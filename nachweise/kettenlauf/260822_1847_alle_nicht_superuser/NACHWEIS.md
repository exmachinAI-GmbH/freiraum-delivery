# FREIRAUM · Kettenlauf — Nachweis · alle fünf Belege bestanden

Dieses Blatt trägt Messwerte, keine Unterschrift. Es entsteht aus
`migrations/kettenlauf.sh`. Wer zeichnet, entscheidet ein Mensch.

## Was gefahren wurde

| Feld | Wert |
|---|---|
| Lauf am | 22.08.2026 18:47 |
| Umfang | `--umfang alle` — alle Dateien aus migrations/*.sql (Lesart B) |
| Vorläufer 260801 eingespielt | nein — wie im gezeichneten Lauf `n2_lauf.sh` |
| Verbindung | Wirt: 127.0.0.1 · Port: 5432 · Datenbank: kette_alle · Konto: frx · sslmode: ⟨nicht angegeben⟩ |
| War es die Zielumgebung? | **VON DER ZEICHNENDEN PERSON EINZUTRAGEN** |
| Prüfsummen der Eingänge nachgerechnet | ja |
| Belegordner | `/home/claude/freiraum-delivery/migrations/kettenlauf_belege_alle_260822_1847` |

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
| `M31__projektnummer_und_zweckbestimmung.sql` | `d7fedad9d89352308a68bf0a9df3ba8b17b7b62ff43b7e19813479d2bdc8fb79` |
| `M32__zeilenschutz_und_stufenwechsel.sql` | `6bac64bda3f021eaaf0ccf911474edada044cae81b41de6dd1a532b895633522` |

## Ergebnis je Beleg

Genau ein Zustand je Beleg, aus vier zulässigen Werten (K23-M22 — die
Klausel, die je Prüfung bestanden, fehlgeschlagen, gesperrt oder nicht
ausgeführt zulässt). Was nicht gemessen werden konnte, heisst *gesperrt*,
nicht *bestanden*.

| | Beleg | Zustand | Ergebnis | Rohbeleg |
|---|---|---|---|---|
| 0 | Grundschema und Vorläufer | **bestanden** | Grundschema eingespielt; Vorläufer nicht verlangt (wie n2_lauf.sh) | `lauf0_grundschema.log` |
| 1 | Lauf 1 verändert etwas, Lauf 2 verändert nichts | **bestanden** | Lauf 1 hat gewirkt: 3276 Zeile(n) Unterschied im Schema-Abzug, 166 im Daten-Abzug; nach Lauf 2 beide diffs leer, 3 Migration(en) je zweimal; verglichen wurden 82 Datenzeile(n), so viele wie die Datenbank trägt | `erstlauf_schema_diff.txt` · `erstlauf_daten_diff.txt` · `schema_diff.txt` · `daten_diff.txt` · `daten_zeilen_lauf1.txt` · `daten_zeilen_lauf2.txt` |
| 2 | Prüffälle | **bestanden** | SUMME: 111 von 111 bestanden, 0 gescheitert | `pruefung_ausgabe.log` · `summe.txt` |
| 3 | Gegentest-Meldungen einzeln festgehalten | **bestanden** | 111 Meldungen bei 111 Fällen -- zu LESEN, nicht zu zählen | `gegentest_meldungen.txt` |
| 4 | Eingefrorene Prüffälle T0 bis T23 | **bestanden** | T0 bis T21 je genau einmal ohne Abweichung; T22 und T23 mit Ersatz-Setup; Zeilen vorher = nachher (tenant 0 actor 0 membership 0 invitation 0 fit_check 0 app 0 event 0) | `t0_t23_ergebnis.txt` · `t22_t23_ergebnis.txt` · `beleg4_zeilen_diff.txt` |
| 5 | Objektzahlen gemessen | **bestanden** | tabellen 57 sichten 12 trigger 27 funktionen 29 davon_mit_suchpfad 29 enums 44 rollen 6  | `objektzahlen.txt` |

## Was dieses Blatt nicht ist

Es ist keine Freigabe, keine Abnahme und keine Zeichnung. Beleg 3 ist zu
**lesen**, nicht zu zählen: die Anzahl der Meldungszeilen sagt nichts
darüber, ob jeder Gegentest an seiner eigenen Bedingung gescheitert ist.

## Wer gezeichnet hat

| Name | Rolle | Datum | Unterschrift |
|---|---|---|---|
| ⟨ ⟩ | für den Auftragnehmer | ⟨ ⟩ | ⟨ ⟩ |
| ⟨ ⟩ | für den Auftraggeber | ⟨ ⟩ | ⟨ ⟩ |
