#!/usr/bin/env python3
# =====================================================================
#  Die 25 Vollzugsstellen gegen den Bauauftragstext halten
#
#      python3 vollzug_pruefen.py <pfad zu 03_N5_BAUAUFTRAG_v1.1_260807.md>
#
#  WOZU
#      Von den 25 Ankerzitaten sind im Coding-Harness nur DREI
#      nachpruefbar -- der Auftragstext liegt ausserhalb. Fuer 22 Stellen
#      konnte niemand pruefen, ob der alte Wortlaut dort wirklich so
#      steht. BA-1:479 sagt fuer diesen Fall: NICHT EINTRAGEN, SONDERN
#      FRAGEN.
#
#      Dieses Werkzeug beantwortet die Frage in einem Befehl -- dort, wo
#      der Auftragstext liegt, bevor irgendjemand tippt.
#
#  WAS ES TUT
#      Es sucht je Stelle das Ankerzitat und danach den alten Wortlaut,
#      und meldet je Stelle einen von vier Zustaenden. Beide Vergleiche
#      laufen ZEICHENGENAU; zusaetzlich wird ein zweiter Durchgang mit
#      zusammengezogenen Leerzeichen gefahren, weil ein Blockzitat im
#      Korrekturblatt anders umbrochen sein kann als der Auftrag.
#
#  WAS ES NICHT TUT -- UND DAS IST ABSICHT
#      ES AENDERT NICHTS. Kein Schreibzugriff, keine Ausgabedatei am
#      Ziel. Der Coding-Harness schreibt nicht in die Konzept-Fabrik
#      (CLAUDE.md Abschn. 6, am 18.08.2026 einmal gebrochen, sofort
#      zurueckgenommen und von beiden Foundern bestaetigt -- mit der
#      Auflage, die Uebergabe zu MECHANISIEREN statt sie zu lockern).
#      Dieses Werkzeug ist diese Mechanisierung: es nimmt das Suchen und
#      Vergleichen ab, nicht das Eintragen.
#
#      Es sagt auch NICHT, ob ersetzt, angefuegt oder eingefuegt wird.
#      Das steht je Stelle im Vollzugsheft unter "Zu beachten" und ist
#      nicht ueberall dieselbe Handlung.
# =====================================================================
import json, sys, re, unicodedata
from pathlib import Path

HIER = Path(__file__).resolve().parent
DATEN = HIER / "vollzug_25_stellen.json"

def norm(t):
    """Weichumbrueche und Mehrfachleerzeichen zusammenziehen."""
    t = unicodedata.normalize("NFC", t)
    return re.sub(r"\s+", " ", t).strip()

def zitat_kern(z):
    """Die Anfuehrungszeichen der Blaetter abstreifen."""
    return z.strip().strip("„“\"»«").strip()

def main():
    if len(sys.argv) < 2:
        print(__doc__ or "", file=sys.stderr)
        sys.exit("Aufruf: vollzug_pruefen.py <pfad zum Bauauftragstext>")
    ziel = Path(sys.argv[1])
    if not ziel.is_file():
        sys.exit(f"ABBRUCH: Datei nicht gefunden: {ziel}")

    text = ziel.read_text(encoding="utf-8")
    ntext = norm(text)
    daten = json.loads(DATEN.read_text(encoding="utf-8"))

    gut = frage = entfaellt = 0
    print(f"Bauauftragstext: {ziel}")
    print(f"{len(text.splitlines())} Zeilen · {len(daten['stellen'])} Stellen im Heft\n")

    for s in daten["stellen"]:
        kennung = f"{s['blatt']} Stelle {s['nr']}"
        if not s["aktiv"]:
            print(f"  —  {kennung:22s} ENTFAELLT · nur abhaken")
            entfaellt += 1
            continue

        anker = zitat_kern(s["ankerzitat"])
        alt = s["alter_wortlaut"].strip()

        anker_da = anker in text or norm(anker) in ntext
        alt_da = bool(alt) and (alt in text or norm(alt) in ntext)

        if anker_da and (alt_da or not alt):
            zeichen, wort = "OK ", "Anker und alter Wortlaut gefunden"
            if not alt:
                wort = "Anker gefunden (Einfuegung, kein alter Wortlaut)"
            gut += 1
        elif anker_da and not alt_da:
            zeichen, wort = "!! ", "Anker gefunden, ALTER WORTLAUT NICHT -- fragen (BA-1:479)"
            frage += 1
        else:
            zeichen, wort = "!! ", "ANKER NICHT GEFUNDEN -- nicht eintragen, fragen (BA-1:479)"
            frage += 1

        print(f"  {zeichen} {kennung:22s} {wort}")
        if s["platzhalter"]:
            print(f"      ⚠ Platzhalter im neuen Wortlaut -- vor dem Eintragen ersetzen (12.4 Nr. 4)")
        if zeichen == "!! ":
            print(f"      Anker: {anker[:88]}")

    print()
    print(f"gefunden: {gut} · zu klaeren: {frage} · entfaellt: {entfaellt}")
    if frage:
        print()
        print("MINDESTENS EINE STELLE IST ZU KLAEREN. BA-1:479: stimmt der Anker nicht,")
        print("wird NICHT eingetragen, sondern gefragt. Eine falsch gesetzte Zeile in einem")
        print("eingefrorenen Vertragstext ist schwerer zu heilen als eine fehlende.")
        sys.exit(1)
    print("Alle aktiven Stellen sind am Text wiedergefunden. Das Eintragen selbst")
    print("nimmt dieses Werkzeug niemandem ab -- es sagt nur, dass die Anker stimmen.")

if __name__ == "__main__":
    main()
