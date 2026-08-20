# Was aus der Zeichnung folgt — **drei Punkte vor der Unterschrift morgen**

**20.08.2026 · ⟨VORSCHLAG · NICHT GEZEICHNET⟩**

Die Standortbestimmung ist gezeichnet — alle sechs Entscheidungen, A. Han und M. Veil,
20.08.2026. Dieses Blatt sagt, **was daraus folgt**, was schon erledigt ist, und **was vor der
Unterschrift am 21.08. noch zu klären ist.**

---

## 1 · Was jetzt gilt

| | Entscheidung | Folge |
|---|---|---|
| **1** | Stand zur Kenntnis genommen | keine |
| **2** | **Weg A** | Der Umfang zum 31.08. ist der **Teilschnitt bis zur Anmeldung**. M4 bis M12 werden zurückgestellt und bekommen über BA-3 eigene Termine — **wirksam wird das erst mit der Gegenzeichnung** (§12.9) |
| **3** | BA-1/BA-2 gegenzeichnen, nach #41, am 21.08. | siehe Abschnitt 2 — **die Bedingung ist bereits erfüllt** |
| **4** | Zugang zur Pilotumgebung bis 21.08. | M1 ist danach mit **einem Befehl** messbar, siehe Abschnitt 4 |
| **5** | Antwortlisten bis 24.08. | löst 88 der 115 M5-Sperren — **aber nicht alle**, siehe Punkt **B** |
| **6** | Tor 3 anfordern bis 21.08., durch A. Han | **Gegenstand ungeklärt**, siehe Punkt **A** |

---

## 2 · Erledigt, ohne dass es jemand tun musste

**#41 ist zusammengeführt.** Der Merge liegt als `795bcdd` auf `main` — *„Merge pull request #41
from exmachinAI-GmbH/m5-vorbereitung"*. **Die Vorbedingung aus Entscheidung 3 ist damit
erfüllt**; die Unterschrift am 21.08. sperrt keine fertige Arbeit hinter sich, jedenfalls nicht
diese.

Der Bauzweig `scheibe/m5-gespraech` stand noch auf dem Stand davor. Er ist nachgezogen und
setzt jetzt auf `main` auf — **0 Commits Rückstand, 31 voraus.**

---

## 3 · Die drei Punkte, die vor der Unterschrift zu klären sind

### A · **Welchen Gegenstand bekommt Tor 3?** — der wichtigste Punkt

Entscheidung 6 sagt *„Tor 3 anfordern bis 21.08., durch A. Han"*. Sie sagt **nicht, wofür.**
Im Bestand liegen **zwei** fertige Anforderungen:

| Blatt | Gegenstand |
|---|---|
| `tor3_anforderung_teilschnitt_260816.md` | **`teilschnitt-anmeldung`** — der Teilschnitt bis zur Anmeldung, dazu die Vorprüfung mit Halt |
| `tor3_anforderung_m5_gespraech_260820.md` | **M5** — EN-05, EN-06, die neun Serverbefehle, der Zeilenschutz M32 |

**Das ist keine Formalie.** C-4 sagt: *„einmal je Scheibenabnahme, nicht je Änderung"* —
**frische Instanz, getrennter Kontext.** Es gibt also **einen** Durchgang, nicht zwei.

> **Empfehlung: den Teilschnitt.** *(abgeleitet aus Entscheidung 2)*
>
> Mit Weg A ist **M5 zurückgestellt**. Ein fremder Blick auf M5 wäre wertvoll — aber er zahlt
> **nicht auf den 31.08. ein**, weil M5 zu diesem Termin nichts mehr beweisen muss. Was zum
> 31.08. abgenommen wird, ist der Teilschnitt. **Also gehört der eine Durchgang dorthin.**
>
> Das Blatt von M5 bleibt liegen und wird gebraucht, sobald M5 seinen eigenen Termin aus BA-3
> hat.

**⚠ Das Teilschnitt-Blatt trägt noch die alten Daten** — *„Anforderung abschicken bis: Montag,
17.08.2026"*. Vor dem Abschicken sind Datum und der geprüfte Commit nachzuziehen. Das kann der
Harness vorbereiten; die Zeichnung des Kopfes bleibt beim Menschen.

`☐` **Teilschnitt** *(Empfehlung)* · `☐` M5 · `☐` beide — mit der Folge, dass zwei Instanzen
gebraucht werden

### B · **Die Fachfragen der Stufe 02 sind nicht beauftragt**

In Entscheidung 5 ist das Kästchen *„Die Fachfragen der Stufe 02 werden mitbeauftragt"*
**leer geblieben**. Das ist eine Angabe mit Folgen, und der Harness legt sie vor, statt sie
auszulegen.

**Gemessen am Klausellauf vom 20.08.:**

| | |
|---|---|
| **34 von 115** Sperren betreffen **EN-06** | Der blinde Prüffall findet den Bildschirm an *„Diese Frage ignorieren"* — nach **K05-M10** steht die Schaltfläche an **jeder gestellten** Fachfrage |
| **Ohne gelieferte Fachfragen wird keine gestellt** | also steht die Schaltfläche nirgends, also ist EN-06 nicht auffindbar. Der Bau weist das sauber aus (`MELDUNG_FACHFRAGEN_FEHLEN`) statt eine leere Kennung anzubieten |
| **Folge** | **Diese 34 bleiben auch nach dem 24.08. gesperrt.** Die Antwortlisten lösen EN-05, nicht EN-06 |

> **Das kann richtig sein.** Mit Weg A ist M5 zurückgestellt — dann ist es *folgerichtig*, die
> Fachfragen jetzt nicht zu beauftragen, und die 34 Sperren gehören zum zurückgestellten Teil.
> **Der Harness legt es nur offen, damit die Zahl später niemanden überrascht.**

`☐` bewusst nicht beauftragt — sie gehören zum zurückgestellten M5 *(die naheliegende Lesart)*
`☐` doch mitbeauftragen, bis ⟨Datum: ⟩

### C · **Der Bauzweig gehört vor der Unterschrift hoch**

**Ab der Zeichnung ist keine Vorlage zur Freigabe mehr zulässig, bis alle 25 Haken sitzen**
(§12.4 Nr. 5). Genau davor warnt BA-1 selbst: *„Wer zeichnet, bevor die Anträge durch sind,
sperrt fertige Arbeitsstände hinter der eigenen Korrektur."*

`scheibe/m5-gespraech` trägt **31 Commits**, darunter der gesamte M5-Bau, Tor 2 mit den 128
blinden Prüffällen, der Riegel in `lauf.sh` und die Blätter dieses Tages. Ohne Antrag liegt das
ab morgen still, bis die 25 Eintragungen im Auftragstext stehen.

> **Empfehlung: heute noch einen Antrag stellen.** *(Vorschlag)* Er löst zugleich **Tor 1 in
> der CI** aus — für diesen Zweig ist es dort noch nie gelaufen.
>
> **Der Harness stellt ihn nicht von sich aus.** Zusammenführen und Freigeben sind menschliche
> Akte (`CLAUDE.md` Abschn. 6, bestätigt am 18.08.). Den **Antrag** hat er auf Weisung schon
> einmal angelegt — #41. Auf dieselbe Weisung legt er ihn wieder an.

`☐` Antrag heute stellen *(Empfehlung)* · `☐` erst nach dem Vollzug der 25 Stellen

---

## 4 · Was der Harness bis morgen früh vorbereiten kann

| | | Wert |
|---|---|---|
| **a** | **Das Vollzugsheft** — 25 Stellen, je Blatt von unten nach oben, mit Ankerzitat, altem und neuem Wortlaut | Verkürzt das Sperrfenster auf das reine Eintragen. **Mit Warnvermerk:** von den 13 BA-1-Ankern ist genau **einer** am mitgeführten §6/§6a-Auszug prüfbar, von den 12 BA-2-Ankern **zwei** — alle übrigen liegen in Abschnitten, die hier nicht vorliegen. **Stimmt ein Anker nicht: nicht eintragen, sondern fragen** (BA-1:479) |
| **b** | **Die Teilschnitt-Anforderung nachziehen** — Datum, geprüfter Commit, Roh-Evidenz mit Prüfsummen | Sie ist dann abschickfertig. Der **Kopf** bleibt leer; ihn zeichnet ein Mensch |
| **c** | **M1 startklar dokumentieren** | Es ist **ein Befehl**: `./migrations/n2_lauf.sh "<verbindung zur zielumgebung>"`. Er spielt die Migration zweimal ein, vergleicht Schema **und** Daten, fährt `M30__pruefung.sql`, die Gegentests und T0–T23, und legt fünf Belege ab. **Es fehlt nur die Verbindung und `frxfw`** |

`☐` a · `☐` b · `☐` c — *(Empfehlung: alle drei; keines davon entscheidet etwas)*

---

## Zeichnung

| Name | Rolle | Datum |
|---|---|---|
| A. Han | für den Auftragnehmer (Nr. 158) | ⟨ ⟩ |
| M. Veil | für den Auftraggeber | ⟨ ⟩ |

---

*Erstellt am 20.08.2026 aus der gezeichneten Standortbestimmung. Der Harness trägt in kein
Kästchen etwas ein, das nicht angewiesen ist. Punkt A ist der einzige, bei dem ein falscher
Griff etwas kostet, das sich nicht nachholen lässt: **es gibt einen Tor-3-Durchgang, nicht
zwei.***
