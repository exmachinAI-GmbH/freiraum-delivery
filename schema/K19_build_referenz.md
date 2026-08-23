# K19 · Build-Referenz (ASCII) — Konzept v1.4
| Feld | Wert |
|---|---|
| Konzept | K19 · Build-Referenz (ASCII) |
| Version / Status | v1.4 · **Freigegeben** |
| Datum / Freigabe | 23.08.2026 · Vier-Augen: 23.08.2026, M. Veil (Founder) |
| Vorgaengerfassung | v1.3, freigegeben 01.08.2026 — abgeloest am 23.08.2026 |
| Aenderung gegenueber v1.3 | Aufnahme von EN-03a und EN-04a: zwei Kaesten und zwei Sitemap-Zeilen (Abschn. 6), zwei Zuordnungszeilen (Abschn. 8), O-K19-11 (Abschn. 11). Wortlaut aus N-K19-1 vom 14.08.2026 (A. Han); drei Verweise auf K04-Klauseln in der Schreibweise angepasst. Sonst keine Aenderung. |
| Quellen | `quellen/build-inventar.md` · `quellen/build-tot.md` · Endnutzer-Handbuch Kap. 2–12 · EXMA-Handbuch Kap. 2–11 · `config/kanon.yaml` |
| Seitenlimit | ≤ 13 Seiten (Ist: 12.8 — 6407 Wörter, 500 je Seite). Berichtigt: v1.3 nannte 12, `config/konzepte.yaml` führt für K19 seit dem 05.08.2026 `umfang: 13` (F30). |
| Lint | Struktur, Klauseln, Enums, Diagramme nachgefahren: **0 Fehler** |
| Tabletop | Stand v1.3: bestanden · 13/14 · 93 %. Für v1.4 **nicht wiederholt** |
| Vorbehalt | Nicht vorhandene Release-1-Felder und Demo-Reset sind aus den Kästen entfernt. Technische Umsetzung von Accessibility, Autorisierung und Produktionssperren bleibt Abnahmegegenstand der Eigentümerkonzepte. |
| Anhang | `03_KONZEPTE_v2.9/schemas/K19_spalten-herkunft.md` |
| Maschinenlesbare Screenquelle | `03_KONZEPTE_v2.9/schemas/K19_screens.yaml` |

## 1 · Zweck und Geltungsbereich

K19 ist die verbindliche Oberflächen-Referenz für Release 1. Es führt die Bildschirm-Kennungen ein, zeichnet je Bildschirm einen Kasten und hält fest, was im Build steht, aber kein Umfang ist. Die einzige pflegbare Screenquelle ist `K19_screens.yaml`; die Kästen werden daraus erzeugt. Andere Konzepte referenzieren Kennung und Version und zeichnen nie frei.

K19 regelt **nicht**, was hinter einem Bildschirm fachlich geschieht. Es besitzt keine Tabelle des Datenmodells. Bedienregeln und Anzeigesprache gehören K16, Freigabe und Rollentrennung K14, Rollen und Einladungen K20, Konten K03, Aufbewahrung K15, Dokumente K10. Die Ableitungsregel für abgeleitete Anzeigenamen gehört K16 — K19 zeigt sie nur.

## 2 · Begriffe

| Begriff | Bedeutung | Quelle |
|---|---|---|
| Bildschirm | Eine bedienbare Fläche mit eigener Kennung. Zwei Zustände derselben Fläche sind ein Bildschirm | K19 |
| Kennung | `EN-01`…`EN-14` für ENDUSER, `EX-01`…`EX-17` für EXMA. Von K19 eingeführt, weder Build noch Handbuch führen eine | K19 |
| Kasten | Der ASCII-Aufriss eines Bildschirms. Zeigt Anordnung und Aktionen, nie Gestaltung | F18 |
| Statusleiste | Rechts in der Kopfzeile des Kastens: Stufe des Gesprächs oder Zustandsname | Endnutzer-Handbuch 9.1 |
| Element-Kennung | Bezeichner aus dem Inventar, etwa `gatehint`. Belegt ein Feld, das sonst geraten wäre | Inventar Abschn. 3 |
| Zugangsmarke | offen · nach Anmeldung · nach gesetztem Häkchen | Kap. 6 |
| ausgeblendet | Die Schaltfläche fehlt; an ihrer Stelle steht ein Hinweis | Endnutzer-Handbuch 12 |
| ausgegraut | Die Schaltfläche ist da und gesperrt, mit Marke für den Grund | EXMA-Handbuch 5.3 |
| Liste A / B / C | gestrichen · `release_status = PLANNED` · zurückgestellt (F28) | Abschn. 9 |

## 3 · Klauseln

### 3.1 MUSS

| Nr. | Klausel |
|---|---|
| K19-M01 | Jedes Konzept mit Bezug zur Oberfläche MUSS Kennung und Version aus `K19_screens.yaml` referenzieren. Eine benötigte Einbettung wird daraus erzeugt; manuell kopierte Kästen sind unzulässig. |
| K19-M02 | Jeder Kasten MUSS in der Kopfzeile Kennung, Name und Statusleiste tragen und darunter genau eine Belegzeile. |
| K19-M03 | Jeder Bildschirm MUSS genau eine Zugangsmarke tragen. Ein Kasten ohne Marke ist unvollständig. |
| K19-M04 | Die Fortschrittsanzeige MUSS fünf Stufen führen: ORIENTIERUNG · INTERVIEW · UEBERSICHT · PROTOTYP · ANGEBOT. |
| K19-M05 | Zustandsnamen MÜSSEN aus `lifecycle_state_label` je `ui_locale` stammen, dessen Eigentümer K11 ist. |
| K19-M06 | Ist eine Bedingung durch den Nutzer selbst erfüllbar, MUSS die Schaltfläche ausgeblendet werden und an ihrer Stelle ein Hinweis stehen, der die Bedingung benennt. |
| K19-M07 | Ist eine Sperre strukturell, MUSS die Schaltfläche ausgegraut und durch eine Marke erklärt werden. |
| K19-M08 | Jede angezeigte Spalte MUSS genau eine Herkunft tragen — Feld oder Enum, nachgewiesen im Schema-Anhang. Eine Spalte ohne Herkunft gehört in Abschnitt 11, nicht in einen Kasten. |
| K19-M09 | EN-09 MUSS beide Häkchen zeigen und das zweite als Übergabe der beiden Memos beschriften. Es wirkt nur zusammen mit dem Siegel (F03, CHECK `ack_needs_seal`, Prüffall T22, Eigentümer K09). |
| K19-M10 | Eine Frist MUSS als Dauer in Klartext erscheinen, im Wortlaut der belegten Handbuchstelle. |
| K19-M11 | Die drei Negativlisten MÜSSEN getrennt geführt werden: Liste A Streichung, Liste B `release_status = PLANNED`, Liste C zurückgestellt (F28). |
| K19-M12 | Jede Zeile der Zuordnung in Abschnitt 8 MUSS genau einen Eigentümer nennen. |
| K19-M13 | Jeder Bildschirm MUSS eine festgelegte Fokusreihenfolge, Tastaturbedienung, programmatisch bestimmbare Namen/Rollen/Werte, verständliche Statusansagen sowie einen verlustfreien schmalen Darstellungsmodus besitzen. |
| K19-M14 | Jede Aktion MUSS in der Maschinenquelle Eingabe, Serverbefehl, Berechtigungsprüfung, Lade-, Leer-, Erfolgs- und Fehlerzustand referenzieren. Ein UI-Zustand ersetzt keine serverseitige Autorisierung. |

### 3.2 DARF NICHT

| Nr. | Klausel |
|---|---|
| K19-D01 | Ein ENDUSER-Bildschirm DARF NICHT Preis, Marge oder Provision zeigen. Der Angebotspreis erscheint ausschließlich in EX-04, EX-05 und EX-08 des EXMA-Portals (F14). |
| K19-D02 | Kein Kasten DARF einen Bildschirm für Service und Tickets oder eine dafür bestimmte Schaltfläche in der Kopfleiste zeigen — zurückgestellt nach F28. |
| K19-D03 | Kein Kasten und keine Sitemap DARF ein Portal mit `release_status = PLANNED` abbilden (F04). |
| K19-D04 | Kein Konzept DARF ein Element der Liste A als Soll beschreiben. Nennung ausschließlich im Streichungsvermerk. |
| K19-D05 | Kein Bildschirm DARF ein anderes Verfahren für den zweiten Faktor zeigen als den Code per E-Mail. `mfa_method` kennt EMAIL_CODE und OFF. |
| K19-D06 | Kein Kasten DARF eine Restlaufzeit, einen Rückwärtszähler oder einen Ablaufzeitpunkt als Datum zeigen. Für Release 1 gibt es dafür keinen Beleg. |
| K19-D07 | Kein Kasten DARF eine Nachweisfläche zeigen, die es nicht gibt: keine Anschrift für Betriebsrat oder Datenschutz, keine Schaltfläche zum Versand der Memos, keine Löschfunktion im Protokoll oder im Audit-Log. |
| K19-D08 | K19 DARF keine Tabelle besitzen. Namen von Tabellen und Sichten erscheinen nur als Verweis auf das zuständige Konzept. |
| K19-D09 | Kein Kasten DARF eine bedienbare Schaltfläche für einen Vorgang zeigen, dessen Vorbedingung nicht erfüllt oder nicht prüfbar ist. Im Zweifel wird gesperrt. |

### 3.3 GILT

| Nr. | Klausel |
|---|---|
| K19-G01 | Fehlt eine Kennung, GILT fail-closed: die Übernahme ist abgelehnt, nicht ergänzt. Der Bildschirm gilt als nicht belegt und wird als offener Punkt geführt. |
| K19-G02 | Es GILT: ausgeblendet und ausgegraut sind zwei Darstellungen mit zwei Bedeutungen. Ausgeblendet, wo der Nutzer die Bedingung selbst erfüllen kann; ausgegraut, wo eine Festlegung sie ihm dauerhaft verwehrt. |
| K19-G03 | Es GILT: Herkunft ist sichtbar getrennt — KI-Notiz gegen eigene Angabe (EN-06), KI-Vorschlag (EN-05), fest zugeordnete Marke je Konzeptkachel (EN-07), Arbeitsdokument und ungeprüft (EN-12). |
| K19-G04 | Es GILT F21: `lifecycle_state` führt acht Werte. *In Klärung* ist ein abgeleitetes Anzeigelabel, kein Zustand, getragen von `lifecycle_state_label` und der Sicht `app_state_aktuell` (Eigentümer K11). In der Auswahlliste von EX-04 und EX-08 wird es nur angezeigt, nie ausgewählt — ein abgeleiteter Name ist nicht setzbar. Zweiter Fall desselben Musters: *Angebot angefragt* auf EN-11, abgeleitet aus `app.sealed_at`. |
| K19-G05 | Bei Widerspruch zwischen Handbuch und Datenmodell GILT das Datenmodell. K19 weist den Widerspruch in Abschnitt 11 aus und entscheidet ihn nicht. |
| K19-G06 | Es GILT die Zeichenkonvention aus Abschnitt 5: runde Ecken für Kästen, Pfeilzeichen ausschließlich für Abläufe und Sitemaps. Wer sie mischt, macht seinen Kasten für die Diagrammzählung zu einem Ablauf. |
| K19-G07 | Es GILT: zurückliegende Stufen öffnen sich nur als Nur-Ansicht. Rollentrennung bei Freigaben gehört K14, der Selbstschutz gegen Sperren des eigenen Kontos ist nach F15 ein Abnahmetest der Anwendung. |
| K19-G08 | Es GILT: die Angabe 24 Stunden ist die Anzeige der Mandantenvorgabe im Werteband 1 bis 168 Stunden (F11, Eigentümer K02). Weicht die Vorgabe ab, folgt der Anzeigetext ihr. |
| K19-G09 | Es GILT: Ursprung und Bearbeitungszustand sind getrennte Angaben. Nach einer Änderung lautet die Anzeige beispielsweise „KI-Vorschlag, anschließend bearbeitet“; eine statische Herkunftsmarke allein genügt nicht als Provenienz. |

## 4 · Abläufe

### 4.1 Ein anderes Konzept übernimmt einen Bildschirm

```
Konzept braucht eine Oberflaeche
            │
            ▼
   Kennung in K19 vorhanden?  ──nein──▶ fail-closed: abgelehnt,
            │ ja                        Bildschirm gilt als unbelegt
            ▼
   Eigentuemer laut Abschnitt 8?  ──nein──▶ abgelehnt: nur Verweis,
            │ ja                            kein eigener Kasten
            ▼
   In Liste A, B oder C?
            │        ├─ Liste A ──▶ abgelehnt, nur Streichungsvermerk
            │        ├─ Liste B ──▶ abgelehnt, release_status PLANNED
            │        └─ Liste C ──▶ abgelehnt, zurueckgestellt F28
            │ nein
            ▼
   Kasten unveraendert + eigene Fachregel
            │
            ▼
   Lint: Kennung · Diagramme · Begriffe ──rot──▶ abgelehnt, zurueck
            │ gruen
            ▼
   Bildschirm im Konzept verbindlich
```

### 4.2 Zugang zu einem Bildschirm

```
Aufruf eines Bildschirms
            │
            ▼
   Zugangsmarke offen?  ──ja──▶ Bildschirm wird gezeigt
            │ nein
            ▼
   Sitzung gueltig?  ──nein──▶ EN-01 bzw. EX-01, kein Teil-Zugang
            │ ja                (Einmal-Link aelter als 24 h: ABGELAUFEN)
            ▼
   actor_status = AKTIV?  ──nein──▶ abgelehnt (fail-closed)
            │ ja                    WARTET_2FA: erst zweiter Faktor
            ▼                       GESPERRT: Anmeldung verweigert
   Vorbedingung des Bildschirms erfuellt?
            │ ja        └─nein──▶ Bildschirm ohne die Schaltflaeche,
            ▼                     Hinweis an ihrer Stelle
   Bildschirm mit allen Aktionen
```

## 5 · Zeichenkonvention

| Element | Zeichen | Grund |
|---|---|---|
| Kasten eines Bildschirms | `╭ ─ ╮ │ ╰ ╯` | runde Ecken, damit die Diagrammzählung ihn nicht für einen Ablauf hält |
| Ablauf | `──▶` `▼` `├─` `└─` | soll als Ablauf gezählt werden, Fehlerpfad eingezeichnet |
| Sitemap | `├─` `└─` | wird als Ablauf gezählt und trägt darum den gesperrten Zugang als Zeile |

| Zone im Kasten | Bedeutung |
|---|---|
| Kopfzeile links | Kennung und Name des Bildschirms |
| Kopfzeile rechts in Klammern | Statusleiste: Stufe oder Zustandsname |
| Senkrechter Strich in der Zeile | Spaltentrenner — links Gespräch oder Navigation, rechts Ergebnis oder Arbeitsfläche |
| `[Wort mit Leerraum ]` | Eingabefeld, der Leerraum zeigt die Feldbreite |
| `[Wort]` | Schaltfläche |
| `[x]` | gesetztes Kontrollkästchen |
| `[Wert v]` | Auswahlliste |
| Zeile ohne Klammern | Hinweis, Marke oder Zustandstext, nicht bedienbar |
| Kleinschrift wie `gatehint` | Element-Kennung aus dem Inventar |

### 5.1 Zugänglichkeit und schmale Ansichten

Die ASCII-Kästen bestimmen Anordnung und Verhalten, nicht Pixel. Für jeden
kritischen Weg gelten K19-M13 und die Web Content Accessibility Guidelines 2.2 als Abnahmebasis. Bei schmaler Ansicht
folgt die rechte Arbeitsfläche unter dem Gespräch; Reihenfolge, Namen, Hinweise
und Aktionen bleiben vollständig. Statusänderungen werden ohne Fokuswechsel
angesagt. Farbe, Symbol oder Position sind nie der einzige Informationsträger.

## 6 · Sitemap und Kastenkatalog · ENDUSER

```
ENDUSER · Endnutzer-Portal        (portal_code ENDUSER · release_status ENABLED)
│
├─ EN-01  Anmeldung
│   └─ Code falsch oder Link aelter als 24 h ──▶ bleibt auf EN-01
├─ EN-02  Startseite — links Gespraech, rechts Ihre Anwendungen
│   ├─ EN-03  Direkt-Prototyp-Check ──▶ EN-12
│   │   └─ EN-03a  Die fuenf Fragen ──▶ EN-12 · EN-04
│   └─ EN-04  Eignungs-Check, drei Fragen
│       ├─ NICHT_GEEIGNET ──▶ Halt, kein Weiterweg
│       └─ GEEIGNET ──▶ EN-04a  Zweckbestimmung, zwei Fragen
│           ├─ Treffer Frage 2 ──▶ Halt, kein Weiterweg
│           └─ Gespraech in fuenf Stufen (journey_phase)
│               ├─ EN-05  Stufe 01 ORIENTIERUNG
│               ├─ EN-06  Stufe 02 INTERVIEW
│               ├─ EN-07  Stufe 03 UEBERSICHT
│               │   └─ Haekchen fehlt ──▶ Weiter-Schaltflaeche ausgeblendet
│               ├─ EN-08  Stufe 04 PROTOTYP
│               └─ EN-09  Stufe 05 ANGEBOT ──▶ EN-10  Bestaetigung
├─ EN-11  Meine Anwendungen
├─ EN-12  Direkt-Prototypen
├─ EN-13  Einstellungen
└─ EN-14  Nebenfragen-Fenster

ohne Anmeldung: gesperrt — jeder Aufruf ausser EN-01 endet auf EN-01.
Kein Bildschirm fuer Service und Tickets (zurueckgestellt, F28).
USER_ADMIN · VAR_ADMIN · INDIA_OPS: release_status PLANNED, nicht enthalten.
```

```
╭─ Kopfleiste · auf jedem Bildschirm gleich ─────── [EN-alle] ─╮
│  [Zurueck] [Hauptmenue] [Meine Apps] [Direkt-Prototypen]     │
│  [Einstellungen] [DE / EN] [-] [+] [Dark] [? Hilfe]          │
│  [Ausloggen]                                                 │
│  Sprache, Zoom und Kontrast wirken sofort, aendern nichts    │
│  am Inhalt.                                                  │
╰──────────────────────────────────────────────────────────────╯
```
Beleg: Endnutzer-Handbuch 11.3, ohne Abbildung.

```
╭─ EN-01 · Anmeldung ───────────────────────────── [offen] ─╮
│  Zugang: offen  │
│  E-Mail-Adresse   [vorbelegt aus der Einladung        ]   │
│  Zugangscode      [sechsstellig                      ]    │
│  Einmal-Link 24 Stunden gueltig, danach neuer Link ueber  │
│  Ihre Ansprechperson.                                     │
│  [Anmelden]                                               │
╰───────────────────────────────────────────────────────────╯
```
Beleg: Endnutzer-Handbuch 2.1, Abbildung 1.

```
╭─ EN-02 · Startseite ───────────────────── [nach Anmeldung] ─╮
│  Zugang: nach Anmeldung  │
│  GESPRAECH                 |  IHRE ANWENDUNGEN              │
│  [Neue Anwendung erstellen]|  Name der Anwendung            │
│  [Erklaervideo ansehen]    |  [Zustandsname]  Stufe 03      │
│  [Termin vereinbaren]      |  [Fortfuehren]                 │
│  [Etwas Eigenes eintippen] |  zweite Anwendung              │
│  [Nachricht         ][Senden]  [Ansehen]                    │
│  Dauerhinweis: KI-Vorschlaege koennen Fehler enthalten.     │
╰─────────────────────────────────────────────────────────────╯
```
Beleg: Endnutzer-Handbuch 2.2 und 2.3, Abbildungen 2 und 3.

```
╭─ EN-03 · Direkt-Prototyp-Check ─── [Vorpruefung 1 von 2] ─╮
│  Zugang: nach Anmeldung  │
│  Braucht Ihr Anliegen wirklich eine Anwendung?            │
│  Ein Direkt-Prototyp ist ein Arbeitsdokument: sofort da,  │
│  ungepruefte Grundlage, nicht Gegenstand einer Anfrage.   │
│  [Check starten]   [Ueberspringen]                        │
╰───────────────────────────────────────────────────────────╯
```
Beleg: Endnutzer-Handbuch 3.1, Abbildung 4.

```
╭─ EN-03a · Die fuenf Fragen ─────── [Vorpruefung 1 von 2] ─╮
│  Zugang: nach Anmeldung  │
│  Frage 1 von 5                                            │
│  Was haetten Sie am liebsten in der Hand?                 │
│  [a  eine Datei, die ich oeffne, lese und weitergebe]     │
│  [b  etwas, das ich aufrufe und in dem ich arbeite]       │
│  [c  weiss ich noch nicht]                                │
│  danach an derselben Stelle Frage 2 Wiederholung, Frage 3 │
│  Beteiligte, Frage 4 Daten, Frage 5 Verbindlichkeit       │
│  Auswertung serverseitig: Vetorecht der Fragen 5 und 1,   │
│  Zaehlung der Fragen 2 bis 4 — der Bildschirm liefert     │
│  kein Ergebnis mit                                        │
│  Ergebnis  Vorschlag Direkt-Prototyp oder Anwendung, mit  │
│  genau einem Satz, der die ausschlaggebende Antwort nennt │
│  Solange eine Frage offen ist, steht an Stelle der beiden │
│  Weiterwege ein Hinweis, der die offene Frage nennt       │
│  Erst mit dem Ergebnis erscheinen die beiden Weiterwege:  │
│  [Arbeitsdokument]  [Vorpruefung 2]                       │
│  Der Direkt-Prototyp bleibt ungeprueft und ist nie        │
│  Gegenstand einer Angebotsanfrage.                        │
╰───────────────────────────────────────────────────────────╯
```
Beleg: Endnutzer-Handbuch 3.1, ohne Abbildung.

```
╭─ EN-04 · Eignungs-Check ────────── [Vorpruefung 2 von 2] ─╮
│  Zugang: nach Anmeldung  │
│  Frage 1  Was soll am Ende entstehen?      [ART]          │
│  Frage 2  Wer arbeitet damit, wie lange?   [NUTZUNG]      │
│  Frage 3  Welche Daten sind beruehrt?      [DATEN]        │
│  Ergebnis  OFFEN · GEEIGNET · NICHT_GEEIGNET              │
│  Bei NICHT_GEEIGNET erscheint ein Halt-Feld statt des     │
│  Weiterwegs: [Antwort aendern] [Termin] [Zur Uebersicht]  │
╰───────────────────────────────────────────────────────────╯
```
Beleg: Endnutzer-Handbuch 3.2 und 3.3, Abbildungen 5 bis 8.

```
╭─ EN-04a · Zweckbestimmung ─────────────── [nicht belegt] ─╮
│  Zugang: nach Anmeldung  │
│  Frage 1  Bewertung von Menschen (Anhang III) [Ja] [Nein] │
│  Frage 2  Verbotene Praktik (Art. 5)          [Ja] [Nein] │
│  Vorrang  Treffer in Frage 2 geht Frage 1 vor             │
│  Keine Eignungsfrage: Art, Nutzung, Daten unberuehrt      │
│  [Weiter] ausgeblendet, bis beide Fragen beantwortet sind │
│  Treffer Frage 1  Warnung: Anhang III kann greifen. Sie   │
│  bringen die Anwendung als Anbieter unter eigenem Namen   │
│  in Verkehr, Pflichten aus Art. 9, 11, 14, 17 und 43.     │
│  [Kenntnis genommen]                                      │
│  Treffer Frage 2  Halt-Feld mit dem Grund und Verweis auf │
│  Art. 5, auch wenn Frage 1 zutrifft. Kein Weiterweg:      │
│  [Antwort aendern] [Termin] [Zur Uebersicht]              │
│  Kein Treffer  Anwendung wird angelegt, weiter nach EN-05 │
╰───────────────────────────────────────────────────────────╯
```
Beleg: `K19_screens.yaml` v1.2 Z. 219–278 · K04 v1.7 Abschn. 3.1 (Klauseln M19 bis M21) ·
K00 Beschluss-Log v1.10 Z. 250 (S23, Founder, 31.07.2026), ohne Abbildung.

```
╭─ EN-05 · Stufe 01 Orientierung ────── [ORIENTIERUNG 1/5] ─╮
│  Zugang: nach Anmeldung  │
│  GESPRAECH                  |  IHR STAND                  │
│  Themenwahl, dann Branche   |  Branche                    │
│  Funktion und Anwendung     |  Funktion                   │
│  Ziele: Mehrfachwahl, die   |  Anwendung                  │
│  Reihenfolge zaehlt         |  Ziele  1 2 3               │
│  Ausgangsproblem bestaetigen|  Ausgangsproblem            │
│  [Ja, weiter zum Interview] |  Name  [KI-Vorschlag     ]  │
│  Jedes Feld mit Vorschlag ist auch ein Eingabefeld.       │
╰───────────────────────────────────────────────────────────╯
```
Beleg: Endnutzer-Handbuch 4.1 bis 4.5, Abbildungen 9 bis 14.

```
╭─ EN-06 · Stufe 02 Interview ──────────── [INTERVIEW 2/5] ──╮
│  Zugang: nach Anmeldung  │
│  GESPRAECH                  |  ZUSAMMENFASSUNG             │
│  Fachfrage mit Vorschlaegen |  Teilnehmer des Gespraechs   │
│  [Vorschlag] [Vorschlag]    |  KI-Notiz                    │
│  [Freitext          ][Datei]|  Ihre Angabe                 │
│  [Diese Frage ignorieren]   |  (Frage uebersprungen)       │
│  [Bin fertig mit dem Interview]                            │
│  [Speichern, spaeter weitermachen]                         │
╰────────────────────────────────────────────────────────────╯
```
Beleg: Endnutzer-Handbuch 5.1 bis 5.3, Abbildungen 15 bis 18.

```
╭─ EN-07 · Stufe 03 Uebersicht ──────────  [UEBERSICHT 3/5] ─╮
│  Zugang: nach Anmeldung  │
│  Pruefung laeuft: fuenf Stufen, links Stand, rechts Wert   │
│  Ergebnis: bestanden · Score                               │
│  Sechs Anforderungskonzepte, je Kachel eine fest           │
│  zugeordnete Herkunftsmarke:                               │
│    1 Prozess & Schritte      [KI]                          │
│    2 Daten & Systeme         [KI]                          │
│    3 Rollen & Aktionen       [Mensch]                      │
│    4 Regeln & Ausnahmen      [KI-ueberarbeitet]            │
│    5 Compliance              [Mensch]                      │
│    6 Ergebnis & Kennzahlen   [KI]                          │
│  Je Kachel [Bearbeiten]. Die Marke bleibt dabei stehen.    │
│  [Offene Punkte] [Interview-Protokoll] [Memos]             │
│  Memos: Betriebsrat und Datenschutz, ansehen und laden.    │
│  FREIRAUM versendet sie nicht.                             │
│  [x] Ich habe die sechs Konzepte geprueft.                 │
│  Ohne Haekchen ist die Weiter-Schaltflaeche ausgeblendet;  │
│  an ihrer Stelle steht der Pruefhinweis (gatehint).        │
│  [Alles herunterladen]                                     │
╰────────────────────────────────────────────────────────────╯
```
Beleg: Endnutzer-Handbuch 6.1 bis 6.3, Abbildungen 19 bis 21. Zuordnung der sechs Marken: Founder-Entscheidung vom 30.07.2026 (O-K19-2). Sie ist **fest und instanzunabhängig** — kein Feld, kein Enum, kein Eingriff ins Datenmodell. Folge, bewusst in Kauf genommen: Bearbeitet der Kunde eine Kachel, bleibt die Marke stehen und beschreibt dann nicht mehr den tatsächlichen Inhalt.

```
╭─ EN-08 · Stufe 04 Prototyp ───────────── [PROTOTYP 4/5] ─╮
│  Zugang: nach gesetztem Häkchen  │
│  [Desktop] [Mobil] [-] [+] [Neu laden]                   │
│  bedienbare Maske mit Beispieldaten aus Ihrem Vorhaben   │
│  Feilen: [Schrift groesser] [Mehr Kontrast]              │
│          [Schaltflaeche umbenennen] [Feld ausblenden]    │
│  [Feilen beenden]                                        │
│  Unantastbar: Zahlen, Rechenlogik, Freigabe-Regeln.      │
│  Zurueckliegende Stufen sind Nur-Ansicht — dort fehlt    │
│  die Bearbeiten-Schaltflaeche.                           │
╰──────────────────────────────────────────────────────────╯
```
Beleg: Endnutzer-Handbuch 7.1 bis 7.3, Abbildungen 22 bis 25.

```
╭─ EN-09 · Stufe 05 Angebot ──────────────── [ANGEBOT 5/5] ─╮
│  Zugang: nach gesetztem Häkchen  │
│  FREIGABE                                                 │
│  Unterschrift  [Ihr Name, mindestens drei Zeichen     ]   │
│  [x] Die Anfrage ist unverbindlich, die offenen Punkte    │
│      sind mir bekannt                                     │
│  [x] Beide Memos wurden mir uebergeben; die Weitergabe    │
│      im Haus liegt bei mir                                │
│  Vorher ausgegraut, mit Liste des Fehlenden darunter:     │
│  [Angebot anfordern]                                      │
│  DOKUMENTE  sechs Konzepte · Protokoll · zwei Memos ·     │
│  Liste der offenen Punkte   [Alle herunterladen]          │
│  Kein Preis in diesem Portal.                             │
╰───────────────────────────────────────────────────────────╯
```
Beleg: Endnutzer-Handbuch 8.1 bis 8.3, Abbildungen 26 und 27.

```
╭─ EN-10 · Bestaetigung ───────────────── [Anfrage gestellt] ─╮
│  Zugang: nach gesetztem Häkchen  │
│  Ihre Anfrage ist eingegangen — unverbindlich.              │
│  Projektnummer                                              │
│  Die E-Mail geht an Ihre Adresse und an die Rechnungs-      │
│  adresse. Kein Rechner entscheidet ueber die Annahme.       │
│  DOKUMENTE  wie in EN-09, vollstaendig                      │
╰─────────────────────────────────────────────────────────────╯
```
Beleg: Endnutzer-Handbuch 8.4, Abbildung 28.

```
╭─ EN-11 · Meine Anwendungen ────────── [nach Anmeldung] ─╮
│  Zugang: nach Anmeldung  │
│  Je Karte: Name · [Zustandsname] · letzte Aenderung     │
│  Stufe und offener Schritt                              │
│  [Fortfuehren] fuehrt an die gespeicherte Stelle        │
│  [Ansehen] bei abgeschlossenem Gespraech                │
│  Marke: geprueft                                        │
│  Abgeleiteter Name "Angebot angefragt", sobald der      │
│  Freigabeblock aus EN-09 abgeschickt ist                │
╰─────────────────────────────────────────────────────────╯
```
Beleg: Endnutzer-Handbuch 9.1, Abbildung 29. **„Angebot angefragt" ist ein abgeleitetes Anzeigelabel, kein Zustand** — zweiter Fall nach dem Muster F21 (O-K19-3, Founder-Entscheidung 30.07.2026). Bedingung: der Nutzer hat in Stufe 05 den Namen eingetragen, beide Häkchen gesetzt und *Angebot anfordern* betätigt; damit ist `app.sealed_at` gesetzt (Eigentümer K01). Für die Anzeige genügt `sealed_at IS NOT NULL` — das zweite Häkchen kann nach CHECK `ack_needs_seal` ohne Siegel gar nicht bestehen. Belegt in der Ground Truth: das Datenmodell führt `sealed_at` ausdrücklich als die einzige Zustandsquelle für *Angebot angefragt*. Träger `lifecycle_state_label` gehört K11, die Anzeigeregel K16.

```
╭─ EN-12 · Direkt-Prototypen ────────────── [ungeprueft] ─╮
│  Zugang: nach Anmeldung  │
│  Marke je Zeile: Arbeitsdokument · ungeprueft ·         │
│  nicht Gegenstand einer Anfrage                         │
│  Dateiname mit Zeitstempel                              │
│  [Laden] [Teilen] [Papierkorb]                          │
│  Getrennt von Meine Anwendungen dargestellt.            │
╰─────────────────────────────────────────────────────────╯
```
Beleg: Endnutzer-Handbuch 9.2, Abbildung 30.

```
╭─ EN-13 · Einstellungen ──────────────── [vier Bereiche] ─╮
│  Zugang: nach Anmeldung  │
│  Profil        Anzeigename · E-Mail        [Speichern]   │
│  Sicherheit    erneute Anmeldung fuer heikle Aenderungen │
│                Zugangscode nicht umstellbar              │
│  Organisation  Firma · Domaene · Anschrift · Telefon     │
│                keine Anschrift fuer Betriebsrat oder     │
│                Datenschutz                               │
│  Audit-Log     unter der Ueberschrift Compliance,        │
│                nur lesbar, keine Loeschfunktion          │
╰──────────────────────────────────────────────────────────╯
```
Beleg: Endnutzer-Handbuch 10, Abbildung 31.

```
╭─ EN-14 · Nebenfragen-Fenster ─── [getrennt vom Gespraech] ─╮
│  Zugang: nach Anmeldung  │
│  Geoeffnet durch [? Hilfe] unter dem Gespraech.            │
│  [Nebenfrage                          ] [Senden]           │
│  Der Inhalt fliesst nicht in Ihre Anwendung ein.           │
│  [? Hilfe] in der Kopfleiste erklaert dagegen die          │
│  Bedienung des Portals. Zwei gleichnamige Schaltflaechen.  │
╰────────────────────────────────────────────────────────────╯
```
Beleg: Endnutzer-Handbuch 2.3 und 11.1, ohne Abbildung.

## 7 · Sitemap und Kastenkatalog · EXMA

```
EXMA · Betriebs-Portal              (portal_code EXMA · release_status ENABLED)
│
├─ EX-01  Anmeldung — derselbe Weg, der Code entscheidet das Portal
│   └─ Code falsch ──▶ kein Portal oeffnet sich
├─ EX-02  Portalrahmen — Kopfleiste, Navigation, Arbeitsflaeche
│   ├─ EX-03  Kunden ──▶ EX-04 Kunde aufgeklappt ──▶ EX-05 Kundendialog
│   │   └─ EX-06  Neuer Kunde
│   │       └─ Pflichtfeld fehlt ──▶ Senden-Schaltflaeche ausgeblendet
│   ├─ EX-07  Apps ──▶ EX-08 App-Detail
│   ├─ EX-11  M1 Wissensregister ──▶ EX-12 Quelle aufnehmen
│   ├─ EX-13  M2 Formatvorlagen
│   ├─ EX-14  M3 KI-Agenten
│   ├─ EX-15  M4 Richtlinien
│   ├─ EX-16  Protokoll
│   └─ EX-17  Einstellungen ──▶ EX-09 Zugaenge und Nutzer ──▶ EX-10 Einladung
│       └─ letzter aktiver Admin ──▶ Loeschen ausgegraut, Versuch abgelehnt
│
ohne Anmeldung: gesperrt — jeder Aufruf ausser EX-01 endet auf EX-01.
Eine Rolle je Portal: Plattform-Admin. Kein Rechte-Baukasten.
USER_ADMIN · VAR_ADMIN · INDIA_OPS: release_status PLANNED, nicht enthalten.
```

```
╭─ EX-01 · Anmeldung ─────────────────────────── [offen] ─╮
│  Zugang: offen  │
│  E-Mail-Adresse   [                              ]      │
│  Zugangscode      [sechsstellig                  ]      │
│  Der Code entscheidet, welches Portal sich oeffnet.     │
│  [Anmelden]                                             │
╰─────────────────────────────────────────────────────────╯
```
Beleg: EXMA-Handbuch 2.1, Abbildung 1.

```
╭─ EX-02 · Portalrahmen ───────────────── [Plattform-Admin] ─╮
│  Zugang: nach Anmeldung  │
│  [Zurueck] [Hauptmenue] [-] [+] [Dark] [? Hilfe]           │
│  Plattform-Admin · exmachinAI              [Ausloggen]     │
│  NAVIGATION       |  Arbeitsflaeche                        │
│  Kunden · Apps    |                                        │
│  M1 · M2 · M3 · M4|  Der gewaehlte Bereich fuellt die      │
│  Protokoll        |  Flaeche. Nur ein Bereich zur Zeit.    │
│  Einstellungen    |                                        │
╰────────────────────────────────────────────────────────────╯
```
Beleg: EXMA-Handbuch 2.2, Abbildung 2.

```
╭─ EX-03 · Kunden ──────────────────────── [Einstiegsflaeche] ─╮
│  Zugang: nach Anmeldung  │
│  Je Zeile: Firmenname · Kunden-Code · Zustandsmarken         │
│  [Legende — was die Zustaende bedeuten]                      │
│  Die Legende erklaert jeden Zustand im Klartext.             │
│  [+ Neuen Kunden anlegen]                                    │
╰──────────────────────────────────────────────────────────────╯
```
Beleg: EXMA-Handbuch 3.1, Abbildung 3.

```
╭─ EX-04 · Kunde aufgeklappt ──────────── [Zustandsname] ─╮
│  Zugang: nach Anmeldung  │
│  Je Anwendung: Projekt-Nr. · Name · [Zustand v] ·       │
│  Angebotspreis                                          │
│  In der Auswahlliste erscheint der abgeleitete Name nur │
│  zur Anzeige und ist nicht waehlbar.                    │
│  [Stammdaten und Ansprechpartner]                       │
╰─────────────────────────────────────────────────────────╯
```
Beleg: EXMA-Handbuch 3.2, Abbildung 4.

```
╭─ EX-05 · Kundendialog ─────────────────── [Stammdaten] ─╮
│  Zugang: nach Anmeldung  │
│  STAMMDATEN   Firma · Rechtsform · Domaene · Anschrift  │
│  Kunden-Code  unveraenderlich                           │
│  ANSPRECHPARTNER  Name · Telefon · E-Mail, hoechstens   │
│  drei; die Marke zeigt eine gueltige Adresse an         │
│  [Einladungslink senden]  [+ Weitere Person]            │
│  ANWENDUNGEN  Projekt-Nr. · Zustand · Angebotspreis     │
│  [Stammdaten speichern]                                 │
╰─────────────────────────────────────────────────────────╯
```
Beleg: EXMA-Handbuch 3.2, Abbildung 5.

```
╭─ EX-06 · Neuer Kunde ───────────────────────── [Anlage] ─╮
│  Zugang: nach Anmeldung  │
│  Firmenname *     [                              ]       │
│  Vorname *        [                              ]       │
│  Nachname *       [                              ]       │
│  Telefon *        [                              ]       │
│  E-Mail *         [                              ]       │
│  Den Kunden-Code vergibt FREIRAUM.                       │
│  [Einladungslink senden] ist ausgeblendet, solange ein   │
│  Pflichtfeld fehlt oder die Adresse ungueltig ist.       │
│  [Kunde anlegen]                                         │
╰──────────────────────────────────────────────────────────╯
```
Beleg: EXMA-Handbuch 3.3, Abbildung 6.

```
╭─ EX-07 · Apps ─────────────────── [kundenuebergreifend] ─╮
│  Zugang: nach Anmeldung  │
│  [Suche ueber alle vier Spalten                     ]    │
│  Projekt-Nr. | Anwendung | Kunde | Zustand               │
│  Kein eigener Zustandsfilter in dieser Sicht.            │
╰──────────────────────────────────────────────────────────╯
```
Beleg: EXMA-Handbuch 4.1 und 4.2, Abbildung 7.

```
╭─ EX-08 · App-Detail ──────────────────── [Zustand v] ─╮
│  Zugang: nach Anmeldung  │
│  Projekt-Nr. · Name · Kunde · erstellt · offen seit   │
│  Angebotspreis  [                 ] Waehrung          │
│  Er wird erst mit [Speichern] uebernommen.            │
│  DOKUMENTE  Protokoll · Konzepte · zwei Memos · SBOM  │
│  [Alle herunterladen]  [Test-Harness laden]           │
╰───────────────────────────────────────────────────────╯
```
Beleg: EXMA-Handbuch 4.3, Abbildung 8.

```
╭─ EX-09 · Zugaenge und Nutzer ────── [nach Anmeldung] ──╮
│  Zugang: nach Anmeldung  │
│  Name | Kennung | 2. Faktor | Status | letzte Anmeldung│
│  Marken: Sie · Schloss beim versiegelten Erst-Admin    │
│  [Link erneut senden] nur bei WARTET_2FA, sonst        │
│  ausgeblendet                                          │
│  [Sperren]  [Loeschen] beim Erst-Admin ausgegraut,     │
│  bis ein zweiter aktiver Plattform-Admin besteht       │
│  Sperren des letzten aktiven Admin wird abgelehnt.     │
│  [Nutzer einladen]                                     │
╰────────────────────────────────────────────────────────╯
```
Beleg: EXMA-Handbuch 5.1 bis 5.6, Abbildungen 9 und 11.

```
╭─ EX-10 · Einladung ─────────────── [Domaenen-Schranke] ─╮
│  Zugang: nach Anmeldung  │
│  Name (freiwillig) [                            ]       │
│  E-Mail *          [                            ]       │
│  Rolle             [Plattform-Admin] ausgegraut         │
│  Nur Adressen der eingerichteten Domaene, keine         │
│  Dubletten. Einmal-Link 24 Stunden gueltig, danach      │
│  ein Code bei jeder Anmeldung.                          │
│  [Einladung senden]                                     │
╰─────────────────────────────────────────────────────────╯
```
Beleg: EXMA-Handbuch 5.4, Abbildung 10.

```
╭─ EX-11 · M1 Wissensregister ────── [Register / Entwurf] ─╮
│  Zugang: nach Anmeldung  │
│  [Register — freigegeben]  [Entwuerfe]                   │
│  Typfilter: GITHUB MCP WEB API OSS MD PDF DOCX CSV       │
│  [Suche mit Feldkuerzeln                          ]      │
│  Je Zeile: Kennung · Register-Nr. · Bereich · Domaene ·  │
│  Lizenz · Status · Modus                                 │
│  Im Entwurf: [Aendern] [Freigeben] [Zurueckziehen]       │
│  [Freigeben] bleibt bis zur neuen Datenmodell-Version    │
│  ausgeblendet; Grund: Kurzbeschreibung noch nicht speicherbar.│
╰──────────────────────────────────────────────────────────╯
```
Beleg: EXMA-Handbuch 6.1 bis 6.3, Abbildungen 12 und 13. Kurzbeschreibung und Meta-Tags bleiben Ziel der nächsten Datenmodell-Version (O-K19-4), erscheinen bis dahin aber nur in Abschnitt 11 und nicht als vorhandene Release-1-Spalten.

```
╭─ EX-12 · Quelle aufnehmen ──────────────── [zwei Wege] ─╮
│  Zugang: nach Anmeldung  │
│  [Einzeleintrag]  Typ · Adresse · Name · Bereich · Tags │
│  [Massen-Upload]  eine Zeile je Quelle                  │
│  Beide Wege legen einen Entwurf an, nie einen           │
│  freigegebenen Eintrag.                                 │
╰─────────────────────────────────────────────────────────╯
```
Beleg: EXMA-Handbuch 6.3, Abbildung 14.

```
╭─ EX-13 · M2 Formatvorlagen ──────────── [Gruppenwahl] ─╮
│  Zugang: nach Anmeldung  │
│  Gruppen: DOCUMENT · DESIGN · DIALOG · POLICY          │
│  Je Zeile: Kuerzel · Name · Version · Status ·         │
│  genutzt von                                           │
│  [Aendern] [Neue Version] [Export]                     │
│  Dialogvorlagen sind nachrichtlich — fuehrend bleibt   │
│  das Werkzeug, in dem sie gepflegt werden.             │
╰────────────────────────────────────────────────────────╯
```
Beleg: EXMA-Handbuch 7.1 bis 7.3, Abbildung 15. Der Dateiname bleibt Ziel der nächsten Datenmodell-Version (O-K19-4), erscheint bis dahin nur als offener Punkt.

```
╭─ EX-14 · M3 KI-Agenten ──────── [Anzeige, kaum Eingabe] ─╮
│  Zugang: nach Anmeldung  │
│  Drei Bloecke: TEAM · SINGLE · Hilfe, zusammen 16        │
│  Je Zeile: Name · Status · Modell · Anbieter · Hosting   │
│  Aenderbar ist hier nur die Verdrahtung zum Wissen.      │
│  Modell, Schluessel und Werkzeuge werden ausserhalb      │
│  gepflegt: [Im Werkzeug oeffnen]                         │
╰──────────────────────────────────────────────────────────╯
```
Beleg: EXMA-Handbuch 8.1 bis 8.3, Abbildung 16.

```
╭─ EX-15 · M4 Richtlinien ──────────────── [versioniert] ─╮
│  Zugang: nach Anmeldung  │
│  Je Zeile: Kennung · Name · Version · Status            │
│  Nicht freigegeben bedeutet in Pruefung.                │
│  [Neue Richtlinie]  [An das Werkzeug uebertragen]       │
╰─────────────────────────────────────────────────────────╯
```
Beleg: EXMA-Handbuch 9.1 und 9.2, Abbildung 17.

```
╭─ EX-16 · Protokoll ──────────────────── [neueste zuerst] ─╮
│  Zugang: nach Anmeldung  │
│  Filter: Kunde oder Nutzer · Projekt-Nr. · von · bis ·    │
│  Quelle PORTAL_ACTION oder MODEL_CHANGE  [Zuruecksetzen]  │
│  Je Zeile: Zeitpunkt · Projekt-Nr. · Kunde oder Nutzer ·  │
│  Aktion · Objekt · Aenderung als neu oder als Paar von    │
│  vorher und jetzt                                         │
│  Keine Loeschfunktion.  [Ausfuhr als CSV] [als SQL]       │
╰───────────────────────────────────────────────────────────╯
```
Beleg: EXMA-Handbuch 10.1 bis 10.4, Abbildung 18.

```
╭─ EX-17 · Einstellungen ─────────────────  [vier Zeilen] ─╮
│  Zugang: nach Anmeldung  │
│  Zweiter Faktor   Code per E-Mail                        │
│  Region           Verarbeitung in der EU                 │
│  Zugaenge         [Oeffnen] fuehrt nach EX-09            │
│  Kein Zugang und keine Route zur Vorfuehr-Zuruecksetzung │
╰──────────────────────────────────────────────────────────╯
```
Beleg: EXMA-Handbuch 11, Abbildung 19. Die Vorführ-Zurücksetzung ist kein Betriebsumfang und wird deshalb im Release-1-Kasten nicht als Aktion gezeichnet. K13 muss zusätzlich nachweisen, dass Route, API und Berechtigung im Produktionsartefakt fehlen (O-K19-6).

## 8 · Bildschirm → zuständiges Konzept

| Kennung | Bildschirm | verantwortliches Konzept (genau eins) | dort geregelt |
|---|---|---|---|
| EN-01 · EX-01 | Anmeldung | K03 | Einmal-Link, Code, Kontozustand |
| EN-02 | Startseite | K01 | Portallandkarte, Einstieg |
| EN-03 · EN-04 | beide Vorprüfungen | K04 | Fragen, Halt-Antworten, Ergebnis |
| EN-03a | die fünf Fragen der Vorprüfung 1 | K04 | Wortlaut der Fragen, Auswertung, Vorschlag |
| EN-04a | Zweckbestimmung | K04 | zwei Fragen, Kenntnisnahme, Halt nach Art. 5 |
| EN-05 · EN-06 | Stufe 01 und 02 | K05 | Gesprächsführung, Antwortwege |
| EN-07 | Stufe 03 | K06 | sechs Konzepte, Prüfung, Häkchen |
| EN-08 · EN-12 | Prototyp, Direkt-Prototypen | K07 | was änderbar ist, Arbeitsdokument |
| EN-09 · EN-10 | Angebot, Bestätigung | K09 | Freigabeblock, Siegel, Unverbindlichkeit |
| EN-11 | Meine Anwendungen | K01 | Anwendung als Ganzes, Fortführen |
| EN-13 · EN-14 · EX-17 | Einstellungen, beide Hilfen | K16 | Anzeigesprache, Bedienregeln, Labels |
| EX-02 | Portalrahmen | K13 | Portal und Freischaltung |
| EX-03 · EX-04 · EX-05 · EX-07 · EX-08 · EX-16 | Kunden, Apps, Protokoll | K11 | Listen, Zustandsanzeige, Ansprechpartner |
| EX-06 | Neuer Kunde | K02 | Mandant, Rechtsraum, Gültigkeit des Links |
| EX-09 · EX-10 | Zugänge, Einladung | K20 | Rollen, Sperren, Erst-Admin |
| EX-11 · EX-12 | Wissensregister, Quelle | K08 | Quellen, Register gegen Entwurf |
| EX-13 | Formatvorlagen | K18 | Vorlagengruppen, Versionen |
| EX-14 | KI-Agenten | K17 | Katalog, Modelle, Verdrahtung |
| EX-15 | Richtlinien | K21 | Anlage und Version einer Richtlinie |

Die Herkunft jeder angezeigten Spalte steht im Schema-Anhang `K19_spalten-herkunft.md`, nicht hier.

**Beleglage, ausdrücklich:** Das Inventar belegt für EXMA genau zwei Navigationseinträge — `vars` als Kunden (EX-03) und `apps` als Apps (EX-07) — und vier Modulzweige: M1 (EX-11), M2 (EX-13), M3 (EX-14) und M4 (EX-15). EX-01, EX-02, EX-05, EX-06, EX-09, EX-10, EX-12, EX-16 und EX-17 sind über die Handbuchkapitel belegt, nicht über den Build. Für ENDUSER belegt das Inventar fünf Stufen, vier lückenlose Stufenwechsel und 68 Element-Kennungen; der Schnitt in Bildschirme stammt aus dem Handbuch.

## 9 · Drei Negativlisten — die TOT-Liste

**Benennung.** Was `config/konzepte.yaml` als *TOT-Liste* führt, steht hier als
diese drei Listen: A für gestrichenen Umfang, B für Portale ohne Release-1-Umfang,
C für Zurückgestelltes. Die Begriffe bezeichnen dieselbe Sache. Der Hinweis steht
hier, weil ein blinder Leser am 31.07.2026 die Verbindung nicht herstellen konnte
und die TOT-Liste für fehlend hielt — sie war da, nur unter anderem Namen.

### 9.1 Liste A · gestrichener Umfang

| Element | Beleg (Zeile) | Vermerk |
|---|---|---|
| Golden-Set-Verwaltung | 2953 | Streichung: umgeleitet nach M1 |
| Learning-Board | 3747 | Streichung: nirgends aufgerufen |
| Break-Glass · Pending-Change | 3148 | Streichung: Eintrag entfernt |
| Statuspage | 3118 | Streichung: umgeleitet nach M4 |
| False-Negative-KPI | 3119 | Streichung: umgeleitet nach M4 |
| Rechte-Matrix | 3155 | Streichung: Eintrag entfernt, Datenbasis leer |
| Rollen-Zentrale | 6263 | Streichung: Eintrag entfernt |
| Preisliste und Deckel | 2467 | Streichung: nie aufgerufen |
| Trust Center | 2476 | Streichung: nie aufgerufen |
| Fabrik & Bausteine | 3151 | Streichung: Eintrag entfernt |
| Schwellen & Kadenzen | 3154 | Streichung: Eintrag entfernt |
| Steuerungs-Cockpit | 3152 | Streichung: Eintrag entfernt |
| Regulatorik und Releases | 3153 | Streichung: Eintrag entfernt |
| Portal-Hub | 790 | Streichung: Einstieg ausgeblendet |
| Golden-Set-Datenmodell | 9427 | Streichung: keine Oberfläche |
| Eval-Runs | 9510 | Streichung: keine Oberfläche |

Umleitungen aus dem Inventar: was nur über `k6` oder `k7` erreichbar war, ist Streichung; beide führen heute nach M1 bzw. M4.

### 9.2 Liste B · Portale ohne Release-1-Umfang

| portal_code | Regel |
|---|---|
| USER_ADMIN | `release_status = PLANNED` — modelliert, nicht gebaut, keine Vorlage für Release 2 |
| VAR_ADMIN | `release_status = PLANNED` — modelliert, nicht gebaut, keine Vorlage für Release 2 |
| INDIA_OPS | `release_status = PLANNED` — modelliert, nicht gebaut, keine Vorlage für Release 2 |

### 9.3 Liste C · zurückgestellt

| Vorgang | Regel |
|---|---|
| Service und Tickets im Produkt | zurückgestellt nach F28 — Release 1 bekommt keinen solchen Bildschirm |
| Anbindung an das externe System | zurückgestellt nach F28 — kein Partner in Release 1 |
| Die zugehörige Referenztabelle | zurückgestellt nach F28, ruht — der Bestand bleibt bei 37 Tabellen |
| Konzept K22 | zurückgestellt nach F28 — nicht freigegeben, nicht exportiert |

Liste C ist von Liste A getrennt, weil Gestrichenes nie wieder auftauchen darf, Zurückgestelltes dagegen aufgegriffen werden soll (F28). Entwurf, Drehbuch und Prüfbericht zu K22 bleiben deshalb in `arbeit/` liegen. In Release 1 erreicht der Nutzer die Unterstützung über seine Ansprechperson bei exmachinAI, wie Endnutzer-Handbuch Kap. 12 sie an drei Stellen nennt.

**Nicht zurückgestellt** sind die beiden Hilfen: die Schaltfläche in der Kopfleiste erklärt die Bedienung, die gleichnamige unter dem Gespräch öffnet EN-14. Beide sind Release-1-Umfang, ihre Regel gehört K16.

## 10 · Verweistabelle v2.2 → v2.9

| v2.2-Konzept / Klausel | Dieses Konzept | Anmerkung |
|---|---|---|
| kein Vorgänger — eine Oberflächen-Referenz gab es in v2.2 nicht | K19-M01 bis K19-M03 | neu in v2.9, Anlass ist die Diagrammpflicht F18 |
| Wireframes verteilt in den Fachkonzepten | K19-M01 | eingesammelt: gezeichnet wird nur noch hier, übernommen überall |
| Rechte-Matrix als Oberfläche | Liste A | Streichung, siehe Abschnitt 9.1 |
| Portal-Auswahl als Einstieg | Liste A | Streichung: Einstieg ausgeblendet |
| Oberflächen der drei weiteren Portale | Liste B | `release_status = PLANNED` |
| Service und Tickets | Liste C | zurückgestellt nach F28 |

**Einschränkung:** Der Vorgängerordner der ersten Iteration (`.../02_KONZEPTE_v2.2/`) ist in diesem Stand nicht vorhanden. Die Herkunft ist deshalb nicht Zeile für Zeile prüfbar; die Tabelle nennt, was aus Kanon und Inventar belegbar ist. Nachtrag beim Vier-Augen-Termin.

## 11 · Offene Punkte

| Nr. | Offener Punkt | Braucht Entscheidung von | Bis |
|---|---|---|---|
| O-K19-1 | **Geschlossen am 01.08.2026 aus der Quelle.** Fünf Stufen. `journey_phase` führt genau fünf Werte; *„Schritt 03 von 6"* ist ein Textrest der gestrichenen Stufe und bereits als CHG-K00-03 beauftragt. DDL Z. 45, 287. | — | — |
| O-K19-2 | **Entschieden am 30.07.2026 (Founder).** Die Herkunftsmarke ist statisch und je Kachel fest zugeordnet — kein Feld, kein Enum, keine Änderung am Datenmodell. Zuordnung siehe EN-07. Der Punkt geht nicht an K06. | erledigt | — |
| O-K19-3 | **Entschieden am 30.07.2026 (Founder).** „Angebot angefragt" ist ein abgeleitetes Anzeigelabel nach dem Muster F21, kein neunter `lifecycle_state`-Wert. Bedingung: Freigabeblock aus EN-09 abgeschickt, also `app.sealed_at` gesetzt (Eigentümer K01). Belegt durch das Datenmodell, das `sealed_at` als einzige Zustandsquelle dafür führt. An K16 geht nur noch die Anzeigeregel, nicht mehr die Frage. | erledigt | — |
| O-K19-4 | **Entschieden am 30.07.2026 (Founder).** Alle drei Felder werden nachgezogen, keines gestrichen: Kurzbeschreibung und Meta-Tags einer Wissensquelle an K08, Dateiname einer Formatvorlage an K18. Ausschlaggebend war die Kurzbeschreibung — sie ist nach EXMA 6.3 Bedingung der Freigabe, und eine Bedingung ohne Speicherort ist keine. **Offen bleibt allein die Umsetzung:** das Datenmodell liegt als Ground Truth fest und wird von keinem Konzept geändert; die drei Felder brauchen eine neue Datenmodell-Version. | K08, K18 + Datenmodell | vor K08 |
| O-K19-5 | **Erledigt am 30.07.2026.** Der Founder hat den erweiterten Schnitt gebilligt; `config/quellen.yaml` führt jetzt `hb_endnutzer_screendetail` und `hb_exma_screendetail`, und `config/konzepte.yaml` gibt sie K19 frei. Kap. 11.2 des Endnutzer-Handbuchs ist bewusst ausgenommen — Service und Tickets ruht (F28). | erledigt | — |
| O-K19-6 | **Zuordnung entschieden am 30.07.2026 (Founder).** Der Zugangscode der Vorführfassung und das Zurücksetzen der Vorführung (EX-17) dürfen im Betrieb nicht erreichbar sein. Die Abschaltregel gehört **K13**, weil dort `portal` und `release_status` liegen — derselbe Schaltgedanke eine Ebene tiefer. Zu schreiben ist sie dort noch. | K13 | vor K13 |
| O-K19-7 | **Geschlossen am 01.08.2026 aus der Quelle.** Ja — der Wiederversand entwertet den alten Link (WIDERRUFEN), erzwungen durch `invitation_offen_uq`. Nur der Portaltext ist richtigzustellen. DDL Z. 74–76, 596–599. | — | — |
| O-K19-8 | Ob eine erneute Anmeldung mitten in Stufe 03 das gesetzte Häkchen erhält, sagt keine Quelle. | K06 · Ziel bestätigt 30.07.2026 | vor K06 |
| O-K19-9 | **Geschlossen am 01.08.2026 aus der Quelle.** Keine Sprachumschaltung; gemeinsam entschieden mit O-K16-2. Handbuch EXMA Z. 142. | — | — |
| O-K19-10 | Für den Prototyp-Link (14 Tage) und die Löschung (90 Tage) aus F11 zeigt kein Bildschirm eine Frist. Anzeigeort offen. | K15 · Ziel bestätigt 30.07.2026 | vor K15 |
| O-K19-11 | Zahl der Fragen auf EN-03a: K04 Klausel M02 (Z. 39) sagt „höchstens fünf kurze Fragen", K04 Klausel M22 (Z. 59) sagt „genau fünf Fragen", Endnutzer-Handbuch 3.1 (Z. 172) sagt „bis zu fünf kurze Fragen". Ob der Kasten fünf Fragen fest zeigt oder einen Abbruch vor Frage 5 zulässt, ist nicht belegt. | K04, hilfsweise K00 | vor dem Bau |
