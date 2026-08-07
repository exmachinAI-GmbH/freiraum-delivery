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
# 1 · Die Prueffaelle der Sammelmigration
# ---------------------------------------------------------------------
echo "== Migrationsprueffaelle =="
P=pruefungen/migration/M30__pruefung.sql
if [ ! -f "$P" ]; then
  echo "::error::$P fehlt — GESPERRT"
  merke "M30-Prueffaelle" gesperrt "Datei fehlt"
else
  if aus=$(psql -v ON_ERROR_STOP=1 -f "$P" 2>&1); then
    summe=$(printf '%s\n' "$aus" | sed -n 's/.*SUMME: \(.*\)/\1/p' | head -1)
    echo "   $summe"
    merke "M30-Prueffaelle" bestanden "${summe:-ohne Summenzeile}"
  else
    printf '%s\n' "$aus" | grep -E 'GESCHEITERT|FEHLER|SUMME' | head -20
    echo "::error::Migrationsprueffaelle nicht bestanden"
    merke "M30-Prueffaelle" fehlgeschlagen "$(printf '%s' "$aus" | grep -c 'GESCHEITERT') Fehlschlaege"
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
  erwartet=$(sed -n 's/^-- erwartet: *//p' "$f" | head -1)
  if [ -z "$erwartet" ]; then
    echo "   $kennung — GESPERRT: nennt keine erwartete Bedingung"
    merke "$kennung" gesperrt "keine erwartete Bedingung genannt"
    continue
  fi
  if aus=$(psql -v ON_ERROR_STOP=1 -q -f "$f" 2>&1); then
    echo "   $kennung — DURCHGELAUFEN, die Bedingung fehlt"
    merke "$kennung" fehlgeschlagen "durchgelaufen statt abgewiesen"
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
# ---------------------------------------------------------------------
echo
echo "== Klausel-Prueffaelle =="
anzahl=0
for f in pruefungen/klauseln/*.sql pruefungen/klauseln/*.sh; do anzahl=$((anzahl+1)); done
if [ "$anzahl" -eq 0 ]; then
  echo "   keine vorhanden — GESPERRT, nicht bestanden (K23-M22)"
  echo "   Sie entstehen je Scheibe durch den blinden Pruef-Agenten."
  merke "Klausel-Prueffaelle" gesperrt "noch keine Scheibe gebaut"
else
  echo "   $anzahl Datei(en) — noch nicht angebunden, GESPERRT"
  merke "Klausel-Prueffaelle" gesperrt "$anzahl Datei(en), Anbindung fehlt"
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
echo "Tor 1c: kein Fehlschlag."
