# BEF-REVIEWMODELL-1 · Die unabhängige Fachprüfung ist belegt, nicht erzwungen

| | |
|---|---|
| **Gegenstand** | Produktseite · `review_run` in `schema/freiraum_datamodel.sql` · die Laufzeitprüfung der sechs Konzepte in Stufe 03 |
| **Art** | Befund — eine Messung des Schemas gegen den Wortlaut der Klausel |
| **Gemessen am** | 24.08.2026, Stand `eb80377` auf `main` |
| **Gemessen woran** | `schema/freiraum_datamodel.sql` (Datenmodell v2.9, Kopf :2), `nachweise/klauselregister/register.json`, `FREIRAUM_Gesamtbuild_v2.9.html` |
| **Ergebnis** | **Die tragende Eigenschaft der Prüfung ruht auf einer Zusicherung, die Nebeneigenschaften sind mechanisch gesichert.** |

---

## 1 · Was die Klausel verlangt

K06 führt im Klauselregister:

> *„Der Prüflauf MUSS ein **anderes Modell** verwenden als der erzeugende Agent.
> `review_run.model_ref_id` verweist mit Löschsperre auf `model_ref` (Eigentümer K17) und
> hält fest, welches."*

Das ist der Kern der Stufe. Der Gesamtbuild v2.9 sagt dem Kunden denselben Satz in seinen
Worten: *„Ein Review-Agent prüft Ihre Bausteine unabhängig (**eigenes Modell**)"*, überschrieben
mit `REVIEW-AGENT · UNABHÄNGIGES MODELL`. Und die Schemaüberschrift selbst lautet
*„UNABHAENGIGE FACHPRUEFUNG"* mit dem Kommentar *„Der Review-Agent bewertet mit einem anderen
Foundation-Modell"* (:495–496).

**Ohne diese Eigenschaft ist die Stufe eine Selbstprüfung** — dasselbe Modell, das die sechs
Konzepte erzeugt hat, bewertet sie. Genau das ist der Fall, gegen den K23-D05 und O-K23-7
gebaut sind.

## 2 · Was gemessen wurde

Alle Zeilen aus `schema/freiraum_datamodel.sql`:

| Zeile | Regel | Zustand |
|---|---|---|
| :515 | `passed` folgt aus Prüfwert und Schwelle | **erzwungen** — `CONSTRAINT pass_matches_threshold CHECK (passed = (score >= threshold))` |
| :501 | höchstens zwei Runden | **erzwungen** — `CHECK (round BETWEEN 1 AND 2)` |
| :503 | Schwelle, Vorgabe 90 | **erzwungen** — `NOT NULL DEFAULT 90 CHECK (threshold BETWEEN 0 AND 100)` |
| :512 | ein Lauf je Stand und Runde | **erzwungen** — `UNIQUE (app_id, artifact_version, round)` |
| :513 | Prüfmaßstab rekonstruierbar | **erzwungen** — Fremdschlüssel auf `knowledge_module_version` |
| **:505** | **anderes Modell als der Erzeuger** | **nur belegt** — `model_ref_id uuid NOT NULL REFERENCES model_ref(id) ON DELETE RESTRICT` |

Zeile :505 stellt sicher, dass **irgendein** Modellverweis eingetragen ist und nicht gelöscht
werden kann. Sie vergleicht ihn **nicht** mit dem Modell des erzeugenden Agenten.

**Auch kein Trigger tut es.** Das Schema führt drei: `platform_admin_guard` (:610),
`sealed_actor_guard` (:633), `invitation_guard` (:653). Sie betreffen Plattform-Admin, Siegel
und Einladungen.

## 3 · Was daraus folgt — und was nicht

**Was folgt.** Ein Prüflauf, der versehentlich dasselbe Modell verwendet wie der erzeugende
Agent, wird **protokolliert, aber nicht verhindert**. Er trägt einen gültigen
`model_ref_id`, besteht jede Prüfung des Schemas und erscheint dem Kunden als *„Fachlich
geprüft und bestanden"*. Nachweisbar ist der Fehler erst hinterher, durch Vergleich zweier
Zeilen — von einem Menschen, der auf die Idee kommt zu vergleichen.

**Der Unterschied zur Nachbarzeile ist der ganze Befund:** `passed` **kann** nicht falsch
gesetzt werden. Das Modell **soll** nur nicht dasselbe sein.

**Was nicht folgt.** Der Befund sagt **nicht**, dass in einem Lauf jemals dasselbe Modell
verwendet wurde. Es hat noch kein produktiver Lauf stattgefunden: `seeds/` enthält keine
`model_ref`-Zeile, und das Modellpfad-Manifest (`model_manifest_version`,
`M30__pilot_sammelmigration.sql`:1194 ff.) ist unbefüllt. Der Befund betrifft die **Bauweise**,
nicht einen eingetretenen Schaden — und er ist deshalb jetzt billig zu beheben.

## 4 · Warum es niemandem auffiel

Die Klausel und das Schema sagen dasselbe, wenn man sie nacheinander liest. Der Satz
*„`review_run.model_ref_id` … hält fest, welches"* beschreibt korrekt, was gebaut ist — er
sagt nur nicht, dass das Festhalten die ganze Durchsetzung ist. Wer von *„MUSS ein anderes
Modell verwenden"* auf einen Constraint schließt, schließt falsch, ohne die Zeile zu lesen.

## 5 · Was dieser Befund nicht tut

- **Er behebt nichts.** Kein Constraint wurde nachgezogen, kein Trigger geschrieben.
- **Er wertet nicht.** Ob die Zusicherung genügt oder ein Constraint folgen muss, ist eine
  Entscheidung des Eigentümers von K06 (Auftragnehmer, A. Han) und der Zeichnung.
- **Er berührt Tor 3 des Harness nicht.** Das ist die Bau-Seite; dieser Befund ist die
  Produkt-Seite. Die beiden sind verschiedene Prüfungen mit verschiedenen Wegen.

---

*Entstanden beim Lesen für `arbeit/Vorlagen/entscheidung_fremdmodell_mcp_260824.md`,
Abschnitt 8.2, nicht durch eine gerichtete Prüfung. Es ist deshalb möglich, dass in derselben
Bauweise weitere Klauseln stehen, die belegen statt zu erzwingen — eine gerichtete Suche
danach hat nicht stattgefunden.*
