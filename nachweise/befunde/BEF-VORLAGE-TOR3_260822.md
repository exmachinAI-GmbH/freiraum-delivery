# BEF-VORLAGE-TOR3 · Die Tor-3-Vorlage führte ein Pflichtfeld nicht

| | |
|---|---|
| **Gefunden** | 22.08.2026, beim ersten Einsatz von Tor 3 mit einem gültigen Blatt |
| **Betrifft** | `nachweise/fremdreview/VORLAGE.md` gegen `werkzeuge/tor3_pflicht.py`:132 |
| **Art** | Widerspruch zwischen Vorlage und Prüfer. **Behoben** |

---

## Was passiert ist

Für die Abnahme der Scheibe `fundament` wurde ein Tor-3-Blatt nach `VORLAGE.md` angelegt.
Der Kopf wurde vollständig nach der Vorlage ausgefüllt — alle zwölf Felder.

**Tor 1a brach ab:**

```
Error: Scheibe fundament: fundament_260822.md fuehrt kein Feld `befunde`.
       Wurde nichts gefunden, muss 'keine' dastehen -- ein leeres Feld ist zweideutig
Error: F42: 1 Scheibe(n) ohne tragenden Tor-3-Nachweis — GESPERRT, nicht abgenommen
```

**Die Vorlage führte `befunde` nicht.** Der Prüfer verlangt es. Wer die Vorlage benutzt und
sonst alles richtig macht, scheitert.

## Warum das nicht auffiel

Das Feld steht in `nachweise/fremdreview/README.md` — dort werden die Pflichtfelder aufgezählt:
*„vollständigen Feldern (`geprueft_commit`, `pruefendes_modell`, `datum`, `urteil`,
`befunde`)"*. Es steht also im Haus, nur nicht dort, wo man beim Ausfüllen hinsieht.

**Tor 3 war bis zum 15.08.2026 kein einziges Mal mit einem gültigen Blatt gelaufen** (README,
Nachtrag vom 15.08.). Eine Vorlage, die nie benutzt wird, veraltet unbemerkt — der Prüfer wuchs
weiter, die Vorlage nicht.

## Was geändert wurde

`VORLAGE.md` führt das Feld jetzt, an derselben Stelle wie im Prüfer, mit einem Hinweiskasten
darunter: was der Prüfer verlangt, was er meldet, wenn es fehlt, und warum leer nicht genügt.

## Was daraus folgt — nicht mitentschieden

Der Fall ist klein, aber er hat ein Muster: **Eine Vorlage und ein Prüfer beschreiben dieselbe
Sache an zwei Orten.** Solange beide von Hand gepflegt werden, laufen sie auseinander, und der
Fehler zeigt sich erst dem, der die Vorlage benutzt.

Zwei Wege, keiner davon hier entschieden:

- **A** — bei Änderungen am Prüfer die Vorlage mitziehen, als Gewohnheit
- **B** — die Vorlage aus den Pflichtfeldern des Prüfers **erzeugen**, sodass sie nicht
  auseinanderlaufen können

*Der Harness legt das vor. Entschieden wird es von einem Menschen.*

---

*Angelegt am 22.08.2026. Der Fehler ist beim ersten scharfen Einsatz von Tor 3 aufgetreten —
nicht beim Lesen, sondern beim Benutzen. Das ist die Art Fehler, die eine Vorlage nur so
findet.*
