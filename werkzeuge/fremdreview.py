#!/usr/bin/env python3
"""FREIRAUM Coding-Harness · Tor 3 — Nachweis des fremden Blicks.

    python3 werkzeuge/fremdreview.py [--scheibe <kennung>] [--verzeichnis <pfad>]

Was dieses Werkzeug prueft
--------------------------
Die FORM des Nachweises, nie die Richtigkeit des Urteils.

Ein Werkzeug, das ein Fremdurteil bewertet, waere wieder der eigene Blick --
und damit genau das, wogegen Tor 3 gebaut ist. Geprueft wird deshalb nur:
ist das Blatt vollstaendig, nennt es Modell und Fassung, existiert der
gepruefte Commit, stimmt die Pruefsumme, hat ein MENSCH die Anforderung
gezeichnet.

Was dieses Werkzeug NICHT kann -- und nicht koennen soll
--------------------------------------------------------
1. Es kann nicht feststellen, ob das Review wirklich von einem fremden
   Modell stammt. Keine Maschine kann das. Es steht als gezeichnete Aussage
   eines Menschen im Kopf des Blattes; diese Unterschrift IST der Beleg.

2. Es kann nicht feststellen, ob wirklich gegen Roh-Evidenz geprueft wurde.
   Das Blatt benennt die Evidenz; ob der Pruefer sie gelesen hat, weiss nur er.

3. Es entscheidet nicht, ob das Urteil zutrifft. Das ist Tor 4.

4. Es FORDERT KEIN REVIEW AN und schreibt keines.
   `.claude/commands/scheibe.md`:73: "Der Harness schreibt dieses Review nie
   selbst." Ein von einem Agenten ausgefuellter Kopf ist kein Nachweis,
   sondern seine Faelschung. Dieses Werkzeug liest nur.

Die drei Zustaende
------------------
Nach K23-M22 traegt jedes Ergebnis genau einen Zustand. Hier:

    bestanden  -- ein vollstaendiges, pruefsummiertes, gezeichnetes Blatt
    gesperrt   -- Blatt fehlt oder ist unvollstaendig: NICHT GEMESSEN
    fehlgeschlagen -- das Blatt sagt selbst "traegt nicht"

"gesperrt" ist ausdruecklich nicht "fehlgeschlagen" und erst recht nicht
"bestanden". Ein fehlendes Fremdreview ist kein bestandenes.
"""
import argparse
import hashlib
import pathlib
import re
import subprocess
import sys

WURZEL = pathlib.Path(__file__).resolve().parent.parent
VERZEICHNIS = WURZEL / "nachweise" / "fremdreview"

# Pflichtfelder des Kopfes. Die Namen stehen so in VORLAGE.md; wer sie
# aendert, aendert den Vertrag zwischen Blatt und Werkzeug.
PFLICHT = [
    "scheibe", "datum", "geprueft_commit",
    "pruefendes_modell", "pruefende_fassung",
    "frische_instanz", "getrennter_kontext", "gegen_roh_evidenz",
    "evidenz", "angefordert_von", "harness_hat_nicht_geschrieben", "urteil",
]

# Felder, die ausdruecklich bejaht sein muessen -- ein "nein" oder "teilweise"
# ist kein Formfehler, sondern die Auskunft, dass die Bedingung aus C-4 und
# scheibe.md:73 nicht erfuellt war. Dann ist das Blatt kein Tor-3-Nachweis.
BEJAHUNG = ["frische_instanz", "getrennter_kontext", "gegen_roh_evidenz",
            "harness_hat_nicht_geschrieben"]

URTEILE = {"traegt", "traegt mit auflagen", "traegt nicht",
           "trägt", "trägt mit auflagen", "trägt nicht"}

# Platzhalter der Vorlage. Ein Blatt, das sie noch traegt, ist nicht
# ausgefuellt -- und ein nicht ausgefuelltes Blatt darf nicht bestehen.
PLATZHALTER = re.compile(r"^<.*>$")

ZEILE = re.compile(r"^\|\s*([a-z_]+)\s*\|\s*(.*?)\s*\|\s*$")


def kopf_lesen(text):
    """Den Kopf lesen -- nur zwischen den beiden Marken, nie darueber hinaus.

    Die Begrenzung ist Absicht: das Urteil darunter enthaelt Tabellen und
    Backticks in beliebiger Form. Ein Leser, der weiterliest, faende dort
    Felder, die niemand als Kopf gemeint hat.
    """
    kopf = {}
    drin = False
    for roh in text.splitlines():
        if "KOPF · maschinell gelesen" in roh:
            drin = True
            continue
        if "ENDE KOPF" in roh:
            break
        if not drin:
            continue
        t = ZEILE.match(roh.strip())
        if t:
            kopf[t.group(1)] = t.group(2).strip().strip("`").strip()
    return kopf


def commit_bekannt(hash_):
    """Existiert der geprüfte Commit in diesem Repo?

    Sonst beschreibt das Blatt einen Stand, den es hier nicht gibt. Kein
    Werfen: fehlt git, ist die Antwort "unbekannt", und das wird ausgewiesen.
    """
    if not re.fullmatch(r"[0-9a-f]{40}", hash_ or ""):
        return False
    try:
        e = subprocess.run(["git", "cat-file", "-e", f"{hash_}^{{commit}}"],
                           cwd=str(WURZEL), capture_output=True, timeout=20,
                           check=False)
        return e.returncode == 0
    except (OSError, subprocess.SubprocessError):
        return None


def summe_stimmt(datei):
    """Nebendatei <name>.sha256 gegen die Datei rechnen."""
    neben = datei.with_suffix(datei.suffix + ".sha256")
    if not neben.is_file():
        return None
    hinterlegt = neben.read_text(encoding="utf-8").split()
    if not hinterlegt:
        return False
    h = hashlib.sha256()
    with datei.open("rb") as d:
        for stueck in iter(lambda: d.read(65536), b""):
            h.update(stueck)
    return h.hexdigest() == hinterlegt[0]


def gezeichnet(text):
    """Traegt die Zeichnung der Anforderung einen Namen?

    Gesucht wird die Tabelle unter "Zeichnung der Anforderung": eine Zeile
    mit drei Feldern, von denen die ersten beiden nicht leer sind. Die
    Vorlage bringt sie leer mit; bleibt sie leer, hat niemand gezeichnet.
    """
    teil = text.split("## Zeichnung der Anforderung", 1)
    if len(teil) < 2:
        return False
    # Bis zum waagerechten Strich -- und der ist eine Zeile, die NUR aus
    # Strichen besteht. Ein blosses split("---") schnitte an der
    # Trennzeile der Tabelle selbst ab ("|---|---|---|") und faende die
    # Unterschrift nie. Gemessen am 14.08.2026: ein gezeichnetes Blatt
    # meldete "Zeichnung ist leer".
    ende = re.search(r"(?m)^-{3,}\s*$", teil[1])
    abschnitt = teil[1][:ende.start()] if ende else teil[1]
    for roh in abschnitt.splitlines():
        s = roh.strip()
        if not s.startswith("|") or set(s) <= set("|- "):
            continue
        felder = [f.strip() for f in s.strip("|").split("|")]
        if len(felder) >= 2 and felder[0] and felder[1] \
                and felder[0].lower() != "name":
            return True
    return False


def blatt_pruefen(datei):
    befunde = []
    text = datei.read_text(encoding="utf-8")
    kopf = kopf_lesen(text)

    for feld in PFLICHT:
        wert = kopf.get(feld, "")
        if not wert:
            befunde.append(f"Kopffeld '{feld}' fehlt oder ist leer")
        elif PLATZHALTER.match(wert):
            befunde.append(f"Kopffeld '{feld}' traegt noch den Platzhalter der Vorlage")

    for feld in BEJAHUNG:
        wert = kopf.get(feld, "").lower()
        if wert and not PLATZHALTER.match(wert) and wert != "ja":
            befunde.append(
                f"'{feld}' lautet '{wert}', nicht 'ja' -- die Bedingung aus C-4 "
                "und scheibe.md:73 war nicht erfuellt; das Blatt ist dann kein "
                "Tor-3-Nachweis")

    urteil = kopf.get("urteil", "").lower()
    if urteil and not PLATZHALTER.match(urteil) and urteil not in URTEILE:
        befunde.append(f"'urteil' lautet '{urteil}' -- erlaubt sind: "
                       "traegt · traegt mit auflagen · traegt nicht")

    c = kopf.get("geprueft_commit", "")
    if c and not PLATZHALTER.match(c):
        bekannt = commit_bekannt(c)
        if bekannt is False:
            befunde.append(f"geprueft_commit {c[:12]} ist in diesem Repo nicht "
                           "auffindbar -- das Blatt beschreibt einen Stand, den "
                           "es hier nicht gibt")
        elif bekannt is None:
            befunde.append("geprueft_commit nicht pruefbar (kein git im Lauf)")

    s = summe_stimmt(datei)
    if s is None:
        befunde.append(f"Nebendatei {datei.name}.sha256 fehlt")
    elif s is False:
        befunde.append("Pruefsumme stimmt nicht -- das Blatt ist nach der "
                       "Ablage veraendert worden")

    if not gezeichnet(text):
        befunde.append("Die Zeichnung der Anforderung ist leer. Ohne sie fehlt "
                       "die einzige Aussage, die belegt, dass ein MENSCH das "
                       "Review angefordert hat (scheibe.md:73)")

    if "## Fundstellen" not in text:
        befunde.append("Abschnitt 'Fundstellen' fehlt -- ein Urteil ohne "
                       "Fundstellen ist eine Meinung (Praezedenz Blatt 26:2)")

    if befunde:
        zustand = "gesperrt"
    elif urteil in {"traegt nicht", "trägt nicht"}:
        zustand = "fehlgeschlagen"
    else:
        zustand = "bestanden"
    return zustand, kopf, befunde


def main():
    ap = argparse.ArgumentParser(
        description="Tor 3 · Nachweis des fremden Blicks pruefen (nie erzeugen)")
    ap.add_argument("--scheibe", help="nur Blaetter dieser Scheibe pruefen")
    ap.add_argument("--verzeichnis", default=str(VERZEICHNIS))
    a = ap.parse_args()

    ort = pathlib.Path(a.verzeichnis)
    if not ort.is_dir():
        print(f"::error::{ort} fehlt -- Tor 3 GESPERRT (K23-M22)")
        return 2

    blaetter = sorted(p for p in ort.glob("*.md")
                      if p.name not in {"README.md", "VORLAGE.md"})

    if not blaetter:
        print("Tor 3: kein Fremdreview abgelegt.")
        print("  Zustand: GESPERRT -- nicht gemessen ist nicht bestanden (K23-M22).")
        print(f"  Vorlage: {ort / 'VORLAGE.md'}")
        print("  Das Review wird von einem MENSCHEN angefordert; der Harness")
        print("  schreibt es nie selbst (.claude/commands/scheibe.md:73).")
        return 1

    gesperrt = fehl = gut = 0
    for b in blaetter:
        zustand, kopf, befunde = blatt_pruefen(b)
        if a.scheibe and kopf.get("scheibe") != a.scheibe:
            continue
        marke = {"bestanden": "BESTANDEN", "gesperrt": "GESPERRT",
                 "fehlgeschlagen": "FEHLGESCHLAGEN"}[zustand]
        modell = kopf.get("pruefendes_modell", "?")
        fassung = kopf.get("pruefende_fassung", "?")
        print(f"{marke:14} {b.name}  Scheibe {kopf.get('scheibe', '?')}  "
              f"{modell} {fassung}")
        for f in befunde:
            print(f"               - {f}")
        gesperrt += zustand == "gesperrt"
        fehl += zustand == "fehlgeschlagen"
        gut += zustand == "bestanden"

    print("----")
    print(f"Tor 3: {gut} bestanden, {fehl} fehlgeschlagen, {gesperrt} gesperrt")
    if fehl or gesperrt:
        print("Ein Bau mit anschlagendem Gate erreicht die menschliche Freigabe "
              "nicht (K23-D01).")
    return 1 if (fehl or gesperrt) else 0


if __name__ == "__main__":
    sys.exit(main())
