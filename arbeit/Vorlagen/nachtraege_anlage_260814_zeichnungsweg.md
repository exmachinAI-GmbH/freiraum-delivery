# Zwei Nachträge zur Anlage „Bauverfahren" — der Weg zur Zeichnung

**Stand 14.08.2026.** Zwei Nachträge liegen zeichnungsfertig vor. Dieses Blatt sagt, in
welcher Reihenfolge sie in die Anlage kommen und was dabei zu beachten ist. Es ist eine
Anleitung, keine Zeichnung.

| | Blatt | Was es regelt |
|---|---|---|
| **1** | `nachtrag_anlage_sprache.md` | *Verständlichkeit als Lieferbedingung* — jeder neue Text ohne IT-Vorkenntnisse lesbar |
| **2** | `nachtrag_anlage_fortschritt.md` | *Fortschritt wird gemessen, nicht behauptet* — zwei getrennte Angaben je Meilenstein, Tätigkeiten mit Beleg, Verbundprobe, Tagesübergabe |

---

## Warum beide in einem Durchgang

Die Anlage „Bauverfahren" ist der unterschriebene Text. `CLAUDE.md` im Lieferordner ist nur
ihre ausführbare Fassung und trägt im Kopf die **Prüfsumme** der Anlage — eine Kennzahl, die
sich aus dem Dateiinhalt errechnet. Ändert sich die Anlage, ändert sich die Kennzahl.

Solange die Kennzahl in der `CLAUDE.md` nicht nachgezogen ist, meldet der Harness
**„Verfassung nicht belegt"** und arbeitet mit diesem Vermerk weiter. Das ist die eingebaute
Sperre, und sie funktioniert wie vorgesehen.

**Zwei getrennte Durchgänge bedeuten zweimal diesen Zustand.** Ein Durchgang mit beiden
Nachträgen bedeutet ihn einmal. Deshalb: beide zusammen.

---

## Der Weg, Schritt für Schritt

1. **Beide Absätze in die Anlage aufnehmen.**
   Datei: `03_AGENT_HARNESS_CODING/30_DELIVERY_HARNESS/Anlage_Bauverfahren.md`
   Der aufzunehmende Text steht in den beiden Blättern jeweils unter *„Der aufzunehmende
   Absatz"* — als Zitatblock. Die Zitatzeichen `>` am Zeilenanfang gehören **nicht** in die
   Anlage; sie markieren im Vorschlag nur, was zu übernehmen ist.

2. **Zeichnen und den Zeichnungsnachweis fortschreiben.**
   Datei: `Anlage_Bauverfahren_zeichnung.md`, Abschnitt *Menschliche Entscheidung*.
   Siehe den Hinweis unten zu A. Hans Unterschrift.

3. **Die neue Prüfsumme berechnen.**
   ```bash
   shasum -a 256 "<Pfad zur Anlage_Bauverfahren.md>"
   ```
   Heraus kommt eine 64-stellige Zeichenkette.

4. **Die Prüfsumme in den Kopf der `CLAUDE.md` eintragen** — sie ersetzt den heutigen Wert
   `ded747a7a98bcc7fa11442b92e0d09a244c0b4ee2051f10fb251bdb68300274d`. Im selben Zug die
   beiden Absätze in `CLAUDE.md` Abschnitt 5 („Betriebsregeln") übernehmen.

5. **Nachrechnen.**
   ```bash
   cd ~/freiraum-delivery && ./install.sh --pruefsumme
   ```
   **Wenn es gut geht:** `OK Pruefsumme der Anlage stimmt mit dem Kopf der CLAUDE.md überein.`
   **Wenn nicht:** Der Befehl zeigt beide Werte nebeneinander. Dann wurde entweder die
   Anlage nach der Berechnung noch einmal geändert, oder der Wert wurde falsch übertragen.
   **Nicht weiterbauen — nachrechnen.**

6. **Die Änderung an `CLAUDE.md` als Antrag einreichen.** `CLAUDE.md` steht unter CODEOWNERS
   und braucht beide Zustimmungen.

---

## Ein Punkt, der beim Zeichnen auffallen wird

**Die Anlage trägt heute keine eindeutige Unterschrift des Auftragnehmers.** Der
Zeichnungsnachweis führt in der Namenstabelle eine Zeile *„A. Han (für den Auftragnehmer),
08.08.2026"*, deren Text aber sagt: *„Offen ist damit nicht mehr wer, sondern nur noch seine
Unterschrift."* Und weiter unten steht ausdrücklich:

> *„Solange A. Han für den Auftragnehmer nicht gezeichnet hat, bindet diese Anlage den
> Auftraggeber allein."*

**Zum Vergleich:** Beim Bauauftrag v1.1 ist die Lage eindeutig — dort steht ein gesetztes
Kreuz, *„v1.1 gezeichnet"*, 08.08.2026.

**Folge für diese beiden Nachträge:** Werden sie in eine Anlage aufgenommen, die den
Auftragnehmer nicht bindet, binden auch sie ihn nicht. Der Harness würde nach ihnen
arbeiten, vertraglich stünden sie aber auf einem Bein.

**Das ist keine Messung, sondern eine Feststellung zweier widersprüchlicher Zeilen in
derselben Datei.** Sie ist beim Zeichnen mit zu klären — es genügt vermutlich, die eine
Zeile zu berichtigen. Der Harness entscheidet das nicht.

---

## Was sich am Tag der Zeichnung ändert

| | vorher | nachher |
|---|---|---|
| Sprachvorgabe | bindet die Menschen an der Tastatur; Vorlagen wirken | bindet den Harness; `/scheibe` und `/pruefe` arbeiten danach |
| Fortschrittsverfahren | ein Plan und zwei Werkzeuge | Teil der Verfassung; die Tagesübergabe ist Pflichtbestandteil eines Antragstags |
| `install.sh --pruefsumme` | meldet OK gegen den alten Wert | meldet OK gegen den neuen |

**Was sich nicht ändert:** kein Meilenstein, keine Bauaufgabe, kein Tor, kein Termin, kein
Umfang. Beide Nachträge sagen das in ihrem Abschnitt *Rang* ausdrücklich.
