"""FREIRAUM · Scheibe 1 · Verbindung und Umgebung.

Drei Werte kommen aus der Umgebung, und keiner von ihnen hat einen
Vorgabewert. Befund BEF-L2-1 vom 10.08.2026: ein stiller Vorgabewert ist ein
fest verdrahtetes Geheimnis, das niemand mehr als Geheimnis liest. Fehlt ein
Wert, bricht der START ab -- nicht der erste Anmeldeversuch. Ein Server, der
mit halber Umgebung hochlaeuft, verschiebt den Fehler auf den ersten Nutzer.

Spaeter kommen Pfeffer und Sitzungsschluessel aus dem Schluesseltresor ueber
die verwaltete Identitaet (K13-M17: keine langlebigen Geheimnisse im Code).
Die Umgebung ist die Zwischenstufe, nicht das Ziel.
"""
import os
from contextlib import contextmanager

import psycopg


class UmgebungUnvollstaendig(RuntimeError):
    """Der Start ist abgebrochen, weil ein Pflichtwert der Umgebung fehlt.

    Eigene Klasse, damit ein Aufrufer sie ENG fangen kann. Sie wird beim
    Import ausgeloest: uvicorn beendet sich dann mit der benannten Meldung,
    statt eine Anwendung ohne Geheimnisse zu bedienen (K03-G01, fail-closed).
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


@contextmanager
def verbindung():
    """Eine Verbindung je Aufruf, autocommit AN.

    Autocommit heisst hier nicht "ohne Transaktion", sondern: die Grenzen der
    Transaktion setzt der Serverpfad selbst mit `conn.transaction()` -- und
    zwar dort, wo eine Klausel sie verlangt (K03-M09: Zustandswechsel und
    Verbrauch des Codes in EINEM Vorgang). Eine implizite Transaktion um den
    ganzen Aufruf wuerde den gebuchten Fehlversuch mit zurueckrollen, und die
    Drosselung aus K03-M16 zaehlte nie.
    """
    with psycopg.connect(DSN, autocommit=True) as conn:
        yield conn
