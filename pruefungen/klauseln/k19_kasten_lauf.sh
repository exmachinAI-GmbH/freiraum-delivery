#!/usr/bin/env bash
# =====================================================================
# FREIRAUM · K19-M01 · "Traegt die ausgelieferte Seite den Kasten
#                       ihres Bildschirms?"
# Klauselpruefung gegen einen LAUFENDEN Server
#
# Geschrieben gegen schema/K19_build_referenz.md (Konzept v1.3,
# Abschn. 5 Zeichenkonvention und Abschn. 6 Kastenkatalog) und gegen
# schema/K19_screens.yaml -- NICHT gegen den Umsetzungscode und NICHT
# gegen die Vorlagen. Der Prueffall kennt den Server nur durch seine
# Tueren; die Vorlagen hat er nie gesehen.
#
# Aufruf:
#   FREIRAUM_PRUEF_URL=http://localhost:8099 \
#   pruefungen/klauseln/k19_kasten_lauf.sh
#
# Umgebung:
#   FREIRAUM_PRUEF_URL    Vorgabe http://localhost:8099
#   FREIRAUM_K19_REF      Vorgabe schema/K19_build_referenz.md
#   FREIRAUM_CODE_PFEFFER wie am Server gesetzt -- der Lauf stellt sich
#                         seinen Anmeldecode selbst aus (K03-M15). Fehlt
#                         er, bleibt nur EN-03 gesperrt; EN-01 misst
#                         weiter.
#   PGHOST/PGPORT/PGUSER/PGPASSWORD/PGDATABASE
#                         Vorgabe localhost/55433/postgres/pilot/freiraum_pruef
#
# ---------------------------------------------------------------------
# WAS HIER GEMESSEN WIRD -- UND WAS SCHON WOANDERS GEMESSEN WIRD
# ---------------------------------------------------------------------
# K19-M01: "Jedes Konzept mit Bezug zur Oberflaeche MUSS Kennung und
# Version aus K19_screens.yaml referenzieren. Eine benoetigte Einbettung
# wird daraus erzeugt; manuell kopierte Kaesten sind unzulaessig."
# (nachweise/klauselregister/register.json, Herkunft
#  260801_FREIRAUM_K19_Build-Referenz_v1.3.md:41)
# Abschn. 4.1 derselben Referenz sagt, was Uebernahme heisst:
# "Kasten unveraendert + eigene Fachregel".
#
# In Tor 1a besteht bereits ein Werkzeug, das prueft, ob eine Vorlage
# ihren Kasten ZITIERT. Ein Zitat ist ein Beleg der Herkunft -- es sagt
# nichts darueber, ob die Seite dem Kasten auch FOLGT. Eine Vorlage kann
# den Kasten wortgetreu als Kommentar tragen und darunter etwas ganz
# anderes ausliefern.
#
# DIESER LAUF MISST DESHALB DAS ANDERE ENDE: die ausgelieferte Seite.
# Nicht die Vorlage -- die darf der blinde Pruef-Agent nicht lesen --,
# sondern das, was durch die Tuer kommt.
#
#   Fall A  VOLLSTAENDIGKEIT · Jedes Element, das der Kasten fuehrt,
#           kommt in der ausgelieferten Seite vor.
#   Fall B  REIHENFOLGE · Die Elemente stehen in der Reihenfolge, die
#           der Kasten zeigt.
#
# ---------------------------------------------------------------------
# WIE AUS EINEM KASTEN EINE MESSBARE LISTE WIRD
# ---------------------------------------------------------------------
# Nicht geraten, sondern nach der ZEICHENKONVENTION aus K19 Abschn. 5.
# Sie steht dort als Tabelle und wird hier eins zu eins angewandt:
#
#   "[Wort mit Leerraum ]"  Eingabefeld, der Leerraum zeigt die Breite
#   "[Wort]"                Schaltflaeche
#   "[x]"                   gesetztes Kontrollkaestchen
#   "[Wert v]"              Auswahlliste
#   Zeile ohne Klammern     Hinweis, Marke oder Zustandstext
#   Kopfzeile rechts in Klammern   Statusleiste
#
# Daraus die Regeln dieses Laufs, jede mit ihrem Grund:
#
#   * Die KOPFZEILE (╭─ ... ─╮) liefert kein Element. Sie traegt Kennung,
#     Name und Statusleiste (K19-M02) -- Angaben UEBER den Bildschirm.
#   * Die ZUGANGSMARKE ("Zugang: ...") liefert kein Element. Sie ist die
#     Marke nach K19-M03, eine Eigenschaft des Bildschirms, kein Text,
#     den die Seite drucken muesste. Gemessen wird der Zugang von den
#     Faellen der Wegetabelle (z. B. VP-01), nicht hier.
#   * Eine BESCHRIFTUNG links neben einem Feld ist ein Element: sie steht
#     im Kasten als sichtbarer Text ("E-Mail-Adresse").
#   * Der Inhalt eines EINGABEFELDS ist KEIN Element. "[vorbelegt aus der
#     Einladung        ]" beschreibt das Feld, es ist keine Aufschrift.
#     Wer ihn forderte, forderte etwas, das der Kasten nicht zusagt.
#   * Eine SCHALTFLAECHE ist ein Element mit ihrer Aufschrift
#     ("Anmelden").
#   * Eine Zeile OHNE Klammern ist ein Hinweis. Aufeinanderfolgende
#     solche Zeilen gehoeren zusammen, WENN die vorige mitten im Satz
#     endet: dann ist der Umbruch eine Eigenschaft der Kastenbreite,
#     nicht des Textes, und beide Zeilen werden mit einem Leerzeichen
#     verbunden. Endet die vorige Zeile auf . ? oder !, ist der Satz zu
#     Ende und der naechste Hinweis ein eigener.
#     NACHGEBESSERT 19.08.2026: zuvor wurden ALLE aufeinanderfolgenden
#     klammerlosen Zeilen zu einem Text verbunden. Bei EN-01 traf das zu
#     ("... neuer Link ueber" / "Ihre Ansprechperson."), bei EN-03 nicht:
#     dort steht eine Frage, die mit "?" endet, und darunter eine eigene
#     Erlaeuterung. Beide zu einer Zeichenkette zu verbinden verlangte
#     von der Seite, dass zwischen ihnen NICHTS steht -- eine Bedingung,
#     die kein Kasten zusagt. Der Fall waere an der Kastenbreite
#     gescheitert statt am Bau (F07).
#
# NICHT GEMESSEN wird "die Seite zeigt NUR, was der Kasten fuehrt".
# Das waere der schaerfere Fall, und er ist hier bewusst nicht gebaut:
# der Kasten "Kopfleiste · auf jedem Bildschirm gleich" fuehrt
# "[DE / EN]" als EINE Schaltflaeche, waehrend zwei Schaltflaechen "DE"
# und "EN" dieselbe Sache waeren. Ein Fall, der das als ueberzaehliges
# Element meldet, scheiterte an der Zeichenkonvention statt am Bau --
# eine FREMDE Bedingung (F07). Offener Punkt, ausgewiesen statt
# stillschweigend weggelassen.
#
# ---------------------------------------------------------------------
# UMSCHRIFT -- damit der Fall nicht an der Schreibweise scheitert
# ---------------------------------------------------------------------
# Die Kaesten sind in ASCII-Umschrift gesetzt ("gueltig", "ueber"), die
# ausgelieferte Seite darf Umlaute tragen ("gueltig" oder "gültig").
# Beide Seiten werden deshalb vor dem Vergleich gleich behandelt:
# HTML-Entitaeten aufloesen, Tags entfernen, Umlaute in die Umschrift
# ueberfuehren, Grossschreibung einebnen, Leerraum zusammenziehen.
# Sonst maesse der Fall die Zeichenkodierung statt den Kasten (F07) --
# derselbe Grund, aus dem vorpruefung_lauf.sh gegen den aufgeloesten
# Rumpf vergleicht.
#
# ---------------------------------------------------------------------
# FAIL-CLOSED (K23-M22)
# ---------------------------------------------------------------------
#   * Fuehrt die Referenz fuer einen Bildschirm KEINEN Kasten, ist er
#     GESPERRT -- nicht durchgefallen. Es gibt dann nichts zu folgen.
#     Das trifft EN-04a: die Bildschirmkennung besteht in
#     schema/K19_screens.yaml, schema/K19_build_referenz.md fuehrt fuer
#     sie aber keinen Kasten (nachgezaehlt am 18.08.2026: 32 Kaesten,
#     keiner davon EN-04a).
#   * Antwortet der Server nicht mit 200, ist der Bildschirm GESPERRT.
#     Ein Fall, der eine Fehlerseite gegen einen Kasten haelt, misst den
#     Fehler, nicht den Kasten.
#   * Fall B laeuft nur, wenn Fall A vollstaendig ist. Fehlt ein Element,
#     ist eine Reihenfolge nicht entscheidbar; B meldet dann GESPERRT und
#     nicht ROT -- sonst scheiterte B an der Bedingung von A (F07).
#
# ---------------------------------------------------------------------
# WELCHE BILDSCHIRME DIESER LAUF FUEHRT
# ---------------------------------------------------------------------
# EN-01 · /anmeldung · Zugangsmarke "offen", ohne Sitzung erreichbar.
# EN-03 · /vorpruefung · Zugangsmarke "nach Anmeldung". Dafuer gibt es
#   seit dem 19.08.2026 k19_kasten_daten.sql: EIN Konto, mit dem der Lauf
#   durch EN-01 hindurchkommt. Ohne Sitzung bleibt EN-03 GESPERRT -- nie
#   bestanden.
# EN-04a · GESPERRT, kein Kasten in der Referenz (siehe oben).
#
# NICHT gefuehrt wird EN-02, obwohl sein Kasten vollstaendig ist. Er
# mischt Aufschriften mit PLATZHALTERN fuer Daten: "Name der Anwendung",
# "zweite Anwendung", "[Zustandsname]", "Stufe 03". Das sind keine
# Beschriftungen, sondern Beispielwerte -- "[Zustandsname]" kommt nach
# K19-M05 aus lifecycle_state_label. Sie als Text zu fordern hiesse,
# einen Selektor zu erfinden. Ausgewiesen statt stillschweigend
# weggelassen; ein Fall dafuer braucht zuerst eine Festlegung, welche
# Zeilen eines Kastens Platzhalter sind.
#
# Die uebrigen ENDUSER-Bildschirme (EN-05 bis EN-14) verlangen einen
# gefahrenen Weg -- Eignungs-Check, Zweckbestimmung, Stufen. Diesen Weg
# messen vorpruefung_lauf.sh und zweckbestimmung_lauf.sh; ihn hier ein
# zweites Mal zu fahren, hiesse ihre Vorbedingungen zu erben und an
# fremden Bedingungen zu scheitern (F07).
#
# ---------------------------------------------------------------------
# GEGENPROBE (F07)
# ---------------------------------------------------------------------
# Gegen synthetische Seiten, ueber HTTP ausgeliefert -- dieselbe Bauart
# des Nachweises, die vorpruefung_lauf.sh am 15.08.2026 fuer VP-14/VP-12
# benutzt hat. Gemessen am 18. und 19.08.2026:
#
#   Seite folgt dem Kasten                 -> A und B BESTANDEN
#   EN-01 ohne Hinweiszeile                -> A GESCHEITERT
#                                             ("HINWEIS: Einmal-Link 24
#                                              Stunden gueltig, ..."),
#                                             B GESPERRT
#   EN-01 [Anmelden] vor die Felder        -> A BESTANDEN, B GESCHEITERT
#                                             ("BRUCH: SCHALTFLAECHE:
#                                              Anmelden")
#   EN-01 "Anmelden" nur in Stilblock und  -> A GESCHEITERT
#         HTML-Kommentar                      ("SCHALTFLAECHE: Anmelden")
#   EN-03 ohne die Erlaeuterung            -> A GESCHEITERT
#                                             ("HINWEIS: Ein Direkt-
#                                              Prototyp ist ein
#                                              Arbeitsdokument: ..."),
#                                             B GESPERRT
#   EN-03 Schaltflaechen vertauscht        -> A BESTANDEN, B GESCHEITERT
#                                             ("BRUCH: SCHALTFLAECHE:
#                                              Ueberspringen")
#   Seite nicht erreichbar (404)           -> A und B GESPERRT
#   ohne FREIRAUM_CODE_PFEFFER             -> EN-03 GESPERRT mit Grund,
#                                             EN-01 misst weiter
#   ohne k19_kasten_daten.sql (Sicht fehlt)-> EN-03 GESPERRT mit Grund
#   Konto GESPERRT statt AKTIV             -> EN-03 GESPERRT, und zwar
#                                             als FREMDE Bedingung
#                                             benannt (F07)
#   Rolle 'Endnutzer' fehlt                -> k19_kasten_daten.sql bricht
#                                             ab: "ABBRUCH -- AUFBAU
#                                             UNBRAUCHBAR (F07):
#                                             k19_seite@ gehoert keinem
#                                             freigeschalteten Portal an"
#
# Die beiden Vertausch-Durchgaenge sind die entscheidenden: A bleibt
# dabei GRUEN und nur B faellt. B scheitert also an SEINER eigenen
# Bedingung, nicht an der von A. Und jeder Durchgang, der einen
# Bildschirm bricht, laesst den anderen gruen -- die beiden Bildschirme
# messen einander nicht.
#
# ZUM STAND IN DIESEM ARBEITSBAUM. Der blinde Arbeitsbaum fuehrt kein
# app/; ein Server laesst sich hier nicht starten. Die Durchgaenge oben
# liefen gegen ein DOPPEL, das nur Tueren aufmacht -- sie belegen die
# TAUGLICHKEIT des Falls, nicht den Stand des Baus. Gegen den wirklichen
# Bau ist sein Ergebnis GESPERRT, bis jemand ihn dort faehrt. Beides
# nicht zu verwechseln, ist der ganze Sinn von K23-M22.
# =====================================================================

set -u

BASIS="${FREIRAUM_PRUEF_URL:-http://localhost:8099}"

: "${PGHOST:=localhost}"
: "${PGPORT:=55433}"
: "${PGUSER:=postgres}"
: "${PGPASSWORD:=pilot}"
: "${PGDATABASE:=freiraum_pruef}"
export PGHOST PGPORT PGUSER PGPASSWORD PGDATABASE
HIER="$(cd "$(dirname "$0")/../.." && pwd)"
REFERENZ="${FREIRAUM_K19_REF:-$HIER/schema/K19_build_referenz.md}"

ARBEIT="$(mktemp -d "${TMPDIR:-/tmp}/freiraum_k19kasten.XXXXXX")"
trap 'rm -rf "$ARBEIT"' EXIT

gesamt=0; bestanden=0; gescheitert=0; gesperrt=0

ok()  { gesamt=$((gesamt+1)); bestanden=$((bestanden+1))
        printf '%-14s BESTANDEN    %s\n' "$1" "$2"; }
nok() { gesamt=$((gesamt+1)); gescheitert=$((gescheitert+1))
        printf '%-14s GESCHEITERT  %s\n' "$1" "$(printf '%s' "$2" | tr '\n' ' ')"; }
# K23-M22: was nicht gemessen werden konnte, ist GESPERRT -- nie
# bestanden. In der Summe zaehlt es zu den nicht bestandenen Faellen.
sperr() { gesamt=$((gesamt+1)); gescheitert=$((gescheitert+1)); gesperrt=$((gesperrt+1))
        printf '%-14s GESPERRT     %s\n' "$1" "$(printf '%s' "$2" | tr '\n' ' ')"; }

abbruch() { printf 'ABBRUCH: %s\n' "$1"; printf 'SUMME: 0 von 0 bestanden, 0 gescheitert\n'; exit 2; }

command -v curl    >/dev/null 2>&1 || abbruch 'curl fehlt.'
command -v python3 >/dev/null 2>&1 || abbruch 'python3 fehlt (Kastenauswertung und Umschrift).'
[ -f "$REFERENZ" ] || abbruch "Die Build-Referenz fehlt: $REFERENZ"

# ---------------------------------------------------------------------
# Werkzeug 1 · Den Kasten eines Bildschirms in eine Liste von Elementen
#              zerlegen. Rueckgabe je Zeile: ART<TAB>TEXT.
#              Beendet sich mit 3, wenn die Referenz keinen Kasten fuehrt.
# ---------------------------------------------------------------------
kasten_elemente() {  # $1 Kennung  ->  Zeilen "ART\tTEXT"
  python3 - "$REFERENZ" "$1" <<'PY'
import re, sys

pfad, kennung = sys.argv[1], sys.argv[2]
zeilen = open(pfad, encoding="utf-8").read().split("\n")

# Der Kasten beginnt mit "╭─ <Kennung> ·" -- die Kennung steht nach K19-M02
# in der Kopfzeile. Ein Kasten, den es nicht gibt, ist kein Fehler dieses
# Werkzeugs, sondern ein Sperrgrund fuer den Fall (Rueckgabe 3).
anfang = None
for i, z in enumerate(zeilen):
    if z.startswith("╭─ ") and re.match(r"╭─\s+" + re.escape(kennung) + r"\s*(·|─)", z):
        anfang = i
        break
if anfang is None:
    sys.exit(3)

rumpf = []
for z in zeilen[anfang + 1:]:
    if z.startswith("╰"):
        break
    rumpf.append(z)

def entrahmen(z):
    z = z.rstrip()
    if z.startswith("│"):
        z = z[1:]
    if z.endswith("│"):
        z = z[:-1]
    return z

elemente = []       # (art, text)
hinweis  = []       # laufender, ueber mehrere Zeilen umgebrochener Hinweis

def hinweis_abschliessen():
    if hinweis:
        elemente.append(("HINWEIS", " ".join(hinweis).strip()))
        hinweis.clear()

for roh in rumpf:
    z = entrahmen(roh)
    if not z.strip():
        hinweis_abschliessen()
        continue
    # Zugangsmarke nach K19-M03: Eigenschaft des Bildschirms, kein Element.
    if re.match(r"\s*Zugang:", z):
        hinweis_abschliessen()
        continue
    klammern = list(re.finditer(r"\[([^\[\]]*)\]", z))
    if not klammern:
        # Zeile ohne Klammern -> Hinweis. Der Umbruch gehoert der
        # Kastenbreite, nicht dem Text -- ABER nur mitten im Satz. Endet
        # die laufende Zeile auf . ? oder !, ist der Hinweis zu Ende und
        # der naechste ein eigener (Nachbesserung 19.08.2026).
        if hinweis and hinweis[-1].rstrip().endswith((".", "?", "!")):
            hinweis_abschliessen()
        # Der Spaltentrenner nach Abschn. 5 trennt auch hier: links
        # Gespraech oder Navigation, rechts Arbeitsflaeche. Er wird als
        # "│" UND als "|" gesetzt -- beide gelten.
        for teil in re.split(r"[\u2502|]", z):
            teil = teil.strip()
            if teil:
                hinweis.append(teil)
        continue
    hinweis_abschliessen()
    # Text VOR der ersten Klammer ist die Beschriftung des Feldes.
    vor = z[:klammern[0].start()]
    # Spaltentrenner "│" nach Abschn. 5 abwerfen; der Text der rechten
    # Spalte bleibt als eigene Beschriftung erhalten.
    for teil in re.split(r"[\u2502|]", vor):
        teil = teil.strip()
        if teil:
            elemente.append(("BESCHRIFTUNG", teil))
    for m in klammern:
        inhalt = m.group(1)
        kern = inhalt.strip()
        if kern == "x":
            elemente.append(("KONTROLLKAESTCHEN", ""))
        elif re.search(r"\sv$", inhalt.rstrip() ) and inhalt.rstrip().endswith(" v"):
            elemente.append(("AUSWAHLLISTE", inhalt.rstrip()[:-2].strip()))
        elif inhalt != inhalt.rstrip():
            # Leerraum am Ende -> Eingabefeld. Sein Inhalt beschreibt das
            # Feld und ist keine Aufschrift: NICHT als Element gefuehrt.
            elemente.append(("EINGABEFELD", kern))
        else:
            elemente.append(("SCHALTFLAECHE", kern))
    # Text zwischen bzw. hinter Klammern -> weitere Beschriftungen.
    rest = z[klammern[-1].end():]
    for teil in re.split(r"[\u2502|]", rest):
        teil = teil.strip()
        if teil:
            elemente.append(("BESCHRIFTUNG", teil))

hinweis_abschliessen()

for art, text in elemente:
    print(art + "\t" + text)
PY
}

# ---------------------------------------------------------------------
# Werkzeug 2 · Die ausgelieferte Seite und die Kastenelemente auf
#              denselben Nenner bringen und Vorkommen sowie Reihenfolge
#              messen.
#
#              Aufruf: kasten_messen <rumpfdatei> <elementdatei> <auftrag>
#              auftrag = fehlend  -> Zeilen der Elemente, die fehlen
#              auftrag = folge    -> "OK" oder der erste Bruch der Folge
# ---------------------------------------------------------------------
kasten_messen() {    # $1 rumpf  $2 elementdatei  $3 auftrag
  python3 - "$1" "$2" "$3" <<'PY'
import html, re, sys

rumpf, elemente_datei, auftrag = sys.argv[1], sys.argv[2], sys.argv[3]

UMSCHRIFT = {"ä": "ae", "ö": "oe", "ü": "ue", "Ä": "ae", "Ö": "oe",
             "Ü": "ue", "ß": "ss", "–": "-", "—": "-",
             "‘": "'", "’": "'", "“": '"', "”": '"',
             " ": " "}

def gleichmachen(t):
    t = html.unescape(t)
    for a, b in UMSCHRIFT.items():
        t = t.replace(a, b)
    t = t.lower()
    t = re.sub(r"\s+", " ", t)
    return t

roh = open(rumpf, encoding="utf-8", errors="replace").read()
# Skripte und Formatangaben sind kein sichtbarer Text; ihr Inhalt darf
# einen Kastentext nicht "erfuellen".
roh = re.sub(r"(?is)<(script|style)\b.*?</\1>", " ", roh)
roh = re.sub(r"(?s)<!--.*?-->", " ", roh)
# Der Wert eines Bedienelements ist sichtbarer Text (value="Anmelden"),
# der uebrige Tag-Inhalt nicht.
roh = re.sub(r'(?is)<input\b[^>]*\bvalue\s*=\s*"([^"]*)"[^>]*>', r" \1 ", roh)
roh = re.sub(r"(?is)<input\b[^>]*\bvalue\s*=\s*'([^']*)'[^>]*>", r" \1 ", roh)
roh = re.sub(r"(?s)<[^>]*>", " ", roh)
seite = gleichmachen(roh)

gesucht = []
for zeile in open(elemente_datei, encoding="utf-8").read().split("\n"):
    if not zeile.strip():
        continue
    art, _, text = zeile.partition("\t")
    # Gemessen werden nur Elemente, die als TEXT auf der Seite stehen
    # muessen. Ein Eingabefeld traegt im Kasten nur seine Beschreibung
    # (siehe Dateikopf), ein Kontrollkaestchen keinen Text.
    if art in ("BESCHRIFTUNG", "SCHALTFLAECHE", "HINWEIS", "AUSWAHLLISTE"):
        if text.strip():
            gesucht.append((art, text))

if auftrag == "fehlend":
    for art, text in gesucht:
        if gleichmachen(text) not in seite:
            print(art + ": " + text)
elif auftrag == "folge":
    # Teilfolgenprobe: jedes Element wird ab der Stelle gesucht, an der
    # das vorige gefunden wurde. Das ist genau die Frage "in dieser
    # Reihenfolge" -- und es bestraft nicht, dass ein Text mehrfach
    # vorkommt.
    marke = 0
    for art, text in gesucht:
        s = gleichmachen(text)
        stelle = seite.find(s, marke)
        if stelle < 0:
            print("BRUCH: " + art + ": " + text)
            break
        marke = stelle + len(s)
    else:
        print("OK")
elif auftrag == "zaehlen":
    print(len(gesucht))
PY
}

hole() {             # $1 pfad  $2 name  [$3 kekswert] -> Statuscode
  local p="$ARBEIT/$2" st ex=()
  [ -n "${3:-}" ] && ex=(-H "Cookie: fr_sitzung=$3")
  st=$(curl -sS -o "$p.rumpf" -D "$p.kopf" -w '%{http_code}' --max-time 25 \
        ${ex[@]+"${ex[@]}"} "$BASIS$1" 2>"$p.fehler") || st="000"
  [ -f "$p.kopf" ] && tr -d '\r' < "$p.kopf" > "$p.kopf.rein" && mv "$p.kopf.rein" "$p.kopf"
  printf '%s' "$st"
}

# ---------------------------------------------------------------------
# Werkzeug: Die Sitzung
#
# Derselbe Weg durch die Tuer wie in vorpruefung_lauf.sh: der Lauf
# stellt sich seinen Code selbst aus (K03-M15, Ableitung in
# k19_kasten_daten.sql als pruef_codewert), sendet POST /anmeldung und
# liest fr_sitzung aus der Antwort. Er kennt den Server nur durch seine
# Tueren -- auch hier.
#
# FAIL-CLOSED: Gelingt das nicht, bleibt $KEKS leer und JEDER Bildschirm
# mit der Marke "nach Anmeldung" meldet GESPERRT. Nie bestanden, und nie
# gegen eine Fehlerseite gemessen.
# ---------------------------------------------------------------------
db() { psql -X -tAq -v ON_ERROR_STOP=1 -c "$1" 2>/dev/null; }

sitzungswert() {     # $1 name -> der Wert des Sitzungskekses
  grep -i '^set-cookie:[[:space:]]*fr_sitzung=' "$ARBEIT/$1.kopf" 2>/dev/null \
    | head -1 | sed 's/^[^=]*=//' | cut -d';' -f1
}

anmelden() {         # $1 email  $2 code  $3 name -> setzt ANM_STATUS, ANM_KEKS
  ANM_STATUS=""; ANM_KEKS=""
  local p="$ARBEIT/$3"
  db "DELETE FROM login_code
       WHERE actor_id = (SELECT id FROM actor WHERE email='$1')
         AND consumed_at IS NULL AND superseded_at IS NULL" >/dev/null || return 1
  db "INSERT INTO login_code (actor_id, code_hash, issued_at, expires_at)
      SELECT id, pruef_codewert('$2','$FREIRAUM_CODE_PFEFFER'), now(), now() + interval '10 minutes'
        FROM actor WHERE email='$1'" >/dev/null || return 1
  ANM_STATUS=$(curl -sS -o "$p.rumpf" -D "$p.kopf" -w '%{http_code}' --max-time 25 \
        -X POST --data-urlencode "email=$1" --data-urlencode "code=$2" \
        "$BASIS/anmeldung" 2>"$p.fehler") || ANM_STATUS="000"
  [ -f "$p.kopf" ] && tr -d '\r' < "$p.kopf" > "$p.kopf.rein" && mv "$p.kopf.rein" "$p.kopf"
  ANM_KEKS="$(sitzungswert "$3")"
  [ -n "$ANM_KEKS" ]
}

printf 'FREIRAUM · K19-M01 — folgt die ausgelieferte Seite ihrem Kasten? Gegen %s\n' "$BASIS"
printf 'Referenz: %s\n\n' "$REFERENZ"

# =====================================================================
# Ein Bildschirm, zwei Faelle. Die Schleife hat genau eine Zeile Daten
# je Bildschirm: Kennung und Adresse. Alles Weitere steht im Kasten.
# =====================================================================
pruefe_bildschirm() {  # $1 Kennung  $2 Pfad  [$3 Sitzungskeks]
  local kennung="$1" pfad="$2" keks="${3:-}" el="$ARBEIT/$1.elemente" st anzahl fehlend folge

  if ! kasten_elemente "$kennung" > "$el" 2>"$ARBEIT/$1.kastenfehler"; then
    sperr "$kennung-A" "Die Build-Referenz fuehrt fuer $kennung keinen Kasten -- es gibt nichts, dem die Seite folgen koennte (K19-G01: fail-closed, der Bildschirm gilt als nicht belegt). Kein Baufehler."
    sperr "$kennung-B" "Ohne Kasten keine Reihenfolge."
    return
  fi

  anzahl="$(kasten_messen /dev/null "$el" zaehlen)"
  if [ "${anzahl:-0}" -lt 2 ]; then
    sperr "$kennung-A" "Der Kasten fuehrt nur $anzahl messbare(s) Element(e); daran laesst sich weder Vollstaendigkeit noch Reihenfolge unterscheiden."
    sperr "$kennung-B" "Der Kasten fuehrt nur $anzahl messbare(s) Element(e)."
    return
  fi

  st="$(hole "$pfad" "$kennung" "$keks")"
  if [ "$st" != "200" ]; then
    sperr "$kennung-A" "GET $pfad antwortete mit $st statt 200 -- eine Fehlerseite gegen einen Kasten zu halten misst den Fehler, nicht den Kasten."
    sperr "$kennung-B" "GET $pfad antwortete mit $st statt 200."
    return
  fi

  fehlend="$(kasten_messen "$ARBEIT/$kennung.rumpf" "$el" fehlend)"
  if [ -z "$fehlend" ]; then
    ok "$kennung-A" "Alle $anzahl Elemente des Kastens $kennung stehen in der ausgelieferten Seite $pfad (K19-M01, Abschn. 4.1 'Kasten unveraendert')"
  else
    nok "$kennung-A" "Die Seite $pfad fuehrt Elemente ihres Kastens $kennung nicht: $(printf '%s' "$fehlend" | tr '\n' '|')"
  fi

  if [ -n "$fehlend" ]; then
    sperr "$kennung-B" "Reihenfolge nicht entscheidbar, solange Elemente fehlen -- sonst scheiterte dieser Fall an der Bedingung von $kennung-A (F07)."
    return
  fi

  folge="$(kasten_messen "$ARBEIT/$kennung.rumpf" "$el" folge)"
  if [ "$folge" = "OK" ]; then
    ok "$kennung-B" "Die $anzahl Elemente stehen in der Seite $pfad in der Reihenfolge des Kastens $kennung (K19-M01)"
  else
    nok "$kennung-B" "Die Seite $pfad haelt die Reihenfolge des Kastens $kennung nicht ein -- $folge"
  fi
}

# ---------------------------------------------------------------------
# Die Sitzung fuer die Bildschirme mit der Marke "nach Anmeldung".
#
# Sie wird VOR den Faellen hergestellt und einmal. Jede Vorbedingung
# wird einzeln geprueft und einzeln benannt: ein GESPERRT, das nicht
# sagt WARUM, ist so wenig wert wie ein gruener Lauf, der nichts misst.
#
# Der Aufbau selbst (Konto AKTIV, Portal freigeschaltet) steht in
# k19_kasten_daten.sql und wird DORT geprueft -- diese Datei liest nur,
# ob er eingespielt ist. Fehlt die Sicht, ist die Datenlage unbekannt,
# und ein Lauf gegen eine unbekannte Datenlage misst nichts (F07).
# ---------------------------------------------------------------------
KEKS=""; SITZUNG_GRUND=""
if ! command -v psql >/dev/null 2>&1; then
  SITZUNG_GRUND="psql fehlt -- ohne Datenbank stellt sich der Lauf keinen Anmeldecode aus (K03-M15)"
elif [ -z "${FREIRAUM_CODE_PFEFFER:-}" ]; then
  SITZUNG_GRUND="FREIRAUM_CODE_PFEFFER ist nicht gesetzt -- der ausgestellte Code traege einen anderen Pruefwert als der Server erwartet, und die Anmeldung scheiterte an der Pruefdatenlage statt am Kasten (F07)"
elif [ -z "$(db 'SELECT 1')" ]; then
  SITZUNG_GRUND="die Datenbank $PGDATABASE auf $PGHOST:$PGPORT ist nicht erreichbar"
elif [ "$(db "SELECT count(*) FROM pg_views WHERE viewname='pruef_k19_kasten_lage'")" != "1" ]; then
  SITZUNG_GRUND="die Sicht pruef_k19_kasten_lage fehlt -- pruefungen/klauseln/k19_kasten_daten.sql ist nicht eingespielt"
elif [ "$(db "SELECT count(*) FROM pruef_k19_kasten_lage WHERE email='k19_seite@k19pruef.example' AND status='AKTIV' AND freigeschaltete_portale >= 1")" != "1" ]; then
  SITZUNG_GRUND="das Konto k19_seite@k19pruef.example ist nicht aktiv oder gehoert keinem freigeschalteten Portal an -- die Anmeldung scheiterte an einer fremden Bedingung (F07)"
elif ! anmelden 'k19_seite@k19pruef.example' '190001' k19anm; then
  SITZUNG_GRUND="die Anmeldung von k19_seite@k19pruef.example scheiterte (Status $ANM_STATUS, kein fr_sitzung in der Antwort)"
else
  KEKS="$ANM_KEKS"
fi
printf 'Sitzung: %s\n\n' "$( [ -n "$KEKS" ] && printf 'steht' || printf 'KEINE — %s' "$SITZUNG_GRUND" )"

# EN-01 · Anmeldung · Zugangsmarke "offen" (K19 Abschn. 6).
# Die Adresse /anmeldung stammt aus der Wegetabelle des Scheibenplans,
# nicht aus der Vorlage: dieselbe Adresse, gegen die VP-01 misst, dass
# jeder Aufruf ohne Sitzung dort endet. Bewusst OHNE Keks geholt -- die
# Marke lautet "offen", und ein Bildschirm, den nur ein Angemeldeter
# sieht, traegt sie nicht.
pruefe_bildschirm EN-01 /anmeldung

# EN-03 · Direkt-Prototyp-Check · Zugangsmarke "nach Anmeldung".
# Die Adresse /vorpruefung stammt aus derselben Wegetabelle; VP-04 misst
# gegen sie die beiden Wege des Bildschirms.
if [ -z "$KEKS" ]; then
  sperr EN-03-A "Ohne Sitzung nicht messbar: $SITZUNG_GRUND"
  sperr EN-03-B "Ohne Sitzung nicht messbar: $SITZUNG_GRUND"
else
  pruefe_bildschirm EN-03 /vorpruefung "$KEKS"
fi

# EN-04a · Zweckbestimmung. Der Bildschirm besteht in
# schema/K19_screens.yaml, die Build-Referenz fuehrt fuer ihn aber
# keinen Kasten. GESPERRT, nicht durchgefallen -- der Bau ist damit
# nicht beurteilt. Eine Adresse wird hier NICHT genannt: der Fall sperrt,
# bevor er eine Seite holt, und ein geratener Pfad waere eine erfundene
# Fundstelle.
pruefe_bildschirm EN-04a '(ohne Adresse -- der Fall sperrt vorher)'

printf '\n'
[ "$gesperrt" -gt 0 ] && printf 'davon GESPERRT (nicht messbar, zaehlt nach K23-M22 nicht als bestanden): %s\n' "$gesperrt"
printf 'SUMME: %s von %s bestanden, %s gescheitert\n' "$bestanden" "$gesamt" "$gescheitert"
[ "$gescheitert" -eq 0 ]
