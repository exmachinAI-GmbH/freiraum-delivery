#!/bin/bash
# =====================================================================
#  FREIRAUM · Pruefumgebung aufbauen
#
#  Stellt den am 02.08.2026 verifizierten Stand in rund zwei Minuten her:
#  frische Datenbank, DDL v2.9, beide Migrationen, Seed Welle 1, B1.
#
#      ./aufbau.sh              nur Datenbank
#      ./aufbau.sh --mail       zusaetzlich Testempfaenger (Mailpit)
#
#  WICHTIG: Das hier ist eine PRUEFumgebung, kein Pilotlauf. Der Pilot
#  braucht nach K20-M21 und F36 eine EIGENE, unberuehrte Datenbank --
#  `sealed` ist unumkehrbar, und geloescht wird nichts. Diese Datenbank
#  traegt bereits Testartefakte und darf dafuer nicht wiederverwendet werden.
# =====================================================================
set -euo pipefail

KONZEPTE="${FREIRAUM_KONZEPTE:-$HOME/Library/CloudStorage/Dropbox-exmachinAI/Team-Ordner exmachinAI/02_exmachinAI_GmbH/02_Projekte/01_AEGIRA _AI_TRUST_PLATFORM/50_APPS/30_FREIRAUM/10_KNOWLEDGE_REPO/ITERATION_2}"
DDL="$KONZEPTE/01_KNOWLEDGE_REPO/v2.9_PIVOT/freiraum_datamodel.sql"
ARBEIT="$KONZEPTE/02_AGENT_HARNESS_KONZEPTE/ITERATION_2/arbeit"
HIER="$(cd "$(dirname "$0")" && pwd)"
C=freiraum-pilot

[ -f "$DDL" ] || { echo "DDL nicht gefunden: $DDL"; exit 1; }

echo "1/6 · Datenbank starten"
docker rm -f "$C" >/dev/null 2>&1 || true
docker run -d --name "$C" -e POSTGRES_PASSWORD=pilot -e POSTGRES_DB=freiraum \
  -p 55432:5432 postgres:16 >/dev/null
for _ in $(seq 1 30); do docker exec "$C" pg_isready -U postgres >/dev/null 2>&1 && break; sleep 2; done

lade() { docker cp "$1" "$C:/tmp/x.sql" >/dev/null; docker exec "$C" psql -U postgres -d freiraum -v ON_ERROR_STOP=1 -q -f /tmp/x.sql; }

echo "2/6 · Schema v2.9"
lade "$DDL"
echo "3/6 · Migration 260801 (Vertragsnachweis, Partneraufgabe)"
lade "$ARBEIT/Migration_260801_tenant.sql"
echo "4/6 · Migration 260802 (Anmeldecode, Zustellnachweis) — Vorschlag"
lade "$HIER/migrations/260802_anmeldecode.sql"
echo "5/6 · Seed Welle 1"
lade "$ARBEIT/Seed_Welle1_M1-M4.sql"
echo "6/6 · B1 · Betreiber-Mandant und Erst-Admin"
docker cp "$HIER/install/01_betreiber_und_erstadmin.sql" "$C:/tmp/b1.sql" >/dev/null
docker exec "$C" psql -U postgres -d freiraum -v ON_ERROR_STOP=1 -q \
  -v admin_email="${FREIRAUM_ADMIN_MAIL:-michael.veil@exmachinai.com}" \
  -v admin_name="${FREIRAUM_ADMIN_NAME:-Michael Veil}" -f /tmp/b1.sql >/dev/null

if [ "${1:-}" = "--mail" ]; then
  echo "     Testempfaenger (Mailpit auf :8025)"
  docker rm -f freiraum-mail >/dev/null 2>&1 || true
  docker run -d --name freiraum-mail -p 8025:8025 -p 1025:1025 axllent/mailpit >/dev/null
fi

echo
echo "Fertig. Kontrolle:"
docker exec "$C" psql -U postgres -d freiraum -tAc "
  select '  aktive Plattform-Admins: '||count(*) from platform_admin where status='AKTIV';
  select '  Quellen: '||count(*)||' · Bausteine: '||(select count(*) from knowledge_module)
       ||' · Vorlagen: '||(select count(*) from template)
       ||' · Richtlinien: '||(select count(*) from policy) from knowledge_source;"
echo
echo "  DSN: postgresql://postgres:pilot@localhost:55432/freiraum"
echo "  Abbau: docker rm -f $C freiraum-mail"
