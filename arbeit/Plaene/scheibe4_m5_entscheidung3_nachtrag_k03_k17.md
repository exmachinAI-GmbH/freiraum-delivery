# Scheibe 4 · M5 — Nachtrag zu Entscheidung 3: zwei Konzepte lagen außerhalb des Suchraums

**19.08.2026 · Erweiterung der Vorschlagsliste · noch nicht gezeichnet**

## Der Befund in einem Satz

**Blatt 100 hat den Suchraum aus der falschen Datei gezogen** — aus dem Bildschirmvertrag statt
aus den Klauseln selbst. Nachgemessen und nachgeholt: **zehn Klauseln aus K03 und K17** gehören
in die Liste, zwei davon **tragend**.

## Wie der Suchraum entstanden ist — und wo er endet

Blatt 100 §5.1 zählte, welche Konzepte der EN-05/EN-06-Block von `K19_screens.yaml` nennt, und
kam auf sechs: K01, K02, K04, K06, K10, K13. Daraus entstand die Liste der 35 (Entscheidung 3).

**Der Bildschirmvertrag ist aber nicht die einzige Stelle, an der M5 auf fremde Zuständigkeit
verweist.** Die **Klauselwortlaute von K05** tun es auch — gemessen am 19.08.2026 über
`register.json`:

| in K05-Wortlauten genannt | Nennungen | im Suchraum von Blatt 100? |
|---|---:|---|
| K01 | 13 | ja |
| **K17** | **3** — K05-M22 *„Agentenbetrieb K17"*, K05-M23 *„Modellpfad K17"*, K05-D09 | **nein** |
| K19 | 3 | ja (über `K19-M06`) |
| K16 | 2 | nein |
| K13 · K02 · K10 | je 2 | ja |
| **K03** | **2** — K05-M25 *„je Beitrag `actor.id` (Eigentümer K03)"*, K05-M28 | **nein** |
| K08 · K20 | je 1 | nein |
| K06 | 1 | ja |

**K16, K08 und K20 bleiben draußen — und zwar mit Beleg, nicht aus Bequemlichkeit.** Die
Klauseln, die sie nennen, grenzen ausdrücklich ab: K05-G10 *„Portal-Hilfe und Nebenfragen-Fenster
… gehören K16. **K05 nennt sie nur als Abgrenzung**"*; K05-G09 *„Eine im Interview angehängte
Datei ist eine Antwort, kein Wissensmodul. Das Register der Quellen führt K08"* — und der Anhang
ist nach Blatt 100 E4 ohnehin zurückgestellt; K05-M17 *„MUSS über die Einladung laufen, die K20
führt … **K05 löst sie aus und beschreibt sie nicht**"*.

**K03 und K17 grenzen nicht ab, sie verlangen etwas.** Deshalb sind genau diese beiden
nachgeholt worden.

## Wie nachgeholt wurde

Dasselbe Verfahren wie bei den 35: je Konzept ein **Sucher**, der nur aufnehmen durfte, was er
an einer konkreten Aktion oder einem konkreten Zustand aus EN-05/EN-06 festmachen kann, danach
je Konzept ein **Widerleger** mit dem Auftrag zu kippen, im Zweifel `false`.

| | K03 (50 Klauseln) | K17 (79 Klauseln) | zusammen |
|---|---:|---:|---:|
| vorgeschlagen | 11 | 19 | **30** |
| **gekippt** | 8 | 14 | **22 — 73 %** |
| gehalten | 3 | 5 | **8** |
| vom Widerleger nachgetragen | 1 | 1 | **2** |
| **Vorschlag** | 4 | 6 | **10** |

> **73 Prozent gekippt — mehr als die 49 Prozent der ersten Runde.** Das ist kein schlechter
> Sucher, sondern die Lage: In K17 stehen 79 Klauseln über Agentenbetrieb, von denen die meisten
> Manifest, Katalog, Telemetrie und Freigabe betreffen — also EXMA-Portal und Betrieb, nicht
> zwei Kundenbildschirme. Der häufigste Kippgrund war nicht *erfunden*, sondern **schon
> abgedeckt**: `K17-M21` ist buchstabengleich `K01-M16`+`K01-M17`, `K17-M05` ist die schwächere
> Kopie von `K13-M22`, `K17-M24` ist `K13-M13` mit *Agentenaufruf* an der Stelle von
> *Schnittstelle*. Alle drei stehen bereits in der Liste der 35.

## Die zehn

### Tragend — ohne sie ist M5 falsch gebaut

| Klausel | Worum es geht | Ausgelöst von |
|---|---|---|
| **`K03-M20`** | Der Zustandsnachweis führt `actor.id` revisionsfest; `actor_label` ist bloße Anzeige und **kein Identitätsnachweis** | EN-05 · `thema_waehlen` · Erfolg (*„Thema als Beitrag im INTERVIEW_PROTOCOL-Stand"*) und EN-06 · `zwischenspeichern` · Erfolg. K05-M25 nennt *„je Beitrag `actor.id` (Eigentümer K03)"* — **die Stelle, an der der Gesprächsstand die handelnde Person überhaupt belegt** |
| **`K17-M23`** | Jede Agentenausgabe wird einem **menschlichen Entscheidungspunkt** vorgelegt; **kein Agent schließt eine Stufe ab** | EN-05 · `ausgangsproblem_bestaetigen` · Erfolg · EN-05 · `name_bestaetigen` (Vorschlag im überschreibbaren Feld → `journey_phase` ORIENTIERUNG → INTERVIEW) · EN-06 · `interview_beenden` (→ UEBERSICHT). Beide Stufenwechsel hängen an einer Handlung der Person, nie an einer Modellausgabe — **keine Klausel der 35 trägt diese Kante** |

### Mitwirkend

| Klausel | Worum es geht | Ausgelöst von |
|---|---|---|
| `K03-D01` | Kein Vorgang ohne gültige Sitzung und `status = AKTIV`; `WARTET_2FA` und `GESPERRT` werden abgelehnt, nie als Teil-Zugang | die zweite Hälfte des M5-Satzes: **neu anmelden**, weitermachen |
| `K03-D11` | Authentisierungs-, Domänen- und Fehlerentscheidungen hängen **nicht** von einem Sprachmodell ab; ein KI-Ausfall verschiebt die sichere Entscheidung nicht | EN-06 · `freitext_antworten` · Fehler (*„Maskierung oder Modellpfad unvollständig — kein Aufruf"*) |
| `K03-M03` **(nachgetragen)** | `display_name` ist gesetzt — der Name, der in der Teilnehmerliste steht | EN-06 · `vorschlag_waehlen` · laden (*„rechts stehen bis dahin nur die Teilnehmer"*, K05-M16). **Gegenstück zu K03-M20: der Name ist Anzeige, `actor.id` ist der Nachweis** |
| `K17-D03` | `OFFEN` bei Hosting oder Anbieter ist **kein Betriebszustand, sondern eine fehlende Angabe** — der Aufruf unterbleibt | EN-06 · `freitext_antworten` · Fehler. Der einzige im Wortlaut benannte **Wert**, an dem dieser Fehlerzustand scheitert; `K13-M22` bindet *Region*, aber nicht *Hosting* |
| `K17-M06` | Das Modellpfad-Tor wird **vor jedem Aufruf** geprüft, nicht nur beim Anlegen; eine nachträglich entfallene Angabe sperrt den nächsten Aufruf | EN-06 · `freitext_antworten` · Erfolg (*„vor jedem Modellaufruf"*). Zählt für M5, weil das Gespräch über eine Abmeldung hinweg fortgesetzt wird |
| `K17-D13` | Ein Agent führt Daten zweier Mandanten nicht zusammen — **auch nicht verdichtet und nicht als Beispiel in einer Eingabe** | zieht den Mandantenschnitt in den **Prompt**; K01-M15, K02-M20, K13-M08, K05-M27 regeln Zeile und Zugriff, keine den Prompt |
| `K17-M07` | Zulässig sind allein die Hosting-Werte `AZURE_EU` und `ON_PREM_DE` | der **Stimmweg**: EN-06 · `freitext_antworten` nennt diktierten Text, K05-D09 verlangt dafür *„Verarbeitung im EU-Raum (K13 Abschn. 3, K17)"* — **ohne selbst einen Wert zu nennen.** Den liefert erst K17-M07 |
| `K17-M02` **(nachgetragen)** | Der Agentenname ist plattformweit eindeutig und ist der **fachliche** Bezeichner; die technische Kennung ist keine Anzeige | EN-06 · `vorschlag_waehlen` · laden in Verbindung mit K05-M16 (*„den Assistenten als Moderator"*) — hier erscheint ein Agent erstmals namentlich auf einem Kundenbildschirm |

## Was dieser Nachtrag nicht sagt

- **Er ersetzt Entscheidung 3 nicht, er erweitert sie.** Gezeichnet wird die Liste als Ganzes:
  **35 + 10 = 45** mitwirkende Klauseln.
- **Er behauptet nicht, der Suchraum sei jetzt vollständig.** Geprüft sind die Konzepte, die
  K19 nennt **und** die K05 nennt. Nennt eine der 45 mitwirkenden Klauseln ihrerseits ein
  weiteres Konzept, ist auch das nicht geprüft — diese Kette wurde **nicht** verfolgt. Wo sie
  endet, ist eine Entscheidung, keine Messung.
- **Die Gewichtung bleibt Vorschlag.** *tragend* gegen *mitwirkend* ist eine Einschätzung.

---

*Verfahren am 19.08.2026: vier Agenten (Sucher K03, Sucher K17, Widerleger K03, Widerleger K17),
je auf einem eigenen Lauf, Klauselwortlaute aus dem im Repo mitgeführten
`nachweise/klauselregister/register.json`, Bildschirmvertrag aus `schema/K19_screens.yaml`
Zeile 280–378. Die Konzept-Fabrik wurde nicht angefasst. Die Zählung der Konzeptnennungen in
K05-Wortlauten ist über alle 56 K05-Zeilen des Registers gemessen, nicht geschätzt.*
