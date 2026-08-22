# Tor 3 · Fremdreview — Fundament (M1)

<!-- KOPF · maschinell gelesen, Feldnamen nicht ändern -->

| Feld | Wert |
|---|---|
| scheibe | `fundament` |
| datum | `2026-08-22` |
| geprueft_commit | `9f893108ebf51f5f97d38b94ad1c174e5745fce7` |
| pruefendes_modell | `GPT-5.6 Sol` |
| pruefende_fassung | `gpt-5.6-sol, Fassung 2026-07-09, über Azure AI Foundry, EU-Datenzone` |
| frische_instanz | `ja` |
| getrennter_kontext | `ja` |
| gegen_roh_evidenz | `ja` |
| evidenz | `nachweise/kettenlauf/260822_2129_alle/` (30 Dateien im Wortlaut) · `SOLL_zielbestand_M1.md` · `AUFLAGEN_M1_260822.md` · `arbeit/Vorlagen/m1_startklar_260820.md` · `arbeit/Vorlagen/zeichnung_M7-M10_260815.md` |
| angefordert_von | `M. Veil` |
| harness_hat_nicht_geschrieben | `ja` |
| urteil | `traegt mit auflagen` |

<!-- ENDE KOPF -->

## Zeichnung der Anforderung

Ich habe dieses Review bei einer **frischen Instanz** mit **getrenntem Kontext** angefordert,
die vorgelegte Roh-Evidenz benannt, und das Urteil unverändert übernommen. Der Harness hat
es nicht geschrieben.

| Name | Datum | Unterschrift |
|---|---|---|
| M. Veil | 2026-08-22 | gez. M. Veil |

**Vorgeschichte, damit sie nicht fehlt:** Diesem Urteil gingen am selben Tag zwei Runden
voraus, beide „trägt nicht". Die erste erging gegen einen Auszug der Evidenz, die zweite
gegen eine unvollständige Vorlage. Erst die dritte lag gegen die vollständige Roh-Evidenz vor.

## Urteil des Fremdmodells


## 1. Kurzurteil

**URTEIL: trägt mit Auflagen.** Die fünf beanstandeten Punkte O-4 bis O-8 sind auf Ebene der vorgelegten Dokumentation geschlossen; der Lauf belegt den gezeichneten Umfang und einen unveränderten zweiten Durchgang. Offen bleiben die ausdrücklich getragenen Auflagen A-1 bis A-3 sowie die technische Rückverfolgbarkeit der geprüften Dateihashes auf Commit `9f89310`.

## 2. Befunde

### Die fünf Punkte

| Punkt | Ergebnis | Schwere · Stelle im Text · Begründung |
|---|---|---|
| **O-4** | **geschlossen** | **P2** · Abschnitt C.4 und B „Ergebnis je Beleg“ · Der berichtigte Solltext unterscheidet nun eindeutig: Grundschema einmal, M30–M32 als Kette zweimal. Das stimmt mit „3 Migration(en) je zweimal“ im Laufnachweis überein; der frühere Widerspruch ist mit Berichtigungsvermerk benannt. |
| **O-5** | **geschlossen** | **P2** · Abschnitt B „Was gefahren wurde“ sowie A, Zeichnung Zeile 3 · Host, Port, Datenbank, Konto und `sslmode=require` werden laufbezogen für den Lauf vom 22.08.2026 genannt. Die Zielumgebung und das Konto `frxadmin` sind zusätzlich im gezeichneten Blatt A zugeordnet. Das ist dokumentarisch belegt, allerdings nicht durch einen vorgelegten serverseitigen Verbindungs- oder Rollenabzug unabhängig nachprüfbar. |
| **O-6** | **geschlossen** | **P2** · Abschnitt A, „Zeichnung“, insbesondere Zeilen 1–3 und Nachtrag zu 10.3 · Umfang B, die übernommenen Pfade und der ausgeführte Lauf sind ausdrücklich gezeichnet. Rang 1 wird als Grundschema plus M30, M31 und M32 festgelegt. |
| **O-7** | **geschlossen** | **P2** · Abschnitt C.7 · Die Differenz zwischen 3.337/166 und 3.947/237 wird durch unterschiedliche Zählweisen erklärt. Der zusätzliche Fehler in `zaehle_aenderungen()` wird konkret benannt; er berührt nach den vorgelegten Zahlen nicht die tragende Aussage, dass Lauf 1 eine Änderung größer null erzeugt hat. |
| **O-8** | **geschlossen** | **P2** · Abschnitt D, „Zeichnung“ · A-1, A-2 und A-3 sind einzeln benannt, einem Träger zugeordnet, mit einem Fristereignis versehen und durch M. Veil als Auftraggeber gezeichnet. Sie sind damit getragen, aber ausdrücklich nicht erledigt. |

### Tragende Messung von M1

**P2 · Abschnitt B, Beleg 1; Abschnitt E, Vergleichsdateien und Datenzeilen ·** Der Text weist für Lauf 1 nichtleere Unterschiede und für Lauf 2 leere `schema_diff.txt` und `daten_diff.txt` aus. Die Datenzählung bleibt zwischen Lauf 1 und Lauf 2 bei 82 Zeilen; zudem werden M30, M31 und M32 als jeweils zweimal gefahren angegeben. Daraus folgt innerhalb der vorgelegten Nachweiskette: Der erste Migrationsdurchgang wirkte, der zweite änderte den verglichenen Schema- und Datenbestand nicht.

### Gezeichneter Zielumfang

**P2 · Abschnitt A, Punkt 10.3; Abschnitt C.4 ·** Der maßgebliche Umfang ist ausdrücklich auf Grundschema plus M30, M31 und M32 erweitert. Der Lauf wurde laut NACHWEIS mit genau diesen vier Eingängen durchgeführt; die vier SHA-256-Werte sind angegeben. Damit stimmen gezeichneter Umfang und dokumentierter Laufumfang überein.

### Auflage A-1 ist für M1 begrenzt, nicht tragend offen

**P2 · Abschnitt C.3 und C.6; Abschnitt D, A-1 ·** Der Text grenzt M1 ausdrücklich auf den Aufbau einer frischen Datenbank und nicht auf die Migration vorhandener Bestandsdaten ein. Deshalb widerlegt der nur an leeren Tabellen gemessene Beleg 4 den hier definierten M1-Zustand nicht. Die kombinierte Prüfung mit vorhandenen Zeilen bleibt gleichwohl ungemessen und ist nachvollziehbar bis M11 getragen.

### Auflage A-2 betrifft eine noch nicht nachgezogene Sollreferenz

**P2 · Abschnitt C.5; Abschnitt D, A-2 ·** `bestand_pilot` beschreibt weiterhin den Stand M30 mit 27 Funktionen, während der gezeichnete Umfang M30 bis M32 und der Lauf 29 Funktionen umfassen. Der Widerspruch ist erklärt und als Dokumentationsnachlauf getragen. Er verhindert die Aussage zu M1 nicht, weil der ältere Kanonblock ausdrücklich als alter Maßstab gekennzeichnet und der neue Umfang separat gezeichnet ist.

### Auflage A-3 betrifft einen fortbestehenden Textwiderspruch

**P1 · Abschnitt A, Punkt 10.3 b; Abschnitt D, A-3 ·** Der Bauauftragstext führt weiterhin die alte Rangfolge. Der Text löst dies vorläufig durch die jüngere, ausdrückliche Zeichnung auf und trägt die redaktionelle Berichtigung bis vor den nächsten Meilenstein, der Rang 1 verwendet. Damit ist der Widerspruch nicht behoben, aber benannt, hierarchisch behandelt, zugeordnet, terminiert und gezeichnet.

### Abnahmestand und geprüfte Dateien sind nicht vollständig technisch verkettet

**P1 · Kopf der Evidenz; Abschnitt B „Prüfsumme jeder eingespielten Datei“ ·** Als Abnahmestand wird Commit `9f89310` zuzüglich zweier nicht gemergter Blätter genannt. Der Laufnachweis nennt zwar SHA-256-Werte der vier SQL-Eingänge, zeigt aber nicht, dass genau diese Hashes dem Inhalt von Commit `9f89310` entsprechen oder welche zwei Blätter außerhalb des Commits liegen. Das ist eine Rückverfolgbarkeitslücke der Vorlage; die gemessene Laufwirkung selbst wird dadurch nicht widerlegt.

### Auflagen und offene Punkte

| Punkt | Zustand | Träger | Frist laut Text |
|---|---|---|---|
| **A-1** · Beleg 4 mit vorhandenem Bestand wiederholen | getragen, offen | A. Han | mit M11 |
| **A-2** · `bestand_pilot` auf 29 Funktionen nachziehen | getragen, offen | M. Veil über Konzept-Fabrik/F6 | vor der nächsten Konzeptprüfung, die Objektzahlen nennt |
| **A-3** · alte Rangfolge im Auftragstext berichtigen | getragen, offen | M. Veil, Arbeitspaket A-1 | vor dem nächsten Meilenstein, der sich auf Rang 1 beruft |
| Zuordnung der SQL-Hashes zu Commit `9f89310` | dokumentarisch nicht nachgewiesen | im Text nicht zugeordnet | im Text keine Frist |

## 3. Was ich nicht beurteilen kann

- **Tatsächliche Verbindung zur angegebenen Zielumgebung:** Es fehlt ein unabhängiger Rohbeleg der aktiven Sitzung, etwa die Ausgabe von Server-, Datenbank-, Benutzer- und SSL-Abfragen. Ich kann nur feststellen, dass NACHWEIS.md und die Zeichnung diese Werte angeben.
- **Rollenstatus von `frxadmin`:** Es fehlt ein vorgelegter Rollenabzug für den Laufzeitpunkt. Daher kann ich technisch nicht nachprüfen, dass `frxadmin` tatsächlich kein SUPERUSER war.
- **Übereinstimmung mit Commit `9f89310`:** Es fehlt die Zuordnung der vier angegebenen SQL-Hashes zum Inhalt dieses Commits sowie eine eindeutige Benennung der zwei nicht gemergten Blätter.
- **Vollständigkeit der Schema- und Datenabzüge:** Die Befehle und Filter, mit denen die Dumps erzeugt wurden, liegen nicht vor. Deshalb kann ich nicht beurteilen, ob sämtliche zustandsrelevanten Datenbankobjekte und Datenarten vom Leer-Diff erfasst werden.
- **Authentizität der übertragenen Zeichnungen:** Vorgelegt sind dokumentierte Weisungszitate und eingetragene Zeichnungen, aber keine extern prüfbaren Signaturen. Ihre Echtheit kann ich anhand des Textes nicht unabhängig feststellen.
