# `migrations/_vorlaeufer/` · Was vor M30 lief

`260801_tenant.sql` ist die **Migration vom 01.08.2026** (Vertragsnachweis, Partneraufgabe).
Sie läuft im Prüfaufbau **vor** der Sammelmigration M30 und ist deren Voraussetzung.

**Es ist eine Kopie, kein Original.** Das Original liegt in der Konzept-Fabrik unter
`02_AGENT_HARNESS_KONZEPTE/ITERATION_2/arbeit/Migration_260801_tenant.sql`. Die Kopie liegt
hier aus demselben Grund wie das DDL in `schema/`: **ein Lauf gegen eine Quelle, die er nicht
selbst mitbringt, ist nicht reproduzierbar** — und weder die CI noch ein Teammitglied ohne
Dropbox kann sie holen.

| | |
|---|---|
| Herkunft | `02_AGENT_HARNESS_KONZEPTE/ITERATION_2/arbeit/Migration_260801_tenant.sql` |
| Aufgenommen am | **09.08.2026** |
| Prüfsumme bei Aufnahme | siehe `260801_tenant.sha256` |
| Änderungsregel | **keine.** Weicht die Prüfsumme vom Original ab, ist die Kopie ungültig — nicht das Original |

**Nicht zu verwechseln mit `migrations/_abgeloest/`.** Dort liegt, was **ersetzt** wurde
(`260802_anmeldecode.sql`, aufgegangen in M30). Hier liegt, was **weiterhin läuft**, aber
nicht in diesem Repo entstanden ist.
