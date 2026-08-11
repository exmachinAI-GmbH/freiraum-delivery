#!/usr/bin/env bash
# =====================================================================
# FREIRAUM · Scheibe · Einladung senden
# Klauselpruefung gegen einen LAUFENDEN Server
#
# Geschrieben gegen K20 v1.3 (Zugaenge und Nutzer, EXMA), K03 v1.3 (fuer
# die Anmeldung, die die Sitzung herstellt), freiraum_datamodel.sql,
# M30__pilot_sammelmigration.sql und den Schnittstellenvertrag dieser
# Scheibe -- NICHT gegen den Umsetzungscode. Der Prueffall kennt den
# Server nur durch seine Tueren.
#
# Aufruf:
#   FREIRAUM_CODE_PFEFFER=... \
#   psql ... -f pruefungen/klauseln/versand_daten.sql                # Daten
#   FREIRAUM_PRUEF_URL=http://localhost:8099 \
#   FREIRAUM_CODE_PFEFFER=... \
#   pruefungen/klauseln/versand_lauf.sh                              # Faelle
#
# Umgebung:
#   FREIRAUM_PRUEF_URL    Vorgabe http://localhost:8099
#   PGHOST/PGPORT/PGUSER/PGPASSWORD/PGDATABASE
#                         Vorgabe localhost/55433/postgres/pilot/freiraum_pruef
#
# MASSSTAB F07: Vor dem ersten Fall wird der AUFBAU geprueft, UND die
# Sitzung wird hergestellt -- ohne sie misst kein einziger Fall dieser
# Scheibe etwas, denn jeder Vorgang an /einladung/senden verlangt sie.
# Gelingt beides nicht, bricht der Lauf mit Rueckgabewert 2 ab (ABBRUCH),
# statt Ergebnisse zu melden, die niemand tragen kann.
# =====================================================================

BASIS="${FREIRAUM_PRUEF_URL:-http://localhost:8099}"

: "${PGHOST:=localhost}"
: "${PGPORT:=55433}"
: "${PGUSER:=postgres}"
: "${PGPASSWORD:=pilot}"
: "${PGDATABASE:=freiraum_pruef}"
export PGHOST PGPORT PGUSER PGPASSWORD PGDATABASE

TENANT_ID='00000000-0000-4000-9000-0000000000f1'

ARBEIT="$(mktemp -d "${TMPDIR:-/tmp}/freiraum_versand.XXXXXX")"

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

# Portal EXMA IMMER auf ENABLED zurueck, egal wie der Lauf endet -- VE-08
# schaltet es fuer K20-D02 kurzzeitig auf PLANNED. Ohne diesen Trap bliebe
# ein abgebrochener Lauf mit PLANNED stehen und vergiftete jeden Folgelauf
# (derselbe Fehlertyp wie der vergessene uvicorn vom 10.08.2026).
cleanup() {
  psql -X -tAq -v ON_ERROR_STOP=1 \
       -c "UPDATE portal SET release_status='ENABLED' WHERE code IN ('EXMA','ENDUSER')" \
       >/dev/null 2>&1 || true
  rm -rf "$ARBEIT"
}
trap cleanup EXIT

abbruch() { printf 'ABBRUCH: %s\n' "$1"; printf 'SUMME: 0 von 0 bestanden, 0 gescheitert\n'; exit 2; }

db()  { psql -X -tAq -v ON_ERROR_STOP=1 -c "$1"; }
dbz() { psql -X -tAq -v ON_ERROR_STOP=1 -c "$1" | head -1; }

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

post_einladung() {   # $1 email  $2 anzeigename  $3 name  [$4 cookiewert]
  local p="$ARBEIT/$3" st ex=()
  [ -n "${4:-}" ] && ex=(-H "Cookie: fr_sitzung=$4")
  st=$(curl -sS -o "$p.rumpf" -D "$p.kopf" -w '%{http_code}' --max-time 25 \
        ${ex[@]+"${ex[@]}"} \
        --data-urlencode "email=$1" --data-urlencode "anzeigename=$2" \
        "$BASIS/einladung/senden" 2>"$p.fehler") || st="000"
  [ -f "$p.kopf" ] && saeubere_kopf "$p.kopf"
  printf '%s' "$st"
}

kopfzeile()    { grep -i "^$2:" "$ARBEIT/$1.kopf" 2>/dev/null | head -1 \
                 | sed "s/^[^:]*:[[:space:]]*//"; }
sitzungswert() { grep -i '^set-cookie:[[:space:]]*fr_sitzung=' "$ARBEIT/$1.kopf" 2>/dev/null | head -1 \
                 | sed 's/^[^=]*=//' | cut -d';' -f1; }
rumpf()        { printf '%s' "$ARBEIT/$1.rumpf"; }
hat_text()     { grep -qF "$2" "$ARBEIT/$1.rumpf" 2>/dev/null; }
hat_hex64()    { grep -Eq '[0-9a-fA-F]{64}' "$ARBEIT/$1.rumpf" 2>/dev/null; }

# ---------------------------------------------------------------------
# Vorpruefung: Werkzeug, Server, Datenlage
# ---------------------------------------------------------------------
command -v curl  >/dev/null 2>&1 || abbruch 'curl fehlt.'
command -v psql  >/dev/null 2>&1 || abbruch 'psql fehlt.'

db 'SELECT 1' >/dev/null 2>&1 || abbruch "Datenbank $PGDATABASE auf $PGHOST:$PGPORT nicht erreichbar."

[ -n "${FREIRAUM_CODE_PFEFFER:-}" ] || abbruch 'FREIRAUM_CODE_PFEFFER ist nicht gesetzt -- derselbe Wert wie am Server ist noetig, sonst stimmt kein Pruefwert (F07).'
case "$FREIRAUM_CODE_PFEFFER" in *"'"*) abbruch "FREIRAUM_CODE_PFEFFER enthaelt ein Hochkomma; das Pruefskript kann es nicht sicher in SQL setzen.";; esac

if [ "$(hole /gesundheit vorpruefung)" != "200" ]; then
  abbruch "Server unter $BASIS antwortet nicht auf GET /gesundheit. Erst starten, dann pruefen."
fi

lage="$(dbz "SELECT count(*) FROM pg_views WHERE viewname='pruef_versand_lage'")"
[ "$lage" = "1" ] || abbruch 'Sicht pruef_versand_lage fehlt -- versand_daten.sql zuerst einspielen.'

# AUFBAUPRUEFUNG (F07): dieselben Bedingungen wie in versand_daten.sql,
# hier aber unmittelbar vor dem Lauf -- die Daten koennten zwischenzeitlich
# durch einen fruehen Teil desselben Laufs veraendert worden sein.
aufbau="$(dbz "
SELECT string_agg(m, ' ') FROM (
  SELECT 'bootstrapadmin:' || status || '/' || exma_mitglied FROM pruef_versand_lage
   WHERE email='bootstrapadmin@pruef.example' AND (status<>'AKTIV' OR exma_mitglied<1)
  UNION ALL
  SELECT 'einladend:' || status || '/' || exma_mitglied || '/' || offene_codes FROM pruef_versand_lage
   WHERE email='einladend@pruef.example' AND (status<>'AKTIV' OR exma_mitglied<1 OR offene_codes<>1)
  UNION ALL
  SELECT 'wiederholt:' || status || '/' || einladungen_offen || '/' || coalesce(attempt_max::text,'-') FROM pruef_versand_lage
   WHERE email='wiederholt@pruef.example' AND (status<>'WARTET_2FA' OR einladungen_offen<>1 OR coalesce(attempt_max,-1)<>1)
  UNION ALL
  SELECT 'portal_exma:' || release_status FROM portal WHERE code='EXMA' AND release_status<>'ENABLED'
  UNION ALL
  SELECT 'tenant_domaene_oder_frist_falsch' FROM tenant
   WHERE id='$TENANT_ID' AND (invite_domain IS DISTINCT FROM 'pruef.example' OR invite_ttl_hours<>24)
) t")"
[ -z "$aufbau" ] || abbruch "Datenlage taugt nicht (F07): $aufbau -- versand_daten.sql neu einspielen."

# Der Fristwert und die Domaenenschranke werden aus der DB gelesen statt
# hier verdrahtet -- der Wortlaut der Waechtermeldung haengt an ihnen
# (K20-G04), und eine zweite Stelle mit demselben Wert waere Drift.
DOMAENE="$(dbz "SELECT invite_domain FROM tenant WHERE id='$TENANT_ID'")"
FRIST_STUNDEN="$(dbz "SELECT invite_ttl_hours FROM tenant WHERE id='$TENANT_ID'")"
MELDUNG_DOMAENE="Nur Adressen der Domaene @${DOMAENE} sind zulaessig"

# ---------------------------------------------------------------------
# Sitzung herstellen. Ohne sie ist JEDER Fall dieser Scheibe GESPERRT
# -- deshalb ABBRUCH (Rueckgabewert 2), nicht GESPERRT je Fall.
# ---------------------------------------------------------------------
st=$(post_anmeldung 'einladend@pruef.example' '300001' anmeldung)
KEKS="$(sitzungswert anmeldung)"
if [ "$st" != "303" ] || [ -z "$KEKS" ]; then
  abbruch "Sitzungsaufbau (Anmeldung als einladend@pruef.example) schlaegt fehl: Status $st, Cookie '${KEKS:-leer}'. Ohne Sitzung misst kein Fall dieser Scheibe etwas (Vertrag: Sitzung erforderlich)."
fi

printf 'FREIRAUM · Scheibe · Einladung senden — Klauselpruefung gegen %s\n' "$BASIS"
printf 'Datenlage: %s auf %s:%s · Aufbaupruefung (F07) bestanden · Sitzung als einladend@pruef.example steht\n\n' \
       "$PGDATABASE" "$PGHOST" "$PGPORT"

# =====================================================================
# VE-01 · Vertrag · GET /einladung/senden ohne Sitzung
# =====================================================================
st=$(hole /einladung/senden ve01)
ziel="$(kopfzeile ve01 location)"
m=""
[ "$st" = "303" ] || m="$m Status $st statt 303;"
case "$ziel" in *"/anmeldung"*) : ;; *) m="$m Location '$ziel' zeigt nicht auf /anmeldung;";; esac
[ -z "$m" ] && ok VE-01 'GET /einladung/senden ohne Sitzung fuehrt mit 303 auf /anmeldung' \
            || nok VE-01 "GET ohne Sitzung:$m"

# =====================================================================
# VE-02 · Vertrag · GET /einladung/senden mit Sitzung -- die Maske
# =====================================================================
st=$(hole /einladung/senden ve02 "$KEKS")
m=""
[ "$st" = "200" ] || m="$m Status $st statt 200;"
grep -Eqi '<form[^>]*method=["'"'"']?post' "$(rumpf ve02)" || m="$m kein Formular mit method=post;"
grep -Eqi 'name=["'"'"']?email["'"'"' >/]' "$(rumpf ve02)" || m="$m kein Feld name=\"email\";"
grep -Eqi 'name=["'"'"']?anzeigename["'"'"' >/]' "$(rumpf ve02)" || m="$m kein Feld name=\"anzeigename\";"
grep -Eqi '<button|type=["'"'"']?submit' "$(rumpf ve02)" || m="$m kein Absendeknopf;"
[ -z "$m" ] && ok VE-02 'GET /einladung/senden liefert mit Sitzung 200 und das Formular mit email und anzeigename' \
            || nok VE-02 "GET mit Sitzung entspricht dem Vertrag nicht:$m"

# =====================================================================
# VE-03 · K20-G01 (fail-closed) · POST /einladung/senden ohne Sitzung
#         Der Vertrag nennt "Sitzung erforderlich" ausdruecklich nur
#         unter GET; K20-G01 verlangt aber fail-closed fuer JEDEN
#         Vorgang. Erwartet wird dasselbe Verhalten wie bei GET
#         (VE-01) -- Gegenprobe ist VE-04, wo dieselbe Anfrage MIT
#         Sitzung traegt.
# =====================================================================
st=$(post_einladung 'ohne.sitzung@pruef.example' 'Pruef Ohne Sitzung' ve03)
ziel="$(kopfzeile ve03 location)"
entstanden="$(dbz "SELECT count(*) FROM invitation WHERE mail='ohne.sitzung@pruef.example'")"
m=""
[ "$st" = "303" ] || m="$m Status $st statt 303;"
case "$ziel" in *"/anmeldung"*) : ;; *) m="$m Location '$ziel' zeigt nicht auf /anmeldung;";; esac
[ "${entstanden:-1}" = "0" ] || m="$m es entstand eine Einladung ohne Sitzung;"
[ -z "$m" ] && ok VE-03 'POST /einladung/senden ohne Sitzung: kein Vorgang, keine Einladung entsteht (K20-G01)' \
            || nok VE-03 "POST ohne Sitzung:$m"

# =====================================================================
# VE-04 · POSITIVKONTROLLE · Vertrag + K20-M07 + K20-M08
#         Ein Regime, das alles abweist, bestuende jeden Negativtest.
#         Zugleich die Gegenprobe zu VE-03 und VE-06.
# =====================================================================
st=$(post_einladung 'neu@pruef.example' 'Pruef Neu' ve04 "$KEKS")
ziel="$(kopfzeile ve04 location)"
m=""
[ "$st" = "303" ] || m="$m Status $st statt 303;"
case "$ziel" in */einladung/senden\?gesendet=1) : ;; \
                *) m="$m Location '$ziel' zeigt nicht auf /einladung/senden?gesendet=1;";; esac
best_st=""
if [ -z "$m" ]; then
  best_st=$(hole '/einladung/senden?gesendet=1' ve04b "$KEKS")
  [ "$best_st" = "200" ] || m="$m die Bestaetigungsseite liefert $best_st statt 200;"
fi

invid="$(dbz "SELECT id FROM invitation WHERE mail='neu@pruef.example' AND status='VERSANDT'")"
token_hash=""
if [ -z "$invid" ]; then
  m="$m keine Einladung mit status=VERSANDT fuer neu@pruef.example entstanden;"
else
  portal="$(dbz "SELECT portal_code FROM invitation WHERE id='$invid'")"
  [ "$portal" = "EXMA" ] || m="$m portal_code ist '$portal' statt EXMA (K20-M07);"
  aktid="$(dbz "SELECT actor_id FROM invitation WHERE id='$invid'")"
  [ -n "$aktid" ] || m="$m invitation.actor_id ist leer (K20-M07: Konto);"
  frist_ok="$(dbz "SELECT (expires_at > sent_at) AND (expires_at <= sent_at + ('$FRIST_STUNDEN hours')::interval) FROM invitation WHERE id='$invid'")"
  [ "$frist_ok" = "t" ] || m="$m expires_at liegt nicht zwischen sent_at und der konfigurierten Frist (K20-M07);"
  token_hash="$(dbz "SELECT token_hash FROM invitation WHERE id='$invid'")"
  echo "$token_hash" | grep -qE '^[0-9a-f]{64}$' \
    || m="$m token_hash '$token_hash' sieht nicht wie ein sha256-Hexwert aus -- Verdacht auf Klartext (K20-M08);"
fi

# K20-M08: der Klartext-Token steht nie in der Fehler-/Erfolgsausgabe.
# Geprueft wird zweifach: der bekannte Streuwert selbst darf nicht
# erscheinen, UND es darf ueberhaupt keine 64-stellige Hexfolge in der
# Antwort auftauchen (das ist die einzige Form, in der ein Streuwert
# aussieht; ein Klartext-Link saehe anders aus, waere aber ebenso ein Fund).
if [ -n "$token_hash" ]; then
  hat_text ve04 "$token_hash" && m="$m die POST-Antwort enthaelt den gespeicherten Streuwert;"
  hat_text ve04b "$token_hash" && m="$m die Bestaetigungsseite enthaelt den gespeicherten Streuwert;"
fi
hat_hex64 ve04  && m="$m die POST-Antwort enthaelt eine 64-stellige Hexfolge (moeglicher Token-Leck, K20-M08);"
hat_hex64 ve04b && m="$m die Bestaetigungsseite enthaelt eine 64-stellige Hexfolge (moeglicher Token-Leck, K20-M08);"

[ -z "$m" ] && ok VE-04 'Sitzung, Adresse in der Domaene, freigeschaltetes Portal: 303 auf ?gesendet=1, Einladung mit Konto/Portal/Streuwert/Fristen entsteht, kein Klartext-Token sichtbar (K20-M07, K20-M08)' \
            || nok VE-04 "Positivfall:$m"

# =====================================================================
# VE-05 · K20-M18 · Nachweiszeile mit Zeitpunkt und der HANDELNDEN
#         Instanz -- das ist die Einladende aus der Sitzung
#         (einladend@pruef.example), NICHT der Eingeladene (neu@).
#         Haengt an VE-04.
# =====================================================================
if [ -z "$invid" ]; then
  sperr VE-05 'Nachweis nicht pruefbar: VE-04 hat keine Einladung erzeugt, also existiert keine object_ref=INVITATION:<id> zu pruefen'
else
  treffer="$(dbz "SELECT count(*) FROM event WHERE object_ref='INVITATION:$invid' AND occurred_at IS NOT NULL")"
  kennzeichnung="$(dbz "SELECT coalesce(e.actor_label,'') || '|' || coalesce(a.email,'') || '|' || coalesce(a.display_name,'')
                          FROM event e LEFT JOIN actor a ON a.id = e.actor_id
                         WHERE e.object_ref='INVITATION:$invid'
                         ORDER BY e.occurred_at DESC LIMIT 1")"
  m=""
  if [ "${treffer:-0}" -lt 1 ]; then
    m="$m kein Nachweis mit object_ref=INVITATION:$invid gefunden;"
  else
    case "$kennzeichnung" in
      *einladend@pruef.example*|*'Pruef Einladend'*) : ;;
      *) m="$m die handelnde Instanz im Nachweis identifiziert nicht einladend@pruef.example (Kennzeichnung: '$kennzeichnung');" ;;
    esac
    case "$kennzeichnung" in
      *neu@pruef.example*|*'Pruef Neu'*)
        m="$m die handelnde Instanz im Nachweis nennt den EINGELADENEN statt den Einladenden (K20-M18 verlangt die Sitzung);" ;;
    esac
  fi
  [ -z "$m" ] && ok VE-05 "Nachweiszeile zu INVITATION:$invid traegt Zeitpunkt und die Sitzung (einladend@pruef.example) als handelnde Instanz, nicht den Eingeladenen (K20-M18)" \
              || nok VE-05 "Nachweis:$m"
fi

# =====================================================================
# VE-06 · Negativ · K20-D04 + K20-M10 · Domaenenschranke
#         Alles andere ist erfuellt: Sitzung, freigeschaltetes Portal,
#         formal gueltige Adresse. Verletzt ist nur die Domaene.
#         Gegenprobe: VE-04 (Adresse in der Domaene traegt).
# =====================================================================
st=$(post_einladung 'niemand@fremde-domaene.example' 'Pruef Aussen' ve06 "$KEKS")
entstanden="$(dbz "SELECT count(*) FROM invitation WHERE mail='niemand@fremde-domaene.example'")"
m=""
[ "$st" = "200" ] || m="$m Status $st statt 200;"
hat_text ve06 "$MELDUNG_DOMAENE" || m="$m die Meldung '$MELDUNG_DOMAENE' fehlt im Wortlaut (K20-G04);"
hat_text ve06 'niemand@fremde-domaene.example' || m="$m die eingegebene Adresse steht nicht mehr im Formular (Vertrag: Eingaben bleiben stehen);"
[ "${entstanden:-1}" = "0" ] || m="$m es entstand trotzdem eine Einladung ausserhalb der Domaene (K20-D04);"
[ -z "$m" ] && ok VE-06 "Adresse ausserhalb @${DOMAENE}: 200 mit der Waechtermeldung im Wortlaut, keine Einladung entsteht (K20-D04, K20-M10, K20-G04)" \
            || nok VE-06 "Domaenenschranke:$m"

# =====================================================================
# VE-07 · POSITIVFALL mit drei Bedingungen · K20-M12 + K20-M13 + K20-D05
#         wiederholt@pruef.example traegt bereits eine offene Einladung
#         (attempt=1). Erneuter Versand MUSS: (1) die alte auf
#         WIDERRUFEN setzen -- NICHT ABGELAUFEN, NICHT EINGELOEST
#         (K20-D05) --, (2) attempt erhoehen, (3) wieder genau eine
#         offene Einladung hinterlassen (K20-M12).
# =====================================================================
alte_id="$(dbz "SELECT id FROM invitation WHERE actor_id=(SELECT id FROM actor WHERE email='wiederholt@pruef.example') AND status='VERSANDT'")"
alter_attempt="$(dbz "SELECT attempt FROM invitation WHERE id='$alte_id'")"
if [ -z "$alte_id" ] || [ -z "$alter_attempt" ]; then
  sperr VE-07 'Erneuter Versand nicht pruefbar: die vorbereitete offene Einladung fuer wiederholt@pruef.example fehlt (Datenlage pruefen)'
else
  st=$(post_einladung 'wiederholt@pruef.example' 'Pruef Wiederholt Erneut' ve07 "$KEKS")
  ziel="$(kopfzeile ve07 location)"
  m=""
  [ "$st" = "303" ] || m="$m Status $st statt 303;"
  case "$ziel" in */einladung/senden\?gesendet=1) : ;; \
                  *) m="$m Location '$ziel' zeigt nicht auf /einladung/senden?gesendet=1;";; esac

  alter_status_danach="$(dbz "SELECT status FROM invitation WHERE id='$alte_id'")"
  offene_danach="$(dbz "SELECT count(*) FROM invitation WHERE actor_id=(SELECT id FROM actor WHERE email='wiederholt@pruef.example') AND status='VERSANDT'")"
  neuer_attempt="$(dbz "SELECT max(attempt) FROM invitation WHERE actor_id=(SELECT id FROM actor WHERE email='wiederholt@pruef.example') AND status='VERSANDT'")"
  konten="$(dbz "SELECT count(*) FROM actor WHERE email='wiederholt@pruef.example'")"

  # (1) NICHT ueber ABGELAUFEN oder EINGELOEST frei geworden -- allein WIDERRUFEN (K20-D05).
  case "$alter_status_danach" in
    WIDERRUFEN) : ;;
    ABGELAUFEN|EINGELOEST) m="$m die alte Einladung wurde auf $alter_status_danach gesetzt statt WIDERRUFEN -- K20-D05 verbietet genau diesen Weg;" ;;
    *) m="$m die alte Einladung steht auf '$alter_status_danach' statt WIDERRUFEN;" ;;
  esac
  # (2) attempt erhoeht.
  if [ -n "$neuer_attempt" ] && [ "$neuer_attempt" -eq $((alter_attempt + 1)) ]; then :
  else m="$m attempt ist '$neuer_attempt' statt $((alter_attempt + 1)) (K20-M13);"
  fi
  # (3) wieder genau eine offene (K20-M12).
  [ "$offene_danach" = "1" ] || m="$m es bestehen $offene_danach offene Einladungen statt genau einer (K20-M12);"
  [ "$konten" = "1" ] || m="$m es entstand ein zusaetzliches Konto fuer dieselbe Adresse ($konten statt 1);"

  [ -z "$m" ] && ok VE-07 "Erneuter Versand: alte Einladung WIDERRUFEN (nicht ABGELAUFEN/EINGELOEST), attempt $alter_attempt->$neuer_attempt, wieder genau eine offene (K20-M12, K20-M13, K20-D05)" \
              || nok VE-07 "Erneuter Versand:$m"
fi

# =====================================================================
# VE-08 · Negativ · K20-D02 · Kein Versand fuer ein Portal mit
#         release_status = PLANNED. Da die Maske kein Portal zur Wahl
#         stellt, ist das Zielportal dieser Scheibe fest EXMA (Abschnitt
#         4.1 des Konzepts) -- der Fall schaltet EXMA selbst kurzzeitig
#         auf PLANNED und stellt es sofort danach zurueck (siehe auch
#         den cleanup()-Trap oben, der das bei jedem Ausgang absichert).
#         Gemessen wird NUR die eine Bedingung, die K20-D02 verbietet:
#         es DARF keine Einladung entstehen -- unabhaengig davon, ueber
#         welchen Statuscode der Server das im Einzelnen zeigt, denn
#         der Vertrag legt fuer diesen Fall (Zielportal selbst
#         abgeschaltet) keinen bestimmten Code fest.
#         Gegenprobe: VE-04 (EXMA ENABLED, derselbe Vorgang traegt).
# =====================================================================
db "UPDATE portal SET release_status='PLANNED' WHERE code='EXMA'" >/dev/null
st=$(post_einladung 'geplant@pruef.example' 'Pruef Geplant' ve08 "$KEKS")
db "UPDATE portal SET release_status='ENABLED' WHERE code='EXMA'" >/dev/null
entstanden="$(dbz "SELECT count(*) FROM invitation WHERE mail='geplant@pruef.example'")"
m=""
[ "${entstanden:-1}" = "0" ] || m="$m es entstand eine Einladung, obwohl EXMA auf PLANNED stand (K20-D02);"
[ "$st" = "303" ] && m="$m der Vorgang meldete 303 (Erfolg), obwohl EXMA auf PLANNED stand;"
[ -z "$m" ] && ok VE-08 "Portal EXMA auf PLANNED: kein Versand, keine Einladung entsteht (K20-D02; beobachteter Status: $st)" \
            || nok VE-08 "PLANNED-Portal:$m"

# =====================================================================
printf '\n'
[ "$gesperrt" -gt 0 ] && printf 'davon GESPERRT (nicht messbar, zaehlt nach K23-M22 nicht als bestanden): %s\n' "$gesperrt"
printf 'SUMME: %s von %s bestanden, %s gescheitert\n' "$bestanden" "$gesamt" "$gescheitert"
[ "$gescheitert" -eq 0 ]
