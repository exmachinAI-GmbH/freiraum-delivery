# Abgelöste Migrationen — nicht anwenden

Nach **F36** wird nichts gelöscht. Was hier liegt, ist **abgelöst**, nicht falsch: es war
richtig für seinen Tag und ist von einer späteren, gemessenen Fassung aufgenommen worden.

**Dieser Ordner wird von Tor 1b nicht eingespielt.** Der CI-Schritt iteriert über
`migrations/*.sql`, nicht über Unterordner.

---

## `260802_anmeldecode.sql` · abgelöst am 07.08.2026

| | |
|---|---|
| **Abgelöst durch** | `migrations/M30__pilot_sammelmigration.sql` |
| **Entschieden** | 07.08.2026, A. Han — *„Ich entscheide wie empfohlen"* |
| **Anlass** | Befund **BEF-C1** aus dem ersten Lauf des Coding-Harness |

### Was der Befund war

Tor 1b spielt jede Migration **zweimal** gegen dieselbe frische Datenbank ein. Der zweite
Lauf brach ab:

```
psql:migrations/260802_anmeldecode.sql:65: ERROR:  relation "login_code" already exists
```

**M1 des Bauauftrags** verlangt wörtlich *„ein zweiter Lauf ändert nichts"*, Tor I
Bedingung 4 *„Migration zweimal, Schema und Daten danach gleich"*. Neun `CREATE`-Anweisungen
waren ungeschützt.

### Warum sie **nicht** abgesichert, sondern abgelöst wurde

M30 führt dieselben Träger — und tut es richtig:

| Träger | hier (02.08.) | M30 |
|---|---|---|
| `login_code` | `CREATE TABLE` | **`CREATE TABLE IF NOT EXISTS`** (M30:191) |
| `mail_delivery` | `CREATE TABLE` | **`CREATE TABLE IF NOT EXISTS`** (M30:287) |
| `mail_kind`, `mail_status` | `CREATE TYPE` ungeschützt | `DO`-Block mit `pg_type`-Prüfung |
| `login_code_entwertet_aeltere_trg` | `CREATE TRIGGER` ungeschützt | `DO`-Block mit `pg_trigger`-Prüfung |

M30 ist **durchgängig wiederholbar**: 20 von 20 Tabellen mit `IF NOT EXISTS`, 31
Existenzprüfungen in `DO`-Blöcken.

**Und M30 ist gemessen.** Der N2-Lauf vom 06.08.2026 gegen
`psql-freiraum-pilot.postgres.database.azure.com` ergab beide Diffs leer, **110 von 110**
Prüffällen, T0–T23 vollständig. Der Abnahmenachweis ist von A. Han gezeichnet, N2 von
M. Veil abgenommen.

**Diese Datei ist dagegen nie im Zielbestand eingespielt worden.** Sie lief am 02.08.2026
einmal gegen eine leere Datenbank und danach nie wieder.

### Die Rangfolge sagt dasselbe

`CLAUDE.md` Abschnitt 1, Rang 1: *„`freiraum_datamodel.sql` **plus** Sammelmigration M30"*.
Das autoritative Zielschema ist die eingefrorene Basis plus M30 in der Fassung mit der
Prüfsumme aus dem gezeichneten N2-Nachweis. Eine zweite Datei, die dieselben Tabellen
anlegt, wäre eine konkurrierende Quelle für Rang 1 — und sie würde driften.

### Was stattdessen im Repo liegt

| Datei | Prüfsumme | stimmt überein mit |
|---|---|---|
| `migrations/M30__pilot_sammelmigration.sql` | `1af077c540f910d3871ad3b459c5bdeff51034274cbb6b680c065eb3fd2fac4d` | dem gezeichneten Abnahmenachweis vom 06.08.2026 |
| `pruefungen/migration/M30__pruefung.sql` | `fc2a2341eea474aaa6637083d127d79ecc073b6c5615a1d8e314d133e032d319` | ebenda |

Beide sind **Kopien**. Die Originale liegen in
`ITERATION_2/02_AGENT_HARNESS_KONZEPTE/ITERATION_2/entscheidungsvorlagen/final_entscheidung-pflichtangaben/uebergabe/migration/`
und werden dort gepflegt. **Weicht eine Prüfsumme ab, ist die Kopie ungültig — nicht das
Original.**

---

## `pruefe_anmeldecode.sh` · abgelöst am 07.08.2026

Die vier Negativfälle zu `260802_anmeldecode.sql`. Sie sind in `M30__pruefung.sql`
aufgegangen, das mit **110 Prüffällen** gegen den Zielbestand gelaufen ist.

**Der Inhalt bleibt lesenswert.** Das Skript trägt die Lehre aus Migration 260801: *drei von
vier Negativfällen scheiterten am Codeformat statt an der Zielregel* — ein bestandener Test,
der nichts misst. Genau daraus ist die Regel geworden, dass ein Negativfall erst dann
bestanden ist, wenn er **an seiner eigenen Bedingung** scheitert, mit der Meldung im
Wortlaut (Bauauftrag §9 Tor I Nr. 6).

---

*Angelegt am 07.08.2026 nach Befund BEF-C1. Entscheidung A. Han, ausgeführt vom
Orchestrator.*
