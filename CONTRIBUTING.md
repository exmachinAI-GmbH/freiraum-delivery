# Verständlich schreiben, bedienbar bauen

**In einem Satz:** Alles, was in diesem Repository neu entsteht, muss eine Person verstehen
und bedienen können, die nicht programmiert.

Das ist keine Stilfrage. Dieser Coding-Harness — die Bau- und Prüfmaschinerie dieses
Repositorys: die Agenten, die automatischen Prüfläufe und die Regeln, nach denen beide
arbeiten — wird von den Personen gesteuert, die für die
Lieferung geradestehen — sie geben frei, sie zeichnen, sie tragen das Risiko. Wer eine
Freigabe erteilen soll, muss vorher verstanden haben, wofür. Ein Text, den nur der Autor
versteht, verlagert die Entscheidung heimlich zurück zum Autor.

---

## 1 · Wer mitliest

| Wer | Was diese Person können muss |
|---|---|
| **Auftraggeber** | in fünf Minuten sagen können, was sich geändert hat und ob sie es trägt |
| **Zeichnende Person** (A. Han, `@AndrewExma`) | einen Pull Request freigeben, ohne den Code zu lesen |
| **Fachverantwortliche, Datenschutz** | erkennen, ob eine Änderung ihr Thema berührt |
| **Fremdes Prüfmodell (Tor 3)** — eine KI eines *anderen* Anbieters als die, die hier baut; sie prüft unabhängig gegen die Rohbelege | den Zweck aus dem Text entnehmen, nicht aus dem Code raten |
| Entwicklerin oder Agent | die Änderung nachbauen |

Die technisch geübte Leserin steht bewusst **an letzter Stelle**. Sie kommt auch mit einem
schlechten Text zurecht. Die anderen vier nicht.

---

## 2 · Wofür das gilt

| Textsorte | Gilt |
|---|---|
| `README.md` und alle Dateien unter `doku/` | ja |
| **Commit-Nachrichten** | ja |
| **Issues** | ja |
| **Pull Requests** — Titel und Beschreibung | ja |
| **Projekttafeln** (GitHub Projects) — Tafelname, Spalten, Kartentitel, Ansichten | ja |
| **Agenten und Kommandos** unter `.claude/` — Name, Beschreibung, Ausgaben | ja |
| **Namen, die sichtbar werden** — Etiketten, Workflows, Prüfschritte, Zweignamen | ja |
| **Fehlermeldungen** in Skripten und Prüfläufen | ja |
| Quelltext selbst, Kommentare im Code, SQL | nein — dort gelten die Regeln des Fachs |

### Ab wann

Ab dem Tag, an dem dieser Text in `main` steht — für alles, was **danach neu** geschrieben
wird.

### Was ausdrücklich ausgenommen ist

**Der gesamte Bestand.** Alle Commits, Issues und Pull Requests, die es am Tag der Aufnahme
schon gab, bleiben, wie sie sind. Sie werden nicht nachgebessert, nicht umgeschrieben, nicht
neu betitelt. Dafür gibt es zwei harte Gründe:

1. **Die Nachweiskette führt Commit-Nummern.** Die Testmanifeste dieses Harness führen als
   erstes Glied den Commit-Hash des geprüften Standes (`CLAUDE.md` Abschnitt 4, erzeugt von
   `werkzeuge/manifest.py`). K23-M18 — die Klausel, die vorschreibt, was am Ende eines Laufs
   im unveränderlichen Manifest stehen muss — verlangt dafür Laufkennung, Bau- und
   Schemafassung sowie die Prüfsummen aller Eingaben und Ergebnisse. Wer die Historie
   umschreibt, vergibt neue Nummern und macht jedes bereits abgelegte Manifest ungültig, das
   auf die alten verweist.
2. **Überschreibendes Zurückschieben ist auf `main` gesperrt** (kein Force-Push). Es ginge
   technisch gar nicht, ohne den Schutz abzuschalten, der seit dem 09.08.2026 wirkt.

Nachträgliches Schönschreiben ist deshalb kein Versäumnis, sondern verboten.

---

## 3 · Die zehn Regeln

**Zwei Textarten, ein Unterschied.** `SPR-1` und `SPR-4` geben die Form von
**Änderungstexten** vor — Commit, Issue, Pull Request, Kartentitel, Fehlermeldung. Für
**Nachschlagetexte** (`README.md`, Dateien unter `doku/`) gelten sie nicht: die beschreiben
einen Zustand, keine Änderung. Dort gelten `SPR-2`, `SPR-3` und `SPR-5` bis `SPR-10`
unverändert.

### SPR-1 · Der erste Satz sagt, was sich in der Sache ändert

Nicht, welche Datei angefasst wurde. Wer nur den ersten Satz liest, soll das Richtige
wissen.

| statt | besser |
|---|---|
| „`tore.yml` angepasst" | „Der automatische Prüflauf misst jetzt auch die Oberfläche" |
| „Refactoring `mail/versand.py`" | „Der Mailversand meldet jetzt, wenn eine Zustellung fehlschlägt" |

### SPR-2 · Jede Kennung wird bei ihrer ersten Nennung im selben Satz erklärt

Dieses Projekt arbeitet mit sehr vielen Kürzeln: `K23-M04`, `Tor 1b`, `F05`, `M30`, `B1`,
`BEF-D3`, `RR-01`. Für Eingeweihte sind das Adressen. Für alle anderen ist es Rauschen.

**Regel:** Kennung nennen, dann in einem Halbsatz sagen, was dahintersteht.

> „Nach **K23-M04** — der Klausel, die für jede ungetestete Anforderung einen einzelnen
> Eintrag in der Restrisikoliste verlangt — sind das 386 Fälle."

Zweite und weitere Nennungen im selben Text dürfen die Kennung allein führen.

**Ausnahme Betreffzeile.** In der Betreffzeile eines Commits und im Titel eines Issues oder
Pull Requests darf eine Kennung unerklärt stehen — 72 Zeichen tragen keine Erklärung. Sie
wird dann bei ihrer ersten Nennung im Fließtext erklärt. Das Beispiel in Abschnitt 7 macht
es so vor.

### SPR-3 · Fachwörter erklären oder ersetzen

Wo es ein gebräuchliches deutsches Wort gibt, wird es benutzt. Wo der Fachbegriff nötig ist,
steht die Erklärung dabei — beim ersten Mal. Das Glossar in Abschnitt 6 ist die
Standardauflösung; wer davon abweicht, erklärt neu.

### SPR-4 · Reihenfolge: Anlass → Änderung → Wirkung → was gleich bleibt

Vier Fragen, immer in dieser Ordnung:

1. **Anlass** — was war das Problem, und wie ist es aufgefallen?
2. **Änderung** — was ist jetzt anders?
3. **Wirkung** — was merkt man davon, und wer muss deshalb etwas anders machen?
4. **Nicht geändert** — was man vielleicht erwartet hätte, aber bewusst nicht angefasst
   wurde.

Punkt 4 wird am häufigsten vergessen und am dringendsten gebraucht. Er ist die Antwort auf
die Frage „was könnte mir das kaputt machen?".

### SPR-5 · Zahlen statt Adjektive

„Deutlich schneller", „umfassend geprüft", „weitgehend abgedeckt" sind keine Aussagen.
**110 von 110 Prüffällen bestanden** ist eine.

Wo eine Zahl fehlt, wird das gesagt: *„nicht gemessen"* ist eine zulässige und oft die
ehrlichste Angabe.

### SPR-6 · Der Text muss allein tragen

Kein Verweis auf ein Gespräch, eine Sitzung oder „wie besprochen". Wer den Text in sechs
Monaten ohne Vorwissen öffnet, muss zurechtkommen. Das ist dieselbe Regel, die den
Arbeitszweigen zugrunde liegt: Entscheidungen stehen in Git und im Manifest, nie im
Gesprächsverlauf.

### SPR-7 · Nur behaupten, was gemessen wurde — mit der Messung dabei

Wer schreibt „läuft", schreibt dazu, womit das festgestellt wurde: welcher Befehl, welches
Ergebnis. Was nicht gemessen werden konnte, heißt **gesperrt**, nicht *bestanden*
(K23-M22 — die Klausel, die je Test genau vier Zustände zulässt: bestanden, fehlgeschlagen,
gesperrt, nicht ausgeführt).

### SPR-8 · Jede neue Bedienung hat einen Bedienpfad in Worten

Wer etwas Neues baut, das bedient werden kann — ein Kommando, einen Agenten, einen Prüflauf,
eine Projekttafel —, schreibt dazu:

- **wo man klickt oder was man tippt**, Schritt für Schritt;
- **was man dann sieht**, wenn es gut geht;
- **was man sieht, wenn es schiefgeht**, und was dann zu tun ist.

Ohne diese drei Angaben gilt die Sache als nicht bedienbar, auch wenn sie funktioniert.

### SPR-9 · Fehlermeldungen sagen, was zu tun ist

Eine Meldung nennt: was nicht ging, woran es lag, und den nächsten Schritt. „Fehler in
Zeile 42" erfüllt das nicht. Stumm abbrechen ist der schlimmste Fall — genau daran ist
dieser Harness schon einmal aufgelaufen (Befund BEF-D3: der Prüflauf schwieg, wenn das
Datenbankwerkzeug `psql` fehlte).

### SPR-10 · „Tor" steht nie allein mit einer Zahl

Für die vier Messstufen dieses Harness schreiben neue Texte **Messstufe 1 bis 4**. Wo das
Wort „Tor" bleibt, trägt es bei der ersten Nennung sein Beiwort:

> Abnahmetor Tor I · II · III · Starttor 05 bis 18 · Echtdaten-Tor E1 bis E10 ·
> Fabrik-Tor 1 bis 4 · Gate 1 bis 15 aus K23.

**Nicht erfasst sind Bezeichner, die eine Maschine vergleicht** — Prüfungsnamen im
Zweigschutz, Dateinamen, Zweignamen, Felder in Manifesten. Ein Beiwort dort bricht die
Sperre, die es schützen soll.

**Bestandsschutz:** Was vorher geschrieben wurde, bleibt unverändert und wird nicht
nachbenannt.

**Warum „Messstufe" und kein neues Wort:** Es steht bereits gezeichnet in Blatt 57 vom
10.08.2026, unterschrieben von beiden Vertragsparteien — *„vollständig belegt, mit allen vier
Messstufen"*. Und es kollidiert nirgends: null Fundstellen im Bauauftrag, null in der Anlage
Baustrategie, null in den 24 Konzepten.

*Der Anlass: Das Wort „Tor" trägt im Projekt sieben verschiedene Bedeutungen. Eine
Umbenennung wurde am 16.08.2026 ausdrücklich abgelehnt — sie hätte 53 Stellen im Auftrag,
21 in einer Anlage, 51 in der anderen, 33 in den Konzepten und 268 im Repository berührt und
dabei zwei von sieben Bedeutungen aufgelöst. Diese Regel kostet nichts und wirkt auf alles
Neue.*

---

## 4 · Die Probe vor dem Absenden

Vier Fragen. Wer eine davon mit *nein* beantwortet, schreibt den Text noch einmal.

1. Könnte die zeichnende Person **allein aus diesem Text** freigeben, ohne den Code zu
   öffnen?
2. Ist **jede Kennung und jedes Fachwort** bei der ersten Nennung erklärt?
3. Steht da, **was gleich bleibt** und was jemand jetzt anders machen muss?
4. Ist **jede Erfolgsaussage** mit einer Messung belegt oder ausdrücklich als ungemessen
   gekennzeichnet?

---

## 5 · Aufbau der einzelnen Textsorten

### Commit-Nachricht

```
<Betreffzeile: was sich in der Sache ändert, höchstens 72 Zeichen, kein Punkt am Ende>

Anlass:        warum das nötig war, und wie es aufgefallen ist
Änderung:      was jetzt anders ist
Wirkung:       was man davon merkt, wer etwas anders machen muss
Nicht geändert: was bewusst so geblieben ist
Gemessen:      Befehl und Ergebnis — oder "nicht gemessen"
```

Die Vorlage dafür liegt als `.gitmessage` bei. `./install.sh` trägt sie ein; danach steht
sie bei jedem `git commit` von selbst im Editor. Bei `git commit -m "…"` erscheint sie
nicht — wer so committet, hält diesen Abschnitt von Hand ein. Von Hand einschalten:

```bash
git config commit.template .gitmessage
```

**Wenn beim `git commit` ein leerer Editor aufgeht**, ist die Vorlage nicht eingetragen.
Prüfen mit `git config --get commit.template`. Kommt keine Antwort, `./install.sh` erneut
ausführen und die Zeile zur Commit-Vorlage lesen — sie nennt den nächsten Schritt.

### Issue

Zwei Vorlagen stehen bereit und erscheinen beim Anlegen von selbst: **Befund melden**
(etwas stimmt nicht) und **Aufgabe** (etwas soll entstehen). Beide fragen den Anlass und den
Gegenstand aus SPR-4 ab und ergänzen sie um das, was bei einem Issue zusätzlich nötig ist:
den Nachstellweg beim Befund, das Fertigkriterium bei der Aufgabe. Den Punkt *Nicht
geändert* verlangt erst der Pull Request — ein Issue hat noch nichts geändert.

### Pull Request

Die Vorlage `.github/PULL_REQUEST_TEMPLATE.md` füllt jede neue Beschreibung vor. Sie
verlangt zusätzlich den Abschnitt **„Was die freigebende Person wissen muss"** — die Stelle,
die im Zweifel Aufmerksamkeit braucht, und die Angabe, ob eine Freigabe ohne Codelektüre
möglich ist.

### Projekttafel (GitHub Projects)

- **Tafelname** sagt, welche Arbeit dort liegt — nicht „Board 1".
- **Spalten** benennen einen Zustand in Alltagssprache: *offen · in Arbeit · wartet auf
  Freigabe · erledigt*. Nicht *Backlog*, *WIP*, *Done*.
- **Kartentitel** folgen SPR-1: was sich ändert, nicht welche Datei.
- Jede Ansicht mit einem Filter bekommt eine Beschreibung, die sagt, was sie ausblendet.

### Agent oder Kommando unter `.claude/`

Jede neue Definition führt **unmittelbar unter dem YAML-Block** — den beiden `---`-Zeilen
mit `name`, `description`, `tools`, `model` — als erste fünf Absätze des Fließtextes, in
dieser Reihenfolge:

1. **Was dieser Agent tut** — ein Satz, ohne Fachwort.
2. **Wann man ihn ruft** und wann ausdrücklich nicht.
3. **Was er sehen darf und was nicht** — die Rollentrennung im Klartext.
4. **Wie man ihn startet** und was man dann sieht (SPR-8).
5. **Was er nie tut.**

In den YAML-Block selbst gehört nichts davon; er trägt nur die vorgesehenen Felder, sonst
lädt die Datei nicht — und meldet das nicht.

Das Feld `description` ist der Satz, den eine nicht programmierende Person liest, um zu
entscheiden, ob sie diesen Agenten braucht. Es ist keine Notiz für Eingeweihte.

---

## 6 · Glossar

Die Standardauflösung. Wer einen dieser Begriffe benutzt, darf auf diese Tabelle verweisen,
statt neu zu erklären.

| Begriff | Was es ist |
|---|---|
| **Harness** | die Maschinerie aus Agenten, Prüfläufen und Regeln, mit der hier gebaut und gemessen wird |
| **Agent** | ein KI-Arbeiter mit festem Auftrag und festen Rechten; er führt aus, er entscheidet nichts |
| **Repository, Repo** | der Ablageort des Codes bei GitHub, mit vollständiger Änderungsgeschichte |
| **Commit** | ein gespeicherter Änderungsschritt mit Nummer, Autor, Zeit und Begründung |
| **Zweig (Branch)** | eine Nebenspur zum Arbeiten; `main` ist die Hauptspur, die als gültig gilt |
| **Pull Request, PR** | der Antrag, eine Nebenspur in die Hauptspur zu übernehmen — die Stelle, an der ein Mensch freigibt |
| **Zusammenführen (Merge)** | die Übernahme einer Nebenspur in die Hauptspur, nach Freigabe |
| **Issue** | ein notierter Punkt: ein Fehler, eine Frage oder eine Aufgabe |
| **Etikett (Label)** | eine Markierung an Issue oder Pull Request, nach der man filtern kann |
| **CI, automatischer Prüflauf** | Prüfungen, die GitHub bei jeder Änderung selbst startet |
| **Workflow** | eine Ablaufbeschreibung für solche automatischen Prüfläufe |
| **Lint** | eine Prüfung auf Form- und Stilfehler im Code, bevor er ausgeführt wird |
| **Datenbankschema, DDL** | der Bauplan der Datenbank: welche Tabellen und Felder es gibt |
| **Migration** | ein Änderungsschritt am Bauplan der Datenbank, als Datei abgelegt und wiederholbar |
| **Seed** | ein Startbestand an Beispieldaten, mit dem eine leere Datenbank gefüllt wird |
| **Negativfall** | ein Testfall, der **scheitern muss**; besteht er, ist der Schutz nicht wirksam |
| **Mandant** | ein Kunde als abgetrennter Datenbereich; kein Mandant darf Daten eines anderen sehen |
| **Zeilengenauer Zugriffsschutz (RLS)** | eine Sperre in der Datenbank selbst, die Zeile für Zeile entscheidet, wer sie sehen darf |
| **Prüfsumme (Hash)** | eine Kennzahl aus dem Dateiinhalt; ändert sich der Inhalt, ändert sie sich mit — so erkennt man Abweichungen |
| **Klausel** | eine einzelne nummerierte Anforderung aus einem der 24 gezeichneten Konzepte, z. B. `K23-M04` |
| **Tor 1 bis 4** | die vier Prüfstufen dieses Harness: 1 maschinell, 2 blind gegen die Anforderungen, 3 durch eine KI eines anderen Anbieters, 4 durch einen Menschen |
| **Manifest** | das maschinenlesbare Protokoll eines Prüflaufs: was womit wann gegen welchen Stand gemessen wurde |
| **Restrisikoliste** | die Liste der Anforderungen, für die es keinen Test gibt — je Anforderung ein Eintrag |

---

## 7 · Ein Beispiel

Beide Fassungen beschreiben denselben erfundenen Vorgang. Der Bestand des Repositorys ist
ausdrücklich **nicht** gemeint.

**Vorher**

```
fix: pflege.json + tor1a guard
```

**Nachher**

```
Tor 1a prüft jetzt gegen eine Pflegeliste statt gegen sich selbst

Anlass:        Der automatische Prüflauf "Tor 1a" ruft eine Datei
               nachweise/klauselregister/pflege.json auf, die es nicht gibt.
               Statt zu scheitern, fiel er still auf den mitgelieferten Stand
               zurück und meldete grün, ohne etwas zu messen.
Änderung:      Die Datei ist angelegt und gefüllt. Fehlt sie künftig, bricht
               der Prüflauf mit einer benannten Meldung ab.
Wirkung:       Das Klauselregister — die Liste aller 1231 Anforderungen aus den
               24 gezeichneten Konzepten — weist ab jetzt aus, welche davon ein
               Abnahmekriterium haben. Wer eine Anforderung ergänzt, pflegt sie
               dort ein, sonst schlägt Tor 1a an.
Nicht geändert: Die Anforderungen selbst und die Konzepte bleiben unangetastet.
               Kein Prüfwert wurde gesenkt.
Gemessen:      bash pruefungen/lauf.sh -> 110 von 110 bestanden;
               fehlende Datei künstlich erzeugt -> Abbruch mit Meldung, wie erwartet.
```

Der zweite Text ist länger. Er spart die Rückfrage, die der erste auslöst.

---

## 8 · Was diese Vorgabe nicht ist

- **Sie ist keine Klausel aus den 24 gezeichneten Konzepten.** Sie legt fest, wie die
  Lieferseite über ihre Arbeit spricht, nicht was gebaut wird. Sie erweitert den Bauumfang
  um nichts.
- **Sie ist kein Tor.** Ein Text, der ihr nicht genügt, wird überarbeitet — er wird nie zum
  Anlass, einen Prüfwert zu senken, eine Schwelle zu lockern oder eine Einstufung
  herabzusetzen. Das bleibt in jedem Fall verboten (K23-D05).
- **Sie ist noch nicht Teil der gezeichneten Verfassung.** Die Anlage „Bauverfahren" ist der
  unterschriebene Text, `CLAUDE.md` nur ihre ausführbare Fassung; Änderungen fließen von der
  Anlage zur `CLAUDE.md`, nie umgekehrt. Damit diese Vorgabe den Harness bindet und nicht
  nur die Menschen an der Tastatur, muss sie in die Anlage aufgenommen und gezeichnet
  werden. Ein zeichnungsfertiger Absatz dafür liegt bei:
  `arbeit/Vorlagen/nachtrag_anlage_sprache.md`. **Bis dahin gilt sie als Arbeitsregel des
  Auftraggebers** — verbindlich für alle, die hier schreiben, aber nicht maschinell
  erzwungen.
- **Nach der Zeichnung gilt der Wortlaut der Anlage.** In die Anlage geht die Kurzfassung
  der neun Regeln ein. Dieser Text hier bleibt die ausführliche Arbeitsfassung; er
  erläutert, bindet aber nicht — bei Abweichung gilt der gezeichnete Wortlaut.

---

*Angelegt am 14.08.2026 auf Weisung des Auftraggebers. Kennung der Regeln: `SPR-1` bis
`SPR-10` (SPR-10 aufgenommen am 16.08.2026). Die Kennungsräume `V-`, `C-` und `F-` sind anderweitig belegt und wurden bewusst
nicht benutzt.*
