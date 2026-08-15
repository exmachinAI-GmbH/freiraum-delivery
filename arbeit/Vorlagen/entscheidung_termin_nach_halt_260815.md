# Entscheidung · Darf nach einem Halt ein Termin angeboten werden?

> **Zwei gezeichnete Klauseln widersprechen einander.** Der Harness löst das nicht auf —
> er legt beide Lesarten mit ihren Folgen vor. Entschieden wird von Menschen.

| | |
|---|---|
| Vorgelegt am | 15.08.2026 |
| Gefunden bei | Bau von M3 („Die Vorprüfung hält an"), Scheibe 2 |
| Betroffener Code | `app/vorpruefung.py`, Weg `POST /eignung/termin` |
| Kennung | **BEF-M3-3** |
| Zu zeichnen von | M. Veil · A. Han nicht erforderlich (kein Eigentum an einer Bauaufgabe berührt) |

---

## 1 · Der Widerspruch in zwei Sätzen

Die eine Klausel **verlangt** den Termin nach dem Halt:

> **K04-M08** · MUSS — *„Nach einem Halt MÜSSEN genau drei Auswege erscheinen: Antwort
> ändern, **Gespräch mit der Ansprechperson vereinbaren**, zur Übersicht zurückkehren."*

Die andere **verbietet**, dass ein gehaltener Check ins Gespräch führt:

> **K04-D04** · DARF NICHT — *„Ein Check mit NICHT_GEEIGNET DARF NICHT **ins Gespräch
> führen**. Es entsteht keine Anwendung (Eigentümer K01) und keine Angebotsanfrage."*

Beide gelten für **denselben Zustand**: einen Eignungs-Check mit dem Ergebnis
`NICHT_GEEIGNET`. Die eine sagt *muss*, die andere sagt *darf nicht*.

## 2 · Was der Bau heute tut

`POST /eignung/termin` schreibt nach dem Halt eine Ereigniszeile:

```
action      = TERMIN_ANGEFRAGT
object_ref  = FIT_CHECK:<Kennung des Checks>
value       = "Ergebnis NICHT_GEEIGNET"
```

Es entsteht **keine Anwendung und keine Angebotsanfrage** — insoweit ist Satz 2 von K04-D04
eingehalten. Ob Satz 1 eingehalten ist, hängt allein davon ab, was *„ins Gespräch führen"*
bedeutet. Genau das ist die Frage.

---

## 3 · Lesart A — *Gespräch* meint das geführte Gespräch im Produkt

**Dann besteht kein Widerspruch.** K04-D04 verbietet, dass ein gehaltener Check in die
Stufen 01/02 des Produkts einmündet; K04-M08 erlaubt den Anruf bei einem Menschen. Zwei
verschiedene Dinge, die nur dasselbe Wort tragen.

**Wofür diese Lesart spricht:**

| Beleg | Wortlaut |
|---|---|
| K05 heißt so | *„Geführtes Gespräch (Stufen 01/02)"* — im Konzeptbestand ist *Gespräch* der Name dieser Produktstufe |
| Das Fadendiagramm der Baustrategie | *„ein **Gesprächspfad** (Stufen 01–02) ▶ Anforderungen/Vertrag (Stufe 03)"* |
| Satz 2 derselben Klausel | *„Es entsteht keine Anwendung und keine Angebotsanfrage"* — beides sind Produktartefakte. Satz 2 erläutert Satz 1 |
| Der Bildschirmvertrag | `EN-04`, Aktion `termin`, Serverbefehl **`request_contact_appointment`**, Erfolgszustand *„Gespräch mit der **Ansprechperson** angestoßen (K04-M08)"* — er nennt K04-M08 ausdrücklich und spricht von der Ansprechperson, nicht vom Produktgespräch |
| Sachlogik | Ein Kunde, dessen Anliegen die Prüfung nicht besteht, ist genau der Fall, in dem ein Mensch helfen sollte. Ihm den Rückruf zu verwehren wäre die härteste denkbare Auslegung |

**Folge, wenn A gilt:** Der Bau bleibt wie er ist. Aufzunehmen ist ein klarstellender Satz,
damit der Widerspruch nicht bei jedem Lesen neu auftaucht.

---

## 4 · Lesart B — *Gespräch* meint jede Fortführung, auch das Telefonat

**Dann gilt der Widerspruch, und eine Klausel muss zurücktreten.**

**Wofür diese Lesart spricht:**

| Beleg | |
|---|---|
| Der Wortlaut ist unbeschränkt | K04-D04 sagt *„ins Gespräch führen"* — ohne Zusatz *„geführte"*, ohne Verweis auf K05 oder auf eine Stufe |
| Der Zweck des Halts | Ein Halt soll **beenden**. Ein Ausweg, der eine Fortsetzung anbahnt, weicht ihn auf |
| Der schärfere Fall | K04-D10 sagt zum zweiten Halt: *„dort heilt keine Aufklärung und keine Bestätigung."* Wenn schon eine Bestätigung nicht heilt, dann vielleicht auch kein Termin |

**Folge, wenn B gilt:** Der Termin-Ausweg darf nach einem Halt **nicht** angeboten werden.
Dann aber verlangt K04-M08 *„genau drei Auswege"*, und es blieben nur zwei — die Klausel
wäre nicht erfüllbar. **B erzwingt damit eine Änderung an einer der beiden gezeichneten
Klauseln**, nicht nur am Bau.

---

## 5 · Was gemessen ist, und was nicht

**Gemessen:** Der Bau legt nach dem Halt **keine Anwendung** an, `fit_check.app_id` bleibt
leer, es entsteht **keine Angebotsanfrage** (Prüffall VP-16, bestanden). Satz 2 von K04-D04
ist eingehalten — darüber besteht kein Streit.

**Nicht entscheidbar durch Messung:** Ob eine Ereigniszeile *„Termin angefragt"* ein
*„Gespräch"* im Sinne von Satz 1 ist. Das ist eine Frage der Auslegung, keine der Messung.

**Ein Hinweis zur Reichweite:** Der Termin-Ausweg ist heute nur ein **Nachweis des
Wunsches**. Wer die Ansprechperson erreicht, ist nicht gebaut — die Tabelle `contact`
gehört zu K11 und trägt im Pilotbestand keine Zeile. Selbst unter Lesart B entsteht heute
also kein tatsächliches Gespräch, sondern nur ein Vermerk.

---

## 6 · Empfehlung des Harness — ein Vorschlag, keine Entscheidung

**Lesart A.** Fünf Belege stützen sie, darunter der Bildschirmvertrag, der beide Klauseln
selbst nebeneinanderstellt und dabei von der *Ansprechperson* spricht. Lesart B stützt sich
allein darauf, dass der Wortlaut keinen Zusatz trägt — und sie führt in eine Sackgasse: sie
macht K04-M08 unerfüllbar und erzwingt eine Klauseländerung.

**Der Vorschlag ist ein Vorschlag. Er nimmt die Entscheidung nicht vorweg und darf nie als
Freigabe gelesen werden.**

---

## 7 · Was aus jeder Entscheidung folgt

| Entscheidung | Was zu tun ist |
|---|---|
| **A** — *Gespräch* meint die Produktstufen | Der Bau bleibt. In K04 wird ein klarstellender Satz nachgetragen, damit der Widerspruch nicht wiederkehrt. Der Befund BEF-M3-3 wird geschlossen |
| **B** — *Gespräch* meint jede Fortführung | Der Termin-Ausweg entfällt nach einem Halt. **K04-M08 muss geändert werden** — statt *„genau drei"* dann *„zwei nach einem Halt"*. Das ist eine Konzeptänderung und läuft über die Konzept-Fabrik, nicht über den Bau |
| **Keine Entscheidung** | Der Befund bleibt offen und geht als **kritisches Restrisiko** in die Liste. Nach Blatt 11:137 braucht jedes kritische Restrisiko eine **gezeichnete Annahmeentscheidung** — die Liste allein genügt nicht |

---

## Menschliche Entscheidung

- [x] **Lesart A** — *Gespräch* meint das geführte Gespräch der Stufen 01/02. Der
      Termin-Ausweg bleibt zulässig.
- [ ] **Lesart B** — *Gespräch* meint jede Fortführung. Der Termin-Ausweg entfällt nach
      einem Halt, und K04-M08 ist zu ändern.
- [ ] **Nicht entschieden** — weil:

| Name | Datum | Begründung / Auflagen |
|---|---|---|
| **M. Veil** (Founder) | **15.08.2026** | Lesart A. Der Termin-Ausweg nach einem Halt bleibt zulässig; *Gespräch* im Sinne von K04-D04 Satz 1 meint die geführten Stufen 01/02, nicht den Anruf bei einer Ansprechperson. |
| *Vermerk zur Form* | 15.08.2026 | Auf ausdrückliche Weisung des Founders vom Orchestrator **übertragen, nicht selbsttätig gesetzt** (F40, Muster BV-22 vom 05.08.2026). Wortlaut der Weisung: *„Ich entscheide hiermit Leseart A, gez. M. Veil, 15.8.26"*. Es wurde genau dieser eine Befund übertragen und keine Sammeloperation gefahren (Beschluss Nr. 102). |

---

## Was aus dieser Zeichnung folgt

| Arbeit | Wer | Vermerk |
|---|---|---|
| **BEF-M3-3 ist geschlossen** — nicht getragen, sondern **entschieden** | erledigt | Der Termin-Ausweg in `app/vorpruefung.py` bleibt unverändert. Er wird nicht zum kritischen Restrisiko und braucht keine Annahmeentscheidung |
| **Klarstellender Satz in K04** — damit der Widerspruch nicht bei jedem Lesen neu auftaucht | **Konzept-Fabrik**, nicht dieses Repo | Vorschlag für den Wortlaut: *„‚Ins Gespräch führen' meint die geführten Stufen 01/02 (K05). Ein Termin mit einer Ansprechperson nach K04-M08 ist davon nicht erfasst."* Der Coding-Harness ändert kein Fachkonzept — das geht als offener Punkt hinaus |
| **Die Ansprechperson ist weiterhin nicht erreichbar** | offen, gehört zu K11 | Die Zeichnung ändert daran nichts. Gebaut ist der **Nachweis des Wunsches** (Ereigniszeile `TERMIN_ANGEFRAGT`), nicht die Zustellung. Die Tabelle `contact` trägt im Pilotbestand keine Zeile |

---

*Dieses Blatt hat zwei Lesarten mit ihren Belegen und ihren Folgen nebeneinandergelegt. Der
Harness löst einen Widerspruch zwischen gezeichneten Quellen nie selbst auf — er benennt
ihn und legt ihn vor (`CLAUDE.md` §3). Entschieden hat ein Mensch.*
