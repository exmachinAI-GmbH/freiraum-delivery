#!/usr/bin/env python3
# -*- coding: utf-8 -*-
"""Erzeugt die Restrisiko-Vorschlagsliste fuer den Teilschnitt.
Traegt NIE einen Traeger und NIE eine Annahmeentscheidung ein."""
import json, datetime, hashlib, os

BASIS = "/Users/mveil/freiraum-delivery"
ZIEL_MD = BASIS + "/nachweise/restrisiken/restrisiken_teilschnitt.md"
ZIEL_JSON = BASIS + "/nachweise/restrisiken/restrisiken_teilschnitt.json"

STATIONEN = ["Mandant", "Einladungsschranke", "Einladung", "Anmeldecode", "Anmeldung"]
# Die fuenf Regeln der Bauspur, die kein Stationswort trifft (Block 1a/1b des
# Klauselschnitts, gegengeprueft in S1_bauspur_nachpruefung.md)
BAUSPUR = {"K20-M14", "K23-D09", "K03-G01", "K03-M26", "K20-M25"}

w = json.load(open(BASIS + "/nachweise/klauselschnitt/S1_wortmarken.json"))
t = json.load(open(BASIS + "/nachweise/klauselregister/triage.json"))
r = json.load(open(BASIS + "/nachweise/klauselregister/register.json"))

# --- Schritt 1: der Ausschnitt ------------------------------------------------
stationstreffer = {}
for s in w["stationen"]:
    if s["station"] in STATIONEN:
        for l in s["leseanlaesse"]:
            stationstreffer.setdefault(l["klausel"], []).append(s["station"])
teilschnitt = set(stationstreffer) | BAUSPUR

triage = {x["klausel"]: x for x in t["zeilen"]}
reg = {x["klausel"]: x for x in r["zeilen"]}

fehlend = [k for k in teilschnitt if k not in triage or k not in reg]
assert not fehlend, fehlend

# --- Schritt 2: kritisch (Vorschlag) und ohne Prueffall ----------------------
eintraege = sorted(
    [k for k in teilschnitt
     if triage[k]["vorschlag_kritikalitaet"] == "kritisch" and not triage[k]["prueffaelle"]]
)

GRUPPEN = ["sicherheitskritisch", "mandantenkritisch", "freigabekritisch",
           "aufbewahrungskritisch", "wiederherstellungskritisch"]
SPERREND = set(GRUPPEN)   # K23-M04: alle fuenf sperren


def kuerzen(text, n=150):
    text = " ".join(text.split())
    if len(text) <= n:
        return text
    schnitt = text[:n].rsplit(" ", 1)[0]
    return schnitt + " …"


def zelle(s):
    return s.replace("|", "\\|")


zeilen = []
for i, k in enumerate(eintraege, 1):
    tr, rg = triage[k], reg[k]
    gruppen = [g for g in GRUPPEN if g in tr["gruppen"]]
    belege = "; ".join(
        "%s (Wort „%s“)" % (b["gruppe"].replace("kritisch", ""), b["begriff"])
        for b in tr["belegstellen"])
    zeilen.append({
        "kennung": "RR-T-%03d" % i,
        "klausel": k,
        "konzept": tr["konzept"],
        "art": tr["art"],
        "wortlaut_kurz": kuerzen(rg["wortlaut"]),
        "wortlaut_voll": rg["wortlaut"],
        "herkunft": rg["herkunft"],
        "kritikalitaet_vorschlag": "kritisch",
        "kritikalitaet_status": "Triage-Vorschlag, nicht festgestellt",
        "gruppen_vorschlag": gruppen,
        "belegstellen": tr["belegstellen"],
        "belege_kurz": belege,
        "sperrend_keine_annahme_genuegt": bool(set(gruppen) & SPERREND),
        "stationen": sorted(set(stationstreffer.get(k, []))) or ["Bauspur"],
        "prueffall": None,
        "traeger": "",
        "annahmeentscheidung": "",
        "frist": "",
    })

sperrend = [z for z in zeilen if z["sperrend_keine_annahme_genuegt"]]

# --- Ausgabe: JSON -----------------------------------------------------------
daten = {
    "vorbemerkung": ("VORSCHLAG, keine Entscheidung. Traeger, Annahmeentscheidung und "
                     "Frist sind absichtlich leer. Sie zeichnet ein Mensch."),
    "grundlage": "K23-M04 · K23-D07 · F34 · Zeichnung B-5 vom 16.08.2026",
    "erzeugt": datetime.date.today().isoformat(),
    "ausschnitt": {
        "definition": ("Teilschnitt bis zur Anmeldung, Blatt 57 Zeile 122, gezeichnet "
                       "10.08.2026 von A. Han und M. Veil"),
        "stationen": STATIONEN,
        "klauseln_stationen": len(stationstreffer),
        "klauseln_bauspur_zusaetzlich": len(BAUSPUR - set(stationstreffer)),
        "klauseln_teilschnitt_ohne_prueffallgenannte": len(teilschnitt),
    },
    "zaehlung": {
        "eintraege": len(zeilen),
        "davon_sperrend": len(sperrend),
        "ohne_traeger": sum(1 for z in zeilen if not z["traeger"]),
        "ohne_annahmeentscheidung": sum(1 for z in zeilen if not z["annahmeentscheidung"]),
    },
    "zeilen": zeilen,
}
os.makedirs(os.path.dirname(ZIEL_JSON), exist_ok=True)
with open(ZIEL_JSON, "w", encoding="utf-8") as f:
    json.dump(daten, f, ensure_ascii=False, indent=2)
    f.write("\n")

# --- Ausgabe: Markdown -------------------------------------------------------
nach_konzept = {}
for z in zeilen:
    nach_konzept.setdefault(z["konzept"], []).append(z)

L = []
A = L.append
A("# Restrisiken des Teilschnitts · **Vorschlag zur Zeichnung**")
A("")
A("> **Dieses Blatt entscheidet nichts.** Es bereitet je Klausel eine Zeile vor. Die Spalten")
A("> **Träger**, **Annahmeentscheidung** und **Frist** sind absichtlich leer — sie füllt ein")
A("> Mensch aus. Ein Feld, das aussieht wie entschieden, wäre schlimmer als ein leeres.")
A("")
A("| Feld | Wert |")
A("|---|---|")
A("| **Grundlage** | `K23-M04` und `K23-D07` — eine Klausel ohne belegenden Test wird **einzeln** mit Träger, Kritikalität und Annahmeentscheidung aufgeführt. **Eine Abdeckungsquote ersetzt diese Liste nicht** (F34) |")
A("| **Anlass** | Zeichnung **B-5** vom 16.08.2026, Punkt 5 der Grenze: *„Für die kritischen Klauseln je einen Eintrag in der Restrisikoliste vorbereiten — mit leerem Träger und leerer Annahmeentscheidung“* |")
A("| **Ausschnitt** | der **Teilschnitt bis zur Anmeldung**, gezeichnet am 10.08.2026 (Blatt 57, Zeile 122, A. Han und M. Veil) |")
A("| **Einträge** | **%d** |" % len(zeilen))
A("| **davon in einer sperrenden Klasse** | **%d** — dort ersetzt **keine** Annahmeentscheidung den Test |" % len(sperrend))
A("| **Träger eingetragen** | **0 von %d** |" % len(zeilen))
A("| **Annahmeentscheidungen gezeichnet** | **0 von %d** |" % len(zeilen))
A("| **Wer liefert das Fehlende** | **M. Veil** zeichnet die Annahmeentscheidungen mit Träger und Frist (Zeichnung B-5, *„Was danach noch bei einem Menschen liegt“*, Zeile 2). Für die %d sperrenden Einträge liefert statt dessen der **Prüf-Agent** den fehlenden Prüffall — eine Annahme genügt dort nicht |" % len(sperrend))
A("| **Erzeugt am** | %s, maschinell aus Klauselschnitt, Triage und Klauselregister |" % daten["erzeugt"])
A("")
A("---")
A("")
A("## Wie der Ausschnitt bestimmt wurde — der Weg, nachrechenbar")
A("")
A("Der Teilschnitt ist im Wortlaut gezeichnet: *„Der Weg **bis zur Anmeldung**: Mandant")
A("anlegen · Einladungsschranke · Einladung über den echten Mailweg · Anmeldecode ·")
A("Anmeldung“* (Blatt 57, Zeile 122; wiedergegeben in `nachweise/meldungen/VERZUG_260814.md`,")
A("Zeilen 77–80). Diese fünf Namen sind zugleich fünf Stationen des Stichwortverzeichnisses")
A("`nachweise/klauselschnitt/S1_wortmarken.json`.")
A("")
A("| Schritt | Quelle | Klauseln |")
A("|---|---|---:|")
A("| 1 · Die fünf Stationen des Teilschnitts, Vereinigungsmenge | `S1_wortmarken.json` | **%d** |" % len(stationstreffer))
A("| 2 · **plus** die Regeln der Bauspur, die kein Stationswort trifft | `S1_zeichnung.md` Block 1a/1b, gegengeprüft in `S1_bauspur_nachpruefung.md` | **+%d** |" % len(BAUSPUR - set(stationstreffer)))
A("| **= Ausschnitt** | | **%d** |" % len(teilschnitt))
A("| 3 · davon **kritisch** nach Triage-Vorschlag | `triage.json` | %d |" % sum(1 for k in teilschnitt if triage[k]["vorschlag_kritikalitaet"] == "kritisch"))
A("| 4 · davon **ohne Prüffall** | `triage.json`, Feld `prueffaelle` | **%d** |" % len(zeilen))
A("")
A("**Zur gezeichneten Zahl 167.** Das Kreuz 7.2 vom 15.08.2026 nennt den Umfang von")
A("Bedingung 4 mit **167 Regeln** = 152 Stationswörter + 5 Bauspur + **10 von Prüffällen")
A("genannte**. Die zehn zusätzlich genannten Regeln **haben einen Prüffall** — sie sind")
A("deshalb hier ohnehin keine Restrisiken und ändern an der Zahl **%d** nichts. Die" % len(zeilen))
A("Auswahl steht damit auf 152 + 5 = **%d** Klauseln." % len(teilschnitt))
A("")
A("**Was hier nicht steht:** kein Akzeptanzkriterium (K23-M02 — das liefert der fachliche")
A("Eigentümer), keine Quote (F34), keine Aussage darüber, ob eine Klausel erfüllt ist.")
A("")
A("---")
A("")
A("## Was die Spalten bedeuten")
A("")
A("| Spalte | Bedeutung |")
A("|---|---|")
A("| **Kennung** | laufende Nummer dieses Blattes. Sie ersetzt die Klauselkennung nicht |")
A("| **Wortlaut in Kürze** | gekürzt zum Wiedererkennen. **Es gilt der volle Wortlaut** im Klauselregister und in der Quelle |")
A("| **Kritikalität** | **Vorschlag der Triage**, keine Feststellung. Daneben steht das Wort, das ihn ausgelöst hat — wer es nicht mitträgt, streicht die Zeile |")
A("| **⛔** | gesetzt, wenn die Klausel in eine der fünf Klassen aus `K23-M04` fällt. Dort **sperrt der fehlende Test die Freigabe**; eine Annahmeentscheidung genügt nicht |")
A("| **Träger** | **leer.** Träger sind Menschen |")
A("| **Annahme** | **leer.** Die Annahmeentscheidung zeichnet M. Veil |")
A("| **Frist** | **leer.** Sie gehört zur Annahmeentscheidung |")
A("")
A("**Achtung zur Spalte Kritikalität.** Die Triage ordnet über einen Worttreffer im Wortlaut")
A("ein. Ein Worttreffer belegt, dass ein Wort dasteht — nicht, dass die Sache zutrifft. Die")
A("Belegstelle steht deshalb in jeder Zeile. **Eine Kritikalität herabzustufen ist untersagt**")
A("(`K23-D05`, `K23-G08`); wer eine Zeile für falsch eingeordnet hält, vermerkt das und legt")
A("es vor, statt sie zu senken.")
A("")
A("---")
A("")
A("## Die Einträge")
A("")
for konzept in sorted(nach_konzept):
    gruppe = nach_konzept[konzept]
    ns = sum(1 for z in gruppe if z["sperrend_keine_annahme_genuegt"])
    A("### %s — %d Einträge, davon %d sperrend" % (konzept, len(gruppe), ns))
    A("")
    A("| Kennung | Klausel | Art | Wortlaut in Kürze | Kritikalität (Triage-**Vorschlag**) | Auslösendes Wort | ⛔ | Träger | Annahme | Frist |")
    A("|---|---|---|---|---|---|:-:|---|---|---|")
    for z in gruppe:
        A("| %s | **%s** | %s | %s | %s · *Vorschlag* | %s | %s | | | |" % (
            z["kennung"], z["klausel"], z["art"], zelle(z["wortlaut_kurz"]),
            ", ".join(g.replace("kritisch", "") for g in z["gruppen_vorschlag"]),
            zelle(z["belege_kurz"]),
            "**⛔**" if z["sperrend_keine_annahme_genuegt"] else ""))
    A("")

A("---")
A("")
A("## Die sperrenden Klassen — warum hier keine Annahme genügt")
A("")
A("`K23-M04`, letzter Satz, im Wortlaut:")
A("")
A("> *„Ist die Klausel sicherheits-, mandanten-, freigabe-, aufbewahrungs- oder")
A("> wiederherstellungskritisch, **sperrt der fehlende Test die Freigabe**.“*")
A("")
A("Jeder der %d Einträge wurde daraufhin am Wortlaut geprüft. **Alle %d fallen in mindestens" % (len(zeilen), len(sperrend)))
A("eine der fünf Klassen** — die Triage kennt keine sechste Art, kritisch zu sein.")
A("")
A("| Klasse | Einträge |")
A("|---|---:|")
for g in GRUPPEN:
    A("| %s | %d |" % (g, sum(1 for z in zeilen if g in z["gruppen_vorschlag"])))
A("")
A("Eine Klausel kann in mehreren Klassen stehen; die Summe ist deshalb größer als %d." % len(zeilen))
A("")
A("### Eine Schwäche dieser Einordnung, offen benannt")
A("")
mk = sum(1 for z in zeilen if "mandantenkritisch" in z["gruppen_vorschlag"])
nur_mk = sum(1 for z in zeilen if z["gruppen_vorschlag"] == ["mandantenkritisch"])
A("**%d der %d Einträge sind *mandantenkritisch*, %d davon ausschließlich.** Ausgelöst hat" % (mk, len(zeilen), nur_mk))
A("das durchweg das Wort *Mandant* im Wortlaut. Das Wort steht in sehr vielen Klauseln,")
A("weil die ganze Anlage mandantengetrennt ist — es trennt also wenig. **Der Vorschlag ist")
A("damit eher zu weit als zu eng.**")
A("")
A("**Das ist kein Grund, ihn zu senken.** `K23-D05` und `K23-G08` untersagen, eine")
A("Kritikalität herabzustufen, damit ein Lauf besteht. Es ist ein Grund, ihn **von einem")
A("Menschen lesen zu lassen**: die auslösende Wortstelle steht in jeder Zeile, und wer eine")
A("Einordnung nicht mitträgt, vermerkt das in der Zeile und legt es vor. **Dieses Blatt hat")
A("nichts gestrichen** — das wäre eine Entscheidung.")
A("")
A("**Was das praktisch heißt.** Für diese %d Einträge ist die Spalte *Annahme* kein Ausweg." % len(sperrend))
A("Sie darf ausgefüllt werden, aber sie hebt die Sperre nicht auf. Es gibt genau zwei Wege:")
A("")
A("1. **Ein Prüffall wird geschrieben** — vom Prüf-Agenten, blind, gegen das Akzeptanzkriterium.")
A("   Das Akzeptanzkriterium fehlt heute bei **allen** Zeilen; es kommt nach `K23-M02` vom")
A("   fachlichen Eigentümer. **Ohne Kriterium kein Prüffall.**")
A("2. **Die Klausel wird aus dem Umfang genommen** — das ist eine Umfangsentscheidung des")
A("   Auftraggebers, kein Vorgang dieses Harness.")
A("")
A("---")
A("")
A("## Was ein Mensch jetzt tun muss")
A("")
A("| | Was | Wer | Warum es nicht maschinell geht |")
A("|---|---|---|---|")
A("| 1 | **Je Eintrag einen Träger benennen** | M. Veil | Träger sind Menschen. `K23-D07`: ein Restrisiko darf nicht stillschweigend übernommen werden |")
A("| 2 | **Je Eintrag Annahmeentscheidung und Frist zeichnen** | M. Veil | Das ist die Kernfrage der Abnahme |")
A("| 3 | **Für die %d sperrenden Einträge entscheiden, welcher Weg gilt** — Prüffall oder Umfangsentscheidung | M. Veil | Eine Annahme genügt dort nach `K23-M04` nicht |" % len(sperrend))
A("| 4 | **Die Akzeptanzkriterien liefern** — ohne sie ist kein Prüffall schreibbar | die fachlichen Eigentümer (`K23-M02`) | Ein erfundenes Kriterium ließe den Bau gegen eine erfundene Erwartung bestehen |")
A("| 5 | **Die Zuordnung zum Teilschnitt zeichnen** — `S1_zeichnung.md` trägt bis heute **kein einziges Kreuz** | M. Veil | Der Ausschnitt dieses Blattes ist damit gerechnet, aber nicht gezeichnet |")
A("")
A("---")
A("")
A("*Erzeugt am %s. **Vorschlag, keine Entscheidung.** Träger, Annahmeentscheidung und Frist" % daten["erzeugt"])
A("sind in allen %d Zeilen leer und bleiben es, bis ein Mensch sie füllt. Maschinenlesbar" % len(zeilen))
A("daneben: `restrisiken_teilschnitt.json`.*")

with open(ZIEL_MD, "w", encoding="utf-8") as f:
    f.write("\n".join(L) + "\n")

print("Ausschnitt (152 Stationen + 5 Bauspur):", len(teilschnitt))
print("Eintraege:", len(zeilen), "| sperrend:", len(sperrend))
print("Traeger gefuellt:", sum(1 for z in zeilen if z["traeger"]))
print("Annahmeentscheidungen gefuellt:", sum(1 for z in zeilen if z["annahmeentscheidung"]))
print("geschrieben:", ZIEL_MD, ZIEL_JSON)
