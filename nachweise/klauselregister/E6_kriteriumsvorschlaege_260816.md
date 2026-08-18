# E-6 · Die Abnahmekriterien des Teilschnitts — **Vorschläge, keine Festlegungen**

| | |
|---|---|
| **Grundlage** | `K23-M02` · Zeichnung **B-4/B-5** vom 16.08.2026 · Freigabe **E-6**, gez. M. Veil und A. Han, 16.08.2026 |
| **Erzeugt** | 16.08.2026, in zwei Stufen: **Vorschlag** und **Gegenprobe** |
| **Umfang** | **142** Klauseln ohne Kriterium (von 157 des Teilschnitts; 15 trugen bereits eines) |
| **Zu zeichnen von** | **A. Han** (139) · **M. Veil** (3 — K15, K17) |

> **Diese Datei enthält keine Entscheidung.** Jeder Eintrag im Register trägt sichtbar
> `⟨VORSCHLAG · NICHT GEZEICHNET⟩` und zwei leere Felder `⟨zeichnet: ⟩ ⟨am: ⟩`. Ein
> Vorschlag ist keine Festlegung — er nimmt dem Eigentümer die Schreibarbeit ab, nicht die
> Entscheidung.

---

## 1 · Das Ergebnis

```
Klauselregister, Feld "akzeptanzkriterium", Ausschnitt Teilschnitt (157 Klauseln)

  vorher     15 von 157
  jetzt     157 von 157
              140  Kriteriumsvorschlag liegt vor
               17  ausdruecklich NICHT ABLEITBAR -- der Eigentuemer liefert nach
```

**Bedingung 4 des Liefertors hat damit zum ersten Mal je Zeile einen Eintrag.** Erfüllt ist
sie nicht: Ein Vorschlag ist kein gezeichnetes Kriterium, und 17 Zeilen sagen ausdrücklich,
dass eine Angabe fehlt.

---

## 2 · Die Gegenprobe — sie hat **62 von 142** beanstandet

**Der Vorschlag allein wäre gefährlich gewesen.** Neun Agenten haben Vorschläge erzeugt,
neun weitere haben sie gegen den Klauselwortlaut geprüft — mit dem ausdrücklichen Auftrag,
zu **beanstanden**, nicht zu bestätigen.

| Mangel | Zahl | Was er heißt |
|---|---:|---|
| **erfunden** | **26** | Der Vorschlag nennt eine Zahl, Frist, Schwelle oder Liste, **die im Klauselwortlaut nicht steht** |
| **zu Unrecht als unableitbar** | **25** | Der Agent hat aufgegeben, obwohl die Klausel einen messbaren Maßstab trägt |
| nicht messbar | 6 | *„angemessen"*, *„zeitnah"* — Wörter, die zwei Menschen verschieden auswerten |
| Negativfall fehlt oder ist fremd | 4 | Kein Negativfall, oder einer, der an einer anderen Bedingung scheitert |
| wiederholt nur die Klausel | 1 | Umgestellt statt gemessen |
| | **62** | **44 % der Vorschläge** |

**59 Einträge sind daraufhin ersetzt worden** — die Gegenprobe hat in diesen Fällen das
letzte Wort, nicht der erste Vorschlag.

### Die 26 erfundenen — sie sind der Grund, warum es die Gegenprobe gab

**Drei Beispiele im Wortlaut der Gegenprobe:**

> **K02-G15:** *„‚Dreistellig' und ‚Buchstabencode' stehen nicht in der Klausel — sie nennt
> nur Anzahlen (17 576 / 676 / 16 900)."*

> **K02-M23:** *„Die Zeichenliste ‚=, +, - oder @' steht nicht in der Klausel; **sie sieht
> aus wie eine Festlegung des Eigentümers und ist eine des Agenten.**"*

> **K02-D03:** Der Vorschlag hatte einen Entfernungs-Zeitstempel als Merkmal gesetzt, den
> die Klausel nicht nennt.

**K02-M23 sagt den Kern in einem Satz.** Genau das ist der Schaden, den ein geratenes
Kriterium anrichtet: Es sieht aus wie eine Zeichnung und ist keine. Ohne die Gegenprobe
wären **26 solcher Sätze** in das Register gegangen, unter dem Namen des Eigentümers.

### Die 25 in die andere Richtung

**Bequemlichkeit gibt es in beide Richtungen.** 25-mal hat ein Agent `ableitbar=false`
gemeldet, obwohl die Klausel sehr wohl einen Maßstab trägt. Das war im Auftrag ausdrücklich
als Mangel geführt — sonst hätte der bequemste Weg gewonnen: alles dem Menschen zurückgeben.

**Verteilung der Beanstandungen je Konzept** — die drei größten Konzepte tragen die meisten,
was der Zahl ihrer Klauseln entspricht:

| K02 | K03 | K11 | K20 | K14 | K01 · K07 | übrige 12 |
|---:|---:|---:|---:|---:|---:|---:|
| 8 | 8 | 8 | 8 | 7 | je 4 | 15 |

---

## 3 · Die Form jedes Vorschlags

**Drei Teile, immer:**

| | |
|---|---|
| **ERFÜLLT WENN** | die messbare Bedingung, positiv formuliert |
| **GEMESSEN DURCH** | woran man es sieht — Prüffall gegen Datenbank, gegen Bildschirm, Rechteprüfung, Sichtprüfung |
| **NICHT ERFÜLLT** | der Negativfall, **und an welcher Bedingung er scheitern muss** |

**Der dritte Teil ist der, an dem dieses Projekt schon einmal gescheitert ist.** Am
02.08.2026 scheiterten drei von vier Negativfällen an einer **fremden** Bedingung — an einer
Formatprüfung statt an der Zielbedingung. Das Ergebnis war ein bestandener Test, der nichts
misst. Jeder Vorschlag nennt deshalb die Bedingung ausdrücklich.

**Beispiel — K02-D05, Mandantentrennung:**

> **NICHT ERFÜLLT:** … *„Der Versuch muss mit gültiger Anmeldung, gültigem Format und
> **existierendem** Schlüssel gefahren werden, damit er allein an der Mandantengrenze
> scheitert."*

---

## 4 · Die 17, bei denen der Eigentümer nachliefern muss

**Sie sind das ehrlichste Ergebnis dieses Laufs.** Ein Werkzeug, das für jede Klausel etwas
produziert, produziert für manche Klauseln Unsinn.

```
K02-D11  K02-D12  K02-G17  K02-M23  K02-M29  K02-M30  K02-M31
K03-G03  K03-M21  K05-M24  K05-M27  K10-M22  K12-M02  K13-M16
K14-D10  K23-M06  K23-M10
```

**Jede dieser 17 Zeilen sagt, welche Angabe fehlt** — nicht bloß *„nicht ableitbar"*. Zwei
Beispiele:

> **K02-D11:** *„Eine prüfbare Festlegung, woran erkannt wird, dass ein Mandant ‚echte
> Kundendaten führt' — ein Merkmal am Mandanten, eine Regel oder eine benannte Feststellung
> samt Zuständigkeit. Ohne sie lässt sich der Negativfall nicht herstellen."*

> **K02-D12:** *„Der Träger des Partner-Kennzeichens aus K02-M31 (Auftrag O-K02-12) samt
> Feldname und Wertebereich. Solange ‚ein solches Kennzeichen' kein Feld hat, ist weder
> herstellbar noch prüfbar, ob ein Betreiber- oder Kundenmandant es trägt."*

**Sieben der siebzehn liegen in K02.** Das ist kein Zufall: K02 ist das Fundament, und dort
stehen die Klauseln, die auf Träger verweisen, die es noch nicht gibt.

---

## 5 · Was der Harness dabei ausdrücklich **nicht** getan hat

| | |
|---|---|
| **Keine Kritikalität gesetzt oder geändert** | `K23-G08`: die begründet der fachliche Eigentümer. Die Triage-Vorschläge stehen unverändert daneben |
| **Kein Kriterium als entschieden eingetragen** | Jeder Eintrag trägt `⟨VORSCHLAG · NICHT GEZEICHNET⟩` und zwei leere Zeichnungsfelder |
| **Nicht in `app/` oder `migrations/` geschaut** | Das Kriterium kommt aus der **Klausel**. Ein aus dem Code abgeleitetes Kriterium misst den Code gegen sich selbst — dasselbe, wovor `K23-D05` steht |
| **Keinen Umfang erfunden** | Und wo es doch geschah, hat die Gegenprobe es 26-mal gefunden und ersetzt |

---

## 6 · Was jetzt bei den Eigentümern liegt

| Wer | Was | Umfang |
|---|---|---|
| **A. Han** | 18 Konzepte durchsehen und zeichnen — oder abweichend fassen | **139** Klauseln |
| **M. Veil** | K15 (1) und K17 (2) | **3** Klauseln |
| **beide** | die **17** fehlenden Angaben nachliefern | 17 Zeilen |

**Der kürzeste Weg bleibt derselbe:** **K02** (33), **K03** (31), **K20** (21) — drei
Konzepte, **85 der 157** Klauseln.

> **Wie die Zeichnung ins Register kommt:** Die beiden Felder `⟨zeichnet: ⟩ ⟨am: ⟩` in
> `pflege.json` füllen, dann `python3 werkzeuge/klauselregister.py` laufen lassen. **Erst
> dann** trägt Bedingung 4 — die Zeichnung auf Papier reicht dafür nicht.

---

*Erzeugt am 16.08.2026 vom Coding-Harness auf Weisung E-6, in achtzehn getrennten
Durchgängen: neun erzeugende, neun beanstandende. **Die Gegenprobe hat 44 % der Vorschläge
beanstandet und in 59 Fällen ersetzt.** Kein Vorschlag ist eine Festlegung; keiner ist
gezeichnet.*
