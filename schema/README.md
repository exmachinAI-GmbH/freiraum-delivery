# schema/ · Grundwahrheit für Tor 1b

`freiraum_datamodel.sql` ist die **eingefrorene v2.9-DDL** — Rang 1 der Rangfolge, sie
gewinnt jeden Konflikt (`CLAUDE.md`).

**Es ist eine Kopie, kein Original.** Das Original liegt in
`ITERATION_2/01_KNOWLEDGE_REPO/v2.9_PIVOT/freiraum_datamodel.sql` und wird **nie geändert**.
Die Kopie liegt hier, weil Tor 1b die Migration gegen eine frische Datenbank fährt und ein
CI-Lauf nicht auf die Dropbox zugreift — ein Lauf gegen eine Quelle, die er nicht selbst
mitbringt, ist nicht reproduzierbar.

| | |
|---|---|
| Herkunft | `01_KNOWLEDGE_REPO/v2.9_PIVOT/freiraum_datamodel.sql` |
| Prüfsumme bei Aufnahme | siehe `schema/freiraum_datamodel.sha256` |
| Änderungsregel | **keine.** Weicht die Prüfsumme vom Original ab, ist die Kopie ungültig — nicht das Original |
