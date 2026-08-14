# umsetzt: K20-M08, K20-M14, K20-M15, K20-M18, K20-D10, K03-M05, K03-M26
# zur Haelfte umgesetzt: K03-G01 -- siehe "K03-G01 IST HIER HALB GEBAUT" im Kopf
"""FREIRAUM · Scheibe 1 · die Einloesung der Einladung.

Der Weg vom Link in der Mail zum freigeschalteten Konto. Fuenf Klauseln
bestimmen den Zuschnitt:

  K20-M08  Gespeichert ist allein der Streuwert. Wer `invitation` lesen darf,
           haelt Pruefwerte und keine Links -- er kann keine fremde Einladung
           einloesen. Der Klartext-Token steht nie in Log, Datenbank,
           Fehlerausgabe oder Manifest (K14-M13, K23-D09).
  K20-M14  Zustand und Zeitpunkt gehoeren zusammen. Die Bedingung
           `invitation_einloesung` erzwingt es bereits; dieser Pfad setzt
           beides trotzdem in EINER Anweisung. Eine Bedingung ist ein Netz,
           kein Plan -- wer sich auf sie verlaesst, hat die Reihenfolge nicht
           festgelegt, sondern nur ihre schlimmste Auswirkung abgefangen.
  K20-M15  WARTET_2FA nach AKTIV, in DERSELBEN Transaktion wie die
           Einloesung. Kein freigeschaltetes Konto ohne verbrauchte
           Einladung, keine verbrauchte Einladung ohne freigeschaltetes Konto.
  K20-D10  Eine abgelaufene, eingeloeste oder widerrufene Einladung wirkt
           nicht erneut. Ein verfallener Link fuehrt zu einem NEUEN Vorgang,
           nie zu einer Verlaengerung -- deshalb ruehrt dieser Pfad weder
           `expires_at` noch `attempt` an. Wer die Frist beim Einloesen
           nachzoege, haette aus jeder abgelaufenen Einladung eine ewige
           gemacht.
  K20-M18  Jede Aenderung an Zugang und Einladung steht mit Zeitpunkt,
           handelnder Instanz sowie Wert davor und danach in `event`.

Und eine Meldung fuer alles. Wer aus der Antwort ablesen koennte, ob ein
Streuwert existiert, haelt ein Orakel: er probiert Links durch, bis einer
"schon eingeloest" statt "unbekannt" sagt, und weiss dann, welche Adressen
eingeladen sind. Unbekannt, abgelaufen, eingeloest, widerrufen, gesperrtes
Konto -- ein Wortlaut, ein Weg, dieselbe Anzahl Anweisungen (K03-G01).

K03-G01 IST HIER HALB GEBAUT, und seit dem 14.08.2026 steht das auch so in der
Kopfzeile (Gegenpruefung, Fund B4). Der Wortlaut der Klausel hat zwei Haelften:
"nicht erfuellte oder nicht pruefbare Vorbedingung sperrt; die Sperre wird
begruendet angezeigt." Gebaut ist die erste -- diese Datei sperrt bei jedem
Zweifel und lehnt sich nirgends zurueck. Die zweite ist NICHT gebaut: der
Nutzer bekommt MELDUNG_MISSERFOLG, und der Satz nennt keinen Grund.

Das ist kein Versehen, sondern ein Widerspruch zwischen zwei Klauseln, den
diese Datei nicht aufloesen darf. Der Grund IST hier die Auskunft, die K03-M25
verbietet: "abgelaufen" statt "unbekannt" macht aus der Antwort das Orakel von
oben. Beim fehlenden Versandweg (siehe `einloesen`) kaeme dazu, dass der Grund
Namen von Umgebungswerten traegt -- die gehoeren nach K23-D09 nicht auf einen
Nutzerbildschirm. Wie eine begruendete Anzeige aussaehe, die weder ein Orakel
noch eine Betriebsauskunft ist, entscheidet ein Mensch. Hier wird die Frage
benannt und nicht gefuellt.

Zum Vergleich: app/haupt.py fuehrt K03-G01 ganz. Dort gibt es den Fall, in dem
eine Sperre begruendet werden KANN, ohne etwas preiszugeben -- der Dienst
erreicht seine Datenbank nicht (MELDUNG_BETRIEB, 503). Ueber ein Konto sagt das
nichts.

DER ANMELDECODE STEHT SEIT DEM 14.08.2026 HIER. Bis dahin endete dieser Weg
mit der Umleitung auf EN-01, und den Code stellte allein
`python3 mail/versand.py code --an ...` von Hand am Terminal aus. Keiner der
neun Bildschirme hat je einen ausgestellt: die Kette Einladung -> Code ->
Anmeldung war nicht durchgehend bedienbar, und der Programmtext sagte dem
Nutzer selbst, der naechste Schritt sei der Code.

DER ZUSCHNITT KOMMT AUS DEM VERTRAG, nicht aus der Bequemlichkeit.
schema/K19_screens.yaml fuehrt fuer EN-01 genau EINE Aktion, `anmelden`, mit
der Eingabe "E-Mail-Adresse (aus der Einladung vorbelegt) und sechsstelliger
Code per E-Mail". Eine Aktion "Code anfordern" fuehrt er NICHT -- eine zu
bauen hiesse, Umfang zu erfinden (CLAUDE.md Abschn. 6). Der Ausloeser steht
in der Eingabe selbst: die Adresse ist aus der Einladung vorbelegt, der Code
kommt per Mail. Der Vorgang, aus dem beides kommt, ist die Einloesung. Also
stellt genau sie ihn aus -- kein neuer Bildschirm, keine neue Aktion, keine
neue Kennung (K03-M05, K03-M06, K20-G09).

OFFEN BLEIBT DER ABGELAUFENE CODE. Er gilt zehn Minuten (K03-M15). Wer sie
verstreichen laesst, wer die Mail nicht bekommt oder wer sich spaeter erneut
anmelden will, braucht einen neuen -- und der Vertrag fuehrt fuer EN-01 keine
Aktion, mit der er ihn bekaeme. Das ist keine Luecke dieses Pfades, sondern
eine Entscheidung fuer einen Menschen. Sie wird hier benannt und nicht
gefuellt. Dazu gehoert ein Satz, der schon heute in der Mail steht:
"Fordern Sie einen neuen an, verliert dieser sofort seine Gueltigkeit"
(mail/versand.py). Er sagt einen Weg zu, den die Anwendung nicht hat. Der
Wortlaut wird hier NICHT geaendert -- er gehoert zu derselben offenen
Entscheidung und faellt mit ihr.

WAS HIER NICHT STEHT: das Anlegen des Kontos. `invitation.actor_id` ist NOT
NULL -- das Konto besteht bereits, wenn die Einladung entsteht. Die
Einloesung legt keines an, sie schaltet eines frei.
"""
import logging

import psycopg

from app.datenbank import CODE_PFEFFER
from mail.versand import (
    CodeNichtAusgestellt,
    VersandFehler,
    anmeldecode,
    streuwert,
    versandweg_fehlt,
)

PROTOKOLL = logging.getLogger(__name__)

# WOERTLICH. Ein Punkt mehr oder weniger ist eine andere Meldung, und eine
# zweite Fassung derselben Meldung ist der Anfang der Fallunterscheidung.
MELDUNG_MISSERFOLG = (
    "Dieser Einladungslink gilt nicht mehr. Bitte fordern Sie einen neuen an.")

# Die Kennung, gegen die freigeschaltet wird, wenn der Streuwert nirgends
# trug. Sie kommt in `actor` nicht vor -- die Anweisung laeuft, trifft nichts
# und kostet dieselbe Zeit wie eine, die trifft. Ohne diesen Umweg verriete
# die Antwortzeit, ob es zu dem Token eine offene Einladung gibt: der Weg mit
# Treffer haette eine Anweisung mehr als der ohne. Dieselbe Bauart wie
# `_KEIN_KONTO` in app/anmeldung.py, aus demselben Grund.
_KEINE_EINLADUNG = "00000000-0000-0000-0000-000000000000"


class _Misserfolg(Exception):
    """Intern: die Einloesung ist gescheitert, die Transaktion faellt zurueck.

    Der Grund steht bewusst NICHT drin. Es gibt keinen Ort, an dem er
    gebraucht wuerde -- nach aussen gilt die eine Meldung, und der Rueckfall
    stellt sicher, was der Vertrag verlangt: bei Misserfolg keine Aenderung
    an irgendeiner Zeile.
    """


def streuwert_token(token):
    """Pruefwert des Einladungstokens -- dieselbe Rechnung wie beim Ausstellen.

    sha256(FREIRAUM_CODE_PFEFFER + token), Hex, Kleinbuchstaben. Importiert
    statt nachgebaut: es gibt genau eine Streuwertregel im Haus
    (mail/versand.py:113), und zwei Kopien derselben Rechnung driften
    auseinander. Das Ergebnis waere eine Einloesung, die fuer alle stumm
    scheitert -- der teuerste aller Fehler, weil er wie eine korrekte
    Ablehnung aussieht.
    """
    return streuwert(token, CODE_PFEFFER)


def token_traegt(wert):
    """Ob der vorgelegte Wert ueberhaupt ein Token sein kann -- OHNE Datenbank.

    Bewusst nur "nicht leer". Ein Formatmuster waere hier eine zweite,
    fremde Bedingung: die Ausstellung legt kein Format fest, und ein
    Negativfall, der an einer Formatpruefung scheitert statt an der
    geprueften Bedingung, ist ein bestandener Test, der nichts misst
    (gemessen am 02.08.2026, CLAUDE.md Abschn. 3).

    Der leere Wert wird trotzdem hier abgefangen und nicht der Datenbank
    vorgelegt: sha256(pfeffer + "") ist ein gueltiger Streuwert. Entstuende
    je eine Einladung ohne Token, koennte sie jeder einloesen, der das
    Formular leer absendet. Fail-closed (K03-G01).
    """
    return bool((wert or "").strip())


def _nachweis(conn, konto, was, gegenstand, davor, danach):
    """Eine Zeile in `event` -- K20-M18.

    Zeitpunkt (`occurred_at`, Vorgabe now()), handelnde Instanz
    (`actor_id`/`actor_label`) sowie Wert davor und danach. Die handelnde
    Instanz ist die eingeladene Person selbst: sie hat den Link geoeffnet und
    die Schaltflaeche gedrueckt.

    Der Token steht hier NICHT, auch nicht als Streuwert. `object_ref` zeigt
    auf die Kennung der Zeile; wer den Nachweis liest, findet den Vorgang und
    nicht den Zugang (K20-M08, K23-D09).
    """
    conn.execute(
        "INSERT INTO event (actor_id, actor_label, tenant_id, action,"
        " object_ref, change_type, value, source)"
        " VALUES (%s, %s, %s, %s, %s, 'Aenderung', %s, 'PORTAL_ACTION')",
        (konto[0], konto[1], konto[2], was, gegenstand,
         f"{davor} -> {danach}"))


def _vollzug(conn, token):
    """Einloesen, freischalten, nachweisen -- ein einziger Vorgang.

    Jeder Schritt endet bei Zweifel mit _Misserfolg; dann faellt alles
    zurueck. Keine eingeloeste Einladung ohne freigeschaltetes Konto, kein
    freigeschaltetes Konto ohne eingeloeste Einladung (K20-M15).

    Rueckgabe seit dem 14.08.2026: KENNUNG UND ADRESSE des freigeschalteten
    Kontos. Der Aufrufer braucht beides fuer den Anmeldecode und fuer nichts
    sonst. Sie kommen aus der Zeile, die soeben geschrieben wurde, und nicht
    aus der Einladung -- der Code geht an das Konto, nicht an das Feld
    `invitation.mail` von damals. Sie bleiben lokale Veraenderliche: nicht ins
    Protokoll, nicht in den Nachweis, nicht auf den Bildschirm (K03-M26,
    K23-D09).

    DIE KENNUNG WIRD SEIT DER GEGENPRUEFUNG DURCHGEREICHT (Fund B1). Sie lag
    schon immer in `freigeschaltet[0]`; bis zum 14.08.2026 wurde sie hier
    weggeworfen, und mail/versand.py loeste die Adresse ein ZWEITES Mal auf --
    schreibweisenegal gegen eine schreibweisengenaue Eindeutigkeit. Zwei nur in
    der Gross-/Kleinschreibung verschiedene Konten trafen beide, und die
    Abfrage nahm eine unbestimmte Zeile: der Ausloeser haette den Code eines
    FREMDEN Kontos entwertet und die Anrede haette einen fremden Namen
    getragen. Wer die Kennung hat, loest nicht noch einmal auf.
    """
    # K20-M14 und die Gleichzeitigkeit in EINER Anweisung: der Streuwert
    # trifft nur eine Zeile, die noch VERSANDT und noch nicht abgelaufen ist,
    # und setzt Zustand und Zeitpunkt zusammen. Zwei gleichzeitige Anfragen
    # mit demselben Token koennen nicht beide gewinnen -- die zweite wartet
    # auf die erste, prueft die Bedingung danach erneut und findet
    # EINGELOEST vor. Ein vorgeschaltetes SELECT haette genau dieses Fenster
    # gelassen; dieselbe Bauart wie der Verbrauch des Anmeldecodes
    # (app/anmeldung.py, K03-M15).
    #
    # K20-D10 steckt in dem, was NICHT in SET steht: expires_at und attempt
    # bleiben unberuehrt. Und die Bedingung deckt WIDERRUFEN und ABGELAUFEN
    # ohne eigenen Zweig ab -- was nicht VERSANDT ist, trifft nicht.
    #
    # `FROM invitation v WHERE v.id = i.id` holt das Bild VOR der Aenderung:
    # RETURNING allein liefert nur die neuen Werte, K20-M18 verlangt beide.
    # Der Wert davor kann hier nur 'VERSANDT' sein -- die Bedingung erzwingt
    # es. Er wird trotzdem gelesen und nicht angenommen: im Nachweis steht
    # ein gemessener Wert oder gar keiner.
    #
    # ZEITSEITENKANAL, gemessen am 10.08.2026 ueber je 150 Anfragen: Die
    # Bedingung auf den Kontozustand stand zuerst NUR in der zweiten Anweisung
    # weiter unten. Damit schrieb das gesperrte Konto die Einladungszeile
    # tatsaechlich -- und die Transaktion nahm sie erst beim Rueckfall wieder
    # mit. Der Median lag bei 12,40 ms gegen 11,26 bis 11,45 ms fuer
    # unbekannt, abgelaufen und bereits eingeloest: ein Schreibvorgang samt
    # Rueckfall kostet mehr als ein Treffer, der ausbleibt. Wer einen Token
    # in der Hand hat, konnte daran ablesen, dass er gilt und nur das Konto
    # gesperrt ist. Der Wortlaut war gleich; die Uhr sprach (K03-G01).
    #
    # Deshalb steht `k.status` HIER mit in der Bedingung: das gesperrte Konto
    # trifft nicht, und damit wird auch nichts geschrieben. Die zweite
    # Anweisung behaelt ihre eigene Bedingung trotzdem -- der Verbund auf
    # `actor` sperrt die Zeile nicht, ein gleichzeitiges Sperren zwischen den
    # beiden Anweisungen faenge sonst niemand ab.
    eingeloest = conn.execute(
        "UPDATE invitation i SET status = 'EINGELOEST', redeemed_at = now()"
        "  FROM invitation v, actor k"
        " WHERE v.id = i.id AND k.id = i.actor_id"
        "   AND i.token_hash = %s"
        "   AND i.status = 'VERSANDT'"
        "   AND i.expires_at > now()"
        "   AND k.status IN ('WARTET_2FA','AKTIV')"
        " RETURNING i.id, i.actor_id, v.status::text, i.status::text",
        (streuwert_token(token),)).fetchone()

    # NICHT hier abbrechen. Der Weg laeuft in jedem Fall durch dieselben
    # Anweisungen; erst danach faellt die Entscheidung (siehe _KEINE_EINLADUNG).
    trifft = eingeloest is not None
    actor_id = eingeloest[1] if trifft else _KEINE_EINLADUNG

    # K20-M15, in derselben Transaktion wie die Einloesung.
    #
    # ENTSCHEIDUNG 1 (10.08.2026): GESPERRT steht in KEINER der beiden
    # Bedingungen. Ein gesperrtes Konto wird durch eine Einloesung nicht
    # aktiviert. K20-M15 nennt ausdruecklich den Weg WARTET_2FA -> AKTIV;
    # eine Sperre ueber eine Einladung aufzuheben waere ein Weg an der Sperre
    # vorbei -- wer gesperrt ist, braeuchte nur noch eine Einladung, um
    # wieder hereinzukommen. Die Einloesung schlaegt dann fehl, mit derselben
    # einen Meldung, und die Einladung bleibt offen. Sie zu verbrauchen waere
    # doppelt falsch: der Vertrag verlangt bei Misserfolg KEINE Aenderung an
    # irgendeiner Zeile, und die Einladung soll noch tragen, wenn die Sperre
    # aufgehoben ist.
    #
    # AKTIV bleibt zulaessig: eine erneute Einladung an ein bereits
    # freigeschaltetes Konto ist kein Fehler, und der Zustand ist danach
    # derselbe. Dieselbe Bedingung fuehrt app/anmeldung.py beim Uebergang.
    #
    # last_login_at wird hier NICHT gesetzt. Eine Einloesung ist keine
    # Anmeldung; K03-G05 haelt das Feld leer, solange kein Code bestaetigt
    # wurde. Der naechste Schritt des Nutzers ist EN-01.
    #
    # `a.email` steht seit dem 14.08.2026 mit in RETURNING -- der Anmeldecode
    # geht an diese Adresse. Es ist KEINE zusaetzliche Anweisung, also auch
    # kein zusaetzlicher Zeitunterschied zwischen Treffer und Fehlschlag: die
    # Spalte faellt in derselben Anweisung mit an (siehe ZEITSEITENKANAL oben).
    freigeschaltet = conn.execute(
        "UPDATE actor a SET status = 'AKTIV'"
        "  FROM actor v"
        " WHERE v.id = a.id AND a.id = %s"
        "   AND a.status IN ('WARTET_2FA','AKTIV')"
        " RETURNING a.id, a.display_name, a.tenant_id,"
        "           v.status::text, a.status::text, a.email",
        (actor_id,)).fetchone()

    if not trifft or freigeschaltet is None:
        # Deckt in EINEM Zweig ab: unbekannter Streuwert, abgelaufen, bereits
        # eingeloest, widerrufen, gesperrtes Konto, geloeschtes Konto. Nach
        # aussen sind das nicht unterscheidbare Faelle; jetzt sind sie es auch
        # auf der Uhr.
        raise _Misserfolg

    _nachweis(conn, freigeschaltet, "EINLADUNG_EINGELOEST",
              "INVITATION:" + str(eingeloest[0]), eingeloest[2], eingeloest[3])
    _nachweis(conn, freigeschaltet, "KONTO_FREIGESCHALTET",
              "ACTOR:" + str(freigeschaltet[0]),
              freigeschaltet[3], freigeschaltet[4])

    return freigeschaltet[0], freigeschaltet[5]


def _anmeldecode_senden(conn, actor_id, adresse):
    """Der Anmeldecode, unmittelbar nach der Einloesung -- und AUSSERHALB ihrer
    Transaktion.

    Die Reihenfolge ist nicht Geschmack, sie ist zwingend:

      1. Erst wird die Einloesung festgeschrieben. Liefe der Versand in
         derselben Transaktion, naehme ein Fehlschlag die Freischaltung mit
         zurueck -- der Nutzer stuende dann vor einem Link, der nach K20-D10
         nicht mehr traegt, UND vor einem Konto, das nicht freigeschaltet ist.
         Der Link hat aber getragen; ihn nachtraeglich fuer ungueltig zu
         erklaeren, waere unwahr.
      2. Dann der Code. Dieselbe Richtung wie in app/einladung_senden.py:
         zuerst der Bestand, dann die Mail.

    Die Grenze haelt sich obendrein nicht nur an die Absicht: `anmeldecode()`
    schliesst mit `conn.commit()` ab, und psycopg weist ein ausdrueckliches
    commit() INNERHALB eines `conn.transaction()`-Blocks mit einem
    ProgrammingError ab (_connection_base.py:568). Ausserhalb -- und die
    Verbindung aus app/datenbank.py laeuft mit autocommit -- ist es ein
    Nichtstun. Wer diesen Aufruf spaeter in die Transaktion zoege, bekaeme
    also keinen stillen Fehler, sondern einen lauten.

    KEIN RUECKGABEWERT, und das ist der Punkt. Ein Fehlschlag beim Versand
    aendert nichts am Ergebnis der Einloesung: sie ist geschehen, das Konto
    ist frei, der Nutzer wird auf EN-01 gefuehrt. Ihm dort
    MELDUNG_MISSERFOLG zu zeigen, waere zweimal falsch -- der Satz stimmte
    nicht, und er schickte ihn einen Weg zurueck, den es fuer ihn nicht mehr
    gibt (K20-D10: eine eingeloeste Einladung wirkt nicht erneut).

    WAS DER NUTZER DANN SIEHT, ist EN-01 ohne Code, und der Vertrag fuehrt
    keine Aktion, mit der er einen neuen anfordern koennte. Diese Stelle ist
    im Kopf dieser Datei als offener Punkt benannt und wird nicht erfunden.

    DER FEHLSCHLAG STEHT IM NACHWEIS: `mail_delivery` traegt die Zeile mit
    Status FEHLER, geschrieben von mail/versand.py auf beiden Wegen. Ohne
    Zustellnachweis ist ein gescheiterter Versand nicht von einem nicht
    erfolgten zu unterscheiden (Bauauftrag B2). Hier bleibt zusaetzlich eine
    Zeile im Betriebsprotokoll -- und in ihr steht weder die Adresse noch der
    Wortlaut des Providerfehlers: K03-M26 haelt vollstaendige Adressen aus
    Logs heraus, und die Meldung eines Mailservers fuehrt die Adresse
    regelmaessig mit ("Vom Server abgelehnt: {...}").

    DIE PRUEFUNG DES VERSANDWEGS STAND BIS ZUM 14.08.2026 HIER und steht jetzt
    in `einloesen()`, VOR der Transaktion (Gegenpruefung, Fund B3). Sie ist rein
    und datenbankfrei; ihr Ergebnis steht fest, bevor die Anfrage beginnt. An
    dieser Stelle kam sie zu spaet: die Einladung war verbraucht und das Konto
    aktiviert, und erst danach fiel auf, dass gar kein Mailweg besteht -- ohne
    Zeile in mail_delivery, denn versucht wurde nichts. Eine Kopie bleibt hier
    NICHT zurueck: zwei Ausfertigungen derselben Bedingung driften auseinander,
    und die zweite waere ohnehin tot -- die Werte stehen beim Import fest.
    """
    try:
        anmeldecode(conn, actor_id, adresse)
    except VersandFehler:
        PROTOKOLL.error("Anmeldecode nach der Einloesung nicht zugestellt. Der "
                        "Fehlschlag steht mit Status FEHLER in mail_delivery.")
    except CodeNichtAusgestellt:
        # Wegen des Kontos kann dieser Pfad den Fall nicht ausloesen: die
        # Einloesung hat soeben eine Zeile in `actor` freigeschaltet, und ihre
        # Kennung wird durchgereicht statt neu aufgeloest. Er wird trotzdem
        # gefangen -- und seit dem 14.08.2026 traegt er auch: mail/versand.py
        # meldet mit derselben Klasse, wenn FREIRAUM_CODE_PFEFFER fehlt
        # (Fund B2, vorher SystemExit -- das kam an diesem Zweig vorbei und
        # haette den Arbeiter mitgenommen).
        #
        # DER WORTLAUT DER AUSNAHME BLEIBT DRAUSSEN. Er nennt einen
        # Umgebungswert; das ist eine Betriebsangabe und gehoert nicht ins
        # Anwendungsprotokoll dieser Ebene (K23-D09). Der Betreiber sieht den
        # fehlenden Pflichtwert ohnehin beim Start -- app/datenbank.py erhebt
        # ihn beim Import.
        PROTOKOLL.error("Nach der Einloesung wurde kein Anmeldecode "
                        "ausgestellt.")


def einloesen(conn, token):
    """Der ganze Weg. Rueckgabe: True bei Erfolg, sonst False.

    False traegt keinen Grund. Der Aufrufer hat auch keinen zu unterscheiden:
    es gibt genau eine Meldung.

    True heisst: die Einloesung hat getragen. Es heisst NICHT, dass der
    Anmeldecode zugestellt wurde -- der geht danach hinaus, und sein Scheitern
    aendert am Ergebnis nichts (siehe `_anmeldecode_senden`).

    SEIT DEM 14.08.2026 GIBT ES EINEN DRITTEN GRUND FUER False: es besteht gar
    kein Versandweg (Gegenpruefung, Fund B3). Dann wird nicht eingeloest --
    siehe die Begruendung unten. Was False in diesem Fall dem Nutzer anzeigt,
    ist eine OFFENE ENTSCHEIDUNG und unten benannt.
    """
    if not token_traegt(token):
        return False

    # VOR jedem Schreibvorgang, und zwar vollstaendig ausserhalb der
    # Transaktion (Gegenpruefung, Fund B3, 14.08.2026). Die Pruefung ist rein
    # und beruehrt die Datenbank nicht; ihr Ergebnis steht fest, bevor die
    # Anfrage beginnt. Bis dahin stand sie in `_anmeldecode_senden()`, also
    # NACH dem Festschreiben: die Einladung war verbraucht und das Konto
    # aktiviert, und erst danach fiel auf, dass keine Mail hinausgehen kann.
    # Der Nutzer stand dann vor einem Konto ohne Code und vor einem Link, der
    # nach K20-D10 nicht mehr traegt -- und mail_delivery trug keine Zeile,
    # weil nichts versucht wurde. Dieselbe Reihenfolge und dieselbe
    # Begruendung wie in app/einladung_senden.py:699-705.
    #
    # Der Link wird dabei NICHT verbraucht. Er traegt weiter, und sobald der
    # Betreiber den Versandweg in Ordnung gebracht hat, traegt derselbe Link
    # denselben Weg (K20-D10 bleibt unberuehrt: hier wird nichts verlaengert,
    # es wird nur nichts angefasst).
    #
    # Die Gruende nennen Namen von Umgebungswerten und die Absenderdomaene;
    # sie gehoeren ins Protokoll des Betreibers und nicht auf den Bildschirm
    # (K23-D09).
    #
    # OFFENE ENTSCHEIDUNG, benannt und nicht getroffen: WAS der Nutzer sieht.
    # Zurueckgegeben wird False -- der Rueckgabewert ist damit wahr, denn
    # eingeloest wurde nichts; True waere die Behauptung eines Vorgangs, den es
    # nicht gegeben hat. Falsch ist der SATZ, den app/haupt.py an False
    # knuepft: MELDUNG_MISSERFOLG sagt "Dieser Einladungslink gilt nicht mehr.
    # Bitte fordern Sie einen neuen an." Der Link gilt aber noch, und ein neuer
    # wuerde denselben stummen Versandweg vorfinden. Von den beiden verfuegbaren
    # Zustaenden behauptet False das Wenigste; ein dritter -- eine eigene
    # Meldung fuer "der Dienst kann zurzeit keine Mail versenden", nach dem
    # Vorbild von MELDUNG_BETRIEB in app/haupt.py -- ist genau die zweite
    # Haelfte von K03-G01, die diese Datei nicht gebaut hat (siehe Kopf). Ob
    # sie gebaut wird, entscheidet ein Mensch.
    fehlt = versandweg_fehlt()
    if fehlt:
        PROTOKOLL.error("Kein Versandweg fuer den Anmeldecode, es wird nicht "
                        "eingeloest: %s", " · ".join(fehlt))
        return False

    try:
        with conn.transaction():
            actor_id, adresse = _vollzug(conn, token.strip())
    except _Misserfolg:
        return False
    except psycopg.errors.CheckViolation:
        # Die Waechter der Datenbank: `invitation_guard_trg` prueft bei JEDER
        # Aenderung an der Zeile die Einladungsdomaene und die Fristobergrenze
        # des Mandanten erneut -- eine seit dem Versand gesenkte
        # `invite_ttl_hours` laesst also die eigene Einloesung scheitern.
        # `platform_admin_guard` haengt am Konto. Ihre Meldungen nennen
        # Domaene und Betriebszustand und bleiben drinnen (K23-D09); nach
        # aussen gilt MELDUNG_MISSERFOLG. Nicht pruefbar heisst gesperrt,
        # nicht durchgewinkt (K03-G01).
        return False

    # Erst hier, nach dem Festschreiben: der Anmeldecode. Der Vertrag verlangt
    # ihn fuer EN-01, und dies ist der Vorgang, den er dafuer benennt
    # (K03-M05, K19_screens.yaml EN-01/anmelden).
    _anmeldecode_senden(conn, actor_id, adresse)
    return True
