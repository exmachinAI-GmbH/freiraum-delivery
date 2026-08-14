# Übergabe · Sitzung vom 14.08.2026

> Für die nächste Sitzung. Wer hier weiterliest, braucht den Gesprächsverlauf nicht.

**Fortgeschrieben am 14.08.2026 nach dem Zusammenführen.** Die erste Fassung dieses Textes
entstand am Vormittag und führte drei Anträge als *offen*. Sie sind seither alle in `main`.
Was hier steht, ist der Stand am Ende des Tages.

**Warum dieser Text im Repository liegt und nicht in der Dropbox.** Die früheren
(`HANDOVER_260801.md`, 07.08., AH-7 vom 11.08.) liegen in der Konzept-Fabrik. Die Arbeit
dieses Tages liegt hier — und der Befund des Tages war dreimal derselbe: *eine Vorgabe, die
niemand prüft, wird von nichts durchgesetzt.* Ein Übergabetext, den nur eine Dropbox kennt,
wäre der vierte Fall.

---

## Der Stand in einem Satz

**Fünf Anträge sind in `main`, kein Antrag ist mehr offen** — der Bildschirmvertrag, die
Triage, Tor 3, diese Übergabe und die neue Sprachvorgabe. **Die Sperre für die Abnahme ist
damit nicht kleiner geworden, sondern nur klarer sichtbar:** die Pflegeliste zum
Klauselregister fehlt weiterhin, und ohne sie steht das Register bei 1231 von 1231
Anforderungen ohne Abnahmekriterium.

---

## 1 · Was heute in `main` gekommen ist

„Antrag" ist das deutsche Wort für *Pull Request* — die Bitte, eine Nebenspur in den
gültigen Stand zu übernehmen. Alle fünf: Tor 1a, 1b, 1c und Sperre grün, freigegeben von
A. Han (`@AndrewExma`).

| Antrag | Gegenstand | zusammengeführt (UTC) |
|---|---|---|
| **#11** | Der Bildschirmvertrag kommt in die Lieferung | 10:42 |
| **#12** | Triage der 1231 Anforderungen nach K23-M04 | 10:52 |
| **#13** | Tor 3 hinterlässt einen Nachweis | 11:00 |
| **#14** | diese Übergabe | 12:59 |
| **#15** | Sprachvorgabe: neue Texte ohne IT-Vorkenntnisse verständlich | 13:03 |

### #11 · Der Bildschirmvertrag

K19 Abschnitt 1 nennt `K19_screens.yaml` die *einzige pflegbare Screenquelle*, K19-M01
verlangt den Bezug auf **Kennung und Fassung**. Die Datei lag ausschließlich in der
Konzept-Fabrik. Gemessen vor der Änderung:

```
grep -r 'K19_screens' app/ pruefungen/ werkzeuge/   → 0
grep -n  'version'    app/vorlagen/*.html           → 0
grep -c  'K16-\|K19-' pruefungen/klauseln/*.sh      → 0,0,0,0
```

Jetzt: `schema/K19_screens.yaml` (33 Bildschirme · 105 Aktionen · 89 Serverbefehle ·
0 Platzhalter) mit Prüfsumme und Änderungsregel *keine*; `werkzeuge/k19_screens_lint.py`;
Prüfung in **Tor 1a**; Glied 6 des Testmanifests von `null` auf Datei, Summe, Fassung,
Status und die vier Abbilder. Gemessen: **0 Fehler, 12 Hinweise.**

`ruff.toml` ist neu und trägt eine **benannte Ausnahme für vier Stilregeln**, damit die
Kopie gegen das Original vergleichbar bleibt. Nachgemessen: 413 aktive Regeln vorher wie
nachher — kein gesenkter Prüfwert.

### #12 · Die Triage

K23-M02 sagt ausdrücklich: *„Ein fehlender Test macht den Bauauftrag nicht automatisch
unvollständig."* Verlangt ist die Grenze aus K23-M04 — der Klausel, die für jede
Anforderung ohne Test einen einzelnen Eintrag in der Restrisikoliste fordert. Gemessen:

| | |
|---|---|
| Anforderungen gesamt | 1231 |
| kritisch nach K23-M04 | **405** |
| unbestimmt | 826 |
| von einem Prüffall genannt | 46 |
| **kritisch und ohne Prüffall** | **386** |

386 ist die Arbeitsmenge — nicht 1231. Jeder der 405 Vorschläge trägt seine Belegstelle
(405 von 405). `unbestimmt` heißt ausdrücklich **nicht** *nicht kritisch*. Ergebnis liegt
als `nachweise/klauselregister/triage.json` und `triage.md`.

### #13 · Tor 3

Tor 3 ist die dritte der vier Prüfstufen: eine KI eines *anderen* Anbieters prüft gegen die
Rohbelege. Sie war an vier Stellen beschrieben und an keiner erzwungen. Neu:
`nachweise/fremdreview/` mit README und Vorlage, `werkzeuge/fremdreview.py`,
`pruefungen/tor3.sh`, `.github/workflows/tor3.yml`. **Getrennt von `tore.yml`**, weil die
Harness-Entscheidung C-4 sagt: *einmal je Scheibenabnahme, nicht je Änderung*. Läuft von
Hand oder am Etikett `scheibenabnahme`.

Hereingeholt wird **nicht das Review, sondern sein Nachweis** — `scheibe.md`:73: *„Der
Harness schreibt dieses Review nie selbst."*

### #15 · Die Sprachvorgabe

Auf Weisung des Auftraggebers: **Der Coding-Harness muss für eine Person ohne
IT-Hintergrund steuerbar und verständlich sein.** Das gilt für alles, was **neu** entsteht —
Commit-Nachrichten, Issues, Anträge, Projekttafeln, Agenten und Kommandos, sichtbare Namen,
Fehlermeldungen. **Der Bestand ist ausgenommen und wird nicht nachgeschrieben.**

| Was | Wo |
|---|---|
| die neun Regeln `SPR-1` bis `SPR-9`, Glossar, Probe vor dem Absenden | `CONTRIBUTING.md` |
| Vorlage für Commit-Nachrichten, von `install.sh` eingetragen | `.gitmessage` |
| Vorlagen für Anträge und Issues; leere Issues abgeschaltet | `.github/` |
| Verweis für Agenten | `AGENTS.md` und die vier Dateien unter `.claude/` |
| das umgeschriebene README mit Fehlerbildtabelle und Bedienpfaden im Browser | `README.md` |
| zeichnungsfertiger Absatz für die Anlage „Bauverfahren" | `arbeit/Vorlagen/nachtrag_anlage_sprache.md` |

**Sie bindet den Harness noch nicht.** `CLAUDE.md` ist unangetastet — Änderungen fließen nur
von der gezeichneten Anlage abwärts. Bis der Nachtrag in der Anlage steht und gezeichnet
ist, bindet die Vorgabe die Menschen an der Tastatur, nicht die Verfassung.

---

## 2 · Was in der Konzept-Fabrik gezeichnet wurde

Alle drei am 14.08.2026, je mit **Vermerk zur Form nach F40** — vom Orchestrator
*übertragen, nicht selbsttätig gesetzt*, mit dem Wortlaut der Weisung.

Ablage: `ITERATION_2/entscheidungsvorlagen/260814_nachtrag_k19_k16/`

| Vorlage | Wirkung |
|---|---|
| **N-K19-1** | EN-03a und EN-04a als Kästen, zwei Sitemap- und zwei Zuordnungszeilen. **29 offene Punkte bleiben — als offen mitgezeichnet** |
| **N-K16-1** | Poka-Yoke-Katalog um **P13 bis P37**. O-K16-7 **verkleinert, nicht geschlossen** |
| **CHG-K00-11** | Lint-Gleichstand Fabrik ↔ Lieferung; befristet die Ausnahme in `ruff.toml` |

**K19 v1.3 und K16 v1.3 selbst sind unverändert.** Die Nachträge sind
Entscheidungsvorlagen; sie gehen in die nächste Fassung ein, wenn die Fabrik sie einarbeitet.

---

## 3 · Was als Nächstes zu tun ist

Der Zustand jeder Zeile ist am 14.08.2026 nachgemessen, nicht aus der Vormittagsfassung
übernommen.

### Die eine Sperre

**1 · `nachweise/klauselregister/pflege.json` anlegen.** Gemessen mit `ls`: der Ordner führt
`register.json`, `register.md`, `triage.json`, `triage.md` — **`pflege.json` gibt es nicht**,
obwohl `tore.yml` sie aufruft. Ohne sie fällt Tor 1a in den Zweig *„der mitgeführte Stand
wird geprüft"* zurück, und das Register bleibt bei **1231 von 1231 ohne Abnahmekriterium**.
Nach K23-M02 ist der Bauauftrag bis dahin unvollständig. **Das ist die eigentliche Sperre,
nicht die fehlenden Tests.**

### Der kritische Pfad bis zum 31.08.

2. **Die 405 Vorschläge der Triage prüfen.** Jeder trägt seinen Beleg — Lesearbeit, keine
   Recherche. Grundlage liegt in `nachweise/klauselregister/triage.json`.
3. **Die 386 aufteilen** in *bekommt einen Prüffall* und *bekommt eine
   Annahmeentscheidung mit Träger*.
4. **`nachweise/restrisiken/restrisiken.md` füllen.** Gemessen: die Datei führt genau **eine**
   Kennung, `RR-01`, und die ist geschlossen. K23-M04 verlangt jede Anforderung ohne Test
   einzeln; eine Quote ersetzt die Liste ausdrücklich nicht (Festlegung F34).
5. **Erstes Tor-3-Blatt ablegen.** Gemessen mit `bash pruefungen/tor3.sh`: *„Tor 3: kein
   Fremdreview abgelegt. Zustand: GESPERRT."* Der Ordner `nachweise/fremdreview/` enthält
   README und Vorlage, sonst nichts. Das ist die richtige Meldung — aber eine
   Scheibenabnahme erreicht damit Tor 4 nicht.
6. **Den Nachtrag zur Anlage „Bauverfahren" zeichnen**, damit die Sprachvorgabe die
   Verfassung bindet. Ablauf Schritt für Schritt in
   `arbeit/Vorlagen/nachtrag_anlage_sprache.md`. **Reihenfolge beachten:** erst zeichnen,
   dann neue Prüfsumme rechnen, dann in den Kopf der `CLAUDE.md` eintragen. Dazwischen
   melden `/scheibe` und `/pruefe` *„Verfassung nicht belegt"* — das ist die eingebaute
   Sperre und kein Fehler.

---

## 4 · Womit die nächste Sitzung anfangen sollte

**BEF-E3 ist der wichtigste ungelöste Punkt.** Das Konzept K19 trägt den Stand
**v1.3 Freigegeben**, die Maschinenquelle `K19_screens.yaml` trägt im Kopf
**v1.2 FREIGABEKANDIDAT**.

Es gibt **keine zweite Fassung** der Maschinenquelle — nachgemessen, ein `find` über die
ganze Konzept-Fabrik liefert genau eine Datei. K19 v1.3 benennt in Zeile 13 selbst diese
Datei. Wahrscheinlich ist der **Kopf nicht nachgezogen**, nicht der Inhalt falsch: die Datei
dokumentiert die Zählung vom 05.08. und *„DER NAMENSRAUM IST AM 5.8.2026 GEZEICHNET
(BV-6 Nr. 67, gez. M. Veil)"*.

**Nicht belegt:** `BV-6 Nr. 67` steht **nicht** im K00-Beschluss-Log v1.10. Ob die Zeichnung
auf einem BV-Blatt liegt oder fehlt, war von hier aus nicht zu entscheiden.

Denn träfe die Kopfzeile zu, verwiese K19-M01 — eine freigegebene MUSS-Klausel — auf eine
nicht freigegebene Quelle. Dann stünde jede Berufung darauf auf Sand, auch die in den vier
Vorlagen dieser Lieferung.

---

## 5 · Offene Befunde

Alle in `nachweise/befunde/BEF-E_260814.md`, seit #11 in `main`.

| | Stand |
|---|---|
| **BEF-E1** · Bildschirmvertrag in der Lieferung nicht vorhanden | **behoben** mit #11 |
| **BEF-E2** · `doku/Delivery_Verification_Harness_Plan_v1.0.md`:95 führt *31* Screen-IDs, die Quelle **33** | offen · gehört in eine v1.1 des Plans. Nicht still berichtigt: eine Zahl in einer v1.0 zu ändern hieße, ein datiertes Dokument rückwirkend recht zu geben |
| **BEF-E3** · Konzept K19 = **v1.3 Freigegeben**, Maschinenquelle = **v1.2 FREIGABEKANDIDAT** | offen · von der Fabrik zu entscheiden · siehe Abschnitt 4 |
| **BEF-E4** · zwei Lint-Regelsätze für dieselbe Datei | getragen · befristet über CHG-K00-11 |

---

## 6 · Fallstricke, die man kennen muss

- **Der Zweigschutz verlangt einen aktuellen Zweig** (`strict: true`). Wer einen Antrag
  stellen will, muss ihn vor dem Zusammenführen auf `main` nachziehen.
- **Nachziehen verwirft die Freigabe nicht.** Am 14.08. gemessen bei #14 und #15: nach
  `gh pr update-branch` stand die Freigabe weiterhin auf `APPROVED`. **Die Vormittagsfassung
  dieses Textes sagte pauschal „jeder Commit nach einer Freigabe verwirft sie" — das gilt
  für eigene Commits, nicht für das Nachziehen der Basis.**
- **Eigene Commits nach einer Freigabe verwerfen sie sehr wohl** (`dismiss_stale_reviews`).
  Am 14.08. bei #11 passiert: Freigabe 09:07:46 UTC, Commit 09:11 UTC, Freigabe verworfen,
  Wiederholung 09:56:12 UTC. Erst fertig bauen, dann um Freigabe bitten.
- **Nur `--merge` ist erlaubt.** `squash` und `rebase` sind im Repository abgeschaltet; die
  Historie trägt seit heute Merge-Commits statt der bisherigen Einzeiler mit `(#N)`.
- **Der Zweigschutz greift wirklich.** `enforce_admins: true` — auch `@exmachinai` kommt
  nicht an einer Freigabe von `@AndrewExma` vorbei. Restrisiko RR-01 ist damit geschlossen.
- **`ruff 0.16.1` fährt hier 413 Regeln**, nicht die dokumentierten Standardregeln. Wer Code
  aus der Konzept-Fabrik übernimmt, trifft auf Verstöße, die dort keine sind.
- **Tor 3 läuft nicht bei jedem Antrag** — nur mit Etikett `scheibenabnahme` oder von Hand.
  Wer es sucht und nicht findet, hat nicht das Etikett gesetzt.
- **Kästen in K19 sind 61 Zeichen breit**, die Zugangsmarkenzeile 28, und innerhalb der
  Kästen wird Umschrift statt Umlauten geschrieben.
- **Der Mitgliedschaftsfall in Tor 1c ist seit dem 13.08. GESPERRT** (8 von 9). Übernommen
  aus der Vormittagsfassung, **in dieser Sitzung nicht nachgemessen.**
- **Neu: für Texte gilt `CONTRIBUTING.md`.** Wer einen Commit, ein Issue, einen Antrag oder
  eine Agentenbeschreibung schreibt, liest vorher die neun Regeln. Der Bestand ist
  ausgenommen.

---

## 7 · Zwei Fehler dieser Sitzung, damit sie sich nicht wiederholen

**Erstens: ein Commit nach der Freigabe.** Bei #11 wurde geschoben, nachdem A. Han bereits
freigegeben hatte, und damit die Freigabe verworfen. Der Inhalt des zweiten Commits war
richtig und gehörte dazu — die Reihenfolge war falsch. Vier Minuten Geduld hätten eine
Freigabe gespart.

**Zweitens: ein Entwurf, der ungeprüft plausibel aussah.** Der erste Entwurf des neuen README
enthielt fünf Sachfehler, die erst eine Gegenprüfung mit 13 Agenten aus sechs Richtungen
gefunden hat: eine Aufrufzeile ohne Passwortangabe und damit **nicht ausführbar**
(`aufbau.sh` hielt die Messung vom 10.08. im Kommentar fest), ein `psql`-Fehlschlag, den es
seit dem 10.08. nicht mehr gibt, der fehlende Ordner `app/`, eine überzeichnete Aussage zum
Mailversand (`B2_Abnahmeprotokoll.md` Nr. 6 und 7 sind offen) und ein falsch zitiertes
K23-M18. **Alle fünf waren durch Nachsehen in einer Datei des Repositorys widerlegbar.**
Die Lehre ist die alte: messen statt behaupten, ausführen statt nur lesen.

---

## 8 · Zahlen des Tages

| | |
|---|---|
| Anträge zusammengeführt | **5** · alle Tor 1 grün · keiner mehr offen |
| Zeichnungen in der Konzept-Fabrik | 3 |
| Neue Werkzeuge | `triage.py` · `fremdreview.py` · `k19_screens_lint.py` (übernommen) |
| Neue Läufe | `pruefungen/tor3.sh` · Tor-3-Workflow |
| Neue Befunde | 4 (BEF-E1 bis E4), davon 1 behoben |
| Funde der Gegenprüfung zu #15, die standgehalten haben | **41**, alle eingearbeitet |
| Anforderungen gemessen | 46 von 1231 |
| Anforderungen, die zwingend einen Test brauchen | **386** |
| Einträge in der Restrisikoliste | **1** von mindestens 386 |
| Tor 3 | **GESPERRT** — kein Fremdreview abgelegt |
| Verbleibende Zeit bis zum Endtermin | **17 Tage** (31.08.2026) |
