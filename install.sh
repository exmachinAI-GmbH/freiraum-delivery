#!/bin/bash
# =====================================================================
#  FREIRAUM Coding-Harness  ·  Einmalige Einrichtung in ~/freiraum-delivery
#
#  Spiegelt Subagenten und Kommandos nach .claude/, legt die Arbeits- und
#  Nachweisordner an und rechnet die Pruefsumme der Anlage "Bauverfahren"
#  gegen den Kopf der CLAUDE.md nach.
#
#      ./install.sh              einrichten und pruefen
#      ./install.sh --pruefsumme nur die Pruefsumme der Anlage nachrechnen
#
#  Die Anlage liegt in der Dropbox, der ausfuehrbare Text hier (C-2, Blatt 26:28).
#  ACHTUNG: Ablageort und Dateiname der Anlage sind NICHT gezeichnet. Der Wert
#  unten ist ein Vorschlag und mit FREIRAUM_ANLAGE zu ueberschreiben.
# =====================================================================
set -euo pipefail
cd "$(dirname "$0")"

ANLAGE="${FREIRAUM_ANLAGE:-$HOME/Library/CloudStorage/Dropbox-exmachinAI/Team-Ordner exmachinAI/02_exmachinAI_GmbH/02_Projekte/01_AEGIRA _AI_TRUST_PLATFORM/50_APPS/30_FREIRAUM/10_KNOWLEDGE_REPO/ITERATION_2/03_AGENT_HARNESS_CODING/30_DELIVERY_HARNESS/Anlage_Bauverfahren.md}"

pruefsumme() {
  if [ ! -f "$ANLAGE" ]; then
    echo "!  Anlage 'Bauverfahren' nicht gefunden:"
    echo "   $ANLAGE"
    echo "   Pruefsumme NICHT nachgerechnet -- Zustand: gesperrt (K23-M22)."
    return 1
  fi
  IST=$(shasum -a 256 "$ANLAGE" | cut -d' ' -f1)
  # Bewusst ohne Umlaut im Suchmuster: 'summe der Anlage' trifft "Pruefsumme"
  # wie "Prüfsumme". Ein Muster mit Umlaut hat in der Vorfassung nie gegriffen.
  SOLL=$(grep -m1 'summe der Anlage' CLAUDE.md | grep -oE '[0-9a-f]{64}' | head -1 || true)
  if [ -z "$SOLL" ]; then
    echo "!  CLAUDE.md fuehrt noch keine Pruefsumme (Platzhalter)."
    echo "   Einzutragen mit der Zeichnung: $IST"
    return 1
  fi
  if [ "$IST" != "$SOLL" ]; then
    echo "X  Pruefsumme weicht ab."
    echo "   Anlage:    $IST"
    echo "   CLAUDE.md: $SOLL"
    echo "   Der ausgefuehrte Text redet ueber eine andere Fassung als der gezeichnete."
    return 1
  fi
  echo "OK Pruefsumme der Anlage stimmt mit dem Kopf der CLAUDE.md ueberein."
}

if [ "${1:-}" = "--pruefsumme" ]; then
  pruefsumme || exit 1
  exit 0
fi

mkdir -p .claude/agents .claude/commands werkzeuge schema \
  arbeit/Plaene arbeit/Bauberichte arbeit/Vorlagen \
  pruefungen/klauseln migrations/negativfaelle \
  nachweise/klauselregister nachweise/manifeste nachweise/restrisiken nachweise/herkunft

if [ -d _claude_setup ]; then
  cp _claude_setup/agents/*.md   .claude/agents/
  cp _claude_setup/commands/*.md .claude/commands/
  echo "OK .claude gespiegelt aus _claude_setup/"
else
  echo "i  kein _claude_setup/ -- .claude/ ist selbst versioniert, nichts gespiegelt"
fi

echo "OK .claude/agents   ($(ls .claude/agents   2>/dev/null | wc -l | tr -d ' ') Agenten)"
echo "OK .claude/commands ($(ls .claude/commands 2>/dev/null | wc -l | tr -d ' ') Kommandos)"

for d in arbeit nachweise pruefungen werkzeuge schema migrations/negativfaelle; do
  [ -f "$d/.gitkeep" ] || : > "$d/.gitkeep"
done

# Commit-Vorlage eintragen. Sie oeffnet sich bei 'git commit' ohne -m im Editor
# und stellt die vier Fragen aus CONTRIBUTING.md -- ohne sie bleibt die
# Sprachvorgabe ein Text, den niemand zum richtigen Zeitpunkt sieht.
# '-e .git' statt 'git rev-parse --git-dir': rev-parse sucht nach OBEN weiter.
# Laege dieser Ordner ohne eigenes .git in einem fremden Git-Arbeitsstand,
# truege rev-parse die Vorlage in DESSEN Konfiguration ein -- dort gibt es keine
# .gitmessage, und jeder 'git commit' des Fremdrepos braeche danach ab.
# '-e' statt '-f', damit 'git worktree' (dort ist .git eine Datei) mit abgedeckt ist.
if [ -f .gitmessage ] && [ -e .git ]; then
  git config commit.template .gitmessage
  echo "OK Commit-Vorlage eingetragen (.gitmessage) -- Vorgabe: CONTRIBUTING.md"
elif [ ! -f .gitmessage ]; then
  echo "!  .gitmessage fehlt -- Commit-Vorlage NICHT eingetragen."
  echo "   Folge: bei 'git commit' steht kein Vorlagentext im Editor."
  echo "   Naechster Schritt: git checkout main -- .gitmessage, dann ./install.sh erneut."
else
  echo "!  Kein eigener Git-Arbeitsstand (kein .git) -- Commit-Vorlage NICHT eingetragen."
  echo "   Vermutlich als ZIP entpackt statt geklont."
  echo "   Naechster Schritt: mit 'git clone' holen und dort ./install.sh ausfuehren."
fi

grep -q '^\.env' .gitignore || { echo "X  .gitignore schuetzt .env nicht -- abgebrochen"; exit 1; }
if git ls-files | grep -qE '(^|/)\.env|\.pem$|\.key$'; then
  echo "X  Geheimnisverdacht im Versionsstand. Einrichtung abgebrochen (K23-D09)."
  exit 1
fi

pruefsumme || echo "   -> /scheibe und /pruefe laufen, melden aber 'Verfassung nicht belegt'."

echo
echo "Start:  claude   -> dann /scheibe 1"
echo "Messen ohne bauen:  /pruefe <Scheibennummer|Klausel|alles>"
