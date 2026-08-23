# BEF-MG-08 · Der Ablauf einer Einladung ist nicht gebaut

| | |
|---|---|
| **Gegenstand** | Prüffall `MG-08` · Vertragssatz *„beim Ablauf verschwindet sie wieder"* |
| **Art** | Befund mit Träger und Frist — **kein** offener Punkt von M2 (siehe Abschnitt 2) |
| **Festgestellt** | 20.08.2026 (Standortbestimmung) · als Befund geführt seit 23.08.2026 |
| **Zustand** | **gesperrt** — nicht durchgefallen, sondern über keine bekannte Tür prüfbar |
| **Träger** | A. Han (fachlich) · Bau (Umsetzung) |
| **Frist** | vor Pilotstart |

---

## 1 · Was gemessen ist

`app/einladung.py` lässt eine abgelaufene Einladung auf `VERSANDT` stehen; der Einlösepfad
räumt sie nicht auf. `app/einladung_senden.py` hält im Programmtext selbst fest, dass ohne
einen späteren Neuversand **niemand** die Mitgliedschaft aufräumt.

`MG-08` erkennt das und meldet deshalb **gesperrt** statt bestanden — nach K23-M22 ist das
nicht dasselbe wie durchgefallen, aber auch nicht dasselbe wie erfüllt. Der Stand erfüllt
seinen eigenen Vertragssatz *„beim Ablauf verschwindet sie wieder"* heute nicht.

## 2 · Warum er M2 nicht sperrt — die Auslegung vom 23.08.2026

**Gezeichnet: Lesart A.**

Die Nachrechnung zu M2 in §6a des Bauauftrags nennt **vier** Sätze, wörtlich:

> *eine echte Zustellung mit abgelesenem Mailkopf; `event` trägt die Anmeldung; Code verfällt
> nach 10 Minuten; Sperre nach fünf Fehlversuchen greift*

Der Ablauf einer Einladung ist keiner davon. Er steht als Vertragssatz an anderer Stelle. Die
Standortbestimmung vom 20.08.2026 hat ihn dennoch unter den offenen Punkten von M2 geführt —
das war eine Zuordnung des Harness, keine Klausel.

**Folge:** M2 ist mit dem Bestehen von AC-16 am 23.08.2026 eingetreten. MG-08 wird ab hier
als eigener Befund geführt und fällt in einen späteren Stand.

> **Was diese Auslegung NICHT sagt:** dass der Punkt unwichtig wäre. Eine Einladung, die nach
> Ablauf weiterbesteht, ist ein offener Zugang, den niemand mehr erwartet. Sie sagt nur, an
> welchem Meilenstein er gemessen wird — und das ist nicht M2.

## 3 · Was zu entscheiden bleibt

Der Ablauf ist **nicht** gebaut, und ihn zu bauen heißt zweierlei: den Zustandswechsel
umsetzen **und** eine Tür schaffen, durch die er messbar ist. Heute gibt es keine — deshalb
ist MG-08 gesperrt und nicht rot.

| | Weg | Kosten |
|---|---|---|
| **A** | Ablauf umsetzen: eine abgelaufene Einladung wechselt ihren Zustand, die Mitgliedschaft wird aufgeräumt, ein Prüfpfad macht es sichtbar | mehrere Bautage, Konzeptnachtrag möglich |
| **B** | Nur den Zustandswechsel, ohne Aufräumen der Mitgliedschaft | halbe Sache — der Vertragssatz spricht von *verschwinden* |
| **C** | Als Restrisiko annehmen und den Vertragssatz ändern | Änderung am gezeichneten Konzept, nicht am Bau |

**Der Harness empfiehlt hier den Vorgang, nicht den Inhalt:** Der Weg gehört dem fachlichen
Eigentümer. Was der Bau sagen kann, ist, dass A ohne einen Konzeptnachtrag nicht auskommt,
wenn dabei ein neuer Bildschirm oder eine neue Aktion entsteht — und dass der Weg dorthin
nach §12.6 gesperrt ist, solange A-1 offen ist.

## 4 · Anschluss

- Zu führen in der Restrisikoliste mit Träger und Frist (`nachweise/restrisiken/`).
- Bei der nächsten Standortbestimmung **nicht** wieder unter M2 einsortieren — die Auslegung
  vom 23.08.2026 ist der Grund.
