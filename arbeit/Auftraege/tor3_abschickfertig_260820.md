# Tor 3 · Fremdprüfung `teilschnitt-anmeldung` — **abschickfertig**

**20.08.2026 · Zum Abschicken durch einen Menschen.**

> **Der Harness hat diese Anforderung NICHT abgeschickt und darf es nicht.** Warum das keine
> Förmlichkeit ist, steht in Abschnitt „Warum nicht ich" am Ende dieses Blattes — kurz: ein
> von mir gefahrenes Review erzeugt **keinen gültigen Tor-3-Nachweis**, und das Prüfwerkzeug
> im Repo fängt es ab.

## So wird abgeschickt — drei Handgriffe

| | |
|---|---|
| **1** | Eine **frische Instanz** eines fremden Modells öffnen — leerer Kontext, kein Vorgespräch, nicht dieselbe Sitzung, in der gebaut wurde (C-4) |
| **2** | Das Belegpaket **anhängen**: `tor3_belege_teilschnitt_260820.zip` — 47 Roh-Belege, dazu `PRUEFSUMMEN.txt` und `STAND.txt` |
| **3** | Den Text unter *„Der Auftrag im Wortlaut"* **vollständig einfügen** und abschicken |

**Danach:** das Urteil **unverändert** in `nachweise/fremdreview/teilschnitt-anmeldung_<JJMMTT>.md`
ablegen (Vorlage: `nachweise/fremdreview/VORLAGE.md`), den Kopf ausfüllen und zeichnen, die
Prüfsumme danebenlegen, dann `python3 werkzeuge/fremdreview.py` und `./pruefungen/tor3.sh`.

## Der geprüfte Stand

| | |
|---|---|
| **Abnahmeeinheit** | `teilschnitt-anmeldung` — **abschreiben, nicht tippen** (der Name wird gegen keine Liste gehalten) |
| **Commit** | `248baeda8b8b06c1ae9f9c4778f2ce858cb442ad` |
| **Zweig** | `scheibe/m5-gespraech` · Antrag #42, Tor 1 vollständig grün |
| **Belege** | 47 Dateien, Prüfsummen im Paket |
| **Anfordernde Person** | **A. Han** — gezeichnet am 20.08.2026, Entscheidung 6 der Standortbestimmung |

> **Berichtigt gegenüber dem Blatt vom 16.08.2026:** die vier Negativfall-Dateien heißen jetzt
> `M30_N1…M30_N4` (Frage 21 betrifft ausschließlich diese vier). Das Paket enthält bereits die
> richtigen. Einzelheiten im Nachtrag `tor3_anforderung_teilschnitt_nachtrag_260820.md`.

---

## Der Auftrag im Wortlaut

*Ab hier vollständig kopieren.*

---

Du prüfst als unabhängiges Modell einen Softwarestand. Du bist **nicht** der Bauende und
übernimmst keine seiner Erklärungen.

**Gegenstand:** ein benannter Teilschnitt einer Mandantenanwendung — Einladung senden,
Einladung einlösen, Anmeldung mit sechsstelligem E-Mail-Code, Mitgliedschaft, und
anschließend eine Vorprüfung der Eignung, die bei einem ungeeigneten Ergebnis anhält.
Serverseitig gerendert, PostgreSQL, FastAPI.

**Du bekommst ausschließlich Roh-Belege:** Quelltext, Bildschirmvorlagen,
Änderungsschritte an der Datenbank, Startbestand, Prüffälle, Prüfausgaben, Manifeste und
die geführten Nachweise. Dazu das Zielschema und den Bildschirmvertrag als Maßstab. Du
bekommst keine Berichte und keine Zusammenfassungen des Bauenden. **Wenn du etwas nicht
beurteilen kannst, weil ein Beleg fehlt, sage das, statt es zu vermuten.**

**Nicht Gegenstand:** alles, was nach der Vorprüfung kommt — die Zweckbestimmung, das
Anlegen einer Anwendung, das Gespräch, der Prototyp, das Angebot, die Übergabe.

**Deine Leitfrage:** Trägt dieser Stand fachlich? Beantworte dazu die folgenden 24 Fragen.
Sie sind aus den gezeichneten Klauseln abgeleitet; der Wortlaut der Klausel steht jeweils
dabei, damit du nicht auf mein Wort angewiesen bist.

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

**22** — Scheitern die vier Negativfälle `migrations/negativfaelle/M30_N1…M30_N4` je an **ihrer
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

**Jede Aussage zeigt auf eine Fundstelle `Datei:Zeile`.** Ein Urteil ohne Fundstellen ist
eine Meinung.

Sage bei jeder Frage ausdrücklich, wenn du sie **nicht** beantworten kannst, weil ein
Beleg fehlt. Das ist eine gültige Antwort und die einzige ehrliche.

**Schließe mit genau einem von drei Worten:** **trägt** · **trägt mit Auflagen** ·
**trägt nicht**.

Wenn *trägt mit Auflagen*: nenne je Auflage einen Satz, was zu tun ist.

---

---

## Warum nicht ich

`nachweise/fremdreview/README.md`, wörtlich:

> *„Ein Fremdmodell, das der Harness selbst aufruft, dessen Ausgabe er selbst ablegt und
> dessen Ergebnis er selbst auswertet, ist kein fremder Blick mehr — es ist derselbe Blick
> mit einem anderen Etikett."*

**Und es ist nicht nur eine Regel, es ist gemessen abgesichert.** `werkzeuge/fremdreview.py`
verlangt im Kopf jedes Blattes vier ausdrückliche Bejahungen:

```
frische_instanz · getrennter_kontext · gegen_roh_evidenz · harness_hat_nicht_geschrieben
```

*„Ein ‚nein' oder ‚teilweise' ist kein Formfehler, sondern die Auskunft, dass die Bedingung
aus C-4 und `scheibe.md`:73 nicht erfüllt war. **Dann ist das Blatt kein Tor-3-Nachweis.**"*

Führe **ich** die Anforderung, gibt es genau zwei Ausgänge, und beide sind wertlos:

| | |
|---|---|
| Das Blatt trägt ehrlich `harness_hat_nicht_geschrieben: nein` | Das Werkzeug weist es ab. **Tor 3 bleibt GESPERRT** — es hätte nur Zeit gekostet |
| Das Blatt trägt `ja` | Dann steht dort eine Unwahrheit. `VORLAGE.md` nennt das beim Namen: *„Ein von einem Agenten ausgefüllter Kopf ist kein Nachweis, sondern seine Fälschung"* |

**Das ist der ganze Grund.** Nicht Vorsicht, nicht Zuständigkeitsdenken: ein Tor 3, das ich
fahre, ist keines — und der Riegel dafür liegt im Repo, nicht in meinem Ermessen.

**Was ich getan habe:** die Anforderung ausgefertigt, berichtigt, die 47 Belege eingesammelt
und geprüfsummt, das Paket geschnürt. **Es fehlen drei Handgriffe, und sie gehören einem
Menschen.**
