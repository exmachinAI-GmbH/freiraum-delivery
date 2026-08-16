# Festlegung · Der Teilschnitt heißt `teilschnitt-anmeldung`

**Der Gegenstand, der zum 31.08.2026 abgenommen werden soll, bekommt einen eigenen Namen und
löst damit die Fremdprüfung aus. Bis heute löste sie am Namen *Scheibenabnahme* aus — und der
zeigt auf etwas, das es unter diesem Namen nicht gibt.**

| | |
|---|---|
| **Betrifft** | den Auslöser der dritten Messstufe — der Prüfung durch eine KI eines anderen Anbieters |
| **Datum** | 16.08.2026 |
| **Art** | **Ausfertigung einer gezeichneten Entscheidung.** Dieses Blatt entscheidet nichts |
| **Grundlage** | Zeichnung **B-2** vom 16.08.2026 (`arbeit/Vorlagen/zeichnung_B1-B5_260816.md`, Zeile 29); der Gegenstand selbst ist mit **Blatt 57** am 10.08.2026 von beiden Seiten gezeichnet |
| **Ebene** | **Steuerung, nicht Abnahme** — siehe Abschnitt 5 |

---

## 1 · Das Problem, gemessen

Die dritte Messstufe („Tor 3", der fremde Blick) startet an einem **Etikett** — einer
Markierung, die an einen Änderungsantrag geheftet wird. Das Etikett heißt `scheibenabnahme`.

**Es existiert seit heute.** Nachgemessen:

```
$ gh label list | grep scheibenabnahme
scheibenabnahme   Loest die Fremdpruefung aus (Tor 3, Messstufe 3)
                  -- einmal je Scheibenabnahme, C-4    #0E8A16
```

**Der Ablauf hängt genau daran** (`.github/workflows/tor3.yml`, Zeile 51):

```
contains(github.event.pull_request.labels.*.name, 'scheibenabnahme')
```

**Und hier bricht es.** Der Gegenstand, der am 31.08.2026 abgenommen werden soll, heißt
**Teilschnitt**. Blatt 57 sagt in derselben Zeile, in der es ihn beschreibt, ausdrücklich,
dass er **keine Scheibe** ist:

> „Der Weg **bis zur Anmeldung**: Mandant anlegen · Einladungsschranke · Einladung über den
> echten Mailweg · Anmeldecode · Anmeldung — vollständig belegt, mit allen vier Messstufen.
> **Ausdrücklich keine Scheibe 1, sondern ein benannter Teil davon.**"
>
> — `57_BERICHTIGUNG_ZU_52_UND_53_260810.md`, Zeile 95; gezeichnet von A. Han und M. Veil am
> **10.08.2026** (Weg A, ebd. Zeile 122)

**In einem Satz: Das Etikett funktioniert, aber es zeigt auf einen Gegenstand, den es unter
diesem Namen nicht gibt.**

---

## 2 · Die Festlegung

**Der Teilschnitt wird als eigene Abnahmeeinheit geführt. Ihr Name ist:**

> ### `teilschnitt-anmeldung`

Ein Name in Kleinbuchstaben mit Bindestrich — so, wie Etiketten und Kennungen in diesem
Repository geschrieben werden.

---

## 3 · Was die Einheit umfasst

**Die fünf Schritte aus Blatt 57, im Wortlaut.** Sie sind nicht neu gefasst und nicht
umgestellt; sie stehen genau so in der Zeile, die beide Seiten gezeichnet haben.

| | Schritt | Was dabei geschieht, in Worten |
|---|---|---|
| **1** | **Mandant anlegen** | Ein Kunde bekommt seinen eigenen, abgetrennten Bereich |
| **2** | **Einladungsschranke** | Es wird geprüft, wer überhaupt eingeladen werden darf |
| **3** | **Einladung über den echten Mailweg** | Die Einladung geht als echte E-Mail hinaus, nicht als Attrappe |
| **4** | **Anmeldecode** | Die eingeladene Person erhält einen Code, mit dem sie sich ausweist |
| **5** | **Anmeldung** | Sie meldet sich an — hier endet der Teilschnitt |

**Und die Bedingung, die in derselben Zeile steht:** *„vollständig belegt, mit allen vier
Messstufen."* Alle vier — also auch die dritte, die fremde. Genau deshalb braucht dieser
Gegenstand einen Auslöser.

---

## 4 · Was die Einheit **nicht** ist

| | Was sie nicht ist | Warum das hier steht |
|---|---|---|
| **1** | **Keine Scheibe** | Blatt 57 sagt es wörtlich: *„Ausdrücklich keine Scheibe 1, sondern ein benannter Teil davon."* Eine Scheibe ist ein Ende-zu-Ende-Lauf bis zum Übergabe-Paket; der Teilschnitt endet bei der Anmeldung |
| **2** | **Kein Meilenstein** | Die Meilensteine M1 bis M12 stehen im Bauauftrag. Der Teilschnitt steht dort nicht. Er ist der **Ausschnitt**, auf den Tor II am 31.08.2026 eingeengt wurde — nicht ein zusätzlicher Punkt daneben |
| **3** | **Keine neue Abnahmebedingung** | Siehe Abschnitt 5. Der Auftrag kennt den Namen nicht, und er muss ihn nicht kennen |
| **4** | **Kein Ersatz für die Scheibenabnahme** | Das Etikett `scheibenabnahme` bleibt, wie es ist. Es gilt weiter für Scheiben. Die neue Einheit tritt **daneben**, nicht an seine Stelle |

---

## 5 · Welche Wirkung die Benennung hat

**Sie löst die Fremdprüfung aus — genau so, wie es die Scheibenabnahme täte.** Mehr nicht.

### Warum das keine zusätzliche Abnahmebedingung ist

Der Bauauftrag trennt zwei Ebenen, und die gezeichnete Anlage *Baustrategie* schreibt sie
wörtlich auf (`11_ANLAGE_BAUSTRATEGIE_ENTWURF.md`, Abschnitt 5 *„Zwei Ebenen"*, Zeilen
180–188):

| Ebene | Gehört dazu | Folge einer Verletzung |
|---|---|---|
| **Abnahme** | „ausschließlich der Bauauftrag: M1–M12, L1–L9, drei Tore, Testdurchläufe 6b" | Lieferung nicht abgenommen |
| **Steuerung** | „diese Anlage (nach Zeichnung)" | „Projektbefund — berichtet und begründet, **nie eine Abnahmebedingung**" |

Und der Satz darunter:

> „**Eine Lieferung, die Tor II erfüllt, kann nicht wegen einer Methodenabweichung
> beanstandet werden.**"

**Der Name `teilschnitt-anmeldung` steht auf der Ebene Steuerung.** Er sagt, **wann** die
dritte Messstufe angefordert wird. Er sagt nicht, **was** geliefert sein muss — das steht
unverändert im Bauauftrag. Wer diesen Namen nicht verwendet, hat keine Abnahmebedingung
verletzt; er hat eine Prüfung nicht angestoßen, die ohnehin fällig ist.

### Was die dritte Messstufe verlangt — unverändert

Die Regel dafür ist **C-4** (Blatt 26, Zeile 30, gezeichnet): *„einmal je Scheibenabnahme,
nicht je Änderung."* Und die Begründung in derselben Quelle: *„Ein Gate, das bei jedem
Commit anschlägt, wird umgangen oder billig erfüllt — beides schlechter als kein Gate."*

**Die neue Einheit ändert daran nichts.** Sie löst **einmal** aus, für den Teilschnitt. Sie
macht die Prüfung nicht häufiger, sondern überhaupt erst erreichbar.

---

## 6 · Was zu tun ist, damit der Name wirkt

**Drei Schritte. Zwei davon gehören einem Menschen.**

| | Was | Wer | Gemessen |
|---|---|---|---|
| **1** | **Ein Etikett `teilschnitt-anmeldung` anlegen** — Beschreibung: *„Loest die Fremdpruefung aus (Tor 3, Messstufe 3) fuer den Teilschnitt bis zur Anmeldung (Blatt 57)"* | **A. Han** — dasselbe Recht, mit dem er am 16.08.2026 `scheibenabnahme` angelegt hat | Der Harness legt keine Etiketten an |
| **2** | **Den Ablauf `Tor 3` auf beide Etiketten hören lassen** | **A. Han** | Heute steht in `.github/workflows/tor3.yml`, Zeile 51, nur `scheibenabnahme`. Das ist eine Datei unter `.github/` — außerhalb der Schreibgrenze dieses Auftrags |
| **3** | **Das Nachweisblatt der Fremdprüfung mit dieser Kennung ablegen** | **A. Han** | **Kein Werkzeugumbau nötig** — siehe unten |

### Zu Schritt 3: der Weg ist frei, das ist nachgemessen

Das Prüfwerkzeug `werkzeuge/fremdreview.py` verlangt im Kopf jedes Nachweisblattes ein Feld
`scheibe` (Pflichtfeld, Zeile 56). **Es prüft den Wert nicht.** Nachgemessen:

```
$ python3 werkzeuge/fremdreview.py --stand --scheibe teilschnitt-anmeldung
Tor 3: **fuer keine Scheibe angefordert.** Das Review fordert ein Mensch an;
der Harness schreibt es nie selbst.
```

**Keine Fehlermeldung, keine Ablehnung.** Die Vorlage lässt den Wert ausdrücklich offen —
`nachweise/fremdreview/VORLAGE.md`, Zeile 21: `| scheibe | <z. B. 1 oder 1-anmeldung> |`.

**Das Blatt heißt dann** `nachweise/fremdreview/teilschnitt-anmeldung_260831.md` (Muster
`<scheibe>_<JJMMTT>.md`, ebd. Zeile 3) **und trägt im Kopf** `scheibe: teilschnitt-anmeldung`.

---

## 7 · ⚠ Was in `.claude/commands/scheibe.md` nachzuziehen ist

**Die Datei ist gelesen und nicht geändert.** Sie liegt außerhalb der Schreibgrenze dieses
Auftrags. Was hier steht, ist eine Meldung, keine Änderung.

**Schritt 10** dieser Datei ist der Halt, an dem ein Mensch gefragt wird, ob die Fremdprüfung
jetzt anzufordern ist. Er benennt unter der Überschrift *„Wann gefragt wird — die Regel für
den ganzen Harness"* **genau zwei Auslöser** (Zeilen 116–132):

| | Auslöser | Gilt für |
|---|---|---|
| 1 | **Scheibenabnahme** | alle Scheiben |
| 2 | **Meilensteinabnahme** | nur M10, M11, M12 — sie gehören keiner Scheibe an |

**Der Teilschnitt ist keiner von beiden.** Er ist keine Scheibe (Blatt 57), und Scheibe 1
schließt keinen Meilenstein — die Datei sagt das selbst, Zeile 129: *„Scheibe 1 schließt
keinen Meilenstein (‚keinen — sie ist Integrationsprobe', BS:116)."*

> **Die Folge, klar benannt:** Nach dem heutigen Wortlaut von Schritt 10 hat ausgerechnet der
> Gegenstand, der am 31.08.2026 abgenommen werden soll, **keinen Auslöser für die dritte
> Messstufe.** Die Datei schließt ihn nicht aus — sie kennt ihn nicht.

**Das ist derselbe Fehlertyp, den Schritt 10 selbst beschreibt** (Zeilen 107–110): *„Bis zum
15.08.2026 ist Tor 3 kein einziges Mal mit einem gültigen Nachweisblatt gelaufen — nicht weil
jemand es abgelehnt hätte, sondern weil **nie ein Moment kam, in dem die Frage gestellt
wurde**. Eine passive Sperre erzeugt keinen Anlass; sie erzeugt einen Zustand, den man
übersieht."*

### Vorschlag für den Nachzug — zur Zeichnung, nicht ausgeführt

| | Stelle | Vorschlag |
|---|---|---|
| **1** | Schritt 10, Abschnitt *„Wann gefragt wird"* | Einen **dritten** Auslöser aufnehmen: **die Anmeldung des Teilschnitts** `teilschnitt-anmeldung` — mit derselben Frage und demselben Halt. Begründung im Text: der Teilschnitt ist nach Blatt 57 weder Scheibe noch Meilenstein und fiele sonst durch beide Raster |
| **2** | Schritt 10, nach der Frage *„ja oder nein"* | Den **Bedienpfad in Worten** ergänzen (`SPR-8`): Ein *Ja* wirkt erst, wenn am Änderungsantrag das passende Etikett gesetzt ist — `scheibenabnahme` für eine Scheibe, `teilschnitt-anmeldung` für den Teilschnitt. Heute nennt Schritt 10 kein Etikett; wer *Ja* sagt, erfährt nicht, was er anzuklicken hat |

**Zwei weitere Stellen, beim Lesen aufgefallen — außerhalb dieses Pakets, deshalb nur
benannt:**

- **Schritt 9**, Zeilen 79–80, trägt: *„Glied 2 und 3 tragen bis auf Weiteres gesperrt — der
  Bauauftrag hat keine Prüfsumme (V-13), die Anlage existiert nicht."* **Beide Angaben sind
  überholt.** Der Kopf der `CLAUDE.md` führt heute beide Prüfsummen mit Nachweis und Datum.
- **Eine Zeilennummer zeigt an vier Stellen ins Leere.** Der Satz *„Der Harness schreibt
  dieses Review nie selbst"* steht in `.claude/commands/scheibe.md` heute in den **Zeilen
  86–87**. Verwiesen wird überall auf *„scheibe.md:73"*: in `werkzeuge/fremdreview.py`
  (Zeilen 28, 64, 178, 206, 293), in `nachweise/fremdreview/VORLAGE.md` (Zeile 12) und in
  `.github/workflows/tor3.yml` (Zeile 13). Der Satz selbst gilt unverändert — nur der Zeiger
  darauf ist alt.

---

## 8 · Zeichnung

*Dieser Block wird von Menschen ausgefüllt. Der Harness trägt hier nichts ein.*

**Die Benennung selbst ist gezeichnet** — B-2, am 16.08.2026. Was hier offen ist, sind die
drei Ausführungsschritte aus Abschnitt 6 und der Nachzug aus Abschnitt 7.

- [ ] **Etikett `teilschnitt-anmeldung` angelegt** — A. Han
- [ ] **Ablauf `Tor 3` hört auf beide Etiketten** — A. Han
- [ ] **Schritt 10 in `.claude/commands/scheibe.md` nachgezogen** — Vorschlag 1 und 2 aus Abschnitt 7
- [ ] **Abweichend entschieden bei:** ⟨Kennung⟩ — mit Begründung

| Name | Rolle | Datum | Anmerkung |
|---|---|---|---|
| **M. Veil** | Auftraggeber | | |
| **A. Han** | für den Auftragnehmer (Nr. 158) | | |

---

*Angelegt am 16.08.2026 vom Orchestrator des Coding-Harness, auf Weisung des Auftraggebers
(B-2, gez. M. Veil 16.08.2026). Alle Messungen sind ausgeführt und mit Fundstelle genannt.
`.claude/commands/scheibe.md` und `.github/workflows/tor3.yml` sind gelesen und **nicht
geändert**. **Dieses Blatt ist Steuerung, keine Abnahmebedingung.***
