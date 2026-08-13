#!/usr/bin/env python3
"""FREIRAUM Coding-Harness · das Testmanifest nach K23-M18.

    werkzeuge/manifest.py --ziel nachweise/manifeste/<name>.json \\
                          --ergebnisse <datei.json> \\
                          --beginn <ISO> [--lauf "Tor 1c"]

K23-M18 zaehlt ACHT Glieder auf. Dieses Werkzeug fuellt jedes einzeln und
weist aus, wo es nichts zu fuellen gibt -- ein leeres Feld ist eine Auskunft,
ein fehlendes Feld ist keine.

    "Ohne Nr. 8 ist 'unveraenderlich' eine Behauptung" (Bauauftrag :306).

Deshalb entsteht neben dem Manifest eine zweite Datei mit seiner Pruefsumme.
Eine Pruefsumme IM Manifest kann nicht ueber das Manifest gehen -- sie waere
Teil dessen, was sie sichert. Der Nebenweg ist die uebliche Loesung und die
einzige, die aufgeht.

BEFUND AH-7 (Handover 11.08.2026): "nachweise/manifeste/ existiert im
Git-Baum nicht. Der ganze 11.08. hat gemessen und nichts hinterlassen."
In CI entstand zwar ein Bericht, aber nur als Anhang am Lauf -- und der
verfaellt nach Tagen. Ein Glied einer Kette, das verfaellt, ist keines.
"""
import argparse
import datetime
import hashlib
import json
import os
import pathlib
import re
import shutil
import subprocess
import sys

WURZEL = pathlib.Path(__file__).resolve().parent.parent


def lauf(*befehl, **kw):
    """Einen Befehl ausfuehren und seine Ausgabe zurueckgeben -- oder None.

    Nie werfen: ein Manifest, das am Ermitteln eines Werts scheitert, waere
    schlechter als eines, das den Wert als unbekannt ausweist.
    """
    try:
        e = subprocess.run(befehl, capture_output=True, text=True, timeout=20,
                           cwd=str(WURZEL), check=False, **kw)
        return e.stdout.strip() or None if e.returncode == 0 else None
    except (OSError, subprocess.SubprocessError):
        # Fehlendes Werkzeug, Zeitueberschreitung, kein Ausfuehrungsrecht:
        # alles drei heisst "kein Wert", und der wird ausgewiesen.
        return None


def streuwert(pfad):
    p = WURZEL / pfad if not os.path.isabs(str(pfad)) else pathlib.Path(pfad)
    if not p.is_file():
        return None
    h = hashlib.sha256()
    with open(p, "rb") as d:
        for stueck in iter(lambda: d.read(65536), b""):
            h.update(stueck)
    return h.hexdigest()


def hinterlegte_summe(pfad):
    """Eine .sha256-Datei neben der Quelle lesen (erstes Wort)."""
    p = WURZEL / pfad
    if not p.is_file():
        return None
    return p.read_text().split()[0] if p.read_text().split() else None


def werkzeugfassung(name, *args):
    a = lauf(name, *args)
    return a.splitlines()[0].strip() if a else None


# ---------------------------------------------------------------------
# Glied 1 · Commit-Hash des geprueften Standes
# ---------------------------------------------------------------------
def glied1():
    hash_ = lauf("git", "rev-parse", "HEAD")
    schmutz = lauf("git", "status", "--porcelain")
    # Ein Commit-Hash bei schmutzigem Arbeitsbaum LUEGT: der Stand, der lief,
    # steht in keinem Commit. Das wird ausgewiesen, nicht verschwiegen.
    return {
        "commit": hash_,
        "zweig": lauf("git", "rev-parse", "--abbrev-ref", "HEAD"),
        "arbeitsbaum_sauber": schmutz == "" or schmutz is None,
        "abweichende_dateien": (schmutz.splitlines() if schmutz else []),
        "anmerkung": None if not schmutz else
                     "Arbeitsbaum war NICHT sauber -- der Commit-Hash "
                     "beschreibt nicht den gelaufenen Stand.",
    }


# ---------------------------------------------------------------------
# Glied 2 und 3 · Pruefsummen von Bauauftrag und Anlage
#
# Beide liegen AUSSERHALB des Repos (CLAUDE.md Kopf): die Anlage misst diese
# Datei gegen sich selbst; laegen beide hier, aenderte ein einziger Commit
# beide Seiten. Der Wert wird deshalb aus der CLAUDE.md gelesen und seine
# Herkunft mitgefuehrt -- er ist an dieser Stelle uebernommen, nicht gemessen.
# Gemessen wird er von `./install.sh --pruefsumme`, das die Anlage selbst
# nachrechnet.
# ---------------------------------------------------------------------
def _aus_claude_md(muster):
    p = WURZEL / "CLAUDE.md"
    if not p.is_file():
        return None
    t = re.search(muster, p.read_text())
    return t.group(1) if t else None


def glied2():
    return {
        "gegenstand": "Bauauftrag N5, Fassung v1.1 (07.08.2026)",
        "sha256": _aus_claude_md(r"Bauauftrags.*?`([0-9a-f]{64})`"),
        "herkunft": "CLAUDE.md Abschn. 4 -- uebernommen, nicht in diesem Lauf gemessen",
        "liegt_im_repo": False,
        "nachrechnen_mit": "shasum -a 256 <Bauauftrag> gegen den Wert in CLAUDE.md",
    }


def glied3():
    return {
        "gegenstand": "Anlage Bauverfahren (gez. M. Veil 07.08.2026)",
        "sha256": _aus_claude_md(r"Prüfsumme der Anlage.*?`([0-9a-f]{64})`"),
        "herkunft": "CLAUDE.md Kopf -- uebernommen, nicht in diesem Lauf gemessen",
        "liegt_im_repo": False,
        "nachrechnen_mit": "./install.sh --pruefsumme",
        "claude_md_sha256": streuwert("CLAUDE.md"),
    }


# ---------------------------------------------------------------------
# Glied 4 · Migrationsstand: welche Dateien, in welcher Reihenfolge,
#           gegen welches Basisschema
# ---------------------------------------------------------------------
def glied4():
    migrationen = sorted((WURZEL / "migrations").glob("*.sql"))
    seeds = sorted((WURZEL / "seeds").glob("*.sql"))
    return {
        "basisschema": {
            "datei": "schema/freiraum_datamodel.sql",
            "sha256": streuwert("schema/freiraum_datamodel.sql"),
            "hinterlegt": hinterlegte_summe("schema/freiraum_datamodel.sha256"),
        },
        # Reihenfolge ist Teil der Auskunft: dieselben Dateien in anderer
        # Folge sind ein anderer Stand.
        "migrationen_in_reihenfolge": [
            {"datei": f"migrations/{m.name}", "sha256": streuwert(f"migrations/{m.name}"),
             "hinterlegt": hinterlegte_summe(f"migrations/{m.stem}.sha256")}
            for m in migrationen],
        "seeds_in_reihenfolge": [
            {"datei": f"seeds/{s.name}", "sha256": streuwert(f"seeds/{s.name}")}
            for s in seeds],
    }


# ---------------------------------------------------------------------
# Glied 5 · Abhaengigkeitsstaende
# ---------------------------------------------------------------------
def glied5(dsn_teile):
    pg = None
    if shutil.which("psql"):
        pg = lauf("psql", "-tAqc", "SHOW server_version",
                  env={**os.environ, "PGCONNECT_TIMEOUT": "5"})
    return {
        "python": sys.version.split()[0],
        "requirements_txt_sha256": streuwert("requirements.txt"),
        "postgres_server_version": pg,
        # Ein Abbild-Digest fuer die ANWENDUNG gibt es nicht: sie laeuft
        # gegen das Python des Rechners, nicht in einem Behaelter. Nur die
        # Datenbank hat einen. Offener Punkt, ausgewiesen statt uebergangen.
        "abbild_digest_anwendung": None,
        "anmerkung_abbild": "Die Anwendung laeuft nicht in einem Behaelter; "
                            "ein Abbild-Digest besteht fuer sie nicht. "
                            "Offener Punkt zu K23-M18 Glied 5.",
    }


# ---------------------------------------------------------------------
# Glied 6 · Modell-, Prompt-, Wissens-, Richtlinien- und Vorlagenstand
# ---------------------------------------------------------------------
def glied6():
    # Tor 1c ruft kein Modell auf und liest keine Vorlage. Die Felder sind
    # deshalb LEER -- und das steht hier, statt dass sie fehlen. K23-M22
    # unterscheidet "nicht vorhanden" von "nicht gemessen"; hier ist es das
    # erste, und ab der ersten Vorschau wird daraus das zweite.
    return {
        "modellstand": None,
        "promptstand": None,
        "wissensstand": None,
        "richtlinienstand": None,
        "vorlagenstand": None,
        "anmerkung": "Dieser Lauf ruft kein Modell auf und liest keine Vorlage. "
                     "Die fuenf Staende sind leer, weil es sie in diesem Lauf "
                     "nicht gibt -- nicht, weil sie nicht gemessen wurden.",
    }


# ---------------------------------------------------------------------
# Glied 7 · Testwerkzeuge mit Version · Beginn und Ende · Umgebung
# ---------------------------------------------------------------------
def glied7(beginn, ende):
    return {
        "beginn": beginn,
        "ende": ende,
        "werkzeuge": {
            "psql": werkzeugfassung("psql", "--version"),
            "bash": werkzeugfassung("bash", "--version"),
            "curl": werkzeugfassung("curl", "--version"),
            "python3": werkzeugfassung("python3", "--version"),
            "uvicorn": werkzeugfassung(".venv/bin/uvicorn", "--version"),
            "shellcheck": werkzeugfassung("shellcheck", "--version"),
        },
        "umgebung": {
            "PGHOST": os.environ.get("PGHOST"),
            "PGPORT": os.environ.get("PGPORT"),
            "PGDATABASE": os.environ.get("PGDATABASE"),
            "rechner": os.uname().nodename if hasattr(os, "uname") else None,
            "system": f"{os.uname().sysname} {os.uname().release}"
                      if hasattr(os, "uname") else None,
            "in_ci": bool(os.environ.get("GITHUB_ACTIONS")),
            "ci_lauf": os.environ.get("GITHUB_RUN_ID"),
        },
        # PGPASSWORD steht bewusst NICHT hier (K23-D09).
    }


# ---------------------------------------------------------------------
# Glied 8 · Pruefsummen aller Eingaben und Ergebnisse
# ---------------------------------------------------------------------
def glied8(ergebnisdatei):
    eingaben = {}
    for muster in ("schema/*.sql", "migrations/*.sql", "seeds/*.sql",
                   "migrations/negativfaelle/*.sql", "pruefungen/migration/*.sql",
                   "pruefungen/klauseln/*", "pruefungen/lauf.sh",
                   "app/*.py", "app/vorlagen/*", "mail/*.py",
                   "requirements.txt", "CLAUDE.md"):
        for p in sorted(WURZEL.glob(muster)):
            if p.is_file():
                rel = str(p.relative_to(WURZEL))
                eingaben[rel] = streuwert(rel)
    return {
        "eingaben": eingaben,
        "anzahl_eingaben": len(eingaben),
        "ergebnisdatei_sha256": streuwert(ergebnisdatei) if ergebnisdatei else None,
        "manifest_sha256": "steht in der Nebendatei <manifest>.sha256 -- eine "
                           "Pruefsumme im Manifest kann nicht ueber das Manifest "
                           "gehen, sie waere Teil dessen, was sie sichert",
    }


def main():
    ap = argparse.ArgumentParser()
    ap.add_argument("--ziel", required=True)
    ap.add_argument("--ergebnisse", help="JSON-Datei mit den Einzelergebnissen")
    ap.add_argument("--beginn", help="ISO-Zeitpunkt des Laufbeginns")
    ap.add_argument("--lauf", default="Tor 1c")
    a = ap.parse_args()

    ergebnisse = None
    if a.ergebnisse and pathlib.Path(a.ergebnisse).is_file():
        try:
            ergebnisse = json.loads(pathlib.Path(a.ergebnisse).read_text())
        except json.JSONDecodeError as f:
            ergebnisse = {"fehler": f"Ergebnisdatei nicht lesbar: {f}"}

    jetzt = datetime.datetime.now(datetime.timezone.utc).isoformat(timespec="seconds")
    manifest = {
        "vorbemerkung": "Testmanifest nach K23-M18. Acht Glieder, jedes einzeln "
                        "gefuellt oder ausdruecklich leer. Die Pruefsumme ueber "
                        "dieses Manifest steht in der Nebendatei gleichen Namens "
                        "mit der Endung .sha256.",
        "lauf": a.lauf,
        "erstellt": jetzt,
        "glied_1_commit": glied1(),
        "glied_2_bauauftrag": glied2(),
        "glied_3_anlage": glied3(),
        "glied_4_migrationsstand": glied4(),
        "glied_5_abhaengigkeiten": glied5(None),
        "glied_6_modell_und_vorlagen": glied6(),
        "glied_7_werkzeuge_und_zeit": glied7(a.beginn, jetzt),
        "glied_8_pruefsummen": glied8(a.ergebnisse),
        "ergebnisse": ergebnisse,
    }

    ziel = pathlib.Path(a.ziel)
    ziel.parent.mkdir(parents=True, exist_ok=True)
    text = json.dumps(manifest, indent=2, ensure_ascii=False, sort_keys=False) + "\n"
    ziel.write_text(text, encoding="utf-8")

    neben = ziel.with_suffix(ziel.suffix + ".sha256")
    summe = hashlib.sha256(text.encode("utf-8")).hexdigest()
    neben.write_text(f"{summe}  {ziel.name}\n", encoding="utf-8")

    # Was fehlt, wird GENANNT -- ein Manifest mit stillen Luecken ist der
    # Anfang derselben Unsauberkeit, die es verhindern soll.
    leer = [k for k in ("glied_1_commit", "glied_2_bauauftrag", "glied_3_anlage")
            if not manifest[k].get("sha256", manifest[k].get("commit"))]
    print(f"Manifest: {ziel}")
    print(f"Pruefsumme: {neben}  ({summe[:16]}…)")
    if leer:
        print(f"::warning::Manifest unvollstaendig -- ohne Wert: {', '.join(leer)}")
    if not manifest["glied_1_commit"]["arbeitsbaum_sauber"]:
        print("::warning::Arbeitsbaum war nicht sauber -- der Commit-Hash "
              "beschreibt nicht den gelaufenen Stand (K23-M18 Glied 1).")
    return 0


if __name__ == "__main__":
    raise SystemExit(main())
