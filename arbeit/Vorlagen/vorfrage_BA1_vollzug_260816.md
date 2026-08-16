# Entscheidungsvorlage · Die Vorfrage zu BA-2 — **BA-1 ist nicht vollzogen**

**Ein Korrekturblatt wartet auf ein anderes. Das ist der einzige Grund, warum BA-2 heute
nicht vollzogen werden kann.**

| | |
|---|---|
| **An** | M. Veil (Auftraggeber) · A. Han (für den Auftragnehmer, Nr. 158) |
| **Von** | Orchestrator des Coding-Harness |
| **Art** | **Vorlage mit Handlungsempfehlungen. Keine Entscheidung.** |
| **Vorgelegt** | 16.08.2026 |
| **Betrifft** | `korrekturblatt_BA-2_termine_und_ausnahme_260816.md`, Kreuz **2.1-V** · Zweig `nachtraege/korrekturblatt-wega` |

---

## 1 · Der Befund in vier Befehlen

**Nicht behauptet, gemessen am 16.08.2026:**

```
$ ls arbeit/Vorlagen/korrekturblatt_BA-1*
zsh: no matches found                       # nicht im Arbeitsbaum

$ git branch -a --contains <BA-1-Commit>
nachtraege/korrekturblatt-wega
remotes/origin/nachtraege/korrekturblatt-wega   # ein Nebenzweig, nicht main

$ git show nachtraege/korrekturblatt-wega:arbeit/Vorlagen/korrekturblatt_BA-1_wegA_260815.md \
    | grep -c '\[x\]'
0                                           # kein einziges Kreuz gesetzt

$ grep -c 'BA-1' 03_N5_BAUAUFTRAG_v1.1_260807.md
0                                           # null Rueckverweise im Auftragstext
```

**Vier Messungen, ein Ergebnis.** BA-1 liegt ungezeichnet auf einem Nebenzweig, trägt kein
gesetztes Kreuz, seine Zeichnungstabelle ist leer, und im Auftragstext steht sein Name
nirgends. **Es ist nicht vollzogen** — und damit trifft der Sachverhalt von Kreuz **2.1-V2**
zu.

---

## 2 · Warum das BA-2 anhält

**BA-2 setzt Termine für zurückgestellte Meilensteine. Zurückgestellt sind sie aber nur auf
einem Blatt, das nicht vollzogen ist.**

```
Zeichnung Weg A (10.08.2026, beide Parteien)
        │  "Tor II umfasst den benannten Teilschnitt bis zur Anmeldung"
        ▼
   BA-1  ◀── traegt die Zurueckstellung in den Auftragstext
        │    STATUS: ungezeichnet, auf einem Nebenzweig
        ▼
   BA-2  ◀── setzt Termine fuer die Zurueckgestellten
             STATUS: gezeichnet (2.1-d, 2.2-a), aber nicht vollziehbar
```

**Der Auftragstext sagt heute unverändert an fünf Stellen, dass zum 31.08.2026 alle zwölf
Meilensteine eingetreten sind.** Ein Termin für etwas zu setzen, das dort noch gar nicht
zurückgestellt ist, wäre kein Vollzug, sondern **eine zweite Änderung im Gewand der ersten.**

> **Die Sachentscheidung von BA-2 ist davon nicht berührt.** M. Veil hat am 16.08.2026
> gezeichnet, wie die Termine gebildet werden. Diese Zeichnung bleibt gültig — sie wartet auf
> ihre Grundlage, nicht auf sich selbst.

---

## 3 · Was BA-1 offen hat — vier Kreuze, alle mit Empfehlung

**BA-1 ist kein leeres Blatt.** Es ist ausgefertigt, siebenfeldrig nach §12.2, mit 13
einzeln benannten Stellen und Ankerzitaten. Was fehlt, sind **vier Entscheidungen.**

### K1 · Wird die Zeichnung vom 10.08.2026 überhaupt vollzogen?

| | |
|---|---|
| ✅ **Empfehlung: Getragen** | *„Das ist kein neuer Entschluss, sondern die Ausführung eines fünf Tage alten. Ihn nicht auszuführen nützt niemandem."* |
| Alternative | **Nicht getragen** — dann verlangt Tor II weiterhin **alle zwölf** Meilensteine zum 31.08.2026. Nach eigener Messung ist das nicht erreichbar |

**Der Orchestrator schließt sich der Empfehlung an.** Beide Parteien haben Weg A am
10.08.2026 gezeichnet. Sechs Tage später trägt der Auftrag das Gegenteil. Das ist der
Zustand, den §12 verhindern soll.

### K1-b · Kommt M3 mit in den Umfang — und M4?

> **⚠ Hier hat sich seit dem 15.08.2026 etwas geändert, und es ändert die Empfehlung.**

Die Empfehlung in BA-1 lautet **„Nur M3 aufgenommen"**, begründet mit:

> *„M4 dagegen ist **nicht begonnen** — es aufzunehmen hieße, in sechzehn Tagen einen
> Meilenstein zu versprechen, der noch keinen Gegenstand hat."*

**Diese Begründung stimmt heute nicht mehr.** Gemessen am 16.08.2026:

| | Stand 15.08. | **Stand 16.08.** |
|---|---|---|
| `create_app_after_fit` mit Nummernvergabe | nicht begonnen | **gebaut** (M31) |
| Bildschirm **EN-04a** | nicht begonnen | **gebaut**, alle sechs Aktionen |
| Migrationsprüffälle | 0 von 111 mit Ergebnis | **111 von 111** |
| Meilenstein **M4** | ohne Gegenstand | **gebaut auf `scheibe/m4-zweckbestimmung`** |

**Trotzdem bleibt die Empfehlung „Nur M3 aufgenommen" — aus einem anderen Grund.**

M4 verlangt nach der Nachrechnung des Auftrags *„MT-95 bis MT-98 **gegen den
Zielbestand**"*. Der Bauauftrag unterscheidet den Zielbestand ausdrücklich von der
Prüfdatenbank. **Dieser Lauf hat nicht stattgefunden** — er ist eine menschlich ausgelöste
Handlung gegen die Zielumgebung. Ein grüner Lauf gegen die Prüfdatenbank belegt M4 **nicht**.

> **Die Empfehlung ist also dieselbe, ihre Begründung eine andere — und das gehört gesagt.**
> Am 15.08. lautete sie „M4 hat keinen Gegenstand". Heute lautet sie: **„M4 hat einen
> Gegenstand, aber keinen Nachweis gegen den Zielbestand."** Wer M4 aufnehmen will, muss
> diesen Lauf vorher fahren, nicht nachher.

| | |
|---|---|
| ✅ **Empfehlung: Nur M3 aufgenommen** | → Korrektur K1 **Fassung B**, Korrektur K6 mit den Starttoren 05, 11, 13, 15 |
| Möglich, wenn der Zielbestandslauf vorher gefahren wird | **M3 und M4 aufgenommen** → Fassung C |
| Möglich, aber verschenkt Gebautes | **Beide zurückgestellt** → Fassung A |

### K2 bis K6 · Werden auch die Bedingungen 2 bis 6 eingeengt?

| | |
|---|---|
| ✅ **Empfehlung: K2, K3, K4, K5 und K6 getragen** | *„Tor II hat sechs Bedingungen. Wird nur die erste eingeengt, bleibt Tor II trotzdem unerreichbar."* |

**Der Orchestrator schließt sich an, und benennt den Preis, den BA-1 selbst benennt:**
*„Das ist die unangenehmste Empfehlung dieses Blattes: sie macht Tor II sichtbar dünn. Aber
sie macht es wahr."*

**Ein Anschluss, der heute konkreter ist als am 15.08.:** Bedingung 4 verlangt ein
vollständiges Klauselregister. Am 15.08. stand es bei **0 von 1231**. Mit der Entscheidung
D-1 vom 16.08.2026 ist der Umfang auf **157 Klauseln** eingeengt — die Bedingung ist damit
zum ersten Mal erfüllbar. **Sie ist es aber erst, wenn die Eigentümernamen gezeichnet sind.**

### K3 · Wie werden die vier sperrenden Gates behandelt?

**Ohne eine dieser vier Entscheidungen erreicht der Teilschnitt die Unterschrift nicht** —
auch mit vollzogenem BA-1 nicht.

| Weg | Was er tut | Dauer | Löst er die Sperre? |
|---|---|---|---|
| **3-I** | Benannte Ausnahme im Auftrag, je als Restrisiko mit Träger | ein Tag | **nein** — Gates 11, 13, 14, 15 schlagen weiter an |
| **3-II** | Nachtrag zu K23 in der Konzept-Fabrik | **nicht gemessen** | ja — aber sperrt bis dahin jede Vorlage (§12.4 Nr. 5) |
| ✅ **3-III** | **Founder-Beschluss auf Rang 0**, nach dem Muster von F28 und F04 | überschaubar | **ja** — Rang 0 gewinnt gegen alles Weitere |
| **3-IV** | BA-1 ohne K3 und K4 zeichnen, Rest auf ein zweites Blatt | sofort | **nein** — nur verschoben |

✅ **Empfehlung: Weg 3-III.** *„Er ist der einzige Weg, der die Gates wirklich auflöst und in
der verbleibenden Zeit darstellbar ist."* Er ändert weder K23 noch erzeugt er einen
Widerspruch — er verlangt aber **einen eigenen gezeichneten Founder-Beschluss.**

> **Gate 11 bleibt gesondert.** Es hängt an den leeren Registerzeilen, nicht am Durchstich.
> Dafür ist Korrektur K4 der Weg — und die Entscheidung D-1 vom 16.08.2026 arbeitet ihm zu.

---

## 4 · Handlungsempfehlung des Orchestrators — die Reihenfolge

**Vier Blätter, und sie müssen in dieser Reihenfolge fallen. Jedes andere Vorgehen erzeugt
einen Vollzug ohne Grundlage.**

| | Was | Wer zeichnet | Warum in dieser Reihenfolge |
|---|---|---|---|
| **1** | **BA-1 zeichnen** — K1 *getragen* · K1-b *nur M3* · K2–K6 *getragen* · K3 *Weg 3-III* | **M. Veil und A. Han** (§12.3) | Es trägt die Zurückstellung überhaupt erst in den Auftragstext |
| **2** | **Founder-Beschluss zu Weg 3-III** — nimmt Durchstich, Modul- und Lastprüfung für **diese eine** Abnahme aus dem Umfang | **M. Veil** | K3 verlangt ihn ausdrücklich; ohne ihn ist BA-1 an dieser Stelle unvollzogen |
| **3** | **BA-1 vollziehen** — 13 Stellen, von unten nach oben, je mit Rückverweis | Orchestrator, auf Weisung | *Teilvollzug ist Nichtvollzug* (§12.4 Nr. 4) |
| **4** | **BA-2 vollziehen** — 7 + 5 Stellen, Fassung D | Orchestrator, auf Weisung | Erst jetzt hat es eine Grundlage |

**Danach, und erst danach:** neue Fassung **v1.2**, einfrieren, Prüfsumme in die
Zeichnungsdatei, Durchstich gegen die neue Prüfsumme (§12.5, §12.6, K23-M20).

> **Was das kostet, offen gesagt:** BA-1 und BA-2 zusammen sind **20 einzelne Stellen** im
> Auftragstext, dazu ein Founder-Beschluss und ein neuer Durchstich. Das ist keine
> Formalie — es ist ein halber Arbeitstag, und er fällt **vor** dem 31.08. an, nicht danach.

---

## 5 · Was geschieht, wenn es offen bleibt

**Der Auftrag und die Wirklichkeit driften weiter auseinander, und zwar nachweisbar:**

| | Der Auftrag sagt | Gemessen gilt |
|---|---|---|
| 1 | Zum 31.08.2026 sind **alle zwölf** Meilensteine eingetreten | Weg A hat neun zurückgestellt — gezeichnet am 10.08.2026 |
| 2 | `nummernvorrat` ist vom Zeilenschutz ausgenommen | L1-E5/A hat die Ausnahme am 10.08.2026 aufgehoben |
| 3 | Bedingung 6 nennt fünf Starttore | Starttor 14 hat keinen Nachweis (Befund ST-14) |

**Drei gezeichnete Entscheidungen, die im Auftragstext nicht angekommen sind.** Jede einzelne
für sich ist ein Vermerk. Zusammen sind sie der Zustand, den §12.4 Nr. 5 mit
*„keine Vorlage zur Freigabe"* belegt.

**Und die Frist ist real:** Ein Korrekturblatt, das am 30.08. gezeichnet wird, erzeugt eine
neue Prüfsumme — und **jeder Durchstich gegen die alte gilt damit als veraltet** (§12.6).
Wer BA-1 spät zeichnet, wirft die Nachweise weg, die bis dahin entstanden sind.

---

## 6 · Zeichnung

*Der Harness trägt nur ein, was angewiesen wurde. **Dieses Blatt entscheidet nichts.***

- [ ] **Der Reihenfolge aus Abschnitt 4 wird gefolgt**, mit den vier Empfehlungen zu BA-1:
      K1 *getragen* · K1-b *nur M3* · K2–K6 *getragen* · K3 *Weg 3-III*
- [ ] **Abweichend bei:** ⟨Kreuz und gewählte Möglichkeit⟩
- [ ] **BA-1 wird nicht vollzogen.** Dann bleibt BA-2 liegen, und die drei Abweichungen aus
      Abschnitt 5 werden als benannte Befunde geführt statt behoben

| Name | Rolle | Datum | Anmerkung |
|---|---|---|---|
| **M. Veil** | Auftraggeber | | |
| **A. Han** | für den Auftragnehmer (Nr. 158) | | **erforderlich** — §12.3 verlangt beide Unterschriften |

---

*Erstellt am 16.08.2026 vom Orchestrator des Coding-Harness. Alle vier Messungen in
Abschnitt 1 sind an diesem Tag gefahren; die Befehle stehen daneben. Die Empfehlungen zu K1,
K2–K6 und K3 sind die von BA-1 selbst; **die Begründung zu K1-b ist berichtigt**, weil M4
seit dem 15.08.2026 gebaut ist — die Empfehlung bleibt, ihr Grund ist ein anderer.*
