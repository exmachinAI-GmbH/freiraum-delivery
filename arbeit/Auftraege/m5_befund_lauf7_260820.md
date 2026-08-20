# Siebter Befund — **eine Zeile.** Der Lauf bricht ab, bevor er seine Summe druckt

**20.08.2026 · Nachbesserungsauftrag an den Prüf-Agenten.**

## Was getragen hat

**Die Ausgangslage lädt sauber durch.** Kein Fehler, keine Beanstandung deiner
Aufbauprüfung. `gespraech_daten.sql` ist fertig.

**Und `gespraech_lauf.sh` läuft** — er fährt seine Fälle, von oben bis fast nach unten.

## Der Mangel

```
pruefungen/klauseln/gespraech_lauf.sh: line 2068: NAME_QUELLE: unbound variable
```

Zeile 2068:

```bash
if [ -s "$ARBEIT/$NAME_QUELLE.rumpf" ] 2>/dev/null; then
```

**`NAME_QUELLE` wird nur in einem Zweig gesetzt.** Wird dieser Zweig nicht durchlaufen, ist
die Variable nie belegt — und `set -u` bricht die Datei an dieser Stelle ab.

**Du machst es an jeder anderen Stelle richtig:** Zeile 964 (`${NAME_QUELLE:-}`) und Zeile
1334 (`[ -n "${NAME_QUELLE:-}" ] && [ -n "${NAME_FELD:-}" ]`) sind geschützt. Die Zeilen
970–1014 stehen im `else`-Zweig von 964 und sind damit ebenfalls sicher. **Zeile 2068 ist die
einzige ungeschützte Verwendung im ganzen Lauf** — nachgemessen über die Datei.

## Warum das mehr wiegt als eine Zeile

**Ohne Summenzeile kann der Orchestrator deinen Lauf nicht einordnen.** Er liest am Ende

```
davon GESPERRT (…): <n>
SUMME: <a> von <b> bestanden, <c> gescheitert
```

und entscheidet daran, ob er **gesperrt** oder **fehlgeschlagen** meldet. Fehlt die Zeile,
zählt er den ganzen Lauf als **Fehlschlag** — auch dann, wenn kein einziger Fall
fehlgeschlagen ist. Genau das ist eben passiert.

> **Ein Abbruch vor der Summe macht aus einem ehrlichen „gesperrt" ein falsches
> „fehlgeschlagen".** Beides ist nicht bestanden — aber es sind zwei verschiedene Aussagen
> (K23-M22), und die eine beschuldigt den Bau, während die andere ihn nur nicht misst.

## Was zu tun ist

1. Zeile 2068 so schützen, wie du es an den anderen Stellen tust.
2. **Dieselbe Frage einmal für den ganzen Lauf stellen:** Gibt es eine weitere Stelle, an der
   der Lauf abbrechen kann, **bevor** die Summe gedruckt wird? Der Fall, den du gerade
   erwischt hast, entsteht immer dann, wenn ein **früher** Schritt nicht zustande kommt und
   ein **später** Fall dessen Ergebnis ohne Schutz benutzt.
3. Prüf, ob die Summenzeile auch dann noch gedruckt wird, wenn `gesperrt` gleich 0 ist —
   `[ "$gesperrt" -gt 0 ] && printf …` gibt bei 0 den Rückgabewert 1 zurück, und unter
   `set -e` kann das die Datei beenden.

## Die Grenze — unverändert

- **Ändere nichts an der fachlichen Aussage eines Falles.**
- **Senke keinen Prüfwert und lockere keine Erwartung** (K23-D05).
- **Nimm keinen Fall stillschweigend heraus.** Ein Fall, dessen Voraussetzung nicht zustande
  kam, gehört auf **GESPERRT mit Begründung** — nicht weg und nicht auf bestanden.
