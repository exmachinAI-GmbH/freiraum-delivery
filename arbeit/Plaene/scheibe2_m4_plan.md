# Plan · Scheibe 2 · Meilenstein M4 — Zweckbestimmung und Anwendungsanlage

**Stand 16.08.2026.** Fortsetzung von `scheibe2_m3_plan.md`, der M3 trägt.

| | |
|---|---|
| **Ziel** | Der Bildschirm **EN-04a** wird bedienbar, und eine Anwendung entsteht ausschließlich über den serverseitigen Befehl |
| **Die neue Breite** | Zweckbestimmung nach der KI-Verordnung: zwei getrennte Fragen, Kenntnisnahme bei der ersten, Halt bei der zweiten |
| **Umfang** | **Alle sechs Aktionen** des Bildschirmvertrags — auf Weisung des Auftraggebers vom 16.08.2026 |

---

## 1 · Was gebaut wird — und was ausdrücklich nicht

### Wird gebaut

- **EN-04a** vollständig: zwei Ja/Nein-Fragen, Auswertung mit Vorrang der zweiten Frage,
  Warnung und Kenntnisnahme bei Treffer in Frage 1, Halt mit drei Auswegen bei Treffer in
  Frage 2, Anlage der Anwendung bei keinem Treffer.
- **Träger** für die Zweckbestimmungs-Erklärung und für die Kenntnisnahme.
- **Die Vergabe der Projektnummer** wandert in den Serverbefehl.

### Wird ausdrücklich nicht gebaut

- **Kein Zustandswechsel.** `change_app_state` und die Wege nach EN-05 gehören zu M5 und
  später. Nach der Anlage endet dieser Weg mit der Weiterleitung.
- **Kein Eingriff in EN-03 oder EN-04.** Die beiden vorbereiteten Fangzweige in
  `app/vorpruefung.py` werden **erreichbar**, aber nicht umgeschrieben.
- **Kein Feld für die Projektnummer.** Nirgends, in keinem Formular. Das ist keine
  Auslassung, sondern eine Verbotsregel (K01-D19).

---

## 2 · Die Wegetabelle

**Das Einzige, was Bau und Prüfung gemeinsam kennen.** Sie sagt, was geschieht — nicht, wie.

| Weg | Ausgangslage | Was der Server tut | Ergebnis für die Nutzerin |
|---|---|---|---|
| **W1** · Bildschirm zeigen | angemeldet, Eignung steht auf GEEIGNET | liest den Stand der Zweckbestimmung | EN-04a mit beiden Fragen; **Weiter ist ausgeblendet**, bis beide beantwortet sind |
| **W2** · Frage beantworten | beide Fragen beantwortet | wertet aus: **erst Frage 2, dann Frage 1** | je nach Treffer W3, W4 oder W5 |
| **W3** · Treffer in Frage 2 | verbotene Praktik bejaht | schreibt die Erklärung, legt **keine** Anwendung an | **Halt** mit dem Grund und dem Verweis auf Artikel 5, dazu **genau drei** Auswege: Antwort ändern · Termin · zur Übersicht |
| **W4** · Treffer in Frage 1 | Bewertung von Menschen bejaht, Frage 2 verneint | schreibt die Erklärung | Warnung zu Anhang III, Hinweis auf die Anbieterpflichten, Aufforderung zur Bestätigung. **Kein Halt** |
| **W5** · Kenntnisnahme | Warnung aus W4 liegt vor | schreibt den Nachweis dauerhaft | Der Weg zur Anlage wird frei |
| **W6** · kein Treffer | beide Fragen verneint | — | Der Weg zur Anlage wird frei |
| **W7** · Anwendung anlegen | W5 oder W6, Eignung liest der Server **unmittelbar vorher erneut** | ruft den Serverbefehl auf; die Projektnummer **vergibt der Befehl** | Anwendung angelegt, Weiterleitung |
| **W8** · Antwort ändern | aus dem Halt heraus | nimmt die frühere Antwort zurück | zurück zu W1 |
| **W9** · Termin | aus dem Halt heraus | vermerkt den Wunsch | Bestätigung |
| **W10** · zur Übersicht | aus dem Halt heraus | — | Übersicht |

### Fehlerpfade, die mindestens einmal abbiegen müssen

| | Was schiefgeht | Was geschehen muss |
|---|---|---|
| **F1** | Anlage versucht, ohne dass die Eignung auf GEEIGNET steht | abgewiesen, keine Zeile |
| **F2** | Anlage versucht bei Treffer in Frage 1 **ohne** Kenntnisnahme | abgewiesen, keine Zeile |
| **F3** | Anlage versucht mit einem Konto eines fremden Mandanten | abgewiesen, keine Zeile |
| **F4** | Der Nachweis der Kenntnisnahme lässt sich nicht schreiben | **kein Weiterweg, keine Anwendung** — fail-closed |
| **F5** | Weiter versucht, bevor beide Fragen beantwortet sind | abgewiesen |
| **F6** | Eine Projektnummer wird im Aufruf mitgesendet | **verworfen**, nicht übernommen |
| **F7** | Die Eignung wechselt zwischen Anzeige und Anlage | die Anlage scheitert; ein veralteter Bildschirmstand berechtigt nicht |

---

## 3 · Die Regeln, gegen die gebaut wird

Je eine Zeile. Der Wortlaut steht im Klauselregister.

| Kennung | Was sie verlangt |
|---|---|
| **K01-M27** | Eine Anwendungszeile entsteht **ausschließlich** über den serverseitigen Befehl. Er prüft in **derselben Transaktion**: Eignung GEEIGNET · aktives Konto · Mandantenzugehörigkeit · `legal_space = DE` · `currency = EUR`. *„Ein nullbarer Fremdschlüssel im Schema ist keine Erlaubnis, den Befehl zu umgehen."* |
| **K01-M38** | Die Projektnummer bildet **der Befehl**, in derselben Transaktion. *„Sie wird vergeben, nicht eingegeben."* |
| **K01-D19** | Kein Bildschirm, kein Formular, kein Endpunkt bietet die Projektnummer zur Eingabe an. *„Ein dennoch mitgesendeter Wert wird verworfen."* |
| **K04-M17** | Anlage und beidseitige Verknüpfung in **einer** Transaktion |
| **K04-M18** | Unmittelbar vor der Anlage wird die Eignung **erneut** gelesen. *„Ein veralteter Bildschirmstand berechtigt nicht zur Anlage."* |
| **K04-M19** | Zwei **getrennte** Fragen: Bewertung von Menschen (Anhang III) · verbotene Praktik (Artikel 5). *„Er ist kein `fit_question`"* — die drei Eignungsdimensionen bleiben unberührt |
| **K04-M20** | Bei Treffer in Frage 1 **drei** Dinge zeigen: Warnung zu Anhang III · Hinweis auf die Anbieterpflichten aus Art. 9, 11, 14, 17 und 43 · Aufforderung zu bestätigen. Bei Treffer in Frage 2 stattdessen der Grund und der Verweis auf Artikel 5 |
| **K04-M21** | Die Kenntnisnahme **bleibt als Nachweis erhalten** und geht ins Übergabe-Paket. *„Ohne sie ist die Auskunftspflicht nach Art. 25 Abs. 4 nicht belegbar."* |
| **K04-D09** | Ein Treffer in Frage 1 wirkt **nicht** als Halt. *„FREIRAUM entscheidet nicht, was der Kunde bauen darf — es sorgt dafür, dass der Kunde weiß, was er tut."* |
| **K04-D10** | Ein Treffer in Frage 2 wird **nicht** weitergeführt. *„Dort heilt keine Aufklärung und keine Bestätigung."* |
| **K04-M08** | Nach einem Halt erscheinen **genau drei** Auswege |
| **K04-D06** | Die Eignungssicht ist **kein** Schreibschutz |
| **K04-D08** | Ein fremder Mandant *„gilt als nicht vorhanden"* |
| **K04-G12** | Solange kein Träger für die Kenntnisnahme besteht, **wird sie als Ereignis geführt**. *„Ein Schritt ohne Nachweis wäre eine Zusage ohne Beleg."* |
| **K19-M14** | Jede Aktion nennt Eingabe, Serverbefehl, Berechtigungsprüfung und alle Zustände. *„Ein UI-Zustand ersetzt keine serverseitige Autorisierung."* |
| **K10-M34** | Das Übergabe-Paket führt die Kenntnisnahme; Rechtsgrund ist Art. 25 Abs. 4 |

---

## 4 · Was der Bau nicht anfassen darf

- **Keine Datei unter `pruefungen/`.** Auch nicht „nur den Tippfehler".
- **Das eingefrorene Datenmodell** wird nie geändert — Änderungen entstehen als Migration.
- **Die bestehende Sammelmigration M30** wird nicht umgeschrieben; die Änderung ist eine neue.
- **Keine Klausel, kein Prüfwert, keine Kritikalität.**

---

## 5 · Was die Prüfung nicht sehen darf

Der Prüf-Agent bekommt **diesen Plan ohne Abschnitt 6** und die Regeln aus Abschnitt 3.
Kein Code, kein Dateiname, kein Ausschnitt, keine Fehlermeldung aus dem Bau.

**Der Grund ist gemessen, nicht vermutet:** Am 02.08.2026 scheiterten drei von vier
Negativfällen an einer **anderen** Bedingung als der geprüften. Am 15.08.2026 ist derselbe
Fehler noch einmal aufgetreten. Beide Male, weil der Prüffall den Code kannte.

---

## 6 · Berührte Dateien — **nicht für die Prüfung**

- `migrations/M31__projektnummer_und_zweckbestimmung.sql` (neu)
- `app/zweckbestimmung.py` (neu) · `app/vorlagen/en04a_zweckbestimmung.html` (neu)
- `app/haupt.py` (Router einbinden)

---

## 7 · Offene Punkte dieser Scheibe

| | Was | Entscheider |
|---|---|---|
| **O-M4-1** | **Der Anzeigewortlaut der zwei Fragen ist nicht gezeichnet.** K04-M19 nennt den Gegenstand, nicht den Text. Der Bau setzt einen Wortlaut, der sich eng an K04-M19 hält, und legt ihn zur Zeichnung vor — er ist **abgeleitet, nicht belegt** | K04 · Founder |
| **O-M4-2** | **Träger der Zweckbestimmungs-Erklärung.** Von keinem offenen Punkt erfasst (N-K19-1 B12). Der Bau wählt den kleinsten Träger und legt ihn vor | Founder · Datenmodell |
| **O-M4-3** | **Die Kenntnisnahme bei Rücknahme einer Antwort.** Bleibt sie stehen oder verfällt sie? Der Bau lässt sie stehen — ein Nachweis, den man zurücknehmen kann, ist keiner — und legt es vor | Founder |
| **O-M4-4** | **M31 ändert den Maßstab.** Rang 1 ist das eingefrorene Datenmodell **plus** die Sammelmigration in der gezeichneten Fassung | M. Veil |
| **O-M4-5** | **EN-04a ist in K19 v1.3 nicht enthalten.** Gebaut wird gegen die Maschinenquelle (v1.2, Freigabekandidat) und den Nachtrag N-K19-1, den nur A. Han gezeichnet hat — mit 14 als offen mitgezeichneten Punkten. Nach K19-G01 gilt der Bildschirm damit als **nicht belegt** | Konzept-Fabrik |

**Alle fünf gehen in die Vorlage, keiner wird still entschieden.**
