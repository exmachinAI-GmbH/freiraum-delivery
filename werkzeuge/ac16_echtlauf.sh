#!/usr/bin/env bash
# =====================================================================
#  AC-16 · Echte Zustellung — Teilaussage 1 der M2-Nachrechnung
#
#      ./ac16_echtlauf.sh vorbereiten <empfaenger>   Durchgang 0
#      ./ac16_echtlauf.sh senden                     Durchgang 1
#      ./ac16_echtlauf.sh pruefen                    Durchgang 2
#
#  WARUM EIN SKRIPT UND NICHT DREI BEFEHLSZEILEN: Jeder Befehl laeuft in
#  einer eigenen Shell -- `export` ueberlebt das nicht. Am 17.08.2026 lief
#  darum ein Versuch mit PGPORT=5432 statt 55433 ins Leere. Hier stehen
#  Umgebung und Lauf in derselben Shell.
#
#  ZWEITER GRUND: Die Anleitung nannte die Befehle mit fuehrendem "!" --
#  in zsh ist das der NICHT-Operator. `! cd X && export …` bricht nach dem
#  cd ab, weil der Erfolg zu einem Misserfolg negiert wird. Gemessen:
#  `zsh -c '! cd /tmp && echo ERREICHT'` gibt nichts aus.
#
#  NICHT gegen freiraum_ci: das ist die Vorlage, aus der jeder Klausellauf
#  seine Wegwerfdatenbank klont. Schreibt AC-16 dort hinein, erben alle
#  spaeteren Laeufe die Pruefkonten. Dieses Skript legt eine eigene
#  Datenbank an (freiraum_ac16) und laesst die Vorlage unberuehrt.
# =====================================================================
set -euo pipefail
# BERICHTIGT AM 23.08.2026: hier stand `cd "$(dirname "$0")"`. Das Skript
# landete damit in werkzeuge/ -- und alle Pfade darunter zeigen ins Leere:
#   psql -f pruefungen/klauseln/anmeldecode_daten.sql  ->  werkzeuge/pruefungen/...
#   ./pruefungen/lauf.sh                               ->  werkzeuge/pruefungen/...
# Gemessen am 23.08.2026 beim ersten vollstaendigen Versuch: Durchgang 0 brach
# nach "2/3" ab mit "No such file or directory". Die Wegwerfdatenbank war da
# schon angelegt, der Merker noch nicht geschrieben -- danach meldete `senden`
# "kein Empfaenger vorgemerkt", was wie ein Bedienfehler aussieht und keiner war.
# Gebraucht wird die WURZEL des Bestandes, nicht das Verzeichnis des Skripts.
cd "$(cd "$(dirname "$0")/.." && pwd)"

DB=freiraum_ac16
KOPF="${FREIRAUM_PRUEF_ECHT_MAILKOPF:-$HOME/mailkopf.txt}"
MERKER=".ac16_empfaenger"

# --- Zugang und Prüfstand, in DIESER Shell -----------------------------
export FREIRAUM_SMTP_HOST=mail.bytecamp.net
# GEAENDERT AM 23.08.2026 (BEF-B2-4, Handprobe 3). Bis hierher stand hier
# einladung@zaa.freiraum.top -- der Wert aus B2_Zugangsablage_260806.md.
# Gemessen am zugestellten Kopf: ueber dieses Konto signiert der Anbieter mit
#   d=zaa.freiraum.top   (nicht d=freiraum.top)
# und zaa.freiraum.top hat KEINEN SPF-Eintrag, also
#   Received-SPF: none   (nicht spf=pass).
# AC-16 sucht woertlich nach 'd=freiraum.top' UND 'spf=pass'. Zwei seiner sieben
# Kopfbedingungen koennen ueber dieses Konto also NIE erfuellt werden -- der Lauf
# waere rot geworden, ohne dass am Bau etwas falsch ist.
# Ueber noreply@freiraum.top ist dieselbe Messung zweimal vollstaendig gruen
# (d=freiraum.top, dkim=pass, spf=pass, dmarc=pass).
export FREIRAUM_SMTP_USER=noreply@freiraum.top
export FREIRAUM_SMTP_TLS=1
export FREIRAUM_ECHTVERSAND=ja
export FREIRAUM_PRUEF_ECHT_MAILKOPF="$KOPF"
export PGHOST=localhost PGPORT=55433 PGUSER=postgres PGPASSWORD=pilot
export PGDATABASE="$DB"
export FREIRAUM_CODE_PFEFFER="${FREIRAUM_CODE_PFEFFER:-ac16-pfeffer-fest}"

# Das Kennwort kommt aus dem Schluesselbund und wird nie ausgegeben.
# -a ERGAENZT AM 23.08.2026: ohne Konto liefert find-generic-password den
# ERSTEN Treffer zum Dienstnamen. Liegt der alte Eintrag fuer
# einladung@zaa.freiraum.top noch im Schluesselbund, kaeme dessen Kennwort --
# der Versand scheiterte mit 535, und gesucht wuerde am falschen Ort.
if ! FREIRAUM_SMTP_PASS="$(security find-generic-password -s FREIRAUM_SMTP_PASS -a "$FREIRAUM_SMTP_USER" -w 2>/dev/null)"; then
  echo "ABBRUCH: FREIRAUM_SMTP_PASS nicht im Schluesselbund lesbar." >&2
  echo "  Pruefen mit: security find-generic-password -s FREIRAUM_SMTP_PASS -a $FREIRAUM_SMTP_USER -w >/dev/null && echo da" >&2
  exit 2
fi
export FREIRAUM_SMTP_PASS

empfaenger_lesen() {
  [ -s "$MERKER" ] || { echo "ABBRUCH: kein Empfaenger vorgemerkt. Zuerst: $0 vorbereiten <adresse>" >&2; exit 2; }
  # Getrennt zuweisen: sonst verdeckt export den Rueckgabewert von cat
  # (shellcheck SC2155) -- eine unlesbare Merkerdatei fiele still durch.
  local_empf="$(cat "$MERKER")"
  export FREIRAUM_PRUEF_ECHT_EMPFAENGER="$local_empf"
}

case "${1:-}" in

vorbereiten)
  EMPF="${2:?Aufruf: $0 vorbereiten <adresse@fremder-anbieter>}"
  case "$EMPF" in *@freiraum.top|*@zaa.freiraum.top)
    echo "ABBRUCH: $EMPF liegt in der eigenen Domaene. Der Sinn der Pruefung ist," >&2
    echo "  dass die Mail den eigenen Bereich VERLAESST." >&2
    exit 2 ;;
  esac
  export FREIRAUM_PRUEF_ECHT_EMPFAENGER="$EMPF"

  echo "1/3 · Wegwerfdatenbank $DB aus freiraum_ci"
  psql -d postgres -qc "DROP DATABASE IF EXISTS $DB WITH (FORCE)" >/dev/null
  psql -d postgres -qc "CREATE DATABASE $DB TEMPLATE freiraum_ci" >/dev/null

  echo "2/3 · Pruefdaten einspielen (mit Echtversand-Konto fuer $EMPF)"
  psql -v ON_ERROR_STOP=1 -q -f pruefungen/klauseln/anmeldecode_daten.sql

  printf '%s' "$EMPF" > "$MERKER"
  echo "3/3 · Vorgemerkt. Weiter mit:  $0 senden"
  ;;

senden|pruefen)
  empfaenger_lesen
  [ "$1" = "pruefen" ] && [ ! -s "$KOPF" ] && {
    echo "ABBRUCH: $KOPF ist leer oder fehlt." >&2
    echo "  Erst den Rohkopf der zugestellten Mail dort ablegen:" >&2
    echo "    pbpaste > $KOPF" >&2
    exit 2; }

  # Der Mailfaenger ist Pflicht fuer die uebrigen Faelle dieser Scheibe.
  # AC-16 selbst braucht ihn nicht -- der echte Versand geht an Bytecamp.
  export FREIRAUM_PRUEF_MAILFANG="${FREIRAUM_PRUEF_MAILFANG:-/tmp/ac16_fang.txt}"
  : > "$FREIRAUM_PRUEF_MAILFANG"

  echo "Lauf gegen $DB · Empfaenger $FREIRAUM_PRUEF_ECHT_EMPFAENGER"
  echo "Kopfdatei: $KOPF"
  echo
  set +e
  ./pruefungen/lauf.sh --bericht "$HOME/ac16_$1.json"
  rc=$?
  set -e
  echo
  grep -E '^\s+AC-16' "$HOME/ac16_$1.json" >/dev/null 2>&1 || true
  if [ "$1" = "senden" ]; then
    echo "───────────────────────────────────────────────────────────"
    echo "ERWARTET: AC-16 GESPERRT mit 'Echter Versand ausgeloest'."
    echo "Das ist der ERFOLG dieses Durchgangs, nicht sein Fehlschlag."
    echo
    echo "Jetzt binnen 20 Minuten:"
    echo "  1. Mail bei $FREIRAUM_PRUEF_ECHT_EMPFAENGER oeffnen"
    echo "  2. Rohkopf anzeigen (Gmail: drei Punkte -> Original anzeigen)"
    echo "  3. kopieren, dann:  pbpaste > $KOPF"
    echo "  4. dann:            $0 pruefen"
    echo
    echo "NICHT 'vorbereiten' wiederholen -- das wuerfe den Token weg."
  fi
  exit "$rc"
  ;;

*)
  sed -n '2,20p' "$0" | sed 's/^# \{0,1\}//'
  exit 1 ;;
esac
