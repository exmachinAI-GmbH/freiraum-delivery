"""FREIRAUM · Scheibe 1 · Sitzungsregeln nach K03-M17.

Zwei Grenzen, beide serverseitig:

  * 30 Minuten Untaetigkeit, gemessen an `auth_session.last_activity_at`
  * spaetestens acht Stunden, gemessen an `auth_session.started_at`

Beide werden gegen `now()` der DATENBANK gerechnet, nicht gegen die Uhr des
Prozesses. Zwei Uhren sind zwei Wahrheiten; die Spalten stehen in der
Datenbank, also entscheidet ihre Uhr.

Nicht ueber die Lebensdauer des Cookies. Die bestimmt der Browser, und
K03-M13 haelt fest: eine Pruefung allein in der Oberflaeche gilt als nicht
erfolgt. Das Cookie traegt deshalb keinen Ablauf, sondern nur ein signiertes
Merkmal -- ob es noch gilt, sagt die Tabelle.
"""
from itsdangerous import BadSignature, URLSafeSerializer

from app.datenbank import SITZUNG_SCHLUESSEL, TLS

KEKS_NAME = "fr_sitzung"

# K03-M17, beziffert seit dem Expertenreview (K03-G09). Keine v2.9-Quelle
# nennt diese Werte; sie stammen aus der Festlegung nach dem Review.
UNTAETIG_MINUTEN = 30
ABSOLUT_STUNDEN = 8

# Das Merkmal traegt AUSSCHLIESSLICH die Kennung der Sitzungszeile -- keine
# Adresse, keinen Namen, keinen Kontozustand, kein Portal. Wer das Cookie
# abfaengt, haelt einen Zeiger in eine Tabelle, die er nicht lesen kann; alles
# Weitere holt der Server bei jedem Aufruf frisch (K03-M13).
_siegel = URLSafeSerializer(SITZUNG_SCHLUESSEL, salt="fr_sitzung_v1")


def merkmal_ausstellen(sitzung_id):
    return _siegel.dumps(str(sitzung_id))


def merkmal_lesen(wert):
    """Kennung aus dem Cookie -- oder None, wenn die Signatur nicht traegt.

    Eine gebrochene Signatur ist kein Grund fuer eine Fehlermeldung, sondern
    fuer denselben Weg wie "kein Cookie": zurueck auf EN-01 (K03-G01).
    """
    if not wert:
        return None
    try:
        return _siegel.loads(wert)
    except BadSignature:
        return None


def keks_setzen(antwort, sitzung_id):
    antwort.set_cookie(
        KEKS_NAME,
        merkmal_ausstellen(sitzung_id),
        httponly=True,          # kein Zugriff aus Skripten im Browser
        samesite="lax",
        secure=TLS,             # FREIRAUM_TLS=1
        path="/",
        # Bewusst OHNE max_age/expires: ein Sitzungskeks. Die Frist steht in
        # auth_session, nicht im Browser (K03-M13, K03-M17).
    )


def keks_loeschen(antwort):
    antwort.delete_cookie(KEKS_NAME, path="/", httponly=True,
                          samesite="lax", secure=TLS)


def portal_bestimmen(conn, actor_id):
    """K03-M11: genau ein Portal, bestimmt ueber `membership`.

    Genau eines -- nicht das erste von mehreren. K03-D02 verbietet zwei, und
    ein Anmeldevorgang, der sich zwischen zweien entscheiden muesste, hat
    keine Regel dafuer. Also fail-closed (K03-G01).

    Gegen `portal_enabled` statt gegen `portal`: die drei Portale mit
    release_status = PLANNED bekommen nach F04 und K03-G10 keinen Anmeldeweg.
    """
    zeilen = conn.execute(
        "SELECT DISTINCT m.portal_code FROM membership m"
        " JOIN portal_enabled p ON p.code = m.portal_code"
        " WHERE m.actor_id = %s",
        (actor_id,)).fetchall()
    if len(zeilen) != 1:
        return None
    return zeilen[0][0]


def sitzung_beenden(conn, sitzung_id):
    conn.execute(
        "UPDATE auth_session SET ended_at = now()"
        " WHERE id = %s AND ended_at IS NULL", (sitzung_id,))


def sitzung_pruefen(conn, sitzung_id):
    """Die Sitzung bei JEDEM Aufruf gegen die Datenbank halten.

    Reihenfolge ist Absicht: erst die beiden Fristen (K03-M17), dann der
    Kontozustand (K03-D01), dann das Portal (K03-M11). Faellt eine Bedingung
    aus, gibt es keinen Teil-Zugang -- die Antwort ist None, und der Aufrufer
    schickt zurueck auf EN-01.

    Rueckgabe: Angaben zur Anzeige, oder None.
    """
    if not sitzung_id:
        return None
    zeile = conn.execute(
        "SELECT s.id, s.actor_id, a.display_name, a.status, a.tenant_id,"
        "       s.ended_at IS NOT NULL AS beendet,"
        "       now() - s.last_activity_at > make_interval(mins => %s) AS untaetig,"
        "       now() - s.started_at      > make_interval(hours => %s) AS ueberalt"
        "  FROM auth_session s JOIN actor a ON a.id = s.actor_id"
        " WHERE s.id = %s",
        (UNTAETIG_MINUTEN, ABSOLUT_STUNDEN, sitzung_id)).fetchone()
    if zeile is None:
        return None
    (kennung, actor_id, name, status, mandant,
     beendet, untaetig, ueberalt) = zeile

    if beendet or untaetig or ueberalt:
        # Abgelaufen heisst beendet, nicht "gilt halt nicht mehr". Ohne
        # ended_at bliebe die Zeile fuer immer offen und der naechste Aufruf
        # rechnete dieselbe Frist erneut nach.
        if not beendet:
            sitzung_beenden(conn, kennung)
        return None

    # K03-D01: kein Vorgang ohne gueltige Sitzung UND status = AKTIV. Eine
    # Sperre wirkt damit sofort und nicht erst bei der naechsten Anmeldung --
    # der Zustand wird bei jedem Aufruf neu gelesen, nicht aus dem Cookie.
    # BEFUND S-1 (Gegenlesung 10.08.2026): Hier stand nur "return None". Die
    # Sperre wirkte damit sofort -- aber nicht dauerhaft. Gemessen: Konto auf
    # GESPERRT setzen, Aufruf wird abgewiesen; Konto wieder auf AKTIV setzen,
    # und DERSELBE Keks von vorher gilt wieder. Die Zeile in auth_session war
    # nie beendet worden, nur uebergangen.
    #
    # Das ist der Unterschied zwischen Aussperren und Aussetzen. Wer gesperrt
    # war, meldet sich neu an -- er setzt nicht dort fort, wo er aufgehoert
    # hat. Der Zweig darueber (Fristablauf) machte es laengst richtig; dass
    # dieser es nicht tat, war keine Entscheidung, sondern ein Versehen.
    if status != "AKTIV":
        sitzung_beenden(conn, kennung)
        return None

    portal = portal_bestimmen(conn, actor_id)
    if portal is None:
        # Ebenso: kein Portal mehr (Mitgliedschaft entzogen, Portal auf
        # PLANNED gesetzt) beendet die Sitzung, statt sie offen zu lassen.
        sitzung_beenden(conn, kennung)
        return None

    # Die Parkuhr nachstellen. Erst NACH allen Pruefungen: sonst haelt der
    # Aufruf, der die Sitzung wegen Untaetigkeit beendet, sie selbst am Leben.
    conn.execute(
        "UPDATE auth_session SET last_activity_at = now()"
        " WHERE id = %s AND ended_at IS NULL", (kennung,))

    # `mandant` seit dem 11.08.2026: der Versand der Einladung schreibt den
    # Mandanten in den Nachweis (K20-M18) und legt das eingeladene Konto in
    # ihm an. Er kommt aus derselben gepruften Zeile wie Name und Portal --
    # ein zweiter Zugriff waere eine zweite Wahrheit, die zwischen beiden
    # Abfragen auseinanderlaufen kann.
    return {"sitzung_id": kennung, "actor_id": actor_id,
            "anzeigename": name, "mandant": mandant, "portal": portal}
