# umsetzt: K04-M05, K04-M08, K04-M09, K04-M11, K04-M12, K04-M13,
#          K04-M14, K04-M16, K04-D03, K04-D05, K04-D08, K04-G04, K04-G06
# zur Haelfte umgesetzt: K04-M10 -- weil diese Datei den Mandanten beim
#          Anlegen schreibt und ihn seit dem 15.08.2026 in JEDER Bedingung
#          auf `fit_check` fuehrt, im Lesen wie im Schreiben; dass die Spalte
#          PFLICHT ist und die Loeschsperre auf `tenant` traegt, haelt allein
#          das Schema. Bis zum 15.08.2026 stand die Klausel hier als GANZ
#          umgesetzt und war es nicht: die beiden UPDATE auf `fit_check`
#          liefen auf "WHERE id = %s" ohne Mandant (Gegenprobe vom 15.08.2026)
# zur Haelfte umgesetzt: K13-M05 -- weil jeder Weg dieser Datei ueber den
#          Serverpfad laeuft und dieser aktives Konto, Portalmitgliedschaft,
#          Mandant, Objektbezug UND den Ergebniszustand prueft, bevor er
#          liest oder schreibt; eine ROLLENpruefung besteht nicht, weil K04
#          fuer den Eignungs-Check keine Rolle fuehrt. Die Luecke ist
#          benannt, nicht geschlossen
# zur Haelfte umgesetzt: K04-M04 -- weil die drei Fragen der Startbestand
#          anlegt (seeds/Seed_Vorpruefung_K04.sql) und diese Datei allein
#          nachprueft, dass genau drei bestehen, und sonst sperrt
# zur Haelfte umgesetzt: K04-M06 -- weil der Bildschirm ausschliesslich
#          Antwortmoeglichkeiten aus fit_option anbietet und kein Freitextfeld
#          fuehrt; die Pflicht der drei Spalten selbst traegt das Schema
# zur Haelfte umgesetzt: K04-M15 -- weil die Rueckname gebaut ist, das
#          "und legt eine neue an" aber nicht traegt, wenn dieselbe
#          Antwortmoeglichkeit ein zweites Mal gewaehlt wird (siehe
#          "DIE GRENZE DES PRIMAERSCHLUESSELS" weiter unten)
# zur Haelfte umgesetzt: K04-D04 -- weil in dieser Scheibe weder eine
#          Anwendung noch eine Angebotsanfrage gebaut ist: der Satz wird hier
#          nicht verletzt, getragen wird er erst mit M4
# zur Haelfte umgesetzt: K19-M06 -- weil der Hinweis auf die fehlende Frage
#          seit dem 15.08.2026 ihren FRAGETEXT nennt (`fehlende_fragen`) und
#          an der Stelle der Schaltflaeche steht, die Schaltflaeche [Weiter]
#          selbst aber NICHT ausgeblendet wird. Die Klausel verlangt beides.
#          Begruendung der Abweichung im Kopf von app/vorlagen/en04_eignung.html,
#          Abschnitt "WO DER HINWEIS STEHT". Bis zum 15.08.2026 stand hier
#          "Bitte beantworten Sie alle drei Fragen" und darueber der Kommentar,
#          die Meldung sage, was fehlt -- sie sagte es nicht (Nachbesserung
#          vom 15.08.2026)
"""FREIRAUM · Scheibe 2 · die Vorpruefung bis zum Halt und die drei Auswege.

Drei Bildschirme aus dem Vertrag `schema/K19_screens.yaml`, uebernommen und
nicht frei gezeichnet (K04-G10):

    EN-02  Uebersicht    -- hier in der Minimalform: eine einzige Aktion
    EN-03  Vorpruefung 1 -- zwei Wege: Check starten und Ueberspringen
    EN-04  Eignungs-Check -- drei Fragen, Halt, drei Auswege

Der Vertrag dieser Scheibe -- er ist zugleich das, was die Pruefung misst:

    GET  /uebersicht              EN-02. Ohne gueltige Sitzung -> 303 auf
                                  "/anmeldung". Sonst 200 mit der Schaltflaeche
                                  "Neue Anwendung erstellen"; ein bestehender
                                  Eignungs-Check dieses Kontos wird mit seinem
                                  Ergebnis angezeigt. AENDERT NICHTS
    POST /uebersicht/neu          Erfolg -> 303 auf "/vorpruefung". Legt weder
                                  eine Anwendung noch einen Eignungs-Check an
    GET  /vorpruefung             EN-03. 200 mit zwei Schaltflaechen
    POST /vorpruefung/starten     200, Verbleib auf EN-03 mit der benannten
                                  Meldung zum ungezeichneten Wortlaut. Legt
                                  nichts an
    POST /vorpruefung/ueberspringen  Erfolg -> 303 auf "/eignung". Legt EINEN
                                  fit_check an: Mandant und Konto aus der
                                  Sitzung, outcome OFFEN, Aufbewahrungsklasse
                                  KI_NACHWEIS
    GET  /eignung                 EN-04. 200: die drei Fragen in Reihenfolge
                                  der Spalte `position`, je Frage ihre
                                  Antwortmoeglichkeiten, die aktive Antwort
                                  markiert. Bei NICHT_GEEIGNET das Halt-Feld
                                  an Stelle des Weiterwegs, begruendet, mit den
                                  drei Auswegen. Ohne offenen Check -> 303 auf
                                  "/vorpruefung"
    POST /eignung/antwort         Felder `frage` und `option`. Erfolg -> 303 auf
                                  "/eignung". Eine bestehende aktive Antwort
                                  derselben Frage wird ZURUECKGENOMMEN, nie
                                  geloescht. IM HALT gesperrt: 200 mit
                                  benannter Meldung, nichts geaendert
    POST /eignung/aendern         Feld `frage`. Nimmt die aktive Antwort
                                  zurueck, ohne eine neue zu setzen, und setzt
                                  das Ergebnis auf OFFEN zurueck. Auch im Halt
                                  -- er ist einer der drei Auswege
    POST /eignung/weiter          Wertet aus. GEEIGNET nur bei drei aktiven
                                  Antworten, die alle `is_eligible` tragen.
                                  Fehlt eine Antwort: 200, es wird NICHTS
                                  geschrieben, und der Bildschirm zeigt im
                                  Block `hinweis` den FRAGETEXT jeder noch
                                  offenen Frage. IM HALT gesperrt: 200 mit
                                  benannter Meldung, nichts geaendert
    POST /eignung/termin          Legt eine Zeile in `event` an und leitet auf
                                  "/eignung?termin=1". AENDERT DAS ERGEBNIS NICHT

WAS HIER AUSDRUECKLICH NICHT GEBAUT IST

  * EN-03a, der Direkt-Prototyp-Check. K04-M22 verlangt genau fuenf Fragen zu
    je drei Antwortmoeglichkeiten. Der WORTLAUT dieser fuenf Fragen ist
    nirgends gezeichnet; die Sammelmigration M30 haelt das selbst fest ("werden
    als Seed nachgereicht, sobald H09/Punkt 13 den Wortlaut zeichnet"). Ihn zu
    erfinden waere Umfang, den niemand gezeichnet hat. Deshalb fuehrt
    "Check starten" auf die benannte Meldung und bleibt auf EN-03 -- genau der
    Fehlerzustand, den der Bildschirmvertrag dafuer vorsieht.
  * EN-04a, die Zweckbestimmung nach K04-M19 bis M21. Sie ist seit M4 gebaut
    (app/zweckbestimmung.py). Nach GEEIGNET steht auf EN-04 deshalb seit dem
    16.08.2026 ein VERWEIS dorthin, wie ihn K19 fuer den Erfolgsfall zeichnet
    -- ein Link und kein Formular, damit EN-04 keinen vierten Weg bekommt.
    Diese Datei baut EN-04a nicht und weiss von ihrem Inhalt nichts; sie kennt
    nur die Adresse.
  * Die uebrigen sechs Aktionen von EN-02 (Erklaervideo, Termin, Nachricht,
    Fortfuehren, Ansehen). Sie gehoeren zu K01 und zu spaeteren Scheiben.

DER MANDANT IST DIE ERSTE FRAGE, NICHT DIE LETZTE (K04-D08, K04-M10). Jede
Abfrage dieser Datei auf `fit_check` fuehrt `tenant_id = Mandant der Sitzung`
in ihrer eigenen Bedingung -- im Lesen und, seit dem 15.08.2026, auch in den
beiden UPDATE. Ein Check eines fremden Mandanten wird nicht "gefunden und dann
abgelehnt" -- er wird gar nicht erst gelesen. Das ist der Unterschied zwischen
"gilt als nicht vorhanden" und "wird verweigert": das eine verraet nichts, das
andere bestaetigt die Existenz.

WORAUF DIESER SATZ SICH NICHT ERSTRECKT, weil es sonst eine Behauptung waere:
`fit_question` und `fit_option` tragen ueberhaupt keinen Mandanten -- die drei
Fragen und ihre Antwortmoeglichkeiten gelten fuer alle. `fit_answer` traegt
ebenfalls keinen; sie haengt ueber `fit_check_id` an einem Check, der zuvor MIT
Mandant gelesen wurde. Die Kette traegt, aber sie traegt ueber den Check, nicht
ueber eine eigene Spalte.

WAS DER SERVER ENTSCHEIDET, ENTSCHEIDET NICHT DER BROWSER (K13-M05, K04-M08).
Bei NICHT_GEEIGNET zeigt EN-04 keine Antwortformulare und keine Schaltflaeche
[Weiter] -- aber ein Bildschirm, der etwas nicht anbietet, verbietet es nicht.
Ein von Hand gesendetes Formular erreicht denselben Weg. Deshalb fragen
POST /eignung/antwort und POST /eignung/weiter den Ergebniszustand ab, BEVOR
sie lesen oder schreiben, und weisen im Halt mit einer benannten Meldung ab.
Sonst waere ein solches Formular ein VIERTER Weg aus dem Halt heraus, und
K04-M08 verlangt genau drei. Befund der Gegenprobe vom 15.08.2026.

DIE DREI AUSWEGE, UND ES SIND DIE DREI DES BILDSCHIRMS: /eignung/aendern,
/eignung/termin und der Weg zurueck auf /uebersicht. "Antwort aendern" bleibt
im Halt ausdruecklich offen -- er ist der Ausweg, der das Ergebnis auf OFFEN
zuruecksetzt; danach sind Antworten wieder erlaubt. Ein Ausweg, der selbst
gesperrt waere, waere keiner.

ZWEI BENANNTE ORTE AUF EN-04, seit dem Nachtrag des Plans vom 15.08.2026:
`<div id="halt">` traegt die Begruendung des Halts mit dem Wortlaut der
aufhaltenden Antwort und die drei Auswege; `<div id="hinweis">` traegt den
Hinweis auf die noch fehlende Frage mit ihrem Fragetext. Beide Bausaetze
entstehen hier -- `aufhaltende_antworten` und `fehlende_fragen` -- und beide
geben ausschliesslich das heraus, worauf es ankommt: die aufhaltende Antwort,
nicht die durchlassende; die offene Frage, nicht die beantwortete. Der
Bildschirm kann deshalb gar nichts vermengen, was hier getrennt ist. Vor dem
Nachtrag hatte der Begruendungsbereich keinen Namen; ein Prueffall konnte ihn
nicht abgrenzen und blieb auf GESPERRT -- ein Fall, der nur sperren kann,
misst nichts.

FAIL-CLOSED HEISST HIER: WER NICHT ZAEHLEN KANN, SPERRT (K04-G04). Stehen
nicht genau drei Fragen im Bestand, wird der Eignungs-Check gar nicht erst
angeboten. Ein Bildschirm mit zwei Fragen saehe vollstaendig aus und waere es
nicht; er koennte GEEIGNET ergeben, ohne die dritte Frage je gestellt zu haben.
"""
import logging
import uuid
from pathlib import Path

import psycopg
from fastapi import APIRouter, Form, Request
from fastapi.responses import HTMLResponse, RedirectResponse
from fastapi.templating import Jinja2Templates

from app.datenbank import verbindung
# Nur die beiden Lesehilfen, damit dieser Weg VOR dem Schreiben pruefen
# kann, ob der Startbestand traegt. app/schnellweg.py bindet diese Datei
# nicht ein -- es gibt also keinen Ringschluss.
from app.schnellweg import fragen_lesen as schnellweg_fragen_lesen
from app.schnellweg import fragen_tragen as schnellweg_fragen_tragen
from app.sitzung import KEKS_NAME, keks_loeschen, merkmal_lesen, sitzung_pruefen

PROTOKOLL = logging.getLogger(__name__)

# Gegen __file__, nicht gegen das Arbeitsverzeichnis -- dieselbe Begruendung
# wie in app/haupt.py: der Server soll aus jedem Verzeichnis startbar sein,
# ohne seine Vorlagen zu verlieren.
VORLAGEN = Jinja2Templates(directory=str(Path(__file__).parent / "vorlagen"))

router = APIRouter()

# 303 und nicht 302, aus demselben Grund wie in app/haupt.py: nach einem POST
# muss der Browser auf GET wechseln. Sonst legt ein Neuladen dieselbe Antwort
# ein zweites Mal vor -- und beim Ueberspringen einen zweiten Eignungs-Check.
UMLEITUNG = 303

# Genau drei Fragen, je eine je Dimension (K04-M04, K04-D02). Die Zahl steht
# hier als Konstante und nicht als "3" in vier Abfragen: vier Stellen laufen
# auseinander, eine nicht.
ANZAHL_FRAGEN = 3

# Der Halt. Er steht in `fit_check.outcome` und nirgends sonst -- K04-D05
# verbietet einen zweiten Eignungsstrang, und ein Kennzeichen "ist_im_halt"
# waere genau das.
HALT = "NICHT_GEEIGNET"

# Welche Ergebniszustaende einen SCHREIBENDEN Weg ueberhaupt zulassen.
# Aufgezaehlt und nicht als "!= HALT" geschrieben: fail-closed heisst, dass
# ein Wert, den niemand vorgesehen hat, sperrt statt durchzulassen (K04-G04).
# `fit_outcome` fuehrt heute drei Werte (K04-M11); kaeme je ein vierter hinzu,
# waere er hier gesperrt, bis jemand ihn ausdruecklich eintraegt.
ERGEBNIS_SCHREIBEND_ZULAESSIG = ("OFFEN", "GEEIGNET")

# --- Die Meldungen. Jede einzeln benannt, jede fuer einen Menschen ohne
# --- IT-Kenntnisse lesbar (CONTRIBUTING.md). Umlaute werden wie im ganzen
# --- Bestand umschrieben; der Wortlaut ist im Uebrigen der des Plans.

# Der Fehlerzustand, den schema/K19_screens.yaml fuer EN-03/check_starten
# vorsieht: "Fragenfluss nicht ladbar -- Meldung, Verbleib auf EN-03;
# [Ueberspringen] bleibt offen, es entsteht kein Vorschlag."
# Bis zum 23.08.2026 stand hier eine Meldung, der Wortlaut der fuenf Fragen
# sei "nicht gezeichnet (H09/Punkt 13)". Das war seit dem 01.08.2026 falsch:
# K04 v1.7 Abschn. 5.0 fuehrt ihn vollstaendig und schliesst O-K04-1.
# Siehe arbeit/Bauberichte/BEF-K04-1_Wortlaut_ist_gezeichnet.md.
# Die Meldung bleibt als FEHLERZUSTAND stehen -- der Bildschirmvertrag
# sieht ihn ausdruecklich vor ("Fragenfluss nicht ladbar"). Sie erscheint
# jetzt nur noch, wenn der Startbestand fehlt, nicht mehr als Regelfall.
MELDUNG_VORPRUEFUNG_1 = (
    "Die Fragen der ersten Vorprüfung stehen gerade nicht bereit. Sie "
    "können diesen Schritt überspringen und mit dem Eignungs-Check "
    "fortfahren.")

# K04-G04, fail-closed: fehlt eine Antwort, bleibt das Ergebnis OFFEN.
#
# DIESE BEIDEN SAETZE SIND NUR DER ANFANG DES HINWEISES. Was tatsaechlich
# fehlt, steht nicht hier, sondern kommt aus `fehlende_fragen` -- der
# FRAGETEXT jeder unbeantworteten Frage, im Wortlaut. Der Bildschirmvertrag
# verlangt fuer EN-04/antwort_waehlen, zustand_leer, woertlich: "Hinweis nennt
# die fehlende Frage" (K19-M06).
#
# BIS ZUM 15.08.2026 STAND HIER "Bitte beantworten Sie alle drei Fragen" --
# und darueber der Kommentar, die Meldung sage, WAS fehlt. Das war schlicht
# unwahr: der Satz nannte keine einzige Frage, er nannte ihre Anzahl. Der
# Kommentar behauptete damit eine erfuellte Klausel, die nicht erfuellt war --
# und eine unwahre Selbstauskunft ist schlimmer als eine offene Luecke, weil
# sie das Nachsehen verhindert. Beides ist berichtigt: der Satz und die
# Behauptung darueber.
#
# Zwei Saetze und nicht einer mit Klammerform ("Frage(n)"): ein Mensch ohne
# IT-Kenntnisse liest keine Klammern, er liest einen Satz (CONTRIBUTING.md).
HINWEIS_FEHLT_EINE = (
    "Es fehlt noch eine Antwort. Sie koennen weitergehen, sobald diese Frage "
    "beantwortet ist:")
HINWEIS_FEHLT_MEHRERE = (
    "Es fehlen noch Antworten. Sie koennen weitergehen, sobald diese Fragen "
    "beantwortet sind:")

# K04-G04, die andere Haelfte: was nicht gelesen werden kann, sperrt. Der Satz
# nennt ausdruecklich, dass es nicht an den Angaben des Nutzers liegt --
# dieselbe Ueberlegung wie bei MELDUNG_BETRIEB in app/haupt.py. Wer glaubt,
# er habe etwas falsch gemacht, versucht es dreimal neu.
MELDUNG_FRAGEN_FEHLEN = (
    "Der Eignungs-Check ist zurzeit nicht bedienbar, weil die drei Fragen "
    "nicht vollstaendig vorliegen. Das liegt nicht an Ihren Angaben. Bitte "
    "wenden Sie sich an Ihre Ansprechperson.")

# Eine Antwortmoeglichkeit, die es nicht gibt oder die zu einer anderen Frage
# gehoert. Fail-closed: es wird nichts gespeichert, und der Satz sagt das.
MELDUNG_AUSWAHL_UNGUELTIG = (
    "Diese Antwortmoeglichkeit gehoert nicht zu dieser Frage. Es wurde nichts "
    "gespeichert; bitte waehlen Sie erneut.")

# Ausweg 2 nach dem Halt. Die Quittung nach der Umleitung -- sie sagt, was
# geschehen ist, und verspricht nichts, was diese Scheibe nicht haelt.
#
# BERICHTIGT AM 20.08.2026, nach dem Tor-3-Urteil vom selben Tag (Grund 9).
# Hier stand: "Ihr Wunsch nach einem Gespraech ist vermerkt. Ihre
# Ansprechperson meldet sich bei Ihnen." Der zweite Satz war eine Zusage,
# die dieser Bau NICHT einloest -- und das steht im selben Modul, im
# Serverpfad des Terminwegs: "DIE ANSPRECHPERSON WIRD NICHT AUFGELOEST ...
# der Wunsch wird vermerkt, die Zustellung an die Ansprechperson ist ein
# offener Punkt und wird NICHT BEHAUPTET." Der Kommentar sagte das eine,
# die Meldung das andere; gelesen hat die Nutzerin die Meldung.
#
# Der Satz oben -- "verspricht nichts, was diese Scheibe nicht haelt" --
# war damit selbst unwahr. Er steht jetzt zu Recht dort.
MELDUNG_TERMIN = (
    "Ihr Wunsch nach einem Gespraech ist vermerkt. Wann und wie er "
    "aufgenommen wird, ist noch nicht festgelegt.")

# Der Halt, serverseitig. K04-M08 laesst genau drei Auswege zu; "noch eine
# Antwort speichern" ist keiner davon. Die Meldung nennt die drei, die es
# gibt -- wer nur "nicht moeglich" liest, sucht den vierten Weg weiter.
MELDUNG_HALT_ANTWORT = (
    "Dieser Eignungs-Check ist angehalten. Solange er das ist, laesst sich "
    "keine Antwort speichern; es wurde nichts geaendert. Sie haben genau drei "
    "Moeglichkeiten: eine Antwort aendern, ein Gespraech mit Ihrer "
    "Ansprechperson vereinbaren oder zur Uebersicht zurueckkehren.")

# Dasselbe fuer den Weiterweg. Eigener Satz und nicht derselbe: "speichern"
# und "auswerten" sind zwei verschiedene Dinge, und der Nutzer soll erfahren,
# was er gerade versucht hat.
MELDUNG_HALT_WEITER = (
    "Dieser Eignungs-Check ist angehalten. Er laesst sich nicht noch einmal "
    "auswerten; es wurde nichts geaendert. Sie haben genau drei "
    "Moeglichkeiten: eine Antwort aendern, ein Gespraech mit Ihrer "
    "Ansprechperson vereinbaren oder zur Uebersicht zurueckkehren.")

# Fail-closed fuer den Fall, den es nach K04-M11 nicht geben duerfte: ein
# Ergebniswert, den diese Datei nicht kennt, oder eine Zeile, die zwischen
# Lesen und Schreiben nicht mehr getroffen wird. Der Satz sagt ausdruecklich,
# dass es nicht an den Angaben des Nutzers liegt -- dieselbe Ueberlegung wie
# bei MELDUNG_FRAGEN_FEHLEN.
MELDUNG_ERGEBNIS_UNKLAR = (
    "Der Stand dieses Eignungs-Checks laesst sich zurzeit nicht sicher lesen. "
    "Aus Vorsicht wurde nichts geaendert. Das liegt nicht an Ihren Angaben. "
    "Bitte wenden Sie sich an Ihre Ansprechperson.")

# HINWEIS NACH VORN, heute unerreichbar. M30 fuehrt auf `fit_check` die
# Bedingung `ack_nach_eignung`: zweckbestimmung_ack_at IS NULL ODER
# outcome = 'GEEIGNET'. Sobald M4 die Kenntnisnahme schreibt (K04-M19 bis
# M21), laeuft jedes Zuruecksetzen auf OFFEN und jedes NICHT_GEEIGNET in
# genau diese Bedingung. Ohne diesen Satz waere das ein Absturz ohne Grund;
# mit ihm ist es eine Meldung. Was danach GESCHEHEN soll -- ob die
# Kenntnisnahme mit der Antwort zurueckgenommen wird oder nicht -- entscheidet
# diese Datei nicht: das ist eine Entscheidung fuer M4 (offener Punkt).
MELDUNG_ACK_BESTEHT = (
    "Sie haben die Zweckbestimmung zu diesem Vorhaben bereits bestaetigt. "
    "Deshalb laesst sich das Ergebnis hier nicht mehr zuruecksetzen; es wurde "
    "nichts geaendert. Bitte wenden Sie sich an Ihre Ansprechperson.")

# Nach GEEIGNET. Der Bildschirmvertrag zeichnet fuer EN-04
# `zustand_erfolg: "GEEIGNET -> EN-04a (Zweckbestimmung)"`
# (schema/K19_screens.yaml:200). Seit M4 ist EN-04a gebaut; der Satz "Dieser
# Schritt ist noch nicht freigeschaltet." aus M3 ist damit ueberholt und
# wird hier durch den Verweis ersetzt, den der Vertrag verlangt.
#
# EIN VERWEIS, KEIN FORMULAR -- und das ist der ganze Unterschied. EN-04
# fuehrt drei Wege aus dem Halt und die Wege des Erfolgs; ein viertes
# Formular waere ein vierter Weg (K04-M08, K19-M14). Ein Link schreibt
# nichts, aendert nichts und nimmt nichts entgegen: er zeigt nur, wohin es
# weitergeht. Deshalb bleibt EN-04 im Uebrigen unangetastet.
#
# Er erscheint unter derselben Bedingung wie der Hinweis heute: nur bei
# `ergebnis == "GEEIGNET"`. Vor der Zeit gezeigt waere er eine Zusage, die
# der Check nicht deckt.
HINWEIS_GEEIGNET = (
    "Ihr Vorhaben ist geeignet. Als naechstes folgt die Zweckbestimmung -- die "
    "beiden Fragen dazu, ob die Anwendung Menschen bewertet oder auswaehlt.")

# Ziel und Beschriftung getrennt vom Satz, damit die Vorlage einen Link
# bauen kann, ohne dass Auszeichnung in einer Textkonstante steht. Eine
# Konstante mit HTML darin muesste in der Vorlage ungeprueft durchgereicht
# werden -- das ist der Weg, auf dem Einschleusung entsteht.
VERWEIS_GEEIGNET_ZIEL = "/zweckbestimmung"
VERWEIS_GEEIGNET_TEXT = "Weiter zur Zweckbestimmung"


def _zurueck_auf_en01(merkmal):
    """Ohne gueltige Sitzung fuehrt kein Weg weiter -- K03-D01, kein Teil-Zugang.

    Wortgleich zu `_zurueck_auf_en01` in app/haupt.py und bewusst nicht von
    dort eingebunden: app/haupt.py bindet diese Datei ein, der umgekehrte Weg
    waere ein Ringschluss beim Import. Wandert die Regel spaeter in eine
    gemeinsame Datei, wandern beide Ausfertigungen zusammen.
    """
    antwort = RedirectResponse("/anmeldung", status_code=UMLEITUNG)
    if merkmal:
        # Das Merkmal zeigt auf nichts Gueltiges mehr. Es stehen zu lassen
        # hiesse, dem Browser zu suggerieren, er sei angemeldet.
        keks_loeschen(antwort)
    antwort.headers["Cache-Control"] = "no-store"
    return antwort


def _seite(request, vorlage, inhalt, status=200):
    antwort = VORLAGEN.TemplateResponse(request, vorlage, inhalt,
                                        status_code=status)
    # Jede dieser Seiten nennt den angemeldeten Namen und den Stand eines
    # Eignungs-Checks. In einem Zwischenspeicher hat beides nichts verloren
    # (K03-M26, datensparsam).
    antwort.headers["Cache-Control"] = "no-store"
    return antwort


def _umleitung(ziel):
    antwort = RedirectResponse(ziel, status_code=UMLEITUNG)
    antwort.headers["Cache-Control"] = "no-store"
    return antwort


# ---------------------------------------------------------------------------
#  Lesen: Fragen, Antwortmoeglichkeiten, Check, Antworten
# ---------------------------------------------------------------------------


def fragen_lesen(conn):
    """Die drei Fragen mit ihren Antwortmoeglichkeiten, in fester Reihenfolge.

    K04-M05: die Reihenfolge steht in `fit_question.position` und
    `fit_option.position` -- nicht im Programmtext und nicht in der Vorlage.
    Wer sie im Bildschirm sortierte, haette zwei Wahrheiten, sobald der
    Startbestand sich aendert.

    Rueckgabe: Liste von Fragen. Steht nicht genau eine Frage je Dimension im
    Bestand, gibt diese Funktion trotzdem zurueck, was sie findet -- gezaehlt
    und entschieden wird eine Ebene hoeher (`fragen_tragen`). Eine Lesefunktion,
    die selbst sperrt, versteckt den Grund vor dem Aufrufer.
    """
    fragen = []
    nach_code = {}
    for code, dimension, position, prompt in conn.execute(
            "SELECT code, dimension::text, position, prompt_de"
            "  FROM fit_question ORDER BY position").fetchall():
        frage = {"code": code, "dimension": dimension, "position": position,
                 "prompt": prompt, "optionen": [], "gewaehlt": None}
        fragen.append(frage)
        nach_code[code] = frage

    for kennung, frage_code, position, label, token, geeignet in conn.execute(
            "SELECT id, question_code, position, label_de, value_token,"
            "       is_eligible"
            "  FROM fit_option ORDER BY question_code, position").fetchall():
        frage = nach_code.get(frage_code)
        if frage is None:
            # Eine Antwortmoeglichkeit ohne Frage. Der Fremdschluessel
            # verhindert das; gefunden wird sie hier trotzdem nicht
            # stillschweigend uebergangen, sondern ausgelassen und gemeldet.
            PROTOKOLL.error("Antwortmoeglichkeit ohne Frage im Bestand: %s",
                            frage_code)
            continue
        frage["optionen"].append({
            "id": str(kennung), "position": position, "label": label,
            "token": token, "geeignet": geeignet})
    return fragen


def fragen_tragen(fragen):
    """Traegt der Bestand genau drei Fragen, je eine je Dimension?

    K04-M04 und K04-D02 verlangen genau drei, je eine je Dimension ART,
    NUTZUNG und DATEN. Das Schema haelt das bereits ueber die Eindeutigkeit
    auf `dimension` und `position` -- aber es erzwingt nicht, dass ALLE DREI
    vorhanden sind. Eine leere Tabelle verletzt keine einzige Bedingung.

    Deshalb wird hier gezaehlt, und zwar vor jeder Anzeige und vor jeder
    Auswertung. Fehlt eine Frage, ist der Check nicht auswertbar, und was
    nicht auswertbar ist, sperrt (K04-G04).

    Eine Frage ohne Antwortmoeglichkeiten zaehlt ebenfalls nicht: sie liesse
    sich nicht beantworten, und "alle drei beantwortet" waere nie erreichbar.
    """
    if len(fragen) != ANZAHL_FRAGEN:
        return False
    if {f["dimension"] for f in fragen} != {"ART", "NUTZUNG", "DATEN"}:
        return False
    return all(f["optionen"] for f in fragen)


def check_lesen(conn, stand):
    """Der laufende Eignungs-Check dieses Kontos -- oder None.

    "Laufend" heisst: noch keiner Anwendung zugeordnet (`app_id` ist leer).
    Das ist ausdruecklich NICHT dasselbe wie "outcome = OFFEN": nach einem
    Halt traegt der Check NICHT_GEEIGNET und muss trotzdem angezeigt werden --
    sonst gaebe es die drei Auswege nicht, die K04-M08 verlangt. Und nach
    GEEIGNET traegt er das Ergebnis, bis der naechste Schritt ihn abholt
    (K04-G06: ein Check besteht auch ohne Anwendung).

    MANDANT UND KONTO STEHEN IN DER BEDINGUNG, nicht in einer Pruefung
    danach. Ein Check eines fremden Mandanten gilt als nicht vorhanden
    (K04-D08); er wird deshalb gar nicht erst gelesen.

    Der juengste zuerst: legt jemand das Ueberspringen zweimal vor, entstehen
    zwei Checks, und der zweite ist der, an dem er gerade arbeitet.
    """
    return conn.execute(
        "SELECT id, outcome::text, completed_at IS NOT NULL AS abgeschlossen,"
        "       retention_class::text"
        "  FROM fit_check"
        " WHERE tenant_id = %s AND actor_id = %s AND app_id IS NULL"
        " ORDER BY started_at DESC, id DESC LIMIT 1",
        (stand["mandant"], stand["actor_id"])).fetchone()


def antworten_eintragen(conn, check_id, fragen):
    """Traegt in jede Frage ihre aktive Antwort ein -- oder laesst sie leer.

    Aktiv heisst: `superseded_at` ist leer. Zurueckgenommene Antworten bleiben
    stehen (K04-D03), sie werden hier nur nicht angezeigt. Dass es je Frage
    hoechstens eine geben kann, haelt der Teilindex `fit_answer_aktiv_uq`
    (K04-M14) -- diese Abfrage verlaesst sich nicht darauf, sondern ordnet
    schlicht zu, was sie findet.
    """
    aktiv = dict(conn.execute(
        "SELECT question_code, option_id::text FROM fit_answer"
        " WHERE fit_check_id = %s AND superseded_at IS NULL",
        (check_id,)).fetchall())
    for frage in fragen:
        frage["gewaehlt"] = aktiv.get(frage["code"])
    return sum(1 for f in fragen if f["gewaehlt"])


def aufhaltende_antworten(fragen):
    """Welche Antwort haelt den Nutzer auf? -- K04-M09.

    Der Halt wird begruendet angezeigt, und die Begruendung ist keine
    allgemeine Floskel, sondern der WORTLAUT der Antwort, die aufhaelt. Es
    koennen mehrere sein; dann werden alle genannt. Wer nur eine erfuehre,
    aenderte sie und liefe in denselben Halt.
    """
    aufhaltend = []
    for frage in fragen:
        for option in frage["optionen"]:
            if option["id"] == frage["gewaehlt"] and not option["geeignet"]:
                aufhaltend.append({"code": frage["code"],
                                   "frage": frage["prompt"],
                                   "antwort": option["label"]})
    return aufhaltend


def fehlende_fragen(fragen):
    """Welche Frage ist noch offen? -- K19-M06, EN-04/antwort_waehlen.

    Rueckgabe: der Hinweis als fertiger Bausatz fuer den Bildschirm -- ein
    einleitender Satz und die Liste der noch offenen Fragen mit ihrer
    Anzeigenummer und ihrem FRAGETEXT. Ist alles beantwortet, kommt None
    zurueck; dann hat der Bildschirm nichts zu zeigen.

    DER FRAGETEXT UND NICHT DER CODE. `fit_question.code` fuehrt "art",
    "nutzung", "daten" -- das sind interne Werte, und dem Nutzer sagen sie
    nichts. Der Bildschirmvertrag verlangt, dass der Hinweis "die fehlende
    Frage" nennt; genannt ist eine Frage erst, wenn man sie wiedererkennt.

    UND AUSSCHLIESSLICH DIE OFFENEN. Der Fragetext einer bereits
    beantworteten Frage kommt hier gar nicht erst heraus -- der Bildschirm
    kann ihn deshalb auch nicht versehentlich mit anzeigen. Stuende er darin,
    suchte der Nutzer eine Luecke, die es nicht gibt, und der Hinweis
    unterschiede nichts.

    Die Reihenfolge ist die des Bildschirms (`position`, K04-M05) -- sie kommt
    aus `fragen` und wird hier NICHT noch einmal sortiert. Zwei Sortierungen
    waeren zwei Wahrheiten.
    """
    offen = [{"position": f["position"], "prompt": f["prompt"]}
             for f in fragen if not f["gewaehlt"]]
    if not offen:
        return None
    satz = HINWEIS_FEHLT_EINE if len(offen) == 1 else HINWEIS_FEHLT_MEHRERE
    return {"satz": satz, "fragen": offen}


def sperre_im_halt(check, meldung_im_halt):
    """Darf dieser Weg den Check ueberhaupt anfassen? -- K04-M08, K13-M05.

    Rueckgabe: None, wenn der Weg offen ist; sonst die Meldung, mit der er
    abzuweisen ist. Es wird NICHTS geaendert und NICHTS gelesen, bevor diese
    Frage beantwortet ist -- K13-M05 verlangt die Pruefung ausdruecklich
    *bevor* der Serverpfad liest oder schreibt.

    Die Frage stellt sich fuer die beiden schreibenden Wege, die es aus dem
    Halt heraus nicht geben darf: "Antwort speichern" und "Weiter". Nicht fuer
    die drei Auswege -- sie sind genau die drei, die K04-M08 verlangt, und
    "Antwort aendern" muss im Halt sogar besonders zuverlaessig laufen: er ist
    der einzige, der das Ergebnis wieder auf OFFEN setzt.

    FAIL-CLOSED (K04-G04): abgewiesen wird nicht nur beim Halt, sondern bei
    jedem Ergebniswert, den diese Datei nicht ausdruecklich zulaesst. Ein
    unbekannter Wert ist kein Grund weiterzumachen, sondern einer anzuhalten.
    """
    ergebnis = check[1]
    if ergebnis == HALT:
        return meldung_im_halt
    if ergebnis not in ERGEBNIS_SCHREIBEND_ZULAESSIG:
        return MELDUNG_ERGEBNIS_UNKLAR
    return None


class _CheckNichtGetroffen(RuntimeError):
    """Ein UPDATE auf `fit_check` hat nicht genau eine Zeile getroffen.

    Eigene Klasse und nicht einfach eine Verzweigung: sie wird INNERHALB von
    `conn.transaction()` ausgeloest, damit das Auswerfen den ganzen Vorgang
    zurueckrollt. Eine Verzweigung koennte das nicht -- sie liesse die zuvor
    ausgefuehrte Anweisung stehen.
    """


def _ist_ack_sperre(fehler):
    """Ist das die Bedingung `ack_nach_eignung` aus M30 -- und keine andere?

    Der Name wird ausdruecklich geprueft. Eine Ausnahmebehandlung, die JEDE
    verletzte Bedingung in dieselbe Meldung uebersetzt, verschweigt den
    naechsten Fehler statt ihn zu zeigen; alles andere wird deshalb
    weitergereicht.
    """
    return getattr(fehler.diag, "constraint_name", None) == "ack_nach_eignung"


# ---------------------------------------------------------------------------
#  EN-02 · Uebersicht
# ---------------------------------------------------------------------------


@router.get("/uebersicht", response_class=HTMLResponse)
def uebersicht(request: Request):
    """EN-02 in der Minimalform. AENDERT NICHTS.

    Der Bildschirmvertrag fuehrt fuer EN-02 sieben Aktionen; gebaut ist genau
    eine, "Neue Anwendung erstellen". Die uebrigen sechs gehoeren zu K01 und zu
    spaeteren Scheiben -- sie hier anzudeuten hiesse, Wege zu zeigen, die es
    nicht gibt.

    DIESE SEITE IST ZUGLEICH AUSWEG 3 nach einem Halt (K04-M08). Sie zeigt den
    bestehenden Eignungs-Check mit seinem Ergebnis. Nichts wird dabei getilgt
    und nichts geaendert (K04-D03) -- der Aufruf liest, er schreibt nicht.
    """
    merkmal = request.cookies.get(KEKS_NAME)
    with verbindung() as conn:
        stand = sitzung_pruefen(conn, merkmal_lesen(merkmal))
        if stand is None:
            return _zurueck_auf_en01(merkmal)
        check = check_lesen(conn, stand)

    return _seite(request, "en02_uebersicht.html", {
        "anzeigename": stand["anzeigename"],
        "portal": stand["portal"],
        "check_besteht": check is not None,
        "ergebnis": check[1] if check else None,
    })


@router.post("/uebersicht/neu")
def uebersicht_neu(request: Request):
    """Der Einstieg in die Vorpruefung. LEGT NICHTS AN.

    Wortgleich aus dem Bildschirmvertrag, EN-02/neue_anwendung_erstellen:
    "es entsteht weder eine Zeile in app (K01-M27) noch eine in fit_check --
    der Eignungs-Check beginnt erst auf EN-04". Diese Route ist deshalb eine
    reine Umleitung mit Sitzungspruefung. Wer hier schon einen Check anlegte,
    haette nach zehn Klicks zehn angefangene Checks und keinen einzigen
    beantworteten.
    """
    merkmal = request.cookies.get(KEKS_NAME)
    with verbindung() as conn:
        stand = sitzung_pruefen(conn, merkmal_lesen(merkmal))
    if stand is None:
        return _zurueck_auf_en01(merkmal)
    return _umleitung("/vorpruefung")


# ---------------------------------------------------------------------------
#  EN-03 · Vorpruefung 1
# ---------------------------------------------------------------------------


def _en03(request, stand, meldung=None):
    return _seite(request, "en03_vorpruefung.html", {
        "anzeigename": stand["anzeigename"], "meldung": meldung})


@router.get("/vorpruefung", response_class=HTMLResponse)
def vorpruefung(request: Request):
    """EN-03, zwei Wege. AENDERT NICHTS."""
    merkmal = request.cookies.get(KEKS_NAME)
    with verbindung() as conn:
        stand = sitzung_pruefen(conn, merkmal_lesen(merkmal))
    if stand is None:
        return _zurueck_auf_en01(merkmal)
    return _en03(request, stand)


@router.post("/vorpruefung/starten", response_class=HTMLResponse)
def vorpruefung_starten(request: Request):
    """"Check starten" -- hier entsteht der Schnellweg (EN-03a).

    BIS ZUM 23.08.2026 FUEHRTE DIESER WEG AUF EINE MELDUNG. Die Begruendung
    lautete, der Wortlaut der fuenf Fragen sei nirgends gezeichnet. Sie war
    seit dem 01.08.2026 ueberholt: K04 v1.7 Abschn. 5.0 fuehrt Wortlaut,
    Antworten und Zuordnung vollstaendig, angenommen vom Founder, und
    schliesst damit O-K04-1. Der Bau hatte richtig gehandelt und sich auf
    eine falsche Aktenlage gestuetzt (BEF-K04-1).

    FAIL-CLOSED VOR DEM SCHREIBEN (K04-G04): stehen nicht genau fuenf Fragen
    zu je drei Antwortmoeglichkeiten im Bestand, entsteht kein Vorgang -- der
    Bildschirmvertrag fuehrt fuer diesen Fall "Verbleib auf EN-03;
    [Ueberspringen] bleibt offen, es entsteht kein Vorschlag".

    Der Vorgang traegt bei der Anlage Mandant und Konto aus der Sitzung. Die
    Aufbewahrungsklasse setzt das Schema (BETRIEBSPROTOKOLL) -- anders als
    beim Eignungs-Check, der KI_NACHWEIS traegt: ein Vorschlag ist kein
    Nachweis ueber ein KI-System.
    """
    merkmal = request.cookies.get(KEKS_NAME)
    with verbindung() as conn:
        stand = sitzung_pruefen(conn, merkmal_lesen(merkmal))
        if stand is None:
            return _zurueck_auf_en01(merkmal)

        if not schnellweg_fragen_tragen(schnellweg_fragen_lesen(conn)):
            PROTOKOLL.error(
                "Schnellweg nicht angelegt: der Bestand fuehrt nicht genau "
                "fuenf Fragen zu je drei Antwortmoeglichkeiten (K04-M22). "
                "Startbestand: seeds/Seed_Direkt_Prototyp_Check_K04.sql")
            return _en03(request, stand, meldung=MELDUNG_VORPRUEFUNG_1)

        conn.execute(
            "INSERT INTO quick_check (tenant_id, actor_id) VALUES (%s, %s)",
            (stand["mandant"], stand["actor_id"]))

    return _umleitung("/schnellweg")


@router.post("/vorpruefung/ueberspringen")
def vorpruefung_ueberspringen(request: Request):
    """"Ueberspringen" -- hier und nur hier entsteht ein Eignungs-Check.

    UEBERSPRUNGEN WIRD DER DIREKT-PROTOTYP-CHECK, NICHT DIE EIGNUNG (K04-D01).
    Dieser Weg fuehrt nicht an der Eignung vorbei, er fuehrt in sie hinein.

    Der Check traegt bei der Anlage:
      * `tenant_id` aus der Sitzung -- Pflicht (K04-M10). Er kommt aus
        derselben geprueften Zeile wie Konto und Portal; ein zweiter Zugriff
        waere eine zweite Wahrheit.
      * `actor_id` aus der Sitzung. Nullbar im Schema und beim Entfernen des
        Kontos geleert (K04-G07) -- der Nachweis ueberlebt das Konto.
      * `outcome = OFFEN` als Vorgabe (K04-M11). Ausdruecklich hingeschrieben
        und nicht der Spaltenvorgabe ueberlassen: eine Vorgabe ist ein Netz,
        kein Plan.
      * `retention_class = KI_NACHWEIS` (K04-M16). Ebenso ausdruecklich. K04
        nennt die Klasse, nie die Frist -- die rechnet die Sicht
        `retention_due` (K04-G09, Eigentuemer K15).
      * `app_id` bleibt LEER (K04-G06). Ein Check besteht ohne Anwendung.

    KEINE ANWENDUNG, KEIN ARBEITSDOKUMENT. Der Bildschirmvertrag sagt fuer
    diesen Weg: "EN-04 geoeffnet; es entsteht kein Vorschlag und kein
    Arbeitsdokument."
    """
    merkmal = request.cookies.get(KEKS_NAME)
    with verbindung() as conn:
        stand = sitzung_pruefen(conn, merkmal_lesen(merkmal))
        if stand is None:
            return _zurueck_auf_en01(merkmal)

        # Fail-closed VOR dem Schreiben (K04-G04): stehen nicht genau drei
        # Fragen im Bestand, entsteht auch kein Check. Sonst legte dieser Weg
        # eine Zeile an, die nie beantwortet werden kann -- ein angefangener
        # Vorgang ohne Weg zum Ende. Der Bildschirmvertrag fuehrt fuer den
        # Fehlerfall ausdruecklich "kein Vorgang angelegt".
        if not fragen_tragen(fragen_lesen(conn)):
            PROTOKOLL.error(
                "Eignungs-Check nicht angelegt: der Bestand fuehrt nicht "
                "genau drei Fragen je Dimension (K04-M04, K04-D02).")
            return _en03(request, stand, meldung=MELDUNG_FRAGEN_FEHLEN)

        conn.execute(
            "INSERT INTO fit_check (tenant_id, actor_id, outcome,"
            "                       retention_class)"
            " VALUES (%s, %s, 'OFFEN', 'KI_NACHWEIS')",
            (stand["mandant"], stand["actor_id"]))

    return _umleitung("/eignung")


# ---------------------------------------------------------------------------
#  EN-04 · Eignungs-Check: die drei Fragen, der Halt, die drei Auswege
# ---------------------------------------------------------------------------


def _en04(request, stand, check, fragen, meldung=None, hinweis=None):
    """Der Bildschirm. Er entscheidet nichts -- er zeigt, was gelesen wurde.

    Das Ergebnis kommt AUSSCHLIESSLICH aus `fit_check.outcome`. Es wird hier
    nicht noch einmal aus den Antworten gerechnet und nirgends gespiegelt
    (K04-D05: kein zweiter Eignungsstrang). Was der Bildschirm zeigt, kann
    deshalb nicht von dem abweichen, was die Datenbank fuehrt.

    ZWEI VERSCHIEDENE ANSAGEN, und sie werden nicht vermischt:

      `meldung`  die Statusansage oben im Kasten. Sie blickt ZURUECK auf einen
                 Vorgang, der abgeschlossen ist: die Quittung des Termin-Wegs,
                 eine ungueltige Auswahl, eine Abweisung im Halt.
      `hinweis`  der Hinweis auf die noch fehlende Frage. Er blickt NACH VORN
                 auf die Bedingung des naechsten Schritts und steht deshalb
                 unten an der Schaltflaeche [Weiter], nicht oben (K19-M06:
                 "an ihrer Stelle"). Sein Bausatz kommt aus `fehlende_fragen`.

    Beide zugleich zu setzen ist moeglich, kommt heute aber nicht vor -- der
    einzige Weg, der `hinweis` setzt, setzt keine `meldung`.
    """
    ergebnis = check[1]
    return _seite(request, "en04_eignung.html", {
        "anzeigename": stand["anzeigename"],
        "fragen": fragen,
        "ergebnis": ergebnis,
        "halt": ergebnis == "NICHT_GEEIGNET",
        "aufhaltend": aufhaltende_antworten(fragen),
        "hinweis_geeignet": HINWEIS_GEEIGNET if ergebnis == "GEEIGNET" else None,
        # Derselbe Schalter, damit Satz und Verweis nicht auseinanderlaufen
        # koennen: entweder beide oder keiner (K19, EN-04/zustand_erfolg).
        "verweis_geeignet": (
            {"ziel": VERWEIS_GEEIGNET_ZIEL, "text": VERWEIS_GEEIGNET_TEXT}
            if ergebnis == "GEEIGNET" else None),
        "meldung": meldung,
        "hinweis": hinweis,
    })


def _en04_zeigen(request, conn, stand, meldung=None):
    """Sitzung, Check und Fragen zusammentragen -- oder begruendet umleiten.

    Rueckgabe: die fertige Antwort. Diese eine Stelle traegt alle
    Vorbedingungen von EN-04, damit sie nicht in fuenf Routen je einmal
    stehen und dort auseinanderlaufen.
    """
    check = check_lesen(conn, stand)
    if check is None:
        # Kein laufender Check: der Weg beginnt auf EN-03. Bewusst eine
        # Umleitung und keine Meldung -- es ist kein Fehler, sondern ein
        # Nutzer, der einen Schritt uebersprungen hat.
        return _umleitung("/vorpruefung")

    fragen = fragen_lesen(conn)
    if not fragen_tragen(fragen):
        # Fail-closed (K04-G04). KEIN halber Bildschirm: ein Check, dessen
        # Fragen nicht vollstaendig vorliegen, ist nicht auswertbar. 503 und
        # nicht 200 -- der Betrieb soll das in seinem Protokoll sehen.
        PROTOKOLL.error("Eignungs-Check nicht bedienbar: der Bestand fuehrt "
                        "nicht genau drei Fragen je Dimension.")
        return _seite(request, "en03_vorpruefung.html", {
            "anzeigename": stand["anzeigename"],
            "meldung": MELDUNG_FRAGEN_FEHLEN}, status=503)

    antworten_eintragen(conn, check[0], fragen)
    return _en04(request, stand, check, fragen, meldung=meldung)


@router.get("/eignung", response_class=HTMLResponse)
def eignung(request: Request, termin: str = ""):
    """EN-04. AENDERT NICHTS.

    `termin` traegt keine Angabe zum Vorgang -- es ist die Quittung nach der
    Umleitung des Termin-Wegs und nichts weiter (dieselbe Bauart wie
    `gesendet` auf EX-10).
    """
    merkmal = request.cookies.get(KEKS_NAME)
    with verbindung() as conn:
        stand = sitzung_pruefen(conn, merkmal_lesen(merkmal))
        if stand is None:
            return _zurueck_auf_en01(merkmal)
        return _en04_zeigen(request, conn, stand,
                            meldung=MELDUNG_TERMIN if termin else None)


def _option_gehoert(conn, frage_code, option_id):
    """Gehoert diese Antwortmoeglichkeit zu dieser Frage?

    Fail-closed (K04-G04). Der Bildschirm liefert beides mit; geglaubt wird
    keines von beiden. Wer das Formular von Hand nachbaut, koennte sonst die
    Antwort einer anderen Frage unterschieben -- der Teilindex
    `fit_answer_aktiv_uq` haengt an `question_code`, nicht an der Option, und
    haette das nicht bemerkt.
    """
    try:
        kennung = uuid.UUID(str(option_id).strip())
    except ValueError:
        # Kein Wert, der ueberhaupt eine Kennung sein kann. Bewusst hier und
        # nicht in der Datenbank: eine ungueltige Zeichenkette loeste dort
        # einen Fehler aus, und ein Fehler ist keine Antwort.
        return None
    zeile = conn.execute(
        "SELECT id FROM fit_option WHERE id = %s AND question_code = %s",
        (kennung, frage_code)).fetchone()
    return zeile[0] if zeile else None


@router.post("/eignung/antwort", response_class=HTMLResponse)
def eignung_antwort(request: Request,
                    frage: str = Form(default=""),
                    option: str = Form(default="")):
    """Eine Antwort setzen -- und die bisherige zurueckziehen, nie loeschen.

    K04-M15 verlangt zweierlei: die bisherige Zeile traegt `superseded_at`,
    und eine neue entsteht. Beides in EINER Transaktion. Fiele die zweite
    Anweisung aus, stuende die Frage sonst ohne jede Antwort da -- der Nutzer
    haette eine Antwort verloren, die er nie zurueckgenommen hat.

    DIE GRENZE DES PRIMAERSCHLUESSELS, offen benannt: `fit_answer` hat den
    Schluessel (fit_check_id, question_code, option_id). Waehlt jemand
    A, dann B, dann WIEDER A, laesst sich A kein zweites Mal als eigene Zeile
    anlegen -- der Schluessel gibt es nicht her. Die vorhandene Zeile wird
    dann wieder aktiv gesetzt. Was dabei verloren geht, ist die Spur der
    ersten Ruecknahme von A; die ZEILE bleibt bestehen, es wird nichts
    entfernt (K04-D03 ist gewahrt). K04-M15 traegt diese Datei deshalb nur zur
    Haelfte, und das steht so in der Kopfzeile. Das Schema ist Rang 1 und wird
    benutzt, nicht geaendert -- die Aufloesung dieses Widerspruchs ist eine
    Entscheidung fuer einen Menschen, kein Handgriff hier.

    DAS ERGEBNIS WIRD HIER NICHT NEU BERECHNET. Der Vertrag legt die
    Auswertung auf den Weg "Weiter" und die Ruecksetzung auf den Weg
    "Antwort aendern". Diese Route entscheidet ueber die Eignung nichts.

    IM HALT IST DIESER WEG ZU. EN-04 zeigt bei NICHT_GEEIGNET keine
    Antwortformulare mehr -- aber der Bildschirm ist keine Sperre. Wer das
    Formular von Hand nachbaut, kaeme sonst an derselben Stelle heraus, und
    das waere ein VIERTER Weg aus dem Halt (K04-M08, K13-M05). Also wird der
    Ergebniszustand abgefragt, bevor gelesen oder geschrieben wird.

    200 UND NICHT 4xx, aus demselben Grund wie bei einer ungueltigen Auswahl:
    die Wegetabelle des Plans nennt 303 fuer den ERFOLG. Eine Abweisung ist
    kein Erfolg; sie bleibt auf EN-04 stehen und traegt eine benannte Meldung
    -- so, wie es diese Datei fuer jede andere Abweisung auch haelt.
    """
    merkmal = request.cookies.get(KEKS_NAME)
    with verbindung() as conn:
        stand = sitzung_pruefen(conn, merkmal_lesen(merkmal))
        if stand is None:
            return _zurueck_auf_en01(merkmal)

        check = check_lesen(conn, stand)
        if check is None:
            return _umleitung("/vorpruefung")

        sperre = sperre_im_halt(check, MELDUNG_HALT_ANTWORT)
        if sperre is not None:
            PROTOKOLL.warning(
                "Antwort abgewiesen: der Eignungs-Check traegt das Ergebnis "
                "%s. Es wurde nichts geaendert (K04-M08, K13-M05).", check[1])
            return _en04_zeigen(request, conn, stand, meldung=sperre)

        option_id = _option_gehoert(conn, frage.strip(), option)
        if option_id is None:
            # 200 mit benannter Meldung, nichts gespeichert. Der Bildschirm
            # bleibt bedienbar ("Antwort bleibt waehlbar, kein Datenverlust").
            return _en04_zeigen(request, conn, stand,
                                meldung=MELDUNG_AUSWAHL_UNGUELTIG)

        bisher = conn.execute(
            "SELECT option_id FROM fit_answer"
            " WHERE fit_check_id = %s AND question_code = %s"
            "   AND superseded_at IS NULL",
            (check[0], frage.strip())).fetchone()

        if bisher and bisher[0] == option_id:
            # Dieselbe Antwort noch einmal. Nichts zurueckzunehmen, nichts
            # anzulegen -- sonst traege der Nachweis eine Ruecknahme, die es
            # sachlich nie gab.
            return _umleitung("/eignung")

        with conn.transaction():
            # Zuerst die Ruecknahme, dann die neue Antwort. Die andere
            # Reihenfolge liefe in den Teilindex `fit_answer_aktiv_uq`: zwei
            # nicht zurueckgenommene Antworten auf dieselbe Frage gibt es
            # nicht (K04-M14). Der Index ist dabei das Netz, nicht der Plan.
            conn.execute(
                "UPDATE fit_answer SET superseded_at = now()"
                " WHERE fit_check_id = %s AND question_code = %s"
                "   AND superseded_at IS NULL",
                (check[0], frage.strip()))
            conn.execute(
                "INSERT INTO fit_answer (fit_check_id, question_code,"
                "                        option_id, answered_at)"
                " VALUES (%s, %s, %s, now())"
                " ON CONFLICT (fit_check_id, question_code, option_id)"
                " DO UPDATE SET answered_at = now(), superseded_at = NULL",
                (check[0], frage.strip(), option_id))

    return _umleitung("/eignung")


@router.post("/eignung/aendern")
def eignung_aendern(request: Request, frage: str = Form(default="")):
    """AUSWEG 1 nach dem Halt: Antwort aendern (K04-M08).

    Der Weg nimmt die aktive Antwort zurueck und setzt KEINE neue. Genau das
    misst die Nachrechnung dieses Meilensteins: die Ruecknahme ueber
    `superseded_at`. Die Zeile bleibt stehen -- entfernt wird nichts, nie
    (K04-D03). Die Ruecknahme ist ein Zeitstempel, kein Loeschen.

    UND DAS ERGEBNIS GEHT AUF OFFEN ZURUECK, `completed_at` auf leer. Ohne das
    waere der Ausweg keiner: der Check truege weiter NICHT_GEEIGNET, EN-04
    zeigte weiter das Halt-Feld an Stelle des Weiterwegs, und der Nutzer
    koennte seine geaenderte Antwort nie erneut auswerten lassen. Beides in
    EINER Anweisung -- die Bedingung `fit_done_needs_ts` verlangt, dass
    `completed_at` und ein Ergebnis ausser OFFEN zusammen auftreten (K04-M12);
    zwei getrennte Anweisungen liefen dazwischen in genau diese Bedingung.

    Dass der Check danach unvollstaendig ist, ist kein Mangel, sondern der
    Zweck: fail-closed heisst, ein unvollstaendiger Check laesst nichts durch
    (K04-G04).

    DIESER WEG BLEIBT IM HALT AUSDRUECKLICH OFFEN. Die beiden anderen
    schreibenden Wege sind dort zu; dieser nicht, denn er ist der erste der
    drei Auswege. Ein Ausweg, der selbst gesperrt waere, waere keiner -- der
    Halt haette dann zwei Auswege statt drei, und auch das verletzte K04-M08.

    DER MANDANT STEHT SEIT DEM 15.08.2026 AUCH IM UPDATE. Er stand bis dahin
    nur in der Bedingung des Lesens (`check_lesen`); geschrieben wurde ueber
    "WHERE id = %s". Das war kein Loch, das jemand haette nutzen koennen --
    die Kennung stammt aus derselben, mit Mandant gelesenen Zeile --, aber es
    war eine unbelegte Behauptung im Kopf dieser Datei. Jetzt traegt jede
    Bedingung auf `fit_check` den Mandanten (K04-M10, K04-D08). Trifft das
    UPDATE nicht genau eine Zeile, wird die Ruecknahme mit zurueckgerollt:
    eine Antwort zurueckzunehmen, ohne das Ergebnis zu oeffnen, hinterliesse
    einen Halt ohne Grund.
    """
    merkmal = request.cookies.get(KEKS_NAME)
    with verbindung() as conn:
        stand = sitzung_pruefen(conn, merkmal_lesen(merkmal))
        if stand is None:
            return _zurueck_auf_en01(merkmal)

        check = check_lesen(conn, stand)
        if check is None:
            return _umleitung("/vorpruefung")

        try:
            with conn.transaction():
                conn.execute(
                    "UPDATE fit_answer SET superseded_at = now()"
                    " WHERE fit_check_id = %s AND question_code = %s"
                    "   AND superseded_at IS NULL",
                    (check[0], frage.strip()))
                getroffen = conn.execute(
                    "UPDATE fit_check SET outcome = 'OFFEN',"
                    "                     completed_at = NULL"
                    " WHERE id = %s AND tenant_id = %s",
                    (check[0], stand["mandant"])).rowcount
                if getroffen != 1:
                    # Zwischen Lesen und Schreiben ist die Zeile weg oder
                    # traegt einen anderen Mandanten. Das Auswerfen rollt die
                    # Ruecknahme mit zurueck -- beides gehoert zusammen.
                    raise _CheckNichtGetroffen(getroffen)
        except _CheckNichtGetroffen as fehler:
            PROTOKOLL.error(
                "Antwort aendern abgebrochen: das UPDATE auf fit_check traf "
                "%s Zeilen statt einer. Nichts geaendert (K04-G04).", fehler)
            return _en04_zeigen(request, conn, stand,
                                meldung=MELDUNG_ERGEBNIS_UNKLAR)
        except psycopg.errors.CheckViolation as fehler:
            # HEUTE UNERREICHBAR, ab M4 der Regelfall: die Bedingung
            # `ack_nach_eignung` aus M30 laesst OFFEN nicht zu, sobald die
            # Kenntnisnahme geschrieben ist. Ohne diesen Zweig waere das ein
            # Absturz ohne Grund.
            if not _ist_ack_sperre(fehler):
                raise
            PROTOKOLL.error(
                "Antwort aendern abgewiesen: die Kenntnisnahme der "
                "Zweckbestimmung besteht bereits, die Bedingung "
                "ack_nach_eignung laesst OFFEN nicht zu (M30). Nichts "
                "geaendert.")
            return _en04_zeigen(request, conn, stand,
                                meldung=MELDUNG_ACK_BESTEHT)

    return _umleitung("/eignung")


@router.post("/eignung/weiter", response_class=HTMLResponse)
def eignung_weiter(request: Request):
    """Die Auswertung. Sie laeuft auf dem Server, immer (K04-M13).

    Der Bildschirm liefert kein Ergebnis mit, und es wuerde auch keines
    angenommen: gelesen werden die drei Fragen und die nicht zurueckgenommenen
    Antworten unmittelbar vor der Entscheidung.

    Drei Ausgaenge, und nur drei:

      GEEIGNET        zu ALLEN drei Fragen liegt genau eine nicht
                      zurueckgenommene Antwort vor, und JEDE traegt
                      `is_eligible` (K04-M13).
      NICHT_GEEIGNET  alle drei sind beantwortet, mindestens eine Antwort
                      traegt `is_eligible` = falsch. Das ist der HALT.
      OFFEN           es fehlt eine Antwort. Dann bleibt das Ergebnis, wie es
                      war, und der Nutzer bekommt die benannte Meldung
                      (K04-G04, fail-closed). Es wird NICHTS geschrieben --
                      ein "noch nicht fertig" ist kein Ergebnis.

    JEDES ERGEBNIS AUSSER OFFEN TRAEGT `completed_at`, gesetzt im SELBEN
    Schreibvorgang (K04-M12). Getrennt gesetzt, schluege die Bedingung
    `fit_done_needs_ts` zwischen den beiden Anweisungen zu -- und das zu
    Recht: ein abgeschlossener Check ohne Abschlusszeitpunkt ist ein Nachweis
    ohne Datum.

    K04-D04: bei NICHT_GEEIGNET entsteht KEINE Anwendung und KEINE
    Angebotsanfrage. Diese Route legt nichts dergleichen an -- in dieser
    Scheibe gibt es beides nicht.

    IM HALT IST DIESER WEG ZU. Nach NICHT_GEEIGNET gibt es auf EN-04 keine
    Schaltflaeche [Weiter] mehr -- aber der Bildschirm ist keine Sperre. Ein
    von Hand gesendetes Formular waere sonst ein VIERTER Weg aus dem Halt:
    er koennte ihn zwar nicht aufheben (die Antworten sind dieselben, das
    Ergebnis waere wieder NICHT_GEEIGNET), er schriebe aber einen neuen
    `completed_at` auf einen Nachweis, den niemand angefasst hat. Ein
    Nachweis, dessen Datum sich von aussen verschieben laesst, ist keiner
    (K04-M08, K04-M12, K13-M05).
    """
    merkmal = request.cookies.get(KEKS_NAME)
    with verbindung() as conn:
        stand = sitzung_pruefen(conn, merkmal_lesen(merkmal))
        if stand is None:
            return _zurueck_auf_en01(merkmal)

        check = check_lesen(conn, stand)
        if check is None:
            return _umleitung("/vorpruefung")

        sperre = sperre_im_halt(check, MELDUNG_HALT_WEITER)
        if sperre is not None:
            PROTOKOLL.warning(
                "Auswertung abgewiesen: der Eignungs-Check traegt das "
                "Ergebnis %s. Es wurde nichts geaendert (K04-M08, K13-M05).",
                check[1])
            return _en04_zeigen(request, conn, stand, meldung=sperre)

        fragen = fragen_lesen(conn)
        if not fragen_tragen(fragen):
            PROTOKOLL.error("Auswertung gesperrt: der Bestand fuehrt nicht "
                            "genau drei Fragen je Dimension.")
            return _seite(request, "en03_vorpruefung.html", {
                "anzeigename": stand["anzeigename"],
                "meldung": MELDUNG_FRAGEN_FEHLEN}, status=503)

        beantwortet = antworten_eintragen(conn, check[0], fragen)
        if beantwortet < ANZAHL_FRAGEN:
            # OFFEN bleibt OFFEN, und geschrieben wird nichts.
            #
            # DER HINWEIS NENNT DIE FEHLENDE FRAGE (K19-M06). Nicht "alle drei
            # Fragen", sondern die, die noch offen ist -- im Wortlaut. Und er
            # geht als `hinweis` und nicht als `meldung` hinaus: er gehoert
            # an die Stelle der Schaltflaeche [Weiter], deren Bedingung er
            # benennt, nicht an den oberen Rand des Kastens.
            return _en04(request, stand, check, fragen,
                         hinweis=fehlende_fragen(fragen))

        ergebnis = "GEEIGNET" if not aufhaltende_antworten(fragen) else HALT
        try:
            # Der Mandant steht seit dem 15.08.2026 auch hier in der
            # Bedingung -- dieselbe Begruendung wie bei "Antwort aendern"
            # (K04-M10, K04-D08).
            getroffen = conn.execute(
                "UPDATE fit_check SET outcome = %s, completed_at = now()"
                " WHERE id = %s AND tenant_id = %s",
                (ergebnis, check[0], stand["mandant"])).rowcount
        except psycopg.errors.CheckViolation as fehler:
            # Ebenfalls heute unerreichbar und ab M4 moeglich: traegt der
            # Check bereits die Kenntnisnahme, laesst `ack_nach_eignung`
            # nichts ausser GEEIGNET zu. Ohne diesen Zweig waere ein
            # nachtraeglich zu NICHT_GEEIGNET gewordener Check ein Absturz.
            if not _ist_ack_sperre(fehler):
                raise
            PROTOKOLL.error(
                "Auswertung abgewiesen: die Kenntnisnahme der Zweckbestimmung "
                "besteht bereits, die Bedingung ack_nach_eignung laesst %s "
                "nicht zu (M30). Nichts geaendert.", ergebnis)
            return _en04_zeigen(request, conn, stand,
                                meldung=MELDUNG_ACK_BESTEHT)

        if getroffen != 1:
            # Zwischen Lesen und Schreiben ist die Zeile weg oder traegt
            # einen anderen Mandanten. Autocommit: es wurde nichts
            # geschrieben, weil nichts getroffen wurde (K04-G04).
            PROTOKOLL.error(
                "Auswertung abgebrochen: das UPDATE auf fit_check traf %s "
                "Zeilen statt einer. Nichts geaendert (K04-G04).", getroffen)
            return _en04_zeigen(request, conn, stand,
                                meldung=MELDUNG_ERGEBNIS_UNKLAR)

    return _umleitung("/eignung")


@router.post("/eignung/termin")
def eignung_termin(request: Request):
    """AUSWEG 2 nach dem Halt: Gespraech mit der Ansprechperson (K04-M08).

    Was hier entsteht, ist EINE Zeile in `event` mit `action`
    'TERMIN_ANGEFRAGT' und dem Bezug auf den Check. Mehr nicht -- und das ist
    Absicht:

      * DAS ERGEBNIS BLEIBT UNVERAENDERT. Ein Terminwunsch ist keine Eignung.
        Wer den Halt durch einen Anruf aufheben koennte, haette keinen Halt.
      * ES ENTSTEHT KEINE ANWENDUNG UND KEINE ANGEBOTSANFRAGE (K04-D04).
      * DIE ANSPRECHPERSON WIRD NICHT AUFGELOEST. Der Bildschirmvertrag fuehrt
        sie aus `contact` des eigenen Mandanten (Eigentuemer K11). `contact`
        gehoert nicht zu dieser Scheibe und traegt im Pilotbestand keine
        Zeile; sie hier zu erfinden hiesse, Umfang zu erfinden. Der Wunsch
        wird vermerkt, die Zustellung an die Ansprechperson ist ein offener
        Punkt und wird nicht behauptet.

    GEPRUEFT UND NICHT ANGENOMMEN (offener Punkt O-M3-4 des Plans): Ob
    'TERMIN_ANGEFRAGT' in einem Aufzaehlungstyp gefuehrt wird, war die Frage.
    `event.action` ist im Zielschema `text NOT NULL` ohne Aufzaehlungstyp und
    ohne Bedingung (schema/freiraum_datamodel.sql, Tabelle `event`); auch M30
    fuegt keine hinzu. Der Wert traegt also. Es war nichts zu aendern und
    nichts auszuweichen.

    `actor_label` steht mit im INSERT, weil die Bedingung
    `event_actor_paarweise` Verknuepfung und Namensschnappschuss gemeinsam
    verlangt (K02-G13): wer das Konto entfernt, soll nicht den Namen
    mitnehmen. `change_type` traegt 'Neuanlage' wie beim Sitzungsnachweis --
    der Gespraechswunsch entsteht neu, es wird nichts geaendert.
    """
    merkmal = request.cookies.get(KEKS_NAME)
    with verbindung() as conn:
        stand = sitzung_pruefen(conn, merkmal_lesen(merkmal))
        if stand is None:
            return _zurueck_auf_en01(merkmal)

        check = check_lesen(conn, stand)
        if check is None:
            return _umleitung("/vorpruefung")

        conn.execute(
            "INSERT INTO event (actor_id, actor_label, tenant_id, action,"
            "                   object_ref, change_type, value, source)"
            " VALUES (%s, %s, %s, 'TERMIN_ANGEFRAGT', %s, 'Neuanlage', %s,"
            "         'PORTAL_ACTION')",
            (stand["actor_id"], stand["anzeigename"], stand["mandant"],
             "FIT_CHECK:" + str(check[0]), "Ergebnis " + check[1]))

    return _umleitung("/eignung?termin=1")
