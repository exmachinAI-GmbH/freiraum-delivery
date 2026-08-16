## 1 · Urteil

Die Prüfung hat sauber gearbeitet: kein Prüfwert ist gesunken, jede Änderung trägt die Klausel oder die Zeichnung im Kopf, nie den Bau. Der Bau hat sein Stück ebenfalls geliefert — die vier Ereigniszeilen tragen jetzt `KI_NACHWEIS`, die Trennung der Ordner ist unverletzt. Die drei verbleibenden roten Fälle (MT-95, MT-95b, ZB-20) scheitern **alle drei an derselben fremden Bedingung**: die Prüfdaten setzen keine Zweckbestimmung, und `create_app_after_fit` verlangt sie seit M31 zu Recht — das ist ein Mangel der Prüfung, nicht des Baus.

## 2 · Die Zahlen

Alle Vorher-Werte sind **gegen denselben Bau nachgemessen** (HEAD-Fassung der Prüfdateien aus `9c7a79b`/`625b3d7`, gefahren gegen die frisch gebaute `freiraum_ci`), nicht aus dem Auftrag übernommen.

| | vorher | jetzt | |
|---|---|---|---|
| Migrationsprüffälle | 108 / 111 | **109 / 111** | MT-98 grün; MT-95, MT-95b rot |
| Faden `zweckbestimmung` | 3 / 26 (23 gesperrt, 0 gescheitert) | **7 / 27** (19 gesperrt, 1 gescheitert) | +4 bestanden, −4 gesperrt |
| Faden `vorpruefung` | 30 / 32 | **30 / 32** | VP-24 rot, Grund geändert |
| Summenzeile | 11 · fehl 2 · gesperrt 3 | **11 · fehl 3 · gesperrt 2** | siehe unten |

**Die Summenzeile sieht schlechter aus und ist besser.** `zweckbestimmung` ist von *gesperrt* nach *fehlgeschlagen* gewandert. Vorher waren dort 23 Fälle nicht messbar und **null** gemessen; jetzt sind vier zusätzlich bestanden und einer sagt echt „nein". Ein gemessenes Nein ist mehr wert als ein Nichtmessen.

**Die sieben nachgezogenen Fälle:** 4 grün (MT-98, ZB-21, ZB-22, ZB-23), 3 rot (MT-95, MT-95b, ZB-20). Vorher waren sie gegen diesen Bau **nicht** grün, sondern MT-95/95b/98 rot und ZB-20..23 gesperrt („besteht nicht in der Gestalt mit fünf Werten").

**VP-24:** nein, weiter rot — aber an einer anderen Bedingung als vorher.

**Der Abgleichprüffall existiert und meldet BESTANDEN.** Im Wortlaut: `ZB-26 BESTANDEN DAUERMESSUNG: … kein Stand ohne Vorgang, kein Vorgang ohne Stand. Geprueft an zweckbestimmung_ack_at, zweck_bewertung_menschen, zweck_verbotene_praktik, zweckbestimmung_erklaert_am; beide Selbstproben haben die vorgetaeuschte Abweichung gefunden (A mit 'zweck_bewertung_menschen = true'), der Fall kann also scheitern.` Er ist nicht leer bestanden — die Fahrten des Laufs setzen die Stände vorher.

**Trennung: sauber.** `git status --short` führt genau vier Dateien, alle unter `pruefungen/`. Die Bau-Änderung liegt committet in `cf33a51` und berührt nur `app/zweckbestimmung.py` und `arbeit/`. Kein Übergriff in beide Richtungen.

**Ist ein Prüfwert gesunken? Nein.**
- ZB-14: die drei alten Bedingungen stehen Wort für Wort, eine vierte kam hinzu. Der Diff entfernt keine einzige Zusicherung.
- ZB-20..23: nur die Aufrufgestalt (fünf → vier Werte) und der Anker (`project_no` → `name`) sind getauscht. Der Anker war die Umgehung selbst.
- VP-24: eine **gedeckte** Lockerung (starre Spaltengleichheit → Vollständigkeit + Namensdeckung + Obergrenze) und eine echte **Verschärfung** (`zusatz_spiegel` gilt jetzt auch für `fit_check` selbst). Grundlage im Kopf: die Zeichnung vom 16.08. und K04-M19/K04-D05 — nicht der Bau. Die Zeichnung liegt vor: `arbeit/Vorlagen/zeichnung_vorlagen_260816.md:43-49`, Weg C, `[x]`.

**Tor 1:** `bash -n` über alle acht Schalen fehlerfrei · `ruff check app/ migrations/` → *All checks passed* (ruff 0.16.1) · `python3 -m py_compile app/*.py` → 0 · `M30__pruefung.sha256` stimmt mit der Datei überein (`6f9511…a2ba88`).

## 3 · Was noch rot oder gesperrt ist

**Rot (3):**

| Fall | Träger |
|---|---|
| MT-95, MT-95b | **Prüfung** — Prüfdaten unvollständig |
| ZB-20 | **Prüfung** — dieselbe Ursache |
| VP-24 | **Prüfung** — Obergrenze zählt Spalten statt Fragen |

**Gesperrt (die schwersten):**

| Fall | Träger |
|---|---|
| ZB-03 bis ZB-19, ZB-24 (16 Fälle) | **Prüfung** — Entdeckung des Weiterwegs nicht eindeutig |
| ZB-25 (Währung EUR) | **Mensch** — kein Mandant, an dem eine andere Währung entstünde; ein Fall dazu könnte nicht scheitern |
| VP-08b | **Mensch** — Widerspruch K04-M07 gegen Rang 1, unverändert |
| AC-16, MG-08 | **Mensch/Umgebung** — unverändert seit dem 11.08. |

## 4 · Mängel, nach Schwere

**M1 · schwer · Prüfung · trifft MT-95, MT-95b, ZB-20**
Der Serverbefehl verlangt seit M31 beide Antworten (`ZWECKBESTIMMUNG: beide Fragen muessen beantwortet sein (K04-M19)`, `create_app_after_fit` Zeile 71). Die verwendeten Prüfzellen tragen sie nicht: `pruefungen/migration/M30__pruefung.sql:66-68` legt `…e1` ohne Zweckbestimmung an, und `pruefungen/klauseln/zweckbestimmung_daten.sql:240` sagt es ausdrücklich („Die Checks tragen KEINE Zweckbestimmung"). Der Riegel ist richtig — die Fälle scheitern an einer fremden Bedingung.
*Korrektur:* „MT-95 und MT-95b setzen unmittelbar vor dem Aufruf `UPDATE fit_check SET zweck_bewertung_menschen=false, zweck_verbotene_praktik=false, zweckbestimmung_erklaert_am=now() WHERE id='…e1'`; ZB-20 setzt dasselbe an `$CHECK_GEEIGNET` **innerhalb seiner eigenen Transaktion**, damit die übrigen Fälle ihre unbeantwortete Prüfzelle behalten — beide Fälle messen den Rechteschnitt, nicht die Zweckbestimmung, und die misst ZB-24."

**M2 · schwer · Prüfung · sperrt 16 Fälle**
`zweckbestimmung_lauf.sh:764-770` leitet das Ziel „Weiter" als das **einzige** Ziel ab, das erst mit der zweiten Antwort erscheint (`comm -13 ZIELE_NULL ZIELE_ZWEI`). Der Bildschirm zeigt aber zwei neue: `/zweckbestimmung/aendern` und `/zweckbestimmung/anlegen`. Der Rücknahmeweg ist von der Zeichnung gedeckt und steht seit `ab46289` — **das ist kein Rückschritt dieser Runde**, aber der größte Hebel im Faden. `ZIELE_EINS` wird bereits erhoben und nicht benutzt; `/aendern` erscheint schon nach **einer** Antwort (`app/vorlagen/en04a_zweckbestimmung.html:247`).
*Korrektur:* „Der Unterschied wird gegen `ZIELE_EINS` statt gegen `ZIELE_NULL` gebildet — der Rücknahmeweg steht schon nach der ersten Antwort da und ist damit kein neues Ziel; bleiben dann immer noch mehrere, sperrt der Fall wie bisher."

**M3 · mittel · Prüfung · trifft VP-24**
`vorpruefung_lauf.sh:1778` zählt **alle** Zusatzspalten und deckelt bei zwei. Gefunden werden drei: `zweck_bewertung_menschen`, `zweck_verbotene_praktik`, `zweckbestimmung_erklaert_am`. Das dritte ist keine dritte Frage, sondern ein Zeitstempel — `migrations/M31…sql:121`: *„Zeitpunkt, zu dem BEIDE Fragen beantwortet vorlagen"*, gleicher Bauart wie das bereits akzeptierte `zweckbestimmung_ack_at`. K04-M19 zeichnet zwei **Fragen**, nicht zwei Spalten.
*Korrektur:* „Die Obergrenze zwei gilt für die **antworttragenden** Zusatzmerkmale — `data_type = 'boolean'`; Zeitstempel (`_at`, `_am`) fallen weiter unter die Namensdeckung, nicht unter die Zählung, weil ein Zeitstempel keine Frage ist (K04-M19)."

**M4 · mittel · Prüfung · stiller Durchlass in VP-24**
Das Deckungsmuster `'(zweck|kenntnis|ack|anhang|…)'` prüft `ack` als freien Teilstring. Spalten wie `feedback_score` oder `tracking_id` enthalten `ack` und gälten damit als von der Zeichnung gedeckt — genau das, was der Fall verhindern soll.
*Korrektur:* „Die Wortbestandteile werden verankert: `'(^|_)(zweck|kenntnis|ack|anhang|annex|artikel|article|verbot|prohib|purpose)'` — sonst deckt `ack` auch `feedback` und `tracking`."

**M5 · leicht · Mensch · Buchführung**
Die Zeichnung steht in `arbeit/Vorlagen/zeichnung_vorlagen_260816.md`, aber der Zeichnungsblock in `arbeit/Vorlagen/entscheidung_traeger_zweckbestimmung_260816.md:135-150` ist **leer** — kein Kreuz. Wer nur die Vorlage liest, sieht eine ungezeichnete Entscheidung, auf die zwei Prüffälle sich berufen.
*Korrektur:* „Der Zeichnungsblock der Vorlage 1 wird mit Verweis auf `zeichnung_vorlagen_260816.md:43-50` ausgefüllt, oder die Vorlage trägt oben den Satz, dass die Zeichnung dort geführt wird."

**M6 · leicht · Mensch · offene Auflage**
Die zwei Kunden-Code-Dauermessungen vom 15.08., auf die sich die Auflage der Zeichnung ausdrücklich beruft (`entscheidung_traeger_zweckbestimmung_260816.md:116`), existieren **nirgends** — weder in `pruefungen/` noch unter `install/` oder `migrations/`. Der Prüf-Agent hat das gemeldet; die Nachsuche bestätigt es. ZB-26 folgt deshalb der Hausform der übrigen Fälle (`ok`/`nok`/`sperr`, Unterscheidung, Selbstprobe mit ROLLBACK), was mir richtig erscheint.
*Korrektur:* „Entweder wird die Auflage vom 15.08. als eigener Auftrag geführt, oder es wird festgehalten, dass die Bauart von ZB-26 sie ersetzt."

**M7 · leicht · Bau · vom Bau selbst vorgelegt**
Scheitert das `INSERT` auf `event` im Antwort- oder Rücknahmeweg, sieht die Kundin eine Serverfehlerseite; der Kenntnisnahmeweg hat dafür `MELDUNG_KENNTNIS_NICHT_SCHREIBBAR`. Fail-closed ist es, lesbar nicht. Der Bau hat den Fangzweig bewusst nicht gebaut. Ich stimme zu — kein bekannter Fehlerfall.
*Korrektur:* „Der Punkt gehört als Zeile in die Vorlage, nicht in den Code: ein Fangzweig ohne bekannten Fall verdeckt mehr, als er hilft."

---

Arbeitsstand: `/private/tmp/claude-501/-Users-mveil/c7cd9bc4-ea30-405e-b4d9-be0d251a1de4/scratchpad/` — `lauf_voll2.txt` (voller Lauf, jetzt), `aus_zweckbestimmung.txt` (alle 27 Fälle im Wortlaut), `alt_aus_zb.txt`/`alt_aus_vp.txt` (HEAD-Fassungen gegen denselben Bau). Nichts im Zweig geändert; die Wegwerf-Datenbank `mig_alt` ist wieder entfernt.