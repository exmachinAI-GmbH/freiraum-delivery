#!/usr/bin/env bash
# =====================================================================
# FREIRAUM · Scheibe 2, erster Teil · M3 "Die Vorpruefung haelt an"
# Klauselpruefung gegen einen LAUFENDEN Server
#
# Geschrieben gegen K04 (49 Regeln des Klauselregisters), K19 EN-02,
# EN-03 und EN-04, schema/freiraum_datamodel.sql,
# migrations/M30__pilot_sammelmigration.sql und die WEGETABELLE aus
# arbeit/Plaene/scheibe2_m3_plan.md Abschnitt 2 --
# NICHT gegen den Umsetzungscode. Der Prueffall kennt den Server nur
# durch seine Tueren.
#
# Aufruf:
#   psql ... -f pruefungen/klauseln/vorpruefung_daten.sql          # Daten
#   FREIRAUM_PRUEF_URL=http://localhost:8099 \
#   FREIRAUM_CODE_PFEFFER=... \
#   pruefungen/klauseln/vorpruefung_lauf.sh                        # Faelle
#
# Umgebung:
#   FREIRAUM_PRUEF_URL    Vorgabe http://localhost:8099
#   FREIRAUM_CODE_PFEFFER wie am Server gesetzt -- der Lauf stellt sich
#                         seine Anmeldecodes selbst aus (K03-M15)
#   PGHOST/PGPORT/PGUSER/PGPASSWORD/PGDATABASE
#                         Vorgabe localhost/55433/postgres/pilot/freiraum_pruef
#
# ---------------------------------------------------------------------
# WAS HIER GEMESSEN WIRD
# ---------------------------------------------------------------------
# Die Nachrechnung von M3 verlangt woertlich einen Lauf, der am HALT
# endet, und je einen ueber alle drei AUSWEGE. Das sind:
#
#   VP-13  der Halt            (outcome NICHT_GEEIGNET, completed_at)
#   VP-17  Ausweg 1  Antwort aendern  (superseded_at, keine Zeile getilgt)
#   VP-18  Ausweg 2  Termin            (Gespraech angestossen, outcome bleibt)
#   VP-19  Ausweg 3  zur Uebersicht    (der Check bleibt erhalten)
#
# Die Reihenfolge der drei Auswege am selben Check ist kein Zufall:
# Ausweg 3 und 2 duerfen den Check NICHT veraendern, Ausweg 1 setzt ihn
# zurueck auf OFFEN. Wer Ausweg 1 zuerst faehrt, misst die anderen beiden
# nicht mehr am Halt.
#
# ---------------------------------------------------------------------
# MASSSTAB F07: Vor dem ersten Fall wird der AUFBAU geprueft. Ein Fall,
# der an einem fehlenden Datensatz oder einer fremden Bedingung
# scheitert, misst nichts -- deshalb bricht der Lauf dann ab, statt
# Ergebnisse zu melden, die niemand tragen kann.
#
# ---------------------------------------------------------------------
# EIN BEFUND, DER VOR DEM ERSTEN FALL FESTSTAND
# ---------------------------------------------------------------------
# Der Katalog der drei Eignungsfragen steht BEREITS IM ZIELSCHEMA:
# schema/freiraum_datamodel.sql, Zeilen 737-756, "SEED: Eignungs-Check"
# -- drei Fragen mit ihrem Wortlaut und dreizehn Antwortmoeglichkeiten,
# davon vier mit is_eligible = falsch. Rang 1, also benutzt und nicht
# geaendert. Zwei Folgen:
#   1. Der offene Punkt O-M3-1 des Plans ("der Wortlaut der drei
#      Eignungsfragen ist nicht gezeichnet") trifft so nicht zu; ein
#      Platzhalter-Seed wuerde am eindeutigen fit_question.dimension
#      und an fit_question.position scheitern.
#   2. Drei der vier Wortlaute aus K04-M07 stehen dort ANDERS als in der
#      Klausel. Siehe VP-08 und VP-08b -- das ist ein Widerspruch
#      zwischen Klausel und Rang 1, kein Baufehler.
#
# Und die Umkehrung, die hier besonders zaehlt: der KATALOG der drei
# Eignungsfragen ist Startbestand und damit Pruefgegenstand.
# Hat ihn die Pruefung selbst anlegen muessen (katalog_herkunft =
# ERSATZ, siehe vorpruefung_daten.sql), sind alle Faelle GESPERRT, die
# ihn messen. Ein Fall, der meine eigenen Daten bestaetigt, ist kein
# Fall (K23-M22: was nicht gemessen werden konnte, ist gesperrt).
#
# ---------------------------------------------------------------------
# NACHGEBESSERT AM 15.08.2026 · VIER FAELLE, DIE NICHTS GEMESSEN HABEN
# ---------------------------------------------------------------------
# Eine Gegenprobe hat vier Faelle dieser Datei nachgerechnet und
# festgestellt: sie bestanden, OHNE ETWAS ZU MESSEN. Jeder suchte einen
# Text, der ohnehin auf der Seite steht. Ein Fall, der nicht scheitern
# KANN, misst nichts -- genau der Fehler vom 02.08.2026, wegen dessen
# die blinde Trennung von Bau und Pruefung gebaut wurde.
#
# DIE LEHRE, fuer jeden, der diese Datei spaeter liest:
#
#   Ein Prueffall muss eine UNTERSCHEIDUNG messen, kein Vorkommen.
#   "Der Text steht irgendwo auf der Seite" ist keine Messung, solange
#   die Seite denselben Text ohnehin fuehrt. Gemessen wird erst, WO er
#   steht -- und WAS daneben NICHT steht.
#
# Im Einzelnen:
#
#   VP-14 (K04-M09) · VORHER: der Wortlaut der aufhaltenden Antwort
#     musste irgendwo im Seitenrumpf stehen. EN-04 listet nach der
#     Wegetabelle ohnehin alle Antwortmoeglichkeiten auf -- der Fall
#     bestand also allein deshalb, weil die Antwort waehlbar ist. Eine
#     Seite, die schlicht ALLE Moeglichkeiten auflistet, haette ihn
#     bestanden. Die Klausel verlangt aber: "Der Nutzer erfaehrt, WELCHE
#     Antwort ihn aufhaelt." Das Wort "welche" ist eine UNTERSCHEIDUNG.
#     JETZT gemessen: der Wortlaut der aufhaltenden Antwort steht im
#     BEGRUENDUNGSBEREICH, und der Wortlaut einer NICHT aufhaltenden
#     Antwort desselben Checks steht dort NICHT.
#
#   VP-09 (K04-M06) · VORHER: als erfundene Antwort ging ein deutscher
#     Satz an den Server. Weist der Server ihn schon an einer Formpruefung
#     der Kennung ab, scheitert der Fall an einer FREMDEN Bedingung und
#     misst nicht, ob Freitext als ANTWORT ausgeschlossen ist -- dasselbe
#     Muster, das am 02.08.2026 drei von vier Negativfaellen wertlos
#     machte (Formatpruefung des Kundencodes statt Zielbedingung). JETZT
#     zwei Durchgaenge: der deutsche Satz UND eine frei erfundene, formal
#     gueltige UUID, die nirgends vergeben ist. Der zweite Durchgang kann
#     an keiner Formpruefung mehr scheitern -- er kann nur noch an der
#     geprueften Bedingung scheitern: die Antwort ist keine bestehende
#     Zeile in fit_option.
#
#   VP-12 (K04-G04) · VORHER: der Fragetext der fehlenden Frage musste
#     irgendwo auf der Seite stehen -- EN-04 zeigt die drei Fragen
#     ohnehin. Der Ersatzvergleich auf den Fragecode trug noch weniger:
#     "daten" steckt als Teilwort in gewoehnlichen deutschen Woertern und
#     traefe auch dort, wo niemand eine Frage benennt. JETZT gemessen:
#     die FEHLENDE Frage ist im HINWEISBEREICH benannt, eine bereits
#     beantwortete Frage dort nicht.
#
#   VP-10 (Wegetabelle, "die aktive Antwort markiert") · VORHER: die
#     Kennung der gewaehlten Moeglichkeit musste auf der Seite stehen --
#     sie steht dort ohnehin, sonst waere die Moeglichkeit gar nicht
#     absendbar (POST /eignung/antwort traegt sie als Feld option).
#     JETZT gemessen: GENAU die gewaehlte Moeglichkeit traegt eine
#     Markierung, die uebrigen derselben Frage tragen keine.
#
# Kein Fall wurde dabei weicher; jeder misst mehr als vorher. K23-D05
# verbietet, einen Pruefwert zu senken, damit ein Lauf besteht -- er
# verbietet nicht, ihn zu schaerfen, wenn er nichts gemessen hat.
#
# NICHT geaendert wurde vorpruefung_daten.sql. Die Unterscheidbarkeit der
# Wortlaute liesse sich dort nur herstellen, indem die Pruefung den
# Antwortkatalog selbst schriebe -- der ist aber Rang 1 (Zielschema) und
# zugleich Pruefgegenstand. Der Lauf STELLT SIE DESHALB FEST, statt sie
# herzustellen: sind die verglichenen Wortlaute nicht eindeutig
# unterscheidbar, meldet der Fall GESPERRT statt zu bestehen.
#
# ---------------------------------------------------------------------
# ZWEITE NACHBESSERUNG AM 15.08.2026 · WO GEMESSEN WIRD (VP-14, VP-12)
# ---------------------------------------------------------------------
# Die erste Nachbesserung desselben Tages hat VP-14 und VP-12 auf eine
# UNTERSCHEIDUNG umgestellt: nicht "der Wortlaut steht irgendwo auf der
# Seite", sondern "er steht in DIESEM Bereich, und jener andere Wortlaut
# steht dort nicht". Was gemessen wird, haengt damit daran, wie der
# BEREICH abgegrenzt wird.
#
# WARUM DIE ALTE ABGRENZUNG NICHT TRUG. Beide Faelle grenzten ab ueber
# "alles hinter dem letzten Formular auf /eignung/antwort". Diese
# Herleitung setzt voraus, dass auf der Halt- bzw. Hinweis-Seite noch
# ein Antwortformular steht -- nur dann gibt es ein "dahinter". Der
# geschaerfte Plan (Abschnitt 2, Nachtrag vom 15.08.2026) sagt jetzt
# ausdruecklich, dass auf der Halt-Seite KEINE Antwortformulare mehr
# stehen: die Fragen und die gewaehlten Antworten bleiben sichtbar, aber
# nicht absendbar. Damit fiel die Abgrenzung auf "die ganze Seite"
# zurueck, und VP-14 konnte WEDER gruen NOCH rot melden -- er blieb auf
# GESPERRT. Ein Fall, der nur sperren kann, misst nichts. Der Fehler lag
# nicht in der Bedingung, sondern im Ort.
#
# WARUM DIE NEUE TRAEGT. Derselbe Nachtrag benennt den Ort selbst,
# statt ihn aus der Formularlage erraten zu lassen:
#
#     <div id="halt">      der Halt-Block   -> VP-14
#     <div id="hinweis">   der Hinweis      -> VP-12
#
# Eine Marke haengt an keinem Seitenzustand. Sie steht dort, ob daneben
# Antwortformulare stehen oder nicht und ob der Block vor oder hinter
# der Fragenliste liegt. Beide Faelle grenzen jetzt daran ab.
#
# FAIL-CLOSED BLEIBT. Fehlt die Marke, steht sie mehrfach oder wird ihr
# Bereich nicht geschlossen, ist er nicht abgrenzbar -- dann meldet der
# Fall GESPERRT, nicht bestanden.
#
# KEIN WEICHMACHEN (K23-D05). Beide Unterscheidungsbedingungen bleiben
# wortgleich. Der Bereich ist ENGER geworden: er endet jetzt am
# schliessenden Tag der Marke, waehrend er zuvor bis zum Seitenende
# reichte. Was frueher als "unmessbar, weil die ganze Seite der Bereich
# ist" gesperrt wurde, ist jetzt entscheidbar und faellt ROT aus. Bei
# VP-14 entfaellt die Sperre "hinter dem letzten Antwortformular steht
# keiner der drei Auswege" -- sie war allein der Nachweis, dass die alte
# Abgrenzung gegriffen hat, und ist mit ihr hinfaellig. Dass GENAU DREI
# Auswege erscheinen, misst VP-15 unveraendert weiter.
#
# GEGENPROBE. Dass beide Faelle bei vorhandener Marke wirklich gruen
# ODER rot werden koennen -- und nicht nur sperren --, ist am 15.08.2026
# mit synthetischen Seiten nachgewiesen worden: ohne Marke sperrt der
# Fall, mit Marke und richtiger Begruendung wird er gruen, mit Marke und
# fehlender, zu breiter oder leerer Begruendung wird er rot.
# =====================================================================

BASIS="${FREIRAUM_PRUEF_URL:-http://localhost:8099}"
HIER="$(cd "$(dirname "$0")" && pwd)"
REPO="${FREIRAUM_PRUEF_REPO:-$(cd "$HIER/../.." && pwd)}"

: "${PGHOST:=localhost}"
: "${PGPORT:=55433}"
: "${PGUSER:=postgres}"
: "${PGPASSWORD:=pilot}"
: "${PGDATABASE:=freiraum_pruef}"
export PGHOST PGPORT PGUSER PGPASSWORD PGDATABASE

MANDANT_A='00000000-0000-4000-8000-00000000ef02'   # der Mandant der Sitzung
MANDANT_B='00000000-0000-4000-8000-00000000ef03'   # der fremde Mandant
MANDANT_L='00000000-0000-4000-8000-00000000ef04'   # nur ein Check haengt daran
CHECK_FREMD='00000000-0000-4000-8000-00000000ec01'
CHECK_SPERRE='00000000-0000-4000-8000-00000000ec02'
CHECK_NEGATIV='00000000-0000-4000-8000-00000000ec03'
CHECK_GELOESCHT='00000000-0000-4000-8000-00000000ec04'

ARBEIT="$(mktemp -d "${TMPDIR:-/tmp}/freiraum_vorpruefung.XXXXXX")"
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

# ---------------------------------------------------------------------
# Datenbank -- gehaertete Fassung, uebernommen aus anmeldung_lauf.sh
# (Befund S1/S3 vom 14.08.2026, dort im Dateikopf begruendet):
#
# db()/dbz() fingen frueher nur stdout ab. Schlug die SQL fehl, blieb
# stdout leer -- ein "[ -z ... ]"-Test las das als "alles in Ordnung".
# Ein abbruch() AUS db() heraus wirkt nicht, weil beide ueberwiegend in
# einer Kommandosubstitution laufen; ein exit beendet dort nur die
# Unterschale. Deshalb: bei einem SQL-Fehler geben beide NICHTS auf
# stdout aus, schreiben den psql-Fehlertext nach stderr und legen die
# Markierungsdatei $ARBEIT/sql.marke an. Die Elternschale prueft sie mit
# pruefe_sql_marke() -- dort wirkt exit.
# ---------------------------------------------------------------------
db()  { local aus
        if ! aus="$(psql -X -tAq -v ON_ERROR_STOP=1 -c "$1" 2>"$ARBEIT/psql.fehler")"; then
          local fehlertext
          fehlertext="SQL gescheitert: $(tr '\n' ' ' <"$ARBEIT/psql.fehler")"
          printf '%s\n' "$fehlertext" >&2
          printf '%s\n' "$fehlertext" > "$ARBEIT/sql.marke"
          return 1
        fi
        printf '%s\n' "$aus"; }

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

# Wird direkt in der Elternschale aufgerufen (NIE in einer Kommando-
# substitution) -- nur dort beendet abbruch()s exit den ganzen Lauf.
pruefe_sql_marke() {
  if [ -s "$ARBEIT/sql.marke" ]; then
    abbruch "$(cat "$ARBEIT/sql.marke")"
  fi
}

# Der Gegenpart fuer die NEGATIVFAELLE gegen die Datenbank: hier ist der
# Fehlschlag das erwartete Ergebnis, und die Fehlermeldung im WORTLAUT
# ist die Evidenz (Bauauftrag :649). Die Anweisung laeuft in einer
# Transaktion, die IMMER zurueckgerollt wird -- gelaenge sie wider
# Erwarten, bliebe kein Schaden zurueck.
# Rueckgabe auf stdout: der Fehlertext, oder das Wort KEIN_FEHLER.
dbf() {
  if psql -X -tAq -v ON_ERROR_STOP=1 -c "BEGIN; $1; ROLLBACK;" \
        >"$ARBEIT/neg.aus" 2>"$ARBEIT/neg.fehler"; then
    printf 'KEIN_FEHLER'
  else
    tr '\n' ' ' <"$ARBEIT/neg.fehler"
  fi
}

# ---------------------------------------------------------------------
# Werkzeug: HTTP
# ---------------------------------------------------------------------
saeubere_kopf() { tr -d '\r' < "$1" > "$1.rein" && mv "$1.rein" "$1"; }

hole() {             # $1 pfad  $2 name  [$3 kekswert]
  local p="$ARBEIT/$2" st ex=()
  [ -n "${3:-}" ] && ex=(-H "Cookie: fr_sitzung=$3")
  st=$(curl -sS -o "$p.rumpf" -D "$p.kopf" -w '%{http_code}' --max-time 25 \
        ${ex[@]+"${ex[@]}"} "$BASIS$1" 2>"$p.fehler") || st="000"
  [ -f "$p.kopf" ] && saeubere_kopf "$p.kopf"
  printf '%s' "$st"
}

sende() {            # $1 pfad  $2 name  $3 kekswert  [$4.. felder "name=wert"]
  local pfad="$1" name="$2" keks="$3"; shift 3
  local p="$ARBEIT/$name" st ex=() d=() f
  [ -n "$keks" ] && ex=(-H "Cookie: fr_sitzung=$keks")
  for f in "$@"; do d+=(--data-urlencode "$f"); done
  st=$(curl -sS -o "$p.rumpf" -D "$p.kopf" -w '%{http_code}' --max-time 25 \
        -X POST ${ex[@]+"${ex[@]}"} ${d[@]+"${d[@]}"} "$BASIS$pfad" 2>"$p.fehler") || st="000"
  [ -f "$p.kopf" ] && saeubere_kopf "$p.kopf"
  printf '%s' "$st"
}

post_anmeldung() {   # $1 email  $2 code  $3 name
  sende /anmeldung "$3" "" "email=$1" "code=$2"
}

kopfzeile()    { grep -i "^$2:" "$ARBEIT/$1.kopf" 2>/dev/null | head -1 \
                 | sed "s/^[^:]*:[[:space:]]*//"; }
sitzungswert() { grep -i '^set-cookie:[[:space:]]*fr_sitzung=' "$ARBEIT/$1.kopf" 2>/dev/null \
                 | head -1 | sed 's/^[^=]*=//' | cut -d';' -f1; }
rumpf()        { printf '%s' "$ARBEIT/$1.rumpf"; }

# ---------------------------------------------------------------------
# Werkzeug: Text
#
# Verglichen wird gegen den Rumpf MIT AUFGELOESTEN HTML-Entitaeten.
# Sonst scheiterte ein Fall daran, dass "Geraet & Rechner" als
# "Geraet &amp; Rechner" ankommt -- also an der Zeichenkodierung statt
# an der Klausel (F07).
# ---------------------------------------------------------------------
enthaelt() {         # $1 name  $2 text   -> 0, wenn enthalten
  python3 - "$ARBEIT/$1.rumpf" "$2" <<'PY'
import html, sys
t = html.unescape(open(sys.argv[1], encoding="utf-8", errors="replace").read())
sys.exit(0 if sys.argv[2] in t else 1)
PY
}

stelle() {           # $1 name  $2 text   -> Fundstelle oder -1
  python3 - "$ARBEIT/$1.rumpf" "$2" <<'PY'
import html, sys
t = html.unescape(open(sys.argv[1], encoding="utf-8", errors="replace").read())
print(t.find(sys.argv[2]))
PY
}

formziele() {        # $1 name -> je Zeile das Ziel eines <form action=...>
  python3 - "$ARBEIT/$1.rumpf" <<'PY'
import html, re, sys
t = html.unescape(open(sys.argv[1], encoding="utf-8", errors="replace").read())
for m in re.finditer(r'<form[^>]*\baction\s*=\s*["\']?([^"\'\s>]*)', t, re.I):
    print(m.group(1) or "(leer)")
PY
}

linkziele() {        # $1 name -> je Zeile das Ziel eines <a href=...>
  python3 - "$ARBEIT/$1.rumpf" <<'PY'
import html, re, sys
t = html.unescape(open(sys.argv[1], encoding="utf-8", errors="replace").read())
for m in re.finditer(r'<a[^>]*\bhref\s*=\s*["\']?([^"\'\s>]*)', t, re.I):
    print(m.group(1) or "(leer)")
PY
}

fuehrt_zu() {        # $1 name  $2 ziel -> 0, wenn ein Formular ODER ein Verweis darauf zeigt
  { formziele "$1"; linkziele "$1"; } | grep -qx -- "$2" \
  || { formziele "$1"; linkziele "$1"; } | grep -q -- "^$2?"
}

# ---------------------------------------------------------------------
# Werkzeug: DER BEREICH (Halt-Block bzw. Hinweis)
#
# WARUM ES IHN GIBT. "Der Wortlaut steht irgendwo auf der Seite" misst
# auf EN-04 nichts: die Seite fuehrt nach der Wegetabelle "je Frage die
# Antwortmoeglichkeiten" und damit ohnehin jeden Wortlaut. Gemessen
# werden kann nur, WO er steht.
#
# WIE DER BEREICH ABGEGRENZT WIRD -- ausschliesslich aus dem Vertrag,
# nie aus Kenntnis des Umsetzungscodes.
#
# DIE ALTE HERLEITUNG UND WARUM SIE NICHT TRUG (Befund vom 15.08.2026).
# Bis zum 15.08.2026 lautete sie: "alles hinter dem letzten Formular,
# das auf /eignung/antwort zeigt". Sie stuetzte sich darauf, dass die
# Antwortmoeglichkeiten absendbar sind und das Halt-Feld hinter ihnen
# steht. Diese Herleitung setzt ein Antwortformular auf der Halt-Seite
# VORAUS. Der geschaerfte Plan (Abschnitt 2, Nachtrag vom 15.08.2026)
# sagt aber ausdruecklich: auf der Halt-Seite VERSCHWINDEN die
# Antwortformulare -- Fragen und gewaehlte Antworten bleiben sichtbar,
# aber nicht absendbar. Damit gibt es kein letztes Antwortformular, die
# Abgrenzung fiel auf "die ganze Seite" zurueck, und VP-14 konnte weder
# gruen noch rot melden: er blieb auf GESPERRT. Ein Fall, der nur
# sperren kann, misst nichts.
#
# DIE NEUE HERLEITUNG UND WARUM SIE TRAEGT. Derselbe Nachtrag benennt
# statt einer Lage zwei MARKEN, die beide Seiten kennen:
#
#     <div id="halt">      der Halt-Block: die Begruendung mit dem
#                          Wortlaut der aufhaltenden Antwort und die
#                          drei Auswege
#     <div id="hinweis">   der Hinweis bei unvollstaendigem Check, der
#                          die fehlende Frage beim Namen nennt
#
# Eine Marke haengt an nichts, was sich mit dem Seitenzustand aendert.
# Sie steht auf der Halt-Seite ebenso wie auf der Hinweis-Seite, ob dort
# nun Antwortformulare stehen oder nicht. Der Bereich ist deshalb: DER
# INHALT DES DIV MIT DIESER MARKE, von seinem oeffnenden Tag bis zu
# seinem zugehoerigen </div> (verschachtelte div werden mitgezaehlt,
# damit ein Ausweg-Block den Bereich nicht vorzeitig beendet).
#
# FAIL-CLOSED. Laesst sich der Bereich nicht abgrenzen, meldet der Fall
# GESPERRT -- nie bestanden. Drei Lagen zaehlen als nicht abgrenzbar:
#   FEHLT          keine Marke auf der Seite
#   MEHRDEUTIG     die Marke steht mehr als einmal; welcher Bereich
#                  gemeint ist, ist nicht entscheidbar
#   UNGESCHLOSSEN  der Bereich wird nicht geschlossen; wo er endet, ist
#                  nicht entscheidbar
# Nur bei MARKE wird gemessen. Der Bereich ist damit ENGER als die alte
# "ganze Seite" -- die Nachbesserung ist eine Verschaerfung, kein
# Weichmachen (K23-D05).
# ---------------------------------------------------------------------
bereich_py() {       # $1 name  $2 marke  $3 auftrag (herkunft|laenge|enthaelt)  [$4 text]
  python3 - "$ARBEIT/$1.rumpf" "$2" "$3" "${4:-}" <<'PY'
import html, re, sys
roh = open(sys.argv[1], encoding="utf-8", errors="replace").read()
marke, auftrag, text = sys.argv[2], sys.argv[3], sys.argv[4]

# 1. alle <div ...>, deren id-Attribut genau die Marke traegt
oeffner = []
for m in re.finditer(r'<div\b[^>]*>', roh, re.I):
    a = re.search(r'\bid\s*=\s*(?:"([^"]*)"|\'([^\']*)\'|([^\s"\'>]+))', m.group(0), re.I)
    if a:
        wert = (a.group(1) or a.group(2) or a.group(3) or '').strip()
        if wert == marke:
            oeffner.append(m)

anfang = ende = -1
if not oeffner:
    herkunft = 'FEHLT'
elif len(oeffner) > 1:
    herkunft = 'MEHRDEUTIG'
else:
    # 2. das zugehoerige </div> -- verschachtelte div mitgezaehlt
    anfang = oeffner[0].end()
    tiefe = 1
    for m in re.finditer(r'<\s*(/?)\s*div\b[^>]*>', roh[anfang:], re.I):
        tiefe += -1 if m.group(1) else 1
        if tiefe == 0:
            ende = anfang + m.start()
            break
    herkunft = 'MARKE' if ende >= 0 else 'UNGESCHLOSSEN'

bereich = html.unescape(roh[anfang:ende]) if herkunft == 'MARKE' else ''

if auftrag == 'herkunft':
    print(herkunft)
elif auftrag == 'laenge':
    print(len(re.sub(r'<[^>]*>', ' ', bereich).strip()))
else:
    # fail-closed: ohne abgegrenzten Bereich enthaelt er nichts
    sys.exit(0 if herkunft == 'MARKE' and text and text in bereich else 1)
PY
}
im_bereich()        { bereich_py "$1" "$2" enthaelt "$3"; }
bereich_herkunft()  { bereich_py "$1" "$2" herkunft; }
bereich_laenge()    { bereich_py "$1" "$2" laenge; }

# Warum sich der Bereich nicht abgrenzen liess -- in Worten, die auch
# jemand ohne IT-Kenntnisse einordnen kann.
bereich_sperrgrund() {   # $1 herkunft  $2 marke
  case "$1" in
    FEHLT)         printf 'die Seite fuehrt keinen mit <div id="%s"> benannten Bereich' "$2";;
    MEHRDEUTIG)    printf 'die Seite fuehrt die Marke <div id="%s"> mehr als einmal -- welcher Bereich gemeint ist, ist nicht entscheidbar' "$2";;
    UNGESCHLOSSEN) printf 'der Bereich <div id="%s"> wird auf der Seite nicht geschlossen -- wo er endet, ist nicht entscheidbar' "$2";;
    *)             printf 'die Lage des Bereichs <div id="%s"> ist unbekannt (%s)' "$2" "$1";;
  esac
}

# Zwei Wortlaute sind eindeutig unterscheidbar, wenn beide bestehen,
# verschieden sind und keiner im anderen steckt. Sonst misst ein
# Vergleich zwischen ihnen nichts -- dann GESPERRT, nie bestanden.
unterscheidbar() {   # $1 text a  $2 text b
  [ -n "$1" ] && [ -n "$2" ] && [ "$1" != "$2" ] || return 1
  case "$1" in *"$2"*) return 1;; esac
  case "$2" in *"$1"*) return 1;; esac
  return 0
}

# ---------------------------------------------------------------------
# Werkzeug: IST DIESE MOEGLICHKEIT ALS GEWAEHLT GEKENNZEICHNET?
#
# Gesucht wird eine Markierung IM UMFELD der Kennung -- im Tag, das die
# Kennung traegt, und im umschliessenden Tag davor (Beschriftung,
# Listeneintrag). Das Umfeld wird an der naechsten und der vorigen
# Kennung DERSELBEN Frage abgeschnitten: sonst schlage die Markierung
# der Nachbarmoeglichkeit durch, und der Fall maesse die falsche Zeile.
# Als Markierung gilt, was ein Bildschirm dafuer fuehren kann: checked,
# selected, aria-checked/aria-selected = true oder ein Wort aus dem
# Wortfeld "gewaehlt/ausgewaehlt/markiert/aktiv".
# ---------------------------------------------------------------------
markierungen() {     # $1 name  $2.. alle Kennungen der Frage
                     # -> je Zeile "kennung=JA|NEIN|FEHLT"
  local n="$1"; shift
  python3 - "$ARBEIT/$n.rumpf" "$@" <<'PY'
import re, sys
roh = open(sys.argv[1], encoding="utf-8", errors="replace").read()
ids = sys.argv[2:]

stellen = []
for oid in ids:
    for m in re.finditer(re.escape(oid), roh):
        stellen.append((m.start(), m.end(), oid))
stellen.sort()

marke = re.compile(r'(\bchecked\b|\bselected\b'
                   r'|aria-checked\s*=\s*["\']?\s*true'
                   r'|aria-selected\s*=\s*["\']?\s*true'
                   r'|\bgewaehlt\b|\bgewählt\b|\bausgewaehlt\b|\bausgewählt\b'
                   r'|\bmarkiert\b|\baktiv\b)', re.I)
huelle = re.compile(r'^<\s*(label|li|div|span|td|tr|fieldset|p)\b', re.I)

befund = {oid: 'FEHLT' for oid in ids}
for i, (start, schluss, oid) in enumerate(stellen):
    links  = stellen[i-1][1] if i > 0 else 0
    rechts = stellen[i+1][0] if i + 1 < len(stellen) else len(roh)
    a = roh.rfind('<', links, start)
    if a < 0:
        a = links
    b = roh.find('>', schluss, rechts)
    b = b + 1 if b >= 0 else rechts
    umfeld = roh[a:b]
    # das umschliessende Tag davor -- aber nur eine Huelle, nie ein
    # zweites Eingabefeld (sonst schlaegt dessen Markierung durch)
    v = roh.rfind('<', links, a)
    if v >= 0:
        w = roh.find('>', v, a)
        if w >= 0 and huelle.match(roh[v:w + 1]):
            umfeld = roh[v:w + 1] + umfeld
    if befund[oid] != 'JA':
        befund[oid] = 'JA' if marke.search(umfeld) else 'NEIN'

for oid in ids:
    print(oid + '=' + befund[oid])
PY
}

# ---------------------------------------------------------------------
# Werkzeug: Anmeldung
#
# Der Lauf stellt sich seine Codes selbst aus -- damit er wiederholbar
# ist und nicht davon abhaengt, welcher Code beim letzten Mal verbraucht
# wurde. Der Weg durch die Tuer bleibt derselbe wie in Scheibe 1:
# POST /anmeldung mit email und code, Antwort 303 mit fr_sitzung.
# ---------------------------------------------------------------------
ANM_STATUS=""; ANM_KEKS=""
anmelden() {         # $1 email  $2 code  $3 name  -> setzt ANM_STATUS, ANM_KEKS
  ANM_STATUS=""; ANM_KEKS=""
  db "DELETE FROM login_code
       WHERE actor_id = (SELECT id FROM actor WHERE email='$1')
         AND consumed_at IS NULL AND superseded_at IS NULL" >/dev/null || return 1
  db "INSERT INTO login_code (actor_id, code_hash, issued_at, expires_at)
      SELECT id, pruef_codewert('$2','$FREIRAUM_CODE_PFEFFER'), now(), now() + interval '10 minutes'
        FROM actor WHERE email='$1'" >/dev/null || return 1
  ANM_STATUS="$(post_anmeldung "$1" "$2" "$3")"
  ANM_KEKS="$(sitzungswert "$3")"
  [ -n "$ANM_KEKS" ]
}

# ---------------------------------------------------------------------
# Vorpruefung: Werkzeug, Server, Datenlage
# ---------------------------------------------------------------------
command -v curl    >/dev/null 2>&1 || abbruch 'curl fehlt.'
command -v psql    >/dev/null 2>&1 || abbruch 'psql fehlt.'
command -v python3 >/dev/null 2>&1 || abbruch 'python3 fehlt (Textvergleich mit aufgeloesten HTML-Entitaeten).'

db 'SELECT 1' >/dev/null || abbruch "Datenbank $PGDATABASE auf $PGHOST:$PGPORT nicht erreichbar."
pruefe_sql_marke

[ -n "${FREIRAUM_CODE_PFEFFER:-}" ] || abbruch 'FREIRAUM_CODE_PFEFFER ist nicht gesetzt -- derselbe Wert wie am Server ist noetig, sonst traegt keine Anmeldung und kein einziger Fall misst etwas (F07).'
case "$FREIRAUM_CODE_PFEFFER" in *"'"*) abbruch "FREIRAUM_CODE_PFEFFER enthaelt ein Hochkomma; das Pruefskript kann es nicht sicher in SQL setzen.";; esac

if [ "$(hole /gesundheit vorpruefung)" != "200" ]; then
  abbruch "Server unter $BASIS antwortet nicht auf GET /gesundheit. Erst starten, dann pruefen."
fi

lage="$(dbz "SELECT count(*) FROM pg_views WHERE viewname='pruef_vorpruefung_lage'")"
pruefe_sql_marke
[ "$lage" = "1" ] || abbruch 'Sicht pruef_vorpruefung_lage fehlt -- vorpruefung_daten.sql zuerst einspielen.'

# AUFBAUPRUEFUNG (F07): dieselben Bedingungen wie in vorpruefung_daten.sql,
# hier aber unmittelbar vor dem Lauf -- die Daten koennten zwischenzeitlich
# durch einen frueheren Lauf verbraucht worden sein.
aufbau="$(dbz "
SELECT string_agg(m, ' ') FROM (
  SELECT email || ':status=' || status AS m FROM pruef_vorpruefung_konten
   WHERE status <> 'AKTIV'
  UNION ALL
  SELECT email || ':ohne_portal' AS m FROM pruef_vorpruefung_konten
   WHERE email <> 'vp_admin@vpruef.example' AND freigeschaltete_portale < 1
  UNION ALL
  SELECT email || ':hat_schon_' || checks || '_checks' AS m FROM pruef_vorpruefung_konten
   WHERE email IN ('vp_weg@vpruef.example','vp_halt@vpruef.example',
                   'vp_geeignet@vpruef.example','vp_leer@vpruef.example')
     AND checks <> 0
  UNION ALL
  SELECT email || ':offene_sitzung' AS m FROM pruef_vorpruefung_konten
   WHERE offene_sitzungen > 0
  UNION ALL
  SELECT 'fremder_check_fehlt' AS m
   WHERE NOT EXISTS (SELECT 1 FROM fit_check
                      WHERE id='$CHECK_FREMD' AND tenant_id='$MANDANT_B'
                        AND outcome='NICHT_GEEIGNET')
  UNION ALL
  SELECT 'loeschsperre_mandant_unrein' AS m
   WHERE (SELECT count(*) FROM fit_check WHERE tenant_id='$MANDANT_L') <> 1
      OR EXISTS (SELECT 1 FROM actor WHERE tenant_id='$MANDANT_L')
  UNION ALL
  SELECT 'anwendung_aus_frueherem_lauf' AS m
   WHERE EXISTS (SELECT 1 FROM app WHERE tenant_id IN ('$MANDANT_A','$MANDANT_B'))
) t")"
pruefe_sql_marke
[ -z "$aufbau" ] || abbruch "Datenlage taugt nicht (F07): $aufbau -- vorpruefung_daten.sql neu einspielen."

# ---------------------------------------------------------------------
# Der Katalog wird EINMAL gelesen. Alle Faelle arbeiten mit dem, was der
# Startbestand hergibt -- nie mit geratenen Fragekennungen. Wer die
# Kennung raet, misst den Bau, nicht die Klausel.
# ---------------------------------------------------------------------
KATALOG_HERKUNFT="$(dbz "SELECT katalog_herkunft FROM pruef_vorpruefung_lage")"
pruefe_sql_marke

Q_CODE=(); Q_POS=(); Q_JA=(); Q_NEIN=(); Q_TEXT=()
while IFS="$(printf '\t')" read -r c p ja nein txt; do
  [ -n "$c" ] || continue
  Q_CODE+=("$c"); Q_POS+=("$p"); Q_JA+=("$ja"); Q_NEIN+=("$nein"); Q_TEXT+=("$txt")
done <<EOF
$(db "SELECT concat_ws(chr(9),
        q.code, q.position::text,
        coalesce((SELECT o.id::text FROM fit_option o
                   WHERE o.question_code=q.code AND o.is_eligible
                   ORDER BY o.position LIMIT 1),''),
        coalesce((SELECT o.id::text FROM fit_option o
                   WHERE o.question_code=q.code AND NOT o.is_eligible
                   ORDER BY o.position LIMIT 1),''),
        q.prompt_de)
      FROM fit_question q ORDER BY q.position")
EOF
pruefe_sql_marke

ANZ_FRAGEN=${#Q_CODE[@]}

# Die Frage, an der der Halt ausgeloest wird: die erste (nach position),
# die eine Antwortmoeglichkeit mit is_eligible = falsch fuehrt.
SPERR_I=-1
i=0
while [ $i -lt $ANZ_FRAGEN ]; do
  if [ -n "${Q_NEIN[$i]}" ] && [ "$SPERR_I" = "-1" ]; then SPERR_I=$i; fi
  i=$((i+1))
done

# Kann der Weg ueberhaupt gefahren werden? Drei Fragen, je eine zusagende
# Moeglichkeit (sonst ist GEEIGNET unerreichbar) und mindestens eine
# ausschliessende (sonst gibt es keinen Halt).
WEG_FAHRBAR=1
WEG_GRUND=""
[ "$ANZ_FRAGEN" = "3" ] || { WEG_FAHRBAR=0; WEG_GRUND="$WEG_GRUND der Startbestand fuehrt $ANZ_FRAGEN Fragen statt drei;"; }
i=0
while [ $i -lt $ANZ_FRAGEN ]; do
  [ -n "${Q_JA[$i]}" ] || { WEG_FAHRBAR=0; WEG_GRUND="$WEG_GRUND Frage ${Q_CODE[$i]} hat keine zusagende Antwortmoeglichkeit;"; }
  i=$((i+1))
done
[ "$SPERR_I" != "-1" ] || { WEG_FAHRBAR=0; WEG_GRUND="$WEG_GRUND keine einzige Antwortmoeglichkeit mit is_eligible = falsch -- ein Halt ist nicht ausloesbar;"; }

printf 'FREIRAUM · Scheibe 2 · M3 Vorpruefung — Klauselpruefung gegen %s\n' "$BASIS"
printf 'Datenlage: %s auf %s:%s · Aufbaupruefung (F07) bestanden\n' "$PGDATABASE" "$PGHOST" "$PGPORT"
printf 'Katalog: %s Frage(n), Herkunft %s%s\n\n' "$ANZ_FRAGEN" "$KATALOG_HERKUNFT" \
       "$( [ "$WEG_FAHRBAR" = "1" ] || printf ' — WEG NICHT FAHRBAR:%s' "$WEG_GRUND" )"

# Hilfsfunktion: eine Antwort setzen.
antworte() {         # $1 keks  $2 index  $3 wahl (ja|nein)  $4 name
  local opt
  if [ "$3" = "nein" ]; then opt="${Q_NEIN[$2]}"; else opt="${Q_JA[$2]}"; fi
  sende /eignung/antwort "$4" "$1" "frage=${Q_CODE[$2]}" "option=$opt"
}

# =====================================================================
# VP-01 · Wegetabelle + K19 EN-02 (access: nach_anmeldung) + K04-G04
#         Ohne gueltige Sitzung fuehrt die Uebersicht auf die Anmeldung.
#         NEGATIVFALL: verletzt ist allein die Sitzung.
# =====================================================================
st=$(hole /uebersicht vp01)
ziel="$(kopfzeile vp01 location)"
m=""
[ "$st" = "303" ] || m="$m Status $st statt 303;"
case "$ziel" in *"/anmeldung"*) : ;; *) m="$m Location '$ziel' zeigt nicht auf /anmeldung;";; esac
[ -z "$m" ] && ok VP-01 'GET /uebersicht ohne Sitzung fuehrt mit 303 auf /anmeldung (fail-closed, K19 EN-02 access, K04-G04)' \
            || nok VP-01 "Uebersicht ohne Sitzung:$m"
pruefe_sql_marke

# =====================================================================
# Ab hier mit Sitzung. Das Konto vp_weg faehrt den ganzen Weg
# EN-02 -> EN-03 -> EN-04 und bleibt am Ende unvollstaendig.
# =====================================================================
KEKS_WEG=""
if anmelden 'vp_weg@vpruef.example' '810001' anm_weg; then KEKS_WEG="$ANM_KEKS"; fi
pruefe_sql_marke

# =====================================================================
# VP-02 · Wegetabelle + K19 EN-02 · Die Uebersicht zeigt den Einstieg
#         und AENDERT NICHTS.
# =====================================================================
if [ -z "$KEKS_WEG" ]; then
  sperr VP-02 "Uebersicht nicht messbar: die Anmeldung von vp_weg@ scheiterte (Status $ANM_STATUS)"
else
  vorher_checks="$(dbz "SELECT count(*) FROM fit_check WHERE tenant_id='$MANDANT_A'")"
  vorher_apps="$(dbz  "SELECT count(*) FROM app        WHERE tenant_id='$MANDANT_A'")"
  st=$(hole /uebersicht vp02 "$KEKS_WEG")
  nachher_checks="$(dbz "SELECT count(*) FROM fit_check WHERE tenant_id='$MANDANT_A'")"
  nachher_apps="$(dbz  "SELECT count(*) FROM app        WHERE tenant_id='$MANDANT_A'")"
  m=""
  [ "$st" = "200" ] || m="$m Status $st statt 200;"
  enthaelt vp02 'Neue Anwendung erstellen' || m="$m die Schaltflaeche 'Neue Anwendung erstellen' fehlt;"
  [ "$vorher_checks" = "$nachher_checks" ] || m="$m das blosse Ansehen legte einen Eignungs-Check an ($vorher_checks -> $nachher_checks);"
  [ "$vorher_apps"   = "$nachher_apps" ]   || m="$m das blosse Ansehen legte eine Anwendung an ($vorher_apps -> $nachher_apps);"
  [ -z "$m" ] && ok VP-02 'GET /uebersicht mit Sitzung: 200 mit "Neue Anwendung erstellen", und es entsteht nichts (K19 EN-02)' \
              || nok VP-02 "Uebersicht mit Sitzung:$m"
fi
pruefe_sql_marke

# =====================================================================
# VP-03 · Wegetabelle + K19 EN-02 zustand_erfolg (woertlich) + K01-M27
#         "Neue Anwendung erstellen" fuehrt nach EN-03 und legt WEDER
#         eine Anwendung NOCH einen Eignungs-Check an. Der Eignungs-Check
#         beginnt erst auf EN-04.
# =====================================================================
if [ -z "$KEKS_WEG" ]; then
  sperr VP-03 'Einstieg nicht messbar: keine Sitzung fuer vp_weg@'
else
  vorher_checks="$(dbz "SELECT count(*) FROM fit_check WHERE tenant_id='$MANDANT_A'")"
  vorher_apps="$(dbz  "SELECT count(*) FROM app        WHERE tenant_id='$MANDANT_A'")"
  st=$(sende /uebersicht/neu vp03 "$KEKS_WEG")
  ziel="$(kopfzeile vp03 location)"
  nachher_checks="$(dbz "SELECT count(*) FROM fit_check WHERE tenant_id='$MANDANT_A'")"
  nachher_apps="$(dbz  "SELECT count(*) FROM app        WHERE tenant_id='$MANDANT_A'")"
  m=""
  [ "$st" = "303" ] || m="$m Status $st statt 303;"
  case "$ziel" in *"/vorpruefung"*) : ;; *) m="$m Location '$ziel' zeigt nicht auf /vorpruefung;";; esac
  [ "$vorher_checks" = "$nachher_checks" ] || m="$m es entstand ein fit_check ($vorher_checks -> $nachher_checks), obwohl der Eignungs-Check erst auf EN-04 beginnt;"
  [ "$vorher_apps"   = "$nachher_apps" ]   || m="$m es entstand eine Anwendung ($vorher_apps -> $nachher_apps), gegen K01-M27;"
  [ -z "$m" ] && ok VP-03 'POST /uebersicht/neu: 303 auf /vorpruefung, ohne app und ohne fit_check (K19 EN-02 zustand_erfolg, K01-M27)' \
              || nok VP-03 "Einstieg Neue Anwendung:$m"
fi
pruefe_sql_marke

# =====================================================================
# VP-04 · K04-M02 + K19 EN-03 + K04-G10
#         EN-03 bietet ZWEI Wege an: Check starten und Ueberspringen.
#         Gemessen wird nicht die Beschriftung allein, sondern dass beide
#         Wege als Formular bestehen.
# =====================================================================
if [ -z "$KEKS_WEG" ]; then
  sperr VP-04 'EN-03 nicht messbar: keine Sitzung fuer vp_weg@'
else
  st=$(hole /vorpruefung vp04 "$KEKS_WEG")
  m=""
  [ "$st" = "200" ] || m="$m Status $st statt 200;"
  formziele vp04 | grep -qx '/vorpruefung/starten'       || m="$m kein Formular auf /vorpruefung/starten;"
  formziele vp04 | grep -qx '/vorpruefung/ueberspringen' || m="$m kein Formular auf /vorpruefung/ueberspringen;"
  [ -z "$m" ] && ok VP-04 'GET /vorpruefung: 200 mit beiden Wegen — Check starten und Ueberspringen (K04-M02, K19 EN-03)' \
              || nok VP-04 "EN-03:$m"
fi
pruefe_sql_marke

# =====================================================================
# VP-05 · K19 EN-03 zustand_fehler + K04-G04 (fail-closed) + O-M3-2
#         "Check starten" fuehrt auf einen BENANNTEN Halt: der Wortlaut
#         der fuenf Fragen ist nicht gezeichnet (H09/Punkt 13). Verbleib
#         auf EN-03, und es entsteht NICHTS.
#
#         Gemessen wird der Wortlaut nicht Zeichen fuer Zeichen -- der
#         Plan gibt ihn als Beispiel, nicht als Vertrag. Gemessen wird,
#         dass die Meldung den GRUND nennt (Wortlaut) und den offenen
#         Punkt (H09). Eine Meldung, die das nicht nennt, ist keine
#         benannte Meldung.
# =====================================================================
if [ -z "$KEKS_WEG" ]; then
  sperr VP-05 'Check starten nicht messbar: keine Sitzung fuer vp_weg@'
else
  vorher_checks="$(dbz "SELECT count(*) FROM fit_check WHERE tenant_id='$MANDANT_A'")"
  vorher_apps="$(dbz  "SELECT count(*) FROM app        WHERE tenant_id='$MANDANT_A'")"
  st=$(sende /vorpruefung/starten vp05 "$KEKS_WEG")
  nachher_checks="$(dbz "SELECT count(*) FROM fit_check WHERE tenant_id='$MANDANT_A'")"
  nachher_apps="$(dbz  "SELECT count(*) FROM app        WHERE tenant_id='$MANDANT_A'")"
  m=""
  [ "$st" = "200" ] || m="$m Status $st statt 200 (Verbleib auf EN-03);"
  enthaelt vp05 'Wortlaut' || m="$m die Meldung nennt den Grund nicht (das Wort 'Wortlaut' fehlt);"
  enthaelt vp05 'H09'      || m="$m die Meldung nennt den offenen Punkt H09 nicht;"
  [ "$vorher_checks" = "$nachher_checks" ] || m="$m es entstand ein fit_check ($vorher_checks -> $nachher_checks);"
  [ "$vorher_apps"   = "$nachher_apps" ]   || m="$m es entstand eine Anwendung;"
  [ -z "$m" ] && ok VP-05 'POST /vorpruefung/starten: 200, benannte Meldung zum ungezeichneten Wortlaut (H09), es entsteht nichts (K19 EN-03 zustand_fehler, K04-G04)' \
              || nok VP-05 "Check starten:$m"
fi
pruefe_sql_marke

# =====================================================================
# VP-06 · Wegetabelle + K04-M10 + M11 + M12 + M16 + G06
#         Ueberspringen legt GENAU EINEN Eignungs-Check an:
#           tenant_id = Mandant der Sitzung (M10)
#           actor_id  = das angemeldete Konto
#           outcome   = OFFEN (M11, Vorgabe)
#           completed_at leer (M12: nur ein anderes Ergebnis traegt ihn)
#           retention_class = KI_NACHWEIS (M16)
#           app_id leer -- ein Check besteht ohne Anwendung (G06)
# =====================================================================
if [ -z "$KEKS_WEG" ]; then
  sperr VP-06 'Ueberspringen nicht messbar: keine Sitzung fuer vp_weg@'
else
  st=$(sende /vorpruefung/ueberspringen vp06 "$KEKS_WEG")
  ziel="$(kopfzeile vp06 location)"
  zahl="$(dbz "SELECT count(*) FROM fit_check c JOIN actor a ON a.id=c.actor_id
                WHERE a.email='vp_weg@vpruef.example'")"
  zeile="$(dbz "SELECT concat_ws('|', c.tenant_id::text, c.outcome::text,
                       coalesce(c.completed_at::text,'(leer)'),
                       c.retention_class::text,
                       coalesce(c.app_id::text,'(leer)'))
                  FROM fit_check c JOIN actor a ON a.id=c.actor_id
                 WHERE a.email='vp_weg@vpruef.example'")"
  m=""
  [ "$st" = "303" ] || m="$m Status $st statt 303;"
  case "$ziel" in *"/eignung"*) : ;; *) m="$m Location '$ziel' zeigt nicht auf /eignung;";; esac
  [ "$zahl" = "1" ] || m="$m es entstanden $zahl Eignungs-Checks statt genau einem;"
  case "$zeile" in
    "$MANDANT_A|OFFEN|(leer)|KI_NACHWEIS|(leer)") : ;;
    "") m="$m es entstand kein Eignungs-Check;";;
    *)  m="$m der Check traegt '$zeile' statt '$MANDANT_A|OFFEN|(leer)|KI_NACHWEIS|(leer)';";;
  esac
  [ -z "$m" ] && ok VP-06 'POST /vorpruefung/ueberspringen: 303 auf /eignung, genau ein Check mit Mandant, OFFEN, ohne completed_at, KI_NACHWEIS, ohne Anwendung (K04-M10/M11/M12/M16/G06)' \
              || nok VP-06 "Ueberspringen:$m"
fi
pruefe_sql_marke

# =====================================================================
# VP-07 · K04-M04 + M05 + D02 + K19 EN-04
#         Genau DREI Fragen, je eine je Dimension ART/NUTZUNG/DATEN, in
#         der Reihenfolge aus fit_question.position -- und zwar auf dem
#         Bildschirm, nicht nur in der Tabelle.
#
#         GESPERRT, wenn der Katalog aus den Pruefdaten stammt: dann
#         bestaetigte der Fall nur meine eigene Hand.
# =====================================================================
if [ "$KATALOG_HERKUNFT" != "BESTAND" ]; then
  sperr VP-07 "Der Katalog der drei Fragen stammt nicht aus dem Startbestand des Baus (katalog_herkunft=$KATALOG_HERKUNFT). K04-M04/M05/D02 sind damit nicht messbar -- der Seed fehlt."
elif [ -z "$KEKS_WEG" ]; then
  sperr VP-07 'EN-04 nicht messbar: keine Sitzung fuer vp_weg@'
else
  dims="$(dbz "SELECT string_agg(dimension::text, ',' ORDER BY position) FROM fit_question")"
  posn="$(dbz "SELECT string_agg(position::text, ',' ORDER BY position) FROM fit_question")"
  st=$(hole /eignung vp07 "$KEKS_WEG")
  m=""
  [ "$st" = "200" ] || m="$m Status $st statt 200;"
  [ "$ANZ_FRAGEN" = "3" ] || m="$m fit_question fuehrt $ANZ_FRAGEN Fragen statt genau drei (K04-D02);"
  case "$dims" in
    'ART,NUTZUNG,DATEN'|'ART,DATEN,NUTZUNG'|'NUTZUNG,ART,DATEN'|'NUTZUNG,DATEN,ART'|'DATEN,ART,NUTZUNG'|'DATEN,NUTZUNG,ART') : ;;
    *) m="$m die Dimensionen lauten '$dims' statt je einmal ART, NUTZUNG und DATEN (K04-M04);";;
  esac
  # Feste Anzeigereihenfolge: die Fragetexte stehen auf dem Bildschirm in
  # derselben Folge wie ihre position (K04-M05).
  vorige=-1
  i=0
  while [ $i -lt $ANZ_FRAGEN ]; do
    s="$(stelle vp07 "${Q_TEXT[$i]}")"
    if [ "$s" = "-1" ]; then
      m="$m der Text der Frage ${Q_CODE[$i]} steht nicht auf dem Bildschirm;"
    elif [ "$vorige" -ge 0 ] && [ "$s" -lt "$vorige" ]; then
      m="$m die Frage ${Q_CODE[$i]} (position ${Q_POS[$i]}) steht vor ihrer Vorgaengerin (K04-M05);"
    else
      vorige="$s"
    fi
    i=$((i+1))
  done
  [ -z "$m" ] && ok VP-07 "Genau drei Fragen je Dimension, auf EN-04 in der Reihenfolge der position (Positionen $posn) angezeigt (K04-M04/M05/D02)" \
              || nok VP-07 "Die drei Fragen:$m"
fi
pruefe_sql_marke

# =====================================================================
# VP-08 · K04-M07 · "Vier Antwortmoeglichkeiten MUESSEN is_eligible =
#         falsch tragen ... bei der Datenfrage 'Nein — es geht um
#         Darstellung, Inhalte oder Gestaltung'."
#
#         Gemessen wird hier der Teil der Klausel, der sich messen laesst,
#         ohne gegen eine hoehere Quelle zu laufen (siehe VP-08b):
#           * es sind GENAU VIER Antwortmoeglichkeiten mit is_eligible =
#             falsch -- nicht drei, nicht fuenf;
#           * eine davon haengt an der DATENFRAGE und traegt den einen
#             Wortlaut, den die Klausel dort ausdruecklich vorgibt.
# =====================================================================
if [ "$KATALOG_HERKUNFT" != "BESTAND" ]; then
  sperr VP-08 "Die Ausschlussantworten sind nicht messbar: der Katalog stammt nicht aus dem Startbestand (katalog_herkunft=$KATALOG_HERKUNFT)."
else
  m=""
  n0="$(dbz "SELECT count(*) FROM fit_option WHERE NOT is_eligible")"
  n4="$(dbz "SELECT count(*) FROM fit_option o JOIN fit_question q ON q.code=o.question_code
              WHERE NOT o.is_eligible AND q.dimension='DATEN'
                AND o.label_de ILIKE '%Darstellung, Inhalte oder Gestaltung%'")"
  [ "${n0:-0}" = "4" ] || m="$m es bestehen $n0 Antwortmoeglichkeiten mit is_eligible = falsch statt genau vier;"
  [ "${n4:-0}" -ge 1 ] || m="$m die Ausschlussantwort der Datenfrage ('Nein — es geht um Darstellung, Inhalte oder Gestaltung') fehlt, traegt is_eligible = wahr oder haengt an einer anderen Dimension;"
  [ -z "$m" ] && ok VP-08 'Genau vier Antwortmoeglichkeiten tragen is_eligible = falsch, darunter die Ausschlussantwort der Datenfrage im Wortlaut (K04-M07)' \
              || nok VP-08 "K04-M07:$m"
fi
pruefe_sql_marke

# =====================================================================
# VP-08b · WIDERSPRUCH · K04-M07 gegen Rang 1
#
#         K04-M07 nennt drei weitere Ausschlussantworten im Wortlaut:
#         "reine Netzseite", "etwas zum Installieren auf Rechner oder
#         Geraet", "Wegwerf-Versuch ohne Produktivbetrieb".
#
#         Das ZIELSCHEMA fuehrt an derselben Stelle einen eigenen
#         Startbestand -- schema/freiraum_datamodel.sql, Zeilen 737-756,
#         "SEED: Eignungs-Check". Er traegt dieselben drei Sachverhalte,
#         aber in anderen Worten:
#           'Eine Website, die unser Unternehmen oder Produkt darstellt'
#           'Etwas, das lokal auf dem Rechner oder Geraet installiert wird'
#           'Nur zum Ausprobieren einer Idee - danach vermutlich nicht weiter'
#         Nur die vierte, die der Datenfrage, steht dort woertlich wie in
#         der Klausel (VP-08).
#
#         Das Zielschema ist Rang 1 und gewinnt jeden Widerspruch; es wird
#         benutzt, nie geaendert. Der Bau kann diesen Teil der Klausel
#         also gar nicht erfuellen, ohne eine hoehere Quelle zu brechen.
#         Ein Prueffall daraus wuerde nicht den Bau messen, sondern das
#         Zielschema -- deshalb GESPERRT, mit dem Befund als Evidenz.
#         Aufzuloesen hat das ein Mensch, nicht dieser Lauf.
# =====================================================================
if [ "$KATALOG_HERKUNFT" != "BESTAND" ]; then
  sperr VP-08b "Nicht messbar: der Katalog stammt nicht aus dem Startbestand (katalog_herkunft=$KATALOG_HERKUNFT)."
else
  n1="$(dbz "SELECT count(*) FROM fit_option WHERE NOT is_eligible AND label_de ILIKE '%reine Netzseite%'")"
  n2="$(dbz "SELECT count(*) FROM fit_option WHERE NOT is_eligible AND label_de ILIKE '%Installieren auf Rechner oder Ger%'")"
  n3="$(dbz "SELECT count(*) FROM fit_option WHERE NOT is_eligible AND label_de ILIKE '%Wegwerf-Versuch ohne Produktivbetrieb%'")"
  fehlend=""
  [ "${n1:-0}" -ge 1 ] || fehlend="$fehlend 'reine Netzseite';"
  [ "${n2:-0}" -ge 1 ] || fehlend="$fehlend 'etwas zum Installieren auf Rechner oder Geraet';"
  [ "${n3:-0}" -ge 1 ] || fehlend="$fehlend 'Wegwerf-Versuch ohne Produktivbetrieb';"
  if [ -z "$fehlend" ]; then
    ok VP-08b 'Auch die drei uebrigen Ausschlussantworten aus K04-M07 stehen im Wortlaut — der Widerspruch zum Startbestand des Zielschemas besteht nicht mehr'
  else
    sperr VP-08b "WIDERSPRUCH K04-M07 gegen Rang 1: diese Wortlaute fehlen im Startbestand:$fehlend Das Zielschema (schema/freiraum_datamodel.sql:737-756) fuehrt dieselben Sachverhalte in anderen Worten und gewinnt als Rang 1. Der Bau darf es nicht aendern -- der Fall misst darum nicht den Bau. Entscheidung durch einen Menschen noetig."
  fi
fi
pruefe_sql_marke

# =====================================================================
# VP-09 · K04-M06 · "Freitext ist nicht vorgesehen."
#         Drei Messungen: auf EN-04 steht kein Freitextfeld fuer eine
#         Antwort, und eine Antwort, die keine bestehende fit_option.id
#         ist, wird abgewiesen, ohne eine Zeile anzulegen -- in ZWEI
#         Durchgaengen.
#         NEGATIVFALL -- verletzt ist allein die Herkunft der Antwort.
#
#         NACHGEBESSERT 15.08.2026. Der Fall sandte bisher NUR einen
#         deutschen Satz. Ein Server darf so etwas schon an einer
#         Formpruefung der Kennung abweisen -- dann scheitert der Fall an
#         einer FREMDEN Bedingung und misst die gepruefte nicht. Genau
#         dieses Muster machte am 02.08.2026 drei von vier Negativfaellen
#         wertlos. Der ZWEITE Durchgang sendet deshalb eine frei
#         erfundene, formal einwandfreie UUID: sie passiert jede
#         Formpruefung und kann nur noch daran scheitern, dass sie keine
#         bestehende Antwortmoeglichkeit bezeichnet. Beide Durchgaenge
#         muessen abweisen, und in beiden darf keine Antwortzeile
#         entstehen.
# =====================================================================
OPTION_ERFUNDEN='00000000-0000-4000-8000-0000000f0009'   # formal gueltig, nirgends vergeben
if [ -z "$KEKS_WEG" ]; then
  sperr VP-09 'Freitext nicht messbar: keine Sitzung fuer vp_weg@'
elif [ "$ANZ_FRAGEN" -lt 1 ]; then
  sperr VP-09 'Freitext nicht messbar: der Katalog fuehrt keine Frage'
elif [ "$(dbz "SELECT count(*) FROM fit_option WHERE id='$OPTION_ERFUNDEN'")" != "0" ]; then
  sperr VP-09 "Nicht messbar: die erfundene Kennung $OPTION_ERFUNDEN ist wider Erwarten vergeben -- der zweite Durchgang maesse dann nicht die Herkunft der Antwort (F07)."
else
  hole /eignung vp09a "$KEKS_WEG" >/dev/null
  m=""
  if grep -Eqi '<textarea' "$(rumpf vp09a)"; then
    m="$m EN-04 traegt ein Freitextfeld (textarea);"
  fi
  if grep -Eqi '<input[^>]*type=["'"'"']?text' "$(rumpf vp09a)"; then
    m="$m EN-04 traegt ein einzeiliges Freitextfeld;"
  fi

  # Durchgang 1: ein deutscher Satz -- Freitext, wie ihn ein Mensch tippt.
  # Durchgang 2: eine formal gueltige, nirgends vergebene Kennung -- sie
  #              kann an keiner Formpruefung mehr scheitern.
  for durchgang in satz kennung; do
    if [ "$durchgang" = "satz" ]; then
      wert='Diese Antwort habe ich mir selbst ausgedacht'
      wie='als deutscher Satz'
    else
      wert="$OPTION_ERFUNDEN"
      wie='als formal gueltige, nirgends vergebene Kennung'
    fi
    vorher="$(dbz "SELECT count(*) FROM fit_answer f JOIN fit_check c ON c.id=f.fit_check_id
                    JOIN actor a ON a.id=c.actor_id WHERE a.email='vp_weg@vpruef.example'")"
    st=$(sende /eignung/antwort "vp09b_$durchgang" "$KEKS_WEG" "frage=${Q_CODE[0]}" "option=$wert")
    nachher="$(dbz "SELECT count(*) FROM fit_answer f JOIN fit_check c ON c.id=f.fit_check_id
                     JOIN actor a ON a.id=c.actor_id WHERE a.email='vp_weg@vpruef.example'")"
    case "$st" in
      2*|4*) : ;;
      303)   m="$m eine erfundene Antwort $wie wurde mit 303 angenommen;";;
      5*)    m="$m eine erfundene Antwort $wie fuehrt zu Status $st -- abgewiesen wird sie damit nicht, der Weg stuerzt ab;";;
      *)     m="$m unerwarteter Status $st beim Durchgang $wie;";;
    esac
    [ "$vorher" = "$nachher" ] \
      || m="$m es entstand eine Antwortzeile aus einer erfundenen Antwort $wie ($vorher -> $nachher);"
  done

  [ -z "$m" ] && ok VP-09 'Kein Freitext: EN-04 bietet kein Textfeld, und eine erfundene Antwort wird abgewiesen — als deutscher Satz UND als formal gueltige, nirgends vergebene Kennung, je ohne eine Zeile anzulegen (K04-M06)' \
              || nok VP-09 "Freitext:$m"
fi
pruefe_sql_marke

# =====================================================================
# VP-10 · Wegetabelle + K19 EN-04 antwort_waehlen
#         Eine gewaehlte Antwort wird gespeichert, fuehrt mit 303 zurueck
#         auf /eignung, ist die einzige nicht zurueckgenommene Antwort
#         ihrer Frage und wird auf dem Bildschirm als gewaehlt markiert.
#
#         NACHGEBESSERT 15.08.2026. Der Fall prueft bisher, ob die
#         KENNUNG der gewaehlten Moeglichkeit auf der Seite steht. Sie
#         steht dort ohnehin: ohne sie waere die Moeglichkeit nicht
#         absendbar, denn POST /eignung/antwort traegt sie im Feld
#         option (Wegetabelle). Der Fall konnte also gar nicht
#         scheitern. Die Wegetabelle verlangt aber "die aktive Antwort
#         markiert" -- das ist eine UNTERSCHEIDUNG zwischen der
#         gewaehlten und den uebrigen Moeglichkeiten derselben Frage.
#         Gemessen wird jetzt genau sie: die gewaehlte traegt eine
#         Markierung, jede andere derselben Frage traegt keine. Ein
#         Bildschirm, der alle markiert oder keine, faellt durch.
# =====================================================================
if [ -z "$KEKS_WEG" ] || [ "$WEG_FAHRBAR" != "1" ]; then
  sperr VP-10 "Antwort waehlen nicht messbar:${WEG_GRUND:- keine Sitzung fuer vp_weg@}"
else
  st=$(antworte "$KEKS_WEG" 0 ja vp10)
  ziel="$(kopfzeile vp10 location)"
  aktiv="$(dbz "SELECT count(*) FROM fit_answer f JOIN fit_check c ON c.id=f.fit_check_id
                 JOIN actor a ON a.id=c.actor_id
                WHERE a.email='vp_weg@vpruef.example'
                  AND f.question_code='${Q_CODE[0]}' AND f.superseded_at IS NULL")"
  opt="$(dbz "SELECT f.option_id::text FROM fit_answer f JOIN fit_check c ON c.id=f.fit_check_id
                JOIN actor a ON a.id=c.actor_id
               WHERE a.email='vp_weg@vpruef.example'
                 AND f.question_code='${Q_CODE[0]}' AND f.superseded_at IS NULL")"
  hole /eignung vp10b "$KEKS_WEG" >/dev/null
  m=""
  [ "$st" = "303" ] || m="$m Status $st statt 303;"
  case "$ziel" in *"/eignung"*) : ;; *) m="$m Location '$ziel' zeigt nicht auf /eignung;";; esac
  [ "$aktiv" = "1" ] || m="$m es bestehen $aktiv nicht zurueckgenommene Antworten auf die erste Frage statt genau einer;"
  [ "$opt" = "${Q_JA[0]}" ] || m="$m gespeichert wurde die Moeglichkeit '$opt' statt der gewaehlten '${Q_JA[0]}';"

  # Die Markierung: GENAU die gewaehlte Moeglichkeit ist gekennzeichnet,
  # keine andere derselben Frage. Gemessen wird an allen Moeglichkeiten
  # der Frage, nicht nur an der gewaehlten -- sonst bestuende der Fall
  # auch bei einem Bildschirm, der alle markiert.
  ALLE_MOEGL=()
  while IFS= read -r z; do [ -n "$z" ] && ALLE_MOEGL+=("$z"); done <<EOF
$(db "SELECT id::text FROM fit_option WHERE question_code='${Q_CODE[0]}' ORDER BY position")
EOF
  pruefe_sql_marke
  if [ "${#ALLE_MOEGL[@]}" -lt 2 ]; then
    m="$m die Frage ${Q_CODE[0]} fuehrt nur ${#ALLE_MOEGL[@]} Antwortmoeglichkeit(en) -- an einer einzigen Moeglichkeit laesst sich keine Markierung unterscheiden (der Katalog selbst wird von VP-07 und VP-08 gemessen);"
  else
    while IFS='=' read -r kennung befund; do
      [ -n "$kennung" ] || continue
      if [ "$kennung" = "${Q_JA[0]}" ]; then
        case "$befund" in
          JA)    : ;;
          NEIN)  m="$m die gewaehlte Moeglichkeit steht zwar auf EN-04, ist aber nicht als gewaehlt gekennzeichnet;";;
          FEHLT) m="$m die gewaehlte Moeglichkeit steht ueberhaupt nicht auf EN-04;";;
        esac
      else
        case "$befund" in
          JA)    m="$m auch die NICHT gewaehlte Moeglichkeit $kennung derselben Frage ist als gewaehlt gekennzeichnet -- die Markierung unterscheidet nicht;";;
          FEHLT) m="$m die Moeglichkeit $kennung der Frage ${Q_CODE[0]} steht nicht auf EN-04 und ist damit nicht waehlbar;";;
        esac
      fi
    done <<EOF
$(markierungen vp10b "${ALLE_MOEGL[@]}")
EOF
  fi
  [ -z "$m" ] && ok VP-10 'POST /eignung/antwort speichert die Wahl, fuehrt mit 303 auf /eignung — und dort ist GENAU die gewaehlte Moeglichkeit als gewaehlt gekennzeichnet, keine andere derselben Frage (K19 EN-04 antwort_waehlen, Wegetabelle)' \
              || nok VP-10 "Antwort waehlen:$m"
fi
pruefe_sql_marke

# =====================================================================
# VP-11 · K04-M15 + M14 + D03
#         Eine ANDERE Wahl auf dieselbe Frage nimmt die bisherige Zeile
#         mit superseded_at zurueck und legt eine neue an. Die alte Zeile
#         bleibt bestehen -- die Ruecknahme ist ein Zeitstempel, kein
#         Entfernen (D03). Danach besteht genau EINE offene Antwort (M14).
# =====================================================================
if [ -z "$KEKS_WEG" ] || [ "$WEG_FAHRBAR" != "1" ]; then
  sperr VP-11 "Antwort aendern nicht messbar:${WEG_GRUND:- keine Sitzung fuer vp_weg@}"
elif [ -z "${Q_NEIN[0]}" ]; then
  sperr VP-11 "Antwort aendern nicht messbar: die Frage ${Q_CODE[0]} fuehrt keine zweite Antwortmoeglichkeit"
else
  vorher_zeilen="$(dbz "SELECT count(*) FROM fit_answer f JOIN fit_check c ON c.id=f.fit_check_id
                         JOIN actor a ON a.id=c.actor_id
                        WHERE a.email='vp_weg@vpruef.example' AND f.question_code='${Q_CODE[0]}'")"
  st=$(antworte "$KEKS_WEG" 0 nein vp11)
  nachher_zeilen="$(dbz "SELECT count(*) FROM fit_answer f JOIN fit_check c ON c.id=f.fit_check_id
                          JOIN actor a ON a.id=c.actor_id
                         WHERE a.email='vp_weg@vpruef.example' AND f.question_code='${Q_CODE[0]}'")"
  aktiv="$(dbz "SELECT count(*) FROM fit_answer f JOIN fit_check c ON c.id=f.fit_check_id
                 JOIN actor a ON a.id=c.actor_id
                WHERE a.email='vp_weg@vpruef.example' AND f.question_code='${Q_CODE[0]}'
                  AND f.superseded_at IS NULL")"
  alt="$(dbz "SELECT count(*) FROM fit_answer f JOIN fit_check c ON c.id=f.fit_check_id
               JOIN actor a ON a.id=c.actor_id
              WHERE a.email='vp_weg@vpruef.example' AND f.question_code='${Q_CODE[0]}'
                AND f.option_id='${Q_JA[0]}' AND f.superseded_at IS NOT NULL")"
  m=""
  [ "$st" = "303" ] || m="$m Status $st statt 303;"
  [ "${nachher_zeilen:-0}" -gt "${vorher_zeilen:-0}" ] || m="$m die Zeilenzahl blieb bei $vorher_zeilen -- die alte Antwort wurde ueberschrieben statt zurueckgenommen (K04-D03);"
  [ "$alt" = "1" ] || m="$m die alte Antwortzeile traegt kein superseded_at oder ist verschwunden (K04-M15, D03);"
  [ "$aktiv" = "1" ] || m="$m es bestehen $aktiv nicht zurueckgenommene Antworten statt genau einer (K04-M14);"
  [ -z "$m" ] && ok VP-11 'Eine geaenderte Antwort nimmt die alte Zeile mit superseded_at zurueck, laesst sie stehen und legt eine neue an (K04-M15, M14, D03)' \
              || nok VP-11 "Antwort aendern:$m"
fi
pruefe_sql_marke

# =====================================================================
# VP-12 · K04-G04 (fail-closed) + K19 EN-04 zustand_leer + K04-D11
#         Fehlt eine Antwort, wird GESPERRT statt zugelassen: das
#         Ergebnis bleibt OFFEN, completed_at bleibt leer, und der
#         Hinweis nennt die fehlende Frage. Es entsteht kein Vorschlag
#         Direkt-Prototyp (D11, Verbotshaelfte).
#
#         Zustand nach VP-11: genau die erste Frage ist beantwortet.
#         Die zweite bekommt jetzt ihre Antwort, die DRITTE bleibt offen.
#
#         NACHGEBESSERT 15.08.2026. "Der Fragetext steht irgendwo auf der
#         Seite" trug nicht: EN-04 zeigt die drei Fragen ohnehin, der
#         Fall konnte nicht scheitern. Der Ersatzvergleich auf den
#         Fragecode trug noch weniger -- "daten" steckt als Teilwort in
#         gewoehnlichen deutschen Woertern. Gemessen wird jetzt die
#         UNTERSCHEIDUNG, die K19 EN-04 zustand_leer verlangt ("Hinweis
#         nennt die fehlende Frage"): die FEHLENDE Frage ist im
#         Hinweisbereich benannt, eine bereits BEANTWORTETE dort nicht.
#         Ein Hinweis, der alle drei Fragen aufzaehlt, nennt keine.
#
#         NEU ABGEGRENZT AM 15.08.2026 (zweite Nachbesserung). Beide
#         Bedingungen bleiben unveraendert; ersetzt wird nur, WO
#         gemessen wird. Der Hinweisbereich war "alles hinter dem
#         letzten Formular auf /eignung/antwort" -- eine Herleitung aus
#         der Formularlage, die voraussetzt, dass ueberhaupt ein
#         Antwortformular danebensteht. Der geschaerfte Plan benennt
#         stattdessen die Marke <div id="hinweis">. Daran wird jetzt
#         abgegrenzt. Fehlt die Marke, ist der Bereich nicht abgrenzbar
#         und der Fall GESPERRT (fail-closed).
# =====================================================================
if [ -z "$KEKS_WEG" ] || [ "$WEG_FAHRBAR" != "1" ]; then
  sperr VP-12 "Fail-closed nicht messbar:${WEG_GRUND:- keine Sitzung fuer vp_weg@}"
else
  antworte "$KEKS_WEG" 1 ja vp12a >/dev/null
  offene="$(dbz "SELECT count(*) FROM fit_answer f JOIN fit_check c ON c.id=f.fit_check_id
                  JOIN actor a ON a.id=c.actor_id
                 WHERE a.email='vp_weg@vpruef.example' AND f.superseded_at IS NULL")"
  st=$(sende /eignung/weiter vp12 "$KEKS_WEG")
  zeile="$(dbz "SELECT concat_ws('|', c.outcome::text, coalesce(c.completed_at::text,'(leer)'))
                  FROM fit_check c JOIN actor a ON a.id=c.actor_id
                 WHERE a.email='vp_weg@vpruef.example'")"
  m=""
  [ "$offene" = "2" ] || m="$m der Aufbau des Falls stimmt nicht: $offene von 3 Fragen beantwortet statt 2;"
  [ "$st" = "200" ] || m="$m Status $st statt 200 (Verbleib auf EN-04 mit Hinweis);"
  [ "$zeile" = "OFFEN|(leer)" ] || m="$m der Check steht auf '$zeile' statt 'OFFEN|(leer)' -- ein unvollstaendiger Check wurde ausgewertet (K04-G04);"

  # Der Hinweis nennt die FEHLENDE Frage -- und nur sie. Verglichen wird
  # die dritte (unbeantwortete) gegen die erste (beantwortete) Frage.
  fehlt_txt="${Q_TEXT[2]}"
  schon_txt="${Q_TEXT[0]}"
  h_herkunft="$(bereich_herkunft vp12 hinweis)"
  h_laenge="$(bereich_laenge vp12 hinweis)"
  if ! unterscheidbar "$fehlt_txt" "$schon_txt"; then
    sperr VP-12 "Der Hinweis auf die fehlende Frage ist nicht messbar: die Wortlaute der fehlenden und der beantworteten Frage sind nicht eindeutig unterscheidbar ('$fehlt_txt' gegen '$schon_txt'). Ein Vergleich zwischen ihnen maesse nichts (F07)."
  elif [ "$h_herkunft" != "MARKE" ]; then
    sperr VP-12 "Der Hinweisbereich laesst sich nicht abgrenzen: $(bereich_sperrgrund "$h_herkunft" hinweis). Der Plan (Abschnitt 2, Nachtrag vom 15.08.2026) verlangt diese Marke ausdruecklich. Ohne sie ist nicht entscheidbar, ob ein Fund im Hinweis oder bloss in der Fragenliste steht -- gemessen wird dann nichts (K23-M22, fail-closed).${m:+ Ausserdem festgestellt:$m}"
  else
    [ "${h_laenge:-0}" -gt 0 ] \
      || m="$m der Hinweisbereich <div id=\"hinweis\"> ist leer -- er kann die fehlende Frage nicht benennen (K19 EN-04 zustand_leer);"
    im_bereich vp12 hinweis "$fehlt_txt" \
      || m="$m der Hinweis nennt die fehlende Frage nicht: ihr Wortlaut steht nicht im Hinweisbereich <div id=\"hinweis\"> -- dass er weiter oben in der Fragenliste steht, nennt niemandem die offene Frage (K19 EN-04 zustand_leer);"
    im_bereich vp12 hinweis "$schon_txt" \
      && m="$m im Hinweisbereich steht auch der Wortlaut der bereits beantworteten Frage '${Q_CODE[0]}' -- der Hinweis unterscheidet nicht, welche Frage offen ist;"
    enthaelt vp12 'Direkt-Prototyp' && m="$m bei unvollstaendigem Check erscheint der Vorschlag Direkt-Prototyp (K04-D11);"
    if [ -z "$m" ]; then
      ok VP-12 'Fehlt eine Antwort, bleibt das Ergebnis OFFEN ohne completed_at, und der Hinweis benennt GENAU die fehlende Frage — die bereits beantwortete steht dort nicht (K04-G04, K19 EN-04 zustand_leer)'
    else
      nok VP-12 "Unvollstaendiger Check:$m"
    fi
  fi
fi
pruefe_sql_marke

# =====================================================================
# VP-13 · DER HALT (Nachrechnung M3, erster Teil)
#         K04-M13 + M12 + K19 EN-04 zustand_fehler
#         Drei Antworten, davon eine mit is_eligible = falsch:
#         outcome = NICHT_GEEIGNET, completed_at im selben Schreibvorgang
#         gesetzt, und EN-04 zeigt das Halt-Feld AN STELLE des
#         Weiterwegs.
# =====================================================================
KEKS_HALT=""
if [ "$WEG_FAHRBAR" != "1" ]; then
  sperr VP-13 "Der Halt ist nicht ausloesbar:$WEG_GRUND"
elif ! anmelden 'vp_halt@vpruef.example' '810002' anm_halt; then
  sperr VP-13 "Der Halt ist nicht messbar: die Anmeldung von vp_halt@ scheiterte (Status $ANM_STATUS)"
else
  KEKS_HALT="$ANM_KEKS"
  sende /vorpruefung/ueberspringen vp13a "$KEKS_HALT" >/dev/null
  i=0
  while [ $i -lt $ANZ_FRAGEN ]; do
    if [ $i -eq $SPERR_I ]; then antworte "$KEKS_HALT" $i nein "vp13b_$i" >/dev/null
    else                         antworte "$KEKS_HALT" $i ja   "vp13b_$i" >/dev/null; fi
    i=$((i+1))
  done
  offene="$(dbz "SELECT count(*) FROM fit_answer f JOIN fit_check c ON c.id=f.fit_check_id
                  JOIN actor a ON a.id=c.actor_id
                 WHERE a.email='vp_halt@vpruef.example' AND f.superseded_at IS NULL")"
  st=$(sende /eignung/weiter vp13 "$KEKS_HALT")
  zeile="$(dbz "SELECT concat_ws('|', c.outcome::text,
                       CASE WHEN c.completed_at IS NULL THEN '(leer)' ELSE '(gesetzt)' END)
                  FROM fit_check c JOIN actor a ON a.id=c.actor_id
                 WHERE a.email='vp_halt@vpruef.example'")"
  st2=$(hole /eignung vp13c "$KEKS_HALT")
  m=""
  [ "$offene" = "3" ] || m="$m der Aufbau des Falls stimmt nicht: $offene von 3 Fragen beantwortet;"
  case "$st" in 200|303) : ;; *) m="$m POST /eignung/weiter liefert $st;";; esac
  [ "$zeile" = "NICHT_GEEIGNET|(gesetzt)" ] \
    || m="$m der Check steht auf '$zeile' statt 'NICHT_GEEIGNET|(gesetzt)' (K04-M13, M12);"
  [ "$st2" = "200" ] || m="$m GET /eignung nach dem Halt liefert $st2 statt 200;"
  formziele vp13c | grep -qx '/eignung/weiter' \
    && m="$m der Weiterweg steht nach dem Halt weiter offen -- das Halt-Feld tritt nicht an seine Stelle (K19 EN-04);"
  [ -z "$m" ] && ok VP-13 'DER HALT: drei Antworten, eine nicht eignungsfaehig -> NICHT_GEEIGNET mit completed_at, Halt-Feld statt Weiterweg (K04-M13, M12)' \
              || nok VP-13 "Der Halt:$m"
fi
pruefe_sql_marke

# =====================================================================
# VP-14 · K04-M09 · "Der Halt MUSS begruendet angezeigt werden. Der
#         Nutzer erfaehrt, WELCHE Antwort ihn aufhaelt."
#
#         DER SCHWERSTE FALL DIESER DATEI -- und bis zum 15.08.2026 der
#         wertloseste. Er verlangte, dass der Anzeigetext der
#         aufhaltenden Antwort irgendwo im Seitenrumpf steht. EN-04 fuehrt
#         nach der Wegetabelle "je Frage die Antwortmoeglichkeiten" und
#         damit ohnehin JEDEN dieser Texte: eine Seite, die schlicht alle
#         Moeglichkeiten auflistet und kein Wort begruendet, bestand ihn.
#         Ein Fall, der nicht scheitern kann, misst nichts.
#
#         Das Wort "WELCHE" in der Klausel verlangt eine UNTERSCHEIDUNG:
#         der Nutzer muss die aufhaltende Antwort von den uebrigen
#         trennen koennen. Gemessen wird sie mit zwei Mitteln zugleich:
#
#           (a) der Wortlaut der AUFHALTENDEN Antwort steht IM
#               HALT-BLOCK -- nicht irgendwo auf der Seite.
#           (b) der Wortlaut einer NICHT aufhaltenden Antwort DESSELBEN
#               Checks steht dort NICHT. Wer im Halt-Block alle
#               drei gewaehlten Antworten aufzaehlt, nennt keine.
#
#         Die beiden verglichenen Wortlaute muessen eindeutig
#         unterscheidbar sein. Sie stammen aus dem Antwortkatalog, der
#         Rang 1 ist und von der Pruefung nicht geschrieben wird -- der
#         Lauf STELLT die Unterscheidbarkeit deshalb fest und sperrt den
#         Fall, wenn sie fehlt, statt ihn bestehen zu lassen.
#
#         NEU ABGEGRENZT AM 15.08.2026 (zweite Nachbesserung).
#         WARUM DIE ALTE ABGRENZUNG NICHT TRUG: der Begruendungsbereich
#         war "alles hinter dem letzten Formular auf /eignung/antwort".
#         Das setzt voraus, dass auf der Halt-Seite ueberhaupt noch ein
#         Antwortformular steht. Der geschaerfte Plan sagt ausdruecklich
#         das Gegenteil: auf der Halt-Seite verschwinden die
#         Antwortformulare. Damit fiel die Abgrenzung auf "die ganze
#         Seite" zurueck, und der Fall konnte WEDER gruen NOCH rot
#         melden -- er blieb auf GESPERRT. Ein Fall, der nur sperren
#         kann, misst nichts.
#         WARUM DIE NEUE TRAEGT: derselbe Nachtrag benennt den Ort
#         selbst -- <div id="halt">. Die Marke haengt an keinem
#         Seitenzustand; sie steht auf der Halt-Seite, ob dort
#         Antwortformulare stehen oder nicht. Fehlt sie, ist der Bereich
#         nicht abgrenzbar und der Fall GESPERRT (fail-closed).
#         Die Sperre "keiner der drei Auswege hinter dem letzten
#         Antwortformular" entfaellt: sie war nur der Nachweis, dass die
#         alte Abgrenzung gegriffen hat. Dass genau drei Auswege
#         erscheinen, misst VP-15 -- unveraendert. Beide
#         Unterscheidungsbedingungen (a) und (b) bleiben wortgleich; sie
#         greifen jetzt auf einem ENGEREN Bereich als zuvor.
# =====================================================================
if [ -z "$KEKS_HALT" ]; then
  sperr VP-14 'Die Begruendung ist nicht messbar: der Halt wurde nicht erreicht'
else
  # Die aufhaltende Antwort: die is_eligible = falsch, die den Halt
  # ausgeloest hat.
  sperrtext="$(dbz "SELECT label_de FROM fit_option WHERE id='${Q_NEIN[$SPERR_I]}'")"
  # Eine NICHT aufhaltende Antwort DESSELBEN Checks: die zusagende Wahl
  # einer der beiden anderen Fragen -- VP-13 hat sie ebenfalls gesetzt.
  FREI_I=-1
  i=0
  while [ $i -lt $ANZ_FRAGEN ]; do
    if [ $i -ne "$SPERR_I" ] && [ -n "${Q_JA[$i]}" ] && [ "$FREI_I" = "-1" ]; then FREI_I=$i; fi
    i=$((i+1))
  done
  freitext=""
  [ "$FREI_I" != "-1" ] && freitext="$(dbz "SELECT label_de FROM fit_option WHERE id='${Q_JA[$FREI_I]}'")"
  pruefe_sql_marke

  b_herkunft="$(bereich_herkunft vp13c halt)"
  b_laenge="$(bereich_laenge vp13c halt)"

  if [ -z "$sperrtext" ]; then
    sperr VP-14 'Die Begruendung ist nicht messbar: der Anzeigetext der aufhaltenden Antwort ist nicht lesbar.'
  elif [ "$FREI_I" = "-1" ] || [ -z "$freitext" ]; then
    sperr VP-14 'Die Unterscheidung ist nicht messbar: der Check fuehrt neben der aufhaltenden keine zweite, nicht aufhaltende Antwort, gegen die sich abgrenzen liesse.'
  elif ! unterscheidbar "$sperrtext" "$freitext"; then
    sperr VP-14 "Die Unterscheidung ist nicht messbar: die Wortlaute der aufhaltenden und der nicht aufhaltenden Antwort sind nicht eindeutig unterscheidbar ('$sperrtext' gegen '$freitext') -- ein Vergleich zwischen ihnen maesse nichts (F07)."
  elif [ "$b_herkunft" != "MARKE" ]; then
    sperr VP-14 "Der Halt-Block laesst sich nicht abgrenzen: $(bereich_sperrgrund "$b_herkunft" halt). Der Plan (Abschnitt 2, Nachtrag vom 15.08.2026) verlangt diese Marke ausdruecklich. Ohne sie ist nicht entscheidbar, ob ein Wortlaut in der Begruendung oder bloss in der Antwortliste steht -- gemessen wird dann nichts (K23-M22, fail-closed)."
  else
    m=""
    [ "${b_laenge:-0}" -gt 0 ] \
      || m="$m der Halt-Block <div id=\"halt\"> ist leer -- der Halt ist nicht begruendet (K04-M09);"
    im_bereich vp13c halt "$sperrtext" \
      || m="$m der Halt-Block <div id=\"halt\"> nennt die aufhaltende Antwort '$sperrtext' nicht; dass ihr Wortlaut weiter oben auf der Seite steht, sagt dem Nutzer nicht, WELCHE Antwort ihn aufhaelt (K04-M09);"
    im_bereich vp13c halt "$freitext" \
      && m="$m im Halt-Block steht auch die NICHT aufhaltende Antwort '$freitext' -- die Begruendung unterscheidet nicht, welche Antwort aufhaelt (K04-M09);"
    if [ -z "$m" ]; then
      ok VP-14 "Der Halt ist begruendet: der Halt-Block <div id=\"halt\"> nennt GENAU die aufhaltende Antwort im Wortlaut, eine nicht aufhaltende Antwort desselben Checks steht dort nicht (K04-M09)"
    else
      nok VP-14 "Begruendung des Halts:$m"
    fi
  fi
fi
pruefe_sql_marke

# =====================================================================
# VP-15 · K04-M08 · Nach einem Halt erscheinen GENAU DREI Auswege:
#         Antwort aendern · Gespraech mit der Ansprechperson · zur
#         Uebersicht. Gemessen wird beides: dass alle drei da sind, und
#         dass kein vierter Weg danebensteht.
# =====================================================================
if [ -z "$KEKS_HALT" ]; then
  sperr VP-15 'Die drei Auswege sind nicht messbar: der Halt wurde nicht erreicht'
else
  m=""
  formziele vp13c | grep -qx '/eignung/aendern' || m="$m Ausweg 1 fehlt: kein Formular auf /eignung/aendern;"
  formziele vp13c | grep -qx '/eignung/termin'  || m="$m Ausweg 2 fehlt: kein Formular auf /eignung/termin;"
  fuehrt_zu vp13c '/uebersicht'                 || m="$m Ausweg 3 fehlt: kein Weg auf /uebersicht;"
  # Kein vierter Weg: jedes Formular auf der Halt-Seite gehoert zu einem
  # der drei Auswege, zur Antwortwahl selbst oder zum Abmelden aus
  # Scheibe 1. Alles andere waere erfundener Umfang.
  while read -r z; do
    [ -n "$z" ] || continue
    case "$z" in
      /eignung/aendern|/eignung/termin|/eignung/antwort|/uebersicht|/abmelden|/eignung|"") : ;;
      *) m="$m nach dem Halt steht ein vierter Weg offen: '$z' (K04-M08);";;
    esac
  done <<EOF
$(formziele vp13c)
EOF
  [ -z "$m" ] && ok VP-15 'Nach dem Halt genau drei Auswege: Antwort aendern, Gespraech, zur Uebersicht — und kein vierter (K04-M08)' \
              || nok VP-15 "Die drei Auswege:$m"
fi
pruefe_sql_marke

# =====================================================================
# VP-16 · K04-D04 · Ein Check mit NICHT_GEEIGNET fuehrt nicht weiter:
#         es entsteht keine Anwendung und keine Angebotsanfrage,
#         fit_check.app_id bleibt leer (auch G06).
#
#         ZUR AUSLEGUNG: K04-D04 sagt "DARF NICHT ins Gespraech fuehren",
#         K04-M08 nennt als zweiten Ausweg ausdruecklich das "Gespraech
#         mit der Ansprechperson". Beide meinen Verschiedenes -- D04 das
#         gefuehrte Gespraech samt Anwendung und Angebotsanfrage
#         (Eigentuemer K01), M08 den Rueckweg zum Menschen. Gemessen wird
#         deshalb hier NUR der harte Teil: keine Anwendung, keine
#         Angebotsanfrage. Der Widerspruch ist im Bericht benannt.
# =====================================================================
if [ -z "$KEKS_HALT" ]; then
  sperr VP-16 'Nicht messbar: der Halt wurde nicht erreicht'
else
  apps="$(dbz "SELECT count(*) FROM app WHERE tenant_id='$MANDANT_A'")"
  appid="$(dbz "SELECT coalesce(c.app_id::text,'(leer)') FROM fit_check c JOIN actor a ON a.id=c.actor_id
                 WHERE a.email='vp_halt@vpruef.example'")"
  angebote="$(dbz "SELECT count(*) FROM event
                    WHERE tenant_id='$MANDANT_A' AND action ILIKE '%ANGEBOT%'")"
  m=""
  [ "$apps" = "0" ]      || m="$m es entstanden $apps Anwendungen im Mandanten, obwohl der Check NICHT_GEEIGNET ist;"
  [ "$appid" = "(leer)" ]|| m="$m fit_check.app_id traegt '$appid' statt leer (K04-G06);"
  [ "$angebote" = "0" ]  || m="$m es entstanden $angebote Ereignisse zur Angebotsanfrage;"
  [ -z "$m" ] && ok VP-16 'Nach dem Halt entsteht keine Anwendung und keine Angebotsanfrage, app_id bleibt leer (K04-D04, G06)' \
              || nok VP-16 "Nach dem Halt:$m"
fi
pruefe_sql_marke

# =====================================================================
# VP-19 · AUSWEG 3 (Nachrechnung M3) · zur Uebersicht
#         K04-D03 + K19 EN-04 zur_uebersicht + EN-02
#         Der Eignungs-Check bleibt mit seinem Ergebnis erhalten und ist
#         wieder aufrufbar. Keine Zeile wird getilgt.
#
#         Dieser Ausweg laeuft VOR Ausweg 1, weil Ausweg 1 den Check auf
#         OFFEN zuruecksetzt -- danach waere hier nichts mehr zu messen.
# =====================================================================
if [ -z "$KEKS_HALT" ]; then
  sperr VP-19 'Ausweg 3 nicht messbar: der Halt wurde nicht erreicht'
else
  vorher_zeilen="$(dbz "SELECT count(*) FROM fit_answer f JOIN fit_check c ON c.id=f.fit_check_id
                         JOIN actor a ON a.id=c.actor_id WHERE a.email='vp_halt@vpruef.example'")"
  vorher_stand="$(dbz "SELECT concat_ws('|', c.outcome::text, coalesce(c.completed_at::text,'(leer)'))
                        FROM fit_check c JOIN actor a ON a.id=c.actor_id
                       WHERE a.email='vp_halt@vpruef.example'")"
  st=$(hole /uebersicht vp19 "$KEKS_HALT")
  nachher_zeilen="$(dbz "SELECT count(*) FROM fit_answer f JOIN fit_check c ON c.id=f.fit_check_id
                          JOIN actor a ON a.id=c.actor_id WHERE a.email='vp_halt@vpruef.example'")"
  nachher_stand="$(dbz "SELECT concat_ws('|', c.outcome::text, coalesce(c.completed_at::text,'(leer)'))
                         FROM fit_check c JOIN actor a ON a.id=c.actor_id
                        WHERE a.email='vp_halt@vpruef.example'")"
  st2=$(hole /eignung vp19b "$KEKS_HALT")
  m=""
  [ "$st" = "200" ] || m="$m GET /uebersicht liefert $st statt 200;"
  [ "$vorher_stand" = "$nachher_stand" ] || m="$m der Check aenderte sich von '$vorher_stand' auf '$nachher_stand';"
  [ "$vorher_zeilen" = "$nachher_zeilen" ] || m="$m die Zahl der Antwortzeilen aenderte sich von $vorher_zeilen auf $nachher_zeilen (K04-D03);"
  [ "$st2" = "200" ] || m="$m der Check ist nach der Rueckkehr nicht wieder aufrufbar (GET /eignung liefert $st2);"
  # EN-02 zeigt den bestehenden Check mit seinem Ergebnis an. Gemessen
  # wird das Ergebnis in der Form, in der es in fit_check.outcome steht,
  # ODER in einer Fassung fuer Menschen -- eines von beidem muss der
  # Nutzer sehen, sonst ist der Check nicht "mit seinem Ergebnis" da.
  enthaelt vp19 'NICHT_GEEIGNET' || enthaelt vp19 'nicht geeignet' || enthaelt vp19 'Nicht geeignet' \
    || m="$m die Uebersicht zeigt den bestehenden Check nicht mit seinem Ergebnis (K19 EN-02);"
  [ -z "$m" ] && ok VP-19 'AUSWEG 3: zur Uebersicht — der Check bleibt mit Ergebnis erhalten, keine Zeile getilgt, er ist wieder aufrufbar (K04-D03, K19 EN-02/EN-04)' \
              || nok VP-19 "Ausweg 3 (zur Uebersicht):$m"
fi
pruefe_sql_marke

# =====================================================================
# VP-18 · AUSWEG 2 (Nachrechnung M3) · Termin
#         Wegetabelle + K04-M08 + K19 EN-04 termin
#         Es entsteht GENAU EINE event-Zeile mit action =
#         'TERMIN_ANGEFRAGT', mit Bezug auf den Check und im Mandanten
#         der Sitzung. Das Ergebnis des Checks bleibt UNVERAENDERT.
#
#         Laeuft ebenfalls vor Ausweg 1 -- gemessen wird "outcome bleibt
#         NICHT_GEEIGNET", und das geht nur am Halt.
# =====================================================================
if [ -z "$KEKS_HALT" ]; then
  sperr VP-18 'Ausweg 2 nicht messbar: der Halt wurde nicht erreicht'
else
  check_id="$(dbz "SELECT c.id::text FROM fit_check c JOIN actor a ON a.id=c.actor_id
                    WHERE a.email='vp_halt@vpruef.example'")"
  vorher_stand="$(dbz "SELECT concat_ws('|', c.outcome::text, coalesce(c.completed_at::text,'(leer)'))
                        FROM fit_check c WHERE c.id='$check_id'")"
  vorher_ereignisse="$(dbz "SELECT count(*) FROM event
                             WHERE action='TERMIN_ANGEFRAGT' AND tenant_id='$MANDANT_A'")"
  st=$(sende /eignung/termin vp18 "$KEKS_HALT")
  ziel="$(kopfzeile vp18 location)"
  nachher_ereignisse="$(dbz "SELECT count(*) FROM event
                              WHERE action='TERMIN_ANGEFRAGT' AND tenant_id='$MANDANT_A'")"
  mit_bezug="$(dbz "SELECT count(*) FROM event
                     WHERE action='TERMIN_ANGEFRAGT' AND tenant_id='$MANDANT_A'
                       AND (coalesce(object_ref,'') LIKE '%$check_id%'
                            OR coalesce(value,'')  LIKE '%$check_id%')")"
  nachher_stand="$(dbz "SELECT concat_ws('|', c.outcome::text, coalesce(c.completed_at::text,'(leer)'))
                         FROM fit_check c WHERE c.id='$check_id'")"
  apps="$(dbz "SELECT count(*) FROM app WHERE tenant_id='$MANDANT_A'")"
  m=""
  [ "$st" = "303" ] || m="$m Status $st statt 303;"
  case "$ziel" in *"/eignung"*) : ;; *) m="$m Location '$ziel' zeigt nicht auf /eignung;";; esac
  case "$ziel" in *"termin=1"*) : ;; *) m="$m Location '$ziel' traegt kein termin=1;";; esac
  [ $((nachher_ereignisse - vorher_ereignisse)) -eq 1 ] \
    || m="$m es entstanden $((nachher_ereignisse - vorher_ereignisse)) Ereignisse TERMIN_ANGEFRAGT statt genau einem;"
  [ "${mit_bezug:-0}" -ge 1 ] || m="$m kein Ereignis nimmt Bezug auf den Check $check_id;"
  [ "$vorher_stand" = "$nachher_stand" ] || m="$m das Ergebnis aenderte sich von '$vorher_stand' auf '$nachher_stand' -- der Termin darf es nicht anfassen;"
  [ "$apps" = "0" ] || m="$m es entstand eine Anwendung (K04-D04);"
  [ -z "$m" ] && ok VP-18 'AUSWEG 2: Termin — genau ein Ereignis TERMIN_ANGEFRAGT mit Bezug auf den Check, das Ergebnis bleibt unveraendert (K04-M08, Wegetabelle)' \
              || nok VP-18 "Ausweg 2 (Termin):$m"
fi
pruefe_sql_marke

# =====================================================================
# VP-17 · AUSWEG 1 (Nachrechnung M3) · Antwort aendern
#         Wegetabelle + K04-M15 + D03 + M12
#         Die aktive Antwort der aufhaltenden Frage wird zurueckgenommen:
#         superseded_at gesetzt, KEINE Zeile getilgt, outcome zurueck auf
#         OFFEN und completed_at wieder leer -- beides zusammen, sonst
#         schluege fit_done_needs_ts an.
#
#         Dieser Ausweg laeuft ZULETZT: er setzt den Halt zurueck.
# =====================================================================
if [ -z "$KEKS_HALT" ]; then
  sperr VP-17 'Ausweg 1 nicht messbar: der Halt wurde nicht erreicht'
else
  vorher_zeilen="$(dbz "SELECT count(*) FROM fit_answer f JOIN fit_check c ON c.id=f.fit_check_id
                         JOIN actor a ON a.id=c.actor_id WHERE a.email='vp_halt@vpruef.example'")"
  st=$(sende /eignung/aendern vp17 "$KEKS_HALT" "frage=${Q_CODE[$SPERR_I]}")
  ziel="$(kopfzeile vp17 location)"
  nachher_zeilen="$(dbz "SELECT count(*) FROM fit_answer f JOIN fit_check c ON c.id=f.fit_check_id
                          JOIN actor a ON a.id=c.actor_id WHERE a.email='vp_halt@vpruef.example'")"
  zurueckgenommen="$(dbz "SELECT count(*) FROM fit_answer f JOIN fit_check c ON c.id=f.fit_check_id
                           JOIN actor a ON a.id=c.actor_id
                          WHERE a.email='vp_halt@vpruef.example'
                            AND f.question_code='${Q_CODE[$SPERR_I]}'
                            AND f.option_id='${Q_NEIN[$SPERR_I]}'
                            AND f.superseded_at IS NOT NULL")"
  aktiv="$(dbz "SELECT count(*) FROM fit_answer f JOIN fit_check c ON c.id=f.fit_check_id
                 JOIN actor a ON a.id=c.actor_id
                WHERE a.email='vp_halt@vpruef.example'
                  AND f.question_code='${Q_CODE[$SPERR_I]}' AND f.superseded_at IS NULL")"
  stand="$(dbz "SELECT concat_ws('|', c.outcome::text, coalesce(c.completed_at::text,'(leer)'))
                 FROM fit_check c JOIN actor a ON a.id=c.actor_id
                WHERE a.email='vp_halt@vpruef.example'")"
  m=""
  [ "$st" = "303" ] || m="$m Status $st statt 303;"
  case "$ziel" in *"/eignung"*) : ;; *) m="$m Location '$ziel' zeigt nicht auf /eignung;";; esac
  [ "$vorher_zeilen" = "$nachher_zeilen" ] \
    || m="$m die Zahl der Antwortzeilen aenderte sich von $vorher_zeilen auf $nachher_zeilen -- eine Ruecknahme entfernt keine Zeile (K04-D03);"
  [ "$zurueckgenommen" = "1" ] || m="$m die aufhaltende Antwort traegt kein superseded_at (K04-M15);"
  [ "$aktiv" = "0" ] || m="$m nach dem Ruecknehmen bestehen $aktiv aktive Antworten auf die Frage statt keiner;"
  [ "$stand" = "OFFEN|(leer)" ] || m="$m der Check steht auf '$stand' statt 'OFFEN|(leer)' (Wegetabelle, K04-M12);"
  [ -z "$m" ] && ok VP-17 'AUSWEG 1: Antwort aendern — die alte Zeile traegt superseded_at und bleibt stehen, das Ergebnis faellt auf OFFEN ohne completed_at zurueck (K04-M15, D03, M12)' \
              || nok VP-17 "Ausweg 1 (Antwort aendern):$m"
fi
pruefe_sql_marke

# =====================================================================
# VP-20 · GEGENPROBE · K04-M13 + M12 + K19 EN-04 zustand_erfolg
#         Drei aktive Antworten, ALLE mit is_eligible = wahr: GEEIGNET
#         mit completed_at, kein Halt-Feld, und der Hinweis auf den
#         Zweckbestimmungs-Schritt (EN-04a, gebaut wird er in M4).
#
#         OHNE DIESEN FALL WAERE DIE GANZE PRUEFUNG WERTLOS: ein Server,
#         der auf alles NICHT_GEEIGNET antwortet, bestuende jeden
#         einzelnen Halt-Fall muehelos.
# =====================================================================
if [ "$WEG_FAHRBAR" != "1" ]; then
  sperr VP-20 "Die Gegenprobe ist nicht fahrbar:$WEG_GRUND"
elif ! anmelden 'vp_geeignet@vpruef.example' '810003' anm_geeignet; then
  sperr VP-20 "Die Gegenprobe ist nicht messbar: die Anmeldung von vp_geeignet@ scheiterte (Status $ANM_STATUS)"
else
  KEKS_GEEIGNET="$ANM_KEKS"
  sende /vorpruefung/ueberspringen vp20a "$KEKS_GEEIGNET" >/dev/null
  i=0
  while [ $i -lt $ANZ_FRAGEN ]; do
    antworte "$KEKS_GEEIGNET" $i ja "vp20b_$i" >/dev/null
    i=$((i+1))
  done
  st=$(sende /eignung/weiter vp20 "$KEKS_GEEIGNET")
  stand="$(dbz "SELECT concat_ws('|', c.outcome::text,
                      CASE WHEN c.completed_at IS NULL THEN '(leer)' ELSE '(gesetzt)' END)
                 FROM fit_check c JOIN actor a ON a.id=c.actor_id
                WHERE a.email='vp_geeignet@vpruef.example'")"
  st2=$(hole /eignung vp20c "$KEKS_GEEIGNET")
  apps="$(dbz "SELECT count(*) FROM app WHERE tenant_id='$MANDANT_A'")"
  m=""
  case "$st" in 200|303) : ;; *) m="$m POST /eignung/weiter liefert $st;";; esac
  [ "$stand" = "GEEIGNET|(gesetzt)" ] || m="$m der Check steht auf '$stand' statt 'GEEIGNET|(gesetzt)' (K04-M13, M12);"
  [ "$st2" = "200" ] || m="$m GET /eignung liefert $st2 statt 200;"
  formziele vp20c | grep -qx '/eignung/termin' \
    && m="$m nach GEEIGNET erscheinen die Auswege des Halts (K04-M08 gilt nur nach einem Halt);"
  enthaelt vp20c 'Zweckbestimmung' \
    || m="$m der Hinweis auf den Zweckbestimmungs-Schritt fehlt (K19 EN-04 zustand_erfolg, K04-M19);"
  [ "$apps" = "0" ] || m="$m es entstand bereits eine Anwendung -- die Anlage gehoert nach EN-04a und damit in M4;"
  [ -z "$m" ] && ok VP-20 'GEGENPROBE: drei zusagende Antworten ergeben GEEIGNET mit completed_at, ohne Halt, mit Hinweis auf die Zweckbestimmung (K04-M13, M12)' \
              || nok VP-20 "Gegenprobe GEEIGNET:$m"
fi
pruefe_sql_marke

# =====================================================================
# VP-21 · K04-D08 · Ein Eignungs-Check eines FREMDEN Mandanten gilt als
#         nicht vorhanden. Gemessen mit einem Konto des Mandanten A, das
#         SELBST keinen Check hat: sieht es den Check des Mandanten B,
#         ist der Mandantenschnitt offen. Zugleich der fail-closed-Fall
#         "ohne offenen Check" (K04-G04, Wegetabelle).
#         NEGATIVFALL -- verletzt ist allein die Mandantenzugehoerigkeit.
# =====================================================================
if ! anmelden 'vp_leer@vpruef.example' '810005' anm_leer; then
  sperr VP-21 "Der Mandantenschnitt ist nicht messbar: die Anmeldung von vp_leer@ scheiterte (Status $ANM_STATUS)"
else
  KEKS_LEER="$ANM_KEKS"
  eigene="$(dbz "SELECT count(*) FROM fit_check c JOIN actor a ON a.id=c.actor_id
                  WHERE a.email='vp_leer@vpruef.example'")"
  st=$(hole /uebersicht vp21 "$KEKS_LEER")
  st2=$(hole /eignung vp21b "$KEKS_LEER")
  ziel="$(kopfzeile vp21b location)"
  fremd_danach="$(dbz "SELECT concat_ws('|', outcome::text, tenant_id::text)
                        FROM fit_check WHERE id='$CHECK_FREMD'")"
  m=""
  [ "$eigene" = "0" ] || m="$m der Aufbau stimmt nicht: vp_leer@ traegt $eigene eigene Checks;"
  [ "$st" = "200" ] || m="$m GET /uebersicht liefert $st statt 200;"
  enthaelt vp21 "$CHECK_FREMD" && m="$m die Uebersicht zeigt den Check des fremden Mandanten (K04-D08);"
  [ "$st2" = "303" ] || m="$m GET /eignung ohne eigenen offenen Check liefert $st2 statt 303 (fail-closed, K04-G04);"
  case "$ziel" in *"/vorpruefung"*) : ;; *) m="$m Location '$ziel' zeigt nicht auf /vorpruefung;";; esac
  [ "$fremd_danach" = "NICHT_GEEIGNET|$MANDANT_B" ] \
    || m="$m der fremde Check steht nach dem Zugriff auf '$fremd_danach' -- er wurde veraendert;"
  [ -z "$m" ] && ok VP-21 'Der Check eines fremden Mandanten ist weder sichtbar noch erreichbar noch aenderbar; ohne eigenen Check fuehrt EN-04 zurueck auf EN-03 (K04-D08, G04)' \
              || nok VP-21 "Fremder Mandant:$m"
fi
pruefe_sql_marke

# =====================================================================
# VP-22 · K04-D01 · "Der Eignungs-Check DARF NICHT uebersprungen
#         werden. Ueberspringbar ist allein der Direkt-Prototyp-Check."
#         Gemessen als Abwesenheit: EN-04 bietet keinen Weg an, der den
#         Check ueberspringt, und solange er OFFEN ist, entsteht keine
#         Anwendung.
# =====================================================================
if [ -z "$KEKS_WEG" ]; then
  sperr VP-22 'Nicht messbar: keine Sitzung fuer vp_weg@'
else
  hole /eignung vp22 "$KEKS_WEG" >/dev/null
  m=""
  formziele vp22 | grep -qi 'ueberspring' && m="$m EN-04 bietet ein Formular zum Ueberspringen an;"
  linkziele vp22 | grep -qi 'ueberspring' && m="$m EN-04 verweist auf einen Weg zum Ueberspringen;"
  enthaelt vp22 'Ueberspringen' && m="$m EN-04 traegt die Schaltflaeche 'Ueberspringen';"
  offen="$(dbz "SELECT count(*) FROM fit_check c JOIN actor a ON a.id=c.actor_id
                 WHERE a.email='vp_weg@vpruef.example' AND c.outcome='OFFEN'")"
  apps="$(dbz "SELECT count(*) FROM app a JOIN fit_check c ON c.id=a.fit_check_id
                WHERE c.outcome <> 'GEEIGNET'")"
  m2=""
  [ "$offen" = "1" ] || m2=" der Aufbau stimmt nicht: der Check von vp_weg@ ist nicht mehr OFFEN;"
  [ "$apps" = "0" ] || m="$m es besteht eine Anwendung zu einem Check, der nicht GEEIGNET ist;"
  if [ -n "$m2" ]; then
    sperr VP-22 "Nicht messbar:$m2"
  else
    [ -z "$m" ] && ok VP-22 'Der Eignungs-Check ist nicht ueberspringbar: EN-04 bietet keinen solchen Weg, und ohne GEEIGNET entsteht keine Anwendung (K04-D01)' \
                || nok VP-22 "Ueberspringen des Eignungs-Checks:$m"
  fi
fi
pruefe_sql_marke

# =====================================================================
# VP-23 · K04-G10 · "Die Bildschirme EN-03 und EN-04 stammen aus K19
#         Abschn. 6 und werden hier nicht frei gezeichnet."
#         Gemessen: jeder serverseitige Weg dieser drei Bildschirme steht
#         in der Wegetabelle. Ein Formular auf ein Ziel, das dort nicht
#         steht, ist erfundener Umfang.
# =====================================================================
if [ -z "$KEKS_WEG" ]; then
  sperr VP-23 'Nicht messbar: keine Sitzung fuer vp_weg@'
else
  hole /uebersicht  vp23a "$KEKS_WEG" >/dev/null
  hole /vorpruefung vp23b "$KEKS_WEG" >/dev/null
  hole /eignung     vp23c "$KEKS_WEG" >/dev/null
  m=""
  while read -r z; do
    [ -n "$z" ] || continue
    case "$z" in
      /uebersicht/neu|/uebersicht|/abmelden|"") : ;;
      *) m="$m EN-02 fuehrt den nicht vereinbarten Weg '$z';";;
    esac
  done <<EOF
$(formziele vp23a)
EOF
  while read -r z; do
    [ -n "$z" ] || continue
    case "$z" in
      /vorpruefung/starten|/vorpruefung/ueberspringen|/vorpruefung|/abmelden|"") : ;;
      *) m="$m EN-03 fuehrt den nicht vereinbarten Weg '$z';";;
    esac
  done <<EOF
$(formziele vp23b)
EOF
  while read -r z; do
    [ -n "$z" ] || continue
    case "$z" in
      /eignung/antwort|/eignung/aendern|/eignung/weiter|/eignung/termin|/eignung|/uebersicht|/abmelden|"") : ;;
      *) m="$m EN-04 fuehrt den nicht vereinbarten Weg '$z';";;
    esac
  done <<EOF
$(formziele vp23c)
EOF
  [ -z "$m" ] && ok VP-23 'EN-02, EN-03 und EN-04 fuehren ausschliesslich die vereinbarten Wege — kein frei gezeichneter Umfang (K04-G10)' \
              || nok VP-23 "Erfundener Umfang:$m"
fi
pruefe_sql_marke

# =====================================================================
# VP-24 · K04-D05 · "Neben fit_check.outcome DARF kein zweiter
#         Eignungsstrang entstehen: kein gespiegeltes Kennzeichen, kein
#         zweites Ergebnisfeld, keine abgeleitete Spalte."
#         Gemessen an der Datenbank selbst: fit_check traegt genau die
#         Spalten aus Zielschema und M30, kein anderes Gebilde traegt den
#         Typ fit_outcome, und keine Spalte spiegelt die Eignung im Namen.
# =====================================================================
spalten="$(dbz "SELECT string_agg(column_name, ',' ORDER BY column_name)
                  FROM information_schema.columns
                 WHERE table_schema='public' AND table_name='fit_check'")"
fremdstrang="$(dbz "SELECT coalesce(string_agg(table_name||'.'||column_name, ' '),'')
                      FROM information_schema.columns
                     WHERE table_schema='public' AND udt_name='fit_outcome'
                       AND table_name <> 'fit_check'
                       AND table_name NOT LIKE 'pruef\_%'")"
spiegel="$(dbz "SELECT coalesce(string_agg(table_name||'.'||column_name, ' '),'')
                  FROM information_schema.columns
                 WHERE table_schema='public'
                   AND table_name NOT LIKE 'pruef\_%'
                   AND table_name <> 'fit_check'
                   AND column_name ~* '(geeignet|eignung|fit_ok|fit_status|fit_result|fit_ergebnis)'")"
erwartet='actor_id,app_id,completed_at,id,outcome,retention_class,started_at,tenant_id,zweckbestimmung_ack_at'
m=""
[ "$spalten" = "$erwartet" ] || m="$m fit_check traegt '$spalten' statt '$erwartet';"
[ -z "$fremdstrang" ] || m="$m ein zweites Ergebnisfeld vom Typ fit_outcome besteht: $fremdstrang;"
[ -z "$spiegel" ]     || m="$m ein gespiegeltes Eignungskennzeichen besteht: $spiegel;"
[ -z "$m" ] && ok VP-24 'Neben fit_check.outcome besteht kein zweiter Eignungsstrang — keine zusaetzliche Spalte, kein gespiegeltes Kennzeichen (K04-D05)' \
            || nok VP-24 "Zweiter Eignungsstrang:$m"
pruefe_sql_marke

# =====================================================================
# NEGATIVFAELLE GEGEN DIE DATENBANK
#
# Ein Negativfall gilt erst als bestanden, wenn er an SEINER EIGENEN
# Bedingung scheitert; die Fehlermeldung im Wortlaut ist Teil der
# Evidenz (Bauauftrag §9 Tor I Nr. 6). Deshalb wird hier nicht nur
# geprueft, DASS die Anweisung scheitert, sondern WORAN.
#
# Jede Anweisung laeuft in einer Transaktion, die immer zurueckgerollt
# wird -- gelaenge sie wider Erwarten, bliebe kein Schaden zurueck.
# =====================================================================

# ---------------------------------------------------------------------
# VP-25 · K04-M14 · Zwei nicht zurueckgenommene Antworten auf DIESELBE
#         Frage scheitern an der Teil-Eindeutigkeit fit_answer_aktiv_uq.
#         Bewusst mit einer ANDEREN Antwortmoeglichkeit derselben Frage:
#         mit derselben schluege der Primaerschluessel an, und der Fall
#         maesse die falsche Bedingung (F07).
# ---------------------------------------------------------------------
neg_frage="$(dbz "SELECT question_code FROM fit_answer
                   WHERE fit_check_id='$CHECK_NEGATIV' AND superseded_at IS NULL")"
neg_belegt="$(dbz "SELECT option_id::text FROM fit_answer
                    WHERE fit_check_id='$CHECK_NEGATIV' AND superseded_at IS NULL")"
neg_zweite="$(dbz "SELECT id::text FROM fit_option
                    WHERE question_code='$neg_frage' AND id::text <> '$neg_belegt'
                    ORDER BY position LIMIT 1")"
pruefe_sql_marke
if [ -z "$neg_frage" ] || [ -z "$neg_zweite" ]; then
  sperr VP-25 "Nicht messbar: der Katalog gibt keine Frage mit zwei Antwortmoeglichkeiten her (Frage '$neg_frage', zweite Moeglichkeit '$neg_zweite')"
else
  fehler="$(dbf "INSERT INTO fit_answer (fit_check_id, question_code, option_id)
                 VALUES ('$CHECK_NEGATIV','$neg_frage','$neg_zweite')")"
  m=""
  case "$fehler" in
    KEIN_FEHLER) m=" die zweite offene Antwort wurde ANGENOMMEN;";;
    *fit_answer_aktiv_uq*) : ;;
    *) m=" gescheitert, aber an einer fremden Bedingung: $fehler";;
  esac
  [ -z "$m" ] && ok VP-25 "Zwei nicht zurueckgenommene Antworten auf dieselbe Frage scheitern an fit_answer_aktiv_uq (K04-M14) — Meldung: $(printf '%s' "$fehler" | head -c 160)" \
              || nok VP-25 "Zweite offene Antwort:$m"
fi
pruefe_sql_marke

# ---------------------------------------------------------------------
# VP-26 · K04-M12 · Ein Ergebnis ungleich OFFEN ohne completed_at
#         scheitert an der Bedingung fit_done_needs_ts.
# ---------------------------------------------------------------------
fehler="$(dbf "UPDATE fit_check SET outcome='NICHT_GEEIGNET', completed_at=NULL
                WHERE id='$CHECK_NEGATIV'")"
m=""
case "$fehler" in
  KEIN_FEHLER) m=" ein abgeschlossener Check ohne completed_at wurde ANGENOMMEN;";;
  *fit_done_needs_ts*) : ;;
  *) m=" gescheitert, aber an einer fremden Bedingung: $fehler";;
esac
[ -z "$m" ] && ok VP-26 "NICHT_GEEIGNET ohne completed_at scheitert an fit_done_needs_ts (K04-M12) — Meldung: $(printf '%s' "$fehler" | head -c 160)" \
            || nok VP-26 "Ergebnis ohne Zeitstempel:$m"
pruefe_sql_marke

# ---------------------------------------------------------------------
# VP-27 · K04-M11 · outcome fuehrt AUSSCHLIESSLICH OFFEN, GEEIGNET und
#         NICHT_GEEIGNET. Ein vierter Wert wird abgewiesen.
# ---------------------------------------------------------------------
fehler="$(dbf "UPDATE fit_check SET outcome='VIELLEICHT', completed_at=now()
                WHERE id='$CHECK_NEGATIV'")"
m=""
case "$fehler" in
  KEIN_FEHLER) m=" ein vierter Ergebniswert wurde ANGENOMMEN;";;
  *fit_outcome*) : ;;
  *) m=" gescheitert, aber an einer fremden Bedingung: $fehler";;
esac
[ -z "$m" ] && ok VP-27 "Ein vierter Ergebniswert wird vom Typ fit_outcome abgewiesen (K04-M11) — Meldung: $(printf '%s' "$fehler" | head -c 160)" \
            || nok VP-27 "Vierter Ergebniswert:$m"
pruefe_sql_marke

# ---------------------------------------------------------------------
# VP-28 · K04-M10 · "Verweis auf tenant mit Loeschsperre."
#         Am Mandanten der Loeschsperre haengt AUSSCHLIESSLICH ein
#         Eignungs-Check -- deshalb kann der Loeschversuch nur an dessen
#         Sperre scheitern und an keiner anderen (F07).
# ---------------------------------------------------------------------
fehler="$(dbf "DELETE FROM tenant WHERE id='$MANDANT_L'")"
m=""
case "$fehler" in
  KEIN_FEHLER) m=" der Mandant liess sich loeschen, obwohl ein Eignungs-Check an ihm haengt;";;
  *fit_check*) : ;;
  *) m=" gescheitert, aber an einer fremden Bedingung: $fehler";;
esac
[ -z "$m" ] && ok VP-28 "Ein Mandant mit Eignungs-Check ist nicht loeschbar — die Loeschsperre von fit_check greift (K04-M10) — Meldung: $(printf '%s' "$fehler" | head -c 160)" \
            || nok VP-28 "Loeschsperre des Mandanten:$m"
pruefe_sql_marke

# ---------------------------------------------------------------------
# VP-29 · K04-G08 · "Eine benutzte Frage oder Antwortmoeglichkeit ist
#         nicht entfernbar -- fit_answer haelt beide mit einer
#         Loeschsperre fest."
# ---------------------------------------------------------------------
if [ -z "$neg_belegt" ]; then
  sperr VP-29 'Nicht messbar: es besteht keine benutzte Antwortmoeglichkeit'
else
  fehler="$(dbf "DELETE FROM fit_option WHERE id='$neg_belegt'")"
  m=""
  case "$fehler" in
    KEIN_FEHLER) m=" eine benutzte Antwortmoeglichkeit liess sich entfernen;";;
    *fit_answer*) : ;;
    *) m=" gescheitert, aber an einer fremden Bedingung: $fehler";;
  esac
  fehler2="$(dbf "DELETE FROM fit_question WHERE code='$neg_frage'")"
  case "$fehler2" in
    KEIN_FEHLER) m="$m eine benutzte Frage liess sich entfernen;";;
    *fit_answer*) : ;;
    *) m="$m Frage: gescheitert, aber an einer fremden Bedingung: $fehler2";;
  esac
  [ -z "$m" ] && ok VP-29 "Benutzte Frage und benutzte Antwortmoeglichkeit sind nicht entfernbar (K04-G08) — Meldung: $(printf '%s' "$fehler" | head -c 120)" \
              || nok VP-29 "Loeschsperre des Katalogs:$m"
fi
pruefe_sql_marke

# ---------------------------------------------------------------------
# VP-30 · K04-M04 + M06 + G04 · Eine Antwortmoeglichkeit gehoert zu
#         GENAU EINER Frage. Wird eine Frage mit der Moeglichkeit einer
#         ANDEREN Frage beantwortet, muss der Server das abweisen: die
#         Datenbank haelt es nicht auf, fit_answer verweist auf Frage und
#         Moeglichkeit getrennt. Fail-closed heisst, der Server prueft es.
#         NEGATIVFALL -- verletzt ist allein die Zugehoerigkeit.
# ---------------------------------------------------------------------
if [ -z "$KEKS_WEG" ] || [ "$ANZ_FRAGEN" -lt 2 ] || [ -z "${Q_JA[1]}" ]; then
  sperr VP-30 'Nicht messbar: keine Sitzung fuer vp_weg@, weniger als zwei Fragen im Katalog oder die zweite Frage fuehrt keine zusagende Antwortmoeglichkeit'
else
  vorher="$(dbz "SELECT count(*) FROM fit_answer f JOIN fit_check c ON c.id=f.fit_check_id
                  JOIN actor a ON a.id=c.actor_id
                 WHERE a.email='vp_weg@vpruef.example' AND f.question_code='${Q_CODE[0]}'")"
  st=$(sende /eignung/antwort vp30 "$KEKS_WEG" "frage=${Q_CODE[0]}" "option=${Q_JA[1]}")
  nachher="$(dbz "SELECT count(*) FROM fit_answer f JOIN fit_check c ON c.id=f.fit_check_id
                   JOIN actor a ON a.id=c.actor_id
                  WHERE a.email='vp_weg@vpruef.example' AND f.question_code='${Q_CODE[0]}'")"
  falsch="$(dbz "SELECT count(*) FROM fit_answer f
                  JOIN fit_option o ON o.id=f.option_id
                 WHERE f.question_code <> o.question_code")"
  m=""
  case "$st" in
    2*|4*) : ;;
    303) m="$m die fremde Antwortmoeglichkeit wurde mit 303 angenommen;";;
    5*)  m="$m Status $st -- abgewiesen wird sie damit nicht, der Weg stuerzt ab;";;
    *)   m="$m unerwarteter Status $st;";;
  esac
  [ "$vorher" = "$nachher" ] || m="$m es entstand eine Antwortzeile aus einer fremden Antwortmoeglichkeit ($vorher -> $nachher);"
  [ "$falsch" = "0" ] || m="$m es bestehen $falsch Antwortzeilen, deren Moeglichkeit zu einer anderen Frage gehoert;"
  [ -z "$m" ] && ok VP-30 'Eine Antwortmoeglichkeit einer anderen Frage wird abgewiesen — die Datenbank haelt das nicht auf, der Server muss es (K04-M04, M06, G04)' \
              || nok VP-30 "Fremde Antwortmoeglichkeit:$m"
fi
pruefe_sql_marke

# ---------------------------------------------------------------------
# VP-31 · K04-G07 · "fit_check.actor_id wird beim Entfernen des Kontos
#         geleert. Der Nachweis ueberlebt das Konto."
#         Laeuft zuletzt: das Konto vp_geloescht@ wird dabei entfernt und
#         von vorpruefung_daten.sql beim naechsten Lauf neu angelegt.
# ---------------------------------------------------------------------
vorher="$(dbz "SELECT count(*) FROM fit_check WHERE id='$CHECK_GELOESCHT'")"
pruefe_sql_marke
if [ "$vorher" != "1" ]; then
  sperr VP-31 "Nicht messbar: der vorbereitete Check $CHECK_GELOESCHT fehlt"
elif ! db "DELETE FROM actor WHERE email='vp_geloescht@vpruef.example'" >/dev/null 2>&1; then
  rm -f "$ARBEIT/sql.marke"
  sperr VP-31 'Nicht messbar: das Konto liess sich nicht entfernen (fremde Bedingung, siehe stderr)'
else
  zeile="$(dbz "SELECT concat_ws('|', coalesce(actor_id::text,'(leer)'), outcome::text, retention_class::text)
                  FROM fit_check WHERE id='$CHECK_GELOESCHT'")"
  m=""
  case "$zeile" in
    "(leer)|OFFEN|KI_NACHWEIS") : ;;
    "") m=" der Eignungs-Check wurde mit dem Konto entfernt -- der Nachweis ueberlebt es nicht;";;
    *)  m=" der Check steht auf '$zeile' statt '(leer)|OFFEN|KI_NACHWEIS';";;
  esac
  [ -z "$m" ] && ok VP-31 'Wird das Konto entfernt, bleibt der Eignungs-Check bestehen und actor_id wird geleert (K04-G07)' \
              || nok VP-31 "Nachweis nach Kontoloeschung:$m"
fi
pruefe_sql_marke

# =====================================================================
printf '\n'
[ "$gesperrt" -gt 0 ] && printf 'davon GESPERRT (nicht messbar, zaehlt nach K23-M22 nicht als bestanden): %s\n' "$gesperrt"
printf 'SUMME: %s von %s bestanden, %s gescheitert\n' "$bestanden" "$gesamt" "$gescheitert"
[ "$gescheitert" -eq 0 ]
