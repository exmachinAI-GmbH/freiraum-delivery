# Entwurf · Kasten für EN-03a

**Zum Einfügen in die K19-Build-Referenz, hinter EN-03.**

> **Woraus dieser Entwurf stammt:** ausschliesslich aus `schema/K19_screens.yaml`, Eintrag
> `EN-03a` (Z. 145–170) — Zugangsmarke, die drei Aktionen, ihre Lade-, Leer-, Erfolgs- und
> Fehlerzustände. **Nicht aus einer gebauten Vorlage.** Es gibt auch keine: `en03a` existiert
> im Bau nicht. Der Kasten ist die Vorgabe, nicht ihre Nachschrift (F41).
>
> **Was er nicht liefern kann: die Anordnung.** Die Maschinenquelle führt sie nicht.
> Reihenfolge und Gruppierung unten sind ein Vorschlag — sie sind zu zeichnen, nicht zu
> übernehmen.

---

```
╭─ EN-03a · Ergebnis ──────────────── [Vorprüfung 1 von 2] ─╮
│  Zugang: nach Anmeldung  │
│  Fünf Fragen nacheinander, je genau eine von drei         │
│  Antworten. Wortlaut und Zuordnung aus K04 Abschn. 5.0.   │
│  Der Weiterweg ist ausgeblendet, bis das Ergebnis steht;  │
│  an seiner Stelle steht die offene Frage.                 │
│  Ergebnis: GENAU EIN Begründungssatz, der die             │
│  ausschlaggebende Antwort nennt.                          │
│  [Arbeitsdokument]     [Weiter zum Eignungs-Check]        │
│  Beide Wege sind auch GEGEN den Vorschlag wählbar —       │
│  der Vorschlag entscheidet nichts.                        │
╰───────────────────────────────────────────────────────────╯
```

**Breite gemessen:** Kastenzeilen 61 Zeichen, Zugangsmarkenzeile 28 — wie die vierzehn
bestehenden Kästen.

---

## Eine Entscheidung, die dieser Entwurf nicht still trifft

**Dieser Kasten trägt echte Umlaute. Die vierzehn bestehenden nicht.**

Seit dem 23.08.2026 gilt `CLAUDE.md` Abschnitt 5: echte Umlaute überall, wo ein Mensch liest —
Bildschirmtext eingeschlossen. Für neuen Text gilt sie sofort, der Bestand steht unter
Bestandsschutz. Ein Kasten, der heute entsteht, ist neuer Text.

**Damit wird die Datei gemischt**, bis die anderen berichtigt sind. Drei Wege:

| | | |
|---|---|---|
| **A** | Nur dieser Kasten mit Umlauten, die anderen bleiben | ☐ |
| **B** | Alle Kästen in v1.4 zugleich auf Umlaute umgestellt | ☐ |
| **C** | Auch dieser Kasten in Umschrift, Umstellung später als eigene Zeichnung | ☐ |

**Zu bedenken bei B:** Die Kästen führen die Beschriftungen der Bildschirme. Wer sie umstellt,
verpflichtet die sieben gebauten Vorlagen zum Nachziehen — der Riegel prüft auf **wörtliche**
Übereinstimmung. Das ist Arbeit, aber sie ist absehbar und einmalig.

---

## Belegstellen

`K19_screens.yaml`, Eintrag `EN-03a`:

| Aussage im Kasten | Quelle |
|---|---|
| Fünf Fragen, je genau eine von drei Antworten | `frage_beantworten`, Eingabe (K04-M22) |
| Auswertung serverseitig, der Bildschirm liefert kein Ergebnis mit | Berechtigung (K04-M23, K04-M24) |
| Weiterweg ausgeblendet, bis das Ergebnis steht | `zustand_laden`, `zustand_leer` (K19-M06) |
| Genau ein Begründungssatz, der die ausschlaggebende Antwort nennt | `zustand_erfolg` (K04-M25) |
| Beide Wege auch gegen den Vorschlag wählbar | `arbeitsdokument`, Eingabe (K04-M03) |
| Arbeitsdokument führt nach EN-12 | `zustand_erfolg` (K04-G05) |
| Eignungs-Check ist nicht überspringbar | `vorpruefung_2`, Berechtigung (K04-D01) |

**Nicht im Kasten, weil nicht sichtbar:** der fail-closed-Fall — scheitert die Auswertung,
lautet der Vorschlag *Anwendung*, und der Grund wird genannt (K04-D11). Das ist Verhalten,
keine Anordnung.

**Offen und nicht von hier zu schliessen:** Welche Tabelle Fragen und Antworten trägt, ist
ungezeichnet (**O-K04-10**). Der Kasten kommt ohne diese Entscheidung aus; der Bau nicht.

---

## Nach dem Einfügen

Sagen Sie Bescheid. Ich ziehe die Kopie im Lieferrepo neu und rechne
`schema/K19_build_referenz.sha256` nach — sonst wird Tor 1a rot, weil die Kopie von ihrer
Summe abweicht.

**Gemessen heute:** 33 Bildschirme im Vertrag, **31 mit Kasten**, 7 gebaut, 6 tragen ihren
Kasten, **1 gesperrt**. Die zwei fehlenden Kästen sind EN-03a und EN-04a — beide liegen jetzt
als Entwurf in diesem Ordner.
