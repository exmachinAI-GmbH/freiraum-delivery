#!/usr/bin/env python3
"""Misst die Auswertungsregel des Direkt-Prototyp-Checks gegen ihre Quelle.

SCHEITERBEDINGUNG -- das ist der Zweck dieses Werkzeugs:

K04 v1.7 Abschn. 5.0 nennt eine pruefbare Zahl:

    "Von 243 moeglichen Antwortkombinationen fuehren 22 zum Vorschlag
     Direkt-Prototyp -- ausnahmslos solche, bei denen Frage 5 auf keine
     Verbindlichkeit und Frage 1 nicht auf 'arbeiten in' zeigt."

Dieses Werkzeug faehrt `app.schnellweg.auswerten` ueber alle 3^5 = 243
Kombinationen und vergleicht. Weicht die Zahl ab, endet es mit Rueckgabewert
1 und nennt die Abweichung. Damit ist die Regel nicht "so gemeint", sondern
gemessen.

WARUM DAS NOETIG IST. K04 widerspricht sich an einer Stelle: die Tabelle in
Abschn. 5.0 fuehrt bei Frage 1 auch die Antwort c als "-> Anwendung", das
Ablaufbild in Abschn. 4.1 laesst das Veto der Frage 1 aber nur bei b
ausloesen. Nur eine der beiden Lesarten trifft die Zahl 22 -- und welche,
entscheidet nicht der Bau, sondern diese Rechnung.

Aufruf:  python3 werkzeuge/schnellweg_gegenprobe.py
"""

import sys
from itertools import product
from pathlib import Path

sys.path.insert(0, str(Path(__file__).resolve().parent.parent))

from app.schnellweg_regel import (GEZAEHLT, VETO, VORSCHLAG_PROTOTYP,  # noqa: E402
                            auswerten)

# Der Startbestand, wie ihn seeds/Seed_Direkt_Prototyp_Check_K04.sql anlegt.
# Er steht hier NOCH EINMAL und wird nicht aus der Datenbank gelesen: dieses
# Werkzeug soll ohne Server und ohne Datenbank laufen koennen. Weicht der
# Seed spaeter ab, faellt es hier auf -- eine zweite Wahrheit, die absichtlich
# eine zweite ist.
BESTAND = {
    "ergebnis": [
        ("eine Datei, die ich öffne, lese und weitergebe", "datei_weitergeben__dok"),
        ("etwas, das ich aufrufe und in dem ich arbeite", "darin_arbeiten__app"),
        ("weiß ich noch nicht", "noch_offen__app"),
    ],
    "wiederholung": [
        ("einmal, für eine bestimmte Frage", "einmalig__dok"),
        ("immer wieder, im laufenden Betrieb", "laufender_betrieb__app"),
        ("erst einmal, später vielleicht öfter", "spaeter_vielleicht__app"),
    ],
    "beteiligte": [
        ("nur ich", "nur_ich__dok"),
        ("mehrere Personen, jede mit eigener Sicht", "mehrere_sichten__app"),
        ("ich erstelle es, andere lesen es", "ich_schreibe__dok"),
    ],
    "daten": [
        ("ich bringe sie mit oder gebe sie einmal ein", "mitgebracht__dok"),
        ("sie stehen in Systemen, die laufend weiterlaufen", "laufende_systeme__app"),
        ("sie entstehen erst beim Benutzen", "entstehen_beim_tun__app"),
    ],
    "verbindlichkeit": [
        ("nein, es ist eine Arbeitsgrundlage für mich", "arbeitsgrundlage__dok"),
        ("ja, andere verlassen sich darauf", "andere_verlassen_sich__app"),
        ("es geht um Geld, Fristen oder Personen", "geld_fristen_personen__app"),
    ],
}

REIHEN = ["ergebnis", "wiederholung", "beteiligte", "daten", "verbindlichkeit"]

SOLL_GESAMT = 243
SOLL_PROTOTYP = 22


def main():
    fehler = []

    if set(BESTAND) != set(VETO) | set(GEZAEHLT):
        fehler.append("Der Bestand dieses Werkzeugs und die Fragen in "
                      "app/schnellweg.py stimmen nicht ueberein.")

    gesamt = 0
    prototyp = 0
    ohne_satz = []
    for wahl in product(range(3), repeat=5):
        gesamt += 1
        antworten = {code: BESTAND[code][wahl[i]] for i, code in enumerate(REIHEN)}
        vorschlag, begruendung = auswerten(antworten)
        if vorschlag == VORSCHLAG_PROTOTYP:
            prototyp += 1
        # K04-M25: JEDE Auswertung traegt genau einen Begruendungssatz, und
        # er nennt eine Antwort. Ein leerer Satz waere ein stiller Vorschlag.
        if not begruendung or "„" not in begruendung:
            if len(ohne_satz) < 3:
                ohne_satz.append((antworten, vorschlag, begruendung))

    print(f"Kombinationen gesamt          : {gesamt}   (Soll {SOLL_GESAMT})")
    print(f"davon Vorschlag Direkt-Prototyp: {prototyp}   (Soll {SOLL_PROTOTYP})")

    if gesamt != SOLL_GESAMT:
        fehler.append(f"Zahl der Kombinationen weicht ab: {gesamt} statt {SOLL_GESAMT}.")
    if prototyp != SOLL_PROTOTYP:
        fehler.append(
            f"K04 Abschn. 5.0 nennt {SOLL_PROTOTYP} Kombinationen mit dem "
            f"Vorschlag Direkt-Prototyp, gemessen wurden {prototyp}. Die "
            "Auswertungsregel in app/schnellweg.py weicht von der Quelle ab.")
    if ohne_satz:
        fehler.append(
            "K04-M25 verletzt: es gibt Auswertungen ohne Begruendungssatz, "
            f"der eine Antwort nennt. Erstes Beispiel: {ohne_satz[0]}")

    # Die Zusatzaussage der Quelle: die 22 Faelle liegen ausnahmslos dort, wo
    # Frage 5 auf "keine Verbindlichkeit" und Frage 1 nicht auf "arbeiten in"
    # zeigt. Auch das wird gemessen, nicht geglaubt.
    for wahl in product(range(3), repeat=5):
        antworten = {code: BESTAND[code][wahl[i]] for i, code in enumerate(REIHEN)}
        vorschlag, _ = auswerten(antworten)
        if vorschlag != VORSCHLAG_PROTOTYP:
            continue
        if antworten["verbindlichkeit"][1] != "arbeitsgrundlage__dok":
            fehler.append("Ein Direkt-Prototyp-Vorschlag trotz Verbindlichkeit: "
                          f"{antworten['verbindlichkeit'][0]}")
            break
        if antworten["ergebnis"][1] == "darin_arbeiten__app":
            fehler.append("Ein Direkt-Prototyp-Vorschlag trotz 'arbeiten in'.")
            break

    if fehler:
        print()
        for satz in fehler:
            print("FEHLGESCHLAGEN:", satz)
        return 1
    print()
    print("BESTANDEN: die Auswertungsregel stimmt mit K04 v1.7 Abschn. 5.0 ueberein.")
    return 0


if __name__ == "__main__":
    sys.exit(main())
