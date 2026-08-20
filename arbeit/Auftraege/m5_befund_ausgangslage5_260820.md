# Fünfter Befund — die letzte Pflichtspalte, und eine Berichtigung an dir

**20.08.2026 · Nachbesserungsauftrag an den Prüf-Agenten.**

## Was getragen hat — und es ist viel

Die Ausgangslage **steht jetzt bis Abschnitt 8**. Gemessen nach dem Laden:

| | erwartet | gemessen |
|---|---|---|
| Konten | 16 | **16** |
| Eignungs-Checks | 14 | **14** |
| Anwendungen | 13 | **13** |

**Deine neue Zählung in Abschnitt 10 (j) ist genau das, was gefehlt hat.** Der stille
Fehlschlag ist damit zu.

## Der Mangel — und es ist der letzte seiner Art

```
psql:pruefungen/klauseln/gespraech_daten.sql:361: ERROR:  null value in column
  "model_ref_id" of relation "agent" violates not-null constraint
```

**Zwei Angaben dazu, damit du dafür keine weitere Runde brauchst:**

1. Im **Startbestand** liegen bereits **sechs** Zeilen in `model_ref`. Du musst also keine
   anlegen — es genügt, auf eine zu zeigen (etwa mit einer Unterabfrage statt einer
   festgeschriebenen Kennung, dann bleibt die Datei wiederholbar).
2. **Dein `EXCEPTION`-Block hat hier nicht getragen.** Er fängt `undefined_table` und
   `undefined_column` — die Ausnahme, die tatsächlich kam, ist `not_null_violation`. Deine
   Absicht war richtig (die Zeile soll den Lauf nicht umwerfen, wenn die Tabelle anders
   aussieht als angenommen); der Fangkorb war nur zu eng.

> **Und das ist nachgemessen die letzte Lücke dieser Art.** Ich habe **alle** Tabellen, in
> die deine Datei schreibt, gegen ihre Pflichtspalten gehalten: `actor`, `app`, `fit_check`,
> `membership`, `tenant` sind **vollständig**. Nur `agent` fehlt diese eine Spalte. Danach
> läuft die Ausgangslage durch, soweit es Pflichtspalten betrifft.

## Eine Berichtigung — sie betrifft eine Aussage in **deiner** Datei

Du hast im vorigen Durchgang beanstandet, `K01-M27` und `O-K01-6` seien unbelegt, und das in
`gespraech_deckung.md` eingetragen. **Das ist zur Hälfte falsch, und es sollte dort nicht so
stehen bleiben:**

| | |
|---|---|
| **K01-M27** | ist eine **echte, freigegebene Klausel** — `260801_FREIRAUM_K01_Rahmenkonzept_v1.3.md:77`, mit gezeichnetem fachlichem Eigentümer (A. Han, 16.08.2026). **Nicht gezeichnet ist allein ihr Akzeptanzkriterium.** Du hast „Kriterium ungezeichnet" mit „Klausel unbelegt" verwechselt |
| **Richtig war** | dass sie **nicht** zu deinen 101 M5-Klauseln gehört. Sie gehört zu M4 |
| **O-K01-6** | ist ein **offener Punkt der Konzept-Fabrik**. Er kommt hier nur in der Migration, ihrer Prüfung und den N2-Schemabelegen vor — von diesem Repo aus nicht aufschlagbar, dieselbe Lage wie `O-K23-7`. **Nicht belegbar** ist nicht dasselbe wie **unbelegt** |

**Bitte zieh die Stelle in `gespraech_deckung.md` entsprechend nach.** Deine Beanstandung war
berechtigt und richtig aufgeschrieben — sie war nur an einem Punkt zu scharf. Dass du sie
überhaupt erhoben hast, war richtig: der Bau hatte sie ungeprüft übernommen.

## Die Grenze — unverändert

- **Ändere nichts an der fachlichen Aussage eines Falles.**
- **Senke keinen Prüfwert und lockere keine Erwartung** (K23-D05).
- **Nimm keinen Fall stillschweigend heraus.**
