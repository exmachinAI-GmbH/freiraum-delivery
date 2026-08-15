#!/usr/bin/env bash
# =====================================================================
# FREIRAUM · ZWEI DAUERMESSUNGEN AM BESTAND · Kunden-Code am Mandanten
# Angelegt am 16.08.2026 (Auftrag 10.6)
#
# Geschrieben gegen K02 "Fundament" v1.3 und schema/freiraum_datamodel.sql
# -- NICHT gegen den Umsetzungscode. Die beiden gezeichneten Klauseln im
# WORTLAUT, weil beide Messungen sie zitieren und nicht umformulieren:
#
#   K02-G02  "Es GILT: Der Kunden-Code ist nur bei der Art Kunde
#             Pflicht. Betreiber und Partner bestehen ohne ihn."
#
#   K02-M25  "Der Kunden-Code MUSS fortlaufend von der Plattform
#             vergeben werden. Der erste lautet `DE-AAA`; jeder weitere
#             ist der naechste freie Code der alphabetischen Folge."
#
# ---------------------------------------------------------------------
# DIE ZWEI MESSUNGEN
# ---------------------------------------------------------------------
#   MC-01  ZAEHLDIFFERENZ (K02-M25). Wieviele Kunden-Codes sind
#          vergeben, und wieviele Plaetze umspannen sie? Bei einer
#          fortlaufenden Vergabe ab `DE-AAA` sind beide Zahlen gleich.
#          Die Differenz ist die Zahl der uebersprungenen Plaetze. Sie
#          ist die eine Zahl, an der man sieht, ob eine Vergabe
#          fortlaufend WAR -- ein einzelner Code sagt das nie.
#          SEIT 16.08.2026 MELDET MC-01 GESPERRT statt eines Ergebnisses,
#          solange BEF-G1 offen ist: die Vergabe ist nicht gebaut, also
#          misst die Rechnung die Buchstabenwahl der Pruefdaten. Die
#          Zahl wird trotzdem gerechnet und in der Sperrmeldung genannt.
#          Der volle Grund steht im Kopf des MC-01-Blocks.
#
#   MC-02  ZUORDNUNGSTREUE (K02-G02). Traegt jeder Kunde einen Code,
#          und traegt KEIN Betreiber und KEIN Partner einen? Beide
#          Haelften zusammen -- eine Messung, die nur die erste liest,
#          misst ein Vorkommen statt einer Unterscheidung.
#
# ---------------------------------------------------------------------
# WAS DIESE ZWEI VON EINEM PRUEFFALL UNTERSCHEIDET
# ---------------------------------------------------------------------
# Sie stellen sich ihre Lage NICHT selbst her. mandantencode_daten.sql
# legt keinen einzigen Mandanten an. Gemessen wird der BESTAND, so wie
# er ist -- jeden Lauf neu. Wer die Codes selbst schreibt, die er
# hinterher misst, misst seine eigene Hand.
#
# ---------------------------------------------------------------------
# OHNE NEUE DATENBANKBEDINGUNG
# ---------------------------------------------------------------------
# Es wird kein CHECK, kein Trigger, keine Regel und kein eindeutiger
# Index angelegt. Beide Messungen sind Abfragen. Eine Bedingung
# verhindert, eine Messung zeigt -- und nur das Zeigen findet, was
# schon da ist.
#
# ---------------------------------------------------------------------
# AUCH CODES AUF UNBEKANNTEM WEG
# ---------------------------------------------------------------------
# Gelesen wird die Tabelle `tenant` vollstaendig: kein Verbund mit einem
# Nachweis, kein Filter auf eine Herkunft, kein Filter auf `deleted_at`.
# Ein Code, der ohne jeden Vorgang unmittelbar in die Zeile geschrieben
# wurde, steht darum genauso in der Messung wie einer aus dem regulaeren
# Weg.
#
# ---------------------------------------------------------------------
# WORAN MAN SIEHT, DASS BEIDE SCHEITERN KOENNEN -- DIE SELBSTPROBE
# ---------------------------------------------------------------------
# Eine Messung am Bestand hat eine Schwaeche, die ein Prueffall nicht
# hat: Ist der Bestand sauber, meldet sie "in Ordnung" -- und meldet
# dasselbe, wenn sie kaputt ist und gar nichts sieht. Genau dieser
# Fehler ist am 02.08.2026 und noch einmal am 15.08.2026 aufgetreten:
# bestandene Faelle, die nichts gemessen haben.
#
# Beide Messungen fuehren darum eine SELBSTPROBE: In einer Transaktion,
# die am Ende ZURUECKGEROLLT wird, wird ein Verstoss GEPFLANZT und die
# Messung darauf wiederholt. Findet sie den gepflanzten Verstoss nicht,
# ist die Messung untauglich -- der Fall meldet dann GESCHEITERT, nicht
# bestanden. Danach wird geprueft, dass der Bestand nach dem Ruecklauf
# unveraendert ist; sonst hat die Probe den Bestand beschaedigt.
#
# Die Selbstprobe von MC-02 pflanzt einen PARTNER, der einen Kunden-Code
# traegt. Das ist der schaerfste Nachweis, den es hier gibt: KEINE
# vorhandene Datenbankbedingung verhindert diese Zeile --
# `customer_needs_code` bindet nur die Art Kunde, `customer_code_fmt`
# ist erfuellt. Nur die MESSUNG findet sie. Damit ist zugleich belegt,
# dass sie Codes auf unbekanntem Weg findet.
#
# Aufruf:
#   psql ... -f pruefungen/klauseln/mandantencode_daten.sql     # Lesegrundlage
#   pruefungen/klauseln/mandantencode_lauf.sh                   # Messungen
#
# Umgebung:
#   PGHOST/PGPORT/PGUSER/PGPASSWORD/PGDATABASE
#       Vorgabe localhost/55433/postgres/pilot/freiraum_pruef
#   FREIRAUM_PRUEF_URL  wird NICHT gebraucht: beide Messungen lesen den
#       Bestand, nicht eine Tuer. Ein laufender Server ist fuer sie
#       weder Vorbedingung noch Gegenstand.
#
# MASSSTAB F07: Traegt die Lesegrundlage nicht, bricht der Lauf mit
# Rueckgabewert 2 ab (ABBRUCH), statt Ergebnisse zu melden, die niemand
# tragen kann. Was nicht gemessen werden konnte, ist GESPERRT und nicht
# bestanden (K23-M22).
# =====================================================================

: "${PGHOST:=localhost}"
: "${PGPORT:=55433}"
: "${PGUSER:=postgres}"
: "${PGPASSWORD:=pilot}"
: "${PGDATABASE:=freiraum_pruef}"
export PGHOST PGPORT PGUSER PGPASSWORD PGDATABASE

ARBEIT="$(mktemp -d "${TMPDIR:-/tmp}/freiraum_mandantencode.XXXXXX")"
trap 'rm -rf "$ARBEIT"' EXIT

gesamt=0; bestanden=0; gescheitert=0; gesperrt=0

ok()  { gesamt=$((gesamt+1)); bestanden=$((bestanden+1))
        printf '%-7s BESTANDEN    %s\n' "$1" "$2"; }
nok() { gesamt=$((gesamt+1)); gescheitert=$((gescheitert+1))
        printf '%-7s GESCHEITERT  %s\n' "$1" "$(printf '%s' "$2" | tr '\n' ' ')"; }
# K23-M22: Was nicht gemessen werden konnte, ist GESPERRT -- nicht
# bestanden. In der Summe zaehlt es zu den gescheiterten Faellen, denn
# ein Lauf, der nichts gemessen hat, ist kein gruener Lauf.
sperr() { gesamt=$((gesamt+1)); gescheitert=$((gescheitert+1)); gesperrt=$((gesperrt+1))
        printf '%-7s GESPERRT     %s\n' "$1" "$(printf '%s' "$2" | tr '\n' ' ')"; }

abbruch() { printf 'ABBRUCH: %s\n' "$1"; printf 'SUMME: 0 von 0 bestanden, 0 gescheitert\n'; exit 2; }

# Haertung wie in den uebrigen Dateien dieses Ordners (dort am
# 14.08.2026 nachgetragen): Schlaegt die SQL fehl, bleibt stdout leer --
# ein "[ -z ... ]"-Test liest das sonst als "alles in Ordnung". Bei
# einem Fehler gibt dbz() NICHTS auf stdout aus, schreibt den psql-Text
# nach stderr und legt die Markierungsdatei an. pruefe_sql_marke()
# prueft sie in der ELTERNSCHALE -- nur dort wirkt exit.
dbz() { local aus
        if ! aus="$(psql -X -tAq -v ON_ERROR_STOP=1 -c "$1" 2>"$ARBEIT/psql.fehler")"; then
          local fehlertext
          fehlertext="SQL gescheitert: $(tr '\n' ' ' <"$ARBEIT/psql.fehler")"
          printf '%s\n' "$fehlertext" >&2
          printf '%s\n' "$fehlertext" > "$ARBEIT/sql.marke"
          return 1
        fi
        [ -n "$aus" ] || return 0
        printf '%s\n' "$aus" | head -1; }

pruefe_sql_marke() {
  if [ -s "$ARBEIT/sql.marke" ]; then
    abbruch "$(cat "$ARBEIT/sql.marke")"
  fi
}

# Fuer die Selbstprobe: mehrere Anweisungen in EINER Sitzung, mit
# BEGIN ... ROLLBACK. Sie darf scheitern, ohne den Lauf abzubrechen --
# ein gescheiterter Ruecklauf ist ein Befund der Probe, kein Abbruch.
# Ruehrt die Markierungsdatei darum NICHT an.
#   Rueckgabewert 0 = durchgelaufen, 1 = gescheitert
db_probe() {
  local aus rc
  if aus="$(psql -X -tAq -v ON_ERROR_STOP=1 -c "$1" 2>&1)"; then rc=0; else rc=1; fi
  printf '%s' "$(printf '%s' "$aus" | tr '\n' ' ' | sed 's/  */ /g')"
  return "$rc"
}

# ---------------------------------------------------------------------
# Die beiden Messformeln. Sie stehen GENAU EINMAL hier und werden von
# der Messung am Bestand UND von der Selbstprobe wortgleich benutzt.
# Zwei Fassungen derselben Formel waeren zwei Wahrheiten -- die Probe
# koennte dann eine Messung bestaetigen, die so nie gelaufen ist.
# ---------------------------------------------------------------------
# MC-01: vergeben|erster_platz|letzter_platz|zaehldifferenz|erster_code
MESSUNG_A="SELECT count(*)::text || '|' ||
                  coalesce(min(platz)::text, '-') || '|' ||
                  coalesce(max(platz)::text, '-') || '|' ||
                  coalesce(((max(platz) - min(platz) + 1) - count(*))::text, '-') || '|' ||
                  coalesce(min(code), '-')
             FROM pruef_mandantencode_lage"

# MC-02: kunde_ohne_code|fremde_art_mit_code|code_doppelt|format_fremd|liste
MESSUNG_B="SELECT (SELECT count(*) FROM tenant WHERE kind = 'CUSTOMER' AND customer_code IS NULL)::text || '|' ||
                  (SELECT count(*) FROM tenant WHERE kind <> 'CUSTOMER' AND customer_code IS NOT NULL)::text || '|' ||
                  (SELECT count(*) FROM (SELECT customer_code FROM tenant
                                          WHERE customer_code IS NOT NULL
                                          GROUP BY customer_code HAVING count(*) > 1) d)::text || '|' ||
                  (SELECT count(*) FROM pruef_mandantencode_lage WHERE NOT formatgerecht)::text || '|' ||
                  coalesce((SELECT string_agg(art || ':' || code, ' ' ORDER BY code)
                              FROM pruef_mandantencode_lage WHERE art <> 'CUSTOMER'), '-')"

feld() { printf '%s' "$1" | cut -d'|' -f"$2"; }

# ---------------------------------------------------------------------
# Vorpruefung
# ---------------------------------------------------------------------
command -v psql >/dev/null 2>&1 || abbruch 'psql fehlt.'

dbz 'SELECT 1' >/dev/null || abbruch "Datenbank $PGDATABASE auf $PGHOST:$PGPORT nicht erreichbar."
pruefe_sql_marke

sicht="$(dbz "SELECT count(*) FROM pg_views WHERE viewname='pruef_mandantencode_lage'")"
pruefe_sql_marke
[ "$sicht" = "1" ] || abbruch 'Lesesicht pruef_mandantencode_lage fehlt -- mandantencode_daten.sql zuerst einspielen.'

# Die Rechnung an ihren Eckpunkten noch einmal HIER, unmittelbar vor der
# Messung. mandantencode_daten.sql prueft sie beim Einspielen; zwischen
# Einspielen und Lauf kann eine andere Datei sie ueberschrieben haben.
# Rechnet sie falsch, meldet MC-01 Luecken, die es nicht gibt.
rechnung="$(dbz "SELECT string_agg(m, ' ') FROM (
  SELECT 'codeplatz(DE-AAA)=' || coalesce(pruef_codeplatz('DE-AAA')::text,'null') AS m WHERE pruef_codeplatz('DE-AAA') IS DISTINCT FROM 0
  UNION ALL
  SELECT 'codeplatz(DE-BBB)=' || coalesce(pruef_codeplatz('DE-BBB')::text,'null') AS m WHERE pruef_codeplatz('DE-BBB') IS DISTINCT FROM 703
  UNION ALL
  SELECT 'codeplatz(DE-ZZZ)=' || coalesce(pruef_codeplatz('DE-ZZZ')::text,'null') AS m WHERE pruef_codeplatz('DE-ZZZ') IS DISTINCT FROM 17575
  UNION ALL
  SELECT 'codename(703)=' || coalesce(pruef_codename(703),'null') AS m WHERE pruef_codename(703) IS DISTINCT FROM 'DE-BBB'
) t")"
pruefe_sql_marke
[ -z "$rechnung" ] || abbruch "Die Buchstabenrechnung stimmt nicht ($rechnung) -- ohne sie ist keine Folge nachzaehlbar."

printf 'FREIRAUM · Dauermessungen am Bestand — Kunden-Code am Mandanten\n'
printf 'Bestand: %s auf %s:%s · es wurde KEIN Mandant angelegt · Aufbaupruefung (F07) bestanden\n\n' \
       "$PGDATABASE" "$PGHOST" "$PGPORT"

# =====================================================================
# MC-01 · ZAEHLDIFFERENZ · K02-M25
#
#   "Der Kunden-Code MUSS fortlaufend von der Plattform vergeben werden.
#    Der erste lautet `DE-AAA`; jeder weitere ist der naechste freie
#    Code der alphabetischen Folge."
#
# GEMESSEN WIRD EINE UNTERSCHEIDUNG, KEIN VORKOMMEN: Nicht, OB ein Code
# dasteht und ob er wie `DE-XXX` aussieht -- das taeten alle Codes immer.
# Gemessen wird die Differenz zwischen der ANZAHL der vergebenen Codes
# und der WEITE der Folge, die sie umspannen. Bei fortlaufender Vergabe
# ab DE-AAA sind beide gleich; jeder uebersprungene Platz macht die
# Differenz groesser. Genau diese Unterscheidung fehlte am 02.08.2026,
# als drei Negativfaelle an einer Formatpruefung des Kundencodes
# scheiterten statt an der Zielbedingung.
#
# DREI TEILE, ALLE DREI MUESSEN TRAGEN:
#   (1) Der erste vergebene Code ist DE-AAA.
#   (2) Die Zaehldifferenz ist null -- kein Platz uebersprungen.
#   (3) SELBSTPROBE: eine gepflanzte Luecke wird gefunden, und der
#       Bestand ist nach dem Ruecklauf unveraendert.
#
# ---------------------------------------------------------------------
# NACHGETRAGEN AM 16.08.2026 · SOLANGE BEF-G1 OFFEN IST: GESPERRT
# ---------------------------------------------------------------------
# BEF-G1 (nachweise/befunde/BEF-G_260815.md) stellt fest -- gemessen,
# nicht behauptet: "Die Vergabe der Kunden-Codes ist ueberhaupt nicht
# gebaut." Keine Zeile des Programmtextes vergibt einen Kunden-Code; die
# Codes, die MC-01 im Bestand vorfindet, hat jemand von Hand
# eingetragen (18 setzende Stellen, alle in Pruefbestaenden und
# Negativfaellen, keine einzige rechnet einen Code aus).
#
# Was MC-01 dann rechnerisch misst, ist die Buchstabenwahl der
# Pruefdaten -- nicht die Vergabe nach K02-M25. Und weil es den Vorgang
# nicht gibt, kann KEINE Aenderung am Bau diesen Fall gruen machen:
# er waere gruen oder rot je nachdem, welche Codes die Startbestaende
# zufaellig tragen. Ein Fall, dessen Ergebnis nicht von der geprueften
# Sache abhaengt, hat nichts gemessen.
#
# K23-M22 kennt dafuer einen eigenen Zustand: bestanden · fehlgeschlagen
# · GESPERRT · nicht ausgefuehrt. Gesperrt heisst "konnte nicht gemessen
# werden" -- weder bestanden noch durchgefallen. Genau das ist die Lage.
#
# WAS SICH DADURCH NICHT AENDERT -- K23-D05 ("Ein Pruefwert DARF NICHT
# gesenkt werden, damit ein Lauf besteht"):
#   * Die Zaehldifferenz wird UNVERAENDERT weitergerechnet, samt
#     Selbstprobe, und steht im Wortlaut in der Sperrmeldung. Ab dem Tag
#     der Vergabe misst sie ohne jede Anpassung weiter.
#   * GESPERRT zaehlt in dieser Datei zu den gescheiterten Faellen
#     (siehe sperr() oben). Der Lauf wird dadurch NICHT gruen.
#   * Ein untaugliches Messwerkzeug (gescheiterte Selbstprobe,
#     beschaedigter Bestand) bleibt GESCHEITERT -- es wird NICHT von der
#     Sperre verdeckt. Die Sperre gilt nur der Aussage ueber die
#     Vergabe, nicht der Tauglichkeit der Messung.
#
# ZURUECKZUSTELLEN, SOBALD BEF-G1 GESCHLOSSEN IST: BEFUND_G1_OFFEN=0
# setzen. MC-01 meldet dann wieder GESCHEITERT bzw. BESTANDEN nach dem
# gemessenen Befund. Die Zeile darunter ist die einzige Stellschraube;
# an den Messformeln und an den Schwellen ist nichts zu aendern.
# =====================================================================
BEFUND_G1_OFFEN=1
BEFUND_G1_WORTLAUT="BEF-G1 (15.08.2026, nachweise/befunde/BEF-G_260815.md): 'Die Vergabe der Kunden-Codes ist ueberhaupt nicht gebaut. Keine einzige Zeile im Programmtext vergibt einen Kunden-Code.' Gemessen ueber 9506 Zeilen Programmtext; alle 18 setzenden Stellen tragen einen von Hand ausgedachten Code ein. Solange kein Vorgang einen Code VERGIBT, misst diese Zaehldifferenz die Buchstabenwahl der Pruefdaten und nicht K02-M25 -- und keine Aenderung am Bau kann sie gruen machen. Nach K23-M22 ist das GESPERRT (konnte nicht gemessen werden), nicht GESCHEITERT"
a_bestand="$(dbz "$MESSUNG_A")"
pruefe_sql_marke
a_vergeben="$(feld "$a_bestand" 1)"
a_von="$(feld "$a_bestand" 2)"
a_bis="$(feld "$a_bestand" 3)"
a_diff="$(feld "$a_bestand" 4)"
a_erster="$(feld "$a_bestand" 5)"

if [ "${a_vergeben:-0}" = "0" ]; then
  sperr MC-01 "Zaehldifferenz nicht messbar: im Bestand traegt kein einziger Mandant einen Kunden-Code. Eine Folge von null Gliedern ist weder fortlaufend noch unterbrochen -- gemessen wurde nichts (K23-M22)"
elif [ "${a_bis:--}" = "-" ] || [ "$((a_bis + 3))" -gt 17575 ]; then
  sperr MC-01 "Zaehldifferenz nicht pruefbar: der hoechste belegte Platz ist '$a_bis'; die Selbstprobe braucht drei freie Plaetze darueber und kann hier nicht pflanzen. Ohne Selbstprobe ist nicht belegt, dass die Messung ueberhaupt etwas findet"
else
  m=""
  befund=""

  # --- (3) ZUERST die Selbstprobe: taugt das Messwerkzeug? ----------
  #     Zuerst, weil ein Befund am Bestand nur zaehlt, wenn das
  #     Werkzeug beweisbar misst. Gepflanzt wird ein Kunde auf Platz
  #     (hoechster + 2) -- der Platz dazwischen bleibt frei, die
  #     Zaehldifferenz MUSS also um genau eins wachsen.
  a_pflanzplatz=$((a_bis + 2))
  a_probe="$(db_probe "BEGIN;
    INSERT INTO tenant (kind, name, customer_code, legal_space)
    VALUES ('CUSTOMER', 'Selbstprobe Zaehldifferenz', pruef_codename($a_pflanzplatz), 'DE');
    $MESSUNG_A;
    ROLLBACK;")" && a_prc=0 || a_prc=1

  if [ "$a_prc" != "0" ]; then
    m="$m die Selbstprobe lief nicht durch -- ob die Messung ueberhaupt etwas findet, ist damit unbelegt. Beobachtet: '$a_probe';"
  else
    a_probe_diff="$(feld "$a_probe" 4)"
    a_erwartet=$((a_diff + 1))
    [ "${a_probe_diff:--}" = "$a_erwartet" ] \
      || m="$m die Messung findet eine GEPFLANZTE Luecke nicht: nach dem Pflanzen eines Kunden auf Platz $a_pflanzplatz (Platz $((a_bis + 1)) bleibt frei) muesste die Zaehldifferenz $a_erwartet betragen, gemessen wurde '${a_probe_diff:-nichts}'. Eine Messung, die einen gepflanzten Verstoss nicht sieht, misst nichts;"
  fi

  # --- Nach dem Ruecklauf: der Bestand muss unveraendert sein -------
  a_danach="$(dbz "$MESSUNG_A")"
  pruefe_sql_marke
  [ "$a_danach" = "$a_bestand" ] \
    || m="$m die Selbstprobe hat den Bestand veraendert (vorher '$a_bestand', nachher '$a_danach') -- der Ruecklauf hat nicht getragen;"

  # --- (1) und (2): der Befund am Bestand selbst --------------------
  [ "$a_erster" = "DE-AAA" ] \
    || befund="$befund der erste vergebene Code ist '$a_erster' und nicht DE-AAA;"
  [ "${a_diff:--}" = "0" ] \
    || befund="$befund die Zaehldifferenz betraegt $a_diff: $a_vergeben Codes umspannen die Plaetze $a_von bis $a_bis, also $((a_bis - a_von + 1)) Plaetze der Folge -- $a_diff Plaetze wurden uebersprungen. Bei lueckenloser Vergabe ab DE-AAA reichte die Folge nur bis $(dbz "SELECT pruef_codename($((a_vergeben - 1)))"), und der naechste zu vergebende Code waere $(dbz "SELECT pruef_codename($a_vergeben)");"

  if [ -n "$m" ]; then
    nok MC-01 "Zaehldifferenz -- das Messwerkzeug traegt nicht:$m (Bestand: $a_bestand)"
  elif [ "$BEFUND_G1_OFFEN" = "1" ]; then
    # Die Zahl wird trotzdem genannt: sie ist gerechnet, sie ist von der
    # Selbstprobe gedeckt, und sie misst ab dem Tag der Vergabe
    # unveraendert weiter. Gesperrt ist die AUSSAGE ueber K02-M25, nicht
    # die Rechnung.
    sperr MC-01 "Zaehldifferenz nicht messbar, solange BEF-G1 offen ist. $BEFUND_G1_WORTLAUT. GERECHNET WURDE TROTZDEM, und dieser Wert misst ab dem Tag der Vergabe unveraendert weiter: Zaehldifferenz = $a_diff ($a_vergeben vergebene Codes umspannen die Plaetze $a_von bis $a_bis, erster Code '$a_erster'; Rohmessung '$a_bestand').$([ -n "$befund" ] && printf ' Was die Rechnung heute am Bestand sieht:%s' "$befund") Die Selbstprobe hat belegt, dass die Messung eine gepflanzte Luecke auf Platz $a_pflanzplatz findet und der Bestand nach dem Ruecklauf unveraendert ist -- das Werkzeug traegt, die gepruefte Sache fehlt. UMZUSTELLEN AUF GESCHEITERT, SOBALD BEF-G1 GESCHLOSSEN IST: BEFUND_G1_OFFEN=0 im Kopf des MC-01-Blocks setzen; an Messformel und Schwelle ist nichts zu aendern (K23-D05, K23-M22)"
  elif [ -n "$befund" ]; then
    nok MC-01 "Zaehldifferenz am Bestand (K02-M25):$befund Gemessen ueber ALLE Mandanten, ohne Filter auf Herkunft oder Loeschmarke. Die Selbstprobe hat belegt, dass diese Messung eine gepflanzte Luecke findet"
  else
    ok MC-01 "Zaehldifferenz null: $a_vergeben Kunden-Codes belegen die Plaetze $a_von bis $a_bis lueckenlos, der erste ist $a_erster (K02-M25). Belegt durch Selbstprobe -- eine gepflanzte Luecke auf Platz $a_pflanzplatz wurde gefunden, der Bestand ist nach dem Ruecklauf unveraendert"
  fi
fi
pruefe_sql_marke

# =====================================================================
# MC-02 · ZUORDNUNGSTREUE · K02-G02
#
#   "Es GILT: Der Kunden-Code ist nur bei der Art Kunde Pflicht.
#    Betreiber und Partner bestehen ohne ihn."
#
# GEMESSEN WIRD EINE UNTERSCHEIDUNG, KEIN VORKOMMEN: Der Satz hat ZWEI
# Haelften. Die erste -- jeder Kunde traegt einen Code -- haelt die
# Datenbank ohnehin (`customer_needs_code`); eine Messung, die nur sie
# liest, kann gar nicht scheitern und misst darum nichts. Die zweite --
# Betreiber und Partner tragen KEINEN -- haelt KEINE Bedingung des
# Datenmodells: `customer_needs_code` bindet allein die Art Kunde. Eine
# Zeile PARTNER mit Kunden-Code ist der Datenbank willkommen. Nur die
# Messung findet sie.
#
# Damit ist diese Messung zugleich der Beleg fuer die zweite Zusicherung
# des Auftrags: Sie findet Codes, die auf UNBEKANNTEM WEG entstanden
# sind. Die Selbstprobe schreibt einen solchen Code unmittelbar in die
# Zeile -- an jedem Vorgang vorbei -- und die Messung MUSS ihn nennen.
#
# VIER TEILE:
#   (1) Kein Kunde ohne Code.
#   (2) Kein Betreiber und kein Partner MIT Code.
#   (3) Kein Code zweimal vergeben, keiner formatfremd.
#   (4) SELBSTPROBE: ein gepflanzter PARTNER mit Kunden-Code wird
#       gefunden, und der Bestand ist nach dem Ruecklauf unveraendert.
# =====================================================================
b_bestand="$(dbz "$MESSUNG_B")"
pruefe_sql_marke
b_kunde_ohne="$(feld "$b_bestand" 1)"
b_fremd_mit="$(feld "$b_bestand" 2)"
b_doppelt="$(feld "$b_bestand" 3)"
b_formatfremd="$(feld "$b_bestand" 4)"
b_liste="$(feld "$b_bestand" 5)"

b_mandanten="$(dbz "SELECT count(*) FROM tenant")"
pruefe_sql_marke

# Der Pflanzplatz der Selbstprobe wird EIGENSTAENDIG bestimmt, nicht von
# MC-01 uebernommen: MC-02 misst auch dann etwas, wenn im Bestand noch
# gar kein Kunden-Code vergeben ist -- die Aussage "kein Betreiber und
# kein Partner traegt einen" gilt auch dann. Ohne Codes ist der erste
# freie Platz 0 (DE-AAA).
b_pflanzplatz="$(dbz "SELECT coalesce(max(platz) + 3, 0) FROM pruef_mandantencode_lage")"
pruefe_sql_marke
case "${b_pflanzplatz:-x}" in
  ''|*[!0-9]*) b_pflanzplatz="" ;;
esac

if [ "${b_mandanten:-0}" = "0" ]; then
  sperr MC-02 "Zuordnungstreue nicht messbar: im Bestand steht kein einziger Mandant. Gemessen wurde nichts (K23-M22)"
elif [ -z "$b_pflanzplatz" ] || [ "$b_pflanzplatz" -gt 17575 ]; then
  sperr MC-02 "Zuordnungstreue nicht pruefbar: es liess sich kein freier Platz fuer die Selbstprobe bestimmen (ermittelt: '${b_pflanzplatz:-nichts}'). Ohne Selbstprobe ist nicht belegt, dass die Messung ueberhaupt etwas findet"
else
  m=""
  befund=""

  # --- (4) ZUERST die Selbstprobe ----------------------------------
  #     Gepflanzt wird ein PARTNER mit Kunden-Code. Keine vorhandene
  #     Datenbankbedingung verhindert diese Zeile: customer_needs_code
  #     bindet nur die Art Kunde, customer_code_fmt ist erfuellt. Geht
  #     der INSERT durch und findet die Messung ihn NICHT, ist die
  #     Messung blind fuer genau den Fall, fuer den es sie gibt.
  b_probe="$(db_probe "BEGIN;
    INSERT INTO tenant (kind, name, customer_code, legal_space)
    VALUES ('PARTNER', 'Selbstprobe Zuordnungstreue', pruef_codename($b_pflanzplatz), 'DE');
    $MESSUNG_B;
    ROLLBACK;")" && b_prc=0 || b_prc=1

  if [ "$b_prc" != "0" ]; then
    m="$m die Selbstprobe lief nicht durch -- ob die Messung ueberhaupt etwas findet, ist damit unbelegt. Beobachtet: '$b_probe';"
  else
    b_probe_fremd="$(feld "$b_probe" 2)"
    b_probe_liste="$(feld "$b_probe" 5)"
    b_erwartet=$((b_fremd_mit + 1))
    if [ "${b_probe_fremd:--}" != "$b_erwartet" ]; then
      m="$m die Messung findet einen GEPFLANZTEN Verstoss nicht: nach dem unmittelbaren Schreiben eines PARTNER mit Kunden-Code muessten $b_erwartet Mandanten fremder Art einen Code tragen, gemessen wurden '${b_probe_fremd:-nichts}'. Eine Messung, die einen an jedem Vorgang vorbei geschriebenen Code nicht sieht, findet auch keinen echten;"
    else
      case "$b_probe_liste" in
        *PARTNER*) : ;;
        *) m="$m die Messung zaehlt den gepflanzten PARTNER zwar, benennt ihn aber nicht (Liste: '$b_probe_liste') -- ohne Namen ist der Befund nicht nachverfolgbar;" ;;
      esac
    fi
  fi

  # --- Nach dem Ruecklauf: der Bestand muss unveraendert sein -------
  b_danach="$(dbz "$MESSUNG_B")"
  pruefe_sql_marke
  [ "$b_danach" = "$b_bestand" ] \
    || m="$m die Selbstprobe hat den Bestand veraendert (vorher '$b_bestand', nachher '$b_danach') -- der Ruecklauf hat nicht getragen;"

  # --- (1) bis (3): der Befund am Bestand selbst --------------------
  [ "${b_kunde_ohne:--}" = "0" ] \
    || befund="$befund $b_kunde_ohne Mandant(en) der Art Kunde tragen KEINEN Kunden-Code -- K02-G02: bei der Art Kunde ist er Pflicht;"
  [ "${b_fremd_mit:--}" = "0" ] \
    || befund="$befund $b_fremd_mit Mandant(en), die nicht Kunde sind, tragen einen Kunden-Code ($b_liste) -- K02-G02: Betreiber und Partner bestehen ohne ihn;"
  [ "${b_doppelt:--}" = "0" ] \
    || befund="$befund $b_doppelt Kunden-Code(s) sind mehrfach vergeben;"
  [ "${b_formatfremd:--}" = "0" ] \
    || befund="$befund $b_formatfremd Kunden-Code(s) folgen nicht dem Muster DE-XXX;"

  if [ -n "$m" ]; then
    nok MC-02 "Zuordnungstreue -- das Messwerkzeug traegt nicht:$m (Bestand: $b_bestand)"
  elif [ -n "$befund" ]; then
    nok MC-02 "Zuordnungstreue am Bestand (K02-G02):$befund Gemessen ueber alle $b_mandanten Mandanten, ohne Filter auf Herkunft oder Loeschmarke. Die Selbstprobe hat belegt, dass diese Messung einen unmittelbar geschriebenen Code findet"
  else
    ok MC-02 "Zuordnungstreue traegt: unter $b_mandanten Mandanten traegt jeder Kunde einen Kunden-Code, kein Betreiber und kein Partner traegt einen, keiner ist doppelt oder formatfremd (K02-G02). Belegt durch Selbstprobe -- ein unmittelbar geschriebener PARTNER-Code auf Platz $b_pflanzplatz wurde gefunden und benannt, der Bestand ist nach dem Ruecklauf unveraendert"
  fi
fi
pruefe_sql_marke

# =====================================================================
printf '\n'
[ "$gesperrt" -gt 0 ] && printf 'davon GESPERRT (nicht messbar, zaehlt nach K23-M22 nicht als bestanden): %s\n' "$gesperrt"
printf 'SUMME: %s von %s bestanden, %s gescheitert\n' "$bestanden" "$gesamt" "$gescheitert"
[ "$gescheitert" -eq 0 ]
