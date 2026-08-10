#!/usr/bin/env bash
# =====================================================================
# FREIRAUM · Scheibe · Einladung einloesen
# Klauselpruefung gegen einen LAUFENDEN Server
#
# Geschrieben gegen K20 (M08, M14, M15, D10, M18), K03-G01, den
# gemessenen Bestand von INVITATION/ACTOR/EVENT und den Schnittstellen-
# vertrag aus dem Pruefauftrag -- NICHT gegen den Umsetzungscode. Der
# Prueffall kennt den Server nur durch seine Tueren. Machart wie
# anmeldung_lauf.sh (das eigene Vorbild dieser Scheibe).
#
# Aufruf:
#   FREIRAUM_CODE_PFEFFER=... \
#   psql ... -f pruefungen/klauseln/einloesung_daten.sql            # Daten
#   FREIRAUM_PRUEF_URL=http://localhost:8099 \
#   FREIRAUM_CODE_PFEFFER=... \
#   pruefungen/klauseln/einloesung_lauf.sh                          # Faelle
#
# Umgebung:
#   FREIRAUM_PRUEF_URL    Vorgabe http://localhost:8099
#   PGHOST/PGPORT/PGUSER/PGPASSWORD/PGDATABASE
#                         Vorgabe localhost/55433/postgres/pilot/freiraum_pruef
#
# MASSSTAB F07: Vor dem ersten Fall wird der AUFBAU geprueft. Ein Fall,
# der an einem fehlenden Datensatz oder einer fremden Bedingung
# scheitert, misst nichts -- deshalb bricht der Lauf dann ab (Rueckgabe 2),
# statt Ergebnisse zu melden, die niemand tragen kann.
# =====================================================================

BASIS="${FREIRAUM_PRUEF_URL:-http://localhost:8099}"

: "${PGHOST:=localhost}"
: "${PGPORT:=55433}"
: "${PGUSER:=postgres}"
: "${PGPASSWORD:=pilot}"
: "${PGDATABASE:=freiraum_pruef}"
export PGHOST PGPORT PGUSER PGPASSWORD PGDATABASE

# Der Wortlaut aus dem Vertrag. Zeichen fuer Zeichen -- bei JEDEM
# Misserfolg, ohne Ausnahme (Ununterscheidbarkeit, K03-G01).
MELDUNG='Dieser Einladungslink gilt nicht mehr. Bitte fordern Sie einen neuen an.'

# Die Klartext-Tokens, wie einloesung_daten.sql sie gehasht hat (Abschn. 6
# dort). Nur hier im Prueflauf als Wert -- nie in einer Datenbankzeile.
TOK_POSITIV='tok-positiv-6f2e9b1c4a7d5083'
TOK_ABGELAUFEN='tok-abgelaufen-9a4b7c2e1f5d0836'
TOK_VERBRAUCHT='tok-verbraucht-2c5e8a1b4d7f0936'
TOK_WIDERRUFEN='tok-widerrufen-7b1d4f8a2c5e0937'
TOK_GESPERRT='tok-gesperrt-4f8b1d7a2c5e0938'
TOK_GLEICHZEITIG='tok-gleichzeitig-1a4d7f2b8c5e0939'
TOK_UNBEKANNT='tok-unbekannt-nie-in-db-5e8a1d4f2c7b0940c3'

ARBEIT="$(mktemp -d "${TMPDIR:-/tmp}/freiraum_einloesung.XXXXXX")"
trap 'rm -rf "$ARBEIT"' EXIT

gesamt=0; bestanden=0; gescheitert=0; gesperrt=0

ok()  { gesamt=$((gesamt+1)); bestanden=$((bestanden+1))
        printf '%-7s BESTANDEN    %s\n' "$1" "$2"; }
nok() { gesamt=$((gesamt+1)); gescheitert=$((gescheitert+1))
        printf '%-7s GESCHEITERT  %s\n' "$1" "$(printf '%s' "$2" | tr '\n' ' ')"; }
# K23-M22: Was nicht gemessen werden konnte, ist GESPERRT -- nicht
# bestanden. In der Summe zaehlt es zu den gescheiterten Faellen, denn
# ein Lauf, der nichts gemessen hat, ist kein gruener Lauf.
sperr() { gesamt=$((gesamt+1)); gescheitert=$((gescheitert+1)); gesperrt=$((gesperrt+1))
        printf '%-7s GESPERRT     %s\n' "$1" "$(printf '%s' "$2" | tr '\n' ' ')"; }

abbruch() { printf 'ABBRUCH: %s\n' "$1"; printf 'SUMME: 0 von 0 bestanden, 0 gescheitert\n'; exit 2; }

db()  { psql -X -tAq -v ON_ERROR_STOP=1 -c "$1"; }
dbz() { psql -X -tAq -v ON_ERROR_STOP=1 -c "$1" | head -1; }

# ---------------------------------------------------------------------
# Werkzeug
# ---------------------------------------------------------------------
saeubere_kopf() { tr -d '\r' < "$1" > "$1.rein" && mv "$1.rein" "$1"; }

post_einladung() {   # $1 token  $2 name
  local p="$ARBEIT/$2" st
  st=$(curl -sS -o "$p.rumpf" -D "$p.kopf" -w '%{http_code}' --max-time 25 \
        --data-urlencode "token=$1" \
        "$BASIS/einladung" 2>"$p.fehler") || st="000"
  [ -f "$p.kopf" ] && saeubere_kopf "$p.kopf"
  printf '%s' "$st"
}

post_einladung_async() {   # $1 token  $2 name  -- laeuft im Hintergrund, siehe EL-18
  local p="$ARBEIT/$2"
  ( st=$(curl -sS -o "$p.rumpf" -D "$p.kopf" -w '%{http_code}' --max-time 25 \
          --data-urlencode "token=$1" \
          "$BASIS/einladung" 2>"$p.fehler") || st="000"
    printf '%s' "$st" > "$p.status" ) &
}

hole() {             # $1 pfad  $2 name
  local p="$ARBEIT/$2" st
  st=$(curl -sS -o "$p.rumpf" -D "$p.kopf" -w '%{http_code}' --max-time 25 \
        "$BASIS$1" 2>"$p.fehler") || st="000"
  [ -f "$p.kopf" ] && saeubere_kopf "$p.kopf"
  printf '%s' "$st"
}

kopfzeile()  { grep -i "^$2:" "$ARBEIT/$1.kopf" 2>/dev/null | head -1 \
               | sed "s/^[^:]*:[[:space:]]*//"; }
rumpf()      { printf '%s' "$ARBEIT/$1.rumpf"; }
hat_meldung(){ grep -qF "$MELDUNG" "$ARBEIT/$1.rumpf" 2>/dev/null; }
hat_verdecktes_tokenfeld() {  # $1 name -- <input type=hidden name=token>, Attributreihenfolge offen
  grep -Eqi '<input[^>]*type=["'"'"']?hidden["'"'"']?[^>]*name=["'"'"']?token["'"'"']' "$ARBEIT/$1.rumpf" 2>/dev/null || \
  grep -Eqi '<input[^>]*name=["'"'"']?token["'"'"']?[^>]*type=["'"'"']?hidden["'"'"']' "$ARBEIT/$1.rumpf" 2>/dev/null
}

# Ein Rumpf, aus dem alles entfernt ist, was sich zwischen zwei Faellen
# zulaessig unterscheiden darf: sechsstellige und laengere Ziffernfolgen,
# lange Zeichenketten (Token, Nonce, Marke), Adressen. Was danach noch
# verschieden ist, unterscheidet die Faelle -- und das ist eine Auskunft.
normiere() {
  sed -e 's/[A-Za-z0-9._%+-]*@pruef\.example/ADRESSE/g' \
      -e 's/[A-Za-z0-9_-]\{12,\}/MARKE/g' \
      -e 's/[[:space:]][[:space:]]*/ /g' "$1"
}

freier_port() { python3 -c 'import socket;s=socket.socket();s.bind(("127.0.0.1",0));print(s.getsockname()[1]);s.close()'; }

# ---------------------------------------------------------------------
# Vorpruefung: Werkzeug, Server, Datenlage (F07)
# ---------------------------------------------------------------------
command -v curl    >/dev/null 2>&1 || abbruch 'curl fehlt.'
command -v psql    >/dev/null 2>&1 || abbruch 'psql fehlt.'
command -v python3 >/dev/null 2>&1 || abbruch 'python3 fehlt (Zeitmessung EL-17, Freier Port EL-18).'

db 'SELECT 1' >/dev/null 2>&1 || abbruch "Datenbank $PGDATABASE auf $PGHOST:$PGPORT nicht erreichbar."

[ -n "${FREIRAUM_CODE_PFEFFER:-}" ] || abbruch 'FREIRAUM_CODE_PFEFFER ist nicht gesetzt -- derselbe Wert wie am Server ist noetig.'
case "$FREIRAUM_CODE_PFEFFER" in *"'"*) abbruch "FREIRAUM_CODE_PFEFFER enthaelt ein Hochkomma; das Pruefskript kann es nicht sicher in SQL setzen.";; esac

if [ "$(hole /gesundheit vorpruefung)" != "200" ]; then
  abbruch "Server unter $BASIS antwortet nicht auf GET /gesundheit. Erst starten, dann pruefen."
fi

lage="$(dbz "SELECT count(*) FROM pg_views WHERE viewname='pruef_einladung_lage'")"
[ "$lage" = "1" ] || abbruch 'Sicht pruef_einladung_lage fehlt -- einloesung_daten.sql zuerst einspielen.'

# AUFBAUPRUEFUNG (F07): dieselben Bedingungen wie in einloesung_daten.sql,
# hier aber unmittelbar vor dem Lauf -- die Daten koennten zwischenzeitlich
# durch einen frueheren Lauf verbraucht worden sein.
aufbau="$(dbz "
SELECT string_agg(m, ' ') FROM (
  SELECT email || ':invitation_status=' || invitation_status FROM pruef_einladung_lage
   WHERE (email IN ('el_positiv@pruef.example','el_abgelaufen@pruef.example',
                    'el_gesperrt@pruef.example','el_gleichzeitig@pruef.example')
          AND invitation_status <> 'VERSANDT')
      OR (email = 'el_verbraucht@pruef.example' AND invitation_status <> 'EINGELOEST')
      OR (email = 'el_widerrufen@pruef.example' AND invitation_status <> 'WIDERRUFEN')
  UNION ALL
  SELECT email || ':noch_offen_frist=' || noch_offen_frist FROM pruef_einladung_lage
   WHERE (email IN ('el_positiv@pruef.example','el_gesperrt@pruef.example','el_gleichzeitig@pruef.example',
                    'el_verbraucht@pruef.example','el_widerrufen@pruef.example')
          AND NOT noch_offen_frist)
      OR (email = 'el_abgelaufen@pruef.example' AND noch_offen_frist)
  UNION ALL
  SELECT email || ':redeemed_at' FROM pruef_einladung_lage
   WHERE (email <> 'el_verbraucht@pruef.example' AND redeemed_at IS NOT NULL)
      OR (email = 'el_verbraucht@pruef.example' AND redeemed_at IS NULL)
  UNION ALL
  SELECT email || ':actor_status=' || actor_status FROM pruef_einladung_lage
   WHERE (email = 'el_gesperrt@pruef.example' AND actor_status <> 'GESPERRT')
      OR (email = 'el_verbraucht@pruef.example' AND actor_status <> 'AKTIV')
      OR (email IN ('el_positiv@pruef.example','el_abgelaufen@pruef.example',
                    'el_widerrufen@pruef.example','el_gleichzeitig@pruef.example')
          AND actor_status <> 'WARTET_2FA')
  UNION ALL
  SELECT email || ':freigeschaltete_portale=' || freigeschaltete_portale FROM pruef_einladung_lage
   WHERE freigeschaltete_portale <> 1
) t")"
[ -z "$aufbau" ] || abbruch "Datenlage taugt nicht (F07): $aufbau -- einloesung_daten.sql neu einspielen."

printf 'FREIRAUM · Scheibe · Einladung einloesen — Klauselpruefung gegen %s\n' "$BASIS"
printf 'Datenlage: %s auf %s:%s · Aufbaupruefung (F07) bestanden\n\n' "$PGDATABASE" "$PGHOST" "$PGPORT"

# =====================================================================
# EL-01 · Vertrag · GET liefert die Bestaetigungsseite mit verdecktem
#         Feld token und einer Schaltflaeche. Gueltiger, offener Token.
# =====================================================================
st=$(hole "/einladung?token=$TOK_POSITIV" el01)
m=""
[ "$st" = "200" ] || m="$m Status $st statt 200;"
grep -Eqi '<form[^>]*method=["'"'"']?post' "$(rumpf el01)" || m="$m kein Formular mit method=post;"
hat_verdecktes_tokenfeld el01 || m="$m kein verdecktes Feld name=\"token\";"
grep -Eqi '<button|type=["'"'"']?submit' "$(rumpf el01)" || m="$m kein Absendeknopf;"
[ -z "$m" ] && ok EL-01 'GET /einladung?token=... liefert 200 und die Bestaetigungsseite mit verdecktem Feld token und Absendeknopf' \
            || nok EL-01 "GET /einladung mit gueltigem Token entspricht dem Vertrag nicht:$m"

# =====================================================================
# EL-02 · Vertrag · Fehlt der Parameter: 200 mit der EINEN Meldung.
# =====================================================================
st=$(hole /einladung el02)
cp "$ARBEIT/el02.rumpf" "$ARBEIT/gleich_leer.rumpf" 2>/dev/null
m=""
[ "$st" = "200" ] || m="$m Status $st statt 200;"
hat_meldung el02 || m="$m die Meldung fehlt oder weicht ab;"
[ -z "$m" ] && ok EL-02 'GET /einladung ohne Parameter: 200 mit der einen Meldung' \
            || nok EL-02 "Fehlender Parameter:$m"

# =====================================================================
# EL-03 · Vertrag + K03-G01 · Unbekannter Token: 200 mit derselben Meldung.
# =====================================================================
st=$(hole "/einladung?token=$TOK_UNBEKANNT" el03)
cp "$ARBEIT/el03.rumpf" "$ARBEIT/gleich_unbekannt.rumpf" 2>/dev/null
m=""
[ "$st" = "200" ] || m="$m Status $st statt 200;"
hat_meldung el03 || m="$m die Meldung fehlt oder weicht ab;"
[ -z "$m" ] && ok EL-03 'GET /einladung mit unbekanntem Token: 200 mit der einen Meldung, faellt fail-closed (K03-G01)' \
            || nok EL-03 "Unbekannter Token:$m"

# =====================================================================
# EL-04 · Vertrag · GET AENDERT NICHTS. Ein Mailscanner, der den Link
#         vorab abruft, darf die Einladung nicht einloesen, bevor der
#         Mensch sie sieht. Zweimaliges GET auf den gueltigen Token.
# =====================================================================
status_vor="$(dbz "SELECT invitation_status FROM pruef_einladung_lage WHERE email='el_positiv@pruef.example'")"
redeemed_vor="$(dbz "SELECT coalesce(redeemed_at::text,'') FROM pruef_einladung_lage WHERE email='el_positiv@pruef.example'")"
hole "/einladung?token=$TOK_POSITIV" el04a >/dev/null
hole "/einladung?token=$TOK_POSITIV" el04b >/dev/null
status_nach="$(dbz "SELECT invitation_status FROM pruef_einladung_lage WHERE email='el_positiv@pruef.example'")"
redeemed_nach="$(dbz "SELECT coalesce(redeemed_at::text,'') FROM pruef_einladung_lage WHERE email='el_positiv@pruef.example'")"
m=""
[ "$status_vor" = "VERSANDT" ] || m="$m Vorbedingung verletzt: Status vor dem GET ist $status_vor statt VERSANDT;"
[ "$status_nach" = "$status_vor" ]   || m="$m der Status wechselte durch ein GET von $status_vor auf $status_nach;"
[ "$redeemed_nach" = "$redeemed_vor" ] || m="$m redeemed_at wurde durch ein GET gesetzt;"
[ -z "$m" ] && ok EL-04 'Zweimaliges GET auf einen gueltigen Token aendert weder invitation.status noch redeemed_at (Mailscanner-Sicherheit)' \
            || nok EL-04 "GET-Sicherheit:$m"

# =====================================================================
# EL-05 · POSITIVKONTROLLE · POST mit gueltigem, offenem Token fuehrt
#         auf /anmeldung. Ein Regime, das alles abweist, bestuende jeden
#         Negativtest -- ohne diesen Fall waeren EL-08..13 wertlos.
# =====================================================================
zeitmarke_el05="$(dbz "SELECT now()::text")"
st=$(post_einladung "$TOK_POSITIV" el05)
ziel="$(kopfzeile el05 location)"
m=""
[ "$st" = "303" ] || m="$m Status $st statt 303;"
case "$ziel" in *"/anmeldung"*) : ;; *) m="$m Location '$ziel' zeigt nicht auf /anmeldung;";; esac
[ -z "$m" ] && ok EL-05 'Gueltiger, offener Token: POST /einladung fuehrt mit 303 auf /anmeldung' \
            || nok EL-05 "Positivfall:$m"

# =====================================================================
# EL-06 · K20-M14 · EINGELOEST nur mit redeemed_at, redeemed_at nur mit
#         EINGELOEST. Die Kopplung ist als CHECK erzwungen (schema-fest);
#         gemessen wird, dass die Anwendung sie nach der Einloesung
#         TATSAECHLICH herstellt.
# =====================================================================
inv_status="$(dbz "SELECT invitation_status FROM pruef_einladung_lage WHERE email='el_positiv@pruef.example'")"
inv_redeemed="$(dbz "SELECT coalesce(redeemed_at::text,'') FROM pruef_einladung_lage WHERE email='el_positiv@pruef.example'")"
m=""
[ "$inv_status" = "EINGELOEST" ] || m="$m invitation.status ist $inv_status statt EINGELOEST;"
[ -n "$inv_redeemed" ]           || m="$m redeemed_at ist nach der Einloesung leer;"
[ -z "$m" ] && ok EL-06 'Nach der Einloesung: status=EINGELOEST und redeemed_at gesetzt, gemeinsam (K20-M14)' \
            || nok EL-06 "Kopplung EINGELOEST/redeemed_at:$m"

# =====================================================================
# EL-07 · K20-M15 · Der Uebergang WARTET_2FA -> AKTIV entsteht aus der
#         Einloesung. Ob es dieselbe Transaktion war, ist von aussen
#         (schwarzer Kasten) nicht unmittelbar beobachtbar -- gemessen
#         wird die KOPPLUNG: erfolgreiche Einloesung UND aktiviertes
#         Konto treten gemeinsam auf, nie einzeln (siehe auch EL-06).
# =====================================================================
actor_status="$(dbz "SELECT actor_status FROM pruef_einladung_lage WHERE email='el_positiv@pruef.example'")"
m=""
[ "$actor_status" = "AKTIV" ] || m="$m actor.status ist $actor_status statt AKTIV;"
[ -z "$m" ] && ok EL-07 'Nach erfolgreicher Einloesung: das Konto steht auf AKTIV (K20-M15, WARTET_2FA -> AKTIV)' \
            || nok EL-07 "Kontoaktivierung:$m"

# =====================================================================
# EL-08 · K20-M18 · Jede Aenderung an der Einladung steht mit Zeitpunkt
#         und handelnder Instanz im Nachweis (event). Gemessen: NACH der
#         Zeitmarke aus EL-05 entstand eine Ereigniszeile, die sich der
#         Einladung oder dem Konto zuordnen laesst, mit benannter Instanz.
#
#         Die genaue Spaltenbelegung (welches Feld die Einladung
#         referenziert) ist im gemessenen Bestand nicht festgelegt --
#         object_ref ist Freitext. Gemessen wird darum tolerant gegen
#         beide plausiblen Traeger (Einladungs- oder Kontokennung).
# =====================================================================
akteur_id="$(dbz "SELECT actor_id::text FROM pruef_einladung_lage WHERE email='el_positiv@pruef.example'")"
einladung_id="$(dbz "SELECT invitation_id::text FROM pruef_einladung_lage WHERE email='el_positiv@pruef.example'")"
if [ -z "$akteur_id" ] || [ -z "$einladung_id" ]; then
  sperr EL-08 'Nachweis nicht pruefbar: actor_id/invitation_id von el_positiv@ liessen sich nicht ermitteln'
else
  treffer="$(dbz "SELECT count(*) FROM event
                    WHERE occurred_at >= '$zeitmarke_el05'::timestamptz
                      AND actor_label IS NOT NULL
                      AND (object_ref = '$einladung_id' OR object_ref = '$akteur_id')")"
  if [ "${treffer:-0}" -ge 1 ]; then
    ok EL-08 "Nach der Einloesung steht eine Nachweiszeile in event mit Zeitpunkt und handelnder Instanz (K20-M18; $treffer Zeile(n))"
  else
    nok EL-08 'keine Nachweiszeile in event nach der Einloesung gefunden, die sich der Einladung oder dem Konto zuordnen laesst (K20-M18)'
  fi
fi

# =====================================================================
# EL-09 · K20-D10 (sofortige Wiederverwendung) · Derselbe Token, gerade
#         erst in EL-05 verbraucht, traegt kein zweites Mal.
# =====================================================================
st=$(post_einladung "$TOK_POSITIV" el09)
cp "$ARBEIT/el09.rumpf" "$ARBEIT/gleich_verbraucht.rumpf" 2>/dev/null
inv_redeemed_nach="$(dbz "SELECT coalesce(redeemed_at::text,'') FROM pruef_einladung_lage WHERE email='el_positiv@pruef.example'")"
actor_status_nach="$(dbz "SELECT actor_status FROM pruef_einladung_lage WHERE email='el_positiv@pruef.example'")"
m=""
[ "$st" = "200" ] || m="$m Status $st statt 200;"
hat_meldung el09 || m="$m die Meldung fehlt oder weicht ab;"
[ "$inv_redeemed_nach" = "$inv_redeemed" ] || m="$m redeemed_at wurde beim zweiten Versuch veraendert;"
[ "$actor_status_nach" = "AKTIV" ]          || m="$m actor.status ist nach dem zweiten Versuch $actor_status_nach statt AKTIV;"
[ -z "$m" ] && ok EL-09 'Derselbe Token unmittelbar erneut eingereicht: abgewiesen, keine zweite Wirkung (K20-D10)' \
            || nok EL-09 "Sofortige Wiederverwendung:$m"

# =====================================================================
# EL-10 · K20-D10 · Abgelaufene Einladung wirkt nicht erneut.
#         Frist ist um, sonst ist der Datensatz tadellos.
# =====================================================================
st=$(post_einladung "$TOK_ABGELAUFEN" el10)
cp "$ARBEIT/el10.rumpf" "$ARBEIT/gleich_abgelaufen.rumpf" 2>/dev/null
zust="$(dbz "SELECT invitation_status FROM pruef_einladung_lage WHERE email='el_abgelaufen@pruef.example'")"
m=""
[ "$st" = "200" ] || m="$m Status $st statt 200;"
hat_meldung el10 || m="$m die Meldung fehlt oder weicht ab;"
[ "$zust" = "VERSANDT" ] || m="$m invitation.status wurde auf $zust veraendert;"
[ -z "$m" ] && ok EL-10 'Abgelaufene Einladung: abgewiesen mit derselben Meldung, kein Zustandswechsel (K20-D10)' \
            || nok EL-10 "Abgelaufene Einladung:$m"

# =====================================================================
# EL-11 · K20-D10 · Bereits eingeloeste Einladung wirkt nicht erneut.
#         Frist laeuft noch -- verletzt ist allein die Einmaligkeit.
# =====================================================================
redeemed_vor11="$(dbz "SELECT redeemed_at::text FROM pruef_einladung_lage WHERE email='el_verbraucht@pruef.example'")"
st=$(post_einladung "$TOK_VERBRAUCHT" el11)
cp "$ARBEIT/el11.rumpf" "$ARBEIT/gleich_eingeloest.rumpf" 2>/dev/null
redeemed_nach11="$(dbz "SELECT redeemed_at::text FROM pruef_einladung_lage WHERE email='el_verbraucht@pruef.example'")"
m=""
[ "$st" = "200" ] || m="$m Status $st statt 200;"
hat_meldung el11 || m="$m die Meldung fehlt oder weicht ab;"
[ "$redeemed_nach11" = "$redeemed_vor11" ] || m="$m redeemed_at wurde durch den erneuten Versuch veraendert;"
[ -z "$m" ] && ok EL-11 'Bereits eingeloeste Einladung: abgewiesen, redeemed_at bleibt der urspruengliche Zeitpunkt (K20-D10)' \
            || nok EL-11 "Bereits eingeloest:$m"

# =====================================================================
# EL-12 · K20-D10 · Widerrufene Einladung wirkt nicht erneut.
# =====================================================================
st=$(post_einladung "$TOK_WIDERRUFEN" el12)
cp "$ARBEIT/el12.rumpf" "$ARBEIT/gleich_widerrufen.rumpf" 2>/dev/null
zust12="$(dbz "SELECT invitation_status FROM pruef_einladung_lage WHERE email='el_widerrufen@pruef.example'")"
m=""
[ "$st" = "200" ] || m="$m Status $st statt 200;"
hat_meldung el12 || m="$m die Meldung fehlt oder weicht ab;"
[ "$zust12" = "WIDERRUFEN" ] || m="$m invitation.status wurde auf $zust12 veraendert;"
[ -z "$m" ] && ok EL-12 'Widerrufene Einladung: abgewiesen mit derselben Meldung, Zustand bleibt WIDERRUFEN (K20-D10)' \
            || nok EL-12 "Widerrufen:$m"

# =====================================================================
# EL-13 · Vertrag Punkt 1 · Ein GESPERRTES Konto wird durch eine
#         Einloesung NICHT aktiviert -- Token und Frist stimmen, verletzt
#         ist ausschliesslich der Kontozustand. Gegenprobe ist EL-05:
#         derselbe Aufbau (gueltiger, offener Token, sonst tadellos),
#         einzig der Kontozustand unterscheidet -- ohne diese Gegenprobe
#         bestuende ein Programm, das grundsaetzlich alles ablehnt.
# =====================================================================
st=$(post_einladung "$TOK_GESPERRT" el13)
cp "$ARBEIT/el13.rumpf" "$ARBEIT/gleich_gesperrt.rumpf" 2>/dev/null
zust13="$(dbz "SELECT actor_status FROM pruef_einladung_lage WHERE email='el_gesperrt@pruef.example'")"
invzust13="$(dbz "SELECT invitation_status FROM pruef_einladung_lage WHERE email='el_gesperrt@pruef.example'")"
m=""
[ "$st" = "200" ] || m="$m Status $st statt 200;"
hat_meldung el13 || m="$m die Meldung fehlt oder weicht ab;"
[ "$zust13" = "GESPERRT" ]   || m="$m actor.status wurde auf $zust13 veraendert -- ein gesperrtes Konto wurde aktiviert;"
[ "$invzust13" = "VERSANDT" ] || m="$m invitation.status wurde auf $invzust13 veraendert;"
[ -z "$m" ] && ok EL-13 'GESPERRTES Konto mit gueltigem Token: die Einloesung schlaegt fehl, das Konto bleibt GESPERRT (Vertrag Punkt 1)' \
            || nok EL-13 "GESPERRTES Konto:$m"

# =====================================================================
# EL-14 · Vertrag + K03-G01 · GET auf einen nicht mehr gueltigen Token
#         (hier: bereits eingeloest) zeigt ebenfalls die EINE Meldung,
#         nicht die Bestaetigungsseite -- "traegt er nicht" gilt fuer GET
#         wie fuer POST.
# =====================================================================
st=$(hole "/einladung?token=$TOK_VERBRAUCHT" el14)
m=""
[ "$st" = "200" ] || m="$m Status $st statt 200;"
hat_meldung el14 || m="$m die Meldung fehlt oder weicht ab;"
hat_verdecktes_tokenfeld el14 && m="$m die Bestaetigungsseite wird trotz ungueltigem Token angezeigt;"
[ -z "$m" ] && ok EL-14 'GET mit einem nicht mehr gueltigen Token liefert ebenfalls die eine Meldung, nicht die Bestaetigungsseite' \
            || nok EL-14 "GET auf ungueltigen Token:$m"

# =====================================================================
# EL-15 · K20-M08 · Der Klartext-Token steht nie in der Fehlerausgabe.
#         Ein unbekannter, aber unverwechselbarer Token wird eingereicht;
#         die Antwort darf ihn nicht enthalten. (Die Speicher-Dimension
#         von M08 ist strukturell durch das Schema erzwungen: INVITATION
#         hat keine Klartext-Spalte, nur token_hash. Die Log-Dimension
#         ist mit den Mitteln dieses Prueflaufs nicht einsehbar --
#         siehe Abschlussbericht.)
# =====================================================================
st=$(post_einladung "$TOK_UNBEKANNT" el15)
m=""
[ "$st" = "200" ] || m="$m Status $st statt 200;"
hat_meldung el15 || m="$m die Meldung fehlt oder weicht ab;"
grep -qF "$TOK_UNBEKANNT" "$(rumpf el15)" && m="$m die Fehlerausgabe enthaelt den eingereichten Klartext-Token;"
[ -z "$m" ] && ok EL-15 'Die Fehlerausgabe auf einen unbekannten Token enthaelt den eingereichten Klartext-Token nicht (K20-M08)' \
            || nok EL-15 "Klartext in der Fehlerausgabe:$m"

# =====================================================================
# EL-16 · K03-G01 · UNUNTERSCHEIDBARKEIT im Wortlaut.
#         Verglichen: fehlender Parameter, unbekannter Token, abgelaufen,
#         bereits eingeloest, widerrufen, gesperrtes Konto.
# =====================================================================
faelle="leer unbekannt abgelaufen verbraucht eingeloest widerrufen gesperrt"
m=""
vollzaehlig=1
for f in $faelle; do
  [ -s "$ARBEIT/gleich_$f.rumpf" ] || { m="$m Antwort '$f' liegt nicht vor;"; vollzaehlig=0; }
done
if [ "$vollzaehlig" = "1" ]; then
  for f in $faelle; do
    grep -qF "$MELDUNG" "$ARBEIT/gleich_$f.rumpf" || m="$m '$f' traegt nicht den Wortlaut;"
  done
  for f in $faelle; do normiere "$ARBEIT/gleich_$f.rumpf" > "$ARBEIT/norm_$f"; done
  for w in gesperrt Gesperrt GESPERRT unbekannt Unbekannt existiert abgelaufen Abgelaufen \
           verbraucht eingeloest EINGELOEST widerrufen WIDERRUFEN WARTET_2FA Konto; do
    ja=0; nein=0
    for f in $faelle; do
      if grep -qF "$w" "$ARBEIT/norm_$f"; then ja=$((ja+1)); else nein=$((nein+1)); fi
    done
    [ "$ja" -gt 0 ] && [ "$nein" -gt 0 ] && m="$m '$w' steht in $ja von 7 Antworten -- das unterscheidet die Faelle;"
  done
  for f in $faelle; do
    cmp -s "$ARBEIT/norm_leer" "$ARBEIT/norm_$f" || \
      [ "$f" = "leer" ] || m="$m die Antwort '$f' weicht von 'leer' ab;"
  done
fi
if [ "$vollzaehlig" != "1" ]; then
  sperr EL-16 "Ununterscheidbarkeit nicht messbar:$m"
elif [ -z "$m" ]; then
  ok EL-16 'Fehlender Parameter, unbekannter, abgelaufener, bereits eingeloester, widerrufener Token und gesperrtes Konto liefern denselben Wortlaut (K03-G01)'
else
  nok EL-16 "Ununterscheidbarkeit:$m"
fi

# =====================================================================
# EL-17 · K03-G01 · Dieselbe Laufzeit, so gut es geht. Ein unbekannter
#         Token darf nicht schneller (oder langsamer) beantwortet werden
#         als ein Token, der wegen eines gesperrten Kontos scheitert --
#         sonst verriete die Uhr den Unterschied zwischen den Faellen.
# =====================================================================
messe() { # $1 token
  curl -sS -o /dev/null -w '%{time_total}\n' --max-time 25 \
       --data-urlencode "token=$1" \
       "$BASIS/einladung" 2>/dev/null || echo 99
}
i=1
: > "$ARBEIT/zeit_unbekannt"; : > "$ARBEIT/zeit_gesperrt"
while [ $i -le 5 ]; do
  messe "$TOK_UNBEKANNT" >> "$ARBEIT/zeit_unbekannt"
  messe "$TOK_GESPERRT"  >> "$ARBEIT/zeit_gesperrt"
  i=$((i+1))
done
mu=$(sort -n "$ARBEIT/zeit_unbekannt" | sed -n '3p')
mg=$(sort -n "$ARBEIT/zeit_gesperrt"  | sed -n '3p')
abstand=$(python3 -c "print('%.3f' % abs(float('${mu:-0}')-float('${mg:-0}')))" 2>/dev/null)
gross=$(python3 -c "print(1 if abs(float('${mu:-0}')-float('${mg:-0}'))>0.250 else 0)" 2>/dev/null)
if [ "$gross" = "0" ]; then
  ok EL-17 "Unbekannter Token und gesperrtes Konto brauchen gleich lange (Median ${mu}s / ${mg}s, Abstand ${abstand}s)"
else
  nok EL-17 "Laufzeit unterscheidet die Faelle: Median unbekannt ${mu}s, gesperrt ${mg}s, Abstand ${abstand}s > 0.250s"
fi

# =====================================================================
# EL-18 · Vertrag Punkt 2 · Konkurrenz. Zwei gleichzeitige Einloesungen
#         desselben Tokens duerfen nicht beide gewinnen. Genau EINE
#         Einloesung, genau EIN redeemed_at. Die Gegenprobe steckt in der
#         Pruefung selbst: bestuende die Anwendung, weil beide Anfragen
#         abgelehnt werden, waere die Mechanik nicht die geprueften --
#         verlangt wird deshalb GENAU EIN Erfolg, nicht "hoechstens einer".
# =====================================================================
post_einladung_async "$TOK_GLEICHZEITIG" el18a
post_einladung_async "$TOK_GLEICHZEITIG" el18b
wait
st_a="$(cat "$ARBEIT/el18a.status" 2>/dev/null || echo '???')"
st_b="$(cat "$ARBEIT/el18b.status" 2>/dev/null || echo '???')"
erfolge=0
[ "$st_a" = "303" ] && erfolge=$((erfolge+1))
[ "$st_b" = "303" ] && erfolge=$((erfolge+1))
redeemed_anzahl="$(dbz "SELECT count(*) FROM invitation i JOIN actor a ON a.id=i.actor_id
                          WHERE a.email='el_gleichzeitig@pruef.example' AND i.redeemed_at IS NOT NULL")"
inv_status18="$(dbz "SELECT invitation_status FROM pruef_einladung_lage WHERE email='el_gleichzeitig@pruef.example'")"
m=""
if [ "$erfolge" -ne 1 ]; then
  m="$m $erfolge von 2 gleichzeitigen Anfragen liefern 303 (Status A=$st_a, B=$st_b) statt genau 1;"
fi
[ "${redeemed_anzahl:-0}" = "1" ] || m="$m redeemed_at ist nach der Konkurrenzpruefung $redeemed_anzahl Mal gesetzt statt genau 1 Mal;"
[ "$inv_status18" = "EINGELOEST" ] || m="$m invitation.status ist $inv_status18 statt EINGELOEST;"
[ -z "$m" ] && ok EL-18 'Zwei gleichzeitige Einloesungen desselben Tokens: genau eine gewinnt, genau ein redeemed_at (Vertrag Punkt 2)' \
            || nok EL-18 "Konkurrenz:$m"

# =====================================================================
printf '\n'
[ "$gesperrt" -gt 0 ] && printf 'davon GESPERRT (nicht messbar, zaehlt nach K23-M22 nicht als bestanden): %s\n' "$gesperrt"
printf 'SUMME: %s von %s bestanden, %s gescheitert\n' "$bestanden" "$gesamt" "$gescheitert"
[ "$gescheitert" -eq 0 ]
