# M5 · Die Akzeptanzkriterien der Stufen 01 und 02 — **Vorschläge, keine Festlegungen**

| | |
|---|---|
| **Grundlage** | `K23-M02` · **Blatt 100, Entscheidung 5**, gez. M. Veil und A. Han, 19.08.2026: *„Akzeptanzkriterien … **[x] vorher**"* |
| **Erzeugt** | 19.08.2026, in zwei Stufen: **Vorschlag** und **Gegenprobe** |
| **Umfang** | **83** Klauseln ohne Kriterium (von **91** der M5-Klausellage; 8 trugen bereits eines) |
| **Zu zeichnen von** | dem fachlichen Eigentümer je Klausel — im Register weiterhin **leer** (`eigentuemer_zuweisung_260816.md`) |

> **Diese Datei enthält keine Entscheidung.** Jeder Eintrag trägt sichtbar
> `⟨VORSCHLAG · NICHT GEZEICHNET⟩` und endet mit `⟨zeichnet: ⟩ ⟨am: ⟩`. Ein Vorschlag ist keine
> Festlegung — er nimmt dem Eigentümer die Schreibarbeit ab, nicht die Entscheidung.

---

## 1 · Das Ergebnis

```
Klauselregister, Feld "akzeptanzkriterium"

  vorher    157 von 1231
  jetzt     240 von 1231        +83

M5-Klausellage (91 Klauseln)

  56  K05 — der Eigentuemer des Meilensteins
  35  mitwirkend aus K01, K02, K04, K10, K13, K19 (Blatt 100, Entscheidung 3)
  --
  91  davon  8 mit Kriterium aus der Runde vom 16.08.2026 (Teilschnitt Anmeldung)
            83 neu vorgeschlagen
```

**Nicht enthalten sind die zehn Klauseln aus K03 und K17**, die am selben Tag nachgetragen
wurden (`arbeit/Plaene/scheibe4_m5_entscheidung3_nachtrag_k03_k17.md`). Ihre Kriterien laufen
in einer eigenen Runde.

**Erfüllt ist damit nichts.** Ein Vorschlag ist kein gezeichnetes Kriterium, und Blatt 100
verlangt die Zeichnung **vor** dem ersten Bauzug.

---

## 2 · Die Gegenprobe hat **39 von 83** beanstandet — 47 Prozent

Fünf Agenten haben die Vorschläge erzeugt, fünf weitere sie gegen den Klauselwortlaut geprüft,
mit dem ausdrücklichen Auftrag zu **beanstanden**, nicht zu bestätigen.

| Mangel | Zahl | Was er heißt |
|---|---:|---|
| **erfunden** | **14** | Der Vorschlag nennt eine Zahl, Schwelle, Ortsangabe oder Bedingung, **die im Klauselwortlaut nicht steht** |
| **nicht messbar** | **14** | Das Kriterium **täuscht einen Maßstab vor** — zwei Menschen werten es verschieden aus |
| **Negativfall fehlt oder ist fremd** | **11** | Kein eigener Negativfall, oder einer, der an einer anderen Bedingung scheitert |
| | **39** | **47 % der Vorschläge** — die Vergleichsrunde vom 16.08. lag bei 44 % |

**Alle 39 sind durch den Ersatztext der Gegenprobe ersetzt worden.** In diesen Fällen hat die
Gegenprobe das letzte Wort, nicht der erste Vorschlag.

### Die 14 erfundenen — drei im Wortlaut der Gegenprobe

> **`K01-G01`:** *„Der Wortlaut verlangt nur ‚begründet angezeigt', der Vorschlag verlangt
> zusätzlich, die Begründung stehe ‚an der Stelle der gesperrten Aktion'. Diese Platzierung
> steht nicht in K01-G01 — sie ist aus K01-G09 herüberkopiert und damit **ein Maßstab des
> Agenten, nicht des Eigentümers**."*

> **`K05-M13`:** *„Der Wortlaut verbietet nur den ‚Wechsel zwischen getrennten Formularen'. Ein
> zusätzlicher Bestätigungsklick ist kein getrenntes Formular — hier wird eine Schwelle gesetzt,
> die im Wortlaut nicht steht und **die wie eine Festlegung des Eigentümers aussieht**."*

> **`K02-D01`:** *„Der Wortlaut sagt, dass zwei Regeln die Wirkung tragen — nicht, dass jede für
> sich genügt, und er benennt die beiden Regeln auch nicht."*

### Die 14 vorgetäuschten Maßstäbe — und drei ehrliche Aufgaben

**Alle 83 Vorschläge waren als *ableitbar* geführt, keiner als NICHT ABLEITBAR** — in der
Vergleichsrunde vom 16.08. waren es 17 von 142. Die Gegenprobe hat genau danach gesucht und in
**drei** Fällen die Aufgabe für richtig gehalten:

| Klausel | warum kein Kriterium möglich ist |
|---|---|
| **`K05-D03`** | *„Eine Änderung ist sichtbar oder sie findet nicht statt"* — der Wortlaut sagt **nicht, woran Sichtbarkeit beobachtbar ist**, und der Bildschirmvertrag führt für EN-05/EN-06 überhaupt keine Aktion, in der der Assistent einen bestehenden Eintrag ersetzt. Der Negativfall ließe sich nicht herstellen, ohne ihn zu unterstellen |
| **`K05-G12`** | Die Sperre knüpft an *„Freigabekandidat"* und *„Produktivweg"* — beide Wortmarken kommen im Register nicht vor; es führt zu K05 *„v1.3 · Freigegeben"*. Ohne Auslegung nicht messbar (siehe auch die Vorlage `arbeit/an_konzeptfabrik/K05_abschnitt5_nachziehen.md`) |
| **`K05-M20`** | Verlangt die Trennung zweier Bedienungen — die zweite (*Sprechen*) ist nach K05-M30 in Release 1 **ausgeblendet und serverseitig gesperrt**. Ein Negativfall an einer Bedienung, die es nicht gibt, misst nichts |

### Die 11 fehlenden Negativfälle — der immer gleiche Fehler

> **`K05-D05`:** *„Der als ‚Negativfall' geführte Absatz ist wörtlich derselbe Lauf wie im
> Positivfall, nur mit umgekehrter Beobachtung. Er hat keinen eigenen Aufbau und kann deshalb an
> nichts scheitern — **es ist die Negation der Behauptung, kein Prüffall**."*

> **`K19-M14`:** *„Der Negativfall stapelt zwei Bedingungen und scheitert dadurch an der
> falschen … ein Lauf, der an Anmeldung oder Berechtigung scheitert, misst den Satz ‚Ein
> UI-Zustand ersetzt keine serverseitige Autorisierung' nicht."*

Das ist derselbe Fehler, an dem am 02.08.2026 drei von vier mitgelieferten Negativfällen
gescheitert sind (`CLAUDE.md` Abschn. 3).

---

## 3 · Die acht Klauseln mit bestehendem Kriterium — **sechs sind für M5 zu eng**

Geprüft, ob das am 16.08. für den **Anmelde-Teilschnitt** geschriebene Kriterium auch den
M5-Auslöser trägt. **Überschrieben wurde nichts** — ein Vorschlag, der auf eine Zeichnung
wartet, wird nicht im Vorbeigehen ersetzt (das Werkzeug verweigert es).

| Klausel | Urteil |
|---|---|
| `K05-M17` · `K13-M08` | **trägt** — die Prüffälle sind objekt- und pfadneutral und greifen auf dem Wiederaufnahmeweg unverändert |
| `K01-M15` | zu eng — misst die Mandantengrenze **innerhalb einer Sitzung**; M5 hängt am **Wechsel** der Sitzung |
| `K02-M20` | zu eng — benennt keinen Datenpfad; ein Bau kann an der `app`-Zeile bestehen und `document`/`event` ohne Policy lassen |
| `K02-M21` | zu eng — misst an einem unbenannten *Fachobjekt*, nicht am Schreibvorgang des Gesprächsstands |
| `K05-M24` | zu eng — gibt die **ganze** Klausel auf, weil **eine** von fünf Prüfungen (die Rolle) ohne Rollenmatrix keinen Negativfall trägt |
| `K05-M27` | zu eng — gibt die ganze Klausel wegen zweier fehlender Zahlenwerte auf, die nur die **Dateiobjekte** betreffen; der M5-tragende Kern (Mandantenableitung über `document.app_id → app.tenant_id`) bleibt ungemessen |
| `K13-M05` | zu eng — der Eintrag ist eine nummerierte **Umstellung des Wortlauts**, ohne Prüffall |

**Sechs Ergänzungen liegen vor** — Ergänzung, nicht Ersatz — in
`M5_ergaenzungen_bestand_260819.json`. Sie gehören mit dem ursprünglichen Vorschlag zusammen
gezeichnet.

---

## 4 · Ein Verfahrensfehler, gemessen statt geglättet

**Die erste Gegenprobe lief blind.** Der Werkzeuglauf hat beim Wiederaufsetzen seine Parameter
verloren; in den Aufträgen der Prüfagenten stand statt des Verzeichnisses das Wort `undefined`.
Ein Agent hat es selbst gemeldet: *„die Pfadangabe ‚undefined' war im Auftrag nicht aufgelöst —
AUFTRAG.md … liegt nirgends im Dateisystem."* Damit fehlten ihnen die Hausform und die
Mängelliste; sie prüften gegen das, was sie im Repo fanden.

**Die Gegenprobe ist deshalb vollständig wiederholt worden**, mit fest eingetragenen Pfaden.
Der Unterschied ist messbar: **20 der 83 Urteile weichen ab** (erster Lauf: 47 beanstandet,
sauberer Lauf: 39 — beim ersten liefen drei Gruppen doppelt, die Zahl ist deshalb eine
Obergrenze). **Verwendet ist ausschließlich der saubere Lauf.**

*Die Lehre ist nicht neu und steht schon in der Konzept-Fabrik: Selbstberichte eines Agenten
sind kein Nachweis. Aufgefallen ist es nur, weil die Rohausgaben gelesen wurden.*

---

## 5 · Was jetzt gilt und was nicht

| | |
|---|---|
| `pflege.json` | **505 Zeilen**, davon **240** mit Kriteriumsvorschlag (vorher 437 / 157) |
| `register.json` | **unverändert** — die Neuerzeugung braucht den Konzeptordner (`FREIRAUM_KONZEPTE`); auf diesem Rechner ist die Konzept-Fabrik für Werkzeugläufe gesperrt (`.claude/settings.json`, Blatt 97). Der Lauf gehört auf den Rechner, auf dem gebaut wird — oder in die CI, die den Ordner mitbekommt |
| Kritikalität, Eigentümer | **nicht angefasst.** Die Kritikalität begründet der fachliche Eigentümer (K23-G08), einen Eigentümer benennt weiterhin keine Quelle |
| Tests, Teststand, Ergebnis, Evidenz | **leer.** Es ist nichts gelaufen. Ein gefülltes Ergebnisfeld ohne Lauf wäre ein grüner Lauf, der nichts gemessen hat |

---

*Verfahren am 19.08.2026: fünf Vorschlagsagenten (Gruppen zu 18/18/17 K05-Klauseln und 11/19
mitwirkenden), danach fünf Gegenproben und eine Bestandsprüfung, je auf eigenem Lauf und
eigenem Modellaufruf. Grundlage waren ausschließlich die Klauselwortlaute aus dem im Repo
mitgeführten `register.json` und der Bildschirmvertrag `schema/K19_screens.yaml` (Zeile
280–378); die Konzept-Fabrik wurde nicht angefasst. Eingetragen wurde mit
`M5_kriterien_eintragen.py`, das die Hausform prüft und ein vorhandenes Kriterium nicht
überschreibt; der Lauf meldete 83 eingetragen, 0 abgewiesen, 0 schon belegt.*
