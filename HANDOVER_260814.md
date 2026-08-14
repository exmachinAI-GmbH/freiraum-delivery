# Übergabe · Sitzung vom 14.08.2026

> Für die nächste Sitzung. Wer hier weiterliest, braucht den Gesprächsverlauf nicht.

**Warum dieser Handover im Repo liegt und nicht in der Dropbox.** Die früheren
(`HANDOVER_260801.md`, 07.08., AH-7 vom 11.08.) liegen in der Konzept-Fabrik. Die Arbeit
dieses Tages liegt hier — und der Befund des Tages war dreimal derselbe: *eine Vorgabe, die
niemand prüft, wird von nichts durchgesetzt.* Ein Übergabetext, den nur eine Dropbox kennt,
wäre der vierte Fall.

---

## Der Stand in einem Satz

**Drei Lücken zwischen Konzept und Lieferung sind geschlossen** — der UI-Vertrag wird
gemessen, die Testpflicht hat eine Zahl, Tor 3 hinterlässt einen Nachweis. **Drei Pull
Requests sind grün und warten auf die Freigabe von A. Han**; ohne sie ist nichts davon in
`main`.

---

## 1 · Die drei offenen Pull Requests

Alle drei: Tor 1a, 1b, 1c und Sperre **grün**. Alle drei: `REVIEW_REQUIRED`. Alle drei gehen
von `main` aus und sind voneinander unabhängig.

| PR | Zweig | Gegenstand |
|---|---|---|
| **#11** | `uebernahme/k19-ui-vertrag` | Der UI-Vertrag kommt in die Lieferung |
| **#12** | `triage/k23-m04` | Triage der 1231 Klauseln nach K23-M04 |
| **#13** | `tor3/institution` | Tor 3 hinterlässt einen Nachweis |

**Zu #11 ist eine Freigabe verfallen.** `@AndrewExma` hat am 14.08. um **09:07:46 UTC**
freigegeben; um **09:11:00** kam ein zweiter Commit (BEF-E3 geschärft, BEF-E4 aufgenommen),
und `dismiss_stale_reviews` hat die Freigabe verworfen. Das ist die Schranke bei der Arbeit,
nicht gegen sie — sie hätte sonst Inhalt gedeckt, den sie nicht gesehen hatte. **Sie ist zu
wiederholen.** Lehre für die nächste Sitzung: erst alle Commits, dann zum Review.

### #11 · Der UI-Vertrag

K19 Abschn. 1 nennt `K19_screens.yaml` die *einzige pflegbare Screenquelle*, K19-M01 verlangt
den Bezug auf **Kennung und Fassung**. Die Datei lag ausschließlich in der Fabrik. Gemessen:

```
grep -r 'K19_screens' app/ pruefungen/ werkzeuge/   → 0
grep -n  'version'    app/vorlagen/*.html           → 0
grep -c  'K16-\|K19-' pruefungen/klauseln/*.sh      → 0,0,0,0
```

Jetzt: `schema/K19_screens.yaml` (33 Bildschirme · 105 Aktionen · 89 Serverbefehle ·
0 Platzhalter) mit `.sha256` und Änderungsregel *keine*; `werkzeuge/k19_screens_lint.py` aus
der Fabrik, geändert nur in Kopfdoku und Vorgabepfad; Prüfung in **Tor 1a**; Glied 6 des
Testmanifests von `null` auf Datei, Summe, Fassung, Status und die vier Abbilder. Gemessen:
**0 Fehler, 12 Hinweise.**

`ruff.toml` ist neu und die Stelle, die im Review Aufmerksamkeit braucht: eine **benannte
Ausnahme für vier Stilregeln**, damit die Kopie gegen das Original vergleichbar bleibt.
Nachgemessen 413 aktive Regeln vorher wie nachher — kein gesenkter Prüfwert.

### #12 · Die Triage

K23-M02 sagt ausdrücklich: *„Ein fehlender Test macht den Bauauftrag nicht automatisch
unvollständig."* Verlangt ist die Grenze aus K23-M04. Gemessen:

| | |
|---|---|
| Klauseln gesamt | 1231 |
| kritisch nach K23-M04 | **405** |
| unbestimmt | 826 |
| von einem Prüffall genannt | 46 |
| **kritisch und ohne Prüffall** | **386** |

386 ist die Arbeitsmenge — nicht 1231. Jeder der 405 Vorschläge trägt seine Belegstelle
(405 von 405). `unbestimmt` heißt ausdrücklich **nicht** *nicht kritisch*.

### #13 · Tor 3

War an vier Stellen beschrieben und an keiner erzwungen. Neu: `nachweise/fremdreview/` mit
README und Vorlage, `werkzeuge/fremdreview.py`, `pruefungen/tor3.sh`,
`.github/workflows/tor3.yml`. **Getrennt von `tore.yml`**, weil C-4 sagt: *einmal je
Scheibenabnahme, nicht je Änderung*. Läuft an `workflow_dispatch` und am Etikett
`scheibenabnahme`.

Hereingeholt wird **nicht das Review, sondern sein Nachweis** — `scheibe.md`:73: *„Der
Harness schreibt dieses Review nie selbst."* `CLAUDE.md`:75 (*„außerhalb dieses Harness"*)
bleibt unangetastet und gilt weiter.

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

**K19 v1.3 und K16 v1.3 selbst sind unverändert.** Die Nachträge sind Entscheidungsvorlagen;
sie gehen in die nächste Fassung ein, wenn die Fabrik sie einarbeitet.

---

## 3 · Was als Nächstes zu tun ist

### Sofort

1. **Die drei PRs freigeben.** #11 braucht die Wiederholung.
2. **Kopf der Maschinenquelle nachziehen** — siehe BEF-E3 unten. Gehört zu N-K19-1.

### Der kritische Pfad bis zum 31.08.

3. **Die 405 Vorschläge der Triage prüfen.** Jeder trägt seinen Beleg — Lesearbeit, keine
   Recherche.
4. **`nachweise/klauselregister/pflege.json` anlegen.** Sie existiert nicht, obwohl
   `tore.yml` sie aufruft. Ohne sie fällt Tor 1a in den Zweig *„der mitgeführte Stand wird
   geprüft"* zurück, und das Register bleibt bei **1231 von 1231 ohne Akzeptanzkriterium**.
   Nach K23-M02 ist der Bauauftrag bis dahin unvollständig — **das ist die eigentliche
   Sperre, nicht die fehlenden Tests.**
5. **Die 386 aufteilen** in *bekommt einen Prüffall* und *bekommt eine Annahmeentscheidung
   mit Träger*.
6. **`nachweise/restrisiken/restrisiken.md` füllen.** Heute steht dort **ein** Eintrag
   (RR-01, geschlossen). K23-M04 verlangt jede Klausel ohne Test einzeln; eine Quote ersetzt
   die Liste ausdrücklich nicht (F34).
7. **Erstes Tor-3-Blatt ablegen.** Solange keines da ist, meldet `pruefungen/tor3.sh`
   **GESPERRT** — richtig so, aber eine Scheibenabnahme erreicht damit Tor 4 nicht.

---

## 4 · Offene Befunde

Alle in `nachweise/befunde/BEF-E_260814.md` (kommt mit #11).

| | Stand |
|---|---|
| **BEF-E1** · Bildschirmvertrag in der Lieferung nicht vorhanden | **behoben** mit #11 |
| **BEF-E2** · `doku/Delivery_Verification_Harness_Plan_v1.0.md:95` führt *31* Screen-IDs, die Quelle **33** | offen · gehört in eine v1.1 des Plans. Nicht still berichtigt: eine Zahl in einer v1.0 zu ändern hieße, ein datiertes Dokument rückwirkend recht zu geben |
| **BEF-E3** · Konzept K19 = **v1.3 Freigegeben**, Maschinenquelle = **v1.2 FREIGABEKANDIDAT** | offen · von der Fabrik zu entscheiden |
| **BEF-E4** · zwei Lint-Regelsätze für dieselbe Datei | getragen · befristet über CHG-K00-11 |

**Zu BEF-E3, der wichtigste ungelöste Punkt:** Es gibt **keine zweite Fassung** der
Maschinenquelle — nachgemessen, ein `find` über die ganze Fabrik liefert genau eine Datei.
K19 v1.3 benennt in Zeile 13 selbst diese Datei. Wahrscheinlich ist der **Kopf nicht
nachgezogen**, nicht der Inhalt falsch: die Datei dokumentiert die Zählung vom 05.08. und
*„DER NAMENSRAUM IST AM 5.8.2026 GEZEICHNET (BV-6 Nr. 67, gez. M. Veil)"*.

**Nicht belegt:** `BV-6 Nr. 67` steht **nicht** im K00-Beschluss-Log v1.10. Ob die Zeichnung
auf einem BV-Blatt liegt oder fehlt, war von hier nicht zu entscheiden. **Das ist die Frage,
mit der die nächste Sitzung anfangen sollte.**

Denn träfe die Kopfzeile zu, verwiese K19-M01 — eine freigegebene MUSS-Klausel — auf eine
nicht freigegebene Quelle. Dann stünde jede Berufung darauf auf Sand, auch die in den vier
Vorlagen dieser Lieferung.

---

## 5 · Fallstricke, die man kennen muss

- **`dismiss_stale_reviews` ist scharf.** Jeder Commit nach einer Freigabe verwirft sie.
  Erst fertig bauen, dann um Review bitten.
- **Der Branch-Schutz greift jetzt wirklich.** `enforce_admins: true` — auch `@exmachinai`
  kommt nicht an einem Review von `@AndrewExma` vorbei. RR-01 ist damit geschlossen.
- **`ruff 0.16.1` fährt hier 413 Regeln**, nicht die dokumentierten Standardregeln. Wer Code
  aus der Fabrik übernimmt, trifft auf Verstöße, die dort keine sind.
- **Tor 3 läuft nicht bei jedem PR** — nur mit Etikett `scheibenabnahme` oder von Hand. Wer
  es sucht und nicht findet, hat nicht das Etikett gesetzt.
- **Kästen in K19 sind 61 Zeichen breit**, die Zugangsmarkenzeile 28, und innerhalb der
  Kästen wird Umschrift statt Umlauten geschrieben. Wer das übersieht, liefert einen Kasten,
  der neben den anderen falsch aussieht.
- **Der Mitgliedschaftsfall in Tor 1c ist seit dem 13.08. GESPERRT** (8 von 9). Das ist
  bekannt und nicht durch die Arbeit dieses Tages entstanden.

---

## 6 · Ein Fehler dieser Sitzung, damit er sich nicht wiederholt

**Ich habe einen Commit geschoben, nachdem A. Han bereits freigegeben hatte**, und damit die
Freigabe verworfen. Der Inhalt des zweiten Commits war richtig und gehörte dazu — die
Reihenfolge war falsch. Vier Minuten Geduld hätten eine Freigabe gespart.

---

## 7 · Zahlen des Tages

| | |
|---|---|
| Pull Requests | 3 · alle Tor 1 grün · alle offen |
| Zeichnungen in der Fabrik | 3 |
| Neue Werkzeuge | `triage.py` · `fremdreview.py` · `k19_screens_lint.py` (übernommen) |
| Neue Läufe | `pruefungen/tor3.sh` · Tor-3-Workflow |
| Neue Befunde | 4 (BEF-E1 bis E4), davon 1 behoben |
| Klauseln gemessen | 46 von 1231 |
| Klauseln, die zwingend einen Test brauchen | **386** |
| Verbleibende Zeit bis zum Endtermin | **17 Tage** (31.08.2026) |
