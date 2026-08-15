# Übergabe · Sitzung vom 15.08.2026 — Stand 23:47 Uhr

> **Diese Fassung schreibt die Fassung von heute früh fort** (Änderungsstand `317ebbb`).
> Sie ersetzt sie nicht: was dort steht, war beim Schreiben richtig. Es ist danach falsch
> geworden. Zeile 5 der alten Fassung sagte *„Stand `main` `af138ab` — unverändert, es ist
> heute nichts zusammengeführt worden"*, Zeile 19 sagte *„Nichts davon ist auf `main`."*
> **Sechs Minuten später wurde der erste von drei Anträgen zusammengeführt.** Wer die alte
> Fassung noch braucht: `git show 317ebbb:HANDOVER_260815.md`.
>
> **Alle Zahlen dieser Fassung sind am 15.08.2026 zwischen 23:35 und 23:47 Ortszeit
> (21:35–21:47 UTC) selbst gemessen worden**, nicht aus Zuarbeiten übernommen. Neben jeder
> Zahl steht der Befehl, der sie erzeugt hat. Was nicht gemessen werden konnte, steht am Ende
> in einem eigenen Abschnitt.

| | |
|---|---|
| Stand `main` | **`7642f0b`** — heute Abend von `af138ab` weitergerückt. `git log --oneline -1 main` |
| Umfang seit gestern Abend | **25 Dateien · +13 508 / −185 Zeilen.** `git diff --shortstat af138ab..main` |
| Zusammengeführt heute | **#21 · #22 · #23** — alle drei `APPROVED`, zusammengeführt 20:38:24Z / 20:41:44Z / 20:44:19Z (22:38–22:44 Ortszeit). `gh pr list --state all --json number,state,mergedAt,reviewDecision` |
| Offene Anträge | **#24 · #25** — beide von heute Abend, alle vier Tor-1-Prüfungen `pass`, Tor 3 `skipping`, **beide warten auf A. Han**. `gh pr checks 24` · `gh pr checks 25` |
| Tor-1-Lauf auf `main` | **kein einziger abgeschlossen und bestanden.** Drei Läufe seit den Merges: `31907234008` `in_progress` (1 h 07), `31907385991` `completed/cancelled`, `31907503866` `pending` (1 h 01). `gh run list --branch main --limit 3` |
| Tage bis zum Endtermin | **16** (31.08.2026). `python3 -c "from datetime import date;print((date(2026,8,31)-date(2026,8,15)).days)"` |
| Arbeitsbaum | **unverändert bis auf diese Datei.** `git status --short` → `M HANDOVER_260815.md` |

**Tor 3 · der fremde Blick:** `python3 werkzeuge/fremdreview.py --stand` → *„Tor 3: **für keine
Scheibe angefordert.** Das Review fordert ein Mensch an; der Harness schreibt es nie selbst.
Vorlage: `arbeit/Vorlagen/tor3_anforderung_scheibe1.md`"* Exitcode 0. Diese Zeile steht ab
heute in jeder Übergabe — sie ist seit Antrag #22 Pflicht.

---

## Der Stand in drei Sätzen

**Der Bau ist heute Abend auf `main` angekommen:** Meilenstein M3 (die Vorprüfung mit Halt),
der Klauselschnitt für Scheibe 1 und die Tor-3-Nachfrage im Harness sind zusammengeführt.

**Der Auftraggeber hat heute 22 Entscheidungen gezeichnet** — die wichtigste engt die
Lieferabnahme am 31.08. auf einen benannten Teilschnitt ein.

**Wirksam geworden ist davon keine einzige:** die Urkunden sind nicht ausgefertigt, die
zweite Unterschrift fehlt, und beide Zeichnungsblätter liegen auf offenen Zweigen außerhalb
von `main`.

---

## 1 · Was heute gilt, das gestern nicht galt: der neue Umfang von Tor II

**Tor II** ist die technische Lieferabnahme am 31.08.2026 (römische Zählung = Abnahmetore des
Bauauftrags; die arabischen Tore 1–4 sind die Messstufen dieses Harness, das ist etwas
anderes — `CLAUDE.md` Abschnitt 0). Bisher verlangte Tor II **alle zwölf Meilensteine**. Jetzt
verlangt es sechs eingeengte Bedingungen. **Der Endtermin ist unverändert** — geändert ist der
Umfang, nicht das Datum. Tor III (Produktivfreigabe) liegt weiterhin ausdrücklich außerhalb.

Quelle für die ganze Tabelle: `git show origin/nachtraege/korrekturblatt-wega:arbeit/Vorlagen/korrekturblatt_BA-1_wegA_260815.md`
(681 Zeilen, Korrekturen K1 bis K6).

| Bedingung | Neuer Umfang | Zurückgestellt |
|---|---|---|
| **1 · Meilensteine** | Der **Teilschnitt bis zur Anmeldung**, erweitert um die **Vorprüfung mit Halt**: Mandant anlegen · Einladungsschranke · Einladung über den echten Mailweg · Anmeldecode · Anmeldung · Vorprüfung. Darauf liegen **M1, M2, M3** (Korrektur K1, **Fassung B**) | **M4 bis M12** |
| **2 · Bauaufgaben** | **L1** (Zeilenschutz) · **L2** (Identitätsvertrag der sechs Dienstidentitäten) · aus L9 der Portal-Hinweis | **L3, L4, L5, L6** — und mit L6 ausdrücklich **Starttor 18** |
| **3 · Prüfungen** | Ein **Teildurchstich** von der Einladung bis zur Anmeldung, mit mindestens einer Abzweigung je Fehlerpfad. Sein Manifest trägt die Kennung `TEILDURCHSTICH` und **darf als Beleg für M10 nicht herangezogen werden** | der volle Durchstich nach K23-M06 · Modulprüfungen (K23-M08) · Lastprüfung (K23-M10) |
| **4 · Nachweise** | Klauselregister, Herkunftsgraph, Restrisikoliste **nur für die Klauseln des Teilschnitts**, je mit allen zehn Feldern aus K23-M02. Welche Klauseln das sind, legt ein **gezeichneter Klauselschnitt** fest | die übrigen Klauseln |
| **5 · Restrisiken** | Kein kritisches Restrisiko offen **für die Klauseln des Teilschnitts**. Unverändert bleibt: bei sicherheits-, mandanten-, freigabe-, aufbewahrungs- und wiederherstellungskritischen Klauseln genügt eine Annahmeentscheidung **nicht** | — |
| **6 · Starttore** | **05, 11, 13, 15** | **14** (gehört zu M4) · **18** (hing an L6) |

### Was „zurückgestellt" ausdrücklich **nicht** heißt

1. **Nicht gestrichen.** Die zurückgestellten Meilensteine und Bauaufgaben bleiben geschuldet.
2. **Nicht abgeschwächt.** Ihre Nachrechnung bleibt **im Wortlaut** bestehen — einschließlich
   *„drei Mandanten gleichzeitig, 95 % unter 3 Sekunden, 50 Modellaufrufe je Gespräch"*.
   **Kein Prüfwert wird gesenkt** (K23-D05 bindet den Bauenden und bleibt unberührt).
3. **Nicht unsichtbar.** Zum 31.08. wird für **jeden** Meilenstein M1–M12 festgestellt, ob er
   eingetreten ist. Für die zurückgestellten ist das **Bericht, nicht Abnahmebedingung**.
4. **Nicht terminiert.** Sie tragen bis zu einem eigenen Korrekturblatt kein Datum. Dieses
   Blatt gibt es noch nicht.
5. **Nicht: Gate aufgehoben.** Der wichtigste Satz des Korrekturblatts lautet wörtlich:
   **„Eine Einengung von Tor II hebt kein Gate auf."** Vier der fünfzehn sperrenden Gates aus
   K23 Abschnitt 6 schlagen an, **gleichgültig wie der Bauauftrag geändert wird**: 11
   (Eigentümer- und Akzeptanzzuordnung), 13 (Modulprüfung), 14 (Lastprüfung), 15 (Durchstich).
   Der gezeichnete Weg 3-III — die Festlegung auf Rang 0 — löst nach der Bewertung der
   Entscheidungsvorlage **13, 14 und 15**. **Gate 11 ist dort ausdrücklich ausgenommen**: es
   hängt an den leeren Registerzeilen, nicht am Durchstich.

**Gemessen zu Gate 11:**
`python3 -c "import json;d=json.load(open('nachweise/klauselregister/register.json'));print(len(d['zeilen']), sum(1 for z in d['zeilen'] if z.get('akzeptanzkriterium')), sum(1 for z in d['zeilen'] if z.get('eigentuemer')))"`
→ **1231 Zeilen · 0 mit Akzeptanzkriterium · 0 mit Eigentümer.** Gate 11 schlägt an.

> **Ein Vorbehalt, der dazugehört:** Dass Weg 3-III die Gates 13, 14, 15 *auflöst*, ist die
> Bewertung der Entscheidungsvorlage, keine Messung. Und sie wirkt erst, wenn das
> Beschlussblatt ausgefertigt ist — siehe Abschnitt 6, Punkt 2.

---

## 2 · Was heute in die Hauptspur kam

`git log --oneline --since="2026-08-15 00:00" main | wc -l` → **22** Änderungsstände, davon
**6** Zusammenführungen (`--merges`). Kein Schema, keine Migration berührt.

`git diff --name-only af138ab..main | awk -F/ '{print $1}' | sort | uniq -c`:
`nachweise` 10 · `app` 5 · `werkzeuge` 2 · `pruefungen` 2 · `arbeit` 2 · `.claude` 2 ·
`seeds` 1 · Wurzel 1 (die Übergabe selbst).

### #21 · Der Klauselschnitt für Scheibe 1
Zusammengeführt 20:38:24Z als `1c15c95`, Zweig `schnitt/scheibe1`.
`git diff --shortstat 1c15c95^1 1c15c95` → **10 Dateien, +8 583 / −182**.

Es gibt jetzt das Lesematerial, mit dem ein Mensch entscheiden kann, welche der 1 231 Regeln
zu Scheibe 1 gehören — und das leere Blatt, auf dem er es einträgt. Der erste Schritt jeder
Scheibe war seit Wochen blockiert, weil die Zuordnung Regel → Scheibe nicht existierte. Sie
existiert weiterhin nicht — aber der Weg dorthin ist jetzt **Lesearbeit statt Ratearbeit**.

`python3 werkzeuge/wortmarken.py --ziel <Ausgabe außerhalb des Repos>` → *„Stichwortverzeichnis
Scheibe 1: 22 Stationen, **470 von 1231** Regeln beruehrt"*. Die Leseblätter bündeln sie zu
**140 Bündeln**; die Übersichtstabelle führt 18 Stationen, weil drei Begriffe (*Anmeldung*,
*Kenntnisnahme*, *Unterschrift*) nichts unterscheiden und ganz in einer Querschnittsgruppe
aufgehen. **Das Werkzeug nennt ausdrücklich keine Scheibe.**

`nachweise/klauselschnitt/S1_zeichnung.md` — **237 Zeilen, 19 Kästchen, alle `[ ]`, kein `[x]`**
(`grep -c "\[x\]"` → 0, `grep -c "\[ \]"` → 19). Name- und Datumszeile leer.

**Die Nachprüfung der Bauspur ist der eigentliche Ertrag von #21.** Sie prüft Zeile für Zeile,
ob dreizehn Regelkennungen, die eine Datei im Kopf mit `umsetzt:` beansprucht, durch deren
eigenen Code gedeckt sind. Ergebnis wörtlich: *„Von den sechzehn Ansprüchen … halten sechs
vollständig, neun nur zum Teil, einer gar nicht."* Vier Befunde lösen beim Bau Arbeit aus:

- **K03-M05** — `app/haupt.py` beansprucht die Regel (sechsstelliger E-Mail-Code als zweiter
  Faktor), im Code der Datei steht dazu **nur ein Satz im Vorspann**. Kein Programmschritt
  erzeugt, prüft oder versendet einen Code.
- **K20-M25** — laut der Nachprüfung *„der deutlichste nicht vermerkte Fall"*: gebaut ist der
  Satz auf dem Bildschirm, nicht die geforderte Aufbewahrungsart.
- **K20-M08** — die beste Umsetzung steht in `app/einladung_senden.py:663`, einer Datei
  **ohne** `umsetzt:`-Kopfzeile. Zwei andere Dateien beanspruchen die Regel und tragen sie nur
  zur Hälfte. **Die am besten belegte Umsetzung beansprucht niemand.**
- **`app/einladung.py:51-54`** behauptet ausdrücklich, `haupt.py` führe **K03-G01** *„ganz"*.
  Das trifft nicht zu und trägt die Lücke in eine zweite Datei weiter.

> **Warum das über #21 hinaus zählt:** Die Kopfzeile `# umsetzt:` wird von
> `werkzeuge/herkunft.py` als **ausdrückliche Erklärung** gewertet. Wer die erzeugte
> Nachweissicht liest, ohne den Code danebenzulegen, bekommt für acht Ansprüche ein zu gutes
> Bild. **Die Kopfzeilen sind ein Wegweiser, kein Beleg.**

### #22 · Der Harness fragt nach dem fremden Blick
Zusammengeführt 20:41:44Z als `d51fc67`, Zweig `harness/tor3-nachfrage`.
`git diff --shortstat d51fc67^1 d51fc67` → **4 Dateien, +237 / −3**.

Der Harness verweigerte das Fremdreview bisher stumm. Jetzt fragt er an zwei Stellen einen
Menschen und wartet auf die Antwort. `/scheibe` Schritt 10 ist von einem Vermerk zu einem
**Halt** geworden (`​.claude/commands/scheibe.md:84`: *„Dieser Schritt ist ein Halt, keine
Notiz."*): Schritt 11 läuft nicht ohne Antwort, ein *Nein* wird als offener Punkt festgehalten,
und Tor 3 bleibt **gesperrt, nicht übersprungen**. Neu sind das Kommando `/uebergabe` und der
Schalter `--stand`, der jede Tages-Übergabe mit einer festen Zeile über Tor 3 eröffnet (siehe
Kopf dieser Seite). Auslöser bleibt die **Scheibenabnahme**, Ausnahme **M10/M11/M12** (sie
gehören keiner Scheibe an — `.claude/commands/uebergabe.md:52`). Kein Tor wurde verschärft,
`pruefungen/tor3.sh` ist unverändert (steht nicht in `git diff --name-only af138ab..main`),
`--stand` liefert immer 0.

> **Was #22 nicht behebt — heute Abend neu gemessen:** Der Auslöser kann nicht ziehen.
> Der Tor-3-Ablauf hängt am Etikett `scheibenabnahme`; `gh label list` führt nur die neun
> mitgelieferten Etiketten, **`scheibenabnahme` existiert nicht**. `gh run list
> --workflow=tor3.yml --limit 100 | wc -l` → **28 Läufe, alle `completed skipped`**. Siehe
> Abschnitt 10.

### #23 · Meilenstein M3: Die Vorprüfung hält an
Zusammengeführt 20:44:19Z als `7642f0b`, Zweig `scheibe/vorpruefung-m3`.
`git diff --shortstat 7642f0b^1 7642f0b` → **11 Dateien, +4 688 / −0**.

Ein Kunde, dessen Anliegen sich für den Bau nicht eignet, wird jetzt angehalten und bekommt
genau drei Auswege: Antwort ändern, Gespräch erbitten, zur Übersicht zurück. **M3 ist der
erste Meilenstein, dessen Nachrechnung in diesem Repo Punkt für Punkt nachgewiesen ist.**
Vorher waren von den **49 Regeln** des K04-Eignungs-Checks (`arbeit/Plaene/scheibe2_m3_plan.md:8`)
null gebaut und von 33 Bildschirmen einer.

Jetzt, gemessen mit `wc -l` und `grep`:
`app/vorpruefung.py` **1 145 Zeilen** · drei Bildschirme EN-02/EN-03/EN-04 · ein Startbestand
mit **drei Fragen und dreizehn Antwortmöglichkeiten** (`seeds/Seed_Vorpruefung_K04.sql`:
`fit_question` 3 Zeilen, `fit_option` 5+4+4) · **32 blind geschriebene Prüffälle**
(`grep -oE "VP-[0-9]+[a-z]?" pruefungen/klauseln/vorpruefung_lauf.sh | sort -u | wc -l` → 32;
Datei 1 897 Zeilen).

Die fünf Nachrechnungspunkte sind einzeln bestanden. Gemessen:
`grep -oE "VP-1[34789]" pruefungen/klauseln/vorpruefung_lauf.sh | sort -u` → `VP-13 VP-14
VP-17 VP-18 VP-19`. Im letzten belegten Lauf meldet der Faden `vorpruefung` **31 von 32
bestanden**, und der einzige nicht bestandene Fall ist **VP-08b (GESPERRT)**. Keiner der fünf
ist also gesperrt oder gescheitert.

---

## 3 · Was entschieden wurde — 22 Zeichnungen, nach Wirkung gebündelt

M. Veil hat heute in zwei Wellen gezeichnet. Beide Blätter sind gelesen mit `git show <zweig>:<pfad>`.

- **Blatt 1** (Zweig von #25): `arbeit/Vorlagen/zeichnung_M1-M10_260815.md`, 124 Zeilen —
  **zehn Entscheidungen M-1 bis M-10**, alle mit `[x]`.
- **Blatt 2** (Zweig von #24): `arbeit/Vorlagen/BA-1_zeichnung_260815.md`, 145 Zeilen —
  **zwölf Entscheidungen**, geordnet in **Teil A: A1–A7** (was der Auftraggeber allein
  entscheidet), **Teil B: B1–B3** (was beide Parteien zeichnen) und **Teil C**, das die Kreuze
  des Korrekturblatts auflöst: **K1 · K1-b · K2–K6 · K3**.

**Form nach F40: die Kreuze sind auf ausdrückliche Weisung übertragen, nicht selbsttätig
gesetzt.** Wortlaut der Weisung zu Blatt 1: *„M-1 bis M-10 gem. Entscheidungsvorlage und
Handlungsempfehlungen hiermit entschieden. Gez. M. Veil, 15.8.26"*

**Bündel 1 · Der Umfang der Abnahme** (K1 · K1-b · K2–K6) — Tor II ist eingeengt, Weg A
bleibt, der 31.08. bleibt. **M3 kommt in den Umfang, M4 nicht**: M3 ist gebaut und gemessen,
M4 ist nicht begonnen. Siehe Abschnitt 1.

**Bündel 2 · Der Weg, die vier sperrenden Gates zu lösen** (K3 · M-2 · B3) — nicht über
einen Nachtrag zum Konzept K23, sondern über einen **Founder-Beschluss auf Rang 0** (Rang 0
gewinnt gegen alles Weitere; erprobt mit F28 und F04). Damit entfällt die Stelle 14 im
Bauauftrag — sie galt nur für Weg 3-I. Der Beschluss erfasst auch den Nachlauf-Durchstich.

**Bündel 3 · Der Vollzug bekommt einen Menschen und eine Frist** (M-1 · Vollzugsauftrag VA-1)
— **A. Han trägt die dreizehn Stellen in den Bauauftrag ein, bis 16.08.2026 abends.** Bis der
letzte Haken sitzt, gilt der Bauauftrag als *in Änderung* (Abschnitt 12.4 Nr. 5): **keine
Vorlage zur Freigabe zulässig.** Das Fenster soll Stunden dauern, nicht Tage.

**Bündel 4 · Kein Werkzeug für den Durchstich** (M-3) — der Schritt wird nicht gebaut, sondern
in den Rang-0-Beschluss aufgenommen und als Befund geführt. Träger A. Han, Frist vor
Pilotstart. Begründung, gemessen: `grep -rl "Durchstich" --include="*.sh" --include="*.py"
--include="*.yml" .` → **0 Treffer** (nur in Dokumenten). Der Vollzugsschritt 7 („Durchstich
neu gegen die neue Prüfsumme") wäre sonst nicht ausführbar.

**Bündel 5 · Zwei Fragen erledigen sich ohne Zeichnung** (M-5, M-6) — die Mandantengrenze ist
keine offene Frage. Siehe Abschnitt 4.

**Bündel 6 · Die Umbenennung von „Tor" ist abgesagt** (A6 · E9) — stattdessen die Sprachregel
**`SPR-10`**. Siehe Abschnitt 5.

**Bündel 7 · Vier Arbeitsaufträge sind ausgelöst** — Klauselschnitt einengen (M-7) ·
**Fremdprüfung anfordern (M-8)** · Ablaufpfad zu MG-08 bauen (M-9) · Migration zu B1-F2
vorlegen (M-10). **Für alle vier liegt seit 23:42 Uhr eine Vorlage vor** — siehe Abschnitt 7.

**Bündel 8 · Aufräumen und Nachholen** — V4 und V5 entschieden (A4; sie sperrten seit 10.08.
den Auslöser S2 der Baustrategie) · **VP-08b wird als Befund getragen** statt K04-M07
nachzuziehen (A5) · Abnahmezeichnung Starttor 05 und 15 nachholen (A2) · Zeichnungsblatt
Scheibe 1 nachholen (A3) · **erst archivieren, dann einfrieren** (M-4) · Managementpräsentation
v4 vor Umlauf korrigieren, vier sperrende Punkte (A7 · E10).

### Ein gezeichneter Klauselkonflikt
**K04-M08** verlangt nach dem Halt den Ausweg *Gespräch mit der Ansprechperson*; **K04-D04**
verbietet, dass ein Check mit dem Ergebnis `NICHT_GEEIGNET` ins Gespräch führt. Zwei
gezeichnete Klauseln, derselbe Zustand. **M. Veil hat Lesart A gezeichnet:** „Gespräch" meint
die geführten Stufen 01/02, nicht den Anruf. Der Befund ist damit **entschieden, nicht
getragen** — er wird kein kritisches Restrisiko. Ein klarstellender Satz in K04 geht als
offener Punkt an die Konzept-Fabrik; der Wortlautvorschlag liegt bei
(`nachweise/befunde/BEF-M3_260815.md`, BEF-M3-3).

---

## 4 · Der Fund zu Beschluss S28 — eine Zeichnung, die erspart blieb

**Gesucht** wurde der Text des Founder-Beschlusses **S28 vom 02.08.2026** (Auftrag M-6).
Anlass war M-5: M. Veil sollte entscheiden, ob aus dem Betreiber-Mandanten heraus über die
Unternehmensgrenze hinweg eingeladen werden darf. Eine fertige Entscheidungsvorlage vom
14.08. lag vor (`arbeit/Vorlagen/entscheidung_einladung_mandantengrenze_260814.md`, auf `main`),
ohne Kreuz.

**Gefunden:** S28 steht im K00-Beschluss-Log v1.10, Zeile 258, und verweist auf das
Founder-Blatt `arbeit/Founder_Beschluesse/O-PIL-4_Domaenenschranke.md`. Der Entscheidungsblock
trägt Kreuz und Zeichnung: *„[x] Der Betreiber bestimmt. Niemand außer exmachinAI legt fest,
wer FREIRAUM nutzen darf."* — 02.08.2026, gez. M. Veil. Technisch löst `invitation_guard()`
die Domäne über `NEW.actor_id → actor.tenant_id → tenant.invite_domain` auf: geprüft wird die
Schranke **des Mandanten, zu dem das eingeladene Konto gehört**. Die Einladung über die Grenze
ist ausdrücklich **kein Widerspruch zur Schranke**. Der Folgeauftrag ist längst ausgeführt —
K03 v1.3 trägt den berichtigten Wortlaut von K03-M19.

**Folge:** Die Vorlage vom 14.08. ist gegenstandslos. „Lesart A" ist nicht eine von zwei
Möglichkeiten, sondern die geltende Rechtslage seit dem 02.08.2026. Empfehlung: Schließvermerk
mit Verweis auf S28, **kein neues Kreuz**.

**Die Lehre:** Der systematische Durchlauf hatte die Mandantengrenze als *„sperrt jetzt,
ungezeichnet"* gemeldet — mit zutreffendem Beleg, denn die Vorlage trägt tatsächlich kein
Kreuz. Erst der Blick in den Bestand zeigte, dass die Frage anderswo beantwortet war.
**Eine offene Vorlage ist nicht dasselbe wie eine offene Frage.**

> **Grenze dieses Befundes, ehrlich benannt:** `arbeit/Founder_Beschluesse/` liegt **nicht in
> diesem Repository** (`ls arbeit/` → nur `Bauberichte`, `Plaene`, `Vorlagen`). Das
> Zeichnungsblatt hält fest, die Prüfsumme des Founder-Blatts sei mit `shasum -a 256` selbst
> nachgerechnet worden (`9e321461…7c7100d`, identisch mit dem Wert im Beschluss-Log). **Diese
> Nachrechnung ist aus dem Lieferrepo heraus nicht wiederholbar** — der Wert kommt hier
> nirgends vor (`grep -rn "9e321461" .` → nur das Zeichnungsblatt auf dem Zweig von #25).

**S28 benennt selbst einen neuen offenen Punkt:** `invite_domain` ist **eine** Textspalte,
keine Liste. Ein Konzern mit mehreren Marken oder externe Berater lassen sich nicht abbilden —
dann bleibt nur „alles oder nichts". Dieser Punkt ist bis heute **nirgends als Kennung
geführt**. Er trifft den Pilotbetrieb, nicht den Teilschnitt, und gehört auf die Liste nach
dem 31.08.

---

## 5 · Die Umbenennung ist abgesagt — ihr Ersatz wirkt noch nicht

Vorgeschlagen hatte die Managementpräsentation, Tor I/II/III in *Starttor · Liefertor ·
Betriebstor* und Tor 1–4 in *Prüfstufen P1–P4* umzubenennen. **Zwei unabhängige Prüfungen
rieten übereinstimmend ab** — eine KI eines anderen Anbieters mit 17 Befunden, eine
mehrstufige Prüfung im Harness mit 60 gemeldeten und 36 nach Gegenprobe bestätigten Befunden
(`gh pr view 24 --json body`).

| | Begründung — gemessen, nicht Geschmack |
|---|---|
| **Der Name ist vergeben** | Der Bauauftrag führt in Abschnitt 4 bereits **zehn „Starttore"** — etwas völlig anderes. Fünf davon sind Bedingung 6 von Tor II im geltenden Auftrag, **vier nach dem heute gezeichneten Kreuz K1-b** |
| **Der Buchstabe ist vergeben** | K16 führt den Poka-Yoke-Katalog **P01–P12**, ein gezeichneter Nachtrag erweitert ihn auf **P13–P37**. Die Glossarzeile „P… (nicht vergeben)" ist sachlich falsch — und sie war die einzige Begründung für die Buchstabenwahl |
| **Es löst zwei von sieben** | „Tor" bedeutet heute sieben verschiedene Dinge. Vier bleiben unangetastet, **zwei neue Kollisionen kämen hinzu** |
| **Es hält den Bau an** | Der Zweigschutz auf `main` verlangt Prüfungen, die wörtlich `Tor 1a · Lint und Geheimnisschranke` heißen. **Selbst gemessen:** `sed -n '42p' .github/workflows/tore.yml` → `    name: Tor 1a · Lint und Geheimnisschranke`, und `gh pr checks 24` führt genau diesen Namen. Wird er geändert, wartet der Zweigschutz auf eine Prüfung, die nie wieder meldet — **kein Antrag wäre mehr zusammenführbar** |
| **Der Weg stimmt nicht** | Eine reine Umbenennung ist nach 12.1 weder Schreibfehler noch Änderung der Torzuordnung. Der vorgeschlagene Weg über ein Korrekturblatt ist nicht gedeckt |
| **Der Umfang** | Laut Entscheidungsvorlage E9: 53 Fundstellen im Auftrag · 21 in der Anlage Baustrategie · 51 in der Anlage Bauverfahren · 33 in den 24 Konzepten · **268 im Repository**. Die Repo-Zahl habe ich mit anderer Grundlage nachgezählt: `grep -rIoE "\bTor\b" . --exclude-dir=.git --exclude-dir=.venv --exclude-dir=.ruff_cache --exclude=HANDOVER_260815.md \| wc -l` → **302**. Die Größenordnung stimmt, die Zählweise ist nicht dieselbe |

**Stattdessen `SPR-10`** — eine Sprachregel, die **keinen einzigen gezeichneten Text ändert**:
neue Texte schreiben „Messstufe 1 bis 4"; wo „Tor" bleibt, trägt es bei der ersten Nennung
sein Beiwort (Abnahmetor · Starttor · Echtdaten-Tor · Fabrik-Tor · Gate). **Maschinell
verglichene Bezeichner sind ausgenommen** — Prüfungsnamen im Zweigschutz, Dateinamen,
Zweignamen, Manifestfelder. **Bestandsschutz** für alles Ältere.

> **Zwei Zusätze, die man nicht überlesen darf.**
> - **Umbenennung und Weg-A-Berichtigung nie auf dasselbe Korrekturblatt.** Eine vergessene
>   Namensstelle ließe nach 12.4 Nr. 4 die **gesamte** Korrektur unvollzogen — und damit den
>   Vollzug, der den Endtermin rettet. Das Bündeln spart nichts: 12.5 Nr. 4 erlaubt ohnehin,
>   mehrere Blätter desselben Tages zu einer Fassung zusammenzufassen.
> - **Die Absage braucht keine Unterschrift. Ihr Ersatz schon.** Gemessen:
>   `grep -c "SPR-10" CONTRIBUTING.md` → **0**;
>   `grep -oE "SPR-[0-9]+" CONTRIBUTING.md | sort -u` → **SPR-1 bis SPR-9**. Solange das so
>   bleibt, ist die Umbenennung abgesagt und **nichts an ihre Stelle getreten**.

---

## 6 · Was noch nicht wirksam ist — der wichtigste Abschnitt

**Es ist heute viel entschieden und nichts vollzogen worden.** Der Bauauftrag steht unverändert
auf Fassung v1.1. Gemessen:
`grep -rln "3341362f" . --exclude-dir=.git --exclude=HANDOVER_260815.md` → **drei Dateien**,
alle mit der **alten** Prüfsumme: `CLAUDE.md` und die beiden Manifeste
`nachweise/manifeste/tor1c_260813_manifest.json` und `…260814_manifest.json`. **Eine Fassung
v1.2 existiert nicht.** (Ohne den Ausschluss zählt der Befehl vier Dateien — diese Übergabe
nennt die Prüfsumme selbst.)

| | Was fehlt | Folge, wenn es fehlt |
|---|---|---|
| **1** | **A. Hans eigene Unterschrift** unter die drei gemeinsamen Vorgänge B1/B2/B3: Korrekturblatt BA-1, die beiden Anlagen-Nachträge, die Rang-0-Festlegung | Nach 12.3 zeichnen beide Parteien jedes Korrekturblatt. Der Ablaufplan 12.9 sagt für den ungezeichneten Zweig: *„Vorschlag bleibt liegen · AM AUFTRAG IST NICHTS GEÄNDERT."* Das Blatt sagt es selbst: *„Ein eigener Nachweis A. Hans liegt für dieses Blatt nicht vor."* **Die Nachweiskette läuft hier über eine Fremdangabe.** Nur indirekt gestützt: A. Han hat am selben Tag #21, #22, #23 auf `APPROVED` gesetzt |
| **2** | **Das Beschlussblatt zur Festlegung auf Rang 0.** Die Entscheidung ist getroffen, der Wortlaut liegt fertig in VA-1 Teil 4 — das Blatt ist **nicht ausgefertigt** | **Kreuz K3 bleibt wirkungslos. Die Gates 13, 14, 15 schlagen weiter an.** Ein Bau erreicht die menschliche Freigabe nicht (K23-D01) |
| **3** | **Die dreizehn Stellen im Bauauftrag.** Keine ist eingetragen | Jede Fortschrittsaussage misst gegen einen Text, den beide Parteien verworfen haben. Das Sperrfenster nach 12.4 Nr. 5 bleibt offen |
| **4** | **Der ausgefüllte Zeichnungsblock in VA-1 selbst.** Die Zeichnung steht nur in der getrennten F40-Datei; im Vollzugsauftrag sind beide Zeilen leer | VA-1 sagt über sich: *„Es wird nichts eingetragen, bis dieser Auftrag gezeichnet ist"* |
| **5** | **Beide Zeichnungsblätter liegen nicht auf `main`** — sie liegen auf den Zweigen von #24 und #25 | **Wer nur `main` liest, sieht von den 22 Entscheidungen keine einzige.** Lesen mit `git show <zweig>:<pfad>` |
| **6** | **Das Zeichnungsblatt der Scheibe 1 trägt kein Kreuz** (A3). Gemessen in `S1_zeichnung.md`: **19 Kästchen, alle `[ ]`**, Name- und Datumszeile leer | Korrektur K4 hängt daran — „die Klauseln des Teilschnitts" bleiben unbestimmt. Eine Abnahmebedingung ohne benennbaren Umfang ist keine |
| **7** | **`SPR-10` hat keinen Wortlaut.** `grep -c "SPR-10" CONTRIBUTING.md` → **0** | Die Absage wirkt sofort, der Ersatz nicht. Die Anlage müsste nach 11.4 neu gezeichnet werden — von beiden Parteien |
| **8** | **Die Abnahmezeichnung für Starttor 05 und 15** (A2). Die Blätter 46 und 49 tragen nur A. Hans Zeichnung; Bedingung 6 verlangt *„Abnahme: M. Veil"* | Eine Abnahmebedingung mit einer statt zwei Unterschriften ist nicht erfüllt. Es fällt erst auf, wenn jemand Tor II nachrechnet |
| **9** | **VP-08b hat keine Kennung, keinen Träger, keine Frist.** Der Befund steht im Prüflauf-Text und in der Meldung; die Restrisikoliste führt ihn nicht (`grep -oE "RR-[0-9]+" nachweise/restrisiken/restrisiken.md \| sort -u` → nur `RR-01`) | „Getragen" ist ohne Eintrag nur ein Wort (offener Punkt M-13) |
| **10** | **Die Verzugsmeldung vom 14.08. ist nicht gegengezeichnet.** In `nachweise/meldungen/VERZUG_260814.md` sind beide Kästchen leer (Zeilen 189 und 191, je `[ ]`) | Die heutigen Entscheidungen *sind* die Antwort darauf — sie steht nur nirgends (M-17) |
| **11** | **M-8 ist gezeichnet („wird heute angefordert"), aber nicht ausgeführt.** Gemessen 23:37 Uhr: `bash pruefungen/tor3.sh` → *„Tor 3: kein Fremdreview abgelegt. Zustand: GESPERRT"*, Exitcode 1 · `ls nachweise/fremdreview/` → nur `README.md` und `VORLAGE.md` | **Eine gezeichnete Entscheidung von heute ist am selben Tag nicht vollzogen worden.** Erster Punkt für morgen |
| **12** | **Kein bestandener Tor-1-Lauf auf `main`.** Von drei Läufen ist einer `cancelled`, einer `in_progress`, einer `pending` | Der Stand `7642f0b` ist auf dem Standardzweig **nicht gemessen**. Nach K23-M22 heißt das **gesperrt**, nicht bestanden |

> **Die eine Handlung, die am meisten löst:** A. Han bestätigt seine drei Mitzeichnungen aus
> eigenem Konto, fertigt mit M. Veil das Rang-0-Beschlussblatt aus und trägt die dreizehn
> Stellen ein. **Ohne diesen Federstrich sind alle 22 Entscheidungen Papier.**

> **Ein Widerspruch, der benannt gehört:** Ob das Sperrfenster nach 12.4 Nr. 5 schon läuft,
> hängt davon ab, ob man BA-1 als wirksam gezeichnet ansieht — die übertragene Mitzeichnung
> spricht dagegen, das Zeichnungsblatt dafür. **Beide Lesarten führen zum selben Handeln:**
> die drei Anträge #21–#23 waren vorher zusammenzuführen (geschehen), und der Vollzug gehört
> an einen Tag.

---

## 7 · Die zwei offenen Anträge

**#24 · Entscheidungsvorlage M. Veil + Korrekturblatt BA-1** — erstellt 20:19:38Z, Zweig
`nachtraege/korrekturblatt-wega`, **4 Dateien, +1 519 / −0**, alle unter `arbeit/Vorlagen/`
(`gh pr view 24 --json files` · `git diff --shortstat main...origin/nachtraege/korrekturblatt-wega`).
Die Unterschrift beider Gründer vom 10.08. (Abnahme Ende August umfasst nur den Weg bis zur
Anmeldung) steht bis heute nicht im Bauauftrag. Dieser Antrag legt die Vorlagen bei, mit denen
sie eingetragen wird: zwölf Entscheidungen mit Empfehlung, dreizehn einzeln benannte
Fundstellen (eine vierzehnte gilt nur bei Weg 3-I und entfällt). Tor 1a/1b/1c **pass**,
Tor 1 Sperre **pass**, Tor 3 **skipping**. `reviewDecision: REVIEW_REQUIRED`, **keine Prüfung
eingetragen** (`gh pr view 24 --json reviews` → `[]`).

> **Der Befund, der jeden angeht:** **Der Teilschnitt kann nach heutiger Regellage die
> Unterschrift gar nicht erreichen.** K23-M06 verlangt vor jeder menschlichen Freigabe einen
> Durchstich von der Einladung bis zum abgerufenen Übergabe-Paket; der Teilschnitt endet bei
> der Anmeldung. Ein Korrekturblatt zum Bauauftrag kann eine gezeichnete K23-Klausel nicht
> aufheben — das ist Kreuz K3 im Blatt.

**Berichtigt gegenüber dem Entwurf dieser Übergabe:** Die zweite Fassung von BA-1 ist
inzwischen **doch** gegen den zusammenführenden Abschlussbericht geprüft worden. Der Bericht
kam nach Antragstellung und wurde um **22:27 Ortszeit** in Änderungsstand `b801f59`
eingearbeitet (`git log --format="%ad" --date=iso b801f59`). Er ist auf dem Zweig. Die Aussage
„noch nicht geprüft" war beim Schreiben schon eine Stunde alt.

**#25 · Was noch zu entscheiden ist — sechs Punkte für A. Han** — erstellt 21:09:58Z, Zweig
`offene/entscheidungen-260815`. Ein systematischer Durchlauf über Repo, Bauauftrag, beide
Anlagen und die 24 Konzepte beantwortet, was nach den zwölf Zeichnungen noch offen ist:
**54 Entscheidungen, davon 18 sperrend**, geordnet nach Entscheider. Tore wie bei #24,
ebenfalls ohne eingetragene Prüfung.

Sechs Punkte liegen bei A. Han, vier sperren sofort:
**H-1** Antrag #24 freigeben ·
**H-2** die drei Mitzeichnungen aus eigenem Konto bestätigen ·
**H-3** die Anlage „Bauverfahren" gegenzeichnen — `CLAUDE.md` sagt über sich selbst:
*„Solange die Anlage nicht gezeichnet ist, ist diese Datei ein Vorschlag."* **Alle
Betriebsregeln des Harness stehen auf einer halben Unterschrift** ·
**H-4** AC-16 fahren, ohne den M2 nicht eintritt.
Nicht sperrend: **H-5** Nachweis Starttor 11/13 vor dem 31.08. · **H-6** Vorbedingungen B2/B3
nachfassen.

> **Achtung — der Antrag ist beim Schreiben dieser Übergabe gewachsen.** Um **23:42 Uhr**
> kam Änderungsstand `c7d14a1` hinzu (*„M-7 bis M-10 vorbereitet — und ein Bauvorschlag gegen
> eine Zeichnung gestoppt"*) mit der Datei `arbeit/Vorlagen/arbeitspakete_M7-M10_260815.md`
> (510 Zeilen). **Antrag #25 umfasst jetzt 3 Dateien, +757 Zeilen**, nicht 2 und +247.
> Gemessen 23:46 Uhr nach `git fetch origin`: `gh pr view 25 --json files` und
> `git diff --stat main...origin/offene/entscheidungen-260815`. Alle vier Tor-1-Prüfungen
> laufen auf dem neuen Stand erneut **pass** (`gh pr checks 25`, Lauf `31910191117`).

**Was in `c7d14a1` neu steht — und was davon nachgemessen ist:**

| | Inhalt | Eigene Nachmessung |
|---|---|---|
| **M-7** | Der Umfang von Bedingung 4 ist bestimmbar: **157 Regeln** (152 über die fünf Stationswörter des Teilschnitts + 5 aus der Bauspur), aus 20 Konzepten. Davon mit Abnahmekriterium: 0 | **bestätigt.** Vereinigungsmenge der fünf Stationen *Mandant · Einladungsschranke · Einladung · Anmeldecode · Anmeldung* aus `nachweise/klauselschnitt/S1_wortmarken.json` → **152** eindeutige Klauseln |
| **M-8** | **Die Fremdprüfung kann gar nicht auslösen.** Das Etikett `scheibenabnahme`, an dem der Lauf hängt, existiert im Repo nicht | **bestätigt.** `gh label list` → nur die neun mitgelieferten Etiketten. `gh run list --workflow=tor3.yml --limit 100 \| wc -l` → **28 Läufe, alle `completed skipped`** |
| **M-9** | Der schwerste Befund: Der Bauvorschlag schlägt genau den Weg vor, den Blatt 62 vom 11.08.2026 **nicht** angekreuzt hat. Nach der Rangfolge gewinnt die Zeichnung. **Der Bau wird nicht gebaut** | **nicht nachmessbar** — Blatt 62 und 63 liegen nicht in diesem Repo |
| **M-10** | Migration wiederholbar, verletzt keinen Bestand — aber die Regel, die sie durchsetzt, ist so nicht gezeichnet, und die Klauseln liegen **außerhalb** der 157 | **nicht nachmessbar** aus dem Lieferrepo |

Zweitwichtigster Befund aus dem Grunddokument von #25: Ob aus dem Betreiber-Mandanten heraus
über die Unternehmensgrenze eingeladen werden darf, sitzt **mitten im gezeichneten
Teilschnitt**. **Abschnitt 4 löst ihn auf: die Frage ist seit dem 02.08. beantwortet** — es
fehlt nur der Schließvermerk.

---

## 8 · Die Meilensteine, an ihrer Nachrechnung gemessen

**Der Merge hat keinen Meilenstein ausgelöst.** Ein Meilenstein tritt durch seine Nachrechnung
ein, nicht durch eine Zusammenführung. Was sich heute Abend geändert hat: der **Gegenstand**
von M3 liegt jetzt auf `main`.

**M3 · „Die Vorprüfung hält an" — eingetreten.** Die fünf Punkte VP-13/14/17/18/19 sind je
einzeln bestanden, keiner gesperrt, keiner gescheitert.

> **Zwei Vorbehalte, die in die Übergabe gehören.**
> 1. Der Lauf, der das belegt, ist **nicht auf `main` gefahren**, sondern auf dem Zweig von
>    Antrag #25 (Lauf `31908885182`, Job `95070897178`, 21:15–21:16 UTC). Dieser Zweig enthält
>    `main` `7642f0b` vollständig — nachgeprüft mit `git merge-base --is-ancestor 7642f0b
>    origin/offene/entscheidungen-260815` (Rückgabe 0) — und fügte damals nur Textdateien
>    hinzu. Er misst also den Code von `main`, ist aber formal kein Lauf **auf** `main`.
> 2. **Auf `main` selbst gibt es bis jetzt keinen abgeschlossenen und bestandenen Tor-1-Lauf.**
>    `gh run list --branch main --limit 3`: `31907234008` `in_progress` (seit 20:38:26Z),
>    `31907385991` `completed / cancelled`, `31907503866` `pending` (seit 20:44:21Z).
>    **`cancelled` ist kein bestandener Lauf.** K23-M22 kennt vier Zustände — *bestanden ·
>    fehlgeschlagen · gesperrt · nicht ausgeführt*. Ein abgebrochener Lauf ist *nicht
>    ausgeführt*, nie *bestanden*.

**M2 · „Ein Eingeladener kann sich anmelden" — nicht eingetreten.** AC-16 (echte Zustellung mit
abgelesenem Mailkopf) ist unverändert gesperrt. Der Lauf nennt die fehlenden Stücke wörtlich:
`FREIRAUM_ECHTVERSAND=ja` setzen, `FREIRAUM_SMTP_HOST/USER/PASS/TLS`,
`FREIRAUM_PRUEF_ECHT_EMPFAENGER`, `FREIRAUM_PRUEF_ECHT_MAILKOPF`. Das SMTP-Kennwort liegt im
Schlüsselbund auf A. Hans Rechner; den Mailkopf muss ein Mensch bei einem fremden Anbieter
ablesen.

> **Ein Detail, das die Morgenfassung nicht führt:** Derselbe Meldetext sagt, Teilaussage 1 der
> M2-Nachrechnung sei ohne diesen Lauf *„nur durch den Einzellauf vom 10.08.2026 belegt, nicht
> durch einen wiederholbaren Prueflauf"*. Es gibt also einen einmaligen Beleg. **Was fehlt, ist
> die Wiederholbarkeit.**

**M1 — von hier aus nicht bestätigbar** (unverändert; die Nachrechnung verweist auf ein Skript
außerhalb dieses Repos). **M4 und weiter — nicht begonnen** (unverändert).

---

## 9 · Der kritische Pfad bis zum 31.08.

**16 Tage. Fünf Dinge liegen auf dem Pfad, und vier davon kann nur ein Mensch tun.**

1. **A. Han gibt #24 und #25 frei** (H-1). Solange sie offen sind, sieht `main` von den 22
   Entscheidungen nichts. Alles Weitere hängt daran.
2. **A. Han bestätigt seine drei Mitzeichnungen aus eigenem Konto** (H-2) und fertigt mit
   M. Veil das **Rang-0-Beschlussblatt** aus (M-2). Ohne das Blatt schlagen die Gates 13, 14,
   15 weiter an — **ein Bau erreicht die menschliche Freigabe nicht** (K23-D01). Das ist die
   härteste Sperre auf dem Pfad.
3. **VA-1 vollziehen: dreizehn Stellen in den Bauauftrag, Frist 16.08. abends** (M-1). Bis
   dahin gilt der Auftrag als *in Änderung* — **es darf keine Vorlage zur Freigabe gehen.**
4. **AC-16 fahren** — schließt M2, und M2 gehört zum gezeichneten Teilschnitt. Hängt an nichts
   anderem außer H-6 (ohne Postfach ist es nicht fahrbar).
5. **Den Tor-1-Lauf auf `main` zum Abschluss bringen.** Ohne ihn ist der Stand des
   Standardzweigs nicht gemessen. Das ist keine Zeichnung, nur eine Warteschlange — aber es
   ist die Grundlage jeder Aussage über `main`.

> **Eine Zuweisungslücke auf dem kritischen Pfad:** Blatt 04 weist die **Messung** des
> Mailkopfs zu, nicht den **Versand**. Wer den Versand auslöst, ist nirgends festgelegt.
> Das gehört morgen früh geklärt, nicht am 30.08.

**Parallel, aber nicht auf dem Pfad:** M-8 vollziehen (Fremdprüfung anfordern, Vorlage liegt in
`arbeit/Vorlagen/tor3_anforderung_scheibe1.md`) **und dabei das fehlende Etikett anlegen** ·
das Zeichnungsblatt Scheibe 1 zeichnen · `SPR-10` einen Wortlaut geben · den Herkunftsgraphen
neu rechnen und einchecken.

---

## 10 · Offene Funde — Stand, Verantwortliche, warum nicht still behoben

| Fund | Stand | Verantwortlich | Warum nicht still behoben |
|---|---|---|---|
| **Der Auslöser von Tor 3 kann nicht ziehen** — das Etikett `scheibenabnahme` existiert im Repo nicht; 28 Läufe, alle übersprungen | **neu, heute Abend gemessen** | Mensch (Etikett anlegen) + Harness | ein fehlender Auslöser ist ein Befund, kein Grün. Wer ihn still anlegt, macht aus 28 übersprungenen Läufen rückwirkend nichts |
| **Kein bestandener Tor-1-Lauf auf `main`** seit den Merges | 1 × `cancelled` · 1 × `in_progress` (1 h 07) · 1 × `pending` (1 h 01) | CI / A. Han | eine Warteschlange wartet man ab; ein Grün behauptet man nicht. **`cancelled` ist nicht `success`** |
| **Der mitgeführte Herkunftsgraph auf `main` ist veraltet** | **neu, heute Abend gemessen** | Orchestrator | erzeugter Nachweis — er wird neu gerechnet, nicht von Hand korrigiert |
| **VP-08b** · K04-M07 nennt drei Antwortwortlaute, die das Zielschema anders führt | gesperrt | **Mensch** | Rang 1 (`schema/freiraum_datamodel.sql:737-756`) gewinnt; der Bau darf ihn nicht ändern. **Berührt die Nachrechnung von M3 nicht** — die fünf M3-Punkte sind VP-13/14/17/18/19 |
| **AC-16** · echte Zustellung mit abgelesenem Mailkopf | gesperrt | **A. Han** (Schlüsselbund + fremdes Postfach) | keine Maschine kann in ein fremdes Postfach sehen |
| **MG-08** · „beim Ablauf verschwindet sie wieder" | gesperrt | Bau (**M-9 gezeichnet**) | über keine bekannte Tür prüfbar. **Neu seit 23:42 Uhr:** der vorbereitete Bauweg widerspricht einer gezeichneten Entscheidung vom 11.08. und wird **nicht gebaut** |
| **Tor 3 nie angefordert** (M-8 gezeichnet, nicht vollzogen) | gesperrt · Exitcode 1 | **Mensch** | der Harness schreibt ein Fremdreview nie selbst |
| **0 von 1 231 Akzeptanzkriterien** | unverändert | Konzept-Fabrik | nach K23-M02 ist der Bauauftrag bis dahin unvollständig; Kriterien sind nicht erfindbar |
| **Vier Befunde aus dem Klauselschnitt** (K03-M05 beansprucht ohne Umsetzung · K20-M25 gebaut nur zur Hälfte, nirgends vermerkt · K20-M08 beste Umsetzung ohne Kopfzeile · falsche Behauptung in `app/einladung.py:51-54`) | offen | Bau | gehören in die nächste Scheibe, nicht in einen Schnellschuss |
| **`invite_domain` ist eine Spalte, keine Liste** | **nirgends als Kennung geführt** | offen | trifft den Pilotbetrieb, nicht den Teilschnitt — Liste nach dem 31.08. |
| **`pflege.json` fehlt** | existiert nicht (`ls nachweise/klauselregister/` → nur `register.json/.md`, `triage.json/.md`) | offen | — |

### Der veraltete Herkunftsgraph im Einzelnen

Der eingecheckte Graph wurde heute um **09:06 Uhr** gegen den damaligen `main` gerechnet
(`git log -1 --date=iso b981631` → *„Herkunftsgraph auf dem Stand von main neu gerechnet"*).
Die drei Zusammenführungen von 20:38–20:44 UTC sind nicht darin.

**Frisch gerechnet, ohne eine Datei im Arbeitsbaum zu berühren.** Das Werkzeug schreibt sonst
zwei versionierte Nachweisdateien; es nimmt aber `--ziel` und `--markdown` entgegen:
`python3 werkzeuge/herkunft.py --ziel <außerhalb>/h.json --markdown <außerhalb>/h.md`.
`git status --short` danach unverändert.

| Zeile | auf `main` eingecheckt | frisch gerechnet |
|---|---|---|
| vom Code genannt | 96 | **123** (erklärt 22 · nur erwähnt 101) |
| ausdrücklich erklärt (`umsetzt:`) | 15 | **22** |
| von niemandem gemessen | 48 | **51** |
| davon kritisch | 22 | **23** |
| **Bildschirme gebaut** | **1** (EN-01) | **4** (EN-01 · EN-02 · EN-03 · EN-04) |
| gemessen, aber nicht gebaut | 6 | **9** (neu: K04-D11, K04-G08, K04-M07) |
| Prüffall nie in einem Protokoll | 0 | **2** (`vorpruefung_daten.sql`, `vorpruefung_lauf.sh`) |

**Genau der Fallstrick, den die Morgenfassung selbst benennt — er hat am selben Tag erneut
zugeschlagen.**

### Zwei Zahlen, die nicht verwechselt werden dürfen

„Kritisch ohne Prüffall" steht heute mit **zwei** verschiedenen Werten im Bestand: **23**
(Herkunftsgraph — *vom Code genannt* und ungemessen) und **386** (Triage — *alle* kritischen
Klauseln ohne Prüffall). Das sind zwei Fragen, kein Widerspruch. **Wer sie vermischt, meldet
die Lage um den Faktor 17 zu gut oder zu schlecht.**

---

## 11 · Zahlen des Tages

| Gemessen | Wert | Befehl |
|---|---|---|
| Stand `main` | **`7642f0b`** (früh: `af138ab`) | `git log --oneline -1 main` |
| Änderungsstände heute auf `main` | **22**, davon **6** Zusammenführungen | `git log --oneline --since="2026-08-15 00:00" main \| wc -l` (+ `--merges`) |
| Umfang seit gestern Abend | **25 Dateien · +13 508 / −185** | `git diff --shortstat af138ab..main` |
| #21 · #22 · #23 einzeln | 10 D. +8 583/−182 · 4 D. +237/−3 · 11 D. +4 688/−0 | `git diff --shortstat <merge>^1 <merge>` |
| Offene Anträge | **#24** (4 Dateien, +1 519) · **#25** (**3 Dateien, +757**, gewachsen um 23:42) | `gh pr view <n> --json files` · `git diff --stat main...<zweig>` |
| Tor-1-Läufe auf `main` heute | **0 bestanden** · 1 `cancelled` · 1 `in_progress` · 1 `pending` | `gh run list --branch main --limit 3` |
| Prüflauf gesamt (letzter belegter Lauf) | **8 bestanden · 0 fehlgeschlagen · 3 gesperrt** | `gh run view --job=95070897178 --log` |
| davon Faden `vorpruefung` (neu) | **31 von 32 bestanden**, 1 gesperrt (VP-08b) | ebd. |
| davon `anmeldecode` | 16 von 17 · 1 gesperrt (AC-16) | ebd. |
| davon `mitgliedschaft` | 8 von 9 · 1 gesperrt (MG-08) | ebd. |
| davon `anmeldung` · `einloesung` · `versand` | 30/30 · 18/18 · 9/9 | ebd. |
| Migrationsprüffälle | **110 von 110** | ebd. |
| Negativfälle | **4 von 4**, je an der eigenen Bedingung (N1–N4, Bedingung wörtlich im Protokoll) | ebd. |
| Prüflauf **örtlich** | **0 bestanden · 0 fehlgeschlagen · 11 gesperrt** — dazu `::error::Tor 1c: kein einziger Punkt bestanden` | `bash pruefungen/lauf.sh` (schreibt ohne `--bericht` nichts; `git status` danach unverändert) |
| Klauseln im Bestand | **1 231** | `python3 -c "…len(d['zeilen'])"` gegen `register.json` |
| Klauseln mit Akzeptanzkriterium / Eigentümer | **0 / 0** von 1 231 | ebd. |
| Triage · kritisch | **405** (sicherheitskritisch 120 · mandantenkritisch 107 · freigabekritisch 156 · aufbewahrungskritisch 62 · wiederherstellungskritisch 18) | `python3 -c "…triage.json…['zaehlung']"` |
| Triage · unbestimmt | **826** | ebd. |
| Triage · kritisch **ohne** Prüffall | **386** · mit Prüffall **46** | ebd. |
| Herkunft · vom Code genannt | **123** (erklärt 22 · nur erwähnt 101) | `werkzeuge/herkunft.py --ziel <außerhalb>` |
| Herkunft · genannt, von niemandem gemessen | **51**, davon kritisch **23** | ebd. |
| **Bildschirme des Vertrags gebaut** | **4 von 33** — **29 fehlen** | ebd. |
| Wortmarken über 22 Stationen | **470 von 1 231 Regeln**, 140 Bündel | `werkzeuge/wortmarken.py --ziel <außerhalb>` |
| Klauseln des Teilschnitts (M-7) | **152** über die fünf Stationswörter (+5 aus der Bauspur = 157) | Vereinigungsmenge aus `S1_wortmarken.json` |
| Restrisiken | **genau eines: RR-01 — und das ist GESCHLOSSEN** (09.08.2026) | `grep -oE "RR-[0-9]+" nachweise/restrisiken/restrisiken.md \| sort -u` |
| Tor 3 | **GESPERRT · für keine Scheibe angefordert · Exitcode 1** | `bash pruefungen/tor3.sh` |
| Tor-3-Ablauf | **28 Läufe, alle `skipped`** · Etikett `scheibenabnahme` **existiert nicht** | `gh run list --workflow=tor3.yml` · `gh label list` |
| Fremdreview-Ordner | **2 Dateien: `README.md` · `VORLAGE.md`** — **kein einziges Blatt** | `ls nachweise/fremdreview/` |
| `SPR-10` in `CONTRIBUTING.md` | **0 Treffer**; die Datei endet bei `SPR-9` | `grep -c "SPR-10" CONTRIBUTING.md` |
| Werkzeug für den Durchstich | **0 Treffer** in Skripten | `grep -rl "Durchstich" --include="*.sh" --include="*.py" --include="*.yml" .` |
| Zweige mit gelöschtem Fernzweig (`gone`) | **5** | `git branch -vv \| grep -c gone` |
| **Tage bis zum Endtermin** | **16** (31.08.2026) | `python3 -c "…(date(2026,8,31)-date(2026,8,15)).days"` |

---

## 12 · Stolperfallen für die nächste Sitzung

**1 · Diese Übergabe ist ab dem nächsten Merge wieder überholt — und war es beim Schreiben
schon einmal.** Die Morgenfassung wurde sechs Minuten nach ihrem eigenen Commit falsch
(`git log --follow --oneline HANDOVER_260815.md` → `317ebbb`, `c6d41ea`). Und während dieser
Fassung wuchs Antrag #25 um eine Datei und 510 Zeilen. **Vor jeder Aussage aus der Übergabe:
`git fetch origin`, dann `git log --oneline -1 main` und `gh pr view <n> --json files` gegen
den Kopf dieser Seite halten.**

**2 · `main` ist nicht der Stand des Tages.** Die 22 gezeichneten Entscheidungen liegen auf
zwei offenen Zweigen. Lesen mit
`git show offene/entscheidungen-260815:arbeit/Vorlagen/zeichnung_M1-M10_260815.md` und
`git show nachtraege/korrekturblatt-wega:arbeit/Vorlagen/BA-1_zeichnung_260815.md`. Die Pfade,
die der Bauauftrag nennt, existieren auf `main` **nicht**.

**3 · „Entschieden" ist nicht „wirksam".** Bei jeder der 22 Entscheidungen zuerst fragen:
Liegt die Urkunde vor? Trägt sie **beide** Unterschriften? Siehe Abschnitt 6.

**4 · Die Antragsbeschreibungen von #24 und #25 nennen weniger Dateien, als sie ändern.** #24
sagt „Zwei neue Dateien", ändert **vier** (`BA-1_zeichnung_260815.md` und
`vollzugsauftrag_VA-1_260815.md` sind im Text nicht angekündigt). #25 sagt „Eine neue Datei",
ändert **drei**. **Wer nach Beschreibung freigibt, sieht zwei Zeichnungsblätter und ein
510-Zeilen-Arbeitspaket nicht.**

**5 · `SKIPPED` liest sich wie „bestanden" und ist es nicht.** Tor 3 meldet bei allen fünf
Anträgen `skipping`. Das ist formal richtig — aber der Grund ist schlimmer als gedacht: der
Auslöser hängt an einem Etikett, das es nicht gibt. **28 Läufe, alle übersprungen. Tor 3 ist
bis heute kein einziges Mal mit einem gültigen Nachweisblatt gelaufen.**

**6 · `cancelled` ist auch kein „bestanden".** Ein Lauf auf `main` steht heute auf
`completed / cancelled`. Wer nur auf `completed` schaut, meldet Grün. K23-M22 kennt vier
Zustände; ein abgebrochener Lauf ist *nicht ausgeführt*.

**7 · Ein Messbefehl kann ein Schreibbefehl sein — es geht auch anders.**
`werkzeuge/herkunft.py` schreibt ohne Schalter `nachweise/herkunft/herkunft.json` und `.md`.
**Aber es nimmt `--ziel` und `--markdown`**, `werkzeuge/wortmarken.py` nimmt `--ziel`,
`pruefungen/lauf.sh` schreibt nur mit `--bericht`. **Vor dem Ausführen eines
Nachweisgenerators: die Hilfe lesen und die Ausgabe aus dem Repo herauslenken.** So sind alle
Zahlen dieser Übergabe entstanden, ohne eine Datei zu berühren.

**8 · `pruefungen/lauf.sh` läuft ohne Datenbank nicht — und das ist richtig so.** Ohne
Postgres meldet er **0 bestanden · 0 fehlgeschlagen · 11 gesperrt** und dazu
`::error::Tor 1c: kein einziger Punkt bestanden — der Lauf hat nichts gemessen.` **Er meldet
nicht grün.** Wer Zahlen braucht, nimmt sie aus der CI, nicht vom eigenen Rechner. Belegbare
Fundstelle: Lauf `31908885182`, Job `95070897178`, 15.08. 21:15–21:16 UTC.

**9 · Der letzte eingecheckte Manifest-Stand ist vom 14.08. und kennt M3 nicht.**
`nachweise/manifeste/tor1c_260814.json` führt **8 · 0 · 2** über fünf Fäden — der Faden
`vorpruefung` fehlt. Die heutige Zahl **8 · 0 · 3** über sechs Fäden steht **in keinem
eingecheckten Manifest**, nur im CI-Protokoll. Zufällig ist die erste Zahl gleich; die Läufe
sind es nicht.

**10 · Manifeste werden nicht nachgezogen.** Sie protokollieren Läufe gegen die Fassung v1.1.
Wer ein Manifest umschreibt, macht aus einem Nachweis eine Behauptung (K23-M18). Die neue
Prüfsumme trägt das **nächste** Manifest, nicht ein altes.

**11 · Beim Eintragen der dreizehn Stellen von unten nach oben arbeiten** (Stelle 13 zuerst),
am **Ankerzitat** nachschlagen, **nie an der Zeilennummer**. Stimmt der Anker nicht: nicht
eintragen, sondern fragen. Der Grund ist gemessen, nicht vermutet — siehe Abschnitt 13 (a).

**12 · Erst archivieren, dann einfrieren.** Beim letzten Fassungswechsel ist die abgelöste
Fassung **v1.0 verlorengegangen**; im Verzeichnis liegen heute nur v1.1 und deren
Zeichnungsdatei.

**13 · `CLAUDE.md` Zeile 151 sagt, die Gegenzeichnung des Auftragnehmers stehe aus.** Das
Zeichnungsblatt von heute hält dagegen fest, sie sei am **08.08.2026** erteilt. **Beides ist
aus diesem Repo nicht entscheidbar** — der Zeichnungsnachweis liegt in der Konzept-Fabrik.
Bis das geklärt ist: die Zeile weder glauben noch ändern, sondern nachfragen. **Achtung, zwei
verschiedene Dinge:** Die Kopfzeile derselben Datei sagt, A. Hans Unterschrift unter die
**Anlage „Bauverfahren"** stehe aus — das ist H-3 und davon unabhängig.

**14 · Der Harness darf den Vollzug nicht ausführen.** Der Bauauftrag liegt in der
Konzept-Fabrik; die Verfassung verbietet, dort eine Datei zu ändern. Der Harness legt die
Anweisung Stelle für Stelle vor — mehr nicht.

**15 · Wer den Tag nach Codeumfang beurteilt, misst ihn falsch.** Von 25 berührten Dateien sind
**zwei** Anwendungscode (`app/haupt.py`, `app/vorpruefung.py`) und drei Bildschirme. Die
übrigen 20 sind Nachweis, Werkzeug, Plan oder Vorlage.

**16 · `scheibe/vorpruefung-m3` steht 17 Stände hinter `main`.**
`git rev-list --count scheibe/vorpruefung-m3..main` → **17**. `git branch -vv` zeigt daneben
„behind 16" — das ist der Abstand zum **eigenen Fernzweig**, nicht zu `main`. Wer dort
weiterarbeitet, arbeitet auf einem überholten Stand.

---

## 13 · Eigene Fehler des Tages

### (a) Die erste Fassung des Korrekturblatts BA-1 ist an der eigenen Prüfung gescheitert

**Gemessen, aus der Änderungsbeschreibung von `b801f59`:** *„Prüfbericht: **76 Meldungen** aus
sechs Richtungen, zusammengeführt und einzeln am Original nachgeprüft → **10
zeichnungshindernd**. Davon mit der Neuschrift bereits behoben: 7. Jetzt behoben: 3."*

**Berichtigung gegenüber dem Entwurf dieser Übergabe:** Dort standen *„76 Mängel, davon 26
zeichnungshindernd"*. **Die 26 sind nirgends belegt** — die Zahl ist 10. Und die Aussage „neu
geschrieben, nicht geflickt" gilt nur für die Zeit **vor** dem ersten Commit: die Geschichte
der Datei zeigt drei Stände (`a129e41` +569, `b801f59` +141/−43, `8fca4db` +16/−2), also eine
Neuschrift und danach **zwei Nachbesserungen**.

Zwei der behobenen Mängel waren strukturell:

1. **Die Zeilennummern zerfielen beim eigenen Vollzug.** Wer Stelle 1 einträgt, verschiebt
   alle folgenden Zeilennummern. **Gemessen und nachgestellt:** *„Zeilenverschiebung auf einer
   Kopie nachgestellt: Z. 728 traf nach dem ersten Einschub Bedingung 2 statt Bedingung 6."*
   Behoben durch **Ankerzitate statt Zeilennummern** und die Regel: **von unten nach oben
   arbeiten.**
2. **Nur ein einziges Gate war benannt.** Die erste Fassung nannte Gate 15; die vier
   anschlagenden Gates sind 11, 13, 14, 15. Und Kreuz K3 hatte zwei Wege statt vier — **Weg
   3-III, der einzige, der die Gates ohne Änderung an K23 auflöst, fehlte ganz.**

**Die Lehre:** Ein Vollzugsdokument muss den Vollzug **überleben**. Ein Verweis, der sich durch
die eigene Ausführung ändert, ist kein Verweis.

### (b) Das Zeichnungsblatt führte die beiden vorhandenen Manifeste unter „nachzuziehen"

Das war falsch und ist am selben Tag berichtigt worden. **K23-M18 verlangt ein
unveränderliches Manifest.** Ein Manifest ist das Protokoll eines Laufs, der gegen die Fassung
v1.1 lief; es umzuschreiben hätte einen **Nachweis in eine Behauptung** verwandelt. Nachgezogen
wird nur `CLAUDE.md` Zeile 151.

**Die Lehre:** Wenn eine Prüfsumme veraltet, ist der Reflex „überall nachziehen" falsch.
Nachgezogen wird nur, was eine **Aussage über den Jetzt-Zustand** macht. Was ein **vergangenes
Ereignis** protokolliert, bleibt stehen.

### (c) Der Entwurf dieser Übergabe trug einen veralteten Vorbehalt

Er schrieb: *„Die zweite Fassung von BA-1 ist noch nicht gegen den zusammenführenden
Abschlussbericht geprüft — der lief bei Antragstellung noch."* Der Bericht war um **22:27 Uhr**
eingearbeitet, die Übergabe wurde um **23:36 Uhr** geschrieben. **Ein Vorbehalt, der einmal
richtig war, wird nicht durch Wiederholung richtig.** Wer „noch nicht gemessen" schreibt, muss
im selben Zug prüfen, ob es inzwischen gemessen ist.

### Drei weitere Selbstmeldungen desselben Musters

- **Die Regel wirkte bei der eigenen Arbeit nicht.** Der Halt in `/scheibe` wurde heute gebaut
  (#22) — und M3 wurde danach über einen Ablauf gebaut, der `/scheibe` **nicht ausführt** (#23).
  Sachlich folgenlos, weil keine Abnahme anstand. **Die Lehre: eine Regel, die nur in einem
  Kommando steht, greift nicht, wenn man das Kommando nicht benutzt.** Deshalb ist die feste
  `--stand`-Zeile im Kopf jeder Übergabe kein Beiwerk — sie ist der Teil, der unabhängig vom
  Weg wirkt. **Verschärfend, seit 23:42 gemessen:** derselbe Halt hängt zusätzlich an einem
  Etikett, das es nicht gibt.
- **Ein Messbefehl war ein Schreibbefehl.** `python3 werkzeuge/herkunft.py` wurde ausgeführt,
  um nachzusehen — und schrieb dabei zwei versionierte Nachweisdateien um (+1 347/−64 Zeilen).
  Zurückgesetzt mit `git checkout --`. **Die Ironie, die nicht verschwiegen wird:** genau
  dieser Fehlgriff hat den wichtigsten Fund des Abends erzeugt — dass der eingecheckte Graph
  veraltet ist. **Ein Fund aus einem Fehler bleibt ein Fehler.** Nachtrag dieser Fassung: das
  Werkzeug hätte den Schalter `--ziel` gehabt. **Der Fehler war nicht das Ausführen, sondern
  das Nicht-Lesen der Hilfe.**
- **Eine Bereinigung hinterließ selbst einen Rest.** In #21 stehen zwei Änderungsstände, die
  tote Variablen entfernen; einer davon ist ausdrücklich betitelt *„Noch eine tote Variable —
  diesmal von mir selbst erzeugt"* (`2bf7e27`).

---

## 14 · Womit die nächste Sitzung anfängt

1. **`git fetch origin`, dann nachsehen, ob die Tor-1-Läufe auf `main` durchgelaufen sind** —
   `gh run list --branch main --limit 5`. Bis dahin gibt es **keinen bestandenen Nachweis auf
   dem Standardzweig**; einer der Läufe steht auf `cancelled` und muss neu angestoßen werden.
2. **#24 und #25 freigeben lassen** — A. Han, H-1 und H-2. Ohne sie steht der Tag auf zwei
   Zweigen und nicht im Projekt. **#25 hat sich um 23:42 nochmals geändert — den neuen Stand
   lesen, nicht den von 21:09.**
3. **VA-1 vollziehen** — dreizehn Stellen, **Frist heute Abend (16.08.)**, Ausführender A. Han,
   von unten nach oben, am Ankerzitat.
4. **M-8 vollziehen: die Fremdprüfung tatsächlich anfordern** — und **zuerst das Etikett
   `scheibenabnahme` anlegen**, sonst bleibt der Auslöser tot. Vorlage:
   `arbeit/Vorlagen/tor3_anforderung_scheibe1.md`.
5. **AC-16 fahren** — schließt M2. Vorher klären, **wer den Versand auslöst**; zugewiesen ist
   bisher nur die Messung.
6. **Den Herkunftsgraphen neu rechnen und den neuen Stand einchecken** — 4 statt 1 Bildschirm,
   123 statt 96 genannte Klauseln.

---

## Was in dieser Übergabe nicht gemessen werden konnte

Alles Folgende ist **übernommen**, nicht nachgerechnet. Es steht hier, damit niemand es für
gemessen hält.

1. **Alles außerhalb dieses Repositoriums.** Der Bauauftrag, seine beiden Anlagen, die 24
   Konzepte, das K00-Beschluss-Log und der Ordner `arbeit/Founder_Beschluesse/` liegen in der
   Konzept-Fabrik. `ls arbeit/` → nur `Bauberichte`, `Plaene`, `Vorlagen`. Betroffen sind:
   alle Abschnittsnummern (10a, 11.4, 12.1–12.9), die Wortlaute der Tor-II-Bedingungen, die
   Blätter 04, 31, 36, 46, 49, 57, 62, 63, die Klauseltexte von K03, K04, K16, K23 und die
   Zählungen „53 / 21 / 51 / 33 Fundstellen".
2. **Die Prüfsumme des Founder-Blatts zu S28** (`9e321461…`). Das Zeichnungsblatt sagt, sie sei
   selbst nachgerechnet worden. Aus dem Lieferrepo ist das nicht wiederholbar.
3. **A. Hans Zeichnung des Bauauftrags v1.1 am 08.08.2026.** Behauptet im Zeichnungsblatt,
   bestritten von `CLAUDE.md:151`. Kein Nachweis in diesem Repo.
4. **Die Befunde M-9 und M-10 aus `arbeitspakete_M7-M10_260815.md`.** Sie stützen sich auf
   Blatt 62 und 63 vom 11.08.2026 und auf Beschluss Nr. 125 — alle drei liegen nicht hier. Nur
   die Zahlen zu M-7 (152 Regeln) und M-8 (Etikett fehlt, 28 Läufe übersprungen) sind selbst
   nachgemessen.
5. **Die Zahl „268 Fundstellen im Repository"** aus der Entscheidungsvorlage E9. Meine eigene
   Zählung liefert **302** — mit anderem Ausschluss-Satz. Die Größenordnung stimmt, die
   Zählweise ist nicht rekonstruierbar.
6. **Die Bewertung, dass Weg 3-III die Gates 13, 14 und 15 „auflöst".** Das ist eine
   rechtliche Einschätzung der Entscheidungsvorlage, keine Messung — und sie wirkt erst mit
   dem ausgefertigten Beschlussblatt.
7. **Die Aussage „M3 ist eingetreten" für den Stand von `main` selbst.** Der belegende Lauf
   ist auf dem Zweig von #25 gefahren. Dass dieser Zweig `main` `7642f0b` vollständig enthält,
   ist gemessen (`git merge-base --is-ancestor`). Dass er dieselbe Umgebung hatte, ist es
   nicht. **Ein Lauf auf `main` steht aus.**
8. **Der Wortlaut der beiden Weisungen des Auftraggebers.** Er ist in den Zeichnungsblättern
   zitiert. Die Blätter sind vom Harness angelegt; ein von M. Veil selbst erzeugter Nachweis
   der Weisung liegt in diesem Repo nicht vor.