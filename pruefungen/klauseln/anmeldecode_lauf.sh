#!/usr/bin/env bash
# =====================================================================
# FREIRAUM · Scheibe · Anmeldecode nach Einloesung
# Klauselpruefung gegen einen LAUFENDEN Server
#
# GEPRUEFTER VORGANG: "Der Eingeladene bekommt nach dem Einloesen der
# Einladung einen Anmeldecode per E-Mail und kann sich damit anmelden."
#
# Vertragsgrundlage: K19 EN-01 fuehrt fuer die Anmeldung genau EINE
# Aktion ("anmelden"), Eingabe "E-Mail-Adresse (aus der Einladung
# vorbelegt) und sechsstelliger Code per E-Mail" -- kein eigener
# Bildschirm oder Knopf fuer den Codeversand. Der einzige im Vertrag
# vorgesehene Ausloeser ist darum die EINLOESUNG der Einladung selbst
# (POST /einladung, Erfolg -> 303 auf /anmeldung). Dieser Prueflauf
# misst, ob genau DAS geschieht: Einloesung -> Codeversand -> Anmeldung.
#
# Geschrieben gegen K03 v1.3 (M15, M16, M25, G01), K19 EN-01
# (Codefrist, Einmalverwendung, Zustand_fehler), K20 v1.3 (M18) und
# K23 v1.1 (D09) -- NICHT gegen den Umsetzungscode. Der Prueffall kennt
# den Server nur durch seine Tueren. Machart wie einloesung_lauf.sh und
# anmeldung_lauf.sh (die eigenen Vorbilder dieser Scheibe).
#
# Aufruf:
#   FREIRAUM_CODE_PFEFFER=... \
#   psql ... -f pruefungen/klauseln/anmeldecode_daten.sql          # Daten
#   FREIRAUM_PRUEF_URL=http://localhost:8099 \
#   FREIRAUM_CODE_PFEFFER=... \
#   FREIRAUM_PRUEF_MAILFANG=/pfad/zu/mailfang.txt \
#   pruefungen/klauseln/anmeldecode_lauf.sh                        # Faelle
#
# Umgebung:
#   FREIRAUM_PRUEF_URL       Vorgabe http://localhost:8099
#   FREIRAUM_PRUEF_MAILFANG  PFLICHT -- Datei, in die der Mailfaenger
#                            jede versandte Mail schreibt (siehe
#                            pruefungen/lauf.sh Abschn. "Klausellauf").
#                            Ohne sie ist der versandte Code nicht
#                            lesbar und kein Fall dieser Scheibe misst
#                            etwas (F07).
#   PGHOST/PGPORT/PGUSER/PGPASSWORD/PGDATABASE
#                            Vorgabe localhost/55433/postgres/pilot/freiraum_pruef
#
# MASSSTAB F07: Vor dem ersten Fall wird der AUFBAU geprueft. Ein Fall,
# der an einem fehlenden Datensatz oder einer fremden Bedingung
# scheitert, misst nichts -- deshalb bricht der Lauf dann ab (Rueckgabe 2).
#
# WAS NICHT PRUEFBAR IST (aus der Klausel/dem Vertrag ableitbar) und
# darum hier NICHT behauptet wird:
#   (1) Der genaue WORTLAUT der Fehlermeldung auf /anmeldung steht --
#       anders als bei /einladung -- weder im Klauselregister noch im
#       Bildschirmvertrag woertlich. Gemessen wird darum Statuscode,
#       das Ausbleiben des Sitzungskekses und BYTEIDENTITAET zwischen
#       den Faellen (wie EL-16/AN-22) -- nicht ein bestimmter Text.
#   (2) Der dritte Fall aus EN-01 zustand_fehler ("Einmal-Link aelter
#       als 24 Stunden") ist hier NICHT nachgebaut: K19 fuehrt keinen
#       eigenen Bildschirm/keine eigene Aktion fuer die Einloesung
#       eines Einladungslinks, und der Vertragstext "Verbleib auf
#       EN-01" ist gegen den Schnittstellenzuschnitt (getrennte Routen
#       /einladung und /anmeldung, siehe einloesung_lauf.sh) nicht
#       eindeutig aufzuloesen -- welcher Endpunkt diesen dritten Fall
#       traegt, sagt der Vertrag nicht. Siehe Abschlussbericht.
#   (3) K03-G01s zweiter Ast ("nicht pruefbare Vorbedingung sperrt")
#       ist von aussen nicht auszuloesen -- geprueft wird nur der
#       erste Ast ("nicht erfuellte Vorbedingung sperrt", AC-04/AC-07).
#   (4) K03-M15 Satz 2 ("Ein neuer Code entwertet alle aelteren Codes
#       desselben Kontos") wird von keinem Fall dieser Scheibe ausgeloest:
#       kein Weg dieser Scheibe stellt fuer ein Konto einen ZWEITEN Code
#       aus (K20-D10 verhindert eine zweite erfolgreiche Einloesung
#       desselben Tokens; AC-14 misst genau das). Ob ein zweiter Code auf
#       einem anderen Weg entstehen kann, ist eine offene Entscheidung --
#       sie wird hier BENANNT, nicht getroffen (P6, 2026-08-14).
#   (5) K03-M26 (Codes und vollstaendige Adressen stehen nie in Logs;
#       Providerfehler wirken fail-closed und alarmieren den Betrieb) ist
#       mit diesem Harness STRUKTURELL nicht pruefbar: der Lauf sieht nur
#       HTTP-Antworten, die Datenbank und den Mailfang -- nie die
#       Serverausgabe/Logs. Ungemessen bedeutet hier: niemand hat
#       hingesehen, nicht "Codes stehen nie in Logs" ist geprueft
#       (P6, 2026-08-14).
#
# =====================================================================
# UEBERARBEITUNG 2026-08-14: Eine adversarische Gegenpruefung hat 24
# Funde bestaetigt. Der Anteil dieser Datei ist eingearbeitet:
#   S1 · Die Aufbaupruefung (F07) lief blind und meldete zugleich
#        Erfolg: den vier Teilabfragen fehlte ein Spaltenalias, dbz()
#        fing keine SQL-Fehler ab. Behoben (Alias + gehaertete
#        db()/dbz()).
#   S2 · AC-04/AC-07 pruefen jetzt die ANMELDESPUR (K03-G05:
#        last_login_at bleibt leer ohne bestaetigten Code; K03-M15:
#        login_code.consumed_at zeigt eine erfolgreiche Verwendung)
#        statt eines actor.status-Werts, der zwischen K20-M15 und
#        K03-M09 nicht eindeutig abzuleiten war.
#   P1 · AC-14 ergaenzt: Gegenstueck zu AC-01 -- eine NICHT erfolgreiche
#        Einloesung stellt keinen Code aus (K20-D10, K03-G01, K03-M15).
#   P2 · Hash-Gegenprobe (K03-M05) als Hilfsfunktion vor jede Messung in
#        AC-04, AC-06, AC-07, AC-08 gezogen. Schlaegt sie fehl, ist der
#        Fall GESPERRT, nicht bestanden.
#   P3 · AC-09 sperrt jetzt (statt zu scheitern), wenn AC-08 keinen
#        Vergleichsrumpf geliefert hat -- wie AC-12/AC-13.
#   P4 · ok/nok/sperr tragen jetzt ein Klauselargument; keine Meldung
#        kann die Klausel mehr vergessen.
#   P5 · AC-10 verengt auf object_ref=INVITATION:<id> und misst den
#        Uebergang VERSANDT->EINGELOEST mit; AC-11 zurueckgenommen auf
#        "handelnde Instanz gesetzt und aufloesbar" -- K20-M18 fordert
#        keine Selbstbedienung.
#   P6 · Siehe (4)/(5) oben; K03-M15 Satz 3 ("nur der Pruefwert wird
#        gespeichert") in AC-01 mitgemessen.
#   P7 · AC-03: ORDER BY/LIMIT ergaenzt, Fristtoleranz auf +/-1s verengt
#        (issued_at/expires_at werden im selben INSERT deterministisch
#        gesetzt), ungefilterte Gesamtzahl als eigene Bedingung ergaenzt.
#        AC-08/AC-09 von K03-M25 auf K03-M16 umgehaengt -- M25 handelt
#        vom Einladungsbefehl, nicht von der Anmeldung.
# =====================================================================
# NACHBESSERUNG 2026-08-14 (S3): Die S1-Haertung von db()/dbz() wirkte
# nicht. Gemessen mit einem Stub-psql, der auf stderr einen Fehler schreibt
# und mit 1 endet:
#   - jede der rund 40 Zuweisungen x="$(dbz ...)" ist eine Kommando-
#     substitution, also eine Unterschale. abbruch() rief darin exit 2 --
#     das beendet NUR die Unterschale. Der ABBRUCH-Text landete als
#     Zeichenkette in der Variable, das Skript lief mit Rueckgabe 0 weiter:
#     der SQL-Fehlertext wurde zum Messwert.
#   - "if dbz ... | grep -q 1" (F07, Zeile ~338): derselbe Effekt in einer
#     Pipe -- der ABBRUCH-Text fiel in die Pipe, "grep -q 1" traf auf
#     "LINE 1:" und nahm den FALSCHEN Zweig.
#   - die Erreichbarkeitspruefung rief abbruch() aus db() heraus auf,
#     dessen Ausgabe aber unter demselben ">/dev/null 2>&1" verschwand wie
#     der psql-Aufruf selbst -- eine nicht erreichbare Datenbank endete
#     STUMM.
# Neue Bauart: db()/dbz() rufen abbruch() nicht mehr selbst. Bei einem
# SQL-Fehler geben sie NICHTS auf stdout aus, schreiben den psql-Fehler-
# text nach stderr (sichtbar, faellt nie in eine Kommandosubstitution oder
# Pipe) und legen eine Markierungsdatei unter $ARBEIT an. Die Elternschale
# prueft diese Markierung mit pruefe_sql_marke() an den Stellen, an denen
# ein falscher Wert Schaden anrichten wuerde -- dort wirkt exit, weil
# pruefe_sql_marke NICHT in einer Unterschale laeuft.
# =====================================================================

BASIS="${FREIRAUM_PRUEF_URL:-http://localhost:8099}"

: "${PGHOST:=localhost}"
: "${PGPORT:=55433}"
: "${PGUSER:=postgres}"
: "${PGPASSWORD:=pilot}"
: "${PGDATABASE:=freiraum_pruef}"
export PGHOST PGPORT PGUSER PGPASSWORD PGDATABASE

TOK_KETTE='tok-ac-kette-3f7b1d9a4c6e0281'
TOK_FRIST='tok-ac-frist-8b2e5f1a7c4d0392'
TOK_UNTERSCHWELLE='tok-ac-unterschwelle-1d4a7f2b8c5e0493'
TOK_GESPERRT5='tok-ac-gesperrt5-6c9e2b5f8a1d0594'
TOK_GEGENPROBE='tok-ac-gegenprobe-4a7d1f8b2c5e0695'

E_KETTE='ac_kette@pruef.example'
E_FRIST='ac_frist@pruef.example'
E_UNTERSCHWELLE='ac_unterschwelle@pruef.example'
E_GESPERRT5='ac_gesperrt5@pruef.example'
E_GEGENPROBE='ac_gegenprobe@pruef.example'
E_UNBEKANNT='ac_unbekannt@pruef.example'

ARBEIT="$(mktemp -d "${TMPDIR:-/tmp}/freiraum_anmeldecode.XXXXXX")"
trap 'rm -rf "$ARBEIT"' EXIT

gesamt=0; bestanden=0; gescheitert=0; gesperrt=0

# P4 (2026-08-14): ok/nok/sperr tragen jetzt ein Klauselargument ($2) --
# vorher trug nur der ok-Text gelegentlich eine Klausel, GESCHEITERT- und
# GESPERRT-Zeilen nie. pruefungen/lauf.sh sammelt aber ausschliesslich
# diese beiden Zeilenarten ein (siehe Abschn. "Klausel-Prueffaelle"
# dort); ein roter Nachweis ohne Klauselreferenz war damit unvollstaendig.
ok()  { gesamt=$((gesamt+1)); bestanden=$((bestanden+1))
        printf '%-7s BESTANDEN    [%s] %s\n' "$1" "$2" "$3"; }
nok() { gesamt=$((gesamt+1)); gescheitert=$((gescheitert+1))
        printf '%-7s GESCHEITERT  [%s] %s\n' "$1" "$2" "$(printf '%s' "$3" | tr '\n' ' ')"; }
# K23-M22: Was nicht gemessen werden konnte, ist GESPERRT -- nicht
# bestanden. Es zaehlt zu den gescheiterten Faellen: ein Lauf, der
# nichts gemessen hat, ist kein gruener Lauf.
sperr() { gesamt=$((gesamt+1)); gescheitert=$((gescheitert+1)); gesperrt=$((gesperrt+1))
        printf '%-7s GESPERRT     [%s] %s\n' "$1" "$2" "$(printf '%s' "$3" | tr '\n' ' ')"; }

abbruch() { printf 'ABBRUCH: %s\n' "$1"; printf 'SUMME: 0 von 0 bestanden, 0 gescheitert\n'; exit 2; }

# S1 (2026-08-14): db()/dbz() fingen bisher nur stdout ab. Schlug die SQL
# fehl (z.B. eine Spalte, die es wegen eines fehlenden Alias gar nicht
# gibt), blieb stdout leer -- ein "[ -z ... ]"-Test las das als "alles in
# Ordnung". Genau so lief die F07-Aufbaupruefung blind und meldete
# zugleich Erfolg.
#
# S3 (2026-08-14): die S1-Fassung rief bei einem SQL-Fehler abbruch() DIREKT
# aus db()/dbz() heraus auf. Das wirkt nicht, sobald db()/dbz() in einer
# Kommandosubstitution oder Pipe laeuft (siehe Nachbesserung im Dateikopf) --
# exit in einer Unterschale beendet nur die Unterschale. Neue Bauart: bei
# einem SQL-Fehler geben beide Funktionen NICHTS auf stdout aus, schreiben
# den psql-Fehlertext nach stderr (sichtbar, unabhaengig von Unterschale/
# Pipe) und legen die Markierungsdatei $ARBEIT/sql.marke an. Kein abbruch()
# mehr hier -- das erledigt die Elternschale ueber pruefe_sql_marke().
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
        printf '%s' "$aus" | head -1; }

# S3 (2026-08-14): wird direkt in der Elternschale aufgerufen (NIE in einer
# Kommandosubstitution) -- nur dort beendet abbruch()s exit den ganzen Lauf.
# Aufruf mindestens: nach der Erreichbarkeitspruefung, nach der F07-
# Aufbaupruefung und am Ende jedes Fallblocks (siehe AC-01 bis AC-14).
pruefe_sql_marke() {
  if [ -s "$ARBEIT/sql.marke" ]; then
    abbruch "$(cat "$ARBEIT/sql.marke")"
  fi
}

# ---------------------------------------------------------------------
# Werkzeug
# ---------------------------------------------------------------------
saeubere_kopf() { tr -d '\r' < "$1" > "$1.rein" && mv "$1.rein" "$1"; }

hole() {             # $1 pfad  $2 name
  local p="$ARBEIT/$2" st
  st=$(curl -sS -o "$p.rumpf" -D "$p.kopf" -w '%{http_code}' --max-time 25 \
        "$BASIS$1" 2>"$p.fehler") || st="000"
  [ -f "$p.kopf" ] && saeubere_kopf "$p.kopf"
  printf '%s' "$st"
}

post_einladung() {   # $1 token  $2 name
  local p="$ARBEIT/$2" st
  st=$(curl -sS -o "$p.rumpf" -D "$p.kopf" -w '%{http_code}' --max-time 25 \
        --data-urlencode "token=$1" \
        "$BASIS/einladung" 2>"$p.fehler") || st="000"
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

kopfzeile()    { grep -i "^$2:" "$ARBEIT/$1.kopf" 2>/dev/null | head -1 \
                 | sed "s/^[^:]*:[[:space:]]*//"; }
sitzungswert() { grep -i '^set-cookie:[[:space:]]*fr_sitzung=' "$ARBEIT/$1.kopf" 2>/dev/null | head -1 \
                 | sed 's/^[^=]*=//' | cut -d';' -f1; }
rumpf()        { printf '%s' "$ARBEIT/$1.rumpf"; }
hat_text()     { grep -qF "$2" "$ARBEIT/$1.rumpf" 2>/dev/null; }

# Ein Rumpf, aus dem alles entfernt ist, was sich zwischen zwei
# rechtmaessig verschiedenen Faellen unterscheiden darf: Adressen und
# sechsstellige Codes. Was danach noch verschieden ist, unterscheidet
# die Faelle -- und genau das darf K03-G01/K03-M16 nicht zulassen.
normiere() {
  sed -e 's/[A-Za-z0-9._%+-]*@pruef\.example/ADRESSE/g' \
      -e 's/\b[0-9]\{6\}\b/CODE/g' \
      -e 's/[[:space:]][[:space:]]*/ /g' "$1"
}

# Liest den zuletzt an $1 versandten sechsstelligen Code aus dem
# Mailfang. Der Mailfaenger (pruefungen/lauf.sh) entpackt jede Mail und
# haengt Kopf+Rumpf, getrennt durch "--- Ende der Nachricht ---", an.
code_aus_mail() {   # $1 Adresse
  python3 - "$FREIRAUM_PRUEF_MAILFANG" "$1" <<'PY'
import re, sys
pfad, adresse = sys.argv[1], sys.argv[2].lower()
try:
    text = open(pfad, encoding="utf-8", errors="replace").read()
except FileNotFoundError:
    print(""); sys.exit(0)
treffer = ""
for block in text.split("--- Ende der Nachricht ---"):
    trenner = block.find("\n\n")
    kopf = block[:trenner] if trenner != -1 else ""
    rumpf = block[trenner:] if trenner != -1 else block
    an_diese_adresse = any(
        zeile.lower().startswith("to:") and adresse in zeile.lower()
        for zeile in kopf.splitlines()
    )
    if an_diese_adresse:
        gefunden = re.findall(r"\b\d{6}\b", rumpf)
        if gefunden:
            treffer = gefunden[-1]
print(treffer)
PY
}

# P1 (2026-08-14): Zaehlt, wie viele im Mailfang stehende Nachrichten an
# $1 adressiert sind -- dieselbe Blockzerlegung wie code_aus_mail (siehe
# dort). Traeger fuer AC-14 (Gegenstueck zu AC-01: eine NICHT erfolgreiche
# Einloesung darf keine weitere Mail zur Folge haben).
mail_anzahl() {   # $1 Adresse
  python3 - "$FREIRAUM_PRUEF_MAILFANG" "$1" <<'PY'
import sys
pfad, adresse = sys.argv[1], sys.argv[2].lower()
try:
    text = open(pfad, encoding="utf-8", errors="replace").read()
except FileNotFoundError:
    print(0); sys.exit(0)
n = 0
for block in text.split("--- Ende der Nachricht ---"):
    trenner = block.find("\n\n")
    kopf = block[:trenner] if trenner != -1 else ""
    an_diese_adresse = any(
        zeile.lower().startswith("to:") and adresse in zeile.lower()
        for zeile in kopf.splitlines()
    )
    if an_diese_adresse:
        n += 1
print(n)
PY
}

# P2 (2026-08-14): Rechnet den aus dem Mailfang gelesenen Klartext-Code
# gegen den gespeicherten Pruefwert in login_code nach (K03-M05:
# "Gespeichert wird nur sein kryptografischer Pruefwert"). Vorher
# rechnete nur AC-01 nach; AC-04/AC-06/AC-07/AC-08 pruefen den gelesenen
# Code nur gegen ^[0-9]{6}$ -- ein falsch gelesener Code (der Leser
# nimmt die LETZTE sechsstellige Ziffernfolge im Mailrumpf) liesse diese
# Faelle unter "ein falscher Code traegt nicht" bestehen, statt ihre
# eigene Klausel zu messen. Schlaegt die Gegenprobe fehl, ist der Fall
# GESPERRT, nicht gescheitert -- der Aufbau ist dann nicht zuverlaessig,
# nicht die Klausel verletzt.
code_stimmt_gegen_hash() {   # $1 actor_id  $2 Klartext-Code
  local treffer
  treffer="$(dbz "SELECT count(*) FROM login_code WHERE actor_id='$1'
                    AND code_hash = pruef_codewert('$2', '$FREIRAUM_CODE_PFEFFER')")"
  [ "${treffer:-0}" -ge 1 ]
}

# ---------------------------------------------------------------------
# Vorpruefung: Werkzeug, Server, Datenlage (F07)
# ---------------------------------------------------------------------
command -v curl    >/dev/null 2>&1 || abbruch 'curl fehlt.'
command -v psql    >/dev/null 2>&1 || abbruch 'psql fehlt.'
command -v python3 >/dev/null 2>&1 || abbruch 'python3 fehlt (Mailfang-Auslesung).'

# S3 (2026-08-14): kein "2>&1" mehr auf diesen Aufruf -- das hat vorher die
# eigene Diagnosemeldung von db() (jetzt auf stderr) mit demselben
# ">/dev/null" verschluckt, das nur den psql-Aufruf selbst stummschalten
# soll. Eine nicht erreichbare Datenbank endete dadurch STUMM mit
# Rueckgabe 2 -- jetzt steht wieder ein Satz da (Diagnose von db() plus der
# nachgestellte abbruch()-Text).
db 'SELECT 1' >/dev/null || abbruch "Datenbank $PGDATABASE auf $PGHOST:$PGPORT nicht erreichbar."

[ -n "${FREIRAUM_CODE_PFEFFER:-}" ] || abbruch 'FREIRAUM_CODE_PFEFFER ist nicht gesetzt -- derselbe Wert wie am Server ist noetig.'
case "$FREIRAUM_CODE_PFEFFER" in *"'"*) abbruch "FREIRAUM_CODE_PFEFFER enthaelt ein Hochkomma; das Pruefskript kann es nicht sicher in SQL setzen.";; esac

[ -n "${FREIRAUM_PRUEF_MAILFANG:-}" ] || abbruch 'FREIRAUM_PRUEF_MAILFANG ist nicht gesetzt -- ohne Zugriff auf die versandte Mail ist der Anmeldecode nicht lesbar, kein Fall dieser Scheibe misst dann etwas.'

if [ "$(hole /gesundheit vorpruefung)" != "200" ]; then
  abbruch "Server unter $BASIS antwortet nicht auf GET /gesundheit. Erst starten, dann pruefen."
fi

lage="$(dbz "SELECT count(*) FROM pg_views WHERE viewname='pruef_anmeldecode_lage'")"
# S3 (2026-08-14): schlaegt dbz() hier fehl, ist $lage leer -- ohne diese
# Pruefung wuerde das als "Sicht fehlt" gemeldet statt mit dem echten
# SQL-Fehler.
pruefe_sql_marke
[ "$lage" = "1" ] || abbruch 'Sicht pruef_anmeldecode_lage fehlt -- anmeldecode_daten.sql zuerst einspielen.'

# AUFBAUPRUEFUNG (F07): dieselben Bedingungen wie in anmeldecode_daten.sql,
# hier aber unmittelbar vor dem Lauf.
#
# S1 (2026-08-14): jede der vier Teilabfragen bekommt jetzt "AS m" -- ohne
# Alias hiess die Ergebnisspalte "?column?", string_agg(m, ' ') griff auf
# eine Spalte, die es so nicht gab, psql brach mit Fehler ab, und die
# UNGEHAERTETE dbz() (siehe oben) hat diesen Fehler bis heute verschluckt:
# leeres stdout, "[ -z "$aufbau" ]" liest das als "alles in Ordnung". Die
# Aufbaupruefung lief damit blind und meldete zugleich Erfolg.
aufbau="$(dbz "
SELECT string_agg(m, ' ') FROM (
  SELECT email || ':invitation_status=' || invitation_status AS m FROM pruef_anmeldecode_lage
   WHERE invitation_status <> 'VERSANDT' OR NOT noch_offen_frist OR redeemed_at IS NOT NULL
  UNION ALL
  SELECT email || ':actor_status=' || actor_status AS m FROM pruef_anmeldecode_lage
   WHERE actor_status <> 'WARTET_2FA' OR last_login_at IS NOT NULL
  UNION ALL
  SELECT email || ':codes_gesamt=' || codes_gesamt AS m FROM pruef_anmeldecode_lage
   WHERE codes_gesamt <> 0
  UNION ALL
  SELECT email || ':freigeschaltete_portale=' || freigeschaltete_portale AS m FROM pruef_anmeldecode_lage
   WHERE freigeschaltete_portale <> 1
) t")"
# S3 (2026-08-14): schlaegt dbz() hier fehl, ist $aufbau leer -- ohne diese
# Pruefung wuerde das faelschlich als "Aufbau in Ordnung" durchgehen (wieder
# der urspruengliche S1-Befund, nur an anderer Stelle).
pruefe_sql_marke
[ -z "$aufbau" ] || abbruch "Datenlage taugt nicht (F07): $aufbau -- anmeldecode_daten.sql neu einspielen."

# S3 (2026-08-14): dbz() gibt bei einem SQL-Fehler jetzt NICHTS auf stdout
# aus (siehe Haertung oben) -- "grep -q 1" bekommt dann eine leere Eingabe,
# trifft nicht, der Zweig wird korrekt NICHT genommen. Vorher fiel der
# ABBRUCH-Text der alten db()/dbz()-Fassung in die Pipe, "grep -q 1" traf
# auf "LINE 1:" und nahm den FALSCHEN Zweig. pruefe_sql_marke faengt den
# echten Fehler danach ab.
if dbz "SELECT 1 FROM actor WHERE email='$E_UNBEKANNT'" | grep -q 1; then
  abbruch "$E_UNBEKANNT existiert als Konto -- AC-09 misst dann nichts (F07)."
fi
pruefe_sql_marke

printf 'FREIRAUM · Scheibe · Anmeldecode nach Einloesung — Klauselpruefung gegen %s\n' "$BASIS"
printf 'Datenlage: %s auf %s:%s · Aufbaupruefung (F07) bestanden · Mailfang: %s\n\n' \
       "$PGDATABASE" "$PGHOST" "$PGPORT" "$FREIRAUM_PRUEF_MAILFANG"

# =====================================================================
# AC-01 · Grundlage der Scheibe (Vertrag EN-01: "Code per E-Mail",
#         Ausloeser aus dem Vertragswortlaut abgeleitet, siehe Kopf
#         dieser Datei) · Erfolgreiche Einloesung der Einladung loest
#         den Versand eines Anmeldecodes aus. Ohne diesen Fall ist die
#         Kette Einladung -> Code -> Anmeldung nicht geschlossen und
#         KEIN weiterer Fall dieser Datei kann etwas messen.
# =====================================================================
zeitmarke_ac01="$(dbz "SELECT now()::text")"
st=$(post_einladung "$TOK_KETTE" ac01)
ziel="$(kopfzeile ac01 location)"
kette_id="$(dbz "SELECT id::text FROM actor WHERE email='$E_KETTE'")"
kette_invid="$(dbz "SELECT id::text FROM invitation WHERE actor_id='$kette_id'")"
m=""
[ "$st" = "303" ] || m="$m Status $st statt 303 auf die Einloesung selbst;"
case "$ziel" in *"/anmeldung"*) : ;; *) m="$m Location '$ziel' zeigt nicht auf /anmeldung;";; esac
offene_codes=""
if [ -n "$kette_id" ]; then
  offene_codes="$(dbz "SELECT count(*) FROM login_code WHERE actor_id='$kette_id'
                          AND consumed_at IS NULL AND superseded_at IS NULL AND expires_at > now()")"
fi
[ "${offene_codes:-0}" = "1" ] || m="$m nach der Einloesung steht kein offener, fristgerechter login_code fuer $E_KETTE (gefunden: ${offene_codes:-0});"
CODE_KETTE="$(code_aus_mail "$E_KETTE")"
if [ -z "$CODE_KETTE" ] || ! printf '%s' "$CODE_KETTE" | grep -Eq '^[0-9]{6}$'; then
  m="$m im Mailfang steht keine sechsstellige Ziffernfolge in einer Mail an $E_KETTE;"
else
  hash_treffer="$(dbz "SELECT count(*) FROM login_code WHERE actor_id='$kette_id'
                          AND code_hash = pruef_codewert('$CODE_KETTE', '$FREIRAUM_CODE_PFEFFER')")"
  [ "${hash_treffer:-0}" = "1" ] || m="$m der aus der Mail gelesene Code passt nicht zum gespeicherten Pruefwert in login_code;"
  # P6 (2026-08-14) K03-M15 Satz 3 ("Gespeichert wird nur sein
  # kryptografischer Pruefwert") -- billig nachrechenbar: der Klartext-Code
  # selbst darf in KEINER login_code.code_hash-Spalte auftauchen.
  klartext_gespeichert="$(dbz "SELECT count(*) FROM login_code WHERE code_hash = '$CODE_KETTE'")"
  [ "${klartext_gespeichert:-0}" = "0" ] || m="$m login_code.code_hash enthaelt den Klartext-Code selbst statt nur seinen Pruefwert (K03-M15 Satz 3);"
fi
[ -z "$m" ] && ok AC-01 "EN-01, K03-M05, K03-M15" "Erfolgreiche Einloesung (POST /einladung) versendet einen sechsstelligen Anmeldecode per E-Mail: offener login_code entsteht, der gemailte Code passt zum gespeicherten Pruefwert und steht nirgends im Klartext (Vertrag EN-01: Code per E-Mail; K03-M05; K03-M15 Satz 3)" \
            || nok AC-01 "EN-01, K03-M05, K03-M15" "Codeversand nach Einloesung:$m"
# S3 (2026-08-14): am Ende jedes Fallblocks -- ein SQL-Fehler in einer der
# dbz()-Zuweisungen oben darf nicht als leerer/falscher Messwert durchgehen.
pruefe_sql_marke

# =====================================================================
# AC-02 · POSITIVKONTROLLE + M2 · Mit dem soeben per E-Mail versandten
#         Code kann sich der Eingeladene anmelden. Das ist der zweite
#         und letzte Schritt der geschlossenen Kette -- Meilenstein M2
#         ("Ein Eingeladener kann sich anmelden") wird hiermit ERSTMALS
#         end-to-end durchlaufen. Zugleich Positivfall fuer die
#         Einmalverwendung: die ERSTE Verwendung des Codes traegt
#         (K03-M15, EN-01 zustand_erfolg).
# =====================================================================
if [ -z "$CODE_KETTE" ]; then
  sperr AC-02 "EN-01, K03-M15" 'Anmeldung mit dem versandten Code nicht pruefbar: AC-01 hat keinen lesbaren Code geliefert'
else
  st=$(post_anmeldung "$E_KETTE" "$CODE_KETTE" ac02)
  keks="$(sitzungswert ac02)"
  ziel="$(kopfzeile ac02 location)"
  m=""
  [ "$st" = "303" ] || m="$m Status $st statt 303;"
  case "$ziel" in "/"|"$BASIS/") : ;; *) m="$m Location '$ziel' fuehrt nicht auf /;";; esac
  [ -n "$keks" ] || m="$m kein Sitzungskeks fr_sitzung gesetzt;"
  [ -z "$m" ] && ok AC-02 "EN-01, K03-M15" "Mit dem per E-Mail versandten Code meldet sich der Eingeladene an: 303 auf /, Sitzungskeks gesetzt -- die Kette Einladung -> Code -> Anmeldung ist durchgehend bedienbar (M2; EN-01 zustand_erfolg; K03-M15 Einmalverwendung, erste Verwendung)" \
              || nok AC-02 "EN-01, K03-M15" "Anmeldung mit dem versandten Code:$m"
fi
pruefe_sql_marke  # S3 (2026-08-14): siehe AC-01.

# =====================================================================
# AC-03 · K03-M15 / EN-01 Codefrist (positiv) · Der beim Einloesen
#         versandte Code traegt eine Zehn-Minuten-Frist -- geprueft am
#         tatsaechlich entstandenen login_code, nicht an einem
#         vorgegebenen Wert.
# =====================================================================
fenster_sek="$(dbz "SELECT extract(epoch from (expires_at - issued_at))::text FROM login_code
                      WHERE actor_id='$kette_id' ORDER BY issued_at DESC LIMIT 1")"
# BERICHTIGT AM 14.08.2026 (gemessen im ersten echten Lauf): hier stand
# ")::text". psql rendert einen Wahrheitswert ohne Umwandlung als "t", MIT
# Umwandlung als "true". Der Vergleich unten gegen "t" konnte deshalb NIE
# zutreffen -- AC-03 war ein falsches Negativ und haette den Bau zu Unrecht
# beschuldigt. Ohne ::text wie in pruefungen/klauseln/versand_lauf.sh:244.
issued_frisch="$(dbz "SELECT (issued_at > now() - interval '5 minutes') FROM login_code
                        WHERE actor_id='$kette_id' ORDER BY issued_at DESC LIMIT 1")"
# P7 (2026-08-14): Gesamtzahl OHNE Filter als eigene Bedingung -- getrennt
# von den bereits woanders gefilterten Zaehlungen (z.B. "offen" in AC-01).
gesamtzahl_ac03="$(dbz "SELECT count(*) FROM login_code WHERE actor_id='$kette_id'")"
m=""
if [ -z "$fenster_sek" ]; then
  m="$m kein login_code fuer $E_KETTE gefunden;"
else
  # P7 (2026-08-14): issued_at UND expires_at werden im selben INSERT per
  # DEFAULT now() gesetzt (migrations/M30 Z.195/197) -- deterministisch,
  # keine Uhrendrift zwischen zwei Spalten. Toleranz darum eng: 1s statt 15s.
  passt="$(python3 -c "print(1 if abs(float('${fenster_sek:-0}')-600.0)<=1 else 0)" 2>/dev/null)"
  [ "$passt" = "1" ] || m="$m Fristfenster ist ${fenster_sek}s, erwartet 600s +/-1s (K03-M15: zehn Minuten, deterministisch gesetzt);"
fi
[ "$issued_frisch" = "t" ] || m="$m issued_at liegt nicht in der juengsten Vergangenheit;"
[ "${gesamtzahl_ac03:-0}" = "1" ] || m="$m login_code-Gesamtzahl (ohne Filter) fuer $E_KETTE ist ${gesamtzahl_ac03:-0} statt 1;"
[ -z "$m" ] && ok AC-03 "K03-M15, EN-01" "Der durch die Einloesung versandte Code ist zehn Minuten gueltig (Fristfenster ${fenster_sek}s), genau ein login_code steht insgesamt fuer das Konto (K03-M15, EN-01 Codefrist)" \
            || nok AC-03 "K03-M15, EN-01" "Codefrist:$m"
pruefe_sql_marke  # S3 (2026-08-14): siehe AC-01.

# =====================================================================
# AC-04 · K03-M15 / EN-01 Codefrist / K03-G01 (fail-closed) ·
#         -- erwartet: code_abgelaufen --
#         Ein eigenes Konto (ac_frist@), eigene Einloesung, eigener
#         Code -- dessen Frist wird anschliessend auf "abgelaufen"
#         gesetzt (dieselbe Zeitreise-Technik wie AN-18). Verletzt ist
#         NUR die Frist; alles andere an diesem Code ist tadellos.
# =====================================================================
st=$(post_einladung "$TOK_FRIST" ac04a)
frist_id="$(dbz "SELECT id::text FROM actor WHERE email='$E_FRIST'")"
CODE_FRIST="$(code_aus_mail "$E_FRIST")"
if [ "$st" != "303" ] || [ -z "$CODE_FRIST" ] || ! printf '%s' "$CODE_FRIST" | grep -Eq '^[0-9]{6}$'; then
  sperr AC-04 "K03-M15, EN-01, K03-G01, K03-G05" "Codefrist-Negativfall nicht aufbaubar: Einloesung fuer $E_FRIST schlug fehl oder kein lesbarer Code (Status $st, Code '${CODE_FRIST:-leer}')"
elif ! code_stimmt_gegen_hash "$frist_id" "$CODE_FRIST"; then
  # P2 (2026-08-14): Ohne diese Gegenprobe wuerde ein falsch gelesener Code
  # AC-04 unter "ein falscher Code traegt nicht" bestehen lassen statt K03-M15
  # zu messen -- darum sperr, nicht nok: der Aufbau ist unzuverlaessig, nicht
  # die Klausel verletzt.
  sperr AC-04 "K03-M15, EN-01, K03-G01, K03-G05" "Codefrist-Negativfall nicht messbar: der aus dem Mailfang gelesene Code passt nicht zum gespeicherten Pruefwert in login_code fuer $E_FRIST"
else
  db "UPDATE login_code SET issued_at = now() - interval '20 minutes', expires_at = now() - interval '10 minutes' WHERE actor_id='$frist_id'" >/dev/null
  st2=$(post_anmeldung "$E_FRIST" "$CODE_FRIST" ac04b)
  keks2="$(sitzungswert ac04b)"
  # S2 (2026-08-14): actor.status ist zwischen K20-M15 ("Nach der Einloesung
  # MUSS das Konto ... auf AKTIV wechseln") und K03-M09 (der Uebergang
  # entsteht AUSSCHLIESSLICH aus einer bestaetigten zweiten Stufe) nicht
  # eindeutig ableitbar -- ein klauselkonformer Stand koennte hier je nach
  # Lesart WARTET_2FA oder AKTIV zeigen. Gemessen wird darum die
  # ANMELDESPUR selbst, ein unbestrittener Traeger: K03-G05 haelt
  # last_login_at leer, solange kein Code bestaetigt wurde; login_code.
  # consumed_at zeigt eine erfolgreiche Verwendung.
  anmeldespur="$(dbz "SELECT (a.last_login_at IS NULL)::text || '|' ||
                             (count(c.id) FILTER (WHERE c.consumed_at IS NOT NULL))::text
                        FROM actor a LEFT JOIN login_code c ON c.actor_id = a.id
                       WHERE a.id='$frist_id' GROUP BY a.last_login_at")"
  m=""
  [ "$st2" = "200" ] || m="$m Status $st2 statt 200 (kein Erfolg erwartet);"
  [ -z "$keks2" ] || m="$m trotz abgelaufenem Code wurde ein Sitzungskeks gesetzt;"
  [ "$anmeldespur" = "true|0" ] || m="$m Anmeldespur $anmeldespur -- ein abgelaufener Code hat eine Anmeldung bewirkt;"
  [ -z "$m" ] && ok AC-04 "K03-M15, EN-01, K03-G01, K03-G05" "Ein Code, dessen Zehn-Minuten-Frist um ist, traegt nicht mehr: keine Sitzung, keine Anmeldespur -- last_login_at bleibt leer, kein login_code als verbraucht markiert (K03-M15, EN-01 Codefrist, fail-closed K03-G01, K03-G05)" \
              || nok AC-04 "K03-M15, EN-01, K03-G01, K03-G05" "Codefrist abgelaufen -- erwartet: code_abgelaufen:$m"
fi
pruefe_sql_marke  # S3 (2026-08-14): siehe AC-01.

# =====================================================================
# AC-05 · K03-M15 / EN-01 Einmalverwendung -- erwartet: code_bereits_verwendet --
#         Derselbe Code, der AC-02 gerade getragen hat, wird ein
#         zweites Mal eingereicht. Alles andere an diesem Code war
#         tadellos (AC-02 hat es bewiesen, inklusive Hash-Gegenprobe in
#         AC-01); verletzt ist NUR die Einmaligkeit.
# =====================================================================
if [ -z "$CODE_KETTE" ]; then
  sperr AC-05 "K03-M15, EN-01" 'Einmalverwendung nicht pruefbar: AC-01/AC-02 haben keinen verwendbaren Code geliefert'
else
  st=$(post_anmeldung "$E_KETTE" "$CODE_KETTE" ac05)
  keks="$(sitzungswert ac05)"
  m=""
  [ "$st" = "200" ] || m="$m Status $st statt 200 (kein zweiter Erfolg erwartet);"
  [ -z "$keks" ] || m="$m der bereits verwendete Code hat ein zweites Mal einen Sitzungskeks gesetzt;"
  [ -z "$m" ] && ok AC-05 "K03-M15, EN-01" "Der bereits verwendete Code traegt kein zweites Mal, obwohl seine Zehn-Minuten-Frist noch liefe (K03-M15, EN-01 Einmalverwendung)" \
              || nok AC-05 "K03-M15, EN-01" "Wiederverwendung -- erwartet: code_bereits_verwendet:$m"
fi
pruefe_sql_marke  # S3 (2026-08-14): siehe AC-01.

# =====================================================================
# AC-06 · K03-M16 (positiv, Gegenprobe) · Vier falsche Codes sperren
#         NOCH NICHT -- der richtige Code traegt danach weiterhin. Ohne
#         diese Gegenprobe bestuende ein Programm, das nach dem ersten
#         Fehlversuch bereits alles sperrt, den Negativfall AC-07
#         ebenso wie ein korrektes.
# =====================================================================
st=$(post_einladung "$TOK_UNTERSCHWELLE" ac06a)
unterschwelle_id="$(dbz "SELECT id::text FROM actor WHERE email='$E_UNTERSCHWELLE'")"
CODE_UNTERSCHWELLE="$(code_aus_mail "$E_UNTERSCHWELLE")"
if [ "$st" != "303" ] || [ -z "$CODE_UNTERSCHWELLE" ] || ! printf '%s' "$CODE_UNTERSCHWELLE" | grep -Eq '^[0-9]{6}$'; then
  sperr AC-06 "K03-M16" "Gegenprobe zu K03-M16 nicht aufbaubar: Einloesung fuer $E_UNTERSCHWELLE schlug fehl oder kein lesbarer Code"
elif ! code_stimmt_gegen_hash "$unterschwelle_id" "$CODE_UNTERSCHWELLE"; then
  # P2 (2026-08-14): siehe AC-04.
  sperr AC-06 "K03-M16" "Gegenprobe zu K03-M16 nicht messbar: der aus dem Mailfang gelesene Code passt nicht zum gespeicherten Pruefwert in login_code fuer $E_UNTERSCHWELLE"
else
  falsch='000000'; [ "$falsch" = "$CODE_UNTERSCHWELLE" ] && falsch='111111'
  m=""
  i=1
  while [ $i -le 4 ]; do
    stf=$(post_anmeldung "$E_UNTERSCHWELLE" "$falsch" "ac06f$i")
    keksf="$(sitzungswert "ac06f$i")"
    [ "$stf" = "200" ] || m="$m Fehlversuch $i: Status $stf statt 200;"
    [ -z "$keksf" ] || m="$m Fehlversuch $i hat faelschlich einen Sitzungskeks gesetzt;"
    i=$((i+1))
  done
  st5=$(post_anmeldung "$E_UNTERSCHWELLE" "$CODE_UNTERSCHWELLE" ac06richtig)
  keks5="$(sitzungswert ac06richtig)"
  [ "$st5" = "303" ] || m="$m der richtige Code traegt nach vier Fehlversuchen nicht mehr (Status $st5 statt 303);"
  [ -n "$keks5" ] || m="$m der richtige Code setzt nach vier Fehlversuchen keinen Sitzungskeks;"
  [ -z "$m" ] && ok AC-06 "K03-M16" "Vier falsche Codes sperren noch nicht -- der richtige Code traegt danach weiterhin (Gegenprobe zu K03-M16)" \
              || nok AC-06 "K03-M16" "Unterschwellige Fehlversuche:$m"
fi
pruefe_sql_marke  # S3 (2026-08-14): siehe AC-01.

# =====================================================================
# AC-07 · K03-M16 -- erwartet: nach_fuenf_fehlversuchen_gesperrt --
#         Nach FUENF falschen Codes wird der Code ungueltig; auch der
#         richtige Code traegt danach nicht mehr (15 Minuten Drosselung).
# =====================================================================
st=$(post_einladung "$TOK_GESPERRT5" ac07a)
gesperrt5_id="$(dbz "SELECT id::text FROM actor WHERE email='$E_GESPERRT5'")"
CODE_GESPERRT5="$(code_aus_mail "$E_GESPERRT5")"
if [ "$st" != "303" ] || [ -z "$CODE_GESPERRT5" ] || ! printf '%s' "$CODE_GESPERRT5" | grep -Eq '^[0-9]{6}$'; then
  sperr AC-07 "K03-M16, K03-G05" "Fuenf-Fehlversuche-Sperre nicht aufbaubar: Einloesung fuer $E_GESPERRT5 schlug fehl oder kein lesbarer Code"
elif ! code_stimmt_gegen_hash "$gesperrt5_id" "$CODE_GESPERRT5"; then
  # P2 (2026-08-14): siehe AC-04.
  sperr AC-07 "K03-M16, K03-G05" "Fuenf-Fehlversuche-Sperre nicht messbar: der aus dem Mailfang gelesene Code passt nicht zum gespeicherten Pruefwert in login_code fuer $E_GESPERRT5"
else
  falsch='000000'; [ "$falsch" = "$CODE_GESPERRT5" ] && falsch='111111'
  m=""
  i=1
  while [ $i -le 5 ]; do
    stf=$(post_anmeldung "$E_GESPERRT5" "$falsch" "ac07f$i")
    keksf="$(sitzungswert "ac07f$i")"
    [ -z "$keksf" ] || m="$m Fehlversuch $i hat faelschlich einen Sitzungskeks gesetzt;"
    i=$((i+1))
  done
  st6=$(post_anmeldung "$E_GESPERRT5" "$CODE_GESPERRT5" ac07richtig)
  keks6="$(sitzungswert ac07richtig)"
  [ "$st6" = "200" ] || m="$m nach fuenf Fehlversuchen traegt der richtige Code noch (Status $st6 statt 200);"
  [ -z "$keks6" ] || m="$m nach fuenf Fehlversuchen setzt der richtige Code trotzdem einen Sitzungskeks;"
  # S2 (2026-08-14): siehe AC-04 -- Anmeldespur statt actor.status.
  anmeldespur7="$(dbz "SELECT (a.last_login_at IS NULL)::text || '|' ||
                              (count(c.id) FILTER (WHERE c.consumed_at IS NOT NULL))::text
                         FROM actor a LEFT JOIN login_code c ON c.actor_id = a.id
                        WHERE a.id='$gesperrt5_id' GROUP BY a.last_login_at")"
  [ "$anmeldespur7" = "true|0" ] || m="$m Anmeldespur $anmeldespur7 -- trotz Fuenf-Fehlversuche-Sperre hat eine Anmeldung gewirkt;"
  [ -z "$m" ] && ok AC-07 "K03-M16, K03-G05" "Nach fuenf falschen Codes ist der Code ungueltig -- auch der richtige Code traegt danach nicht mehr, keine Anmeldespur entsteht (K03-M16, K03-G05)" \
              || nok AC-07 "K03-M16, K03-G05" "Fuenf Fehlversuche -- erwartet: nach_fuenf_fehlversuchen_gesperrt:$m"
fi
pruefe_sql_marke  # S3 (2026-08-14): siehe AC-01.

# =====================================================================
# AC-08 · K03-M16 + K03-G01 (positiv, Gegenprobe) · Ein bestehendes,
#         frisch eingeloestes Konto (ac_gegenprobe@) mit falschem Code
#         wird korrekt abgewiesen -- strukturell wie ein unbekanntes
#         Konto (AC-09), kein Erfolg, kein Sitzungskeks. Der Rumpf wird
#         fuer AC-09, AC-12 und AC-13 aufgehoben.
#
#         P7 (2026-08-14): vorher an K03-M25 gehaengt. K03-M25 handelt
#         vom serverseitigen Einladungsbefehl ("...Fehlermeldungen geben
#         nicht preis, ob ein Konto existiert" bezieht sich dort auf die
#         EINLADUNG); der zu diesem Fall passende Satz -- Konto- und
#         Netzgrenzen gemeinsam auswerten, "ohne die Existenz eines
#         Kontos preiszugeben" -- steht in K03-M16. Umgehaengt.
# =====================================================================
st=$(post_einladung "$TOK_GEGENPROBE" ac08vor)
gegenprobe_id="$(dbz "SELECT id::text FROM actor WHERE email='$E_GEGENPROBE'")"
CODE_GEGENPROBE="$(code_aus_mail "$E_GEGENPROBE")"
if [ "$st" != "303" ] || [ -z "$CODE_GEGENPROBE" ] || ! printf '%s' "$CODE_GEGENPROBE" | grep -Eq '^[0-9]{6}$'; then
  sperr AC-08 "K03-M16, K03-G01" "Ununterscheidbarkeit nicht aufbaubar: Einloesung fuer $E_GEGENPROBE schlug fehl oder kein lesbarer Code"
elif ! code_stimmt_gegen_hash "$gegenprobe_id" "$CODE_GEGENPROBE"; then
  # P2 (2026-08-14): siehe AC-04.
  sperr AC-08 "K03-M16, K03-G01" "Ununterscheidbarkeit nicht messbar: der aus dem Mailfang gelesene Code passt nicht zum gespeicherten Pruefwert in login_code fuer $E_GEGENPROBE"
else
  falsch_gp='000000'; [ "$falsch_gp" = "$CODE_GEGENPROBE" ] && falsch_gp='111111'
  st8=$(post_anmeldung "$E_GEGENPROBE" "$falsch_gp" ac08)
  keks8="$(sitzungswert ac08)"
  m=""
  [ "$st8" = "200" ] || m="$m Status $st8 statt 200;"
  [ -z "$keks8" ] || m="$m falscher Code an einem echten Konto hat einen Sitzungskeks gesetzt;"
  [ -z "$m" ] && ok AC-08 "K03-M16, K03-G01" "Ein bestehendes, frisch eingeloestes Konto mit falschem Code wird korrekt abgewiesen (200, kein Sitzungskeks) -- strukturelle Grundlage der Ununterscheidbarkeit (K03-M16: ohne die Existenz eines Kontos preiszugeben; K03-G01)" \
              || nok AC-08 "K03-M16, K03-G01" "Falscher Code an echtem Konto:$m"
fi
pruefe_sql_marke  # S3 (2026-08-14): siehe AC-01.

# =====================================================================
# AC-09 · K03-M16 + K03-G01 + EN-01 zustand_fehler --
#         erwartet: Kontoexistenz_nicht_preisgegeben --
#         Eine NIE registrierte Adresse (ac_unbekannt@, kein Konto)
#         bekommt dieselbe Antwort wie das echte Konto aus AC-08 mit
#         falschem Code -- byteidentisch nach Normierung. Damit verraet
#         die Anmeldung nicht, ob ein Konto besteht.
#
#         P7 (2026-08-14): wie AC-08 von K03-M25 auf K03-M16 umgehaengt.
#         P3 (2026-08-14): fehlt der Vergleichsrumpf aus AC-08, ist das
#         eine NICHTMESSUNG (AC-08 selbst ist ausgefallen), kein
#         Klauselverstoss -- sperr statt nok, wie AC-12/AC-13.
# =====================================================================
if [ ! -s "$ARBEIT/ac08.rumpf" ]; then
  sperr AC-09 "K03-M16, K03-G01, EN-01" 'Kontoexistenz nicht pruefbar: kein Vergleichsrumpf aus AC-08 vorhanden'
else
  irgendein_code='482913'
  st9=$(post_anmeldung "$E_UNBEKANNT" "$irgendein_code" ac09)
  keks9="$(sitzungswert ac09)"
  m=""
  [ "$st9" = "200" ] || m="$m Status $st9 statt 200;"
  [ -z "$keks9" ] || m="$m eine nie registrierte Adresse hat einen Sitzungskeks bekommen;"
  normiere "$ARBEIT/ac08.rumpf" > "$ARBEIT/norm_ac08"
  normiere "$ARBEIT/ac09.rumpf" > "$ARBEIT/norm_ac09"
  cmp -s "$ARBEIT/norm_ac08" "$ARBEIT/norm_ac09" || m="$m die Antwort unterscheidet sich (nach Normierung) von der auf falschen Code an einem echten Konto (AC-08) -- die Existenz des Kontos wird preisgegeben;"
  [ -z "$m" ] && ok AC-09 "K03-M16, K03-G01, EN-01" "Eine nie registrierte Adresse bekommt dieselbe Antwort wie ein echtes Konto mit falschem Code -- byteidentisch nach Normierung (K03-M16: ohne die Existenz eines Kontos preiszugeben; K03-G01, EN-01 zustand_fehler)" \
              || nok AC-09 "K03-M16, K03-G01, EN-01" "Kontoexistenz -- erwartet: Kontoexistenz_nicht_preisgegeben:$m"
fi
pruefe_sql_marke  # S3 (2026-08-14): siehe AC-01.

# =====================================================================
# AC-10 · K20-M18 (positiv) · Nach der Einloesung (AC-01) steht eine
#         Nachweiszeile mit Zeitpunkt, benannter handelnder Instanz und
#         einem Wert, der den Zustandswechsel VERSANDT->EINGELOEST traegt.
#
#         P5 (2026-08-14): vorher liess object_ref='ACTOR:<id>' als
#         Alternative den Fall bestehen, OHNE dass zur Einladung selbst
#         eine Nachweiszeile existierte -- verengt auf
#         object_ref=INVITATION:<invitation_id>. Und: change_type/value
#         (K20-M18 "Wert davor und danach") wurden gar nicht geprueft --
#         jetzt gefordert: value enthaelt sowohl VERSANDT als auch
#         EINGELOEST. Eine feste Kodierung fuer "davor und danach" in der
#         einen value-Spalte gibt weder das Klauselregister noch das
#         Schema vor; das Vorkommen beider Werte ist die formatunabhaengige
#         Lesart.
# =====================================================================
if [ -z "$kette_id" ] || [ -z "$kette_invid" ]; then
  sperr AC-10 "K20-M18" 'Nachweis nicht pruefbar: actor_id/invitation_id von ac_kette@ liessen sich nicht ermitteln'
else
  treffer10="$(dbz "SELECT count(*) FROM event
                      WHERE occurred_at >= '$zeitmarke_ac01'::timestamptz
                        AND actor_label IS NOT NULL
                        AND object_ref = 'INVITATION:$kette_invid'
                        AND change_type IS NOT NULL
                        AND value ILIKE '%VERSANDT%' AND value ILIKE '%EINGELOEST%'")"
  if [ "${treffer10:-0}" -ge 1 ]; then
    ok AC-10 "K20-M18" "Nach der Einloesung steht eine Nachweiszeile in event mit Zeitpunkt, handelnder Instanz, object_ref=INVITATION:<id> und einem Wert, der den Uebergang VERSANDT -> EINGELOEST traegt (K20-M18; $treffer10 Zeile(n))"
  else
    nok AC-10 "K20-M18" 'keine Nachweiszeile in event gefunden, deren object_ref exakt INVITATION:<invitation_id> lautet und deren change_type/value den Uebergang VERSANDT->EINGELOEST traegt (K20-M18)'
  fi
fi
pruefe_sql_marke  # S3 (2026-08-14): siehe AC-01.

# =====================================================================
# AC-11 · K20-M18 (positiv) · Die Nachweiszeile zur Einloesung traegt
#         eine gesetzte UND aufloesbare handelnde Instanz.
#
#         P5 (2026-08-14): vorher wurde Selbstbedienung durch den
#         Eingeladenen SELBST verlangt und der Plattform-Admin
#         ausdruecklich ausgeschlossen -- beides steht in K20-M18 NICHT.
#         Zurueckgenommen auf das, was die Klausel wirklich fordert:
#         "handelnde Instanz" gesetzt (actor_label) und aufloesbar
#         (actor_id verweist auf einen bestehenden actor -- die Paarung
#         ist ohnehin per event_actor_paarweise erzwungen, migrations/M30).
# =====================================================================
if [ -z "$kette_invid" ]; then
  sperr AC-11 "K20-M18" 'Handelnde Instanz nicht pruefbar: invitation_id von ac_kette@ fehlt'
else
  treffer11="$(dbz "SELECT count(*) FROM event e JOIN actor a ON a.id = e.actor_id
                      WHERE e.object_ref = 'INVITATION:$kette_invid'
                        AND e.actor_label IS NOT NULL
                        AND length(trim(e.actor_label)) > 0")"
  [ "${treffer11:-0}" -ge 1 ] && ok AC-11 "K20-M18" "Die Nachweiszeile zur Einloesung traegt eine gesetzte und aufloesbare handelnde Instanz: actor_id verweist auf einen bestehenden actor, actor_label ist gesetzt (K20-M18)" \
              || nok AC-11 "K20-M18" 'keine Nachweiszeile zur Einladung mit gesetzter und aufloesbarer handelnder Instanz gefunden (K20-M18)'
fi
pruefe_sql_marke  # S3 (2026-08-14): siehe AC-01.

# =====================================================================
# AC-12 · K23-D09 (positiv) · Die Fehlerausgabe auf den EIGENEN falschen
#         Versuch (AC-08) enthaelt den EIGENEN, echten Anmeldecode
#         nicht im Klartext.
# =====================================================================
if [ -z "$CODE_GEGENPROBE" ] || [ ! -s "$ARBEIT/ac08.rumpf" ]; then
  sperr AC-12 "K23-D09" 'Fehlerausgabe nicht pruefbar: kein Code oder keine Antwort aus AC-08 vorhanden'
else
  m=""
  hat_text ac08 "$CODE_GEGENPROBE" && m="$m die Fehlerausgabe enthaelt den eigenen, echten Anmeldecode im Klartext;"
  [ -z "$m" ] && ok AC-12 "K23-D09" "Die Fehlerausgabe auf den eigenen falschen Versuch enthaelt den eigenen, echten Anmeldecode nicht (K23-D09)" \
              || nok AC-12 "K23-D09" "Eigener Code in der Fehlerausgabe:$m"
fi
pruefe_sql_marke  # S3 (2026-08-14): siehe AC-01.

# =====================================================================
# AC-13 · K23-D09 -- erwartet: fremde_Personenangabe_in_Fehlerausgabe --
#         Kreuzpruefung: Die Fehlerausgabe zu ac_gegenprobe@ (AC-08)
#         darf keine Angabe eines ANDEREN, echten Kontos (ac_kette@)
#         preisgeben -- weder dessen echten Code noch Adresse noch
#         Anzeigename.
# =====================================================================
if [ ! -s "$ARBEIT/ac08.rumpf" ]; then
  sperr AC-13 "K23-D09" 'Kreuzpruefung nicht moeglich: keine Antwort aus AC-08 vorhanden'
else
  m=""
  [ -n "$CODE_KETTE" ] && { hat_text ac08 "$CODE_KETTE" && m="$m die Fehlerausgabe zu $E_GEGENPROBE enthaelt den echten Code eines fremden Kontos ($E_KETTE);"; }
  hat_text ac08 "$E_KETTE" && m="$m die Fehlerausgabe enthaelt die Adresse eines fremden Kontos ($E_KETTE);"
  hat_text ac08 'Pruef AC Kette' && m="$m die Fehlerausgabe enthaelt den Anzeigenamen eines fremden Kontos;"
  [ -z "$m" ] && ok AC-13 "K23-D09" "Die Fehlerausgabe zu $E_GEGENPROBE verraet keine Angabe eines anderen, echten Kontos (Kreuzpruefung mit $E_KETTE; K23-D09)" \
              || nok AC-13 "K23-D09" "Fremde Personenangabe -- erwartet: fremde_Personenangabe_in_Fehlerausgabe:$m"
fi
pruefe_sql_marke  # S3 (2026-08-14): siehe AC-01.

# =====================================================================
# AC-14 · K20-D10 + K03-G01 + K03-M15 -- Gegenstueck zu AC-01 (P1,
#         2026-08-14): eine NICHT erfolgreiche Einloesung stellt KEINEN
#         Anmeldecode aus -- die Aussage, auf der der Zuschnitt dieser
#         Scheibe beruht (siehe Kopf dieser Datei). Ohne diesen Fall war
#         nie gemessen, dass eine fehlschlagende Einloesung wirklich
#         nichts ausloest.
#
#         Derselbe Token wie in AC-01 wird ein zweites Mal eingereicht;
#         die Einladung ist nach AC-01 bereits EINGELOEST (K20-D10: eine
#         eingeloeste Einladung wirkt nicht erneut).
#
#         Drosselung (siehe "ACHTUNG ZUR DROSSELUNG" der Uebergabe):
#         dieser Fall ruft POST /einladung auf, nicht POST /anmeldung --
#         er schreibt keine Zeile nach login_attempt und verbraucht
#         darum KEIN Kontingent von login_attempt_guard (5 je E-Mail/
#         15 Min., 20 je Herkunft/60 Min.). Weder eine eigene Adresse
#         noch ein Zuruecksetzen von login_attempt ist fuer AC-14 noetig.
# =====================================================================
if [ -z "$kette_id" ]; then
  sperr AC-14 "K20-D10, K03-G01, K03-M15" 'Gegenstueck zu AC-01 nicht pruefbar: actor_id von ac_kette@ liess sich nicht ermitteln'
else
  codes_vor14="$(dbz "SELECT count(*) FROM login_code WHERE actor_id='$kette_id'")"
  mails_vor14="$(mail_anzahl "$E_KETTE")"
  st14=$(post_einladung "$TOK_KETTE" ac14)
  codes_nach14="$(dbz "SELECT count(*) FROM login_code WHERE actor_id='$kette_id'")"
  mails_nach14="$(mail_anzahl "$E_KETTE")"
  m=""
  [ "$st14" != "303" ] || m="$m Status 303 -- eine bereits eingeloeste Einladung hat ein zweites Mal gewirkt (K20-D10);"
  [ "${codes_nach14:-0}" = "${codes_vor14:-0}" ] || m="$m login_code-Zaehlerstand fuer $E_KETTE stieg von ${codes_vor14:-0} auf ${codes_nach14:-0} -- die nicht erfolgreiche Einloesung hat einen Code ausgestellt;"
  [ "${mails_nach14:-0}" = "${mails_vor14:-0}" ] || m="$m im Mailfang stehen nach dem zweiten Versuch mehr Mails an $E_KETTE (${mails_vor14:-0} -> ${mails_nach14:-0});"
  [ -z "$m" ] && ok AC-14 "K20-D10, K03-G01, K03-M15" "Eine nicht erfolgreiche Einloesung (Token bereits EINGELOEST) stellt keinen Anmeldecode aus: kein 303, login_code-Zaehler unveraendert, keine weitere Mail (K20-D10, K03-G01, K03-M15 -- Gegenstueck zu AC-01)" \
              || nok AC-14 "K20-D10, K03-G01, K03-M15" "Gegenstueck zu AC-01:$m"
fi
pruefe_sql_marke  # S3 (2026-08-14): siehe AC-01.

# =====================================================================
printf '\n'
[ "$gesperrt" -gt 0 ] && printf 'davon GESPERRT (nicht messbar, zaehlt nach K23-M22 nicht als bestanden): %s\n' "$gesperrt"
printf 'SUMME: %s von %s bestanden, %s gescheitert\n' "$bestanden" "$gesamt" "$gescheitert"
[ "$gescheitert" -eq 0 ]
