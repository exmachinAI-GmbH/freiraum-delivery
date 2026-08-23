# Prüfauftrag · M3 · EN-03a Direkt-Prototyp-Check

| Feld | Wert |
|---|---|
| An | Prüf-Agent (blind) · Tor 2 |
| Von | Bau-Agent |
| Datum | 23.08.2026 |
| Gegenstand | Der Direkt-Prototyp-Check: fünf Fragen, Auswertung, Vorschlag, zwei Weiterwege |
| Zweig | `scheibe/m3-schnellweg` |

## Rollengrenze

**Schreiben Sie die Fälle allein aus den Klauseln und der Wegetabelle unten.** Der Umsetzungscode (`app/schnellweg.py`, `app/schnellweg_regel.py`, `app/vorlagen/en03a_fragen.html`) ist für diesen Auftrag nicht zu lesen. Gibt eine Klausel keinen messbaren Maßstab her, schreiben Sie **„NICHT PRÜFBAR aus der Klausel"** und nennen, welche Angabe fehlt. Bitte nicht raten.

Führen Sie den Lauf unter `blindstand.sh` — die Lesesperre ist vorhanden, aber an keinen Lauf angeschlossen (offener Punkt V-13). Wer sie nicht ausdrücklich benutzt, arbeitet ohne sie.

**Ein Lauf zur Zeit.** Befund BEF-NEBENLAUF-1: zwei gleichzeitige Prüfläufe erschlagen einander die Server und erzeugen rote Fälle, die keine sind.

## Wegetabelle

| Weg | Erwartung |
|---|---|
| `POST /vorpruefung/starten` | Erfolg → 303 auf `/schnellweg`. Legt **genau einen** `quick_check` an: Mandant und Konto aus der Sitzung. Trägt der Bestand nicht genau fünf Fragen zu je drei Antworten, wird **nichts angelegt**: 200, Verbleib auf EN-03, benannte Meldung, `[Überspringen]` bleibt bedienbar |
| `GET /schnellweg` | Ohne Sitzung → 303 `/anmeldung`. Ohne laufenden Vorgang → 303 `/vorpruefung`. Sonst 200 mit **genau einer** Frage und **genau drei** Antwortmöglichkeiten. Ändert nichts |
| `POST /schnellweg/antwort` | Felder `frage`, `option`. Erfolg → 303 `/schnellweg`. Eine bestehende aktive Antwort derselben Frage wird **zurückgenommen** (`superseded_at`), nie gelöscht. Passt die Antwort nicht zur Frage: 200, **nichts geschrieben**, benannte Meldung |
| `POST /schnellweg/abbruch` | 303 `/vorpruefung`. **Kein Vorschlag**, `completed_at` bleibt leer |
| `POST /schnellweg/arbeitsdokument` | 200, Verbleib, benannte Meldung. **Kein** `direct_prototype`, **keine** `app`-Zeile |
| `POST /schnellweg/vorpruefung2` | Liegt kein Ergebnis vor: 200, nichts angelegt. Sonst 303 `/eignung`, legt genau einen `fit_check` an |

## Zu messende Klauseln

| Klausel | Was zu messen ist |
|---|---|
| **K04-M22** | Genau fünf Fragen. Je Frage genau drei Antwortmöglichkeiten. Je Antwort eine Zuordnung. Kein Freitextfeld auf dem Bildschirm |
| **K04-M23** | Zeigt die Verbindlichkeitsfrage auf *Anwendung* oder die Ergebnisfrage auf *„etwas, das ich aufrufe und in dem ich arbeite"*, lautet der Vorschlag **Anwendung** — unabhängig von allen übrigen Antworten |
| **K04-M24** | Zwei oder drei Treffer in den Fragen 2 bis 4 → Anwendung. Ein Treffer → Direkt-Prototyp, **und die abweichende Antwort wird genannt**. Kein Treffer → Direkt-Prototyp |
| **K04-M25** | Jeder Vorschlag trägt **genau einen** Begründungssatz, und er nennt eine Antwort im Wortlaut |
| **K04-D11** | Fehlt eine Antwort oder scheitert die Auswertung: Vorschlag **Anwendung**, nie Direkt-Prototyp, und der Grund wird genannt |
| **K04-M03** | Der Weg Arbeitsdokument ist auch **gegen** den Vorschlag wählbar und nicht ausgegraut |
| **K19-M06** | Solange eine Frage offen ist, sind beide Weiterwege **ausgeblendet** — nicht ausgegraut. An ihrer Stelle steht ein Hinweis, der die offene Frage **im Wortlaut** nennt, nicht ihre Nummer |
| **K19-M03** | Genau eine Zugangsmarke auf dem Bildschirm |
| **K01-M15 · K02** | Ein Vorgang eines fremden Mandanten gilt als nicht vorhanden — Zwei-Mandanten-Lesetest |

## Kontrollzahl für K04-M23 und K04-M24

K04 v1.7 Abschn. 5.0 sagt: von 243 Antwortkombinationen führen **22** zum Vorschlag *Direkt-Prototyp*, und zwar ausnahmslos solche, bei denen Frage 5 auf *keine Verbindlichkeit* und Frage 1 nicht auf *arbeiten in* zeigt. Diese Zahl ist ein Maßstab, gegen den sich der ganze Auswerter blind messen lässt.

## Was ausdrücklich NICHT gemessen werden soll

- **EN-12 und der Träger `direct_prototype`.** Nicht gebaut. Der Weg ist benannt gesperrt; ein roter Fall dafür wäre keiner.
- **Die Herkunft des Wortlauts.** Sie ist gezeichnet (K04 v1.7 Abschn. 5.0, Founder 01.08.2026, siehe BEF-K04-1).

## Zwei offene Punkte, die den Maßstab berühren

| | |
|---|---|
| **O-M3-5** | `quick_option` hat keine Spalte für die Zuordnung. Der Bau trägt sie als Endung `__dok`/`__app` am `value_token`. Ist das für die Messung von K04-M22 tragfähig oder nicht prüfbar? Bitte ausweisen, nicht entscheiden (BEF-K04-2) |
| **O-K19-11** | K04-M02 sagt „höchstens fünf", K04-M22 sagt „genau fünf". Der Bau zeigt fünf fest. Ein Fall für einen adaptiven Abbruch vor Frage 5 wäre **nicht prüfbar aus der Klausel** |
