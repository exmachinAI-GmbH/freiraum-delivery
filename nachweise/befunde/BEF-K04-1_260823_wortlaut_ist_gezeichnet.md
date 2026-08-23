# BEF-K04-1 · Der Wortlaut der fünf Fragen ist seit dem 01.08.2026 gezeichnet

| Feld | Wert |
|---|---|
| Befund | Arbeitspaket **A-3** ist keine offene Zulieferung. Der Wortlaut, den es beschaffen soll, liegt gezeichnet vor. |
| Gemessen am | 23.08.2026 |
| Betrifft | M3 · A-3 · O-M3-2 · `app/vorpruefung.py` · `app/vorlagen/en03_vorpruefung.html` · `migrations/M30__pilot_sammelmigration.sql` |
| Wirkung | M3 wartete auf einen Text, den es seit drei Wochen hat. Der Bau war nicht falsch — die Aktenlage war es. |

## 1 · Was der Bestand behauptete

Vier Stellen sagten übereinstimmend, der Wortlaut fehle, und beriefen sich alle auf denselben Punkt H09/13:

| Fundstelle | Wortlaut |
|---|---|
| `app/vorlagen/en03_vorpruefung.html` | „ihr **WORTLAUT ist nirgends gezeichnet** (H09/Punkt 13, festgehalten in der Sammelmigration M30). Erfundene Fragen fällten eine Entscheidung, die niemand getroffen hat." |
| `migrations/M30__pilot_sammelmigration.sql`, Abschn. 3f | „werden als Seed nachgereicht, **sobald H09/Punkt 13 den Wortlaut zeichnet**." |
| `app/vorpruefung.py`, `vorpruefung_starten` | „Der WORTLAUT dieser fünf Fragen ist in keinem der gezeichneten Konzepte enthalten." |
| `arbeit/Plaene/scheibe2_m3_plan.md`, O-M3-2 | „**EN-03a wird deshalb nicht gebaut.**" |

Der Bau hat sich nicht geirrt, sondern konsequent gehandelt: er hat nicht erfunden, was er nicht belegen konnte. Der Irrtum liegt eine Ebene höher.

## 2 · Was gemessen wurde

`concepts-md/260801_FREIRAUM_K04_Eignungs-und-Schnell-Check_v1.7.md` in der Konzept-Fabrik:

- Kopf: **Status Freigegeben · Vier-Augen M. Veil (Founder) · 01.08.2026**
- Abschnitt 5.0 „Die fünf Fragen des Direkt-Prototyp-Checks" führt die vollständige Tabelle: fünf Fragen, je drei Antwortmöglichkeiten, je Antwort die Zuordnung zu *Dokument* oder *Anwendung*. Darüber: „Angenommen am 01.08.2026 (Founder), schliesst O-K04-1."
- Abschnitt 8 führt **O-K04-1 als geschlossen**.

## 3 · Gegenprobe

K04 Abschn. 5.0 nennt eine prüfbare Zahl: von 243 Kombinationen führen 22 zum Direkt-Prototyp. Nachgerechnet über alle 3⁵ Kombinationen mit der Regel aus K04-M23 und K04-M24:

```
Kombinationen gesamt          : 243   (Soll 243)
davon Vorschlag Direkt-Prototyp: 22   (Soll 22)
BESTANDEN
```

Läuft als Werkzeug mit Scheiterbedingung: `werkzeuge/schnellweg_gegenprobe.py`.

## 4 · Was daraus folgt und am 23.08.2026 getan wurde

| | |
|---|---|
| `seeds/Seed_Direkt_Prototyp_Check_K04.sql` | angelegt · fünf Fragen, fünfzehn Antworten, wörtlich aus K04 Abschn. 5.0 |
| `app/schnellweg_regel.py` · `app/schnellweg.py` | Auswertung und Bildschirmwege gebaut |
| `app/vorlagen/en03a_fragen.html` | EN-03a nach dem Kasten aus N-K19-1 |
| `app/vorpruefung.py` | „Check starten" führt nach EN-03a statt auf die Meldung |
| `migrations/M30` Abschn. 3f | Kommentar **nicht** geändert — eine gelaufene Migration wird nicht rückwirkend beschrieben. Der Vermerk steht hier. |

## 5 · Was dieser Befund NICHT entscheidet

**K04-G11** sagt, K04 sei „nur Freigabekandidat", bis O-K04-2 und O-K04-4 beschlossen sind. Beide sind im selben Dokument als am 01.08.2026 geschlossen geführt. Ob K04-G11 damit erledigt ist oder eigens aufgehoben werden muss, sagt keine Quelle. Ausgewiesen, nicht entschieden — entscheiden müsste K04, hilfsweise K00.
