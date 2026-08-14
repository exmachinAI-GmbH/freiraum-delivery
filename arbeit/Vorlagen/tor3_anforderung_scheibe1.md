# Fremdprüfung anfordern — Scheibe 1, erster Durchlauf

**Wozu dieses Blatt da ist.** Die Fremdprüfung (Tor 3) ist an vier Stellen verbindlich
beschrieben und **noch nie durchlaufen**. `pruefungen/tor3.sh` meldet deshalb GESPERRT.
Damit ist unbekannt, wie viele Tage ein Durchlauf kostet — und wer das erst kurz vor dem
Endtermin herausfindet, findet es zu spät heraus.

Dieses Blatt bereitet den Durchlauf vor. **Es führt ihn nicht aus.**

> **Warum der Harness das nicht selbst tut** — wörtlich aus `nachweise/fremdreview/README.md`:
>
> *„Ein Fremdmodell, das der Harness selbst aufruft, dessen Ausgabe er selbst ablegt und
> dessen Ergebnis er selbst auswertet, ist kein fremder Blick mehr — es ist derselbe Blick
> mit einem anderen Etikett."*
>
> Deshalb fordert **ein Mensch** an, **ein Mensch** legt das Urteil ab, **ein Mensch**
> unterschreibt. Ein von einem Agenten ausgefüllter Kopf ist kein Nachweis, sondern seine
> Fälschung.

**Dieser Durchlauf nimmt nichts ab.** Scheibe 1 ist ausdrücklich *„nicht abnahmefähig"* —
sie heißt Integrationsprobe, nie Durchstich. Der Zweck ist allein: den Weg einmal gehen und
die Laufzeit kennen.

---

## Schritt 1 · Was Sie brauchen

| | |
|---|---|
| **Ein Modell eines anderen Anbieters** | nicht dasselbe, das hier baut. Im Projekt bewährt: GPT 5.6 Sol über die Codex-Kommandozeile |
| **Eine frische Sitzung** | kein fortgesetztes Gespräch, kein übernommener Zusammenhang |
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
nachweise/manifeste/tor1c_260813.json
nachweise/manifeste/tor1c_260813_manifest.json
```

**Nicht mitgeben:** Übergabetexte, Bauberichte, Antragsbeschreibungen, dieses Blatt.

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
4. Unterschreiben und die Prüfsumme danebenlegen:

```bash
cd nachweise/fremdreview && shasum -a 256 1_260814.md > 1_260814.md.sha256
cd ../.. && python3 werkzeuge/fremdreview.py
```

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
