# Befund an **deinen eigenen Dateien** — der Lauf startet nicht

**20.08.2026 · Nachbesserungsauftrag an den Prüf-Agenten.**

## Was dieser Befund ist — und was er nicht ist

Hier steht **kein** Testergebnis, **kein** Verhalten der Anwendung und **keine** Meldung aus
dem Umsetzungscode. Hier steht genau ein Mangel an **deinen eigenen Dateien**, der dazu
führt, dass **kein einziger Fall zur Ausführung kommt**.

Deine Blindheit bleibt unberührt. Du erfährst hier nichts über den Bau.

## Der Mangel

`pruefungen/klauseln/gespraech_daten.sql` wird von `psql` abgewiesen, **bevor die erste Zeile
wirkt**:

```
psql:pruefungen/klauseln/gespraech_daten.sql:65: ERROR:  invalid input syntax for type uuid:
  "00000000-0000-4000-8000-0000000ea01"
LINE 2:   ('00000000-0000-4000-8000-0000000ea01','OPERATOR','Pruefbe...
             ^
```

**Die Ursache ist systematisch, nicht einzeln.** Eine UUID hat die Form
`8-4-4-4-**12**` Hexzeichen. Deine Kennungen haben in der **letzten** Gruppe **elf**.
Gemessen über beide Dateien:

| Datei | UUID-Literale mit 11 Zeichen in der letzten Gruppe | mit 12 (richtig) |
|---|---|---|
| `pruefungen/klauseln/gespraech_daten.sql` | **130** | 0 |
| `pruefungen/klauseln/gespraech_lauf.sh` | **32** | 2 |

## Was zu tun ist

1. **Alle** UUID-Literale in beiden Dateien auf die Form `8-4-4-4-12` bringen.
2. Die Zuordnung muss erhalten bleiben: **dieselbe Kennung in beiden Dateien bleibt
   dieselbe.** Wird aus `…-0000000ea01` etwa `…-0000000ea010`, dann überall.
3. Die Kennungen müssen **untereinander verschieden** bleiben — zwei Zeilen dürfen nicht
   durch das Auffüllen dieselbe Kennung bekommen.

## Die Grenze dieses Auftrags

- **Ändere nichts an der fachlichen Aussage eines Falles.**
- **Senke keinen Prüfwert und lockere keine Erwartung**, damit etwas besteht (K23-D05).
- **Nimm keinen Fall heraus** und wandle keinen in `GESPERRT`, um den Lauf glatt zu bekommen.
- Behebe **nur**, was den Lauf am Starten hindert.

> Findest du beim Nachbessern einen **weiteren** Mangel derselben Art — etwas, das die Datei
> nicht ausführbar macht —, behebe ihn mit und nenne ihn am Ende. Findest du etwas, das eine
> **fachliche** Entscheidung verlangt, behebe es **nicht**, sondern nenne es.
