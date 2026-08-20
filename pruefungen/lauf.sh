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

# ---------------------------------------------------------------------
#  NOTAUFRAEUMEN -- der Riegel fuer den Fall, dass dieser Lauf nicht
#  ordentlich zu Ende kommt.
#
#  WAS ES SCHON GAB: `trap aufraeumen RETURN` in klausellauf(). Das
#  greift, wenn die Funktion ZURUECKKEHRT -- also im Normalfall und auch
#  nach einem gescheiterten Fall.
#
#  WAS ES NICHT GAB, UND WAS AM 20.08.2026 GEMESSEN WURDE: Wird der Lauf
#  von aussen abgebrochen -- Strg-C, SIGTERM, ein Zeitablauf des
#  Aufrufers, ein in den Hintergrund verschobener Auftrag --, kehrt
#  klausellauf() nie zurueck. Der RETURN-Riegel feuert dann nicht, und
#  Server und Mailfaenger bleiben stehen. Gezaehlt an diesem Tag: 41
#  vergessene uvicorn-Prozesse, die aelteste acht Tage alt, jeder mit
#  einer offenen Datenbankverbindung.
#
#  Das ist keine Kosmetik. Genau daran ist am 10.08.2026 ein Lauf
#  falsch gemessen worden: ein vergessener Server hielt den Port, der
#  neue startete nie, und zehn Faelle meldeten Fehlschlaege gegen den
#  ALTEN Stand (siehe Abschn. 3). Der freie Port entschaerft das; die
#  vergessenen Prozesse selbst blieben.
#
#  WARUM DIE PRUEFUNG VOR DEM TOETEN: Eine Prozessnummer wird vom
#  Betriebssystem wiederverwendet. Blind auf eine gemerkte Nummer zu
#  schiessen, kann einen fremden Prozess treffen, der zufaellig dieselbe
#  bekommen hat. Getoetet wird deshalb nur, was sich noch als der eigene
#  Server oder der eigene Mailfaenger ausweist.
#
#  Der Riegel aendert an keiner Messung etwas: er laeuft erst, wenn der
#  Lauf schon vorbei oder abgebrochen ist, und er beruehrt weder einen
#  Prueffall noch eine Schwelle noch einen Zustand (K23-D05).
# ---------------------------------------------------------------------
#  JE KIND EIN ERKENNUNGSMERKMAL, nicht nur eine Nummer. Der Mailfaenger
#  laeuft als "python3 - <port> <mailfangdatei>" und traegt kein Wort, an
#  dem man ihn erkennen koennte -- ausser der Wegwerfdatei, die nur dieser
#  Lauf kennt. Sie ist das Merkmal. Beim Server ist es "app.haupt:app".
#  UND EIN ZWEITER RIEGEL, WEIL DER ERSTE NICHT ALLES SIEHT.
#
#  Gemessen am 20.08.2026: Auch mit dem Riegel oben ueberlebte JE LAUF
#  genau ein Server. Die Ursache liegt nicht hier, sondern in
#  pruefungen/klauseln/anmeldung_lauf.sh: dort wird uvicorn in einer
#  Unterschale gestartet --  ( cd "$REPO" ... uvicorn ) &  -- und `$!`
#  liefert die Nummer der UNTERSCHALE, nicht die des Servers. Wird die
#  Unterschale getoetet, bleibt der Server als Waise stehen (Elternteil
#  wird 1). So sind bis zum 20.08.2026 41 Prozesse aufgelaufen, der
#  aelteste acht Tage alt.
#
#  Die Ursache gehoert dem Pruef-Agenten -- der Bau fasst pruefungen/
#  nicht an. Dieser Lauf kann sie aber EINGRENZEN, ohne etwas zu raten:
#  Er merkt sich beim Start, welche Server es SCHON gab, und raeumt am
#  Ende nur das ab, was WAEHREND seiner Laufzeit dazugekommen ist.
#
#  Damit bleibt ein Server, den jemand nebenher zum Entwickeln laufen
#  laesst, unangetastet -- er stand vorher da und steht nachher noch.
# `|| true` ist hier nicht Zierde: pgrep meldet 1, wenn es NICHTS findet --
# also genau auf einer sauber aufgeraeumten Maschine. Unter `set -e` beendet
# das den Lauf, bevor die erste Zeile Ausgabe entsteht. GEMESSEN AM
# 20.08.2026, unmittelbar nach dem Einbau dieses Riegels: ein leeres
# Protokoll und Rueckgabewert 1. Der Riegel gegen vergessene Prozesse haette
# den Lauf also ausgerechnet dann umgeworfen, wenn keiner vergessen war.
FREMDE_SERVER="$(pgrep -f 'app\.haupt:app' 2>/dev/null | tr '\n' ' ' || true)"

KINDER=""          # je Zeile: <Prozessnummer><TAB><Erkennungsmerkmal>

kind_merken() {    # $1 Prozessnummer · $2 Merkmal in seiner Kommandozeile
  KINDER="${KINDER}$1	$2
"
}

notaufraeumen() {
  rc_vorher=$?
  [ -n "$KINDER" ] || return $rc_vorher
  uebrig=""
  while IFS='	' read -r p muster; do
    [ -n "${p:-}" ] || continue
    kill -0 "$p" 2>/dev/null || continue
    # Nur toeten, was sich noch als eigenes Kind ausweist.
    case "$(ps -o command= -p "$p" 2>/dev/null)" in
      *"$muster"*) kill "$p" 2>/dev/null || true
                   uebrig="${uebrig}${uebrig:+ }$p" ;;
    esac
  done <<KINDERLISTE
$KINDER
KINDERLISTE

  # NACHFASSEN. Gemessen am 20.08.2026, unmittelbar nach dem Einbau dieses
  # Riegels: EIN Server ueberlebte einen ordentlich beendeten Lauf. Er ging
  # anschliessend auf ein einzelnes SIGTERM sofort weg -- er hatte also nie
  # eines bekommen oder es im Anlauf verschluckt. Ein Server, der ein Signal
  # verschluckt, ist kein seltener Fall: uvicorn setzt seinen eigenen
  # Griff auf SIGTERM erst, wenn es hochgefahren ist.
  #
  # Deshalb wird nicht einmal geschossen und geglaubt, sondern nachgesehen.
  # Wer nach einer Atempause noch lebt, bekommt SIGKILL -- und wieder nur,
  # wenn er sich noch als eigenes Kind ausweist.
  if [ -n "$uebrig" ]; then
    sleep 2
    for p in $uebrig; do
      kill -0 "$p" 2>/dev/null || continue
      case "$(ps -o command= -p "$p" 2>/dev/null)" in
        *app.haupt:app*|*python3*) kill -9 "$p" 2>/dev/null || true ;;
      esac
    done
  fi

  # Der zweite Riegel: die Waisen, die dieser Lauf nicht selbst gestartet
  # hat, die es aber vor ihm noch nicht gab.
  for p in $(pgrep -f 'app\.haupt:app' 2>/dev/null || true); do
    case " $FREMDE_SERVER " in
      *" $p "*) continue ;;              # stand schon vorher da -- nicht anfassen
    esac
    kill "$p" 2>/dev/null || true
  done
  return $rc_vorher
}
trap notaufraeumen EXIT
trap 'notaufraeumen; exit 130' INT
trap 'notaufraeumen; exit 143' TERM

ok=0; fehl=0; gesperrt=0
zeilen=""
# Glied 7 nach K23-M18 verlangt Beginn UND Ende. Der Beginn ist jetzt.
BEGINN="$(date -u +%Y-%m-%dT%H:%M:%SZ)"

# JSON-Maskierung, seit 20.08.2026. Vorher baute diese Funktion die Zeile
# durch blosses Aneinanderhaengen -- ein Anfuehrungszeichen in der Anmerkung
# haette den Bericht unlesbar gemacht. Bis dahin fiel es nicht auf, weil
# keine Anmerkung eines fuehrte. Mit der Fehlermeldung aus dem Erfolgszweig
# der Negativfaelle fuehrt sie sofort welche: PostgreSQL schreibt
# `violates check constraint "frist_ge_mindestfrist"`.
json_wert() { printf '%s' "$1" | sed -e 's/\\/\\\\/g' -e 's/"/\\"/g' -e 's/\t/ /g' | tr -d '\n\r'; }

merke() {  # kennung · zustand · anmerkung
  zeilen="${zeilen}${zeilen:+,}{\"kennung\":\"$(json_wert "$1")\",\"zustand\":\"$(json_wert "$2")\",\"anmerkung\":\"$(json_wert "$3")\"}"
  case "$2" in
    bestanden)      ok=$((ok+1)) ;;
    fehlgeschlagen) fehl=$((fehl+1)) ;;
    gesperrt)       gesperrt=$((gesperrt+1)) ;;
  esac
}

# ---------------------------------------------------------------------
# Die FALLZAEHLUNG -- neben der Punktzaehlung, nicht an ihrer Stelle.
#
# merke() zaehlt PRUEFPUNKTE: ein Klausellauf ist EIN Punkt, ob er 9 oder
# 27 Faelle fuehrt. Gemessen am 18.08.2026 meldete dieser Lauf am Ende
# "gesperrt: 4" -- und 22 Einzelfaelle waren nicht gemessen:
#
#     zweckbestimmung  19        vorpruefung      1
#     mitgliedschaft    1        anmeldecode      1
#
# Wer "4" liest, haelt 22 ungemessene Faelle fuer gemessen. Der Fehler war
# nicht die kleine Zahl, sondern dass die groessere fehlte.
#
# Gelesen wird die Summenzeile des Klausellaufs im Wortlaut:
#     SUMME: 8 von 27 bestanden, 19 gescheitert
#     davon GESPERRT (...): 19
# Fehlt sie, wird NICHTS gezaehlt -- eine geratene Zahl waere schlimmer als
# keine (K23-M22).
# ---------------------------------------------------------------------
f_ok=0; f_fehl=0; f_gesperrt=0; f_ohne_summe=0

faelle_zaehlen() {  # $1 = vollstaendige Ausgabe eines Klausellaufs
  local best schlecht blockiert
  best=$(printf '%s\n' "$1" | sed -n 's/^SUMME: \([0-9][0-9]*\) von .*/\1/p' | head -1)
  schlecht=$(printf '%s\n' "$1" | sed -n 's/^SUMME:.*bestanden, \([0-9][0-9]*\) gescheitert.*/\1/p' | head -1)
  blockiert=$(printf '%s\n' "$1" | sed -n 's/^davon GESPERRT[^:]*: *\([0-9][0-9]*\).*/\1/p' | head -1)

  if [ -z "${best:-}" ] || [ -z "${schlecht:-}" ]; then
    f_ohne_summe=$((f_ohne_summe+1))
    return
  fi
  : "${blockiert:=0}"
  f_ok=$((f_ok + best))
  f_gesperrt=$((f_gesperrt + blockiert))
  # Was gescheitert und NICHT gesperrt ist, ist echt fehlgeschlagen.
  f_fehl=$((f_fehl + schlecht - blockiert))
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
    # DIE MELDUNG IM WORTLAUT, seit 20.08.2026.
    #
    # Hier stand nur `scheitert an $erwartet` -- also der Name, den die
    # Datei SELBST als erwartete Bedingung fuehrt. Der Lauf behauptete
    # damit, der Fall sei an seiner eigenen Bedingung gescheitert, und
    # warf den einzigen Beleg dafuer weg.
    #
    # CLAUDE.md:180-182 verlangt ihn: "Ein Negativfall gilt erst als
    # bestanden, wenn er an seiner eigenen Bedingung scheitert; DIE
    # FEHLERMELDUNG IM WORTLAUT IST TEIL DER EVIDENZ." Gezeichnete
    # Grundlage: Bauauftrag §9 Tor I Nr. 6 (:649), README.md:204.
    #
    # GEFUNDEN HAT ES TOR 3 am 20.08.2026, nicht dieser Harness: "Im
    # Erfolgszweig verwirft der Harness die tatsaechliche Fehlermeldung
    # und gibt nur 'scheitert an $erwartet' aus. Darum kann ich die
    # verlangten vier tatsaechlichen Fehlermeldungen im Wortlaut nicht
    # ehrlich zitieren."
    meldung="$(printf '%s\n' "$aus" | grep -m1 -E 'ERROR|FEHLER' | sed 's/^[[:space:]]*//')"
    : "${meldung:=(keine ERROR-Zeile in der Ausgabe gefunden)}"
    echo "   $kennung — scheitert an $erwartet"
    echo "      $meldung"
    merke "$kennung" bestanden "scheitert an $erwartet · $meldung"
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

# ---------------------------------------------------------------------
# Auflage aus Blatt 90 Punkt 2: Laeuft dieser Lauf mit echtem Versand,
# sagt er es SELBST -- und zwar VOR den Faellen, nicht danach.
#
# Der Grund ist gemessen: Am 17.08.2026 entstand ein Lauf mit neun roten
# Faellen, weil der echte Wirt keine Adresse @pruef.example annimmt. Wer
# ihn spaeter liest, haelt neun Fehlschlaege fuer einen Baubefund. Sie
# sind keiner -- sie sind die Folge dieses Zustands.
# ---------------------------------------------------------------------
if [ "${FREIRAUM_ECHTVERSAND:-}" = "ja" ]; then
  echo "::warning::ECHTVERSAND-LAUF — dieser Lauf misst NUR AC-16."
  echo "   Der Server verschickt ueber den echten Wirt (${FREIRAUM_SMTP_HOST:-<nicht gesetzt>})."
  echo "   Die uebrigen Faelle brauchen den oertlichen Faenger und TRAGEN HIER NICHT:"
  echo "   Adressen @pruef.example nimmt kein fremder Anbieter an, der Versand"
  echo "   scheitert, und die Anwendung entwertet daraufhin den Code (mail/versand.py)."
  echo "   Ihre Fehlschlaege sind KEIN Baubefund (Blatt 90, Abschn. 4)."
  echo "   Fuer einen vollstaendigen Lauf: FREIRAUM_ECHTVERSAND leer lassen."
  echo
fi

freier_port() {
  # Port 0 binden und den zugeteilten melden. Ein fester Port hat am
  # 10.08.2026 zehn Faelle gegen einen alten Server messen lassen.
  python3 -c 'import socket;s=socket.socket();s.bind(("127.0.0.1",0));print(s.getsockname()[1]);s.close()'
}

klausellauf() {  # $1 = Prueflauf-Datei · $2 = Kennung
  local lauf="$1" kennung="$2"
  local daten="${lauf%_lauf.sh}_daten.sql"
  # BEFUND BEF-AC-16-3 (Blatt 91, 18.08.2026): Bei echtem Versand wird
  # NICHT geklont. Der Prueflauf klont sonst je Lauf eine frische
  # Datenbank und wirft sie danach weg -- und mit ihr den
  # mail_delivery-Nachweis, auf den sich der zweite Durchgang von
  # AC-16 stuetzt. Durchgang 2 fand deshalb nie einen frischen
  # Versand, hielt sich fuer Durchgang 1 und verschickte erneut.
  # Gemessen: Mail 1 um 11:27:03, Mail 2 um 11:32:24 -- 321 s
  # Abstand bei 300 s Bindungstoleranz. Die Schleife konnte sich nie
  # schliessen; jeder Pruefversuch entwertete den soeben geholten Kopf.
  #
  # Der Preis ist benannt (Blatt 91 Abschn. 7): Ohne Klonen laufen die
  # Faelle gegen dieselbe Datenbank und stoeren einander. Im
  # Echtversand-Lauf ist das hinnehmbar, weil er nach Blatt 90 ohnehin
  # NUR AC-16 misst.
  local db
  if [ "${FREIRAUM_ECHTVERSAND:-}" = "ja" ]; then
    db="$PGDATABASE"
  else
    db="klausel_${kennung}_$$"
  fi
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
    # Bei Echtversand ist $db die Datenbank des Aufrufers -- sie gehoert
    # ihm, nicht diesem Lauf. Sie zu loeschen naehme dem naechsten
    # Durchgang genau den Nachweis, den er braucht.
    if [ "${FREIRAUM_ECHTVERSAND:-}" != "ja" ]; then
      psql -d postgres -qAt -c "DROP DATABASE IF EXISTS \"$db\" WITH (FORCE)" >/dev/null 2>&1 || true
    fi
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
  kind_merken "$smtp_pid" "$mailfang"

  if [ "${FREIRAUM_ECHTVERSAND:-}" = "ja" ]; then
    : # keine Kopie -- $db IST $PGDATABASE (Blatt 91)
  elif ! psql -d postgres -qAt -c "CREATE DATABASE \"$db\" TEMPLATE \"$PGDATABASE\"" >/dev/null 2>&1; then
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

  # ---------------------------------------------------------------------
  # Der Wirt des Servers: Faenger oder echter Weg?
  #
  # BEFUND BEF-AC-16-2 (Blatt 90, 17.08.2026): Diese Stelle setzte den Wirt
  # UNBEDINGT auf 127.0.0.1. AC-16 braucht aber den echten Versandweg zu
  # einem fremden Anbieter -- und bekam ihn nie. Der Fall war ueber diesen
  # Prueflauf nicht schwer zu erfuellen, sondern UNERFUELLBAR.
  #
  # Entstanden aus der Rollentrennung: Der Faenger (11.08.) musste den Wirt
  # setzen, damit die uebrigen Faelle den versandten Code lesen koennen;
  # AC-16 (14.08.) durfte diesen Prueflauf nicht lesen. Beide Seiten haben
  # richtig gehandelt, und die Luecke lag zwischen ihnen.
  #
  # Weg A aus Blatt 90: Mit FREIRAUM_ECHTVERSAND=ja gehen die Werte des
  # Aufrufers durch. OHNE die Variable bleibt alles wie bisher -- der
  # Normalfall ist unberuehrt.
  # ---------------------------------------------------------------------
  if [ "${FREIRAUM_ECHTVERSAND:-}" = "ja" ]; then
    # OHNE FREIRAUM_UMGEBUNG=lokal -- und das ist der ganze Punkt.
    #
    # Gemessen am 18.08.2026: Mit "lokal" faellt die Portvorgabe in
    # mail/versand.py auf 1025 (der oertliche Faenger); ohne sie auf 587
    # (der uebliche Einlieferungsport). Der erste Anlauf dieses Zweiges
    # liess zwar den WIRT durch, behielt aber "lokal" -- die Anwendung
    # versuchte mail.bytecamp.net:1025, wo nichts horcht. Die Mail kam
    # wieder nicht an, und AC-16 sperrte zu Recht.
    #
    #   UMGEBUNG=lokal -> Port 1025 · mail.bytecamp.net:1025 zu
    #   UMGEBUNG=""    -> Port 587  · mail.bytecamp.net:587  offen
    #
    # Ohne "lokal" sind FREIRAUM_SMTP_HOST und FREIRAUM_DSN Pflicht
    # (BEF-L2-1). Beide werden hier gesetzt -- der Aufrufer liefert den
    # Wirt, diese Zeile den DSN.
    FREIRAUM_DSN="postgresql://$PGUSER:${PGPASSWORD:-pilot}@$PGHOST:$PGPORT/$db" \
    FREIRAUM_CODE_PFEFFER="$pfeffer" \
    FREIRAUM_SITZUNG_SCHLUESSEL="$schluessel" \
      .venv/bin/uvicorn app.haupt:app --host 127.0.0.1 --port "$port" >"$log" 2>&1 &
  else
    FREIRAUM_DSN="postgresql://$PGUSER:${PGPASSWORD:-pilot}@$PGHOST:$PGPORT/$db" \
    FREIRAUM_CODE_PFEFFER="$pfeffer" \
    FREIRAUM_SITZUNG_SCHLUESSEL="$schluessel" \
    FREIRAUM_UMGEBUNG=lokal \
    FREIRAUM_SMTP_HOST=127.0.0.1 FREIRAUM_SMTP_PORT="$smtp_port" FREIRAUM_SMTP_TLS=0 \
      .venv/bin/uvicorn app.haupt:app --host 127.0.0.1 --port "$port" >"$log" 2>&1 &
  fi
  pid=$!
  kind_merken "$pid" "app.haupt:app"

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
  # Bei echtem Versand das Serverprotokoll AUFHEBEN. Zweimal ist am
  # 17./18.08.2026 geraten worden, warum keine Mail ankam -- der Grund
  # stand jedesmal im Protokoll, und das Protokoll war geloescht. Es
  # traegt keine Zugangswerte: der DSN wird maskiert (BEF-L2-1), und ein
  # smtplib-Fehler zeigt die Antwort des Servers, nicht das Kennwort.
  if [ "${FREIRAUM_ECHTVERSAND:-}" = "ja" ] && [ -s "$log" ]; then
    cp "$log" "/tmp/freiraum_server_${kennung}.log" 2>/dev/null || true
    echo "   Serverprotokoll aufgehoben: /tmp/freiraum_server_${kennung}.log"
  fi
  rm -f "$log"

  summe=$(printf '%s\n' "$aus" | sed -n 's/^SUMME: //p' | head -1)

  # BEFUND vom 18.08.2026: Die Summenzeile am Ende dieses Laufs zaehlt
  # PRUEFPUNKTE -- und ein Klausellauf ist EIN Punkt, gleich ob er 9 oder
  # 27 Faelle fuehrt. Am 18.08.2026 meldete der Lauf "gesperrt: 4", waehrend
  # 22 EINZELFAELLE nicht gemessen waren (zweckbestimmung 19, vorpruefung 1,
  # mitgliedschaft 1, anmeldecode 1). Wer "4" liest, haelt 22 ungemessene
  # Faelle fuer gemessen.
  #
  # Die Punktzaehlung bleibt, wie sie ist -- sie ist fuer den Rueckgabewert
  # richtig. Daneben tritt eine FALLZAEHLUNG. Zwei Zahlen, zwei Namen; die
  # groessere zu verschweigen war der Fehler, nicht die kleinere zu fuehren.
  faelle_zaehlen "$aus"

  case "$rc" in
    0) echo "   $kennung — ${summe:-bestanden}"
       merke "$kennung" bestanden "${summe:-ohne Summenzeile}" ;;
    2) # F07: die Aufbaupruefung des Prueflaufs hat nicht getragen.
       # Dann ist kein einziger Fall gelaufen -- das ist GESPERRT.
       printf '%s\n' "$aus" | grep '^ABBRUCH' | head -1 | sed 's/^/      /' || true
       echo "   $kennung — GESPERRT: Aufbaupruefung (F07) hat nicht getragen"
       merke "$kennung" gesperrt "F07-Abbruch, nichts gemessen" ;;
    *) # BEFUND vom 18.08.2026: Hier stand `head -12` ohne einen Hinweis
       # darauf, dass gekuerzt wird. Bei zweckbestimmung mit 19 offenen
       # Punkten waren sieben Zeilen unsichtbar -- und nichts sagte es.
       # Eine stille Kuerzung liest sich wie Vollstaendigkeit.
       offen=$(printf '%s\n' "$aus" | grep -cE 'GESCHEITERT|GESPERRT' || true)
       printf '%s\n' "$aus" | grep -E 'GESCHEITERT|GESPERRT' | head -12 | sed 's/^/      /' || true
       if [ "${offen:-0}" -gt 12 ]; then
         echo "      ... $((offen - 12)) weitere Zeile(n) hier nicht gezeigt;"
         echo "      vollstaendig im Bericht (--bericht) und im Klausellauf selbst."
       fi
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
echo "Pruefpunkte: bestanden: $ok · fehlgeschlagen: $fehl · gesperrt: $gesperrt"
# Ein Klausellauf ist EIN Punkt, fuehrt aber viele Faelle. Beide Zahlen
# stehen da, damit "gesperrt: 4" nie wieder wie "vier Faelle" aussieht.
if [ $((f_ok + f_fehl + f_gesperrt)) -gt 0 ]; then
  echo "Einzelfaelle: bestanden: $f_ok · fehlgeschlagen: $f_fehl · gesperrt: $f_gesperrt"
fi
[ "${f_ohne_summe:-0}" -gt 0 ] && \
  echo "::warning::$f_ohne_summe Klausellauf/-laeufe ohne Summenzeile -- ihre Faelle sind in der Einzelfallzaehlung NICHT enthalten"

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

  # ---------------------------------------------------------------------
  # Das Manifest nach K23-M18 -- acht Glieder, nicht vier Zahlen.
  #
  # BEFUND AH-7 (Handover 11.08.2026): "nachweise/manifeste/ existiert im
  # Git-Baum nicht. Der ganze 11.08. hat gemessen und nichts hinterlassen."
  # Der Bericht oben ist eine Zusammenfassung des Laufs; ein MANIFEST ist
  # etwas anderes -- es sagt, GEGEN WELCHEN STAND gemessen wurde, mit
  # welchen Werkzeugen, gegen welche Eingaben, und macht sich selbst
  # nachrechenbar (Glied 8).
  #
  # Es entsteht NEBEN dem Bericht, nicht statt seiner: der Bericht ist die
  # Auskunft ueber das Ergebnis, das Manifest die ueber die Umstaende.
  # ---------------------------------------------------------------------
  MANIFEST="${BERICHT%.json}_manifest.json"
  if [ -x .venv/bin/python ]; then
    .venv/bin/python werkzeuge/manifest.py \
      --ziel "$MANIFEST" --ergebnisse "$BERICHT" --beginn "$BEGINN" || {
        echo "::warning::Manifest konnte nicht erzeugt werden — der Lauf hat "
        echo "::warning::gemessen, aber nichts Nachrechenbares hinterlassen (K23-M18)."
      }
  else
    echo "::warning::.venv/bin/python fehlt — kein Manifest (K23-M18 unerfuellt)."
  fi
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
