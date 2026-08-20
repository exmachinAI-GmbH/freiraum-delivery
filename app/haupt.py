# umsetzt: K03-D01, K03-G01, K03-M05, K03-M13, K13-M05, K20-M08, K20-M25,
#          K23-D09
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
    GET  /einladung   200, Bestaetigungsseite mit verdecktem Feld token.
                      AENDERT NICHTS. Ohne tragenden Parameter: 200 mit der
                      einen Meldung der Einloesung
    POST /einladung   Erfolg -> 303 auf "/anmeldung"; im selben Vorgang geht
                      der Anmeldecode hinaus (seit 14.08.2026, K03-M05)
                      sonst  -> 200 mit der einen Meldung, KEINE Aenderung
    GET  /einladung/senden   ohne gueltige Sitzung -> 303 auf "/anmeldung";
                      mit gueltiger Sitzung ohne EXMA-Mitgliedschaft -> 303
                      auf "/" (K13-M05, K19 EX-10)
                      sonst 200, Formular mit email und anzeigename
    POST /einladung/senden   Erfolg -> 303 auf
                      "/einladung/senden?gesendet=1"
                      ohne EXMA-Mitgliedschaft -> 303 auf "/"
                      sonst  -> 200 mit BENANNTER Meldung, Eingaben bleiben
    GET  /            ohne gueltige Sitzung -> 303 auf "/anmeldung"
    POST /abmelden    303 auf "/anmeldung", Sitzung beendet
    GET  /gesundheit  200 {"status":"ok"}, ohne Sitzung erreichbar

Seit dem 15.08.2026 kommen die Wege der Vorpruefung hinzu -- /uebersicht,
/vorpruefung und /eignung. Sie stehen mit ihrem eigenen Vertrag im Kopf von
app/vorpruefung.py und sind hier nur eingebunden.

Seit dem 16.08.2026 kommen die Wege der Zweckbestimmung hinzu --
/zweckbestimmung und die fuenf Wege darunter. Sie stehen mit ihrem eigenen
Vertrag im Kopf von app/zweckbestimmung.py und sind hier ebenfalls nur
eingebunden.

Der Import von app.datenbank steht bewusst am Anfang: fehlt einer der drei
Pflichtwerte der Umgebung, bricht er hier ab -- beim START, nicht beim ersten
Anmeldeversuch (Befund BEF-L2-1 vom 10.08.2026).
"""
import logging
from pathlib import Path

import psycopg
from fastapi import FastAPI, Form, Request
from fastapi.responses import HTMLResponse, JSONResponse, RedirectResponse
from fastapi.staticfiles import StaticFiles
from fastapi.templating import Jinja2Templates

from app import ki_hinweis
from app.anmeldung import MELDUNG_MISSERFOLG, anmelden
from app.datenbank import verbindung
from app.einladung import MELDUNG_MISSERFOLG as MELDUNG_EINLADUNG
from app.einladung import einloesen, token_traegt
from app.einladung_senden import MELDUNG_GESENDET, einladung_senden
from app.gespraech import router as gespraech_router
from app.sitzung import (
    KEKS_NAME,
    keks_loeschen,
    keks_setzen,
    merkmal_lesen,
    sitzung_beenden,
    sitzung_pruefen,
)
from app.vorpruefung import router as vorpruefung_router
from app.zweckbestimmung import router as zweckbestimmung_router

# Gegen __file__, nicht gegen das Arbeitsverzeichnis: der Server soll aus
# jedem Verzeichnis startbar sein, ohne seine Vorlagen zu verlieren.
VORLAGEN = Jinja2Templates(directory=str(Path(__file__).parent / "vorlagen"))

app = FastAPI(title="FREIRAUM · Anmeldung", docs_url=None, redoc_url=None)

# ---------------------------------------------------------------------------
#  Die Gestaltung -- EINE Quelle, ausgeliefert, nicht nachgeladen
#
#  Bis zum 18.08.2026 gab es hier gar nichts: acht Vorlagen mit je eigenem
#  <style>-Block, kein <link>, kein statischer Weg. Es gab schlicht keinen
#  Ort, an dem eine CSS-Datei oder eine Schrift haette ankommen koennen --
#  und deshalb stand im ganzen Repo kein einziger Wert des gezeichneten
#  Token-Schemas (Blatt 94, BEF-UI-1).
#
#  MITGELIEFERT, NICHT NACHGELADEN: Die drei Schriften liegen unter
#  app/statisch/schriften/. Ein Bildschirm, der eine Schrift von einem
#  fremden Wirt holt, laesst dort eine Anfrage mit IP-Adresse zurueck --
#  eine Verarbeitung ausserhalb der EU (F05). Die Lizenzen liegen daneben.
# ---------------------------------------------------------------------------
app.mount("/statisch",
          StaticFiles(directory=str(Path(__file__).parent / "statisch")),
          name="statisch")

# Scheibe 2: die Vorpruefung (EN-02, EN-03, EN-04). Bewusst als eigene Datei
# und hier nur eingebunden -- diese Datei traegt die Anmeldung und den Zugang,
# app/vorpruefung.py traegt den Weg dahinter. Die Fehlerbehandlung fuer eine
# nicht erreichbare Datenbank gilt fuer beide: sie haengt am `app`-Objekt,
# nicht an einer einzelnen Route (siehe `datenbank_weg` weiter unten).
app.include_router(vorpruefung_router)

# Scheibe 2, M4: die Zweckbestimmung (EN-04a). Ebenfalls eine eigene Datei
# und hier nur eingebunden. Sie steht NACH der Vorpruefung, weil sie den Weg
# fortsetzt, den jene bis GEEIGNET fuehrt -- die Reihenfolge der beiden
# Zeilen entscheidet fachlich nichts, die Pfade ueberschneiden sich nicht.
app.include_router(zweckbestimmung_router)

# Scheibe 4, M5: das gefuehrte Gespraech (EN-05 und EN-06). Dritte eigene
# Datei, derselbe Grund wie oben. Sie steht NACH der Zweckbestimmung, weil
# sie deren Ergebnis voraussetzt: ohne eine ueber create_app_after_fit
# angelegte Anwendung gibt es keinen Gespraechsstand, den sie fuehren
# koennte (Bauauftrag §6a: "Faellt M4, entsteht keine Anwendung, und M5 bis
# M9 haben keinen Gegenstand").
app.include_router(gespraech_router)


class TokenAusDemProtokoll(logging.Filter):
    """Verdeckt die Abfragezeichenfolge von /einladung im Zugriffsprotokoll.

    K20-M08 und K23-D09: der Klartext-Token steht NIE in einem Log. Das
    Zugriffsprotokoll von uvicorn schreibt die volle Anfragezeile, also auch
    "?token=...". Der Einladungslink ist ein Zugangswert -- wer das Protokoll
    lesen darf, koennte damit jede noch offene Einladung einloesen, ohne die
    Datenbank je gesehen zu haben.

    Deshalb traegt der Vertrag den Token beim POST im Rumpf; nur der erste
    Aufruf aus der Mail kann ihn ueberhaupt in der Adresszeile fuehren, und
    genau diese Zeile wird hier gekuerzt. Der Pfad bleibt stehen, damit der
    Betrieb den Aufruf noch sieht.

    Der Filter haengt an der Ausgabe und ersetzt sie nicht: geht er ins
    Leere -- anderes Format, anderer Server --, bleibt die Zeile wie sie war.
    Ein Protokollfilter darf kein Protokoll verschlucken.
    """

    def filter(self, satz):
        args = getattr(satz, "args", None)
        if isinstance(args, tuple) and len(args) >= 3 and isinstance(args[2], str):
            pfad = args[2]
            if pfad.startswith("/einladung?"):
                satz.args = args[:2] + ("/einladung?token=<verdeckt>",) + args[3:]
        return True


logging.getLogger("uvicorn.access").addFilter(TokenAusDemProtokoll())


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


def _en01(request, meldung=None, adresse=None, status=200,
          ki_bestaetigt=False):
    antwort = VORLAGEN.TemplateResponse(
        request, "en01_anmeldung.html",
        {"meldung": meldung, "adresse": adresse,
         # Bauaufgabe L9: der Wortlaut kommt aus dem Modul, nicht aus der
         # Vorlage. Drei Absaetze, je eine geforderte Angabe.
         "ki_hinweis": ki_hinweis.HINWEIS,
         "ki_bestaetigung": ki_hinweis.BESTAETIGUNG,
         # Ein gesetztes Haekchen ueberlebt eine Fehlermeldung. Wer seinen
         # Code vertippt, soll nicht zweimal bestaetigen muessen -- das
         # erzeugt Klickmuedigkeit, und Klickmuedigkeit ist das Gegenteil
         # einer Kenntnisnahme.
         "ki_bestaetigt": ki_bestaetigt},
        status_code=status)
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

    # BAUAUFGABE L9 -- Kriterium 1 und 2 traegt die Maske, Kriterium 3 NICHT.
    #
    # HIER STAND EIN RIEGEL. Er wies die Anmeldung ab, solange das Kaestchen
    # zum KI-Hinweis nicht gesetzt war. ZURUECKGENOMMEN am 16.08.2026,
    # nachdem der blinde Prueflauf gemessen hat, was er kostet:
    #
    #   anmeldung     8 von 30 bestanden   (vorher vollstaendig)
    #   vorpruefung   8 von 32             (vorher 30 von 32)
    #   anmeldecode  13 von 17             (vorher 16 von 17)
    #
    # KEIN EINZIGER PRUEFFALL KENNT DAS FELD `ki_bestaetigt`. Der Riegel hat
    # den Anmeldevertrag geaendert, auf dem jeder andere Faden aufsetzt --
    # und er hat es getan, ohne dass eine Klausel das verlangt:
    # Paragraf 7a, L9 sagt "vor der ERSTEN Nutzung", nicht "vor jeder".
    #
    # DIE FRAGE, DIE DAHINTERSTEHT, IST OFFEN und wird nicht still
    # entschieden: Einmal je Person oder bei jeder Anmeldung? Einmal je
    # Person setzt voraus, dass man VOR der Anmeldung weiss, wer kommt --
    # und das hiesse, die Adresse gegen die Datenbank zu pruefen, bevor der
    # Code stimmt. Genau diese Kontoauskunft wollte K03-M16 nicht.
    # Der saubere Ausweg waere ein Riegel NACH der Anmeldung und VOR der
    # Uebersicht. Er ist nicht gebaut, weil er dieselbe Frage voraussetzt.
    #
    # WAS DAMIT GILT: Der Hinweis steht sichtbar ueber dem Formular
    # (Kriterium 1 und 2). Die nachweisbare Kenntnisnahme (Kriterium 3) ist
    # NICHT erzwungen -- L9 ist damit NICHT erfuellt, und das steht so in
    # nachweise/vorbedingungen/L9_portal_hinweis_260816.md.
    # Vorgelegt als E-13 in arbeit/Vorlagen/entscheidung_tor1_260816.md.
    #
    # Kein Alibi-Kaestchen: eine Pruefung, die nur in der Oberflaeche steht,
    # gilt nach K03-M13 als nicht erfolgt. Lieber eine offene Luecke, die
    # jeder sieht, als ein Bedienelement, das Sicherheit vortaeuscht.

    with verbindung() as conn:
        sitzung_id = anmelden(conn, email, code, herkunft)

    if sitzung_id is None:
        # 200 mit Meldung, ausdruecklich KEIN Cookie: eine Sitzung entsteht
        # nur aus einer bestaetigten zweiten Stufe (K03-M09, K03-D01).
        # Das Haekchen bleibt gesetzt: die Bestaetigung war nicht der Fehler.
        return _en01(request, meldung=MELDUNG_MISSERFOLG, adresse=email)

    antwort = RedirectResponse("/", status_code=UMLEITUNG)
    keks_setzen(antwort, sitzung_id)
    antwort.headers["Cache-Control"] = "no-store"
    return antwort


def _einladungsseite(request, token=None, meldung=None):
    antwort = VORLAGEN.TemplateResponse(
        request, "einladung.html", {"token": token, "meldung": meldung})
    # no-store: der Token steht im verdeckten Feld dieser Seite und hat in
    # keinem Zwischenspeicher etwas verloren. no-referrer: sonst reicht der
    # Browser die Adresszeile -- mitsamt Token -- an das naechste Ziel weiter
    # (K20-M08, K23-D09).
    antwort.headers["Cache-Control"] = "no-store"
    antwort.headers["Referrer-Policy"] = "no-referrer"
    return antwort


@app.get("/einladung", response_class=HTMLResponse)
def einladungsmaske(request: Request, token: str = ""):
    """Zeigt die Bestaetigung. AENDERT NICHTS -- keine Zeile, keine Verbindung.

    Diese Route ruehrt die Datenbank nicht an. Zwei Gruende, beide zwingend:

    1. Ein Mailscanner ruft Links vorab ab. Loeste dieser Aufruf ein, waere
       die Einladung verbraucht, bevor der Mensch sie sieht -- und der Weg
       fuehrte fuer ihn ins Leere (K20-D10: der verfallene Link fuehrt zu
       einem neuen Vorgang, nicht zu einer Verlaengerung).

    2. Wuerde hier nachgesehen, ob es den Streuwert gibt, waere die Antwort
       ein Orakel: Bestaetigungsseite heisst "diese Einladung existiert",
       Meldung heisst "diese nicht". Wer Links durchprobiert, haette damit
       ein Verzeichnis der offenen Einladungen. Also entscheidet hier
       ausschliesslich, ob ueberhaupt ein Wert vorliegt; ob er traegt,
       entscheidet erst der POST -- und der sagt es niemandem.
    """
    if not token_traegt(token):
        return _einladungsseite(request, meldung=MELDUNG_EINLADUNG)
    return _einladungsseite(request, token=token)


@app.post("/einladung")
def einladung_annehmen(request: Request, token: str = Form(default="")):
    with verbindung() as conn:
        erfolg = einloesen(conn, token)

    if not erfolg:
        # 200 mit der einen Meldung. Die Seite kommt OHNE Token zurueck: ein
        # Link, der nicht mehr traegt, gehoert nicht noch einmal angeboten --
        # eine zweite Schaltflaeche waere die Einladung, es noch einmal zu
        # versuchen, und jeder Versuch ist derselbe Misserfolg (K20-D10).
        return _einladungsseite(request, meldung=MELDUNG_EINLADUNG)

    # 303 auf EN-01. Der Zugang ist frei, angemeldet ist damit niemand: die
    # Einloesung ist keine bestaetigte zweite Stufe, und eine Sitzung entsteht
    # nur aus einer solchen (K03-M09). Der naechste Schritt ist der Code --
    # und er ist seit dem 14.08.2026 unterwegs, wenn diese Zeile laeuft:
    # app/einladung.py stellt ihn nach dem Festschreiben der Einloesung aus
    # (K03-M05). Scheitert der Versand, bleibt es bei dieser Umleitung. Die
    # Einloesung hat getragen, und der Fehlschlag steht im Versandnachweis --
    # nicht auf dem Bildschirm.
    antwort = RedirectResponse("/anmeldung", status_code=UMLEITUNG)
    antwort.headers["Cache-Control"] = "no-store"
    antwort.headers["Referrer-Policy"] = "no-referrer"
    return antwort


def _zurueck_auf_en01(merkmal):
    """Ohne gueltige Sitzung fuehrt kein Weg weiter -- K03-D01, kein Teil-Zugang.

    Dieselbe Antwort wie auf der Startseite: 303 auf EN-01, und ein
    vorhandenes, aber nicht mehr tragendes Merkmal wird geloescht. Es stehen
    zu lassen hiesse, dem Browser zu suggerieren, er sei angemeldet.
    """
    antwort = RedirectResponse("/anmeldung", status_code=UMLEITUNG)
    if merkmal:
        keks_loeschen(antwort)
    antwort.headers["Cache-Control"] = "no-store"
    return antwort


# Das Portal, dessen Mitgliedschaft zum Einladen berechtigt. Als Konstante
# und nicht als Zeichenkette in zwei Routen: zwei Stellen laufen auseinander.
PORTAL_VERWALTUNG = "EXMA"


def _ohne_einladerecht(stand):
    """K13-M05: darf diese Sitzung den Einladeweg ueberhaupt betreten?

    BEFUND F2 der Fremdpruefung vom 14.08.2026: Bis heute genuegte eine
    aktive Sitzung mit genau einem freigeschalteten Portal. Damit durfte
    auch ein Konto des ENDUSER-Portals einladen. Der Vertrag sagt etwas
    anderes, und zwar an drei Stellen:

      K13-M05  "Jeder Aufruf aus einer Oberflaeche MUSS ueber den Serverpfad
               laufen. Der Serverpfad prueft aktives Konto, MITGLIEDSCHAFT,
               ROLLE, Mandant und Objektbezug, bevor er liest oder schreibt."
               Konto, Mandant und Objektbezug hielt app/sitzung.py laengst --
               Mitgliedschaft und Rolle wurden nur GEZAEHLT, nie GEPRUEFT.
      K19      schema/K19_screens.yaml, EX-10/einladung_senden, Feld
               `berechtigung`: "serverseitig: EXMA-Mitgliedschaft im
               Serverpfad (K13-M05)". Und EX-09/nutzer_einladen: "ohne sie
               endet jeder Aufruf ausser EX-01 auf EX-01".
      K20-M02  Release 1 fuehrt je Portal GENAU EINE Rolle -- Plattform-Admin
               fuer EXMA, Endnutzer fuer ENDUSER (F08, K14-G04: ausdruecklich
               kein Rechte-Baukasten). Die Mitgliedschaft im EXMA-Portal IST
               deshalb die Rolle Plattform-Admin. Diese Pruefung erfindet
               also keine Berechtigungsregel; sie liest die eine, die es gibt.

    GEPRUEFT WIRD DAS PORTAL DER SITZUNG, nicht eine zweite Abfrage: das
    Portal in `stand` stammt aus derselben gepruften Zeile wie Konto und
    Mandant und ist ueber `portal_enabled` gegen K20-D02 gehalten
    (app/sitzung.py, portal_bestimmen). Ein zweiter Zugriff waere eine zweite
    Wahrheit, die zwischen beiden Abfragen auseinanderlaufen kann.
    """
    return stand["portal"] != PORTAL_VERWALTUNG


def _kein_einladerecht():
    """Die Antwort auf einen Aufruf ohne EXMA-Mitgliedschaft: 303 auf "/".

    KEIN TEIL-ZUGANG, aber auch keine Abmeldung. Die Sitzung ist gueltig --
    sie traegt nur dieses Formular nicht. Deshalb ausdruecklich NICHT
    `_zurueck_auf_en01`: das loescht den Keks und wuerfe eine einwandfreie
    Sitzung hinaus, was kein Vertragssatz verlangt. K19 fuehrt fuer EX-09
    "endet jeder Aufruf ausser EX-01 auf EX-01" -- den Einstieg des eigenen
    Portals. Der Einstieg, den DIESE Sitzung hat, ist "/".

    KEINE MELDUNG. Anders als beim Versand (K20-G01, angemeldeter
    Verwaltender vor seiner eigenen Eingabe) stuende hier ein Satz auf dem
    Bildschirm, der die Existenz eines Verwaltungswegs bestaetigt, den diese
    Person nicht hat. Die Umleitung ist die Antwort.
    """
    antwort = RedirectResponse("/", status_code=UMLEITUNG)
    antwort.headers["Cache-Control"] = "no-store"
    return antwort


def _versandseite(request, stand, meldung=None, adresse=None, anzeigename=None):
    antwort = VORLAGEN.TemplateResponse(
        request, "einladung_senden.html",
        {"meldung": meldung, "adresse": adresse, "anzeigename": anzeigename,
         "einladender": stand["anzeigename"], "portal": stand["portal"]})
    # Die Maske traegt die Eingabe zurueck und nennt den angemeldeten
    # Verwaltenden; in einem Zwischenspeicher hat beides nichts verloren.
    antwort.headers["Cache-Control"] = "no-store"
    return antwort


@app.get("/einladung/senden", response_class=HTMLResponse)
def versandmaske(request: Request, gesendet: str = ""):
    """Das Formular des Verwaltenden. AENDERT NICHTS.

    `gesendet` traegt keine Angabe zum Vorgang -- es ist die Quittung nach
    der Umleitung des POST und nichts weiter. Der Link steht nicht darin und
    wird auch nicht nachgeschlagen (K20-D03: nie erneut angezeigt).
    """
    merkmal = request.cookies.get(KEKS_NAME)
    with verbindung() as conn:
        stand = sitzung_pruefen(conn, merkmal_lesen(merkmal))

    if stand is None:
        return _zurueck_auf_en01(merkmal)
    if _ohne_einladerecht(stand):
        # Schon das FORMULAR ist gesperrt, nicht erst das Absenden. K19 fuehrt
        # EX-10 als Bildschirm des Verwaltenden; wer ihn nicht betreten darf,
        # bekommt ihn nicht zu sehen (K13-M05).
        return _kein_einladerecht()

    return _versandseite(request, stand,
                         meldung=MELDUNG_GESENDET if gesendet else None)


@app.post("/einladung/senden")
def versand_absenden(request: Request,
                     email: str = Form(default=""),
                     anzeigename: str = Form(default="")):
    """Konto, Einladung, Nachweis und Mail -- der Weg steht in app/einladung_senden.py.

    Die Sitzung wird auch hier gegen die Datenbank gehalten und nicht aus
    dem GET von vorhin geglaubt: zwischen Maske und Absenden koennen
    Minuten liegen, eine Sperre wirkt sofort (K03-D01, K03-M17).

    Erfolg endet in einer UMLEITUNG und nicht in einer Seite. Sonst legt ein
    Neuladen des Browsers dieselbe Einladung ein zweites Mal an -- und die
    zweite widerruft nach K20-M13 die erste, die gerade per Mail unterwegs
    ist.
    """
    merkmal = request.cookies.get(KEKS_NAME)
    with verbindung() as conn:
        stand = sitzung_pruefen(conn, merkmal_lesen(merkmal))
        if stand is None:
            return _zurueck_auf_en01(merkmal)
        if _ohne_einladerecht(stand):
            # Erneut und nicht nur im GET: zwischen Formular und Absenden
            # koennen Minuten liegen, und ein POST erreicht diese Route auch
            # ohne vorheriges GET. Eine Pruefung, die nur die Maske haelt,
            # ist keine serverseitige Pruefung (K13-M05, K03-M13).
            return _kein_einladerecht()

        meldung = einladung_senden(conn, stand, email, anzeigename,
                                   request.base_url)

    if meldung is not None:
        # 200 mit BENANNTER Meldung, Eingaben bleiben stehen. Anders als bei
        # Anmeldung und Einloesung gibt es hier mehrere Wortlaute: vor der
        # Maske steht ein angemeldeter Verwaltender, dem die Sperre begruendet
        # angezeigt wird (K20-G01, K20-G04).
        return _versandseite(request, stand, meldung=meldung,
                             adresse=email, anzeigename=anzeigename)

    antwort = RedirectResponse("/einladung/senden?gesendet=1",
                               status_code=UMLEITUNG)
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
