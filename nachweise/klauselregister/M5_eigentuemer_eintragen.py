#!/usr/bin/env python3
"""Traegt die fachlichen Eigentuemer der M5-Klauseln in pflege.json ein.

    python3 nachweise/klauselregister/M5_eigentuemer_eintragen.py [--schreiben]

GRUNDLAGE
    arbeit/Vorlagen/m5_vor_dem_bauzug_260819.md, Entscheidung 3, gez. M. Veil und
    A. Han am 19.08.2026: Fachlicher Eigentuemer der M5-Klauseln ist A. Han fuer
    den Auftragnehmer, AUSSER fuer K17 -- dort M. Veil, wie in der Runde vom
    16.08.2026 (dort: A. Han 139, M. Veil 3 fuer K15 und K17).

    Damit ist die Einengung vom 16.08.2026 ("Nur fuer die 167 des Teilschnitts")
    fuer die Klauseln von M5 aufgehoben. Sie gilt fuer alle uebrigen weiter.

WAS ES VERWEIGERT
    - das Ueberschreiben eines vorhandenen Eigentuemers. Elf der 101 Zeilen
      tragen bereits einen aus der Runde vom 16.08.; sie bleiben stehen,
    - jedes andere Feld. Kriterium und Kritikalitaet fasst es nicht an.

WARUM DAS KEIN VORSCHLAG IST
    Die uebrigen Eintraege dieses Registers tragen die Marke
    "VORSCHLAG · NICHT GEZEICHNET". Der Eigentuemer nicht: er ist gezeichnet,
    und der Eintrag nennt die Weisung, auf der er beruht. Ein Kreuz zu setzen,
    fuer das eine Weisung vorliegt, ist Buchfuehrung (CLAUDE.md Abschn. 6).
"""
import argparse
import json
import sys
from pathlib import Path

HIER = Path(__file__).resolve().parent
PFLEGE = HIER / "pflege.json"
REGISTER = HIER / "register.json"
MENGE = HIER / "M5_klausellage_260819.json"

GRUNDLAGE = ("Grundlage: arbeit/Vorlagen/m5_vor_dem_bauzug_260819.md, Entscheidung 3 — "
             "Fortschreibung der Zuweisung vom 16.08.2026; die Einengung auf den "
             "Teilschnitt ist fuer die Klauseln von M5 aufgehoben")
AUFTRAGNEHMER = ("Auftragnehmer (Nr. 158), vertreten durch A. Han · gez. M. Veil und A. Han, "
                 f"19.08.2026 · {GRUNDLAGE}")
AUFTRAGGEBER = ("Auftraggeber, M. Veil · gez. M. Veil und A. Han, 19.08.2026 · "
                f"{GRUNDLAGE}; K17 bleibt beim Auftraggeber wie am 16.08.2026")


def main():
    p = argparse.ArgumentParser()
    p.add_argument("--schreiben", action="store_true")
    a = p.parse_args()

    menge = json.loads(MENGE.read_text(encoding="utf-8"))["klauseln"]
    zeilen = {r["klausel"]: r for r in json.loads(REGISTER.read_text(encoding="utf-8"))["zeilen"]}
    pflege = json.loads(PFLEGE.read_text(encoding="utf-8"))

    neu, belegt, unbekannt = {}, [], []
    for klausel in menge:
        if klausel not in zeilen:
            unbekannt.append(klausel)
            continue
        # Der Bestand entscheidet, nicht die Pflegeliste: das Register fuehrt
        # beide Quellen zusammen.
        vorhanden = (zeilen[klausel]["eigentuemer"].strip()
                     or pflege.get(klausel, {}).get("eigentuemer", "").strip())
        if vorhanden:
            belegt.append(klausel)
            continue
        neu[klausel] = AUFTRAGGEBER if klausel.startswith("K17-") else AUFTRAGNEHMER

    print(f"M5-Klausellage    {len(menge)}")
    print(f"neu zugeordnet    {len(neu)}  "
          f"(davon K17 an den Auftraggeber: {sum(1 for k in neu if k.startswith('K17-'))})")
    print(f"schon belegt      {len(belegt)}  {' '.join(belegt)}")
    if unbekannt:
        print(f"NICHT IM REGISTER {len(unbekannt)}  {' '.join(unbekannt)}")
        return 2

    if not a.schreiben:
        print("\nProbelauf - nichts geschrieben. Mit --schreiben eintragen.")
        return 0

    for klausel, wert in neu.items():
        pflege.setdefault(klausel, {})["eigentuemer"] = wert
    PFLEGE.write_text(json.dumps(pflege, ensure_ascii=False, indent=1) + "\n", encoding="utf-8")
    print(f"\n{PFLEGE} geschrieben - {len(pflege)} Zeilen.")
    return 0


if __name__ == "__main__":
    sys.exit(main())
