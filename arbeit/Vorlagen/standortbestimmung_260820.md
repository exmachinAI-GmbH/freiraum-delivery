# Wo wir stehen — **die zwölf Meilensteine, gemessen**

**20.08.2026 · ⟨VORSCHLAG · NICHT GEZEICHNET⟩ · elf Tage bis zum 31.08.2026**

Dieses Blatt behauptet nichts. Jede Zeile trägt, woran sie gemessen ist. Wo nichts gemessen
werden konnte, steht **gesperrt** — nach K23-M22 ist das **nicht** dasselbe wie bestanden.

---

## Der Stand in einem Bild

```
M1 ──── M2 ──── M3 ──── M4 ──── M5 ──── M6 ─ M7 ─ M8 ─ M9 ─ M10 ─ M11 ─ M12
 ▲       ▲       ✓       ▲       ●        ·    ·    ·    ·    ·     ·     ·
 │       │               │       │
 │       │               │       └── HIER: gebaut, am 20.08. zum ersten Mal
 │       │               │           blind gemessen — und weitgehend GESPERRT
 │       │               └── Serverseite gemessen, Bildschirmseite nicht
 │       └── im Prüfstand bestanden, echte Zustellung nur einmalig belegt
 └── gebaut, gegen die Zielumgebung nie gefahren
```

**Die Phase:** M5 ist gebaut und erstmals messbar gemacht. Dabei ist sichtbar geworden, dass
**M1, M2 und M4 hinter uns nicht geschlossen sind.**

---

## Die zwölf Meilensteine

| | Meilenstein (§6a) | Stand am 20.08.2026 | woran gemessen |
|---|---|---|---|
| **M1** | Die Datenbank steht | **Gebaut, gegen die Zielumgebung ungemessen** | 111 von 111 Migrationsprüffällen bestanden, 12 Negativfälle scheitern je an **ihrer eigenen** Bedingung — **im Prüfstand**. `aufbau.sh` sagt selbst: *„eine PRÜFumgebung, kein Pilotlauf"*. `migrations/n2_lauf.sh` liegt bereit; der Lauf braucht die Pilotumgebung und `frxfw` |
| **M2** | Ein Eingeladener kann sich anmelden | **Fast — zwei benannte Sperren** | `anmeldung` 30/30 · `einloesung` 18/18 · `versand` 9/9 · `anmeldecode` 16/17 · `mitgliedschaft` 8/9. Beide offenen sind **gesperrt, nicht gescheitert**: **AC-16** (echte Zustellung — nur durch einen Einzellauf vom 10.08. belegt, nicht wiederholbar) und **MG-08** (der Ablauf einer Einladung ist über **keine bekannte Tür** prüfbar) |
| **M3** | Die Vorprüfung hält an | **✓ Bestanden** | `vorpruefung` 32 von 32, alle drei Auswege nach K04-M08 |
| **M4** | Eine Anwendung entsteht nur über den einen Weg | **Halb — Serverseite ja, Bildschirmseite nein** | MT-95, MT-95b, MT-96 bis MT-98 **bestanden** (`m4_nachrechnung_260819.md`). Die Bildschirmseite ist aus **zwei fremden Gründen** ungemessen: EN-04a hat **keinen K19-Kasten** (Riegel meldet GESPERRT; der Kasten gehört der Konzept-Fabrik), und 13 der 27 `zweckbestimmung`-Fälle sperren wegen **`BEF-ZB-1`** — einem Modellfehler **im Prüffall**, nicht im Bau |
| **M5** | Das Gespräch trägt und überlebt das Abmelden | **● Gebaut, kaum gemessen** | Gebaut: M32 (Zeilenschutz + Stufenwechsel), neun Serverbefehle, EN-05 und EN-06 je mit ihrem Kasten wörtlich. Tor 2 am 20.08. erstmals gefahren: **13 von 128 bestanden, 115 gesperrt, 0 fehlgeschlagen**. **88 der Sperren hängen an den fehlenden Antwortlisten** (`m5_tor2_260820.md`) |
| **M6** | Die sechs Anforderungskonzepte liegen vor | nicht begonnen | — |
| **M7** | Der Prototyp ist gebaut und bedienbar | nicht begonnen | — |
| **M8** | Das Angebot ist freigebbar | nicht begonnen | — |
| **M9** | Das Übergabe-Paket ist abrufbar | nicht begonnen | — |
| **M10** | Der Durchstich ist bestanden | nicht begonnen | — |
| **M11** | Die Lastprüfung ist bestanden | nicht begonnen | — |
| **M12** | Der Wechsel nach ABNAHME ist gezeichnet | nicht begonnen | **ein menschlicher Akt** — er läuft nie automatisch (K23-G01, K23-D06) |

---

## Die vier Messstufen, quer zu den Meilensteinen

| Tor | Was es misst | Stand |
|---|---|---|
| **1 · mechanisch** | Lint, frische Datenbank, zweiter Lauf ändert nichts, Negativfälle | grün auf `main`. Auf `scheibe/m5-gespraech` lokal gefahren: **0 fehlgeschlagen**, 5 gesperrt. In der CI für diesen Zweig noch nicht gelaufen — es gibt keinen Antrag |
| **2 · blind** | Erfüllt der Stand die gezeichneten Akzeptanzkriterien? | Für M1–M4 läuft er seit längerem. **Für M5 existiert er seit dem 20.08.** — blind erzeugt, in acht Nachbesserungsrunden |
| **3 · fremd** | Fachliche Eignung gegen Roh-Evidenz | **GESPERRT · für keine Scheibe je gelaufen.** `nachweise/fremdreview/` enthält README und Vorlage, sonst nichts. Die Anforderung liegt fertig |
| **4 · Mensch** | Wird es getragen? | offen |

---

## Was den Stand deutet — und es hängt an einer Unterschrift

**Der Auftrag sagt in §6a wörtlich:**

> *„Kein Meilenstein trägt ein eigenes Datum — es gibt einen **Endtermin für alle: den
> 31. August 2026**."*
>
> *„**Woran der Auftraggeber vor dem Endtermin misst: an M1 bis M4.** Sie sind die Kette, an
> der alles hängt; steht M4 nicht, sind M5 bis M9 gegenstandslos, und der Endtermin ist nicht
> zu halten — unabhängig davon, wie viel gebaut wurde."*

**Von diesen vier ist genau einer sauber gemessen: M3.**

Daraus folgen zwei Lesarten, und welche gilt, entscheidet **eine ausstehende Zeichnung**:

| | |
|---|---|
| **Ohne die Gegenzeichnung von BA-1 und BA-2** *(heutiger Stand)* | §12.9: *„Vorschlag bleibt liegen — **am Auftrag ist nichts geändert**."* Dann sind **alle zwölf** Meilensteine zum 31.08. geschuldet. Drei sind begonnen, neun nicht. **Elf Tage vorher ist das nicht zu halten** — und §6a sagt selbst, woran man es merkt |
| **Mit der Gegenzeichnung** *(Weg A)* | Tor II wird auf den **Teilschnitt bis zur Anmeldung** eingeengt; **M4 bis M12 werden zurückgestellt** und bekommen über BA-3 eigene Termine. Dann ist der heutige Stand **nah am Ziel**: M3 steht, M2 hat zwei benannte Sperren, M1 braucht einen Lauf gegen die Pilotumgebung |

> **Das ist der eigentliche Befund dieses Blattes.** Es fehlt nicht in erster Linie Bau. Es
> fehlt eine Entscheidung darüber, **was am 31.08. geschuldet ist** — und bis sie getroffen
> ist, arbeitet der Bau gegen einen Umfang, den beide Seiten unterschiedlich lesen.

---

## Die drei Dinge, die den Stand am schnellsten bewegen

**Keines davon ist eine Bauaufgabe.**

| | | wer | Wirkung |
|---|---|---|---|
| **1** | **BA-1 und BA-2 gegenzeichnen** | **A. Han** — drei Zellen (BA-1:655, BA-2:466, BA-2:656), danach **25** Eintragungen im Auftragstext | Entscheidet, welche der beiden Lesarten oben gilt. Solange sie fehlt, ist jede Aussage über „geschuldet" doppeldeutig |
| **2** | **M1 gegen die Pilotumgebung fahren** | braucht die Umgebung und `frxfw` | Schließt den ersten Meilenstein der Kette. Das Skript liegt bereit — es fehlt nur der Zugang |
| **3** | **Die Antwortlisten liefern** — zwölf Themen, sieben Ziele, drei Vorschlagslisten, Fachfragen Stufe 02 | **A. Han**, fachlicher Eigentümer K05 | Löst **88 der 115** M5-Sperren. Kein Lauf und kein Bau kann das ersetzen: ein erfundener Wortlaut wäre eine Fälschung mit grüner Anzeige |

**Danach, in dieser Reihenfolge:** Tor 3 anfordern *(die Zykluszeit ist unbekannt, weil es nie
lief)* · #41 zusammenführen *(vor jeder Unterschrift, §12.4 Nr. 5)* · EN-04a-Kasten in der
Konzept-Fabrik · `BEF-ZB-1` an den Prüf-Agenten.

---

## Zeichnung

**Zu jeder Entscheidung steht die Empfehlung des Harness — mit ihrem Etikett.**
*Abgeleitet* heißt: der Wert folgt aus etwas Gezeichnetem durch Nachrechnen, es ist keine Wahl.
*Vorschlag* heißt: der Harness hat sich etwas überlegt, es ist begründet, aber es ist gewählt.
**Die Entscheidung gehört in jedem Fall dem Menschen.**

### 1 · Der Stand oben wird zur Kenntnis genommen

**Empfehlung: so.** *(abgeleitet)* — jede Zeile trägt ihre Fundstelle; wo nichts gemessen
wurde, steht *gesperrt* und nicht *offen*. Wer widerspricht, widerspricht einer Messung, nicht
einer Meinung — dann bitte mit der Zeile, die nicht stimmt.

`☒` **so** — ⟨am 20.08.2026 von Hand im Blatt gesetzt; nicht vom Harness⟩
`☐` Einwand zu Zeile ⟨ ⟩: ⟨ ⟩

### 2 · Alle zwölf zum 31.08. — oder Weg A?

**Empfehlung: Weg A.** *(Vorschlag des Harness — die Sachentscheidung gehört dem
Auftraggeber.)*

Der Grund ist eine Rechnung, keine Vorliebe: **neun der zwölf Meilensteine sind nicht
begonnen**, und §6a sagt selbst, dass M5 bis M9 gegenstandslos sind, solange M4 nicht steht.
Elf Tage reichen dafür nicht — unabhängig davon, wie viel gearbeitet wird.

> **Der Punkt ist nicht, welcher Weg mehr Arbeit macht.** *Alle zwölf* zu zeichnen heißt nicht,
> mehr zu schaffen, sondern **den Termin sehenden Auges zu verfehlen**. Weg A heißt, den Umfang
> auf das zu setzen, was zum 31.08. tatsächlich eintreten kann, und dem Rest über BA-3 eigene
> Termine zu geben. G2 verlangt ohnehin: **melden, sobald es sich abzeichnet — nicht am
> 31. August.** Dieses Blatt ist diese Meldung.

`☐` **Weg A** *(Empfehlung)* · `☐` alle zwölf · `☐` anders: ⟨ ⟩

### 3 · BA-1 und BA-2 gegenzeichnen

**Empfehlung: ja — aber erst nach dem Zusammenführen von #41.** *(Vorschlag zur Reihenfolge.
Die Unterschrift selbst ist eine Willenserklärung nach §12.3 und gehört allein A. Han; der
Harness trägt dort nichts ein, auch nicht auf Weisung — `BEF-ZEICHNUNG-1`.)*

**Ab der Zeichnung ist keine Vorlage zur Freigabe mehr zulässig, bis alle 25 Haken sitzen**
(§12.4 Nr. 5). Wer vorher nicht zusammenführt, sperrt fertige Arbeit hinter der eigenen
Korrektur. Es sind **drei Zellen** — BA-1:655, BA-2:466, BA-2:656 —, danach 25 Eintragungen im
Auftragstext.

**Vorgeschlagenes Datum: Freitag, 21.08.2026.** *(Vorschlag)* — sie entscheidet Punkt 2, und
solange sie fehlt, ist jede Aussage über „geschuldet" doppeldeutig.

`☐` so, nach #41 *(Empfehlung)* · `☐` sofort, ohne #41 · Datum ⟨ ⟩

### 4 · M1 gegen die Pilotumgebung

**Empfehlung: Zugang bis Freitag, 21.08.2026.** *(Vorschlag)*

Der Bau ist hier fertig — `migrations/n2_lauf.sh` liegt bereit. **Es fehlt nur der Zugang zur
Umgebung und `frxfw`.** Von den drei Punkten, die den Stand bewegen, ist dieser der billigste:
ein Lauf, keine Entscheidung, kein neuer Text. Und er schließt den **ersten** Meilenstein der
Kette, an der nach §6a alles hängt.

`☐` Zugang bis ⟨Datum: ⟩ *(Empfehlung: 21.08.2026)* · `☐` M1 bleibt vorerst ungemessen

### 5 · Die Antwortlisten

**Empfehlung: Montag, 24.08.2026 — ohne Uhrzeit.** *(Anker abgeleitet, Vorlaufdauer
geschätzt.)*

Rückwärts vom 31.08.: der 29./30.08. ist Wochenende, es bleiben **vier Arbeitstage**
(Di 25. bis Fr 28.) für Einbau, blinde Prüffälle, Nachbesserung und Freigabe. **Vier Tage ist
der optimistische Rand zweier gemessener Züge, nicht ihr Mittel — Puffer besteht nicht.**

Zu liefern: **zwölf Themen · sieben Ziele · die drei Vorschlagslisten** (deren Länge keine
Quelle nennt) — und **getrennt zu beauftragen** die Fachfragen der Stufe 02.

> **Der Harness kann das nicht ersetzen.** Eine erfundene Themenliste wäre ein Wortlaut, den
> niemand gezeichnet hat; die Prüffälle würden ihn messen und bestehen. Das wäre kein
> Fortschritt, sondern eine Fälschung mit grüner Anzeige.

`☐` **24.08.2026** *(Empfehlung)* · `☐` anderes Datum: ⟨ ⟩
`☐` Die Fachfragen der Stufe 02 werden mitbeauftragt

### 6 · Tor 3 anfordern

**Empfehlung: diese Woche, spätestens Freitag, 21.08.2026.** *(Vorschlag)*

**Die Zykluszeit ist unbekannt, weil Tor 3 nie gelaufen ist.** Wer den Weg zum ersten Mal am
28.08. geht, erfährt zu spät, wie lange er dauert. Die Anforderung liegt fertig ausgefertigt
(`tor3_anforderung_m5_gespraech_260820.md`) — abschicken und ablegen sind zwei Handgriffe.

**Zum Namen gibt der Harness keine Empfehlung.** Wer anfordert, ist eine Personenentscheidung.
Der Bestand nennt A. Han für Anfordern, Ablegen und Zeichnen des Tor-3-Nachweises — dieselbe
Seite erzeugt aber auch den Prüfgegenstand. Ob das zusammenfallen darf, ist die offene Frage
aus **B-3**, und sie gehört dem Auftraggeber.

`☐` bis ⟨Datum: ⟩ *(Empfehlung: 21.08.2026)* · Anfordernde Person: ⟨Name: ⟩

---

### Die Empfehlungen auf einen Blick

| | Empfehlung | Etikett |
|---|---|---|
| **1** | zur Kenntnis nehmen | abgeleitet |
| **2** | **Weg A** | Vorschlag |
| **3** | gegenzeichnen — **nach** #41, am 21.08.2026 | Vorschlag zur Reihenfolge |
| **4** | Zugang zur Pilotumgebung bis **21.08.2026** | Vorschlag |
| **5** | Antwortlisten bis **24.08.2026** | Anker abgeleitet, Dauer geschätzt |
| **6** | Tor 3 anfordern bis **21.08.2026**, Name offen | Vorschlag |

**Drei der sechs Empfehlungen fallen auf denselben Tag — Freitag, den 21.08.2026.** Das ist
kein Zufall und keine Drängelei: Punkt 3 entscheidet den Umfang, Punkt 4 schließt den ersten
Meilenstein, Punkt 6 startet eine Uhr, deren Laufzeit niemand kennt. **Alle drei werden mit
jedem Tag Wartezeit teurer, keiner davon billiger.**

| Name | Rolle | Datum |
|---|---|---|
| A. Han | für den Auftragnehmer (Nr. 158) | ⟨ ⟩ |
| M. Veil | für den Auftraggeber | ⟨ ⟩ |

---

*Erstellt am 20.08.2026. Die Zahlen stammen aus `nachweise/manifeste/tor1c_260820h.json` und
dem Einzellauf des M5-Klausellaufs; die Meilensteintexte wörtlich aus
`arbeit/Quellen/BAUAUFTRAG_v1.1_paragraph6_und_6a.md`. Der Harness stellt hier fest, was
gemessen ist — **er zeichnet keinen Meilenstein als eingetreten.** Das tut ein Mensch.*
