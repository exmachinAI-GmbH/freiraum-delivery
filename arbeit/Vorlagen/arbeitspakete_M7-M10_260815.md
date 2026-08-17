# Vorlage · Vier Arbeitspakete zum Teilschnitt

**Stand: 15.08.2026 · Zweig `main` · Commit `7642f0b78a3cf157f3c7b7cd03161d5294d45bad` · `git status --short` ist leer**

*Diese Vorlage entscheidet nichts. Sie legt vor, was vier Vorbereiter ausgearbeitet haben, prüft die Zahlen am Original nach und benennt, wo Bauvorschlag und blind geschriebener Prüffall auseinandergehen. Ich habe keine Datei geändert.*

**Zwei Begriffe vorab, weil sie überall wiederkehren.**
Eine **Klausel** ist eine einzelne, nummerierte Regel aus den 24 gezeichneten Konzepten. Ihre Kennung liest sich so: `K20-M22` heißt Konzept 20, Regel M22. Der Buchstabe sagt die Art: **M** = MUSS, **D** = DARF NICHT, **G** = GILT.
Der **Teilschnitt** ist der Weg bis zur Anmeldung in fünf Teilen: Mandant anlegen · Einladungsschranke · Einladung über den echten Mailweg · Anmeldecode · Anmeldung. Er ist seit Blatt 57 vom 10.08.2026 der Umfang von Tor II.

---

## 1 · Stand in vier Sätzen

**M-7 (Klauselschnitt).** Der Umfang von Bedingung 4 ist bestimmbar und liegt bei **157 Regeln**; jede Zahl des Pakets habe ich nachgerechnet und bestätigt gefunden — es fehlt allein die menschliche Zeichnung, denn auf dem Zeichnungsblatt ist keines der 19 Kästchen gesetzt.

**M-8 (Fremdprüfung).** Der Anforderungstext ist satzfertig und die Belege sind vollständig benannt; was fehlt, ist ein Mensch, der ihn abschickt — der verdrahtete Auslöser kann nicht ziehen, weil das Etikett `scheibenabnahme` im Repo **nicht existiert** (nachgemessen: alle 27 Läufe des Tor-3-Ablaufs sind übersprungen).

**M-9 (Ablaufpfad).** Der Bauvorschlag ist technisch sauber gemessen, aber er schlägt genau den Weg vor, den **zwei gezeichnete Blätter am 11.08.2026 nicht gewählt haben** — das ist der schwerste Befund dieser Vorlage, und M-9 konnte ihn nicht sehen, weil es die Blätter nur im Arbeitsverzeichnis gesucht hat, wo sie nicht liegen.

**M-10 (Kunden-Code).** Der Migrationsvorschlag ist wiederholbar, verletzt keinen Bestand und deckt sich in der Sache mit dem blinden Prüfer; beide sagen aber unabhängig voneinander, dass die Regel, die er durchsetzt, **so gar nicht gezeichnet ist** — und die Regeln, um die es geht, liegen nach M-7 **außerhalb** der 157.

---

## 2 · M-7 · Der Klauselschnitt des Teilschnitts

### 2.1 Die Zahl

**Bedingung 4 von Tor II umfasst 157 Regeln.**

Bedingung 4 lautet im gezeichneten Bauauftrag wörtlich: *„Klauselregister, Herkunftsgraph und Restrisikoliste liegen vollständig vor."* Seit der Einengung von heute gilt sie nur für die Regeln des Teilschnitts. Welche das sind, war bis heute nicht benannt.

### 2.2 Wo die Grenze liegt — und warum sie scharf ist

Der Teilschnitt ist am 10.08.2026 von beiden Gründern gezeichnet worden. Ich habe den Wortlaut am Original nachgeschlagen (Blatt 57, Weg A):

> *„Der Weg **bis zur Anmeldung**: Mandant anlegen · Einladungsschranke · Einladung über den echten Mailweg · Anmeldecode · Anmeldung — vollständig belegt, mit allen vier Messstufen. Ausdrücklich **keine** Scheibe 1, sondern ein benannter Teil davon."*

Diese fünf Namen sind fünf der 22 Stationen, an denen der Klauselschnitt der ganzen Scheibe 1 entlanggeht. Sie stehen in genau zwei Zeilen des gezeichneten Fadendiagramms. Der Schnitt bricht also nicht mitten in einer Zeile ab, sondern am Zeilenende. Deshalb muss die Grenze nicht ausgelegt werden.

**Nachgemessen, Station für Station:**

| Station | Treffer |
|---|---:|
| Mandant | 106 |
| Einladungsschranke | 4 |
| Einladung | 34 |
| Anmeldecode | 19 |
| Anmeldung | 6 |
| **Summe der Treffer** | **169** |

Die erste Station **dahinter** heißt *Kenntnisnahme*. Sie steht unmittelbar nach der Anmeldung und ist bewusst draußen: das gezeichnete Kreuz endet mit dem Wort *Anmeldung* und nennt sie nicht.

### 2.3 Die Herleitung, in drei Schritten — jeder von mir nachgerechnet

1. **152** Regeln nennen im Wortlaut eine der fünf Stationen. Die 169 oben sind Treffer, nicht Regeln: siebzehn Regeln stehen an mehr als einer Station.
2. **+ 5** Regeln, die der gebaute Programmtext selbst für sich beansprucht, ohne ein Stationswort zu tragen (`K03-G01`, `K03-M26`, `K20-M14`, `K20-M25`, `K23-D09`).
3. **= 157** Regeln aus **20** der 24 gezeichneten Konzepte.

Das sind 12,8 % aller 1 231 Regeln und 33,4 % der 470, die der Schnitt der ganzen Scheibe 1 berührt. Verteilung: K02 (33) · K03 (31) · K20 (21) · K01 (11) · K11 (10) · K14 (9) · K23 (7) · K07 und K13 (je 6) · K04, K05, K10, K12 (je 3) · K08, K17, K19, K25 (je 2) · K06, K15, K16 (je 1). **Alle diese Zahlen habe ich selbst gerechnet und identisch gefunden.**

**Zwei Vergleichszahlen, falls eine Auflage gemacht wird.** Ohne die Station *Anmeldung* wären es **154**. Ohne die fünf Regeln aus der Bauspur **152**. Der Vorschlag ist 157, weil eine Regel, die der eigene Programmtext beansprucht, nicht deshalb draußen bleiben soll, weil sie ein anderes Wort benutzt.

### 2.4 Was diese 157 Regeln heute an Nachweisen tragen

| Nachweis nach Bedingung 4 | Stand für die 157 |
|---|---|
| **Klauselregister** — jede Regel mit einem Abnahmekriterium | **0 von 157.** Ebenso leer: Eigentümer, Kritikalität, Test, Teststand, Ergebnis, Beleg |
| **Herkunftsgraph** — die Kette *Quelle → Regel → Umsetzung → Test → Nachweis* | Quelle → Regel: **157**. Weiter bis zur Umsetzung: **44**. Weiter bis zum Test: **30**. Bis zum Nachweis durchgehend: **30** |
| **Restrisikoliste** — ein Eintrag je Regel ohne Test | **0 von 157** |

Ein Prüffall **nennt** heute **31 der 157** Regeln. Genannt heißt genannt — nicht gemessen.

**Die Erwartung „null Abnahmekriterien" trifft zu, und zwar nicht nur für den Teilschnitt.** Das Feld ist in allen 1 231 Registerzeilen leer. Der Teilschnitt ist hier nicht schlechter gestellt als der Rest. Er ist nur der Teil, für den es jetzt gefüllt werden muss.

### 2.5 Was noch fehlt

1. **Zwei der fünf Stationen haben kein Leseblatt.** Ich habe die Abschnitte der Lesefassung ausgezählt: 18 Stationen haben einen Abschnitt, **Anmeldecode und Anmeldung nicht**. Wer heute zeichnen wollte, müsste 25 Regeln im Rohtext nachschlagen. Das ist Herstellungsarbeit, kein Beschluss.
2. **Der Eintragungsteil des Zeichnungsblatts ist leer.** 19 Kästchen, **kein einziges gesetzt** (nachgezählt). Die Tabelle für die Zuordnung je Regel hat null Zeilen. Die 157 sind ein Messergebnis. Die Zuordnung trifft ein Mensch.
3. **Sieben offene Vorbehalte.** Für sechs Regeln ist nachgeprüft, dass der Programmtext sie nur teilweise deckt; für eine schlägt das Blatt selbst eine andere Einstufung vor.
4. **Der Schnitt ist enger als die Prüffälle, die es schon gibt.** Nachgemessen: die fünf Prüffallgruppen des Teilschnitts nennen zusammen 38 Regeln, **zehn davon liegen außerhalb der 157** (`K03-D02`, `K03-M11`, `K03-M16`, `K03-M17`, `K20-D01`, `K20-G01`, `K20-M02`, `K20-M05`, `K23-D05`, `K23-M22`). Entweder gehören sie hinein — dann sind es 167 — oder die Prüffälle messen mehr, als der Umfang verlangt. Das ist zu entscheiden, nicht zu rechnen.
5. **Eine Sprachlücke ist nur an einer Station gegengeprüft.** Bei *Anmeldecode* traf der Stationsbegriff zunächst null Regeln, weil die Konzepte „E-Mail-Code" und „zweiter Faktor" sagen. Erst drei belegte Wortgleichsetzungen brachten die 19 Treffer. Bei *Mandant*, *Einladungsschranke* und *Einladung* ist eine solche Gegenprobe **nicht** gemacht worden.
6. **Die Triage ist veraltet.** Ihr Prüffallfeld stammt vom 07.08.2026 und zählt 12, wo heute 31 Regeln genannt werden. Vor der Vorlage ist neu zu rechnen.

### 2.6 Ein Nachtrag aus meiner eigenen Prüfung

Ich habe zusätzlich nachgesehen, welche der Regeln, um die es in M-10 geht, im Satz der 157 liegen. Ergebnis:

| Regel | in den 157? |
|---|---|
| `K02-G02` (Kunden-Code nur bei der Art Kunde Pflicht) | **nein** |
| `K02-M25` (fortlaufende Vergabe, erster Code `DE-AAA`) | **nein** |
| `K02-M27`, `K02-M28`, `K02-D06` | **nein** |
| `K02-M06`, `K02-D10`, `K02-G15` | ja |

**Das heißt:** Die beiden Regeln, die M-10 durchsetzen will, gehören nach dem Schnitt von M-7 **nicht** zu Bedingung 4 des Tors II. Das macht M-10 nicht falsch — es macht es zu Arbeit außerhalb des vereinbarten Umfangs. Siehe Abschnitt 5.

---

## 3 · M-8 · Die Fremdprüfung anfordern

### 3.1 Die Messung

Die dritte der vier Messstufen ist der fremde Blick: eine KI eines anderen Anbieters urteilt gegen die Rohbelege. Sie ist gegen den gebauten Stand **kein einziges Mal** gelaufen. Selbst nachgefahren:

```
$ bash pruefungen/tor3.sh   →   Rückgabewert 1
Tor 3: kein Fremdreview abgelegt.
  Zustand: GESPERRT -- nicht gemessen ist nicht bestanden (K23-M22).
```

`K23-M22` ist die Regel, die vier Zustände unterscheidet: bestanden · fehlgeschlagen · **gesperrt** · nicht ausgeführt. Gesperrt heißt *nicht gemessen*, nicht *durchgefallen*.

### 3.2 Die entscheidende Lücke — der Auslöser

Drei Auslöser sind verdrahtet. **Keiner wird durch den Teilschnitt ausgelöst.**

**A · Das Etikett `scheibenabnahme`.** Selbst nachgemessen:

```
$ gh label list --limit 100
bug · documentation · duplicate · enhancement · good first issue
help wanted · invalid · question · wontfix
→ das Etikett "scheibenabnahme" ist NICHT dabei

$ gh run list --workflow=tor3.yml --limit 100
27 Läufe, alle 27: pull_request / skipped
```

Das Etikett, an dem der Lauf hängt, **gibt es im Repo nicht**. Niemand kann es setzen, ohne es vorher anzulegen. Folgerichtig ist jeder Lauf übersprungen worden.

**B · Von Hand.** Verdrahtet und funktionsfähig. Null Läufe.

**C · Der Halt im Scheibenbefehl.** Echt gebaut, seit gestern. Er greift aber nur, wenn jemand einen Scheibenlauf startet. **Der Teilschnitt ist keine Scheibe** — Blatt 57 sagt das wörtlich. Der Halt greift also für genau den Gegenstand nicht, der abgenommen werden soll.

**Die Lücke in einem Satz:** Der Auslöser heißt *Scheibenabnahme*. Der Gegenstand heißt *Teilschnitt* und ist ausdrücklich keine Scheibe. Zwischen beiden gibt es keine Verbindung.

### 3.3 Sechs Stellen, an denen die vorhandene Anforderung nicht trägt

Nachgeprüft an `arbeit/Vorlagen/tor3_anforderung_scheibe1.md`:

| # | Was dort steht | Warum das nicht trägt | Was hinein muss |
|---|---|---|---|
| 1 | Geprüfter Stand: Commit `40e8ec6d…` (14.08.) | Der Commit existiert. Seither aber 47 geänderte Dateien mit über 31 000 neuen Zeilen — ein Urteil dagegen beurteilt nicht den Stand, der abgenommen wird | Commit `7642f0b7…` |
| 2 | Titel und Feld: „Scheibe 1" | Blatt 57 sagt: *ausdrücklich keine Scheibe 1* | Kennung `teilschnitt-anmeldung` |
| 3 | Belegliste nennt fünf Programmdateien | Selbst nachgezählt: **drei der fünf Teile fehlen**. Die Wörter `anmeldecode`, `pruefe_schranke` und `01_betreiber` kommen im Blatt **null Mal** vor | die Belege für Mandant anlegen, Einladungsschranke, Anmeldecode |
| 4 | Das eingefrorene Datenmodell fehlt | Es ist **Rang 1** der Quellenrangfolge. Wer nur die Sammelmigration sieht, kann nicht beurteilen, ob sie die Basis richtig fortschreibt (nachgeprüft: das Wort `freiraum_datamodel` kommt im Blatt null Mal vor) | `schema/freiraum_datamodel.sql` |
| 5 | Protokoll vom 13.08. | Es gibt ein neueres vom 14.08. Es meldet **zwei gesperrte** Prüffälle | das Protokoll vom 14.08. |
| 6 | Nichts zum Ausschluss von Scheibe 2 | Seit dem 15.08. liegt die Vorprüfung im Baum. Das ist Meilenstein M3, nicht Teilschnitt | Abschnitt „Nicht mitgeben" erweitern |

**Am Nachweisblatt selbst ist nichts zu ändern.** Nachgeprüft: das Werkzeug liest genau zwölf Kopffelder, und das Feld für die Kennung wird nur auf Gleichheit verglichen — es nimmt jeden Wert an.

### 3.4 Der Anforderungstext — satzfertig zum Übernehmen

> ### Fremdprüfung anfordern — Teilschnitt bis zur Anmeldung
>
> **Wozu dieses Blatt da ist.** Blatt 57 vom 10.08.2026 legt den Umfang von Tor II auf den Teilschnitt bis zur Anmeldung fest und verlangt dafür wörtlich *„alle vier Messstufen"*. Die dritte ist die Fremdprüfung. Sie ist gegen den gebauten Stand nie gelaufen. Dieses Blatt bereitet den Durchlauf vor. **Es führt ihn nicht aus.**
>
> | | |
> |---|---|
> | **Träger** | ⟨Name⟩ |
> | **Anforderung abzuschicken bis** | ⟨Datum⟩ |
>
> **Warum der Harness das nicht selbst tut** — wörtlich aus dem Bestand:
>
> > *„Ein Fremdmodell, das der Harness selbst aufruft, dessen Ausgabe er selbst ablegt und dessen Ergebnis er selbst auswertet, ist kein fremder Blick mehr — es ist derselbe Blick mit einem anderen Etikett."*
>
> Deshalb fordert **ein Mensch** an, **ein Mensch** legt das Urteil ab, **ein Mensch** unterschreibt.
>
> **Was zur Prüfung steht.** Der Weg bis zur Anmeldung in fünf Teilen. **Ausdrücklich nicht:** die Vorprüfung. Sie ist seit dem 15.08. gebaut, gehört aber zu Scheibe 2.
>
> ---
>
> #### Schritt 1 · Was Sie brauchen
>
> | | |
> |---|---|
> | **Ein Modell eines anderen Anbieters** | nicht dasselbe, das hier baut. Eingespielt: GPT 5.6 Sol über die Codex-Kommandozeile, im Ordner `~/freiraum-delivery` |
> | **Eine frische Sitzung** | kein fortgesetztes Gespräch |
> | **Die genaue Fassungsangabe des Modells** | zu Beginn erfragen und notieren |
> | **Der geprüfte Stand** | Commit `7642f0b78a3cf157f3c7b7cd03161d5294d45bad` |
>
> **Wichtig:** Geben Sie dem Modell die **Rohbelege**, nicht die Berichte des Bauenden. Ein Prüfer, der gegen eine Zusammenfassung prüft, prüft die Zusammenfassung.
>
> #### Schritt 2 · Die Rohbelege
>
> **Das eingefrorene Datenmodell — Rang 1:** `schema/freiraum_datamodel.sql`
>
> **Was gebaut wurde:** `app/haupt.py` · `app/anmeldung.py` · `app/einladung.py` · `app/einladung_senden.py` · `app/sitzung.py` · `app/datenbank.py` · `app/__init__.py` · die vier Bildschirmvorlagen unter `app/vorlagen/` · `mail/versand.py` · `install/01_betreiber_und_erstadmin.sql` · `install/pruefe_b1.sh` · `install/pruefe_schranke.sh`
>
> **Die Änderungsschritte an der Datenbank:** `migrations/M30__pilot_sammelmigration.sql` und die vier Dateien unter `migrations/negativfaelle/`
>
> **Was gemessen wurde:** `pruefungen/lauf.sh` · die zehn Dateien der fünf Prüffallgruppen Anmeldung, Einlösung, Versand, Anmeldecode, Mitgliedschaft · `pruefungen/migration/M30__pruefung.sql` · die beiden Protokolldateien `nachweise/manifeste/tor1c_260814*.json`
>
> **Nicht mitgeben:** Übergabetexte, Bauberichte, `README.md`, `CLAUDE.md`, `CONTRIBUTING.md`, dieses Blatt.
> **Ebenfalls nicht mitgeben — Scheibe 2:** `app/vorpruefung.py`, die drei Vorprüfungs-Bildschirme, `pruefungen/klauseln/vorpruefung_*`, `seeds/Seed_Vorpruefung_K04.sql`.
>
> **Achtung, zwei Sätze tragen ähnliche Namen.** Die **vier** SQL-Dateien unter `migrations/negativfaelle/` sind etwas anderes als die fünf Fälle in `migrations/pruefe_negativfaelle.sh`. Geben Sie Letzteres **nicht** mit.
>
> #### Schritt 3 · Zwei Stellen, die der Prüfer kennen muss
>
> 1. **Das Protokoll meldet selbst zwei gesperrte Prüffälle** — `anmeldecode` 16 von 17, `mitgliedschaft` 8 von 9. Die Anmerkung dort lautet „1 gescheitert", der Zustand aber „gesperrt". Das ist gewollt: das Prüfwerkzeug schreibt die rohe Summenzeile in die Anmerkung und stuft den Lauf nur dann auf *gesperrt* herunter, wenn **alle** offenen Punkte gesperrt sind. Bitte beurteilen Sie mit, ob das hier trägt.
> 2. **Der echte Mailweg ist bis heute nicht gemessen.** Der Prüffall `AC-16` führt die echte Zustellung nur aus, wenn eine Umgebungsvariable gesetzt ist; ohne sie meldet er gesperrt. Der echte Mailweg ist einer der fünf benannten Teile.
>
> #### Schritt 4 · Der Auftrag an das fremde Modell
>
> > Du prüfst als unabhängiges Modell einen Softwarestand. Du bist **nicht** der Bauende und übernimmst keine seiner Erklärungen.
> >
> > **Gegenstand:** der Weg bis zur Anmeldung in einer Mandantenanwendung, in fünf Teilen — einen Mandanten anlegen, die Einladungsschranke, eine Einladung über den echten Mailweg versenden, den Anmeldecode ausstellen, sich anmelden.
> >
> > **Du bekommst ausschließlich Rohbelege.** Keine Berichte, keine Zusammenfassungen. Wenn du etwas nicht beurteilen kannst, weil ein Beleg fehlt, sage das, statt es zu vermuten.
> >
> > **Deine Frage lautet: Trägt dieser Teilschnitt fachlich?** Insbesondere:
> > 1. Ist die Anmeldung serverseitig durchgesetzt, oder gibt es einen Weg an ihr vorbei?
> > 2. Kann ein Mandant Daten eines anderen sehen?
> > 3. Hält die Einladungsschranke — kann jemand ohne gültige Einladung ein Konto bekommen?
> > 4. Ist der Anmeldecode nirgends im Klartext gespeichert, wird er nach der ersten Verwendung wertlos, und gibt es je Konto höchstens einen offenen Code?
> > 5. Scheitern die vier Negativfälle wirklich an der Bedingung, die sie prüfen sollen — oder an einer anderen?
> > 6. Misst ein Prüffall etwas, das der Programmtext so nicht tut, oder umgekehrt?
> > 7. Setzt die Sammelmigration M30 das eingefrorene Datenmodell folgerichtig fort?
> > 8. Wo behauptet ein Protokoll etwas, das die Belege nicht hergeben? Prüfe ausdrücklich die beiden Fälle, die das Protokoll selbst als *gesperrt* führt.
> >
> > **Form deiner Antwort:** Jede Aussage zeigt auf eine Fundstelle *Datei:Zeile*. Ein Urteil ohne Fundstellen ist eine Meinung. Schließe mit genau einem von drei Worten: **trägt** · **trägt mit Auflagen** · **trägt nicht**.
>
> #### Schritt 5 · Das Urteil ablegen
>
> 1. `nachweise/fremdreview/VORLAGE.md` kopieren nach `nachweise/fremdreview/teilschnitt-anmeldung_260817.md`.
> 2. Die zwölf Pflichtangaben ausfüllen. Kennung = `teilschnitt-anmeldung`, Commit = der volle 40-stellige Wert. Vier Angaben sind Bestätigungen, die nur Sie geben können: frische Sitzung, getrennter Zusammenhang, gegen Rohbelege geprüft, der Harness hat es nicht geschrieben.
> 3. Das Urteil **unverändert** einsetzen. Nicht zusammenfassen, nicht glätten.
> 4. Unterschreiben. Bleibt die Zeichnung leer, meldet das Werkzeug es.
> 5. Prüfsumme rechnen und `bash pruefungen/tor3.sh` laufen lassen.
>
> **Wenn es gut geht:** BESTANDEN mit Rückgabewert 0. **Wenn etwas fehlt:** Das Werkzeug nennt jedes fehlende Feld beim Namen. Das ist die richtige Meldung.
>
> #### Schritt 6 · Zwei Zeiten notieren
>
> Abgeschickt am ⟨…⟩ · Urteil abgelegt und Formprüfung bestanden am ⟨…⟩ · Dauer ⟨…⟩.
> Der Probelauf vom 14.08.2026 hat für den Lauf selbst **6 Minuten** gemessen. Zeit kostet das Zusammenstellen der Belege.

### 3.5 Was ein Mensch tun muss — mit Träger und Frist

**Wer zeichnet, ist nicht belegt.** Die Verfassung des Harness führt für Tor 4 ausdrücklich: *„die zeichnenden Personen sind offen"*. Die folgende Zuordnung ist ein **Vorschlag mit Begründung**.

| # | Aufgabe | Vorschlag | Begründung |
|---|---|---|---|
| 1 | Etikett `scheibenabnahme` anlegen und setzen | **A. Han** | Ein Befehl, braucht Schreibrecht. Ohne ihn kann der verdrahtete Auslöser nie ziehen — gemessen: 27 von 27 Läufen übersprungen |
| 2 | Entscheiden, dass der Teilschnitt eine eigene Abnahmeeinheit mit der Kennung `teilschnitt-anmeldung` ist | **M. Veil** | Umfang gehört dem Auftraggeber. Ohne diese Benennung zeigt kein Werkzeug auf etwas |
| 3 | Die Fremdprüfung anfordern | **A. Han** | Fordert derselbe Mensch an, der später Tor 4 zeichnet, fallen Messender und Abnehmender zusammen. Außerdem liegen die Zugangsdaten für den echten Mailweg lokal auf seinem Rechner |
| 4 | Urteil ablegen, Kopf ausfüllen, unterschreiben, Prüfsumme rechnen | **A. Han** | Vier der zwölf Pflichtangaben kann nur der Anfordernde geben |
| 5 | `bash pruefungen/tor3.sh` laufen lassen und die Ausgabe in die Tagesübergabe nehmen | **A. Han** | Prüft die Form des Blattes, nicht das Urteil |
| 6 | Tor 4 zeichnen — trägt es? | **M. Veil** | Die letzte Messstufe. Läuft nie automatisch |

**Vorgeschlagene Fristen.** Heute ist Samstag, der 15.08.2026. Bis zum Endtermin am Montag, dem 31.08.2026, sind es 16 Kalendertage, davon 11 Arbeitstage.

| | Vorschlag |
|---|---|
| Etikett anlegen und Kennung entscheiden | **Montag, 17.08.2026, vormittags** |
| Anforderung abschicken | **Montag, 17.08.2026, bis 12:00** |
| Blatt abgelegt, gezeichnet, Prüfung mit Rückgabewert 0 | **Dienstag, 18.08.2026, bis 18:00** |

Vier Gründe: Der Lauf selbst kostet 6 Minuten — die Frist ist nicht knapp, sondern so früh gesetzt, dass Zeit für die **Folge** bleibt. Ein Urteil „trägt mit Auflagen" braucht Nacharbeit; bei einem Lauf am 17./18.08. bleiben neun Arbeitstage dafür. Am 18.08. steht ohnehin eine Vorlage zu Umfang und Termin an; dann sollte die Antwort auf „trägt der Teilschnitt?" bereits vorliegen. Und es sind **zwei** Durchläufe nötig, nicht einer: der erste misst und deckt auf, der zweite läuft gegen den Zeichnungsstand — der echte Mailweg ist heute noch gesperrt.

**Wenn A. Han nicht verfügbar ist:** M. Veil kann die Schritte 3 bis 5 übernehmen. Dann zeichnet dieselbe Person Messung und Abnahme. Keine Klausel verlangt hier zwei Personen — aber es schwächt Tor 3 und gehört dann als Eintrag in die Restrisikoliste, nicht in eine stille Ausnahme.

---

## 4 · M-9 · Ablaufpfad — Bauvorschlag und blinder Prüffall nebeneinander

**Zur Sache in einem Satz.** Eine Einladung hat eine Frist. Verstreicht sie, soll die Zugangszeile, die beim Versand angelegt wurde, wieder verschwinden. Der Prüffall dafür heißt MG-08 und ist heute gesperrt.

### 4.1 Der schwerste Befund dieser Vorlage

**M-9 sagt: „Das Blatt 62 ist nicht auffindbar, sein Wortlaut ist nicht belegt, es sollte vor dem Bau vorgelegt werden."**

**Ich habe es gefunden.** Es liegt nicht im Arbeitsverzeichnis, sondern in der Ablage der Entscheidungsvorlagen. Und es liegt ein **zweites** Blatt daneben, das M-9 nicht kennt.

**Blatt 62 vom 11.08.2026, Zeichnung, von A. Han und M. Veil unterschrieben:**

| | Entscheidung | |
|---|---|---|
| **1** | Wann entsteht die Mitgliedschaft? | **x A · beim Versand der Einladung** · ☐ B bei der Einlösung · ☐ C beim Anlegen des Kontos |
| **2** | Aufräumen bei Widerruf und Ablauf | **x im Serverpfad des Widerrufs, gemeinsam mit K20-M13** · ☐ **eigener Aufräumlauf** · ☐ nicht aufräumen |

**Blatt 63 vom selben Tag, ebenfalls von beiden gezeichnet, trägt den Titel „Berichtigung zu Blatt 62 · ‚oder ABGELAUFEN' gibt es nicht".** Es hält fest:

| | Berichtigung | gezeichnet |
|---|---|---|
| **A** | In Blatt 62 Punkt 2 entfällt „oder ABGELAUFEN". Aufgeräumt wird beim Widerruf; der Restfall wird als Restposten geführt | **x so** |
| **B** | Der Aufräumlauf wird als **Folgepunkt** geführt, zusammen mit der Frage nach der handelnden Instanz eines Laufs | **x so** |

**Daraus folgt:**

1. **Der eigene Aufräumlauf ist die Möglichkeit, die in Blatt 62 ausdrücklich nicht angekreuzt wurde.** M-9 schlägt genau ihn vor (`werkzeuge/einladungen_aufraeumen.py`). Der Bau widerspricht damit einer gezeichneten Zeichnung. Nach der Rangfolge gewinnt die Zeichnung.
2. **Blatt 63 hat den Aufräumlauf als Folgepunkt aufgenommen — nicht als Bauauftrag.** Und es hat ihn ausdrücklich an eine offene Frage gebunden: *Wer ist die handelnde Instanz eines Laufs?* Das Blatt sagt wörtlich, diese Frage unter Termindruck zu entscheiden wäre *„derselbe Fehler wie der, den dieses Blatt berichtigt."*
3. **M-9 beantwortet genau diese Frage — im Vorbeigehen.** Sein Risiko R7 schlägt vor, im Nachweis kein Konto einzutragen und stattdessen den Datenbankbenutzer zu vermerken. M-9 meldet das selbst als Auslegung. Es ist aber mehr als das: es ist die Antwort auf die eine Frage, die die Gründer bewusst offengelassen haben.
4. **Der Vertragssatz selbst ist belegt.** Blatt 62, Abschnitt 6, wörtlich: *„Eine abgelaufene oder widerrufene Einladung muss die Mitgliedschaft wieder entfernen."* Diese Hälfte von M-9 stimmt.

**Ein weiterer Fund:** Es gibt bereits einen **gezeichneten Aufräumlauf für Einladungen** — Beschluss Nr. 125 vom 05.08.2026 mit einem Nachtrag vom 08.08.2026. Er löscht Einladungen 30 Tage nach Ablauf aus Aufbewahrungsgründen. Er tut etwas anderes als M-9s Lauf, trägt aber denselben Namen. Wer M-9s Lauf baut, muss ihn anders nennen — sonst stehen zwei verschiedene Dinge unter einem Wort.

### 4.2 Was M-9 richtig gemessen hat — von mir nachgeprüft

| Behauptung | nachgeprüft |
|---|---|
| Der Zustand `ABGELAUFEN` existiert im Datenmodell und wird von **keiner Zeile** je geschrieben | **bestätigt** — 23 Fundstellen, keine einzige ein Schreibvorgang |
| `K20-M22` sagt wörtlich: *„Ablauf wird ausschließlich aus `expires_at` abgeleitet; kein Lauf schreibt ABGELAUFEN."* | **bestätigt**, Wortlaut identisch |
| `K20-D05` verbietet, den Einladungsplatz über einen Wechsel nach ABGELAUFEN freizumachen | **bestätigt** |
| Die Mitgliedschaft entsteht **beim Versand**, nicht bei der Einlösung | **bestätigt** — und zusätzlich durch Blatt 62 Zeichnung Nr. 1 A gezeichnet |
| Die heutige Löschanweisung trifft eine abgelaufene Einladung nicht, weil diese sich selbst als Träger zählt | **bestätigt** am Programmtext |
| MG-08 kann nur dann „bestanden" melden, wenn `ABGELAUFEN` geschrieben wurde — was eine gezeichnete Regel verbietet | **bestätigt.** Der Prüffall ist aber ausdrücklich **nachgiebig** gebaut: er meldet **gesperrt**, nicht durchgefallen. Blatt 63 nennt das folgerichtig |
| Der Satz steht in keinem der 24 Konzepte | **bestätigt** — null Treffer |

### 4.3 Bauvorschlag und blinder Prüffall nebeneinander

Der blinde Prüfer kannte den Bauvorschlag nicht. Er hatte nur die Konzepte und das Datenmodell.

**Wo beide übereinstimmen — das ist die stärkste Stelle:**

| Punkt | M-9 (Bau) | Blinder Prüfer |
|---|---|---|
| Der Satz hat keine Klausel | „steht in keinem der 24 Konzepte" | „Der Vertragssatz ist ein Umsetzungsvorschlag ohne Klausel" |
| `K20-M22` steht dem Schreiben von ABGELAUFEN entgegen | ja | ja, wörtlich zitiert |
| Der Ablauf ist kein Ereignis, an dem etwas hängen könnte | „ein Trigger braucht ein auslösendes Ereignis" | „Die Datenbank kennt keinen Auslöser auf Zeitablauf" |
| Es braucht einen benannten Beobachtungspunkt | implizit im Aufräumlauf | ausdrücklich als AK-1, Wahlmöglichkeit (a) träge / (b) nachziehend |
| Der Wächter für den letzten Plattform-Admin kann den Lauf abbrechen | Risiko R1, gemessen | Negativfall N1, mit erwarteter Meldung im Wortlaut |
| Der arbeitende Nutzer darf nicht hinausfliegen | Risiko R4, gemessen | Prüffall P4 (eingelöst, dann Fristablauf) |
| Der erneute Versand darf sich nicht ändern | Risiko R5, gemessen | Prüffall P5 |

**Wo sie auseinandergehen — ausdrücklich benannt:**

| # | M-9 sagt | Der blinde Prüfer sagt | Wer gewinnt, und warum |
|---|---|---|---|
| **1** | Der Entstehungszeitpunkt der Mitgliedschaft ist gemessen: beim Versand | „Kein Konzept sagt, wann die `membership` überhaupt entsteht. Entsteht sie erst bei der Einlösung, ist der Satz leer" | **M-9 — aber nicht wegen der Messung.** Blatt 62, Zeichnung Nr. 1, hat es als **A · beim Versand** gezeichnet. Der blinde Prüfer konnte das nicht wissen; er kannte nur die Konzepte, und dort steht es tatsächlich nicht. **Handlung: den Zeitpunkt in K20 nachziehen**, sonst bleibt eine gezeichnete Entscheidung ohne Klausel |
| **2** | Ein **eigener Aufräumlauf** ist „die einzige Tür, die zur Sache passt" | `K20-M17`/`K20-M19` binden das Entfernen an genau einen Befehl mit drei Vorbedingungen — „ein automatisches Entfernen bei Ablauf umgeht sie" | **Der blinde Prüfer, und Blatt 62 dazu.** Die Zeichnung wählt den Serverpfad des Widerrufs und nicht den eigenen Lauf. **Das ist der Kernkonflikt dieses Pakets** |
| **3** | Die Mitgliedschaft gehört über `actor_id` + `portal_code` eindeutig zur Einladung | „Die Zuordnung ist eine Vermutung. `membership` hat **keine** Spalte, die auf die Einladung verweist. Das ‚daran' aus dem Vertragssatz gibt es im Modell nicht" | **Der blinde Prüfer.** Die beiden Werte sind zwar die, aus denen die Zeile entstand — aber das Modell hält den Bezug nicht fest. Bleibt ein offener Punkt, unabhängig davon, welche Tür gebaut wird |
| **4** | Risiko R1: der Wächter kann den Lauf abbrechen, deshalb eine Transaktion je Einladung | N1 fordert die Meldung **im Wortlaut** plus den Fehlercode `23514`; ein Scheitern aus anderem Grund gilt **nicht** als bestanden | **Der blinde Prüfer ist strenger und hat recht.** Das entspricht der Hausregel F07: ein Fall, der an der falschen Bedingung scheitert, ist nicht bestanden |
| **5** | *(nicht behandelt)* | N2: der Ablauf darf den Einladungsplatz nicht freimachen — eine zweite Einladung ohne Widerruf muss am Eindeutigkeitsschutz scheitern | **Lücke bei M-9.** Der Fall gehört dazu, er misst `K20-D05` unmittelbar |
| **6** | *(nicht gemessen)* | P2 „nicht abgelaufen, nichts geht" und P3 „nur das betroffene Portal" | **Lücke bei M-9.** P2 ist der Fall, der P1 ehrlich hält: ohne ihn bestünde P1 auch dann, wenn ein Bau pauschal alle Zugangszeilen wartender Konten räumt |
| **7** | Risiko R1 sieht den Wächter zuschlagen | Der Programmtext hält an anderer Stelle fest, der Wächter könne beim Widerruf **nie** zuschlagen, weil eingeladene Konten auf „wartet auf zweiten Faktor" stehen | **Beides stimmt — und das ist ein Argument gegen den neuen Lauf.** Die vorhandene Tür kann den Wächter nicht auslösen. Die neue Tür kann es. Der Aufräumlauf schafft ein Risiko, das der gezeichnete Weg nicht hat |

### 4.4 Was von M-9 unbestritten trägt

**Schritt 1 des Bauvorschlags — die Trägerbedingung gegen die Uhr rechnen.** Zwei Zeilen im Programmtext. Heute zählt eine verfallene Einladung sich selbst noch als Träger einer Zugangszeile; künftig zählt nur, was eingelöst ist oder **noch läuft**. Das ist wörtlich die Bedingung der vorhandenen Lesesicht. Es ändert nichts am Datenmodell, widerspricht keiner Zeichnung und macht den gezeichneten Weg (Aufräumen beim Widerruf) genauer. **Diesen Schritt empfehle ich unabhängig von allem anderen.**

---

## 5 · M-10 · Kunden-Code — Migrationsvorschlag und blinder Prüffall nebeneinander

**Zur Sache in einem Satz.** Jeder Kundenmandant trägt einen Kunden-Code der Form `DE-XXX`. Heute lässt sich ein solcher Code auch an einen Betreiber- oder Partnermandanten hängen; die Datenbank widerspricht nicht. Das ist der Befund B1-F2.

### 5.1 Der heutige Zustand — von mir selbst nachgemessen

Am eingefrorenen Datenmodell stehen zum Kunden-Code genau drei Regeln:

| Regel | was sie prüft |
|---|---|
| `customer_needs_code` | Kunde ⇒ Code vorhanden |
| `customer_code_fmt` | die Form `DE-` plus drei Großbuchstaben |
| Eindeutigkeit (Systemname `tenant_customer_code_key`) | zwei Mandanten teilen den Code nie |

**Die Lücke ist die Gegenrichtung: Code vorhanden ⇒ Kunde. Sie fehlt.**

Ich habe beide laufenden Datenbanken selbst abgefragt:

```
Prüfdatenbank (freiraum_ci):  8 Bedingungen an tenant
Pilotdatenbank (freiraum):   10 Bedingungen an tenant
Bestand Pilot: OPERATOR | exmachinAI GmbH | Kunden-Code leer
Zeilen, die die neue Bedingung verletzen würden: 0 in beiden
```

**Beide Datenbanken tragen nicht dasselbe Schema.** Das ist so gewollt und dokumentiert. Es schränkt ein, wie die Negativfälle geschrieben sein dürfen — sie dürfen keine Spalte benutzen, die nur die Pilotdatenbank kennt. M-10 hat das beachtet.

### 5.2 Die Klauseln im Wortlaut — von mir am Original nachgeschlagen

> **K02-G02** — *„Es GILT: Der Kunden-Code ist nur bei der Art Kunde Pflicht. Betreiber und Partner bestehen ohne ihn."*
> **K02-M25** — *„Der Kunden-Code MUSS fortlaufend von der Plattform vergeben werden. Der erste lautet `DE-AAA`; jeder weitere ist der nächste freie Code der alphabetischen Folge."*

**Beide Bearbeiter — der Bauende und der blinde Prüfer, unabhängig voneinander — sagen denselben Satz: Ein ausdrückliches Verbot steht dort nicht.** `K02-G02` regelt die *Pflicht*, nicht die *Erlaubnis*. Das Verbot ergibt sich erst aus drei weiteren Regeln: der Vorrat ist endlich (`K02-G15`: 16 900 Codes für Kunden), jeder Code ist einmalig (`K02-M06`), und der Code ist der unveränderliche Bezug des Kunden (`K02-D06`).

**Das ist eine Ableitung, keine gezeichnete Klausel.** Und es ist der Punkt, an dem beide Pakete zusammenfallen — was ihre Aussage stark macht.

### 5.3 Migrationsvorschlag und blinder Prüffall nebeneinander

**Wo beide übereinstimmen:**

- Die Lücke besteht, sie ist reproduziert, und sie ist einseitig: nur die Richtung Kunde ⇒ Code ist geprüft.
- Es braucht eine neue Bedingung an der Tabelle der Mandanten.
- Ein Negativfall muss **an seiner eigenen Bedingung** scheitern, nicht an irgendeiner. Der blinde Prüfer nennt dafür sogar den historischen Anlass: am 02.08. starben drei von vier Fällen an der Formprüfung, bevor die Zielbedingung überhaupt gelesen wurde.
- Das Verbot ist abgeleitet, nicht gezeichnet.

**Wo sie auseinandergehen:**

| # | M-10 sagt | Der blinde Prüfer sagt | Bewertung |
|---|---|---|---|
| **1** | Die neue Bedingung heißt `customer_code_nur_kunde` | Sie heißt `code_only_for_customer`, und die erwartete Fehlermeldung nennt genau diesen Namen | **Ein Name, zwei Vorschläge.** Für sich harmlos — aber weil jeder Negativfall seine Bedingung **beim Namen** nennen muss, würden die blinden Fälle mit M-10s Migration am falschen Namen scheitern. Muss vor dem Bau festgelegt werden. Empfehlung: der deutsche Name, passend zum übrigen Bestand |
| **2** | Die Migration wird gebaut | **N1 und N2 stehen auf *gesperrt*, nicht auf fehlgeschlagen** — bis der Eigentümer von K02 entschieden hat, ob das Verbot gilt | **Der blinde Prüfer, nach der Regel „Klausel schlägt Bau".** Die Bedingung setzt etwas durch, das keine Klausel wörtlich sagt. Erst zeichnen, dann bauen |
| **3** | Vier Negativfälle N5–N8, alle zum Verbot | **Zehn Prüffälle P1–P10 und sechs Negativfälle** — davon sechs zur **Vergabe**: erster Code `DE-AAA`, zweiter `DE-AAB`, Übertrag, kein Ausweichen in den reservierten Namensraum, kein Freiwerden nach Entfernen, kein vorgegebener Code | **Große Lücke bei M-10.** Ich habe nachgesehen: **keine einzige Zeile im Programmtext berührt den Kunden-Code.** Die fortlaufende Vergabe nach `K02-M25`, `K02-M27` und `K02-M28` ist **überhaupt nicht gebaut.** Die Migration schließt eine Seite; die andere Seite existiert nicht |
| **4** | Testcodes `DE-ZQA` bis `DE-ZQD` — im reservierten Namensraum, damit kein echter Kundencode verbraucht wird | Testcodes `DE-AAB`, `DE-AAC` — echte Kundencodes | **M-10 ist hier sicherer.** Solange die Bedingung fehlt, würde ein Fall mit `DE-AAB` durchgehen und diesen Code still verbrauchen. Genau der Schaden, um den es geht |
| **5** | Prüft Einsatzversuche | Fordert zusätzlich **zwei Dauermessungen am Bestand**: (1) Zahl der Zeilen mit Code minus Zahl der Kundenzeilen muss **exakt 0** sein; (2) die Menge der Arten aller Zeilen mit Code muss **genau einen** Wert enthalten | **Der blinde Prüfer ergänzt etwas Wichtiges.** Diese Messungen brauchen keine neue Bedingung, sie laufen heute, und sie schlagen auch dann an, wenn ein Code auf einem Weg entstanden ist, den kein Prüffall kennt |
| **6** | *(nicht enthalten)* | N4: zweiter Kunde mit demselben Code muss an der Eindeutigkeit scheitern | Kleine Lücke. Der Fall besteht heute schon — er gehört als Rückfallprobe dazu |

### 5.4 Zwei Dinge, die vor dem Bau zu berichtigen sind

**Erstens: ein Fehler im Wortlaut von M-10s Negativfall N7.** Dort steht

```sql
INSERT INTO tenant (kind,name,legal_space) VALUES ('N7 Vorbereitung','DE','DE');
```

Drei Spalten, drei Werte — aber verschoben. `'N7 Vorbereitung'` landet in der Spalte für die Art, und das ist kein gültiger Wert. Der Fall würde an der falschen Bedingung scheitern. M-10 hat den Fehler selbst in einem Hinweis bemerkt. **Richtig lautet die Zeile:**

```sql
INSERT INTO tenant (kind,name,legal_space) VALUES ('OPERATOR','N7 Vorbereitung','DE');
```

**Zweitens: die Migration würde im Pilotstand stillschweigend übersprungen.** Nachgeprüft: das Aufbauskript lädt für die Pilotdatenbank nur **vier namentlich genannte Dateien**. Eine neue Migration steht nicht darunter. Für die Prüfdatenbank wird dagegen jede Datei des Ordners geladen. Ohne die Ergänzung des Skripts wäre die Bedingung in der einen Datenbank vorhanden und in der anderen nicht — und niemand bekäme eine Meldung.

### 5.5 Ein Nebenbefund, der zur Sache gehört

Das Prüfskript für die Installation **erzeugt den Schaden heute selbst**. Nachgeprüft, Zeile 27–29: es setzt `DE-AAA` an den Betreiber-Mandanten, ohne Transaktion. Solange die Bedingung fehlt, geht das durch, und der Code bleibt danach stehen. Das Prüfskript ist damit selbst ein Weg, den ersten Kundencode zu verbrauchen. Nach der Migration erledigt sich das von allein.

---

## 6 · Was ein Mensch entscheiden oder zeichnen muss

### M-7 · Klauselschnitt

| # | Zu entscheiden | Wer | Empfehlung |
|---|---|---|---|
| 7.1 | **Sind es 157?** Die 19 Kästchen auf dem Zeichnungsblatt setzen | M. Veil | **Zeichnen.** Die Herleitung ist in drei Schritten nachrechenbar und ich habe jeden nachgerechnet. Die Grenze fällt auf ein Zeilenende, sie muss nicht ausgelegt werden |
| 7.2 | **Die zehn Regeln außerhalb.** Fünf Prüffallgruppen nennen zehn Regeln, die nicht in den 157 stehen | M. Veil | **Hereinnehmen — dann sind es 167.** Was gemessen wird, sollte auch benannt sein. Die Gegenrichtung — Prüffälle beschneiden — wäre schlechter |
| 7.3 | **Die Station *Kenntnisnahme*** bleibt draußen | M. Veil | **Bestätigen.** Das gezeichnete Kreuz endet mit dem Wort *Anmeldung*. Wer sie hereinnimmt, erweitert den Umfang gegen die Zeichnung |
| 7.4 | **Zwei fehlende Leseblätter** herstellen (Anmeldecode, Anmeldung, 25 Regeln) | A. Han / Bau | **Vor der Zeichnung herstellen.** Das ist Arbeit, kein Beschluss — aber ohne sie zeichnet man blind |
| 7.5 | **Sieben offene Vorbehalte** zu einzelnen Regeln | M. Veil | **Vor der Zeichnung klären**, nicht danach |

### M-8 · Fremdprüfung

| # | Zu tun | Wer | Frist | Empfehlung |
|---|---|---|---|---|
| 8.1 | Etikett `scheibenabnahme` anlegen | A. Han | Mo 17.08. vormittags | **Tun.** Ein Befehl. Ohne ihn sind alle 27 bisherigen Läufe umsonst gewesen und alle künftigen auch |
| 8.2 | Den Teilschnitt als eigene Abnahmeeinheit `teilschnitt-anmeldung` benennen | **M. Veil** | Mo 17.08. vormittags | **Zeichnen.** Umfang gehört dem Auftraggeber. Ohne diese Benennung zeigt kein Werkzeug auf etwas |
| 8.3 | Die Fremdprüfung anfordern | A. Han | Mo 17.08. bis 12:00 | **Tun.** Der Lauf kostet 6 Minuten; die Frist ist früh gesetzt, damit Zeit für die Folge bleibt |
| 8.4 | Urteil ablegen, zeichnen, Formprüfung | A. Han | Di 18.08. bis 18:00 | **Tun** |
| 8.5 | Tor 4 zeichnen | M. Veil | nach 8.4 | Die letzte Messstufe |
| 8.6 | Falls A. Han die Schritte 8.3–8.5 nicht übernehmen kann | M. Veil | — | **Dann als Restrisiko eintragen**, nicht als stille Ausnahme. Messender und Abnehmender fallen sonst zusammen |

### M-9 · Ablaufpfad — hier ist am meisten zu entscheiden

| # | Zu entscheiden | Wer | Empfehlung |
|---|---|---|---|
| 9.1 | **Bleibt es bei Blatt 63, Weg A** — aufgeräumt wird beim Widerruf, der Restfall wird als Restposten geführt? | M. Veil und A. Han | **Ja, dabei bleiben.** Es ist am 11.08. von beiden gezeichnet worden und seither ist nichts dazugekommen, was dagegen spräche. Der Restfall ist eine wirkungslose Zeile an einem Konto, das sich nicht anmelden kann |
| 9.2 | **Wird der Aufräumlauf (Folgepunkt B) jetzt gebaut?** | M. Veil | **Nein, nicht vor dem 31.08.** Blatt 63 hat ihn ausdrücklich als Folgepunkt geführt und an eine offene Frage gebunden. Sechzehn Tage vor dem Endtermin ist der falsche Zeitpunkt für genau die Entscheidung, die die Gründer sich vorbehalten haben |
| 9.3 | **Wer ist die handelnde Instanz eines Laufs?** M-9 schlägt vor: kein Konto, dafür der Datenbankbenutzer | M. Veil und A. Han | **Als eigenständige Vorlage führen**, nicht als Nebensatz in einem Bauvorschlag. `K20-M18` verlangt die handelnde Instanz zu **jeder** Änderung — die Antwort wirkt weit über diesen Fall hinaus |
| 9.4 | **Schritt 1 allein bauen** — die Trägerbedingung gegen die Uhr rechnen (zwei Zeilen) | A. Han | **Ja, bauen.** Er widerspricht keiner Zeichnung, ändert das Datenmodell nicht und macht den gezeichneten Weg genauer |
| 9.5 | **MG-08 neu fassen**, damit er gegen den gezeichneten Weg misst statt gegen einen verbotenen Zustandswechsel | **Prüf-Agent**, nicht Bau-Agent | **Beauftragen.** Heute kann der Fall nur „bestanden" melden, wenn eine gezeichnete Regel gebrochen wird — er bleibt sonst dauerhaft gesperrt |
| 9.6 | **Fünf Prüffälle des blinden Prüfers ergänzen:** P2 (nicht abgelaufen), P3 (nur das betroffene Portal), N1 mit Meldung im Wortlaut, N2 (Einladungsplatz), und die Vorher-Messung in jedem Fall | Prüf-Agent | **Übernehmen.** P2 ist der Fall, der P1 ehrlich hält |
| 9.7 | **Den Entstehungszeitpunkt der Mitgliedschaft in K20 nachziehen** | Eigentümer K20 | **Tun.** Er ist gezeichnet (Blatt 62), steht aber in keiner Klausel. Der blinde Prüfer ist genau deshalb daran hängengeblieben |
| 9.8 | **Der fehlende Bezug im Datenmodell**: die Zugangszeile verweist auf keine Einladung | M. Veil | **Als Restrisiko eintragen.** Solange er fehlt, ist die Zuordnung eine begründete Annahme, keine Tatsache — egal, welche Tür gebaut wird |
| 9.9 | **Namensgleichheit** mit dem bereits gezeichneten Aufräumlauf (Beschluss Nr. 125) auflösen | A. Han | Falls 9.2 später doch bejaht wird: **anders benennen** |

### M-10 · Kunden-Code

| # | Zu entscheiden | Wer | Empfehlung |
|---|---|---|---|
| 10.1 | **Gilt das Verbot?** Ist ein Kunden-Code an Betreiber oder Partner *verboten* oder nur *nicht verlangt*? | Eigentümer K02, zeichnend M. Veil | **Verbieten und `K02-G02` nachziehen.** Beide Bearbeiter kommen unabhängig zum selben Schluss. Aber es ist eine Klauseländerung, kein Bauzug — sie gehört gezeichnet, nicht abgeleitet |
| 10.2 | **Gehört das überhaupt in Tor II?** Nach meiner Messung liegen `K02-G02` und `K02-M25` **außerhalb** der 157 Regeln des Teilschnitts | M. Veil | **Bewusst entscheiden.** Entweder gilt es als Arbeit außerhalb des Umfangs — dann nach dem 31.08. — oder der Umfang wird ausdrücklich erweitert. Still mitlaufen sollte es nicht |
| 10.3 | **Erweitert eine neue Migration den Maßstab?** Rang 1 ist heute das eingefrorene Datenmodell **plus** die Sammelmigration M30 in der gezeichneten Fassung | **M. Veil** | **Zeichnen, bevor gebaut wird.** Eine M31 ändert nicht den Bau, sondern den Maßstab, an dem gemessen wird |
| 10.4 | **Der Name der Bedingung** — zwei Vorschläge liegen vor | A. Han | **Einen festlegen und beide Seiten nachziehen**, weil jeder Negativfall seine Bedingung beim Namen nennen muss |
| 10.5 | **Die Vergabe ist überhaupt nicht gebaut.** Keine Zeile im Programmtext berührt den Kunden-Code | M. Veil | **Als eigenen Befund führen.** Er ist größer als B1-F2 und die Migration schließt ihn nicht. Sechs der blinden Prüffälle können deshalb heute nicht bestehen |
| 10.6 | **Zwei Dauermessungen am Bestand** aufnehmen (Zähldifferenz, Zuordnungstreue) | Prüf-Agent | **Übernehmen.** Sie laufen ohne neue Bedingung und finden auch Codes, die auf unbekanntem Weg entstanden sind |
| 10.7 | **Wenn eine Bestandszeile die neue Bedingung verletzt:** nicht automatisch aufräumen | M. Veil | **Zustimmen.** Ein stiller Änderungslauf auf Bestandsdaten wäre genau die Art von Vorgang, die niemand bemerkt — und der Befund handelt davon, dass eine Codevergabe still passiert. Heute ist die Liste in beiden Datenbanken leer |

---

## 7 · Was ich nicht messen konnte

**Zu allen vier Paketen**

- **Ob eine der 157 Regeln erfüllt ist.** Der Schnitt sagt nur, welche gemeint sind. Eine Abdeckungsquote ersetzt die Liste nicht.
- **Ob das Fremdurteil ausfällt wie erhofft.** Es ist nie gelaufen.

**M-7**

- Ob bei *Mandant*, *Einladungsschranke* und *Einladung* dieselbe Sprachlücke besteht wie bei *Anmeldecode*. Die Gegenprobe ist nicht gemacht.
- Ob die Triage-Einstufungen von 125 kritischen Regeln heute noch stimmen. Ihr Stand ist vom 07.08.2026.
- Der Grad, in dem die 44 Regeln mit einer Umsetzungskante tatsächlich umgesetzt sind. Die Kante belegt eine Nennung im Programmtext, keine Deckung.

**M-8**

- Ob eine gültige Fremdprüfung fehlende Belege ersetzen kann. Ein Fremdmodell kann sagen, dass der Programmtext für den Mailweg trägt — es kann nicht bezeugen, dass eine Mail angekommen ist. Blatt 57 verlangt beides.
- Ob die Zugangsdaten für den echten Mailweg heute funktionieren. Sie liegen lokal auf einem fremden Rechner.
- Wie lange das Zusammenstellen der Belege dauert. Gemessen sind nur die 6 Minuten des Laufs selbst.

**M-9**

- **Wie viele abgelaufene Einladungen ein echter Bestand trägt.** Es gibt keine Produktionsdatenbank, gegen die ich messen dürfte.
- Ob die Gründer den Folgepunkt B seit dem 11.08. weiterverfolgt haben. Ich habe kein Blatt gefunden, das darauf zurückkommt — das ist ein Nichtfund, kein Beleg für das Gegenteil.
- Ob der vorgeschlagene Aufräumlauf in der Praxis läuft. Er existiert nicht; M-9 hat nur seine Bedingung an einer Wegwerf-Datenbank gemessen. Ich habe diese Messung **nicht** wiederholt — ich habe die Klauseln, die Zeichnungen und den Programmtext nachgeprüft, nicht den Datenbanklauf.

**M-10**

- **Die volle Wiederholbarkeit.** Das Hausmaß verlangt einen Vergleich der Schemaabzüge vor und nach einem zweiten Lauf. Er lässt sich erst gegen eine frisch aufgebaute Datenbank fahren. Bis dahin ist die Wiederholbarkeit an der Zahl der Bedingungen belegt, am Schemaabzug nicht.
- Ob die vier Negativfälle in der Fassung mit der berichtigten N7-Zeile durchlaufen. M-10 hat mit der fehlerhaften Zeile gemessen und den Fehler nur im Hinweis benannt.
- Ob die Vergabe nach `K02-M25` irgendwo außerhalb des Programmtexts stattfindet — von Hand, in einem Skript, in einem Kopf. Gemessen ist nur: im Programmtext steht sie nicht.

**Zur Arbeitsweise**

- Ich habe **keine Datei geändert**. `git status --short` ist vor und nach dieser Arbeit leer.
- Ich habe die Zahlen von M-7 vollständig nachgerechnet, die Belege von M-8 an Werkzeug, Datei und Ablauf nachgeprüft, die Klauselzitate aller vier Pakete am Original nachgeschlagen und die Datenbanken von M-10 selbst abgefragt. Die Datenbankmessungen von M-9 habe ich **nicht** wiederholt.
- Der eine Punkt, an dem ich über die vier Pakete hinausgegangen bin, war die Suche nach Blatt 62. Sie hat den schwersten Befund dieser Vorlage ergeben.