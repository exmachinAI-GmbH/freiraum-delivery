# Formvermerk · der Bau-Agent hat `pruefungen/lauf.sh` angefasst

**20.08.2026**

## Die Regel, von der abgewichen wurde

`CLAUDE.md` Abschn. 6:

> *„**Als Bau-Agent eine Datei unter `pruefungen/` anfassen.** Auch nicht ‚nur den Tippfehler'."*

## Die Weisung, im Wortlaut

> **„Zieh den trap in lauf.sh nach"**

Vorausgegangen war der Hinweis des Harness, dass die Änderung eine Prüfdatei betrifft, die der
Bau-Agent nicht anfasst, und deshalb **entweder dem Prüf-Agenten gehört oder eine Weisung
braucht**. Die Weisung ist erteilt worden.

## Was geändert wurde — und was ausdrücklich nicht

| | |
|---|---|
| **Geändert** | ein Riegel auf Skriptebene, der Server und Mailfänger abräumt, wenn der Lauf **nicht ordentlich zu Ende kommt** (Strg-C, SIGTERM, Zeitablauf) — dazu ein zweiter Riegel gegen verwaiste Server, begrenzt auf das, was **während** der Laufzeit dazugekommen ist |
| **Nicht geändert** | kein Prüffall · keine Erwartung · keine Schwelle · keine Kritikalität · kein Zustand · keine Zählung · keine Ausgabe des Laufs |

## Der Nachweis, dass keine Messung berührt ist

Derselbe Lauf, vor und nach der Änderung, gegen eine frische Datenbank:

| | vor (`tor1c_260820e`) | nach (`tor1c_260820h`) |
|---|---|---|
| Prüfpunkte | 17 bestanden · 0 fehlgeschlagen · 5 gesperrt | **gleich** |
| Einzelfälle | 144 bestanden · 0 fehlgeschlagen · 132 gesperrt | **gleich** |

**Die Ziffern sind identisch.** Der Riegel läuft erst, wenn der Lauf schon vorbei oder
abgebrochen ist.

## Was der Riegel kann und was nicht

**Gemessen:** Wird der Lauf von außen mit `SIGTERM` abgebrochen, blieben vorher Server und
Mailfänger stehen; jetzt gehen beide weg.

**Die eigentliche Ursache liegt woanders, und sie bleibt offen.**
`pruefungen/klauseln/anmeldung_lauf.sh` startet uvicorn in einer Unterschale —
`( cd "$REPO" … uvicorn ) &` — und `$!` liefert die Nummer der **Unterschale**, nicht die des
Servers. Wird die Unterschale beendet, bleibt der Server als Waise stehen. **So sind bis zum
20.08.2026 41 Prozesse aufgelaufen, der älteste acht Tage alt.**

Das ist ein Mangel an einer **Prüffalldatei**. Er gehört dem Prüf-Agenten, und die Weisung
deckt ihn nicht — sie nannte `lauf.sh`. Der zweite Riegel **grenzt ihn ein**, er behebt ihn
nicht: er räumt am Ende ab, was während der Laufzeit dazugekommen ist, und lässt alles in
Ruhe, was vorher schon lief. **Gemessen an einem Server, der absichtlich vorher gestartet
wurde: er hat den Lauf überlebt.**

---

*Der Anlass und die Grenze stehen hier, damit später nachvollziehbar ist, warum eine Datei
unter `pruefungen/` einen Commit des Bau-Agenten trägt. Die Vorlage für diese Form ist
`formvermerk_uebertragene_kreuze_260816.md`.*

---

# Zweiter Eingriff am selben Tag — die Fehlermeldung der Negativfälle

**20.08.2026, abends.**

## Die Weisung, im Wortlaut

Auf die Vorlage der drei sofort möglichen Berichtigungen aus dem Tor-3-Bericht — darunter
ausdrücklich der Hinweis, der dritte betreffe `pruefungen/` und brauche deshalb eine Weisung:

> **„Ja, mach die drei"**

## Was geändert wurde

| | |
|---|---|
| **`merke()`** | maskiert die drei Felder jetzt für JSON. Vorher wurde die Zeile durch bloßes Aneinanderhängen gebaut — ein Anführungszeichen in der Anmerkung hätte den Bericht unlesbar gemacht. Es fiel nicht auf, weil bis dahin keine Anmerkung eines führte |
| **Erfolgszweig der Negativfälle** | zieht die erste `ERROR`-Zeile aus der Ausgabe, druckt sie und gibt sie an `merke()` weiter. Vorher stand dort nur `scheitert an $erwartet` — also der Name, den die Datei **selbst** als erwartete Bedingung führt |

## Warum das kein Schönheitsfehler war

`CLAUDE.md`:180-182, gezeichnete Grundlage Bauauftrag §9 Tor I Nr. 6 und `README.md`:204:

> *„Ein Negativfall gilt erst als bestanden, wenn er an seiner eigenen Bedingung scheitert;
> **die Fehlermeldung im Wortlaut ist Teil der Evidenz**."*

Der Lauf behauptete, jeder Fall scheitere an seiner eigenen Bedingung — und warf den einzigen
Beleg dafür weg. **Gefunden hat es Tor 3 am 20.08.2026, nicht dieser Harness.**

## Der Nachweis, dass keine Messung berührt ist

| | vorher | nachher |
|---|---|---|
| Prüfpunkte | 17 · 0 · 5 | **gleich** |
| Einzelfälle | 144 · 0 · 132 | **gleich** |
| Bericht als JSON lesbar | ja | **ja** — mit Anführungszeichen in jeder der zwölf Anmerkungen |

Alle zwölf Negativfälle tragen jetzt ihre Meldung, zum Beispiel:

```
M30_N1_frist_ge_mindestfrist — scheitert an frist_ge_mindestfrist
   psql:…/M30_N1_frist_ge_mindestfrist.sql:15: ERROR:  new row for relation
   "retention_rule" violates check constraint "frist_ge_mindestfrist"
```

**Damit ist F07 für diese zwölf Fälle zum ersten Mal belegt und nicht nur behauptet.**
