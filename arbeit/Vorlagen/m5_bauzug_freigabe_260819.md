# M5 · Ist der erste Bauzug erreicht? — **am Abend des 19.08. noch nicht; mit B-1 bis B-3 ist er freigegeben**

**19.08.2026, abends · GEZEICHNET — B-1, B-2 und B-3 tragen ihr Kreuz**

Die Behauptung *„damit ist der erste Bauzug an M5 erreicht"* ist geprüft worden — mit drei
adversarialen Linsen (formal · baulich · prüfseitig) und einer Zusammenführung, die jeden Beleg
selbst aufgeschlagen und sechs Rohbefunde verworfen hat.

## Das Urteil in einem Satz

> **Gezeichnet ist der Umfang, nicht der Baugrund:** die 101 Kriterien standen nur in
> `pflege.json` und teils nur im Arbeitsbaum, das Register — gegen das Tor 1a und der blinde
> Prüf-Agent messen — führte 90 der 101 leer, und für Tor 2 gab es weder Riegel noch Aufrufer
> noch eine tragende Blindheit. **Es kann gebaut werden; erreicht ist der Bauzug nicht.**

---

## 1 · Was in derselben Stunde erledigt worden ist

**Sieben der acht Bauzug-Hindernisse waren Bauarbeit, keine Zeichnung.** Sie sind gemacht:

| | Hindernis | Erledigt |
|---|---|---|
| **1** | Die Zeichnungen lagen nur im Arbeitsbaum | **eingecheckt** — `f149d89` und Folgende |
| **2** | `register.json` führte 90 der 101 M5-Klauseln leer | **neu gerechnet** gegen den Konzeptordner: **101 von 101** mit gezeichnetem Kriterium **und** Eigentümer. Die Unterschrift kommt jetzt dort an, wo gemessen wird |
| **3** | Der Blindstand trug `pruefungen/migration/` mit — also Schemawissen | **zugeschnitten**: nur noch `pruefungen/klauseln/` und `nachweise/klauselregister/` |
| **4** | Die K17-Zeichnung trug M. Veils Namen auf eine Weisung A. Hans | **berichtigt**: die Zellen sagen jetzt *„übertragen auf die Weisung A. Hans; die Bestätigung des fachlichen Eigentümers M. Veil **steht aus**"* |
| **5** | Zwei Steuerungstexte beschrieben das Repo falsch | **berichtigt** — `CLAUDE.md` (die `settings.json` **gibt es**) und `bau-agent.md` (`schema/` **gibt es**) |
| **6** | Der Bauauftrag §6a lag außerhalb des Repos | **übertragen**, wortgleich, mit Prüfsumme — `arbeit/Quellen/` |
| **7** | Das M1-Nachweisskript „liegt nicht im Repo" | **übertragen**: `migrations/n2_lauf.sh` samt den Belegen des N2-Laufs |

> **Der Fund des Tages steht daneben.** In derselben Übergabe lag ein **fertiges
> Zeilenschutz-Regime** — 332 Zeilen, idempotent, mit eigener Prüfdatei
> (`migrations/uebernahme/`). Der Befund *„im Repo gibt es kein einziges `CREATE POLICY`"* stimmt
> für den Lieferstand und nicht für die Vorarbeit: sie lag fertig da und ist nie übernommen
> worden. **Sie löst S-A nicht von selbst** — der Serverpfad verbindet als Eigentümer und setzt
> `freiraum.tenant_id` nirgends. Beides gehört in denselben Zug.

---

## 2 · Was jetzt noch eine Unterschrift braucht — **drei Zeilen**

### B-1 · Wer fasst `.github/`, `.claude/` und `pruefungen/` an?

**Entscheidung 8 vom 19.08. weist dem Bau fünf Punkte zu** — V-7 (Negativfälle je Migration),
V-10 (GESPERRT in den Rückgabewert), V-11 (Prüfsummen in Tor 1), V-12 (Rollengrenzen mechanisch),
V-13 (Blindstand einhängen). **Alle fünf liegen in Pfaden, die der Bau-Agent nie beschreiben
darf** (`bau-agent.md`: *„`CLAUDE.md`, `.claude/`, `.github/`"* und *„`pruefungen/` — kein
Anlegen, kein Ändern"*).

Ohne eine benannte Zuständigkeit kann dieser Teil nicht beginnen, **ohne die gezeichnete
Rollentrennung zu verletzen**.

`x` **Ich lege fest:** V-7, V-10, V-11, V-12 und V-13 führt der **Orchestrator** aus; die
Schreibgrenze des Bau-Agenten bleibt unverändert. *(Empfehlung — der Orchestrator schreibt
ohnehin die Nachweise und entscheidet nichts fachlich.)*
`☐` anders: ⟨ ⟩

### B-2 · Die fünfte der fünf Fragen des Fremdmodells

`CLAUDE.md` Abschn. 6: *„Die fünf Fragen des Fremdmodells sind **vor dem ersten Bauzug** zu
entscheiden, nicht danach."* Vier sind gezeichnet. **B-17** trägt den Vermerk *„gez. M. Veil,
16.08.2026 — Mitzeichnung A. Han nach 12.3 steht aus"*.

`x` **A. Han zeichnet B-17 mit** (jede Umfangskürzung benennt die berührten K23-Gates und was an
ihre Stelle tritt). *(Empfehlung)*

### B-3 · Die sechs K17-Kriterien

Sie sind eingetragen, aber die Zelle sagt selbst, dass **M. Veils Bestätigung aussteht**.

`x` **M. Veil bestätigt die sechs K17-Zeichnungen** (K17-D03, K17-D13, K17-M02, K17-M06,
K17-M07, K17-M23). *(Empfehlung — die Zuweisung folgt Bauauftrag §7a, L4)*
`☐` die Zeichnung wird auf den benannt Weisenden umgeschrieben

---

## 3 · Was keine Unterschrift löst — hier muss jemand etwas tun

**Reihenfolge zählt: S1 vor allem anderen.** Fällt M4, hat M5 nach §6a *„keinen Gegenstand"*.

| | Was | Wer | Warum es nicht mit einem Kreuz geht |
|---|---|---|---|
| **S1** | **M4 eintreten lassen** — **Lauf gefahren am 19.08.:** MT-95 bis MT-98 **bestanden**, 131 Einzelfälle, 0 Fehlschläge. **Offen:** der K19-Kasten für EN-04a und der freie Weg im Klausellauf (`arbeit/Bauberichte/m4_nachrechnung_260819.md`) | Bau · Konzept-Fabrik · Prüf-Agent, dann beide | Ein Lauf ist ein Lauf. Der gegen die **Zielumgebung** steht aus |
| **S3** | **M1 bestätigen** — `migrations/n2_lauf.sh` gegen die Zielumgebung, Manifest nach K23-M18. **Vor jedem Zugriff `frxfw`** | Bau | Das Skript liegt jetzt im Repo; gelaufen ist es hier nie |
| **T3** | **Tor 3 anfordern** — die Anforderung liegt fertig, das Etikett existiert, `nachweise/fremdreview/` ist leer | A. Han | Der fremde Blick entsteht außerhalb des Harness. **Das ist das Nadelöhr: er braucht Zeit** |
| **A** | **Scheibenabnahme anmelden** — `nachweise/scheiben/<kennung>/abnahme.md`; F42 greift erst dann | ein Mensch | Der Harness legt sie **nie** selbst an |
| **BA** | **BA-1 und BA-2 gegenzeichnen** — ohne A. Hans Zeile gilt *„AM AUFTRAG IST NICHTS GEÄNDERT"*, und M5 wäre zum 31.08. geschuldet | A. Han | **Reihenfolge:** erst diesen Zweig zusammenführen, dann zeichnen — sonst sperrt §12.4 jede weitere Vorlage |
| **F42** | **F42 in `config/kanon.yaml`** — der Entwurf liegt in `arbeit/an_konzeptfabrik/` | M. Veil | Der Harness schreibt nicht in die Konzept-Fabrik |
| **PR** | **Diesen Antrag zusammenführen** — Tor 1 hat die Commits noch **kein einziges Mal** gemessen | ein Mensch | Kein Agent hat Freigabe- oder Merge-Recht |

---

## 4 · Was danach gilt

**Mit B-1 bis B-3 und dem zusammengeführten Antrag ist der erste Bauzug erreicht.** Die
übrigen Punkte aus Abschnitt 3 blockieren nicht den *Beginn*, sondern die *Abnahme* — sie
dürfen parallel laufen, und Tor 3 sollte es, weil es am längsten dauert.

**Was der Bauzug dann als Erstes anfasst**, ist gezeichnet und liegt bereit: die Übernahme des
Zeilenschutzes für `app`, `document`, `event`, `freiraum.tenant_id` im Serverpfad, die Funktion
für den Stufenwechsel samt atomarem `event`-Eintrag und der Umbau von `change_app_state`.

---

## Zeichnung

| | Entscheidung | |
|---|---|---|
| **B-1** | V-7, V-10, V-11, V-12, V-13 führt der Orchestrator aus | **x** so |
| **B-2** | A. Han zeichnet B-17 mit | **x** so |
| **B-3** | M. Veil bestätigt die sechs K17-Kriterien | **x** so |

> **Übertragung durch den Harness.** Zwei Weisungen im Wortlaut, 19.08.2026:
> *„B1 B2 B3 sind gezeichnet"* und *„B2 -B17 gezeichnet, A. Han, M. Veil"*. Die zweite nennt
> für B-17 beide Namen; eingetragen ist sie so. Eine erteilte Zeichnung einzutragen ist
> Buchführung (`CLAUDE.md` Abschn. 6).
>
> **Damit ist die letzte der fünf Fragen des Fremdmodells entschieden — und der erste Bauzug
> an M5 ist freigegeben.** Was aus Abschnitt 3 offen bleibt, blockiert die *Abnahme*, nicht den
> *Beginn*.

| Name | Rolle | Datum |
|---|---|---|
| A. Han | für den Auftragnehmer | **19.08.2026** |
| M. Veil | für den Auftraggeber | **19.08.2026** |

---

*Verfahren am 19.08.2026: drei adversariale Linsen mit dem Auftrag, die Behauptung zu
widerlegen, danach eine Zusammenführung, die jeden Beleg selbst aufschlug. Von den Rohbefunden
sind sechs verworfen worden — darunter zwei, die den Harness härter getroffen hätten, als die
Quelle hergab. Die sieben erledigten Punkte aus Abschnitt 1 sind nach dem Urteil und vor dieser
Vorlage ausgeführt worden; sie sind im Git-Verlauf einzeln nachlesbar.*
