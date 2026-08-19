#!/usr/bin/env python3
"""Erzeugt das Sichtblatt zur Zeichnung der M5-Akzeptanzkriterien.

    python3 nachweise/klauselregister/M5_sichtblatt_erzeugen.py [--ziel <md>]

Es erfindet nichts: Wortlaut und Herkunft kommen aus register.json, Kriterium und
Eigentuemer aus pflege.json, die Klausellage aus M5_klausellage_260819.json, die
Ergaenzungen aus den beiden M5_ergaenzungen_*.json. Die Spalte "Gegenprobe" kommt
aus M5_gegenprobe_verdikte_260819.json (je Klausel: "gehalten" oder "ersetzt · <Mangelart>",
erzeugt aus den Laeufen der Gegenprobe vom 19.08.2026) -- fehlt die Datei, bleibt der Vermerk
leer statt geraten.

Sortiert wird nach dem, was den Leser Zeit kostet:
  1. Kriterien OHNE Massstab (NICHT ABLEITBAR) -- sie brauchen eine Lieferung,
     keine Unterschrift.
  2. Bestandskriterien vom 16.08.2026, die fuer M5 zu eng sind -- zwei Teile.
  3. Der Rest, nach Konzept.
"""
import argparse
import json
import textwrap
from pathlib import Path

HIER = Path(__file__).resolve().parent
MARKE = "⟨VORSCHLAG · NICHT GEZEICHNET⟩"


def lies(name, vorgabe=None):
    p = HIER / name
    if not p.exists():
        return vorgabe
    return json.loads(p.read_text(encoding="utf-8"))


def kriterium(k, pflege, reg):
    return (pflege.get(k, {}).get("akzeptanzkriterium") or reg[k]["akzeptanzkriterium"]).strip()


def eigentuemer(k, pflege, reg):
    return (pflege.get(k, {}).get("eigentuemer") or reg[k]["eigentuemer"]).strip()


# Die Zelle ist EIN langer String. Zum Lesen wird sie an ihren eigenen
# Abschnittsmarken umbrochen und weich auf Zeilenbreite gebracht -- massgeblich
# bleibt der Eintrag in pflege.json, nicht diese Ansicht.
SCHNITT = ["ERFUELLT WENN:", "NICHT ABLEITBAR:", "BESTAND PRUEFEN:", "GEMESSEN DURCH:",
           "· Quelle:", "· Stufe:", "· K23-M02:", "· Erzeugt am", "⟨zeichnet:"]


def lesbar(text, breite=96):
    t = text.replace(MARKE, MARKE + "\n").strip()
    for marke in SCHNITT:
        t = t.replace(" " + marke, "\n" + marke).replace("\n " + marke, "\n" + marke)
    zeilen = []
    for zeile in t.split("\n"):
        zeile = zeile.strip()
        if not zeile:
            continue
        zeilen.extend(textwrap.wrap(zeile, breite, break_long_words=False,
                                    subsequent_indent="  ") or [""])
    return "\n".join(zeilen)


def block(k, reg, text, marker, ergaenzung=None):
    r = reg[k]
    quelle = r["herkunft"].split(":")[-1]
    aus = [f"### {k} · {r['art']}",
           "",
           f"> {r['wortlaut']}",
           "",
           f"*Konzept {r['konzept']}, Zeile {quelle} · {marker}*",
           "",
           "**Vorgeschlagenes Kriterium**",
           "",
           "```",
           lesbar(text),
           "```",
           ""]
    if ergaenzung:
        aus += ["**Ergänzung für M5** — der Eintrag oben bleibt stehen, dies kommt hinzu:",
                "", "```", lesbar(ergaenzung), "```", ""]
    if text.startswith("⟨GEZEICHNET⟩"):
        aus += ["`x gezeichnet · A. Han · 19.08.2026` — eingetragen auf Weisung, "
                "Wortlaut in der Zelle", "", "---", ""]
    else:
        aus += ["`☐ gezeichnet   ☐ geändert (Wortlaut unten)   ☐ zurück an den Harness`",
                "", "---", ""]
    return "\n".join(aus)


def main():
    p = argparse.ArgumentParser()
    p.add_argument("--ziel", default=str(HIER / "M5_zeichnung_A-Han_260819.md"))
    a = p.parse_args()

    reg = {r["klausel"]: r for r in lies("register.json")["zeilen"]}
    pflege = lies("pflege.json")
    menge = lies("M5_klausellage_260819.json")["klauseln"]
    erg_best = lies("M5_ergaenzungen_bestand_260819.json", {})
    erg_nach = lies("M5_ergaenzungen_nachtrag10_260819.json", {})
    verdikte = lies("M5_gegenprobe_verdikte_260819.json", {})

    meine = [k for k in menge if eigentuemer(k, pflege, reg).startswith("Auftragnehmer")]
    ohne_massstab = [k for k in meine if "NICHT ABLEITBAR" in kriterium(k, pflege, reg)]
    zu_eng = [k for k in meine
              if k in erg_best and not erg_best[k]["traegt_fuer_m5"] and k not in ohne_massstab]
    rest = [k for k in meine if k not in ohne_massstab and k not in zu_eng]

    def marker(k):
        if k in erg_best:
            traegt = "für M5 geprüft: trägt" if erg_best[k]["traegt_fuer_m5"] else "für M5 zu eng"
            return f"Vorschlag vom 16.08.2026 · {traegt}"
        v = verdikte.get(k)
        if v == "gehalten":
            return "Gegenprobe: gehalten"
        if v:
            return f"Gegenprobe: **{v}**"
        return "ohne Gegenprobe-Vermerk"

    t = []
    t.append("# M5 · Die Akzeptanzkriterien zur Durchsicht — **A. Han, 95 Klauseln**\n")
    t.append("| | |\n|---|---|")
    t.append(f"| **Zu zeichnen von** | **A. Han** für den Auftragnehmer — Zuweisung gez. 19.08.2026 |")
    t.append(f"| **Umfang** | **{len(meine)}** der 101 M5-Klauseln. Die übrigen **6** gehören K17 und liegen bei M. Veil |")
    t.append("| **Grundlage** | `K23-M02` · Blatt 100, Entscheidung 5: *Akzeptanzkriterien werden **vor** dem Bauzug gezeichnet* |")
    t.append("| **Was eine Zeichnung heißt** | Der Maßstab, an dem der Bau später gemessen wird, steht fest — und der blinde Prüf-Agent schreibt seine Prüffälle dagegen. **Nicht** gezeichnet wird damit, dass der Bau ihn erfüllt |")
    t.append("| **Was sie nicht heißt** | Keine Abnahme, keine Freigabe, kein Urteil über Code. Es gibt noch keinen |")
    t.append("")
    t.append("> **Wie Sie das in einer Stunde durchsehen.** Je Eintrag genügt der Vergleich zweier Zeilen:")
    t.append("> der **Klauselwortlaut** oben und die Zeile **ERFUELLT WENN**. Stimmen sie überein, ist der")
    t.append("> Rest Prüffallmechanik. Die Zeile **GEMESSEN DURCH** ist der Bauplan des Prüffalls; sie")
    t.append("> interessiert nur, wenn Sie am Positiv- oder Negativfall zweifeln.")
    t.append(">")
    t.append("> **Wo Sie genau hinsehen sollten:** überall dort, wo der Vermerk *Gegenprobe: **ersetzt***")
    t.append("> steht — dort hat der erste Vorschlag einen Mangel getragen, und der Ersatztext ist der")
    t.append("> zweite Versuch. Bei *erfunden* hatte der erste Vorschlag eine Zahl oder Bedingung genannt,")
    t.append("> die im Wortlaut nicht steht.")
    t.append(">")
    t.append("> **Die Zeilenumbrüche in den Kästen sind zur Lesbarkeit gesetzt.** Maßgeblich ist der")
    t.append("> Eintrag in `pflege.json`; dort steht die Zelle als ein Satzblock.")
    t.append("")
    t.append("---\n")
    t.append("## Die drei Teile\n")
    t.append("| Teil | Was | Zahl | Was zu tun ist |")
    t.append("|---|---|---:|---|")
    t.append(f"| **1** | Kriterien **ohne Maßstab** (*NICHT ABLEITBAR*) | **{len(ohne_massstab)}** | **keine Unterschrift** — hier fehlt eine Angabe, die nur der Eigentümer liefern kann |")
    t.append(f"| **2** | Bestandskriterien vom 16.08., **für M5 zu eng** | **{len(zu_eng)}** | **zwei Teile zeichnen**: der alte Eintrag bleibt, die Ergänzung kommt hinzu |")
    t.append(f"| **3** | Der Rest, nach Konzept | **{len(rest)}** | durchsehen und zeichnen |")
    t.append("")
    t.append("---\n")

    t.append("## Teil 1 · Fünf Klauseln ohne Maßstab — hier hilft keine Unterschrift\n")
    t.append("Der Vorschlag sagt in diesen Fällen ausdrücklich, **was fehlt und wer es festlegen muss**.")
    t.append("Ein Kriterium daraufhin zu erfinden, wäre genau der Mangel, an dem die Gegenprobe 14")
    t.append("Vorschläge gekippt hat.\n")
    t.append("---\n")
    for k in ohne_massstab:
        t.append(block(k, reg, kriterium(k, pflege, reg), marker(k),
                       (erg_best.get(k) or {}).get("ergaenzung")))

    t.append("## Teil 2 · Bestandskriterien, die für M5 zu eng sind\n")
    t.append("Diese Klauseln trugen schon am 16.08.2026 einen Vorschlag — geschrieben für den")
    t.append("**Teilschnitt bis zur Anmeldung**. Für M5 misst er zu wenig. **Überschrieben wurde")
    t.append("nichts**: der alte Eintrag steht, die Ergänzung kommt daneben.\n")
    t.append("---\n")
    for k in zu_eng:
        t.append(block(k, reg, kriterium(k, pflege, reg), marker(k),
                       (erg_best.get(k) or {}).get("ergaenzung")))

    t.append("## Teil 3 · Die übrigen, nach Konzept\n")
    for konzept in sorted({reg[k]["konzept"] for k in rest}):
        gruppe = [k for k in rest if reg[k]["konzept"] == konzept]
        gehalten = sum(1 for k in gruppe if verdikte.get(k) == "gehalten")
        t.append(f"### {konzept} — {len(gruppe)} Klauseln "
                 f"({gehalten} von der Gegenprobe gehalten, {len(gruppe) - gehalten} ersetzt)\n")
        t.append("---\n")
        for k in gruppe:
            t.append(block(k, reg, kriterium(k, pflege, reg), marker(k),
                           (erg_nach.get(k) or {}).get("vorschlag")))

    t.append("## Zeichnung\n")
    t.append("Je Block genügt **eine** Unterschrift, wenn Sie alle Einträge des Blocks tragen.")
    t.append("Einzelne Ausnahmen tragen Sie darunter mit Kennung ein.\n")
    t.append("| Block | Einträge | gezeichnet | Datum | Ausnahmen (Kennungen) |")
    t.append("|---|---:|---|---|---|")
    t.append(f"| Teil 1 · ohne Maßstab | {len(ohne_massstab)} | *keine Zeichnung — Lieferung* | | |")
    def stand(gruppe):
        n = sum(1 for k in gruppe if kriterium(k, pflege, reg).startswith("⟨GEZEICHNET⟩"))
        return (f"**x** ({n}/{len(gruppe)})", "19.08.2026") if n == len(gruppe) and gruppe \
            else (f"☐ ({n}/{len(gruppe)})", "⟨ ⟩")
    kreuz, datum = stand(zu_eng)
    t.append(f"| Teil 2 · Bestand plus Ergänzung | {len(zu_eng)} | {kreuz} | {datum} | |")
    for konzept in sorted({reg[k]["konzept"] for k in rest}):
        gruppe = [k for k in rest if reg[k]["konzept"] == konzept]
        kreuz, datum = stand(gruppe)
        t.append(f"| Teil 3 · {konzept} | {len(gruppe)} | {kreuz} | {datum} | |")
    t.append("")
    t.append("| Name | Rolle | Datum |")
    t.append("|---|---|---|")
    offen = [k for k in meine if not kriterium(k, pflege, reg).startswith("⟨GEZEICHNET⟩")]
    t.append("| A. Han | fachlicher Eigentümer, für den Auftragnehmer | "
             + ("19.08.2026 — Teile 2 und 3" if len(offen) == len(ohne_massstab) else "⟨ ⟩") + " |")
    t.append("")
    t.append("---\n")
    t.append("*Erzeugt am 19.08.2026 von `M5_sichtblatt_erzeugen.py`. Wortlaut und Herkunft aus")
    t.append("`register.json`, Kriterium und Eigentümer aus `pflege.json`, die Klausellage aus")
    t.append("`M5_klausellage_260819.json`. Der Harness trägt eine Zeichnung ein, wenn sie erteilt")
    t.append("ist — er setzt keine.*")

    Path(a.ziel).write_text("\n".join(t) + "\n", encoding="utf-8")
    print(f"{a.ziel} geschrieben · Teil 1: {len(ohne_massstab)} · Teil 2: {len(zu_eng)} · "
          f"Teil 3: {len(rest)} · gesamt {len(meine)}")


if __name__ == "__main__":
    main()
