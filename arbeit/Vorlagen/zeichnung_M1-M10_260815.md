# Zeichnung · Die Entscheidungen M-1 bis M-10 vom 15.08.2026

**Diese Datei gehört den zeichnenden Personen. Der Harness schreibt hier nichts von sich aus.**

| | |
|---|---|
| **Betrifft** | `offene_entscheidungen_260815.md`, Teil B.1 — die zehn sofort sperrenden Punkte |
| **Datum** | **15.08.2026** |
| **Form** | getrennte Zeichnungsdatei nach **F40** |

## Vermerk zur Form nach F40

**Die Kreuze sind vom Orchestrator übertragen, nicht selbsttätig gesetzt.** Wortlaut der
Weisung des Auftraggebers vom 15.08.2026:

> „M-1 bis M-10 gem. Entscheidungsvorlage und Handlungsempfehlungen hiermit entschieden.
> Gez. M. Veil, 15.8.26"

**Gez. M. Veil, Auftraggeber, 15.08.2026.**

---

## Die zehn Entscheidungen im Wortlaut

| | Entschieden | Zustand |
|---|---|---|
| **M-1** | **Der Vollzugsauftrag VA-1 ist gezeichnet. A. Han ist als Ausführender benannt, Frist 16.08.2026 abends.** Er trägt die dreizehn Stellen in den Bauauftrag ein und hakt Feld 6 des Korrekturblatts ab | **[x]** · Mitzeichnung A. Hans steht aus |
| **M-2** | **Das Beschlussblatt zur Festlegung auf Rang 0 wird zusammen mit M-1 ausgefertigt.** Der Wortlaut steht in VA-1, Teil 4 — **und erfasst ausdrücklich auch den Nachlauf-Durchstich nach 12.6** | **[x]** · Blatt auszufertigen, beide Founder zeichnen |
| **M-3** | **Für den Durchstich wird kein Werkzeug gebaut.** Der Schritt wird in den Wortlaut von M-2 aufgenommen und als benannter Befund mit **Träger A. Han, Frist vor Pilotstart** geführt | **[x]** |
| **M-4** | **Die Formfragen zur Fassung v1.2** — Dateiname, Zeichnungsdatei, Ablage — werden als Teil von VA-1 mitentschieden. **Erst archivieren, dann einfrieren** | **[x]** |
| **M-5** | **Erst suchen, dann zeichnen.** → **siehe unten: die Suche hat die Vorlage erübrigt** | **[x]** · **erledigt ohne Zeichnung** |
| **M-6** | **Der Text von Beschluss S28 wird beschafft** | **[x]** · **ausgeführt am 15.08.2026** |
| **M-7** | **Der Klauselschnitt für den Teilschnitt wird aus dem gezeichneten Schnitt der Scheibe 1 abgeleitet und auf den Teilschnitt eingeengt** | **[x]** · auszuführen |
| **M-8** | **Die Fremdprüfung (Messstufe 3) wird heute angefordert**, mit Träger, Frist, Auslöser und benannten zeichnenden Personen | **[x]** · auszuführen |
| **M-9** | **Der Ablaufpfad zu MG-08 wird gebaut** — eine abgelaufene Einladung darf nicht auf `VERSANDT` stehen bleiben | **[x]** · auszuführen |
| **M-10** | **Die Migration zu B1-F2 wird gezeichnet** — ein Kunden-Code darf sich nicht an einen Nicht-Kunden hängen lassen | **[x]** · Migration vorzulegen |

---

## Zu M-5 und M-6 · Die Suche hat die Vorlage erübrigt

**Ergebnis in einem Satz: Die Frage nach der Unternehmensgrenze war bereits am 02.08.2026
entschieden und die betroffene Klausel bereits berichtigt. Es ist nichts mehr zu zeichnen.**

### Was gefunden wurde

**Beschluss S28** steht im K00-Beschluss-Log v1.10, Zeile 258, und verweist auf das
Founder-Blatt `arbeit/Founder_Beschluesse/O-PIL-4_Domaenenschranke.md`.

**Die Prüfsumme stimmt.** Selbst nachgerechnet mit `shasum -a 256`:
`9e321461baabc2ab5491907ac5ce3172dfd8c4f436337b8aa9bc84aba7c7100d` — identisch mit dem Wert,
den das Beschluss-Log in Abschnitt 9b für S28 bindet. Das Blatt ist unverändert.

### Was darin entschieden ist

Der Entscheidungsblock trägt das Kreuz und die Zeichnung:

> **„[x] Der Betreiber bestimmt. Niemand außer exmachinAI legt fest, wer FREIRAUM nutzen
> darf."**
>
> *Datum · Zeichnung: 02.08.2026 · GEZEICHNET UND FREIGEGEBEN, gez. M. Veil*

Und zur technischen Seite hält dasselbe Blatt fest, gemessen am Datenmodell:

> „`invitation_guard()` löst die Domäne über `NEW.actor_id → actor.tenant_id →
> tenant.invite_domain` auf. Geprüft wird die Schranke **des Mandanten, zu dem das
> eingeladene Konto gehört**."

Und ausdrücklich zur Einladung über die Grenze hinweg:

> „Eingeladen wird an ganz unterschiedliche, vorher erfragte Adressen … **wir erfragen die
> Adressen beim Kunden, tragen sie ein und senden dorthin.** Das ist **kein Widerspruch zur
> Schranke**."

### Der Folgeauftrag ist ebenfalls schon ausgeführt

S28 verlangte als Folgeauftrag 1, die Klausel K03-M19 klarzustellen. **Das ist geschehen.**
K03 v1.3 trägt heute:

> **K03-M19** *(berichtigt nach Beschluss S28 vom 02.08.2026)* Geprüft wird die
> Einladungsschranke des Mandanten, zu dem das **eingeladene Konto** gehört — nicht die des
> einladenden. **Bei einer Einladung über die Mandantengrenze hinweg gilt damit die Schranke
> des Ziels.**

### Was daraus folgt

**Die Entscheidungsvorlage vom 14.08.2026 (`entscheidung_einladung_mandantengrenze_260814.md`)
ist gegenstandslos.** Sie legte eine Frage zur Zeichnung vor, die seit dem 02.08.2026
gezeichnet und deren Klausel seit demselben Tag berichtigt ist. Die dort als „Lesart A"
bezeichnete Auslegung — Einladung über die Unternehmensgrenze zulässig, die Schranke des
Zielmandanten gilt — **ist die geltende Rechtslage**, nicht eine von zwei Möglichkeiten.

**Empfehlung: die Vorlage mit einem Schließvermerk versehen**, der auf S28 und die berichtigte
Fassung von K03-M19 verweist. Kein neues Kreuz.

**Was offen bleibt, ist kleiner und anderer Art:** Ob der Bau den Zielmandanten bereits als
Pflichtangabe führt, ist eine Umsetzungsfrage und folgt aus der geltenden Klausel — sie ist
keine Entscheidung mehr.

### Ein neuer offener Punkt, den S28 selbst benennt

> „**Grenze des Modells:** `invite_domain` ist **eine** Textspalte, keine Liste. Ein Kunde,
> dessen Leute Adressen bei mehreren Domänen haben (Konzern mit mehreren Marken, externe
> Berater), lässt sich damit nicht abbilden — dann bleibt nur `NULL`, also alles oder nichts.
> Ein Mittelweg ist heute nicht modelliert. → neuer offener Punkt."

**Dieser Punkt ist bis heute nirgends als Kennung geführt.** Er trifft den Pilotbetrieb, nicht
den Teilschnitt, und gehört auf die Liste nach dem 31.08.

---

## Die Lehre dieses Tages

**Die Suche nach S28 hat eine Zeichnung erspart und eine falsche Darstellung verhindert.** Der
Durchlauf hatte die Mandantengrenze als *„sperrt jetzt, ungezeichnet"* gemeldet — mit
zutreffendem Beleg: die Vorlage vom 14.08. trägt tatsächlich kein Kreuz. Erst der Blick in den
Bestand zeigte, dass die Frage anderswo längst beantwortet war.

**Eine offene Vorlage ist nicht dasselbe wie eine offene Frage.**

---

*Angelegt am 15.08.2026 vom Orchestrator des Coding-Harness, auf Weisung des Auftraggebers.
Die Kreuze sind übertragen, nicht selbsttätig gesetzt (F40). Der Harness zeichnet nie.*
