# Fremdprüfung anfordern — Scheibe 1, erster Durchlauf

**Wozu dieses Blatt da ist.** Die Fremdprüfung (Tor 3) ist an vier Stellen verbindlich
beschrieben — `CLAUDE.md` Abschnitt 2 (Messstufe 3), `pruefungen/tor3.sh`,
`nachweise/fremdreview/README.md` und `.claude/commands/scheibe.md`:73 — und **gegen den
gebauten Stand noch nie durchlaufen**. `pruefungen/tor3.sh` meldet deshalb GESPERRT. Damit
ist unbekannt, wie viele Tage ein Durchlauf kostet — und wer das erst kurz vor dem Endtermin
herausfindet, findet es zu spät heraus.

*Gegen Texte ist sie gelaufen: am 07.08. und 11.08.2026 gegen Klausel- und
Gestaltungsquellen (Blätter 39, 72, 81). Gegen Quelltext, Migrationen und Prüflaufausgaben
noch nie.*

Dieses Blatt bereitet den Durchlauf vor. **Es führt ihn nicht aus.**

| | |
|---|---|
| **Träger** | ⟨Name⟩ |
| **Anforderung abzuschicken bis** | ⟨Datum⟩ |

Beides trägt ein Mensch ein. `werkzeuge/fremdreview.py` verlangt später die Angabe
*angefordert von* und meldet ohne sie GESPERRT.

> **Warum der Harness das nicht selbst tut** — wörtlich aus `nachweise/fremdreview/README.md`:
>
> *„Ein Fremdmodell, das der Harness selbst aufruft, dessen Ausgabe er selbst ablegt und
> dessen Ergebnis er selbst auswertet, ist kein fremder Blick mehr — es ist derselbe Blick
> mit einem anderen Etikett."*
>
> Deshalb fordert **ein Mensch** an, **ein Mensch** legt das Urteil ab, **ein Mensch**
> unterschreibt. Ein von einem Agenten ausgefüllter Kopf ist kein Nachweis, sondern seine
> Fälschung.

**Dieser Durchlauf nimmt nichts ab.** Der Zweck ist allein: den Weg einmal gehen und die
Laufzeit kennen.

**Zum Namen.** Blatt 57 vom 10.08.2026 hat den Umfang von *Scheibe 1* auf einen *benannten
Teilschnitt bis zur Anmeldung* verkleinert und hält dort ausdrücklich fest, es sei
*„**keine** Scheibe 1, sondern ein benannter Teil davon"*. Dieses Blatt fordert die
Fremdprüfung für **diesen Teilschnitt** an; *Scheibe 1* im Titel ist der alte Name. Blatt 57
verlangt für den Teilschnitt zugleich **alle vier Messstufen** — die Fremdprüfung ist also
Teil des gezeichneten Umfangs, keine Zugabe.

---

## Schritt 1 · Was Sie brauchen

| | |
|---|---|
| **Ein Modell eines anderen Anbieters** | nicht dasselbe, das hier baut. Im Projekt eingespielt: **GPT 5.6 Sol über die Codex-Kommandozeile** — im Terminal, im Ordner `~/freiraum-delivery` |
| **Eine frische Sitzung** | kein fortgesetztes Gespräch, kein übernommener Zusammenhang |
| **Die genaue Fassungsangabe des Modells** | zu Beginn erfragen und notieren — sie ist eine der zwölf Pflichtangaben im Nachweis |
| **Der geprüfte Stand** | Commit `40e8ec6d97402f9e5816b21cf828a9bd3f18ec22` (Hauptspur, 14.08.2026) |

**Wichtig:** Geben Sie dem Modell die **Rohbelege**, nicht meine Berichte. Ein Prüfer, der
gegen eine Zusammenfassung des Bauenden prüft, prüft die Zusammenfassung.

---

## Schritt 2 · Die Rohbelege

Genau diese Dateien, sonst nichts:

**Was gebaut wurde**
```
app/haupt.py  app/anmeldung.py  app/einladung.py  app/einladung_senden.py
app/sitzung.py  app/datenbank.py
app/vorlagen/en01_anmeldung.html  app/vorlagen/einladung.html
app/vorlagen/einladung_senden.html  app/vorlagen/start.html
mail/versand.py
```

**Die Änderungsschritte an der Datenbank**
```
migrations/M30__pilot_sammelmigration.sql
migrations/negativfaelle/N1_frist_ge_mindestfrist.sql
migrations/negativfaelle/N2_mail_fehler_braucht_grund.sql
migrations/negativfaelle/N3_pseudonym_vor_frist.sql
migrations/negativfaelle/N4_tagesfrist_positiv.sql
```

**Was gemessen wurde**
```
pruefungen/lauf.sh
pruefungen/klauseln/anmeldung_lauf.sh      pruefungen/klauseln/anmeldung_daten.sql
pruefungen/klauseln/einloesung_lauf.sh     pruefungen/klauseln/einloesung_daten.sql
pruefungen/klauseln/versand_lauf.sh        pruefungen/klauseln/versand_daten.sql
pruefungen/klauseln/mitgliedschaft_lauf.sh pruefungen/klauseln/mitgliedschaft_daten.sql
pruefungen/migration/M30__pruefung.sql
nachweise/manifeste/tor1c_260813.json
nachweise/manifeste/tor1c_260813_manifest.json
```

`M30__pruefung.sql` ist mit 81 KB die größte Datei der Liste — sie enthält die 110 Prüffälle
hinter der Zeile *„110 von 110"* im Protokoll. Ihre Prüfsumme ist nachgerechnet der Wert
`prueffaelle_sha256` in `tor1c_260813.json`.

**Nicht mitgeben:** Übergabetexte, Bauberichte, Antragsbeschreibungen, dieses Blatt.

> **Achtung, zwei verschiedene Sätze tragen dieselben Bezeichnungen.** Die **vier**
> SQL-Dateien unter `migrations/negativfaelle/` (N1 Mindestfrist, N2 Mailfehler ohne Grund,
> N3 Pseudonym vor Frist, N4 Tagesfrist) sind etwas anderes als die **fünf** Fälle in
> `migrations/pruefe_negativfaelle.sh` (Vertragsnachweis, Partneraufgabe, Codeformat). Sie
> prüfen Verschiedenes. **Frage 3 unten betrifft ausschließlich die vier SQL-Dateien**; die
> erwartete Bedingung steht in deren Kopfzeile (`-- erwartet: …`) und wird von
> `pruefungen/lauf.sh`:117–145 ausgelesen. Geben Sie `pruefe_negativfaelle.sh` **nicht** mit
> — es würde den Prüfer auf einen fremden Testsatz lenken.

---

## Schritt 3 · Der Auftrag an das fremde Modell

Wortlaut zum Übernehmen:

> Du prüfst als unabhängiges Modell einen Softwarestand. Du bist **nicht** der Bauende und
> übernimmst keine seiner Erklärungen.
>
> **Gegenstand:** ein erster durchgehender Faden einer Mandantenanwendung — Einladung
> senden, Einladung einlösen, Anmeldung mit Einmalcode, Mitgliedschaft. Serverseitig
> gerendert, PostgreSQL, FastAPI.
>
> **Du bekommst ausschließlich Rohbelege:** Quelltext, Änderungsschritte an der Datenbank,
> Prüffälle und die Protokolle der Prüfläufe. Du bekommst keine Berichte und keine
> Zusammenfassungen. Wenn du etwas nicht beurteilen kannst, weil ein Beleg fehlt, sage das,
> statt es zu vermuten.
>
> **Deine Frage lautet:** Trägt dieser Stand fachlich? Insbesondere:
> 1. Ist die Anmeldung serverseitig durchgesetzt, oder gibt es einen Weg an ihr vorbei?
> 2. Kann ein Mandant Daten eines anderen sehen?
> 3. Scheitern die Negativfälle wirklich an der Bedingung, die sie prüfen sollen — oder an
>    einer anderen?
> 4. Misst ein Prüffall etwas, das der Code so nicht tut, oder umgekehrt?
> 5. Wo behauptet ein Protokoll etwas, das die Belege nicht hergeben?
>
> **Form deiner Antwort:** Jede Aussage zeigt auf eine Fundstelle `Datei:Zeile`. Ein Urteil
> ohne Fundstellen ist eine Meinung. Schließe mit genau einem von drei Worten:
> **trägt** · **trägt mit Auflagen** · **trägt nicht**.

---

## Schritt 4 · Das Urteil ablegen

1. `nachweise/fremdreview/VORLAGE.md` kopieren nach
   `nachweise/fremdreview/1_260814.md` (Scheibe · Datum).
2. Den Kopf ausfüllen — die zwölf Pflichtangaben. Vier davon sind Bestätigungen, die nur
   Sie geben können: frische Sitzung, getrennter Zusammenhang, gegen Rohbelege geprüft, der
   Harness hat es nicht geschrieben.
3. Das Urteil **unverändert** einsetzen. Nicht zusammenfassen, nicht glätten, nicht kürzen —
   ein zusammengefasstes Fremdurteil ist wieder das eigene Wort.
4. Unterschreiben und die Prüfsumme danebenlegen — im Terminal, im Ordner
   `~/freiraum-delivery`:

```bash
cd nachweise/fremdreview && shasum -a 256 1_260814.md > 1_260814.md.sha256
cd ../.. && python3 werkzeuge/fremdreview.py
```

Erwartete Ausgabe bei vollständigem Blatt: eine Zeile je abgelegtem Nachweis mit dem
Zustand *bestanden* und eine Schlussbilanz.

**Wenn es gut geht:** `bash pruefungen/tor3.sh` meldet den Stand je Scheibe statt GESPERRT.
**Wenn etwas fehlt:** Das Werkzeug nennt jedes fehlende Feld beim Namen und meldet GESPERRT.
Das ist die richtige Meldung — gesperrt heißt *nicht gemessen*, nicht *durchgefallen*.

---

## Schritt 5 · Die eigentliche Messung dieses Durchlaufs

Bitte notieren Sie zwei Zeiten. Sie sind der Grund, warum dieser Durchlauf jetzt stattfindet:

| | |
|---|---|
| Anforderung abgeschickt am | ⟨Datum, Uhrzeit⟩ |
| Urteil abgelegt und Formprüfung bestanden am | ⟨Datum, Uhrzeit⟩ |
| **Dauer des Zyklus** | ⟨…⟩ |

Diese Dauer geht in die Planung der Scheibenabnahmen ein. Ohne sie ist jede Terminaussage
zu Tor 3 geraten.
