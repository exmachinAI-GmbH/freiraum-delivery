#!/usr/bin/env python3
"""
Wortmarken -- das Stichwortverzeichnis zum Faden einer Scheibe.

Wozu
----
Der Klauselschnitt einer Scheibe (Anlage Bauverfahren, Schritt 1) verlangt die
BENANNTEN Klauseln, nie "lies alles". Welche Klausel zu welcher Scheibe gehoert,
ist heute nicht festgelegt -- .claude/commands/scheibe.md:31 sagt dazu woertlich:
"Die Zuordnung Klausel -> Scheibe existiert heute nicht ... Der Harness erfindet
sie nicht."

Dieses Werkzeug erfindet sie auch nicht. Es schreibt ein STICHWORTVERZEICHNIS:
je Station des gezeichneten Fadens die Klauseln, deren Wortlaut den Begriff der
Station nennt. Ein Mensch schneidet daran entlang.

Was dieses Werkzeug NICHT tut
-----------------------------
1. Es nennt KEINE Scheibe. Nirgends in der Ausgabe steht "Scheibe 1" als Aussage
   ueber eine Klausel. Ein Worttreffer belegt, dass ein Wort an zwei Stellen
   steht -- nicht, dass die Klausel zu dieser Scheibe gehoert. Deshalb heisst das
   Feld `leseanlass` und nicht `vorschlag`, und deshalb gibt es keine Spalte
   "Scheibe".

2. Es entscheidet nicht, welcher Begriff taugt. Es MISST, welcher Begriff nicht
   unterscheidet: geht die Trefferliste eines Begriffs vollstaendig in einer
   Gruppe aus triage.json auf, dann trennt er nichts, sondern benennt eine
   Querschnittseigenschaft, die ohnehin in jeder Scheibe gilt. Das Werkzeug
   vermerkt das und ueberlaesst das Streichen dem Menschen.

3. Es sperrt nichts. Es meldet Zahlen. Wer sperrt, ist ein Mensch.

Fail-closed
-----------
Trifft ein Stationsbegriff keinen einzigen Wortlaut, wird das AUSGEWIESEN, nicht
verschwiegen -- es heisst dann, dass die Maschine zu dieser Station nichts
beitraegt, nicht dass die Station leer ist. Genau dieser Fall tritt ein.

Die Stationen stammen woertlich aus dem Fadendiagramm der Anlage Baustrategie,
Zeilen 52 bis 70, gez. 05.08.2026. Sie sind abgeschrieben, nicht ausgedacht; je
Station steht ihr Zeilenanker daneben.
"""

import argparse
import json
import re
import sys
from pathlib import Path

# --- Die Stationen des Fadens, abgeschrieben aus BS:52-70 ---------------------
# (Begriff-Kennung, Suchmuster, Zeilenanker, Zeile im Wortlaut)
STATIONEN = [
    ("Mandant",            r"Mandant",                    "BS:53", "EXMA-Minimum: Mandant anlegen"),
    ("Einladungsschranke", r"Einladungsschranke",         "BS:53", "EXMA-Minimum: ... Einladungsschranke"),
    ("Einladung",          r"Einladung",                  "BS:53", "EXMA-Minimum: ... Einladung senden"),
    ("Anmeldecode",        r"Anmeldecode",                "BS:55", "Einladung kommt an ... Anmeldecode"),
    ("Anmeldung",          r"Anmeldung",                  "BS:55", "... Anmeldecode > Anmeldung"),
    ("Kenntnisnahme",      r"Kenntnisnahme",              "BS:56", "der Portal-Hinweis nach L9: NACHWEISBARE Kenntnisnahme"),
    ("Vorpruefung",        r"Vorpr[uü]fung",              "BS:57", "Vorpruefung: ein geeigneter Fall -> GEEIGNET"),
    ("geeignet",           r"geeignet",                   "BS:57", "... ein geeigneter Fall -> GEEIGNET"),
    ("Zweckbestimmung",    r"Zweckbestimmung",            "BS:59", "ZWECKBESTIMMUNG bestaetigt (Riegel)"),
    ("Anwendung",          r"Anwendung",                  "BS:61", "create_app_after_fit -- der EINE Weg"),
    ("Gespraech",          r"Gespr[aä]ch",                "BS:63", "ein Gespraechspfad (Stufen 01-02)"),
    ("Anforderungen",      r"Anforderung",                "BS:63", "... > Anforderungen/Vertrag (Stufe 03)"),
    ("Vertrag",            r"Vertrag",                    "BS:63", "... Anforderungen/Vertrag (Stufe 03)"),
    ("Prototyp",           r"Prototyp",                   "BS:65", "Prototyp aus EINER freigegebenen Vorlage"),
    ("Vorlage",            r"Vorlage",                    "BS:65", "... aus EINER freigegebenen Vorlage (Stufe 04)"),
    ("Angebot",            r"Angebot",                    "BS:67", "Angebot, Stufe 05"),
    ("Unterschrift",       r"Unterschrift",               "BS:67", "UNTERSCHRIFT + BEIDE HAEKCHEN > SIEGEL"),
    ("Haekchen",           r"H[aä]kchen",                 "BS:67", "UNTERSCHRIFT + BEIDE HAEKCHEN"),
    ("Siegel",             r"Siegel",                     "BS:67", "... > SIEGEL (Riegel)"),
    ("Uebergabe",          r"[UÜ]bergabe",                "BS:69", "das Uebergabe-Paket"),
    ("Manifest",           r"Manifest",                   "BS:69", "... mit Manifest- und Archivpruefsumme"),
    ("Pruefsumme",         r"Pr[uü]fsumme",               "BS:69", "... Manifest- und Archivpruefsumme"),
]

GRUPPEN = ("sicherheitskritisch", "mandantenkritisch", "freigabekritisch",
           "aufbewahrungskritisch", "wiederherstellungskritisch")


def laden(pfad, was):
    p = Path(pfad)
    if not p.is_file():
        print("GESPERRT: %s nicht gefunden (%s)" % (pfad, was), file=sys.stderr)
        raise SystemExit(2)
    return json.loads(p.read_text(encoding="utf-8"))


def treffer(zeilen, muster):
    """Alle Klauseln, deren Wortlaut das Muster enthaelt -- mit Fundstelle."""
    m = re.compile(muster + r"\w*", re.IGNORECASE)
    aus = []
    for z in zeilen:
        f = m.search(z["wortlaut"])
        if f:
            aus.append({"klausel": z["klausel"], "konzept": z["konzept"],
                        "begriff": f.group(0), "stelle": f.start()})
    return aus


def gruppen_von(triage):
    """Klauselmengen der fuenf Kritikalitaetsgruppen aus triage.json."""
    aus = {g: set() for g in GRUPPEN}
    for z in triage["zeilen"]:
        for g in (z.get("gruppen") or []):
            if g in aus:
                aus[g].add(z["klausel"])
    return aus


def unterscheidet_nicht(kl, gruppen):
    """Geht die Trefferliste ganz in einer Gruppe auf, trennt der Begriff nichts."""
    if not kl:
        return None
    for g, menge in gruppen.items():
        if kl <= menge:
            return g
    return None


def main():
    p = argparse.ArgumentParser(description=__doc__.split("\n")[1])
    p.add_argument("--register", default="nachweise/klauselregister/register.json")
    p.add_argument("--triage", default="nachweise/klauselregister/triage.json")
    p.add_argument("--ziel", default="nachweise/klauselschnitt")
    p.add_argument("--scheibe", default="1")
    a = p.parse_args()

    reg = laden(a.register, "Klauselregister")
    tri = laden(a.triage, "Triage")
    zeilen = reg["zeilen"]
    gruppen = gruppen_von(tri)

    ergebnis, alle = [], set()
    for kennung, muster, anker, wortlaut in STATIONEN:
        tr = treffer(zeilen, muster)
        kl = {t["klausel"] for t in tr}
        alle |= kl
        ergebnis.append({
            "station": kennung,
            "anker": anker,
            "zeile_im_faden": wortlaut,
            "muster": muster,
            "treffer": len(tr),
            "konzepte": sorted({t["konzept"] for t in tr}),
            "geht_auf_in": unterscheidet_nicht(kl, gruppen),
            "leseanlaesse": tr,
        })

    kopf = {
        "vorbemerkung": (
            "Stichwortverzeichnis, keine Zuordnung. Ein Worttreffer belegt, dass ein "
            "Wort an zwei Stellen steht -- nicht, dass die Klausel zu dieser Scheibe "
            "gehoert. Dieses Verzeichnis nennt deshalb nirgends eine Scheibe. "
            "'geht_auf_in' heisst: die Trefferliste dieses Begriffs steckt vollstaendig "
            "in einer Querschnittsgruppe, der Begriff unterscheidet also nichts -- "
            "das Streichen entscheidet ein Mensch."
        ),
        "grundlage": "Anlage Baustrategie, Fadendiagramm Z. 52-70, gez. 05.08.2026",
        "scheibe": a.scheibe,
        "register_erzeugt": reg.get("erzeugt"),
        "klauseln_gesamt": len(zeilen),
        "beruehrt_insgesamt": len(alle),
        "stationen": ergebnis,
    }

    ziel = Path(a.ziel)
    ziel.mkdir(parents=True, exist_ok=True)
    (ziel / ("S%s_wortmarken.json" % a.scheibe)).write_text(
        json.dumps(kopf, ensure_ascii=False, indent=2) + "\n", encoding="utf-8")

    # --- Markdown-Sicht -------------------------------------------------------
    z = ["# Stichwortverzeichnis zum Faden der Scheibe %s" % a.scheibe, "",
         "**Vorschlag ist das hier nicht.** Ein Worttreffer belegt, dass ein Wort an",
         "zwei Stellen steht -- nicht, dass die Regel zu dieser Scheibe gehoert.",
         "Deshalb steht in diesem Verzeichnis nirgends eine Scheibennummer.", "",
         "Grundlage: Anlage Baustrategie, Fadendiagramm Zeilen 52 bis 70,",
         "gezeichnet am 05.08.2026. Die Stationen sind abgeschrieben, nicht ausgedacht.", "",
         "| Station | Zeile im Faden | Treffer | Konzepte | unterscheidet |",
         "|---|---|---:|---:|---|"]
    for e in ergebnis:
        u = ("**nein** -- steckt ganz in *%s*" % e["geht_auf_in"]) if e["geht_auf_in"] else (
            "keine Treffer" if e["treffer"] == 0 else "ja")
        z.append("| **%s** | %s (%s) | %d | %d | %s |"
                 % (e["station"], e["zeile_im_faden"], e["anker"],
                    e["treffer"], len(e["konzepte"]), u))
    z += ["", "**Insgesamt beruehrt: %d von %d Regeln.**" % (len(alle), len(zeilen)), "",
          "## Was hier NICHT steht", "",
          "- keine Scheibenzuordnung -- die trifft ein Mensch",
          "- keine Kritikalitaet und kein Akzeptanzkriterium",
          "- keine Quote und kein Zielwert (F34)", "",
          "## Zu entscheiden", "",
          "Die mit *unterscheidet: nein* gekennzeichneten Begriffe benennen eine",
          "Eigenschaft, die in jeder Scheibe gilt. Sie als Leseanlass fuer diese eine",
          "Scheibe zu fuehren, waere irrefuehrend. Ob sie gestrichen werden,",
          "entscheidet M. Veil -- nicht dieses Werkzeug.", ""]
    for e in ergebnis:
        if e["geht_auf_in"]:
            z.append("- **%s** (%d Treffer) steckt vollstaendig in *%s*"
                     % (e["station"], e["treffer"], e["geht_auf_in"]))
    leer = [e["station"] for e in ergebnis if e["treffer"] == 0]
    if leer:
        z += ["", "Ohne jeden Treffer -- die Maschine traegt hier nichts bei:",
              "", "- " + " · ".join(leer), ""]
    (ziel / ("S%s_wortmarken.md" % a.scheibe)).write_text("\n".join(z) + "\n", encoding="utf-8")

    print("Stichwortverzeichnis Scheibe %s: %d Stationen, %d von %d Regeln beruehrt"
          % (a.scheibe, len(ergebnis), len(alle), len(zeilen)))
    for e in ergebnis:
        if e["geht_auf_in"]:
            print("  HINWEIS %s unterscheidet nicht -- ganz in %s" % (e["station"], e["geht_auf_in"]))
        if e["treffer"] == 0:
            print("  HINWEIS %s ohne Treffer -- die Maschine traegt hier nichts bei" % e["station"])
    return 0


if __name__ == "__main__":
    raise SystemExit(main())
