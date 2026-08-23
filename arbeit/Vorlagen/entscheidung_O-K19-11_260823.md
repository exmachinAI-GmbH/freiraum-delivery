# Entscheidungsvorlage · O-K19-11 · „höchstens fünf" oder „genau fünf"

| Feld | Wert |
|---|---|
| Vorgelegt am | 23.08.2026 |
| Zu entscheiden von | K04, hilfsweise K00 — praktisch beide Founder |
| Betrifft | EN-03a · M3 · den Auswerter in `app/schnellweg_regel.py` |
| Fällig | vor der Abnahme von M3. Der Klausellauf führt den Fall **VP-25 als GESPERRT** — nicht als offen, sondern als nicht erbracht |
| Wirkung der Zeichnung von N-K19-1 | **keine.** Der Nachtrag sagt selbst: „Kein hier als *nicht belegt* geführter Punkt gilt mit dieser Zeichnung als entschieden" (Punkt A4) |

---

## 1 · Der Widerspruch, in drei Quellen

| Quelle | Wortlaut |
|---|---|
| **K04-M02** (K04 v1.7) | „Er stellt **höchstens fünf** kurze Fragen." |
| **K04-M22** (K04 v1.7) | „Der Direkt-Prototyp-Check MUSS **genau fünf** Fragen führen." |
| Endnutzer-Handbuch v2.9, Abschn. 3.1 | „stellt Ihnen **bis zu fünf** kurze Fragen" |

Zwei Klauseln desselben freigegebenen Konzepts sagen Verschiedenes. Nach K19-G05 ist ein solcher Widerspruch auszuweisen und **nicht vom Bau zu entscheiden**.

## 2 · Was der Bau heute tut

**Fünf Fragen fest.** Begründung: K04-M22 ist die speziellere Klausel — sie regelt den Fragenkatalog, K04-M02 beschreibt den Bildschirm im Überblick. Und nur diese Lesart trifft die Kontrollzahl, die K04 selbst nennt.

*Das ist eine Auslegung des Baus, keine Entscheidung. Sie steht hier, damit sie widerrufen werden kann.*

## 3 · Die beiden Möglichkeiten

### A · Genau fünf — der heutige Bau

| | |
|---|---|
| **Ablauf** | Der Kunde beantwortet alle fünf Fragen, dann kommt der Vorschlag |
| **Aufwand** | **null.** Gebaut und gemessen: 23 Fälle im Klausellauf vom 23.08.2026 |
| **Kontrollzahl** | 22 von 243 — stimmt mit K04 Abschn. 5.0 überein |
| **Dafür** | Alle fünf Antworten liegen vor. Der Nutzer sieht, worauf der Vorschlag beruht, und kann jede Antwort ändern. Der Begründungssatz kann auf jede der fünf zeigen |
| **Dagegen** | Wer schon bei Frage 1 „etwas, in dem ich arbeite" wählt, beantwortet vier Fragen, die nichts mehr ändern. K04-M02 spricht von *kurzen* Fragen — das Versprechen war Tempo |

### B · Adaptiver Abbruch — Restfragen entfallen sichtbar

| | |
|---|---|
| **Ablauf** | Sobald ein Veto greift, endet die Befragung und der Vorschlag erscheint |
| **Aufwand** | **ein halber Bautag.** Der Auswerter muss nach jeder Antwort prüfen statt am Ende; der Bildschirm muss die entfallenen Fragen sichtbar machen (sonst wirkt es wie ein Fehler); `werkzeuge/schnellweg_gegenprobe.py` braucht eine zweite Sollzahl |
| **Kontrollzahl** | **Ändert sich.** Nicht mehr 22 von 243 — viele Kombinationen sind dann gar nicht mehr erreichbar. Die Zahl aus K04 Abschn. 5.0 wäre nachzuziehen |
| **Dafür** | Hält, was „höchstens fünf" verspricht. Der frühere Entwurf K04 v0.1 hatte genau das vorgesehen: „adaptiver Abbruch, Rest entfällt" |
| **Dagegen** | Der Vorschlag steht dann auf **einer** Antwort. Ändert der Nutzer sie, muss der ganze Fluss neu aufgerollt werden. Und: die Kontrollzahl ist heute der einzige blind messbare Maßstab für die Auswertung — sie aufzugeben kostet dem Prüf-Agenten sein bestes Werkzeug |

## 4 · Was in jedem Fall nachzuziehen ist

| Bei A | Bei B |
|---|---|
| **K04-M02 berichtigen**: „höchstens fünf" → „genau fünf". Sonst bleibt der Widerspruch im gezeichneten Konzept stehen | **K04-M22 berichtigen**: „genau fünf" → „höchstens fünf" |
| Handbuch 3.1: „bis zu fünf" → „fünf" | Handbuch bleibt |
| — | Die Kontrollzahl in K04 Abschn. 5.0 neu rechnen und ersetzen |
| O-K19-11 in K19 Abschn. 11 schließen | O-K19-11 schließen |

## 5 · Zeichnung

| Feld | Wert |
|---|---|
| Gewählt | ☐ **A** genau fünf ·  ☐ **B** adaptiver Abbruch |
| Gezeichnet durch | ________________________  ·  Datum: ____________ |
| Gegenzeichnung | ________________________  ·  Datum: ____________ |

*Mit der Zeichnung wird O-K19-11 geschlossen und VP-25 im Klausellauf von GESPERRT auf messbar gestellt. Bei A ist danach nichts zu bauen; bei B ein halber Tag.*
