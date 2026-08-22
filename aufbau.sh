#!/bin/bash
# =====================================================================
#  FREIRAUM · Pruefumgebung aufbauen
#
#  Stellt den Pilotstand in rund zwei Minuten her: frische Datenbank,
#  DDL v2.9, Vorlaeufer 260801, Migrationen M30/M31/M32, Seed Welle 1, B1.
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
# ERGAENZT AM 22.08.2026 (Befund A3): Der Pilotpfad lud bis heute DDL,
# Vorlaeufer, M30 und Seed -- M31 und M32 fehlten. Gemessen und benannt in
# arbeit/Bauberichte/m4_messbericht_260816.md:152 ("M31 laeuft gegen
# freiraum-pilot nicht mit. Nur --ci zieht den Glob").
#
# Die Folge war keine Kleinigkeit: `freiraum-pilot` und `freiraum_ci` trugen
# verschiedene Staende derselben Anwendung. M31 ersetzt
# create_app_after_fit(uuid,text,text,uuid,uuid) durch die vierstellige
# Fassung ohne Projektnummer (K01-M38); M32 setzt den Zeilenschutz fuer
# `app`, `document`, `event` und den geprueften Stufenwechsel. Wer gegen die
# Pruefumgebung baute, baute gegen einen Serverbefehl, den es im CI-Stand
# nicht mehr gibt.
#
# REIHENFOLGE: streng aufsteigend nach Kennung, dieselbe Ordnung, die der
# Glob `migrations/*.sql` in --ci und in Messstufe 1b herstellt
# (.github/workflows/tore.yml). M31 setzt auf M30 auf, M32 auf M31 -- eine
# andere Reihenfolge ist keine Variante, sondern ein Fehler.
M31="$HIER/migrations/M31__projektnummer_und_zweckbestimmung.sql"
M32="$HIER/migrations/M32__zeilenschutz_und_stufenwechsel.sql"
SEED="$HIER/seeds/Seed_Welle1_M1-M4.sql"
C=freiraum-pilot

for f in "$DDL" "$VORLAEUFER" "$M30" "$M31" "$M32" "$SEED"; do
  [ -f "$f" ] || { echo "Eingang fehlt: $f"; exit 1; }
done

# Die mitgelieferten Eingaenge gegen ihre Pruefsumme bei Aufnahme nachrechnen.
# Weicht einer ab, ist die Kopie ungueltig -- nicht das Original.
#
# Bewusst formatunabhaengig: schema/freiraum_datamodel.sha256 fuehrt seit dem
# 02.08.2026 nur den nackten Hash, die neueren Dateien das shasum-Format
# "<hash>  <datei>". Wir lesen das erste 64-stellige Hexwort und vergleichen
# selbst, statt eine vorhandene Nachweisdatei umzuschreiben.
#
# GEAENDERT AM 22.08.2026 (Befund A6): Die Zeile lautete hier bis heute
# `[ -f "$summendatei" ] || return 0` -- fehlte die Summendatei, kehrte die
# Pruefung STILL zurueck und der Eingang galt als geprueft. Ein Riegel, der
# schweigt, ist keiner: der Lauf sah genauso aus wie ein Lauf mit lueckenlos
# nachgerechneten Eingaengen, und die Ausgabe unterschied beide nicht.
#
# WARUM ABBRUCH UND NICHT WARNUNG. Drei Gruende, in dieser Reihenfolge:
#   1  K23-M22 -- genau ein Zustand je Pruefung. Was nicht gemessen werden
#      konnte, ist GESPERRT, nicht bestanden. Eine Warnung, nach der der
#      Aufbau weiterlaeuft und am Ende "Fertig" meldet, fuehrt den Lauf als
#      bestanden, obwohl ein Glied der Pruefsummenkette fehlt.
#   2  Die Nachweiskette (CLAUDE.md Abschn. 4, Glied 8) verlangt die
#      Pruefsummen ALLER Eingaben. Eine fehlende Summe ist dort kein
#      kleinerer Mangel als eine abweichende -- in beiden Faellen ist
#      unbelegt, gegen welchen Stand gebaut wurde.
#   3  Die abweichende Summe bricht seit jeher ab (unten, exit 1). Haette
#      die fehlende nur gewarnt, waere der schwaechere Beleg die mildere
#      Folge -- wer die Summendatei loescht, kaeme durch, wer sie pflegt,
#      nicht. Das ist genau die Anreizrichtung, die K23-D05 verbietet.
#
# Gemessen am 22.08.2026: alle sechs Eingaenge dieses Skripts fuehren eine
# Summendatei, der Abbruch trifft heute keinen gueltigen Lauf.
pruefe_eingang() {
  local datei="$1" summendatei="${1%.sql}.sha256" soll ist
  if [ ! -f "$summendatei" ]; then
    echo "X  Pruefsumme fehlt: $summendatei"
    echo "   Eingang: $datei"
    echo "   Ohne hinterlegte Summe ist nicht belegbar, gegen welchen Stand"
    echo "   gebaut wird. Zustand nach K23-M22: gesperrt -- nicht bestanden."
    echo "   Anzulegen mit: shasum -a 256 \"$datei\" | cut -d' ' -f1 > \"$summendatei\""
    exit 1
  fi
  # Das `|| true` ist Pflicht, nicht Bequemlichkeit: findet grep kein Hexwort,
  # gibt es 1 zurueck, und `set -o pipefail` reicht diese 1 durch head hindurch
  # als Wert der ganzen Zuweisung weiter. Unter `set -e` beendet das den Aufbau
  # STILL -- gemessen am 22.08.2026 an einer leeren Summendatei: Rueckgabewert
  # 1, keine einzige Zeile Ausgabe. Genau die Sorte Schweigen, gegen die dieser
  # Riegel gebaut ist. Der leere Wert wird zwei Zeilen tiefer sprechend gemeldet.
  soll=$(grep -oE '[0-9a-f]{64}' "$summendatei" | head -1 || true)
  ist=$(shasum -a 256 "$datei" | cut -d' ' -f1)
  if [ -z "$soll" ]; then
    # Eine Summendatei ohne 64-stelliges Hexwort ist kein Beleg, sondern eine
    # leere Huelle. Ohne diese Klausel verglich das Skript "" gegen den
    # Istwert und meldete eine Abweichung mit leerem Sollwert -- richtig im
    # Ergebnis, irrefuehrend in der Meldung.
    echo "X  Pruefsumme unlesbar: $summendatei"
    echo "   Die Datei enthaelt kein 64-stelliges Hexwort."
    echo "   Zustand nach K23-M22: gesperrt -- nicht bestanden."
    exit 1
  fi
  if [ "$soll" != "$ist" ]; then
    echo "X  Pruefsumme weicht ab: $datei"
    echo "   erwartet: $soll"
    echo "   gemessen: $ist"
    echo "   Die Kopie ist ungueltig -- nicht das Original."
    exit 1
  fi
}
for f in "$DDL" "$VORLAEUFER" "$M30" "$M31" "$M32" "$SEED"; do pruefe_eingang "$f"; done

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

# SCHRITTZAEHLER: seit dem 22.08.2026 acht statt sechs Schritte -- M31 und
# M32 sind je ein eigener Schritt und keine Anhaengsel von M30. Der Grund ist
# die Ablesbarkeit im Fehlerfall: bricht der Aufbau ab, nennt die letzte
# gedruckte Zeile die Migration, an der er abbrach. Waeren die drei
# Migrationen ein Schritt, stuende dort nur "Migrationen" und der Abbruch
# waere nicht zuzuordnen.
echo "1/8 · Datenbank starten"
docker rm -f "$C" >/dev/null 2>&1 || true
docker run -d --name "$C" -e POSTGRES_PASSWORD=pilot -e POSTGRES_DB=freiraum \
  -p 55432:5432 postgres:16 >/dev/null
for _ in $(seq 1 30); do docker exec "$C" pg_isready -U postgres >/dev/null 2>&1 && break; sleep 2; done

lade() { docker cp "$1" "$C:/tmp/x.sql" >/dev/null; docker exec "$C" psql -U postgres -d freiraum -v ON_ERROR_STOP=1 -q -f /tmp/x.sql; }

echo "2/8 · Schema v2.9"
lade "$DDL"
echo "3/8 · Migration 260801 (Vertragsnachweis, Partneraufgabe)"
lade "$VORLAEUFER"
echo "4/8 · Sammelmigration M30 (Pilotstand)"
lade "$M30"
echo "5/8 · M31 · Projektnummer und Zweckbestimmung"
lade "$M31"
echo "6/8 · M32 · Zeilenschutz fuer drei Tabellen und Stufenwechsel"
lade "$M32"
# Der Seed laeuft NACH allen drei Migrationen, nicht zwischen ihnen. Er
# schreibt Wissensbestand (Quellen, Bausteine, Vorlagen, Richtlinien) und
# setzt den vollstaendigen Bedingungsstand voraus -- unter anderem
# lizenz_spdx_form aus M30. Vorgezogen wuerde er gegen ein halbes Schema
# laufen und der Befund BEF-D1 unten waere nicht mehr zuzuordnen.
echo "7/8 · Seed Welle 1"
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
echo "8/8 · B1 · Betreiber-Mandant und Erst-Admin"
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
