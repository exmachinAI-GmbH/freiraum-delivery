#!/usr/bin/env python3
# umsetzt: Tor 3 (C-4) · Anlage "Bauverfahren" :114, :201 · HV-D16 (Anlage :229)
"""FREIRAUM · Tor 3 — die Anforderung mechanisch erzeugen, nicht formulieren.

    python3 werkzeuge/fremdreview_anfordern.py --einheit <kennung> \\
        --auftragstext arbeit/Auftraege/<blatt>.md \\
        --paket nachweise/tor3_belege/<paket>.zip

WOZU DIESES WERKZEUG DA IST
---------------------------
Die Anlage "Bauverfahren" schreibt fuer Tor 3 den Weg vor: ":114 extern, direkt zu
OpenAI ueber MCP, nicht ueber die Azure-OpenAI-Ressource" und ":201 eigener Pfad".
Der Kanal ist damit gezeichnet. Was die Anlage weiterhin verbietet, ist die
URHEBERSCHAFT: HV-D16 (:229) sagt "Kein Tor-3-Review selbst schreiben".

Dazwischen liegt eine Luecke, die man leicht uebersieht. Selbst wenn das fremde
Modell den Text des Urteils schreibt: Formuliert der Orchestrator die ANFRAGE frei,
reist die Lesart des Baus mit. Das Modell prueft dann die Erzaehlung ueber den Stand
statt den Stand -- und `gegen_roh_evidenz: ja` waere eine Behauptung.

Dieses Werkzeug schliesst die Luecke, indem es die Anfrage aus MESSBAREN TEILEN
zusammensetzt:

    fester Rahmen (unten im Quelltext, nachlesbar)
  + Auftragstext   (von Menschen geschrieben, unveraendert uebernommen)
  + Standblock     (Einheit, Commit, Zweig, Paketname, Pruefsummen -- gemessen)

Kein Satz dieser Anfrage stammt aus dem Zusammenhang des Baus. Der Rahmen steht in
RAHMEN weiter unten und aendert sich nur mit einem Antrag.

WAS ES AUSDRUECKLICH NICHT TUT
------------------------------
1. Es SCHICKT NICHTS AB. Es druckt den Befehl, den ein Mensch ausfuehrt. Wer den
   Versand automatisiert, hebt den Unterschied zwischen Weg B und Weg C auf --
   und genau der war der Gegenstand der Zeichnung vom 24.08.2026.

2. Es fuellt KEINEN KOPF aus. Die zwoelf Pflichtangaben des Urteilsblattes
   bestaetigt der anfordernde Mensch. Ein von einem Agenten ausgefuellter Kopf
   ist kein Nachweis, sondern seine Faelschung (`fremdreview.py`:27).

3. Es BEWERTET KEIN URTEIL. Das ist Tor 4.

DIE SCHEITERBEDINGUNG
---------------------
Eine Anforderung beschreibt einen Stand. Ist der Arbeitsbaum nicht sauber,
beschreibt der Commit ihn nicht -- dann bricht dieser Lauf ab. Wer es trotzdem
braucht, sagt es mit `--trotz-unsauber`, und der Vermerk steht in der Anfrage.
Ein stiller Ausweg waere schlimmer als keiner.

RUECKGABEWERTE (K23-M22: genau ein Zustand je Ergebnis)
    0  Anfrage erzeugt, alle Teile belegt
    1  Anfrage erzeugt, aber ein Teil ist benannt-unvollstaendig
    2  GESPERRT: nichts erzeugt
"""
import argparse
import hashlib
import pathlib
import re
import subprocess
import sys
from datetime import datetime, timezone

WURZEL = pathlib.Path(__file__).resolve().parent.parent
ZIEL = WURZEL / "arbeit" / "Auftraege"

# Der feste Rahmen. Er nennt dem Modell die Bedingungen aus C-4 und sagt, was es
# NICHT bekommt. Er enthaelt bewusst keine Aussage darueber, was der Bau geleistet
# hat -- kein "wir haben behoben", kein "erwartet wird". Wer diesen Text aendert,
# aendert die Anfrage aller kuenftigen Durchgaenge und braucht dafuer einen Antrag.
RAHMEN = """\
Sie pruefen als unabhaengiges Fremdmodell einen Stand der Software FREIRAUM.

Bedingungen dieser Pruefung:

1. Sie urteilen gegen die beigelegte Roh-Evidenz -- gegen Dateien, Protokolle und
   Pruefsummen, nicht gegen Erklaerungen des Bauteams. Erklaerungen liegen dieser
   Anfrage bewusst nicht bei.
2. Sie haben keinen Zusammenhang aus frueheren Sitzungen. Falls Ihnen etwas fehlt,
   um zu urteilen, ist "dazu kann ich nicht urteilen" eine gueltige und erwuenschte
   Antwort. Raten Sie nicht.
3. Ihr Urteil zeigt auf Fundstellen: Datei und Zeile oder Datei und Abschnitt. Ein
   Urteil ohne Fundstellen ist eine Meinung.
4. Ihr Urteil endet mit genau einem der drei Woerter: traegt, traegt mit auflagen,
   traegt nicht.

Sie entscheiden nicht ueber Freigabe. Das tut ein Mensch.
"""

STANDKOPF = "== DER GEPRUEFTE STAND (gemessen, nicht abgeschrieben) =="
AUFTRAGKOPF = "== DER AUFTRAGSTEXT (unveraendert uebernommen) =="


def lauf(*bef):
    """Ein Git-Aufruf. Keine Ausnahme nach aussen -- None heisst 'unbekannt'."""
    try:
        e = subprocess.run(bef, cwd=str(WURZEL), capture_output=True,
                           text=True, timeout=30, check=False)
    except (OSError, subprocess.SubprocessError):
        return None
    return e.stdout.strip() if e.returncode == 0 else None


def summe(datei):
    h = hashlib.sha256()
    with datei.open("rb") as d:
        for stueck in iter(lambda: d.read(65536), b""):
            h.update(stueck)
    return h.hexdigest()


def stand_erheben(trotz_unsauber):
    """Commit, Zweig und Sauberkeit -- gemessen. Gibt (stand, sperre) zurueck."""
    if lauf("git", "rev-parse", "--git-dir") is None:
        return None, "GESPERRT: kein Git-Bestand. Der Commit ist nicht feststellbar."
    commit = lauf("git", "rev-parse", "HEAD")
    if not commit or not re.fullmatch(r"[0-9a-f]{40}", commit):
        return None, "GESPERRT: HEAD liefert keinen vollstaendigen Commit."
    offen = lauf("git", "status", "--porcelain")
    sauber = (offen == "")
    if not sauber and not trotz_unsauber:
        return None, ("GESPERRT: der Arbeitsbaum ist nicht sauber -- der Commit "
                      f"{commit[:8]} beschreibt diesen Stand nicht (K23-M18 Glied 1).\n"
                      "         Entweder einchecken, oder --trotz-unsauber angeben; "
                      "der Vermerk steht dann in der Anfrage.")
    return {
        "commit": commit,
        "zweig": lauf("git", "rev-parse", "--abbrev-ref", "HEAD") or "unbekannt",
        "sauber": sauber,
    }, None


def anfrage_bauen(einheit, stand, auftragstext, paket, paketsumme, luecken):
    """Die Anfrage zusammensetzen. Reine Verkettung -- keine Formulierung."""
    zeit = datetime.now(timezone.utc).strftime("%Y-%m-%d %H:%M UTC")
    teile = [RAHMEN, "", STANDKOPF, ""]
    teile.append(f"Abnahmeeinheit : {einheit}")
    teile.append(f"Commit         : {stand['commit']}")
    teile.append(f"Zweig          : {stand['zweig']}")
    teile.append(f"Erzeugt        : {zeit}")
    if paket is not None:
        teile.append(f"Belegpaket     : {paket.name}")
        teile.append(f"  sha256       : {paketsumme}")
    else:
        teile.append("Belegpaket     : KEINES BEIGELEGT -- siehe Luecken unten")
    if not stand["sauber"]:
        teile.append("")
        teile.append("VERMERK: Der Arbeitsbaum war beim Erzeugen NICHT sauber. Der oben")
        teile.append("genannte Commit beschreibt den vorgelegten Stand nur teilweise.")
    if luecken:
        teile.append("")
        teile.append("BENANNTE LUECKEN dieser Anfrage:")
        for l in luecken:
            teile.append(f"  - {l}")
    teile += ["", AUFTRAGKOPF, "", auftragstext.rstrip(), ""]
    return "\n".join(teile) + "\n"


def main():
    ap = argparse.ArgumentParser(
        description="Tor 3: die Anforderung mechanisch erzeugen. Schickt nichts ab.")
    ap.add_argument("--einheit", required=True,
                    help="Kennung der Abnahmeeinheit, z. B. teilschnitt-anmeldung")
    ap.add_argument("--auftragstext", required=True,
                    help="Pfad zum von Menschen geschriebenen Auftragstext")
    ap.add_argument("--paket", help="Pfad zum Belegpaket aus werkzeuge/tor3_belege.py")
    ap.add_argument("--trotz-unsauber", action="store_true",
                    help="auch bei unsauberem Arbeitsbaum erzeugen; wird vermerkt")
    a = ap.parse_args()

    stand, sperre = stand_erheben(a.trotz_unsauber)
    if sperre:
        print(sperre, file=sys.stderr)
        return 2

    auftrag = pathlib.Path(a.auftragstext)
    if not auftrag.is_absolute():
        auftrag = WURZEL / auftrag
    if not auftrag.is_file():
        print(f"GESPERRT: Auftragstext nicht gefunden: {a.auftragstext}", file=sys.stderr)
        vorhandene = sorted((WURZEL / "arbeit" / "Auftraege").glob("tor3_*.md"))
        if vorhandene:
            print("         Vorhanden waeren:", file=sys.stderr)
            for v in vorhandene:
                print(f"           {v.relative_to(WURZEL)}", file=sys.stderr)
        return 2

    luecken = []
    paket = paketsumme = None
    if a.paket:
        paket = pathlib.Path(a.paket)
        if not paket.is_absolute():
            paket = WURZEL / paket
        if not paket.is_file():
            print(f"GESPERRT: Belegpaket nicht gefunden: {a.paket}", file=sys.stderr)
            return 2
        paketsumme = summe(paket)
    else:
        luecken.append(
            "Kein Belegpaket angegeben. Ohne Roh-Belege kann das Modell nur den "
            "Auftragstext lesen -- erzeuge es mit werkzeuge/tor3_belege.py "
            f"--einheit {a.einheit} und gib es mit --paket an.")

    text = anfrage_bauen(a.einheit, stand, auftrag.read_text(encoding="utf-8"),
                         paket, paketsumme, luecken)

    ZIEL.mkdir(parents=True, exist_ok=True)
    name = (f"anforderung_{a.einheit}_"
            f"{datetime.now(timezone.utc).strftime('%y%m%d')}_"
            f"{stand['commit'][:8]}.txt")
    ziel = ZIEL / name
    ziel.write_text(text, encoding="utf-8")
    (ziel.with_suffix(".txt.sha256")).write_text(
        f"{summe(ziel)}  {name}\n", encoding="utf-8")

    print(f"Anfrage erzeugt: {ziel.relative_to(WURZEL)}")
    print(f"  Zeichen: {len(text)}   Commit: {stand['commit'][:8]}   "
          f"Arbeitsbaum: {'sauber' if stand['sauber'] else 'UNSAUBER'}")
    for l in luecken:
        print(f"  LUECKE: {l}")
    print()
    print("DER HARNESS SCHICKT NICHTS AB. Ein Mensch fuehrt aus (Anlage :114, :201):")
    print()
    print("    codex exec --model gpt-5.6-sol --sandbox read-only \\")
    print(f"        \"$(cat {ziel.relative_to(WURZEL)})\"")
    print()
    print("Danach: Urteil UNVERAENDERT in ein Blatt nach "
          "nachweise/fremdreview/VORLAGE.md setzen,")
    print("Kopf ausfuellen und zeichnen, Pruefsumme daneben legen, dann")
    print("    python3 werkzeuge/fremdreview.py")
    return 1 if luecken else 0


if __name__ == "__main__":
    sys.exit(main())
