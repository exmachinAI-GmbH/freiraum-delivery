Alle Messungen liegen vor. Bericht:

---

# Prüfbericht · B-1 bis B-5 · gemessen am 16.08.2026

## 1 · Urteil in drei Sätzen

**Geschlossen ist die Buchführung, nicht die Sache.** Alle vier Pakete haben die Nachweise angelegt, die bisher fehlten — Abnahmeblatt, Festlegungsblatt, Fremdprüfungs-Anforderung, Pflegeliste, Restrisikoliste —, und **jeder Vorschlag ist als Vorschlag erkennbar geblieben** (411 von 411 markiert, 0 unmarkiert, gegengemessen).

**Nicht geschlossen ist alles, was eine Unterschrift braucht:** 0 von 24 Eigentümern, 0 von 113 Trägern, 0 von 113 Annahmeentscheidungen, Tor 3 weiterhin gesperrt, und **von den 167 gezeichneten Abnahmekriterien liegen 15 vor** — die übrigen 152 sind aus keiner im Arbeitsstand liegenden Quelle ableitbar.

**Ein Formmangel zieht sich durch B-1:** das Abnahmeblatt setzt vier Kreuze und beruft sich dafür auf **F40** — und F40 sagt im Wortlaut etwas anderes.

---

## 2 · Die Zahlen, gemessen

| Messung | vorher | jetzt | zitierte Ausgabe |
|---|---|---|---|
| **Prüflauf** | 11 · 3 · 2 | **11 · 3 · 2** | `bestanden: 11 · fehlgeschlagen: 3 · gesperrt: 2` |
| **Klauselregister** | Rückfallzweig, 1 Befund | **0 Befunde** | `1231 Klauseln - ohne Akzeptanzkriterium: 1216 - ohne Test: 1231 - Befunde: 0` |
| `--streng` | 1 | **1** | Exit 1 (mit `PIPESTATUS` gemessen, nicht durch `tail` verdeckt) |
| ohne Kriterium | 1231 | **1216** | −15 |
| ohne Kritikalität | 1231 | **826** | −405 |
| **ohne Eigentümer** | 1231 | **1231** | unverändert |
| ohne Test / Teststand / Ergebnis / Evidenz | 1231 | **1231** | unverändert |
| vollständige Zeilen | 0 | **0** | — |
| **Tor 3** | gesperrt | **gesperrt** | `Tor 3: kein Fremdreview abgelegt. Zustand: GESPERRT` |
| **Trennung** | — | **sauber** | 16 Pfade, alle im eigenen Ordner |
| **fundstellen.py, neue Texte** | — | **1 Treffer, Artefakt** | siehe M7 |

**Alles unabhängig nachgerechnet, nicht übernommen:**

| Behauptung | mein eigener Nachlauf |
|---|---|
| Ausschnitt 152 + 5 = 157 | Mandant 106 · Einladungsschranke 4 · Einladung 34 · Anmeldecode 19 · Anmeldung 6 → **Vereinigung 152**, Bauspur disjunkt → **157** ✓ |
| 125 kritisch, **113** ohne Prüffall | **125 / 113** ✓ |
| Klassen 26 · 94 · 8 · 5 · 5 | identisch ✓ |
| alle 113 sperrend | `sperrt_die_freigabe = true` bei 113 ✓ |
| Träger/Annahme/Frist leer | **113 von 113 leer** ✓ |
| `pflege.json` sha256 `66041cf5…` | neu erzeugt → **bitgleich** ✓ |
| `restrisiken_teilschnitt.*` reproduzierbar | neu erzeugt → **bitgleich** ✓ |
| Bauauftrag Z. 728 nennt **14** | im Original nachgelesen: „05, 11, 13, **14** und 15 … sie betreffen den **Bau**" ✓ |
| Starttor 14 = Übergabe K04→K07, „offen" | Z. 189 ✓ |
| „BA-1" existiert nicht | ein Treffer im Repo, **null** im Auftragsordner ✓ |

**Stichprobe fünf Klauseln** (K03-M15, K20-M14, K23-D09, K13-M05, K03-M25): jeder Vorschlag ist eine reine Zerlegung des eigenen Wortlauts. **Kein Wert, keine Schwelle, keine Frist ergänzt.** K03-M15 „zehn Minuten / genau einmal / entwertet ältere / nur der Prüfwert" — vier Bedingungen, vier Sätze im Wortlaut. Nichts erfunden.

---

## 3 · Was jetzt bei einem Menschen liegt

| Wer | Was | Warum nur er |
|---|---|---|
| **M. Veil** | **24 Namen** in `eigentuemer_zuweisung_260816.md` eintragen | Keine der geprüften Quellen benennt einen Menschen — nachgemessen: `konzepte.yaml` hat kein solches Feld, `kanon.yaml` Abschn. 4 meint ein **Konzept**, `triage.json` trägt unter `vorschlag_eigentuemer` ebenfalls nur Konzeptkürzel (K01, K17, …). Ein Name, den keine Quelle trägt, wäre erfunden |
| **M. Veil** | **113 Träger, 113 Annahmeentscheidungen, 113 Fristen** zeichnen | Träger sind Menschen (K23-D07). Ein gefülltes Feld ohne Entscheidung ist schlimmer als ein leeres |
| **M. Veil / A. Han** | **Starttor 13 klären** | Gemessen offen: `create_direct_prototype` hat **einen** Treffer im ganzen Repo — den Namen selbst. `grep direct_prototype app/` = **0**. Der Befund hat bis heute **keinen Träger und keine Frist** — genau die Auflage aus Weg 2 |
| **M. Veil / A. Han** | **Befund ST-14 entscheiden** — vier Starttore oder fünf | Ein Starttor aus einer gezeichneten Bedingung zu streichen ist eine Umfangsänderung. Weg: Korrekturblatt nach Abschn. 12 |
| **M. Veil / A. Han** | **„Korrekturblatt BA-1" vorlegen oder streichen** | Die Zahl *vier* hat sonst keine Quelle |
| **M. Veil** | **`zeichnung_M7-M10_260815.md` in den Arbeitsstand bringen** | Der Zweig `umsetzung/M7-M10-260815` existiert (nachgesehen), das Blatt liegt nicht im Baum. Ohne die 167 Kennungen bleiben 152 Kriterien unerzeugbar |
| **A. Han** | **Fremdprüfung anfordern**, Etikett `teilschnitt-anmeldung` anlegen, `tor3.yml:51` erweitern | Der Harness schreibt das Review nie selbst |
| **A. Han / Eigentümer** | **Die 15 Kriteriumsvorschläge zeichnen, streichen oder schärfen** | K23-M02 wörtlich |

---

## 4 · Mängel, nach Schwere

### M1 · schwer — **F40 trägt die Übertragung der Kreuze nicht**

`starttore_abnahme_260816.md:13` nennt F40 „die Festlegung, dass ein Agent nie zeichnet, sondern nur die Zeichnung eines Menschen abbildet". **Im Wortlaut steht das nicht.** F40 nachgelesen:

> „Die Zeichnung gehoert dem Menschen und liegt in einer eigenen Datei … **Der Fehler lag … darin, dass ein Werkzeug die Unterschrift ueberhaupt erreichen konnte.**"

F40 regelt die **Trennung** der Zeichnungsdatei, nicht das Kopieren von Kreuzen. Eine Regel zur „Übertragung" findet sich im ganzen Kanon nicht (`grep uebertrag|übertrag|abbild` → 0 Treffer). Und dasselbe Paket widerspricht sich selbst: `starttor_11_13_nachweis_260816.md` schreibt „der Harness setzt in einem fremden Zeichnungsblock kein Kreuz (F40)" — im Abnahmeblatt setzt er vier.

**Satzfertige Korrektur** (in `starttore_abnahme_260816.md`, Zeile 13):
> **Form** | Die Kreuze sind **abgeschrieben** aus der Weisung des Auftraggebers vom 16.08.2026, die in Abschnitt 7 im Wortlaut steht. **Eine Festlegung, die dem Harness das Abschreiben einer Unterschrift erlaubt, gibt es nicht** — F40 regelt nur, dass die Zeichnung in einer eigenen Datei liegt und von keinem Werkzeug erreicht wird. **Dieses Blatt ist deshalb ein Nachweis, keine Zeichnung.** Gilt es als Zeichnung, muss M. Veil es selbst gegenzeichnen: ⟨Name⟩ ⟨Datum⟩.

### M2 · schwer — **B-4 liefert 15 von 167 Kriterien (9 %)**

Die Zeichnung verlangt die Einengung „auf die 167 Klauseln". Geliefert sind 15. Die Begründung ist offen und nachrechenbar (das tragende Blatt liegt nur auf einem Zweig; 152 ist keine eindeutige Stationskombination). **Bedingung 4 des Liefertors bleibt damit zu 91 % offen** — und das ist die Bedingung, von der die Vorlage selbst sagt, an ihr werde das Liefertor scheitern.

**Satzfertige Korrektur** (Kopf `pflege_LIESMICH.md`): > **Umfangslücke, offen benannt:** Gezeichnet sind 167 Kriterien, erzeugt sind 15. **Die fehlenden 152 sind kein Fleißproblem, sondern eine fehlende Quelle** — `zeichnung_M7-M10_260815.md` liegt nur auf `umsetzung/M7-M10-260815`. Bis das Blatt im Arbeitsstand liegt oder die 167 Kennungen benannt sind, ist B-4 zu 9 % erfüllt. **Verantwortlich: M. Veil. Frist: ⟨offen⟩.**

### M3 · mittel — **`fremdreview.py` meldet grün, wo nichts gemessen wurde** (reproduziert)

Mit einem Probeblatt für Scheibe 1 in einem getrennten Ordner:

```
$ python3 werkzeuge/fremdreview.py --verzeichnis <probe> --scheibe teilschnitt-anmeldung
Tor 3: 0 bestanden, 0 fehlgeschlagen, 0 gesperrt      EXIT=0
```

`tor3.sh:49–51` reicht den Wert durch und meldet „Tor 3 bestanden." Ursache: der Filter in `main()` (Z. 299) greift **nach** der Leerprüfung (Z. 288), die nur den ganzen Ordner kennt. Verstoß gegen K23-M22. **Heute folgenlos — wirksam ab dem ersten abgelegten Blatt, also ab diesem Durchlauf.**

**Satzfertige Korrektur** (`fremdreview.py`, nach dem Filter): > Wurde nach `--scheibe` gefiltert und bleibt **kein** Blatt übrig, ist der Zustand **gesperrt**, nicht leer: `print("Tor 3: fuer <scheibe> liegt kein Blatt vor -- GESPERRT (K23-M22).")` und `return 1`.

### M4 · mittel — **Die Vorlage bringt vier Bestätigungen bejaht mit** (bestätigt)

`VORLAGE.md` Z. 26, 27, 28, 31 tragen `ja` bei `frische_instanz`, `getrennter_kontext`, `gegen_roh_evidenz`, `harness_hat_nicht_geschrieben` — alle anderen Felder tragen Platzhalter `<…>`. `README.md:145–147` nennt genau diese vier „Bestätigungen, die nur Sie geben können". Wer kopiert und die übrigen füllt, hat vier Aussagen bestätigt, die er nie gemacht hat.

**Satzfertige Korrektur:** in `VORLAGE.md` alle vier Werte auf `<ja | nein>` setzen.

### M5 · mittel — **Fundstellen werden gefordert, nicht gemessen** (bestätigt im Quelltext)

`fremdreview.py:208` prüft `"## Fundstellen" not in text` — also nur die Überschrift, die die Vorlage mitbringt. Ein Blatt ohne eine einzige Fundstelle meldet `BESTANDEN`.

**Satzfertige Korrektur:** zusätzlich prüfen, dass unter der Überschrift mindestens eine Zeile der Form `<pfad>:<zeile>` steht; sonst Befund „Abschnitt Fundstellen ist leer — ein Urteil ohne Fundstellen ist eine Meinung."

### M6 · leicht — **Vier Quellenpfade zeigen ins Leere**

`pflege_LIESMICH.md:83` und `eigentuemer_zuweisung_260816.md:23–24` nennen `config/konzepte.yaml` und `config/kanon.yaml`. **Ein `config/`-Verzeichnis gibt es im Repo nicht.** Die Dateien liegen außerhalb (`…/K00_Ablagepaket_2026-08-02/config/konzepte.yaml`, `~/Desktop/…/04_Pruefmassstab/kanon.yaml`). Ich habe beide geöffnet: **die inhaltliche Aussage stimmt** — `konzepte.yaml` hat kein Eigentümerfeld (`grep eigentuem|owner` → 0 Treffer), `kanon.yaml` Abschn. 4 ordnet Tabellen einem **Konzept** zu. Nur nachprüfen kann es niemand, der dem Pfad folgt.

**Satzfertige Korrektur:** beide Angaben um den Zusatz ergänzen „*(liegt außerhalb dieses Repos, Ablage siehe `03_AGENT_HARNESS_CODING/README.md`)*".

### M7 · leicht — **Zwei Zählfehler**

- `festlegung_teilschnitt_anmeldung_260816.md:198` schreibt „**an vier Stellen** ins Leere", zählt dann **sieben** auf. Gemessen sind es sieben (`fremdreview.py:27,64,178,206,293` · `VORLAGE.md:12` · `tor3.yml:13`) — der Bericht des Pakets nennt „sechs".
- `eigentuemer_zuweisung_260816.md:90` schreibt „**Drei Namen** decken alles ab", nennt in derselben Klammer **vier** Konzepte (K03, K20, K13, K23).

**Satzfertige Korrektur:** „vier" → „sieben"; „Drei Namen" → „Vier Namen".

### M8 · leicht — **Die Quellenliste ist unvollständig**

„Vier Quellen wurden durchsucht." Es gibt eine fünfte: `triage.json` trägt je Zeile ein Feld `vorschlag_eigentuemer` — mit Konzeptkürzeln (K01 = 81 ×, K17 = 79 ×, …). **Das ändert das Ergebnis nicht** — ein Konzept ist kein Mensch, und genau so argumentiert das Blatt. Aber wer das Feld findet, hält die Aussage „keine Quelle benennt einen Eigentümer" für widerlegt.

**Satzfertige Korrektur:** fünfte Tabellenzeile — „`triage.json`, Feld `vorschlag_eigentuemer` | je Klausel das **Konzeptkürzel**, aus der Kennung abgeleitet | **nein** — dasselbe Konzept, das die Kennung schon trägt".

**Kein Mangel:** der eine Treffer von `fundstellen.py` in den neuen Texten (`festlegung_…:201`) ist ein Parser-Artefakt — das Werkzeug liest das Zitat `*„scheibe.md:73` als Dateinamen. Die Datei berichtet dort korrekt über einen **fremden** toten Verweis. Die sechs sperrenden Fundstellen des Laufs liegen sämtlich in `CLAUDE.md` und `.claude/agents/` — Altbestand, von keinem der vier Pakete berührt.

---

## 5 · Die schärfste Frage: ist eine offene Frage still entschieden worden?

**Bei den Feldern: nein — und das ist maschinell geprüft, nicht geglaubt.**

```
Eintraege gesamt: 411
gefuellte Felder: {'kritikalitaet': 405, 'akzeptanzkriterium': 15}
UNMARKIERT: 0
OHNE offene Unterschrift: 0
unerlaubte Felder: set()
```

Kein Eigentümer eingetragen. Kein Test, kein Teststand, kein Ergebnis, keine Evidenz. Jeder der 420 Werte beginnt mit `⟨VORSCHLAG · NICHT GEZEICHNET⟩` und endet mit `⟨zeichnet: ⟩ ⟨am: ⟩`. In der Restrisikoliste tragen **alle 113** `kritikalitaet_status: "Triage-Vorschlag, nicht festgestellt"` und leere Träger-, Annahme- und Fristfelder. Ein Leser kann keinen dieser Werte für gezeichnet halten. **Die 826 unbestimmten Kritikalitäten blieben leer** — „unbestimmt" hineinzuschreiben hätte 826 Zeilen bearbeitet aussehen lassen. Das ist die richtige Entscheidung.

**Zwei Dinge sind trotzdem entschieden worden, ohne dass jemand gefragt wurde:**

**(a) Die Form der Übertragung.** Dass ein Agent ein Kreuz eines Menschen in eine selbst angelegte Datei schreiben darf, ist **nirgends gezeichnet**. Es wird auf F40 gestützt, und F40 sagt das Gegenteil-nahe: der Anlass von F40 war, dass ein Werkzeug eine Unterschrift überhaupt erreichen konnte. **Das ist keine Feldentscheidung, sondern eine Formentscheidung — und sie trägt vier Abnahmen.** Sie gehört M. Veil, nicht dem Harness. Siehe M1.

**(b) Bei Starttor 13 wurde zwischen den zwei angebotenen Wegen faktisch gewählt.** Die Empfehlung sagte „zurückstellen **oder** als benannten Befund **mit Träger und Frist** tragen." Das Kreuz ist gesetzt, der Befund ist geführt — **Träger und Frist fehlen.** Damit ist die Auflage von Weg 2 nicht erfüllt. Zu Gunsten des Pakets: die Zeichnung B-1 gab „[x] · siehe Vorbehalt" selbst vor, und Abschnitt 8 Zeile 213 reicht den Punkt ausdrücklich an M. Veil und A. Han zurück. **Es ist offen benannt, aber nicht offen geblieben.**

**Was das Paket dagegen sehr gut gemacht hat:** Es hat drei Widersprüche gefunden, die niemand beauftragt hatte, und **keinen davon geglättet** — Starttor 14 fehlt in der Zeichnung, „BA-1" existiert nicht, und `starttor_11_13_nachweis_260816.md:26` zitiert den gezeichneten Auftragswortlaut **verändert** („05, 11, 13 und 15 … den *Teilschnitt*" statt „05, 11, 13, **14** und 15 … den *Bau*"). Ich habe alle drei am Original nachgeprüft. **Alle drei stimmen.** Das ist der Grund, warum ich dem Rest der Messungen traue.