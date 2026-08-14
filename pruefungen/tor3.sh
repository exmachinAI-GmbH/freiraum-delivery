#!/usr/bin/env bash
# =====================================================================
# FREIRAUM Coding-Harness · Tor 3 — der fremde Blick
#
# ACHTUNG, das Wichtigste zuerst: dieses Skript FORDERT KEIN REVIEW AN
# und schreibt keines. `.claude/commands/scheibe.md`:73 im Wortlaut:
# "Der Harness schreibt dieses Review nie selbst."
#
# Es prueft den NACHWEIS, dass ein Fremdmodell geprueft hat -- nicht das
# Urteil. Ein Werkzeug, das ein Fremdurteil bewertet, waere wieder der
# eigene Blick und damit genau das, wogegen Tor 3 gebaut ist.
#
# NICHT je Aenderung. C-4 (Blatt 26:30, gezeichnet): "Das Fremdmodell
# kommt einmal je Scheibenabnahme, nicht je Aenderung." Ein Gate, das bei
# jedem Commit anschlaegt, wird umgangen oder billig erfuellt -- beides
# schlechter als kein Gate.
#
# Aufruf:
#   pruefungen/tor3.sh [scheibe]
#
# Rueckgabewerte:
#   0  bestanden -- ein vollstaendiges, gezeichnetes, pruefsummiertes Blatt
#   1  gesperrt oder fehlgeschlagen
#   2  Aufruf- oder Umgebungsfehler
# =====================================================================
set -euo pipefail

wurzel="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
cd "$wurzel"

scheibe="${1:-}"

echo "== Tor 3 · der fremde Blick"
echo "   Der Nachweis wird geprueft, nicht das Urteil."
echo

if ! command -v python3 >/dev/null 2>&1; then
  echo "::error::python3 fehlt -- Tor 3 GESPERRT (K23-M22)."
  echo "Ein Lauf, der nicht messen kann, meldet GESPERRT -- nie gruen."
  exit 2
fi

if [ ! -d nachweise/fremdreview ]; then
  echo "::error::nachweise/fremdreview/ fehlt -- Tor 3 GESPERRT."
  exit 2
fi

ergebnis=0
if [ -n "$scheibe" ]; then
  python3 werkzeuge/fremdreview.py --scheibe "$scheibe" || ergebnis=$?
else
  python3 werkzeuge/fremdreview.py || ergebnis=$?
fi

echo
if [ "$ergebnis" -eq 0 ]; then
  echo "Tor 3 bestanden. Tor 4 ist der Mensch und laeuft nie automatisch."
else
  echo "Tor 3 sperrt."
  echo "Ein fehlendes Fremdreview ist KEIN bestandenes (K23-M22):"
  echo "  bestanden · fehlgeschlagen · gesperrt · nicht ausgefuehrt"
  echo "sind vier Zustaende, nicht zwei."
fi
exit "$ergebnis"
