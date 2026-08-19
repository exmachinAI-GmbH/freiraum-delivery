# Scheibe 4 · M5 — Entscheidung 3: die mitwirkenden Klauseln

**19.08.2026 · Vorschlagsliste zur Zeichnung · noch nicht gezeichnet**

Blatt 100, Entscheidung 3 (gez. 19.08.2026): *„Der Harness legt eine Vorschlagsliste aus den 368 Klauseln der sechs Konzepte vor; gezeichnet wird sie von den Founders."*

## Wie sie entstanden ist

Je Konzept ein **Sucher**, der nur aufnehmen durfte, was er an einer konkreten Aktion oder
einem konkreten Zustand aus EN-05/EN-06 festmachen kann. Danach je Konzept ein **Widerleger**
mit dem ausdrücklichen Auftrag, zu kippen statt zu bestätigen, im Zweifel `false`.

| | |
|---|---|
| vorgeschlagen | **63** |
| vom Widerleger gekippt | **31** — 49 Prozent |
| nachgetragen (Sucher hatte sie übersehen) | **4** |
| aus der Liste entfernt (keine Klausel) | **1** — `A-K10-1` |
| **Vorschlag** | **35** Klauseln aus 6 Konzepten |

**Jede der 35 Kennungen ist gegen `nachweise/klauselregister/register.json` geprüft und dort
vorhanden.** `A-K10-1` war es nicht: sie ist eine **Abweichung aus dem K00-Register**, keine
Klausel, und gehört in die Restrisikoliste. Inhaltlich ist sie zudem überholt —
`document_version` führt `version`, `erfasst_am`, `content_sha256`, gesichert vom Wächter
`document_version_unveraenderlich_trg`.

## Ein Konzept fällt ganz heraus

**K06 ist nicht dabei.** Drei Vorschläge, alle drei gekippt. K05-M19 verlangt bei
*Bin fertig mit dem Interview* die **Übergabe** des Gesprächsstands an K06 — die Übergabe ist
die Grenze von M5, nicht sein Inhalt.

## Die Liste

### Tragend — ohne sie ist M5 falsch gebaut

*30 Klauseln*

| Klausel | Worum es geht | Ausgelöst von |
|---|---|---|
| `K01-G01` | Es GILT fail-closed: Ist eine Vorbedingung nicht erfüllt oder nicht prüfbar, wird gesperrt statt zugelassen (K | Die K01-Klausel, die die Fehler- und Leerzustaende von EN-05/EN-06 wirklich traegt — der Sucher hat stattdessen faelschl |
| `K01-M01` | Eine Anwendung ist genau eine Zeile in app; app ist Aggregatswurzel, kanonische Kennung app.id. Zustand, Stufe | Die erreichte Stufe darf nicht in Sitzung, Client oder Nebentabelle liegen, sonst ueberlebt sie das Abmelden nicht. Ausg |
| `K01-M05` | Eine Anwendung fuehrt zwei Pflicht-Zustandsachsen: lifecycle_state mit acht Werten und journey_phase mit fuenf | Stufe 01 und 02 sind genau journey_phase = ORIENTIERUNG bzw. INTERVIEW. Ausgeloest von EN-05 name_bestaetigen (ORIENTIER |
| `K01-M09` | Ab Stufe 02 steht "Speichern, spaeter weitermachen" unter dem Gespraech. Der Stand muss das Abmelden ueberlebe | Woertlicher Kern von M5. Ausgeloest von EN-06 Aktion zwischenspeichern (save_interview_progress); zugleich Begruendung,  |
| `K01-M15` | Jeder Lese- und Schreibzugriff ist auf den Mandanten der angemeldeten Sitzung eingeschraenkt. Ein Objekt eines | Nach der neuen Anmeldung wird der Stand ueber den Mandantenschnitt wiedergefunden; ein fremder Mandant darf ihn nie sehe |
| `K01-M16` | Text, den ein Nutzer eingibt, diktiert oder hochlädt, MUSS als Daten behandelt werden. Eine darin enthaltene H | Verbatim-Treffer, den der Sucher uebergangen hat. EN-06 freitext_antworten berechtigung: 'der Text gilt als Daten, eine  |
| `K01-M21` | Jeder Zustandswechsel wird nachweisbar geschrieben: Zeitpunkt, Projektnummer, handelnde Instanz, Wert davor un | Der Stufenwechsel Stufe 01 auf 02 und die Uebergabe aus Stufe 02 muessen mit Vorher/Nachher in event stehen; der juengst |
| `K02-D01` | Ein Protokolleintrag DARF NICHT geaendert werden. Zwei Regeln am Bestand lassen jeden Aenderungsversuch wirkun | Nur weil kein Eintrag nachtraeglich verschiebbar ist, bestimmt der juengste Eintrag verlaesslich den Stand beim Weiterma |
| `K02-D04` | Ein Schreibvorgang DARF NICHT gelten, wenn sein Protokolleintrag ausbleibt. Beides entsteht gemeinsam oder gar | Die Fehlerzustaende von confirm_app_name und complete_interview verlangen woertlich vollstaendigen Ruecklauf ohne Teilwe |
| `K02-M12` | Jeder Schreibvorgang auf einem fachlichen Objekt MUSS genau einen Protokolleintrag erzeugen. | Alle neun schreibenden Aktionen von EN-05/EN-06 (record_topic, record_classification, record_goals, confirm_initial_prob |
| `K02-M13` | Jeder Protokolleintrag MUSS Zeitpunkt, Aktion und Quelle tragen. Ohne diese drei Angaben entsteht kein Eintrag | Der wiederaufnehmbare Stand wird ueber den juengsten event-Eintrag bestimmt (K05-M26); ohne occurred_at und action gibt  |
| `K02-M14` | Die Quelle MUSS einen von zwei Werten fuehren: Portal-Aktion oder Modell-Aenderung. Ein dritter Wert ist nicht | EN-05 und EN-06 schreiben source = PORTAL_ACTION woertlich vor; jede Nutzeraktion der beiden Bildschirme protokolliert m |
| `K02-M20` | Die Mandantengrenze MUSS zweifach durchgesetzt werden — im Serverpfad und im Datenbestand, nach K13 Abschn. 3. | Uebersehen und klar tragend. Die Klausel fordert die Mandantengrenze zweifach — im Serverpfad UND im Datenbestand — und  |
| `K02-M21` | Bei mandantengebundenem Schreibvorgang MUSS event.tenant_id gesetzt sein und mit Mandant der Sitzung, des Fach | Nach Abmelden und Neuanmelden ist die Sitzung neu; der Eintrag zur Wiederaufnahme muss weiterhin denselben Mandanten fue |
| `K02-M22` | event.value und event.object_ref MUESSEN auf den Nachweisumfang begrenzt sein; Geheimnisse, vollstaendige Doku | zwischenspeichern legt in object_ref genau Dokumentkennung und Hash ab, nicht den Protokollinhalt; Freitextantworten und |
| `K04-G04` | Es gilt fail-closed: ist das Ergebnis OFFEN, fehlt eine Antwort oder ist der Check nicht lesbar, wird gesperrt | Findet der Serverbefehl zum app-Datensatz keinen lesbaren Check mit GEEIGNET, muss record_topic (und jede Folgeaktion in |
| `K04-M11` | Das Ergebnis steht in fit_check.outcome und fuehrt genau einen der Werte OFFEN, GEEIGNET, NICHT_GEEIGNET; Vorg | Die Vorbedingung von Stufe 01 wird ausschliesslich an diesem Feld gelesen: jede EN-05-Aktion (record_topic, record_class |
| `K10-M01` | Jedes Dokument besteht als genau eine Zeile in document und ist einer Anwendung zugeordnet; ohne Anwendung ent | Der INTERVIEW_PROTOCOL-Stand ist ein Dokument im Sinne K10. Ausgeloest von thema_waehlen (Erfolg: Beitrag im INTERVIEW_P |
| `K10-M02` | Jede Zeile traegt eine Dokumentart aus der geschlossenen Liste; sieben Werte sind vorgesehen, ein achter entst | Der Gespraechsstand darf nur unter dem Wert INTERVIEW_PROTOCOL abgelegt werden -- der einzige der sieben Werte, der in K |
| `K10-M03` | Jede Zeile traegt einen Dateinamen; ein Eintrag ohne Datei ist kein Dokument, sondern ein Fehler. | Der Dreischritt Datei -> document-Zeile -> event ist genau in dieser Reihenfolge zu bauen: eine document-Zeile ohne dahi |
| `K13-M05` | Jeder Aufruf aus einer Oberflaeche laeuft ueber den Serverpfad; er prueft aktives Konto, Mitgliedschaft, Rolle | Alle elf Aktionen von EN-05/EN-06 nennen genau diese Pruefkette als berechtigung; sie ist der einzige Weg, auf dem recor |
| `K13-M08` | Die Mandantengrenze MUSS zweifach durchgesetzt werden: im Serverpfad durch Autorisierung und im Datenbestand d | Uebersehen. Die berechtigung von vorschlag_waehlen (Serverbefehl record_interview_answer, die zentrale Schreibaktion der |
| `K13-M09` | Anlegen einer Anwendung und jeder Zustandswechsel laufen ueber die serverseitigen Befehle nach K01 Abschn. 3;  | name_bestaetigen setzt app.journey_phase von ORIENTIERUNG auf INTERVIEW, interview_beenden auf UEBERSICHT — beide ausdru |
| `K13-M10` | Jeder Schreibvorgang erzeugt einen Protokolleintrag. Traeger ist event mit event_source (Eigentuemer K02); K13 | zwischenspeichern schreibt den Dreischritt Datei, document-Zeile, event; der juengste event-Eintrag ist genau das, was d |
| `K13-M13` | Jede Schnittstelle besitzt einen benannten Fehlerfall, der sperrt statt durchzulassen. Ein unbeantworteter ode | Jede der elf Aktionen fuehrt einen eigenen zustand_fehler, der abweist statt weiterzulassen — etwa 'Reihenfolge verletzt |
| `K13-M20` | Fachliche Aenderung und Auditnachweis entstehen atomar. Wo keine gemeinsame Transaktion moeglich ist, wird ein | Die Fehlerzustaende von zwischenspeichern, name_bestaetigen und interview_beenden verlangen, dass ein unvollstaendiger D |
| `K19-D09` | Keine bedienbare Schaltflaeche fuer einen Vorgang, dessen Vorbedingung nicht erfuellt oder nicht pruefbar ist. | Fail-closed am Einstieg und an jedem Stufenschritt: thema_waehlen setzt einen fit_check mit outcome GEEIGNET voraus, aus |
| `K19-G03` | Herkunft ist sichtbar getrennt: KI-Vorschlag auf EN-05, KI-Notiz gegen eigene Angabe auf EN-06. | Nennt EN-05 und EN-06 woertlich und ist die K19-Seite zu K05-M11. Ausgeloest von name_bestaetigen (Marke KI-Vorschlag, o |
| `K19-M06` | Ist die Bedingung vom Nutzer selbst erfuellbar, wird die Schaltflaeche ausgeblendet; an ihrer Stelle steht ein | Einzige K19-Klausel, die EN-05/EN-06 namentlich zitieren -- achtmal. Sie regelt den Zustand leer aller elf Aktionen: bei |
| `K19-M14` | Jede Aktion fuehrt Eingabe, Serverbefehl, Berechtigungspruefung sowie Lade-, Leer-, Erfolgs- und Fehlerzustand | Ist der Bauvertrag der elf Aktionen selbst: Jede der elf Zeilen in EN-05/EN-06 traegt genau diese sieben Felder, und der |

### Mitwirkend — gilt, ist aber nicht der Kern

*5 Klauseln*

| Klausel | Worum es geht | Ausgelöst von |
|---|---|---|
| `K01-G09` | Zweiteilung der Sperren: ausgeblendet mit Hinweis an Stelle der Schaltflaeche, wo der Nutzer die Bedingung sel | Die Leerzustaende von EN-05 setzen genau die erste Haelfte um. Ausgeloest von ziele_waehlen und ausgangsproblem_bestaeti |
| `K01-M07` | Jeder Bildschirm mit Gespraech ist zweigeteilt: links wird gesagt oder geklickt, rechts erscheint das Ergebnis | Der rechte Spaltenstand ist das, was nach der Wiederanmeldung wieder dastehen muss. Ausgeloest von praktisch jedem Leer- |
| `K01-M17` | Vor jeder Uebergabe an ein Sprachmodell muessen personenbezogene Angaben maskiert werden; die Rueckaufloesung  | Stufe 02 ruft bei jeder Freitextantwort ein Modell; ohne vollstaendige Maskierung unterbleibt der Aufruf. Ausgeloest von |
| `K02-M15` | Bei einer Aenderung MUSS der Eintrag Wert vorher und Wert jetzt tragen; bei einer Neuanlage den Anfangswert. | Der Stufenwechsel ORIENTIERUNG auf INTERVIEW (confirm_app_name) und INTERVIEW auf UEBERSICHT (complete_interview) sind A |
| `K13-M22` | Jeder Modellpfad ist an Deployment-ID, Anbieter, Region, Netzwerk- und Policyversion, Zweck, Datenminimum, Fre | freitext_antworten macht den unvollstaendigen Modellpfad ausdruecklich zum Fehlerfall ohne Aufruf; der Namensvorschlag i |

## Was diese Liste nicht sagt

- **Ob die 56 K05-Klauseln vollständig gelten.** EN-05/EN-06 nennen davon **31** mit Kennung.
  Die übrigen 25 sind nicht geprüft — sie können andere Bildschirme betreffen.
- **Ob die Gewichtung stimmt.** *tragend* gegen *mitwirkend* ist ein Vorschlag, kein Befund.
- **Die Akzeptanzkriterien.** Blatt 100, Entscheidung 5: sie kommen vor dem Bauzug und werden
  gezeichnet. Diese Liste ist ihre Grundlage, nicht ihr Ersatz.
