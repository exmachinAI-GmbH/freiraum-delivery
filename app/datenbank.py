# BERICHTIGTE FASSUNG des Entwurfs fuer app/datenbank.py · M5 · Zug 2
# Stand 19.08.2026. Gegengelesen; berichtigt sind die BEANSPRUCHUNGEN im Kopf,
# die Wiedergabe zweier Quellen und die Formpruefung des Mandantenwerts.
# Vollstaendige neue Fassung: alles, was vorher in dieser Datei stand, steht
# unveraendert weiter darin -- neu sind allein `EINSTELLUNG_MANDANT`,
# `MandantFehlt`, `mandantenvorgang()` und `gesetzter_mandant()`.
#
# zur Haelfte umgesetzt: K13-M08 und K02-M20 -- die beiden tragenden Klauseln
#          der Mandantengrenze (RR-04 nennt sie gemeinsam). Diese Datei baut
#          die MECHANIK, mit der der Serverpfad den Mandanten der Sitzung in
#          `freiraum.tenant_id` hinterlegt; ohne sie lesen die drei
#          Zeilenregeln aus M32 `sitzungs_mandant() IS NULL`. Sie ist damit
#          NICHT umgesetzt, und das ist der Unterschied, den dieser Kopf
#          festhalten muss: das gezeichnete Kriterium zu K13-M08 misst zwei
#          Laeufe je DATENPFAD, und Lauf (b) verlangt, dass der SERVERPFAD
#          den Fremdzugriff ueber die Autorisierung abweist, waehrend die
#          Policy fuer dieses Objekt abgeschaltet ist. Diese Datei
#          autorisiert nichts -- sie kennt keine Sitzung, kein Objekt und
#          keine Rolle. BERICHTIGT AM 20.08.2026: Hier stand, sie habe
#          "nach diesem Zug KEINEN Aufrufer". Das ist seit dem Bauzug W7
#          falsch -- `app/zweckbestimmung.py`:159 und :1148 betreten
#          `mandantenvorgang`, und das galt schon am Stand, der am
#          20.08.2026 dem Fremdmodell vorlag. DER SATZ HAT SCHADEN
#          ANGERICHTET: das Fremdmodell hat ihn uebernommen und daraus
#          geschlossen, die Mechanik werde "von keinem vorhandenen Weg
#          benutzt" (Tor-3-Blatt vom 20.08., Grund 8). Richtig ist: EIN
#          Weg betritt sie, und er gehoert zu M4. IM TEILSCHNITT BIS ZUR
#          ANMELDUNG betritt sie weiterhin keiner -- insofern traegt der
#          Befund des Fremdmodells fuer seinen Pruefumfang unveraendert.
#          Siehe "WAS NACH DIESEM ZUG OFFEN BLEIBT"
# beruehrt, nicht beansprucht: K01-M15 -- der Mandantenschnitt fuer `app`,
#          `document` und `event` gilt ab dem Setzen der Einstellung ohne
#          Zutun der einzelnen Abfrage. Das gezeichnete Kriterium misst aber
#          drei Aufrufe eines LESE-WEGES und vergleicht Fall 2 (fremdes
#          Objekt) mit Fall 3 (nirgends vergebene Kennung) auf Statuscode
#          UND Text. Einen solchen Weg baut diese Datei nicht; die Gleichheit
#          der beiden Antworten entsteht in der Route, nicht hier. Die
#          uebrigen 54 Tabellen (57 insgesamt, gezaehlt in Entscheidung 1
#          vom 19.08.2026) tragen ohnehin keine Zeilenregel; dort haelt
#          weiterhin allein die Bedingung in der Abfrage, so wie
#          app/vorpruefung.py sie auf `fit_check` fuehrt
# beruehrt, nicht beansprucht: K13-M05, K05-M24 -- beide Kriterien zaehlen
#          fuenf Pruefungen auf (Konto, Mitgliedschaft, Rolle, Mandant,
#          Objektbezug) und messen sie an den benannten Serverbefehlen von
#          EN-05 und EN-06 (record_topic, record_classification,
#          record_goals, confirm_initial_problem, confirm_app_name,
#          record_interview_answer, skip_interview_question,
#          save_interview_progress, complete_interview). Keiner davon ist
#          gebaut. Diese Datei macht EINE der fuenf an EINER Stelle
#          erzwingbar und prueft selbst keine
# beruehrt, nicht beansprucht: K13-M20 -- die Klammer, in der fachliche
#          Aenderung und Protokolleintrag gemeinsam oder gar nicht entstehen,
#          ist ab hier fuer jeden sitzungsgebundenen Vorgang schon offen.
#          Gemessen wird sie am Negativlauf von EN-05 · name_bestaetigen
#          ("alles zurueckgerollt, kein Teilwechsel, Stufe bleibt
#          ORIENTIERUNG") und an einem zweiten Lauf fuer den Outbox-Weg.
#          Beides gehoert zu Zug 4; eine Outbox baut diese Datei nicht und
#          braucht sie nicht, weil hier nichts ausserhalb der Datenbank
#          geschrieben wird
#
# NICHT beansprucht, obwohl der Entwurf es tat -- mit Begruendung, weil ein
# zurueckgenommener Anspruch sonst wie ein Versehen aussieht:
#   * K01-G01. Das gezeichnete Kriterium misst am BILDSCHIRM: "zu jeder
#     gesetzten Sperre ist am Bildschirm ein Grund sichtbar; keine Sperre
#     steht ohne sichtbaren Grund", gemessen an EN-05 · ausgangsproblem_-
#     bestaetigen und EN-05 · ziele_waehlen. `MandantFehlt` ist ein
#     RuntimeError; app/haupt.py fuehrt genau einen Ausnahmebehandler
#     (psycopg.OperationalError, Zeile 143). Der Abbruch endet also in einer
#     Standardantwort ohne sichtbaren Grund. Gegen dieses Kriterium gemessen
#     waere er nicht Erfuellung, sondern der Fehlerfall. Der Abbruch bleibt
#     trotzdem -- als Programmfehler, wie `UmgebungUnvollstaendig`, und
#     nicht als Sperre einer Nutzeraktion.
#   * K03-M09 und K03-M16. Beide gehoeren zu M1 und tragen kein gezeichnetes
#     Kriterium (K03-M09: VORSCHLAG, NICHT GEZEICHNET; K03-M16: gar keines).
#     Der Entwurf hat sie unter "umgesetzt" gefuehrt und gleichzeitig
#     K01-D08 und K14-D07 mit genau der Begruendung zurueckgewiesen, sie
#     seien ungezeichnet. Es gilt dieselbe Regel fuer beide Seiten.
#     Ausserdem war die Wiedergabe falsch: K03-M09 sagt nicht "eine Sitzung
#     entsteht nur aus einer bestaetigten zweiten Stufe", sondern "der
#     Uebergang WARTET_2FA nach AKTIV MUSS ausschliesslich aus einer
#     bestaetigten zweiten Stufe entstehen; im selben Vorgang wird
#     `last_login_at` gesetzt". Das ist eine Aussage ueber den KONTOZUSTAND,
#     nicht ueber die Entstehung der Sitzung. Die Trennlinie unten steht
#     deshalb ohne Klauselkennung: sie folgt aus dem Bau, nicht aus K03-M09.
#   * K01-D08 und K14-D07 -- unveraendert nicht beansprucht, beide
#     ungezeichnet.
#
# beruehrt, aber ausdruecklich NICHT gebaut -- siehe "WAS DIESE DATEI NICHT
# TUT": der Schalter `freiraum.rls_enforce` (Echtdaten-Tor E2, O-K13-1), die
# Zeilenregeln fuer die uebrigen Tabellen (Punkt 09), die Umstellung der
# bereits gebauten Wege aus M1 bis M4, und `datei_anhaengen` /
# `upload_interview_document` (Blatt 100, Entscheidung 4: zurueckgestellt).
"""FREIRAUM · Scheibe 1 · Verbindung, Umgebung und der Mandant der Sitzung.

Drei Werte kommen aus der Umgebung, und keiner von ihnen hat einen
Vorgabewert. Befund BEF-L2-1 vom 10.08.2026: ein stiller Vorgabewert ist ein
fest verdrahtetes Geheimnis, das niemand mehr als Geheimnis liest. Fehlt ein
Wert, bricht der START ab -- nicht der erste Anmeldeversuch. Ein Server, der
mit halber Umgebung hochlaeuft, verschiebt den Fehler auf den ersten Nutzer.

Spaeter kommen Pfeffer und Sitzungsschluessel aus dem Schluesseltresor ueber
die verwaltete Identitaet (K13-M17: keine langlebigen Geheimnisse im Code).
Die Umgebung ist die Zwischenstufe, nicht das Ziel.

SEIT DEM 19.08.2026 STEHT HIER EINE ZWEITE SACHE. Die Migration M32 hat
`app`, `document` und `event` Zeilenregeln gegeben, mit ENABLE und FORCE.
Die Regeln fragen den Waechter `sitzungs_mandant()` (M30, Zeile 2171 ff.),
und der liest genau eine Einstellung: `freiraum.tenant_id`.

WER DABEI WAS ENTSCHEIDET, genau gelesen, weil der ganze Bauzug daran haengt:
Der Waechter entscheidet NICHTS. Ist die Einstellung nicht gesetzt, gibt er
NULL zurueck -- mehr nicht. Ob NULL durchgelassen oder abgewiesen wird,
entscheidet der Schalter, und zwar im Praedikat der Zeilenregel selbst:

    (tenant_id = sitzungs_mandant())
    OR (sitzungs_mandant() IS NULL AND NOT rls_erzwungen())

`rls_erzwungen()` liest `freiraum.rls_enforce` (M32, Stufe 1). So steht es
auch in M30 im eigenen Wortlaut: "NULL heisst: nicht gesetzt. Ob das
durchgelassen oder abgewiesen wird, entscheidet freiraum.rls_enforce."
Der Entwurf schrieb "der Waechter laesst durch" -- das ist eine Stelle zu
frueh und verschiebt die Verantwortung auf die falsche Funktion.

Bis heute setzt die Einstellung niemand, und der Schalter steht aus. Die drei
Regeln standen damit scharf und trafen nichts. Diese Datei liefert die
Mechanik zum Setzen. Sie setzt es nicht selbst -- setzen tut es, wer
`mandantenvorgang` betritt. BERICHTIGT AM 20.08.2026: hier stand "und das
tut nach diesem Zug noch kein Weg". Seit dem Bauzug W7 tut es einer --
`app/zweckbestimmung.py`:1148. Im Teilschnitt bis zur Anmeldung tut es
weiterhin keiner.

DIE TRENNLINIE: ZWEI WEGE, ZWEI FUNKTIONEN
------------------------------------------
Es gibt Wege, die im Namen einer angemeldeten Sitzung arbeiten, und es gibt
Wege, die es nicht tun -- und das nicht aus Nachlaessigkeit, sondern weil es
in ihnen noch keine Sitzung GEBEN KANN:

    ohne Sitzung   EN-01 Anmeldung (`anmelden`), die Einloesung der Einladung
                   (`/einladung`), die Lebenszeichen-Route `/gesundheit`.
                   Wer sich anmeldet, hat noch keinen Mandanten; wer eine
                   Einladung einloest, hat noch kein freigeschaltetes Konto.
                   Ein Mandant liesse sich hier nur RATEN.
    mit Sitzung    alles hinter `sitzung_pruefen`: Uebersicht, Vorpruefung,
                   Eignung, Zweckbestimmung, Einladungsversand -- und ab M5
                   EN-05 und EN-06.

Die beiden Wege werden nicht durch eine Fallunterscheidung getrennt, sondern
durch zwei Namen. Wer `verbindung()` allein benutzt, arbeitet ohne
hinterlegten Mandanten. Wer `mandantenvorgang()` betritt, hat einen Mandanten
oder bekommt einen Abbruch. Es gibt keinen dritten Fall und keine Vorgabe,
die einen der beiden still herstellt.

WAS DIESE TRENNUNG NICHT LEISTET, und das gehoert an dieselbe Stelle wie ihre
Begruendung: sie ist ein Angebot, keine Durchsetzung. `mandantenvorgang`
gibt dieselbe Verbindung zurueck, die der Aufrufer schon hat; nichts hindert
ihn, daran vorbei zu arbeiten, und jeder heute gebaute Weg tut genau das.
Der Entwurf begruendete die Trennung damit, ein `verbindung(mandant=None)`
mit Vorgabewert mache "den Normalfall zum ungeschuetzten, und niemand saehe
es beim Lesen". Das Argument trifft die gewaehlte Loesung selbst: nach
diesem Zug IST der Normalfall der ungeschuetzte -- `verbindung()` allein,
in fuenf Dateien, unveraendert lesbar wie am Vortag. Der Unterschied zur
Vorgabewert-Loesung ist, dass die Umstellung sichtbar aussteht statt still
zu wirken. Das ist ein Unterschied, aber kein Schutz.

DER BEDIENPFAD IN WORTEN (fuer die Routen, die diese Datei benutzen)
--------------------------------------------------------------------
Erst die Sitzung pruefen, dann den Mandanten setzen, dann fachlich arbeiten:

    merkmal = request.cookies.get(KEKS_NAME)
    with verbindung() as conn:
        stand = sitzung_pruefen(conn, merkmal_lesen(merkmal))
        if stand is None:
            return _zurueck_auf_en01(merkmal)
        with mandantenvorgang(conn, stand["mandant"]):
            ...   # hier und NUR hier steht das Fachliche

WARUM `sitzung_pruefen` DAVOR STEHT UND NICHT DARIN. Der Mandant KOMMT aus
dieser Pruefung -- vorher weiss der Serverpfad nicht, in wessen Namen er
arbeitet, und ein Wert, den er sich vorher nimmt, kaeme aus dem Cookie und
nicht aus der Datenbank. Die Pruefung selbst ist deshalb nicht "fachlich":
sie stellt fest, WER fragt, und liest dafuer `auth_session`, `actor`,
`membership` und `portal_enabled`. Keine dieser vier Tabellen traegt eine
Zeilenregel aus M32; die Pruefung laeuft also vollstaendig, bevor die erste
Regel ueberhaupt zustaendig wird. Das ist keine Luecke, sondern die
Reihenfolge, ohne die es nicht geht.

WAS DAS FUER DIE PARKUHR HEISST, offen benannt: `sitzung_pruefen` stellt
`last_activity_at` nach, und zwar ausserhalb der Transaktion, also mit
autocommit. Rollt der fachliche Vorgang danach zurueck, bleibt die Parkuhr
trotzdem nachgestellt. Das ist richtig herum: der Aufruf HAT stattgefunden,
auch wenn er fachlich scheiterte -- dieselbe Ueberlegung, die den gebuchten
Fehlversuch der Anmeldedrosselung nicht mitrollen laesst.

TRANSAKTIONSLOKAL, NICHT GLOBAL
-------------------------------
`set_config(..., true)` -- der dritte Parameter heisst `is_local` und ist
hier `true`. Die Einstellung gilt bis zum Ende DIESER Transaktion und keinen
Befehl laenger.

Und deshalb OEFFNET `mandantenvorgang` eine Transaktion, statt nur eine
Anweisung abzusetzen. Die Verbindung dieser Datei laeuft mit autocommit: jede
einzelne Anweisung waere ihre eigene Transaktion, und eine
transaktionslokale Einstellung waere in derselben Zehntelsekunde wieder weg,
in der sie gesetzt wurde. Sie zu setzen und dann fachlich zu arbeiten, ergibt
nur innerhalb EINER Klammer einen Sinn. Die Klammer ist der Vorgang.

Die naheliegende Abkuerzung -- `is_local = false`, also fuer die Dauer der
Verbindung -- ist bewusst nicht genommen. Sie funktionierte, solange jede
Anfrage ihre eigene Verbindung oeffnet und wieder schliesst (heute tut sie
das). Sie ist genau in dem Augenblick falsch, in dem jemand einen
Verbindungspool einzieht: dann traegt die naechste Anfrage den Mandanten der
vorigen, bis sie ihn ueberschreibt -- und die eine Anfrage, die es vergisst,
liest fremde Daten und meldet keinen Fehler dabei. Ein Mandantenschnitt, der
von einer Betriebsentscheidung abhaengt, die niemand mit ihm im Sinn trifft,
ist kein Schnitt.

`SET LOCAL freiraum.tenant_id = ...` waere dasselbe in kuerzer, nimmt aber
keinen Parameter -- der Wert muesste in den Text der Anweisung geschrieben
werden. `set_config` nimmt ihn als Parameter. Bei einer Kennung, die aus der
Datenbank kommt, ist der Unterschied klein; die Regel, Werte nie in
Anweisungstext zu schreiben, ist es nicht.

WAS DIESE DATEI NICHT TUT
-------------------------
  * SIE SCHALTET DIE DURCHSETZUNG NICHT EIN. `freiraum.rls_enforce` bleibt
    unberuehrt und damit aus. Das heisst: eine Verbindung OHNE gesetzten
    Mandanten wird weiterhin durchgelassen. Genau darauf beruht, dass
    Anmeldung und Einloesung nach diesem Zug unveraendert laufen -- und
    ebenso jede Route aus M1 bis M4, die noch keinen `mandantenvorgang`
    betritt. Der Schalter geht an, wenn ALLE sitzungsgebundenen Wege
    umgestellt sind, und vor dem ersten Mandanten mit echten Daten
    (Echtdaten-Tor E2, O-K13-1). Ihn hier mitzuschalten hiesse, den Bauzug
    an der Stelle zu beenden, an der er noch nicht gemessen ist.
  * SIE STELLT DIE BESTEHENDEN ROUTEN NICHT UM. app/haupt.py,
    app/vorpruefung.py und app/einladung_senden.py rufen weiterhin
    `verbindung()` und sonst nichts. Sie laufen dadurch unveraendert --
    und ungeschuetzt. Das ist eine offene Kante, kein erledigter Punkt;
    sie steht unten unter "WAS NACH DIESEM ZUG OFFEN BLEIBT" und ist dort
    gegen die gezeichnete Unterlage gehalten.

    BERICHTIGT AM 20.08.2026: In dieser Aufzaehlung stand auch
    `app/zweckbestimmung.py`. Das war falsch -- W7 hat genau diesen Weg
    umgestellt (:1148). Damit ist die Zahl der ungeschuetzten Wege eine
    andere, als hier stand, und die Aufzaehlung nannte ausgerechnet den
    einen um, der es nicht mehr ist. Gemessen am 20.08.2026:
    `grep -n mandantenvorgang app/*.py` findet ausserhalb dieser Datei
    genau zwei Zeilen, beide in app/zweckbestimmung.py.
  * SIE KENNT KEINE SITZUNG. Kein Import aus app/sitzung.py -- der liefe
    im Kreis, weil app/sitzung.py von hier `SITZUNG_SCHLUESSEL` und `TLS`
    holt. Diese Datei nimmt einen Mandantenwert entgegen und fragt nicht,
    woher er stammt. Dass er aus derselben geprueften Zeile kommt wie Konto
    und Portal, verantwortet der Aufrufer.
  * SIE BAUT `datei_anhaengen` / `upload_interview_document` NICHT und
    bereitet nichts dafuer vor. Die Aktion ist mit Blatt 100, Entscheidung 4
    zurueckgestellt. Sie waere der erste Weg gewesen, der in `document`
    schreibt -- die Tabelle, die seit M32 eine Zeilenregel traegt. Beides
    hier zu erwaehnen ist Absicht: wenn die Aktion nachgereicht wird,
    braucht sie einen `mandantenvorgang` und nichts sonst.

WAS NACH DIESEM ZUG OFFEN BLEIBT -- gegen die gezeichnete Unterlage
-------------------------------------------------------------------
Der Bauplan des ersten Zuges sagt zu Zug 2 im Wortlaut: "app/datenbank.py:
JEDE VERBINDUNG setzt `freiraum.tenant_id` aus der Sitzung, BEVOR die erste
Anweisung laeuft. Der Umfang ist groesser als M5 -- auch die fuenf
Bildschirme aus M1-M4 schreiben heute ohne ihn." Dieselbe Sache steht
zweimal gezeichnet daneben: RR-04 ("Unabhaengig davon setzt JEDER
Serverbefehl `freiraum.tenant_id`") und Entscheidung 1 vom 19.08.2026
("Vorbedingung, die ohnehin faellt: jeder Serverbefehl setzt
`freiraum.tenant_id`; ohne sie laesst der gebaute Waechter durch").

Gemessen an diesem Wortlaut leistet diese Datei die Haelfte: das WIE steht,
das JEDE nicht. Nach diesem Zug setzt kein einziger Weg die Einstellung.
Das ist kein Einwand gegen die schrittweise Umstellung -- die Klammer aendert
das Rueckrollverhalten der bestehenden Wege (bisher fiel bei zwei
unabhaengigen Schreibvorgaengen nur der gescheiterte weg, kuenftig beide),
und das gehoert einzeln und gemessen gemacht. Es ist ein Einwand dagegen,
den Zug damit als erledigt zu fuehren.

UND DIESER TEILSTAND IST NICHT VON RR-04 GEDECKT. RR-04 traegt den Umfang
der TABELLEN -- drei statt siebenundfuenfzig -- und sagt im eigenen Nachsatz:
"Wer aus RR-04 liest, die Mandantengrenze sei geschlossen, liest ihn falsch."
Ein Serverpfad, der den Mandanten an keiner Stelle setzt, ist ein anderer
Mangel als eine Tabelle ohne Zeilenregel, und fuer ihn steht heute keine
Zeile in der Restrisikoliste. Entweder wird er mit Zug 4 geschlossen, bevor
irgendetwas als erfuellt gemeldet wird, oder er braucht eine eigene,
gezeichnete Zeile. Beides ist eine Entscheidung des Auftraggebers, keine
Bauentscheidung -- und deshalb steht sie hier und nicht in einem Haken.
"""
import os
import uuid
from contextlib import contextmanager

import psycopg


class UmgebungUnvollstaendig(RuntimeError):
    """Der Start ist abgebrochen, weil ein Pflichtwert der Umgebung fehlt.

    Eigene Klasse, damit ein Aufrufer sie ENG fangen kann. Sie wird beim
    Import ausgeloest: uvicorn beendet sich dann mit der benannten Meldung,
    statt eine Anwendung ohne Geheimnisse zu bedienen (K03-G01, fail-closed).
    """


class MandantFehlt(RuntimeError):
    """Ein sitzungsgebundener Vorgang sollte ohne brauchbaren Mandanten beginnen.

    Eigene Klasse aus demselben Grund wie oben: ein Aufrufer, der sie faengt,
    faengt genau diesen einen Fall und nicht jeden Programmfehler mit.

    Sie ist ein PROGRAMMFEHLER, keine Nutzereingabe -- ein fehlender oder
    formwidriger Mandant kann an dieser Stelle nur bedeuten, dass jemand
    `mandantenvorgang` vor `sitzung_pruefen` betreten hat oder eine Zeile
    ohne brauchbare `tenant_id` weitergereicht hat. Deshalb ein Abbruch mit
    Meldung und keine stille Rueckgabe: stillschweigend ohne Mandanten
    weiterzuarbeiten waere genau der Zustand, den dieser Bauzug beendet.

    KEIN K01-G01. Das gezeichnete Kriterium dieser Klausel misst eine Sperre
    AM BILDSCHIRM mit sichtbarem Grund. Diese Ausnahme erreicht keinen
    Bildschirm: app/haupt.py behandelt allein psycopg.OperationalError, jede
    andere endet in der Standardantwort. Als Sperre einer Nutzeraktion
    gemessen, waere sie das Gegenteil dessen, was K01-G01 verlangt. Sie ist
    ein Bauwerkzeug fuer den Entwickler, nicht die Antwort an einen Nutzer.
    """


def pflichtwert(name, grund):
    wert = os.environ.get(name)
    if not wert:
        raise UmgebungUnvollstaendig(
            f"{name} ist nicht gesetzt. {grund} Der Start bricht ab; ein "
            "stiller Vorgabewert ist ausgeschlossen (Befund BEF-L2-1 vom "
            "10.08.2026).")
    return wert


DSN = pflichtwert(
    "FREIRAUM_DSN",
    "Ohne Datenbank ist keine Anmeldung pruefbar, und was nicht pruefbar ist, "
    "sperrt (K03-G01).")

# Entscheidung D vom 10.08.2026, gezeichnet von beiden Foundern. Befund
# BEF-B2-2: ein SHA-256 ueber sechs Ziffern ohne Pfeffer ist in 0,17 Sekunden
# ueber alle 1 000 000 Kandidaten zurueckgerechnet -- wer login_code lesen
# darf, kennt jeden Code. Der Pfeffer steht nie in der Datenbank und nie im
# Bau; er belegt denselben Parameter, den mail/versand.py beim Ausstellen
# belegt. Stimmen die beiden Seiten nicht ueberein, passt kein Code mehr.
CODE_PFEFFER = pflichtwert(
    "FREIRAUM_CODE_PFEFFER",
    "Ohne ihn waere der abgelegte Pruefwert eines sechsstelligen Codes in "
    "Sekunden zurueckgerechnet (Befund BEF-B2-2, Entscheidung D vom "
    "10.08.2026).")

SITZUNG_SCHLUESSEL = pflichtwert(
    "FREIRAUM_SITZUNG_SCHLUESSEL",
    "Ohne ihn waere das Sitzungsmerkmal nicht signiert und jeder koennte sich "
    "eine fremde Sitzung ausstellen.")

# Kein Pflichtwert: die Vorgabe 0 ist die UNSICHERE Richtung und damit keine
# stille Bequemlichkeit -- wer TLS hat, sagt es. Umgekehrt waere Secure als
# Vorgabe im Klartextbetrieb ein Cookie, das nie ankommt.
TLS = os.environ.get("FREIRAUM_TLS", "0") == "1"

# Der Name der Einstellung steht GENAU EINMAL im Anwendungscode. Auf der
# anderen Seite steht er in M30 (`sitzungs_mandant()`); zwei Stellen sind
# schon eine zu viel, drei waeren ein Tippfehler mit Ansage -- und der faellt
# nicht auf, weil ein falscher Name keinen Fehler ausloest, sondern eine
# nicht gesetzte Einstellung. Deren Wirkung entscheidet der Schalter, und der
# steht auf durchlassen. Ein Tippfehler hier sieht also aus wie Erfolg.
EINSTELLUNG_MANDANT = "freiraum.tenant_id"


@contextmanager
def verbindung():
    """Eine Verbindung je Aufruf, autocommit AN. OHNE hinterlegten Mandanten.

    Autocommit heisst hier nicht "ohne Transaktion", sondern: die Grenzen der
    Transaktion setzt der Serverpfad selbst mit `conn.transaction()` -- und
    zwar dort, wo eine Klausel sie verlangt (Zustandswechsel und Verbrauch
    des Codes in EINEM Vorgang). Eine implizite Transaktion um den ganzen
    Aufruf wuerde den gebuchten Fehlversuch mit zurueckrollen, und die
    Drosselung nach K03-M16 zaehlte nie.

    SEIT DEM 19.08.2026 IST DAS ZUGLEICH EINE AUSSAGE ueber den Mandanten:
    diese Verbindung hat keinen. Sie ist der Weg fuer alles, was VOR einer
    Sitzung geschieht -- Anmeldung, Einloesung der Einladung, Lebenszeichen.
    Wer eine Sitzung hat, umschliesst seinen fachlichen Teil zusaetzlich mit
    `mandantenvorgang` (siehe Kopf, "DER BEDIENPFAD IN WORTEN").

    Der Aufruf bleibt unveraendert. Das ist Absicht: dieser Bauzug soll
    keinen bestehenden Weg brechen, sondern einen zweiten daneben oeffnen.
    Es ist zugleich der Grund, warum nach diesem Zug noch nichts geschuetzt
    ist -- die fuenf gebauten Wege benutzen weiterhin genau diesen hier.
    """
    with psycopg.connect(DSN, autocommit=True) as conn:
        yield conn


@contextmanager
def mandantenvorgang(conn, mandant):
    """Der fachliche Teil eines sitzungsgebundenen Aufrufs.

    Was hier drinsteht, laeuft in EINER Transaktion, und in dieser
    Transaktion ist `freiraum.tenant_id` auf den Mandanten der Sitzung
    gesetzt -- gesetzt als ERSTE Anweisung, vor allem Fachlichen. Damit
    greifen die drei Zeilenregeln aus M32.

    Aufruf:

        with verbindung() as conn:
            stand = sitzung_pruefen(conn, merkmal_lesen(merkmal))
            if stand is None:
                return _zurueck_auf_en01(merkmal)
            with mandantenvorgang(conn, stand["mandant"]):
                ...

    `conn` und nicht ein eigener Rueckgabewert: die Verbindung ist dieselbe,
    nur die Klammer ist neu. Ein zweites Objekt zurueckzugeben, das sich wie
    `conn` verhaelt, waere ein zweiter Name fuer dieselbe Sache -- und
    frueher oder spaeter benutzt jemand beide nebeneinander.

    OHNE BRAUCHBAREN MANDANTEN KEIN VORGANG. Ein fehlender Wert bricht ab,
    statt eine Transaktion ohne gesetzte Einstellung zu oeffnen. Denn die
    liefe: eine nicht gesetzte Einstellung laesst das Praedikat der
    Zeilenregel durch, solange `freiraum.rls_enforce` aus ist. Ein Abbruch,
    den jeder sieht, ist besser als ein Vorgang, der ungeschuetzt gelingt.

    UND DIE FORM WIRD GEPRUEFT, die EXISTENZ NICHT. Das sind zwei
    verschiedene Fragen, und der Entwurf hat sie zu einer gemacht.
      * Ob es diesen Mandanten GIBT, fragt diese Funktion nicht nach -- das
        waere eine zweite Wahrheit neben `sitzung_pruefen`, und zwischen
        beiden Abfragen kann sie auseinanderlaufen. Bleibt draussen.
      * Ob der Wert die FORM einer Kennung hat, wird hier geprueft, mit
        `uuid.UUID`. Nicht aus Misstrauen gegen `sitzung_pruefen`, sondern
        wegen des Zeitpunkts: ein formwidriger Wert laesst sich setzen und
        faellt erst auf, wenn zum ersten Mal eine Zeilenregel ausgewertet
        wird -- irgendwo mitten im Vorgang, aus der Tiefe eines Praedikats,
        mit `sitzungs_mandant()`s Meldung "ist gesetzt, aber keine Kennung"
        (M30, ausdruecklich nicht verschluckt). Dieselbe Sache an der Tuer
        gemeldet, mit dem Namen des Aufrufers im Bild, ist derselbe Befund
        eine Ebene frueher. Das gezeichnete Kriterium zu K01-M15 haelt
        ausserdem fest, dass ein Prueffall, der schon an der FORM der
        Kennung scheitert, nichts misst -- die Form gehoert also geprueft
        und benannt, nicht mitgeschleppt.

    WAS DIE KLAMMER SONST NOCH BEWIRKT, und das ist keine Nebenwirkung:
    fachliche Aenderung und Protokolleintrag stehen damit im selben Vorgang.
    Faellt einer aus, faellt beides. Bis heute war das in jeder Route eine
    eigene Entscheidung -- app/vorpruefung.py und app/zweckbestimmung.py
    setzen `conn.transaction()` je Schreibvorgang, andere Wege gar nicht.
    Beansprucht ist K13-M20 damit NICHT: gemessen wird die Klausel am
    Negativlauf von EN-05 · name_bestaetigen, und der ist nicht gebaut.

    WAS SIE KOSTET, ebenso offen: der ganze fachliche Teil eines Aufrufs
    faellt jetzt gemeinsam zurueck, nicht mehr Anweisung fuer Anweisung.
    Eine Route, die bisher zwei unabhaengige Dinge schrieb und beim zweiten
    scheiterte, behielt das erste; ab jetzt behaelt sie keines. Fuer M5 ist
    das die gewollte Richtung. Fuer die Wege aus M1 bis M4 ist es eine
    Aenderung ihres Verhaltens, und deshalb werden sie nicht mit diesem Zug
    umgestellt, sondern einzeln und gemessen.

    Ein bereits laufender `conn.transaction()`-Block darin bleibt richtig:
    er wird zum Sicherungspunkt innerhalb dieser Klammer. Die Einstellung
    steht davor und ueberlebt sein Zuruecknehmen -- sie wurde nicht in ihm
    gesetzt.

    ZU `change_app_state` UND `set_journey_phase`: beide sind SECURITY
    DEFINER, und `app` traegt FORCE -- die Zeilenregel gilt also auch fuer
    den Funktionseigentuemer. Beide Aufrufe muessen deshalb INNERHALB eines
    `mandantenvorgang` stehen. Ob das die gewollte Verschraenkung ist oder
    ob die beiden Funktionen den Mandanten selbst setzen sollen, entscheidet
    diese Datei nicht; sie wird mit Zug 4 gemessen und ist dort zu klaeren,
    bevor der erste Serverbefehl gebaut wird.
    """
    roh = "" if mandant is None else str(mandant).strip()
    if not roh:
        raise MandantFehlt(
            "Ein sitzungsgebundener Vorgang wurde ohne Mandanten begonnen. "
            "Der Mandant kommt aus derselben geprueften Sitzungszeile wie "
            "Konto und Portal (app/sitzung.py, Schluessel 'mandant'); fehlt "
            "er, ist die Sitzung nicht geprueft oder die Zeile traegt keine "
            "tenant_id. Der Vorgang bricht ab, statt ungeschuetzt zu laufen.")
    try:
        kennung = str(uuid.UUID(roh))
    except (ValueError, AttributeError, TypeError) as fehler:
        raise MandantFehlt(
            "Der uebergebene Mandant hat nicht die Form einer Kennung: "
            f"{roh!r}. Gesetzt wuerde er trotzdem, und `sitzungs_mandant()` "
            "meldete ihn erst bei der ersten Auswertung einer Zeilenregel -- "
            "mitten im Vorgang und ohne den Aufrufer im Bild. Der Vorgang "
            "bricht deshalb hier ab.") from fehler

    with conn.transaction():
        # DIE ERSTE ANWEISUNG DER TRANSAKTION, vor jeder fachlichen. Der
        # Wert steht als Parameter im Aufruf, nicht im Anweisungstext.
        conn.execute("SELECT set_config(%s, %s, true)",
                     (EINSTELLUNG_MANDANT, kennung))
        yield conn


def gesetzter_mandant(conn):
    """Was in dieser Transaktion gerade gilt -- oder None.

    Nur zum Nachmessen da, nicht fuer den Fachweg. Eine Behauptung im
    Kommentar ist keine Messung; die Pruefung liest die Einstellung hiermit
    zurueck, statt in die Datenbank zu greifen und den Namen ein drittes Mal
    hinzuschreiben.

    NUR INNERHALB DES `mandantenvorgang` AUSSAGEKRAEFTIG. Die Einstellung ist
    transaktionslokal; nach dem Verlassen der Klammer gibt diese Funktion
    immer None zurueck, und zwar auch dann, wenn alles richtig lief. Wer sie
    danach aufruft und None als Befund liest, misst den falschen Zeitpunkt.

    None heisst innerhalb der Klammer: nicht gesetzt -- und dann entscheidet
    `rls_erzwungen()`, ob die Zeile durchgelassen wird.

    SIE IST EIN HILFSMITTEL AUF WIDERRUF. Misst die Pruefung ohnehin
    unmittelbar auf der Datenbank, gehoert diese Funktion geloescht statt
    mitgeschleppt. Das entscheidet, wer den Prueffall zu K13-M08 schreibt.
    """
    zeile = conn.execute("SELECT current_setting(%s, true)",
                         (EINSTELLUNG_MANDANT,)).fetchone()
    wert = zeile[0] if zeile else None
    return wert or None
