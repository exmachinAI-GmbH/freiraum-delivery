"""FREIRAUM · Scheibe 1 · der Versand der Einladung.

Die Gegenseite zu app/einladung.py. Dort wird ein Link eingeloest, hier
entsteht er. Bis heute beruehrte nichts in app/ die Tabelle `invitation`
schreibend: der Streuwert kam von Hand in die Datenbank, und
mail/versand.py bekam den fertigen Link als Parameter. Damit war der Weg
"Verwaltender laedt jemanden ein" nirgends gebaut.

Acht Klauseln bestimmen den Zuschnitt:

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
  K20-D02  Kein Versand fuer ein Portal mit release_status = PLANNED.
           Geprueft wird gegen die Sicht `portal_enabled`, nicht gegen
           `portal` -- dieselbe Regel, die app/sitzung.py beim Anmelden
           fuehrt (F04, K13).
  K20-D04  Eine Einladung ausserhalb der Domaenenschranke entsteht nicht --
           "auch nicht auf Zuruf, auch nicht fuer einen Verwaltenden". Die
           Schranke haelt der Ausloeser `invitation_guard_trg`; dieser Pfad
           baut sie NICHT nach, er laesst sie zu Wort kommen (siehe
           _waechtermeldung).
  K20-M18  Jede Aenderung an Zugang und Einladung steht mit Zeitpunkt,
           handelnder Instanz sowie Wert davor und danach in `event`.

UND HIER GILT DAS GEGENTEIL DER ANMELDUNG: die Meldungen sind
unterscheidbar. Bei Anmeldung (K03-M16) und Einloesung (K20-D10) steht ein
Unbekannter vor der Tuer, und jede Fallunterscheidung waere eine
Kontoauskunft. Hier steht ein angemeldeter Verwaltender, der eine Adresse
selbst eingegeben hat -- ihm zu verschweigen, WARUM sein Versand scheitert,
hilft niemandem und widerspricht K20-G01 ("Die Sperre wird begruendet
angezeigt, nie stillschweigend gesetzt") und K20-G04 ("Die Meldungen des
Einladungswaechters werden am Ort der Ablehnung angezeigt ... im Wortlaut").

WAS HIER NICHT STEHT: die Mitgliedschaft. Ob sie beim Versand oder bei der
Einloesung entsteht, liegt den Foundern als Blatt 62 vor und ist NICHT
entschieden. Es entsteht deshalb keine `membership`-Zeile und auch keine
vorbereitete Stelle dafuer (CLAUDE.md Abschn. 6: keine offene Frage still
entscheiden). Folge, ausdruecklich benannt: das eingeladene Konto kann sich
nach der Einloesung noch NICHT anmelden -- app/sitzung.py verlangt genau
ein Portal ueber `membership` (K03-M11) und findet keines. Der Faden bleibt
offen, bis Blatt 62 gezeichnet ist.
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

MELDUNG_FREMDER_MANDANT = (
    "Zu dieser Adresse besteht bereits ein Konto bei einem anderen "
    "Mandanten. Eine Einladung ueber die Mandantengrenze hinweg wird nicht "
    "ausgestellt.")

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

    UEBER DIE MANDANTENGRENZE wird nicht eingeladen. Findet sich die
    Adresse bei einem anderen Mandanten, ist der Versand abgewiesen: die
    Einladung wuerde sonst gegen die Domaenenschranke und die Frist eines
    FREMDEN Mandanten geprueft (der Waechter liest sie ueber
    invitation.actor_id) und einem fremden Konto ein Portal dieses Hauses
    oeffnen. Zugriff zwischen zwei Mandanten ist eines der fuenfzehn
    sperrenden Gates (K23 Abschn. 6).

    `user_code` bleibt leer. K20-M24 laesst ihn den Server aus einem
    portal- und ROLLENbezogenen Praefix bilden -- die Rolle steht in der
    `membership`, und die ist ausdruecklich nicht Gegenstand (Blatt 62).
    Eine Kennung mit geratenem Praefix waere nach K20-M24 nicht
    wiederverwendbar und damit dauerhaft falsch. Offener Punkt.
    """
    zeilen = conn.execute(
        "SELECT id, tenant_id FROM actor WHERE lower(email) = %s"
        " ORDER BY id FOR UPDATE",
        (adresse,)).fetchall()

    if len(zeilen) > 1:
        raise _Abweisung(MELDUNG_MEHRDEUTIG)

    if zeilen:
        kennung, mandant = zeilen[0]
        if mandant != einladender["mandant"]:
            raise _Abweisung(MELDUNG_FREMDER_MANDANT)
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
    return widerrufen[3] + 1


def _anlegen(conn, einladender, konto, adresse, streu):
    """Die Einladungszeile. K20-M07, K20-M11, K20-D02.

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
      3. Konto, Widerruf und Einladung in EINER Transaktion (K20-M22).
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
