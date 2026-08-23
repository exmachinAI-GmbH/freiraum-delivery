#!/usr/bin/env python3
"""M3 · Klausellauf EN-03a gegen einen echten Server.

Faehrt jeden Weg aus arbeit/Auftraege/m3_pruefauftrag_en03a_260823.md gegen
einen laufenden FREIRAUM-Server mit echter PostgreSQL -- einschliesslich der
Fehlerpfade. Schreibt ein Manifest.

Jeder Fall traegt genau einen der vier Zustaende: BESTANDEN, FEHLGESCHLAGEN,
GESPERRT, NICHT_AUSGEFUEHRT. Einen fuenften gibt es nicht (K23-M22).
"""
import json
import os
import re
import sys

import httpx
import psycopg
from itsdangerous import URLSafeSerializer

BASIS = "http://127.0.0.1:8123"
DSN = os.environ["FREIRAUM_DSN"]
SIEGEL = URLSafeSerializer(os.environ["FREIRAUM_SITZUNG_SCHLUESSEL"],
                           salt="fr_sitzung_v1")

ANNA = "cccccccc-cccc-cccc-cccc-cccccccccccc"   # Demobank
BERT = "dddddddd-dddd-dddd-dddd-dddddddddddd"   # Zweitbank
MANDANT_ANNA = "11111111-1111-1111-1111-111111111111"
MANDANT_BERT = "22222222-2222-2222-2222-222222222222"

FAELLE = []


def keks(sitzung):
    return {"fr_sitzung": SIEGEL.dumps(sitzung)}


def db():
    return psycopg.connect(DSN, autocommit=True)


def zuruecksetzen():
    with db() as conn:
        conn.execute("DELETE FROM quick_answer")
        conn.execute("DELETE FROM quick_check")
        conn.execute("DELETE FROM fit_answer")
        conn.execute("DELETE FROM fit_check")
        conn.execute("UPDATE auth_session SET ended_at = NULL,"
                     " last_activity_at = now(), started_at = now()")


def fall(kennung, klausel, satz, bedingung, belege=""):
    zustand = "BESTANDEN" if bedingung else "FEHLGESCHLAGEN"
    FAELLE.append({"kennung": kennung, "klausel": klausel, "aussage": satz,
                   "zustand": zustand, "beleg": belege})
    print(f"  {kennung:<8} {zustand:<15} {satz}")
    return bedingung


def gesperrt(kennung, klausel, satz, grund):
    FAELLE.append({"kennung": kennung, "klausel": klausel, "aussage": satz,
                   "zustand": "GESPERRT", "beleg": grund})
    print(f"  {kennung:<8} {'GESPERRT':<15} {satz}")


def optionen_von(html):
    return re.findall(r'name="option" value="(\d+)"', html)


def frage_von(html):
    treffer = re.search(r'<legend id="frage">(.*?)</legend>', html, re.S)
    return treffer.group(1).strip() if treffer else None


def antworten(sitz, wahl):
    """Beantwortet die Fragen der Reihe nach mit den Positionen aus `wahl`."""
    with httpx.Client(base_url=BASIS, cookies=keks(sitz),
                      follow_redirects=False) as k:
        for _ in range(len(wahl)):
            seite = k.get("/schnellweg").text
            code = re.search(r'name="frage" value="([a-z_]+)"', seite)
            if code is None:
                break
            k.post("/schnellweg/antwort",
                   data={"frage": code.group(1), "option": wahl[code.group(1)]})
        return k.get("/schnellweg").text


# ---------------------------------------------------------------------------
print("\n=== M3 · KLAUSELLAUF EN-03a · echter Server, echte Datenbank ===\n")

# --- VP-01 · Ohne Sitzung fuehrt kein Weg weiter --------------------------
zuruecksetzen()
a = httpx.get(f"{BASIS}/schnellweg", follow_redirects=False)
fall("VP-01", "K03-D01", "Ohne Sitzung fuehrt GET /schnellweg auf die Anmeldung",
     a.status_code == 303 and a.headers.get("location") == "/anmeldung",
     f"{a.status_code} -> {a.headers.get('location')}")

# --- VP-02 · Mit Sitzung, ohne Vorgang ------------------------------------
a = httpx.get(f"{BASIS}/schnellweg", cookies=keks(ANNA), follow_redirects=False)
fall("VP-02", "K04-G04", "Ohne laufenden Vorgang fuehrt EN-03a zurueck auf EN-03",
     a.status_code == 303 and a.headers.get("location") == "/vorpruefung",
     f"{a.status_code} -> {a.headers.get('location')}")

# --- VP-03 · Check starten legt GENAU EINEN Vorgang an --------------------
a = httpx.post(f"{BASIS}/vorpruefung/starten", cookies=keks(ANNA),
               follow_redirects=False)
with db() as conn:
    anzahl = conn.execute("SELECT count(*) FROM quick_check").fetchone()[0]
    mandant = conn.execute("SELECT tenant_id::text FROM quick_check").fetchone()
fall("VP-03", "K04-M02", "Check starten fuehrt nach EN-03a und legt genau einen Vorgang an",
     a.status_code == 303 and a.headers.get("location") == "/schnellweg"
     and anzahl == 1 and mandant[0] == MANDANT_ANNA,
     f"{a.status_code} -> {a.headers.get('location')}, quick_check={anzahl}, Mandant stimmt")

# --- VP-04 · Genau eine Frage, genau drei Antwortmoeglichkeiten ------------
seite = httpx.get(f"{BASIS}/schnellweg", cookies=keks(ANNA)).text
opts = optionen_von(seite)
fall("VP-04", "K04-M22", "EN-03a zeigt genau eine Frage mit genau drei Antwortmoeglichkeiten",
     len(re.findall(r'<legend id="frage">', seite)) == 1 and len(opts) == 3,
     f"Fragen=1, Antwortmoeglichkeiten={len(opts)}, Frage='{frage_von(seite)}'")

# --- VP-05 · Kein Freitextfeld --------------------------------------------
fall("VP-05", "K04-M22", "EN-03a fuehrt kein Freitextfeld",
     'type="text"' not in seite and "<textarea" not in seite,
     "keine Eingabefelder vom Typ text, kein textarea")

# --- VP-06 · Solange offen: keine Weiterwege, Hinweis nennt die Frage ------
hinweis = re.search(r'<div id="hinweis".*?</div>', seite, re.S)
hinweis_txt = hinweis.group(0) if hinweis else ""
fall("VP-06", "K19-M06",
     "Solange eine Frage offen ist, fehlen beide Weiterwege und der Hinweis nennt sie im Wortlaut",
     "/schnellweg/vorpruefung2" not in seite
     and "/schnellweg/arbeitsdokument" not in seite
     and frage_von(seite) in hinweis_txt,
     "Weiterwege ausgeblendet (nicht ausgegraut); Hinweis traegt den Fragewortlaut")

# --- VP-07 · Genau eine Zugangsmarke --------------------------------------
marken = seite.count('class="marke">Zugang:')
fall("VP-07", "K19-M03", "EN-03a traegt genau eine Zugangsmarke",
     marken == 1, f"Zugangsmarken={marken}")

# --- VP-08 · Antwort, die nicht zur Frage gehoert -------------------------
with db() as conn:
    vorher = conn.execute("SELECT count(*) FROM quick_answer").fetchone()[0]
a = httpx.post(f"{BASIS}/schnellweg/antwort", cookies=keks(ANNA),
               data={"frage": "verbindlichkeit", "option": "9"},
               follow_redirects=False)
with db() as conn:
    nachher = conn.execute("SELECT count(*) FROM quick_answer").fetchone()[0]
fall("VP-08", "K04-G04",
     "Eine Antwortmoeglichkeit, die es nicht gibt, schreibt nichts",
     a.status_code == 200 and vorher == nachher,
     f"HTTP {a.status_code}, quick_answer {vorher} -> {nachher}")

# --- VP-09 · Veto der Verbindlichkeitsfrage -------------------------------
zuruecksetzen()
httpx.post(f"{BASIS}/vorpruefung/starten", cookies=keks(ANNA), follow_redirects=False)
ergebnis = antworten(ANNA, {"ergebnis": 1, "wiederholung": 1, "beteiligte": 1,
                            "daten": 1, "verbindlichkeit": 2})
fall("VP-09", "K04-M23",
     "Verbindlichkeit auf Anwendung gibt allein den Ausschlag",
     "Unser Vorschlag: eine Anwendung" in ergebnis
     and "andere verlassen sich darauf" in ergebnis,
     "vier Dokument-Antworten, dennoch Vorschlag Anwendung; der Satz nennt die Veto-Antwort")

# --- VP-10 · Veto der Ergebnisfrage ---------------------------------------
zuruecksetzen()
httpx.post(f"{BASIS}/vorpruefung/starten", cookies=keks(ANNA), follow_redirects=False)
ergebnis = antworten(ANNA, {"ergebnis": 2, "wiederholung": 1, "beteiligte": 1,
                            "daten": 1, "verbindlichkeit": 1})
fall("VP-10", "K04-M23",
     "Ergebnis auf 'darin arbeiten' gibt allein den Ausschlag",
     "Unser Vorschlag: eine Anwendung" in ergebnis,
     "vier Dokument-Antworten, dennoch Vorschlag Anwendung")

# --- VP-11 · Zaehlung: kein Treffer ---------------------------------------
zuruecksetzen()
httpx.post(f"{BASIS}/vorpruefung/starten", cookies=keks(ANNA), follow_redirects=False)
ergebnis = antworten(ANNA, {"ergebnis": 1, "wiederholung": 1, "beteiligte": 1,
                            "daten": 1, "verbindlichkeit": 1})
fall("VP-11", "K04-M24", "Kein Treffer in den Fragen 2 bis 4 ergibt Direkt-Prototyp",
     "Unser Vorschlag: ein Arbeitsdokument" in ergebnis, "0 Treffer")

# --- VP-12 · Zaehlung: ein Treffer, Abweichung wird genannt ---------------
zuruecksetzen()
httpx.post(f"{BASIS}/vorpruefung/starten", cookies=keks(ANNA), follow_redirects=False)
ergebnis = antworten(ANNA, {"ergebnis": 1, "wiederholung": 2, "beteiligte": 1,
                            "daten": 1, "verbindlichkeit": 1})
fall("VP-12", "K04-M24",
     "Ein Treffer ergibt Direkt-Prototyp UND nennt die abweichende Antwort",
     "Unser Vorschlag: ein Arbeitsdokument" in ergebnis
     and "immer wieder, im laufenden Betrieb" in ergebnis,
     "1 Treffer; der Satz nennt die abweichende Antwort im Wortlaut")

# --- VP-13 · Zaehlung: zwei Treffer ---------------------------------------
zuruecksetzen()
httpx.post(f"{BASIS}/vorpruefung/starten", cookies=keks(ANNA), follow_redirects=False)
ergebnis = antworten(ANNA, {"ergebnis": 1, "wiederholung": 2, "beteiligte": 2,
                            "daten": 1, "verbindlichkeit": 1})
fall("VP-13", "K04-M24", "Zwei Treffer in den Fragen 2 bis 4 ergeben Anwendung",
     "Unser Vorschlag: eine Anwendung" in ergebnis, "2 Treffer")

# --- VP-14 · Genau ein Begruendungssatz -----------------------------------
satz = re.search(r'<p id="begruendung">(.*?)</p>', ergebnis, re.S)
satztext = satz.group(1).strip() if satz else ""
fall("VP-14", "K04-M25",
     "Der Vorschlag traegt genau einen Begruendungssatz, der eine Antwort nennt",
     satztext.count(".") == 1 and "„" in satztext,
     f"'{satztext}'")

# --- VP-15 · completed_at gesetzt -----------------------------------------
with db() as conn:
    fertig = conn.execute(
        "SELECT completed_at IS NOT NULL FROM quick_check").fetchone()[0]
fall("VP-15", "K04-M22", "Mit der fuenften Antwort traegt der Vorgang completed_at",
     fertig is True, f"completed_at gesetzt: {fertig}")

# --- VP-16 · Ruecknahme statt Loeschen ------------------------------------
httpx.post(f"{BASIS}/schnellweg/antwort", cookies=keks(ANNA),
           data={"frage": "beteiligte", "option": "1"}, follow_redirects=False)
with db() as conn:
    zeilen, zurueck = conn.execute(
        "SELECT count(*), count(*) FILTER (WHERE superseded_at IS NOT NULL)"
        "  FROM quick_answer WHERE question_code = 'beteiligte'").fetchone()
fall("VP-16", "K04-M15",
     "Eine geaenderte Antwort wird zurueckgenommen, nicht entfernt",
     zeilen == 2 and zurueck == 1,
     f"{zeilen} Zeilen zu 'beteiligte', davon {zurueck} zurueckgenommen")

# --- VP-17 · Mandantenschnitt ---------------------------------------------
a = httpx.get(f"{BASIS}/schnellweg", cookies=keks(BERT), follow_redirects=False)
with db() as conn:
    fremde = conn.execute(
        "SELECT count(*) FROM quick_check WHERE tenant_id = %s",
        (MANDANT_BERT,)).fetchone()[0]
fall("VP-17", "K01-M15",
     "Der Vorgang eines fremden Mandanten gilt als nicht vorhanden",
     a.status_code == 303 and a.headers.get("location") == "/vorpruefung"
     and fremde == 0,
     f"Bert: {a.status_code} -> {a.headers.get('location')}; Annas Vorgang bleibt unsichtbar")

# --- VP-18 · Weg Arbeitsdokument: benannt gesperrt, nichts angelegt --------
a = httpx.post(f"{BASIS}/schnellweg/arbeitsdokument", cookies=keks(ANNA),
               follow_redirects=False)
with db() as conn:
    proto = conn.execute("SELECT count(*) FROM direct_prototype").fetchone()[0]
    apps = conn.execute("SELECT count(*) FROM app").fetchone()[0]
fall("VP-18", "K04-D07",
     "Der Weg Arbeitsdokument legt weder ein Dokument noch eine Anwendung an",
     a.status_code == 200 and proto == 0 and apps == 0
     and "noch nicht gebaut" in a.text,
     f"HTTP {a.status_code}, direct_prototype={proto}, app={apps}, benannte Meldung")

# --- VP-19 · Weiterweg gegen den Vorschlag waehlbar -----------------------
seite = httpx.get(f"{BASIS}/schnellweg", cookies=keks(ANNA)).text
fall("VP-19", "K04-M03",
     "Beide Weiterwege stehen gleichwertig; keiner ist ausgegraut",
     "/schnellweg/arbeitsdokument" in seite
     and "/schnellweg/vorpruefung2" in seite
     and "disabled" not in seite,
     "beide Formulare vorhanden, kein disabled")

# --- VP-20 · Vorpruefung 2 legt den Eignungs-Check an ---------------------
a = httpx.post(f"{BASIS}/schnellweg/vorpruefung2", cookies=keks(ANNA),
               follow_redirects=False)
with db() as conn:
    checks = conn.execute(
        "SELECT count(*), min(outcome::text), min(retention_class::text)"
        "  FROM fit_check").fetchone()
fall("VP-20", "K04-D01",
     "Vorpruefung 2 legt genau einen Eignungs-Check an, Ergebnis OFFEN",
     a.status_code == 303 and a.headers.get("location") == "/eignung"
     and checks[0] == 1 and checks[1] == "OFFEN" and checks[2] == "KI_NACHWEIS",
     f"{a.status_code} -> {a.headers.get('location')}, fit_check={checks[0]}, "
     f"outcome={checks[1]}, Klasse={checks[2]}")

# --- VP-21 · Unvollstaendiger Check: Vorpruefung 2 legt nichts an ---------
zuruecksetzen()
httpx.post(f"{BASIS}/vorpruefung/starten", cookies=keks(ANNA), follow_redirects=False)
antworten(ANNA, {"ergebnis": 1, "wiederholung": 1})
a = httpx.post(f"{BASIS}/schnellweg/vorpruefung2", cookies=keks(ANNA),
               follow_redirects=False)
with db() as conn:
    checks = conn.execute("SELECT count(*) FROM fit_check").fetchone()[0]
fall("VP-21", "K04-D11",
     "Ohne Ergebnis legt Vorpruefung 2 keinen Eignungs-Check an",
     a.status_code == 200 and checks == 0,
     f"HTTP {a.status_code}, fit_check={checks}")

# --- VP-22 · Abbruch: kein Vorschlag, completed_at bleibt leer ------------
a = httpx.post(f"{BASIS}/schnellweg/abbruch", cookies=keks(ANNA),
               follow_redirects=False)
with db() as conn:
    offen = conn.execute(
        "SELECT completed_at IS NULL FROM quick_check").fetchone()[0]
fall("VP-22", "K04-G04",
     "Abbruch fuehrt ohne Vorschlag zurueck; der Vorgang bleibt unvollstaendig",
     a.status_code == 303 and a.headers.get("location") == "/vorpruefung"
     and offen is True,
     f"{a.status_code} -> {a.headers.get('location')}, completed_at leer: {offen}")

# --- VP-23 · Leerer Bestand: fail-closed vor dem Schreiben ----------------
zuruecksetzen()
with db() as conn:
    conn.execute("CREATE TEMP TABLE t AS SELECT 1")
    gesichert = conn.execute(
        "SELECT question_code, version, position, label_de, value_token"
        "  FROM quick_option").fetchall()
    conn.execute("DELETE FROM quick_option WHERE question_code = 'daten'")
a = httpx.post(f"{BASIS}/vorpruefung/starten", cookies=keks(ANNA),
               follow_redirects=False)
with db() as conn:
    angelegt = conn.execute("SELECT count(*) FROM quick_check").fetchone()[0]
    for zeile in gesichert:
        conn.execute("INSERT INTO quick_option VALUES (%s,%s,%s,%s,%s)"
                     " ON CONFLICT DO NOTHING", zeile)
fall("VP-23", "K04-M22",
     "Fehlt eine Frage im Bestand, entsteht kein Vorgang (fail-closed)",
     a.status_code == 200 and angelegt == 0 and "nicht bereit" in a.text,
     f"HTTP {a.status_code}, quick_check={angelegt}, benannte Meldung, Verbleib auf EN-03")

# --- Was dieser Lauf NICHT messen kann ------------------------------------
gesperrt("VP-24", "O-M3-5",
         "Die Zuordnung Dokument/Anwendung hat keine eigene Spalte",
         "quick_option traegt sie als Endung am value_token. Ob das fuer "
         "K04-M22 genuegt, ist nicht entschieden (BEF-K04-2).")
gesperrt("VP-25", "K04-M02 gegen K04-M22",
         "Ob EN-03a vor Frage 5 abbrechen darf",
         "K04-M02 sagt 'hoechstens fuenf', K04-M22 'genau fuenf'. Der "
         "Widerspruch ist nicht entschieden (O-K19-11).")

# ---------------------------------------------------------------------------
zaehler = {}
for f in FAELLE:
    zaehler[f["zustand"]] = zaehler.get(f["zustand"], 0) + 1
print("\n=== ERGEBNIS ===")
for z in ("BESTANDEN", "FEHLGESCHLAGEN", "GESPERRT", "NICHT_AUSGEFUEHRT"):
    print(f"  {z:<18} {zaehler.get(z, 0)}")

with open("/home/claude/m3_klausellauf_manifest.json", "w", encoding="utf-8") as f:
    json.dump({"gegenstand": "M3 · EN-03a · Direkt-Prototyp-Check",
               "zweig": "scheibe/m3-schnellweg",
               "server": "FREIRAUM auf uvicorn, PostgreSQL 16.13, frische Datenbank",
               "bestand": "schema/freiraum_datamodel.sql + M30 + M31 + M32 "
                          "+ Seed_Vorpruefung_K04 + Seed_Direkt_Prototyp_Check_K04",
               "zaehlung": zaehler, "faelle": FAELLE}, f,
              ensure_ascii=False, indent=2)
print("\nManifest: /home/claude/m3_klausellauf_manifest.json")
sys.exit(1 if zaehler.get("FEHLGESCHLAGEN") else 0)
