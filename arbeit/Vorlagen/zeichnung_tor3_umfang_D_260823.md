# Zur Zeichnung · Umfang von `D_Nachweise` im Tor-3-Belegpaket — A. Han

**23.08.2026 · Entscheidung des Anfordernden nach C-4**

---

## Warum das entschieden werden muss

Am 20.08.2026 wurde die Gruppe `D_Nachweise` **weggelassen**. Das Fremdmodell hat es im Kopf
seines Blattes vermerken müssen:

> *„D_Nachweise.txt (Klauselregister, Herkunftsgraph) wurde nicht vorgelegt."*

Das war keine Nachlässigkeit, sondern eine Größenfrage — die jetzt gemessen ist:

| Datei | Größe |
|---|---|
| `nachweise/klauselregister/register.json` | **1319 KiB** |
| `nachweise/klauselregister/register.md` | 828 KiB |
| `nachweise/klauselregister/pflege.json` | 645 KiB |
| `nachweise/klauselregister/triage.json` | 413 KiB |
| `nachweise/herkunft/herkunft.json` | 520 KiB |
| `nachweise/herkunft/herkunft.md` | **4 KiB** |
| `nachweise/befunde/*.md` | zusammen ~120 KiB |
| **Gruppe D insgesamt** | **4254 KiB** |

Zum Vergleich: Umsetzungscode, Prüffälle und Vertrag zusammen sind **2234 KiB**. **Die
Nachweise wären fast doppelt so groß wie alles, worüber geurteilt werden soll.**

> **Warum das nicht bloß unbequem ist.** Ein Fremdmodell, das 4 MB Register liest, urteilt
> danach über das Register — nicht über den Bau. Der Auftrag lautet aber, den **Stand** gegen
> den **Maßstab** zu halten. Ein Beleg, der den Blick füllt, ist kein besserer Beleg.

## Die drei Wege

`☐` **A · Nur was der Auftrag braucht** — `herkunft.md` (4 KiB) und die Befunde (~120 KiB).
Das Register bleibt draußen; im `STAND.txt` steht ausdrücklich, dass es besteht und auf
Nachfrage nachgereicht wird. **Gruppe D: ~124 KiB.**

`x` **B · Ausschnitt der geprüften Klauseln** — nur die Klauseln der Abnahmeeinheit, mit
Wortlaut und Akzeptanzkriterium, als eigene Datei erzeugt. Wie beim Blindauftrag M5, der
101 Klauseln als `klauseln.md` mitgab. **Gruppe D: geschätzt 150–400 KiB, je nach Schnitt.**
⟨Schnitt: …………………………⟩

`☐` **C · Alles** — das vollständige Register. **Gruppe D: 4254 KiB.**
*Der Harness rät ab; die Begründung steht im Kasten oben.*

> **Empfehlung des Harness: B, ersatzweise A.** Weg B legt genau das vor, woran gemessen
> werden soll, und nichts darüber hinaus — es ist derselbe Zuschnitt, mit dem der Blindauftrag
> M5 am 20.08. gefahren wurde. Weg A ist der kleinere Schnitt und immer noch besser als der
> Zustand vom 20.08., wo die Gruppe ganz fehlte.
>
> **Bei B ist der Schnitt zu benennen:** welche Klauseln gehören zur Abnahmeeinheit? Ohne
> diese Angabe entscheidet sonst der Harness, worüber geurteilt wird — und das ist nach
> K23-M02 nicht seine Sache.

---

⟨zeichnet: …M. Veil, A.Han………………⟩ ⟨am: ……23.8.26……………⟩

*Danach trage ich den gewählten Schnitt in `werkzeuge/tor3_belege.py` ein und schnüre das
Paket gegen den dann sauberen Arbeitsbaum neu.*
