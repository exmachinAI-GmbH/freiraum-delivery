# M5 · Was vor dem ersten Bauzug noch fehlt — **acht Sperren, gemessen**

**19.08.2026 · Vorlage zur Entscheidung · noch nicht gezeichnet**

Blatt 100 ist gezeichnet, die sechs Entscheidungen sind ausgeführt, die Akzeptanzkriterien
liegen vor. Bevor der erste Bauzug fällt, ist dieselbe Vorbereitung noch einmal **gegen sich
selbst** geprüft worden: drei adversariale Linsen (Klausellage · Sperren und Vorbedingungen ·
Prüfbarkeit), danach eine Zusammenführung, die **jeden Beleg selbst nachgeschlagen** und sechs
Befunde wieder verworfen hat.

**Ergebnis: 23 belegte Lücken — 8 sperren den Bauzug, 14 verzögern ihn, 1 Anmerkung.**

> **Fünf der acht Sperren sind vom Harness selbst noch einmal nachgemessen** (Abschnitt 4).
> Die übrigen tragen den Beleg der Prüfung; wer sie entscheidet, sollte ihn aufschlagen.

---

## 1 · Die acht Sperren

### S-A · Der zeilengenaue Zugriffsschutz existiert nicht

| | |
|---|---|
| **Was fehlt** | Der Bildschirmvertrag beruft sich für die zentrale Schreibaktion von EN-06 **wörtlich** auf RLS. Im Repo gibt es **kein einziges** `ENABLE ROW LEVEL SECURITY` und **kein** `CREATE POLICY`. `K02-M20` und `K13-M08` — beide tragend in der Liste — verlangen die Grenze ausdrücklich **zweifach**: im Serverpfad *und* im Datenbestand |
| **Beleg** | `grep -rniE 'row level security\|create policy' --include='*.sql'` über das ganze Repo: **null Treffer** (selbst nachgemessen). `M30:1713–1716` im Wortlaut: *„WAS HIER AUCH NICHT STEHT: das vollständige RLS-Regime … die Zeilenregeln je Tabelle sind Punkt 09 und bleiben offen."* Und der einzige gebaute Wächter lässt durch: `M30:2166–2172` *„IST DIE EINSTELLUNG NICHT GESETZT, lässt der Wächter durch … Der Serverpfad setzt sie heute noch nicht."* |
| **Warum es sperrt** | Entscheidung 2 führt `document.app_id → app.tenant_id` als *vorhanden*. Das ist eine **Spaltenbeziehung, kein durchgesetzter Zeilenschutz.** Ein M5, das darauf baut, erfüllt die halbe Klausel und meldet die ganze |
| **Nächster Schritt** | Entscheiden, ob **Punkt 09** (RLS-Regime) mit M5 gezogen wird — oder M5 ausdrücklich als Bau **ohne** die zweite Hälfte der Mandantengrenze fahren, mit anschlagendem Gate. Unabhängig davon festschreiben, dass jeder der zehn Serverbefehle `freiraum.tenant_id` setzt |
| **Entscheider** | **Founders** (Terminierung gegen den 31.08.), Ausführung Bau |

### S-B · `K05-G12` sperrt den Produktivweg — und drei Dateien führen drei verschiedene Stände

| | |
|---|---|
| **Was fehlt** | Gezeichneter Wortlaut: *„Solange O-K05-1 und O-K05-2 offen sind, bleibt K05 Freigabekandidat … **der Produktivweg bleibt gesperrt**."* `K05-G11` verbietet ausdrücklich, eine als offen ausgewiesene Zeile stillschweigend als Träger anzunehmen. **In keinem der vier M5-Papiere kommt eine der beiden Kennungen vor** |
| **Beleg** | `register.json` K05-G12 (K05 v1.3:105), K05-G11 (:104). Die Berichtigung liegt **unentschieden** bei der Konzept-Fabrik (`arbeit/an_konzeptfabrik/K05_abschnitt5_nachziehen.md`, vorgelegt 19.08.). Eine dritte Datei führt sie schon als erledigt: `arbeit/Vorlagen/sichtung_offene_konzeptpunkte_260816.md:243` — *„geschlossen — die Sperre greift nicht mehr"* (selbst nachgemessen) |
| **Nächster Schritt** | K05 Abschn. 5 nachziehen **oder** `K05-G12` ausdrücklich als erfüllt kennzeichnen — und die drei Stände auf einen bringen |
| **Entscheider** | **M. Veil** als Eigentümer der Konzept-Fabrik. Der Harness darf die Datei nicht anfassen |

### S-C · Für die Klauseln von M5 ist kein fachlicher Eigentümer bestimmt

| | |
|---|---|
| **Was fehlt** | `K23-M02`: Das Kriterium liefert der **fachliche Eigentümer**. Gemessen über die **101** Klauseln der M5-Lage: **11 mit Eigentümer**, 90 ohne. Die Eigentümerzuweisung vom 16.08.2026 ist ausdrücklich auf den **Teilschnitt bis zur Anmeldung** eingeengt — K05, K03 und K17 liegen außerhalb |
| **Beleg** | `register.json`, Feld `eigentuemer` über die M5-Menge (selbst nachgemessen: 11 von 101). `eigentuemer_zuweisung_260816.md`, Weisung im Wortlaut |
| **Warum es sperrt** | **Die Kriterien sind geschrieben, aber niemand kann sie zeichnen.** Blatt 100 E5 verlangt die Zeichnung vor dem Bauzug — der Zeichnungsschritt hat heute keinen Adressaten |
| **Nächster Schritt** | Die Einengung für K05, K03, K17 und die übrigen M5-Klauseln aufheben und je Klausel einen Namen eintragen |
| **Entscheider** | **M. Veil** (die Einengung ist seine gezeichnete Weisung) |

### S-D · K11 ist nie geprüft worden — und entscheidet den Migrationszuschnitt

| | |
|---|---|
| **Was fehlt** | `K01-M21` steht **tragend** in der Liste und lautet vollständig: *„Der Protokolleintrag gehört `event` (K02), die Verlaufszeile `app_state_history` und der Sicht `app_state_aktuell` (**beide K11**)."* **K11 kommt in keinem der vier Papiere vor.** `K11-M10` verlangt, dass jeder Zustandswechsel Verlaufszeile **und** Protokolleintrag atomar schreibt — Entscheidung 2 plant die neue Funktion **ohne Verlaufszeile** |
| **Beleg** | `register.json` K01-M21 (selbst nachgemessen, Wortlaut oben), K11-M10, K05-D11, K11-D08. `M30:725–727`: der Verlaufszeilen-Trigger feuert `AFTER INSERT OR UPDATE OF lifecycle_state` — **nicht** bei `journey_phase`; `app_state_history.state` ist vom Typ `lifecycle_state` und kann eine Stufe gar nicht aufnehmen |
| **Warum es sperrt** | Es ist genau die Stelle, an der Entscheidung 2 den Zuschnitt festlegt: *„genau eine Funktion"*. Gilt K11-M10 auch für den Stufenwechsel, fällt dieser Zuschnitt — und das Schema braucht eine Erweiterung |
| **Nächster Schritt** | Vor dem Migrationszug entscheiden, ob `K11-M10` auch für den Stufenwechsel gilt. Gilt sie nur für `lifecycle_state`, ist **das** eine Auslegung und gehört gezeichnet |
| **Entscheider** | fachlicher Eigentümer K01/K11 (Auslegung) · **Founders** (Aufnahme von K11 in die Klauselliste) |

### S-E · Der Träger der Protokolldatei ist ungezeichnet, und die CI hat keinen Objektspeicher

| | |
|---|---|
| **Was fehlt** | M5 hängt an `K05-M26`: *„erzeugt zuerst die Datei, dann die `document`-Zeile, dann `event`."* Die CI kennt genau **einen** Dienst: Postgres. Weder Objektspeicher noch Attrappe. Der Datenbestand allein kann *Datei vorhanden* nicht von *Datei nicht vorhanden* unterscheiden — `content_ref` ist eine nullable `text`-Spalte ohne Fremdschlüssel |
| **Beleg** | `.github/workflows/tore.yml`: `services:` nur in zwei Jobs, beide `image: postgres:16` (selbst nachgemessen); kein Treffer für minio/azurite/s3/blob. `M30:491–501` |
| **Nächster Schritt** | **Zeile A des Ablage-Nachtrags zeichnen** (privater Objektspeicher, Attrappe hinter derselben Schnittstelle im Prüfstand) und die Attrappe **vor** dem ersten Klausellauf bauen — sonst sind die Prüffälle zu K05-M25, K05-M26, K05-M15 und K10-M03 nach `K23-M22` **von Anfang an gesperrt** |
| **Entscheider** | **Founders** / Betriebsrahmen K13 (Träger) · fachlicher Eigentümer (die Zahl hinter *kurzlebig*) · Bau (Attrappe) |

### S-F · Der Blindstand liefert dem Prüf-Agenten das Gegenteil seiner Rolle

| | |
|---|---|
| **Was fehlt** | `werkzeuge/blindstand.sh` exportiert `pruefungen` **und `schema`** und sperrt alles übrige. Die Rollendatei sagt das Umgekehrte: gelesen werden dürfen **ausschließlich** die Klauseldateien unter `nachweise/klauselregister/` und `pruefungen/klauseln/`; **nie gelesen** wird unter anderem **`schema/`** |
| **Beleg** | `werkzeuge/blindstand.sh` (`git archive HEAD pruefungen schema`) gegen `.claude/agents/pruef-agent.md:55` und `:57` — beide selbst nachgelesen |
| **Warum es sperrt** | Der Prüf-Agent bekäme die DDL, die er nicht sehen darf, und **verlöre die einzige mitgeführte Quelle der Klauselwortlaute** (`register.json` liegt unter `nachweise/`). Die 101 M5-Klauseln wären im Blindstand nicht nachschlagbar. **Das Werkzeug ist heute erst gebaut worden — der Befund betrifft die eigene Arbeit dieses Tages** |
| **Nächster Schritt** | `blindstand.sh` vor Tor 2 berichtigen: `nachweise/klauselregister/` hinein, `schema/` heraus — oder die Rollengrenze ausdrücklich ändern, wenn der Bildschirmvertrag als Quelle gelten soll |
| **Entscheider** | Bau · die Rollengrenze selbst ändert nur, wer sie gezeichnet hat |

### S-G · Zwölf Themen, drei Einordnungsfragen, sieben Ziele — die Zahl steht im Vertrag, der Inhalt nirgends

| | |
|---|---|
| **Was fehlt** | EN-05 verlangt *„zwölf Themen geladen"* und *„Mehrfachauswahl aus sieben Zielen"*. **Keine Position dieser Listen steht irgendwo im Repo.** Der K19-Kasten nennt nur die Schrittfolge; `seeds/` enthält den K04-Seed und Welle 1 (selbst nachgesehen) |
| **Nächster Schritt** | Die zwölf Themen, die drei Einordnungsfragen und die sieben Ziele **im Wortlaut** festlegen und als versionierte Konfigurationsdaten ablegen, bevor EN-05 gebaut wird |
| **Entscheider** | **fachlicher Eigentümer K05.** Der Harness darf die Listen nicht erfinden |

> Entscheidung 2 erklärt `O-K05-6` für geschlossen und empfiehlt `seeds/` als **Ablageform** — den **Inhalt** liefert sie nicht. Das Kriterium ist trotzdem schreibbar (die Zahl ist zählbar); **der Bildschirm ist es nicht.**

### S-H · Für keine der elf Aktionen existiert eine Fehlermeldung im Wortlaut

| | |
|---|---|
| **Was fehlt** | Bauauftrag §9 Tor I Nr. 6 verlangt die **erwartete Fehlermeldung im Wortlaut** als Teil der Evidenz. Die elf `zustand_fehler`-Zeilen beschreiben **Verhalten** (*„abgewiesen, bisherige Antworten bleiben unverändert"*), nennen aber **keinen Meldungstext**; die K19-Build-Referenz führt keinen Meldungskatalog |
| **Beleg** | alle elf `zustand_fehler`-Zeilen des Vertrags. Gegenbeispiel, wie es aussähe: `M30:1960` — `RAISE EXCEPTION 'ZUSTANDSWECHSEL: Anwendung % existiert nicht (K01-M28)'` |
| **Nächster Schritt** | Vor der Zeichnung der Kriterien festlegen, ob der Meldungswortlaut **Teil des Kriteriums** ist (dann liefert ihn der Eigentümer) oder eine nachgereichte Bauentscheidung — sonst wird er **erfunden** oder der Negativfall bleibt unvollständig |
| **Entscheider** | **Founders** (Auslegung der eigenen Torbedingung) · Wortlaut vom fachlichen Eigentümer |

---

## 2 · Die vierzehn, die verzögern

| | Lücke | Nächster Schritt | Entscheider |
|---|---|---|---|
| V-1 | **Der Stimmweg** ist durch K05-D12, K05-M30 und K05-G12 dreifach gesperrt, steht aber im Vertrag — und trägt zugleich die Begründung für die Aufnahme von `K17-M07` | wie den Anhang mit *„Stufe: zurückgestellt"* führen, oder als *ausgeblendet, Serverpfad weist ab* in den Vertrag aufnehmen | Founders |
| V-2 | **`K05-M32` verlangt einen Wiederaufnahmezustand** — der Vertrag führt vier Zustände, das Wort *Wiederaufnahme* kommt in `K19_screens.yaml` nicht vor, und die Datei ist prüfsummenversiegelt | entscheiden, ob EN-06 einen fünften, eigens benannten Zustand führt (dann Vertrag **und** Prüfsumme nachziehen) | Eigentümer K05 + K19 |
| V-3 | **`K05-D06` fehlt in der Liste** — sie verbietet das Anspringen von Stufen und lässt zurückliegende Stufen nur als Nur-Ansicht zu: die Navigationsregel für genau den Vorgang, an dem M5 nachgerechnet wird | in die zu zeichnende Klauselliste aufnehmen | Founders |
| V-4 | **K20 wurde nur gegen `K05-M17` abgegrenzt** — `K02-M21` (tragend) nennt K20 Abschn. 3 als **benannte Ausnahme** von der Mandantengleichheit | K20 Abschn. 3 nachziehen oder festhalten, dass der Betreiberzugriff in M5 nicht vorkommt | Founders · Eigentümer K02 |
| V-5 | **K15 ist nie geprüft**, obwohl `K01-M17` es nennt: *„die Rückauflösung … ihre Aufbewahrung führt K15"*. Für die Maskierung ist kein Träger gemessen | klären, ob der Maskierungspfad einen aufbewahrten Träger braucht — **fällt er an, kippt der Migrationszuschnitt ein zweites Mal** | Eigentümer K15/K17 · Founders |
| V-6 | **`K05-M09` verlangt drei gleichrangige Antwortwege**, E4 streicht einen. Für diesen Teilfall gibt es keine Regel; der Vorschlag hat ihn bereits ausgelegt | festlegen, wie eine MUSS-Klausel behandelt wird, die eine zurückgestellte Aktion nur **teilweise** betrifft | Founders |
| V-7 | **Tor 1b zählt die Negativfälle über alle Migrationen zusammen** (`if [ "$anzahl" -lt 4 ]`; heute liegen acht dort). Eine neue M5-Migration käme **ohne einen einzigen eigenen** durch — selbst nachgemessen | den Riegel je Migration zählen lassen, vor dem ersten M5-Migrationszug | Bau |
| V-8 | **Kein Weg von der Klausel zum Prüffall** — die Läufe melden je Datei; `test` ist in allen 1231 Zeilen leer | die Zuordnung herstellen, bevor eine Abdeckung für M5 behauptet wird (K23-D04) | Bau · Eigentümer |
| V-9 | **Der Vertrag macht Zustände an der Lage im Bild fest** (*rechts*) — dafür gibt es in Tor 1 kein Messwerkzeug, im Repo kein Browserwerkzeug | Kriterien an Bestand, Marke oder Meldung festmachen — oder ausdrücklich als gesperrt führen | Eigentümer · Bau |
| V-10 | **GESPERRT geht nicht in Rückgabewert und Torsperre ein** und landet in keiner Restrisikoliste. *(Die schärfste Fassung ist widerlegt: ein Lauf, in dem alles gesperrt ist, fällt durch. Der realistische Fall ist der teilweise gesperrte)* | gesperrte Punkte maschinell in die Restrisikoliste; entscheiden, ob eine Abnahme darauf ruhen darf | Bau · Founders |
| V-11 | **Die Prüfsumme von M30 wird von keinem Tor nachgerechnet** — Tor 1a rechnet nur die beiden K19-Summen nach; und M5 baut an `change_app_state`, einer M30-Funktion auf **Rang 1** | Migrationsprüfsumme in Tor 1 nachrechnen; den Umbau nur per `CREATE OR REPLACE` in einer **neuen** Migration | Bau |
| V-12 | **Die am 16.08.2026 gezeichnete Mechanisierung der Blindheit ist nicht ausgeführt** — keine Rollendatei führt `disallowedTools`, der Wirksamkeitsnachweis ist unangekreuzt | Rollengrenzen je Agent mechanisch setzen, Nachweis führen | Bau (gezeichnete Weisung) |
| V-13 | **Der Blindstand hat keinen git-Verlauf und wird von nichts aufgerufen** — für Tor 2 gibt es keinen Riegel wie F42 für Tor 3 | in das Prüfkommando einhängen; Riegel für die zeitliche Ordnung bauen | Bau |
| V-14 | **Es gibt keine angemeldete Scheibenabnahme und kein einziges Tor-3-Blatt** — beide Verzeichnisse enthalten nur README und Vorlage | klären, wer das Tor-3-Blatt schreibt — **F42 sperrt sonst erst bei der Anmeldung, mit null Puffer bis zum 31.08.** | Founders |

**Anmerkung A-1:** `pruefung_v2.9.sql` — **Rang 4 der gezeichneten Quellenrangfolge** — liegt
nicht im Repo (`git ls-files | grep pruefung_v2` → leer). Nachführen oder Rang 4 ausdrücklich
als nicht mitgeführt kennzeichnen. *Entscheider: Founders, die Rangfolge ist wortgleich aus dem
Bauauftrag übernommen.*

---

## 3 · Sechs Befunde sind verworfen worden

Die Zusammenführung hat jeden Beleg selbst aufgeschlagen und **sechs** Rohbefunde wieder
gestrichen — darunter drei, die den Harness härter getroffen hätten, als die Quelle hergab:

- *„Ein M5-Bauzug, dessen Prüffälle sämtlich gesperrt sind, fährt Tor 1 grün durch"* —
  widerlegt: `pruefungen/lauf.sh` bricht ab, wenn **kein einziger** Punkt bestanden ist.
- *„K05-M32 widerspricht K19-M14"* — der Wortlaut trägt es nicht: K19-M14 nennt einen
  **Mindestbestand**, kein Verbot eines fünften Zustands.
- *„Der Nachtrag nimmt K17-M07 in die tragende Liste auf"* — nachgesehen: er steht unter
  *mitwirkend*.

**Das ist der Grund, warum die Zusammenführung eine eigene Stufe ist.** Ein Befund ohne
nachgeschlagenen Beleg kostet dieselbe Aufmerksamkeit wie einer mit — und verbraucht sie
falsch.

---

## 4 · Was der Harness selbst nachgemessen hat

| Behauptung | eigene Messung |
|---|---|
| kein RLS im Repo | `grep -rniE 'row level security\|create policy' --include='*.sql'` → **null Treffer** |
| K11 wird von einer tragenden Klausel verlangt | `K01-M21` im Register, Wortlaut nennt `app_state_history` und `app_state_aktuell` *(beide K11)* |
| Blindstand gegen Rollengrenze | `blindstand.sh` exportiert `schema`; `pruef-agent.md:57` führt `schema/` unter *nie gelesen* |
| Negativfälle werden zusammengezählt | `tore.yml`, Schleife über `migrations/negativfaelle/*.sql`, Abschluss `if [ "$anzahl" -lt 4 ]`; acht Dateien liegen dort |
| CI hat nur Postgres | zwei `services:`-Blöcke, beide `image: postgres:16` |
| Eigentümer der M5-Klauseln | 11 von 101 |
| K05-G12 in drei Ständen | Register (gesperrt) · Vorlage an die Konzept-Fabrik (offen) · `sichtung_offene_konzeptpunkte_260816.md:243` (*„geschlossen"*) |

Die übrigen Belege sind von der Zusammenführung geprüft, nicht ein drittes Mal.

---

## 5 · Was das für den Termin heißt

**M5 ist nach Blatt 100 Entscheidung 1 benannte Vorarbeit, keine Vertragserfüllung zum 31.08.**
Keine dieser 23 Lücken gefährdet Tor II unmittelbar. Zwei berühren es dennoch:

- **V-14** — ohne angemeldete Scheibenabnahme greift F42 erst am Tag der Anmeldung.
- **S-A** — Punkt 09 (RLS) ist keine M5-Frage allein; er steht zwischen dem heutigen Stand und
  jedem Produktivweg.

---

## 6 · Was eine Unterschrift erledigt — und was nicht

**Nachgetragen am 19.08.2026.** Die erste Fassung dieses Blattes legte acht Kästchen vor
**ohne Empfehlung** — anders als Blatt 100, das in jeder Zeile eine trug. Ein Kästchen ohne
Empfehlung verschiebt die Arbeit nur: der Entscheider muss sich die Lage selbst erarbeiten,
die der Harness gerade gemessen hat. Das ist hier nachgeholt.

**Drei der acht sind mit Kreuz und Datum erledigt. Bei den übrigen beginnt danach die Arbeit —
und zwar bei je einem anderen.**

| | Sperre | mit der Unterschrift erledigt? | wer arbeitet danach |
|---|---|---|---|
| S-A | RLS | **nein** — die Zeichnung sagt nur, *wie weit* gebaut wird | Bau: Policies für drei Tabellen, `freiraum.tenant_id` in jedem Serverbefehl |
| S-B | K05-G12 | **nein** — zwei Zeilen in der Konzept-Fabrik ändern | M. Veil (der Harness darf die Datei nicht anfassen) |
| S-C | Eigentümer | **fast** — eine Weisung, dann trägt der Harness sie ein | M. Veil zeichnet · Harness trägt ein |
| S-D | K11 | **ja**, wenn die Auslegung gezeichnet wird | — (bei der anderen Variante: Schemaerweiterung) |
| S-E | Ablage | **nein** — Zeile A zeichnen, dann bauen | Bau: Attrappe hinter der Schnittstelle |
| S-F | Blindstand | **erledigt** — am 19.08. behoben, keine Zeichnung nötig | — |
| S-G | Antwortlisten | **nein** — 22 Positionen im Wortlaut liefern | fachlicher Eigentümer K05 |
| S-H | Meldungswortlaut | **ja** | — (Wortlaut entsteht beim Bau) |

---

## Zeichnung

| | Entscheidung | |
|---|---|---|
| **1** | **S-A · RLS.** *(Empfehlung: der mittlere Weg)* **Zeilenregeln für die drei Tabellen, die M5 anfasst** — `app`, `document`, `event` — als Teil von M5; der ganze Punkt 09 bleibt ein eigener Zug. **Begründung:** Ohne Zeilenschutz sind `K02-M20` und `K13-M08` — beide **tragend** — nach K23-M22 von Anfang an *gesperrt*; ein Meilenstein, dessen tragende Klauseln nicht gemessen werden können, ist keine Vorarbeit, sondern eine Behauptung. Der ganze Punkt 09 dagegen berührt 57 Tabellen und die bereits gebauten Wege M1–M4 — das ist eine eigene Scheibe. **Vorbedingung, die ohnehin fällt:** jeder Serverbefehl setzt `freiraum.tenant_id`; ohne sie lässt der gebaute Wächter durch. **Der Teilstand gehört als solcher in die Restrisikoliste** | ☐ so · ☐ ganz (Punkt 09 mit M5) · ☐ ohne, mit anschlagendem Gate · ☐ anders: |
| **2** | **S-B · K05-G12.** *(Empfehlung: nachziehen, nicht abhaken)* K05 Abschn. 5 wird nach der vorliegenden Vorlage nachgezogen. **Begründung:** `K05-G11` verbietet ausdrücklich, eine als offen ausgewiesene Zeile stillschweigend als Träger anzunehmen — „erfüllt ankreuzen" wäre genau das. Der Träger ist gemessen vorhanden; es fehlt nur die Zeile, die es sagt. **Danach:** der dritte, abweichende Stand im Repo wird auf denselben Wortlaut gebracht | ☐ nachziehen · ☐ als erfüllt kennzeichnen · ☐ anders: |
| **3** | **S-C · Eigentümer.** *(Empfehlung: nach dem Muster vom 16.08.)* Fachlicher Eigentümer für die M5-Klauseln ist **A. Han für den Auftragnehmer**, **außer für K17** — dort M. Veil, wie schon in der Runde vom 16.08. (K15, K17). **Begründung:** Die Einengung auf den Teilschnitt war eine Terminentscheidung, keine Zuständigkeitsentscheidung; die Verteilung ist bereits einmal gezeichnet worden und wird nur fortgeschrieben. **Danach trägt der Harness sie ein** — Buchführung, keine Anmaßung | ☐ so · ☐ andere Verteilung: |
| **4** | **S-D · K11.** *(Empfehlung: Auslegung zeichnen)* Die Verlaufszeile `app_state_history` gilt **nur für `lifecycle_state`**; der Stufenwechsel wird über `event` nachgewiesen. **Begründung:** Das gezeichnete Schema kann es nicht anders — `app_state_history.state` ist vom Typ `lifecycle_state`, der Trigger feuert nur darauf. Die Gegenvariante verlangt eine Erweiterung des eingefrorenen Schemas für einen Meilenstein, der ausdrücklich Vorarbeit ist. **Der M5-Nachweis hängt am `event`-Eintrag, nicht an der Verlaufszeile.** Restrisiko: wird die Verlaufszeile später doch für `journey_phase` verlangt, ist das eine Migration, kein Umbau von M5 | ☐ nur `lifecycle_state` · ☐ auch der Stufenwechsel (Schemaerweiterung) · ☐ anders: |
| **5** | **S-E · Ablage.** *(Empfehlung: Zeile A des Ablage-Nachtrags)* Privater Objektspeicher in `swedencentral`, im Prüfstand eine Attrappe hinter **derselben** Schnittstelle. **Begründung:** Variante B bricht `K05-M25` im Wortlaut (*„Dateistand"* und *„K05 besitzt weiterhin keine Tabelle"*), Variante C überlebt keinen Neustart und damit nicht den Meilenstein selbst. **Offen bleibt nur die Zahl hinter *kurzlebig*** — sie steht in keiner Klausel, und der Harness trägt sie nicht ein | ☐ Zeile A · ☐ anders: · Zugriffsdauer: ⟨Minuten: ⟩ oder ☐ Frage an K13 |
| **6** | **S-G · Antwortlisten.** *(Empfehlung: liefern, hilfsweise das Hausmuster)* Zwölf Themen, drei Einordnungsfragen, sieben Ziele im Wortlaut — **22 kurze Positionen**. Kommen sie nicht rechtzeitig, gilt das bereits gebaute Muster: der **freie Weg** (*Was anderes* / *+ Anderes Ziel*) trägt, die Auswahllisten führen die **benannte Meldung zum ungezeichneten Wortlaut** und werden als Seed nachgereicht — genau wie EN-03a (`app/vorpruefung.py`: *„Ihn zu erfinden wäre Umfang, den niemand gezeichnet hat"*). **Begründung:** M5 ist an *abbrechen, neu anmelden, weitermachen* nachrechenbar; das trägt der freie Weg auch ohne die Listen | ☐ wird geliefert bis ⟨Datum: ⟩ · ☐ Hausmuster, Nachreichung als Seed |
| **7** | **S-H · Meldungswortlaut.** *(Empfehlung: nachgereichte Bauentscheidung)* Das Kriterium verlangt *eine Meldung, die den Grund nennt*; der Wortlaut entsteht beim Bau und wird als Katalog geführt. **Begründung:** Tor I Nr. 6 verlangt den Wortlaut dort, wo es einen gibt — bei den Migrations-Negativfällen kommt er aus `RAISE EXCEPTION`. Für die elf Bildschirmaktionen gibt es keine solche Quelle; ihn ins Kriterium zu schreiben hieße, ihn zu erfinden | ☐ nachgereichte Bauentscheidung · ☐ Teil des Kriteriums (Eigentümer liefert elf Wortlaute) |
| **8** | **Die vierzehn verzögernden Punkte** werden vom Bau ohne weitere Zeichnung ausgeführt, **ausgenommen V-1, V-2, V-3, V-4, V-5, V-6 und V-14** — sie brauchen eine Entscheidung und werden einzeln vorgelegt *(Empfehlung: so)* | ☐ so · ☐ anders: |

| Name | Rolle | Datum | Bemerkung |
|---|---|---|---|
| A. Han | für den Auftragnehmer |  |  |
| M. Veil | für den Auftraggeber |  |  |

---

*Verfahren am 19.08.2026: drei adversariale Linsen (Klausellage · Sperren und Vorbedingungen ·
Prüfbarkeit), je mit dem Auftrag, nur zu melden, was sie selbst belegen können, danach eine
Zusammenführung mit dem Auftrag, jeden Beleg nachzuschlagen und Unbelegtes zu verwerfen. 29
Rohbefunde, 23 bestätigt, 6 verworfen. Die Konzept-Fabrik wurde nicht angefasst; alle
Klauselwortlaute stammen aus dem mitgeführten `nachweise/klauselregister/register.json`.*
