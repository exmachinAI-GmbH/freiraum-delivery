# Vorlage zur Zeichnung · Die zwölf Gründe aus Tor 3 — Träger, Frist, Reihenfolge

**23.08.2026 · ⟨VORSCHLAG · NICHT GEZEICHNET⟩ · An: M. Veil · A. Han**
**Anlass: `nachweise/fremdreview/teilschnitt-anmeldung_260820.md`, Urteil `trägt nicht`**

---

## Warum dieses Blatt

Das Fremdreview vom 20.08.2026 nennt zwölf Gründe. Alle zwölf haben **leere Spalten für
Träger und Frist**. Das Blatt sagt selbst: *„Keine Auflagen — das Urteil lautet ‚trägt
nicht'. Was daraus folgt, entscheidet Tor 4, nicht dieses Blatt."*

Solange die zwölf Zeilen leer bleiben, ist das Urteil abgelegt, aber nicht bearbeitet — und
ein zweiter fremder Blick auf denselben Stand fände dieselben zwölf. **Dieses Blatt macht sie
entscheidbar. Es entscheidet nichts.**

## Was seit dem 20.08.2026 gemessen wurde

Fünf der zwölf ließen sich am Programmtext nachprüfen. **Alle fünf gelten unverändert:**

| Nr. | Nachgemessen am 23.08.2026 |
|---|---|
| 2 | `mfa_method` kommt in `app/anmeldung.py` und `app/sitzung.py` **nicht vor** — kein Treffer |
| 5 | `mail_delivery` speichert `recipient` im Klartext (`mail/versand.py`, `nachweis()`) |
| 7 | `app/einladung_senden.py:291` sagt es selbst: *„`retention_class` wird NICHT gesetzt"* |
| 8 | `mandantenvorgang()` hat **keinen Aufrufer** in `app/` oder `mail/`. `app/datenbank.py:154` sagt selbst: *„sie ist ein Angebot, keine Durchsetzung"* |
| 11 | Der Zweig in `pruefungen/lauf.sh` besteht; die Zeilennummern haben sich seit dem 20.08. verschoben — **neu zu bewerten**, nicht als erledigt zu führen |

*Die übrigen sieben sind nur durch Lesen zu bestätigen. Sie wurden nicht widerlegt und gelten
damit fort (K23-M22).*

---

## Die zwölf Gründe, geordnet und eingeordnet

**Spalte „M2":** berührt der Grund eine der **vier** Teilaussagen der Nachrechnung aus §6a —
echte Zustellung · `event` trägt die Anmeldung · Code verfällt nach 10 Minuten · Sperre nach
fünf Fehlversuchen? Das entscheidet, ob er der Abnahme von M2 im Wege steht.

### Zuerst: zwei Messfehler — sie betreffen alles andere

| Nr. | Grund | Art | M2 | Vorschlag Träger | Vorschlag Frist |
|---|---|---|---|---|---|
| **12** | **VP-18 misst zugunsten des Standes:** wertet K04-M08 als erfüllt, wenn ein `TERMIN_ANGEFRAGT`-Ereignis entsteht — beweist „Ereignis vermerkt", nicht „Gespräch vereinbart" | **Messfehler** | nein — **M3** | Prüf-Agent | **zuerst** |
| **11** | Zu Frage 22 fehlen die tatsächlichen Fehlermeldungen — der Erfolgszweig gibt nur „scheitert an $erwartet" aus | **Messfehler** | nein | Bau | **zuerst** |

> **Warum diese beiden zuerst.** Ein Messfehler ist keine Zeile wie die anderen zehn: Er
> betrifft nicht den Bau, sondern das, womit der Bau beurteilt wird. **Nr. 12 ist der
> gefährlichere Typ — falsch grün.** M3 gilt seit dem 15.08. als eingetreten, mit 32 von 32.
> Trägt einer dieser 32 Fälle einen Messfehler, ist die Zahl nicht falsch, aber sie belegt
> etwas anderes als angenommen. Das gehört geklärt, **bevor** über die zehn übrigen
> entschieden wird.

### Dann: was im Kern von M2 liegt

| Nr. | Grund | Art | M2 | Vorschlag Träger | Vorschlag Frist |
|---|---|---|---|---|---|
| **2** | **K03-M05:** `mfa_method` wird beim Anmelden nicht gelesen — ein Konto mit `OFF` würde nicht abgewiesen | **Zeichnung, dann Bau** | **nein**, aber MUSS-Klausel im Kern | A. Han (Kriterium) · dann Bau | Kriterium heute |
| **4** | **K03-M25:** Fehlermeldungen geben den Kontobestand preis | **Zeichnung, dann Bau** | nein | A. Han (Kriterium) · dann Bau | Kriterium heute |
| **3** | **K03-G01:** Sperre ohne den verursachenden Grund — bei fehlendem Versandweg gilt der Link weiter, der Nutzer liest das Gegenteil | **Entscheidung** + Bau | nein | M. Veil (Wortlaut) · Bau | hängt an derselben offenen Entscheidung wie der Einladungswortlaut |
| **6** | **K20-M18:** die Entwertung älterer Anmeldecodes erzeugt keine `event`-Spur mit Vorher/Nachher | **Zeichnung, dann Bau** | nein — AC-15 misst die **Anmeldung**, und die ist belegt | A. Han (Kriterium) · dann Bau | Kriterium heute |
| **7** | **K20-M25:** `_nachweis()` lässt `retention_class` weg; M30 setzt EREIGNIS statt BETRIEBSPROTOKOLL | **Entscheidung** — Widerspruch Klausel ↔ Beschluss Nr. 60 | nein | M. Veil | **vor** dem Bau |
| **5** | **K03-M26:** kein Secret-Handling über verwaltete Identität, keine Alarmierung mit Runbook-Verweis; `mail_delivery` speichert die vollständige Adresse | Bau + **hängt an A-2** | nein | A. Han (Betrieb) · Bau | vor Echtdaten (Tor III) |

### Dann: die großen, die über M2 hinausreichen

| Nr. | Grund | Art | M2 | Vorschlag Träger | Vorschlag Frist |
|---|---|---|---|---|---|
| **1** | **K13-M05** nicht vollständig — Rolle und allgemeiner Objektbezug fehlen, die Mandantenprüfung ist kein durchgängiger Serverpfad | Bau, **groß** | nein | Bau · Abnahme A. Han | vor **M11** |
| **8** | Die Mandantengrenze ist nicht durchgängig — `mandantenvorgang()` wird von keinem Weg benutzt; 22 Stellen ohne Mandantenbedingung | Bau, **groß** | nein | Bau · Abnahme A. Han | vor **M11** |
| **10** | **K04-G11:** kein Produktivsperrriegel; der Router wird bedingungslos eingebunden | Bau | nein | Bau | vor Echtdaten (Tor III) |
| **9** | **K04-M08:** der Termin-Ausweg löst die Ansprechperson nicht auf — es entsteht nur ein internes Ereignis | Bau | nein — **M3** | Bau | zusammen mit Nr. 12 |

---

## Warum keiner dieser vier heute gebaut werden kann — nachgemessen am 23.08.2026

**Die Akzeptanzkriterien aller vier Klauseln tragen die Marke ⟨VORSCHLAG · NICHT
GEZEICHNET⟩:** K03-M05 · K03-M25 · K20-M18 · K20-M25.

K03-M05 sagt es in seiner eigenen Zeile:

> *„Messweg, Schwelle und Evidenzform sagt der Wortlaut nicht — sie ergänzt nach K23-M02 der
> fachliche Eigentümer, der in dieser Zeile heute ⟨nicht benannt⟩ ist."*

**Was das heißt.** Der Bau könnte bauen. Aber niemand könnte feststellen, dass es reicht —
denn wann eine dieser Klauseln als erfüllt gilt, ist nicht gezeichnet. Baut der Harness
trotzdem, entscheidet er den Inhalt eines Kriteriums, und genau das verbieten K23-M02 und
K23-G08: *die Kritikalität und den Inhalt begründet der fachliche Eigentümer, nicht der
Harness.*

**Grund 7 ist noch eine Stufe schärfer:** Dort steht kein fehlendes Kriterium, sondern ein
**Widerspruch zwischen zwei gezeichneten Quellen**. `app/einladung_senden.py:291` hält ihn
fest und weigert sich ausdrücklich, ihn zu entscheiden:

> *„K20-M25 nennt für den Nachweis einer Zugangsänderung BETRIEBSPROTOKOLL; M30 hat die
> Vorgabe der Tabelle am 04.08.2026 auf EREIGNIS umgestellt … Zwei Quellen, ein Widerspruch —
> er wird gemeldet, nicht hier entschieden."*

Wer hier `retention_class` setzt, entscheidet zwischen einer Klausel und **Founder-Beschluss
Nr. 60** — still, in einer Zeile Code.

> **Das ist der eigentliche Grund, warum die zwölf seit dem 20.08. offen sind.** Nicht
> Aufwand. Vier von ihnen warten auf **eine Unterschrift, nicht auf Arbeit** — und die
> Vorschläge für die Kriterien liegen ausformuliert im Register. Sie sind eine Sitzung, kein
> Bauabschnitt.

**Der kürzeste Weg zu einem erneuten Tor 3 führt daher über den Federstrich, nicht über den
Editor:**

```
A. Han zeichnet die vier Akzeptanzkriterien   ── heute möglich
        │                                        (Vorschläge liegen vor)
        ▼
M. Veil entscheidet Grund 7 (Klausel ↔ Nr. 60)
        │
        ▼
der Bau kann gegen ein gezeichnetes Kriterium bauen
        │
        ▼
Tor 3 erneut — gegen einen Stand, dessen Maßstab feststeht
```

---

## Was daraus für die Abnahme von M2 folgt

**Keiner der zwölf Gründe berührt eine der vier Teilaussagen der Nachrechnung.** Sie sind
gemessen und belegt (AC-16, `event`-Spur der Anmeldung, Codefrist, Fehlversuchssperre).

**Das ist kein Freibrief, sondern eine Unterscheidung:** Die Nachrechnung misst vier Sätze;
das Klauselwerk misst mehr. Ein Meilenstein kann eintreten, während im selben Bereich
MUSS-Klauseln offen sind — genau deshalb gibt es beide Maßstäbe.

**Die Entscheidung, die Tor 4 zu treffen hat**, lautet daher nicht *„trotz trägt nicht
abnehmen?"*, sondern:

> Wird M2 als eingetreten festgestellt, **während** die zwölf Gründe als geführte Punkte mit
> Träger und Frist weiterlaufen — oder wartet die Feststellung, bis eine benannte Teilmenge
> davon behoben ist?

`☐` **A** — M2 feststellen, die zwölf laufen als geführte Punkte weiter
`x` **B** — erst die beiden Messfehler (11, 12) klären, dann M2 feststellen
`☐` **C** — erst eine größere Teilmenge beheben: ⟨Nummern: …………⟩

> **Empfehlung des Harness zum Vorgang, nicht zum Inhalt:** **B.** Die beiden Messfehler
> kosten wenig und betreffen das, womit gemessen wird — eine Feststellung, die auf einem
> ungeklärten Messfehler ruht, ist genau die Sorte Beleg, die dieses Projekt sonst
> zurückweist. Die übrigen zehn sind Bau und Betrieb; sie laufen ohnehin weiter.

---

## Zeichnung

**Träger und Frist setzt ein Mensch.** Die Spalten oben sind **Vorschläge** mit Begründung;
der Harness trägt sie nicht ein. Nach K23-M04 ersetzt eine Annahmeentscheidung keinen
fehlenden Prüffall — wo ein Grund als Restrisiko angenommen wird, gehört das ausdrücklich
gezeichnet und nicht durch Fristsetzung ersetzt.

| Nr. | Grund, kurz | Träger | Frist |
|---|---|---|---|
| **12** | VP-18 misst zugunsten des Standes | Prüf-Agent | zuerst |
| **11** | Fehlermeldungen gehen im Erfolgszweig verloren | Prüf-Agent | zuerst |
| **2** | K03-M05 · mfa_method nicht gelesen | Bau | erledigt 23.08. |
| **7** | K20-M25 · retention_class | M. Veil | entschieden 23.08. |
| **4** | K03-M25 · Kontobestand in Fehlermeldungen | Bau | vor Pilotstart |
| **3** | K03-G01 · Sperre ohne Grund | M. Veil · Bau | mit dem Einladungswortlaut |
| **6** | K20-M18 · keine Vorher/Nachher-Spur | Bau | vor Pilotstart |
| **5** | K03-M26 · Secret-Handling, volle Adresse | A. Han · Bau | vor Echtdaten (Tor III) |
| **10** | K04-G11 · kein Produktivsperrriegel | Bau | vor Echtdaten (Tor III) |
| **9** | K04-M08 · Termin löst Ansprechperson nicht auf | Bau | mit Nr. 12 |
| **1** | K13-M05 · Rolle und Objektbezug fehlen | Bau · Abnahme A. Han | vor M11 |
| **8** | Mandantengrenze · 22 Stellen | Bau · Abnahme A. Han | vor M11 |

### Zeichnung

`x` **Träger und Fristen gelten wie in der Tabelle oben.**

*Abweichungen — nur die Zeilen eintragen, die anders sein sollen:*

| Nr. | Träger | Frist | als Restrisiko angenommen? |
|---|---|---|---|
| ⟨…⟩ | ⟨………………⟩ | ⟨………………⟩ | ⟨ja/nein⟩ |
| ⟨…⟩ | ⟨………………⟩ | ⟨………………⟩ | ⟨ja/nein⟩ |
| ⟨…⟩ | ⟨………………⟩ | ⟨………………⟩ | ⟨ja/nein⟩ |

⟨zeichnet: …M. Veil, A. Han………………⟩ ⟨am: ……23.8.26……………⟩

> **Ein Kreuz statt sechsunddreißig Feldern.** Die Vorschläge stehen unverändert darüber;
> das Kreuz macht sie zur Zeichnung. Nach K23-M04 ersetzt eine Annahmeentscheidung keinen
> fehlenden Prüffall — wo eine Zeile als Restrisiko angenommen wird, gehört das ausdrücklich
> in die Abweichungstabelle und nicht in eine Frist.

> **Die beiden linken Spalten sind Vorschläge des Harness, die beiden rechten sind die
> Zeichnung.** Sie stehen nebeneinander, damit sichtbar bleibt, wo jemand abgewichen ist.
> Die Reihenfolge ist die vorgeschlagene Bearbeitungsreihenfolge, nicht die Nummernfolge.

**Gezeichnet:** ⟨……M. Veil…………………⟩ **am** ⟨……23.8.26…………⟩
