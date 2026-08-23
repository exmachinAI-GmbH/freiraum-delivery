# Zeichnungsfertiger Nachtrag zur Anlage „Bauverfahren" — Deutsch und Begriffe

**22.08.2026 · ⟨VORSCHLAG · NICHT GEZEICHNET⟩**

**Wozu dieses Blatt da ist.** Der Auftraggeber hat am 22.08.2026 angewiesen, dass die Regel für
richtiges Deutsch in die `CLAUDE.md` gehört. Sie steht dort seit heute (Abschnitt 5,
„Deutsch, und zwar richtig"). **Damit ist sie ausgeführt, aber nicht gezeichnet.**

Der Kopf der `CLAUDE.md` sagt es selbst: gezeichnet wird die Anlage, ausgeführt wird die Datei,
und Änderungen fließen ausschließlich von der Anlage zur Datei. Solange dieses Blatt nicht
gezeichnet ist, **weichen Anlage und ausführbare Fassung voneinander ab** — derselbe Zustand,
in dem seit heute auch die Rangfolge steht (Auflage **A-3**).

Dieses Blatt enthält den Text, der dafür in die Anlage aufzunehmen ist.

---

## 1 · Der Anlass, gemessen

| | |
|---|---|
| Ersatzgeschriebene Wörter im sichtbaren Text der sieben gebauten Vorlagen | **83** |
| Echte Umlaute in denselben Vorlagen | **0** |
| Deutsch-englische Mischformen auf Bildschirmen | **3** — „Eignungs-Check" (EN-04), „Direkt-Prototyp-Check" (EN-03), „Check" (EN-02) |
| Textsorten, die `CONTRIBUTING.md` §2 erfasst | **8**, plus Quelltext ausdrücklich ausgenommen |
| Davon Bildschirmtext | **keine** — er steht in keiner der beiden Spalten |

Gemessen am 22.08.2026 gegen `app/vorlagen/` auf dem Stand `2b8e6a7`.

**Der Befund ist nicht neu.** Er steht seit dem Bau im Quelltext: `app/gespraech.py`:785–790
vermerkt „UMLAUT ODER UMSCHRIFT — offener Punkt, nicht still entschieden" und legt ihn
ausdrücklich „in die Vorlage". Dieses Blatt ist die Vorlage.

---

## 2 · Was zu tun ist

1. Den Absatz aus Abschnitt 3 in die Anlage „Bauverfahren" aufnehmen
   (`03_AGENT_HARNESS_CODING/30_DELIVERY_HARNESS/Anlage_Bauverfahren.md`).
2. Die Anlage zeichnen und den Zeichnungsnachweis fortschreiben.
3. Die **neue** Prüfsumme der Anlage berechnen: `shasum -a 256 <Anlage>`.
4. Diese Prüfsumme in den Kopf der `CLAUDE.md` eintragen.
5. `./install.sh --pruefsumme` ausführen. Erst wenn er **OK** meldet, redet der ausgeführte
   Text wieder über dieselbe Fassung wie der unterschriebene.

**Achtung, Reihenfolge:** Solange Schritt 3 und 4 nicht beide erledigt sind, weicht die
Prüfsumme ab, und `/scheibe` und `/pruefe` melden „Verfassung nicht belegt". Das ist die
eingebaute Sperre; sie darf nicht umgangen werden.

**Zusammen zeichnen:** `arbeit/Vorlagen/nachtrag_anlage_sprache.md` liegt seit dem 14.08.2026
zeichnungsfertig und ist bis heute nicht vollzogen. Beide Blätter betreffen dieselbe Anlage und
denselben Abschnitt. Sie in einem Zug zu zeichnen, spart einen zweiten Prüfsummenlauf.

---

## 3 · Der aufzunehmende Absatz

> ### Deutsch, und zwar richtig
>
> **Echte Umlaute überall, wo ein Mensch liest.** ä ö ü Ä Ö Ü ß — nie `ae`, `oe`, `ue`, `ss`.
> Das gilt für den Bildschirmtext des Portals, für jede Ausgabe des Harness im Gespräch und auf
> der Konsole, für Fehlermeldungen, Commit-Nachrichten, Anträge, Befunde und Nachweisblätter.
>
> **Ausgenommen ist, was eine Maschine vergleicht:** Datei-, Zweig-, Funktions-, Feld- und
> Prüffallnamen, Werte in Manifesten, Eingaben in Prüfsummen. Ein Umlaut dort bricht die Sperre,
> die er schützen soll. Es ist dieselbe Grenze, die `CONTRIBUTING.md` SPR-10 zieht.
>
> **Keine erfundenen Wörter.** Wo ein gebräuchliches deutsches Wort besteht, wird es benutzt.
> Ein neu geprägter Begriff wird bei seiner ersten Nennung erklärt und in das Glossar
> aufgenommen. Ein Begriff, der nirgends erklärt ist, ist keiner — er verlagert die Entscheidung
> heimlich zurück zu dem, der ihn geprägt hat, und entwertet damit die menschliche Freigabe in
> Messstufe 4. Das ist derselbe Grund, aus dem die Vorgabe zur Verständlichkeit besteht.
>
> **Keine deutsch-englischen Mischformen** in sichtbarem Text. Ersetzt wird an der Quelle — bei
> Bildschirmen im K19-Kasten, nicht in der Vorlage.
>
> **Bestandsschutz.** Gezeichnete Klauselwortlaute, abgelegte Nachweise und Prüffälle, die
> Zeichen für Zeichen vergleichen, bleiben unverändert. Berichtigt wird beim nächsten Anfassen
> einer Datei, nicht durch einen Sammellauf über den Bestand.

---

## 4 · Was dieses Blatt ausdrücklich **nicht** entscheidet

**Den Übersprungvermerk.** Die Klausel **K05-M10** schreibt „(Frage übersprungen)" mit Umlaut,
das gezeichnete Akzeptanzkriterium schreibt „(Frage uebersprungen)", und der Prüffall vergleicht
Zeichen für Zeichen. Nach Rang 1 gewinnt die Klausel — aber wer umstellt, ändert einen Prüffall.
Das ist eine eigene Zeichnung, siehe Abschnitt 6.

**Die Beschriftungen der drei Mischform-Bildschirme.** Sie stehen im K19-Kasten, und der Kasten
liegt in der Konzept-Fabrik. Dorthin schreibt der Harness nie.

---

## 5 · Wie die Regel gemessen werden soll

Eine Regel ohne Messung ist ein Wunsch. Vorgeschlagen wird eine Prüfung in **Tor 1a**:

| | |
|---|---|
| **Was sie misst** | den sichtbaren Text in `app/vorlagen/` und die Ausgaben unter `.claude/` gegen eine gepflegte Liste ersatzgeschriebener Wörter |
| **Warum keine Mustererkennung** | `ae`, `oe`, `ue`, `ss` stehen auch in richtigen Wörtern — „neue", „Steuer", „Adresse", „dass". Ein Muster allein meldet mehr Fehlalarme als Funde |
| **Wie sie wächst** | jeder Fund, der keiner ist, geht als benannte Ausnahme in die Liste, mit Grund. Die Liste ist der Nachweis, nicht das Muster |
| **Bis dahin** | die Regel gilt, wird aber nicht durchgesetzt. Sie gehört auf die Restrisikoliste |

**Nicht gebaut.** Der Bau wartet auf die Zeichnung; ein Werkzeug, das eine ungezeichnete Regel
durchsetzt, wäre genau der Fehler, den dieses Repo vermeidet.

---

## 6 · Zeichnung

| | | |
|---|---|---|
| **1** | Der Absatz aus Abschnitt 3 wird in die Anlage „Bauverfahren" aufgenommen | ☐ so · ☐ geändert: ⟨ ⟩ |
| **2** | Gemeinsam mit `nachtrag_anlage_sprache.md` vom 14.08.2026 | ☐ ja · ☐ getrennt |
| **3** | Die Prüfung aus Abschnitt 5 wird gebaut | ☐ mit dieser Zeichnung · ☐ als eigenes Arbeitspaket · ☐ vorerst nicht |
| **4** | Der Übersprungvermerk (Abschnitt 4) wird | ☐ auf den Klauselwortlaut mit Umlaut umgestellt, Prüffall mit · ☐ bleibt als Umschrift, Klausel wird berichtigt · ☐ später, eigenes Blatt |

| Name | Rolle | Datum |
|---|---|---|
| M. Veil | für den Auftraggeber | ⟨ ⟩ |
| A. Han | für den Auftragnehmer (Nr. 158) | ⟨ ⟩ |

---

*Erstellt am 22.08.2026. Die Zahlen in Abschnitt 1 stammen aus einer Messung gegen die
tatsächlichen Vorlagen, nicht aus einem Eindruck.*
