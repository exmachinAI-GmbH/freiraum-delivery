# Auflagen zu M1 · was benannt getragen wird

**Angelegt am 22.08.2026** nach dem Fremdurteil zum Abnahmestand `9f89310`.

Dieses Blatt führt die Punkte, die zum Zeitpunkt der Abnahme **nicht belegt** sind — einzeln,
mit Träger und Frist. Es macht sie nicht kleiner. Es macht sie auffindbar.

> Die Restrisikoliste des Harness verlangt genau das: *„Jede Klausel ohne Golden-Test — einzeln
> benannt, nicht zusammengefasst."* Eine Auflage, die niemand aufschreibt, taucht beim nächsten
> Nachrechnen als Lücke auf.

---

## A-1 · Beleg 4 ist auf leeren Tabellen gemessen

**Der Befund, im Wortlaut des Fremdmodells:**

> „Alle acht aufgeführten Tabellen stehen vorher und nachher auf 0. Das belegt keine Erhaltung
> vorhandener Zeilen und trägt insbesondere keinen realistischen Bestandsmigrationsfall."

**Er trifft zu.** Beleg 4 weist nach, dass die eingefrorenen Prüffälle T0–T23 nichts in der
Datenbank hinterlassen. Gemessen wurde das an sieben Tabellen, die vorher **und** nachher auf
null standen. Auf einer leeren Datenbank ist „hinterlässt nichts" trivial wahr.

**Was trotzdem gemessen ist:** Die Transaktionsklammer selbst greift — sie wurde am 22.08.2026
gegen eine Datenbank **mit** Zeilen geprüft, bevor sie in den Lauf kam
(`migrations/_werkzeug/pruefklammer.sql`). Ungemessen ist nur der Zusammenbau: Klammer *und*
Zielumgebung *und* vorhandene Zeilen zugleich.

| | |
|---|---|
| **Schwere** | mittel — der Mechanismus ist belegt, seine Wirkung im Bestandsfall nicht |
| **Träger** | A. Han, für den Auftragnehmer |
| **Frist** | mit **M11** (Lastprüfung, Mandantentrennung) — dort liegen ohnehin Zeilen in der Datenbank |
| **Erledigt, wenn** | Beleg 4 einmal gegen eine Datenbank mit Bestand gefahren ist und die Zählungen vorher = nachher bleiben |

---

## A-2 · `bestand_pilot` in `kanon.yaml` ist nachzuziehen

Die Objektzahlen des Laufs stimmen in **fünf von sechs** Werten mit dem Soll überein. Die
sechste — Funktionen 29 statt 27 — ist erklärt: M31 und M32 ergänzen zwei. Aber das Soll selbst
ist als *„v2.9 + M30"* bezeichnet und beschreibt damit den **alten** Maßstab.

| | |
|---|---|
| **Schwere** | gering — die Abweichung ist erklärt und in `SOLL_zielbestand_M1.md` benannt |
| **Träger** | M. Veil, über die Konzept-Fabrik (F6) |
| **Frist** | vor der nächsten Konzeptprüfung, die Objektzahlen nennt |
| **Erledigt, wenn** | `bestand_pilot` den geltenden Maßstab führt: 29 Funktionen |

**Der Harness zieht das nicht selbst nach** — `kanon.yaml` liegt in der Konzept-Fabrik, und
dorthin schreibt er nie.

---

## A-3 · Der Auftragstext führt die alte Rangfolge

`CLAUDE.md`:44 ist am 22.08.2026 auf den erweiterten Maßstab nachgezogen. Der Bauauftragstext
:80–86 führt ihn wortgleich in der alten Fassung weiter. Die Berichtigung ist am 22.08.2026
angewiesen und gehört zu Arbeitspaket **A-1** der Projektsteuerung.

| | |
|---|---|
| **Schwere** | mittel — zwei geltende Stände widersprechen sich |
| **Träger** | M. Veil |
| **Frist** | vor dem nächsten Meilenstein, der sich auf Rang 1 beruft |
| **Erledigt, wenn** | der Auftragstext den erweiterten Maßstab führt |

**Bis dahin gewinnt die Zeichnung** — sie ist jünger und ausdrücklich. Das steht an beiden
Stellen vermerkt.

---

## Was ausdrücklich KEINE Auflage ist

Mehrere Punkte des ersten Fremdurteils vom 22.08.2026 waren **Folge einer gekürzten Vorlage**,
nicht des Laufes: dass sich 3 337 Zeilen nicht aus 142 200 Byte nachrechnen lassen, dass die
Prüffallsumme nicht nachzählbar sei, dass 82 gegen 54 Datenzeilen stünden. Dem Modell lagen
Dateigrössen und Auszüge vor, nicht die Dateien.

**Das war ein Fehler in der Vorlage der Evidenz, und er ist behoben:** Das zweite Fremdurteil
erging gegen die vollständigen Dateien. Wer beide Urteile nebeneinanderlegt, sieht den
Unterschied — und sollte ihn sehen. Ein Prüfer, der zu wenig sieht, findet Mängel, die keine
sind, und übersieht welche, die es sind.

---

---

## Zeichnung

*Eingetragen auf Weisung des Auftraggebers vom 22.08.2026. Wortlaut der Weisung:*

> „A-1, A-2, A-3 werden getragen, gez. M. Veil, 22.08.2026."

- [x] **A-1** · Beleg 4 ist auf leeren Tabellen gemessen — **getragen**, Träger A. Han, Frist mit M11
- [x] **A-2** · `bestand_pilot` ist nachzuziehen — **getragen**, Träger M. Veil über die Konzept-Fabrik (F6)
- [x] **A-3** · Der Auftragstext führt die alte Rangfolge — **getragen**, Träger M. Veil, Arbeitspaket A-1

**gez. M. Veil, Auftraggeber, 22.08.2026**

| Name | Rolle | Datum |
|---|---|---|
| **M. Veil** | Auftraggeber | **22.08.2026** |
| A. Han | für den Auftragnehmer | ⟨ ⟩ |

**Was „getragen" heisst.** Die drei Punkte sind damit nicht behoben, sondern **benannt,
zugeordnet und terminiert**. Sie bleiben offen und sichtbar, bis ihr jeweiliges „Erledigt,
wenn" eintritt. Ein getragener Punkt ist kein erledigter — er ist einer, der niemandem mehr
unbemerkt durchgeht.

---

*Angelegt vom Orchestrator, gezeichnet vom Auftraggeber am 22.08.2026.*
