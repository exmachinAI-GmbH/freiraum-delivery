# Die Prüfsumme der Anlage „Baustrategie" — gebildet, mit einem Vorbehalt

**Der Bauauftrag führt für diese Anlage bis heute *„nicht gebildet — offener Punkt nach
11.5"*. Sie ist jetzt gebildet. Sie deckt aber nicht den Stand, der gezeichnet worden ist,
sondern den heutigen — und das ist der ganze Punkt dieses Blattes.**

| | |
|---|---|
| **Gemessen am** | 16.08.2026 |
| **Anlass** | Punkt **B-10** der Schlussrunde vom 16.08.2026 |
| **Regel** | `shasum -a 256 <Anlage>` — dieselbe wie bei der Anlage „Bauverfahren" (`CLAUDE.md`, Kopfzeile *Nachgerechnet mit*) |
| **An der Anlage geändert** | **nichts.** Sie liegt außerhalb dieses Repos und gehört den Menschen. Es ist nur gelesen und gerechnet worden |

---

## 1 · Was eine Prüfsumme ist — für den, der es nicht täglich liest

Eine Prüfsumme ist eine lange Zahl, die aus dem **gesamten Inhalt** einer Datei gerechnet
wird. Ändert sich ein einziges Zeichen, kommt eine völlig andere Zahl heraus. Zwei Dateien
mit derselben Prüfsumme sind inhaltlich gleich; zwei mit verschiedener sind es nicht.

**Wozu sie hier gebraucht wird:** Ohne eine Prüfsumme des alten Standes lässt sich später nie
sagen, ob ein Text seither verändert wurde. Es gibt dann kein „vorher" und kein „nachher" —
**die Nachweiskette ist an dieser Stelle dauerhaft nicht führbar.** Genau das steht heute im
Bauauftrag, Abschnitt 11.1, Zeile 797.

---

## 2 · Die Messung

### Der Befehl und seine Ausgabe

```
$ shasum -a 256 ".../260805-Add-On-04/11_ANLAGE_BAUSTRATEGIE_ENTWURF.md"
70bea79ac999d2921da622dd8814bbd59fbf6be453177112d6632a2329d57a35
```

| Feld | Wert |
|---|---|
| **Datei** | `11_ANLAGE_BAUSTRATEGIE_ENTWURF.md` |
| **Vollständiger Ort** | `10_KNOWLEDGE_REPO/ITERATION_2/02_AGENT_HARNESS_KONZEPTE/ITERATION_2/entscheidungsvorlagen/final_entscheidung-pflichtangaben/260805/260805-Add-On-04/` |
| **Prüfsumme (SHA-256)** | `70bea79ac999d2921da622dd8814bbd59fbf6be453177112d6632a2329d57a35` |
| **Größe** | 18 430 Bytes · 276 Zeilen |
| **Zuletzt geändert** | **07.08.2026, 18:05:32 Uhr** |
| **Angelegt** | 07.08.2026, 18:05:32 Uhr |

### Es gibt nur diese eine Datei

Gesucht wurde im gesamten FREIRAUM-Baum der Dropbox nach jedem Dateinamen, der
*Baustrategie* enthält. Ergebnis:

| Prüfsumme (erste 16 Zeichen) | Geändert | Bytes | Datei |
|---|---|---|---|
| `70bea79ac999d292` | 07.08. 18:05 | 18 430 | **`11_ANLAGE_BAUSTRATEGIE_ENTWURF.md`** — die Anlage |
| `084549aa2a8024de` | 08.08. 10:36 | 6 719 | `37_KORREKTURBLATT_BAUSTRATEGIE_V1_260807.md` — das Korrekturblatt |
| `1ae636523054916b` | 07.08. 11:58 | 5 199 | `BV-21_Baustrategie_Diskussion_vom_05.08.2026.md` — Beschlussnotiz |
| `1ae636523054916b` | 06.08. 00:01 | 5 199 | dieselbe Beschlussnotiz, zweite Ablage |

**Ein Exemplar des am 05.08.2026 gezeichneten Standes existiert nicht mehr.** Es ist keine
Sicherung, keine Zweitablage und keine Archivfassung gefunden worden.

---

## 3 · Der Vorbehalt — und er bestätigt sich

Der Auftrag zu B-10 nannte einen Vorbehalt: Die Anlage sei **nach ihrer Zeichnung geändert**
worden. **Er ist nachgemessen und trifft zu.** Drei unabhängige Belege:

### Beleg 1 · Die Anlage trägt die Zeichnung vom 05.08.2026

Zeile 1 und Abschnitt 8 der Anlage:

> Zeile 1: „# Anlage zum Bauauftrag · Die Baustrategie — **VIERTE FASSUNG, GEZEICHNET am
> 05.08.2026**"
>
> Zeile 234: „| M. Veil (Auftraggeber) | **05.08.2026** | **[x] getragen** — gez. M. Veil,
> nach mechanischer Gegenprüfung 13/13 |"
>
> Zeile 235: „| A. Han (Mitzeichnung) | **05.08.2026** | **[x] getragen** — gez. A. Han, nach
> der Zeichnung M. Veils |"

### Beleg 2 · Im Text steht ein Verweis auf ein Blatt vom 07.08.2026

Zeile 81 derselben Datei, in der Voraussetzungstabelle der Scheibe 1:

> „… der **Secret- oder Federation-Weg** in der Zielumgebung ist Sache A. Hans, weil die sechs
> Rollen `NOLOGIN` sind und ein Anmeldeweg dort entschieden wird, nicht im Bau
> ***(Korrekturblatt 37, gez. M. Veil 07.08.2026)***"

**Ein Text, der am 05.08. unterschrieben wurde, kann nicht auf ein Blatt vom 07.08. verweisen.**
Der Satz ist danach hineingekommen.

### Beleg 3 · Das Korrekturblatt gibt es wirklich, und es sagt selbst, was zu geschehen hat

`37_KORREKTURBLATT_BAUSTRATEGIE_V1_260807.md`, Prüfsumme
`084549aa2a8024de20b8bbf133954f20e1f8ab1d3dd95986064c049b101c5495`. Sein Kopf lautet:

> „*07.08.2026. Betrifft `11_ANLAGE_BAUSTRATEGIE_ENTWURF.md`, vierte Fassung, **gezeichnet am
> 05.08.2026** … Verfahren wie bei Blatt 12: vorgelegt, entschieden, dann eingefügt. **An der
> gezeichneten Anlage ist nichts geändert, bis die Zeichnung vorliegt.***"

Sein Zeichnungsblock ist ausgefüllt: **M. Veil am 07.08.2026**, **A. Han am 08.08.2026**.

**Was daraus folgt — und was ausdrücklich nicht:** Die Änderung war **gedeckt**. Sie ist
vorgelegt, entschieden, gezeichnet und dann eingefügt worden, genau wie das Blatt es
vorschreibt. **Es ist kein Verstoß.** Es ist ein Buchhaltungsproblem: Die Datei führt in ihrer
Kopfzeile und in ihrem Zeichnungsblock weiterhin **nur** den 05.08.2026, obwohl in ihr
inzwischen auch der Vollzug eines Blattes vom 07.08.2026 steckt.

### Der Zeitstempel ist kein Speicherfehler

Ein Änderungsdatum aus einem Wolkenspeicher kann täuschen — es kann auch von einer
Synchronisierung stammen. **Hier nicht.** Die 111 Dateien im selben Ordner tragen Daten vom
05.08. bis zum 11.08.; sie sind nicht in einem Zug angefasst worden. Der Stempel **07.08.,
18:05 Uhr** der Anlage liegt in derselben Arbeitsstunde wie der des Bauauftrags v1.1
(07.08., 17:48 Uhr) und **nach** dem Beschluss des Korrekturblatts vom selben Tag.

---

## 4 · Was die Prüfsumme oben deshalb sagt — und was nicht

| | |
|---|---|
| **Sie sagt** | Der heutige Stand der Datei ist `70bea79a…`. Jede spätere Änderung ist ab jetzt erkennbar |
| **Sie sagt nicht** | dass dies der am 05.08.2026 unterschriebene Stand ist. **Das ist er nicht** |
| **Was sie damit ist** | eine Prüfsumme über den **Stand vom 07.08.2026** — den gezeichneten Text **einschließlich** des vollzogenen Korrekturblatts 37 |

> **Eine Prüfsumme über einen Stand, der nicht der gezeichnete ist, muss das sagen.** Dieses
> Blatt sagt es. Wer die Zahl `70bea79a…` künftig zitiert, zitiert den Stand vom 07.08.2026.

---

## 5 · Was jetzt bei einem Menschen liegt

**Der Harness entscheidet das nicht** und legt hier nichts als erledigt ab. Die Prüfsumme ist
gebildet — sie zu **zeichnen** ist ein Akt des Auftraggebers. Drei Wege stehen offen; der
Harness beschreibt sie, er wählt nicht.

| | Weg | Was zu tun ist | Was danach gilt |
|---|---|---|---|
| **A** | **Den heutigen Stand als Fassung nachzeichnen** | Die Kopfzeile der Anlage um den Vollzug ergänzen (*„vierte Fassung, gezeichnet 05.08.2026, Korrekturblatt 37 vollzogen 07.08.2026"*), den Zeichnungsblock um eine Zeile mit dem 07.08. erweitern, dann die Prüfsumme **neu** bilden und zeichnen | Die Kette ist ab dem 07.08.2026 lückenlos. Der 05.08.-Stand bleibt unbelegt — er existiert nicht mehr |
| **B** | **Die Zahl oben zeichnen, wie sie ist** | Ein Kreuz auf diesem Blatt, mit dem Vermerk, dass sie den Stand vom 07.08.2026 deckt | Schnellster Weg. Die Anlage selbst führt den Widerspruch zwischen Kopfzeile (05.08.) und Inhalt (07.08.) weiter |
| **C** | **Den 05.08.-Stand wiederbeschaffen** | Aus der Versionsgeschichte der Dropbox holen, seine Prüfsumme bilden, beide zeichnen | Vollständigste Kette. Ob die Versionsgeschichte 11 Tage zurückreicht, ist **nicht gemessen** — das kann nur, wer Zugang zum Dropbox-Konto hat |

**Ein zweites Stück gehört dazu, egal welcher Weg gewählt wird:** Abschnitt 11.1 des
Bauauftrags (Zeile 797) trägt in der Prüfsummenspalte weiterhin *„nicht gebildet — offener
Punkt nach 11.5"*. Diese Zelle ist nachzuziehen. Das ist eine Änderung am Bauauftrag und
läuft nach Abschnitt 12 über ein Korrekturblatt — **es passt in dasselbe zweite
Korrekturblatt, das die Punkte B-6 und B-7 ohnehin brauchen.**

---

## Zeichnung

*Eingetragen auf Weisung des Auftraggebers vom 16.08.2026: „Ich zeichne hiermit alle
Entscheidungsvorlagen von M. Veil, gez. 16.8.26" — gezeichnet ist die Handlungsempfehlung.
**Abschnitt 5 dieses Blattes wählt selbst keinen Weg;** die Empfehlung auf Weg A stammt aus
der Handlungsempfehlung des Orchestrators vom 16.08.2026: Weg A deckt den einzigen Stand,
der noch existiert, und dieser Stand ist durch Korrekturblatt 37 gedeckt.*

- [x] **Weg A** — heutigen Stand als Fassung nachzeichnen, danach Prüfsumme neu bilden
      · **gez. M. Veil, 16.08.2026** — *„Ich zeichne hiermit alle Entscheidungsvorlagen von
      M. Veil, gez. 16.8.26"*
- [ ] **Weg B** — die Prüfsumme `70bea79ac999d2921da622dd8814bbd59fbf6be453177112d6632a2329d57a35` zeichnen, als Stand vom **07.08.2026**
- [ ] **Weg C** — den 05.08.-Stand wiederbeschaffen und beide Prüfsummen zeichnen
- [ ] **Der Bauauftrag, Abschnitt 11.1, wird mit dem nächsten Korrekturblatt nachgezogen**
      *(bleibt leer — für dieses Blatt lag die Weisung „genau ein Kreuz" vor. Abschnitt 5
      sagt, dieser Punkt gehöre dazu, **egal welcher Weg gewählt wird**; er ist nachzuzeichnen)*

| Name | Rolle | Datum | Anmerkung |
|---|---|---|---|
| **M. Veil** | Auftraggeber | **16.08.2026** | allen Handlungsempfehlungen wird gefolgt |
| **A. Han** | für den Auftragnehmer (Nr. 158) | | Mitzeichnung, wie bei der Anlage selbst |

---

*Angelegt am 16.08.2026 vom Orchestrator des Coding-Harness auf die Weisung zu Punkt B-10 der
Schlussrunde. **An der Anlage selbst ist nichts geändert worden.** Alle Zahlen dieses Blattes
stammen aus Befehlen, die am 16.08.2026 gelaufen sind, und sind mit dem Befehl daneben
nachrechenbar.*
