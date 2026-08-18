Alle Messungen liegen vor. Hier mein Prüfbericht.

---

# NACHPRÜFUNG DER 47 FUNDE · 16.08.2026

## 1 · Urteil in drei Sätzen

Die Steuerungstexte sind **nicht flächendeckend falsch, sondern an den Nahtstellen abgerissen**: die Sachaussagen halten fast durchweg (die Klauselzählung 1231, die fünfzehn Gates, die Blatt-11- und Blatt-26-Verweise sind sämtlich zeilengenau), aber **jede Angabe, die auf eine fremde Datei zeigt oder einen Zustand behauptet, ist verrottet** — 27 der 47 Meldungen halten stand, davon fünf, die einen Bau anhalten.

Gefährlich ist es an drei Stellen: `app/` steht in **keiner** Schreib- oder Lesegrenze des Harness, obwohl dort seit dem 10.08. die ganze Anwendung liegt — der Bau-Agent hat für sein Arbeitsverzeichnis keine Erlaubnis und der blinde Prüf-Agent kein Verbot; das Tor-3-Etikett `scheibenabnahme` **existiert nicht**, weshalb alle 29 Tor-3-Läufe übersprungen wurden, während zwei Steuerungstexte den Fehler beim Benutzer suchen; und `/scheibe` Schritt 9 trägt Glied 2 und 3 des Manifests bis heute als *gesperrt*, obwohl beide Prüfsummen belegt sind und nachrechnen.

Das gemeinsame Muster ist scharf: **Behauptungen über Code werden gemessen, Behauptungen über Dokumente nie** — Tor 1 rechnet Klauselregister und Herkunftsgraph nach, aber keine einzige Fundstelle, und selbst die vorhandene Aktualitätsprüfung des Herkunftsgraphen meldet nur `::warning::` und sperrt nicht (`tore.yml`:147) — weshalb der eingecheckte Graph heute nachweislich veraltet ist.

---

## 2 · Die Funde, die standhalten

### A · HÄLT DEN BAU AN

---

**A1 · `app/` steht in keiner Grenze des Harness**
*(führt F3, F11, F12 zusammen)*

**Stelle:** `CLAUDE.md`:113 · `.claude/agents/bau-agent.md`:42–43 · `.claude/agents/pruef-agent.md`:56

**Was dort steht:** „Schreibt nach | `install/ mail/ migrations/ seeds/ schema/ werkzeuge/`" · „Du schreibst nach: … `arbeit/Bauberichte/`" · „Nie gelesen: `install/ mail/ migrations/ seeds/ schema/ werkzeuge/ arbeit/`"

**Was gilt:** `app/` fehlt in allen dreien.

**Mein Beleg:**
```
$ git ls-tree main --name-only -r | grep '^app/' | wc -l      →  15
$ git log --diff-filter=A --date=short -- app/ | tail -1
  b1d17bd 2026-08-10 Scheibe 1 · Anmeldung: der erste senkrechte Schnitt (#5)
$ grep -rn 'app/' .claude/ CLAUDE.md                          →  KEINE TREFFER
$ grep -n 'compileall\|ruff check' .github/workflows/tore.yml
  79:  python3 -m compileall -q werkzeuge mail app
  84:  ruff check werkzeuge mail app
```
Tor 1 lintet `app/` ausdrücklich mit — der Ablauf kennt das Verzeichnis, die Steuerung nicht. **Zusätzlich selbst geprüft:** die Grenze steht **nicht** in der gezeichneten Anlage (`grep -n 'Schreibt nach\|werkzeuge/\|app/' Anlage_Bauverfahren.md` → keine Treffer). Sie ist eine Zutat der CLAUDE.md und **ohne Berührung der Prüfsumme berichtigbar**.

**Satzfertige Korrektur** — `CLAUDE.md`:113:
> | Schreibt nach | `app/ install/ mail/ migrations/ seeds/ schema/ werkzeuge/` sowie die erzeugten Nachweise unter `nachweise/` und die Bauunterlagen unter `arbeit/` | ausschließlich `pruefungen/` |

`bau-agent.md`:42 — erste Spalte: `` `app/` `install/` `mail/` `migrations/` `seeds/` `schema/` `werkzeuge/` ``, dazu ein Satz: *„`app/` trägt seit Antrag #5 (10.08.2026) die Anwendung des dünnen Fadens. Die Grenze wurde vor dem ersten Anwendungscode geschrieben."*

`pruef-agent.md`:56 — „Nie gelesen: `app/ install/ mail/ …`", dazu: *„**`app/` ist der wichtigste Eintrag dieser Liste** — dort liegt der gesamte Anwendungscode. Wer ihn liest, schreibt den Prüffall auf den Code."*

---

**A2 · `/scheibe` Schritt 9 sperrt zwei belegte Manifestglieder**
*(F9)*

**Stelle:** `.claude/commands/scheibe.md`:74–75 (auf `main`; im Arbeitsbaum verschoben)

**Was dort steht:** „Glied 2 und 3 tragen bis auf Weiteres *gesperrt* — der Bauauftrag hat keine Prüfsumme (V-13), die Anlage existiert nicht."

**Was gilt:** Beide sind belegt. Es ist dieselbe Behauptung, die in Schritt 1 und 2 bereits berichtigt wurde — in Schritt 9 hat sie niemand angefasst.

**Mein Beleg:**
```
$ shasum -a 256 03_N5_BAUAUFTRAG_v1.1_260807.md
  3341362f8962af9d48de4afdc863284d5261e9ede3c997fb32bd83933186e43d
$ shasum -a 256 Anlage_Bauverfahren.md
  ded747a7a98bcc7fa11442b92e0d09a244c0b4ee2051f10fb251bdb68300274d   (= CLAUDE.md:7)
$ ./install.sh --pruefsumme
  OK Pruefsumme der Anlage stimmt mit dem Kopf der CLAUDE.md ueberein.   EXIT=0
```
**Gegenprobe, die keiner der fünf gemacht hat:** Ich habe die Mechanik auch im Negativfall gefahren —
```
$ FREIRAUM_ANLAGE=<falsche Datei> ./install.sh --pruefsumme
  X  Pruefsumme weicht ab.   EXIT=1
```
Sie misst wirklich, sie behauptet nicht. Beide Werte gehören ins Manifest.

**Satzfertige Korrektur:**
> Glied 2 und 3 sind belegt und werden in das Manifest **übernommen**, nicht als *gesperrt* geführt: der Bauauftrag v1.1 trägt `3341362f…` (gezeichnet M. Veil 07.08., A. Han 08.08.2026), die Anlage „Bauverfahren" trägt `ded747a7…`, nachgerechnet von `./install.sh --pruefsumme` (Exit 0 bei Übereinstimmung, Exit 1 bei Abweichung). Danach Klauselregister, Herkunftsgraph und Restrisikoliste fortschreiben.

---

**A3 · Schritt 2 schickt 1231 Klauseln an einen Adressaten, den es nicht gibt**
*(F19)*

**Stelle:** `.claude/commands/scheibe.md`, Schritt 2

**Was dort steht:** „Fehlt einer Klausel das **Akzeptanzkriterium**, liefert es der in derselben Zeile eingetragene fachliche Eigentümer nach … Die Klausel geht als Rückfrage hinaus."

**Was gilt:** Der Klauselwortlaut (K23-M02, K23:57) ist korrekt abgeschrieben. Aber **keine** Registerzeile trägt einen Eigentümer, und **keine** ein Akzeptanzkriterium. Der Weg hat für alle 1231 Klauseln keinen Adressaten.

**Mein Beleg:**
```
$ python3 -c "import json;print(json.load(open('nachweise/klauselregister/register.json'))['zaehlung'])"
  {'klauseln': 1231,
   'leere_felder': {'eigentuemer': 1231, 'akzeptanzkriterium': 1231, 'test': 1231, …},
   'ohne_akzeptanzkriterium': 1231, 'vollstaendige_zeilen': 0}
```

**Satzfertige Korrektur:**
> Fehlt einer Klausel das **Akzeptanzkriterium**, liefert es nach K23-M02 (K23:57) der in derselben Zeile eingetragene fachliche Eigentümer nach. **Gemessen am 16.08.2026 ist dieses Feld in allen 1231 Registerzeilen leer, ebenso das Akzeptanzkriterium** (`register.json`, `zaehlung.leere_felder`). Solange das so ist, gibt es für keine Klausel einen benannten Adressaten: die Zuweisung fachlicher Eigentümer ist als **eigene Vorbedingung** an den Menschen zu melden (Schwelle S2, Blatt 11:202), bevor Schritt 2 trägt.

---

**A4 · Schritt 7 baut die falsche Datenbank**
*(F17)*

**Stelle:** `.claude/commands/scheibe.md`:**60** — *nicht* :65; die Meldung nennt den Arbeitsbaum-Stand, auf `main` ist es Zeile 60.

**Was dort steht:** „`./aufbau.sh` (Prüfumgebung, **kein** Pilotlauf, `aufbau.sh`:11–14) → `./pruefungen/lauf.sh`."

**Was gilt:** Zwei Fehler in einer Zeile. `./aufbau.sh` ohne Schalter baut `freiraum` auf Port 55432 mit Vorläufer und Seed; `lauf.sh` erwartet `freiraum_ci`. Und `aufbau.sh`:11–14 trägt die zitierte Aussage nicht.

**Mein Beleg:**
```
$ sed -n '11,14p' aufbau.sh
  #  (Entscheidung A. Han, 07.08.2026). Das Skript lief seither ins Leere.
  #  Jetzt laeuft M30 an ihrer Stelle.
  #      ./aufbau.sh              nur Datenbank
$ sed -n '16,18p' aufbau.sh
  #      ./aufbau.sh --ci   die Datenbank, die Tor 1b und pruefungen/lauf.sh
  #                         erwarten … Name freiraum_ci, Port 55433.
$ sed -n '20,21p' aufbau.sh
  #  WICHTIG: Das hier ist eine PRUEFumgebung, kein Pilotlauf.
$ sed -n '29p' pruefungen/lauf.sh
  : "${PGDATABASE:=freiraum_ci}"
```

**Satzfertige Korrektur:**
> `./aufbau.sh --ci` (Prüfumgebung `freiraum_ci` auf Port 55433 — die Datenbank, die `pruefungen/lauf.sh` erwartet; **kein** Pilotlauf, `aufbau.sh`:16–18 und :20–23) → `./pruefungen/lauf.sh`

---

**A5 · Die Übergabe hält einen grünen Stand für ungemessen**
*(F39 und F40 zusammengeführt)*

**Stelle:** `HANDOVER_260815.md` auf `uebergabe/260815-abend`, Kopftabelle Z. 21; Abschn. 8 Vorbehalt 2

**Was dort steht:** „Tor-1-Lauf auf `main` | **kein einziger abgeschlossen und bestanden** … `31907503866` `pending`" · „**Ein Lauf auf `main` steht aus.**"

**Was gilt:** Der Lauf ist abgeschlossen und grün, auf genau dem Stand, den die Übergabe als ungemessen führt.

**Mein Beleg:**
```
$ gh run view 31907503866 --json headSha,status,conclusion
  7642f0b78a3cf157f3c7b7cd03161d5294d45bad  completed  success
$ gh run view 31907503866 --json jobs
  Tor 1a · Lint und Geheimnisschranke            success
  Tor 1b · Migration gegen frische Datenbank     success
  Tor 1c · Prueflauf gegen die blinden Prueffaelle success
  Tor 1 · Sperre                                 success
$ git log --oneline -1 main   →  7642f0b
```

**Satzfertige Korrektur:**
> Tor-1-Lauf auf `main`: **bestanden.** Lauf `31907503866` auf dem Änderungsstand `7642f0b` ist am 16.08.2026 abgeschlossen — Tor 1a, 1b, 1c und Sperre je `success`. Die Läufe zu #21 und #22 stehen auf `cancelled`; das ist folgenlos, weil der Lauf zum letzten Stand durchgelaufen ist. **Es ist kein Lauf neu anzustoßen. M3 ist damit auch für den Stand von `main` selbst belegt.**

---

### B · LÄSST EINE PRÜFUNG AUS

---

**B1 · Das Tor-3-Etikett existiert nicht — und zwei Texte suchen den Fehler beim Benutzer**
*(F10 und F47 zusammengeführt; der schwerste Fund dieser Gruppe)*

**Stelle:** `HANDOVER_260814.md`:219–220 · `.claude/commands/scheibe.md`, Schritt 10

**Was dort steht:** „**Tor 3 läuft nicht bei jedem Antrag** — nur mit Etikett `scheibenabnahme` oder von Hand. **Wer es sucht und nicht findet, hat nicht das Etikett gesetzt.**" · „nicht weil jemand es abgelehnt hätte, sondern weil **nie ein Moment kam**, in dem die Frage gestellt wurde."

**Was gilt:** Das Etikett lässt sich gar nicht setzen — es ist im Repository nicht angelegt. Beide Texte verdecken damit eine mechanische Sperre mit einer menschlichen Erklärung.

**Mein Beleg:**
```
$ gh label list
  bug · documentation · duplicate · enhancement · good first issue ·
  help wanted · invalid · question · wontfix        (neun Vorgaben; scheibenabnahme fehlt)
$ gh run list --workflow=tor3.yml --limit 100 --json conclusion,status
  29  completed skipped                              (kein einziger ausgeführt)
$ gh pr list --state all --limit 40 --json number,labels
  25 PRs, jeder mit 0 Etiketten
$ sed -n '51p' .github/workflows/tor3.yml
  contains(github.event.pull_request.labels.*.name, 'scheibenabnahme')
```

**Satzfertige Korrektur** — `HANDOVER_260814.md`:219:
> **Tor 3 läuft bei keinem Antrag — und zwar nicht, weil niemand das Etikett gesetzt hat, sondern weil es das Etikett nicht gibt.** `gh label list` führt nur die neun mitgelieferten Etiketten. Gemessen: `gh run list --workflow=tor3.yml` → 29 Läufe, alle `completed skipped`. **Erst das Etikett anlegen, dann kann der Auslöser ziehen.** Bis dahin bleibt nur `workflow_dispatch`. Ein fehlender Auslöser ist ein Befund, kein Grün.

`scheibe.md` Schritt 10, Ergänzung nach dem Satz über den Halt:
> Zum anderen — und das ist mechanisch — hängt der Ablauf `Tor 3` am Etikett `scheibenabnahme`, das im Repository **nicht angelegt** ist. Ein Ja auf die Frage oben läuft heute ins Leere; das Anlegen des Etiketts gehört als benannter offener Punkt in die Vorlage.

---

**B2 · Sämtliche Zeilenverweise auf den Bauauftrag zeigen auf die abgelöste Fassung**
*(F6, erweitert um einen eigenen Fund)*

**Stelle:** `CLAUDE.md` Kopftabelle Z. 10; Abschn. 0 Z. 26; Abschn. 1 Z. 44–62; Abschn. 3 Z. 131; Abschn. 4 Z. 159

**Was dort steht:** u. a. „Endtermin 31.08.2026 (Bauauftrag :1, :39, :40)" · „Wortgleich aus Bauauftrag :80–86" · „Bauauftrag §9 (:631–699)" · „Tor I Nr. 6 (:649)"

**Was gilt:** Bis auf `:1` trifft **kein einziger**. Sie sind gegen v1.0 gebildet; gezeichnet ist v1.1 mit 1035 Zeilen. Der Versatz wächst von +3 auf +47.

**Mein Beleg** (jede Zeile selbst aufgeschlagen, v1.1, SHA `3341362f…`, 1035 Zeilen):

| CLAUDE.md sagt | dort steht heute | richtig ist |
|---|---|---|
| `:39, :40` Endtermin | Fassung v1.1 / Prüfsummenfeld | `:16`, `:43` |
| `:80–86` Rangfolge | H3-Pfadtabelle („beschreibt den Modellpfad der Anwendung") | `:97–105` |
| `:88–90` Zielschema | — | `:107–109` |
| `:42` 24 Konzepte | Prüfsummenfeld | `:45` |
| `:614–627` Nicht Gegenstand | L8-Löschweg | `:661–675` (Abschn. 8) |
| `:128–136` W2a/W2b | Altfälle T0–T21 | `:149–155` |
| `:631–699` Abschnitt 9 | leer / Abschn. 8 | `:678–750` |
| `:649` Tor I Nr. 6 | KI-VO-Einweisung | `:696` |
| `:306` „unveränderlich" | Frist der Annahmeentscheidung | `:337` |

```
$ grep -n '^## ' 03_N5_BAUAUFTRAG_v1.1_260807.md
  661:## 8 · Was ausdrücklich nicht beauftragt ist
  678:## 9 · Abnahme in drei Toren
  751:## 10 · Berichtspflichten
$ sed -n '696p' …
  | 6 | jeder Gegentest scheitert an der vorgesehenen Regel, mit Meldung im Wortlaut | erfüllt |
```

**Eigener Zusatzfund, den keiner der fünf ausgemessen hat:** Die **gezeichnete Anlage selbst** trägt durchgehend dieselbe alte Zählung — und ihre Verweise sind ebenso verrutscht:
```
Anlage :8   „Auftrag Z. 52–56" (Anlage Bauverfahren)  →  steht heute auf :75
Anlage :37  „Auftrag Z. 82"    (Rangfolge Rang 0)     →  steht heute auf :97–105
Anlage :98  „Auftrag Z. 379"   (Positivfall)          →  steht heute auf :409
```
Das ist der harte Teil: **die Anlage lässt sich nicht berichtigen, ohne ihre Prüfsumme zu ändern und nach ihrer eigenen Regel eine Neuzeichnung auszulösen.** Die CLAUDE.md kann sofort nachgezogen werden, die Anlage braucht den Weg über das Änderungsverfahren.

**Satzfertige Korrektur** — alle Verweise auf v1.1 umstellen (Kopftabelle `:1, :16, :43` · Abschn. 0 `§9 (:678–750)` · Abschn. 1 `:97–105`, `:107–109`, `:45`, `:661–675` mit F04 `:663`, F28 `:665`, K06-D13 `:667`, Nr. 85 `:670`, `:149–155` · Abschn. 3 und 5 `Tor I Nr. 6 (:696)` · Abschn. 4 `(:337)`), dazu eine Zeile in die Kopftabelle:
> **Alle `:`-Verweise auf den Bauauftrag beziehen sich auf die gezeichnete Fassung v1.1 vom 07.08.2026 (Prüfsumme `3341362f…`, 1035 Zeilen).** Die Anlage „Bauverfahren" zählt noch nach v1.0; ihre Berichtigung ändert ihre Prüfsumme und ist nur über das Änderungsverfahren möglich.

---

**B3 · Fünf README-Fundstellen zeigen ins Leere, eine davon auf nichts**
*(F7)*

**Stelle:** `CLAUDE.md`:180, 182, 183, 184; dazu Abschn. 3 Z. 131

**Was dort steht:** „nach F36 wird nichts gelöscht (`README.md`:31, `aufbau.sh`:11–14)" · „(`README.md`:34)" · „(`README.md`:30)" · „(`README.md`:35)"

**Was gilt:** Der README ist am 14.08.2026 von 84 auf 265 Zeilen umgeschrieben worden. An den Zeilen 30–35 stehen heute Begriffserklärungen zu Branch und Pull Request. **F36 kommt im heutigen README überhaupt nicht mehr vor.**

**Mein Beleg:**
```
$ wc -l README.md → 265        $ git show 1d667ba:README.md | wc -l → 84
$ sed -n '30,35p' README.md
  - „Nebenspur" heißt im Fachwort Branch: eine Arbeitskopie …
  - „Antrag" heißt Pull Request: die Bitte, die Nebenspur …
$ grep -n 'F36\|gelöscht' README.md            →  KEINE TREFFER
$ grep -n 'Keine Zugangsdaten' README.md       →  196
$ grep -n 'Negativfälle jeder' README.md       →  204
$ grep -n 'Verarbeitung in der EU' README.md   →  207
$ grep -n 'F36' aufbau.sh                      →  21
```

**Satzfertige Korrektur** — `CLAUDE.md` Abschn. 5:
> nach F36 wird nichts gelöscht (`aufbau.sh`:21–22; F36 selbst in der Konzept-Fabrik, im README nicht mehr geführt) · **Vier Negativfälle je Migration müssen scheitern** (`README.md`:204) · **Keine Geheimnisse im Repo** (`README.md`:196) · ein Dienst außerhalb bricht K13 (`README.md`:207)

Abschn. 3 Z. 131: „und `README.md`:204 des Repos".

---

**B4 · `/pruefe` behauptet, den Klauselschnitt gebe es nicht**
*(F13)*

**Stelle:** `.claude/commands/pruefe.md`:24

**Was dort steht:** „Scheibennummer → die Klauseln dieser Scheibe (**Zuordnung existiert noch nicht**)"

**Was gilt:** Sie existiert seit Antrag #21 für Scheibe 1. Wörtlich dieselbe Behauptung, die in `scheibe.md` Schritt 2 bereits berichtigt wurde. Richtig bleibt allein: das Zeichnungsblatt trägt kein Kreuz.

**Mein Beleg:**
```
$ ls nachweise/klauselschnitt/
  S1_bauspur_nachpruefung.md  S1_leseblaetter.md  S1_wortmarken.json
  S1_wortmarken.md  S1_zeichnung.md
$ git log --oneline -15 | grep '#21'
  1c15c95 Merge pull request #21 … schnitt/scheibe1
```

**Satzfertige Korrektur:**
> Scheibennummer → die Klauseln dieser Scheibe. Für Scheibe 1 liegt der Schnitt seit Antrag #21 unter `nachweise/klauselschnitt/` (Zeichnungsblatt `S1_zeichnung.md`, Lesefassung `S1_leseblaetter.md`, Wortmarken `S1_wortmarken.md`). Das Zeichnungsblatt trägt **kein gesetztes Kreuz** — der Schnitt ist gemessen, nicht gezeichnet; die Zuordnung wird deshalb als *vorläufig* ausgewiesen. Für Scheibe 2 und später existiert sie noch nicht.

---

**B5 · Die Tor-3-Zeile verschweigt den eigenen Nachweisteil**
*(F5)*

**Stelle:** `CLAUDE.md`:75, Spalte „Werkzeug"

**Was dort steht:** „**3 · fremd** | … | außerhalb dieses Harness"

**Was gilt:** Das Review entsteht weiterhin außerhalb — aber seit dem 14.08. hat Tor 3 einen mechanischen Nachweisteil **im** Harness. Die leere Spalte verschweigt ihn.

**Mein Beleg:**
```
$ git log --diff-filter=A --oneline -- .github/workflows/tor3.yml pruefungen/tor3.sh werkzeuge/fremdreview.py
  ce3dc93 Tor 3 wird eine Institution: der fremde Blick hinterlaesst jetzt einen Nachweis
$ sed -n '9,12p' .github/workflows/tor3.yml
  # DIESER LAUF ERZEUGT KEIN REVIEW. Er prueft, ob ein abgelegtes Blatt
  # vollstaendig, gezeichnet und pruefsummiert ist.
$ ls nachweise/fremdreview/  →  README.md  VORLAGE.md
```

**Satzfertige Korrektur:**
> | **3 · fremd** | Fachliche Eignung gegen **Roh-Evidenz**, nicht gegen Erklärungen des Baus | Fremdmodell, **frische Instanz je Scheibenabnahme** (C-4, Blatt 26:30) | Das **Review** entsteht außerhalb dieses Harness. Sein **Nachweis** wird hier geprüft: `.github/workflows/tor3.yml` → `pruefungen/tor3.sh` (Werkzeug `werkzeuge/fremdreview.py`, Blätter unter `nachweise/fremdreview/`). Der Lauf erzeugt nie ein Review. |

---

**B6 · Vier Nachweise, vier Werkzeuge — genannt wird eines**
*(F4)*

**Stelle:** `CLAUDE.md`:166–167

**Was dort steht:** „Erzeugt von `werkzeuge/klauselregister.py`; leere Felder werden **ausgewiesen**."

**Was gilt:** Die drei anderen Werkzeuge sind nach dem letzten Stand dieser Datei (09.08.) entstanden.

**Mein Beleg:**
```
$ git log --diff-filter=A --date=short -- werkzeuge/herkunft.py
  be2e06a 2026-08-14 Der Herkunftsgraph entsteht …
$ git log --diff-filter=A --date=short -- werkzeuge/manifest.py
  314e991 2026-08-13 AH-7 · Das Testmanifest nach K23-M18 entsteht …
$ git log --diff-filter=A --date=short -- werkzeuge/triage.py
  a50433d 2026-08-14 Triage nach K23-M04 …
$ head -2 werkzeuge/herkunft.py  → "Herkunftsgraph nach K23-M03"
$ head -2 werkzeuge/triage.py    → "Triage der Klauseln nach K23-M04"
$ head -2 werkzeuge/manifest.py  → "das Testmanifest nach K23-M18"
```

**Satzfertige Korrektur:**
> Sie sind **erzeugte Sichten eines Datenbestands**, keine dreizehn von Hand gepflegten Wahrheiten (Blatt 26:59–63). **Je Nachweis ein Werkzeug:** Klauselregister `werkzeuge/klauselregister.py` · Herkunftsgraph `werkzeuge/herkunft.py` · Restrisikoliste `werkzeuge/triage.py` · Testmanifest `werkzeuge/manifest.py`. Leere Felder werden **ausgewiesen**.

---

**B7 · `config/kanon.yaml` gibt es in diesem Repo nicht**
*(F18)*

**Stelle:** `.claude/agents/pruef-agent.md`:6 und :13 · `.claude/agents/bau-agent.md`:68 · `CLAUDE.md`:114 (Rang 0)

**Was dort steht:** „Grundlage: Festlegung F27 (config/kanon.yaml:346-359)"

**Was gilt:** Der Inhalt stimmt (F27 steht dort zeilengenau). Der **Pfad** nicht — wer die Fundstelle aufschlägt, findet nichts und kann die Modelltrennung nicht gegen die Quelle prüfen.

**Mein Beleg:**
```
$ ls -la config           →  No such file or directory
$ find . -name 'kanon.yaml' -not -path './.git/*'  →  (leer)
$ echo "[${FREIRAUM_KONZEPTE:-}]"  →  []
```

**Satzfertige Korrektur:**
> Grundlage: Festlegung F27, `$FREIRAUM_KONZEPTE/config/kanon.yaml`:346–359 — die Datei liegt in der Konzept-Fabrik, **nicht in diesem Repo**. Ohne gesetzte Umgebungsvariable `FREIRAUM_KONZEPTE` ist sie nicht erreichbar; dann gilt der Eintrag als *nicht nachprüfbar*, nicht als bestätigt. (Gleiche Berichtigung in `bau-agent.md`:68 zu F10.)

---

**B8 · Das Repo wird als privat geführt und ist öffentlich**
*(F25)*

**Stelle:** `nachweise/restrisiken/restrisiken.md`:83

**Was dort steht:** „| Repository | `exmachinAI-GmbH/freiraum-delivery` — Organisation, **privat** |"

**Was gilt:** Es ist öffentlich. Damit lesen sich K23-D09 (keine Geheimnisse) und K15 (Personenangaben) gegen die Öffentlichkeit, nicht gegen zwei Mitarbeiter — und das hat niemand gemessen.

**Mein Beleg:**
```
$ gh api repos/exmachinAI-GmbH/freiraum-delivery --jq '.private, .visibility'
  false
  public
```

**Satzfertige Korrektur:**
> | Repository | `exmachinAI-GmbH/freiraum-delivery` — Organisation, **öffentlich** (gemessen 16.08.2026: `gh api … --jq .visibility` → `public`) |

Ergänzen: **Das Repo ist seit dem Umzug öffentlich, nicht privat.** Damit entfällt der ursprüngliche Grund von RR-01 endgültig — und es entsteht ein neuer, bisher ungemessener Punkt: K23-D09 und K15 gelten hier gegen die Öffentlichkeit. **Ein eigener Restrisikoeintrag mit Träger ist fällig.**

---

**B9 · Der Befundindex fällt zurück**
*(F28)*

**Stelle:** `nachweise/befunde/README.md`:7–11

**Was dort steht:** Drei Blätter: `BEF-C_260807.md`, `BEF-D_260809.md`, `BEF-E_260814.md`.

**Was gilt:** Es liegen vier auf `main`.

**Mein Beleg:**
```
$ git ls-tree --name-only main nachweise/befunde/
  BEF-C_260807.md  BEF-D_260809.md  BEF-E_260814.md  BEF-M3_260815.md  README.md
```

**Satzfertige Korrektur** — Zeile ergänzen:
> | `BEF-M3_260815.md` | 15.08.2026 | Bau der Vorprüfung (Scheibe 2, M3) — sieben Befunde |

dazu: **Dieses Verzeichnis ist von Hand geführt und fällt deshalb zurück.** Wer die Befundlage prüft, misst mit `ls nachweise/befunde/`, nicht mit dieser Tabelle.

---

**B10 · Glied 6 ist nicht mehr leer**
*(F30)*

**Stelle:** `nachweise/manifeste/README.md`:33 und 37–39

**Was dort steht:** „bei Tor 1c **leer** — und das steht drin" · „weil dieser Lauf kein Modell aufruft **und keine Vorlage liest**."

**Was gilt:** Im jüngsten Manifest trägt der Vorlagenstand den Bildschirmvertrag. Das Manifest widerspricht seinem eigenen Erklärtext.

**Mein Beleg:**
```
$ python3 -c "…tor1c_260814_manifest.json…['glied_6_modell_und_vorlagen']"
  vorlagenstand: {datei: schema/K19_screens.yaml, sha256: 4f186ce1…,
                  fassung: 1.2, status: FREIGABEKANDIDAT, abbilder: [4 Vorlagen]}
  anmerkung: "… Der Vorlagenstand ist der Bildschirmvertrag nach K19-M01 …"
$ … tor1c_260813_manifest.json …  →  vorlagenstand: None
```

**Satzfertige Korrektur** — Tabellenzeile:
> | **6** | Modell-, Prompt-, Wissens-, Richtlinien-, Vorlagenstand | Modell/Prompt/Wissen/Richtlinien bei Tor 1c **leer**; der **Vorlagenstand** ist seit dem 14.08.2026 gefüllt — und das steht drin |

Fließtext: **Ein leeres Feld ist eine Auskunft, ein fehlendes Feld ist keine.** Die vier ersten Stände stehen auf `null`, weil dieser Lauf kein Modell aufruft. Der fünfte, der **Vorlagenstand**, war bis zum 13.08.2026 ebenfalls `null`; seit der Aufnahme des Bildschirmvertrags nach K19-M01 trägt er `schema/K19_screens.yaml` mit Prüfsumme, Fassung und Abbildern.

---

**B11 · B3 wird ein Dossier zugeschrieben, das es nie gab**
*(F35)*

**Stelle:** `nachweise/vorbedingungen/README.md`:9

**Was dort steht:** „| **B3** | Testdomäne | **Dossier** |"

**Was gilt:** Der Ordner enthält genau eine Datei: `README.md`.

**Mein Beleg:**
```
$ ls nachweise/vorbedingungen/B3_testdomaene/   →   README.md
```

**Satzfertige Korrektur:**
> | **B3** | Testdomäne | **nur Vorschlag** — Sub-Domäne `zaa.freiraum.top` empfohlen; Dossier und Abnahmeprotokoll fehlen. Postfächer sind seit 06.08.2026 angelegt, der MX-Eintrag steht aus |

---

### C · IRREFÜHREND

---

**C1 · Die Gegenzeichnung des Bauauftrags steht nicht mehr aus** *(F1)*
`CLAUDE.md`:151. Dort: „gezeichnet von M. Veil … Die Gegenzeichnung des Auftragnehmers steht aus." Gemessen:
```
$ sed -n '90,92p' 03_N5_BAUAUFTRAG_v1.1_zeichnung.md
  ### Auftragnehmer
  |**A. Han**|08.08.2026|[x] **v1.1 gezeichnet** — einschließlich der neuen Vorbedingung in L4|
$ shasum -a 256 03_N5_BAUAUFTRAG_v1.1_260807.md  →  3341362f…  (= Wert in CLAUDE.md)
```
Der Vorbehalt ist seit acht Tagen gegenstandslos. **Korrektur:**
> **belegt seit 07.08.2026:** Fassung v1.1, `3341362f8962af9d48de4afdc863284d5261e9ede3c997fb32bd83933186e43d`. **Von beiden Vertragsseiten gezeichnet:** M. Veil am 07.08.2026, A. Han für den Auftragnehmer am 08.08.2026 (`03_N5_BAUAUFTRAG_v1.1_zeichnung.md`, Abschnitt 4). Glied 2 ist vollständig belegt.

---

**C2 · Ein erfundenes Zitat trägt die ganze Auslöserregel** *(F15 und F16 zusammengeführt)*
`.claude/commands/scheibe.md`:120 und `.claude/commands/uebergabe.md`:60. Beide schreiben C-4 wörtlich zu: *„Ein Gate, das bei jedem Commit anschlägt, wird umgangen oder billig erfüllt — beides schlechter als kein Gate."* Gemessen:
```
$ grep -rn 'bei jedem Commit' <Wissensablage ITERATION_2>   →  KEINE TREFFER
$ sed -n '30p' 26_HANDOVER_260807_NACHTRAG.md   (C-4 im Wortlaut)
  | C-4 | Bau-Agent und Prüf-Agent getrennt; der Prüf-Agent arbeitet blind …
    Das Fremdmodell kommt **einmal je Scheibenabnahme**, nicht je Änderung.
  | Setzt K23-D05 … mechanisch durch … O-K23-7 vom 2.8. ist der Beleg …
$ grep -rn 'bei jedem Commit' . --exclude-dir=.git
  → nur scheibe.md:120 und uebergabe.md:60
```
Der Satz existiert nur in diesem Harness. **Korrektur, in beiden Dateien:**
> C-4 zeichnet nur den Auslöser: *„Das Fremdmodell kommt einmal je Scheibenabnahme, nicht je Änderung"* (Blatt 26:30). Die Begründung — eine Frage, die zu oft kommt, wird weggeklickt — ist eine Erwägung dieses Harness und **nicht gezeichnet**; sie wird als solche geführt, nicht als Zitat.

---

**C3 · „`schema/` gibt es im Repo heute nicht"** *(F14)*
`.claude/agents/bau-agent.md`:47–48. Gemessen:
```
$ ls -la schema/
  freiraum_datamodel.sql  47238 B   7 Aug.     freiraum_datamodel.sha256
  K19_screens.yaml        95984 B  14 Aug.     K19_screens.sha256   README.md
$ sed -n '33p' aufbau.sh   →  DDL="$HIER/schema/freiraum_datamodel.sql"
```
Die Frage ist beantwortet, nicht offen. **Korrektur:**
> `schema/` liegt seit dem 07.08.2026 im Repo und trägt das eingefrorene DDL `freiraum_datamodel.sql` samt `.sha256` sowie `K19_screens.yaml`; `aufbau.sh` lädt von dort (Zeile 33). Neue Dateien in `schema/` werden trotzdem nicht auf eigene Faust angelegt — jede Ergänzung braucht Prüfsumme und Herkunftsvermerk nach `schema/README.md`.

---

**C4 · Ein veraltetes Zitat, fünffach verankert** *(F31)*
`nachweise/fremdreview/README.md`:30–35, :55, :101, :105 — dazu `VORLAGE.md`:12, `werkzeuge/fremdreview.py` (sechsmal), `pruefungen/tor3.sh`:6, `.github/workflows/tor3.yml`:13. Alle zeigen auf `scheibe.md`:73 und zitieren *„Fremdmodell anfordern (Tor 3, …)"*. Gemessen:
```
$ git show main:.claude/commands/scheibe.md | sed -n '73p'
  mit allen acht Gliedern aus `CLAUDE.md` §4, maschinenlesbar, mit Prüfsumme über sich
$ git show main:.claude/commands/scheibe.md | grep -n 'Fremdmodell anfordern'  →  (leer)
$ git show main:.claude/commands/scheibe.md | grep -n 'nie selbst'  →  82
```
**Hier weiche ich vom Prüfbericht der Kommando-Gruppe ab:** der gesuchte Satz steht auf Zeile **82**, nicht 87 — Zeile 87 trägt den `fremdreview.py`-Aufruf. Wer der alten Fundstelle folgt, landet ausgerechnet auf dem Manifest-Schritt mit der falschen „die Anlage existiert nicht"-Zeile (A2). **Korrektur:**
> `.claude/commands/scheibe.md` macht daraus seit dem 15.08.2026 einen Halt, **Schritt 10**:
> > *„HALT — den Menschen fragen, ob das Fremdmodell jetzt anzufordern ist. Tor 3, einmal je Scheibenabnahme (C-4): frische Instanz, getrennter Kontext, Prüfung gegen **Roh-Evidenz**, nicht gegen Erklärungen des Baus. Der Harness schreibt dieses Review **nie selbst**."*

In allen acht Fundstellen `scheibe.md:73` durch **`scheibe.md`, Schritt 10** ersetzen — **nicht** durch eine neue Zeilennummer. Sie ist schon einmal verrutscht.

---

**C5 · Die Abendübergabe ist an fünf Stellen von ihrem eigenen Redaktionsschluss überholt** *(F41–F45)*

Drei Minuten nach Redaktionsschluss (23:47) kam ein **drittes** Zeichnungsblatt auf den Zweig von #25. Gemessen:
```
$ git log -1 --format="%H %ad %s" --date=iso 7f2a28a
  7f2a28a 2026-08-15 23:50:51 +0200 M-7 bis M-10 gezeichnet -- ein Punkt bleibt offen
$ gh pr view 25 --json files
  4 Dateien, +900/-0   (Abendfassung Z. 406 und Z. 552: „3 Dateien, +757")
$ git show 7f2a28a:…/zeichnung_M7-M10_260815.md | sed -n '56p'
  | 7.2 | Die zehn zusätzlich genannten Regeln kommen herein — der Umfang beträgt
         damit **167 Regeln**, nicht 157 | [x] |         (Abendfassung Z. 415: „157")
$ … | sed -n '92,96p'
  | 9.2 | Der eigene Aufräumlauf wird nicht gebaut | [x] |
  | 9.4 | **Schritt 1 wird gebaut** — die Trägerbedingung gegen die Uhr rechnen | [x] · zu bauen |
                                                   (Abendfassung Z. 417: „Der Bau wird nicht gebaut")
$ git show offene/entscheidungen-260815:…/zeichnung_M1-M10_260815.md | sed -n '31,32p'
  | M-5 | … | [x] · **erledigt ohne Zeichnung** |
  | M-6 | … | [x] · **ausgeführt am 15.08.2026** |   (Abendfassung Z. 40: „Wirksam
                                                     geworden ist davon keine einzige")
```
**Die gefährlichste dieser fünf ist M-9:** die Zeichnung trennt, was die Übergabe zusammenwirft — nicht gebaut wird nur der Aufräumlauf (9.2), **Schritt 1 wird ausdrücklich gebaut** (9.4). Wer die Übergabe liest, hält einen gezeichneten Bauauftrag für abgesagt.

**Satzfertige Korrekturen:**
- Kopf: **Der Auftraggeber hat am 15.08. auf drei Blättern gezeichnet.** Blatt 3 `zeichnung_M7-M10_260815.md` (Stand `7f2a28a`, 23:50 Uhr, **ein ausdrücklich offener Punkt 10.2**). **Alle drei liegen auf offenen Zweigen, keines auf `main`.** Eine belastbare Gesamtzahl nennt diese Übergabe bewusst nicht — die „22" sind aus keinem Blatt nachrechenbar.
- M-7: **Der Umfang von Bedingung 4 ist gezeichnet: 167 Regeln** (152 Stationswörter + 5 Bauspur + 10 von Prüffällen genannte, Kreuz 7.2). Die 157 sind der Stand vor der Zeichnung.
- M-9: **gezeichnet und differenziert.** Der **eigene Aufräumlauf wird nicht gebaut** (9.2). **Schritt 1 wird gebaut** (9.4). MG-08 geht neu gefasst an den **Prüf-Agenten** (9.5).
- #25: **vier Dateien, +900 Zeilen** — **zwei** Zeichnungsblätter. Wer nach Beschreibung freigibt, sieht sie nicht.
- Dritter Satz: **Wirksam geworden ist fast nichts — aber nicht nichts.** Ohne weitere Unterschrift wirken die Absage der Umbenennung sowie M-5 und M-6. **Alles Übrige hängt.**

---

**C6 · Die Fassung auf `main` ist überholt und hat keinen Nachfolger im Antrag** *(F46)*
`HANDOVER_260815.md` auf `main` sagt „Stand `main` `af138ab` — unverändert" und „Nachsehen, ob die drei Anträge freigegeben sind. **Ohne sie steht der Tag still.**" Gemessen:
```
$ git log --oneline -1 main  →  7642f0b
$ gh pr list --state all --json number,state,mergedAt,reviewDecision
  23 MERGED 2026-08-15T20:44:19Z APPROVED
  22 MERGED 2026-08-15T20:41:44Z APPROVED
  21 MERGED 2026-08-15T20:38:24Z APPROVED
$ gh pr list --state all --head uebergabe/260815-abend  →  []
$ git rev-list --left-right --count main...uebergabe/260815-abend  →  0  1
```
Die berichtigte Abendfassung liegt bereit und **hat keinen Antrag**. Wer als nächster `main` liest, beginnt mit einer erledigten Aufgabe. **Korrektur — beide Wege gehen:** erstens die Abendfassung als Antrag stellen (ein einziger Änderungsstand über `main`); zweitens bis dahin einen Vorspann in die `main`-Fassung:
> **Überholt.** Der Stand von `main` ist `7642f0b`; die Anträge #21, #22 und #23 sind am 15.08.2026 zwischen 20:38 und 20:44 UTC zusammengeführt. Der volle Tagesstand steht in `git show uebergabe/260815-abend:HANDOVER_260815.md`.

---

**C7 · B1 und B2 stehen auf „noch nicht begonnen" und sind abgenommen** *(F26 und F27)*
```
$ sed -n '3p' nachweise/vorbedingungen/B1_installation/README.md
  **Status:** noch nicht begonnen.
$ sed -n '9p' …/B1_Abnahmeprotokoll.md
  | Ergebnis | **bestanden** — Abnahmekriterium erfüllt, alle Negativfälle abgewiesen |
$ sed -n '6p' …/B2_mailversand/README.md    →  **Status:** noch nicht begonnen.
$ sed -n '8p' …/B2_Abnahmeprotokoll.md
  | Ergebnis | **Abnahmekriterium erfüllt** gegen den Testempfänger · echter Versand offen |
```
Das Protokoll liegt jeweils im **selben Ordner**. Die Übersicht eine Ebene höher führt beide richtig („Abnahmeprotokoll vorhanden" / „Einrichtung belegt, Abnahme offen") — die beiden Detailblätter widersprechen ihr. **Korrektur:**
- B1: **Status: abgenommen am 02.08.2026** — Protokoll `B1_Abnahmeprotokoll.md`, Ergebnis bestanden. Offen bleibt allein B1-F2.
- B2: **Status: teilabgenommen.** Abnahmekriterium am 02.08.2026 gegen den Testempfänger erfüllt, Postfächer am 06.08.2026 angelegt. **Offen bleibt die Abnahme gegen den echten Dienst** und die Messung des `d=`-Werts.

---

**C8 · `install.sh` erklärt den Ablageort der Anlage für ungezeichnet** *(F20)*
`install.sh`:13–14: „ACHTUNG: Ablageort und Dateiname der Anlage sind NICHT gezeichnet."
```
$ sed -n '12p' Anlage_Bauverfahren_zeichnung.md
  | Datei | `30_DELIVERY_HARNESS/Anlage_Bauverfahren.md` |
… ebd.: [x] GEZEICHNET · M. Veil | 07.08.2026
$ ./install.sh --pruefsumme  →  OK …  EXIT=0
```
Der Hinweis stammt aus dem Gerüst-Commit vom 07.08.2026, 14:15 Uhr — der Stunde **vor** der Zeichnung. **Korrektur:**
> #  Ablageort und Dateiname sind seit dem 07.08.2026 GEZEICHNET: das Zeichnungs-
> #  blatt fuehrt die Datei "30_DELIVERY_HARNESS/Anlage_Bauverfahren.md". Der
> #  Vorgabewert unten trifft genau diese Datei.
> #  FREIRAUM_ANLAGE ist allein fuer einen anderen Ort DESSELBEN Blattes gedacht.
> #  Wer damit auf eine andere Datei zeigt, misst die CLAUDE.md gegen einen
> #  ungezeichneten Text und hebt die Trennung der zwei Vertrauensbereiche auf.

---

**C9 · Die README-Karte zeigt drei Bestände nicht** *(F21 und F24)*
`README.md`:145, :150, :159–167.
```
$ ls seeds/  →  README.md  Seed_Vorpruefung_K04.sql  Seed_Welle1_M1-M4.{sql,sha256}
$ head -3 seeds/Seed_Vorpruefung_K04.sql
  --  FREIRAUM · Startbestand des Eignungs-Checks (K04)
  --  Angelegt 15.08.2026 · Scheibe 2 · Meilenstein M3
$ sed -n '63p' aufbau.sh
  for f in "$DDL" "$VORLAEUFER" "$M30" "$SEED"; do pruefe_eingang "$f"; done
$ ls nachweise/  →  … fremdreview  klauselschnitt  meldungen …
$ ls schema/     →  … K19_screens.yaml  K19_screens.sha256 …
```
`Seed_Vorpruefung_K04.sql` ist **hier entstanden**, trägt keine `.sha256`, wird nicht geladen — die Änderungsregel „keine" gilt für sie nicht. **Korrektur:** Überschrift zu „**Kopien und Originale — nicht alles in diesen Ordnern ist eine Kopie**", die vier Kopien namentlich nennen, dann:
> **Ausnahme:** `seeds/Seed_Vorpruefung_K04.sql` ist am 15.08.2026 in diesem Repository entstanden (Scheibe 2, M3). Sie ist ein Original, trägt keine Prüfsumme, wird von `aufbau.sh` nicht geladen und wird hier gepflegt.

Tabelle „Was wo liegt": `schema/` um den Bildschirmvertrag `K19_screens.yaml` ergänzen (Tor 1a rechnet ihn nach), `nachweise/` um **Klauselschnitte · Fremdprüfung (Tor 3) · Meldungen**.

---

**C10 · Vier statt fünf Negativfälle, unter einem Namen, den es nicht gibt** *(F29)*
`nachweise/pilot/README.md`:14.
```
$ grep -n '^-- N[0-9]' migrations/_vorlaeufer/260801_tenant.sql
  94:  N1 …  98: N2 …  102: N3 …  106: N4 …  112: -- N5 · Kunden-Code mit Ziffer
$ ls migrations/Migration_260801_tenant.sql  →  No such file or directory
```
**Korrektur:**
> (u. a. die **fünf** Negativfälle N1–N5 aus `migrations/_vorlaeufer/260801_tenant.sql` — alle müssen scheitern, und zwar **je an der eigenen Bedingung**; N5 prüft das Codeformat und ist am 02.08.2026 aus Befund B1-F1 entstanden)

---

**C11 · Der Repo-Pfad ist veraltet — aber er klont** *(F8, herabgestuft)*
`CLAUDE.md`:11: „`exmachinai/freiraum-delivery`". Die Meldung stuft das als *hält den Bau an* ein („wer klont, greift ins Leere"). **Das habe ich geprüft und es trifft nicht zu:**
```
$ git ls-remote https://github.com/exmachinai/freiraum-delivery HEAD
  7642f0b78a3cf157f3c7b7cd03161d5294d45bad
```
GitHub leitet nach dem Transfer vom alten Pfad weiter. Der Name ist trotzdem falsch — und die Weiterleitung ist kein Verlass: sie bricht, sobald jemand unter `exmachinai` ein gleichnamiges Repo anlegt. **Korrektur:**
> | Repo | `exmachinAI-GmbH/freiraum-delivery` — GitHub ist Wahrheit, kein Klon in Dropbox. Der alte persönliche Pfad `exmachinai/…` wird derzeit noch weitergeleitet; darauf ist kein Verlass. **Seit 09.08.2026 bringt das Repo alle Bau-Eingaben selbst mit** |

---

**C12 · Beide Mitarbeiter sind Admin** *(F33)*
`nachweise/restrisiken/restrisiken.md`:89: „`AndrewExma` (push)".
```
$ gh api …/collaborators --jq '.[] | {login, role_name}'
  {"login":"exmachinai","role_name":"admin"}
  {"login":"AndrewExma","role_name":"admin"}
$ gh api …/branches/main/protection
  enforce_admins: true · 4 Pflichtprüfungen · require_code_owner_reviews: true
```
Die Schließung von RR-01 stützt sich auf Rollentrennung. Sie trägt weiter — aber über `enforce_admins`, nicht über abgestufte Rechte. Das muss dastehen. **Korrektur:**
> | Mitarbeiter | `exmachinai` (admin) · **`AndrewExma` (admin)** — beide Admin; die Rollentrennung trägt **nicht** über abgestufte Rechte, sondern über `enforce_admins=true` und `require_last_push_approval=true`, die auch einen Admin abweisen (gemessen 16.08.2026) |

---

### D · GERING

| | Stelle | Was gilt | Beleg |
|---|---|---|---|
| **D1** | `aufbau.sh`:16–18 | `--ci` beschreibt auch `lauf.sh`. In der CI läuft `lauf.sh` als Tor 1c gegen denselben Bestand **plus `seeds/*.sql`** — örtlich misst man weniger. | `tore.yml`:292 `for s in seeds/*.sql; do psql … -f "$s"; done` vs. `aufbau.sh`:78–79 |
| **D2** | `restrisiken.md`:102–121 | Der Nachtrag sagt „weiterhin nein" / „weiterhin 403" und steht **unter** der Schließungsmeldung. Beides ist vollzogen. Erkennbar historisch gerahmt, daher gering. | `git remote -v` → `exmachinAI-GmbH`; `enforce_admins: true`, 4 Pflichtprüfungen |
| **D3** | `restrisiken.md`:132 | Ersatzmaßnahme 4 steht auf „mit dem ersten Manifest" — zwei Sätze liegen vor, beide Prüfsummen `OK`. | `ls nachweise/manifeste/` → `tor1c_260813*`, `tor1c_260814*` |
| **D4** | `herkunft.md`:27–28 | „Solange die Zeile *als umgesetzt erklärt* auf 0 steht …" — sie steht auf 15 (`main`) bzw. 22 (Arbeitsbaum). Der Satz ist **konditional**, keine Tatsachenbehauptung; deshalb gering, nicht „lässt eine Prüfung aus". | `main`:17 → `15`; `herkunft.json` → `davon_erklaert: 22` |
| **D5** | `ruff.toml`:8–11 | „`.github/` und `pruefungen/` verlangen beide Kennungen … diese Datei gehört in dieselbe Aufmerksamkeit." CODEOWNERS führt `/ruff.toml` **nicht**. Als Sollaussage formuliert, daher Lücke statt Fehlbehauptung. | `grep -n 'ruff' .github/CODEOWNERS` → keine Ausgabe |
| **D6** | B1/B2/B3 `README.md` | „Auftrag: `arbeit/Bauauftrag_Pilot-Vorbedingungen.md`" — den Pfad gibt es im Repo nie gegeben; seit dem Umzug liest er sich als Repo-Pfad. | `git log --all -- arbeit/Bauauftrag_Pilot-Vorbedingungen.md` → leer |
| **D7** | `B3_testdomaene/README.md`:7 | Der relative Pfad `../../../02_AGENT_HARNESS_KONZEPTE/…` landet in der Repo-Wurzel. Zu löschen, nicht zu reparieren. | `ls /Users/mveil/freiraum-delivery/02_AGENT_HARNESS_KONZEPTE` → nicht vorhanden |

---

## 3 · Verworfene und herabgestufte Meldungen

- **F8 (Repo-Pfad) — herabgestuft von *hält den Bau an* auf *irreführend*:** `git ls-remote https://github.com/exmachinai/freiraum-delivery` liefert `7642f0b` — GitHub leitet weiter, wer klont greift **nicht** ins Leere.
- **F2 (Zeichnungsstand der Anlage) — kein Korrekturfund, sondern ein Klärungspunkt:** Das Zeichnungsblatt widerspricht sich zwar selbst (Datum 08.08. in A. Hans Zeile, Vorbehalt im Begleittext und in „Was das bedeutet"), aber die CLAUDE.md wählt die **vorsichtige** Lesart, und die Anlage sagt selbst „bindet den Auftraggeber allein" — ein absichtlich weitergeführter Vorbehalt gehört nicht per Korrektur entfernt, sondern ans Zeichnungsblatt zurückgegeben.
- **F12 (Prüf-Agent) — herabgestuft auf *irreführend*:** Der Nachsatz „und jede Datei, die Umsetzung enthält" fängt `app/` sachlich auf; die Lücke ist die fehlende Namensnennung, nicht eine ausgelassene Prüfung.
- **F34 (Herkunftsgraph) — herabgestuft auf *gering*:** Der Satz ist eine Wenn-Dann-Aussage, keine Behauptung, die Zahl stehe auf 0. Die Meldung liest ihn als Strohmann; der Fund schrumpft auf einen missverständlichen Kontext.
- **F22 (ruff.toml) — herabgestuft auf *gering*:** Der Text behauptet nirgends, `ruff.toml` stehe in CODEOWNERS — „gehört in dieselbe Aufmerksamkeit" ist eine Soll-, keine Ist-Aussage.
- **F32 (RR-01-Nachtrag) — herabgestuft auf *gering*:** Der Abschnitt ist mit „Wie es dahin kam" ausdrücklich historisch gerahmt.
- **Zwei Zeilenangaben der Melder selbst korrigiert:** F17 nennt `scheibe.md`:65 — auf `main` ist es **Zeile 60**. Der Prüfbericht der Kommando-Gruppe nennt für „Der Harness schreibt dieses Review nie selbst" die Zeile 87 — es ist **Zeile 82**; Zeile 87 trägt den `fremdreview.py`-Aufruf.

**Zusammengeführt:** F3+F11+F12 → A1 · F10+F47 → B1 · F15+F16 → C2 · F39+F40 → A5 · F41–F45 → C5 · F26+F27 → C7 · F21+F24 → C9.

---

## 4 · Was ich zusätzlich geprüft habe

1. **Die Prüfsummenmechanik im Negativfall.** Alle fünf haben nur den OK-Fall gemessen. Ich habe `install.sh` gegen eine falsche Datei gefahren: `X Pruefsumme weicht ab … Der ausgefuehrte Text redet ueber eine andere Fassung als der gezeichnete.` **EXIT=1.** Die eine Stelle, an der dieses Projekt Dokumente wirklich misst, funktioniert — das ist die Grundlage meiner Empfehlung.

2. **Die gezeichnete Anlage trägt dieselbe verrottete Zählung wie die CLAUDE.md.** Kein Prüfer hat das ausgemessen. `Anlage_Bauverfahren.md`:8 „Auftrag Z. 52–56" → der zitierte Satz steht heute auf `:75`; `:37` „Auftrag Z. 82" → `:97–105`; `:98` „Auftrag Z. 379" → `:409`. **Folge:** Die CLAUDE.md ist sofort berichtigbar, die Anlage nicht — jede Änderung an ihr ändert `ded747a7…` und löst nach ihrer eigenen Regel eine Neuzeichnung aus.

3. **Ob die Schreibgrenze überhaupt gezeichnet ist.** `grep -n 'Schreibt nach\|werkzeuge/\|app/' Anlage_Bauverfahren.md` → **keine Treffer.** Damit ist A1 eine reine CLAUDE.md-Zutat und ohne Zeichnungsberührung zu berichtigen — das war offen und entscheidet, ob der schwerste Fund heute behebbar ist.

4. **Ob irgendein Tor eine Dokumentbehauptung prüft.** Ich habe alle zwölf Schritte von `tore.yml` durchgesehen: Geheimnisse, Shell-Lint, Python-Lint, UI-Vertrag, Klauselregister, Herkunftsgraph, Schema, Migration, Negativfälle, Prüflauf. **Keiner davon schlägt eine Fundstelle nach.**

5. **Warum der Herkunftsgraph auf `main` veraltet ist.** `tore.yml`:143–152 rechnet ihn bei jedem Lauf neu und vergleicht — meldet aber nur `::warning::` und sperrt nicht. Der eingecheckte Graph ist deshalb nachweislich alt (96 statt 123). **Das ist der Beweis im eigenen Haus, dass eine Warnung nicht wirkt.**

---

## 5 · Der Vorschlag

**Ein Werkzeug `werkzeuge/fundstellen.py`, das jede `Datei:Zeile`-Behauptung der Steuerungstexte nachschlägt — als sperrender Schritt in Tor 1a.**

Dieses Projekt hat das Muster schon zweimal gebaut und weiß, dass es trägt: `install.sh --pruefsumme` misst die CLAUDE.md gegen die Anlage und gibt bei Abweichung **Exit 1** — ich habe es eben im Negativfall gefahren. `werkzeuge/herkunft.py` rechnet den Graphen neu und vergleicht ihn mit dem eingecheckten. Es fehlt nur die dritte Anwendung desselben Gedankens: **eine Behauptung über eine Datei ist nachrechenbar wie eine Prüfsumme.**

Das Werkzeug liest aus `CLAUDE.md`, `.claude/**`, `README.md`, `CONTRIBUTING.md`, `install.sh`, `aufbau.sh`, `ruff.toml` und `nachweise/**` jedes Muster `pfad:zeile` bzw. `pfad:von–bis`, öffnet die Zeile und prüft **zwei** Dinge: dass die Datei existiert, und dass ein im Steuerungstext mitgeführtes **Ankerwort** dort wirklich vorkommt. Fundstellen außerhalb des Repos (Bauauftrag, Blatt 11, Blatt 26, `config/kanon.yaml`) werden über `$FREIRAUM_KONZEPTE` aufgelöst — ist die Variable nicht gesetzt, meldet das Werkzeug **`gesperrt`, nicht `bestanden`**. Genau die Unterscheidung, die K23-M22 ohnehin verlangt.

**Und es sperrt.** Nicht `::warning::` — der veraltete Herkunftsgraph auf `main` ist der Beleg im eigenen Haus, dass eine Warnung in diesem Projekt nichts bewirkt. Ein Lauf mit einer toten Fundstelle ist rot.

Von den 27 bestätigten Funden hätte dieses eine Werkzeug **fünfzehn** am Tag ihrer Entstehung gefunden: alle Bauauftrags-Verweise, alle README-Verweise, `scheibe.md:73` in seinen acht Verankerungen, `config/kanon.yaml`, `aufbau.sh:11–14`, `Migration_260801_tenant.sql`, den relativen O-PIL-4-Pfad, `arbeit/Bauauftrag_Pilot-Vorbedingungen.md`. Es hätte auch die vier Stellen gefunden, die gestern zufällig auffielen. Der Rest — „die Anlage existiert nicht", „schema/ gibt es nicht", „noch nicht begonnen", das erfundene C-4-Zitat — sind Zustandsbehauptungen; dafür genügt die schwächere Schwester derselben Regel: **jede Behauptung über einen Zustand trägt den Befehl, der sie erzeugt hat, direkt daneben.** Die Abendübergabe vom 15.08. macht das bereits vor und beweist damit, dass es geht.

Der Bau kann ohne all das weiterlaufen. Aber solange keine Maschine die Steuerungstexte gegen die Wirklichkeit hält, prüft dieses Projekt seinen Code sorgfältiger als die Anweisungen, nach denen der Code entsteht — und genau das ist der Fehler, der es dreimal erwischt hat.