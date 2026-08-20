# Die zehn offenen Punkte — **Lösungsvorschläge**

**20.08.2026 · ⟨VORSCHLAG · NICHT GEZEICHNET⟩**

Am 19.08. sind alle Vorlagen gezeichnet worden **bis auf zehn Stellen**. Die zehn haben
gemeinsam, dass sie **eine Angabe verlangen** — einen Namen, ein Datum, eine Zahl, eine
Reihenfolge, eine Bedeutung. Ein Kreuz trägt sie nicht, und **geraten wird hier nichts**.

Dieses Blatt legt für jede Stelle vor: **die Frage · was die Quellen wörtlich sagen · der
Vorschlag · woher er kommt · was auch nach der Zeichnung offen bleibt.**

## Wie der Vorschlag jeweils zustande kam — drei Etiketten, und sie sind nicht dasselbe

| Etikett | Bedeutung |
|---|---|
| **ABGELEITET (Messung)** | Der Wert steht schon irgendwo gezeichnet oder folgt aus etwas Gezeichnetem durch reines Nachrechnen. Es ist **keine Wahl** — wer anders entscheidet, ändert eine frühere Zeichnung |
| **VORSCHLAG DES HARNESS** | Der Harness hat sich etwas überlegt. Es ist **eine Wahl**, sie ist begründet, aber sie ist nicht gemessen |
| **NUR VERFAHREN** | Kein Wort davon geht in einen Vertragstext oder in eine Zeichnungszelle. Es geht nur um die Reihenfolge des Vorgehens |

> **Jeder Vorschlag ist zweimal gelaufen:** einmal geschrieben, einmal von einer zweiten,
> unabhängigen Instanz gegengelesen, die ausdrücklich den Auftrag hatte, ihn zu widerlegen.
> **Sechs von zehn wurden dabei berichtigt, zwei schwer beanstandet** — was hier steht, ist
> die berichtigte Fassung. Wo die Gegenprobe etwas gestrichen hat, steht es dabei.

---

# 1 · Die 113 Risikozeilen — **wer trägt sie** (V-1a)

**Die Frage:** Jede der 113 gesperrten Klauseln braucht nach K23-M04 einen Träger. Ist das der
**fachliche Eigentümer** der Klausel oder der, der die **Annahme zeichnet**?

**Gemessen, nachgerechnet und bestätigt:**

| | |
|---|---|
| Alle 113 stehen im Register, **keine Eigentümerzelle ist leer** | `nachweise/klauselregister/register.json` |
| Verteilung **110 / 3** | 110 »Auftragnehmer (Nr. 158), vertreten durch A. Han« · 3 M. Veil: **K15-G09, K17-D13, K17-G12** |
| **Für 105 der 113 fehlt das Akzeptanzkriterium** | ohne das kein Prüffall schreibbar ist (K23-M02) |
| Feld `test`: **0 von 113 belegt** | |

**Vorschlag:** **Träger = der in derselben Registerzeile bereits gezeichnete fachliche
Eigentümer.** Es entsteht **kein neuer Name**. Grund: Nur der fachliche Eigentümer kann das
fehlende Akzeptanzkriterium liefern — also nur er kann die Sperre auflösen.

**Die Spalte ANNAHME bleibt leer**, mit dem Vermerk: *„nach K23-M04 in dieser Klasse unzulässig
— kein Ersatz für den Test."*

> **Etikett: VORSCHLAG DES HARNESS.** Gemessen ist nur die Verteilung 110/3 und wer die drei
> sind. Die **Gleichsetzung** »Träger = fachlicher Eigentümer« ist die Wahl — und sie steht
> **gegen vier bereits gezeichnete Fälle** im selben Verzeichnis: RR-02, RR-04, RR-05 und RR-06
> führen alle **M. Veil** als Träger.
>
> **Von der Gegenprobe gestrichen:** der Satz, der Eintrag sei maschinell setzbar. Er ist es
> nicht — `werkzeuge/klauselregister.py` kennt die Felder Träger, Annahme und Frist überhaupt
> nicht und weist sie ausdrücklich ab. Das sind **113 Zeilen Handarbeit**, kein Knopfdruck.

**Bleibt beim Menschen:** Die Annahmeentscheidung je Zeile ist für alle 113 **nicht offen,
sondern unzulässig** — der Weg ist Prüffall oder Umfangsentnahme. Wer A. Han nicht als Träger
will, hat dafür die vorgesehene Zeile *„Eine andere Person zeichnet für den Auftragnehmer"*.
Und: **wer den Träger setzt, hat die 105 fehlenden Kriterien damit noch nicht beauftragt.**

`☐` Träger = fachlicher Eigentümer (110 A. Han / 3 M. Veil) · `☐` alle 113 auf M. Veil ·
`☐` anders: ⟨ ⟩

---

# 2 · Die 113 Risikozeilen — **bis wann** (V-1b)

**Die Frage:** Bis wann muss jede Zeile erledigt sein — und lässt sich das Datum ausrechnen?

**Die Obergrenze ist ausrechenbar, in drei Schritten ohne Ermessen:** Bedingung 5 des Tores II
verlangt, dass **kein kritisches Restrisiko ohne Annahme offen** ist. Alle 113 liegen in einer
sperrenden Klasse. Eine Frist **nach** der Zeichnung von Tor II wäre für sie wirkungslos.
Nach heutigem Stand ist das der **31.08.2026**.

**Vorschlag — kein Fristeintrag, sondern zwei Zeilen je Klausel:**

1. **OBERGRENZE (gemessen):** *„Wirksam nur bis zur Zeichnung von Tor II — nach heutigem Stand
   31.08.2026. Eine Frist danach wäre für eine sperrende Zeile wirkungslos."*
2. **BEFUND (gemessen):** *„Prüffall erst schreibbar, wenn das Akzeptanzkriterium gezeichnet ist
   — bei 105 von 113 fehlt es (K23-M02)."*

**Die Spalte Frist selbst bleibt leer**, solange keine Annahmeentscheidung zulässig ist.

> **Etikett: Obergrenze ABGELEITET** — die Entscheidung, die Frist **auf** die Obergrenze zu
> legen, ist ein **Vorschlag des Harness**. Die Gegenprobe hat das Etikett »nichts daran ist
> gewählt« verworfen.
>
> **Vorbehalt, der bisher fehlte:** Bedingung 5 gilt in der eingeengten Fassung **erst mit
> wirksamem BA-1** — also erst mit A. Hans Gegenzeichnung.

**Bleibt beim Menschen:** Ob überhaupt eine Frist gesetzt wird. Die Folge aus K23-M04 — **mit
Fristablauf erlischt die Annahme, danach sperrt die Klausel wieder**. Und die **Beauftragung der
105 fehlenden Kriterien**: sie ist die eigentliche Vorbedingung und hat bis heute weder Datum
noch Kästchen.

`☐` Zwei Zeilen wie vorgeschlagen, Fristspalte bleibt leer · `☐` hartes Datum 31.08.2026 ·
`☐` anders: ⟨ ⟩

---

# 3 · Welche **vier Bauaufgaben** zurückgestellt sind (V-2 · Kreuz 2.1-Z)

**Die Frage:** Welche vier von L3, L4, L5, L6, L9 sind zurückgestellt?

**Antwort: die Sache ist nicht offen.** Sie steht am **16.08.2026 zweimal gezeichnet** im
Bestand — in BA-1 (Kreuz K2 über K2–K6) und in BA-2 (Anlage T Teil 2, mit Weisung im Wortlaut).

**Die vier sind L3, L4, L5, L6. L9 bleibt im Umfang** — und zwar **nur mit dem Portal-Hinweis**,
nicht mit Vertragsbaustein und Einweisung.

**Zu tun sind drei Dinge:**

| | |
|---|---|
| **a** | Kreuz **2.1-Z** setzen |
| **b** | Den Satz bei BA-2:449–450 berichtigen: *„die Kreuze in Anlage T Teil 2 sind am 16.08.2026 auf Weisung gesetzt, nicht vom Harness"*, und die leere Erstkopie in Feld 5 als überholt kennzeichnen. **Die gezeichnete Tabelle selbst bleibt unangetastet** |
| **c** | Daneben der Vermerk: *„Mit L9 im Umfang ist Bedingung 2 zum 31.08. erst erfüllbar, wenn E-13 entschieden, Kriterium 3 gebaut, ein Prüffall geschrieben und der Hinweis nach §7a abgenommen ist — heute ist keines davon der Fall."* |

> **Etikett: ABGELEITET für den Inhalt** — offen ist allein die **Form** (das Kästchen).
> Die Wertung »L9 ist am wenigsten zurückstellbar« ist eine **begründete Wertung**, keine
> Messung; die Gegenprobe hat sie als solche kenntlich gemacht.

**Bleibt beim Menschen:** Das Kreuz. Die **Termine** der vier (BA-3, binnen 14 Tagen nach
Zeichnung von Tor II). Und bei L9: Entscheidung E-13, der fehlende Prüffall, die Abnahme nach
§7a — **und die Frage, ob Bedingung 2 zum 31.08. überhaupt erfüllbar ist.**

`☐` 2.1-Z: die vier sind L3, L4, L5, L6 · `☐` anders: ⟨ ⟩

---

# 4 · Die **Reihenfolge im EN-04a-Kasten** (V-3)

**Hier legt der Harness bewusst keinen Vorschlag vor.** Der Entwurf vom **18.08.2026** sagt
ausdrücklich, die Maschinenquelle führe die Anordnung nicht und sie sei *„zu zeichnen, nicht zu
übernehmen"*; **Z-13 vom 19.08. trägt dazu ausdrücklich „der Harness darf hier nicht
empfehlen"**. Das ist die Umkehrung von F41 — wer den Kasten empfiehlt, schreibt sich die
Vorschrift selbst, an der er anschließend gemessen wird.

> **Von der Gegenprobe schwer beanstandet:** Der erste Durchgang hatte behauptet, dieser
> Vorbehalt stamme vom 05.08. und sei überholt. **Das Datum war erfunden.** Der Entwurf ist vom
> 18.08.2026, der Vorbehalt steht ungebrochen.

**Was der Harness stattdessen vorlegt — zwei Berichtigungen, weil es Klauselverstöße sind:**

| | Verstoß | gemessen |
|---|---|---|
| **1** | `-> EN-05` wird zu **„weiter nach EN-05"** | K19-G06 · **0 Pfeilzeichen in 31 Kästen**; Vorbild EX-17 *„fuehrt nach EX-09"* |
| **2** | Die Belegangabe wird auf **eine** physische Zeile gezogen | K19-M02 *„genau eine Belegzeile"* · **32 von 32 sind einzeilig**, auch die mit 693 Zeichen |

**Und ein Befund, kein Vorschlag:** Die drei Auswege stehen im Entwurf unter dem Zweig *„Ohne
Treffer"*, gehören aber nach K04-M08 unter die **Halt-Zeilen** — so macht es EN-04.

**Material zur Zeichnung, ohne dass daraus eine Anordnung folgt:** die Zugangszeile ist in
**31 von 31** Kästen die erste (K19-M03); die Auswertungsreihenfolge steht in
`K19_screens.yaml`; die Form von EN-04 liegt daneben.

**Mitzulegen, weil es dieselbe Zeichnung entscheidet — der Fassungsspalt:**
`schema/K19_screens.yaml` trägt **„version: 1.2 / status: FREIGABEKANDIDAT"**, die Referenz ist
**v1.3**, und **zwei Bildschirme stehen nur in der Quelle**. Jede Ableitung aus dieser Datei
steht und fällt damit. Z-13 schlägt als Frist den **22.08.2026** vor.

**Bleibt beim Menschen:** Die Anordnung selbst. Die Voraussetzungszeile (**0 von 31** Kästen
führen so etwas). Ob die drei Auswege inline oder auf eigener Zeile stehen. Das **Einfügen** —
die Datei liegt in der Konzept-Fabrik. **Bis dahin bleibt EN-04a im Riegel GESPERRT.**

`☐` Die zwei Berichtigungen (Pfeil, Belegzeile) sind zu machen · `☐` Fassungsspalt geht als
Befund an die Konzept-Fabrik · `☐` Anordnung: ⟨wird gezeichnet: ⟩

---

# 5 · **Zwei Namen**: Tresorzugriff und echter Mailversand (V-4)

**Die Frage:** Wer bekommt den Schlüssel zum Tresor in swedencentral, wer drückt beim echten
E-Mail-Versand auf den Knopf?

> **Von der Gegenprobe schwer beanstandet.** Der erste Durchgang hatte (a) eine **private
> E-Mail-Adresse aus einer gitignorierten Datei** als Repo-Messung ausgegeben — sie ist hier
> **gestrichen**; sie in ein Blatt zu schreiben, das gezeichnet und eingecheckt wird, machte
> ein Löschverlangen nach K15 unerfüllbar. Und (b) eine **Personenidentität behauptet, die
> keine Quelle trägt** — ebenfalls gestrichen.

**Der Harness setzt in beide Kästchen keinen Namen.** Vorgelegt wird das Material:

| | |
|---|---|
| **Welche Rolle** die Quellen dem Mailweg und den Identitäten zuordnen | **„Founder Technik und Betrieb"** (`rollen.md`:30) |
| Wen die **gezeichnete** Anlage Baustrategie an dieser Rolle nennt | Secret-/Federation-Weg *„Sache A. Hans"* (Korrekturblatt 37, gez. M. Veil 07.08.2026); B2_Zugangsablage: *„Zugriff: A. Han"* |
| Warum daraus **kein Name** folgt | **B-12 behält die Personenwahl ausdrücklich dem Auftraggeber vor** |
| Was eine dritte Person kosten würde | **2 von 2 Organisationssitzen sind belegt**; Plattform-Admins brauchen eine `@exmachinai.com`-Adresse. Das ist eine Personalentscheidung |
| Ungelöster Widerspruch | Der Vermerk vom 06.08. baut auf **zwei** Handelnden (einer löst aus, einer misst). Wer *„BR Andrew"* ist, steht in Blatt 04 **in der Konzept-Fabrik** und ist hier nicht nachschlagbar |

Die Empfangsseite des Prüfversands ist zu beschreiben als **„über Umgebungsvariable gesetzt,
nicht im Bestand"** — mehr ist darüber im Repo nicht messbar.

> **Etikett: VORSCHLAG DES HARNESS zur Umformung der Frage** (Rolle statt Name) — **keine
> Messung**. Gemessen ist allein, welche Rolle die Quellen dem Mailweg zuordnen.

**Bleibt beim Menschen:** Beide Namen. Ob überhaupt eine zweite Person Zugriff bekommt. Ob
Auslösen und Messen bei derselben Person liegen dürfen. Wer *„BR Andrew"* ist. Der Name des noch
nicht angelegten Tresors. **Nicht mit zu entscheiden** sind die Leserechte der drei
Maschinen-Identitäten und der Notfallweg des Abonnement-Eigentümers.

`☐` Tresor: ⟨Name: ⟩ · `☐` Echter Versand wird ausgelöst von: ⟨Name: ⟩ ·
`☐` Beide Kästchen werden auf **Rolle** statt Name umgestellt

---

# 6 · Was **„vor der Übergabe"** heißt (V-5)

**Die Frage:** Meint die Frist in den Konzepten die Übergabe **eines Pakets an einen Kunden** —
oder die **Lieferung an den Auftraggeber**? An der Antwort hängen zwölf offene Punkte.

**Vorschlag: Übergabe an einen Kunden (K10).** Die Indizienkette, offen hingeschrieben, damit
sie widerlegbar bleibt:

1. **K10-M35** definiert den Vorgang über einen **Empfänger, der ein Mandant der Art Partner
   ist** — eine Lieferung an den Auftraggeber hat keinen solchen Empfänger.
2. **K10-M11** ist die **einzige** Klausel im Bestand, die *„vor der Übergabe"* als Frist führt
   — nachgemessen an allen **1231** Wortlauten. (Die zweite Fundstelle K14-M09 meint die
   Übergabe an ein Sprachmodell.)
3. Der Auftrag nennt seine **eigene** Abgabe durchgehend **„technische Lieferabnahme"**.
4. Die Konzepte führen *„vor technischer Abnahme"* bereits als **eigene** Fristgruppe.

**Folge bei diesem Weg:** Die zwölf bleiben, wo sie stehen. **Vor dem 31.08. entsteht keine
zusätzliche Arbeit.**
**Folge beim anderen Weg:** Zehn Punkte rücken vor — bei **acht Arbeitstagen**, und **sieben der
zwölf tragen „Datenmodell" als Träger**, das Rang 1 hat und eingefroren ist.

**Drei Berichtigungen, die vor das Kreuz gehören:**

| | |
|---|---|
| **a** | Der Kästchentext *„sie bleiben in Bündel E"* ist unrichtig: **10** der 12 stehen in E, O-K14-2 in D, O-K15-2 in B. Die Zahl **„11 der 12" ist auf 10 zu berichtigen** |
| **b** | **O-K14-2 bleibt ausgenommen** — seine Fälligkeit hängt am Teilschnitt, nicht an der Wortbedeutung; es verlangt auch bei diesem Weg eine Änderung am eingefrorenen Datenmodell |
| **c** | Das Wort **„Lieferübergabe"** steht in vier Harness-Blättern und **in keiner Klausel und in keinem Auftragstext** |

> **Etikett: AUSLEGUNGSVORSCHLAG des Harness**, gestützt auf vier Messungen. Die Gegenprobe hat
> das ursprüngliche Etikett „Befund" verworfen: die Fristspalten liegen in der Konzept-Fabrik
> und sind hier nicht aufschlagbar. **Gemessen und unstrittig ist allein die Berichtigung
> 11 → 10.**

**Bleibt beim Menschen:** Die Auslegung selbst — sie gehört dem Auftraggeber. Das **Eintragen**
gehört der Konzept-Fabrik.

`☐` „Übergabe" = an einen Kunden (K10) · `☐` = Lieferung an den Auftraggeber ·
`☐` Die Berichtigung 11 → 10 wird gemacht

---

# 7 · Die **Unterschrift in BA-1/BA-2 selbst** (H-1)

**Die Frage:** Wie wird der Vorgang so vorbereitet, dass Unterschrift, Vollzug und Nachzug in
einem Zug gehen?

> **⚠ Zuerst eine Berichtigung, und sie ist erheblich.** Das Blatt vom 19.08. nennt
> **„12 Haken (7 aus BA-1 + 5 aus BA-2)"** und an anderer Stelle **„dreizehn Haken"**. **Beides
> ist falsch.** Richtig sind **25**: 13 aus BA-1, 7 aus BA-2 Korrektur 2.1-d, 5 aus BA-2
> Korrektur 2.2 — an drei Blättern gemessen und durch `BEF-ZEICHNUNG-1_260817.md`:83–87
> bestätigt. **Die Sperre nach §12.4 Nr. 5 läuft bis zum letzten der 25**, nicht des dreizehnten.
> *(Beide Stellen sind mit diesem Blatt berichtigt.)*

**Vorschlag — der Vorgang in fünf Schritten:**

| | |
|---|---|
| **1** | **Zusammenführen vor der Unterschrift**: #41 und `scheibe/m5-gespraech`. Das ist als Empfehlung vorgelegt, **aber nicht gezeichnet** — Kreuz 0 des Blattes vom 19.08. ist leer, ebenso 1, 2, 3 und 5 |
| **2** | **Vollzugsheft**, drei Blätter, je von unten nach oben (BA-1 13 → 1; BA-2/2.1-d S9 → S1 ohne S5 und S7; BA-2/2.2 S5 → S1): je Stelle Ankerzitat, alter Wortlaut, neuer Wortlaut, Vollzugsvermerk, Rückverweis. **Mit Warnvermerk:** von den 13 BA-1-Ankern ist genau **einer** am mitgeführten §6/§6a-Auszug prüfbar, von den 12 BA-2-Ankern **zwei**; alle übrigen liegen in Abschnitten, die hier nicht vorliegen. **BA-1:479 gilt: stimmt der Anker nicht, nicht eintragen, sondern fragen** |
| **3** | **Reihenfolgevorbehalt, der bisher fehlte:** VA-1 ist **ungezeichnet** (drei leere Kästchen), und der Founder-Beschluss zu Weg 3-III (Punkt 8 dieses Blattes) steht **vor** dem Vollzug |
| **4** | **Zeichnen: drei Zellen** — BA-1:655, BA-2:466, BA-2:656. Nur diese drei |
| **5** | **Nachziehen:** neue Prüfsumme in `CLAUDE.md` Glied 2 und `arbeit/Quellen/BAUAUFTRAG_v1.1_paragraph6_und_6a.md` neu ziehen — **Stelle 4 ändert genau diesen Abschnitt** |

> **Etikett: NUR VERFAHREN.** Die einzige neue Zahl ist die Berichtigung 25 statt 12.
> **Von der Gegenprobe gestrichen:** die Behauptung, das Zusammenführen sei bereits als
> Handlungsempfehlung *gezeichnet*. Sämtliche Kästchen jenes Blattes sind leer.

**Bleibt beim Menschen:** Die Unterschrift — drei Zellen. **Der Harness trägt dort nichts ein,
auch nicht auf Weisung** (BEF-ZEICHNUNG-1, 17.08.2026). Das Eintragen der 25 Stellen im
Auftragstext (Konzept-Fabrik). Und der neue Durchstich nach §12.6, **für den es im Lieferrepo
kein Werkzeug gibt**.

`☐` Vollzugsheft wird gewünscht · `☐` Erst zusammenführen, dann zeichnen ·
`☐` anders: ⟨ ⟩

---

# 8 · **Der Liefertermin** der Antwortlisten (H-7)

**Die Frage:** Bis wann müssen die Wortlaute im Repo liegen, damit der Bau sie einbaut und der
Prüfstand sie misst?

> **⚠ Zuerst eine Berichtigung an der Zahl — und zwar nach oben.** Es sind **nicht 22 und nicht
> 19** Positionen. Zu liefern sind: (1) **zwölf Themen**, (2) **sieben Ziele**, (3) **die
> Vorschlagslisten der drei Einordnungsfragen** — die sind **nicht gebaut**; gebaut sind nur die
> Fragen selbst. **Ihre Zahl nennt keine Quelle.** Getrennt zu beauftragen: (4) die **Fachfragen
> der Stufe 02**, deren Zahl ebenfalls keine Quelle nennt. **Ohne (3) bleiben K05-M03, K05-M04
> und K05-G02 nach K23-M22 gesperrt — obwohl sie am 19.08. gezeichnet sind.**

**Vorschlag: Montag, 24.08.2026** — **ohne Uhrzeit**, mit offener Rechnung:

Anker **31.08.2026** (§6a, Endtermin für alle, wortgleich im mitgeführten Auszug). 29./30.08.
sind Wochenende. Die beiden vergleichbaren Züge im git-Verlauf liefen **2 Tage** (M3, 16
Seed-Positionen) und **über 4 Tage** (M4). Angesetzt sind **vier Arbeitstage**, Di 25. bis Fr
28.08., für Einbau, blinde Prüffälle, Nachbesserung und Antrag/Tor 1/Freigabe.

**Vier Tage ist der optimistische Rand der beiden Messungen, nicht ihr Mittel. Puffer besteht
nicht.**

> **Etikett: VORSCHLAG DES HARNESS.** Abgeleitet ist nur der **Anker** und die
> **Kalenderrechnung**. Die Vorlaufdauer ist eine **Schätzung**; die Gegenprobe hat das Etikett
> „abgeleitet" verworfen und die **erfundene Uhrzeit gestrichen**.
>
> **Vorbehalt:** Dass M5 außerhalb des Endtermins liegt, folgt aus **BA-2 Fassung D** — und BA-2
> ist ohne A. Hans Gegenzeichnung **nicht wirksam**.

**Bleibt beim Menschen:** Der **Wortlaut** aller Listen — er gehört dem fachlichen Eigentümer
K05. Die **Länge** der drei Vorschlagslisten (offener Punkt O-K05-6) und der Fachfragen. Ob
EN-05 überhaupt in den 31.08.-Stand gehört.

`☐` Liefertermin: **24.08.2026** · `☐` anderes Datum: ⟨ ⟩ ·
`☐` Die Vorschlagslisten (3) werden mitbeauftragt · `☐` Die Fachfragen Stufe 02 auch

---

# 9 · Der **Inhalt des Beschlussblatts** (B-2)

**Die Frage:** Wird der in VA-1 Teil 4 vorgeschlagene Wortlaut als Founder-Beschluss
ausgefertigt — und mit welchen Ergänzungen?

**Vorschlag:** Den Wortlaut aus **VA-1 Teil 4 unverändert** übernehmen (drei Absätze,
Begründungskasten, Kopftabelle). Er ist **Satz für Satz an BA-1 nachgeprüft und stimmt.**

**Einen vierten Absatz ergänzen — aber nicht als Zitat**, sondern in dieser Fassung:

> *„Die drei Abweichungen dieser Festlegung — von K23-M06, K23-M08 und K23-M10 — werden je als
> benanntes Restrisiko mit Träger und Wiedervorlage in der Restrisikoliste geführt (K23-M04).
> Die vierte in BA-1 Zusatz 3a genannte Abweichung (K23-M02) ist hier bewusst nicht erfasst;
> sie gehört zu Gate 11 und zur eingeengten Bedingung 4."*

> **Warum umformuliert, und das gehört auf das Blatt:** Der Satz in BA-1:283 spricht von **vier**
> Abweichungen **einschließlich K23-M02** und steht dort unmittelbar vor *„Die sperrenden Gates
> 11, 13, 14 und 15 bleiben davon unberührt"*. **Wörtlich übernommen widerspräche er dem dritten
> Absatz des eigenen Beschlusses.** Der erste Durchgang wollte ihn wörtlich zitieren — die
> Gegenprobe hat das aufgedeckt.

**Ablage:** Blatt in `arbeit/Founder_Beschluesse/` mit laufender Nummer im K00-Beschluss-Log.
**Kein Eintrag in `config/kanon.yaml`, keine Nummer F43** — der Beschluss erlischt mit der einen
Abnahme, F01–F42 tun das nicht; und gezeichnete Founder-Beschlüsse haben Rang 0 auch ohne
F-Nummer.

**Leer bleiben:** Datum, beide Namen, die laufende Nummer.

**Reihenfolgevorbehalt:** VA-1 ist **ungezeichnet**, BA-1 ohne Gegenzeichnung **nicht wirksam**
— der Beschluss wirkt erst auf eine Bedingung 3, die es dann gibt.

> **Etikett: VORSCHLAG DES HARNESS.** Der Kernwortlaut ist kein neuer Text; der vierte Absatz
> ist eine **Harness-Formulierung, kein Zitat**. Größenordnung: **ein Absatz.**

**Bleibt beim Menschen:** Die **Sachentscheidung** (drei Prüfungen aus dem Umfang nehmen) — ein
Founder-Beschluss auf Rang 0. Der Satz *„nach dem Muster von F28 und F04"* bleibt **ungeprüft**:
`kanon.yaml` liegt außerhalb dieses Repos. **Wer zeichnet, sollte einmal gegen den echten
F28-Wortlaut halten.**

`☐` Wortlaut aus VA-1 Teil 4 plus vierter Absatz in der berichtigten Fassung ·
`☐` ohne vierten Absatz · `☐` anders: ⟨ ⟩

---

# 10 · **Drei Namen für die Liefereinheit** (B-3)

**Die Frage:** Wer unterschreibt am 31.08. die Einheit `teilschnitt-anmeldung`, wer hat sie
geprüft, wer erzeugt?

**Vorschlag: zwei Felder abgeleitet, eines ausdrücklich zur Wahl gestellt.**

| Feld | Wert | Grundlage |
|---|---|---|
| **Es zeichnet** | **M. Veil** als abnehmender Plattform-Admin — er löst den Wechsel nach `ABNAHME` aus | `rollen.md`, `.github/CODEOWNERS`; **nach §6a M12 genügt für ABNAHME EINE Person** in dieser Rolle |
| **Es erzeugt** | Der **Auftragnehmer (Nr. 158)**, vertreten durch **A. Han** | Der Bau-Agent hat weder Freigabe- noch Zusammenführungs- noch Deploymentrecht (`CLAUDE.md` Abschn. 6, bestätigt 18.08.2026) |
| **Es prüft** | **⟨offen — zur Wahl gestellt⟩** | siehe unten |

> **Warum „es prüft" nicht abgeleitet werden darf — die Gegenprobe hat das aufgedeckt.** Der
> Bestand nennt **A. Han** für Anfordern, Ablegen und Zeichnen des Tor-3-Nachweises (gez.
> 16.08.2026) und als **zweite natürliche Person** nach K23-M21. **Damit fiele die prüfende mit
> der erzeugenden Seite zusammen.** K10-M12 und K14-G02 verlangen die Trennung für die Übergabe;
> **ob sie hier greift, entscheidet der Auftraggeber.** Der erste Durchgang hatte diese
> Streitfrage still mitentschieden und dazu **zwei** Unterschriften vorgeschrieben, wo die
> Quelle **eine** verlangt.

`☐` A. Han prüft, obwohl er erzeugt · `☐` M. Veil prüft ·
`☐` Eine dritte Person wird benannt — ⟨Name: ⟩ *(setzt einen Organisationssitz voraus; 2 von 2
sind belegt)*

**Mitzuzeichnen:** **beide** leeren Zeilen in `abnahme_VORBEREITET.md` (Z. 61 und 62). Ob A. Han
**gegen**zeichnet, ist ein eigenes Kästchen, nicht Teil der Ableitung.

**Bleibt beim Menschen:** Ob Erzeuger und Prüfer dieselbe Person sein dürfen. Ob eine oder zwei
Unterschriften. Die Spannung zwischen K23-M21 (*„zweite natürliche Person"*) und §6a M12
(*„für IN_PROD erforderlich, nicht für ABNAHME"*). **Und V-11 bleibt in `CLAUDE.md`:109 stehen,
bis alle drei Felder gefüllt sind.**

---

# 11 · **Vier oder fünf Starttore** (B-5)

**Die Frage:** Gilt Bedingung 6 des Tores II für vier Starttore oder für fünf?

**Antwort: VIER — 05, 11, 13, 15. Und zwar bedingt.**

Die Ableitung hat drei Schritte und **keinen Ermessensschritt**: Kreuz **K1-b** in BA-1 ist
gezeichnet (*„Nur M3 aufgenommen"*, gez. M. Veil, 16.08.2026) → die Auswahltabelle der Korrektur
K6 → Bedingung 6 lautet an beiden Stellen **05, 11, 13, 15**.

> **Der Vorbehalt, den die Gegenprobe eingezogen hat:** Die Zahl wird **erst mit A. Hans
> Gegenzeichnung wirksam. Bis dahin gilt fünf** (§12.9).

**Nicht getrennt zeichnen, sondern mit BA-1 vollziehen** (Punkt 7 dieses Blattes). Ein Starttor
aus einer gezeichneten Abnahmebedingung zu streichen wäre eine Umfangsänderung und brauchte ein
eigenes Korrekturblatt.

**Zwei Berichtigungen am Abnahmeblatt:**

| | |
|---|---|
| **a** | **ST-14 als benannten Befund anlegen — ohne Träger und Frist**, beide Felder ausdrücklich als offen führen. Sonst entsteht genau die Angabe-ohne-Quelle, die dieses Blatt vermeiden will |
| **b** | **Punkt 5 nicht schließen, sondern umformulieren:** *„Die Fundstelle `starttor_11_13_nachweis_260816.md`:8 und :26 stützt sich auf einen Bedingungs-6-Wortlaut, der in BA-1 nicht steht, und behandelt BA-1 als wirksam. Zu berichtigen."* |

> **Etikett: BEDINGT ABGELEITET.** Die Zahl folgt zwingend aus einer gezeichneten Wahl; die
> **Wirksamkeit** hängt an einer ausstehenden Willenserklärung. Der **Weg** (mit BA-1 vollziehen)
> ist ein Vorschlag des Harness.

**Bleibt beim Menschen:** A. Hans Gegenzeichnung. Die vier Punkte aus Abschnitt 8 (Starttor 13
klären, ST-14 entscheiden, BEF-ST05, BEF-ST15). **Träger und Frist für ST-14 hat niemand
benannt.** Und für Starttor 14 fehlt der Übergabepunkt selbst: `create_direct_prototype` ist
**nur ein Name** in `schema/K19_screens.yaml`:159.

`☐` Vier — mit BA-1 vollzogen, nicht getrennt gezeichnet · `☐` anders: ⟨ ⟩

---

# Was dieses Blatt **nicht** kann

| | |
|---|---|
| **Fünf Punkte verlangen eine Angabe, die in keiner Quelle steht** | die zwei Namen (5), der Prüfer (10), die Anordnung des Kastens (4), die Auslegung (6), die Sachentscheidung (9). **Der Harness hat sie nicht geraten und rät sie auch nicht** |
| **Drei Punkte hängen an einer einzigen Unterschrift** | Punkte 2, 11 und Teile von 8 werden erst mit A. Hans Gegenzeichnung unter BA-1 wirksam. **Bis dahin gilt jeweils der alte Wert** |
| **Ein Punkt ist Handarbeit, kein Knopfdruck** | die 113 Zeilen (1 und 2) — das Werkzeug kann diese Spalten nicht setzen |
| **Ein Punkt darf vom Harness gar nicht empfohlen werden** | Punkt 4, nach Z-13 vom 19.08.2026 |

---

## Zeichnung

| | Punkt | |
|---|---|---|
| **1** | Träger der 113 Risikozeilen | ☐ · ⟨ ⟩ |
| **2** | Frist der 113 Risikozeilen | ☐ · ⟨ ⟩ |
| **3** | Die vier zurückgestellten Bauaufgaben (Kreuz 2.1-Z) | ☐ · ⟨ ⟩ |
| **4** | EN-04a: die zwei Berichtigungen · die Anordnung | ☐ · ⟨ ⟩ |
| **5** | Tresorzugriff und echter Mailversand — **zwei Namen** | ☐ · ⟨ ⟩ |
| **6** | „vor der Übergabe" — die Auslegung | ☐ · ⟨ ⟩ |
| **7** | Der Vorgang zu BA-1/BA-2 (Vollzugsheft, Reihenfolge) | ☐ · ⟨ ⟩ |
| **8** | Liefertermin und Umfang der Antwortlisten | ☐ · ⟨ ⟩ |
| **9** | Inhalt des Beschlussblatts | ☐ · ⟨ ⟩ |
| **10** | Drei Namen für die Liefereinheit | ☐ · ⟨ ⟩ |
| **11** | Vier Starttore | ☐ · ⟨ ⟩ |

| Name | Rolle | Datum |
|---|---|---|
| A. Han | für den Auftragnehmer (Nr. 158) | ⟨ ⟩ |
| M. Veil | für den Auftraggeber | ⟨ ⟩ |

---

*Erstellt am 20.08.2026. Jeder Vorschlag ist von einer zweiten, unabhängigen Instanz
gegengelesen worden, die den Auftrag hatte, ihn zu widerlegen; sechs wurden berichtigt, zwei
schwer beanstandet. Die Berichtigungen stehen im Text, nicht in einer Fußnote — wer nur den
Vorschlag liest, soll auch lesen, was an ihm falsch war. Der Harness trägt in keines der
Kästchen etwas ein, das nicht angewiesen ist (`CLAUDE.md` Abschn. 6).*
