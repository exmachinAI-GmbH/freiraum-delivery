# Vierter Befund — zwei Pflichtspalten auf einmal, und ein stiller Fehlschlag

**20.08.2026 · Nachbesserungsauftrag an den Prüf-Agenten.**

## Was getragen hat

`project_no` ist durch. Deine Entscheidung für Weg A ist eingetragen und begründet — das ist
in Ordnung, sie ist deine. Auch dein Hinweis, dass `K01-M27` und `O-K01-6` **nicht** zu den
101 gezeichneten Klauseln gehören, stimmt und ist notiert; die Riegelmeldung der Datenbank
zitiert dort etwas Ungezeichnetes, und das ist ein eigener Befund gegen den Bau, nicht gegen
dich.

## Der Mangel — und diesmal beide auf einmal

```
psql:pruefungen/klauseln/gespraech_daten.sql:290: ERROR:  null value in column "name"
  of relation "app" violates not-null constraint
```

Und unmittelbar danach, mit einer eigenen Probe vorweggenommen, damit du dafür keine weitere
Runde brauchst:

```
null value in column "created_at" of relation "app" violates not-null constraint
```

**Damit sind es genau diese beiden. Danach ist der `INSERT` vollständig** — ich habe es gegen
eine Wegwerfkopie geprobt: mit `name`, `created_at` und dem, was du schon nennst, geht die
Zeile durch.

> **Was ich dir bewusst NICHT gegeben habe:** das Zielschema, die Tabellendefinition, die
> Prüfbedingungen der Tabelle oder irgendetwas über das Verhalten der Anwendung. Was oben
> steht, ist die Antwort der Datenbank auf **deine eigene Anweisung** — dieselbe Auskunft, die
> du sonst in zwei weiteren Runden Zeile für Zeile bekommen hättest, nur in einer.

## Die fachliche Frage, die dahintersteckt — sie ist deine

Du setzt `name` für die sechs Anwendungen in der Stufe ORIENTIERUNG **absichtlich auf NULL**.
Deine Kommentare sagen warum: der Name entsteht erst im Gespräch.

**Die Datenbank lässt das nicht zu.** Damit stehen zwei Möglichkeiten offen, und du
entscheidest, welche zutrifft:

| | |
|---|---|
| **1** | Es ist nur die **Ausgangslage**, die einen Platzhalter braucht. Dann setz einen erkennbaren (nicht „" und nicht etwas, das wie ein echter Name aussieht) und schreib in den Kommentar, dass er Ausgangslage ist und **kein Prüfgegenstand** |
| **2** | Es ist ein **WIDERSPRUCH**: eine Klausel verlangt, dass der Name erst später entsteht, die Tabelle verlangt ihn von Anfang an. Dann melde `WIDERSPRUCH` mit beiden Nummern — so, wie deine Rolle es vorsieht — und trag ihn in `gespraech_deckung.md` ein |

**Rate nicht. Sieh in deinen Klauseln nach**, ob eine von ihnen den Zeitpunkt des Namens
festlegt. Wenn ja, ist es Fall 2. Wenn keine es tut, ist es Fall 1.

## Der stille Fehlschlag — das ist der wichtigere Punkt

Beim Lauf ohne Abbruch bei erstem Fehler ist Folgendes gemessen worden:

| | |
|---|---|
| **`app`-Zeilen nach dem Laden** | **0** |
| **`fit_check`-Zeilen** | 14 |
| **Deine AUFBAUPRUEFUNG in Abschnitt 10** | **hat nicht angeschlagen** |

**Eine Ausgangslage, die keine einzige Anwendung anlegt, ist durchgelaufen, ohne zu
widersprechen.** Wäre der Fehler nur eine Warnung gewesen, hätte danach ein voller Prüflauf
stattgefunden, dessen Fälle allesamt nichts vorgefunden hätten — und einige davon hätten
womöglich **bestanden**, weil „nichts da" und „richtig leer" von außen gleich aussehen.

Das ist genau der Fehler vom 02.08.2026 in neuer Gestalt: ein Lauf, der besteht und nichts
misst.

**Zu tun:** Deine Aufbauprüfung muss die Ausgangslage **zählen**, nicht nur stichprobenartig
nachsehen. Sie muss abbrechen, wenn die erwartete Zahl an Anwendungen, Konten,
Mitgliedschaften und Eignungs-Checks nicht steht — mit dem Wort `ABBRUCH` in der Meldung,
damit der Orchestrator es erkennt.

## Die Grenze — unverändert

- **Ändere nichts an der fachlichen Aussage eines Falles.**
- **Senke keinen Prüfwert und lockere keine Erwartung** (K23-D05).
- **Nimm keinen Fall stillschweigend heraus.** Was unerreichbar wird, wird **GESPERRT mit
  Begründung**.
