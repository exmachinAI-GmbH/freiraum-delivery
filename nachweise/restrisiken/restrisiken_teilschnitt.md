# Restrisiken des Teilschnitts · **Vorschlag zur Zeichnung**

> **Dieses Blatt entscheidet nichts.** Es bereitet je Klausel eine Zeile vor. Die Spalten
> **Träger**, **Annahmeentscheidung** und **Frist** sind absichtlich leer — sie füllt ein
> Mensch aus. Ein Feld, das aussieht wie entschieden, wäre schlimmer als ein leeres.

| Feld | Wert |
|---|---|
| **Grundlage** | `K23-M04` und `K23-D07` — eine Klausel ohne belegenden Test wird **einzeln** mit Träger, Kritikalität und Annahmeentscheidung aufgeführt. **Eine Abdeckungsquote ersetzt diese Liste nicht** (F34) |
| **Anlass** | Zeichnung **B-5** vom 16.08.2026, Punkt 5 der Grenze: *„Für die kritischen Klauseln je einen Eintrag in der Restrisikoliste vorbereiten — mit leerem Träger und leerer Annahmeentscheidung“* |
| **Ausschnitt** | der **Teilschnitt bis zur Anmeldung**, gezeichnet am 10.08.2026 (Blatt 57, Zeile 122, A. Han und M. Veil) |
| **Einträge** | **113** |
| **davon in einer sperrenden Klasse** | **113** — dort ersetzt **keine** Annahmeentscheidung den Test |
| **Träger eingetragen** | **0 von 113** |
| **Annahmeentscheidungen gezeichnet** | **0 von 113** |
| **Wer liefert das Fehlende** | **M. Veil** zeichnet die Annahmeentscheidungen mit Träger und Frist (Zeichnung B-5, *„Was danach noch bei einem Menschen liegt“*, Zeile 2). Für die 113 sperrenden Einträge liefert statt dessen der **Prüf-Agent** den fehlenden Prüffall — eine Annahme genügt dort nicht |
| **Erzeugt am** | 2026-08-16, maschinell aus Klauselschnitt, Triage und Klauselregister |

---

## Wie der Ausschnitt bestimmt wurde — der Weg, nachrechenbar

Der Teilschnitt ist im Wortlaut gezeichnet: *„Der Weg **bis zur Anmeldung**: Mandant
anlegen · Einladungsschranke · Einladung über den echten Mailweg · Anmeldecode ·
Anmeldung“* (Blatt 57, Zeile 122; wiedergegeben in `nachweise/meldungen/VERZUG_260814.md`,
Zeilen 77–80). Diese fünf Namen sind zugleich fünf Stationen des Stichwortverzeichnisses
`nachweise/klauselschnitt/S1_wortmarken.json`.

| Schritt | Quelle | Klauseln |
|---|---|---:|
| 1 · Die fünf Stationen des Teilschnitts, Vereinigungsmenge | `S1_wortmarken.json` | **152** |
| 2 · **plus** die Regeln der Bauspur, die kein Stationswort trifft | `S1_zeichnung.md` Block 1a/1b, gegengeprüft in `S1_bauspur_nachpruefung.md` | **+5** |
| **= Ausschnitt** | | **157** |
| 3 · davon **kritisch** nach Triage-Vorschlag | `triage.json` | 125 |
| 4 · davon **ohne Prüffall** | `triage.json`, Feld `prueffaelle` | **113** |

**Zur gezeichneten Zahl 167.** Das Kreuz 7.2 vom 15.08.2026 nennt den Umfang von
Bedingung 4 mit **167 Regeln** = 152 Stationswörter + 5 Bauspur + **10 von Prüffällen
genannte**. Die zehn zusätzlich genannten Regeln **haben einen Prüffall** — sie sind
deshalb hier ohnehin keine Restrisiken und ändern an der Zahl **113** nichts. Die
Auswahl steht damit auf 152 + 5 = **157** Klauseln.

**Was hier nicht steht:** kein Akzeptanzkriterium (K23-M02 — das liefert der fachliche
Eigentümer), keine Quote (F34), keine Aussage darüber, ob eine Klausel erfüllt ist.

---

## Was die Spalten bedeuten

| Spalte | Bedeutung |
|---|---|
| **Kennung** | laufende Nummer dieses Blattes. Sie ersetzt die Klauselkennung nicht |
| **Wortlaut in Kürze** | gekürzt zum Wiedererkennen. **Es gilt der volle Wortlaut** im Klauselregister und in der Quelle |
| **Kritikalität** | **Vorschlag der Triage**, keine Feststellung. Daneben steht das Wort, das ihn ausgelöst hat — wer es nicht mitträgt, streicht die Zeile |
| **⛔** | gesetzt, wenn die Klausel in eine der fünf Klassen aus `K23-M04` fällt. Dort **sperrt der fehlende Test die Freigabe**; eine Annahmeentscheidung genügt nicht |
| **Träger** | **leer.** Träger sind Menschen |
| **Annahme** | **leer.** Die Annahmeentscheidung zeichnet M. Veil |
| **Frist** | **leer.** Sie gehört zur Annahmeentscheidung |

**Achtung zur Spalte Kritikalität.** Die Triage ordnet über einen Worttreffer im Wortlaut
ein. Ein Worttreffer belegt, dass ein Wort dasteht — nicht, dass die Sache zutrifft. Die
Belegstelle steht deshalb in jeder Zeile. **Eine Kritikalität herabzustufen ist untersagt**
(`K23-D05`, `K23-G08`); wer eine Zeile für falsch eingeordnet hält, vermerkt das und legt
es vor, statt sie zu senken.

---

## Die Einträge

### K01 — 8 Einträge, davon 8 sperrend

| Kennung | Klausel | Art | Wortlaut in Kürze | Kritikalität (Triage-**Vorschlag**) | Auslösendes Wort | ⛔ | Träger | Annahme | Frist |
|---|---|---|---|---|---|:-:|---|---|---|
| RR-T-001 | **K01-D08** | DARF NICHT | Kein Bildschirm, keine Liste, keine Ausleitung und keine Modellanfrage DARF Daten zweier Mandanten zusammenführen. Auch verdichtete Kennzahlen über … | mandanten · *Vorschlag* | mandanten (Wort „Mandanten“) | **⛔** | | | |
| RR-T-002 | **K01-M02** | MUSS | Jede Zeile in `app` MUSS einen Mandanten tragen (`tenant_id`, Pflicht, Verweis auf `tenant` — Eigentümer K02). Ein Mandant mit mindestens einer … | mandanten, aufbewahrungs · *Vorschlag* | mandanten (Wort „Mandanten“); aufbewahrungs (Wort „löschbar“) | **⛔** | | | |
| RR-T-003 | **K01-M14** | MUSS | Der zweite Faktor MUSS ein Code per E-Mail sein; `mfa_method` kennt EMAIL_CODE und den Ausschaltwert OFF. Ein anderes Verfahren ist im Rahmen nicht … | sicherheits · *Vorschlag* | sicherheits (Wort „zweite Faktor“) | **⛔** | | | |
| RR-T-004 | **K01-M15** | MUSS | Jeder Lese- und Schreibzugriff MUSS auf den Mandanten der angemeldeten Sitzung eingeschränkt sein. Ein Objekt eines fremden Mandanten gilt als nicht … | mandanten · *Vorschlag* | mandanten (Wort „Mandanten“) | **⛔** | | | |
| RR-T-005 | **K01-M23** | MUSS | Jeder Kunde MUSS genau einen Rechtsraum aus `legal_space` tragen, und die Verarbeitung MUSS in der EU stattfinden, Vorgabe `swedencentral` (F05). … | mandanten · *Vorschlag* | mandanten (Wort „Mandanten“) | **⛔** | | | |
| RR-T-006 | **K01-M26** | MUSS | Eine Anwendung MUSS einem Mandanten mit `legal_space = DE` gehören. Nur er legt in Release 1 eine Anwendung an (F35); das Muster von `project_no` mit … | mandanten · *Vorschlag* | mandanten (Wort „Mandanten“) | **⛔** | | | |
| RR-T-007 | **K01-M30** | MUSS | Vor jeder Exposition über eine Supabase Data API MÜSSEN RLS-Policies für SELECT, INSERT, UPDATE und DELETE aktiv sein. Sie prüfen aktives Konto, … | mandanten · *Vorschlag* | mandanten (Wort „Mandant“) | **⛔** | | | |
| RR-T-008 | **K01-M35** | MUSS | Die drei Großbuchstaben MÜSSEN der Kunden-Code des tragenden Mandanten sein (Eigentümer K02). Die Projektnummer bildet keinen eigenen Buchstabencode. | mandanten · *Vorschlag* | mandanten (Wort „Mandanten“) | **⛔** | | | |

### K02 — 30 Einträge, davon 30 sperrend

| Kennung | Klausel | Art | Wortlaut in Kürze | Kritikalität (Triage-**Vorschlag**) | Auslösendes Wort | ⛔ | Träger | Annahme | Frist |
|---|---|---|---|---|---|:-:|---|---|---|
| RR-T-009 | **K02-D03** | DARF NICHT | Ein Mandant DARF NICHT physisch entfernt werden. Das Entfernen ist ein Zeitstempel, nicht das Tilgen der Zeile. | mandanten · *Vorschlag* | mandanten (Wort „Mandant“) | **⛔** | | | |
| RR-T-010 | **K02-D05** | DARF NICHT | Ein Bestand eines fremden Mandanten DARF NICHT sichtbar, zählbar oder verdichtet erreichbar sein. Er gilt als nicht vorhanden. | mandanten · *Vorschlag* | mandanten (Wort „Mandanten“) | **⛔** | | | |
| RR-T-011 | **K02-D07** | DARF NICHT | Ein Mandant DARF NICHT ohne Rechtsraum bestehen. Ein leeres Feld ist kein zulässiger Übergangszustand. | mandanten · *Vorschlag* | mandanten (Wort „Mandant“) | **⛔** | | | |
| RR-T-012 | **K02-D08** | DARF NICHT | Die Protokollsicht DARF NICHT technische Schlüssel oder Bestände fremder Mandanten zeigen. | sicherheits, mandanten · *Vorschlag* | sicherheits (Wort „Schlüssel“); mandanten (Wort „Mandanten“) | **⛔** | | | |
| RR-T-013 | **K02-D09** | DARF NICHT | Ein Mandant DARF NICHT entfernt werden, solange ein Konto auf ihn verweist. Die Löschsperre am Verweis hält ihn fest. | mandanten · *Vorschlag* | mandanten (Wort „Mandant“) | **⛔** | | | |
| RR-T-014 | **K02-D10** | DARF NICHT | Der Kunden-Code DARF NICHT eingegeben, gewählt oder aus dem Namen des Mandanten abgeleitet werden. | mandanten · *Vorschlag* | mandanten (Wort „Mandanten“) | **⛔** | | | |
| RR-T-015 | **K02-D11** | DARF NICHT | Ein Code des Namensraums `DE-Z..` DARF NICHT an einen Mandanten vergeben werden, der echte Kundendaten führt. | mandanten · *Vorschlag* | mandanten (Wort „Mandanten“) | **⛔** | | | |
| RR-T-016 | **K02-D12** | DARF NICHT | Ein Mandant der Art Betreiber oder Kunde DARF NICHT ein solches Kennzeichen tragen. | mandanten · *Vorschlag* | mandanten (Wort „Mandant“) | **⛔** | | | |
| RR-T-017 | **K02-G05** | GILT | Es GILT: Die Verarbeitungsregion ist eine Eigenschaft der Plattform je Mandant, nicht eine Einstellung des einzelnen Nutzers. | mandanten · *Vorschlag* | mandanten (Wort „Mandant“) | **⛔** | | | |
| RR-T-018 | **K02-G06** | GILT | Es GILT: Einladungsfrist und Einladungsschranke stehen am Mandanten, weil sie Eigenschaften der einladenden Organisation sind. Das Verfahren dahinter … | mandanten · *Vorschlag* | mandanten (Wort „Mandanten“) | **⛔** | | | |
| RR-T-019 | **K02-G10** | GILT | Es GILT: Die Währung steht an der Anwendung, nicht am Mandanten (Eigentümer K01). K02 führt sie nicht. | mandanten · *Vorschlag* | mandanten (Wort „Mandanten“) | **⛔** | | | |
| RR-T-020 | **K02-G11** | GILT | Es GILT: Ein Protokolleintrag überlebt seinen Bezug. Entfällt die Anwendung oder der Mandant, bleibt der Eintrag bestehen und verliert nur den … | mandanten · *Vorschlag* | mandanten (Wort „Mandant“) | **⛔** | | | |
| RR-T-021 | **K02-G12** | GILT | Es GILT: Bis O-K02-6 und die Datenbestandsregeln aus K13 belegt sind, bleibt das Schema server-only. Ein mandantengebundener Vorgang ohne auflösbaren … | mandanten · *Vorschlag* | mandanten (Wort „Mandantenbezug“) | **⛔** | | | |
| RR-T-022 | **K02-G14** | GILT | Es GILT: Der Kunden-Code trägt keine Bedeutung. Lesbar ist der Name des Mandanten; der Code ist ein Bezug, kein Kürzel. | mandanten · *Vorschlag* | mandanten (Wort „Mandanten“) | **⛔** | | | |
| RR-T-023 | **K02-G16** | GILT | Es GILT: Ein Mandant, dessen Code mit `Z` beginnt, ist ein Testmandant. Das Merkmal steht im Code selbst; ein zusätzliches Feld entsteht dafür nicht. | mandanten · *Vorschlag* | mandanten (Wort „Mandant“) | **⛔** | | | |
| RR-T-024 | **K02-G17** | GILT | Es GILT: K02-M30 greift nicht für Testmandanten des reservierten Namensraums. Die Ausnahme setzt voraus, dass dort keine echten Personendaten stehen; … | freigabe · *Vorschlag* | freigabe (Wort „Freigabe“) | **⛔** | | | |
| RR-T-025 | **K02-M02** | MUSS | Jeder Mandant MUSS eine Art tragen: Betreiber, Kunde oder Partner. Ein vierter Wert ist nicht vorgesehen. | mandanten · *Vorschlag* | mandanten (Wort „Mandant“) | **⛔** | | | |
| RR-T-026 | **K02-M03** | MUSS | Jeder Mandant MUSS einen Namen tragen. Das Feld ist Pflicht und wird in der Oberfläche als Firmenname geführt. | mandanten · *Vorschlag* | mandanten (Wort „Mandant“) | **⛔** | | | |
| RR-T-027 | **K02-M04** | MUSS | Ein Mandant der Art Kunde MUSS einen Kunden-Code tragen. Durchgesetzt von der Bedingung `customer_needs_code`. | mandanten · *Vorschlag* | mandanten (Wort „Mandant“) | **⛔** | | | |
| RR-T-028 | **K02-M06** | MUSS | Der Kunden-Code MUSS plattformweit eindeutig sein. Zwei Mandanten teilen ihn nie. | mandanten · *Vorschlag* | mandanten (Wort „Mandanten“) | **⛔** | | | |
| RR-T-029 | **K02-M07** | MUSS | Jeder Mandant MUSS einen Rechtsraum tragen. Für Release 1 ist allein DE zulässig (F35); die übrigen Werte bleiben modelliert. | mandanten · *Vorschlag* | mandanten (Wort „Mandant“) | **⛔** | | | |
| RR-T-030 | **K02-M08** | MUSS | Jeder Mandant MUSS eine Verarbeitungsregion tragen. Vorgabe ist `swedencentral`; Release 1 verarbeitet ausschließlich dort (K13 Abschn. 3). | mandanten · *Vorschlag* | mandanten (Wort „Mandant“) | **⛔** | | | |
| RR-T-031 | **K02-M09** | MUSS | Jeder Mandant MUSS eine organisationsweite Richtlinie zur zweiten Anmeldestufe tragen. Vorgabe ist der Code per E-Mail; das Verfahren führt K03. | mandanten · *Vorschlag* | mandanten (Wort „Mandant“) | **⛔** | | | |
| RR-T-032 | **K02-M20** | MUSS | Die Mandantengrenze MUSS zweifach durchgesetzt werden — im Serverpfad und im Datenbestand, nach K13 Abschn. 3. | mandanten · *Vorschlag* | mandanten (Wort „Mandantengrenze“) | **⛔** | | | |
| RR-T-033 | **K02-M21** | MUSS | Bei einem mandantengebundenen Schreibvorgang MUSS `event.tenant_id` gesetzt sein und mit Mandant der Sitzung, des Fachobjekts und der Projektnummer … | mandanten · *Vorschlag* | mandanten (Wort „Mandant“) | **⛔** | | | |
| RR-T-034 | **K02-M23** | MUSS | Jede Protokollausfuhr MUSS serverseitig erneut autorisiert werden, ausschließlich die gefilterte Mandantenmenge mit fester Spaltenliste liefern und … | mandanten · *Vorschlag* | mandanten (Wort „Mandantenmenge“) | **⛔** | | | |
| RR-T-035 | **K02-M26** | MUSS | Die Vergabe MUSS serverseitig und in derselben Transaktion wie die Anlage des Mandanten erfolgen. Schlägt sie fehl, entsteht kein Mandant. | mandanten · *Vorschlag* | mandanten (Wort „Mandanten“) | **⛔** | | | |
| RR-T-036 | **K02-M29** | MUSS | Ein Mandant der Art Kunde MUSS den Nachweis des hinterlegten Auftragsverarbeitungsvertrags führen: Zeitpunkt der Hinterlegung und Aktenzeichen der … | mandanten · *Vorschlag* | mandanten (Wort „Mandant“) | **⛔** | | | |
| RR-T-037 | **K02-M30** | MUSS | Ohne hinterlegten Vertrag MUSS der Beginn eines Gesprächs für diesen Mandanten serverseitig abgelehnt werden. Die Prüfung liegt im Serverpfad, nicht … | mandanten · *Vorschlag* | mandanten (Wort „Mandanten“) | **⛔** | | | |
| RR-T-038 | **K02-M31** | MUSS | Ein Mandant der Art Partner MUSS erkennen lassen, ob er die Anwendung **baut**, sie beim Kunden **umsetzt**, oder beides. **Das Datenmodell führt … | mandanten · *Vorschlag* | mandanten (Wort „Mandant“) | **⛔** | | | |

### K03 — 16 Einträge, davon 16 sperrend

| Kennung | Klausel | Art | Wortlaut in Kürze | Kritikalität (Triage-**Vorschlag**) | Auslösendes Wort | ⛔ | Träger | Annahme | Frist |
|---|---|---|---|---|---|:-:|---|---|---|
| RR-T-039 | **K03-D04** | DARF NICHT | Ein anderer zweiter Faktor als der Code per E-Mail DARF NICHT angeboten werden, auch nicht Verwaltenden. | sicherheits · *Vorschlag* | sicherheits (Wort „zweiter Faktor“) | **⛔** | | | |
| RR-T-040 | **K03-D05** | DARF NICHT | Der zweite Faktor DARF im Endnutzer-Portal NICHT umstellbar sein. Der Bereich Sicherheit zeigt ihn, ohne ihn zur Auswahl zu stellen. | sicherheits · *Vorschlag* | sicherheits (Wort „Sicherheit“) | **⛔** | | | |
| RR-T-041 | **K03-D10** | DARF NICHT | Der zweite Faktor DARF NICHT abgeschaltet werden. Der abschaltende Wert von `mfa_method` ist in Release 1 kein zulässiger Betriebszustand — weder am … | sicherheits, mandanten · *Vorschlag* | sicherheits (Wort „zweite Faktor“); mandanten (Wort „Mandanten“) | **⛔** | | | |
| RR-T-042 | **K03-G03** | GILT | Es GILT: Die organisationsweite Richtlinie zur zweiten Stufe liegt am Mandanten (Eigentümer K02, dort Abschn. 3). K03 führt das Verfahren, nicht das … | mandanten · *Vorschlag* | mandanten (Wort „Mandanten“) | **⛔** | | | |
| RR-T-043 | **K03-G06** | GILT | Es GILT: `actor` trägt kein Kennwort. Anmeldename ist die Adresse, zweiter Faktor der Code; ein dritter Nachweis fehlt (O-K03-5). | sicherheits · *Vorschlag* | sicherheits (Wort „zweiter Faktor“) | **⛔** | | | |
| RR-T-044 | **K03-G12** | GILT | Der E-Mail-Code wird in Oberfläche, Dokumentation und Nachweis als **E-Mail-Code** bezeichnet. K03 erhebt keinen Anspruch auf unabhängige MFA, aal2 … | sicherheits, freigabe · *Vorschlag* | sicherheits (Wort „MFA“); freigabe (Wort „Freigabe“) | **⛔** | | | |
| RR-T-045 | **K03-M02** | MUSS | Jede Zeile in `actor` MUSS einen Mandanten tragen (`tenant_id`, Verweis auf `tenant` — Eigentümer K02). | mandanten · *Vorschlag* | mandanten (Wort „Mandanten“) | **⛔** | | | |
| RR-T-046 | **K03-M07** | MUSS | Der Einmal-Link MUSS nach 24 Stunden verfallen (F11). Die Frist steht am Mandanten (Eigentümer K02), der Einladungssatz gehört K20. | sicherheits, mandanten · *Vorschlag* | sicherheits (Wort „Einmal-Link“); mandanten (Wort „Mandanten“) | **⛔** | | | |
| RR-T-047 | **K03-M12** | MUSS | Eine heikle Änderung MUSS eine erneute Anmeldung verlangen, bevor sie wirksam wird. Die Anzeige dazu führt K16. | sicherheits · *Vorschlag* | sicherheits (Wort „Anmeldung“) | **⛔** | | | |
| RR-T-048 | **K03-M18** | MUSS | E-Mail-Adresse, Authentifizierungsverfahren, Rolle, Mitgliedschaft, Portalzuordnung, Entsperrung und Freigabeberechtigung gelten als heikle … | sicherheits, freigabe · *Vorschlag* | sicherheits (Wort „Authentifizierungsverfahren“); freigabe (Wort „Freigabeberechtigung“) | **⛔** | | | |
| RR-T-049 | **K03-M19** | MUSS | *(berichtigt nach Beschluss S28 vom 02.08.2026)* Geprüft wird die Einladungsschranke des Mandanten, zu dem das **eingeladene Konto** gehört — nicht … | sicherheits, mandanten · *Vorschlag* | sicherheits (Wort „Einmal-Link“); mandanten (Wort „Mandanten“) | **⛔** | | | |
| RR-T-050 | **K03-M21** | MUSS | Replay, Brute Force, Konto-Ermittlung, Sitzungsfixierung, parallele Anmeldung, fremder Mandant und Provider-Ausfall MÜSSEN vor Produktion als … | sicherheits, mandanten, wiederherstellungs · *Vorschlag* | sicherheits (Wort „Anmeldung“); mandanten (Wort „Mandant“); wiederherstellungs (Wort „Ausfall“) | **⛔** | | | |
| RR-T-051 | **K03-M22** | MUSS | Die Einladungsschranke setzt allein der Betreiber, indem er den Mandanten anlegt. Bei jeder Anlage MUSS über sie entschieden werden: entweder die … | mandanten · *Vorschlag* | mandanten (Wort „Mandanten“) | **⛔** | | | |
| RR-T-052 | **K03-M25** | MUSS | Ein serverseitiger, idempotenter Einladungsbefehl prüft Zielmandant, Entscheidungsnachweis und Domäne und legt Einladung und Ereignis atomar an. … | sicherheits, wiederherstellungs · *Vorschlag* | sicherheits (Wort „Schlüssel“); wiederherstellungs (Wort „idempotenter“) | **⛔** | | | |
| RR-T-053 | **K03-M26** | MUSS | Der Versand nutzt verwaltete Identität oder Secret-Referenz, eine erlaubte Ausgangsverbindung und datensparsame Telemetrie. Codes und vollständige … | sicherheits · *Vorschlag* | sicherheits (Wort „fail-closed“) | **⛔** | | | |
| RR-T-054 | **K03-M27** | MUSS | Die Abnahme prüft mindestens: bewusst unbeschränkt, fehlender Nachweis, exakte Domäne, Groß-/Kleinschreibung, idna, Suffixverwechslung, Subdomäne, … | freigabe · *Vorschlag* | freigabe (Wort „Abnahme“) | **⛔** | | | |

### K04 — 3 Einträge, davon 3 sperrend

| Kennung | Klausel | Art | Wortlaut in Kürze | Kritikalität (Triage-**Vorschlag**) | Auslösendes Wort | ⛔ | Träger | Annahme | Frist |
|---|---|---|---|---|---|:-:|---|---|---|
| RR-T-055 | **K04-D08** | DARF NICHT | Ein Eignungs-Check eines fremden Mandanten DARF NICHT sichtbar oder änderbar sein; er gilt als nicht vorhanden (Mandantenschnitt K02). | mandanten · *Vorschlag* | mandanten (Wort „Mandanten“) | **⛔** | | | |
| RR-T-056 | **K04-M10** | MUSS | Jeder Eignungs-Check MUSS einen Mandanten tragen: `fit_check.tenant_id` ist Pflicht, Verweis auf `tenant` (Eigentümer K02) mit Löschsperre. | mandanten · *Vorschlag* | mandanten (Wort „Mandanten“) | **⛔** | | | |
| RR-T-057 | **K04-M18** | MUSS | Der Server MUSS Ergebnis, drei aktive Antworten und Mandant unmittelbar vor der Anlage erneut lesen. Ein veralteter Bildschirmstand berechtigt nicht … | mandanten · *Vorschlag* | mandanten (Wort „Mandant“) | **⛔** | | | |

### K05 — 2 Einträge, davon 2 sperrend

| Kennung | Klausel | Art | Wortlaut in Kürze | Kritikalität (Triage-**Vorschlag**) | Auslösendes Wort | ⛔ | Träger | Annahme | Frist |
|---|---|---|---|---|---|:-:|---|---|---|
| RR-T-058 | **K05-M24** | MUSS | Jeder Aufruf aus den Stufen 01 und 02 MUSS über den Serverpfad laufen, der Konto, Mitgliedschaft, Rolle, Mandant und Objektbezug prüft (K13 Abschn. … | mandanten · *Vorschlag* | mandanten (Wort „Mandant“) | **⛔** | | | |
| RR-T-059 | **K05-M27** | MUSS | RLS und Serverpfad leiten den Mandanten ausschließlich über `document.app_id → app.tenant_id` ab. Dateiobjekte verwenden nicht erratbare Schlüssel … | sicherheits, mandanten · *Vorschlag* | sicherheits (Wort „Schlüssel“); mandanten (Wort „Mandanten“) | **⛔** | | | |

### K06 — 1 Einträge, davon 1 sperrend

| Kennung | Klausel | Art | Wortlaut in Kürze | Kritikalität (Triage-**Vorschlag**) | Auslösendes Wort | ⛔ | Träger | Annahme | Frist |
|---|---|---|---|---|---|:-:|---|---|---|
| RR-T-060 | **K06-M26** | MUSS | Jeder Aufruf der Stufe 03 MUSS über den Serverpfad laufen, der Konto, Mitgliedschaft, Rolle, Mandant und Objektbezug prüft (K13 Abschn. 3). | mandanten · *Vorschlag* | mandanten (Wort „Mandant“) | **⛔** | | | |

### K07 — 6 Einträge, davon 6 sperrend

| Kennung | Klausel | Art | Wortlaut in Kürze | Kritikalität (Triage-**Vorschlag**) | Auslösendes Wort | ⛔ | Träger | Annahme | Frist |
|---|---|---|---|---|---|:-:|---|---|---|
| RR-T-061 | **K07-D08** | DARF NICHT | Ein Bestand eines fremden Mandanten DARF NICHT sichtbar oder ladbar sein; er gilt als nicht vorhanden. | mandanten · *Vorschlag* | mandanten (Wort „Mandanten“) | **⛔** | | | |
| RR-T-062 | **K07-M12** | MUSS | Jeder Direkt-Prototyp MUSS einen Mandanten tragen; der Verweis hält den Mandanten mit einer Löschsperre fest. | mandanten · *Vorschlag* | mandanten (Wort „Mandanten“) | **⛔** | | | |
| RR-T-063 | **K07-M19** | MUSS | Jede Änderung läuft als revisionsgebundener, idempotenter Server-Command. Er prüft angemeldetes Konto, Mandant, erwartete Revision und den erlaubten … | mandanten, wiederherstellungs · *Vorschlag* | mandanten (Wort „Mandant“); wiederherstellungs (Wort „idempotenter“) | **⛔** | | | |
| RR-T-064 | **K07-M22** | MUSS | Laden, Teilen und Entfernen prüfen bei jedem Aufruf serverseitig Konto, Mandant und Objektstatus. Ablage und Metadaten sind privat und RLS-geschützt; … | mandanten · *Vorschlag* | mandanten (Wort „Mandant“) | **⛔** | | | |
| RR-T-065 | **K07-M23** | MUSS | Teilen verwendet keinen direkt ausgegebenen Storage-Link, sondern einen serververmittelten, zufälligen, objekt- und mandantengebundenen … | mandanten, freigabe · *Vorschlag* | mandanten (Wort „mandantengebundenen“); freigabe (Wort „Freigabezugang“) | **⛔** | | | |
| RR-T-066 | **K07-M28** | MUSS | Vor Produktion bestehen revisionsgebundene Negativtests für Mandantentrennung, Linkablauf/-widerruf, Parallelität, Prompt Injection, UI-Scope, … | mandanten, aufbewahrungs, wiederherstellungs · *Vorschlag* | mandanten (Wort „Mandantentrennung“); aufbewahrungs (Wort „Retention“); wiederherstellungs (Wort „Restore“) | **⛔** | | | |

### K08 — 2 Einträge, davon 2 sperrend

| Kennung | Klausel | Art | Wortlaut in Kürze | Kritikalität (Triage-**Vorschlag**) | Auslösendes Wort | ⛔ | Träger | Annahme | Frist |
|---|---|---|---|---|---|:-:|---|---|---|
| RR-T-067 | **K08-M22** | MUSS | RLS und Serverpfad prüfen bei Projektquellen Mandant und Anwendung. Globale Quellen sind nur nach Plattformfreigabe lesbar. Ein Service- oder … | sicherheits, mandanten · *Vorschlag* | sicherheits (Wort „Schlüssel“); mandanten (Wort „Mandant“) | **⛔** | | | |
| RR-T-068 | **K08-M31** | MUSS | Der Nachweis bindet mindestens Quellen-ID, Quellversion, Quellen-Hash, Fundstelle, Ausgabe-Hash, Rechte-/Policy-Version, Prüfermodell, … | mandanten · *Vorschlag* | mandanten (Wort „Mandanten“) | **⛔** | | | |

### K10 — 3 Einträge, davon 3 sperrend

| Kennung | Klausel | Art | Wortlaut in Kürze | Kritikalität (Triage-**Vorschlag**) | Auslösendes Wort | ⛔ | Träger | Annahme | Frist |
|---|---|---|---|---|---|:-:|---|---|---|
| RR-T-069 | **K10-G10** | GILT | Es GILT: *Umsetzungspartner* ist der Oberbegriff für beide Firmen. Unterschieden werden sie durch ihre Aufgabe am Partner-Mandanten (Eigentümer K02), … | mandanten · *Vorschlag* | mandanten (Wort „Mandanten“) | **⛔** | | | |
| RR-T-070 | **K10-M22** | MUSS | Jeder Abruf MUSS privat und serverseitig für Anwendung, Mandant, Person und freigegebene Paketrevision autorisiert werden. Öffentliche oder dauerhaft … | sicherheits, mandanten · *Vorschlag* | sicherheits (Wort „Geheimniswerte“); mandanten (Wort „Mandant“) | **⛔** | | | |
| RR-T-071 | **K10-M35** | MUSS | Jede Übergabe MUSS genau einen Empfänger benennen: einen Mandanten der Art Partner mit erkennbarer Aufgabe. Ohne benannten Empfänger entsteht keine … | mandanten · *Vorschlag* | mandanten (Wort „Mandanten“) | **⛔** | | | |

### K11 — 7 Einträge, davon 7 sperrend

| Kennung | Klausel | Art | Wortlaut in Kürze | Kritikalität (Triage-**Vorschlag**) | Auslösendes Wort | ⛔ | Träger | Annahme | Frist |
|---|---|---|---|---|---|:-:|---|---|---|
| RR-T-072 | **K11-D05** | DARF NICHT | Eine vierte Zeile in `contact` DARF für denselben Mandanten nicht entstehen, und zwei Zeilen DÜRFEN nicht dieselbe Platznummer tragen. | mandanten · *Vorschlag* | mandanten (Wort „Mandanten“) | **⛔** | | | |
| RR-T-073 | **K11-D09** | DARF NICHT | Die Protokollsicht DARF keine Zeile eines fremden Mandanten zeigen und keine Ausfuhr über die Mandantengrenze erzeugen (Schnitt K02, Durchsetzung K13 … | mandanten · *Vorschlag* | mandanten (Wort „Mandanten“) | **⛔** | | | |
| RR-T-074 | **K11-G05** | GILT | Es GILT: `app_state_aktuell` ist eine Lesesicht auf Anwendung, Zustand und Beginn — kein Schreibschutz, ohne eigenen Mandantenbezug; die Grenze zieht … | mandanten · *Vorschlag* | mandanten (Wort „Mandantenbezug“) | **⛔** | | | |
| RR-T-075 | **K11-M01** | MUSS | Ein Ansprechpartner MUSS genau eine Zeile in `contact` sein und genau einen Mandanten tragen (`tenant_id`, Verweis auf `tenant` — Eigentümer K02, … | mandanten · *Vorschlag* | mandanten (Wort „Mandanten“) | **⛔** | | | |
| RR-T-076 | **K11-M02** | MUSS | Je Mandant MÜSSEN höchstens drei Ansprechpartner bestehen. Die Grenze trägt doppelt: Wertebereich 1 bis 3 an `contact.position` und Eindeutigkeit von … | mandanten · *Vorschlag* | mandanten (Wort „Mandant“) | **⛔** | | | |
| RR-T-077 | **K11-M07** | MUSS | Der Einladungsweg MUSS erst erscheinen, wenn Firmenname, Vorname, Nachname, Telefon und eine gültige Adresse zusammen vorliegen. Als gültig zählt … | sicherheits · *Vorschlag* | sicherheits (Wort „fail-closed“) | **⛔** | | | |
| RR-T-078 | **K11-M27** | MUSS | `app_state_aktuell` bleibt für direkte Clientrollen gesperrt oder wird als Security-Invoker-Sicht mit RLS der Basistabellen bereitgestellt. … | mandanten · *Vorschlag* | mandanten (Wort „Mandanten“) | **⛔** | | | |

### K12 — 3 Einträge, davon 3 sperrend

| Kennung | Klausel | Art | Wortlaut in Kürze | Kritikalität (Triage-**Vorschlag**) | Auslösendes Wort | ⛔ | Träger | Annahme | Frist |
|---|---|---|---|---|---|:-:|---|---|---|
| RR-T-079 | **K12-M02** | MUSS | Die Region MUSS aus der geprüften Werteliste am Mandanten stammen (Eigentümer K02) und gegen die Datenlokalität geprüft werden (Eigentümer K13). | mandanten · *Vorschlag* | mandanten (Wort „Mandanten“) | **⛔** | | | |
| RR-T-080 | **K12-M10** | MUSS | Ein Freigabezugang ist ein serververmittelter, zufälliger, objekt- und mandantengebundener Zugriff. Ablauf und Widerruf werden bei jedem Abruf … | mandanten, freigabe · *Vorschlag* | mandanten (Wort „mandantengebundener“); freigabe (Wort „Freigabezugang“) | **⛔** | | | |
| RR-T-081 | **K12-M12** | MUSS | Release 1 liefert Vorschauen nur für Mandanten mit `processing_region = swedencentral`. Andere modellierte Regionen erhalten eine begründete Sperre … | mandanten · *Vorschlag* | mandanten (Wort „Mandanten“) | **⛔** | | | |

### K13 — 6 Einträge, davon 6 sperrend

| Kennung | Klausel | Art | Wortlaut in Kürze | Kritikalität (Triage-**Vorschlag**) | Auslösendes Wort | ⛔ | Träger | Annahme | Frist |
|---|---|---|---|---|---|:-:|---|---|---|
| RR-T-082 | **K13-D09** | DARF NICHT | Ein produktiver Datenpfad DARF NICHT allein durch Autorisierung im Servercode geschützt sein. Die zweite Mandantenschutzschicht aus RLS ist ein … | mandanten · *Vorschlag* | mandanten (Wort „Mandantenschutzschicht“) | **⛔** | | | |
| RR-T-083 | **K13-G04** | GILT | Es GILT: `portal.data_locality` trägt die Zusage der Datenlokalität mit der Vorgabe `EU-Azure/swedencentral`. Sie ist eine Angabe je Portal, nicht je … | mandanten · *Vorschlag* | mandanten (Wort „Mandant“) | **⛔** | | | |
| RR-T-084 | **K13-M05** | MUSS | Jeder Aufruf aus einer Oberfläche MUSS über den Serverpfad laufen. Der Serverpfad prüft aktives Konto, Mitgliedschaft, Rolle, Mandant und … | mandanten · *Vorschlag* | mandanten (Wort „Mandant“) | **⛔** | | | |
| RR-T-085 | **K13-M07** | MUSS | Vor jeder Exposition über eine unmittelbar erreichbare Datenschnittstelle MÜSSEN RLS-Policies für SELECT, INSERT, UPDATE und DELETE aktiv sein. Der … | mandanten · *Vorschlag* | mandanten (Wort „Mandanten“) | **⛔** | | | |
| RR-T-086 | **K13-M08** | MUSS | Die Mandantengrenze MUSS zweifach durchgesetzt werden: im Serverpfad durch Autorisierung und im Datenbestand durch Policies. Fällt eine Ebene aus, … | mandanten · *Vorschlag* | mandanten (Wort „Mandantengrenze“) | **⛔** | | | |
| RR-T-087 | **K13-M16** | MUSS | Vor jedem Produktivbetrieb MÜSSEN RLS-Policies für alle mandantenbezogenen Tabellen und Sichten aktiv sein. UI-, API- und DB-Negativtests prüfen zwei … | sicherheits, mandanten · *Vorschlag* | sicherheits (Wort „privilegierte“); mandanten (Wort „Mandanten“) | **⛔** | | | |

### K14 — 7 Einträge, davon 7 sperrend

| Kennung | Klausel | Art | Wortlaut in Kürze | Kritikalität (Triage-**Vorschlag**) | Auslösendes Wort | ⛔ | Träger | Annahme | Frist |
|---|---|---|---|---|---|:-:|---|---|---|
| RR-T-088 | **K14-D10** | DARF NICHT | Es DARF keinen Ausnahmezugang geben, der die Rollentrennung, die Mandantengrenze oder die Maskierung umgeht. Auch ein Betriebsvorfall hebt keine … | sicherheits, mandanten · *Vorschlag* | sicherheits (Wort „Rollentrennung“); mandanten (Wort „Mandantengrenze“) | **⛔** | | | |
| RR-T-089 | **K14-G05** | GILT | Es GILT: `approval` trägt keine Mandantenspalte und keinen Fremdschlüssel auf das freigegebene Objekt. Der Mandantenbezug entsteht über das Objekt … | mandanten · *Vorschlag* | mandanten (Wort „Mandantenspalte“) | **⛔** | | | |
| RR-T-090 | **K14-M04** | MUSS | Der Server MUSS vor dem Schreiben der Freigabezeile fünf Bedingungen prüfen: Die Aktion steht in der Matrix, der Freigeber ist die angemeldete … | mandanten, freigabe · *Vorschlag* | mandanten (Wort „Mandanten“); freigabe (Wort „Freigabezeile“) | **⛔** | | | |
| RR-T-091 | **K14-M05** | MUSS | Die serverseitige Prüfung aus K14-M04 MUSS unabhängig von der Bedingung in der Datenbank bestehen. Der CHECK vergleicht zwei Werte einer Zeile; er … | mandanten · *Vorschlag* | mandanten (Wort „Mandant“) | **⛔** | | | |
| RR-T-092 | **K14-M12** | MUSS | Jeder Lese- und Schreibzugriff MUSS auf den Mandanten der angemeldeten Sitzung eingeschränkt sein — doppelt: serverseitige Autorisierung und Regeln … | mandanten · *Vorschlag* | mandanten (Wort „Mandanten“) | **⛔** | | | |
| RR-T-093 | **K14-M18** | MUSS | Jede Handlung, die Daten erzeugt, ändert oder freigibt, MUSS einem angemeldeten Konto mit gültiger Sitzung zugeordnet sein (Konto und zweiter Faktor: … | sicherheits · *Vorschlag* | sicherheits (Wort „zweiter Faktor“) | **⛔** | | | |
| RR-T-094 | **K14-M20** | MUSS | Ein Übergabezugang MUSS je Partnermandant einzeln erteilt werden. Sind zwei Partner beteiligt, entstehen zwei Zugänge mit zwei getrennten … | sicherheits · *Vorschlag* | sicherheits (Wort „Geheimnisreferenzen“) | **⛔** | | | |

### K15 — 1 Einträge, davon 1 sperrend

| Kennung | Klausel | Art | Wortlaut in Kürze | Kritikalität (Triage-**Vorschlag**) | Auslösendes Wort | ⛔ | Träger | Annahme | Frist |
|---|---|---|---|---|---|:-:|---|---|---|
| RR-T-095 | **K15-G09** | GILT | Es GILT: Eine Einladung ist ein Sicherheitsmittel, kein Nachweis, und trägt deshalb keine eigene Klasse. Der Beleg, dass eingeladen wurde, liegt im … | sicherheits · *Vorschlag* | sicherheits (Wort „Sicherheitsmittel“) | **⛔** | | | |

### K16 — 1 Einträge, davon 1 sperrend

| Kennung | Klausel | Art | Wortlaut in Kürze | Kritikalität (Triage-**Vorschlag**) | Auslösendes Wort | ⛔ | Träger | Annahme | Frist |
|---|---|---|---|---|---|:-:|---|---|---|
| RR-T-096 | **K16-G11** | GILT | Es GILT: Die Anzeige eines Zustands ist mandantengebunden wie jede andere Anzeige. Ein fremder Bestand gilt als nicht vorhanden (K02). | mandanten · *Vorschlag* | mandanten (Wort „mandantengebunden“) | **⛔** | | | |

### K17 — 2 Einträge, davon 2 sperrend

| Kennung | Klausel | Art | Wortlaut in Kürze | Kritikalität (Triage-**Vorschlag**) | Auslösendes Wort | ⛔ | Träger | Annahme | Frist |
|---|---|---|---|---|---|:-:|---|---|---|
| RR-T-097 | **K17-D13** | DARF NICHT | Ein Agent DARF Daten zweier Mandanten NICHT zusammenführen — auch nicht verdichtet und auch nicht als Beispiel in einer Eingabe (K02 Abschn. 3). | mandanten · *Vorschlag* | mandanten (Wort „Mandanten“) | **⛔** | | | |
| RR-T-098 | **K17-G12** | GILT | Es GILT: Der Katalog trägt keinen Mandantenbezug; er ist plattformweit. Die Trennung der Kundendaten liegt im Serverpfad und im Datenbestand (K13 … | mandanten · *Vorschlag* | mandanten (Wort „Mandantenbezug“) | **⛔** | | | |

### K19 — 2 Einträge, davon 2 sperrend

| Kennung | Klausel | Art | Wortlaut in Kürze | Kritikalität (Triage-**Vorschlag**) | Auslösendes Wort | ⛔ | Träger | Annahme | Frist |
|---|---|---|---|---|---|:-:|---|---|---|
| RR-T-099 | **K19-D05** | DARF NICHT | Kein Bildschirm DARF ein anderes Verfahren für den zweiten Faktor zeigen als den Code per E-Mail. `mfa_method` kennt EMAIL_CODE und OFF. | sicherheits · *Vorschlag* | sicherheits (Wort „zweiten Faktor“) | **⛔** | | | |
| RR-T-100 | **K19-G08** | GILT | Es GILT: die Angabe 24 Stunden ist die Anzeige der Mandantenvorgabe im Werteband 1 bis 168 Stunden (F11, Eigentümer K02). Weicht die Vorgabe ab, … | mandanten · *Vorschlag* | mandanten (Wort „Mandantenvorgabe“) | **⛔** | | | |

### K20 — 6 Einträge, davon 6 sperrend

| Kennung | Klausel | Art | Wortlaut in Kürze | Kritikalität (Triage-**Vorschlag**) | Auslösendes Wort | ⛔ | Träger | Annahme | Frist |
|---|---|---|---|---|---|:-:|---|---|---|
| RR-T-101 | **K20-G08** | GILT | Es GILT: Schranke und Frist stehen am Mandanten, nicht in der Einladung (Eigentümer K02). Ändert sich die Frist, wirkt sie auf künftige Einladungen, … | mandanten · *Vorschlag* | mandanten (Wort „Mandanten“) | **⛔** | | | |
| RR-T-102 | **K20-G09** | GILT | Es GILT: Das Einladungsverfahren der Verwaltenden — Einmal-Link, Frist, Code bei jeder Anmeldung — ist dasselbe wie beim Endnutzer. Einen bequemeren … | sicherheits · *Vorschlag* | sicherheits (Wort „Anmeldung“) | **⛔** | | | |
| RR-T-103 | **K20-G10** | GILT | Es GILT: Beim Entfernen eines Kontos gehen Mitgliedschaften und Einladungen mit; Rolle und Mandant bleiben und verweigern das Mitlöschen. | mandanten · *Vorschlag* | mandanten (Wort „Mandant“) | **⛔** | | | |
| RR-T-104 | **K20-M11** | MUSS | Der Ablaufzeitpunkt MUSS nach dem Versandzeitpunkt liegen (`invitation_frist`) und die Frist des Mandanten einhalten. Vorgabe sind 24 Stunden (F11); … | mandanten · *Vorschlag* | mandanten (Wort „Mandanten“) | **⛔** | | | |
| RR-T-105 | **K20-M19** | MUSS | *Portalzugang entfernen* löscht ausschließlich die `membership` des gewählten Portals. `actor` (Eigentümer K03) bleibt bestehen; Mitgliedschaften … | aufbewahrungs · *Vorschlag* | aufbewahrungs (Wort „löscht“) | **⛔** | | | |
| RR-T-106 | **K20-M25** | MUSS | Wiederversand zeigt: *Der vorherige Link ist ungültig.* Der Nachweis einer Zugangsänderung trägt `retention_class = BETRIEBSPROTOKOLL`; … | aufbewahrungs · *Vorschlag* | aufbewahrungs (Wort „retention_class“) | **⛔** | | | |

### K23 — 5 Einträge, davon 5 sperrend

| Kennung | Klausel | Art | Wortlaut in Kürze | Kritikalität (Triage-**Vorschlag**) | Auslösendes Wort | ⛔ | Träger | Annahme | Frist |
|---|---|---|---|---|---|:-:|---|---|---|
| RR-T-107 | **K23-M04** | MUSS | Eine Klausel ohne belegenden Test MUSS einzeln als Restrisiko mit Träger, Kritikalität und Annahmeentscheidung aufgeführt werden. Eine … | mandanten, freigabe, aufbewahrungs, wiederherstellungs · *Vorschlag* | mandanten (Wort „mandanten“); freigabe (Wort „Freigabe“); aufbewahrungs (Wort „aufbewahrungs“); wiederherstellungs (Wort „wiederherstellungskritisch“) | **⛔** | | | |
| RR-T-108 | **K23-M10** | MUSS | Es MUSS eine Lastprüfung geben, die mehrere Mandanten gleichzeitig prototypisieren lässt. Ihre Zielwerte legt der Founder fest (O-K23-1). | mandanten · *Vorschlag* | mandanten (Wort „Mandanten“) | **⛔** | | | |
| RR-T-109 | **K23-M11** | MUSS | Die Lastprüfung MUSS die Mandantentrennung unter Last nachweisen, nicht nur die Antwortzeit. | mandanten · *Vorschlag* | mandanten (Wort „Mandantentrennung“) | **⛔** | | | |
| RR-T-110 | **K23-M12** | MUSS | Jeder Prüflauf MUSS gegen deterministisch erzeugte, synthetische und je Mandant gekennzeichnete Daten in einer abgetrennten Umgebung laufen. … | mandanten · *Vorschlag* | mandanten (Wort „Mandant“) | **⛔** | | | |
| RR-T-111 | **K23-M23** | MUSS | Die Lastprüfung MUSS außerhalb der Produktion mit getrennten Testidentitäten und kleinsten erforderlichen Berechtigungen laufen. Sie zeichnet neben … | sicherheits, mandanten · *Vorschlag* | sicherheits (Wort „Berechtigungen“); mandanten (Wort „Mandantenfairness“) | **⛔** | | | |

### K25 — 2 Einträge, davon 2 sperrend

| Kennung | Klausel | Art | Wortlaut in Kürze | Kritikalität (Triage-**Vorschlag**) | Auslösendes Wort | ⛔ | Träger | Annahme | Frist |
|---|---|---|---|---|---|:-:|---|---|---|
| RR-T-112 | **K25-G14** | GILT | Es GILT: Mehrere Hüllen laufen gleichzeitig. Ihre Trennung folgt der Mandantentrennung des Hostings (K12, K13). | mandanten · *Vorschlag* | mandanten (Wort „Mandantentrennung“) | **⛔** | | | |
| RR-T-113 | **K25-M22** | MUSS | Jede Auswahl MUSS einen vollständigen Auswahlvermerk erzeugen: Auswahlkennung, Zeitpunkt, Anwendungs- und Mandantenbezug, Fassung der bestätigten … | mandanten · *Vorschlag* | mandanten (Wort „Mandantenbezug“) | **⛔** | | | |

---

## Die sperrenden Klassen — warum hier keine Annahme genügt

`K23-M04`, letzter Satz, im Wortlaut:

> *„Ist die Klausel sicherheits-, mandanten-, freigabe-, aufbewahrungs- oder
> wiederherstellungskritisch, **sperrt der fehlende Test die Freigabe**.“*

Jeder der 113 Einträge wurde daraufhin am Wortlaut geprüft. **Alle 113 fallen in mindestens
eine der fünf Klassen** — die Triage kennt keine sechste Art, kritisch zu sein.

| Klasse | Einträge |
|---|---:|
| sicherheitskritisch | 26 |
| mandantenkritisch | 94 |
| freigabekritisch | 8 |
| aufbewahrungskritisch | 5 |
| wiederherstellungskritisch | 5 |

Eine Klausel kann in mehreren Klassen stehen; die Summe ist deshalb größer als 113.

### Eine Schwäche dieser Einordnung, offen benannt

**94 der 113 Einträge sind *mandantenkritisch*, 76 davon ausschließlich.** Ausgelöst hat
das durchweg das Wort *Mandant* im Wortlaut. Das Wort steht in sehr vielen Klauseln,
weil die ganze Anlage mandantengetrennt ist — es trennt also wenig. **Der Vorschlag ist
damit eher zu weit als zu eng.**

**Das ist kein Grund, ihn zu senken.** `K23-D05` und `K23-G08` untersagen, eine
Kritikalität herabzustufen, damit ein Lauf besteht. Es ist ein Grund, ihn **von einem
Menschen lesen zu lassen**: die auslösende Wortstelle steht in jeder Zeile, und wer eine
Einordnung nicht mitträgt, vermerkt das in der Zeile und legt es vor. **Dieses Blatt hat
nichts gestrichen** — das wäre eine Entscheidung.

**Was das praktisch heißt.** Für diese 113 Einträge ist die Spalte *Annahme* kein Ausweg.
Sie darf ausgefüllt werden, aber sie hebt die Sperre nicht auf. Es gibt genau zwei Wege:

1. **Ein Prüffall wird geschrieben** — vom Prüf-Agenten, blind, gegen das Akzeptanzkriterium.
   Das Akzeptanzkriterium fehlt heute bei **allen** Zeilen; es kommt nach `K23-M02` vom
   fachlichen Eigentümer. **Ohne Kriterium kein Prüffall.**
2. **Die Klausel wird aus dem Umfang genommen** — das ist eine Umfangsentscheidung des
   Auftraggebers, kein Vorgang dieses Harness.

---

## Was ein Mensch jetzt tun muss

| | Was | Wer | Warum es nicht maschinell geht |
|---|---|---|---|
| 1 | **Je Eintrag einen Träger benennen** | M. Veil | Träger sind Menschen. `K23-D07`: ein Restrisiko darf nicht stillschweigend übernommen werden |
| 2 | **Je Eintrag Annahmeentscheidung und Frist zeichnen** | M. Veil | Das ist die Kernfrage der Abnahme |
| 3 | **Für die 113 sperrenden Einträge entscheiden, welcher Weg gilt** — Prüffall oder Umfangsentscheidung | M. Veil | Eine Annahme genügt dort nach `K23-M04` nicht |
| 4 | **Die Akzeptanzkriterien liefern** — ohne sie ist kein Prüffall schreibbar | die fachlichen Eigentümer (`K23-M02`) | Ein erfundenes Kriterium ließe den Bau gegen eine erfundene Erwartung bestehen |
| 5 | **Die Zuordnung zum Teilschnitt zeichnen** — `S1_zeichnung.md` trägt bis heute **kein einziges Kreuz** | M. Veil | Der Ausschnitt dieses Blattes ist damit gerechnet, aber nicht gezeichnet |

---

*Erzeugt am 2026-08-16. **Vorschlag, keine Entscheidung.** Träger, Annahmeentscheidung und Frist
sind in allen 113 Zeilen leer und bleiben es, bis ein Mensch sie füllt. Maschinenlesbar
daneben: `restrisiken_teilschnitt.json`.*
