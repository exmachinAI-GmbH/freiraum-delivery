#!/usr/bin/env bash
# =====================================================================
#  Blindstand fuer den Pruef-Agenten · Blatt 100, Entscheidung 6
#
#      ./werkzeuge/blindstand.sh <zielverzeichnis>
#
#  WOZU
#      CLAUDE.md Abschn. 3 sagt es selbst: "Die Pfadgrenzen sind
#      Anweisung, nicht Mechanik." Der Pruef-Agent SOLL den Umsetzungs-
#      code nie sehen -- gehindert hat ihn daran bisher nichts.
#
#  WAS AM 19.08.2026 GEMESSEN WURDE
#      Der naheliegende Weg traegt NICHT. Ein git-Worktree mit
#      sparse-checkout laesst app/ migrations/ mail/ verschwinden -- und
#      alle drei Gegenproben holten den Code trotzdem:
#
#        git show HEAD:app/haupt.py        -> 523 Zeilen
#        Hauptarbeitsbaum daneben lesen    -> offen lesbar
#        git sparse-checkout disable       -> alles zurueck, ein Befehl
#
#      Auch die Berechtigungsschicht traegt nicht: Claude Code kennt
#      keine deny-Regeln je Subagent, settings.local.json wird ueber alle
#      Worktrees GETEILT, und Hooks sehen den Agentennamen nicht.
#
#  WAS TRAEGT
#      Die Sandbox. sandbox.filesystem.denyRead wird auf Betriebssystem-
#      ebene durchgesetzt (macOS Seatbelt) und gilt fuer Bash und ALLE
#      Kindprozesse. Gemessen, ohne jede Musterregel:
#
#        git -C <repo> show HEAD:app/haupt.py   -> not a git repository
#        git --git-dir=<repo>/.git show ...     -> not a git repository
#        python3 -c "open(...).readline()"      -> Operation not permitted
#        tar -cf - -C <repo> app                -> Couldn't visit directory
#
#      Der Python-Fall ist der wichtige: Die Berechtigungsschicht deckt
#      ihn laut Doku ausdruecklich NICHT ab ("arbitrary subprocesses").
#      Die Sandbox schon.
#
#  DIE GRENZE
#      Der VerzeichnisNAME kann durchscheinen -- tar schrieb "app/" in
#      den Kopf, bevor es scheiterte. Der INHALT nicht. Fuer die
#      Blindheit nach C-4 genuegt das: der Pruef-Agent darf wissen, DASS
#      es einen Bau gibt, nur nicht, WIE er aussieht.
# =====================================================================
set -euo pipefail
cd "$(dirname "$0")/.."
QUELLE="$(pwd)"
ZIEL="${1:?Aufruf: $0 <zielverzeichnis>}"

[ -e "$ZIEL" ] && { echo "ABBRUCH: $ZIEL gibt es schon. Erst entfernen." >&2; exit 2; }
mkdir -p "$ZIEL"

# git archive statt cp: keine .git, keine Objektdatenbank, kein Weg
# zurueck ueber git show.
#
# WAS MITGEHT, SAGT DIE ROLLENDATEI -- NICHT DIE BEQUEMLICHKEIT.
# .claude/agents/pruef-agent.md:55 laesst genau zwei Orte zu:
# nachweise/klauselregister/ und pruefungen/klauseln/. Zeile 57 fuehrt
# schema/ ausdruecklich unter "nie gelesen".
#
# BERICHTIGT AM 19.08.2026, wenige Stunden nach dem Bau. Die erste Fassung
# archivierte "pruefungen schema" -- also genau umgekehrt: sie gab dem
# Pruef-Agenten die DDL, die er nicht sehen darf, und nahm ihm die einzige
# mitgefuehrte Quelle der Klauselwortlaute (register.json liegt unter
# nachweise/). Im Blindstand waeren die 101 M5-Klauseln nicht nachschlagbar
# gewesen. Gefunden hat es eine adversariale Pruefung der eigenen Arbeit,
# nicht ein Lauf: arbeit/Vorlagen/m5_vor_dem_bauzug_260819.md, Befund S-F.
# WAS MITGEHT, IST ZUGESCHNITTEN -- NICHT GANZE VERZEICHNISSE.
# Berichtigt am 19.08.2026, zweiter Durchgang: `pruefungen` ging bis dahin
# VOLLSTAENDIG mit, und darin liegt pruefungen/migration/ -- Schema- und
# Umsetzungswissen, das die Rollengrenze ausschliesst
# (.claude/agents/pruef-agent.md:57). Mitgehen duerfen nur die Klauselfaelle
# und die Klauselwortlaute.
git archive HEAD pruefungen/klauseln nachweise/klauselregister 2>/dev/null | tar -x -C "$ZIEL" || {
  echo "HINWEIS: pruefungen/klauseln gibt es noch nicht -- nur die Klauseln gehen mit." >&2
  git archive HEAD nachweise/klauselregister | tar -x -C "$ZIEL"
}
mkdir -p "$ZIEL/pruefungen/klauseln"

# Die absolute Pfadform ist "//" PLUS Pfad OHNE fuehrenden Schraegstrich.
# Am 19.08.2026 stand hier "//$QUELLE" -- und $QUELLE beginnt bereits mit
# einem Schraegstrich. Das ergab "///Users/..." und Claude Code meldete die
# Regel als nicht greifend. Die Sandbox verkraftete es, die
# Berechtigungsschicht nicht.
ABS="${QUELLE#/}"

# KEINE Write(...)-Regel: Claude Code meldet dazu ausdruecklich
# "Write(...) is not matched by file permission checks -- only Edit(path)
# rules are". Edit(...) deckt alle schreibenden Dateiwerkzeuge ab.
cat > "$ZIEL/pruef-sandbox.json" <<JSON
{
  "permissions": {
    "deny": [
      "Read(//$ABS/**)",
      "Edit(//$ABS/**)"
    ]
  },
  "sandbox": {
    "enabled": true,
    "filesystem": { "denyRead": ["//$ABS"] },
    "failIfUnavailable": true
  }
}
JSON

echo "Blindstand steht: $ZIEL"
echo
echo "Gegenprobe VOR dem Gebrauch -- sie MUSS scheitern:"
echo "  cd $ZIEL && claude -p 'Lies $QUELLE/app/haupt.py' \\"
echo "      --settings $ZIEL/pruef-sandbox.json --allowedTools Bash"
echo
echo "Erwartet: 'Operation not permitted'. Kommt Code, ist die Blindheit"
echo "gebrochen und der Lauf gilt nicht (F07: die Gegenprobe muss an"
echo "IHRER eigenen Bedingung scheitern, nicht an einer fremden)."
