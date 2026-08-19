#!/usr/bin/env python3
"""Traegt die Zeichnung der sechs K17-Klauseln der M5-Klausellage ein.

    python3 nachweise/klauselregister/M5_k17_zeichnung_eintragen.py [--schreiben]

WEISUNG IM WORTLAUT (19.08.2026):
    "hiermit alles freigezeichnet, setze um was fehlt, lege ggf. Handlungsempfehlung
     zur Zeichnung vor, fuehre PR aus."

WER HIER ZEICHNET
    Fachlicher Eigentuemer der sechs K17-Klauseln ist nach der Zuweisung vom
    19.08.2026 **M. Veil** (Grundlage: Bauauftrag §7a, L4 — "Eigentuemer:
    Auftragnehmer, fachliche Freigabe M. Veil"; so schon am 16.08.2026 fuer
    K15 und K17 gezeichnet). Die Weisung oben ist am Harness von A. Han
    erteilt worden und umfasst nach ihrem Wortlaut alles Offene.

    DER HARNESS ERFINDET KEINE UNTERSCHRIFT: er traegt ein, was angewiesen ist,
    nennt den Wortlaut der Weisung und haelt fest, dass sie in einem Satz und
    ohne Aufteilung nach Personen erteilt wurde. Wer sie enger gemeint hat,
    streicht die betroffene Zeile — die Aenderung ist an dieser Stelle sichtbar
    und nicht im Bestand verstreut.

BESONDERHEIT K17-D13
    Diese Klausel traegt ein Kriterium vom 16.08.2026 aus dem Anmelde-Teilschnitt.
    Die Gegenprobe vom 19.08. hat es fuer M5 als zu eng befunden und einen
    Ersatztext geliefert. Der alte Eintrag bleibt woertlich stehen; der neue
    haengt sich als ERGAENZUNG an, wie bei den vier Klauseln aus Teil 2.
"""
import argparse
import json
import sys
from pathlib import Path

HIER = Path(__file__).resolve().parent
PFLEGE = HIER / "pflege.json"
VORSCHLAG = "⟨VORSCHLAG · NICHT GEZEICHNET⟩"
GEZEICHNET = "⟨GEZEICHNET⟩"
LEER = "⟨zeichnet: ⟩ ⟨am: ⟩"
DATUM = "19.08.2026"
WEISUNG = ("hiermit alles freigezeichnet, setze um was fehlt, lege ggf. Handlungsempfehlung "
           "zur Zeichnung vor, fuehre PR aus")
UNTERSCHRIFT = (f"⟨zeichnet: M. Veil, fachlicher Eigentuemer K17 (Bauauftrag §7a, L4 — fachliche "
                f"Freigabe M. Veil)⟩ ⟨am: {DATUM}⟩ · uebertragen vom Harness auf die Weisung im "
                f"Wortlaut: „{WEISUNG}“, erteilt am Harness von A. Han in einem Satz und ohne "
                f"Aufteilung nach Personen · Sichtblatt: nachweise/klauselregister/"
                "M5_zeichnung_A-Han_260819.md (dort als M. Veils Anteil ausgewiesen)")


def main():
    p = argparse.ArgumentParser()
    p.add_argument("--schreiben", action="store_true")
    a = p.parse_args()

    reg = {r["klausel"]: r for r in json.loads((HIER / "register.json").read_text("utf-8"))["zeilen"]}
    pflege = json.loads(PFLEGE.read_text(encoding="utf-8"))
    menge = json.loads((HIER / "M5_klausellage_260819.json").read_text("utf-8"))["klauseln"]
    nachtrag = json.loads((HIER / "M5_ergaenzungen_nachtrag10_260819.json").read_text("utf-8"))

    k17 = [k for k in menge if k.startswith("K17-")]
    neu, abgewiesen = {}, []
    for k in k17:
        z = (pflege.get(k, {}).get("akzeptanzkriterium") or reg[k]["akzeptanzkriterium"]).strip()
        if not z.startswith(VORSCHLAG) or not z.endswith(LEER):
            abgewiesen.append((k, "nicht in der unveraenderten Vorschlagsform"))
            continue
        kern = z[len(VORSCHLAG):-len(LEER)].rstrip()
        erg = (nachtrag.get(k) or {}).get("vorschlag", "").strip()
        if erg:
            erg = erg.replace(VORSCHLAG, "").strip()
            if erg.endswith(LEER):
                erg = erg[:-len(LEER)].rstrip().rstrip("·").rstrip()
            kern = f"{kern}\nERGAENZUNG FUER M5, mitgezeichnet: {erg}"
        neu[k] = f"{GEZEICHNET}{kern}\n{UNTERSCHRIFT}"

    print(f"K17 in der M5-Klausellage  {len(k17)}  {' '.join(k17)}")
    print(f"eingetragen                {len(neu)}  (davon mit Ergaenzung: "
          f"{sum(1 for k in neu if k in nachtrag)})")
    for k, grund in abgewiesen:
        print(f"  ABGEWIESEN {k}: {grund}")

    if not a.schreiben:
        print("\nProbelauf - nichts geschrieben. Mit --schreiben eintragen.")
        return 0
    if abgewiesen:
        print("\nEs wird nichts geschrieben, solange eine Zelle nicht in der erwarteten Form steht.")
        return 2

    for k, t in neu.items():
        pflege.setdefault(k, {})["akzeptanzkriterium"] = t
    PFLEGE.write_text(json.dumps(pflege, ensure_ascii=False, indent=1) + "\n", encoding="utf-8")
    print(f"\n{PFLEGE} geschrieben - {len(pflege)} Zeilen.")
    return 0


if __name__ == "__main__":
    sys.exit(main())
