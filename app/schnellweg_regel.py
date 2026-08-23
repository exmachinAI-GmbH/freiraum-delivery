"""FREIRAUM · die Auswertungsregel des Direkt-Prototyp-Checks (K04).

DIESE DATEI BINDET NICHTS EIN AUSSER DER STANDARDBIBLIOTHEK -- und das ist
ihr ganzer Zweck. Die Regel, die einen Kunden auf den Dokument- oder den
Anwendungsweg lenkt, soll ohne Server, ohne Datenbank und ohne Webrahmen
gemessen werden koennen. Solange sie in app/schnellweg.py neben `APIRouter`
stand, brauchte jede Gegenprobe eine Installation.

Gemessen wird sie von werkzeuge/schnellweg_gegenprobe.py gegen die
Kontrollzahl, die K04 v1.7 Abschn. 5.0 selbst nennt: 22 von 243.

Quelle der Regel: K04-M23 (Vetorecht der Fragen 5 und 1), K04-M24 (Zaehlung
der Fragen 2 bis 4), K04-M25 (ein Begruendungssatz), K04-D11 und K04-G13
(fail-closed: im Zweifel ANWENDUNG).
"""

# Genau fuenf Fragen (K04-M22). Als Konstante und nicht als "5" in vier
# Abfragen -- dieselbe Begruendung wie ANZAHL_FRAGEN in app/vorpruefung.py.
ANZAHL_FRAGEN = 5

# Die Fassung, die dieser Bau liest. Der Traeger fuehrt Fragen MIT Fassung;
# eine Antwort verweist auf die BEANTWORTETE Fassung (Gegentest Nr. 55).
# Gelesen wird nicht "die neueste", sondern die HEUTE GUELTIGE -- das ist
# eine Angabe der Datenbank (`gueltig @> CURRENT_DATE`), keine des Codes.

# Die beiden Werte des Aufzaehlungstyps quick_zuordnung (M36).
ZUORDNUNG_ANWENDUNG = "ANWENDUNG"
ZUORDNUNG_DOKUMENT = "DOKUMENT"

VORSCHLAG_ANWENDUNG = "ANWENDUNG"
VORSCHLAG_PROTOTYP = "DIREKT_PROTOTYP"

# --- DAS VETORECHT, ausgeschrieben statt hergeleitet (K04-M23) -------------
#
# K04-M23: "Zwei Fragen MUESSEN allein entscheiden: die Frage nach der
# Verbindlichkeit und die Frage nach dem Ergebnis. Zeigt eine von beiden auf
# Anwendung, lautet der Vorschlag Anwendung."
#
# Woertlich gelesen hiesse das: JEDE __app-Antwort dieser beiden Fragen loest
# das Veto aus. Das Ablaufbild in K04 Abschn. 4.1 sagt aber etwas anderes:
#
#     Frage 5 Verbindlichkeit = b/c ? --ja--> VORSCHLAG Anwendung
#     Frage 1 Ergebnis        = b   ? --ja--> VORSCHLAG Anwendung
#
# Bei Frage 1 nur b, obwohl die Tabelle in Abschn. 5.0 auch c als
# "-> Anwendung" fuehrt. Die beiden Stellen widersprechen einander.
#
# ENTSCHIEDEN HAT DIE KONTROLLZAHL, nicht der Bau: K04 Abschn. 5.0 sagt, von
# 243 Kombinationen fuehren 22 zum Direkt-Prototyp. Nachgerechnet ergibt die
# Lesart "Veto bei b" genau 22, die Lesart "Veto bei b und c" nur 11. Der
# Nachweis laeuft als eigenes Werkzeug: werkzeuge/schnellweg_gegenprobe.py.
#
# Die Folge ist eine Antwort ohne Wirkung: ergebnis = c loest kein Veto aus
# und wird auch nicht gezaehlt. Ausgewiesen und NICHT entschieden -- siehe
# arbeit/Bauberichte/BEF-K04-2_Traeger_ohne_Zuordnung.md. Entscheiden
# muesste K04. Bis dahin folgt der Bau der Zahl, die die Quelle selbst nennt.
VETO = {
    "verbindlichkeit": ("andere_verlassen_sich__app", "geld_fristen_personen__app"),
    "ergebnis": ("darin_arbeiten__app",),
}

# Die drei gezaehlten Fragen (K04-M24). Ihre Reihenfolge ist die des
# Bestandes; hier steht nur, WELCHE gezaehlt werden.
GEZAEHLT = ("wiederholung", "beteiligte", "daten")

# ---------------------------------------------------------------------------
#  Die Auswertung -- ohne Datenbank, damit sie pruefbar ist
# ---------------------------------------------------------------------------


def auswerten(antworten):
    """Vorschlag und Begruendungssatz aus den fuenf Antworten (K04-M23 bis M25).

    `antworten` ist eine Abbildung {frage_code: (label, token, zuordnung)}. Zurueck kommt
    (vorschlag, begruendung). Diese Funktion liest nichts und schreibt nichts
    -- sie ist die einzige Stelle, an der die Regel steht, und sie laesst sich
    ohne Server gegen alle 243 Kombinationen fahren.

    FAIL-CLOSED IST DER ERSTE SCHRITT, NICHT DER LETZTE (K04-D11): fehlt eine
    Antwort, lautet der Vorschlag ANWENDUNG und der Grund wird genannt. Erst
    danach wird ueberhaupt gewogen.
    """
    fehlend = [code for code in list(VETO) + list(GEZAEHLT) if code not in antworten]
    if fehlend:
        return VORSCHLAG_ANWENDUNG, (
            "Es fehlt noch eine Antwort, deshalb schlagen wir die Anwendung "
            "vor — der Weg, auf dem alle Prüfungen greifen."
        )

    # Schritt 1 und 2 -- das Veto. Die Reihenfolge ist die des Ablaufbildes:
    # erst die Verbindlichkeit, dann das Ergebnis.
    for code in ("verbindlichkeit", "ergebnis"):
        label, token, _ = antworten[code]
        if token in VETO[code]:
            return VORSCHLAG_ANWENDUNG, (
                f"Ihre Antwort „{label}“ gibt allein den Ausschlag: "
                "dafür braucht es eine Anwendung."
            )

    # Schritt 3 -- die Zaehlung der Fragen 2 bis 4.
    # Gezaehlt wird nach der Spalte `zuordnung` (M36, 23.08.2026), nicht
    # mehr nach der Endung am Token. Der Name ist ein Name, die Spalte ist
    # die Wahrheit -- der Seed misst nach, dass beide uebereinstimmen.
    treffer = [(code, antworten[code][0]) for code in GEZAEHLT
               if antworten[code][2] == ZUORDNUNG_ANWENDUNG]

    if len(treffer) >= 2:
        genannt = treffer[0][1]
        return VORSCHLAG_ANWENDUNG, (
            f"Mehrere Ihrer Antworten sprechen dafuer, zuerst „{genannt}“: "
            "das trägt ein Dokument nicht."
        )
    if len(treffer) == 1:
        genannt = treffer[0][1]
        return VORSCHLAG_PROTOTYP, (
            f"Nur „{genannt}“ spricht für eine Anwendung — für alles "
            "Übrige genügt ein Arbeitsdokument."
        )
    label = antworten["verbindlichkeit"][0]
    return VORSCHLAG_PROTOTYP, (
        f"Ihre Antwort „{label}“ gibt den Ausschlag: dafür genügt ein "
        "Arbeitsdokument."
    )
