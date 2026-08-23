# Zeichnungsblatt · N-K19-1 · EN-03a und EN-04a in K19 aufnehmen

| Feld | Wert |
|---|---|
| Vorgelegt am | 23.08.2026 |
| Vorgelegt von | Coding-Harness |
| Zu zeichnen von | A. Han (der Nachtrag nennt ihn als Zeichnenden) · Gegenzeichnung M. Veil |
| Gegenstand | Der Nachtrag `N-K19-1__EN-03a_EN-04a.md` vom **14.08.2026**, unverändert |
| Wirkung | K19 nimmt zwei Kästen, zwei Sitemap-Zeilen und zwei Zuordnungszeilen auf. **M3 und M4 zugleich.** |
| Aufwand | Eine Unterschrift. Der Nachtrag ist seit neun Tagen fertig und liefert jede Einfügestelle nach Dateizeile mit. |

---

## 1 · Warum das jetzt vorliegt

`schema/K19_screens.yaml` führt 33 Bildschirme, der Konzepttext K19 v1.3 führt 31 Kästen. **EN-03a und EN-04a fehlen im Konzept**, nicht in der Maschinenquelle. K19 v1.3 ist vom 01.08.2026, die Zählung vom 05.08.2026 — die Maschinenquelle ist nach der Freigabe gewachsen. Kein Widerspruch in der Sache, ein Zeitunterschied.

**Der Bau hat für EN-04a bereits nach der Maschinenquelle gebaut** (`app/vorlagen/en04a_zweckbestimmung.html`, 16.08.2026, Kopfzeile: „EN-04a aus `schema/K19_screens.yaml`, übernommen und nicht frei gezeichnet"). Nach K19-M01 ist sie die Quelle der Kästen. EN-03a ist am 23.08.2026 nach demselben Maßstab gebaut worden.

Was die Zeichnung ändert, ist deshalb **nicht die Baubarkeit, sondern die Belegbarkeit**: solange K19 die Kästen nicht führt, gelten beide Bildschirme nach K19-G01 als *nicht belegt*, und was nicht belegt ist, ist nicht abnehmbar.

## 2 · Was Sie zeichnen

Den Nachtrag `N-K19-1__EN-03a_EN-04a.md` **im Wortlaut vom 14.08.2026**. Er enthält:

| | |
|---|---|
| Abschn. 2.1 | Kasten **EN-03a · Die fünf Fragen**, 61 Zeichen breit wie EN-03 und EN-04, jede Zeile mit Fundstelle begründet |
| Abschn. 2.2 | Kasten **EN-04a · Zweckbestimmung** |
| Abschn. 3.1 | zwei Sitemap-Zeilen für K19 Abschn. 6, mit Einfügestelle nach Dateizeile |
| Abschn. 3.2 | zwei Zuordnungszeilen für K19 Abschn. 8, mit Einfügestelle |
| Abschn. 4 | **fünfzehn Punkte, die er ausdrücklich nicht entscheidet** (A1–A15, B1–B14) |

## 3 · Was mit der Zeichnung NICHT entschieden ist

Der Nachtrag sagt es selbst: „Kein hier als *nicht belegt* geführter Punkt gilt mit dieser Zeichnung als entschieden." Die für den Bau wichtigsten:

| Punkt | Offen bleibt |
|---|---|
| **A11** | Ob die drei Antwortmöglichkeiten Schaltfläche, Kontrollkästchen oder Auswahlliste sind. Der Bau verwendet ein Wahlfeld je Antwort und eine Schaltfläche je Frage — vorläufig, ohne Anspruch |
| **A4 / O-K19-11** | K04-M02 sagt „höchstens fünf", K04-M22 „genau fünf", das Handbuch „bis zu fünf". Der Bau zeigt fünf fest. **Das ist der einzige Punkt, der den Auswerter betrifft**, wenn er anders entschieden wird |
| **A2** | Die Beschriftung der beiden Weiterwege. Der Bau schreibt „Arbeitsdokument" und „Vorprüfung 2" — die Kennungen aus der Maschinenquelle |
| **A13** | Ob die Zuordnung *→ Dokument / → Anwendung* an den Antworten sichtbar ist. Der Bau zeigt sie **nicht**, weil die Auswertung serverseitig läuft |

## 4 · Neu hinzugekommen seit dem 14.08.2026

| Punkt | |
|---|---|
| **O-M3-5** | `quick_option` hat keine Spalte für die Zuordnung, obwohl K04-M22 sie je Antwort verlangt. Behelf im Bau: Endung `__dok`/`__app` am `value_token`. Zielzustand wäre eine Migration. Siehe `nachweise/befunde/BEF-K04-2_260823_traeger_ohne_zuordnung.md` |
| **K04, Frage 1 c** | „weiß ich noch nicht" ist in K04 Abschn. 5.0 als *→ Anwendung* geführt, wirkt nach K04-M23/M24 aber nicht. Die Kontrollzahl 22 von 243 entscheidet es rechnerisch zugunsten des Ablaufbildes; gezeichnet ist es nicht |

---

## Zeichnung — VOLLZOGEN am 23.08.2026

**Gezeichnet wurde nicht auf diesem Blatt, sondern auf dem Nachtrag selbst.** Das ist der richtige Ort: dieses Blatt war die Vorlage, `N-K19-1__EN-03a_EN-04a.md` ist der Gegenstand.

| Feld | Wert |
|---|---|
| Ort der Zeichnung | Konzept-Fabrik › `ITERATION_2/02_AGENT_HARNESS_KONZEPTE/ITERATION_2/entscheidungsvorlagen/260814_nachtrag_k19_k16/N-K19-1__EN-03a_EN-04a.md` |
| Gezeichnet durch | **A. Han · 23.08.2026** |
| Gegenzeichnung | **M. Veil · 23.08.2026** |
| Zusatz im Dokument | „Hiermit alles gezeichnet: A. Han, M. Veil, 23.8.26" |
| Beleg | Dateistand der Quelle 23.08.2026, 12:26 UTC — gelesen am selben Tag |
| Die Unterschriftszeilen dieses Blattes | bleiben leer. Sie zweimal zu füllen hiesse, zwei Zeichnungen zu führen, wo es eine gibt |

### Was die Zeichnung bewirkt

Der gezeichnete Wortlaut sagt es selbst: **„Auftrag an K19, die beiden Kästen, die Sitemap-Zeilen und die Zuordnungszeilen in eine künftige Fassung aufzunehmen. K19 v1.3 bleibt unverändert."**

Damit ist der Auftrag erteilt, aber **K19 führt die Kästen noch nicht**. Nach K19-G01 gelten EN-03a und EN-04a bis zur Aufnahme in eine Fassung v1.4 weiterhin als *nicht belegt*. Der nächste Schritt liegt bei K19, nicht mehr bei der Unterschrift.

### Was die Zeichnung ausdrücklich NICHT entscheidet

Ebenfalls im gezeichneten Wortlaut: **„Kein hier als *nicht belegt* geführter Punkt gilt mit dieser Zeichnung als entschieden."**

Offen bleiben damit alle Punkte A1 bis A15 und B1 bis B14 des Nachtrags — für den Bau von M3 vor allem:

| Punkt | Bleibt offen |
|---|---|
| **A4 / O-K19-11** | „höchstens fünf" gegen „genau fünf". Der Bau zeigt fünf fest |
| **A5 / O-M3-5** | Der Träger der fünf Fragen und die fehlende Zuordnungsspalte |
| **A11** | Ob die drei Antwortmöglichkeiten Schaltfläche, Kontrollkästchen oder Auswahlliste sind |

Beide Entscheidungsvorlagen liegen daneben: `entscheidung_O-K19-11_260823.md` und `M36_entwurf_zuordnungsspalte_260823.sql`.
