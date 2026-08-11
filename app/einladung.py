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

WAS HIER NICHT STEHT: das Anlegen des Kontos. `invitation.actor_id` ist NOT
NULL -- das Konto besteht bereits, wenn die Einladung entsteht. Die
Einloesung legt keines an, sie schaltet eines frei.
"""
import psycopg

from app.datenbank import CODE_PFEFFER
from mail.versand import streuwert

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
    freigeschaltet = conn.execute(
        "UPDATE actor a SET status = 'AKTIV'"
        "  FROM actor v"
        " WHERE v.id = a.id AND a.id = %s"
        "   AND a.status IN ('WARTET_2FA','AKTIV')"
        " RETURNING a.id, a.display_name, a.tenant_id,"
        "           v.status::text, a.status::text",
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


def einloesen(conn, token):
    """Der ganze Weg. Rueckgabe: True bei Erfolg, sonst False.

    False traegt keinen Grund. Der Aufrufer hat auch keinen zu unterscheiden:
    es gibt genau eine Meldung.
    """
    if not token_traegt(token):
        return False

    try:
        with conn.transaction():
            _vollzug(conn, token.strip())
            return True
    except _Misserfolg:
        pass
    except psycopg.errors.CheckViolation:
        # Die Waechter der Datenbank: `invitation_guard_trg` prueft bei JEDER
        # Aenderung an der Zeile die Einladungsdomaene und die Fristobergrenze
        # des Mandanten erneut -- eine seit dem Versand gesenkte
        # `invite_ttl_hours` laesst also die eigene Einloesung scheitern.
        # `platform_admin_guard` haengt am Konto. Ihre Meldungen nennen
        # Domaene und Betriebszustand und bleiben drinnen (K23-D09); nach
        # aussen gilt MELDUNG_MISSERFOLG. Nicht pruefbar heisst gesperrt,
        # nicht durchgewinkt (K03-G01).
        pass

    return False
