# FREIRAUM · Kettenlauf — Nachweis · ABGEBROCHEN

Dieses Blatt trägt Messwerte, keine Unterschrift. Es entsteht aus
`migrations/kettenlauf.sh`. Wer zeichnet, entscheidet ein Mensch.

## Was gefahren wurde

| Feld | Wert |
|---|---|
| Lauf am | 22.08.2026 17:20 |
| Umfang | `--umfang m30` — nur M30 (Lesart A) |
| Vorläufer 260801 eingespielt | nein — wie im gezeichneten Lauf `n2_lauf.sh` |
| Verbindung | Wirt: 127.0.0.1 · Port: 5432 · Datenbank: freiraum_kette · Konto: freiraum · sslmode: ⟨nicht angegeben⟩ |
| War es die Zielumgebung? | **VON DER ZEICHNENDEN PERSON EINZUTRAGEN** |
| Prüfsummen der Eingänge nachgerechnet | ja |
| Belegordner | `/home/claude/freiraum-delivery/migrations/kettenlauf_belege_m30_260822_1720` |

> **Den Umfang von M1 hat dieser Lauf nicht entschieden.** Die beiden Lesarten
> stehen in `arbeit/Vorlagen/m1_startklar_260820.md`:98–100, die Zeichnungszeile
> in derselben Datei:119, die Unterschriftszeilen in derselben Datei:143–144.
> Der Lauf hat gefahren, was ihm über `--umfang` gesagt wurde, und schreibt es
> hier auf. Ob der gefahrene Umfang der gezeichnete ist, prüft ein Mensch am
> Blatt — nicht dieses Skript.

## Prüfsumme jeder eingespielten Datei

| Datei | SHA-256 |
|---|---|
| `freiraum_datamodel.sql` | `cb37d5fe6ef7652458eb6f6cf2b201400aa6e5ff61b2396800bf5b4e48e46e96` |
| `M30__pilot_sammelmigration.sql` | `1af077c540f910d3871ad3b459c5bdeff51034274cbb6b680c065eb3fd2fac4d` |

## Ergebnis je Beleg

Genau ein Zustand je Beleg, aus vier zulässigen Werten (K23-M22 — die
Klausel, die je Prüfung bestanden, fehlgeschlagen, gesperrt oder nicht
ausgeführt zulässt). Was nicht gemessen werden konnte, heisst *gesperrt*,
nicht *bestanden*.

| | Beleg | Zustand | Ergebnis | Rohbeleg |
|---|---|---|---|---|
| 0 | Grundschema und Vorläufer | **bestanden** | Grundschema eingespielt; Vorläufer nicht verlangt (wie n2_lauf.sh) | `lauf0_grundschema.log` |
| 1 | Migration zweimal, Schema und Daten unverändert | **bestanden** | beide diffs leer, 1 Migration(en) je zweimal | `schema_diff.txt` · `daten_diff.txt` |
| 2 | Prüffälle | **fehlgeschlagen** | SUMME: 108 von 111 bestanden, 3 gescheitert — Folge von Lesart A, siehe Abbruchtext | `pruefung_ausgabe.log` · `summe.txt` |
| 3 | Gegentest-Meldungen einzeln festgehalten | **fehlgeschlagen** | Lauf endete hier | siehe Bildschirmausgabe |
| 4 | Eingefrorene Prüffälle T0 bis T23 | **nicht ausgeführt** | — | — |
| 5 | Objektzahlen gemessen | **nicht ausgeführt** | — | — |

## Was dieses Blatt nicht ist

Es ist keine Freigabe, keine Abnahme und keine Zeichnung. Beleg 3 ist zu
**lesen**, nicht zu zählen: die Anzahl der Meldungszeilen sagt nichts
darüber, ob jeder Gegentest an seiner eigenen Bedingung gescheitert ist.

## Wer gezeichnet hat

| Name | Rolle | Datum | Unterschrift |
|---|---|---|---|
| ⟨ ⟩ | für den Auftragnehmer | ⟨ ⟩ | ⟨ ⟩ |
| ⟨ ⟩ | für den Auftraggeber | ⟨ ⟩ | ⟨ ⟩ |
