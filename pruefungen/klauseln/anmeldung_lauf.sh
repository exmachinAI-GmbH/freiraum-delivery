#!/usr/bin/env bash
# =====================================================================
# FREIRAUM · Scheibe 1 · Anmeldung
# Klauselpruefung gegen einen LAUFENDEN Server
#
# Geschrieben gegen K03 v1.3, K19 EN-01, freiraum_datamodel.sql,
# M30__pilot_sammelmigration.sql und den Schnittstellenvertrag --
# NICHT gegen den Umsetzungscode. Der Prueffall kennt den Server nur
# durch seine Tueren.
#
# Aufruf:
#   FREIRAUM_CODE_PFEFFER=... \
#   psql ... -f pruefungen/klauseln/anmeldung_daten.sql          # Daten
#   FREIRAUM_PRUEF_URL=http://localhost:8099 \
#   FREIRAUM_CODE_PFEFFER=... \
#   pruefungen/klauseln/anmeldung_lauf.sh                        # Faelle
#
# Umgebung:
#   FREIRAUM_PRUEF_URL    Vorgabe http://localhost:8099
#   FREIRAUM_PRUEF_REPO   Vorgabe: zwei Ebenen ueber diesem Skript
#   FREIRAUM_TLS          wie am Server gesetzt (steuert die Secure-Erwartung)
#   PGHOST/PGPORT/PGUSER/PGPASSWORD/PGDATABASE
#                         Vorgabe localhost/55433/postgres/pilot/freiraum_pruef
#
# MASSSTAB F07: Vor dem ersten Fall wird der AUFBAU geprueft. Ein Fall,
# der an einem fehlenden Datensatz oder einer fremden Bedingung
# scheitert, misst nichts -- deshalb bricht der Lauf dann ab, statt
# Ergebnisse zu melden, die niemand tragen kann.
# =====================================================================

BASIS="${FREIRAUM_PRUEF_URL:-http://localhost:8099}"
HIER="$(cd "$(dirname "$0")" && pwd)"
REPO="${FREIRAUM_PRUEF_REPO:-$(cd "$HIER/../.." && pwd)}"

: "${PGHOST:=localhost}"
: "${PGPORT:=55433}"
: "${PGUSER:=postgres}"
: "${PGPASSWORD:=pilot}"
: "${PGDATABASE:=freiraum_pruef}"
export PGHOST PGPORT PGUSER PGPASSWORD PGDATABASE

# Der Wortlaut aus dem Vertrag und K03-M16. Zeichen fuer Zeichen.
MELDUNG='Anmeldung nicht moeglich. Pruefen Sie Adresse und Code.'

ARBEIT="$(mktemp -d "${TMPDIR:-/tmp}/freiraum_anmeldung.XXXXXX")"
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

post_anmeldung() {   # $1 email  $2 code  $3 name  [$4 cookiewert]
  local p="$ARBEIT/$3" st ex=()
  [ -n "${4:-}" ] && ex=(-H "Cookie: fr_sitzung=$4")
  st=$(curl -sS -o "$p.rumpf" -D "$p.kopf" -w '%{http_code}' --max-time 25 \
        ${ex[@]+"${ex[@]}"} \
        --data-urlencode "email=$1" --data-urlencode "code=$2" \
        "$BASIS/anmeldung" 2>"$p.fehler") || st="000"
  [ -f "$p.kopf" ] && saeubere_kopf "$p.kopf"
  printf '%s' "$st"
}

hole() {             # $1 pfad  $2 name  [$3 cookiewert]
  local p="$ARBEIT/$2" st ex=()
  [ -n "${3:-}" ] && ex=(-H "Cookie: fr_sitzung=$3")
  st=$(curl -sS -o "$p.rumpf" -D "$p.kopf" -w '%{http_code}' --max-time 25 \
        ${ex[@]+"${ex[@]}"} "$BASIS$1" 2>"$p.fehler") || st="000"
  [ -f "$p.kopf" ] && saeubere_kopf "$p.kopf"
  printf '%s' "$st"
}

sende() {            # $1 pfad  $2 name  [$3 cookiewert]   -- POST ohne Rumpf
  local p="$ARBEIT/$2" st ex=()
  [ -n "${3:-}" ] && ex=(-H "Cookie: fr_sitzung=$3")
  st=$(curl -sS -o "$p.rumpf" -D "$p.kopf" -w '%{http_code}' --max-time 25 \
        -X POST ${ex[@]+"${ex[@]}"} "$BASIS$1" 2>"$p.fehler") || st="000"
  [ -f "$p.kopf" ] && saeubere_kopf "$p.kopf"
  printf '%s' "$st"
}

kopfzeile()    { grep -i "^$2:" "$ARBEIT/$1.kopf" 2>/dev/null | head -1 \
                 | sed "s/^[^:]*:[[:space:]]*//"; }
sitzungszeile(){ grep -i '^set-cookie:[[:space:]]*fr_sitzung=' "$ARBEIT/$1.kopf" 2>/dev/null | head -1; }
sitzungszahl() { [ -f "$ARBEIT/$1.kopf" ] || { printf '0'; return; }
                 grep -ic '^set-cookie:[[:space:]]*fr_sitzung=' "$ARBEIT/$1.kopf"; }
sitzungswert() { sitzungszeile "$1" | sed 's/^[^=]*=//' | cut -d';' -f1; }
rumpf()        { printf '%s' "$ARBEIT/$1.rumpf"; }
hat_meldung()  { grep -qF "$MELDUNG" "$ARBEIT/$1.rumpf" 2>/dev/null; }

# Ein Rumpf, aus dem alles entfernt ist, was sich zwischen zwei Faellen
# zulaessig unterscheiden darf: die eingegebene Adresse, sechsstellige
# Ziffernfolgen und lange Zeichenketten (Nonce, Marke). Was danach noch
# verschieden ist, unterscheidet die Faelle -- und das ist eine Auskunft.
normiere() {
  sed -e 's/[A-Za-z0-9._%+-]*@pruef\.example/ADRESSE/g' \
      -e 's/[0-9][0-9][0-9][0-9][0-9][0-9]/ZIFFERN/g' \
      -e 's/[A-Za-z0-9_-]\{20,\}/MARKE/g' \
      -e 's/[[:space:]][[:space:]]*/ /g' "$1"
}

versuche_leeren() {  # $1 optional: diese Adresse behalten
  if [ -n "${1:-}" ]; then
    db "DELETE FROM login_attempt WHERE email LIKE '%@pruef.example' AND lower(email) <> lower('$1');" >/dev/null 2>&1
  else
    db "DELETE FROM login_attempt WHERE email LIKE '%@pruef.example';" >/dev/null 2>&1
  fi
}

freier_port() { python3 -c 'import socket;s=socket.socket();s.bind(("127.0.0.1",0));print(s.getsockname()[1]);s.close()'; }

# ---------------------------------------------------------------------
# Vorpruefung: Werkzeug, Server, Datenlage
# ---------------------------------------------------------------------
command -v curl  >/dev/null 2>&1 || abbruch 'curl fehlt.'
command -v psql  >/dev/null 2>&1 || abbruch 'psql fehlt.'
command -v python3 >/dev/null 2>&1 || abbruch 'python3 fehlt (Kekspruefung AN-05, JSON AN-02).'

db 'SELECT 1' >/dev/null 2>&1 || abbruch "Datenbank $PGDATABASE auf $PGHOST:$PGPORT nicht erreichbar."

# Der Pfeffer wird gebraucht: AN-26 stellt einen weiteren Code aus, und
# ohne ihn stimmte kein Pruefwert. Ein Positivfall, der am Pfeffer
# scheitert, misst nichts (F07).
[ -n "${FREIRAUM_CODE_PFEFFER:-}" ] || abbruch 'FREIRAUM_CODE_PFEFFER ist nicht gesetzt -- derselbe Wert wie am Server ist noetig.'
case "$FREIRAUM_CODE_PFEFFER" in *"'"*) abbruch "FREIRAUM_CODE_PFEFFER enthaelt ein Hochkomma; das Pruefskript kann es nicht sicher in SQL setzen.";; esac

if [ "$(hole /gesundheit vorpruefung)" != "200" ]; then
  abbruch "Server unter $BASIS antwortet nicht auf GET /gesundheit. Erst starten, dann pruefen."
fi

lage="$(dbz "SELECT count(*) FROM pg_views WHERE viewname='pruef_anmeldung_lage'")"
[ "$lage" = "1" ] || abbruch 'Sicht pruef_anmeldung_lage fehlt -- anmeldung_daten.sql zuerst einspielen.'

# AUFBAUPRUEFUNG (F07): dieselben Bedingungen wie in anmeldung_daten.sql,
# hier aber unmittelbar vor dem Lauf -- die Daten koennten zwischenzeitlich
# durch einen frueheren Lauf verbraucht worden sein.
aufbau="$(dbz "
SELECT string_agg(m, ' ') FROM (
  SELECT email || ':status=' || status AS m FROM pruef_anmeldung_lage
   WHERE (email IN ('positiv@pruef.example','untaetig@pruef.example','achtstunden@pruef.example',
                    'abmeldung@pruef.example','sperrmitten@pruef.example','zweiportale@pruef.example',
                    'ohneportal@pruef.example','falschercode@pruef.example','abgelaufen@pruef.example',
                    'verbraucht@pruef.example','entwertet@pruef.example','drossel@pruef.example',
                    'zweitanmeldung@pruef.example','leercode@pruef.example') AND status <> 'AKTIV')
      OR (email IN ('wartetfalsch@pruef.example','wartetrichtig@pruef.example') AND status <> 'WARTET_2FA')
      OR (email = 'gesperrt@pruef.example' AND status <> 'GESPERRT')
  UNION ALL
  SELECT email || ':offene_codes=' || offene_codes FROM pruef_anmeldung_lage
   WHERE (email IN ('positiv@pruef.example','untaetig@pruef.example','achtstunden@pruef.example',
                    'abmeldung@pruef.example','sperrmitten@pruef.example','zweiportale@pruef.example',
                    'ohneportal@pruef.example','falschercode@pruef.example','gesperrt@pruef.example',
                    'drossel@pruef.example','wartetfalsch@pruef.example','wartetrichtig@pruef.example',
                    'zweitanmeldung@pruef.example','leercode@pruef.example','entwertet@pruef.example')
          AND offene_codes <> 1)
      OR (email IN ('abgelaufen@pruef.example','verbraucht@pruef.example') AND offene_codes <> 0)
  UNION ALL
  SELECT email || ':freigeschaltete_portale=' || freigeschaltete_portale FROM pruef_anmeldung_lage
   WHERE (email = 'ohneportal@pruef.example' AND mitgliedschaften <> 0)
      OR (email = 'zweiportale@pruef.example' AND freigeschaltete_portale <> 2)
      OR (email NOT IN ('ohneportal@pruef.example') AND freigeschaltete_portale < 1)
  UNION ALL
  SELECT 'unbekannt@pruef.example:existiert' FROM actor WHERE email='unbekannt@pruef.example'
  UNION ALL
  SELECT email || ':last_login_at_trotz_WARTET_2FA' FROM pruef_anmeldung_lage
   WHERE status='WARTET_2FA' AND last_login_at IS NOT NULL
) t")"
[ -z "$aufbau" ] || abbruch "Datenlage taugt nicht (F07): $aufbau -- anmeldung_daten.sql neu einspielen."

versuche_leeren

printf 'FREIRAUM · Scheibe 1 · Anmeldung — Klauselpruefung gegen %s\n' "$BASIS"
printf 'Datenlage: %s auf %s:%s · Aufbaupruefung (F07) bestanden\n\n' "$PGDATABASE" "$PGHOST" "$PGPORT"

# =====================================================================
# AN-01 · Vertrag + K19 EN-01 · Die Anmeldemaske
# =====================================================================
st=$(hole /anmeldung an01)
m=""
[ "$st" = "200" ] || m="$m Status $st statt 200;"
grep -Eqi '<form[^>]*method=["'"'"']?post' "$(rumpf an01)" || m="$m kein Formular mit method=post;"
grep -Eqi 'name=["'"'"']?email["'"'"' >/]' "$(rumpf an01)" || m="$m kein Feld name=\"email\";"
grep -Eqi 'name=["'"'"']?code["'"'"' >/]' "$(rumpf an01)"  || m="$m kein Feld name=\"code\";"
grep -Eqi '<button|type=["'"'"']?submit' "$(rumpf an01)"   || m="$m kein Absendeknopf;"
[ -z "$m" ] && ok AN-01 'GET /anmeldung liefert 200 und die Maske EN-01 mit email, code und Absendeknopf' \
            || nok AN-01 "GET /anmeldung entspricht EN-01 nicht:$m"

# =====================================================================
# AN-02 · Vertrag · Gesundheit ohne Sitzung
# =====================================================================
st=$(hole /gesundheit an02)
m=""
[ "$st" = "200" ] || m="$m Status $st statt 200;"
python3 -c 'import json,sys
d=json.load(open(sys.argv[1]))
sys.exit(0 if d.get("status")=="ok" else 1)' "$(rumpf an02)" 2>/dev/null \
  || m="$m Rumpf ist nicht {\"status\":\"ok\"};"
[ -z "$m" ] && ok AN-02 'GET /gesundheit ist ohne Sitzung erreichbar und meldet {"status":"ok"}' \
            || nok AN-02 "GET /gesundheit:$m"

# =====================================================================
# AN-03 · K03-D01 · Ohne Sitzung kein Vorgang
# =====================================================================
st=$(hole / an03)
ziel="$(kopfzeile an03 location)"
m=""
[ "$st" = "303" ] || m="$m Status $st statt 303;"
case "$ziel" in *"/anmeldung"*) : ;; *) m="$m Location '$ziel' zeigt nicht auf /anmeldung;";; esac
[ -z "$m" ] && ok AN-03 'GET / ohne Sitzung fuehrt mit 303 auf /anmeldung (K03-D01)' \
            || nok AN-03 "GET / ohne Sitzung:$m"

# =====================================================================
# AN-04 · POSITIVFALL · Ein Regime, das alles abweist, bestuende jeden
#         Negativtest. K03-M06, K03-M11, K03-D01, Vertrag.
# =====================================================================
vorher="$(dbz "SELECT coalesce(last_login_at::text,'') FROM actor WHERE email='positiv@pruef.example'")"
st=$(post_anmeldung 'positiv@pruef.example' '100002' an04)
keks="$(sitzungswert an04)"
ziel="$(kopfzeile an04 location)"
m=""
[ "$st" = "303" ] || m="$m Status $st statt 303;"
case "$ziel" in "/"|"$BASIS"|"$BASIS/") : ;; *) m="$m Location '$ziel' statt /;";; esac
[ -n "$keks" ]    || m="$m kein Cookie fr_sitzung gesetzt;"
if [ -n "$keks" ]; then
  st2=$(hole / an04b "$keks")
  [ "$st2" = "200" ] || m="$m GET / mit Sitzung liefert $st2 statt 200;"
fi
[ -z "$m" ] && ok AN-04 'Aktives Konto, gueltiger sechsstelliger Code: 303 auf /, Cookie fr_sitzung, GET / = 200' \
            || nok AN-04 "Positivfall:$m"

# =====================================================================
# AN-05 · Vertrag · Eigenschaften des Sitzungskeks
# =====================================================================
zeile="$(sitzungszeile an04)"
m=""
if [ -z "$zeile" ]; then
  m=" es wurde kein Cookie gesetzt (siehe AN-04);"
else
  printf '%s' "$zeile" | grep -qi 'httponly'      || m="$m HttpOnly fehlt;"
  printf '%s' "$zeile" | grep -qi 'samesite=lax'  || m="$m SameSite=Lax fehlt;"
  if [ "${FREIRAUM_TLS:-}" = "1" ]; then
    printf '%s' "$zeile" | grep -qi 'secure'      || m="$m Secure fehlt trotz FREIRAUM_TLS=1;"
  else
    printf '%s' "$zeile" | grep -qi 'secure'      && m="$m Secure gesetzt ohne FREIRAUM_TLS=1;"
  fi
  kennung="$(dbz "SELECT id FROM actor WHERE email='positiv@pruef.example'")"
  roh="$(python3 -c '
import base64,sys
wert=sys.argv[1]
sicht=[wert]
for teil in wert.replace(":",".").replace("|",".").split("."):
    rest=teil+"="*((4-len(teil)%4)%4)
    for f in (base64.urlsafe_b64decode, base64.b64decode):
        try: sicht.append(f(rest).decode("utf-8","replace"))
        except Exception: pass
print(" ".join(sicht))' "$keks" 2>/dev/null)"
  case "$roh" in
    *positiv@pruef.example*)  m="$m Cookie traegt die Adresse im Klartext;";;
  esac
  case "$roh" in
    *"$kennung"*)             m="$m Cookie traegt actor.id im Klartext;";;
  esac
  case "$roh" in
    *"Pruef Positiv"*)        m="$m Cookie traegt den Anzeigenamen im Klartext;";;
  esac
fi
[ -z "$m" ] && ok AN-05 'Cookie fr_sitzung: HttpOnly, SameSite=Lax, Secure passend zu FREIRAUM_TLS, keine Rohdaten des Kontos' \
            || nok AN-05 "Cookie fr_sitzung:$m"

# =====================================================================
# AN-06 · K03-M09 / K03 Abschn. 5.3 · Die Anmeldung schreibt
#         last_login_at fort, der Zustand bleibt AKTIV
# =====================================================================
nachher="$(dbz "SELECT coalesce(last_login_at::text,'') FROM actor WHERE email='positiv@pruef.example'")"
zustand="$(dbz "SELECT status FROM actor WHERE email='positiv@pruef.example'")"
m=""
[ "$zustand" = "AKTIV" ] || m="$m status ist $zustand statt AKTIV;"
[ -n "$nachher" ]        || m="$m last_login_at ist nach der Anmeldung leer;"
if [ -n "$nachher" ] && [ "$nachher" = "$vorher" ]; then
  m="$m last_login_at unveraendert ($vorher);"
fi
[ -z "$m" ] && ok AN-06 'Erfolgreiche Anmeldung setzt last_login_at fort und haelt AKTIV (K03-M09)' \
            || nok AN-06 "last_login_at nach der Anmeldung:$m"

# =====================================================================
# AN-07 · K03-M17 · 30 Minuten Untaetigkeit, serverseitig geprueft
# =====================================================================
st=$(post_anmeldung 'untaetig@pruef.example' '100003' an07)
keks="$(sitzungswert an07)"
if [ "$st" != "303" ] || [ -z "$keks" ]; then
  sperr AN-07 "Untaetigkeitsgrenze nicht messbar: die Anmeldung selbst scheiterte (Status $st, Cookie '${keks:-leer}')"
else
  st2=$(hole / an07b "$keks")
  if [ "$st2" != "200" ]; then
    sperr AN-07 "Untaetigkeitsgrenze nicht messbar: GET / mit frischer Sitzung liefert $st2 statt 200"
  else
    n="$(dbz "UPDATE auth_session SET started_at = now() - interval '40 minutes',
                                       last_activity_at = now() - interval '31 minutes'
                WHERE actor_id=(SELECT id FROM actor WHERE email='untaetig@pruef.example')
                  AND ended_at IS NULL
              RETURNING 1" | wc -l | tr -d ' ')"
    if [ "$n" = "0" ]; then
      sperr AN-07 'keine Zeile in auth_session -- eine serverseitige Untaetigkeitsgrenze ist so nicht pruefbar (K03-M13, fail-closed K03-G01)'
    else
      st3=$(hole / an07c "$keks")
      ziel="$(kopfzeile an07c location)"
      m=""
      [ "$st3" = "303" ] || m="$m GET / liefert $st3 statt 303 nach 31 Minuten Untaetigkeit;"
      case "$ziel" in *"/anmeldung"*) : ;; *) m="$m Location '$ziel' zeigt nicht auf /anmeldung;";; esac
      [ -z "$m" ] && ok AN-07 'Sitzung endet nach 30 Minuten Untaetigkeit, der Server prueft es (K03-M17)' \
                  || nok AN-07 "30-Minuten-Grenze:$m"
    fi
  fi
fi

# =====================================================================
# AN-08 · K03-M17 · Acht Stunden absolut -- BEIDE Grenzen prueft der
#         Server. Die Sitzung ist hier durchgehend benutzt worden:
#         last_activity_at ist jetzt. Nur die absolute Grenze ist um.
# =====================================================================
st=$(post_anmeldung 'achtstunden@pruef.example' '100004' an08)
keks="$(sitzungswert an08)"
if [ "$st" != "303" ] || [ -z "$keks" ]; then
  sperr AN-08 "Achtstundengrenze nicht messbar: die Anmeldung selbst scheiterte (Status $st, Cookie '${keks:-leer}')"
else
  st2=$(hole / an08b "$keks")
  if [ "$st2" != "200" ]; then
    sperr AN-08 "Achtstundengrenze nicht messbar: GET / mit frischer Sitzung liefert $st2 statt 200"
  else
    n="$(dbz "UPDATE auth_session SET started_at = now() - interval '8 hours 5 minutes',
                                       last_activity_at = now()
                WHERE actor_id=(SELECT id FROM actor WHERE email='achtstunden@pruef.example')
                  AND ended_at IS NULL
              RETURNING 1" | wc -l | tr -d ' ')"
    if [ "$n" = "0" ]; then
      sperr AN-08 'keine Zeile in auth_session -- die absolute Grenze ist so nicht pruefbar (K03-M13, fail-closed K03-G01)'
    else
      st3=$(hole / an08c "$keks")
      ziel="$(kopfzeile an08c location)"
      m=""
      [ "$st3" = "303" ] || m="$m GET / liefert $st3 statt 303 nach 8 Stunden 5 Minuten;"
      case "$ziel" in *"/anmeldung"*) : ;; *) m="$m Location '$ziel' zeigt nicht auf /anmeldung;";; esac
      [ -z "$m" ] && ok AN-08 'Sitzung endet spaetestens nach acht Stunden, auch bei laufender Nutzung (K03-M17)' \
                  || nok AN-08 "Achtstundengrenze:$m"
    fi
  fi
fi

# =====================================================================
# AN-09 · Vertrag · Abmelden beendet die Sitzung
# =====================================================================
st=$(post_anmeldung 'abmeldung@pruef.example' '100005' an09)
keks="$(sitzungswert an09)"
if [ "$st" != "303" ] || [ -z "$keks" ]; then
  sperr AN-09 "Abmeldung nicht messbar: die Anmeldung selbst scheiterte (Status $st, Cookie '${keks:-leer}')"
else
  st2=$(sende /abmelden an09b "$keks")
  ziel="$(kopfzeile an09b location)"
  st3=$(hole / an09c "$keks")
  m=""
  [ "$st2" = "303" ] || m="$m POST /abmelden liefert $st2 statt 303;"
  case "$ziel" in *"/anmeldung"*) : ;; *) m="$m Location '$ziel' zeigt nicht auf /anmeldung;";; esac
  [ "$st3" = "303" ] || m="$m GET / mit dem alten Cookie liefert $st3 statt 303 -- die Sitzung lebt weiter;"
  [ -z "$m" ] && ok AN-09 'POST /abmelden fuehrt auf /anmeldung und beendet die Sitzung' \
              || nok AN-09 "Abmeldung:$m"
fi

# =====================================================================
# AN-10 · K03-D01 · Eine gueltige Sitzung allein genuegt nicht.
#         Wird das Konto waehrend der Sitzung gesperrt, endet der Zugang
#         -- nie ein Teil-Zugang.
# =====================================================================
st=$(post_anmeldung 'sperrmitten@pruef.example' '100006' an10)
keks="$(sitzungswert an10)"
if [ "$st" != "303" ] || [ -z "$keks" ]; then
  sperr AN-10 "Sperre in laufender Sitzung nicht messbar: die Anmeldung selbst scheiterte (Status $st)"
else
  st2=$(hole / an10b "$keks")
  if [ "$st2" != "200" ]; then
    sperr AN-10 "Sperre in laufender Sitzung nicht messbar: GET / mit frischer Sitzung liefert $st2 statt 200"
  else
    db "UPDATE actor SET status='GESPERRT', status_before_lock='AKTIV' WHERE email='sperrmitten@pruef.example';" >/dev/null
    st3=$(hole / an10c "$keks")
    db "UPDATE actor SET status='AKTIV', status_before_lock=NULL WHERE email='sperrmitten@pruef.example';" >/dev/null
    m=""
    case "$st3" in
      200) m="$m GET / liefert weiter 200, obwohl das Konto GESPERRT ist;";;
      3*|4*) : ;;
      *) m="$m unerwarteter Status $st3;";;
    esac
    [ -z "$m" ] && ok AN-10 'GESPERRT waehrend der Sitzung: kein Vorgang mehr, kein Teil-Zugang (K03-D01)' \
                || nok AN-10 "Sperre in laufender Sitzung:$m"
  fi
fi

# =====================================================================
# AN-11 · K03-M06 + K03-M15 · Der Code wird bei JEDER Anmeldung
#         abgefragt und gilt genau einmal.
# =====================================================================
versuche_leeren
st=$(post_anmeldung 'zweitanmeldung@pruef.example' '100017' an11)
keks="$(sitzungswert an11)"
if [ "$st" != "303" ] || [ -z "$keks" ]; then
  sperr AN-11 "Zweitanmeldung nicht messbar: die erste Anmeldung scheiterte (Status $st)"
else
  sende /abmelden an11b "$keks" >/dev/null
  st2=$(post_anmeldung 'zweitanmeldung@pruef.example' '100017' an11c)
  keks2="$(sitzungswert an11c)"
  m=""
  [ "$st2" = "200" ] || m="$m zweite Anmeldung liefert $st2 statt 200;"
  [ -z "$keks2" ]    || m="$m zweite Anmeldung setzt trotzdem ein Cookie;"
  hat_meldung an11c  || m="$m die Meldung fehlt oder weicht ab;"
  [ -z "$m" ] && ok AN-11 'Der verbrauchte Code oeffnet keine zweite Sitzung -- der Code wird jedes Mal abgefragt (K03-M06, K03-M15)' \
              || nok AN-11 "Zweitanmeldung mit verbrauchtem Code:$m"
fi

# =====================================================================
# AN-12 · K03-M06 · Ohne Code keine Anmeldung, auch mit richtiger Adresse
# =====================================================================
versuche_leeren
st=$(post_anmeldung 'leercode@pruef.example' '' an12)
keks="$(sitzungswert an12)"
m=""
[ "$st" = "200" ] || m="$m Status $st statt 200;"
[ -z "$keks" ]    || m="$m es wurde ein Cookie gesetzt;"
hat_meldung an12  || m="$m die Meldung fehlt oder weicht ab;"
[ -z "$m" ] && ok AN-12 'Aktives Konto, leerer Code: abgewiesen mit der einen Meldung, ohne Cookie (K03-M06)' \
            || nok AN-12 "Leerer Code:$m"

# =====================================================================
# AN-13 · K03-M11 + K03 Abschn. 6 · Ohne Mitgliedschaft in einem
#         freigeschalteten Portal oeffnet sich keines.
# =====================================================================
versuche_leeren
st=$(post_anmeldung 'ohneportal@pruef.example' '100008' an13)
keks="$(sitzungswert an13)"
m=""
[ "$st" = "200" ] || m="$m Status $st statt 200;"
[ -z "$keks" ]    || m="$m es wurde ein Cookie gesetzt, obwohl keine Mitgliedschaft besteht;"
hat_meldung an13  || m="$m die Meldung fehlt oder weicht ab;"
[ -z "$m" ] && ok AN-13 'Aktives Konto ohne Mitgliedschaft: abgewiesen, kein Portal (K03-M11)' \
            || nok AN-13 "Konto ohne Mitgliedschaft:$m"

# =====================================================================
# AN-14 · K03-D02 · Ein Anmeldevorgang oeffnet nicht zwei Portale.
#         Das Konto ist in ENDUSER UND EXMA Mitglied. Zulaessig ist
#         beides: Ablehnung oder genau ein Portal -- niemals zwei.
# =====================================================================
versuche_leeren
db "DELETE FROM auth_session WHERE actor_id=(SELECT id FROM actor WHERE email='zweiportale@pruef.example');" >/dev/null
st=$(post_anmeldung 'zweiportale@pruef.example' '100007' an14)
zahl="$(sitzungszahl an14)"
keks="$(sitzungswert an14)"
sitzungen="$(dbz "SELECT count(*) FROM auth_session s JOIN actor a ON a.id=s.actor_id
                   WHERE a.email='zweiportale@pruef.example' AND s.ended_at IS NULL")"
m=""
[ "$zahl" -le 1 ] || m="$m die Antwort setzt $zahl Cookies fr_sitzung;"
[ "${sitzungen:-0}" -le 1 ] || m="$m es entstanden $sitzungen offene Sitzungen aus einer Anmeldung;"
if [ "$st" = "303" ]; then
  [ -n "$keks" ] || m="$m 303 ohne Cookie fr_sitzung;"
  ziel14="$(kopfzeile an14 location)"
  case "$ziel14" in "/"|"$BASIS"|"$BASIS/") : ;; *) m="$m Location '$ziel14' statt /;";; esac
elif [ "$st" = "200" ]; then
  hat_meldung an14 || m="$m Ablehnung ohne die eine Meldung;"
  [ -z "$keks" ]   || m="$m Ablehnung mit Cookie;"
else
  m="$m unerwarteter Status $st;"
fi
[ -z "$m" ] && ok AN-14 'Mitglied in zwei freigeschalteten Portalen: die Anmeldung oeffnet hoechstens eines (K03-D02)' \
            || nok AN-14 "Zwei Portale:$m"

# =====================================================================
# AN-15 · Negativ · Falscher Code
#         Alles andere ist erfuellt: AKTIV, Mitgliedschaft, offener Code
#         innerhalb der Frist. Verletzt ist nur die Codepruefung.
# =====================================================================
versuche_leeren
st=$(post_anmeldung 'falschercode@pruef.example' '999999' an15)
cp "$ARBEIT/an15.rumpf" "$ARBEIT/gleich_falsch.rumpf" 2>/dev/null
keks="$(sitzungswert an15)"
m=""
[ "$st" = "200" ] || m="$m Status $st statt 200;"
[ -z "$keks" ]    || m="$m es wurde ein Cookie gesetzt;"
hat_meldung an15  || m="$m die Meldung fehlt oder weicht ab;"
st2=$(hole / an15b "")
[ "$st2" = "303" ] || m="$m GET / nach dem Fehlversuch liefert $st2 statt 303;"
[ -z "$m" ] && ok AN-15 'Falscher Code: 200 mit der einen Meldung, kein Cookie (K03-G01)' \
            || nok AN-15 "Falscher Code:$m"

# =====================================================================
# AN-16 · Negativ · Unbekanntes Konto
#         Adresse formal einwandfrei, Code formal einwandfrei --
#         es fehlt allein das Konto.
# =====================================================================
versuche_leeren
st=$(post_anmeldung 'unbekannt@pruef.example' '100099' an16)
cp "$ARBEIT/an16.rumpf" "$ARBEIT/gleich_unbekannt.rumpf" 2>/dev/null
keks="$(sitzungswert an16)"
m=""
[ "$st" = "200" ] || m="$m Status $st statt 200;"
[ -z "$keks" ]    || m="$m es wurde ein Cookie gesetzt;"
hat_meldung an16  || m="$m die Meldung fehlt oder weicht ab;"
[ -z "$m" ] && ok AN-16 'Unbekanntes Konto: dieselbe Antwort wie bei falschem Code (K03-M16)' \
            || nok AN-16 "Unbekanntes Konto:$m"

# =====================================================================
# AN-17 · Negativ · Gesperrtes Konto MIT richtigem Code
#         Der Code stimmt, die Frist laeuft, die Mitgliedschaft steht.
#         Verletzt ist nur der Kontozustand (K03-D01).
# =====================================================================
versuche_leeren
st=$(post_anmeldung 'gesperrt@pruef.example' '100010' an17)
cp "$ARBEIT/an17.rumpf" "$ARBEIT/gleich_gesperrt.rumpf" 2>/dev/null
keks="$(sitzungswert an17)"
m=""
[ "$st" = "200" ] || m="$m Status $st statt 200;"
[ -z "$keks" ]    || m="$m es wurde ein Cookie gesetzt;"
hat_meldung an17  || m="$m die Meldung fehlt oder weicht ab;"
zust="$(dbz "SELECT status FROM actor WHERE email='gesperrt@pruef.example'")"
[ "$zust" = "GESPERRT" ] || m="$m der Kontozustand wurde auf $zust veraendert;"
[ -z "$m" ] && ok AN-17 'GESPERRT mit richtigem Code: abgewiesen, kein Teil-Zugang, Zustand unveraendert (K03-D01)' \
            || nok AN-17 "Gesperrtes Konto:$m"

# =====================================================================
# AN-18 · Negativ · Abgelaufener Code (K03-M15, zehn Minuten)
# =====================================================================
versuche_leeren
st=$(post_anmeldung 'abgelaufen@pruef.example' '100011' an18)
cp "$ARBEIT/an18.rumpf" "$ARBEIT/gleich_abgelaufen.rumpf" 2>/dev/null
keks="$(sitzungswert an18)"
m=""
[ "$st" = "200" ] || m="$m Status $st statt 200;"
[ -z "$keks" ]    || m="$m es wurde ein Cookie gesetzt;"
hat_meldung an18  || m="$m die Meldung fehlt oder weicht ab;"
[ -z "$m" ] && ok AN-18 'Code aelter als zehn Minuten: abgewiesen mit derselben Meldung (K03-M15)' \
            || nok AN-18 "Abgelaufener Code:$m"

# =====================================================================
# AN-19 · Negativ · Verbrauchter Code (K03-M15, genau einmal gueltig)
#         Die Frist laeuft noch -- verletzt ist allein die Einmaligkeit.
# =====================================================================
versuche_leeren
st=$(post_anmeldung 'verbraucht@pruef.example' '100012' an19)
cp "$ARBEIT/an19.rumpf" "$ARBEIT/gleich_verbraucht.rumpf" 2>/dev/null
keks="$(sitzungswert an19)"
m=""
[ "$st" = "200" ] || m="$m Status $st statt 200;"
[ -z "$keks" ]    || m="$m es wurde ein Cookie gesetzt;"
hat_meldung an19  || m="$m die Meldung fehlt oder weicht ab;"
[ -z "$m" ] && ok AN-19 'Bereits eingeloester Code: abgewiesen, obwohl die Frist noch laeuft (K03-M15)' \
            || nok AN-19 "Verbrauchter Code:$m"

# =====================================================================
# AN-20 · Negativ + Gegenprobe · Ein neuer Code entwertet aeltere
#         (K03-M15). Erst der alte -- muss scheitern. Dann der neue --
#         muss tragen. Ohne die Gegenprobe wuerde ein Server bestehen,
#         der schlicht jeden Code ablehnt.
# =====================================================================
versuche_leeren
st=$(post_anmeldung 'entwertet@pruef.example' '100013' an20)
cp "$ARBEIT/an20.rumpf" "$ARBEIT/gleich_entwertet.rumpf" 2>/dev/null
keks="$(sitzungswert an20)"
m=""
[ "$st" = "200" ] || m="$m alter Code: Status $st statt 200;"
[ -z "$keks" ]    || m="$m alter Code: es wurde ein Cookie gesetzt;"
hat_meldung an20  || m="$m alter Code: die Meldung fehlt oder weicht ab;"
versuche_leeren
st2=$(post_anmeldung 'entwertet@pruef.example' '100113' an20b)
keks2="$(sitzungswert an20b)"
[ "$st2" = "303" ] || m="$m Gegenprobe: der neue Code liefert $st2 statt 303;"
[ -n "$keks2" ]    || m="$m Gegenprobe: der neue Code setzt kein Cookie;"
[ -z "$m" ] && ok AN-20 'Der entwertete aeltere Code wird abgewiesen, der neuere traegt (K03-M15)' \
            || nok AN-20 "Entwerteter Code:$m"

# =====================================================================
# AN-21 · K03-M16 · Nach fuenf falschen Codes ist der Code ungueltig,
#         weitere Versuche werden gedrosselt. Der sechste Versuch traegt
#         den RICHTIGEN Code -- und muss trotzdem scheitern.
# =====================================================================
versuche_leeren 'drossel@pruef.example'
i=1
fehl=""
while [ $i -le 5 ]; do
  s=$(post_anmeldung 'drossel@pruef.example' '99999'"$i" "an21_$i")
  [ "$s" = "200" ] || fehl="$fehl Fehlversuch $i liefert $s statt 200;"
  hat_meldung "an21_$i" || fehl="$fehl Fehlversuch $i ohne die eine Meldung;"
  i=$((i+1))
done
st=$(post_anmeldung 'drossel@pruef.example' '100014' an21z)
keks="$(sitzungswert an21z)"
m="$fehl"
[ "$st" = "200" ] || m="$m sechster Versuch mit RICHTIGEM Code liefert $st statt 200;"
[ -z "$keks" ]    || m="$m der richtige Code oeffnet trotz fuenf Fehlversuchen eine Sitzung;"
hat_meldung an21z || m="$m die Meldung fehlt oder weicht ab;"
spur="$(dbz "SELECT coalesce(max(failed_count),-1) FROM login_code c JOIN actor a ON a.id=c.actor_id
              WHERE a.email='drossel@pruef.example'")"
[ -z "$m" ] && ok AN-21 "Fuenf falsche Codes machen den Code ungueltig, der richtige traegt danach nicht mehr (K03-M16; failed_count=$spur)" \
            || nok AN-21 "Drosselung:$m"

# =====================================================================
# AN-22 · K03-M16 · UNUNTERSCHEIDBARKEIT.
#         "ohne die Existenz eines Kontos preiszugeben." Eine abweichende
#         Meldung je Fall ist eine Kontoauskunft. Verglichen werden:
#         falscher Code, unbekanntes Konto, gesperrtes Konto,
#         abgelaufener, verbrauchter und entwerteter Code.
# =====================================================================
faelle="falsch unbekannt gesperrt abgelaufen verbraucht entwertet"
m=""
vollzaehlig=1
for f in $faelle; do
  [ -s "$ARBEIT/gleich_$f.rumpf" ] || { m="$m Antwort '$f' liegt nicht vor;"; vollzaehlig=0; }
done
if [ "$vollzaehlig" = "1" ]; then
  # (1) Der Wortlaut, Zeichen fuer Zeichen
  for f in $faelle; do
    grep -qF "$MELDUNG" "$ARBEIT/gleich_$f.rumpf" || m="$m '$f' traegt nicht den Wortlaut;"
  done
  # (2) Erst normieren: die eingegebene Adresse darf zurueckkommen (die
  #     Maske EN-01 belegt das Feld vor), sie ist keine Auskunft ueber ein
  #     Konto. Ohne diesen Abzug meldete die Wortprobe die Adresse selbst
  #     -- ein Fall, der an der falschen Bedingung scheitert (F07).
  for f in $faelle; do normiere "$ARBEIT/gleich_$f.rumpf" > "$ARBEIT/norm_$f"; done
  # (3) Rueckstaende, die nur in EINEM Teil der Antworten stehen, sind
  #     Kontoauskunft. Woerter, die in ALLEN stehen, sind es nicht.
  for w in gesperrt Gesperrt GESPERRT unbekannt Unbekannt existiert abgelaufen Abgelaufen \
           verbraucht entwertet gedrosselt Drosselung WARTET_2FA Fehlversuch; do
    ja=0; nein=0
    for f in $faelle; do
      if grep -qF "$w" "$ARBEIT/norm_$f"; then ja=$((ja+1)); else nein=$((nein+1)); fi
    done
    [ "$ja" -gt 0 ] && [ "$nein" -gt 0 ] && m="$m '$w' steht in $ja von 6 Antworten -- das unterscheidet die Faelle;"
  done
  # (4) Die Antworten selbst, nach Abzug von Adresse, Ziffernfolge und Marke
  for f in $faelle; do
    cmp -s "$ARBEIT/norm_falsch" "$ARBEIT/norm_$f" || \
      [ "$f" = "falsch" ] || m="$m die Antwort '$f' weicht von 'falsch' ab;"
  done
fi
if [ "$vollzaehlig" != "1" ]; then
  sperr AN-22 "Ununterscheidbarkeit nicht messbar:$m"
elif [ -z "$m" ]; then
  ok AN-22 'Falscher Code, unbekanntes Konto, gesperrtes Konto, abgelaufener, verbrauchter und entwerteter Code liefern dieselbe Antwort (K03-M16)'
else
  nok AN-22 "Ununterscheidbarkeit:$m"
fi

# =====================================================================
# AN-23 · K03-M16 · Dieselbe Laufzeit, so gut es geht.
#         Ein Konto, das schneller abgewiesen wird als eines, das es
#         nicht gibt, ist eine Kontoauskunft ueber die Uhr.
# =====================================================================
messe() { # $1 email  $2 code
  curl -sS -o /dev/null -w '%{time_total}\n' --max-time 25 \
       --data-urlencode "email=$1" --data-urlencode "code=$2" \
       "$BASIS/anmeldung" 2>/dev/null || echo 99
}
i=1
: > "$ARBEIT/zeit_falsch"; : > "$ARBEIT/zeit_unbekannt"
while [ $i -le 5 ]; do
  versuche_leeren
  messe 'falschercode@pruef.example' '999999'   >> "$ARBEIT/zeit_falsch"
  versuche_leeren
  messe 'unbekannt@pruef.example'    '100099'   >> "$ARBEIT/zeit_unbekannt"
  i=$((i+1))
done
mf=$(sort -n "$ARBEIT/zeit_falsch"    | sed -n '3p')
mu=$(sort -n "$ARBEIT/zeit_unbekannt" | sed -n '3p')
abstand=$(python3 -c "print('%.3f' % abs(float('${mf:-0}')-float('${mu:-0}')))" 2>/dev/null)
gross=$(python3 -c "print(1 if abs(float('${mf:-0}')-float('${mu:-0}'))>0.250 else 0)" 2>/dev/null)
if [ "$gross" = "0" ]; then
  ok AN-23 "Unbekanntes Konto und falscher Code brauchen gleich lange (Median ${mu}s / ${mf}s, Abstand ${abstand}s)"
else
  nok AN-23 "Laufzeit verraet die Existenz des Kontos: Median unbekannt ${mu}s, falscher Code ${mf}s, Abstand ${abstand}s > 0.250s"
fi

# =====================================================================
# AN-24 · K03-G05 + K03-M09 · Ein Fehlversuch an einem Konto in
#         WARTET_2FA aendert weder den Zustand noch last_login_at.
# =====================================================================
versuche_leeren
st=$(post_anmeldung 'wartetfalsch@pruef.example' '999999' an24)
keks="$(sitzungswert an24)"
zust="$(dbz "SELECT status FROM actor WHERE email='wartetfalsch@pruef.example'")"
anmeldung="$(dbz "SELECT coalesce(last_login_at::text,'') FROM actor WHERE email='wartetfalsch@pruef.example'")"
m=""
[ "$st" = "200" ] || m="$m Status $st statt 200;"
[ -z "$keks" ]    || m="$m es wurde ein Cookie gesetzt;"
hat_meldung an24  || m="$m die Meldung fehlt oder weicht ab;"
[ "$zust" = "WARTET_2FA" ] || m="$m status ist $zust statt WARTET_2FA;"
[ -z "$anmeldung" ]        || m="$m last_login_at ist gesetzt ($anmeldung), obwohl das Konto WARTET_2FA traegt;"
[ -z "$m" ] && ok AN-24 'WARTET_2FA und falscher Code: abgewiesen, Zustand bleibt, last_login_at bleibt leer (K03-G05, K03-M09)' \
            || nok AN-24 "WARTET_2FA mit falschem Code:$m"

# =====================================================================
# AN-25 · K03-M09 · Der Uebergang WARTET_2FA -> AKTIV entsteht
#         AUSSCHLIESSLICH aus bestaetigter zweiter Stufe, und im SELBEN
#         Vorgang wird last_login_at gesetzt.
#
#         K03 traegt hier zwei Lesarten (4.1 gegen K03-D01). Geprueft
#         wird deshalb die KOPPLUNG, die in beiden gilt:
#           Ablehnung -> WARTET_2FA und last_login_at leer
#           Erfolg    -> AKTIV UND last_login_at gesetzt
#         Unzulaessig ist jede Halbheit dazwischen.
# =====================================================================
versuche_leeren
st=$(post_anmeldung 'wartetrichtig@pruef.example' '100016' an25)
keks="$(sitzungswert an25)"
zust="$(dbz "SELECT status FROM actor WHERE email='wartetrichtig@pruef.example'")"
anmeldung="$(dbz "SELECT coalesce(last_login_at::text,'') FROM actor WHERE email='wartetrichtig@pruef.example'")"
m=""
if [ "$st" = "303" ] && [ -n "$keks" ]; then
  [ "$zust" = "AKTIV" ] || m="$m Anmeldung erfolgreich, aber status ist $zust statt AKTIV;"
  [ -n "$anmeldung" ]   || m="$m Anmeldung erfolgreich, aber last_login_at blieb leer (K03-M09: im selben Vorgang);"
  ausgang='Erfolg: WARTET_2FA -> AKTIV mit gesetztem last_login_at'
elif [ "$st" = "200" ] && [ -z "$keks" ]; then
  hat_meldung an25 || m="$m Ablehnung ohne die eine Meldung;"
  [ "$zust" = "WARTET_2FA" ] || m="$m abgelehnt, aber status wurde auf $zust gesetzt;"
  [ -z "$anmeldung" ]        || m="$m abgelehnt, aber last_login_at wurde gesetzt ($anmeldung);"
  ausgang='Ablehnung: Zustand und last_login_at unveraendert'
else
  m="$m unklarer Ausgang: Status $st, Cookie '${keks:-leer}';"
  ausgang='unklar'
fi
[ -z "$m" ] && ok AN-25 "WARTET_2FA mit richtigem Code -- Zustand und last_login_at bleiben gekoppelt (K03-M09). $ausgang" \
            || nok AN-25 "WARTET_2FA mit richtigem Code:$m"

# =====================================================================
# AN-26 · K03-M13 · Jede Pruefung erfolgt serverseitig. Ein selbst
#         gebauter oder verfaelschter Keks traegt nicht.
# =====================================================================
versuche_leeren
st=$(post_anmeldung 'positiv@pruef.example' '100002' an26vor)
echt="$(sitzungswert an26vor)"
if [ -z "$echt" ]; then
  # Der Code ist verbraucht (AN-04). Ein neuer wird gestellt -- der
  # Pruefwert entsteht in der Datenbank, nicht im Serverpfad.
  db "INSERT INTO login_code(actor_id, code_hash)
      SELECT id, pruef_codewert('100202', '${FREIRAUM_CODE_PFEFFER:-}')
        FROM actor WHERE email='positiv@pruef.example';" >/dev/null 2>&1
  st=$(post_anmeldung 'positiv@pruef.example' '100202' an26vor2)
  echt="$(sitzungswert an26vor2)"
fi
if [ -z "$echt" ]; then
  sperr AN-26 'serverseitige Pruefung nicht messbar: es liess sich kein echtes Sitzungscookie beschaffen'
elif [ "${#echt}" -lt 2 ]; then
  sperr AN-26 "serverseitige Pruefung nicht messbar: das echte Sitzungscookie ist mit ${#echt} Zeichen zu kurz, um daraus eine Faelschung auf Byteebene zu bilden"
else
  # Die Faelschung muss auf BYTEEBENE wirken, nicht auf Zeichenebene.
  # Das Sitzungsmerkmal ist nutzlast.signatur; die Signatur sind 20 Byte
  # HMAC in ungepolstertem Base64 (itsdangerous URLSafeSerializer). Bei
  # ungepolstertem Base64 traegt AUSSCHLIESSLICH das LETZTE Zeichen
  # Fuellbits, die beim Decodieren verworfen werden -- bei 20 Byte sind es
  # 4 bedeutungstragende und 2 verworfene Bits. Ein Vorgehen, das nur
  # dieses letzte Zeichen ersetzt, erzeugt deshalb manchmal ein BYTEGLEICHES
  # Cookie: verschiedene Zeichen decodieren auf dieselben Bytes, der Server
  # nimmt die "Faelschung" zu Recht an. Gemessen ueber 20000 damit erzeugte
  # Merkmale: 1220 Annahmen (6,10 %), immer beim Endzeichen 'U'.
  #
  # Die VORLETZTE Stelle ist davon nicht betroffen: Fuellbits treten bei
  # ungepolstertem Base64 -- unabhaengig von der Signaturlaenge -- immer
  # ausschliesslich im letzten Zeichen auf, nie im vorletzten. Das
  # vorletzte Zeichen gehoert immer zu einer vollen 6-Bit-Gruppe aus
  # echten Signaturbytes; jede Aenderung dort aendert die decodierten
  # Bytes zwingend. Nachgerechnet mit itsdangerous (Salz fr_sitzung_v1)
  # ueber 220000 so erzeugte Faelschungen: 0 Annahmen.
  vorletzte_pos=$((${#echt} - 2))
  vorletztes_zeichen="${echt:vorletzte_pos:1}"
  if [ "$vorletztes_zeichen" = "A" ]; then ersatz="B"; else ersatz="A"; fi
  gefaelscht="${echt:0:vorletzte_pos}${ersatz}${echt:vorletzte_pos+1}"
  kennung="$(dbz "SELECT id FROM actor WHERE email='positiv@pruef.example'")"
  m=""
  s1=$(hole / an26a "$gefaelscht");        [ "$s1" = "200" ] && m="$m verfaelschtes Cookie liefert 200;"
  s2=$(hole / an26b "$kennung");           [ "$s2" = "200" ] && m="$m actor.id als Cookie liefert 200;"
  s3=$(hole / an26c 'positiv@pruef.example'); [ "$s3" = "200" ] && m="$m die Adresse als Cookie liefert 200;"
  s4=$(hole / an26d 'aktiv');              [ "$s4" = "200" ] && m="$m der Wert 'aktiv' als Cookie liefert 200;"
  s5=$(hole / an26e "$echt");              [ "$s5" = "200" ] || m="$m Gegenprobe: das echte Cookie liefert $s5 statt 200;"
  [ -z "$m" ] && ok AN-26 'Verfaelschte und selbst gebaute Cookies tragen nicht, das echte schon (K03-M13)' \
              || nok AN-26 "Serverseitige Pruefung:$m"
fi

# =====================================================================
# AN-27/28/29 · K03-G01 + BEF-L2-1 · Fehlt eine Pflichtvariable, bricht
#         der Start ab -- benannt, nicht still, ohne Vorgabewert.
#         AN-30 ist ihre Gegenprobe: mit allen dreien startet er. Ohne
#         sie bestuende ein Server, der ueberhaupt nicht startet, alle
#         drei Faelle.
# =====================================================================
DSN_PRUEF="postgresql://$PGUSER:$PGPASSWORD@$PGHOST:$PGPORT/$PGDATABASE"
START_ERGEBNIS=""; START_PID=""; START_PORT=""; START_LOG=""

# Laeuft OHNE Befehlsersetzung, damit die gesetzten Werte im laufenden
# Skript ankommen und der Prozess danach sicher beendet werden kann.
start_probe() {   # $1 = fehlende Variable, oder "-" fuer den vollstaendigen Start
  fehlt="$1"; i=0
  START_PORT="$(freier_port)"
  START_LOG="$ARBEIT/start_$fehlt.log"
  if [ "$fehlt" = "-" ]; then
    ( cd "$REPO" || exit 97
      env FREIRAUM_DSN="$DSN_PRUEF" \
          FREIRAUM_CODE_PFEFFER="$FREIRAUM_CODE_PFEFFER" \
          FREIRAUM_SITZUNG_SCHLUESSEL="${FREIRAUM_SITZUNG_SCHLUESSEL:-pruefschluessel}" \
          .venv/bin/uvicorn app.haupt:app --port "$START_PORT"
    ) >"$START_LOG" 2>&1 &
  else
    ( cd "$REPO" || exit 97
      env FREIRAUM_DSN="$DSN_PRUEF" \
          FREIRAUM_CODE_PFEFFER="$FREIRAUM_CODE_PFEFFER" \
          FREIRAUM_SITZUNG_SCHLUESSEL="${FREIRAUM_SITZUNG_SCHLUESSEL:-pruefschluessel}" \
          env -u "$fehlt" .venv/bin/uvicorn app.haupt:app --port "$START_PORT"
    ) >"$START_LOG" 2>&1 &
  fi
  START_PID=$!
  while kill -0 "$START_PID" 2>/dev/null && [ $i -lt 15 ]; do sleep 1; i=$((i+1)); done
  if kill -0 "$START_PID" 2>/dev/null; then
    START_ERGEBNIS="LAEUFT"
  else
    wait "$START_PID"; START_ERGEBNIS="ENDE:$?"; START_PID=""
  fi
}
start_ende() { [ -n "$START_PID" ] && { kill "$START_PID" 2>/dev/null; wait "$START_PID" 2>/dev/null; }; START_PID=""; }

pruefe_start() { # $1 Kennung  $2 Variablenname
  if [ ! -x "$REPO/.venv/bin/uvicorn" ]; then
    sperr "$1" "Startabbruch nicht pruefbar: $REPO/.venv/bin/uvicorn fehlt (fail-closed nach K03-G01)"
    return
  fi
  m=""
  start_probe "$2"
  start_ende
  if [ "$START_ERGEBNIS" = "LAEUFT" ]; then
    m="$m der Server laeuft ohne $2 weiter -- stiller Vorgabewert (BEF-L2-1);"
  elif [ "$START_ERGEBNIS" = "ENDE:0" ]; then
    m="$m der Start endete mit 0, also ohne Fehler;"
  fi
  grep -q "$2" "$ARBEIT/start_$2.log" 2>/dev/null || m="$m die Meldung nennt $2 nicht;"
  [ -z "$m" ] && ok "$1" "Start ohne $2 bricht ab und nennt die Variable (K03-G01, BEF-L2-1)" \
              || nok "$1" "Start ohne $2:$m"
}
pruefe_start AN-27 FREIRAUM_DSN
pruefe_start AN-28 FREIRAUM_CODE_PFEFFER
pruefe_start AN-29 FREIRAUM_SITZUNG_SCHLUESSEL

# =====================================================================
# AN-30 · GEGENPROBE zu AN-27/28/29: mit allen drei Variablen startet
#         der Server und antwortet. Ohne diesen Fall bestuende ein
#         Programm, das nie startet, die drei Abbruchfaelle muehelos.
# =====================================================================
if [ ! -x "$REPO/.venv/bin/uvicorn" ]; then
  sperr AN-30 "Gegenprobe nicht moeglich: $REPO/.venv/bin/uvicorn fehlt"
else
  start_probe '-'
  m=""
  if [ "$START_ERGEBNIS" != "LAEUFT" ]; then
    m="$m der Start endete mit $START_ERGEBNIS, obwohl alle drei Variablen gesetzt waren;"
  else
    sg=$(curl -sS -o /dev/null -w '%{http_code}' --max-time 10 "http://127.0.0.1:$START_PORT/gesundheit" 2>/dev/null) || sg="000"
    [ "$sg" = "200" ] || m="$m der gestartete Server antwortet auf /gesundheit mit $sg statt 200;"
  fi
  start_ende
  [ -z "$m" ] && ok AN-30 'Mit FREIRAUM_DSN, FREIRAUM_CODE_PFEFFER und FREIRAUM_SITZUNG_SCHLUESSEL startet der Server und antwortet' \
              || nok AN-30 "Gegenprobe zum Startabbruch:$m"
fi

# =====================================================================
printf '\n'
[ "$gesperrt" -gt 0 ] && printf 'davon GESPERRT (nicht messbar, zaehlt nach K23-M22 nicht als bestanden): %s\n' "$gesperrt"
printf 'SUMME: %s von %s bestanden, %s gescheitert\n' "$bestanden" "$gesamt" "$gescheitert"
[ "$gescheitert" -eq 0 ]
