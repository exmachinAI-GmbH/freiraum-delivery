# Entscheidungsvorlage · Sieben Prüffälle rufen eine Funktion, die es nicht mehr gibt

**Sie waren grün — aber nur, weil eine Umgehung offen stand.**

| | |
|---|---|
| **An** | M. Veil (Auftraggeber) · A. Han (für den Auftragnehmer) |
| **Von** | Orchestrator des Coding-Harness |
| **Art** | **Vorlage. Keine Entscheidung.** |
| **Vorgelegt** | 16.08.2026 |
| **Anlass** | Der Bau von M4 hat eine offene Umgehung geschlossen. Dadurch ist sichtbar geworden, dass sieben Prüffälle **an dieser Umgehung** bestanden haben |

---

## Worum es geht, ohne Fachwort

Eine Anwendung darf nur auf **einem** Weg entstehen: über einen benannten Serverbefehl, der
vorher fünf Dinge prüft. Ein direkter Eintrag in die Tabelle ist verboten — das ist der Kern
des Meilensteins M4.

Diesen Serverbefehl gab es bis heute in **zwei** Fassungen:

| Fassung | Wie sie die Projektnummer behandelt |
|---|---|
| **alt**, fünf Werte | nimmt die Projektnummer **entgegen** — der Aufrufer bestimmt sie |
| **neu**, vier Werte | **vergibt** die Projektnummer selbst |

Die alte Fassung widerspricht einer gezeichneten Regel. **K01-M38:** *„Die Projektnummer MUSS
der serverseitige Befehl bilden … Sie wird vergeben, nicht eingegeben."*

Der Bau hat die alte Fassung deshalb entfernt.

---

## Was dabei sichtbar wurde

**Die alte Fassung war bereits entrechtet** — die Portalrolle durfte sie nicht mehr aufrufen.
Aber der **Eigentümer** der Datenbank durfte es weiterhin. Und die Anwendung verbindet sich
als eben dieser Eigentümer.

**Die Umgehung war also offen, nicht theoretisch.** Wer sie benutzte, kam an der Regel vorbei.

Sieben Prüffälle haben genau diese Fassung aufgerufen und waren deshalb grün:

| | Was der Fall misst |
|---|---|
| **MT-95** | Der eine erlaubte Weg legt eine Anwendung an |
| **MT-95b** | Auch unter der Portalrolle gelingt der Aufruf — der Fall, der die **offene** Tür misst |
| **MT-98** | Ein Konto eines fremden Mandanten wird abgewiesen |
| **ZB-20 bis ZB-23** | Vier Fälle des Zweckbestimmungs-Fadens |

**Sie waren vorher nicht grün, weil der Bau richtig war** — sie waren grün, weil die Umgehung
offen war. Das ist kein Rückschritt, sondern **neu sichtbares Rot**.

> **Warum das überhaupt auffiel:** Der Bau hat die Umgehung geschlossen, ohne zu wissen,
> welche Prüffälle darauf standen — er darf sie nicht sehen. Die Messung hat es danach
> gefunden. Ohne die getrennten Rollen wäre die Umgehung geschlossen und die sieben Fälle
> stillschweigend angepasst worden.

---

## Die drei Wege

### Weg A · Die Prüffälle auf die neue Fassung nachziehen

Die sieben Fälle rufen künftig die Vierwert-Fassung auf und übergeben keine Projektnummer
mehr.

| | |
|---|---|
| **Dafür** | Die Prüffälle messen dann das, was gebaut ist und was die Regel verlangt. Die Umgehung bleibt geschlossen |
| **Dagegen** | Es ändert Prüffälle, nachdem der Bau sich geändert hat. **Genau das ist der Vorgang, den dieses Projekt fürchtet** — die Prüfung folgt sonst dem Bau statt der Regel. Es braucht hier eine ausdrückliche Feststellung, dass die Änderung von der **Klausel** getragen ist, nicht vom Bau |

### Weg B · Die alte Fassung zurückholen

Beide Fassungen bestehen nebeneinander; die Prüffälle bleiben, wie sie sind.

| | |
|---|---|
| **Dafür** | Kein Prüffall wird angefasst. Die Zahlen sind sofort wieder grün |
| **Dagegen** | **Die Umgehung ist wieder offen.** Der Kern von M4 lautet *„eine Anwendung entsteht nur über den einen Weg"* — mit zwei Fassungen sind es zwei Wege, und einer davon verstößt gegen K01-M38. Die Prüffälle wären grün, und die Regel wäre verletzt |

### Weg C · Nachziehen und den Vorgang benennen

Wie Weg A, aber die Änderung der Prüffälle wird **als eigener Vorgang gezeichnet**, mit der
Feststellung, worauf sie sich stützt: nicht auf den geänderten Bau, sondern auf K01-M38 und
K01-D19, die schon vorher galten.

| | |
|---|---|
| **Dafür** | Der Nachweis bleibt lesbar. Wer in einem Jahr fragt, warum ein Prüffall geändert wurde, findet die Antwort — und sie lautet *„weil die Klausel es so verlangt"*, nicht *„weil der Bau es so tut"* |
| **Dagegen** | Ein Vorgang mehr |

---

## Handlungsempfehlung des Orchestrators: **Weg C**

**Weg B scheidet aus.** Er macht die Prüfzahlen grün, indem er die Regel bricht. Der Kern von
M4 ist *„nur über den einen Weg"* — zwei Fassungen sind zwei Wege. Eine Umgehung
zurückzuholen, damit ein Prüffall besteht, ist der Fall, den `K23-D05` verbietet: *„Ein
Prüfwert DARF NICHT gesenkt werden, damit ein Lauf besteht."* Der Prüfwert wäre hier nicht
die Zahl, sondern die Regel selbst.

**Weg A ist sachlich richtig, aber unvollständig.** Prüffälle nach einer Bauänderung
anzupassen ist genau der Vorgang, an dem dieses Projekt am 02.08. und am 15.08. Prüffälle
verloren hat, die nichts mehr maßen. Die Änderung *ist* hier gerechtfertigt — aber das muss
dastehen, nicht mitgedacht werden.

**Weg C kostet einen Vorgang und rettet die Nachvollziehbarkeit.** Die Änderung stützt sich
auf zwei Klauseln, die **vor** dem Bau galten:

> **K01-M38:** „Die Projektnummer MUSS der serverseitige Befehl bilden, in derselben
> Transaktion … **Sie wird vergeben, nicht eingegeben.**"
>
> **K01-D19:** „Kein Bildschirm, kein Formular und kein Endpunkt DARF die Projektnummer zur
> Eingabe, Auswahl oder Änderung anbieten. **Ein dennoch mitgesendeter Wert wird verworfen.**"

Ein Prüffall, der eine Projektnummer übergibt, misst also einen Weg, den die Klausel
verbietet. Er war schon vor dem Bau falsch — er ist nur nie aufgefallen, weil die Umgehung
ihn trug.

**Die Auflage:** Die Änderung schreibt der **Prüf-Agent**, nicht der Bau — und er bekommt als
Begründung die **Klausel**, nicht den Bauvorschlag. Sonst ist die Trennung, die den Befund
überhaupt erst sichtbar gemacht hat, an dieser Stelle aufgegeben.

---

## Was von dieser Entscheidung abhängt

| | |
|---|---|
| **Der Prüflauf** | Solange die sieben Fälle rot sind, endet der Lauf rot — und keine Vorlage zur Freigabe ist möglich |
| **Die Nachrechnung von M4** | Sie verlangt MT-95 bis MT-98. Solange diese eine Funktion aufrufen, die es nicht gibt, ist M4 nicht nachrechenbar |
| **Der Nachweis** | Bei Weg B stünde im Nachweis, dass der eine Weg gemessen wurde — während es zwei gab |

---

## Zeichnung

*Dieser Block wird von Menschen ausgefüllt. Der Harness trägt hier nichts ein.*

- [ ] **Weg A** — Prüffälle nachziehen
- [ ] **Weg B** — alte Fassung zurückholen. **Bekannte Folge:** die Umgehung ist wieder offen
- [ ] **Weg C** — nachziehen und den Vorgang zeichnen ✅ *Empfehlung*
- [ ] **anders:** ⟨…⟩

**Bei Weg A oder C zusätzlich:**

- [ ] Die Änderung schreibt der **Prüf-Agent**, mit der Klausel als Begründung — nicht der Bau

| Name | Rolle | Datum | Anmerkung |
|---|---|---|---|
| **M. Veil** | Auftraggeber | | |
| **A. Han** | für den Auftragnehmer (Nr. 158) | | |

---

*Erstellt am 16.08.2026 vom Orchestrator des Coding-Harness. **Diese Vorlage entscheidet
nichts.***
