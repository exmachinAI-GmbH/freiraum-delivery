# Entscheidungsvorlage · Der MCP-Weg zum Fremdmodell — Ausführung und eine Berichtigung

**Vorgelegt am 24.08.2026 vom Orchestrator des Coding-Harness.**
Diese Vorlage entscheidet nichts. Sie legt vor, was eingerichtet und gemessen ist, benennt
die Frage und zeigt die Wege mit ihren Folgen.

| | |
|---|---|
| **Betrifft** | **Tor 3 · fremd** — die Ausführung des MCP-Wegs, und eine Abweichung zwischen `CLAUDE.md` und der gezeichneten Anlage |
| **Anlass** | Auftrag vom 24.08.2026: „integriere ChatGPT 5.6 Sol per MCP hier als Fremdmodell ein" |
| **Klarstellung** | Ebenfalls 24.08.2026: *„Wir haben ja auch in der Laufzeit einen Fremdmodellcheck — aber für die Codierung und Entwicklung der FREIRAUM-App soll dies über den MCP-Weg erfolgen."* |
| **Stand des Repos** | `56437fe` auf `main` |
| **Zu entscheiden von** | M. Veil, Auftraggeber |

> **Berichtigung gegenüber der ersten Fassung dieser Vorlage.** Sie enthielt einen Abschnitt,
> der den MCP-Weg gegen die Azure-EU-Datenzone stellte und daraus einen Einwand machte. Der
> Abschnitt war falsch. Er stützte sich auf die Vorlage vom 22.08.2026, nicht auf die
> gezeichnete Anlage — und die sagt in Abschnitt 3 das Gegenteil. Der Einwand ist ersatzlos
> gestrichen; was an seine Stelle tritt, steht ebenfalls in Abschnitt 3.

---

## 1 · Was eingerichtet ist — gemessen, nicht behauptet

| | Befund | Wie belegt |
|---|---|---|
| **Server** | `codex mcp-server` (codex-cli **0.146.0**), Zustand *Connected* | `claude mcp list` |
| **Geltung** | Eintrag unter `mcpServers` in `~/.claude.json` — **Benutzerebene**, gilt in jedem Projekt | Auslesen der Konfiguration |
| **Modell** | `model = "gpt-5.6-sol"`, `model_reasoning_effort = "medium"` | `~/.codex/config.toml`:1–2 |
| **Wirksamkeit** | Der Modellname wird **serverseitig geprüft**, nicht stillschweigend verworfen | Gegenprobe mit `gpt-9.9-nichtexistent` → HTTP **400**, *„model is not supported"*. `gpt-5.6-sol` läuft |
| **Weg** | `auth_mode = chatgpt`, kein API-Schlüssel, kein `base_url`, kein Azure-Provider → **direkt zu OpenAI**, nicht über die Azure-OpenAI-Ressource | `~/.codex/auth.json`, `~/.codex/config.toml` |
| **Repo** | Geklont nach `~/Developer/freiraum-delivery`, `origin` gesetzt, `main` verfolgt | `git remote -v`, `git status -sb` |
| **Verfassung** | Prüfsumme der Anlage **stimmt**: `ded747a7…0274d`, identisch mit dem Kopf der `CLAUDE.md`:7 | `shasum -a 256 Anlage_Bauverfahren.md` |

**Zum Ort des Klons.** Er liegt **ausserhalb von Dropbox** — `CLAUDE.md`:12 verlangt das
ausdrücklich: *„GitHub ist Wahrheit, kein Klon in Dropbox."* Der Ort ist damit keine Annahme
des Orchestrators mehr, sondern die Anwendung einer bestehenden Regel.

---

## 2 · Die Frage

**Nicht: darf der Kanal Tor 3 bedienen. Sondern: wie wird er ausgeführt, ohne die eine
gezeichnete Schranke zu brechen — und was ist an `CLAUDE.md` zu berichtigen?**

---

## 3 · Die gezeichnete Lage — der MCP-Weg ist bereits vorgeschrieben

Die Anlage „Bauverfahren" ist von beiden Vertragsseiten gezeichnet: M. Veil am 07.08.2026,
A. Han am 16.08.2026 (`CLAUDE.md`:5). Sie sagt zu Tor 3 zweimal dasselbe:

| Fundstelle | Wortlaut |
|---|---|
| **Anlage :114** (Torstufen-Tabelle, Spalte *Wer*) | *„extern, **direkt zu OpenAI über MCP**, nicht über die Azure-OpenAI-Ressource (Auftrag Z. 58–60)"* |
| **Anlage :201** (Rollentabelle, Zeile *Fremdmodell (Tor 3)*) | *„**eigener Pfad, direkt zu OpenAI über MCP**", Zugriff: „lesend"* |

**Damit ist der Auftrag vom 24.08.2026 keine Regeländerung, sondern der Vollzug einer
gezeichneten Regel.** Die Anlage schliesst den Azure-Weg für Tor 3 sogar ausdrücklich aus und
beruft sich dafür auf den Bauauftrag Z. 58–60. Die Trennung, die der Auftraggeber am
24.08.2026 benannt hat — Laufzeitprüfung des Produkts über Azure EU, Entwicklungsprüfung über
MCP —, steht mit dieser Fundstelle im Einklang.

**Was die Anlage weiterhin verbietet, und zwar gezeichnet:**

| Fundstelle | Schranke |
|---|---|
| **Anlage :229 · HV-D16** | *„**Kein Tor-3-Review selbst schreiben**"* — und keine Prüffälle als Bau-Agent ändern |
| **Anlage :114** | frische Instanz · getrennter Kontext · **gegen Roh-Evidenz, nicht gegen Erklärungen des Baus** |
| **Anlage :201** | *eigener* Pfad |

**Die Schranke ist also nicht der Kanal, sondern die Urheberschaft.** Das Fremdmodell muss
den Text schreiben, nicht der Harness — und es muss den Commit sehen, nicht meine Erzählung
darüber.

---

## 4 · Wo `CLAUDE.md` von der Anlage abweicht

`CLAUDE.md`:115 führt in der Spalte *Werkzeug* für Tor 3:

> **außerhalb dieses Harness**

Die Anlage schreibt an derselben Stelle *„extern, direkt zu OpenAI über MCP"* und
*„eigener Pfad"*. **Das ist nicht dasselbe.** „Externer Pfad" sagt, wohin die Anfrage geht;
„außerhalb dieses Harness" sagt zusätzlich, wer sie nicht absetzen darf. Die ausführbare
Fassung ist damit **enger als der unterschriebene Text**.

`CLAUDE.md`:14 regelt diesen Fall selbst: *„Bei Abweichung gilt die **Anlage**."*

**Folge: Das ist eine Berichtigung, keine Regeländerung.** Dafür gibt es im Haus Vorbild —
der Kopf der `CLAUDE.md`:12 trägt bereits eine solche Notiz (*„Berichtigt am 20.08.2026 …
er ist nur nie hierher übertragen worden"*). Dieselbe Form passt hier.

**Und deshalb bleibt die Prüfsumme unberührt.** Die Anlage wird **nicht** angefasst; sie sagt
ja schon das Richtige. `ded747a7…` bleibt gültig, `./install.sh --pruefsumme` meldet weiter
OK, `/scheibe` und `/pruefe` laufen. *Hätte* der Auftrag die Regel geändert statt sie zu
vollziehen, wäre der Weg umgekehrt und deutlich länger: erst Anlage ändern und zeichnen, dann
neue Prüfsumme, dann `CLAUDE.md` — sonst meldet der Harness „Verfassung nicht belegt".

---

## 5 · Was an der Ausführung hängt

`werkzeuge/fremdreview.py`:65 verlangt vier Felder, die **ausdrücklich bejaht** sein müssen:

| Feld | Was der Ausführungsweg daran entscheidet |
|---|---|
| `frische_instanz` | Erfüllbar — **nur**, wenn je Abnahme ein neuer Faden geöffnet und `codex-reply` nie wiederverwendet wird |
| `getrennter_kontext` | Hängt daran, **wer den Prompt formuliert**. Formuliert ihn der Orchestrator frei, reist die Lesart des Baus mit |
| `gegen_roh_evidenz` | Hängt daran, **was mitgeschickt wird**: der Commit und benannte Dateien — oder eine Zusammenfassung |
| `harness_hat_nicht_geschrieben` | Hängt daran, **wer absendet und wer den Text erzeugt** |

---

## 6 · Die Wege

Nach Abschnitt 3 steht der Kanal fest. Zu entscheiden bleibt die Urheberschaft:

| | Weg | Folge |
|---|---|---|
| **C** | **Anfrage mechanisch, Mensch löst aus.** Ein Werkzeug (`werkzeuge/fremdreview_anfordern.py`) erzeugt die Anfrage **aus Commit und Evidenzliste** — kein frei formulierter Text des Orchestrators. Der Mensch löst aus. Codex antwortet in frischem Faden. Die Antwort wird **wortwörtlich samt Prüfsumme** abgelegt. Der Orchestrator sieht sie erst, wenn sie im Repo liegt | Erfüllt HV-D16 und „eigener Pfad" buchstäblich. Kostet ein Werkzeug und eine Änderung an `.claude/commands/scheibe.md`:84 |
| **B** | **Orchestrator ruft und sammelt ein.** Der Harness setzt den MCP-Aufruf ab, formuliert die Anfrage, legt die Antwort ab | Der schnellste Weg, in einer Sitzung nutzbar. Aber er steht in Spannung zu *„eigener Pfad"* (Anlage :201) und macht `getrennter_kontext` zur Behauptung statt zur Bauweise. HV-D16 wäre eingehalten, solange der Text vom Fremdmodell stammt — die Grenze ist schmal |
| **E** | anders: ⟨ ⟩ | |

**Handlungsempfehlung des Orchestrators: C.** Nicht aus Vorsicht. Der Unterschied zwischen B
und C ist genau der Unterschied zwischen einer Bedingung, die man **zusichert**, und einer,
die man **erzwingt**. Bei C ist `getrennter_kontext: ja` keine Aussage über meine Absicht,
sondern eine Eigenschaft des Werkzeugs — nachlesbar in seinem Quelltext. Das ist die
Bauweise, die dieses Repo überall sonst schon anwendet.

---

## 7 · Was zu ändern ist — und auf welchem Weg

**Ein Pull Request ist Pflicht.** Gemessen an der Schutzeinstellung von `main`:

| | Befund |
|---|---|
| **Direkter Push** | ausgeschlossen — `required_pull_request_reviews`, dazu `enforce_admins: true`. Das gilt auch für den Auftraggeber |
| **Freigaben** | 1 zustimmende Prüfung · `require_code_owner_reviews: true` · `require_last_push_approval: true` · `dismiss_stale_reviews: true` |
| **Tore** | vier Pflichtprüfungen: *Tor 1a · Lint und Geheimnisschranke*, *1b · Migration*, *1c · Prüflauf*, *Tor 1 · Sperre* |
| **Sonstiges** | `required_conversation_resolution: true` · kein Force-Push · keine Löschung |

**Wer zeichnen muss.** `.github/CODEOWNERS` bindet die betroffenen Pfade an **beide**
Kennungen — `@exmachinai` **und** `@AndrewExma`:

    /CLAUDE.md    @exmachinai @AndrewExma
    /.claude/     @exmachinai @AndrewExma

**Der Umfang des Antrags:**

| | Datei | Was | Nötig für |
|---|---|---|---|
| 1 | `CLAUDE.md`:115 | Spalte *Werkzeug* auf den Wortlaut der Anlage bringen, mit Berichtigungsnotiz | **beide Wege** — die Abweichung besteht unabhängig von der Entscheidung |
| 2 | `.claude/commands/scheibe.md`:84 | Schritt 10 um den Ausführungsweg ergänzen; der **HALT bleibt** | B und C |
| 3 | `werkzeuge/fremdreview_anfordern.py` | neu — erzeugt die Anfrage mechanisch | nur C |
| 4 | `nachweise/fremdreview/VORLAGE.md` + `fremdreview.py` PFLICHT | ein Kopffeld, das den Weg benennt (`weg: mcp-mechanisch`) | **durch Befund 8.1 begründet** — ohne dieses Feld bleibt ein falscher Weg unsichtbar |
| 5 | diese Vorlage | mit ablegen | — |

**Die Anlage wird nicht angefasst, und es wird nichts neu gezeichnet** (Abschnitt 4).
Punkt 1 allein wäre auch ohne jede Entscheidung fällig: eine ausführbare Fassung, die enger
ist als der unterschriebene Text, ist ein Befund, kein Zustand.

---

## 8 · Zwei Befunde am Rand — aufgenommen auf Weisung vom 24.08.2026

Beide sind beim Lesen für diese Vorlage entstanden, nicht durch eine gerichtete Prüfung.
Der Orchestrator legt sie vor und bewertet sie nicht.

### 8.1 · Das Tor-3-Blatt vom 22.08.2026 ist über den Weg gelaufen, den die Anlage ausschliesst

| | |
|---|---|
| **Das Blatt** | `nachweise/fremdreview/fundament_260822.md`:11 · `pruefende_fassung: gpt-5.6-sol, Fassung 2026-07-09, **über Azure AI Foundry, EU-Datenzone**` |
| **Die Anlage** | :114 · *„extern, **direkt zu OpenAI über MCP**, nicht über die Azure-OpenAI-Ressource (Auftrag Z. 58–60)"* |

**Warum es kein Werkzeug gemerkt hat.** `fremdreview.py` prüft die **Form** des Blattes. Ein
Kopffeld für den **Weg** gibt es nicht (PFLICHT ab :55). Das Werkzeug hat korrekt gearbeitet;
es konnte diesen Fehler gar nicht sehen. **Damit ist das Kopffeld aus Abschnitt 7 Ziffer 4
nicht mehr eine Frage des Geschmacks, sondern begründet:** ohne `weg:` bleibt derselbe Fehler
auch beim nächsten Mal unsichtbar.

**Das zweite Blatt ist nicht betroffen.** `teilschnitt-anmeldung_260820.md`:21 nennt nur
*„Anzeige im Modellwähler"* ohne Weg — dort ist der Weg **unbekannt**, nicht abweichend.

**Was der Orchestrator ausdrücklich nicht entscheidet:** ob „Azure AI Foundry" und „die
Azure-OpenAI-Ressource" dieselbe Sache meinen. Der Wortlaut der Anlage zielt erkennbar auf
den Weg über Azure — die Gleichsetzung ist aber eine **Auslegung, keine Messung**. Trägt sie,
dann ist das Blatt zum Fundament formal vollständig, aber über den falschen Weg entstanden.
Ob es dann noch als Tor-3-Nachweis trägt, ist eine Zeichnungsfrage (Tor 4); kein Werkzeug
entscheidet sie, und `fremdreview.py` liest es weiterhin als *bestanden*.

### 8.2 · Produktseite: „ein anderes Modell als der Erzeuger" ist belegt, nicht erzwungen

Die Klausel (K06, Klauselregister): *„Der Prüflauf MUSS ein **anderes Modell** verwenden als
der erzeugende Agent. `review_run.model_ref_id` verweist mit Löschsperre auf `model_ref`
(Eigentümer K17) und hält fest, welches."*

`schema/freiraum_datamodel.sql` — Datenmodell **v2.9** (Kopf :2, Quelle
`FREIRAUM_Gesamtbuild_v2.9.html`); der Vermerk *„v2.7 NEU"* an der Fachprüfung ist eine
**Herkunftsangabe**, kein Versionsstand:

| | Regel | Zustand |
|---|---|---|
| :515 | `passed` folgt aus Prüfwert und Schwelle | **erzwungen** — `CONSTRAINT pass_matches_threshold CHECK (passed = (score >= threshold))` |
| :501 | höchstens zwei Runden | **erzwungen** — `CHECK (round BETWEEN 1 AND 2)` |
| :503 | Schwelle 90 | **erzwungen** — `NOT NULL DEFAULT 90 CHECK (threshold BETWEEN 0 AND 100)` |
| :513 | Prüfmaßstab nachvollziehbar | **erzwungen** — Fremdschlüssel auf `knowledge_module_version` |
| **:505** | **anderes Modell als der Erzeuger** | **nur belegt** — `model_ref_id … NOT NULL REFERENCES model_ref(id) ON DELETE RESTRICT`. Kein Constraint und kein Trigger vergleicht diesen Verweis mit dem Modell des erzeugenden Agenten |

Die drei Trigger des Schemas — `platform_admin_guard` (:610), `sealed_actor_guard` (:633),
`invitation_guard` (:653) — betreffen Plattform-Admin, Siegel und Einladungen, nicht den
Modellvergleich.

**Folge.** Ein Prüflauf mit **demselben** Modell wie der erzeugende Agent wird
**protokolliert, aber nicht verhindert**. Der Unterschied zur Nachbarzeile ist der ganze
Punkt: `passed` **kann** nicht falsch gesetzt werden — das Modell **soll** nur nicht dasselbe
sein. Damit ruht die tragende Eigenschaft der unabhängigen Fachprüfung auf einer Zusicherung,
während die weniger tragenden Eigenschaften mechanisch gesichert sind.

**Zur Einordnung.** Dieser Befund gehört auf die **Produktseite** und berührt Tor 3 des
Harness nicht. Sein richtiger Ort wäre ein eigenes Blatt in `nachweise/befunde/` nach dem
Muster der dortigen `BEF-…`-Reihe. Er steht hier, weil er beim Lesen für diese Vorlage
entstanden ist — Ziffer 6 der Zeichnung entscheidet, wohin er gehört.

---

## 9 · Was der Harness ausdrücklich nicht getan hat

- **Kein Tor-3-Blatt angelegt.** Der Zweitblick in Anhang A ist **kein Tor-3-Nachweis**: vom
  Harness angefordert, Prompt vom Harness formuliert. `angefordert_von` wäre nicht
  wahrheitsgemäss auszufüllen. HV-D16 gilt.
- **Die beiden Befunde aus Abschnitt 8 nicht bewertet und nicht behoben.** Weder wurde das
  Blatt vom 22.08. angefasst noch ein Constraint nachgezogen. Vorgelegt, nicht entschieden.
- **Keinen Kopf ausgefüllt.** `fremdreview.py`:27.
- **`CLAUDE.md` und `scheibe.md` nicht angefasst.** Abschnitt 7 ist ein Vorschlag zum Antrag,
  kein Vollzug.
- **Kein Werkzeug für Weg C gebaut.** Erst zeichnen, dann bauen.
- **Nichts committet und nichts gepusht.** Der Zweig `vorlage/fremdmodell-mcp-260824` liegt
  örtlich.
- **Nichts in `30_FREIRAUM/` oder `10_KNOWLEDGE_REPO/` geschrieben.** Die Anlage wurde
  **gelesen**, nicht verändert; ihre Prüfsumme ist unverändert `ded747a7…`.
- **Das Fremdurteil nicht geglättet.** Anhang A ist der Rohtext.

---

## Zeichnung

| | | |
|---|---|---|
| **1** | Der MCP-Weg für Tor 3 wird ausgeführt als | ☐ **C** Anfrage mechanisch erzeugt, Mensch löst aus · ☐ **B** Orchestrator ruft und sammelt ein · ☐ anders: ⟨ ⟩ |
| **2** | Die Abweichung `CLAUDE.md`:115 gegen Anlage :114/:201 wird | ☐ als Berichtigung im selben Antrag behoben · ☐ in eigenem Antrag · ☐ nicht, weil: ⟨ ⟩ |
| **3** | Der Antrag wird gestellt von | ☐ dem Harness, zur Freigabe durch beide Kennungen · ☐ mir selbst · ☐ anders: ⟨ ⟩ |
| **4** | Ein Kopffeld, das den Weg des Reviews benennt (Abschnitt 7 Ziffer 4), wird | ☐ aufgenommen · ☐ nicht aufgenommen |
| **5** | Zu Befund **8.1**: „Azure AI Foundry" und „Azure-OpenAI-Ressource" meinen | ☐ dasselbe — das Blatt vom 22.08. ist über den ausgeschlossenen Weg entstanden · ☐ Verschiedenes — kein Befund · ☐ zu klären durch: ⟨ ⟩ |
| **5a** | Falls dasselbe: das Tor-3-Blatt `fundament_260822.md` | ☐ trägt weiter · ☐ wird über den MCP-Weg neu eingeholt · ☐ anders: ⟨ ⟩ |
| **6** | Befund **8.2** (Produktseite) wird geführt | ☐ als eigenes Blatt `nachweise/befunde/BEF-…` · ☐ als Restrisiko in der Restrisikoliste · ☐ als Bauauftrag (Constraint nachziehen) · ☐ nur hier |

| Name | Rolle | Datum |
|---|---|---|
| M. Veil | Auftraggeber | ⟨ ⟩ |
| A. Han | für den Auftragnehmer | ⟨ ⟩ |

---

## Anhang A · Der Zweitblick im Wortlaut

**Modell:** `gpt-5.6-sol` · **Weg:** Codex-MCP, `sandbox: read-only` · **Faden:**
`01a030af-8311-7231-9d48-e95d2e5c9949` · **gelesene Dateien:** `CLAUDE.md`,
`.claude/commands/scheibe.md`, `werkzeuge/fremdreview.py` im Stand `56437fe`.
**Kein Tor-3-Nachweis** — siehe Abschnitt 8.

**Einordnung nachträglich.** Das Fremdmodell hat nur die Dateien im Repo gesehen, **nicht die
Anlage** — die liegt ausserhalb. Sein Urteil beschreibt deshalb die Lage nach `CLAUDE.md`,
nicht nach dem unterschriebenen Text. Genau darin liegt sein Wert für Abschnitt 4: es hat die
engere Fassung gelesen und sie konsequent angewandt. Sein Punkt 3 bleibt in der Sache gültig
und ist die Begründung für Weg C.

> **1.** Gefährdet wären insbesondere:
>
> - `frische_instanz`
> - `getrennter_kontext`
> - `gegen_roh_evidenz`
> - `evidenz`
> - `angefordert_von`
> - `harness_hat_nicht_geschrieben`
> - außerdem die verlässliche Angabe von `pruefendes_modell`, `pruefende_fassung` und `geprueft_commit`
>
> Die ersten vier Bedingungen müssen ausdrücklich mit „ja" bestätigt werden
> (fremdreview.py:53). Ein Mensch muss die Anforderung zeichnen; eine Maschine kann weder
> Fremdherkunft noch tatsächliche Roh-Evidenz-Prüfung feststellen (fremdreview.py:16).
>
> **2.** Nur unter strengen Auflagen. C-4 ist technisch mit MCP vereinbar, wenn jede Anfrage
> eine neue, zustandslose Modellinstanz erhält, keinerlei Claude-/Harness-Kontext übertragen
> wird und das Modell ausschließlich den festgelegten Commit samt benannter Roh-Evidenz sieht
> (CLAUDE.md:111). Der beschriebene vollautomatische Ablauf ist dagegen nicht vereinbar: Das
> Werkzeug ist „außerhalb dieses Harness" verortet; der Harness darf das Review weder
> anfordern noch schreiben (CLAUDE.md:115, fremdreview.py:27). Nach Schritt 10 führt der
> Mensch die Anforderung aus, legt das Blatt ab und zeichnet den Kopf (scheibe.md:84).
>
> **3.** Für ein wahrheitsgemäßes `harness_hat_nicht_geschrieben = ja` müsste technisch
> erzwungen werden:
>
> - Der Harness besitzt weder die Berechtigung zum MCP-Aufruf noch Schreibrechte auf Review und Kopf.
> - Erst die ausdrückliche menschliche Entscheidung startet einen getrennten MCP-Client außerhalb des Harness.
> - Nur das Fremdmodell erzeugt den Reviewtext; der Harness darf ihn weder ergänzen noch umformulieren.
> - Ein Mensch prüft, legt das unveränderte Blatt ab und zeichnet die Anforderung.
>
> Eine Maschine kann die Fremdherkunft dennoch nicht abschließend beweisen; laut Docstring
> ist die menschliche Zeichnung der maßgebliche Beleg (fremdreview.py:18).

---

*Erstellt am 24.08.2026, am selben Tag zweimal neu gefasst: nach der Klarstellung des
Auftraggebers und nach dem Lesen der gezeichneten Anlage. Die Werte aus Abschnitt 1 stammen
aus tatsächlich gefahrenen Proben gegen die eingerichtete Verbindung.*
