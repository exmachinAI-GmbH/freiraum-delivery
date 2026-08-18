#!/usr/bin/env bash
# =====================================================================
# FREIRAUM · Scheibe 2, zweiter Teil · M4 "Die Zweckbestimmung"
# Klauselpruefung gegen einen LAUFENDEN Server
#
# Geschrieben gegen K04-M08, M17, M18, M19, M20, M21, D06, D08, D09,
# D10, G12 · K01-M27, M38, D19 · K19-M06, M14 · den Bildschirmvertrag
# schema/K19_screens.yaml (EN-04a) und schema/freiraum_datamodel.sql --
# NICHT gegen den Umsetzungscode. Der Prueffall kennt den Server nur
# durch seine Tueren.
#
# Aufruf:
#   psql ... -f pruefungen/klauseln/zweckbestimmung_daten.sql       # Daten
#   FREIRAUM_PRUEF_URL=http://localhost:8099 \
#   FREIRAUM_CODE_PFEFFER=... \
#   pruefungen/klauseln/zweckbestimmung_lauf.sh                     # Faelle
#
# Umgebung:
#   FREIRAUM_PRUEF_URL    Vorgabe http://localhost:8099
#   FREIRAUM_CODE_PFEFFER wie am Server gesetzt -- der Lauf stellt sich
#                         seine Anmeldecodes selbst aus (K03-M15)
#   FREIRAUM_ZWECK_PFAD   OPTIONAL. Der Lauf ENTDECKT den Bildschirm
#                         selbst; diese Angabe ist nur der Notausgang,
#                         wenn die Entdeckung nicht traegt.
#   PGHOST/PGPORT/PGUSER/PGPASSWORD/PGDATABASE
#
# ---------------------------------------------------------------------
# DER FEHLER, GEGEN DEN DIESE DATEI GEBAUT IST
# ---------------------------------------------------------------------
# Am 02.08.2026 scheiterten drei von vier Negativfaellen an einer
# Formatpruefung statt an der Zielbedingung: bestandene Tests, die nichts
# gemessen haben. Am 15.08.2026 ist derselbe Fehler noch einmal
# aufgetreten -- Faelle, die einen Text suchten, der ohnehin auf der
# Seite steht.
#
# DARAUS FOLGEN ZWEI ARBEITSREGELN, DIE HIER DURCHGEHALTEN WERDEN:
#
#   1. GEMESSEN WIRD EINE UNTERSCHEIDUNG, KEIN VORKOMMEN.
#      Kein Fall dieser Datei fragt "steht dieser Text irgendwo".
#      Gemessen wird immer gegen einen ZWEITEN Lauf desselben
#      Bildschirms, der sich nur in der Antwort unterscheidet:
#
#        die Warnung zu Anhang III steht auf der Seite nach
#        (Frage 1 JA, Frage 2 NEIN)  -- und NICHT auf der Seite nach
#        (Frage 1 NEIN, Frage 2 NEIN) und NICHT auf der Halt-Seite.
#
#      Eine Seite, die beides immer zeigt, faellt damit durch. Eine
#      Seite, die nur Vokabeln enthaelt, ebenso.
#
#   2. DIE ADRESSEN WERDEN ENTDECKT, NICHT GERATEN.
#      Der Bildschirmvertrag K19_screens.yaml nennt Aktionen und
#      Serverbefehle, aber keine Adressen. Wer sie raet, misst im besten
#      Fall einen 404 -- also eine FREMDE Bedingung. Dieser Lauf faehrt
#      deshalb wie eine Nutzerin: er folgt der Weiterleitung nach
#      GEEIGNET, liest die Formulare der Seite und leitet die Ziele aus
#      dem UNTERSCHIED zwischen drei Faelle ab:
#
#        Ziel "Weiter"        = das Ziel, das erst erscheint, wenn BEIDE
#                               Fragen beantwortet sind
#        Ziel "Kenntnisnahme" = das Ziel, das nur nach Treffer in
#                               Frage 1 erscheint
#        Ziel "Anlage"        = das Ziel, das nur erscheint, wenn der
#                               Weg frei ist
#
#      Diese Ableitung ist zugleich die Messung: erscheint "Weiter"
#      schon bei einer Antwort, faellt F5 durch; erscheint "Anlage"
#      schon vor der Kenntnisnahme, faellt F2 durch.
#      Laesst sich ein Ziel nicht eindeutig bestimmen, meldet jeder
#      Fall, der es braucht, GESPERRT -- nie bestanden (K23-M22).
#
# ---------------------------------------------------------------------
# WAS DIESE DATEI NICHT MESSEN KANN -- und warum das hier steht
# ---------------------------------------------------------------------
#   * Den WORTLAUT der beiden Zweckfragen. K04-M19 beschreibt sie
#     inhaltlich ("Bewerbung, Beschaeftigung, Kreditwuerdigkeit,
#     Versicherung, Bildung, Biometrie" gegen "Gefuehle, soziales
#     Verhalten, Schwaechen wegen Alter, Behinderung oder Notlage,
#     Gesichter ungezielt"), zeichnet aber keinen Satz. Der Lauf misst
#     deshalb, dass die beiden Fragen an diesen Merkmalen
#     UNTERSCHEIDBAR sind -- nicht, dass sie einen bestimmten Satz
#     tragen.
#   * currency = EUR aus K01-M27. Das Datenmodell fuehrt die Waehrung an
#     app mit Vorgabe EUR und kennt keinen Mandanten mit einer anderen;
#     ein Fall dazu haette nichts, wogegen er scheitern koennte.
#     Ausgewiesen als GESPERRT.
# =====================================================================

BASIS="${FREIRAUM_PRUEF_URL:-http://localhost:8099}"

: "${PGHOST:=localhost}"
: "${PGPORT:=55433}"
: "${PGUSER:=postgres}"
: "${PGPASSWORD:=pilot}"
: "${PGDATABASE:=freiraum_pruef}"
export PGHOST PGPORT PGUSER PGPASSWORD PGDATABASE

MANDANT_A='00000000-0000-4000-8000-00000000fb02'   # der Mandant der Sitzung
MANDANT_B='00000000-0000-4000-8000-00000000fb03'   # der fremde Mandant
MANDANT_X='00000000-0000-4000-8000-00000000fb04'   # ausserhalb DE
CHECK_GEEIGNET='00000000-0000-4000-8000-00000000fc01'
CHECK_OFFEN='00000000-0000-4000-8000-00000000fc02'
CHECK_FREMD='00000000-0000-4000-8000-00000000fc03'
CHECK_GESPERRT='00000000-0000-4000-8000-00000000fc04'
CHECK_AUSLAND='00000000-0000-4000-8000-00000000fc05'
KONTO_DB='00000000-0000-4000-8000-00000000aa15'
KONTO_FREMD='00000000-0000-4000-8000-00000000aa14'
KONTO_GESPERRT='00000000-0000-4000-8000-00000000aa16'

ARBEIT="$(mktemp -d "${TMPDIR:-/tmp}/freiraum_zweck.XXXXXX")"
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
# Datenbank -- gehaertete Fassung, uebernommen aus den Nachbardateien
# (Befund S1/S3 vom 14.08.2026): bei einem SQL-Fehler gibt db()/dbz()
# NICHTS auf stdout aus und legt $ARBEIT/sql.marke an. Sonst laese ein
# "[ -z ... ]"-Test den leeren Fehlerfall als "alles in Ordnung".
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

# Aus einer Location-Kopfzeile den PFAD machen -- ohne Wirt, ohne
# Abfrageteil, ohne Anker. Der Lauf vergleicht nur Pfade.
nur_pfad() {         # $1 adresse
  printf '%s' "$1" | sed -e 's|^https\{0,1\}://[^/]*||' -e 's|[?#].*$||'
}

# ---------------------------------------------------------------------
# Werkzeug: Text
#
# Verglichen wird gegen den Rumpf MIT AUFGELOESTEN HTML-Entitaeten.
# Sonst scheiterte ein Fall daran, dass "Art. 5 & Anhang III" als
# "Art. 5 &amp; Anhang III" ankommt -- also an der Zeichenkodierung
# statt an der Klausel (F07).
# ---------------------------------------------------------------------
# Ohne Ruecksicht auf Gross- und Kleinschreibung und mit zusammen-
# gezogenem Leerraum. Fuer Wendungen, deren Schreibweise der Bau frei
# waehlt ("Anhang III" / "anhang iii").
enthaelt_lose() {    # $1 name  $2 text
  python3 - "$ARBEIT/$1.rumpf" "$2" <<'PY'
import html, re, sys
t = html.unescape(open(sys.argv[1], encoding="utf-8", errors="replace").read())
t = re.sub(r'<[^>]*>', ' ', t)
t = re.sub(r'\s+', ' ', t).lower()
s = re.sub(r'\s+', ' ', sys.argv[2]).lower()
sys.exit(0 if s in t else 1)
PY
}

# Welche der fuenf Artikel aus K04-M20 sind als ARTIKEL benannt?
# Gesucht wird "Art. 9", "Artikel 11", "Art 14" -- nicht die blosse
# Ziffer irgendwo auf der Seite. Ohne diese Einengung bestuende der Fall
# an jeder Seite, auf der zufaellig eine 9 steht.
artikelliste() {     # $1 name -> je Zeile eine gefundene Artikelnummer
  python3 - "$ARBEIT/$1.rumpf" <<'PY'
import html, re, sys
t = html.unescape(open(sys.argv[1], encoding="utf-8", errors="replace").read())
t = re.sub(r'<[^>]*>', ' ', t)
t = re.sub(r'\s+', ' ', t)
roh = set()
for m in re.finditer(r'\bArt(?:ikel|\.)?\s*((?:\d+\s*(?:,|und|;|\band\b)\s*)*\d+)', t, re.I):
    for n in re.findall(r'\d+', m.group(1)):
        roh.add(n)
for n in sorted(roh, key=int):
    print(n)
PY
}

# ---------------------------------------------------------------------
# Werkzeug: DER BEREICH (der Hinweis bei unvollstaendiger Antwort)
#
# WARUM ES IHN GIBT. "Der Text steht irgendwo auf der Seite" misst auf
# EN-04a nichts: der Bildschirm zeigt nach K19 EN-04a BEIDE Fragen, also
# ohnehin jeden ihrer Wortlaute. Ob die noch fehlende Frage BENANNT ist
# (K19-M06), laesst sich nur dort entscheiden, wo der Hinweis steht.
#
# WIE DER BEREICH ABGEGRENZT WIRD. Ueber dieselbe Marke, gegen die schon
# die Vorpruefung derselben Scheibe misst:
#
#     <div id="hinweis">   der Hinweis bei unvollstaendiger Antwort
#
# Eine Marke haengt an keinem Seitenzustand. FAIL-CLOSED: laesst sich
# der Bereich nicht abgrenzen (Marke fehlt, steht mehrfach oder wird
# nicht geschlossen), meldet der Fall GESPERRT -- nie bestanden.
# ---------------------------------------------------------------------
bereich_py() {       # $1 name  $2 marke  $3 auftrag (herkunft|enthaelt)  [$4 text]
  python3 - "$ARBEIT/$1.rumpf" "$2" "$3" "${4:-}" <<'PY'
import html, re, sys
roh = open(sys.argv[1], encoding="utf-8", errors="replace").read()
marke, auftrag, text = sys.argv[2], sys.argv[3], sys.argv[4]

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
    anfang = oeffner[0].end()
    tiefe = 1
    for m in re.finditer(r'<\s*(/?)\s*div\b[^>]*>', roh[anfang:], re.I):
        tiefe += -1 if m.group(1) else 1
        if tiefe == 0:
            ende = anfang + m.start()
            break
    herkunft = 'MARKE' if ende >= 0 else 'UNGESCHLOSSEN'

bereich = html.unescape(roh[anfang:ende]) if herkunft == 'MARKE' else ''
bereich = re.sub(r'\s+', ' ', re.sub(r'<[^>]*>', ' ', bereich)).lower()

if auftrag == 'herkunft':
    print(herkunft)
else:
    # fail-closed: ohne abgegrenzten Bereich enthaelt er nichts
    s = re.sub(r'\s+', ' ', text).lower()
    sys.exit(0 if herkunft == 'MARKE' and s and s in bereich else 1)
PY
}
im_bereich()       { bereich_py "$1" "$2" enthaelt "$3"; }
bereich_herkunft() { bereich_py "$1" "$2" herkunft; }

bereich_sperrgrund() {   # $1 herkunft  $2 marke
  case "$1" in
    FEHLT)         printf 'die Seite fuehrt keinen mit <div id="%s"> benannten Bereich' "$2";;
    MEHRDEUTIG)    printf 'die Seite fuehrt die Marke <div id="%s"> mehr als einmal -- welcher Bereich gemeint ist, ist nicht entscheidbar' "$2";;
    UNGESCHLOSSEN) printf 'der Bereich <div id="%s"> wird nicht geschlossen -- wo er endet, ist nicht entscheidbar' "$2";;
    *)             printf 'die Lage des Bereichs <div id="%s"> ist unbekannt (%s)' "$2" "$1";;
  esac
}

# Die Merkmale, an denen K04-M19 die beiden Fragen unterscheidet.
# "Bildung" und "bewerten" stehen in BEIDEN Aufzaehlungen und taugen
# deshalb nicht -- sie sind mit Absicht nicht dabei.
MERKMAL_F1=('Bewerbung' 'Beschäftigung' 'Beschaeftigung' 'Kreditwürdigkeit' 'Kreditwuerdigkeit' 'Versicherung' 'Biometrie' 'biometrisch' 'Anhang III')
MERKMAL_F2=('Gefühle' 'Gefuehle' 'Emotion' 'sozialem Verhalten' 'soziales Verhalten' 'Schwächen' 'Schwaechen' 'Notlage' 'Behinderung' 'Gesichter' 'ungezielt' 'Artikel 5' 'Art. 5')

# Wie viele Merkmale einer Frage stehen im benannten Bereich?
merkmale_im_bereich() {   # $1 name  $2 marke  $3 F1|F2  -> Anzahl
  local n=0 w
  if [ "$3" = "F1" ]; then
    for w in "${MERKMAL_F1[@]}"; do im_bereich "$1" "$2" "$w" && n=$((n+1)); done
  else
    for w in "${MERKMAL_F2[@]}"; do im_bereich "$1" "$2" "$w" && n=$((n+1)); done
  fi
  printf '%s' "$n"
}

# Alle Ziele der Seite: Formularziele UND Verweisziele, als reine Pfade,
# ohne Dubletten. Anker, leere Ziele und Fremdadressen fallen weg -- sie
# sind keine Wege im Sinne der Wegetabelle.
zieltexte() {        # $1 name -> je Zeile ein Pfad
  python3 - "$ARBEIT/$1.rumpf" <<'PY'
import html, re, sys
t = html.unescape(open(sys.argv[1], encoding="utf-8", errors="replace").read())
z = []
for m in re.finditer(r'<form[^>]*\baction\s*=\s*["\']?([^"\'\s>]*)', t, re.I):
    z.append(m.group(1))
for m in re.finditer(r'<a[^>]*\bhref\s*=\s*["\']?([^"\'\s>]*)', t, re.I):
    z.append(m.group(1))
raus, gesehen = [], set()
for w in z:
    w = re.sub(r'^https?://[^/]*', '', w)
    w = re.sub(r'[?#].*$', '', w)
    if not w or not w.startswith('/'):
        continue
    if w not in gesehen:
        gesehen.add(w); raus.append(w)
for w in raus:
    print(w)
PY
}

fuehrt_zu() {        # $1 name  $2 ziel -> 0, wenn ein Weg dorthin fuehrt
  zieltexte "$1" | grep -qx -- "$2"
}

# ---------------------------------------------------------------------
# Werkzeug: DIE FELDER DES BILDSCHIRMS
#
# WOZU. K04-M19 verlangt ZWEI GETRENNTE Fragen. "Getrennt" ist keine
# Frage der Formulierung, sondern der Bedienung: es muss zwei eigene
# Eingaben geben, jede mit eigener Ja/Nein-Wahl. Ein einziges Feld mit
# drei Auswahlmoeglichkeiten waere eine Frage, kein Paar.
#
# WIE UNTERSCHIEDEN WIRD, welches Feld welche Frage ist -- ausschliesslich
# aus K04-M19, nie aus Kenntnis des Umsetzungscodes:
#
#   Frage 1 (Anhang III) nennt Bewerbung, Beschaeftigung,
#           Kreditwuerdigkeit, Versicherung, Biometrie.
#   Frage 2 (Art. 5)     nennt Gefuehle, soziales Verhalten, Schwaechen
#           wegen Alter, Behinderung oder Notlage, Gesichter ungezielt.
#
# Das Wort "Bildung" steht in BEIDEN Aufzaehlungen und taugt deshalb
# nicht zur Unterscheidung; es ist bewusst nicht in den Merkmalen.
# Ebenso "bewerten" -- es kommt in beiden vor.
#
# FAIL-CLOSED. Laesst sich ein Feld nicht zuordnen, oder traegt eine
# Frage keine unterscheidbare Ja- und Nein-Wahl, meldet der Fall
# GESPERRT -- nie bestanden.
# ---------------------------------------------------------------------
felder() {           # $1 name
                     # -> FELD|name|typ|aktion|klasse|jawert|neinwert
                     #    HIDDEN|name|wert
  python3 - "$ARBEIT/$1.rumpf" <<'PY'
import html, re, sys

roh = open(sys.argv[1], encoding="utf-8", errors="replace").read()

M1 = ['bewerbung', 'beschäftig', 'beschaeftig', 'kreditwürdig', 'kreditwuerdig',
      'versicherung', 'biometri', 'anhang iii', 'anhang 3', 'hochrisiko']
M2 = ['gefühl', 'gefuehl', 'emotion', 'sozialem verhalten', 'soziales verhalten',
      'social scoring', 'schwäch', 'schwaech', 'notlage', 'behinderung',
      'gesichter', 'ungezielt', 'verbotene praktik', 'artikel 5', 'art. 5']

JA   = {'ja', 'j', 'yes', 'y', 'true', 'wahr', '1', 'ja_treffer', 'treffer'}
NEIN = {'nein', 'n', 'no', 'false', 'falsch', '0', 'kein_treffer', 'ohne_treffer'}


def attr(tag, name):
    m = re.search(r'\b' + name + r'\s*=\s*(?:"([^"]*)"|\'([^\']*)\'|([^\s"\'>]+))', tag, re.I)
    if not m:
        return ''
    return (m.group(1) or m.group(2) or m.group(3) or '').strip()


def klartext(s):
    s = html.unescape(re.sub(r'<[^>]*>', ' ', s))
    return re.sub(r'\s+', ' ', s).strip().lower()


# Formularbereiche: Ziel je Stelle im Dokument
bereiche = []
for m in re.finditer(r'<form\b[^>]*>(.*?)</form\s*>', roh, re.I | re.S):
    bereiche.append((m.start(), m.end(), attr(m.group(0)[:m.group(0).find('>') + 1], 'action')))


def ziel_bei(pos):
    for a, e, z in bereiche:
        if a <= pos < e:
            return z or '(leer)'
    return '(ohne Formular)'


# Alle Eingaben in Dokumentreihenfolge
eingaben = []          # (pos, name, typ, wert, beschriftung)
for m in re.finditer(r'<input\b[^>]*>', roh, re.I):
    tag = m.group(0)
    name = attr(tag, 'name')
    if not name:
        continue
    typ = (attr(tag, 'type') or 'text').lower()
    wert = attr(tag, 'value')
    folge = klartext(roh[m.end():m.end() + 120])
    eingaben.append((m.start(), name, typ, wert, folge))

for m in re.finditer(r'<select\b[^>]*>(.*?)</select\s*>', roh, re.I | re.S):
    kopf = m.group(0)[:m.group(0).find('>') + 1]
    name = attr(kopf, 'name')
    if not name:
        continue
    for o in re.finditer(r'<option\b[^>]*>(.*?)</option\s*>', m.group(1), re.I | re.S):
        wert = attr(o.group(0)[:o.group(0).find('>') + 1], 'value')
        beschriftung = klartext(o.group(1))
        if not wert:
            wert = beschriftung
        eingaben.append((m.start(), name, 'select', wert, beschriftung))

# Verborgene Felder gehen unveraendert mit -- sonst scheiterte ein POST
# an einer FREMDEN Bedingung (fehlendes Pflichtfeld) statt an der
# geprueften (F07).
for pos, name, typ, wert, _ in eingaben:
    if typ == 'hidden':
        print('HIDDEN|%s|%s' % (name, wert))

sichtbar = [e for e in eingaben if e[2] in ('radio', 'checkbox', 'select')]

# Reihenfolge der Feldnamen nach ihrem ersten Auftreten
namen = []
for _, name, _, _, _ in sichtbar:
    if name not in namen:
        namen.append(name)

erstes = {n: min(p for p, nm, _, _, _ in sichtbar if nm == n) for n in namen}


def umfeld(name):
    """Der Text VOR dem Feld -- bis zum vorigen Feld. Dort steht die Frage."""
    a = 0
    for n2 in namen:
        if n2 != name and erstes[n2] < erstes[name]:
            a = max(a, erstes[n2])
    return klartext(roh[a:erstes[name]])


for name in namen:
    stellen = [e for e in sichtbar if e[1] == name]
    typ = stellen[0][2]
    text = umfeld(name)
    t1 = sum(1 for w in M1 if w in text)
    t2 = sum(1 for w in M2 if w in text)
    klasse = 'F1' if t1 > t2 else ('F2' if t2 > t1 else '?')

    ja = nein = ''
    for _, _, _, wert, beschriftung in stellen:
        w = (wert or '').strip().lower()
        b = (beschriftung or '').strip().lower()
        if not ja and (w in JA or b.startswith('ja')):
            ja = wert
        elif not nein and (w in NEIN or b.startswith('nein')):
            nein = wert
    if typ == 'checkbox' and len(stellen) == 1 and not nein:
        # Ein einzelnes Ankreuzfeld: gesetzt = ja, weggelassen = nein.
        ja = ja or stellen[0][3] or 'on'
        nein = '(weglassen)'

    print('FELD|%s|%s|%s|%s|%s|%s' % (name, typ, ziel_bei(erstes[name]), klasse, ja, nein))
PY
}

# ---------------------------------------------------------------------
# Werkzeug: Anmeldung
# Der Lauf stellt sich seine Codes selbst aus -- damit er wiederholbar
# ist und nicht davon abhaengt, welcher Code beim letzten Mal verbraucht
# wurde (K03-M15).
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

if [ "$(hole /gesundheit zb_gesund)" != "200" ]; then
  abbruch "Server unter $BASIS antwortet nicht auf GET /gesundheit. Erst starten, dann pruefen."
fi

lage="$(dbz "SELECT count(*) FROM pg_views WHERE viewname='pruef_zweck_lage'")"
pruefe_sql_marke
[ "$lage" = "1" ] || abbruch 'Sicht pruef_zweck_lage fehlt -- zweckbestimmung_daten.sql zuerst einspielen.'

# AUFBAUPRUEFUNG (F07): dieselben Bedingungen wie in
# zweckbestimmung_daten.sql, hier aber unmittelbar vor dem Lauf -- die
# Daten koennten zwischenzeitlich durch einen frueheren Lauf verbraucht
# worden sein.
aufbau="$(dbz "
SELECT string_agg(m, ' ') FROM (
  SELECT email || ':status=' || status AS m FROM pruef_zweck_konten
   WHERE email <> 'zb_gesperrt@zbpruef.example' AND status <> 'AKTIV'
  UNION ALL
  SELECT email || ':ohne_portal' AS m FROM pruef_zweck_konten
   WHERE email <> 'zb_admin@zbpruef.example' AND freigeschaltete_portale < 1
  UNION ALL
  SELECT email || ':hat_schon_' || checks || '_checks' AS m FROM pruef_zweck_konten
   WHERE email NOT IN ('zb_admin@zbpruef.example','zb_db@zbpruef.example',
                       'zb_fremd@zbpruef.example','zb_gesperrt@zbpruef.example')
     AND checks <> 0
  UNION ALL
  SELECT email || ':offene_sitzung' AS m FROM pruef_zweck_konten
   WHERE offene_sitzungen > 0
  UNION ALL
  SELECT 'geeigneter_check_fehlt' AS m
   WHERE NOT EXISTS (SELECT 1 FROM fit_check
                      WHERE id='$CHECK_GEEIGNET' AND outcome='GEEIGNET' AND app_id IS NULL)
  UNION ALL
  SELECT 'offener_check_fehlt' AS m
   WHERE NOT EXISTS (SELECT 1 FROM fit_check WHERE id='$CHECK_OFFEN' AND outcome='OFFEN')
  UNION ALL
  SELECT 'fremder_check_fehlt' AS m
   WHERE NOT EXISTS (SELECT 1 FROM fit_check
                      WHERE id='$CHECK_FREMD' AND tenant_id='$MANDANT_B' AND outcome='GEEIGNET')
  UNION ALL
  SELECT 'anwendung_aus_frueherem_lauf' AS m
   WHERE EXISTS (SELECT 1 FROM app WHERE tenant_id IN ('$MANDANT_A','$MANDANT_B'))
) t")"
pruefe_sql_marke
[ -z "$aufbau" ] || abbruch "Datenlage taugt nicht (F07): $aufbau -- zweckbestimmung_daten.sql neu einspielen."

ACK_SPALTE="$(dbz "SELECT ack_spalte FROM pruef_zweck_lage")"
MANDANT_AUSLAND="$(dbz "SELECT coalesce(mandant_ausland,'?') FROM pruef_zweck_lage")"
ANSPRECHPERSON="$(dbz "SELECT coalesce(ansprechperson,'?') FROM pruef_zweck_lage")"
pruefe_sql_marke

# ---------------------------------------------------------------------
# Der Katalog der drei Eignungsfragen wird EINMAL gelesen. Er ist
# Startbestand des Baus; der Lauf faehrt mit dem, was er hergibt -- nie
# mit geratenen Fragekennungen. Wer die Kennung raet, misst den Bau,
# nicht die Klausel.
# ---------------------------------------------------------------------
Q_CODE=(); Q_JA=()
while IFS="$(printf '\t')" read -r c ja; do
  [ -n "$c" ] || continue
  Q_CODE+=("$c"); Q_JA+=("$ja")
done <<EOF
$(db "SELECT concat_ws(chr(9), q.code,
        coalesce((SELECT o.id::text FROM fit_option o
                   WHERE o.question_code=q.code AND o.is_eligible
                   ORDER BY o.position LIMIT 1),''))
      FROM fit_question q ORDER BY q.position")
EOF
pruefe_sql_marke

ANZ_FRAGEN=${#Q_CODE[@]}
EIGNUNG_FAHRBAR=1
EIGNUNG_GRUND=""
[ "$ANZ_FRAGEN" -ge 1 ] || { EIGNUNG_FAHRBAR=0; EIGNUNG_GRUND="der Startbestand fuehrt keine Eignungsfrage"; }
i=0
while [ $i -lt "$ANZ_FRAGEN" ]; do
  [ -n "${Q_JA[$i]}" ] || { EIGNUNG_FAHRBAR=0; EIGNUNG_GRUND="Frage ${Q_CODE[$i]} hat keine zusagende Antwortmoeglichkeit -- GEEIGNET ist unerreichbar"; }
  i=$((i+1))
done

printf 'FREIRAUM · Scheibe 2 · M4 Zweckbestimmung — Klauselpruefung gegen %s\n' "$BASIS"
printf 'Datenlage: %s auf %s:%s · Aufbaupruefung (F07) bestanden\n' "$PGDATABASE" "$PGHOST" "$PGPORT"
printf 'Eignungskatalog: %s Frage(n)%s\n' "$ANZ_FRAGEN" \
       "$( [ "$EIGNUNG_FAHRBAR" = "1" ] || printf ' — GEEIGNET NICHT FAHRBAR: %s' "$EIGNUNG_GRUND" )"
printf 'Traeger der Kenntnisnahme: %s\n\n' \
       "$( [ "${ACK_SPALTE:-0}" = "1" ] && printf 'Spalte fit_check.zweckbestimmung_ack_at vorhanden; zusaetzlich wird nach einem Ereignis gesucht (K04-G12)' || printf 'keine eigene Spalte — es wird ein Ereignis erwartet (K04-G12)' )"

# =====================================================================
# TEIL A · DIE FAHRTEN UND DIE ENTDECKUNG
#
# Erst werden die Wege gefahren und alle Seiten aufgehoben. Gemessen
# wird danach -- durch VERGLEICH der Seiten untereinander. Kein Fall
# fragt "steht dieser Text irgendwo"; jeder fragt "steht er HIER und
# DORT nicht".
# =====================================================================

# Bis GEEIGNET: anmelden, die Vorpruefung ueberspringen, jede
# Eignungsfrage zusagend beantworten, weiter. Rueckgabe in
# FAHRT_KEKS und FAHRT_ZIEL (die Adresse, auf die der Server nach
# GEEIGNET weiterleitet).
FAHRT_KEKS=""; FAHRT_ZIEL=""; FAHRT_GRUND=""
bis_geeignet() {     # $1 email  $2 code  $3 namensvorsatz
  FAHRT_KEKS=""; FAHRT_ZIEL=""; FAHRT_GRUND=""
  if [ "$EIGNUNG_FAHRBAR" != "1" ]; then
    FAHRT_GRUND="GEEIGNET ist nicht fahrbar: $EIGNUNG_GRUND"; return 1
  fi
  if ! anmelden "$1" "$2" "${3}_anm"; then
    FAHRT_GRUND="die Anmeldung von $1 scheiterte (Status $ANM_STATUS)"; return 1
  fi
  local keks="$ANM_KEKS" i st
  sende /vorpruefung/ueberspringen "${3}_vor" "$keks" >/dev/null
  i=0
  while [ $i -lt "$ANZ_FRAGEN" ]; do
    sende /eignung/antwort "${3}_a$i" "$keks" "frage=${Q_CODE[$i]}" "option=${Q_JA[$i]}" >/dev/null
    i=$((i+1))
  done
  st=$(sende /eignung/weiter "${3}_w" "$keks")
  local stand
  stand="$(dbz "SELECT c.outcome::text FROM fit_check c JOIN actor a ON a.id=c.actor_id
                 WHERE a.email='$1' ORDER BY c.started_at DESC LIMIT 1")"
  if [ "$stand" != "GEEIGNET" ]; then
    FAHRT_GRUND="der Eignungs-Check von $1 steht auf '${stand:-(keiner)}' statt GEEIGNET (POST /eignung/weiter lieferte $st)"
    return 1
  fi
  FAHRT_KEKS="$keks"
  FAHRT_ZIEL="$(nur_pfad "$(kopfzeile "${3}_w" location)")"
  return 0
}

# Der Bildschirm der Zweckbestimmung wird ENTDECKT, nicht geraten.
# Erster Versuch: die Weiterleitung nach GEEIGNET. Zweiter Versuch: eine
# kurze Liste naheliegender Adressen, die der Reihe nach geoeffnet und
# an den Merkmalen aus K04-M19 GEPRUEFT werden -- eine Adresse gilt erst
# als der Bildschirm, wenn sie zwei nach diesen Merkmalen
# unterscheidbare Eingaben fuehrt.
ZWECK_PFAD=""; ZWECK_GRUND=""
FELD1=""; JA1=""; NEIN1=""; FELD2=""; JA2=""; NEIN2=""; ANTWORT_ZIEL=""
VERBORGEN=()

lies_felder() {      # $1 name -> setzt FELD1..NEIN2, ANTWORT_ZIEL, VERBORGEN
  FELD1=""; JA1=""; NEIN1=""; FELD2=""; JA2=""; NEIN2=""; ANTWORT_ZIEL=""
  VERBORGEN=()
  local zeile art rest
  while IFS= read -r zeile; do
    [ -n "$zeile" ] || continue
    art="${zeile%%|*}"; rest="${zeile#*|}"
    case "$art" in
      HIDDEN)
        VERBORGEN+=("${rest%%|*}=${rest#*|}")
        ;;
      FELD)
        local n _ z k j ne
        IFS='|' read -r n _ z k j ne <<< "$rest"
        case "$k" in
          F1) [ -n "$FELD1" ] || { FELD1="$n"; JA1="$j"; NEIN1="$ne"; ANTWORT_ZIEL="${ANTWORT_ZIEL:-$z}"; };;
          F2) [ -n "$FELD2" ] || { FELD2="$n"; JA2="$j"; NEIN2="$ne"; ANTWORT_ZIEL="${ANTWORT_ZIEL:-$z}"; };;
        esac
        ;;
    esac
  done <<EOF
$(felder "$1")
EOF
}

if bis_geeignet 'zb_frei@zbpruef.example' '820001' zbfrei; then
  KEKS_FREI="$FAHRT_KEKS"
  # Kandidaten: die Weiterleitung zuerst, dann der Notausgang aus der
  # Umgebung, dann naheliegende Adressen. Jede wird geprueft, keine
  # geglaubt.
  for kand in "$FAHRT_ZIEL" "${FREIRAUM_ZWECK_PFAD:-}" /zweck /zweckbestimmung /eignung/zweck /verwendung; do
    [ -n "$kand" ] || continue
    case "$kand" in /*) : ;; *) continue;; esac
    if [ "$(hole "$kand" zb_f0 "$KEKS_FREI")" = "200" ]; then
      lies_felder zb_f0
      if [ -n "$FELD1" ] && [ -n "$FELD2" ] && [ "$FELD1" != "$FELD2" ]; then
        ZWECK_PFAD="$kand"; break
      fi
    fi
  done
  [ -n "$ZWECK_PFAD" ] || ZWECK_GRUND="unter keiner der geprueften Adressen (Weiterleitung nach GEEIGNET: '${FAHRT_ZIEL:-keine}') steht ein Bildschirm mit zwei nach K04-M19 unterscheidbaren Eingaben"
else
  ZWECK_GRUND="$FAHRT_GRUND"
  KEKS_FREI=""
fi

printf 'Entdeckung: Bildschirm der Zweckbestimmung = %s\n' "${ZWECK_PFAD:-NICHT GEFUNDEN ($ZWECK_GRUND)}"
[ -n "$ZWECK_PFAD" ] && printf 'Entdeckung: Frage 1 = Feld "%s" (ja=%s nein=%s) · Frage 2 = Feld "%s" (ja=%s nein=%s) · Antwortziel %s\n' \
   "$FELD1" "$JA1" "$NEIN1" "$FELD2" "$JA2" "$NEIN2" "$ANTWORT_ZIEL"

# Eine Zweckfrage beantworten -- mit allen verborgenen Feldern der
# Seite, damit kein POST an einer FREMDEN Bedingung scheitert.
zweck_antwort() {    # $1 keks  $2 name  $3 feld  $4 wert
  local f=()
  [ "$4" = "(weglassen)" ] || f+=("$3=$4")
  sende "${ANTWORT_ZIEL:-$ZWECK_PFAD}" "$2" "$1" ${VERBORGEN[@]+"${VERBORGEN[@]}"} ${f[@]+"${f[@]}"}
}

# ---------------------------------------------------------------------
# Fahrt 1 · zb_frei · beide Fragen NEIN -> W6
# Dabei entstehen die drei Zielmengen, aus deren UNTERSCHIED das Ziel
# "Weiter" abgeleitet wird.
# ---------------------------------------------------------------------
ZIELE_NULL=""; ZIELE_EINS=""; ZIELE_ZWEI=""; ZIELE_FREI=""
WEITER_ZIEL=""; WEITER_GRUND=""
if [ -n "$ZWECK_PFAD" ]; then
  ZIELE_NULL="$(zieltexte zb_f0)"
  zweck_antwort "$KEKS_FREI" zb_f1 "$FELD1" "$NEIN1" >/dev/null
  hole "$ZWECK_PFAD" zb_f1s "$KEKS_FREI" >/dev/null
  ZIELE_EINS="$(zieltexte zb_f1s)"
  zweck_antwort "$KEKS_FREI" zb_f2 "$FELD2" "$NEIN2" >/dev/null
  hole "$ZWECK_PFAD" zb_f2s "$KEKS_FREI" >/dev/null
  ZIELE_ZWEI="$(zieltexte zb_f2s)"

  # Das Ziel "Weiter": erscheint erst mit der zweiten Antwort. Die
  # fruehere Fassung verlangte, dass GENAU EIN Ziel neu erscheint --
  # eine Annahme, die in keiner Klausel verankert ist (K19-M06 regelt
  # das AUSBLENDEN einer Schaltflaeche, nicht die Anzahl gleichzeitig
  # neu erscheinender Wege; K04-M08 ist halt-bezogen). EN-04a fuehrt
  # sechs Aktionen -- nichts verbietet, dass mehrere zugleich neu
  # erscheinen. Ersetzt durch eine Erkennung an der WIRKUNG:
  #
  #   Der Anlageweg ist derjenige, nach dessen Aufruf gilt: genau eine
  #   neue Anwendungszeile ist entstanden * der Eignungs-Check traegt
  #   danach einen Verweis auf diese Anwendung * im Verlauf steht eine
  #   Zeile mit dem Anlass DISCOVERY.
  #
  # Die Differenz bleibt gegen ZIELE_NULL (nicht ZIELE_EINS) -- sonst
  # pruefte ZB-03 seine eigene Ableitung, und die zweite Zusicherung
  # (der Weiterweg steht nicht schon mit einer Antwort offen) waere
  # tautologisch.
  neu="$(comm -13 <(printf '%s\n' "$ZIELE_NULL" | sort -u) <(printf '%s\n' "$ZIELE_ZWEI" | sort -u))"
  anz="$(printf '%s\n' "$neu" | grep -c . || true)"
  if [ "$anz" = "1" ]; then
    WEITER_ZIEL="$(printf '%s\n' "$neu" | grep . | head -1)"
  elif [ "$anz" -gt 1 ]; then
    cid_w="$(dbz "SELECT c.id::text FROM fit_check c JOIN actor a ON a.id=c.actor_id
                   WHERE a.email='zb_frei@zbpruef.example' ORDER BY c.started_at DESC LIMIT 1")"
    vorher_w="$(dbz "SELECT count(*) FROM app WHERE tenant_id='$MANDANT_A'")"
    treffer_w=(); i_w=0
    while IFS= read -r kand; do
      [ -n "$kand" ] || continue
      i_w=$((i_w+1))
      sende "$kand" "zb_f3_probe$i_w" "$KEKS_FREI" ${VERBORGEN[@]+"${VERBORGEN[@]}"} >/dev/null
      nachher_w="$(dbz "SELECT count(*) FROM app WHERE tenant_id='$MANDANT_A'")"
      if [ "${nachher_w:-0}" = "$(( ${vorher_w:-0} + 1 ))" ]; then
        rueck_w="$(dbz "SELECT coalesce(app_id::text,'(leer)') FROM fit_check WHERE id='$cid_w'")"
        ev_w=0
        if [ "$rueck_w" != "(leer)" ]; then
          ev_w="$(dbz "SELECT count(*) FROM event WHERE action ILIKE '%DISCOVERY%'
                        AND (coalesce(object_ref,'') LIKE '%$rueck_w%'
                             OR coalesce(value,'') LIKE '%$rueck_w%')")"
        fi
        [ "${ev_w:-0}" -ge 1 ] && treffer_w+=("$kand")
      fi
      vorher_w="$nachher_w"
    done <<EOF
$neu
EOF
    if [ "${#treffer_w[@]}" = "1" ]; then
      WEITER_ZIEL="${treffer_w[0]}"
    else
      WEITER_GRUND="mit beiden Antworten erscheinen $anz neue Ziele statt genau einem; die Wirkung (genau eine neue Anwendungszeile, Eignungs-Check-Verweis darauf, Verlauf-Anlass DISCOVERY) grenzt sie nicht auf einen einzigen Kandidaten ein (${#treffer_w[@]} erfuellen sie) -- Kandidaten: $(printf '%s' "$neu" | tr '\n' ' ')"
    fi
  else
    WEITER_GRUND="mit beiden Antworten erscheint kein neues Ziel"
  fi
  if [ -n "$WEITER_ZIEL" ]; then
    sende "$WEITER_ZIEL" zb_f3 "$KEKS_FREI" ${VERBORGEN[@]+"${VERBORGEN[@]}"} >/dev/null
    ziel3="$(nur_pfad "$(kopfzeile zb_f3 location)")"
    [ -n "$ziel3" ] && hole "$ziel3" zb_f3s "$KEKS_FREI" >/dev/null || cp "$ARBEIT/zb_f3.rumpf" "$ARBEIT/zb_f3s.rumpf" 2>/dev/null
    ZIELE_FREI="$(zieltexte zb_f3s)"
  fi
fi

# ---------------------------------------------------------------------
# Fahrt 2 · zb_anhang · Frage 1 JA, Frage 2 NEIN -> W4
# ---------------------------------------------------------------------
KEKS_ANHANG=""; ZIELE_ANHANG=""; ANHANG_GRUND=""
if [ -n "$ZWECK_PFAD" ] && bis_geeignet 'zb_anhang@zbpruef.example' '820002' zbanhang; then
  KEKS_ANHANG="$FAHRT_KEKS"
  hole "$ZWECK_PFAD" zb_a0 "$KEKS_ANHANG" >/dev/null
  zweck_antwort "$KEKS_ANHANG" zb_a1 "$FELD1" "$JA1"   >/dev/null
  zweck_antwort "$KEKS_ANHANG" zb_a2 "$FELD2" "$NEIN2" >/dev/null
  if [ -n "$WEITER_ZIEL" ]; then
    sende "$WEITER_ZIEL" zb_a3 "$KEKS_ANHANG" ${VERBORGEN[@]+"${VERBORGEN[@]}"} >/dev/null
    z="$(nur_pfad "$(kopfzeile zb_a3 location)")"
    [ -n "$z" ] && hole "$z" zb_a3s "$KEKS_ANHANG" >/dev/null || cp "$ARBEIT/zb_a3.rumpf" "$ARBEIT/zb_a3s.rumpf" 2>/dev/null
    ZIELE_ANHANG="$(zieltexte zb_a3s)"
  fi
else
  ANHANG_GRUND="${FAHRT_GRUND:-$ZWECK_GRUND}"
fi

# ---------------------------------------------------------------------
# Fahrt 3 · zb_verboten · Frage 1 NEIN, Frage 2 JA -> W3 (Halt)
# ---------------------------------------------------------------------
KEKS_VERBOTEN=""; ZIELE_HALT=""; VERBOTEN_GRUND=""
if [ -n "$ZWECK_PFAD" ] && bis_geeignet 'zb_verboten@zbpruef.example' '820003' zbverb; then
  KEKS_VERBOTEN="$FAHRT_KEKS"
  zweck_antwort "$KEKS_VERBOTEN" zb_v1 "$FELD1" "$NEIN1" >/dev/null
  zweck_antwort "$KEKS_VERBOTEN" zb_v2 "$FELD2" "$JA2"   >/dev/null
  if [ -n "$WEITER_ZIEL" ]; then
    sende "$WEITER_ZIEL" zb_v3 "$KEKS_VERBOTEN" ${VERBORGEN[@]+"${VERBORGEN[@]}"} >/dev/null
    z="$(nur_pfad "$(kopfzeile zb_v3 location)")"
    [ -n "$z" ] && hole "$z" zb_v3s "$KEKS_VERBOTEN" >/dev/null || cp "$ARBEIT/zb_v3.rumpf" "$ARBEIT/zb_v3s.rumpf" 2>/dev/null
    ZIELE_HALT="$(zieltexte zb_v3s)"
  fi
else
  VERBOTEN_GRUND="${FAHRT_GRUND:-$ZWECK_GRUND}"
fi

# ---------------------------------------------------------------------
# Fahrt 4 · zb_beide · Frage 1 JA UND Frage 2 JA -> der Vorrangfall
# ---------------------------------------------------------------------
KEKS_BEIDE=""; BEIDE_GRUND=""
if [ -n "$ZWECK_PFAD" ] && bis_geeignet 'zb_beide@zbpruef.example' '820004' zbbeide; then
  KEKS_BEIDE="$FAHRT_KEKS"
  zweck_antwort "$KEKS_BEIDE" zb_b1 "$FELD1" "$JA1" >/dev/null
  zweck_antwort "$KEKS_BEIDE" zb_b2 "$FELD2" "$JA2" >/dev/null
  if [ -n "$WEITER_ZIEL" ]; then
    sende "$WEITER_ZIEL" zb_b3 "$KEKS_BEIDE" ${VERBORGEN[@]+"${VERBORGEN[@]}"} >/dev/null
    z="$(nur_pfad "$(kopfzeile zb_b3 location)")"
    [ -n "$z" ] && hole "$z" zb_b3s "$KEKS_BEIDE" >/dev/null || cp "$ARBEIT/zb_b3.rumpf" "$ARBEIT/zb_b3s.rumpf" 2>/dev/null
  fi
else
  BEIDE_GRUND="${FAHRT_GRUND:-$ZWECK_GRUND}"
fi

# ---------------------------------------------------------------------
# Die beiden verbleibenden Ziele aus dem UNTERSCHIED der Fahrten
# ---------------------------------------------------------------------
KENNTNIS_ZIEL=""; KENNTNIS_GRUND=""
ANLEGEN_ZIEL="";  ANLEGEN_GRUND=""
if [ -n "$ZIELE_ANHANG" ] && [ -n "$ZIELE_FREI" ]; then
  neu="$(comm -13 <(printf '%s\n' "$ZIELE_FREI" | sort -u) <(printf '%s\n' "$ZIELE_ANHANG" | sort -u))"
  anz="$(printf '%s\n' "$neu" | grep -c . || true)"
  if [ "$anz" = "1" ]; then KENNTNIS_ZIEL="$(printf '%s\n' "$neu" | grep . | head -1)"
  else KENNTNIS_GRUND="nach Treffer in Frage 1 erscheinen $anz Ziele, die es beim freien Weg nicht gibt, statt genau einem ($(printf '%s' "$neu" | tr '\n' ' '))"; fi

  neu="$(comm -13 <(printf '%s\n' "$ZIELE_ANHANG" | sort -u) <(printf '%s\n' "$ZIELE_FREI" | sort -u))"
  anz="$(printf '%s\n' "$neu" | grep -c . || true)"
  if [ "$anz" = "1" ]; then ANLEGEN_ZIEL="$(printf '%s\n' "$neu" | grep . | head -1)"
  else ANLEGEN_GRUND="beim freien Weg erscheinen $anz Ziele, die es nach Treffer in Frage 1 nicht gibt, statt genau einem ($(printf '%s' "$neu" | tr '\n' ' '))"; fi
else
  KENNTNIS_GRUND="eine der beiden Fahrten (freier Weg / Treffer in Frage 1) kam nicht zustande"
  ANLEGEN_GRUND="$KENNTNIS_GRUND"
fi

printf 'Entdeckung: Ziel Weiter = %s · Ziel Kenntnisnahme = %s · Ziel Anlage = %s\n\n' \
  "${WEITER_ZIEL:-NICHT BESTIMMBAR}" "${KENNTNIS_ZIEL:-NICHT BESTIMMBAR}" "${ANLEGEN_ZIEL:-NICHT BESTIMMBAR}"

# Hilfsfunktionen fuer die Auswertung
anz_apps() {         # $1 mandant
  dbz "SELECT count(*) FROM app WHERE tenant_id='$1'"
}
check_von() {        # $1 email -> die Kennung seines juengsten Checks
  dbz "SELECT c.id::text FROM fit_check c JOIN actor a ON a.id=c.actor_id
        WHERE a.email='$1' ORDER BY c.started_at DESC LIMIT 1"
}
stand_von() {        # $1 email -> outcome|app_id
  dbz "SELECT concat_ws('|', c.outcome::text, coalesce(c.app_id::text,'(leer)'))
         FROM fit_check c JOIN actor a ON a.id=c.actor_id
        WHERE a.email='$1' ORDER BY c.started_at DESC LIMIT 1"
}
# Der Nachweis der Kenntnisnahme -- gesucht an BEIDEN Orten, die
# K04-G12 und O-K04-8 offenlassen: eigene Spalte ODER Ereignis nach K02.
nachweise() {        # $1 email -> Anzahl
  local cid n1 n2
  cid="$(check_von "$1")"
  [ -n "$cid" ] || { printf '0'; return; }
  n1=0
  if [ "${ACK_SPALTE:-0}" = "1" ]; then
    n1="$(dbz "SELECT count(*) FROM fit_check
                WHERE id='$cid' AND zweckbestimmung_ack_at IS NOT NULL")"
  fi
  n2="$(dbz "SELECT count(*) FROM event
              WHERE (action ILIKE '%KENNTNIS%' OR action ILIKE '%ACK%'
                     OR action ILIKE '%ZWECK%' OR action ILIKE '%ANHANG%')
                AND (coalesce(object_ref,'') LIKE '%$cid%'
                     OR coalesce(value,'')  LIKE '%$cid%')")"
  printf '%s' $(( ${n1:-0} + ${n2:-0} ))
}

# =====================================================================
# TEIL B · DIE FAELLE AM BILDSCHIRM
# =====================================================================

# ---------------------------------------------------------------------
# ZB-01 · W1 + K04-M19 · Nach GEEIGNET oeffnet sich der Bildschirm der
#         Zweckbestimmung, und er fuehrt ZWEI Fragen -- nicht eine.
#
#         WORAN ER SCHEITERN KANN: leitet der Server nach GEEIGNET
#         nirgendwohin, oder fuehrt der Zielbildschirm nur eine oder
#         keine nach K04-M19 unterscheidbare Eingabe, wird er rot.
#         Genau das ist der Zustand, den EN-04a am 05.08.2026 geschlossen
#         hat: EN-04 verwies seit jeher auf einen Bildschirm, den es
#         nicht gab.
# ---------------------------------------------------------------------
if [ -z "$KEKS_FREI" ]; then
  sperr ZB-01 "Nicht messbar: GEEIGNET wurde nicht erreicht -- $ZWECK_GRUND"
elif [ -z "$ZWECK_PFAD" ]; then
  nok ZB-01 "Nach GEEIGNET oeffnet sich kein Bildschirm der Zweckbestimmung: $ZWECK_GRUND (K04-M19, K19 EN-04 zustand_erfolg)"
else
  m=""
  [ -n "$FAHRT_ZIEL" ] || m="$m POST /eignung/weiter leitet nach GEEIGNET nirgendwohin weiter;"
  [ "$FELD1" != "$FELD2" ] || m="$m beide Fragen haengen am selben Eingabefeld '$FELD1';"
  [ -n "$JA1" ] && [ -n "$NEIN1" ] || m="$m Frage 1 fuehrt keine unterscheidbare Ja- und Nein-Wahl (ja='$JA1', nein='$NEIN1');"
  [ -n "$JA2" ] && [ -n "$NEIN2" ] || m="$m Frage 2 fuehrt keine unterscheidbare Ja- und Nein-Wahl (ja='$JA2', nein='$NEIN2');"
  [ -z "$m" ] && ok ZB-01 "Nach GEEIGNET oeffnet sich $ZWECK_PFAD mit ZWEI getrennten Fragen, jede mit eigener Ja/Nein-Wahl (K04-M19, K19 EN-04a)" \
              || nok ZB-01 "Der Bildschirm der Zweckbestimmung:$m"
fi
pruefe_sql_marke

# ---------------------------------------------------------------------
# ZB-02 · K04-M19 · "Er ist kein fit_question; die drei Dimensionen nach
#         K04-M04 bleiben unberuehrt."
#
#         GEMESSEN WIRD EINE UNTERSCHEIDUNG, kein Vorkommen: die Zahl
#         der Eignungsfragen, der Antwortmoeglichkeiten und der
#         Antwortzeilen des Checks VOR und NACH der Beantwortung beider
#         Zweckfragen. Waere die Zweckbestimmung als vierte
#         Eignungsfrage gebaut, aendert sich eine dieser Zahlen -- und
#         der Fall faellt durch. Zusaetzlich: das Ergebnis des
#         Eignungs-Checks bleibt GEEIGNET; die Zweckfrage darf es nicht
#         umwerfen.
# ---------------------------------------------------------------------
if [ -z "$ZWECK_PFAD" ] || [ -z "$KEKS_ANHANG" ]; then
  sperr ZB-02 "Nicht messbar: ${ANHANG_GRUND:-$ZWECK_GRUND}"
else
  # zb_anhang hat beide Zweckfragen beantwortet; der Vergleich laeuft
  # gegen den Startbestand, der sich dadurch nicht aendern darf.
  fragen="$(dbz "SELECT count(*) FROM fit_question")"
  optionen="$(dbz "SELECT count(*) FROM fit_option")"
  dimensionen="$(dbz "SELECT count(DISTINCT dimension) FROM fit_question")"
  cid="$(check_von 'zb_anhang@zbpruef.example')"
  antworten="$(dbz "SELECT count(*) FROM fit_answer
                     WHERE fit_check_id='$cid' AND superseded_at IS NULL")"
  stand="$(dbz "SELECT outcome::text FROM fit_check WHERE id='$cid'")"
  m=""
  [ "$fragen" = "$ANZ_FRAGEN" ] || m="$m der Bestand fuehrt jetzt $fragen Eignungsfragen statt $ANZ_FRAGEN -- die Zweckfrage ist als fit_question gebaut worden (K04-M19);"
  [ "${dimensionen:-0}" -le 3 ] || m="$m es bestehen $dimensionen Eignungsdimensionen statt hoechstens drei (K04-M04);"
  [ "$antworten" = "$ANZ_FRAGEN" ] || m="$m der Check traegt $antworten offene Antwortzeilen statt $ANZ_FRAGEN -- die Zweckantwort ist als fit_answer geschrieben worden (K04-M19);"
  [ "$stand" = "GEEIGNET" ] || m="$m das Ergebnis des Eignungs-Checks steht nach der Zweckbestimmung auf '$stand' statt GEEIGNET;"
  [ -n "$optionen" ] || m="$m der Antwortkatalog liess sich nicht lesen;"
  [ -z "$m" ] && ok ZB-02 'Die Zweckbestimmung ist kein fit_question: Fragen, Dimensionen und Antwortzeilen des Eignungs-Checks bleiben unveraendert, das Ergebnis bleibt GEEIGNET (K04-M19, K04-M04)' \
              || nok ZB-02 "Zweckbestimmung als Eignungsfrage:$m"
fi
pruefe_sql_marke

# ---------------------------------------------------------------------
# ZB-03 · F5 + K19-M06 · "[Weiter] ausgeblendet, Hinweis nennt die
#         fehlende Frage", bis BEIDE Fragen beantwortet sind.
#
#         GEMESSEN WIRD EINE UNTERSCHEIDUNG: die Ziele der Seite ohne
#         Antwort, mit EINER Antwort und mit BEIDEN. Der Weiterweg darf
#         erst in der dritten Lage erscheinen. Ein Bildschirm, der ihn
#         immer zeigt, faellt durch; einer, der ihn nie zeigt, ebenso --
#         dann ist er gar nicht bestimmbar und der Fall sperrt.
# ---------------------------------------------------------------------
if [ -z "$ZWECK_PFAD" ] || [ -z "$KEKS_FREI" ]; then
  sperr ZB-03 "Nicht messbar: ${ZWECK_GRUND:-der Bildschirm wurde nicht erreicht}"
elif [ -z "$WEITER_ZIEL" ]; then
  sperr ZB-03 "Der Weiterweg ist nicht bestimmbar: $WEITER_GRUND. Ohne ihn ist nicht entscheidbar, ob er ausgeblendet war (K19-M06, fail-closed)"
else
  m=""
  printf '%s\n' "$ZIELE_NULL" | grep -qx -- "$WEITER_ZIEL" \
    && m="$m der Weiterweg '$WEITER_ZIEL' steht schon offen, bevor eine Frage beantwortet ist (K19-M06);"
  printf '%s\n' "$ZIELE_EINS" | grep -qx -- "$WEITER_ZIEL" \
    && m="$m der Weiterweg '$WEITER_ZIEL' steht schon offen, wenn erst EINE Frage beantwortet ist (K19-M06);"
  [ -z "$m" ] && ok ZB-03 "Der Weiterweg '$WEITER_ZIEL' erscheint erst, wenn BEIDE Zweckfragen beantwortet sind — vorher steht er weder ohne noch mit einer Antwort offen (F5, K19-M06)" \
              || nok ZB-03 "Weiter vor beiden Antworten:$m"
fi
pruefe_sql_marke

# ---------------------------------------------------------------------
# ZB-03b · K19-M06 · "Hinweis nennt die fehlende Frage."
#
#         WARUM DIESER FALL EINEN EIGENEN BEREICH BRAUCHT. EN-04a zeigt
#         nach K19 BEIDE Fragen; ihre Wortlaute stehen also ohnehin auf
#         der Seite. Ein Fall, der fragt "steht ein Merkmal der zweiten
#         Frage irgendwo", bestuende immer -- und maesse nichts. Genau
#         dieser Fehler ist am 15.08.2026 in der Vorpruefung derselben
#         Scheibe gefunden worden.
#
#         GEMESSEN WIRD DESHALB IM HINWEIS SELBST, abgegrenzt an der
#         Marke <div id="hinweis">, und als UNTERSCHEIDUNG:
#           (a) im Hinweis steht mindestens ein Merkmal der noch
#               offenen Frage 2;
#           (b) im Hinweis steht KEIN Merkmal der bereits beantworteten
#               Frage 1. Wer beide Fragen aufzaehlt, nennt keine.
#
#         Fehlt die Marke, ist der Ort nicht entscheidbar -- dann
#         GESPERRT, nie bestanden (K23-M22, fail-closed).
# ---------------------------------------------------------------------
if [ -z "$ZWECK_PFAD" ] || [ ! -f "$ARBEIT/zb_f1s.rumpf" ]; then
  sperr ZB-03b "Nicht messbar: ${ZWECK_GRUND:-der Bildschirm nach der ersten Antwort wurde nicht erreicht}"
else
  h="$(bereich_herkunft zb_f1s hinweis)"
  if [ "$h" != "MARKE" ]; then
    sperr ZB-03b "Der Hinweisbereich laesst sich nicht abgrenzen: $(bereich_sperrgrund "$h" hinweis). Ohne ihn ist nicht entscheidbar, ob die fehlende Frage BENANNT ist oder ob ihr Wortlaut bloss als Frage auf der Seite steht (K19-M06, fail-closed)"
  else
    t2="$(merkmale_im_bereich zb_f1s hinweis F2)"
    t1="$(merkmale_im_bereich zb_f1s hinweis F1)"
    m=""
    [ "${t2:-0}" -ge 1 ] || m="$m der Hinweis nennt kein Merkmal der noch offenen zweiten Frage (K19-M06);"
    [ "${t1:-0}" = "0" ] || m="$m der Hinweis nennt auch Merkmale der bereits beantworteten ersten Frage ($t1 Stueck) -- er unterscheidet nicht, WELCHE Frage fehlt (K19-M06);"
    [ -z "$m" ] && ok ZB-03b 'Der Hinweis benennt GENAU die noch fehlende Frage; die bereits beantwortete steht dort nicht (K19-M06)' \
                || nok ZB-03b "Hinweis auf die fehlende Frage:$m"
  fi
fi
pruefe_sql_marke

# ---------------------------------------------------------------------
# ZB-04 · F5 + K19-M14 · "Ein UI-Zustand ersetzt keine serverseitige
#         Autorisierung."
#
#         Der ausgeblendete Knopf ist keine Sperre. Ein Konto, das erst
#         EINE Frage beantwortet hat, sendet den Weiterweg trotzdem ab.
#         Der Server MUSS abweisen -- und es darf keine Anwendung
#         entstehen.
#
#         DIESER FALL SCHEITERT AN SEINER EIGENEN BEDINGUNG: er faehrt
#         genau die Adresse, die der Server selbst als Weiterweg
#         ausgibt, mit gueltiger Sitzung und allen verborgenen Feldern.
#         Ein 404 oder ein 401 waere eine FREMDE Bedingung -- deshalb
#         wird der Status ausdruecklich unterschieden.
# ---------------------------------------------------------------------
if [ -z "$WEITER_ZIEL" ]; then
  sperr ZB-04 "Nicht messbar: der Weiterweg ist nicht bestimmbar ($WEITER_GRUND)"
elif ! bis_geeignet 'zb_halb@zbpruef.example' '820006' zbhalb; then
  sperr ZB-04 "Nicht messbar: $FAHRT_GRUND"
else
  KEKS_HALB="$FAHRT_KEKS"
  hole "$ZWECK_PFAD" zb_h0 "$KEKS_HALB" >/dev/null
  zweck_antwort "$KEKS_HALB" zb_h1 "$FELD1" "$NEIN1" >/dev/null
  vorher="$(anz_apps "$MANDANT_A")"
  st=$(sende "$WEITER_ZIEL" zb_h2 "$KEKS_HALB" ${VERBORGEN[@]+"${VERBORGEN[@]}"})
  nachher="$(anz_apps "$MANDANT_A")"
  stand="$(stand_von 'zb_halb@zbpruef.example')"
  m=""; pruefbar=1
  # 401/403 VOR 2*|4*): eine abgewiesene Sitzung ist eine FREMDE
  # Bedingung (s. Kopfkommentar), keine Antwort im Sinne von F5 -- und
  # damit nicht messbar, nicht "in Ordnung" (K23-M22: bestanden ·
  # fehlgeschlagen · GESPERRT · nicht ausgefuehrt).
  case "$st" in
    401|403)
      pruefbar=0
      sperr ZB-04 "Status $st -- die Sitzung selbst wurde abgewiesen; gemessen waere dann eine fremde Bedingung, nicht F5"
      ;;
    2*|4*) : ;;
    303)   ziel="$(nur_pfad "$(kopfzeile zb_h2 location)")"
           case "$ziel" in
             "$ZWECK_PFAD") : ;;   # zurueck auf den Bildschirm ist eine Abweisung
             *) m="$m der Weiterweg wurde mit 303 auf '$ziel' angenommen, obwohl nur eine Frage beantwortet ist;";;
           esac;;
    5*)    m="$m Status $st -- abgewiesen wird der Weiterweg damit nicht, der Weg stuerzt ab;";;
    *)     m="$m unerwarteter Status $st;";;
  esac
  if [ "$pruefbar" = "1" ]; then
    [ "$vorher" = "$nachher" ] || m="$m es entstand eine Anwendung ($vorher -> $nachher), obwohl nur eine Zweckfrage beantwortet ist (K01-M27);"
    case "$stand" in *"|(leer)") : ;; *) m="$m der Check traegt jetzt '$stand' -- er ist mit einer Anwendung verknuepft;";; esac
    [ -z "$m" ] && ok ZB-04 'Der Weiterweg wird serverseitig abgewiesen, wenn erst eine Zweckfrage beantwortet ist -- der ausgeblendete Knopf ist nicht die Autorisierung (K19-M14, F5)' \
                || nok ZB-04 "Weiter mit halber Antwort:$m"
  fi
fi
pruefe_sql_marke

# ---------------------------------------------------------------------
# ZB-05 · W6 · Beide Fragen verneint: kein Halt, keine Warnung, der Weg
#         zur Anlage wird frei.
#
#         Dieser Fall ist die GEGENPROBE fuer ZB-06 und ZB-07. Ohne ihn
#         maessen jene nichts: eine Seite, die Anhang III und Artikel 5
#         immer nennt, bestuende beide.
# ---------------------------------------------------------------------
if [ -z "$ZIELE_FREI" ]; then
  sperr ZB-05 "Nicht messbar: die Fahrt mit zwei Nein-Antworten kam nicht bis zur Auswertung (${WEITER_GRUND:-$ZWECK_GRUND})"
else
  m=""
  enthaelt_lose zb_f3s 'Anhang III' && m="$m die Warnung zu Anhang III steht auch ohne Treffer in Frage 1 auf der Seite (K04-M20);"
  enthaelt_lose zb_f3s 'Artikel 5'  && m="$m der Verweis auf Artikel 5 steht auch ohne Treffer in Frage 2 auf der Seite (K04-M20);"
  enthaelt_lose zb_f3s 'Art. 5'     && m="$m der Verweis auf Art. 5 steht auch ohne Treffer in Frage 2 auf der Seite (K04-M20);"
  [ -n "$ANLEGEN_ZIEL" ] || m="$m der Weg zur Anlage ist nicht bestimmbar: $ANLEGEN_GRUND;"
  apps="$(anz_apps "$MANDANT_A")"
  [ "${apps:-0}" = "0" ] || m="$m es entstand schon eine Anwendung, bevor der Weg zur Anlage gegangen wurde ($apps) -- W7 ist dann kein eigener Schritt mehr und K04-M18 nicht pruefbar;"
  [ -z "$m" ] && ok ZB-05 'Beide Zweckfragen verneint: weder Anhang-III-Warnung noch Artikel-5-Verweis, der Weg zur Anlage wird frei und noch keine Anwendung angelegt (W6)' \
              || nok ZB-05 "Kein Treffer:$m"
fi
pruefe_sql_marke

# ---------------------------------------------------------------------
# ZB-06 · W4 + K04-M20 + K04-D09 · Treffer in Frage 1: DREI Dinge --
#         Warnung zu Anhang III, Hinweis auf die Anbieterpflichten aus
#         Art. 9, 11, 14, 17 und 43, Aufforderung zu bestaetigen.
#         Und: das ist KEIN Halt.
#
#         GEMESSEN WIRD DIE UNTERSCHEIDUNG gegen ZB-05 (beide verneint):
#         dieselbe Seite, nur eine andere Antwort. Was dort nicht steht
#         und hier steht, ist die Wirkung des Treffers. Die fuenf
#         Artikel werden als ARTIKEL gezaehlt ("Art. 9", "Artikel 11"),
#         nicht als blosse Ziffern -- sonst bestuende der Fall an jeder
#         Seite, auf der zufaellig eine 9 steht.
# ---------------------------------------------------------------------
if [ -z "$ZIELE_ANHANG" ]; then
  sperr ZB-06 "Nicht messbar: ${ANHANG_GRUND:-die Fahrt mit Treffer in Frage 1 kam nicht bis zur Auswertung}"
else
  fehlen=""
  for a in 9 11 14 17 43; do
    artikelliste zb_a3s | grep -qx -- "$a" || fehlen="$fehlen $a"
  done
  stand="$(stand_von 'zb_anhang@zbpruef.example')"
  m=""
  enthaelt_lose zb_a3s 'Anhang III' || m="$m die Warnung nennt den Anhang III der KI-Verordnung nicht (K04-M20);"
  [ -z "$fehlen" ] || m="$m die Anbieterpflichten sind unvollstaendig -- es fehlen die Artikel$fehlen (K04-M20);"
  [ -n "$KENNTNIS_ZIEL" ] || m="$m es gibt keine Aufforderung zu bestaetigen: $KENNTNIS_GRUND (K04-M20);"
  # K04-D09: kein Halt. Das Ergebnis bleibt GEEIGNET, und der Weg endet
  # nicht in den drei Auswegen.
  case "$stand" in GEEIGNET*) : ;; *) m="$m der Eignungs-Check steht auf '$stand' -- der Treffer in Frage 1 hat als Halt gewirkt (K04-D09);";; esac
  enthaelt_lose zb_a3s 'Artikel 5' && m="$m die Seite verweist auf Artikel 5, obwohl nur Frage 1 zutrifft -- das ist die Begruendung des Halts (K04-M20, D09);"
  enthaelt_lose zb_a3s 'Art. 5'    && m="$m die Seite verweist auf Art. 5, obwohl nur Frage 1 zutrifft (K04-M20, D09);"
  [ -z "$m" ] && ok ZB-06 'Treffer in Frage 1: Warnung zu Anhang III, alle fuenf Anbieterpflichten (Art. 9, 11, 14, 17, 43) und eine Aufforderung zu bestaetigen — und KEIN Halt, das Ergebnis bleibt GEEIGNET (K04-M20, K04-D09)' \
              || nok ZB-06 "Treffer in Frage 1:$m"
fi
pruefe_sql_marke

# ---------------------------------------------------------------------
# ZB-07 · W3 + K04-M20 + K04-D10 · Treffer in Frage 2: Grund der
#         Ablehnung und Verweis auf Artikel 5 -- und der Weg wird NICHT
#         weitergefuehrt. "Dort heilt keine Aufklaerung und keine
#         Bestaetigung."
#
#         GEMESSEN WIRD DIE UNTERSCHEIDUNG gegen ZB-06: hier steht der
#         Artikel-5-Verweis und NICHT die Aufforderung zu bestaetigen;
#         dort war es umgekehrt. Eine Seite, die beides zeigt, faellt
#         durch -- und genau das waere der Fehler, den K04-D10 verbietet.
# ---------------------------------------------------------------------
if [ -z "$ZIELE_HALT" ]; then
  sperr ZB-07 "Nicht messbar: ${VERBOTEN_GRUND:-die Fahrt mit Treffer in Frage 2 kam nicht bis zur Auswertung}"
else
  apps="$(anz_apps "$MANDANT_A")"
  cid="$(check_von 'zb_verboten@zbpruef.example')"
  appid="$(dbz "SELECT coalesce(app_id::text,'(leer)') FROM fit_check WHERE id='$cid'")"
  m=""
  { enthaelt_lose zb_v3s 'Artikel 5' || enthaelt_lose zb_v3s 'Art. 5'; } \
    || m="$m der Halt verweist nicht auf Artikel 5 (K04-M20);"
  # Der GRUND der Ablehnung: die Seite muss die verbotene Praktik beim
  # Namen nennen. Gemessen an den Merkmalen aus K04-M19, die die
  # Gegenprobe ZB-05 nicht traegt.
  grund_da=0
  for w in 'verboten' 'Gefuehle' 'Gefühle' 'soziale' 'Gesichter' 'Notlage'; do
    enthaelt_lose zb_v3s "$w" && grund_da=1
  done
  [ "$grund_da" = "1" ] || m="$m der Halt nennt den Grund der Ablehnung nicht (K04-M20);"
  [ -n "$KENNTNIS_ZIEL" ] && printf '%s\n' "$ZIELE_HALT" | grep -qx -- "$KENNTNIS_ZIEL" \
    && m="$m nach dem Treffer in Frage 2 steht die Kenntnisnahme '$KENNTNIS_ZIEL' offen -- dort heilt keine Bestaetigung (K04-D10);"
  [ -n "$ANLEGEN_ZIEL" ] && printf '%s\n' "$ZIELE_HALT" | grep -qx -- "$ANLEGEN_ZIEL" \
    && m="$m nach dem Treffer in Frage 2 steht der Weg zur Anlage '$ANLEGEN_ZIEL' offen (K04-D10);"
  enthaelt_lose zb_v3s 'Anhang III' \
    && m="$m der Halt zeigt die Warnung zu Anhang III statt des Grundes nach Artikel 5 (K04-M20: 'stattdessen');"
  [ "${apps:-0}" = "0" ] || m="$m es entstanden $apps Anwendungen im Mandanten (K04-D10);"
  [ "$appid" = "(leer)" ] || m="$m fit_check.app_id traegt '$appid' statt leer;"
  [ -z "$m" ] && ok ZB-07 'Treffer in Frage 2: Halt mit Grund und Verweis auf Artikel 5, keine Kenntnisnahme, kein Weg zur Anlage, keine Anwendung (K04-M20, K04-D10)' \
              || nok ZB-07 "Treffer in Frage 2:$m"
fi
pruefe_sql_marke

# ---------------------------------------------------------------------
# ZB-08 · DER VORRANGFALL · K04-D09 GEGEN K04-D10
#
#         DAS IST DER FALL, AN DEM SICH BEIDE KLAUSELN UNTERSCHEIDEN,
#         und der einzige, in dem sie einander begegnen: Frage 1 UND
#         Frage 2 treffen zu. Die Wegetabelle sagt "wertet aus: erst
#         Frage 2, dann Frage 1"; K19 EN-04a sagt "Treffer in Frage 2 ->
#         Halt-Feld, AUCH WENN Frage 1 ebenfalls zutrifft".
#
#         Ein Bau, der beide Klauseln einzeln erfuellt und die
#         Reihenfolge vertauscht, besteht ZB-06 und ZB-07 -- und faellt
#         hier durch. Ein Bau, der beides zugleich zeigt (Warnung UND
#         Halt), faellt hier ebenfalls durch: K04-M20 sagt
#         "stattdessen".
# ---------------------------------------------------------------------
if [ -z "$KEKS_BEIDE" ] || [ ! -f "$ARBEIT/zb_b3s.rumpf" ]; then
  sperr ZB-08 "Nicht messbar: ${BEIDE_GRUND:-die Fahrt mit beiden Treffern kam nicht bis zur Auswertung}"
else
  apps="$(anz_apps "$MANDANT_A")"
  cid="$(check_von 'zb_beide@zbpruef.example')"
  appid="$(dbz "SELECT coalesce(app_id::text,'(leer)') FROM fit_check WHERE id='$cid'")"
  nw="$(nachweise 'zb_beide@zbpruef.example')"
  m=""
  { enthaelt_lose zb_b3s 'Artikel 5' || enthaelt_lose zb_b3s 'Art. 5'; } \
    || m="$m obwohl Frage 2 zutrifft, verweist die Seite nicht auf Artikel 5 -- Frage 1 hat den Vorrang bekommen (K04-D10);"
  enthaelt_lose zb_b3s 'Anhang III' \
    && m="$m die Seite zeigt die Warnung zu Anhang III, obwohl Frage 2 zutrifft -- bei Treffer in Frage 2 tritt die Ablehnung an die STELLE der Kenntnisnahme (K04-M20, D10);"
  [ -n "$KENNTNIS_ZIEL" ] && fuehrt_zu zb_b3s "$KENNTNIS_ZIEL" \
    && m="$m die Kenntnisnahme '$KENNTNIS_ZIEL' steht offen, obwohl Frage 2 zutrifft -- dort heilt keine Bestaetigung (K04-D10);"
  [ -n "$ANLEGEN_ZIEL" ] && fuehrt_zu zb_b3s "$ANLEGEN_ZIEL" \
    && m="$m der Weg zur Anlage steht offen, obwohl Frage 2 zutrifft (K04-D10);"
  [ "${apps:-0}" = "0" ] || m="$m es entstanden $apps Anwendungen im Mandanten (K04-D10);"
  [ "$appid" = "(leer)" ] || m="$m fit_check.app_id traegt '$appid' statt leer;"
  [ "${nw:-0}" = "0" ] || m="$m es wurde ein Nachweis der Kenntnisnahme geschrieben, obwohl Frage 2 zutrifft (K04-D10);"
  [ -z "$m" ] && ok ZB-08 'Frage 1 UND Frage 2 treffen zu: es gilt der Halt nach Frage 2 — kein Anhang-III-Weg, keine Kenntnisnahme, keine Anwendung. Der Vorrang der zweiten Frage haelt (K04-D10 vor K04-D09)' \
              || nok ZB-08 "Vorrang der zweiten Frage:$m"
fi
pruefe_sql_marke

# ---------------------------------------------------------------------
# ZB-09 · K04-M08 · Nach einem Halt erscheinen GENAU DREI Auswege:
#         Antwort aendern, Termin, zur Uebersicht.
#
#         GEZAEHLT, NICHT ANGENOMMEN. Gezaehlt werden die Wege der
#         Halt-Seite: jedes Formularziel und jedes Verweisziel, ohne
#         Dubletten, ohne den Selbstbezug auf den Bildschirm und ohne
#         das Abmelden aus Scheibe 1. Was danach uebrig bleibt, MUSS
#         genau dreierlei sein. Ein vierter Weg faellt auf, ein
#         fehlender ebenso.
# ---------------------------------------------------------------------
if [ -z "$ZIELE_HALT" ]; then
  sperr ZB-09 "Nicht messbar: ${VERBOTEN_GRUND:-der Halt wurde nicht erreicht}"
else
  auswege=""
  while read -r z; do
    [ -n "$z" ] || continue
    case "$z" in
      "$ZWECK_PFAD"|"$ANTWORT_ZIEL"|/abmelden|/gesundheit) : ;;
      *) auswege="$auswege$z
";;
    esac
  done <<EOF
$ZIELE_HALT
EOF
  anz="$(printf '%s' "$auswege" | grep -c . || true)"
  hat_aendern=0; hat_termin=0; hat_uebersicht=0
  while read -r z; do
    [ -n "$z" ] || continue
    case "$z" in
      *aendern*|*antwort*|/eignung) hat_aendern=1;;
      *termin*|*gespraech*|*kontakt*) hat_termin=1;;
      *uebersicht*|/) hat_uebersicht=1;;
    esac
  done <<EOF
$auswege
EOF
  m=""
  [ "$hat_aendern" = "1" ]    || m="$m Ausweg 1 fehlt: kein Weg, die Antwort zu aendern;"
  [ "$hat_termin" = "1" ]     || m="$m Ausweg 2 fehlt: kein Weg zum Termin mit der Ansprechperson;"
  [ "$hat_uebersicht" = "1" ] || m="$m Ausweg 3 fehlt: kein Weg zurueck zur Uebersicht;"
  [ "$anz" = "3" ] || m="$m es sind $anz Wege statt genau drei: $(printf '%s' "$auswege" | tr '\n' ' ');"
  [ -z "$m" ] && ok ZB-09 "Nach dem Halt genau drei Auswege — gezaehlt, nicht angenommen: $(printf '%s' "$auswege" | tr '\n' ' ')(K04-M08)" \
              || nok ZB-09 "Die drei Auswege:$m"
fi
pruefe_sql_marke

# ---------------------------------------------------------------------
# ZB-10 · W5 + K04-M21 · "Die Kenntnisnahme MUSS als Nachweis erhalten
#         bleiben." Ohne sie ist die Auskunftspflicht nach Art. 25
#         Abs. 4 nicht belegbar.
#
#         GEMESSEN WIRD BLEIBEN, nicht Anzeigen: gesucht wird nicht auf
#         dem Bildschirm, sondern im BESTAND -- an fit_check oder als
#         Ereignis nach K02. Ein Vermerk, der nur in der Sitzung lebt,
#         hinterlaesst dort nichts und faellt damit durch. Gesucht wird
#         an BEIDEN Orten, die O-K04-8 offen laesst (K04-G12); der Fall
#         entscheidet die offene Frage nicht, er verlangt nur einen
#         Beleg.
#
#         Dass der Nachweis auch den naechsten SCHRITT ueberlebt --
#         die Anlage der Anwendung --, misst ZB-24. Eine zweite
#         Anmeldung wird hier bewusst NICHT gefahren: sie koennte die
#         laufende Sitzung entwerten, und die folgenden Faelle
#         scheiterten dann an einer fremden Bedingung (F07).
# ---------------------------------------------------------------------
if [ -z "$KENNTNIS_ZIEL" ] || [ -z "$KEKS_ANHANG" ]; then
  sperr ZB-10 "Nicht messbar: ${KENNTNIS_GRUND:-die Aufforderung zu bestaetigen wurde nicht gefunden}"
else
  vorher="$(nachweise 'zb_anhang@zbpruef.example')"
  st=$(sende "$KENNTNIS_ZIEL" zb_a4 "$KEKS_ANHANG" ${VERBORGEN[@]+"${VERBORGEN[@]}"})
  nachher="$(nachweise 'zb_anhang@zbpruef.example')"
  # Ein erneuter Aufruf des Bildschirms darf den Nachweis nicht
  # zuruecknehmen -- er ist ein Beleg, keine Anzeige.
  hole "$ZWECK_PFAD" zb_a5 "$KEKS_ANHANG" >/dev/null
  danach="$(nachweise 'zb_anhang@zbpruef.example')"
  m=""
  case "$st" in 2*|303) : ;; *) m="$m die Kenntnisnahme lieferte Status $st;";; esac
  [ "${vorher:-0}" = "0" ] || m="$m der Aufbau des Falls stimmt nicht: es lag schon ein Nachweis vor;"
  [ "${nachher:-0}" -ge 1 ] || m="$m nach der Bestaetigung besteht kein Nachweis im Bestand -- weder als Spalte an fit_check noch als Ereignis nach K02 (K04-M21, K04-G12);"
  [ "${danach:-0}" -ge 1 ] || m="$m der Nachweis war nach einem erneuten Aufruf des Bildschirms wieder fort (K04-M21);"
  [ -z "$m" ] && ok ZB-10 'Die Kenntnisnahme wird als Nachweis in den Bestand geschrieben und bleibt dort — belegbar an fit_check oder als Ereignis nach K02 (K04-M21, K04-G12)' \
              || nok ZB-10 "Nachweis der Kenntnisnahme:$m"
fi
pruefe_sql_marke

# ---------------------------------------------------------------------
# ZB-11 · F2 · Treffer in Frage 1 OHNE Kenntnisnahme: die Anlage wird
#         abgewiesen, es entsteht KEINE Zeile.
#
#         Zwei Messungen in einer: der Weg zur Anlage steht auf der
#         Warnseite gar nicht offen (das misst schon die Entdeckung des
#         Ziels), UND der Server weist ihn ab, wenn er trotzdem gefahren
#         wird (K19-M14). Nur die zweite Messung traegt: ein
#         ausgeblendeter Knopf ist keine Autorisierung.
#
#         WORAN ER SCHEITERT, WENN ER SCHEITERT: an seiner eigenen
#         Bedingung. Die Sitzung ist gueltig, die Adresse ist die, die
#         der Server beim freien Weg selbst ausgibt, der Eignungs-Check
#         steht auf GEEIGNET. Fehlt allein die Kenntnisnahme.
# ---------------------------------------------------------------------
if [ -z "$ANLEGEN_ZIEL" ]; then
  sperr ZB-11 "Nicht messbar: der Weg zur Anlage ist nicht bestimmbar ($ANLEGEN_GRUND)"
elif ! bis_geeignet 'zb_ohne@zbpruef.example' '820005' zbohne; then
  sperr ZB-11 "Nicht messbar: $FAHRT_GRUND"
else
  KEKS_OHNE="$FAHRT_KEKS"
  zweck_antwort "$KEKS_OHNE" zb_o1 "$FELD1" "$JA1"   >/dev/null
  zweck_antwort "$KEKS_OHNE" zb_o2 "$FELD2" "$NEIN2" >/dev/null
  sende "$WEITER_ZIEL" zb_o3 "$KEKS_OHNE" ${VERBORGEN[@]+"${VERBORGEN[@]}"} >/dev/null
  nw="$(nachweise 'zb_ohne@zbpruef.example')"
  vorher="$(anz_apps "$MANDANT_A")"
  st=$(sende "$ANLEGEN_ZIEL" zb_o4 "$KEKS_OHNE" ${VERBORGEN[@]+"${VERBORGEN[@]}"})
  nachher="$(anz_apps "$MANDANT_A")"
  stand="$(stand_von 'zb_ohne@zbpruef.example')"
  m=""; pruefbar=1
  [ "${nw:-0}" = "0" ] || m="$m der Aufbau des Falls stimmt nicht: es liegt schon ein Nachweis vor;"
  # 401/403 VOR 2*|4*), aus demselben Grund wie bei ZB-04: eine
  # abgewiesene Sitzung ist eine fremde Bedingung -- GESPERRT, nicht
  # GESCHEITERT (K23-M22).
  case "$st" in
    401|403)
      pruefbar=0
      sperr ZB-11 "Status $st -- die Sitzung selbst wurde abgewiesen; gemessen waere eine fremde Bedingung, nicht F2"
      ;;
    2*|4*) : ;;
    303) ziel="$(nur_pfad "$(kopfzeile zb_o4 location)")"
         case "$ziel" in
           "$ZWECK_PFAD") : ;;
           *) m="$m die Anlage wurde mit 303 auf '$ziel' angenommen, obwohl die Kenntnisnahme fehlt;";;
         esac;;
    5*) m="$m Status $st -- abgewiesen wird die Anlage damit nicht, der Weg stuerzt ab;";;
    *)  m="$m unerwarteter Status $st;";;
  esac
  if [ "$pruefbar" = "1" ]; then
    [ "$vorher" = "$nachher" ] || m="$m es entstand eine Anwendung ($vorher -> $nachher), obwohl die Kenntnisnahme fehlt (F2, K04-M21);"
    case "$stand" in *"|(leer)") : ;; *) m="$m der Check traegt jetzt '$stand' -- er ist mit einer Anwendung verknuepft;";; esac
    [ -z "$m" ] && ok ZB-11 'Treffer in Frage 1 ohne Kenntnisnahme: die Anlage wird serverseitig abgewiesen, es entsteht keine Zeile (F2, K04-M21, K19-M14)' \
                || nok ZB-11 "Anlage ohne Kenntnisnahme:$m"
  fi
fi
pruefe_sql_marke

# ---------------------------------------------------------------------
# ZB-12 · W7 + K04-M17 · Die Anlage gelingt nach der Kenntnisnahme:
#         genau EINE Zeile, beidseitig verknuepft, in einer Transaktion.
#
#         Der POSITIVE Fall. Ohne ihn misst der ganze Rest die
#         geschlossene Tuer: ein Server, der jede Anlage abweist,
#         bestuende ZB-04, ZB-11, ZB-15, ZB-16 und ZB-17 -- und liefe
#         nicht.
# ---------------------------------------------------------------------
if [ -z "$ANLEGEN_ZIEL" ] || [ -z "$KEKS_ANHANG" ]; then
  sperr ZB-12 "Nicht messbar: ${ANLEGEN_GRUND:-der Weg zur Anlage ist nicht bestimmbar}"
else
  cid="$(check_von 'zb_anhang@zbpruef.example')"
  vorher="$(anz_apps "$MANDANT_A")"
  st=$(sende "$ANLEGEN_ZIEL" zb_a6 "$KEKS_ANHANG" ${VERBORGEN[@]+"${VERBORGEN[@]}"})
  nachher="$(anz_apps "$MANDANT_A")"
  zeile="$(dbz "SELECT concat_ws('|', a.project_no, a.lifecycle_state::text, a.currency::text,
                       coalesce(a.fit_check_id::text,'(leer)'))
                  FROM app a WHERE a.tenant_id='$MANDANT_A'
                 ORDER BY a.project_no DESC LIMIT 1")"
  rueck="$(dbz "SELECT coalesce(app_id::text,'(leer)') FROM fit_check WHERE id='$cid'")"
  APP_NR_1="$(printf '%s' "$zeile" | cut -d'|' -f1)"
  m=""
  case "$st" in 2*|303) : ;; *) m="$m die Anlage lieferte Status $st;";; esac
  [ "$((nachher - vorher))" = "1" ] || m="$m es entstanden $((nachher - vorher)) Anwendungen statt genau einer;"
  case "$zeile" in
    *"|DISCOVERY|EUR|$cid") : ;;
    "") m="$m es entstand keine Anwendungszeile;";;
    *)  m="$m die Zeile steht auf '$zeile' -- erwartet waren Zustand DISCOVERY, Waehrung EUR und die Verknuepfung auf den Check $cid (K04-M17, K01-M27);";;
  esac
  # K04-M17: beidseitig. Die Anwendung zeigt auf den Check (oben) UND
  # der Check auf die Anwendung. Eine halbe Verknuepfung ist keine.
  if [ -z "$rueck" ] || [ "$rueck" = "(leer)" ]; then
    m="$m fit_check.app_id ist leer -- die Verknuepfung ist nur einseitig (K04-M17);"
  fi
  [ -z "$m" ] && ok ZB-12 "Die Anlage gelingt nach der Kenntnisnahme: genau eine Zeile, Zustand DISCOVERY, beidseitig mit dem Check verknuepft (W7, K04-M17, K01-M27)" \
              || nok ZB-12 "Die Anlage:$m"
fi
pruefe_sql_marke

# ---------------------------------------------------------------------
# ZB-13 · K01-D19 + F6 · "Kein Bildschirm, kein Formular und kein
#         Endpunkt DARF die Projektnummer zur Eingabe anbieten. Ein
#         dennoch mitgesendeter Wert wird verworfen."
#
#         ZWEI MESSUNGEN, und die zweite ist die, auf die es ankommt:
#         (a) auf keinem der gefahrenen Bildschirme steht ein Feld, das
#             die Projektnummer aufnimmt;
#         (b) ein trotzdem mitgesendeter, formal gueltiger Wert
#             erscheint NICHT in der angelegten Zeile.
#
#         Der mitgesendete Wert ist mit Absicht formgerecht
#         (DE-ZBA_777_77 passt auf das Muster der Spalte). Ein
#         formwidriger Wert waere an der Formpruefung gescheitert --
#         also an einer FREMDEN Bedingung. Genau dieser Fehler machte am
#         02.08.2026 drei von vier Negativfaellen wertlos.
# ---------------------------------------------------------------------
if [ -z "$ANLEGEN_ZIEL" ]; then
  sperr ZB-13 "Nicht messbar: der Weg zur Anlage ist nicht bestimmbar ($ANLEGEN_GRUND)"
elif ! bis_geeignet 'zb_zweit@zbpruef.example' '820013' zbzweit; then
  sperr ZB-13 "Nicht messbar: $FAHRT_GRUND"
else
  KEKS_ZWEIT="$FAHRT_KEKS"
  zweck_antwort "$KEKS_ZWEIT" zb_z1 "$FELD1" "$NEIN1" >/dev/null
  zweck_antwort "$KEKS_ZWEIT" zb_z2 "$FELD2" "$NEIN2" >/dev/null
  sende "$WEITER_ZIEL" zb_z3 "$KEKS_ZWEIT" ${VERBORGEN[@]+"${VERBORGEN[@]}"} >/dev/null
  z="$(nur_pfad "$(kopfzeile zb_z3 location)")"
  [ -n "$z" ] && hole "$z" zb_z3s "$KEKS_ZWEIT" >/dev/null || cp "$ARBEIT/zb_z3.rumpf" "$ARBEIT/zb_z3s.rumpf" 2>/dev/null

  UNTERGESCHOBEN='DE-ZBA_777_77'
  vorher="$(anz_apps "$MANDANT_A")"
  st=$(sende "$ANLEGEN_ZIEL" zb_z4 "$KEKS_ZWEIT" ${VERBORGEN[@]+"${VERBORGEN[@]}"} \
        "project_no=$UNTERGESCHOBEN" "projektnummer=$UNTERGESCHOBEN")
  nachher="$(anz_apps "$MANDANT_A")"
  cid="$(check_von 'zb_zweit@zbpruef.example')"
  nr="$(dbz "SELECT coalesce(a.project_no,'(keine)') FROM app a WHERE a.fit_check_id='$cid'")"
  uebernommen="$(dbz "SELECT count(*) FROM app WHERE project_no='$UNTERGESCHOBEN'")"

  # (a) Kein Eingabefeld fuer die Projektnummer auf den gefahrenen Seiten.
  feldfund=""
  for s in zb_f0 zb_f2s zb_f3s zb_z3s; do
    [ -f "$ARBEIT/$s.rumpf" ] || continue
    if felder "$s" | grep -qiE '^(FELD|HIDDEN)\|(project_no|project_number|projektnummer|projekt_nr|projektnr)\b' ; then
      feldfund="$feldfund $s"
    fi
  done

  m=""
  case "$st" in 2*|303) : ;; *) m="$m die Anlage lieferte Status $st;";; esac
  [ "$((nachher - vorher))" = "1" ] || m="$m es entstanden $((nachher - vorher)) Anwendungen statt genau einer -- ohne Zeile ist nicht pruefbar, welche Nummer sie traegt;"
  [ "${uebernommen:-0}" = "0" ] || m="$m die mitgesendete Projektnummer '$UNTERGESCHOBEN' wurde uebernommen (K01-D19, F6);"
  [ "$nr" != "$UNTERGESCHOBEN" ] || m="$m die angelegte Zeile traegt genau die mitgesendete Nummer (K01-D19, F6);"
  [ -z "$feldfund" ] || m="$m ein Bildschirm bietet die Projektnummer zur Eingabe an:$feldfund (K01-D19);"
  [ -z "$m" ] && ok ZB-13 "Die mitgesendete Projektnummer '$UNTERGESCHOBEN' wird verworfen — die Zeile traegt '$nr'; kein Bildschirm bietet sie zur Eingabe an (K01-D19, F6)" \
              || nok ZB-13 "Projektnummer im Aufruf:$m"
  APP_NR_2="$nr"
fi
pruefe_sql_marke

# ---------------------------------------------------------------------
# ZB-14 · K01-M38 · "Die Projektnummer bildet der serverseitige Befehl,
#         in derselben Transaktion. Sie wird vergeben, nicht eingegeben."
#
#         Gemessen an zwei Anlagen: beide Nummern bestehen, sie sind
#         VERSCHIEDEN, und beide tragen die Kundenkennung des Mandanten.
#         Zwei gleiche Nummern waeren keine Vergabe; eine Nummer aus
#         einem fremden Mandanten waere keine.
#
#         ERWEITERT AM 16.08.2026 um die zweite Haelfte derselben
#         Klausel: "sie wird VERGEBEN, NICHT EINGEGEBEN". Bis heute mass
#         dieser Fall nur, WAS herauskommt. Ein Serverbefehl, der eine
#         Projektnummer ENTGEGENNIMMT, ist aber schon als Gestalt ein
#         Verstoss -- er bietet die Nummer zur Eingabe an, und wer ihn
#         benutzt, kommt an der Klausel vorbei. Das war der offene Weg,
#         auf dem sieben Prueffaelle bis zum 16.08.2026 gruen standen.
#         Deshalb wird hier nicht der Bau befragt, sondern die Gestalt:
#         traegt IRGENDEINE Fassung von create_app_after_fit einen
#         Parameter fuer die Projektnummer, ist ZB-14 rot -- gleichgueltig,
#         wie schoen die zwei Nummern aussehen.
#         Kein Pruefwert wird dadurch gesenkt: die drei bisherigen
#         Bedingungen bleiben Wort fuer Wort stehen, eine vierte kommt hinzu.
# ---------------------------------------------------------------------
if [ -z "${APP_NR_1:-}" ] || [ -z "${APP_NR_2:-}" ] || [ "${APP_NR_2:-}" = "(keine)" ]; then
  sperr ZB-14 'Nicht messbar: es kamen nicht zwei Anlagen zustande, deren Nummern sich vergleichen liessen'
else
  kkz="$(dbz "SELECT customer_code FROM tenant WHERE id='$MANDANT_A'")"
  nr_param="$(dbz "SELECT coalesce(string_agg(n,','),'')
                     FROM pg_proc p, unnest(coalesce(p.proargnames,ARRAY[]::text[])) AS n
                    WHERE p.proname='create_app_after_fit'
                      AND n ~* '(project|projekt|nummer|(^|_)no\$|(^|_)nr(\$|_))'")"
  m=""
  [ "$APP_NR_1" != "$APP_NR_2" ] || m="$m beide Anlagen tragen dieselbe Nummer '$APP_NR_1' -- vergeben wird da nichts;"
  case "$APP_NR_1" in "$kkz"_*) : ;; *) m="$m die erste Nummer '$APP_NR_1' traegt nicht die Kundenkennung '$kkz' des Mandanten;";; esac
  case "$APP_NR_2" in "$kkz"_*) : ;; *) m="$m die zweite Nummer '$APP_NR_2' traegt nicht die Kundenkennung '$kkz' des Mandanten;";; esac
  [ -z "${nr_param:-}" ] || m="$m der Serverbefehl NIMMT eine Projektnummer ENTGEGEN (Parameter: $nr_param) -- damit wird sie eingegeben und nicht vergeben, und der Riegel ist umgehbar (K01-M38, K01-D19);"
  [ -z "$m" ] && ok ZB-14 "Die Projektnummer vergibt der Befehl: zwei Anlagen, zwei verschiedene Nummern ('$APP_NR_1', '$APP_NR_2'), beide mit der Kundenkennung '$kkz' — und kein Wert des Befehls nimmt eine Nummer entgegen (K01-M38, K01-D19)" \
              || nok ZB-14 "Vergabe der Projektnummer:$m"
fi
pruefe_sql_marke

# ---------------------------------------------------------------------
# ZB-15 · F7 + K04-M18 · "Der Server MUSS Ergebnis, drei aktive
#         Antworten und Mandant UNMITTELBAR VOR der Anlage erneut lesen.
#         Ein veralteter Bildschirmstand berechtigt nicht zur Anlage."
#
#         SO WIRD ES GEMESSEN: ein Konto faehrt bis zu dem Bildschirm,
#         auf dem der Weg zur Anlage offen steht. DANN -- und erst dann
#         -- kippt der Eignungs-Check in der Datenbank auf
#         NICHT_GEEIGNET. Der Bildschirm der Nutzerin weiss davon
#         nichts; er zeigt den Weg weiter an. Jetzt wird er gefahren.
#
#         Ein Server, der die Eignung beim Anzeigen gelesen und sich
#         gemerkt hat, legt die Zeile an -- und faellt durch. Nur ein
#         Server, der UNMITTELBAR VOR der Anlage noch einmal liest,
#         weist ab. Genau diese Unterscheidung ist K04-M18.
# ---------------------------------------------------------------------
if [ -z "$ANLEGEN_ZIEL" ]; then
  sperr ZB-15 "Nicht messbar: der Weg zur Anlage ist nicht bestimmbar ($ANLEGEN_GRUND)"
elif ! bis_geeignet 'zb_wechsel@zbpruef.example' '820008' zbwech; then
  sperr ZB-15 "Nicht messbar: $FAHRT_GRUND"
else
  KEKS_WECHSEL="$FAHRT_KEKS"
  zweck_antwort "$KEKS_WECHSEL" zb_w1 "$FELD1" "$NEIN1" >/dev/null
  zweck_antwort "$KEKS_WECHSEL" zb_w2 "$FELD2" "$NEIN2" >/dev/null
  sende "$WEITER_ZIEL" zb_w3 "$KEKS_WECHSEL" ${VERBORGEN[@]+"${VERBORGEN[@]}"} >/dev/null
  z="$(nur_pfad "$(kopfzeile zb_w3 location)")"
  [ -n "$z" ] && hole "$z" zb_w3s "$KEKS_WECHSEL" >/dev/null || cp "$ARBEIT/zb_w3.rumpf" "$ARBEIT/zb_w3s.rumpf" 2>/dev/null
  cid="$(check_von 'zb_wechsel@zbpruef.example')"
  weg_offen=0
  fuehrt_zu zb_w3s "$ANLEGEN_ZIEL" && weg_offen=1

  # Der Wechsel -- NACH der Anzeige, VOR der Anlage.
  db "UPDATE fit_check SET outcome='NICHT_GEEIGNET',
             completed_at=coalesce(completed_at, now())
       WHERE id='$cid'" >/dev/null
  vorher="$(anz_apps "$MANDANT_A")"
  st=$(sende "$ANLEGEN_ZIEL" zb_w4 "$KEKS_WECHSEL" ${VERBORGEN[@]+"${VERBORGEN[@]}"})
  nachher="$(anz_apps "$MANDANT_A")"
  appid="$(dbz "SELECT coalesce(app_id::text,'(leer)') FROM fit_check WHERE id='$cid'")"
  m=""
  [ "$weg_offen" = "1" ] || m="$m der Aufbau des Falls stimmt nicht: der Weg zur Anlage stand auf dem Bildschirm gar nicht offen, es gab also keinen veralteten Stand zu messen;"
  case "$st" in
    2*|4*) : ;;
    303) ziel="$(nur_pfad "$(kopfzeile zb_w4 location)")"
         case "$ziel" in
           "$ZWECK_PFAD"|/eignung) : ;;
           *) m="$m die Anlage wurde mit 303 auf '$ziel' angenommen, obwohl die Eignung inzwischen NICHT_GEEIGNET ist;";;
         esac;;
    5*) m="$m Status $st -- abgewiesen wird die Anlage damit nicht, der Weg stuerzt ab;";;
    *)  m="$m unerwarteter Status $st;";;
  esac
  [ "$vorher" = "$nachher" ] || m="$m es entstand eine Anwendung ($vorher -> $nachher) auf einem veralteten Bildschirmstand (K04-M18, F7);"
  [ "$appid" = "(leer)" ] || m="$m fit_check.app_id traegt '$appid' statt leer;"
  [ -z "$m" ] && ok ZB-15 'Wechselt die Eignung zwischen Anzeige und Anlage, scheitert die Anlage: der Server liest sie unmittelbar vorher erneut (K04-M18, F7)' \
              || nok ZB-15 "Veralteter Bildschirmstand:$m"
fi
pruefe_sql_marke

# ---------------------------------------------------------------------
# ZB-16 · F4 · "Der Nachweis der Kenntnisnahme laesst sich nicht
#         schreiben -> kein Weiterweg, keine Anwendung."
#
#         WIE DER FEHLSCHLAG HERBEIGEFUEHRT WIRD, OHNE DEN CODE ZU
#         KENNEN: Das Datenmodell bindet die Kenntnisnahme an die
#         Aufbewahrungsklasse KI_NACHWEIS (Art. 25 Abs. 4 ist ein
#         KI-Nachweis, kein Betriebsprotokoll). Steht der Check auf
#         BETRIEBSPROTOKOLL, ist der Nachweis nicht schreibbar -- ohne
#         dass irgendetwas am Server angefasst wurde.
#
#         DREI AUSGAENGE, und das ist Absicht:
#           gruen   der Nachweis scheiterte UND es entstand keine
#                   Anwendung und kein Weiterweg  (fail-closed haelt)
#           rot     der Nachweis scheiterte UND der Weg ging trotzdem
#                   weiter                        (fail-closed haelt nicht)
#           gesperrt der Nachweis liess sich mit diesem Mittel nicht
#                   verhindern -- dann ist F4 hier nicht messbar, und
#                   ein Fall, der nichts gemessen hat, ist nicht gruen.
# ---------------------------------------------------------------------
if [ -z "$KENNTNIS_ZIEL" ]; then
  sperr ZB-16 "Nicht messbar: die Aufforderung zu bestaetigen wurde nicht gefunden ($KENNTNIS_GRUND)"
elif [ "${ACK_SPALTE:-0}" != "1" ]; then
  sperr ZB-16 'Nicht messbar: die Kenntnisnahme haengt an keiner Spalte von fit_check; mit welchem Mittel sie unschreibbar zu machen waere, ist ohne Kenntnis des Traegers nicht entscheidbar (K04-G12)'
elif ! bis_geeignet 'zb_nachweis@zbpruef.example' '820009' zbnw; then
  sperr ZB-16 "Nicht messbar: $FAHRT_GRUND"
else
  KEKS_NW="$FAHRT_KEKS"
  zweck_antwort "$KEKS_NW" zb_n1 "$FELD1" "$JA1"   >/dev/null
  zweck_antwort "$KEKS_NW" zb_n2 "$FELD2" "$NEIN2" >/dev/null
  sende "$WEITER_ZIEL" zb_n3 "$KEKS_NW" ${VERBORGEN[@]+"${VERBORGEN[@]}"} >/dev/null
  cid="$(check_von 'zb_nachweis@zbpruef.example')"
  db "UPDATE fit_check SET retention_class='BETRIEBSPROTOKOLL' WHERE id='$cid'" >/dev/null
  klasse="$(dbz "SELECT retention_class::text FROM fit_check WHERE id='$cid'")"
  vorher="$(anz_apps "$MANDANT_A")"
  st=$(sende "$KENNTNIS_ZIEL" zb_n4 "$KEKS_NW" ${VERBORGEN[@]+"${VERBORGEN[@]}"})
  nw="$(nachweise 'zb_nachweis@zbpruef.example')"
  nachher="$(anz_apps "$MANDANT_A")"
  # Der Weiterweg: steht nach dem gescheiterten Nachweis der Weg zur
  # Anlage offen?
  hole "$ZWECK_PFAD" zb_n5 "$KEKS_NW" >/dev/null
  weg=0
  [ -n "$ANLEGEN_ZIEL" ] && fuehrt_zu zb_n5 "$ANLEGEN_ZIEL" && weg=1
  if [ "$klasse" != "BETRIEBSPROTOKOLL" ]; then
    sperr ZB-16 "Nicht messbar: die Aufbewahrungsklasse liess sich nicht auf BETRIEBSPROTOKOLL setzen (sie steht auf '$klasse') -- der Nachweis war mit diesem Mittel nicht unschreibbar zu machen"
  elif [ "${nw:-0}" -ge 1 ]; then
    sperr ZB-16 "Nicht messbar: der Nachweis wurde trotz Klasse BETRIEBSPROTOKOLL geschrieben; mit welchem Mittel er unschreibbar zu machen waere, ist ohne Kenntnis des Traegers nicht entscheidbar. Ein Fall, der nichts gemessen hat, ist nicht bestanden (K23-M22)"
  else
    m=""
    case "$st" in 2*|4*|303) : ;; 5*) m="$m Status $st -- der Weg stuerzt ab, statt abzuweisen;";; *) m="$m unerwarteter Status $st;";; esac
    [ "$vorher" = "$nachher" ] || m="$m es entstand eine Anwendung ($vorher -> $nachher), obwohl der Nachweis nicht geschrieben werden konnte (F4);"
    [ "$weg" = "0" ] || m="$m der Weg zur Anlage steht trotz gescheitertem Nachweis offen (F4, K04-M21);"
    [ -z "$m" ] && ok ZB-16 'Laesst sich der Nachweis nicht schreiben, gibt es keinen Weiterweg und keine Anwendung — fail-closed (F4, K04-M21)' \
                || nok ZB-16 "Nachweis nicht schreibbar:$m"
  fi
fi
pruefe_sql_marke

# ---------------------------------------------------------------------
# ZB-17 · W8 · Ausweg 1 aus dem Halt · Antwort aendern
#         Die frueher gegebene Antwort wird ZURUECKGENOMMEN, nicht
#         entfernt (K04-D03), und der Weg beginnt wieder bei W1.
# ---------------------------------------------------------------------
if [ -z "$ZWECK_PFAD" ] || [ -z "$WEITER_ZIEL" ]; then
  sperr ZB-17 "Nicht messbar: ${ZWECK_GRUND:-$WEITER_GRUND}"
elif ! bis_geeignet 'zb_aendern@zbpruef.example' '820010' zbaend; then
  sperr ZB-17 "Nicht messbar: $FAHRT_GRUND"
else
  KEKS_AEND="$FAHRT_KEKS"
  zweck_antwort "$KEKS_AEND" zb_e1 "$FELD1" "$NEIN1" >/dev/null
  zweck_antwort "$KEKS_AEND" zb_e2 "$FELD2" "$JA2"   >/dev/null
  sende "$WEITER_ZIEL" zb_e3 "$KEKS_AEND" ${VERBORGEN[@]+"${VERBORGEN[@]}"} >/dev/null
  z="$(nur_pfad "$(kopfzeile zb_e3 location)")"
  [ -n "$z" ] && hole "$z" zb_e3s "$KEKS_AEND" >/dev/null || cp "$ARBEIT/zb_e3.rumpf" "$ARBEIT/zb_e3s.rumpf" 2>/dev/null
  cid="$(check_von 'zb_aendern@zbpruef.example')"
  zeilen_vorher="$(dbz "SELECT count(*) FROM fit_answer WHERE fit_check_id='$cid'")"
  # Der Ausweg wird ueber das Ziel gefahren, das die Halt-Seite selbst
  # dafuer ausgibt -- nicht ueber eine geratene Adresse.
  ausweg=""
  while read -r zz; do
    [ -n "$zz" ] || continue
    case "$zz" in *aendern*) ausweg="$zz";; esac
  done <<EOF
$(zieltexte zb_e3s)
EOF
  if [ -z "$ausweg" ]; then
    sperr ZB-17 'Nicht messbar: die Halt-Seite gibt keinen Weg aus, die Antwort zu aendern'
  else
    apps_vorher="$(anz_apps "$MANDANT_A")"
    st=$(sende "$ausweg" zb_e4 "$KEKS_AEND" ${VERBORGEN[@]+"${VERBORGEN[@]}"})
    zeilen_nachher="$(dbz "SELECT count(*) FROM fit_answer WHERE fit_check_id='$cid'")"
    st2=$(hole "$ZWECK_PFAD" zb_e5 "$KEKS_AEND")
    st3=$(hole /eignung zb_e6 "$KEKS_AEND")
    apps_nachher="$(anz_apps "$MANDANT_A")"
    m=""
    case "$st" in 2*|303) : ;; *) m="$m der Ausweg lieferte Status $st;";; esac
    [ "${zeilen_nachher:-0}" -ge "${zeilen_vorher:-0}" ] \
      || m="$m es wurden Antwortzeilen entfernt ($zeilen_vorher -> $zeilen_nachher) statt zurueckgenommen (K04-D03);"
    { [ "$st2" = "200" ] || [ "$st3" = "200" ]; } \
      || m="$m nach dem Ausweg ist weder der Zweckbildschirm ($st2) noch der Eignungs-Check ($st3) wieder erreichbar;"
    [ "$apps_vorher" = "$apps_nachher" ] || m="$m es entstand eine Anwendung ($apps_vorher -> $apps_nachher), obwohl der Weg aus dem Halt zurueckfuehrt;"
    [ -z "$m" ] && ok ZB-17 'AUSWEG 1: Antwort aendern fuehrt aus dem Halt zurueck zum Bildschirm; keine Antwortzeile wird entfernt (W8, K04-M08, K04-D03)' \
                || nok ZB-17 "Ausweg 1 (Antwort aendern):$m"
  fi
fi
pruefe_sql_marke

# ---------------------------------------------------------------------
# ZB-18 · W9 · Ausweg 2 aus dem Halt · Termin
#         Der Wunsch wird VERMERKT -- gemessen als ZUNAHME der
#         Ereignisse, nicht als Gesamtstand: event ist append-only, ein
#         Gesamtstand maesse auch fremde Laeufe. Und der Halt bleibt,
#         was er war: kein Weiterweg, keine Anwendung.
# ---------------------------------------------------------------------
if [ -z "$ZWECK_PFAD" ] || [ -z "$WEITER_ZIEL" ]; then
  sperr ZB-18 "Nicht messbar: ${ZWECK_GRUND:-$WEITER_GRUND}"
elif ! bis_geeignet 'zb_termin@zbpruef.example' '820011' zbterm; then
  sperr ZB-18 "Nicht messbar: $FAHRT_GRUND"
else
  KEKS_TERM="$FAHRT_KEKS"
  zweck_antwort "$KEKS_TERM" zb_t1 "$FELD1" "$NEIN1" >/dev/null
  zweck_antwort "$KEKS_TERM" zb_t2 "$FELD2" "$JA2"   >/dev/null
  sende "$WEITER_ZIEL" zb_t3 "$KEKS_TERM" ${VERBORGEN[@]+"${VERBORGEN[@]}"} >/dev/null
  z="$(nur_pfad "$(kopfzeile zb_t3 location)")"
  [ -n "$z" ] && hole "$z" zb_t3s "$KEKS_TERM" >/dev/null || cp "$ARBEIT/zb_t3.rumpf" "$ARBEIT/zb_t3s.rumpf" 2>/dev/null
  ausweg=""
  while read -r zz; do
    [ -n "$zz" ] || continue
    case "$zz" in *termin*|*gespraech*|*kontakt*) ausweg="$zz";; esac
  done <<EOF
$(zieltexte zb_t3s)
EOF
  if [ -z "$ausweg" ]; then
    sperr ZB-18 'Nicht messbar: die Halt-Seite gibt keinen Weg zum Termin aus'
  elif [ "${ANSPRECHPERSON:-}" != "JA" ]; then
    sperr ZB-18 "Nicht messbar: im Mandanten steht keine Ansprechperson ($ANSPRECHPERSON) -- der Ausweg scheiterte an einer fremden Bedingung (F07)"
  else
    cid="$(check_von 'zb_termin@zbpruef.example')"
    vorher_ev="$(dbz "SELECT count(*) FROM event WHERE tenant_id='$MANDANT_A' AND action ILIKE '%TERMIN%'")"
    stand_vorher="$(stand_von 'zb_termin@zbpruef.example')"
    apps_vorher="$(anz_apps "$MANDANT_A")"
    st=$(sende "$ausweg" zb_t4 "$KEKS_TERM" ${VERBORGEN[@]+"${VERBORGEN[@]}"})
    nachher_ev="$(dbz "SELECT count(*) FROM event WHERE tenant_id='$MANDANT_A' AND action ILIKE '%TERMIN%'")"
    stand_nachher="$(stand_von 'zb_termin@zbpruef.example')"
    apps_nachher="$(anz_apps "$MANDANT_A")"
    m=""
    case "$st" in 2*|303) : ;; *) m="$m der Ausweg lieferte Status $st;";; esac
    [ "$((nachher_ev - vorher_ev))" -ge 1 ] \
      || m="$m der Terminwunsch wurde nicht vermerkt: die Zahl der Ereignisse blieb bei $vorher_ev (W9, K04-M08);"
    [ "$stand_vorher" = "$stand_nachher" ] \
      || m="$m der Termin hat den Check veraendert ('$stand_vorher' -> '$stand_nachher');"
    [ "$apps_vorher" = "$apps_nachher" ] || m="$m es entstand eine Anwendung ($apps_vorher -> $apps_nachher), obwohl der Weg im Halt endet (K04-D10);"
    [ -z "$m" ] && ok ZB-18 'AUSWEG 2: der Terminwunsch wird als Ereignis vermerkt, der Halt bleibt unveraendert, keine Anwendung (W9, K04-M08)' \
                || nok ZB-18 "Ausweg 2 (Termin):$m"
  fi
fi
pruefe_sql_marke

# ---------------------------------------------------------------------
# ZB-19 · W10 · Ausweg 3 aus dem Halt · zur Uebersicht
#         Die Uebersicht oeffnet sich, und der Vorgang bleibt erhalten:
#         der Eignungs-Check unveraendert, die Antwortzeilen
#         unveraendert, keine Anwendung. Ein Ausweg, der den Vorgang
#         tilgt, waere keiner (K04-D03).
# ---------------------------------------------------------------------
if [ -z "$ZWECK_PFAD" ] || [ -z "$WEITER_ZIEL" ]; then
  sperr ZB-19 "Nicht messbar: ${ZWECK_GRUND:-$WEITER_GRUND}"
elif ! bis_geeignet 'zb_uebersicht@zbpruef.example' '820012' zbueb; then
  sperr ZB-19 "Nicht messbar: $FAHRT_GRUND"
else
  KEKS_UEB="$FAHRT_KEKS"
  zweck_antwort "$KEKS_UEB" zb_u1 "$FELD1" "$NEIN1" >/dev/null
  zweck_antwort "$KEKS_UEB" zb_u2 "$FELD2" "$JA2"   >/dev/null
  sende "$WEITER_ZIEL" zb_u3 "$KEKS_UEB" ${VERBORGEN[@]+"${VERBORGEN[@]}"} >/dev/null
  z="$(nur_pfad "$(kopfzeile zb_u3 location)")"
  [ -n "$z" ] && hole "$z" zb_u3s "$KEKS_UEB" >/dev/null || cp "$ARBEIT/zb_u3.rumpf" "$ARBEIT/zb_u3s.rumpf" 2>/dev/null
  ausweg=""
  while read -r zz; do
    [ -n "$zz" ] || continue
    case "$zz" in *uebersicht*) ausweg="$zz";; esac
  done <<EOF
$(zieltexte zb_u3s)
EOF
  if [ -z "$ausweg" ]; then
    sperr ZB-19 'Nicht messbar: die Halt-Seite gibt keinen Weg zur Uebersicht aus'
  else
    cid="$(check_von 'zb_uebersicht@zbpruef.example')"
    vorher_stand="$(stand_von 'zb_uebersicht@zbpruef.example')"
    vorher_zeilen="$(dbz "SELECT count(*) FROM fit_answer WHERE fit_check_id='$cid'")"
    apps_vorher="$(anz_apps "$MANDANT_A")"
    st=$(hole "$ausweg" zb_u4 "$KEKS_UEB")
    nachher_stand="$(stand_von 'zb_uebersicht@zbpruef.example')"
    nachher_zeilen="$(dbz "SELECT count(*) FROM fit_answer WHERE fit_check_id='$cid'")"
    apps_nachher="$(anz_apps "$MANDANT_A")"
    m=""
    [ "$st" = "200" ] || m="$m die Uebersicht lieferte Status $st statt 200;"
    [ "$vorher_stand" = "$nachher_stand" ] || m="$m der Check aenderte sich von '$vorher_stand' auf '$nachher_stand' (K04-D03);"
    [ "$vorher_zeilen" = "$nachher_zeilen" ] || m="$m die Zahl der Antwortzeilen aenderte sich von $vorher_zeilen auf $nachher_zeilen (K04-D03);"
    [ "$apps_vorher" = "$apps_nachher" ] || m="$m es entstand eine Anwendung ($apps_vorher -> $apps_nachher);"
    [ -z "$m" ] && ok ZB-19 'AUSWEG 3: die Uebersicht oeffnet sich, der Vorgang bleibt vollstaendig erhalten, keine Anwendung (W10, K04-M08, K04-D03)' \
                || nok ZB-19 "Ausweg 3 (zur Uebersicht):$m"
  fi
fi
pruefe_sql_marke

# =====================================================================
# TEIL C · DIE FAELLE GEGEN DIE DATENBANK
#
# Sie messen den Riegel selbst, nicht seine Anzeige. Jeder laeuft in
# einer Transaktion mit ROLLBACK -- gelaenge er wider Erwarten, bliebe
# kein Schaden zurueck. Die Fehlermeldung im WORTLAUT ist Teil des
# Belegs (Bauauftrag :649).
# =====================================================================

# =====================================================================
# NACHGEZOGEN AM 16.08.2026 · ZB-20, ZB-21, ZB-22 UND ZB-23
# WORAUF SICH DIE AENDERUNG STUETZT -- UND WORAUF AUSDRUECKLICH NICHT
# =====================================================================
# Bis heute riefen diese vier Faelle create_app_after_fit in einer
# Gestalt auf, die eine PROJEKTNUMMER UEBERGIBT ('DE-ZBA_901_01' und
# fort). Diese Gestalt misst einen Weg, den zwei GEZEICHNETE KLAUSELN
# verbieten:
#
#   K01-M38 · MUSS
#     "Die Projektnummer MUSS der serverseitige Befehl bilden, in
#      derselben Transaktion, in der die Anwendungszeile entsteht.
#      SIE WIRD VERGEBEN, NICHT EINGEGEBEN."
#
#   K01-D19 · DARF NICHT
#     "Kein Bildschirm, kein Formular und kein Endpunkt DARF die
#      Projektnummer zur Eingabe, Auswahl oder Aenderung anbieten.
#      EIN DENNOCH MITGESENDETER WERT WIRD VERWORFEN."
#
# BEIDE KLAUSELN GALTEN VORHER. Ein Prueffall, der eine Projektnummer
# uebergibt, war damit schon vorher falsch -- er ist nur nie
# aufgefallen, weil eine zweite Fassung des Befehls offenstand, die den
# Wert entgegennahm, und ihn trug. Wer in einem Jahr fragt, warum diese
# vier Faelle geaendert wurden: WEIL DIE KLAUSEL ES SO VERLANGT, nicht
# weil der Bau es so tut. Traegt der Befehl morgen wieder einen
# Parameter fuer die Projektnummer, wird hier nichts zurueckgedreht --
# dann meldet ZB-14 einen Verstoss gegen K01-M38.
#
# KEIN PRUEFWERT WIRD GESENKT (K23-D05):
#   * Die Bedingung "es blieb keine Zeile stehen" haengt jetzt am NAMEN
#     der Anwendung statt an der Projektnummer. Die Namen dieser vier
#     Faelle sind untereinander und gegen den uebrigen Bestand
#     verschieden; gemessen wird dasselbe.
#   * Die Reihenfolge der vier Werte wird NEU an den Parameternamen
#     geprueft (siehe BEFEHL_LAGE). Drei der vier Werte sind uuid --
#     ohne diese Pruefung waere eine Vertauschung STILL, und die
#     Negativfaelle scheiterten an einer fremden Bedingung, statt an
#     ihrer eigenen. Das ist strenger als vorher, nicht lockerer.
#   * ZB-20 laesst den DIREKTEN INSERT in app bewusst weiter mit
#     Projektnummer laufen. Er ist der VERBOTENE Weg und muss am
#     Rechteschnitt scheitern; Postgres prueft Rechte vor Bedingungen,
#     die Nummer aendert daran nichts. Ohne sie scheiterte er an
#     project_no NOT NULL -- also an einer fremden Bedingung.
#
# DIE GESTALT WIRD ERFRAGT, NICHT ANGENOMMEN. BEFEHL_LAGE trennt drei
# Faelle:
#   leer                -> messbar
#   'VERSTOSS ...'      -> der Befehl nimmt eine Projektnummer entgegen.
#                          Gemeldet wird das dort, wo es hingehoert:
#                          in ZB-14 (K01-M38). Die vier Faelle hier
#                          sperren, denn den klauselgemaessen Aufruf
#                          gibt es dann nicht.
#   'NICHT MESSBAR ...' -> die Gestalt gibt den Aufruf nicht her
# =====================================================================
BEFEHL_ARGS="$(dbz "SELECT coalesce(string_agg(array_to_string(coalesce(p.proargnames,ARRAY[]::text[]),','),' | '),'')
                      FROM pg_proc p WHERE p.proname='create_app_after_fit'")"
BEFEHL_TYPEN="$(dbz "SELECT coalesce(string_agg(t.liste,' | '),'')
                       FROM pg_proc p
                       CROSS JOIN LATERAL (
                         SELECT coalesce(string_agg(format_type(u.typ,NULL),',' ORDER BY u.pos),'') AS liste
                           FROM unnest(p.proargtypes) WITH ORDINALITY AS u(typ,pos)) t
                      WHERE p.proname='create_app_after_fit'")"
BEFEHL_N="$(dbz "SELECT coalesce(max(pronargs),0) FROM pg_proc WHERE proname='create_app_after_fit'")"
BEFEHL_ANZ="$(dbz "SELECT count(*) FROM pg_proc WHERE proname='create_app_after_fit'")"
# Traegt IRGENDEINE Fassung einen Parameter, der die Projektnummer
# entgegennimmt? Das ist der Verstoss gegen K01-M38, nicht ein Mangel
# der Messung.
BEFEHL_NR_PARAM="$(dbz "SELECT coalesce(string_agg(n,','),'')
                          FROM pg_proc p, unnest(coalesce(p.proargnames,ARRAY[]::text[])) AS n
                         WHERE p.proname='create_app_after_fit'
                           AND n ~* '(project|projekt|nummer|(^|_)no\$|(^|_)nr(\$|_))'")"
pruefe_sql_marke

BEFEHL_LAGE=""
if [ "${BEFEHL_ANZ:-0}" = "0" ]; then
  BEFEHL_LAGE='NICHT MESSBAR: create_app_after_fit besteht nicht'
elif [ -n "${BEFEHL_NR_PARAM:-}" ]; then
  BEFEHL_LAGE="VERSTOSS gegen K01-M38 (\"sie wird vergeben, nicht eingegeben\"): der Befehl nimmt eine Projektnummer entgegen -- Parameter: $BEFEHL_NR_PARAM. Einen klauselgemaessen Aufruf gibt es damit nicht"
elif [ "${BEFEHL_ANZ:-0}" != "1" ]; then
  BEFEHL_LAGE="NICHT MESSBAR: es bestehen $BEFEHL_ANZ Fassungen von create_app_after_fit ($BEFEHL_ARGS); welche gemeint ist, liesse sich nur raten"
elif [ "${BEFEHL_N:-0}" != "4" ]; then
  BEFEHL_LAGE="NICHT MESSBAR: create_app_after_fit besteht nicht in der Gestalt mit vier Werten (gefunden: $BEFEHL_N -- $BEFEHL_ARGS)"
elif [ "${BEFEHL_TYPEN:-}" != "uuid,text,uuid,uuid" ]; then
  BEFEHL_LAGE="NICHT MESSBAR: die Werte tragen die Typen '$BEFEHL_TYPEN' statt uuid,text,uuid,uuid; die Zuordnung liesse sich nur raten"
elif ! printf '%s' "$BEFEHL_ARGS" \
     | grep -Eqi '^[^,|]*(tenant|mandant)[^,|]*,[^,|]*(name|bezeichn)[^,|]*,[^,|]*(fit|check|eignung)[^,|]*,[^,|]*(actor|konto|account)[^,|]*$'; then
  # Drei der vier Werte sind uuid. Ohne diese Pruefung waere eine
  # Vertauschung STILL, und jeder Negativfall scheiterte danach an einer
  # FREMDEN Bedingung (Massstab F07).
  BEFEHL_LAGE="NICHT MESSBAR: die vier Werte heissen '$BEFEHL_ARGS'; welcher Wert wohin gehoert, liesse sich nur raten (erwartet der Reihe nach: Mandant, Name, Eignungs-Check, Konto)"
fi

printf '\nServerbefehl: create_app_after_fit(%s) — Typen (%s)\n' \
       "${BEFEHL_ARGS:-NICHT VORHANDEN}" "${BEFEHL_TYPEN:-—}"
printf 'Gestalt: %s\n' "${BEFEHL_LAGE:-klauselgemaess (vier Werte, keine Projektnummer) — messbar}"

# Der Aufruf in der Gestalt, die auch pruefungen/migration/M30__pruefung.sql
# fuehrt: (Mandant, Name, Eignungs-Check, Konto). OHNE Projektnummer --
# sie wird vergeben, nicht eingegeben (K01-M38).
befehl_aufruf() {    # $1 mandant  $2 name  $3 check  $4 konto
  printf "SELECT create_app_after_fit('%s','%s','%s','%s')" "$1" "$2" "$3" "$4"
}

# ---------------------------------------------------------------------
# ZB-20 · K01-M27 + K04-D06 · "Eine Anwendungszeile entsteht
#         AUSSCHLIESSLICH ueber den serverseitigen Befehl."
#
#         DIE UNTERSCHEIDUNG, ohne die der Fall nichts misst: unter
#         DERSELBEN Rolle wird beides versucht -- der direkte INSERT in
#         app und der Aufruf des Befehls. Der eine MUSS scheitern, der
#         andere MUSS gelingen.
#
#         Ein Rechteschnitt, der alles verbietet, bestuende die Haelfte
#         dieses Falls und liesse die Anwendung nicht laufen. Genau das
#         war der Befund an MT-96 und MT-97: "Ein Regime, das alles
#         verbietet, bestuende jeden Negativtest."
# ---------------------------------------------------------------------
#         NACHGEZOGEN AM 16.08.2026 auf K01-M38 und K01-D19 -- die
#         Begruendung steht im Block ueber befehl_aufruf(). Der direkte
#         INSERT behaelt seine Projektnummer mit Absicht: er ist der
#         VERBOTENE Weg und muss am Rechteschnitt scheitern, nicht an
#         project_no NOT NULL.
# ---------------------------------------------------------------------
rolle_da="$(dbz "SELECT count(*) FROM pg_roles WHERE rolname='fr_portal'")"
pruefe_sql_marke
if [ "${rolle_da:-0}" != "1" ]; then
  sperr ZB-20 'Nicht messbar: die Rolle fr_portal besteht nicht -- ohne sie ist nicht entscheidbar, was dem Portalpfad erlaubt ist'
elif [ -n "$BEFEHL_LAGE" ]; then
  sperr ZB-20 "Nicht messbar: $BEFEHL_LAGE"
else
  direkt="$(dbf "SET LOCAL ROLE fr_portal;
                 INSERT INTO app(tenant_id,project_no,name,created_at,fit_check_id)
                 VALUES ('$MANDANT_A','DE-ZBA_900_01','ZB20 Direkt vorbei',current_date,'$CHECK_GEEIGNET')")"
  offen="$(dbf "SET LOCAL ROLE fr_portal;
                $(befehl_aufruf "$MANDANT_A" 'ZB20 Ueber den Befehl' "$CHECK_GEEIGNET" "$KONTO_DB")")"
  m=""
  case "$direkt" in
    KEIN_FEHLER) m="$m der Portalpfad darf app direkt beschreiben -- der Befehl ist umgehbar (K01-M27);";;
    *"denied for table app"*|*"keine Berechtigung"*|*"permission denied"*) : ;;
    *) m="$m der direkte INSERT scheiterte an einer FREMDEN Bedingung, nicht am Rechteschnitt: $direkt;";;
  esac
  case "$offen" in
    KEIN_FEHLER) : ;;
    *) m="$m unter der Rolle des Portals gelingt der Serverbefehl NICHT: $offen -- ein Riegel, der auch den vorgesehenen Weg sperrt, laesst die Anwendung nicht laufen;";;
  esac
  [ -z "$m" ] && ok ZB-20 'Unter der Rolle des Portals ist der direkte INSERT in app verwehrt, der Serverbefehl aber erlaubt — die geschlossene UND die offene Tuer gemessen (K01-M27, K04-D06)' \
              || nok ZB-20 "Der Riegel vor app:$m"
fi
pruefe_sql_marke

# ---------------------------------------------------------------------
# ZB-21 · F1 + K01-M27 · Anlage ohne GEEIGNET wird abgewiesen, es
#         entsteht keine Zeile.
#
#         Der Negativfall scheitert an SEINER EIGENEN Bedingung: alles
#         andere ist richtig -- Mandant, aktives Konto, formgerechte
#         Nummer, bestehender Check. Falsch ist allein sein Ergebnis
#         (OFFEN). Die Meldung wird im Wortlaut ausgewiesen.
# ---------------------------------------------------------------------
#         NACHGEZOGEN AM 16.08.2026 auf K01-M38 und K01-D19 (Begruendung
#         im Block ueber befehl_aufruf()). Der Nachweis "es blieb keine
#         Zeile stehen" haengt jetzt am NAMEN statt an der Projektnummer
#         -- die vergibt der Befehl, der Aufrufer kennt sie nicht mehr.
if [ -n "$BEFEHL_LAGE" ]; then
  sperr ZB-21 "Nicht messbar: $BEFEHL_LAGE"
else
  meldung="$(dbf "$(befehl_aufruf "$MANDANT_A" 'ZB21 Ohne Eignung' "$CHECK_OFFEN" "$KONTO_DB")")"
  bestand="$(dbz "SELECT count(*) FROM app WHERE name='ZB21 Ohne Eignung'")"
  m=""
  case "$meldung" in
    KEIN_FEHLER) m="$m die Anlage auf einem Check mit outcome = OFFEN wurde angenommen (K01-M27, F1);";;
    *ANLAGE*|*GEEIGNET*|*EIGNUNG*) : ;;
    *) m="$m sie scheiterte an einer FREMDEN Bedingung, nicht am Eignungsriegel: $meldung;";;
  esac
  [ "${bestand:-0}" = "0" ] || m="$m es blieb eine Zeile stehen;"
  [ -z "$m" ] && ok ZB-21 "Anlage ohne GEEIGNET wird abgewiesen, keine Zeile — Meldung im Wortlaut: $meldung (F1, K01-M27)" \
              || nok ZB-21 "Anlage ohne Eignung:$m"
fi
pruefe_sql_marke

# ---------------------------------------------------------------------
# ZB-22 · F3 + K04-D08 · Ein Konto eines FREMDEN Mandanten legt nichts
#         an. "Er gilt als nicht vorhanden."
#
#         Zwei Richtungen, damit der Fall nicht an der bequemen haengen
#         bleibt:
#           (a) fremdes Konto, eigener Check
#           (b) eigenes Konto, fremder Check
#         Beides muss abgewiesen werden, und beides an der
#         Mandantenbedingung.
# ---------------------------------------------------------------------
#         NACHGEZOGEN AM 16.08.2026 auf K01-M38 und K01-D19 (Begruendung
#         im Block ueber befehl_aufruf()). Beide Richtungen bleiben
#         erhalten; der Nachweis "es blieben keine Zeilen stehen" haengt
#         jetzt am NAMEN statt an der Projektnummer.
if [ -n "$BEFEHL_LAGE" ]; then
  sperr ZB-22 "Nicht messbar: $BEFEHL_LAGE"
else
  m1="$(dbf "$(befehl_aufruf "$MANDANT_A" 'ZB22 Fremdes Konto' "$CHECK_GEEIGNET" "$KONTO_FREMD")")"
  m2="$(dbf "$(befehl_aufruf "$MANDANT_A" 'ZB22 Fremder Check' "$CHECK_FREMD" "$KONTO_DB")")"
  bestand="$(dbz "SELECT count(*) FROM app WHERE name IN ('ZB22 Fremdes Konto','ZB22 Fremder Check')")"
  m=""
  case "$m1" in
    KEIN_FEHLER) m="$m ein Konto des fremden Mandanten durfte anlegen (F3, K04-D08);";;
    *ANLAGE*|*MANDANT*|*TENANT*|*KONTO*) : ;;
    *) m="$m der fremde-Konto-Fall scheiterte an einer FREMDEN Bedingung: $m1;";;
  esac
  case "$m2" in
    KEIN_FEHLER) m="$m ein Check des fremden Mandanten trug die Anlage im eigenen (K04-D08);";;
    *ANLAGE*|*MANDANT*|*TENANT*|*CHECK*|*EIGNUNG*) : ;;
    *) m="$m der fremde-Check-Fall scheiterte an einer FREMDEN Bedingung: $m2;";;
  esac
  [ "${bestand:-0}" = "0" ] || m="$m es blieben Zeilen stehen;"
  [ -z "$m" ] && ok ZB-22 "Ein fremder Mandant gilt als nicht vorhanden — beide Richtungen abgewiesen. Meldungen im Wortlaut: [$m1] [$m2] (F3, K04-D08)" \
              || nok ZB-22 "Fremder Mandant:$m"
fi
pruefe_sql_marke

# ---------------------------------------------------------------------
# ZB-23 · K01-M27 · Die uebrigen Bedingungen desselben Riegels:
#         aktives Konto und legal_space = DE.
#
#         currency = EUR bleibt UNGEMESSEN und ist deshalb hier
#         ausgewiesen: das Datenmodell fuehrt die Waehrung an app mit
#         Vorgabe EUR und kennt keinen Mandanten mit einer anderen -- es
#         gaebe nichts, wogegen ein Fall scheitern koennte. Ein Fall,
#         der nicht scheitern kann, misst nichts.
# ---------------------------------------------------------------------
#         NACHGEZOGEN AM 16.08.2026 auf K01-M38 und K01-D19 (Begruendung
#         im Block ueber befehl_aufruf()). Der Nachweis "es blieben keine
#         Zeilen stehen" haengt jetzt am NAMEN statt an der Projektnummer.
if [ -n "$BEFEHL_LAGE" ]; then
  sperr ZB-23 "Nicht messbar: $BEFEHL_LAGE"
else
  m1="$(dbf "$(befehl_aufruf "$MANDANT_A" 'ZB23 Gesperrtes Konto' "$CHECK_GESPERRT" "$KONTO_GESPERRT")")"
  m2="(nicht gefahren)"
  if [ "${MANDANT_AUSLAND:-}" = "JA" ]; then
    m2="$(dbf "$(befehl_aufruf "$MANDANT_X" 'ZB23 Ausserhalb DE' "$CHECK_AUSLAND" "$KONTO_DB")")"
  fi
  bestand="$(dbz "SELECT count(*) FROM app WHERE name IN ('ZB23 Gesperrtes Konto','ZB23 Ausserhalb DE')")"
  m=""
  case "$m1" in
    KEIN_FEHLER) m="$m ein GESPERRTES Konto durfte anlegen (K01-M27);";;
    *ANLAGE*|*KONTO*|*AKTIV*|*STATUS*) : ;;
    *) m="$m der Fall mit dem gesperrten Konto scheiterte an einer FREMDEN Bedingung: $m1;";;
  esac
  if [ "${MANDANT_AUSLAND:-}" = "JA" ]; then
    case "$m2" in
      KEIN_FEHLER) m="$m ein Mandant ausserhalb DE durfte anlegen (K01-M27: legal_space = DE);";;
      *ANLAGE*|*LEGAL*|*DE*|*RAUM*) : ;;
      *) m="$m der Fall ausserhalb DE scheiterte an einer FREMDEN Bedingung: $m2;";;
    esac
  fi
  [ "${bestand:-0}" = "0" ] || m="$m es blieben Zeilen stehen;"
  if [ -z "$m" ] && [ "${MANDANT_AUSLAND:-}" != "JA" ]; then
    sperr ZB-23 "Nur teilweise messbar: das gesperrte Konto wurde abgewiesen [$m1], aber ein Mandant ausserhalb DE liess sich nicht anlegen ($MANDANT_AUSLAND) -- legal_space = DE bleibt ungemessen"
  else
    [ -z "$m" ] && ok ZB-23 "Der Riegel prueft mit: aktives Konto und legal_space = DE. Meldungen im Wortlaut: [$m1] [$m2] (K01-M27)" \
                || nok ZB-23 "Die uebrigen Bedingungen des Riegels:$m"
  fi
fi
pruefe_sql_marke

# ---------------------------------------------------------------------
# ZB-24 · K04-M21 + K10 · Der Nachweis der Kenntnisnahme bleibt NACH
#         der Anlage bestehen -- er geht ins Uebergabe-Paket.
#         "Ohne ihn ist die Auskunftspflicht nach Art. 25 Abs. 4 nicht
#         belegbar."
#
#         Gemessen wird der Fortbestand ueber den Schritt hinweg, der
#         ihn am ehesten verdraengen wuerde: die Anlage der Anwendung.
# ---------------------------------------------------------------------
if [ -z "${APP_NR_1:-}" ]; then
  sperr ZB-24 'Nicht messbar: die Anlage nach der Kenntnisnahme kam nicht zustande'
else
  nw="$(nachweise 'zb_anhang@zbpruef.example')"
  cid="$(check_von 'zb_anhang@zbpruef.example')"
  klasse="$(dbz "SELECT retention_class::text FROM fit_check WHERE id='$cid'")"
  m=""
  [ "${nw:-0}" -ge 1 ] || m="$m nach der Anlage besteht kein Nachweis der Kenntnisnahme mehr (K04-M21);"
  [ "$klasse" = "KI_NACHWEIS" ] || m="$m der Check steht in der Aufbewahrungsklasse '$klasse' statt KI_NACHWEIS -- als KI-Nachweis waere er damit nicht gefuehrt (K04-M21, K15);"
  [ -z "$m" ] && ok ZB-24 'Der Nachweis der Kenntnisnahme besteht nach der Anlage fort und ist als KI_NACHWEIS gefuehrt (K04-M21, K10)' \
              || nok ZB-24 "Nachweis nach der Anlage:$m"
fi
pruefe_sql_marke

# ---------------------------------------------------------------------
# ZB-25 · K01-M27 · currency = EUR
#         AUSDRUECKLICH GESPERRT, nicht stillschweigend weggelassen.
#         Begruendung siehe ZB-23: es gibt nichts, wogegen dieser Fall
#         scheitern koennte, solange das Datenmodell keinen Mandanten
#         mit einer anderen Waehrung kennt. Ein Fall, der nicht
#         scheitern kann, ist kein Fall (K23-M22).
# ---------------------------------------------------------------------
sperr ZB-25 'currency = EUR aus K01-M27 ist mit den vorhandenen Mitteln nicht messbar: app.currency traegt EUR als Vorgabe, und es besteht kein Mandant, an dem eine andere Waehrung entstuende. Ein Fall dazu koennte nicht scheitern und wuerde nichts messen.'

# =====================================================================
# ZB-26 · DER ABGLEICH · DAUERMESSUNG
#
# WORAUF ER SICH STUETZT: die AUFLAGE der gezeichneten Entscheidung vom
# 16.08.2026 zum Traeger der Zweckbestimmung (Weg C, O-K04-8 geschlossen),
# im Wortlaut:
#
#   "Zwei Orte fuer dieselbe Sache halten nur, wenn jemand misst, dass
#    sie uebereinstimmen. EIN DAUERHAFTER PRUEFFALL vergleicht den Stand
#    am Datensatz mit dem, was die Vorgaenge sagen. Ohne diese Auflage
#    wird aus C das Schlechteste beider Wege."
#
# Die Entscheidung fuehrt Zweckbestimmung und Kenntnisnahme kuenftig als
# ZUSTAND (Spalten an fit_check) UND als EREIGNIS (event nach K02
# Abschn. 3, wie K04-G12 es fuer die Kenntnisnahme vorzeichnet). Diese
# Datei legt beides nie an -- beides ist Pruefgegenstand.
#
# WAS ER MISST -- eine UNTERSCHEIDUNG, kein Vorkommen:
#   Regel 1  Traegt eine Pruefung einen gesetzten Stand, MUSS mindestens
#            ein Vorgang zu ihr bestehen.  (Zustand ohne Vorgang)
#   Regel 2  Besteht ein Vorgang zu einer Pruefung, MUSS an ihr ein Stand
#            gesetzt sein.                 (Vorgang ohne Zustand)
# Weichen die beiden Orte ab, ist das ein FEHLSCHLAG -- kein gesperrter
# Fall. Es ist messbar, also wird es gemessen.
#
# ER MISST DEN GANZEN BESTAND, nicht nur die Konten dieses Laufs. Genau
# das ist der Sinn einer Dauermessung: sie findet auch, was auf einem
# unbekannten Weg entstanden ist.
#
# ---------------------------------------------------------------------
# DASS ER SCHEITERN KANN, IST NICHT BEHAUPTET, SONDERN BELEGT
# ---------------------------------------------------------------------
# Ein Abgleich, der auf einem stimmigen Bestand laeuft, ist von einem
# Abgleich, der gar nichts prueft, nicht zu unterscheiden. Deshalb faehrt
# der Fall ZWEI SELBSTPROBEN, jede in einer Transaktion, die IMMER
# zurueckgerollt wird:
#
#   Probe A  Ein Stand wird an einer Pruefung gesetzt, zu der es keinen
#            Vorgang gibt. DIESELBE Abfrage muss diese Pruefung dann als
#            "Zustand ohne Vorgang" melden.
#   Probe B  Ein Vorgang wird zu einer Pruefung geschrieben, an der kein
#            Stand gesetzt ist. DIESELBE Abfrage muss sie dann als
#            "Vorgang ohne Zustand" melden.
#
# Meldet eine Probe die vorgetaeuschte Abweichung NICHT, ist die Messung
# blind -- dann ist der Fall GESPERRT, nicht bestanden (K23-M22). Beide
# Proben laufen gegen die IDENTISCHE Abfrage (abgleich_sql), nicht gegen
# eine nachgebaute; sonst belegten sie die Abfrage nicht, die misst.
#
# ---------------------------------------------------------------------
# WAS ER NICHT MESSEN KANN -- ausgewiesen, nicht weggelassen
# ---------------------------------------------------------------------
#   * Er misst DASS beide Orte etwas sagen, nicht dass sie DASSELBE
#     sagen. Welcher Vorgang zu welchem Merkmal gehoert, zeichnet die
#     Entscheidung nicht; eine Zuordnung waere geraten.
#   * Traegt ein Merkmal einen NICHT NULLBAREN Wahrheitswert, ist "nicht
#     beantwortet" von "mit nein beantwortet" nicht unterscheidbar. Dann
#     laeuft Regel 2 NICHT, und der Fall sagt es -- statt eine Abweichung
#     zu melden, die keine ist.
# =====================================================================

# Die Traeger des ZUSTANDS werden ERFRAGT, nicht angenommen: welche
# Spalten der Bau gewaehlt hat, zeichnet die Entscheidung nicht.
ZUST_ZEILEN="$(db "SELECT column_name||':'||data_type||':'||is_nullable
                     FROM information_schema.columns
                    WHERE table_schema='public' AND table_name='fit_check'
                      AND column_name ~* '(zweck|kenntnis|ack|anhang|annex|artikel|article|verbot|prohib|purpose)'
                    ORDER BY ordinal_position")"
pruefe_sql_marke

ZUST_PRAED=""; ZUST_LISTE=""; ZUST_STUMPF=""
PROBE_SETZ=(); PROBE_SPAT=()      # Kandidaten der Selbstprobe: Zeitstempel zuerst
while IFS=: read -r sp typ nullbar; do
  [ -n "$sp" ] || continue
  ZUST_LISTE="${ZUST_LISTE:+$ZUST_LISTE, }$sp ($typ)"
  if [ "$typ" = "boolean" ] && [ "$nullbar" = "NO" ]; then
    ZUST_PRAED="${ZUST_PRAED:+$ZUST_PRAED OR }c.$sp IS TRUE"
    ZUST_STUMPF="${ZUST_STUMPF:+$ZUST_STUMPF, }$sp"
  else
    ZUST_PRAED="${ZUST_PRAED:+$ZUST_PRAED OR }c.$sp IS NOT NULL"
  fi
  # Fuer die Selbstprobe: JEDES Merkmal, das sich setzen laesst -- die
  # Probe geht sie der Reihe nach durch. Der Bau hat zu den Spalten eine
  # BEDINGUNG gesetzt; welche, weiss dieser Lauf nicht. Scheitert die
  # Probe an ihr, ist das eine FREMDE Bedingung, und der naechste
  # Kandidat kommt an die Reihe.
  case "$typ" in
    "timestamp with time zone"|"timestamp without time zone")
             PROBE_SETZ+=("$sp = now()");;
    date)    PROBE_SPAT+=("$sp = current_date");;
    boolean) PROBE_SPAT+=("$sp = true");;
    text|"character varying")
             PROBE_SPAT+=("$sp = 'PROBE'");;
    uuid)    PROBE_SPAT+=("$sp = gen_random_uuid()");;
  esac
done <<EOF
$ZUST_ZEILEN
EOF
PROBE_SETZ+=(${PROBE_SPAT[@]+"${PROBE_SPAT[@]}"})

# Der Vorgang wird an denselben Merkmalen erkannt wie in nachweise() --
# eine zweite, engere Liste waere ein zweiter Massstab.
EV_PRAED="EXISTS (SELECT 1 FROM event e
                   WHERE (e.action ILIKE '%KENNTNIS%' OR e.action ILIKE '%ACK%'
                          OR e.action ILIKE '%ZWECK%'    OR e.action ILIKE '%ANHANG%'
                          OR e.action ILIKE '%ARTIKEL%'  OR e.action ILIKE '%VERBOT%'
                          OR e.action ILIKE '%PURPOSE%')
                     AND (coalesce(e.object_ref,'') LIKE '%'||c.id::text||'%'
                          OR coalesce(e.value,'')   LIKE '%'||c.id::text||'%'))"

# EINE Abfrage, die der Fall UND beide Selbstproben benutzen.
abgleich_sql() {     # $1 = 1, wenn Regel 2 mitlaeuft
  printf "SELECT coalesce(string_agg(t.z,'; ' ORDER BY t.z),'') FROM ("
  printf "SELECT c.id::text||' Zustand-ohne-Vorgang' AS z FROM fit_check c"
  printf " WHERE (%s) AND NOT %s" "$ZUST_PRAED" "$EV_PRAED"
  if [ "${1:-0}" = "1" ]; then
    printf " UNION ALL SELECT c.id::text||' Vorgang-ohne-Zustand' FROM fit_check c"
    printf " WHERE %s AND NOT (%s)" "$EV_PRAED" "$ZUST_PRAED"
  fi
  printf ") t"
}

# Die Selbstprobe laeuft in einer Transaktion, die IMMER zurueckgerollt
# wird -- wie dbf(), aber sie gibt die Ausgabe der Abfrage zurueck.
probe() {            # $1 = SQL-Block vor der Abfrage  $2 = 1, wenn Regel 2 mitlaeuft
  local aus
  if ! aus="$(psql -X -tAq -v ON_ERROR_STOP=1 \
                   -c "BEGIN; $1; $(abgleich_sql "${2:-0}"); ROLLBACK;" \
                   2>"$ARBEIT/probe.fehler")"; then
    printf 'PROBE GESCHEITERT: %s' "$(tr '\n' ' ' <"$ARBEIT/probe.fehler")"
    return 0
  fi
  printf '%s' "$aus" | head -1
}

REGEL2=1
[ -z "$ZUST_STUMPF" ] || REGEL2=0

if [ -z "$ZUST_PRAED" ]; then
  sperr ZB-26 'Nicht messbar: fit_check traegt kein Merkmal, an dem der ZUSTAND der Zweckbestimmung oder der Kenntnisnahme abzulesen waere. Die gezeichnete Entscheidung vom 16.08.2026 (Weg C) fuehrt beides als Zustand UND als Ereignis; ohne den einen Ort gibt es nichts abzugleichen. Ein Fall, der nichts gemessen hat, ist nicht bestanden (K23-M22).'
elif [ "${#PROBE_SETZ[@]}" -eq 0 ]; then
  sperr ZB-26 "Nicht messbar: keines der Merkmale ($ZUST_LISTE) laesst sich fuer die Selbstprobe setzen. Ohne Selbstprobe ist nicht belegt, dass dieser Fall ueberhaupt scheitern kann -- und ein Fall, der nicht scheitern kann, misst nichts (K23-M22)."
else
  # (0) Die Pruefung, an der die Selbstprobe faehrt, muss VORHER an
  #     BEIDEN Orten stumm sein. Sonst belegte die Probe nichts.
  vorbelastet="$(dbz "SELECT (CASE WHEN ($ZUST_PRAED) THEN 'Zustand ' ELSE '' END)
                          || (CASE WHEN $EV_PRAED  THEN 'Vorgang' ELSE '' END)
                        FROM fit_check c WHERE c.id='$CHECK_OFFEN'")"
  pruefe_sql_marke
  if [ -n "${vorbelastet// /}" ]; then
    sperr ZB-26 "Nicht messbar: der Check $CHECK_OFFEN, an dem die Selbstprobe faehrt, traegt schon '$vorbelastet'. Eine vorgetaeuschte Abweichung waere von der vorhandenen nicht zu unterscheiden."
  else
    # (1) Der Abgleich selbst -- ueber den GANZEN Bestand.
    lebend="$(dbz "$(abgleich_sql "$REGEL2")")"
    pruefe_sql_marke

    # (2) Selbstprobe A: Zustand ohne Vorgang. Der Reihe nach durch alle
    #     setzbaren Merkmale, bis eines die vorgetaeuschte Abweichung
    #     sichtbar macht. Ein Kandidat, der an der Bedingung des Baus
    #     scheitert, ist eine FREMDE Bedingung und belegt nichts.
    probe_a=""; PROBE_MIT=""
    for setz in "${PROBE_SETZ[@]}"; do
      probe_a="$(probe "UPDATE fit_check SET $setz WHERE id='$CHECK_OFFEN'" "$REGEL2")"
      PROBE_MIT="$setz"
      case "$probe_a" in *"$CHECK_OFFEN Zustand-ohne-Vorgang"*) break;; esac
    done

    # (3) Selbstprobe B: Vorgang ohne Zustand. Nur fahrbar, wenn Regel 2
    #     laeuft -- sonst gaebe es die Richtung nicht, die sie belegt.
    probe_b="(nicht gefahren)"
    if [ "$REGEL2" = "1" ]; then
      probe_b="$(probe "INSERT INTO event(action,object_ref,source)
                        VALUES ('ZWECKBESTIMMUNG_PROBE','FIT_CHECK:$CHECK_OFFEN','PORTAL_ACTION')" 1)"
    fi

    blind=""
    case "$probe_a" in
      *"$CHECK_OFFEN Zustand-ohne-Vorgang"*) : ;;
      *) blind="$blind Selbstprobe A (zuletzt versucht mit '$PROBE_MIT'): ein gesetzter Stand OHNE Vorgang wurde nicht gefunden (Antwort der Abfrage: '${probe_a:-leer}'). Die Messung ist in dieser Richtung blind;";;
    esac
    if [ "$REGEL2" = "1" ]; then
      case "$probe_b" in
        *"$CHECK_OFFEN Vorgang-ohne-Zustand"*) : ;;
        *) blind="$blind Selbstprobe B: ein Vorgang OHNE Stand wurde nicht gefunden (Antwort der Abfrage: '${probe_b:-leer}'). Die Messung ist in dieser Richtung blind;";;
      esac
    fi

    hinweis=""
    [ "$REGEL2" = "1" ] || hinweis=" REGEL 2 LAEUFT NICHT: $ZUST_STUMPF ist ein nicht nullbarer Wahrheitswert -- 'nicht beantwortet' und 'mit nein beantwortet' sind daran nicht unterscheidbar. 'Vorgang ohne Zustand' bleibt damit UNGEMESSEN."

    if [ -n "$blind" ]; then
      sperr ZB-26 "Der Abgleich hat nichts gemessen:$blind Ein Fall, der nicht scheitern kann, ist kein Fall (K23-M22)."
    elif [ -n "$lebend" ]; then
      nok ZB-26 "Zustand und Vorgaenge laufen auseinander (Auflage der Zeichnung vom 16.08.2026): $lebend — geprueft an $ZUST_LISTE.$hinweis"
    elif [ "$REGEL2" != "1" ]; then
      sperr ZB-26 "Nur teilweise messbar: 'Zustand ohne Vorgang' ist ueber den ganzen Bestand geprueft und stimmt (Selbstprobe A belegt, dass eine Abweichung gefunden worden waere).$hinweis"
    else
      ok ZB-26 "DAUERMESSUNG: ueber den ganzen Bestand sagen Zustand und Vorgaenge dasselbe — kein Stand ohne Vorgang, kein Vorgang ohne Stand. Geprueft an $ZUST_LISTE; beide Selbstproben haben die vorgetaeuschte Abweichung gefunden (A mit '$PROBE_MIT'), der Fall kann also scheitern (Auflage der Zeichnung vom 16.08.2026, K04-M21, K04-G12)"
    fi
  fi
fi
pruefe_sql_marke

# =====================================================================
printf '\n'
[ "$gesperrt" -gt 0 ] && printf 'davon GESPERRT (nicht messbar, zaehlt nach K23-M22 nicht als bestanden): %s\n' "$gesperrt"
printf 'SUMME: %s von %s bestanden, %s gescheitert\n' "$bestanden" "$gesamt" "$gescheitert"
[ "$gescheitert" -eq 0 ]
