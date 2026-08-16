# Fachliche Eigentümer — **eingeengt auf den Teilschnitt, gez. M. Veil 16.08.2026**

> **Diese Datei gehört dem Menschen.** Der Harness hat sie angelegt, die Zahlen gemessen
> und einen **Vorschlag** in die Spalte *Fachlicher Eigentümer* geschrieben. **Der
> Vorschlag ist sichtbar als solcher gekennzeichnet.** Er wird erst durch die Zeichnung
> unten zur Zuordnung. Wer die Spalte überschreibt, ohne unten zu zeichnen, hat nichts
> entschieden.

| | |
|---|---|
| **Warum es dieses Blatt gibt** | `K23-M02` verlangt je Registerzeile einen fachlichen Eigentümer. Gemessen am 16.08.2026: **0 von 1231** Zeilen tragen einen |
| **Entschieden am 16.08.2026** | **Nur die Klauseln des Teilschnitts bekommen einen Eigentümer.** Weisung im Wortlaut: *„Nur für die 167 des Teilschnitts. Nur die Regeln, die zum Weg bis zur Anmeldung gehören, bekommen einen Verantwortlichen. Die übrigen bleiben leer, bis sie an der Reihe sind."* — **gez. M. Veil, 16.08.2026** |
| **Fassung** | 2 · **16.08.2026 abends**. Fassung 1 (leeres Formular über alle 24 Konzepte) ist durch diese Entscheidung überholt |
| **Angelegt am** | 16.08.2026 · auf Weisung zu B-4, eingeengt auf Weisung zu D-1 |

---

## ⚠ Zwei Berichtigungen vorweg — beide Zahlen der Frage waren zu grob

**Die Frage an M. Veil sprach von „den 167 des Teilschnitts" und legte nahe, damit seien
nur wenige Konzepte betroffen. Beides ist beim Nachmessen enger bzw. weiter geworden.**

### Berichtigung 1 · Es sind **157** Klauseln, nicht 167

Die Zahl 167 stammt aus Kreuz 7.2 vom 15.08.2026. Sie war schon vor dieser Entscheidung
im Repository berichtigt (`nachweise/restrisiken/restrisiken_teilschnitt.md`, Zeilen
37–41):

| Schritt | Quelle | Klauseln |
|---|---|---:|
| 1 · Die fünf Stationen des Teilschnitts, Vereinigungsmenge | `S1_wortmarken.json` | **152** |
| 2 · **plus** die Regeln der Bauspur ohne eigenes Stationswort | `S1_bauspur_nachpruefung.md` | **+5** — `K03-G01` · `K03-M26` · `K20-M14` · `K20-M25` · `K23-D09` |
| **= Ausschnitt** | | **157** |
| *(Kreuz 7.2 zählte zusätzlich 10 von Prüffällen genannte Regeln)* | | *(+10 = 167)* |

**Die zehn zusätzlichen haben einen Prüffall.** Für sie liefert der Prüffall bereits, was
ein Akzeptanzkriterium leisten soll. Sie stehen deshalb unten **mit**, ändern aber nichts
an der Sperrfrage.

```
$ python3 -c "…S1_wortmarken.json + S1_bauspur_nachpruefung.md…"
AUSSCHNITT gesamt: 157
Konzepte: 20
```

### Berichtigung 2 · Es sind **20 Konzepte**, nicht vier

**Das ist die Berichtigung, auf die es ankommt.** Die Frage stellte die Einengung als
großen Aufwandsunterschied dar. Bei den **Klauseln** ist sie das auch — 157 statt 1231,
ein Achtel. Bei den **Namen** ist sie es kaum:

| | ohne Einengung | mit Einengung | gespart |
|---|---:|---:|---:|
| **Klauseln mit Eigentümer** | 1231 | **157** | 87 % |
| **Namen, die einzutragen sind** | 24 | **20** | **17 %** |

**Der Grund:** Der Teilschnitt ist ein **senkrechter** Schnitt. Der Weg vom Mandanten bis
zur Anmeldung berührt fast jedes Konzept ein wenig — Sicherheit, Datenschutz, Bedienung,
Architektur, Protokoll. Nur **vier** Konzepte bleiben ganz außen vor: **K09** (Angebot),
**K18** (Wissens-Struktur), **K21** (Richtlinien), **K22** (durch F28 ohnehin nicht
Gegenstand).

> **Was die Entscheidung trotzdem wert ist.** Sie spart nicht die Namen, sie spart die
> **Arbeit dahinter**: Ein Eigentümer schuldet nach `K23-M02` je Klausel ein
> Abnahmekriterium. 157 Kriterien statt 1231 ist der Unterschied zwischen machbar und
> nicht machbar — und **genau das war der Zweck der Frage.** Die Entscheidung trägt also,
> auch wenn eine ihrer Begründungen zu günstig dargestellt war.

---

## Der Umfang, gemessen — 157 Klauseln über 20 Konzepte

*Spalte **Ausschnitt**: Klauseln des Teilschnitts. Spalte **sperrt**: davon kritisch und
ohne Prüffall — dort ersetzt nach `K23-M04` keine Annahmeentscheidung den Test. Spalte
**gesamt**: alle Klauseln des Konzepts, zum Vergleich.*

| Konzept | Titel | **Ausschnitt** | **sperrt** | gesamt | **Fachlicher Eigentümer** *(Vorschlag)* | **Gez. / Datum** |
|---|---|---:|---:|---:|---|---|
| **K02** | Fundament | **33** | **30** | 61 | Auftragnehmer *(A. Han)* | |
| **K03** | Anmeldung | **31** | **16** | 50 | Auftragnehmer *(A. Han)* | |
| **K20** | Zugänge und Nutzer (EXMA) | **21** | 6 | 46 | Auftragnehmer *(A. Han)* | |
| **K01** | Rahmenkonzept v2.9 | **11** | 8 | 81 | Auftragnehmer *(A. Han)* | |
| **K11** | Betriebs-Portal | **10** | 7 | 54 | Auftragnehmer *(A. Han)* | |
| **K14** | Sicherheits-Grundlinie | **9** | 7 | 53 | Auftragnehmer *(A. Han)* | |
| **K23** | Test- und Abnahmekonzept | **7** | 5 | 41 | Auftragnehmer *(A. Han)* | |
| **K07** | Prototyp und Verfeinern | **6** | 6 | 46 | Auftragnehmer *(A. Han)* | |
| **K13** | Architektur-Muster | **6** | 6 | 53 | Auftragnehmer *(A. Han)* | |
| **K04** | Eignungs- und Schnell-Check | **3** | 3 | 49 | Auftragnehmer *(A. Han)* | |
| **K05** | Geführtes Gespräch | **3** | 2 | 56 | Auftragnehmer *(A. Han)* | |
| **K10** | Übergabe-Paket | **3** | 3 | 61 | Auftragnehmer *(A. Han)* | |
| **K12** | Prototyp-Hosting | **3** | 3 | 26 | Auftragnehmer *(A. Han)* | |
| **K08** | Wissen und Quellen im Projekt | **2** | 2 | 53 | Auftragnehmer *(A. Han)* | |
| **K17** | Agenten-Betriebskonzept | **2** | 2 | 79 | **M. Veil** — siehe Begründung | |
| **K19** | Build-Referenz (ASCII) | **2** | 2 | 32 | Auftragnehmer *(A. Han)* | |
| **K25** | Wortschatz des Prototyp-Erzeugers | **2** | 2 | 70 | Auftragnehmer *(A. Han)* | |
| **K06** | Anforderungskonzepte und Fachreview | **1** | 1 | 63 | Auftragnehmer *(A. Han)* | |
| **K15** | Datenschutz- und Löschkonzept | **1** | 1 | 41 | **M. Veil** — siehe Begründung | |
| **K16** | Bedien-Standard | **1** | 1 | 54 | Auftragnehmer *(A. Han)* | |
| | **Summe** | **157** | **113** | 1231 | | |

**Nicht in dieser Liste — und das ist die Entscheidung vom 16.08.2026:**
**K09** (Angebot und Freigabe, 39) · **K18** (Wissens-Struktur, 59) · **K21**
(Richtlinien, 40) berühren den Teilschnitt nicht und bleiben **ohne Eigentümer**, bis sie
an der Reihe sind. **K22** ist durch **F28** ohnehin nicht Gegenstand des Bauauftrags.

---

## Woher der Vorschlag kommt — er ist abgeleitet, nicht erfunden

**Fassung 1 dieses Blattes ließ die Spalte leer, weil keine Quelle einen Menschen je
Konzept benennt. Das gilt unverändert.** Was sich geändert hat: Mit der Einengung auf den
Teilschnitt ist eine **andere** Quelle tragfähig geworden, die vorher zu grob war — die
Eigentümerzeilen der Bauaufgaben in §7a des Bauauftrags.

```
$ grep -nE '^\*\*Eigentümer' 03_N5_BAUAUFTRAG_v1.1_260807.md
418:**Eigentümer:** Auftragnehmer, Abnahme mit A. Han     · L1
449:**Eigentümer:** Auftragnehmer                          · L2
470:**Eigentümer:** Auftragnehmer                          · L3
507:**Eigentümer:** Auftragnehmer, fachliche Freigabe M. Veil · L4
537:**Eigentümer:** Auftragnehmer                          · L5
566:**Eigentümer:** Auftragnehmer, Abnahme A. Han          · L6
598:**Eigentümer:** Auftragnehmer                          · L7
624:**Eigentümer:** A. Han mit rechtlicher Beratung        · L8
648:**Eigentümer — drei verschiedene, ausdrücklich getrennt** · L9
```

**Acht von neun Bauaufgaben gehören dem Auftragnehmer.** Das ist keine Auslegung, das
steht dort. Die Regel des Vorschlags lautet deshalb:

> **Fachlicher Eigentümer ist der Auftragnehmer (Nr. 158), vertreten durch A. Han — außer
> wo der Auftrag ausdrücklich einen anderen für die fachliche Seite benennt.**

**Die zwei Ausnahmen, je mit ihrer Fundstelle:**

| Konzept | Vorgeschlagen | Woher |
|---|---|---|
| **K17** · Agenten-Betriebskonzept | **M. Veil** | §7a, L4 (Agentenmanifest): *„Eigentümer: Auftragnehmer, **fachliche Freigabe M. Veil**."* K17 ist das Konzept hinter L4. Wo der Auftrag die fachliche Seite ausdrücklich abtrennt, folgt der Vorschlag ihm |
| **K15** · Datenschutz- und Löschkonzept | **M. Veil** | Nicht aus §7a, sondern aus einer **Entscheidung desselben Tages**: `RR-02` (Löschkette, Weg A) trägt M. Veil als Träger. Wer den Vorrang zwischen Protokoll und Löschregel entscheidet, ist der fachliche Eigentümer der Löschregeln |

### Was der Vorschlag ausdrücklich **nicht** behauptet

- **Er behauptet nicht, dass A. Han zugestimmt hat.** Er leitet aus dem Auftragstext ab,
  wem die Sache gehört. **A. Han zeichnet unten selbst** oder widerspricht.
- **Er behauptet nicht, dass „Auftragnehmer" ein Mensch ist.** `K23-M02` verlangt einen
  **fachlichen Eigentümer**, und ein Abnahmekriterium schreibt keine Firma, sondern eine
  Person. Der Klammerzusatz *(A. Han)* benennt die Person, die für den Auftragnehmer
  zeichnet (Nr. 158) — **das ist der Punkt, an dem A. Han widersprechen kann und soll**,
  wenn eine andere Person es liefern soll.
- **Er verteilt nichts nach Gefühl.** Es gibt keine Zeile, hinter der nicht entweder eine
  Fundstelle oder eine Entscheidung dieses Tages steht.

---

## Was der Eigentümer schuldet — damit die Zeichnung nicht unterschätzt wird

`K23-M02` im Wortlaut:

> „Fehlt das Akzeptanzkriterium, liefert es der **in derselben Zeile eingetragene fachliche
> Eigentümer** nach; bis dahin bleibt der Bauauftrag unvollständig."

**Wer hier zeichnet, sagt zu: für jede Klausel seines Konzepts im Ausschnitt ein
Abnahmekriterium zu liefern** — also den Satz, an dem man misst, ob die Regel erfüllt ist.

| Wer | Konzepte | **Klauseln** | davon **sperrend** |
|---|---:|---:|---:|
| **Auftragnehmer / A. Han** *(Vorschlag)* | 18 | **154** | **110** |
| **M. Veil** *(Vorschlag)* | 2 — K15, K17 | **3** | **3** |

> **Die Last ist einseitig, und das gehört gesagt.** 154 von 157 lägen bei A. Han. Das
> folgt aus §7a — dort gehören acht von neun Bauaufgaben dem Auftragnehmer — aber es ist
> eine erhebliche Zusage. **Wenn das nicht gewollt ist, ist hier der Ort, es zu ändern**,
> nicht später beim Liefertor.

**Und die Reihenfolge, die den Aufwand erträglich macht:** Drei Konzepte — **K02** (33),
**K03** (31), **K20** (21) — tragen **85 der 157** Klauseln und **52 der 113** sperrenden.
Wer dort anfängt, hat nach drei Konzepten mehr als die Hälfte.

---

## Wie die Namen ins Register kommen

Über `nachweise/klauselregister/pflege.json` — die Pflegeliste, die seit dem 16.08.2026
wieder vorliegt. **Ein Werkzeugwechsel ist nicht nötig**, und keine Zeile wird von Hand in
`register.json` geschrieben: Das Register ist eine erzeugte Sicht, kein gepflegtes
Dokument (Blatt 26:59–63).

```
$ python3 werkzeuge/klauselregister.py     # liest pflege.json, erzeugt register.json neu
```

**Erst nach diesem Lauf trägt Bedingung 4 des Liefertors** — vorher steht die Zuordnung
nur auf diesem Blatt.

---

## Zeichnung

*Der Harness trägt nur ein, was angewiesen wurde.*

### Die Einengung — **gezeichnet**

- [x] **Nur die Klauseln des Teilschnitts bekommen einen fachlichen Eigentümer.** Die
      übrigen 1074 Klauseln in K09, K18, K21 und in den nicht berührten Teilen der 20
      Konzepte bleiben **ausdrücklich ohne Eigentümer**, bis ihr Umfang an der Reihe ist.
      **gez. M. Veil, 16.08.2026** · Weisung im Wortlaut: *„Nur für die 167 des
      Teilschnitts. Nur die Regeln, die zum Weg bis zur Anmeldung gehören, bekommen einen
      Verantwortlichen. Die übrigen bleiben leer, bis sie an der Reihe sind. Kleinster
      Aufwand, und es reicht für die Abnahme am 31.08."*

> **Eine Folge, die mitgezeichnet ist:** Wird der Umfang später wieder verbreitert, fehlen
> für den neuen Umfang die Eigentümer, und `K23-M02` schlägt dort erneut an. Das ist kein
> Einwand gegen die Entscheidung — es ist ihr Preis, und er ist hiermit benannt.

### Die Namen — **offen, hier wird gezeichnet**

- [ ] **Der Vorschlag oben gilt.** Fachlicher Eigentümer ist der Auftragnehmer (Nr. 158),
      vertreten durch **A. Han**, außer bei K15 und K17 — dort **M. Veil**.
- [ ] **Abweichend:** ⟨Konzept → Name, je Zeile⟩
- [ ] **Eine andere Person zeichnet für den Auftragnehmer:** ⟨Name⟩

| Name | Rolle | Datum | Anmerkung |
|---|---|---|---|
| **M. Veil** | Auftraggeber | **16.08.2026** | **nur die Einengung** — die Namensspalte ist damit nicht gezeichnet |
| **A. Han** | für den Auftragnehmer (Nr. 158) | | **erforderlich** — 154 der 157 Klauseln lägen bei ihm |

---

*Fassung 2, 16.08.2026, vom Coding-Harness. Alle Zahlen an diesem Tag erhoben aus
`S1_wortmarken.json`, `S1_bauspur_nachpruefung.md`, `restrisiken_teilschnitt.json` und
`register.json`; die Befehle stehen im Text. **Die Namen sind ein abgeleiteter Vorschlag
und keine Zuordnung** — sie werden es erst mit der Zeichnung im vorstehenden Block.*
