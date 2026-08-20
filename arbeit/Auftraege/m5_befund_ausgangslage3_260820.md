# Dritter Befund — und eine Frage, die größer ist als die Fehlerzeile

**20.08.2026 · Nachbesserungsauftrag an den Prüf-Agenten.**

## Was getragen hat

**Die Reihenfolge stimmt jetzt.** Der EIGNUNGSRIEGEL greift nicht mehr; deine Konstruktion
über `fit_check_id` und das Nachziehen in Abschnitt 7b ist durchgekommen. Auch der
Spaltenname, den du aus K01-G05 abgeleitet hast, war richtig.

## Der neue Mangel

```
psql:pruefungen/klauseln/gespraech_daten.sql:270: ERROR:  null value in column
  "project_no" of relation "app" violates not-null constraint
```

## Die größere Frage — bevor du die Spalte füllst

**Deine eigene Klausel K01-M27 sagt, dass eine Anwendung nur über den Serverbefehl
entsteht.** Deine Ausgangslage legt `app`-Zeilen aber **von Hand** an, mit `INSERT`.

Genau daran läufst du auf: Die Zeile trägt Pflichten, die **der Serverbefehl** erfüllt, nicht
du. Du hast sie jetzt zweimal einzeln nachgereicht — die Verknüpfung, gleich die Nummer — und
es ist nicht gesagt, dass es die letzte ist. **Jede Runde kostet einen ganzen Lauf.**

**Deshalb die Frage, und sie ist deine, nicht meine:**

> Ist eine von Hand geschriebene `app`-Zeile überhaupt die richtige Ausgangslage für M5 —
> oder muss die Ausgangslage **durch dieselbe Tür entstehen, durch die sie im Betrieb
> entsteht**?

Dein Vorbild `zweckbestimmung_daten.sql` beantwortet die Frage für sich selbst schon einmal,
und zwar ausdrücklich: *„Der Katalog der drei Eignungsfragen ist STARTBESTAND DES BAUS. Diese
Datei fasst ihn NICHT an. Der Lauf liest ihn und fährt damit den Weg."* Und weiter: *„Die
Zweckbestimmung selbst legt diese Datei NIRGENDS an. Sie ist der Prüfgegenstand."*

**Zwei Wege stehen dir offen. Wähle einen und begründe ihn:**

| | |
|---|---|
| **A** | Die Ausgangslage legt weiter `app`-Zeilen von Hand an. Dann trägst du **alle** Pflichten der Zeile selbst — und wir zählen sie einzeln durch, Runde für Runde |
| **B** | Die Ausgangslage legt **keine** `app`-Zeile an. Sie stellt nur Mandanten, Konten, Mitgliedschaften und Eignungs-Checks bereit; die Anwendungen fährt `gespraech_lauf.sh` **durch die Tür** herbei, so wie eine Nutzerin es täte — und misst dabei gleich mit, ob das geht |

> **B ist nicht nur bequemer, es misst mehr.** Eine von Hand gesetzte Ausgangslage kann einen
> Zustand herstellen, den der Bau über seine Türen **gar nicht erreichen kann** — und dann
> misst der Fall etwas, das es nicht gibt. Aber: **B kann Fälle unerreichbar machen**, deren
> Ausgangslage über keine Tür herstellbar ist. Die gehören dann nach K23-M22 auf **GESPERRT
> mit Begründung**, nicht weggelassen.

**Entscheide das aus deinen Klauseln.** Wenn du B wählst und dabei Fälle verlierst, ist das
ein Ergebnis und kein Fehler — schreib es in `gespraech_deckung.md`.

## Die Grenze — unverändert

- **Ändere nichts an der fachlichen Aussage eines Falles.**
- **Senke keinen Prüfwert und lockere keine Erwartung** (K23-D05).
- **Nimm keinen Fall stillschweigend heraus.** Was unerreichbar wird, wird **GESPERRT mit
  Begründung**, nicht gelöscht.
