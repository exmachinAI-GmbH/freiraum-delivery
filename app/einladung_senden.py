"""FREIRAUM · Scheibe 1 · der Versand der Einladung.

Die Gegenseite zu app/einladung.py. Dort wird ein Link eingeloest, hier
entsteht er. Bis heute beruehrte nichts in app/ die Tabelle `invitation`
schreibend: der Streuwert kam von Hand in die Datenbank, und
mail/versand.py bekam den fertigen Link als Parameter. Damit war der Weg
"Verwaltender laedt jemanden ein" nirgends gebaut.

Zehn Klauseln bestimmen den Zuschnitt -- acht seit dem Versand, zwei seit
Blatt 62 (K20-M04, K20-M05):

  K20-M07  Ein neuer Zugang entsteht ueber eine Einladung: Zeile in
           `invitation` mit Konto, Portal, Adresse, Streuwert, Versand- und
           Ablaufzeitpunkt. `invitation.actor_id` ist NOT NULL -- also legt
           dieser Pfad das Konto an, wenn es noch keines gibt. Die
           Einloesung schaltet es spaeter frei, sie legt keines an.
  K20-M08  Gespeichert wird allein der Streuwert des Links. Der
           Klartext-Token existiert in genau zwei Zustaenden: als lokale
           Veraenderliche in dieser Datei und als Zeile in der Mail. Nicht
           in der Datenbank, nicht im Log, nicht in der Fehlerausgabe, nicht
           im Nachweis (K20-D03, K23-D09).
  K20-M12  Je Konto hoechstens eine offene Einladung. Getragen vom
           Teilindex `invitation_offen_uq` auf status = 'VERSANDT'.
  K20-M13  Ein erneuter Versand widerruft die vorherige Einladung ZUERST
           und erhoeht `attempt`. Danach besteht wieder genau eine offene.
  K20-M22  Widerruf und Neuanlage stehen in EINER Transaktion. Ein
           Rueckfall zwischen beiden hinterliesse entweder zwei offene
           Einladungen -- die der Index gar nicht zulaesst -- oder gar
           keine, obwohl der Verwaltende einen neuen Link erwartet.
  K20-D05  Der Platz wird NICHT ueber ABGELAUFEN oder EINGELOEST frei:
           allein WIDERRUFEN schafft ihn, und nur dieser Weg erhoeht den
           Zaehler. Dieser Pfad schreibt deshalb nirgends ABGELAUFEN --
           der Ablauf ergibt sich aus `expires_at` und der Uhr (K20-M22,
           K20-G03).
  K20-D02  Kein Versand und KEINE MITGLIEDSCHAFT fuer ein Portal mit
           release_status = PLANNED. Geprueft wird gegen die Sicht
           `portal_enabled`, nicht gegen `portal` -- dieselbe Regel, die
           app/sitzung.py beim Anmelden fuehrt (F04, K13).
  K20-D04  Eine Einladung ausserhalb der Domaenenschranke entsteht nicht --
           "auch nicht auf Zuruf, auch nicht fuer einen Verwaltenden". Die
           Schranke haelt der Ausloeser `invitation_guard_trg`; dieser Pfad
           baut sie NICHT nach, er laesst sie zu Wort kommen (siehe
           _waechtermeldung).
  K20-M18  Jede Aenderung an Zugang, Rolle, MITGLIEDSCHAFT und Einladung steht
           mit Zeitpunkt, handelnder Instanz sowie Wert davor und danach in
           `event`. Die handelnde Instanz ist hier durchgehend der Einladende
           aus der Sitzung -- auch fuer die Mitgliedschaft (Blatt 62, Grund
           fuer Moeglichkeit A). `object_ref` traegt die Form ART:<...>
           (Blatt 60 B), hier MEMBERSHIP:<actor_id>.
  K20-M04  Ein Zugang besteht als Zeile in `membership` aus Konto, Portal,
           Rolle und Reichweite. Alle vier bilden den Schluessel.
  K20-M05  Eine Zeile oeffnet genau EIN Portal. Deshalb legt dieser Pfad
           genau eine Zeile an und prueft das anschliessend nach, statt es
           anzunehmen (K13-D07: kein Zugang wirkt in zwei Portalen ohne je
           eigene Mitgliedschaft).

UND HIER GILT DAS GEGENTEIL DER ANMELDUNG: die Meldungen sind
unterscheidbar. Bei Anmeldung (K03-M16) und Einloesung (K20-D10) steht ein
Unbekannter vor der Tuer, und jede Fallunterscheidung waere eine
Kontoauskunft. Hier steht ein angemeldeter Verwaltender, der eine Adresse
selbst eingegeben hat -- ihm zu verschweigen, WARUM sein Versand scheitert,
hilft niemandem und widerspricht K20-G01 ("Die Sperre wird begruendet
angezeigt, nie stillschweigend gesetzt") und K20-G04 ("Die Meldungen des
Einladungswaechters werden am Ort der Ablehnung angezeigt ... im Wortlaut").

DIESE UNTERSCHEIDBARKEIT HAT SEIT DEM 14.08.2026 EINE GRENZE, und sie steht
in K03-M25: "Fehlermeldungen geben nicht preis, ob ein Konto existiert." Eine
Meldung darf sagen, was der Verwaltende falsch eingegeben hat -- sie darf
nicht sagen, wer sonst noch ein Konto hat. Die eine Meldung, die das tat, ist
entfallen; die Begruendung steht bei _konto_sichern (Befund F1 der
Fremdpruefung vom 14.08.2026).

DIE MITGLIEDSCHAFT STEHT SEIT DEM 11.08.2026 HIER. Blatt 62 ist an diesem Tag
von beiden Foundern gezeichnet, Moeglichkeit A: sie entsteht beim VERSAND, in
derselben Transaktion wie die Einladung. Keine Einladung ohne Mitgliedschaft,
keine Mitgliedschaft ohne Einladung.

Der tragende Grund ist K20-M18 und nicht die Bequemlichkeit: die Klausel
verlangt zu jeder Aenderung an einer Mitgliedschaft die HANDELNDE INSTANZ.
Beim Versand ist das der Einladende -- er hat entschieden, jemandem Zugang zu
geben. Bei der Einloesung waere es der Eingeladene, und der Nachweis lautete
"X hat X eine Mitgliedschaft verschafft". Das waere nicht unschoen, sondern
unwahr.

Die Kehrseite gehoert dazu und ist mitgezeichnet: Widerruf und Ablauf
ENTFERNEN die Mitgliedschaft wieder, im selben Serverpfad und derselben
Transaktion (Blatt 62 Abschn. 6, Zeichnung Nr. 2). Sonst bliebe zu jeder
verfallenen Einladung eine Zugangszeile stehen, die die Lesesicht
`platform_admin` mit auflistet -- sie filtert nicht nach Kontozustand.

Bis zum 11.08.2026 fehlte die Zeile ganz, und der Teilschnitt aus Blatt 57
lief deshalb nicht am Stueck durch: ein eingeloestes Konto kam nicht durch
EN-01, weil app/sitzung.py genau ein Portal ueber `membership` verlangt
(K03-M11) und keines fand.

WAS HIER NICHT STEHT, und zwar weiterhin: die Einloesung legt KEINE
Mitgliedschaft an. Sie besteht dann schon. app/einladung.py bleibt in diesem
Punkt unveraendert.
"""
import logging
import os
import re
import secrets
from urllib.parse import quote

import psycopg

from app.datenbank import CODE_PFEFFER
from mail.versand import VersandFehler, streuwert, versandweg_fehlt
from mail.versand import einladung as mail_einladung

PROTOKOLL = logging.getLogger(__name__)

# Die Adresse, unter der die Einladung eingeloest wird. KEIN Pflichtwert wie
# die drei aus app/datenbank.py: fehlt sie, faellt der Link auf die Adresse
# zurueck, unter der die Anfrage hereinkam. Das ist kein stiller Rueckfall
# auf localhost (BEF-L2-1) -- es ist der Rechnername, den der Verwaltende
# soeben selbst benutzt hat.
#
# Gesetzt gewinnt sie IMMER gegen den Kopf der Anfrage. Sonst bestimmt der
# Host-Kopf, wohin der Link zeigt: wer eine Anfrage mit fremdem Host durch
# den Server bekommt, liesse sich einen gueltigen Token auf seine eigene
# Domaene schicken. In der Zielumgebung gehoert FREIRAUM_BASIS_URL deshalb
# gesetzt -- als offener Punkt vermerkt, nicht stillschweigend geraten.
BASIS_URL = os.environ.get("FREIRAUM_BASIS_URL", "").strip()

# K20-M09, wortgleich zur Bedingung `invitation_mail_fmt` des Datenmodells:
# ein Zeichen vor dem Klammeraffen, eines danach, ein Punkt im hinteren
# Teil, kein Leerraum. Bewusst DIESELBE Regel und keine strengere: eine
# zweite, eigene Adressregel wuerde Eingaben abweisen, die die Datenbank
# annimmt -- und ein Negativfall scheiterte dann an der falschen Bedingung
# (gemessen am 02.08.2026, CLAUDE.md Abschn. 3).
ADRESSE_MUSTER = re.compile(r"^[^\s@]+@[^\s@]+\.[^\s@]+$")

# Laenge des Einmal-Links. 32 Byte aus einer kryptografischen Quelle sind
# 256 Bit; ein Durchprobieren scheitert nicht an einer Drosselung, sondern
# am Raum. Anders als beim sechsstelligen Anmeldecode (K03-M15) nennt keine
# Klausel eine Laenge -- also wird sie nicht knapp gewaehlt.
TOKEN_BYTES = 32

# --- Die Meldungen. Benannt, unterscheidbar, jede an ihrer eigenen Stelle.

# K20-M25 im Wortlaut. Sie steht auf der Erfolgsseite und nicht nur beim
# Wiederversand: der Vertrag dieser Scheibe legt das Ziel der Umleitung auf
# genau "/einladung/senden?gesendet=1" fest und laesst keinen zweiten
# Parameter zu, an dem die Seite den Wiederversand erkennen koennte. Der
# Satz ist in beiden Faellen wahr -- nach diesem Versand gilt kein frueherer
# Link mehr --, beim ersten Versand allerdings gegenstandslos. Als offener
# Punkt vermerkt.
MELDUNG_GESENDET = "Einladung versandt. Der vorherige Link ist ungueltig."

MELDUNG_ADRESSE = (
    "Bitte eine E-Mail-Adresse angeben: ein Zeichen vor dem Klammeraffen, "
    "eines danach, ein Punkt im hinteren Teil, kein Leerraum.")

MELDUNG_NAME = (
    "Bitte einen Anzeigenamen angeben. Ohne ihn traegt das Konto keinen "
    "Namen, unter dem es jemand wiedererkennt.")

MELDUNG_PORTAL = (
    "Fuer dieses Portal wird nicht eingeladen: es ist noch nicht "
    "freigeschaltet.")

# HIER STAND MELDUNG_FREMDER_MANDANT ("Zu dieser Adresse besteht bereits ein
# Konto bei einem anderen Mandanten ..."). Sie ist am 14.08.2026 entfallen,
# nicht umformuliert: sie war eine Auskunft ueber den Bestand eines fremden
# Mandanten und verstiess gegen K03-M25 ("Fehlermeldungen geben nicht preis,
# ob ein Konto existiert"), K01-M15 und K02-D05. Die Begruendung im ganzen
# steht in _konto_sichern; dort ist auch der verbleibende Rest benannt, der
# im Datenmodell sitzt und nicht in app/.
#
# Sie kommt nicht als milderer Wortlaut zurueck. Ein eigener Zweig, der genau
# beim fremden Treffer anschlaegt, bleibt ein Orakel -- gleich wie hoeflich.

MELDUNG_MEHRDEUTIG = (
    "Zu dieser Adresse bestehen mehrere Konten, die sich nur in der Gross- "
    "und Kleinschreibung unterscheiden. Der Versand ist gesperrt, bis das "
    "geklaert ist.")

MELDUNG_GLEICHZEITIG = (
    "Zu diesem Konto ist zeitgleich eine andere Einladung entstanden. Es "
    "wurde nichts geaendert; bitte erneut versuchen.")

MELDUNG_VERSANDWEG = (
    "Die Einladung ist zurzeit nicht moeglich, weil der Dienst keinen "
    "Mailweg hat. Es wurde nichts angelegt, und es liegt nicht an Ihren "
    "Angaben. Bitte verstaendigen Sie den Betrieb.")

MELDUNG_VERSAND = (
    "Die Einladung konnte nicht zugestellt werden. Sie wurde deshalb "
    "widerrufen -- es besteht kein gueltiger Link. Der Fehlschlag steht im "
    "Versandnachweis.")

MELDUNG_ABGEWIESEN = (
    "Die Einladung wurde von der Datenbank abgewiesen. Es wurde nichts "
    "geaendert.")

MELDUNG_MITGLIEDSCHAFT = (
    "Fuer dieses Portal liesse sich kein Zugang einrichten -- es fuehrt "
    "nicht genau eine Rolle. Es wurde nichts angelegt, und es liegt nicht an "
    "Ihren Angaben. Bitte verstaendigen Sie den Betrieb.")


class _Abweisung(Exception):
    """Intern: der Versand ist abgewiesen, die Transaktion faellt zurueck.

    Anders als `_Misserfolg` bei Anmeldung und Einloesung TRAEGT diese
    Ausnahme ihren Grund. Dort waere er eine Kontoauskunft an einen
    Unbekannten; hier ist er die begruendete Sperre, die K20-G01 verlangt.
    """

    def __init__(self, meldung):
        super().__init__(meldung)
        self.meldung = meldung


def token_erzeugen():
    """Der Einmal-Link, einmal im Leben, aus einer kryptografischen Quelle.

    `token_urlsafe` liefert Zeichen, die in einer Adresszeile ohne
    Umschreibung stehen duerfen. Der Rueckgabewert wird von genau einer
    Stelle entgegengenommen und von dort nur noch zweimal benutzt: fuer den
    Streuwert und fuer die Mail.
    """
    return secrets.token_urlsafe(TOKEN_BYTES)


def streuwert_token(token):
    """sha256(FREIRAUM_CODE_PFEFFER + token), Hex, Kleinbuchstaben.

    Importiert statt nachgebaut -- es gibt genau eine Streuwertregel im Haus
    (mail/versand.py:113). Dieselbe Zeile fuehrt app/einladung.py beim
    Einloesen. Zwei Kopien derselben Rechnung driften auseinander, und das
    Ergebnis waere eine Einladung, die sich nie einloesen laesst.
    """
    return streuwert(token, CODE_PFEFFER)


def einladungslink(anfrage_basis, token):
    """Die Adresse, die in der Mail steht -- und nur dort.

    Der Token wandert als Abfrageparameter mit, weil der erste Aufruf aus
    einer Mail nichts anderes tragen kann. app/haupt.py verdeckt ihn dafuer
    im Zugriffsprotokoll, und die Bestaetigungsseite reicht ihn im Rumpf des
    POST weiter (K20-M08, K20-D03).
    """
    basis = BASIS_URL or str(anfrage_basis)
    return basis.rstrip("/") + "/einladung?token=" + quote(token, safe="")


def _waechtermeldung(fehler):
    """Die Meldung des Einladungswaechters -- im Wortlaut, nicht umformuliert.

    K20-G04: "Die Meldungen des Einladungswaechters werden am Ort der
    Ablehnung angezeigt ... Alle drei melden im Wortlaut aus Abschnitt 5."
    Der Ausloeser fuellt das Prozentzeichen zur Laufzeit aus der Datenbank
    -- mit der Domaene des Mandanten, mit seiner Frist. Wer den Satz hier
    nachbaut, baut eine zweite Fassung derselben Meldung und muss sie
    nachfuehren, sobald die Datenbank ihre eigene aendert.

    Unterschieden wird NICHT am Text, sondern an der Herkunft: eine
    RAISE EXCEPTION aus einem Ausloeser traegt keinen Bedingungsnamen, eine
    verletzte Tabellenbedingung traegt ihren. Nur die erste ist ein Satz
    fuer Menschen. Die zweite lautet 'new row for relation "invitation"
    violates check constraint "..."' und ist eine Betriebsangabe, die nach
    K23-D09 drinnen bleibt.
    """
    if fehler.diag.constraint_name is None and fehler.diag.message_primary:
        return fehler.diag.message_primary
    PROTOKOLL.warning("Einladung abgewiesen durch Bedingung %s",
                      fehler.diag.constraint_name)
    return MELDUNG_ABGEWIESEN


def _nachweis(conn, einladender, was, gegenstand, art, wert):
    """Eine Zeile in `event` -- K20-M18.

    Zeitpunkt (`occurred_at`, Vorgabe now()), handelnde Instanz
    (`actor_id`/`actor_label`) sowie Wert davor und danach. Die handelnde
    Instanz ist der EINLADENDE aus der Sitzung, nicht der Eingeladene: der
    Eingeladene hat nichts getan, er weiss zu diesem Zeitpunkt nicht einmal,
    dass es ihn hier gibt. Die Bedingung `event_actor_paarweise` verlangt
    zur Kennung auch den Namensschnappschuss; beide kommen aus derselben
    gepruften Sitzung.

    Weder Token noch Streuwert stehen hier, und auch die Adresse nicht:
    `object_ref` zeigt auf die Kennung der Zeile, und wer den Nachweis
    liest, findet den Vorgang und nicht den Zugang (K20-M08, K20-D03,
    K23-D09, K15).

    `retention_class` wird NICHT gesetzt. K20-M25 nennt fuer den Nachweis
    einer Zugangsaenderung BETRIEBSPROTOKOLL; M30 hat die Vorgabe der
    Tabelle am 04.08.2026 auf EREIGNIS umgestellt und haelt ausdruecklich
    fest, dass Altbestand mit BETRIEBSPROTOKOLL nachzuziehen waere
    (M30:1480-1496, Beschluss Nr. 60 Option A). Zwei Quellen, ein
    Widerspruch -- er wird gemeldet, nicht hier entschieden (CLAUDE.md
    Abschn. 3). Bis dahin gilt die Vorgabe der Tabelle, wie auch bei der
    Einloesung.
    """
    conn.execute(
        "INSERT INTO event (actor_id, actor_label, tenant_id, action,"
        " object_ref, change_type, value, source)"
        " VALUES (%s, %s, %s, %s, %s, %s, %s, 'PORTAL_ACTION')",
        (einladender["actor_id"], einladender["anzeigename"],
         einladender["mandant"], was, gegenstand, art, wert))


def _konto_sichern(conn, einladender, adresse, name):
    """Das Konto des Eingeladenen -- vorhandenes oder neues. K20-M07.

    `invitation.actor_id` ist NOT NULL: ohne Konto keine Einladung. Der
    Zustand des neuen Kontos ist die Vorgabe der Tabelle, WARTET_2FA --
    "fachlich weder aktiv noch gesperrt" (DDL Z. 155-157). AKTIV wird es
    erst durch die Einloesung (K20-M15); hier AKTIV zu setzen hiesse, den
    Zugang vor dem Link zu oeffnen.

    ZUR SCHREIBWEISE: Die Eindeutigkeit auf actor.email ist ZEICHENGENAU
    ("UNIQUE (email)", kein lower()). Diese Abfrage loest
    schreibweisenegal auf, und die Adresse wird kleingeschrieben abgelegt.
    Beides zusammen verhindert, dass hier ein zweites Konto zu A@x.de
    neben a@x.de entsteht -- der Fall, den app/anmeldung.py am 10.08.2026
    gemessen hat und seither fail-closed abweist. Die Wurzel liegt im
    Schema: richtig waere ein eindeutiger Index ueber lower(email). Das ist
    eine Aenderung am gezeichneten Modell, gehoert in einen
    Migrationsnachtrag und ist als offener Punkt gemeldet -- nicht in
    diesen Pfad.

    FOR UPDATE, damit zwei gleichzeitige Versande an dieselbe Adresse sich
    nicht gegenseitig ueberholen: der zweite wartet und findet dann das
    Konto des ersten vor, statt ein zweites anzulegen.

    UEBER DIE MANDANTENGRENZE wird nicht eingeladen -- und seit dem
    14.08.2026 wird sie auch nicht mehr ABGEFRAGT. Die Abfrage sucht
    ausschliesslich im Mandanten der Sitzung.

    BEFUND F1 der Fremdpruefung vom 14.08.2026: Bis heute suchte diese
    Stelle global nach lower(email), unterschied danach eigenen von fremdem
    Mandanten und zeigte im fremden Fall eine EIGENE Meldung ("Konto bei
    einem anderen Mandanten"). Wer einladen durfte, konnte damit Adressen
    durchprobieren und erfuhr, welche bei einem anderen Mandanten
    registriert sind. Der Vertrag verbietet das dreifach:

      K03-M25  Der Einladungsbefehl prueft Zielmandant, Nachweis und
               Domaene -- "Fehlermeldungen geben nicht preis, ob ein Konto
               existiert." Genau das tat die alte Meldung, im Klartext.
      K01-M15  "Jeder Lese- und Schreibzugriff MUSS auf den Mandanten der
               angemeldeten Sitzung eingeschraenkt sein. Ein Objekt eines
               fremden Mandanten gilt als NICHT VORHANDEN."
      K02-D05  "Ein Bestand eines fremden Mandanten DARF NICHT sichtbar,
               zaehlbar oder verdichtet erreichbar sein."

    K01-M15 entscheidet auch die Bauform. Eine bloss neutraler formulierte
    Meldung genuegt NICHT: ein eigener Zweig, der genau dann anschlaegt,
    wenn drueben ein Konto steht, ist auch mit hoeflichem Wortlaut ein
    Orakel. Nach K01-M15 ist die fremde Zeile nicht vorhanden -- also
    sieht diese Abfrage sie nicht, und es gibt keinen Zweig mehr.

    K20-G01 ("die Sperre wird begruendet angezeigt") steht dem nicht
    entgegen: es gibt hier keine Sperre mehr zu begruenden. Aus Sicht des
    Mandanten der Sitzung ist an dieser Adresse nichts, und der Weg laeuft
    weiter wie bei jeder unbekannten Adresse. Wo zwei Klauseln denselben
    Fall regeln, gilt die naeher stehende: K03-M25 spricht ueber die
    Fehlermeldungen DIESES Befehls.

    WAS DANN PASSIERT, und es ist der Rest des Befundes: Der Pfad legt ein
    neues Konto an, und die ZEICHENGENAUE, PLATTFORMWEITE Eindeutigkeit auf
    actor.email weist das ab -- UniqueViolation, Transaktion zurueck,
    MELDUNG_GLEICHZEITIG. Es entsteht nichts, die Mandantengrenze haelt
    also weiterhin. Aber der Wortlaut jener Meldung ("zeitgleich eine
    andere Einladung") trifft diesen Fall nicht, und ein Aufrufer kann
    Erfolg und Abweisung immer noch unterscheiden. Dieser Rest ist NICHT
    in app/ zu schliessen: er sitzt in "UNIQUE (email)" des gezeichneten
    Modells, das eine Adresse plattformweit einmal zulaesst. Ein Modell mit
    Eindeutigkeit je Mandant waere die Behebung; das ist ein
    Migrationsnachtrag und als offener Punkt gemeldet, nicht hier gebaut.

    Der urspruengliche Grund der Abweisung bleibt richtig und bleibt
    gewahrt: eine Einladung an ein fremdes Konto wuerde gegen Schranke und
    Frist eines FREMDEN Mandanten geprueft (der Waechter liest sie ueber
    invitation.actor_id) und einem fremden Konto ein Portal dieses Hauses
    oeffnen. Zugriff zwischen zwei Mandanten ist eines der fuenfzehn
    sperrenden Gates (K23 Abschn. 6). Er wird jetzt von der Datenbank
    gehalten statt von einer auskunftsfreudigen Meldung.

    `user_code` bleibt leer. Seit Blatt 62 steht die Rolle fest, der GRUND
    fuer die Luecke ist damit ein anderer geworden, die Luecke selbst
    bleibt: K20-M24 verlangt Praefix UND fortlaufende Nummer, bei
    Eindeutigkeitskonflikt wiederholt und niemals wiederverwendet. Weder das
    Praefixverzeichnis noch der Nummernkreis sind gebaut, und eine Kennung
    mit geratenem Praefix waere nach K20-M24 dauerhaft falsch -- sie ist
    nicht wiederverwendbar. Weiterhin offener Punkt, jetzt ohne Bezug auf
    Blatt 62.
    """
    zeilen = conn.execute(
        "SELECT id FROM actor"
        " WHERE lower(email) = %s AND tenant_id = %s"
        " ORDER BY id FOR UPDATE",
        (adresse, einladender["mandant"])).fetchall()

    if len(zeilen) > 1:
        # Mehrdeutig ist jetzt eine Aussage UEBER DEN EIGENEN MANDANTEN --
        # zwei Konten desselben Hauses, die sich nur in der Schreibweise
        # unterscheiden. Das ist keine Auskunft ueber Fremde (K01-M15).
        raise _Abweisung(MELDUNG_MEHRDEUTIG)

    if zeilen:
        kennung = zeilen[0][0]
        # Der Anzeigename eines BESTEHENDEN Kontos bleibt, wie er ist. Ihn
        # ueber das Einladungsformular zu ueberschreiben waere eine zweite,
        # unbenannte Aenderung an einem fremden Konto -- mit eigenem
        # Nachweis, eigener Klausel und eigenem Formular. Hier nicht.
        return kennung

    neu = conn.execute(
        "INSERT INTO actor (tenant_id, email, display_name)"
        " VALUES (%s, %s, %s) RETURNING id, status::text",
        (einladender["mandant"], adresse, name)).fetchone()
    _nachweis(conn, einladender, "KONTO_ANGELEGT", "ACTOR:" + str(neu[0]),
              "Neuanlage", "<kein Konto> -> " + neu[1])
    return neu[0]


def mitgliedschaft_entfernen(conn, einladender, einladung):
    """Die Mitgliedschaft zu einer widerrufenen oder abgelaufenen Einladung.

    Blatt 62, Zeichnung Nr. 2: "im Serverpfad des Widerrufs, gemeinsam mit
    K20-M13" -- nicht in einem eigenen Aufraeumlauf. Der Aufrufer hat die
    Einladungszeile soeben auf WIDERRUFEN gesetzt und uebergibt ihre Kennung;
    die Anweisung laeuft in derselben Transaktion.

    ANGESPROCHEN wird die Zeile ueber die EINLADUNG, nicht ueber Konto und
    Portal aus dem Aufrufer. Der Bezug steht damit in der Datenbank und nicht
    in zwei Argumenten, die auseinanderlaufen koennen: `i.actor_id` und
    `i.portal_code` sind genau die beiden Werte, aus denen die Zeile beim
    Versand entstanden ist.

    ZWEI BEDINGUNGEN HALTEN SIE ZURUECK, und beide haben einen eigenen Grund:

    1. `i.status <> 'EINGELOEST'` -- eine bereits eingeloeste Einladung
       entfernt NIE eine Mitgliedschaft. Nach K20-D05 fuehrt ohnehin allein
       VERSANDT -> WIDERRUFEN, die Bedingung koennte also nie greifen; sie
       steht trotzdem ausdruecklich da. Eine Bedingung, die man weglaesst,
       weil ein anderer Pfad sie heute erfuellt, ist keine Bedingung, sondern
       eine Annahme ueber fremden Code.

    2. Kein anderer TRAEGER mehr. Die Mitgliedschaft besteht, solange das
       Konto zu diesem Portal eine eingeloeste Einladung hat -- oder eine
       versandte, DEREN FRIST NOCH LAEUFT. Ist noch eine da, bleibt die Zeile
       stehen.

    DIE TRAEGERBEDINGUNG WIRD SEIT DEM 15.08.2026 GEGEN DIE UHR GERECHNET
    (Auftrag 9.4, Schritt 1). Bis dahin stand dort schlicht
    `t.status IN ('VERSANDT','EINGELOEST')`. Das war ein Traegerbegriff ohne
    Zeit, und er widerspricht der einzigen Ablaufregel, die dieses Haus hat:

      K20-M22  "Ablauf wird ausschliesslich aus `expires_at` abgeleitet; kein
               Lauf schreibt ABGELAUFEN."
      K20-D05  Der Platz wird NICHT ueber ABGELAUFEN frei.

    Beides zusammen heisst: eine verfallene Einladung steht weiter auf
    VERSANDT. Ihr Status sagt ueber den Ablauf nichts -- er kann es gar nicht,
    weil ihn niemand nachfuehren darf. Wer allein den Status liest, haelt jede
    verfallene Einladung fuer einen Traeger, und zwar fuer immer.

    Der Wortlaut ist nicht erfunden. Das Zielschema fuehrt fuer denselben
    Begriff bereits dieselbe Rechnung: die Sicht `invitation_offen` waehlt
    "status = 'VERSANDT' AND expires_at > now()" und begruendet es an Ort und
    Stelle -- "Der Abgleich mit der Uhr steht in der Sicht und nicht als
    gespeicherter Status, damit kein Hintergrundlauf noetig ist, um die
    Wahrheit herzustellen" (freiraum_datamodel.sql:858-865, Rang 1). Dieselbe
    Bedingung fuehrt app/einladung.py beim Einloesen (dort Z. 240-241). Hier
    stand als einzige Stelle im Bestand eine dritte, zeitlose Lesart. Sie ist
    entfallen.

    EINGELOEST BLEIBT OHNE UHR, und das ist Absicht. Eine eingeloeste
    Einladung ist verbraucht, nicht offen; ihre Frist ist gegenstandslos. Wer
    sie mitrechnete, naehme dem arbeitenden Nutzer den Zugang, sobald die
    Frist seiner alten Einladung verstreicht. Genau das darf nicht passieren
    (siehe unten).

    ES WIRD DABEI NIRGENDS ABGELAUFEN GESCHRIEBEN. Diese Anweisung liest
    `expires_at`, sie aendert keinen Status -- weder den der uebergebenen
    Einladung noch den irgendeiner anderen. K20-M22 und K20-D05 bleiben
    unberuehrt, und das Datenmodell ebenso: die Spalte `expires_at` steht seit
    jeher dort, es braucht keine Migration.

    Bedingung 2 ist der Grund, warum die REIHENFOLGE beim erneuten Versand
    (K20-M13) keine Falle ist. Sie wirkt in beide Richtungen:

      widerrufen -> entfernen -> neu anlegen -> anlegen   = eine Zeile
      widerrufen -> neu anlegen -> anlegen -> entfernen   = eine Zeile
                    (das Entfernen findet die neue offene Einladung und
                     laesst die Zeile stehen; das Anlegen faellt auf den
                     Schluesselkonflikt und tut nichts, siehe unten)

    Die Uhr aendert daran nichts: die soeben angelegte Einladung traegt eine
    Frist in der Zukunft. `_anlegen` rechnet sie als
    `now() + invite_ttl_hours`, und `invite_ttl_hours` liegt zwischen 1 und
    168 Stunden. Sie ist also im selben Augenblick, in dem sie entsteht, ein
    Traeger. Nachgemessen, nicht angenommen -- Fall B der Messung zu diesem
    Auftrag.

    Und sie ist genau die Regel, die ein spaeterer Aufraeumlauf braucht: wer
    eingeloest hat und danach eine zweite, verfallende Einladung bekommt,
    verliert seinen Zugang nicht. Der arbeitende Nutzer bleibt drin.

    ZUM WAECHTER `membership_platform_admin_guard`: er laeuft AFTER DELETE
    FOR EACH STATEMENT und zaehlt Konten mit `status = 'AKTIV'` und
    EXMA-Mitgliedschaft. Ein eingeladenes, noch nicht eingeloestes Konto steht
    auf WARTET_2FA und zaehlt nie mit -- das Entfernen seiner Mitgliedschaft
    kann die Zahl nicht senken. Nachgemessen am 11.08.2026, nicht geglaubt.

    Rueckgabe: nichts. Wo nichts zu entfernen war, steht auch keine
    Nachweiszeile -- K20-M18 verlangt sie zu jeder AENDERUNG, und was sich
    nicht geaendert hat, wird nicht behauptet.
    """
    entfernt = conn.execute(
        "WITH weg AS ("
        " DELETE FROM membership m"
        "  USING invitation i"
        "  WHERE i.id = %s"
        "    AND m.actor_id = i.actor_id"
        "    AND m.portal_code = i.portal_code"
        "    AND i.status <> 'EINGELOEST'"
        "    AND NOT EXISTS (SELECT 1 FROM invitation t"
        "                     WHERE t.actor_id = i.actor_id"
        "                       AND t.portal_code = i.portal_code"
        "                       AND (t.status = 'EINGELOEST'"
        "                            OR (t.status = 'VERSANDT'"
        "                                AND t.expires_at > now())))"
        " RETURNING m.actor_id, m.portal_code, m.role_id)"
        " SELECT w.actor_id, w.portal_code::text, r.name"
        "   FROM weg w JOIN role r ON r.id = w.role_id",
        (einladung,)).fetchall()

    for konto, portal, rolle in entfernt:
        _nachweis(conn, einladender, "MITGLIEDSCHAFT_ENTFERNT",
                  "MEMBERSHIP:" + str(konto), "Loeschung",
                  f"{portal}/{rolle} -> <keine Mitgliedschaft>")


def _mitgliedschaft_anlegen(conn, einladender, konto):
    """Die eine Zeile in `membership`. Blatt 62 A · K20-M04 · K20-M05.

    Alle vier Schluesselspalten sind durch den Versand bestimmt:

      actor_id     das eingeladene Konto
      portal_code  das Portal der Einladung -- dasselbe, das `_anlegen`
                   nach `invitation.portal_code` schreibt
      role_id      die EINE Rolle dieses Portals. In Release 1 fuehrt `role`
                   genau zwei Zeilen, eine je freigeschaltetem Portal
                   (F08, K01-M22)
      tenant_scope `actor.tenant_id` des EINGELADENEN Kontos

    `tenant_scope` kommt aus der Kontozeile und nicht aus der Sitzung des
    Einladenden, obwohl beide denselben Wert tragen: `_konto_sichern` sucht
    seit dem 14.08.2026 ausschliesslich im Mandanten der Sitzung und legt
    Neuanlagen ebendort an (K01-M15). Gelesen wird trotzdem der Wert, der
    tatsaechlich in der Zeile steht -- dieselbe Regel wie beim Nachweis.

    K20-D02 steht auch hier im Weg, und zwar mit demselben Verbund auf
    `portal_enabled` wie bei der Einladung: fuer ein Portal auf PLANNED wird
    keine Rolle vergeben und keine Mitgliedschaft angelegt. Trifft die Auswahl
    nichts, entsteht keine Zeile -- fail-closed (K20-G01).

    ON CONFLICT DO NOTHING ist kein Zugestaendnis, sondern die zweite Haelfte
    der Reihenfolgesicherung aus `mitgliedschaft_entfernen`. Der Schluessel
    ist (actor_id, portal_code, role_id, tenant_scope); ein zweites INSERT
    derselben Werte scheitert. Das trifft nicht nur den erneuten Versand: wird
    ein Konto eingeladen, das seine Einladung bereits EINGELOEST hat, findet
    K20-D05 nichts zu widerrufen, die Mitgliedschaft steht noch -- und ein
    hartes INSERT liefe in eine Eindeutigkeitsverletzung, die der Aufrufer als
    MELDUNG_GLEICHZEITIG deuten wuerde. Falsche Meldung, richtiger Bestand.
    Hier tut das INSERT dann nichts, und weil nichts geschah, entsteht auch
    keine Nachweiszeile.

    DANACH WIRD GEZAEHLT, in derselben Transaktion. Dieselbe Bauart wie die
    Abnahme in install/01_betreiber_und_erstadmin.sql: der Vertrag verlangt
    "genau eine Mitgliedschaft", also wird genau das gemessen und nicht aus
    dem Verlauf geschlossen. Die Zaehlung faengt beides ab -- ein Portal ohne
    Rolle (keine Zeile) und ein Portal mit zwei Rollen (zwei Zeilen, und
    K20-M05 waere gebrochen). Stimmt sie nicht, faellt der ganze Versand
    zurueck.
    """
    neu = conn.execute(
        "WITH neu AS ("
        " INSERT INTO membership (actor_id, portal_code, role_id, tenant_scope)"
        " SELECT a.id, r.portal_code, r.id, a.tenant_id"
        "   FROM actor a"
        "   JOIN role r ON r.portal_code = %s"
        "   JOIN portal_enabled p ON p.code = r.portal_code"
        "  WHERE a.id = %s"
        " ON CONFLICT DO NOTHING"
        " RETURNING actor_id, portal_code, role_id)"
        " SELECT n.actor_id, n.portal_code::text, r.name"
        "   FROM neu n JOIN role r ON r.id = n.role_id",
        (einladender["portal"], konto)).fetchall()

    bestand = conn.execute(
        "SELECT count(*) FROM membership"
        " WHERE actor_id = %s AND portal_code = %s",
        (konto, einladender["portal"])).fetchone()[0]
    if bestand != 1:
        PROTOKOLL.error("Mitgliedschaft nicht eindeutig: %s Zeilen fuer "
                        "Portal %s", bestand, einladender["portal"])
        raise _Abweisung(MELDUNG_MITGLIEDSCHAFT)

    for kennung, portal, rolle in neu:
        _nachweis(conn, einladender, "MITGLIEDSCHAFT_ANGELEGT",
                  "MEMBERSHIP:" + str(kennung), "Neuanlage",
                  f"<keine Mitgliedschaft> -> {portal}/{rolle}")


def _vorherige_widerrufen(conn, einladender, konto):
    """K20-M13 · K20-D05: zuerst widerrufen, dann zaehlen.

    In EINER Anweisung, mit Bedingung auf status = 'VERSANDT'. Der
    Teilindex `invitation_offen_uq` laesst hoechstens eine solche Zeile zu,
    also trifft sie hoechstens eine; ein vorgeschaltetes SELECT haette nur
    ein Zeitfenster geoeffnet.

    `FROM invitation v WHERE v.id = i.id` holt das Bild VOR der Aenderung:
    RETURNING allein liefert die neuen Werte, K20-M18 verlangt beide. Der
    Wert davor kann hier nur 'VERSANDT' sein -- die Bedingung erzwingt es.
    Er wird trotzdem gelesen und nicht angenommen: im Nachweis steht ein
    gemessener Wert oder gar keiner.

    Rueckgabe: die Nummer des naechsten Versuchs. K20-D05 sagt, dass ALLEIN
    dieser Weg den Zaehler erhoeht -- ohne Widerruf beginnt er also wieder
    bei 1 (Vorgabe der Tabelle). Eine abgelaufene Einladung steht
    weiterhin auf VERSANDT (K20-M22: kein Lauf schreibt ABGELAUFEN) und
    wird deshalb hier widerrufen und mitgezaehlt.

    UND SEIT BLATT 62 nimmt der Widerruf die Mitgliedschaft mit -- hier, in
    derselben Transaktion, unmittelbar hinter der Anweisung, die den Zustand
    gesetzt hat. Es ist zugleich die einzige Stelle im Bestand, an der eine
    ABGELAUFENE Einladung aufgeraeumt wird: nach K20-M22 schreibt kein Lauf
    ABGELAUFEN, eine verfallene Einladung steht weiter auf VERSANDT und wird
    beim naechsten Versand hier widerrufen. Der Ablauf OHNE folgenden Versand
    raeumt heute niemand auf -- als offener Punkt gemeldet, nicht still
    entschieden.

    DARAN AENDERT AUCH DER 15.08.2026 NICHTS. An diesem Tag ist die
    Traegerbedingung in `mitgliedschaft_entfernen` gegen die Uhr gerechnet
    worden (Auftrag 9.4, Schritt 1). Damit gibt eine verfallene Einladung die
    Zugangszeile frei, SOBALD JEMAND DIESE FUNKTION AUFRUFT. Wer sie aufruft,
    ist unveraendert allein der Widerruf -- hier und in `_zuruecknehmen`. Ein
    Lauf, der von sich aus nach verfallenen Einladungen sieht, ist NICHT
    gebaut: Blatt 63 vom 11.08.2026 hat ihn ausdruecklich nicht gewaehlt,
    sondern als Folgepunkt gefuehrt. Der offene Punkt bleibt also offen; er
    ist jetzt nur kleiner, weil die Bedingung, die ein solcher Lauf braeuchte,
    schon steht und schon gemessen ist.
    """
    widerrufen = conn.execute(
        "UPDATE invitation i SET status = 'WIDERRUFEN'"
        "  FROM invitation v"
        " WHERE v.id = i.id AND i.actor_id = %s AND i.status = 'VERSANDT'"
        " RETURNING i.id, v.status::text, i.status::text, i.attempt",
        (konto,)).fetchone()
    if widerrufen is None:
        return 1

    _nachweis(conn, einladender, "EINLADUNG_WIDERRUFEN",
              "INVITATION:" + str(widerrufen[0]), "Aenderung",
              f"{widerrufen[1]} -> {widerrufen[2]}")
    mitgliedschaft_entfernen(conn, einladender, widerrufen[0])
    return widerrufen[3] + 1


def _anlegen(conn, einladender, konto, adresse, streu):
    """Die Einladungszeile UND die Mitgliedschaft. K20-M07, K20-M11, K20-D02.

    Der Ablaufzeitpunkt wird von der DATENBANK gerechnet, aus
    `tenant.invite_ttl_hours` des Mandanten, dem das eingeladene Konto
    gehoert -- derselben Zeile, die auch der Waechter liest. Zwei Gruende:
    zwei Uhren sind zwei Wahrheiten (dieselbe Regel wie in app/sitzung.py),
    und ein in Python gerechneter Wert waere gegen eine andere Fassung der
    Frist gerechnet als die, an der der Waechter ihn misst.

    now() ist innerhalb einer Anweisung derselbe Zeitpunkt wie die Vorgabe
    von `sent_at`. Der Waechter prueft
    `NEW.expires_at > NEW.sent_at + ttl` und laesst Gleichheit durch --
    die Einladung schoepft die Frist damit genau aus, ohne sie zu
    ueberschreiten (K20-M11). `invitation_frist` verlangt zusaetzlich
    expires_at > sent_at; das ist erfuellt, solange die Frist des Mandanten
    mindestens eine Stunde betraegt, was die Bedingung
    `invite_ttl_hours BETWEEN 1 AND 168` sicherstellt.

    K20-G08: die Frist wirkt auf KUENFTIGE Einladungen. Deshalb wird sie
    hier gelesen und nicht irgendwo zwischengehalten.

    K20-D02 steht zweimal im Weg: als eigene Pruefung mit eigener Meldung
    und noch einmal als `EXISTS` in dieser Anweisung. Die erste erklaert
    dem Verwaltenden, was los ist; die zweite haelt auch dann, wenn das
    Portal zwischen den beiden Anweisungen abgeschaltet wird. Trifft die
    Auswahl nichts, entsteht keine Zeile -- fail-closed (K20-G01).

    DIE REIHENFOLGE, seit Blatt 62 vollstaendig:

      1. Portal freigeschaltet?                        (K20-D02)
      2. vorherige Einladung widerrufen -- und damit
         ihre Mitgliedschaft entfernen                 (K20-M13, Blatt 62)
      3. neue Einladung                                (K20-M07)
      4. Mitgliedschaft dazu                           (Blatt 62 A)

    Schritt 2 steht vor 3, weil K20-M13 es so verlangt und weil
    `invitation_offen_uq` keine zweite offene Einladung zulaesst. Fuer die
    Mitgliedschaft ist die Reihenfolge dennoch nicht tragend: beide Anweisungen
    sind gegen die jeweils andere abgesichert (siehe dort). Alles zusammen in
    EINER Transaktion -- keine Einladung ohne Mitgliedschaft, keine
    Mitgliedschaft ohne Einladung (K20-M22, Blatt 62).
    """
    if conn.execute("SELECT 1 FROM portal_enabled WHERE code = %s",
                    (einladender["portal"],)).fetchone() is None:
        raise _Abweisung(MELDUNG_PORTAL)

    versuch = _vorherige_widerrufen(conn, einladender, konto)

    neu = conn.execute(
        "INSERT INTO invitation (actor_id, portal_code, mail, token_hash,"
        "                        expires_at, attempt)"
        " SELECT a.id, %s, %s, %s,"
        "        now() + make_interval(hours => t.invite_ttl_hours::int), %s"
        "   FROM actor a JOIN tenant t ON t.id = a.tenant_id"
        "  WHERE a.id = %s"
        "    AND EXISTS (SELECT 1 FROM portal_enabled p WHERE p.code = %s)"
        " RETURNING id, status::text",
        (einladender["portal"], adresse, streu, versuch, konto,
         einladender["portal"])).fetchone()
    if neu is None:
        raise _Abweisung(MELDUNG_ABGEWIESEN)

    _nachweis(conn, einladender, "EINLADUNG_VERSANDT",
              "INVITATION:" + str(neu[0]), "Neuanlage",
              "<keine Einladung> -> " + neu[1])
    _mitgliedschaft_anlegen(conn, einladender, konto)
    return neu[0]


def _zuruecknehmen(conn, einladender, kennung):
    """Die eben angelegte Einladung widerrufen, weil die Mail nicht ankam.

    Dieselbe Bauart wie beim Anmeldecode: `mail/versand.py` entwertet einen
    Code, dessen Mail scheiterte, weil er nie zugestellt wurde. Eine
    Einladung, deren Link niemand hat, waere sonst eine offene Einladung,
    die den einen Platz je Konto besetzt (K20-M12) und die niemand einloesen
    kann.

    WIDERRUFEN und nicht ABGELAUFEN: K20-D05 laesst den Platz allein ueber
    den Widerruf frei werden.

    In EIGENER Transaktion. Die Einladung ist zu diesem Zeitpunkt bereits
    festgeschrieben -- sie musste es sein, sonst gaebe es einen Link in der
    Welt, den die Datenbank nicht kennt.

    Der Widerruf laeuft erneut durch `invitation_guard_trg` (BEFORE UPDATE).
    Wurde die Frist des Mandanten in derselben Sekunde gesenkt, weist der
    Waechter ihn ab; dann bleibt die Einladung offen stehen. Der Verwaltende
    sieht in beiden Faellen denselben Fehlschlag, und der naechste Versand
    widerruft sie nach K20-M13 ohnehin.
    """
    try:
        with conn.transaction():
            zurueck = conn.execute(
                "UPDATE invitation i SET status = 'WIDERRUFEN'"
                "  FROM invitation v"
                " WHERE v.id = i.id AND i.id = %s AND i.status = 'VERSANDT'"
                " RETURNING i.id, v.status::text, i.status::text",
                (kennung,)).fetchone()
            if zurueck is not None:
                _nachweis(conn, einladender, "EINLADUNG_WIDERRUFEN",
                          "INVITATION:" + str(zurueck[0]), "Aenderung",
                          f"{zurueck[1]} -> {zurueck[2]}")
                # Blatt 62: derselbe Serverpfad, dieselbe Transaktion. Ohne
                # diese Zeile bliebe nach einem Zustellfehlschlag ein Zugang
                # zu einer Einladung stehen, die niemand hat.
                mitgliedschaft_entfernen(conn, einladender, zurueck[0])
    except psycopg.errors.CheckViolation:
        PROTOKOLL.error("Einladung nach Versandfehler nicht widerrufen: der "
                        "Waechter hat den Widerruf abgewiesen.")


def einladung_senden(conn, einladender, email, anzeigename, anfrage_basis):
    """Der ganze Weg. Rueckgabe: None bei Erfolg, sonst die Meldung.

    `einladender` ist der Stand der gepruften Sitzung aus app/sitzung.py --
    Konto, Anzeigename, Mandant und Portal des Verwaltenden. Er kommt aus
    der Datenbank und nicht aus dem Formular; wer einlaedt, waehlt nicht
    aus, in wessen Namen.

    REIHENFOLGE, und sie ist der ganze Punkt:

      1. Form der Eingaben. Ohne Datenbank, ohne Nebenwirkung.
      2. Versandweg. VOR jedem Schreibvorgang -- ein Konto und eine
         Einladung anzulegen, von denen von vornherein feststeht, dass ihre
         Mail nicht hinausgeht, waere Muell im Bestand.
      3. Konto, Widerruf, Einladung und Mitgliedschaft in EINER Transaktion
         (K20-M22, Blatt 62). Scheitert eine der vier Stellen, entsteht
         keine der anderen.
      4. Erst danach die Mail. Andersherum gaebe es einen Link in der Welt,
         den die Datenbank nicht kennt -- dieselbe Ueberlegung wie beim
         Anmeldecode (mail/versand.py:201).
      5. Scheitert die Zustellung, wird die Einladung widerrufen.

    Der Klartext-Token lebt in Schritt 3 bis 5 als lokale Veraenderliche.
    Er wird nicht zurueckgegeben, nicht protokolliert und nicht angezeigt
    (K20-M08, K20-D03).
    """
    adresse = (email or "").strip().lower()
    name = (anzeigename or "").strip()

    if not ADRESSE_MUSTER.match(adresse):
        return MELDUNG_ADRESSE
    if not name:
        return MELDUNG_NAME

    fehlt = versandweg_fehlt()
    if fehlt:
        # Die Gruende nennen Namen von Umgebungswerten und die
        # Absenderdomaene -- Betriebsangaben. Sie gehoeren ins Protokoll des
        # Betreibers und nicht auf den Bildschirm (K23-D09).
        PROTOKOLL.error("Kein Versandweg: %s", " · ".join(fehlt))
        return MELDUNG_VERSANDWEG

    token = token_erzeugen()

    try:
        with conn.transaction():
            konto = _konto_sichern(conn, einladender, adresse, name)
            kennung = _anlegen(conn, einladender, konto, adresse,
                               streuwert_token(token))
    except _Abweisung as abweisung:
        return abweisung.meldung
    except psycopg.errors.UniqueViolation:
        # `invitation_offen_uq` oder die Eindeutigkeit auf actor.email: ein
        # zweiter Versand war schneller. Nichts ist geaendert -- die
        # Transaktion nimmt alles mit zurueck (K20-M12, K20-G01).
        return MELDUNG_GLEICHZEITIG
    except psycopg.errors.CheckViolation as fehler:
        # Hier kommt der Einladungswaechter zu Wort: Domaenenschranke
        # (K20-D04, K20-M10) und Fristobergrenze (K20-M11). Sein Wortlaut
        # geht unveraendert nach draussen (K20-G04).
        #
        # Seit Blatt 62 kann an derselben Stelle auch
        # `membership_platform_admin_guard` melden -- er haengt am Entfernen
        # der Mitgliedschaft und wirft mit demselben Fehlercode. Sein Satz
        # ("Mindestens ein aktiver Plattform-Admin muss bestehen bleiben")
        # nennt keine Betriebsangabe und keine Person und darf deshalb
        # denselben Weg nach draussen nehmen. Ausloesen kann ihn dieser Pfad
        # nach der Messung vom 11.08.2026 nicht: das eingeladene Konto steht
        # auf WARTET_2FA und wird vom Waechter nicht gezaehlt.
        return _waechtermeldung(fehler)

    try:
        mail_einladung(conn, adresse, einladungslink(anfrage_basis, token))
    except VersandFehler:
        # Der Fehlschlag steht bereits als Zeile in `mail_delivery` -- ohne
        # Zustellnachweis ist eine gescheiterte Einladung nicht von einer
        # nicht gesendeten zu unterscheiden (Bauauftrag B2).
        _zuruecknehmen(conn, einladender, kennung)
        return MELDUNG_VERSAND

    return None
