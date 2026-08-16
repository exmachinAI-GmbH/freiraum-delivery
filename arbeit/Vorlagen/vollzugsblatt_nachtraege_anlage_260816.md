# Vollzugsblatt B-9 · Die zwei Nachträge kommen in die Anlage

**Was genau wo einzutragen ist, in welcher Reihenfolge, und was danach folgt.**

| | |
|---|---|
| **Punkt** | **B-9** der Schlussrunde vom 16.08.2026 (`entscheidungen_schlussrunde_260816.md`, Zeile 178) |
| **Datum** | 16.08.2026 |
| **Art** | **Vollzugsblatt. Es entscheidet nichts.** Es sagt, welche Handgriffe eine gezeichnete Entscheidung ausführen — und benennt drei Stellen, an denen zuvor ein Mensch entscheiden muss |
| **Angelegt von** | Orchestrator des Coding-Harness |
| **Kästchen** | **alle leer.** Seit dem 16.08.2026 setzt der Harness kein Kreuz mehr, auch kein abgeschriebenes (`nachweise/vorbedingungen/formvermerk_uebertragene_kreuze_260816.md`) |

---

## 1 · Die Ausgangslage — gemessen, nicht angenommen

Drei Dateien gehören zusammen. **Gezeichnet wird die Anlage, ausgeführt wird die `CLAUDE.md`,
und die Prüfsumme verbindet beide.** Eine Prüfsumme ist eine 64-stellige Kennzahl, die sich
aus dem Dateiinhalt errechnet: ändert sich ein Zeichen, ändert sich die Kennzahl.

| Datei | Wo | Was sie ist |
|---|---|---|
| `Anlage_Bauverfahren.md` | Dropbox, `03_AGENT_HARNESS_CODING/30_DELIVERY_HARNESS/` | **der unterschriebene Text** |
| `Anlage_Bauverfahren_zeichnung.md` | daneben, dieselbe Ablage | **der Zeichnungsblock** — getrennt, damit ein Kreuz die Prüfsumme der Anlage nicht ändert (F40) |
| `CLAUDE.md` | dieses Repo | die **ausführbare** Fassung; trägt die Prüfsumme der Anlage im Kopf |

### Was heute gilt

```
$ shasum -a 256 ".../30_DELIVERY_HARNESS/Anlage_Bauverfahren.md"
ded747a7a98bcc7fa11442b92e0d09a244c0b4ee2051f10fb251bdb68300274d

$ cd ~/freiraum-delivery && ./install.sh --pruefsumme
OK Pruefsumme der Anlage stimmt mit dem Kopf der CLAUDE.md ueberein.
```

**Beide Nachträge stehen noch nicht in der Anlage.** Gemessen:

```
$ grep -c "Verständlichkeit als Lieferbedingung\|Fortschritt wird gemessen" \
       ".../Anlage_Bauverfahren.md"
0
```

Die Anlage hat heute **elf Abschnitte** und trägt die Kennungen `HV-M01` bis `HV-M20`,
`HV-D01` bis `HV-D19`, `HV-G01` bis `HV-G11`. Gemessen mit
`grep -oE 'HV-[MDG][0-9]+' ".../Anlage_Bauverfahren.md" | sort -u`.
**Frei und für die zwei Nachträge vorgesehen: `HV-M21` und `HV-M22`.**

---

## 2 · Warum beide in **einem** Durchgang

Der Zeichnungsweg (`nachtraege_anlage_260814_zeichnungsweg.md`, Zeilen 14–25) sagt es und
begründet es: Jede Aufnahme in die Anlage ändert deren Prüfsumme. Zwischen der Änderung und
dem Nachziehen der Kennzahl in der `CLAUDE.md` liegt ein Zustand, in dem der Harness meldet,
er arbeite gegen eine unbelegte Verfassung.

**Zwei getrennte Durchgänge bedeuten diesen Zustand zweimal. Ein Durchgang bedeutet ihn
einmal.** Deshalb: beide zusammen, an einem Tag.

---

## 3 · Der Fallstrick — **das ist kein Defekt**

> **Zwischen der Zeichnung und der neuen Prüfsumme melden `/scheibe` und `/pruefe`
> „Verfassung nicht belegt". Das ist die eingebaute Sperre und funktioniert wie vorgesehen.**

`/scheibe` baut eine Scheibe, `/pruefe` misst, ohne zu bauen — beide werden im Programm
`claude` im Verzeichnis `~/freiraum-delivery` eingegeben.

**Was in diesem Zustand passiert:** Beide Kommandos laufen weiter. Sie hören nicht auf. Aber
jeder Bericht trägt im Kopf den Vermerk *„Verfassung nicht belegt"*, und **jedes Ergebnis
gilt als gesperrt, nicht als bestanden** (`.claude/commands/pruefe.md`, Zeile 15).

**Warum das richtig ist:** Der ausgeführte Text redet in diesem Augenblick über eine andere
Fassung als der unterschriebene. Ein Lauf, der das nicht sagt, behauptet eine Deckung, die
es gerade nicht gibt.

**Die Meldung steht an drei Stellen im Bestand** — sie ist gewollt und dokumentiert:

| Stelle | Zeile |
|---|---|
| `install.sh` | 99 — `-> /scheibe und /pruefe laufen, melden aber 'Verfassung nicht belegt'.` |
| `README.md` | 220 — führt sie in der Tabelle *„Wenn etwas nicht geht"* ausdrücklich als **kein Fehler** |
| `.claude/commands/pruefe.md` | 15 — jedes Ergebnis gilt dann als gesperrt |

> **Wer diese Meldung sieht, hat nichts kaputt gemacht.** Er steht mitten in Schritt 4 bis 6
> der Liste unten. Die Meldung verschwindet, sobald die neue Prüfsumme im Kopf der
> `CLAUDE.md` steht und `./install.sh --pruefsumme` wieder **OK** meldet.
>
> **Was man nie tut:** die Prüfung überspringen, damit die Meldung weggeht. Das ist genau
> die Umgehung, die die Sperre verhindern soll.

---

## 4 · Drei Punkte, die **vor** dem ersten Handgriff entschieden werden

Der Harness legt sie vor. Er entscheidet keinen davon.

### 4.1 · An welche Stelle der Anlage die zwei Absätze kommen

Der Zeichnungsweg sagt *„in die Anlage aufnehmen"*, nennt aber **keinen Abschnitt**. Für die
`CLAUDE.md` nennt er Abschnitt 5 („Betriebsregeln"). Die Anlage ist anders gegliedert — sie
hat keinen Abschnitt dieses Namens.

**Vorschlag des Orchestrators, sichtbar als Vorschlag:**

| Nachtrag | Vorgeschlagene Stelle | Warum dort |
|---|---|---|
| **Verständlichkeit als Lieferbedingung** | Abschnitt **3 · Bauregeln**, als neue Zeile **`HV-M21`**, direkt nach `HV-M11` | `HV-M11` regelt bereits die Sprache (*„Nachweise Deutsch"*). Die Verständlichkeit ist dieselbe Art Regel, eine Stufe weiter |
| **Fortschritt wird gemessen, nicht behauptet** | Abschnitt **8 · Die Betriebseinheit**, als neue Zeile **`HV-M22`** am Ende | Dort steht heute schon, was eine Arbeitseinheit ist und was `/clear` trägt. Die Tagesübergabe gehört in dieselbe Ordnung |

**Was gegen den Vorschlag spricht und mit zu bedenken ist:** Beide Absätze sind lang. Als
Tabellenzeile in einer Regeltabelle wären sie die mit Abstand längsten Zellen der Anlage. Die
Gegenmöglichkeit ist ein **eigener Abschnitt 3a und 8a** je Nachtrag. Das ist Geschmack, nicht
Sache — aber es ist eine Entscheidung, und sie gehört dem Menschen.

- [ ] **Vorschlag** — `HV-M21` in Abschnitt 3, `HV-M22` in Abschnitt 8
- [ ] **Eigene Abschnitte** — je Nachtrag ein eigener Abschnitt
- [ ] **Anders:** ⟨Stelle⟩

### 4.2 · Ob die **zehnte** Sprachregel mitgeht — und wie ihr Wortlaut heißt

Der Auftrag an dieses Blatt lautete zu prüfen, ob `SPR-10` — die Beiwortpflicht für das Wort
*„Tor"* — in den Sprach-Nachtrag aufzunehmen ist.

**Sachlich gehört sie dazu.** Der Sprach-Nachtrag nimmt die Kurzfassung der Sprachregeln in
die Anlage auf; eine zehnte Regel, die nicht mitgeht, stünde ab dem Zeichnungstag außerhalb
der Anlage, während neun Schwestern darin stehen.

**Aber der Wortlaut ist im Bestand nicht auffindbar.** Gemessen:

```
$ grep -rn "SPR-10" --include="*.md" ~/freiraum-delivery
arbeit/Vorlagen/entscheidungen_schlussrunde_260816.md:178
arbeit/Vorlagen/entscheidungen_schlussrunde_260816.md:181
arbeit/Vorlagen/entscheidungen_schlussrunde_260816.md:310
```

**Drei Treffer, alle drei in der Schlussrunde selbst.** Kein vierter. `CONTRIBUTING.md` führt
`SPR-1` bis `SPR-9` und schließt mit dem Satz: *„Kennung der Regeln: `SPR-1` bis `SPR-9`."*

Auch die genannte Quelle fehlt in diesem Arbeitsstand:

```
$ ls arbeit/Vorlagen/entscheidungsvorlage_MVeil_260815.md
ls: ... No such file or directory
```

Ebenso fehlen hier `BA-1_zeichnung_260815.md`, `zeichnung_M1-M10_260815.md` und
`zeichnung_M7-M10_260815.md`. **Das ist kein Beweis, dass es sie nicht gibt** — dieser
Arbeitsstand ist nicht der Gesamtbestand, und der Orchestrator führt zusammen, nicht dieses
Blatt. Es heißt nur: **von hier aus ist der Wortlaut nicht lesbar.**

> **Der Harness schreibt ihn deshalb nicht auf.** Einen Wortlaut zu formulieren, den er nicht
> gelesen hat, wäre erfundener Umfang — und die Regel käme in eine unterschriebene Anlage.

**Was der Sache nach klar ist, auch ohne den Wortlaut:** Die Verwechslungsgefahr ist real und
belegt. `CLAUDE.md` Abschnitt 0 trennt sie in zwei Zeilen ausdrücklich:

> *„Tor I · II · III (römisch) — die drei Abnahmetore des Bauauftrags … Tor 1 · 2 · 3 · 4
> (arabisch) — die vier Messstufen dieses Harness je Scheibe."*
>
> *„Tor 4 dieses Harness ist **nicht** Tor II des Auftrags."*

Eine Regel, die bei jeder Nennung ein Beiwort verlangt, schützt genau diese Trennung.

- [ ] **`SPR-10` geht mit** — Wortlaut wird beim Zeichnen beigelegt und in
      `CONTRIBUTING.md` sowie in die Kurzfassung des Nachtrags übernommen
- [ ] **`SPR-10` geht nicht mit** — sie bleibt Arbeitsregel und kommt mit dem nächsten
      Nachtrag; der Sprach-Nachtrag geht unverändert in die Anlage
- [ ] **Anders:** ⟨Entscheidung⟩

**Wenn das erste Kästchen gesetzt wird, ändert sich an Schritt 1 der Liste unten genau
eines:** Im Absatz *„Die neun Regeln sind unten in Kurzfassung aufgenommen"* wird **neun** zu
**zehn**, und die Kurzfassungszeile bekommt ein zehntes Glied. Sonst nichts.

### 4.3 · Der Widerspruch im Zeichnungsnachweis

Der Zeichnungsweg nennt ihn schon (Zeilen 65–84), und er ist heute noch da. Gemessen in
`Anlage_Bauverfahren_zeichnung.md`:

| Zeile | Text |
|---|---|
| 28 | *„A. Han (für den Auftragnehmer) · 08.08.2026 … Offen ist damit nicht mehr **wer**, sondern nur noch seine Unterschrift"* |
| 37 | *„solange A. Han für den Auftragnehmer nicht gezeichnet hat, bindet diese Anlage den Auftraggeber allein"* |

**Die Sache selbst ist seit dem 16.08.2026 entschieden.** Die Weisung liegt im Wortlaut vor
(`nachweise/vorbedingungen/anlage_bauverfahren_gegenzeichnung_260816.md`, Zeile 17):

> *„Die Anlage „Bauverfahren" gegenzeichnen - ist hiermit freigegeben und gezeichnet.
> Gez. A. Han, 16.8.26"*

**Offen ist nur das Nachziehen des Blattes.** Der Harness hat es nicht angefasst: Nach F40
gehört das Blatt dem Menschen, sobald ein Kreuz darin steht. **Der Tag, an dem für die zwei
Nachträge ohnehin neu gezeichnet wird, ist der richtige Tag dafür** — dann wird das Blatt
einmal angefasst statt zweimal.

- [ ] **Beim Zeichnen mit nachziehen** — Zeile 37 auf den Stand vom 16.08.2026 berichtigen
- [ ] **Getrennt behandeln:** ⟨Begründung⟩

---

## 5 · Der Vollzug — neun Schritte in dieser Reihenfolge

**Die Reihenfolge ist nicht Geschmack.** Schritt 5 muss nach Schritt 4 kommen, sonst wird eine
Prüfsumme über einen Text gebildet, der sich danach noch ändert. Schritt 7 muss nach
Schritt 5 kommen, sonst steht in der `CLAUDE.md` eine Kennzahl, die zu nichts passt.

| # | Handgriff | Datei | Woran man sieht, dass es geklappt hat |
|---|---|---|---|
| **1** | **Die zwei Absätze in die Anlage aufnehmen** — an die in 4.1 entschiedene Stelle | `.../30_DELIVERY_HARNESS/Anlage_Bauverfahren.md` | `grep -c "Verständlichkeit als Lieferbedingung" <Anlage>` meldet **1** statt 0 |
| **2** | **Die Zitatzeichen weglassen.** In beiden Nachträgen steht der aufzunehmende Text als Zitatblock — jede Zeile beginnt mit `>`. **Diese Zeichen gehören nicht in die Anlage**; sie markieren im Vorschlag nur, was zu übernehmen ist | dieselbe Datei | keine Zeile des neuen Textes beginnt mit `>` |
| **3** | **Die alte Zeichnung heben, nicht überschreiben.** F40: *„Die alte Zeichnung wird archiviert, nie überschrieben."* Der Weg steht im Zeichnungsnachweis selbst, Zeile 53 | `Anlage_Bauverfahren_zeichnung.md` → `Anlage_Bauverfahren_zeichnung_v1.md` | beide Dateien liegen nebeneinander |
| **4** | **Neu zeichnen** — und dabei 4.3 miterledigen | neues `Anlage_Bauverfahren_zeichnung.md` | Kreuz und Datum stehen; **gesetzt vom Menschen** |
| **5** | **Die neue Prüfsumme rechnen** — `shasum -a 256 "<Pfad zur Anlage>"` | — | 64 Stellen kommen heraus; sie ist **nicht** mehr `ded747a7…` |
| **6** | **Die neue Prüfsumme in den Zeichnungsnachweis eintragen** — dort steht sie in der Kopftabelle, Zeile 14 | `Anlage_Bauverfahren_zeichnung.md` | die Kennzahl aus Schritt 5 steht dort |
| **7** | **Die neue Prüfsumme in den Kopf der `CLAUDE.md` eintragen** — sie ersetzt `ded747a7a98bcc7fa11442b92e0d09a244c0b4ee2051f10fb251bdb68300274d`. **Im selben Zug** die beiden Absätze in `CLAUDE.md` Abschnitt 5 („Betriebsregeln") übernehmen | `~/freiraum-delivery/CLAUDE.md` | beide Änderungen stehen in **einer** Änderung |
| **8** | **Nachrechnen** — `cd ~/freiraum-delivery && ./install.sh --pruefsumme` | — | **`OK Pruefsumme der Anlage stimmt mit dem Kopf der CLAUDE.md ueberein.`** Ab hier ist der Vermerk *„Verfassung nicht belegt"* weg |
| **9** | **Die Änderung an `CLAUDE.md` als Antrag einreichen** | dieses Repo | der Antrag ist offen und wartet auf **zwei** Zustimmungen |

### Wenn Schritt 8 **nicht** OK meldet

Der Befehl zeigt dann beide Werte nebeneinander. **Nicht weiterbauen — nachrechnen.** Es gibt
genau zwei Ursachen:

| Ursache | Woran man sie erkennt | Was hilft |
|---|---|---|
| Die Anlage wurde nach Schritt 5 noch einmal geändert | `shasum -a 256 <Anlage>` liefert heute etwas anderes als in Schritt 5 | Schritte 5 bis 8 wiederholen |
| Die Kennzahl wurde falsch abgetippt | die beiden Werte unterscheiden sich in wenigen Zeichen | Wert aus Schritt 5 erneut übernehmen |

---

## 6 · Was nach Schritt 9 noch zu tun ist

| | Was | Warum |
|---|---|---|
| **a** | **`CONTRIBUTING.md` nachziehen** — der Schlussabsatz sagt heute: *„Sie ist noch nicht Teil der gezeichneten Verfassung … Ein zeichnungsfertiger Absatz dafür liegt bei."* Das stimmt ab Schritt 8 nicht mehr | Ein Text, der über sich selbst etwas Falsches sagt, ist die Sorte Fehler, die beim nächsten Nachrechnen als Lücke auftaucht. Auch `CONTRIBUTING.md` braucht **zwei** Zustimmungen (`.github/CODEOWNERS`) |
| **b** | **Wenn 4.2 mit „geht mit" entschieden wurde:** `SPR-10` in `CONTRIBUTING.md` aufnehmen — im selben Antrag wie **a** | Sonst führt die Anlage zehn Regeln und die Arbeitsfassung neun |
| **c** | Prüfen, ob ein Testmanifest die alte Prüfsumme führt | Die Nachweiskette führt als Glied 3 die *Prüfsumme der Anlage* (`CLAUDE.md` Abschnitt 4). Ältere Manifeste bleiben, wie sie sind — sie belegen einen Stand von damals. **Umgeschrieben wird nichts** |

**Was sich durch den ganzen Vorgang nicht ändert** — beide Nachträge sagen es in ihrem
Abschnitt *Rang* ausdrücklich: kein Meilenstein, keine Bauaufgabe, kein Tor, kein Termin,
kein Umfang. **Kein zusätzliches Abnahmetor entsteht.**

---

## 7 · Was dieses Blatt nicht tut

- **Es zeichnet nicht.** Alle Kästchen sind leer.
- **Es formuliert `SPR-10` nicht.** Der Wortlaut ist von hier aus nicht lesbar; ihn zu
  erfinden wäre erfundener Umfang.
- **Es fasst die Anlage nicht an.** Die Anlage liegt außerhalb dieses Repos, und das mit
  Grund: `--pruefsumme` misst die `CLAUDE.md` **gegen** sie. Lägen beide hier, änderte eine
  Änderung beide Seiten zugleich, und die Messung wäre wertlos.
- **Es entscheidet die drei Punkte aus Abschnitt 4 nicht.** Es legt sie vor.

---

## Zeichnung

*Dieser Block wird von Menschen ausgefüllt. Der Harness trägt hier nichts ein.*

- [ ] **Der Vollzug wird nach Abschnitt 5 ausgeführt**
- [ ] **Abweichend:** ⟨Schritt und Änderung⟩
- [ ] **Zurückgestellt** — mit Begründung: ⟨…⟩

Dazu die drei Entscheidungen aus Abschnitt 4 — ihre Kästchen stehen dort:
**4.1** Stelle in der Anlage · **4.2** `SPR-10` · **4.3** Widerspruch im Zeichnungsnachweis.

| Name | Rolle | Datum | Anmerkung |
|---|---|---|---|
| **M. Veil** | Auftraggeber | | |
| **A. Han** | für den Auftragnehmer (Nr. 158) | | |

---

*Angelegt am 16.08.2026 vom Orchestrator des Coding-Harness zu Punkt B-9 der Schlussrunde.
Alle Zahlen und Dateizustände in diesem Blatt sind ausgeführt und mit dem Befehl daneben
genannt. **Dieses Blatt entscheidet nichts.***
