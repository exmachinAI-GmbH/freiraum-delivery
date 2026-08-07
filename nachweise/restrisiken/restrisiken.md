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
| **Entscheidung** | **GitHub Team wird nicht gebucht, A. Han wird nicht als Mitarbeiter aufgenommen** — Weisung M. Veils vom 07.08.2026. Das Repo bleibt privat (BV-25 Nr. 150) |
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
