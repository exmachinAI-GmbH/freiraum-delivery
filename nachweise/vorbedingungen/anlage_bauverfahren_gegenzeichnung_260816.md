# Nachweis · Die Anlage „Bauverfahren" ist von beiden Seiten gezeichnet

**Und: das Etikett der Fremdprüfung ist angelegt.**

| | |
|---|---|
| **Datum** | 16.08.2026 |
| **Angelegt von** | Orchestrator des Coding-Harness, auf Weisung |
| **Art** | Nachweis. Keine Entscheidung |

---

## 1 · Die Gegenzeichnung

**Wortlaut der Weisung vom 16.08.2026:**

> „Die Anlage „Bauverfahren" gegenzeichnen - ist hiermit freigegeben und gezeichnet.
> Gez. A. Han, 16.8.26"

**Damit ist die Anlage von beiden Vertragsseiten gezeichnet:** M. Veil am 07.08.2026, A. Han
für den Auftragnehmer (Nr. 158) am 16.08.2026.

### Was das ändert

Die ausführbare Verfassung `CLAUDE.md` sagte über sich selbst:

> *„Solange die Anlage nicht gezeichnet ist, ist diese Datei ein Vorschlag."*

**Alle Betriebsregeln des Harness standen damit auf einer halben Unterschrift** — die
Rollentrennung, die vier Messstufen, die Nachweiskette, die Liste dessen, was nie getan wird.
Sie sind jetzt getragen.

Zwei Stellen der `CLAUDE.md` sind entsprechend berichtigt: die Kopfzeile und der Absatz zur
Vorschlagsfassung.

### Was sich **nicht** ändert

**Die Prüfsumme der Anlage bleibt gültig** — nachgerechnet am 16.08.2026:

```
$ ./install.sh --pruefsumme
OK Pruefsumme der Anlage stimmt mit dem Kopf der CLAUDE.md ueberein.
```

Der Grund ist die Bauform nach **F40**: Der Zeichnungsblock steht in einer **getrennten**
Datei, nicht in der Anlage selbst. Eine Unterschrift ändert die Anlage nicht — sonst änderte
jedes Kreuz ihre Prüfsumme, und die Kette risse bei jedem Zeichnen.

### Ein Vorbehalt, der dazugehört

**Das Zeichnungsblatt der Anlage liegt außerhalb dieses Repositorys**, und es gehört den
Menschen: Nach F40 fasst kein Werkzeug es an, sobald ein Kreuz darin steht. Der Harness hat
es deshalb **nicht** geändert.

Eine Prüfung am 16.08.2026 hatte dort einen inneren Widerspruch gefunden: A. Hans Zeile trug
bereits ein Datum, während der Begleittext derselben Datei noch den Vorbehalt führte
(*„solange A. Han nicht gezeichnet hat…"*). **Mit dieser Weisung ist die Sache entschieden**
— der Begleittext ist beim nächsten Anfassen des Blattes von Hand nachzuziehen.

---

## 2 · Das Etikett der Fremdprüfung

**Wortlaut der Weisung vom 16.08.2026:**

> „Ich lege auch hiermit das Das Etikett scheibenabnahme an, gez. A. Han, 16.8.26"

**Ausgeführt und nachgemessen:**

```
$ gh label list | grep scheibenabnahme
scheibenabnahme   Loest die Fremdpruefung aus (Tor 3, Messstufe 3)
                  -- einmal je Scheibenabnahme, C-4    #0E8A16
```

### Warum das mehr ist als ein Etikett

Die dritte Messstufe — eine KI eines anderen Anbieters urteilt gegen die Roh-Belege — hängt
an genau diesem Etikett. **Es existierte nicht.** Deshalb sind **alle 29 bisherigen Läufe**
der Fremdprüfung übersprungen worden, und zwei Steuerungstexte suchten den Fehler beim
Benutzer: *„Wer es sucht und nicht findet, hat nicht das Etikett gesetzt."* Man konnte es
nicht setzen.

**Die Fremdprüfung kann damit zum ersten Mal überhaupt auslösen.**

### Was noch fehlt, damit sie für den Teilschnitt greift

Der Auslöser heißt **Scheibenabnahme**. Der Gegenstand, der zum 31.08.2026 abgenommen werden
soll, heißt **Teilschnitt** — und ist nach Blatt 57 ausdrücklich **keine** Scheibe.

Am 15.08.2026 ist deshalb gezeichnet worden, den Teilschnitt als **eigene Abnahmeeinheit** zu
benennen. Das ist auszuführen; bis dahin zeigt der Auslöser auf einen Gegenstand, den es
unter diesem Namen nicht gibt.

---

*Angelegt am 16.08.2026 vom Orchestrator des Coding-Harness. Beide Weisungen sind im Wortlaut
wiedergegeben; die Kreuze sind übertragen, nicht selbsttätig gesetzt (F40).*
