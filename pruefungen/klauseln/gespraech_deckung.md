# M5 "Das geführte Gespräch" · Deckung der 101 Klauseln

**20.08.2026 · blinder Prüf-Agent.** Bezieht sich auf `gespraech_daten.sql` und
`gespraech_lauf.sh`. Grundlage: `klauseln.md` (101 Klauseln mit gezeichneten
Akzeptanzkriterien, Zählung `nachweise/klauselregister/M5_klausellage_260819.json`) und
`nachweise/klauselregister/register.md`, beide am 20.08.2026 gelesen — kein Umsetzungscode,
kein `schema/`.

Zustände dieser Tabelle: **gedeckt** (Positiv- und Negativfall in `gespraech_lauf.sh`,
gegen einen laufenden Server) · **teilweise gedeckt** (ein Teil der Klausel ist HTTP-/DB-
messbar und gedeckt, ein anderer Teil ist `NICHT PRÜFBAR`, mit eigener Zeile begründet) ·
`NICHT PRÜFBAR` (kein Prüffall gebaut, Grund benannt) · **kein Prüffall** (K05-G12 allein —
die Klausel selbst sagt, dass für M5 keiner entsteht).

Fünf Gründe tragen alle `NICHT PRÜFBAR`-Zeilen dieser Datei (Kurzbuchstabe wie im Kopf von
`gespraech_lauf.sh`):

| Grund | Bedeutung |
|---|---|
| **a** | das Merkmal liegt im Umsetzungscode oder unter `schema/` — für den blinden Prüf-Agenten laut `rolle.md` verschlossen |
| **b** | das Merkmal braucht eine Konfigurationstabelle (Modellpfad-Eintrag, Positivliste „personenbezogene Angaben"), deren Feldnamen keine der 101 Klauseln nennt |
| **c** | das Merkmal braucht einen Mitschnitt des ausgehenden Modellverkehrs — kein Werkzeug dafür ist dokumentiert |
| **d** | das Merkmal braucht eine gezielte, künstliche Störung des Serverpfads (z. B. „der Protokolleintrag wird unterbunden"), für die kein Kanal dokumentiert ist |
| **e** | der Bau führt das Merkmal in Release 1 noch nicht (`Stufe: zurückgestellt` im Klauseltext selbst) |

---

## 1 · K01 — Anwendung, Zustand, Protokoll

| Klausel | Zustand | Testfall(e) in `gespraech_lauf.sh` | Bemerkung |
|---|---|---|---|
| K01-G01 | gedeckt | `K01-G01` (Positiv, wiederverwendet aus K19-D09-ziele), `K01-G01-negativ` | Zweiter Positivfall der Klausel selbst ist die Ziele-leer-Beobachtung; eigener Negativfall: `confirm_initial_problem` ohne Zusammenfassung. |
| K01-G09 | gedeckt | `K01-G09` | Reuse derselben Ziele-leer-Beobachtung; zweite Form (ausgegraut) führt der Bildschirmvertrag laut Klauseltext an keiner Aktion. |
| K01-M01 | gedeckt | `K01-M01-vorher`, `K01-M01` | Isolationskontrolle `gs_isoliert@`, Vorher/Nachher Feld für Feld gleich. |
| K01-M05 | gedeckt | `K01-M05` | reine DB-Abfrage über alle Anwendungen der Datei. |
| K01-M07 | gedeckt | `K01-M07` | kein Location-Header auf ein getrenntes Formular über die gesamte Stufe-01-Fahrt. |
| K01-M09 | gedeckt | `K01-M09` | Speichern erfolgreich, neue `document`-Zeile entstanden. |
| K01-M15 | gedeckt | `K01-M15` | `gs_fremd@` gegen App von `gs_frisch@`: gleiche Antwort wie auf nirgends vergebene Kennung. |
| K01-M16 | teilweise gedeckt | `K01-M16` (getippt/diktiert), `K01-M16-hochgeladen` (**NICHT PRÜFBAR**, Grund e) | „Diktiert" ist am HTTP-Rand nicht von „getippt" unterscheidbar — beides füllt dasselbe Freitextfeld; das wird im Testfall offen benannt, nicht verschwiegen. |
| K01-M17 | **NICHT PRÜFBAR** | `K01-M17` | Grund b + c (Positivliste personenbezogener Angaben fehlt; kein Mitschnitt des Modellverkehrs). |
| K01-M21 | gedeckt | `K01-M21` | Zähler der `event`-Einträge zum Namenswechsel vorher/nachher. |

## 2 · K02 — Protokoll (`event`)

| Klausel | Zustand | Testfall(e) | Bemerkung |
|---|---|---|---|
| K02-D01 | gedeckt | `K02-D01` | direkter `UPDATE`-Versuch auf einen vorhandenen `event`-Eintrag, Feldstand vorher=nachher. |
| K02-D04 | teilweise gedeckt (Grund d) | `K02-D04` | Ersatzmessung über natürlich scheiternden Schreibvorgang (`gs_ohnecheck@`) statt künstlich unterbundenem Protokolleintrag — im Testkommentar offen benannt. |
| K02-M12 | gedeckt | `K02-M12` | Zuwachs der `event`-Einträge um genau den erwarteten Betrag. |
| K02-M13 | gedeckt | `K02-M13` | jüngster Eintrag trägt Zeitpunkt, Aktion, Quelle gefüllt. |
| K02-M14 | gedeckt | `K02-M14` | `source = PORTAL_ACTION`, der im Bildschirmvertrag zitierte Wert. |
| K02-M15 | gedeckt | `K02-M15` | `event.value` trägt sowohl den Wert vorher als auch den Wert jetzt. |
| K02-M20 | teilweise gedeckt | `K02-M20-server` (gedeckt), `K02-M20-datenbestand` (**NICHT PRÜFBAR**, Grund b: kein bekannter Mandantenkontext-Mechanismus außerhalb des Serverpfads) | |
| K02-M21 | teilweise gedeckt | `K02-M21-server` (gedeckt, ERGÄNZUNG-Positivfall über K01-M15), `K02-M21-negativfaelle` (**NICHT PRÜFBAR**, `event.tenant_id` wird serverseitig gesetzt, kein Weg sie zu verfälschen; Betreiberzugriff entfällt strukturell auf ENDUSER-Bildschirmen) | |
| K02-M22 | gedeckt | `K02-M22` | Kanarientext (voller Antwortinhalt) steht nicht in `event.value`/`event.object_ref`. |

## 3 · K03 — Konto, Sitzung, Identität

| Klausel | Zustand | Testfall(e) | Bemerkung |
|---|---|---|---|
| K03-D01 | gedeckt | `K03-D01` | `gs_gesperrt@` scheitert an der Anmeldung. |
| K03-D11 | **NICHT PRÜFBAR** | `K03-D11` | Grund b — kein Schalter, den Zustand der KI-Komponente von außen zu setzen. |
| K03-M03 | gedeckt (Teilumfang) | `K03-M03` | reiner DB-Constraint-Test (`email`/`display_name` NOT NULL); die Vorbelegung aus der Einladung ist bereits Gegenstand von `anmeldecode_lauf.sh`/`einloesung_lauf.sh` (F07, nicht erneut gefahren). |
| K03-M20 | gedeckt | `K03-M20`, `K03-M20-negativ` | `gs_gleich1@`/`gs_gleich2@`, gleicher Anzeigename, verschiedene `event.actor_id`; Änderungsversuch wirkungslos. |

## 4 · K04 — Eignung (Gate vor Stufe 01)

| Klausel | Zustand | Testfall(e) | Bemerkung |
|---|---|---|---|
| K04-G04 | gedeckt | `K04-G04`, `K04-G04-offen`, `K04-G04-ohnecheck` | dritte Auspägung „nicht lesbar" stellvertretend über fehlenden `fit_check` gemessen. |
| K04-M11 | gedeckt | `K04-M11`, `K04-M11-vorgabe`, `K04-M11-wertevorrat` | Vorgabewert OFFEN, dritter/vierter Wert von der DB abgewiesen. |

## 5 · K05 — das Konzept des Gesprächs selbst (56 Klauseln)

| Klausel | Zustand | Testfall(e) | Bemerkung |
|---|---|---|---|
| K05-D01 | gedeckt | `K05-D01` | Übersprungvermerk sichtbar. |
| K05-D02 | gedeckt | `K05-D02` | Marken-Trennung Eintrag/Übersprungvermerk. |
| K05-D03 | gedeckt | `K05-D03` | Freitext-Wortlaut bleibt nach weiteren Aktionen zeichengleich. |
| K05-D04 | gedeckt | `K05-D04-positiv`, `K05-D04-negativ` | Namensvorschlag überschreibbar; ohne Marke/leer abgelehnt. |
| K05-D05 | gedeckt | `K05-D05` | freier, zu keinem Vorschlag passender Wortlaut wird übernommen. |
| K05-D06 | gedeckt | `K05-D06-uebersprungen`, `K05-D06-clientstufe`, `K05-D06-fertig` | Stufe nicht überspringbar (vorwärts UND rückwärts symmetrisch geprüft). |
| K05-D07 | **NICHT PRÜFBAR** | `K05-D07` | Grund a — Nebenfragen-Fenster hat laut K05-G10 keinen eigenen Serverbefehl, also keinen HTTP-Weg hinein. |
| K05-D08 | gedeckt (Teilumfang) | `K05-D08` | kein Betrag auf den erreichten Seiten; Gegenprobe im EXMA-Portal außerhalb M5. |
| K05-D09 | **NICHT PRÜFBAR** als eigener Fall | `K05-D09` | messbarer Kern bereits in K05-M21/K01-M16 erfasst; Zweck/EU-Raum-Nachweis Grund b. |
| K05-D10 | gedeckt (Textprüfung) | `K05-D10` | eigene Lektüre der 101 Klauseln, kein HTTP-Fall möglich/nötig. |
| K05-D11 | gedeckt | `K05-D11` | `journey_phase` unmittelbar zurückgesetzt, EN-06 folgt dem geänderten Wert. |
| K05-D12 | **NICHT PRÜFBAR** | `K05-D12` | Grund e, wie im Klauseltext selbst vermerkt (F31 nicht freigegeben). |
| K05-G01 | gedeckt | `K05-G01` | |
| K05-G02 | gedeckt | `K05-G02` | eigener Wortlaut übernommen, „Zielbranche" kommt nicht vor. |
| K05-G03 | gedeckt | `K05-G03` | vergebene Marke ist die im Bildschirmvertrag genannte. |
| K05-G04 | gedeckt | `K05-G04` | zweiter, unabhängiger Lauf `gs_zielrang@`, Rangfolgen zueinander umgekehrt. |
| K05-G05 | gedeckt | `K05-G05` | Bestätigung als Tor. |
| K05-G06 | gedeckt | `K05-G06` | Namensvorschlag bleibt wirkungslos ohne Bestätigung. |
| K05-G07 | **NICHT PRÜFBAR** | `K05-G07` | Grund a — Abgleich verlangt `schema/K19_build_referenz.md`. |
| K05-G08 | gedeckt (Näherung) | `K05-G08` | Wortlaute ORIENTIERUNG/INTERVIEW gefunden; genaue Zählung „fünf Stufen" ohne Bereichsmarke nicht zuverlässig abgrenzbar. |
| K05-G09 | teilweise gedeckt | `K05-G09-vollstaendig` (**NICHT PRÜFBAR**, Grund a — voller Abgleich gegen K19 Abschn. 3) | Teilmenge „genau eine Marke je Eintrag" bereits über K05-M11/K19-G03 gedeckt. |
| K05-G10 | teilweise gedeckt | `K05-G10-text` (gedeckt, Textprüfung), `K05-G10-bildschirmvertrag` (**NICHT PRÜFBAR**, Grund a) | |
| K05-G11 | teilweise gedeckt | `K05-G11-text` (gedeckt, Textprüfung), `K05-G11-bestand` (gedeckt, Näherung über Tabellennamen — kein vollständiger Vorher-/Nachher-Katalogabgleich) | |
| K05-G12 | **kein Prüffall** | — | Klausel-eigene Festlegung: „Für M5 entsteht zu K05-G12 kein Prüffall." Restrisiko, geführt in der Restrisikoliste des Bauzugs M5 (K23-M04, K23-D07) — hier nicht zweifach geführt. |
| K05-M01 | gedeckt | `K05-M01` | offene Eingangsfrage zuerst. |
| K05-M02 | gedeckt | `K05-M02` | „Was anderes" vorhanden und wirksam; exakte Zahl 12 nur als Teilbeobachtung (offen benannt). |
| K05-M03 | gedeckt | `K05-M03-reihenfolge`, `K05-M03-positiv` | |
| K05-M04 | gedeckt | `K05-M04` | |
| K05-M05 | gedeckt | `K05-M05` | Mehrfachnennung, Rangfolge = Klickreihenfolge. |
| K05-M06 | gedeckt | `K05-M06` | |
| K05-M07 | gedeckt | `K05-M07-marke`, `K05-M07-negativ` | |
| K05-M08 | gedeckt | `K05-M08` | |
| K05-M09 | teilweise gedeckt | `K05-M09` (Vorschlag+Freitext gedeckt), `K05-M09-dritterweg` (**NICHT PRÜFBAR**, Grund e) | |
| K05-M10 | gedeckt | `K05-M10` | |
| K05-M11 | gedeckt | `K05-M11-positiv`, `K05-M11-negativ` | |
| K05-M12 | gedeckt | `K05-M12` | Namenseintrag zeigt Marke UND Bearbeitungshinweis getrennt. |
| K05-M13 | gedeckt | `K05-M13` | (dieselbe Beobachtung wie K01-M07). |
| K05-M14 | gedeckt (Teilumfang) | `K05-M14` | Vorhandensein des Hinweises gemessen; „nicht wegklickbar" ohne Browser nicht abschließend prüfbar (offen benannt). |
| K05-M15 | gedeckt | `K05-M15` | Stand überlebt Abmelden/Wiederanmelden. |
| K05-M16 | gedeckt | `K05-M16` | Teilnehmerliste nennt den Moderator. |
| K05-M17 | gedeckt (Teilumfang) | `K05-M17` | invitation-Satz entsteht; volle Annahmefahrt bei K05-M31 verwiesen. |
| K05-M18 | gedeckt | `K05-M18` | Download enthält aktuellen Stand samt Übersprungvermerk. |
| K05-M19 | gedeckt | `K05-M19`, `K05-M19-negativ` | |
| K05-M20 | **NICHT PRÜFBAR/zurückgestellt** | `K05-M20` | Grund e, wie im Klauseltext selbst festgehalten. |
| K05-M21 | gedeckt (Teilumfang) | `K05-M21` | „diktiert" nicht von „getippt" unterscheidbar (wie K01-M16). |
| K05-M22 | gedeckt | `K05-M22` | eingebettete Handlungsanweisung wirkt nicht. |
| K05-M23 | **NICHT PRÜFBAR** | `K05-M23` | Grund b + c. |
| K05-M24 | gedeckt (Teilumfang) | `K05-M24` | ein Fall aus der Rollenmatrix (Konto ohne Mitgliedschaft) live gebaut; der Rest bereits über K01-M15/K02-M20 gedeckt. |
| K05-M25 | gedeckt | `K05-M25` | |
| K05-M26 | gedeckt | `K05-M26` | `object_ref` verweist auf die neue Dokument-ID. |
| K05-M27 | teilweise gedeckt | `K05-M27-format` (gedeckt), `K05-M27-ablauf` (**NICHT PRÜFBAR**, kein Download-Endpunkt/keine steuerbare Uhr) | |
| K05-M28 | **NICHT PRÜFBAR** | `K05-M28` | Grund a — Dateiformat des Standes ist in keiner Klausel spezifiziert. |
| K05-M29 | **NICHT PRÜFBAR/zurückgestellt** | `K05-M29` | Grund e. |
| K05-M30 | **NICHT PRÜFBAR** | `K05-M30` | kein bekannter Serverpfad des freihändigen Sprachwegs (im Klauseltext selbst offen). |
| K05-M31 | teilweise gedeckt | `K05-M31-ablage` (gedeckt), `K05-M31-sicherheitsweg` (**NICHT PRÜFBAR**, F07-Verweis auf `anmeldecode_lauf.sh`/`einloesung_lauf.sh`) | |
| K05-M32 | teilweise gedeckt | `K05-M32-statusmeldung` (gedeckt, ARIA-Anzeichen), `K05-M32-tastatur` (**NICHT PRÜFBAR**, Grund a — keine Satzmaschine, wie `ZOOM200_nicht_messbar_260818.md`) | |

## 6 · K10 — Dokument

| Klausel | Zustand | Testfall(e) |
|---|---|---|
| K10-M01 | gedeckt | `K10-M01` |
| K10-M02 | gedeckt (Teilumfang: Vorhandensein/Nicht-Leere, nicht die volle Sieben-Werte-Liste) | `K10-M02` |
| K10-M03 | gedeckt | `K10-M03` |

## 7 · K13 — Plattform-Grundsätze

| Klausel | Zustand | Testfall(e) | Bemerkung |
|---|---|---|---|
| K13-M05 | teilweise gedeckt | `K13-M05-clientstufe` (gedeckt), `K13-M05-unmittelbar` (**NICHT PRÜFBAR**, kein bekannter eingeschränkter DB-Zugang) | |
| K13-M08 | teilweise gedeckt | `K13-M08-server` (gedeckt), `K13-M08-datenbestand` (**NICHT PRÜFBAR**, derselbe Grund) | |
| K13-M09 | gedeckt (Serverpfad-Teil) + teilweise NICHT PRÜFBAR | `K13-M09` (Positivteil), `K13-M09-clientstufe` (gedeckt), `K13-M09-unmittelbar` (**NICHT PRÜFBAR**) | |
| K13-M10 | gedeckt | `K13-M10` | |
| K13-M13 | gedeckt | `K13-M13` | |
| K13-M20 | teilweise gedeckt (Grund d) | `K13-M20` | Ersatzmessung wie K02-D04; Outbox-/Wiederanlauf-Teil NICHT PRÜFBAR. |
| K13-M22 | **NICHT PRÜFBAR** | `K13-M22` | Grund b. |

## 8 · K17 — Agentenbetrieb

| Klausel | Zustand | Testfall(e) | Bemerkung |
|---|---|---|---|
| K17-D03 | **NICHT PRÜFBAR** | `K17-D03` | Grund b. |
| K17-D13 | **NICHT PRÜFBAR** | `K17-D13` | Grund c. |
| K17-M02 | gedeckt | `K17-M02-negativ`, `K17-M02-anzeige` | Namenseindeutigkeit (DB) + Anzeige über Namen, nicht Kennung. |
| K17-M06 | **NICHT PRÜFBAR** | `K17-M06` | Grund b. |
| K17-M07 | **NICHT PRÜFBAR** | `K17-M07` | Grund b. |
| K17-M23 | gedeckt (Konsolidierung) | `K17-M23` | referenziert die drei bereits gemessenen Negativfälle (K01-G01-negativ, K05-M19-negativ, K05-G06). |

## 9 · K19 — Bildschirmvertrag, allgemeine Regeln

| Klausel | Zustand | Testfall(e) | Bemerkung |
|---|---|---|---|
| K19-D09 | gedeckt | `K19-D09-thema`, `K19-D09-ziele` | |
| K19-G03 | gedeckt | `K19-G03-en05`, `K19-G03-en06` | |
| K19-M06 | gedeckt | `K19-M06-ziele`, `K19-M06-ziele-erfuellt` | |
| K19-M14 | teilweise gedeckt | `K19-M14-live` (gedeckt), `K19-M14-quellcode` (**NICHT PRÜFBAR**, Grund a) | |

---

## 2 · Zählung

Maßgeblich sind die 101 Zeilen der Tabellen in Abschnitt 1–9 oben:

| Zustand | Zahl | Klauseln |
|---|---|---|
| **gedeckt** (Positiv- und Negativfall messbar, kein offener Teil) | 68 | siehe Abschnitt 1–9 |
| **teilweise gedeckt** (ein Teil gedeckt, ein anderer Teil `NICHT PRÜFBAR` mit eigener Zeile) | 16 | K01-M16, K02-D04, K02-M20, K02-M21, K05-G09, K05-G10, K05-G11, K05-M09, K05-M27, K05-M31, K05-M32, K13-M05, K13-M08, K13-M09, K13-M20, K19-M14 |
| **vollständig `NICHT PRÜFBAR`** (kein messbarer Teil ohne fehlende Angabe) | 16 | K01-M17, K03-D11, K05-D07, K05-D09, K05-D12, K05-G07, K05-M20, K05-M23, K05-M28, K05-M29, K05-M30, K13-M22, K17-D03, K17-D13, K17-M06, K17-M07 |
| **kein Prüffall** (Klausel-eigene Festlegung) | 1 | K05-G12 |
| **Summe** | **101** | |

- **0 Widersprüche gefunden.** Geprüft insbesondere: K01-G09 (Sperrform 1) gegen K19-D09/
  K19-M06 (dieselbe Form) — deckungsgleich, kein Widerspruch. K05-D12/K05-M20/K05-M30
  (freihändiger Stimmweg gesperrt) gegen K05-M09/K05-M21 (Diktat zulässig) — beide
  Aussagen bestehen nebeneinander, die Klauseln unterscheiden selbst zwischen den beiden
  Stimmwegen. Keine zwei Klauseln dieser 101 verlangen an derselben Stelle unvereinbare
  Werte.

---

## 3 · Welche Klauseln ungedeckt bleiben — und warum

Das ist der wichtigste Teil dieses Berichts. Jede der folgenden Zeilen ist eine **benannte**
Lücke, keine stillschweigend übersprungene:

### Wegen Grund a (Umsetzungscode/`schema/` verschlossen)
K05-G07, K05-G10 (Bildschirmvertrag-Teil), K05-M28, K05-M32 (Tastatur-Teil),
K19-M14 (Quellcode-Teil). — **Auflösbar**, sobald ein Prüf-Agent mit Zugriff auf `schema/`
denselben Abgleich fährt, den `k19_kasten_lauf.sh` für andere Bildschirme bereits vormacht.

### Wegen Grund b (Modellpfad-Konfiguration unbekannt)
K01-M17, K05-M23, K13-M22, K17-M06, K17-M07, K17-D03. — **Auflösbar**, sobald der
fachliche Eigentümer (a) die Positivliste „personenbezogene Angaben" und (b) den
Tabellen-/Spaltennamen des Modellpfad-Eintrags benennt (K23-M02).

### Wegen Grund c (kein Mitschnitt des Modellverkehrs)
K17-D13, K05-M23 (zweiter Teil), K05-D09 (Teil). — **Auflösbar**, sobald ein
Prüfwerkzeug den ausgehenden Modellaufruf mitschneiden kann.

### Wegen Grund d (keine dokumentierte Fault-Injection)
K02-D04, K13-M20 — beide mit einer schwächeren, aber echten Ersatzmessung über eine
natürlich scheiternde Eingabe abgedeckt; die im Klauseltext selbst vorgesehene stärkere
Form (gezielt unterbundener Protokolleintrag bei sonst erfolgreichem fachlichem Vorgang)
bleibt offen. — **Auflösbar**, sobald ein dokumentierter Fehlschlags-Kanal besteht (z. B.
ein Prüf-Header, der genau einen Schritt eines mehrschrittigen Schreibvorgangs scheitern
lässt).

### Wegen Grund e (Bauumfang zurückgestellt, Blatt 100 E4 bzw. F31)
K01-M16 (Upload-Teil), K05-D09 (Teil), K05-D12, K05-M09 (dritter Weg), K05-M20, K05-M29,
K05-M30. — **Auflösbar**, sobald `upload_interview_document` gebaut bzw. ein bewerteter
Fall für den freihändigen Stimmweg nach F31 freigegeben ist; dieser Lauf ist dann ohne
Änderung an der Klausellage erneut zu fahren.

### Kein Prüffall aus eigener Klausel-Festlegung
K05-G12 — Restrisiko, siehe Abschnitt 1.

### Teilweise offen aus Werkzeuggrenzen dieser Datei (nicht in den fünf Gründen oben, aber
### ehrlich zu nennen)
- **K05-M27-ablauf** (10-Minuten-Ablauf eines ausgestellten Zugriffs): kein bekannter
  Download-Endpunkt und keine steuerbare Serveruhr in dieser Datei.
- **K05-G08** und **K05-M02** (genaue Zahlen „fünf Stufen", „zwölf Themen"): ohne bekannte
  Bereichsmarke für die Fortschrittsanzeige bzw. die Themenliste bleibt die Zählung eine
  Näherung, keine exakte Abzählung.
- **K05-M14** und **K05-M32-tastatur**: „nicht wegklickbar" bzw. Tastaturerreichbarkeit
  brauchen echte Interaktion; ohne Satzmaschine/Browser (dieselbe, am 18.08.2026 gemessene
  Werkzeuglage wie in `ZOOM200_nicht_messbar_260818.md`) bleibt das ungemessen.

---

## 4 · Was diese Datei nicht ersetzt

- Sie ersetzt **nicht** die Restrisikoliste des Bauzugs M5 (K23-M04, K23-D07) — die führt
  ihre eigene Zeile zu K05-G12 mit Träger und Annahmeentscheidung.
- Sie ersetzt **nicht** `k19_kasten_lauf.sh` — der Abgleich gegen `schema/K19_build_referenz.md`
  (K05-G07, K19-M14 Quellcode-Teil) gehört dorthin, sobald ein Prüf-Agent mit Zugriff auf
  `schema/` ihn dort nachträgt.
- Sie ersetzt **nicht** `anmeldecode_lauf.sh`/`einloesung_lauf.sh` — der Sicherheitsweg
  einer Einladung (K05-M31) ist dort bereits Gegenstand und wird hier nicht doppelt gefahren
  (F07).

---

## 5 · Ausgangslage der Anwendungen (`app`) — von Hand oder durch die Tür

**Anlass.** Der dritte Lauf der Aufbaudaten scheiterte am 20.08.2026 an
`psql:pruefungen/klauseln/gespraech_daten.sql:270: ERROR: null value in column "project_no" of
relation "app" violates not-null constraint`. Die Bauleitung stellte daraufhin die
grundsätzlichere Frage: Ist eine von Hand mit `INSERT` angelegte `app`-Zeile für M5 überhaupt
die richtige Ausgangslage, oder muss sie — wie beim Vorbild `zweckbestimmung_daten.sql` —
durch den Serverpfad entstehen, den auch eine Nutzerin durchliefe?

**Entscheidung: Option A — die Ausgangslage legt weiter `app`-Zeilen von Hand an.** Begründung:
Bei `zweckbestimmung_daten.sql` ist die Entstehung der `app`-Zeile selbst der Prüfgegenstand
(K01-M26/K01-M27, siehe unten) — dort verböte ein von Hand gesetzter Zustand genau das, was
gemessen werden soll. Bei M5/`gespraech_daten.sql` ist die `app`-Zeile dagegen reine
Ausgangslage: keine der 101 Klauseln dieses Laufs (K01, K02, K03, K04, K05, K10, K13, K17, K19 —
Zählung `nachweise/klauselregister/M5_klausellage_260819.json`) macht eine Aussage darüber,
*wie* eine `app`-Zeile entsteht; sie machen Aussagen darüber, was mit einer bereits bestehenden
Zeile geschehen darf (K05, K19) oder wie ihr Zustand geführt wird (K01-M05, K01-M07, K01-M09).
Der Prüfgegenstand von `gespraech_lauf.sh` ist der Gesprächsinhalt (Beiträge, Herkunftsmarken,
Übersprungvermerke, der Dreischritt Datei/document/event), nicht die Entstehung der `app`-Zeile
— das legt bereits der Abschnitt „MASSSTAB F07" am Kopf dieser Datei fest, unverändert seit dem
ersten Entwurf. Eine von Hand gesetzte Ausgangslage misst hier also nichts vor, was sonst
gemessen würde.

**Korrektur einer eigenen Fehlangabe.** Der bisherige Kommentar vor Abschnitt 6 in
`gespraech_daten.sql` schrieb das beobachtete Verhalten des EIGNUNGSRIEGELS (jeder `INSERT INTO
app` ohne beim Einfügen schon gültige `fit_check_id` scheitert) der signierten Klausel
„K01-M27, offener Punkt O-K01-6" zu. Beides war falsch: `O-K01-6` ist keine geführte
Kennung — sie kommt in keiner anderen Datei dieses Prüfstands vor und wurde ohne Beleg
erfunden. `K01-M27` ist keine der 101 Klauseln dieses Laufs; sie steht in
`nachweise/klauselregister/register.md`:139 als `⟨VORSCHLAG · NICHT GEZEICHNET⟩` (ebenso
`K01-M26`, register.md:136 — dort auch das Muster `^DE-[A-Z]{3}_[0-9]{3}_[0-9]{2}$` für
`project_no`). Der Kommentar ist jetzt korrigiert: Der EIGNUNGSRIEGEL wird als beobachtetes
Verhalten des laufenden Baus beschrieben, K01-M26/K01-M27 werden nur noch als unsignierter
Hintergrund zitiert, nie als geprüfter Maßstab.

**`project_no`.** Die Spalte ist `NOT NULL`, aber kein Akzeptanzkriterium der 101 Klauseln
nennt sie — deshalb misst kein Testfall in `gespraech_lauf.sh` ihren Wert oder ihr Format. Die
Datei füllt sie je Zeile mit einem synthetischen, eindeutigen Wert der Form `DE-GSA_NNN_01`
(Mandant A) bzw. `DE-GSB_001_01` (Mandant B) — reine Infrastruktur wie die `id`-Spalte, in
derselben Rolle wie die frei erfundenen UUIDs. Das Muster ist dem ungezeichneten Vorschlag
K01-M26 entnommen, damit der Wert plausibel und lesbar bleibt; das ist eine Bequemlichkeit,
keine Behauptung über ein gezeichnetes Kriterium.

**Was das nicht abschließt.** Sollte ein künftiger Lauf eine weitere `NOT NULL`-Spalte oder
eine Sperre finden, die nur der tatsächliche Serverbefehl auflöst — nicht nur eine fehlende
Pflichtangabe —, kippt diese Abwägung zugunsten Option B, und diese Zeile wird entsprechend
nachgetragen. Bis dahin bleibt Option A die begründete Wahl für diese Datei.

**Nachtrag 20.08.2026 (vierter Nachbesserungsauftrag) — zwei weitere `NOT NULL`-Spalten,
still `name` beantwortet.** Ein Lauf ohne Abbruch beim ersten Fehler zeigte zwei weitere
`NOT NULL`-Verletzungen in `app`: `created_at` und — für die sechs Anwendungen der Stufe
ORIENTIERUNG (`ed01`-`ed06`) sowie die siebte, `ed0e` für `gs_gesperrt@` — `name`.

- **`created_at`**: dieselbe Rolle wie `project_no` oben — reine Infrastruktur, `now()` je
  Zeile, keine der 101 Klauseln stellt eine Anforderung an den Erstellungszeitpunkt, kein
  Testfall in `gespraech_lauf.sh` liest die Spalte.
- **`name`**: Fall 1 der beiden Möglichkeiten aus dem Nachbesserungsauftrag — **kein
  Widerspruch**. K05-D06/K05-M07/K05-G06 beschreiben den fachlichen Zustand „kein
  bestätigter Name" vor der Bestätigung in Stufe 01; keine der 101 Klauseln behauptet, die
  Spalte `app.name` selbst müsse `NULL` sein — das war eine Ausgangslagen-Bequemlichkeit
  dieser Datei, keine geprüfte Aussage. Der Platzhalter lautet
  `'(Ausgangslage: Name noch nicht gesetzt)'` — bewusst nicht leer und bewusst nicht wie ein
  echter oder KI-vorgeschlagener Name, damit er in keiner Anzeige verwechselbar ist. Einziger
  betroffener Testfall: `K05-M07-negativ` verglich bisher gegen eine angenommene Leere nach
  einer leeren Namenseingabe; er vergleicht jetzt den vollen Vorher- gegen den vollen
  Nachher-Zustand (`journey_phase` und `name`) — dieselbe fachliche Aussage („eine leere
  Namenseingabe ändert den Zustand nicht"), nur ohne die jetzt falsche Annahme über den
  Platzhalterwert. Kein Prüfwert wurde gesenkt, keine Erwartung gelockert.

**Der stille Fehlschlag.** Derselbe Lauf zeigte, dass die AUFBAUPRÜFUNG in Abschnitt 10 von
`gespraech_daten.sql` bei 0 `app`-Zeilen nicht angeschlagen hätte — ihre Einzelprüfungen
(a)-(i) vergleichen nur Eigenschaften vorhandener Zeilen, nie ob genug Zeilen vorhanden sind.
Abschnitt 10 zählt jetzt zusätzlich (Punkt (j)): 16 Konten, 16 Mitgliedschaften, 14
Eignungs-Checks, 13 Anwendungen — Zahlen, die aus den `INSERT`-Blöcken dieser Datei
abgezählt sind. Weicht eine davon ab, bricht die Prüfung mit dem Wort `ABBRUCH` in der
Meldung ab, statt eine leere Ausgangslage stillschweigend bestehen zu lassen.

---

*Erstellt am 20.08.2026, Abschnitt 5 nachgetragen am 20.08.2026 (dritter Nachbesserungsauftrag),
Nachtrag zu Abschnitt 5 am 20.08.2026 (vierter Nachbesserungsauftrag).
Gelesen für diesen Bericht: `klauseln.md` (vollständig, 1186 Zeilen),
`nachweise/klauselregister/M5_klausellage_260819.json`,
`nachweise/klauselregister/register.md`/`register.json` (Zeilen zu K01-G05, K01-M26, K01-M27),
`pruefungen/klauseln/zweckbestimmung_daten.sql`/`zweckbestimmung_lauf.sh`,
`pruefungen/klauseln/k19_kasten_lauf.sh` und `pruefungen/klauseln/ZOOM200_nicht_messbar_260818.md`
als Formvorbild. Nicht gelesen: `app/`, `install/`, `mail/`, `migrations/`, `seeds/`,
`schema/`, `werkzeuge/`, `arbeit/`.*
