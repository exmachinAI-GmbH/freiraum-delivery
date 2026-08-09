#!/bin/bash
# =====================================================================
#  Nach dem Umzug in die Organisation — Schritte 2 und 3
#
#  Auszufuehren EINMAL, nachdem exmachinai/freiraum-delivery nach
#  exmachinAI-GmbH/freiraum-delivery uebertragen wurde.
#
#      ./install/nach_umzug.sh            zeigt nur, was es taete
#      ./install/nach_umzug.sh --setzen   fuehrt es aus
#
#  Setzt: Fernadresse, Branch-Schutz auf main mit Tor 1 als Pflichtpruefung,
#  enforce_admins, Pflichtreview mit CODEOWNERS. Damit greift Gate 5 aus K23
#  (keine Selbstfreigabe) mechanisch -- die Voraussetzung, um RR-01 zu
#  schliessen.
#
#  ACHTUNG, damit es niemanden ueberrascht: enforce_admins und
#  require_last_push_approval bedeuten, dass AUCH DER AUFTRAGGEBER nicht an
#  Tor 1 vorbei auf main schreibt und seinen eigenen Zweig nicht selbst
#  freigibt. Genau das ist der Zweck. Es setzt voraus, dass beide Personen
#  Zugang haben -- sonst steht der Bau.
# =====================================================================
set -euo pipefail

ORG=exmachinAI-GmbH
REPO=freiraum-delivery
VOLL="$ORG/$REPO"
TROCKEN=1
[ "${1:-}" = "--setzen" ] && TROCKEN=0

tu() {
  if [ "$TROCKEN" = 1 ]; then echo "   [nur gezeigt] $*"; else "$@"; fi
}

echo "== Vorpruefung =="
if ! gh api "repos/$VOLL" --jq '.owner.login' >/dev/null 2>&1; then
  echo "X  $VOLL nicht erreichbar."
  echo "   Der Umzug ist noch nicht vollzogen. Schritt 1 zuerst:"
  echo "   gh api -X POST repos/exmachinai/$REPO/transfer -f new_owner=$ORG"
  exit 1
fi
echo "OK $VOLL gefunden (Eigentuemer: $(gh api "repos/$VOLL" --jq '.owner.type'))"

echo
echo "== Schritt 2 · Fernadresse nachziehen =="
AKTUELL=$(git remote get-url origin)
NEU="https://github.com/$VOLL.git"
if [ "$AKTUELL" = "$NEU" ]; then
  echo "OK steht bereits auf $NEU"
else
  echo "   $AKTUELL"
  echo "-> $NEU"
  tu git remote set-url origin "$NEU"
fi

echo
echo "== Schritt 3 · Branch-Schutz auf main =="
echo "   Pflichtpruefungen: Tor 1a, Tor 1b, Tor 1c UND die Sperre."
echo "   Alle vier, nicht nur die Sperre: sie laeuft mit if:always() und"
echo "   koennte bei einem uebersprungenen Job gruen melden, ohne dass die"
echo "   drei Messungen stattgefunden haben. Die Namen stammen woertlich aus"
echo "   .github/workflows/tore.yml, Zeilen 42, 118, 222, 268."
echo "   enforce_admins, ein Pflichtreview, CODEOWNERS-Pflicht,"
echo "   letzter Push muss von jemand anderem freigegeben werden,"
echo "   keine Force-Pushes, kein Loeschen von main"
if [ "$TROCKEN" = 1 ]; then
  echo "   [nur gezeigt] gh api -X PUT repos/$VOLL/branches/main/protection ..."
else
  gh api -X PUT "repos/$VOLL/branches/main/protection" --input - <<'JSON'
{
  "required_status_checks": {
    "strict": true,
    "contexts": [
      "Tor 1a · Lint und Geheimnisschranke",
      "Tor 1b · Migration gegen frische Datenbank",
      "Tor 1c · Prueflauf gegen die blinden Prueffaelle",
      "Tor 1 · Sperre"
    ]
  },
  "enforce_admins": true,
  "required_pull_request_reviews": {
    "required_approving_review_count": 1,
    "require_code_owner_reviews": true,
    "require_last_push_approval": true,
    "dismiss_stale_reviews": true
  },
  "restrictions": null,
  "allow_force_pushes": false,
  "allow_deletions": false,
  "required_linear_history": true,
  "required_conversation_resolution": true
}
JSON
  echo "OK gesetzt."
fi

echo
echo "== Nachweis =="
if [ "$TROCKEN" = 1 ]; then
  echo "   [nur gezeigt] gh api repos/$VOLL/branches/main/protection"
else
  gh api "repos/$VOLL/branches/main/protection" \
    --jq '"   enforce_admins: " + (.enforce_admins.enabled|tostring)
        + " · Reviews: " + (.required_pull_request_reviews.required_approving_review_count|tostring)
        + " · CODEOWNERS: " + (.required_pull_request_reviews.require_code_owner_reviews|tostring)
        + " · Force-Push: " + (.allow_force_pushes.enabled|tostring)'
  echo
  echo "   Die Namen der Pflichtpruefungen muessen WOERTLICH den job-Namen in"
  echo "   .github/workflows/tore.yml entsprechen. Stimmen sie nicht, wartet"
  echo "   GitHub auf eine Pruefung, die nie kommt -- und main ist gesperrt,"
  echo "   nicht geschuetzt. Nachsehen: gh run list --limit 1 --json name"
fi

echo
echo "== Danach von Hand =="
echo "   1. A. Han (@AndrewExma) Schreibrecht geben:"
echo "      gh api -X PUT orgs/$ORG/teams/<team>/repos/$VOLL -f permission=push"
echo "      oder ueber die Weboberflaeche als Mitarbeiter aufnehmen"
echo "   2. RR-01 schliessen: nachweise/restrisiken/restrisiken.md"
echo "      -- mit dem Nachweis aus diesem Lauf, nicht mit einer Behauptung"
