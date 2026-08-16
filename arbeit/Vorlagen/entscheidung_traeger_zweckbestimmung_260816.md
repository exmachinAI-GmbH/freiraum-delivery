# Entscheidungsvorlage · Wo werden Zweckbestimmung und Kenntnisnahme gespeichert?

**Offener Punkt O-K04-8 und die von ihm nicht erfasste Schwesterfrage.**

| | |
|---|---|
| **An** | M. Veil (Auftraggeber) · A. Han (für den Auftragnehmer) |
| **Von** | Orchestrator des Coding-Harness |
| **Art** | **Vorlage. Keine Entscheidung.** |
| **Vorgelegt** | 16.08.2026 |
| **Anlass** | Der Bau von M4 hat die Frage still entschieden. Das ist zurückzunehmen oder zu bestätigen — beides gehört Ihnen, nicht dem Bau |

---

## Worum es geht, ohne Fachwort

Bevor eine Anwendung entsteht, muss der Kunde zwei Fragen beantworten: **ob seine Anwendung
Menschen bewertet** (dann kann die KI-Verordnung mit Anhang III greifen) und **ob sie eine
verbotene Praktik ist** (dann ist der Weg zu Ende, Artikel 5).

Bejaht er die erste, bekommt er eine Warnung und muss sie **bestätigen**. Diese Bestätigung
ist kein Häkchen, das verfällt: Sie ist der Nachweis, mit dem sich später belegen lässt, dass
er wusste, was er tut. Ohne sie ist eine gesetzliche Auskunftspflicht nicht erfüllbar.

**Die Frage dieser Vorlage lautet: Wo werden diese Angaben gespeichert?**

---

## Warum es überhaupt offen ist

**Das Datenmodell hat dafür keinen Platz vorgesehen.** Zwei Lücken, und nur eine ist bisher
als offener Punkt geführt:

| | Was fehlt | Wie es geführt wird |
|---|---|---|
| **Die Kenntnisnahme** — die Bestätigung des Kunden | **O-K04-8**, offen: *„Für die Kenntnisnahme aus K04-M21 führt das Datenmodell keine Spalte. Eigenes Feld an `fit_check`, oder Ereignis nach K02?"* Entscheider: Founder und Datenmodell, fällig **vor dem ersten Kundenprojekt** |
| **Die zwei Antworten selbst** | **von keinem offenen Punkt erfasst.** Erst am 14.08.2026 als **B12** eines Nachtrags benannt: *„Träger der Zweckbestimmung im Datenmodell: nicht belegt und von keinem offenen Punkt erfasst … O-K04-8 deckt allein die Kenntnisnahme."* |

Für die Kenntnisnahme gibt es einen **gezeichneten Behelf** — K04-G12: *„Solange kein Träger
besteht, wird sie als Ereignis geführt. Ein Schritt ohne Nachweis wäre eine Zusage ohne
Beleg."* Für die zwei Antworten gibt es keinen.

---

## Was der Bau getan hat — und warum das vorgelegt und nicht verschwiegen wird

Der Bau von M4 hat am 16.08.2026 **zwei Spalten an die Prüftabelle gehängt** und dazu eine
Bedingung. Er hat damit den Träger gewählt, den O-K04-8 offenlässt.

**Das ist ein Regelverstoß, und er ist gemessen worden.** Die Verfassung des Harness führt
unter *„Was du nie tust"*: **„Eine offene Frage still entscheiden."**

Aufgefallen ist es, weil ein **bestandener Prüffall aus M3 gekippt ist**: Er misst, welche
Felder die Prüftabelle führt, und vergleicht das mit der obersten Quelle. Der Bau hat diese
Quelle erweitert — also schlug der Fall an.

> **Der Prüffall wird nicht nachgezogen.** Er bleibt rot, bis Sie entschieden haben. Die
> Prüfung folgt nicht dem Bau; sonst misst sie den Bau statt die Regel.

Dass es aufgefallen ist, ist kein Zufall: Bau und Prüfung liefen gleichzeitig und blind. Der
Prüfling kannte den Bau nicht — deshalb hat er gegen die Regel gemessen und den Verstoß
sichtbar gemacht.

---

## Die drei Wege

### Weg A · Zwei Felder an der Prüftabelle

Die Antworten stehen dort, wo auch die Eignungsprüfung steht. Ein Blick, eine Zeile.

| | |
|---|---|
| **Dafür** | Die Angaben gehören sachlich zur Eignungsprüfung und werden immer zusammen gelesen. Kein Umweg, keine zusätzliche Verknüpfung. Der Bau hat es bereits so gebaut — die Entscheidung wäre sofort wirksam |
| **Dagegen** | Die oberste Quelle wächst. Jeder Prüffall, der die Feldliste misst, ändert sich mit. Und ein Feld lässt sich überschreiben — die Antwort von gestern ist dann weg |

### Weg B · Ein Ereignis, wie der Behelf es vorsieht

Jede Antwort wird als Vorgang festgehalten, nicht als Zustand. Ereignisse werden hier nie
verändert und nie gelöscht.

| | |
|---|---|
| **Dafür** | **Nichts geht verloren.** Wer wann was geantwortet hat, bleibt nachvollziehbar — auch nach einer Rücknahme. Das ist genau, was ein Nachweis leisten soll. Die oberste Quelle bleibt unverändert, und der bestandene Prüffall aus M3 bliebe grün. **K04-G12 zeichnet diesen Weg für die Kenntnisnahme bereits vor** |
| **Dagegen** | Der aktuelle Stand muss aus den Vorgängen errechnet werden, bei jedem Aufruf. Etwas mehr Arbeit im Bau, etwas langsamer im Betrieb |

### Weg C · Beides — Zustand für die Anzeige, Ereignis für den Nachweis

Der aktuelle Stand steht am Datensatz, die Geschichte in den Ereignissen.

| | |
|---|---|
| **Dafür** | Schnell zu lesen **und** vollständig nachweisbar. Der Bau hat es für die Kenntnisnahme bereits so gemacht: Spalte **und** Ereigniszeile, in einem Zug |
| **Dagegen** | Zwei Orte für dieselbe Sache. Wenn sie auseinanderlaufen, gilt keiner mehr — und dass sie es nicht tun, muss dauerhaft gemessen werden |

---

## Empfehlung des Orchestrators: **Weg C**, mit einer Auflage

**Warum nicht A:** Ein Nachweis, den man überschreiben kann, ist keiner. Bei der Kenntnisnahme
ist genau das der Zweck — sie soll belegen, was der Kunde **damals** wusste.

**Warum nicht B allein:** Der Bildschirm muss bei jedem Aufruf wissen, ob beide Fragen schon
beantwortet sind. Das aus Vorgängen zu errechnen ist möglich, aber es macht die einfachste
Abfrage des Bildschirms zur kompliziertesten.

**Warum C:** Es ist der Weg, den K04-G12 für die Kenntnisnahme ohnehin vorzeichnet — *und*
der, den der Bau für sie bereits gegangen ist. Ihn auch für die zwei Antworten zu gehen, hält
beides gleich, statt zwei Sachen verschieden zu behandeln.

**Die Auflage:** Zwei Orte für dieselbe Sache halten nur, wenn jemand misst, dass sie
übereinstimmen. **Ein dauerhafter Prüffall** vergleicht den Stand am Datensatz mit dem, was
die Vorgänge sagen. Ohne diese Auflage wird aus C das Schlechteste beider Wege.

*Das ist dieselbe Auflage, die am 15.08. für den Kunden-Code beschlossen wurde — zwei
Dauermessungen am Bestand, die auch finden, was auf unbekanntem Weg entstanden ist.*

---

## Was von dieser Entscheidung abhängt

| | |
|---|---|
| **VP-24** | Der gekippte Prüffall aus M3. Bei **Weg B** wird er von selbst wieder grün. Bei **A** und **C** ist er nachzuziehen — dann aber **nach** Ihrer Zeichnung, nicht davor |
| **Die Nachrechnung von M4** | Sie verlangt: *„bei Treffer in Frage 1 liegt die Kenntnisnahme vor."* Ohne entschiedenen Träger ist nicht bestimmbar, wo man nachsieht |
| **Das Übergabe-Paket** | K10-M34 verlangt die Kenntnisnahme darin. Rechtsgrund ist Artikel 25 Absatz 4 |
| **Die Rücknahme einer Antwort** | Bleibt die Kenntnisnahme stehen, wenn der Kunde seine Antwort ändert? Bei **B** und **C** ist die Frage nebensächlich — die Geschichte bleibt ohnehin. Bei **A** muss sie eigens entschieden werden |

---

## Zeichnung

*Eingetragen auf Weisung; der Harness trägt nur ein, was angewiesen wurde.*

**Bis zur Zeichnung bleibt der Prüffall VP-24 rot.** Er wird als Befund geführt, nicht
nachgezogen.

- [ ] **Weg A** — zwei Felder an der Prüftabelle
- [ ] **Weg B** — Ereignisse, wie der Behelf es vorsieht
- [x] **Weg C** — beides, mit der Auflage einer dauerhaften Messung · **gez. M. Veil, 16.08.2026**
- [ ] **anders:** ⟨…⟩

**Gilt die Entscheidung für beides — die zwei Antworten und die Kenntnisnahme?**

- [x] ja, für beides · **gez. M. Veil, 16.08.2026**
- [ ] nein, getrennt: Antworten ⟨…⟩ · Kenntnisnahme ⟨…⟩

**Damit ist zugleich zu entscheiden:**

- [x] **O-K04-8 gilt als geschlossen.** Der Behelf K04-G12 wird abgelöst · **gez. M. Veil, 16.08.2026**
- [x] **Die Schwesterfrage (Träger der Antworten) bekommt eine eigene Kennung** · **gez. M. Veil, 16.08.2026**
      und wird in
      K04 nachgezogen — sie ist bis heute in keinem Konzept als offener Punkt geführt

| Name | Rolle | Datum | Anmerkung |
|---|---|---|---|
| **M. Veil** | Auftraggeber | **16.08.2026** | Weg C, für beides |
| **A. Han** | für den Auftragnehmer (Nr. 158) | **16.08.2026** | mitgezeichnet — schließt O-K04-8 |

---

*Erstellt am 16.08.2026 vom Orchestrator des Coding-Harness. Der Bau hat diese Frage still
entschieden; diese Vorlage legt die Entscheidung dorthin zurück, wo sie hingehört.
**Sie entscheidet nichts.***
