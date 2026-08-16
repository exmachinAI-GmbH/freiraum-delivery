# `.claude/settings.json` ist gebaut — und was sie kann, was sie nicht kann

**Punkt B-18 der Schlussrunde. Die Empfehlung lautete: entweder bauen oder ausdrücklich als
Restrisiko tragen; der Zwischenzustand ist der schlechteste. Der Auftraggeber hat „bauen"
gezeichnet. Die Datei ist gebaut. Sie schließt einen Teil der Lücke — und dieses Blatt sagt
genau, welchen Teil nicht, statt es zu behaupten.**

| | |
|---|---|
| **Angelegt** | `/Users/mveil/freiraum-delivery/.claude/settings.json` |
| **Gebaut am** | 16.08.2026 |
| **Grundlage** | Weisung zu B-18 · Grenzen aus `CLAUDE.md` Abschnitt 3 und den beiden Agentenbeschreibungen unter `.claude/agents/` |
| **Gemessen gegen** | Claude Code **2.1.233** (`claude --version`) |

---

## 1 · Der Satz, der seit jeher in der Verfassung steht

> „Die Pfadgrenzen sind Anweisung, nicht Mechanik. Das Werkzeugfeld im Frontmatter beschränkt
> Werkzeuge, nicht Pfade. Wer die Blindheit mechanisch will, braucht `deny`-Regeln in
> `.claude/settings.json`. **Diese Datei existiert noch nicht — offener Punkt.**"
> — `CLAUDE.md`, Abschnitt 3

Die Datei existiert jetzt. Der Satz muss trotzdem umgeschrieben werden, und zwar nicht auf
„erledigt". **Warum, steht in Abschnitt 4 dieses Blattes.**

---

## 2 · Was die Datei enthält

Vierzehn Verbotsregeln, in drei Gruppen. Jede ist **rollenneutral** — sie gilt für den
Bau-Agenten, den Prüf-Agenten und den Orchestrator gleichermaßen, und keiner von ihnen braucht
das Verbotene für seine Arbeit.

| Gruppe | Regeln | Grundlage |
|---|---|---|
| **Geheimnisse** | `Read/Edit/Write` auf `./.env` und `./.env.*` | *„Keine Geheimnisse im Repo"* (`README.md`:30) · **K23-D09** — ein Fund sperrt den Lauf · `.gitignore` führt `.env` und `.env.*` bereits |
| **Konzept-Fabrik und Zielbau** | `Edit/Write` auf alles unter `10_KNOWLEDGE_REPO/` und unter `v2.9_PIVOT/` | `CLAUDE.md` Abschnitt 6: *„Eine Datei in der Konzept-Fabrik oder in `v2.9_PIVOT/` verändern"* — steht dort unter **Was du nie tust** |
| **Die gezeichnete Anlage** | `Edit/Write` auf alles unter `30_DELIVERY_HARNESS/` | Dort liegt die Anlage „Bauverfahren". Sie liegt **bewusst außerhalb** dieses Repos, weil `./install.sh --pruefsumme` die `CLAUDE.md` *gegen* sie misst. Ein Werkzeug, das beide Seiten ändern kann, misst nichts |

### Nachgeprüft, dass die Datei gültig ist

Zwei Prüfungen, beide am 16.08.2026 gelaufen:

```
$ python3 -m json.tool .claude/settings.json > /dev/null && echo "OK - gueltiges JSON"
OK - gueltiges JSON

$ jq -e '.permissions.deny | length' .claude/settings.json
14
```

Der zweite Befehl beweist mehr als der erste: Er findet das Feld **an der Stelle, an der die
Einstellungen es erwarten** (`permissions.deny`), und zählt vierzehn Einträge. Ein Tippfehler
im Feldnamen hätte hier einen Fehler ergeben, kein Ergebnis.

### Eine Regel, deren Wirkung nicht gemessen ist

Zwei der vierzehn Regeln nennen den vollständigen Ordnerpfad in der Dropbox. **Dieser Pfad
enthält Leerzeichen** (`Team-Ordner exmachinAI`, `01_AEGIRA _AI_TRUST_PLATFORM`). Ob die
Mustererkennung der Berechtigungen mit Leerzeichen im Pfad zurechtkommt, **ist nicht
gemessen** — es ließ sich in dieser Sitzung nicht prüfen.

**Deshalb stehen dieselben Verbote zusätzlich in einer pfadunabhängigen Form** (`//**/10_KNOWLEDGE_REPO/**`
und so weiter). Greift die eine Form nicht, greift die andere. Eine Regel, die auf nichts
passt, richtet keinen Schaden an — sie tut nur nichts.

---

## 3 · Was ausdrücklich **nicht** drinsteht — die Rollentrennung

**Das ist der wichtigste Absatz dieses Blattes.**

Die eigentlich gemeinte Grenze ist die zwischen Bau und Prüfung:

| | Bau-Agent | Prüf-Agent |
|---|---|---|
| **Schreibt nach** | `app/ install/ mail/ migrations/ seeds/ schema/ werkzeuge/`, `arbeit/Bauberichte/` | **ausschließlich** `pruefungen/` |
| **Schreibt nie nach** | **`pruefungen/`** | alles andere |
| **Liest** | Klauseln, Code, Schema, Läufe | **nur** Klauseln und Akzeptanzkriterien |
| **Liest nie** | die Prüfdateien | **`app/`** und jede Datei mit Umsetzungscode |

**Diese beiden Grenzen sind Spiegelbilder.** Was der eine nicht anfassen darf, ist genau der
Ordner, in dem der andere arbeitet:

- Ein Verbot `Write(./pruefungen/**)` würde den Bau-Agenten richtig sperren — **und den
  Prüf-Agenten arbeitsunfähig machen.**
- Ein Verbot `Read(./app/**)` würde die Blindheit des Prüf-Agenten erzwingen — **und dem
  Bau-Agenten den Blick auf seinen eigenen Code nehmen.**

### Warum eine einzelne `settings.json` das nicht auflösen kann

**Gemessen, nicht vermutet.** Das vollständige Einstellungsschema von Claude Code 2.1.233
kennt unter `permissions` genau vier Listen — `allow`, `deny`, `ask`, `additionalDirectories`
— und einen `defaultMode`. **Keine dieser Angaben hat eine Spalte für „welcher Agent".** Die
Datei gilt für die ganze Sitzung: Hauptfaden und alle Unteragenten zugleich.

Deshalb enthält die gebaute Datei **keine** der beiden Rollengrenzen. Sie hineinzuschreiben
hätte den Harness angehalten, nicht gesichert.

### Zwei weitere Grenzen, die aus demselben Grund fehlen

| Grenze | Aus | Warum sie nicht global gesetzt werden kann |
|---|---|---|
| `nachweise/manifeste/` — kein Agent schreibt dorthin | `bau-agent.md`:44 | **Der Orchestrator schreibt dort.** Ein globales Verbot würde die Manifeste anhalten |
| `CLAUDE.md`, `.claude/`, `.github/` — der Bau-Agent schreibt dort nie | `bau-agent.md`:45 | Der Orchestrator pflegt diese Dateien. Ob er das künftig noch darf, ist eine **Entscheidung**, keine Messung — sie ist nicht gezeichnet, deshalb steht sie nicht in der Datei |

---

## 4 · Der Weg, der die Rollentrennung mechanisch machen würde — als Vorschlag

**Es gibt einen, und er ist gemessen.** Er wird hier **vorgeschlagen, nicht gebaut** — weil
seine Wirkung nicht nachgeprüft werden konnte und ein Fehlschlag beide Agenten zum Stehen
brächte, fünfzehn Tage vor dem Endtermin.

**Was gemessen wurde:** Die Agentenbeschreibungen unter `.claude/agents/` nehmen im Kopf mehr
Felder an als nur `name`, `description`, `tools` und `model`. Die Liste der zugelassenen
Felder in Claude Code 2.1.233 führt unter anderem:

```
"tools", "disallowedTools", "color", "permissionMode", "maxTurns", "initialPrompt", …
```

**`disallowedTools` ist eine Verbotsliste je Agent** — genau die fehlende Spalte. Eine
Fehlermeldung desselben Programms zeigt, dass ihre Einträge mit demselben Regelleser gelesen
werden wie die Berechtigungen (sie spricht von *„a space before the rule parens or an
unbalanced paren"* — also von Regeln der Form `Read(…)`, nicht bloß von Werkzeugnamen).

**Was nicht gemessen wurde:** ob ein Eintrag der Form `Read(./app/**)` dort auch **den Pfad**
auswertet oder nur den Werkzeugnamen `Read`. Das ließe sich nur prüfen, indem man einen Agenten
mit einer solchen Zeile tatsächlich startet — das war in dieser Sitzung nicht möglich.

**Das Risiko beim Blindflug ist benannt:** Dasselbe Programm meldet bei einem Eintrag, den es
nicht lesen kann, *„spawn refused"* — der Agent startet dann gar nicht.

> **Vorschlag des Orchestrators, zu prüfen bevor er gezeichnet wird:**
> In `.claude/agents/pruef-agent.md` im Kopf ergänzen:
> `disallowedTools: ["Read(./app/**)", "Read(./install/**)", "Read(./mail/**)", "Read(./migrations/**)", "Read(./seeds/**)", "Read(./schema/**)", "Read(./werkzeuge/**)", "Read(./arbeit/**)"]`
> und in `.claude/agents/bau-agent.md`:
> `disallowedTools: ["Write(./pruefungen/**)", "Edit(./pruefungen/**)"]`
>
> **Vorher ein Probelauf mit einem Wegwerf-Agenten**, der nichts tut außer zu starten. Startet
> er, greift die Form. Startet er nicht, ist der Weg widerlegt und kostet nichts.

---

## 5 · Die Lücke, die auch danach bleibt: `Bash`

**Eine Verbotsregel bindet die Werkzeuge, die sie nennt — sie bindet nicht die Kommandozeile.**
`Read(./app/**)` verbietet dem Lesewerkzeug den Zugriff. `cat app/haupt.py` in einem
Kommandozeilenaufruf ist ein **anderes** Werkzeug (`Bash`) und wird von dieser Regel nicht
berührt.

**Was das für die beiden Rollen bedeutet — und hier ist die Nachricht besser als erwartet:**

| | Werkzeuge laut Kopfzeile | Kommt an `Bash` heran? | Folge |
|---|---|---|---|
| **Prüf-Agent** | `Read, Write` | **nein** | Eine Lesesperre auf `app/` würde bei ihm **wirklich greifen**. Die Blindheit wäre mechanisch |
| **Bau-Agent** | `Read, Write, Edit, Bash, Grep, Glob` | **ja** | Jede Pfadsperre bleibt bei ihm eine **Anweisung**. Wer `Bash` hat, kann jede Datei lesen und schreiben |

**Das ist keine Nachlässigkeit, sondern ein Zielkonflikt:** Der Bau-Agent braucht die
Kommandozeile, um Migrationen und Prüfläufe zu fahren. Ihm `Bash` zu nehmen, hieße, den Bau
anzuhalten.

**Was daraus folgt:** Selbst der vollständige Ausbau nach Abschnitt 4 macht **die Blindheit des
Prüf-Agenten** mechanisch — nicht die Schreibgrenze des Bau-Agenten. Die bleibt eine
Anweisung, und das ist ein **Restrisiko mit Träger**, kein gelöster Punkt.

Ein Trost, und er ist gemessen: Die Grenze, die zweimal Prüffälle erzeugt hat, die nichts
maßen (02.08.2026 und 15.08.2026, `BEF-M3-6`), ist **die Blindheit der Prüfung** — genau die,
die mechanisch machbar wäre.

---

## 6 · Ob die Datei heute schon wirkt

**Nicht messbar in dieser Sitzung, und das wird hier gesagt statt behauptet.** Die
Einstellungsdatei wird beim Start einer Sitzung gelesen. Sie existierte beim Start dieser
Sitzung nicht. Ob sie nachgeladen wurde, lässt sich von innen nicht feststellen.

**Der Nachweis, dass sie greift, ist in der nächsten Sitzung zu führen** — in drei Schritten,
die jeder nachvollziehen kann:

1. `claude` im Verzeichnis `~/freiraum-delivery` neu starten.
2. Den Befehl `/permissions` eingeben. Die vierzehn Regeln müssen unter *deny* stehen.
3. Versuchen, eine Datei unter `10_KNOWLEDGE_REPO/` zu ändern. Der Versuch muss abgewiesen
   werden — **mit der Meldung im Wortlaut als Nachweis.**

**Bis dieser Nachweis geführt ist, gilt die Datei als angelegt, nicht als wirksam.** Nach
`K23-M22` ist das der Zustand **gesperrt**, nicht *bestanden*.

---

## 7 · Was jetzt bei einem Menschen liegt

| | Was | Wer |
|---|---|---|
| **1** | **Den Nachweis aus Abschnitt 6 führen** — drei Schritte, wenige Minuten | wer als Nächstes eine Sitzung öffnet |
| **2** | **Über den Vorschlag aus Abschnitt 4 entscheiden**: Probelauf fahren und die Rollengrenzen je Agent eintragen — oder es lassen | M. Veil |
| **3** | **Die `Bash`-Lücke aus Abschnitt 5 als Restrisiko mit Träger und Frist tragen** — sie ist durch keinen Ausbau zu schließen, solange der Bau die Kommandozeile braucht | M. Veil |
| **4** | **Den Satz in `CLAUDE.md` Abschnitt 3 nachziehen** — er sagt heute noch *„Diese Datei existiert noch nicht"*. Die neue Fassung muss beides sagen: sie existiert, und sie erzwingt die Rollentrennung nicht | Orchestrator, nach Zeichnung von Punkt 2 und 3 |

> **Warum der Harness Punkt 4 nicht selbst getan hat:** `CLAUDE.md` ist die ausführbare Seite
> einer **gezeichneten** Anlage. Änderungen fließen von der Anlage zur `CLAUDE.md`, nie
> umgekehrt. Was dort künftig steht, hängt davon ab, wie die Punkte 2 und 3 entschieden werden
> — und das ist nicht die Sache des Harness.

---

## Zeichnung

*Dieser Block wird vom Auftraggeber ausgefüllt. Der Harness trägt hier nichts ein.*

- [ ] **Der Nachweis aus Abschnitt 6 ist geführt** — die Datei wirkt
- [ ] **Der Vorschlag aus Abschnitt 4 wird umgesetzt** — Probelauf, dann Rollengrenzen je Agent
- [ ] **Der Vorschlag aus Abschnitt 4 wird zurückgestellt** — Begründung: ⟨…⟩
- [ ] **Die `Bash`-Lücke wird als Restrisiko getragen** — Träger: ⟨…⟩ · Frist: ⟨…⟩

| Name | Rolle | Datum | Anmerkung |
|---|---|---|---|
| **M. Veil** | Auftraggeber | | |

---

*Angelegt am 16.08.2026 vom Orchestrator des Coding-Harness auf die Weisung zu Punkt B-18 der
Schlussrunde. Alle Aussagen über das Verhalten von Claude Code stammen aus Messungen am
Programm der Fassung 2.1.233, nicht aus Erinnerung. Wo eine Wirkung nicht gemessen werden
konnte, steht es dabei.*
