# `migrations/_werkzeug/` — SQL, das keine Migration ist

**In einem Satz:** Hier liegt SQL, das die Prüfläufe brauchen, das aber **niemals** als
Migration eingespielt werden darf.

## Warum es diesen Ordner gibt

`migrations/*.sql` ist an drei Stellen ein Suchmuster für **alle Migrationen**:

* `migrations/kettenlauf.sh` — beim Umfang `alle`;
* `.github/workflows/tore.yml`:330, :360 und :447 — im automatischen Prüflauf.

Das Muster fasst **keine Unterordner**. Eine Hilfsdatei, die direkt in `migrations/` läge,
würde von allen vier Stellen als Migration eingespielt. Deshalb dieser Ordner — nach dem
Vorbild von `_vorlaeufer/` und `_abgeloest/`, die aus demselben Grund einen Unterstrich
tragen.

## Was hier liegt

| Datei | Wozu | Wer ruft sie |
|---|---|---|
| `pruefklammer.sql` | klammert eine Prüfdatei in `BEGIN … ROLLBACK`, damit der Lauf keine Prüfdaten in der Datenbank zurücklässt | `migrations/kettenlauf.sh`, Beleg 4 |

## Was hier nicht hingehört

Alles, was das Schema ändert. Eine Datei in diesem Ordner wird von keinem Prüflauf
automatisch eingespielt — eine Migration, die hier landet, liefe nie.
