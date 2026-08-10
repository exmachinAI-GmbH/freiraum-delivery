#!/bin/bash
# =====================================================================
#  FREIRAUM · Pruefumgebung aufbauen
#
#  Stellt den Pilotstand in rund zwei Minuten her: frische Datenbank,
#  DDL v2.9, Vorlaeufermigration 260801, Sammelmigration M30, Seed Welle 1, B1.
#
#  GEAENDERT AM 09.08.2026: Das Skript lud bis dahin
#  migrations/260802_anmeldecode.sql -- diese Datei ist beim BEF-C1-Fix nach
#  migrations/_abgeloest/ gewandert, weil M30 sie vollstaendig ersetzt
#  (Entscheidung A. Han, 07.08.2026). Das Skript lief seither ins Leere.
#  Jetzt laeuft M30 an ihrer Stelle.
#
#      ./aufbau.sh              nur Datenbank
#      ./aufbau.sh --mail       zusaetzlich Testempfaenger (Mailpit)
#      ./aufbau.sh --ci         die Datenbank, die Tor 1b und pruefungen/lauf.sh
#                               erwarten: DDL + migrations/*.sql, OHNE Vorlaeufer
#                               und OHNE Seed. Name freiraum_ci, Port 55433.
#
#  WICHTIG: Das hier ist eine PRUEFumgebung, kein Pilotlauf. Der Pilot
#  braucht nach K20-M21 und F36 eine EIGENE, unberuehrte Datenbank --
#  `sealed` ist unumkehrbar, und geloescht wird nichts. Diese Datenbank
#  traegt bereits Testartefakte und darf dafuer nicht wiederverwendet werden.
# =====================================================================
set -euo pipefail

#  Seit 09.08.2026 bringt dieses Skript ALLE Eingaenge selbst mit. Kein Pfad
#  zeigt mehr in die Dropbox: das DDL liegt in schema/, die Vorlaeufermigration
#  in migrations/_vorlaeufer/, der Seed in seeds/ -- je mit .sha256 und
#  Herkunftsvermerk. Grund: ein Lauf gegen eine Quelle, die er nicht selbst
#  mitbringt, ist nicht reproduzierbar (schema/README.md).
HIER="$(cd "$(dirname "$0")" && pwd)"
DDL="$HIER/schema/freiraum_datamodel.sql"
VORLAEUFER="$HIER/migrations/_vorlaeufer/260801_tenant.sql"
M30="$HIER/migrations/M30__pilot_sammelmigration.sql"
SEED="$HIER/seeds/Seed_Welle1_M1-M4.sql"
C=freiraum-pilot

for f in "$DDL" "$VORLAEUFER" "$M30" "$SEED"; do
  [ -f "$f" ] || { echo "Eingang fehlt: $f"; exit 1; }
done

# Die mitgelieferten Eingaenge gegen ihre Pruefsumme bei Aufnahme nachrechnen.
# Weicht einer ab, ist die Kopie ungueltig -- nicht das Original.
#
# Bewusst formatunabhaengig: schema/freiraum_datamodel.sha256 fuehrt seit dem
# 02.08.2026 nur den nackten Hash, die neueren Dateien das shasum-Format
# "<hash>  <datei>". Wir lesen das erste 64-stellige Hexwort und vergleichen
# selbst, statt eine vorhandene Nachweisdatei umzuschreiben.
pruefe_eingang() {
  local datei="$1" summendatei="${1%.sql}.sha256" soll ist
  [ -f "$summendatei" ] || return 0
  soll=$(grep -oE '[0-9a-f]{64}' "$summendatei" | head -1)
  ist=$(shasum -a 256 "$datei" | cut -d' ' -f1)
  if [ "$soll" != "$ist" ]; then
    echo "X  Pruefsumme weicht ab: $datei"
    echo "   erwartet: $soll"
    echo "   gemessen: $ist"
    echo "   Die Kopie ist ungueltig -- nicht das Original."
    exit 1
  fi
}
for f in "$DDL" "$VORLAEUFER" "$M30" "$SEED"; do pruefe_eingang "$f"; done

# --- CI-Fassung ------------------------------------------------------
# Tor 1b und pruefungen/lauf.sh messen gegen eine ANDERE Datenbank als die
# Pruefumgebung unten: freiraum_ci, gebaut aus DDL + migrations/*.sql, ohne
# die Vorlaeufermigration und ohne Seed. Bis zum 09.08.2026 baute sie nur die
# CI selbst -- lokal war Tor 1b nicht nachvollziehbar (Befund BEF-D4).
if [ "${1:-}" = "--ci" ]; then
  CI=freiraum-ci
  echo "CI-Fassung: DDL + migrations/*.sql, ohne Vorlaeufer, ohne Seed"
  docker rm -f "$CI" >/dev/null 2>&1 || true
  docker run -d --name "$CI" -e POSTGRES_PASSWORD=pilot -e POSTGRES_DB=freiraum_ci \
    -p 55433:5432 postgres:16 >/dev/null
  for _ in $(seq 1 30); do docker exec "$CI" pg_isready -U postgres >/dev/null 2>&1 && break; sleep 2; done
  ladeci() { docker cp "$1" "$CI:/tmp/x.sql" >/dev/null; docker exec "$CI" psql -U postgres -d freiraum_ci -v ON_ERROR_STOP=1 -q -f /tmp/x.sql; }
  echo "  Schema v2.9"; ladeci "$DDL"
  for m in "$HIER"/migrations/*.sql; do echo "  $(basename "$m")"; ladeci "$m"; done
  echo
  echo "Fertig. Das ist die Datenbank, die pruefungen/lauf.sh erwartet:"
  # PGPASSWORD gehoert dazu: der Container wird oben mit POSTGRES_PASSWORD=pilot
  # erzeugt, und psql ueber TCP verlangt es. Ohne diese Angabe fragt psql
  # interaktiv nach und der Lauf scheitert an der Anmeldung statt zu messen.
  # Gemessen am 10.08.2026 -- die Zeile war seit dem 09.08. nicht ausfuehrbar.
  echo "  PGHOST=localhost PGPORT=55433 PGUSER=postgres PGDATABASE=freiraum_ci PGPASSWORD=pilot \\"
  echo "    bash pruefungen/lauf.sh"
  echo "  Abbau: docker rm -f $CI"
  exit 0
fi

echo "1/6 · Datenbank starten"
docker rm -f "$C" >/dev/null 2>&1 || true
docker run -d --name "$C" -e POSTGRES_PASSWORD=pilot -e POSTGRES_DB=freiraum \
  -p 55432:5432 postgres:16 >/dev/null
for _ in $(seq 1 30); do docker exec "$C" pg_isready -U postgres >/dev/null 2>&1 && break; sleep 2; done

lade() { docker cp "$1" "$C:/tmp/x.sql" >/dev/null; docker exec "$C" psql -U postgres -d freiraum -v ON_ERROR_STOP=1 -q -f /tmp/x.sql; }

echo "2/6 · Schema v2.9"
lade "$DDL"
echo "3/6 · Migration 260801 (Vertragsnachweis, Partneraufgabe)"
lade "$VORLAEUFER"
echo "4/6 · Sammelmigration M30 (Pilotstand)"
lade "$M30"
echo "5/6 · Seed Welle 1"
SEED_ZUSTAND=bestanden
if ! seed_aus=$(lade "$SEED" 2>&1); then
  SEED_ZUSTAND=gesperrt
  echo "   ! Seed Welle 1 laeuft gegen M30 NICHT durch -- Befund BEF-D1."
  printf '     %s\n' "$(printf '%s' "$seed_aus" | grep -m1 'ERROR:' || echo 'siehe Ausgabe oben')"
  echo "     Der Seed stammt vom 02.08.2026 und schreibt Lizenzen in Prosa;"
  echo "     M30 (04.08.2026) verlangt seither SPDX-Schreibweise"
  echo "     (Bedingung lizenz_spdx_form, M30 Z. 1265-1269)."
  echo "     Zu beheben ist das ORIGINAL in der Konzept-Fabrik, nicht die"
  echo "     Kopie hier (seeds/README.md, Aenderungsregel: keine)."
  echo "     Zustand nach K23-M22: gesperrt -- nicht bestanden."
fi
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

if [ "$SEED_ZUSTAND" != bestanden ]; then
  echo
  echo "  ZUSTAND: UNVOLLSTAENDIG -- Schema und Migrationen stehen, der Seed nicht."
  echo "  Wer gegen diese Datenbank prueft, prueft ohne Wissensbestand."
  echo "  Befund BEF-D1 · nachweise/befunde/BEF-D_260809.md"
  exit 1
fi
