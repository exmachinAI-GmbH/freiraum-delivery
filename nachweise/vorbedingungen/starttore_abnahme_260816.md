# Abnahmeblatt · Die Starttore der Bedingung 6

**Die Abnahme M. Veils ist übertragen und liegt jetzt für alle vier gezeichneten Starttore
an einer Stelle. Zwei Punkte bleiben ausdrücklich offen: die Verdrahtung von Starttor 13 und
Starttor 14, das im Auftragstext mitgezählt wird und in der Zeichnung fehlt.**

| | |
|---|---|
| **Betrifft** | Bedingung 6 der technischen Lieferabnahme — die Starttore aus Abschnitt 4 des Bauauftrags |
| **Datum** | 16.08.2026 |
| **Art** | **Abnahmeblatt.** Es führt zusammen, was an vier Stellen verstreut lag |
| **Grundlage** | Zeichnung **B-1** vom 16.08.2026 (`arbeit/Vorlagen/zeichnung_B1-B5_260816.md`) |
| **Form** | Die Kreuze sind **übertragen**, nicht selbsttätig gesetzt (**F40** — die Festlegung, dass ein Agent nie zeichnet, sondern nur die Zeichnung eines Menschen abbildet) |

---

## 1 · Was Bedingung 6 verlangt

Der Bauauftrag trennt zwei Handlungen, und er tut es wörtlich
(`03_N5_BAUAUFTRAG_v1.1_260807.md`, Zeile 728):

> „**Die Starttore 05, 11, 13, 14 und 15 aus Abschnitt 4 sind nachgewiesen** — sie betreffen
> den Bau. Nachweis: A. Han. Abnahme: M. Veil (Nr. 157; Blatt 31, Punkt G; die Auswahl ist
> mit Blatt 36 am 07.08.2026 gezeichnet)."

**A. Han führt den Nachweis. M. Veil nimmt ab.** Das sind zwei Handlungen, nicht eine. Eine
Bedingung, die zwei Unterschriften verlangt und eine hat, ist nicht erfüllt.

---

## 2 · Vier oder fünf? — der Unterschied ist gemessen, nicht behauptet

**Die Zeichnung B-1 nennt vier Starttore: 05, 11, 13, 15. Der gezeichnete Auftragstext nennt
fünf: 05, 11, 13, 14, 15.** Beide Fundstellen im Wortlaut:

| Quelle | Was dort steht | Gezeichnet |
|---|---|---|
| Bauauftrag v1.1, Zeile 728 | „05, 11, 13, **14** und 15 … sie betreffen den **Bau**" | M. Veil, 07.08.2026 |
| Blatt 36, Zeile 69 | „Wie empfohlen: 05, 11, 13, **14**, 15 betreffen den Bau" | M. Veil, 07.08.2026 |
| Zeichnungsblatt zum Bauauftrag, Zeile 31 | „Tor II Bedingung 6 — Starttore 05, 11, 13, **14**, 15" | M. Veil, 07.08.2026 |
| `starttor_11_13_nachweis_260816.md`, Zeile 26 | „05, 11, 13 und 15 … sie betreffen den **Teilschnitt**" | — |

**Die vierte Zeile beruft sich auf ein „Korrekturblatt BA-1". Dieses Blatt ist nicht
auffindbar.** Gesucht wurde im ganzen Repository und im Auftragsordner:

```
$ grep -rn "BA-1" --include='*.md' ~/freiraum-delivery
nachweise/vorbedingungen/starttor_11_13_nachweis_260816.md:8: … seit dem Korrekturblatt BA-1 …

$ grep -rln "BA-1" <Auftragsordner 260805-Add-On-04>
(keine Treffer)
```

**Der Harness entscheidet das nicht.** Er trägt beide Fassungen und legt Starttor 14 als
benannten Befund vor — siehe Abschnitt 5.

---

## 3 · Die vier gezeichneten Starttore

Die Spalte *„Was es verlangt"* ist der Wortlaut aus Abschnitt 4 des Bauauftrags
(Zeilen 180–192).

### Starttor 05 · Nachweisliste für Einladungsentscheidungen

| | |
|---|---|
| **Was es verlangt** | „Nachweisliste für Einladungsentscheidungen, nur ergänzbar, Gegentest bestanden" |
| **Stand im Auftragstext** | „Träger gebaut, Abnahme offen" |
| **Nachweis geführt von** | **A. Han**, Blatt 46 (`46_ABNAHME_STARTTOR_05_260808.md`), gezeichnet **09.08.2026** |
| **Was der Nachweis misst** | Fünf Gegentests gegen eine Wegwerfdatenbank `freiraum_st05`, je an der eigenen Regel gescheitert. Urteil dort: „abgenommen — mit BEF-ST05 als offenem Punkt zu O-K15-3" |
| **Abnahme M. Veil** | **[x] abgenommen** — übertragen aus der Zeichnung B-1 vom 16.08.2026 |
| **Mitlaufender Befund** | **BEF-ST05** — der Fremdschlüssel `ON DELETE SET NULL` kann nie ausgeführt werden; der geplante Aufräumlauf für Einladungen bricht daran ab. Betrifft **nicht** die Eigenschaft „nur ergänzbar", die gemessen hält |

### Starttor 11 · Auslöser für die Protokollzeile bei der Anmeldung

| | |
|---|---|
| **Was es verlangt** | „Auslöser für die Protokollzeile bei der Anmeldung" |
| **Stand im Auftragstext** | „Träger gebaut" |
| **Nachweis geführt von** | **A. Han**, Weisung vom **16.08.2026**, abgelegt in `starttor_11_13_nachweis_260816.md` |
| **Hier nachgemessen** | Der Auslöser existiert: `CREATE OR REPLACE TRIGGER auth_session_event_trg` in `migrations/M30__pilot_sammelmigration.sql`, Zeile 969. Die Anwendung nennt ihn und knüpft die Anmeldung daran: `app/anmeldung.py`, Zeilen 197–198 — *„Der Ausloeser auth_session_event_trg schreibt im selben Vorgang die Protokollzeile; scheitert sie, scheitert die Anmeldung."* Der Prüffaden `anmeldung` führt **30 Prüffälle** (gezählt in `pruefungen/klauseln/anmeldung_lauf.sh`); der letzte abgelegte Lauf meldet **30 von 30 bestanden, 0 gescheitert** (`nachweise/manifeste/tor1c_260814.json`, Zeile 9) |
| **Abnahme M. Veil** | **[x] abgenommen** — übertragen aus der Zeichnung B-1 vom 16.08.2026 |

### Starttor 13 · Erzeuger und Ablage des Arbeitsdokuments im Schnellweg

| | |
|---|---|
| **Was es verlangt** | „Erzeuger und Ablage des Arbeitsdokuments im Schnellweg" |
| **Stand im Auftragstext** | „**entschieden** (Nr. 66); **Verdrahtung offen**" |
| **Nachweis geführt von** | **A. Han**, Weisung vom **16.08.2026**, abgelegt in `starttor_11_13_nachweis_260816.md` |
| **Abnahme M. Veil** | **[x] abgenommen — unter dem Vorbehalt in Abschnitt 4** |

### Starttor 15 · Beziehung Vorlage → Elementvorlage

| | |
|---|---|
| **Was es verlangt** | „Beziehung Vorlage → Elementvorlage" |
| **Stand im Auftragstext** | „offen" |
| **Nachweis geführt von** | **A. Han**, Blatt 49 (`49_ABNAHME_STARTTOR_15_260809.md`), gezeichnet **10.08.2026** |
| **Was der Nachweis misst** | Elf Fälle gegen eine Wegwerfdatenbank `freiraum_st15`; neun scheitern an der vorgesehenen Regel, zwei sind der Befund. Urteil dort: „abgenommen — mit BEF-ST15 als offenem Punkt, vorzulegen mit MB-3" |
| **Abnahme M. Veil** | **[x] abgenommen** — übertragen aus der Zeichnung B-1 vom 16.08.2026 |
| **Mitlaufender Befund** | **BEF-ST15** — eine neue Beziehung darf heute auf eine Elementvorlage zeigen, die längst ausgemustert ist; geprüft wird nur die Art, nicht Status und Gültigkeit |

> **Zu 05 und 15, ausdrücklich:** Die Blätter 46 und 49 liegen außerhalb dieses Repositorys
> und gehören nach F40 den Menschen. **Sie sind gelesen, nicht angefasst.** Beide tragen bis
> heute **nur die Zeichnung A. Hans** — die Zeile M. Veils fehlt dort seit dem 09. bzw.
> 10.08.2026. Dieses Blatt holt die fehlende Abnahme nach; es ändert die Blätter nicht.

---

## 4 · ⚠ Der Vorbehalt zu Starttor 13 — hier nachgemessen

**Der Auftragstext sagt: Verdrahtung offen. Die Messung bestätigt das.** Der Nachweis A. Hans
deckt das Starttor der Form nach ab; ein eigener Beleg für die Verdrahtung liegt in diesem
Repository nicht.

„Verdrahtung" heißt hier: Der Weg vom Bildschirm bis zur gespeicherten Zeile ist
durchgeschaltet. Gemessen wurde beides getrennt — die **Ablage** (wo das Arbeitsdokument
landet) und der **Erzeuger** (was es anlegt).

| Was | Gemessen | Ergebnis |
|---|---|---|
| **Ablage** — die Tabelle | `schema/freiraum_datamodel.sql`, Zeile 314: `CREATE TABLE direct_prototype`; erweitert in `migrations/M30__pilot_sammelmigration.sql`, Zeilen 1570–1578 | **vorhanden** |
| **Erzeuger** — der Serverbefehl | Der Bildschirmvertrag benennt ihn: `schema/K19_screens.yaml`, Zeile 159 — Aktion `arbeitsdokument`, `serverbefehl: "create_direct_prototype"` | **nur als Name** |
| Umsetzung dieses Befehls | `grep -rn "create_direct_prototype"` über das ganze Repository | **ein Treffer**, und der ist die Zeile 159 selbst |
| Anlegen einer Zeile aus der Anwendung | `grep -rn "direct_prototype" app/` | **0 Treffer** |
| Anlegen einer Zeile überhaupt | `grep -rn "INSERT INTO direct_prototype"` | **ein Treffer**: `pruefungen/migration/M30__pruefung.sql`, Zeile 1009 — ein **Prüffall**, nicht die Anwendung |
| Der Bildschirm davor (EN-03a, die fünf Fragen des Schnellwegs) | `grep -rn "EN-03a" app/` | **nicht gebaut.** `app/vorpruefung.py`, Zeilen 640–656 nennt den Grund: der Wortlaut der fünf Fragen steht **in keinem gezeichneten Konzept**; ihn zu erfinden wäre Umfang ohne Zeichnung |
| Der Bildschirm danach (EN-12) | `grep -rn "EN-12" app/` | **0 Treffer** |

**Der ehrliche Befund in einem Satz: Die Ablage steht, der Erzeuger fehlt — und der Weg
dorthin bricht schon einen Bildschirm früher ab.**

**Das ist keine Nachlässigkeit des Baus.** Der Bau hat an dieser Stelle bewusst nichts
gebaut, weil ihm die gezeichnete Grundlage fehlt, und er hat das im Quelltext benannt. Der
Auftragstext und die Messung sagen dasselbe.

### Zwei Wege stehen offen — beide sind vertretbar

| | Weg | Wirkung |
|---|---|---|
| **1** | **Die Verdrahtung gilt als erfolgt** | Dann widerspricht die Messung oben. Der Vorbehalt entfällt nur, wenn benannt wird, wo der Erzeuger steht |
| **2** | **Die Verdrahtung ist offen** | Die Abnahme gilt **unter der Auflage**, dass der Punkt als benannter Befund mit Träger und Frist geführt wird |

**Bis zur Klärung wird Starttor 13 als Befund geführt. Der Harness entscheidet das nicht.**

---

## 5 · ⚠ Befund ST-14 · Starttor 14 fehlt in der Zeichnung

**Was Abschnitt 4 dazu sagt** (Zeile 189):

| Nr. | Tor | Verantwortlich | Stand |
|---|---|---|---|
| **14** | **Übergabe K04 → K07** | **A. Han** | **offen** |

**Warum das zählt:** Der gezeichnete Auftragstext führt Starttor 14 in Bedingung 6. Die
Zeichnung B-1 nennt es nicht. Für 14 liegt **kein Nachweis** vor — weder in diesem
Repository noch als Blatt im Auftragsordner. Sein Stand im Auftragstext ist unverändert
*„offen"*.

**Es fällt erst auf, wenn jemand das Liefertor nachrechnet** — dasselbe Muster, das am
15.08.2026 schon bei Starttor 05 und 15 zugeschlagen hat.

**Beachtenswert:** Starttor 14 ist die Übergabe von K04 (Vorprüfung) an K07 (Arbeitsdokument)
— **genau die Stelle, an der auch Starttor 13 hängt.** Die Messung in Abschnitt 4 ist damit
zugleich die Messung zu 14: Der Serverbefehl `create_direct_prototype` ist der
Übergabepunkt, und er ist nicht gebaut.

| | |
|---|---|
| **Abnahme M. Veil** | **[ ] steht aus** — der Harness setzt hier kein Kreuz |
| **Zu entscheiden** | Gilt Bedingung 6 für vier Starttore oder für fünf? |
| **Wer entscheidet** | **M. Veil**, gemeinsam mit A. Han |
| **Warum nicht hier** | Ein Starttor aus einer gezeichneten Abnahmebedingung zu streichen, wäre eine Umfangsänderung. Der Weg dafür ist ein Korrekturblatt nach Abschnitt 12 des Bauauftrags |

---

## 6 · Der Stand in einer Tabelle

| Starttor | Nachweis | Von | Wann | Abnahme M. Veil | Vorbehalt |
|---|---|---|---|---|---|
| **05** | Blatt 46 | A. Han | 09.08.2026 | **[x]** übertragen 16.08.2026 | BEF-ST05 läuft mit |
| **11** | Weisung 16.08. | A. Han | 16.08.2026 | **[x]** übertragen 16.08.2026 | — |
| **13** | Weisung 16.08. | A. Han | 16.08.2026 | **[x]** übertragen 16.08.2026 | **Verdrahtung gemessen offen** |
| **14** | **liegt nicht vor** | — | — | **[ ] steht aus** | **Befund ST-14** |
| **15** | Blatt 49 | A. Han | 10.08.2026 | **[x]** übertragen 16.08.2026 | BEF-ST15 läuft mit |

---

## 7 · Die Zeichnung, aus der die Kreuze stammen

Wortlaut der Weisung des Auftraggebers vom 16.08.2026, übertragen nach F40:

> „B-1 bis B-5 gem. Handlungsempfehlungen freigegeben. Setze alles komplett um, so dass alle
> offenen Themen gem. Deinen Handlungsempfehlungen, die ich voll unterstütze, geschlossen und
> erledigt werden. Gez. M. Veil, 16.8.26"

**Gez. M. Veil, Auftraggeber, 16.08.2026.**

Der zugehörige Zeichnungssatz in `arbeit/Vorlagen/zeichnung_B1-B5_260816.md`, Zeile 28:

> **B-1** · „Die vier Starttore 05, 11, 13 und 15 sind abgenommen. Nachweis: A. Han.
> Abnahme: M. Veil" — **[x]** · siehe Vorbehalt

---

## 8 · Was danach noch bei einem Menschen liegt

| | Was | Wer | Warum |
|---|---|---|---|
| 1 | **Starttor 13 klären** — Verdrahtung erfolgt oder Befund mit Träger und Frist | M. Veil / A. Han | Der Auftragstext und die Messung sagen beide *offen* |
| 2 | **Befund ST-14 entscheiden** — vier Starttore oder fünf | M. Veil / A. Han | Der gezeichnete Auftragstext nennt fünf |
| 3 | **BEF-ST05 entscheiden** — Weg 1, 2 oder 3 aus Blatt 46 | A. Han (O-K15-3) | Sonst bricht der Aufräumlauf für Einladungen ab |
| 4 | **BEF-ST15 vorlegen** — zusammen mit MB-3 | A. Han | Berührt K25-M14, deshalb keine stille Änderung |
| 5 | **Die Angabe „Korrekturblatt BA-1" klären** | M. Veil / A. Han | Das Blatt ist nicht auffindbar; die Zahl *vier* hat damit keine belegte Quelle |

---

*Angelegt am 16.08.2026 vom Orchestrator des Coding-Harness, auf Weisung des Auftraggebers.
Die Kreuze sind übertragen, nicht selbsttätig gesetzt (F40). Alle Messungen in diesem Blatt
sind ausgeführt und mit Fundstelle genannt; keine ist angenommen. **Der Harness zeichnet nie
— und er erfindet keinen Umfang.***
