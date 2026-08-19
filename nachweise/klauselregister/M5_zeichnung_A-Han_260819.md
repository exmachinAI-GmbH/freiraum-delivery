# M5 · Die Akzeptanzkriterien zur Durchsicht — **A. Han, 95 Klauseln**

| | |
|---|---|
| **Zu zeichnen von** | **A. Han** für den Auftragnehmer — Zuweisung gez. 19.08.2026 |
| **Umfang** | **95** der 101 M5-Klauseln. Die übrigen **6** gehören K17 und liegen bei M. Veil |
| **Grundlage** | `K23-M02` · Blatt 100, Entscheidung 5: *Akzeptanzkriterien werden **vor** dem Bauzug gezeichnet* |
| **Was eine Zeichnung heißt** | Der Maßstab, an dem der Bau später gemessen wird, steht fest — und der blinde Prüf-Agent schreibt seine Prüffälle dagegen. **Nicht** gezeichnet wird damit, dass der Bau ihn erfüllt |
| **Was sie nicht heißt** | Keine Abnahme, keine Freigabe, kein Urteil über Code. Es gibt noch keinen |

> **Wie Sie das in einer Stunde durchsehen.** Je Eintrag genügt der Vergleich zweier Zeilen:
> der **Klauselwortlaut** oben und die Zeile **ERFUELLT WENN**. Stimmen sie überein, ist der
> Rest Prüffallmechanik. Die Zeile **GEMESSEN DURCH** ist der Bauplan des Prüffalls; sie
> interessiert nur, wenn Sie am Positiv- oder Negativfall zweifeln.
>
> **Wo Sie genau hinsehen sollten:** überall dort, wo der Vermerk *Gegenprobe: **ersetzt***
> steht — dort hat der erste Vorschlag einen Mangel getragen, und der Ersatztext ist der
> zweite Versuch. Bei *erfunden* hatte der erste Vorschlag eine Zahl oder Bedingung genannt,
> die im Wortlaut nicht steht.
>
> **Die Zeilenumbrüche in den Kästen sind zur Lesbarkeit gesetzt.** Maßgeblich ist der
> Eintrag in `pflege.json`; dort steht die Zelle als ein Satzblock.

---

## Die drei Teile

| Teil | Was | Zahl | Was zu tun ist |
|---|---|---:|---|
| **1** | Kriterien **ohne Maßstab** (*NICHT ABLEITBAR*) | **5** | **keine Unterschrift** — hier fehlt eine Angabe, die nur der Eigentümer liefern kann |
| **2** | Bestandskriterien vom 16.08., **für M5 zu eng** | **4** | **zwei Teile zeichnen**: der alte Eintrag bleibt, die Ergänzung kommt hinzu |
| **3** | Der Rest, nach Konzept | **86** | durchsehen und zeichnen |

---

## Teil 1 · Fünf Klauseln ohne Maßstab — hier hilft keine Unterschrift

Der Vorschlag sagt in diesen Fällen ausdrücklich, **was fehlt und wer es festlegen muss**.
Ein Kriterium daraufhin zu erfinden, wäre genau der Mangel, an dem die Gegenprobe 14
Vorschläge gekippt hat.

---

### K05-D03 · DARF NICHT

> Ein Eintrag der rechten Spalte DARF NICHT stillschweigend durch eine Formulierung des Assistenten ersetzt werden. Eine Änderung ist sichtbar oder sie findet nicht statt.

*Konzept K05, Zeile 79 · Gegenprobe: **ersetzt · nicht_messbar***

**Vorgeschlagenes Kriterium**

```
⟨VORSCHLAG · NICHT GEZEICHNET⟩
NICHT ABLEITBAR: Der Wortlaut verlangt, dass eine Ersetzung eines Eintrags der rechten Spalte
  durch eine Formulierung des Assistenten sichtbar ist oder unterbleibt; er sagt nicht, woran
  Sichtbarkeit beobachtbar ist — keine Marke, kein Hinweis, kein Vergleichsstand ist genannt.
  Der Bildschirmvertrag fuehrt fuer EN-05 und EN-06 keine Aktion, keinen Serverbefehl und keinen
  Zustand, in dem der Assistent einen bestehenden Eintrag umformuliert. Ohne diese Festlegung
  ist weder der Positivfall abgrenzbar (jede beliebige Anzeige koennte als sichtbare Aenderung
  gelten) noch ein Negativfall aufbaubar (die Ersetzung laesst sich nicht herbeifuehren, ohne
  sie zugleich zu unterstellen). Der fachliche Eigentuemer muss festlegen: (a) woran eine
  Aenderung an einem bestehenden Eintrag sichtbar gemacht wird — Anzeige am Eintrag selbst,
  getrennte Angabe von Ursprung und Bearbeitungszustand nach K19-G09, oder Fassungsvergleich mit
  Anzeige der Vorfassung; (b) ueber welchen Serverbefehl und in welchem Zustand von EN-06 eine
  solche Ersetzung ueberhaupt stattfinden darf; (c) welcher festgehaltene Ausgangswortlaut als
  Vergleichsstand gilt und wann er festgehalten wird. Erst danach ist ein Prueffall mit eigenem
  Negativfall schreibbar.
· Quelle: „Ein Eintrag der rechten Spalte DARF NICHT stillschweigend durch eine Formulierung des
  Assistenten ersetzt werden. Eine Änderung ist sichtbar oder sie findet nicht statt."
· K23-M02: das Akzeptanzkriterium liefert der fachliche Eigentuemer — dieser Vorschlag nimmt ihm
  die Schreibarbeit ab, nicht die Entscheidung.
⟨zeichnet: ⟩ ⟨am: ⟩
```

`☐ gezeichnet   ☐ geändert (Wortlaut unten)   ☐ zurück an den Harness`

---

### K05-G12 · GILT

> Es GILT: Solange O-K05-1 und O-K05-2 offen sind, bleibt K05 Freigabekandidat. Für Gesprächsinhalt und Herkunftsmarke fehlt der belegte Träger; der Produktivweg bleibt gesperrt. Der Stimmweg ist zusätzlich durch K05-D12 gesperrt, bis ein bewerteter Fall vorliegt (F31).

*Konzept K05, Zeile 105 · Gegenprobe: **ersetzt · nicht_messbar***

**Vorgeschlagenes Kriterium**

```
⟨VORSCHLAG · NICHT GEZEICHNET⟩
NICHT ABLEITBAR: Der Wortlaut nennt drei Sperren, aber fuer keine ein beobachtbares Merkmal. (1)
  „bleibt K05 Freigabekandidat" — wo der Freigabestand eines Konzepts gefuehrt wird und welcher
  Wert Freigabekandidat bedeutet, sagen weder der Klauselwortlaut noch der Bildschirmvertrag;
  das Klauselregister fuehrt zu K05 allein „dokumentversion: v1.3 · Freigegeben", eine andere
  Wortmarke, an der die Klausel nicht ohne Auslegung gemessen werden kann. (2) „der Produktivweg
  bleibt gesperrt" — der Bildschirmvertrag kennt weder einen Produktivweg noch eine Sperre;
  welcher Aufruf gesperrt ist, woran die Sperre erkennbar wird und mit welcher Meldung sie
  abweist, ist nirgends gezeichnet. (3) „Der Stimmweg ist zusätzlich durch K05-D12 gesperrt, bis
  ein bewerteter Fall vorliegt (F31)" — welcher der gezeichneten Wege der Stimmweg ist und was
  ein bewerteter Fall nach F31 ist, bestimmt der Wortlaut nicht. Der fachliche Eigentuemer muss
  festlegen: den Ort und den Wert des Freigabestands (Freigabekandidat gegen freigegeben); den
  beobachtbaren Aufruf, an dem die Sperre des Produktivwegs sichtbar wird, samt erwarteter
  Meldung im Wortlaut; die Zuordnung des Stimmwegs zu einer Aktion des Bildschirmvertrags und
  das Merkmal eines bewerteten Falls nach F31. Erst dann ist ein Prueffall mit Positiv- und
  Negativfall schreibbar.
· Erzeugt am 19.08.2026 zu Blatt 100, Entscheidung 5. K23-M02: das Abnahmekriterium liefert der
  fachliche Eigentuemer — dieser Vorschlag nimmt ihm die Schreibarbeit ab, nicht die
  Entscheidung.
⟨zeichnet: ⟩ ⟨am: ⟩
```

`☐ gezeichnet   ☐ geändert (Wortlaut unten)   ☐ zurück an den Harness`

---

### K05-M20 · MUSS

> Der Stimmweg MUSS zwei getrennte Bedienungen führen: Das Mikrofon diktiert in das Eingabefeld, *Sprechen* führt das Gespräch freihändig.

*Konzept K05, Zeile 67 · Gegenprobe: **ersetzt · nicht_messbar***

**Vorgeschlagenes Kriterium**

```
⟨VORSCHLAG · NICHT GEZEICHNET⟩
NICHT ABLEITBAR: Der Wortlaut verlangt zwei getrennte Bedienungen, von denen die zweite —
  *Sprechen*, das freihaendige Gespraech — nach K05-M30 in Release 1 ausgeblendet und
  serverseitig gesperrt ist; der Bildschirmvertrag EN-05/EN-06 fuehrt fuer sie weder eine Aktion
  noch einen Serverbefehl. Ob die beiden Bedienungen getrennt sind, ist an der gebauten Stufe
  deshalb nicht beobachtbar, und ein Negativfall (eine einzige Bedienung leistet beides) laesst
  sich nicht herstellen, solange die zweite Bedienung nicht existiert. Der fachliche Eigentuemer
  muss festlegen: ob K05-M20 mit dem freihaendigen Weg zurueckgestellt wird — dann mit einem
  ausdruecklichen Zusatz wie bei K05-M29 — oder ob fuer Release 1 allein die Mikrofon-Bedienung
  gemessen wird; im zweiten Fall zusaetzlich, an welchem Merkmal ausser dem bereits von K05-M21
  gemessenen (diktierter Text steht vor dem Senden sichtbar und aenderbar im Eingabefeld) die
  Trennung von der nicht vorhandenen zweiten Bedienung nachgewiesen werden soll. ·
⟨zeichnet: ⟩ ⟨am: ⟩
```

`☐ gezeichnet   ☐ geändert (Wortlaut unten)   ☐ zurück an den Harness`

---

### K05-M24 · MUSS

> Jeder Aufruf aus den Stufen 01 und 02 MUSS über den Serverpfad laufen, der Konto, Mitgliedschaft, Rolle, Mandant und Objektbezug prüft (K13 Abschn. 3).

*Konzept K05, Zeile 71 · Vorschlag vom 16.08.2026 · für M5 zu eng*

**Vorgeschlagenes Kriterium**

```
⟨VORSCHLAG · NICHT GEZEICHNET⟩
NICHT ABLEITBAR aus dem Klauselwortlaut. Der fachliche Eigentuemer liefert nach: Die
  Rollenmatrix: welche Rolle je Aufruf der Stufen 01 und 02 mindestens ausreicht. Ohne sie
  laesst sich kein Negativfall bauen, der allein an der Rolle scheitert und nicht schon an
  Mitgliedschaft, Mandant oder Objektbezug - genau das verlangt die Klausel aber als eigene
  Pruefdimension. Die vier uebrigen Pruefungen (Konto, Mitgliedschaft, Mandant, Objektbezug)
  waeren fuer sich messbar; ableitbar wird die Klausel, sobald der fachliche Eigentuemer je
  Aufruf die ausreichende Rolle benennt.
· Erzeugt am 16.08.2026 auf Weisung E-6 (gez. M. Veil und A. Han). K23-M02: das Abnahmekriterium
  liefert der fachliche Eigentuemer — dieser Vorschlag nimmt ihm die Schreibarbeit ab, nicht die
  Entscheidung.
⟨zeichnet: ⟩ ⟨am: ⟩
```

**Ergänzung für M5** — der Eintrag oben bleibt stehen, dies kommt hinzu:

```
⟨VORSCHLAG · NICHT GEZEICHNET⟩
ERGAENZUNG (kein Ersatz) zum Eintrag vom 16.08.2026; die Rollendimension bleibt offen, bis der
  Eigentuemer die Rollenmatrix nachliefert.
ERFUELLT WENN: Fuer die vier ohne Rollenmatrix messbaren Pruefungen - aktives Konto,
  Mitgliedschaft, Mandant, Objektbezug - gilt an jedem Aufruf der Stufen 01 und 02: liegt eine
  davon nicht vor, wird weder gelesen noch geschrieben; es entsteht keine document-Zeile und
  kein event-Eintrag, und der vorhandene Stand bleibt unveraendert.
GEMESSEN DURCH: Aufbau: gespeicherter Gespraechsstand bei Mandant A. Positivfall: eine gueltige
  Sitzung von A ruft nacheinander die Serverbefehle der Stufen 01 und 02 auf dem eigenen Stand
  auf - jeder Aufruf geht durch, Zustand Erfolg. Negativfall, je Aufruf einzeln und bei sonst
  gueltigen Angaben: (a) ohne aktives Konto, also aus der abgemeldeten oder abgelaufenen Sitzung
  heraus; (b) mit aktivem Konto ohne Mitgliedschaft im Mandanten des Standes; (c) mit gueltiger
  Mitgliedschaft in einem anderen Mandanten; (d) mit gueltiger Sitzung, aber der Kennung eines
  fremden Standes. Nach jedem Fall Datenbestand lesen. NICHT ERFUELLT: ein Negativfall liefert
  Daten oder hinterlaesst eine neue oder geaenderte document-Zeile oder einen event-Eintrag;
  oder ein Negativfall scheitert erkennbar an einer anderen Bedingung als der geprueften (etwa
  (b) an einer fehlenden Rolle) - dann misst er nichts. Den Wortlaut der Abweisung legt die
  Klausel nicht fest; er ist vom Eigentuemer nachzutragen.
· Quelle: 'Jeder Aufruf aus den Stufen 01 und 02 MUSS ueber den Serverpfad laufen, der Konto,
  Mitgliedschaft, Rolle, Mandant und Objektbezug prueft' (K05-M24); Berechtigungszeilen von
  EN-05 und EN-06 ·
⟨zeichnet: ⟩ ⟨am: ⟩
```

`☐ gezeichnet   ☐ geändert (Wortlaut unten)   ☐ zurück an den Harness`

---

### K05-M27 · MUSS

> RLS und Serverpfad leiten den Mandanten ausschließlich über `document.app_id → app.tenant_id` ab. Dateiobjekte verwenden nicht erratbare Schlüssel und sind nur über kurzlebige, serverseitig autorisierte Zugriffe erreichbar. Zwei-Mandanten- und Zwei-Anwendungs-Negativtests sind Produktionsgate.

*Konzept K05, Zeile 330 · Vorschlag vom 16.08.2026 · für M5 zu eng*

**Vorgeschlagenes Kriterium**

```
⟨VORSCHLAG · NICHT GEZEICHNET⟩
NICHT ABLEITBAR aus dem Klauselwortlaut. Der fachliche Eigentuemer liefert nach: Zwei
  Zahlenwerte: (1) die Hoechstgueltigkeit eines Zugriffs auf ein Dateiobjekt - 'kurzlebig' in
  Sekunden oder Minuten; (2) das Mindestmass fuer 'nicht erratbar' - Schluessellaenge bzw.
  Entropie. Ohne (1) ist kein Ablauftest entscheidbar, ohne (2) kein Ratetest. Die
  Mandantenableitung ausschliesslich ueber document.app_id -> app.tenant_id und die Zwei-
  Mandanten- sowie Zwei-Anwendungs-Negativtests waeren fuer sich messbar.
· Erzeugt am 16.08.2026 auf Weisung E-6 (gez. M. Veil und A. Han). K23-M02: das Abnahmekriterium
  liefert der fachliche Eigentuemer — dieser Vorschlag nimmt ihm die Schreibarbeit ab, nicht die
  Entscheidung.
⟨zeichnet: ⟩ ⟨am: ⟩
```

**Ergänzung für M5** — der Eintrag oben bleibt stehen, dies kommt hinzu:

```
⟨VORSCHLAG · NICHT GEZEICHNET⟩
ERGAENZUNG (kein Ersatz) zum Eintrag vom 16.08.2026; die Anforderungen an Dateiobjekte (nicht
  erratbare Schluessel, kurzlebige Zugriffe) bleiben mangels der beiden Zahlenwerte unmessbar
  und betreffen datei_anhaengen
· Stufe: zurueckgestellt (Blatt 100, E4).
ERFUELLT WENN: Der Mandant des Gespraechsstands wird im Serverpfad wie in der Policy
  ausschliesslich ueber document.app_id -> app.tenant_id abgeleitet: eine am Datensatz
  mitgefuehrte oder aus der Sitzung uebernommene Mandantenangabe entscheidet nie, und Zwei-
  Mandanten- wie Zwei-Anwendungs-Negativtest sind bestanden.
GEMESSEN DURCH: Aufbau: Mandant A mit zwei Anwendungen A1 und A2, Mandant B mit einer Anwendung;
  je ein gespeicherter Gespraechsstand (EN-06 · zwischenspeichern · Zustand Erfolg).
  Positivfall: eine Sitzung von A liest den Stand von A1 ueber den Serverpfad und ueber
  unmittelbare Abfrage - die document-Zeile ist da. Negativfall Zwei-Mandanten: Sitzung und
  Mandantenkontext von B auf den Stand von A1, auf beiden Wegen - keine Zeile. Negativfall Zwei-
  Anwendungen: Sitzung von A liest mit dem Objektbezug von A2 den Stand von A1 - keine Zeile.
  Gegenprobe zur Ausschliesslichkeit: wird app.tenant_id der zugehoerigen Anwendung auf einen
  anderen Mandanten gesetzt, ist die document-Zeile fuer die Sitzung von A nicht mehr lesbar.
  NICHT ERFUELLT: einer der beiden Negativfaelle liefert die Zeile; oder die Zeile bleibt nach
  der Gegenprobe lesbar - dann stammt der Mandant nicht aus app.tenant_id. Anmeldung,
  Mandantenkontext und Schluessel sind in allen Faellen gueltig, damit sie allein an der
  Ableitung scheitern.
· Quelle: 'RLS und Serverpfad leiten den Mandanten ausschliesslich ueber document.app_id ->
  app.tenant_id ab' und 'Zwei-Mandanten- und Zwei-Anwendungs-Negativtests sind Produktionsgate'
  (K05-M27) ·
⟨zeichnet: ⟩ ⟨am: ⟩
```

`☐ gezeichnet   ☐ geändert (Wortlaut unten)   ☐ zurück an den Harness`

---

## Teil 2 · Bestandskriterien, die für M5 zu eng sind

Diese Klauseln trugen schon am 16.08.2026 einen Vorschlag — geschrieben für den
**Teilschnitt bis zur Anmeldung**. Für M5 misst er zu wenig. **Überschrieben wurde
nichts**: der alte Eintrag steht, die Ergänzung kommt daneben.

---

### K01-M15 · MUSS

> Jeder Lese- und Schreibzugriff MUSS auf den Mandanten der angemeldeten Sitzung eingeschränkt sein. Ein Objekt eines fremden Mandanten gilt als nicht vorhanden (Mandantenschnitt K02).

*Konzept K01, Zeile 65 · Vorschlag vom 16.08.2026 · für M5 zu eng*

**Vorgeschlagenes Kriterium**

```
⟨VORSCHLAG · NICHT GEZEICHNET⟩
ERFUELLT WENN: Lesen und Schreiben erreichen nur Objekte, deren Mandant der Mandant der
  angemeldeten Sitzung ist; auf ein Objekt eines fremden Mandanten antwortet das System genau so
  wie auf ein nirgends vergebenes Objekt - gleiche Antwort, kein Hinweis darauf, dass es das
  Objekt gibt.
GEMESSEN DURCH: Prueffall gegen Datenbank und Bildschirm. Eine Sitzung von Mandant A ruft
  denselben Lese-Weg dreimal auf: mit der Kennung eines eigenen Objekts, mit der Kennung eines
  echten Objekts von Mandant B, mit einer gueltig aufgebauten, aber nirgends vergebenen Kennung.
  Die Antworten auf Fall 2 und Fall 3 werden verglichen (Statuscode und Text). Derselbe Aufbau
  fuer einen schreibenden Weg, danach Vergleich der Zeile von B vorher/nachher.
NICHT ERFUELLT: Fall 2 liefert Daten oder aendert die Zeile von B; oder Fall 2 antwortet anders
  als Fall 3 (etwa 'kein Zugriff' statt 'nicht vorhanden') - dann ist die Existenz des fremden
  Objekts verraten. Die Kennung in Fall 2 muss eine echte, formal gueltige Kennung sein;
  scheitert der Fall an ihrer Form, misst er nichts.
· Erzeugt am 16.08.2026 auf Weisung E-6 (gez. M. Veil und A. Han). K23-M02: das Abnahmekriterium
  liefert der fachliche Eigentuemer — dieser Vorschlag nimmt ihm die Schreibarbeit ab, nicht die
  Entscheidung.
⟨zeichnet: ⟩ ⟨am: ⟩
```

**Ergänzung für M5** — der Eintrag oben bleibt stehen, dies kommt hinzu:

```
⟨VORSCHLAG · NICHT GEZEICHNET⟩
ERGAENZUNG (kein Ersatz) zum Kriterium vom 16.08.2026.
ERFUELLT WENN: Auch der Wiederaufnahmestand ist an den Mandanten der jetzt angemeldeten Sitzung
  gebunden - nach Abmelden und erneutem Anmelden liefert der Lesepfad des Gespraechsstands die
  Saetze des Mandanten dieser Sitzung, und ein Gespraechsstand eines fremden Mandanten gilt auch
  hier als nicht vorhanden, mit derselben Antwort wie auf eine nirgends vergebene Kennung.
GEMESSEN DURCH: Aufbau: je ein gespeicherter Gespraechsstand bei Mandant A und bei Mandant B
  (EN-06 · zwischenspeichern · Zustand Erfolg). Positivfall: der Nutzer von A meldet sich ab,
  meldet sich neu an und ruft den Lesepfad mit der Kennung seines eigenen Standes auf - der
  Stand ist da. Negativfall: dieselbe neue Sitzung von A ruft denselben Lesepfad zweimal auf,
  einmal mit der Kennung des echten Standes von B und einmal mit einer formal gueltigen,
  nirgends vergebenen Kennung; beide Antworten werden in Statuscode und Text verglichen. NICHT
  ERFUELLT: der Stand von B wird geliefert, oder er wird anders abgewiesen als die nirgends
  vergebene Kennung - dann ist seine Existenz verraten. Beide Kennungen muessen formal gueltig
  und die neue Sitzung gueltig angemeldet sein, damit der Fall allein an der Mandantengrenze
  scheitert.
· Quelle: 'auf den Mandanten der angemeldeten Sitzung eingeschraenkt' und 'gilt als nicht
  vorhanden' (K01-M15); EN-06 · zwischenspeichern · Zustand Erfolg ('Stand ueberlebt das
  Abmelden') ·
⟨zeichnet: ⟩ ⟨am: ⟩
```

`☐ gezeichnet   ☐ geändert (Wortlaut unten)   ☐ zurück an den Harness`

---

### K02-M20 · MUSS

> Die Mandantengrenze MUSS zweifach durchgesetzt werden — im Serverpfad und im Datenbestand, nach K13 Abschn. 3.

*Konzept K02, Zeile 63 · Vorschlag vom 16.08.2026 · für M5 zu eng*

**Vorgeschlagenes Kriterium**

```
⟨VORSCHLAG · NICHT GEZEICHNET⟩
ERFUELLT WENN: Beide Ebenen weisen den Zugriff auf fremde Mandantenzeilen je fuer sich ab: der
  Serverpfad bei einem Aufruf unter der Sitzung eines fremden Mandanten, und der Datenbestand
  bei einer Abfrage, die den Serverpfad umgeht und unmittelbar mit dem Mandantenkontext eines
  fremden Mandanten arbeitet.
GEMESSEN DURCH: Zwei getrennte Prueffaelle -- (a) gegen den Serverpfad: Sitzung von Mandant A
  ruft einen existierenden Bestand von B ab; (b) gegen die Datenbank: unmittelbare Abfrage
  derselben Zeile unter dem Mandantenkontext von A ohne Serverpfad. Beide Faelle liefern keine
  Zeile. NICHT ERFUELLT: Einer der beiden Prueffaelle liefert die fremde Zeile -- insbesondere
  wenn (b) sie liefert und die Grenze damit nur im Serverpfad haengt. Beide Faelle sind mit
  gueltiger Anmeldung, gueltigem Mandantenkontext und existierendem Schluessel zu fahren, damit
  sie allein an der Mandantengrenze scheitern.
· Erzeugt am 16.08.2026 auf Weisung E-6 (gez. M. Veil und A. Han). K23-M02: das Abnahmekriterium
  liefert der fachliche Eigentuemer — dieser Vorschlag nimmt ihm die Schreibarbeit ab, nicht die
  Entscheidung.
⟨zeichnet: ⟩ ⟨am: ⟩
```

**Ergänzung für M5** — der Eintrag oben bleibt stehen, dies kommt hinzu:

```
⟨VORSCHLAG · NICHT GEZEICHNET⟩
ERGAENZUNG (kein Ersatz) zum Kriterium vom 16.08.2026.
ERFUELLT WENN: Die zweifache Durchsetzung gilt auch fuer die Traeger des Gespraechsstands: fuer
  die document-Zeile und den zugehoerigen event-Eintrag weist der Serverpfad den Fremdzugriff
  ab, und der Datenbestand weist ihn auch dann ab, wenn der Serverpfad umgangen wird.
GEMESSEN DURCH: Aufbau: ein gespeicherter Gespraechsstand bei Mandant A (EN-06 ·
  zwischenspeichern · Zustand Erfolg), dazu Sitzung und Mandantenkontext von Mandant B.
  Positivfall: dieselben beiden Wege unter dem eigenen Mandanten A liefern document-Zeile und
  juengsten event-Eintrag. Negativfall: (a) Sitzung von B ruft den Serverpfad auf den Stand von
  A auf; (b) unmittelbare Abfrage derselben document-Zeile und desselben event-Eintrags unter
  dem Mandantenkontext von B, ohne Serverpfad; beide Faelle liefern keine Zeile. NICHT ERFUELLT:
  einer der beiden Faelle liefert eine der Zeilen - liefert sie (b), haengt die Grenze fuer den
  Gespraechsstand nur im Serverpfad. Anmeldung, Mandantenkontext und Schluessel sind gueltig,
  damit die Faelle allein an der Mandantengrenze scheitern.
· Quelle: 'im Serverpfad und im Datenbestand' (K02-M20); EN-06 · zwischenspeichern ·
  Berechtigung (Dreischritt Datei, document-Zeile, event) ·
⟨zeichnet: ⟩ ⟨am: ⟩
```

`☐ gezeichnet   ☐ geändert (Wortlaut unten)   ☐ zurück an den Harness`

---

### K02-M21 · MUSS

> Bei einem mandantengebundenen Schreibvorgang MUSS `event.tenant_id` gesetzt sein und mit Mandant der Sitzung, des Fachobjekts und der Projektnummer übereinstimmen. Fehlt oder widerspricht ein Bezug, wird die gemeinsame Transaktion zurückgerollt. **Eine benannte Ausnahme gilt für den Betreiber:** Trägt die Mitgliedschaft der Sitzung den Geltungsbereich Betreiber (K20 Abschn. 3), tritt an die Stelle der Gleichheit die Prüfung, dass Fachobjekt und Protokolleintrag denselben Kundenmandanten führen. Der Vorgang wird zusätzlich als Betreiberzugriff protokolliert.

*Konzept K02, Zeile 64 · Vorschlag vom 16.08.2026 · für M5 zu eng*

**Vorgeschlagenes Kriterium**

```
⟨VORSCHLAG · NICHT GEZEICHNET⟩
ERFUELLT WENN: Ein mandantengebundener Schreibvorgang geht nur durch, wenn event.tenant_id
  gesetzt ist und mit dem Mandanten der Sitzung, dem Mandanten des Fachobjekts und dem Mandanten
  der Projektnummer uebereinstimmt; fehlt oder widerspricht einer dieser Bezuege, sind nach dem
  Vorgang weder Fachobjekt noch Protokolleintrag entstanden oder veraendert. Traegt die
  Mitgliedschaft der Sitzung den Geltungsbereich Betreiber, tritt an die Stelle der Gleichheit
  mit der Sitzung die Pruefung, dass Fachobjekt und Protokolleintrag denselben Kundenmandanten
  fuehren; der Vorgang wird dann zusaetzlich als Betreiberzugriff protokolliert.
GEMESSEN DURCH: Prueffaelle gegen die Datenbank, nach jedem Fall Fachobjekt und Protokolleintrag
  lesen -- (a) alle Bezuege gleich (Erwartung: beide entstanden); (b) event.tenant_id leer; (c)
  event.tenant_id weicht vom Fachobjekt ab; (d) Projektnummer eines anderen Mandanten; (e)
  Betreitersitzung mit Fachobjekt und Eintrag desselben Kundenmandanten (Erwartung:
  durchgelassen, Betreiberzugriff protokolliert); (f) Betreibersitzung mit Fachobjekt und
  Eintrag verschiedener Kundenmandanten (Erwartung: nichts entstanden). NICHT ERFUELLT: In (b)
  bis (d) oder (f) ist das Fachobjekt entstanden oder veraendert, oder ein Protokolleintrag
  steht ohne sein Fachobjekt (Teilwirkung statt Ruecklauf der gemeinsamen Transaktion); oder in
  (e) fehlt die Kennzeichnung als Betreiberzugriff. Alle Faelle sind mit gueltiger Anmeldung und
  gueltigen Feldwerten zu fahren, damit sie an der Mandantenpruefung scheitern und nicht an
  Format oder Rechten.
· Erzeugt am 16.08.2026 auf Weisung E-6 (gez. M. Veil und A. Han). K23-M02: das Abnahmekriterium
  liefert der fachliche Eigentuemer — dieser Vorschlag nimmt ihm die Schreibarbeit ab, nicht die
  Entscheidung.
⟨zeichnet: ⟩ ⟨am: ⟩
```

**Ergänzung für M5** — der Eintrag oben bleibt stehen, dies kommt hinzu:

```
⟨VORSCHLAG · NICHT GEZEICHNET⟩
ERGAENZUNG (kein Ersatz) zum Kriterium vom 16.08.2026.
ERFUELLT WENN: Der Prueffall wird auch mit dem Schreibvorgang des Gespraechsstands gefahren -
  Fachobjekt ist die document-Zeile, Protokolleintrag der event-Eintrag aus EN-06 ·
  zwischenspeichern. Geht der Vorgang durch, fuehren beide denselben Mandanten und der Stand ist
  nach Abmelden und erneutem Anmelden lesbar; wird zurueckgerollt, steht weder eine neue
  document-Zeile noch ein event-Eintrag, und der vor dem Vorgang gueltige Stand bleibt gueltig.
GEMESSEN DURCH: Aufbau: angemeldete Sitzung mit vorhandenem Gespraechsstand. Positivfall:
  zwischenspeichern mit uebereinstimmenden Bezuegen - document-Zeile und event-Eintrag
  entstanden, event.tenant_id gleich dem Mandanten der Sitzung, des Fachobjekts und der
  Projektnummer; danach abmelden, neu anmelden, weitermachen - der Stand ist da. Negativfall:
  derselbe Vorgang je einmal mit leerem event.tenant_id, mit vom Fachobjekt abweichendem
  event.tenant_id und mit Projektnummer eines anderen Mandanten; nach jedem Fall document-Zeile
  und event-Eintrag lesen. NICHT ERFUELLT: in einem Negativfall ist die document-Zeile
  entstanden oder veraendert, oder ein event-Eintrag steht ohne seine document-Zeile
  (Teilwirkung statt Ruecklauf), oder der vor dem Fall gueltige Stand ist nach dem erneuten
  Anmelden nicht mehr da. Alle Faelle mit gueltiger Anmeldung und im Uebrigen gueltigen
  Feldwerten, damit sie an der Mandantenpruefung scheitern und nicht an Format oder Rechten.
· Quelle: 'mandantengebundener Schreibvorgang' und 'wird die gemeinsame Transaktion
  zurueckgerollt' (K02-M21); EN-06 · zwischenspeichern · Zustand Erfolg und Zustand Fehler ('der
  vorige Stand bleibt gueltig') ·
⟨zeichnet: ⟩ ⟨am: ⟩
```

`☐ gezeichnet   ☐ geändert (Wortlaut unten)   ☐ zurück an den Harness`

---

### K13-M05 · MUSS

> Jeder Aufruf aus einer Oberfläche MUSS über den Serverpfad laufen. Der Serverpfad prüft aktives Konto, Mitgliedschaft, Rolle, Mandant und Objektbezug, bevor er liest oder schreibt.

*Konzept K13, Zeile 46 · Vorschlag vom 16.08.2026 · für M5 zu eng*

**Vorgeschlagenes Kriterium**

```
⟨VORSCHLAG · NICHT GEZEICHNET⟩
Umstellung des eigenen Wortlauts, nichts ergänzt. Erfüllt, wenn nachgewiesen ist: (1) jeder
  Aufruf aus einer Oberfläche läuft über den Serverpfad; (2) der Serverpfad prüft das aktive
  Konto; (3) der Serverpfad prüft die Mitgliedschaft; (4) der Serverpfad prüft die Rolle; (5)
  der Serverpfad prüft den Mandanten; (6) der Serverpfad prüft den Objektbezug; (7) alle fünf
  Prüfungen liegen vor dem Lesen und vor dem Schreiben. Messweg, Schwelle und Evidenzform sagt
  der Wortlaut nicht — sie ergänzt nach K23-M02 der fachliche Eigentümer, der in dieser Zeile
  heute ⟨nicht benannt⟩ ist. Warum diese Klausel vorgelegt wird: klauselschnitt/S1_zeichnung.md,
  Block 1b — vom Bau beansprucht, nur teilweise gedeckt — dort noch ohne Haken.
⟨zeichnet: ⟩ ⟨am: ⟩
```

**Ergänzung für M5** — der Eintrag oben bleibt stehen, dies kommt hinzu:

```
⟨VORSCHLAG · NICHT GEZEICHNET⟩
ERGAENZUNG (kein Ersatz) zum Eintrag vom 16.08.2026, der den Wortlaut nur umstellt.
ERFUELLT WENN: Kein Aufruf aus EN-05 oder EN-06 erreicht Daten am Serverpfad vorbei, und die
  Pruefungen liegen vor dem Lesen und vor dem Schreiben: ein unmittelbar an den Datenbestand
  gerichteter Schreibvorgang mit den Nutzdaten einer Oberflaechenaktion bewirkt nichts, und
  Angaben, die der Server selbst ermittelt - Stufe und Mandant -, bleiben ohne Wirkung, wenn der
  Aufruf sie mitgibt.
GEMESSEN DURCH: Aufbau: angemeldete Sitzung mit vorhandenem Gespraechsstand. Positivfall: die
  Aktionen von EN-05 und EN-06 ueber den Serverpfad - Zustand Erfolg; bei EN-05 ·
  name_bestaetigen wechselt journey_phase serverseitig von ORIENTIERUNG auf INTERVIEW.
  Negativfall: (a) derselbe Schreibvorgang unmittelbar am Datenbestand ohne Serverpfad - danach
  ist keine Zeile entstanden oder veraendert; (b) Aufruf ueber den Serverpfad mit mitgegebener
  Stufe oder mitgegebenem Mandanten, die vom serverseitig ermittelten Wert abweichen - nach dem
  Aufruf steht der serverseitig ermittelte Wert. NICHT ERFUELLT: (a) hinterlaesst eine Zeile,
  oder in (b) steht der mitgegebene Wert. Sitzung, Rechte und uebrige Feldwerte sind gueltig,
  damit die Faelle allein am Serverpfad scheitern.
· Quelle: 'Jeder Aufruf aus einer Oberflaeche MUSS ueber den Serverpfad laufen ... bevor er
  liest oder schreibt' (K13-M05); EN-05 · name_bestaetigen · Berechtigung ('der Stufenwechsel
  wird serverseitig gesetzt, nie vom Client uebergeben') ·
⟨zeichnet: ⟩ ⟨am: ⟩
```

`☐ gezeichnet   ☐ geändert (Wortlaut unten)   ☐ zurück an den Harness`

---

## Teil 3 · Die übrigen, nach Konzept

### K01 — 9 Klauseln (4 von der Gegenprobe gehalten, 5 ersetzt)

---

### K01-G01 · GILT

> Es GILT fail-closed: Ist eine Vorbedingung nicht erfüllt oder nicht prüfbar, wird gesperrt statt zugelassen (K19 Abschn. 3.2 und 3.3). Die Sperre wird begründet angezeigt, nie stillschweigend gesetzt.

*Konzept K01, Zeile 113 · Gegenprobe: **ersetzt · erfunden***

**Vorgeschlagenes Kriterium**

```
⟨VORSCHLAG · NICHT GEZEICHNET⟩
ERFUELLT WENN: Auf EN-05 und EN-06 wird jede Aktion, deren Vorbedingung nicht erfuellt oder
  nicht pruefbar ist, gesperrt statt zugelassen, und zu jeder gesetzten Sperre ist am Bildschirm
  ein Grund sichtbar; keine Sperre steht ohne sichtbaren Grund.
GEMESSEN DURCH: Aufbau: angemeldetes Konto, eigener Mandant, eine app-Zeile in Stufe
  ORIENTIERUNG, EN-05 aufgerufen. Positivfall — EN-05 · ausgangsproblem_bestaetigen · Zustand
  leer: es liegt keine zusammengefasste Beschreibung des Ausgangsproblems vor, die Vorbedingung
  ist also nicht erfuellt; erwartete Beobachtung: die Schaltflaeche Ja, weiter zum Interview ist
  ausgeblendet, und an ihrer Stelle steht der Hinweis auf die fehlende Beschreibung — die Sperre
  ist damit begruendet angezeigt und nicht stillschweigend gesetzt. Zweiter Positivfall — EN-05
  · ziele_waehlen · Zustand leer: kein Ziel gewaehlt; erwartete Beobachtung: der Weiterweg ist
  ausgeblendet, an seiner Stelle steht der Hinweis auf das fehlende Ziel. Negativfall an
  derselben Bedingung: derselbe Aufbau ohne zusammengefasste Beschreibung, der Serverbefehl
  confirm_initial_problem wird dennoch aufgerufen; erwartete Beobachtung: der Serverpfad sperrt
  statt zuzulassen, die Bestaetigung wird nicht gespeichert, der Namensvorschlag erscheint
  nicht, die Stufe bleibt ORIENTIERUNG, und am Bildschirm steht weiterhin an Stelle der
  Schaltflaeche der Hinweis auf die fehlende Beschreibung. Der Prueffall ist gescheitert, wenn
  die Aktion durchlaeuft oder wenn eine Sperre ohne sichtbaren Grund steht. Den Wortlaut des
  Grundes nennt die Klausel nicht; ihn legt der fachliche Eigentuemer fest.
· Quelle: „Ist eine Vorbedingung nicht erfüllt oder nicht prüfbar, wird gesperrt statt
  zugelassen (K19 Abschn. 3.2 und 3.3). Die Sperre wird begründet angezeigt, nie stillschweigend
  gesetzt." ·
⟨zeichnet: ⟩ ⟨am: ⟩
```

`☐ gezeichnet   ☐ geändert (Wortlaut unten)   ☐ zurück an den Harness`

---

### K01-G09 · GILT

> Es GILT die Zweiteilung der Sperren: **ausgeblendet**, wo der Nutzer die Bedingung selbst erfüllen kann, mit einem Hinweis an Stelle der Schaltfläche; **ausgegraut**, wo eine Festlegung sie ihm dauerhaft verwehrt, mit Marke für den Grund (K19 Abschn. 3.1 und 3.3).

*Konzept K01, Zeile 121 · Gegenprobe: **ersetzt · negativfall_fehlt_oder_fremd***

**Vorgeschlagenes Kriterium**

```
⟨VORSCHLAG · NICHT GEZEICHNET⟩
ERFUELLT WENN: Auf EN-05 und EN-06 erscheint eine Sperre, deren Bedingung der Nutzer selbst
  erfuellen kann, ausgeblendet, und an Stelle der Schaltflaeche steht ein Hinweis; erfuellt der
  Nutzer die Bedingung, faellt der Hinweis fort und die Schaltflaeche steht an derselben Stelle
  wieder bedienbar. Die zweite Form der Zweiteilung — ausgegraut mit Marke fuer den Grund —
  fuehrt der Bildschirmvertrag fuer EN-05 und EN-06 an keiner Aktion; welche Festlegung sie dort
  ausloest, legt der fachliche Eigentuemer fest, und erst danach ist sie auf diesen beiden
  Bildschirmen messbar.
GEMESSEN DURCH: Aufbau: angemeldetes Konto, eigener Mandant, EN-05 in Stufe ORIENTIERUNG.
  Positivfall — EN-05 · ziele_waehlen · Zustand leer: kein Ziel gewaehlt, also eine Bedingung,
  die der Nutzer selbst erfuellen kann; erwartete Beobachtung: die Rangliste rechts bleibt leer,
  der Weiterweg ist ausgeblendet, und an seiner Stelle steht der Hinweis auf das fehlende Ziel.
  Zweiter Positivfall — EN-05 · ausgangsproblem_bestaetigen · Zustand leer: ohne
  zusammengefasstes Ausgangsproblem ist die Schaltflaeche ausgeblendet, an ihrer Stelle steht
  der Hinweis auf die fehlende Beschreibung. Negativfall an derselben Bedingung: derselbe
  Aufbau, aber der Nutzer erfuellt die Bedingung selbst und waehlt mindestens ein Ziel;
  erwartete Beobachtung: die Sperre tritt nicht ein — der Hinweis auf das fehlende Ziel steht
  nicht mehr, der Weiterweg ist wieder da und bedienbar, die Ziele stehen rechts mit
  Rangziffern. Der Prueffall ist gescheitert, wenn an Stelle der ausgeblendeten Schaltflaeche
  kein Hinweis steht, wenn der Hinweis nach Erfuellung der Bedingung stehen bleibt, oder wenn
  eine selbst erfuellbare Bedingung ausgegraut statt ausgeblendet dargestellt wird. Den Wortlaut
  des Hinweises nennt die Klausel nicht; ihn legt der fachliche Eigentuemer fest.
· Quelle: „ausgeblendet, wo der Nutzer die Bedingung selbst erfüllen kann, mit einem Hinweis an
  Stelle der Schaltfläche; ausgegraut, wo eine Festlegung sie ihm dauerhaft verwehrt, mit Marke
  für den Grund" ·
⟨zeichnet: ⟩ ⟨am: ⟩
```

`☐ gezeichnet   ☐ geändert (Wortlaut unten)   ☐ zurück an den Harness`

---

### K01-M01 · MUSS

> Eine Anwendung MUSS genau eine Zeile in `app` sein. `app` ist die Aggregatswurzel; die kanonische Kennung ist `app.id`. Zustand, Stufe, Siegel und Aufbewahrungsklasse hängen an dieser Zeile und nirgends sonst.

*Konzept K01, Zeile 51 · Gegenprobe: **ersetzt · erfunden***

**Vorgeschlagenes Kriterium**

```
⟨VORSCHLAG · NICHT GEZEICHNET⟩
ERFUELLT WENN: Zu einer Anwendung besteht genau eine Zeile in app; jeder Bezug auf die Anwendung
  laeuft ueber app.id; Zustand, Stufe, Siegel und Aufbewahrungsklasse sind ausschliesslich an
  dieser einen Zeile zu lesen, und keine zweite Stelle fuehrt fuer dieselbe Anwendung einen
  eigenen Wert dieser vier Angaben.
GEMESSEN DURCH: Aufbau: ein Konto eines Mandanten mit zwei Anwendungen A und B; A steht auf
  EN-05 in Stufe ORIENTIERUNG, B unveraendert. Positivfall — EN-05 · name_bestaetigen · Zustand
  Erfolg an A: app.name wird gesetzt und app.journey_phase von ORIENTIERUNG auf INTERVIEW
  gewechselt; erwartete Beobachtung: zu A besteht danach weiterhin genau eine app-Zeile; die
  neue Stufe ist in dieser einen, ueber app.id von A bezeichneten Zeile zu lesen; keine zweite
  Zeile und keine zweite Tabelle traegt fuer A einen eigenen Wert fuer Zustand, Stufe, Siegel
  oder Aufbewahrungsklasse. Negativfall an derselben Bedingung: unmittelbar nach demselben
  Wechsel an A wird B gelesen und B auf EN-05 aufgerufen; erwartete Beobachtung: die app-Zeile
  von B liest unveraendert ihren vorherigen Zustand und ihre vorherige Stufe, B zeigt keinen der
  an A geaenderten Werte, und es existiert keine gemeinsame zweite Stelle, ueber die der Wechsel
  an A auf B durchschlaegt. Der Prueffall ist gescheitert, sobald derselbe der vier Werte fuer
  dieselbe Anwendung an zwei Stellen steht, sobald zu A mehr als eine app-Zeile besteht, oder
  sobald der Wechsel an A einen Wert von B mitfuehrt.
· Quelle: „Eine Anwendung MUSS genau eine Zeile in `app` sein. `app` ist die Aggregatswurzel;
  die kanonische Kennung ist `app.id`. Zustand, Stufe, Siegel und Aufbewahrungsklasse hängen an
  dieser Zeile und nirgends sonst." ·
⟨zeichnet: ⟩ ⟨am: ⟩
```

`☐ gezeichnet   ☐ geändert (Wortlaut unten)   ☐ zurück an den Harness`

---

### K01-M05 · MUSS

> Eine Anwendung MUSS zwei Zustandsachsen führen, beide Pflicht: `lifecycle_state` mit acht Werten (EINGELADEN, DISCOVERY, IN_BEARBEITUNG, BEAUFTRAGT, IN_DEV, ABNAHME, IN_PROD, PAUSIERT) und `journey_phase` mit fünf Werten (ORIENTIERUNG, INTERVIEW, UEBERSICHT, PROTOTYP, ANGEBOT).

*Konzept K01, Zeile 55 · Gegenprobe: gehalten*

**Vorgeschlagenes Kriterium**

```
⟨VORSCHLAG · NICHT GEZEICHNET⟩
ERFUELLT WENN: Jede app-Zeile fuehrt beide Zustandsachsen belegt: lifecycle_state mit einem der
  acht Werte EINGELADEN, DISCOVERY, IN_BEARBEITUNG, BEAUFTRAGT, IN_DEV, ABNAHME, IN_PROD,
  PAUSIERT und journey_phase mit einem der fuenf Werte ORIENTIERUNG, INTERVIEW, UEBERSICHT,
  PROTOTYP, ANGEBOT; keine der beiden Achsen ist leer, und kein Wert ausserhalb dieser
  Aufzaehlungen kommt vor.
GEMESSEN DURCH: Aufbau: ein Konto durchlaeuft EN-05 und EN-06. Positivfall — EN-05 ·
  name_bestaetigen · Zustand Erfolg und EN-06 · interview_beenden · Zustand Erfolg: die app-
  Zeile wird vor und nach jeder der beiden Aktionen gelesen; erwartete Beobachtung: beide Achsen
  sind jedes Mal belegt, journey_phase liest nacheinander ORIENTIERUNG, INTERVIEW, UEBERSICHT,
  und lifecycle_state traegt durchgehend einen der acht genannten Werte. Negativfall an
  derselben Bedingung, zweifach: (a) in journey_phase wird ein Wert geschrieben, der in der
  Aufzaehlung der fuenf nicht vorkommt; (b) es wird eine app-Zeile gefuehrt, in der eine der
  beiden Achsen leer bleibt. Erwartete Beobachtung in beiden Faellen: der Schreibversuch wird
  abgewiesen, und die Achse liest unveraendert ihren vorherigen Wert beziehungsweise die Zeile
  entsteht nicht. Einen Meldungswortlaut nennt die Klausel nicht; ihn legt der fachliche
  Eigentuemer fest.
· Quelle: „Eine Anwendung MUSS zwei Zustandsachsen führen, beide Pflicht: `lifecycle_state` mit
  acht Werten (EINGELADEN, DISCOVERY, IN_BEARBEITUNG, BEAUFTRAGT, IN_DEV, ABNAHME, IN_PROD,
  PAUSIERT) und `journey_phase` mit fünf Werten (ORIENTIERUNG, INTERVIEW, UEBERSICHT, PROTOTYP,
  ANGEBOT)." ·
⟨zeichnet: ⟩ ⟨am: ⟩
```

`☐ gezeichnet   ☐ geändert (Wortlaut unten)   ☐ zurück an den Harness`

---

### K01-M07 · MUSS

> Jeder Bildschirm mit Gespräch MUSS zweigeteilt sein: links wird gesagt oder geklickt, rechts erscheint das Ergebnis, unmittelbar und ohne Wechsel zwischen getrennten Formularen.

*Konzept K01, Zeile 57 · Gegenprobe: **ersetzt · negativfall_fehlt_oder_fremd***

**Vorgeschlagenes Kriterium**

```
⟨VORSCHLAG · NICHT GEZEICHNET⟩
ERFUELLT WENN: EN-05 und EN-06 sind zweigeteilt — links wird gesagt oder geklickt, rechts
  erscheint das Ergebnis derselben Handlung, auf demselben Bildschirm und ohne dass dazwischen
  ein getrenntes Formular oder ein zweiter Bildschirm aufgerufen wird; solange links keine
  Handlung erfolgt ist, steht rechts kein Eintrag zu ihr.
GEMESSEN DURCH: Aufbau: angemeldetes Konto auf EN-06, Fachfrage mit Vorschlaegen gestellt;
  waehrend des gesamten Prueffalls wird der Bildschirm nicht gewechselt und kein weiteres
  Formular geoeffnet. Positivfall — EN-06 · vorschlag_waehlen: zuerst Zustand laden lesen, dann
  links einen Vorschlag waehlen und Zustand Erfolg lesen; erwartete Beobachtung: im Zustand
  laden stehen rechts nur die Teilnehmer; unmittelbar nach der Auswahl links steht rechts der
  Eintrag mit genau einer Herkunftsmarke, sichtbar ohne Aufruf eines getrennten Formulars und
  ohne Wechsel auf einen zweiten Bildschirm. Zweiter Positivfall — EN-05 ·
  einordnung_beantworten · Zustand Erfolg: die links gegebene Antwort ist rechts unter Branche,
  Funktion oder Anwendung sichtbar, auf demselben Bildschirm. Negativfall an derselben Bedingung
  — EN-06 · vorschlag_waehlen · Zustand laden: Frage und Vorschlaege sind geladen, links wird
  nichts gewaehlt, nichts getippt, nichts gesendet; erwartete Beobachtung: rechts stehen
  ausschliesslich die Teilnehmer, es entsteht kein Antworteintrag, solange links keine Handlung
  gewirkt hat. Der Prueffall ist gescheitert, wenn rechts ohne wirksame Handlung links ein
  Eintrag steht, oder wenn das Ergebnis einer Handlung links erst nach einem Wechsel auf ein
  getrenntes Formular oder einen zweiten Bildschirm sichtbar wird.
· Quelle: „Jeder Bildschirm mit Gespräch MUSS zweigeteilt sein: links wird gesagt oder geklickt,
  rechts erscheint das Ergebnis, unmittelbar und ohne Wechsel zwischen getrennten Formularen." ·
⟨zeichnet: ⟩ ⟨am: ⟩
```

`☐ gezeichnet   ☐ geändert (Wortlaut unten)   ☐ zurück an den Harness`

---

### K01-M09 · MUSS

> Ab Stufe 02 MUSS unter dem Gespräch *Speichern, später weitermachen* stehen. Der Stand MUSS das Abmelden überleben; es gibt keinen Vorgang, der nur innerhalb einer Sitzung besteht.

*Konzept K01, Zeile 59 · Gegenprobe: gehalten*

**Vorgeschlagenes Kriterium**

```
⟨VORSCHLAG · NICHT GEZEICHNET⟩
ERFUELLT WENN: Auf Stufe 02 (EN-06) steht unter dem Gespraech die Schaltflaeche Speichern,
  spaeter weitermachen; nach ihrem Erfolg ueberlebt der erreichte Gespraechsstand mit Marken und
  Uebersprungvermerken eine Abmeldung — nach neuer Anmeldung ist derselbe Stand da, und kein
  Teil des Vorgangs besteht nur innerhalb der Sitzung.
GEMESSEN DURCH: Aufbau: ein Konto beantwortet auf EN-06 mindestens eine Fachfrage (Zustand
  Erfolg, Eintrag rechts mit Marke) und ueberspringt mindestens eine (EN-06 · frage_ignorieren ·
  Zustand Erfolg, rechts der Wortlaut (Frage uebersprungen) ohne Marke). Positivfall — EN-06 ·
  zwischenspeichern · Zustand Erfolg: die Schaltflaeche steht unter dem Gespraech und wird
  ausgeloest; danach abmelden, neu anmelden, EN-06 wieder aufrufen; erwartete Beobachtung: die
  Antworten stehen rechts mit ihren Marken, der Uebersprungvermerk steht ohne Marke, und der
  juengste event-Eintrag verweist in object_ref auf Dokumentkennung und Hash. Negativfall an
  derselben Bedingung — EN-06 · zwischenspeichern · Zustand Fehler: derselbe Aufbau, aber der
  Dreischritt Datei, document-Zeile, event bleibt unvollstaendig; erwartete Beobachtung: der
  unvollstaendige Dreischritt wird nicht sichtbar, es erscheint eine Meldung, der vorige Stand
  bleibt gueltig — und nach Abmelden und Neuanmelden steht genau dieser vorige Stand, kein
  halber. Den Wortlaut der Meldung nennt die Klausel nicht; ihn legt der fachliche Eigentuemer
  fest.
· Quelle: „Ab Stufe 02 MUSS unter dem Gespräch *Speichern, später weitermachen* stehen. Der
  Stand MUSS das Abmelden überleben; es gibt keinen Vorgang, der nur innerhalb einer Sitzung
  besteht." ·
⟨zeichnet: ⟩ ⟨am: ⟩
```

`☐ gezeichnet   ☐ geändert (Wortlaut unten)   ☐ zurück an den Harness`

---

### K01-M16 · MUSS

> Text, den ein Nutzer eingibt, diktiert oder hochlädt, MUSS als Daten behandelt werden. Eine darin enthaltene Handlungsanweisung wird nicht ausgeführt (Trennung im Agentenbetrieb: K17).

*Konzept K01, Zeile 66 · Gegenprobe: gehalten*

**Vorgeschlagenes Kriterium**

```
⟨VORSCHLAG · NICHT GEZEICHNET⟩
ERFUELLT WENN: Ein vom Nutzer eingegebener oder diktierter Text wird auf EN-06 ausschliesslich
  als Antwort gefuehrt; eine darin enthaltene Handlungsanweisung wird nicht ausgefuehrt — sie
  loest keinen Serverbefehl, keinen Stufenwechsel und keine Aenderung am Gespraechsstand aus,
  die der Nutzer nicht selbst ausgeloest hat.
GEMESSEN DURCH: Aufbau: angemeldetes Konto auf EN-06 mit gestellter Fachfrage; die tatsaechlich
  ausgefuehrten Serverbefehle und Zustandswechsel werden mitgeschrieben. Positivfall — EN-06 ·
  freitext_antworten · Zustand Erfolg: ein Freitext ohne Handlungsanweisung wird gesendet;
  erwartete Beobachtung: Eintrag rechts mit Marke Ihre Angabe, kein weiterer Serverbefehl.
  Negativfall an derselben Bedingung: derselbe Weg mit einem Freitext, der eine an das System
  gerichtete Handlungsanweisung enthaelt, einmal getippt und einmal diktiert (diktierter Text
  ist vor dem Senden sichtbar und aenderbar); erwartete Beobachtung: die Anweisung scheitert —
  der Wortlaut steht unveraendert rechts als Eintrag mit Marke Ihre Angabe, und im Mitschrieb
  steht kein Serverbefehl und kein Zustandswechsel, den der Nutzer nicht selbst ausgeloest hat.
  Der Prueffall ist gescheitert, sobald eine Wirkung der Anweisung nachweisbar ist. Der dritte
  im Wortlaut genannte Weg — hochgeladener Text — ist auf EN-06 nur ueber datei_anhaengen
  messbar
· Stufe: zurueckgestellt (Blatt 100, E4).
· Quelle: „Text, den ein Nutzer eingibt, diktiert oder hochlädt, MUSS als Daten behandelt
  werden. Eine darin enthaltene Handlungsanweisung wird nicht ausgeführt." ·
⟨zeichnet: ⟩ ⟨am: ⟩
```

`☐ gezeichnet   ☐ geändert (Wortlaut unten)   ☐ zurück an den Harness`

---

### K01-M17 · MUSS

> Vor jeder Übergabe an ein Sprachmodell MÜSSEN personenbezogene Angaben maskiert werden. Die Rückauflösung bleibt in der Plattform; ihre Aufbewahrung führt K15, den Modellpfad K17.

*Konzept K01, Zeile 67 · Gegenprobe: **ersetzt · nicht_messbar***

**Vorgeschlagenes Kriterium**

```
⟨VORSCHLAG · NICHT GEZEICHNET⟩
ERFUELLT WENN: Vor jeder Uebergabe von EN-06 an ein Sprachmodell laeuft der Maskierungsschritt;
  in der uebergebenen Nutzlast steht keine der Angaben wortgleich, die der fachliche Eigentuemer
  vorab als personenbezogen bezeichnet hat, und die Rueckaufloesung ist in der Nutzlast nicht
  enthalten, sondern verbleibt in der Plattform; scheitert oder fehlt der Maskierungsschritt,
  unterbleibt die Uebergabe ganz. Welche Angaben als personenbezogen gelten, zaehlt der Wortlaut
  nicht auf — diese Aufzaehlung legt der fachliche Eigentuemer fest (Aufbewahrung K15,
  Modellpfad K17); ohne sie hat der Positivfall keine feste Bestehensbedingung und ist vor der
  Abnahme beizubringen.
GEMESSEN DURCH: Aufbau: angemeldetes Konto auf EN-06 mit gestellter Fachfrage; jede tatsaechlich
  gesendete Nutzlast eines Modellaufrufs wird mitgeschrieben; der Prueftext enthaelt wortgleich
  mindestens eine Angabe aus der vom Eigentuemer gezeichneten Aufzaehlung. Positivfall — EN-06 ·
  freitext_antworten · Zustand Erfolg: der Prueftext wird gesendet; erwartete Beobachtung:
  rechts steht der Eintrag mit Marke Ihre Angabe, in der mitgeschriebenen Nutzlast kommt die
  bezeichnete Angabe nicht wortgleich vor, und die Nutzlast enthaelt keine Zuordnung, aus der
  sich die Angabe zurueckaufloesen laesst. Negativfall an derselben Bedingung — EN-06 ·
  freitext_antworten · Zustand Fehler: derselbe Prueftext, der Maskierungsschritt wird zum
  Scheitern gebracht (abgeschaltet oder mit Fehler beantwortet); erwartete Beobachtung: es wird
  keine Nutzlast gesendet, im Mitschrieb steht kein Modellaufruf, und die Frage bleibt
  unbeantwortet stehen. Der Prueffall ist gescheitert, wenn die bezeichnete Angabe wortgleich in
  der Nutzlast steht, wenn die Rueckaufloesung mitgesendet wird, oder wenn bei gescheitertem
  Maskierungsschritt dennoch eine Nutzlast das System verlaesst. Den Wortlaut der Meldung nennt
  die Klausel nicht; ihn legt der fachliche Eigentuemer fest.
· Quelle: „Vor jeder Übergabe an ein Sprachmodell MÜSSEN personenbezogene Angaben maskiert
  werden. Die Rückauflösung bleibt in der Plattform; ihre Aufbewahrung führt K15, den Modellpfad
  K17." ·
⟨zeichnet: ⟩ ⟨am: ⟩
```

`☐ gezeichnet   ☐ geändert (Wortlaut unten)   ☐ zurück an den Harness`

---

### K01-M21 · MUSS

> Jeder Zustandswechsel MUSS nachweisbar geschrieben werden: Zeitpunkt, Projektnummer, handelnde Instanz, Wert davor und danach. Der Protokolleintrag gehört `event` (K02), die Verlaufszeile `app_state_history` und der Sicht `app_state_aktuell` (beide K11).

*Konzept K01, Zeile 71 · Gegenprobe: gehalten*

**Vorgeschlagenes Kriterium**

```
⟨VORSCHLAG · NICHT GEZEICHNET⟩
ERFUELLT WENN: Zu jedem Zustandswechsel auf EN-05 und EN-06 besteht ein Protokolleintrag in
  event, der Zeitpunkt, Projektnummer, handelnde Instanz sowie den Wert davor und den Wert
  danach traegt, dazu eine Verlaufszeile in app_state_history und der neue Wert in der Sicht
  app_state_aktuell; gelingt der Eintrag nicht, findet auch der Wechsel nicht statt.
GEMESSEN DURCH: Aufbau: ein Konto auf EN-05 in Stufe ORIENTIERUNG. Positivfall — EN-05 ·
  name_bestaetigen · Zustand Erfolg: der Wechsel von ORIENTIERUNG auf INTERVIEW wird ausgeloest;
  erwartete Beobachtung: die app-Zeile liest INTERVIEW; es besteht ein event-Eintrag mit source
  = PORTAL_ACTION, dessen Angaben Zeitpunkt, Projektnummer, handelnde Instanz, Wert davor
  (ORIENTIERUNG) und Wert danach (INTERVIEW) saemtlich belegt sind; app_state_history traegt die
  zugehoerige Verlaufszeile und app_state_aktuell den neuen Wert. Zweiter Positivfall an EN-06 ·
  interview_beenden · Zustand Erfolg fuer den Wechsel auf UEBERSICHT. Negativfall an derselben
  Bedingung — EN-05 · name_bestaetigen · Zustand Fehler: derselbe Aufbau, aber der
  Protokolleintrag scheitert; erwartete Beobachtung: alles ist zurueckgerollt, es gibt keinen
  Teilwechsel, die Stufe bleibt ORIENTIERUNG, und weder event noch app_state_history tragen eine
  Zeile zu diesem Wechsel. Der Prueffall ist gescheitert, wenn die Stufe gewechselt hat, ohne
  dass der vollstaendige Eintrag steht. Den Wortlaut der Fehlermeldung nennt die Klausel nicht;
  ihn legt der fachliche Eigentuemer fest.
· Quelle: „Jeder Zustandswechsel MUSS nachweisbar geschrieben werden: Zeitpunkt, Projektnummer,
  handelnde Instanz, Wert davor und danach. Der Protokolleintrag gehört `event` (K02), die
  Verlaufszeile `app_state_history` und der Sicht `app_state_aktuell`." ·
⟨zeichnet: ⟩ ⟨am: ⟩
```

`☐ gezeichnet   ☐ geändert (Wortlaut unten)   ☐ zurück an den Harness`

---

### K02 — 7 Klauseln (3 von der Gegenprobe gehalten, 4 ersetzt)

---

### K02-D01 · DARF NICHT

> Ein Protokolleintrag DARF NICHT geändert werden. Zwei Regeln am Bestand lassen jeden Änderungsversuch wirkungslos verlaufen.

*Konzept K02, Zeile 73 · Gegenprobe: **ersetzt · erfunden***

**Vorgeschlagenes Kriterium**

```
⟨VORSCHLAG · NICHT GEZEICHNET⟩
ERFUELLT WENN: Ein vorhandener Protokolleintrag traegt nach einem Aenderungsversuch Feld fuer
  Feld denselben Stand wie davor; der Versuch bleibt wirkungslos.
GEMESSEN DURCH: Aufbau: ueber EN-06 · zwischenspeichern · Zustand Erfolg entsteht ein event-
  Eintrag — „der juengste event-Eintrag verweist in object_ref auf Dokumentkennung und Hash";
  sein vollstaendiger Feldstand wird gelesen und festgehalten. Positivfall: derselbe Weg wird
  noch einmal ausgeloest — ein neuer Eintrag kommt hinzu, der festgehaltene aeltere bleibt Feld
  fuer Feld unveraendert; danach abmelden, neu anmelden und das Gespraech wieder aufnehmen — der
  Stand richtet sich nach dem juengsten Eintrag, der aeltere ist weiterhin unveraendert. Die
  Unveraenderlichkeit sperrt also das Aendern, nicht das Schreiben. Negativfall (muss
  wirkungslos verlaufen): auf denselben vorhandenen Eintrag wird unmittelbar am Bestand ein Feld
  ueberschrieben — mit gueltiger Anmeldung, gueltigem Mandantenkontext und richtigem Schluessel,
  damit der Lauf allein an der Unveraenderlichkeit scheitert und nicht an Rechten, Schluessel
  oder Format; erwartete Beobachtung: Abweisung oder folgenlose Ausfuehrung, danach Feld fuer
  Feld derselbe Stand wie vor dem Lauf. Einen Wortlaut der Meldung nennt die Klausel nicht;
  gemessen wird der Feldstand vorher gegen nachher. Dass zwei Regeln am Bestand diese Wirkung
  tragen, wird belegt, indem beide Regeln benannt und am Bestand nachgewiesen werden; welche
  zwei Regeln das sind und ob jede fuer sich allein tragen muss, gibt der Wortlaut nicht her —
  das legt der fachliche Eigentuemer fest. Der Loeschfall ist nicht Gegenstand dieser Klausel;
  sie spricht vom Aendern.
· Quelle: „Ein Protokolleintrag DARF NICHT geändert werden. Zwei Regeln am Bestand lassen jeden
  Änderungsversuch wirkungslos verlaufen.“
· Erzeugt am 19.08.2026 (Blatt 100, Entscheidung 5). K23-M02: das Abnahmekriterium liefert der
  fachliche Eigentuemer — dieser Vorschlag nimmt ihm die Schreibarbeit ab, nicht die
  Entscheidung.
⟨zeichnet: ⟩ ⟨am: ⟩
```

`☐ gezeichnet   ☐ geändert (Wortlaut unten)   ☐ zurück an den Harness`

---

### K02-D04 · DARF NICHT

> Ein Schreibvorgang DARF NICHT gelten, wenn sein Protokolleintrag ausbleibt. Beides entsteht gemeinsam oder gar nicht.

*Konzept K02, Zeile 76 · Gegenprobe: gehalten*

**Vorgeschlagenes Kriterium**

```
⟨VORSCHLAG · NICHT GEZEICHNET⟩
ERFUELLT WENN: Nach einem Schreibvorgang, dessen Protokolleintrag ausbleibt, ist die fachliche
  Aenderung nicht vorhanden: Fachobjekt und Protokolleintrag stehen nach dem Vorgang gemeinsam
  da oder gar nicht.
GEMESSEN DURCH: Aufbau: EN-05 · name_bestaetigen mit gefuelltem Namensfeld, Sitzung des eigenen
  Mandanten. Positivfall: Aktion ausloesen, Zustand Erfolg — app.name ist gesetzt,
  app.journey_phase steht auf INTERVIEW, und der Protokolleintrag in event mit source =
  PORTAL_ACTION liegt vor; beide werden gelesen. Negativfall (muss folgenlos bleiben): derselbe
  Aufruf mit unterbundenem Protokolleintrag, sonst unveraendert gueltig — gleiche Anmeldung,
  gleicher Mandant, gleiche Eingabe, damit der Lauf allein am ausbleibenden Eintrag scheitert;
  erwartete Beobachtung: der Fehlerzustand der Aktion tritt ein — „Schreibbefehl oder
  Protokolleintrag gescheitert — alles zurueckgerollt, kein Teilwechsel, Stufe bleibt
  ORIENTIERUNG“ — und app traegt danach weder den neuen Namen noch die neue Stufe. Gegenprobe in
  der anderen Richtung: derselbe Lauf mit scheiterndem fachlichem Schreibvorgang — dann steht
  auch kein Protokolleintrag.
· Quelle: „Ein Schreibvorgang DARF NICHT gelten, wenn sein Protokolleintrag ausbleibt. Beides
  entsteht gemeinsam oder gar nicht.“
· Erzeugt am 19.08.2026 (Blatt 100, Entscheidung 5). K23-M02: das Abnahmekriterium liefert der
  fachliche Eigentuemer — dieser Vorschlag nimmt ihm die Schreibarbeit ab, nicht die
  Entscheidung.
⟨zeichnet: ⟩ ⟨am: ⟩
```

`☐ gezeichnet   ☐ geändert (Wortlaut unten)   ☐ zurück an den Harness`

---

### K02-M12 · MUSS

> Jeder Schreibvorgang auf einem fachlichen Objekt MUSS genau einen Protokolleintrag erzeugen. Diese Klausel löst die Auflage aus K13 Abschn. 3 ein.

*Konzept K02, Zeile 55 · Gegenprobe: **ersetzt · negativfall_fehlt_oder_fremd***

**Vorgeschlagenes Kriterium**

```
⟨VORSCHLAG · NICHT GEZEICHNET⟩
ERFUELLT WENN: Je Schreibvorgang auf einem fachlichen Objekt zaehlt der Bestand genau einen
  neuen Protokolleintrag zu diesem Objekt — nicht keinen und nicht zwei.
GEMESSEN DURCH: Aufbau: Zaehlstand der event-Eintraege zum betroffenen Objekt vor der Handlung
  lesen. Positivfall: nacheinander je einmal EN-05 · thema_waehlen, EN-05 · name_bestaetigen und
  EN-06 · zwischenspeichern in Zustand Erfolg ausloesen; nach jeder einzelnen Handlung ist der
  Zaehlstand um genau eins gestiegen, und die fachliche Wirkung der Handlung steht (Thema im
  INTERVIEW_PROTOCOL-Stand gefuehrt, app.name gesetzt, Stand gespeichert). Negativfall (muss an
  der Zahl scheitern): derselbe Befehl EN-05 · name_bestaetigen wird unter gleicher Anmeldung,
  gleichem Mandanten, gleichem Objekt und gleicher Eingabe ausgeloest, waehrend der
  Protokolleintrag nicht geschrieben werden kann — damit der Lauf allein an der Zahl der
  Eintraege scheitert und nicht an Rechten, Mandant oder Format; erwartete Beobachtung: der
  gezeichnete Fehlerzustand „Schreibbefehl oder Protokolleintrag gescheitert — alles
  zurueckgerollt, kein Teilwechsel, Stufe bleibt ORIENTIERUNG", danach ist der Zaehlstand der
  event-Eintraege unveraendert UND app traegt weder den neuen Namen noch die neue Stufe: es gibt
  keinen Schreibvorgang mit null Eintraegen. Zweiter Negativlauf gegen die zwei: derselbe Befehl
  wird nach diesem gescheiterten Lauf wiederholt und geht durch — danach steht genau ein
  fachlicher Schreibvorgang und genau ein neuer Eintrag; der zurueckgerollte Versuch hat keinen
  zweiten hinterlassen. Einen Meldungstext ueber den Vertragswortlaut hinaus nennt die Klausel
  nicht; gemessen wird die Zahl der Eintraege je Schreibvorgang.
· Quelle: „Jeder Schreibvorgang auf einem fachlichen Objekt MUSS genau einen Protokolleintrag
  erzeugen.“
· Erzeugt am 19.08.2026 (Blatt 100, Entscheidung 5). K23-M02: das Abnahmekriterium liefert der
  fachliche Eigentuemer — dieser Vorschlag nimmt ihm die Schreibarbeit ab, nicht die
  Entscheidung.
⟨zeichnet: ⟩ ⟨am: ⟩
```

`☐ gezeichnet   ☐ geändert (Wortlaut unten)   ☐ zurück an den Harness`

---

### K02-M13 · MUSS

> Jeder Protokolleintrag MUSS Zeitpunkt, Aktion und Quelle tragen. Ohne diese drei Angaben entsteht kein Eintrag.

*Konzept K02, Zeile 56 · Gegenprobe: gehalten*

**Vorgeschlagenes Kriterium**

```
⟨VORSCHLAG · NICHT GEZEICHNET⟩
ERFUELLT WENN: Jeder vorhandene Protokolleintrag traegt alle drei Angaben Zeitpunkt, Aktion und
  Quelle gefuellt; fehlt eine der drei, ist kein Eintrag entstanden.
GEMESSEN DURCH: Positivfall: EN-06 · zwischenspeichern in Zustand Erfolg ausloesen und den
  juengsten event-Eintrag lesen — Zeitpunkt, Aktion und Quelle sind gefuellt; dieselbe Lesung
  ueber alle im Lauf entstandenen Eintraege, keiner mit einer leeren der drei Angaben.
  Negativfall (muss ohne Eintrag enden): drei Laeufe, in denen der Eintrag je einmal ohne
  Zeitpunkt, ohne Aktion und ohne Quelle geschrieben werden soll, sonst gueltig — gleiche
  Anmeldung, vorhandenes Objekt, gefuellte uebrige Angaben, damit jeder Lauf allein an der
  fehlenden Angabe scheitert; erwartete Beobachtung: der Zaehlstand der Eintraege bleibt in
  allen drei Laeufen unveraendert. Einen Meldungstext nennt die Klausel nicht; gemessen wird das
  Ausbleiben des Eintrags.
· Quelle: „Jeder Protokolleintrag MUSS Zeitpunkt, Aktion und Quelle tragen. Ohne diese drei
  Angaben entsteht kein Eintrag.“
· Erzeugt am 19.08.2026 (Blatt 100, Entscheidung 5). K23-M02: das Abnahmekriterium liefert der
  fachliche Eigentuemer — dieser Vorschlag nimmt ihm die Schreibarbeit ab, nicht die
  Entscheidung.
⟨zeichnet: ⟩ ⟨am: ⟩
```

`☐ gezeichnet   ☐ geändert (Wortlaut unten)   ☐ zurück an den Harness`

---

### K02-M14 · MUSS

> Die Quelle MUSS einen von zwei Werten führen: Portal-Aktion oder Modell-Änderung. Ein dritter Wert ist nicht vorgesehen.

*Konzept K02, Zeile 57 · Gegenprobe: **ersetzt · nicht_messbar***

**Vorgeschlagenes Kriterium**

```
⟨VORSCHLAG · NICHT GEZEICHNET⟩
ERFUELLT WENN: Die Quelle jedes in den Stufen 01 und 02 entstandenen Protokolleintrags traegt
  einen der beiden im Wortlaut genannten Werte — Portal-Aktion oder Modell-Aenderung; ein
  dritter Wert kommt im Bestand nicht vor und laesst sich nicht schreiben.
GEMESSEN DURCH: Positivfall: EN-05 · name_bestaetigen und EN-06 · interview_beenden je in
  Zustand Erfolg ausloesen — der entstandene Eintrag traegt die Quelle, die der
  Bildschirmvertrag als „Protokolleintrag in event mit source = PORTAL_ACTION" fuehrt, also den
  Wert Portal-Aktion; anschliessend die Quelle aller im Lauf entstandenen Eintraege auslesen —
  jeder traegt einen der beiden im Wortlaut genannten Werte, keiner einen weiteren. Negativfall
  (muss abgewiesen werden): derselbe Schreibweg mit einem dritten, nicht vorgesehenen Quellwert,
  sonst gueltig — gleiche Anmeldung, gleicher Mandant, vorhandenes Objekt, gefuellter Zeitpunkt,
  gefuellte Aktion, damit der Lauf allein am Quellwert scheitert; erwartete Beobachtung: kein
  Eintrag mit dem dritten Wert entsteht, der Zaehlstand der Eintraege zum Objekt bleibt
  unveraendert. Einen Meldungstext nennt die Klausel nicht; gemessen wird der Wertevorrat der
  Quelle. Dass auch der zweite Wert Modell-Aenderung tatsaechlich vorkommt, ist in den Stufen 01
  und 02 nicht beobachtbar — der Bildschirmvertrag zeichnet dort nur source = PORTAL_ACTION; wo
  ein Eintrag mit dem zweiten Wert entsteht und wie er zu pruefen ist, legt der fachliche
  Eigentuemer fest.
· Quelle: „Die Quelle MUSS einen von zwei Werten führen: Portal-Aktion oder Modell-Änderung. Ein
  dritter Wert ist nicht vorgesehen.“
· Erzeugt am 19.08.2026 (Blatt 100, Entscheidung 5). K23-M02: das Abnahmekriterium liefert der
  fachliche Eigentuemer — dieser Vorschlag nimmt ihm die Schreibarbeit ab, nicht die
  Entscheidung.
⟨zeichnet: ⟩ ⟨am: ⟩
```

`☐ gezeichnet   ☐ geändert (Wortlaut unten)   ☐ zurück an den Harness`

---

### K02-M15 · MUSS

> Bei einer Änderung MUSS der Eintrag den Wert vorher und den Wert jetzt tragen; bei einer Neuanlage den Anfangswert.

*Konzept K02, Zeile 58 · Gegenprobe: **ersetzt · negativfall_fehlt_oder_fremd***

**Vorgeschlagenes Kriterium**

```
⟨VORSCHLAG · NICHT GEZEICHNET⟩
ERFUELLT WENN: Ein Protokolleintrag zu einer Aenderung traegt beide Werte — den Wert vorher und
  den Wert jetzt; ein Protokolleintrag zu einer Neuanlage traegt den Anfangswert und keinen Wert
  vorher.
GEMESSEN DURCH: Positivfall Aenderung: EN-05 · name_bestaetigen in Zustand Erfolg ausloesen; der
  Bildschirmvertrag fuehrt dort „app.journey_phase von ORIENTIERUNG auf INTERVIEW" — der
  entstandene Eintrag traegt ORIENTIERUNG als Wert vorher und INTERVIEW als Wert jetzt, beide
  gefuellt und voneinander verschieden. Positivfall Neuanlage: EN-06 · zwischenspeichern in
  Zustand Erfolg zum ersten Mal ausloesen; dabei entsteht im Dreischritt Datei, document-Zeile,
  event eine neue document-Zeile — der zugehoerige Eintrag traegt den Anfangswert dieser Zeile,
  ein Wert vorher steht nicht darin. Negativfall (muss an SEINER eigenen Bedingung scheitern):
  derselbe Leseweg wird auf den Eintrag der Neuanlage angewandt und gegen die
  Aenderungsbedingung geprueft — er fuehrt keinen Wert vorher; die Aenderungsbedingung ist an
  ihm nicht erfuellt und darf an ihm nicht verlangt werden. Aufbau sonst gueltig: gleiche
  Anmeldung, gleicher Mandant, vorhandenes Objekt, damit der Lauf allein an der Unterscheidung
  Aenderung gegen Neuanlage scheitert; erwartete Beobachtung: die Messung trennt beide Faelle
  und winkt nicht jeden Eintrag mit zwei Wertfeldern durch. Zusatz zum Positivfall Aenderung:
  derselbe Vorgang wird nach einer zweiten Aenderung desselben Feldes gelesen — der Wert vorher
  ist der zuvor stehende Wert, nicht der Anfangswert. Einen Meldungstext oder eine Frist nennt
  die Klausel nicht; gemessen werden die beiden Wertfelder je Eintragsart.
· Quelle: „Bei einer Änderung MUSS der Eintrag den Wert vorher und den Wert jetzt tragen; bei
  einer Neuanlage den Anfangswert.“
· Erzeugt am 19.08.2026 (Blatt 100, Entscheidung 5). K23-M02: das Abnahmekriterium liefert der
  fachliche Eigentuemer — dieser Vorschlag nimmt ihm die Schreibarbeit ab, nicht die
  Entscheidung.
⟨zeichnet: ⟩ ⟨am: ⟩
```

`☐ gezeichnet   ☐ geändert (Wortlaut unten)   ☐ zurück an den Harness`

---

### K02-M22 · MUSS

> `event.value` und `event.object_ref` MÜSSEN auf den für den Nachweis erforderlichen Umfang begrenzt werden. Geheimnisse, Zugangsdaten, vollständige Dokumente und vollständige Modellprompts werden nicht protokolliert.

*Konzept K02, Zeile 65 · Gegenprobe: gehalten*

**Vorgeschlagenes Kriterium**

```
⟨VORSCHLAG · NICHT GEZEICHNET⟩
ERFUELLT WENN: In event.value und event.object_ref steht keines der vier im Wortlaut
  ausgeschlossenen Dinge: kein Geheimnis, keine Zugangsdaten, kein vollstaendiges Dokument, kein
  vollstaendiger Modellprompt.
GEMESSEN DURCH: Aufbau: in den Gespraechsstand werden vier eindeutig wiedererkennbare
  Kennzeichenfolgen eingebracht — je eine in ein Geheimnis, in Zugangsdaten, in den
  Dokumentinhalt und in den Modellprompt. Positivfall: EN-06 · freitext_antworten und EN-06 ·
  zwischenspeichern je in Zustand Erfolg ausloesen; die entstandenen Eintraege werden in value
  und object_ref nach den vier Kennzeichenfolgen durchsucht — keine wird gefunden; statt des
  Inhalts steht dort der im Vertrag genannte Verweis auf Dokumentkennung und Hash. Negativfall
  (muss ausbleiben): derselbe Lauf, bei dem der vollstaendige Dokumentinhalt und in einem
  zweiten Lauf der vollstaendige Modellprompt nach value geschrieben werden sollen, sonst
  gueltig — gleiche Anmeldung, vorhandenes Objekt, gefuellte Pflichtangaben, damit der Lauf
  allein am protokollierten Umfang scheitert; erwartete Beobachtung: die jeweilige
  Kennzeichenfolge ist nach dem Lauf in keinem der beiden Felder auffindbar. Gemessen wird die
  im Wortlaut benannte Ausschlussliste; welcher Umfang darueber hinaus fuer den Nachweis
  erforderlich ist, bestimmt der fachliche Eigentuemer — der Wortlaut nennt dafuer keine Grenze.
· Quelle: „Geheimnisse, Zugangsdaten, vollständige Dokumente und vollständige Modellprompts
  werden nicht protokolliert.“
· Erzeugt am 19.08.2026 (Blatt 100, Entscheidung 5). K23-M02: das Abnahmekriterium liefert der
  fachliche Eigentuemer — dieser Vorschlag nimmt ihm die Schreibarbeit ab, nicht die
  Entscheidung.
⟨zeichnet: ⟩ ⟨am: ⟩
```

`☐ gezeichnet   ☐ geändert (Wortlaut unten)   ☐ zurück an den Harness`

---

### K03 — 4 Klauseln (0 von der Gegenprobe gehalten, 4 ersetzt)

---

### K03-D01 · DARF NICHT

> Kein Vorgang DARF ohne gültige Sitzung und ohne `status = AKTIV` wirksam werden. WARTET_2FA und GESPERRT führen zur Ablehnung, nie zum Teil-Zugang.

*Konzept K03, Zeile 57 · Gegenprobe: **ersetzt · hausform_verletzt***

**Vorgeschlagenes Kriterium**

```
⟨VORSCHLAG · NICHT GEZEICHNET⟩
Umstellung des eigenen Wortlauts, nichts ergänzt. Erfüllt, wenn nachgewiesen ist: (1) ein
  Vorgang ohne gültige Sitzung wird nicht wirksam; (2) ein Vorgang mit status WARTET_2FA wird
  abgelehnt; (3) ein Vorgang mit status GESPERRT wird abgelehnt; (4) in keinem der beiden Fälle
  entsteht ein Teil-Zugang. Messweg, Schwelle und Evidenzform sagt der Wortlaut nicht — sie
  ergänzt nach K23-M02 der fachliche Eigentümer, der in dieser Zeile heute ⟨nicht benannt⟩ ist.
  Warum diese Klausel vorgelegt wird: klauselschnitt/S1_zeichnung.md, Block 1a — vom Bau
  beansprucht und ganz gedeckt — dort noch ohne Haken.
⟨zeichnet: ⟩ ⟨am: ⟩
```

**Ergänzung für M5** — der Eintrag oben bleibt stehen, dies kommt hinzu:

```
⟨VORSCHLAG · NICHT GEZEICHNET⟩
ERFUELLT WENN: Ein Vorgang auf EN-05 oder EN-06 wird nur wirksam, wenn er zu einer gueltigen
  Sitzung gehoert und das handelnde Konto status = AKTIV fuehrt; ein Konto mit status WARTET_2FA
  und ein Konto mit status GESPERRT werden abgewiesen, und zwar ganz — kein Teil des Vorgangs
  wird wirksam.
GEMESSEN DURCH: Aufbau — ein Gespraech in Stufe 02 mit vorhandenem Stand; drei sonst gleiche
  Konten desselben Mandanten mit denselben Rechten: (a) status AKTIV, (b) status WARTET_2FA, (c)
  status GESPERRT. Positivfall (a): EN-06 · zwischenspeichern erreicht Zustand Erfolg ("Stand
  ueberlebt das Abmelden"); danach abmelden, neu anmelden, im selben Gespraech weitermachen —
  derselbe Stand ist da und die Fortsetzung wird wirksam. Negativfall 1 (abgelaufene Sitzung):
  mit Konto (a) denselben Speicherschritt aus der vor dem Abmelden bestehenden, nun abgelaufenen
  Sitzung erneut absenden — er wird nicht wirksam; der zuletzt gueltige Stand bleibt
  unveraendert, rechts entsteht kein Eintrag, es entsteht kein Teilstand. Negativfall 2 (b) und
  Negativfall 3 (c): dieselbe Handlung aus einer frisch angemeldeten Sitzung der Konten (b) und
  (c) — beide werden abgewiesen; in beiden Faellen entsteht weder ein Eintrag rechts noch ein
  geaenderter Stand, also kein Teil-Zugang. Aufbau, Gespraech, Mandant, Rolle und Objektbezug
  sind in allen drei Negativfaellen dieselben wie im Positivfall; sie scheitern allein an der
  fehlenden gueltigen Sitzung beziehungsweise am status des Kontos. Mit welcher Meldung der
  Bildschirm die Ablehnung zeigt, sagt der Wortlaut nicht — das ergaenzt nach K23-M02 der
  fachliche Eigentuemer.
· Quelle: K03-D01 Satz 1 ("Kein Vorgang DARF ohne gueltige Sitzung und ohne status = AKTIV
  wirksam werden") und Satz 2 ("WARTET_2FA und GESPERRT fuehren zur Ablehnung, nie zum Teil-
  Zugang"); Anker access: nach_anmeldung von EN-05 und EN-06 sowie EN-06 · zwischenspeichern ·
  Zustand Erfolg. Tritt an die Stelle des Eintrags vom 16.08.2026, der vier Bedingungen, aber
  keinen Prueffall fuehrt. ·
⟨zeichnet: ⟩ ⟨am: ⟩
```

`☐ gezeichnet   ☐ geändert (Wortlaut unten)   ☐ zurück an den Harness`

---

### K03-D11 · DARF NICHT

> Authentisierungs-, Domänen- und Fehlerentscheidungen DÜRFEN NICHT von einem Sprachmodell oder einer anderen KI-Komponente abhängen. Ein KI-Ausfall verändert die sichere Entscheidung nicht.

*Konzept K03, Zeile 304 · Gegenprobe: **ersetzt · negativfall_fremd***

**Vorgeschlagenes Kriterium**

```
⟨VORSCHLAG · NICHT GEZEICHNET⟩
ERFUELLT WENN: Authentisierungs-, Domaenen- und Fehlerentscheidungen auf EN-05 und EN-06 fallen
  bei ausgefallener oder abgeschalteter KI-Komponente genau so aus wie bei laufender, und keine
  dieser Entscheidungen uebernimmt ihr Ergebnis aus einer Modellausgabe.
GEMESSEN DURCH: Aufbau — dasselbe Konto, dasselbe Gespraech, dieselben Eingaben in drei Laeufen,
  die sich allein in der KI-Komponente unterscheiden: Lauf 1 mit erreichbarer KI-Komponente,
  Lauf 2 mit ausgefallener KI-Komponente, Lauf 3 mit einer KI-Komponente, deren Ausgabe das
  Gegenteil der Serverentscheidung nahelegt. Handlung je Lauf dieselbe Folge: (1) EN-06 ·
  freitext_antworten aus einem Konto, das die Pruefkette des Serverpfads nicht besteht; (2)
  EN-06 · freitext_antworten bei unvollstaendigem Modellpfad; (3) EN-05 · name_bestaetigen mit
  leerem Feld. Positivfall (Laeufe 1 und 2): die drei Entscheidungen lauten in beiden Laeufen
  gleich — (1) abgewiesen; (2) Zustand Fehler, "kein Aufruf, die Frage bleibt unbeantwortet
  stehen"; (3) abgelehnt, Stufe bleibt ORIENTIERUNG. Der Ausfall der KI-Komponente verschiebt
  keine der drei. Negativfall (Lauf 3): dieselben drei Faelle, waehrend die KI-Komponente zu
  jedem eine Ausgabe liefert, die Berechtigung, vollstaendigen Modellpfad und gefuelltes Feld
  behauptet — erwartete Beobachtung: alle drei Entscheidungen bleiben unveraendert abweisend,
  die Modellausgabe wird nicht uebernommen; faellt eine der drei anders aus als in Lauf 1, ist
  die Klausel verletzt. Konto, Sitzung, Mandant, Eingabe und Modellpfad sind in Lauf 3 dieselben
  wie in Lauf 1; der Fall scheitert allein daran, dass die Entscheidung nicht am Modell haengen
  darf. Nicht Gegenstand dieses Kriteriums ist die im Nutzertext enthaltene Handlungsanweisung —
  sie misst K01-M16 beziehungsweise K05-M22.
· Quelle: K03-D11 Satz 1 ("DUERFEN NICHT von einem Sprachmodell oder einer anderen KI-Komponente
  abhaengen") und Satz 2 ("Ein KI-Ausfall veraendert die sichere Entscheidung nicht"); Anker
  EN-06 · freitext_antworten · Zustand Fehler und EN-05 · name_bestaetigen · Zustand laden und
  Zustand leer. ·
⟨zeichnet: ⟩ ⟨am: ⟩
```

`☐ gezeichnet   ☐ geändert (Wortlaut unten)   ☐ zurück an den Harness`

---

### K03-M03 · MUSS

> `email` und `display_name` MÜSSEN gesetzt sein, die Adresse eindeutig. Sie ist der Anmeldename und wird aus der Einladung vorbelegt.

*Konzept K03, Zeile 40 · Gegenprobe: **ersetzt · hausform_verletzt***

**Vorgeschlagenes Kriterium**

```
⟨VORSCHLAG · NICHT GEZEICHNET⟩
Der Einwand zum Geltungsbereich der Eindeutigkeit ist berechtigt, traegt aber nur einen von drei
  Teilen. Die Begruendung raeumt selbst ein, die uebrigen Teile waeren messbar — dann gehoeren
  sie ins Kriterium und nicht in den Papierkorb. Ersatz: "ERFUELLT WENN: Jede Zeile in `actor`
  traegt ein nicht leeres `email` und ein nicht leeres `display_name`; beim Einloesen der
  Einladung ist `email` mit der eingeladenen Adresse vorbelegt.
GEMESSEN DURCH: Abfrage gegen die Datenbank — Zahl der Zeilen mit leerem `email` oder leerem
  `display_name` ist null; dazu zwei Einfuegeversuche (einer ohne `email`, einer ohne
  `display_name`) und ein Prueffall: Einladung an eine Adresse versenden, Link einloesen,
  gespeicherte Adresse mit der eingeladenen vergleichen. NICHT ERFUELLT: Eine `actor`-Zeile ohne
  `email` oder ohne `display_name` existiert; oder einer der Einfuegeversuche wird angenommen;
  oder die angelegte Adresse weicht von der eingeladenen ab." Offen bleibt allein der
  Geltungsbereich der Eindeutigkeit (systemweit oder je Mandant, im Licht von K03-M19) — dieser
  Teilpunkt ist als fehlend zu melden, nicht die ganze Klausel. · [durch Gegenprobe ersetzt:
  zu_unrecht_als_unableitbar]
· Erzeugt am 16.08.2026 auf Weisung E-6 (gez. M. Veil und A. Han). K23-M02: das Abnahmekriterium
  liefert der fachliche Eigentuemer — dieser Vorschlag nimmt ihm die Schreibarbeit ab, nicht die
  Entscheidung.
⟨zeichnet: ⟩ ⟨am: ⟩
```

**Ergänzung für M5** — der Eintrag oben bleibt stehen, dies kommt hinzu:

```
⟨VORSCHLAG · NICHT GEZEICHNET⟩
ERFUELLT WENN: Jede Zeile in actor traegt ein nicht leeres email und ein nicht leeres
  display_name, die Adresse ist eindeutig und beim Einloesen der Einladung mit der eingeladenen
  Adresse vorbelegt; in der Teilnehmerliste oben rechts auf EN-06 steht fuer den angemeldeten
  Nutzer genau dieses display_name.
GEMESSEN DURCH: Aufbau — eine an eine bekannte Adresse versendete Einladung, das daraus
  eingeloeste Konto mit bekanntem display_name, ein Gespraech in Stufe 02. Handlung — EN-06 ·
  vorschlag_waehlen in den Zustand laden bringen ("rechts stehen bis dahin nur die Teilnehmer").
  Positivfall: die Teilnehmerliste nennt den angemeldeten Nutzer mit dem display_name seiner
  actor-Zeile; die gespeicherte Adresse ist die eingeladene; Abfrage ueber alle actor-Zeilen:
  die Zahl der Zeilen mit leerem email ist null, die Zahl der Zeilen mit leerem display_name ist
  null, die Zahl doppelt vergebener Adressen ist null. Negativfall A: eine actor-Zeile ohne
  email anlegen — abgewiesen. Negativfall B: eine actor-Zeile ohne display_name anlegen —
  abgewiesen. Negativfall C: eine zweite actor-Zeile mit einer bereits vergebenen Adresse
  anlegen — abgewiesen. In allen drei Faellen sind Mandant, Einladung und Rolle dieselben wie im
  Positivfall; jeder scheitert allein an der eigenen Bedingung (fehlendes email, fehlendes
  display_name, nicht eindeutige Adresse). In welchem Geltungsbereich die Adresse eindeutig ist
  — plattformweit oder je Mandant, im Licht von K03-M19 — und mit welcher Meldung die Ablehnung
  gezeigt wird, sagt der Wortlaut nicht; das ergaenzt nach K23-M02 der fachliche Eigentuemer.
· Quelle: K03-M03 Satz 1 ("email und display_name MUESSEN gesetzt sein, die Adresse eindeutig")
  und Satz 2 ("Sie ist der Anmeldename und wird aus der Einladung vorbelegt"); Anker EN-06 ·
  vorschlag_waehlen · Zustand laden, Teilnehmer nach K05-M16. Tritt an die Stelle des Eintrags
  vom 16.08.2026, der den Bestand misst, aber nicht die Anzeige. ·
⟨zeichnet: ⟩ ⟨am: ⟩
```

`☐ gezeichnet   ☐ geändert (Wortlaut unten)   ☐ zurück an den Harness`

---

### K03-M20 · MUSS

> Der Zustandsnachweis MUSS `actor.id` revisionsfest führen. `actor_label` bleibt Anzeige und ist kein Identitätsnachweis.

*Konzept K03, Zeile 280 · Gegenprobe: **ersetzt · erfunden***

**Vorgeschlagenes Kriterium**

```
⟨VORSCHLAG · NICHT GEZEICHNET⟩
ERFUELLT WENN: Jeder Beitrag im INTERVIEW_PROTOCOL-Stand traegt eine actor.id; die actor.id
  eines bereits geschriebenen Beitrags ist nachtraeglich nicht mehr aenderbar; wer gehandelt
  hat, wird allein aus actor.id bestimmt — actor_label weist die handelnde Person nie aus.
GEMESSEN DURCH: Aufbau — zwei Konten desselben Mandanten mit gleichem actor_label und
  verschiedener actor.id, ein Gespraech in Stufe 01. Handlung — mit dem ersten Konto EN-05 ·
  thema_waehlen bis Zustand Erfolg ("Thema als Beitrag im INTERVIEW_PROTOCOL-Stand gefuehrt"),
  danach EN-06 · zwischenspeichern bis Zustand Erfolg. Positivfall: der entstandene Beitrag
  traegt eine actor.id; nach Abmelden, Neuanmelden und Weitermachen traegt derselbe Beitrag
  unveraendert dieselbe actor.id. Negativfall A (revisionsfest): ein Aenderungsversuch an der
  actor.id dieses bereits geschriebenen Beitrags bleibt wirkungslos — der danach gelesene Wert
  ist der alte; Konto, Sitzung, Mandant und Gespraech sind dieselben wie im Positivfall, der
  Versuch scheitert allein an der Revisionsfestigkeit. Negativfall B (actor_label ist kein
  Nachweis): beide Konten schreiben je einen Beitrag; der Zustandsnachweis weist sie trotz
  gleichen actor_label als zwei verschiedene Handelnde aus. Wird das actor_label eines der
  beiden Beitraege auf das andere geaendert, bleibt die ausgewiesene handelnde Person dieselbe —
  oder der Aenderungsversuch wird abgewiesen; wechselt die ausgewiesene Person mit dem
  actor_label, ist die Klausel verletzt. Der Fall scheitert allein daran, dass actor_label kein
  Identitaetsnachweis ist; Berechtigung, Sitzung und Speicherweg sind unveraendert in Ordnung.
  Welche Ablage den Zustandsnachweis traegt, in welcher Form die Unveraenderlichkeit belegt wird
  und mit welcher Meldung der Aenderungsversuch abgewiesen wird, sagt der Wortlaut nicht — das
  ergaenzt nach K23-M02 der fachliche Eigentuemer.
· Quelle: K03-M20 Satz 1 ("MUSS actor.id revisionsfest fuehren") und Satz 2 ("actor_label bleibt
  Anzeige und ist kein Identitaetsnachweis"); Anker EN-05 · thema_waehlen · Zustand Erfolg und
  EN-06 · zwischenspeichern · Zustand Erfolg; je Beitrag actor.id nach K05-M25. ·
⟨zeichnet: ⟩ ⟨am: ⟩
```

`☐ gezeichnet   ☐ geändert (Wortlaut unten)   ☐ zurück an den Harness`

---

### K04 — 2 Klauseln (2 von der Gegenprobe gehalten, 0 ersetzt)

---

### K04-G04 · GILT

> Es GILT fail-closed: Ist das Ergebnis OFFEN, fehlt eine Antwort oder ist der Check nicht lesbar, wird gesperrt statt zugelassen.

*Konzept K04, Zeile 87 · Gegenprobe: gehalten*

**Vorgeschlagenes Kriterium**

```
⟨VORSCHLAG · NICHT GEZEICHNET⟩
ERFUELLT WENN: Ist das Ergebnis des Checks OFFEN, fehlt eine Antwort oder ist der Check nicht
  lesbar, wird die davon abhaengige Aktion gesperrt statt zugelassen — in allen drei Faellen und
  ohne Ausnahme.
GEMESSEN DURCH: Aufbau: angemeldetes Konto, eigener Mandant, EN-05 aufgerufen; die Vorbedingung
  der Aktion ist ein fit_check mit outcome GEEIGNET. Positivfall — EN-05 · thema_waehlen ·
  Zustand Erfolg: der fit_check traegt GEEIGNET, ein Thema wird gewaehlt; erwartete Beobachtung:
  das Thema wird als Beitrag gefuehrt und steht rechts im Stand. Negativfall an derselben
  Bedingung, dreifach gefahren: (a) outcome ist OFFEN, (b) eine Antwort des Checks fehlt, (c)
  der Check ist nicht lesbar. In jedem der drei Faelle wird thema_waehlen ausgeloest; erwartete
  Beobachtung jedes Mal: die Aktion wird gesperrt statt zugelassen, es entsteht kein Beitrag und
  rechts kein Eintrag. Der Prueffall ist gescheitert, sobald einer der drei Faelle durchlaeuft.
  Einen Meldungswortlaut nennt die Klausel nicht; ihn legt der fachliche Eigentuemer fest.
· Quelle: „Es GILT fail-closed: Ist das Ergebnis OFFEN, fehlt eine Antwort oder ist der Check
  nicht lesbar, wird gesperrt statt zugelassen." ·
⟨zeichnet: ⟩ ⟨am: ⟩
```

`☐ gezeichnet   ☐ geändert (Wortlaut unten)   ☐ zurück an den Harness`

---

### K04-M11 · MUSS

> Das Ergebnis MUSS in `fit_check.outcome` stehen und einen der Werte OFFEN, GEEIGNET, NICHT_GEEIGNET führen. Vorgabe ist OFFEN.

*Konzept K04, Zeile 48 · Gegenprobe: gehalten*

**Vorgeschlagenes Kriterium**

```
⟨VORSCHLAG · NICHT GEZEICHNET⟩
ERFUELLT WENN: Das Ergebnis steht in fit_check.outcome; das Feld fuehrt ausschliesslich einen
  der drei Werte OFFEN, GEEIGNET, NICHT_GEEIGNET, und ein fit_check, dessen Ergebnis noch nicht
  gesetzt wurde, liest OFFEN.
GEMESSEN DURCH: Aufbau: ein Konto mit eigenem Mandanten. Positivfall in drei Schritten: (1) ein
  fit_check wird angelegt, ohne das Ergebnis zu setzen; erwartete Beobachtung: fit_check.outcome
  liest OFFEN. (2) outcome wird auf GEEIGNET gesetzt; erwartete Beobachtung: der Wert steht in
  fit_check.outcome, und EN-05 · thema_waehlen erreicht mit dieser Vorbedingung den Zustand
  Erfolg. (3) outcome wird auf NICHT_GEEIGNET gesetzt; erwartete Beobachtung: auch dieser Wert
  wird angenommen und steht in fit_check.outcome. Negativfall an derselben Bedingung: es wird
  versucht, in fit_check.outcome einen Wert zu schreiben, der keiner der drei genannten ist;
  erwartete Beobachtung: der Schreibversuch wird abgewiesen, und fit_check.outcome liest
  unveraendert den vorherigen Wert. Der Prueffall ist gescheitert, wenn ein vierter Wert im Feld
  steht oder ein neuer fit_check ohne gesetztes Ergebnis nicht OFFEN liest. Einen
  Meldungswortlaut nennt die Klausel nicht; ihn legt der fachliche Eigentuemer fest.
· Quelle: „Das Ergebnis MUSS in `fit_check.outcome` stehen und einen der Werte OFFEN, GEEIGNET,
  NICHT_GEEIGNET führen. Vorgabe ist OFFEN." ·
⟨zeichnet: ⟩ ⟨am: ⟩
```

`☐ gezeichnet   ☐ geändert (Wortlaut unten)   ☐ zurück an den Harness`

---

### K05 — 51 Klauseln (28 von der Gegenprobe gehalten, 23 ersetzt)

---

### K05-D01 · DARF NICHT

> Eine übersprungene Frage DARF NICHT spurlos verschwinden. Der Vermerk bleibt sichtbar und geht in das Protokoll ein.

*Konzept K05, Zeile 77 · Gegenprobe: gehalten*

**Vorgeschlagenes Kriterium**

```
⟨VORSCHLAG · NICHT GEZEICHNET⟩
ERFUELLT WENN: Nach dem Ueberspringen einer Fachfrage steht der Uebersprungvermerk sichtbar in
  der rechten Spalte und geht in das Protokoll ein; scheitert das Schreiben des Vermerks, bleibt
  die Frage offen stehen. In keinem der beiden Faelle verschwindet die Frage spurlos.
GEMESSEN DURCH: Aufbau: angemeldete Sitzung, eigener Mandant, EN-06 mit gestellter Fachfrage.
  Positivfall: 'Diese Frage ignorieren' ausloesen — rechts erscheint der Vermerk; er steht nach
  dem Neuladen und nach Abmelden, erneutem Anmelden und Weitermachen unveraendert dort und ist
  im gespeicherten Gespraechsstand enthalten. Negativfall: derselbe Aufruf bei gueltiger
  Anmeldung, eigenem Mandanten und offener, nicht abgeschlossener Frage, aber nicht schreibbarem
  Vermerk — erwartete Beobachtung nach EN-06 · frage_ignorieren · Zustand Fehler: abgelehnt, die
  Frage bleibt offen stehen. NICHT ERFUELLT, wenn die Frage danach weder als Vermerk noch als
  offene Frage sichtbar ist oder der Vermerk im Protokoll fehlt. Der Negativfall zaehlt nur,
  wenn er am Schreiben des Vermerks scheitert, nicht an Anmeldung, Mandant, Rolle oder
  abgeschlossenem Gespraech; eine Fehlermeldung im Wortlaut nennt die Klausel nicht, die
  erwartete Beobachtung stammt aus dem gezeichneten Zustand Fehler.
· Quelle: „Eine übersprungene Frage DARF NICHT spurlos verschwinden. Der Vermerk bleibt sichtbar
  und geht in das Protokoll ein."
· K23-M02: das Akzeptanzkriterium liefert der fachliche Eigentuemer — dieser Vorschlag nimmt ihm
  die Schreibarbeit ab, nicht die Entscheidung.
⟨zeichnet: ⟩ ⟨am: ⟩
```

`☐ gezeichnet   ☐ geändert (Wortlaut unten)   ☐ zurück an den Harness`

---

### K05-D02 · DARF NICHT

> Eine KI-Notiz DARF NICHT als eigene Angabe des Nutzers erscheinen, und eine eigene Angabe DARF NICHT als KI-Notiz erscheinen. An einem inhaltlichen Eintrag ist eine gemischte oder fehlende Marke unzulässig. Der Übersprungvermerk DARF NICHT als Träger für Gesprächsinhalt benutzt werden — sonst umginge er die Markenpflicht.

*Konzept K05, Zeile 78 · Gegenprobe: gehalten*

**Vorgeschlagenes Kriterium**

```
⟨VORSCHLAG · NICHT GEZEICHNET⟩
ERFUELLT WENN: Jeder inhaltliche Eintrag der rechten Spalte traegt genau eine Herkunftsmarke;
  eine eigene Angabe des Nutzers traegt nie die Marke der KI-Notiz und eine KI-Notiz nie die
  Marke der eigenen Angabe; ein Eintrag mit gemischter oder fehlender Marke entsteht nicht; der
  Uebersprungvermerk traegt keinen Gespraechsinhalt.
GEMESSEN DURCH: Aufbau: angemeldete Sitzung, EN-06 mit gestellter Fachfrage. Positivfall: (a)
  Freitextantwort senden — Eintrag rechts mit der Marke der eigenen Angabe, genau eine Marke;
  (b) eine KI-Notiz entstehen lassen — Eintrag rechts mit der Marke der KI-Notiz, genau eine;
  (c) Frage ueberspringen — rechts steht ausschliesslich der Uebersprungwortlaut ohne Marke und
  ohne weiteren Text; alle drei Beobachtungen wiederholen nach Abmelden und Weitermachen.
  Negativfall: ein inhaltlicher Eintrag, dessen Marke nicht eindeutig bestimmbar ist, bei
  gueltiger Sitzung, offener Frage und nicht leerem Inhalt — erwartete Beobachtung nach EN-06 ·
  vorschlag_waehlen · Zustand Fehler: kein Eintrag rechts, Meldung, die Antwort bleibt waehlbar.
  NICHT ERFUELLT, wenn der Eintrag ohne Marke, mit zwei Marken oder mit der Marke der jeweils
  anderen Herkunft entsteht oder wenn Gespraechsinhalt im Uebersprungvermerk steht. Der
  Fehlschlag muss an der Marke liegen, nicht an Anmeldung, Mandant oder leerem Feld.
· Quelle: „Eine KI-Notiz DARF NICHT als eigene Angabe des Nutzers erscheinen, und eine eigene
  Angabe DARF NICHT als KI-Notiz erscheinen. An einem inhaltlichen Eintrag ist eine gemischte
  oder fehlende Marke unzulässig. Der Übersprungvermerk DARF NICHT als Träger für
  Gesprächsinhalt benutzt werden"
· K23-M02: das Akzeptanzkriterium liefert der fachliche Eigentuemer — dieser Vorschlag nimmt ihm
  die Schreibarbeit ab, nicht die Entscheidung.
⟨zeichnet: ⟩ ⟨am: ⟩
```

`☐ gezeichnet   ☐ geändert (Wortlaut unten)   ☐ zurück an den Harness`

---

### K05-D04 · DARF NICHT

> Der Namensvorschlag DARF NICHT ohne Marke erscheinen und DARF NICHT unveränderbar sein.

*Konzept K05, Zeile 80 · Gegenprobe: gehalten*

**Vorgeschlagenes Kriterium**

```
⟨VORSCHLAG · NICHT GEZEICHNET⟩
ERFUELLT WENN: Der Namensvorschlag erscheint nur mit seiner Marke, und das Feld, in dem er
  steht, ist ueberschreibbar: ein vom Nutzer geaenderter Name wird uebernommen.
GEMESSEN DURCH: Aufbau: angemeldete Sitzung, eigener Mandant, EN-05 bis zum Namensschritt
  gefuehrt (Ausgangsproblem bestaetigt). Positivfall: den Schritt aufrufen — der Vorschlag
  erscheint im gefuellten Feld und traegt die Marke; den Vorschlag durch einen eigenen Wortlaut
  ersetzen und bestaetigen — der eigene Wortlaut ist gespeichert und wird nach Abmelden,
  erneutem Anmelden und Weitermachen unveraendert angezeigt. Negativfall: den Schritt mit
  fehlender Marke am Vorschlag ausfuehren, bei gueltiger Anmeldung, eigenem Mandanten,
  vorhandenem Schreibrecht und nicht leerem Feld — erwartete Beobachtung nach EN-05 ·
  name_bestaetigen · Zustand leer: abgelehnt, die Stufe bleibt ORIENTIERUNG. NICHT ERFUELLT,
  wenn der Vorschlag ohne Marke erscheint oder das Feld den eigenen Wortlaut nicht annimmt. Der
  Negativfall zaehlt nur, wenn er an der fehlenden Marke scheitert und nicht an leerem Feld,
  Rechten oder Mandant.
· Quelle: „Der Namensvorschlag DARF NICHT ohne Marke erscheinen und DARF NICHT unveränderbar
  sein."
· K23-M02: das Akzeptanzkriterium liefert der fachliche Eigentuemer — dieser Vorschlag nimmt ihm
  die Schreibarbeit ab, nicht die Entscheidung.
⟨zeichnet: ⟩ ⟨am: ⟩
```

`☐ gezeichnet   ☐ geändert (Wortlaut unten)   ☐ zurück an den Harness`

---

### K05-D05 · DARF NICHT

> Die Vorschläge in Stufe 02 DÜRFEN NICHT die Antwortmenge begrenzen. Frei eingetippter Text wird gleichwertig aufgenommen.

*Konzept K05, Zeile 81 · Gegenprobe: **ersetzt · negativfall_fehlt_oder_fremd***

**Vorgeschlagenes Kriterium**

```
⟨VORSCHLAG · NICHT GEZEICHNET⟩
ERFUELLT WENN: Eine frei eingetippte Antwort in Stufe 02, die mit keinem der angebotenen
  Vorschlaege uebereinstimmt, wird gleichwertig aufgenommen: sie laeuft ueber denselben
  Serverbefehl record_interview_answer wie eine gewaehlte Antwort, erzeugt ebenso einen Eintrag
  in der rechten Spalte mit der Marke Ihre Angabe und steht dort zeichengleich im eingetippten
  Wortlaut; die Menge der zulaessigen Antworten wird durch die Vorschlaege nicht eingeschraenkt.
GEMESSEN DURCH: Aufbau: angemeldete Sitzung, eigener Mandant, EN-06 mit offener Fachfrage und
  angebotenen Vorschlaegen, nicht leeres Freitextfeld. Positivfall: dieselbe Frage in zwei
  Laeufen beantworten — Lauf A mit einem angebotenen Vorschlag (EN-06 · vorschlag_waehlen ·
  Zustand Erfolg: Eintrag rechts mit genau einer Herkunftsmarke), Lauf B mit einem eigenen, mit
  keinem Vorschlag uebereinstimmenden Wortlaut (EN-06 · freitext_antworten · Zustand Erfolg:
  Eintrag rechts mit Marke Ihre Angabe); beide Eintraege stehen nach zwischenspeichern,
  Abmelden, erneutem Anmelden und Weitermachen unveraendert und zeichengleich. Negativfall mit
  eigenem Aufbau (Wirksamkeitsnachweis): Lauf B gegen einen Stand fahren, in dem der
  Serverbefehl die Antwort gegen die Vorschlagsliste prueft (Listenzwang eingespielt), bei
  gueltiger Anmeldung, eigenem Mandanten, offener Frage und nicht leerem Feld — erwartete
  Beobachtung: die Antwort wird abgewiesen oder auf einen der Vorschlaege zurueckgefuehrt, und
  der Prueffall meldet NICHT ERFUELLT; meldet er das nicht, misst der Positivfall nichts.
  Scheitert ein Lauf statt dessen an leerem Feld, geschlossener Frage, Anmeldung oder Mandant,
  misst er eine fremde Bedingung; scheitert er nach EN-06 · freitext_antworten · Zustand Fehler
  an Maskierung oder Modellpfad, misst er K05-G01 und nicht diese Klausel.
· Quelle: „Die Vorschläge in Stufe 02 DÜRFEN NICHT die Antwortmenge begrenzen. Frei eingetippter
  Text wird gleichwertig aufgenommen."
· K23-M02: das Akzeptanzkriterium liefert der fachliche Eigentuemer — dieser Vorschlag nimmt ihm
  die Schreibarbeit ab, nicht die Entscheidung.
⟨zeichnet: ⟩ ⟨am: ⟩
```

`☐ gezeichnet   ☐ geändert (Wortlaut unten)   ☐ zurück an den Harness`

---

### K05-D06 · DARF NICHT

> Der Nutzer DARF NICHT eine Stufe überspringen oder eine spätere Stufe anspringen. Zurückliegende Stufen öffnen sich ausschließlich als Nur-Ansicht (K01 Abschn. 3).

*Konzept K05, Zeile 82 · Gegenprobe: gehalten*

**Vorgeschlagenes Kriterium**

```
⟨VORSCHLAG · NICHT GEZEICHNET⟩
ERFUELLT WENN: Eine Stufe wird nicht uebersprungen und keine spaetere Stufe angesprungen: eine
  Aktion einer spaeteren Stufe wird abgewiesen, solange die Stufe des Gespraechs sie nicht
  erreicht hat, und der Stufenwechsel wird serverseitig gesetzt, nie vom Client uebergeben; eine
  zurueckliegende Stufe oeffnet sich nur als Nur-Ansicht, ihre Aktionen schreiben nichts.
GEMESSEN DURCH: Aufbau: zwei angemeldete Sitzungen desselben Mandanten, eine Anwendung in
  ORIENTIERUNG, eine in INTERVIEW. Positivfall: in der Anwendung in INTERVIEW die
  zurueckliegende Stufe EN-05 oeffnen — der Stand ist lesbar, jede Aktion von EN-05 schreibt
  nichts; Datenstand vorher und nachher gleich. Negativfall: in der Anwendung in ORIENTIERUNG
  eine Aktion von EN-06 aufrufen, bei gueltiger Anmeldung, eigenem Mandanten, ausreichender
  Rolle und vorhandenem Objektbezug — erwartet: abgewiesen, journey_phase unveraendert
  ORIENTIERUNG, kein Eintrag rechts; zweiter Negativfall: eine Stufe vom Client mit uebergeben —
  sie wird nicht uebernommen, die Stufe folgt allein dem serverseitigen Wechsel. NICHT ERFUELLT,
  wenn die Aktion durchgeht oder die uebergebene Stufe wirkt. Beide Faelle zaehlen nur, wenn
  alle uebrigen Vorbedingungen erfuellt sind, damit sie an der Stufenfolge scheitern.
· Quelle: „Der Nutzer DARF NICHT eine Stufe überspringen oder eine spätere Stufe anspringen.
  Zurückliegende Stufen öffnen sich ausschließlich als Nur-Ansicht"
· K23-M02: das Akzeptanzkriterium liefert der fachliche Eigentuemer — dieser Vorschlag nimmt ihm
  die Schreibarbeit ab, nicht die Entscheidung.
⟨zeichnet: ⟩ ⟨am: ⟩
```

`☐ gezeichnet   ☐ geändert (Wortlaut unten)   ☐ zurück an den Harness`

---

### K05-D07 · DARF NICHT

> Der Inhalt des Nebenfragen-Fensters DARF NICHT in die rechte Spalte, in eine Anforderung oder in ein Dokument einfließen (Eigentümer K16).

*Konzept K05, Zeile 83 · Gegenprobe: **ersetzt · negativfall_fehlt_oder_fremd***

**Vorgeschlagenes Kriterium**

```
⟨VORSCHLAG · NICHT GEZEICHNET⟩
ERFUELLT WENN: Kein Inhalt, der im Nebenfragen-Fenster eingegeben oder dort ausgegeben wurde,
  erscheint in der rechten Spalte, in einer Anforderung oder in einem Dokument; der
  Bildschirmvertrag fuehrt fuer das Fenster in EN-05 und EN-06 keinen Serverbefehl, ueber den
  sein Inhalt in den Gespraechsstand gelangen koennte.
GEMESSEN DURCH: Aufbau: angemeldete Sitzung, eigener Mandant, EN-06 mit offener Fachfrage; zwei
  eindeutige, sonst nirgends vorkommende Erkennungstexte T1 und T2. Positivfall: T1
  ausschliesslich im Nebenfragen-Fenster eingeben, das Gespraech fortsetzen, zwischenspeichern
  bis EN-06 · zwischenspeichern · Zustand Erfolg, danach rechte Spalte, Anforderungen und den
  gespeicherten Dokumentstand nach T1 durchsuchen — kein Treffer, auch nicht nach Abmelden,
  erneutem Anmelden und Weitermachen. Negativfall mit eigenem Aufbau (Wirksamkeitsnachweis der
  Suche): T2 als regulaere Freitextantwort ueber freitext_antworten senden bis Zustand Erfolg
  und dieselbe Suche fahren — T2 MUSS in der rechten Spalte und im gespeicherten Dokumentstand
  gefunden werden; wird T2 dort nicht gefunden, scheitert der Prueffall an sich selbst: die
  Suche misst dann sich selbst und nicht die Klausel, und der Positivlauf belegt nichts. NICHT
  ERFUELLT, wenn T1 in einem der drei Ziele gefunden wird. Der Positivlauf zaehlt nur, wenn das
  Nebenfragen-Fenster tatsaechlich bedient wurde und zwischenspeichern den Zustand Erfolg
  erreicht hat; ein an Anmeldung, Mandant oder gescheitertem Speichern abgebrochener Lauf misst
  diese Klausel nicht.
· Quelle: „Der Inhalt des Nebenfragen-Fensters DARF NICHT in die rechte Spalte, in eine
  Anforderung oder in ein Dokument einfließen (Eigentümer K16)."
· K23-M02: das Akzeptanzkriterium liefert der fachliche Eigentuemer — dieser Vorschlag nimmt ihm
  die Schreibarbeit ab, nicht die Entscheidung.
⟨zeichnet: ⟩ ⟨am: ⟩
```

`☐ gezeichnet   ☐ geändert (Wortlaut unten)   ☐ zurück an den Harness`

---

### K05-D08 · DARF NICHT

> Kein Bildschirm der Stufen 01 und 02 DARF einen Betrag zeigen. Das Endnutzer-Portal führt keinen; die Angebotsangaben sind Felder des EXMA-Portals (K01 Abschn. 3).

*Konzept K05, Zeile 84 · Gegenprobe: **ersetzt · erfunden***

**Vorgeschlagenes Kriterium**

```
⟨VORSCHLAG · NICHT GEZEICHNET⟩
ERFUELLT WENN: Auf keinem Bildschirm der Stufen 01 und 02 — EN-05 und EN-06 — wird ein Betrag
  ausgegeben: in keinem der zu einer Aktion tatsaechlich gezeichneten Zustaende (laden, leer,
  Erfolg, Fehler; bei frage_ignorieren, zwischenspeichern und interview_beenden ist der Zustand
  leer als entfaellt gezeichnet) erscheint eine Angebotsangabe als Feld, als Text oder als Wert.
GEMESSEN DURCH: Aufbau: angemeldete Sitzung, eigener Mandant, eine Anwendung, zu der ein
  Angebotsbetrag hinterlegt und im EXMA-Portal lesbar ist; die zurueckgestellte Aktion
  datei_anhaengen bleibt ausgenommen
· Stufe: zurueckgestellt (Blatt 100, E4). Positivfall: jede im Bildschirmvertrag gefuehrte
  Aktion von EN-05 und EN-06 in jedem fuer sie gezeichneten Zustand aufrufen und die ausgegebene
  Seite sichten und nach dem hinterlegten Betrag in seiner Schreibweise durchsuchen — kein
  Treffer, auch nicht nach Abmelden, erneutem Anmelden und Weitermachen. Negativfall mit eigenem
  Aufbau (Wirksamkeitsnachweis): denselben Betrag an seiner zustaendigen Stelle im EXMA-Portal
  aufrufen und mit derselben Suche pruefen — er MUSS dort gefunden werden; wird er auch dort
  nicht gefunden, scheitert der Prueffall an sich selbst und der Positivlauf belegt nichts, weil
  dann die Suche und nicht die Klausel gemessen wurde. NICHT ERFUELLT, wenn der Betrag auf einem
  gezeichneten Zustand von EN-05 oder EN-06 erscheint. Ein Lauf ohne hinterlegten Betrag misst
  diese Klausel nicht.
· Quelle: „Kein Bildschirm der Stufen 01 und 02 DARF einen Betrag zeigen. Das Endnutzer-Portal
  führt keinen; die Angebotsangaben sind Felder des EXMA-Portals"
· K23-M02: das Akzeptanzkriterium liefert der fachliche Eigentuemer — dieser Vorschlag nimmt ihm
  die Schreibarbeit ab, nicht die Entscheidung.
⟨zeichnet: ⟩ ⟨am: ⟩
```

`☐ gezeichnet   ☐ geändert (Wortlaut unten)   ☐ zurück an den Harness`

---

### K05-D09 · DARF NICHT

> Eine Aufnahme des Stimmwegs DARF NICHT ohne freigegebenen Zweck, ohne Verarbeitung im EU-Raum und ohne Maskierung weitergegeben werden (K13 Abschn. 3, K17).

*Konzept K05, Zeile 85 · Gegenprobe: **ersetzt · erfunden***

**Vorgeschlagenes Kriterium**

```
⟨VORSCHLAG · NICHT GEZEICHNET⟩
ERFUELLT WENN: Aus den Stufen 01 und 02 geht keine Aufnahme des Stimmwegs hinaus — der
  Bildschirmvertrag fuehrt fuer EN-05 und EN-06 keinen Serverbefehl, der eine Aufnahme
  weitergibt; diktierter Text ist vor dem Senden sichtbar und aenderbar und laeuft als Freitext
  ueber record_interview_answer, und vor jedem Modellaufruf werden die personenbezogenen Angaben
  maskiert; ist die Maskierung oder der Modellpfad unvollstaendig, findet kein Aufruf statt.
GEMESSEN DURCH: Aufbau: angemeldete Sitzung, eigener Mandant, EN-06 mit offener Fachfrage,
  diktierte Antwort mit personenbezogenen Angaben im Wortlaut, mitgeschriebener ausgehender
  Verkehr. Positivfall: die diktierte Antwort vor dem Senden sichten und aendern, dann senden
  bis EN-06 · freitext_antworten · Zustand Erfolg — im mitgeschriebenen Verkehr steht kein Ton-
  und kein Aufnahmeinhalt, und die personenbezogenen Angaben des Wortlauts erscheinen im
  ausgehenden Inhalt nur maskiert; der Eintrag rechts traegt die Marke Ihre Angabe und steht
  nach Abmelden, erneutem Anmelden und Weitermachen unveraendert. Negativfall: denselben Lauf
  mit unvollstaendiger Maskierung fahren, bei gueltiger Anmeldung, eigenem Mandanten, offener
  Frage und nicht leerem Feld — erwartete Beobachtung nach EN-06 · freitext_antworten · Zustand
  Fehler: kein Aufruf, die Frage bleibt unbeantwortet stehen; im mitgeschriebenen Verkehr steht
  nichts. Der Fall zaehlt nur, wenn er an der Maskierung scheitert und nicht an Anmeldung,
  Mandant oder leerem Feld. Freigegebener Zweck und Verarbeitung im EU-Raum sind in K13 Abschn.
  3 und K17 geregelt; welcher Nachweis dort als freigegebener Zweck und als Verarbeitungsort
  gilt und wo er beobachtbar ist, legt der fachliche Eigentuemer fest — der Bildschirmvertrag
  zeichnet dafuer in EN-05 und EN-06 keinen Zustand.
· Quelle: „Eine Aufnahme des Stimmwegs DARF NICHT ohne freigegebenen Zweck, ohne Verarbeitung im
  EU-Raum und ohne Maskierung weitergegeben werden (K13 Abschn. 3, K17)."
· K23-M02: das Akzeptanzkriterium liefert der fachliche Eigentuemer — dieser Vorschlag nimmt ihm
  die Schreibarbeit ab, nicht die Entscheidung.
⟨zeichnet: ⟩ ⟨am: ⟩
```

`☐ gezeichnet   ☐ geändert (Wortlaut unten)   ☐ zurück an den Harness`

---

### K05-D10 · DARF NICHT

> K05 DARF keine Tabelle und keine Sicht besitzen oder beschreiben. Namen fremder Objekte erscheinen ausschließlich als Verweis auf das zuständige Konzept.

*Konzept K05, Zeile 86 · Gegenprobe: **ersetzt · nicht_messbar***

**Vorgeschlagenes Kriterium**

```
⟨VORSCHLAG · NICHT GEZEICHNET⟩
ERFUELLT WENN: Der K05-Text fuehrt keine eigene Tabelle und keine eigene Sicht — er enthaelt
  keine Objektdefinition, keine Spaltenliste und keine Sichtbeschreibung; jeder darin genannte
  Objektname steht ausschliesslich als Verweis auf das zustaendige Konzept, so wie der
  Bildschirmvertrag ihn fuehrt: Traeger document mit Eigentuemer K10, app.name und
  app.journey_phase mit Eigentuemer K01, Protokolleintrag in event nach K02.
GEMESSEN DURCH: Aufbau: der gezeichnete K05-Text in der geltenden Fassung und der
  Bildschirmvertrag zu EN-05 und EN-06. Positivfall: den K05-Text Stelle fuer Stelle durchgehen
  und jede Nennung eines Datenobjekts auflisten — zu jeder Nennung ist das zustaendige Konzept
  genannt, keine Stelle beschreibt Aufbau, Spalten oder Inhalt eines Objekts, und die Liste
  enthaelt keine Tabelle und keine Sicht, fuer die kein anderes Konzept benannt ist. Negativfall
  mit eigenem Aufbau (Wirksamkeitsnachweis): in einer Arbeitskopie des K05-Textes bei genau
  einer dieser Nennungen den Verweis auf das zustaendige Konzept streichen und dieselbe
  Durchsicht wiederholen — sie MUSS genau diese Stelle beanstanden; beanstandet sie sie nicht,
  scheitert der Prueffall an sich selbst und der Positivlauf belegt nichts. NICHT ERFUELLT, wenn
  der K05-Text ein Objekt ohne Verweis nennt oder ein Objekt beschreibt. Ein Lauf am gebauten
  Datenbestand misst diese Klausel nicht: welchem Konzept eine Tabelle oder Sicht zugeordnet
  ist, ist am Bestand nicht beobachtbar.
· Quelle: „K05 DARF keine Tabelle und keine Sicht besitzen oder beschreiben. Namen fremder
  Objekte erscheinen ausschließlich als Verweis auf das zuständige Konzept."
· K23-M02: das Akzeptanzkriterium liefert der fachliche Eigentuemer — dieser Vorschlag nimmt ihm
  die Schreibarbeit ab, nicht die Entscheidung.
⟨zeichnet: ⟩ ⟨am: ⟩
```

`☐ gezeichnet   ☐ geändert (Wortlaut unten)   ☐ zurück an den Harness`

---

### K05-D11 · DARF NICHT

> Neben `app.journey_phase` DARF kein zweiter Strang für den Stand des Gesprächs entstehen — kein gespiegeltes Feld, kein Zähler, keine abgeleitete Spalte (Eigentümer K01).

*Konzept K05, Zeile 87 · Gegenprobe: **ersetzt · negativfall_fehlt_oder_fremd***

**Vorgeschlagenes Kriterium**

```
⟨VORSCHLAG · NICHT GEZEICHNET⟩
ERFUELLT WENN: Der Stand des Gespraechs wird allein aus app.journey_phase gefuehrt: kein zweites
  gespeichertes Feld, kein Zaehler und keine abgeleitete Spalte fuehrt ihn ebenfalls, und jede
  im Bildschirmvertrag gezeichnete Stelle, die den Stand anzeigt oder auf ihn hin entscheidet,
  folgt dem Wert in app.journey_phase.
GEMESSEN DURCH: Aufbau: angemeldete Sitzung, eigener Mandant, ein Gespraech in ORIENTIERUNG; als
  standtragende Stellen gelten die gezeichneten: die Stufenanzeige in EN-05 und EN-06, die
  Erreichbarkeit von EN-06 nach EN-05 · name_bestaetigen · Zustand Erfolg und die Uebergabe in
  EN-06 · interview_beenden. Positivfall: den Namen bestaetigen — app.journey_phase steht auf
  INTERVIEW und alle genannten Stellen zeigen INTERVIEW; danach app.journey_phase unmittelbar am
  Bestand auf ORIENTIERUNG zuruecksetzen und dieselben Stellen erneut lesen, auch nach Abmelden,
  erneutem Anmelden und Weitermachen — alle folgen dem geaenderten Wert, keine haelt einen
  eigenen. Negativfall: name_bestaetigen so fahren, dass der Schreibbefehl oder der
  Protokolleintrag scheitert, bei gueltiger Anmeldung, eigenem Mandanten, ausreichender Rolle
  und gefuelltem, markiertem Feld — erwartete Beobachtung nach EN-05 · name_bestaetigen ·
  Zustand Fehler: alles zurueckgerollt, kein Teilwechsel, Stufe bleibt ORIENTIERUNG; zeigt
  danach eine der genannten Stellen INTERVIEW, waehrend app.journey_phase ORIENTIERUNG traegt,
  besteht ein zweiter Strang und das Kriterium ist NICHT ERFUELLT. Nicht als zweiter Strang gilt
  der gezeichnete Protokolleintrag in event: er haelt die Aenderung als Spur fest und wird nicht
  als aktueller Stand gelesen. Der Negativfall zaehlt nur, wenn er am Schreibbefehl oder am
  Protokolleintrag scheitert und nicht an Anmeldung, Rolle, Mandant oder leerem Feld.
· Quelle: „Neben `app.journey_phase` DARF kein zweiter Strang für den Stand des Gesprächs
  entstehen — kein gespiegeltes Feld, kein Zähler, keine abgeleitete Spalte"
· K23-M02: das Akzeptanzkriterium liefert der fachliche Eigentuemer — dieser Vorschlag nimmt ihm
  die Schreibarbeit ab, nicht die Entscheidung.
⟨zeichnet: ⟩ ⟨am: ⟩
```

`☐ gezeichnet   ☐ geändert (Wortlaut unten)   ☐ zurück an den Harness`

---

### K05-D12 · DARF NICHT

> Der freihändige Stimmweg DARF NICHT betrieben werden, solange für ihn kein eigener, bewerteter Fall freigegeben ist (F31). Die Erfüllung von Zweck, Verarbeitungsort und Maskierung ersetzt diese Freigabe nicht — sie sind ihre Voraussetzung, nicht ihr Ersatz. Bis dahin bleibt die Bedienung ausgeblendet, und der Serverpfad weist den Aufruf ab.

*Konzept K05, Zeile 88 · Gegenprobe: gehalten*

**Vorgeschlagenes Kriterium**

```
⟨VORSCHLAG · NICHT GEZEICHNET⟩
ERFUELLT WENN: Solange fuer den freihaendigen Stimmweg kein eigener, bewerteter Fall freigegeben
  ist, ist seine Bedienung auf dem Bildschirm nicht vorhanden und der Serverpfad weist jeden
  Aufruf ab; erfuellter Zweck, Verarbeitung im EU-Raum und Maskierung aendern daran nichts.
GEMESSEN DURCH: Aufbau: angemeldete Sitzung, eigener Mandant, EN-06, kein freigegebener
  bewerteter Fall fuer den freihaendigen Stimmweg. Positivfall: EN-06 in allen Zustaenden
  aufrufen — es erscheint keine Bedienung fuer den freihaendigen Stimmweg (diktierter Text
  laeuft nur ueber das Freitextfeld und ist vor dem Senden sichtbar und aenderbar). Negativfall:
  den Serverpfad des freihaendigen Stimmwegs unmittelbar aufrufen, bei gueltiger Anmeldung,
  eigenem Mandanten, ausreichender Rolle, vorhandenem Objektbezug und zugleich erfuelltem Zweck,
  Verarbeitung im EU-Raum und Maskierung — erwartet: der Aufruf wird abgewiesen, nichts wird
  gespeichert und nichts weitergegeben. NICHT ERFUELLT, wenn der Aufruf durchgeht oder die
  Bedienung sichtbar ist. Der Fall zaehlt nur, wenn die drei Voraussetzungen erfuellt sind,
  damit er allein an der fehlenden Freigabe scheitert.
· Quelle: „Der freihändige Stimmweg DARF NICHT betrieben werden, solange für ihn kein eigener,
  bewerteter Fall freigegeben ist (F31). Die Erfüllung von Zweck, Verarbeitungsort und
  Maskierung ersetzt diese Freigabe nicht"
· K23-M02: das Akzeptanzkriterium liefert der fachliche Eigentuemer — dieser Vorschlag nimmt ihm
  die Schreibarbeit ab, nicht die Entscheidung.
⟨zeichnet: ⟩ ⟨am: ⟩
```

`☐ gezeichnet   ☐ geändert (Wortlaut unten)   ☐ zurück an den Harness`

---

### K05-G01 · GILT

> Es GILT fail-closed: Ist eine Vorbedingung nicht erfüllt oder nicht prüfbar, wird gesperrt statt zugelassen. Die Sperre wird begründet angezeigt (K01 Abschn. 3).

*Konzept K05, Zeile 94 · Gegenprobe: **ersetzt · negativfall_fehlt_oder_fremd***

**Vorgeschlagenes Kriterium**

```
⟨VORSCHLAG · NICHT GEZEICHNET⟩
ERFUELLT WENN: Ist eine Vorbedingung einer Aktion der Stufen 01 oder 02 erfuellt und pruefbar,
  laeuft die Aktion durch; ist sie nicht erfuellt oder nicht pruefbar, wird gesperrt statt
  zugelassen, die Sperre wird mit Begruendung angezeigt, und der Datenstand bleibt unveraendert.
GEMESSEN DURCH: Aufbau: angemeldete Sitzung, eigener Mandant, ausreichende Rolle, vorhandener
  Objektbezug, EN-05 · thema_waehlen. Positivfall: thema_waehlen aufrufen, waehrend ein
  fit_check mit outcome GEEIGNET vorliegt — die Aktion laeuft durch, EN-05 · thema_waehlen ·
  Zustand Erfolg tritt ein (Thema als Beitrag im INTERVIEW_PROTOCOL-Stand gefuehrt), keine
  Sperre erscheint, und der Beitrag steht nach Abmelden, erneutem Anmelden und Weitermachen
  weiter da. Negativfall, zwei Laeufe bei sonst gleichem, gueltigem Aufbau: (a) der fit_check
  traegt nicht das outcome GEEIGNET; (b) das Ergebnis des fit_check ist nicht ermittelbar —
  erwartete Beobachtung je Lauf: die Aktion wird gesperrt, eine Begruendung wird angezeigt, kein
  Beitrag entsteht, und der Datenstand vor und nach dem Aufruf ist gleich. NICHT ERFUELLT, wenn
  in (a) oder (b) durchgelassen wird, wenn die Sperre ohne Begruendung erscheint, oder wenn
  schon der Positivfall sperrt — ein Stand, der auch bei erfuellter und pruefbarer Vorbedingung
  sperrt, erfuellt fail-closed nicht, sondern misst nichts. Beide Negativlaeufe zaehlen nur,
  wenn sie an der Vorbedingung haengen und nicht an Anmeldung, Rolle, Mandant oder Objektbezug.
  Den Wortlaut der Begruendung nennt die Klausel nicht; verlangt ist, dass eine Begruendung
  angezeigt wird.
· Quelle: „Es GILT fail-closed: Ist eine Vorbedingung nicht erfüllt oder nicht prüfbar, wird
  gesperrt statt zugelassen. Die Sperre wird begründet angezeigt"
· K23-M02: das Akzeptanzkriterium liefert der fachliche Eigentuemer — dieser Vorschlag nimmt ihm
  die Schreibarbeit ab, nicht die Entscheidung.
⟨zeichnet: ⟩ ⟨am: ⟩
```

`☐ gezeichnet   ☐ geändert (Wortlaut unten)   ☐ zurück an den Harness`

---

### K05-G02 · GILT

> Es GILT: Branche, Funktionsbereich und Anwendung sind Eingabefelder des Nutzers, keine festgelegten Werte. Eine Zielbranche gibt es nicht; F16 hat sie gestrichen.

*Konzept K05, Zeile 95 · Gegenprobe: **ersetzt · nicht_messbar***

**Vorgeschlagenes Kriterium**

```
⟨VORSCHLAG · NICHT GEZEICHNET⟩
ERFUELLT WENN: Branche, Funktionsbereich und Anwendung sind Eingaben des Nutzers: jede der drei
  Fragen nimmt ueber ihre offene Alternative Andere ... einen eigenen Wortlaut an, der
  zeichengleich uebernommen und rechts unter Branche, Funktion oder Anwendung angezeigt wird und
  nicht durch einen Wert der versionierten Antwortlisten ersetzt wird; keine der drei ist mit
  einem nicht ersetzbaren Wert vorbelegt, und weder Bildschirm noch gespeicherter Stand fuehrt
  ein Feld, eine Ueberschrift oder einen Wert mit der Zeichenfolge Zielbranche.
GEMESSEN DURCH: Aufbau: angemeldete Sitzung, eigener Mandant, EN-05 · einordnung_beantworten in
  der festen Reihenfolge Branche, Funktionsbereich, Anwendung; die geladenen Antwortlisten
  (versionierte Konfigurationsdaten) liegen als Vergleichsmenge vor. Positivfall: jede der drei
  Fragen ueber ihre offene Alternative mit einem eigenen, in den Antwortlisten nicht enthaltenen
  Wortlaut beantworten — jede Antwort erscheint rechts unter ihrer Ueberschrift zeichengleich
  wie eingegeben, mit genau einer Herkunftsmarke, und steht so auch nach Abmelden, erneutem
  Anmelden und Weitermachen; die Suche nach der Zeichenfolge Zielbranche in Bildschirm und
  gespeichertem Stand liefert keinen Treffer. Negativfall mit eigenem Aufbau: dieselbe Eingabe
  bei eingehaltener Reihenfolge, gueltiger Anmeldung, eigenem Mandanten und nicht leerem Feld
  gegen einen Stand fahren, in dem record_classification den Wortlaut gegen die Antwortlisten
  prueft oder ihn auf einen Listenwert normalisiert — erwartete Beobachtung: die Antwort wird
  abgewiesen oder erscheint rechts als Listenwert statt als eingegebener Wortlaut, und der
  Prueffall meldet NICHT ERFUELLT; meldet er das nicht, belegt der Positivlauf nichts. Wird ein
  Lauf nach EN-05 · einordnung_beantworten · Zustand Fehler wegen verletzter Reihenfolge
  abgewiesen oder scheitert er an Anmeldung, Mandant oder leerem Feld, misst er eine fremde
  Bedingung und zaehlt nicht.
· Quelle: „Branche, Funktionsbereich und Anwendung sind Eingabefelder des Nutzers, keine
  festgelegten Werte. Eine Zielbranche gibt es nicht"
· K23-M02: das Akzeptanzkriterium liefert der fachliche Eigentuemer — dieser Vorschlag nimmt ihm
  die Schreibarbeit ab, nicht die Entscheidung.
⟨zeichnet: ⟩ ⟨am: ⟩
```

`☐ gezeichnet   ☐ geändert (Wortlaut unten)   ☐ zurück an den Harness`

---

### K05-G03 · GILT

> Es GILT die Herkunftsregel aus K19 Abschn. 3. K05 setzt sie für die Stufen 01 und 02 um und erfindet sie nicht neu.

*Konzept K05, Zeile 96 · Gegenprobe: **ersetzt · erfunden***

**Vorgeschlagenes Kriterium**

```
⟨VORSCHLAG · NICHT GEZEICHNET⟩
ERFUELLT WENN: Jede in den Stufen 01 und 02 vergebene Herkunftsmarke ist eine der in K19 Abschn.
  3 gefuehrten, und ihre Zuordnung folgt der dortigen Regel; K05 fuehrt fuer diese Stufen keine
  zusaetzliche Marke und keine abweichende Zuordnung ein. Jeder inhaltliche Eintrag traegt genau
  eine Marke; der Uebersprungvermerk traegt gezeichnet keine, weil er kein inhaltlicher Eintrag
  ist.
GEMESSEN DURCH: Aufbau: angemeldete Sitzung, eigener Mandant, EN-05 und EN-06; einmal
  erfolgreich durchlaufen werden die gezeichneten Aktionen ausser der zurueckgestellten
  datei_anhaengen
· Stufe: zurueckgestellt (Blatt 100, E4): thema_waehlen, einordnung_beantworten, ziele_waehlen,
  ausgangsproblem_bestaetigen, name_bestaetigen, vorschlag_waehlen, freitext_antworten,
  frage_ignorieren. Positivfall: die dabei entstandenen Eintraege der rechten Spalte auflisten
  und die vergebenen Marken zu einer Menge zusammenfassen — jede Marke dieser Menge steht in K19
  Abschn. 3; jeder inhaltliche Eintrag traegt genau eine und genau die dort fuer seine Herkunft
  vorgesehene Marke (freitext_antworten: Ihre Angabe; Namensvorschlag in name_bestaetigen: KI-
  Vorschlag); der Eintrag aus frage_ignorieren traegt ausschliesslich den Wortlaut (Frage
  uebersprungen) ohne Marke. Dieselbe Zuordnung steht nach Abmelden, erneutem Anmelden und
  Weitermachen unveraendert. Negativfall: eine Antwort ueber vorschlag_waehlen einreichen, deren
  Marke nicht eindeutig bestimmbar ist, bei gueltiger Anmeldung, eigenem Mandanten, offener
  Frage und nicht leerem Inhalt — erwartete Beobachtung nach EN-06 · vorschlag_waehlen · Zustand
  Fehler: kein Eintrag rechts, Meldung, die Antwort bleibt waehlbar. NICHT ERFUELLT, wenn statt
  dessen ein Eintrag entsteht, der keine, zwei oder eine in K19 Abschn. 3 nicht gefuehrte Marke
  traegt. Der Fall zaehlt nur, wenn er an der Marke scheitert und nicht an Anmeldung, Mandant
  oder leerem Feld. Welche Marken K19 Abschn. 3 fuehrt, ist dort nachzulesen und wird hier nicht
  neu bestimmt.
· Quelle: „Es GILT die Herkunftsregel aus K19 Abschn. 3. K05 setzt sie für die Stufen 01 und 02
  um und erfindet sie nicht neu."
· K23-M02: das Akzeptanzkriterium liefert der fachliche Eigentuemer — dieser Vorschlag nimmt ihm
  die Schreibarbeit ab, nicht die Entscheidung.
⟨zeichnet: ⟩ ⟨am: ⟩
```

`☐ gezeichnet   ☐ geändert (Wortlaut unten)   ☐ zurück an den Harness`

---

### K05-G04 · GILT

> Es GILT: Die Rangfolge der Ziele entsteht aus der Reihenfolge der Auswahl. Sie ist eine Angabe des Nutzers, keine Bewertung des Systems.

*Konzept K05, Zeile 97 · Gegenprobe: gehalten*

**Vorgeschlagenes Kriterium**

```
⟨VORSCHLAG · NICHT GEZEICHNET⟩
ERFUELLT WENN: Die Rangfolge der Ziele entspricht genau der Reihenfolge, in der der Nutzer sie
  ausgewaehlt hat; sie wird nicht vom System bestimmt oder umsortiert.
GEMESSEN DURCH: Aufbau: angemeldete Sitzung, EN-05, Zielschritt mit geladener Zielliste.
  Positivfall: dieselbe Zielmenge in zwei Laeufen auswaehlen, in Lauf A in einer Reihenfolge,
  die von der Reihenfolge der Anzeige abweicht, in Lauf B in umgekehrter Reihenfolge zu A —
  rechts stehen die Ziele je mit Rangziffern in genau der Reihenfolge der Auswahl des jeweiligen
  Laufs, und die beiden Rangfolgen sind zueinander umgekehrt; die Rangfolge steht so auch nach
  Abmelden und Weitermachen. Negativfall: derselbe Aufbau, aber beide Laeufe ergeben dieselbe
  Rangfolge oder eine, die der Reihenfolge der Anzeige folgt — dann ist das Kriterium NICHT
  ERFUELLT; zusaetzlich der gezeichnete Abweisungsfall nach EN-05 · ziele_waehlen · Zustand
  Fehler: ist der Rang nicht eindeutig uebernehmbar, wird abgewiesen und die Auswahl bleibt
  unveraendert. Die beiden Laeufe messen nur, wenn sie dieselbe Zielmenge verwenden und sich
  allein in der Klickreihenfolge unterscheiden.
· Quelle: „Die Rangfolge der Ziele entsteht aus der Reihenfolge der Auswahl. Sie ist eine Angabe
  des Nutzers, keine Bewertung des Systems."
· K23-M02: das Akzeptanzkriterium liefert der fachliche Eigentuemer — dieser Vorschlag nimmt ihm
  die Schreibarbeit ab, nicht die Entscheidung.
⟨zeichnet: ⟩ ⟨am: ⟩
```

`☐ gezeichnet   ☐ geändert (Wortlaut unten)   ☐ zurück an den Harness`

---

### K05-G05 · GILT

> Es GILT: Die Bestätigung des Ausgangsproblems ist ein Tor, keine Höflichkeit. Konzepte, Prototyp und Angebot bauen auf dieser einen Beschreibung auf.

*Konzept K05, Zeile 98 · Gegenprobe: gehalten*

**Vorgeschlagenes Kriterium**

```
⟨VORSCHLAG · NICHT GEZEICHNET⟩
ERFUELLT WENN: Die Bestaetigung des Ausgangsproblems wirkt als Tor: ohne sie findet der
  Namensschritt nicht statt, auch nicht bei unmittelbarem Aufruf des Serverpfads; mit ihr wird
  die bestaetigte Beschreibung gespeichert und ist die Beschreibung, auf die die weiteren
  Schritte zugreifen.
GEMESSEN DURCH: Aufbau: angemeldete Sitzung, eigener Mandant, ausreichende Rolle, EN-05 mit
  zusammengefasster Beschreibung. Positivfall: bestaetigen — die Bestaetigung ist gespeichert,
  der Namensvorschlag erscheint, und die bei Wiederaufnahme nach Abmelden angezeigte
  Beschreibung ist zeichengleich die bestaetigte. Negativfall: ohne Bestaetigung den
  Namensschritt unmittelbar am Serverpfad aufrufen, bei gueltiger Anmeldung, eigenem Mandanten,
  ausreichender Rolle und vorhandener Anwendung — erwartet: abgewiesen, kein Name gesetzt, die
  Stufe bleibt ORIENTIERUNG; liegt keine zusammengefasste Beschreibung vor, ist die
  Schaltflaeche ausgeblendet und an ihrer Stelle steht der Hinweis auf die fehlende
  Beschreibung. NICHT ERFUELLT, wenn der Namensschritt ohne Bestaetigung durchgeht. Der Fall
  zaehlt nur, wenn er an der fehlenden Bestaetigung scheitert und nicht an Rechten, Mandant oder
  fehlender Anwendung. Was Konzepte, Prototyp und Angebot aus dieser Beschreibung ableiten,
  liegt ausserhalb der Stufen 01 und 02 und wird dort gemessen.
· Quelle: „Die Bestätigung des Ausgangsproblems ist ein Tor, keine Höflichkeit. Konzepte,
  Prototyp und Angebot bauen auf dieser einen Beschreibung auf."
· K23-M02: das Akzeptanzkriterium liefert der fachliche Eigentuemer — dieser Vorschlag nimmt ihm
  die Schreibarbeit ab, nicht die Entscheidung.
⟨zeichnet: ⟩ ⟨am: ⟩
```

`☐ gezeichnet   ☐ geändert (Wortlaut unten)   ☐ zurück an den Harness`

---

### K05-G06 · GILT

> Es GILT: Der Namensvorschlag bleibt ein Vorschlag. Ohne Bestätigung wechselt die Stufe nicht.

*Konzept K05, Zeile 99 · Gegenprobe: gehalten*

**Vorgeschlagenes Kriterium**

```
⟨VORSCHLAG · NICHT GEZEICHNET⟩
ERFUELLT WENN: Der Namensvorschlag allein bewirkt nichts: solange er nicht bestaetigt ist,
  bleibt die Stufe unveraendert und kein Name ist gesetzt; erst die Bestaetigung fuehrt den
  Stufenwechsel herbei.
GEMESSEN DURCH: Aufbau: angemeldete Sitzung, eigener Mandant, EN-05 bis zum Namensschritt,
  Ausgangsproblem bestaetigt, Ausgangswert journey_phase ORIENTIERUNG. Positivfall: den Namen
  bestaetigen — app.name ist gesetzt und journey_phase steht auf INTERVIEW, EN-06 ist
  erreichbar. Negativfall: den angezeigten Vorschlag stehen lassen, die Stufe ohne Bestaetigung
  verlassen, abmelden, neu anmelden und weitermachen — erwartet: journey_phase steht
  unveraendert auf ORIENTIERUNG, kein Name ist gesetzt, EN-06 ist nicht erreichbar; zweiter
  Negativfall: den Wechsel durch eine vom Client uebergebene Stufe herbeifuehren wollen, bei
  gueltiger Anmeldung, eigenem Mandanten und ausreichender Rolle — die uebergebene Stufe wirkt
  nicht, der Wechsel wird nur serverseitig auf Bestaetigung hin gesetzt. NICHT ERFUELLT, wenn
  die Stufe ohne Bestaetigung wechselt. Beide Faelle zaehlen nur, wenn Stufe 01 im Uebrigen
  vollstaendig ist, damit sie allein an der fehlenden Bestaetigung haengen.
· Quelle: „Der Namensvorschlag bleibt ein Vorschlag. Ohne Bestätigung wechselt die Stufe nicht."
· K23-M02: das Akzeptanzkriterium liefert der fachliche Eigentuemer — dieser Vorschlag nimmt ihm
  die Schreibarbeit ab, nicht die Entscheidung.
⟨zeichnet: ⟩ ⟨am: ⟩
```

`☐ gezeichnet   ☐ geändert (Wortlaut unten)   ☐ zurück an den Harness`

---

### K05-G07 · GILT

> Es GILT: Die Bildschirme EN-05 und EN-06 stammen aus K19 Abschn. 6 und werden hier nicht frei gezeichnet. K19 Abschn. 8 weist sie K05 zu.

*Konzept K05, Zeile 100 · Gegenprobe: **ersetzt · erfunden***

**Vorgeschlagenes Kriterium**

```
⟨VORSCHLAG · NICHT GEZEICHNET⟩
ERFUELLT WENN: K05 zeichnet zu EN-05 und EN-06 keinen eigenen Bildschirm — jede Darstellung
  dieser beiden Bildschirme in K05 ist die aus K19 Abschn. 6 uebernommene, und K05 fuegt ihr
  keine Zeile und kein Element hinzu, das der Kasten in K19 Abschn. 6 nicht fuehrt; K19 Abschn.
  8 nennt fuer die Zeile EN-05 · EN-06 genau ein zustaendiges Konzept, und das ist K05, wie es
  der Bildschirmvertrag je Bildschirm im Feld owner fuehrt.
GEMESSEN DURCH: Aufbau: K05 in der vorliegenden Fassung; K19 Abschn. 6 mit den Kaesten „EN-05 ·
  Stufe 01 Orientierung" und „EN-06 · Stufe 02 Interview" in der Fassung, deren Pruefsumme
  schema/K19_build_referenz.sha256 fuehrt; K19 Abschn. 8; der Bildschirmvertrag EN-05/EN-06.
  Handlung: (a) in K05 jede Darstellung von EN-05 und EN-06 aufsuchen und Zeile fuer Zeile gegen
  den Kasten aus K19 Abschn. 6 stellen; (b) in K19 Abschn. 8 die Zeile EN-05 · EN-06 lesen; (c)
  im Bildschirmvertrag je Bildschirm das Feld owner lesen. Erwartete Beobachtung (Positivfall):
  (a) jede Zeile in K05 steht so im Kasten aus K19 Abschn. 6, K05 fuehrt keine selbst
  gezeichnete Zeile; (b) Abschn. 8 nennt genau K05; (c) owner lautet beide Male K05. NICHT
  ERFUELLT: K05 fuehrt zu EN-05 oder EN-06 eine Zeile, die der Kasten aus K19 Abschn. 6 nicht
  fuehrt (frei gezeichnet), oder Abschn. 8 nennt fuer EN-05 · EN-06 ein anderes Konzept als K05,
  oder owner lautet nicht K05; der Abgleich benennt die abweichende Zeile. Der Abgleich ist
  gegen die Fassung zu fahren, deren Pruefsumme in schema/K19_build_referenz.sha256 steht, damit
  er an der freien Zeichnung scheitert und nicht an einer anderen Fassung des Kastens. Nicht
  gemessen wird der gebaute Bildschirm gegen den Kasten: der Kasten bestimmt nach K19 Abschn.
  5.1 Anordnung und Verhalten, nicht den vollstaendigen Elementbestand — die Kopfleiste steht
  als eigener Kasten „auf jedem Bildschirm gleich", und Elemente, die K05-M02, K05-M04, K05-M05
  und K05-M06 fordern, fuehrt der Kasten nicht auf. Einen Meldungswortlaut nennt der
  Klauselwortlaut nicht.
· Quelle: „Die Bildschirme EN-05 und EN-06 stammen aus K19 Abschn. 6 und werden hier nicht frei
  gezeichnet. K19 Abschn. 8 weist sie K05 zu." · Anker: Bildschirmvertrag EN-05 und EN-06, Feld
  „owner: K05".
· Erzeugt am 19.08.2026 zu Blatt 100, Entscheidung 5. K23-M02: das Abnahmekriterium liefert der
  fachliche Eigentuemer — dieser Vorschlag nimmt ihm die Schreibarbeit ab, nicht die
  Entscheidung.
⟨zeichnet: ⟩ ⟨am: ⟩
```

`☐ gezeichnet   ☐ geändert (Wortlaut unten)   ☐ zurück an den Harness`

---

### K05-G08 · GILT

> Es GILT: Die Fortschrittsanzeige führt fünf Stufen. Stufe 01 ist ORIENTIERUNG, Stufe 02 ist INTERVIEW (K01 Abschn. 3, F02).

*Konzept K05, Zeile 101 · Gegenprobe: gehalten*

**Vorgeschlagenes Kriterium**

```
⟨VORSCHLAG · NICHT GEZEICHNET⟩
ERFUELLT WENN: Die Fortschrittsanzeige fuehrt fuenf Stufen; auf EN-05 ist die laufende Stufe die
  Stufe 01 mit dem Namen ORIENTIERUNG, auf EN-06 die Stufe 02 mit dem Namen INTERVIEW.
GEMESSEN DURCH: Aufbau: angemeldete Sitzung des eigenen Mandanten, fit_check mit outcome
  GEEIGNET, app.journey_phase = ORIENTIERUNG. Handlung: EN-05 oeffnen, die Stufen der
  Fortschrittsanzeige zaehlen und den markierten Eintrag mit Nummer und Namen lesen; danach
  Stufe 01 ueber name_bestaetigen abschliessen (Zustand Erfolg) und auf EN-06 dasselbe lesen.
  Erwartete Beobachtung (Positivfall): beide Male zaehlt die Anzeige fuenf Stufen; EN-05
  markiert Stufe 01 ORIENTIERUNG, EN-06 markiert Stufe 02 INTERVIEW; der markierte Name deckt
  sich mit dem Wert in app.journey_phase. NICHT ERFUELLT: Die Anzeige fuehrt eine andere Zahl
  von Stufen als fuenf, oder EN-05 fuehrt an Stufe 01 einen anderen Namen als ORIENTIERUNG, oder
  EN-06 fuehrt an Stufe 02 einen anderen Namen als INTERVIEW. Der Fall ist mit gueltiger
  Anmeldung und vorhandenem Gespraechsstand zu fahren, damit er an der Fortschrittsanzeige
  scheitert und nicht am Zugang oder an einem fehlenden Stand.
· Quelle: „Die Fortschrittsanzeige führt fünf Stufen. Stufe 01 ist ORIENTIERUNG, Stufe 02 ist
  INTERVIEW (K01 Abschn. 3, F02)." · Anker: EN-05 · name_bestaetigen · Zustand Erfolg —
  „app.journey_phase von ORIENTIERUNG auf INTERVIEW (K01)".
· Erzeugt am 19.08.2026 zu Blatt 100, Entscheidung 5. K23-M02: das Abnahmekriterium liefert der
  fachliche Eigentuemer — dieser Vorschlag nimmt ihm die Schreibarbeit ab, nicht die
  Entscheidung.
⟨zeichnet: ⟩ ⟨am: ⟩
```

`☐ gezeichnet   ☐ geändert (Wortlaut unten)   ☐ zurück an den Harness`

---

### K05-G09 · GILT

> Es GILT: Eine im Interview angehängte Datei ist eine Antwort, kein Wissensmodul. Das Register der Quellen führt K08.

*Konzept K05, Zeile 102 · Gegenprobe: gehalten*

**Vorgeschlagenes Kriterium**

```
⟨VORSCHLAG · NICHT GEZEICHNET⟩
ERFUELLT WENN: Eine im Interview angehaengte Datei erscheint als Antwort auf die gestellte
  Fachfrage — Eintrag in der rechten Spalte mit der Marke Ihre Angabe, aufgenommen in den
  INTERVIEW_PROTOCOL-Stand — und erzeugt keinen Eintrag im Register der Quellen, das K08 fuehrt.
GEMESSEN DURCH: Aufbau: Sitzung auf EN-06 mit gestellter Fachfrage; der Stand des von K08
  gefuehrten Quellenregisters wird vor der Handlung festgehalten. Handlung: dieselbe Datei ueber
  datei_anhaengen als Antwort auf die Fachfrage anhaengen; danach rechte Spalte,
  INTERVIEW_PROTOCOL-Stand und Quellenregister lesen. Erwartete Beobachtung (Positivfall):
  rechts steht ein Eintrag mit der Marke Ihre Angabe, die Datei geht in den INTERVIEW_PROTOCOL-
  Stand ein, und das von K08 gefuehrte Quellenregister ist gegenueber dem Ausgangsstand
  unveraendert. NICHT ERFUELLT: Nach dem Anhaengen fuehrt das Quellenregister von K08 einen
  neuen Eintrag zu dieser Datei, oder die Datei erscheint nicht als Antwort auf die Fachfrage,
  sondern nur als Quelle. Der Fall ist mit einer pruefbaren Datei zu fahren (Pruefung auf Typ,
  Groesse, Malware und aktiven Inhalt bestanden), damit er an der Einordnung als Antwort
  scheitert und nicht an der Dateipruefung; scheitert die Pruefung, ist die erwartete
  Beobachtung eine andere — „nicht pruefbare Datei bleibt in Quarantaene, Meldung mit Grund,
  kein Eintrag rechts".
· Stufe: zurueckgestellt (Blatt 100, E4)
· Quelle: „Eine im Interview angehängte Datei ist eine Antwort, kein Wissensmodul. Das Register
  der Quellen führt K08." · Anker: EN-06 · datei_anhaengen · Zustand Erfolg.
· Erzeugt am 19.08.2026 zu Blatt 100, Entscheidung 5. K23-M02: das Abnahmekriterium liefert der
  fachliche Eigentuemer — dieser Vorschlag nimmt ihm die Schreibarbeit ab, nicht die
  Entscheidung.
⟨zeichnet: ⟩ ⟨am: ⟩
```

`☐ gezeichnet   ☐ geändert (Wortlaut unten)   ☐ zurück an den Harness`

---

### K05-G10 · GILT

> Es GILT: Portal-Hilfe und Nebenfragen-Fenster sind Release-1-Umfang und gehören K16. K05 nennt sie nur als Abgrenzung.

*Konzept K05, Zeile 103 · Gegenprobe: **ersetzt · erfunden***

**Vorgeschlagenes Kriterium**

```
⟨VORSCHLAG · NICHT GEZEICHNET⟩
ERFUELLT WENN: K05 stellt fuer Portal-Hilfe und Nebenfragen-Fenster keine Regel auf — keine
  MUSS-, DARF-NICHT- oder GILT-Klausel von K05 schreibt ihr Verhalten, ihre Beschriftung oder
  ihren Inhalt vor —, und die Aktionsliste von EN-05 und EN-06 im Bildschirmvertrag fuehrt fuer
  sie weder eine eigene Aktion noch einen eigenen Serverbefehl; in K05 kommen sie
  ausschliesslich als Abgrenzung mit Verweis auf K16 vor.
GEMESSEN DURCH: Aufbau: K05 in der vorliegenden Fassung; der Bildschirmvertrag EN-05/EN-06 mit
  dem Feld aktionen; K19 Abschn. 8, Zeile „EN-13 · EN-14 · EX-17 | Einstellungen, beide Hilfen |
  K16". Handlung: (a) in K05 jede Fundstelle von Portal-Hilfe und Nebenfragen-Fenster aufsuchen
  und lesen, ob sie eine Regel aufstellt oder abgrenzt; (b) im Bildschirmvertrag alle Kennungen
  unter aktionen von EN-05 und EN-06 lesen und je Kennung pruefen, ob sie Hilfe oder
  Nebenfragen-Fenster bedient; (c) in K19 Abschn. 8 lesen, welches Konzept beide Hilfen fuehrt.
  Erwartete Beobachtung (Positivfall): (a) jede Fundstelle in K05 ist Abgrenzung mit Verweis auf
  K16, keine Regel; (b) keine der gefuehrten Kennungen bedient Hilfe oder Nebenfragen-Fenster;
  (c) Abschn. 8 nennt K16. NICHT ERFUELLT: K05 stellt selbst eine Regel fuer die Portal-Hilfe
  oder das Nebenfragen-Fenster auf, oder der Bildschirmvertrag fuehrt fuer EN-05 oder EN-06 eine
  eigene Aktion oder einen eigenen Serverbefehl dafuer — dann liefert K05, was nach dieser
  Klausel K16 gehoert; die Pruefung benennt die Klausel bzw. die Kennung. Nicht als Fehlschlag
  zaehlt eine auf EN-05 oder EN-06 sichtbare Schaltflaeche [? Hilfe]: K19 fuehrt die Kopfleiste
  als eigenen Kasten „auf jedem Bildschirm gleich" und weist beide Hilfen als Release-1-Umfang
  mit Regel bei K16 aus. Gemessen wird die Zustaendigkeit fuer die Regel, damit der Fall an ihr
  scheitert und nicht am blossen Vorhandensein eines gezeichneten Bedienelements oder am
  Wortvorkommen in einem Abgrenzungssatz.
· Quelle: „Portal-Hilfe und Nebenfragen-Fenster sind Release-1-Umfang und gehören K16. K05 nennt
  sie nur als Abgrenzung." · Anker: Bildschirmvertrag EN-05/EN-06, Feld „aktionen".
· Erzeugt am 19.08.2026 zu Blatt 100, Entscheidung 5. K23-M02: das Abnahmekriterium liefert der
  fachliche Eigentuemer — dieser Vorschlag nimmt ihm die Schreibarbeit ab, nicht die
  Entscheidung.
⟨zeichnet: ⟩ ⟨am: ⟩
```

`☐ gezeichnet   ☐ geändert (Wortlaut unten)   ☐ zurück an den Harness`

---

### K05-G11 · GILT

> Es GILT: K05 besitzt kein Datenobjekt. Der Inhalt des Gesprächs wird von den in Abschnitt 5 genannten Konzepten getragen; eine dort als offen ausgewiesene Zeile ist kein stillschweigend angenommener Träger.

*Konzept K05, Zeile 104 · Gegenprobe: **ersetzt · nicht_messbar***

**Vorgeschlagenes Kriterium**

```
⟨VORSCHLAG · NICHT GEZEICHNET⟩
ERFUELLT WENN: K05 weist kein eigenes Datenobjekt aus, sondern nennt fuer jeden Inhalt des
  Gespraechs das tragende Konzept aus seinem Abschnitt 5; und ein vollstaendiger Durchlauf der
  Stufen 01 und 02 schreibt jeden dabei entstehenden Gespraechsinhalt ausschliesslich in
  Traeger, die Abschnitt 5 benennt und dort nicht als offen ausweist — in eine dort als offen
  ausgewiesene Zeile schreibt der Durchlauf nichts.
GEMESSEN DURCH: Aufbau: K05 in einer benannten Fassung mit Abschnitt 5 und dessen Kennzeichnung
  offen; Pruefdatenbank mit synthetischen Daten und vollstaendigem Abzug des Datenbestands vor
  dem Lauf; angemeldete Sitzung des eigenen Mandanten, fit_check mit outcome GEEIGNET. Handlung:
  (a) in K05 nachlesen, ob ein eigenes Datenobjekt ausgewiesen ist und welche Traeger Abschnitt
  5 benennt bzw. als offen fuehrt; (b) EN-05 und EN-06 vollstaendig durchlaufen — Thema,
  Einordnung, Ziele, Ausgangsproblem, Name, Antworten, Ueberspringen, Zwischenspeichern; (c)
  zweiter Abzug und Vergleich Zeile fuer Zeile: in welchen Tabellen und Spalten sind Zeilen
  entstanden. Erwartete Beobachtung (Positivfall): (a) K05 weist kein eigenes Datenobjekt aus;
  (b)/(c) jede neu entstandene Zeile steht in einem Traeger, den Abschnitt 5 benennt und nicht
  als offen fuehrt — fuer den Beitrag im Gespraech ist das nach Bildschirmvertrag document
  (Eigentuemer K10). NICHT ERFUELLT: K05 weist ein eigenes Datenobjekt aus, oder der Vergleich
  der beiden Abzuege zeigt eine neue Zeile in einem Traeger, den Abschnitt 5 nicht benennt oder
  dort als offen fuehrt — dann ist ein offener Traeger stillschweigend angenommen worden; der
  Vergleich benennt Tabelle und Spalte. Der Lauf ist mit gueltiger Anmeldung, gueltigem
  Mandanten und gegen eine benannte Fassung von Abschnitt 5 zu fahren, damit er an der
  Traegerfrage scheitert und nicht an Zugang, Mandant oder einer anderen Fassung der Liste.
  Nicht gemessen wird das Eigentum am Datenmodell: schema/freiraum_datamodel.sql fuehrt keinen
  Eigentuemer je Tabelle — wer Eigentuemer ist, steht im Konzept und wird dort gelesen.
· Quelle: „K05 besitzt kein Datenobjekt. Der Inhalt des Gesprächs wird von den in Abschnitt 5
  genannten Konzepten getragen; eine dort als offen ausgewiesene Zeile ist kein stillschweigend
  angenommener Träger." · Anker: EN-05 · thema_waehlen · Zustand Erfolg — „Thema als Beitrag im
  INTERVIEW_PROTOCOL-Stand gefuehrt (K05-M25, Traeger document, Eigentuemer K10)".
· Erzeugt am 19.08.2026 zu Blatt 100, Entscheidung 5. K23-M02: das Abnahmekriterium liefert der
  fachliche Eigentuemer — dieser Vorschlag nimmt ihm die Schreibarbeit ab, nicht die
  Entscheidung.
⟨zeichnet: ⟩ ⟨am: ⟩
```

`☐ gezeichnet   ☐ geändert (Wortlaut unten)   ☐ zurück an den Harness`

---

### K05-M01 · MUSS

> Stufe 01 MUSS mit der offensten Frage beginnen: Der Nutzer beschreibt in eigenen Worten, welchen Arbeitsalltag FREIRAUM verbessern soll.

*Konzept K05, Zeile 48 · Gegenprobe: gehalten*

**Vorgeschlagenes Kriterium**

```
⟨VORSCHLAG · NICHT GEZEICHNET⟩
ERFUELLT WENN: Beim ersten Betreten von Stufe 01 steht als erste Frage die offene Frage, in der
  der Nutzer in eigenen Worten beschreibt, welchen Arbeitsalltag FREIRAUM verbessern soll; keine
  Einordnungs-, Ziel-, Ausgangsproblem- oder Namensfrage steht vor ihr, und an dieser Stelle ist
  eine Eingabe in eigenen Worten moeglich.
GEMESSEN DURCH: Aufbau: angemeldete Sitzung des eigenen Mandanten, fit_check mit outcome
  GEEIGNET, Gespraechsstand ohne jeden Beitrag. Handlung: EN-05 oeffnen, die zuerst gestellte
  Frage lesen und pruefen, ob an ihr eine Beschreibung in eigenen Worten eingegeben werden kann.
  Erwartete Beobachtung (Positivfall): die zuerst gestellte Frage ist die offene Eingangsfrage
  nach dem zu verbessernden Arbeitsalltag; eine freie Eingabe in eigenen Worten ist an ihr
  moeglich; solange nichts gewaehlt oder geschrieben ist, bleibt die Stufe an dieser
  Eingangsfrage stehen und rechts entsteht kein Eintrag. NICHT ERFUELLT: Beim ersten Betreten
  steht eine andere Frage vor der Eingangsfrage (etwa Branche, Ziel oder Name), oder die
  Eingangsfrage laesst keine Beschreibung in eigenen Worten zu. Der Fall ist mit leerem
  Gespraechsstand und gueltigem Zugang zu fahren, damit er an der Stellung der ersten Frage
  scheitert und nicht an einem schon vorhandenen Stand oder an der Berechtigung.
· Quelle: „Stufe 01 MUSS mit der offensten Frage beginnen: Der Nutzer beschreibt in eigenen
  Worten, welchen Arbeitsalltag FREIRAUM verbessern soll." · Anker: EN-05 · thema_waehlen ·
  Zustand leer — „kein Thema gewaehlt — die Stufe bleibt an der Eingangsfrage, rechts entsteht
  kein Eintrag (K19-M06)".
· Erzeugt am 19.08.2026 zu Blatt 100, Entscheidung 5. K23-M02: das Abnahmekriterium liefert der
  fachliche Eigentuemer — dieser Vorschlag nimmt ihm die Schreibarbeit ab, nicht die
  Entscheidung.
⟨zeichnet: ⟩ ⟨am: ⟩
```

`☐ gezeichnet   ☐ geändert (Wortlaut unten)   ☐ zurück an den Harness`

---

### K05-M02 · MUSS

> Unter der Eingangsfrage MÜSSEN zwölf häufige Themen als Vorschlag stehen. *Was anderes* MUSS in die freie Eingabe führen.

*Konzept K05, Zeile 49 · Gegenprobe: gehalten*

**Vorgeschlagenes Kriterium**

```
⟨VORSCHLAG · NICHT GEZEICHNET⟩
ERFUELLT WENN: Unter der Eingangsfrage stehen zwoelf haeufige Themen als Vorschlag, und die Wahl
  von „Was anderes" fuehrt in eine freie Eingabe, die einen eigenen Wortlaut als Thema annimmt.
GEMESSEN DURCH: Aufbau: angemeldete Sitzung des eigenen Mandanten, fit_check mit outcome
  GEEIGNET, Gespraechsstand ohne Beitrag, Antwortlisten vollstaendig geladen. Handlung: die
  unter der Eingangsfrage stehenden Themenvorschlaege zaehlen; danach „Was anderes" waehlen und
  einen eigenen Wortlaut eingeben und senden. Erwartete Beobachtung (Positivfall): gezaehlt
  werden zwoelf Themen; „Was anderes" oeffnet die freie Eingabe; der eingegebene eigene Wortlaut
  wird als Thema uebernommen und im Stand gefuehrt. Vor dem Stehen der zwoelf bleibt die
  Gespraechsspalte inaktiv. NICHT ERFUELLT: Unter der Eingangsfrage stehen mehr oder weniger als
  zwoelf Themen, oder „Was anderes" fuehrt nicht in eine freie Eingabe, sondern in eine weitere
  feste Auswahl oder ins Leere. Der Fall ist mit vollstaendig geladenen Antwortlisten und
  gueltiger Sitzung zu fahren, damit er an der Zahl der Themen bzw. am Weg von „Was anderes"
  scheitert und nicht am Ladezustand.
· Quelle: „Unter der Eingangsfrage MÜSSEN zwölf häufige Themen als Vorschlag stehen. *Was
  anderes* MUSS in die freie Eingabe führen." · Anker: EN-05 · thema_waehlen · Zustand laden —
  „zwoelf Themen geladen; die Gespraechsspalte bleibt inaktiv, bis sie stehen".
· Erzeugt am 19.08.2026 zu Blatt 100, Entscheidung 5. K23-M02: das Abnahmekriterium liefert der
  fachliche Eigentuemer — dieser Vorschlag nimmt ihm die Schreibarbeit ab, nicht die
  Entscheidung.
⟨zeichnet: ⟩ ⟨am: ⟩
```

`☐ gezeichnet   ☐ geändert (Wortlaut unten)   ☐ zurück an den Harness`

---

### K05-M03 · MUSS

> Die drei Einordnungsfragen MÜSSEN in fester Reihenfolge gestellt werden: Branche, dann Funktionsbereich, dann Anwendung.

*Konzept K05, Zeile 50 · Gegenprobe: gehalten*

**Vorgeschlagenes Kriterium**

```
⟨VORSCHLAG · NICHT GEZEICHNET⟩
ERFUELLT WENN: Die drei Einordnungsfragen werden in der Reihenfolge Branche, dann
  Funktionsbereich, dann Anwendung gestellt: die Folgefrage erscheint erst, wenn die
  vorangehende beantwortet ist, und eine Antwort ausser der Reihe wird abgewiesen, ohne die
  bisherigen Antworten zu veraendern.
GEMESSEN DURCH: Aufbau: Sitzung auf EN-05 mit gewaehltem Thema, keine Einordnungsantwort
  gespeichert, Antwortlisten geladen. Handlung Positivfall: Branche beantworten — der
  Funktionsbereich erscheint; Funktionsbereich beantworten — die Anwendung erscheint; die rechte
  Spalte fuellt sich in dieser Folge unter Branche, Funktion, Anwendung. Handlung Negativfall:
  bei unbeantworteter Branche record_classification mit einem gueltigen Antwortwert auf die
  Anwendungsfrage aufrufen. Erwartete Beobachtung: der Aufruf wird abgewiesen, die Folgefrage
  erscheint nicht, die Zeile rechts bleibt leer, und die bisherigen Antworten bleiben
  unveraendert. NICHT ERFUELLT: Die Antwort ausser der Reihe wird gespeichert, oder die
  Anwendungsfrage erscheint, bevor Branche und Funktionsbereich beantwortet sind, oder der
  abgewiesene Aufruf veraendert eine bereits gegebene Antwort. Der Negativfall ist mit gueltiger
  Anmeldung, gueltigem Mandanten und einem gueltigen Antwortwert zu fahren, damit er allein an
  der Reihenfolge scheitert und nicht an Recht, Mandant oder Wert.
· Quelle: „Die drei Einordnungsfragen MÜSSEN in fester Reihenfolge gestellt werden: Branche,
  dann Funktionsbereich, dann Anwendung." · Anker: EN-05 · einordnung_beantworten · Zustand
  fehler — „Reihenfolge verletzt oder Speichern fehlgeschlagen — abgewiesen, bisherige Antworten
  bleiben unveraendert (K05-G01)"; Zustand leer — „unbeantwortete Frage — die Folgefrage
  erscheint nicht".
· Erzeugt am 19.08.2026 zu Blatt 100, Entscheidung 5. K23-M02: das Abnahmekriterium liefert der
  fachliche Eigentuemer — dieser Vorschlag nimmt ihm die Schreibarbeit ab, nicht die
  Entscheidung.
⟨zeichnet: ⟩ ⟨am: ⟩
```

`☐ gezeichnet   ☐ geändert (Wortlaut unten)   ☐ zurück an den Harness`

---

### K05-M04 · MUSS

> Jede Einordnungsfrage MUSS neben den vorgeschlagenen Antworten genau eine offene Alternative führen — *Andere Branche*, *Anderer Funktionsbereich*, *Andere Anwendung*.

*Konzept K05, Zeile 51 · Gegenprobe: gehalten*

**Vorgeschlagenes Kriterium**

```
⟨VORSCHLAG · NICHT GEZEICHNET⟩
ERFUELLT WENN: Jede der drei Einordnungsfragen fuehrt neben den vorgeschlagenen Antworten genau
  eine offene Alternative — die Branchenfrage „Andere Branche", die Funktionsbereichsfrage
  „Anderer Funktionsbereich", die Anwendungsfrage „Andere Anwendung" —, und ueber diese
  Alternative ist eine eigene Antwort moeglich.
GEMESSEN DURCH: Aufbau: Sitzung auf EN-05 mit gewaehltem Thema, Antwortlisten als versionierte
  Konfigurationsdaten geladen. Handlung: je Frage die offenen Alternativen zaehlen und ihre
  Beschriftung lesen; danach je Frage ueber die offene Alternative eine eigene Antwort eingeben
  und senden. Erwartete Beobachtung (Positivfall): je Frage steht genau eine offene Alternative
  mit der jeweils genannten Beschriftung; die eigene Antwort wird uebernommen und erscheint
  rechts unter Branche, Funktion oder Anwendung. NICHT ERFUELLT: Eine der drei Fragen fuehrt
  keine offene Alternative oder mehr als eine, oder die offene Alternative nimmt keine eigene
  Antwort an. Der Fall ist mit vollstaendig geladenen Antwortlisten und in der geforderten
  Reihenfolge Branche, Funktionsbereich, Anwendung zu fahren, damit er an der offenen
  Alternative scheitert und nicht am Ladezustand oder an der Reihenfolge.
· Quelle: „Jede Einordnungsfrage MUSS neben den vorgeschlagenen Antworten genau eine offene
  Alternative führen — *Andere Branche*, *Anderer Funktionsbereich*, *Andere Anwendung*." ·
  Anker: EN-05 · einordnung_beantworten · eingabe — „je Frage eine offene Alternative Andere ...
  (K05-M03, K05-M04)".
· Erzeugt am 19.08.2026 zu Blatt 100, Entscheidung 5. K23-M02: das Abnahmekriterium liefert der
  fachliche Eigentuemer — dieser Vorschlag nimmt ihm die Schreibarbeit ab, nicht die
  Entscheidung.
⟨zeichnet: ⟩ ⟨am: ⟩
```

`☐ gezeichnet   ☐ geändert (Wortlaut unten)   ☐ zurück an den Harness`

---

### K05-M05 · MUSS

> Die Zielauswahl MUSS Mehrfachnennung zulassen und die Reihenfolge der Auswahl als Rangfolge übernehmen. Sieben Ziele stehen zur Wahl, *+ Anderes Ziel* ergänzt sie.

*Konzept K05, Zeile 52 · Gegenprobe: gehalten*

**Vorgeschlagenes Kriterium**

```
⟨VORSCHLAG · NICHT GEZEICHNET⟩
ERFUELLT WENN: Zur Wahl stehen sieben Ziele und zusaetzlich „+ Anderes Ziel"; mehrere Ziele
  lassen sich zugleich waehlen; die Rangfolge rechts entspricht Zug um Zug der Reihenfolge der
  Auswahl.
GEMESSEN DURCH: Aufbau: Sitzung auf EN-05, Zielschritt erreicht, keine Auswahl getroffen,
  Zielliste geladen. Handlung: die angebotenen Ziele zaehlen und pruefen, ob „+ Anderes Ziel"
  daneben steht; danach drei Ziele in einer vorher festgelegten Reihenfolge waehlen — erst C,
  dann A, dann B — und die rechte Spalte lesen; zuletzt ueber „+ Anderes Ziel" ein eigenes Ziel
  ergaenzen. Erwartete Beobachtung (Positivfall): sieben Ziele stehen zur Wahl, „+ Anderes Ziel"
  ergaenzt sie; alle drei gewaehlten Ziele stehen zugleich rechts; die Rangziffern lauten 1 fuer
  C, 2 fuer A, 3 fuer B. NICHT ERFUELLT: Die zweite Wahl ersetzt die erste, statt sie zu
  ergaenzen (keine Mehrfachnennung), oder die Rangziffern folgen einer anderen Ordnung als der
  Auswahlreihenfolge — etwa der Listenordnung —, oder es stehen nicht sieben Ziele und „+
  Anderes Ziel" zur Wahl. Der Fall ist mit gueltiger Sitzung und geladener Zielliste zu fahren,
  damit er an Mehrfachnennung, Rangfolge oder Zahl scheitert und nicht am Laden; wird der Rang
  nicht eindeutig uebernommen, ist die erwartete Beobachtung „abgewiesen, Auswahl bleibt
  unveraendert".
· Quelle: „Die Zielauswahl MUSS Mehrfachnennung zulassen und die Reihenfolge der Auswahl als
  Rangfolge übernehmen. Sieben Ziele stehen zur Wahl, *+ Anderes Ziel* ergänzt sie." · Anker:
  EN-05 · ziele_waehlen · Zustand Erfolg — „Ziele rechts mit Rangziffern 1 2 3 in der
  Reihenfolge der Auswahl".
· Erzeugt am 19.08.2026 zu Blatt 100, Entscheidung 5. K23-M02: das Abnahmekriterium liefert der
  fachliche Eigentuemer — dieser Vorschlag nimmt ihm die Schreibarbeit ab, nicht die
  Entscheidung.
⟨zeichnet: ⟩ ⟨am: ⟩
```

`☐ gezeichnet   ☐ geändert (Wortlaut unten)   ☐ zurück an den Harness`

---

### K05-M06 · MUSS

> Das Ausgangsproblem MUSS zusammengefasst angezeigt und ausdrücklich bestätigt werden. Zwei Wege stehen bereit: *Weitere Details angeben* korrigiert, *Ja, weiter zum Interview* bestätigt.

*Konzept K05, Zeile 53 · Gegenprobe: gehalten*

**Vorgeschlagenes Kriterium**

```
⟨VORSCHLAG · NICHT GEZEICHNET⟩
ERFUELLT WENN: Vor dem Weitergang wird das Ausgangsproblem zusammengefasst angezeigt, und beide
  Wege stehen bereit: „Weitere Details angeben" fuehrt in die Korrektur und die Zusammenfassung
  nimmt die Korrektur auf, „Ja, weiter zum Interview" bestaetigt ausdruecklich; ohne diese
  ausdrueckliche Bestaetigung folgt kein Namensschritt.
GEMESSEN DURCH: Aufbau: Sitzung auf EN-05 mit beantworteten Vorschritten, das Ausgangsproblem
  liegt zusammengefasst vor. Handlung Positivfall: die Zusammenfassung lesen; „Weitere Details
  angeben" waehlen, eine Ergaenzung eintragen und zurueckkehren — die Zusammenfassung fuehrt die
  Ergaenzung; danach „Ja, weiter zum Interview" waehlen. Erwartet: die Bestaetigung ist
  gespeichert und der Namensvorschlag erscheint. Handlung Negativfall: ohne „Ja, weiter zum
  Interview" den Namensschritt anfordern. Erwartet: kein Namensschritt; die Stufe bleibt
  ORIENTIERUNG, die Beschreibung bleibt korrigierbar. NICHT ERFUELLT: Der Namensschritt
  erscheint ohne die ausdrueckliche Bestaetigung, oder einer der beiden Wege fehlt, oder das
  Ausgangsproblem wird nicht zusammengefasst angezeigt. Der Negativfall ist mit vorhandener
  Zusammenfassung und gueltiger Sitzung zu fahren, damit er an der fehlenden Bestaetigung
  scheitert und nicht an der fehlenden Beschreibung — fehlt diese, ist die erwartete Beobachtung
  eine andere: „ohne zusammengefasstes Ausgangsproblem ist die Schaltflaeche ausgeblendet, an
  ihrer Stelle steht der Hinweis auf die fehlende Beschreibung".
· Quelle: „Das Ausgangsproblem MUSS zusammengefasst angezeigt und ausdrücklich bestätigt werden.
  Zwei Wege stehen bereit: *Weitere Details angeben* korrigiert, *Ja, weiter zum Interview*
  bestätigt." · Anker: EN-05 · ausgangsproblem_bestaetigen · berechtigung — „ohne bestaetigtes
  Ausgangsproblem kein Namensschritt"; Zustand Erfolg — „Bestaetigung gespeichert; der
  Namensvorschlag erscheint (K05-M07)".
· Erzeugt am 19.08.2026 zu Blatt 100, Entscheidung 5. K23-M02: das Abnahmekriterium liefert der
  fachliche Eigentuemer — dieser Vorschlag nimmt ihm die Schreibarbeit ab, nicht die
  Entscheidung.
⟨zeichnet: ⟩ ⟨am: ⟩
```

`☐ gezeichnet   ☐ geändert (Wortlaut unten)   ☐ zurück an den Harness`

---

### K05-M07 · MUSS

> Zum Abschluss von Stufe 01 MUSS ein Namensvorschlag erscheinen, als Vorschlag der Modelle markiert und in einem überschreibbaren Eingabefeld. Träger des Namens ist `app.name` (Eigentümer K01).

*Konzept K05, Zeile 54 · Gegenprobe: gehalten*

**Vorgeschlagenes Kriterium**

```
⟨VORSCHLAG · NICHT GEZEICHNET⟩
ERFUELLT WENN: Zum Abschluss von Stufe 01 erscheint ein Namensvorschlag, der als Vorschlag der
  Modelle markiert ist (Bildschirmvertrag: Marke KI-Vorschlag) und in einem ueberschreibbaren
  Eingabefeld steht; der bestaetigte Name steht danach in app.name.
GEMESSEN DURCH: Aufbau: Sitzung auf EN-05 mit bestaetigtem Ausgangsproblem, Schreibrecht auf
  app.name des eigenen Mandanten, app.name vor der Handlung gelesen. Handlung: den erscheinenden
  Namensvorschlag lesen und pruefen, ob er die Marke traegt; das Feld mit einem anderen Wortlaut
  ueberschreiben und bestaetigen; danach app.name lesen. Erwartete Beobachtung (Positivfall):
  der Vorschlag erscheint, traegt die Marke und steht in einem Feld, das die Aenderung annimmt;
  nach der Bestaetigung traegt app.name genau den ueberschriebenen Wortlaut. NICHT ERFUELLT: Der
  Namensvorschlag erscheint ohne Marke, oder das Feld nimmt die Ueberschreibung nicht an, oder
  der bestaetigte Name steht nicht in app.name. Fuer den ersten Fall nennt der Bildschirmvertrag
  die erwartete Beobachtung: „Feld leer oder Marke fehlt — abgelehnt, Stufe bleibt
  ORIENTIERUNG". Der Fall ist mit gueltiger Anmeldung und vorhandenem Schreibrecht auf app.name
  des eigenen Mandanten zu fahren, damit er an Marke, Ueberschreibbarkeit oder Traeger scheitert
  und nicht am Recht.
· Quelle: „Zum Abschluss von Stufe 01 MUSS ein Namensvorschlag erscheinen, als Vorschlag der
  Modelle markiert und in einem überschreibbaren Eingabefeld. Träger des Namens ist `app.name`
  (Eigentümer K01)." · Anker: EN-05 · name_bestaetigen · eingabe — „der Vorschlag traegt die
  Marke KI-Vorschlag, jedes Feld mit Vorschlag ist zugleich Eingabefeld"; Zustand leer — „Feld
  leer oder Marke fehlt — abgelehnt, Stufe bleibt ORIENTIERUNG".
· Erzeugt am 19.08.2026 zu Blatt 100, Entscheidung 5. K23-M02: das Abnahmekriterium liefert der
  fachliche Eigentuemer — dieser Vorschlag nimmt ihm die Schreibarbeit ab, nicht die
  Entscheidung.
⟨zeichnet: ⟩ ⟨am: ⟩
```

`☐ gezeichnet   ☐ geändert (Wortlaut unten)   ☐ zurück an den Harness`

---

### K05-M08 · MUSS

> Der Stufenwechsel MUSS `app.journey_phase` von ORIENTIERUNG auf INTERVIEW setzen (Eigentümer K01) und einen Protokolleintrag in `event` erzeugen (Eigentümer K02).

*Konzept K05, Zeile 55 · Gegenprobe: gehalten*

**Vorgeschlagenes Kriterium**

```
⟨VORSCHLAG · NICHT GEZEICHNET⟩
ERFUELLT WENN: Der Stufenwechsel wirkt nur als Ganzes: nach ihm steht app.journey_phase auf
  INTERVIEW, wo vorher ORIENTIERUNG stand, und im event-Bestand steht ein Protokolleintrag zu
  diesem Wechsel; scheitert eines von beiden, steht keines von beiden — journey_phase bleibt
  ORIENTIERUNG und es entsteht kein Protokolleintrag.
GEMESSEN DURCH: Aufbau: frische Pruefdatenbank mit synthetischen Daten, eine Anwendung mit
  journey_phase = ORIENTIERUNG, app-Zeile und event-Bestand vor der Handlung gelesen, gueltige
  Anmeldung mit Schreibrecht im eigenen Mandanten. Handlung Positivfall: name_bestaetigen mit
  gueltigem Namen ausfuehren; danach app.journey_phase und den event-Bestand lesen. Erwartet:
  journey_phase = INTERVIEW und ein neuer Protokolleintrag in event zu diesem Wechsel (der
  Bildschirmvertrag nennt dazu source = PORTAL_ACTION, K02). Handlung Negativfall: denselben
  Aufruf so fahren, dass allein der Protokolleintrag scheitert — der Schreibweg auf event wird
  in der Pruefumgebung unterbunden. Erwartet: alles zurueckgerollt, kein Teilwechsel;
  journey_phase steht weiter auf ORIENTIERUNG, und es steht weder ein Protokolleintrag ohne
  Phasenwechsel noch ein Phasenwechsel ohne Protokolleintrag. NICHT ERFUELLT: Nach dem
  Negativfall steht journey_phase auf INTERVIEW, oder ein Protokolleintrag steht ohne den
  Phasenwechsel. Der Negativfall ist mit gueltiger Anmeldung, gueltigem Namen, gueltigem
  Mandanten und gueltigem Schreibrecht zu fahren, damit er allein am Protokolleintrag scheitert
  und nicht an Name, Recht oder Mandant.
· Quelle: „Der Stufenwechsel MUSS `app.journey_phase` von ORIENTIERUNG auf INTERVIEW setzen
  (Eigentümer K01) und einen Protokolleintrag in `event` erzeugen (Eigentümer K02)." · Anker:
  EN-05 · name_bestaetigen · Zustand fehler — „Schreibbefehl oder Protokolleintrag gescheitert —
  alles zurueckgerollt, kein Teilwechsel, Stufe bleibt ORIENTIERUNG (K05-M08)".
· Erzeugt am 19.08.2026 zu Blatt 100, Entscheidung 5. K23-M02: das Abnahmekriterium liefert der
  fachliche Eigentuemer — dieser Vorschlag nimmt ihm die Schreibarbeit ab, nicht die
  Entscheidung.
⟨zeichnet: ⟩ ⟨am: ⟩
```

`☐ gezeichnet   ☐ geändert (Wortlaut unten)   ☐ zurück an den Harness`

---

### K05-M09 · MUSS

> Stufe 02 MUSS je Frage drei Antwortwege gleichrangig anbieten: einen Vorschlag anklicken, in eigenen Worten schreiben, ein Dokument anhängen.

*Konzept K05, Zeile 56 · Gegenprobe: gehalten*

**Vorgeschlagenes Kriterium**

```
⟨VORSCHLAG · NICHT GEZEICHNET⟩
ERFUELLT WENN: An jeder gestellten Fachfrage der Stufe 02 stehen alle drei Antwortwege zugleich
  und gleichrangig zur Wahl — einen Vorschlag anklicken, in eigenen Worten schreiben, ein
  Dokument anhaengen —; keiner ist einem anderen vorgeschaltet oder erst nach Nutzung eines
  anderen erreichbar, und jeder der drei fuehrt fuer sich zu einem Eintrag in der rechten
  Spalte.
GEMESSEN DURCH: Aufbau: Sitzung auf EN-06 mit gestellter Fachfrage, Frage und Vorschlaege
  geladen. Handlung: an derselben Frage pruefen, ob alle drei Wege ohne Zwischenschritt
  bedienbar sind; danach die drei Wege je einmal einzeln benutzen, jeweils mit frisch gestellter
  Frage. Erwartete Beobachtung (Positivfall): alle drei stehen an der Frage bedienbar
  nebeneinander; jeder erzeugt fuer sich einen Eintrag in der rechten Spalte. NICHT ERFUELLT: An
  der Frage fehlt einer der drei Wege, oder einer ist erst bedienbar, nachdem ein anderer
  benutzt wurde. Der Fall ist an einer regulaer gestellten Fachfrage mit gueltiger Sitzung zu
  fahren, damit er am fehlenden oder nachgeordneten Antwortweg scheitert und nicht am
  Ladezustand der Frage.
· Stufe: der dritte Weg (Dokument anhaengen, upload_interview_document) zurueckgestellt (Blatt
  100, E4) — bis zum Nachziehen ist die Bedingung nur fuer die ersten beiden Wege messbar; der
  dritte bleibt offen und wird nicht als erfuellt gefuehrt.
· Quelle: „Stufe 02 MUSS je Frage drei Antwortwege gleichrangig anbieten: einen Vorschlag
  anklicken, in eigenen Worten schreiben, ein Dokument anhängen." · Anker: EN-06 fuehrt zu
  derselben Fachfrage die Aktionen vorschlag_waehlen, freitext_antworten und datei_anhaengen.
· Erzeugt am 19.08.2026 zu Blatt 100, Entscheidung 5. K23-M02: das Abnahmekriterium liefert der
  fachliche Eigentuemer — dieser Vorschlag nimmt ihm die Schreibarbeit ab, nicht die
  Entscheidung.
⟨zeichnet: ⟩ ⟨am: ⟩
```

`☐ gezeichnet   ☐ geändert (Wortlaut unten)   ☐ zurück an den Harness`

---

### K05-M10 · MUSS

> Jede Frage in Stufe 02 MUSS überspringbar sein. *Diese Frage ignorieren* MUSS den Übersprungvermerk in die rechte Spalte schreiben. Der Vermerk trägt ausschließlich den Wortlaut *(Frage übersprungen)* — keinen Inhalt aus dem Gespräch und deshalb auch keine Herkunftsmarke.

*Konzept K05, Zeile 57 · Gegenprobe: gehalten*

**Vorgeschlagenes Kriterium**

```
⟨VORSCHLAG · NICHT GEZEICHNET⟩
ERFUELLT WENN: Zu jeder in Stufe 02 gestellten Frage steht „Diese Frage ignorieren" bereit, und
  nach ihrer Wahl steht in der rechten Spalte ausschliesslich der Wortlaut (Frage uebersprungen)
  — kein Inhalt aus dem Gespraech und keine Herkunftsmarke.
GEMESSEN DURCH: Aufbau: Sitzung auf EN-06 mit gestellter Fachfrage, der Stand der rechten Spalte
  vor der Handlung festgehalten. Handlung: fuer jede gestellte Frage pruefen, ob die Aktion
  bereitsteht; an einer Frage „Diese Frage ignorieren" waehlen und den neu entstandenen Eintrag
  rechts Zeichen fuer Zeichen lesen. Erwartete Beobachtung (Positivfall): der Eintrag traegt
  ausschliesslich den Wortlaut (Frage uebersprungen); er traegt keine Herkunftsmarke und keinen
  Text aus dem Gespraech; das Nachholen der Antwort bleibt bis „Bin fertig mit dem Interview"
  moeglich. NICHT ERFUELLT: Der Vermerk traegt eine Herkunftsmarke oder zusaetzlichen Inhalt —
  etwa den Fragetext oder eine angefangene Antwort —, oder zu einer gestellten Frage steht die
  Aktion nicht bereit. Der Fall ist an einer regulaer gestellten Frage mit gueltiger Sitzung und
  schreibbarem Vermerk zu fahren, damit er am Inhalt des Vermerks scheitert und nicht am
  Schreibweg; ist der Vermerk nicht schreibbar, ist die erwartete Beobachtung eine andere:
  „abgelehnt, die Frage bleibt offen".
· Quelle: „Jede Frage in Stufe 02 MUSS überspringbar sein. *Diese Frage ignorieren* MUSS den
  Übersprungvermerk in die rechte Spalte schreiben. Der Vermerk trägt ausschließlich den
  Wortlaut *(Frage übersprungen)* — keinen Inhalt aus dem Gespräch und deshalb auch keine
  Herkunftsmarke." · Anker: EN-06 · frage_ignorieren · Zustand Erfolg — „rechts steht
  ausschliesslich der Wortlaut (Frage uebersprungen), ohne Marke; nachholbar bis Bin fertig mit
  dem Interview".
· Erzeugt am 19.08.2026 zu Blatt 100, Entscheidung 5. K23-M02: das Abnahmekriterium liefert der
  fachliche Eigentuemer — dieser Vorschlag nimmt ihm die Schreibarbeit ab, nicht die
  Entscheidung.
⟨zeichnet: ⟩ ⟨am: ⟩
```

`☐ gezeichnet   ☐ geändert (Wortlaut unten)   ☐ zurück an den Harness`

---

### K05-M11 · MUSS

> Jeder inhaltliche Eintrag der rechten Spalte MUSS genau eine Herkunftsmarke tragen: *KI-Notiz* für das, was der Assistent aus Antworten geschlossen hat, *Ihre Angabe* für das, was der Nutzer selbst formuliert hat. Der Übersprungvermerk ist kein inhaltlicher Eintrag (K05-M10).

*Konzept K05, Zeile 58 · Gegenprobe: **ersetzt · nicht_messbar***

**Vorgeschlagenes Kriterium**

```
⟨VORSCHLAG · NICHT GEZEICHNET⟩
ERFUELLT WENN: Jeder inhaltliche Eintrag der rechten Spalte traegt genau eine Herkunftsmarke —
  keiner traegt keine, keiner traegt zwei —, ein vom Nutzer selbst formulierter Eintrag traegt
  die Marke Ihre Angabe, und laesst sich die Marke nicht eindeutig bestimmen, entsteht rechts
  ueberhaupt kein Eintrag; der Uebersprungvermerk zaehlt nicht als inhaltlicher Eintrag.
GEMESSEN DURCH: Aufbau: Sitzung des eigenen Mandanten auf EN-06 mit gestellter Fachfrage, rechte
  Spalte im Ausgangsstand festgehalten. Handlung Positivfall: (a) im Freitextfeld einen eigenen
  Wortlaut senden; (b) an der naechsten Frage einen angebotenen Vorschlag anklicken; (c) eine
  dritte Frage ueber Diese Frage ignorieren ueberspringen; danach je Eintrag der rechten Spalte
  die Marken zaehlen und lesen. Erwartete Beobachtung: (a) genau eine Marke, und zwar Ihre
  Angabe; (b) genau eine Herkunftsmarke; (c) ausschliesslich der Wortlaut (Frage uebersprungen),
  keine Marke, bei der Zaehlung der inhaltlichen Eintraege nicht mitgezaehlt. Handlung
  Negativfall: dieselbe Antwort ueber vorschlag_waehlen senden, waehrend die Marke nicht
  eindeutig bestimmbar ist. Erwartete Beobachtung: kein Eintrag rechts, Meldung, die Antwort
  bleibt waehlbar. NICHT ERFUELLT: Ein inhaltlicher Eintrag steht ohne Marke oder mit zwei
  Marken, oder ein vom Nutzer im Freitext formulierter Eintrag traegt eine andere Marke als Ihre
  Angabe, oder im Negativfall entsteht trotz nicht eindeutig bestimmbarer Marke ein Eintrag
  rechts. Der Negativfall ist mit gueltiger Anmeldung, gueltigem Mandanten und speicherbarem
  Stand zu fahren, damit er an der Marke scheitert und nicht am Speichern. Nicht gemessen wird,
  welcher Vorgang einen Eintrag mit der Marke KI-Notiz erzeugt: weder der Klauselwortlaut noch
  der Bildschirmvertrag nennt eine Aktion von EN-05 oder EN-06, die einen aus Antworten
  geschlossenen Eintrag herbeifuehrt — welcher Vorgang das ist, muss der fachliche Eigentuemer
  benennen, bevor die Zuordnung KI-Notiz gegen Ihre Angabe als Prueffall gefahren werden kann.
· Quelle: „Jeder inhaltliche Eintrag der rechten Spalte MUSS genau eine Herkunftsmarke tragen:
  *KI-Notiz* für das, was der Assistent aus Antworten geschlossen hat, *Ihre Angabe* für das,
  was der Nutzer selbst formuliert hat. Der Übersprungvermerk ist kein inhaltlicher Eintrag
  (K05-M10)." · Anker: EN-06 · vorschlag_waehlen · Zustand Erfolg — „Eintrag rechts mit genau
  einer Herkunftsmarke" und Zustand fehler — „Marke nicht eindeutig bestimmbar ... kein Eintrag
  rechts, Meldung, Antwort bleibt waehlbar"; EN-06 · freitext_antworten · Zustand Erfolg —
  „Eintrag rechts mit Marke Ihre Angabe".
· Erzeugt am 19.08.2026 zu Blatt 100, Entscheidung 5. K23-M02: das Abnahmekriterium liefert der
  fachliche Eigentuemer — dieser Vorschlag nimmt ihm die Schreibarbeit ab, nicht die
  Entscheidung.
⟨zeichnet: ⟩ ⟨am: ⟩
```

`☐ gezeichnet   ☐ geändert (Wortlaut unten)   ☐ zurück an den Harness`

---

### K05-M12 · MUSS

> Wird ein Eintrag nach seiner Entstehung geändert, MÜSSEN Ursprung und Bearbeitungszustand getrennt angezeigt werden. Die Marke allein genügt dann nicht (K19 Abschn. 3).

*Konzept K05, Zeile 59 · Gegenprobe: **ersetzt · nicht_messbar***

**Vorgeschlagenes Kriterium**

```
⟨VORSCHLAG · NICHT GEZEICHNET⟩
ERFUELLT WENN: An einem Eintrag, der nach seiner Entstehung geaendert wurde, stehen zwei
  getrennte Angaben — die Herkunftsmarke, mit der er entstanden ist, und daneben der
  Bearbeitungszustand, dass er anschliessend bearbeitet wurde, in der Form, die K19 Abschn. 3
  angibt (K19-G09: die Anzeige lautet dann beispielsweise „KI-Vorschlag, anschließend
  bearbeitet") —, waehrend ein unveraenderter Eintrag gleicher Herkunft allein die Marke traegt;
  geaendert und unveraendert sind dadurch an der Anzeige unterscheidbar.
GEMESSEN DURCH: Aufbau: zwei Eintraege der rechten Spalte gleicher Herkunft, beide bei der
  Entstehung mit derselben Marke versehen; angemeldete Sitzung des eigenen Mandanten mit
  Schreibrecht; der Anzeigestand beider Eintraege vor der Handlung festgehalten. Handlung
  Positivfall: den einen Eintrag unangetastet lassen; den anderen nach seiner Entstehung aendern
  — den mit der Marke KI-Vorschlag versehenen Namensvorschlag im ueberschreibbaren Feld mit
  einem anderen Wortlaut ueberschreiben und bestaetigen —; danach beide Eintraege nebeneinander
  lesen. Erwartete Beobachtung: der unangetastete Eintrag zeigt allein die Marke; der geaenderte
  zeigt die Marke und, davon getrennt lesbar, den Bearbeitungszustand nach dem Muster „Marke,
  anschliessend bearbeitet". NICHT ERFUELLT: Nach der Aenderung steht am geaenderten Eintrag
  weiterhin allein die Marke, sodass er vom unveraenderten Eintrag nicht zu unterscheiden ist;
  oder die Marke ist durch den Bearbeitungszustand ersetzt, sodass der Ursprung nicht mehr
  lesbar ist; oder der unveraenderte Eintrag traegt ebenfalls einen Bearbeitungszustand. Der
  Fall ist an einem Eintrag zu fahren, der bei seiner Entstehung eine Marke trug, und mit
  gueltigem Schreibrecht des eigenen Mandanten, damit er an der fehlenden getrennten Anzeige
  scheitert und nicht an einer fehlenden Marke oder am Speichern.
· Quelle: „Wird ein Eintrag nach seiner Entstehung geändert, MÜSSEN Ursprung und
  Bearbeitungszustand getrennt angezeigt werden. Die Marke allein genügt dann nicht (K19 Abschn.
  3)." · Anker: EN-05 · name_bestaetigen · eingabe — „Name im ueberschreibbaren Feld; der
  Vorschlag traegt die Marke KI-Vorschlag, jedes Feld mit Vorschlag ist zugleich Eingabefeld";
  K19 Abschn. 3, Klausel K19-G09.
· Erzeugt am 19.08.2026 zu Blatt 100, Entscheidung 5. K23-M02: das Abnahmekriterium liefert der
  fachliche Eigentuemer — dieser Vorschlag nimmt ihm die Schreibarbeit ab, nicht die
  Entscheidung.
⟨zeichnet: ⟩ ⟨am: ⟩
```

`☐ gezeichnet   ☐ geändert (Wortlaut unten)   ☐ zurück an den Harness`

---

### K05-M13 · MUSS

> Beide Stufen MÜSSEN zweigeteilt sein: links wird gesagt oder geklickt, rechts erscheint das Ergebnis, unmittelbar und ohne Wechsel zwischen getrennten Formularen (K01 Abschn. 3).

*Konzept K05, Zeile 60 · Gegenprobe: **ersetzt · erfunden***

**Vorgeschlagenes Kriterium**

```
⟨VORSCHLAG · NICHT GEZEICHNET⟩
ERFUELLT WENN: EN-05 und EN-06 zeigen Bedienung und Ergebnis in einer einzigen Ansicht — links
  wird gesagt oder geklickt, rechts erscheint das Ergebnis; zwischen der Handlung links und dem
  Eintrag rechts oeffnet sich kein getrenntes Formular und wechselt der Bildschirm nicht.
GEMESSEN DURCH: Aufbau: angemeldete Sitzung mit einem Gespraech in Stufe 01 (EN-05) und in Stufe
  02 (EN-06). Positivfall: auf EN-05 ein Thema waehlen (thema_waehlen, Zustand Erfolg) und auf
  EN-06 einen Vorschlag waehlen (vorschlag_waehlen, Zustand Erfolg: „Eintrag rechts mit genau
  einer Herkunftsmarke"); erwartete Beobachtung: der Eintrag steht rechts in derselben Ansicht,
  in der links bedient wurde, und zwischen Bedienung und Eintrag wurde kein getrenntes Formular
  geoeffnet und kein Bildschirm gewechselt. Negativfall: derselbe Aufbau, dieselbe Bedienung,
  der Speichervorgang meldet Erfolg — aber der Eintrag rechts erscheint erst, nachdem ein
  getrenntes Formular geoeffnet oder der Bildschirm gewechselt wurde; ebenso nicht erfuellt,
  wenn Bedienung und Ergebnis auf getrennten Bildschirmen liegen. Weil der Speichervorgang
  Erfolg meldet, scheitert der Fall allein an der Zweiteilung in einer Ansicht. Offen fuer den
  fachlichen Eigentuemer: ob „unmittelbar" ausser dem Verzicht auf Formular- und
  Bildschirmwechsel eine Hoechstdauer meint — der Wortlaut nennt keine; ohne seine Festlegung
  wird keine Dauer gemessen.
· Quelle: „Beide Stufen MÜSSEN zweigeteilt sein: links wird gesagt oder geklickt, rechts
  erscheint das Ergebnis, unmittelbar und ohne Wechsel zwischen getrennten Formularen (K01
  Abschn. 3)." ·
⟨zeichnet: ⟩ ⟨am: ⟩
```

`☐ gezeichnet   ☐ geändert (Wortlaut unten)   ☐ zurück an den Harness`

---

### K05-M14 · MUSS

> Über dem Gespräch MUSS in beiden Stufen der nicht wegklickbare Hinweis stehen, dass Vorschläge der Modelle Fehler enthalten können (K01 Abschn. 3).

*Konzept K05, Zeile 61 · Gegenprobe: gehalten*

**Vorgeschlagenes Kriterium**

```
⟨VORSCHLAG · NICHT GEZEICHNET⟩
ERFUELLT WENN: Auf EN-05 und auf EN-06 steht ueber der Gespraechsspalte ein Hinweis mit der
  Aussage, dass Vorschlaege der Modelle Fehler enthalten koennen; er traegt keine Bedienung zum
  Wegklicken und bleibt in allen vier Zustaenden der Aktionen (laden, leer, Erfolg, Fehler)
  sowie nach erneutem Aufruf des Bildschirms sichtbar.
GEMESSEN DURCH: Aufbau: angemeldete Sitzung, EN-05 und EN-06 nacheinander geoeffnet.
  Positivfall: auf jedem der beiden Bildschirme wird der Hinweis ueber dem Gespraech abgelesen;
  dann je eine Aktion mit Erfolg und eine mit Fehler ausgeloest und der Bildschirm neu
  aufgerufen; erwartete Beobachtung: der Hinweis steht jedes Mal an derselben Stelle, und es
  gibt keine Bedienung, die ihn entfernt. Negativfall: derselbe Aufbau bei einem Stand, in dem
  der Hinweis eine Schliessen-Bedienung traegt oder auf einer der beiden Stufen fehlt; erwartete
  Beobachtung: nach dem Schliessen ist der Hinweis nicht mehr sichtbar bzw. er fehlt von Anfang
  an — der Fall scheitert an der Sichtbarkeit und Nichtwegklickbarkeit des Hinweises, waehrend
  Gespraech und Aktionen unveraendert funktionieren.
· Quelle: „Über dem Gespräch MUSS in beiden Stufen der nicht wegklickbare Hinweis stehen, dass
  Vorschläge der Modelle Fehler enthalten können (K01 Abschn. 3)." ·
⟨zeichnet: ⟩ ⟨am: ⟩
```

`☐ gezeichnet   ☐ geändert (Wortlaut unten)   ☐ zurück an den Harness`

---

### K05-M15 · MUSS

> Ab Stufe 02 MUSS unter dem Gespräch *Speichern, später weitermachen* stehen. Der Stand MUSS das Abmelden überleben (K01 Abschn. 3).

*Konzept K05, Zeile 62 · Gegenprobe: gehalten*

**Vorgeschlagenes Kriterium**

```
⟨VORSCHLAG · NICHT GEZEICHNET⟩
ERFUELLT WENN: Auf EN-06 (Stufe 02) steht unter dem Gespraech die Bedienung mit dem Wortlaut
  „Speichern, später weitermachen"; nach ihrer erfolgreichen Ausfuehrung (Zustand Erfolg) zeigt
  dasselbe Gespraech nach Abmelden und erneutem Anmelden denselben Stand wie vor dem Abmelden —
  dieselben Beitraege, dieselben Herkunftsmarken, dieselben Uebersprungvermerke.
GEMESSEN DURCH: Aufbau: angemeldete Sitzung, Gespraech in Stufe 02 mit mindestens einem
  beantworteten Beitrag mit Herkunftsmarke und mindestens einer uebersprungenen Frage.
  Positivfall: die Bedienung unter dem Gespraech ablesen und ausloesen (save_interview_progress,
  Zustand Erfolg), abmelden, neu anmelden, das Gespraech wieder aufnehmen; erwartete
  Beobachtung: die rechte Spalte fuehrt dieselben Eintraege mit denselben Marken und denselben
  Uebersprungvermerken wie vor dem Abmelden. Negativfall a: derselbe Aufbau, dasselbe
  erfolgreich gemeldete Speichern, dieselbe erfolgreiche Neuanmeldung — nach der Wiederaufnahme
  fehlen Eintraege oder das Gespraech steht auf einem aelteren Stand; da Speichern Erfolg
  meldete und die Anmeldung gelang, scheitert der Fall allein am Ueberleben des Standes.
  Negativfall b: das Speichern wird zum Scheitern gebracht (Zustand Fehler); erwartete
  Beobachtung: die Meldung des Fehlerzustands erscheint und der vorige Stand bleibt gueltig —
  nicht erfuellt waere, wenn nach dem Abmelden ein halber, nie erfolgreich gespeicherter Stand
  erschiene.
· Quelle: „Ab Stufe 02 MUSS unter dem Gespräch *Speichern, später weitermachen* stehen. Der
  Stand MUSS das Abmelden überleben (K01 Abschn. 3)." ·
⟨zeichnet: ⟩ ⟨am: ⟩
```

`☐ gezeichnet   ☐ geändert (Wortlaut unten)   ☐ zurück an den Harness`

---

### K05-M16 · MUSS

> Stufe 02 MUSS oben in der rechten Spalte die Teilnehmer des Gesprächs nennen: mindestens den angemeldeten Nutzer und den Assistenten als Moderator. Die Liste ist nicht abgeschlossen; eingeladene Mitarbeiter treten hinzu (K05-M17).

*Konzept K05, Zeile 63 · Gegenprobe: gehalten*

**Vorgeschlagenes Kriterium**

```
⟨VORSCHLAG · NICHT GEZEICHNET⟩
ERFUELLT WENN: EN-06 nennt oben in der rechten Spalte — vor und unabhaengig von den uebrigen
  Eintraegen — die Teilnehmer des Gespraechs, darunter mindestens den angemeldeten Nutzer und
  den Assistenten als Moderator; tritt ein eingeladener Mitarbeiter hinzu (K05-M17), erscheint
  er zusaetzlich in derselben Liste, ohne dass ein bisheriger Teilnehmer entfaellt.
GEMESSEN DURCH: Aufbau: angemeldete Sitzung, EN-06 im Zustand laden, in dem laut Vertrag rechts
  nur die Teilnehmer stehen. Positivfall: die rechte Spalte von oben ablesen; erwartete
  Beobachtung: die Teilnehmerangabe steht an oberster Stelle und nennt den angemeldeten Nutzer
  und den Assistenten als Moderator. Danach tritt ein eingeladener Mitarbeiter dem Gespraech
  bei; erneut ablesen: die Liste nennt ihn zusaetzlich, die beiden bisherigen Nennungen stehen
  weiter. Negativfall: derselbe Aufbau mit vollstaendig ladendem Gespraech, aber die Liste nennt
  den Assistenten als Moderator nicht, oder sie steht nicht oben in der rechten Spalte, oder der
  hinzugetretene Mitarbeiter fehlt darin, obwohl seine Beitraege rechts erscheinen; der Fall
  scheitert allein an der Teilnehmernennung, nicht am Laden des Gespraechs.
· Quelle: „Stufe 02 MUSS oben in der rechten Spalte die Teilnehmer des Gesprächs nennen:
  mindestens den angemeldeten Nutzer und den Assistenten als Moderator. Die Liste ist nicht
  abgeschlossen; eingeladene Mitarbeiter treten hinzu (K05-M17)." ·
⟨zeichnet: ⟩ ⟨am: ⟩
```

`☐ gezeichnet   ☐ geändert (Wortlaut unten)   ☐ zurück an den Harness`

---

### K05-M17 · MUSS

> *Weitere Mitarbeiter einladen* MUSS über die Einladung laufen, die K20 führt (`invitation`, Eigentümer K20). K05 löst sie aus und beschreibt sie nicht.

*Konzept K05, Zeile 64 · Vorschlag vom 16.08.2026 · für M5 geprüft: trägt*

**Vorgeschlagenes Kriterium**

```
⟨VORSCHLAG · NICHT GEZEICHNET⟩
ERFUELLT WENN: Die Aktion 'Weitere Mitarbeiter einladen' aus Stufe 01/02 erzeugt den
  Einladungsstand ausschliesslich als Satz in invitation (Eigentuemer K20); K05 fuehrt fuer
  Einladungen weder eine eigene Tabelle noch eigene Felder.
GEMESSEN DURCH: Prueffall gegen Datenbank: Datenbestand vor und nach der Aktion vergleichen -
  neue Saetze entstehen nur in invitation; dazu Sichtpruefung eines Menschen am Datenmodell von
  K05 auf eigene Einladungstabellen oder -felder. NICHT ERFUELLT: Die Aktion erzeugt keinen
  invitation-Satz, oder der Einladungsstand wird zusaetzlich bzw. stattdessen in einer
  K05-eigenen Ablage gefuehrt. Der Fehlschlag muss an der Ablage der Einladung liegen. ---
  Begruendung der Beanstandung: Der Vorschlag setzt zwei Dinge zu, die im Wortlaut nicht stehen:
  (1) die Zahl 'genau einen neuen Satz' - die Klausel legt keine Anzahl fest; (2) den Umfang
  'legt weder Konto noch Mitgliedschaft noch Zugang an', der auch den Negativfall traegt
  ('Mitgliedschaft, Konto oder Zugang ohne invitation-Satz'). Konto, Mitgliedschaft und Zugang
  regelt diese Klausel nicht; ein Negativfall, der daran scheitert, misst eine fremde Bedingung.
  · [durch Gegenprobe ersetzt: erfunden]
· Erzeugt am 16.08.2026 auf Weisung E-6 (gez. M. Veil und A. Han). K23-M02: das Abnahmekriterium
  liefert der fachliche Eigentuemer — dieser Vorschlag nimmt ihm die Schreibarbeit ab, nicht die
  Entscheidung.
⟨zeichnet: ⟩ ⟨am: ⟩
```

`☐ gezeichnet   ☐ geändert (Wortlaut unten)   ☐ zurück an den Harness`

---

### K05-M18 · MUSS

> *Als Interview-Protokoll herunterladen* MUSS jederzeit den aktuellen Stand ausgeben, mit Herkunftsmarken und Übersprungvermerken. Träger ist `document` mit `document_kind = INTERVIEW_PROTOCOL` (Eigentümer K10).

*Konzept K05, Zeile 65 · Gegenprobe: **ersetzt · erfunden***

**Vorgeschlagenes Kriterium**

```
⟨VORSCHLAG · NICHT GEZEICHNET⟩
ERFUELLT WENN: Die Bedienung „Als Interview-Protokoll herunterladen" ist zu jedem Zeitpunkt des
  Gespraechs bedienbar und gibt den aktuellen Gespraechsstand aus; die Ausgabe fuehrt zu jedem
  Beitrag seine Herkunftsmarke und zu jeder uebersprungenen Frage ihren Uebersprungvermerk;
  Traeger der Ausgabe ist eine `document`-Zeile mit `document_kind = INTERVIEW_PROTOCOL`.
GEMESSEN DURCH: Aufbau: angemeldete Sitzung, Gespraech in Stufe 02 mit mindestens einem Beitrag
  mit Herkunftsmarke (EN-06 · vorschlag_waehlen · Zustand Erfolg) und mindestens einer
  uebersprungenen Frage (EN-06 · frage_ignorieren · Zustand Erfolg: rechts steht ausschliesslich
  der Wortlaut (Frage uebersprungen), ohne Marke). Positivfall: herunterladen; erwartete
  Beobachtung: die Ausgabe enthaelt jeden Beitrag des Standes mit derselben Herkunftsmarke und
  jeden Uebersprungvermerk, und die ausgegebene Datei ist in `document` mit `document_kind =
  INTERVIEW_PROTOCOL` registriert. Danach eine weitere Antwort geben (Zustand Erfolg),
  zwischenspeichern (EN-06 · zwischenspeichern · Zustand Erfolg) und erneut herunterladen;
  erwartete Beobachtung: die zweite Ausgabe fuehrt zusaetzlich den neuen Beitrag mit seiner
  Marke. Negativfall: derselbe Aufbau, der weitere Beitrag ist erfolgreich erfasst und das
  Speichern meldet Erfolg, aber die erneute Ausgabe fuehrt ihn nicht, oder sie laesst
  Herkunftsmarken oder Uebersprungvermerke weg, obwohl beide im Stand stehen, oder sie stammt
  nicht aus einer `document`-Zeile mit `document_kind = INTERVIEW_PROTOCOL`; da Erfassung und
  Speichern gelingen, scheitert der Fall allein an der Ausgabe. Offen fuer den fachlichen
  Eigentuemer: ob „jederzeit den aktuellen Stand" auch Eingaben umfasst, die noch nicht als
  Dateistand geschrieben sind — der Wortlaut sagt es nicht, und nach K05-M26 bestimmt der
  juengste erfolgreiche Eventeintrag den Stand; ohne seine Festlegung wird gegen den
  geschriebenen Stand gemessen. Ebenso, auf welchem Bildschirm die Bedienung steht: EN-05 und
  EN-06 fuehren sie im Bildschirmvertrag nicht.
· Quelle: „*Als Interview-Protokoll herunterladen* MUSS jederzeit den aktuellen Stand ausgeben,
  mit Herkunftsmarken und Übersprungvermerken. Träger ist `document` mit `document_kind =
  INTERVIEW_PROTOCOL` (Eigentümer K10)." ·
⟨zeichnet: ⟩ ⟨am: ⟩
```

`☐ gezeichnet   ☐ geändert (Wortlaut unten)   ☐ zurück an den Harness`

---

### K05-M19 · MUSS

> *Bin fertig mit dem Interview* MUSS `journey_phase` auf UEBERSICHT setzen (Eigentümer K01), einen Protokolleintrag in `event` erzeugen (Eigentümer K02) und den Gesprächsstand an K06 übergeben. Wie bei K05-M08 gilt: ohne Eintrag kein Wechsel.

*Konzept K05, Zeile 66 · Gegenprobe: gehalten*

**Vorgeschlagenes Kriterium**

```
⟨VORSCHLAG · NICHT GEZEICHNET⟩
ERFUELLT WENN: Nach der Bedienung „Bin fertig mit dem Interview" liegen drei Wirkungen gemeinsam
  vor: `app.journey_phase` steht auf UEBERSICHT, in `event` steht ein neuer Protokolleintrag zu
  diesem Vorgang (im Bildschirmvertrag mit `source = PORTAL_ACTION`), und der Gespraechsstand
  ist an K06 uebergeben; entsteht der Eintrag nicht, findet auch kein Wechsel statt und keine
  der drei Wirkungen bleibt zurueck.
GEMESSEN DURCH: Aufbau: Gespraech in Stufe 02 mit vorhandenem Stand, angemeldete Sitzung mit den
  fuer diesen Aufruf noetigen Rechten; `journey_phase` vor dem Versuch abgelesen (INTERVIEW).
  Positivfall: Bedienung ausloesen (complete_interview, Zustand Erfolg); erwartete Beobachtung:
  `journey_phase` = UEBERSICHT, ein neuer `event`-Eintrag zu diesem Vorgang, der Stand liegt bei
  K06, weiter nach EN-07. Negativfall: derselbe Aufbau, gleiche Rechte, gleiche gueltige
  Eingangslage, aber der Protokolleintrag in `event` wird zum Scheitern gebracht; erwartete
  Beobachtung: die Meldung des Fehlerzustands, `journey_phase` steht unveraendert auf INTERVIEW,
  keine Uebergabe an K06 — nicht erfuellt ist das Kriterium, wenn nach dem gescheiterten Eintrag
  die Phase gewechselt hat oder der Stand uebergeben wurde. Da Anmeldung, Rechte und
  Gespraechsstand gueltig sind, scheitert der Fall allein am Protokolleintrag.
· Quelle: „*Bin fertig mit dem Interview* MUSS `journey_phase` auf UEBERSICHT setzen (Eigentümer
  K01), einen Protokolleintrag in `event` erzeugen (Eigentümer K02) und den Gesprächsstand an
  K06 übergeben. Wie bei K05-M08 gilt: ohne Eintrag kein Wechsel." ·
⟨zeichnet: ⟩ ⟨am: ⟩
```

`☐ gezeichnet   ☐ geändert (Wortlaut unten)   ☐ zurück an den Harness`

---

### K05-M21 · MUSS

> Diktierter Text MUSS vor dem Absenden im Eingabefeld sichtbar und änderbar sein. Er zählt als eigene Angabe des Nutzers.

*Konzept K05, Zeile 68 · Gegenprobe: gehalten*

**Vorgeschlagenes Kriterium**

```
⟨VORSCHLAG · NICHT GEZEICHNET⟩
ERFUELLT WENN: Diktierter Text steht vor dem Absenden im Eingabefeld von EN-06 sichtbar, ist
  dort vom Nutzer aenderbar, und der abgesendete Beitrag erscheint rechts mit der Marke „Ihre
  Angabe" — er zaehlt also als eigene Angabe des Nutzers.
GEMESSEN DURCH: Aufbau: EN-06 mit offener Fachfrage, funktionierende Spracherkennung,
  angemeldete Sitzung. Positivfall: diktieren und vor dem Senden das Eingabefeld ablesen;
  erwartete Beobachtung: der diktierte Wortlaut steht dort; ihn im Feld aendern (Wort streichen
  und ein anderes tippen), dann senden; erwartete Beobachtung: rechts erscheint der geaenderte
  Wortlaut mit der Marke „Ihre Angabe". Negativfall: derselbe Aufbau mit funktionierender
  Erkennung und erfolgreichem Senden, aber das Diktat wird ohne Zwischenstand im Feld
  unmittelbar abgesendet, oder das Feld nimmt keine Aenderung am diktierten Text an, oder der
  abgesendete Beitrag erscheint rechts mit einer anderen Marke als „Ihre Angabe"; da Erkennung
  und Speichern gelingen, scheitert der Fall allein an Sichtbarkeit, Aenderbarkeit oder
  Zurechnung des diktierten Textes.
· Quelle: „Diktierter Text MUSS vor dem Absenden im Eingabefeld sichtbar und änderbar sein. Er
  zählt als eigene Angabe des Nutzers." ·
⟨zeichnet: ⟩ ⟨am: ⟩
```

`☐ gezeichnet   ☐ geändert (Wortlaut unten)   ☐ zurück an den Harness`

---

### K05-M22 · MUSS

> Jede Eingabe — getippt, diktiert oder hochgeladen — MUSS als Daten behandelt werden. Eine darin enthaltene Handlungsanweisung wird nicht ausgeführt (K01 Abschn. 3, Agentenbetrieb K17).

*Konzept K05, Zeile 69 · Gegenprobe: gehalten*

**Vorgeschlagenes Kriterium**

```
⟨VORSCHLAG · NICHT GEZEICHNET⟩
ERFUELLT WENN: Eine Eingabe, deren Wortlaut eine Handlungsanweisung an das System enthaelt,
  wirkt ausschliesslich als Antwortdaten: sie erscheint rechts als Beitrag, und die im Text
  verlangte Handlung ist nicht ausgefuehrt — das gilt fuer getippte, diktierte und hochgeladene
  Eingaben gleichermassen.
GEMESSEN DURCH: Aufbau: EN-06 mit offener Fachfrage, angemeldete Sitzung; als Eingabewortlaut
  wird eine Anweisung gewaehlt, die genau eine der Aktionen dieses Bildschirms verlangt (etwa
  das Ueberspringen der gestellten Frage oder das Beenden des Interviews). Positivfall:
  denselben Wortlaut je einmal getippt und einmal diktiert senden; erwartete Beobachtung: rechts
  steht der Wortlaut als Beitrag mit Marke, die Fachfrage traegt keinen Uebersprungvermerk,
  `journey_phase` ist unveraendert, es wurde keine Uebergabe ausgeloest. Negativfall: derselbe
  Aufbau, dieselbe erfolgreich erfasste Eingabe, aber nach dem Senden ist die im Text verlangte
  Handlung eingetreten (Frage als uebersprungen vermerkt oder Interview uebergeben), ohne dass
  der Nutzer die zugehoerige Schaltflaeche bedient hat; da die Eingabe erfasst wurde und rechts
  steht, scheitert der Fall allein an der Grenze zwischen Daten und Anweisung.
· Stufe: der hochgeladene Weg zurueckgestellt (Blatt 100, E4); er wird nach derselben Vorschrift
  gemessen, sobald `upload_interview_document` gebaut ist.
· Quelle: „Jede Eingabe — getippt, diktiert oder hochgeladen — MUSS als Daten behandelt werden.
  Eine darin enthaltene Handlungsanweisung wird nicht ausgeführt (K01 Abschn. 3, Agentenbetrieb
  K17)." ·
⟨zeichnet: ⟩ ⟨am: ⟩
```

`☐ gezeichnet   ☐ geändert (Wortlaut unten)   ☐ zurück an den Harness`

---

### K05-M23 · MUSS

> Vor jeder Übergabe an ein Sprachmodell MÜSSEN personenbezogene Angaben maskiert werden; die Rückauflösung bleibt in der Plattform (K01 Abschn. 3, Modellpfad K17).

*Konzept K05, Zeile 70 · Gegenprobe: **ersetzt · erfunden***

**Vorgeschlagenes Kriterium**

```
⟨VORSCHLAG · NICHT GEZEICHNET⟩
ERFUELLT WENN: Keine Sendung an ein Sprachmodell fuehrt eine Angabe, die der fachliche
  Eigentuemer als personenbezogen benannt hat, im Wortlaut — sie steht in der Sendung nur als
  Maske; die Zuordnung von Maske zu Original ist nicht Teil der Sendung, sondern wird nur in der
  Plattform aufgeloest; ist Maskierung oder Modellpfad unvollstaendig, ergeht kein Aufruf und
  die Frage bleibt unbeantwortet stehen (EN-06 · freitext_antworten · Zustand Fehler).
GEMESSEN DURCH: Aufbau: EN-06 mit offener Fachfrage, angemeldete Sitzung; die Antwort enthaelt
  je eine der vom fachlichen Eigentuemer benannten personenbezogenen Angaben; die an das Modell
  abgehende Sendung wird mitgeschnitten. Positivfall: Antwort senden (record_interview_answer,
  Zustand Erfolg); erwartete Beobachtung: in der mitgeschnittenen Sendung kommt keine der
  benannten Angaben im Wortlaut vor, sondern je eine Maske, und die Zuordnung Maske zu Original
  ist in der Sendung nicht enthalten. Negativfall a: derselbe Aufbau, der Modellaufruf gelingt
  und liefert eine Antwort, aber die mitgeschnittene Sendung fuehrt eine der benannten Angaben
  im Wortlaut oder traegt die Zuordnung Maske zu Original mit; da der Modellpfad im Uebrigen
  arbeitet, scheitert der Fall allein an der Maskierung. Negativfall b: die Maskierung wird
  unvollstaendig gemacht; erwartete Beobachtung nach dem Bildschirmvertrag: kein Modellaufruf,
  die Frage bleibt unbeantwortet stehen — nicht erfuellt, wenn der Aufruf trotzdem abgeht. Offen
  fuer den fachlichen Eigentuemer: welche Angaben als personenbezogen gelten. Der Wortlaut nennt
  keine; ohne diese Liste hat der Prueffall keine Eingabedaten, und der Massstab bliebe eine
  Festlegung des Pruefers.
· Quelle: „Vor jeder Übergabe an ein Sprachmodell MÜSSEN personenbezogene Angaben maskiert
  werden; die Rückauflösung bleibt in der Plattform (K01 Abschn. 3, Modellpfad K17)." ·
⟨zeichnet: ⟩ ⟨am: ⟩
```

`☐ gezeichnet   ☐ geändert (Wortlaut unten)   ☐ zurück an den Harness`

---

### K05-M25 · MUSS

> Der fachliche Gesprächsstand wird als unveränderlicher, strukturierter Dateistand mit `document_kind = INTERVIEW_PROTOCOL` geführt. `document` (Eigentümer K10) registriert die Datei; ihr Format enthält `app_id`, Revision, Zeit, Reihenfolge und je Beitrag `actor.id` (Eigentümer K03), Erzeugungsart, Herkunft, Bearbeitungszustand sowie Hash des Vorgängers. K05 besitzt weiterhin keine Tabelle.

*Konzept K05, Zeile 328 · Gegenprobe: **ersetzt · erfunden***

**Vorgeschlagenes Kriterium**

```
⟨VORSCHLAG · NICHT GEZEICHNET⟩
ERFUELLT WENN: Der fachliche Gespraechsstand liegt als strukturierter Dateistand vor, den eine
  `document`-Zeile mit `document_kind = INTERVIEW_PROTOCOL` registriert; das Format der Datei
  fuehrt `app_id`, Revision, Zeit und Reihenfolge und je Beitrag `actor.id`, Erzeugungsart,
  Herkunft, Bearbeitungszustand sowie den Hash des Vorgaengers; ein einmal geschriebener Stand
  ist unveraenderlich — er laesst sich nicht ueberschreiben und liest sich unveraendert zurueck;
  und der Gespraechsstand wird in keiner Tabelle gefuehrt, die das Datenmodell K05 zuordnet.
GEMESSEN DURCH: Aufbau: angemeldete Sitzung, Gespraech in Stufe 02; Datei-, `document`- und
  Tabellenbestand vor der Handlung festgehalten. Positivfall: einen Beitrag erfassen und
  zwischenspeichern (EN-06 · zwischenspeichern · Zustand Erfolg), danach einen zweiten Beitrag
  erfassen und erneut zwischenspeichern; erwartete Beobachtung: zu jedem der beiden
  Speichervorgaenge gehoert ein Dateistand mit einer `document`-Zeile mit `document_kind =
  INTERVIEW_PROTOCOL`; die Datei fuehrt alle im Wortlaut genannten Felder; der im zweiten Stand
  gefuehrte Hash des Vorgaengers ist der Hash des ersten Standes; ein Schreibversuch auf den
  ersten Stand geht nicht durch und dieser liest sich unveraendert zurueck; der
  Bestandsvergleich zeigt keine neue Zeile in einer Tabelle, die das Datenmodell K05 zuordnet.
  Negativfall: derselbe Aufbau, der Beitrag ist erfasst und das Speichern meldet Erfolg, aber im
  Dateiformat fehlt eines der genannten Felder (etwa der Hash des Vorgaengers), oder der bereits
  geschriebene Stand laesst sich ueberschreiben und liest sich veraendert zurueck, oder der
  Stand steht zusaetzlich in einer K05 zugeordneten Tabelle; da Erfassung und Speichern
  gelingen, scheitert der Fall allein an Traeger, Format, Unveraenderlichkeit oder
  Tabellenfreiheit. Offen fuer den fachlichen Eigentuemer: in welchem Takt der Dateistand
  fortgeschrieben wird — der Wortlaut bindet ihn an keinen einzelnen Beitrag; bis zu seiner
  Festlegung wird je Speichervorgang nach K05-M26 gemessen.
· Quelle: „Der fachliche Gesprächsstand wird als unveränderlicher, strukturierter Dateistand mit
  `document_kind = INTERVIEW_PROTOCOL` geführt. `document` (Eigentümer K10) registriert die
  Datei; ihr Format enthält `app_id`, Revision, Zeit, Reihenfolge und je Beitrag `actor.id`
  (Eigentümer K03), Erzeugungsart, Herkunft, Bearbeitungszustand sowie Hash des Vorgängers. K05
  besitzt weiterhin keine Tabelle." ·
⟨zeichnet: ⟩ ⟨am: ⟩
```

`☐ gezeichnet   ☐ geändert (Wortlaut unten)   ☐ zurück an den Harness`

---

### K05-M26 · MUSS

> Jeder erfolgreiche Speichervorgang erzeugt zuerst die Datei, dann die `document`-Zeile und zuletzt ein append-only `event`. Der jüngste erfolgreiche Eventeintrag je Anwendung verweist in `object_ref` auf Dokument-ID und Hash und bestimmt den wiederaufnehmbaren Stand. Ein unvollständiger Dreischritt wird nicht sichtbar.

*Konzept K05, Zeile 329 · Gegenprobe: gehalten*

**Vorgeschlagenes Kriterium**

```
⟨VORSCHLAG · NICHT GEZEICHNET⟩
ERFUELLT WENN: Jeder erfolgreiche Speichervorgang legt in dieser Reihenfolge an: zuerst die
  Datei, dann die `document`-Zeile, zuletzt einen `event`-Eintrag, der sich nicht mehr aendern
  oder loeschen laesst; der juengste erfolgreiche `event`-Eintrag je Anwendung verweist in
  `object_ref` auf Dokument-ID und Hash und ist genau der Stand, der bei der Wiederaufnahme
  erscheint; bricht einer der drei Schritte ab, wird nichts von diesem unvollstaendigen
  Dreischritt sichtbar.
GEMESSEN DURCH: Aufbau: Gespraech in Stufe 02 mit vorhandenem Stand; Datei-, `document`- und
  `event`-Bestand vor dem Speichern festgehalten. Positivfall: zwischenspeichern (Zustand
  Erfolg); erwartete Beobachtung: die drei Saetze sind in der Reihenfolge Datei,
  `document`-Zeile, `event` entstanden; ein Aenderungs- oder Loeschversuch am `event`-Eintrag
  geht nicht durch; `object_ref` des juengsten Eintrags nennt Dokument-ID und Hash der eben
  registrierten Datei; nach Abmelden und Wiederanmelden zeigt die Wiederaufnahme genau diesen
  Stand. Zweites Speichern nach einem weiteren Beitrag: nun bestimmt der neue juengste Eintrag
  die Wiederaufnahme. Negativfall: derselbe Aufbau, Datei und `document`-Zeile werden
  geschrieben, der `event`-Schritt wird zum Scheitern gebracht; erwartete Beobachtung nach dem
  Bildschirmvertrag: die Meldung des Fehlerzustands, der vorige Stand bleibt gueltig, und nach
  Abmelden und Wiederanmelden erscheint der vorige Stand — nicht erfuellt, wenn der halbfertige
  Stand rechts sichtbar wird oder die Wiederaufnahme ihm folgt, oder wenn die Wiederaufnahme
  einem aelteren als dem juengsten erfolgreichen Eintrag folgt. Anmeldung und Rechte sind
  gueltig, damit der Fall allein am Dreischritt scheitert.
· Quelle: „Jeder erfolgreiche Speichervorgang erzeugt zuerst die Datei, dann die
  `document`-Zeile und zuletzt ein append-only `event`. … Ein unvollständiger Dreischritt wird
  nicht sichtbar." ·
⟨zeichnet: ⟩ ⟨am: ⟩
```

`☐ gezeichnet   ☐ geändert (Wortlaut unten)   ☐ zurück an den Harness`

---

### K05-M28 · MUSS

> *Ihre Angabe* bleibt die einfache Anzeige. Revisionsfest führt der Dateistand zusätzlich `actor.id` (Eigentümer K03); KI-Beiträge führen Modell-, Prompt- und Quellenversion. Änderung und Ursprung bleiben getrennt.

*Konzept K05, Zeile 331 · Gegenprobe: **ersetzt · erfunden***

**Vorgeschlagenes Kriterium**

```
⟨VORSCHLAG · NICHT GEZEICHNET⟩
ERFUELLT WENN: Am Bildschirm traegt ein Nutzerbeitrag als Anzeige die Marke „Ihre Angabe" (EN-06
  · freitext_antworten · Zustand Erfolg); derselbe Beitrag fuehrt im Dateistand zusaetzlich
  `actor.id`; ein KI-Beitrag fuehrt im Dateistand Modellversion, Promptversion und
  Quellenversion; und Aenderung und Ursprung stehen im Dateistand als zwei getrennte Angaben —
  Bearbeitungszustand und Herkunft (K05-M25) werden nie in einer Angabe zusammengefuehrt.
GEMESSEN DURCH: Aufbau: EN-06 mit einem Nutzerbeitrag im Freitext und einem KI-Beitrag im selben
  Stand; der Dateistand wird gelesen. Positivfall: rechts ablesen — der Nutzerbeitrag traegt
  genau eine Herkunftsmarke, naemlich „Ihre Angabe" (K05-M11); im Dateistand fuehrt derselbe
  Beitrag `actor.id`, der KI-Beitrag fuehrt Modell-, Prompt- und Quellenversion;
  Bearbeitungszustand und Herkunft stehen als zwei voneinander unabhaengige Angaben, deren Werte
  sich einzeln lesen lassen. Negativfall: derselbe Aufbau, der Beitrag ist erfolgreich erfasst
  und steht rechts mit seiner Marke, aber im Dateistand fehlt `actor.id` beim Nutzerbeitrag oder
  eine der drei Versionsangaben beim KI-Beitrag, oder Bearbeitungszustand und Herkunft stehen in
  einer einzigen Angabe, sodass ein geaenderter Bearbeitungszustand die Herkunft mitveraendert;
  da die Erfassung gelang, scheitert der Fall allein an der Revisionsfestigkeit und an der
  Trennung von Aenderung und Ursprung. Offen fuer den fachlichen Eigentuemer: EN-05 und EN-06
  fuehren keine Aktion zum Bearbeiten eines Beitrags, und der Dateistand ist nach K05-M25
  unveraenderlich; wo und an welcher Handlung die Trennung an einer tatsaechlichen Bearbeitung
  nachzuweisen ist, legt er fest.
· Quelle: „*Ihre Angabe* bleibt die einfache Anzeige. Revisionsfest führt der Dateistand
  zusätzlich `actor.id` (Eigentümer K03); KI-Beiträge führen Modell-, Prompt- und
  Quellenversion. Änderung und Ursprung bleiben getrennt." ·
⟨zeichnet: ⟩ ⟨am: ⟩
```

`☐ gezeichnet   ☐ geändert (Wortlaut unten)   ☐ zurück an den Harness`

---

### K05-M29 · MUSS

> Uploads werden vor Nutzung auf Typ, Größe, Malware und aktiven Inhalt geprüft. Nicht prüfbare Dateien bleiben in Quarantäne. Text aus Datei, Tastatur oder Diktat gilt als Daten und kann keine Tools oder Systemregeln steuern.

*Konzept K05, Zeile 332 · Gegenprobe: gehalten*

**Vorgeschlagenes Kriterium**

```
⟨VORSCHLAG · NICHT GEZEICHNET⟩
ERFUELLT WENN: Vor jeder Nutzung einer hochgeladenen Datei — vor dem Eintrag rechts, vor der
  Aufnahme in den Gespraechsstand und vor jedem Modellaufruf — liegen die vier Pruefungen auf
  Typ, Groesse, Malware und aktiven Inhalt je mit einem Ergebnis vor; liefert eine davon kein
  Ergebnis, bleibt die Datei in Quarantaene, es erscheint eine Meldung, die den Grund nennt, und
  rechts entsteht kein Eintrag; Text aus Datei, Tastatur oder Diktat wirkt nur als Daten und
  steuert kein Werkzeug und keine Systemregel.
GEMESSEN DURCH: Aufbau: EN-06 mit offener Fachfrage, angemeldete Sitzung mit Anhangrecht.
  Positivfall: eine pruefbare Datei anhaengen; erwartete Beobachtung: die vier Pruefungen liegen
  je mit Ergebnis vor, bevor die Datei irgendwo verwendet wird; danach erscheint rechts der
  Eintrag mit Marke „Ihre Angabe" und die Datei geht in den INTERVIEW_PROTOCOL-Stand ein.
  Zweiter Positivfall: eine pruefbare Datei, deren Text eine Handlungsanweisung enthaelt — sie
  wird als Antwort erfasst, die verlangte Handlung tritt nicht ein. Negativfall: eine Datei,
  fuer die eine der vier Pruefungen kein Ergebnis liefert (die Pruefung ist nicht
  durchfuehrbar); erwartete Beobachtung: die Datei bleibt in Quarantaene, die Meldung nennt den
  Grund, rechts entsteht kein Eintrag und es ergeht kein Modellaufruf — nicht erfuellt, wenn die
  Datei trotz fehlenden Pruefergebnisses genutzt wird, wenn der Eintrag rechts erscheint oder
  wenn die Meldung keinen Grund nennt. Uebertragung und Recht sind in Ordnung, damit der Fall
  allein an der Pruefbarkeit scheitert.
· Stufe: zurueckgestellt (Blatt 100, E4).
· Quelle: „Uploads werden vor Nutzung auf Typ, Größe, Malware und aktiven Inhalt geprüft. Nicht
  prüfbare Dateien bleiben in Quarantäne. Text aus Datei, Tastatur oder Diktat gilt als Daten
  und kann keine Tools oder Systemregeln steuern." ·
⟨zeichnet: ⟩ ⟨am: ⟩
```

`☐ gezeichnet   ☐ geändert (Wortlaut unten)   ☐ zurück an den Harness`

---

### K05-M30 · MUSS

> Der freihändige Sprachweg bleibt in Release 1 ausgeblendet und serverseitig gesperrt. Diktat bleibt zulässig, wenn der Text vor dem Senden sichtbar und änderbar ist.

*Konzept K05, Zeile 333 · Gegenprobe: **ersetzt · nicht_messbar***

**Vorgeschlagenes Kriterium**

```
⟨VORSCHLAG · NICHT GEZEICHNET⟩
ERFUELLT WENN: Im Release-1-Stand ist auf EN-05 und EN-06 keine Bedienung fuer den freihaendigen
  Sprachweg sichtbar; ein am Bildschirm vorbei abgesetzter Aufruf dieses Weges wird serverseitig
  abgewiesen und hinterlaesst keine Wirkung — auch bei gueltiger Anmeldung, gueltigen Rechten
  und formal gueltigen Angaben; das Diktat bleibt nutzbar und sein Text steht vor dem Senden
  sichtbar und aenderbar im Eingabefeld.
GEMESSEN DURCH: Aufbau: Release-1-Stand, angemeldete Sitzung mit allen sonst noetigen Rechten;
  der zu pruefende Serverpfad des freihaendigen Sprachweges ist vor dem Lauf benannt.
  Positivfall: EN-05 und EN-06 ablesen; erwartete Beobachtung: keine Bedienung fuer den
  freihaendigen Sprachweg sichtbar. Den benannten Serverpfad unmittelbar aufrufen; erwartete
  Beobachtung: der Aufruf wird abgewiesen, und es entsteht kein Eintrag rechts, kein Dateistand,
  keine `document`-Zeile und kein `event`-Eintrag. Danach diktieren; erwartete Beobachtung: der
  Text steht sichtbar und aenderbar im Freitextfeld und laesst sich senden. Negativfall:
  derselbe Aufbau, die Bedienung ist nicht sichtbar, aber der unmittelbare Serveraufruf wird
  angenommen und fuehrt das Gespraech freihaendig; da Anmeldung, Rechte und Angaben gueltig
  sind, scheitert der Fall allein an der fehlenden serverseitigen Sperre. Ebenfalls nicht
  erfuellt, wenn die Bedienung sichtbar ist oder wenn das Diktat nicht mehr moeglich ist, obwohl
  sein Text sichtbar und aenderbar waere. Offen fuer den fachlichen Eigentuemer: welcher
  Serverpfad als der des freihaendigen Sprachweges gilt — keiner der Serverbefehle des
  Bildschirmvertrags fuehrt ihn; ohne diese Benennung ist „serverseitig gesperrt" nicht von
  „nicht gebaut" zu unterscheiden.
· Quelle: „Der freihändige Sprachweg bleibt in Release 1 ausgeblendet und serverseitig gesperrt.
  Diktat bleibt zulässig, wenn der Text vor dem Senden sichtbar und änderbar ist." ·
⟨zeichnet: ⟩ ⟨am: ⟩
```

`☐ gezeichnet   ☐ geändert (Wortlaut unten)   ☐ zurück an den Harness`

---

### K05-M31 · MUSS

> Mitarbeiter im ENDUSER-Portal werden über dieselbe `invitation`-Tabelle und denselben Sicherheitsweg wie EXMA-Zugänge eingeladen. Die Portalrolle und Mitgliedschaft sind portalbezogen; die Herkunft jedes Beitrags bleibt personenbezogen belegbar.

*Konzept K05, Zeile 334 · Gegenprobe: **ersetzt · nicht_messbar***

**Vorgeschlagenes Kriterium**

```
⟨VORSCHLAG · NICHT GEZEICHNET⟩
ERFUELLT WENN: Die Einladung eines Mitarbeiters in das ENDUSER-Portal entsteht als Satz in
  derselben `invitation`-Tabelle wie eine EXMA-Einladung und durchlaeuft dieselben Schritte des
  Sicherheitsweges, wie der fachliche Eigentuemer sie fuer EXMA benannt hat — kein Schritt
  entfaellt, keiner tritt hinzu; Portalrolle und Mitgliedschaft wirken nur in dem Portal, fuer
  das sie erteilt wurden; und jeder Beitrag des Eingeladenen ist im Gespraechsstand seiner
  Person zugeordnet (`actor.id`, K05-M25) und von den Beitraegen anderer Teilnehmer
  unterscheidbar.
GEMESSEN DURCH: Aufbau: Datenbestand vor den Handlungen festgehalten; die Schrittfolge des EXMA-
  Sicherheitsweges liegt benannt vor; je eine Einladung wird ausgeloest — ein Mitarbeiter in das
  ENDUSER-Portal, ein Zugang in EXMA. Positivfall: beide Einladungen ausloesen und den Bestand
  vergleichen; erwartete Beobachtung: beide erzeugen ihren Satz in `invitation`, und die
  durchlaufenen Schritte sind bei beiden dieselben wie in der benannten Schrittfolge. Danach
  meldet sich der eingeladene Mitarbeiter an und gibt auf EN-06 eine Antwort
  (record_interview_answer, Zustand Erfolg); erwartete Beobachtung: der Beitrag steht rechts,
  traegt im Dateistand die `actor.id` des Mitarbeiters und ist von den Beitraegen des
  Einladenden unterscheidbar. Negativfall: dieselbe, erfolgreich zugestellte und angenommene
  ENDUSER-Einladung, aber ihr Satz steht ausserhalb von `invitation`, oder ein Schritt der
  benannten Schrittfolge entfaellt, oder der Beitrag des Eingeladenen traegt keine
  Personenzuordnung; da die Einladung selbst gelingt und der Beitrag erfasst wird, scheitert der
  Fall allein am gemeinsamen Weg oder an der Belegbarkeit der Herkunft. Offen fuer den
  fachlichen Eigentuemer: die Schritte des EXMA-Sicherheitsweges — der Wortlaut nennt keinen;
  ohne ihre Benennung ist „derselbe Sicherheitsweg" nicht gleich auswertbar. Ebenso, an welcher
  Bedienung die Portalbindung von Rolle und Mitgliedschaft gemessen wird: EN-05 und EN-06
  fuehren keine Aktion zum Einladen.
· Quelle: „Mitarbeiter im ENDUSER-Portal werden über dieselbe `invitation`-Tabelle und denselben
  Sicherheitsweg wie EXMA-Zugänge eingeladen. Die Portalrolle und Mitgliedschaft sind
  portalbezogen; die Herkunft jedes Beitrags bleibt personenbezogen belegbar." ·
⟨zeichnet: ⟩ ⟨am: ⟩
```

`☐ gezeichnet   ☐ geändert (Wortlaut unten)   ☐ zurück an den Harness`

---

### K05-M32 · MUSS

> Dynamische Änderungen werden als Statusmeldung für Hilfstechnologien ausgegeben; Tastaturreihenfolge, Fehlerfokus und gleichwertiger Textweg sind Pflicht. Speichern, Upload und Übergabe besitzen eindeutige Erfolg-, Fehler- und Wiederaufnahmezustände.

*Konzept K05, Zeile 335 · Gegenprobe: **ersetzt · nicht_messbar***

**Vorgeschlagenes Kriterium**

```
⟨VORSCHLAG · NICHT GEZEICHNET⟩
ERFUELLT WENN: Auf EN-05 und EN-06 gilt: zu jeder dynamischen Aenderung — neuer Eintrag rechts,
  Erscheinen der Folgefrage, Wechsel eines Zustands — ergeht eine Statusmeldung fuer
  Hilfstechnologien; jede Bedienung des Bildschirms ist ueber die Tastatur erreichbar und
  ausloesbar; nach einem Fehler traegt die Fehlermeldung den Tastaturfokus; und Speichern
  (save_interview_progress) sowie Uebergabe (complete_interview) fuehren je einen eigenen,
  voneinander unterscheidbaren Erfolgs-, Fehler- und Wiederaufnahmezustand.
GEMESSEN DURCH: Aufbau: EN-06 mit vorhandenem Gespraechsstand, Bedienung ausschliesslich ueber
  die Tastatur, mitlaufende Ausgabe der Hilfstechnologie. Positivfall 1 (Statusmeldung): eine
  Antwort senden und eine Frage ueberspringen; erwartete Beobachtung: zu jedem neuen Eintrag
  rechts und zu jedem Zustandswechsel ergeht eine Statusmeldung. Positivfall 2 (Tastatur): jede
  Bedienung des Bildschirms wird ohne Zeigergeraet erreicht und ausgeloest. Positivfall 3
  (Fehlerfokus): einen Fehler erzwingen (EN-06 · zwischenspeichern · Zustand Fehler); erwartete
  Beobachtung: der Tastaturfokus steht auf der Fehlermeldung. Positivfall 4 (Zustaende):
  zwischenspeichern, abmelden, neu anmelden, wiederaufnehmen, uebergeben; erwartete Beobachtung:
  Erfolgszustand, Fehlerzustand und Wiederaufnahmezustand sind je eigens benannt und voneinander
  unterscheidbar. Negativfall zu Positivfall 1: derselbe Aufbau, die Antwort wird erfolgreich
  erfasst und steht rechts, aber zu dem neuen Eintrag ergeht keine Statusmeldung — da die
  Erfassung gelingt, scheitert der Fall allein an der Statusmeldung. Negativfall zu Positivfall
  3: derselbe erzwungene Fehler, die Meldung erscheint, aber der Fokus bleibt auf der
  Schaltflaeche. Negativfall zu Positivfall 4: Erfolgs- und Fehlerausgang des Speicherns enden
  im selben angezeigten Zustand, obwohl der eine gelingt und der andere scheitert. Offen fuer
  den fachlichen Eigentuemer: welcher Reihenfolge die Tastaturfuehrung folgen muss und was ein
  „gleichwertiger Textweg" leisten muss — der Wortlaut fuehrt beides als Pflicht, ohne einen
  Massstab zu setzen; bis zu seiner Festlegung bleiben diese beiden Teile ungemessen.
· Stufe: der Upload-Teil zurueckgestellt (Blatt 100, E4).
· Quelle: „Dynamische Änderungen werden als Statusmeldung für Hilfstechnologien ausgegeben;
  Tastaturreihenfolge, Fehlerfokus und gleichwertiger Textweg sind Pflicht. Speichern, Upload
  und Übergabe besitzen eindeutige Erfolg-, Fehler- und Wiederaufnahmezustände." ·
⟨zeichnet: ⟩ ⟨am: ⟩
```

`☐ gezeichnet   ☐ geändert (Wortlaut unten)   ☐ zurück an den Harness`

---

### K10 — 3 Klauseln (3 von der Gegenprobe gehalten, 0 ersetzt)

---

### K10-M01 · MUSS

> Jedes Dokument MUSS als genau eine Zeile in `document` bestehen und einer Anwendung zugeordnet sein. Ohne Anwendung entsteht kein Dokument.

*Konzept K10, Zeile 44 · Gegenprobe: gehalten*

**Vorgeschlagenes Kriterium**

```
⟨VORSCHLAG · NICHT GEZEICHNET⟩
ERFUELLT WENN: Zu jedem Dokument steht genau eine Zeile in document, und diese Zeile ist einer
  Anwendung zugeordnet; ohne Anwendung entsteht keine Zeile.
GEMESSEN DURCH: Aufbau: Zaehlstand der document-Zeilen lesen. Positivfall: EN-06 ·
  zwischenspeichern in Zustand Erfolg ausloesen — Dreischritt Datei, document-Zeile, event;
  danach steht zum gespeicherten Stand genau eine neue document-Zeile, und ihre Zuordnung zeigt
  ueber document.app_id auf die Anwendung des Gespraechs; abmelden, neu anmelden, weitermachen —
  dieselbe eine Zeile traegt den wieder aufgenommenen Stand. Negativfall (muss ohne Zeile
  enden): derselbe Speichervorgang, bei dem die Anwendungszuordnung leer bleibt oder auf keine
  vorhandene Anwendung zeigt, sonst gueltig — gleiche Anmeldung, gleicher Mandant, vorhandene
  Datei, damit der Lauf allein an der fehlenden Anwendung scheitert; erwartete Beobachtung: der
  Zaehlstand der document-Zeilen ist unveraendert, und der Bildschirm zeigt den Fehlerzustand
  der Aktion — „unvollstaendiger Dreischritt wird nicht sichtbar — Meldung, der vorige Stand
  bleibt gueltig“.
· Quelle: „Jedes Dokument MUSS als genau eine Zeile in `document` bestehen und einer Anwendung
  zugeordnet sein. Ohne Anwendung entsteht kein Dokument.“
· Erzeugt am 19.08.2026 (Blatt 100, Entscheidung 5). K23-M02: das Abnahmekriterium liefert der
  fachliche Eigentuemer — dieser Vorschlag nimmt ihm die Schreibarbeit ab, nicht die
  Entscheidung.
⟨zeichnet: ⟩ ⟨am: ⟩
```

`☐ gezeichnet   ☐ geändert (Wortlaut unten)   ☐ zurück an den Harness`

---

### K10-M02 · MUSS

> Jede Zeile MUSS eine Dokumentart aus der geschlossenen Liste tragen. Sieben Werte sind vorgesehen; ein achter entsteht nicht (F10).

*Konzept K10, Zeile 45 · Gegenprobe: gehalten*

**Vorgeschlagenes Kriterium**

```
⟨VORSCHLAG · NICHT GEZEICHNET⟩
ERFUELLT WENN: Jede document-Zeile traegt eine Dokumentart aus der geschlossenen Liste; die
  Liste fuehrt sieben Werte, ein achter entsteht nicht.
GEMESSEN DURCH: Positivfall: EN-06 · zwischenspeichern in Zustand Erfolg ausloesen — die neue
  Zeile traegt eine Dokumentart, und zwar die im Vertrag genannte Art des INTERVIEW_PROTOCOL-
  Standes; dazu die Liste der zugelassenen Werte auslesen und abzaehlen: sieben; dazu alle
  vorhandenen Zeilen lesen — keine ohne Dokumentart. Negativfall (muss abgewiesen werden):
  dieselbe Registrierung in zwei Laeufen, einmal mit einem achten, in der Liste nicht gefuehrten
  Wert und einmal ohne Dokumentart, sonst gueltig — gleiche Anmeldung, vorhandene Anwendung,
  gefuellter Dateiname, damit beide Laeufe allein an der Dokumentart scheitern; erwartete
  Beobachtung: keine neue Zeile entsteht, und der Bildschirm zeigt den Fehlerzustand der Aktion
  — „unvollstaendiger Dreischritt wird nicht sichtbar — Meldung, der vorige Stand bleibt
  gueltig“. Welche sieben Werte die Liste fuehrt, nennt der Wortlaut nicht; gemessen werden
  Anzahl und Geschlossenheit.
· Quelle: „Jede Zeile MUSS eine Dokumentart aus der geschlossenen Liste tragen. Sieben Werte
  sind vorgesehen; ein achter entsteht nicht (F10).“
· Erzeugt am 19.08.2026 (Blatt 100, Entscheidung 5). K23-M02: das Abnahmekriterium liefert der
  fachliche Eigentuemer — dieser Vorschlag nimmt ihm die Schreibarbeit ab, nicht die
  Entscheidung.
⟨zeichnet: ⟩ ⟨am: ⟩
```

`☐ gezeichnet   ☐ geändert (Wortlaut unten)   ☐ zurück an den Harness`

---

### K10-M03 · MUSS

> Jede Zeile MUSS einen Dateinamen tragen. Ein Eintrag ohne Datei ist kein Dokument, sondern ein Fehler.

*Konzept K10, Zeile 46 · Gegenprobe: gehalten*

**Vorgeschlagenes Kriterium**

```
⟨VORSCHLAG · NICHT GEZEICHNET⟩
ERFUELLT WENN: Jede document-Zeile traegt einen gefuellten Dateinamen; ein Eintrag ohne Datei
  entsteht nicht, sondern gilt als Fehler.
GEMESSEN DURCH: Positivfall: EN-06 · zwischenspeichern in Zustand Erfolg ausloesen — die neue
  Zeile traegt einen nicht leeren Dateinamen; dazu alle vorhandenen Zeilen lesen — keine mit
  leerem Dateinamen. Negativfall (muss als Fehler enden): derselbe Speichervorgang mit leerem
  Dateinamen, sonst gueltig — gleiche Anmeldung, vorhandene Anwendung, zugelassene Dokumentart,
  damit der Lauf allein am fehlenden Dateinamen scheitert; erwartete Beobachtung: keine neue
  Zeile, und auf dem Bildschirm der Fehlerzustand der Aktion — „unvollstaendiger Dreischritt
  wird nicht sichtbar — Meldung, der vorige Stand bleibt gueltig“; der vor dem Lauf gespeicherte
  Stand ist danach unveraendert lesbar.
· Quelle: „Jede Zeile MUSS einen Dateinamen tragen. Ein Eintrag ohne Datei ist kein Dokument,
  sondern ein Fehler.“
· Erzeugt am 19.08.2026 (Blatt 100, Entscheidung 5). K23-M02: das Abnahmekriterium liefert der
  fachliche Eigentuemer — dieser Vorschlag nimmt ihm die Schreibarbeit ab, nicht die
  Entscheidung.
⟨zeichnet: ⟩ ⟨am: ⟩
```

`☐ gezeichnet   ☐ geändert (Wortlaut unten)   ☐ zurück an den Harness`

---

### K13 — 6 Klauseln (3 von der Gegenprobe gehalten, 3 ersetzt)

---

### K13-M08 · MUSS

> Die Mandantengrenze MUSS zweifach durchgesetzt werden: im Serverpfad durch Autorisierung und im Datenbestand durch Policies. Fällt eine Ebene aus, hält die andere.

*Konzept K13, Zeile 49 · Vorschlag vom 16.08.2026 · für M5 geprüft: trägt*

**Vorgeschlagenes Kriterium**

```
⟨VORSCHLAG · NICHT GEZEICHNET⟩
ERFUELLT WENN: Beide Ebenen weisen den Fremdzugriff jede fuer sich ab - (a) bei umgangenem
  Serverpfad verweigert die Datenbank ueber die Policy, (b) bei fuer dieses Objekt
  abgeschalteter Policy verweigert der Serverpfad ueber die Autorisierung.
GEMESSEN DURCH: Zwei Prueflaeufe je Datenpfad mit zwei Mandanten: Lauf (a) unmittelbare
  Datenbankverbindung als Mandant B auf einen vorhandenen Satz von Mandant A; Lauf (b) derselbe
  Zugriff ueber den Serverpfad in einer Pruefumgebung, in der die Policy fuer dieses Objekt
  deaktiviert ist. NICHT ERFUELLT: In einem der beiden Laeufe wird der Satz von Mandant A
  geliefert oder geaendert. Beide Laeufe messen nur, wenn die jeweils andere Ebene tatsaechlich
  ausgeschaltet ist: scheitert Lauf (b) schon an der Policy, ist die Autorisierung ungeprueft
  und der Lauf zaehlt nicht als bestanden.
· Erzeugt am 16.08.2026 auf Weisung E-6 (gez. M. Veil und A. Han). K23-M02: das Abnahmekriterium
  liefert der fachliche Eigentuemer — dieser Vorschlag nimmt ihm die Schreibarbeit ab, nicht die
  Entscheidung.
⟨zeichnet: ⟩ ⟨am: ⟩
```

`☐ gezeichnet   ☐ geändert (Wortlaut unten)   ☐ zurück an den Harness`

---

### K13-M09 · MUSS

> Das Anlegen einer Anwendung und jeder Zustandswechsel MÜSSEN über die serverseitigen Befehle laufen, die K01 Abschn. 3 festlegt. Unmittelbare Schreibrechte auf die zugehörigen Tabellen bleiben allen Zugängen entzogen.

*Konzept K13, Zeile 50 · Gegenprobe: **ersetzt · nicht_messbar***

**Vorgeschlagenes Kriterium**

```
⟨VORSCHLAG · NICHT GEZEICHNET⟩
ERFUELLT WENN: Jeder Zustandswechsel der Stufen 01 und 02 tritt nur ueber den im
  Bildschirmvertrag gefuehrten Serverbefehl ein, und unter den Zugaengen, mit denen diese Stufen
  arbeiten, besteht kein unmittelbares Schreibrecht auf app.
GEMESSEN DURCH: Positivfall: EN-05 · name_bestaetigen in Zustand Erfolg ueber confirm_app_name
  ausloesen — „app.journey_phase von ORIENTIERUNG auf INTERVIEW" tritt ein; EN-06 ·
  interview_beenden in Zustand Erfolg ueber complete_interview — „journey_phase = UEBERSICHT";
  in beiden Faellen uebergibt der Client keine Stufe. Aufbau der Rechtelage: fuer jeden Zugang,
  unter dem die Stufen 01 und 02 arbeiten — die angemeldete Nutzersitzung des eigenen Mandanten
  und der Zugang, mit dem die Oberflaeche auf den Bestand geht —, werden die unmittelbaren
  Schreibrechte auf app aufgelistet; keines ist vorhanden. Negativfall (muss verweigert werden):
  unter demselben Zugang wird derselbe Zustandswechsel unmittelbar auf app geschrieben, ohne
  Serverbefehl, mit gueltiger Anmeldung, vorhandener Zeile und richtigem Mandantenkontext, damit
  der Lauf allein am entzogenen Schreibrecht scheitert und nicht an Anmeldung, Mandant oder
  Schluessel; erwartete Beobachtung: der Schreibvorgang wird verweigert, app.journey_phase steht
  danach unveraendert. Zweiter Negativlauf zur Vertragszeile „der Stufenwechsel wird
  serverseitig gesetzt, nie vom Client uebergeben": derselbe Serverbefehl mit einer vom Client
  mitgegebenen Zielstufe — die mitgegebene Stufe wirkt nicht, die Stufe steht auf dem
  serverseitig gesetzten Wert. Das Anlegen einer Anwendung faellt nicht in die Stufen 01 und 02
  und wird hier nicht gemessen; welche weiteren Zugaenge unter „allen Zugaengen" zu pruefen sind
  und welche Befehle K01 Abschn. 3 dafuer festlegt, bestimmt der fachliche Eigentuemer.
· Quelle: „Unmittelbare Schreibrechte auf die zugehörigen Tabellen bleiben allen Zugängen
  entzogen.“
· Erzeugt am 19.08.2026 (Blatt 100, Entscheidung 5). K23-M02: das Abnahmekriterium liefert der
  fachliche Eigentuemer — dieser Vorschlag nimmt ihm die Schreibarbeit ab, nicht die
  Entscheidung.
⟨zeichnet: ⟩ ⟨am: ⟩
```

`☐ gezeichnet   ☐ geändert (Wortlaut unten)   ☐ zurück an den Harness`

---

### K13-M10 · MUSS

> Jeder Schreibvorgang MUSS einen Protokolleintrag erzeugen. Träger ist `event` mit `event_source` (Eigentümer K02); K13 verlangt die Kante, nicht ihre Form.

*Konzept K13, Zeile 51 · Gegenprobe: **ersetzt · negativfall_fehlt_oder_fremd***

**Vorgeschlagenes Kriterium**

```
⟨VORSCHLAG · NICHT GEZEICHNET⟩
ERFUELLT WENN: Zu jedem Schreibvorgang der Stufen 01 und 02 steht ein Protokolleintrag in event
  mit gefuelltem event_source, und kein fachlicher Schreibvorgang steht ohne diesen Eintrag;
  gemessen wird das Vorhandensein der Kante, nicht ihre Form.
GEMESSEN DURCH: Positivfall: die schreibenden Aktionen beider Bildschirme werden je einmal in
  Zustand Erfolg ausgeloest — EN-05 thema_waehlen, einordnung_beantworten, ziele_waehlen,
  ausgangsproblem_bestaetigen, name_bestaetigen sowie EN-06 vorschlag_waehlen,
  freitext_antworten, frage_ignorieren, zwischenspeichern, interview_beenden; nach jeder
  Handlung steht mindestens ein neuer event-Eintrag zu diesem Vorgang, und sein event_source ist
  gefuellt. Negativfall (muss ohne fachliche Wirkung enden): derselbe Schreibvorgang wird unter
  gleicher Anmeldung, gleichem Mandanten, gleichem Objekt und gleicher Eingabe ausgeloest,
  waehrend der Protokolleintrag nicht geschrieben werden kann — damit der Lauf allein an der
  fehlenden Kante scheitert und nicht an Rechten, Mandant oder Format; erwartete Beobachtung an
  EN-05 · name_bestaetigen: der gezeichnete Fehlerzustand „Schreibbefehl oder Protokolleintrag
  gescheitert — alles zurueckgerollt, kein Teilwechsel, Stufe bleibt ORIENTIERUNG", danach steht
  weder die fachliche Aenderung noch ein Eintrag; an EN-06 · zwischenspeichern:
  „unvollstaendiger Dreischritt wird nicht sichtbar — Meldung, der vorige Stand bleibt gueltig".
  Die Kante bleibt also nie einseitig. Ueber Aufbau und Felder des Eintrags wird darueber hinaus
  nichts gemessen.
· Stufe: EN-06 · datei_anhaengen bleibt aussen vor (Blatt 100, E4).
· Quelle: „Jeder Schreibvorgang MUSS einen Protokolleintrag erzeugen. Träger ist `event` mit
  `event_source` … K13 verlangt die Kante, nicht ihre Form.“
· Erzeugt am 19.08.2026 (Blatt 100, Entscheidung 5). K23-M02: das Abnahmekriterium liefert der
  fachliche Eigentuemer — dieser Vorschlag nimmt ihm die Schreibarbeit ab, nicht die
  Entscheidung.
⟨zeichnet: ⟩ ⟨am: ⟩
```

`☐ gezeichnet   ☐ geändert (Wortlaut unten)   ☐ zurück an den Harness`

---

### K13-M13 · MUSS

> Jede Schnittstelle MUSS einen benannten Fehlerfall besitzen, der sperrt statt durchzulassen. Ein unbeantworteter oder nicht prüfbarer Aufruf gilt als abgelehnt.

*Konzept K13, Zeile 54 · Gegenprobe: gehalten*

**Vorgeschlagenes Kriterium**

```
⟨VORSCHLAG · NICHT GEZEICHNET⟩
ERFUELLT WENN: Jede Aktion der Stufen 01 und 02 fuehrt einen benannten Fehlerfall, und dieser
  sperrt: nach seinem Eintritt ist keine fachliche Zeile entstanden oder veraendert; ein Aufruf,
  der unbeantwortet bleibt oder nicht pruefbar ist, endet in diesem Fehlerfall und gilt als
  abgelehnt.
GEMESSEN DURCH: Aufbau: fuer jede Aktion von EN-05 und EN-06 den in der Maschinenquelle
  benannten Fehlerzustand lesen — fehlt er bei einer Aktion, ist das Kriterium ohne weiteren
  Lauf verletzt. Positivfall: die Aktion mit erfuellten Bedingungen ausloesen — Zustand Erfolg,
  die fachliche Zeile entsteht. Negativfall (muss sperren): dieselbe Aktion in zwei Laeufen,
  einmal mit unbeantwortetem Aufruf, weil die Gegenstelle nicht antwortet, und einmal mit nicht
  pruefbarem Aufruf, weil die Pruefung nicht entschieden werden kann, sonst gueltig — gleiche
  Anmeldung, vorhandenes Objekt, gefuellte Eingaben, damit der Lauf allein am Fehlerfall der
  Schnittstelle scheitert; erwartete Beobachtung: der Bildschirm zeigt genau den benannten
  Fehlerzustand dieser Aktion, fuer EN-06 · vorschlag_waehlen etwa „kein Eintrag rechts,
  Meldung, Antwort bleibt waehlbar“, und die fachliche Zeile ist nach dem Lauf unveraendert.
· Quelle: „Jede Schnittstelle MUSS einen benannten Fehlerfall besitzen, der sperrt statt
  durchzulassen. Ein unbeantworteter oder nicht prüfbarer Aufruf gilt als abgelehnt.“
· Erzeugt am 19.08.2026 (Blatt 100, Entscheidung 5). K23-M02: das Abnahmekriterium liefert der
  fachliche Eigentuemer — dieser Vorschlag nimmt ihm die Schreibarbeit ab, nicht die
  Entscheidung.
⟨zeichnet: ⟩ ⟨am: ⟩
```

`☐ gezeichnet   ☐ geändert (Wortlaut unten)   ☐ zurück an den Harness`

---

### K13-M20 · MUSS

> Fachliche Änderung und Auditnachweis MÜSSEN atomar entstehen. Wo keine gemeinsame Transaktion möglich ist, wird eine transaktionale Outbox mit Wiederanlauf und Abgleich verwendet.

*Konzept K13, Zeile 61 · Gegenprobe: gehalten*

**Vorgeschlagenes Kriterium**

```
⟨VORSCHLAG · NICHT GEZEICHNET⟩
ERFUELLT WENN: Fachliche Aenderung und Auditnachweis stehen nach jedem Vorgang gemeinsam oder
  gar nicht da; wo beide nicht in einer Transaktion entstehen koennen, liegt eine transaktionale
  Outbox vor, deren Wiederanlauf den ausstehenden Nachweis nachholt und deren Abgleich danach
  keine Abweichung ausweist.
GEMESSEN DURCH: Positivfall: EN-05 · name_bestaetigen in Zustand Erfolg ausloesen; fachliche
  Zeile und Auditeintrag werden gelesen — beide vorhanden. Negativfall (muss ohne Teilwirkung
  enden): derselbe Aufruf mit einem Abbruch, der nach der fachlichen Aenderung und vor dem
  Auditeintrag gesetzt ist, sonst gueltig — gleiche Anmeldung, gleicher Mandant, gefuellte
  Eingaben, damit der Lauf allein an der Atomaritaet scheitert; erwartete Beobachtung: der im
  Vertrag benannte Fehlerzustand „alles zurueckgerollt, kein Teilwechsel, Stufe bleibt
  ORIENTIERUNG“, danach ist weder die Aenderung noch der Nachweis da. Zweiter Negativlauf fuer
  den Outbox-Weg: derselbe Abbruch an einer Stelle, an der beide nicht in einer gemeinsamen
  Transaktion entstehen koennen; erwartete Beobachtung: der ausstehende Nachweis liegt in der
  Outbox, der Wiederanlauf holt ihn nach, und der Abgleich weist danach weder eine Aenderung
  ohne Nachweis noch einen Nachweis ohne Aenderung aus. Eine Frist fuer den Wiederanlauf nennt
  der Wortlaut nicht; gemessen wird, dass Wiederanlauf und Abgleich stattfinden und der Abgleich
  ohne Abweichung endet.
· Quelle: „Fachliche Änderung und Auditnachweis MÜSSEN atomar entstehen. Wo keine gemeinsame
  Transaktion möglich ist, wird eine transaktionale Outbox mit Wiederanlauf und Abgleich
  verwendet.“
· Erzeugt am 19.08.2026 (Blatt 100, Entscheidung 5). K23-M02: das Abnahmekriterium liefert der
  fachliche Eigentuemer — dieser Vorschlag nimmt ihm die Schreibarbeit ab, nicht die
  Entscheidung.
⟨zeichnet: ⟩ ⟨am: ⟩
```

`☐ gezeichnet   ☐ geändert (Wortlaut unten)   ☐ zurück an den Harness`

---

### K13-M22 · MUSS

> Jeder Modellpfad MUSS an Deployment-ID, Anbieter, Region, Netzwerk- und Policyversion, Zweck, Datenminimum, Evaluationssatz, Freigabeschwelle und menschliche Eskalationsrolle gebunden sein. Ohne vollständigen Eintrag findet kein Aufruf statt.

*Konzept K13, Zeile 63 · Gegenprobe: gehalten*

**Vorgeschlagenes Kriterium**

```
⟨VORSCHLAG · NICHT GEZEICHNET⟩
ERFUELLT WENN: Zu jedem Modellpfad der Stufen 01 und 02 liegt ein Eintrag vor, der alle im
  Wortlaut genannten Angaben fuehrt — Deployment-ID, Anbieter, Region, Netzwerkversion,
  Policyversion, Zweck, Datenminimum, Evaluationssatz, Freigabeschwelle und menschliche
  Eskalationsrolle; fehlt eine davon, findet kein Aufruf statt.
GEMESSEN DURCH: Positivfall: mit vollstaendigem Eintrag EN-05 · name_bestaetigen (Zustand laden:
  „Vorschlag der Modelle geladen, Feld gefuellt und aenderbar“) und EN-06 · freitext_antworten
  in Zustand Erfolg ausloesen — der Aufruf findet statt, Vorschlag beziehungsweise Eintrag
  rechts erscheint; der Eintrag zum Modellpfad wird gelesen, alle genannten Angaben sind
  gefuellt. Negativfall (muss den Aufruf verhindern): so viele Laeufe, wie der Wortlaut Angaben
  nennt, in denen je eine dieser Angaben aus dem Eintrag entfernt ist, sonst gueltig — gleiche
  Anmeldung, gleicher Text, erreichbarer Modellpfad, damit jeder Lauf allein an der fehlenden
  Angabe scheitert; erwartete Beobachtung je Lauf: kein ausgehender Modellaufruf, und auf dem
  Bildschirm der Fehlerzustand von EN-06 · freitext_antworten — „Maskierung oder Modellpfad
  unvollstaendig — kein Aufruf, die Frage bleibt unbeantwortet stehen“. Gemessen wird das
  Vorhandensein der Angaben, nicht ihr Inhalt; welchen Wert etwa die Freigabeschwelle traegt,
  bestimmt der fachliche Eigentuemer.
· Quelle: „Jeder Modellpfad MUSS an Deployment-ID, Anbieter, Region, Netzwerk- und
  Policyversion, Zweck, Datenminimum, Evaluationssatz, Freigabeschwelle und menschliche
  Eskalationsrolle gebunden sein. Ohne vollständigen Eintrag findet kein Aufruf statt.“
· Erzeugt am 19.08.2026 (Blatt 100, Entscheidung 5). K23-M02: das Abnahmekriterium liefert der
  fachliche Eigentuemer — dieser Vorschlag nimmt ihm die Schreibarbeit ab, nicht die
  Entscheidung.
⟨zeichnet: ⟩ ⟨am: ⟩
```

`☐ gezeichnet   ☐ geändert (Wortlaut unten)   ☐ zurück an den Harness`

---

### K19 — 4 Klauseln (1 von der Gegenprobe gehalten, 3 ersetzt)

---

### K19-D09 · DARF NICHT

> Kein Kasten DARF eine bedienbare Schaltfläche für einen Vorgang zeigen, dessen Vorbedingung nicht erfüllt oder nicht prüfbar ist. Im Zweifel wird gesperrt.

*Konzept K19, Zeile 68 · Gegenprobe: **ersetzt · erfunden***

**Vorgeschlagenes Kriterium**

```
⟨VORSCHLAG · NICHT GEZEICHNET⟩
ERFUELLT WENN: In keinem Kasten von EN-05 und EN-06 ist eine Schaltflaeche bedienbar, solange
  die Vorbedingung ihres Vorgangs nicht erfuellt oder nicht pruefbar ist; bleibt die Pruefung
  unentschieden, ist die Schaltflaeche gesperrt.
GEMESSEN DURCH: Positivfall: mit stehender Zusammenfassung ist auf EN-05 ·
  ausgangsproblem_bestaetigen die im Vertrag gefuehrte Eingabe „Ja, weiter zum Interview"
  bedienbar und der Vorgang geht durch; mit geladenem, gefuelltem und aenderbarem Namensfeld ist
  EN-05 · name_bestaetigen bedienbar. Negativfall (muss gesperrt bleiben): dieselben Kaesten in
  drei Laeufen, sonst gueltig — angemeldete Sitzung des eigenen Mandanten, erreichter
  Bildschirm, gefuellte uebrige Eingaben, damit jeder Lauf allein an der Vorbedingung scheitert.
  (a) Zustand laden von ausgangsproblem_bestaetigen: „Zusammenfassung wird gestellt,
  Schaltflaeche inaktiv bis sie steht" — nicht bedienbar. (b) Zustand laden von thema_waehlen:
  „zwoelf Themen geladen; die Gespraechsspalte bleibt inaktiv, bis sie stehen" — nicht
  bedienbar, solange die Themen nicht stehen. (c) Die Vorbedingung ist nicht pruefbar: die im
  Vertrag zu record_topic gefuehrte Vorbedingung, ein fit_check mit outcome GEEIGNET, bleibt
  ohne Antwort — die Schaltflaeche bleibt gesperrt, im Zweifel gesperrt. Erwartete Beobachtung
  je Lauf: die Schaltflaeche ist nicht bedienbar und der Vorgang tritt nicht ein; wird sie
  dennoch ausgeloest, entsteht keine fachliche Zeile. Wo die Bedingung durch den Nutzer selbst
  erfuellbar ist, tritt nach K19-M06 an die Stelle der Schaltflaeche der Hinweis;
  Beschriftungen, die der Bildschirmvertrag nicht fuehrt, werden nicht gemessen.
· Quelle: „Kein Kasten DARF eine bedienbare Schaltfläche für einen Vorgang zeigen, dessen
  Vorbedingung nicht erfüllt oder nicht prüfbar ist. Im Zweifel wird gesperrt.“
· Erzeugt am 19.08.2026 (Blatt 100, Entscheidung 5). K23-M02: das Abnahmekriterium liefert der
  fachliche Eigentuemer — dieser Vorschlag nimmt ihm die Schreibarbeit ab, nicht die
  Entscheidung.
⟨zeichnet: ⟩ ⟨am: ⟩
```

`☐ gezeichnet   ☐ geändert (Wortlaut unten)   ☐ zurück an den Harness`

---

### K19-G03 · GILT

> Es GILT: Herkunft ist sichtbar getrennt — KI-Notiz gegen eigene Angabe (EN-06), KI-Vorschlag (EN-05), fest zugeordnete Marke je Konzeptkachel (EN-07), Arbeitsdokument und ungeprüft (EN-12).

*Konzept K19, Zeile 76 · Gegenprobe: gehalten*

**Vorgeschlagenes Kriterium**

```
⟨VORSCHLAG · NICHT GEZEICHNET⟩
ERFUELLT WENN: Auf EN-06 sind KI-Notiz und eigene Angabe zwei verschiedene, sichtbare Marken,
  und jeder Eintrag rechts traegt genau eine davon; auf EN-05 traegt der Vorschlag die sichtbare
  Marke KI-Vorschlag.
GEMESSEN DURCH: Positivfall: auf EN-06 · freitext_antworten in Zustand Erfolg antworten — der
  Eintrag rechts traegt die Marke der eigenen Angabe, im Vertrag „Marke Ihre Angabe“; daneben
  entsteht eine KI-Notiz, sie traegt die andere Marke; beide sind auf demselben Bildschirm
  sichtbar und voneinander unterscheidbar; auf EN-05 traegt das Namensfeld im Zustand laden die
  Marke KI-Vorschlag. Negativfall (muss abgewiesen werden): zwei Laeufe — ein Eintrag, dessen
  Marke nicht eindeutig bestimmbar ist, und ein Namensfeld ohne Marke, sonst gueltig, mit
  angemeldeter Sitzung und gefuellter Eingabe, damit der Lauf allein an der Herkunftsmarke
  scheitert; erwartete Beobachtung: auf EN-06 der Fehlerzustand „Marke nicht eindeutig
  bestimmbar oder Speichern fehlgeschlagen — kein Eintrag rechts, Meldung, Antwort bleibt
  waehlbar“, auf EN-05 der Leerzustand „Feld leer oder Marke fehlt — abgelehnt, Stufe bleibt
  ORIENTIERUNG“. Die uebrigen Teile der Klausel, EN-07 und EN-12, liegen ausserhalb der Stufen
  01 und 02 und werden hier nicht gemessen.
· Quelle: „Es GILT: Herkunft ist sichtbar getrennt — KI-Notiz gegen eigene Angabe (EN-06), KI-
  Vorschlag (EN-05) …“
· Erzeugt am 19.08.2026 (Blatt 100, Entscheidung 5). K23-M02: das Abnahmekriterium liefert der
  fachliche Eigentuemer — dieser Vorschlag nimmt ihm die Schreibarbeit ab, nicht die
  Entscheidung.
⟨zeichnet: ⟩ ⟨am: ⟩
```

`☐ gezeichnet   ☐ geändert (Wortlaut unten)   ☐ zurück an den Harness`

---

### K19-M06 · MUSS

> Ist eine Bedingung durch den Nutzer selbst erfüllbar, MUSS die Schaltfläche ausgeblendet werden und an ihrer Stelle ein Hinweis stehen, der die Bedingung benennt.

*Konzept K19, Zeile 46 · Gegenprobe: **ersetzt · negativfall_fehlt_oder_fremd***

**Vorgeschlagenes Kriterium**

```
⟨VORSCHLAG · NICHT GEZEICHNET⟩
ERFUELLT WENN: Ist die Bedingung eines Vorgangs vom Nutzer selbst erfuellbar, ist die
  Schaltflaeche nicht vorhanden — ausgeblendet, nicht nur inaktiv — und an ihrer Stelle steht
  ein Hinweis, der genau diese Bedingung benennt; erfuellt der Nutzer die Bedingung, erscheint
  die Schaltflaeche an dieser Stelle.
GEMESSEN DURCH: Positivfall: EN-05 in den Leerzustand von ziele_waehlen bringen, also kein Ziel
  waehlen — „der Weiterweg ist ausgeblendet, an seiner Stelle steht der Hinweis auf das fehlende
  Ziel"; die Schaltflaeche ist im Kasten nicht auffindbar, der Hinweistext benennt das fehlende
  Ziel. Dann die Bedingung durch die eigene Handlung erfuellen, ein Ziel waehlen — der Hinweis
  weicht, die Schaltflaeche steht an seiner Stelle. Derselbe Ablauf fuer EN-05 ·
  ausgangsproblem_bestaetigen im Leerzustand ohne zusammengefasste Beschreibung, wo der Vertrag
  fuehrt: „ohne zusammengefasstes Ausgangsproblem ist die Schaltflaeche ausgeblendet, an ihrer
  Stelle steht der Hinweis auf die fehlende Beschreibung". Negativfall (muss an SEINER eigenen
  Bedingung scheitern): derselbe Kasten EN-05 · ausgangsproblem_bestaetigen im Ladezustand, in
  dem die Zusammenfassung gestellt wird — die Bedingung ist hier nicht vom Nutzer selbst
  erfuellbar, sonst gueltig: angemeldete Sitzung des eigenen Mandanten, erreichter Bildschirm,
  damit der Lauf allein am Vordersatz der Klausel scheitert; erwartete Beobachtung: es gilt
  „Zusammenfassung wird gestellt, Schaltflaeche inaktiv bis sie steht" — die Schaltflaeche steht
  sichtbar und inaktiv im Kasten, ohne Hinweis an ihrer Stelle, und das ist kein Verstoss. Damit
  ist gemessen, dass die Pruefung Ausblendung samt Hinweis nur dort verlangt, wo der Nutzer die
  Bedingung selbst erfuellen kann, und nicht jede gesperrte Schaltflaeche beanstandet.
· Quelle: „Ist eine Bedingung durch den Nutzer selbst erfüllbar, MUSS die Schaltfläche
  ausgeblendet werden und an ihrer Stelle ein Hinweis stehen, der die Bedingung benennt.“
· Erzeugt am 19.08.2026 (Blatt 100, Entscheidung 5). K23-M02: das Abnahmekriterium liefert der
  fachliche Eigentuemer — dieser Vorschlag nimmt ihm die Schreibarbeit ab, nicht die
  Entscheidung.
⟨zeichnet: ⟩ ⟨am: ⟩
```

`☐ gezeichnet   ☐ geändert (Wortlaut unten)   ☐ zurück an den Harness`

---

### K19-M14 · MUSS

> Jede Aktion MUSS in der Maschinenquelle Eingabe, Serverbefehl, Berechtigungsprüfung, Lade-, Leer-, Erfolgs- und Fehlerzustand referenzieren. Ein UI-Zustand ersetzt keine serverseitige Autorisierung.

*Konzept K19, Zeile 54 · Gegenprobe: **ersetzt · negativfall_fehlt_oder_fremd***

**Vorgeschlagenes Kriterium**

```
⟨VORSCHLAG · NICHT GEZEICHNET⟩
ERFUELLT WENN: Jede Aktion von EN-05 und EN-06 fuehrt in der Maschinenquelle alle sieben im
  Wortlaut genannten Angaben — Eingabe, Serverbefehl, Berechtigungspruefung, Lade-, Leer-,
  Erfolgs- und Fehlerzustand — und keine davon ist leer; und der Serverbefehl weist einen Aufruf
  auch dann ab, wenn allein die Oberflaeche ihn gesperrt haette.
GEMESSEN DURCH: Positivfall: die Maschinenquelle je Aktion lesen und die sieben Angaben abhaken;
  wo der Leerzustand entfaellt, traegt er die Begruendung, etwa bei EN-06 · zwischenspeichern
  „entfaellt — die Aktion steht erst ab Stufe 02 und immer mit vorhandenem Stand (Begruendung
  nach K19-M06)". Dazu mit erfuellter Vorbedingung und berechtigter Sitzung den Serverbefehl
  unmittelbar aufrufen — er geht durch, der Erfolgszustand tritt ein. Negativfall (muss
  serverseitig abgewiesen werden): derselbe Serverbefehl wird unter einer vollstaendig gueltigen
  und berechtigten Sitzung des eigenen Mandanten ohne die Oberflaeche aufgerufen, in einem
  Zustand, in dem die Oberflaeche die Schaltflaeche sperrt oder ausblendet — confirm_app_name
  bei leerem Namensfeld, confirm_initial_problem ohne zusammengefasstes Ausgangsproblem —, sonst
  gueltig: vorhandenes Objekt, richtiger Mandant, richtiger Aufbau des Aufrufs, damit der Lauf
  allein an der serverseitigen Pruefung des Zustands scheitert und nicht an Anmeldung, Mandant
  oder Format; erwartete Beobachtung: der Aufruf wird abgewiesen, es gilt „Feld leer oder Marke
  fehlt — abgelehnt, Stufe bleibt ORIENTIERUNG" beziehungsweise „ohne bestaetigtes
  Ausgangsproblem kein Namensschritt", und keine fachliche Zeile entsteht. Fehlt einer Aktion
  eine der sieben Angaben, ist das Kriterium ohne weiteren Lauf verletzt.
· Stufe: EN-06 · datei_anhaengen bleibt aussen vor (Blatt 100, E4).
· Quelle: „Jede Aktion MUSS in der Maschinenquelle Eingabe, Serverbefehl, Berechtigungsprüfung,
  Lade-, Leer-, Erfolgs- und Fehlerzustand referenzieren. Ein UI-Zustand ersetzt keine
  serverseitige Autorisierung.“
· Erzeugt am 19.08.2026 (Blatt 100, Entscheidung 5). K23-M02: das Abnahmekriterium liefert der
  fachliche Eigentuemer — dieser Vorschlag nimmt ihm die Schreibarbeit ab, nicht die
  Entscheidung.
⟨zeichnet: ⟩ ⟨am: ⟩
```

`☐ gezeichnet   ☐ geändert (Wortlaut unten)   ☐ zurück an den Harness`

---

## Zeichnung

Je Block genügt **eine** Unterschrift, wenn Sie alle Einträge des Blocks tragen.
Einzelne Ausnahmen tragen Sie darunter mit Kennung ein.

| Block | Einträge | gezeichnet | Datum | Ausnahmen (Kennungen) |
|---|---:|---|---|---|
| Teil 1 · ohne Maßstab | 5 | *keine Zeichnung — Lieferung* | | |
| Teil 2 · Bestand plus Ergänzung | 4 | ☐ | ⟨ ⟩ | |
| Teil 3 · K01 | 9 | ☐ | ⟨ ⟩ | |
| Teil 3 · K02 | 7 | ☐ | ⟨ ⟩ | |
| Teil 3 · K03 | 4 | ☐ | ⟨ ⟩ | |
| Teil 3 · K04 | 2 | ☐ | ⟨ ⟩ | |
| Teil 3 · K05 | 51 | ☐ | ⟨ ⟩ | |
| Teil 3 · K10 | 3 | ☐ | ⟨ ⟩ | |
| Teil 3 · K13 | 6 | ☐ | ⟨ ⟩ | |
| Teil 3 · K19 | 4 | ☐ | ⟨ ⟩ | |

| Name | Rolle | Datum |
|---|---|---|
| A. Han | fachlicher Eigentümer, für den Auftragnehmer | ⟨ ⟩ |

---

*Erzeugt am 19.08.2026 von `M5_sichtblatt_erzeugen.py`. Wortlaut und Herkunft aus
`register.json`, Kriterium und Eigentümer aus `pflege.json`, die Klausellage aus
`M5_klausellage_260819.json`. Der Harness trägt eine Zeichnung ein, wenn sie erteilt
ist — er setzt keine.*
