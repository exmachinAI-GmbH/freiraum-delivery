# Restrisikoliste · FREIRAUM Coding-Harness

**Grundlage: K23-M04 und K23-D07.** Eine Klausel ohne belegenden Test wird **einzeln** als
Restrisiko mit Träger, Kritikalität und Annahmeentscheidung aufgeführt. **Eine
Abdeckungsquote ersetzt diese Liste nicht** (F34). Ein Restrisiko **darf nicht stillschweigend
übernommen werden** — es trägt einen Namen und einen Träger (K23-D07).

**Diese Liste wird bei jeder Scheibenabnahme mit vorgelegt** (Blatt 11:137). Die eigenständige
Tor-II-Sperrbedingung lautet: **kein kritisches Restrisiko ohne Annahmeentscheidung** — die
Liste allein erfüllt sie nicht; je kritischem Eintrag braucht es die gezeichnete Annahme des
Auftraggebers.

---

## Diese Liste hat seit dem 16.08.2026 zwei Teile

| Teil | Datei | Was darin steht | Einträge |
|---|---|---|---|
| **A · aus Entscheidungen** | **dieses Blatt** | Restrisiken, die keiner einzelnen Klausel zugeordnet sind, sondern aus einer Entscheidung folgen | **2** — `RR-01` **geschlossen**, `RR-02` **offen und getragen** |
| **B · aus fehlenden Prüffällen** | **`restrisiken_teilschnitt.md`** | je Klausel des Teilschnitts, die als kritisch vorgeschlagen ist und **keinen Prüffall** hat — einzeln, wie `K23-M04` es verlangt | **113, alle offen** |

**Der Stand von Teil B, gemessen am 16.08.2026:**

| | |
|---|---|
| **Einträge** | **113** |
| **davon in einer sperrenden Klasse** nach `K23-M04` | **113** — dort ersetzt **keine** Annahmeentscheidung den Test |
| **Träger eingetragen** | **0 von 113** |
| **Annahmeentscheidungen gezeichnet** | **0 von 113** |
| **Wer das Fehlende liefert** | **M. Veil** zeichnet Träger, Annahmeentscheidung und Frist (Zeichnung B-5 vom 16.08.2026). Die **Akzeptanzkriterien**, ohne die kein Prüffall schreibbar ist, liefern die **fachlichen Eigentümer** (`K23-M02`) |

**Teil B ist ein Vorschlag, keine Entscheidung.** Der Harness hat die Zeilen vorbereitet und
die Felder für Träger und Annahmeentscheidung **absichtlich leer gelassen**. Ein Feld, das
aussieht wie entschieden, wäre schlimmer als ein leeres.

**Damit ist die Tor-II-Sperrbedingung heute nicht erfüllt** — nicht wegen dieser Liste,
sondern weil 113 Einträge ohne Annahmeentscheidung darin stehen und für alle 113 eine
Annahme nach `K23-M04` ohnehin nicht genügen würde.

---

## RR-01 · Gate 5 ist im Repo nicht mechanisch erzwungen — **GESCHLOSSEN am 09.08.2026**

| Feld | Wert |
|---|---|
| **Betroffene Klausel** | K23 Abschnitt 6, **Gate 5** — *Selbstfreigabe oder fehlender Rollentrennung* |
| **Kritikalität** | **kritisch** — Gate 5 zählt zu den sperrenden Freigabe-Gates. Nach K23-M04 sperrt eine kritische Klausel ohne belegenden Test die Freigabe, solange keine gültige befristete Annahmeentscheidung vorliegt |
| **Befund** | Branch-Schutz ist auf privaten Repositories des freien GitHub-Plans nicht verfügbar. Gemessen am 07.08.2026: `gh api repos/exmachinai/freiraum-delivery/branches/main/protection` → **403 „Upgrade to GitHub Pro or make this repository public"** |
| **Entscheidung** | Ursprünglich am 07.08.2026: kein Abonnement, kein zusätzlicher Mitarbeiter (BV-25 Nr. 150). **Am selben Tag überholt — siehe Nachtrag unten.** Das Repo bleibt privat |
| **Was dadurch nicht greift** | `enforce_admins` · `require_code_owner_reviews` · erzwungene Prüfungen (Tor 1 als Pflichtcheck) · Verbot direkter Pushes auf `main` · `require_last_push_approval`. Die Datei `.github/CODEOWNERS` liegt vor, wirkt aber ohne Branch-Schutz nicht |
| **Träger** | M. Veil |
| **Annahmeentscheidung** | **gezeichnet am 07.08.2026** (BV-25 Nr. 150) |
| **Frist** | **Vor dem ersten Mandanten mit echten Daten** — gezeichnet am 07.08.2026 von M. Veil. Derselbe Auslöser, den das Projekt für die Risikoannahme zum zweiten Faktor gewählt hat (K00 S95 · P5). **Nach K23-M04 erlischt die Annahmeentscheidung mit Fristablauf; danach sperrt die Klausel wie eine kritische, ohne dass es einer neuen Entscheidung bedarf** — es braucht dann Branch-Schutz oder eine neue, begründete Annahme |

### Was genau offen ist — und was nicht

**Nicht betroffen ist die Abnahmespur.** Der zweite Blick nach K14 und die zweite natürliche
Person für den Wechsel nach `IN_PROD` (K23-M21) sind Akte im **Nachweis** und in `approval`,
nicht im Repo. Sie sind durch BV-25 Nr. 165 personell benannt: **A. Han**.

**Betroffen ist die Codespur.** Ohne Branch-Schutz kann Code den Standardzweig erreichen,

- ohne dass **Tor 1** bestanden ist (Lint, Migration gegen frische Datenbank, Prüflauf),
- ohne dass ein **zweiter Mensch** hingesehen hat,
- und ohne dass eine Umgehung im Nachhinein erkennbar wäre.

**Der Widerspruch, der bleibt:** Die zweite natürliche Person (A. Han) hat **keinen Zugang zum
Repository** — einziger Mitarbeiter ist `exmachinai`. Solange das so ist, ist der zweite Blick
auf den **Code** eine Aussage auf Papier. Auf die Abnahmezeichnung wirkt das nicht.

### Nachtrag vom 07.08.2026, abends — die Lage hat sich geändert

**GitHub Team ist abonniert.** Gemessen: die Organisation `exmachinAI-GmbH` führt den Plan
`team` mit zwei Sitzen und unbegrenzt privaten Repositories; das angemeldete Konto ist dort
Admin.

**Der Branch-Schutz greift trotzdem nicht — das Repo liegt am falschen Ort.**

| | gemessen am 07.08.2026 |
|---|---|
| Eigentümer von `freiraum-delivery` | persönliches Konto **`exmachinai`** (Typ: User) |
| Repos der Organisation `exmachinAI-GmbH` | null *(Stand 07.08.; seit 09.08.: eines — dieses)* |
| `GET /repos/…/branches/main/protection` | 403 *(Stand 07.08.; seit 09.08.: gesetzt, siehe oben)* |

GitHub Team ist ein **Organisations**plan. Für ein privates Repository unter einem
persönlichen Konto verlangt GitHub den Plan **Pro** — ein anderes Abonnement. Das
Abonnement läuft damit ins Leere, solange das Repo nicht der Organisation gehört.

**RR-01 bleibt deshalb offen — aber der Weg zur Schließung ist jetzt kurz und kostet
nichts mehr:** das Repository in die Organisation übertragen, A. Han einen der beiden
Sitze geben, Branch-Schutz setzen. Danach greift Gate 5 mechanisch, und dieses Restrisiko
wird geschlossen statt getragen.

## GESCHLOSSEN am 09.08.2026 — Gate 5 greift mechanisch

**Nicht behauptet, gemessen.** Ein Versuch, mit dem **Admin-Konto** direkt auf `main` zu
schreiben, wurde abgewiesen:

```
remote: error: GH006: Protected branch update failed for refs/heads/main.
remote: - Changes must be made through a pull request.
remote: - 4 of 4 required status checks are expected.
```

**Der Schutz hat den Auftraggeber selbst abgewiesen.** Das ist der Nachweis, auf den es
ankommt — ein Schutz, der Admins ausnimmt, schützt nichts.

| Was | Wert |
|---|---|
| Repository | `exmachinAI-GmbH/freiraum-delivery` — Organisation, privat |
| `enforce_admins` | **true** |
| Pflichtprüfungen | **4 von 4**: Tor 1a · Tor 1b · Tor 1c · Tor 1 Sperre |
| Pflichtreview | 1, mit **CODEOWNERS-Pflicht** |
| `require_last_push_approval` | **true** — niemand gibt seinen eigenen letzten Push frei |
| `dismiss_stale_reviews` | true · Force-Push: **aus** · Löschen von `main`: **aus** |
| Mitarbeiter | `exmachinai` (admin) · **`AndrewExma` (push)** |

**Damit ist die Voraussetzung von Gate 5 aus K23 erfüllt** — keine Selbstfreigabe, keine
fehlende Rollentrennung. Das Restrisiko ist **geschlossen**, nicht getragen: die
Annahmeentscheidung vom 07.08.2026 (Träger M. Veil, Frist *„vor dem ersten Mandanten mit
echten Daten"*) läuft damit ins Leere, weil der Grund entfallen ist.

**Die Probe hat sich selbst bestätigt:** Auch dieses Blatt kann nicht mehr direkt auf `main`
geschrieben werden. Es kommt über einen Pull Request, der einen Review von `@AndrewExma`
braucht — der erste Vorgang, der Gate 5 durchläuft.

---

### Wie es dahin kam — Nachtrag 09.08.2026

| | Stand am 07.08. | Stand am 09.08. |
|---|---|---|
| Entscheidung über den Umzug | stand aus | **gezeichnet** (M. Veil, 07.08.2026) |
| A. Han in der Organisation | Einladung offen, Kennung unbekannt | **Mitglied**, Kennung `@AndrewExma`; 2 von 2 Sitzen belegt |
| Repo gehört der Organisation | nein | **weiterhin nein** — `exmachinai`, persönliches Konto |
| Branch-Schutz | 403 | **weiterhin 403** |

**Es fehlt genau ein Handgriff:** die Übertragung. Sie verlangt den Eigentümer des
persönlichen Kontos; ein Werkzeug kann sie hier nicht auslösen.

Alles danach ist vorbereitet und liegt als **`install/nach_umzug.sh`** bei — Fernadresse,
Branch-Schutz mit allen vier Tor-1-Prüfungen als Pflicht, `enforce_admins`, Pflichtreview
über CODEOWNERS. Das Skript prüft zuerst, ob der Umzug vollzogen ist, und tut ohne
`--setzen` nichts.

**RR-01 wird geschlossen, wenn das Skript gelaufen ist und sein Nachweis vorliegt** — nicht
vorher, und nicht auf Zuruf. Ein Restrisiko, das man für geschlossen erklärt, ohne die
Sperre zu messen, ist genau das, wogegen K23-M04 geschrieben ist.

---

### Ersatzmaßnahmen, die ohne Branch-Schutz greifen

| | Maßnahme | Stand |
|---|---|---|
| 1 | Tor 1 läuft trotzdem bei jedem Pull Request und meldet sein Ergebnis — es **sperrt** nur nicht | **eingerichtet** (`.github/workflows/tore.yml`) |
| 2 | Der Bau-Agent hat **kein Freigabe- und kein Deploymentrecht** und darf nur Zweige und Pull Requests (BV-25 Nr. 146) | **festgelegt**, in der Anlage „Bauverfahren" |
| 3 | Jede Scheibenabnahme legt diese Liste mit vor | **diese Datei** |
| 4 | Das Manifest je Lauf führt den Commit-Hash — eine Umgehung ist nachträglich **auffindbar**, wenn auch nicht verhindert | mit dem ersten Manifest |

---
---

## RR-02 · Die Aufbewahrungsklasse `BETRIEBSPROTOKOLL` ist im Protokoll nicht vollziehbar — **OFFEN, getragen seit 16.08.2026**

| Feld | Wert |
|---|---|
| **Betroffene Punkte** | **O-K15-6** (*„Das Protokoll ist bewusst nur ergänzbar; ein Entfernen ist per Regel unterbunden. Damit ist die Klasse BETRIEBSPROTOKOLL im Protokoll nicht vollziehbar. **Vorrang klären.**"*) · **O-K02-6** (*„… im Betrieb identisch sperrend, aber aufschiebbar, **solange O-K15-6 offen ist**"*) · geschlossen an **O-K20-4** |
| **Kritikalität** | **kritisch — aufbewahrungskritisch.** Nach `K23-M04` ersetzt in dieser Klasse eine Annahmeentscheidung **den Test nicht.** Das gilt für diesen Eintrag ausdrücklich weiter |
| **Befund** | Zwei gezeichnete Regeln widersprechen sich. Regel 1: Aus dem Protokoll wird nichts entfernt — es ist *„bewusst nur ergänzbar"*. Regel 2: Einträge der Klasse `BETRIEBSPROTOKOLL` müssen nach ihrer Frist verschwinden. **Beide gelten, eine kann nicht erfüllt werden.** Keines der beiden Konzepte konnte allein entscheiden, welche weicht: K15 verwies auf K02, K02 wartete auf K15 — ein Kreis, der sich ohne einen Eingriff von außen nicht öffnet |
| **Entscheidung** | **Weg A — die Unversehrtheit des Protokolls hat Vorrang.** Aus dem Protokoll wird nichts entfernt. Die Aufbewahrungsklasse `BETRIEBSPROTOKOLL` wird **im Protokoll** als **nicht vollziehbar** geführt und als dieses benannte Restrisiko getragen |
| **Grundlage** | Zeichnung **B-20** vom 16.08.2026, `arbeit/Vorlagen/vorlage_neun_entscheidungen_260816.md`. Weisung im Wortlaut: *„Das Protokoll bleibt lückenlos. Es wird nie etwas entfernt. Die Löschregel steht dann zwar auf dem Papier, wird an dieser einen Stelle aber nicht ausgeführt — und das wird ausdrücklich als bekanntes Risiko aufgeschrieben, damit es niemand übersieht."* |
| **Träger** | **M. Veil** — *abgeleitet, nicht angewiesen:* O-K15-6 führt als Entscheider *„Founder"*, und die Weisung stammt von M. Veil. Wer ein Restrisiko annimmt, trägt es. Ist ein anderer Träger gewollt, wird der Name hier ersetzt |
| **Annahmeentscheidung** | **gezeichnet am 16.08.2026** (M. Veil) — **und sie genügt nach `K23-M04` nicht.** Siehe *Was dieser Eintrag nicht leistet* |
| **Frist** | **keine.** Der Vorrang ist eine Dauerentscheidung, kein Aufschub. Was befristet ist, ist der **Nachweis** darüber — siehe unten |

### ⚠ Berichtigung vom 16.08.2026, spät — die Lage ist besser, als dieser Eintrag sie beschrieb

**Beim Ausarbeiten der Handlungsempfehlungen ist gemessen worden, dass die Frage schon
einmal entschieden **und gebaut** worden ist. Drei Funde, jeder mit seinem Befehl:**

**1 · Es gibt einen Beschluss, und er sagt dasselbe wie Weg A.**

```
$ grep -n "Nr\. 60\|^| 60 |" 260804_Nachweisprotokoll_Freigabe.md
115:| 60 | Protokollzeilen und der taegliche Aufraeumlauf widersprechen sich | wie Empfehlung — Option A |
```

**Beschluss Nr. 60, gezeichnet am 04.08.2026** — zwölf Tage vor der heutigen Entscheidung,
zu genau derselben Frage, mit demselben Ergebnis. **M. Veil hat heute bestätigt, nicht neu
entschieden.** Das ist kein Fehler, aber es gehört hier hin: Dieser Eintrag las sich, als
sei ein Kreis zum ersten Mal geöffnet worden.

**2 · Der Bau führt Weg A bereits aus.**

```
$ sed -n '1477,1496p' migrations/M30__pilot_sammelmigration.sql
-- 10h · Eigene Klasse fuer Protokollzeilen
INSERT INTO retention_rule(class,…) VALUES ('EREIGNIS',
  'Unveraenderbare Ereigniszeilen (Protokoll)','BEZUGSOBJEKT',NULL,NULL,0,NULL,
  'Beschluss Nr. 60 (Option A) und Nr. 16: Beweiswert vor Loeschzusage. '
  'Ohne Faelligkeit und ohne Anonymisierung -- die Zeile bleibt, wie sie ist');
ALTER TABLE event ALTER COLUMN retention_class SET DEFAULT 'EREIGNIS';
```

**Die Tabelle `event` trägt seit M30 die Klasse `EREIGNIS`, nicht mehr `BETRIEBSPROTOKOLL`** —
eine Klasse ohne Fälligkeit und ohne Anonymisierung. **Damit ist der Widerspruch im Bau
strukturell aufgelöst**, nicht getragen: Es gibt dort keine unerfüllbare Löschfrist mehr,
weil die Klasse, die sie trug, für das Protokoll nicht mehr gilt.

**3 · Was dadurch tatsächlich offen bleibt — und es ist deutlich weniger:**

| | Was | Stand |
|---|---|---|
| Der Bau | `event` = `EREIGNIS`, append-only per Trigger `event_append_only` | **erledigt** |
| Die **Konzepte** | `O-K15-6` und `O-K02-6` stehen weiter als **offen** in K15 v1.6 und K02 v1.3 | ⛔ **offen** |
| **`K02-M17`** | sagt gezeichnet: *„Jeder Protokolleintrag MUSS eine Aufbewahrungsklasse tragen; **Vorgabe ist das Betriebsprotokoll**."* — **das Gegenteil dessen, was gebaut ist** | ⛔ **Widerspruch** |
| **`K15-G11`** | *„Solange O-K15-2, O-K15-4 bis O-K15-6 und O-K15-9 offen sind, bleibt die automatisierte Entfernung **gesperrt**; eine manuelle Umgehung ist unzulässig."* | ⛔ **vier weitere Punkte sperren** |

> **Was das für diesen Eintrag heißt.** `RR-02` bleibt bestehen, aber sein Gegenstand ist ein
> anderer als beschrieben: **Nicht ein verklemmter Kreis, sondern ein Bau, der einer
> gezeichneten Klausel widerspricht** — mit Beschluss Nr. 60 als Deckung, aber ohne dass die
> Klausel nachgezogen wurde. Und **K15-G11** zeigt, dass das Schließen von O-K15-6 allein die
> automatisierte Löschung nicht freigibt: **vier weitere offene Punkte sperren sie weiter.**

### Was mit dieser Entscheidung geschlossen ist

**Der Kreis ist offen.** O-K15-6 lautete *„Vorrang klären"* — der Vorrang ist geklärt. Damit
fällt auch die Bedingung weg, unter der O-K02-6 aufschiebbar war (*„solange O-K15-6 offen
ist"*). Beide Punkte haben ab dem 16.08.2026 eine Antwort, an der sie fortgeschrieben werden
können.

### Was dieser Eintrag **nicht** leistet — offen benannt

**`K23-M04` sagt für aufbewahrungskritische Klauseln, dass eine gezeichnete Annahme den Test
nicht ersetzt.** Dieser Eintrag ist eine Annahme. **Er hebt die Sperre also nicht auf.**

Was er leistet, ist etwas anderes und Geringeres, aber Notwendiges: Er macht aus einem
**stillschweigenden** Zustand einen **benannten**. Vorher galt eine Löschregel, die an einer
Stelle nicht ausgeführt wurde, ohne dass irgendwo stand, dass sie dort nicht ausgeführt wird.
Genau das verbietet `K23-D07`: *ein Restrisiko darf nicht stillschweigend übernommen werden.*

**Was zum Aufheben der Sperre nötig bleibt — drei Dinge, keines davon Harness-Arbeit:**

| | Was | Wer |
|---|---|---|
| 1 | **Die Aufbewahrungsregel im Wortlaut ändern**, so dass `BETRIEBSPROTOKOLL` für das Protokoll gar nicht erst eine Löschfrist trägt. Erst dann gibt es keine unerfüllte Regel mehr, sondern nur noch eine, die dort nicht gilt | Eigentümer **K02** und **K15**, gemeinsam |
| 2 | **Ein Prüffall, der belegt, dass aus dem Protokoll nichts entfernt werden kann** — der Test, den die Annahme nicht ersetzt | Prüf-Agent, blind, nach dem Akzeptanzkriterium des fachlichen Eigentümers |
| 3 | **Die datenschutzrechtliche Seite prüfen lassen.** Eine Löschpflicht wird durch eine Projektentscheidung nicht kleiner. Was hier entschieden ist, ist der **Vorrang im Bau** — nicht, dass die Pflicht entfällt | **M. Veil**, mit fachlicher Beratung |

> **Punkt 3 ist der wichtigste und der einzige, der außerhalb des Projekts liegt.** Die
> Entscheidung vom 16.08.2026 löst den Kreis im Bau. Sie entscheidet nicht, ob die
> Aufbewahrungspflicht rechtlich hinter der Beweisführung zurücktritt — das kann sie nicht,
> und dieses Blatt behauptet es nicht.

### Ein verwandter Punkt, der **nicht** mitentschieden ist

**O-K15-3** — *„Der Aufräumlauf für Einladungen außerhalb des Zustands VERSANDT (Vorschlag:
90 Tage) ist eine Betriebsregel, keine Schemaregel, und **noch nicht beschlossen**."* ·
Träger: *Founder · Umsetzung K20* · Frist: *vor Produktion*.

Er stand auf demselben Blatt B-20 und ist **nicht** angewiesen worden. Er bleibt offen und
wird hier nur genannt, damit er nicht im Schatten von RR-02 verschwindet.

---

---

## RR-03 · Der Verlauf ist Kontrolldatum des Übergangswächters und nicht schreibgeschützt — **OFFEN, angelegt 19.08.2026**

| | |
|---|---|
| **Was** | `app_state_history` trägt keinen Schreibschutz. Wer die Verlaufszeile ändert, verändert damit die Grundlage, auf der `lifecycle_transition_guard` entscheidet |
| **Gemessen am 19.08.2026** | Unter `SET ROLE fr_portal` gelang nach **einem einzigen `UPDATE`** auf die Verlaufszeile ein Wechsel `PAUSIERT → IN_PROD` — **ohne `sealed_at`, ohne `approval`** |
| **Kritikalität** | **hoch, aber heute nicht erreichbar.** Alle sechs `fr_*`-Rollen sind `NOLOGIN`, `pg_auth_members` ist leer; die Anwendung verbindet als `postgres`. Wer heute herankommt, könnte ohnehin auch den `event`-Wächter abschalten |
| **Wann es scharf wird** | **mit der Rollenabbildung.** Sobald eine `fr_*`-Rolle anmeldefähig wird, ist der Weg offen |
| **Träger** | offen — *nicht angewiesen.* Der Eigentümer ist nach K01/K11 zu bestimmen |
| **Annahmeentscheidung** | **keine.** Blatt 99 Punkt 3, gezeichnet am 19.08.2026, sagt: *zu entscheiden, **bevor** die Rollenabbildung kommt* |

### Warum das kein Append-only-Problem ist

Der ursprüngliche Verdacht lautete: `app_state_history` fehlt der Schreibschutz, den `event`
hat. **Er wurde geprüft und zurückgewiesen** (Blatt 99, Befund A, 0 von 3 Stimmen):

- **Keine der 1231 Klauseln** verlangt Unveränderlichkeit für `app_state_history`. Wo sie
  gewollt ist, steht sie namentlich da — K02-D01, K11-D07, K14-G09 — und genau diese vier
  Tabellen tragen den Wächter.
- Die Auslassung ist begründet: `schema/freiraum_datamodel.sql:446` — *„Bewusst NICHT
  bitemporal: Transaktionszeit liefert bereits das append-only EVENT-Log."*
- **Ein pauschaler Wächter würde den Bau zerbrechen.** Gemessen: `change_app_state` bricht ab,
  weil er die Verlaufszeile selbst aktualisiert, um sie zu schließen — genau das, was K11-M09
  verlangt.

**Der Befund liegt woanders**, und deshalb steht er hier als eigener Punkt: nicht *„der Verlauf
ist änderbar"*, sondern *„der Verlauf entscheidet mit, ob ein Übergang erlaubt ist"*. Ein
Kontrolldatum, das der Kontrollierte ändern kann, ist keine Kontrolle.

### Was noch nicht gemessen ist

- Ob der Weg auch mit der künftigen Rollenabbildung besteht — **die gibt es noch nicht.**
- Ob ein Riegel **nur gegen `DELETE`** genügt. Gemessen ist, dass er den Bau nicht zerbricht;
  ob er den Weg schließt, ist offen.
- Ob weitere Wächter im Bestand auf Daten entscheiden, die der Aufrufer ändern kann. Geprüft
  wurde dieser eine.

### Wie er geschlossen wird

Nicht durch ein Werkzeug allein. Zu entscheiden ist, **worauf** der Übergangswächter sich
stützen soll, wenn die Verlaufszeile es nicht sicher kann. Das ist Konzeptarbeit bei K01/K11 —
nicht Bau, nicht Prüfung.

## Wie diese Liste geführt wird

Sie ist eine **erzeugte Sicht auf einen Datenbestand**, keine von Hand gepflegte Wahrheit
(Blatt 26:59–63). Die 1.231 Klauseln ohne Akzeptanzkriterium und ohne Test stehen im
Klauselregister (`nachweise/klauselregister/register.json`).

**Auf diesem Blatt stehen nur Restrisiken, die keiner Klausel zugeordnet sind** — solche, die
aus einer Entscheidung folgen statt aus einer fehlenden Prüfung. RR-01 (geschlossen) und
RR-02 (offen, getragen).

**Die klauselgebundenen Restrisiken stehen seit dem 16.08.2026 in
`restrisiken_teilschnitt.md`** — dort einzeln, mit `RR-T-001` bis `RR-T-113`, jeweils mit
dem Wort, das die Kritikalität ausgelöst hat. Maschinenlesbar daneben:
`restrisiken_teilschnitt.json`.

**Was noch fehlt:** Die 113 Einträge decken den **Teilschnitt** ab, nicht den ganzen Bestand.
Die Triage schlägt insgesamt **386** kritische Klauseln ohne Prüffall vor. Die übrigen **273**
liegen außerhalb des Teilschnitts und sind **nicht** aufgeführt — die Einengung auf den
Teilschnitt ist mit B-4 und B-5 am 16.08.2026 gezeichnet. Wird der Umfang später wieder
verbreitert, wächst diese Liste mit.

---

*Angelegt am 07.08.2026. RR-01 vollständig: Träger M. Veil, Annahmeentscheidung und Frist
gezeichnet am 07.08.2026. Die Frist ist ereignisgebunden, nicht kalendarisch — sie greift mit
dem ersten Mandanten, dessen `tenant.datenart` von `SYNTHETISCH` auf `ECHT` wechselt.*
