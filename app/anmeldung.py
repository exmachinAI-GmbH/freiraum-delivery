"""FREIRAUM · Scheibe 1 · der Serverpfad der Anmeldung.

Hier wird der Code geprueft, verbraucht und der Kontozustand gesetzt. Vier
Klauseln bestimmen den Zuschnitt:

  K03-M15  Zehn Minuten, genau EINMAL. Der Verbrauch ist ein UPDATE mit
           Bedingung, kein "erst lesen, dann schreiben" -- zwei gleichzeitige
           Anmeldungen mit demselben Code duerfen nicht beide gewinnen.
  K03-M16  Fuenf falsche Codes entwerten ihn, 15 Minuten Drosselung. Das
           haelt die DATENBANK: der Ausloeser login_attempt_guard weist den
           sechsten Versuch ab, login_attempt_koppelt_code zaehlt und
           entwertet. Hier wird sie GENUTZT, nicht nachgebaut.
  K03-M09  WARTET_2FA nach AKTIV nur aus bestaetigter zweiter Stufe, im
           selben Vorgang last_login_at. Die Datenbank erzwingt das NICHT
           (gemessen am 10.08.2026); dieser Pfad erzwingt es, in EINER
           Transaktion mit dem Verbrauch des Codes.
  K03-M11  Genau ein Portal ueber membership; nie zwei (K03-D02).

Und eine Meldung fuer alles. K03-M16 verlangt die Drosselung "ohne die
Existenz eines Kontos preiszugeben". Eine je Fall abweichende Meldung ist
eine Kontoauskunft: wer den Unterschied zwischen "Code falsch" und "Konto
unbekannt" sieht, hat ein Adressverzeichnis. Auch die Meldungen der
Datenbank -- "KONTO-SPERRE: 5 Fehlversuche ..." -- bleiben drinnen.
"""
import hashlib

import psycopg

from app.datenbank import CODE_PFEFFER
from app.sitzung import portal_bestimmen
from mail.versand import streuwert

# WOERTLICH. Ein Punkt mehr oder weniger ist eine andere Meldung, und eine
# zweite Fassung derselben Meldung ist der Anfang der Fallunterscheidung.
MELDUNG_MISSERFOLG = "Anmeldung nicht moeglich. Pruefen Sie Adresse und Code."

# Die Kennung, gegen die gerechnet wird, wenn es das Konto nicht gibt oder die
# Adresse mehrdeutig ist. Sie kommt in actor nicht vor -- die Abfrage laeuft,
# findet nichts und kostet dieselbe Zeit wie eine, die etwas findet. Ohne diesen
# Umweg verriete die Laufzeit, ob ein Konto existiert (K03-M16).
_KEIN_KONTO = "00000000-0000-0000-0000-000000000000"


class _Misserfolg(Exception):
    """Intern: die Anmeldung ist gescheitert, die Transaktion faellt zurueck.

    Der Grund steht bewusst NICHT drin. Es gibt keinen Ort, an dem er
    gebraucht wuerde: nach aussen gilt die eine Meldung (K03-M16), und was
    gezaehlt werden muss, zaehlt die Datenbank in login_attempt.
    """


def streuwert_code(code):
    """Pruefwert des Anmeldecodes -- dieselbe Rechnung wie beim Ausstellen.

    Importiert statt nachgebaut: mail/versand.py legt den Wert an, dieser
    Pfad prueft ihn. Zwei Kopien derselben Rechnung driften auseinander, und
    das Ergebnis waere eine Anmeldung, die fuer alle stumm scheitert.
    Entscheidung D vom 10.08.2026 belegt den Pfeffer auf BEIDEN Seiten.
    """
    return streuwert(code, CODE_PFEFFER)


def herkunft_streuwert(herkunft):
    """Die Herkunft gehashed -- login_attempt.origin_hash ist NOT NULL.

    Mit Pfeffer, aus demselben Grund wie beim Code (BEF-B2-2): ein blanker
    SHA-256 ueber eine IPv4-Adresse ist ueber 2^32 Kandidaten in Minuten
    zurueckgerechnet, und dann steht die Adresse doch im Bestand. Das
    Praefix trennt die beiden Verwendungen desselben Geheimnisses.
    """
    return hashlib.sha256(
        ("herkunft:" + CODE_PFEFFER + (herkunft or "")).encode("utf-8")).hexdigest()


def _versuch_buchen(conn, adresse, herkunft, erfolg):
    """Eine Zeile in login_attempt. Sie ist die Sperre, nicht nur die Statistik.

    Der Ausloeser login_attempt_guard prueft VOR dem Einfuegen, ob in den
    letzten 15 Minuten schon fuenf Fehlversuche zu dieser Adresse stehen, und
    weist dann ab. Diese Zeile ist also der Punkt, an dem K03-M16 wirkt --
    deshalb wird sie auf BEIDEN Wegen geschrieben, auch beim Erfolg.
    """
    conn.execute(
        "INSERT INTO login_attempt (email, origin_hash, success)"
        " VALUES (%s, %s, %s)", (adresse, herkunft, erfolg))


def _fehlversuch_buchen(conn, adresse, herkunft):
    """Der Fehlversuch in EINEM EIGENEN Vorgang.

    Er darf nicht in der Transaktion des Vollzugs stehen: die faellt beim
    Misserfolg zurueck und naehme den Zaehler mit. Eine Drosselung, die sich
    beim Scheitern selbst loescht, ist keine Drosselung (K03-M16).
    """
    try:
        with conn.transaction():
            _versuch_buchen(conn, adresse, herkunft, False)
    except psycopg.errors.CheckViolation:
        # Bereits gedrosselt: der Waechter nimmt die Zeile nicht mehr an.
        # Der Versuch bleibt ungezaehlt -- gesperrt ist er trotzdem, die
        # Sperre traegt sich aus den bereits gezaehlten fuenf.
        pass


def _vollzug(conn, adresse, eingabe):
    """Prueft, verbraucht, setzt den Zustand, eroeffnet die Sitzung.

    Ein einziger Vorgang. Jeder Schritt endet bei Zweifel mit _Misserfolg;
    dann faellt alles zurueck -- kein verbrauchter Code ohne Sitzung, kein
    AKTIV ohne Verbrauch (K03-M09, K03-G01).
    """
    # BEFUND 1 (Gegenlesung 10.08.2026): Die Eindeutigkeit auf actor.email ist
    # SCHREIBWEISENGENAU -- "CREATE UNIQUE INDEX actor_email_key ON actor
    # (email)". Diese Abfrage loest SCHREIBWEISENEGAL auf. Beides zusammen
    # ergibt eine Mehrdeutigkeit: gemessen am 10.08.2026 lassen sich
    # anna@pruef.test und Anna@pruef.test nebeneinander anlegen, und die
    # Abfrage findet BEIDE. Ein fetchone() haette eine davon genommen -- welche,
    # bestimmt die Zeilenreihenfolge, die PostgreSQL nicht zusichert.
    #
    # Deshalb fetchall() und die harte Forderung "genau eine". Null Zeilen
    # heisst unbekannt, zwei heissen mehrdeutig -- beides sperrt (K03-G01:
    # was nicht pruefbar ist, sperrt).
    #
    # Die Wurzel liegt im Schema und nicht hier: richtig waere ein eindeutiger
    # Index ueber lower(email). Das ist eine Aenderung am gezeichneten Modell
    # und gehoert in einen Migrationsnachtrag, nicht in diesen Pfad.
    zeilen = conn.execute(
        "SELECT id, status, mfa_method FROM actor WHERE lower(email) = %s"
        " ORDER BY id FOR UPDATE",
        (adresse,)).fetchall()

    # ZEITSEITENKANAL (Gegenlesung 10.08.2026): Ein Abbruch an dieser Stelle
    # verliess die Datenbank nach EINER Anweisung, waehrend jedes existierende
    # Konto mindestens zwei brauchte. Gemessen ueber 200 Runden war der
    # Unterschied statistisch trennbar -- und damit eine Kontoauskunft, die
    # K03-M16 ausdruecklich verbietet ("ohne die Existenz eines Kontos
    # preiszugeben"). Der Meldungstext half nicht: die Uhr sprach.
    #
    # Also wird NICHT hier abgebrochen. Der Weg laeuft in jedem Fall durch
    # dieselben Anweisungen; erst danach faellt die Entscheidung. Ein
    # unbekanntes Konto rechnet gegen eine Kennung, die es nicht gibt.
    tragfaehig = len(zeilen) == 1
    actor_id = zeilen[0][0] if tragfaehig else _KEIN_KONTO
    status = zeilen[0][1] if tragfaehig else "AKTIV"
    # Derselbe Umweg wie bei `status`: Ein unbekanntes Konto rechnet gegen einen
    # unverfaenglichen Wert weiter, damit die Uhr nichts verraet (siehe oben).
    verfahren = zeilen[0][2] if tragfaehig else "EMAIL_CODE"

    # K03-D01: GESPERRT fuehrt zur Ablehnung, nie zum Teil-Zugang. WARTET_2FA
    # bleibt hier zulaessig -- genau dieser Vorgang ist die bestaetigte
    # zweite Stufe, aus der der Uebergang nach AKTIV entsteht (K03-M09).
    if status not in ("AKTIV", "WARTET_2FA"):
        tragfaehig = False

    # K03-M05, Punkt 3: `mfa_method` traegt den Wert EMAIL_CODE.
    #
    # NEU AM 23.08.2026. Bis hierher wurde `actor.mfa_method` auf dem
    # Anmeldeweg ueberhaupt nicht gelesen -- gemessen: kein Treffer in `app/`
    # und `mail/`. Das Zielschema laesst neben EMAIL_CODE auch OFF zu
    # (schema/freiraum_datamodel.sql). Ein Konto mit OFF und einem gueltigen
    # login_code waere also angemeldet worden, obwohl es den zweiten Faktor
    # gar nicht fuehrt. Befund: Fremdreview vom 20.08.2026, Grund 2.
    #
    # DIE ENTSCHEIDUNG IST GEZEICHNET, nicht hier getroffen: A. Han,
    # 23.08.2026, `arbeit/Vorlagen/zeichnung_akzeptanzkriterien_260823.md`,
    # Abschnitt 1 -- "abweisen mit der bestehenden Meldung, die keinen Grund
    # nennt". Eine eigene Meldung fuer diesen Fall waere das Kontoorakel, das
    # K03-M25 verbietet: Wer den Unterschied liest, weiss, dass es das Konto
    # gibt und wie es eingestellt ist.
    #
    # Deshalb steht die Pruefung HIER und nicht frueher: Sie setzt nur
    # `tragfaehig` zurueck und laesst den Weg weiterlaufen -- derselbe Grund
    # wie beim Zeitseitenkanal oben.
    #
    # OFFEN UND NICHT VON DIESER STELLE ZU LOESEN: Beschluss Nr. 59 sieht in
    # migrations/M30__pilot_sammelmigration.sql:988-993 GENAU EIN Konto mit
    # mfa_method = OFF vor. Es ist vorgesehen, aber unbenutzt -- der
    # Erst-Admin wird mit EMAIL_CODE angelegt
    # (install/01_betreiber_und_erstadmin.sql:101). Ab hier wuerde es sich
    # nicht mehr anmelden koennen. Ob die Vorsorge zurueckgenommen wird, ist
    # eine Aenderung an der Sammelmigration und gehoert in einen
    # Migrationsnachtrag, nicht in diesen Pfad.
    if verfahren != "EMAIL_CODE":
        tragfaehig = False

    # K03-M15 in einer Anweisung: den offenen, nicht abgelaufenen, nicht
    # entwerteten Code des Kontos verbrauchen -- und nur, wenn der Pruefwert
    # stimmt. Als UPDATE ... RETURNING ist der Verbrauch atomar: der zweite
    # Aufruf mit demselben Code findet consumed_at gesetzt und bekommt keine
    # Zeile zurueck. Ein vorheriges SELECT haette ein Zeitfenster gelassen.
    verbraucht = conn.execute(
        "UPDATE login_code SET consumed_at = now()"
        " WHERE id = (SELECT id FROM login_code"
        "              WHERE actor_id = %s AND consumed_at IS NULL"
        "                AND superseded_at IS NULL AND expires_at > now()"
        "              ORDER BY issued_at DESC LIMIT 1)"
        "   AND code_hash = %s"
        " RETURNING id",
        (actor_id, streuwert_code(eingabe))).fetchone()
    if verbraucht is None or not tragfaehig:
        # Deckt in EINEM Zweig ab: falscher Code, abgelaufener Code,
        # verbrauchter Code, entwerteter Code, gar kein Code -- und seit der
        # Gegenlesung vom 10.08.2026 auch das unbekannte, das mehrdeutige und
        # das gesperrte Konto. Nach aussen sind das ohnehin nicht
        # unterscheidbare Faelle (K03-M16); jetzt sind sie es auch auf der Uhr.
        #
        # Der Rueckfall ist folgenlos: alles laeuft in der Transaktion des
        # Aufrufers, und _Misserfolg rollt sie zurueck. Ein gesperrtes Konto
        # verliert seinen Code also NICHT, obwohl das UPDATE gefahren wurde.
        raise _Misserfolg

    portal = portal_bestimmen(conn, actor_id)
    if portal is None:
        raise _Misserfolg           # K03-M11 · K03-D02 · fail-closed

    # K03-M09: der Uebergang und last_login_at im SELBEN Vorgang wie der
    # Verbrauch. Die Bedingung im WHERE ist der eigentliche Waechter -- die
    # Datenbank laesst ein Konto auch unmittelbar auf AKTIV setzen (gemessen
    # am 10.08.2026), hier ist AKTIV nur ueber diesen Pfad erreichbar.
    # K03-G05: last_login_at ist Anzeige und bleibt leer, solange kein Code
    # bestaetigt wurde -- also wird es genau hier gesetzt, nicht frueher.
    gesetzt = conn.execute(
        "UPDATE actor SET status = 'AKTIV', last_login_at = now()"
        " WHERE id = %s AND status IN ('WARTET_2FA','AKTIV')"
        " RETURNING id", (actor_id,)).fetchone()
    if gesetzt is None:
        raise _Misserfolg

    # Jede Anmeldung eroeffnet eine NEUE Zeile. Eine bestehende Sitzung
    # weiterzuverwenden waere Sitzungsfixierung (K03-M21).
    # Der Ausloeser auth_session_event_trg schreibt im selben Vorgang die
    # Protokollzeile; scheitert sie, scheitert die Anmeldung.
    neu = conn.execute(
        "INSERT INTO auth_session (actor_id) VALUES (%s) RETURNING id",
        (actor_id,)).fetchone()
    return neu[0]


def anmelden(conn, email, code, herkunft):
    """Der ganze Weg. Rueckgabe: Kennung der Sitzung, oder None.

    None traegt keinen Grund. Der Aufrufer hat auch keinen zu unterscheiden:
    es gibt genau eine Meldung (K03-M16).
    """
    adresse = (email or "").strip().lower()
    eingabe = (code or "").strip()
    quelle = herkunft_streuwert(herkunft)

    try:
        with conn.transaction():
            sitzung_id = _vollzug(conn, adresse, eingabe)
            # ZULETZT: der Erfolg wird im selben Vorgang gebucht. Steht das
            # Konto in der Drosselung, weist login_attempt_guard hier ab --
            # und nimmt Verbrauch, Zustandswechsel und Sitzung mit zurueck.
            # Ein richtiger Code hebt eine laufende Sperre nicht auf.
            _versuch_buchen(conn, adresse, quelle, True)
            return sitzung_id
    except _Misserfolg:
        pass
    except psycopg.errors.CheckViolation:
        # Der Waechter der Datenbank: "KONTO-SPERRE: 5 Fehlversuche, 15
        # Minuten Wartezeit (Nr. 35)" oder die Herkunftssperre. Diese
        # Meldungen sind eine Kontoauskunft und bleiben hier -- nach aussen
        # gilt MELDUNG_MISSERFOLG (K03-M16).
        pass

    _fehlversuch_buchen(conn, adresse, quelle)
    return None
