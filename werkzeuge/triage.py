#!/usr/bin/env python3
"""FREIRAUM Coding-Harness · Triage der Klauseln nach K23-M04.

    python3 werkzeuge/triage.py [--register <datei>] [--ziel <datei>]
                                [--markdown <datei>]

Warum es diese Datei gibt
-------------------------
K23-M04 im Wortlaut:

    "Eine Klausel ohne belegenden Test MUSS einzeln als Restrisiko mit
    Traeger, Kritikalitaet und Annahmeentscheidung aufgefuehrt werden. Eine
    Abdeckungsquote ersetzt diese Liste nicht (F34). Ist die Klausel
    sicherheits-, mandanten-, freigabe-, aufbewahrungs- oder
    wiederherstellungskritisch, sperrt der fehlende Test die Freigabe."

Daraus folgt die Frage, die dieses Werkzeug beantwortet: WELCHE der 1231
Klauseln brauchen zwingend einen Test? Bisher war das eine Vermutung. Das
Register fuehrt die Spalte `kritikalitaet` fuer alle 1231 Zeilen leer.

Was dieses Werkzeug NICHT tut
-----------------------------
1. Es ENTSCHEIDET die Kritikalitaet nicht. Es macht einen VORSCHLAG und legt
   je Vorschlag die Belegstelle bei: welcher Begriff an welcher Stelle des
   Wortlauts ihn ausgeloest hat. Wer den Vorschlag pruefen will, liest eine
   Zeile, nicht 1231.

   Der Grund steht in K00-D04 und K00-M03: eine Angabe wird nicht erfunden.
   Eine Kritikalitaet, die eine Maschine ohne Beleg setzt, waere genau das.
   Deshalb heissen die Felder `vorschlag_kritikalitaet` und `belegstellen`
   und nicht `kritikalitaet`.

2. Es schreibt KEIN Akzeptanzkriterium. K23-M02: "Fehlt das
   Akzeptanzkriterium, liefert es der in derselben Zeile eingetragene
   fachliche Eigentuemer nach." Der Eigentuemer ist ein Mensch. Ein Kriterium,
   das dieses Werkzeug ausdaechte, waere der teuerste Fehler dieser Arbeit:
   ab dann pruefte der Bau gegen eine erfundene Erwartung und bestaende.

3. Es sperrt nichts. K23-M04 sperrt die FREIGABE, nicht Tor 1. Dieses
   Werkzeug meldet Zahlen; wer sperrt, ist Tor II.

Fail-closed
-----------
Loest kein Begriff aus, lautet der Vorschlag `unbestimmt` -- NICHT "nicht
kritisch". Der Unterschied ist der ganze Punkt: "nicht kritisch" waere eine
Aussage, "unbestimmt" ist das Eingestaendnis, dass die Maschine hier nichts
beitraegt. Die unbestimmten Zeilen sind die Arbeitsliste fuer den Menschen.

Der Teststand kommt aus den Prueffaellen, nicht aus dem Register
----------------------------------------------------------------
Das Register fuehrt `test` fuer alle 1231 Zeilen leer. Die Prueffaelle unter
pruefungen/ nennen ihre Klauseln aber im Klartext. Dieses Werkzeug liest sie
und zaehlt, welche Klausel TATSAECHLICH gemessen wird -- gemessen am
Versionsstand, nicht an einer gepflegten Spalte. Eine Spalte kann irren; ein
Prueffall, der eine Klausel nennt, existiert.
"""
import argparse
import json
import pathlib
import re
import sys

WURZEL = pathlib.Path(__file__).resolve().parent.parent

# ---------------------------------------------------------------------
# Die fuenf Gruppen. Die NAMEN stehen woertlich in K23-M04; erfunden ist
# hier nichts. Die Begriffe je Gruppe sind die Woerter, mit denen die
# Konzepte ueber die jeweilige Sache sprechen -- nachgeschlagen im Korpus,
# nicht aus der Luft. Jeder Treffer wird mit dem ausloesenden Begriff
# ausgewiesen, damit ein Mensch den Vorschlag in einer Zeile pruefen kann.
#
# Bewusst WEIT geschnitten: ein falscher Treffer kostet einen Blick, eine
# uebersehene sicherheitskritische Klausel kostet die Freigabe (K23-M04,
# letzter Satz). Im Zweifel meldet dieses Werkzeug lieber zu viel.
# ---------------------------------------------------------------------
GRUPPEN = {
    "sicherheitskritisch": [
        r"Sicherheit\w*", r"Geheimnis\w*", r"Schl[üu]ssel\w*", r"Passwort\w*",
        r"Token\w*", r"verschl[üu]ssel\w*", r"Verschl[üu]sselung\w*",
        r"authentifiz\w*", r"Authentifiz\w*", r"Anmeldung\w*", r"anmelde\w*",
        r"Zugangscode\w*", r"Zugangswert\w*", r"Berechtigung\w*",
        r"Rollentrennung", r"Angriff\w*", r"Missbrauch\w*", r"MFA",
        r"zweite[rn]? Faktor", r"Streuwert\w*", r"Pfeffer",
        r"privilegiert\w*", r"Bypass\w*", r"Einmal-Link", r"fail-closed",
    ],
    "mandantenkritisch": [
        r"Mandant\w*", r"mandant\w*", r"tenant_id", r"RLS",
        r"Mandantenschnitt", r"Row Level Security", r"Isolierung",
        r"fremde[rn]? Mandant\w*", r"Mandantentrennung",
    ],
    "freigabekritisch": [
        r"Freigabe\w*", r"freigegeben", r"freizugeben", r"Abnahme\w*",
        r"Zeichnung\w*", r"gezeichnet", r"Unterschrift\w*", r"Siegel\w*",
        r"sealed\w*", r"Selbstfreigabe", r"Vier-Augen\w*",
        r"Rollentrennung bei Freigab\w*", r"genehmig\w*", r"Gate \d",
        r"Kenntnisnahme", r"IN_PROD", r"ABNAHME",
    ],
    "aufbewahrungskritisch": [
        r"Aufbewahrung\w*", r"aufbewahr\w*", r"L[öo]schung\w*", r"l[öo]sch\w*",
        r"retention\w*", r"Retention\w*", r"Aufbewahrungsklasse\w*",
        r"DSGVO", r"personenbezogen\w*", r"Anonymisier\w*", r"anonymisier\w*",
        r"Pseudonym\w*", r"pseudonym\w*", r"Regelfrist\w*", r"Mindestfrist\w*",
        r"Auskunftspflicht\w*", r"Betroffenenrecht\w*",
    ],
    "wiederherstellungskritisch": [
        r"Wiederherstell\w*", r"wiederherstell\w*", r"Backup\w*",
        r"Sicherungskopie\w*", r"Restore\w*", r"Wiederanlauf\w*",
        r"Notfall\w*", r"Ausfall\w*", r"Desaster\w*", r"RTO", r"RPO",
        r"Idempotenz", r"idempotent\w*",
    ],
}

# Vorkompiliert; \b an beiden Enden, damit "Frist" nicht in "Fristenkonflikt"
# des Fliesstextes eines anderen Gedankens haengenbleibt.
MUSTER = {
    gruppe: [re.compile(r"\b" + b + r"\b") for b in begriffe]
    for gruppe, begriffe in GRUPPEN.items()
}

KLAUSEL_MUSTER = re.compile(r"\bK\d{2}-[MDG]\d{2}\b")


def klauseln_mit_prueffall(wurzel):
    """Welche Klausel wird TATSAECHLICH von einem Prueffall genannt?

    Gelesen wird der Versionsstand unter pruefungen/, nicht die Spalte
    `test` des Registers -- die ist fuer alle 1231 Zeilen leer. Ein
    Prueffall, der eine Klausel nennt, ist ein Beleg; eine leere Spalte ist
    keiner, und eine gefuellte Spalte waere nur eine Behauptung.
    """
    treffer = {}
    pfade = sorted(p for p in (wurzel / "pruefungen").rglob("*")
                   if p.is_file() and p.suffix in {".sh", ".sql", ".py"})
    for p in pfade:
        try:
            text = p.read_text(encoding="utf-8", errors="replace")
        except OSError:
            continue
        rel = str(p.relative_to(wurzel))
        for k in set(KLAUSEL_MUSTER.findall(text)):
            treffer.setdefault(k, []).append(rel)
    return {k: sorted(v) for k, v in treffer.items()}


def einordnen(wortlaut):
    """Vorschlag und Belegstellen fuer eine Klausel.

    Rueckgabe: (liste_der_gruppen, liste_der_belegstellen). Leer bedeutet
    unbestimmt -- ausdruecklich NICHT "nicht kritisch".
    """
    gruppen, belege = [], []
    for gruppe, muster in MUSTER.items():
        for m in muster:
            fund = m.search(wortlaut)
            if fund:
                if gruppe not in gruppen:
                    gruppen.append(gruppe)
                belege.append({
                    "gruppe": gruppe,
                    "begriff": fund.group(0),
                    "stelle": fund.start(),
                })
                break          # ein Beleg je Gruppe genuegt
    return gruppen, belege


def triagieren(register, wurzel):
    with pathlib.Path(register).open(encoding="utf-8") as d:
        reg = json.load(d)
    getestet = klauseln_mit_prueffall(wurzel)

    zeilen, zaehlung = [], {g: 0 for g in GRUPPEN}
    zaehlung.update({"kritisch": 0, "unbestimmt": 0,
                     "kritisch_ohne_prueffall": 0, "mit_prueffall": 0})

    for x in reg["zeilen"]:
        gruppen, belege = einordnen(x["wortlaut"])
        prueffaelle = getestet.get(x["klausel"], [])
        kritisch = bool(gruppen)

        zeilen.append({
            "klausel": x["klausel"],
            "konzept": x["konzept"],
            "art": x["art"],
            # Eigentuemer: das eigene Konzept ist die belegte Vorgabe (jede
            # Klausel gehoert dem Konzept, in dem sie steht). Wo kanon.yaml
            # eine Sache einem ANDEREN Konzept zuordnet, gewinnt kanon.yaml
            # -- das kann dieses Werkzeug nicht sehen und traegt es deshalb
            # als Vorgabe, nicht als Feststellung.
            "vorschlag_eigentuemer": x["konzept"],
            "vorschlag_kritikalitaet": "kritisch" if kritisch else "unbestimmt",
            "gruppen": gruppen,
            "belegstellen": belege,
            "prueffaelle": prueffaelle,
            "sperrt_die_freigabe": kritisch and not prueffaelle,
        })

        for g in gruppen:
            zaehlung[g] += 1
        if kritisch:
            zaehlung["kritisch"] += 1
        else:
            zaehlung["unbestimmt"] += 1
        if prueffaelle:
            zaehlung["mit_prueffall"] += 1
        if kritisch and not prueffaelle:
            zaehlung["kritisch_ohne_prueffall"] += 1

    return {
        "vorbemerkung":
            "Vorschlag nach K23-M04, nicht Feststellung. Jede Einordnung "
            "traegt die Belegstelle, die sie ausgeloest hat. 'unbestimmt' "
            "heisst: die Maschine traegt hier nichts bei -- nicht 'nicht "
            "kritisch'. Das Akzeptanzkriterium fehlt weiterhin bei allen "
            "Zeilen und kommt nach K23-M02 vom fachlichen Eigentuemer.",
        "grundlage": "K23-M04 · die fuenf Kritikalitaeten im Wortlaut der Klausel",
        "register": str(pathlib.Path(register).name),
        "register_erzeugt": reg.get("erzeugt"),
        "zaehlung": zaehlung,
        "zeilen": zeilen,
    }


def markdown(t):
    z = t["zaehlung"]
    gesamt = len(t["zeilen"])
    zeilen = [
        "# Triage der Klauseln nach K23-M04 — **Vorschlag, keine Feststellung**",
        "",
        "Erzeugt von `werkzeuge/triage.py`. Jede Einordnung trägt die Belegstelle,",
        "die sie ausgelöst hat. **`unbestimmt` heißt nicht `nicht kritisch`** — es heißt,",
        "dass kein Begriff der fünf Gruppen im Wortlaut vorkommt und die Maschine hier",
        "nichts beiträgt. Diese Zeilen sind die Arbeitsliste, nicht der Rest.",
        "",
        "## Die Zahl, nach der gefragt war",
        "",
        "| | Anzahl | Anteil |",
        "|---|---|---|",
        f"| Klauseln gesamt | {gesamt} | 100 % |",
        f"| **kritisch nach K23-M04** | **{z['kritisch']}** | {z['kritisch'] * 100 // gesamt} % |",
        f"| unbestimmt | {z['unbestimmt']} | {z['unbestimmt'] * 100 // gesamt} % |",
        f"| von einem Prüffall genannt | {z['mit_prueffall']} | {z['mit_prueffall'] * 100 // gesamt} % |",
        f"| **kritisch und ohne Prüffall** | **{z['kritisch_ohne_prueffall']}** | {z['kritisch_ohne_prueffall'] * 100 // gesamt} % |",
        "",
        "Die letzte Zeile ist die, die zählt. K23-M04, letzter Satz:",
        "",
        "> *„Ist die Klausel sicherheits-, mandanten-, freigabe-, aufbewahrungs- oder",
        "> wiederherstellungskritisch, **sperrt der fehlende Test die Freigabe**.“*",
        "",
        "Diese Klauseln brauchen entweder einen Prüffall oder eine gezeichnete",
        "Annahmeentscheidung mit Träger — sonst sperren sie Tor II.",
        "",
        "## Nach Gruppe",
        "",
        "| Gruppe | Klauseln |",
        "|---|---|",
    ]
    for g in GRUPPEN:
        zeilen.append(f"| {g} | {z[g]} |")
    zeilen += [
        "",
        "Eine Klausel kann in mehreren Gruppen stehen; die Summe ist deshalb größer",
        "als die Zahl der kritischen Klauseln.",
        "",
        "## Nach Konzept",
        "",
        "| Konzept | gesamt | kritisch | mit Prüffall | **kritisch ohne Prüffall** |",
        "|---|---|---|---|---|",
    ]
    je_konzept = {}
    for x in t["zeilen"]:
        e = je_konzept.setdefault(x["konzept"], [0, 0, 0, 0])
        e[0] += 1
        if x["vorschlag_kritikalitaet"] == "kritisch":
            e[1] += 1
        if x["prueffaelle"]:
            e[2] += 1
        if x["sperrt_die_freigabe"]:
            e[3] += 1
    for k in sorted(je_konzept):
        a, b, c, d = je_konzept[k]
        zeilen.append(f"| {k} | {a} | {b} | {c} | **{d}** |")
    zeilen += [
        "",
        "## Was hier NICHT steht",
        "",
        "**Kein Akzeptanzkriterium.** K23-M02:",
        "",
        "> *„Fehlt das Akzeptanzkriterium, liefert es der in derselben Zeile eingetragene",
        "> fachliche Eigentümer nach; bis dahin bleibt der Bauauftrag unvollständig.“*",
        "",
        "Der Eigentümer ist ein Mensch. Ein Kriterium, das dieses Werkzeug ausdächte, wäre",
        "der teuerste Fehler dieser Arbeit — ab dann prüfte der Bau gegen eine erfundene",
        "Erwartung und bestände.",
        "",
        "**Keine Entscheidung.** Der Eigentümer-Vorschlag ist das Konzept, in dem die",
        "Klausel steht. Wo `kanon.yaml` eine Sache einem anderen Konzept zuordnet, gewinnt",
        "`kanon.yaml`; das sieht dieses Werkzeug nicht.",
        "",
        "**Keine Sperre.** K23-M04 sperrt die Freigabe, nicht Tor 1. Dieses Werkzeug",
        "meldet Zahlen; wer sperrt, ist Tor II.",
        "",
    ]
    return "\n".join(zeilen) + "\n"


def main():
    ap = argparse.ArgumentParser(description="Triage der Klauseln nach K23-M04")
    ap.add_argument("--register",
                    default=str(WURZEL / "nachweise/klauselregister/register.json"))
    ap.add_argument("--ziel",
                    default=str(WURZEL / "nachweise/klauselregister/triage.json"))
    ap.add_argument("--markdown",
                    default=str(WURZEL / "nachweise/klauselregister/triage.md"))
    a = ap.parse_args()

    if not pathlib.Path(a.register).is_file():
        print(f"::error::Register nicht gefunden: {a.register}", file=sys.stderr)
        return 2

    t = triagieren(a.register, WURZEL)

    ziel = pathlib.Path(a.ziel)
    ziel.parent.mkdir(parents=True, exist_ok=True)
    with ziel.open("w", encoding="utf-8") as d:
        json.dump(t, d, indent=2, ensure_ascii=False)
        d.write("\n")
    with pathlib.Path(a.markdown).open("w", encoding="utf-8") as d:
        d.write(markdown(t))

    z = t["zaehlung"]
    print(f"Triage nach K23-M04 · {len(t['zeilen'])} Klauseln")
    print(f"  kritisch:                 {z['kritisch']}")
    print(f"  unbestimmt:               {z['unbestimmt']}")
    print(f"  von Prueffall genannt:    {z['mit_prueffall']}")
    print(f"  KRITISCH OHNE PRUEFFALL:  {z['kritisch_ohne_prueffall']}")
    print(f"{ziel}\n{a.markdown}")
    return 0


if __name__ == "__main__":
    sys.exit(main())
