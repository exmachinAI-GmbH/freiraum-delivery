#!/usr/bin/env python3
"""Blatt 97, Punkt 2 · Wurde in der Konzept-Fabrik geschrieben?

    python3 werkzeuge/konzeptfabrik_unberuehrt.py            pruefen
    python3 werkzeuge/konzeptfabrik_unberuehrt.py --erzeugen  Grundstand aufnehmen

WOZU
    Die deny-Regeln in .claude/settings.json sperren Schreibzugriffe auf die
    Konzept-Fabrik. Sie greifen nach WERKZEUG (Edit, Write, seit Blatt 97
    auch Bash) -- und eine Regel auf die Kommandozeile prueft den BEFEHLSTEXT,
    nicht den Pfad. Wer den Pfad in eine Variable legt, entgeht ihr. Genau so
    ist am 18.08.2026 in config/kanon.yaml geschrieben worden.

    Blatt 97 nennt das "eine halbe Schranke" und diese Pruefung "die Haelfte,
    die wirklich traegt": Sie verhindert nichts. Sie STELLT FEST -- und zwar
    unabhaengig davon, mit welchem Werkzeug geschrieben wurde.

WAS SIE MISST
    Die Pruefsumme jeder Datei, von der der Harness abhaengt, gegen einen
    aufgenommenen Grundstand (nachweise/konzeptfabrik/grundstand.sha256).
    Weicht eine ab, ist in der Konzept-Fabrik geschrieben worden -- vom
    Harness oder von einem Menschen. WELCHES von beiden, sagt sie nicht;
    das steht in den Blaettern.

DIE GRENZE, und sie ist gross
    Die Konzept-Fabrik liegt in einer Dropbox, nicht im Repo. In GitHub
    Actions ist sie NICHT ERREICHBAR -- dort meldet diese Pruefung GESPERRT
    und laeuft weiter. Sie traegt also nur auf dem Rechner, auf dem gebaut
    wird.

    Das ist keine Nachlaessigkeit, sondern die Lage: Ein Nachweis ueber eine
    Datei, die der Lauf nicht sehen kann, waere eine Behauptung. Nach
    K23-M22 heisst das GESPERRT, nicht bestanden.

WAS EINE ABWEICHUNG BEDEUTET
    Nicht zwangslaeufig einen Verstoss. M. Veil aendert die Konzept-Fabrik
    regelmaessig und darf das -- er ist ihr Eigentuemer. Eine Abweichung
    heisst: der Grundstand ist ueberholt und gehoert neu aufgenommen, ODER
    hier hat jemand geschrieben, der es nicht durfte. Die Pruefung nennt die
    Datei; entscheiden muss ein Mensch.
"""
import hashlib
import os
import sys
from pathlib import Path

WURZEL = Path(__file__).resolve().parent.parent
GRUNDSTAND = WURZEL / "nachweise" / "konzeptfabrik" / "grundstand.sha256"

# Die Dateien, von denen der Harness wirklich abhaengt. Bewusst kurz: Was
# hier steht, muss gepflegt werden. Eine Liste, die alles fuehrt, wird nicht
# gepflegt und meldet dann staendig falsch.
BEOBACHTET = [
    "config/kanon.yaml",
    "CLAUDE.md",
    "quellen/build-inventar.md",
    "03_KONZEPTE_v2.9/concepts-md/260801_FREIRAUM_K19_Build-Referenz_v1.3.md",
]

# Die Konzept-Fabrik. Ueberschreibbar, damit der Pfad nicht in der Datei
# festbrennt -- er ist auf jedem Rechner ein anderer.
VORGABE = (
    "~/Library/CloudStorage/Dropbox-exmachinAI/Team-Ordner exmachinAI/"
    "02_exmachinAI_GmbH/02_Projekte/01_AEGIRA _AI_TRUST_PLATFORM/50_APPS/"
    "30_FREIRAUM/10_KNOWLEDGE_REPO/ITERATION_2/02_AGENT_HARNESS_KONZEPTE/"
    "ITERATION_2"
)


def fabrik():
    return Path(os.environ.get("FREIRAUM_KONZEPTFABRIK", VORGABE)).expanduser()


def summe(pfad):
    h = hashlib.sha256()
    with pfad.open("rb") as f:
        for stueck in iter(lambda: f.read(65536), b""):
            h.update(stueck)
    return h.hexdigest()


def sammeln():
    """Gibt (gefunden, fehlend) -- gefunden ist {relpfad: summe}."""
    w = fabrik()
    gefunden, fehlend = {}, []
    for rel in BEOBACHTET:
        p = w / rel
        if p.is_file():
            gefunden[rel] = summe(p)
        else:
            fehlend.append(rel)
    return gefunden, fehlend


def erzeugen():
    w = fabrik()
    if not w.is_dir():
        print(f"::error::Konzept-Fabrik nicht erreichbar: {w}")
        return 1
    gefunden, fehlend = sammeln()
    if not gefunden:
        print("::error::keine der beobachteten Dateien gefunden — "
              "nichts aufzunehmen")
        return 1
    GRUNDSTAND.parent.mkdir(parents=True, exist_ok=True)
    zeilen = [
        "# Grundstand der Konzept-Fabrik · Blatt 97, Punkt 2",
        "#",
        "# Aufgenommen, damit ein spaeterer Lauf feststellen kann, ob dort",
        "# geschrieben wurde. Eine Abweichung ist KEIN Verstoss an sich --",
        "# M. Veil aendert die Konzept-Fabrik und darf das. Sie heisst nur:",
        "# hier ist etwas passiert, sieh nach.",
        "#",
        "# Neu aufnehmen mit:",
        "#   python3 werkzeuge/konzeptfabrik_unberuehrt.py --erzeugen",
        "",
    ]
    zeilen += [f"{s}  {rel}" for rel, s in sorted(gefunden.items())]
    for rel in fehlend:
        zeilen.append(f"# NICHT GEFUNDEN  {rel}")
    GRUNDSTAND.write_text("\n".join(zeilen) + "\n", encoding="utf-8")
    print(f"Grundstand aufgenommen: {len(gefunden)} Datei(en) "
          f"-> {GRUNDSTAND.relative_to(WURZEL)}")
    for rel in fehlend:
        print(f"::warning::nicht gefunden, nicht aufgenommen: {rel}")
    return 0


def pruefen():
    if not GRUNDSTAND.is_file():
        print(f"::warning::GESPERRT — {GRUNDSTAND.relative_to(WURZEL)} fehlt. "
              f"Ohne Grundstand ist nichts zu vergleichen (K23-M22).")
        print("     Aufnehmen mit: python3 werkzeuge/"
              "konzeptfabrik_unberuehrt.py --erzeugen")
        return 0

    w = fabrik()
    if not w.is_dir():
        # Der Regelfall in GitHub Actions. Kein Fehler -- eine Grenze.
        print(f"::warning::GESPERRT — die Konzept-Fabrik ist hier nicht "
              f"erreichbar ({w}).")
        print("     Diese Pruefung traegt nur auf dem Rechner, auf dem "
              "gebaut wird (Blatt 97, Punkt 2).")
        return 0

    erwartet = {}
    for zeile in GRUNDSTAND.read_text(encoding="utf-8").splitlines():
        if not zeile.strip() or zeile.startswith("#"):
            continue
        s, _, rel = zeile.partition("  ")
        erwartet[rel.strip()] = s.strip()

    gefunden, fehlend = sammeln()
    abweichung, verschwunden = [], []
    for rel, soll in erwartet.items():
        ist = gefunden.get(rel)
        if ist is None:
            verschwunden.append(rel)
        elif ist != soll:
            abweichung.append(rel)
    neu = [r for r in gefunden if r not in erwartet]

    for rel in abweichung:
        print(f"::error::VERAENDERT: {rel}")
    for rel in verschwunden:
        print(f"::error::VERSCHWUNDEN: {rel}")
    for rel in neu:
        print(f"::warning::nicht im Grundstand gefuehrt: {rel}")
    for rel in fehlend:
        if rel not in verschwunden:
            print(f"::warning::nicht gefunden: {rel}")

    print(f"\nKonzept-Fabrik: {len(erwartet)} Datei(en) im Grundstand · "
          f"{len(abweichung)} veraendert · {len(verschwunden)} verschwunden")

    if abweichung or verschwunden:
        print("::error::In der Konzept-Fabrik ist seit dem Grundstand "
              "geschrieben worden.")
        print("     Das ist NICHT zwangslaeufig ein Verstoss: der Eigentuemer")
        print("     darf sie aendern. Zu klaeren ist, WER geschrieben hat.")
        print("     War es der Eigentuemer, den Grundstand neu aufnehmen.")
        return 1
    print("Unberuehrt seit dem Grundstand.")
    return 0


if __name__ == "__main__":
    sys.exit(erzeugen() if "--erzeugen" in sys.argv[1:] else pruefen())
