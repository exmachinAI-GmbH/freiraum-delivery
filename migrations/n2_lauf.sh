#!/usr/bin/env bash
# =====================================================================
# N2 · Der Abnahmelauf — ein Befehl, fuenf Belege, ein vorgefuellter Nachweis
# =====================================================================
#
#   ./n2_lauf.sh "<verbindung>" [zielordner]
#
#   <verbindung>   psql-Verbindung zur ZIELUMGEBUNG, z. B.
#                  "host=... dbname=freiraum user=... password=..."
#                  Fuer eine Probe vor dem echten Lauf genuegt eine frische
#                  lokale Datenbank -- der Nachweis vermerkt dann selbst,
#                  dass es keine Zielumgebung war.
#   [zielordner]   Ablage der Belege; Vorgabe: ./n2_belege_<datum>
#
# WAS DAS SKRIPT TUT (die fuenf Belege aus 00_N2_WAS_A.HAN_VORLEGEN_MUSS.md):
#   1  Migration einspielen, danach ein zweites Mal; nach jedem Lauf ZWEI
#      Dumps -- Schema und Daten. Beide diffs muessen leer sein. (Bis zum
#      5.8.2026 verglich das Skript nur das Schema und der Bauauftrag sprach
#      trotzdem vom "vollen Dump" -- Befund B04 des Auftragsreviews.)
#   2  M30__pruefung.sql -- vollstaendige Ausgabe, Summenzeile muss
#      null Fehlschlaege melden (die Zahl waechst; die Regel nicht)
#   3  jede Meldung:-Zeile der Gegentests einzeln in einer Datei
#   4  die eingefrorenen Prueffaelle T0-T23 (pruefung_v2.9.sql, in EINER
#      Transaktion; T22/T23 brauchen das neue Setup und laufen gesondert)
#   5  Objektzahlen der Zielumgebung messen -- fuer kanon.yaml, der erst
#      DANACH nachgezogen wird (F6)
#
# WAS ES NICHT TUT: zeichnen. Der Nachweis am Ende traegt die gemessenen
# Pruefsummen und leere Unterschriftsfelder. Ein Skript, das unterschreibt,
# haette den Sinn der Unterschrift nicht verstanden.
#
# BRICHT EIN SCHRITT AB, ENDET DER LAUF DORT. Ein Nachweis ueber vier von
# fuenf Pruefungen ist keiner.
set -euo pipefail

VERBINDUNG="${1:?Verbindung zur Zielumgebung angeben}"
HIER="$(cd "$(dirname "$0")" && pwd)"
STAND="$(date +%y%m%d_%H%M)"
ZIEL="${2:-$HIER/n2_belege_$STAND}"
mkdir -p "$ZIEL"

MIG="$HIER/M30__pilot_sammelmigration.sql"

# DIE MIGRATIONSKETTE, seit dem 20.08.2026 -- Entscheidung "Umfang von M1: B",
# gezeichnet am 20.08.2026 (arbeit/Vorlagen/m1_startklar_260820.md, Punkt 2).
#
# WARUM NICHT M30 ALLEIN, wie es die Rangfolge zunaechst nahelegt: Die
# Prueffaelle MT-95, MT-95b und MT-98 sind am 16.08.2026 im SELBEN Commit
# (ab46289) entstanden wie M31 und pruefen `create_app_after_fit` OHNE den
# Parameter p_project_no -- also genau den Zustand, den erst M31 herstellt.
# Gemessen am 20.08. gegen eine Wegwerfdatenbank mit M30 allein:
# "SUMME: 108 von 111 bestanden, 3 gescheitert". Ein Zustand, der seine
# eigene Pruefdatei nie bestanden haette, ist kein Massstab.
#
# WAS DAMIT MITGEZEICHNET IST: CLAUDE.md Rang 1 nennt als autoritatives
# Zielschema "eingefrorene Basis + M30". Der Zielbestand ist mit dieser
# Entscheidung Basis + M30 + M31 + M32. Das ist eine FORTSCHREIBUNG des
# Zielschemas und gehoert in den N2-Nachweis -- sonst redet der Beleg ueber
# eine andere Fassung als die eingespielte.
#
# Uebersteuerbar: MIGRATIONEN="M30__... M31__... " ./n2_lauf.sh ...
if [ -n "${MIGRATIONEN:-}" ]; then
  KETTE=""
  for m in $MIGRATIONEN; do
    case "$m" in /*) KETTE="$KETTE $m" ;; *) KETTE="$KETTE $HIER/$m" ;; esac
  done
else
  KETTE="$MIG $HIER/M31__projektnummer_und_zweckbestimmung.sql $HIER/M32__zeilenschutz_und_stufenwechsel.sql"
fi

# BERICHTIGT AM 20.08.2026. Hier stand "$HIER/M30__pruefung.sql" -- also
# migrations/M30__pruefung.sql. DIESE DATEI GIBT ES NICHT; die Prueffaelle
# liegen unter pruefungen/migration/. Das Skript waere an seiner eigenen
# Vollstaendigkeitspruefung abgebrochen ("Datei nicht gefunden"), und zwar
# ERST in dem Augenblick, in dem der Zugang zur Zielumgebung endlich da ist.
# Uebersteuerbar wie ALT und GRUND, damit die Belege auch auf einem Rechner
# ohne das volle Repo erzeugt werden koennen.
TST="${TST_DATEI:-$HIER/../pruefungen/migration/M30__pruefung.sql}"

# Uebersteuerbar (z. B. wenn die Belege auf einem Rechner ohne das volle
# Repo erzeugt werden): ALT_DATEI=/pfad/zur/pruefung_v2.9.sql ./n2_lauf.sh ...
#
# BERICHTIGT AM 20.08.2026: Die Vorgabe zeigte sechs Ebenen nach oben in die
# Konzept-Fabrik. Seit dem 09.08. bringt das Repo alle Bau-Eingaben selbst
# mit -- pruefung_v2.9.sql liegt unter schema/. Der alte Pfad bleibt als
# zweite Wahl stehen, falls jemand ausserhalb des Repos faehrt.
if [ -z "${ALT_DATEI:-}" ] && [ -f "$HIER/../schema/pruefung_v2.9.sql" ]; then
  ALT_DATEI="$HIER/../schema/pruefung_v2.9.sql"
fi
ALT="${ALT_DATEI:-$HIER/../../../../../../01_KNOWLEDGE_REPO/v2.9_PIVOT/pruefung_v2.9.sql}"
# Das Grundschema v2.9. M30 baut DARAUF auf -- ohne es scheitert schon die
# erste Anweisung an `type "retention_class" does not exist`. Bis zum
# 5.8.2026 abends sagte das Skript das nirgends und pruefte es nicht: der
# Lauf gegen eine frische Datenbank brach sofort ab, ohne dass die Meldung
# den Grund nannte. Gefunden, indem das Skript ausgefuehrt wurde -- nicht,
# indem es gelesen wurde.
# Dieselbe Berichtigung wie bei ALT: das Grundschema liegt im Repo.
if [ -z "${GRUND_DATEI:-}" ] && [ -f "$HIER/../schema/freiraum_datamodel.sql" ]; then
  GRUND_DATEI="$HIER/../schema/freiraum_datamodel.sql"
fi
GRUND="${GRUND_DATEI:-$HIER/../../../../../../01_KNOWLEDGE_REPO/v2.9_PIVOT/freiraum_datamodel.sql}"

for datei in $KETTE "$TST" "$ALT" "$GRUND"; do
  [ -f "$datei" ] || { echo "ABBRUCH: Datei nicht gefunden: $datei"; echo "         ALT_DATEI= bzw. GRUND_DATEI= setzen."; exit 1; }
done

sagen() { printf '\n=== %s ===\n' "$1"; }
# ON_ERROR_STOP=1 fuer JEDEN Lauf -- auch fuer die Prueffaelle.
#
# Am 5.8.2026 stand hier zunaechst eine Begruendung, warum das bei den
# Prueffaellen NICHT gehe: die eingefrorenen Faelle erzeugten Fehler als
# Methode (ein UPDATE, das scheitern muss), ein Abbruch beim ersten
# Gegentest waere die Folge. Diese Begruendung ist GEMESSEN WORDEN und war
# falsch: beide Dateien fangen ihre Ausnahmen selbst ab -- M30__pruefung.sql
# in DO-Bloecken, pruefung_v2.9.sql ueber Sicherungspunkte. Unter
# ON_ERROR_STOP=1 laufen beide sauber durch (108 von 108; 22 von 22
# T-Zeilen). Der vierte Lauf des Auftragsreviews hatte schlicht recht.
P() { psql "$VERBINDUNG" -v ON_ERROR_STOP=1 "$@"; }

# Ersetzt das fruehere `|| true`: der Rueckgabewert wird ausgewertet, nicht
# weggeworfen -- und er BRICHT AB. Die Vollstaendigkeitspruefungen weiter
# unten bleiben daneben bestehen, weil sie einen anderen Fall fangen: einen
# Lauf, der mit Rueckgabewert 0 endet und trotzdem Faelle ausgelassen hat.
lauf_pruefen() {
  local rc="$1" log="$2" was="$3"
  printf '%s: psql-Rueckgabewert %s\n' "$was" "$rc" | tee -a "$ZIEL/rueckgabewerte.txt"
  if [ "$rc" -ne 0 ]; then
    echo "ABBRUCH: $was endete mit Rueckgabewert $rc -- siehe $log"; exit 1
  fi
}

sagen "Beleg 0 · Grundschema v2.9 (Vorbedingung von M30)"
# Idempotent gedacht: Steht der Typ schon, war das Grundschema da; dann wird
# nichts erneut geladen. So bleibt der Lauf auf einer vorbereiteten
# Zielumgebung genauso richtig wie auf einer frischen Datenbank.
vorhanden=$(psql "$VERBINDUNG" -tA -c "SELECT count(*) FROM pg_type WHERE typname='retention_class'")
if [ "$vorhanden" = "0" ]; then
  echo "leere Datenbank -- Grundschema wird geladen: $GRUND"
  set +e
  psql "$VERBINDUNG" -q -v ON_ERROR_STOP=1 -f "$GRUND" 2>&1 | tee "$ZIEL/lauf0_grundschema.log"
  rc=${PIPESTATUS[0]}
  set -e
  [ "$rc" -eq 0 ] || { echo "ABBRUCH: Grundschema endete mit Rueckgabewert $rc -- $ZIEL/lauf0_grundschema.log"; exit 1; }
else
  echo "Grundschema ist bereits vorhanden -- nichts geladen."
fi

sagen "Beleg 1 · Migration zweimal, Schema-Vergleich"
# Der Rueckgabewert von psql entscheidet, nicht ein Textmuster. Bis zum
# 5.8.2026 stand hier "| grep -ciE ... && { exit 1; } || true" -- und das
# `|| true` machte einen gescheiterten Lauf wieder erfolgreich, sobald die
# Meldung nicht auf das englische Muster passte (dritter Lauf des
# Auftragsreviews). PIPESTATUS liest den Wert des ersten Gliedes.
set +e
for m in $KETTE; do
  echo "--- $(basename "$m") ---"
  psql "$VERBINDUNG" -q -v ON_ERROR_STOP=1 -f "$m" 2>&1
done | tee "$ZIEL/lauf1.log"
rc=${PIPESTATUS[0]}
set -e
if [ "$rc" -ne 0 ]; then
  echo "ABBRUCH: Lauf 1 endete mit Rueckgabewert $rc -- siehe $ZIEL/lauf1.log"; exit 1
fi
if grep -qiE "^psql.*(error|FEHLER)" "$ZIEL/lauf1.log"; then
  echo "ABBRUCH: Lauf 1 meldet Fehler im Protokoll -- siehe $ZIEL/lauf1.log"; exit 1
fi
pg_dump --schema-only "$VERBINDUNG" | grep -vE "^\\\\(un)?restrict" > "$ZIEL/schema_nach_lauf1.sql"
pg_dump --data-only --column-inserts "$VERBINDUNG" | grep -vE "^\\\\(un)?restrict" | LC_ALL=C sort > "$ZIEL/daten_nach_lauf1.sql"
set +e
for m in $KETTE; do
  echo "--- $(basename "$m") ---"
  psql "$VERBINDUNG" -q -v ON_ERROR_STOP=1 -f "$m" 2>&1
done | tee "$ZIEL/lauf2.log"
rc=${PIPESTATUS[0]}
set -e
if [ "$rc" -ne 0 ]; then
  echo "ABBRUCH: Lauf 2 endete mit Rueckgabewert $rc -- siehe $ZIEL/lauf2.log"; exit 1
fi
if grep -qiE "^psql.*(error|FEHLER)" "$ZIEL/lauf2.log"; then
  echo "ABBRUCH: Lauf 2 meldet Fehler im Protokoll -- siehe $ZIEL/lauf2.log"; exit 1
fi
pg_dump --schema-only "$VERBINDUNG" | grep -vE "^\\\\(un)?restrict" > "$ZIEL/schema_nach_lauf2.sql"
pg_dump --data-only --column-inserts "$VERBINDUNG" | grep -vE "^\\\\(un)?restrict" | LC_ALL=C sort > "$ZIEL/daten_nach_lauf2.sql"
if ! diff "$ZIEL/schema_nach_lauf1.sql" "$ZIEL/schema_nach_lauf2.sql" > "$ZIEL/schema_diff.txt"; then
  echo "ABBRUCH: der zweite Lauf hat das SCHEMA geaendert -- $ZIEL/schema_diff.txt"; exit 1
fi
# Daten getrennt: Eine Migration kann schemagleich sein und trotzdem beim
# zweiten Lauf Zeilen einfuegen. Genau das faellt sonst niemandem auf.
if ! diff "$ZIEL/daten_nach_lauf1.sql" "$ZIEL/daten_nach_lauf2.sql" > "$ZIEL/daten_diff.txt"; then
  echo "ABBRUCH: der zweite Lauf hat DATEN geaendert -- $ZIEL/daten_diff.txt"; exit 1
fi
echo "beide diffs leer -- Schema und Daten idempotent."

sagen "Beleg 2 und 3 · Prueffaelle und Gegentest-Meldungen"
set +e; P -f "$TST" > "$ZIEL/pruefung_ausgabe.log" 2>&1; rc=$?; set -e
lauf_pruefen "$rc" "$ZIEL/pruefung_ausgabe.log" "Prueffaelle M30"
# Ohne die explizite Pruefung starb das Skript hier wortlos: grep faende
# nichts, pipefail beendete den Lauf ohne Meldung. In der Negativprobe vom
# 5.8.2026 war genau das der Fall -- Rueckgabewert 1, kein Wort dazu.
grep -oE "SUMME: [0-9]+ von [0-9]+ bestanden.*" "$ZIEL/pruefung_ausgabe.log" | tail -1 > "$ZIEL/summe.txt" || true
if [ ! -s "$ZIEL/summe.txt" ]; then
  echo "ABBRUCH: keine Summenzeile in der Ausgabe -- der Lauf ist unvollstaendig geblieben."
  echo "         siehe $ZIEL/pruefung_ausgabe.log"; exit 1
fi
cat "$ZIEL/summe.txt"
# Kein fest verdrahteter Sollwert: Die Zahl waechst mit jedem neuen Fall,
# und eine Zahl im Skript veraltet stiller als eine Regel. Gefordert ist,
# dass KEIN Fall scheitert -- und dass ueberhaupt welche gelaufen sind.
grep -q "SUMME: .* 0 gescheitert" "$ZIEL/summe.txt" \
  || { echo "ABBRUCH: es sind Prueffaelle gescheitert -- siehe $ZIEL/pruefung_ausgabe.log"; exit 1; }
n_faelle=$(grep -oE "SUMME: [0-9]+" "$ZIEL/summe.txt" | grep -oE "[0-9]+" || echo 0)
[ "$n_faelle" -ge 100 ] \
  || { echo "ABBRUCH: nur $n_faelle Prueffaelle gelaufen -- erwartet mindestens 100"; exit 1; }
echo "$n_faelle Prueffaelle, keiner gescheitert."
grep -oE "MT-[0-9]+ · [A-Z* ]+ — .*" "$ZIEL/pruefung_ausgabe.log" > "$ZIEL/gegentest_meldungen.txt"
echo "$(wc -l < "$ZIEL/gegentest_meldungen.txt" | tr -d ' ') Meldungszeilen festgehalten."

sagen "Beleg 4 · Eingefrorene Prueffaelle T0-T23"
set +e; P -1 -f "$ALT" > "$ZIEL/t0_t23_ausgabe.log" 2>&1; rc=$?; set -e
lauf_pruefen "$rc" "$ZIEL/t0_t23_ausgabe.log" "Eingefrorene Faelle T0-T21"
grep -E "^T[0-9]+" "$ZIEL/t0_t23_ausgabe.log" | awk -F'|' '{print ($2==$3?"OK      ":"ABWEICHT")" "$0}' \
  | tee "$ZIEL/t0_t23_ergebnis.txt"
if grep -q "ABWEICHT" "$ZIEL/t0_t23_ergebnis.txt"; then
  echo "ABBRUCH: ein eingefrorener Fall weicht ab."; exit 1
fi
# Vollstaendigkeit, nicht nur Fehlerfreiheit: T0 bis T21 muessen JE GENAU
# EINMAL dastehen. Vorher genuegte "keine Abweichung" -- ein Fall, der gar
# nicht lief, fiel damit nicht auf (dritter Lauf des Auftragsreviews).
for i in $(seq 0 21); do
  n=$(grep -cE "T${i}[^0-9]" "$ZIEL/t0_t23_ergebnis.txt" || true)
  if [ "$n" -ne 1 ]; then
    echo "ABBRUCH: T${i} kommt ${n}-mal vor, erwartet genau einmal -- $ZIEL/t0_t23_ergebnis.txt"
    exit 1
  fi
done
echo "T0 bis T21: je genau ein Ergebnis, keine Abweichung."
# T22/T23 · Das Setup der Altdatei kollidiert mit der Anlegeregel W01
# (README.md). Bis zum 5.8.2026 legte dieser Block nur zwei Zeilen an und
# meldete "Setup-Ersatz protokolliert" -- er FUEHRTE die Faelle nicht aus,
# und der Bauauftrag nannte sie trotzdem bestanden (Befund B05). Jetzt
# laufen sie wirklich; koennen sie nicht laufen, steht das da.
set +e
P -tA > "$ZIEL/t22_t23_ausgabe.log" 2>&1 <<'SQL'
BEGIN;
INSERT INTO tenant(id,kind,name,customer_code,legal_space,invite_domain)
  VALUES ('22222222-2222-2222-2222-222222222222','CUSTOMER','Nordfracht','DE-NOF','DE','nordfracht.de')
  ON CONFLICT (id) DO NOTHING;
INSERT INTO fit_check(id,tenant_id,outcome,completed_at)
  VALUES ('cccccccc-0000-0000-0000-000000000001','22222222-2222-2222-2222-222222222222','GEEIGNET',now())
  ON CONFLICT (id) DO NOTHING;
-- Ersatz-Setup nach README: entsteht auf DISCOVERY (W01), dann Wechsel.
INSERT INTO app(id,tenant_id,project_no,name,journey_phase,fit_check_id,created_at)
  VALUES ('dddddddd-0000-0000-0000-000000000001','22222222-2222-2222-2222-222222222222',
          'DE-NOF_001_26','Eingangsrechnungen','ANGEBOT',
          'cccccccc-0000-0000-0000-000000000001',DATE '2026-03-02')
  ON CONFLICT (id) DO NOTHING;
UPDATE app SET lifecycle_state='IN_BEARBEITUNG'
  WHERE id='dddddddd-0000-0000-0000-000000000001';

-- T22 muss an ack_needs_seal scheitern, nicht an irgendetwas. Der
-- Ausnahmezweig liest die Meldung und meldet den Fall nur dann als
-- erwartet, wenn sie die vorgesehene Bedingung nennt (Massstab F07).
DO $t22$ BEGIN
  UPDATE app SET mitbestimmung_ack_at = now()
    WHERE id='dddddddd-0000-0000-0000-000000000001';
  RAISE NOTICE '%', 'T22 Bestaetigung ohne Siegel|Fehler|akzeptiert';
EXCEPTION WHEN others THEN
  IF SQLERRM LIKE '%ack_needs_seal%' THEN
    RAISE NOTICE '%', 'T22 Bestaetigung ohne Siegel|Fehler|Fehler';
  ELSE
    RAISE NOTICE '%', 'T22 Bestaetigung ohne Siegel|Fehler|falsche Regel: '||SQLERRM;
  END IF;
END $t22$;

UPDATE app SET sealed_at = now(), mitbestimmung_ack_at = now()
  WHERE id='dddddddd-0000-0000-0000-000000000001';
SELECT 'T23 Bestaetigung mit Siegel|1|' || count(*)::text
  FROM app WHERE mitbestimmung_ack_at IS NOT NULL
   AND id='dddddddd-0000-0000-0000-000000000001';
ROLLBACK;
SQL
rc=$?; set -e
lauf_pruefen "$rc" "$ZIEL/t22_t23_ausgabe.log" "Ersatz-Setup T22/T23"
grep -oE "T2[23] [^|]*\|[^|]*\|.*" "$ZIEL/t22_t23_ausgabe.log" | awk -F'|' '{print ($2==$3?"OK      ":"ABWEICHT")" "$0}' \
  | tee "$ZIEL/t22_t23_ergebnis.txt"
# Genau zwei Zeilen, je eine je Fall. Vorher genuegte "nicht leer" -- damit
# haette die vorhandene T22-Zeile allein das Tor passiert, auch wenn T23 gar
# nicht gelaufen waere (zweites Auftragsreview, Befund B05).
n_t22=$(grep -c "T22 " "$ZIEL/t22_t23_ergebnis.txt" || true)
n_t23=$(grep -c "T23 " "$ZIEL/t22_t23_ergebnis.txt" || true)
if [ "$n_t22" -ne 1 ] || [ "$n_t23" -ne 1 ]; then
  echo "ABBRUCH: erwartet je ein Ergebnis fuer T22 und T23, gefunden T22=$n_t22 T23=$n_t23"
  echo "         -- $ZIEL/t22_t23_ausgabe.log"; exit 1
fi
if grep -q "ABWEICHT" "$ZIEL/t22_t23_ergebnis.txt"; then
  echo "ABBRUCH: T22 oder T23 weicht ab."; exit 1
fi
if grep -q "falsche Regel" "$ZIEL/t22_t23_ergebnis.txt"; then
  echo "ABBRUCH: T22 ist an einer anderen Regel gescheitert als ack_needs_seal (F07)."; exit 1
fi
echo "T22/T23 mit Ersatz-Setup ausgefuehrt und bestanden."

sagen "Beleg 5 · Objektzahlen der Zielumgebung (fuer kanon.yaml -- erst danach, F6)"
P -tA <<'SQL' | tee "$ZIEL/objektzahlen.txt"
SELECT 'tabellen '  || count(*) FROM information_schema.tables  WHERE table_schema='public' AND table_type='BASE TABLE';
SELECT 'sichten '   || count(*) FROM information_schema.views   WHERE table_schema='public';
SELECT 'trigger '   || count(*) FROM pg_trigger WHERE NOT tgisinternal;
SELECT 'funktionen '|| count(*) || ' davon_mit_suchpfad ' || count(*) FILTER (WHERE proconfig IS NOT NULL)
  FROM pg_proc p JOIN pg_namespace n ON n.oid=p.pronamespace
 WHERE n.nspname='public' AND NOT EXISTS (SELECT 1 FROM pg_depend d WHERE d.objid=p.oid AND d.deptype='e');
SELECT 'enums '     || count(DISTINCT t.typname) FROM pg_type t JOIN pg_enum e ON e.enumtypid=t.oid;
SELECT 'rollen '    || count(*) FROM pg_roles WHERE rolname LIKE 'fr\_%';
SQL

sagen "Nachweis vorbefuellen"
H_MIG=$(for m in $KETTE; do shasum -a 256 "$m"; done | shasum -a 256 | cut -d' ' -f1)
# Eine Pruefsumme UEBER DIE KETTE, nicht ueber M30 allein -- sonst behauptet
# der Nachweis einen Zielbestand, der nicht der eingespielte ist.
H_TST=$(shasum -a 256 "$TST" | cut -d' ' -f1)
cat > "$ZIEL/ABNAHMENACHWEIS_ENTWURF.md" <<NACHWEIS
# N2 · Abnahmenachweis der Sammelmigration — ENTWURF, ungezeichnet

| Feld | Wert |
|---|---|
| Lauf am | $(date '+%d.%m.%Y %H:%M') |
| Umgebung | **VON A. HAN EINZUTRAGEN** — Host/Instanz; war es die Zielumgebung? |
| M30__pilot_sammelmigration.sql SHA-256 | \`$H_MIG\` |
| M30__pruefung.sql SHA-256 | \`$H_TST\` |

## Welche Pruefungen bestanden wurden

| | Pruefung | Ergebnis | Beleg |
|---|---|---|---|
| 1 | Migration zweimal, **Schema und Daten** unveraendert | beide diffs leer | \`schema_diff.txt\` · \`daten_diff.txt\` |
| 2 | Prueffaelle | $(cat "$ZIEL/summe.txt") | \`pruefung_ausgabe.log\` |
| 3 | Gegentests an der vorgesehenen Regel (F07) | $(wc -l < "$ZIEL/gegentest_meldungen.txt" | tr -d ' ') Meldungen einzeln | \`gegentest_meldungen.txt\` — **von A. Han durchzusehen, nicht nur zu zaehlen** |
| 4 | Eingefrorene Faelle T0–T21 **und T22/T23 mit Ersatz-Setup** | alle OK | \`t0_t23_ergebnis.txt\` · \`t22_t23_ergebnis.txt\` |
| 5 | Objektzahlen gemessen | $(tr '\n' ' · ' < "$ZIEL/objektzahlen.txt") | \`objektzahlen.txt\` — kanon.yaml **erst jetzt** nachziehen (F6) |

## Wer gezeichnet hat

| Name | Datum | Unterschrift |
|---|---|---|
| A. Han |  |  |

> Dieses Blatt ist ein ENTWURF aus \`n2_lauf.sh\`. Es traegt Messwerte, keine
> Unterschrift — die setzt allein A. Han, nachdem er Beleg 3 gelesen hat.
> Danach nimmt M. Veil ab (N2 im Blatt *Zeichnungen und Abnahmen*).
NACHWEIS

sagen "FERTIG"
echo "Belege in: $ZIEL"
echo "Naechster Schritt: gegentest_meldungen.txt lesen, Umgebung eintragen, zeichnen."
