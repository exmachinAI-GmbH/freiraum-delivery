#!/usr/bin/env bash
# =====================================================================
#  FREIRAUM Coding-Harness · Tor 1c — der Prueflauf
#
#      ./pruefungen/lauf.sh [--bericht <datei.json>]
#
#  WAS DIESER LAUF HEUTE MISST: die Prueffaelle der Sammelmigration M30
#  (MT-01 ff.) und die vier Negativfaelle. Er misst den ZIELBESTAND --
#  nicht die Anwendung. Die gibt es noch nicht.
#
#  WAS ER NOCH NICHT MISST: die Klausel-Prueffaelle. Sie schreibt der
#  Pruef-Agent je Scheibe, BLIND -- ohne den Umsetzungscode gesehen zu
#  haben (CLAUDE.md Abschn. 3). Sie kommen nach pruefungen/klauseln/ und
#  werden von hier aus mitgefahren, sobald es sie gibt. Solange der Ordner
#  leer ist, WEIST DIESER LAUF DAS AUS -- er meldet nicht gruen fuer etwas,
#  das er nicht gemessen hat (K23-M22: was nicht gemessen werden konnte,
#  ist GESPERRT, nicht bestanden).
#
#  MASSSTAB DER NEGATIVFAELLE (F07, Bauauftrag §9 Tor I Nr. 6): Ein
#  Negativfall gilt erst als bestanden, wenn er an SEINER EIGENEN Bedingung
#  scheitert. Die Meldung im Wortlaut ist Teil der Evidenz.
# =====================================================================
set -euo pipefail
cd "$(dirname "$0")/.."

BERICHT=""
[ "${1:-}" = "--bericht" ] && BERICHT="${2:?--bericht braucht einen Dateinamen}"

: "${PGHOST:=localhost}" "${PGPORT:=5432}" "${PGUSER:=postgres}" "${PGDATABASE:=freiraum_ci}"
export PGHOST PGPORT PGUSER PGDATABASE

ok=0; fehl=0; gesperrt=0
zeilen=""

merke() {  # kennung · zustand · anmerkung
  zeilen="${zeilen}${zeilen:+,}{\"kennung\":\"$1\",\"zustand\":\"$2\",\"anmerkung\":\"$3\"}"
  case "$2" in
    bestanden)      ok=$((ok+1)) ;;
    fehlgeschlagen) fehl=$((fehl+1)) ;;
    gesperrt)       gesperrt=$((gesperrt+1)) ;;
  esac
}

# ---------------------------------------------------------------------
# 0 · Ist das Werkzeug ueberhaupt da?
#
#     BEF-D3, gemessen am 10.08.2026: Ohne psql gab dieser Lauf die
#     Ueberschrift "== Migrationsprueffaelle ==" aus und starb dann
#     WORTLOS -- er kam nicht einmal bis zu seiner eigenen ::error::-Zeile.
#     Die Ursache steht in Abschnitt 1; sie traf JEDE psql-Stoerung, nicht
#     nur das fehlende Werkzeug (unerreichbare Datenbank ebenso, gemessen).
#
#     K23-M22: was nicht gemessen werden konnte, ist GESPERRT, nicht bestanden.
# ---------------------------------------------------------------------
PSQL_DA=ja
PSQL_GRUND="ohne psql nicht messbar"   # wird genauer, sobald der Grund bekannt ist
if ! command -v psql >/dev/null 2>&1; then
  PSQL_DA=nein
  echo "::error::psql ist nicht im PATH — dieser Lauf misst NICHTS."
  echo "   Abhilfe: brew install libpq && brew link --force libpq"
  merke "Werkzeug-psql" gesperrt "psql nicht im PATH"
fi

# ---------------------------------------------------------------------
# 1 · Die Prueffaelle der Sammelmigration
# ---------------------------------------------------------------------
echo "== Migrationsprueffaelle =="
P=pruefungen/migration/M30__pruefung.sql
if [ "$PSQL_DA" = nein ]; then
  echo "   GESPERRT — ohne psql nicht messbar"
  merke "M30-Prueffaelle" gesperrt "psql fehlt"
elif [ ! -f "$P" ]; then
  echo "::error::$P fehlt — GESPERRT"
  merke "M30-Prueffaelle" gesperrt "Datei fehlt"
else
  if aus=$(psql -v ON_ERROR_STOP=1 -f "$P" 2>&1); then
    summe=$(printf '%s\n' "$aus" | sed -n 's/.*SUMME: \(.*\)/\1/p' | head -1)
    echo "   $summe"
    merke "M30-Prueffaelle" bestanden "${summe:-ohne Summenzeile}"
  else
    # HIER starb der Lauf. Ohne "|| true" beendet ein grep OHNE Treffer
    # (Rueckgabewert 1) unter "set -euo pipefail" das ganze Skript -- und zwar
    # VOR der ::error::-Zeile darunter. Der Fehlerzweig kam also nie dazu, den
    # Fehler zu melden. Betroffen war jede psql-Stoerung, deren Ausgabe keines
    # der drei Muster enthaelt: fehlendes psql, unerreichbare Datenbank,
    # falsche Anmeldung (BEF-D3, gemessen 10.08.2026).
    if printf '%s\n' "$aus" | grep -q '^psql: error:'; then
      # psql selbst kam nicht durch: Verbindung, Anmeldung, fehlende Datenbank.
      # Dann wurde NICHTS gemessen -- das ist GESPERRT, nicht fehlgeschlagen.
      # Der Unterschied ist der ganze Punkt von K23-M22: "gemessen und schlecht"
      # ist ein Ergebnis, "nicht gemessen" ist keines.
      printf '%s\n' "$aus" | head -5 | sed 's/^/   /'
      echo "::error::Datenbank nicht erreichbar — GESPERRT, nicht gemessen"
      merke "M30-Prueffaelle" gesperrt "psql kam nicht durch"
      PSQL_DA=nein   # die Negativfaelle brauchen es gar nicht erst zu versuchen
      PSQL_GRUND="Datenbank nicht erreichbar"
    else
      gefiltert=$(printf '%s\n' "$aus" | grep -E 'GESCHEITERT|FEHLER|SUMME' | head -20 || true)
      if [ -n "$gefiltert" ]; then
        printf '%s\n' "$gefiltert"
      else
        # Kein bekanntes Muster? Dann die Rohausgabe zeigen. Eine Stoerung, die
        # das Filtermuster NICHT kennt, ist die interessantere -- nicht die,
        # die man wegwirft.
        printf '%s\n' "$aus" | head -20 | sed 's/^/   /'
      fi
      echo "::error::Migrationsprueffaelle nicht bestanden"
      anz=$(printf '%s' "$aus" | grep -c 'GESCHEITERT' || true)
      merke "M30-Prueffaelle" fehlgeschlagen "${anz:-0} Fehlschlaege"
    fi
  fi
fi

# ---------------------------------------------------------------------
# 2 · Die Negativfaelle — jeder an SEINER Bedingung
# ---------------------------------------------------------------------
echo
echo "== Negativfaelle =="
shopt -s nullglob
for f in migrations/negativfaelle/*.sql; do
  kennung=$(basename "$f" .sql)
  if [ "$PSQL_DA" = nein ]; then
    echo "   $kennung — GESPERRT: $PSQL_GRUND"
    merke "$kennung" gesperrt "$PSQL_GRUND"
    continue
  fi
  erwartet=$(sed -n 's/^-- erwartet: *//p' "$f" | head -1)
  if [ -z "$erwartet" ]; then
    echo "   $kennung — GESPERRT: nennt keine erwartete Bedingung"
    merke "$kennung" gesperrt "keine erwartete Bedingung genannt"
    continue
  fi
  if aus=$(psql -v ON_ERROR_STOP=1 -q -f "$f" 2>&1); then
    echo "   $kennung — DURCHGELAUFEN, die Bedingung fehlt"
    merke "$kennung" fehlgeschlagen "durchgelaufen statt abgewiesen"
  elif printf '%s\n' "$aus" | grep -q '^psql: error:'; then
    # Nicht "falsche Bedingung", sondern gar keine Messung. Ohne diese Zeile
    # meldete ein Verbindungsabbruch vier FEHLSCHLAEGE -- und ein Fehlschlag
    # klingt nach einem Ergebnis (BEF-D3, gemessen 10.08.2026).
    echo "   $kennung — GESPERRT: psql kam nicht durch, nichts gemessen"
    printf '%s\n' "$aus" | head -2 | sed 's/^/      /'
    merke "$kennung" gesperrt "psql kam nicht durch"
  elif printf '%s' "$aus" | grep -qF "$erwartet"; then
    echo "   $kennung — scheitert an $erwartet"
    merke "$kennung" bestanden "$erwartet"
  else
    echo "   $kennung — FALSCHE BEDINGUNG. Erwartet: $erwartet"
    printf '%s\n' "$aus" | head -2 | sed 's/^/      /'
    merke "$kennung" fehlgeschlagen "scheitert an fremder Bedingung"
  fi
done

# ---------------------------------------------------------------------
# 3 · Die Klausel-Prueffaelle des blinden Pruef-Agenten
#
#     Sie pruefen gegen einen LAUFENDEN Server, nicht gegen eine Datei.
#     Aufbauen muss ihn dieser Lauf: eigene Wegwerfdatenbank, eigener
#     Server auf einem FREIEN Port, danach beides weg.
#
#     Warum ein freier Port und kein fester: Am 10.08.2026 hielt ein
#     vergessener uvicorn aus einem frueheren Lauf den Port 8099. Der
#     neue Server startete nie ("address already in use"), und zehn
#     Faelle meldeten Fehlschlaege gegen den ALTEN Stand. Ein Ergebnis,
#     das nach Messung aussah und keine war.
#
#     Rueckgabewerte des Prueflaufs (sein eigener Vertrag):
#       0  alle Faelle bestanden
#       2  ABBRUCH -- die Aufbaupruefung nach F07 hat nicht getragen,
#          es wurde NICHTS gemessen  -> GESPERRT, nicht fehlgeschlagen
#       *  Faelle gescheitert                        -> fehlgeschlagen
# ---------------------------------------------------------------------
echo
echo "== Klausel-Prueffaelle =="

freier_port() {
  # Port 0 binden und den zugeteilten melden. Ein fester Port hat am
  # 10.08.2026 zehn Faelle gegen einen alten Server messen lassen.
  python3 -c 'import socket;s=socket.socket();s.bind(("127.0.0.1",0));print(s.getsockname()[1]);s.close()'
}

klausellauf() {  # $1 = Prueflauf-Datei · $2 = Kennung
  local lauf="$1" kennung="$2"
  local daten="${lauf%_lauf.sh}_daten.sql"
  local db="klausel_${kennung}_$$"
  local port pfeffer schluessel pid=0 log rc summe
  local smtp_port smtp_pid=0 mailfang gescheitert geblockt

  [ -f "$daten" ] || {
    echo "   $kennung — GESPERRT: $daten fehlt"
    merke "$kennung" gesperrt "Datendatei fehlt"; return; }
  [ -x .venv/bin/uvicorn ] || {
    echo "   $kennung — GESPERRT: .venv/bin/uvicorn fehlt"
    merke "$kennung" gesperrt "uvicorn fehlt"; return; }

  # Aufraeumen in JEDEM Ausgang -- auch bei Abbruch mitten im Lauf.
  # Ohne das bleibt ein Server stehen und vergiftet den naechsten Lauf,
  # genau wie am 10.08.2026.
  # Jede Zeile einzeln entschaerft. "wait" auf einen getoeteten Prozess
  # liefert 143 (128+SIGTERM) -- unter "set -e" beendet das die ganze
  # Kette, und zwar VOR dem Aufraeumen der Datenbank und vor dem
  # Ergebnisteil des Laufs. Gemessen am 10.08.2026: 30 von 30 bestanden,
  # danach Rueckgabewert 143 und keine Summenzeile. Ein bestandener Lauf,
  # der als Fehlschlag endete -- und eine Wegwerfdatenbank, die blieb.
  aufraeumen() {
    for p in "$pid" "$smtp_pid"; do
      if [ "${p:-0}" -gt 0 ] 2>/dev/null; then
        kill "$p" 2>/dev/null || true
        wait "$p" 2>/dev/null || true
      fi
    done
    # Zum Nachsehen aufheben, wenn ausdruecklich verlangt. Ohne das laesst
    # sich ein Fehlschlag beim Mailweg nur erraten -- und Raten ist genau das,
    # was dieser Harness nicht tut.
    if [ -n "${FREIRAUM_PRUEF_MAILFANG_BEHALTEN:-}" ] && [ -s "$mailfang" ]; then
      cp "$mailfang" "$FREIRAUM_PRUEF_MAILFANG_BEHALTEN/${kennung}_mailfang.txt" 2>/dev/null || true
    fi
    rm -f "$mailfang" 2>/dev/null || true
    psql -d postgres -qAt -c "DROP DATABASE IF EXISTS \"$db\" WITH (FORCE)" >/dev/null 2>&1 || true
    return 0
  }
  trap aufraeumen RETURN

  # Beide Werte je Lauf neu und nur hier bekannt. Ein fest verdrahteter
  # Pfeffer im Prueflauf waere ein Geheimnis im Repo (K23-D09).
  #
  # Sie entstehen VOR der Datenlage, nicht danach: anmeldung_daten.sql
  # liest FREIRAUM_CODE_PFEFFER selbst (\getenv) und beendet sich sonst
  # mit \quit -- und \quit gibt NULL zurueck. Ohne den Wert legte psql
  # also nichts an und meldete Erfolg. Gemessen am 10.08.2026: die
  # Pruefdatenbank blieb leer, der Lauf brach erst spaeter an der
  # fehlenden Sicht ab. Derselbe Fehlertyp wie BEF-D3 -- ein stiller
  # Nichtlauf, der wie ein Erfolg aussieht.
  pfeffer=$(python3 -c 'import secrets;print(secrets.token_hex(16))')
  schluessel=$(python3 -c 'import secrets;print(secrets.token_hex(32))')
  port=$(freier_port)
  smtp_port=$(freier_port)
  log="$(mktemp)"
  mailfang="$(mktemp)"

  # Der Mailfaenger. Ohne ihn misst dieser Lauf den Bau nicht, sondern seine
  # eigene Unvollstaendigkeit: mail/versand.py prueft den Versandweg, BEVOR
  # etwas entsteht (BEF-L2-1 eine Ebene tiefer), und weist ohne erreichbaren
  # Dienst den ganzen Vorgang ab. Der Erfolgsweg antwortet dann mit 200 statt
  # 303 -- und fuenf Faelle melden Fehlschlaege gegen eine Anwendung, die
  # nichts falsch gemacht hat. Gemessen am 11.08.2026.
  #
  # Bewusst hier und nicht als Werkzeug im Repo: Die Umgebung herzustellen ist
  # Sache des Laufs. Ein Faenger, den der Bau-Agent pflegen muesste, waere eine
  # Pruefeinrichtung in seiner Hand.
  python3 - "$smtp_port" "$mailfang" <<'PY' >/dev/null 2>&1 &
import socket, sys, threading
lauscher = socket.socket()
lauscher.setsockopt(socket.SOL_SOCKET, socket.SO_REUSEADDR, 1)
lauscher.bind(("127.0.0.1", int(sys.argv[1]))); lauscher.listen(16)
ziel = sys.argv[2]
def bedienen(draht):
    f = draht.makefile("rwb")
    f.write(b"220 mailfaenger\r\n"); f.flush()
    im_rumpf = False
    gesammelt = []
    while True:
        zeile = f.readline()
        if not zeile:
            break
        if im_rumpf:
            if zeile.strip() == b".":
                im_rumpf = False
                # ENTPACKT ablegen, nicht roh. Gemessen am 11.08.2026: Der
                # Versand schickt "quoted-printable", weil der Text Umlaute
                # traegt. Darin wird aus "token=" ein "token=3D", und die
                # weiche Zeilenumbruchregel zerreisst den Token nach 76
                # Zeichen mitten im Wort:
                #
                #   http://.../einladung?token=3DCyOBPzxOhrUXAspZw3kx6Sw5T=
                #   _grivRI
                #
                # Ein Prueffall, der das selbst zusammensetzen muesste,
                # baute MIME nach -- in einer Shell, ungeprueft, und still
                # falsch, sobald sich die Kodierung aendert. Der Empfaenger
                # einer Mail entpackt sie; der Prueffall spielt den
                # Empfaenger. Also entpackt der Faenger.
                import email, email.policy
                roh = b"".join(gesammelt)
                text = ""
                try:
                    n = email.message_from_bytes(roh, policy=email.policy.default)
                    teil = n.get_body(preferencelist=("plain",)) or n
                    text = teil.get_content()
                    kopf = "".join(f"{k}: {v}\n" for k, v in n.items())
                except Exception:
                    # Nicht entpackbar? Dann roh ablegen und nichts verbergen.
                    kopf, text = "", roh.decode("utf-8", "replace")
                with open(ziel, "a", encoding="utf-8") as d:
                    d.write(kopf + "\n" + text + "\n--- Ende der Nachricht ---\n")
                gesammelt = []
                f.write(b"250 angenommen\r\n"); f.flush()
            else:
                # Punkt-Verdopplung der SMTP-Regel zuruecknehmen
                gesammelt.append(zeile[1:] if zeile.startswith(b"..") else zeile)
            continue
        befehl = zeile.upper()
        if befehl.startswith(b"DATA"):
            im_rumpf = True
            f.write(b"354 los\r\n")
        elif befehl.startswith(b"QUIT"):
            f.write(b"221 tschuess\r\n"); f.flush(); break
        else:
            f.write(b"250 ok\r\n")
        f.flush()
    draht.close()
while True:
    draht, _ = lauscher.accept()
    threading.Thread(target=bedienen, args=(draht,), daemon=True).start()
PY
  smtp_pid=$!

  if ! psql -d postgres -qAt -c "CREATE DATABASE \"$db\" TEMPLATE \"$PGDATABASE\"" >/dev/null 2>&1; then
    echo "   $kennung — GESPERRT: Wegwerfdatenbank aus $PGDATABASE nicht anlegbar"
    merke "$kennung" gesperrt "Vorlage $PGDATABASE nicht kopierbar"; return
  fi
  if ! FREIRAUM_CODE_PFEFFER="$pfeffer" \
       psql -d "$db" -v ON_ERROR_STOP=1 -q -f "$daten" >"$log" 2>&1; then
    echo "   $kennung — GESPERRT: $daten laeuft nicht durch"
    head -5 "$log" | sed 's/^/      /'
    rm -f "$log"
    merke "$kennung" gesperrt "Datenlage nicht herstellbar"; return
  fi
  # Gegenprobe zum \quit-Fall: ein Rueckgabewert von null beweist NICHT,
  # dass etwas entstanden ist. Eine Datendatei, die ihre Vorbedingung
  # nicht erfuellt sieht, meldet das und beendet sich mit \quit -- also
  # mit null. Geprueft wird deshalb ihre Meldung, nicht ihr Rueckgabewert.
  # Bewusst gegen das Wort ABBRUCH und nicht gegen ein einzelnes Objekt:
  # der Prueflauf darf nicht wissen muessen, WAS die Datei anlegt.
  if grep -q 'ABBRUCH' "$log" 2>/dev/null; then
    echo "   $kennung — GESPERRT: $daten hat abgebrochen und trotzdem null gemeldet"
    grep 'ABBRUCH' "$log" | head -3 | sed 's/^/      /'
    rm -f "$log"
    merke "$kennung" gesperrt "Datendatei brach ab, Rueckgabewert null"; return
  fi

  FREIRAUM_DSN="postgresql://$PGUSER:${PGPASSWORD:-pilot}@$PGHOST:$PGPORT/$db" \
  FREIRAUM_CODE_PFEFFER="$pfeffer" \
  FREIRAUM_SITZUNG_SCHLUESSEL="$schluessel" \
  FREIRAUM_UMGEBUNG=lokal \
  FREIRAUM_SMTP_HOST=127.0.0.1 FREIRAUM_SMTP_PORT="$smtp_port" FREIRAUM_SMTP_TLS=0 \
    .venv/bin/uvicorn app.haupt:app --host 127.0.0.1 --port "$port" >"$log" 2>&1 &
  pid=$!

  # Warten, bis er antwortet -- und aufgeben, statt ewig zu haengen.
  local i=0
  until curl -sS -o /dev/null --max-time 2 "http://127.0.0.1:$port/gesundheit" 2>/dev/null; do
    i=$((i+1))
    if [ "$i" -ge 50 ] || ! kill -0 "$pid" 2>/dev/null; then
      echo "   $kennung — GESPERRT: Server kam nicht hoch (Port $port)"
      head -5 "$log" | sed 's/^/      /'
      rm -f "$log"
      merke "$kennung" gesperrt "Server startete nicht"; return
    fi
    sleep 0.2
  done

  set +e
  aus=$(FREIRAUM_PRUEF_URL="http://127.0.0.1:$port" \
        FREIRAUM_CODE_PFEFFER="$pfeffer" \
        FREIRAUM_SITZUNG_SCHLUESSEL="$schluessel" \
        PGDATABASE="$db" \
        FREIRAUM_PRUEF_MAILFANG="$mailfang" \
        "$lauf" 2>&1)
  rc=$?
  set -e
  rm -f "$log"

  summe=$(printf '%s\n' "$aus" | sed -n 's/^SUMME: //p' | head -1)
  case "$rc" in
    0) echo "   $kennung — ${summe:-bestanden}"
       merke "$kennung" bestanden "${summe:-ohne Summenzeile}" ;;
    2) # F07: die Aufbaupruefung des Prueflaufs hat nicht getragen.
       # Dann ist kein einziger Fall gelaufen -- das ist GESPERRT.
       printf '%s\n' "$aus" | grep '^ABBRUCH' | head -1 | sed 's/^/      /' || true
       echo "   $kennung — GESPERRT: Aufbaupruefung (F07) hat nicht getragen"
       merke "$kennung" gesperrt "F07-Abbruch, nichts gemessen" ;;
    *) printf '%s\n' "$aus" | grep -E 'GESCHEITERT|GESPERRT' | head -12 | sed 's/^/      /' || true
       # Sind ALLE nicht bestandenen Faelle gesperrt, ist der Lauf nicht
       # fehlgeschlagen -- er hat einen Bereich nicht messen koennen. K23-M22
       # kennt vier Zustaende, und "gesperrt" ist keiner davon "fehlgeschlagen".
       # Die Regel steht seit dem 09.08.2026 weiter unten in dieser Datei und
       # galt bisher nur fuer die Migrations- und Negativfaelle; hier wurde sie
       # nachgezogen (Vermerk Blatt 64, 11.08.2026).
       #
       # Kein Fall wird dadurch nachgiebiger und kein gesperrter Fall gilt als
       # bestanden. Nur der NAME des Ergebnisses wird richtig.
       gescheitert=$(printf '%s\n' "$aus" | sed -n 's/^SUMME:.*bestanden, \([0-9][0-9]*\) gescheitert.*/\1/p' | head -1)
       geblockt=$(printf '%s\n' "$aus" | sed -n 's/^davon GESPERRT[^:]*: *\([0-9][0-9]*\).*/\1/p' | head -1)
       if [ -n "${gescheitert:-}" ] && [ -n "${geblockt:-}" ] \
          && [ "$geblockt" -gt 0 ] && [ "$gescheitert" -eq "$geblockt" ]; then
         echo "::warning::$kennung — ${summe:-ohne Summenzeile}; alle offenen Punkte GESPERRT, keiner gescheitert"
         merke "$kennung" gesperrt "${summe:-ohne Summenzeile}"
       else
         echo "::error::$kennung — ${summe:-Faelle gescheitert}"
         merke "$kennung" fehlgeschlagen "${summe:-ohne Summenzeile}"
       fi ;;
  esac
}

shopt -s nullglob
klauselfaelle=(pruefungen/klauseln/*_lauf.sh)

if [ "${#klauselfaelle[@]}" -eq 0 ]; then
  echo "   keine vorhanden — GESPERRT, nicht bestanden (K23-M22)"
  echo "   Sie entstehen je Scheibe durch den blinden Pruef-Agenten."
  merke "Klausel-Prueffaelle" gesperrt "noch keine Scheibe gebaut"
elif [ "$PSQL_DA" = nein ]; then
  for f in "${klauselfaelle[@]}"; do
    kennung=$(basename "$f" _lauf.sh)
    echo "   $kennung — GESPERRT: $PSQL_GRUND"
    merke "$kennung" gesperrt "$PSQL_GRUND"
  done
else
  for f in "${klauselfaelle[@]}"; do
    klausellauf "$f" "$(basename "$f" _lauf.sh)"
  done
fi

# ---------------------------------------------------------------------
# 4 · Ergebnis
# ---------------------------------------------------------------------
echo
echo "======================================================="
echo "bestanden: $ok · fehlgeschlagen: $fehl · gesperrt: $gesperrt"

if [ -n "$BERICHT" ]; then
  mkdir -p "$(dirname "$BERICHT")"
  cat > "$BERICHT" <<JSON
{
  "lauf": "Tor 1c",
  "bestanden": $ok,
  "fehlgeschlagen": $fehl,
  "gesperrt": $gesperrt,
  "umgebung": "$PGHOST:$PGPORT/$PGDATABASE",
  "migration_sha256": "$(cat migrations/M30__pilot_sammelmigration.sha256 2>/dev/null || echo unbekannt)",
  "prueffaelle_sha256": "$(cat pruefungen/migration/M30__pruefung.sha256 2>/dev/null || echo unbekannt)",
  "ergebnisse": [$zeilen]
}
JSON
  echo "Bericht: $BERICHT"
fi

# Ein Fehlschlag sperrt. Ein GESPERRT sperrt NICHT den Lauf selbst -- es wird
# ausgewiesen und wandert in die Restrisikoliste. Nur so bleibt der Unterschied
# zwischen "gemessen und schlecht" und "nicht gemessen" sichtbar (K23-M22).
if [ "$fehl" -gt 0 ]; then
  echo "::error::Tor 1c: $fehl Fehlschlag/Fehlschlaege"
  exit 1
fi
if [ "$gesperrt" -gt 0 ]; then
  echo "::warning::Tor 1c: $gesperrt Punkt(e) GESPERRT — nicht gemessen, nicht bestanden"
fi

# Ein Lauf ohne einen einzigen bestandenen Punkt hat NICHTS gemessen und darf
# nicht mit "kein Fehlschlag" enden. Sonst haette die Sperre aus Abschnitt 0
# den Fehler nur verschoben: statt wortlos zu sterben, meldete der Lauf alles
# GESPERRT -- und weil ein GESPERRT den Lauf nicht sperrt, waere er GRUEN
# durchgelaufen, ohne eine einzige Zeile SQL ausgefuehrt zu haben.
# CLAUDE.md Abschn. 6: "Einen gruenen Lauf melden, der nichts gemessen hat"
# steht unter dem, was nie getan wird (K23-M22).
if [ "$ok" -eq 0 ]; then
  echo "::error::Tor 1c: kein einziger Punkt bestanden — der Lauf hat nichts gemessen."
  exit 1
fi
echo "Tor 1c: kein Fehlschlag."
