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

## RR-02 · Die Zugangszeile verweist auf keine Einladung — **offen, angelegt am 15.08.2026**

| Feld | Wert |
|---|---|
| **Betroffene Klausel** | **K20-M07** — *„Ein neuer Zugang zum EXMA-Portal MUSS über eine Einladung entstehen: Zeile in `invitation` mit Konto, Portal, Adresse, Streuwert, Versand- und Ablaufzeitpunkt."* Mitbetroffen: **K20-M18** (jede Änderung an Zugang und Einladung steht mit Zeitpunkt und handelnder Instanz im Nachweis) und **K23-M03** (die Herkunftskette *Quelle → Klausel → Umsetzung → Test → Nachweis*) |
| **Kritikalität** | **offen — dieses Blatt stuft nicht ein.** Vorschlag: **mittel**, Begründung unten. Eine Einstufung ist eine fachliche Entscheidung, und kein Agent entscheidet sie nach eigenem Urteil (Blatt 11:170). K23-D05 verbietet zusätzlich, eine Kritikalität so zu setzen, dass ein Lauf bequem besteht |
| **Befund** | Im Datenmodell gibt es **keine Spalte und keinen Fremdschlüssel**, der eine Zugangszeile — die Zeile in `membership` — mit der Einladung verbindet, aus der sie entstanden ist. Wer beide einander zuordnet, tut das über **Konto, Portal und Zeitpunkt**. Das ist eine **begründete Annahme, keine Tatsache** |
| **Was dadurch nicht greift** | Zu einer bestehenden Zugangszeile lässt sich **aus dem Bestand nicht belegen**, aus welcher Einladung sie stammt — und ob sie überhaupt aus einer stammt. Umgekehrt lässt sich zu einer eingelösten Einladung nicht belegen, welchen Zugang sie eröffnet hat. Die Herkunftskette nach K23-M03 hat an dieser Stelle eine Lücke, die kein Prüflauf schließen kann, weil der Wert schlicht nirgends steht |
| **Träger** | **offen** |
| **Annahmeentscheidung** | **liegt nicht vor** |
| **Frist** | **offen** |

### Woran man es sieht — drei Messungen vom 15.08.2026 gegen `freiraum_ci`

**1 · Die Zugangszeile führt vier Spalten. Keine zeigt auf eine Einladung.**

```
$ psql -c "\d membership"
                  Table "public.membership"
    Column    |    Type     | Nullable
--------------+-------------+----------
 actor_id     | uuid        | not null
 portal_code  | portal_code | not null
 role_id      | uuid        | not null
 tenant_scope | uuid        | not null
Foreign-key constraints:
    "membership_actor_id_fkey"     FOREIGN KEY (actor_id)     REFERENCES actor(id)  ON DELETE CASCADE
    "membership_portal_code_fkey"  FOREIGN KEY (portal_code)  REFERENCES portal(code)
    "membership_role_id_fkey"      FOREIGN KEY (role_id)      REFERENCES role(id)   ON DELETE RESTRICT
    "membership_tenant_scope_fkey" FOREIGN KEY (tenant_scope) REFERENCES tenant(id) ON DELETE RESTRICT
```

*(Indizes und Auslöser der Ausgabe hier weggelassen; sie enthalten keinen weiteren Verweis.)*

Vier Fremdschlüssel: Konto, Portal, Rolle, Reichweite. Genau die vier Angaben, die **K20-M04**
verlangt. Die Einladung ist keine davon.

**2 · Im ganzen Zielschema verweist genau eine Tabelle auf `invitation` — und es ist nicht die
Zugangszeile.**

```
$ psql -c "SELECT conname, pg_get_constraintdef(oid) FROM pg_constraint
           WHERE confrelid='invitation'::regclass;"

                conname                 |                     pg_get_constraintdef
----------------------------------------+--------------------------------------------------------------
 invitation_decision_invitation_id_fkey | FOREIGN KEY (invitation_id) REFERENCES invitation(id) ON DELETE SET NULL
(1 row)
```

Eine Zeile. `invitation_decision` ist die Nachweisliste der **Einladungsentscheidungen** aus
M30 — wer eine Einladung veranlasst hat, nicht welchen Zugang sie erzeugt hat.

**3 · Auch im Programmtext taucht der Bezug nirgends auf.**

```
$ grep -rn "invitation_id" schema/ migrations/ install/ app/ werkzeuge/ mail/ seeds/
migrations/M30__pilot_sammelmigration.sql:328:  invitation_id  uuid REFERENCES invitation(id) ON DELETE SET NULL,
```

**Ein einziger Treffer** — die Spalte aus Messung 2. Kein zweiter.

### Warum kein Bauweg das behebt, solange der Bezug fehlt

Der Weg, der beides anlegt, ist gebaut und sauber — und genau deshalb ist der Befund
sichtbar. In `app/einladung_senden.py` legt `_mitgliedschaft_anlegen()` die Zugangszeile an:

```
INSERT INTO membership (actor_id, portal_code, role_id, tenant_scope)
SELECT a.id, r.portal_code, r.id, a.tenant_id …
```

Das Portal kommt aus derselben Größe, die kurz zuvor nach `invitation.portal_code` geschrieben
wurde — die Datei sagt das selbst: *„das Portal der Einladung — dasselbe, das `_anlegen` nach
`invitation.portal_code` schreibt"*. **Dasselbe heißt hier: derselbe Wert, nicht derselbe
Bezug.** Nach dem Vorgang ist nicht mehr unterscheidbar, ob der Wert von dort kam.

Auch der Nachweis in `event` schließt die Lücke nicht. Er trägt zwei getrennte Zeilen mit zwei
verschiedenen Schlüsseln:

| Vorgang | `object_ref` | Fundstelle |
|---|---|---|
| Mitgliedschaft angelegt | `MEMBERSHIP:<actor_id>` | `app/einladung_senden.py`, Aufruf `"MEMBERSHIP:" + str(kennung), "Neuanlage"` |
| Einladung angelegt | `INVITATION:<invitation.id>` | `app/einladung_senden.py`, Aufruf `"INVITATION:" + str(neu[0]), "Neuanlage"` |

*Ohne Zeilennummer, mit Absicht: Die Datei wurde am 15./16.08.2026 in einem parallelen
Arbeitspaket verändert; die Nummern wandern, die Zeichenfolgen nicht. Auffindbar mit
`grep -n 'MEMBERSHIP:\|INVITATION:' app/einladung_senden.py`.*

Beide entstehen in derselben Transaktion, mit derselben handelnden Person, im selben
Augenblick. Wer sie zusammenführt, führt sie über **Zeit und Konto** zusammen — nicht über
einen gemeinsamen Schlüssel. Das trägt, solange nichts dazwischenkommt, und es trägt nicht
mehr, sobald zwei Vorgänge dicht beieinanderliegen, ein Konto zweimal eingeladen wurde
(`attempt` erhöht sich, **K20-M13**) oder der Nachweis nach K15 beschnitten wird.

**Das ist unabhängig davon, welcher Weg gebaut wird.** Ob die Einlösung den Zugang anlegt oder
der Versand, ob über ein Portal oder über zwei: solange die Zugangszeile den Bezug nicht
führt, bleibt die Zuordnung eine Rekonstruktion.

### Was für welche Einstufung spricht

| Für **gering** | Für **kritisch** |
|---|---|
| Der Nachweis in `event` führt beide Vorgänge, in derselben Transaktion, mit derselben handelnden Person. Wer nachrechnet, kommt in der Regel zum richtigen Ergebnis | K23 Abschn. 6 führt **unklare Herkunft** unter den fünfzehn sperrenden Gates. Genau darum geht es hier |
| Es entsteht **kein** unberechtigter Zugang. Der Befund betrifft den Nachweis, nicht die Schranke | **K20-M07** ist eine MUSS-Klausel. Ihre Erfüllung lässt sich an einem bestehenden Bestand nicht zeigen, sondern nur behaupten |

Deshalb der Vorschlag **mittel** — und deshalb die Vorlage an den Auftraggeber statt einer
eigenen Festlegung.

### Der kurze Weg zur Schließung

Eine Spalte `invitation_id uuid REFERENCES invitation(id)` an `membership`, gefüllt in
derselben Transaktion, in der die Zeile entsteht. Einzubringen über eine Migration — das
Grundschema ist eingefroren und wird nicht angefasst. **Ob das in den Umfang bis zum
31.08.2026 gehört, entscheidet dieses Blatt nicht.**

---

## RR-03 · Der Kunden-Code am Nicht-Kunden (B1-F2) bleibt bis nach dem 31.08.2026 offen

| Feld | Wert |
|---|---|
| **Betroffene Klausel** | **K02-G02** — *„Es GILT: Der Kunden-Code ist nur bei der Art Kunde Pflicht. Betreiber und Partner bestehen ohne ihn."* Mitbetroffen: **K02-M25** — *„Der Kunden-Code MUSS fortlaufend von der Plattform vergeben werden. Der erste lautet `DE-AAA`…"* |
| **Kritikalität** | **offen — dieses Blatt stuft nicht ein.** Was feststeht: die Wirkung ist **still** (keine Fehlermeldung), und sie verbraucht mit `DE-AAA` den Code, der nach K02-M25 dem ersten echten Kunden zusteht. Vorschlag: **mittel**, solange die Vergabe nicht gebaut ist |
| **Befund** | **B1-F2**, `nachweise/vorbedingungen/B1_installation/B1_Abnahmeprotokoll.md`, Abschnitt 4: `customer_needs_code` verlangt einen Kunden-Code bei `kind=CUSTOMER`, **aber keine Bedingung verbietet ihn bei den anderen Arten.** Am 15.08.2026 gegen das geltende Zielschema (Grundschema + M30) neu gemessen: unverändert offen, für `OPERATOR` **und** für `PARTNER` |
| **Entscheidung** | **Weg a**, Auftraggeber M. Veil, **15.08.2026**: Die Regeln zum Kunden-Code werden **nicht** in den Umfang des Teilschnitts von Tor II aufgenommen. B1-F2 bleibt damit offen und wird benannt getragen statt behoben |
| **Was dadurch nicht greift** | Ein Kunden-Code kann an einem Betreiber- oder Partner-Mandanten sitzen. Er ist dann **verbraucht**: `tenant_customer_code_key` ist plattformweit eindeutig, und `K02-D06` verbietet die Änderung eines vergebenen Codes. Ob das Zurücknehmen einer irrtümlichen Vergabe eine solche Änderung ist, sagt **keine Klausel** |
| **Träger** | **M. Veil** |
| **Annahmeentscheidung** | **mitgeteilt am 15.08.2026** (Weg a). Ein Entscheidungsblatt liegt in diesem Repo **nicht vor**: `grep -rn "Weg a" arbeit/ nachweise/` → kein Treffer (Stand der Messung: 16.08.2026, 00:10 Uhr; die übrigen Entscheidungen des Tages liegen als eigene Blätter in `arbeit/Vorlagen/`). Bis es vorliegt, ist die Entscheidung **mitgeteilt, nicht belegt** |
| **Frist** | **31.08.2026** — der Endtermin des Bauauftrags. Bis dahin getragen, danach neu vorzulegen. **Nach K23-M04 erlischt eine Annahmeentscheidung mit Fristablauf**; danach wirkt die Klausel wieder, ohne dass es einer neuen Entscheidung bedarf |

### Der zweite Teil des Befundes: Das Prüfskript erzeugt den Schaden selbst

`install/pruefe_b1.sh`, **Zeile 29**, im Negativfall der Zeilen 28 bis 30:

```bash
28  neg "Kunden-Code am Betreiber-Mandanten wird abgewiesen" \
29    "UPDATE tenant SET customer_code='DE-AAA' WHERE kind='OPERATOR';" \
30    "ERROR"
```

Der Fall wird nicht abgewiesen. Er läuft durch, wird **geschrieben** und bleibt geschrieben:
die Hilfsfunktion `neg` ruft `psql` mit einem einzelnen `-c` auf, ohne Transaktionsklammer,
und im ganzen Skript steht kein Zurücksetzen.

Nachgemessen in einer eigens angelegten Wegwerf-Datenbank, die nach der Messung entfernt
wurde:

```
  FEHLGESCHLAGEN  Kunden-Code am Betreiber-Mandanten wird abgewiesen — DURCHGELAUFEN

   kind   |      name       | customer_code
----------+-----------------+---------------
 OPERATOR | exmachinAI GmbH | DE-AAA
```

Und die Folge:

```
ERROR:  duplicate key value violates unique constraint "tenant_customer_code_key"
DETAIL:  Key (customer_code)=(DE-AAA) already exists.
```

**Der erste echte Kunde bekommt seinen Code nicht mehr.** Vollständige Herleitung, alle
Zeilenangaben und die zweite Hälfte des Befundes — der erwartete Grund lautet `ERROR` statt
einer benannten Bedingung — im Blatt **`nachweise/befunde/BEF-G_260815.md`, BEF-G2**.

**Ob der laufende Pilotstand betroffen ist, ist nicht belegt** — er wurde für diese Messung
bewusst nicht angefasst. Die Prüfung ist ein Einzeiler und steht in BEF-G2.

### Zwei Befunde, die nicht verwechselt werden dürfen

| | RR-03 / B1-F2 | BEF-G1 |
|---|---|---|
| Was fehlt | eine **Schranke** an einem vorhandenen Feld | der **Vergabevorgang** selbst |
| Gegenmittel | eine Bedingung in einer Migration | ein gebauter, geprüfter Serverbefehl |
| Getragen? | **ja**, Weg a vom 15.08.2026 | **keine Entscheidung belegt** |

Die Bedingung aus B1-F2 allein würde die Lage kurzfristig verschärfen: sie machte
`customer_needs_code` zur harten Sperre in beide Richtungen, und ein Kundenmandant ließe sich
ohne vergebenen Code gar nicht mehr anlegen — einen vergebenden Weg gibt es nicht. Das ist
kein Argument gegen die Bedingung, sondern eines dafür, sie **zusammen mit** dem Vergabeweg zu
bauen.

---

## Wie diese Liste geführt wird

Sie ist eine **erzeugte Sicht auf einen Datenbestand**, keine von Hand gepflegte Wahrheit
(Blatt 26:59–63). Die 1.231 Klauseln ohne Akzeptanzkriterium und ohne Test stehen im
Klauselregister (`nachweise/klauselregister/register.json`) und werden von dort aus
fortgeschrieben, sobald die Pflegedatei entsteht.

**Hier stehen Restrisiken, die aus einer Entscheidung oder aus einer Lücke im Bestand folgen
statt aus einer bloß fehlenden Prüfung.** RR-01 war der erste und kam ohne Klausel aus.
**Seit dem 15.08.2026 stimmt das nicht mehr für alle Einträge:** RR-02 und RR-03 tragen je
eine benannte Klausel. Das ist kein Widerspruch zur Herkunft dieser Liste, sondern der Grund,
warum sie von Hand geführt bleibt: Für eine Klausel, deren Erfüllung sich am Bestand **gar
nicht zeigen lässt**, erzeugt kein Register einen Eintrag. Er muss geschrieben werden.

---

## Stand der Liste

| | Gegenstand | Träger | Frist | Zustand |
|---|---|---|---|---|
| **RR-01** | Gate 5 ist im Repo nicht mechanisch erzwungen | M. Veil | ereignisgebunden | **geschlossen** am 09.08.2026 |
| **RR-02** | Die Zugangszeile verweist auf keine Einladung | **offen** | **offen** | **offen**, angelegt am 15.08.2026 |
| **RR-03** | Kunden-Code am Nicht-Kunden (B1-F2) | **M. Veil** | **31.08.2026** | **getragen**, Weg a vom 15.08.2026 |

**Die Tor-II-Sperrbedingung lautet: kein kritisches Restrisiko ohne Annahmeentscheidung.**
RR-02 und RR-03 sind **nicht eingestuft**; solange das so bleibt, ist nicht entschieden, ob
sie unter diese Bedingung fallen. Die Einstufung liegt beim Auftraggeber.

---

*Angelegt am 07.08.2026. RR-01 vollständig: Träger M. Veil, Annahmeentscheidung und Frist
gezeichnet am 07.08.2026. Die Frist ist ereignisgebunden, nicht kalendarisch — sie greift mit
dem ersten Mandanten, dessen `tenant.datenart` von `SYNTHETISCH` auf `ECHT` wechselt.*

*RR-02 und RR-03 angelegt am 15.08.2026 auf Weisung des Auftraggebers (Aufträge 9.8 und 10.2
der Arbeitspakete M-7 bis M-10). Jede Datenbankausgabe und jede Zeilenangabe darin ist
gemessen; offene Felder sind als offen ausgewiesen und nicht geraten.*
