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
| `arbeit/Auftraege/m3_pruefauftrag_en03a_260823.md` | neu · Auftrag über die Rollengrenze, Tor 2 |
| `arbeit/Vorlagen/zeichnung_N-K19-1_260823.md` | neu · Zeichnungsblatt |
| `nachweise/befunde/BEF-K04-1…` · `BEF-K04-2…` | neu |

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

## 4 · Was M3 noch fehlt

| Schritt | Träger |
|---|---|
| `N-K19-1` zeichnen — löst M3 **und** M4 | A. Han · Gegenzeichnung M. Veil |
| Zugang zur Pilotdatenbank (A-2) | M. Veil |
| Klausellauf und Ende-zu-Ende-Lauf gegen einen echten Server | Bau |
| Tor 2 · blind, nach dem vorliegenden Auftrag | Prüf-Agent |
| Tor 3 · fremd | Fremdmodell |
| O-K19-11 entscheiden: „genau fünf" gegen „höchstens fünf" | K04, hilfsweise K00 |
| O-M3-5 entscheiden: eigene Spalte für die Zuordnung | Founder mit dem Datenmodell |

*Von diesen sieben Punkten liegen fünf außerhalb dessen, was der Bau leisten kann.*
