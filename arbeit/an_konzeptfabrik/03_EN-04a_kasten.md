# Entwurf · Kasten für EN-04a

**Zum Einfügen in `260801_FREIRAUM_K19_Build-Referenz_v1.3.md`, hinter EN-04 (Z. 251).**

> **Woraus dieser Entwurf stammt:** ausschließlich aus `schema/K19_screens.yaml`, Eintrag
> `EN-04a` — Zugangsmarke, die sechs Aktionen, ihre Leer- und Erfolgszustände. **Nicht aus der
> gebauten Vorlage.** Der Kasten ist die Vorgabe für den Bau; leitete man ihn aus dem Bau ab,
> prüfte der Bau sich selbst, und F41 wäre umgekehrt.
>
> **Was er deshalb nicht liefern kann: die Anordnung.** Die Maschinenquelle führt sie nicht.
> Reihenfolge und Gruppierung unten sind ein Vorschlag aus der Logik der Auswertung
> (K04-M20: Frage 2 hat Vorrang) — sie sind zu zeichnen, nicht zu übernehmen.

---

```
╭─ EN-04a · Zweckbestimmung ──────── [nach Anmeldung] ─╮
│  Zugang: nach Anmeldung  │
│  Voraussetzung: Eignungs-Check mit Ergebnis GEEIGNET │
│  Frage 1  Bewertung von Menschen?      [Anhang III]  │
│  Frage 2  Verbotene Praktik?           [Art. 5]      │
│  [Weiter] ausgeblendet, bis beide beantwortet sind;  │
│  an seiner Stelle steht die fehlende Frage.          │
│  Bei Treffer in Frage 2: Halt-Feld, es entsteht      │
│  nichts. Frage 2 geht Frage 1 vor.                   │
│  Bei Treffer in Frage 1: Warnung mit den Pflichten   │
│  aus Art. 9, 11, 14, 17 und 43, darunter             │
│  [Kenntnis genommen] -- vorher ausgegraut.           │
│  Ohne Treffer: die Anwendung entsteht -> EN-05       │
│  Drei Auswege nach dem Halt:                         │
│  [Antwort aendern] [Termin] [Zur Uebersicht]         │
╰──────────────────────────────────────────────────────╯
```

Beleg: `K19_screens.yaml` v1.2, Eintrag `EN-04a` (Z. 224–279) · K04-M19 (zwei Fragen) ·
K04-M20 (Vorrang von Frage 2) · K04-M21 (Kenntnisnahme als Nachweis) · K04-M08 (drei Auswege) ·
K01-M27 (die Zeile entsteht ausschließlich über `create_app_after_fit`) · K19-M06 (ausblenden
statt ausgrauen, wenn die Bedingung selbst erfüllbar ist).

---

## Nach dem Einfügen

Sagen Sie Bescheid. Ich ziehe die Kopie im Lieferrepo neu und rechne
`schema/K19_build_referenz.sha256` nach — sonst wird Tor 1a rot, weil die Kopie von ihrer
Summe abweicht. Danach fällt `EN-04a` von **GESPERRT** auf **messbar**, und der Riegel prüft,
ob `en04a_zweckbestimmung.html` den Kasten trägt.
