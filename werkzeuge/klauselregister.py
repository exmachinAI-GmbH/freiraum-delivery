#!/usr/bin/env python3
"""FREIRAUM Coding-Harness - Klauselregister nach K23-M02.

Deterministischer Extraktor, kein Compiler. Er zieht die Klauseln (K##-M##, -D##, -G##)
aus den gezeichneten Konzepten und erzeugt je Klausel EINE Zeile mit den zehn Feldern aus
K23-M02. Er erfindet nichts: die sieben nicht ableitbaren Felder kommen aus der Pflegedatei
oder bleiben leer - und leer wird ausgewiesen, nicht verschwiegen.

K22 wird nicht aufgenommen (F28; Bauauftrag Abschn. 1 und 8).
ACHTUNG - Widerspruch, hier nicht aufgeloest: K23-M01 verlangt woertlich eine Zeile fuer
jede Klausel der Konzepte "K00 bis K23 und K25" und erfasst damit auch K22. F28 steht in
der Rangfolge auf Rang 0 und nimmt K22 von Freigabe und Export aus. Das Werkzeug folgt
Rang 0 und weist K22 unter "gesperrt" aus, statt die Zeilen still wegzulassen.

K24 ist nicht vergeben (K23-M01, Beschluss S27).

Die JSON-Datei ist das Register. Die Markdown-Datei ist nur eine lesbare Sicht darauf
(ohne Wortlaut, weil Klauseltexte Tabellenzeichen enthalten).

  python3 werkzeuge/klauselregister.py --konzepte <ordner> [--pflege <json>]
                                       [--ziel <json>] [--markdown <md>]
                                       [--stdout] [--streng]
"""
import argparse
import datetime
import json
import re
import sys
from pathlib import Path

FELDER = ["wortlaut", "herkunft", "dokumentversion", "eigentuemer", "kritikalitaet",
          "akzeptanzkriterium", "test", "teststand", "ergebnis", "evidenz"]
GEPFLEGT = FELDER[3:]
ART = {"M": "MUSS", "D": "DARF NICHT", "G": "GILT"}
ERWARTET = [f"K{i:02d}" for i in range(0, 26)]
GESPERRT = {
    "K22": "gesperrt - nicht Gegenstand des Bauauftrags (F28; Bauauftrag Abschn. 1 und 8)",
    "K24": "nicht vergeben (K23-M01, Beschluss S27)",
}
RE_ZEILE = re.compile(r"^\|\s*(K\d{2})-([MDG])(\d{2})\s*\|\s*(.+?)\s*\|\s*$")
RE_VERSION = re.compile(r"^\|\s*Version / Status\s*\|\s*(.+?)\s*\|\s*$")
RE_DATEI = re.compile(r"_FREIRAUM_(K\d{2})_")


def entziere(text):
    return re.sub(r"\*\*|`", "", text).strip()


def lies_konzept(pfad):
    treffer = RE_DATEI.search(pfad.name)
    if not treffer:
        return None, "", []
    kid, version, zeilen = treffer.group(1), "", []
    for nr, zeile in enumerate(pfad.read_text(encoding="utf-8").splitlines(), 1):
        if not version:
            v = RE_VERSION.match(zeile)
            if v:
                version = entziere(v.group(1))
        m = RE_ZEILE.match(zeile)
        if m and m.group(1) == kid:
            zeilen.append({
                "klausel": f"{kid}-{m.group(2)}{m.group(3)}",
                "konzept": kid,
                "art": ART[m.group(2)],
                "wortlaut": m.group(4),
                "herkunft": f"{pfad.name}:{nr}",
            })
    return kid, version, zeilen


def sammle(ordner):
    zeilen, konzepte, befunde, gesehen = [], {}, [], {}
    for pfad in sorted(Path(ordner).glob("*.md")):
        kid, version, roh = lies_konzept(pfad)
        if kid is None:
            continue
        if kid in GESPERRT:
            befunde.append(f"{pfad.name}: {kid} ist {GESPERRT[kid]} - nicht aufgenommen")
            continue
        if kid in konzepte:
            befunde.append(f"{pfad.name}: zweite Fassung zu {kid} - uebersprungen, "
                           f"es gilt {konzepte[kid]['datei']}")
            continue
        konzepte[kid] = {"datei": pfad.name, "dokumentversion": version,
                         "klauseln": len(roh)}
        if not version:
            befunde.append(f"{pfad.name}: Feld 'Version / Status' nicht gefunden - "
                           f"Dokumentversion bleibt leer (K23-M02)")
        for z in roh:
            if z["klausel"] in gesehen:
                befunde.append(f"{z['klausel']}: doppelt vergeben ({gesehen[z['klausel']]} "
                               f"und {z['herkunft']})")
                continue
            gesehen[z["klausel"]] = z["herkunft"]
            z["dokumentversion"] = version
            for feld in GEPFLEGT:
                z[feld] = ""
            zeilen.append(z)
    for kid in ERWARTET:
        if kid in GESPERRT or kid in konzepte:
            continue
        befunde.append(f"{kid}: keine Konzeptdatei gefunden - Klauseln fehlen im Register "
                       f"(K23-M01)")
    zeilen.sort(key=lambda z: (z["konzept"], z["art"], z["klausel"]))
    return zeilen, konzepte, befunde


def pflege_anwenden(zeilen, pfad, befunde):
    daten = json.loads(Path(pfad).read_text(encoding="utf-8"))
    nach_id = {z["klausel"]: z for z in zeilen}
    for klausel, werte in sorted(daten.items()):
        ziel = nach_id.get(klausel)
        if ziel is None:
            befunde.append(f"Pflegeeintrag {klausel}: keine solche Klausel im Bestand")
            continue
        for feld, wert in werte.items():
            if feld not in GEPFLEGT:
                befunde.append(f"Pflegeeintrag {klausel}: Feld '{feld}' ist nicht "
                               f"pflegbar - abgelehnt")
                continue
            ziel[feld] = str(wert)


def zaehle(zeilen):
    leer = {feld: sum(1 for z in zeilen if not z[feld]) for feld in FELDER}
    return {
        "klauseln": len(zeilen),
        "leere_felder": leer,
        "ohne_akzeptanzkriterium": leer["akzeptanzkriterium"],
        "ohne_test": leer["test"],
        "vollstaendige_zeilen": sum(1 for z in zeilen if all(z[f] for f in FELDER)),
    }


def als_markdown(register):
    kopf = ("| Klausel | Art | Dokumentversion | Eigentuemer | Kritikalitaet | "
            "Akzeptanzkriterium | Test | Teststand | Ergebnis | Evidenz | Herkunft |")
    zeilen = ["# Klauselregister nach K23-M02 - lesbare Sicht", "",
              f"Erzeugt: {register['erzeugt']} - {register['zaehlung']['klauseln']} Klauseln",
              "", kopf, "|" + "---|" * 11]
    for z in register["zeilen"]:
        felder = [(z[f] or "- leer -").replace("|", "\\|") for f in
                  ("dokumentversion", "eigentuemer", "kritikalitaet",
                   "akzeptanzkriterium", "test", "teststand", "ergebnis", "evidenz")]
        zeilen.append("| " + " | ".join([z["klausel"], z["art"], *felder,
                                         z["herkunft"]]) + " |")
    return "\n".join(zeilen) + "\n"


def main(argv=None):
    p = argparse.ArgumentParser(description="Klauselregister nach K23-M02")
    p.add_argument("--konzepte", required=True)
    p.add_argument("--pflege")
    p.add_argument("--ziel")
    p.add_argument("--markdown")
    p.add_argument("--stdout", action="store_true")
    p.add_argument("--streng", action="store_true",
                   help="Rueckgabewert 1, wenn ein Akzeptanzkriterium fehlt (K23-M02)")
    a = p.parse_args(argv)

    zeilen, konzepte, befunde = sammle(a.konzepte)
    if a.pflege and Path(a.pflege).is_file():
        pflege_anwenden(zeilen, a.pflege, befunde)
    elif a.pflege:
        befunde.append(f"Pflegedatei {a.pflege} nicht gefunden - alle sieben pflegbaren "
                       f"Felder bleiben leer")
    register = {
        "erzeugt": datetime.datetime.now(datetime.timezone.utc).isoformat(timespec="seconds"),
        "quelle": str(Path(a.konzepte).resolve()),
        "konzepte": konzepte,
        "gesperrt": GESPERRT,
        "zaehlung": zaehle(zeilen),
        "befunde": befunde,
        "zeilen": zeilen,
    }
    text = json.dumps(register, ensure_ascii=False, indent=2, sort_keys=False)
    if a.ziel:
        Path(a.ziel).parent.mkdir(parents=True, exist_ok=True)
        Path(a.ziel).write_text(text + "\n", encoding="utf-8")
    if a.markdown:
        Path(a.markdown).parent.mkdir(parents=True, exist_ok=True)
        Path(a.markdown).write_text(als_markdown(register), encoding="utf-8")
    if a.stdout or not (a.ziel or a.markdown):
        print(text)
    z = register["zaehlung"]
    print(f"{z['klauseln']} Klauseln - ohne Akzeptanzkriterium: "
          f"{z['ohne_akzeptanzkriterium']} - ohne Test: {z['ohne_test']} - "
          f"Befunde: {len(befunde)}", file=sys.stderr)
    for b in befunde:
        print(f"  BEFUND {b}", file=sys.stderr)
    return 1 if (a.streng and z["ohne_akzeptanzkriterium"]) else 0


if __name__ == "__main__":
    sys.exit(main())
