#!/usr/bin/env python3
"""Traegt die erteilte Zeichnung der M5-Akzeptanzkriterien in pflege.json ein.

    python3 nachweise/klauselregister/M5_zeichnung_eintragen.py [--schreiben]

WEISUNG IM WORTLAUT (19.08.2026, A. Han fuer den Auftragnehmer):
    "Teil 2 und Teil 3 alle zeichnen, mache Handlungsempfehlungen zu Teil 1,
     die ich zeichnen kann"

Gezeichnet werden damit die Teile 2 und 3 des Sichtblattes
`M5_zeichnung_A-Han_260819.md` -- 90 der 95 Klauseln, die A. Han gehoeren.
Teil 1 (fuenf Klauseln ohne Massstab) bleibt ausdruecklich UNGEZEICHNET; dazu
liegt eine eigene Vorlage vor.

WAS DER EINTRAG AENDERT
    - die Marke am Anfang der Zelle: aus "VORSCHLAG · NICHT GEZEICHNET" wird
      "GEZEICHNET",
    - das leere Unterschriftsfeld am Ende: aus "zeichnet: / am:" wird der Name
      und das Datum, dazu die Weisung, auf der die Uebertragung beruht,
    - bei den vier Klauseln aus Teil 2 kommt die M5-Ergaenzung IN DIE ZELLE.
      Der alte Eintrag bleibt woertlich stehen; die Ergaenzung haengt sich an,
      wie es das Sichtblatt zeigt.

WAS ES VERWEIGERT
    - jede Zelle, die nicht die Vorschlagsmarke traegt (schon gezeichnet oder
      von Hand veraendert),
    - jede Klausel aus Teil 1,
    - jede Klausel, die nicht A. Han gehoert (K17 liegt bei M. Veil).

    Der Harness setzt keine Unterschrift. Er traegt eine erteilte ein -- mit dem
    Wortlaut der Weisung daneben (CLAUDE.md Abschn. 6).
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
NAME = "A. Han"
DATUM = "19.08.2026"
WEISUNG = ("Teil 2 und Teil 3 alle zeichnen, mache Handlungsempfehlungen zu Teil 1, "
           "die ich zeichnen kann")
UNTERSCHRIFT = (f"⟨zeichnet: {NAME}, fachlicher Eigentuemer fuer den Auftragnehmer⟩ "
                f"⟨am: {DATUM}⟩ · uebertragen vom Harness auf die Weisung im Wortlaut: "
                f"„{WEISUNG}“ · Sichtblatt: nachweise/klauselregister/"
                "M5_zeichnung_A-Han_260819.md, Teile 2 und 3")


def lies(name):
    return json.loads((HIER / name).read_text(encoding="utf-8"))


def main():
    p = argparse.ArgumentParser()
    p.add_argument("--schreiben", action="store_true")
    a = p.parse_args()

    reg = {r["klausel"]: r for r in lies("register.json")["zeilen"]}
    pflege = lies("pflege.json")
    menge = lies("M5_klausellage_260819.json")["klauseln"]
    ergaenzungen = lies("M5_ergaenzungen_bestand_260819.json")

    def zelle(k):
        return (pflege.get(k, {}).get("akzeptanzkriterium")
                or reg[k]["akzeptanzkriterium"]).strip()

    def eigner(k):
        return (pflege.get(k, {}).get("eigentuemer") or reg[k]["eigentuemer"]).strip()

    meine = [k for k in menge if eigner(k).startswith("Auftragnehmer")]
    teil1 = [k for k in meine if "NICHT ABLEITBAR" in zelle(k)]
    zu_zeichnen = [k for k in meine if k not in teil1]

    neu, abgewiesen = {}, []
    for k in zu_zeichnen:
        t = zelle(k)
        if not t.startswith(VORSCHLAG) or not t.endswith(LEER):
            abgewiesen.append((k, "traegt nicht die unveraenderte Vorschlagsform"))
            continue
        t = t[:-len(LEER)].rstrip()
        erg = (ergaenzungen.get(k) or {}).get("ergaenzung", "").strip()
        if erg:
            erg = erg.replace(VORSCHLAG, "").strip()
            if erg.endswith(LEER):
                erg = erg[:-len(LEER)].rstrip().rstrip("·").rstrip()
            t = f"{t}\nERGAENZUNG FUER M5, mitgezeichnet: {erg}"
        neu[k] = f"{GEZEICHNET}{t[len(VORSCHLAG):]}\n{UNTERSCHRIFT}"

    print(f"A. Han gehoeren      {len(meine)}")
    print(f"Teil 1, bleibt offen {len(teil1)}  {' '.join(teil1)}")
    print(f"zu zeichnen          {len(zu_zeichnen)}")
    print(f"eingetragen          {len(neu)}  (davon mit Ergaenzung: "
          f"{sum(1 for k in neu if k in ergaenzungen and not ergaenzungen[k]['traegt_fuer_m5'])})")
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
