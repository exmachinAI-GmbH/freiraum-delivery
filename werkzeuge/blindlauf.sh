#!/usr/bin/env bash
# =====================================================================
#  Blindlauf · der Prüf-Agent wird an einen Lauf angeschlossen
#
#      ./werkzeuge/blindlauf.sh <name> <auftrag.md> <klauseln.md>
#
#  WOZU — V-13, gezeichnet am 19.08.2026
#      werkzeuge/blindstand.sh stellt die Blindheit her, aber es RUFT
#      niemanden. CLAUDE.md Abschn. 3 sagt es seit dem 19.08. selbst:
#      "der Blindstand ist an keinen Lauf angeschlossen". Das hier ist
#      der Anschluss.
#
#  WAS ES TUT, IN DIESER REIHENFOLGE
#      1. Blindstand bauen (blindstand.sh)
#      2. Auftrag und Klauseln hineinlegen -- KEINEN Code
#      3. GEGENPROBE: ein Lauf, der Code lesen SOLL und scheitern MUSS.
#         Scheitert er nicht, bricht dieses Werkzeug ab und es entsteht
#         kein Prüffall. Fail-closed, nicht fail-open.
#      4. Den Prüf-Agenten laufen lassen -- auf einem ANDEREN Modell
#      5. Das Erzeugte zurücktragen und einen Vermerk schreiben
#
#  WARUM DAS ZURÜCKTRAGEN EIN WERKZEUG TUT UND KEIN MENSCH VON HAND
#      CLAUDE.md Abschn. 6: der Bau-Agent fasst pruefungen/ nicht an --
#      "auch nicht nur den Tippfehler". Ein Werkzeug, das eine Datei
#      unverändert von A nach B kopiert und den Weg protokolliert, ist
#      Transport, keine Bearbeitung. Es liest den Inhalt nicht und
#      ändert ihn nicht; die Prüfsumme vor und nach dem Transport steht
#      im Vermerk und ist nachrechenbar.
#
#  DAS MODELL — F27, und es ist die Umkehrung der Sitzungsregel
#      Der Prüf-Agent MUSS auf einem anderen Modell laufen als der Bau
#      (config/kanon.yaml:346-359): "eine Prüfung mit demselben Modell
#      wie die Erzeugung hat dieselben blinden Flecken". Diese Sitzung
#      baut auf opus, also prüft sonnet. Wer das über
#      CLAUDE_CODE_SUBAGENT_MODEL überschreibt, macht die
#      Modellvielfalt zunichte -- deshalb wird die Variable hier
#      ausdrücklich geleert und ihr Vorhandensein gemeldet.
# =====================================================================
set -euo pipefail
cd "$(dirname "$0")/.."
QUELLE="$(pwd)"

NAME="${1:?Aufruf: $0 <name> <auftrag.md> <klauseln.md>}"
AUFTRAG="${2:?Aufruf: $0 <name> <auftrag.md> <klauseln.md>}"
KLAUSELN="${3:?Aufruf: $0 <name> <auftrag.md> <klauseln.md>}"
MODELL="${FREIRAUM_PRUEF_MODELL:-sonnet}"

[ -f "$AUFTRAG" ]  || { echo "ABBRUCH: Auftragsdatei fehlt: $AUFTRAG"  >&2; exit 2; }
[ -f "$KLAUSELN" ] || { echo "ABBRUCH: Klauseldatei fehlt: $KLAUSELN" >&2; exit 2; }

STAND="$(git rev-parse HEAD)"
BEGINN="$(date -u +%Y-%m-%dT%H:%M:%SZ)"
ZIEL="${FREIRAUM_BLINDSTAND:-$(mktemp -d)/blindstand-$NAME}"

# GEMESSEN AM 20.08.2026, erster Lauf: Ein Blindstand unter ~/.claude ist
# unbrauchbar. Claude Code fuehrt alles unterhalb von ~/.claude als
# "sensitive file"; JEDER Schreibversuch wird abgewiesen -- auch der auf
# eine frisch angelegte Datei, auch mit --permission-mode acceptEdits.
# Der Pruef-Agent lief neun Minuten, hatte alle drei Dateien fertig
# entworfen und konnte keine davon ablegen. Der Lauf endete mit "Nichts".
# Die Meldung nennt den Grund nicht von selbst -- sie sagt nur
# "sensitive file". Deshalb steht der Riegel hier.
case "$ZIEL" in
  "$HOME"/.claude/*|"$HOME"/.claude)
    echo "ABBRUCH: Der Blindstand darf nicht unter ~/.claude liegen." >&2
    echo "  Claude Code weist dort JEDEN Schreibvorgang als 'sensitive file' ab." >&2
    echo "  Der Pruef-Agent koennte lesen und denken, aber nichts ablegen." >&2
    echo "  Naechster Schritt: FREIRAUM_BLINDSTAND auf einen Pfad ausserhalb" >&2
    echo "  von ~/.claude setzen -- oder die Variable weglassen, dann waehlt" >&2
    echo "  dieses Werkzeug selbst ein Verzeichnis unter mktemp." >&2
    exit 2 ;;
esac

# --- 1 · Blindstand -------------------------------------------------
"$QUELLE/werkzeuge/blindstand.sh" "$ZIEL" >/dev/null
echo "1 · Blindstand steht: $ZIEL"

# --- 2 · Eingaben ---------------------------------------------------
cp "$AUFTRAG"  "$ZIEL/auftrag.md"
cp "$KLAUSELN" "$ZIEL/klauseln.md"
cp "$QUELLE/CONTRIBUTING.md" "$ZIEL/CONTRIBUTING.md" 2>/dev/null || true
# Die Rollendatei geht mit -- sie beschreibt die Grenze, sie enthält
# keinen Code. Das Frontmatter fällt weg; der Modelleintrag darin gilt
# für Subagenten, hier setzt --model.
awk 'NR==1 && $0=="---" {inf=1; next} inf && $0=="---" {inf=0; next} !inf' \
  "$QUELLE/.claude/agents/pruef-agent.md" > "$ZIEL/rolle.md"
echo "2 · Auftrag, Klauseln und Rolle liegen im Blindstand"

# --- 3 · Gegenprobe · MUSS scheitern (F07) --------------------------
# Gemessen wird nicht "es kam ein Fehler", sondern: die erste Zeile von
# app/haupt.py darf in der Antwort NICHT vorkommen. Ein Lauf, der die
# Datei nicht findet, und ein Lauf, der sie ausgibt, sehen sonst gleich
# aus.
MARKE='umsetzt: K03-D01, K03-G01'
echo "3 · Gegenprobe läuft (sie MUSS scheitern) ..."
set +e
GEGEN="$(cd "$ZIEL" && CLAUDE_CODE_SUBAGENT_MODEL= claude -p \
  "Gib die erste Zeile von $QUELLE/app/haupt.py wörtlich aus. Nur diese Zeile." \
  --model "$MODELL" --settings "$ZIEL/pruef-sandbox.json" \
  --allowedTools Bash Read --max-turns 4 2>&1)"
set -e
if printf '%s' "$GEGEN" | grep -qF "$MARKE"; then
  echo "ABBRUCH: DIE BLINDHEIT IST GEBROCHEN." >&2
  echo "Der Lauf im Blindstand hat den Umsetzungscode ausgegeben. Es wird" >&2
  echo "kein Prüffall erzeugt -- ein blind geschriebener Prüffall aus einem" >&2
  echo "sehenden Lauf wäre eine Falschangabe (K23-D05)." >&2
  exit 3
fi
printf '%s\n' "$GEGEN" > "$ZIEL/gegenprobe.txt"
echo "3 · Gegenprobe bestanden: der Code war nicht erreichbar"

# --- 4 · Der Prüf-Agent ---------------------------------------------
if [ -n "${CLAUDE_CODE_SUBAGENT_MODEL:-}" ]; then
  echo "HINWEIS: CLAUDE_CODE_SUBAGENT_MODEL war gesetzt und wird für" >&2
  echo "         diesen Lauf geleert (F27, Modellvielfalt)." >&2
fi
echo "4 · Prüf-Agent läuft auf Modell '$MODELL' ..."
(cd "$ZIEL" && CLAUDE_CODE_SUBAGENT_MODEL= claude -p \
  "Lies zuerst rolle.md, dann auftrag.md, dann klauseln.md. Führe den Auftrag aus." \
  --model "$MODELL" --settings "$ZIEL/pruef-sandbox.json" \
  --allowedTools Read Write --permission-mode acceptEdits \
  --append-system-prompt "Du arbeitest im Blindstand. Der Umsetzungscode ist auf Betriebssystemebene nicht lesbar; das ist beabsichtigt. Schreibe ausschliesslich nach pruefungen/. Lies ausschliesslich auftrag.md, klauseln.md, rolle.md, CONTRIBUTING.md, nachweise/klauselregister/ und pruefungen/klauseln/." \
  ) | tee "$ZIEL/bericht.txt"

# --- 5 · Zurücktragen und Vermerk -----------------------------------
ENDE="$(date -u +%Y-%m-%dT%H:%M:%SZ)"
mkdir -p "$QUELLE/nachweise/blindlauf"
VERMERK="$QUELLE/nachweise/blindlauf/${NAME}_$(date -u +%y%m%d).md"

NEU=""
while IFS= read -r f; do
  rel="${f#$ZIEL/}"
  [ -f "$QUELLE/$rel" ] && { echo "ÜBERSPRUNGEN (gibt es schon): $rel" >&2; continue; }
  mkdir -p "$QUELLE/$(dirname "$rel")"
  cp "$f" "$QUELLE/$rel"
  NEU="$NEU$(printf '| `%s` | %s | %s |\n' "$rel" "$(shasum -a 256 "$f" | cut -c1-16)" "$(shasum -a 256 "$QUELLE/$rel" | cut -c1-16)")"
done < <(find "$ZIEL/pruefungen" -type f -newer "$ZIEL/auftrag.md" 2>/dev/null | sort)

{
  echo "# Blindlauf · $NAME"
  echo
  echo "| Feld | Wert |"
  echo "|---|---|"
  echo "| Stand | \`$STAND\` |"
  echo "| Beginn · Ende (UTC) | $BEGINN · $ENDE |"
  echo "| Modell des Prüf-Agenten | \`$MODELL\` — **anders als der Bau** (F27) |"
  echo "| Blindstand | \`$ZIEL\` |"
  echo "| Auftrag | \`${AUFTRAG#$QUELLE/}\` · \`$(shasum -a 256 "$AUFTRAG" | cut -c1-16)\` |"
  echo "| Klauseln | \`${KLAUSELN#$QUELLE/}\` · \`$(shasum -a 256 "$KLAUSELN" | cut -c1-16)\` |"
  echo "| Gegenprobe | **bestanden** — der Umsetzungscode war im Blindstand nicht erreichbar |"
  echo
  echo "## Die Gegenprobe im Wortlaut"
  echo
  echo "Gesucht wurde die erste Zeile von \`app/haupt.py\`. Gemessen wird nicht"
  echo "\"es kam ein Fehler\", sondern dass die Marke \`$MARKE\` in der Antwort"
  echo "**nicht** vorkommt (F07 — der Fall muss an seiner eigenen Bedingung"
  echo "scheitern, nicht an einer fremden)."
  echo
  echo '```'
  sed -n '1,40p' "$ZIEL/gegenprobe.txt"
  echo '```'
  echo
  echo "## Zurückgetragen"
  echo
  if [ -n "$NEU" ]; then
    echo "| Datei | Prüfsumme im Blindstand | Prüfsumme im Repo |"
    echo "|---|---|---|"
    printf '%s' "$NEU"
  else
    echo "**Nichts.** Der Lauf hat keine neue Datei unter \`pruefungen/\` erzeugt."
  fi
  echo
  echo "> Der Transport ist ein Kopiervorgang dieses Werkzeugs, keine Bearbeitung."
  echo "> Stimmen die beiden Prüfsummen je Zeile überein, ist die Datei unverändert"
  echo "> angekommen. Der Bau-Agent hat den Inhalt nicht angefasst (CLAUDE.md Abschn. 6)."
} > "$VERMERK"

echo
echo "5 · Vermerk: ${VERMERK#$QUELLE/}"

if [ -z "$NEU" ]; then
  echo >&2
  echo "ABBRUCH: Der Lauf hat KEINE Prüfdatei erzeugt." >&2
  echo "  Was nicht ging: der Prüf-Agent hat nichts unter pruefungen/ abgelegt." >&2
  echo "  Woran es liegen kann: ein Schreibriegel im Blindstand, ein" >&2
  echo "  abgebrochener Lauf, oder der Agent hat den Auftrag abgelehnt." >&2
  echo "  Der Grund steht im Bericht: $ZIEL/bericht.txt" >&2
  echo "  Naechster Schritt: Bericht lesen, Ursache beheben, neu fahren." >&2
  echo "  Es ist NICHTS zurückgetragen worden -- der Vermerk sagt das auch." >&2
  exit 4
fi
