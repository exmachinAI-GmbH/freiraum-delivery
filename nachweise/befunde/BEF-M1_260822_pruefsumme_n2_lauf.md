# BEF-M1 · Die Prüfsumme von `n2_lauf.sh` weicht ab — und wurde beinahe stillgelegt

| | |
|---|---|
| **Gefunden** | 22.08.2026, durch die Gegenprüfung des Fremdmodell-Laufs zur M1-Lieferung |
| **Betrifft** | `migrations/n2_lauf.sh` · `migrations/n2_lauf.sh.sha256` |
| **Art** | Abweichung in der Prüfsummenkette. **Zustand: gesperrt** (K23-M22) |

---

## Der Sachverhalt, nachgerechnet

| | |
|---|---|
| Hinterlegt seit 19.08.2026 (Commit `f149d89`) | `c57f298c…` |
| Ist-Wert der Datei heute | `60f14e4f…` |
| `git show f149d89:migrations/n2_lauf.sh \| sha256sum` | **`c57f298c…`** |

**Die hinterlegte Summe war bei ihrer Hinterlegung richtig.** Abgewichen ist sie erst durch
Commit `15595ad` vom 20.08.2026 („VORBEREITET · Tor-3-Nachtrag und M1 startklar"), der
`n2_lauf.sh` um 22 Zeilen erweiterte — die drei Pfadberichtigungen — und die Summendatei
nicht mitzog. Das ist in einem Befehl feststellbar.

## Was beinahe geschehen wäre

Die M1-Lieferung vom 22.08.2026 hat die Summendatei auf den neuen Ist-Wert **nachgezogen**,
mit der Begründung, die hinterlegte Summe sei falsch gewesen. Beides ist widerlegt.

**Die Wirkung wäre gewesen:** `c57f298c…` käme im Arbeitsbaum an keiner Stelle mehr vor. Der
einzige Beleg für die am 19.08. übertragene Fassung wäre gelöscht, und die Summendatei
belegte nur noch sich selbst.

**Dagegen stehen, im Wortlaut:**

| Quelle | Wortlaut |
|---|---|
| `.github/workflows/tore.yml`:151–152, :166–167 | *„weicht sie ab, ist die KOPIE ungueltig — nicht das Original"* |
| `CLAUDE.md`:125 | eine beschädigte Prüfsummenkette ist eines der fünfzehn sperrenden Tore |
| `migrations/kettenlauf.sh`:454–456 | *„Die Kopie ist ungültig — nicht das Original. … die Prüfsumme wird NICHT nachgezogen."* |

Die letzte Zeile stammt **aus derselben Lieferung**. Sie schreibt die Regel auf und handelt
eine Datei weiter dagegen. Genau das ist die Anreizrichtung, vor der K23-D05 warnt: einen
Prüfwert anzupassen, damit ein Lauf besteht.

## Stand jetzt

`migrations/n2_lauf.sh.sha256` ist auf `c57f298c…` zurückgesetzt. Die Abweichung besteht damit
wieder sichtbar — **das ist der richtige Zustand**, nicht der Mangel.

## Was zu entscheiden ist

Nicht vom Harness. Die Fassung vom 19.08. ist übertragen und mit Summe belegt; die Fassung
vom 20.08. trägt drei Berichtigungen, die im Probelauf gebraucht wurden.

- [ ] **A** — Die Fassung vom 20.08. wird als neue Übertragung gezeichnet, die Summe
      anschliessend neu hinterlegt. Der Vorgang wird beurkundet, nicht stillgelegt
- [ ] **B** — Die drei Pfadberichtigungen werden zurückgenommen; `n2_lauf.sh` kehrt auf die
      gezeichnete Fassung zurück
- [ ] anders: ⟨ ⟩

*Angelegt vom Orchestrator, nachdem eine eigene Gegenprüfung den Fehler in der eigenen
Lieferung nachgewiesen hat. Er ist hier benannt, weil ein stillgelegter Riegel beim nächsten
Nachrechnen als Lücke auftaucht.*
