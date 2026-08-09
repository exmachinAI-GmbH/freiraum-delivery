# seeds/ · Seed-Läufe

`Seed_Welle1_M1-M4.sql` ist **Welle 1**: 8 Quellen, 6 Bausteine, 12 Vorlagen, 2 Richtlinien.
Sie wird von `aufbau.sh` als Schritt 5 geladen.

**Es ist eine Kopie, kein Original.** Das Original liegt in der Konzept-Fabrik unter
`02_AGENT_HARNESS_KONZEPTE/ITERATION_2/arbeit/Seed_Welle1_M1-M4.sql`. Die Kopie liegt hier
aus demselben Grund wie das DDL in `schema/`: **ein Lauf gegen eine Quelle, die er nicht
selbst mitbringt, ist nicht reproduzierbar** — und weder die CI noch ein Teammitglied ohne
Dropbox kann sie holen.

| | |
|---|---|
| Herkunft | `02_AGENT_HARNESS_KONZEPTE/ITERATION_2/arbeit/Seed_Welle1_M1-M4.sql` |
| Aufgenommen am | **09.08.2026** |
| Prüfsumme bei Aufnahme | siehe `Seed_Welle1_M1-M4.sha256` |
| Änderungsregel | **keine.** Weicht die Prüfsumme vom Original ab, ist die Kopie ungültig — nicht das Original |

## Regeln beim Laden

Nach dem Laden **Vier-Augen-Prüfung je Baustein nach K14**, erst dann verdrahten.
Ausschließlich synthetische Daten. Die 15 Gesprächsvorlagen bleiben inhaltsleer, bis
**O-K25-2** entschieden ist — *wo der Inhalt einer Vorlage liegt, wenn `template` kein
Inhaltsfeld hat*. Der Punkt steht im Handover vom 07.08. als **MV-E2** und sperrt V4.
