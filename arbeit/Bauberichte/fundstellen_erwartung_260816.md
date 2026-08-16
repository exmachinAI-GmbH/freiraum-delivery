# Erwartung an `werkzeuge/fundstellen.py`

**Angelegt am 16.08.2026. Geschrieben ohne Kenntnis der Umsetzung.**

Der Verfasser dieses Blattes hat `werkzeuge/fundstellen.py` **nicht gelesen**. Das Werkzeug
entsteht parallel. Der Grund für die Trennung: Wer die Umsetzung kennt, schreibt die
Erwartung auf die Umsetzung statt auf die Aufgabe. Dieses Projekt hat an dieser Stelle am
02.08. und am 15.08.2026 Prüffälle verloren.

**Was dieses Blatt tut.** Es geht die bestätigten Funde des Prüfberichts vom 16.08.2026
einzeln durch und ordnet jeden einer von drei Lagen zu: *muss gefunden werden*, *kann nicht
gefunden werden*, *Grenzfall*. Danach nennt es die Fälle, in denen ein solches Werkzeug
**grün meldet, obwohl etwas falsch ist**. Am Ende steht eine Zahl.

**„Fundstelle" heißt hier:** eine Angabe in einem Steuerungstext, die auf eine bestimmte
Zeile einer bestimmten Datei zeigt — zum Beispiel `` `README.md`:31 ``. Ein Steuerungstext
ist eine Datei, die den Bau anweist: `CLAUDE.md`, alles unter `.claude/`, `README.md`,
`CONTRIBUTING.md`, `install.sh`, `aufbau.sh`, `ruff.toml`.

---

## 0 · Zwei Zahlen des Berichts sind nicht nachrechenbar

Bevor die Liste kommt, zwei Feststellungen zum Bericht selbst. Beide sind gemessen.

**Erstens: „27 bestätigte Funde" lässt sich aus dem Bericht nicht nachzählen.** Der Bericht
führt in seinen Abschnitten A bis D **35** benannte Einträge (A1–A5, B1–B11, C1–C12,
D1–D7). Diese 35 fassen 46 der ursprünglich 47 Meldungen zusammen. Die Zahl 27 stammt aus
der Kopfzeile und zählt Meldungen, nicht Funde. **Dieses Blatt geht deshalb alle 35
benannten Funde durch** — das ist die einzige Liste, die im Bericht wirklich steht.

**Zweitens: „fünfzehn hätte das Werkzeug gefunden" lässt sich ebenfalls nicht nachzählen.**
Abschnitt 5 des Berichts zählt namentlich auf, was das Werkzeug gefunden hätte: die
Bauauftrags-Verweise, die README-Verweise, `scheibe.md:73` in acht Verankerungen,
`config/kanon.yaml`, `aufbau.sh:11–14`, `Migration_260801_tenant.sql`, den relativen
O-PIL-4-Pfad, `arbeit/Bauauftrag_Pilot-Vorbedingungen.md`. Das sind **acht** Funde, nicht
fünfzehn. Die Fünfzehn entsteht nur, wenn man einzelne Fundstellen zählt statt Funde — dann
sind es aber mehr als fünfzehn. **Die Zahl ist aus keiner Liste des Berichts herleitbar.**

Das ist derselbe Fehler, den der Bericht unter C5 an der Abendübergabe rügt: *„Eine
belastbare Gesamtzahl nennt diese Übergabe bewusst nicht — die ‚22' sind aus keinem Blatt
nachrechenbar."* Hier gilt er für den Bericht selbst.

---

## 1 · Die Messung, die alles entscheidet

Vor der Zuordnung steht eine Messung. Sie bestimmt, welche Prüfung das Werkzeug überhaupt
leisten muss.

Ich habe alle Verweise der Form *Datei-Doppelpunkt-Zahl* im Repository eingesammelt und
nachgeschlagen, ob die Datei da ist und ob die Zeile existiert:

```
$ grep -rhoE '[A-Za-z0-9_./-]+\.(md|py|sh|yml|yaml|toml|sql|json):[0-9]+' \
      CLAUDE.md .claude/ README.md CONTRIBUTING.md install.sh aufbau.sh \
      ruff.toml nachweise/ | sort -u | wc -l
  1658          eindeutige Verweise

  Datei im Repo vorhanden:  424
  Datei NICHT im Repo:     1234

$ (jede der 424 Zeilennummern gegen die Länge ihrer Datei gerechnet)
  Zeile existiert:                424
  Zeile ausserhalb der Datei:       0
```

**Von 424 Verweisen, die sich im Repository auflösen lassen, zeigt kein einziger über das
Dateiende hinaus.** Eine Prüfung, die nur fragt *„gibt es die Datei, gibt es die Zeile?"*,
meldet heute **424 mal grün und findet null Funde**. Sie findet auch keinen einzigen der 35
Funde des Berichts.

**Folge:** Der Ankerwort-Vergleich ist keine Zusatzleistung des Werkzeugs. **Er ist das
ganze Werkzeug.** Jeder tote Verweis in diesem Projekt ist tot, weil der *Inhalt*
weitergerutscht ist — nie, weil die Zeile verschwunden wäre. Wer die Ankerprüfung als
zweite Ausbaustufe verschiebt, liefert ein Werkzeug aus, das messbar nichts misst.

---

## 2 · Die vier Schreibweisen — und warum ein Muster zu wenig ist

Der Bericht schlägt vor, das Werkzeug solle *„jedes Muster `pfad:zeile` bzw.
`pfad:von–bis`"* lesen. Gemessen an den Steuerungstexten reicht das nicht. Dort stehen
**vier** verschiedene Schreibweisen nebeneinander:

| Stil | Beispiel aus dem Repo | Vorkommen |
|---|---|---|
| **A · Pfad in Häkchen, Doppelpunkt außerhalb** | `` `README.md`:31 `` · `` `aufbau.sh`:11–14 `` | 17 |
| **B · Pfad blank** | `config/kanon.yaml:346-359` | 2 |
| **C · Zeile ohne Datei** | `(:649)` · `(:337)` — Datei aus dem Satz davor | 6 |
| **D · Rufname statt Dateiname** | `Blatt 26:30` · `Bauauftrag :80–86` · `K23:57` | 44 |

Gemessen:
```
$ grep -rhoE '`[A-Za-z0-9_./-]+`:[0-9]+'  <Steuerungstexte>   →  17    (Stil A)
$ grep -rhoE '[A-Za-z0-9_./-]+\.(md|…):[0-9]+' <dieselben>    →   2    (Stil B)
$ grep -rhoE '\(:[0-9]+' <dieselben>                          →   6    (Stil C)
$ grep -rhoE '(Blatt [0-9]+|Bauauftrag|K23) ?:? ?[0-9]+' …    →  44    (Stil D)
```

**Ein Werkzeug, das nur Stil B liest, findet in den Steuerungstexten zwei Verweise von rund
neunundsechzig.** Beide stehen in derselben Datei (`.claude/agents/pruef-agent.md`). Es
würde grün melden und dabei die README-Verweise (B3), die `scheibe.md:73`-Verankerungen
(C4) und sämtliche Bauauftrags-Verweise (B2) **gar nicht ansehen** — nicht falsch bewerten,
sondern nicht sehen.

Zwei weitere Fallen in derselben Sache:
- **Zwei Sorten Bindestrich.** `` `aufbau.sh`:11–14 `` trägt einen langen Strich (–),
  `config/kanon.yaml:346-359` einen kurzen (-). Wer nur einen kennt, verliert den anderen.
- **Rufnamen brauchen ein Verzeichnis.** „Blatt 26", „Bauauftrag", „K23" sind
  Dokumentnamen, die nirgends im Repo als Dateiname vorkommen. Ohne eine gepflegte
  Zuordnung *Rufname → Datei* sind 44 der 69 Verweise für das Werkzeug unsichtbar.

---

## 3 · Wo das Werkzeug hinsehen soll — und wo nicht

Der Bericht nennt als Lesebereich unter anderem `nachweise/**`. Gemessen ist das ein
Fehlgriff:

```
$ (Verweis-Vorkommen je Quelldatei, absteigend)
  2941  nachweise/herkunft/herkunft.json
  1231  nachweise/klauselregister/register.md
  1231  nachweise/klauselregister/register.json
    48  nachweise/klauselschnitt/S1_bauspur_nachpruefung.md
     9  nachweise/klauselschnitt/S1_zeichnung.md
     4  nachweise/fremdreview/README.md
     2  .claude/agents/pruef-agent.md
```

**5403 der 5468 Vorkommen stehen in maschinell erzeugten Dateien.** Herkunftsgraph und
Klauselregister sind erzeugte Sichten; sie haben mit `werkzeuge/herkunft.py` und
`werkzeuge/klauselregister.py` bereits ihr eigenes Werkzeug, das sie nachrechnet. Sie ein
zweites Mal zu prüfen, ertränkt die 69 von Hand geschriebenen Verweise in Rauschen.

**Erwartung:** Das Werkzeug liest die von Hand geschriebenen Steuerungstexte und die von
Hand geführten `README.md` unter `nachweise/`. Die erzeugten Dateien
(`register.json`, `register.md`, `herkunft.json`) bleiben ausgenommen, und die Ausnahme
steht mit Begründung im Werkzeug.

---

## 4 · Die Zuordnung aller 35 Funde

**Lesehilfe der Spalte „Lage":**

| Zeichen | Bedeutung |
|---|---|
| **MUSS** | eine tote oder verschobene Fundstelle im Repo. Das Werkzeug muss sie finden. |
| **KANN NICHT** | eine Zustandsbehauptung ohne Bezug auf Datei und Zeile. Kein Nachschlagen kann sie widerlegen. |
| **GRENZFALL** | findbar nur unter einer benannten zusätzlichen Bedingung. Die Bedingung steht dabei. |

---

### A · Hält den Bau an

| Fund | Stelle | Lage | Begründung — selbst nachgeprüft |
|---|---|---|---|
| **A1** | `app/` fehlt in allen Schreib- und Lesegrenzen | **KANN NICHT** | Gemessen: `grep -rn 'app/' .claude/ CLAUDE.md` → **keine Treffer**. Der Fund ist ein **fehlender Eintrag in einer Liste**. Ein Werkzeug, das Verweise nachschlägt, sieht nur, was dasteht — nie, was fehlt. |
| **A2** | `scheibe.md` Schritt 9: „die Anlage existiert nicht" | **KANN NICHT** | Zustandsbehauptung. Gemessen im Arbeitsbaum auf `scheibe.md`:79–80. Sie nennt keine Datei und keine Zeile. Bemerkenswert: `./install.sh --pruefsumme` widerlegt sie seit dem 07.08.2026 — aber das ist ein anderes Werkzeug. |
| **A3** | Schritt 2 schickt 1231 Klauseln an einen Adressaten, den es nicht gibt | **KANN NICHT** | Zustandsbehauptung über den Inhalt von `register.json`. Der einzige Verweis im Satz (K23-M02, K23:57) ist laut Bericht **richtig**. |
| **A4** | `` `aufbau.sh`:11–14 `` trägt die zitierte Aussage nicht | **MUSS** | Gemessen: `aufbau.sh`:11–14 sagt „nur Datenbank". Der Satz „Das hier ist eine PRUEFumgebung, kein Pilotlauf" steht auf **:20**. Ankerwort „Pilotlauf" fehlt im angegebenen Bereich → rot. **Aber nur die halbe Wahrheit:** der schwerere Teil des Fundes — `./aufbau.sh` baut die falsche Datenbank — ist eine Verhaltensbehauptung und bleibt unentdeckt. |
| **A5** | Übergabe hält einen grünen Tor-1-Lauf für ungemessen | **KANN NICHT** | Zustandsbehauptung über einen Lauf bei GitHub. Nennt eine Lauf-Nummer, keine Datei-Zeile. Liegt außerhalb jedes Dateisystems. |

---

### B · Lässt eine Prüfung aus

| Fund | Stelle | Lage | Begründung — selbst nachgeprüft |
|---|---|---|---|
| **B1** | Etikett `scheibenabnahme` existiert nicht | **KANN NICHT** | Zustandsbehauptung über die Etikettenliste bei GitHub. Kein Dateibezug. |
| **B2** | Alle Bauauftrags-Verweise zeigen auf die abgelöste Fassung | **GRENZFALL** | Der Bericht zählt diesen Fund zu seinen fünfzehn. **Gemessen geht das heute nicht:** `ls 03_N5*` → kein Treffer, `echo "[${FREIRAUM_KONZEPTE:-}]"` → `[]`, und eine Suche über sechs Verzeichnisebenen findet die Datei nirgends. Dazu kommt Stil C und D: die Verweise heißen `(:649)` und `Bauauftrag :80–86`, tragen also **gar keinen Dateinamen**. **Findbar nur, wenn dreierlei zutrifft:** die Konzept-Fabrik ist im Prüflauf eingehängt, das Werkzeug kennt den Rufnamen „Bauauftrag", und es liest Stil C und D. Keine der drei Bedingungen ist heute erfüllt. |
| **B3** | Fünf README-Fundstellen zeigen ins Leere | **MUSS** | **Der Musterfall.** Gemessen: `README.md` hat 265 Zeilen, die Zeilen 30–35 tragen heute Begriffserklärungen zu Branch und Pull Request. `CLAUDE.md`:131, :180, :182, :183, :184 verweisen dorthin. Datei da, Zeile da, Inhalt vertauscht — genau das, was nur ein Ankerwort fängt. |
| **B4** | `pruefe.md`:24 „Zuordnung existiert noch nicht" | **KANN NICHT** | Verneinte Zustandsbehauptung. Gemessen: `ls nachweise/klauselschnitt/` → fünf Dateien. Der Satz nennt keinen Pfad, den man nachschlagen könnte. |
| **B5** | Tor-3-Zeile verschweigt den eigenen Nachweisteil | **KANN NICHT** | Gemessen: `CLAUDE.md`:75, Spalte „Werkzeug" trägt nur „außerhalb dieses Harness". Ein fehlender Verweis ist kein toter Verweis. |
| **B6** | Vier Nachweise, vier Werkzeuge — genannt wird eines | **KANN NICHT** | Gemessen: `CLAUDE.md`:166 nennt `werkzeuge/klauselregister.py` — die Datei **gibt es**, der Verweis ist gültig. Falsch ist die Vollständigkeit. Ein Werkzeug, das Verweise nachschlägt, meldet hier **grün** — zu Recht und trotzdem falsch. |
| **B7** | `config/kanon.yaml` gibt es in diesem Repo nicht | **MUSS** | Gemessen: `ls -d config` → *No such file or directory*; `find . -name 'kanon.yaml'` → leer. Vier Fundstellen: `pruef-agent.md`:6 und :13, `bau-agent.md`:68, `CLAUDE.md`:114. **Der einzige Fund im Bericht, den schon die reine Dateiprüfung fängt.** Achtung Stil: `CLAUDE.md`:114 schreibt `` `kanon.yaml`:346–359 `` — ohne Verzeichnis und mit langem Strich. |
| **B8** | Repo wird als privat geführt und ist öffentlich | **KANN NICHT** | Zustandsbehauptung über GitHub. Gemessen bestätigt (`restrisiken.md`:83 trägt weiterhin „privat"). |
| **B9** | Befundindex führt drei Blätter, es liegen vier | **KANN NICHT** | Gemessen: `nachweise/befunde/README.md`:8–10 nennt drei Dateien, **alle drei existieren**. Im Ordner liegen vier. Jeder genannte Verweis ist gültig; falsch ist das Fehlen des vierten. Grün, obwohl falsch. |
| **B10** | Glied 6 ist nicht mehr leer | **KANN NICHT** | Zustandsbehauptung über den Inhalt einer erzeugten JSON-Datei. Gemessen: `manifeste/README.md`:33 trägt weiterhin „bei Tor 1c **leer**". |
| **B11** | B3 wird ein Dossier zugeschrieben, das es nie gab | **KANN NICHT** | Gemessen: `vorbedingungen/README.md`:9 sagt „Dossier", `ls …/B3_testdomaene/` → nur `README.md`. **Die Behauptung nennt kein Dokument beim Namen.** Es gibt nichts nachzuschlagen. |

---

### C · Irreführend

| Fund | Stelle | Lage | Begründung — selbst nachgeprüft |
|---|---|---|---|
| **C1** | Gegenzeichnung des Bauauftrags steht nicht mehr aus | **KANN NICHT** | Gemessen: `CLAUDE.md`:151 trägt weiterhin „Die Gegenzeichnung des Auftragnehmers steht aus". Sie nennt das Zeichnungsblatt als **Dateinamen ohne Zeile**, und die Datei liegt außerhalb des Repos. Zustandsbehauptung. |
| **C2** | Ein erfundenes Zitat trägt die ganze Auslöserregel | **KANN NICHT** | **Der wichtigste Nichtfund dieses Blattes.** Gemessen: `grep -rn 'bei jedem Commit' . --exclude-dir=.git` → **nur** `scheibe.md`:120 und `uebergabe.md`:60. Der Satz steht nirgendwo sonst. **Und er trägt keine Fundstelle:** die Quellenangabe lautet „C-4" — eine Kennung, kein Datei-Zeile-Paar. Es gibt buchstäblich nichts nachzuschlagen. Siehe Abschnitt 5. |
| **C3** | „`schema/` gibt es im Repo heute nicht" | **GRENZFALL** | Gemessen: `bau-agent.md`:47 sagt es, `ls schema/` liefert fünf Dateien. **Der Pfad ist genannt** — ein Werkzeug schlägt ihn also nach und findet ihn. Nur: es findet ihn und meldet **grün**, während der Satz daneben behauptet, es gebe ihn nicht. **Findbar nur, wenn das Werkzeug die Verneinung liest** — also die Regel „ein Pfad, der im Satz als nicht vorhanden bezeichnet wird, muss fehlen". Das ist eine andere Regel als das Nachschlagen. |
| **C4** | `scheibe.md`:73 in acht Verankerungen | **MUSS** | **Der ergiebigste Einzelfall: acht Fundstellen auf einen Schlag.** Gemessen im Arbeitsbaum: `scheibe.md`:73 trägt „Fehlgeschlagen und gesperrt tragen Befund, Verantwortlichen und Frist." Der zitierte Satz „Der Harness schreibt dieses Review **nie selbst**" steht auf **:87**. Jede der acht Stellen führt das Zitat als Ankerwort mit — die Prüfung ist eindeutig. **Zusatzbefund:** der Bericht nennt für `main` die Zeile 82, im Arbeitsbaum ist es 87. Dieselbe Aussage hat je nach Zweig eine andere Nummer. Das ist der Beleg dafür, dass die Korrekturempfehlung des Berichts richtig ist: **auf „Schritt 10" umstellen, nicht auf eine neue Zahl.** |
| **C5** | Abendübergabe an fünf Stellen überholt | **KANN NICHT** | Fünf Zustandsbehauptungen über Zeichnungen, Dateizahlen und Regelzahlen. Kein Datei-Zeile-Verweis. |
| **C6** | Fassung auf `main` ist überholt und hat keinen Nachfolger | **KANN NICHT** | Zustandsbehauptung über den Änderungsstand und die Antragslage. |
| **C7** | B1 und B2 stehen auf „noch nicht begonnen" und sind abgenommen | **KANN NICHT** | Gemessen: `B1_installation/README.md`:3 und `B2_mailversand/README.md`:6 tragen weiterhin „**Status:** noch nicht begonnen." Das Gegenbeweisstück liegt im **selben Ordner** — aber der Text **nennt es nicht**. Ohne Nennung kein Nachschlagen. |
| **C8** | `install.sh` erklärt den Ablageort für ungezeichnet | **KANN NICHT** | Gemessen: `install.sh`:13–14 trägt weiterhin „ACHTUNG: … NICHT gezeichnet." Widerlegt wird das durch ein Zeichnungsblatt außerhalb des Repos, das der Satz nicht nennt. |
| **C9** | README-Karte zeigt drei Bestände nicht | **KANN NICHT** | Gemessen: `README.md`:159 „Drei Ordner sind Kopien" — `ls seeds/` zeigt vier Dateien, darunter `Seed_Vorpruefung_K04.sql` **ohne** `.sha256`. Alle genannten Ordner existieren. Falsch sind eine Zahl und eine Einordnung. |
| **C10** | `Migration_260801_tenant.sql` gibt es nicht | **GRENZFALL** | Gemessen: `nachweise/pilot/README.md`:14 nennt sie, `ls migrations/` kennt sie nicht — die Datei heißt `migrations/_vorlaeufer/260801_tenant.sql`. **Aber der Verweis trägt keine Zeilennummer.** Nach der im Bericht beschriebenen Bauart (`pfad:zeile` bzw. `pfad:von–bis`) wird er **nicht erfasst**. Der Bericht zählt ihn trotzdem zu seinen fünfzehn. **Findbar nur, wenn der Umfang von „Pfad mit Zeile" auf „Pfad" erweitert wird.** |
| **C11** | Repo-Pfad ist veraltet — aber er klont | **KANN NICHT** | Eine Adresse bei GitHub, kein Dateipfad. |
| **C12** | Beide Mitarbeiter sind Admin | **KANN NICHT** | Gemessen: `restrisiken.md`:89 trägt weiterhin „`AndrewExma` (push)". Zustandsbehauptung über Rechte bei GitHub. |

---

### D · Gering

| Fund | Stelle | Lage | Begründung — selbst nachgeprüft |
|---|---|---|---|
| **D1** | `aufbau.sh`:16–18 beschreibt weniger als die CI lädt | **KANN NICHT** | Gemessen: `tore.yml`:292 lädt zusätzlich `seeds/*.sql`, `aufbau.sh`:76–79 nicht. Eine unvollständige Beschreibung, kein toter Verweis. |
| **D2** | `restrisiken.md`:102–121 sagt „weiterhin nein" | **KANN NICHT** | Zustandsbehauptung, historisch gerahmt („Wie es dahin kam — Nachtrag 09.08.2026", gemessen auf :102). |
| **D3** | `restrisiken.md`:132 „mit dem ersten Manifest" | **KANN NICHT** | Zustandsbehauptung über den Bestand in `nachweise/manifeste/`. Gemessen: zwei Manifeste liegen vor. |
| **D4** | `herkunft.md`:27–28 Wenn-Dann-Satz | **KANN NICHT** | Gemessen: `herkunft.md`:17 steht heute auf **30**, der Satz auf :27 ist ausdrücklich bedingt („Solange die Zeile … auf 0 steht"). Keine Behauptung, kein Verweis. |
| **D5** | `ruff.toml`:8–11 — CODEOWNERS führt `/ruff.toml` nicht | **KANN NICHT** | Gemessen: `grep -n 'ruff' .github/CODEOWNERS` → keine Ausgabe. Der Text sagt „gehört in dieselbe Aufmerksamkeit" — eine Soll-Aussage ohne Fundstelle. |
| **D6** | `arbeit/Bauauftrag_Pilot-Vorbedingungen.md` hat es nie gegeben | **GRENZFALL** | Gemessen: drei Fundstellen (`B1_installation/README.md`:3, `B2_mailversand/README.md`:6, `B3_testdomaene/README.md`:3), `ls arbeit/` → nur `Bauberichte`, `Plaene`, `Vorlagen`. **Pfad ohne Zeilennummer**, dafür mit Abschnittsangabe („Abschnitt B1"). Gleiche Bedingung wie C10. |
| **D7** | Relativer Pfad `../../../02_AGENT_HARNESS_KONZEPTE/…` | **GRENZFALL** | Gemessen: `B3_testdomaene/README.md`:7; drei Ebenen aufwärts landet in der Repo-Wurzel, dort gibt es `02_AGENT_HARNESS_KONZEPTE` nicht. **Pfad ohne Zeilennummer**, dazu die Extrahürde, dass `../` gegen den Ort der **zitierenden** Datei aufgelöst werden muss, nicht gegen die Repo-Wurzel. Gemessen: bei Auflösung gegen die Repo-Wurzel gehen **null** zusätzliche Verweise auf. |

---

## 5 · Was dieses Werkzeug grundsätzlich nicht findet

**Dies ist der wichtigste Abschnitt dieses Blattes.** Ein Werkzeug, dessen Grenzen niemand
aufgeschrieben hat, erzeugt falsche Sicherheit — und in Tor 1a erzeugt es ein grünes
Häkchen, das aussieht wie ein Beweis.

### 5.1 · Die Zeile lebt, ihr Inhalt ist ausgetauscht — und der Anker passt zufällig noch

Das Ankerwort ist die einzige Prüfung, die trägt (Abschnitt 1). Sie ist zugleich die
schwächste Stelle. Ein Anker ist ein einzelnes Wort oder ein kurzer Ausdruck. Je häufiger
er im Zieldokument vorkommt, desto wahrscheinlicher trifft er nach einer Verschiebung
wieder. In diesem Projekt ist das kein Gedankenspiel: `README.md` ist am 14.08.2026 von 84
auf 265 Zeilen gewachsen. Wörter wie „Prüfsumme", „Migration", „Mandant" oder „Nachweis"
stehen dort dutzendfach. Ein Anker „Prüfsumme" trifft nach jeder Umstellung irgendwo.

**Erwartung:** Der Anker ist der **Satz**, den der Steuerungstext dem Ziel zuschreibt, nicht
ein Stichwort daraus. Und das Werkzeug meldet **nicht nur** „gefunden", sondern **auf
welcher Zeile** — dann fällt ein Treffer sechzig Zeilen weiter unten auf.

### 5.2 · Ein Verweis ohne Zeilennummer

`CLAUDE.md`:166 sagt „Erzeugt von `werkzeuge/klauselregister.py`". Die Datei gibt es. Der
Verweis ist gültig. Die Aussage ist trotzdem falsch — es sind vier Werkzeuge (Fund B6).
Ein Nachschlagewerkzeug meldet hier grün, und es hat recht damit.

Dasselbe bei B9: `nachweise/befunde/README.md` nennt drei Befundblätter, alle drei
existieren, ein viertes fehlt in der Aufzählung. **Jeder Verweis stimmt, die Liste nicht.**

**Erwartung:** Das Werkzeug schreibt in seinen Bericht, wie viele der geprüften Angaben
**keine Zeilennummer** tragen. Diese Zahl ist die Größe des blinden Flecks und gehört in
jeden Lauf.

### 5.3 · Ein Verweis auf eine Datei außerhalb des Repos

Gemessen: **1234 von 1658** Verweisen zeigen auf Dateien, die im Repository nicht liegen —
knapp drei Viertel. Der Bauauftrag, Blatt 11, Blatt 26, `config/kanon.yaml`, die
K18-Wissensstruktur. Und `FREIRAUM_KONZEPTE` ist auf dieser Maschine **leer**.

Der Bericht schlägt vor, in diesem Fall `gesperrt` statt `bestanden` zu melden. Das ist
richtig gedacht und hat eine Folge, die der Bericht nicht ausspricht: **wenn `gesperrt` in
Tor 1a rot bedeutet, ist Tor 1a ab dem ersten Tag dauerhaft rot** — nicht wegen eines
Fundes, sondern weil die Konzept-Fabrik im Prüflauf nicht eingehängt ist. Und ein Tor, das
immer rot ist, wird abgeschaltet.

**Erwartung:** Drei Ergebnisse statt zwei, mit getrennter Zählung im Bericht:
`bestanden` · `tot` (sperrt) · `nicht nachprüfbar` (sperrt nicht, wird gezählt). Die dritte
Zahl steht im Bericht ganz oben. **Steigt sie, ist das selbst ein Befund** — dann sind
Behauptungen aus dem prüfbaren Bereich in den unprüfbaren gewandert.

### 5.4 · Ein Zitat, das nie irgendwo stand

**Die Antwort auf die Frage im Auftrag lautet: nein. Ein Fundstellenprüfer kann C2 nicht
finden — auch nicht im Ansatz.**

Der Satz *„Ein Gate, das bei jedem Commit anschlägt, wird umgangen oder billig erfüllt"*
steht in `scheibe.md`:120 und `uebergabe.md`:60. Gemessen existiert er sonst nirgends:

```
$ grep -rn 'bei jedem Commit' . --exclude-dir=.git --exclude-dir=.venv
  .claude/commands/scheibe.md:120
  .claude/commands/uebergabe.md:60
```

Drei Gründe, warum kein Nachschlagen hilft:

1. **Es gibt keine Fundstelle.** Die Quellenangabe ist „C-4" — eine Kennung, kein
   Datei-Zeile-Paar. Das Werkzeug bekommt nichts zum Aufschlagen.
2. **Selbst mit Fundstelle würde es nicht greifen.** Stünde dort „Blatt 26:30", prüfte das
   Werkzeug ein *Ankerwort* an dieser Zeile — und Blatt 26:30 handelt tatsächlich von C-4.
   Ein Anker wie „C-4" oder „Fremdmodell" träfe. **Grün, und das Zitat bleibt erfunden.**
3. **Die Quelle liegt außerhalb.** Blatt 26 ist heute nicht erreichbar (Abschnitt 5.3).

**Ein erfundenes Zitat ist die gefährlichste Sorte Fehler in diesem Projekt** — es sieht
belastbarer aus als eine Behauptung, weil es Anführungszeichen trägt, und es trägt hier
eine ganze Auslöserregel. Es braucht eine **eigene Regel**, nicht dieses Werkzeug:

> **Jedes Zitat in Anführungszeichen trägt Datei und Zeile, und der zitierte Text muss dort
> zeichengleich stehen.** Wo das nicht geht, wird es nicht als Zitat geschrieben, sondern
> als eigene Erwägung gekennzeichnet.

Diese Regel ist mit demselben Werkzeug messbar — aber nur, wenn sie **vorher** in die
Steuerungstexte geschrieben wird. Solange Zitate ohne Fundstelle erlaubt sind, ist ein
Fundstellenprüfer gegen sie machtlos.

### 5.5 · Was fehlt, wird nie geprüft

**Neun der fünfunddreißig Funde sind Auslassungen**, nicht Fehler: A1 (`app/` fehlt in drei
Listen), B5 (leere Spalte), B6 (drei von vier Werkzeugen fehlen), B9 (ein Blatt fehlt), B11
(kein Dokument genannt), C7 (Protokoll nicht genannt), C9 (drei Bestände fehlen), D1, D5.

Ein Werkzeug prüft, was dasteht. **Es kann nicht wissen, was dastehen müsste.** Das ist
keine Schwäche der Umsetzung, sondern der Aufgabe. Wer erwartet, dass ein Fundstellenprüfer
A1 findet — den schwersten Fund des Berichts —, erwartet das Falsche.

### 5.6 · Die Zeilennummer ist zweigabhängig

Gemessen: der Satz „Der Harness schreibt dieses Review **nie selbst**" steht auf `main` in
Zeile 82 und im Arbeitsbaum in Zeile 87. **Dieselbe Aussage, zwei Nummern.** Ein Werkzeug
misst immer nur den ausgecheckten Stand. Eine Fundstelle, die auf `main` stimmt, kann im
Antrag rot sein — und umgekehrt.

**Erwartung:** Das Werkzeug nennt in seinem Bericht den geprüften Änderungsstand, damit ein
Fund einem Stand zugeordnet werden kann. Und die Steuerungstexte hören auf, in
`.claude/commands/` mit Zeilennummern zu verweisen: dort trägt **„Schritt 10"** und nicht
**„:73"**. Genau das empfiehlt der Bericht unter C4 bereits.

### 5.7 · Grün heißt nicht richtig

Die Zusammenfassung dieses Abschnitts in einem Satz:

> **Ein grüner Fundstellenlauf beweist, dass die Verweise dorthin zeigen, wo sie hinzeigen
> sollen. Er beweist nichts über den Inhalt, nichts über Vollständigkeit, nichts über
> Zitate und nichts über die drei Viertel der Verweise, die aus dem Repo hinausführen.**

Dieser Satz gehört in die Ausgabe des Werkzeugs selbst, nicht nur in dieses Blatt. Sonst
wird das Häkchen gelesen, als hätte jemand die Steuerungstexte geprüft.

---

## 6 · Die Zahl

**Vier Funde muss das Werkzeug finden: A4, B3, B7, C4.**

Zusammen sind das **siebzehn einzelne Fundstellen**: eine in `aufbau.sh` (A4), fünf im
README-Bezug (B3), vier auf `config/kanon.yaml` (B7), acht auf `scheibe.md`:73 (C4).

**Fünf weitere sind Grenzfälle** — findbar nur unter einer benannten Bedingung:

| Fund | Bedingung, unter der er findbar wird |
|---|---|
| **B2** | Konzept-Fabrik im Prüflauf eingehängt **und** Rufnamen-Zuordnung **und** Stil C+D gelesen |
| **C3** | Werkzeug liest die Verneinung („gibt es nicht") und prüft auf Abwesenheit |
| **C10** | Umfang von „Pfad mit Zeile" auf „Pfad" erweitert |
| **D6** | dieselbe Erweiterung |
| **D7** | dieselbe Erweiterung, dazu Auflösung von `../` gegen die zitierende Datei |

**Sechsundzwanzig Funde kann es grundsätzlich nicht finden.**

Damit gilt: **vier sicher, höchstens neun im besten Ausbau, nie fünfzehn.**

**Eine Empfehlung folgt daraus unmittelbar.** Drei der fünf Grenzfälle (C10, D6, D7) hängen
an derselben, sehr kleinen Erweiterung: **auch Pfade ohne Zeilennummer nachschlagen.** Das
kostet wenig und hebt die sichere Ausbeute von vier auf sieben. C3 hängt an einer zweiten,
ebenfalls kleinen Regel: **wo ein Text sagt, etwas gebe es nicht, muss es fehlen.** Damit
sind es acht. Nur B2 bleibt außer Reichweite, solange die Konzept-Fabrik im Prüflauf nicht
erreichbar ist.

---

## 7 · Die Prüfliste für die Abnahme des Werkzeugs

Zwölf Fragen. Wer das Werkzeug abnimmt, beantwortet sie mit einer Messung, nicht mit einem
Satz.

| # | Frage | Erwartete Antwort |
|---|---|---|
| 1 | Findet es B3 — die fünf README-Fundstellen? | ja, alle fünf |
| 2 | Findet es C4 — `scheibe.md`:73 an allen acht Stellen? | ja, alle acht |
| 3 | Findet es B7 — `config/kanon.yaml` an allen vier Stellen? | ja, alle vier |
| 4 | Findet es A4 — `aufbau.sh`:11–14? | ja |
| 5 | Liest es Stil A (`` `datei`:zeile ``)? | ja — sonst sieht es 17 von 69 Verweisen nicht |
| 6 | Liest es beide Bindestrich-Arten (– und -)? | ja |
| 7 | Was tut es bei einem Verweis ohne Zeilennummer? | zählt ihn und weist ihn aus |
| 8 | Was tut es bei einer Datei außerhalb des Repos? | `nicht nachprüfbar`, gezählt, sperrt nicht |
| 9 | Nennt der Bericht die Zahl der nicht nachprüfbaren Angaben? | ja, ganz oben |
| 10 | Prüft es `register.json` und `herkunft.json` mit? | **nein**, mit Begründung im Werkzeug |
| 11 | Meldet es bei einem Fund die gefundene Zeile des Ankers? | ja — sonst fällt 5.1 nicht auf |
| 12 | Ist ein Lauf mit einer toten Fundstelle rot, nicht `::warning::`? | ja |

Frage 12 ist die einzige, bei der ein Nein das ganze Werkzeug wertlos macht. Der
Herkunftsgraph auf `main` ist der Beleg im eigenen Haus: er wird bei jedem Lauf nachgerechnet
und verglichen, meldet aber nur `::warning::` (`tore.yml`:147) — und ist deshalb
nachweislich veraltet.

---

*Angelegt am 16.08.2026. Alle Messungen in diesem Blatt sind gegen den Arbeitsbaum unter
`/Users/mveil/freiraum-delivery` gefahren, nicht gegen `main`; wo der Bericht `main`-Zeilen
nennt, ist das vermerkt. `werkzeuge/fundstellen.py` wurde für dieses Blatt nicht gelesen.*
