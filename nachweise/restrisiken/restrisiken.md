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
| **A · aus Entscheidungen** | **dieses Blatt** | Restrisiken, die keiner einzelnen Klausel zugeordnet sind, sondern aus einer Entscheidung folgen. `RR-01` ist der erste — und **geschlossen** | 1, geschlossen |
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

## Wie diese Liste geführt wird

Sie ist eine **erzeugte Sicht auf einen Datenbestand**, keine von Hand gepflegte Wahrheit
(Blatt 26:59–63). Die 1.231 Klauseln ohne Akzeptanzkriterium und ohne Test stehen im
Klauselregister (`nachweise/klauselregister/register.json`).

**Auf diesem Blatt stehen nur Restrisiken, die keiner Klausel zugeordnet sind** — solche, die
aus einer Entscheidung folgen statt aus einer fehlenden Prüfung. RR-01 ist der erste und
bisher einzige.

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
