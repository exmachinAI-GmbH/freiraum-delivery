#!/bin/bash
# =====================================================================
#  Negativfaelle zu M31 (Projektnummer und Zweckbestimmung)
#
#  Vier Faelle, und jeder muss an SEINER EIGENEN Bedingung scheitern.
#  Ein Fall, der abgewiesen wird, aber von einer anderen Bedingung, ist
#  ein bestandener Test, der nichts misst -- am 02.08.2026 gemessen, drei
#  von vier (siehe pruefe_negativfaelle.sh, Kopf). Deshalb wird hier nicht
#  nur geprueft, DASS ein Fehler kommt, sondern WELCHER, und der Wortlaut
#  steht in der Ausgabe.
#
#      bash migrations/pruefe_negativfaelle_M31.sh
#
#  Erwartet eine Datenbank mit DDL + M30 + M31. Zugang ueber die
#  ueblichen PG*-Umgebungsvariablen; ohne Angabe die CI-Datenbank aus
#  aufbau.sh --ci.
#
#  Jeder Fall laeuft in einer eigenen Transaktion und rollt zurueck. Er
#  hinterlaesst nichts -- weder eine Anwendung noch einen Mandanten.
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
  aus=$(psql -v ON_ERROR_STOP=0 -f "$datei" 2>&1)
  if ! printf '%s' "$aus" | grep -q "ERROR"; then
    echo "  FEHLGESCHLAGEN  $name — DURCHGELAUFEN, die Bedingung fehlt!"
    fehler=1
    return
  fi
  zeile=$(printf '%s' "$aus" | grep -m1 "ERROR")
  if printf '%s' "$zeile" | grep -q "$erwartet"; then
    echo "  OK   $name"
    echo "       $zeile"
  else
    echo "  WARN $name — abgewiesen, aber NICHT durch \"$erwartet\":"
    echo "       $zeile"
    fehler=1
  fi
}

echo "Negativfaelle zu M31 — jeder an seiner eigenen Bedingung:"
lauf "$HIER/negativfaelle/M31_N1_anlage_ohne_eignung.sql" \
     "der Eignungs-Check steht nicht auf GEEIGNET"
lauf "$HIER/negativfaelle/M31_N2_treffer_frage1_ohne_kenntnisnahme.sql" \
     "die Kenntnisnahme zu Anhang III fehlt"
lauf "$HIER/negativfaelle/M31_N3_treffer_frage2_wird_nicht_weitergefuehrt.sql" \
     "verbotene Praktik nach Art. 5"
lauf "$HIER/negativfaelle/M31_N4_kenntnisnahme_ohne_erklaerung.sql" \
     "ack_braucht_erklaerung"

echo
echo "Gegenprobe — es ist nichts liegengeblieben:"
psql -tAc "SELECT '  Mandanten mit Pruefcode: '||count(*) FROM tenant
            WHERE customer_code LIKE 'DE-QN%';"
psql -tAc "SELECT '  Anwendungen mit Pruefnamen: '||count(*) FROM app
            WHERE name LIKE 'M31-N%';"

exit "$fehler"
