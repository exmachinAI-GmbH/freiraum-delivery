# Zeichnungsfertiger Nachtrag zur Anlage „Bauverfahren" — Fortschritt und Übergabe

**Wozu dieses Blatt da ist.** Der Harness kann heute nicht sagen, wie weit er ist. Im ganzen
Repository gibt es kein Datenfeld für „Meilenstein" oder „Scheibe"; die Zuordnung Anforderung
→ Scheibe ist an zwei Stellen ausdrücklich als *fehlend* vermerkt. Der Auftraggeber hat am
14.08.2026 ein Verfahren verlangt, das messbar sagt, wie viel bis zum nächsten Meilenstein
fehlt, und das die dafür nötigen Tätigkeiten einzeln benennt.

Damit dieses Verfahren den Harness **bindet** und nicht nur die Menschen an der Tastatur,
muss es in die gezeichnete Anlage. `CLAUDE.md` ist nur deren ausführbare Fassung; Änderungen
fließen ausschließlich von der Anlage zur `CLAUDE.md`, nie umgekehrt.

Dieses Blatt ist ein **Vorschlag zur Zeichnung**, keine Zeichnung.

> **Gemeinsam zeichnen.** Es liegt ein zweiter Nachtrag vor
> (`nachtrag_anlage_sprache.md`). Beide sollten in **einem** Durchgang in die Anlage —
> jede Aufnahme ändert die Prüfsumme, und zwei Durchgänge bedeuten zweimal den Zustand
> „Verfassung nicht belegt". Der Weg steht in `nachtraege_anlage_260814_zeichnungsweg.md`.

---

## Der aufzunehmende Absatz

> ### Fortschritt wird gemessen, nicht behauptet
>
> **Der Harness führt je Meilenstein zwei Angaben — getrennt und nie als eine.**
>
> | Angabe | Woher sie kommt | Was sie ist |
> |---|---|---|
> | **Abnahme** | ausschließlich der Bauauftrag, Nachrechnung des Meilensteins | **eingetreten** oder **nicht eingetreten**. Kein Zwischenwert |
> | **Steuerung** | diese Anlage: erledigte von benannten Tätigkeiten | eine Planungsgröße |
>
> Die Steuerungsangabe erscheint **ausschließlich** in der Tagesübergabe und in der
> Fortschrittssicht unter `nachweise/fortschritt/`. Sie erscheint **nie** in einer Vorlage
> zur Zeichnung, **nie** in einem Testmanifest und **nie** in einem Tor-3-Nachweis. Wer sie
> dorthin trägt, macht aus einer Planungsgröße eine Abnahmeaussage.
>
> **Gemessen wird je Scheibe und je Meilenstein.** Beide Sichten werden geführt, und die
> Scheibe ist die alltägliche: In Scheiben wird gearbeitet, und für die Scheibe — und nur
> für sie — gibt es eine gezeichnete Fertig-Definition. **Scheibe 1 schließt ausdrücklich
> keinen Meilenstein**; eine Messung, die allein Meilensteine kennt, stünde über ihre ganze
> Laufzeit auf *unbestimmt*.
>
> **Was eine Tätigkeit ist.** Jede prüfbare Teilaussage einer Nachrechnung **und jede
> benannte neue Breite einer Scheibe** wird in Tätigkeiten zerlegt. Jede Tätigkeit trägt:
> eine Kennung, eine Art, einen Träger, ihre Abhängigkeiten, die **Art ihres Belegs** und
> eine **Fundstelle im Bauauftrag oder in dieser Anlage** — die Teilaussage der Nachrechnung
> oder die Breitenangabe des Scheibenplans. Die Arten sind: Oberfläche · Bedienung ·
> Durchstich · Modulprüfung · Lastprüfung · Datenmodell · Serverbefehl · Nachweisführung ·
> Bauaufgabe · Voraussetzung · Entscheidung · Wiederherstellung.
>
> **Die Fertig-Definition der Scheibe ist ein Tor, kein Bestandteil.** Solange die
> Integrationsprobe über den vollen Faden nicht bestanden ist, wird für diese Scheibe **kein
> Prozentwert ausgewiesen** — sondern der Vektor je Art und die Zeile, was sperrt. Eine
> Scheibe mit neun von zehn Tätigkeiten und gescheiterter Integrationsprobe ist nicht zu
> neunzig Hundertsteln fertig; sie ist nicht fertig.
>
> **Ohne Fundstelle keine Zählung.** Eine Tätigkeit ohne Fundstelle heißt *Vorschlag* und
> zählt nicht in den Nenner. Sonst erfände der Harness Umfang — untersagt.
>
> **Kein Häkchen.** Eine Tätigkeit trägt kein Zustandsfeld. Gespeichert wird nur die
> **Adresse ihres Belegs**; ihren Zustand liest der Harness aus dem Beleg. Ein selbstgesetztes
> Häkchen ist der Mechanismus, der am 02.08.2026 einen bestandenen Test erzeugt hat, der
> nichts maß.
>
> **Genau vier Zustände**, wie bei jedem Test (K23-M22): bestanden · fehlgeschlagen ·
> gesperrt · nicht ausgeführt. **Nur *bestanden* zählt.** Ein Durchstich, dessen
> Fehlerpfade nicht in den Ergebnissen auftauchen, gilt als *nicht ausgeführt* (K23-M07).
>
> **Die Verbundprobe.** Ein Meilenstein gilt erst dann als eingetreten, wenn zusätzlich zu
> seiner Nachrechnung **ein bestandener Durchstich** vorliegt, der ihn **zusammen mit allen
> früheren Meilensteinen desselben Fadens** misst. Das ist keine neue Bedingung, sondern die
> bereits gezeichnete Definition of Done je Scheibe — *„Integrationsprobe über den vollen
> Faden bestanden, mit der neuen Breite darin"* —, mechanisch angewandt. Ein Meilenstein
> ohne Verbundprobe ist eine Sammlung von Einzelteilen.
>
> **Die Tagesübergabe.** Jeder Tag, an dem ein Antrag gestellt wird, bringt eine erzeugte
> Übergabe unter `handover/` mit — im selben Antrag, ohne eigene Freigabe. Sie führt den
> Stand in beiden Angaben, die offenen Tätigkeiten **der laufenden Scheibe** einzeln, den
> Stand der Meilensteine, die diese Scheibe schließt, und das Gerüst für die Planung der
> nächsten. Ihre Zahlen werden erzeugt, nicht abgetippt.
>
> **Wo das alles lebt.** Unter `nachweise/`, geschrieben vom Orchestrator und vom Menschen —
> **von keinem der beiden Agenten**. Eine Fortschrittstafel im Schreibbereich des Bau-Agenten
> ließe ihn seinen eigenen Maßstab verschieben.
>
> **Rang.** Diese Regelung erweitert den Bauumfang um nichts und schafft **kein zusätzliches
> Abnahmetor**. Kein Tor wird rot wegen einer Fortschrittszahl. Eine fehlende Tätigkeit ist
> ein **Projektbefund**, nie eine Abnahmebedingung — und heißt im Werkzeug ausdrücklich
> *Projektbefund: Tätigkeit offen*, niemals *gesperrt*: dieses Wort ist als Testzustand
> vergeben und darf nicht doppelt belegt werden.
>
> **Keine Quote als Ersatz.** Nach F34 ersetzt eine Abdeckungsquote die Einzelliste nicht.
> Jede Zahl erscheint deshalb nur zusammen mit der namentlichen Restliste, trägt **keinen
> Zielwert**, keine Ampel und keine Schwelle. Es entsteht kein Wert, ab dem etwas grün wird.
>
> **Sprache.** Jede Ausgabe dieses Verfahrens unterliegt der Vorgabe zur Verständlichkeit
> (siehe den Nachtrag *Verständlichkeit als Lieferbedingung*).

---

## Was dieser Nachtrag ausdrücklich nicht tut

- **Er fügt keinen fünften Nachweis hinzu.** Die vier gezeichneten Nachweise —
  Klauselregister, Herkunftsgraph, Restrisikoliste, Testmanifest — bleiben, wie sie sind.
  Die Fortschrittssicht tritt **daneben**, nicht hinein.
- **Er entscheidet die Zuordnung Anforderung → Meilenstein nicht.** Wo sie nicht aus dem
  Bauauftrag ableitbar ist, bleibt sie offen und wird vorgelegt. Der Harness erfindet sie
  nicht.
- **Er legt die Zeichnungseinheit nicht fest.** Was die zu zeichnende Release-Einheit ist,
  ist ausdrücklich offen und bleibt es.
- **Er nennt keine Aufwandsschätzung und kein Gewicht.** Die Verträge führen keine; eine
  erfundene wäre eine Behauptung.
- **Er verschiebt keinen Termin und keinen Umfang.** Das gehört dem Auftraggeber.

---

## Herkunft

| | |
|---|---|
| Weisung | Auftraggeber, 14.08.2026 |
| Wortlaut der Weisung | *„entwickle ein Verfahren für den Coding harness, um messbar die % bis Meilenstein Done zu erreichen bzw eindeutig definieren zu können. Es muss dabei konkret definiert werden, welche Aktivitäten noch durchzuführen sind"* · *„wie wird sichergestellt, das die Meilenstein Ergebnisse nicht isolierte Artefakte sind"* · *„definiere die Struktur des täglichen handovers"* · *„Dies muss alles in den coding harness integraler Bestandteil sein"* |
| Entschieden am 14.08. | beide Lesarten ausweisen — zwölf Meilensteine und Teilschnitt bis zur Anmeldung —, **bis die Berichtigung des Auftrags vollzogen ist** · Tätigkeiten ungewichtet plus zweite Zahl · Übergabe reist im Antrag des Tages mit · Sprache ohne IT-Vorkenntnisse als Abnahmekriterium |
| Zum Umfang | Blatt 57 vom 10.08.2026 hat den Umfang von Tor II auf den Teilschnitt bis zur Anmeldung festgelegt, gezeichnet von beiden Gründern. Der Bauauftrag steht unverändert auf zwölf Meilensteinen; die im selben Kreuz zugesagte Berichtigung ist offen. Solange beides nebeneinander steht, führt das Verfahren **beide** Lesarten und entscheidet nichts |
| Bereits umgesetzt | `werkzeuge/herkunft.py` und `nachweise/herkunft/` (Antrag #17) — der Herkunftsgraph, auf dem die Verbundprobe aufsetzt |
| Kennungsraum | keiner neu vergeben. Die Tätigkeitskennungen (`AK-####`) sind repo-lokal und berühren `K##-`, `F##`, `V-`, `C-`, `O-`, `A-`, `S##`, `BV-` nicht |
| Vom Orchestrator | **übertragen, nicht selbsttätig gesetzt** |
