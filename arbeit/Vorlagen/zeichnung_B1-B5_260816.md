# Zeichnung · B-1 bis B-5 der Schlussrunde

**Diese Datei gehört den zeichnenden Personen. Der Harness schreibt hier nichts von sich aus.**

| | |
|---|---|
| **Betrifft** | `entscheidungen_schlussrunde_260816.md`, Abschnitt B.1 — die fünf sperrenden Punkte |
| **Datum** | **16.08.2026** |
| **Form** | getrennte Zeichnungsdatei nach **F40** |

## Vermerk zur Form nach F40

**Die Kreuze sind vom Orchestrator übertragen, nicht selbsttätig gesetzt.** Wortlaut der
Weisung des Auftraggebers vom 16.08.2026:

> „B-1 bis B-5 gem. Handlungsempfehlungen freigegeben. Setze alles komplett um, so dass alle
> offenen Themen gem. Deinen Handlungsempfehlungen, die ich voll unterstütze, geschlossen und
> erledigt werden. Gez. M. Veil, 16.8.26"

**Gez. M. Veil, Auftraggeber, 16.08.2026.**

---

## Die fünf Entscheidungen

| | Entschieden | Zustand |
|---|---|---|
| **B-1** | **Die vier Starttore 05, 11, 13 und 15 sind abgenommen.** Nachweis: A. Han. Abnahme: M. Veil | **[x]** · siehe Vorbehalt |
| **B-2** | **Der Teilschnitt wird als eigene Abnahmeeinheit `teilschnitt-anmeldung` benannt** | **[x]** · auszufertigen |
| **B-3** | **Die Fremdprüfung wird angefordert** — mit Träger, Frist und benannten zeichnenden Personen | **[x]** · Anforderung auszufertigen, **anfordern muss ein Mensch** |
| **B-4** | **Die Nachweispflicht wird auf die Klauseln des Teilschnitts eingeengt**, und je Klausel wird ein fachlicher Eigentümer benannt | **[x]** · siehe Grenze |
| **B-5** | **Für die kritischen Klauseln des Teilschnitts** wird je Eintrag ein Prüffall **oder** eine Annahmeentscheidung mit Träger geführt | **[x]** · siehe Grenze |

---

## ⚠ Vorbehalt zu B-1 · Starttor 13

Der Auftragstext führt Starttor 13 als *„entschieden (Nr. 66); **Verdrahtung offen**"*. Die
Empfehlung sagte ausdrücklich: **vorher klären, sonst nimmt man etwas ab, das offen ist.**

**Aus dem Repository heraus ist nicht messbar, ob die Verdrahtung erfolgt ist.** Die Abnahme
ist übertragen; sie trägt diesen Vorbehalt mit. Zwei Wege stehen offen, und beide sind
vertretbar:

- **Die Verdrahtung ist erfolgt** → der Vorbehalt entfällt, ein Satz genügt.
- **Sie ist offen** → die Abnahme gilt unter der Auflage, dass sie als benannter Befund mit
  Träger und Frist geführt wird.

**Der Harness entscheidet das nicht.** Bis zur Klärung wird der Punkt als Befund geführt.

---

## ⚠ Die Grenze bei B-4 und B-5 — was der Harness nicht darf

**Die Weisung lautet „setze alles komplett um". Ein Teil davon darf der Harness nicht.**

`K23-M02` sagt wörtlich:

> „Fehlt das Akzeptanzkriterium, liefert es der **in derselben Zeile eingetragene fachliche
> Eigentümer** nach; bis dahin bleibt der Bauauftrag unvollständig."

**Das Kriterium liefert der Eigentümer, nicht der Harness.** Und die Verfassung führt unter
*„Was du nie tust"*: **„Umfang erfinden."** Ein Abnahmekriterium zu erfinden hieße
festzulegen, wann etwas als geliefert gilt — das ist die Kernfrage der Abnahme.

### Was der Harness deshalb tut

| | Was | Warum es zulässig ist |
|---|---|---|
| **1** | **Die Pflegeliste `pflege.json` anlegen** — sie fehlt seit dem 14.08. und ist *„die eigentliche Sperre"* | Das Werkzeug erwartet sie; ohne sie fällt die Prüfstrecke in einen Rückfallzweig |
| **2** | **Den fachlichen Eigentümer je Klausel eintragen** | Mechanisch ableitbar: jede Klausel gehört einem Konzept, jedes Konzept hat einen Eigentümer. **Abgeleitet, nicht erfunden** |
| **3** | **Die Kritikalität eintragen**, soweit die Triage sie vorschlägt | Sie liegt vor und ist als Vorschlag gekennzeichnet |
| **4** | **Für die Klauseln des Teilschnitts einen Vorschlag für das Abnahmekriterium erzeugen** — **deutlich als Vorschlag gekennzeichnet**, zur Zeichnung durch den Eigentümer | Ein Vorschlag ist keine Festlegung. Er nimmt dem Eigentümer die Schreibarbeit ab, nicht die Entscheidung |
| **5** | **Für die kritischen Klauseln je einen Eintrag in der Restrisikoliste vorbereiten** — mit leerem Träger und leerer Annahmeentscheidung | K23-M04 verlangt die Liste; wer sie trägt, entscheidet ein Mensch |

### Was der Harness **nicht** tut

- **Kein Abnahmekriterium als entschieden eintragen.** Jeder Vorschlag trägt sichtbar, dass
  er ein Vorschlag ist.
- **Keine Annahmeentscheidung zeichnen.** Sie braucht einen Träger, und Träger sind Menschen.
- **Keine Kritikalität festlegen**, wo die Triage keine vorschlägt. „Unbestimmt" heißt
  ausdrücklich **nicht** „nicht kritisch".

**Unverändert gilt K23-M04:** Bei sicherheits-, mandanten-, freigabe-, aufbewahrungs- und
wiederherstellungskritischen Klauseln **sperrt der fehlende Test die Freigabe** — dort
ersetzt keine Annahmeentscheidung den Test.

---

## Was danach noch bei einem Menschen liegt

| | Was | Wer |
|---|---|---|
| 1 | **Die Abnahmekriterien zeichnen** — je Klausel des Teilschnitts, auf Grundlage der Vorschläge | die benannten fachlichen Eigentümer |
| 2 | **Die Annahmeentscheidungen zeichnen** — je kritischer Klausel ohne Prüffall, mit Träger und Frist | M. Veil |
| 3 | **Die Fremdprüfung anfordern und ihr Blatt ablegen** — der Harness schreibt das Review nie selbst | A. Han |
| 4 | **Starttor 13 klären** — Verdrahtung erfolgt oder Befund | M. Veil / A. Han |

---

*Angelegt am 16.08.2026 vom Orchestrator des Coding-Harness, auf Weisung des Auftraggebers.
Die Kreuze sind übertragen, nicht selbsttätig gesetzt (F40). Der Harness zeichnet nie — und
er erfindet keinen Umfang.*
