# Scheibenabnahmen · der Auslöser für F42

**Eine Abnahme meldet man an, indem hier eine Datei entsteht:**

```
nachweise/scheiben/<kennung>/abnahme.md
```

**Ihr Entstehen ist ein Commit, und an einen Commit kann ein Lauf sich hängen.** Das ist der
ganze Zweck dieses Verzeichnisses. Ohne einen solchen Träger bliebe F42 eine Regel ohne
Schranke — genau wie C-4 es vom 05.08.2026 bis zum 18.08.2026 war: gezeichnet, gültig, und von
keinem Lauf erzwungen.

## Was dann passiert

`werkzeuge/tor3_pflicht.py` läuft in Tor 1a **bei jedem Lauf** und verlangt für jede
angemeldete Scheibe ein Blatt in `nachweise/fremdreview/` mit

- demselben `scheibe`-Wert im Kopf,
- vollständigen Feldern (`geprueft_commit`, `pruefendes_modell`, `datum`, `urteil`, `befunde`),
- `befunde: keine`, falls nichts gefunden wurde — **leer ist zweideutig**,
- und einem `geprueft_commit`, der ein **Vorfahr des Abnahmestandes** ist.

**Die Bindung ist der Punkt.** Ohne sie erfüllt ein beliebiges altes Blatt die Bedingung — das
war AC-16 vor Blatt 89, und der Fehler wird nicht zweimal gemacht.

## Was hier NICHT hineingehört

**Der Harness legt diese Datei nie selbst an.** Eine Abnahme ist eine Willenserklärung; sie
anzumelden ist eine Handlung eines Menschen. Ein Agent, der sie schreibt, meldet eine Abnahme
an, die niemand beschlossen hat.

## Vorlage

Siehe `VORLAGE_abnahme.md` daneben. Das Tor-3-Blatt selbst entsteht nach
`nachweise/fremdreview/VORLAGE.md` — **von einem Menschen, nicht vom Harness**
(`.claude/commands/scheibe.md`:73).
