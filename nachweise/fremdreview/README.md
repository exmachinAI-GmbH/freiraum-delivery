# `nachweise/fremdreview/` · Tor 3 — der fremde Blick

Hier liegt **nicht** das Review. Hier liegt der **Nachweis, dass es stattgefunden hat**.

Der Unterschied ist der ganze Sinn dieses Verzeichnisses.

## Warum Tor 3 nicht wie Tor 1 gebaut werden darf

> **Nachtrag vom 15.08.2026 — wann gefragt wird.** Bis heute war das Verbot verankert und
> die Sperre auch, ein **aktives Nachfragen** aber nicht. Der Harness verweigerte, ohne zu
> fragen: `pruefungen/tor3.sh` meldete *gesperrt* in einem Prüfbericht, und ob jemand das
> las, hing davon ab, dass ein Mensch zum richtigen Zeitpunkt hinsah. Das Ergebnis ist
> gemessen: Tor 3 ist bis zum 15.08.2026 **kein einziges Mal** mit einem gültigen Blatt
> gelaufen — nicht aus Ablehnung, sondern weil nie ein Moment kam, in dem die Frage
> gestellt wurde.
>
> Seither gilt: **`/scheibe` hält vor der Vorlage an und stellt die Frage ausdrücklich**,
> und **jede Tages-Übergabe führt die Zeile `fremdreview.py --stand`**.
>
> **Auslöser ist die Scheibenabnahme** — so zeichnet es C-4: *„einmal je Scheibenabnahme,
> nicht je Änderung."* **Ausnahme: M10, M11 und M12**, die keiner Scheibe angehören
> (BS:125, *„Prüf- und Abnahmespur — quer, keine Scheibe"*); für sie löst die
> Meilensteinabnahme aus. **Nicht bei jedem Meilenstein** — Scheibe 2 schließt M3 und M4,
> und dreimal dieselbe Frage macht sie billig.
>
> Beides ist **Steuerung, nicht Abnahme**: kein Tor wird verschärft, keine
> Abnahmebedingung kommt hinzu (Blatt 11:182–188).

`CLAUDE.md` führt vier Tore. Für Tor 3 steht in der Spalte *Wo* seit dem 07.08.2026 der
Eintrag **„außerhalb dieses Harness"**, und `.claude/commands/scheibe.md` sagt es in
Schritt 10 ohne Umschweife:

> *„Fremdmodell anfordern (Tor 3, einmal je Scheibenabnahme, C-4): frische Instanz,
> getrennter Kontext, Prüfung gegen **Roh-Evidenz**, nicht gegen Erklärungen des Baus.
> **Der Harness schreibt dieses Review nie selbst.**"*

Das ist keine Bequemlichkeit, sondern die Schutzregel. Ein Fremdmodell, das der Harness
selbst aufruft, dessen Ausgabe er selbst ablegt und dessen Ergebnis er selbst auswertet, ist
kein fremder Blick mehr — es ist derselbe Blick mit einem anderen Etikett. Tor 3 lebt davon,
**in einem anderen Vertrauensbereich zu liegen**.

Dieselbe Erwägung trägt die Anlage „Bauverfahren": sie liegt außerhalb dieses Repos, weil
`install.sh --pruefsumme` den Kopf der `CLAUDE.md` *gegen* sie rechnet. Lägen beide hier,
änderte ein Commit beide Seiten und die Prüfung ginge immer auf.

## Was hier trotzdem hereingehört

Bis zum 14.08.2026 hinterließ ein durchgeführtes Tor-3-Review im Repo **nichts**. Es war
verbindlich beschrieben — an vier Stellen — und von nichts belegt:

| Fundstelle | Was dort steht |
|---|---|
| `CLAUDE.md:75` | Tor 3 · *fremd* · Roh-Evidenz · frische Instanz je Scheibenabnahme (C-4) |
| `CLAUDE.md:96`, `:213` | Zeichnungseinheit · die fünf Fragen des Fremdmodells |
| `.claude/commands/scheibe.md:73` | Schritt 10 — Anweisung an einen Agenten, kein Gate |
| `.github/workflows/tore.yml:9` | *„Tor 3 (Fremdmodell) … läuft außerhalb dieser Datei"* |

Das ist derselbe Befund, den `BEF-E1` für den UI-Vertrag festhält: **eine Vorgabe, die
niemand prüft, wird von nichts durchgesetzt.**

Die Auflösung ist nicht, das Review hereinzuholen — sondern **seinen Nachweis**. Das Urteil
entsteht draußen, in einem fremden Vertrauensbereich. Herein kommt ein abgelegtes,
prüfsummiertes Blatt, das sagt: welches Modell, welche Fassung, welcher Commit, welche
Scheibe, gegen welche Roh-Evidenz, mit welchen Fundstellen, und wer es angefordert hat.

## Der Ablauf

```
  Scheibenabnahme steht an
        │
        ├─▶ 1  Mensch fordert das Review an — frische Instanz, getrennter Kontext
        │      Der Harness tut das nicht. Er darf es nicht.
        │
        ├─▶ 2  Fremdmodell prueft gegen ROH-EVIDENZ:
        │      Quelltext · Migrationen · Prueflaufausgaben · Manifest
        │      NICHT gegen Bauberichte, Zusammenfassungen oder diese README
        │
        ├─▶ 3  Mensch legt das Urteil hier ab:
        │      nachweise/fremdreview/<scheibe>_<JJMMTT>.md
        │      und zeichnet den Kopf — Modell, Fassung, Commit, Herkunft
        │
        ├─▶ 4  werkzeuge/fremdreview.py prueft das BLATT, nicht das Urteil
        │      └─ unvollstaendig ─▶ GESPERRT (K23-M22), nie gruen
        │
        └─▶ 5  pruefungen/tor3.sh meldet den Stand je Scheibe
               └─ kein Blatt ─▶ GESPERRT · Scheibenabnahme erreicht Tor 4 nicht
```

## Was das Werkzeug prüft — und was es nicht kann

`werkzeuge/fremdreview.py` prüft **die Form des Nachweises**, nie die Richtigkeit des
Urteils. Ein Werkzeug, das ein Fremdurteil bewertet, wäre wieder der eigene Blick.

**Geprüft wird:**

| | Beleg |
|---|---|
| Alle Kopffelder gefüllt | dieses Blatt, Abschnitt *Pflichtangaben* |
| Prüfendes Modell **und Fassung** genannt | K23-M18 Glied 6 führt Modellstände; ein Prüfer ohne Fassung ist kein Stand |
| Frische Instanz ausdrücklich bejaht | C-4, Blatt 26:30 |
| Getrennter Kontext ausdrücklich bejaht | `scheibe.md`:73 |
| Gegen Roh-Evidenz, mit benannter Evidenz | `CLAUDE.md`:75 |
| Der geprüfte Commit existiert im Repo | sonst beschreibt das Blatt einen Stand, den es nicht gibt |
| Fundstellen im Urteil | Präzedenz Blatt 26:2 — *„80 Zeilen mit Fundstellen"* |
| Anforderung durch einen **Menschen**, gezeichnet | `scheibe.md`:73 — der Harness schreibt es nie selbst |
| Nebendatei mit Prüfsumme stimmt | wie bei jeder Grundwahrheit hier |

**Nicht geprüft — und ausdrücklich nicht prüfbar:**

- **Ob das Review wirklich von einem fremden Modell stammt.** Das kann keine Maschine
  feststellen. Es steht als gezeichnete Aussage eines Menschen im Kopf des Blattes, und
  diese Unterschrift ist der Beleg — nicht eine Prüfung.
- **Ob das Urteil zutrifft.** Das ist die Sache von Tor 4.
- **Ob wirklich gegen Roh-Evidenz geprüft wurde.** Das Blatt benennt die Evidenz; ob der
  Prüfer sie gelesen hat, weiß nur er.

Ein Nachweis kann belegen, dass etwas stattfand. Er kann nicht belegen, dass es gut war.

## Pflichtangaben je Blatt

Siehe `VORLAGE.md`. Der Kopf ist eine YAML-artige Tabelle, damit ihn ein Werkzeug lesen kann,
ohne das Urteil zu berühren.

## Was passiert, wenn kein Blatt vorliegt

`pruefungen/tor3.sh` meldet **GESPERRT** — nach K23-M22 ausdrücklich *nicht* fehlgeschlagen
und *nicht* grün: nicht gemessen ist nicht bestanden. Eine Scheibenabnahme mit gesperrtem
Tor 3 erreicht Tor 4 nicht (K23-D01).

**Tor 3 ist kein Pflichtcheck je Pull Request.** C-4 im Wortlaut: *„Das Fremdmodell kommt
**einmal je Scheibenabnahme**, nicht je Änderung."* Ein Gate, das bei jeder Änderung
anschlüge, würde entweder umgangen oder billig erfüllt — beides schlechter als kein Gate.
Der Lauf hängt deshalb am Etikett `scheibenabnahme` und an `workflow_dispatch`.
