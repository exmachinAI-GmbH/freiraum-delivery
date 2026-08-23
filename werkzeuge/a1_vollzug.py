#!/usr/bin/env python3
# umsetzt: A-1 · BEF-A1-1 · §12.4 Nr. 2, Nr. 4, Nr. 5 · K23-M22
"""FREIRAUM · A-1 — Arbeitsliste vor dem Vollzug, Nachprüfung danach.

    python3 werkzeuge/a1_vollzug.py --plan
    python3 werkzeuge/a1_vollzug.py --pruefen <auftragstext.md>

WOZU. A-1 sind 25 Eintragungen von Hand in einem Dokument, das außerhalb dieses
Bestandes liegt. Zwei Dinge daran sind gefährlich, und gegen beide ist dieses
Werkzeug gebaut:

  1. AB DER ZEICHNUNG VON BA-1/BA-2 IST KEINE VORLAGE ZUR FREIGABE MEHR ZULÄSSIG,
     bis die letzte der 25 Stellen sitzt (§12.4 Nr. 5). Wer mittendrin aufhört,
     hält das ganze Vorhaben an. `--plan` verkürzt das Fenster auf das reine
     Eintragen: Reihenfolge, Suchzeichenfolge, Platzhalter — alles vorab.

  2. EIN STEHENGEBLIEBENER PLATZHALTER IST EIN NICHTVOLLZUG (§12.4 Nr. 4). Fünf
     der Stellen tragen einen. `--pruefen` findet sie, bevor es jemand anders tut.

EINE QUELLE, KEINE KOPIE. Beide Betriebsarten lesen das Vollzugsheft selbst
(`arbeit/Vorlagen/vollzugsheft_25_stellen_260820.md`). Eine zweite Liste der
Wortlaute wäre eine Kopie, die driftet — und die Stelle, an der zwei Fassungen
auseinandergehen, ist genau die, die niemand bemerkt.

WAS ES NICHT TUT. Es trägt nichts ein. In die Konzept-Fabrik schreibt ein Mensch
(CLAUDE.md Abschn. 6, Schreibsperre in .claude/settings.json). Und es prüft NICHT,
ob alte Wortlaute verschwunden sind: Einige Stellen ERSETZEN, andere HÄNGEN AN
(Stelle 13 zum Beispiel). Diese Unterscheidung steht nur im Fließtext des Heftes
und wird hier nicht geraten — wer sie automatisch behandelt, meldet irgendwann
falsch grün.

RÜCKGABEWERTE:
    0  alle 25 neuen Wortlaute gefunden, kein Platzhalter offen
    1  gemessen, und es fehlt etwas
    2  GESPERRT — nichts gemessen (Heft oder Auftragstext nicht lesbar)
"""
import argparse
import hashlib
import re
import sys
import unicodedata
from pathlib import Path

HEFT = Path(__file__).resolve().parent.parent / "arbeit/Vorlagen/vollzugsheft_25_stellen_260820.md"

# Vier Anker stehen im Heft anders, als sie im Auftrag stehen — Fettung, ein
# Umbruch im Blockzitat, eine Auslassung. Gemessen am 23.08.2026 gegen
# 03_N5_BAUAUFTRAG_v1.1_260807.md, je genau ein Treffer (BEF-A1-1 Abschn. 3).
ERSATZANKER = {
    "2.1-S8": ("Umbruch im Blockzitat", "Kein Meilenstein trägt ein eigenes Datum"),
    "2.2-S1": ("Fettung nur im Heft", "L1-Vermerk zu `login_attempt` und `nummernvorrat`"),
    "2.2-S2": ("Fettung nur im Heft",
               "Der Nachweis gehört zur L1-Abnahme; die Inventur führt beide als GLOBAL"),
    "2.2-S4": ("Auslassung „…“ im Heft",
               "und `nummernvorrat` (ein Zähler trägt keine Mandantenzeile)"),
}


def normal(s):
    s = unicodedata.normalize("NFC", s).replace(" ", " ")
    return re.sub(r"\s+", " ", s)


def heft_lesen():
    if not HEFT.is_file():
        print(f"GESPERRT · {HEFT} fehlt — nichts gemessen.", file=sys.stderr)
        raise SystemExit(2)
    text = HEFT.read_text(encoding="utf-8")
    stellen = []
    for teil in re.split(r"^### Stelle ", text, flags=re.MULTILINE)[1:]:
        kopf = teil.split("\n", 1)[0]
        nr = kopf.split(" ")[0]
        entfaellt = "ENTFÄLLT" in kopf.upper()
        anker = re.search(r"\*\*Ankerzitat\*\*.*?```\s*\n(.*?)\n```", teil, re.DOTALL)
        neu = re.search(r"\*\*Neuer Wortlaut:?\*\*.*?```\s*\n(.*?)\n```", teil, re.DOTALL)
        hinweis = re.search(r"^> \*\*Zu beachten\.\*\*\s*(.+)$", teil, re.MULTILINE)
        stellen.append({
            "nr": nr,
            "titel": re.sub(r"\s*—\s*\*\*ENTFÄLLT\*\*", "", kopf).strip(),
            "entfaellt": entfaellt,
            "anker": anker.group(1).strip() if anker else None,
            "neu": neu.group(1).strip() if neu else None,
            "hinweis": bool(hinweis),
        })
    return stellen


def suchzeichenfolge(st):
    """Womit der Mensch die Stelle findet — mit den Berichtigungen aus BEF-A1-1."""
    if st["nr"] in ERSATZANKER:
        return ERSATZANKER[st["nr"]][1], ERSATZANKER[st["nr"]][0]
    a = (st["anker"] or "").strip()
    a = re.sub(r"\*\(.*?\)\*\s*$", "", a).strip().lstrip("„").rstrip("“\"")
    return a, None


def plan():
    stellen = heft_lesen()
    zu_tragen = [s for s in stellen if not s["entfaellt"]]
    print("A-1 · Arbeitsliste für den Vollzug")
    print(f"   {len(zu_tragen)} Eintragungen · {sum(1 for s in stellen if s['entfaellt'])} entfällt")
    print("   Reihenfolge JE BLATT VON UNTEN NACH OBEN — so steht die Liste hier.")
    print("   Gefunden wird an der Suchzeichenfolge, NIE an der Zeilennummer.\n")
    for st in stellen:
        marke = "entfällt" if st["entfaellt"] else "        "
        print(f"── Stelle {st['nr']:<8} {marke}  {st['titel'][:64]}")
        if st["entfaellt"]:
            print("     in BA-1 Feld 6 mit *entfällt* abhaken, NICHT eintragen\n")
            continue
        such, grund = suchzeichenfolge(st)
        print(f"     suchen: {such}")
        if grund:
            print(f"     ⚠ berichtigt gegenüber dem Heft ({grund}) — BEF-A1-1")
        for ph in re.findall(r"⟨[^⟩]*⟩", st["neu"] or ""):
            print(f"     ⚠ PLATZHALTER {ph} — ersetzen, sonst Nichtvollzug (§12.4 Nr. 4)")
        if st["hinweis"]:
            print("     ⚠ das Heft führt zu dieser Stelle ein „Zu beachten\" — vorher lesen")
        print("     abhaken mit Datum und Zeichen (§12.4 Nr. 2)\n")
    print("Nach der letzten Stelle:")
    print("  1. als v1.2 ablegen · 2. neue Zeichnungsdatei mit Prüfsumme anlegen")
    print("     (die Prüfsumme steht NIE im Auftrag selbst)")
    print("  3. python3 werkzeuge/a1_vollzug.py --pruefen <die neue Fassung>")
    return 0


def pruefen(pfad):
    p = Path(pfad)
    if not p.is_file():
        print(f"GESPERRT · {pfad} nicht lesbar — nichts gemessen.", file=sys.stderr)
        return 2
    text = p.read_text(encoding="utf-8")
    t = normal(text)
    stellen = [s for s in heft_lesen() if not s["entfaellt"]]

    print(f"A-1 · Nachprüfung gegen {p.name} ({len(text)} Zeichen)\n")
    fehlt, offen = [], []
    for st in stellen:
        if not st["neu"]:
            print(f"   ?  Stelle {st['nr']:<8} das Heft führt keinen neuen Wortlaut")
            continue
        n = t.count(normal(st["neu"]))
        zeichen = "✓" if n >= 1 else "✗"
        if n == 0:
            fehlt.append(st["nr"])
        print(f"   {zeichen}  Stelle {st['nr']:<8} neuer Wortlaut {n}x gefunden")

    for ph in sorted(set(re.findall(r"⟨[^⟩]*⟩", text))):
        offen.append(ph)
        print(f"   ✗  PLATZHALTER steht noch: {ph}")

    print()
    if fehlt:
        print(f"NICHT VOLLZOGEN — {len(fehlt)} neue Wortlaute nicht gefunden: {', '.join(fehlt)}")
    if offen:
        print(f"NICHT VOLLZOGEN — {len(offen)} Platzhalter offen (§12.4 Nr. 4)")
    if not fehlt and not offen:
        print(f"VOLLZOGEN — alle {len(stellen)} neuen Wortlaute stehen, kein Platzhalter offen.")
        print(f"   Prüfsumme dieser Fassung: {hashlib.sha256(p.read_bytes()).hexdigest()}")
        print("   Sie gehört in die Zeichnungsdatei, nie in den Auftrag selbst.")
    print("\n   Was diese Prüfung NICHT sagt: ob alte Wortlaute richtig ersetzt statt")
    print("   angehängt wurden. Einige Stellen ersetzen, andere hängen an — das steht")
    print("   im Fließtext des Heftes und wird hier nicht geraten (K23-M22).")
    return 1 if (fehlt or offen) else 0


def main():
    ap = argparse.ArgumentParser(description="A-1: Arbeitsliste und Nachprüfung. Trägt nichts ein.")
    g = ap.add_mutually_exclusive_group(required=True)
    g.add_argument("--plan", action="store_true", help="die Arbeitsliste vor dem Vollzug")
    g.add_argument("--pruefen", metavar="DATEI", help="die vollzogene Fassung nachprüfen")
    a = ap.parse_args()
    return plan() if a.plan else pruefen(a.pruefen)


if __name__ == "__main__":
    try:
        raise SystemExit(main())
    except BrokenPipeError:
        try:
            sys.stdout.close()
        finally:
            raise SystemExit(2)
