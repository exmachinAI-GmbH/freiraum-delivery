"""FREIRAUM · Scheibe 1 · die Routen.

    .venv/bin/uvicorn app.haupt:app --port 8099

Serverseitig gerendert, ohne getrenntes Frontend. K03-M13: jede Pruefung der
Anmeldung erfolgt serverseitig, eine Pruefung allein in der Oberflaeche gilt
als nicht erfolgt. Wo es keine Entscheidung im Browser gibt, kann auch keine
dorthin rutschen.

Der Vertrag der Scheibe:

    GET  /anmeldung   200, Formular mit email und code
    POST /anmeldung   Erfolg -> 303 auf "/", Cookie fr_sitzung
                      sonst  -> 200 mit der einen Meldung, KEIN Cookie
    GET  /            ohne gueltige Sitzung -> 303 auf "/anmeldung"
    POST /abmelden    303 auf "/anmeldung", Sitzung beendet
    GET  /gesundheit  200 {"status":"ok"}, ohne Sitzung erreichbar

Der Import von app.datenbank steht bewusst am Anfang: fehlt einer der drei
Pflichtwerte der Umgebung, bricht er hier ab -- beim START, nicht beim ersten
Anmeldeversuch (Befund BEF-L2-1 vom 10.08.2026).
"""
from pathlib import Path

import psycopg
from fastapi import FastAPI, Form, Request
from fastapi.responses import HTMLResponse, JSONResponse, RedirectResponse
from fastapi.templating import Jinja2Templates

from app.anmeldung import MELDUNG_MISSERFOLG, anmelden
from app.datenbank import verbindung
from app.sitzung import (
    KEKS_NAME,
    keks_loeschen,
    keks_setzen,
    merkmal_lesen,
    sitzung_beenden,
    sitzung_pruefen,
)

# Gegen __file__, nicht gegen das Arbeitsverzeichnis: der Server soll aus
# jedem Verzeichnis startbar sein, ohne seine Vorlagen zu verlieren.
VORLAGEN = Jinja2Templates(directory=str(Path(__file__).parent / "vorlagen"))

app = FastAPI(title="FREIRAUM · Anmeldung", docs_url=None, redoc_url=None)


@app.exception_handler(psycopg.OperationalError)
def datenbank_weg(request: Request, fehler: psycopg.OperationalError):
    """Eine Stelle statt einer je Route -- sonst wird die naechste vergessen.

    Der Fehler selbst wird NICHT angezeigt: psycopg nennt darin Rechnernamen
    und Anschluss der Datenbank, und K23-D09 verbietet Betriebsangaben in der
    Fehlerausgabe. Er gehoert ins Protokoll des Betreibers, nicht auf den
    Bildschirm des Nutzers.
    """
    return _en01(request, meldung=MELDUNG_BETRIEB, status=503)

# 303 und nicht 302: nach einem POST muss der Browser auf GET wechseln.
# 302 laesst ihm die Wahl, und ein wiederholtes POST auf "/" waere ein
# zweiter Anmeldeversuch mit einem bereits verbrauchten Code.
UMLEITUNG = 303

# BEFUND 3 (Gegenlesung 10.08.2026): Bei toter Datenbank lief jede Route in
# einen nackten "500 Internal Server Error" mit 21 Byte Rumpf. Der Kern von
# K03-G01 war gewahrt -- es entstand keine Sitzung, und das Kennwort aus dem
# DSN stand weder im Rumpf noch im Log. Aber die Klausel verlangt mehr:
# "nicht erfuellte oder nicht pruefbare Vorbedingung sperrt; die Sperre wird
# BEGRUENDET ANGEZEIGT."
#
# Bewusst eine EIGENE Meldung und 503, nicht die Meldung aus K03-M16: Ein
# Betriebsausfall sagt nichts ueber ein Konto aus, verraet also nichts -- und
# "Pruefen Sie Adresse und Code" waere hier schlicht gelogen. Wer seinen Code
# dreimal neu eintippt, weil die Anwendung ihm die Schuld gibt, verbrennt
# seine fuenf Versuche an einem Fehler, der nicht seiner ist.
MELDUNG_BETRIEB = ("Die Anmeldung ist zurzeit nicht moeglich, weil der Dienst "
                   "seine Datenbank nicht erreicht. Das liegt nicht an Ihren "
                   "Angaben. Bitte versuchen Sie es spaeter erneut.")


def _en01(request, meldung=None, adresse=None, status=200):
    antwort = VORLAGEN.TemplateResponse(
        request, "en01_anmeldung.html",
        {"meldung": meldung, "adresse": adresse}, status_code=status)
    # Die Maske traegt die Eingabe zurueck; im Cache eines Zwischenspeichers
    # hat sie nichts verloren (K03-M26, datensparsam).
    antwort.headers["Cache-Control"] = "no-store"
    return antwort


@app.get("/anmeldung", response_class=HTMLResponse)
def anmeldemaske(request: Request):
    return _en01(request)


@app.post("/anmeldung")
def anmeldung_absenden(request: Request,
                       email: str = Form(default=""),
                       code: str = Form(default="")):
    # request.client.host ist die Herkunft, wie der Prozess sie sieht. Hinter
    # einem Lastverteiler ist das dessen Adresse -- die Auswertung der
    # weitergereichten Adresse gehoert zur Zielumgebung und ist als offener
    # Punkt vermerkt, nicht hier stillschweigend geraten.
    herkunft = request.client.host if request.client else ""

    with verbindung() as conn:
        sitzung_id = anmelden(conn, email, code, herkunft)

    if sitzung_id is None:
        # 200 mit Meldung, ausdruecklich KEIN Cookie: eine Sitzung entsteht
        # nur aus einer bestaetigten zweiten Stufe (K03-M09, K03-D01).
        return _en01(request, meldung=MELDUNG_MISSERFOLG, adresse=email)

    antwort = RedirectResponse("/", status_code=UMLEITUNG)
    keks_setzen(antwort, sitzung_id)
    antwort.headers["Cache-Control"] = "no-store"
    return antwort


@app.get("/", response_class=HTMLResponse)
def startseite(request: Request):
    merkmal = request.cookies.get(KEKS_NAME)
    with verbindung() as conn:
        stand = sitzung_pruefen(conn, merkmal_lesen(merkmal))

    if stand is None:
        # K03-D01: kein Teil-Zugang. Kein halber Bildschirm, keine Kachel,
        # kein "Sie sind abgemeldet"-Rest -- zurueck auf EN-01.
        antwort = RedirectResponse("/anmeldung", status_code=UMLEITUNG)
        if merkmal:
            # Das Merkmal zeigt auf nichts Gueltiges mehr. Es stehen zu
            # lassen hiesse, bei jedem Aufruf dieselbe tote Kennung zu
            # pruefen -- und dem Browser zu suggerieren, er sei angemeldet.
            keks_loeschen(antwort)
        return antwort

    antwort = VORLAGEN.TemplateResponse(
        request, "start.html",
        {"anzeigename": stand["anzeigename"], "portal": stand["portal"]})
    antwort.headers["Cache-Control"] = "no-store"
    return antwort


@app.post("/abmelden")
def abmelden(request: Request):
    merkmal = request.cookies.get(KEKS_NAME)
    with verbindung() as conn:
        kennung = merkmal_lesen(merkmal)
        if kennung:
            # Serverseitig beenden, nicht nur das Cookie loeschen. Ein
            # geloeschtes Cookie ist kein Sitzungsende -- wer eine Kopie
            # behalten hat, waere weiter angemeldet (K03-M13).
            sitzung_beenden(conn, kennung)

    antwort = RedirectResponse("/anmeldung", status_code=UMLEITUNG)
    keks_loeschen(antwort)
    antwort.headers["Cache-Control"] = "no-store"
    return antwort


@app.get("/gesundheit")
def gesundheit():
    """Lebenszeichen des Prozesses, ohne Sitzung erreichbar.

    Bewusst OHNE Datenbankzugriff. Der Vertrag der Scheibe verlangt hier
    200 und {"status":"ok"}; eine Bereitschaftsprobe, die die Datenbank
    mitprueft, ist eine zweite Frage ("kann ich bedienen?") und als offener
    Punkt vermerkt. Beides in einer Route zu beantworten, hiesse: der
    Betrieb kann nicht mehr unterscheiden, ob der Prozess weg ist oder die
    Datenbank.
    """
    return JSONResponse({"status": "ok"})
