# Zeichnungsblatt · O-M3-5 · Eine eigene Spalte für die Zuordnung

| Feld | Wert |
|---|---|
| Vorgelegt am | 23.08.2026 |
| Vorgelegt von | Coding-Harness |
| Zu entscheiden von | Founder mit dem Datenmodell — dieselbe Zuständigkeit wie O-K04-8 und O-K04-10 |
| Betrifft | `quick_option` · K04-M22 · M3 |
| Anlage | `M36_entwurf_zuordnungsspalte_260823.sql` — der fertige Migrationsentwurf. **Er wird nicht gezeichnet, dieses Blatt wird gezeichnet.** |
| Fällig | vor der Abnahme von M3. Der Klausellauf führt **VP-24 als GESPERRT** — nicht als offen, sondern als nicht erbracht |

---

## 1 · Worum es geht, in vier Sätzen

K04-M22 verlangt „je Antwort eine Zuordnung zu *Dokument* oder *Anwendung*".

`quick_option` trägt sie nicht. Beim Nachbau nach dem Muster `fit_option` (Sammelmigration M30, Abschn. 3f) ist die dritte Sachspalte — dort `is_eligible` — ersatzlos entfallen.

Der Bau behilft sich seit dem 23.08.2026 mit einer Endung am `value_token`: `__dok` oder `__app`. Der Seed misst sie nach und bricht ab, wenn eine fehlt.

Das hält — aber es hält nur, solange sich alle daran halten. Das Schema erzwingt nichts.

## 2 · Die beiden Möglichkeiten

### A · Eigene Spalte — der Migrationsentwurf M36

| | |
|---|---|
| **Was geschieht** | `quick_option` bekommt eine Spalte `zuordnung` vom Typ `quick_zuordnung` (`DOKUMENT` · `ANWENDUNG`), Pflichtfeld. Der Bestand wird einmal aus der heutigen Endung übersetzt |
| **Aufwand** | Die Migration ist geschrieben und gemessen. Danach: Seed, Auswerter und Gegenprobe nachziehen — **etwa zwei Stunden** |
| **Gemessen am 23.08.2026** | Zweimal gegen die Laufdatenbank gefahren, der zweite Lauf ändert nichts. Ergebnis 6 `DOKUMENT` / 9 `ANWENDUNG` — genau die Aufteilung aus K04 Abschn. 5.0. Eine Antwort ohne Endung bricht den Lauf ab |
| **Dafür** | K04-M22 wird vom Schema getragen, nicht von einer Verabredung. VP-24 wird messbar |
| **Dagegen** | Eine Migration mehr in der Kette. `value_token` verliert eine Bedeutung, die heute mitgelesen wird — der Auswerter muss umgestellt werden |

### B · Beim Behelf bleiben

| | |
|---|---|
| **Was geschieht** | Nichts. Die Endung am `value_token` bleibt die Zuordnung |
| **Aufwand** | null |
| **Dafür** | Kein Eingriff ins Schema kurz vor der Abnahme. Der Behelf funktioniert nachweislich |
| **Dagegen** | **K04-M22 bleibt im Schema offen.** Der Prüf-Agent darf ihn als *„NICHT PRÜFBAR aus der Klausel"* zurückgeben — und ein fehlendes Ergebnis ist nach K23-M22 nicht bestanden, sondern nicht erbracht. Derselbe Fall wie der fehlende Riegel für die Rubrik-Fassung: eine Pflicht, die gilt, solange sich alle daran halten |

**Der Bau empfiehlt nichts. Er nennt, was jede Wahl kostet.**

## 3 · Was bei A nachzuziehen ist — nicht Teil der Migration

| | |
|---|---|
| 1 | `seeds/Seed_Direkt_Prototyp_Check_K04.sql`: `zuordnung` ausdrücklich setzen, Endung entfällt |
| 2 | `app/schnellweg.py`, `fragen_lesen`: die Spalte mitlesen |
| 3 | `app/schnellweg_regel.py`: `token.endswith('__app')` weicht dem gelesenen Spaltenwert |
| 4 | `werkzeuge/schnellweg_gegenprobe.py`: muss danach **unverändert 22 von 243** ergeben |
| 5 | VP-24 im Klausellauf steht dann nicht mehr auf GESPERRT |

## 4 · Zeichnung

| Feld | Wert |
|---|---|
| Gewählt | ☒ **A** eigene Spalte (Migration M36) ·  ☐ ~~B beim Behelf bleiben~~ |
| Gezeichnet durch | _____A. Han___________________  ·  Datum: ______23.8.26______ |
| Gegenzeichnung | _________M. Veil_______________  ·  Datum: ____23.8.26________ |
| Wirkung bei A | `M36_entwurf_zuordnungsspalte_260823.sql` wird nach `migrations/M36__zuordnung_quick_option.sql` übernommen und gefahren. O-M3-5 geschlossen |
| Wirkung bei B | O-M3-5 bleibt als benannter Restpunkt stehen und geht mit der Abnahme in die Restrisikoliste. Der Prüf-Agent misst VP-24 nicht |

**Vermerk des Baus zur Wahl.** Die beiden Unterschriften standen am 23.08.2026 auf dem Blatt, die Zeile *Gewählt* war leer. Die Wahl **A** ist am selben Tag im Gespräch erteilt und vom Bau hier eingetragen worden — sie stammt nicht von einer Hand auf diesem Blatt. Wer das später prüft, soll den Unterschied sehen können.
