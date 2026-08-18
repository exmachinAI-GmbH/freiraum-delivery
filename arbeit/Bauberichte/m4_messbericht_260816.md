# MESSBERICHT · M4 · Scheibe 2

## 1 · Urteil

**M4 ist zur Hälfte gebaut.** Die Datenbankseite trägt: der neue Serverbefehl vergibt die Projektnummer selbst, prüft fünf Dinge, kennt die Zweckbestimmung als Vorbedingung und ist unter `fr_portal` aufrufbar. **Die Bildschirmseite ist nicht angeschlossen:** EN-04 verweist im Erfolgsfall weiterhin auf nichts, und der blinde Prüffaden findet EN-04a auf keinem Weg — 21 von 26 Fällen bleiben gesperrt. **Der Stand ist nicht vorlagefähig**: M31 bricht die bestehende Migrationsprüfung bei MT-29 ab, wodurch MT-30 bis MT-99 in keinem echten Lauf mehr gemessen werden, und der volle Lauf endet mit `Tor 1c: 3 Fehlschlag/Fehlschlaege`.

---

## 2 · Trennung — gewahrt

**Pfadgrenzen.** `git status --short` zeigt keine Datei in beiden Bereichen:

| Bereich | Dateien | Urheber |
|---|---|---|
| `pruefungen/` | `klauseln/zweckbestimmung_daten.sql`, `klauseln/zweckbestimmung_lauf.sh`, `migration/M30__pruefung.sql`, `migration/M30__pruefung.sha256` | genau die vier, die der Prüf-Agent meldet |
| Bau | `app/haupt.py`, `app/zweckbestimmung.py`, `app/vorlagen/en04a_zweckbestimmung.html`, `migrations/M31__*`, `migrations/negativfaelle/M31_N1…N4`, `migrations/pruefe_negativfaelle_M31.sh` | Bau-Agent |
| außerhalb beider | `nachweise/herkunft/herkunft.{json,md}`, `.claude/commands/scheibe.md`, `arbeit/Plaene/scheibe2_m4_plan.md` | siehe unten |

Der Bau hat **nichts** unter `pruefungen/` angefasst. Die Prüfung hat **nichts** außerhalb `pruefungen/` angefasst.

**Blindheit — belegt.** Suche in den beiden neuen Prüfdateien nach allem, was nur der Code kennt (`zweckbestimmung.py`, `en04a`, `app/vorlagen`, `haupt.py`, `zweck_bewertung_menschen`, `zweck_verbotene_praktik`, `zweckbestimmung_erklaert_am`, `zweck_erklaerung_vollstaendig`, `ack_braucht_erklaerung`, `auswerten`, `Name folgt in Stufe`, `nummernvorrat`): **null Treffer.**

Die eine Spalte, die der Prüfling nennt — `fit_check.zweckbestimmung_ack_at` — ist **kein** Codewissen: sie steht bereits in M30. Gemessen an der CI-Datenbank **vor** dem Einspielen von M31 war sie vorhanden. Der Prüfling liest sie zudem über `information_schema` ab und sucht den Nachweis ausdrücklich an beiden möglichen Orten (Spalte *oder* Ereignis), statt einen zu unterstellen.

Die Adressen sind entdeckt, nicht geraten: der Lauf folgt der Weiterleitung nach GEEIGNET und leitet Weiter/Kenntnisnahme/Anlage aus dem Unterschied dreier Fahrten ab. Das ist gegen Regeln geschrieben, nicht gegen Code.

**Zwei Beobachtungen, keine Verletzungen:**
- Der Bau hat `nachweise/herkunft/*` neu erzeugt — außerhalb des ihm genannten Schreibbereichs. Er hat es selbst benannt.
- `.claude/commands/scheibe.md` ist geändert (Vermerke zu Anlage und Klauselschnitt, datiert 16.08.2026). Kein Agentenbericht nennt diese Änderung. Sie stammt vermutlich vom Orchestrator; sie ist zu bestätigen.

---

## 3 · Die Zahlen

| Prüfung | Befehl | Ergebnis |
|---|---|---|
| Aufbau CI | `bash /Users/mveil/freiraum-delivery/aufbau.sh --ci` | DDL + M30 + **M31** geladen, RC=0. M31 läuft im `--ci`-Zweig mit (Glob) |
| **Voller Lauf** | `PGHOST=localhost PGPORT=55433 PGUSER=postgres PGDATABASE=freiraum_ci PGPASSWORD=pilot bash pruefungen/lauf.sh` | `bestanden: 11 · fehlgeschlagen: 3 · gesperrt: 2` · `::error::Tor 1c: 3 Fehlschlag/Fehlschlaege` · **RC=1** |
| · Migrationsprüffälle | im Lauf | `::error::Migrationsprueffaelle nicht bestanden` |
| · Negativfälle | im Lauf | 8 von 8, je an eigener Bedingung |
| · anmeldecode | im Lauf | `16 von 17 bestanden, 1 gescheitert; alle offenen Punkte GESPERRT` (AC-16, Echtversand) |
| · anmeldung | im Lauf | `30 von 30 bestanden, 0 gescheitert` |
| · einloesung | im Lauf | `18 von 18 bestanden, 0 gescheitert` |
| · mitgliedschaft | im Lauf | `8 von 9 bestanden, 1 gescheitert; alle offenen Punkte GESPERRT` (MG-08) |
| · versand | im Lauf | `9 von 9 bestanden, 0 gescheitert` |
| · **vorpruefung** | im Lauf | `::error::vorpruefung — 30 von 32 bestanden, 2 gescheitert` — **VP-24 GESCHEITERT** (neu), VP-08b gesperrt |
| · **zweckbestimmung** | im Lauf | `::error::zweckbestimmung — 3 von 26 bestanden, 23 gescheitert` · davon **21 GESPERRT**, 2 GESCHEITERT (ZB-01, ZB-20) |
| Migrationsprüffälle einzeln | `psql … -v ON_ERROR_STOP=1 -f pruefungen/migration/M30__pruefung.sql` | **RC=3**, Abbruch bei Zeile 455: `ERROR: new row for relation "fit_check" violates check constraint "ack_braucht_erklaerung"` — **MT-30 bis MT-99 ungemessen** |
| Migrationsprüffälle (Diagnosefassung, MT-29 entschärft, nur im Scratchpad) | — | `SUMME: 108 von 111 bestanden, 3 gescheitert`: **MT-27**, **MT-28**, **MT-95b** |
| MT-95 · MT-96 · MT-97 · MT-98 | Diagnosefassung | alle vier **BESTANDEN** |
| **MT-95b** | Diagnosefassung | **GESCHEITERT** — `FEHLER unter fr_portal: permission denied for function create_app_after_fit` |
| Negativfälle M31 | `bash migrations/pruefe_negativfaelle_M31.sh` | 4 von 4 `OK`, je an eigener Bedingung, Wortlaut ausgewiesen; Gegenprobe: nichts liegengeblieben |
| **Migration zweimal** | frische DB, M31 erneut | RC=0, nur `already exists, skipping`-Hinweise. **Schema identisch. Daten identisch.** Einziger Unterschied: die zufälligen `\restrict`-Marker von `pg_dump` |
| Herkunft | `python3 werkzeuge/herkunft.py` | `Bildschirme im Vertrag: 33 · gebaut: 5` · Frage 6: 28 nicht gebaut, **EN-04a ist aus der Fehlliste verschwunden** |
| Lint | `ruff check app werkzeuge mail` | `All checks passed!` RC=0 |
| Syntax | `python3 -m py_compile app/zweckbestimmung.py app/haupt.py app/vorpruefung.py` | RC=0, ohne Ausgabe |
| Shell | `bash -n` über `pruefe_negativfaelle_M31.sh`, `zweckbestimmung_lauf.sh`, `aufbau.sh` | je RC=0 |
| Prüfsumme | `shasum -a 256 pruefungen/migration/M30__pruefung.sql` | `11d91289…3232d` — stimmt mit `.sha256` überein |
| **K23-D05** | `git diff pruefungen/` | **Kein Prüfwert gesenkt.** Einzige Änderung an vorhandenem Prüf-SQL: **Einfügung** von MT-95b (56 Zeilen), nichts entfernt, nichts abgeschwächt |

**K01-M38 / K01-D19 — gemessen, nicht geglaubt.** Kein Eingabefeld für die Projektnummer in `app/vorlagen/en04a_zweckbestimmung.html`; die Vorlage zeigt sie nur an. `app/zweckbestimmung.py:936` ruft `create_app_after_fit(%s, %s, %s, %s)` — **vier** Werte, kein `project_no`. Gegenprobe unter `SET LOCAL ROLE fr_portal` mit zwei Aufrufen hintereinander:

```
 project_no   |   name   | currency | lifecycle_state | retention_class
--------------+----------+----------+-----------------+----------------
 DE-MVR_001_01| Testname | EUR      | DISCOVERY       | HANDELSRECHT
 DE-MVR_002_01| Zweite   | EUR      | DISCOVERY       | HANDELSRECHT
```

Zwei verschiedene Nummern, beide mit Kundenkennung, keine Doppelvergabe. **K01-M27 — fünf Prüfungen:** Mandant existiert · `legal_space = DE` · Konto aktiv und mandantengleich · `fit_check` GEEIGNET und mandantengleich · **`currency = EUR`**, geprüft in `M31:348-358` am tatsächlichen Wert der eben entstandenen Zeile (`INSERT … RETURNING currency`). Die fünfte Prüfung ist gebaut.

---

## 4 · Wo Bau und blinder Prüffall auseinandergehen

### 4.1 · Der Feldname — hier gewinnt der Bau, aber nur knapp

Der Prüfling entdeckt den Bildschirm daran, dass er **zwei nach Feldnamen unterscheidbare** Eingaben führt. Die Vorlage baut pro Frage ein eigenes Formular, aber beide benutzen denselben Namen:

```html
<input type="hidden" name="frage" value="{{ frage.code }}">
<input type="radio" name="antwort" value="ja">
<input type="radio" name="antwort" value="nein">
```

`felder()` gruppiert nach Feldnamen (`zweckbestimmung_lauf.sh:472-476`). Es gibt nur einen sichtbaren Namen — `antwort`. Also wird `FELD2` nie gesetzt, `ZWECK_PFAD` bleibt leer, und **21 Fälle sperren sich in Kette.**

Der Bau folgt hier der Hausart von EN-04 (`frage` + `option`), die in M3 gebilligt wurde. Der Prüffall unterstellt eine Bauart, die keine Klausel zeichnet. **Gegenprobe gemessen:** ich habe den Lauf mit dem eingebauten Notausgang `FREIRAUM_ZWECK_PFAD=/zweckbestimmung` wiederholt — identisches Ergebnis. Es liegt nicht an der Adresse.

**Und doch:** die Merkmalsklassifikation des Prüflings würde tragen. `WORTLAUT_FRAGE_1` enthält fünf M1-Merkmale (Bewerbung, Beschäftigung, Kreditwürdigkeit, Versicherung, Biometrie) und null M2. `WORTLAUT_FRAGE_2` enthält sieben M2-Merkmale und null M1. **Ein einziger Bau-Fix — je Frage ein eigener Feldname — schaltet den gesamten ZB-Faden frei.** Das ist der billigste Weg zu 26 gemessenen Fällen.

### 4.2 · Der Verweis von EN-04 — hier gewinnt die Klausel

`schema/K19_screens.yaml:200` zeichnet: `zustand_erfolg: "GEEIGNET -> EN-04a (Zweckbestimmung)"`. Gemessen an einem laufenden Server: EN-04 führt nach GEEIGNET genau einen Verweis, `href="/uebersicht"`. Und `app/vorpruefung.py:294-301` sagt weiterhin wörtlich:

> „Dieser Schritt ist noch nicht freigeschaltet."

Das ist der M3-Text. M4 hat ihn nicht fortgeschrieben. Die Begründung des Baus — „M4 darf EN-04 nicht umschreiben" — trägt für das Zurücksetzen auf OFFEN (dort prüft `vorpruefung.py` einen Bedingungsnamen), **nicht** für einen Verweis im Erfolgsfall. **Hier gilt die Klausel.**

### 4.3 · MT-95b und ZB-20 — beide messen die falsche Gestalt

Beide rufen `create_app_after_fit` mit **fünf** Werten. Die alte Fassung existiert weiter (der Bau hat sie nur entrechtet), also greift die Vorsichtsklausel von MT-95b (`pronargs=5` → „NICHT GEMESSEN") **nicht** — stattdessen kommt `permission denied for function create_app_after_fit`, und beide Fälle melden ein Rechteproblem, wo eine Signaturänderung vorliegt. Gemessen: die **neue** Vierwert-Fassung gelingt unter `fr_portal` einwandfrei.

Die Absicht des Baus war, blind geschriebene Prüffälle nicht an „Funktion existiert nicht" scheitern zu lassen. Das Ergebnis ist schlimmer: sie scheitern an einer Meldung, die in eine falsche Richtung zeigt.

### 4.4 · VP-24 — hier gewinnt die Klausel eindeutig

```
VP-24 GESCHEITERT  Zweiter Eignungsstrang: fit_check traegt
'…,zweck_bewertung_menschen,zweck_verbotene_praktik,zweckbestimmung_ack_at,zweckbestimmung_erklaert_am'
statt '…,zweckbestimmung_ack_at'
```

Ein bestandener Prüffall aus M3 kippt. Er misst die Spaltenliste von `fit_check` gegen Rang 1 (`schema/freiraum_datamodel.sql` + M30). Der Bau hat Rang 1 erweitert. Der Träger der Zweckbestimmung ist nach **O-K04-8 ausdrücklich offen** — der Bau hat ihn unter O-M4-2 still entschieden. `CLAUDE.md` §6: *„Eine offene Frage still entscheiden"* steht auf der Liste dessen, was nie getan wird.

---

## 5 · Mängel, nach Schwere

### M1 · SPERREND · M31 bricht die bestehende Migrationsprüfung

Die neue Bedingung `ack_braucht_erklaerung` macht MT-29 unmöglich (`M30__pruefung.sql:454`). Der Lauf bricht ab; **MT-30 bis MT-99 werden in keinem echten Lauf mehr gemessen**, einschließlich MT-95, MT-95b, MT-96, MT-97, MT-98. Zusätzlich schlägt die neue Bedingung **vor** `ack_klasse_ki_nachweis` und `ack_nach_eignung` zu: MT-27 und MT-28 scheitern jetzt an der falschen Bedingung und messen nicht mehr, wofür sie geschrieben wurden — derselbe Fehlertyp wie am 02.08.2026.

> **Korrektur:** Nimm `ack_braucht_erklaerung` aus M31 heraus. Der Nachweis, den sie sichern soll, wird bereits von `zweck_erklaerung_vollstaendig` und vom Serverbefehl getragen; eine dritte Bedingung, die eine Rang-1-Prüfung unmöglich macht, kauft nichts. Wird sie fachlich für nötig gehalten, ist das eine Änderung an M30-Verhalten und gehört als Rückfrage an die Founder — nicht in M31. **Die Prüffälle MT-27 bis MT-29 werden nicht angepasst; die Prüfung folgt nicht dem Bau.**

### M2 · SPERREND · EN-04 verweist nicht auf EN-04a

`K19_screens.yaml:200` verlangt `GEEIGNET -> EN-04a`. Gemessen: EN-04 führt nur `href="/uebersicht"`.

> **Korrektur:** Ersetze in `app/vorpruefung.py` den Satz „Dieser Schritt ist noch nicht freigeschaltet." durch einen Verweis auf `/zweckbestimmung` — ein Link, kein Formular, damit EN-04 keinen vierten Weg bekommt. Der Verweis erscheint nur bei `ergebnis == "GEEIGNET"`, wie der Hinweis heute auch.

### M3 · SCHWER · Beide Zweckfragen tragen denselben Feldnamen

Kostet 21 gesperrte Fälle. Keine Klausel verlangt getrennte Namen — aber getrennte Namen kosten nichts und machen den Bildschirm messbar.

> **Korrektur:** In `app/vorlagen/en04a_zweckbestimmung.html` je Frage einen eigenen Namen vergeben (`name="antwort_{{ frage.code }}"`) und in `app/zweckbestimmung.py` in `POST /zweckbestimmung/antwort` entsprechend lesen. Das verborgene Feld `frage` bleibt, damit der Server die Frage weiterhin nicht glaubt.

### M4 · SCHWER · Offene Frage O-K04-8 still entschieden

Der Träger der Zweckbestimmung ist offen. Der Bau hat zwei Spalten an `fit_check` gehängt und damit VP-24 gekippt.

> **Korrektur:** O-K04-8 geht als Rückfrage an die Founder, mit der Ableitung O-M4-2 als Vorschlag und VP-24 als gemessener Folge. Bis zur Entscheidung bleibt VP-24 rot und wird als **Befund** geführt, nicht als Prüffall, der nachzuziehen wäre.

### M5 · MITTEL · Die Fünfwert-Fassung bleibt bestehen

Sie nimmt die Projektnummer weiterhin als Übergabewert entgegen — gegen K01-M38 („vergeben, nicht eingegeben"). Für `fr_portal` ist sie entrechtet, **der Eigentümer `postgres` kann sie weiter aufrufen — und die Anwendung verbindet sich als `postgres`** (`FREIRAUM_DSN` in `pruefungen/lauf.sh:343`). Die Umgehung ist offen, nicht nur theoretisch. Nebenwirkung: MT-95b und ZB-20 melden ein Rechteproblem statt einer Signaturänderung.

> **Korrektur:** `DROP FUNCTION IF EXISTS create_app_after_fit(uuid,text,text,uuid,uuid);` in M31 nachziehen, bedingt über `to_regprocedure` wie schon der REVOKE-Block. Dann greift die Vorsichtsklausel von MT-95b und meldet ehrlich „NICHT GEMESSEN" statt „permission denied".

### M6 · MITTEL · BEF-M4-1 bestätigt

`aufbau.sh:35,39,63,105` lädt im Pilotzweig nur `$M30` namentlich. **M31 läuft gegen `freiraum-pilot` nicht mit.** Nur `--ci` zieht den Glob. Bestätigt gemessen.

> **Korrektur:** In `aufbau.sh` Schritt 4/6 durch dieselbe Glob-Schleife ersetzen, die der `--ci`-Zweig benutzt, mit `pruefe_eingang` je Datei. Die Datei liegt außerhalb des Bau-Schreibbereichs — Nachziehen durch den Orchestrator, bevor jemand gegen `freiraum-pilot` misst.

### M7 · GERING · BEF-M4-2 bestätigt

Gemessen: `retention_class = HANDELSRECHT` an der neu angelegten Anwendung. M30 hält zu Beschluss Nr. 58 fest, dass Projekte vor Stufe 05 `PROJEKT_VORVERTRAG` tragen. Die Entscheidung, nichts zu setzen, ist richtig — eine still geänderte Aufbewahrungsklasse ist eine still geänderte Löschfrist.

> **Korrektur:** als Rückfrage an K15 vorlegen, nicht bauen.

### M8 · BEOBACHTUNG · Ein `fit_check` legt beliebig viele Anwendungen an

Gemessen: zwei Aufrufe mit demselben `p_fit_check` gelingen beide. `fit_check.app_id` zeigt danach auf die **zweite**; die erste Anwendung ist verwaist. Die beidseitige Verknüpfung nach K04-M17 wird vom Bau zwar zurückgelesen — aber je Aufruf, nicht über Aufrufe hinweg. Ob eine Klausel „genau eine Anwendung je Eignungs-Check" verlangt, habe ich nicht entschieden; das Verhalten stammt aus der M30-Fassung und ist **nicht** durch M31 eingeführt.

---

## 6 · Was für M4 noch fehlt

**Nicht gemessen, weil der Bau es sperrt:**
- MT-30 bis MT-99 im echten Lauf (M1). Die Diagnosefassung zeigt: nach Behebung wären 108 von 111 grün.
- ZB-02 bis ZB-19 und ZB-24 — 21 Fälle, gesperrt an M3. Darunter **jeder** Fall zu K04-M20, D09, D10, M08, M17, M21, G12 und zu den Wegen W1–W10.
- **Die Bau-Behauptung „W1–W10 und F1, F2, F5, F6, F7 durchgespielt" ist durch keinen blinden Prüffall belegt.** Sie stammt aus dem Selbstlauf des Baus. Das ist Tor 1, nicht Tor 2.

**Grundsätzlich nicht messbar mit dem heutigen Bestand:**
- **ZB-25 / K01-M27 fünfte Prüfung.** Die `currency`-Prüfung ist gebaut (`M31:357`), aber `app.currency` trägt EUR als Vorgabe und es besteht kein Mandant, an dem eine andere Währung entstünde. Ein Fall dazu könnte nicht scheitern. Der Prüfling weist ihn ausdrücklich als gesperrt aus, statt ihn grün zu melden — richtig.
- **Der Wortlaut der beiden Zweckfragen (O-M4-1).** K04-M19 beschreibt sie inhaltlich, zeichnet keinen Satz. Gemessen wird nur Unterscheidbarkeit an Merkmalen. Die Formulierung des Baus bleibt eine Ableitung.
- **Die zwei letzten Stellen der Projektnummer (`_01`).** Keine Quelle sagt, wofür sie stehen.
- **Die 999er-Grenze des globalen `PROJ`-Zählers.** Abgeleitet, nicht gezeichnet.
- **`legal_space ≠ DE`** ist nur teilweise messbar; ZB-23 lief hier grün, weil der Mandant `fb04` anlegbar war.

**Prozessual offen:**
- Der Prüf-Agent hat `pruefungen/migration/M30__pruefung.sha256` neu gebildet. Die alte Fassung ist nicht mehr rekonstruierbar. Wer die Prüfsummenkette nachrechnet, muss den Wechsel kennen — das ist ein Glied der Nachweiskette nach K23-M18 Nr. 8 und gehört ins Manifest.
- Tor 3 (fremd) steht aus.
- `.claude/commands/scheibe.md` ist von niemandem als Änderung gemeldet.

---

**Umgebung dieses Laufs:** `freiraum-ci`, PostgreSQL 16.14 auf aarch64, Port 55433, Datenbank `freiraum_ci`, gebaut mit `bash /Users/mveil/freiraum-delivery/aufbau.sh --ci`. Alle Wegwerfdatenbanken meiner Messungen sind abgeräumt. Diagnosedateien liegen ausschließlich unter `/private/tmp/claude-501/-Users-mveil/c7cd9bc4-ea30-405e-b4d9-be0d251a1de4/scratchpad/`; im Repo wurde nichts geändert, es liefen nur `git status` und `git diff`.