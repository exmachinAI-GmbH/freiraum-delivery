# Fremdprüfung anfordern · Teilschnitt `teilschnitt-anmeldung`

**Ausfertigung zu B-3 der Schlussrunde, gezeichnet am 16.08.2026.** Der Auftraggeber hat
entschieden, dass die Fremdprüfung angefordert wird. Dieses Blatt ist die fertige
Anforderung. **Ein Mensch schickt sie ab; der Harness tut das nicht und darf es nicht.**

| | |
|---|---|
| **Gegenstand** | der Teilschnitt bis zur Anmeldung, dazu die Vorprüfung mit Halt |
| **Kennung der Abnahmeeinheit** | `teilschnitt-anmeldung` (B-2, gezeichnet 16.08.2026) |
| **Anfordern** | **A. Han** — Vorschlag aus der Handlungsempfehlung, mit der Zeichnung übernommen |
| **Anforderung abschicken bis** | **Montag, 17.08.2026** |
| **Urteil zurück bis** | ⟨Datum⟩ — **trägt A. Han ein.** Warum es hier leer bleibt, steht in Abschnitt 8 |
| **Blatt ablegen und zeichnen** | **A. Han** |
| **Danach die vierte Messstufe** | **M. Veil** — sie läuft nie automatisch |
| **Erstellt** | 16.08.2026, vom Orchestrator des Coding-Harness |
| **Art** | **Ausfertigung. Sie entscheidet nichts.** Jedes Feld in ⟨spitzen Klammern⟩ gehört einem Menschen |

---

## 0 · Der Vorbehalt — er steht bewusst vor allem anderen

**Der Harness schreibt dieses Review nie selbst.** Er holt nur seinen Nachweis herein.

Wörtlich aus `nachweise/fremdreview/README.md`:

> *„Ein Fremdmodell, das der Harness selbst aufruft, dessen Ausgabe er selbst ablegt und
> dessen Ergebnis er selbst auswertet, ist kein fremder Blick mehr — es ist derselbe Blick
> mit einem anderen Etikett."*

Deshalb gilt für dieses Blatt: **ein Mensch fordert an, ein Mensch legt das Urteil ab, ein
Mensch unterschreibt.** Ein von einem Agenten ausgefüllter Kopf ist kein Nachweis, sondern
seine Fälschung.

Was der Harness beisteuert, ist genau dieses Blatt und die Liste der Belege. Er hat kein
Modell aufgerufen, keine Antwort erzeugt und keinen Kopf ausgefüllt.

---

## 1 · Warum jetzt — die Lage, gemessen

Die dritte Messstufe ist **nie gelaufen**. Das ist keine Einschätzung, das ist die Ausgabe
der beiden Prüfwerkzeuge vom 16.08.2026:

```
$ bash pruefungen/tor3.sh
== Tor 3 · der fremde Blick
   Der Nachweis wird geprueft, nicht das Urteil.

Tor 3: kein Fremdreview abgelegt.
  Zustand: GESPERRT -- nicht gemessen ist nicht bestanden (K23-M22).
  Vorlage: /Users/mveil/freiraum-delivery/nachweise/fremdreview/VORLAGE.md
  Das Review wird von einem MENSCHEN angefordert; der Harness
  schreibt es nie selbst (.claude/commands/scheibe.md:73).

Tor 3 sperrt.
```

```
$ python3 werkzeuge/fremdreview.py --stand
Tor 3: **fuer keine Scheibe angefordert.** Das Review fordert ein Mensch an; der Harness
schreibt es nie selbst. Vorlage: arbeit/Vorlagen/tor3_anforderung_scheibe1.md
```

**Was das bedeutet.** Die Zykluszeit der Fremdprüfung ist unbekannt. Blatt 57 macht *„alle
vier Messstufen"* zum gezeichneten Bestandteil des Teilschnitts. Das Etikett
`scheibenabnahme`, das die Prüfung auslöst, existiert seit dem 16.08.2026. Wer den Weg zum
ersten Mal am 28.08. geht, erfährt zu spät, wie lange er dauert. **Bis zum Endtermin am
Montag, 31.08.2026, sind es 15 Tage.**

**Dieser Durchlauf nimmt nichts ab.** Er liefert ein Urteil und eine gemessene Dauer.

---

## 2 · Was geprüft wird

**Der Weg von der Einladung bis zur Anmeldung, und die Vorprüfung, die anhält.**

In Worten, ohne Fachsprache: Jemand wird eingeladen. Die Einladung kommt per E-Mail an. Er
löst sie ein, meldet sich mit einem sechsstelligen Code an und ist Mitglied. Danach
beantwortet er drei Fragen zur Eignung seines Vorhabens. Passt es nicht, **hält der Weg an**
und nennt den Grund, und es stehen genau drei Auswege offen.

### Die Meilensteine, die auf diesem Teilschnitt liegen

| | Zustand, der eintritt | Stand am 16.08.2026 |
|---|---|---|
| **M1** | Die Datenbank steht | **von hier aus nicht bestätigbar.** M1 wird gegen die Zielumgebung gemessen; der Nachweis verweist auf ein Skript, das nicht in diesem Repository liegt. Das Fremdmodell sieht Zielschema und Migration, nicht die Zielumgebung |
| **M2** | Ein Eingeladener kann sich anmelden | **nicht eingetreten.** Drei von vier Teilaussagen bestanden; die vierte — eine echte Zustellung mit abgelesenem Mailkopf — ist **gesperrt**, weil nur ein Mensch mit dem Schlüsselbund und Zugriff auf ein fremdes Postfach sie fahren kann |
| **M3** | Die Vorprüfung hält an | **eingetreten.** Fünf Teilaussagen, fünf bestandene Prüffälle, keiner gesperrt, keiner gescheitert |

Die Wortlaute stehen im Anhang der Verzugsmeldung, `nachweise/meldungen/VERZUG_260814.md`
Zeilen 204–206.

> **Warum M2 trotz der offenen Teilaussage mitgeprüft wird.** Die gesperrte Stelle ist der
> Versandweg nach draußen, nicht der Anmeldeweg. Alles, was das Fremdmodell an M2 beurteilen
> soll — Einlösung, Code, Sitzung, Mitgliedschaft — liegt vollständig als Beleg vor. Die
> gesperrte Stelle wird in Frage 11 ausdrücklich angesprochen.

---

## 3 · Was ausdrücklich **nicht** Gegenstand ist

**Neun Meilensteine sind zurückgestellt und ohne Termin.** Sie werden hier nicht geprüft,
und das Fremdmodell bekommt ihre Dateien nicht.

| | Zustand, der eintreten soll |
|---|---|
| **M4** | Eine Anwendung entsteht nur über den einen Weg |
| **M5** | Das Gespräch trägt und überlebt das Abmelden |
| **M6** | Die sechs Anforderungskonzepte liegen vor |
| **M7** | Der Prototyp ist gebaut und bedienbar |
| **M8** | Das Angebot ist freigebbar |
| **M9** | Das Übergabe-Paket ist abrufbar |
| **M10** | Der Durchstich ist bestanden |
| **M11** | Die Lastprüfung ist bestanden |
| **M12** | Der Wechsel nach `ABNAHME` ist gezeichnet |

**Konkret nicht mitgeben** — diese Dateien gehören zu M4 und sind nicht Gegenstand:

```
app/zweckbestimmung.py
app/vorlagen/en04a_zweckbestimmung.html
migrations/M31__projektnummer_und_zweckbestimmung.sql
migrations/negativfaelle/M31_N1_anlage_ohne_eignung.sql
migrations/negativfaelle/M31_N2_treffer_frage1_ohne_kenntnisnahme.sql
migrations/negativfaelle/M31_N3_treffer_frage2_wird_nicht_weitergefuehrt.sql
migrations/negativfaelle/M31_N4_erklaerung_ohne_zweite_antwort.sql
migrations/pruefe_negativfaelle_M31.sh
pruefungen/klauseln/zweckbestimmung_lauf.sh
pruefungen/klauseln/zweckbestimmung_daten.sql
```

> **Ein Hinweis, der nicht verschwiegen wird.** Der Stand, den Sie im nächsten Abschnitt
> festlegen, kann die Migration `M31` bereits enthalten — sie wird gerade gebaut. Wenn ja,
> sagen Sie es dem Prüfer in einem Satz: *„M31 liegt im Stand, gehört aber nicht zum
> Gegenstand."* Etwas mitzuliefern und zu verschweigen wäre schlechter, als es zu benennen.

---

## 4 · Was Sie brauchen, bevor Sie anfordern

| | |
|---|---|
| **Ein Modell eines anderen Anbieters** | nicht dasselbe, das hier baut. Im Projekt eingespielt: **GPT 5.6 Sol über die Codex-Kommandozeile** — im Terminal, im Ordner `~/freiraum-delivery` |
| **Eine frische Sitzung** | kein fortgesetztes Gespräch, kein übernommener Zusammenhang |
| **Die genaue Fassungsangabe des Modells** | zu Beginn erfragen und notieren. Sie ist eine der zwölf Pflichtangaben im Nachweis; ein Prüfer ohne Fassung ist kein festgehaltener Stand |
| **Der geprüfte Stand** | ⟨40-stelliger Commit-Hash⟩ — **Sie legen ihn fest.** Er muss in diesem Repository auffindbar sein, sonst weist das Prüfwerkzeug das Blatt zurück |

**Wichtig:** Geben Sie dem Modell die **Roh-Belege**, nicht die Berichte des Baus. Ein
Prüfer, der gegen eine Zusammenfassung des Bauenden prüft, prüft die Zusammenfassung.

---

## 5 · Die Roh-Belege — einzeln, mit Pfad

**45 Dateien. Genau diese, sonst nichts.** Alle 45 sind am 16.08.2026 als vorhanden
nachgesehen worden.

### 5.1 · Was gebaut wurde — Quelltext (9)

```
app/__init__.py
app/haupt.py
app/datenbank.py
app/sitzung.py
app/anmeldung.py
app/einladung.py
app/einladung_senden.py
app/vorpruefung.py
mail/versand.py
```

### 5.2 · Was der Benutzer sieht — Bildschirme (7)

```
app/vorlagen/start.html
app/vorlagen/en01_anmeldung.html
app/vorlagen/en02_uebersicht.html
app/vorlagen/en03_vorpruefung.html
app/vorlagen/en04_eignung.html
app/vorlagen/einladung.html
app/vorlagen/einladung_senden.html
```

### 5.3 · Die Änderungsschritte an der Datenbank (5)

```
migrations/M30__pilot_sammelmigration.sql
migrations/negativfaelle/N1_frist_ge_mindestfrist.sql
migrations/negativfaelle/N2_mail_fehler_braucht_grund.sql
migrations/negativfaelle/N3_pseudonym_vor_frist.sql
migrations/negativfaelle/N4_tagesfrist_positiv.sql
```

> **Achtung, zwei verschiedene Sätze tragen ähnliche Bezeichnungen.** Die **vier**
> SQL-Dateien oben sind etwas anderes als die **fünf** Fälle in
> `migrations/pruefe_negativfaelle.sh`. Sie prüfen Verschiedenes. **Frage 21 unten betrifft
> ausschließlich die vier SQL-Dateien**; die erwartete Bedingung steht in deren Kopfzeile
> (`-- erwartet: …`) und wird von `pruefungen/lauf.sh` ausgelesen. Geben Sie
> `pruefe_negativfaelle.sh` **nicht** mit — es würde den Prüfer auf einen fremden Testsatz
> lenken.

### 5.4 · Der Startbestand (2)

```
seeds/Seed_Welle1_M1-M4.sql
seeds/Seed_Vorpruefung_K04.sql
```

### 5.5 · Was gemessen wurde — Prüffälle und Prüfausgaben (14)

```
pruefungen/lauf.sh
pruefungen/migration/M30__pruefung.sql
pruefungen/klauseln/anmeldung_lauf.sh          pruefungen/klauseln/anmeldung_daten.sql
pruefungen/klauseln/anmeldecode_lauf.sh        pruefungen/klauseln/anmeldecode_daten.sql
pruefungen/klauseln/einloesung_lauf.sh         pruefungen/klauseln/einloesung_daten.sql
pruefungen/klauseln/versand_lauf.sh            pruefungen/klauseln/versand_daten.sql
pruefungen/klauseln/mitgliedschaft_lauf.sh     pruefungen/klauseln/mitgliedschaft_daten.sql
pruefungen/klauseln/vorpruefung_lauf.sh        pruefungen/klauseln/vorpruefung_daten.sql
```

`M30__pruefung.sql` ist mit rund 92 000 Zeichen die größte Datei der Liste. Sie enthält die
110 Prüffälle hinter der Zeile *„110 von 110"* im Protokoll.

### 5.6 · Die Manifeste (4)

```
nachweise/manifeste/tor1c_260814.json      nachweise/manifeste/tor1c_260814_manifest.json
nachweise/manifeste/tor1c_260813.json      nachweise/manifeste/tor1c_260813_manifest.json
```

### 5.7 · Die vier geführten Nachweise (4)

```
nachweise/klauselregister/register.md      — Klauselregister (K23-M01/M02)
nachweise/klauselregister/triage.md        — Vorschlag der Kritikalitäten (K23-M04)
nachweise/herkunft/herkunft.json           — Herkunftsgraph (K23-M03)
nachweise/restrisiken/restrisiken.md       — Restrisikoliste (K23-M04, K23-D07)
```

Zu `register.md` und `triage.md` gibt es je eine maschinenlesbare Fassung mit derselben
Endung `.json` im selben Ordner. Wer lieber maschinell liest, nimmt diese.

### 5.8 · Der Maßstab — was geschuldet ist (2)

Diese beiden sind **keine Belege des Baus**, sondern die Quelle, gegen die geprüft wird.
Rang 1 der Quellenordnung:

```
schema/freiraum_datamodel.sql     — das autoritative Zielschema
schema/K19_screens.yaml           — der Bildschirmvertrag
```

### 5.9 · Was ausdrücklich **nicht** mitgegeben wird

Alles, was der Bau über sich selbst erzählt:

```
arbeit/Bauberichte/     alle Messberichte und Nachmessungen
arbeit/Plaene/          die Baupläne
HANDOVER_260814.md · HANDOVER_260815.md   die Tagesübergaben
README.md · CLAUDE.md · CONTRIBUTING.md   die Beschreibungen des Verfahrens
dieses Blatt
```

**Der Grund in einem Satz:** Ein Bericht erklärt, warum etwas richtig ist. Ein Beleg zeigt,
was da ist. Tor 3 prüft Belege.

---

## 6 · Der Auftrag an das fremde Modell

**Wortlaut zum Übernehmen.** Er ist so geschrieben, dass er ohne dieses Blatt trägt.

> Du prüfst als unabhängiges Modell einen Softwarestand. Du bist **nicht** der Bauende und
> übernimmst keine seiner Erklärungen.
>
> **Gegenstand:** ein benannter Teilschnitt einer Mandantenanwendung — Einladung senden,
> Einladung einlösen, Anmeldung mit sechsstelligem E-Mail-Code, Mitgliedschaft, und
> anschließend eine Vorprüfung der Eignung, die bei einem ungeeigneten Ergebnis anhält.
> Serverseitig gerendert, PostgreSQL, FastAPI.
>
> **Du bekommst ausschließlich Roh-Belege:** Quelltext, Bildschirmvorlagen,
> Änderungsschritte an der Datenbank, Startbestand, Prüffälle, Prüfausgaben, Manifeste und
> die geführten Nachweise. Dazu das Zielschema und den Bildschirmvertrag als Maßstab. Du
> bekommst keine Berichte und keine Zusammenfassungen des Bauenden. **Wenn du etwas nicht
> beurteilen kannst, weil ein Beleg fehlt, sage das, statt es zu vermuten.**
>
> **Nicht Gegenstand:** alles, was nach der Vorprüfung kommt — die Zweckbestimmung, das
> Anlegen einer Anwendung, das Gespräch, der Prototyp, das Angebot, die Übergabe.
>
> **Deine Leitfrage:** Trägt dieser Stand fachlich? Beantworte dazu die folgenden 24 Fragen.
> Sie sind aus den gezeichneten Klauseln abgeleitet; der Wortlaut der Klausel steht jeweils
> dabei, damit du nicht auf mein Wort angewiesen bist.

### A · Anmeldung, Sitzung, Zugriffsweg

**1 — K03-M13** *(MUSS)*: „Jede Prüfung der Anmeldung MUSS serverseitig erfolgen; eine
Prüfung allein in der Oberfläche gilt als nicht erfolgt."
→ Gibt es einen Weg, auf dem eine Prüfung nur in der Oberfläche stattfindet?

**2 — K13-M05** *(MUSS)*: „Jeder Aufruf aus einer Oberfläche MUSS über den Serverpfad
laufen. Der Serverpfad prüft aktives Konto, Mitgliedschaft, Rolle, Mandant und Objektbezug,
bevor er liest oder schreibt."
→ Fünf Prüfungen sind verlangt. **Welche davon geschehen tatsächlich, und wo genau?** Nenne
jede fehlende einzeln.

**3 — K03-D01** *(DARF NICHT)*: „Kein Vorgang DARF ohne gültige Sitzung und ohne
`status = AKTIV` wirksam werden. `WARTET_2FA` und `GESPERRT` führen zur Ablehnung, nie zum
Teil-Zugang."
→ Gibt es einen Teil-Zugang? Kann jemand im Zustand *wartet auf zweiten Faktor* irgendetwas
bewirken?

**4 — K03-M05** *(MUSS)*: „Der zweite Faktor MUSS ein sechsstelliger Code per E-Mail sein:
`mfa_method = EMAIL_CODE`. Ein anderes Verfahren führt das Datenmodell nicht."
→ Setzt der Code irgendeine Stelle im Quelltext durch — oder steht die Regel nur im
Prüffall?

**5 — K03-M15** *(MUSS)*: „Ein E-Mail-Code ist zehn Minuten und genau einmal gültig. Ein
neuer Code entwertet alle älteren Codes desselben Kontos. Gespeichert wird nur sein
kryptografischer Prüfwert."
→ Vier Teilaussagen. **Prüfe jede einzeln** und sage je Teilaussage, ob sie im Code
durchgesetzt ist, nur im Prüffall behauptet wird, oder fehlt.

**6 — K03-G01** *(GILT)*: „Es GILT fail-closed: nicht erfüllte oder nicht prüfbare
Vorbedingung sperrt; die Sperre wird begründet angezeigt."
→ In welchen Fällen sperrt der Stand **ohne** Begründung? Zähle sie auf.

### B · Einladung

**7 — K20-M08** *(MUSS)*: „Gespeichert MUSS allein der Streuwert des Links werden. Wer den
Datenbestand liest, darf keine fremde Einladung einlösen können."
→ Angenommen, jemand liest die ganze Datenbank. Kann er eine fremde Einladung einlösen?

**8 — K20-M14** *(MUSS)*: „Die Einlösung MUSS Zustand und Zeitpunkt gemeinsam setzen:
`EINGELOEST` nur mit `redeemed_at`, `redeemed_at` nur mit `EINGELOEST`."
→ Gibt es einen Pfad, auf dem die eine Hälfte ohne die andere entsteht — auch bei Abbruch
mitten im Vorgang?

**9 — K20-M15** *(MUSS)*: „Nach der Einlösung MUSS das Konto von `WARTET_2FA` auf `AKTIV`
wechseln."
→ Geschieht das im selben Zug wie die Einlösung, oder kann es dazwischen hängen bleiben?

**10 — K20-D10** *(DARF NICHT)*: „Eine abgelaufene, eingelöste oder widerrufene Einladung
DARF NICHT erneut wirken. Ein verfallener Link führt zu einem neuen Vorgang, nie zu einer
Verlängerung."
→ Was passiert bei **zwei gleichzeitigen** Einlösungen desselben Links?

**11 — K03-M25** *(MUSS)*: „Ein serverseitiger, idempotenter Einladungsbefehl prüft
Zielmandant, Entscheidungsnachweis und Domäne und legt Einladung und Ereignis atomar an.
Portal, Builder und Service-Schlüssel dürfen diese Prüfung nicht umgehen; Fehlermeldungen
geben nicht preis, ob ein Konto existiert."
→ Sechs Teilaussagen. **Verraten die Fehlermeldungen, ob ein Konto existiert?** Zitiere die
Meldungen im Wortlaut.

**12 — K03-M26** *(MUSS)*: „Der Versand nutzt verwaltete Identität oder Secret-Referenz, eine
erlaubte Ausgangsverbindung und datensparsame Telemetrie. Codes und vollständige
E-Mail-Adressen stehen nie in Logs. Providerfehler, fehlender Nachweis oder unklare
Konfiguration wirken fail-closed und alarmieren den Betrieb mit Runbook-Verweis."
→ Welche der fünf Teilaussagen ist gebaut, welche nicht?

**13 — K20-M18** *(MUSS)*: „Jede Änderung an Zugang, Rolle, Mitgliedschaft oder Einladung
MUSS mit Zeitpunkt, handelnder Instanz sowie Wert davor und danach im internen Nachweis
stehen."
→ Finde eine Änderung, die **keine** Spur hinterlässt, oder deren Spur den Wert davor nicht
trägt.

**14 — K20-M25** *(MUSS)*: „Wiederversand zeigt: *Der vorherige Link ist ungültig.* Der
Nachweis einer Zugangsänderung trägt `retention_class = BETRIEBSPROTOKOLL`."
→ Wird die Aufbewahrungsklasse gesetzt — oder nur der Hinweis angezeigt?

### C · Die Mandantengrenze

**15** — Kann ein Mandant Daten eines anderen sehen, lesen oder ändern? Prüfe jede Abfrage
und jede Schreibanweisung darauf, ob der Mandant in der Bedingung steht. **Nenne jede
Stelle, an der er fehlt** — auch dann, wenn sie praktisch unerreichbar scheint.

### D · Vorprüfung und Halt

**16 — K04-M04** *(MUSS)*: „Der Eignungs-Check MUSS genau drei Fragen führen, je eine je
Dimension Art, Nutzung, Daten. `fit_question.dimension` ist Pflicht und je Dimension einmal
belegbar."
→ Genau drei, nicht zwei, nicht vier?

**17 — K04-M07** *(MUSS)*: „Vier Antwortmöglichkeiten MÜSSEN `is_eligible = falsch` tragen:
reine Netzseite, etwas zum Installieren auf Rechner oder Gerät, Wegwerf-Versuch ohne
Produktivbetrieb, bei der Datenfrage *Nein — es geht um Darstellung, Inhalte oder
Gestaltung*."
→ Stehen alle vier im Startbestand, im Wortlaut, mit dem richtigen Kennzeichen?

**18 — K04-M08** *(MUSS)*: „Nach einem Halt MÜSSEN genau drei Auswege erscheinen: Antwort
ändern, Gespräch mit der Ansprechperson vereinbaren, zur Übersicht zurückkehren."
→ Genau drei? Führt jeder tatsächlich dorthin, wo er hinführen soll?

**19 — K04-M09** *(MUSS)*: „Der Halt MUSS begründet angezeigt werden. Der Nutzer erfährt,
welche Antwort ihn aufhält."
→ Erfährt er **welche Antwort** — oder nur, dass er aufgehalten wird?

**20 — K04-D04** *(DARF NICHT)*: „Ein Check mit `NICHT_GEEIGNET` DARF NICHT ins Gespräch
führen. Es entsteht keine Anwendung und keine Angebotsanfrage."
→ Gibt es einen Weg, auf dem nach einem Halt doch etwas entsteht? **Achte besonders auf
gleichzeitige Aufrufe und auf den Rücksprung über die Übersicht.**

**21 — K04-G11** *(GILT)*: „Bis Antwortkatalog und Wiederanlauf beschlossen sind, ist K04 nur
Freigabekandidat; der Produktivweg bleibt gesperrt."
→ Öffnet der Stand irgendwo einen Produktivweg, den diese Klausel gesperrt hält?

### E · Misst die Prüfung, was sie zu messen vorgibt

**22** — Scheitern die vier Negativfälle unter `migrations/negativfaelle/` je an **ihrer
eigenen** Bedingung — oder an einer anderen? Die erwartete Bedingung steht in der Kopfzeile
jeder Datei. **Zitiere je Fall die Fehlermeldung im Wortlaut.**

**23** — Misst ein Prüffall ein **Vorkommen** statt einer **Unterscheidung**? Also: prüft er,
ob ein Text irgendwo auf der Seite steht, obwohl der Text dort ohnehin immer steht? Nenne
jeden solchen Fall. Und umgekehrt: misst ein Prüffall etwas, das der Code so nicht tut?

**24 — K23-D09** *(DARF NICHT)*: „Geheimnisse, Zugangswerte oder unmaskierte
personenbezogene Angaben DÜRFEN NICHT in Manifest, Log, Screenshot oder Fehlerausgabe
gelangen."
→ Steht irgendwo ein Code, ein Kennwort oder eine vollständige E-Mail-Adresse? Und: **wo
behauptet ein Protokoll oder Manifest etwas, das die Belege nicht hergeben?**

### Form der Antwort

> **Jede Aussage zeigt auf eine Fundstelle `Datei:Zeile`.** Ein Urteil ohne Fundstellen ist
> eine Meinung.
>
> Sage bei jeder Frage ausdrücklich, wenn du sie **nicht** beantworten kannst, weil ein
> Beleg fehlt. Das ist eine gültige Antwort und die einzige ehrliche.
>
> **Schließe mit genau einem von drei Worten:** **trägt** · **trägt mit Auflagen** ·
> **trägt nicht**.
>
> Wenn *trägt mit Auflagen*: nenne je Auflage einen Satz, was zu tun ist.

---

## 7 · Das Urteil ablegen

1. `nachweise/fremdreview/VORLAGE.md` kopieren nach
   **`nachweise/fremdreview/teilschnitt-anmeldung_260817.md`** — Kennung der Abnahmeeinheit,
   dann das Datum in der Form JJMMTT.
2. Den Kopf ausfüllen. **Zwölf Pflichtangaben**, alle zwölf:

   | Feld | einzutragen |
   |---|---|
   | `scheibe` | `teilschnitt-anmeldung` |
   | `datum` | Tag der Ablage, in der Form JJJJ-MM-TT |
   | `geprueft_commit` | der volle 40-stellige Hash aus Abschnitt 4 |
   | `pruefendes_modell` | Name des fremden Modells |
   | `pruefende_fassung` | seine Fassungsangabe |
   | `frische_instanz` | `ja` — **bitte aktiv bestätigen, siehe Anhang, Abweichung 1** |
   | `getrennter_kontext` | `ja` — dasselbe |
   | `gegen_roh_evidenz` | `ja` — dasselbe |
   | `evidenz` | die Belege mit Pfad, nicht „der Baubericht" |
   | `angefordert_von` | Ihr Name |
   | `harness_hat_nicht_geschrieben` | `ja` — dasselbe |
   | `urteil` | `traegt` · `traegt mit auflagen` · `traegt nicht` |

3. Das Urteil **unverändert** einsetzen. Nicht zusammenfassen, nicht glätten, nicht kürzen —
   ein zusammengefasstes Fremdurteil ist wieder das eigene Wort.
4. Die Fundstellen in den dafür vorgesehenen Abschnitt setzen. **Der Abschnitt darf nicht
   leer bleiben** — das Werkzeug merkt es nicht, aber ein Urteil ohne Fundstellen ist eine
   Meinung. Siehe Anhang, Abweichung 2.
5. Unterschreiben — Name **und** Datum, beides ist nötig.
6. Prüfsumme daneben legen und prüfen. Im Terminal, im Ordner `~/freiraum-delivery`:

```bash
cd nachweise/fremdreview
shasum -a 256 teilschnitt-anmeldung_260817.md > teilschnitt-anmeldung_260817.md.sha256
cd ../..
python3 werkzeuge/fremdreview.py
bash pruefungen/tor3.sh
```

**Wenn es gut geht:** eine Zeile `BESTANDEN` je abgelegtem Nachweis und
*„Tor 3 bestanden. Tor 4 ist der Mensch und laeuft nie automatisch."*

**Wenn etwas fehlt:** Das Werkzeug nennt jedes fehlende Feld beim Namen und meldet
**GESPERRT**. Das ist die richtige Meldung. *Gesperrt* heißt *nicht gemessen*, nicht
*durchgefallen*.

7. **Danach die vierte Messstufe: M. Veil.** Sie läuft nie automatisch und wird von keinem
   Werkzeug ausgelöst.

---

## 8 · Die zweite Messung dieses Durchlaufs — die Zeit

Bitte notieren Sie zwei Zeitpunkte. Sie sind der zweite Grund, warum dieser Durchlauf jetzt
stattfindet:

| | |
|---|---|
| Anforderung abgeschickt am | ⟨Datum, Uhrzeit⟩ |
| Urteil abgelegt und Formprüfung bestanden am | ⟨Datum, Uhrzeit⟩ |
| **Dauer des Zyklus** | ⟨…⟩ |

**Deshalb steht im Kopf dieses Blattes keine Frist für die Rückgabe des Urteils.** Sie zu
setzen hieße zu behaupten, wie lange der Weg dauert — und genau das ist unbekannt. Nach
diesem Durchlauf ist es gemessen, und dann trägt jede spätere Terminaussage zu Tor 3.

---

## 9 · Anhang · Vier Stellen, an denen Nachweisblatt und Prüfwerkzeug auseinandergehen

**Am 16.08.2026 gemessen, mit Probeblättern in einem getrennten Ordner. Am Werkzeug wurde
nichts geändert** — es zu ändern ist nicht Sache des Harness, und der Befund gehört zuerst
den Menschen, die das Blatt ausfüllen.

### Abweichung 1 · Die vier Bestätigungen bringt die Vorlage schon bejaht mit

`nachweise/fremdreview/VORLAGE.md` trägt in den Zeilen 26, 27, 28 und 31 bereits den Wert
`ja` — bei `frische_instanz`, `getrennter_kontext`, `gegen_roh_evidenz` und
`harness_hat_nicht_geschrieben`.

Das sind genau die vier Angaben, von denen `nachweise/fremdreview/README.md` sagt, sie seien
**„Bestätigungen, die nur Sie geben können"**. Wer die Vorlage kopiert und die anderen acht
Felder ausfüllt, hat vier Aussagen bestätigt, die er nie aktiv gemacht hat.

**Gegenprobe, dass die Prüfung selbst richtig arbeitet:** Ein Blatt mit
`frische_instanz = nein` wird zurückgewiesen.

```
GESPERRT       c_nein_260817.md  Scheibe t  Testmodell v0
               - 'frische_instanz' lautet 'nein', nicht 'ja' -- die Bedingung aus C-4
                 und scheibe.md:73 war nicht erfuellt; das Blatt ist dann kein Tor-3-Nachweis
```

Die Mechanik ist also in Ordnung. Nur die **Voreinstellung** nimmt die Antwort vorweg.

**Was das für Sie heißt:** Lesen Sie die vier Zeilen und setzen Sie den Wert bewusst — auch
dann, wenn er schon dasteht. **Vorschlag zur Behebung, zur Entscheidung durch den
Eigentümer des Blattes:** die vier Werte in der Vorlage durch `<ja | nein>` ersetzen, damit
sie als Platzhalter erkannt und erzwungen werden.

### Abweichung 2 · Fundstellen werden gefordert, aber nicht gemessen

`README.md` führt in der Liste des Geprüften die Zeile **„Fundstellen im Urteil"**. Das
Werkzeug prüft an dieser Stelle nur, ob die **Überschrift** `## Fundstellen` im Blatt
vorkommt — und die bringt die Vorlage mit.

**Gemessen:** Ein Blatt ohne einen einzigen Satz Urteil und ohne eine einzige Fundstelle
besteht.

```
BESTANDEN      probe_260817.md  Scheibe teilschnitt-anmeldung  Testmodell v0
----
Tor 3: 1 bestanden, 0 fehlgeschlagen, 0 gesperrt
```

Unter beiden Überschriften stand in diesem Probeblatt nur der Kommentar aus der Vorlage:
`<!-- hier das Urteil -->` und `<!-- hier die Fundstellen -->`.

**Was das für Sie heißt:** Dass das Werkzeug grün meldet, belegt nicht, dass ein Urteil im
Blatt steht. Das belegt nur Ihr Blick.

### Abweichung 3 · Eine Abfrage nach einer Abnahmeeinheit ohne Blatt meldet grün

Wird nach einer bestimmten Abnahmeeinheit gefragt, für die **kein** Blatt vorliegt, während
für eine andere eines vorliegt, meldet das Werkzeug Rückgabewert 0 — also *bestanden*.

**Gemessen**, mit einem Blatt für eine andere Einheit im Ordner:

```
$ python3 werkzeuge/fremdreview.py --scheibe teilschnitt-anmeldung
----
Tor 3: 0 bestanden, 0 fehlgeschlagen, 0 gesperrt
RUECKGABE: 0
```

Und `pruefungen/tor3.sh` gibt diesen Rückgabewert unverändert weiter — es meldete dann
*„Tor 3 bestanden."*

Das widerspricht K23-M22: *nicht gemessen ist nicht bestanden.* **Heute wirkt es nicht**,
weil noch gar kein Blatt abgelegt ist und der andere Zweig des Werkzeugs greift. Es wirkt
**ab dem Tag, an dem das erste Blatt liegt** — also ab diesem Durchlauf.

**Was das für Sie heißt:** Rufen Sie `bash pruefungen/tor3.sh` **ohne** Angabe einer
Abnahmeeinheit auf. Dann werden alle Blätter geprüft, und die Lücke greift nicht.

### Abweichung 4 · Ein Blatt, das den Namen der Abnahmeeinheit falsch trägt, fällt nicht auf

Das Feld `scheibe` wird gegen keine Liste gehalten. Ein Tippfehler im Namen
`teilschnitt-anmeldung` erzeugt kein Blatt, das *falsch* wäre — er erzeugt ein Blatt für eine
Einheit, die es nicht gibt. Zusammen mit Abweichung 3 heißt das: der Tippfehler bleibt
unbemerkt, und die Abfrage für die richtige Einheit meldet trotzdem grün.

**Was das für Sie heißt:** Schreiben Sie den Namen ab, tippen Sie ihn nicht.

---

## Zeichnung

*Dieser Block wird von Menschen ausgefüllt. Der Harness trägt hier nichts ein.*

- [ ] **Die Anforderung ist so abgeschickt worden** — an ⟨Modell⟩, am ⟨Datum, Uhrzeit⟩
- [ ] **Abweichend von diesem Blatt:** ⟨was, und warum⟩

| Name | Rolle | Datum | Anmerkung |
|---|---|---|---|
| **A. Han** | fordert an, legt ab, zeichnet den Kopf | | |
| **M. Veil** | vierte Messstufe, nach der Ablage | | |

---

*Ausgefertigt am 16.08.2026 vom Orchestrator des Coding-Harness, auf Grundlage der am
16.08.2026 gezeichneten Entscheidung B-3. Träger, Frist und zeichnende Personen sind aus der
Handlungsempfehlung übernommen, nicht selbst gesetzt. **Der Harness hat kein Modell
aufgerufen und kein Review geschrieben.** Er hat diese Anforderung ausgefertigt, damit ein
Mensch sie nur noch abschicken muss.*
