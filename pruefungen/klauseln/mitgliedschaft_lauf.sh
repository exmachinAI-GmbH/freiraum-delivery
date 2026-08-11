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

ok()  { gesamt=$((gesamt+1)); bestanden=$((bestanden+1))
        printf '%-7s BESTANDEN    %s\n' "$1" "$2"; }
nok() { gesamt=$((gesamt+1)); gescheitert=$((gescheitert+1))
        printf '%-7s GESCHEITERT  %s\n' "$1" "$(printf '%s' "$2" | tr '\n' ' ')"; }
# K23-M22: Was nicht gemessen werden konnte, ist GESPERRT -- nicht
# bestanden. In der Summe zaehlt es zu den gescheiterten Faellen, denn
# ein Lauf, der nichts gemessen hat, ist kein gruener Lauf.
sperr() { gesamt=$((gesamt+1)); gescheitert=$((gescheitert+1)); gesperrt=$((gesperrt+1))
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

db 'SELECT 1' >/dev/null 2>&1 || abbruch "Datenbank $PGDATABASE auf $PGHOST:$PGPORT nicht erreichbar."

[ -n "${FREIRAUM_CODE_PFEFFER:-}" ] || abbruch 'FREIRAUM_CODE_PFEFFER ist nicht gesetzt -- derselbe Wert wie am Server ist noetig, sonst stimmt kein Pruefwert (F07).'
case "$FREIRAUM_CODE_PFEFFER" in *"'"*) abbruch "FREIRAUM_CODE_PFEFFER enthaelt ein Hochkomma; das Pruefskript kann es nicht sicher in SQL setzen.";; esac

if [ "$(hole /gesundheit vorpruefung)" != "200" ]; then
  abbruch "Server unter $BASIS antwortet nicht auf GET /gesundheit. Erst starten, dann pruefen."
fi

lage="$(dbz "SELECT count(*) FROM pg_views WHERE viewname='pruef_mitgliedschaft_lage'")"
[ "$lage" = "1" ] || abbruch 'Sicht pruef_mitgliedschaft_lage fehlt -- mitgliedschaft_daten.sql zuerst einspielen.'

# AUFBAUPRUEFUNG (F07): dieselben Bedingungen wie in mitgliedschaft_daten.sql,
# hier aber unmittelbar vor dem Lauf.
aufbau="$(dbz "
SELECT string_agg(m, ' ') FROM (
  SELECT 'bootstrapadmin:' || status || '/' || mitgliedschaft_exma FROM pruef_mitgliedschaft_lage
   WHERE email='bootstrapadmin@pruef.example' AND (status<>'AKTIV' OR mitgliedschaft_exma<1)
  UNION ALL
  SELECT 'einladend:' || status || '/' || mitgliedschaft_exma || '/' || offene_codes FROM pruef_mitgliedschaft_lage
   WHERE email='einladend@pruef.example' AND (status<>'AKTIV' OR mitgliedschaft_exma<1 OR offene_codes<>1)
  UNION ALL
  SELECT 'mg_wiederholt:' || status || '/' || einladungen_offen || '/' || coalesce(attempt_max::text,'-') || '/' || mitgliedschaft_exma
    FROM pruef_mitgliedschaft_lage
   WHERE email='mg_wiederholt@pruef.example'
     AND (status<>'WARTET_2FA' OR einladungen_offen<>1 OR coalesce(attempt_max,-1)<>1 OR mitgliedschaft_exma<>1)
  UNION ALL
  SELECT 'mg_aktiv:' || status || '/' || einladungen_eingeloest || '/' || mitgliedschaft_exma FROM pruef_mitgliedschaft_lage
   WHERE email='mg_aktiv@pruef.example' AND (status<>'AKTIV' OR einladungen_eingeloest<>1 OR mitgliedschaft_exma<>1)
  UNION ALL
  SELECT 'mg_bereitsmitglied:' || status || '/' || einladungen_offen || '/' || mitgliedschaft_exma FROM pruef_mitgliedschaft_lage
   WHERE email='mg_bereitsmitglied@pruef.example' AND (status<>'WARTET_2FA' OR einladungen_offen<>1 OR mitgliedschaft_exma<>1)
  UNION ALL
  SELECT 'mg_abgelaufen:' || status || '/' || mitgliedschaft_exma FROM pruef_mitgliedschaft_lage
   WHERE email='mg_abgelaufen@pruef.example' AND (status<>'WARTET_2FA' OR mitgliedschaft_exma<>1)
  UNION ALL
  SELECT 'mg_zweitportal:' || status || '/' || mitgliedschaft_exma || '/' || mitgliedschaft_enduser || '/' || offene_codes
    FROM pruef_mitgliedschaft_lage
   WHERE email='mg_zweitportal@pruef.example'
     AND (status<>'AKTIV' OR mitgliedschaft_exma<>1 OR mitgliedschaft_enduser<>1 OR offene_codes<>1)
  UNION ALL
  SELECT 'dynamisches_fallziel_existiert_schon' FROM actor
   WHERE email IN ('mg_neu@pruef.example','mg_geplant@pruef.example','mg_faden@pruef.example')
  UNION ALL
  SELECT 'portal_exma:' || release_status FROM portal WHERE code='EXMA' AND release_status<>'ENABLED'
  UNION ALL
  SELECT 'portal_enduser:' || release_status FROM portal WHERE code='ENDUSER' AND release_status<>'ENABLED'
  UNION ALL
  SELECT 'tenant_domaene_oder_frist_falsch' FROM tenant
   WHERE id='$TENANT_ID' AND (invite_domain IS DISTINCT FROM 'pruef.example' OR invite_ttl_hours<>24)
) t")"
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

# =====================================================================
# MG-08 · Vertrag ("beim Ablauf verschwindet sie wieder") · Ablauf,
#         SOWEIT UEBER DIE BEKANNTEN TUEREN MESSBAR. Es ist keine
#         Schnittstelle bekannt, die einen Aufraeumlauf fuer abgelaufene
#         Einladungen ausdruecklich ausloest (siehe Abschlussbericht).
#         Gemessen wird darum ueber die einzige bekannte Tuer, die einen
#         abgelaufenen Token ueberhaupt anfasst -- POST /einladung --
#         und TOLERANT ausgewertet: loest sie den Zustandswechsel aus,
#         MUSS die Mitgliedschaft weg sein; loest sie ihn nicht aus,
#         bleibt der Fall GESPERRT statt einen Fehlschlag an der
#         falschen Bedingung zu melden (F07).
# =====================================================================
MG08_AKTID="$(dbz "SELECT id FROM actor WHERE email='mg_abgelaufen@pruef.example'")"
mg08_mzahl_vor="$(dbz "SELECT count(*) FROM membership WHERE actor_id='$MG08_AKTID'")"
mg08_status_vor="$(dbz "SELECT status FROM invitation WHERE actor_id='$MG08_AKTID'")"
if [ "${mg08_mzahl_vor:-0}" != "1" ] || [ "$mg08_status_vor" != "VERSANDT" ]; then
  sperr MG-08 "Ablauf nicht pruefbar: mg_abgelaufen@ traegt nicht die vorbereitete Ausgangslage (Mitgliedschaften=${mg08_mzahl_vor:-?}, invitation.status=$mg08_status_vor)"
else
  st=$(post_einladung_einloesen 'tok-mg-abgelaufen-7c2f9a4e1d6b0842' mg08)
  mg08_status_nach="$(dbz "SELECT status FROM invitation WHERE actor_id='$MG08_AKTID'")"
  mg08_mzahl_nach="$(dbz "SELECT count(*) FROM membership WHERE actor_id='$MG08_AKTID'")"
  case "$mg08_status_nach" in
    ABGELAUFEN)
      if [ "${mg08_mzahl_nach:-1}" = "0" ]; then
        ok MG-08 "Der Versuch auf einen abgelaufenen Token setzt die Einladung auf ABGELAUFEN und entfernt im selben Zug die Mitgliedschaft (Vertrag; beobachteter Status: $st)"
      else
        nok MG-08 "Ablauf: invitation.status wurde auf ABGELAUFEN gesetzt, die Mitgliedschaft besteht aber weiterhin ($mg08_mzahl_nach Mal) -- Vertragsverstoss (beim Ablauf verschwindet sie wieder)"
      fi
      ;;
    VERSANDT)
      sperr MG-08 "Ablauf ueber POST /einladung mit abgelaufenem Token loest keinen Zustandswechsel aus (invitation.status bleibt VERSANDT) -- der Vertragssatz 'beim Ablauf verschwindet sie wieder' ist ueber KEINE bekannte Tuer pruefbar (offener Punkt, siehe Abschlussbericht); beobachteter Status: $st"
      ;;
    *)
      nok MG-08 "Ablauf: invitation.status steht unerwartet auf '$mg08_status_nach' nach dem Versuch mit abgelaufenem Token (beobachteter Status: $st)"
      ;;
  esac
fi

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

# =====================================================================
printf '\n'
[ "$gesperrt" -gt 0 ] && printf 'davon GESPERRT (nicht messbar, zaehlt nach K23-M22 nicht als bestanden): %s\n' "$gesperrt"
printf 'SUMME: %s von %s bestanden, %s gescheitert\n' "$bestanden" "$gesamt" "$gescheitert"
[ "$gescheitert" -eq 0 ]
