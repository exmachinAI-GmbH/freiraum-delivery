#!/usr/bin/env python3
"""FREIRAUM Coding-Harness · Herkunftsgraph nach K23-M03.

    python3 werkzeuge/herkunft.py [--isoliert] [--pflege-vorschlag <datei>]
                                  [--ziel <json>] [--markdown <md>]

Warum es diese Datei gibt
-------------------------
K23-M03 verlangt nicht "Funktion zeigt auf Quelle", sondern die ganze Kette:

    Quelle --> Klausel --> Umsetzung --> Test --> Nachweis

woertlich: "Jede Kante ist einzeln belegt. Eine Funktion, die auf eine Quelle
zeigt, ohne dass Umsetzung und Test dazwischen nachvollziehbar sind, erfuellt
K23-M03 nicht."

Der Graph ist Bedingung 4 des Tor II und einer der vier Nachweise, die ab
Scheibe 1 gefuehrt werden (Blatt 11:137). Bis heute war der Ordner
nachweise/herkunft/ leer -- die Bedingung hatte keinen Gegenstand.

Was dieses Werkzeug NICHT tut
-----------------------------
1. Es sperrt nichts. Eine fehlende Kante ist ein BEFUND, kein Sperrsignal.
   Wer sperrt, ist Tor II. Der Rueckgabewert ist 0, auch wenn der Graph
   Loecher hat -- sonst waere aus einem Nachweis eine selbstgebaute
   Abnahmebedingung geworden.

2. Es erfindet keine Kante. Wo ein Beleg fehlt, steht die Luecke im Bericht,
   nicht eine geratene Verbindung.

3. Es bewertet nicht, ob die Umsetzung richtig ist. Der Graph sagt, WER auf
   WEN zeigt, nicht ob es stimmt.

Zwei Kantenklassen, die nie vermischt werden duerfen
----------------------------------------------------
Klausel -> Umsetzung:
    ERKLAERT  Die Datei traegt eine Zeile "umsetzt: K##-M##". Das ist eine
              Aussage des Bauenden: "diese Datei setzt diese Klausel um."
              Nur diese Kante zaehlt.
    ERWAEHNT  Die Kennung kommt sonstwo in der Datei vor. Das ist KEINE
              Umsetzung. app/haupt.py nennt K03-M16 gerade, um zu sagen, dass
              hier NICHT danach gehandelt wird. Eine reine Textsuche haette
              das als Umsetzung gezaehlt -- deshalb die Trennung.

Klausel -> Test:
    GENANNT   Die Kennung steht im Quelltext eines Prueffalls. Ein Kommentar
              genuegt dafuer -- und ein Kommentar misst nichts.
    BELEGT    Der Prueffall ist in einem Berichtsprotokoll mit dem Zustand
              "bestanden" gelaufen. Erst das ist ein Beleg.

Die vier Zustaende bleiben, wie sie sind
-----------------------------------------
K23-M22: bestanden - fehlgeschlagen - gesperrt - nicht ausgefuehrt. Dieses
Werkzeug erzeugt keinen fuenften und deutet keinen um. "gesperrt" heisst
weiterhin: konnte nicht gemessen werden -- nicht "fehlt".
"""
import argparse
import json
import pathlib
import re
import sys

WURZEL = pathlib.Path(__file__).resolve().parent.parent

# Dieselbe Kennung wie in werkzeuge/triage.py. Bewusst dieselbe Zeile und
# nicht importiert: die beiden Werkzeuge sollen unabhaengig lauffaehig sein.
KLAUSEL_MUSTER = re.compile(r"\bK\d{2}-[MDG]\d{2}\b")

# "umsetzt:" in jeder Kommentarform, die im Repo vorkommt:
#   # umsetzt: K20-M07       Python, Shell
#   -- umsetzt: K02-M14      SQL
#   {# umsetzt: K19-M01 #}   Jinja
UMSETZT_MUSTER = re.compile(r"umsetzt\s*:", re.IGNORECASE)

# Bildschirmkennungen aus dem Vertrag: EN-01, EN-03a, EX-17
BILDSCHIRM_MUSTER = re.compile(r"\b(?:EN|EX)-\d{2}[a-z]?\b")

# Wo das GEBAUTE liegt. Bewusst ohne schema/ und seeds/: das sind
# mitgelieferte Kopien mit Aenderungsregel "keine", keine Umsetzung.
# Ohne werkzeuge/: das ist der Harness selbst, nicht das Produkt.
UMSETZUNGSORTE = ("app", "mail", "install", "migrations")
UMSETZUNGSENDUNGEN = {".py", ".sql", ".sh", ".html"}

# Ausgenommen, weil es keine Umsetzung dieses Baus ist:
#   _vorlaeufer/  was VOR diesem Bau lief -- mitgelieferte Kopie
#   _abgeloest/   was ersetzt wurde
# Beide tragen die Aenderungsregel "keine". Wer sie mitzaehlt, schreibt dem
# Bau eine Umsetzung zu, die er nicht geschrieben hat.
AUSGENOMMEN = ("/_vorlaeufer/", "/_abgeloest/")

# Die sieben Fragen nach isolierten Ergebnissen, in Anzeigereihenfolge.
FRAGEN = (
    "1_umsetzung_ohne_klausel",
    "2_klausel_mit_test_ohne_umsetzung",
    "3_umsetzung_ohne_belegten_test",
    "4_test_ohne_nachweis",
    "5_nachweis_ohne_test",
    "6_bildschirm_ohne_abbild",
    "7_toter_verweis",
)


def dateien(wurzel, orte, endungen):
    """Alle Dateien unter den genannten Ordnern mit den genannten Endungen."""
    gefunden = []
    for ort in orte:
        p = wurzel / ort
        if not p.is_dir():
            continue
        for d in p.rglob("*"):
            if not d.is_file() or d.suffix not in endungen:
                continue
            if any(a in "/" + str(d.relative_to(wurzel)) for a in AUSGENOMMEN):
                continue
            gefunden.append(d)
    return sorted(gefunden)


def lies(pfad):
    try:
        return pfad.read_text(encoding="utf-8", errors="replace")
    except OSError:
        return ""


# ---------------------------------------------------------------------
# Kante 1 · Quelle -> Klausel
# ---------------------------------------------------------------------
def kante_quelle_klausel(register):
    """Aus register.json, Feld `herkunft` = "<Konzeptdatei>:<Zeile>".

    Diese Kante ist die einzige, die heute schon vollstaendig belegt ist:
    der Extraktor hat sie beim Lesen der Konzepte mitgeschrieben.
    """
    kanten = []
    for z in register["zeilen"]:
        herkunft = z.get("herkunft") or ""
        kanten.append({
            "von": herkunft or "(ohne Fundstelle)",
            "nach": z["klausel"],
            "art": "quelle_klausel",
            "staerke": "belegt" if herkunft else "fehlt",
            "beleg": herkunft,
            "dokumentversion": z.get("dokumentversion", ""),
        })
    return kanten


# ---------------------------------------------------------------------
# Kante 2 · Klausel -> Umsetzung
# ---------------------------------------------------------------------
def kante_klausel_umsetzung(wurzel):
    """Getrennt nach `erklaert` (Zeile "umsetzt:") und `erwaehnt` (sonst).

    Rueckgabe: (kanten, dateien_ohne_klauselbezug)
    """
    kanten, ohne_bezug = [], []
    for pfad in dateien(wurzel, UMSETZUNGSORTE, UMSETZUNGSENDUNGEN):
        rel = str(pfad.relative_to(wurzel))
        text = lies(pfad)
        erklaert, erwaehnt = set(), set()

        for nr, zeile in enumerate(text.splitlines(), start=1):
            treffer = set(KLAUSEL_MUSTER.findall(zeile))
            if not treffer:
                continue
            if UMSETZT_MUSTER.search(zeile):
                for k in treffer:
                    erklaert.add((k, nr))
            else:
                for k in treffer:
                    erwaehnt.add((k, nr))

        erklaerte_kennungen = {k for k, _ in erklaert}
        for k, nr in sorted(erklaert):
            kanten.append({
                "von": k, "nach": rel, "art": "klausel_umsetzung",
                "staerke": "erklaert", "beleg": f"{rel}:{nr}",
            })
        for k, nr in sorted(erwaehnt):
            if k in erklaerte_kennungen:
                continue          # schon als erklaert gefuehrt
            kanten.append({
                "von": k, "nach": rel, "art": "klausel_umsetzung",
                "staerke": "erwaehnt", "beleg": f"{rel}:{nr}",
            })

        if not erklaert and not erwaehnt:
            ohne_bezug.append(rel)

    return kanten, ohne_bezug


# ---------------------------------------------------------------------
# Kante 3 · Klausel -> Test
# ---------------------------------------------------------------------
def kante_klausel_test(wurzel, belegte_laeufe):
    """`genannt` aus dem Quelltext, `belegt` aus einem bestandenen Lauf.

    belegte_laeufe: Menge relativer Pfade von Prueffaellen, die in einem
    Berichtsprotokoll mit Zustand "bestanden" gefuehrt sind.
    """
    kanten = []
    for pfad in dateien(wurzel, ("pruefungen",), {".sh", ".sql", ".py"}):
        rel = str(pfad.relative_to(wurzel))
        text = lies(pfad)
        for k in sorted(set(KLAUSEL_MUSTER.findall(text))):
            kanten.append({
                "von": k, "nach": rel, "art": "klausel_test",
                "staerke": "belegt" if rel in belegte_laeufe else "genannt",
                "beleg": rel,
            })
    return kanten


# ---------------------------------------------------------------------
# Kante 4 · Test -> Nachweis
# ---------------------------------------------------------------------
def kante_test_nachweis(wurzel):
    """Aus den Berichtsprotokollen unter nachweise/manifeste/.

    Ein Bericht fuehrt `ergebnisse[{kennung, zustand, anmerkung}]`. Die
    Kennung eines Klausel-Prueffalls ist der Dateiname ohne "_lauf.sh"; die
    Migrationsprueffaelle heissen "M30-Prueffaelle", die Negativfaelle
    "N1_..." bis "N4_...". Die Zuordnung wird ueber den Dateinamen gesucht --
    findet sie keinen, wird das ausgewiesen statt geraten.
    """
    kanten, belegte, ohne_zuordnung = [], set(), []
    ordner = wurzel / "nachweise" / "manifeste"
    if not ordner.is_dir():
        return kanten, belegte, ohne_zuordnung

    for bericht in sorted(ordner.glob("*.json")):
        if bericht.name.endswith("_manifest.json"):
            continue                      # das Manifest, nicht der Bericht
        try:
            b = json.loads(lies(bericht))
        except json.JSONDecodeError:
            continue
        if "ergebnisse" not in b:
            continue
        rel_bericht = str(bericht.relative_to(wurzel))

        for e in b["ergebnisse"]:
            kennung, zustand = e.get("kennung", ""), e.get("zustand", "")
            kandidaten = [
                f"pruefungen/klauseln/{kennung}_lauf.sh",
                f"pruefungen/klauseln/{kennung}_daten.sql",
            ]
            if kennung == "M30-Prueffaelle":
                kandidaten = ["pruefungen/migration/M30__pruefung.sql"]
            treffer = [k for k in kandidaten if (wurzel / k).is_file()]

            if not treffer:
                ohne_zuordnung.append({
                    "kennung": kennung, "zustand": zustand,
                    "bericht": rel_bericht,
                })
                continue
            for k in treffer:
                kanten.append({
                    "von": k, "nach": rel_bericht, "art": "test_nachweis",
                    "staerke": zustand, "beleg": f"{rel_bericht} · {kennung}",
                    "anmerkung": e.get("anmerkung", ""),
                })
                if zustand == "bestanden":
                    belegte.add(k)
    return kanten, belegte, ohne_zuordnung


# ---------------------------------------------------------------------
# Bildschirme · der Vertrag gegen das Gebaute
# ---------------------------------------------------------------------
def bildschirme(wurzel):
    """33 Kennungen aus schema/K19_screens.yaml gegen app/vorlagen/.

    Kein YAML-Leser: gelesen werden die Zeilen "- id: EN-01". Waere die
    Datei anders aufgebaut, faende dieses Werkzeug null Kennungen -- und
    meldete das, statt eine Zahl zu erfinden.

    ERKLAERT gegen ERWAEHNT -- derselbe Unterschied wie bei den Klauseln, und
    aus demselben gemessenen Grund: app/vorlagen/start.html sagt woertlich
    "DAS IST NICHT EN-02". Eine Vorlage, die eine Bildschirmkennung nur im
    Text nennt, ist nicht dieser Bildschirm. Als Abbild zaehlt nur:

      a) der Dateiname traegt die Kennung ("en01_anmeldung.html" -> EN-01), oder
      b) eine Zeile "bildschirm: EN-01" erklaert es ausdruecklich.

    Alles andere ist eine Erwaehnung und wird getrennt ausgewiesen.
    """
    quelle = wurzel / "schema" / "K19_screens.yaml"
    if not quelle.is_file():
        return [], {}, [], {}
    vertrag = []
    for zeile in lies(quelle).splitlines():
        m = re.match(r"\s*-\s*id:\s*(\S+)", zeile)
        if m and BILDSCHIRM_MUSTER.fullmatch(m.group(1)):
            vertrag.append(m.group(1))

    abbilder, erwaehnungen = {}, {}
    for pfad in dateien(wurzel, ("app",), {".html"}):
        rel = str(pfad.relative_to(wurzel))
        text = lies(pfad)

        # a) Dateiname: "en01_..." bzw. "ex17_..." -> EN-01 / EX-17
        aus_name = set()
        n = re.match(r"(en|ex)(\d{2})([a-z]?)_", pfad.name.lower())
        if n:
            aus_name.add(f"{n.group(1).upper()}-{n.group(2)}{n.group(3)}")
        # b) ausdrueckliche Zeile
        for zeile in text.splitlines():
            if re.search(r"bildschirm\s*:", zeile, re.IGNORECASE):
                aus_name |= set(BILDSCHIRM_MUSTER.findall(zeile))

        for k in sorted(aus_name):
            abbilder.setdefault(k, []).append(rel)
        for k in sorted(set(BILDSCHIRM_MUSTER.findall(text)) - aus_name):
            erwaehnungen.setdefault(k, []).append(rel)

    ohne_abbild = [k for k in vertrag if k not in abbilder]
    return vertrag, abbilder, ohne_abbild, erwaehnungen


# ---------------------------------------------------------------------
# Die sechs Fragen nach der Einsamkeit
# ---------------------------------------------------------------------
def isolation(kanten, register, ohne_bezug, vertrag, abbilder, ohne_abbild,
              berichte_ohne_zuordnung, bildschirm_erwaehnungen, kritisch):
    alle = {z["klausel"] for z in register["zeilen"]}

    roh_umgesetzt = {k["von"] for k in kanten
                     if k["art"] == "klausel_umsetzung" and k["staerke"] == "erklaert"}
    roh_erwaehnt = {k["von"] for k in kanten
                    if k["art"] == "klausel_umsetzung" and k["staerke"] == "erwaehnt"}

    # Tote Verweise: eine Kennung, die kein Register kennt. Sie darf nicht in
    # die Zaehlung -- sonst zaehlt der Graph eine Anforderung mit, die es
    # nicht gibt. Sie verschwindet aber auch nicht: sie ist ein eigener Befund.
    tote = sorted((roh_umgesetzt | roh_erwaehnt) - alle)
    tote_belege = sorted({k["beleg"] for k in kanten
                          if k["art"] == "klausel_umsetzung" and k["von"] in set(tote)})

    umgesetzt = roh_umgesetzt & alle
    erwaehnt = roh_erwaehnt & alle
    getestet = {k["von"] for k in kanten if k["art"] == "klausel_test"} & alle
    belegt = {k["von"] for k in kanten
              if k["art"] == "klausel_test" and k["staerke"] == "belegt"} & alle

    testdateien = {k["nach"] for k in kanten if k["art"] == "klausel_test"}
    gelaufen = {k["von"] for k in kanten if k["art"] == "test_nachweis"}

    return {
        "7_toter_verweis": {
            "frage": "Welche genannte Kennung gehört zu keiner bekannten Anforderung?",
            "anzahl": len(tote),
            "eintraege": tote,
            "fundstellen": tote_belege,
        },
        "1_umsetzung_ohne_klausel": {
            "frage": "Welche gebaute Datei sagt nicht, wofür sie da ist?",
            "anzahl": len(ohne_bezug),
            "eintraege": ohne_bezug,
        },
        "2_klausel_mit_test_ohne_umsetzung": {
            "frage": "Was wird gemessen, das niemand gebaut hat?",
            "anzahl": len(sorted(getestet - umgesetzt - erwaehnt)),
            "eintraege": sorted(getestet - umgesetzt - erwaehnt),
        },
        "3_umsetzung_ohne_belegten_test": {
            "frage": "Welche gebaute Anforderung prüft niemand?",
            "anzahl": len(sorted((umgesetzt | erwaehnt) - belegt)),
            "eintraege": sorted((umgesetzt | erwaehnt) - belegt),
        },
        "4_test_ohne_nachweis": {
            "frage": "Welcher Prüffall ist noch nie in einem Protokoll gelaufen?",
            "anzahl": len(sorted(testdateien - gelaufen)),
            "eintraege": sorted(testdateien - gelaufen),
        },
        "5_nachweis_ohne_test": {
            "frage": "Welches Protokoll führt eine Kennung ohne Prüffall?",
            "anzahl": len(berichte_ohne_zuordnung),
            "eintraege": berichte_ohne_zuordnung,
        },
        "6_bildschirm_ohne_abbild": {
            "frage": "Welcher Bildschirm des Vertrags ist nicht gebaut?",
            "anzahl": len(ohne_abbild),
            "von": len(vertrag),
            "eintraege": ohne_abbild,
            "nur_erwaehnt": bildschirm_erwaehnungen,
        },
        "_zahlen": {
            "klauseln_gesamt": len(alle),
            "vom_code_genannt": len(umgesetzt | erwaehnt),
            "davon_erklaert": len(umgesetzt),
            "davon_nur_erwaehnt": len(erwaehnt - umgesetzt),
            "vom_code_genannt_mit_test": len((umgesetzt | erwaehnt) & getestet),
            "vom_code_genannt_ohne_test": len((umgesetzt | erwaehnt) - getestet),
            "vom_code_genannt_ohne_belegten_test": len((umgesetzt | erwaehnt) - belegt),
            # Die Zahl, auf die es ankommt: gebaut, als kritisch vorgeschlagen,
            # von keinem Prueffall gemessen. Leer, wenn keine Triage vorliegt.
            "vom_code_genannt_kritisch_ohne_test":
                len(((umgesetzt | erwaehnt) & kritisch) - getestet) if kritisch else None,
            "kritisch_laut_triage": len(kritisch) if kritisch else None,
            "tote_verweise": len(tote),
            "bildschirme_im_vertrag": len(vertrag),
            "bildschirme_mit_abbild": len(abbilder),
            "bildschirme_nur_erwaehnt": len(bildschirm_erwaehnungen),
        },
    }


def kritikalitaet(wurzel):
    """Vorschlag aus der Triage, wenn sie vorliegt -- sonst leer.

    Die Einstufung stammt aus werkzeuge/triage.py und ist ausdruecklich ein
    VORSCHLAG (K23-G08 verbietet der Maschine die Feststellung). Sie wird hier
    nur benutzt, um die eine Zahl zu bilden, auf die es ankommt: gebaut,
    kritisch, ungeprueft. Fehlt die Triage, bleibt die Zahl leer statt geraten.
    """
    p = wurzel / "nachweise" / "klauselregister" / "triage.json"
    if not p.is_file():
        return set()
    try:
        t = json.loads(lies(p))
    except json.JSONDecodeError:
        return set()
    return {z["klausel"] for z in t.get("zeilen", [])
            if z.get("vorschlag_kritikalitaet") == "kritisch"}


def bauen(wurzel, register_pfad):
    register = json.loads(lies(pathlib.Path(register_pfad)))

    k_test_nachweis, belegte_laeufe, ohne_zuordnung = kante_test_nachweis(wurzel)
    k_quelle = kante_quelle_klausel(register)
    k_umsetzung, ohne_bezug = kante_klausel_umsetzung(wurzel)
    k_test = kante_klausel_test(wurzel, belegte_laeufe)
    vertrag, abbilder, ohne_abbild, bs_erwaehnt = bildschirme(wurzel)

    kanten = k_quelle + k_umsetzung + k_test + k_test_nachweis

    return {
        "vorbemerkung":
            "Herkunftsgraph nach K23-M03, Bedingung 4 des Tor II. Jede Kante "
            "traegt ihren Beleg. Eine fehlende Kante ist ein Befund, kein "
            "Sperrsignal -- wer sperrt, ist Tor II. Die Staerke einer Kante "
            "wird nie geraten: 'erklaert' verlangt eine Zeile 'umsetzt:', "
            "'belegt' verlangt einen bestandenen Lauf in einem Protokoll.",
        "grundlage": "K23-M03 · Quelle -> Klausel -> Umsetzung -> Test -> Nachweis",
        "register": str(pathlib.Path(register_pfad).name),
        "register_erzeugt": register.get("erzeugt"),
        "kanten": kanten,
        "bildschirme": {
            "im_vertrag": vertrag,
            "abbilder": abbilder,
            "ohne_abbild": ohne_abbild,
            "nur_erwaehnt": bs_erwaehnt,
        },
        "isolation": isolation(kanten, register, ohne_bezug, vertrag,
                               abbilder, ohne_abbild, ohne_zuordnung,
                               bs_erwaehnt, kritikalitaet(wurzel)),
    }


# ---------------------------------------------------------------------
# Lesbare Sicht
# ---------------------------------------------------------------------
def markdown(g):
    z = g["isolation"]["_zahlen"]
    i = g["isolation"]
    t = [
        "# Herkunftsgraph — `Quelle → Klausel → Umsetzung → Test → Nachweis`",
        "",
        "Erzeugt von `werkzeuge/herkunft.py`. **Nicht von Hand pflegen.**",
        "",
        "Dieser Nachweis ist nach K23-M03 vorgeschrieben — der Klausel, die verlangt, dass",
        "jede Anforderung von ihrer Quelle bis zu ihrem Nachweis lückenlos verfolgbar ist —",
        "und er ist **Bedingung 4 der technischen Lieferabnahme (Tor II)**.",
        "",
        "**Er sperrt nichts.** Eine fehlende Kante ist ein Befund. Wer sperrt, ist Tor II.",
        "",
        "## Die Zahlen",
        "",
        "| | Anzahl |",
        "|---|---|",
        f"| Anforderungen insgesamt | {z['klauseln_gesamt']} |",
        f"| **vom gebauten Code genannt** | **{z['vom_code_genannt']}** |",
        f"| davon ausdrücklich als umgesetzt erklärt (`umsetzt:`) | {z['davon_erklaert']} |",
        f"| davon nur nebenbei erwähnt | {z['davon_nur_erwaehnt']} |",
        f"| vom Code genannt **und** von einem Prüffall gemessen | {z['vom_code_genannt_mit_test']} |",
        f"| **vom Code genannt und von niemandem gemessen** | **{z['vom_code_genannt_ohne_test']}** |",
    ]
    if z["vom_code_genannt_kritisch_ohne_test"] is not None:
        t += [
            f"| **davon als kritisch vorgeschlagen** | **{z['vom_code_genannt_kritisch_ohne_test']}** |",
        ]
    t += [
        f"| Bildschirme im Vertrag | {z['bildschirme_im_vertrag']} |",
        f"| davon gebaut | {z['bildschirme_mit_abbild']} |",
        "",
        "Die Zeile *davon als kritisch vorgeschlagen* ist die, auf die es ankommt:",
        "**gebaut, als kritisch eingestuft, von niemandem geprüft.** Die Einstufung",
        "*kritisch* ist ein Vorschlag aus der Triage, keine Feststellung — die trifft",
        "ein Mensch.",
        "",
        "**Der Unterschied zwischen *erklärt* und *erwähnt*, und warum er wichtig ist:**",
        "Eine Datei gilt erst dann als Umsetzung einer Anforderung, wenn sie eine Zeile",
        "`umsetzt:` mit der Kennung trägt. Kommt die Kennung nur irgendwo im Text vor,",
        "zählt sie nicht — denn `app/haupt.py` nennt eine Anforderung gerade, um zu sagen,",
        "dass hier **nicht** danach gehandelt wird. Eine reine Textsuche hätte das als",
        "Umsetzung gezählt und den Graphen zum Lügen gebracht.",
        "",
        "## Die sieben Fragen nach isolierten Ergebnissen",
        "",
        "| | Frage | Anzahl |",
        "|---|---|---|",
    ]
    for schluessel in FRAGEN:
        e = i[schluessel]
        t.append(f"| {schluessel[0]} | {e['frage']} | **{e['anzahl']}** |")

    t += ["", "### Im Einzelnen", ""]
    for schluessel in FRAGEN:
        e = i[schluessel]
        t += [f"**{schluessel[0]} · {e['frage']}** — {e['anzahl']} Einträge", ""]
        if not e["eintraege"]:
            t += ["*keine*", ""]
            continue
        for x in e["eintraege"][:40]:
            t.append(f"- `{x}`" if isinstance(x, str) else f"- {x}")
        if len(e["eintraege"]) > 40:
            t.append(f"- … und {len(e['eintraege']) - 40} weitere (vollständig in `herkunft.json`)")
        t.append("")

    t += [
        "## Was hier nicht steht",
        "",
        "**Keine Bewertung.** Der Graph sagt, wer auf wen zeigt — nicht, ob es stimmt.",
        "",
        "**Keine erfundene Kante.** Wo ein Beleg fehlt, steht die Lücke, nicht eine",
        "geratene Verbindung.",
        "",
        "**Keine Sperre.** Der Rückgabewert ist immer 0, auch bei Löchern. Ein Nachweis,",
        "der sperrt, wäre eine selbstgebaute Abnahmebedingung — und die Anlage sagt",
        "ausdrücklich, dass eine Verletzung von Steuerungsregeln ein Projektbefund ist,",
        "niemals eine zusätzliche Abnahmebedingung.",
        "",
    ]
    return "\n".join(t) + "\n"


# ---------------------------------------------------------------------
# Vorschlag fuer die Pflegedatei
# ---------------------------------------------------------------------
def pflege_vorschlag(g):
    """Fuellt die vier MESSfelder des Klauselregisters aus dem Graphen.

    Nicht gefuellt werden `eigentuemer`, `kritikalitaet` und
    `akzeptanzkriterium` -- die kommen nach K23-M02 vom fachlichen
    Eigentuemer, also von einem Menschen. Ein Werkzeug, das sie ausdaechte,
    liesse den Bau gegen eine erfundene Erwartung pruefen.
    """
    je_klausel = {}
    for k in g["kanten"]:
        if k["art"] != "klausel_test":
            continue
        e = je_klausel.setdefault(k["von"], {"tests": [], "belegt": False})
        e["tests"].append(k["nach"])
        if k["staerke"] == "belegt":
            e["belegt"] = True

    nachweise = {}
    for k in g["kanten"]:
        if k["art"] == "test_nachweis":
            nachweise.setdefault(k["von"], []).append(k["beleg"])

    vorschlag = {}
    for klausel, e in sorted(je_klausel.items()):
        evidenz = sorted({b for t in e["tests"] for b in nachweise.get(t, [])})
        vorschlag[klausel] = {
            "test": " · ".join(sorted(set(e["tests"]))),
            "teststand": "belegt" if e["belegt"] else "genannt, nicht belegt",
            "ergebnis": "bestanden" if e["belegt"] else "nicht ausgefuehrt",
            "evidenz": " · ".join(evidenz) if evidenz
                       else "kein Protokoll fuehrt diesen Lauf",
        }
    return vorschlag


def main():
    ap = argparse.ArgumentParser(
        description="Herkunftsgraph nach K23-M03 erzeugen")
    ap.add_argument("--register",
                    default=str(WURZEL / "nachweise/klauselregister/register.json"))
    ap.add_argument("--ziel",
                    default=str(WURZEL / "nachweise/herkunft/herkunft.json"))
    ap.add_argument("--markdown",
                    default=str(WURZEL / "nachweise/herkunft/herkunft.md"))
    ap.add_argument("--isoliert", action="store_true",
                    help="nur die sechs Fragen nach isolierten Ergebnissen melden")
    ap.add_argument("--pflege-vorschlag", metavar="DATEI",
                    help="Vorschlag fuer die vier Messfelder des Registers schreiben")
    a = ap.parse_args()

    if not pathlib.Path(a.register).is_file():
        print(f"::error::Klauselregister nicht gefunden: {a.register}",
              file=sys.stderr)
        print("   Naechster Schritt: python3 werkzeuge/klauselregister.py "
              "--konzepte <ordner> --ziel " + a.register, file=sys.stderr)
        return 2

    g = bauen(WURZEL, a.register)
    z = g["isolation"]["_zahlen"]

    if not a.isoliert:
        ziel = pathlib.Path(a.ziel)
        ziel.parent.mkdir(parents=True, exist_ok=True)
        with ziel.open("w", encoding="utf-8") as d:
            json.dump(g, d, indent=2, ensure_ascii=False)
            d.write("\n")
        with pathlib.Path(a.markdown).open("w", encoding="utf-8") as d:
            d.write(markdown(g))

    if a.pflege_vorschlag:
        p = pathlib.Path(a.pflege_vorschlag)
        p.parent.mkdir(parents=True, exist_ok=True)
        with p.open("w", encoding="utf-8") as d:
            json.dump(pflege_vorschlag(g), d, indent=2, ensure_ascii=False)
            d.write("\n")
        print(f"Pflegevorschlag: {p}")

    print("Herkunftsgraph nach K23-M03")
    print(f"  Anforderungen gesamt:            {z['klauseln_gesamt']}")
    print(f"  vom gebauten Code genannt:       {z['vom_code_genannt']}"
          f"  (erklaert {z['davon_erklaert']} · nur erwaehnt {z['davon_nur_erwaehnt']})")
    print(f"  davon mit Prueffall:             {z['vom_code_genannt_mit_test']}")
    print(f"  DAVON OHNE PRUEFFALL:            {z['vom_code_genannt_ohne_test']}")
    if z["vom_code_genannt_kritisch_ohne_test"] is not None:
        print(f"  davon KRITISCH ohne Prueffall:   "
              f"{z['vom_code_genannt_kritisch_ohne_test']}"
              f"  (Kritikalitaet: Vorschlag der Triage, keine Feststellung)")
    print(f"  Bildschirme im Vertrag:          {z['bildschirme_im_vertrag']}"
          f"  · gebaut: {z['bildschirme_mit_abbild']}")
    print()
    for s in FRAGEN:
        e = g["isolation"][s]
        print(f"  {s[0]} {e['frage']:<66} {e['anzahl']}")
    if not a.isoliert:
        print(f"\n{a.ziel}\n{a.markdown}")
    # Immer 0: eine fehlende Kante ist ein Befund, kein Sperrsignal.
    return 0


if __name__ == "__main__":
    sys.exit(main())
