# Schlussrunde · Alle offenen Entscheidungen, Schritt für Schritt

**Stand 16.08.2026. Je Punkt eine Handlungsempfehlung. Fünfzehn Tage bis zum Endtermin.**

| | |
|---|---|
| **An** | M. Veil (Auftraggeber) · A. Han (für den Auftragnehmer) · Konzept-Fabrik |
| **Von** | Orchestrator des Coding-Harness |
| **Art** | **Vorlage. Keine Entscheidung.** |
| **Grundlage** | die Liste vom 15.08.2026 (54 Punkte), fortgeschrieben um alles, was seither entschieden oder neu gefunden wurde |

---

## Was seit gestern erledigt ist — damit niemand doppelt entscheidet

| | |
|---|---|
| **M-1 bis M-10** | am 15.08. entschieden und ausgeführt |
| **Drei Vorlagen** | Träger der Zweckbestimmung · Fassung der Anlagefunktion · Steuerungstexte — am 16.08. gezeichnet |
| **H-1 teilweise** | #24 und #25 freigegeben |
| **H-3** | Anlage „Bauverfahren" **von beiden Seiten gezeichnet** — die Betriebsregeln des Harness sind seither getragen |
| **H-5 halb** | Nachweis für Starttor 11 und 13 geführt |
| **Das Etikett** | `scheibenabnahme` angelegt — die Fremdprüfung kann erstmals auslösen |
| **`app/`** | steht jetzt in beiden Grenzen — Erlaubnis für den Bau, Verbot für die blinde Prüfung |

**Offen sind: 3 bei A. Han · 21 bei M. Veil · 3 bei der Konzept-Fabrik.**

---

## ⚠ Was gerade in Arbeit ist — **nicht** zu entscheiden

Drei Aufträge laufen in diesem Augenblick. Sie sind **Ausführung bereits gezeichneter
Entscheidungen**, keine offenen Punkte. Wer sie hier noch einmal entscheidet, entscheidet
doppelt.

| | Was läuft | Aus welcher Zeichnung |
|---|---|---|
| **Prüfung** | Sieben Prüffälle werden auf die neue Fassung der Anlagefunktion nachgezogen — **mit der Klausel als Begründung, nicht dem Bau** | Vorlage 2, gezeichnet 16.08. |
| **Prüfung** | Der Prüffall zur Feldliste wird nachgezogen — jetzt zulässig, weil die Frage entschieden ist | Vorlage 1, gezeichnet 16.08. |
| **Prüfung** | Der **Abgleichprüffall** entsteht: er vergleicht den Zustand mit den Vorgängen | die Auflage aus Vorlage 1 |
| **Bau** | Ereigniszeilen für die zwei Antworten der Zweckbestimmung | Vorlage 1 |

**Was das für die Zahlen unten bedeutet:** Die Punkte **B-4** und **B-5** nennen 0 von 1231
und 386 — diese Zahlen ändern sich durch die laufenden Arbeiten **nicht**. Sie betreffen das
Klauselregister, nicht die Prüffälle.

**Was sich ändern wird:** Der Prüflauf. Heute steht er auf *11 bestanden · 2 fehlgeschlagen ·
3 gesperrt*. Nach den Nachzügen sollten die sieben Fälle und der Feldlisten-Fall grün sein.
**Der Stand wird nach dem Lauf gemessen, nicht angenommen.**

---

# TEIL A · A. Han — drei Punkte

*Diese drei liegen als eigener Antrag vor.*

### A-1 · Antrag #26 freigeben

**Was:** Meilenstein M4 — die Zweckbestimmung und der eine Weg zur Anwendung.

**Warum es sperrt:** Ohne die Freigabe bleibt M4 auf einem Zweig. **M5 kann nicht beginnen**,
und die nachgezogenen Prüffälle kommen nicht in den gültigen Stand.

> **Empfehlung: freigeben.** Die Beschreibung trägt allein; der Antrag nennt ausdrücklich,
> was M4 noch **nicht** erfüllt.

### A-2 · AC-16 fahren

**Was:** Eine echte Zustellung mit abgelesenem Mailkopf.

**Warum es sperrt:** **Der einzige Punkt, an dem M2 hängt** — und M2 gehört zum gezeichneten
Umfang des Liefertors. Gemessen heute: *„Echte Zustellung nicht ausgeführt."* Nur wer den
Schlüsselbund hat und in ein fremdes Postfach sehen kann, schafft das.

> **Empfehlung: heute oder morgen fahren.** Minuten Arbeit, ein Meilenstein. Anleitung:
> `nachweise/vorbedingungen/B2_mailversand/M2_echtlauf_anleitung.md`

### A-3 · B2 und B3 nachfassen

**Was:** Webhosting, MX-Eintrag, zwei Postfächer, Testdomäne — seit dem 02.08. beauftragt.

**Warum es zählt:** **Ohne Postfach ist A-2 nicht fahrbar.** Die beiden hängen zusammen.

> **Empfehlung: mit Frist nachfassen, bei Ausbleiben Anbieterwechsel prüfen.** Dazu die
> offene DKIM-Frage: wann wird `p=none` verschärft? Bei falscher Zuordnung wären alle
> Anmeldecodes auf einmal weg, und für den Anmeldepfad gibt es kein Ersatzverfahren.

---

# TEIL B · M. Veil — einundzwanzig Punkte

## B.1 · Was jetzt sperrt — fünf Punkte

### B-1 · Vier Starttore abnehmen

**Was:** Bedingung 6 des Liefertors trennt zwei Rollen wörtlich: *„Nachweis: A. Han.
**Abnahme: M. Veil**."* Für **05, 11, 13, 15** liegt der Nachweis vor — die Abnahme nicht.
Bei 05 und 15 fehlt sie seit einer Woche.

> **Empfehlung: alle vier in einem Zug abnehmen.** Vier Kreuze, ein Vorgang.
>
> **Vorher zu klären:** Starttor 13 führt der Auftragstext als *„entschieden; Verdrahtung
> offen"*. Ist sie erfolgt? Wenn nein: zurückstellen **oder** als benannten Befund mit Frist
> tragen — aber nicht unbemerkt mitlaufen lassen.

### B-2 · Den Teilschnitt als Abnahmeeinheit benennen

**Was:** Am 15.08. gezeichnet, noch nicht ausgeführt. Der Auslöser der Fremdprüfung heißt
*Scheibenabnahme* — der Gegenstand heißt *Teilschnitt* und ist nach Blatt 57 ausdrücklich
**keine** Scheibe.

**Warum es sperrt:** Das Etikett existiert jetzt, **aber es zeigt auf einen Gegenstand, den
es unter diesem Namen nicht gibt.**

> **Empfehlung: den Namen `teilschnitt-anmeldung` zeichnen.** Ein Satz. Ohne ihn kann die
> Fremdprüfung zwar auslösen, aber nicht für das, was abgenommen werden soll.

### B-3 · Die Fremdprüfung anfordern

**Was:** Träger, Frist und die zeichnenden Personen benennen.

**Warum es sperrt:** Sie ist **nie gelaufen** — ihre Zykluszeit ist unbekannt. Blatt 57 macht
„alle vier Messstufen" zum gezeichneten Bestandteil des Teilschnitts.

> **Empfehlung: sofort anfordern, nach B-2.** Wer sie am 28.08. zum ersten Mal versucht,
> findet zu spät heraus, wie lange sie braucht.

### B-4 · Abnahmekriterien und fachliche Eigentümer

**Was:** Gemessen: **0 von 1231** Klauseln tragen ein Kriterium, **0** einen Eigentümer.
Gate 11 schlägt deshalb an.

**Warum es sperrt:** Bedingung 4 des Liefertors ist ohne sie nicht erfüllbar — auch im
eingeengten Umfang.

> **Empfehlung: auf die 167 Klauseln des Teilschnitts einengen und je Klausel einen
> Eigentümer benennen.** Das ist nicht durch Fleiß zu schließen, sondern nur durch eine
> Entscheidung, **wer liefert und in welcher Tiefe.** Wenn eine der Entscheidungen dieser
> Woche am 31.08. scheitert, dann diese.

### B-5 · Die 386 kritischen Klauseln ohne Prüffall

**Was:** Je Eintrag ein Prüffall **oder** eine gezeichnete Annahmeentscheidung mit Träger.
Die Restrisikoliste führt heute einen Eintrag, und der ist geschlossen.

> **Empfehlung: zusammen mit B-4, auf denselben Ausschnitt eingeengt.**
> **Achtung:** Bei sicherheits-, mandanten-, freigabe-, aufbewahrungs- und
> wiederherstellungskritischen Klauseln lässt K23-M04 die Annahmeentscheidung **nicht**
> genügen — dort ersetzt sie keinen Test.

---

## B.2 · Vor dem 31.08. — neun Punkte

### B-6 · Termine für die zurückgestellten Meilensteine und Bauaufgaben

Das Korrekturblatt sagt: *„Ein Termin wird mit einem eigenen Korrekturblatt gesetzt."*
Dieses Blatt gibt es nicht. Neun Meilensteine sind geschuldet und terminlos.

> **Empfehlung: mit B-7 in ein zweites Korrekturblatt bündeln** — §12.5 Nr. 4 erlaubt,
> mehrere Blätter desselben Tages zu einer Fassung zusammenzufassen.

### B-7 · Die aufgehobene Ausnahme zum Nummernvorrat

Am 10.08. haben beide Parteien eine Ausnahme aufgehoben; der Auftragstext trägt sie
unverändert weiter. Blatt 59 verlangt ausdrücklich: *„nicht stillschweigend gegenstandslos,
sondern benannt aufgehoben."*

> **Empfehlung: mit B-6 bündeln.**

### B-8 · Die Verzugsmeldung gegenzeichnen

Zwei leere Kästchen seit dem 14.08.

> **Empfehlung: erstes Kreuz, „Kenntnis genommen, Weg A gilt".** Die Entscheidungen dieser
> Woche **sind** die Antwort darauf.

### B-9 · Die zwei Nachträge in die Anlage eintragen, mit `SPR-10`

Sprachvorgabe und Fortschrittsverfahren sind gezeichnet, stehen aber noch nicht in der
Anlage. `SPR-10` — die Beiwortpflicht für „Tor" — hat noch keinen Wortlaut in
`CONTRIBUTING.md`.

> **Empfehlung: eintragen und die Anlage neu zeichnen.** Der Wortlaut liegt fertig vor.

### B-10 · Die Anlage Baustrategie hat keine Prüfsumme

Der Auftrag führt sie als *„nicht gebildet — offener Punkt"*. Und sie ist nach ihrer
Zeichnung geändert worden.

> **Empfehlung: Prüfsumme über den heutigen Stand bilden und neu zeichnen.** Ohne alte
> Prüfsumme gibt es bei jeder späteren Änderung kein „neu" — die Kette ist dort dauerhaft
> nicht führbar.

### B-11 · VP-08b

Ein Widerspruch zwischen einer Klausel und dem Datenmodell. Am 15.08. entschieden: **Befund
tragen.** Es fehlen Kennung, Träger und Frist.

> **Empfehlung: eintragen.** Sonst ist „getragen" nur ein Wort.

### B-12 · Geteilter Tresor statt Schlüsselbund

Heute kann **nur eine Person** versenden. Der vorhandene Tresor liegt in der falschen Region
und verstieße gegen F05.

> **Empfehlung: neuer Tresor in der richtigen Region.** Die Empfehlung liegt seit dem 09.08.
> vor. Solange er fehlt, hängt A-2 an einer einzigen Person.

### B-13 · Die 81 Klauseln aus K01

Sie tragen „menschliche Freigabeentscheidung offen" — kein anderes Konzept trägt diesen
Status.

> **Empfehlung: Sammelfreigabe — oder benennen, was entgegensteht.**

### B-14 · Sitzungsdauer und Abmeldung nach Untätigkeit

Zwei Konzepte führen den Punkt offen, ein drittes hat die Werte längst.

> **Empfehlung: ein Federstrich — „Es gelten die Werte aus K03."**

---

## B.3 · Grundsätzliches — sieben Punkte

### B-15 · Was die zu zeichnende Release-Einheit ist

Die Verfassung sagt: *„ausdrücklich offen — dieser Harness entscheidet es nicht."* Damit hat
das Liefertor keinen definierten Gegenstand.

> **Empfehlung: der Teilschnitt selbst ist die Einheit.** Ein Satz. Er passt zu B-2.

### B-16 · Reichweite des Bau-Agenten

Nur Arbeitszweige, oder auch Prüfstrecke und Zielumgebungen? Die fünf Fragen waren *„vor dem
ersten Bauzug zu entscheiden"* — der Bau läuft seit dem 09.08.

> **Empfehlung: den engsten Schnitt zeichnen.** Er gilt ohnehin faktisch.

### B-17 · Verfahren für weitere Umfangskürzungen

Der Fall dieser Woche ist entschieden; die Regel für den nächsten fehlt.

> **Empfehlung: jetzt festlegen, solange der Fall frisch ist.**

### B-18 · Blindheit mechanisch erzwingen

`.claude/settings.json` fehlt. Seit heute stehen die Grenzen wenigstens **geschrieben** in
beiden Agentenbeschreibungen — erzwungen sind sie nicht.

> **Empfehlung: entweder bauen oder ausdrücklich als Restrisiko mit Träger tragen.** Der
> heutige Zwischenzustand ist der schlechteste. Genau diese Lücke hat am 02.08. und am 15.08.
> Prüffälle erzeugt, die nichts gemessen haben.

### B-19 · Priorisierung der 75 offenen Konzeptpunkte

Welche vor dem 31.08., welche danach. Am dichtesten: K15, K01, K00, K14.

> **Empfehlung: eine Stunde Sichtung.** Sie spart Wochen Arbeit an den falschen Punkten.

### B-20 · Die drei Sperren des Anmeldepfads und die verklemmte Löschkette

> **Empfehlung: mit B-19 sichten.**

### B-21 · Die sechs Gestaltungsentscheidungen

Kontrastwerte, Zierlinien, zwei Farbberichtigungen, fünf Verträge. **Fünf Bildschirme sind
gebaut**, ohne dass die Grundlage gezeichnet ist.

> **Empfehlung: zeichnen oder ausdrücklich zurückstellen.**

---

# TEIL C · Konzept-Fabrik — drei Punkte

### C-1 · BEF-E3

Das Bildschirmkonzept ist freigegeben, seine Maschinenquelle trägt „Freigabekandidat". Zwei
Bildschirme stehen in der Quelle, nicht im Konzept — darunter **der, auf dem M4 beruht**.

> **Empfehlung: Anfrage mit Frist 22.08.** Eine freigegebene MUSS-Klausel verweist sonst auf
> eine nicht freigegebene Quelle.

### C-2 · Die Negativfall-Regel ohne Klausel

Sie steht im Bauauftrag und in der README, aber **in keiner Klausel**.

> **Empfehlung: mit C-1 in derselben Anfrage.** Derselbe Fehler ist am 02.08., 14.08. und
> 15.08. aufgetreten — eine Regel ohne Klausel wird von keinem Tor durchgesetzt.

### C-3 · Die zwei K04-Punkte mit der Frist „vor dem Bau"

Die einzigen beiden im ganzen Bestand mit dieser Frist.

> **Empfehlung: klären, wie die Frist es verlangt.**

---

# Die Reihenfolge — Schritt für Schritt

| | Schritt | Wer | Warum hier |
|---|---|---|---|
| **1** | #26 freigeben | A. Han | Alles Weitere baut darauf auf |
| **2** | AC-16 fahren | A. Han | Schließt M2 — der einzige Punkt, an dem es hängt |
| **3** | Vier Starttore abnehmen | M. Veil | Vier Kreuze, ein Vorgang |
| **4** | Teilschnitt benennen, Fremdprüfung anfordern | M. Veil | Ohne den Namen zeigt das Etikett ins Leere |
| **5** | Abnahmekriterien und Eigentümer entscheiden | M. Veil | **Der Punkt, an dem das Liefertor scheitern wird, wenn er offen bleibt** |
| **6** | Zweites Korrekturblatt: Termine und die aufgehobene Ausnahme | beide | Bündeln spart eine Fassung |
| **7** | Die Anlagen nachziehen: Nachträge, `SPR-10`, Prüfsumme der Baustrategie | beide | Hängt zusammen |
| **8** | Die Anfrage an die Konzept-Fabrik | Orchestrator | Frist 22.08. |
| **9** | Die grundsätzlichen sieben sichten | M. Veil | Eine Stunde, spart Wochen |

---

## Zeichnung

*Dieser Block wird von Menschen ausgefüllt. Der Harness trägt hier nichts ein.*

- [ ] **Allen Handlungsempfehlungen wird gefolgt**
- [ ] **Abweichend entschieden bei:** ⟨Kennungen⟩
- [ ] **Zurückgestellt:** ⟨Kennungen⟩ — mit Begründung

| Name | Rolle | Datum | Anmerkung |
|---|---|---|---|
| **M. Veil** | Auftraggeber | | |
| **A. Han** | für den Auftragnehmer (Nr. 158) | | |

---

*Erstellt am 16.08.2026 vom Orchestrator des Coding-Harness. Grundlage ist die systematisch
erhobene Liste vom 15.08.2026, fortgeschrieben um alles, was seither entschieden oder neu
gefunden wurde. **Diese Vorlage entscheidet nichts.***
