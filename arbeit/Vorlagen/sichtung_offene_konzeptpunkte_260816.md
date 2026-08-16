# Sichtung B-19 · Die offenen Punkte der Konzepte, sortiert — nicht entschieden

**Was heute wirklich sperrt, was eine Frist vor dem 31.08. trägt, und was eindeutig danach
kommt.**

| | |
|---|---|
| **Punkt** | **B-19** der Schlussrunde vom 16.08.2026, mit **B-20** (`entscheidungen_schlussrunde_260816.md`, Zeilen 256–264) |
| **Datum** | 16.08.2026 |
| **Art** | **Sichtung. Keine Entscheidung, keine Priorisierung.** Sie schlägt eine Ordnung vor und sagt, worauf die Ordnung beruht |
| **Angelegt von** | Orchestrator des Coding-Harness |
| **Kästchen** | **Kein Kreuz ohne Weisung — mit Weisung trägt der Harness es ein**, samt Wortlaut und Datum daneben. Die Kreuze der Handlungsempfehlungen sind am 16.08.2026 auf Weisung M. Veils eingetragen (`nachweise/vorbedingungen/formvermerk_uebertragene_kreuze_260816.md`, berichtigte Fassung) |
| **Gemessen an** | den 24 gezeichneten Konzepten unter `…/03_KONZEPTE_v2.9/concepts-md/` |

---

## 1 · Wie viele es wirklich sind

**Ein offener Punkt** ist eine Zeile in den *Offene-Punkte*-Tabellen der Konzepte. Er trägt
eine Kennung der Form `O-K##-#` — Beispiel: `O-K15-3` ist der dritte offene Punkt des
Konzepts K15.

### Der einfache Zählbefehl

```
$ cd ".../03_KONZEPTE_v2.9/concepts-md"
$ grep -chE '^\| *\**O-K[0-9]{2}-[0-9]+' *.md | paste -sd+ - | bc
203
```

**203 Zeilen tragen eine solche Kennung.** Das ist aber noch keine Antwort, denn ein großer
Teil dieser Zeilen ist **bereits geschlossen** und steht nur noch als Nachweis da.

### Warum eine einzige Zählregel nicht genügt

Gemessen: Die Konzepte führen ihre Offene-Punkte-Tabellen in **drei verschiedenen Formen**.

| Form | Spalten | Wie viele Zeilen | Wie man „offen" erkennt |
|---|---|---|---|
| **vierspaltig** | Kennung · Sache · Träger · **Frist** | 118 | Die Fristspalte ist gefüllt. Steht dort `—`, ist der Punkt geschlossen |
| **dreispaltig** | Kennung · Sache · Träger — **keine Fristspalte** | 74 | Nur am Text: trägt die Zeile einen Vermerk wie *„geschlossen"* oder *„Entschieden am …"*? |
| **zweispaltig** | Kennung · Status | 11 | Der Status sagt es wörtlich: *„geschlossen"* oder *„**Offen**"* |

Wer alle 203 Zeilen mit **einer** Regel zählt, zählt falsch. Wer nur die Fristspalte prüft,
übersieht die 74 dreispaltigen Zeilen — darunter **alle sechs** offenen Punkte des
Testkonzepts K23 und **alle sieben** des Prototyp-Konzepts K25.

### Das Ergebnis

```
$ python3 zaehl.py ".../03_KONZEPTE_v2.9/concepts-md"
offen: 103  geschlossen: 100  davon nur Ausfuehrung offen: 24  echter Entscheidungsbedarf: 79
```

| | Zahl | Was das heißt |
|---|---|---|
| Zeilen mit Kennung insgesamt | **203** | |
| davon **geschlossen** | **100** | Die Sache ist entschieden **und** die Zeile ist abgeschlossen |
| davon **offen** | **103** | |
| — davon **sachlich entschieden, nur Ausführung oder Nachweis fehlt** | **24** | Die Zeile trägt einen Vermerk wie *„Entschieden am 01.08.2026 (Founder)"* oder *„Beauftragt am …"*. **Sie kostet heute keine Entscheidung mehr, sondern Arbeit** |
| — davon **echter Entscheidungsbedarf** | **79** | **Das ist die Menge, um die es in B-19 geht** |

Das Zählprogramm ist vier Zeilen Logik und steht am Ende dieses Blattes (Abschnitt 8), damit
jeder die Zahl nachrechnen kann.

### Abweichung zur Schlussrunde — benannt, nicht geglättet

Die Schlussrunde nennt **75** Punkte und *„am dichtesten K15, K01, K00, K14"*. Diese Messung
findet **79** und eine andere Dichte:

| Konzept | echter Entscheidungsbedarf |
|---|---|
| **K01** Rahmenkonzept | **9** |
| **K15** Datenschutz und Löschen | **9** |
| **K14** Sicherheits-Grundlinie | **7** |
| **K25** Prototyp-Erzeuger | **7** |
| **K18** Wissens-Struktur | **7** |
| **K23** Test und Abnahme | **6** |
| K04 · 5 · K02 · 4 · K13 · 4 · K16 · 4 · K17 · 4 · K00 · 3 · K19 · 2 · K03 · 2 | |
| K07 · K06 · K11 · K12 · K21 · K08 — je 1 | |

**Zwei Unterschiede, beide gehören auf den Tisch:**

1. **79 statt 75.** Welche Zählregel hinter der 75 steht, ist nicht dokumentiert. Die Regel
   hinter der 79 steht oben und in Abschnitt 8. **Die Sichtung bleibt bei 79** und weist die
   Abweichung aus, statt sie anzupassen.
2. **K00 ist nicht unter den dichtesten.** K00 hat 14 Zeilen mit Kennung, davon sind **11
   entschieden** — meist am 30.07. und 31.07.2026 von den Foundern. **Echter
   Entscheidungsbedarf: 3.** Dafür sind **K25 und K18 mit je 7** dichter, als die
   Schlussrunde annimmt.

**Ein Punkt fehlt in allen Zahlen, und das ist richtig so:** `O-K23-7` — die Regel, dass ein
Negativfall an seiner **eigenen** Bedingung scheitern muss. Gemessen:
`grep -c 'O-K23-7'` in der exportierten K23 v1.1 ergibt **0**. Der Punkt steht nur im
Entwurf. **Genau das ist der Befund, den die Schlussrunde als C-2 führt** — eine Regel ohne
Klausel wird von keinem Tor durchgesetzt. Diese Sichtung kann ihn nicht zählen, weil er in
den gezeichneten Konzepten nicht existiert.

---

## 2 · Welche eine Frist tragen — die eigentliche Frage

Der Auftrag lautete, die Punkte mit einer Frist wie *„vor dem Bau"*, *„vor technischer
Abnahme"* oder *„vor dem ersten Kundenprojekt"* zu finden. Hier sind sie, alle 79 nach ihrer
Frist geordnet.

### Gruppe 1 · Frist **„vor dem Bau"** — 2 Punkte

**Die einzigen beiden im ganzen Bestand mit dieser Frist.** Der Bau läuft seit dem
09.08.2026 — die Frist ist also bereits verstrichen.

| Kennung | Sache | Träger |
|---|---|---|
| `O-K04-9` | K19 führt für den Direkt-Prototyp-Check keinen Bildschirm. K19 Abschn. 3 verbietet freies Zeichnen — K19 muss ihn aufnehmen | K19 |
| `O-K04-10` | Die fünf Fragen des Direkt-Prototyp-Checks haben keinen Träger im Datenmodell | Founder · Datenmodell |

> **Das ist Punkt C-3 der Schlussrunde**, dort an die Konzept-Fabrik gerichtet. Die Messung
> bestätigt: es sind genau diese zwei und keine weiteren.

### Gruppe 2 · Frist **„vor technischer Abnahme"** — 4 Punkte

Die technische Lieferabnahme ist **Tor II** des Bauauftrags — das Tor, das zum 31.08.2026
erreicht werden soll. *(Tor II, römisch, ist ein Abnahmetor des Auftrags — nicht Tor 2, die
zweite Messstufe dieses Harness.)*

| Kennung | Sache | Träger |
|---|---|---|
| `O-K02-1` | Fällt der Protokolleintrag aus, wird der Schreibvorgang zurückgerollt. Damit hängt **jeder** Schreibvorgang an der Verfügbarkeit des Protokolls | Founder · Betrieb |
| `O-K02-9` | `event.actor_label` ist Freitext und verweist nicht auf `actor`. Wie bleibt die handelnde Identität nach Umbenennung oder Kontolöschung nachvollziehbar? | K00 · K03 · Datenmodell |
| `O-K04-6` | Die beidseitige Verknüpfung Check ↔ Anwendung wird von keiner Bedingung abgeglichen | K00 · Datenmodell |
| `O-K13-4` | Der Abnahmetest für die Aussteuerung des Angebotspreises ist beschrieben, aber nicht geschrieben | K14 mit K13 |

### Gruppe 3 · Frist **„vor der Übergabe"** — 12 Punkte

| Kennung | Sache | Träger |
|---|---|---|
| `O-K02-8` | Welche Verarbeitungsregion je Kunde zugesagt ist | Founder |
| `O-K12-2` | Einstufung der Plattform als Hochrisiko oder nicht — **liegt bereits entscheidungsreif aufbereitet vor** | Founder mit Datenschutz und Recht |
| `O-K13-7` | `portal.data_locality` ist freier Text, kein Enum — die Zusage der Datenlokalität ist nicht maschinell prüfbar | K00 · Datenmodell |
| `O-K14-2` | `approval` trägt weder Mandantenspalte noch Fremdschlüssel auf das freigegebene Objekt | K00 · Datenmodell |
| `O-K15-1` | Widerruf einer Angebotsanfrage ist nicht modelliert | A. Han |
| `O-K15-2` | Löschverlangen vor Ablauf der handelsrechtlichen Frist ist nicht modelliert | A. Han |
| `O-K15-12` | Die Mindestfrist von sechs Monaten steht ohne tragende Norm | Founder · Betrieb |
| `O-K18-2` | Kein Feld trägt die Vorlagen-Version am erzeugten Ergebnis | Datenmodell · K10 mit K18 |
| `O-K18-5` | `template.id` trägt kein Muster | Datenmodell |
| `O-K18-6` | `editor` und `aenderungsvermerk` sind offen | Datenmodell · K18 |
| `O-K18-7` | Beide Sichten verwenden den Stern statt einer Spaltenliste | Datenmodell |
| `O-K18-9` | Kopplung von Kennungspräfix und `knowledge_group` liegt allein im Serverpfad | Datenmodell |

**Was „Übergabe" heißt, ist offen.** Sie kann das Übergabe-Paket an einen Kunden meinen (K10)
oder die Lieferübergabe an den Auftraggeber. Die Konzepte sagen es nicht. **Wenn sie die
Lieferübergabe meint, gehören diese zwölf zur Frist vor dem 31.08.** — das ist eine Frage an
den Auftraggeber, keine Feststellung.

### Gruppe 4 · Frist **„vor dem ersten Kunden"** — 2 Punkte

| Kennung | Sache | Frist im Wortlaut | Träger |
|---|---|---|---|
| `O-K00-13` | Die Sperre *„kein Versand"* darf erst mit nachgewiesener Migration und bestandenem Negativfall aufgehoben werden | vor erster Kundeneinladung | K03 · K20 |
| `O-K04-8` | Für die Kenntnisnahme führt das Datenmodell keine Spalte | vor dem ersten Kundenprojekt | Founder · Datenmodell |

### Gruppe 5 · Frist **„vor Produktion"** oder **„vor Modellbetrieb"** — 9 Punkte

Alle nach dem 31.08.2026. `O-K15-3` bis `O-K15-10` bilden zusammen die Löschkette (siehe
Abschnitt 3).

`O-K13-8` (SLO/RTO/RPO je kritischem Pfad) · `O-K13-9` (freigegebene Anbieterpfade,
Träger **A. Han**) · `O-K15-3` · `O-K15-4` · `O-K15-6` · `O-K15-9` · `O-K15-10` ·
`O-K18-3` · `O-K18-10`

### Gruppe 6 · **An ein anderes Konzept gebunden** — 24 Punkte

Diese Punkte tragen keine Terminfrist, sondern eine Reihenfolge: *„vor K11"*, *„vor
Tabletop K16"*, *„vor Freigabe K15"*. **Sie werden fällig, wenn das genannte Konzept
drankommt — nicht an einem Datum.**

`O-K01-5` `O-K01-7` `O-K01-8` `O-K01-9` `O-K01-11` `O-K01-14` `O-K01-15` `O-K01-16`
`O-K01-19` · `O-K02-7` · `O-K04-3` · `O-K14-1` `O-K14-3` `O-K14-6` `O-K14-7` `O-K14-8`
`O-K14-9` · `O-K15-7` · `O-K16-3` `O-K16-5` `O-K16-6` `O-K16-7` · `O-K19-8` `O-K19-10`

> **Ein Fund, der eine andere Entscheidung dieser Woche direkt erledigt:** `O-K01-9` und
> `O-K14-6` sind **wortgleich** und lauten beide *„Sitzungsdauer und Abmeldung nach
> Untätigkeit sind nirgends beziffert"* — das ist **B-14** der Schlussrunde. In K03 ist die
> Frage **geschlossen**, und die Werte stehen dort im Wortlaut:
>
> > *„30 Minuten inaktiv, acht Stunden absolut, Code zehn Minuten, fünf Fehlversuche"*
> > — `O-K03-1/3/4`, Zeile 310 der K03 v1.3, Status **geschlossen**
>
> Der Federstrich aus B-14 hat damit einen gemessenen Inhalt. **Zwei Punkte fallen mit ihm.**

### Gruppe 7 · **Ohne Fristangabe** — 23 Punkte

Sie stehen in den drei- und zweispaltigen Tabellen, die **keine Fristspalte führen**.

| Konzept | Kennungen |
|---|---|
| **K23** Test und Abnahme | `O-K23-1` bis `O-K23-6` |
| **K25** Prototyp-Erzeuger | `O-K25-1` `O-K25-2` `O-K25-3` `O-K25-5` `O-K25-6` `O-K25-8` `O-K25-9` |
| **K17** Agenten-Betrieb | `O-K17-10` `O-K17-11` `O-K17-12` `O-K17-13` |
| K03 · K06 · K07 · K08 · K11 | `O-K03-9` `O-K03-10` · `O-K06-11` · `O-K07-7` · `O-K08-11` · `O-K11-11` |

> **Achtung: „ohne Frist" heißt nicht „unwichtig".** In dieser Gruppe stehen **drei** der
> fünf Punkte, die heute etwas sperren (Abschnitt 3). Ihre Tabellen führen schlicht keine
> Fristspalte. **Das ist ein Formunterschied der Konzepte, keine Aussage über Dringlichkeit.**

### Gruppe 8 · **Sonstige Fristen** — 3 Punkte

`O-K00-12` (*vor Automatisierung des Registers*) · `O-K00-14` (*vor erster Nachjustierung*) ·
`O-K21-7` (*offen* — KI-Kompetenz nach Art. 4 der KI-Verordnung, Träger Founder)

**Summe: 2 + 4 + 12 + 2 + 9 + 24 + 23 + 3 = 79.**

---

## 3 · Was heute wirklich sperrt

Das ist die härteste Auskunft dieses Blattes, und sie ist unabhängig von jeder Frist:
**welche Punkte halten heute etwas an?**

### 3.1 · Fünf Punkte tragen im eigenen Text eine Sperre

Gemessen mit `grep -E 'bis dahin|bleibt gesperrt|kein Versand|Freigabekandidat'` über die
79 Zeilen:

| Kennung | Was gesperrt ist | Träger |
|---|---|---|
| `O-K00-13` | **kein Versand**, bis Migration, Unveränderbarkeit der Nachweistabelle und ein bestandener Negativfall nachgewiesen sind | K03 · K20 |
| `O-K03-10` | **kein Versand**, bis Persistenzort und unveränderliche Form des Entscheidungsnachweises aus K03-M23 feststehen | Datenmodell K02/K20 |
| `O-K08-11` | kein Maßstab dafür, wann eine Formulierung zu nah am Original ist | Founder mit K17 |
| `O-K17-13` | **derselbe Punkt, zweites Konzept** — K17-M40 und K17-D16 stellen die Regel auf, ohne prüfbares Maß | Founder mit K08 |
| `O-K18-10` | *„bis dahin kein RELEASED"* — Persistenzfelder, Speicher/Region, RTO, RPO, Aufbewahrung und Löschfristen | Datenmodell · Betrieb |

### 3.2 · Vier Klauseln sperren ausdrücklich, solange ein Punkt offen ist

Gemessen mit `grep -n "Solange O-K"`:

| Klausel | Wortlaut, gekürzt | Hängt an |
|---|---|---|
| **K15-G11** | *„Solange O-K15-2, O-K15-4 bis O-K15-6 und O-K15-9 offen sind, bleibt die automatisierte Entfernung der betroffenen Bestände gesperrt; eine manuelle Umgehung ist unzulässig"* | `O-K15-2` `O-K15-4` `O-K15-6` `O-K15-9` — **vier echte offene**; `O-K15-5` ist entschieden, nur die Ausführung fehlt |
| **K06-G13** | *„Solange O-K06-11 offen ist, bleibt K06 Freigabekandidat"* | `O-K06-11` |
| **K21-G04** | *„Solange O-K21-1 offen ist, ist eine Freigabe über Weg B ein Restrisiko"* | `O-K21-1` — **geschlossen**, die Sperre greift nicht mehr |
| **K23, Gate 14** | *„Solange O-K23-1 offen ist, schlägt es an, wenn …"* | `O-K23-1` (Zielwerte der Lastprüfung) |
| **K05-G12** | *„Solange O-K05-1 und O-K05-2 offen sind, bleibt K05 Freigabekandidat"* | **geschlossen** — die Sperre greift nicht mehr |

### 3.3 · Die Verklemmung in der Löschkette

**K15-G11 sperrt das automatische Löschen. `O-K15-6` erklärt, warum die Kette sich selbst
im Weg steht** — im Wortlaut:

> *„Das Protokoll ist bewusst nur ergänzbar; ein Entfernen ist per Regel unterbunden
> (Eigentümer K02). Damit ist die Klasse BETRIEBSPROTOKOLL im Protokoll nicht vollziehbar.
> Vorrang klären."*

**Zwei gezeichnete Regeln stehen gegeneinander:** Das Protokoll darf nach K02 nicht gelöscht
werden. Nach K15 muss es nach Ablauf der Frist gelöscht werden. **Solange niemand sagt,
welche Regel vorgeht, kann das Löschen weder laufen noch abgeschaltet werden.** Das ist die
*verklemmte Löschkette* aus B-20 der Schlussrunde.

### 3.4 · Die drei Sperren des Anmeldepfads — ein Vorschlag zur Zuordnung

**B-20 nennt „die drei Sperren des Anmeldepfads", ohne sie zu benennen.** Diese Messung
findet im Anmeldepfad genau drei Punkte, die etwas anhalten:

| | Kennung | Sperrt |
|---|---|---|
| **1** | `O-K03-9` | Die befristete Risikoannahme für den E-Mail-Code ohne Phishing-Resistenz ist **noch nicht menschlich freigegeben**; Owner und Migrationsauslöser fehlen |
| **2** | `O-K03-10` | *„bis dahin kein Versand"* — der Entscheidungsnachweis der Einladungsschranke hat keinen Ablageort |
| **3** | `O-K00-13` | *„kein Versand"*, bis Migration, Unveränderbarkeit und ein bestandener Negativfall nachgewiesen sind |

**Die drei sperren auf zweierlei Art**, und der Unterschied ist wichtig: `O-K03-10` und
`O-K00-13` sagen im eigenen Text *„kein Versand"* — sie stehen deshalb in Abschnitt 3.1.
`O-K03-9` sagt das nicht; bei ihm fehlt die **menschliche Freigabe** einer befristeten
Risikoannahme. Beides hält den Anmeldepfad an, aber nur das erste ist maschinell auffindbar.

> **Das ist eine Zuordnung des Harness, kein Zitat.** B-20 nennt keine Kennungen. Ob dieselben
> drei gemeint waren, sagt nur der, der B-20 geschrieben hat.
>
> - [x] **Die drei sind gemeint** — `O-K03-9` · `O-K03-10` · `O-K00-13`
>       · **gez. M. Veil, 16.08.2026** — *„Ich zeichne hiermit alle Entscheidungsvorlagen von
>       M. Veil, gez. 16.8.26"*
> - [ ] **Andere:** ⟨Kennungen⟩

**Warum das dringlich ist, ganz ohne Priorisierung:** Zwei der drei enthalten den Satz *„kein
Versand"*. Der Gegenstand, der am 31.08.2026 abgenommen werden soll, heißt **Teilschnitt bis
zur Anmeldung** — und die Anmeldung beginnt mit einer versandten Einladung.

---

## 4 · Welche den Teilschnitt berühren

**Vorbemerkung, die der Klauselschnitt selbst macht** und die man nicht überlesen darf:

> *„Stichwortverzeichnis, keine Zuordnung. Ein Worttreffer belegt, dass ein Wort an zwei
> Stellen steht — nicht, dass die Klausel zu dieser Scheibe gehört."*
> — `nachweise/klauselschnitt/S1_wortmarken.json`, Feld `vorbemerkung`

**Die Zuordnung selbst ist noch nicht gezeichnet.** Das Blatt `S1_zeichnung.md` sagt es
wörtlich: *„Eine Zeile ohne Haken bleibt offen, auch wenn das Sammelkreuz steht."*

### Wie hier gemessen wurde

Der Klauselschnitt führt **22 Stationen** entlang des dünnen Fadens. Der **Teilschnitt bis
zur Anmeldung** endet nach Blatt 57 bei der Anmeldung — das sind die Stationen an den Ankern
**BS:53 bis BS:56**:

`Mandant` · `Einladungsschranke` · `Einladung` · `Anmeldecode` (mit `E-Mail-Code`, `zweiter
Faktor`, `MFA`/`2FA`) · `Anmeldung` · `Kenntnisnahme`

Diese sechs Stationen berühren **155 Regeln** aus 20 Konzepten. *(Zum Vergleich: die ganze
Scheibe 1 berührt 470.)*

### Das Ergebnis

**7 der 79 offenen Punkte nennen ein Stichwort dieser Stationen:**

| Kennung | Berührung | Frist |
|---|---|---|
| `O-K00-13` | Kundeneinladung, *kein Versand* | vor erster Kundeneinladung |
| `O-K03-9` | Anmeldung, E-Mail-Code, zweiter Faktor | keine Fristspalte |
| `O-K04-8` | Kenntnisnahme | vor dem ersten Kundenprojekt |
| `O-K14-2` | Mandantenspalte an `approval` | vor der Übergabe |
| `O-K15-3` | Aufräumlauf für **Einladungen** außerhalb VERSANDT | vor Produktion |
| `O-K19-8` | erneute **Anmeldung** mitten in Stufe 03 | vor K06 |
| `O-K23-1` | gleichzeitige **Mandanten** in der Lastprüfung | keine Fristspalte |

`O-K03-10` steht nicht in dieser Liste, weil sein Text die Wörter nicht nennt — er heißt
*„Persistenzort und unveränderliche Form des Policy-Entscheidungsnachweises aus K03-M23"*.
**Sachlich gehört er dazu:** er sperrt den Versand der Einladung. **Das zeigt, was die
Stichwortprobe kann und was nicht.**

### Ein Befund zur Zahl 167

Punkt **B-4** der Schlussrunde spricht von *„den 167 Klauseln des Teilschnitts"*. Diese Zahl
ist im Bestand nicht auffindbar:

```
$ grep -rn "167" ~/freiraum-delivery/nachweise/klauselschnitt/*.md
(keine Ausgabe)
```

Der Klauselschnitt nennt **470** berührte Regeln für die ganze Scheibe 1 und **155** für die
Stationen des Teilschnitts. **Woher die 167 stammt, sagt kein Blatt.** Das ist kein
Widerspruch — die drei Zahlen können verschiedene Dinge zählen. Aber wer B-4 auf *„die 167"*
stützt, sollte wissen, dass ihre Herkunft heute nicht nachlesbar ist.

---

## 5 · Welche eindeutig danach kommen

**Sie kosten heute keine Entscheidung.** Drei Mengen, alle gemessen:

| | Zahl | Warum sie warten können |
|---|---|---|
| **Die 24 „nur Ausführung offen"** | 24 | Sachlich entschieden — meist am 30.07. und 31.07.2026 von den Foundern. Es fehlt der Vollzug im Datenmodell oder ein Nachweis, **keine Entscheidung** |
| **Frist „vor Produktion" / „vor Modellbetrieb"** | 9 | Produktivbetrieb ist nach dem 31.08.2026. **Ausnahme:** die vier K15-Punkte in dieser Gruppe halten heute die Löschkette an (Abschnitt 3.3) — die *Sperre* wirkt sofort, auch wenn die *Frist* später liegt |
| **An ein anderes Konzept gebunden** | 24 | Sie werden fällig, wenn das genannte Konzept drankommt. **Ausnahme:** `O-K01-9` und `O-K14-6` fallen mit dem Federstrich aus B-14 (Abschnitt 2, Gruppe 6) |

---

## 6 · Ein Vorschlag für die Ordnung — und worauf er beruht

**Eine Sichtung, die schon priorisiert, nimmt die Entscheidung vorweg.** Deshalb steht hier
keine Rangliste, sondern eine Sortierung nach **drei gemessenen Merkmalen**. Wer die Merkmale
anders gewichtet, bekommt eine andere Ordnung — und das ist zulässig.

### Die drei Merkmale

| | Merkmal | Woran gemessen |
|---|---|---|
| **M1** | **Hält der Punkt heute etwas an?** | Sein Text sagt *„bis dahin …"*, oder eine Klausel sagt *„Solange … offen ist"* |
| **M2** | **Liegt seine Frist vor dem 31.08.2026?** | Fristspalte nennt *„vor dem Bau"* oder *„vor technischer Abnahme"* |
| **M3** | **Berührt er den Teilschnitt bis zur Anmeldung?** | Stichwortprobe gegen die Stationen BS:53–BS:56 |

### Die drei gemessenen Mengen

| | Zahl | Kennungen |
|---|---|---|
| **M1** hält heute etwas an | **11** | `O-K00-13` `O-K03-10` `O-K08-11` `O-K17-13` `O-K18-10` (eigener Text) · `O-K15-2` `O-K15-4` `O-K15-6` `O-K15-9` (K15-G11) · `O-K06-11` (K06-G13) · `O-K23-1` (K23 Gate 14) |
| **M2** Frist vor dem 31.08. | **6** | `O-K04-9` `O-K04-10` · `O-K02-1` `O-K02-9` `O-K04-6` `O-K13-4` |
| **M3** berührt den Teilschnitt | **7** | `O-K00-13` `O-K03-9` `O-K04-8` `O-K14-2` `O-K15-3` `O-K19-8` `O-K23-1` |

### Die Ordnung, die daraus folgt

Jeder Punkt steht in seinem **obersten** zutreffenden Bündel; die Zahlen summieren sich
deshalb auf 79.

| Bündel | Regel | Zahl | Kennungen |
|---|---|---|---|
| **A** | **M1 und M3** — hält etwas an **und** berührt den Abnahmegegenstand | **2** | `O-K00-13` · `O-K23-1` |
| **B** | **M1**, aber nicht M3 | **9** | `O-K03-10` `O-K08-11` `O-K17-13` `O-K18-10` · `O-K15-2` `O-K15-4` `O-K15-6` `O-K15-9` · `O-K06-11` |
| **C** | **M2**, aber weder M1 noch M3 | **6** | `O-K04-9` `O-K04-10` (*vor dem Bau*) · `O-K02-1` `O-K02-9` `O-K04-6` `O-K13-4` (*vor technischer Abnahme*) |
| **D** | **M3** allein | **5** | `O-K03-9` `O-K04-8` `O-K14-2` `O-K15-3` `O-K19-8` |
| **E** | keines der drei | **57** | u. a. die 24 konzeptgebundenen und 11 der 12 *„vor der Übergabe"* |

**2 + 9 + 6 + 5 + 57 = 79.**

### Eine Verschiebung von Hand — sichtbar als Vorschlag, nicht als Messung

**`O-K03-10` steht in B und gehört sachlich in A.** Er sperrt den Versand der Einladung, und
die Einladung ist die erste Station des Teilschnitts. Er fällt nur deshalb aus M3, weil sein
Text die Wörter *Einladung* und *Anmeldung* nicht enthält — er heißt *„Persistenzort und
unveränderliche Form des Policy-Entscheidungsnachweises aus K03-M23"*.

**Der Harness verschiebt ihn nicht selbst.** Er legt die Verschiebung vor:

- [x] **`O-K03-10` rückt nach Bündel A** — dann steht A auf 3 und B auf 8
      · **gez. M. Veil, 16.08.2026**
- [ ] **`O-K03-10` bleibt in B**

### Worauf dieser Vorschlag **nicht** beruht

- **Nicht auf Aufwand.** Die Konzepte führen keine Schätzung. Eine erfundene wäre eine
  Behauptung.
- **Nicht auf Kritikalität.** Die Klauseln tragen heute **kein** Feld dafür — gemessen für
  B-4: **0 von 1231** Klauseln tragen ein Abnahmekriterium, 0 einen Eigentümer.
- **Nicht auf einer Terminzusage.** Die Fristen der Konzepte nennen Ereignisse (*Übergabe*,
  *Produktion*), keine Daten. **Welches Ereignis wann eintritt, entscheidet der Auftraggeber.**

### Die zwei Stellen, an denen der Vorschlag am dünnsten ist

1. **Was „vor der Übergabe" bedeutet.** Zwölf Punkte hängen daran. Meint sie die
   Kundenübergabe (K10) oder die Lieferübergabe an den Auftraggeber? Bei der zweiten Lesart
   rutschen zwölf Punkte aus Bündel E nach Bündel C. **Das ist die größte einzelne Unschärfe
   dieser Sichtung.**
2. **Die Stichwortprobe ist grob.** `O-K03-10` sperrt den Einladungsversand und taucht in M3
   trotzdem nicht auf, weil sein Text die Wörter nicht enthält. **Eine Berührungsprobe über
   Wörter findet nicht alles.**

---

## 7 · Was diese Sichtung nicht tut

- **Sie entscheidet keinen der 79 Punkte.**
- **Sie priorisiert nicht.** Sie sortiert nach drei genannten Merkmalen und legt offen,
  worauf jede Zuordnung beruht.
- **Sie ändert keine Frist und keinen Träger.** Beides steht in den Konzepten und gehört der
  Konzept-Fabrik.
- **Sie passt die Zahl 75 nicht an ihre eigene 79 an.** Beide stehen nebeneinander.
- **Sie behauptet keine Zuordnung zum Teilschnitt.** Der Klauselschnitt ist ein
  Stichwortverzeichnis, und seine Zeilen sind nicht abgehakt.

---

## 8 · Das Zählprogramm — damit jeder nachrechnen kann

Aufruf: `python3 zaehl.py "<Pfad zu concepts-md>"`. Es liest nichts anderes als die
24 Konzeptdateien und schreibt nichts.

```python
import re, os, sys
from collections import Counter
BASE = sys.argv[1]
ROW = re.compile(r'^\|\s*\**\s*(O-K\d\d-\d+)\b')
LEER = {'—', '-', '–', '', '**—**'}
VERMERK = re.compile(r'geschlossen|Geschlossen|[Ee]ntschieden am|Beauftragt am|'
                     r'[Ee]rledigt auf Konzeptebene|Im Review|Geteilt am|Anwaltlich')
offen = Counter(); zu = 0; echt = Counter(); ausf = 0
for fn in sorted(os.listdir(BASE)):
    if not fn.endswith('.md'): continue
    k = re.search(r'_(K\d\d)_', fn).group(1)
    for l in open(os.path.join(BASE, fn), encoding='utf-8'):
        if not ROW.match(l): continue
        c = [x.strip() for x in l.strip().strip('|').split('|')]
        v = bool(VERMERK.search(l))
        if len(c) >= 4:   ist_offen = c[-1] not in LEER          # Fristspalte gefuellt
        elif len(c) == 3: ist_offen = not v                      # keine Fristspalte
        else:             ist_offen = bool(re.search(r'\*\*Offen|^Offen', c[-1]))
        if not ist_offen: zu += 1
        else:
            offen[k] += 1
            if v: ausf += 1
            else: echt[k] += 1
print("offen:", sum(offen.values()), " geschlossen:", zu,
      " davon nur Ausfuehrung offen:", ausf, " echter Entscheidungsbedarf:", sum(echt.values()))
print("echter Entscheidungsbedarf je Konzept:", echt.most_common())
```

**Wo das Programm irren kann, und zwar zu Lasten der Vollständigkeit:** Es erkennt einen
Entscheidungsvermerk am Wortlaut. Eine Zeile, die *„Fachlich entschieden am 31.07.2026"* sagt
und im nächsten Satz *„Offen bleibt allein die Ausführung"*, zählt es als **entschieden** —
sie landet unter den 24, nicht unter den 79. **Wer streng zählt, kommt auf mehr als 79, nie
auf weniger.**

---

## Zeichnung

*Eingetragen auf Weisung des Auftraggebers vom 16.08.2026: „Ich zeichne hiermit alle
Entscheidungsvorlagen von M. Veil, gez. 16.8.26" — gezeichnet ist jeweils die
Handlungsempfehlung. Wo das Blatt keine Empfehlung führt, bleibt das Kästchen leer.*

- [x] **Die Ordnung aus Abschnitt 6 wird übernommen** — Bündel A bis E
      · **gez. M. Veil, 16.08.2026**
- [ ] **Abweichende Ordnung:** ⟨Merkmale und Gewichtung⟩
- [ ] **„Vor der Übergabe" meint die Lieferübergabe** — die zwölf Punkte der Gruppe 3
      rücken nach Bündel C
- [ ] **„Vor der Übergabe" meint die Kundenübergabe** — sie bleiben in Bündel E
      *(beide Kästchen bleiben leer: Abschnitt 6 nennt die Bedeutung von „vor der Übergabe"
      ausdrücklich die größte Unschärfe dieser Sichtung und legt keinen der beiden Wege vor)*
- [x] **Die drei Sperren des Anmeldepfads sind `O-K03-9`, `O-K03-10`, `O-K00-13`**
      *(Kästchen auch in Abschnitt 3.4)* · **gez. M. Veil, 16.08.2026**

| Name | Rolle | Datum | Anmerkung |
|---|---|---|---|
| **M. Veil** | Auftraggeber | **16.08.2026** | allen Handlungsempfehlungen wird gefolgt |
| **A. Han** | für den Auftragnehmer (Nr. 158) | | |
| **Konzept-Fabrik** | für Fristen und Träger der Punkte | | |

---

*Angelegt am 16.08.2026 vom Orchestrator des Coding-Harness zu Punkt B-19 der Schlussrunde,
mit B-20. Jede Zahl in diesem Blatt ist ausgeführt; der Befehl oder das Programm steht
daneben. **Diese Sichtung entscheidet nichts.***
