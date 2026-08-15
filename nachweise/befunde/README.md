# `nachweise/befunde/` · Befunde am Bau

Je Befundlauf ein Blatt. Ein Befund wird **benannt und getragen**, nicht stillschweigend
behoben — K23-M04 verlangt für jede Klausel ohne belegenden Test eine einzelne Zeile mit
Träger und Annahmeentscheidung; für Befunde am Code gilt dasselbe Prinzip.

| Blatt | Datum | Woher |
|---|---|---|
| `BEF-C_260807.md` | 07.08.2026 | erster Tor-1-Lauf des Coding-Harness |
| `BEF-D_260809.md` | 09.08.2026 | Neuzuschnitt der Ablage |
| `BEF-E_260814.md` | 14.08.2026 | Aufnahme des UI-Vertrags nach K19 |
| `BEF-M3_260815.md` | 15.08.2026 | Bau der Vorprüfung, Meilenstein M3 |
| `BEF-G_260815.md` | 15.08.2026 | Kunden-Code: Vergabe und Umfang von Tor II (Aufträge 10.5 und 10.2) |

**Ein Befund gilt erst als erledigt, wenn der Lauf, der ihn gefunden hat, ihn nicht mehr
findet** — nicht, wenn jemand sagt, er sei behoben.

## Zur Vergabe der Kennungen

Zwei Reihen laufen nebeneinander, und sie dürfen nicht verwechselt werden:

- **Blattbuchstaben** `BEF-C` · `BEF-D` · `BEF-E` · `BEF-G` — je ein Blatt, fortlaufend nach
  Datum. Der Buchstabe **`F` ist übersprungen**: die Befunde des Installationsprotokolls
  heißen bereits `B1-F1` und `B1-F2`, und `BEF-F2` daneben wäre eine Verwechslung mit Ansage.
- **Meilensteinkennungen** wie `BEF-M3`, `BEF-B2`, `BEF-L2` — benannt nach dem Meilenstein
  oder Lauf, aus dem sie stammen. Die Nummern **M10, M11, M12** sind für Meilensteine
  vergeben; ein Befundblatt trägt sie deshalb nicht.

**Vor der Vergabe einer neuen Kennung wird gemessen, welche schon belegt sind:**

```
grep -rhoE "(BEF-[A-Za-z0-9]+-?[0-9]+|B[0-9]-F[0-9]+)" --exclude-dir=.git . | sort -u
```

Am 06.08.2026 ist in diesem Projekt eine Kennungskollision real eingetreten. Der Zweizeiler
oben kostet weniger als ihre Auflösung.
