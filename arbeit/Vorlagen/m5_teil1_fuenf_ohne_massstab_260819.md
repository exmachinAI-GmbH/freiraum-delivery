# M5 · Die fünf Klauseln ohne Maßstab — **fünf Festlegungen, die A. Han zeichnen kann**

**19.08.2026 · gezeichnet von A. Han · alle fünf Festlegungen nach Empfehlung, 10 Minuten bei T-5**

Am 19.08.2026 sind 90 von 95 Akzeptanzkriterien gezeichnet worden. **Fünf blieben liegen**,
weil im Register ausdrücklich *NICHT ABLEITBAR* steht — der Klauselwortlaut trage keinen
messbaren Maßstab. Weisung im Wortlaut: *„mache Handlungsempfehlungen zu Teil 1, die ich
zeichnen kann"*.

## Das Ergebnis in einem Satz

**Bei vier von fünf fehlt die Angabe gar nicht — sie steht woanders, und zweimal hat A. Han sie
am selben Tag selbst mitgezeichnet.** Zu zeichnen ist dort keine neue Festlegung, sondern eine
**Zuordnung**. Nur bei **K05-M27** fehlt wirklich etwas: zwei Zahlen.

| | Klausel | Was zu zeichnen ist | Art |
|---|---|---|---|
| **T-1** | `K05-D03` | D03 wird in M5 an ihrer **zweiten Hälfte** gemessen (*„oder sie findet nicht statt"*); die erste hängt am gezeichneten Kriterium zu `K05-M12` | **Zuordnung** |
| **T-2** | `K05-G12` | Die Sperre trägt **kein Merkmal am Bau** — Feststellung plus **eine Restrisikozeile**, keine Aufhebung | **Feststellung** |
| **T-3** | `K05-M20` | **Zurückstellung** bis zur F31-Freigabe des Stimmwegs, mit Deckungsanzeige auf drei bereits gezeichnete Kriterien | **Zurückstellung** |
| **T-4** | `K05-M24` | Die „fehlende Rollenmatrix" **gibt es nicht**: das Endnutzer-Portal führt genau **eine** Rolle | **Feststellung (Rang 0 + 1)** |
| **T-5** | `K05-M27` | **Zwei Zahlen** — Höchstdauer eines ausgestellten Zugriffs und Mindestmaß für *nicht erratbar* | **echte Festlegung** |

> **Verfahren.** Je Klausel ein Entwurf, danach ein Widerleger mit dem Auftrag zu kippen. Er hat
> **zwei von fünf Empfehlungen umgeworfen** (T-3 und T-2) und drei mit Berichtigungen versehen.
> Was hier steht, ist die berichtigte Fassung.

---

## T-1 · `K05-D03` — die Sichtbarkeit ist schon gezeichnet

> *„Ein Eintrag der rechten Spalte DARF NICHT stillschweigend durch eine Formulierung des
> Assistenten ersetzt werden. Eine Änderung ist sichtbar oder sie findet nicht statt."*

**Der Befund:** Der bisherige Eintrag verlangt vom Eigentümer drei Angaben — woran Sichtbarkeit
beobachtbar ist, über welchen Serverbefehl eine Ersetzung liefe, welcher Vergleichsstand gilt.
**Alle drei stehen bereits:**

- *Sichtbarkeit* → **`K05-M12`** (*„Wird ein Eintrag nach seiner Entstehung geändert, MÜSSEN
  Ursprung und Bearbeitungszustand getrennt angezeigt werden. Die Marke allein genügt dann
  nicht"*), gestützt von `K19-G09`. **Das Kriterium dazu ist seit dem 19.08.2026 gezeichnet.**
- *Vergleichsstand* → `K05-M25`/`K05-M26` (unveränderlicher Dateistand, Hash des Vorgängers,
  jüngster `event`-Eintrag) — **ebenfalls gezeichnet.**
- *Serverbefehl* → **keiner.** Von den zehn Serverbefehlen ersetzt keiner einen bestehenden
  Eintrag; die Fehlerzustände sagen es wörtlich (*„bisherige Antworten bleiben unverändert"*).

**Empfehlung:** In M5 an der zweiten Hälfte messen. Der Positivfall beweist eine Abwesenheit —
deshalb trägt der **Negativfall die Last**: er wird *eingespielt*, nicht bedient (ein Stand, in
dem ein Wortlaut ersetzt ist, während die Marke steht), und muss auffallen.

**Was auch dann nicht gemessen ist:** eine stille Ersetzung, die über einen *regulär
angehängten* neuen Stand kommt — kein Zustand des Bildschirmvertrags verlangt heute, dass Bau
oder Server den vorigen Wortlaut dagegen hält. Das bleibt offen und gehört genannt.

`x` **Ich lege fest:** K05-D03 wird in M5 an *„oder sie findet nicht statt"* gemessen; die erste
Hälfte hängt am gezeichneten Kriterium zu `K05-M12`/`K19-G09`. Ein elfter Serverbefehl entsteht
dafür nicht.

---

## T-2 · `K05-G12` — eine Sperre, die man nicht messen, sondern führen muss

> *„Solange O-K05-1 und O-K05-2 offen sind, bleibt K05 Freigabekandidat … der Produktivweg
> bleibt gesperrt."*

**Der Befund:** Gemessen am Bildschirmvertrag — **elf Aktionen, zehn Serverbefehle**, keiner
heißt *Produktivweg*, keiner setzt einen *Freigabestand*. Die Klausel richtet sich an den
Freigabeprozess, nicht an EN-05/EN-06. **Der Widerleger hat den ersten Entwurf gekippt**, weil
dessen Prüffall eine *„Ergebniszeile je Klausel"* voraussetzte — die es nicht gibt (das Feld
`test` ist in **1231 von 1231** Zeilen leer).

**Empfehlung — feststellen und führen, nichts aufheben:**

1. Für M5 entsteht zu `K05-G12` **kein Prüffall**; das ist eine Zählung, keine Wahl.
2. Das Feld *Test* trägt den Vermerk **„kein Test — Restrisiko"**; das Akzeptanzkriterium bleibt
   offen, und der Bauauftrag ist insoweit unvollständig.
3. **Eine Zeile in der Restrisikoliste** (K23-M04, K23-D07): Träger **M. Veil**,
   Erledigungsbedingung *„K05 Abschn. 5 nachgezogen"* (Entscheidung 2 vom 19.08.2026),
   Annahmeentscheidung des Auftraggebers **offen**.

**Ausdrücklich nicht:** die Sperre als erfüllt ankreuzen. `K05-G11` verbietet es im Wortlaut —
und dasselbe Kästchen ist am selben Tag bewusst **nicht** angekreuzt worden.

`x` **Ich stelle fest und lege fest:** K05-G12 trägt kein Merkmal am Bau; für M5 entsteht kein
Prüffall; das Feld *Test* trägt „kein Test — Restrisiko"; eine Restrisikozeile mit Träger
M. Veil und der Erledigungsbedingung aus Entscheidung 2 wird geführt.

---

## T-3 · `K05-M20` — zurückstellen, nicht messen *(der Widerleger hat hier gedreht)*

> Verlangt die **Trennung zweier Bedienungen**: Diktat und freihändiges Sprechen.

**Der Befund:** Die zweite Bedienung **darf in Release 1 nicht betrieben werden** (`K05-D12`,
`K05-M30`). Der Entwurf wollte daraus ein Kriterium bauen — der Widerleger hat es gekippt:

> Die Lücke, die er schließen wollte, **ist bereits geschlossen.** Am 19.08. sind drei Kriterien
> gezeichnet worden, die den Release-1-Zustand vollständig abdecken: `K05-M30` (*keine Bedienung
> sichtbar; ein vorbei abgesetzter Aufruf wird serverseitig abgewiesen*), `K05-D12` und
> `K05-M21`. Ein viertes Kriterium in abweichendem Wortlaut misst dasselbe zweimal — und
> misslingt an der **Zweiheit**, die die Klausel eigentlich verlangt: sie ist nicht herstellbar,
> solange es die zweite Bedienung nicht gibt.

**Empfehlung:** **Zurückstellen** bis zur Freigabe eines bewerteten Falls nach F31 — mit
ausdrücklicher **Deckungsanzeige** statt der falschen Behauptung, die Sperre sei ungemessen.
Grundlage ist `K05-D12`/`K05-M30`, **nicht** Blatt 100 E4 (das betrifft den Dateianhang).

**Der Preis, ausdrücklich in Kauf genommen:** Bis zur F31-Freigabe misst zu dieser Klausel
nichts. Tragbar, weil der beobachtbare Rest dreifach gezeichnet gemessen ist.

`x` **Ich lege fest:** K05-M20 bleibt zurückgestellt bis zur F31-Freigabe des Stimmwegs; der in
Release 1 beobachtbare Rest ist durch die gezeichneten Kriterien zu `K05-M21`, `K05-M30` und
`K05-D12` gedeckt und wird unter K05-M20 nicht ein zweites Mal gemessen.

---

## T-4 · `K05-M24` — die fehlende Rollenmatrix gibt es nicht

> *„Jeder Aufruf aus den Stufen 01 und 02 MUSS über den Serverpfad laufen, der Konto,
> Mitgliedschaft, **Rolle**, Mandant und Objektbezug prüft."*

**Der Befund:** Der Eintrag vom 16.08. gibt die **ganze** Klausel auf, weil *„die Rollenmatrix"*
fehle. Sie fehlt nicht — sie steht auf **Rang 0 und Rang 1**:

```
schema/freiraum_datamodel.sql:685–687     INSERT INTO role(portal_code,name) VALUES
                                            ('EXMA',   'Plattform-Admin'),
                                            ('ENDUSER','Endnutzer');
schema/freiraum_datamodel.sql:691–692     role_right → 'V' für ENDUSER · 'Endnutzer'
```

Rang 0 sagt dasselbe dreimal: `K14-G04` (*„F08: Release 1 kennt genau eine Rolle je Portal … und
ausdrücklich keinen Rechte-Baukasten"*), `K20-M02`, `K20-M03`.

**Empfehlung:** Als **Messung** festschreiben — die für die Stufen 01/02 ausreichende Rolle ist
die eine Rolle des Endnutzer-Portals. Damit wird K05-M24 in vier Dimensionen messbar und
verlässt den Zustand *NICHT ABLEITBAR*. **Ohne** eigenen Rollen-Negativfall: die Rolle steht als
`role_id` in derselben `membership`-Zeile wie Portal und Reichweite (`K20-M04`) und wird **mit
der Mitgliedschaft** gemessen.

**Was offen bleibt:** Ob der Serverpfad eine `membership`-Zeile mit portalfremder `role_id`
abweisen muss, sagt kein Wortlaut — und das Schema erzwingt es nicht (kein CHECK auf
`role.portal_code = membership.portal_code`). Solange es je Portal genau eine Rolle gibt, fällt
die Rolle mit der Mitgliedschaft zusammen.

`x` **Ich stelle fest:** Die ausreichende Rolle ist gesetzt (*Endnutzer*, Rechtestufe `V`); eine
Rollenmatrix je Aufruf entfällt; die Rolle trägt in Release 1 keinen eigenen Negativfall.

---

## T-5 · `K05-M27` — hier fehlt wirklich etwas: **zwei Zahlen**

> *„Dateiobjekte verwenden nicht erratbare Schlüssel und sind nur über kurzlebige, serverseitig
> autorisierte Zugriffe erreichbar."*

**Der Befund:** Die beiden Werte sind **nicht gleich viel wert.**

| | Wert | Lage |
|---|---|---|
| **(1)** | *nicht erratbar* | Das eingefrorene Datenmodell führt **eine** Schlüsselform für Objektidentität: `uuid DEFAULT gen_random_uuid()`, an **16 Stellen**, namentlich `document.id`. **Gemessen ist die Vorlage** — ihre Übertragung auf `content_ref` ist die Festlegung, denn `M30:492` lässt die Spalte als blankes `text` |
| **(2)** | *kurzlebig* | **Keine Quelle nennt eine Zahl.** Das kürzeste im Register bezifferte Maß für eine serverseitig ausgestellte Berechtigung sind **10 Minuten** (`K03-M15`, `K03-M18`); die nächsten sind 15 Minuten, 30 Minuten (Sitzungsgrenze `K03-M17`), 1 Stunde |

**Empfehlung:** **10 Minuten** — die Größenordnung ist geliehen, nicht erfunden, und bleibt unter
der einzigen messbaren Obergrenze (der Sitzungsgrenze; die Abmeldung ist der Satz, an dem M5
nachgerechnet wird). Die F11-Fristen (24 Stunden, 14 Tage) sind **ausdrücklich nicht** das
Vorbild: sie gelten Verweisen, die *aus der Hand gegeben* werden. Beim Schlüssel wird **Form,
Herkunft und Abwesenheit fachlicher Bestandteile** gemessen — **keine Bitzahl**, die an einem
Einzelwert ohnehin niemand feststellen kann.

**Was offen bleibt — und den Wert bedingt macht:** Ob überhaupt ein Zugriff *ausgestellt* wird,
ist ungezeichnet (Ablage-Nachtrag, Punkt B; die Schnittstelle kennt nur *schreiben · lesen ·
Hash prüfen · sperren*). Liest der Server selbst, ist Teil (2) **nicht anwendbar** — und wird so
vermerkt, nicht als bestanden. Ebenfalls offen: der Träger der Ablage (Punkt A), der Widerruf
eines bereits ausgestellten Zugriffs bei Abmeldung, und der Wortlaut der Abweisung.

`x` **Ich lege fest:** (1) Ein serverseitig ausgestellter Zugriff auf die Protokolldatei gilt
höchstens **10 Minuten**, serverseitig gegen den gespeicherten Ausstellungszeitpunkt geprüft.
(2) `document.content_ref` trägt mindestens die Schlüsselform des Datenmodells (`uuid`, Fassung
4, serverseitig erzeugt, ohne fachlichen Bestandteil). Die längeren Fristen für aus der Hand
gegebene Zugänge (`K07-M23`, `K12-M04/M10/M11`, `K14-M21`) bleiben unberührt.

---

## Zeichnung

| | Klausel | Festlegung | |
|---|---|---|---|
| **T-1** | `K05-D03` | an der zweiten Hälfte messen; erste Hälfte über `K05-M12` | **x** so · ☐ zurückstellen · ☐ anders: |
| **T-2** | `K05-G12` | kein Prüffall; Vermerk „kein Test — Restrisiko"; eine Restrisikozeile | **x** so · ☐ anders: |
| **T-3** | `K05-M20` | zurückstellen bis F31, mit Deckungsanzeige | **x** so · ☐ jetzt messen · ☐ anders: |
| **T-4** | `K05-M24` | eine Rolle je Portal — Feststellung, kein eigener Rollenfall | **x** so · ☐ anders: |
| **T-5** | `K05-M27` | **10** Minuten · Schlüsselform `uuid` v4 | **x** 10 Minuten · ☐ ⟨andere Zahl: ⟩ · ☐ Frist an K13 |

| Name | Rolle | Datum |
|---|---|---|
| A. Han | fachlicher Eigentümer, für den Auftragnehmer | **19.08.2026** |

> **Übertragung durch den Harness.** Weisung im Wortlaut, 19.08.2026: *„T-1 bis T-5 alle so
> zeichnen, 10 Minuten bei T-5"*. Eingetragen ist je Zeile die ausgewiesene Empfehlung; bei T-5
> die angewiesene Zahl. Eine erteilte Zeichnung einzutragen ist Buchführung, eine zu erfinden
> wäre Anmaßung (`CLAUDE.md` Abschn. 6).

**Vollzogen am 19.08.2026:**

- Die **fünf Zellen** stehen in `pflege.json`, je mit `⟨GEZEICHNET⟩`, Name, Datum und der
  Weisung — eingetragen mit `M5_teil1_zeichnung_eintragen.py`, das eine andere als die
  angewiesene Zahl abgewiesen hätte.
- **`K05-G12`** trägt im Feld `test` den gezeichneten Vermerk *„kein Test — Restrisiko"* —
  ausdrücklich **keine** Aussage über einen Lauf.
- Die verlangte Zeile steht als **`RR-06`** in `nachweise/restrisiken/restrisiken.md`: Träger
  M. Veil, Erledigungsbedingung *„K05 Abschn. 5 nachgezogen"*, Annahmeentscheidung offen.

**Damit sind 95 von 101 M5-Klauseln gezeichnet.** Die übrigen sechs gehören K17 und liegen bei
M. Veil.

---

*Erarbeitet am 19.08.2026: je Klausel ein Entwurf und ein Widerleger mit dem Auftrag zu kippen;
zwei Empfehlungen sind dabei umgeworfen worden (T-2, T-3), drei berichtigt. Alle Belege sind
gegen `nachweise/klauselregister/register.json`, `schema/freiraum_datamodel.sql`,
`migrations/M30__pilot_sammelmigration.sql` und `schema/K19_screens.yaml` nachgeschlagen; die
Konzept-Fabrik wurde nicht angefasst.*
