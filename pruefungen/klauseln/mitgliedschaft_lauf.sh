#!/usr/bin/env bash
# =====================================================================
# FREIRAUM · Scheibe · Mitgliedschaft aus der Einladung (Blatt 62)
# Klauselpruefung gegen einen LAUFENDEN Server
#
# Geschrieben gegen Blatt 62 (gezeichnet von beiden Foundern, 11.08.2026),
# K03-M11, K20-M05/M18/D02/D05, freiraum_datamodel.sql,
# M30__pilot_sammelmigration.sql und den Schnittstellenvertrag aus dem
# Pruefauftrag -- NICHT gegen den Umsetzungscode. app/einladung_senden.py
# und app/einladung.py kommen in diesem Arbeitsbaum nicht vor; der
# Prueffall kennt den Server nur durch seine Tueren:
#   POST /einladung/senden   (email, anzeigename)   -- wie versand_lauf.sh
#   GET/POST /einladung      (token)                -- wie einloesung_lauf.sh
#   POST /anmeldung          (email, code)          -- wie anmeldung_lauf.sh
#   GET  /                                          -- Startseite
#
# Aufruf:
#   FREIRAUM_CODE_PFEFFER=... \
#   psql ... -f pruefungen/klauseln/mitgliedschaft_daten.sql          # Daten
#   FREIRAUM_PRUEF_URL=http://localhost:8099 \
#   FREIRAUM_CODE_PFEFFER=... \
#   FREIRAUM_PRUEF_MAILFANG=/pfad/zu/gefangenen_mails.txt \
#   pruefungen/klauseln/mitgliedschaft_lauf.sh                        # Faelle
#
# Umgebung:
#   FREIRAUM_PRUEF_URL      Vorgabe http://localhost:8099
#   FREIRAUM_PRUEF_MAILFANG Datei mit den gefangenen Mails -- NUR fuer
#                           MG-09 (der ganze Faden). Ohne sie ist MG-09
#                           GESPERRT, alle anderen Faelle laufen unberuehrt.
#   PGHOST/PGPORT/PGUSER/PGPASSWORD/PGDATABASE
#                           Vorgabe localhost/55433/postgres/pilot/freiraum_pruef
#
# MAILFANG-FORMAT (verbindlich nachgereicht -- vormals offene
# Vertragsstelle, siehe Abschlussbericht des Pruef-Agenten): die Datei
# enthaelt die rohen Zeilen der SMTP-DATA-Phase, also Kopfzeilen, eine
# Leerzeile, dann den Rumpf -- so, wie der Versand sie geschrieben hat.
# Nach jeder Nachricht folgt genau eine Trennzeile
# "--- Ende der Nachricht ---". Mehrere Nachrichten stehen in
# Reihenfolge ihres Eingangs hintereinander. mailfang_token() unten
# liest GENAU dieses Format. Die vormals versuchsweise mitgefuehrten
# Formen (JSON-Zeilen, ein JSON-Array, ungebundener Freitext in
# Absaetzen) sind entfernt: ohne den verbindlichen Vertrag waren sie
# blosse Vermutungen, und ein Fund gegen eine falsche Vermutung misst
# nichts (K23-D05). Findet die Funktion die Mail trotzdem nicht
# eindeutig der Empfaenger-Adresse zugeordnet, faellt MG-09 weiterhin
# auf GESPERRT zurueck statt auf einen falschen Fehlschlag.
#
# ANNAHME aus versand_lauf.sh uebernommen (dort VE-08-Kommentar): die
# Maske /einladung/senden vergibt IMMER EXMA/Plattform-Admin, es gibt
# keine Portalwahl. Alle hier neu eingeladenen Konten werden deshalb
# EXMA-Mitglied -- daran werden die Feldpruefungen der Mitgliedschaft
# gemessen.
#
# MASSSTAB F07: Vor dem ersten Fall wird der AUFBAU geprueft, UND die
# Sitzung wird hergestellt -- ohne sie misst kein einziger Fall dieser
# Scheibe etwas. Gelingt beides nicht, bricht der Lauf mit Rueckgabewert
# 2 ab (ABBRUCH), statt Ergebnisse zu melden, die niemand tragen kann.
#
# ---------------------------------------------------------------------
# NACHGEBESSERT AM 16.08.2026 · DIE ABLAUF-FAMILIE
# ---------------------------------------------------------------------
# MG-08 hat bis zum 15.08.2026 GESPERRT gemeldet, und zwar aus einem
# Grund, der im Fall selbst lag: Er konnte nur dann "bestanden" melden,
# wenn der Zustand ABGELAUFEN in die Einladung geschrieben wurde --
# genau das, was die gezeichnete Klausel K20-M22 im Wortlaut verbietet
# ("Ablauf wird ausschliesslich aus expires_at abgeleitet; kein Lauf
# schreibt ABGELAUFEN"). Ein Fall, dessen Erfolgsweg ein Regelbruch ist,
# kann nichts messen.
#
# MG-08 misst jetzt die ZIELBEDINGUNG statt des Zustands: Eine
# Einladung, deren Frist verstrichen ist, traegt keine Zugangszeile
# mehr -- gleich, welcher Zustand in ihr steht. Fuenf Faelle halten ihn
# ehrlich; jeder von ihnen misst den Zustand VOR der Handlung und weist
# ihn in seiner Ergebniszeile aus:
#
#   MG-10  Die Einladung, deren Frist NOCH LAEUFT, behaelt ihre
#          Zugangszeile. Ohne diesen Gegenhalt bestuende MG-08 auch
#          gegen einen Bau, der einfach alle Zugangszeilen loescht.
#   MG-11  Der Ablauf trifft nur das betroffene Portal: EXMA weg,
#          ENDUSER unveraendert, das Konto bleibt (K20-M19).
#   MG-12  Negativfall an der Frist des Mandanten, mit der Meldung im
#          Wortlaut aus dem Datenmodell -- plus Gegenprobe innerhalb der
#          Frist, damit nicht eine Tuer gemessen wird, die alles ablehnt.
#   MG-13  Der Einladungsplatz bleibt belegt, solange die abgelaufene
#          Einladung auf VERSANDT steht; erst WIDERRUFEN macht ihn frei
#          (K20-D05, K20-M13).
#   MG-14  Der abgelaufene Link wirkt nicht: kein AKTIV, keine Sitzung,
#          kein Einloesezeitpunkt (K20-D10).
#
# REIHENFOLGE IM LAUF: MG-08, dann MG-10 bis MG-14, dann erst MG-09.
# Das ist Absicht, keine Unordnung: MG-10 und MG-14 lesen den Zustand
# UNMITTELBAR nach der einen Handlung von MG-08. Schoebe man MG-09
# dazwischen, laege zwischen Handlung und Messung ein zweiter, ganzer
# Faden -- und es waere nicht mehr belegt, welcher Vorgang was bewirkt
# hat.
#
# EINE AUSNAHME IN DER BERICHTSFOLGE (16.08.2026): MG-14 MISST an seinem
# Platz, MELDET aber als letzter Fall, nach MG-09. Er misst ein
# Ausbleiben, und ein Ausbleiben ist nur dann ein Befund, wenn derselbe
# Vorgang mit einem GUELTIGEN Token nachweislich wirkt -- das belegen
# MG-07 und MG-09. Bestehen die nicht, meldet MG-14 GESPERRT statt
# BESTANDEN. Er sieht das jetzt SELBST nach (ERGEBNISSE/ergebnis()),
# statt sich auf einen Satz im Kommentar zu verlassen.
#
# JEDER dieser Faelle kann scheitern, und keiner besteht durch blosses
# Vorkommen eines Wertes: MG-08/MG-10 und MG-11 messen gegensaetzliche
# Zielbedingungen an derselben Handlung, MG-12 und MG-13 je einen
# abgewiesenen und einen angenommenen Versuch. Eine Antwort, die beide
# Haelften zugleich trivial erfuellt, gibt es in keinem von ihnen.
# =====================================================================

BASIS="${FREIRAUM_PRUEF_URL:-http://localhost:8099}"
MAILFANG="${FREIRAUM_PRUEF_MAILFANG:-}"

: "${PGHOST:=localhost}"
: "${PGPORT:=55433}"
: "${PGUSER:=postgres}"
: "${PGPASSWORD:=pilot}"
: "${PGDATABASE:=freiraum_pruef}"
export PGHOST PGPORT PGUSER PGPASSWORD PGDATABASE

TENANT_ID='00000000-0000-4000-a000-0000000000f1'

ARBEIT="$(mktemp -d "${TMPDIR:-/tmp}/freiraum_mitgliedschaft.XXXXXX")"

gesamt=0; bestanden=0; gescheitert=0; gesperrt=0

# NACHGETRAGEN AM 16.08.2026 fuer MG-14 (siehe dort).
#
# Ein Fall, dessen Aussage vom Bestehen anderer Faelle abhaengt, muss
# das SELBST nachsehen -- sonst meldet er "bestanden" weiter, waehrend
# sein Gegenhalt daneben umgefallen ist. ERGEBNISSE fuehrt darum je
# Fallnamen den gemeldeten Zustand mit. Kein Fall kann sich daraus
# etwas Besseres holen: gelesen wird nur, OB ein anderer Fall bestanden
# hat, und die Antwort kann eine Meldung ausschliesslich verschaerfen
# (BESTANDEN -> GESPERRT), nie mildern.
#
# Kein assoziatives Feld: bash 3.2 (macOS-Vorgabe) kennt keines. Ein
# Feldtrenner '|' je Eintrag genuegt, die Fallnamen enthalten keinen.
ERGEBNISSE=""

# $1 Fallname -> BESTANDEN | GESCHEITERT | GESPERRT | 'NICHT AUSGEFUEHRT'
# Mehrfachmeldungen desselben Namens gaebe es nicht; traeten sie doch
# auf, gilt die LETZTE -- das ist der Zustand, der im Bericht steht.
ergebnis() {
  case "$ERGEBNISSE" in
    *"|$1="*) local rest="${ERGEBNISSE##*|$1=}"; printf '%s' "${rest%%|*}" ;;
    *)        printf 'NICHT AUSGEFUEHRT' ;;
  esac
}

ok()  { gesamt=$((gesamt+1)); bestanden=$((bestanden+1)); ERGEBNISSE="$ERGEBNISSE|$1=BESTANDEN"
        printf '%-7s BESTANDEN    %s\n' "$1" "$2"; }
nok() { gesamt=$((gesamt+1)); gescheitert=$((gescheitert+1)); ERGEBNISSE="$ERGEBNISSE|$1=GESCHEITERT"
        printf '%-7s GESCHEITERT  %s\n' "$1" "$(printf '%s' "$2" | tr '\n' ' ')"; }
# K23-M22: Was nicht gemessen werden konnte, ist GESPERRT -- nicht
# bestanden. In der Summe zaehlt es zu den gescheiterten Faellen, denn
# ein Lauf, der nichts gemessen hat, ist kein gruener Lauf.
sperr() { gesamt=$((gesamt+1)); gescheitert=$((gescheitert+1)); gesperrt=$((gesperrt+1)); ERGEBNISSE="$ERGEBNISSE|$1=GESPERRT"
        printf '%-7s GESPERRT     %s\n' "$1" "$(printf '%s' "$2" | tr '\n' ' ')"; }

# Portal EXMA IMMER auf ENABLED zurueck, egal wie der Lauf endet -- MG-03
# schaltet es fuer K20-D02 kurzzeitig auf PLANNED (derselbe Fehlertyp wie
# der vergessene uvicorn vom 10.08.2026, uebertragen auf Datenzustand).
cleanup() {
  psql -X -tAq -v ON_ERROR_STOP=1 \
       -c "UPDATE portal SET release_status='ENABLED' WHERE code IN ('EXMA','ENDUSER')" \
       >/dev/null 2>&1 || true
  rm -rf "$ARBEIT"
}
trap cleanup EXIT

abbruch() { printf 'ABBRUCH: %s\n' "$1"; printf 'SUMME: 0 von 0 bestanden, 0 gescheitert\n'; exit 2; }

# S1/S3 (14.08.2026, Muster aus pruefungen/klauseln/anmeldecode_lauf.sh
# uebernommen -- dort steht der volle Befund im Dateikopf): db()/dbz()
# fingen bisher nur stdout ab. Schlug die SQL fehl (z.B. eine
# string_agg-Abfrage ohne Spaltenalias -- genau das war hier der Fall,
# siehe die AUFBAUPRUEFUNG unten), blieb stdout leer -- ein
# "[ -z ... ]"-Test las das als "alles in Ordnung". Die Aufbaupruefung
# lief damit blind und meldete zugleich Erfolg.
#
# Ein direkter abbruch()-Aufruf AUS db()/dbz() heraus wirkt nicht: beide
# laufen ueberwiegend in einer Kommandosubstitution ("x=\"\$(dbz ...)\"")
# oder einer Pipe -- ein exit dort beendet nur die Unterschale, nicht den
# Lauf. Neue Bauart: bei einem SQL-Fehler geben beide Funktionen NICHTS
# auf stdout aus, schreiben den psql-Fehlertext nach stderr (sichtbar,
# unabhaengig von Unterschale/Pipe) und legen die Markierungsdatei
# $ARBEIT/sql.marke an. Die Elternschale prueft diese Markierung mit
# pruefe_sql_marke() an den Stellen, an denen ein falscher Wert Schaden
# anrichten wuerde -- dort wirkt exit, weil pruefe_sql_marke NICHT in
# einer Unterschale laeuft. Aufruf mindestens: nach der
# Erreichbarkeitspruefung, nach der Aufbaupruefung und am Ende jedes
# Fallblocks.
db()  { local aus
        if ! aus="$(psql -X -tAq -v ON_ERROR_STOP=1 -c "$1" 2>"$ARBEIT/psql.fehler")"; then
          local fehlertext
          fehlertext="SQL gescheitert: $(tr '\n' ' ' <"$ARBEIT/psql.fehler")"
          printf '%s\n' "$fehlertext" >&2
          printf '%s\n' "$fehlertext" > "$ARBEIT/sql.marke"
          return 1
        fi
        printf '%s\n' "$aus"; }
dbz() { local aus
        if ! aus="$(psql -X -tAq -v ON_ERROR_STOP=1 -c "$1" 2>"$ARBEIT/psql.fehler")"; then
          local fehlertext
          fehlertext="SQL gescheitert: $(tr '\n' ' ' <"$ARBEIT/psql.fehler")"
          printf '%s\n' "$fehlertext" >&2
          printf '%s\n' "$fehlertext" > "$ARBEIT/sql.marke"
          return 1
        fi
        # BERICHTIGT AM 14.08.2026, gemessen: "printf '%s'" laesst den
        # Zeilenumbruch weg. Die Fassung davor leitete psql direkt durch
        # ("psql ... | head -1") und gab ihn mit aus. Jeder Fall, der mit
        # "| wc -l" zaehlt, bekam dadurch 0 statt 1 -- AN-07 und AN-08
        # meldeten "keine Zeile in auth_session" und sperrten, obwohl die
        # Zeile existierte. Eine leere Ausgabe bleibt leer, wie vorher.
        [ -n "$aus" ] || return 0
        printf '%s\n' "$aus" | head -1; }

# Wird direkt in der Elternschale aufgerufen (NIE in einer Kommando-
# substitution) -- nur dort beendet abbruch()s exit den ganzen Lauf.
pruefe_sql_marke() {
  if [ -s "$ARBEIT/sql.marke" ]; then
    abbruch "$(cat "$ARBEIT/sql.marke")"
  fi
}

# NACHGETRAGEN AM 16.08.2026 fuer die Negativfaelle MG-12 und MG-13.
#
# WARUM NICHT db(): db() legt bei jedem SQL-Fehler die Markierungsdatei
# an, und pruefe_sql_marke() bricht daraufhin den ganzen Lauf ab. Fuer
# einen Negativfall ist der Fehler aber das ERWARTETE Ergebnis -- ein
# Abbruch waere dort gerade der Fehler.
#
# db_versuch() fuehrt eine Anweisung aus, die scheitern DARF, ruehrt die
# Markierungsdatei NICHT an und gibt IMMER den Meldungstext von psql auf
# stdout aus -- einzeilig, damit er unveraendert in die Ergebniszeile
# zitiert werden kann (Bauauftrag §9 Tor I Nr. 6: die Fehlermeldung im
# Wortlaut ist Teil des Belegs).
#   Rueckgabewert 0 = die Anweisung ist DURCHGELAUFEN
#   Rueckgabewert 1 = die Anweisung ist GESCHEITERT
db_versuch() {
  local aus rc
  if aus="$(psql -X -tAq -v ON_ERROR_STOP=1 -c "$1" 2>&1)"; then rc=0; else rc=1; fi
  printf '%s' "$(printf '%s' "$aus" | tr '\n' ' ')"
  return "$rc"
}

# ---------------------------------------------------------------------
# Werkzeug
# ---------------------------------------------------------------------
saeubere_kopf() { tr -d '\r' < "$1" > "$1.rein" && mv "$1.rein" "$1"; }

hole() {             # $1 pfad  $2 name  [$3 cookiewert]
  local p="$ARBEIT/$2" st ex=()
  [ -n "${3:-}" ] && ex=(-H "Cookie: fr_sitzung=$3")
  st=$(curl -sS -o "$p.rumpf" -D "$p.kopf" -w '%{http_code}' --max-time 25 \
        ${ex[@]+"${ex[@]}"} "$BASIS$1" 2>"$p.fehler") || st="000"
  [ -f "$p.kopf" ] && saeubere_kopf "$p.kopf"
  printf '%s' "$st"
}

post_anmeldung() {   # $1 email  $2 code  $3 name
  local p="$ARBEIT/$3" st
  st=$(curl -sS -o "$p.rumpf" -D "$p.kopf" -w '%{http_code}' --max-time 25 \
        --data-urlencode "email=$1" --data-urlencode "code=$2" \
        "$BASIS/anmeldung" 2>"$p.fehler") || st="000"
  [ -f "$p.kopf" ] && saeubere_kopf "$p.kopf"
  printf '%s' "$st"
}

post_einladung_senden() {   # $1 email  $2 anzeigename  $3 name  [$4 cookiewert]
  local p="$ARBEIT/$3" st ex=()
  [ -n "${4:-}" ] && ex=(-H "Cookie: fr_sitzung=$4")
  st=$(curl -sS -o "$p.rumpf" -D "$p.kopf" -w '%{http_code}' --max-time 25 \
        ${ex[@]+"${ex[@]}"} \
        --data-urlencode "email=$1" --data-urlencode "anzeigename=$2" \
        "$BASIS/einladung/senden" 2>"$p.fehler") || st="000"
  [ -f "$p.kopf" ] && saeubere_kopf "$p.kopf"
  printf '%s' "$st"
}

post_einladung_einloesen() {   # $1 token  $2 name
  local p="$ARBEIT/$2" st
  st=$(curl -sS -o "$p.rumpf" -D "$p.kopf" -w '%{http_code}' --max-time 25 \
        --data-urlencode "token=$1" \
        "$BASIS/einladung" 2>"$p.fehler") || st="000"
  [ -f "$p.kopf" ] && saeubere_kopf "$p.kopf"
  printf '%s' "$st"
}

kopfzeile()    { grep -i "^$2:" "$ARBEIT/$1.kopf" 2>/dev/null | head -1 \
                 | sed "s/^[^:]*:[[:space:]]*//"; }
sitzungswert() { grep -i '^set-cookie:[[:space:]]*fr_sitzung=' "$ARBEIT/$1.kopf" 2>/dev/null | head -1 \
                 | sed 's/^[^=]*=//' | cut -d';' -f1; }
sitzungszahl() { [ -f "$ARBEIT/$1.kopf" ] || { printf '0'; return; }
                 grep -ic '^set-cookie:[[:space:]]*fr_sitzung=' "$ARBEIT/$1.kopf"; }
rumpf()        { printf '%s' "$ARBEIT/$1.rumpf"; }

# Die einzige Stelle, an der die Extraktion des Einladungslinks aus der
# gefangenen Mail geschieht -- gegen das jetzt verbindliche Mailfang-
# Format (siehe Kopf dieser Datei): rohe SMTP-DATA-Zeilen je Nachricht
# (Kopfzeilen, eine Leerzeile, Rumpf), Nachrichten in Reihenfolge ihres
# Eingangs hintereinander, je durch die Zeile
# "--- Ende der Nachricht ---" getrennt.
# $1 Pfad zur Mailfang-Datei, $2 Empfaengeradresse.
# Ausgabe: der Klartext-Token auf stdout.
# Rueckgabewert: 0 = eindeutig der Adresse zugeordnet gefunden,
#                3 = ein Token gefunden, aber in KEINER Nachricht, deren
#                    Kopfzeilen die Adresse nennen,
#                2 = kein Treffer,  1 = Datei nicht lesbar.
mailfang_token() {
  python3 - "$1" "$2" <<'PY'
import re, sys

pfad, empfaenger = sys.argv[1], sys.argv[2].lower()
try:
    text = open(pfad, encoding="utf-8", errors="replace").read()
except OSError:
    sys.exit(1)
text = text.replace('\r\n', '\n')

# Nachrichten trennen: jede endet mit der Zeile
# "--- Ende der Nachricht ---" fuer sich allein.
trenner = re.compile(r'^[ \t]*---[ \t]*Ende der Nachricht[ \t]*---[ \t]*\n?', re.MULTILINE)
nachrichten = [n for n in trenner.split(text) if n.strip()]

muster = re.compile(r'token=([A-Za-z0-9_\-\.]{6,})')
kandidat = None
token_irgendwo_gesehen = False

# Je Nachricht: Kopfzeilen vor der ersten Leerzeile, Rumpf danach.
# Zugeordnet wird ausschliesslich ueber die Kopfzeilen -- ein Treffer im
# Rumpf einer FREMDEN Nachricht (z.B. weil die Adresse dort zufaellig
# als Text vorkommt) zaehlt nicht als Zuordnung. Stehen mehrere
# Nachrichten an dieselbe Adresse in der Datei (z.B. nach einem
# erneuten Versand), gewinnt die LETZTE -- die Nachrichten stehen nach
# Vertrag in Reihenfolge ihres Eingangs.
for nachricht in nachrichten:
    teile = re.split(r'\n[ \t]*\n', nachricht, maxsplit=1)
    kopf = teile[0]
    rumpf = teile[1] if len(teile) == 2 else ''
    treffer = muster.findall(rumpf) or muster.findall(kopf)
    if treffer:
        token_irgendwo_gesehen = True
        if empfaenger in kopf.lower():
            kandidat = treffer[-1]

if kandidat is None:
    sys.exit(3 if token_irgendwo_gesehen else 2)
print(kandidat)
sys.exit(0)
PY
}

freier_port() { python3 -c 'import socket;s=socket.socket();s.bind(("127.0.0.1",0));print(s.getsockname()[1]);s.close()'; }

# ---------------------------------------------------------------------
# Vorpruefung: Werkzeug, Server, Datenlage
# ---------------------------------------------------------------------
command -v curl    >/dev/null 2>&1 || abbruch 'curl fehlt.'
command -v psql    >/dev/null 2>&1 || abbruch 'psql fehlt.'
command -v python3 >/dev/null 2>&1 || abbruch 'python3 fehlt (Mailfang-Extraktion MG-09, freier Port).'

# S3 (14.08.2026, aus anmeldecode_lauf.sh uebernommen): kein "2>&1" mehr auf
# diesen Aufruf -- das wuerde die eigene Diagnosemeldung von db() (jetzt auf
# stderr) mit demselben ">/dev/null" verschlucken, das nur den psql-Aufruf
# selbst stummschalten soll. Eine nicht erreichbare Datenbank endete
# dadurch STUMM; jetzt steht ein Satz da (Diagnose von db() plus der
# nachgestellte abbruch()-Text).
db 'SELECT 1' >/dev/null || abbruch "Datenbank $PGDATABASE auf $PGHOST:$PGPORT nicht erreichbar."
pruefe_sql_marke

[ -n "${FREIRAUM_CODE_PFEFFER:-}" ] || abbruch 'FREIRAUM_CODE_PFEFFER ist nicht gesetzt -- derselbe Wert wie am Server ist noetig, sonst stimmt kein Pruefwert (F07).'
case "$FREIRAUM_CODE_PFEFFER" in *"'"*) abbruch "FREIRAUM_CODE_PFEFFER enthaelt ein Hochkomma; das Pruefskript kann es nicht sicher in SQL setzen.";; esac

if [ "$(hole /gesundheit vorpruefung)" != "200" ]; then
  abbruch "Server unter $BASIS antwortet nicht auf GET /gesundheit. Erst starten, dann pruefen."
fi

lage="$(dbz "SELECT count(*) FROM pg_views WHERE viewname='pruef_mitgliedschaft_lage'")"
# S3 (14.08.2026): schlaegt dbz() hier fehl, ist $lage leer -- ohne diese
# Pruefung wuerde das faelschlich als "Sicht fehlt" statt mit dem echten
# SQL-Fehler gemeldet.
pruefe_sql_marke
[ "$lage" = "1" ] || abbruch 'Sicht pruef_mitgliedschaft_lage fehlt -- mitgliedschaft_daten.sql zuerst einspielen.'

# AUFBAUPRUEFUNG (F07): dieselben Bedingungen wie in mitgliedschaft_daten.sql,
# hier aber unmittelbar vor dem Lauf.
#
# S1 (14.08.2026, BEFUND, derselbe Fehlertyp wie in versand_lauf.sh Zeile
# ~137): KEINE der elf Teilabfragen trug einen Spaltenalias. Die
# Ergebnisspalte hiess damit "?column?", string_agg(m, ' ') griff auf eine
# Spalte, die es so nicht gab, psql brach mit "column \"m\" does not
# exist" ab, und die UNGEHAERTETE dbz() (siehe Haertung oben) hat diesen
# Fehler bis zu diesem Fund verschluckt: leeres stdout, "[ -z "$aufbau" ]"
# las das als "alles in Ordnung". Die Aufbaupruefung lief damit blind und
# meldete zugleich Erfolg. Jetzt: Alias "AS m" an jeder Teilabfrage.
aufbau="$(dbz "
SELECT string_agg(m, ' ') FROM (
  SELECT 'bootstrapadmin:' || status || '/' || mitgliedschaft_exma AS m FROM pruef_mitgliedschaft_lage
   WHERE email='bootstrapadmin@pruef.example' AND (status<>'AKTIV' OR mitgliedschaft_exma<1)
  UNION ALL
  SELECT 'einladend:' || status || '/' || mitgliedschaft_exma || '/' || offene_codes AS m FROM pruef_mitgliedschaft_lage
   WHERE email='einladend@pruef.example' AND (status<>'AKTIV' OR mitgliedschaft_exma<1 OR offene_codes<>1)
  UNION ALL
  SELECT 'mg_wiederholt:' || status || '/' || einladungen_offen || '/' || coalesce(attempt_max::text,'-') || '/' || mitgliedschaft_exma AS m
    FROM pruef_mitgliedschaft_lage
   WHERE email='mg_wiederholt@pruef.example'
     AND (status<>'WARTET_2FA' OR einladungen_offen<>1 OR coalesce(attempt_max,-1)<>1 OR mitgliedschaft_exma<>1)
  UNION ALL
  SELECT 'mg_aktiv:' || status || '/' || einladungen_eingeloest || '/' || mitgliedschaft_exma AS m FROM pruef_mitgliedschaft_lage
   WHERE email='mg_aktiv@pruef.example' AND (status<>'AKTIV' OR einladungen_eingeloest<>1 OR mitgliedschaft_exma<>1)
  UNION ALL
  SELECT 'mg_bereitsmitglied:' || status || '/' || einladungen_offen || '/' || mitgliedschaft_exma AS m FROM pruef_mitgliedschaft_lage
   WHERE email='mg_bereitsmitglied@pruef.example' AND (status<>'WARTET_2FA' OR einladungen_offen<>1 OR mitgliedschaft_exma<>1)
  UNION ALL
  SELECT 'mg_abgelaufen:' || status || '/' || mitgliedschaft_exma || '/frist_um=' || einladungen_frist_verstrichen AS m
    FROM pruef_mitgliedschaft_lage
   WHERE email='mg_abgelaufen@pruef.example'
     AND (status<>'WARTET_2FA' OR mitgliedschaft_exma<>1 OR einladungen_frist_verstrichen<>1)
  UNION ALL
  -- NACHGETRAGEN 16.08.2026 · die vier Ausgangslagen der neuen Ablauf-Familie.
  SELECT 'mg_nichtabgelaufen:' || status || '/' || mitgliedschaft_exma || '/frist_laeuft=' || einladungen_frist_laeuft AS m
    FROM pruef_mitgliedschaft_lage
   WHERE email='mg_nichtabgelaufen@pruef.example'
     AND (status<>'WARTET_2FA' OR mitgliedschaft_exma<>1
          OR einladungen_frist_laeuft<>1 OR einladungen_frist_verstrichen<>0)
  UNION ALL
  SELECT 'mg_portalablauf:' || mitgliedschaft_exma || '/' || mitgliedschaft_enduser || '/frist_um=' || einladungen_frist_verstrichen AS m
    FROM pruef_mitgliedschaft_lage
   WHERE email='mg_portalablauf@pruef.example'
     AND (mitgliedschaft_exma<>1 OR mitgliedschaft_enduser<>1
          OR mitgliedschaften_gesamt<>2 OR einladungen_frist_verstrichen<>1)
  UNION ALL
  SELECT 'mg_frist_nicht_leer:' || einladungen_gesamt || '/' || mitgliedschaften_gesamt AS m
    FROM pruef_mitgliedschaft_lage
   WHERE email='mg_frist@pruef.example'
     AND (einladungen_gesamt<>0 OR mitgliedschaften_gesamt<>0)
  UNION ALL
  SELECT 'mg_platz:' || einladungen_gesamt || '/frist_um=' || einladungen_frist_verstrichen AS m
    FROM pruef_mitgliedschaft_lage
   WHERE email='mg_platz@pruef.example'
     AND (einladungen_gesamt<>1 OR einladungen_frist_verstrichen<>1)
  UNION ALL
  -- Die Teilabfragen oben schweigen, wenn ein Konto GAR NICHT existiert
  -- (kein Treffer, keine Meldung). Diese Zeile schliesst die Luecke: sie
  -- zaehlt die vier neuen Konten und meldet, wenn eines fehlt.
  SELECT 'ablauf_familie_unvollstaendig:' || count(*)::text || ' von 4' AS m FROM actor
   WHERE email IN ('mg_nichtabgelaufen@pruef.example','mg_portalablauf@pruef.example',
                   'mg_frist@pruef.example','mg_platz@pruef.example')
  HAVING count(*) <> 4
  UNION ALL
  SELECT 'mg_zweitportal:' || status || '/' || mitgliedschaft_exma || '/' || mitgliedschaft_enduser || '/' || offene_codes AS m
    FROM pruef_mitgliedschaft_lage
   WHERE email='mg_zweitportal@pruef.example'
     AND (status<>'AKTIV' OR mitgliedschaft_exma<>1 OR mitgliedschaft_enduser<>1 OR offene_codes<>1)
  UNION ALL
  SELECT 'dynamisches_fallziel_existiert_schon' AS m FROM actor
   WHERE email IN ('mg_neu@pruef.example','mg_geplant@pruef.example','mg_faden@pruef.example')
  UNION ALL
  SELECT 'portal_exma:' || release_status AS m FROM portal WHERE code='EXMA' AND release_status<>'ENABLED'
  UNION ALL
  SELECT 'portal_enduser:' || release_status AS m FROM portal WHERE code='ENDUSER' AND release_status<>'ENABLED'
  UNION ALL
  SELECT 'tenant_domaene_oder_frist_falsch' AS m FROM tenant
   WHERE id='$TENANT_ID' AND (invite_domain IS DISTINCT FROM 'pruef.example' OR invite_ttl_hours<>24)
) t")"
# S3 (14.08.2026): schlaegt dbz() hier fehl, ist $aufbau leer -- ohne diese
# Pruefung wuerde das faelschlich als "Aufbau in Ordnung" durchgehen (der
# urspruengliche S1-Befund, nur an dieser Stelle).
pruefe_sql_marke
[ -z "$aufbau" ] || abbruch "Datenlage taugt nicht (F07): $aufbau -- mitgliedschaft_daten.sql neu einspielen."

# ---------------------------------------------------------------------
# Sitzung herstellen. Ohne sie ist JEDER Fall dieser Scheibe GESPERRT
# -- deshalb ABBRUCH (Rueckgabewert 2), nicht GESPERRT je Fall.
# ---------------------------------------------------------------------
st=$(post_anmeldung 'einladend@pruef.example' '700001' anmeldung)
KEKS="$(sitzungswert anmeldung)"
if [ "$st" != "303" ] || [ -z "$KEKS" ]; then
  abbruch "Sitzungsaufbau (Anmeldung als einladend@pruef.example) schlaegt fehl: Status $st, Cookie '${KEKS:-leer}'. Ohne Sitzung misst kein Fall dieser Scheibe etwas."
fi

# Die EXMA-Rolle und ihre id -- fuer die Feldpruefungen der Mitgliedschaft
# (membership.role_id = "die eine Rolle dieses Portals").
EXMA_ROLLE="$(dbz "SELECT id FROM role WHERE portal_code='EXMA'")"
pruefe_sql_marke  # S3 (14.08.2026): ein SQL-Fehler hier darf nicht als "keine Rolle" durchgehen.
[ -n "$EXMA_ROLLE" ] || abbruch 'Portal EXMA traegt keine Rolle -- ohne sie ist role_id nicht pruefbar (siehe Aufbaupruefung).'

printf 'FREIRAUM · Scheibe · Mitgliedschaft aus der Einladung — Klauselpruefung gegen %s\n' "$BASIS"
printf 'Datenlage: %s auf %s:%s · Aufbaupruefung (F07) bestanden · Sitzung als einladend@pruef.example steht\n\n' \
       "$PGDATABASE" "$PGHOST" "$PGPORT"

# =====================================================================
# MG-01 · POSITIVKONTROLLE · Vertrag Kernsatz + K20-M05
#         "Beim Versand entsteht zusaetzlich genau eine Mitgliedschaft":
#         actor_id = das eingeladene Konto, portal_code = invitation.
#         portal_code, role_id = die eine Rolle dieses Portals,
#         tenant_scope = actor.tenant_id des eingeladenen Kontos. In
#         derselben Transaktion wie die Einladung. Ein Regime, das nie
#         eine Mitgliedschaft anlegt, bestuende jeden Negativtest dieser
#         Scheibe -- ohne diesen Fall waeren MG-05..MG-09 wertlos.
# =====================================================================
st=$(post_einladung_senden 'mg_neu@pruef.example' 'Pruef MG Neu' mg01 "$KEKS")
ziel="$(kopfzeile mg01 location)"
m=""
[ "$st" = "303" ] || m="$m Status $st statt 303;"
case "$ziel" in */einladung/senden\?gesendet=1) : ;; \
                *) m="$m Location '$ziel' zeigt nicht auf /einladung/senden?gesendet=1;";; esac

MG01_INVID="$(dbz "SELECT id FROM invitation WHERE mail='mg_neu@pruef.example' AND status='VERSANDT'")"
MG01_AKTID="$(dbz "SELECT id FROM actor WHERE email='mg_neu@pruef.example'")"
if [ -z "$MG01_INVID" ] || [ -z "$MG01_AKTID" ]; then
  m="$m keine Einladung/kein Konto fuer mg_neu@pruef.example entstanden;"
else
  portal="$(dbz "SELECT portal_code FROM invitation WHERE id='$MG01_INVID'")"
  [ "$portal" = "EXMA" ] || m="$m invitation.portal_code ist '$portal' statt EXMA;"

  akt_tenant="$(dbz "SELECT tenant_id FROM actor WHERE id='$MG01_AKTID'")"
  mzahl="$(dbz "SELECT count(*) FROM membership WHERE actor_id='$MG01_AKTID'")"
  [ "${mzahl:-0}" = "1" ] || m="$m es bestehen $mzahl Mitgliedschaften statt genau einer (K20-M05);"

  if [ "${mzahl:-0}" = "1" ]; then
    zeile="$(dbz "SELECT portal_code || '|' || role_id || '|' || tenant_scope
                    FROM membership WHERE actor_id='$MG01_AKTID'")"
    mportal="${zeile%%|*}"
    rest="${zeile#*|}"
    mrole="${rest%%|*}"
    mtenant="${rest#*|}"
    [ "$mportal" = "EXMA" ]        || m="$m membership.portal_code ist '$mportal' statt EXMA (Vertrag);"
    [ "$mrole" = "$EXMA_ROLLE" ]   || m="$m membership.role_id ist '$mrole' statt der einen EXMA-Rolle '$EXMA_ROLLE' (Vertrag);"
    [ "$mtenant" = "$akt_tenant" ] || m="$m membership.tenant_scope ist '$mtenant' statt actor.tenant_id '$akt_tenant' (Vertrag);"
  fi
fi
[ -z "$m" ] && ok MG-01 'Versand legt genau eine Mitgliedschaft an: actor_id/portal_code/role_id/tenant_scope wie im Vertrag benannt (Vertrag Kernsatz, K20-M05)' \
            || nok MG-01 "Positivfall Mitgliedschaft beim Versand:$m"
pruefe_sql_marke  # S3 (14.08.2026): am Ende jedes Fallblocks, siehe Haertung von db()/dbz() oben.

# =====================================================================
# MG-02 · K20-M18 · Nachweiszeile mit Zeitpunkt und HANDELNDER Instanz
#         -- die Einladende (einladend@), NICHT der Eingeladene
#         (mg_neu@). object_ref in der Form ART:<...> (Blatt 60 B).
#         Haengt an MG-01.
# =====================================================================
if [ -z "$MG01_INVID" ] || [ -z "$MG01_AKTID" ]; then
  sperr MG-02 'Nachweis nicht pruefbar: MG-01 hat keine Einladung/kein Konto erzeugt'
else
  form_ok="$(dbz "SELECT count(*) FROM event
                    WHERE occurred_at IS NOT NULL
                      AND object_ref ~ '^[A-Z][A-Z_]*:'
                      AND (object_ref LIKE '%$MG01_INVID%' OR object_ref LIKE '%$MG01_AKTID%')")"
  kennzeichnung="$(dbz "SELECT coalesce(a.email,'') || '|' || coalesce(e.actor_label,'')
                          FROM event e LEFT JOIN actor a ON a.id = e.actor_id
                         WHERE object_ref ~ '^[A-Z][A-Z_]*:'
                           AND (object_ref LIKE '%$MG01_INVID%' OR object_ref LIKE '%$MG01_AKTID%')
                         ORDER BY e.occurred_at DESC LIMIT 1")"
  m=""
  if [ "${form_ok:-0}" -lt 1 ]; then
    m="$m keine Nachweiszeile mit object_ref in der Form ART:<...> zur Einladung/zum Konto gefunden;"
  else
    case "$kennzeichnung" in
      *einladend@pruef.example*|*'Pruef Einladend'*) : ;;
      *) m="$m die handelnde Instanz im Nachweis identifiziert nicht einladend@pruef.example (Kennzeichnung: '$kennzeichnung');" ;;
    esac
    case "$kennzeichnung" in
      *mg_neu@pruef.example*|*'Pruef MG Neu'*)
        m="$m die handelnde Instanz nennt den EINGELADENEN statt den Einladenden (K20-M18 verlangt die Sitzung);" ;;
    esac
  fi
  [ -z "$m" ] && ok MG-02 "Nachweiszeile zur Mitgliedschaftsanlage traegt Zeitpunkt, object_ref in der Form ART:<...> und die Sitzung (einladend@) als handelnde Instanz (K20-M18, Blatt 60 B)" \
              || nok MG-02 "Nachweis:$m"
fi
pruefe_sql_marke  # S3 (14.08.2026): am Ende jedes Fallblocks, siehe Haertung von db()/dbz() oben.

# =====================================================================
# MG-03 · K20-D02 · Portal EXMA auf PLANNED: keine Einladung, KEINE
#         Mitgliedschaft. Gegenprobe: MG-01 (EXMA ENABLED, derselbe
#         Vorgang legt Einladung UND Mitgliedschaft an).
#
#         Berichtigung C (Blatt 63, 11.08.2026 -- derselbe Fehlertyp und
#         dieselbe Loesung wie VE-08 in versand_lauf.sh, Blatt 60):
#         beide zulaessigen Ausgaenge sind 303 -- Erfolg (?gesendet=1)
#         UND Sitzungsabbruch (/anmeldung). Steht EXMA auf PLANNED,
#         findet die Portalbestimmung kein freigeschaltetes Portal, und
#         DAS BEENDET DIE SITZUNG des Einladenden (nicht nur diesen
#         Aufruf) -- fail-closed landet der Aufruf mit 303 auf
#         /anmeldung, exakt das vom Vertrag gedeckte Verhalten ("Ohne
#         gueltige Sitzung -> 303 auf /anmeldung"). Der Statuscode
#         allein unterscheidet die beiden Ausgaenge darum NICHT;
#         unterschieden wird am Location-Kopf. Gemessen werden weiter
#         GENAU DIESELBEN Kernbedingungen wie vorher -- (1) keine
#         Einladung, (2) keine Mitgliedschaft -- nur der Statuscheck ist
#         jetzt zielgenau statt pauschal.
# =====================================================================
db "UPDATE portal SET release_status='PLANNED' WHERE code='EXMA'" >/dev/null
st=$(post_einladung_senden 'mg_geplant@pruef.example' 'Pruef MG Geplant' mg03 "$KEKS")
ziel="$(kopfzeile mg03 location)"
db "UPDATE portal SET release_status='ENABLED' WHERE code='EXMA'" >/dev/null
inv_entstanden="$(dbz "SELECT count(*) FROM invitation WHERE mail='mg_geplant@pruef.example'")"
mit_entstanden="$(dbz "SELECT count(*) FROM membership m JOIN actor a ON a.id=m.actor_id
                        WHERE a.email='mg_geplant@pruef.example'")"
m=""
[ "${inv_entstanden:-1}" = "0" ] || m="$m es entstand eine Einladung, obwohl EXMA auf PLANNED stand;"
[ "${mit_entstanden:-1}" = "0" ] || m="$m es entstand eine Mitgliedschaft, obwohl EXMA auf PLANNED stand (K20-D02);"
[ "$st" = "303" ] || m="$m Status $st statt 303 (beide zulaessigen Ausgaenge -- Erfolg wie Sitzungsabbruch -- sind 303);"
case "$ziel" in
  */einladung/senden\?gesendet=1)
    m="$m die Antwort fuehrt auf die Erfolgsseite ?gesendet=1, obwohl EXMA auf PLANNED stand (K20-D02);" ;;
  *"/anmeldung"*)
    : ;;  # fail-closed: keine gueltige Sitzung mangels freigeschaltetem Portal -> 303 auf /anmeldung, vom Vertrag gedeckt
  *)
    m="$m Location '$ziel' ist weder die Erfolgsseite noch /anmeldung -- kein vom Vertrag gedeckter Ausgang;" ;;
esac
[ -z "$m" ] && ok MG-03 "Portal EXMA auf PLANNED: keine Einladung und keine Mitgliedschaft entstehen, die Antwort fuehrt nicht auf die Erfolgsseite (K20-D02; Location: '$ziel', Berichtigung Blatt 63 C)" \
            || nok MG-03 "PLANNED-Portal:$m"
pruefe_sql_marke  # S3 (14.08.2026): am Ende jedes Fallblocks, siehe Haertung von db()/dbz() oben.

# =====================================================================
# Sitzung NEU herstellen -- MG-03 hat das Portal EXMA kurzzeitig auf
# PLANNED geschaltet. Die Portalbestimmung fand daraufhin kein
# freigeschaltetes Portal, und DAS BEENDET DIE SITZUNG des Einladenden
# dauerhaft, nicht nur den einzelnen Aufruf (BEFUND S-1, 10.08.2026:
# eine Sperre sperrt AUS, sie haengt nicht aus -- fuer ein
# abgeschaltetes Portal gilt nach Blatt 63 C dieselbe Folge). $KEKS ist
# ab hier wertlos. Jeder Fall unterhalb, der die Sitzung des
# Einladenden weiter braucht (MG-05, MG-06, MG-09), meldet sich NEU an
# -- sonst liefe er, wie bis zur Berichtigung gemessen, ins Leere
# (Location /anmeldung statt der eigentlich geprueften Bedingung).
# Bleibt die Neuanmeldung selbst erfolglos, wird $KEKS auf leer
# gesetzt; die betroffenen Faelle melden dann GESPERRT statt an einer
# falschen Bedingung zu scheitern (F07).
# =====================================================================
db "INSERT INTO login_code (actor_id, code_hash, issued_at, expires_at)
    SELECT id, pruef_codewert('700002', '$FREIRAUM_CODE_PFEFFER'), now(), now() + interval '10 minutes'
      FROM actor WHERE email = 'einladend@pruef.example'" >/dev/null
st=$(post_anmeldung 'einladend@pruef.example' '700002' anmeldung_neu)
KEKS="$(sitzungswert anmeldung_neu)"
if [ "$st" != "303" ] || [ -z "$KEKS" ]; then
  KEKS=""
fi
pruefe_sql_marke  # S3 (14.08.2026): am Ende jedes Fallblocks, siehe Haertung von db()/dbz() oben.

# =====================================================================
# MG-04 · K03-M11 · "genau ein Portal, bestimmt ueber membership. Genau
#         eines -- nicht das erste von mehreren." mg_zweitportal@ traegt
#         zwei Mitgliedschaften in zwei freigeschalteten Portalen, eine
#         davon aus der Einladung entstanden (wie MG-01 belegt). Zulaessig
#         ist Ablehnung ODER genau ein Portal -- niemals zwei Sitzungen.
# =====================================================================
db "DELETE FROM auth_session WHERE actor_id=(SELECT id FROM actor WHERE email='mg_zweitportal@pruef.example');" >/dev/null
st=$(post_anmeldung 'mg_zweitportal@pruef.example' '700004' mg04)
zahl="$(sitzungszahl mg04)"
keks04="$(sitzungswert mg04)"
sitzungen="$(dbz "SELECT count(*) FROM auth_session s JOIN actor a ON a.id=s.actor_id
                   WHERE a.email='mg_zweitportal@pruef.example' AND s.ended_at IS NULL")"
m=""
[ "$zahl" -le 1 ] || m="$m die Antwort setzt $zahl Cookies fr_sitzung;"
[ "${sitzungen:-0}" -le 1 ] || m="$m es entstanden $sitzungen offene Sitzungen aus einer Anmeldung;"
if [ "$st" = "303" ]; then
  [ -n "$keks04" ] || m="$m 303 ohne Cookie fr_sitzung;"
  if [ -n "$keks04" ]; then
    st2=$(hole / mg04b "$keks04")
    [ "$st2" = "200" ] || m="$m GET / mit der Sitzung liefert $st2 statt 200;"
  fi
elif [ "$st" = "200" ]; then
  [ -z "$keks04" ] || m="$m Ablehnung mit Cookie;"
else
  m="$m unerwarteter Status $st;"
fi
[ -z "$m" ] && ok MG-04 'Mitgliedschaft in zwei freigeschalteten Portalen (eine davon ueber die Einladung entstanden): die Anmeldung oeffnet hoechstens eines (K03-M11)' \
            || nok MG-04 "Zwei Portale:$m"
pruefe_sql_marke  # S3 (14.08.2026): am Ende jedes Fallblocks, siehe Haertung von db()/dbz() oben.

# =====================================================================
# MG-05 · SHARP POINT 1 · K20-M13 + K20-D05 + Vertrag: der erneute
#         Versand darf nicht zwei Mitgliedschaftszeilen hinterlassen und
#         auch nicht null. Er widerruft die alte Einladung (Mitgliedschaft
#         weg) und legt eine neue an (Mitgliedschaft wieder da). Danach
#         muss GENAU EINE bestehen -- der Primaerschluessel ist
#         (actor_id, portal_code, role_id, tenant_scope).
# =====================================================================
MG05_AKTID="$(dbz "SELECT id FROM actor WHERE email='mg_wiederholt@pruef.example'")"
alte_id="$(dbz "SELECT id FROM invitation WHERE actor_id='$MG05_AKTID' AND status='VERSANDT'")"
alter_attempt="$(dbz "SELECT attempt FROM invitation WHERE id='$alte_id'")"
mzahl_vor="$(dbz "SELECT count(*) FROM membership WHERE actor_id='$MG05_AKTID'")"
if [ -z "$KEKS" ]; then
  sperr MG-05 "Erneuter Versand nicht pruefbar: die Sitzung des Einladenden liess sich nach MG-03 nicht neu herstellen"
elif [ -z "$alte_id" ] || [ -z "$alter_attempt" ] || [ "${mzahl_vor:-0}" != "1" ]; then
  sperr MG-05 "Erneuter Versand nicht pruefbar: die vorbereitete offene Einladung oder ihre Mitgliedschaft fuer mg_wiederholt@ fehlt (mzahl_vor=${mzahl_vor:-?})"
else
  st=$(post_einladung_senden 'mg_wiederholt@pruef.example' 'Pruef MG Wiederholt Erneut' mg05 "$KEKS")
  ziel="$(kopfzeile mg05 location)"
  m=""
  [ "$st" = "303" ] || m="$m Status $st statt 303;"
  case "$ziel" in */einladung/senden\?gesendet=1) : ;; \
                  *) m="$m Location '$ziel' zeigt nicht auf /einladung/senden?gesendet=1;";; esac

  alter_status_danach="$(dbz "SELECT status FROM invitation WHERE id='$alte_id'")"
  offene_danach="$(dbz "SELECT count(*) FROM invitation WHERE actor_id='$MG05_AKTID' AND status='VERSANDT'")"
  neuer_attempt="$(dbz "SELECT max(attempt) FROM invitation WHERE actor_id='$MG05_AKTID' AND status='VERSANDT'")"
  mzahl_danach="$(dbz "SELECT count(*) FROM membership WHERE actor_id='$MG05_AKTID'")"

  case "$alter_status_danach" in
    WIDERRUFEN) : ;;
    ABGELAUFEN|EINGELOEST) m="$m die alte Einladung wurde auf $alter_status_danach gesetzt statt WIDERRUFEN -- K20-D05 verbietet genau diesen Weg;" ;;
    *) m="$m die alte Einladung steht auf '$alter_status_danach' statt WIDERRUFEN;" ;;
  esac
  if [ -n "$neuer_attempt" ] && [ "$neuer_attempt" -eq $((alter_attempt + 1)) ]; then :
  else m="$m attempt ist '$neuer_attempt' statt $((alter_attempt + 1)) (K20-M13);"
  fi
  [ "$offene_danach" = "1" ] || m="$m es bestehen $offene_danach offene Einladungen statt genau einer (K20-M12);"

  # DER KERN dieses Falls: weder 0 noch 2 Mitgliedschaften.
  [ "${mzahl_danach:-0}" = "1" ] || m="$m es bestehen $mzahl_danach Mitgliedschaften nach dem erneuten Versand statt genau einer (Sharp Point 1, Blatt 62);"
  if [ "${mzahl_danach:-0}" = "1" ]; then
    zeile="$(dbz "SELECT portal_code || '|' || role_id || '|' || tenant_scope
                    FROM membership WHERE actor_id='$MG05_AKTID'")"
    mportal="${zeile%%|*}"; rest="${zeile#*|}"; mrole="${rest%%|*}"; mtenant="${rest#*|}"
    akt_tenant="$(dbz "SELECT tenant_id FROM actor WHERE id='$MG05_AKTID'")"
    [ "$mportal" = "EXMA" ]        || m="$m membership.portal_code ist '$mportal' statt EXMA nach dem erneuten Versand;"
    [ "$mrole" = "$EXMA_ROLLE" ]   || m="$m membership.role_id ist '$mrole' statt der einen EXMA-Rolle nach dem erneuten Versand;"
    [ "$mtenant" = "$akt_tenant" ] || m="$m membership.tenant_scope ist '$mtenant' statt actor.tenant_id nach dem erneuten Versand;"
  fi

  [ -z "$m" ] && ok MG-05 "Erneuter Versand: alte Einladung WIDERRUFEN, attempt $alter_attempt->$neuer_attempt, wieder genau eine offene Einladung UND genau eine Mitgliedschaft mit korrektem Primaerschluessel (K20-M12, K20-M13, K20-D05, Sharp Point 1 Blatt 62)" \
              || nok MG-05 "Erneuter Versand:$m"
fi
pruefe_sql_marke  # S3 (14.08.2026): am Ende jedes Fallblocks, siehe Haertung von db()/dbz() oben.

# =====================================================================
# MG-06 · SHARP POINT 2 (der gefaehrlichste Fall dieser Aufgabe) ·
#         Eine bereits eingeloeste Einladung darf ihre Mitgliedschaft NIE
#         verlieren -- sonst nimmt ein Aufraeumvorgang einem arbeitenden
#         Nutzer den Zugang. mg_aktiv@ ist AKTIV, seine Einladung laengst
#         EINGELOEST. Ein erneuter Versandversuch an dieselbe Adresse
#         (der einzige bekannte Weg, der eine Einladung ueberhaupt
#         anfasst) darf weder die Mitgliedschaft entfernen noch die
#         eingeloeste Einladung zuruecksetzen -- unabhaengig davon, ob der
#         Server den Versuch annimmt, ablehnt oder ignoriert (das legt
#         der Vertrag hier nicht fest). Gegenprobe: MG-05 zeigt, dass ein
#         Widerruf bei einer OFFENEN Einladung sehr wohl greift -- der
#         Unterschied zu diesem Fall ist ausschliesslich der Zustand
#         EINGELOEST.
# =====================================================================
MG06_AKTID="$(dbz "SELECT id FROM actor WHERE email='mg_aktiv@pruef.example'")"
mg06_invid="$(dbz "SELECT id FROM invitation WHERE actor_id='$MG06_AKTID' AND status='EINGELOEST'")"
mg06_redeemed_vor="$(dbz "SELECT redeemed_at::text FROM invitation WHERE id='$mg06_invid'")"
mg06_mzahl_vor="$(dbz "SELECT count(*) FROM membership WHERE actor_id='$MG06_AKTID'")"
if [ -z "$KEKS" ]; then
  sperr MG-06 "Gefaehrlichster Fall nicht pruefbar: die Sitzung des Einladenden liess sich nach MG-03 nicht neu herstellen"
elif [ -z "$mg06_invid" ] || [ -z "$mg06_redeemed_vor" ] || [ "${mg06_mzahl_vor:-0}" != "1" ]; then
  sperr MG-06 "Gefaehrlichster Fall nicht pruefbar: die vorbereitete eingeloeste Einladung oder ihre Mitgliedschaft fuer mg_aktiv@ fehlt (mzahl_vor=${mg06_mzahl_vor:-?})"
else
  zeile_vor="$(dbz "SELECT portal_code || '|' || role_id || '|' || tenant_scope
                      FROM membership WHERE actor_id='$MG06_AKTID'")"

  st=$(post_einladung_senden 'mg_aktiv@pruef.example' 'Pruef MG Aktiv Erneut' mg06 "$KEKS")

  m=""
  mzahl_nach="$(dbz "SELECT count(*) FROM membership WHERE actor_id='$MG06_AKTID'")"
  [ "${mzahl_nach:-0}" = "1" ] || m="$m die Mitgliedschaft ist danach $mzahl_nach Mal vorhanden statt genau einmal -- ein bereits arbeitender Nutzer verlor oder verdoppelte seinen Zugang (Sharp Point 2, Blatt 62);"
  if [ "${mzahl_nach:-0}" = "1" ]; then
    zeile_nach="$(dbz "SELECT portal_code || '|' || role_id || '|' || tenant_scope
                         FROM membership WHERE actor_id='$MG06_AKTID'")"
    [ "$zeile_nach" = "$zeile_vor" ] || m="$m die Mitgliedschaftszeile aenderte sich (vorher '$zeile_vor', nachher '$zeile_nach');"
  fi

  status_nach="$(dbz "SELECT status FROM invitation WHERE id='$mg06_invid'")"
  redeemed_nach="$(dbz "SELECT redeemed_at::text FROM invitation WHERE id='$mg06_invid'")"
  [ "$status_nach" = "EINGELOEST" ]         || m="$m die bereits eingeloeste Einladung wurde auf '$status_nach' umgesetzt;"
  [ "$redeemed_nach" = "$mg06_redeemed_vor" ] || m="$m redeemed_at der eingeloesten Einladung wurde veraendert;"

  akt_status_nach="$(dbz "SELECT status FROM actor WHERE id='$MG06_AKTID'")"
  [ "$akt_status_nach" = "AKTIV" ] || m="$m das Konto steht danach auf '$akt_status_nach' statt AKTIV;"

  [ -z "$m" ] && ok MG-06 "Eine bereits eingeloeste Einladung verliert ihre Mitgliedschaft NIE -- weder Zeile noch Zustand aendern sich durch einen erneuten Einladungsversuch (beobachteter Status: $st; Sharp Point 2, Blatt 62)" \
              || nok MG-06 "Gefaehrlichster Fall:$m"
fi
pruefe_sql_marke  # S3 (14.08.2026): am Ende jedes Fallblocks, siehe Haertung von db()/dbz() oben.

# =====================================================================
# MG-07 · Vertrag · "Die Einloesung legt KEINE Mitgliedschaft an. Sie
#         besteht dann schon." mg_bereitsmitglied@ traegt die
#         Mitgliedschaft bereits VOR der Einloesung (aus dem -- hier
#         simulierten -- Versand). Nach der Einloesung muss die Anzahl
#         UNVERAENDERT bei genau eins stehen: kein Duplikat, keine
#         zweite Zeile. Gegenprobe: MG-01 zeigt, dass die Mitgliedschaft
#         schon beim VERSAND entsteht, nicht erst hier.
# =====================================================================
MG07_AKTID="$(dbz "SELECT id FROM actor WHERE email='mg_bereitsmitglied@pruef.example'")"
mg07_mzahl_vor="$(dbz "SELECT count(*) FROM membership WHERE actor_id='$MG07_AKTID'")"
mg07_zeile_vor="$(dbz "SELECT portal_code || '|' || role_id || '|' || tenant_scope
                         FROM membership WHERE actor_id='$MG07_AKTID'")"
if [ "${mg07_mzahl_vor:-0}" != "1" ]; then
  sperr MG-07 "Einloesung ohne Mitgliedschaftsduplikat nicht pruefbar: mg_bereitsmitglied@ traegt vor der Einloesung $mg07_mzahl_vor Mitgliedschaften statt genau einer"
else
  st=$(post_einladung_einloesen 'tok-mg-bereits-3f8a1c6e9d2b0741' mg07)
  ziel="$(kopfzeile mg07 location)"
  m=""
  [ "$st" = "303" ] || m="$m Status $st statt 303;"
  case "$ziel" in *"/anmeldung"*) : ;; *) m="$m Location '$ziel' zeigt nicht auf /anmeldung;";; esac

  mg07_mzahl_nach="$(dbz "SELECT count(*) FROM membership WHERE actor_id='$MG07_AKTID'")"
  [ "${mg07_mzahl_nach:-0}" = "1" ] || m="$m nach der Einloesung bestehen $mg07_mzahl_nach Mitgliedschaften statt weiterhin genau einer (Vertrag: Einloesung legt keine Mitgliedschaft an);"
  if [ "${mg07_mzahl_nach:-0}" = "1" ]; then
    mg07_zeile_nach="$(dbz "SELECT portal_code || '|' || role_id || '|' || tenant_scope
                              FROM membership WHERE actor_id='$MG07_AKTID'")"
    [ "$mg07_zeile_nach" = "$mg07_zeile_vor" ] || m="$m die Mitgliedschaftszeile veraenderte sich durch die Einloesung (vorher '$mg07_zeile_vor', nachher '$mg07_zeile_nach');"
  fi

  inv_status="$(dbz "SELECT status FROM invitation WHERE actor_id='$MG07_AKTID'")"
  akt_status="$(dbz "SELECT status FROM actor WHERE id='$MG07_AKTID'")"
  [ "$inv_status" = "EINGELOEST" ] || m="$m invitation.status ist '$inv_status' statt EINGELOEST nach der Einloesung;"
  [ "$akt_status" = "AKTIV" ]      || m="$m actor.status ist '$akt_status' statt AKTIV nach der Einloesung;"

  [ -z "$m" ] && ok MG-07 'Die Einloesung legt keine zweite Mitgliedschaft an -- die Zahl bleibt bei genau eins, dieselbe Zeile wie vor der Einloesung (Vertrag)' \
              || nok MG-07 "Einloesung ohne Mitgliedschaftsduplikat:$m"
fi
pruefe_sql_marke  # S3 (14.08.2026): am Ende jedes Fallblocks, siehe Haertung von db()/dbz() oben.

# =====================================================================
# MG-08 · NEU GEFASST AM 16.08.2026 · Der Ablauf, gemessen am
#         GEZEICHNETEN Weg.
#
# WAS AN DER ALTEN FASSUNG FALSCH WAR
# ------------------------------------
# Sie konnte nur dann "bestanden" melden, wenn der Zustand ABGELAUFEN
# in die Einladung GESCHRIEBEN wurde. Genau das verbietet die
# gezeichnete Klausel K20-M22 im Wortlaut:
#
#   "Ablauf wird ausschliesslich aus expires_at abgeleitet; kein Lauf
#    schreibt ABGELAUFEN."
#
# Der Fall mass also gegen etwas Verbotenes. Er meldete darum jeden Tag
# GESPERRT -- ein Fall, der nichts messen konnte, weil sein Erfolgsweg
# ein Regelbruch gewesen waere.
#
# WAS ER JETZT MISST
# ------------------
# Die ZIELBEDINGUNG statt des Zustands: Eine Einladung, deren Frist
# verstrichen ist, darf KEINE Zugangszeile (membership) mehr tragen --
# unabhaengig davon, welcher Zustand in der Einladung steht. Ob die
# Frist verstrichen ist, entscheidet allein der Vergleich von
# expires_at mit der Uhr (K20-G03: "invitation_offen vergleicht in der
# Sicht mit der Uhr"), nicht ein gespeichertes Wort.
#
# Der Zustand wird nur noch BERICHTET. Steht danach ABGELAUFEN in der
# Zeile, ist das ein eigener Fehlschlag gegen K20-M22 -- nie ein Erfolg.
#
# WORAN MAN SIEHT, DASS DIESER FALL SCHEITERN KANN
# ------------------------------------------------
#  * Der Zustand VOR der Handlung wird gemessen und ausgewiesen: genau
#    EINE Zugangszeile, Frist verstrichen. Bleibt die Zeile nach der
#    Handlung stehen, meldet der Fall GESCHEITERT -- kein GESPERRT
#    mehr, denn die Bedingung ist jetzt eine erlaubte.
#  * Er kann auf zwei verschiedenen Wegen scheitern (Zugangszeile
#    bleibt · ABGELAUFEN wurde geschrieben) und auf einem bestehen.
#  * Der Gegenhalt steht in MG-10: dieselbe Handlung darf die
#    Zugangszeile einer NICHT abgelaufenen Einladung nicht anruehren.
#    Ein Server, der einfach alle Zugangszeilen loescht, besteht MG-08
#    und faellt in MG-10. Damit misst MG-08 einen UNTERSCHIED, kein
#    Vorkommen.
#
# Die Handlung -- POST /einladung mit dem abgelaufenen Token -- ist die
# einzige bekannte Tuer, die einen abgelaufenen Token ueberhaupt
# anfasst. Sie wird GENAU EINMAL ausgefuehrt; MG-10 und MG-14 lesen
# denselben Vorgang mit.
# =====================================================================
MG08_AKTID="$(dbz "SELECT id FROM actor WHERE email='mg_abgelaufen@pruef.example'")"
MG10_AKTID="$(dbz "SELECT id FROM actor WHERE email='mg_nichtabgelaufen@pruef.example'")"

# --- Zustand VOR der Handlung, fuer BEIDE Konten in einem Zug --------
mg08_mzahl_vor="$(dbz "SELECT count(*) FROM membership WHERE actor_id='$MG08_AKTID'")"
mg08_status_vor="$(dbz "SELECT status FROM invitation WHERE actor_id='$MG08_AKTID'")"
mg08_frist_vor="$(dbz "SELECT CASE WHEN expires_at <= now() THEN 'verstrichen' ELSE 'laeuft' END FROM invitation WHERE actor_id='$MG08_AKTID'")"
mg08_aktstatus_vor="$(dbz "SELECT status FROM actor WHERE id='$MG08_AKTID'")"
mg08_sitzungen_vor="$(dbz "SELECT count(*) FROM auth_session WHERE actor_id='$MG08_AKTID' AND ended_at IS NULL")"
mg10_mzahl_vor="$(dbz "SELECT count(*) FROM membership WHERE actor_id='$MG10_AKTID'")"
mg10_status_vor="$(dbz "SELECT status FROM invitation WHERE actor_id='$MG10_AKTID'")"
mg10_frist_vor="$(dbz "SELECT CASE WHEN expires_at <= now() THEN 'verstrichen' ELSE 'laeuft' END FROM invitation WHERE actor_id='$MG10_AKTID'")"

mg08_handlung=0
if [ "${mg08_mzahl_vor:-0}" != "1" ] || [ "$mg08_frist_vor" != "verstrichen" ]; then
  sperr MG-08 "Ablauf nicht pruefbar: mg_abgelaufen@ traegt vor der Handlung nicht die vorbereitete Ausgangslage (Zugangszeilen=${mg08_mzahl_vor:-?} statt 1, Frist='${mg08_frist_vor:-?}' statt verstrichen, invitation.status='$mg08_status_vor')"
else
  mg08_st=$(post_einladung_einloesen 'tok-mg-abgelaufen-7c2f9a4e1d6b0842' mg08)
  mg08_handlung=1
  mg08_status_nach="$(dbz "SELECT status FROM invitation WHERE actor_id='$MG08_AKTID'")"
  mg08_mzahl_nach="$(dbz "SELECT count(*) FROM membership WHERE actor_id='$MG08_AKTID'")"

  m=""
  # (1) Die Zielbedingung -- und NUR sie entscheidet ueber bestanden.
  [ "${mg08_mzahl_nach:-1}" = "0" ] \
    || m="$m die Zugangszeile besteht weiter (vorher $mg08_mzahl_vor, nachher $mg08_mzahl_nach) -- eine Einladung, deren Frist verstrichen ist, darf keine tragen;"
  # (2) Der verbotene Weg. Wird er beschritten, ist das ein eigener
  #     Fehlschlag -- auch dann, wenn (1) erfuellt waere.
  [ "$mg08_status_nach" != "ABGELAUFEN" ] \
    || m="$m invitation.status wurde auf ABGELAUFEN GESCHRIEBEN -- K20-M22 im Wortlaut: 'Ablauf wird ausschliesslich aus expires_at abgeleitet; kein Lauf schreibt ABGELAUFEN';"

  [ -z "$m" ] && ok MG-08 "Eine Einladung, deren Frist verstrichen ist, traegt keine Zugangszeile mehr (vorher $mg08_mzahl_vor, nachher $mg08_mzahl_nach) -- und es wurde kein ABGELAUFEN geschrieben (invitation.status: $mg08_status_vor -> $mg08_status_nach; K20-M22, K20-G03; beobachtete Antwort: $mg08_st)" \
              || nok MG-08 "Ablauf am gezeichneten Weg:$m (invitation.status: $mg08_status_vor -> $mg08_status_nach; beobachtete Antwort: $mg08_st)"
fi
pruefe_sql_marke  # S3 (14.08.2026): am Ende jedes Fallblocks, siehe Haertung von db()/dbz() oben.

# =====================================================================
# MG-10 · NEU AM 16.08.2026 · DER GEGENHALT ZU MG-08.
#
# Er haelt MG-08 ehrlich. MG-08 verlangt, dass eine Zugangszeile
# VERSCHWINDET. Ein Server, der das dadurch erreicht, dass er alle
# Zugangszeilen loescht, wuerde MG-08 bestehen -- und haette die Regel
# gerade nicht erfuellt. K20-G03 im Wortlaut: "invitation_offen
# vergleicht in der Sicht mit der Uhr." Also gilt der Ablauf NUR fuer
# die, deren Uhr abgelaufen ist.
#
# GEMESSEN WIRD EIN UNTERSCHIED, KEIN VORKOMMEN: dasselbe Ereignis, zwei
# Konten, zwei verschiedene Fristzustaende, zwei verschiedene
# Zielbedingungen. mg_abgelaufen@ MUSS seine Zeile verlieren,
# mg_nichtabgelaufen@ MUSS sie behalten.
#
# SCHEITERN KANN ER: sobald die Zugangszeile des nicht abgelaufenen
# Kontos nach der Handlung fehlt oder seine Einladung angefasst wurde.
# =====================================================================
if [ "$mg08_handlung" != "1" ]; then
  sperr MG-10 "Gegenhalt nicht pruefbar: die Handlung aus MG-08 (POST /einladung mit abgelaufenem Token) ist nicht gelaufen -- ohne sie gibt es nichts, wogegen gegengehalten wird"
elif [ "${mg10_mzahl_vor:-0}" != "1" ] || [ "$mg10_frist_vor" != "laeuft" ] || [ "$mg10_status_vor" != "VERSANDT" ]; then
  sperr MG-10 "Gegenhalt nicht pruefbar: mg_nichtabgelaufen@ traegt vor der Handlung nicht die Ausgangslage (Zugangszeilen=${mg10_mzahl_vor:-?} statt 1, Frist='${mg10_frist_vor:-?}' statt laeuft, invitation.status='$mg10_status_vor' statt VERSANDT)"
else
  mg10_mzahl_nach="$(dbz "SELECT count(*) FROM membership WHERE actor_id='$MG10_AKTID'")"
  mg10_status_nach="$(dbz "SELECT status FROM invitation WHERE actor_id='$MG10_AKTID'")"
  mg10_frist_nach="$(dbz "SELECT CASE WHEN expires_at <= now() THEN 'verstrichen' ELSE 'laeuft' END FROM invitation WHERE actor_id='$MG10_AKTID'")"

  m=""
  [ "${mg10_mzahl_nach:-0}" = "1" ] \
    || m="$m die Zugangszeile der NICHT abgelaufenen Einladung veraenderte sich (vorher $mg10_mzahl_vor, nachher $mg10_mzahl_nach) -- der Ablauf eines fremden Kontos hat sie angefasst;"
  [ "$mg10_status_nach" = "VERSANDT" ] \
    || m="$m invitation.status der NICHT abgelaufenen Einladung wechselte von VERSANDT auf '$mg10_status_nach';"
  [ "$mg10_frist_nach" = "laeuft" ] \
    || m="$m expires_at der NICHT abgelaufenen Einladung wurde veraendert (Frist jetzt '$mg10_frist_nach');"

  [ -z "$m" ] && ok MG-10 "Gegenhalt traegt: eine Einladung, deren Frist NOCH LAEUFT, behaelt ihre Zugangszeile (vorher $mg10_mzahl_vor, nachher $mg10_mzahl_nach) und ihren Zustand VERSANDT, waehrend dieselbe Handlung die abgelaufene traf (K20-G03)" \
              || nok MG-10 "Gegenhalt zum Ablauf:$m"
fi
pruefe_sql_marke  # S3 (14.08.2026): am Ende jedes Fallblocks, siehe Haertung von db()/dbz() oben.

# =====================================================================
# MG-11 · NEU AM 16.08.2026 · NUR DAS BETROFFENE PORTAL.
#
# K20-M19 im Wortlaut: "Portalzugang entfernen loescht ausschliesslich
# die membership des gewaehlten Portals. actor bleibt bestehen;
# Mitgliedschaften anderer Portale bleiben unveraendert."
#
# mg_portalablauf@ traegt ZWEI Zugangszeilen (EXMA und ENDUSER).
# Abgelaufen ist allein die EXMA-Einladung. Nach der Handlung MUSS die
# EXMA-Zeile weg und die ENDUSER-Zeile unveraendert da sein.
#
# GEMESSEN WIRD EIN UNTERSCHIED: zwei Zeilen desselben Kontos,
# gegensaetzliche Zielbedingungen. Ein Server, der nichts tut, faellt an
# der ersten Haelfte; einer, der zu viel tut, an der zweiten. Es gibt
# keine Antwort, die beide Haelften zugleich trivial erfuellt.
# =====================================================================
MG11_AKTID="$(dbz "SELECT id FROM actor WHERE email='mg_portalablauf@pruef.example'")"
mg11_exma_vor="$(dbz "SELECT count(*) FROM membership WHERE actor_id='$MG11_AKTID' AND portal_code='EXMA'")"
mg11_end_vor="$(dbz "SELECT count(*) FROM membership WHERE actor_id='$MG11_AKTID' AND portal_code='ENDUSER'")"
mg11_frist_vor="$(dbz "SELECT CASE WHEN expires_at <= now() THEN 'verstrichen' ELSE 'laeuft' END FROM invitation WHERE actor_id='$MG11_AKTID' AND portal_code='EXMA'")"
mg11_akt_vor="$(dbz "SELECT count(*) FROM actor WHERE id='$MG11_AKTID'")"

if [ "${mg11_exma_vor:-0}" != "1" ] || [ "${mg11_end_vor:-0}" != "1" ] || [ "$mg11_frist_vor" != "verstrichen" ]; then
  sperr MG-11 "Portalgenauigkeit nicht pruefbar: mg_portalablauf@ traegt vor der Handlung nicht die Ausgangslage (EXMA-Zugangszeilen=${mg11_exma_vor:-?}, ENDUSER-Zugangszeilen=${mg11_end_vor:-?}, EXMA-Frist='${mg11_frist_vor:-?}')"
else
  mg11_st=$(post_einladung_einloesen 'tok-mg-portalablauf-4e8b1f6a2d9c7350' mg11)
  mg11_exma_nach="$(dbz "SELECT count(*) FROM membership WHERE actor_id='$MG11_AKTID' AND portal_code='EXMA'")"
  mg11_end_nach="$(dbz "SELECT count(*) FROM membership WHERE actor_id='$MG11_AKTID' AND portal_code='ENDUSER'")"
  mg11_akt_nach="$(dbz "SELECT count(*) FROM actor WHERE id='$MG11_AKTID'")"

  m=""
  [ "${mg11_exma_nach:-1}" = "0" ] \
    || m="$m die EXMA-Zugangszeile zur abgelaufenen Einladung besteht weiter (vorher $mg11_exma_vor, nachher $mg11_exma_nach);"
  [ "${mg11_end_nach:-0}" = "1" ] \
    || m="$m die ENDUSER-Zugangszeile wurde mitgenommen (vorher $mg11_end_vor, nachher $mg11_end_nach) -- K20-M19: 'Mitgliedschaften anderer Portale bleiben unveraendert';"
  [ "${mg11_akt_nach:-0}" = "1" ] \
    || m="$m das Konto selbst verschwand (actor vorher $mg11_akt_vor, nachher $mg11_akt_nach) -- K20-M19: 'actor bleibt bestehen';"

  [ -z "$m" ] && ok MG-11 "Der Ablauf trifft nur das betroffene Portal: EXMA-Zugangszeile $mg11_exma_vor -> $mg11_exma_nach, ENDUSER-Zugangszeile $mg11_end_vor -> $mg11_end_nach, das Konto bleibt (K20-M19; beobachtete Antwort: $mg11_st)" \
              || nok MG-11 "Portalgenauigkeit des Ablaufs:$m (beobachtete Antwort: $mg11_st)"
fi
pruefe_sql_marke  # S3 (14.08.2026): am Ende jedes Fallblocks, siehe Haertung von db()/dbz() oben.

# =====================================================================
# MG-12 · NEU AM 16.08.2026 · NEGATIVFALL MIT DER FEHLERMELDUNG IM
#         WORTLAUT.
#
# Gezeichneter Massstab (Bauauftrag §9 Tor I Nr. 6): Ein Negativfall
# gilt erst als bestanden, wenn er an SEINER EIGENEN Bedingung
# scheitert; die Fehlermeldung im Wortlaut ist Teil des Belegs. Genau
# das ist am 02.08.2026 dreimal misslungen -- die Faelle scheiterten an
# einer Formatpruefung statt an der Zielbedingung.
#
# DIE EIGENE BEDINGUNG hier ist die Frist am Mandanten. K20-G08 im
# Wortlaut: "Schranke und Frist stehen am Mandanten, nicht in der
# Einladung (Eigentuemer K02)." Das Datenmodell nennt die Meldung
# woertlich (K20 Abschn. 5.2, Ground Truth -- "sie werden zitiert und
# nicht umformuliert"):
#
#   "Einladung ueberschreitet die konfigurierte Gueltigkeit von %
#    Stunden"
#
# Der Platzhalter % wird zur Laufzeit durch den Fristwert des Mandanten
# ersetzt. Dieser Fall LIEST den Wert am Mandanten und baut den
# erwarteten Wortlaut daraus -- er schreibt keine Zahl fest, sonst
# maesse er die eigene Annahme statt die Regel.
#
# GEMESSEN WIRD EIN UNTERSCHIED, KEIN VORKOMMEN: Der Versuch UEBER der
# Frist muss abgewiesen werden, der sonst gleiche Versuch INNERHALB der
# Frist muss durchgehen. Ohne diese Gegenprobe bestuende der Fall auch
# gegen eine Tabelle, die einfach alles ablehnt.
#
# ---------------------------------------------------------------------
# WAS DIESER FALL MISST -- UND WAS NICHT (nachgetragen 16.08.2026)
# ---------------------------------------------------------------------
# Beide Versuche schreiben UNMITTELBAR in die Einladungstabelle, an
# jedem Serverweg vorbei. GEMESSEN WIRD DAMIT DIE BEDINGUNG IM
# ZIELSCHEMA, NICHT DER GEBAUTE SERVERBEFEHL. Ob der Einladungsversand
# (POST /einladung/senden) dieselbe Frist einhaelt, misst dieser Fall
# NICHT -- ein Bau, der die Frist im Serverweg ignoriert, faellt hier
# nicht auf, solange die Schranke im Schema haelt. Ein bestandener MG-12
# ist also die Aussage "das Zielschema weist die zu lange Frist ab, und
# zwar an ihrer eigenen Bedingung", nicht die Aussage "der Versand haelt
# die Frist ein".
#
# Er veraendert dabei den Bestand des benutzten Kontos: die Gegenprobe
# innerhalb der Frist geht DURCH und laesst eine Einladungszeile an
# mg_frist@ stehen. Kein spaeterer Fall dieses Laufs liest mg_frist@
# (nachgeprueft am 16.08.2026 ueber alle Fallbloecke: die Adresse kommt
# nur in der Aufbaupruefung VOR allen Faellen und in diesem Block vor).
# =====================================================================
MG12_AKTID="$(dbz "SELECT id FROM actor WHERE email='mg_frist@pruef.example'")"
mg12_ttl="$(dbz "SELECT invite_ttl_hours FROM tenant WHERE id='$TENANT_ID'")"
mg12_inv_vor="$(dbz "SELECT count(*) FROM invitation WHERE actor_id='$MG12_AKTID'")"
mg12_m_vor="$(dbz "SELECT count(*) FROM membership WHERE actor_id='$MG12_AKTID'")"

case "${mg12_ttl:-x}" in
  ''|*[!0-9]*) mg12_ttl="" ;;
esac

if [ -z "$MG12_AKTID" ] || [ -z "$mg12_ttl" ]; then
  sperr MG-12 "Negativfall Frist nicht pruefbar: mg_frist@ fehlt oder der Mandant traegt keine lesbare Frist (invite_ttl_hours='${mg12_ttl:-?}')"
# NACHGETRAGEN 16.08.2026: Die Gegenprobe rechnet ttl-1. Am Pruefstand
# steht 24, aber das Zielschema laesst 1 bis 168 Stunden zu. Bei einer
# Frist von genau einer Stunde waere die Gegenprobe NULL Stunden lang --
# und eine Einladung, die im selben Augenblick verfaellt, in dem sie
# entsteht, ist keine Probe "innerhalb der Frist", sondern ein zweiter
# Grenzfall. Der Fall wuerde dann eine Abweisung melden, die nichts mit
# der gemessenen Regel zu tun hat. Unterhalb einer Stunde ist keine
# Gegenprobe moeglich -- also GESPERRT (K23-M22), nicht bestanden und
# nicht gescheitert. Die Schwelle des Falls bleibt unangetastet: der
# Versuch UEBER der Frist muss weiterhin an seiner eigenen Bedingung
# scheitern.
elif [ "$mg12_ttl" -le 1 ]; then
  sperr MG-12 "Negativfall Frist nicht messbar: der Mandant fuehrt eine Frist von $mg12_ttl Stunde(n). Die Gegenprobe INNERHALB der Frist braucht mindestens eine Stunde Restlaufzeit; unterhalb einer Stunde ist keine Gegenprobe moeglich. Ohne sie maesse Schritt (1) nicht die Frist, sondern eine Tuer, die alles ablehnt -- das waere ein bestandener Fall, der nichts gemessen hat (K23-M22)"
elif [ "${mg12_inv_vor:-1}" != "0" ] || [ "${mg12_m_vor:-1}" != "0" ]; then
  sperr MG-12 "Negativfall Frist nicht pruefbar: mg_frist@ ist vor der Handlung nicht leer (Einladungen=${mg12_inv_vor:-?}, Zugangszeilen=${mg12_m_vor:-?}) -- der Versuch scheiterte sonst am Einladungsplatz statt an der Frist, also an fremder Bedingung"
else
  mg12_erwartet="Einladung ueberschreitet die konfigurierte Gueltigkeit von $mg12_ttl Stunden"
  mg12_ueber=$((mg12_ttl + 1))
  # Mindestens eine Stunde. Der Zweig oben faengt ttl<=1 bereits als
  # GESPERRT ab; diese Begrenzung ist der zweite Riegel, damit hier
  # unter keinen Umstaenden "interval '0 hours'" entsteht.
  mg12_drunter=$((mg12_ttl - 1))
  [ "$mg12_drunter" -ge 1 ] || mg12_drunter=1

  # --- (1) Der Versuch UEBER der Frist: er MUSS scheitern -----------
  mg12_meldung="$(db_versuch "INSERT INTO invitation (actor_id, portal_code, mail, token_hash, sent_at, expires_at, status)
                              VALUES ('$MG12_AKTID','EXMA','mg_frist@pruef.example','streuwert-mg-frist-ueber-der-frist',
                                      now(), now() + interval '$mg12_ueber hours','VERSANDT')")" \
    && mg12_rc=0 || mg12_rc=1

  m=""
  if [ "$mg12_rc" = "0" ]; then
    m="$m die Einladung mit einer Gueltigkeit von $mg12_ueber Stunden wurde ANGENOMMEN, obwohl der Mandant $mg12_ttl Stunden fuehrt;"
  else
    case "$mg12_meldung" in
      *"$mg12_erwartet"*) : ;;
      *) m="$m der Versuch scheiterte an einer FREMDEN Bedingung, nicht an der Frist. Erwartet im Wortlaut: '$mg12_erwartet'. Beobachtet: '$mg12_meldung';" ;;
    esac
  fi

  # --- (2) Nachzustand: es darf nichts entstanden sein --------------
  mg12_inv_nach="$(dbz "SELECT count(*) FROM invitation WHERE actor_id='$MG12_AKTID'")"
  mg12_m_nach="$(dbz "SELECT count(*) FROM membership WHERE actor_id='$MG12_AKTID'")"
  [ "${mg12_inv_nach:-1}" = "0" ] || m="$m nach dem abgewiesenen Versuch steht eine Einladungszeile (${mg12_inv_nach});"
  [ "${mg12_m_nach:-1}" = "0" ]   || m="$m nach dem abgewiesenen Versuch steht eine Zugangszeile (${mg12_m_nach}) -- abgewiesen heisst: es entsteht keine Zeile;"

  # --- (3) Gegenprobe INNERHALB der Frist: sie MUSS durchgehen ------
  #     Ohne sie misst der Fall nichts: eine Tuer, die alles ablehnt,
  #     bestuende Schritt (1) ebenfalls.
  mg12_gegen="$(db_versuch "INSERT INTO invitation (actor_id, portal_code, mail, token_hash, sent_at, expires_at, status)
                            VALUES ('$MG12_AKTID','EXMA','mg_frist@pruef.example','streuwert-mg-frist-in-der-frist',
                                    now(), now() + interval '$mg12_drunter hours','VERSANDT')")" \
    && mg12_grc=0 || mg12_grc=1
  [ "$mg12_grc" = "0" ] \
    || m="$m die Gegenprobe INNERHALB der Frist ($mg12_drunter Stunden) wurde ebenfalls abgewiesen -- damit misst Schritt (1) nicht die Frist, sondern eine Tuer, die alles ablehnt. Beobachtet: '$mg12_gegen';"

  [ -z "$m" ] && ok MG-12 "Negativfall an SEINER EIGENEN Bedingung: eine Einladung mit $mg12_ueber Stunden Gueltigkeit wird abgewiesen, mit der Meldung im Wortlaut -- '$mg12_meldung'; es entsteht weder Einladungs- noch Zugangszeile, und die Gegenprobe mit $mg12_drunter Stunden geht durch (K20-G08, K20 Abschn. 5.2)" \
              || nok MG-12 "Negativfall Frist:$m"
fi
pruefe_sql_marke  # S3 (14.08.2026): am Ende jedes Fallblocks, siehe Haertung von db()/dbz() oben.

# =====================================================================
# MG-13 · NEU AM 16.08.2026 · DER EINLADUNGSPLATZ.
#
# K20-D05 im Wortlaut: "Eine zweite offene Einladung je Konto DARF NICHT
# bestehen. Der Wunsch nach einem neuen Link fuehrt ueber den Widerruf,
# nicht daran vorbei. Der Platz DARF NICHT ueber einen Wechsel nach
# ABGELAUFEN oder EINGELOEST frei gemacht werden -- allein WIDERRUFEN
# nach K20-M13 schafft ihn."
#
# Der Fall setzt genau dort an, wo K20-M22 und K20-D05 aufeinander
# treffen: mg_platz@ traegt eine Einladung, deren FRIST verstrichen ist,
# die aber -- wie K20-M22 es verlangt -- weiter auf VERSANDT steht. Der
# Platz ist damit belegt.
#
# GEMESSEN WIRD EIN UNTERSCHIED, KEIN VORKOMMEN:
#   Schritt 1  Zweite Einladung bei belegtem Platz  -> MUSS abgewiesen
#              werden, und zwar am Einladungsplatz (invitation_offen_uq),
#              nicht an Frist oder Domaene.
#   Schritt 2  Dieselbe Einladung, nachdem die alte WIDERRUFEN wurde
#              (der einzige gezeichnete Weg) -> MUSS durchgehen.
# Genau ein Weg macht den Platz frei. Ein Bestand, der beides zulaesst
# oder beides ablehnt, faellt durch.
#
# ---------------------------------------------------------------------
# WAS DIESER FALL MISST -- UND WAS NICHT (nachgetragen 16.08.2026)
# ---------------------------------------------------------------------
# Beide Schritte schreiben UNMITTELBAR in die Einladungstabelle, an
# jedem Serverweg vorbei. GEMESSEN WIRD DAMIT DIE BEDINGUNG IM
# ZIELSCHEMA, NICHT DER GEBAUTE SERVERBEFEHL. Ob der Einladungsversand
# (POST /einladung/senden) denselben Einladungsplatz achtet und
# dieselbe Frist einhaelt, misst dieser Fall NICHT -- ein Bau, der am
# Serverweg eine zweite offene Einladung erzeugt, faellt hier nicht auf,
# solange die Schranke im Schema haelt.
#
# DIESER FALL VERAENDERT DEN BESTAND DES BENUTZTEN KONTOS: die alte
# Einladung von mg_platz@ steht am Ende auf WIDERRUFEN, und eine zweite,
# gueltige Einladung (attempt=2) ist dazugekommen. KEIN SPAETERER FALL
# LIEST DIESES KONTO. Nachgeprueft am 16.08.2026 ueber alle Fallbloecke
# des Laufs: 'mg_platz@pruef.example' kommt ausschliesslich in der
# Aufbaupruefung VOR allen Faellen und in diesem Block vor; die danach
# folgenden Faelle MG-14 (mg_abgelaufen@) und MG-09 (mg_faden@) ruehren
# es nicht an. Wer NACH MG-13 einen Fall einfuegt, der mg_platz@ liest,
# muss diese Zeile neu pruefen -- sie ist eine Messung, keine Annahme.
# =====================================================================
MG13_AKTID="$(dbz "SELECT id FROM actor WHERE email='mg_platz@pruef.example'")"
mg13_inv_vor="$(dbz "SELECT count(*) FROM invitation WHERE actor_id='$MG13_AKTID'")"
mg13_status_vor="$(dbz "SELECT status FROM invitation WHERE actor_id='$MG13_AKTID'")"
mg13_frist_vor="$(dbz "SELECT CASE WHEN expires_at <= now() THEN 'verstrichen' ELSE 'laeuft' END FROM invitation WHERE actor_id='$MG13_AKTID'")"
mg13_ttl="$(dbz "SELECT invite_ttl_hours FROM tenant WHERE id='$TENANT_ID'")"
case "${mg13_ttl:-x}" in
  ''|*[!0-9]*) mg13_ttl="" ;;
esac

if [ -z "$MG13_AKTID" ] || [ -z "$mg13_ttl" ]; then
  sperr MG-13 "Einladungsplatz nicht pruefbar: mg_platz@ fehlt oder der Mandant traegt keine lesbare Frist (invite_ttl_hours='${mg13_ttl:-?}')"
elif [ "${mg13_inv_vor:-0}" != "1" ] || [ "$mg13_status_vor" != "VERSANDT" ] || [ "$mg13_frist_vor" != "verstrichen" ]; then
  sperr MG-13 "Einladungsplatz nicht pruefbar: mg_platz@ traegt vor der Handlung nicht die Ausgangslage (Einladungen=${mg13_inv_vor:-?} statt 1, status='$mg13_status_vor' statt VERSANDT, Frist='${mg13_frist_vor:-?}' statt verstrichen)"
else
  mg13_kurz=$((mg13_ttl - 1))

  # --- Schritt 1: der Platz ist belegt, obwohl die Frist um ist -----
  mg13_meldung="$(db_versuch "INSERT INTO invitation (actor_id, portal_code, mail, token_hash, sent_at, expires_at, status)
                              VALUES ('$MG13_AKTID','EXMA','mg_platz@pruef.example','streuwert-mg-platz-zweiter-versuch',
                                      now(), now() + interval '$mg13_kurz hours','VERSANDT')")" \
    && mg13_rc=0 || mg13_rc=1

  m=""
  if [ "$mg13_rc" = "0" ]; then
    m="$m eine ZWEITE Einladung entstand neben der ersten, obwohl diese noch auf VERSANDT steht -- der Platz wurde durch das blosse Verstreichen der Frist frei (K20-D05: allein WIDERRUFEN schafft ihn);"
  else
    case "$mg13_meldung" in
      *invitation_offen_uq*) : ;;
      *) m="$m der zweite Versuch scheiterte an einer FREMDEN Bedingung, nicht am Einladungsplatz. Erwartet war die Bedingung invitation_offen_uq. Beobachtet: '$mg13_meldung';" ;;
    esac
  fi
  mg13_inv_mitte="$(dbz "SELECT count(*) FROM invitation WHERE actor_id='$MG13_AKTID'")"
  [ "${mg13_inv_mitte:-0}" = "1" ] \
    || m="$m nach dem abgewiesenen zweiten Versuch stehen ${mg13_inv_mitte} Einladungszeilen statt einer;"

  # --- Schritt 2: WIDERRUFEN -- der einzige gezeichnete Weg ---------
  mg13_widerruf="$(db_versuch "UPDATE invitation SET status='WIDERRUFEN'
                                WHERE actor_id='$MG13_AKTID' AND status='VERSANDT'")" \
    && mg13_wrc=0 || mg13_wrc=1
  if [ "$mg13_wrc" != "0" ]; then
    m="$m der Widerruf der alten Einladung liess sich nicht setzen -- ohne ihn ist der zweite Teil der Unterscheidung nicht messbar. Beobachtet: '$mg13_widerruf';"
  else
    mg13_gegen="$(db_versuch "INSERT INTO invitation (actor_id, portal_code, mail, token_hash, sent_at, expires_at, status, attempt)
                              VALUES ('$MG13_AKTID','EXMA','mg_platz@pruef.example','streuwert-mg-platz-nach-widerruf',
                                      now(), now() + interval '$mg13_kurz hours','VERSANDT',2)")" \
      && mg13_grc=0 || mg13_grc=1
    [ "$mg13_grc" = "0" ] \
      || m="$m nach dem WIDERRUF blieb der Platz belegt -- die neue Einladung wurde ebenfalls abgewiesen. Damit misst Schritt 1 nicht den Platz, sondern eine Tuer, die alles ablehnt. Beobachtet: '$mg13_gegen';"
  fi

  [ -z "$m" ] && ok MG-13 "Der Einladungsplatz bleibt belegt, solange die abgelaufene Einladung auf VERSANDT steht (abgewiesen an invitation_offen_uq: '$mg13_meldung') -- und wird erst durch WIDERRUFEN frei, danach entsteht die neue Einladung (K20-D05, K20-M13, K20-M22)" \
              || nok MG-13 "Einladungsplatz:$m"
fi
pruefe_sql_marke  # S3 (14.08.2026): am Ende jedes Fallblocks, siehe Haertung von db()/dbz() oben.

# =====================================================================
# MG-14 · NEU AM 16.08.2026 · DER ABGELAUFENE LINK WIRKT NICHT.
#
# K20-D10 im Wortlaut: "Eine abgelaufene, eingeloeste oder widerrufene
# Einladung DARF NICHT erneut wirken. Ein verfallener Link fuehrt zu
# einem neuen Vorgang, nie zu einer Verlaengerung."
#
# MG-08 misst, was die abgelaufene Einladung VERLIERT (die Zugangszeile).
# Dieser Fall misst, was sie NICHT BEKOMMT: kein AKTIV, keine Sitzung,
# kein Einloesezeitpunkt, keine neue Zugangszeile. Beides zusammen ist
# der Ablauf; einzeln waere jedes die halbe Regel.
#
# GEMESSEN WIRD EIN UNTERSCHIED, KEIN VORKOMMEN: Dass eine Tuer, die
# einfach immer schweigt, hier nicht durchkaeme, belegen MG-07 und
# MG-09 -- dort MUSS derselbe Vorgang mit einem GUELTIGEN Token das
# Konto auf AKTIV setzen und eine Sitzung eroeffnen. Erst der
# Unterschied zwischen beiden ist die Messung.
#
# Der Zustand VOR der Handlung ist oben gemessen (mg08_aktstatus_vor,
# mg08_sitzungen_vor) -- vor demselben POST, den MG-08 ausgeloest hat.
#
# ---------------------------------------------------------------------
# NACHGEBESSERT AM 16.08.2026 · DER GEGENHALT WIRD SELBST GEPRUEFT
# ---------------------------------------------------------------------
# Bis heute stand der Satz "das belegen MG-07 und MG-09" nur im
# Kommentar. MG-07 und MG-09 stehen in ANDEREN Bloecken: scheitern sie,
# merkte MG-14 nichts und meldete weiter "bestanden" -- eine Aussage
# ueber einen Unterschied, von dem nur noch eine Haelfte gemessen war.
# Genau das ist der Fehler, den diese Scheibe ueberall sonst vermeidet:
# ein gruener Fall, der nichts gemessen hat.
#
# MG-14 sieht jetzt SELBST nach. Bestehen MG-07 oder MG-09 nicht, meldet
# er GESPERRT statt BESTANDEN, mit dem Zustand beider Faelle im
# Wortlaut. GESPERRT heisst hier, was K23-M22 darunter versteht: der
# Unterschied konnte nicht gemessen werden -- nicht, dass der Bau ihn
# verletzt haette.
#
# WARUM DAS URTEIL ANS ENDE DES LAUFS WANDERT: MG-09 laeuft NACH MG-14
# (Reihenfolge siehe Dateikopf -- MG-10 und MG-14 muessen den Zustand
# unmittelbar nach der einen Handlung von MG-08 lesen, ohne einen
# zweiten ganzen Faden dazwischen). Die MESSUNG bleibt deshalb hier an
# ihrem Platz; nur die MELDUNG wird zurueckgestellt, bis MG-09
# gesprochen hat. Das aendert die Reihenfolge der Zeilen im Bericht,
# nicht den Zeitpunkt einer einzigen Messung.
#
# K23-D05 -- kein Pruefwert wird gesenkt: Die Nachschau kann ein
# Urteil ausschliesslich VERSCHAERFEN. GESCHEITERT bleibt GESCHEITERT,
# GESPERRT bleibt GESPERRT; nur BESTANDEN kann zu GESPERRT werden. Und
# GESPERRT zaehlt in dieser Datei zu den gescheiterten Faellen.
# =====================================================================
mg14_urteil=""     # sperr | nok | ok -- die Meldung folgt nach MG-09
mg14_text=""
if [ "$mg08_handlung" != "1" ]; then
  mg14_urteil=sperr
  mg14_text="Wirkung des abgelaufenen Links nicht pruefbar: die Handlung aus MG-08 (POST /einladung mit abgelaufenem Token) ist nicht gelaufen"
elif [ "$mg08_aktstatus_vor" != "WARTET_2FA" ] || [ "${mg08_sitzungen_vor:-1}" != "0" ]; then
  mg14_urteil=sperr
  mg14_text="Wirkung des abgelaufenen Links nicht pruefbar: mg_abgelaufen@ war vor der Handlung nicht im erwarteten Zustand (actor.status='$mg08_aktstatus_vor' statt WARTET_2FA, offene Sitzungen=${mg08_sitzungen_vor:-?} statt 0)"
else
  mg14_aktstatus_nach="$(dbz "SELECT status FROM actor WHERE id='$MG08_AKTID'")"
  mg14_sitzungen_nach="$(dbz "SELECT count(*) FROM auth_session WHERE actor_id='$MG08_AKTID' AND ended_at IS NULL")"
  mg14_redeemed="$(dbz "SELECT count(*) FROM invitation WHERE actor_id='$MG08_AKTID' AND redeemed_at IS NOT NULL")"
  mg14_keks="$(sitzungszahl mg08)"

  m=""
  [ "$mg14_aktstatus_nach" = "WARTET_2FA" ] \
    || m="$m actor.status wechselte von '$mg08_aktstatus_vor' auf '$mg14_aktstatus_nach' -- ein verfallener Link darf nicht wirken;"
  [ "${mg14_sitzungen_nach:-1}" = "0" ] \
    || m="$m es steht eine offene Sitzung (vorher $mg08_sitzungen_vor, nachher $mg14_sitzungen_nach);"
  [ "${mg14_redeemed:-1}" = "0" ] \
    || m="$m ein Einloesezeitpunkt (redeemed_at) wurde gesetzt (${mg14_redeemed} Zeile(n));"
  [ "${mg14_keks:-1}" = "0" ] \
    || m="$m die Antwort setzte ein Sitzungs-Cookie (${mg14_keks} Set-Cookie-Zeile(n));"

  if [ -z "$m" ]; then
    mg14_urteil=ok
    mg14_text="Der abgelaufene Link wirkt nicht: das Konto bleibt WARTET_2FA, es entsteht keine Sitzung, kein Sitzungs-Cookie und kein Einloesezeitpunkt (K20-D10; beobachtete Antwort: $mg08_st)"
  else
    mg14_urteil=nok
    mg14_text="Wirkung des abgelaufenen Links:$m (beobachtete Antwort: $mg08_st)"
  fi
fi
pruefe_sql_marke  # S3 (14.08.2026): am Ende jedes Fallblocks, siehe Haertung von db()/dbz() oben.

# =====================================================================
# MG-09 · FALL 3 · Der ganze Faden am Stueck: Versand -> Link aus der
#         Mail -> Einloesung -> Anmeldung mit Code -> Startseite. Bis
#         heute scheiterte er an portal_bestimmen, weil keine
#         Mitgliedschaft bestand (K03-M11). Dieser Fall belegt, dass die
#         Luecke geschlossen ist -- MG-01..MG-08 pruefen die einzelnen
#         Nebenwirkungen isoliert, dieser Fall prueft den Faden am
#         Stueck, wie ein echter eingeladener Nutzer ihn durchlaeuft.
# =====================================================================
if [ -z "$KEKS" ]; then
  sperr MG-09 "Ganzer Faden nicht pruefbar: die Sitzung des Einladenden liess sich nach MG-03 nicht neu herstellen"
elif [ -z "$MAILFANG" ]; then
  sperr MG-09 'FREIRAUM_PRUEF_MAILFANG ist nicht gesetzt -- ohne die gefangenen Mails ist der Link aus der Einladung nicht auffindbar, der ganze Faden also nicht pruefbar'
elif [ ! -r "$MAILFANG" ]; then
  sperr MG-09 "FREIRAUM_PRUEF_MAILFANG='$MAILFANG' ist nicht lesbar"
else
  m=""
  st=$(post_einladung_senden 'mg_faden@pruef.example' 'Pruef MG Faden' mg09_versand "$KEKS")
  ziel="$(kopfzeile mg09_versand location)"
  [ "$st" = "303" ] || m="$m Versand: Status $st statt 303;"
  case "$ziel" in */einladung/senden\?gesendet=1) : ;; \
                  *) m="$m Versand: Location '$ziel' zeigt nicht auf /einladung/senden?gesendet=1;";; esac

  if [ -n "$m" ]; then
    nok MG-09 "Versandschritt des ganzen Fadens:$m"
  else
    token=""
    mailfang_rc=0
    token="$(mailfang_token "$MAILFANG" 'mg_faden@pruef.example')" || mailfang_rc=$?
    case "$mailfang_rc" in
      0) : ;;
      3) sperr MG-09 "In $MAILFANG wurde ein Einladungstoken gefunden, aber KEINE Nachricht darin nennt mg_faden@pruef.example in ihren Kopfzeilen -- die Zuordnung nach dem verbindlichen Mailfang-Format (siehe Kopf dieser Datei) misslingt" ;;
      2) sperr MG-09 "Kein Einladungstoken fuer mg_faden@pruef.example in $MAILFANG gefunden (Format: siehe Kopf dieser Datei)" ;;
      *) sperr MG-09 "$MAILFANG konnte nicht gelesen werden" ;;
    esac

    if [ "$mailfang_rc" = "0" ] && [ -n "$token" ]; then
      # Der Link, wie er in der Mail steht: ein GET zeigt die
      # Bestaetigungsseite (klick-sicher, siehe EL-04 der Nachbarscheibe).
      hole "/einladung?token=$token" mg09_link >/dev/null

      st=$(post_einladung_einloesen "$token" mg09_einloesen)
      ziel="$(kopfzeile mg09_einloesen location)"
      m=""
      [ "$st" = "303" ] || m="$m Einloesung: Status $st statt 303;"
      case "$ziel" in *"/anmeldung"*) : ;; *) m="$m Einloesung: Location '$ziel' zeigt nicht auf /anmeldung;";; esac

      if [ -n "$m" ]; then
        nok MG-09 "Einloesungsschritt des ganzen Fadens:$m"
      else
        faden_aktid="$(dbz "SELECT id FROM actor WHERE email='mg_faden@pruef.example'")"
        faden_status="$(dbz "SELECT status FROM actor WHERE id='$faden_aktid'")"
        if [ -z "$faden_aktid" ] || [ "$faden_status" != "AKTIV" ]; then
          nok MG-09 "Nach der Einloesung ist mg_faden@ nicht auffindbar oder nicht AKTIV (status=$faden_status) -- der Faden bricht vor der Anmeldung ab"
        else
          # Der Anmeldecode kommt hier NICHT aus der Mailfang-Datei: der
          # Vertrag nennt fuer FREIRAUM_PRUEF_MAILFANG nur "der Link"
          # (Einladung), nicht den Anmeldecode. Ein frischer, gueltiger
          # Code wird deshalb wie bei jeder Sitzungsgrundlage dieser
          # Scheiben direkt gesetzt (siehe versand_daten.sql Abschn. 6).
          db "INSERT INTO login_code (actor_id, code_hash, issued_at, expires_at)
              SELECT '$faden_aktid', pruef_codewert('700009', '$FREIRAUM_CODE_PFEFFER'), now(), now() + interval '10 minutes'" >/dev/null

          st=$(post_anmeldung 'mg_faden@pruef.example' '700009' mg09_anmeldung)
          keks09="$(sitzungswert mg09_anmeldung)"
          m=""
          [ "$st" = "303" ] || m="$m Anmeldung: Status $st statt 303 -- die historische Luecke (portal_bestimmen ohne Mitgliedschaft) waere hier sichtbar;"
          [ -n "$keks09" ]  || m="$m Anmeldung: kein Cookie fr_sitzung gesetzt;"

          if [ -n "$m" ]; then
            nok MG-09 "Anmeldeschritt des ganzen Fadens:$m"
          else
            st2=$(hole / mg09_start "$keks09")
            m=""
            [ "$st2" = "200" ] || m="$m Startseite: GET / mit der Sitzung liefert $st2 statt 200;"

            mzahl="$(dbz "SELECT count(*) FROM membership WHERE actor_id='$faden_aktid'")"
            [ "${mzahl:-0}" = "1" ] || m="$m nach dem ganzen Faden bestehen $mzahl Mitgliedschaften statt genau einer;"
            if [ "${mzahl:-0}" = "1" ]; then
              zeile="$(dbz "SELECT portal_code || '|' || role_id || '|' || tenant_scope
                              FROM membership WHERE actor_id='$faden_aktid'")"
              mportal="${zeile%%|*}"; rest="${zeile#*|}"; mrole="${rest%%|*}"; mtenant="${rest#*|}"
              akt_tenant="$(dbz "SELECT tenant_id FROM actor WHERE id='$faden_aktid'")"
              [ "$mportal" = "EXMA" ]        || m="$m membership.portal_code ist '$mportal' statt EXMA am Ende des Fadens;"
              [ "$mrole" = "$EXMA_ROLLE" ]   || m="$m membership.role_id ist '$mrole' statt der einen EXMA-Rolle am Ende des Fadens;"
              [ "$mtenant" = "$akt_tenant" ] || m="$m membership.tenant_scope ist '$mtenant' statt actor.tenant_id am Ende des Fadens;"
            fi

            [ -z "$m" ] && ok MG-09 'Der ganze Faden traegt: Versand -> Link aus der Mail -> Einloesung -> Anmeldung mit Code -> Startseite (200), mit korrekt bestehender Mitgliedschaft -- die historische Luecke an portal_bestimmen ist geschlossen (Blatt 62, K03-M11)' \
                        || nok MG-09 "Startseite/Mitgliedschaft am Ende des ganzen Fadens:$m"
          fi
        fi
      fi
    fi
  fi
fi
pruefe_sql_marke  # S3 (14.08.2026): am Ende jedes Fallblocks, siehe Haertung von db()/dbz() oben.

# =====================================================================
# MG-14 · DIE ZURUECKGESTELLTE MELDUNG (nachgetragen 16.08.2026)
#
# Die Messung ist oben gelaufen, unmittelbar nach der einen Handlung von
# MG-08. Erst hier ist auch MG-09 gesprochen -- und erst hier laesst
# sich sagen, ob der Unterschied, den MG-14 behauptet, ueberhaupt
# gemessen ist.
#
# MG-14 misst, was ein ABGELAUFENER Link NICHT bewirkt: kein AKTIV,
# keine Sitzung, kein Einloesezeitpunkt. Ein Server, der auf JEDEN Token
# schweigt, bestuende das. Dass er das nicht darf, belegen allein
# MG-07 und MG-09: dort MUSS derselbe Vorgang mit einem GUELTIGEN Token
# wirken. Fehlt einer der beiden, ist hier kein Unterschied gemessen,
# sondern nur ein Schweigen beobachtet -- also GESPERRT (K23-M22).
#
# Ein bereits GESCHEITERTES oder GESPERRTES Urteil bleibt, was es ist:
# der Gegenhalt wird nur an ein BESTANDEN angelegt (K23-D05).
# =====================================================================
mg14_gegenhalt=""
[ "$(ergebnis MG-07)" = "BESTANDEN" ] \
  || mg14_gegenhalt="$mg14_gegenhalt MG-07 steht auf '$(ergebnis MG-07)';"
[ "$(ergebnis MG-09)" = "BESTANDEN" ] \
  || mg14_gegenhalt="$mg14_gegenhalt MG-09 steht auf '$(ergebnis MG-09)';"

case "$mg14_urteil" in
  ok)
    if [ -n "$mg14_gegenhalt" ]; then
      sperr MG-14 "Wirkung des abgelaufenen Links NICHT gemessen, obwohl am abgelaufenen Link nichts geschah: dieser Fall misst ein AUSBLEIBEN (kein AKTIV, keine Sitzung, kein Sitzungs-Cookie, kein Einloesezeitpunkt). Ein Ausbleiben ist nur dann ein Befund, wenn derselbe Vorgang mit einem GUELTIGEN Token nachweislich wirkt -- das belegen MG-07 und MG-09, und die tragen heute nicht:$mg14_gegenhalt Ohne sie waere hier auch ein Server gruen, der auf JEDEN Token schweigt. Gemessen ist damit kein Unterschied, sondern ein Schweigen -- nach K23-M22 GESPERRT, nicht bestanden. Die Beobachtung selbst, unveraendert: $mg14_text"
    else
      ok MG-14 "$mg14_text -- der Gegenhalt traegt: MG-07 und MG-09 sind beide BESTANDEN, dort wirkt derselbe Vorgang mit einem GUELTIGEN Token. Erst dieser Unterschied ist die Messung"
    fi
    ;;
  nok)    nok   MG-14 "$mg14_text" ;;
  sperr)  sperr MG-14 "$mg14_text" ;;
  *)      sperr MG-14 "Wirkung des abgelaufenen Links nicht pruefbar: der Block von MG-14 hat kein Urteil hinterlassen -- der Lauf ist an ihm vorbeigegangen" ;;
esac
pruefe_sql_marke  # S3 (14.08.2026): am Ende jedes Fallblocks, siehe Haertung von db()/dbz() oben.

# =====================================================================
printf '\n'
[ "$gesperrt" -gt 0 ] && printf 'davon GESPERRT (nicht messbar, zaehlt nach K23-M22 nicht als bestanden): %s\n' "$gesperrt"
printf 'SUMME: %s von %s bestanden, %s gescheitert\n' "$bestanden" "$gesamt" "$gescheitert"
[ "$gescheitert" -eq 0 ]
