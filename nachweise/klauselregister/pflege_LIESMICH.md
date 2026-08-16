# Die Pflegeliste `pflege.json` — was drinsteht und warum

**Angelegt am 16.08.2026 zu Punkt B-4 der Schlussrunde.** Die Übergabe vom 14.08.
nannte die fehlende Datei *„die eigentliche Sperre"*: `werkzeuge/klauselregister.py`
erwartet sie, findet sie nicht, und trägt dann in **jede** der 1231 Zeilen sieben
leere Felder ein.

---

## In einem Satz

Die Datei füllt **zwei** der sieben pflegbaren Felder, und beide Werte tragen im
Klartext, dass sie **Vorschläge und nicht gezeichnet** sind. Das dritte Feld — der
fachliche Eigentümer — **bleibt leer**, weil keine Quelle einen benennt.

---

## Welche Felder überhaupt pflegbar sind

`werkzeuge/klauselregister.py` führt zehn Felder je Zeile. Die ersten drei liest es
selbst aus den Konzepten. Die übrigen sieben stehen in `GEPFLEGT` und sind die
einzigen, die eine Pflegeliste setzen darf — jedes andere Feld weist das Werkzeug
mit einem Befund ab:

| | Feld | von wem | Stand nach dieser Liste |
|---|---|---|---|
| 1 | `wortlaut` | Werkzeug | gefüllt, 1231 |
| 2 | `herkunft` | Werkzeug | gefüllt, 1231 |
| 3 | `dokumentversion` | Werkzeug | gefüllt, 1231 |
| 4 | `eigentuemer` | Pflegeliste | **leer, 1231** — siehe unten |
| 5 | `kritikalitaet` | Pflegeliste | **405 gefüllt**, 826 leer |
| 6 | `akzeptanzkriterium` | Pflegeliste | **15 gefüllt**, 1216 leer |
| 7 | `test` | Pflegeliste | leer, 1231 — gehört zu B-5 |
| 8 | `teststand` | Pflegeliste | leer, 1231 — eine Aussage über einen Lauf |
| 9 | `ergebnis` | Pflegeliste | leer, 1231 — eine Aussage über einen Lauf |
| 10 | `evidenz` | Pflegeliste | leer, 1231 — eine Aussage über einen Lauf |

Die Felder 7 bis 10 beschreiben, **was gemessen wurde**. Der Harness hat dafür
nichts gemessen, also schreibt er dort nichts hin. Ein gefülltes Ergebnisfeld ohne
Lauf wäre ein grüner Lauf, der nichts gemessen hat.

---

## Woran Sie einen Vorschlag erkennen

**Jeder** eingetragene Wert beginnt mit derselben Zeichenfolge:

```
⟨VORSCHLAG · NICHT GEZEICHNET⟩
```

und **endet** mit einem leeren Unterschriftsfeld:

```
⟨zeichnet: ⟩ ⟨am: ⟩
```

**Warum diese Form gewählt wurde** — vier Gründe, jeder gegen eine andere Art des
Missverstehens:

| | Gefahr | Was die Form dagegen tut |
|---|---|---|
| **1** | Jemand liest nur den Anfang der Zelle | Die Marke steht **ganz vorn**. Auch eine abgeschnittene Tabellenzelle zeigt sie noch |
| **2** | Jemand hält das Feld für ausgefüllt | Die Zelle **endet mit einer leeren Unterschrift**. Die Zeile sagt selbst, dass noch jemand zeichnen muss |
| **3** | Ein Werkzeug zählt es als erledigt | Die Marke ist maschinell prüfbar: `wert.startswith("⟨VORSCHLAG")`. Vorschläge lassen sich getrennt zählen, ohne die Datei zu verstehen |
| **4** | Jemand kennt die Hausschreibweise nicht | Die spitzen Klammern `⟨…⟩` sind in diesem Projekt durchgehend die Schreibweise für *„hier fehlt noch etwas"* — `tor3_anforderung_scheibe1.md` schreibt so `⟨Name⟩` und `⟨Datum⟩`, die Schlussrunde so `⟨Kennungen⟩` |

Dazu kommt: **kein Vorschlag steht allein.** Jeder nennt seine Quelle im selben
Satz — die Kritikalität die Triage samt dem Wort, das sie ausgelöst hat; das
Kriterium den Wortlaut, aus dem es umgestellt wurde. Wer die Quelle nicht
mitträgt, streicht die Zeile.

---

## Feld 4 · `eigentuemer` — leer, und das ist die Antwort

**Gesucht wurde in vier Quellen. Keine benennt einen Menschen.** Der Nachweis Zeile
für Zeile steht in `eigentuemer_zuweisung_260816.md`, zusammen mit einem leeren
Formular über 24 Zeilen — eine je Konzept.

Die gezeichnete Weisung vom 16.08. hielt den Eintrag für mechanisch ableitbar:
*„jede Klausel gehört einem Konzept, jedes Konzept hat einen Eigentümer."* **Der
erste Halbsatz stimmt, der zweite nicht.** `config/kanon.yaml` ordnet jede Tabelle
genau einem Konzept zu — der Eigentümer ist dort ein **Dokument**, kein Mensch.
`K23-M02` verlangt aber einen, der das fehlende Kriterium *nachliefert*; das kann
ein Dokument nicht.

Und die Kennung trägt das Konzept ohnehin schon: `K03-M05` gehört zu K03. Wer „K03"
in das Eigentümerfeld schriebe, hätte nichts hinzugefügt — aber die Zählung
*„0 ohne Eigentümer"* wäre verschwunden. Ein Feld, das aussieht wie entschieden,
ist schlimmer als ein leeres.

---

## Feld 5 · `kritikalitaet` — 405 gefüllt, 826 bewusst leer

Übernommen aus `triage.json` vom 14.08.2026, **unverändert und als Vorschlag
gekennzeichnet**. Jeder Wert nennt die Gruppe, den Beleg im eigenen Wortlaut und
die Fundstelle — zum Beispiel:

> ⟨VORSCHLAG · NICHT GEZEICHNET⟩ kritisch: sicherheitskritisch · Quelle:
> triage.json vom 14.08.2026, Beleg im eigenen Wortlaut — sicherheitskritisch:
> „zweite Faktor" (Stelle 4) · K23-G08: die Kritikalität begründet der fachliche
> Eigentümer, nicht der Harness · ⟨zeichnet: ⟩ ⟨am: ⟩

Bei den **386**, bei denen zusätzlich kein Prüffall vorliegt, steht im selben Wert:
*fehlender Test SPERRT die Freigabe (K23-M04)*.

**Die 826 „unbestimmten" bleiben leer.** Die Triage sagt dazu wörtlich:
*„`unbestimmt` heißt nicht `nicht kritisch`"* — es heißt, dass kein Begriff der fünf
Gruppen im Wortlaut vorkommt und die Maschine hier nichts beiträgt. Das Wort
„unbestimmt" in das Feld zu schreiben, hätte 826 Zeilen gefüllt aussehen lassen,
über die niemand nachgedacht hat.

---

## Feld 6 · `akzeptanzkriterium` — 15 Vorschläge, und warum nicht 167

### Wie ein Vorschlag entsteht

**Der Wortlaut wird zerlegt, nicht ergänzt.** Jede Bedingung im Vorschlag ist ein
Satzteil der Klausel selbst, umgestellt in eine prüfbare Aussage. Beispiel
`K03-M15`, dessen Wortlaut lautet: *„Ein E-Mail-Code ist zehn Minuten und genau
einmal gültig. Ein neuer Code entwertet alle älteren Codes desselben Kontos.
Gespeichert wird nur sein kryptografischer Prüfwert."*

Daraus werden vier Bedingungen — (1) zehn Minuten gültig, (2) genau einmal gültig,
(3) ein neuer Code entwertet ältere, (4) gespeichert wird nur der Prüfwert. **Kein
Wert, keine Schwelle, keine Frist und kein Messweg kommt hinzu.** Was der Wortlaut
nicht sagt, sagt der Vorschlag ausdrücklich auch nicht:

> Messweg, Schwelle und Evidenzform sagt der Wortlaut nicht — sie ergänzt nach
> K23-M02 der fachliche Eigentümer, der in dieser Zeile heute ⟨nicht benannt⟩ ist.

Damit nimmt der Vorschlag dem Eigentümer die Schreibarbeit ab, nicht die
Entscheidung. Er kann streichen, schärfen oder verwerfen — aber er muss die Klausel
nicht noch einmal auseinandernehmen.

### Warum nur 15 Klauseln

**Die Zeichnung nennt 167. Diese Zahl ist aus dem Arbeitsstand nicht nachrechenbar.**
Nachgerechnet am 16.08.2026:

| Was gezählt wurde | Ergebnis |
|---|---:|
| Klauseln im Bestand | 1231 |
| vom Stichwortverzeichnis berührt (`S1_wortmarken.json`) | 470 |
| davon in den Leseblättern gebündelt | 448 |
| von mindestens zwei Stationen berührt | 96 |
| im Klauselschnitt **einzeln benannt** (Blöcke 1a, 1b, 2) | **15** |
| **gesucht** | **167** |

Der Baubericht `arbeit/Bauberichte/steuertexte_pruefung_260816.md`:538 nennt die
Zusammensetzung: *167 = 152 Stationswörter + 5 Bauspur + 10 von Prüffällen
genannte.* **Das Blatt, das diese Auswahl trägt** — `zeichnung_M7-M10_260815.md`,
Kreuz 7.2 — **liegt nicht im Arbeitsstand**, sondern auf dem Zweig
`umsetzung/M7-M10-260815`. Ohne dieses Blatt gibt es keine Liste der 152, und die
Zahl allein reicht nicht: es gibt mehrere Auswahlen aus dem Stichwortverzeichnis,
die zufällig 152 ergeben. Eine davon zu greifen, wäre geraten.

**Deshalb der engste belegbare Schnitt.** Genommen wurden die Klauseln, die
`nachweise/klauselschnitt/S1_zeichnung.md` **einzeln mit Kennung und Fundstelle**
aufführt:

| Block | Was ihn trägt | Klauseln |
|---|---|---:|
| **1a** | vom Bau beansprucht und Zeile für Zeile ganz gedeckt | 7 |
| **1b** | vom Bau beansprucht, nur teilweise gedeckt | 6 |
| **2** | vom Bau beansprucht, ohne Scheibenangabe | 2 |
| | **Summe** | **15** |

**Block 3 bleibt außen vor**, und das ist kein Versäumnis: das Blatt sagt selbst,
ein Worttreffer belege *„dass ein Wort an zwei Stellen steht — nicht, dass die
Regel zu dieser Scheibe gehört."* Dort steht keine Klausel einzeln, sondern eine
Leseliste über 22 Stationen.

**Auch die 15 tragen im Klauselschnitt noch keinen Haken.** Der Vorschlag sagt das
in jeder Zelle mit: *dort noch ohne Haken.*

### Was fehlt, damit die restlichen entstehen

Ein Schritt, kein Werkzeugwechsel: **`zeichnung_M7-M10_260815.md` in den
Arbeitsstand bringen** oder die Liste der 167 Kennungen benennen. Danach
`pflege_erzeugen.py` um diese Kennungen erweitern und neu fahren.

---

## Wie die Datei neu entsteht

```
python3 nachweise/klauselregister/pflege_erzeugen.py
python3 werkzeuge/klauselregister.py \
  --konzepte "<…>/03_KONZEPTE_v2.9/concepts-md" \
  --pflege   nachweise/klauselregister/pflege.json \
  --ziel     nachweise/klauselregister/register.json \
  --markdown nachweise/klauselregister/register.md
```

`pflege.json` ist **erzeugt, nicht von Hand gepflegt** — das war die Auflage aus
Blatt 26:59–63. `pflege_erzeugen.py` liest `triage.json` und trägt die Zerlegung
der 15 Wortlaute; beides ist im Quelltext nachlesbar.

**Das Werkzeug `werkzeuge/klauselregister.py` wurde nicht angefasst.**

---

## Was das Register jetzt meldet

| | vorher (07.08.) | nachher (16.08.) |
|---|---:|---:|
| Klauseln | 1231 | 1231 |
| ohne Eigentümer | 1231 | **1231** |
| ohne Kritikalität | 1231 | **826** |
| ohne Akzeptanzkriterium | 1231 | **1216** |
| ohne Test | 1231 | 1231 |
| vollständige Zeilen | 0 | **0** |
| Befunde des Werkzeugs | 1 (*Pflegedatei nicht gefunden*) | **0** |

**Keine einzige Zeile ist vollständig, und `--streng` gibt weiterhin 1 zurück.**
Das ist richtig so: Gate 11 schlägt weiter an, weil `K23-M02` weiter nicht erfüllt
ist. Was sich geändert hat, ist nicht die Sperre — sondern dass sie jetzt auf
**einen benannten Rest** zeigt statt auf alles.

---

*Erzeugt am 16.08.2026 vom Coding-Harness zu B-4. Der Harness zeichnet nie und
erfindet keinen Umfang. Alle Zahlen dieses Blattes sind gemessen; wo eine Zahl
nicht gemessen werden konnte, steht sie als offener Punkt da.*
