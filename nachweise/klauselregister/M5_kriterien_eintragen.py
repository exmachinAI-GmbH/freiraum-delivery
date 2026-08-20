#!/usr/bin/env python3
"""Traegt die M5-Kriteriumsvorschlaege additiv in pflege.json ein.

    python3 nachweise/klauselregister/M5_kriterien_eintragen.py \
        --quelle <ergebnis.json> [--schreiben]

Ohne --schreiben wird nur gerechnet und gemeldet; die Datei bleibt unberuehrt.

WARUM EIN EIGENES SKRIPT UND NICHT pflege_erzeugen.py
    pflege_erzeugen.py ERZEUGT die Datei neu aus 15 hartkodierten Klauseln und
    traegt einen /Users/mveil-Pfad. Ein Lauf davon wuerde die 140 Vorschlaege der
    E-6-Runde vom 16.08.2026 loeschen. Dieses Skript schreibt nur dazu.

WAS ES VERWEIGERT
    - eine Zelle, die nicht mit der Vorschlagsmarke beginnt und mit dem leeren
      Unterschriftsfeld endet (Hausform, pflege_LIESMICH.md Abschn. "Woran Sie
      einen Vorschlag erkennen"),
    - das Ueberschreiben eines bereits vorhandenen Kriteriums. Die acht Klauseln
      des Teilschnitts, die schon eines tragen, bleiben stehen: ein Vorschlag,
      der auf eine Zeichnung wartet, wird nicht im Vorbeigehen ersetzt,
    - jedes andere Feld. Kritikalitaet und Eigentuemer fasst es nicht an.
"""
import argparse
import json
import sys
from pathlib import Path

HIER = Path(__file__).resolve().parent
PFLEGE = HIER / "pflege.json"
MARKE = "⟨VORSCHLAG · NICHT GEZEICHNET⟩"
SLOT = "⟨zeichnet: ⟩ ⟨am: ⟩"


def main():
    p = argparse.ArgumentParser()
    p.add_argument("--quelle", required=True,
                   help="JSON: {Klausel: Zellentext}")
    p.add_argument("--schreiben", action="store_true")
    a = p.parse_args()

    neu = json.loads(Path(a.quelle).read_text(encoding="utf-8"))
    pflege = json.loads(PFLEGE.read_text(encoding="utf-8"))

    getragen, abgewiesen, belegt = {}, [], []
    for klausel, zelle in sorted(neu.items()):
        zelle = zelle.strip()
        if not zelle.startswith(MARKE):
            abgewiesen.append((klausel, "beginnt nicht mit der Vorschlagsmarke"))
            continue
        if not zelle.endswith(SLOT):
            abgewiesen.append((klausel, "endet nicht mit dem leeren Unterschriftsfeld"))
            continue
        vorhanden = pflege.get(klausel, {}).get("akzeptanzkriterium", "").strip()
        if vorhanden:
            belegt.append(klausel)
            continue
        getragen[klausel] = zelle

    print(f"vorgelegt        {len(neu)}")
    print(f"eingetragen      {len(getragen)}")
    print(f"schon belegt     {len(belegt)}  {' '.join(belegt) if belegt else ''}")
    print(f"abgewiesen       {len(abgewiesen)}")
    for k, grund in abgewiesen:
        print(f"  ABGEWIESEN {k}: {grund}")

    if not a.schreiben:
        print("\nProbelauf - nichts geschrieben. Mit --schreiben eintragen.")
        return 0
    if abgewiesen:
        print("\nEs wird nichts geschrieben, solange eine Zelle die Hausform bricht.")
        return 2

    for klausel, zelle in getragen.items():
        pflege.setdefault(klausel, {})["akzeptanzkriterium"] = zelle
    PFLEGE.write_text(json.dumps(pflege, ensure_ascii=False, indent=1) + "\n",
                      encoding="utf-8")
    print(f"\n{PFLEGE} geschrieben - {len(pflege)} Zeilen.")
    return 0


if __name__ == "__main__":
    sys.exit(main())
