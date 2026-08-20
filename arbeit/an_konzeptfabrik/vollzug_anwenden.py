#!/usr/bin/env python3
# =====================================================================
#  Die Vollzugsstellen im Bauauftragstext anwenden
#
#      python3 vollzug_anwenden.py <bauauftrag.md>                  # nur pruefen
#      python3 vollzug_anwenden.py <bauauftrag.md> --anwenden \
#              --datum 20.08.2026                                   # schreiben
#
#  ES SCHREIBT NIE IN DIE VORGELEGTE DATEI. Das Ergebnis geht in eine
#  NEUE Datei daneben (<name>__v1.2_ENTWURF.md). Die Fassung v1.1 bleibt
#  unberuehrt -- nach 12.5 Nr. 5 wird sie archiviert, nicht ueberschrieben.
#
#  DIE FUENF REGELN, NACH DENEN ES ARBEITET
#
#   1  OHNE --anwenden wird nichts geschrieben. Der erste Aufruf ist eine
#      Probe, und sie ist Pflicht.
#   2  FAIL-CLOSED. Stimmt EIN Anker oder EIN alter Wortlaut nicht, wird
#      GAR NICHTS geschrieben -- nicht "die anderen trotzdem".
#   3  VON UNTEN NACH OBEN, je Blatt. Sonst verrutschen die uebrigen.
#   4  KEIN PLATZHALTER DARF UEBERLEBEN. Bleibt nach dem Einsetzen ein
#      ⟨…⟩ stehen, wird die Stelle abgelehnt -- ein Platzhalter im
#      eingefrorenen Auftrag ist nach 12.4 Nr. 4 ein NICHTVOLLZUG.
#   5  WAS UNKLAR IST, WIRD NICHT ANGEFASST. Fuenf der 25 Stellen sagen
#      die Korrekturblaetter nicht eindeutig -- sie werden benannt und
#      bleiben Handarbeit. Raten waere hier das Schlimmste: ein Absatz an
#      falscher Stelle in einem Vertragstext ist schwerer zu heilen als
#      eine fehlende Zeile.
#
#  WAS ES NICHT ERSETZT: das Nachsehen. BA-1:479 gilt weiter -- stimmt
#  ein Anker nicht, wird gefragt, nicht getippt. Dieses Werkzeug stellt
#  die Frage nur zuverlaessiger als ein Mensch, der 25-mal sucht.
# =====================================================================
import json, sys, re, shutil, unicodedata
from pathlib import Path

HIER = Path(__file__).resolve().parent
DATEN = HIER / "vollzug_25_stellen.json"
PLATZHALTER = re.compile(r"⟨[^⟩]*⟩")


def norm(t):
    return re.sub(r"\s+", " ", unicodedata.normalize("NFC", t)).strip()


def finde(text, stueck):
    """Zeichengenau, sonst mit zusammengezogenen Leerzeichen. Gibt den im
    Text tatsaechlich vorkommenden Ausschnitt zurueck -- oder None."""
    if stueck in text:
        return stueck
    ziel = norm(stueck)
    if not ziel or ziel not in norm(text):
        return None
    # Den echten Ausschnitt im Originaltext suchen: Wortfolge mit
    # beliebigem Zwischenraum.
    muster = r"\s+".join(re.escape(w) for w in ziel.split())
    t = re.search(muster, text)
    return t.group(0) if t else None


def main():
    argv = sys.argv[1:]
    if not argv:
        print(__doc__); sys.exit("Aufruf: vollzug_anwenden.py <bauauftrag.md> [--anwenden --datum TT.MM.JJJJ]")
    ziel = Path(argv[0])
    schreiben = "--anwenden" in argv
    datum = ""
    if "--datum" in argv:
        datum = argv[argv.index("--datum") + 1]
    if not ziel.is_file():
        sys.exit(f"ABBRUCH: Datei nicht gefunden: {ziel}")
    if schreiben and not datum:
        sys.exit("ABBRUCH: --anwenden verlangt --datum TT.MM.JJJJ. Ein Platzhalter im "
                 "eingefrorenen Auftrag ist ein Nichtvollzug (12.4 Nr. 4).")

    text = ziel.read_text(encoding="utf-8")
    daten = json.loads(DATEN.read_text(encoding="utf-8"))
    stellen = daten["stellen"]

    fertig, handarbeit, fehler = [], [], []

    for s in stellen:
        kennung = f"{s['blatt']} Stelle {s['nr']}"
        if not s.get("aktiv"):
            handarbeit.append((kennung, "ENTFAELLT — nicht eintragen, nur abhaken"))
            continue
        if s.get("art") in ("UNKLAR", None):
            handarbeit.append((kennung, "UNKLAR — " + (s.get("art_begruendung", "") or "")[:150]))
            continue

        anker = s["ankerzitat"].strip().strip("„“\"»«").strip()
        if finde(text, anker) is None:
            fehler.append((kennung, "ANKER NICHT GEFUNDEN — nicht eintragen, fragen (BA-1:479)"))
            continue

        alt_echt = finde(text, s["alter_wortlaut"].strip()) if s["alter_wortlaut"].strip() else ""
        if s["alter_wortlaut"].strip() and alt_echt is None:
            fehler.append((kennung, "ALTER WORTLAUT NICHT GEFUNDEN — fragen (BA-1:479)"))
            continue

        neu = s["neuer_wortlaut"]
        for k, v in (s.get("platzhalter_werte") or {}).items():
            neu = neu.replace(k, v)
        neu = re.sub(r"⟨(Zeichnungs)?[Dd]atum⟩", datum or "⟨Datum⟩", neu)
        if schreiben and PLATZHALTER.search(neu):
            fehler.append((kennung, "PLATZHALTER BLEIBT STEHEN: "
                           + ", ".join(sorted(set(PLATZHALTER.findall(neu))))
                           + " — Nichtvollzug nach 12.4 Nr. 4"))
            continue

        fertig.append((kennung, s, alt_echt, neu))

    print(f"Bauauftragstext: {ziel}")
    print(f"{len(stellen)} Stellen im Heft · {len(fertig)} anwendbar · "
          f"{len(handarbeit)} Handarbeit · {len(fehler)} zu klaeren\n")

    for k, s, _, _ in fertig:
        print(f"  OK   {k:22s} {s['art']}")
    for k, g in handarbeit:
        print(f"  --   {k:22s} {g}")
    for k, g in fehler:
        print(f"  !!   {k:22s} {g}")

    if fehler:
        print("\nEs wird NICHTS geschrieben. Fail-closed: eine Stelle, die nicht stimmt,")
        print("haelt alle an. BA-1:479 -- stimmt der Anker nicht, wird gefragt.")
        sys.exit(1)

    if not schreiben:
        print("\nProbe bestanden. Zum Schreiben:")
        print(f"  python3 {Path(__file__).name} {ziel} --anwenden --datum TT.MM.JJJJ")
        return

    # Anwenden -- von unten nach oben, in der Reihenfolge des Heftes.
    neu_text = text
    for k, s, alt_echt, neu in fertig:
        if s["art"] == "ERSETZEN":
            neu_text = neu_text.replace(alt_echt, neu, 1)
        elif s["art"] == "ANFUEGEN":
            neu_text = neu_text.replace(alt_echt, alt_echt + "\n\n" + neu, 1)
        elif s["art"] == "EINFUEGEN":
            marke = finde(neu_text, s["ankerzitat"].strip().strip("„“\"»«").strip())
            neu_text = neu_text.replace(marke, marke + "\n\n" + neu, 1)

    sicherung = ziel.with_name(ziel.stem + "__v1.1_SICHERUNG" + ziel.suffix)
    if not sicherung.exists():
        shutil.copy2(ziel, sicherung)
    ausgabe = ziel.with_name(ziel.stem + "__v1.2_ENTWURF" + ziel.suffix)
    ausgabe.write_text(neu_text, encoding="utf-8")

    print(f"\nGeschrieben: {ausgabe}")
    print(f"Sicherung:   {sicherung}")
    print(f"\n{len(fertig)} Stellen eingesetzt. {len(handarbeit)} bleiben Handarbeit:")
    for k, g in handarbeit:
        print(f"  {k:22s} {g[:110]}")
    print("\nDIE VORGELEGTE DATEI IST UNVERAENDERT. Erst wenn auch die Handarbeit sitzt und")
    print("jede Stelle in Feld 6 abgehakt ist, wird der Entwurf zur Fassung v1.2 (12.5).")


if __name__ == "__main__":
    main()
