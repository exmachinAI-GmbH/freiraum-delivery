# freiraum-delivery

Ausführbarer Code der FREIRAUM-Bauseite (Pilot-Vorbedingungen B1–B3, später Delivery &
Verification Harness). **Gerüst, Stand 02.08.2026 — noch nichts umgesetzt.**

## Einordnung

| | |
|---|---|
| Konzeptlage | Konzept-Fabrik ITERATION_2 (Dropbox), 24 exportierte Konzepte v2.9 — dort wird nichts mehr verändert |
| Bauauftrag | `arbeit/Bauauftrag_Pilot-Vorbedingungen.md` (Konzeptfabrik) — B1 Installation, B2 Mailversand, B3 Testdomäne |
| Harness-Plan | `03_AGENT_HARNESS_CODING/260731_FREIRAUM_Delivery_Verification_Harness_Plan_v1.0.md` |
| Doku/Nachweise | Dropbox `ITERATION_2/03_AGENT_HARNESS_CODING/` — Abnahmeprotokolle, Dossiers, Evidenzen |
| Ground Truth | `freiraum_datamodel.sql` (v2.9-DDL) — gewinnt jeden Konflikt; kein Konzept und kein Agent beschließt eine Spalte |

**GitHub ist Wahrheit.** Kein Klonen in Dropbox/iCloud. Doku-Nachweise liegen bewusst in der
Dropbox, Code bewusst hier — nichts doppelt pflegen.

## Struktur

| Ordner | Inhalt (geplant) |
|---|---|
| `install/` | B1 — Installationsskript: Betreiber-Mandant, Erst-Admin `EXMA-ADM-0001`, Mitgliedschaft |
| `mail/` | B2 — Versand-Anbindung (EU-Verarbeitung, F05), Zustellnachweis |
| `migrations/` | versionierte Migrationen; Eingang: `Migration_260801_tenant.sql` aus der Konzeptfabrik |
| `seeds/` | Seed-Läufe; Eingang: `Seed_Welle1_M1-M4.sql` aus der Konzeptfabrik |

## Eiserne Regeln

1. **Keine Secrets im Repo.** `.env*` ist gitignored; Zugänge in Key Vault/Passwortmanager.
2. **Eigene Datenbank je Pilot-Anlauf** — `sealed` ist unumkehrbar (K20-M21).
3. **Nur synthetische Daten** in Entwicklung und Abnahme; kein Produktivbetrieb vor RLS
   (Harness-Plan §6: die v2.9-DDL hat noch keine RLS-Policies).
4. Die vier Negativfälle jeder Migration **müssen scheitern**, bevor sie als angewendet gilt.
5. Verarbeitung in der EU (F05); ein Dienst außerhalb bricht K13.
