# FREIRAUM Coding-Harness · `~/freiraum-delivery`

| Feld | Wert |
|---|---|
| **Gezeichnete Verfassung** | Anlage **„Bauverfahren"** zum Bauauftrag — **von beiden Vertragsseiten gezeichnet:** M. Veil am 07.08.2026, A. Han für den Auftragnehmer (Nr. 158) am 16.08.2026. **Damit ist diese Datei keine Vorschlagsfassung mehr, sondern die ausführbare Seite einer vollständig gezeichneten Anlage** |
| Ablageort | `03_AGENT_HARNESS_CODING/30_DELIVERY_HARNESS/` — **bewusst außerhalb dieses Repos**: `--pruefsumme` misst diese Datei *gegen* die Anlage; lägen beide hier, änderte ein Commit beide Seiten. Überschreibbar mit `FREIRAUM_ANLAGE` |
| **Prüfsumme der Anlage** | `ded747a7a98bcc7fa11442b92e0d09a244c0b4ee2051f10fb251bdb68300274d` — gezeichnet 07.08.2026, Nachweis in `Anlage_Bauverfahren_zeichnung.md` |
| Nachgerechnet mit | `./install.sh --pruefsumme` · Regel: `shasum -a 256 <Anlage>` |
| Ausführbare Fassung | **diese Datei** |
| Bauauftrag | erteilt 06.08.2026 · Endtermin 31.08.2026 (Bauauftrag :1, :39, :40) |
| Repo | `exmachinai/freiraum-delivery` — GitHub ist Wahrheit, kein Klon in Dropbox. **Seit 09.08.2026 bringt das Repo alle Bau-Eingaben selbst mit**; außerhalb liegen nur noch die Anlage, ihre Zeichnung und das Zugangsblatt, je mit Grund (`03_AGENT_HARNESS_CODING/README.md`) |

**Zwei Texte, eine Sache.** Gezeichnet wird die Anlage, ausgeführt wird diese Datei.
Bei Abweichung gilt die **Anlage**. Stimmt die Prüfsumme oben nicht, redet diese Datei über
eine andere Fassung als die unterschriebene: dann wird **nicht gebaut, sondern gefragt**.

**Die Anlage ist seit dem 16.08.2026 von beiden Vertragsseiten gezeichnet.** Diese Datei ist
damit die ausführbare Seite einer gezeichneten Anlage — kein Vorschlag mehr. Der frühere Satz
*„Solange die Anlage nicht gezeichnet ist, ist diese Datei ein Vorschlag"* ist mit der
Gegenzeichnung A. Hans gegenstandslos geworden.

**Was unverändert gilt:** Sie steuert die Arbeit, sie ersetzt keine Zeichnung. Bei Abweichung
gilt die Anlage. Und stimmt die Prüfsumme oben nicht, wird nicht gebaut, sondern gefragt.

---

## 0 · Zwei Zählungen, die nicht verwechselt werden dürfen

| Bezeichnung | Bedeutung | Quelle |
|---|---|---|
| **Tor I · II · III** (römisch) | die drei **Abnahmetore des Bauauftrags** — Auftragsreife, technische Lieferabnahme, Produktivfreigabe | Bauauftrag §9 (:631–699) |
| **Tor 1 · 2 · 3 · 4** (arabisch) | die vier **Messstufen dieses Harness** je Scheibe, nach dem Vorbild der Konzept-Fabrik | C-1 (Blatt 26:27) |

Tor 4 dieses Harness ist **nicht** Tor II des Auftrags. Tor II ist der Wechsel nach
`ABNAHME` über alle Meilensteine hinweg; Tor 4 ist die Zeichnung eines Scheibenstandes.

---

## 1 · Rangfolge der Quellen für den Bau

| Rang | Quelle | gewinnt gegen |
|---|---|---|
| **0** | Festlegungen **F01–F40** und gezeichnete Founder-Beschlüsse (`config/kanon.yaml`, `arbeit/Founder_Beschluesse/`) | **alles Weitere.** F28 nimmt K22 aus, F04 nimmt drei Portale aus |
| 1 | `freiraum_datamodel.sql` **plus** Sammelmigration **M30** | Datenmodell-Doku, Handbücher, Prüffälle |
| 2 | `freiraum_datamodel_v2.9.md` | Handbücher, Prüffälle |
| 3 | die beiden Handbücher v2.9 | Prüffälle |
| 4 | `pruefung_v2.9.sql` | — |

Wortgleich aus Bauauftrag :80–86. Das autoritative Zielschema ist eingefrorene Basis + M30
in der Fassung mit der Prüfsumme aus dem gezeichneten N2-Nachweis (:88–90).

**Was gebaut wird**, steht in den **24 gezeichneten Konzepten** K00–K21, K23, K25
(Bauauftrag :42) — als Klauseln `K##-M##` / `-D##` / `-G##`. Gemessen: **1231 Klauseln**
in 24 Dateien unter `03_KONZEPTE_v2.9/concepts-md/`.

**Nicht Gegenstand** (Bauauftrag :614–627): K22 (F28, :618) · `USER_ADMIN`, `VAR_ADMIN`,
`INDIA_OPS` (F04, :616) · ein siebzehnter Agent (K06-D13, K17-M01, :620) · Wahl der
Verarbeitungsregion je Kunde (Nr. 85, :621).

**Steuerung, nicht Abnahme:** Die gezeichnete Anlage *Baustrategie* (4. Fassung, gez.
05.08.2026, BV-22:15 und :29) führt den Scheibenplan. Eine Abweichung von ihr ist ein
**Projektbefund**, nie eine zusätzliche Abnahmebedingung (Blatt 11:182–188).

**Der v2.9-Build ist Spezifikation, nicht Vorbild.** Er wird nie als Codevorlage gelesen
(K23-D02). Zwei Stellen sind benannt falsch: `openApp()` setzt `J.phase = 5` gegen ein
fünfelementiges Feld (W2a), `freigeben()` setzt `J.sealed = false` statt `true` (W2b) —
Bauauftrag :128–136. Wer dort abschreibt, baut das Siegel falsch herum.

---

## 2 · Die vier Messstufen beim Code

Bei Dokumenten misst Tor 1 den Text gegen die Quelle. Bei Code genügt das nicht:
*„Kompilierbarer Code kann fachlich falsch sein"* (Blatt 26:51). Tor 1 ist ein Teil-Orakel.

| Tor | Prüft | Wer | Werkzeug |
|---|---|---|---|
| **1 · mechanisch** | Lint · Shell- und Python-Syntax · Migration gegen eine **frische** Datenbank · zweiter Lauf ändert **Schema und Daten** nicht · Negativfälle scheitern · Geheimnisschranke | CI | `.github/workflows/tore.yml` |
| **2 · blind** | Erfüllt der Stand die **Akzeptanzkriterien** der Klauseln? Prüffälle, geschrieben **ohne den Code gesehen zu haben** | `pruef-agent` | `/scheibe`, `/pruefe` |
| **3 · fremd** | Fachliche Eignung gegen **Roh-Evidenz**, nicht gegen Erklärungen des Baus | Fremdmodell, **frische Instanz je Scheibenabnahme** (C-4, Blatt 26:30) | außerhalb dieses Harness |
| **4 · Mensch** | Wird es getragen? | **Mensch** — die zeichnenden Personen sind offen (V-11) | Zeichnung, nie automatisch |

```
   Klauseln ─┬─▶ Bau-Agent ──▶ Stand ─┐
             │                        ├─▶ Tor 1 ─▶ Tor 2 ─▶ Tor 3 ─▶ Tor 4
             └─▶ Prüf-Agent ─▶ Prüffälle ┘   CI      blind    fremd    Mensch
                  (blind, parallel)
                                        └─ ein Tor, das nicht messen kann,
                                           meldet GESPERRT — nie grün
```

**Die fünfzehn sperrenden Gates aus K23 Abschn. 6 (:239–255) gelten unverändert.** Sie
schlagen an bei Abweichung zur Quelle · fehlendem oder unwirksamem Zeilenschutz · Zugriff
zwischen zwei Mandanten · Umgehung der serverseitigen Schreibbefehle · Selbstfreigabe oder
fehlender Rollentrennung · Verlust einer Änderung oder ihrer Protokollspur · Geheimnissen ·
Einschleusung · fehlgeschlagener Wiederherstellungsprobe · unklarer Herkunft · fehlender
Eigentümer- oder Akzeptanzzuordnung · beschädigter Prüfsummenkette · fehlgeschlagener
Modul- oder Lastprüfung · fehlendem, veraltetem oder nur auf dem Erfolgsweg gelaufenem
Durchstich. Ein Bau mit anschlagendem Gate erreicht die menschliche Freigabe nicht (K23-D01).

**Zur Zeichnungseinheit.** Das Fremdmodell hält fest: gezeichnet wird ein
**Release-Kandidat, nicht jede Änderung** (Blatt 26:52). K23-M20 verlangt vor jeder Vorlage
einen bestandenen Durchstich gegen den **aktuellen** Stand des Bauauftrags, nachgewiesen
über die Prüfsumme im Manifest (K23:75). **Was die zu zeichnende Release-Einheit ist, ist
ausdrücklich offen** (Blatt 26:75) — dieser Harness entscheidet es nicht. Bis zur
Entscheidung legt er je Scheibe ein Paket vor und nennt es *Vorlage*, nicht *Freigabe*.

---

## 3 · Rollentrennung Bau und Prüfung

| | Bau-Agent | Prüf-Agent |
|---|---|---|
| Auftrag | Code gegen die Klauseln | Prüffälle gegen die **Akzeptanzkriterien** |
| Sieht | Klauseln, Code, Schema, Läufe | **nur** Klauseln und Akzeptanzkriterien |
| Sieht nie | die Prüfdateien | **den Umsetzungscode** |
| Werkzeuge | Read, Write, Edit, Bash, Grep, Glob | Read, Write |
| Schreibt nach | `app/ install/ mail/ migrations/ seeds/ schema/ werkzeuge/` sowie die erzeugten Nachweise unter `nachweise/` und die Bauunterlagen unter `arbeit/` | ausschließlich `pruefungen/` |
| Modell | Sitzungsmodell | **anderes Modell** als der Bau (F27, `config/kanon.yaml`:346–359 — **Konzept-Fabrik**, außerhalb dieses Repos) |

**Beide laufen gleichzeitig und ohne einander zu kennen** (C-4, Blatt 26:30). Wer den Code
kennt, schreibt den Prüffall auf den Code — nicht auf die Klausel. Das ist gemessen: Am
02.08.2026 scheiterten **drei von vier** mitgelieferten Negativfällen an einer **anderen**
Bedingung als der geprüften — an einer Formatprüfung des Kundencodes statt an der
Zielbedingung; das Ergebnis war ein bestandener Test, der nichts misst
(`arbeit/Entwürfe/K23_entwurf.md`:297; im Repo dokumentiert in
`migrations/pruefe_negativfaelle.sh`:2–5). **K23-D05** verbietet, einen Prüfwert zu senken,
damit ein Lauf besteht; die Trennung setzt das mechanisch durch.

**Die Pfadgrenzen sind Anweisung, nicht Mechanik.** Das Werkzeugfeld im Frontmatter
beschränkt Werkzeuge, nicht Pfade. Wer die Blindheit mechanisch will, braucht `deny`-Regeln
in `.claude/settings.json`. Diese Datei existiert noch nicht — **offener Punkt**.

**Ein Negativfall gilt erst als bestanden, wenn er an seiner eigenen Bedingung scheitert;
die Fehlermeldung im Wortlaut ist Teil der Evidenz.** Gezeichnete Grundlage: Bauauftrag
§9 Tor I Nr. 6 (:649) und `README.md`:204 des Repos. Als **Klausel** ist die Regel **noch
nicht gefasst** — sie steht als **offener Punkt O-K23-7** (`arbeit/Entwürfe/K23_entwurf.md`:300
— **Konzept-Fabrik**, außerhalb dieses Repos; Entscheider Konzept-Fabrik-Owner · K23) und
**nicht** in der exportierten K23 v1.1.

**Der Orchestrator schreibt zusammen, entscheidet aber nichts fachlich.** Kein Agent
entscheidet „nach eigenem Urteil" (Blatt 11:170). Widerspruch zwischen Quellen: benennen,
in die Restrisikoliste, an die Founder — Antwortzusage Mo–Fr 9–17 Uhr binnen vier Stunden
(G4, Blatt 11:28).

---

## 4 · Die Nachweiskette

Ein Commit beweist weder den Build noch das Deployment; eine Prüfsumme in der Dropbox
beweist nicht, welcher Commit lief (Blatt 26:55). Jedes Manifest nach **K23-M18** (:73)
führt deshalb alle Glieder:

| Glied | Wert | Stand |
|---|---|---|
| 1 | **Commit-Hash** des geprüften Standes | führbar |
| 2 | **Prüfsumme des Bauauftrags** — ohne sie gilt der Durchstich als veraltet (K23-M20) | **belegt seit 07.08.2026:** Fassung v1.1, `3341362f8962af9d48de4afdc863284d5261e9ede3c997fb32bd83933186e43d`, gezeichnet von M. Veil (Nachweis `03_N5_BAUAUFTRAG_v1.1_zeichnung.md`). Die Gegenzeichnung des Auftragnehmers steht aus |
| 3 | **Prüfsumme der Anlage** | **belegt** — gezeichnet am 07.08.2026, nachgerechnet von `./install.sh --pruefsumme` |
| 4 | **Migrationsstand** — welche Dateien, in welcher Reihenfolge, gegen welches Basisschema | führbar |
| 5 | **Abhängigkeitsstände** — Lockfiles, Abbild-Digests, Postgres-Version | führbar |
| 6 | **Modell-, Prompt-, Wissens-, Richtlinien- und Vorlagenstand** (K23-M18 wörtlich) | führbar |
| 7 | **Testwerkzeuge mit Version** · Beginn und Ende · Umgebung | führbar |
| 8 | **Prüfsummen aller Eingaben und Ergebnisse** und eine Prüfsumme über das Manifest selbst | führbar |

Ohne Nr. 8 ist „unveränderlich" eine Behauptung (Bauauftrag :306). Das Manifest ist
maschinenlesbar und liegt unter `nachweise/manifeste/`.

**Vier Nachweise werden ab Scheibe 1 geführt und je Verbreiterung fortgeschrieben**
(Blatt 11:137): Klauselregister (K23-M01/M02) · Herkunftsgraph
`Quelle → Klausel → Umsetzung → Test → Nachweis` (K23-M03) · Restrisikoliste (K23-M04,
K23-D07) · Testmanifest (K23-M18). Sie sind **erzeugte Sichten eines Datenbestands**, keine
dreizehn von Hand gepflegten Wahrheiten (Blatt 26:59–63). Erzeugt von
`werkzeuge/klauselregister.py`; leere Felder werden **ausgewiesen**.

**Genau ein Zustand je Test** (K23-M22, :77): *bestanden · fehlgeschlagen · gesperrt · nicht
ausgeführt.* Was nicht gemessen werden konnte, ist **gesperrt** — nicht bestanden.

---

## 5 · Betriebsregeln

| Regel | Umsetzung |
|---|---|
| **Eine Scheibe oder ein abgegrenzter Change je Arbeitszweig** | Danach `/clear`. `/clear` trägt nur, weil Akzeptanzkriterien, Entscheidungen, Tests und offene Befunde in **Git und Manifest** stehen — nie im Gespräch (Blatt 26:53) |
| **Vertikale Scheiben führen den Bau** (G1, Blatt 11:25) | Scheibe n+1 = Faden von n **plus eine benannte Breite**; bestanden erst, wenn der **ganze** Lauf wieder durchgeht (Blatt 11:40–48) |
| **Eigene Datenbank je Pilot-Anlauf** | `sealed` ist unumkehrbar (K20-M21); nach F36 wird nichts gelöscht (`README.md`:31, `aufbau.sh`:11–14). Die Prüfumgebung aus `aufbau.sh` ist **kein** Pilotlauf |
| **Nur synthetische Daten** | deterministisch erzeugt, je Mandant gekennzeichnet, in abgetrennter Umgebung (K23-M12, :67) |
| **Die vier Negativfälle jeder Migration müssen scheitern** (`README.md`:204) | und zwar je an der eigenen Bedingung, mit Meldung im Wortlaut (Bauauftrag :649) |
| **Keine Zugangsdaten im Repository** (`README.md`:196) | `.env*` gitignored; Zugänge in Key Vault/Passwortmanager. Ein Fund sperrt den Lauf (K23-D09, :92) |
| **Verarbeitung in der EU** (F05) | ein Dienst außerhalb bricht K13 (`README.md`:35) |
| **Stop statt Endlosschleife** | Max. drei Anläufe je Gate, dann Eskalation an die Founder — **übertragen** aus der Konzept-Fabrik (`CLAUDE.md`:179), dort für Tabletop-Runden gesetzt. Für Code **nicht gezeichnet** |
| **Bei Verzug: melden, sobald es sich abzeichnet** | nicht am 31. August. Über Umfang oder Termin entscheidet der Auftraggeber (G2, Blatt 11:26) |

---

## 6 · Was du nie tust

- **Ein Kreuz setzen, für das keine Weisung vorliegt.** Ein Kästchen wird nur gefüllt, wenn
  eine zeichnende Person es angewiesen hat — dann **trägt der Harness es ein**, mit dem
  **Wortlaut der Weisung** und dem Datum unmittelbar daneben. Fehlt die Weisung, bleibt das
  Kästchen leer, auch wenn die Sache offensichtlich scheint.
  *Berichtigt am 16.08.2026. Zuvor stand hier, der Harness dürfe überhaupt kein Kreuz setzen.
  Das verfehlte den Zweck: Wer entscheidet, hat gezeichnet — und ein Blatt mit leeren
  Kästchen, das in Wahrheit entschieden ist, stellt den Stand falsch dar. Was der Harness nie
  darf, ist eine Unterschrift **erfinden**; eine erteilte einzutragen ist Buchführung, keine
  Anmaßung. Der Anlass und die Grenze stehen in
  `nachweise/vorbedingungen/formvermerk_uebertragene_kreuze_260816.md`.*
- **Den Status „Freigegeben", `ABNAHME` oder `IN_PROD` setzen.** Das tut ein Mensch
  (K23-G01 :99, K23-D06 :89). `IN_PROD` verlangt die zweite natürliche Person (K23-M21 :76).
- **Einen Prüfwert senken, eine Schwelle lockern oder eine Kritikalität herabstufen**, damit
  ein Lauf besteht (K23-D05 :88, K23-G08 :106).
- **Als Bau-Agent eine Datei unter `pruefungen/` anfassen.** Auch nicht „nur den Tippfehler".
- **Dem Prüf-Agenten Code zeigen** — weder Datei noch Ausschnitt noch Fehlermeldung daraus.
- **Einen Negativfall als bestanden führen, der an einer fremden Bedingung scheitert.**
- **Einen grünen Lauf melden, der nichts gemessen hat.** Fehlt die Grundlage, ist der Zustand
  *gesperrt* (K23-M22).
- **Aus dem v2.9-Gesamtbuild Code erzeugen** (K23-D02 :85) — siehe W2a/W2b.
- **Gegen Produktionsdaten oder mit produktiven Identitäten prüfen** (K23-M12, K23-D08,
  K23-D10). Ein Lauf, in dem sie aufgetreten sind, wird verworfen und vollständig wiederholt.
- **Geheimnisse, Zugangswerte oder unmaskierte Personenangaben in Manifest, Log, Screenshot
  oder Fehlerausgabe schreiben** (K23-D09).
- **Direkt auf `main` schreiben, einen Zweig ohne Tor 1 zusammenführen oder ein Deployment
  auslösen.** Kein Agent hat Freigabe- oder Deploymentrecht.
- **Eine Fassung bauen, deren Anlagen-Prüfsumme nicht aufgeht.**
- **K22 bauen oder prüfen** (F28) und keine der drei Portale aus F04 anfassen.
- **Umfang erfinden.** Was nicht in den 24 gezeichneten Konzepten steht, wird nicht gebaut,
  sondern als offener Punkt vorgelegt.
- **Eine Datei in der Konzept-Fabrik oder in `v2.9_PIVOT/` verändern.**
- **Eine offene Frage still entscheiden.** Die fünf Fragen des Fremdmodells (Blatt 26:70–79)
  sind vor dem ersten Bauzug zu entscheiden, nicht danach.
