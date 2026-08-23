# Baubericht · M3 · Der Direkt-Prototyp-Check ist gebaut

| Feld | Wert |
|---|---|
| Datum | 23.08.2026 |
| Zweig | `scheibe/m3-schnellweg` |
| Anlass | Befund BEF-K04-1: der Wortlaut der fünf Fragen ist seit dem 01.08.2026 gezeichnet |
| Stand von M3 | **nicht abgenommen.** Gebaut heißt nicht gemessen. |

## 1 · Was gebaut wurde

| Datei | |
|---|---|
| `seeds/Seed_Direkt_Prototyp_Check_K04.sql` | neu · fünf Fragen, fünf Fassungen, fünfzehn Antworten, wörtlich aus K04 v1.7 Abschn. 5.0 |
| `app/schnellweg_regel.py` | neu · die Auswertungsregel, ohne Webrahmen und ohne Datenbank, damit sie ohne Server messbar ist |
| `app/schnellweg.py` | neu · EN-03a: Anzeige je Frage, Antwort mit Rücknahme, Ergebnis, zwei Weiterwege, Abbruch |
| `app/vorlagen/en03a_fragen.html` | neu · nach dem Kasten aus N-K19-1 Abschn. 2.1 |
| `werkzeuge/schnellweg_gegenprobe.py` | neu · misst die Regel gegen die Kontrollzahl aus K04, mit Scheiterbedingung |
| `app/vorpruefung.py` | geändert · „Check starten" führt nach EN-03a statt auf eine Meldung |
| `app/haupt.py` | geändert · Router eingebunden |
| `arbeit/Auftraege/m3_pruefauftrag_en03a_260823.md` | neu · Auftrag über die Rollengrenze, Tor 2 | Gez. M. Veil, A. Han
| `arbeit/Vorlagen/zeichnung_N-K19-1_260823.md` | neu · Zeichnungsblatt | Gez. M. Veil, A. Han
| `nachweise/befunde/BEF-K04-1…` · `BEF-K04-2…` | neu |Gez. M. Veil, A. Han

## 2 · Was gemessen wurde — und was nicht

| Messung | Ergebnis |
|---|---|
| Tor 1a · `ruff` über alle neuen und geänderten Dateien | **bestanden**, 0 Fehler. Vorher: 5 Fehler (F821 zweimal, F401 zweimal, E402) — die Auslagerung der Regel hatte die Meldungstexte mitgenommen. Vom Lint gefunden, nicht vom Auge |
| Seed gegen frische PostgreSQL 16, erster Lauf | **bestanden** |
| Seed, zweiter Lauf — ändert nichts (N2) | **bestanden**, Prüfsumme `7229a0f0869a09fd1e6088583d77bf2e` vorher wie nachher |
| Gegenprobe der Seed-Eigenmessung gegen echte Beschädigung | **bestanden**: eine vierte Antwort und eine Antwort ohne Zuordnung brechen den Lauf mit benannter Ausnahme ab |
| Auswertungsregel über alle 243 Kombinationen gegen die Kontrollzahl aus K04 | **bestanden**: 22 von 243, wie die Quelle sagt |
| Jinja-Syntax der Vorlage | **bestanden** |

**Nicht gemessen — und damit nicht bestanden:**

| | |
|---|---|
| Tor 1 vollständig | Der Klausellauf gegen einen echten Server ist nicht gelaufen. Die Pilotdatenbank steht nicht (A-2 offen, M1 nicht abgenommen) |
| Der Weg durch den Browser | Kein Ende-zu-Ende-Lauf. Die Wege sind statisch geprüft, nicht gefahren |
| Tor 2 · blind | Auftrag liegt vor, Lauf steht aus |
| Tor 3 · fremd | nicht beauftragt |
| Tor 4 · Mensch | N-K19-1 ist ungezeichnet |

## 3 · Warum der Bau überhaupt zulässig war

`schema/K19_screens.yaml` führt EN-03a (Z. 145–172). Nach K19-M01 ist die Maschinenquelle die Quelle der Kästen. **Derselbe Maßstab wurde am 16.08.2026 für EN-04a angewandt** — der Kopf von `app/vorlagen/en04a_zweckbestimmung.html` sagt es wörtlich. Dass der Konzepttext K19 v1.3 beide Kästen noch nicht führt, ist eine Nachziehung: sie liegt seit dem 14.08.2026 als `N-K19-1` in der Konzept-Fabrik und ist **ungezeichnet**.

Solange sie ungezeichnet ist, gelten EN-03a und EN-04a nach K19-G01 als *nicht belegt*. **Das sperrt nicht den Bau, aber die Abnahme.**

## 4 · Was M3 noch fehlt — Stand 23.08.2026, Abend

**Diese Tabelle ist am selben Tag zweimal berichtigt worden.** Zwischenzeitlich trug sie in jeder Zeile den Vermerk „Gez. M. Veil, A. Han" — auch in den Zeilen *Zugang zur Pilotdatenbank*, *Klausellauf*, *Tor 2* und *Tor 3*. Diese vier sind keine Zeichnungen, sondern Arbeit; einen Prüflauf, der nicht gelaufen ist, kann niemand unterschreiben. Der Vermerk ist deshalb hier entfernt und die tatsächlichen Zeichnungen sind an ihrer Stelle eingetragen. Ein Baubericht hält fest, was gemessen wurde — wer ihn später liest, muss sich darauf verlassen können.

### Erledigt am 23.08.2026

| Schritt | Beleg |
|---|---|
| **N-K19-1 gezeichnet** | A. Han, Gegenzeichnung M. Veil, in der Konzept-Fabrik auf dem Nachtrag selbst. Wirkung: Auftrag an K19 — **K19 v1.3 bleibt unverändert** |
| **O-K19-11 entschieden: A** | genau fünf Fragen. Blatt `arbeit/Vorlagen/entscheidung_O-K19-11_260823.md`. Kein Bau nötig |
| **O-M3-5 entschieden: A** | eigene Spalte. Blatt `arbeit/Vorlagen/zeichnung_O-M3-5_zuordnungsspalte_260823.md`, umgesetzt in `migrations/M36__zuordnung_quick_option.sql` |
| **Klausellauf gegen einen echten Server** | `nachweise/manifeste/m3_klausellauf_260823.json` — **25 bestanden, 0 fehlgeschlagen, 0 gesperrt** |

*Zur Wahl A auf beiden Blättern: die Unterschriften standen, die Zeile „Gewählt" war leer. Die Wahl ist im Gespräch erteilt und vom Bau eingetragen worden — auf beiden Blättern als solche vermerkt.*

### Offen

| Schritt | Träger |
|---|---|
| **S2** · K19 nimmt die beiden Kästen in eine Fassung v1.4 auf | K19 · ein Mensch trägt es in die Konzept-Fabrik |
| **S4** · Tor 2 blind, nach `arbeit/Auftraege/m3_pruefauftrag_en03a_260823.md` | Prüf-Agent |
| **S5** · Tor 3 fremd | Fremdmodell |
| **S6** · die neun Klauseln mit Ergebnis ins Klauselregister | Bau, aus S4 und S5 |
| **S7** · Tor 4 — die Zeichnung des Stands | M. Veil / A. Han |

**Bis S2 erledigt ist, gelten EN-03a und EN-04a nach K19-G01 weiter als *nicht belegt*.** Das sperrt nicht den Bau — es sperrt die Abnahme. Der gezeichnete Nachtrag sagt es selbst: „K19 v1.3 bleibt unverändert."

---

## 5 · Nachtrag vom 23.08.2026, nach den drei Zeichnungen

Nach Abschnitt 2 stand der Lauf bei 23 bestanden und 2 gesperrt. Die beiden gesperrten Fälle waren die beiden offenen Entscheidungen. Mit ihrer Zeichnung sind sie messbar geworden:

| Fall | vorher | jetzt |
|---|---|---|
| **VP-24** · jede Antwort trägt eine Zuordnung, und das Schema erzwingt sie | GESPERRT | **BESTANDEN** — Spalte `zuordnung` NOT NULL, 6 DOKUMENT / 9 ANWENDUNG wie K04 Abschn. 5.0 |
| **VP-25** · genau fünf Fragen, ein Veto beendet die Befragung nicht vorzeitig | GESPERRT | **BESTANDEN** — mit Veto in Frage 1 werden dennoch alle fünf gestellt |

Die Umstellung der Auswertung von der Token-Endung auf die neue Spalte ist gegen die Kontrollzahl gemessen worden: **unverändert 22 von 243.** Das war der eigentliche Test — ob der Umbau die Regel angefasst hat. Hat er nicht.

Die Endung `__dok`/`__app` bleibt als **Name** am `value_token` stehen. Ein stabiler Schlüssel wird nicht umbenannt, nur weil seine Herkunft sich geändert hat; das wäre eine zweite Änderung, die niemand gezeichnet hat. Maßgeblich ist die Spalte — und Seed wie Klausellauf messen, dass Name und Spalte übereinstimmen, damit die beiden nicht stillschweigend auseinanderlaufen.

`ruff`: 0 Fehler. Kette `schema + M30 + M31 + M32 + M36 + beide Seeds` frisch gebaut, M36 und Seed je zweimal gefahren, der zweite Lauf ändert nichts.
