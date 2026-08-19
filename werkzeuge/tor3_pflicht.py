#!/usr/bin/env python3
"""F42 · Keine Scheibenabnahme ohne gezeichneten Tor-3-Nachweis.

    python3 werkzeuge/tor3_pflicht.py

WOZU
    C-4 ist seit Blatt 26:30 gezeichnet: ein fremder Blick "einmal je
    Scheibenabnahme, nicht je Aenderung". Die Regel galt und wurde nicht
    erzwungen -- dieselbe Beobachtung wie bei F41: eine gezeichnete Regel,
    die kein Lauf erzwingt, wird nicht eingehalten.

    Dieses Werkzeug macht daraus eine Bedingung, an der ein Lauf scheitert.

DER AUSLOESER -- das Stueck, das bisher fehlte
    Eine Regel kann erst greifen, wenn maschinell erkennbar ist, dass eine
    Scheibenabnahme ueberhaupt stattfindet. Der Traeger dafuer ist

        nachweise/scheiben/<kennung>/abnahme.md

    Ihr Entstehen ist ein Commit, und an einen Commit kann ein Lauf sich
    haengen. Ohne diesen Ausloeser bliebe F42 eine Regel ohne Schranke,
    genau wie C-4 es bis zum 18.08.2026 war.

DIE BINDUNG, auf die es ankommt
    geprueft_commit MUSS ein VORFAHR des Abnahmestandes sein.

    Ohne diese Bedingung ist der Nachweis das, was AC-16 vor Blatt 89 war:
    ein Beleg, den jedes beliebige alte Blatt erfuellt. Das bisherige
    fremdreview.py prueft nur, ob der Commit EXISTIERT -- ein Hash aus dem
    Juli erfuellt das ebenso wie der Abnahmestand von heute.

    Als Abnahmestand gilt HEAD: der Stand, der gerade angenommen werden
    soll. Ein Review, das einen Commit ausserhalb dieser Geschichte nennt,
    hat einen anderen Stand gesehen als den, der abgenommen wird.

ABLAGE -- Abweichung vom Wortlaut der Festlegung, benannt
    F42 nennt nachweise/tor3/<scheibe>.md. Dieses Werkzeug liest
    nachweise/fremdreview/, weil dort bereits die VORLAGE, das README und
    werkzeuge/fremdreview.py stehen und .github/workflows/tor3.yml dorthin
    zeigt. Eine zweite Ablage haette die Nachweise geteilt -- ein Blatt
    findet man dann in zwei Verzeichnissen nicht, sondern in keinem.
    Wird die Ablage umbenannt, aendert sich hier eine Konstante.

GRENZE, ausdruecklich
    Diese Festlegung erzwingt die ABLAGE, nicht die PRUEFUNG. Ob ein Mensch
    wirklich eine frische Instanz eines fremden Modells gefragt hat, kann
    kein Riegel sehen. Dagegen schuetzt allein die Zeichnung -- eine
    Willenserklaerung, keine Messung.
"""
import re
import subprocess
import sys
from pathlib import Path

WURZEL = Path(__file__).resolve().parent.parent
SCHEIBEN = WURZEL / "nachweise" / "scheiben"
NACHWEISE = WURZEL / "nachweise" / "fremdreview"

KOPFZEILE = re.compile(r"^\|\s*([a-z_]+)\s*\|\s*(.+?)\s*\|\s*$")
HASH = re.compile(r"\b[0-9a-f]{40}\b")


def git(*args):
    """git-Aufruf. Gibt (rueckgabe, ausgabe). Kein git -> (None, '')."""
    try:
        e = subprocess.run(("git", *args), cwd=WURZEL, capture_output=True,
                           check=False,
                           text=True, timeout=20)
        return e.returncode, e.stdout.strip()
    except (OSError, subprocess.SubprocessError):
        return None, ""


def kopf_lesen(pfad):
    """Die Feld-Wert-Tabelle im Kopf eines Blattes."""
    kopf = {}
    for zeile in pfad.read_text(encoding="utf-8").splitlines():
        t = KOPFZEILE.match(zeile)
        if t:
            kopf[t.group(1)] = t.group(2).strip("` ")
    return kopf


def abnahmen():
    """Alle Scheiben, fuer die eine Abnahme angemeldet ist."""
    if not SCHEIBEN.is_dir():
        return []
    return sorted(p for p in SCHEIBEN.glob("*/abnahme.md"))


def nachweis_zu(kennung):
    """Das Tor-3-Blatt dieser Scheibe -- ueber das Feld, nicht den Dateinamen.

    Der Dateiname traegt nach der VORLAGE ein Datum (<scheibe>_<JJMMTT>.md);
    massgeblich ist das Feld `scheibe` im Kopf. Gibt es mehrere, gewinnt das
    zuletzt datierte -- und die uebrigen bleiben als Historie liegen.
    """
    if not NACHWEISE.is_dir():
        return None
    passend = []
    for p in sorted(NACHWEISE.glob("*.md")):
        if p.name == "VORLAGE.md":
            continue
        if kopf_lesen(p).get("scheibe") == kennung:
            passend.append(p)
    return passend[-1] if passend else None


def pruefe(abnahme):
    """Gibt (zustand, meldung) fuer eine angemeldete Abnahme."""
    kennung = abnahme.parent.name
    nachweis = nachweis_zu(kennung)

    if nachweis is None:
        return "fehlgeschlagen", (
            f"Scheibe {kennung} meldet eine Abnahme ({abnahme.relative_to(WURZEL)}), "
            f"aber in nachweise/fremdreview/ steht kein Blatt mit "
            f"scheibe: {kennung}. Ohne fremden Blick ist die Scheibe GESPERRT, "
            f"nicht abgenommen (C-4, F42)")

    kopf = kopf_lesen(nachweis)
    fehlt = [f for f in ("geprueft_commit", "pruefendes_modell", "datum",
                         "urteil") if not kopf.get(f)]
    if fehlt:
        return "fehlgeschlagen", (
            f"Scheibe {kennung}: {nachweis.name} fuehrt {', '.join(fehlt)} "
            f"nicht. Ein unvollstaendiges Blatt ist kein Nachweis")

    # "keine" muss dastehen, nicht fehlen: ein leeres Befundfeld ist
    # zweideutig -- niemand weiss, ob nichts gefunden oder nichts
    # eingetragen wurde.
    if "befunde" not in kopf or not kopf["befunde"]:
        return "fehlgeschlagen", (
            f"Scheibe {kennung}: {nachweis.name} fuehrt kein Feld `befunde`. "
            f"Wurde nichts gefunden, muss 'keine' dastehen -- ein leeres Feld "
            f"ist zweideutig")

    c = kopf["geprueft_commit"]
    if not HASH.fullmatch(c):
        return "fehlgeschlagen", (
            f"Scheibe {kennung}: geprueft_commit '{c[:20]}' ist kein voller "
            f"40-stelliger Hash")

    # ── DIE BINDUNG ──────────────────────────────────────────────────
    rc, _ = git("cat-file", "-e", f"{c}^{{commit}}")
    if rc is None:
        return "gesperrt", (
            f"Scheibe {kennung}: kein git im Lauf — die Bindung des "
            f"Nachweises an den Abnahmestand ist nicht pruefbar (K23-M22)")
    if rc != 0:
        return "fehlgeschlagen", (
            f"Scheibe {kennung}: geprueft_commit {c[:12]} ist in diesem Repo "
            f"nicht auffindbar")

    rc, _ = git("merge-base", "--is-ancestor", c, "HEAD")
    if rc != 0:
        return "fehlgeschlagen", (
            f"Scheibe {kennung}: geprueft_commit {c[:12]} ist KEIN Vorfahr des "
            f"Abnahmestandes. Das Fremdmodell hat einen anderen Stand gesehen "
            f"als den, der abgenommen werden soll — der Nachweis traegt nicht "
            f"(F42). Genau das war AC-16 vor Blatt 89")

    return "bestanden", (
        f"Scheibe {kennung} — {nachweis.name}, {kopf['pruefendes_modell']}, "
        f"geprueft gegen {c[:12]} (Vorfahr des Abnahmestandes), "
        f"Befunde: {kopf['befunde']}")


def main():
    angemeldet = abnahmen()
    if not angemeldet:
        print("F42: keine Scheibenabnahme angemeldet — nichts zu pruefen.")
        print("     Eine Abnahme meldet man mit "
              "nachweise/scheiben/<kennung>/abnahme.md an.")
        return 0

    ok = fehl = gesperrt = 0
    for a in angemeldet:
        zustand, meldung = pruefe(a)
        if zustand == "bestanden":
            ok += 1
            print(f"   {meldung}")
        elif zustand == "gesperrt":
            gesperrt += 1
            print(f"::warning::GESPERRT — {meldung}")
        else:
            fehl += 1
            print(f"::error::{meldung}")

    print(f"\nF42: {len(angemeldet)} Abnahme(n) angemeldet · {ok} mit "
          f"gebundenem Tor-3-Nachweis · {fehl} ohne · {gesperrt} gesperrt")

    if fehl:
        print(f"::error::F42: {fehl} Scheibe(n) ohne tragenden "
              f"Tor-3-Nachweis — GESPERRT, nicht abgenommen (C-4, K23-M22)")
        return 1
    if gesperrt:
        print(f"::warning::F42: {gesperrt} Scheibe(n) nicht messbar")
    return 0


if __name__ == "__main__":
    sys.exit(main())
