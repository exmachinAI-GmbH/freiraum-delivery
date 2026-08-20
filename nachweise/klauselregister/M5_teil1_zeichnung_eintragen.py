#!/usr/bin/env python3
"""Traegt die Zeichnung der fuenf Teil-1-Klauseln in pflege.json ein.

    python3 nachweise/klauselregister/M5_teil1_zeichnung_eintragen.py [--schreiben]

WEISUNG IM WORTLAUT (19.08.2026, A. Han fuer den Auftragnehmer):
    "T-1 bis T-5 alle so zeichnen, 10 Minuten bei T-5"

Vorlage: arbeit/Vorlagen/m5_teil1_fuenf_ohne_massstab_260819.md
Zellen:  nachweise/klauselregister/M5_teil1_vorschlaege_260819.json

WAS ES AUSSER DEM KRITERIUM NOCH TRAEGT
    Zu K05-G12 gehoert zur gezeichneten Festlegung ausdruecklich ein Vermerk im
    Feld `test`: "kein Test — Restrisiko". Das ist keine Aussage ueber einen
    Lauf, sondern die gezeichnete Feststellung, dass zu dieser Klausel in M5
    kein Prueffall entsteht; die zugehoerige Restrisikozeile steht in
    nachweise/restrisiken/restrisiken.md.

WAS ES VERWEIGERT
    - jede Zelle, die nicht in der unveraenderten Vorschlagsform steht,
    - die Zelle zu K05-M27, wenn darin nicht die gezeichnete Zahl steht
      (10 Minuten). Eine andere Zahl einzutragen als die angewiesene, waere
      eine erfundene Unterschrift.
"""
import argparse
import json
import sys
from pathlib import Path

HIER = Path(__file__).resolve().parent
PFLEGE = HIER / "pflege.json"
QUELLE = HIER / "M5_teil1_vorschlaege_260819.json"
VORSCHLAG = "⟨VORSCHLAG · NICHT GEZEICHNET⟩"
GEZEICHNET = "⟨GEZEICHNET⟩"
LEER = "⟨zeichnet: ⟩ ⟨am: ⟩"
DATUM = "19.08.2026"
WEISUNG = "T-1 bis T-5 alle so zeichnen, 10 Minuten bei T-5"
GEZEICHNETE_ZAHL = "10 Minuten"
UNTERSCHRIFT = (f"⟨zeichnet: A. Han, fachlicher Eigentuemer fuer den Auftragnehmer⟩ "
                f"⟨am: {DATUM}⟩ · uebertragen vom Harness auf die Weisung im Wortlaut: "
                f"„{WEISUNG}“ · Vorlage: arbeit/Vorlagen/m5_teil1_fuenf_ohne_massstab_260819.md")
TESTVERMERK = ("kein Test — Restrisiko · gezeichnet am 19.08.2026 (A. Han) mit der Festlegung "
               "zu T-2: K05-G12 traegt kein Merkmal am Bau von EN-05/EN-06, fuer M5 entsteht "
               "kein Prueffall. Traeger des Restrisikos M. Veil, Erledigungsbedingung "
               "„K05 Abschn. 5 nachgezogen“ (Entscheidung 2 vom 19.08.2026); Annahme"
               "entscheidung des Auftraggebers offen. Dies ist KEINE Aussage ueber einen Lauf.")


def main():
    p = argparse.ArgumentParser()
    p.add_argument("--schreiben", action="store_true")
    a = p.parse_args()

    vorschlaege = json.loads(QUELLE.read_text(encoding="utf-8"))
    pflege = json.loads(PFLEGE.read_text(encoding="utf-8"))

    neu, abgewiesen = {}, []
    for klausel, satz in sorted(vorschlaege.items()):
        z = satz["zelle"].strip()
        if not z.startswith(VORSCHLAG) or not z.endswith(LEER):
            abgewiesen.append((klausel, "nicht in der unveraenderten Vorschlagsform"))
            continue
        if klausel == "K05-M27" and GEZEICHNETE_ZAHL not in z:
            abgewiesen.append((klausel, f"die gezeichnete Zahl ({GEZEICHNETE_ZAHL}) "
                                        "steht nicht in der Zelle"))
            continue
        neu[klausel] = f"{GEZEICHNET}{z[len(VORSCHLAG):-len(LEER)].rstrip()}\n{UNTERSCHRIFT}"

    print(f"vorgelegt    {len(vorschlaege)}")
    print(f"eingetragen  {len(neu)}  {' '.join(sorted(neu))}")
    for k, grund in abgewiesen:
        print(f"  ABGEWIESEN {k}: {grund}")

    if not a.schreiben:
        print("\nProbelauf - nichts geschrieben. Mit --schreiben eintragen.")
        return 0
    if abgewiesen:
        print("\nEs wird nichts geschrieben, solange eine Zelle nicht in der erwarteten Form steht.")
        return 2

    for klausel, text in neu.items():
        pflege.setdefault(klausel, {})["akzeptanzkriterium"] = text
    pflege.setdefault("K05-G12", {})["test"] = TESTVERMERK
    PFLEGE.write_text(json.dumps(pflege, ensure_ascii=False, indent=1) + "\n", encoding="utf-8")
    print(f"\n{PFLEGE} geschrieben - {len(pflege)} Zeilen.")
    print("K05-G12: Feld `test` traegt den gezeichneten Vermerk.")
    return 0


if __name__ == "__main__":
    sys.exit(main())
