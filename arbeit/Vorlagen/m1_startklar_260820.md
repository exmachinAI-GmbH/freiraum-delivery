# M1 startklar — **ein Befehl, und eine Frage, die vorher zu klären ist**

**20.08.2026 · ⟨VORSCHLAG · NICHT GEZEICHNET⟩** · zu Entscheidung 4 der Standortbestimmung:
*„Zugang zur Pilotumgebung bis 21.08.2026"*

---

## 1 · Der Befehl

```bash
./migrations/n2_lauf.sh "host=<wirt> port=5432 dbname=<datenbank> user=<konto> password=<wort>"
```

Mehr nicht. Das Skript legt die Belege unter `migrations/n2_belege_<datum>` ab und fährt
**fünf Schritte, jeder mit Beleg** (§6a, M1):

| | |
|---|---|
| **1** | Migration einspielen, **danach ein zweites Mal**; nach jedem Lauf zwei Dumps — **Schema und Daten**. Beide Vergleiche müssen leer sein |
| **2** | `M30__pruefung.sql` — vollständige Ausgabe, die Summenzeile muss **null** Fehlschläge melden |
| **3** | jede `Meldung:`-Zeile der Gegentests einzeln in einer Datei |
| **4** | die eingefrorenen Prüffälle **T0–T23** aus `pruefung_v2.9.sql` |
| **5** | Objektzahlen der Zielumgebung messen |

> **Bricht ein Schritt ab, endet der Lauf dort.** Ein Nachweis über vier von fünf Prüfungen
> ist keiner. Und: **das Skript zeichnet nicht.** Der Nachweis am Ende trägt die gemessenen
> Prüfsummen und **leere** Unterschriftsfelder.

**Werkzeuge auf diesem Rechner nachgesehen:** `psql`, `pg_dump`, `shasum` — alle vorhanden.

---

## 2 · Was heute berichtigt wurde — es wäre am Freitag aufgeschlagen

Drei Pfade im Skript zeigten ins Leere. **Alle drei hätten den Lauf abgebrochen, und zwar
genau in dem Augenblick, in dem der Zugang endlich da ist.**

| | stand dort | zeigt jetzt auf |
|---|---|---|
| **Prüffälle** | `migrations/M30__pruefung.sql` — **diese Datei gibt es nicht** | `pruefungen/migration/M30__pruefung.sql`. Sie war als einzige **nicht** übersteuerbar; jetzt ist sie es (`TST_DATEI=`) |
| **Eingefrorene Fälle** | sechs Ebenen nach oben in die Konzept-Fabrik | `schema/pruefung_v2.9.sql` — seit dem 09.08. bringt das Repo alle Bau-Eingaben selbst mit |
| **Grundschema** | ebenso | `schema/freiraum_datamodel.sql` |

Der alte Pfad bleibt in beiden Fällen als zweite Wahl stehen, falls jemand außerhalb des
Repos fährt.

---

## 3 · Die Probe ist gefahren — gegen eine Wegwerfdatenbank

Das Skript sagt selbst, dass eine frische lokale Datenbank für eine Probe genügt. Sie ist
gefahren, **damit am Freitag nichts Neues auftaucht.**

| Schritt | Ergebnis |
|---|---|
| **Grundschema + Migration, zweimal** | **„beide diffs leer — Schema und Daten idempotent."** Der zweite Lauf ändert nichts |
| **Prüffälle M30** | **`SUMME: 108 von 111 bestanden, 3 gescheitert`** → das Skript bricht ab, wie es soll |

**Die drei sind benannt und hängen alle an derselben Sache:**

```
MT-95  · GESCHEITERT — VERSTOSS gegen K01-M38 ("sie wird vergeben, nicht eingegeben"):
         der Befehl nimmt eine Projektnummer entgegen -- Parameter: p_project_no
MT-95b · GESCHEITERT — NICHT GEMESSEN: derselbe Grund
MT-98  · GESCHEITERT — NICHT GEMESSEN: derselbe Grund
```

---

## 4 · **Die Frage, die vor dem Lauf zu klären ist**

**`n2_lauf.sh` spielt genau eine Migration ein: M30.** Zweimal, wie es soll — aber nur M30.

Inzwischen gibt es **drei**:

| | |
|---|---|
| **M30** | die Sammelmigration |
| **M31** | Projektnummer und Zweckbestimmung — **hier verschwindet `p_project_no`** aus `create_app_after_fit` (fünf Parameter → vier) |
| **M32** | Zeilenschutz und Stufenwechsel |

**Deshalb scheitern MT-95, MT-95b und MT-98 in der Probe** — und deshalb **bestehen sie**
gegen `freiraum_ci`, das alle drei Migrationen trägt: dort meldet derselbe Prüflauf
**111 von 111**.

> **Das ist kein Fehler im Skript und kein Fehler im Bau.** Es ist eine offene Frage zum
> Umfang von M1, und sie gehört entschieden, **bevor** der Zugang genutzt wird:

| | Lesart | Folge |
|---|---|---|
| **A** | **M1 meint M30 allein.** So steht es in der Rangfolge: *„`freiraum_datamodel.sql` **plus** Sammelmigration M30"* (Rang 1) | Der Lauf meldet **108 von 111** und bricht ab. Der Nachweis wäre **nicht** zu führen — es sei denn, die drei Fälle werden als benannte Ausnahme getragen. **Und die Zielumgebung trüge danach M31 und M32 nicht**, also nicht das, worauf die Anwendung läuft |
| **B** | **M1 meint den Stand, auf dem die Anwendung läuft** — M30, M31, M32 | Der Lauf ginge durch (`freiraum_ci` zeigt 111/111). **Aber:** das Skript müsste dafür geändert werden, und die Idempotenzprobe müsste über alle drei laufen. Das ist eine Änderung am **Abnahmelauf**, nicht am Bau — sie gehört gezeichnet, nicht nebenbei gemacht |

> **Der Harness hat sie nicht entschieden.** Er hat die Pfade berichtigt, damit das Skript
> überhaupt läuft, und die Probe gefahren, damit die Frage **heute** auf dem Tisch liegt und
> nicht am Freitag.

`☐` **A** — M30 allein; die drei Fälle werden als benannte Ausnahme getragen
`☐` **B** — alle drei Migrationen; das Skript wird entsprechend geändert *(eigene Zeichnung)*
`☐` anders: ⟨ ⟩

---

## 5 · Was noch fehlt

| | |
|---|---|
| **Die Verbindung** | Wirt, Datenbank, Konto, Kennwort der Pilotumgebung — **nicht ins Repo** (K23-D09; ein Fund sperrt den Lauf) |
| **`frxfw`** | vor jedem Zugriff auf die Zielumgebung |
| **Die Entscheidung aus Abschnitt 4** | sonst läuft es entweder ins Abbruch-Ende oder in einen unvollständigen Zielbestand |

---

## Zeichnung

| | | |
|---|---|---|
| **1** | Die drei berichtigten Pfade werden übernommen | ☐ so |
| **2** | Umfang von M1: | ☐ A · **☒ B** · ☐ anders: ⟨ ⟩ |
| **3** | Der Lauf wird gefahren am | ⟨Datum: ⟩ · von ⟨Name: ⟩ |

*Zu Zeile 2 eingetragen auf Weisung des Auftraggebers vom 22.08.2026. Wortlaut der Weisung:*

> „Setze die Kreuze genau hier. Gez. M. Veil, 22.8.26 - dies ist eine Zeichnung, kein Zuruf:
> … `arbeit/Vorlagen/m1_startklar_260820.md`, Abschnitt „Zeichnung", Zeile 2 — Kästchen B,
> mit der Notiz, dass B aus Punkt 10.3 folgt."

**Notiz zu Zeile 2 — die Reihenfolge ist Teil der Entscheidung.**
B folgt aus der Zeichnung zu **Punkt 10.3** in `arbeit/Vorlagen/arbeitspakete_M7-M10_260815.md`
vom selben Tag, nicht umgekehrt. Dort ist der **Maßstab** erweitert worden: Rang 1 ist künftig
das eingefrorene Datenmodell plus M30, M31 und M32. Der Umfang von M1 ist die **Folge** dieser
Erweiterung — M1 misst gegen den geltenden Maßstab, und der ist seit dem 22.08.2026 ein anderer.
Wer die Reihenfolge umdreht, hätte den Umfang eines Meilensteins geändert, ohne den Maßstab
anzufassen; MT-95, MT-95b und MT-98 wären dann weiterhin ohne Grundlage bestanden.

**Nicht mitgezeichnet:** Zeile 1 und Zeile 3 sind offen. Zeile 3 wird erst eingetragen, wenn der
Lauf tatsächlich gefahren ist. Und **B heißt nicht, dass der Zeilenschutz eingeschaltet ist** —
`M32` legt die Vorrichtung an und lässt die Durchsetzung ausdrücklich aus (`M32`:35–39). Der
Nachweis, dass sie hält, gehört zu M11.

| Name | Rolle | Datum |
|---|---|---|
| A. Han | für den Auftragnehmer (Nr. 158) | ⟨ ⟩ |
| M. Veil | für den Auftraggeber | **22.08.2026** *(nur Zeile 2)* |

---

*Erstellt am 20.08.2026. Die Zahlen stammen aus einem tatsächlich gefahrenen Probelauf gegen
eine Wegwerfdatenbank, nicht aus dem Lesen des Skripts — derselbe Unterschied, der am
05.08.2026 einen fehlenden Grundschema-Pfad zutage gefördert hat.*
