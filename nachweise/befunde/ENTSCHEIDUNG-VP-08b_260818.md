# Entscheidung · VP-08b — die Rang-1-Quelle gewinnt

**18. August 2026 · gezeichnet von M. Veil und A. Han · Vermerk des Orchestrators**

*VP-08b war seit dem 14.08.2026 GESPERRT und wartete auf einen Menschen. Die Entscheidung ist
gefallen; dieser Vermerk hält sie fest, damit der blinde Prüf-Agent sie hat.*

---

## 1 · Der Widerspruch

**K04-M07** nennt drei Ausschlussantworten im Wortlaut:

```
"reine Netzseite"
"etwas zum Installieren auf Rechner oder Geraet"
"Wegwerf-Versuch ohne Produktivbetrieb"
```

**Das Zielschema** führt dieselben drei Sachverhalte — in anderen Worten
(`schema/freiraum_datamodel.sql:737-756`, „SEED: Eignungs-Check"):

```
"Eine Website, die unser Unternehmen oder Produkt darstellt"
"Etwas, das lokal auf dem Rechner oder Geraet installiert wird"
"Nur zum Ausprobieren einer Idee - danach vermutlich nicht weiter"
```

**Es geht nicht um die Sache, sondern um den Wortlaut.** Die Sachverhalte sind deckungsgleich.

## 2 · Die Entscheidung

> **Die Rang-1-Quelle gewinnt. Der Wortlaut aus K04-M07 wird nicht erzwungen.**

`CLAUDE.md` Abschn. 1 führt die Rangfolge, und sie ist gezeichnet: `freiraum_datamodel.sql`
plus M30 ist **Rang 1**, die Konzepte sind **Rang 2**. Der Widerspruch war damit nie ein Patt —
es fehlte allein die Feststellung.

**Der Bau bleibt unverändert.** Er hätte den Wortlaut ohnehin nicht herstellen können, ohne das
Zielschema zu ändern, und das darf er nicht.

## 3 · Was daraus für VP-08b folgt

**VP-08b darf nicht mehr GESPERRT melden.** Ein Fall, dessen Frage entschieden ist, ist
messbar geworden.

**Was er stattdessen messen soll — die Anforderung, nicht die Lösung:**

> Der Startbestand führt für jeden der **drei Sachverhalte** genau eine nicht-geeignete
> Antwort. Gemessen wird der **Sachverhalt**, nicht die Buchstabenfolge aus K04-M07.
> Fehlt einer der drei, fällt der Fall durch — **nicht** gesperrt, sondern durch.

**Wie das gebaut wird, entscheidet der blinde Prüf-Agent.** Er allein fasst
`pruefungen/klauseln/vorpruefung_lauf.sh` an (`CLAUDE.md` Abschn. 3).

**Der schwierige Teil ist die Gegenprobe:** Ein Fall, der nur nachsieht, ob drei Zeilen
existieren, besteht auch dann, wenn eine davon den falschen Sachverhalt trägt. Nach F07 muss
er an seiner **eigenen** Bedingung scheitern können.

## 4 · Was diese Entscheidung nicht sagt

**K04-M07 ist nicht falsch und wird nicht gestrichen.** Ob der Klauselwortlaut an das
Zielschema angeglichen wird, ist Konzeptarbeit und gehört in die Konzept-Fabrik — nicht in den
Bau. Dieser Vermerk stellt nur fest, welche Quelle im Bau gewinnt.

**Kein anderer Prüffall ist berührt.** VP-08 (die Datenfrage) steht ohnehin im Wortlaut in
beiden Quellen und bestand schon vorher.

---

*Erstellt am 18.08.2026. Die zitierten Wortlaute stammen aus
`pruefungen/klauseln/vorpruefung_lauf.sh` (Kommentarblock zu VP-08b, Z. 909-931) und aus
`schema/freiraum_datamodel.sql:737-756`, beide am selben Tag gelesen. Die Rangfolge steht in
`CLAUDE.md` Abschn. 1, wortgleich aus Bauauftrag :80-86.*
