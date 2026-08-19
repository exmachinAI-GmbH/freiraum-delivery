# M5 · Bauplan des ersten Zuges — **freigegeben, noch nicht gebaut**

**19.08.2026 · Bauunterlage.** Was hier steht, ist die Reihenfolge, in der gebaut wird.

**Stand am Abend des 19.08.: freigegeben.** `m5_bauzug_freigabe_260819.md` trägt B-1, B-2 und
B-3; B-17 ist am selben Tag mitgezeichnet worden (`vorlage_neun_entscheidungen_260816.md`).
Damit ist die letzte der fünf Fragen des Fremdmodells entschieden — die Vorbedingung aus
`CLAUDE.md` Abschn. 6 ist erfüllt. **Gebaut ist noch nichts.**

---

## Zug 1 · Die Migration — `M32__zeilenschutz_und_stufenwechsel.sql`

**Ein Migrationszug, drei gezeichnete Gegenstände.** Sie gehören zusammen, weil sie dieselbe
Stelle anfassen (Entscheidung 2 zu Blatt 100, Blatt 99 Entscheidung 1).

| | Was | Grundlage |
|---|---|---|
| **1a** | **Zeilenregeln für `app`, `document`, `event`** — übernommen aus `migrations/uebernahme/M31__zeilenschutz_VORSCHLAG.sql`, eingeengt auf die drei Tabellen von M5 | S-A, gez. 19.08. · RR-04 |
| **1b** | **`FORCE ROW LEVEL SECURITY`** auf denselben drei Tabellen | sonst läuft der Eigentümer daran vorbei — der Serverpfad verbindet heute als Eigentümer |
| **1c** | **`change_app_state` schreibt die `event`-Zeile atomar mit** — per `CREATE OR REPLACE`, nicht an Ort und Stelle | Blatt 99, Entscheidung 1 |
| **1d** | **Neue Funktion `set_journey_phase`** — `SECURITY DEFINER`, fester Suchpfad, Rechteprüfung, `GRANT EXECUTE` an `fr_portal`, Protokolleintrag im selben Zug | E2: `journey_phase` hat **keinen** Schreibweg; K05-M08, K05-M19 |
| **1e** | **Keine Verlaufszeile für `journey_phase`** | RR-05, gezeichnet: `app_state_history` bleibt bei `lifecycle_state` |

**Vier Negativfälle** (`migrations/negativfaelle/M32_N1..N4`), je an der eigenen Bedingung:

1. `set_journey_phase` ohne gültige Mitgliedschaft → abgewiesen, kein `event`
2. Stufenwechsel mit vom Client übergebener Stufe → wirkt nicht
3. Lesen einer `document`-Zeile eines fremden Mandanten bei gesetztem `freiraum.tenant_id` → keine Zeile
4. `change_app_state` mit unterdrücktem `event`-Schreibweg → **gesamter** Vorgang zurückgerollt

> **Ohne 1b ist 1a wirkungslos**, und ohne den Serverpfad, der `freiraum.tenant_id` setzt, sind
> beide es. Deshalb steht Zug 2 nicht hinten an.

## Zug 2 · Der Serverpfad setzt den Mandanten

`app/datenbank.py`: jede Verbindung setzt `freiraum.tenant_id` aus der Sitzung, **bevor** die
erste Anweisung läuft. Der Umfang ist größer als M5 — auch die fünf Bildschirme aus M1–M4
schreiben heute ohne ihn (RR-04, ausdrücklich benannt).

## Zug 3 · Die Ablage-Attrappe

Eine Schnittstelle mit vier Verrichtungen — *schreiben · lesen · Hash prüfen · sperren*.
Dahinter im Prüfstand das Dateisystem, im Pilot der private Objektspeicher (S-E, Zeile A).
Schlüssel: `uuid` v4, serverseitig erzeugt (T-5). Zugriffsdauer, falls ausgestellt: **10 Minuten**.

## Zug 4 · Die zehn Serverbefehle

`app/gespraech.py` — sieben reine Serverpfade, zwei über `set_journey_phase`,
`upload_interview_document` **zurückgestellt** (Blatt 100, E4). Jeder Befehl: Serverpfadprüfung
nach K05-M24 (Konto · Mitgliedschaft · Rolle · Mandant · Objektbezug), Dreischritt Datei →
`document` → `event` nach K05-M26, Protokolleintrag atomar.

## Zug 5 · Die zwei Bildschirme

`app/vorlagen/en05_orientierung.html` und `en06_interview.html`, **je nach ihrem K19-Kasten**
(`schema/K19_build_referenz.md:252` und `:267`), Gestaltung ausschließlich aus `token.css`.

**Die zwölf Themen, drei Einordnungsfragen und sieben Ziele fehlen im Wortlaut.** Gezeichneter
Rückfallweg (S-G): der freie Weg trägt, die Auswahllisten führen die benannte Meldung zum
ungezeichneten Wortlaut — wie EN-03a es vormacht.

---

## Was der Bau **nicht** anfasst

`pruefungen/` (der blinde Prüf-Agent schreibt dort), `.github/` und `.claude/` (bis B-1
gezeichnet ist), die Konzept-Fabrik (nie).

## Die Reihenfolge in einem Satz

**1 → 2 → 3 → 4 → 5**, und nach jedem Zug ein Lauf gegen eine frische Datenbank; der zweite
Lauf muss Schema **und** Daten unverändert lassen.
