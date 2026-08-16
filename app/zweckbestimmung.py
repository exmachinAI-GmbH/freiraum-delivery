# umsetzt: K04-M19, K04-M20, K04-M21, K04-D09, K04-D10, K04-M08, K04-D06,
#          K04-D08, K04-M18, K01-D19, K13-M05, K19-M14
#          sowie die Zeichnung beider Vertragsparteien vom 16.08.2026:
#          Zweckbestimmung und Kenntnisnahme werden als ZUSTAND (Anzeige)
#          UND als EREIGNIS (Nachweis) gefuehrt. Damit ist O-K04-8
#          geschlossen und der Behelf K04-G12 abgeloest -- er verlangte
#          das Ereignis nur, "solange kein Traeger besteht"; jetzt tragen
#          beide, jedes fuer seinen eigenen Zweck
# zur Haelfte umgesetzt: K01-M27 -- weil diese Datei die Anwendungszeile
#          ausschliesslich ueber `create_app_after_fit` anlegt und selbst
#          kein INSERT auf `app` fuehrt; die fuenf Pruefungen selbst laufen
#          in der Migration M31, nicht hier
# zur Haelfte umgesetzt: K01-M38 -- weil diese Datei die Projektnummer
#          nirgends bildet, nirgends liest und nirgends weiterreicht;
#          gebildet wird sie im Serverbefehl (M31)
# zur Haelfte umgesetzt: K04-M17 -- weil Anlage und beidseitige
#          Verknuepfung im Serverbefehl in EINER Transaktion laufen; diese
#          Datei ruft ihn auf und wertet aus, was er meldet
# zur Haelfte umgesetzt: K10-M34 -- weil die Kenntnisnahme hier dauerhaft
#          geschrieben wird (Spalte UND Ereignis); dass sie in das
#          Uebergabe-Paket eingeht, gehoert K10 und ist nicht gebaut
"""FREIRAUM · Scheibe 2 · M4 · die Zweckbestimmung und die Anwendungsanlage.

Ein Bildschirm aus dem Vertrag `schema/K19_screens.yaml`, uebernommen und
nicht frei gezeichnet (K19-M01, K04-G10):

    EN-04a  Zweckbestimmung -- zwei getrennte Fragen, Warnung mit
            Kenntnisnahme, Halt mit drei Auswegen, Anlage der Anwendung

Der Vertrag dieser Datei -- er ist zugleich das, was die Pruefung misst:

    GET  /zweckbestimmung          EN-04a. AENDERT NICHTS. Ohne gueltige
                                   Sitzung -> 303 auf "/anmeldung". Ohne
                                   laufenden Eignungs-Check -> 303 auf
                                   "/vorpruefung". Steht die Eignung nicht
                                   auf GEEIGNET -> 303 auf "/eignung".
                                   Sonst 200 mit beiden Fragen; die
                                   Schaltflaeche zur Anlage erscheint erst,
                                   wenn beide beantwortet sind
    POST /zweckbestimmung/antwort  Felder `frage_bewertung` bzw.
                                   `frage_praktik` (Wert = eigener Name)
                                   und `antwort_bewertung` bzw.
                                   `antwort_praktik` (ja|nein) -- je Frage
                                   ein eigener Name, keiner kommt zweimal
                                   vor. Antwortfeld und Marke muessen
                                   dieselbe Frage nennen.
                                   Erfolg -> 303 auf "/zweckbestimmung".
                                   Schreibt Spalte UND Ereignis in EINER
                                   Transaktion; scheitert eines, ist
                                   nichts geschrieben.
                                   IM HALT gesperrt: 200 mit benannter
                                   Meldung, nichts geaendert
    POST /zweckbestimmung/kenntnis Ohne Feld. Nur bei Treffer in Frage 1
                                   und verneinter Frage 2. Erfolg -> 303.
                                   Schreibt Spalte UND Ereignis in EINER
                                   Transaktion; scheitert eines, ist nichts
                                   geschrieben und es geht nicht weiter
    POST /zweckbestimmung/anlegen  Ohne Feld -- ausdruecklich auch ohne
                                   Feld fuer die Projektnummer (K01-D19).
                                   Erfolg -> 303 auf
                                   "/zweckbestimmung?angelegt=<Check>".
                                   Sonst 200 mit benannter Meldung und
                                   OHNE Anwendungszeile
    POST /zweckbestimmung/aendern  GENAU EINE Marke,
                                   `ruecknahme_bewertung` oder
                                   `ruecknahme_praktik`, mit dem Code
                                   ihrer Frage als Wert. Nimmt die Antwort
                                   auf diese Frage zurueck und schreibt
                                   dabei Spalte UND Ereignis in EINER
                                   Transaktion -- der frueher gegebene
                                   Stand bleibt in den Ereignissen lesbar.
                                   Erfolg -> 303 auf "/zweckbestimmung"
    POST /zweckbestimmung/termin   Legt eine Zeile in `event` an und leitet
                                   auf "/zweckbestimmung?termin=1".
                                   AENDERT DIE ERKLAERUNG NICHT

Die sechste Aktion des Bildschirmvertrags, `zur_uebersicht`, ist ein
Verweis auf "/uebersicht" und braucht keinen eigenen Weg -- genau wie
Ausweg 3 auf EN-04.

DIE ZWEI FRAGEN SIND ABGELEITET, NICHT BELEGT (offener Punkt O-M4-1).
K04-M19 nennt den GEGENSTAND beider Fragen, nicht ihren Anzeigewortlaut.
Der Wortlaut unten haelt sich so eng an die Klausel, wie es geht: er
uebernimmt ihre Aufzaehlungen Wort fuer Wort und macht aus dem Satz eine
Frage. Erfunden ist nichts dazu -- kein Beispiel, keine Erlaeuterung, kein
Anwendungsfall. Gezeichnet ist er trotzdem nicht; er geht als O-M4-1 in
die Vorlage.

DIE REIHENFOLGE DER AUSWERTUNG STEHT IM BILDSCHIRMVERTRAG, WOERTLICH:
"Treffer in Frage 2 -> Halt-Feld, auch wenn Frage 1 ebenfalls zutrifft;
sonst Treffer in Frage 1 -> Kenntnisnahme; sonst kein Treffer ->
anwendung_anlegen". Sie steht in dieser Datei an genau EINER Stelle
(`auswerten`) und wird von jedem Weg benutzt. Zwei Auswertungen waeren
zwei Wahrheiten -- und die eine, die der Bildschirm zeigt, waere nicht die,
die die Anlage prueft.

DER VORRANG IST KEINE GESTALTUNGSFRAGE (K04-D10). Ein Vorhaben, das beide
Fragen trifft, ist verboten und nicht bloss pflichtig. Wuerde zuerst Frage
1 ausgewertet, saehe die Nutzerin eine Warnung mit einer Schaltflaeche zum
Bestaetigen -- und bestaetigte etwas, das keine Bestaetigung heilt. Der
Serverbefehl prueft dieselbe Reihenfolge noch einmal (M31, Abschnitt 2b);
die beiden Stellen sind nicht redundant, sondern Anzeige und Riegel.

WAS DER SERVER ENTSCHEIDET, ENTSCHEIDET NICHT DER BROWSER (K19-M14,
K13-M05). Im Halt zeigt EN-04a keine Antwortformulare und keine
Schaltflaeche zur Anlage -- aber ein Bildschirm, der etwas nicht anbietet,
verbietet es nicht. Wer das Formular von Hand nachbaut, erreicht denselben
Weg. Deshalb fragt JEDER schreibende Weg dieser Datei den Stand der
Zweckbestimmung ab, BEVOR er liest oder schreibt, und weist im Halt mit
einer benannten Meldung ab. Sonst waere ein solches Formular ein VIERTER
Weg aus dem Halt, und K04-M08 verlangt genau drei.

KEIN FELD FUER DIE PROJEKTNUMMER (K01-D19). Nicht in einem Formular, nicht
als Parameter, nicht als verdecktes Feld. Ein dennoch mitgesendeter Wert
wird verworfen -- und zwar in der schaerfsten Form, die es gibt: er wird
nicht gelesen. Kein Weg dieser Datei nimmt ihn entgegen, kein Weg reicht
ihn weiter, und `create_app_after_fit` hat in seiner neuen Fassung keinen
Parameter mehr, in den er passte. "Verworfen" heisst hier nicht
"angenommen und dann ignoriert".

DER MANDANT IST DIE ERSTE FRAGE, NICHT DIE LETZTE (K04-D08). Jede Abfrage
dieser Datei auf `fit_check` fuehrt `tenant_id = Mandant der Sitzung` in
ihrer eigenen Bedingung -- im Lesen wie im Schreiben. Ein Check eines
fremden Mandanten wird nicht gefunden und dann abgelehnt, er wird gar
nicht erst gelesen. Das gilt auch fuer die Bestaetigungsseite nach der
Anlage: die Kennung dort kommt aus der Adresszeile, und die Abfrage dazu
fuehrt Mandant UND Konto in der Bedingung.

DIE EIGNUNGSSICHT IST KEIN SCHREIBSCHUTZ (K04-D06, K01-G05). Dass
`app.fit_check_id` im Schema nullbar ist und dass es eine Lesesicht
`app_fit_ok` gibt, erlaubt hier nichts. Diese Datei fuehrt kein einziges
INSERT auf `app`. Der einzige Weg zu einer Anwendungszeile ist der
Serverbefehl (K01-M27).

WAS HIER AUSDRUECKLICH NICHT GEBAUT IST

  * KEIN ZUSTANDSWECHSEL. `change_app_state` und der Weg nach EN-05
    gehoeren zu M5. Nach der Anlage endet dieser Weg mit der Weiterleitung
    auf die Bestaetigung -- sie nennt die vergebene Projektnummer und
    verweist auf die Uebersicht.
  * KEIN NAME FUER DIE ANWENDUNG. Der Bildschirmvertrag fuehrt fuer
    `anwendung_anlegen` keine Eingabe ausser dem Check; `app.name` ist
    aber Pflicht. Vergeben wird deshalb ein vorlaeufiger Name, den der
    naechste Schritt ersetzt (K05, EN-05). Ihn hier abzufragen hiesse, dem
    Bildschirm ein Feld hinzuzufuegen, das der Vertrag nicht fuehrt.
  * KEINE AUFLOESUNG DER ANSPRECHPERSON beim Termin -- dieselbe Lage wie
    auf EN-04: `contact` gehoert K11 und traegt im Pilotbestand keine
    Zeile.
"""
import logging
import uuid
from pathlib import Path

import psycopg
from fastapi import APIRouter, Form, Request
from fastapi.responses import HTMLResponse, RedirectResponse
from fastapi.templating import Jinja2Templates

from app.datenbank import verbindung
from app.sitzung import KEKS_NAME, keks_loeschen, merkmal_lesen, sitzung_pruefen

PROTOKOLL = logging.getLogger(__name__)

# Gegen __file__, nicht gegen das Arbeitsverzeichnis -- dieselbe
# Begruendung wie in app/haupt.py und app/vorpruefung.py.
VORLAGEN = Jinja2Templates(directory=str(Path(__file__).parent / "vorlagen"))

router = APIRouter()

# 303 und nicht 302: nach einem POST muss der Browser auf GET wechseln.
# Sonst legt ein Neuladen dieselbe Antwort ein zweites Mal vor -- und beim
# Anlegen eine zweite Anwendung mit einer zweiten Projektnummer.
UMLEITUNG = 303

# Der einzige Ergebniswert, unter dem dieser Bildschirm ueberhaupt
# erscheint. K04-M19: "Nach `outcome = GEEIGNET` MUSS ein
# Zweckbestimmungs-Schritt folgen" -- vorher nicht.
GEEIGNET = "GEEIGNET"

# Die beiden Fragen. `code` ist der Wert im Formular, `spalte` der Traeger
# in der Datenbank (M31). Der Code steht NICHT fuer eine Zeile in
# `fit_question`: K04-M19 sagt ausdruecklich "Er ist kein `fit_question`",
# und die drei Eignungsdimensionen bleiben unberuehrt.
FRAGE_BEWERTUNG = "bewertung"
FRAGE_PRAKTIK = "praktik"

SPALTE = {
    FRAGE_BEWERTUNG: "zweck_bewertung_menschen",
    FRAGE_PRAKTIK: "zweck_verbotene_praktik",
}

# JE FRAGE EIN EIGENER FELDNAME -- `antwort_bewertung`, `antwort_praktik`.
#
# Keine Klausel verlangt getrennte Namen. Zwei getrennte Fragen mit
# demselben Feldnamen sind aber von aussen nicht auseinanderzuhalten: wer
# den Bildschirm nur ueber seine Felder liest, sieht ein einziges Feld
# `antwort` und kann nicht sagen, welche der beiden Fragen er gerade
# beantwortet. Getrennte Namen kosten nichts und machen den Bildschirm
# messbar; sie sind hier am 16.08.2026 nachgezogen worden.
#
# Der Name des Antwortfeldes NENNT die Frage, und er nennt sie eindeutig:
# `antwort_bewertung` ist die erste Frage, `antwort_praktik` die zweite.
# Beide gehoeren zu einem geschlossenen, hier aufgezaehlten Bestand -- der
# Server nimmt keinen Namen entgegen, den er nicht selbst gebildet hat.
FELDNAME_ANTWORT = {
    FRAGE_BEWERTUNG: "antwort_" + FRAGE_BEWERTUNG,
    FRAGE_PRAKTIK: "antwort_" + FRAGE_PRAKTIK,
}

# JE FRAGE AUCH EINE EIGENE MARKE -- `frage_bewertung`, `frage_praktik`.
#
# BEFUND, gemessen am 16.08.2026: Der Bildschirm trug bis dahin ZWEI
# verborgene Felder mit demselben Namen `frage` und verschiedenen Werten --
# eines je Frage. Wer die Seite als Ganzes einliest und alle verborgenen
# Felder mitschickt, sendet denselben Namen zweimal, und bei doppeltem
# Schluessel gewinnt der letzte Wert. Der Server las dann immer die zweite
# Frage, suchte deren Antwortfeld, fand beim Beantworten der ERSTEN Frage
# nichts -- und schrieb nichts. Kein Fehler, keine Meldung, keine
# Weiterleitung: die Antwort ging STILL verloren.
#
# Zwei Felder desselben Namens auf einer Seite sind eine Falle, gleich wer
# sie stellt. Sie ist hier beseitigt, indem die Marke den Namen ihrer Frage
# traegt. Damit gibt es auf dem Bildschirm keinen Feldnamen mehr, der
# zweimal mit verschiedenen Werten vorkommt.
FELDNAME_FRAGE = {
    FRAGE_BEWERTUNG: "frage_" + FRAGE_BEWERTUNG,
    FRAGE_PRAKTIK: "frage_" + FRAGE_PRAKTIK,
}

# DIE RUECKNAHME TRAEGT EIGENE NAMEN -- `ruecknahme_bewertung`,
# `ruecknahme_praktik`.
#
# Sind beide Fragen beantwortet, stehen auf dem Bildschirm VIER Formulare:
# je Frage eines zum Antworten und eines zum Zuruecknehmen. Truegen
# Antwort- und Ruecknahmeformular derselben Frage dieselbe Marke, stuende
# dieser Name zweimal auf der Seite. Er truege zwar beide Male denselben
# Wert -- aber "es faellt nicht auf, weil die Werte gleich sind" ist keine
# Eigenschaft, auf die sich bauen laesst. Nach dieser Aenderung kommt auf
# EN-04a kein Feldname zweimal vor.
#
# Die Namen sind ausserdem DISJUNKT zu denen des Antwortwegs. Ein Feld,
# das an den falschen der beiden Wege geraet, wird dort nicht gelesen und
# kann dort nichts ausloesen.
FELDNAME_RUECKNAHME = {
    FRAGE_BEWERTUNG: "ruecknahme_" + FRAGE_BEWERTUNG,
    FRAGE_PRAKTIK: "ruecknahme_" + FRAGE_PRAKTIK,
}

# --- Der Wortlaut der beiden Fragen ---------------------------------------
#
# ABGELEITET, NICHT BELEGT -- offener Punkt O-M4-1 des Plans zu M4.
#
# K04-M19 nennt den Gegenstand beider Fragen und nicht ihren
# Anzeigewortlaut. Die beiden Saetze unten uebernehmen die Aufzaehlungen
# der Klausel Wort fuer Wort und machen aus dem Klauselsatz eine Frage --
# mehr nicht. Kein Beispiel, keine Erlaeuterung, kein Anwendungsfall ist
# hinzugekommen; nichts ist weggelassen. Wer den Wortlaut zeichnet, aendert
# diese beiden Konstanten und sonst nichts.
#
# Die Klausel im Wortlaut, damit die Ableitung nachpruefbar bleibt:
#   "Er fragt zweierlei getrennt: erstens, ob die Anwendung Menschen
#    bewertet, auswaehlt oder ueberwacht -- bei Bewerbung, Beschaeftigung,
#    Kreditwuerdigkeit, Versicherung, Bildung, Biometrie; zweitens, ob sie
#    Gefuehle am Arbeitsplatz oder in der Bildung erkennen, Menschen nach
#    sozialem Verhalten bewerten, Schwaechen wegen Alter, Behinderung oder
#    Notlage ausnutzen oder Gesichter ungezielt sammeln soll."
WORTLAUT_FRAGE_1 = (
    "Soll die Anwendung Menschen bewerten, auswaehlen oder ueberwachen -- "
    "bei Bewerbung, Beschaeftigung, Kreditwuerdigkeit, Versicherung, "
    "Bildung oder Biometrie?")
WORTLAUT_FRAGE_2 = (
    "Soll die Anwendung Gefuehle am Arbeitsplatz oder in der Bildung "
    "erkennen, Menschen nach sozialem Verhalten bewerten, Schwaechen wegen "
    "Alter, Behinderung oder Notlage ausnutzen oder Gesichter ungezielt "
    "sammeln?")

FRAGEN = (
    {"code": FRAGE_BEWERTUNG, "nummer": 1, "text": WORTLAUT_FRAGE_1},
    {"code": FRAGE_PRAKTIK, "nummer": 2, "text": WORTLAUT_FRAGE_2},
)

# Der vorlaeufige Name der Anwendung. `app.name` ist Pflicht, der
# Bildschirmvertrag fuehrt fuer diesen Schritt aber kein Namensfeld -- der
# Name entsteht im gefuehrten Gespraech (K05, EN-05). Ein Platzhalter, der
# als Platzhalter LESBAR ist, ist ehrlicher als ein erfundener Name.
NAME_VORLAEUFIG = "Neue Anwendung (Name folgt in Stufe 01)"

# --- Die vier Staende der Zweckbestimmung ---------------------------------
# Aufgezaehlt und benannt, damit jeder Weg denselben Stand meint. Die
# Reihenfolge ihrer Ermittlung steht in `auswerten` und nirgends sonst.
ZUSTAND_UNVOLLSTAENDIG = "UNVOLLSTAENDIG"   # eine der beiden Fragen offen
ZUSTAND_HALT = "HALT"                       # Treffer in Frage 2 (K04-D10)
ZUSTAND_KENNTNIS = "KENNTNIS"               # Treffer in Frage 1 (K04-M20)
ZUSTAND_FREI = "FREI"                       # der Weg zur Anlage ist offen

# --- Die Meldungen. Jede einzeln benannt, jede fuer einen Menschen ohne
# --- IT-Kenntnisse lesbar (CONTRIBUTING.md). Umlaute werden wie im ganzen
# --- Bestand umschrieben.

# Der Vorrangsatz. Er steht auf dem Bildschirm ueber beiden Fragen, damit
# niemand die zweite Frage fuer eine Verschaerfung der ersten haelt.
# Abgeleitet aus K04-D10 ("dort heilt keine Aufklaerung und keine
# Bestaetigung") und K04-M20.
VORRANGSATZ = (
    "Die beiden Fragen sind getrennt und werden getrennt beantwortet. "
    "Trifft die zweite Frage zu, endet der Weg hier -- auch dann, wenn die "
    "erste Frage ebenfalls zutrifft. Daran aendert keine Aufklaerung und "
    "keine Bestaetigung etwas.")

# K19 EN-04a/zweckfrage_beantworten, zustand_leer: "[Weiter] ausgeblendet,
# Hinweis nennt die fehlende Frage (K19-M06)". Beides geschieht hier --
# anders als auf EN-04, wo die Schaltflaeche stehen bleibt: dort ist
# [Weiter] der Weg, den die Nutzerin nach der letzten Antwort wieder
# braucht, hier erscheint er nach dem Absenden der zweiten Antwort von
# selbst wieder, weil jede Antwort die Seite neu laedt.
HINWEIS_FEHLT_EINE = (
    "Es fehlt noch eine Antwort. Sie koennen weitergehen, sobald diese "
    "Frage beantwortet ist:")
HINWEIS_FEHLT_BEIDE = (
    "Es fehlen noch beide Antworten. Sie koennen weitergehen, sobald diese "
    "Fragen beantwortet sind:")

# Eine Frage oder eine Antwort, die es nicht gibt. Fail-closed: es wird
# nichts gespeichert, und der Satz sagt das.
MELDUNG_AUSWAHL_UNGUELTIG = (
    "Diese Angabe gehoert nicht zu den beiden Fragen. Es wurde nichts "
    "gespeichert; bitte antworten Sie erneut.")

# Der Halt, serverseitig. K04-M08 laesst genau drei Auswege zu; "noch eine
# Antwort speichern" ist keiner davon.
MELDUNG_HALT_ANTWORT = (
    "Dieser Weg ist angehalten, weil Sie die zweite Frage bejaht haben. "
    "Solange das so steht, laesst sich keine Antwort speichern; es wurde "
    "nichts geaendert. Sie haben genau drei Moeglichkeiten: Ihre Antwort "
    "aendern, ein Gespraech mit Ihrer Ansprechperson vereinbaren oder zur "
    "Uebersicht zurueckkehren.")

# Dasselbe fuer die Anlage. Eigener Satz und nicht derselbe: "eine Antwort
# speichern" und "eine Anwendung anlegen" sind zwei verschiedene Dinge, und
# die Nutzerin soll erfahren, was sie gerade versucht hat.
MELDUNG_HALT_ANLAGE = (
    "Dieser Weg ist angehalten, weil Sie die zweite Frage bejaht haben. Es "
    "entsteht keine Anwendung; es wurde nichts angelegt. Sie haben genau "
    "drei Moeglichkeiten: Ihre Antwort aendern, ein Gespraech mit Ihrer "
    "Ansprechperson vereinbaren oder zur Uebersicht zurueckkehren.")

# F5 des Plans: Weiter, bevor beide Fragen beantwortet sind.
MELDUNG_ANLAGE_UNVOLLSTAENDIG = (
    "Bitte beantworten Sie zuerst beide Fragen. Es wurde nichts angelegt.")

# F2 des Plans: Treffer in Frage 1 ohne Kenntnisnahme. K04-M21 -- ohne sie
# ist die Auskunftspflicht nach Art. 25 Abs. 4 nicht belegbar.
MELDUNG_ANLAGE_OHNE_KENNTNIS = (
    "Bitte bestaetigen Sie zuerst, dass Sie die Hinweise zu Anhang III zur "
    "Kenntnis genommen haben. Es wurde nichts angelegt.")

# Der Weg "Kenntnis nehmen", wenn es nichts zur Kenntnis zu nehmen gibt.
# Der Bildschirm bietet ihn dann nicht an -- aber ein Bildschirm ist keine
# Sperre (K19-M14).
MELDUNG_KENNTNIS_NICHT_OFFEN = (
    "Zu diesem Vorhaben steht keine Bestaetigung offen. Es wurde nichts "
    "geaendert.")

# F4 des Plans, fail-closed: der Nachweis laesst sich nicht schreiben.
# Dann gibt es keinen Weiterweg und keine Anwendung -- und der Satz sagt
# ausdruecklich, dass es nicht an den Angaben der Nutzerin liegt.
MELDUNG_KENNTNIS_NICHT_SCHREIBBAR = (
    "Ihre Bestaetigung konnte nicht dauerhaft gesichert werden. Aus "
    "Vorsicht wurde nichts geaendert und nichts angelegt. Das liegt nicht "
    "an Ihren Angaben. Bitte wenden Sie sich an Ihre Ansprechperson.")

# Die Anlage ist abgewiesen worden. Der GRUND aus der Datenbank steht
# bewusst NICHT in der Meldung: er nennt Kennungen und Tabellennamen, und
# K23-D09 verbietet Betriebsangaben in der Fehlerausgabe. Er gehoert ins
# Protokoll des Betreibers.
MELDUNG_ANLAGE_ABGEWIESEN = (
    "Die Anwendung konnte nicht angelegt werden. Es ist keine Anwendung "
    "entstanden. Bitte wenden Sie sich an Ihre Ansprechperson.")

# Fail-closed fuer den Fall, den es nicht geben duerfte: eine Zeile, die
# zwischen Lesen und Schreiben nicht mehr getroffen wird.
MELDUNG_STAND_UNKLAR = (
    "Der Stand dieses Vorhabens laesst sich zurzeit nicht sicher lesen. Aus "
    "Vorsicht wurde nichts geaendert. Das liegt nicht an Ihren Angaben. "
    "Bitte wenden Sie sich an Ihre Ansprechperson.")

# Ausweg 2 nach dem Halt. Die Quittung nach der Umleitung -- sie sagt, was
# geschehen ist, und verspricht nichts, was diese Scheibe nicht haelt.
MELDUNG_TERMIN = (
    "Ihr Wunsch nach einem Gespraech ist vermerkt. Ihre Ansprechperson "
    "meldet sich bei Ihnen.")

# --- Die drei Ansagen aus K04-M20 -----------------------------------------
# Sie sind KEINE freie Formulierung: die Klausel verlangt bei einem Treffer
# in Frage 1 genau drei Dinge -- die Warnung zu Anhang III, den Hinweis auf
# die Anbieterpflichten aus Art. 9, 11, 14, 17 und 43 und die Aufforderung
# zu bestaetigen. Drei Konstanten, damit keine davon beim Umbauen des
# Bildschirms verlorengeht.
WARNUNG_ANHANG_III = (
    "Ihre Anwendung kann unter Anhang III der KI-Verordnung fallen. Das "
    "heisst nicht, dass Sie sie nicht bauen duerfen -- es heisst, dass "
    "Pflichten daran haengen.")
HINWEIS_ANBIETERPFLICHTEN = (
    "Sie bringen die Anwendung als Anbieter unter Ihrem eigenen Namen in "
    "Verkehr. Damit tragen Sie die Pflichten aus Art. 9, 11, 14, 17 und 43 "
    "der KI-Verordnung.")
AUFFORDERUNG_BESTAETIGEN = (
    "Bitte bestaetigen Sie, dass Sie beides zur Kenntnis genommen haben. "
    "Ohne diese Bestaetigung geht es nicht weiter.")

# --- Die Ablehnung aus K04-M20, zweite Haelfte ----------------------------
# "Bei einem Treffer in der zweiten Frage MUSS er stattdessen den Grund der
# Ablehnung nennen und auf Art. 5 verweisen." Beides steht hier: der Grund
# im ersten Satz, der Verweis im zweiten.
HALT_GRUND = (
    "Sie haben angegeben, dass die Anwendung eine der in der zweiten Frage "
    "genannten Praktiken ausfuehren soll. Das ist der Grund, aus dem es "
    "hier nicht weitergeht.")
HALT_VERWEIS_ART5 = (
    "Diese Praktiken sind nach Art. 5 der KI-Verordnung verboten. Ein "
    "Verbot laesst sich nicht durch Aufklaerung oder Bestaetigung "
    "ausraeumen -- deshalb gibt es hier keine Bestaetigung, sondern drei "
    "Auswege.")

# Die Bestaetigung nach der Anlage. Sie nennt die vergebene Projektnummer
# -- ANZEIGEN ist nicht ANBIETEN (K01-D19 verbietet Eingabe, Auswahl und
# Aenderung, nicht die Auskunft ueber das Ergebnis).
MELDUNG_ANGELEGT = (
    "Ihre Anwendung ist angelegt. Die Projektnummer hat FREIRAUM vergeben; "
    "sie laesst sich nicht aendern.")
HINWEIS_NACH_ANLAGE = (
    "Der naechste Schritt ist das gefuehrte Gespraech zu Ihrem Vorhaben. "
    "Er ist noch nicht freigeschaltet.")


def _zurueck_auf_en01(merkmal):
    """Ohne gueltige Sitzung fuehrt kein Weg weiter -- K03-D01.

    Wortgleich zu `_zurueck_auf_en01` in app/haupt.py und app/vorpruefung.py
    und bewusst nicht von dort eingebunden: dieselbe Begruendung wie dort --
    app/haupt.py bindet beide Dateien ein, der umgekehrte Weg waere ein
    Ringschluss beim Import. Wandert die Regel spaeter in eine gemeinsame
    Datei, wandern alle drei Ausfertigungen zusammen.
    """
    antwort = RedirectResponse("/anmeldung", status_code=UMLEITUNG)
    if merkmal:
        keks_loeschen(antwort)
    antwort.headers["Cache-Control"] = "no-store"
    return antwort


def _seite(request, vorlage, inhalt, status=200):
    antwort = VORLAGEN.TemplateResponse(request, vorlage, inhalt,
                                        status_code=status)
    # Diese Seite nennt den angemeldeten Namen, die Zweckbestimmung eines
    # Vorhabens und nach der Anlage die Projektnummer. In einem
    # Zwischenspeicher hat nichts davon etwas verloren (K03-M26).
    antwort.headers["Cache-Control"] = "no-store"
    return antwort


def _umleitung(ziel):
    antwort = RedirectResponse(ziel, status_code=UMLEITUNG)
    antwort.headers["Cache-Control"] = "no-store"
    return antwort


class _CheckNichtGetroffen(RuntimeError):
    """Ein UPDATE auf `fit_check` hat nicht genau eine Zeile getroffen.

    Eigene Klasse und nicht einfach eine Verzweigung: sie wird INNERHALB von
    `conn.transaction()` ausgeloest, damit das Auswerfen den ganzen Vorgang
    zurueckrollt -- die Spalte und die Ereigniszeile gehoeren zusammen. Eine
    Verzweigung koennte das nicht; sie liesse die zuvor ausgefuehrte
    Anweisung stehen.
    """


# ---------------------------------------------------------------------------
#  Lesen und Auswerten
# ---------------------------------------------------------------------------


def check_lesen(conn, stand):
    """Der laufende Eignungs-Check dieses Kontos -- oder None.

    "Laufend" heisst hier wie auf EN-04: noch keiner Anwendung zugeordnet
    (`app_id` ist leer). Sobald die Anwendung entstanden ist, traegt der
    Check ihre Kennung und wird von dieser Abfrage nicht mehr gefunden --
    genau richtig, denn dann ist dieser Weg zu Ende.

    MANDANT UND KONTO STEHEN IN DER BEDINGUNG, nicht in einer Pruefung
    danach (K04-D08). Der juengste zuerst, aus demselben Grund wie auf
    EN-04.

    Eigene Abfrage und nicht die aus app/vorpruefung.py: diese hier liest
    die drei Spalten der Zweckbestimmung mit, jene liest sie nicht. Zwei
    Abfragen mit derselben Bedingung und verschiedenen Spalten sind
    ehrlicher als eine Abfrage, die fuer beide Seiten zu viel liest.
    """
    zeile = conn.execute(
        "SELECT id, outcome::text, zweck_bewertung_menschen,"
        "       zweck_verbotene_praktik,"
        "       zweckbestimmung_ack_at IS NOT NULL AS kenntnis"
        "  FROM fit_check"
        " WHERE tenant_id = %s AND actor_id = %s AND app_id IS NULL"
        " ORDER BY started_at DESC, id DESC LIMIT 1",
        (stand["mandant"], stand["actor_id"])).fetchone()
    if zeile is None:
        return None
    return {"id": zeile[0], "ergebnis": zeile[1], "bewertung": zeile[2],
            "praktik": zeile[3], "kenntnis": zeile[4]}


def auswerten(check):
    """Der Stand der Zweckbestimmung -- an genau einer Stelle.

    Die Reihenfolge ist die des Bildschirmvertrags, EN-04a, wortgleich:

      1. eine der beiden Fragen offen  ->  UNVOLLSTAENDIG. Der Vertrag
         fuehrt dafuer zustand_leer: "[Weiter] ausgeblendet, Hinweis nennt
         die fehlende Frage". Erst danach wird ueberhaupt ausgewertet.
      2. Treffer in Frage 2            ->  HALT, "auch wenn Frage 1
         ebenfalls zutrifft" (K04-D10). Der Vorrang steht hier und nicht
         in einer Verzweigung des Bildschirms.
      3. Treffer in Frage 1            ->  KENNTNIS (K04-M20). Kein Halt
         (K04-D09) -- der Weg geht weiter, sobald bestaetigt ist.
      4. sonst                         ->  FREI.

    Liegt die Kenntnisnahme bereits vor, ist der Stand FREI und nicht
    KENNTNIS: die Bedingung ist erfuellt. Die Warnung bleibt auf dem
    Bildschirm trotzdem stehen -- sie ist der Grund, aus dem bestaetigt
    wurde, und ein Grund, der nach der Bestaetigung verschwindet, war
    keiner.
    """
    if check["bewertung"] is None or check["praktik"] is None:
        return ZUSTAND_UNVOLLSTAENDIG
    if check["praktik"]:
        return ZUSTAND_HALT
    if check["bewertung"] and not check["kenntnis"]:
        return ZUSTAND_KENNTNIS
    return ZUSTAND_FREI


def fragen_mit_antwort(check):
    """Die beiden Fragen mit dem, was zu ihnen bereits beantwortet ist.

    Rueckgabe je Frage: `antwort` ist True, False oder None. None heisst
    "noch nicht beantwortet" und ist ausdruecklich nicht dasselbe wie
    "Nein" -- der Bildschirm darf keine der beiden Antwortmoeglichkeiten
    vorbelegen. Eine Vorbelegung waere eine Antwort, die niemand gegeben
    hat.

    `feld` ist der Formularname der Antwort, `marke` der Name des
    verborgenen Feldes im Antwortformular, `ruecknahme` der im
    Ruecknahmeformular -- je Frage eigene. Alle drei kommen aus
    FELDNAME_ANTWORT, FELDNAME_FRAGE und FELDNAME_RUECKNAHME und nicht aus
    der Vorlage, damit Bildschirm und Serverpfad dieselben Namen aus
    derselben Quelle nehmen. Kein Name kommt auf dem Bildschirm zweimal
    vor.
    """
    return [{"code": f["code"], "nummer": f["nummer"], "text": f["text"],
             "feld": FELDNAME_ANTWORT[f["code"]],
             "marke": FELDNAME_FRAGE[f["code"]],
             "ruecknahme": FELDNAME_RUECKNAHME[f["code"]],
             "antwort": check[f["code"]]}
            for f in FRAGEN]


def genannte_frage(marken, antworten=None):
    """Welche Frage nennt diese Absendung? -- oder None.

    GERATEN WIRD NICHTS. Eine Frage gilt nur dann als genannt, wenn die
    Absendung sie AUSDRUECKLICH nennt und sich dabei nicht widerspricht.
    Der Rueckgabewert None heisst immer dasselbe: es wird nichts
    geschrieben.

    `marken` ist die Zuordnung Frage -> Wert des verborgenen Feldes,
    `antworten` die Zuordnung Frage -> gesendete Antwort. Fehlt
    `antworten`, traegt die Marke die Frage allein (Weg W8, die
    Ruecknahme -- dort gibt es kein Antwortfeld).

    DIE MARKE MUSS ZU IHREM EIGENEN FELD PASSEN. `frage_bewertung` darf
    nur den Wert "bewertung" tragen. Eine Marke, die eine FREMDE Frage
    nennt, ist ein Widerspruch in sich; die ganze Absendung faellt dann
    aus, und zwar unabhaengig davon, welche Frage der Rest nennt.

    MIT ANTWORTFELD nennt der Name des Antwortfeldes die Frage, und die
    Marke dieser Frage muss danebenstehen und sie bestaetigen. Beide
    Seiten muessen dieselbe Frage nennen; nur eine von beiden reicht
    nicht. Die Marken der ANDEREN Frage stoeren nicht -- sie stehen auf
    demselben Bildschirm und gehoeren dem anderen Formular. Sie sind
    geprueft, aber sie entscheiden nichts.

    OHNE ANTWORTFELD traegt die Marke die Frage allein. Dann darf GENAU
    EINE gesetzt sein: zwei gesetzte Marken nennen zwei Fragen, und welche
    davon gemeint ist, wird hier nicht erraten.

    Die Reihenfolge der gesendeten Felder spielt an keiner Stelle eine
    Rolle. Genau daran ist der alte Weg gescheitert.
    """
    for code, marke in marken.items():
        wert = (marke or "").strip()
        if wert and wert != code:
            return None

    gesetzt = [code for code, marke in marken.items()
               if (marke or "").strip()]

    if antworten is None:
        if len(gesetzt) != 1:
            return None
        return gesetzt[0]

    beantwortet = [code for code, wahl in antworten.items()
                   if (wahl or "").strip()]
    if len(beantwortet) != 1:
        return None
    code = beantwortet[0]
    if code not in gesetzt:
        return None
    return code


def fehlende_fragen(check):
    """Welche Frage ist noch offen? -- K19-M06.

    Rueckgabe: der fertige Bausatz fuer den Bildschirm -- ein einleitender
    Satz und die noch offenen Fragen mit Nummer und WORTLAUT. Ist beides
    beantwortet, kommt None zurueck; dann hat der Bildschirm nichts zu
    zeigen.

    UND AUSSCHLIESSLICH DIE OFFENEN. Der Wortlaut einer bereits
    beantworteten Frage kommt hier gar nicht erst heraus -- der Bildschirm
    kann ihn deshalb auch nicht versehentlich mit anzeigen. Stuende er
    darin, suchte die Nutzerin eine Luecke, die es nicht gibt.
    """
    offen = [{"nummer": f["nummer"], "text": f["text"]}
             for f in FRAGEN if check[f["code"]] is None]
    if not offen:
        return None
    satz = HINWEIS_FEHLT_EINE if len(offen) == 1 else HINWEIS_FEHLT_BEIDE
    return {"satz": satz, "fragen": offen}


def angelegte_anwendung(conn, stand, kennung):
    """Die eben angelegte Anwendung zu diesem Eignungs-Check -- oder None.

    Sie wird fuer die Bestaetigungsseite gelesen, auf die der Weg nach der
    Anlage fuehrt. Die Kennung kommt aus der Adresszeile und wird deshalb
    wie jede Eingabe behandelt: MANDANT UND KONTO STEHEN IN DER BEDINGUNG
    (K04-D08). Wer eine fremde Kennung eintraegt, bekommt nicht die
    Auskunft "gibt es, gehoert Ihnen aber nicht", sondern None -- und damit
    denselben Weg wie jemand ohne Kennung.
    """
    try:
        pruefbar = uuid.UUID(str(kennung).strip())
    except ValueError:
        # Kein Wert, der ueberhaupt eine Kennung sein kann. Bewusst hier
        # und nicht in der Datenbank: dort loeste er einen Fehler aus, und
        # ein Fehler ist keine Auskunft.
        return None
    zeile = conn.execute(
        "SELECT a.project_no, a.name"
        "  FROM app a JOIN fit_check f ON f.app_id = a.id"
        " WHERE f.id = %s AND f.tenant_id = %s AND f.actor_id = %s",
        (pruefbar, stand["mandant"], stand["actor_id"])).fetchone()
    if zeile is None:
        return None
    return {"projektnummer": zeile[0], "name": zeile[1]}


# Die Aufbewahrungsklasse der Zweckbestimmung. Sie steht als benannte
# Konstante und nicht als Zeichenkette an vier Stellen, weil genau das die
# Entscheidung vom 16.08.2026 traegt: Zustand UND Ereignis sind DERSELBE
# Nachweis, und ein Nachweis hat genau eine Frist.
KLASSE_NACHWEIS = "KI_NACHWEIS"


def _ereignis(conn, stand, check_id, aktion, wert, art, klasse=None):
    """Eine Zeile in `event` -- unveraenderlich, mit Bezug auf den Check.

    Die Erklaerung braucht die Zeile aus dem Grund, den die Spalte nicht
    aufwiegt: eine Spalte kennt nur ihren letzten Wert. Wer wann was
    geantwortet und was zurueckgenommen hat, steht ausschliesslich hier --
    und `event` traegt seit M30 den Ausloeser `event_append_only`, der
    UPDATE und DELETE mit einem Fehler ABWEIST statt sie still zu
    verwerfen. Eine Ereigniszeile wird nie veraendert und nie geloescht.

    `actor_label` steht mit im INSERT, weil die Bedingung
    `event_actor_paarweise` Verknuepfung und Namensschnappschuss gemeinsam
    verlangt (K02-G13): wer das Konto entfernt, soll nicht den Namen
    mitnehmen.

    ZWEI GETRENNTE ANGABEN, UND SIE HINGEN BIS ZUM 16.08.2026 ZUSAMMEN.
    `art` ist die Art der Aenderung (`event.change_type`), `klasse` die
    Aufbewahrungsfrist (`event.retention_class`). Die frueheren zwei
    Zweige koppelten beides: wer eine Klasse setzte, bekam ungefragt auch
    `Neuanlage` statt `Aenderung`. Das ist getrennt, weil es zwei
    verschiedene Fragen sind -- WAS geschah und WIE LANGE es aufbewahrt
    wird. Gekoppelt liesse sich die eine nicht beantworten, ohne die
    andere still mitzubeantworten.

    `klasse` leer heisst: es gilt die Spaltenvorgabe. Sie steht seit M30
    Stufe 8 auf EREIGNIS (`M30`:1493) -- nicht mehr auf BETRIEBSPROTOKOLL,
    wie die Grundfassung sie setzt. Das ist die richtige Klasse fuer einen
    reinen Betriebsvorgang wie den Terminwunsch.

    Fuer die Zweckbestimmung wird sie ausdruecklich auf KI_NACHWEIS
    gesetzt -- fuer die Kenntnisnahme wie fuer jede Antwort und jede
    Ruecknahme. Sie sind derselbe Nachweis wie die Spalten an `fit_check`,
    und zwei Aufbewahrungsfristen fuer einen Nachweis waeren eine zu viel
    (K04-M21, K15).
    """
    if klasse is None:
        conn.execute(
            "INSERT INTO event (actor_id, actor_label, tenant_id, action,"
            "                   object_ref, change_type, value, source)"
            " VALUES (%s, %s, %s, %s, %s, %s, %s, 'PORTAL_ACTION')",
            (stand["actor_id"], stand["anzeigename"], stand["mandant"],
             aktion, "FIT_CHECK:" + str(check_id), art, wert))
        return
    conn.execute(
        "INSERT INTO event (actor_id, actor_label, tenant_id, action,"
        "                   object_ref, change_type, value, source,"
        "                   retention_class)"
        " VALUES (%s, %s, %s, %s, %s, %s, %s, 'PORTAL_ACTION', %s)",
        (stand["actor_id"], stand["anzeigename"], stand["mandant"],
         aktion, "FIT_CHECK:" + str(check_id), art, wert, klasse))


# ---------------------------------------------------------------------------
#  EN-04a · der Bildschirm
# ---------------------------------------------------------------------------


def _en04a(request, stand, check, meldung=None):
    """Der Bildschirm. Er entscheidet nichts -- er zeigt, was gelesen wurde.

    Der Stand kommt AUSSCHLIESSLICH aus `auswerten` und wird hier nicht
    noch einmal gerechnet. Was der Bildschirm zeigt, kann deshalb nicht von
    dem abweichen, was die schreibenden Wege pruefen.

    ZWEI VERSCHIEDENE ANSAGEN, und sie werden nicht vermischt -- dieselbe
    Aufteilung wie auf EN-04:

      `meldung`  die Statusansage oben im Kasten. Sie blickt ZURUECK auf
                 einen abgeschlossenen Vorgang: die Terminquittung, eine
                 ungueltige Auswahl, eine Abweisung.
      `hinweis`  der Hinweis auf die noch fehlende Frage. Er blickt NACH
                 VORN auf die Bedingung des naechsten Schritts und steht
                 deshalb unten an der Stelle der Schaltflaeche (K19-M06:
                 "an ihrer Stelle").
    """
    zustand = auswerten(check)
    return _seite(request, "en04a_zweckbestimmung.html", {
        "anzeigename": stand["anzeigename"],
        "fragen": fragen_mit_antwort(check),
        "vorrangsatz": VORRANGSATZ,
        "zustand": zustand,
        "halt": zustand == ZUSTAND_HALT,
        # Die Warnung steht, sobald Frage 1 zutrifft UND Frage 2 verneint
        # ist -- vor wie nach der Bestaetigung. Im Halt steht sie nicht:
        # dort tritt die Ablehnung an ihre Stelle (K04-M20).
        "warnung": check["praktik"] is False and check["bewertung"] is True,
        "kenntnis_offen": zustand == ZUSTAND_KENNTNIS,
        "kenntnis_vorliegend": check["kenntnis"],
        "anlage_offen": zustand == ZUSTAND_FREI,
        "hinweis": fehlende_fragen(check),
        "warnung_anhang_iii": WARNUNG_ANHANG_III,
        "hinweis_anbieterpflichten": HINWEIS_ANBIETERPFLICHTEN,
        "aufforderung_bestaetigen": AUFFORDERUNG_BESTAETIGEN,
        "halt_grund": HALT_GRUND,
        "halt_verweis": HALT_VERWEIS_ART5,
        # Ausweg 1 nimmt die Antwort auf die ZWEITE Frage zurueck. Name und
        # Wert der Marke kommen aus derselben Quelle wie im Serverpfad --
        # in der Vorlage steht keiner von beiden als fester Text.
        "marke_halt": FELDNAME_RUECKNAHME[FRAGE_PRAKTIK],
        "code_halt": FRAGE_PRAKTIK,
        "meldung": meldung,
        "angelegt": None,
    })


def _vorbedingung(conn, stand):
    """Check und Eignung -- oder die Antwort, die stattdessen hinausgeht.

    Rueckgabe: `(check, None)`, wenn der Weg offen ist; sonst
    `(None, antwort)`. Diese eine Stelle traegt die Vorbedingungen von
    EN-04a, damit sie nicht in sechs Wegen je einmal stehen und dort
    auseinanderlaufen.

    DIE EIGNUNG WIRD BEI JEDEM AUFRUF ERNEUT GELESEN -- auch beim Anzeigen,
    nicht nur bei der Anlage. K04-M18 verlangt es fuer die Anlage
    ausdruecklich ("ein veralteter Bildschirmstand berechtigt nicht"); dass
    es hier fuer jeden Weg gilt, ist kein Mehr an Vorsicht, sondern das
    Gegenteil einer Ausnahme: es gibt keinen Weg, auf dem der Stand aus
    einem frueheren Aufruf weiterwirkt.
    """
    check = check_lesen(conn, stand)
    if check is None:
        # Kein laufender Eignungs-Check. Bewusst eine Umleitung und keine
        # Meldung -- es ist kein Fehler, sondern jemand, der einen Schritt
        # uebersprungen hat.
        return None, _umleitung("/vorpruefung")

    if check["ergebnis"] != GEEIGNET:
        # F1 des Plans, und zwar fuer JEDEN Weg dieser Datei. K04-M19:
        # der Schritt folgt NACH GEEIGNET. Steht dort etwas anderes --
        # OFFEN, NICHT_GEEIGNET oder ein Wert, den niemand vorgesehen hat
        # --, gehoert die Nutzerin auf EN-04 und nicht hierher.
        PROTOKOLL.info(
            "Zweckbestimmung nicht geoeffnet: der Eignungs-Check traegt "
            "das Ergebnis %s statt GEEIGNET (K04-M19).", check["ergebnis"])
        return None, _umleitung("/eignung")

    return check, None


@router.get("/zweckbestimmung", response_class=HTMLResponse)
def zweckbestimmung(request: Request, termin: str = "", angelegt: str = ""):
    """W1 · EN-04a zeigen. AENDERT NICHTS.

    `termin` traegt keine Angabe zum Vorgang -- es ist die Quittung nach
    der Umleitung des Termin-Wegs und nichts weiter.

    `angelegt` traegt die Kennung des Eignungs-Checks, aus dem die
    Anwendung entstanden ist. Sie wird NICHT geglaubt: gelesen wird mit
    Mandant und Konto in der Bedingung, und wer nichts findet, sieht die
    Bestaetigung nicht. Die Kennung steht in der Adresszeile, weil der Weg
    nach dem Anlegen eine Umleitung ist (POST, dann GET) -- ein Neuladen
    darf keine zweite Anwendung anlegen.
    """
    merkmal = request.cookies.get(KEKS_NAME)
    with verbindung() as conn:
        stand = sitzung_pruefen(conn, merkmal_lesen(merkmal))
        if stand is None:
            return _zurueck_auf_en01(merkmal)

        if angelegt:
            fertig = angelegte_anwendung(conn, stand, angelegt)
            if fertig is not None:
                return _seite(request, "en04a_zweckbestimmung.html", {
                    "anzeigename": stand["anzeigename"],
                    "angelegt": fertig,
                    "meldung_angelegt": MELDUNG_ANGELEGT,
                    "hinweis_nach_anlage": HINWEIS_NACH_ANLAGE,
                })

        check, antwort = _vorbedingung(conn, stand)
        if antwort is not None:
            return antwort
        return _en04a(request, stand, check,
                      meldung=MELDUNG_TERMIN if termin else None)


# ---------------------------------------------------------------------------
#  W2 · Eine Frage beantworten
# ---------------------------------------------------------------------------


@router.post("/zweckbestimmung/antwort", response_class=HTMLResponse)
def zweckfrage_beantworten(request: Request,
                           frage_bewertung: str = Form(default=""),
                           frage_praktik: str = Form(default=""),
                           antwort_bewertung: str = Form(default=""),
                           antwort_praktik: str = Form(default="")):
    """W2 · eine der beiden Fragen beantworten (K04-M19).

    Zwei getrennte Fragen heisst: zwei getrennte Formulare, zwei getrennte
    Feldnamen und zwei getrennte Schreibvorgaenge. Es gibt keinen Weg, auf
    dem beide zugleich entstehen -- und keinen, auf dem eine Antwort die
    andere setzt.

    DIE FRAGE MUSS VON BEIDEN SEITEN GENANNT WERDEN. Der Name des
    Antwortfeldes nennt sie -- `antwort_bewertung` ist die erste Frage --
    und die Marke dieser Frage muss danebenstehen: `frage_bewertung` mit
    dem Wert "bewertung". Stimmen beide nicht ueberein, wird nichts
    geschrieben. Der Server leitet die Frage also nicht ab, er prueft eine
    Nennung gegen eine zweite; die Regeln stehen in `genannte_frage`.

    KEIN FELDNAME KOMMT AUF DIESEM BILDSCHIRM ZWEIMAL VOR. Bis zum
    16.08.2026 trugen beide Formulare ein verborgenes Feld `frage`, und
    eine Absendung, die alle verborgenen Felder der Seite mitschickte,
    nannte denselben Namen zweimal. Der letzte Wert gewann, die Antwort zur
    ERSTEN Frage lief ins Leere und ging STILL verloren -- 200, keine
    Weiterleitung, nichts geschrieben, keine Meldung. Seither traegt jede
    Marke den Namen ihrer eigenen Frage, und die Marke der anderen Frage
    darf mitkommen, ohne etwas zu entscheiden.

    IM HALT IST DIESER WEG ZU. Nach einem Treffer in Frage 2 zeigt EN-04a
    keine Antwortformulare mehr -- aber der Bildschirm ist keine Sperre.
    Wer das Formular von Hand nachbaut, kaeme sonst an derselben Stelle
    heraus, und das waere ein VIERTER Weg aus dem Halt (K04-M08, K19-M14).
    Der Weg zurueck aus dem Halt ist "Antwort aendern", nicht "Antwort
    ueberschreiben": erst wird die aufhaltende Antwort zurueckgenommen,
    danach steht der Bildschirm wieder offen.

    JEDE ANTWORT SCHREIBT ZUSTAND UND EREIGNIS, IN EINER TRANSAKTION --
    Zeichnung vom 16.08.2026, dasselbe Muster wie die Kenntnisnahme (W5).
    Die Spalte ist die ANZEIGE: sie kennt nur ihren letzten Wert und wird
    von der naechsten Antwort ueberschrieben. Die Ereigniszeile ist der
    NACHWEIS: was die Kundin DAMALS geantwortet hat, bleibt lesbar. Sie
    traegt dieselbe Aufbewahrungsklasse wie die der Kenntnisnahme
    (KI_NACHWEIS) -- ein Nachweis hat genau eine Frist.

    In EINER Transaktion, weil beides sonst auseinanderlaufen kann: eine
    Spalte ohne Ereignis waere ein Zustand ohne Nachweis, ein Ereignis
    ohne Spalte ein Nachweis ueber etwas, das nicht geschehen ist. Die
    Ausnahme `_CheckNichtGetroffen` fliegt INNERHALB der Transaktion und
    rollt deshalb beides zurueck.

    DER ZEITPUNKT DER VOLLSTAENDIGKEIT WIRD MITGESCHRIEBEN, in derselben
    Anweisung. Die Bedingung `zweck_erklaerung_vollstaendig` (M31) verlangt,
    dass er nur steht, wenn beide Antworten vorliegen; zwei getrennte
    Anweisungen liefen dazwischen in genau diese Bedingung.

    200 UND NICHT 4xx bei einer Abweisung, aus demselben Grund wie auf
    EN-04: die Wegetabelle nennt 303 fuer den ERFOLG. Eine Abweisung ist
    kein Erfolg; sie bleibt stehen und traegt eine benannte Meldung.
    """
    merkmal = request.cookies.get(KEKS_NAME)
    with verbindung() as conn:
        stand = sitzung_pruefen(conn, merkmal_lesen(merkmal))
        if stand is None:
            return _zurueck_auf_en01(merkmal)
        check, fehlweg = _vorbedingung(conn, stand)
        if fehlweg is not None:
            return fehlweg

        if auswerten(check) == ZUSTAND_HALT:
            PROTOKOLL.warning(
                "Antwort abgewiesen: die zweite Frage der Zweckbestimmung "
                "ist bejaht, der Weg ist angehalten. Es wurde nichts "
                "geaendert (K04-M08, K04-D10, K19-M14).")
            return _en04a(request, stand, check,
                          meldung=MELDUNG_HALT_ANTWORT)

        gesendet = {FRAGE_BEWERTUNG: antwort_bewertung,
                    FRAGE_PRAKTIK: antwort_praktik}
        marken = {FRAGE_BEWERTUNG: frage_bewertung,
                  FRAGE_PRAKTIK: frage_praktik}
        code = genannte_frage(marken, gesendet)
        # Die Pruefung gegen SPALTE bleibt daneben stehen. `genannte_frage`
        # gibt nur einen der beiden bekannten Codes oder None zurueck; dass
        # es dabei bleibt, wird hier nicht geglaubt, sondern nachgesehen.
        wahl = "" if code is None else gesendet[code].strip().lower()
        if code not in SPALTE or wahl not in ("ja", "nein"):
            # Fail-closed: es wird nichts gespeichert, und der Satz sagt
            # das. Der Bildschirm liefert beides mit; geglaubt wird keines.
            return _en04a(request, stand, check,
                          meldung=MELDUNG_AUSWAHL_UNGUELTIG)

        wert = wahl == "ja"
        neu = dict(check)
        neu[code] = wert
        vollstaendig = (neu["bewertung"] is not None
                        and neu["praktik"] is not None)

        # Der Spaltenname kommt aus SPALTE und niemals aus dem Formular:
        # `code` ist zuvor gegen die beiden zugelassenen Werte geprueft
        # worden. Der WERT steht als Parameter, nicht im Text.
        anweisung = (
            f"UPDATE fit_check SET {SPALTE[code]} = %s,"
            "       zweckbestimmung_erklaert_am ="
            "         CASE WHEN %s THEN COALESCE(zweckbestimmung_erklaert_am,"
            "                                    now())"
            "              ELSE NULL END"
            " WHERE id = %s AND tenant_id = %s")

        try:
            with conn.transaction():
                getroffen = conn.execute(
                    anweisung,
                    (wert, vollstaendig, check["id"], stand["mandant"])
                ).rowcount
                if getroffen != 1:
                    raise _CheckNichtGetroffen(getroffen)
                _ereignis(conn, stand, check["id"],
                          "ZWECKBESTIMMUNG_BEANTWORTET",
                          f"Frage {1 if code == FRAGE_BEWERTUNG else 2}: "
                          f"{'Ja' if wert else 'Nein'}",
                          "Aenderung", klasse=KLASSE_NACHWEIS)
        except _CheckNichtGetroffen as fehler:
            PROTOKOLL.error(
                "Antwort nicht gespeichert: das UPDATE auf fit_check traf "
                "%s Zeilen statt einer. Nichts geaendert.", fehler)
            return _en04a(request, stand, check, meldung=MELDUNG_STAND_UNKLAR)

    return _umleitung("/zweckbestimmung")


# ---------------------------------------------------------------------------
#  W5 · Kenntnis nehmen
# ---------------------------------------------------------------------------


@router.post("/zweckbestimmung/kenntnis", response_class=HTMLResponse)
def kenntnis_nehmen(request: Request):
    """W5 · die Kenntnisnahme, dauerhaft (K04-M20, K04-M21).

    SIE ENTSTEHT NUR NACH EINEM TREFFER IN FRAGE 1. Der Bildschirmvertrag
    sagt es fuer diese Aktion woertlich, und der Stand wird hier gelesen,
    nicht geglaubt: `auswerten` muss KENNTNIS ergeben. Damit ist im selben
    Zug ausgeschlossen, dass jemand im Halt bestaetigt -- dort heilt keine
    Bestaetigung (K04-D10).

    SIE WIRD ZWEIMAL GESCHRIEBEN, UND SEIT DEM 16.08.2026 IST DAS
    GEZEICHNET. Die Spalte `fit_check.zweckbestimmung_ack_at` ist der
    Traeger fuer die ANZEIGE, den die Founder am 4.8.2026 mit Entscheidung
    F1 gewaehlt haben (M30, Abschnitt 3g); die Ereigniszeile ist der
    NACHWEIS. Bis zum 16.08.2026 stand diese Doppelung auf einem
    Widerspruch zweier Quellen und wurde vorsorglich gebaut; seither steht
    sie auf der Entscheidung beider Vertragsparteien, die O-K04-8
    geschlossen hat. Ihre Begruendung in einem Satz: ein Nachweis, den man
    ueberschreiben kann, ist keiner. Genau das kann die Spalte -- sie
    kennt nur ihren letzten Wert --, und genau das kann die Ereigniszeile
    nicht: `event_append_only` weist UPDATE und DELETE mit einem Fehler ab.

    BEIDES IN EINER TRANSAKTION, und daran haengt F4 des Plans: "Der
    Nachweis der Kenntnisnahme laesst sich nicht schreiben -> kein
    Weiterweg, keine Anwendung." Faellt eine der beiden Anweisungen aus,
    steht keine von beiden -- und ohne Spalte weist der Serverbefehl die
    Anlage ab (M31). Ein halb geschriebener Nachweis waere schlimmer als
    keiner: er saehe aus wie einer.

    ZWEIMAL BESTAETIGEN AENDERT NICHTS. Die Bedingung
    `zweckbestimmung_ack_at IS NULL` im UPDATE sorgt dafuer, dass der
    Zeitpunkt der ERSTEN Bestaetigung stehen bleibt. Ein Nachweis, dessen
    Datum sich von aussen verschieben laesst, ist keiner.
    """
    merkmal = request.cookies.get(KEKS_NAME)
    with verbindung() as conn:
        stand = sitzung_pruefen(conn, merkmal_lesen(merkmal))
        if stand is None:
            return _zurueck_auf_en01(merkmal)
        check, fehlweg = _vorbedingung(conn, stand)
        if fehlweg is not None:
            return fehlweg

        if auswerten(check) != ZUSTAND_KENNTNIS:
            PROTOKOLL.warning(
                "Kenntnisnahme abgewiesen: der Stand der Zweckbestimmung "
                "ist %s, verlangt ist ein Treffer in Frage 1 bei verneinter "
                "Frage 2. Nichts geaendert (K04-M21, K19-M14).",
                auswerten(check))
            return _en04a(request, stand, check,
                          meldung=MELDUNG_KENNTNIS_NICHT_OFFEN)

        try:
            with conn.transaction():
                getroffen = conn.execute(
                    "UPDATE fit_check SET zweckbestimmung_ack_at = now()"
                    " WHERE id = %s AND tenant_id = %s"
                    "   AND outcome = 'GEEIGNET'"
                    "   AND zweckbestimmung_ack_at IS NULL",
                    (check["id"], stand["mandant"])).rowcount
                if getroffen != 1:
                    raise _CheckNichtGetroffen(getroffen)
                _ereignis(conn, stand, check["id"],
                          "ZWECKBESTIMMUNG_KENNTNIS_GENOMMEN",
                          "Anhang III und die Anbieterpflichten aus Art. 9, "
                          "11, 14, 17 und 43 zur Kenntnis genommen "
                          "(K04-M21, Art. 25 Abs. 4)",
                          "Neuanlage", klasse=KLASSE_NACHWEIS)
        except (_CheckNichtGetroffen, psycopg.errors.IntegrityError) as fehler:
            # Fail-closed (F4). Beide Faelle enden gleich: nichts steht,
            # kein Weiterweg, keine Anwendung. Die Bedingungen aus M30 --
            # ack_nach_eignung, ack_klasse_ki_nachweis -- landen als
            # IntegrityError hier; sie werden NICHT einzeln uebersetzt,
            # weil die Nutzerin an jeder von ihnen dasselbe tun kann:
            # nichts. Dass die Kenntnisnahme eine vollstaendige
            # Erklaerung voraussetzt, steht seit dem 16.08.2026 nicht mehr
            # als Tabellenbedingung in M31, sondern traegt hier: `auswerten`
            # liefert UNVOLLSTAENDIG, solange eine Frage offen ist, und der
            # Weg oben bricht dann ab, bevor irgendetwas geschrieben wird.
            PROTOKOLL.error(
                "Kenntnisnahme nicht geschrieben, nichts geaendert und "
                "nichts angelegt (K04-M21, fail-closed): %s", fehler)
            return _en04a(request, stand, check,
                          meldung=MELDUNG_KENNTNIS_NICHT_SCHREIBBAR)

    return _umleitung("/zweckbestimmung")


# ---------------------------------------------------------------------------
#  W7 · Die Anwendung anlegen
# ---------------------------------------------------------------------------


@router.post("/zweckbestimmung/anlegen", response_class=HTMLResponse)
def anwendung_anlegen(request: Request):
    """W7 · die Anwendung -- ausschliesslich ueber den Serverbefehl.

    DIESER WEG NIMMT KEINE PROJEKTNUMMER ENTGEGEN (K01-D19, F6 des Plans).
    Er nimmt ueberhaupt kein Feld entgegen. Ein mitgesendeter Wert wird
    verworfen, und zwar in der schaerfsten Form: er wird nicht gelesen.
    Es gibt hier keinen Parameter, in den er liefe, keine Variable, in der
    er landete, und `create_app_after_fit` hat in seiner neuen Fassung
    keinen Parameter mehr, an den er weitergereicht werden koennte. Das ist
    der Unterschied zu "entgegengenommen und dann verworfen" -- letzteres
    waere eine Stelle, an der jemand die Verwerfung wieder herausnehmen
    kann.

    DIE EIGNUNG WIRD ZWEIMAL ERNEUT GELESEN (K04-M18, F7 des Plans): hier,
    unmittelbar vor dem Aufruf (`_vorbedingung`), und noch einmal im
    Serverbefehl selbst, in DERSELBEN Transaktion, in der die Zeile
    entsteht. Die zweite Lesung ist die, auf die es ankommt: zwischen der
    ersten und dem Commit liegt Zeit. Wechselt die Eignung dazwischen,
    scheitert die Anlage -- und zwar an der Bedingung, nicht am Zufall.

    DREI GRUENDE, AUS DENEN HIER ABGEWIESEN WIRD, und jeder mit eigener
    Meldung (F1, F2, F5 des Plans):

      UNVOLLSTAENDIG  eine der beiden Fragen ist offen
      HALT            Treffer in Frage 2 -- es entsteht nichts (K04-D10)
      KENNTNIS        Treffer in Frage 1 ohne Bestaetigung (K04-M21)

    Die Eignung selbst faengt `_vorbedingung` eine Ebene vorher ab. Alle
    drei Gruende prueft der Serverbefehl noch einmal; hier stehen sie,
    damit die Nutzerin erfaehrt, WAS fehlt, statt nur, dass es nicht ging.

    UND KEINE ZEILE ENTSTEHT AN DIESER STELLE. Diese Datei fuehrt kein
    INSERT auf `app` -- der Serverbefehl ist der einzige Weg (K01-M27).
    """
    merkmal = request.cookies.get(KEKS_NAME)
    with verbindung() as conn:
        stand = sitzung_pruefen(conn, merkmal_lesen(merkmal))
        if stand is None:
            return _zurueck_auf_en01(merkmal)
        check, fehlweg = _vorbedingung(conn, stand)
        if fehlweg is not None:
            return fehlweg

        zustand = auswerten(check)
        if zustand != ZUSTAND_FREI:
            meldung = {
                ZUSTAND_UNVOLLSTAENDIG: MELDUNG_ANLAGE_UNVOLLSTAENDIG,
                ZUSTAND_HALT: MELDUNG_HALT_ANLAGE,
                ZUSTAND_KENNTNIS: MELDUNG_ANLAGE_OHNE_KENNTNIS,
            }[zustand]
            PROTOKOLL.warning(
                "Anlage abgewiesen: der Stand der Zweckbestimmung ist %s. "
                "Es ist keine Anwendung entstanden (K01-M27, K04-M21, "
                "K04-D10).", zustand)
            return _en04a(request, stand, check, meldung=meldung)

        try:
            zeile = conn.execute(
                "SELECT create_app_after_fit(%s, %s, %s, %s)",
                (stand["mandant"], NAME_VORLAEUFIG, check["id"],
                 stand["actor_id"])).fetchone()
        except (psycopg.errors.IntegrityError,
                psycopg.errors.RaiseException) as fehler:
            # Der Grund geht ins Protokoll des Betreibers, nicht auf den
            # Bildschirm (K23-D09). Es ist KEINE Zeile entstanden: der
            # Befehl laeuft in einer Transaktion, und was er auswirft,
            # rollt alles zurueck -- auch die gezogene Projektnummer.
            PROTOKOLL.error(
                "Anlage abgewiesen durch create_app_after_fit; es ist keine "
                "Anwendung entstanden (K01-M27): %s", fehler)
            return _en04a(request, stand, check,
                          meldung=MELDUNG_ANLAGE_ABGEWIESEN)

        if zeile is None or zeile[0] is None:
            # Der Befehl hat nichts ausgeworfen und trotzdem keine Kennung
            # geliefert. Fail-closed: das wird nicht als Erfolg gelesen.
            PROTOKOLL.error(
                "Anlage unklar: create_app_after_fit lieferte keine Kennung "
                "und keinen Fehler. Es wird kein Erfolg angenommen.")
            return _en04a(request, stand, check,
                          meldung=MELDUNG_ANLAGE_ABGEWIESEN)

    # Weiterleitung mit 303, nicht 200: ein Neuladen der Bestaetigung darf
    # keine zweite Anwendung anlegen (POST, dann GET).
    return _umleitung(f"/zweckbestimmung?angelegt={check['id']}")


# ---------------------------------------------------------------------------
#  W8 · Antwort aendern -- Ausweg 1 nach dem Halt
# ---------------------------------------------------------------------------


@router.post("/zweckbestimmung/aendern", response_class=HTMLResponse)
def antwort_aendern(request: Request,
                    ruecknahme_bewertung: str = Form(default=""),
                    ruecknahme_praktik: str = Form(default="")):
    """W8 · AUSWEG 1 nach dem Halt: die Antwort zuruecknehmen (K04-M08).

    Der Weg nimmt die Antwort auf die genannte Frage zurueck und setzt
    KEINE neue. Danach ist die Erklaerung unvollstaendig, der Halt fort und
    der Bildschirm wieder offen -- W1. Dass die Erklaerung danach
    unvollstaendig ist, ist kein Mangel, sondern der Zweck: eine
    unvollstaendige Erklaerung laesst nichts durch (K04-G04).

    HIER TRAEGT DIE MARKE DIE FRAGE ALLEIN -- es gibt kein Antwortfeld,
    das sie ein zweites Mal nennen koennte. Deshalb muss GENAU EINE Marke
    gesetzt sein und ihren eigenen Namen tragen. Zwei gesetzte Marken
    nennen zwei Fragen; welche gemeint ist, wird nicht erraten, sondern
    abgewiesen -- mit einer Meldung, damit nichts still geschieht. Ein
    Formular dieses Bildschirms sendet nie zwei: jedes traegt genau seine
    eigene.

    DIESER WEG BLEIBT IM HALT AUSDRUECKLICH OFFEN. Die beiden anderen
    schreibenden Wege sind dort zu; dieser nicht, denn er ist der erste der
    drei Auswege. Ein Ausweg, der selbst gesperrt waere, waere keiner --
    der Halt haette dann zwei Auswege statt drei, und auch das verletzte
    K04-M08.

    AUCH DIE RUECKNAHME SCHREIBT EIN EREIGNIS -- und das ist der Kern der
    Zeichnung vom 16.08.2026. Die Spalte geht hier auf NULL zurueck; waere
    sie der einzige Traeger, waere die frueher gegebene Antwort damit
    verschwunden. Die Ereigniszeile nennt sie im Wortlaut
    ("Frage 2: Ja zurueckgenommen") und steht neben der Zeile, die sie
    seinerzeit eingetragen hat. Beide bleiben, beide in derselben
    Aufbewahrungsklasse wie die Kenntnisnahme. Ein Ereignis wird nie
    veraendert und nie geloescht (`event_append_only`).

    ZUSTAND UND EREIGNIS IN EINER TRANSAKTION, wie auf jedem anderen Weg
    dieser Datei. Ohne sie koennte die Spalte geleert sein, ohne dass
    irgendwo stuende, was sie zuvor trug -- genau der Verlust, den die
    Entscheidung ausschliesst.

    DIE KENNTNISNAHME BLEIBT STEHEN (offener Punkt O-M4-3 des Plans). Sie
    wird hier nicht mit zurueckgenommen. Ein Nachweis, den man
    zurueckziehen kann, ist keiner -- und K04-M21 verlangt, dass er
    ERHALTEN bleibt und in das Uebergabe-Paket eingeht. Dass die
    Bestaetigung danach zu einer Frage gehoert, die neu beantwortet wird,
    ist kein Widerspruch: die Ereigniszeile traegt den Zeitpunkt, und die
    Reihenfolge bleibt lesbar. Der Punkt geht in die Vorlage, er ist nicht
    still entschieden.

    DER ZEITPUNKT DER VOLLSTAENDIGKEIT WIRD MITGELEERT, in derselben
    Anweisung -- sonst schluege die Bedingung
    `zweck_erklaerung_vollstaendig` (M31) zwischen zwei Anweisungen zu, und
    zu Recht: ein Zeitpunkt der Vollstaendigkeit bei offener Frage ist eine
    Falschangabe.
    """
    merkmal = request.cookies.get(KEKS_NAME)
    with verbindung() as conn:
        stand = sitzung_pruefen(conn, merkmal_lesen(merkmal))
        if stand is None:
            return _zurueck_auf_en01(merkmal)
        check, fehlweg = _vorbedingung(conn, stand)
        if fehlweg is not None:
            return fehlweg

        code = genannte_frage({FRAGE_BEWERTUNG: ruecknahme_bewertung,
                               FRAGE_PRAKTIK: ruecknahme_praktik})
        if code not in SPALTE:
            return _en04a(request, stand, check,
                          meldung=MELDUNG_AUSWAHL_UNGUELTIG)

        if check[code] is None:
            # Es gibt nichts zurueckzunehmen. Kein Schreibvorgang, keine
            # Ereigniszeile -- sonst truege der Nachweis eine Ruecknahme,
            # die es sachlich nie gab.
            return _umleitung("/zweckbestimmung")

        bisher = "Ja" if check[code] else "Nein"
        anweisung = (
            f"UPDATE fit_check SET {SPALTE[code]} = NULL,"
            "       zweckbestimmung_erklaert_am = NULL"
            " WHERE id = %s AND tenant_id = %s")

        try:
            with conn.transaction():
                getroffen = conn.execute(
                    anweisung, (check["id"], stand["mandant"])).rowcount
                if getroffen != 1:
                    raise _CheckNichtGetroffen(getroffen)
                _ereignis(conn, stand, check["id"],
                          "ZWECKBESTIMMUNG_ZURUECKGENOMMEN",
                          f"Frage {1 if code == FRAGE_BEWERTUNG else 2}: "
                          f"{bisher} zurueckgenommen",
                          "Aenderung", klasse=KLASSE_NACHWEIS)
        except _CheckNichtGetroffen as fehler:
            PROTOKOLL.error(
                "Ruecknahme abgebrochen: das UPDATE auf fit_check traf %s "
                "Zeilen statt einer. Nichts geaendert.", fehler)
            return _en04a(request, stand, check, meldung=MELDUNG_STAND_UNKLAR)

    return _umleitung("/zweckbestimmung")


# ---------------------------------------------------------------------------
#  W9 · Termin -- Ausweg 2 nach dem Halt
# ---------------------------------------------------------------------------


@router.post("/zweckbestimmung/termin")
def termin(request: Request):
    """W9 · AUSWEG 2 nach dem Halt: Gespraech mit der Ansprechperson.

    Was hier entsteht, ist EINE Zeile in `event`. Mehr nicht, und das ist
    Absicht -- dieselbe Bauart und dieselben Gruende wie auf EN-04:

      * DIE ERKLAERUNG BLEIBT UNVERAENDERT. Ein Terminwunsch hebt keinen
        Halt auf. Wer den Halt durch einen Anruf aufheben koennte, haette
        keinen Halt (K04-D10).
      * ES ENTSTEHT KEINE ANWENDUNG.
      * DIE ANSPRECHPERSON WIRD NICHT AUFGELOEST. `contact` gehoert K11 und
        traegt im Pilotbestand keine Zeile; sie hier zu erfinden hiesse,
        Umfang zu erfinden. Der Wunsch wird vermerkt, die Zustellung wird
        nicht behauptet.
    """
    merkmal = request.cookies.get(KEKS_NAME)
    with verbindung() as conn:
        stand = sitzung_pruefen(conn, merkmal_lesen(merkmal))
        if stand is None:
            return _zurueck_auf_en01(merkmal)
        check, fehlweg = _vorbedingung(conn, stand)
        if fehlweg is not None:
            return fehlweg
        # OHNE `klasse`, und das ist Absicht: ein Terminwunsch ist ein
        # Betriebsvorgang, kein Nachweis der Zweckbestimmung. Er aendert
        # die Erklaerung nicht -- also traegt er auch nicht ihre Frist.
        _ereignis(conn, stand, check["id"], "TERMIN_ANGEFRAGT",
                  "Zweckbestimmung, Stand " + auswerten(check),
                  "Aenderung")

    return _umleitung("/zweckbestimmung?termin=1")
