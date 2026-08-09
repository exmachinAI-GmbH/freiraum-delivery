# freiraum-delivery

Coding-Harness der FREIRAUM-Bauseite: ausführbarer Code, Prüfstrecke und die Nachweise
darüber.

## Anfangen

**Voraussetzungen:** Docker (die Prüfdatenbank läuft im Container) · Python 3.11 ·
**ein Postgres-Client** (`psql`). Ohne `psql` bricht `pruefungen/lauf.sh` ohne Meldung ab —
siehe `nachweise/befunde/BEF-D_260809.md`, BEF-D3.

```bash
brew install libpq && brew link --force libpq     # macOS; oder postgresql-client
git clone <repo> && cd freiraum-delivery
python3 -m venv .venv && .venv/bin/pip install -r requirements.txt
./aufbau.sh            # Pruefumgebung: DDL, Vorlaeufer 260801, M30, Seed, B1
```

### Zwei Datenbanken, und sie sind nicht dasselbe

| | Name · Port | gebaut aus | wofür |
|---|---|---|---|
| **Prüfumgebung** | `freiraum` · 55432 | DDL + `_vorlaeufer/260801` + M30 + Seed + B1 | entwickeln, B1/B2 nachvollziehen |
| **Tor 1b** | `freiraum_ci` · 55433 | DDL + `migrations/*.sql` — ohne Vorläufer, ohne Seed | `pruefungen/lauf.sh`, dasselbe wie in der CI |

```bash
./aufbau.sh --ci
PGHOST=localhost PGPORT=55433 PGUSER=postgres PGDATABASE=freiraum_ci bash pruefungen/lauf.sh
```

**Warum getrennt:** 260801 führt `customer_needs_avv` ein; die M30-Prüffälle legen einen
Kunden ohne AVV an und werden dagegen abgewiesen. Gegen DDL+M30 laufen sie **110 von 110**.
Bis zum 09.08.2026 baute `freiraum_ci` nur die CI — Tor 1b war lokal nicht nachvollziehbar
(`nachweise/befunde/BEF-D_260809.md`, BEF-D4).

**Mehr ist nicht nötig.** Seit dem 09.08.2026 bringt das Repo alle Eingaben selbst mit — es
gibt keinen Pfad mehr in eine Dropbox und keinen auf einen bestimmten Rechner. Wer klonen
kann, kann bauen.

## Einordnung

| | |
|---|---|
| Konzeptlage | Konzept-Fabrik ITERATION_2, 24 exportierte Konzepte v2.9 — dort wird nichts mehr verändert |
| Ground Truth | `schema/freiraum_datamodel.sql` (v2.9-DDL) **plus** `migrations/M30__pilot_sammelmigration.sql` — gewinnt jeden Konflikt; kein Konzept und kein Agent beschließt eine Spalte |
| Nachweise | **hier**, unter `nachweise/` — Klauselregister, Manifeste, Restrisiken, Herkunft, Vorbedingungen B1–B3, Befunde |
| Gezeichnete Verfassung | Anlage „Bauverfahren" — **bewusst außerhalb dieses Repos**, siehe unten |

**GitHub ist Wahrheit.** Kein Klon in Dropbox oder iCloud.

### Warum zwei Dinge trotzdem außerhalb liegen

| | Warum |
|---|---|
| **Anlage „Bauverfahren"** und ihre Zeichnung | `install.sh --pruefsumme` rechnet den Kopf der `CLAUDE.md` **gegen** die Anlage. Lägen beide hier, änderte ein einziger Commit beide Werte und die Prüfung ginge immer auf. Ihr Wert besteht darin, dass die Seiten in verschiedenen Vertrauensbereichen liegen |
| **Zugangsblatt** (Namen, Adressen) | git vergisst nicht: eine Redaktion bliebe für immer in der Historie und in jedem Klon. Was zum **Arbeiten** nötig ist, steht ohne Personenbezug in `nachweise/rollen.md` |

## Struktur

| Ordner | Inhalt |
|---|---|
| `install/` | B1 — Betreiber-Mandant, Erst-Admin `EXMA-ADM-0001`, Mitgliedschaft |
| `mail/` | B2 — Versand-Anbindung (EU-Verarbeitung, F05), Zustellnachweis |
| `schema/` | die eingefrorene v2.9-DDL als Kopie mit Prüfsumme |
| `migrations/` | `M30__pilot_sammelmigration.sql` · `_vorlaeufer/` (was davor lief) · `_abgeloest/` (was ersetzt wurde) · `negativfaelle/` |
| `seeds/` | Seed Welle 1 als Kopie mit Prüfsumme |
| `pruefungen/` | Prüffälle — **nur der Prüf-Agent schreibt hier** |
| `werkzeuge/` | `klauselregister.py` |
| `nachweise/` | Klauselregister · Manifeste · Restrisiken · Herkunft · **Rollen** · **Vorbedingungen B1–B3** · **Befunde** · Pilot-Anläufe |
| `doku/` | Grundlagen, die nicht hier entstanden sind |

**Die drei mitgelieferten Eingaben sind Kopien, keine Originale** (`schema/`,
`migrations/_vorlaeufer/`, `seeds/`). Jede trägt ihre Prüfsumme bei Aufnahme und einen
Herkunftsvermerk; `aufbau.sh` rechnet sie vor jedem Lauf nach. **Änderungsregel: keine** —
weicht eine ab, ist die Kopie ungültig, nicht das Original.

## Eiserne Regeln

1. **Keine Secrets im Repo.** `.env*` ist gitignored; Zugänge in Key Vault/Passwortmanager.
2. **Eigene Datenbank je Pilot-Anlauf** — `sealed` ist unumkehrbar (K20-M21).
3. **Nur synthetische Daten** in Entwicklung und Abnahme; kein Produktivbetrieb vor RLS
   (Harness-Plan §6: die v2.9-DDL hat noch keine RLS-Policies).
4. Die vier Negativfälle jeder Migration **müssen scheitern**, bevor sie als angewendet gilt.
5. Verarbeitung in der EU (F05); ein Dienst außerhalb bricht K13.
