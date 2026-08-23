# umsetzt: K04-M22 (fuenf Fragen, je drei Antwortmoeglichkeiten, Zuordnung
#          je Antwort -- der Bestand traegt sie, diese Datei liest ihn),
#          K04-M23 (Vetorecht der Fragen 5 und 1), K04-M24 (Zaehlung der
#          Fragen 2 bis 4), K04-M25 (genau ein Begruendungssatz, der die
#          ausschlaggebende Antwort nennt), K04-M03 (der Vorschlag ist keine
#          Entscheidung -- beide Weiterwege bleiben waehlbar), K04-D11 und
#          K04-G13 (fail-closed: unvollstaendig oder nicht auswertbar ergibt
#          ANWENDUNG, nie Direkt-Prototyp), K19-M06 (solange eine Frage offen
#          ist, steht an Stelle der Weiterwege ein Hinweis)
# zur Haelfte umgesetzt: K04-D07 -- weil diese Datei den Weg Arbeitsdokument
#          NICHT beschreitet: EN-12 und `create_direct_prototype` sind nicht
#          gebaut. Sie verhindert nur, dass dabei eine Anwendung entsteht,
#          indem sie den Weg benannt sperrt statt ihn zu erfinden
# zur Haelfte umgesetzt: K04-M15 -- die Ruecknahme traegt dieselbe Grenze des
#          Primaerschluessels wie in app/vorpruefung.py: dieselbe Antwort ein
#          zweites Mal zu waehlen, kollidiert mit dem zurueckgenommenen Satz
"""FREIRAUM · Scheibe 2 · EN-03a, der Direkt-Prototyp-Check.

Ein Bildschirm aus dem Vertrag `schema/K19_screens.yaml` (Eintrag EN-03a),
uebernommen und nicht frei gezeichnet (K19-M01, K04-G10). Derselbe Massstab,
nach dem EN-04a am 16.08.2026 gebaut wurde: die Maschinenquelle ist die
Quelle der Kaesten. Dass der KONZEPTTEXT K19 v1.3 den Kasten noch nicht
fuehrt, ist eine Nachziehung und steht als Vorlage in der Konzept-Fabrik
(N-K19-1 vom 14.08.2026, ungezeichnet).

WARUM DIESE DATEI UEBERHAUPT ENTSTEHT. Bis zum 23.08.2026 stand in
app/vorpruefung.py, der Wortlaut der fuenf Fragen sei "in keinem der
gezeichneten Konzepte enthalten". Das war seit dem 01.08.2026 nicht mehr
richtig: K04 v1.7 Abschn. 5.0 fuehrt ihn vollstaendig, angenommen vom
Founder, und schliesst damit O-K04-1. Siehe
arbeit/Bauberichte/BEF-K04-1_Wortlaut_ist_gezeichnet.md.

Der Vertrag dieser Datei -- er ist zugleich das, was die Pruefung misst:

    GET  /schnellweg              EN-03a. Ohne gueltige Sitzung -> 303 auf
                                  "/anmeldung". Ohne laufenden Schnellweg ->
                                  303 auf "/vorpruefung". Sonst 200: GENAU
                                  EINE Frage -- die naechste unbeantwortete --
                                  mit ihren drei Antwortmoeglichkeiten. Liegt
                                  das Ergebnis vor, statt der Frage der
                                  Vorschlag mit genau einem Begruendungssatz
                                  und den beiden Weiterwegen. AENDERT NICHTS
    POST /schnellweg/antwort      Felder `frage` und `option`. Erfolg -> 303
                                  auf "/schnellweg". Die Antwort wird
                                  geschrieben; eine bestehende aktive Antwort
                                  derselben Frage wird ZURUECKGENOMMEN, nie
                                  geloescht. Mit der fuenften Antwort wird
                                  ausgewertet und `completed_at` gesetzt
    POST /schnellweg/abbruch      303 auf "/vorpruefung". Es entsteht KEIN
                                  Vorschlag; der Vorgang bleibt unvollstaendig
                                  stehen (Bildschirmvertrag, zustand_fehler)
    POST /schnellweg/arbeitsdokument  200, Verbleib auf EN-03a mit benannter
                                  Meldung. EN-12 und der Traeger
                                  `direct_prototype` sind in dieser Scheibe
                                  nicht gebaut -- fail-closed, kein Dokument
    POST /schnellweg/vorpruefung2 Erfolg -> 303 auf "/eignung". Legt EINEN
                                  fit_check an, wie /vorpruefung/ueberspringen

WAS HIER AUSDRUECKLICH NICHT GEBAUT IST

  * Der Weg Arbeitsdokument (EN-12, K07). Er ist im Bildschirmvertrag
    gefuehrt und wird hier benannt gesperrt, nicht erfunden.
  * Ein Abbruch VOR der ersten Antwort loescht den Schnellweg nicht. Er
    bleibt als unvollstaendiger Vorgang stehen -- `quick_check` traegt die
    Aufbewahrungsklasse BETRIEBSPROTOKOLL und wird nicht weggeraeumt.
"""

import logging
from pathlib import Path

from fastapi import APIRouter, Form, Request
from fastapi.responses import HTMLResponse, RedirectResponse
from fastapi.templating import Jinja2Templates

from app.datenbank import verbindung
# Die Auswertungsregel steht in einer eigenen Datei ohne Webrahmen, damit
# sie ohne Server messbar ist -- siehe werkzeuge/schnellweg_gegenprobe.py.
from app.schnellweg_regel import ANZAHL_FRAGEN, GEZAEHLT, VETO, auswerten
from app.sitzung import KEKS_NAME, keks_loeschen, merkmal_lesen, sitzung_pruefen

PROTOKOLL = logging.getLogger(__name__)

VORLAGEN = Jinja2Templates(directory=str(Path(__file__).parent / "vorlagen"))

router = APIRouter()

UMLEITUNG = 303

MELDUNG_FRAGEN_FEHLEN = (
    "Die Fragen der Vorprüfung stehen gerade nicht bereit. Bitte versuchen "
    "Sie es später noch einmal oder überspringen Sie diesen Schritt."
)
MELDUNG_AUSWAHL_UNGUELTIG = (
    "Diese Antwort gehört nicht zu der gestellten Frage. Bitte wählen Sie "
    "eine der angebotenen Möglichkeiten."
)
MELDUNG_ARBEITSDOKUMENT_GESPERRT = (
    "Der Weg zum Arbeitsdokument ist in diesem Stand noch nicht gebaut. Ihre "
    "Antworten bleiben erhalten; Sie können mit der zweiten Vorprüfung "
    "fortfahren."
)

# ---------------------------------------------------------------------------
#  Lesen
# ---------------------------------------------------------------------------


def fragen_lesen(conn):
    """Die fuenf Fragen in ihrer HEUTE gueltigen Fassung, mit Antworten.

    Die Reihenfolge steht in `quick_question.position` und
    `quick_option.position` -- nicht im Programmtext. Die Fassung waehlt
    `gueltig @> CURRENT_DATE`; damit liest der Bau nie "die neueste", sondern
    die geltende. Das ist derselbe Unterschied wie zwischen einem Dokument
    und seiner letzten Fassung.
    """
    fragen = []
    nach_code = {}
    for code, position, version, prompt in conn.execute(
            "SELECT q.code, q.position, v.version, v.prompt_de"
            "  FROM quick_question q"
            "  JOIN quick_question_version v ON v.question_code = q.code"
            " WHERE v.gueltig @> CURRENT_DATE"
            " ORDER BY q.position").fetchall():
        frage = {"code": code, "position": position, "version": version,
                 "prompt": prompt, "optionen": [], "gewaehlt": None}
        fragen.append(frage)
        nach_code[code] = frage

    for frage_code, version, position, label, token, zuordnung in conn.execute(
            "SELECT question_code, version, position, label_de, value_token,"
            "       zuordnung::text"
            "  FROM quick_option ORDER BY question_code, position").fetchall():
        frage = nach_code.get(frage_code)
        if frage is None or frage["version"] != version:
            continue
        # `zuordnung` seit dem 23.08.2026 (M36). Die Endung __dok/__app am
        # Token ist nur noch ein Name -- gelesen wird die Spalte.
        frage["optionen"].append({"position": position, "label": label,
                                  "token": token, "zuordnung": zuordnung})
    return fragen


def fragen_tragen(fragen):
    """Traegt der Bestand genau fuenf Fragen zu je genau drei Antworten?

    Keine Bedingung der Datenbank erzwingt das -- eine leere Tabelle verletzt
    keine einzige. Deshalb wird vor jeder Anzeige und vor jeder Auswertung
    gezaehlt. Was nicht auswertbar ist, sperrt (K04-G04).
    """
    if len(fragen) != ANZAHL_FRAGEN:
        return False
    if {f["code"] for f in fragen} != set(VETO) | set(GEZAEHLT):
        return False
    return all(len(f["optionen"]) == 3 for f in fragen)


def check_lesen(conn, stand):
    """Der laufende Schnellweg dieses Kontos -- oder None.

    DER MANDANT STEHT IN DER BEDINGUNG, nicht in einer Pruefung danach
    (K01-M15, K02): ein Vorgang eines fremden Mandanten wird nicht gefunden
    und dann abgelehnt, er wird gar nicht erst gelesen.
    """
    zeile = conn.execute(
        "SELECT id, completed_at FROM quick_check"
        " WHERE tenant_id = %s AND actor_id = %s"
        " ORDER BY started_at DESC LIMIT 1",
        (stand["mandant"], stand["actor_id"])).fetchone()
    return zeile


def antworten_eintragen(conn, check_id, fragen):
    """Traegt die aktive Antwort je Frage in die gelesenen Fragen ein."""
    gewaehlt = {}
    for frage_code, option_pos in conn.execute(
            "SELECT question_code, option_pos FROM quick_answer"
            " WHERE quick_check_id = %s AND superseded_at IS NULL",
            (check_id,)).fetchall():
        gewaehlt[frage_code] = option_pos
    for frage in fragen:
        frage["gewaehlt"] = gewaehlt.get(frage["code"])
    return gewaehlt


def naechste_frage(fragen):
    """Die erste noch unbeantwortete Frage -- oder None, wenn alle stehen."""
    for frage in fragen:
        if frage["gewaehlt"] is None:
            return frage
    return None


def antwortabbildung(fragen):
    """{frage_code: (label, token, zuordnung)} fuer die Auswertung."""
    abbildung = {}
    for frage in fragen:
        if frage["gewaehlt"] is None:
            continue
        for option in frage["optionen"]:
            if option["position"] == frage["gewaehlt"]:
                abbildung[frage["code"]] = (option["label"], option["token"],
                                            option["zuordnung"])
    return abbildung


# ---------------------------------------------------------------------------
#  Schreiben
# ---------------------------------------------------------------------------


def ergebnis_festhalten(conn, check_id, fragen):
    """Wertet aus und setzt `completed_at` -- im selben Schreibvorgang.

    Der Vorschlag wird NICHT gespeichert: `quick_check` fuehrt kein Feld
    dafuer, und eines zu erfinden waere ein zweiter Strang neben den
    Antworten. Er wird bei jeder Anzeige aus den Antworten gerechnet -- aus
    derselben Quelle, aus der er beim ersten Mal kam. Damit kann Angezeigtes
    und Gespeichertes nicht auseinanderlaufen.
    """
    conn.execute(
        "UPDATE quick_check SET completed_at = now()"
        " WHERE id = %s AND completed_at IS NULL", (check_id,))


# ---------------------------------------------------------------------------
#  Hilfen, wortgleich zu app/vorpruefung.py und bewusst nicht von dort
#  eingebunden -- app/haupt.py bindet beide Dateien ein, der umgekehrte Weg
#  waere ein Ringschluss beim Import.
# ---------------------------------------------------------------------------


def _zurueck_auf_en01(merkmal):
    antwort = RedirectResponse("/anmeldung", status_code=UMLEITUNG)
    if merkmal:
        keks_loeschen(antwort)
    antwort.headers["Cache-Control"] = "no-store"
    return antwort


def _seite(request, vorlage, inhalt, status=200):
    antwort = VORLAGEN.TemplateResponse(request, vorlage, inhalt,
                                        status_code=status)
    antwort.headers["Cache-Control"] = "no-store"
    return antwort


def _umleitung(ziel):
    antwort = RedirectResponse(ziel, status_code=UMLEITUNG)
    antwort.headers["Cache-Control"] = "no-store"
    return antwort


def _en03a(request, stand, frage, fragen, vorschlag, begruendung, meldung=None):
    """Der Bildschirm. Er entscheidet nichts -- er zeigt, was gerechnet wurde.

    K19_screens.yaml, EN-03a: "Die Auswertung laeuft auf dem Server; der
    Bildschirm liefert kein Ergebnis mit." Deshalb bekommt die Vorlage den
    fertigen Vorschlag und den fertigen Satz -- nie die Antworten, aus denen
    sie sich rechnen liessen.

    SOLANGE EINE FRAGE OFFEN IST, gibt es keine Weiterwege (K19-M06). Nicht
    ausgegraut, sondern ausgeblendet: der Nutzer erfuellt die Bedingung
    selbst, indem er antwortet.
    """
    return _seite(request, "en03a_fragen.html", {
        "anzeigename": stand["anzeigename"],
        "frage": frage,
        "nummer": (frage["position"] if frage else ANZAHL_FRAGEN),
        "anzahl": ANZAHL_FRAGEN,
        "vorschlag": vorschlag,
        "begruendung": begruendung,
        "meldung": meldung,
    })


def _stand_und_check(request):
    """Sitzung, Fragen, Check und Antworten in einem Zug -- oder ein Abbruch.

    Rueckgabe: (antwort_oder_None, stand, conn_daten). Die zweite Form spart
    jedem Weg dieselben acht Zeilen; der Preis ist, dass die Verbindung
    geschlossen ist, wenn er sie bekommt. Alles, was geschrieben werden muss,
    oeffnet deshalb seine eigene.
    """
    merkmal = request.cookies.get(KEKS_NAME)
    with verbindung() as conn:
        stand = sitzung_pruefen(conn, merkmal_lesen(merkmal))
        if stand is None:
            return _zurueck_auf_en01(merkmal), None, None
        fragen = fragen_lesen(conn)
        if not fragen_tragen(fragen):
            PROTOKOLL.error(
                "EN-03a gesperrt: der Bestand fuehrt nicht genau fuenf Fragen "
                "zu je drei Antwortmoeglichkeiten (K04-M22). Startbestand: "
                "seeds/Seed_Direkt_Prototyp_Check_K04.sql")
            return _umleitung("/vorpruefung"), None, None
        check = check_lesen(conn, stand)
        if check is None:
            return _umleitung("/vorpruefung"), None, None
        antworten_eintragen(conn, check[0], fragen)
    return None, stand, (check, fragen)


# ---------------------------------------------------------------------------
#  EN-03a
# ---------------------------------------------------------------------------


@router.get("/schnellweg", response_class=HTMLResponse)
def schnellweg(request: Request, meldung: str = ""):
    """EN-03a. AENDERT NICHTS."""
    abbruch, stand, daten = _stand_und_check(request)
    if abbruch is not None:
        return abbruch
    check, fragen = daten
    frage = naechste_frage(fragen)
    if frage is not None:
        return _en03a(request, stand, frage, fragen, None, None)
    vorschlag, begruendung = auswerten(antwortabbildung(fragen))
    return _en03a(request, stand, None, fragen, vorschlag, begruendung)


@router.post("/schnellweg/antwort", response_class=HTMLResponse)
def schnellweg_antwort(request: Request,
                       frage: str = Form(default=""),
                       option: str = Form(default="")):
    """Eine Antwort. Mit der fuenften wird ausgewertet.

    DIE ANTWORT MUSS ZU DER FRAGE GEHOEREN, und das wird gegen den BESTAND
    geprueft, nicht gegen das Formular: ein Formularfeld sagt nur, was der
    Browser geschickt hat. Passt die Antwortmoeglichkeit nicht zur Frage,
    wird nichts geschrieben (fail-closed).
    """
    abbruch, stand, daten = _stand_und_check(request)
    if abbruch is not None:
        return abbruch
    check, fragen = daten

    passend = next((f for f in fragen if f["code"] == frage), None)
    gewaehlt = None
    if passend is not None and option.isdigit():
        gewaehlt = next((o for o in passend["optionen"]
                         if o["position"] == int(option)), None)
    if gewaehlt is None:
        naechste = naechste_frage(fragen)
        return _en03a(request, stand, naechste, fragen, None, None,
                      meldung=MELDUNG_AUSWAHL_UNGUELTIG)

    with verbindung() as conn:
        # Ruecknahme statt Loeschen (K04-D03 sinngemaess, wie am
        # Eignungs-Check): die alte Zeile bleibt und traegt einen Zeitpunkt.
        conn.execute(
            "UPDATE quick_answer SET superseded_at = now()"
            " WHERE quick_check_id = %s AND question_code = %s"
            "   AND superseded_at IS NULL",
            (check[0], passend["code"]))
        conn.execute(
            "INSERT INTO quick_answer (quick_check_id, question_code, version,"
            "                          option_pos)"
            " VALUES (%s, %s, %s, %s) ON CONFLICT DO NOTHING",
            (check[0], passend["code"], passend["version"], gewaehlt["position"]))

        fragen = fragen_lesen(conn)
        antworten_eintragen(conn, check[0], fragen)
        if naechste_frage(fragen) is None:
            ergebnis_festhalten(conn, check[0], fragen)

    return _umleitung("/schnellweg")


@router.post("/schnellweg/abbruch")
def schnellweg_abbruch(request: Request):
    """Abbruch. OHNE VORSCHLAG zurueck nach EN-03 (Bildschirmvertrag).

    Der Vorgang wird nicht geloescht und nicht abgeschlossen. Er bleibt
    unvollstaendig stehen -- was angefangen wurde, verschwindet nicht
    spurlos, und `completed_at` bleibt leer, weil kein Ergebnis vorliegt.
    """
    merkmal = request.cookies.get(KEKS_NAME)
    with verbindung() as conn:
        stand = sitzung_pruefen(conn, merkmal_lesen(merkmal))
    if stand is None:
        return _zurueck_auf_en01(merkmal)
    return _umleitung("/vorpruefung")


@router.post("/schnellweg/arbeitsdokument", response_class=HTMLResponse)
def schnellweg_arbeitsdokument(request: Request):
    """Der Weg Arbeitsdokument -- benannt gesperrt, nicht erfunden.

    Der Bildschirmvertrag fuehrt ihn nach EN-12 ueber `create_direct_prototype`.
    Beides ist in dieser Scheibe nicht gebaut. Ein Arbeitsdokument hier
    anzulegen hiesse, einen Traeger zu benutzen, den niemand geprueft hat --
    und K04-D07 verbietet ausdruecklich, dass daraus eine Anwendung wird.
    Also 200, Verbleib, benannte Meldung, nichts angelegt (fail-closed).
    """
    abbruch, stand, daten = _stand_und_check(request)
    if abbruch is not None:
        return abbruch
    check, fragen = daten
    vorschlag, begruendung = auswerten(antwortabbildung(fragen))
    return _en03a(request, stand, naechste_frage(fragen), fragen,
                  vorschlag, begruendung,
                  meldung=MELDUNG_ARBEITSDOKUMENT_GESPERRT)


@router.post("/schnellweg/vorpruefung2")
def schnellweg_vorpruefung2(request: Request):
    """Weiter in die zweite Vorpruefung. Hier entsteht der Eignungs-Check.

    ER IST AUCH GEGEN DEN VORSCHLAG WAEHLBAR (K04-M03): der Vorschlag ist
    keine Entscheidung. Dieser Weg prueft deshalb NICHT, was vorgeschlagen
    wurde -- er prueft nur, dass ein Ergebnis vorliegt.
    """
    abbruch, stand, daten = _stand_und_check(request)
    if abbruch is not None:
        return abbruch
    check, fragen = daten
    if naechste_frage(fragen) is not None:
        return _en03a(request, stand, naechste_frage(fragen), fragen, None, None)

    with verbindung() as conn:
        conn.execute(
            "INSERT INTO fit_check (tenant_id, actor_id, outcome,"
            "                       retention_class)"
            " VALUES (%s, %s, 'OFFEN', 'KI_NACHWEIS')",
            (stand["mandant"], stand["actor_id"]))
    return _umleitung("/eignung")
