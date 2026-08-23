# BEF-K04-2 · Der Träger der fünf Fragen kann die Zuordnung nicht führen

| Feld | Wert |
|---|---|
| Befund 1 | `quick_option` hat keine Spalte für die Zuordnung zu *Dokument* oder *Anwendung*. K04-M22 verlangt sie je Antwort. |
| Befund 2 | Eine der fünfzehn Antworten ist nach der Auswertungsregel wirkungslos. |
| Gemessen am | 23.08.2026 |
| Träger | Founder mit dem Datenmodell — dieselbe Zuständigkeit wie bei O-K04-8 und O-K04-10 |
| Neuer offener Punkt | **O-M3-5** |

## 1 · Der Träger führt zwei Sachspalten, wo drei gebraucht werden

`migrations/M30__pilot_sammelmigration.sql` Abschn. 3f legt `quick_option` an — ausdrücklich „nach dem Muster `fit_question`/`fit_option`". Das Vorbild trägt drei Sachspalten: `label_de`, `value_token`, `is_eligible`. Beim Nachbau ist die dritte entfallen und **nicht ersetzt** worden. `quick_option` führt nur `label_de` und `value_token`.

K04-M22 verlangt „je Antwort eine Zuordnung zu *Dokument* oder *Anwendung*".

| Weg | Folge |
|---|---|
| Zuordnung im Anwendungscode | Genau der Fehler, den O-K04-10 benennt: „nur mit einer Auslieferung änderbar". Der Träger wurde gebaut, um das zu beenden. |
| Zuordnung in `value_token` | Behelf. Eine Spalte trägt zwei Bedeutungen. Änderbar ohne Auslieferung, aber vom Schema nicht prüfbar. |
| Eigene Spalte `zuordnung` | Zielzustand. |

**Der Bau geht den mittleren Weg und weist ihn aus.** Jeder `value_token` endet auf `__dok` oder `__app`; der Seed prüft das selbst und bricht ab, wenn eine Antwort ohne Zuordnung im Bestand steht — gemessen am 23.08.2026:

```
ERROR:  K04-M22 verletzt: Antwort ohne Zuordnung (ohne_endung)
ERROR:  K04-M22 verletzt: nicht genau drei Antworten je Frage (daten=4)
```

**Vorschlag für den Zielzustand** — eine eigene Migration, nicht dieser Seed:

```sql
CREATE TYPE quick_zuordnung AS ENUM ('DOKUMENT','ANWENDUNG');
ALTER TABLE quick_option ADD COLUMN zuordnung quick_zuordnung NOT NULL;
```

Solange die Spalte fehlt, ist K04-M22 **im Schema nicht durchgesetzt** — nur im Seed nachgehalten. Derselbe Fall wie der fehlende Schema-Riegel für die Rubrik-Fassung: eine Pflicht, die so lange gilt, wie sich alle daran halten.

## 2 · Eine Antwort ohne Wirkung

K04 Abschn. 5.0 ordnet **Frage 1, Antwort c** („weiß ich noch nicht") der *Anwendung* zu. Das Ablaufbild in K04 Abschn. 4.1 lässt das Veto der Frage 1 aber nur bei **b** auslösen, und gezählt werden nach K04-M24 nur die Fragen 2 bis 4. Die Antwort wirkt damit nicht.

**Entschieden hat die Kontrollzahl, nicht der Bau:**

| Lesart | ergibt |
|---|---|
| Veto Frage 1 bei **b** | **22** ✓ — die Zahl, die K04 selbst nennt |
| Veto Frage 1 bei **b und c** | 11 ✗ |

Gemessen von `werkzeuge/schnellweg_gegenprobe.py`. Der Bau folgt der Zahl und schreibt das Vetorecht als ausgeschriebene Tabelle `VETO` in `app/schnellweg_regel.py` — nicht als Regel „jede `__app`-Antwort", die die Zahl verfehlen würde.

**Ausgewiesen, nicht entschieden.** Entscheiden müsste K04. Bleibt es beim Rechenstand, ist das fachlich vertretbar — „weiß ich noch nicht" ist keine Aussage über das Ergebnis, und K04-G13 fängt den Zweifel ohnehin ab. Nur steht das nirgends so.
