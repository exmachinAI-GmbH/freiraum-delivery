**Dateien (alle unter `pruefungen/`, sonst nichts angefasst):**
- `/Users/mveil/freiraum-delivery/pruefungen/klauseln/zweckbestimmung_daten.sql` (neu)
- `/Users/mveil/freiraum-delivery/pruefungen/klauseln/zweckbestimmung_lauf.sh` (neu, ausführbar)
- `/Users/mveil/freiraum-delivery/pruefungen/migration/M30__pruefung.sql` (MT-95b eingefügt, vor MT-96)
- `/Users/mveil/freiraum-delivery/pruefungen/migration/M30__pruefung.sha256` (neu gebildet: `11d91289a8d42e43c6c7dc7d56ae4879da637aa524c784f50d484eca8833232d`, 65 Byte wie zuvor — sonst nennt das Manifest eine Prüfsumme, die nicht zur Datei gehört)

**bash -n, wörtlich:**
```
$ bash -n pruefungen/klauseln/zweckbestimmung_lauf.sh
== bash -n pruefungen/klauseln/zweckbestimmung_lauf.sh: keine Ausgabe, Rueckgabewert 0 ==
```
Keine Ausgabe, Rückgabewert 0. `shellcheck` ist auf dieser Maschine nicht vorhanden.

---

## Der Grundzug: nichts wird geraten

K19_screens.yaml nennt Aktionen und Serverbefehle, aber **keine Adressen**. Wer sie rät, misst einen 404 — eine fremde Bedingung. Der Lauf fährt deshalb wie eine Nutzerin und leitet die Ziele aus dem **Unterschied dreier Fahrten** ab:

| Ziel | abgeleitet als |
|---|---|
| Weiter | das Ziel, das erst mit der **zweiten** Antwort erscheint |
| Kenntnisnahme | das Ziel, das es nur nach Treffer in Frage 1 gibt |
| Anlage | das Ziel, das es nur beim freien Weg gibt |

Die Ableitung **ist** die Messung: erscheint „Weiter" schon bei einer Antwort, fällt F5 durch; erscheint „Anlage" schon vor der Kenntnisnahme, fällt F2 durch. Ist ein Ziel nicht eindeutig, meldet jeder Fall, der es braucht, `sperr`.

Ebenso werden die zwei Fragen nicht am Wortlaut erkannt (K04-M19 zeichnet keinen Satz), sondern an den Merkmalen, die die Klausel selbst nennt. „Bildung" und „bewerten" stehen in **beiden** Aufzählungen und sind mit Absicht **nicht** unter den Merkmalen.

## Die Fälle

| Nr. | Regel | Was er misst | Warum er scheitern kann |
|---|---|---|---|
| ZB-01 | K04-M19, W1 | nach GEEIGNET öffnet sich EN-04a mit **zwei** Feldern, je eigene Ja/Nein-Wahl | ein kombiniertes Feld liefert Klasse `?` → kein Bildschirm gefunden → rot (an synthetischer Seite nachgestellt) |
| ZB-02 | K04-M19 | Zahl der `fit_question`/Dimensionen/`fit_answer` **vor und nach** der Zweckantwort unverändert, outcome bleibt GEEIGNET | als vierte Eignungsfrage gebaut → eine Zahl wandert → rot |
| ZB-03 | F5, K19-M06 | Weiter fehlt bei 0 **und** bei 1 Antwort, erscheint bei 2 | immer sichtbar → rot; nie sichtbar → nicht bestimmbar → gesperrt |
| ZB-03b | K19-M06 | im Bereich `<div id="hinweis">`: Merkmal der **fehlenden** Frage ja, Merkmal der beantworteten **nein** | Hinweis nennt beide Fragen → rot (nachgestellt: `schlecht.rumpf` → rot); Marke fehlt/doppelt/offen → gesperrt |
| ZB-04 | K19-M14, F5 | Weiter mit halber Antwort **serverseitig** abgewiesen, keine Zeile | 303 auf ein anderes Ziel oder neue app-Zeile → rot; 401/403 wird ausdrücklich als **fremde** Bedingung ausgewiesen |
| ZB-05 | W6 | Gegenprobe: bei zwei Nein weder Anhang III noch Art. 5, Weg frei, noch keine Anwendung | ohne ihn messen ZB-06/07 nichts |
| ZB-06 | K04-M20, D09 | Anhang-III-Warnung **und** alle fünf Artikel **und** Bestätigungsaufforderung; outcome bleibt GEEIGNET; **kein** Art.-5-Verweis | Artikel werden als *Artikel* gezählt (`Art. 9`), nicht als Ziffer — Gegenprobe „9 Punkte und 43 Zeilen" liefert nur `5` → rot |
| ZB-07 | K04-M20, D10 | Grund + Art. 5, **kein** Anhang III, keine Kenntnisnahme, kein Anlageweg, keine Zeile | zeigt der Bau beides, fällt er hier durch („stattdessen") |
| **ZB-08** | **D10 vor D09** | Frage 1 **und** 2 bejaht → Halt nach Frage 2, kein Anhang-III-Weg, kein Nachweis, keine Zeile | ein Bau, der beide Klauseln einzeln erfüllt und die **Reihenfolge tauscht**, besteht ZB-06 und ZB-07 und fällt nur hier durch |
| ZB-09 | K04-M08 | Wege der Halt-Seite **gezählt** (ohne Selbstbezug/Abmelden): genau drei, alle drei benannt | vierter Weg oder fehlender Ausweg → rot, mit Liste der gefundenen Ziele |
| ZB-10 | M21, G12 | Nachweis entsteht **im Bestand** (Spalte *oder* Ereignis) und bleibt beim erneuten Aufruf | reiner Bildschirmzustand hinterlässt nichts → rot |
| ZB-11 | F2 | Treffer Frage 1 **ohne** Kenntnisnahme: Anlage abgewiesen, keine Zeile | alles andere ist richtig (Sitzung, Adresse vom Server selbst, GEEIGNET); fehlt allein der Nachweis |
| ZB-12 | W7, M17 | **positiv**: genau eine Zeile, DISCOVERY, EUR, beidseitige Verknüpfung | ohne ihn misst der Rest die geschlossene Tür |
| ZB-13 | K01-D19, F6 | mitgesendete, **formgerechte** Nummer `DE-ZBA_777_77` wird verworfen; kein Eingabefeld dafür | eine formwidrige Nummer wäre an der Formprüfung gescheitert — genau der Fehler vom 02.08.2026 |
| ZB-14 | K01-M38 | zwei Anlagen, zwei **verschiedene** Nummern, beide mit Kundenkennung | gleiche Nummer oder fremde Kennung → rot |
| ZB-15 | F7, K04-M18 | Eignung kippt **nach** der Anzeige, **vor** der Anlage → Anlage scheitert | ein Server, der die Eignung beim Anzeigen gelesen und gemerkt hat, legt an → rot. Der Fall prüft vorher, dass der Weg überhaupt offen stand |
| ZB-16 | F4 | Nachweis unschreibbar (Klasse auf BETRIEBSPROTOKOLL) → kein Weiterweg, keine Anwendung | drei Ausgänge mit Absicht; gelingt der Nachweis trotzdem, ist F4 nicht messbar → **gesperrt**, nie grün |
| ZB-17/18/19 | W8/W9/W10, M08, D03 | Ausweg über das Ziel, das die Halt-Seite **selbst** ausgibt; Antwortzeilen nie entfernt; Termin als Ereignis-**Zunahme**; Vorgang bleibt | Zeilenverlust, Ergebniswechsel oder neue Anwendung → rot |
| **ZB-20** | K01-M27, D06 | unter **derselben** Rolle `fr_portal`: direkter INSERT verwehrt **und** Serverbefehl gelingt | ein Regime, das alles verbietet, fällt an der zweiten Hälfte durch |
| ZB-21/22/23 | K01-M27, F1/F3, K04-D08 | Befehl gegen OFFEN, fremdes Konto, fremder Check, gesperrtes Konto, Mandant außerhalb DE | jede Meldung wird auf die **erwartete** Kennung geprüft und im **Wortlaut** ausgewiesen; ein Scheitern aus anderem Grund gilt als nicht bestanden |
| ZB-24 | M21, K10 | Nachweis besteht **nach** der Anlage fort, Klasse KI_NACHWEIS | der Schritt, der ihn am ehesten verdrängen würde |
| ZB-25 | K01-M27 | — | **ausdrücklich gesperrt**, siehe unten |

**MT-95b** (`M30__pruefung.sql`, direkt vor MT-96): unter `SET LOCAL ROLE fr_portal` muss `create_app_after_fit` **gelingen** und die Zeile wirklich stehen. Mandant, Konto und Check sind dieselben wie in MT-95; unterschieden ist allein die Rolle — er kann also nur am Ausführungsrecht bzw. am Rechtemodell des Befehls scheitern. Die Gestalt des Befehls wird über `pg_proc` **erfragt**; gibt es sie mit fünf Werten nicht, meldet er ausdrücklich „NICHT GEMESSEN" statt ein fehlendes Recht vorzutäuschen.

## Was ich nicht messen konnte

1. **`currency = EUR` aus K01-M27** (ZB-25, gesperrt). Das Datenmodell führt `app.currency` mit Vorgabe EUR und kennt keinen Mandanten mit anderer Währung. Ein Fall dazu könnte nicht scheitern.
2. **Der Wortlaut der beiden Zweckfragen.** K04-M19 beschreibt sie inhaltlich, zeichnet aber keinen Satz. Gemessen wird nur die Unterscheidbarkeit an den Merkmalen der Klausel.
3. **`legal_space ≠ DE`** nur, wenn der Mandant `fb04` (EU27_REST) anlegbar war; sonst meldet ZB-23 „nur teilweise messbar" statt grün.
4. **Der Träger der Zweckbestimmung selbst** (die zwei Antworten) ist nach O-K04-8 offen. Der Lauf sucht den Nachweis an beiden Orten (Spalte `fit_check.zweckbestimmung_ack_at` *oder* Ereignis nach K02) und entscheidet die offene Frage nicht.
5. **Kein Lauf gegen einen Server möglich:** keine Datenbank unter `localhost:55433` erreichbar. Geprüft sind Syntax und — an synthetischen Seiten — dass Feld-Entdeckung, Bereichsabgrenzung (MARKE/FEHLT/MEHRDEUTIG/UNGESCHLOSSEN), Artikelzählung und Zielerkennung grün **und** rot werden können.

## Zwei Befunde für den Auftraggeber

- **K01-M38 gegen die Gestalt des Serverbefehls.** `create_app_after_fit` nimmt nach MT-95 die Projektnummer als **Übergabewert** entgegen (fünf Werte). K01-M38 sagt: „Sie wird vergeben, nicht eingegeben." Beides ist nur vereinbar, wenn der Befehl einen übergebenen Wert überschreibt oder verwirft. Ich habe das nicht auf DB-Ebene entschieden, sondern auf der Ebene gemessen, auf der K01-D19 eindeutig ist: ZB-13 (mitgesendeter Wert wird verworfen) und ZB-14 (zwei Anlagen, zwei Nummern).
- **`pruefungen/migration/M30__pruefung.sha256`** war die Prüfsumme des unveränderten Prüf-SQL. Sie ist neu gebildet; die alte Fassung ist damit nicht mehr rekonstruierbar. Wer die Kette nachrechnet, muss den Wechsel kennen.