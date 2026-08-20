# umsetzt: K05-M01, K05-M03, K05-M04, K05-M06, K05-M08, K05-M10, K05-M11,
#          K05-M15, K05-M22, K05-M24, K05-M25, K05-M26, K05-M27, K05-G01,
#          K05-G02, K05-G04, K05-G05, K05-G06, K05-D01, K05-D02, K05-D03,
#          K05-D05, K05-D06, K05-D11, K13-M05, K01-M15, K02-D04,
#          K02-M21, K02-G13, K10-M03, K19-M06, K23-D09
# nicht beansprucht, obwohl beruehrt: K05-D10 -- die Datei legt keine Tabelle
#          und keine Sicht an und nennt jedes fremde Objekt mit seinem
#          Eigentuemer. Gemessen wird die Klausel aber am K05-TEXT und nicht
#          am Bau: "Ein Lauf am gebauten Datenbestand misst diese Klausel
#          nicht" (gezeichnetes Kriterium). Der Entwurf fuehrte sie in seiner
#          Meldung als umgesetzt -- ein Bau kann sie nicht erfuellen
#          sowie die Zeichnungen vom 19.08.2026: T-4 (die eine Rolle des
#          Endnutzer-Portals faellt mit der Mitgliedschaft zusammen), T-5
#          (Ablageschluessel als serverseitig erzeugte uuid4), Blatt 100
#          Entscheidung 4 (der Dateianhang ist zurueckgestellt) und der
#          Rueckfallweg S-G (die ungezeichneten Auswahllisten fuehren die
#          benannte Meldung, der freie Weg traegt)
#
# BERICHTIGTE FASSUNG, 19.08.2026. Gegengelesen wurde der Entwurf gleichen
# Namens. Sechs Stellen sind gekippt und stehen jetzt anders; jede ist unten
# im Abschnitt "WAS AN DIESER FASSUNG BERICHTIGT IST" mit ihrem Grund und
# ihrer Fundstelle benannt. Nichts davon ist Geschmack: jede der sechs
# widersprach dem Bildschirmvertrag oder einem gezeichneten
# Akzeptanzkriterium vom 19.08.2026.
# zur Haelfte umgesetzt: K05-M02 -- weil der freie Weg ("Was anderes") ganz
#          traegt, die zwoelf Themen aber in keiner Quelle im Wortlaut
#          stehen. Sie werden nicht erfunden; der Bildschirm fuehrt an ihrer
#          Stelle die benannte Meldung, genau wie EN-03a es vormacht
#          (S-G, gezeichnet 19.08.2026)
# zur Haelfte umgesetzt: K05-M05 -- dieselbe Lage: Mehrfachnennung und Rang
#          aus der Reihenfolge sind gebaut, die sieben Ziele im Wortlaut
#          fehlen. "+ Anderes Ziel" traegt allein
# zur Haelfte umgesetzt: K05-M07 -- weil es in M5 KEINEN Modellpfad gibt.
#          Ein Namensvorschlag "als Vorschlag der Modelle markiert" kann
#          deshalb nicht entstehen; das Feld bleibt leer und ueberschreibbar,
#          und der eingegebene Name traegt die Marke "Ihre Angabe". Erfunden
#          wird kein Vorschlag und keine Marke, die keinen Urheber hat
#          (K05-D04 waere sonst mit einer Falschangabe erfuellt)
# zur Haelfte umgesetzt: K05-M09 -- weil zwei der drei Antwortwege gebaut
#          sind (Vorschlag anklicken, in eigenen Worten schreiben) und der
#          dritte, das Dokument, nach Blatt 100 Entscheidung 4
#          zurueckgestellt ist. Der Serverbefehl upload_interview_document
#          existiert in dieser Datei nicht -- weder als Weg noch als Feld
# zur Haelfte umgesetzt: K05-M05 -- dieselbe Lage wie bei K05-M02:
#          Mehrfachnennung und Rang aus der Reihenfolge sind gebaut, die
#          sieben Ziele im Wortlaut fehlen. "+ Anderes Ziel" traegt allein
#          (S-G). Der Entwurf fuehrte K05-M05 im Kopf als GANZ umgesetzt und
#          in seiner Meldung als halb -- der Kopf ist die Wahrheit dieser
#          Datei und sagt jetzt dasselbe wie die Meldung
# zur Haelfte umgesetzt: K05-M19 -- weil Stufe und Protokolleintrag ueber
#          set_journey_phase gemeinsam entstehen, die UEBERGABE AN K06 aber
#          nicht gebaut ist. M32 sagt es im eigenen Kopf: "Die Uebergabe an
#          K06 ist die Grenze von M5, nicht sein Inhalt." Der Weg endet
#          deshalb auf EN-06 in Nur-Ansicht mit einer Quittung und nicht auf
#          EN-07 -- EN-07 gehoert M6
# zur Haelfte umgesetzt: K05-M12 -- weil Ursprung und Bearbeitungszustand im
#          Dateistand je Beitrag getrennt gefuehrt werden
#          (`bearbeitungszustand`, `ersetzt`), die getrennte ANZEIGE aber der
#          Bildschirm leistet und der in Zug 5 entsteht
# zur Haelfte umgesetzt: K05-M28 -- die eine Haelfte traegt: der Nutzerbeitrag
#          fuehrt `actor_id`, und Bearbeitungszustand und Herkunft stehen als
#          zwei voneinander unabhaengige Angaben. Die andere Haelfte ist
#          gebaut, aber LEER: das Format fuehrt `modell_version`,
#          `prompt_version` und `quellen_version` je Beitrag und laesst sie
#          unbesetzt, weil es keinen KI-Beitrag gibt. Das gezeichnete
#          Kriterium misst sie ausdruecklich ("ein KI-Beitrag fuehrt im
#          Dateistand Modellversion, Promptversion und Quellenversion"); ein
#          Format ohne die drei Felder muesste beim ersten Modellpfad
#          geaendert werden, und ein geaendertes Format bricht die
#          Unveraenderlichkeit der alten Staende auf (K05-M25). Der Entwurf
#          liess sie weg und benannte die Luecke nicht
# zur Haelfte umgesetzt: K05-M14, K05-M13, K05-M16, K05-M32 -- sie
#          beschreiben den Bildschirm (nicht wegklickbarer KI-Hinweis,
#          Zweiteilung, Teilnehmerliste, Statusmeldungen fuer
#          Hilfstechnologien). Diese Datei liefert die Bausaetze dafuer und
#          baut den Bildschirm nicht
# nicht umgesetzt: K05-M23 -- weil kein Modellaufruf stattfindet. Eine
#          Maskierung vor einem Aufruf, den es nicht gibt, waere eine
#          Behauptung. Statt ihrer traegt diese Datei einen Riegel: die
#          Marke KI_NOTIZ laesst sich hier nicht schreiben (`_marke_pruefen`)
# nicht umgesetzt: K05-M17, K05-M18, K05-M20, K05-M21, K05-M29, K05-M30,
#          K05-M31, K05-D07, K05-D09, K05-D12 -- Einladung (K20),
#          Protokoll-Download (K10), Stimmweg (F31, ausdruecklich gesperrt),
#          Upload-Pruefung (zurueckgestellt), Nebenfragen-Fenster (K16).
#          Keiner dieser Wege ist hier angedeutet; ein angedeuteter Weg ist
#          ein versprochener Weg
#
# WAS AN DIESER FASSUNG BERICHTIGT IST -- sechs Stellen, mit Fundstelle
#
#  1  "Speichern, spaeter weitermachen" SCHREIBT WIEDER. Der Entwurf liess
#     `save_interview_progress` nichts anlegen, wenn seit dem letzten Stand
#     kein Beitrag hinzukam, und begruendete das mit dem offenen Takt aus
#     K05-M25. Der Takt ist offen -- fuenf gezeichnete Kriterien sind es
#     nicht, und alle fuenf messen an genau diesem Weg:
#       K05-M26 Positivfall: "zwischenspeichern (Zustand Erfolg); erwartete
#               Beobachtung: die drei Saetze sind in der Reihenfolge Datei,
#               `document`-Zeile, `event` entstanden"
#       K10-M03 Positivfall: "EN-06 · zwischenspeichern in Zustand Erfolg
#               ausloesen -- die neue Zeile traegt einen nicht leeren
#               Dateinamen"
#       K05-M27 Aufbau:      "ein Gespraechsstand zweimal nacheinander
#               gespeichert (EN-06 · zwischenspeichern · Zustand Erfolg),
#               also zwei document-Zeilen mit content_ref und content_sha256"
#       K05-M24 Aufbau:      "Anwendung A1 und gespeichertem Gespraechsstand
#               (EN-06 · zwischenspeichern · Zustand Erfolg)"
#       K05-M15 Negativfall b: "das Speichern wird zum Scheitern gebracht
#               (Zustand Fehler)" -- ein Weg, der nichts schreibt, kennt
#               keinen Fehlerzustand
#     Dazu der Bildschirmvertrag selbst (K19_screens.yaml:364):
#     "Dreischritt Datei, document-Zeile, event in dieser Reihenfolge".
#     Ein Weg, der nichts anlegt, macht diese fuenf Prueffaelle nicht etwa
#     falsch -- er macht sie UNAUFBAUBAR, und ein Tor, das nicht messen kann,
#     meldet nach K23-M22 GESPERRT. Der offene Takt bleibt offen und steht
#     unten in den Vorlagenpunkten; entschieden wird er vom Eigentuemer und
#     nicht dadurch, dass der Bau fuenf Messungen wegbaut.
#
#  2  DER EIGNUNGSRIEGEL. Der Entwurf pruefte den `fit_check` nirgends.
#     EN-05 · thema_waehlen · berechtigung (K19_screens.yaml:287):
#     "Vorbedingung ist ein fit_check mit outcome GEEIGNET (Eigentuemer
#     K04)". Und K05-G01 misst genau die beiden Gegenfaelle: "(a) der
#     fit_check traegt nicht das outcome GEEIGNET; (b) das Ergebnis des
#     fit_check ist nicht ermittelbar -- erwartete Beobachtung je Lauf: die
#     Aktion wird gesperrt". Beide waeren durchgelaufen. Dass heute nur
#     `create_app_after_fit` eine Anwendung anlegt, ist kein Ersatz: der
#     Fremdschluessel `app.fit_check_id` ist nullbar, und der Vertrag sagt an
#     anderer Stelle selbst, dass ein nullbarer Fremdschluessel keine
#     Erlaubnis ist, ihn zu umgehen. Gebaut ist der Riegel jetzt in
#     `zugang_pruefen` -- an derselben Stelle wie Konto, Mandant und
#     Objektbezug, also VOR jedem Lesen und Schreiben.
#
#  3  DIE EINORDNUNG LAESST SICH WIEDER KORRIGIEREN. Der Entwurf wies jede
#     Antwort auf `record_classification` ab, sobald alle drei Fragen
#     beantwortet waren ("eine vierte Antwort auf eine abgeschlossene Folge
#     ist keine Aenderung"). Damit gab es keinen Weg mehr, eine falsch
#     eingetragene Branche zu berichtigen. K05-M06 verlangt zwei Wege und
#     misst den zweiten: "'Weitere Details angeben' waehlen, eine Ergaenzung
#     eintragen und zurueckkehren -- die Zusammenfassung fuehrt die
#     Ergaenzung"; NICHT ERFUELLT ist es, wenn "einer der beiden Wege fehlt".
#     K05-D03 und K05-M12 setzen dieselbe Moeglichkeit voraus. Die feste
#     Reihenfolge aus K05-M03 gilt weiter -- sie ordnet, wie zum ERSTEN Mal
#     geantwortet wird, und nicht, ob eine gegebene Antwort berichtigt werden
#     darf. Berichtigt: eine erneute Antwort auf eine bereits beantwortete
#     Frage kommt als eigener Beitrag hinzu (BEARBEITET, mit Verweis auf den
#     abgeloesten); geloescht wird nichts (K05-D03).
#
#  4  EN-06 OEFFNET SICH NICHT MEHR VOR SEINER STUFE. Der Entwurf zeigte
#     `GET /interview` auch dann, wenn die Anwendung noch auf ORIENTIERUNG
#     stand -- als "Nur-Ansicht". K05-D06 kennt die Nur-Ansicht nur fuer
#     ZURUECKLIEGENDE Stufen: "Der Nutzer DARF NICHT eine Stufe ueberspringen
#     oder eine spaetere Stufe anspringen. Zurueckliegende Stufen oeffnen
#     sich ausschliesslich als Nur-Ansicht." Eine spaetere Stufe als
#     Nur-Ansicht ist ein Anspringen mit ausgeblendeten Knoepfen.
#
#  5  DIE QUITTUNGEN ERREICHEN JETZT JEMANDEN. Der Entwurf leitete auf
#     "/uebersicht?fertig=1" und "/uebersicht?unbekannt=1" um und hielt zwei
#     Meldungen bereit, die nie jemand las: `GET /uebersicht`
#     (app/vorpruefung.py:570) nimmt keinen Parameter entgegen und
#     `en02_uebersicht.html` zeigt keine Meldung. Zwei erfundene Parameter an
#     einem fremden Bildschirm und zwei tote Konstanten. Berichtigt: der
#     Abschluss quittiert auf EN-06, das nach dem Wechsel ohnehin in
#     Nur-Ansicht steht -- auf einem Bildschirm, den diese Datei besitzt und
#     dessen Kasten belegt ist (F41). Der Weg fuer die unbekannte Anwendung
#     leitet ohne Parameter auf "/uebersicht"; dass beide Faelle -- fremder
#     Mandant und nicht vergebene Kennung -- dieselbe Antwort geben, ist
#     genau, was K01-M15 misst ("gleiche Antwort, kein Hinweis darauf, dass
#     es das Objekt gibt").
#
#  6  DER WORTLAUT DES NUTZERS WIRD NICHT MEHR BESCHNITTEN. Der Entwurf
#     speicherte `wortlaut.strip()`. K05-D05 und K05-G02 messen "zeichengleich
#     im eingetippten Wortlaut"; das Abschneiden von Randzeichen ist eine
#     Normalisierung, die keine Quelle nennt. Berichtigt: `.strip()`
#     entscheidet nur noch, OB etwas eingegeben wurde; gespeichert wird der
#     Text, wie er kam.
#
# UND EINE VORBEDINGUNG, DIE NICHT IN DIESER DATEI LIEGT UND SIE TROTZDEM
# SPERRT: `set_journey_phase` (M32, Zeile 257 ff.) schreibt seinen
# Protokolleintrag mit `actor_id` und OHNE `actor_label`. Die Bedingung
# `event_actor_paarweise` aus M30 (Zeile 745 ff., zu K02-G13) verlangt beides
# gemeinsam: CHECK (actor_id IS NULL OR actor_label IS NOT NULL). Jeder
# Aufruf bricht damit mit `check_violation` ab. Solange das so steht,
# erreichen `confirm_app_name` und `complete_interview` ihren Erfolgszustand
# NIE, und die Positivfaelle zu K05-M08, K05-M19, K05-G06, K05-D11 und
# K02-D04 fallen aus -- nicht wegen dieser Datei. Der Fehlerweg dieser Datei
# faengt es fail-closed ab (nichts geaendert, benannte Meldung), aber das ist
# keine Heilung. Gehoert in den naechsten Migrationszug, nicht hierher; hier
# wird er benannt, damit ihn niemand fuer ein Versehen dieses Weges haelt.
"""FREIRAUM · Scheibe 4 · M5 · Zug 4 -- die Serverbefehle von EN-05 und EN-06.

Zwei Bildschirme aus dem Vertrag `schema/K19_screens.yaml`, uebernommen und
nicht frei gezeichnet (K05-G07, K19-M01):

    EN-05  Stufe 01 Orientierung -- Thema, Einordnung, Ziele,
           Ausgangsproblem, Name; am Ende der Stufenwechsel nach INTERVIEW
    EN-06  Stufe 02 Interview -- antworten, ueberspringen, zwischenspeichern,
           beenden; am Ende der Stufenwechsel nach UEBERSICHT

NEUN VON ZEHN BEFEHLEN. `upload_interview_document` ist nach Blatt 100,
Entscheidung 4 zurueckgestellt und wird hier ausdruecklich BENANNT und nicht
gebaut -- weder als Route noch als Formularfeld noch als Zweig. Zurueckgestellt
heisst nicht "halb gebaut".

Der Vertrag dieser Datei -- er ist zugleich das, was die Pruefung misst:

    GET  /orientierung              EN-05. AENDERT NICHTS. Ohne gueltige
                                    Sitzung -> 303 auf "/anmeldung". Ohne
                                    Zugang zur genannten Anwendung oder ohne
                                    Eignung GEEIGNET -> dieselbe Antwort wie
                                    auf eine nicht vorhandene (K01-M15,
                                    K05-G01). Steht die Stufe SPAETER als
                                    ORIENTIERUNG -> Nur-Ansicht (K05-D06)
    POST /orientierung/thema        `anwendung`, `wortlaut`. record_topic.
                                    Erfolg -> 303 auf "/orientierung"
    POST /orientierung/einordnung   `anwendung`, `frage`, `wortlaut`.
                                    record_classification. Feste Reihenfolge
                                    Branche -> Funktionsbereich -> Anwendung
                                    fuer die ERSTE Beantwortung; eine
                                    uebersprungene Reihenfolge wird
                                    abgewiesen, ohne zu schreiben (K05-M03).
                                    Eine bereits beantwortete Frage laesst
                                    sich berichtigen; die Berichtigung kommt
                                    hinzu, sie ersetzt nichts (K05-M06,
                                    K05-D03, K05-M12)
    POST /orientierung/ziele        `anwendung`, `wortlaut`. record_goals.
                                    Der Rang ist die Reihenfolge der Auswahl
                                    und wird nicht bewertet (K05-G04)
    POST /orientierung/ausgangsproblem  `anwendung`. confirm_initial_problem.
                                    Ohne Zusammenfassung ausgeblendet, an
                                    ihrer Stelle der Hinweis (K05-G05)
    POST /orientierung/name         `anwendung`, `name`. confirm_app_name.
                                    Setzt `app.name` UND die Stufe -- ueber
                                    set_journey_phase, nie ueber ein UPDATE
                                    auf `journey_phase`. Erfolg -> 303 auf
                                    "/interview"
    GET  /interview                 EN-06. AENDERT NICHTS
    POST /interview/antwort         `anwendung`, `wortlaut`, `frage`.
                                    record_interview_answer -- derselbe Befehl
                                    fuer beide Aktionen des Vertrags
                                    (vorschlag_waehlen, freitext_antworten)
    POST /interview/ueberspringen   `anwendung`, `frage`.
                                    skip_interview_question. Schreibt den
                                    Vermerk (Frage uebersprungen) OHNE Marke
    POST /interview/speichern       `anwendung`. save_interview_progress.
                                    Fuehrt den Dreischritt aus -- auch wenn
                                    seit dem letzten Stand kein Beitrag
                                    hinzukam (K05-M26, K10-M03, K05-M27,
                                    K05-M24, K05-M15). Erfolg -> 303 auf
                                    "/interview?...&gespeichert=1"
    POST /interview/fertig          `anwendung`. complete_interview. Stufe auf
                                    UEBERSICHT ueber set_journey_phase.
                                    Erfolg -> 303 auf
                                    "/interview?...&abgeschlossen=1";
                                    EN-06 steht danach in Nur-Ansicht und
                                    traegt die Quittung

DER DREISCHRITT IST DER KERN (K05-M26). Jeder Speichervorgang legt an, in
dieser Reihenfolge: zuerst die DATEI, dann die `document`-Zeile, zuletzt den
append-only `event`-Eintrag. Der juengste Eintrag je Anwendung bestimmt den
wiederaufnehmbaren Stand -- die Wiederaufnahme liest ihn und nichts anderes.

UND DIE SICHTBARKEIT HAENGT AM LETZTEN SCHRITT, nicht am ersten. Das ist der
ganze Trick, mit dem "ein unvollstaendiger Dreischritt wird nicht sichtbar"
ohne verteilte Transaktion traegt: Datei und `document`-Zeile werden von
niemandem gelesen, der nicht ueber den `event`-Eintrag kommt. Bricht Schritt 2
oder 3 ab, bleibt die Datei ein Objekt, auf das kein Eintrag zeigt -- sie wird
zusaetzlich gesperrt (vierte Verrichtung der Ablage) und ist damit weder
sichtbar noch stumm liegen geblieben. Der vorige Stand bleibt gueltig, weil
sein Eintrag weiter der juengste ist.

Schritt 2 und 3 laufen in EINER Transaktion. Eine `document`-Zeile ohne
Eintrag waere kein Schaden, aber ein Rest; ein Eintrag ohne Zeile waere ein
Verweis ins Leere. Beides entsteht gemeinsam oder gar nicht (K02-D04).

K05 BESITZT KEINE TABELLE (K05-M25), UND DIESE DATEI LEGT KEINE AN. Der
gesamte fachliche Gespraechsstand steht in der Datei. Es gibt hier keinen
Zwischenspeicher, keine Sitzungsvariable und kein Feld, in dem ein Beitrag
darauf wartete, gespeichert zu werden -- deshalb ueberlebt der Stand das
Abmelden ohne weiteres Zutun (K05-M15). Wo nichts gepuffert wird, kann nichts
verloren gehen.

DER TAKT, offen gezeichnet -- und deshalb NICHT hier entschieden: Das
Akzeptanzkriterium zu K05-M25 laesst ausdruecklich offen, "in welchem Takt der
Dateistand fortgeschrieben wird", und misst bis dahin "je Speichervorgang nach
K05-M26". Diese Datei setzt deshalb die WEITE Lesart, die alle uebrigen
gezeichneten Kriterien messbar laesst:

    JEDER BEITRAG IST EIN SPEICHERVORGANG -- UND "SPEICHERN, SPAETER
    WEITERMACHEN" IST AUCH EINER.

Beides fuehrt den vollen Dreischritt. Ein Speichervorgang ohne neuen Beitrag
legt also einen Stand an, der dieselben Beitraege fuehrt wie sein Vorgaenger
und sich von ihm in Revision, Zeit und `vorgaenger_hash` unterscheidet. Das
sieht nach einer leeren Revision aus und ist keine: sie ist der Nachweis, DASS
zu diesem Zeitpunkt gespeichert wurde -- und genau diesen Nachweis verlangen
K05-M26, K10-M03, K05-M27, K05-M24 und K05-M15 an dieser Bedienung.

WAS DAS KOSTET, offen benannt und in der Vorlage: Faehrt man die Messung zu
K05-M25 buchstaeblich -- "einen Beitrag erfassen und zwischenspeichern, danach
einen zweiten Beitrag erfassen und erneut zwischenspeichern" --, entstehen
VIER Staende und nicht zwei, und der Hash des Vorgaengers im vierten ist der
des dritten und nicht der des ersten. Die Kette ist luecken- und bruchlos und
belegt jeden Stand gegen seinen Vorgaenger; welche zwei Staende der
Eigentuemer bei der Abnahme gegeneinander haelt, ist genau die offene
Taktfrage. Die andere Lesart -- zwischenspeichern legt nichts an, wenn nichts
hinzukam -- traefe die Messung zu K05-M25 woertlicher UND machte die fuenf
oben genannten Prueffaelle unaufbaubar. Fuenf messbare Kriterien wiegen
schwerer als die bequemere Lesart eines ausdruecklich offenen Punktes.

DIE ABLAGE IST EINE SCHNITTSTELLE MIT VIER VERRICHTUNGEN -- schreiben, lesen,
Hash pruefen, sperren -- und dahinter im Pruefstand eine Attrappe auf dem
Dateisystem. Der private Objektspeicher in `swedencentral` kommt spaeter
dahinter (gezeichnet, Zeile A des Nachtrags zur Ablage vom 19.08.2026). Der
Fachcode kennt den Traeger nicht und darf ihn nie kennen: ein Klausellauf, der
einen Objektspeicher braucht, laeuft in der CI nicht, und ein Tor, das nicht
messen kann, meldet nach K23-M22 GESPERRT statt bestanden.

DER SCHLUESSEL IST EINE uuid4, SERVERSEITIG ERZEUGT (T-5, gez. 19.08.2026).
`document.content_ref` traegt genau einen Bestandteil in der Form, die
`gen_random_uuid()` erzeugt, davor einen festen Praefix und dahinter eine feste
Endung -- und sonst nichts. Kein Dateiname, keine `app_id`, keine `actor_id`,
kein Zeitpunkt, keine laufende Nummer. Zwei Staende unterscheiden sich in mehr
als der letzten Stelle; ein hochgezaehlter Schluessel trifft nichts.

KEIN AUSGESTELLTER ZUGRIFF, und das ist zu vermerken. Das Akzeptanzkriterium
zu K05-M27 sagt: "Stellt der Serverpfad keinen Zugriff aus, sondern liest er
das Objekt selbst und gibt nur den Inhalt zurueck, ist (2) NICHT ANWENDBAR und
wird so vermerkt -- nicht als bestanden." Genau so ist es hier: der Server
liest das Objekt selbst; ein Verweis auf das Dateiobjekt verlaesst diesen
Prozess nie. Die gezeichneten zehn Minuten kommen deshalb nirgends vor -- eine
Konstante fuer eine Frist, die niemand prueft, waere eine Behauptung.

DER MANDANT IST DIE ERSTE FRAGE, NICHT DIE LETZTE (K01-M15, K05-M27). Jede
Abfrage auf `app` fuehrt `tenant_id = Mandant der Sitzung` in ihrer eigenen
Bedingung, jede Abfrage auf `document` zusaetzlich `app_id`. Seit M32 traegt
das auch der Zeilenschutz -- aber die Zeilenregel ist das NETZ und die
Bedingung der PLAN. Und der Zeilenschutz greift ohnehin erst, wenn der
Serverpfad `freiraum.tenant_id` setzt; das ist Zug 2 und nicht diese Datei.
Ein Stand eines fremden Mandanten wird nicht gefunden und dann abgelehnt -- er
wird gar nicht erst gelesen (dieselbe Antwort wie auf ein nicht vorhandenes
Objekt, K01-M15).

WAS DER SERVER ENTSCHEIDET, ENTSCHEIDET NICHT DER BROWSER (K05-M24, K13-M05).
Jeder der neun Befehle prueft VOR jedem Lesen und Schreiben: aktives Konto,
Mitgliedschaft (und mit ihr die eine Rolle des Endnutzer-Portals, T-4),
Mandant, Objektbezug, die Eignung (`fit_check` mit `outcome = GEEIGNET`,
EN-05 · thema_waehlen · berechtigung, K05-G01) -- und zusaetzlich die Stufe
(K05-D06). Faellt eine dieser
Angaben aus, wird weder gelesen noch geschrieben: keine Nutzdaten in der
Antwort, keine `document`-Zeile, kein `event`-Eintrag, der vorhandene Stand
unveraendert. Der Bildschirm blendet Wege aus; das ist Bequemlichkeit, keine
Sperre. Die Sperre steht hier.

DIE STUFE WECHSELT NUR UEBER set_journey_phase (M32). Kein UPDATE auf
`app.journey_phase` -- weder hier noch anderswo; die Funktion ist der einzige
Schreibweg, sie prueft Konto, Mandant und Mitgliedschaft selbst und schreibt
den Protokolleintrag im selben Zug (K05-M08, K05-M19, K02-D04). Der Client
uebergibt keine Stufe: die beiden Befehle nehmen kein Feld dafuer entgegen,
und es gibt keine Variable, in die eines liefe.

EINGABEN SIND DATEN (K05-M22). Kein Text dieser Datei wird ausgefuehrt,
ausgewertet oder an ein Modell gereicht. Er geht als Parameter in die
Datenbank (nie in eine zusammengesetzte Anweisung), als Wert in eine
JSON-Datei und als Wert an den Bildschirm, der ihn maskiert ausgibt. Eine
Handlungsanweisung im Text hat hier nichts, worauf sie wirken koennte.

WAS HIER AUSDRUECKLICH NICHT GEBAUT IST

  * `upload_interview_document` und mit ihm jede Datei-Entgegennahme.
    Zurueckgestellt nach Blatt 100, Entscheidung 4. Mit ihm bleiben K05-M29
    (Typ, Groesse, Malware, aktiver Inhalt, Quarantaene) und K05-G09
    ungebaut -- sie gehoeren zu diesem einen Weg.
  * DIE ZWOELF THEMEN, DIE SIEBEN ZIELE UND DIE FACHFRAGEN DER STUFE 02.
    Ihr Wortlaut steht in keiner Quelle. Gezeichneter Rueckfallweg S-G: der
    freie Weg traegt, die Auswahllisten fuehren die benannte Meldung zum
    ungezeichneten Wortlaut und werden als Seed nachgereicht -- genau wie
    EN-03a es vormacht. Erfunden wird keine Liste und keine Frage.
    Die DREI EINORDNUNGSFRAGEN sind davon ausgenommen: sie stehen im
    Klauselwortlaut selbst (K05-M03: Branche, Funktionsbereich, Anwendung;
    K05-M04: die drei offenen Alternativen), und K05-G02 sagt ausdruecklich,
    dass es Eingabefelder sind und keine festgelegten Werte. Sie sind ganz
    gebaut.
  * JEDER MODELLPFAD. Keine KI-Notiz, kein Namensvorschlag, keine erzeugte
    Zusammenfassung. Was der Assistent "aus Antworten geschlossen" haette,
    entsteht in M5 nicht -- und das Akzeptanzkriterium zu K05-M11 sagt selbst,
    dass nicht gemessen wird, "welcher Vorgang einen Eintrag mit der Marke
    KI-Notiz erzeugt", weil keine Quelle ihn nennt.
  * DIE BEIDEN BILDSCHIRME. `app/vorlagen/en05_orientierung.html` und
    `en06_interview.html` entstehen in Zug 5, je nach ihrem K19-Kasten
    (`schema/K19_build_referenz.md:252` und `:267`); die Gestaltung kommt
    ausschliesslich aus `app/statisch/token.css`. Diese Datei nennt die beiden
    Vorlagen und die Bausaetze, die sie erwarten -- gebaut sind sie nicht.
  * EN-07. `complete_interview` fuehrt nach dem Vertrag "weiter nach EN-07".
    EN-07 gehoert M6. Der Weg bleibt deshalb auf EN-06, das nach dem Wechsel
    in Nur-Ansicht steht (K05-D06), und quittiert dort; ein erfundenes EN-07
    waere ein Bildschirm ohne Kasten (F41). Auf EN-02 zu leiten waere ebenso
    falsch gewesen: `GET /uebersicht` (app/vorpruefung.py:570) kennt keinen
    Parameter, und `en02_uebersicht.html` zeigt keine Meldung -- die Quittung
    haette dort niemand gelesen.

WAS IN DIE VORLAGE GEHOERT UND HIER NICHT ENTSCHIEDEN IST

  * DER TAKT der Fortschreibung (K05-M25, ausdruecklich offen). Siehe oben.
  * DER UEBERSPRUNGVERMERK: die Klausel K05-M10 schreibt ihn mit Umlaut, das
    gezeichnete Akzeptanzkriterium an derselben Stelle umschrieben, und
    gemessen wird "Zeichen fuer Zeichen". Gebaut ist die Umschrift.
  * WER DAS AUSGANGSPROBLEM ZUSAMMENFASST (K05-M06 nennt keinen Urheber).
    Gebaut ist eine serverseitige Zusammenstellung aus den Angaben des
    Nutzers im Wortlaut, mit der Marke "Ihre Angabe".
  * DER NAMENSSCHRITT OHNE MODELLPFAD (K05-M07, K05-D04): leeres Feld und
    Marke "Ihre Angabe" -- oder gesperrt bis zum ersten Vorschlag der
    Modelle? Die zweite Lesart sperrt den ganzen Durchstich von M5.
  * OB EINE UEBERHOLTE BESTAETIGUNG DES AUSGANGSPROBLEMS NEU EINZUHOLEN IST.
    Gebaut ist: sie bleibt stehen und wird nicht entfernt (K05-D03).
  * EINE HOECHSTLAENGE FUER FREITEXT. Keine Quelle nennt eine; erfunden wird
    keine.
  * DIE ERSTRECKUNG DES RUECKFALLWEGS S-G AUF DIE FACHFRAGEN DER STUFE 02.
    Ohne gestellte Frage ist K05-M10 ("zu jeder gestellten Frage steht
    Diese Frage ignorieren bereit") nur mit einer vom Pruefstand gelieferten
    Kennung messbar.
  * `app.name` HAT KEINEN SERVERBEFEHL. M32 baut `set_journey_phase`, nicht
    `set_app_name`; `fr_portal` hat auf `app` nur SELECT. Das UPDATE traegt,
    solange der Serverpfad als Eigentuemer verbindet -- ein Punkt fuer den
    naechsten Migrationszug.
  * `event_actor_paarweise` GEGEN `set_journey_phase` (siehe Kopf). Sperrt
    heute beide Stufenwechsel.
"""
import hashlib
import json
import logging
import os
import uuid
from pathlib import Path

import psycopg
from fastapi import APIRouter, Form, Request
from fastapi.responses import HTMLResponse, RedirectResponse
from fastapi.templating import Jinja2Templates

from app.datenbank import pflichtwert, verbindung
from app.sitzung import KEKS_NAME, keks_loeschen, merkmal_lesen, sitzung_pruefen

PROTOKOLL = logging.getLogger(__name__)

# Gegen __file__, nicht gegen das Arbeitsverzeichnis -- dieselbe Begruendung
# wie in app/haupt.py, app/vorpruefung.py und app/zweckbestimmung.py.
VORLAGEN = Jinja2Templates(directory=str(Path(__file__).parent / "vorlagen"))

router = APIRouter()

# 303 und nicht 302, aus demselben Grund wie ueberall im Bestand: nach einem
# POST muss der Browser auf GET wechseln. Sonst legt ein Neuladen denselben
# Beitrag ein zweites Mal vor -- und der Stand truege ihn zweimal.
UMLEITUNG = 303


# ===========================================================================
#  ABSCHNITT A · DIE ABLAGE
#
#  Vier Verrichtungen, ein Traeger dahinter, und der Fachcode kennt ihn nicht.
#  Diese Schnittstelle gehoert nach Zug 3 des Bauplans in eine eigene Datei
#  (`app/ablage.py`). Sie steht hier, weil dieser Entwurf EINE Datei ist;
#  wandert sie, wandert sie unveraendert, und dieser Abschnitt wird zu einer
#  Import-Zeile. Was NICHT wandert, ist die Kenntnis des Traegers: sie ist
#  hier nirgends.
# ===========================================================================


class AblageFehler(RuntimeError):
    """Die Ablage konnte eine Verrichtung nicht ausfuehren.

    Eigene Klasse, damit der Aufrufer sie ENG fangen kann. Sie wird nie in
    eine Meldung an den Nutzer uebersetzt: ihr Wortlaut nennt Schluessel und
    Pfade und gehoert deshalb ins Protokoll des Betreibers (K23-D09).
    """


class AblageBesetzt(AblageFehler):
    """Unter diesem Schluessel liegt bereits ein Objekt.

    Das ist kein Missgeschick, sondern die Unveraenderlichkeit aus K05-M25:
    "ein Schreibversuch auf den ersten Stand geht nicht durch". Ein Objekt
    wird nie ueberschrieben. Dass es hier ueberhaupt auftreten kann, ist ein
    Netz und kein Plan -- die Schluessel sind uuid4.
    """


class Ablage:
    """Die Schnittstelle. Vier Verrichtungen, mehr nicht.

    schreiben     legt ein Objekt an und gibt Hash und Groesse zurueck.
                  Ueberschreiben ist ausgeschlossen (K05-M25).
    lesen         gibt den Inhalt zurueck. Kein Verweis verlaesst den Prozess
                  -- deshalb ist die Frist aus K05-M27 hier NICHT ANWENDBAR.
    hash_pruefen  vergleicht den Inhalt mit dem gefuehrten Hash. Sie steht in
                  JEDEM Lesepfad, nicht nur beim Anlegen (Vorbild K18-M30).
    sperren       nimmt ein Objekt aus dem Verkehr, ohne es zu entfernen
                  (F36: es wird nichts geloescht). Fuer verwaiste Objekte
                  eines abgebrochenen Dreischritts und fuer jeden Inhalt,
                  dessen Hash nicht mehr stimmt.

    KEINE FUENFTE VERRICHTUNG. Kein Auflisten, kein Loeschen, kein Umbenennen,
    kein Ausstellen eines Verweises. Was die Schnittstelle nicht kann, kann
    kein Traeger dahinter anbieten -- und niemand kann es versehentlich
    benutzen.
    """

    def schreiben(self, schluessel, daten):
        raise NotImplementedError

    def lesen(self, schluessel):
        raise NotImplementedError

    def hash_pruefen(self, schluessel, erwarteter_hash):
        raise NotImplementedError

    def sperren(self, schluessel, grund):
        raise NotImplementedError


class DateisystemAblage(Ablage):
    """Die ATTRAPPE fuer den Pruefstand. Nicht fuer den Pilotbetrieb.

    Gezeichnet als Variante 3 des Nachtrags zur Ablage vom 19.08.2026, und
    dort mit ihrem Mangel benannt: sie ueberlebt keinen Neustart des
    Behaelters und belegt keine private Ablage nach K10-M30. Fuer den
    Pilotbetrieb ist sie untauglich -- fuer einen Klausellauf ist sie das
    Einzige, was ueberhaupt laeuft.

    DASS SIE HIER STEHT, IST DER PUNKT. Ohne sie waeren die Prueffaelle zu M5
    von Anfang an GESPERRT (K23-M22), weil in der CI kein Objektspeicher
    laeuft. Mit ihr misst der Lauf alles ausser dem Traeger.
    """

    def __init__(self, wurzel):
        self._wurzel = Path(wurzel)
        self._quarantaene = self._wurzel / "quarantaene"

    def _pfad(self, schluessel):
        """Der Schluessel wird geprueft, bevor er ein Pfad wird.

        Ein Schluessel kommt in dieser Datei ausschliesslich aus
        `_ablageschluessel()` oder aus `document.content_ref`. Trotzdem wird
        seine FORM hier geprueft und nicht angenommen: ein Wert aus der
        Datenbank ist eine Eingabe wie jede andere, und ".." in einem Pfad ist
        der aelteste Fehler, den es gibt. Fail-closed (K05-G01).
        """
        if not _schluessel_traegt(schluessel):
            raise AblageFehler(
                f"Ablageschluessel hat nicht die gezeichnete Form: {schluessel!r}")
        return self._wurzel / schluessel

    def schreiben(self, schluessel, daten):
        pfad = self._pfad(schluessel)
        pfad.parent.mkdir(parents=True, exist_ok=True)
        try:
            # "xb" und nicht "wb": das Anlegen scheitert, wenn das Objekt
            # bereits besteht. Unveraenderlichkeit als Eigenschaft des
            # Schreibvorgangs und nicht als Vorsatz (K05-M25).
            with open(pfad, "xb") as datei:
                datei.write(daten)
        except FileExistsError as fehler:
            raise AblageBesetzt(f"Objekt besteht bereits: {schluessel}") from fehler
        except OSError as fehler:
            raise AblageFehler(f"Objekt nicht schreibbar: {schluessel}") from fehler
        return {"sha256": hashlib.sha256(daten).hexdigest(),
                "groesse": len(daten)}

    def lesen(self, schluessel):
        try:
            return self._pfad(schluessel).read_bytes()
        except OSError as fehler:
            raise AblageFehler(f"Objekt nicht lesbar: {schluessel}") from fehler

    def hash_pruefen(self, schluessel, erwarteter_hash):
        return hashlib.sha256(self.lesen(schluessel)).hexdigest() == erwarteter_hash

    def sperren(self, schluessel, grund):
        """Aus dem Verkehr, nicht aus der Welt.

        Das Objekt wandert in die Quarantaene und bleibt dort liegen. Es wird
        NICHT entfernt: nach F36 wird nichts geloescht, und ein verwaistes
        Objekt ist zugleich der Beleg dafuer, dass ein Dreischritt abgebrochen
        ist. Wer es wegwirft, wirft den Befund weg.
        """
        quelle = self._pfad(schluessel)
        ziel = self._quarantaene / quelle.name
        try:
            self._quarantaene.mkdir(parents=True, exist_ok=True)
            if quelle.exists():
                quelle.replace(ziel)
        except OSError as fehler:
            # Auch das Sperren kann scheitern. Es wird gemeldet und nicht
            # verschluckt -- ein Objekt, das weder gesperrt noch verwaist
            # gemeldet ist, waere unsichtbar UND unbekannt.
            raise AblageFehler(f"Objekt nicht sperrbar: {schluessel}") from fehler
        PROTOKOLL.warning("Ablageobjekt gesperrt (%s): %s", grund, schluessel)


# Welcher Traeger. Kein stiller Vorgabewert -- dieselbe Begruendung wie bei
# den drei Werten in app/datenbank.py (Befund BEF-L2-1): ein Vorgabewert waere
# hier "schreibe irgendwohin", und das faellt niemandem auf.
#
# EIN TRAEGER, DEN DIESE DATEI NICHT KENNT, SPERRT BEIM START (K05-G01). Der
# private Objektspeicher steht noch nicht dahinter; er wird eingetragen, wenn
# er gebaut ist, und nicht vorweg als Zweig angedeutet.
ABLAGE_TRAEGER = os.environ.get("FREIRAUM_ABLAGE", "DATEISYSTEM")

if ABLAGE_TRAEGER != "DATEISYSTEM":
    raise RuntimeError(
        f"FREIRAUM_ABLAGE={ABLAGE_TRAEGER!r} ist kein Traeger, den dieser Stand "
        "kennt. Gebaut ist die Attrappe auf dem Dateisystem (Pruefstand); der "
        "private Objektspeicher in swedencentral kommt spaeter dahinter "
        "(Nachtrag zur Ablage vom 19.08.2026, Zeile A). Der Start bricht ab.")

# BERICHTIGT AM 20.08.2026, beim ersten Lauf mit eingehaengtem Router.
#
# Hier stand `ABLAGE_WURZEL = pflichtwert("FREIRAUM_ABLAGE_PFAD", ...)` --
# beim IMPORT ausgewertet. Die Absicht war richtig (kein stiller
# Vorgabewert), der Zeitpunkt war falsch: der Import dieser Datei haengt am
# Start der ganzen Anwendung, und damit nahm eine fehlende Angabe fuer den
# GESPRAECHSSTAND die Anmeldung, die Einladung und die Vorpruefung mit.
# Gemessen: der Prueflauf sprang von 4 auf 8 gesperrte Punkte, weil uvicorn
# gar nicht mehr hochkam -- ein Bauzug, der vier fremde Wege aussperrt, weil
# sein eigener Ort fehlt.
#
# FAIL-CLOSED BLEIBT ES TROTZDEM, nur an der richtigen Stelle: der Wert wird
# beim ERSTEN ABLAGEZUGRIFF verlangt, mit derselben Meldung. Wer ohne ihn
# einen Gespraechsstand schreiben will, kommt nicht durch; wer sich nur
# anmelden will, wird nicht bestraft.
_ABLAGE = None


def ablage():
    """Die Ablage -- beim ersten Zugriff hergestellt, nicht beim Import.

    Kein stiller Vorgabewert: fehlt der Pfad, bricht der ZUGRIFF ab, und die
    Meldung nennt den Grund (K05-M26, K05-G01, Befund BEF-L2-1).
    """
    global _ABLAGE
    if _ABLAGE is None:
        _ABLAGE = DateisystemAblage(pflichtwert(
            "FREIRAUM_ABLAGE_PFAD",
            "Ohne sie gibt es keinen Ort fuer den Gespraechsstand, und ohne "
            "Datei gibt es keinen Dreischritt (K05-M26)."))
    return _ABLAGE

# Praefix und Endung des Ablageschluessels. Sie sind bei JEDEM Stand dieselben
# -- das verlangt das Akzeptanzkriterium zu K05-M27 woertlich: ausser dem
# einen uuid4-Bestandteil "nur Zeichen, die bei jedem Stand dieselben sind
# (fester Praefix, feste Endung)".
#
# UND SIE TEILEN MIT `document.filename` KEINE ZEICHENFOLGE. Das ist kein
# Zufall: die Gegenprobe des Kriteriums vergleicht `content_ref` gegen
# Dateiname, app_id, actor_id, Zeitpunkt und laufende Nummer und laesst keine
# gemeinsame Teilzeichenkette von sechs oder mehr Zeichen zu. Deshalb heisst
# der Dateiname "Gespraechsstand ... .json" und der Schluessel "objekt/... .obj":
# gleiche Endungen waeren bereits fuenf gemeinsame Zeichen, und fuenf ist zu
# nah an sechs, um es dem Zufall zu ueberlassen.
ABLAGE_PRAEFIX = "objekt/"
ABLAGE_ENDUNG = ".obj"


def _ablageschluessel():
    """Ein Schluessel, serverseitig erzeugt, ohne fachlichen Bestandteil (T-5).

    `uuid.uuid4()` erzeugt genau die Form, die das Kriterium verlangt und die
    `gen_random_uuid()` an sechzehn Stellen des Datenmodells fuehrt. Der Wert
    stammt aus dem Zufallsgenerator des Betriebssystems und nicht aus dem
    Dateinamen, der `app_id`, der `actor_id`, dem Zeitpunkt oder einer
    laufenden Nummer -- keiner dieser Werte wird dieser Funktion auch nur
    uebergeben. Sie kann sie nicht verwenden, nicht weil sie es unterlaesst,
    sondern weil sie sie nicht hat.
    """
    return f"{ABLAGE_PRAEFIX}{uuid.uuid4()}{ABLAGE_ENDUNG}"


def _schluessel_traegt(schluessel):
    """Hat dieser Wert die Form eines Ablageschluessels? Fail-closed."""
    if not isinstance(schluessel, str):
        return False
    if not schluessel.startswith(ABLAGE_PRAEFIX):
        return False
    if not schluessel.endswith(ABLAGE_ENDUNG):
        return False
    mitte = schluessel[len(ABLAGE_PRAEFIX):-len(ABLAGE_ENDUNG)]
    try:
        kennung = uuid.UUID(mitte)
    except ValueError:
        return False
    # Version 4 ausdruecklich: das Kriterium nennt das Muster mit der "4" an
    # der dreizehnten Stelle. Eine uuid1 traegt die Uhrzeit und die
    # Netzadresse -- sie waere ein fachlicher Bestandteil und zaehlbar.
    return kennung.version == 4 and str(kennung) == mitte


# ===========================================================================
#  ABSCHNITT B · DER GESPRAECHSSTAND ALS DATEI
#
#  Das Format traegt, was K05-M25 aufzaehlt: app_id, Revision, Zeit,
#  Reihenfolge und je Beitrag actor.id, Erzeugungsart, Herkunft,
#  Bearbeitungszustand sowie Hash des Vorgaengers.
# ===========================================================================

# Die Marken. Zwei, und nur zwei (K05-M11). Der Wortlaut fuer die Anzeige
# steht daneben, damit der Bildschirm ihn nicht selbst bildet -- zwei Stellen
# mit demselben Wort laufen auseinander.
HERKUNFT_MENSCH = "IHRE_ANGABE"
HERKUNFT_MODELL = "KI_NOTIZ"
HERKUNFT_WORTLAUT = {HERKUNFT_MENSCH: "Ihre Angabe",
                     HERKUNFT_MODELL: "KI-Notiz"}

ERZEUGUNG_MENSCH = "MENSCH"
# ERZEUGUNG_MODELL wird in dieser Fassung von keinem Weg gesetzt und steht
# trotzdem hier: die Erzeugungsart ist ein Feld des Dateiformats (K05-M25),
# und ein Format, dessen Wertevorrat nur zur Haelfte benannt ist, laesst
# offen, was der andere Wert heissen wird. Wer den Modellpfad baut, findet
# ihn hier -- und mit ihm `MODELLPFAD_GEBAUT` und `_marke_pruefen`.
ERZEUGUNG_MODELL = "MODELL"

# GIBT ES IN M5 EINEN MODELLPFAD? Nein. Diese eine Zeile ist der Riegel, an
# dem `_marke_pruefen` haengt: solange sie falsch ist, laesst sich die Marke
# KI-Notiz nicht schreiben, und zwar an einer Stelle und nicht an neun.
# K05-M23 verlangt Maskierung vor JEDER Uebergabe an ein Sprachmodell; wer
# den Modellpfad baut, aendert diese Zeile und stolpert dabei ueber die
# Klausel, statt sie zu uebersehen.
MODELLPFAD_GEBAUT = False

# Bearbeitungszustand (K05-M12, K05-M28). Ursprung und Bearbeitung bleiben
# getrennt; ersetzt wird nichts, es kommt etwas hinzu (K05-D03).
ZUSTAND_URSPRUNG = "URSPRUNG"
ZUSTAND_BEARBEITET = "BEARBEITET"

# Die Gegenstaende eines Beitrags. Aufgezaehlt und nicht frei: ein Beitrag,
# dessen Gegenstand niemand kennt, laesst sich rechts nicht einordnen -- und
# der Bildschirmvertrag ordnet jede Zeile der rechten Spalte einem Feld zu
# (K19-Kasten EN-05: Branche, Funktion, Anwendung, Ziele, Ausgangsproblem,
# Name).
GEGENSTAND_THEMA = "THEMA"
GEGENSTAND_BRANCHE = "BRANCHE"
GEGENSTAND_FUNKTIONSBEREICH = "FUNKTIONSBEREICH"
GEGENSTAND_ANWENDUNG = "ANWENDUNG"
GEGENSTAND_ZIEL = "ZIEL"
GEGENSTAND_AUSGANGSPROBLEM = "AUSGANGSPROBLEM"
GEGENSTAND_NAME = "NAME"
GEGENSTAND_ANTWORT = "ANTWORT"
GEGENSTAND_UEBERSPRUNGEN = "UEBERSPRUNGEN"

# Die drei Einordnungsfragen IN FESTER REIHENFOLGE (K05-M03). Die Reihenfolge
# steht hier als Liste und nicht in drei Verzweigungen: drei Stellen laufen
# auseinander, eine nicht. Die Beschriftung ist der Klauselwortlaut selbst.
#
# FRAGE UND UEBERSCHRIFT SIND ZWEI ANGABEN, und die Quellen halten sie
# auseinander: gefragt wird nach dem "Funktionsbereich" (K05-M03, K05-M04,
# K19_screens.yaml:293), rechts steht die Antwort unter "Funktion"
# (K19_screens.yaml:298 und der Kasten, K19_build_referenz.md:256). Der
# Entwurf fuehrte nur einen Wert und haette die Ueberschrift in Zug 5 erfinden
# lassen. `offen` ist der Wortlaut aus K05-M04, Zeichen fuer Zeichen.
EINORDNUNG = [
    {"code": "branche", "gegenstand": GEGENSTAND_BRANCHE,
     "frage": "Branche", "ueberschrift": "Branche",
     "offen": "Andere Branche"},
    {"code": "funktionsbereich", "gegenstand": GEGENSTAND_FUNKTIONSBEREICH,
     "frage": "Funktionsbereich", "ueberschrift": "Funktion",
     "offen": "Anderer Funktionsbereich"},
    {"code": "anwendung", "gegenstand": GEGENSTAND_ANWENDUNG,
     "frage": "Anwendung", "ueberschrift": "Anwendung",
     "offen": "Andere Anwendung"},
]

# Welche Gegenstaende in "IHR STAND" gehoeren -- der Kasten von EN-05 zaehlt
# sechs Zeilen auf und das Thema ist keine davon (K19_build_referenz.md:254
# bis 260: Branche, Funktion, Anwendung, Ziele, Ausgangsproblem, Name). Das
# Thema wird links gewaehlt und im Stand gefuehrt (EN-05 · thema_waehlen ·
# Zustand Erfolg), es steht aber nicht als eigene Zeile im Kasten. Der Entwurf
# gab es ununterschieden mit heraus; Zug 5 haette dann eine siebte Zeile
# erfinden oder das Thema stillschweigend weglassen muessen -- beides waere
# eine Entscheidung des Bildschirms ueber den Kasten (F41).
IM_KASTEN_EN05 = {GEGENSTAND_BRANCHE, GEGENSTAND_FUNKTIONSBEREICH,
                  GEGENSTAND_ANWENDUNG, GEGENSTAND_ZIEL,
                  GEGENSTAND_AUSGANGSPROBLEM, GEGENSTAND_NAME}

# Der Uebersprungvermerk. AUSSCHLIESSLICH dieser Wortlaut, keine Marke, kein
# Inhalt aus dem Gespraech (K05-M10, K05-D02). Er steht als Konstante, damit
# ein Prueffall ihn Zeichen fuer Zeichen treffen kann.
#
# UMLAUT ODER UMSCHRIFT -- offener Punkt, nicht still entschieden. Der
# Klauselwortlaut schreibt "(Frage übersprungen)"; das gezeichnete
# Akzeptanzkriterium schreibt an derselben Stelle "(Frage uebersprungen)", und
# der gesamte Bestand umschreibt Umlaute. Gebaut ist deshalb die Umschrift --
# gemessen wird aber "Zeichen fuer Zeichen", und das ist genau die Stelle, an
# der eine Umschrift zu wenig ist. Der Punkt geht in die Vorlage.
VERMERK_UEBERSPRUNGEN = "(Frage uebersprungen)"

# Das Dateiformat traegt seine eigene Kennung und seine eigene Fassung. Ohne
# sie liesse sich ein spaeter geaendertes Format von einem alten Stand nicht
# unterscheiden -- und ein Stand, dessen Bedeutung man raten muss, ist kein
# unveraenderlicher Nachweis.
FORMAT_KENNUNG = "FREIRAUM_GESPRAECHSSTAND"
FORMAT_FASSUNG = "1"

# Medienart und Dateiname der Protokolldatei. `document.filename` ist Pflicht
# (K10-M03) und ausdruecklich NICHT der Ablageschluessel (K07-M25).
MEDIENART = "application/json"


def _kanonisch(stand):
    """Die Bytes, die geschrieben und gehasht werden -- in EINER Form.

    `sort_keys` und feste Trennzeichen, damit derselbe Stand immer dieselben
    Bytes ergibt. Ohne das haengt der Hash an der Laune der Bibliothek, und
    eine Kette aus solchen Hashes belegt nichts.

    `ensure_ascii=False`: der Wortlaut des Nutzers geht unveraendert in die
    Datei. Er ist sein Text und nicht unserer -- die Umschrift der Umlaute ist
    eine Regel fuer den Programmtext dieses Hauses, keine fuer fremde Angaben.
    """
    return json.dumps(stand, sort_keys=True, ensure_ascii=False,
                      separators=(",", ":")).encode("utf-8")


def _hash(daten):
    return hashlib.sha256(daten).hexdigest()


def _stand_leer(app_id):
    """Der Stand vor dem ersten Beitrag. Revision 0, und er wird nie geschrieben.

    Er ist der Zustand `leer` des Bildschirmvertrags in Datenform: keine
    Beitraege, kein Vorgaenger. Dass er nicht geschrieben wird, ist Absicht --
    eine Revision 0 in der Ablage waere ein Stand, in dem nichts geschah.
    """
    return {"format": FORMAT_KENNUNG, "format_fassung": FORMAT_FASSUNG,
            "app_id": str(app_id), "revision": 0, "zeit": None,
            "vorgaenger_hash": None, "beitraege": []}


def _marke_pruefen(herkunft, erzeugungsart):
    """Genau eine Marke, und sie muss bestimmbar sein (K05-M11).

    Rueckgabe: None, wenn die Marke traegt; sonst die Meldung, mit der der
    Beitrag abzuweisen ist -- und zwar OHNE dass rechts ein Eintrag entsteht.
    Der Bildschirmvertrag sagt es fuer `vorschlag_waehlen` woertlich: "Marke
    nicht eindeutig bestimmbar ... kein Eintrag rechts, Meldung, Antwort
    bleibt waehlbar".

    HIER HAENGT DER RIEGEL AUS `MODELLPFAD_GEBAUT`. Eine KI-Notiz setzt einen
    Modellaufruf voraus, ein Modellaufruf setzt die Maskierung nach K05-M23
    voraus, und die ist nicht gebaut. Also ist die Marke KI-Notiz in diesem
    Stand nicht bestimmbar -- nicht "verboten", sondern schlicht nicht
    belegbar. Fail-closed heisst, dass daraus kein Eintrag wird.
    """
    if herkunft not in HERKUNFT_WORTLAUT:
        return MELDUNG_MARKE_UNKLAR
    if herkunft == HERKUNFT_MODELL and not MODELLPFAD_GEBAUT:
        return MELDUNG_MARKE_UNKLAR
    if (herkunft == HERKUNFT_MENSCH) != (erzeugungsart == ERZEUGUNG_MENSCH):
        # Marke und Erzeugungsart muessen dasselbe sagen. Sagen sie es nicht,
        # ist die Herkunft nicht bestimmt, sondern behauptet (K05-D02).
        return MELDUNG_MARKE_UNKLAR
    return None


def _beitrag_anfuegen(stand, *, gegenstand, wortlaut, actor_id, stufe,
                      herkunft=HERKUNFT_MENSCH,
                      erzeugungsart=ERZEUGUNG_MENSCH,
                      zustand=ZUSTAND_URSPRUNG, ersetzt=None,
                      frage_kennung=None, rang=None, zeit=None):
    """Einen Beitrag anhaengen -- und NICHTS anderes anfassen.

    Diese Funktion rechnet, sie schreibt nicht. Sie gibt einen NEUEN Stand
    zurueck und laesst den uebergebenen unangetastet; die Datei des vorigen
    Standes ist unveraenderlich (K05-M25), und ein Stand, den man im
    Arbeitsspeicher aendern koennte, verfuehrt genau dazu.

    DER HASH DES VORGAENGERS steht an zwei Stellen, weil der Klauselwortlaut
    ihn an zwei Stellen lesen laesst und keine der beiden Lesarten
    ausschliesst:

      am STAND    `vorgaenger_hash` ist der Hash der Datei des vorigen
                  Standes. Das ist die Kette, die das gezeichnete
                  Akzeptanzkriterium misst ("der im zweiten Stand gefuehrte
                  Hash des Vorgaengers ist der Hash des ersten Standes").
      am BEITRAG  `vorgaenger_hash` ist der Hash des vorhergehenden Beitrags
                  in kanonischer Form. Das ist die Lesart, die der Wortlaut
                  "je Beitrag ... sowie Hash des Vorgaengers" nahelegt.

    Beide zu fuehren kostet ein Feld. Sich fuer eine zu entscheiden, hiesse
    einen Klauselwortlaut auslegen -- und das tut der Bau nicht.
    """
    # KOPIE JE BEITRAG, nicht nur der Liste. Der Entwurf nahm `list(...)` und
    # teilte damit die Beitragsverzeichnisse mit dem uebergebenen Stand; der
    # Dreischritt traegt danach die Zeit nach und aenderte den alten Stand
    # mit. Heute faellt das nicht auf, weil gelesene Beitraege ihre Zeit schon
    # tragen -- eine Unveraenderlichkeit, die von dieser Reihenfolge abhaengt,
    # ist keine (K05-M25).
    beitraege = [dict(b) for b in stand["beitraege"]]
    vorgaenger = _hash(_kanonisch(beitraege[-1])) if beitraege else None
    beitraege.append({
        "reihenfolge": len(beitraege) + 1,
        "stufe": stufe,
        "gegenstand": gegenstand,
        "wortlaut": wortlaut,
        "rang": rang,
        "frage_kennung": frage_kennung,
        "actor_id": str(actor_id),
        "erzeugungsart": erzeugungsart,
        "herkunft": herkunft,
        "bearbeitungszustand": zustand,
        "ersetzt": ersetzt,
        "zeit": zeit,
        # Die drei Versionsangaben eines KI-Beitrags (K05-M28). Sie stehen im
        # Format und sind leer, weil es in M5 keinen KI-Beitrag gibt. Ein
        # Format, das sie erst spaeter bekaeme, waere ein zweites Format --
        # und die alten Staende liessen sich dann nicht mehr unveraendert
        # zurueckdeuten (K05-M25). Wer den Modellpfad baut, fuellt sie; die
        # Felder erfinden nichts, sie halten den Platz.
        "modell_version": None,
        "prompt_version": None,
        "quellen_version": None,
        "vorgaenger_hash": vorgaenger,
    })
    return {"format": FORMAT_KENNUNG, "format_fassung": FORMAT_FASSUNG,
            "app_id": stand["app_id"],
            "revision": stand["revision"] + 1,
            "zeit": zeit,
            "vorgaenger_hash": stand.get("datei_hash"),
            "beitraege": beitraege}


def _stand_fortschreiben(stand):
    """Eine Revision weiter, mit denselben Beitraegen. Rechnet, schreibt nicht.

    Zwei Wege brauchen das: "Speichern, spaeter weitermachen" (K05-M15) und
    "Bin fertig mit dem Interview" (K05-M19). Beide sind Speichervorgaenge im
    Sinne von K05-M26 und legen deshalb einen Stand an, ohne dass ein Beitrag
    hinzukaeme. Der neue Stand fuehrt dieselbe Beitragsliste und unterscheidet
    sich vom vorigen in Revision, Zeit und `vorgaenger_hash` -- die Kette
    laeuft bruchlos weiter, jeder Stand belegt seinen Vorgaenger.

    Sie steht als eigene Funktion und nicht zweimal ausgeschrieben: zwei
    Stellen, die dasselbe Format bilden, laufen auseinander -- und ein
    auseinandergelaufenes Format bricht die Rueckdeutbarkeit der alten Staende
    (K05-M25).
    """
    return {"format": FORMAT_KENNUNG, "format_fassung": FORMAT_FASSUNG,
            "app_id": stand["app_id"],
            "revision": stand["revision"] + 1,
            "zeit": None,
            "vorgaenger_hash": stand.get("datei_hash"),
            "beitraege": [dict(b) for b in stand["beitraege"]]}


def _beitraege(stand, gegenstand):
    """Alle Beitraege zu einem Gegenstand, in ihrer Reihenfolge."""
    return [b for b in stand["beitraege"] if b["gegenstand"] == gegenstand]


def _gueltig(stand, gegenstand):
    """Der geltende Beitrag zu einem Gegenstand -- der juengste, oder None.

    Der juengste gilt, die frueheren bleiben stehen (K05-D03: eine Aenderung
    ist sichtbar oder sie findet nicht statt). Es wird nichts entfernt und
    nichts ueberschrieben -- weder in der Datei noch in der Anzeige.
    """
    zeilen = _beitraege(stand, gegenstand)
    return zeilen[-1] if zeilen else None


def _ziele(stand):
    """Die Ziele mit ihrem Rang (K05-M05, K05-G04).

    Der Rang ist die Reihenfolge der Auswahl und wird hier ABGELESEN, nicht
    gerechnet: er steht am Beitrag, weil er eine Angabe des Nutzers ist. Das
    System bewertet ihn nicht -- es zaehlt ihn nicht einmal neu.
    """
    return sorted(_beitraege(stand, GEGENSTAND_ZIEL), key=lambda b: b["rang"])


# ===========================================================================
#  ABSCHNITT C · DIE MELDUNGEN
#
#  Jede einzeln benannt, jede fuer einen Menschen ohne IT-Kenntnisse lesbar
#  (CONTRIBUTING.md). Umlaute umschrieben wie im ganzen Bestand.
# ===========================================================================

# S-G, der gezeichnete Rueckfallweg. Wortgleiche Bauart wie
# MELDUNG_VORPRUEFUNG_1 in app/vorpruefung.py: der Satz sagt, WAS fehlt und
# WELCHER Weg offen bleibt -- sonst sucht der Nutzer den Fehler bei sich.
MELDUNG_THEMEN_FEHLEN = (
    "Die Liste der zwoelf haeufigen Themen ist noch nicht freigegeben. Sie "
    "koennen Ihr Thema in eigenen Worten beschreiben; das Feld darunter nimmt "
    "jeden Wortlaut an.")

MELDUNG_ZIELE_FEHLEN = (
    "Die Liste der sieben Ziele ist noch nicht freigegeben. Sie koennen Ihre "
    "Ziele in eigenen Worten eintragen; die Reihenfolge Ihrer Eintraege ist "
    "die Rangfolge.")

MELDUNG_FACHFRAGEN_FEHLEN = (
    "Die Fachfragen fuer dieses Gespraech sind noch nicht freigegeben. Sie "
    "koennen in eigenen Worten schreiben, was Ihnen wichtig ist; jeder Beitrag "
    "geht in das Interview-Protokoll ein.")

# Der Dateianhang. Er wird BENANNT und nicht angeboten -- ein ausgegrauter
# Knopf waere ein Versprechen (Blatt 100, Entscheidung 4).
MELDUNG_ANHANG_ZURUECKGESTELLT = (
    "Das Anhaengen von Dokumenten ist in dieser Fassung noch nicht verfuegbar. "
    "Ihre Antwort in eigenen Worten geht vollstaendig in das Protokoll ein.")

# Der Zustand `leer` je Aktion. Je Aktion ein eigener Satz: "Bitte fuellen Sie
# das Feld aus" sagt nicht, WELCHES Feld und WOZU.
MELDUNG_THEMA_LEER = (
    "Es ist noch kein Thema eingetragen. Beschreiben Sie in eigenen Worten, "
    "welchen Arbeitsalltag FREIRAUM verbessern soll; erst danach geht es "
    "weiter.")

MELDUNG_EINORDNUNG_LEER = (
    "Diese Frage ist noch offen. Solange sie offen ist, erscheint die naechste "
    "Frage nicht, und rechts bleibt die Zeile leer.")

MELDUNG_ZIEL_LEER = (
    "Es ist noch kein Ziel eingetragen. Die Rangfolge entsteht aus der "
    "Reihenfolge Ihrer Eintraege.")

MELDUNG_ANTWORT_LEER = (
    "Es ist kein Text eingegeben. Es wurde nichts gespeichert, und rechts ist "
    "kein Eintrag entstanden.")

MELDUNG_NAME_LEER = (
    "Es ist kein Name eingetragen. Ohne Namen bleibt das Vorhaben in Stufe 01; "
    "es wurde nichts geaendert.")

# K05-G05: die Bestaetigung ist ein Tor, keine Hoeflichkeit. Der Satz sagt,
# WAS fehlt -- nach demselben Massstab wie `fehlende_fragen` auf EN-04.
MELDUNG_AUSGANGSPROBLEM_FEHLT = (
    "Die Zusammenfassung Ihres Ausgangsproblems steht noch nicht. Sie entsteht "
    "aus Thema, Einordnung und Zielen; sobald diese Angaben vorliegen, koennen "
    "Sie sie bestaetigen.")

MELDUNG_AUSGANGSPROBLEM_OFFEN = (
    "Das Ausgangsproblem ist noch nicht bestaetigt. Ohne diese Bestaetigung "
    "gibt es keinen Namensschritt; es wurde nichts geaendert.")

# K05-M03: die Reihenfolge ist fest. Der Satz nennt die Frage, die vorher
# fehlt -- nicht bloss, dass etwas fehlt.
MELDUNG_REIHENFOLGE = (
    "Diese Frage kommt spaeter. Bitte beantworten Sie zuerst die vorherige "
    "Frage; es wurde nichts gespeichert.")

# K05-M11, Fehlerzustand von vorschlag_waehlen. Der Satz sagt ausdruecklich,
# dass es nicht an den Angaben des Nutzers liegt -- dieselbe Ueberlegung wie
# bei MELDUNG_BETRIEB in app/haupt.py.
MELDUNG_MARKE_UNKLAR = (
    "Die Herkunft dieses Eintrags laesst sich zurzeit nicht eindeutig "
    "bestimmen. Aus Vorsicht ist rechts kein Eintrag entstanden; Ihre Antwort "
    "bleibt waehlbar. Das liegt nicht an Ihren Angaben.")

# K05-M10: ohne gestellte Frage gibt es nichts zu ueberspringen.
MELDUNG_UEBERSPRINGEN_OHNE_FRAGE = (
    "Zu dieser Bedienung gehoert keine gestellte Frage. Es wurde nichts "
    "vermerkt, und es ist keine Frage verschwunden.")

# Der abgebrochene Dreischritt (K05-M26). Der vorige Stand bleibt gueltig, und
# der Satz sagt genau das -- sonst nimmt der Nutzer an, er habe alles verloren.
MELDUNG_SPEICHERN_GESCHEITERT = (
    "Das Speichern ist fehlgeschlagen. Ihr zuletzt gespeicherter Stand gilt "
    "unveraendert weiter; der Versuch laesst sich wiederholen. Das liegt nicht "
    "an Ihren Angaben.")

# Der Stand laesst sich nicht lesen -- Datei fort, Hash abweichend, Format
# unbekannt. Fail-closed: es wird NICHTS angezeigt und NICHTS geschrieben.
# Ein halber Stand waere schlimmer als keiner: der Nutzer schriebe auf einem
# Stand weiter, von dem niemand weiss, was er ist.
MELDUNG_STAND_NICHT_LESBAR = (
    "Der gespeicherte Gespraechsstand laesst sich zurzeit nicht sicher lesen. "
    "Aus Vorsicht wird er nicht angezeigt und nicht fortgeschrieben. Das liegt "
    "nicht an Ihren Angaben. Bitte wenden Sie sich an Ihre Ansprechperson.")

# K05-D06: keine Stufe ueberspringen, keine spaetere anspringen.
MELDUNG_STUFE_VORBEI = (
    "Dieser Schritt ist abgeschlossen. Zurueckliegende Stufen lassen sich "
    "ansehen, aber nicht mehr aendern; es wurde nichts geaendert.")

MELDUNG_STUFE_NOCH_NICHT = (
    "Dieser Schritt ist noch nicht an der Reihe. Bitte schliessen Sie zuerst "
    "die laufende Stufe ab; es wurde nichts geaendert.")

# Der Stufenwechsel ueber set_journey_phase ist abgewiesen worden. K05-M08
# und K05-M19: ohne Protokolleintrag kein Wechsel -- also auch keine halbe
# Auskunft.
MELDUNG_STUFENWECHSEL_GESCHEITERT = (
    "Der Wechsel in den naechsten Schritt ist nicht zustande gekommen. Es "
    "wurde nichts geaendert -- weder der Schritt noch Ihr Gespraechsstand. Das "
    "liegt nicht an Ihren Angaben.")

# KEINE MELDUNG FUER "NICHT VORHANDEN", und das ist Absicht. Objektbezug,
# Mandant, Mitgliedschaft und Eignung (K05-M24, K05-G01, K01-M15) fuehren alle
# auf denselben Weg: die Umleitung auf "/uebersicht", ohne Parameter und ohne
# Meldung. Der Entwurf hielt hier eine Meldung bereit und leitete zugleich auf
# einen Bildschirm um, der sie nicht anzeigen kann (`GET /uebersicht`,
# app/vorpruefung.py:570, nimmt keinen Parameter entgegen) -- eine Konstante,
# die nie jemand las. K01-M15 misst ohnehin die GLEICHHEIT der Antworten auf
# den fremden und auf den nirgends vergebenen Fall; die gleichmachende Antwort
# ist die Umleitung selbst, nicht ihr Text. Wer hier spaeter einen Text will,
# baut ihn auf EN-02 und damit bei K01, nicht hier.

# Die Quittung des Speicherwegs. Sie sagt, was gilt -- und verspricht nichts
# darueber hinaus (K05-M15: "Der Stand MUSS das Abmelden ueberleben").
MELDUNG_SPEICHERN_QUITTUNG = (
    "Ihr Gespraechsstand ist gespeichert. Sie koennen sich abmelden und "
    "spaeter an dieser Stelle weitermachen.")

# Die Quittung nach dem Interview. Sie verspricht nichts, was M5 nicht haelt:
# EN-07 ist nicht gebaut.
MELDUNG_INTERVIEW_FERTIG = (
    "Ihr Interview ist abgeschlossen und der Stand ist gespeichert. Die "
    "Auswertung Ihrer Angaben folgt in einem spaeteren Schritt.")


# ===========================================================================
#  ABSCHNITT D · DER ZUGANG -- K05-M24 UND K13-M05
# ===========================================================================


def _zurueck_auf_en01(merkmal):
    """Ohne gueltige Sitzung fuehrt kein Weg weiter -- K03-D01.

    Wortgleich zu `_zurueck_auf_en01` in app/haupt.py, app/vorpruefung.py und
    app/zweckbestimmung.py und bewusst nicht von dort eingebunden: app/haupt.py
    bindet diese Datei ein, der umgekehrte Weg waere ein Ringschluss beim
    Import. Wandert die Regel in eine gemeinsame Datei, wandern alle
    Ausfertigungen zusammen.
    """
    antwort = RedirectResponse("/anmeldung", status_code=UMLEITUNG)
    if merkmal:
        keks_loeschen(antwort)
    antwort.headers["Cache-Control"] = "no-store"
    return antwort


def _seite(request, vorlage, inhalt, status=200):
    antwort = VORLAGEN.TemplateResponse(request, vorlage, inhalt,
                                        status_code=status)
    # Auf diesen Seiten steht der Gespraechsstand im Wortlaut. In einem
    # Zwischenspeicher hat er nichts verloren (K03-M26, datensparsam).
    antwort.headers["Cache-Control"] = "no-store"
    return antwort


def _umleitung(ziel):
    antwort = RedirectResponse(ziel, status_code=UMLEITUNG)
    antwort.headers["Cache-Control"] = "no-store"
    return antwort


def _kennung(wert):
    """Eine Kennung aus dem Formular -- oder None. Fail-closed.

    Bewusst hier und nicht in der Datenbank: eine ungueltige Zeichenkette
    loeste dort einen Fehler aus, und ein Fehler ist keine Antwort. Dieselbe
    Bauart wie `_option_gehoert` in app/vorpruefung.py.
    """
    try:
        return uuid.UUID(str(wert).strip())
    except (ValueError, AttributeError):
        return None


def zugang_pruefen(conn, stand_sitzung, anwendung):
    """Konto, Mitgliedschaft, Rolle, Mandant, Objektbezug -- VOR allem anderen.

    K05-M24 im Wortlaut: "Jeder Aufruf aus den Stufen 01 und 02 MUSS ueber den
    Serverpfad laufen, der Konto, Mitgliedschaft, Rolle, Mandant und
    Objektbezug prueft". Das gezeichnete Akzeptanzkriterium schaerft nach: die
    Pruefung steht VOR jedem Lesen und Schreiben, und faellt eine Angabe aus,
    entsteht "keine Nutzdaten in der Antwort, keine neue oder geaenderte
    document-Zeile, kein event-Eintrag".

    Deshalb liest diese Funktion die Anwendungszeile MIT dem Mandanten in der
    Bedingung und liest den Gespraechsstand NICHT -- der kommt erst danach und
    nur, wenn hier etwas zurueckkommt.

    DAS KONTO prueft `sitzung_pruefen` bei jedem Aufruf gegen die Datenbank
    (K03-D01, status AKTIV). Es steht deshalb hier nicht ein zweites Mal: zwei
    Pruefungen desselben Zustands sind zwei Wahrheiten, sobald eine von beiden
    nachgezogen wird.

    DIE ROLLE FAELLT MIT DER MITGLIEDSCHAFT ZUSAMMEN (T-4, gez. 19.08.2026).
    Das Endnutzer-Portal fuehrt in Release 1 genau eine Rolle (F08 ueber
    K14-G04 und K20-M02); die Rolle steht als `role_id` in derselben
    `membership`-Zeile wie Portal und Reichweite (K20-M04). Gemessen wird
    deshalb die Mitgliedschaft im Portal ENDUSER mit Reichweite auf den
    Mandanten der Anwendung -- dasselbe Praedikat, das `set_journey_phase` in
    M32 fuehrt. Zwei verschiedene Praedikate fuer dieselbe Frage waeren zwei
    Wahrheiten, und die eine wuerde irgendwann milder.

    DIE EIGNUNG STEHT IN DERSELBEN BEDINGUNG. EN-05 · thema_waehlen ·
    berechtigung: "Vorbedingung ist ein fit_check mit outcome GEEIGNET
    (Eigentuemer K04)". Der `JOIN fit_check` traegt damit beide Negativfaelle,
    die das gezeichnete Kriterium zu K05-G01 fordert: (a) der Check traegt
    nicht GEEIGNET -- der JOIN findet nichts; (b) das Ergebnis ist nicht
    ermittelbar, weil `app.fit_check_id` leer ist -- der JOIN findet ebenso
    nichts. Fail-closed heisst hier woertlich: es wird nicht nachgesehen und
    dann abgelehnt, es wird gar nicht erst gefunden.

    DASS `create_app_after_fit` DIE EIGNUNG SCHON PRUEFT, IST KEIN ERSATZ. Die
    Zeile entsteht nur mit GEEIGNET (K01-M27) -- aber `app.fit_check_id` ist
    nullbar, und die Eignung kann sich nach der Anlage aendern. Der
    Bildschirmvertrag sagt es an anderer Stelle selbst: "Ein nullbarer
    Fremdschluessel im Schema ist keine Erlaubnis, ihn zu umgehen."

    Rueckgabe: die Anwendungszeile als Verzeichnis, oder None. None heisst in
    JEDEM Fall dasselbe -- unbekannte Kennung, fremder Mandant, fehlende
    Mitgliedschaft, fehlende oder verlorene Eignung. Der Aufrufer kann daraus
    nichts ableiten, und der Nutzer erfaehrt nichts, was er nicht ohnehin
    weiss (K01-M15).
    """
    kennung = _kennung(anwendung)
    if kennung is None:
        return None

    zeile = conn.execute(
        "SELECT a.id, a.tenant_id, a.project_no, a.name,"
        "       a.journey_phase::text, a.lifecycle_state::text"
        "  FROM app a"
        "  JOIN fit_check f ON f.id = a.fit_check_id"
        " WHERE a.id = %s AND a.tenant_id = %s AND a.deleted_at IS NULL"
        "   AND f.outcome = 'GEEIGNET' AND f.tenant_id = a.tenant_id"
        "   AND EXISTS (SELECT 1 FROM membership m"
        "                 JOIN role r ON r.id = m.role_id"
        "                WHERE m.actor_id = %s"
        "                  AND m.portal_code = 'ENDUSER'"
        "                  AND m.tenant_scope = a.tenant_id"
        "                  AND r.portal_code = 'ENDUSER')",
        (kennung, stand_sitzung["mandant"], stand_sitzung["actor_id"])
    ).fetchone()

    if zeile is None:
        # Ein Wort ins Protokoll des Betreibers, keines auf den Bildschirm.
        # Der Wortlaut nennt keine Kennung des Nutzers und keinen Mandanten
        # (K23-D09) -- nur, dass abgewiesen wurde.
        PROTOKOLL.warning(
            "Zugang abgewiesen: Konto %s hat auf die genannte Anwendung "
            "keinen Zugriff, sie besteht nicht, oder ihre Eignung steht nicht "
            "auf GEEIGNET (K05-M24, K05-G01, K01-M15). Es wurde weder gelesen "
            "noch geschrieben.", stand_sitzung["actor_id"])
        return None

    return {"id": zeile[0], "mandant": zeile[1], "projektnummer": zeile[2],
            "name": zeile[3], "stufe": zeile[4], "zustand": zeile[5]}


def stufe_pruefen(app, erwartet):
    """Steht die Anwendung auf der Stufe, die dieser Weg voraussetzt? (K05-D06)

    Rueckgabe: None, wenn der Weg offen ist; sonst die Meldung, mit der er
    abzuweisen ist. Es wird nichts geaendert.

    ZWEI VERSCHIEDENE ABWEISUNGEN, und sie werden nicht vermischt: eine
    zurueckliegende Stufe ist abgeschlossen ("Nur-Ansicht", K05-D06), eine
    spaetere ist noch nicht an der Reihe. Wer nur "nicht moeglich" liest,
    versucht es an der falschen Stelle noch einmal.

    FAIL-CLOSED (K05-G01): ein Stufenwert, den diese Datei nicht kennt, sperrt.
    `journey_phase` fuehrt fuenf Werte; kaeme ein sechster hinzu, waere er hier
    gesperrt, bis jemand ihn ausdruecklich eintraegt.
    """
    ordnung = ["ORIENTIERUNG", "INTERVIEW", "UEBERSICHT", "PROTOTYP", "ANGEBOT"]
    if app["stufe"] not in ordnung or erwartet not in ordnung:
        return MELDUNG_STAND_NICHT_LESBAR
    if app["stufe"] == erwartet:
        return None
    if ordnung.index(app["stufe"]) > ordnung.index(erwartet):
        return MELDUNG_STUFE_VORBEI
    return MELDUNG_STUFE_NOCH_NICHT


# ===========================================================================
#  ABSCHNITT E · DER DREISCHRITT -- K05-M26
# ===========================================================================

# Die Aktion des Protokolleintrags. EIN Wert fuer alle Speichervorgaenge:
# der juengste Eintrag je Anwendung bestimmt den Stand (K05-M26), und "der
# juengste" laesst sich nur ueber einen einzigen Aktionsnamen finden. Zwei
# Namen hiessen zwei Ketten, und die Wiederaufnahme muesste raten.
#
# `event.action` ist im Zielschema `text NOT NULL` ohne Aufzaehlungstyp
# (freiraum_datamodel.sql, Tabelle `event`); der Wert traegt also. Geprueft
# und nicht angenommen -- derselbe Weg wie bei 'TERMIN_ANGEFRAGT' in
# app/vorpruefung.py.
AKTION_STAND = "app.gespraechsstand.gespeichert"


class DreischrittGescheitert(RuntimeError):
    """Der Dreischritt ist abgebrochen. Nichts davon ist sichtbar geworden.

    Eigene Klasse, damit der Aufrufer sie ENG faengt und in die benannte
    Meldung uebersetzt. Ihr Wortlaut nennt Schluessel und Kennungen und geht
    deshalb nur ins Protokoll des Betreibers (K23-D09).
    """


def _objektbezug(dokument_id, dateihash):
    """`object_ref` nennt Dokumentkennung UND Hash -- K05-M26 im Wortlaut.

    Beides in EINEM Feld, weil `event` kein zweites hat, das den Hash truege.
    Die Form ist fest und wird an genau einer Stelle gebildet und an genau
    einer gelesen (`_bezug_lesen`); zwei Stellen liefen auseinander.

    NICHT ueber `event.document_id` und `event.document_version`. Geprueft und
    verworfen: die beiden Spalten aus M30 zeigen zusammen auf eine Zeile in
    `document_version` (Bedingung `event_document_fk`), und `document_version`
    traegt einen `daterange` mit Ausschlussbedingung -- zwei Staende desselben
    Tages passten dort nicht nebeneinander. Ein Gespraech, das zweimal an
    einem Vormittag speichert, waere damit gesperrt. K05-M26 nennt ohnehin
    `object_ref` und keine der beiden Spalten.
    """
    return f"document:{dokument_id}#sha256:{dateihash}"


def _bezug_lesen(bezug):
    """Aus `object_ref` wieder Kennung und Hash -- oder (None, None)."""
    if not bezug or not bezug.startswith("document:") or "#sha256:" not in bezug:
        return None, None
    kennung, _, dateihash = bezug[len("document:"):].partition("#sha256:")
    return _kennung(kennung), dateihash


def dreischritt(conn, sitzung, app, stand_neu, *, neuer_name=None,
                ziel_stufe=None):
    """Datei, dann `document`-Zeile, dann `event` -- in dieser Reihenfolge.

    K05-M26 im Wortlaut: "Jeder erfolgreiche Speichervorgang erzeugt zuerst die
    Datei, dann die `document`-Zeile und zuletzt ein append-only `event`."

    SCHRITT 1 LAEUFT AUSSERHALB DER TRANSAKTION, und das ist kein Mangel,
    sondern die Reihenfolge selbst. Die Ablage kennt keine Transaktion der
    Datenbank; sie in eine hineinzuziehen ginge nur ueber einen zweiten
    Zustandsraum, den niemand gezeichnet hat. Was stattdessen traegt: die
    Datei ist erst sichtbar, wenn ein `event`-Eintrag auf sie zeigt. Bricht
    Schritt 2 oder 3 ab, wird sie GESPERRT -- vierte Verrichtung der Ablage --
    und liegt in der Quarantaene, weder sichtbar noch verschwunden.

    SCHRITT 2 UND 3 LAUFEN IN EINER TRANSAKTION (K02-D04, K13-M20). Und in
    derselben Transaktion laufen, wenn sie verlangt sind:

      `neuer_name`  das UPDATE auf `app.name` (K05-M07, Traeger K01)
      `ziel_stufe`  der Aufruf von `set_journey_phase` (M32), der seinerseits
                    prueft und seinen eigenen Protokolleintrag schreibt

    Damit ist K05-M08 buchstaeblich erfuellt: "scheitert eines von beiden,
    steht keines von beiden". Ein Name ohne Stufenwechsel, eine Stufe ohne
    Protokolleintrag oder ein Stufenwechsel ohne gespeicherten Stand kann hier
    nicht entstehen -- nicht, weil es nachgeprueft wird, sondern weil alles
    dasselbe Zurueckrollen teilt.

    DIE UHR IST DIE DER DATENBANK. Der Zeitpunkt in der Datei kommt aus
    `now()` derselben Verbindung, die gleich den Eintrag schreibt. Zwei Uhren
    waeren zwei Wahrheiten, und der Nachweis stuende dann zwischen ihnen.

    Rueckgabe: (Dokumentkennung, Dateihash). Bei jedem Abbruch wird
    `DreischrittGescheitert` ausgeworfen -- und der vorige Stand gilt weiter,
    weil sein Eintrag weiter der juengste ist.
    """
    zeit = conn.execute("SELECT now()").fetchone()[0]
    stand_neu = dict(stand_neu, zeit=zeit.isoformat())
    for beitrag in stand_neu["beitraege"]:
        if beitrag["zeit"] is None:
            beitrag["zeit"] = zeit.isoformat()

    daten = _kanonisch(stand_neu)
    schluessel = _ablageschluessel()

    # --- Schritt 1 · die Datei -------------------------------------------
    try:
        belege = ablage().schreiben(schluessel, daten)
    except AblageFehler as fehler:
        PROTOKOLL.error(
            "Dreischritt abgebrochen in Schritt 1 (Datei): %s. Es ist keine "
            "document-Zeile und kein event-Eintrag entstanden (K05-M26).",
            fehler)
        raise DreischrittGescheitert("Schritt 1") from fehler

    dateiname = (f"Gespraechsstand_{app['projektnummer']}"
                 f"_r{stand_neu['revision']}.json")

    try:
        # --- Schritt 2 und 3 · document, dann event ----------------------
        with conn.transaction():
            zeile = conn.execute(
                "INSERT INTO document (app_id, kind, filename, content_ref,"
                "                      content_sha256, content_media_type,"
                "                      content_size_bytes)"
                " VALUES (%s, 'INTERVIEW_PROTOCOL', %s, %s, %s, %s, %s)"
                " RETURNING id",
                (app["id"], dateiname, schluessel, belege["sha256"],
                 MEDIENART, belege["groesse"])).fetchone()
            dokument_id = zeile[0]

            # `actor_label` steht mit im INSERT, weil die Bedingung
            # `event_actor_paarweise` Verknuepfung und Namensschnappschuss
            # gemeinsam verlangt (K02-G13). `tenant_id` ist der des
            # Fachobjekts (K02-M21) und kommt aus der gelesenen
            # Anwendungszeile, nicht aus der Sitzung -- eine zweite Quelle
            # waere eine zweite Wahrheit.
            #
            # `retention_class` steht NICHT im INSERT: M30 setzt die Vorgabe
            # 'EREIGNIS' (Zeile 1493), und die Klasse des DOKUMENTS wird gar
            # nicht gespeichert, sondern in der Sicht `retention_due`
            # abgeleitet (KI_NACHWEIS fuer alles, was nicht ORDER oder SBOM
            # ist). Wer sie hier setzte, traefe eine Festlegung, die auf Rang 1
            # bereits getroffen ist.
            conn.execute(
                "INSERT INTO event (occurred_at, project_no, tenant_id,"
                "                   actor_id, actor_label, action, object_ref,"
                "                   change_type, value, source)"
                " VALUES (%s, %s, %s, %s, %s, %s, %s, 'Neuanlage', %s,"
                "         'PORTAL_ACTION')",
                (zeit, app["projektnummer"], app["mandant"],
                 sitzung["actor_id"], sitzung["anzeigename"], AKTION_STAND,
                 _objektbezug(dokument_id, belege["sha256"]),
                 (f"Revision {stand_neu['revision']}, "
                  f"{len(stand_neu['beitraege'])} Beitraege")))

            if neuer_name is not None:
                # DER NAME HAT KEINEN SERVERBEFEHL -- benannt, nicht
                # verschwiegen. M32 baut `set_journey_phase`, nicht
                # `set_app_name`. Solange der Serverpfad als Eigentuemer
                # verbindet, traegt dieses UPDATE (und wird seit M32 von der
                # Zeilenregel MIT FORCE gefiltert); sobald er als `fr_portal`
                # verbindet, faellt es aus -- `fr_portal` hat auf `app` nur
                # SELECT, auf jeder einzelnen Spalte (gemessen am 19.08.2026,
                # Kopf von M32). Das ist ein offener Punkt fuer den naechsten
                # Migrationszug und keine Bauentscheidung dieser Datei.
                #
                # Der Mandant steht auch hier in der Bedingung, nicht nur die
                # Kennung (K01-M15). Trifft das UPDATE nicht genau eine Zeile,
                # wird der ganze Vorgang zurueckgerollt: ein gespeicherter
                # Stand mit einem Namen, den die Anwendung nicht traegt, waere
                # ein Nachweis ueber etwas, das nicht geschehen ist.
                getroffen = conn.execute(
                    "UPDATE app SET name = %s, updated_at = %s"
                    " WHERE id = %s AND tenant_id = %s",
                    (neuer_name, zeit, app["id"], app["mandant"])).rowcount
                if getroffen != 1:
                    raise DreischrittGescheitert(
                        f"UPDATE app.name traf {getroffen} Zeilen statt einer")

            if ziel_stufe is not None:
                # DER EINZIGE SCHREIBWEG FUER DIE STUFE (M32). Kein UPDATE auf
                # `journey_phase` -- hier nicht und nirgends. Die Funktion
                # prueft Konto, Mandant und Mitgliedschaft selbst und schreibt
                # den Protokolleintrag im selben Zug (K05-M08, K05-M19).
                #
                # Dass sie dieselben Angaben ein zweites Mal prueft, ist keine
                # Doppelung, sondern Anzeige und Riegel: `zugang_pruefen`
                # entscheidet, was der Bildschirm anbietet; die Funktion
                # entscheidet, was geschieht. Zwischen beiden liegt Zeit.
                conn.execute("SELECT set_journey_phase(%s, %s, %s)",
                             (app["id"], ziel_stufe, sitzung["actor_id"]))
    except (psycopg.Error, DreischrittGescheitert) as fehler:
        # Der Grund geht ins Protokoll des Betreibers, nicht auf den
        # Bildschirm (K23-D09). Und die Datei aus Schritt 1 wird gesperrt: sie
        # ist verwaist, denn kein Eintrag zeigt auf sie.
        PROTOKOLL.error(
            "Dreischritt abgebrochen nach Schritt 1; nichts davon ist sichtbar "
            "geworden (K05-M26). Der vorige Stand gilt weiter. Grund: %s",
            fehler)
        try:
            ablage().sperren(schluessel, "verwaist nach abgebrochenem Dreischritt")
        except AblageFehler as sperrfehler:
            # Sperren gescheitert. Das ist zu melden und nicht zu verschlucken
            # -- ein Objekt, das weder gesperrt noch als verwaist gemeldet
            # waere, wuesste niemand.
            PROTOKOLL.error("Verwaistes Ablageobjekt nicht sperrbar: %s",
                            sperrfehler)
        raise DreischrittGescheitert(str(fehler)) from fehler

    return dokument_id, belege["sha256"]


def stand_lesen(conn, app):
    """Der wiederaufnehmbare Stand -- ueber den juengsten Eintrag (K05-M26).

    "Der juengste erfolgreiche Eventeintrag je Anwendung verweist in
    `object_ref` auf Dokument-ID und Hash und bestimmt den wiederaufnehmbaren
    Stand." Genau diesen Weg geht diese Funktion, und keinen anderen:

      1  den juengsten `event`-Eintrag dieser Anwendung mit dieser Aktion
      2  aus `object_ref` Dokumentkennung und Hash
      3  die `document`-Zeile -- MIT `app_id` in der Bedingung (Objektbezug)
      4  das Objekt aus der Ablage, und den Hash pruefen (K05-M27)
      5  das Format lesen

    NICHT ueber "die juengste document-Zeile". Das saehe gleichwertig aus und
    waere es nicht: eine `document`-Zeile aus einem abgebrochenen Dreischritt
    (Schritt 2 gelungen, Schritt 3 nicht) waere dann der neueste Stand -- und
    genau das schliesst "ein unvollstaendiger Dreischritt wird nicht sichtbar"
    aus. Die Sichtbarkeit haengt am letzten Schritt.

    JE ANWENDUNG heisst hier: ueber `project_no`. `event` traegt keine
    `app_id`, wohl aber `project_no` mit Fremdschluessel auf `app.project_no`,
    und die Projektnummer ist eindeutig (`app.project_no ... UNIQUE`). Das ist
    dieselbe Anwendung, nicht eine aehnliche.

    DER HASH WIRD BEI JEDEM LESEN GEPRUEFT, nicht nur beim Anlegen. Stimmt er
    nicht, wird das Objekt gesperrt und NICHTS zurueckgegeben: ein Stand,
    dessen Inhalt sich geaendert hat, ist kein unveraenderlicher Nachweis mehr
    (K05-M25), und ihn trotzdem anzuzeigen hiesse, den Nachweis zu verlassen
    und weiterzuarbeiten.

    Rueckgabe: (Stand, None) oder (None, Meldung). Ein leeres Gespraech ist
    KEIN Fehler -- es kommt der leere Stand zurueck, und der Bildschirm zeigt
    seinen Zustand `leer`.
    """
    # ZWEI ZEILEN, NICHT EINE -- und das ist kein Vorrat, sondern die Frage,
    # ob "der juengste" ueberhaupt bestimmt ist. `event` traegt keine laufende
    # Nummer; die Kennung ist eine Zufallszahl. Der Entwurf ordnete
    # "occurred_at DESC, id DESC" und liess damit bei gleicher Zeit den Zufall
    # entscheiden, welcher Stand der neueste ist. K05-M26 verlangt DEN
    # juengsten Eintrag; wo zwei gleich alt sind, gibt es ihn nicht, und
    # fail-closed heisst dann sperren statt wuerfeln (K05-G01).
    zeilen = conn.execute(
        "SELECT object_ref, occurred_at FROM event"
        " WHERE project_no = %s AND action = %s AND tenant_id = %s"
        " ORDER BY occurred_at DESC LIMIT 2",
        (app["projektnummer"], AKTION_STAND, app["mandant"])).fetchall()
    if not zeilen:
        return _stand_leer(app["id"]), None
    if len(zeilen) == 2 and zeilen[0][1] == zeilen[1][1]:
        PROTOKOLL.error(
            "Gespraechsstand nicht lesbar: zwei Protokolleintraege tragen "
            "denselben Zeitpunkt; welcher der juengste ist, steht nicht fest "
            "(K05-M26). Es wird nichts angezeigt und nichts fortgeschrieben.")
        return None, MELDUNG_STAND_NICHT_LESBAR
    zeile = zeilen[0]

    dokument_id, dateihash = _bezug_lesen(zeile[0])
    if dokument_id is None or not dateihash:
        PROTOKOLL.error(
            "Gespraechsstand nicht lesbar: object_ref des juengsten Eintrags "
            "nennt nicht Dokumentkennung und Hash (K05-M26).")
        return None, MELDUNG_STAND_NICHT_LESBAR

    dokument = conn.execute(
        "SELECT content_ref, content_sha256 FROM document"
        " WHERE id = %s AND app_id = %s AND kind = 'INTERVIEW_PROTOCOL'",
        (dokument_id, app["id"])).fetchone()
    if dokument is None or not dokument[0]:
        PROTOKOLL.error(
            "Gespraechsstand nicht lesbar: zum juengsten Eintrag besteht keine "
            "document-Zeile dieser Anwendung.")
        return None, MELDUNG_STAND_NICHT_LESBAR

    schluessel, hash_zeile = dokument
    if hash_zeile != dateihash:
        # Der Eintrag und die Zeile nennen verschiedene Haende. Einer von
        # beiden ist nicht der, fuer den er sich ausgibt -- welcher, entscheidet
        # diese Datei nicht. Fail-closed (K05-G01).
        PROTOKOLL.error(
            "Gespraechsstand nicht lesbar: der Hash im Protokolleintrag und "
            "der in der document-Zeile stimmen nicht ueberein.")
        return None, MELDUNG_STAND_NICHT_LESBAR

    try:
        if not ablage().hash_pruefen(schluessel, dateihash):
            ablage().sperren(schluessel, "Hash weicht vom gefuehrten Wert ab")
            PROTOKOLL.error(
                "Gespraechsstand nicht lesbar: der Inhalt des Objekts stimmt "
                "nicht mit content_sha256 ueberein; das Objekt ist gesperrt "
                "(K05-M25, K05-M27).")
            return None, MELDUNG_STAND_NICHT_LESBAR
        roh = ablage().lesen(schluessel)
    except AblageFehler as fehler:
        PROTOKOLL.error("Gespraechsstand nicht lesbar: %s", fehler)
        return None, MELDUNG_STAND_NICHT_LESBAR

    try:
        stand = json.loads(roh.decode("utf-8"))
    except (UnicodeDecodeError, ValueError) as fehler:
        PROTOKOLL.error("Gespraechsstand nicht lesbar: kein gueltiges Format "
                        "(%s).", fehler)
        return None, MELDUNG_STAND_NICHT_LESBAR

    if (not isinstance(stand, dict)
            or stand.get("format") != FORMAT_KENNUNG
            or stand.get("format_fassung") != FORMAT_FASSUNG
            or stand.get("app_id") != str(app["id"])
            or not isinstance(stand.get("beitraege"), list)):
        # Fail-closed: ein Stand, dessen Format oder Zugehoerigkeit nicht
        # feststeht, wird nicht angezeigt und nicht fortgeschrieben. Die
        # Pruefung auf `app_id` ist dabei die zweite Haelfte des Objektbezugs:
        # sie faellt auf, wenn eine Datei an der falschen Anwendung haengt.
        PROTOKOLL.error("Gespraechsstand nicht lesbar: Format oder "
                        "Zugehoerigkeit stimmen nicht.")
        return None, MELDUNG_STAND_NICHT_LESBAR

    # Der Hash der eigenen Datei wandert in den Stand -- nicht als Feld der
    # Datei (er stuende dann in sich selbst), sondern als Angabe fuer den
    # naechsten Stand, der ihn als `vorgaenger_hash` fuehrt.
    stand["datei_hash"] = dateihash
    return stand, None


# ===========================================================================
#  ABSCHNITT F · DIE BAUSAETZE FUER DIE BEIDEN BILDSCHIRME
#
#  Die Vorlagen entstehen in Zug 5. Hier steht, was sie bekommen -- und zwar
#  fertig aufbereitet: der Bildschirm entscheidet nichts, er zeigt.
# ===========================================================================


def ausgangsproblem(stand):
    """Die Zusammenfassung des Ausgangsproblems -- oder None (K05-M06).

    SIE STAMMT AUSSCHLIESSLICH AUS DEN ANGABEN DES NUTZERS, im Wortlaut, in
    der Reihenfolge des Bildschirms. Kein Modell ist beteiligt, und deshalb
    traegt sie die Marke "Ihre Angabe" und nicht "KI-Notiz".

    WARUM NICHT AUS EINEM MODELL: K05-M06 verlangt, dass das Ausgangsproblem
    "zusammengefasst angezeigt" wird; es sagt NICHT, wer zusammenfasst. In M5
    gibt es keinen Modellpfad (K17 ist nicht gebaut, K05-M23 waere nicht
    erfuellbar). Eine Zusammenfassung, die dem Nutzer seine eigenen Worte
    geordnet zurueckgibt, erfindet nichts und behauptet nichts. Ob der
    Eigentuemer stattdessen eine Zusammenfassung der Modelle will, ist eine
    Frage an ihn und steht in der Vorlage.

    Rueckgabe: None, solange Thema, alle drei Einordnungen oder das erste Ziel
    fehlen. Dann ist die Schaltflaeche ausgeblendet und an ihrer Stelle steht
    der Hinweis (K05-G05, K19-M06) -- genau der Zustand `leer` des Vertrags.
    """
    thema = _gueltig(stand, GEGENSTAND_THEMA)
    einordnung = [_gueltig(stand, f["gegenstand"]) for f in EINORDNUNG]
    ziele = _ziele(stand)
    if thema is None or not all(einordnung) or not ziele:
        return None
    return {
        "thema": thema["wortlaut"],
        "einordnung": [{"ueberschrift": f["ueberschrift"],
                        "wortlaut": b["wortlaut"]}
                       for f, b in zip(EINORDNUNG, einordnung)],
        "ziele": [{"rang": z["rang"], "wortlaut": z["wortlaut"]} for z in ziele],
        "herkunft": HERKUNFT_WORTLAUT[HERKUNFT_MENSCH],
    }


def rechte_spalte(stand):
    """Die rechte Spalte, fertig gebaut -- K05-M11, K05-M13, K19-Kasten.

    JEDER INHALTLICHE EINTRAG TRAEGT GENAU EINE MARKE, und diese Funktion ist
    die einzige Stelle, die sie herausgibt. Der Uebersprungvermerk traegt
    KEINE (K05-M10) und zaehlt nicht als inhaltlicher Eintrag (K05-M11) -- er
    ist deshalb hier als eigener Eintragstyp gefuehrt und nicht als Eintrag
    mit leerer Marke. Eine leere Marke waere eine Marke.

    Was hier NICHT geschieht: es wird nichts zusammengefasst, nichts
    umformuliert und nichts ersetzt (K05-D03). Frueher gegebene Beitraege
    bleiben in der Liste stehen; `gilt` sagt, welcher der geltende ist.
    """
    eintraege = []
    for beitrag in stand["beitraege"]:
        if beitrag["gegenstand"] == GEGENSTAND_UEBERSPRUNGEN:
            eintraege.append({"art": "vermerk",
                              "wortlaut": VERMERK_UEBERSPRUNGEN,
                              "marke": None,
                              "im_kasten": True,
                              "reihenfolge": beitrag["reihenfolge"]})
            continue
        eintraege.append({
            "art": "inhalt",
            "gegenstand": beitrag["gegenstand"],
            "wortlaut": beitrag["wortlaut"],
            "marke": HERKUNFT_WORTLAUT[beitrag["herkunft"]],
            "bearbeitet": beitrag["bearbeitungszustand"] == ZUSTAND_BEARBEITET,
            "ersetzt": beitrag["ersetzt"],
            "rang": beitrag["rang"],
            # In welchem Kasten dieser Eintrag steht, entscheidet nicht der
            # Bildschirm. Die sechs Zeilen von "IHR STAND" auf EN-05 stehen im
            # Kasten (K19_build_referenz.md:254-260); ein Beitrag der Stufe 02
            # gehoert in die ZUSAMMENFASSUNG von EN-06 (:269-273). Das Thema
            # steht in keinem der beiden Kaesten -- es wird links gewaehlt und
            # im Stand gefuehrt. Mit `im_kasten` traegt Zug 5 die Entscheidung
            # nicht, sondern liest sie ab (F41).
            "im_kasten": (beitrag["gegenstand"] in IM_KASTEN_EN05
                          or beitrag["stufe"] == "INTERVIEW"),
            "reihenfolge": beitrag["reihenfolge"],
        })
    return eintraege


def teilnehmer(sitzung):
    """Die Teilnehmer des Gespraechs -- K05-M16.

    "Mindestens den angemeldeten Nutzer und den Assistenten als Moderator."
    Die Liste ist nicht abgeschlossen; eingeladene Mitarbeiter treten hinzu
    (K05-M17) -- die Einladung gehoert K20 und ist hier nicht gebaut, deshalb
    stehen heute genau zwei darin und keine Andeutung eines dritten.
    """
    return [{"rolle": "Sie", "name": sitzung["anzeigename"]},
            {"rolle": "Moderation", "name": "FREIRAUM-Assistent"}]


# ===========================================================================
#  ABSCHNITT G · EN-05 · Stufe 01 Orientierung
# ===========================================================================


def _en05(request, sitzung, app, stand, meldung=None, hinweis=None):
    """Der Bildschirm EN-05. Er entscheidet nichts -- er zeigt, was gelesen wurde.

    ZWEI VERSCHIEDENE ANSAGEN, und sie werden nicht vermischt -- dieselbe
    Trennung wie auf EN-04 (app/vorpruefung.py):

      `meldung`  blickt ZURUECK auf einen abgeschlossenen Vorgang: eine
                 Abweisung, ein gescheitertes Speichern.
      `hinweis`  blickt NACH VORN auf die Bedingung des naechsten Schritts und
                 steht an der Stelle der Schaltflaeche, die er benennt
                 (K19-M06).
    """
    return _seite(request, "en05_orientierung.html", {
        "anzeigename": sitzung["anzeigename"],
        "anwendung": str(app["id"]),
        "projektnummer": app["projektnummer"],
        "stufe": app["stufe"],
        "nur_ansicht": app["stufe"] != "ORIENTIERUNG",
        "themen_hinweis": MELDUNG_THEMEN_FEHLEN,
        "ziele_hinweis": MELDUNG_ZIELE_FEHLEN,
        "einordnung": EINORDNUNG,
        "naechste_einordnung": _naechste_einordnung(stand),
        "eintraege": rechte_spalte(stand),
        "ziele": _ziele(stand),
        "ausgangsproblem": ausgangsproblem(stand),
        "bestaetigt": _gueltig(stand, GEGENSTAND_AUSGANGSPROBLEM) is not None,
        # Das Namensfeld ist LEER und ueberschreibbar. Ein Vorschlag mit Marke
        # entstuende nur aus einem Modell, und das gibt es hier nicht
        # (K05-M07, K05-D04 -- im Kopf als halbe Umsetzung benannt).
        "name_vorschlag": "",
        "name_marke": None,
        "teilnehmer": teilnehmer(sitzung),
        "meldung": meldung,
        "hinweis": hinweis,
    })


def _naechste_einordnung(stand):
    """Welche der drei Einordnungsfragen ist an der Reihe? (K05-M03)

    Rueckgabe: die Frage, oder None, wenn alle drei beantwortet sind. Die
    Reihenfolge steht in EINER Liste (`EINORDNUNG`) und wird hier nur
    abgelaufen -- der Bildschirm sortiert nicht, und der Serverbefehl prueft
    gegen dieselbe Liste. Zwei Reihenfolgen waeren zwei Wahrheiten.
    """
    for feld in EINORDNUNG:
        if _gueltig(stand, feld["gegenstand"]) is None:
            return feld
    return None


def _en05_zeigen(request, conn, sitzung, app, meldung=None, hinweis=None):
    """Stand lesen und EN-05 bauen -- oder begruendet abweisen.

    Diese eine Stelle traegt alle Vorbedingungen der Anzeige, damit sie nicht
    in sechs Routen je einmal stehen und dort auseinanderlaufen.
    """
    stand, fehler = stand_lesen(conn, app)
    if stand is None:
        return _seite(request, "en05_orientierung.html", {
            "anzeigename": sitzung["anzeigename"],
            "anwendung": str(app["id"]),
            "gesperrt": True, "meldung": fehler}, status=503)
    return _en05(request, sitzung, app, stand, meldung=meldung, hinweis=hinweis)


def _vorbereiten(request, conn, merkmal, anwendung, erwartete_stufe):
    """Sitzung, Zugang, Stufe und Stand -- in dieser Reihenfolge, vor allem.

    Rueckgabe: (sitzung, app, stand, None) oder (None, None, None, Antwort).
    Die Antwort ist fertig; der Aufrufer gibt sie unveraendert zurueck.

    DIE REIHENFOLGE IST DER PUNKT (K05-M24, K13-M05). Erst die Sitzung (und
    mit ihr der Kontozustand), dann Mitgliedschaft, Mandant und Objektbezug,
    dann die Stufe -- und ERST DANN wird der Gespraechsstand gelesen. Faellt
    eine der Angaben aus, ist keine Nutzdatenzeile angefasst worden, kein
    Objekt gelesen und nichts geschrieben.
    """
    sitzung = sitzung_pruefen(conn, merkmal_lesen(merkmal))
    if sitzung is None:
        return None, None, None, _zurueck_auf_en01(merkmal)

    # DER MANDANT WIRD GESETZT, BEVOR DIE ERSTE FACHLICHE ZEILE GELESEN WIRD.
    # Ohne diese Zeile liefe der ganze M5-Weg an den Zeilenregeln aus M32
    # vorbei: `sitzungs_mandant()` laesst eine fehlende Einstellung
    # ausdruecklich durch, und `document` haengt allein an ihr (K05-M27).
    #
    # WARUM HIER UND NICHT IN JEDER ROUTE: alle elf Wege dieser Datei kommen
    # durch `_vorbereiten`, und zwar als Erstes. Elf Klammern waeren elf
    # Stellen, an denen eine vergessen werden kann.
    #
    # WARUM SITZUNGSWEIT (`false`) UND NICHT TRANSAKTIONSLOKAL: die Klammer
    # muesste sonst den ganzen fachlichen Teil der Route umfassen, und der
    # endet in elf verschiedenen Zweigen. Sitzungsweit gilt sie fuer die
    # Verbindung -- und `verbindung()` oeffnet eine je Aufruf und schliesst
    # sie danach. Der Entwurf vom 19.08. hat diesen Weg selbst geprueft und
    # verworfen, mit einer Bedingung, die heute nicht zutrifft: "es traegt
    # nur, solange jede Anfrage ihre eigene Verbindung oeffnet, und wird in
    # dem Augenblick falsch, in dem jemand einen Verbindungspool einzieht."
    # GENAU DAS IST DIE STELLE, an der diese Zeile zu aendern ist -- wer
    # einen Pool einzieht, aendert sie mit, sonst traegt eine Verbindung den
    # Mandanten der vorigen Sitzung weiter. Der Satz steht hier, damit er
    # gefunden wird: `grep -n "Verbindungspool" app/`.
    conn.execute("SELECT set_config('freiraum.tenant_id', %s, false)",
                 (str(sitzung["mandant"]),))

    app = zugang_pruefen(conn, sitzung, anwendung)
    if app is None:
        return None, None, None, _umleitung("/uebersicht")

    sperre = stufe_pruefen(app, erwartete_stufe)
    if sperre is not None:
        PROTOKOLL.warning(
            "Aufruf abgewiesen: die Anwendung steht auf Stufe %s, der Weg "
            "setzt %s voraus. Es wurde nichts geaendert (K05-D06).",
            app["stufe"], erwartete_stufe)
        vorlage = ("en05_orientierung.html" if erwartete_stufe == "ORIENTIERUNG"
                   else "en06_interview.html")
        return None, None, None, _seite(request, vorlage, {
            "anzeigename": sitzung["anzeigename"],
            "anwendung": str(app["id"]),
            "nur_ansicht": True, "meldung": sperre})

    stand, fehler = stand_lesen(conn, app)
    if stand is None:
        vorlage = ("en05_orientierung.html" if erwartete_stufe == "ORIENTIERUNG"
                   else "en06_interview.html")
        return None, None, None, _seite(request, vorlage, {
            "anzeigename": sitzung["anzeigename"],
            "anwendung": str(app["id"]),
            "gesperrt": True, "meldung": fehler}, status=503)

    return sitzung, app, stand, None


@router.get("/orientierung", response_class=HTMLResponse)
def orientierung(request: Request, anwendung: str = ""):
    """EN-05. AENDERT NICHTS.

    Zustand `laden` des Vertrags ist ein Zustand des BILDSCHIRMS ("zwoelf
    Themen geladen; die Gespraechsspalte bleibt inaktiv, bis sie stehen") und
    entsteht in Zug 5. Diese Datei traegt `leer`, `Erfolg` und `Fehler`.

    ZURUECKLIEGENDE STUFEN OEFFNEN SICH ALS NUR-ANSICHT (K05-D06). Deshalb
    weist diese Route die Stufe nicht ab, sondern zeigt sie mit `nur_ansicht`;
    die schreibenden Wege weisen ab. Ein Bildschirm, der gar nicht mehr
    aufginge, waere keine Nur-Ansicht, sondern eine Sperre.

    EN-05 IST DIE ERSTE STUFE -- vor ihr liegt nichts. Der Fall "zu frueh"
    kann hier deshalb nur eintreten, wenn `journey_phase` einen Wert traegt,
    den diese Datei nicht kennt; dann sperrt sie (K05-G01), statt eine
    Nur-Ansicht auf einen unbekannten Stand zu oeffnen.
    """
    merkmal = request.cookies.get(KEKS_NAME)
    with verbindung() as conn:
        sitzung = sitzung_pruefen(conn, merkmal_lesen(merkmal))
        if sitzung is None:
            return _zurueck_auf_en01(merkmal)
        app = zugang_pruefen(conn, sitzung, anwendung)
        if app is None:
            return _umleitung("/uebersicht")
        sperre = stufe_pruefen(app, "ORIENTIERUNG")
        if sperre is not None and sperre is not MELDUNG_STUFE_VORBEI:
            return _seite(request, "en05_orientierung.html", {
                "anzeigename": sitzung["anzeigename"],
                "anwendung": str(app["id"]),
                "gesperrt": True, "meldung": sperre}, status=503)
        return _en05_zeigen(request, conn, sitzung, app)


@router.post("/orientierung/thema", response_class=HTMLResponse)
def record_topic(request: Request,
                 anwendung: str = Form(default=""),
                 wortlaut: str = Form(default="")):
    """record_topic -- die offenste Frage zuerst (K05-M01, K05-M02).

    Vier Zustaende des Vertrags, und was diese Datei von ihnen traegt:

      laden    Bildschirm (Zug 5).
      leer     "kein Thema gewaehlt -- die Stufe bleibt an der Eingangsfrage,
               rechts entsteht kein Eintrag". Leerer Wortlaut: 200 mit
               benannter Meldung, KEIN Beitrag, KEIN Dreischritt.
      Erfolg   "Thema als Beitrag im INTERVIEW_PROTOCOL-Stand gefuehrt". Genau
               das tut der Dreischritt -- und nichts sonst.
      Fehler   "Speichern fehlgeschlagen -- Meldung, Auswahl bleibt stehen,
               ein unvollstaendiger Dreischritt wird nicht sichtbar".

    DIE ZWOELF THEMEN FEHLEN IM WORTLAUT, und sie werden nicht erfunden (S-G).
    Dieser Weg nimmt deshalb keinen Themen-CODE entgegen, sondern nur den
    Wortlaut: ein Code ohne Liste zeigte auf nichts. Kommt die Liste als Seed,
    liefert sie Wortlaute, und dieser Weg bleibt unveraendert -- ausgewaehlt
    oder selbst geschrieben, es ist derselbe Beitrag mit derselben Marke
    "Ihre Angabe" (K05-M11).

    EIN ZWEITES THEMA ERSETZT DAS ERSTE NICHT (K05-D03). Es kommt als eigener
    Beitrag hinzu, mit `bearbeitungszustand = BEARBEITET` und einem Verweis auf
    den Beitrag, den es abloest. Beide bleiben in der Datei und beide bleiben
    lesbar; geloescht wird nichts.
    """
    merkmal = request.cookies.get(KEKS_NAME)
    with verbindung() as conn:
        sitzung, app, stand, fehlweg = _vorbereiten(
            request, conn, merkmal, anwendung, "ORIENTIERUNG")
        if fehlweg is not None:
            return fehlweg

        if not wortlaut.strip():
            return _en05(request, sitzung, app, stand,
                         hinweis=MELDUNG_THEMA_LEER)

        bisher = _gueltig(stand, GEGENSTAND_THEMA)
        neu = _beitrag_anfuegen(
            stand, gegenstand=GEGENSTAND_THEMA, wortlaut=wortlaut,
            actor_id=sitzung["actor_id"], stufe="ORIENTIERUNG",
            zustand=ZUSTAND_URSPRUNG if bisher is None else ZUSTAND_BEARBEITET,
            ersetzt=bisher["reihenfolge"] if bisher else None)

        try:
            dreischritt(conn, sitzung, app, neu)
        except DreischrittGescheitert:
            return _en05(request, sitzung, app, stand,
                         meldung=MELDUNG_SPEICHERN_GESCHEITERT)

    return _umleitung(f"/orientierung?anwendung={app['id']}")


@router.post("/orientierung/einordnung", response_class=HTMLResponse)
def record_classification(request: Request,
                          anwendung: str = Form(default=""),
                          frage: str = Form(default=""),
                          wortlaut: str = Form(default="")):
    """record_classification -- drei Fragen in fester Reihenfolge (K05-M03).

    DIE REIHENFOLGE WIRD SERVERSEITIG DURCHGESETZT, nicht angezeigt. Der
    Bildschirm zeigt die Folgefrage erst, wenn die vorige beantwortet ist --
    aber ein Bildschirm, der etwas nicht anbietet, verbietet es nicht. Wer das
    Formular von Hand nachbaut, kaeme sonst mit "Anwendung" an, ohne je eine
    Branche genannt zu haben, und die feste Reihenfolge aus K05-M03 waere eine
    Empfehlung. Also: `frage` muss GENAU die naechste offene Frage sein.

    DIE OFFENE ALTERNATIVE IST DER REGELFALL, NICHT DIE AUSNAHME (K05-M04,
    K05-G02). "Branche, Funktionsbereich und Anwendung sind Eingabefelder des
    Nutzers, keine festgelegten Werte" -- deshalb nimmt dieser Weg den
    Wortlaut entgegen und keinen Code, und deshalb fehlt hier keine Liste: die
    drei Fragen stehen im Klauselwortlaut, ihre Antworten sind Eingaben.

    UND EINE GEGEBENE ANTWORT LAESST SICH BERICHTIGEN (K05-M06, K05-D03).
    Der Entwurf wies jede Antwort ab, sobald alle drei Fragen beantwortet
    waren -- damit gab es keinen Weg mehr, eine falsch eingetragene Branche zu
    aendern, und K05-M06 verlangt genau zwei Wege: "Weitere Details angeben"
    korrigiert, "Ja, weiter zum Interview" bestaetigt. Das gezeichnete
    Kriterium misst den ersten mit ("eine Ergaenzung eintragen und
    zurueckkehren -- die Zusammenfassung fuehrt die Ergaenzung") und nennt
    NICHT ERFUELLT, wenn "einer der beiden Wege fehlt".

    DIE FESTE REIHENFOLGE BLEIBT DAVON UNBERUEHRT. K05-M03 ordnet, wie zum
    ERSTEN Mal geantwortet wird: solange eine Frage offen ist, nimmt dieser
    Weg nur genau sie entgegen. Steht eine Frage bereits beantwortet da, ist
    sie nicht mehr "ausser der Reihe" -- ihre Reihe ist vorbei. Der
    Negativfall des Kriteriums bleibt messbar, weil er bei UNBEANTWORTETER
    Branche auf die Anwendungsfrage zielt.

    Zustand `leer` des Vertrags: "unbeantwortete Frage -- die Folgefrage
    erscheint nicht, die Zeile rechts bleibt leer". Zustand `Fehler`:
    "Reihenfolge verletzt oder Speichern fehlgeschlagen -- abgewiesen,
    bisherige Antworten bleiben unveraendert" (K05-G01).
    """
    merkmal = request.cookies.get(KEKS_NAME)
    with verbindung() as conn:
        sitzung, app, stand, fehlweg = _vorbereiten(
            request, conn, merkmal, anwendung, "ORIENTIERUNG")
        if fehlweg is not None:
            return fehlweg

        code = frage.strip()
        naechste = _naechste_einordnung(stand)
        feld = next((f for f in EINORDNUNG if f["code"] == code), None)
        bisher = _gueltig(stand, feld["gegenstand"]) if feld else None

        # Zulaessig ist genau zweierlei: die naechste offene Frage beantworten
        # (K05-M03) oder eine bereits beantwortete berichtigen (K05-M06).
        # Alles andere wird abgewiesen, ohne zu schreiben.
        erstantwort = naechste is not None and code == naechste["code"]
        if feld is None or not (erstantwort or bisher is not None):
            PROTOKOLL.warning(
                "Einordnung abgewiesen: gesendet wurde %r, an der Reihe ist "
                "%r, und eine Berichtigung liegt nicht vor. Es wurde nichts "
                "gespeichert (K05-M03).",
                code, naechste["code"] if naechste else None)
            return _en05(request, sitzung, app, stand,
                         meldung=MELDUNG_REIHENFOLGE)

        # Der Wortlaut geht unbeschnitten in den Stand; `.strip()` entscheidet
        # nur, OB etwas eingegeben wurde. K05-G02 misst "zeichengleich wie
        # eingegeben" -- eine Normalisierung der Randzeichen nennt keine
        # Quelle (dieselbe Ueberlegung an allen vier Eingabewegen).
        if not wortlaut.strip():
            return _en05(request, sitzung, app, stand,
                         hinweis=MELDUNG_EINORDNUNG_LEER)

        neu = _beitrag_anfuegen(
            stand, gegenstand=feld["gegenstand"], wortlaut=wortlaut,
            actor_id=sitzung["actor_id"], stufe="ORIENTIERUNG",
            zustand=ZUSTAND_URSPRUNG if bisher is None else ZUSTAND_BEARBEITET,
            ersetzt=bisher["reihenfolge"] if bisher else None)

        try:
            dreischritt(conn, sitzung, app, neu)
        except DreischrittGescheitert:
            return _en05(request, sitzung, app, stand,
                         meldung=MELDUNG_SPEICHERN_GESCHEITERT)

    return _umleitung(f"/orientierung?anwendung={app['id']}")


@router.post("/orientierung/ziele", response_class=HTMLResponse)
def record_goals(request: Request,
                 anwendung: str = Form(default=""),
                 wortlaut: str = Form(default="")):
    """record_goals -- Mehrfachnennung, und die Reihenfolge ist der Rang.

    K05-G04: "Die Rangfolge der Ziele entsteht aus der Reihenfolge der
    Auswahl. Sie ist eine Angabe des Nutzers, keine Bewertung des Systems."
    Deshalb nimmt dieser Weg KEIN Rangfeld entgegen. Es gibt keinen Parameter,
    in den ein Rang liefe, und keine Stelle, an der einer gerechnet wuerde --
    der Rang ist schlicht die naechste freie Ziffer. Ein Feld dafuer waere
    eine Einladung, die Reihenfolge von aussen zu setzen.

    EIN ZIEL JE AUFRUF. Der Bildschirm sammelt die Mehrfachauswahl, indem er
    diesen Weg mehrfach geht -- jede Auswahl ist ein Beitrag und damit ein
    Speichervorgang. Das ist der Grund, warum der Rang stabil bleibt: er
    entsteht in der Reihenfolge, in der die Beitraege in die Datei kommen, und
    diese Reihenfolge ist unveraenderlich (K05-M25).

    DIE SIEBEN ZIELE FEHLEN IM WORTLAUT (S-G) -- wie die zwoelf Themen. "+
    Anderes Ziel" traegt allein; ein Code ohne Liste zeigte auf nichts.
    """
    merkmal = request.cookies.get(KEKS_NAME)
    with verbindung() as conn:
        sitzung, app, stand, fehlweg = _vorbereiten(
            request, conn, merkmal, anwendung, "ORIENTIERUNG")
        if fehlweg is not None:
            return fehlweg

        if not wortlaut.strip():
            return _en05(request, sitzung, app, stand,
                         hinweis=MELDUNG_ZIEL_LEER)

        neu = _beitrag_anfuegen(
            stand, gegenstand=GEGENSTAND_ZIEL, wortlaut=wortlaut,
            actor_id=sitzung["actor_id"], stufe="ORIENTIERUNG",
            rang=len(_beitraege(stand, GEGENSTAND_ZIEL)) + 1)

        try:
            dreischritt(conn, sitzung, app, neu)
        except DreischrittGescheitert:
            return _en05(request, sitzung, app, stand,
                         meldung=MELDUNG_SPEICHERN_GESCHEITERT)

    return _umleitung(f"/orientierung?anwendung={app['id']}")


@router.post("/orientierung/ausgangsproblem", response_class=HTMLResponse)
def confirm_initial_problem(request: Request,
                            anwendung: str = Form(default="")):
    """confirm_initial_problem -- ein Tor, keine Hoeflichkeit (K05-G05).

    "Konzepte, Prototyp und Angebot bauen auf dieser einen Beschreibung auf."
    Deshalb nimmt dieser Weg KEINEN Text entgegen: bestaetigt wird, was steht,
    und nicht, was mitgesendet wird. Ein Textfeld hier hiesse, die Beschreibung
    liesse sich im Akt der Bestaetigung noch aendern -- und bestaetigt waere
    dann etwas, das niemand gelesen hat.

    Zustand `leer` des Vertrags: "ohne zusammengefasstes Ausgangsproblem ist
    die Schaltflaeche ausgeblendet, an ihrer Stelle steht der Hinweis auf die
    fehlende Beschreibung". Der Hinweis geht deshalb als `hinweis` hinaus und
    nicht als `meldung` -- er benennt die Bedingung des naechsten Schritts und
    gehoert an die Stelle der Schaltflaeche (K19-M06).

    KORRIGIEREN GEHT WEITER (K05-M06, "Weitere Details angeben"): jeder
    weitere Beitrag zu Thema, Einordnung oder Zielen aendert die
    Zusammenfassung, und die Bestaetigung ist danach eine aeltere Zeile in der
    Datei -- sie wird nicht entfernt, sie wird ueberholt (K05-D03). Ob eine
    ueberholte Bestaetigung neu einzuholen ist, sagt keine Quelle; der Punkt
    steht in der Vorlage und ist hier nicht still entschieden.
    """
    merkmal = request.cookies.get(KEKS_NAME)
    with verbindung() as conn:
        sitzung, app, stand, fehlweg = _vorbereiten(
            request, conn, merkmal, anwendung, "ORIENTIERUNG")
        if fehlweg is not None:
            return fehlweg

        zusammenfassung = ausgangsproblem(stand)
        if zusammenfassung is None:
            return _en05(request, sitzung, app, stand,
                         hinweis=MELDUNG_AUSGANGSPROBLEM_FEHLT)

        # Der Wortlaut der Bestaetigung ist die Zusammenfassung selbst, in
        # ihrer kanonischen Form -- damit in der Datei steht, WAS bestaetigt
        # wurde, und nicht bloss DASS bestaetigt wurde. Ein Nachweis ohne
        # Gegenstand belegt nichts.
        neu = _beitrag_anfuegen(
            stand, gegenstand=GEGENSTAND_AUSGANGSPROBLEM,
            wortlaut=json.dumps(zusammenfassung, sort_keys=True,
                                ensure_ascii=False),
            actor_id=sitzung["actor_id"], stufe="ORIENTIERUNG")

        try:
            dreischritt(conn, sitzung, app, neu)
        except DreischrittGescheitert:
            return _en05(request, sitzung, app, stand,
                         meldung=MELDUNG_SPEICHERN_GESCHEITERT)

    return _umleitung(f"/orientierung?anwendung={app['id']}")


@router.post("/orientierung/name", response_class=HTMLResponse)
def confirm_app_name(request: Request,
                     anwendung: str = Form(default=""),
                     name: str = Form(default="")):
    """confirm_app_name -- der erste Stufenwechsel (K05-M07, K05-M08).

    DREI WIRKUNGEN, EIN ZUG: der Name als Beitrag im Stand, `app.name` und der
    Wechsel ORIENTIERUNG -> INTERVIEW mit seinem Protokolleintrag. Alles in
    EINER Transaktion (`dreischritt` mit `neuer_name` und `ziel_stufe`).
    Scheitert eines, steht keines -- genau der Negativfall, den das
    gezeichnete Akzeptanzkriterium faehrt: "der Schreibweg auf event wird in
    der Pruefumgebung unterbunden ... alles zurueckgerollt, kein Teilwechsel;
    journey_phase steht weiter auf ORIENTIERUNG".

    DIE STUFE KOMMT NICHT VOM CLIENT. Dieser Weg nimmt zwei Felder entgegen,
    `anwendung` und `name`, und kein drittes. Es gibt keinen Parameter fuer
    eine Stufe, keine Variable, in die einer liefe, und `set_journey_phase`
    laesst ohnehin nur die beiden Uebergaenge von M5 zu (M32). Ein
    mitgesendeter Wert wird nicht "angenommen und verworfen" -- er wird nicht
    gelesen.

    OHNE BESTAETIGTES AUSGANGSPROBLEM KEIN NAMENSSCHRITT. Der Vertrag sagt es
    fuer `ausgangsproblem_bestaetigen` als Berechtigung: "serverseitig: ohne
    bestaetigtes Ausgangsproblem kein Namensschritt". Also wird es hier
    geprueft und nicht bloss ausgeblendet.

    OHNE NAMEN KEIN WECHSEL (K05-G06, K05-D04). Zustand `leer` des Vertrags:
    "Feld leer oder Marke fehlt -- abgelehnt, Stufe bleibt ORIENTIERUNG".

    ZUR MARKE, offen benannt: der Vertrag erwartet einen Vorschlag der Modelle
    mit der Marke "KI-Vorschlag". In M5 gibt es keinen Modellpfad; das Feld ist
    leer und der Nutzer schreibt den Namen selbst. Der Beitrag traegt deshalb
    genau eine Marke, und zwar "Ihre Angabe" -- die einzige, die hier belegbar
    ist. Erfunden wird kein Vorschlag; eine Marke ohne Urheber waere eine
    Falschangabe (K05-D02).
    """
    merkmal = request.cookies.get(KEKS_NAME)
    with verbindung() as conn:
        sitzung, app, stand, fehlweg = _vorbereiten(
            request, conn, merkmal, anwendung, "ORIENTIERUNG")
        if fehlweg is not None:
            return fehlweg

        if _gueltig(stand, GEGENSTAND_AUSGANGSPROBLEM) is None:
            return _en05(request, sitzung, app, stand,
                         hinweis=MELDUNG_AUSGANGSPROBLEM_OFFEN)

        # Auch hier entscheidet `.strip()` nur, OB etwas eingetragen wurde.
        # Das gezeichnete Kriterium zu K05-M07 misst "app.name traegt genau
        # den ueberschriebenen Wortlaut" -- genau heisst genau.
        gewaehlt = name
        if not name.strip():
            return _en05(request, sitzung, app, stand,
                         hinweis=MELDUNG_NAME_LEER)

        marke = _marke_pruefen(HERKUNFT_MENSCH, ERZEUGUNG_MENSCH)
        if marke is not None:
            return _en05(request, sitzung, app, stand, meldung=marke)

        neu = _beitrag_anfuegen(
            stand, gegenstand=GEGENSTAND_NAME, wortlaut=gewaehlt,
            actor_id=sitzung["actor_id"], stufe="ORIENTIERUNG")

        try:
            dreischritt(conn, sitzung, app, neu,
                        neuer_name=gewaehlt, ziel_stufe="INTERVIEW")
        except DreischrittGescheitert:
            # EINE Meldung fuer beide Abbruchgruende, und zwar mit Absicht:
            # ob die Datei, die Zeile, der Eintrag, der Name oder der
            # Stufenwechsel scheiterte, aendert fuer den Nutzer nichts --
            # geaendert ist in jedem Fall nichts. Der Grund steht im Protokoll
            # des Betreibers (K23-D09).
            return _en05(request, sitzung, app, stand,
                         meldung=MELDUNG_STUFENWECHSEL_GESCHEITERT)

    return _umleitung(f"/interview?anwendung={app['id']}")


# ===========================================================================
#  ABSCHNITT H · EN-06 · Stufe 02 Interview
# ===========================================================================


def _en06(request, sitzung, app, stand, meldung=None, hinweis=None):
    """Der Bildschirm EN-06. Er entscheidet nichts -- er zeigt.

    Der K19-Kasten (`schema/K19_build_referenz.md:267`) fuehrt links die
    Fachfrage mit Vorschlaegen, das Freitextfeld, [Datei], [Diese Frage
    ignorieren], [Bin fertig mit dem Interview] und [Speichern, spaeter
    weitermachen] -- rechts Teilnehmer, KI-Notiz, Ihre Angabe und den
    Uebersprungvermerk. Diese Datei liefert dazu die Bausaetze; die Anordnung
    ist Zug 5.

    ZWEI KAESTEN DES KASTENS BLEIBEN LEER, und der Bildschirm sagt es:
    [Datei] ist zurueckgestellt (Blatt 100, E4), und die Fachfragen sind im
    Wortlaut nicht gezeichnet (S-G). Beides steht als benannte Meldung, nicht
    als ausgegraute Schaltflaeche -- ein ausgegrauter Knopf ist ein
    Versprechen.
    """
    return _seite(request, "en06_interview.html", {
        "anzeigename": sitzung["anzeigename"],
        "anwendung": str(app["id"]),
        "projektnummer": app["projektnummer"],
        "name": app["name"],
        "stufe": app["stufe"],
        "nur_ansicht": app["stufe"] != "INTERVIEW",
        "teilnehmer": teilnehmer(sitzung),
        "eintraege": rechte_spalte(stand),
        "fachfragen_hinweis": MELDUNG_FACHFRAGEN_FEHLEN,
        "anhang_hinweis": MELDUNG_ANHANG_ZURUECKGESTELLT,
        "meldung": meldung,
        "hinweis": hinweis,
    })


@router.get("/interview", response_class=HTMLResponse)
def interview(request: Request, anwendung: str = "", gespeichert: str = "",
              abgeschlossen: str = ""):
    """EN-06. AENDERT NICHTS.

    `gespeichert` und `abgeschlossen` tragen keine Angabe zum Vorgang -- es
    sind die Quittungen nach der Umleitung der beiden schreibenden Wege und
    nichts weiter (dieselbe Bauart wie `termin` auf EN-04).

    EINE SPAETERE STUFE OEFFNET SICH NICHT, AUCH NICHT ALS NUR-ANSICHT
    (K05-D06). Der Entwurf zeigte EN-06 auch bei Stufe ORIENTIERUNG, mit
    `nur_ansicht = True`. Die Klausel kennt die Nur-Ansicht aber nur fuer
    ZURUECKLIEGENDE Stufen: "Der Nutzer DARF NICHT eine Stufe ueberspringen
    oder eine spaetere Stufe anspringen. Zurueckliegende Stufen oeffnen sich
    ausschliesslich als Nur-Ansicht." Eine spaetere Stufe mit ausgeblendeten
    Schaltflaechen ist ein Anspringen, kein Ansehen -- und das gezeichnete
    Kriterium faehrt dazu einen eigenen Negativfall. Wer zu frueh kommt, wird
    deshalb abgewiesen; wer zu spaet kommt, sieht (K05-D06, `stufe_pruefen`).
    """
    merkmal = request.cookies.get(KEKS_NAME)
    with verbindung() as conn:
        sitzung = sitzung_pruefen(conn, merkmal_lesen(merkmal))
        if sitzung is None:
            return _zurueck_auf_en01(merkmal)
        app = zugang_pruefen(conn, sitzung, anwendung)
        if app is None:
            return _umleitung("/uebersicht")

        # Offen ist dieser Bildschirm genau zweimal: auf seiner eigenen Stufe
        # (None) und auf einer spaeteren als Nur-Ansicht (MELDUNG_STUFE_VORBEI,
        # K05-D06). Jede andere Auskunft von `stufe_pruefen` sperrt -- auch
        # die, die ein unbekannter Stufenwert erzeugt. Fail-closed heisst,
        # dass die Liste der offenen Faelle abgezaehlt ist und nicht die der
        # gesperrten (K05-G01).
        sperre = stufe_pruefen(app, "INTERVIEW")
        if sperre is not None and sperre is not MELDUNG_STUFE_VORBEI:
            PROTOKOLL.warning(
                "EN-06 abgewiesen: die Anwendung steht auf Stufe %s. Eine "
                "spaetere Stufe oeffnet sich nicht, auch nicht als "
                "Nur-Ansicht (K05-D06).", app["stufe"])
            return _seite(request, "en06_interview.html", {
                "anzeigename": sitzung["anzeigename"],
                "anwendung": str(app["id"]),
                "gesperrt": True, "meldung": sperre})

        stand, fehler = stand_lesen(conn, app)
        if stand is None:
            return _seite(request, "en06_interview.html", {
                "anzeigename": sitzung["anzeigename"],
                "anwendung": str(app["id"]),
                "gesperrt": True, "meldung": fehler}, status=503)

        # Die beiden Quittungen sind unterscheidbar und schliessen einander
        # aus (K05-M32: "Speichern und Uebergabe fuehren je einen eigenen,
        # voneinander unterscheidbaren Erfolgszustand"). Der Abschluss steht
        # vor dem Speichern, weil er der spaetere Vorgang ist.
        quittung = None
        if abgeschlossen:
            quittung = MELDUNG_INTERVIEW_FERTIG
        elif gespeichert:
            quittung = MELDUNG_SPEICHERN_QUITTUNG
        return _en06(request, sitzung, app, stand, meldung=quittung)


@router.post("/interview/antwort", response_class=HTMLResponse)
def record_interview_answer(request: Request,
                            anwendung: str = Form(default=""),
                            wortlaut: str = Form(default=""),
                            frage: str = Form(default="")):
    """record_interview_answer -- EIN Befehl fuer ZWEI Aktionen des Vertrags.

    `vorschlag_waehlen` und `freitext_antworten` nennen denselben
    Serverbefehl, und das ist keine Vereinfachung: K05-D05 sagt, die
    Vorschlaege "DUERFEN NICHT die Antwortmenge begrenzen. Frei eingetippter
    Text wird gleichwertig aufgenommen." Zwei Wege mit verschiedenen
    Bedingungen waeren genau die Begrenzung, die verboten ist. Ein angeklickter
    Vorschlag kommt hier als derselbe Wortlaut an wie ein getippter Satz --
    der Server kann sie nicht unterscheiden, und er soll es nicht.

    DIE MARKE IST "IHRE ANGABE", in beiden Faellen (K05-M11). Der angeklickte
    Vorschlag stammt aus einem Modell, seine Auswahl aber vom Nutzer; und ein
    Eintrag, den der Nutzer gewaehlt hat, ist seine Angabe. Weil in M5 ohnehin
    kein Modell Vorschlaege bildet, ist der Fall heute theoretisch -- er steht
    hier, damit die Zuordnung nicht spaeter beilaeufig getroffen wird. Der
    Zustand `Fehler` des Vertrags ("Marke nicht eindeutig bestimmbar ... kein
    Eintrag rechts") haengt an `_marke_pruefen` und an nichts sonst.

    DER TEXT IST DATEN (K05-M22, K05-M29). Er geht als Parameter in die
    Datenbank, als Wert in die Datei und als Wert an den Bildschirm. Er wird
    nirgends ausgewertet, in keine Anweisung eingesetzt und an kein Modell
    gereicht -- eine Handlungsanweisung darin hat nichts, worauf sie wirken
    koennte.

    `frage` ist eine KENNUNG und wird nicht ausgelegt. Ihr Wortlaut ist nicht
    gezeichnet (S-G); der Server merkt sich, worauf geantwortet wurde, und
    behauptet nicht, was gefragt war. Ohne Kennung ist der Beitrag ein freier
    Beitrag -- das ist der Weg, der heute traegt.
    """
    merkmal = request.cookies.get(KEKS_NAME)
    with verbindung() as conn:
        sitzung, app, stand, fehlweg = _vorbereiten(
            request, conn, merkmal, anwendung, "INTERVIEW")
        if fehlweg is not None:
            return fehlweg

        if not wortlaut.strip():
            # "leeres Feld -- Senden wirkt nicht, rechts entsteht kein
            # Eintrag." Es wird nichts geschrieben und nichts gemeldet, was
            # nach einem Fehler klingt: der Nutzer hat nichts falsch gemacht.
            return _en06(request, sitzung, app, stand,
                         hinweis=MELDUNG_ANTWORT_LEER)

        marke = _marke_pruefen(HERKUNFT_MENSCH, ERZEUGUNG_MENSCH)
        if marke is not None:
            PROTOKOLL.warning(
                "Antwort abgewiesen: die Herkunftsmarke ist nicht eindeutig "
                "bestimmbar. Es ist kein Eintrag entstanden (K05-M11).")
            return _en06(request, sitzung, app, stand, meldung=marke)

        neu = _beitrag_anfuegen(
            stand, gegenstand=GEGENSTAND_ANTWORT, wortlaut=wortlaut,
            actor_id=sitzung["actor_id"], stufe="INTERVIEW",
            frage_kennung=frage.strip() or None)

        try:
            dreischritt(conn, sitzung, app, neu)
        except DreischrittGescheitert:
            return _en06(request, sitzung, app, stand,
                         meldung=MELDUNG_SPEICHERN_GESCHEITERT)

    return _umleitung(f"/interview?anwendung={app['id']}")


@router.post("/interview/ueberspringen", response_class=HTMLResponse)
def skip_interview_question(request: Request,
                            anwendung: str = Form(default=""),
                            frage: str = Form(default="")):
    """skip_interview_question -- der Vermerk, und AUSSCHLIESSLICH er (K05-M10).

    "Der Vermerk traegt ausschliesslich den Wortlaut (Frage uebersprungen) --
    keinen Inhalt aus dem Gespraech und deshalb auch keine Herkunftsmarke."
    Beides ist hier baulich sichergestellt und nicht bloss beabsichtigt:

      * Der Wortlaut steht in EINER Konstante und wird nicht zusammengesetzt.
        Dieser Weg nimmt kein Textfeld entgegen; es gibt keinen Parameter, aus
        dem Inhalt in den Vermerk gelangen koennte.
      * Die Marke ist `None`, und `rechte_spalte` gibt den Vermerk als eigenen
        Eintragstyp heraus. Eine leere Marke waere eine Marke.
      * Die Fragekennung wandert in `frage_kennung`, nicht in den Wortlaut.
        Sie ist nicht Inhalt des Gespraechs, sondern sein Ort.

    UND DIE FRAGE VERSCHWINDET NICHT (K05-D01). Gelingt der Vermerk, steht er
    rechts und geht in das Protokoll ein -- er IST das Protokoll. Gelingt er
    nicht, bleibt die Frage offen stehen und es wird nichts geschrieben. Einen
    dritten Ausgang, bei dem die Frage weg waere, gibt es nicht.

    NACHHOLBAR BIS "BIN FERTIG MIT DEM INTERVIEW" (K05-M10): eine spaetere
    Antwort auf dieselbe Kennung kommt als eigener Beitrag hinzu. Der Vermerk
    bleibt daneben stehen -- er wird nicht ueberschrieben und nicht entfernt
    (K05-D03). Wer wissen will, ob eine Frage uebersprungen WAR, liest es dort;
    wer wissen will, ob sie beantwortet IST, liest den spaeteren Beitrag.
    """
    merkmal = request.cookies.get(KEKS_NAME)
    with verbindung() as conn:
        sitzung, app, stand, fehlweg = _vorbereiten(
            request, conn, merkmal, anwendung, "INTERVIEW")
        if fehlweg is not None:
            return fehlweg

        kennung = frage.strip()
        if not kennung:
            # Ohne gestellte Frage gibt es nichts zu ueberspringen. Fail-closed
            # (K05-G01): es entsteht KEIN Vermerk ohne Bezug -- ein solcher
            # Vermerk stuende rechts und benannte nichts.
            return _en06(request, sitzung, app, stand,
                         meldung=MELDUNG_UEBERSPRINGEN_OHNE_FRAGE)

        neu = _beitrag_anfuegen(
            stand, gegenstand=GEGENSTAND_UEBERSPRUNGEN,
            wortlaut=VERMERK_UEBERSPRUNGEN,
            actor_id=sitzung["actor_id"], stufe="INTERVIEW",
            # KEINE Marke und keine Erzeugungsart aus dem Marken-Vorrat:
            # der Vermerk ist kein inhaltlicher Eintrag (K05-M11), und
            # `_marke_pruefen` wird fuer ihn deshalb gar nicht erst gefragt.
            herkunft=None, erzeugungsart=ERZEUGUNG_MENSCH,
            frage_kennung=kennung)

        try:
            dreischritt(conn, sitzung, app, neu)
        except DreischrittGescheitert:
            PROTOKOLL.warning(
                "Uebersprungvermerk nicht schreibbar; die Frage bleibt offen "
                "stehen (K05-D01).")
            return _en06(request, sitzung, app, stand,
                         meldung=MELDUNG_SPEICHERN_GESCHEITERT)

    return _umleitung(f"/interview?anwendung={app['id']}")


@router.post("/interview/speichern", response_class=HTMLResponse)
def save_interview_progress(request: Request,
                            anwendung: str = Form(default="")):
    """save_interview_progress -- "Speichern, spaeter weitermachen" (K05-M15).

    ER FUEHRT DEN DREISCHRITT AUS, IMMER. Auch dann, wenn seit dem letzten
    Stand kein Beitrag hinzukam. Der Entwurf tat das nicht: er las den Stand,
    meldete Erfolg und legte nichts an. Das war die bequemere Lesart der
    offenen Taktfrage aus K05-M25 -- und sie machte fuenf gezeichnete
    Prueffaelle nicht falsch, sondern UNAUFBAUBAR, weil alle fuenf an genau
    dieser Bedienung ansetzen:

      K05-M26  "zwischenspeichern (Zustand Erfolg); erwartete Beobachtung:
               die drei Saetze sind in der Reihenfolge Datei, `document`-
               Zeile, `event` entstanden"
      K10-M03  "EN-06 · zwischenspeichern in Zustand Erfolg ausloesen -- die
               neue Zeile traegt einen nicht leeren Dateinamen"
      K05-M27  "ein Gespraechsstand zweimal nacheinander gespeichert ..., also
               zwei document-Zeilen mit content_ref und content_sha256"
      K05-M24  "Anwendung A1 und gespeichertem Gespraechsstand (EN-06 ·
               zwischenspeichern · Zustand Erfolg)"
      K05-M15  Negativfall b: "das Speichern wird zum Scheitern gebracht
               (Zustand Fehler)" -- was nichts schreibt, kann nicht scheitern

    Dazu der Bildschirmvertrag selbst, berechtigung: "Dreischritt Datei,
    document-Zeile, event in dieser Reihenfolge (K05-M26)", und Zustand
    Erfolg: "der juengste event-Eintrag verweist in object_ref auf
    Dokumentkennung und Hash".

    DER NEUE STAND FUEHRT DIESELBEN BEITRAEGE wie sein Vorgaenger und
    unterscheidet sich von ihm in Revision, Zeit und `vorgaenger_hash`. Das
    sieht nach einer leeren Revision aus und ist der Nachweis, DASS zu diesem
    Zeitpunkt gespeichert wurde -- genau der Nachweis, den die fuenf oben
    verlangen. Was es kostet, steht im Kopf unter "DER TAKT" und geht als
    offener Punkt an den Eigentuemer; entschieden wird er nicht dadurch, dass
    der Bau fuenf Messungen wegbaut.

    OHNE STAND KEIN SPEICHERN. Ein Gespraech ohne einen einzigen Beitrag hat
    nichts fortzuschreiben; der Vertrag sagt zum Zustand `leer` woertlich:
    "entfaellt -- die Aktion steht erst ab Stufe 02 und immer mit vorhandenem
    Stand". Abgewiesen wird, ohne zu schreiben.

    Zustand `Fehler` des Vertrags: "unvollstaendiger Dreischritt wird nicht
    sichtbar -- Meldung, der vorige Stand bleibt gueltig". Er tritt ein, wenn
    der Stand nicht lesbar ist (503 aus `_vorbereiten`) oder wenn der
    Dreischritt abbricht (200 mit benannter Meldung, voriger Stand gilt).
    """
    merkmal = request.cookies.get(KEKS_NAME)
    with verbindung() as conn:
        sitzung, app, stand, fehlweg = _vorbereiten(
            request, conn, merkmal, anwendung, "INTERVIEW")
        if fehlweg is not None:
            # `_vorbereiten` hat den Stand bereits gelesen; ist er nicht
            # lesbar, kommt von dort die 503 mit MELDUNG_STAND_NICHT_LESBAR.
            return fehlweg

        if not stand["beitraege"]:
            return _en06(request, sitzung, app, stand,
                         hinweis=MELDUNG_ANTWORT_LEER)

        try:
            dreischritt(conn, sitzung, app, _stand_fortschreiben(stand))
        except DreischrittGescheitert:
            return _en06(request, sitzung, app, stand,
                         meldung=MELDUNG_SPEICHERN_GESCHEITERT)

    return _umleitung(f"/interview?anwendung={app['id']}&gespeichert=1")


@router.post("/interview/fertig", response_class=HTMLResponse)
def complete_interview(request: Request, anwendung: str = Form(default="")):
    """complete_interview -- der zweite Stufenwechsel (K05-M19).

    DREI WIRKUNGEN VERLANGT DIE KLAUSEL, ZWEI ENTSTEHEN HIER, und die dritte
    wird benannt statt behauptet:

      Stufe             `journey_phase` auf UEBERSICHT -- ueber
                        `set_journey_phase`, nie ueber ein UPDATE (M32).
      Protokolleintrag  schreibt dieselbe Funktion im selben Zug (K02-D04).
      Uebergabe an K06  NICHT GEBAUT. M32 sagt es im eigenen Kopf: "Die
                        Uebergabe an K06 ist die Grenze von M5, nicht sein
                        Inhalt." K06 ist in dieser Scheibe nicht vorhanden;
                        eine Uebergabe an ein Konzept, das nicht gebaut ist,
                        waere eine Zeile, die nichts erreicht.

    "WIE BEI K05-M08 GILT: OHNE EINTRAG KEIN WECHSEL." Das traegt die Funktion
    selbst -- Wechsel und Eintrag stehen in einer Anweisungsfolge derselben
    Transaktion, und der Aufruf steht hier zusammen mit dem Dreischritt in
    EINER Transaktion. Der Negativfall des Akzeptanzkriteriums ("der
    Protokolleintrag wird zum Scheitern gebracht") laesst deshalb nichts
    zurueck: keine Stufe, keinen Stand, keine Uebergabe.

    OHNE GESPRAECHSSTAND KEINE UEBERGABE (Vertrag, Zustand `leer`: "entfaellt
    -- ohne Gespraechsstand gibt es keine Uebergabe"). Ein Interview ohne einen
    einzigen Beitrag wird abgewiesen, ohne zu schreiben.

    UND ES WIRD EIN ABSCHLIESSENDER STAND GESCHRIEBEN. Er traegt den Beitrag
    nicht -- es gibt keinen -- sondern ist der Stand, auf den der
    Protokolleintrag des Wechsels zeigt: der Stand, mit dem das Interview
    beendet wurde. Ohne ihn stuende der juengste Eintrag vor dem Wechsel, und
    die Frage "welcher Stand ist uebergeben worden" haette keine Antwort in
    den Daten. Er entsteht ueber dieselbe Funktion wie beim Zwischenspeichern
    (`_stand_fortschreiben`) -- seit dieser Fassung ist er nicht mehr die
    einzige Revision ohne neuen Beitrag, sondern der Regelfall eines
    Speichervorgangs ohne Beitrag.

    EN-07 IST NICHT GEBAUT. Der Vertrag fuehrt "weiter nach EN-07"; EN-07
    gehoert M6 und hat in dieser Scheibe keinen K19-Kasten (F41). Der Weg
    bleibt deshalb auf EN-06, das nach dem Wechsel in Nur-Ansicht steht
    (K05-D06), und quittiert dort. Auf EN-02 zu leiten waere kein
    Zurueckhalten, sondern ein Verlust: `GET /uebersicht`
    (app/vorpruefung.py:570) nimmt keinen Parameter entgegen und
    `en02_uebersicht.html` zeigt keine Meldung -- die Quittung des Entwurfs
    haette dort niemand gelesen.
    """
    merkmal = request.cookies.get(KEKS_NAME)
    with verbindung() as conn:
        sitzung, app, stand, fehlweg = _vorbereiten(
            request, conn, merkmal, anwendung, "INTERVIEW")
        if fehlweg is not None:
            return fehlweg

        if not stand["beitraege"]:
            return _en06(request, sitzung, app, stand,
                         hinweis=MELDUNG_ANTWORT_LEER)

        # Derselbe Stand, eine Revision weiter -- ohne neuen Beitrag, ueber
        # dieselbe Funktion wie beim Zwischenspeichern (`_stand_fortschreiben`).
        try:
            dreischritt(conn, sitzung, app, _stand_fortschreiben(stand),
                        ziel_stufe="UEBERSICHT")
        except DreischrittGescheitert:
            return _en06(request, sitzung, app, stand,
                         meldung=MELDUNG_STUFENWECHSEL_GESCHEITERT)

    return _umleitung(f"/interview?anwendung={app['id']}&abgeschlossen=1")
