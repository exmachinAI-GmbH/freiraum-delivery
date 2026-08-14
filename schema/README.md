# schema/ · Grundwahrheit für Tor 1b

Hier liegen **zwei** Grundwahrheiten, und sie messen Verschiedenes:

| Datei | bestimmt | geprüft in |
|---|---|---|
| `freiraum_datamodel.sql` | was die Datenbank kennt | Tor 1b |
| `K19_screens.yaml` | was ein Bildschirm zeigen und auslösen darf | Tor 1a |

Beide sind Kopien mit derselben Änderungsregel: **keine.**

## `freiraum_datamodel.sql`

`freiraum_datamodel.sql` ist die **eingefrorene v2.9-DDL** — Rang 1 der Rangfolge, sie
gewinnt jeden Konflikt (`CLAUDE.md`).

**Es ist eine Kopie, kein Original.** Das Original liegt in
`ITERATION_2/01_KNOWLEDGE_REPO/v2.9_PIVOT/freiraum_datamodel.sql` und wird **nie geändert**.
Die Kopie liegt hier, weil Tor 1b die Migration gegen eine frische Datenbank fährt und ein
CI-Lauf nicht auf die Dropbox zugreift — ein Lauf gegen eine Quelle, die er nicht selbst
mitbringt, ist nicht reproduzierbar.

| | |
|---|---|
| Herkunft | `01_KNOWLEDGE_REPO/v2.9_PIVOT/freiraum_datamodel.sql` |
| Prüfsumme bei Aufnahme | siehe `schema/freiraum_datamodel.sha256` |
| Änderungsregel | **keine.** Weicht die Prüfsumme vom Original ab, ist die Kopie ungültig — nicht das Original |

## `K19_screens.yaml` · der UI-Vertrag

K19 Abschn. 1 nennt diese Datei die **einzige pflegbare Screenquelle**. K19-M01 verlangt,
dass jedes Konzept mit Bezug zur Oberfläche **Kennung und Version** aus ihr referenziert —
„manuell kopierte Kästen sind unzulässig". Sie führt je Bildschirm die Zugangsmarke, den
Eigentümer und je Aktion die sieben Angaben aus K19-M14: Eingabe, Serverbefehl,
Berechtigungsprüfung, Lade-, Leer-, Erfolgs- und Fehlerzustand.

**Aufgenommen am 14.08.2026.** Bis dahin lag sie ausschließlich in der Konzept-Fabrik.
Die Folge war messbar: `app/vorlagen/` beruft sich in vier Vorlagen auf K19-M01, ohne eine
Fassung zu nennen; kein Prüffall unter `pruefungen/` nannte je eine K16- oder K19-Klausel;
und `doku/Delivery_Verification_Harness_Plan_v1.0.md` führt bis heute *31* Screen-IDs, wo
die Quelle **33** führt. Eine Wahrheit ohne Prüfsumme driftet, und niemand merkt es.

| | |
|---|---|
| Herkunft | `ITERATION_2/03_KONZEPTE_v2.9/schemas/K19_screens.yaml` |
| Fassung bei Aufnahme | `version: "1.2"` · `status: FREIGABEKANDIDAT` |
| Bestand | 33 Bildschirme · 105 Aktionen · 89 verschiedene Serverbefehle · 0 Platzhalter |
| Prüfsumme bei Aufnahme | siehe `schema/K19_screens.sha256` |
| Änderungsregel | **keine.** Sie wird hier nie bearbeitet. Eine Änderung entsteht in der Konzept-Fabrik und kommt als Nachführung mit neuer Prüfsumme |
| Geprüft von | `werkzeuge/k19_screens_lint.py`, in Tor 1a |

**Offener Punkt bei der Aufnahme.** Das Konzept K19 ist **v1.3 · Freigegeben**, diese
Maschinenquelle **v1.2 · FREIGABEKANDIDAT**. Welche der beiden die gezeichnete Fassung
trägt, entscheidet die Konzept-Fabrik, nicht diese Lieferung. Bis das geklärt ist, weist
das Testmanifest den Vorlagenstand mit genau dieser Fassungsangabe aus — gemessen wird der
Stand, der hier liegt, und er wird beim Namen genannt.
