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

## RR-01 · Gate 5 ist im Repo nicht mechanisch erzwungen

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
| Repos der Organisation `exmachinAI-GmbH` | **null** |
| `GET /repos/…/branches/main/protection` | weiterhin **403** |

GitHub Team ist ein **Organisations**plan. Für ein privates Repository unter einem
persönlichen Konto verlangt GitHub den Plan **Pro** — ein anderes Abonnement. Das
Abonnement läuft damit ins Leere, solange das Repo nicht der Organisation gehört.

**RR-01 bleibt deshalb offen — aber der Weg zur Schließung ist jetzt kurz und kostet
nichts mehr:** das Repository in die Organisation übertragen, A. Han einen der beiden
Sitze geben, Branch-Schutz setzen. Danach greift Gate 5 mechanisch, und dieses Restrisiko
wird geschlossen statt getragen.

### Nachtrag 09.08.2026 — von drei Voraussetzungen sind zwei erfüllt

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
Klauselregister (`nachweise/klauselregister/register.json`) und werden von dort aus
fortgeschrieben, sobald die Pflegedatei entsteht.

**Hier stehen nur Restrisiken, die keiner Klausel zugeordnet sind** — solche, die aus einer
Entscheidung folgen statt aus einer fehlenden Prüfung. RR-01 ist der erste.

---

*Angelegt am 07.08.2026. RR-01 vollständig: Träger M. Veil, Annahmeentscheidung und Frist
gezeichnet am 07.08.2026. Die Frist ist ereignisgebunden, nicht kalendarisch — sie greift mit
dem ersten Mandanten, dessen `tenant.datenart` von `SYNTHETISCH` auf `ECHT` wechselt.*
