#!/usr/bin/env python3
# umsetzt: Tor 3 (C-4, F42) · K23-M18 Glied 1 · K23-M22
"""FREIRAUM · Das Belegpaket für Tor 3 — nach Regel eingesammelt, nicht von Hand.

    python3 werkzeuge/tor3_belege.py --einheit teilschnitt-anmeldung
    python3 werkzeuge/tor3_belege.py --einheit teilschnitt-anmeldung --trotz-unsauber

WOZU. Tor 3 legt einem fremden Modell **Roh-Belege** vor, keine Zusammenfassungen. Am
20.08.2026 wurden sie von Hand eingesammelt — und im Urteil steht der Satz, der dabei
herauskommt:

    „D_Nachweise.txt (Klauselregister, Herkunftsgraph) wurde nicht vorgelegt."

Eine Gruppe fehlte. Nicht aus Nachlässigkeit, sondern weil eine Liste im Kopf keine Liste
ist. Dieses Werkzeug sammelt nach **Regel**: Es zählt nicht ab, es findet — und wenn eine
Gruppe leer bleibt, sagt es das, statt sie wegzulassen.

DIE SCHEITERBEDINGUNG. Ein Belegpaket beschreibt einen Stand. Ist der Arbeitsbaum nicht
sauber, beschreibt der Commit-Hash ihn nicht (K23-M18 Glied 1) — dann bricht dieser Lauf ab.
Wer es trotzdem braucht, sagt es ausdrücklich mit `--trotz-unsauber`, und der Vermerk steht
danach in STAND.txt. Ein stiller Ausweg wäre schlimmer als keiner.

WAS ES NICHT TUT. Es schickt nichts ab. Ein vom Harness gefahrenes Fremdreview ist kein
gültiger Tor-3-Nachweis — die frische Instanz und der getrennte Zusammenhang sind vier der
zwölf Pflichtangaben, und die kann nur der Anfordernde bestätigen.

RÜCKGABEWERTE:
    0  Paket geschnürt, alle Gruppen belegt
    1  Paket geschnürt, aber eine Gruppe ist leer — im Paket vermerkt
    2  GESPERRT: nichts geschnürt (unsauberer Arbeitsbaum, kein Git, keine Belege)
"""
import argparse
import hashlib
import subprocess
import sys
import zipfile
from datetime import datetime, timezone
from pathlib import Path

WURZEL = Path(__file__).resolve().parent.parent

# Die vier Gruppen des Anforderungssatzes vom 16.08.2026. Muster statt Liste:
# Der Auftrag O-K13-1 nannte einmal "die drei Waechter", und die Zahl war
# ueberholt, bevor er ausgefuehrt wurde (Befund F-06, M30:2322). Dieselbe Lehre.
GRUPPEN = {
    "A_Pruefgegenstand": {
        "was": "Der Umsetzungscode — was gebaut wurde",
        "muster": ["app/**/*.py", "app/vorlagen/*.html", "mail/*.py",
                   "migrations/*.sql", "migrations/negativfaelle/*.sql", "seeds/*.sql"],
    },
    "B_Messungen": {
        "was": "Die Prüffälle und was sie gemessen haben",
        "muster": ["pruefungen/*.sh", "pruefungen/klauseln/*", "pruefungen/migration/*",
                   "nachweise/manifeste/*.json"],
    },
    "C_Massstab": {
        "was": "Woran gemessen wird — der gezeichnete Vertrag",
        "muster": ["schema/K19_screens.yaml", "schema/K19_build_referenz.md",
                   "schema/freiraum_datamodel.sql"],
    },
    "D_Nachweise": {
        "was": "Klauselschnitt und Herkunft — am 20.08.2026 NICHT vorgelegt",
        "muster": ["nachweise/herkunft/herkunft.md", "nachweise/befunde/*.md"],
        "klauselschnitt": ("K03", "K04", "K13", "K19", "K20"),
    },
}

# GEZEICHNET AM 23.08.2026 (zeichnung_tor3_umfang_D_260823.md, Weg B, M. Veil und A. Han):
# "Klauseln der Konzepte K03, K04, K13, K19, K20 -- Wortlaut und, wo vorhanden,
# Akzeptanzkriterium; fehlende Kriterien bleiben sichtbar als 'ohne Kriterium' und
# werden nicht weggelassen."
#
# Gemessen: 230 der 1231 Klauseln, 249 KiB statt 4254 KiB fuer das ganze Register.
# 154 der 230 tragen kein Kriterium -- und genau das muss sichtbar bleiben. Gaebe man
# nur die 76 mit Kriterium mit, saehe der Massstab vollstaendiger aus, als er ist; das
# fremde Modell koennte "dazu kann ich nicht urteilen" nicht mehr sagen, obwohl der
# Auftragstext diese Antwort ausdruecklich als gueltig fuehrt.
REGISTER = "nachweise/klauselregister/register.json"


def klauselschnitt(konzepte):
    """Die Klauseln der genannten Konzepte im Wortlaut -- erzeugt, nicht kopiert."""
    quelle = WURZEL / REGISTER
    if not quelle.is_file():
        return None, f"{REGISTER} fehlt -- der Klauselschnitt kann nicht gezogen werden"
    import json
    zeilen = json.loads(quelle.read_text(encoding="utf-8")).get("zeilen", [])
    teil = [e for e in zeilen if e.get("konzept") in konzepte]
    if not teil:
        return None, f"kein Treffer fuer {', '.join(konzepte)} im Register"
    ohne = 0
    aus = [f"KLAUSELSCHNITT · {', '.join(konzepte)}",
           f"{len(teil)} Klauseln von {len(zeilen)} im Register.",
           "Gezeichnet am 23.08.2026 als Umfang der Gruppe D (Weg B).", ""]
    for e in sorted(teil, key=lambda x: str(x.get("klausel"))):
        aus.append("-" * 74)
        aus.append(f"{e.get('klausel')} · {e.get('konzept')} · {e.get('art')}")
        aus.append(f"Wortlaut: {e.get('wortlaut') or '(fehlt)'}")
        k = (e.get("akzeptanzkriterium") or "").strip()
        if k:
            aus.append(f"Akzeptanzkriterium: {k}")
        else:
            ohne += 1
            aus.append("Akzeptanzkriterium: OHNE KRITERIUM -- fuer diese Klausel ist nicht "
                       "gezeichnet, wann sie als erfuellt gilt.")
        aus.append("")
    aus.insert(3, f"{ohne} der {len(teil)} tragen KEIN Akzeptanzkriterium. Das ist kein "
                  "Auslassen,\nsondern der Stand -- und eine gueltige Antwort dazu lautet: "
                  "dazu kann ich nicht urteilen.")
    return "\n".join(aus), None


def git(*args):
    try:
        return subprocess.run(["git", "-C", str(WURZEL), *args],
                              capture_output=True, text=True, check=True).stdout.strip()
    except (subprocess.CalledProcessError, FileNotFoundError):
        return None


def sammeln(muster):
    dateien = []
    for m in muster:
        dateien.extend(p for p in sorted(WURZEL.glob(m)) if p.is_file())
    return sorted(set(dateien))


def main():
    ap = argparse.ArgumentParser(description="Schnürt das Belegpaket für Tor 3. Schickt nichts ab.")
    ap.add_argument("--einheit", required=True, help="Kennung der Abnahmeeinheit, z. B. teilschnitt-anmeldung")
    ap.add_argument("--ziel", default=None, help="Zielverzeichnis (Vorgabe: arbeit/Auftraege/)")
    ap.add_argument("--trotz-unsauber", action="store_true",
                    help="auch bei unsauberem Arbeitsbaum schnüren — der Vermerk steht dann im Paket")
    a = ap.parse_args()

    commit = git("rev-parse", "HEAD")
    if commit is None:
        print("GESPERRT · kein Git-Bestand erreichbar — nichts geschnürt.", file=sys.stderr)
        return 2
    zweig = git("rev-parse", "--abbrev-ref", "HEAD") or "?"
    schmutz = git("status", "--porcelain") or ""
    sauber = schmutz == ""

    if not sauber and not a.trotz_unsauber:
        print("GESPERRT · Arbeitsbaum nicht sauber — der Commit-Hash beschreibt den Stand nicht",
              file=sys.stderr)
        print("           (K23-M18 Glied 1). Erst einchecken, oder --trotz-unsauber setzen.",
              file=sys.stderr)
        for z in schmutz.splitlines()[:8]:
            print("           " + z, file=sys.stderr)
        return 2

    zeitpunkt = datetime.now(timezone.utc)
    stempel = zeitpunkt.strftime("%y%m%d")
    ziel = Path(a.ziel) if a.ziel else WURZEL / "arbeit/Auftraege"
    ziel.mkdir(parents=True, exist_ok=True)
    paket = ziel / f"tor3_belege_{a.einheit}_{stempel}.zip"

    print(f"== Belegpaket für Tor 3 · {a.einheit}")
    print(f"   Commit {commit[:12]} · Zweig {zweig} · Arbeitsbaum {'sauber' if sauber else 'NICHT SAUBER'}\n")

    gefunden, pruefsummen, leer = {}, [], []
    for name, g in GRUPPEN.items():
        dateien = sammeln(g["muster"])
        gefunden[name] = dateien
        if not dateien:
            leer.append(name)
        kb = sum(x.stat().st_size for x in dateien) // 1024
        print(f"   {name:20} {len(dateien):>3} Dateien · {kb:>5} KiB   {g['was']}")
        for p in dateien:
            rel = p.relative_to(WURZEL).as_posix()
            pruefsummen.append(f"{hashlib.sha256(p.read_bytes()).hexdigest()}  {rel}")

    gesamt = sum(len(v) for v in gefunden.values())
    zeichen = sum(p.stat().st_size for v in gefunden.values() for p in v)
    print(f"\n   zusammen {gesamt} Belege · {zeichen // 1024} KiB Rohtext")
    if zeichen > 900_000:
        print("   HINWEIS: Das ist viel fuer ein Gespraech. Am 20.08.2026 wurden A und C")
        print("            zuerst vorgelegt und B im selben Gespraech nachgereicht.")

    stand = [
        f"FREIRAUM · Tor 3 · Belegpaket zur Abnahmeeinheit {a.einheit}",
        f"geschnuert am   {zeitpunkt.isoformat(timespec='seconds')}",
        f"Commit          {commit}",
        f"Zweig           {zweig}",
        f"Arbeitsbaum     {'sauber' if sauber else 'NICHT SAUBER -- der Hash beschreibt den Stand NICHT (K23-M18)'}",
        f"Belege          {gesamt} Dateien in {len(GRUPPEN)} Gruppen",
        "",
        "Die Gruppen:",
    ]
    for name, g in GRUPPEN.items():
        stand.append(f"  {name:20} {len(gefunden[name]):>3}  {g['was']}")
    stand += ["",
              "Was NICHT im Paket ist und es auch nicht sein soll:",
              "  - Bauberichte, Zusammenfassungen, Erklaerungen des Bauenden",
              "  - Zugangsdaten jeder Art (K23-D09)",
              "  - das Urteil selbst -- es entsteht beim fremden Modell",
              ""]
    if leer:
        stand += ["ACHTUNG -- eine Gruppe ist LEER und wurde nicht weggelassen, sondern gemeldet:"]
        stand += [f"  {n}" for n in leer]
        stand += [""]

    with zipfile.ZipFile(paket, "w", zipfile.ZIP_DEFLATED) as z:
        for name, dateien in gefunden.items():
            teile = []
            schnitt = GRUPPEN[name].get("klauselschnitt")
            if schnitt:
                text, grund = klauselschnitt(schnitt)
                if text:
                    teile.append(f"\n{'='*78}\n=== erzeugter Klauselschnitt\n{'='*78}\n")
                    teile.append(text + "\n")
                else:
                    teile.append(f"\n(Klauselschnitt nicht erzeugt: {grund})\n")
            for p in dateien:
                rel = p.relative_to(WURZEL).as_posix()
                teile.append(f"\n{'='*78}\n=== {rel}\n{'='*78}\n")
                teile.append(p.read_text(encoding="utf-8", errors="replace"))
            z.writestr(f"{name}.txt", "".join(teile) if teile
                       else "(leer -- diese Gruppe hat keine Belege gefunden)\n")
        z.writestr("PRUEFSUMMEN.txt", "\n".join(pruefsummen) + "\n")
        z.writestr("STAND.txt", "\n".join(stand))

    try:
        wo = paket.relative_to(WURZEL)
    except ValueError:
        wo = paket          # --ziel darf ausserhalb des Bestandes liegen
    print(f"\n   geschnuert: {wo}")
    print(f"   {paket.stat().st_size // 1024} KiB · sha256 {hashlib.sha256(paket.read_bytes()).hexdigest()[:16]}…")
    if leer:
        print(f"\n   ACHTUNG: leer geblieben — {', '.join(leer)}. Im Paket vermerkt, nicht weggelassen.")
    print("\n   Abgeschickt wird von einem Menschen, in einer frischen Instanz eines fremden")
    print("   Modells. Ein vom Harness gefahrenes Review ist kein Tor-3-Nachweis (C-4).")
    return 1 if leer else 0


if __name__ == "__main__":
    try:
        raise SystemExit(main())
    except BrokenPipeError:
        try:
            sys.stdout.close()
        finally:
            raise SystemExit(2)
