#!/bin/bash
# =====================================================================
#  Negativfaelle zu M32 (Zeilenschutz fuer drei Tabellen, Stufenwechsel)
#
#  Vier Faelle, und jeder muss an SEINER EIGENEN Bedingung scheitern.
#  Ein Fall, der abgewiesen wird, aber von einer anderen Bedingung, ist
#  ein bestandener Test, der nichts misst -- am 02.08.2026 gemessen, drei
#  von vier (siehe pruefe_negativfaelle.sh, Kopf). Deshalb wird hier nicht
#  nur geprueft, DASS ein Fehler kommt, sondern WELCHER, und der Wortlaut
#  steht in der Ausgabe.
#
#      bash migrations/pruefe_negativfaelle_M32.sh
#
#  Erwartet eine Datenbank mit DDL + M30 + M31 + M32. Zugang ueber die
#  ueblichen PG*-Umgebungsvariablen; ohne Angabe die CI-Datenbank aus
#  aufbau.sh --ci.
#
#  Jeder Fall laeuft in einer eigenen Transaktion und rollt zurueck. Er
#  hinterlaesst nichts -- weder eine Anwendung noch einen Mandanten.
#
#  ANGELEGT AM 22.08.2026 (Befund A9). Es gab bis dahin einen Runner fuer
#  die Faelle aus dem Pilotstand (pruefe_negativfaelle.sh) und einen fuer
#  M31 -- fuer M32 keinen. Die vier M32-Faelle lagen unter
#  migrations/negativfaelle/ und liefen ausschliesslich im Riegel der
#  Messstufe 1b. Oertlich war der Stand nicht nachzufahren, und wer nicht
#  nachfahren kann, misst nicht, sondern glaubt.
#
#  EINE VORBEDINGUNG, DIE DIESER RUNNER NICHT SELBST HERSTELLEN KANN.
#  M32_N4 misst die Zeilenregel, und die gilt fuer den Eigentuemer nur mit
#  FORCE ROW LEVEL SECURITY -- fuer einen SUPERUSER nie. Der Fall wechselt
#  deshalb selbst auf die Rolle fr_portal (SET LOCAL ROLE, dort Z. 67).
#  Fehlt diese Rolle im Bestand, scheitert er an "role ... does not exist"
#  und wird hier folgerichtig als WARN gefuehrt -- nicht als OK. Das ist
#  gewollt: ein Zeilenschutz, der nur gegen Nicht-Superuser haelt, ist eine
#  Ansage an den Bau, nicht an den Angreifer (M32_N4, Kopf Punkt 2).
# =====================================================================
set -uo pipefail

HIER="$(cd "$(dirname "$0")" && pwd)"
export PGHOST="${PGHOST:-localhost}"
export PGPORT="${PGPORT:-55433}"
export PGUSER="${PGUSER:-postgres}"
export PGDATABASE="${PGDATABASE:-freiraum_ci}"
export PGPASSWORD="${PGPASSWORD:-pilot}"

fehler=0

lauf() {
  datei="$1"; erwartet="$2"
  name="$(basename "$datei" .sql)"
  # Die Datei muss da sein. Ohne diese Klausel liefe psql ins Leere, die
  # Ausgabe enthielte kein "ERROR", und der Fall erschiene als
  # DURCHGELAUFEN -- eine fehlende Datei saehe aus wie eine fehlende
  # Bedingung. Zwei verschiedene Befunde, und sie duerfen nicht dieselbe
  # Meldung tragen.
  if [ ! -f "$datei" ]; then
    echo "  GESPERRT  $name — Datei fehlt: $datei"
    fehler=1
    return
  fi
  aus=$(psql -v ON_ERROR_STOP=0 -f "$datei" 2>&1)
  if ! printf '%s' "$aus" | grep -q "ERROR"; then
    echo "  FEHLGESCHLAGEN  $name — DURCHGELAUFEN, die Bedingung fehlt!"
    fehler=1
    return
  fi
  # Bewusst die ERSTE ERROR-Zeile: nach dem Abbruch meldet psql unter
  # ON_ERROR_STOP=0 jede weitere Anweisung mit "current transaction is
  # aborted". Wer die letzte Zeile pruefte, pruefte die Folge und nicht
  # die Ursache.
  zeile=$(printf '%s' "$aus" | grep -m1 "ERROR")
  if printf '%s' "$zeile" | grep -qF "$erwartet"; then
    echo "  OK   $name"
    echo "       $zeile"
  else
    echo "  WARN $name — abgewiesen, aber NICHT durch \"$erwartet\":"
    echo "       $zeile"
    fehler=1
  fi
}

echo "Negativfaelle zu M32 — jeder an seiner eigenen Bedingung:"
# Die erwarteten Zeichenketten stehen wortgleich in der Zeile
# "-- erwartet:" im Kopf der jeweiligen Datei. Sie sind hier gekuerzt auf
# den Teil, den PostgreSQL im Wortlaut meldet -- verglichen wird mit
# grep -F, damit kein Zeichen der Meldung als Muster gelesen wird.
lauf "$HIER/negativfaelle/M32_N1_stufe_uebersprungen.sql" \
     "STUFENWECHSEL: ORIENTIERUNG nach UEBERSICHT ist kein Uebergang von M5"
lauf "$HIER/negativfaelle/M32_N2_fremder_mandant.sql" \
     "STUFENWECHSEL: das Konto gehoert Mandant"
lauf "$HIER/negativfaelle/M32_N3_ohne_mitgliedschaft.sql" \
     "STUFENWECHSEL: keine Mitgliedschaft im Endnutzer-Portal fuer diesen Mandanten"
lauf "$HIER/negativfaelle/M32_N4_zeilenschutz_haelt.sql" \
     "new row violates row-level security policy"

echo
echo "Gegenprobe — es ist nichts liegengeblieben:"
# Jeder Fall klammert sich in BEGIN/ROLLBACK. Die Gegenprobe glaubt das
# nicht, sondern zaehlt nach: drei Zaehlungen, weil die Faelle drei Sorten
# Zeile anlegen -- Mandant, Konto, Anwendung. Alle drei muessen 0 melden.
psql -tAc "SELECT '  Mandanten mit Pruefcode: '||count(*) FROM tenant
            WHERE customer_code LIKE 'DE-QN%';"
psql -tAc "SELECT '  Konten mit Pruefadresse: '||count(*) FROM actor
            WHERE email LIKE 'm32-n%@pruefung.invalid';"
psql -tAc "SELECT '  Anwendungen mit Pruefnamen: '||count(*) FROM app
            WHERE name LIKE 'M32-N%';"

exit "$fehler"
