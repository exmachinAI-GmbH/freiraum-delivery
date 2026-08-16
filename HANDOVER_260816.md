# Übergabe · Sitzung vom 16.08.2026

> **Für die nächste Sitzung. Wer hier weiterliest, braucht den Gesprächsverlauf nicht.**
>
> Alle Zahlen sind am 16.08.2026 abends selbst gemessen; neben jeder steht der Befehl.
> Was nicht gemessen werden konnte, steht am Ende in einem eigenen Abschnitt.

| | |
|---|---|
| Stand `main` | **`7642f0b`** — **unverändert. Auch am Sitzungsende ist nichts zusammengeführt worden** |
| Arbeitszweig | `scheibe/m4-zweckbestimmung`, Kopf **`afb6759`** (Stand 22:28 Uhr; war `1dd19ef` bei Erstfassung dieser Übergabe) · **25 Änderungsstände** gegen `main` · **80 Dateien, +28 786 / −1 930** |
| Offene Anträge | **#24** REVIEW_REQUIRED · **#25** APPROVED (keins der drei zusammengeführt) · **#26** (M4) REVIEW_REQUIRED, **Tor-1-Prüfung darauf FAILURE** — `gh pr list`/`gh pr view 26` |
| Tage bis zum Endtermin | **15** (31.08.2026) |
| Prüflauf (Sitzungsende, realer CI-Lauf `31970634298`) | Tor 1a **bestanden** · Tor 1b **bestanden** · Tor 1c **fehlgeschlagen** — Sammelzeile `bestanden: 12 · fehlgeschlagen: 1 · gesperrt: 3`, siehe Abschnitt 12 |
| Fremdprüfung | **nie gelaufen** (Tor 3 dieses Laufs: `skipped`) — Etikett existiert, Anforderung liegt fertig, Frist **Montag 17.08.2026** |

---

## Der Stand in drei Sätzen

**Heute war der Tag der Entscheidungen, nicht des Bauens:** rund vierzig Punkte sind
gezeichnet worden, von den zwölf Entscheidungen des Vormittags bis zu den 24 der
Schlussvorlage am Abend.

**Meilenstein M4 ist gebaut** — die Zweckbestimmung, der eine Weg zur Anwendung, der
Bildschirm EN-04a — **aber nicht eingetreten**, und der Antrag dazu liegt bei A. Han.

**Drei Fehler in der eigenen Arbeit des Harness sind gefunden und benannt worden**, zwei davon
von Prüfungen, die er selbst angesetzt hat.

---

## 1 · Was heute entschieden wurde

Vier Wellen, je mit einem eigenen Nachweisblatt unter `arbeit/Vorlagen/`:

| | Was | Blatt |
|---|---|---|
| **Drei Vorlagen** | Träger der Zweckbestimmung (schließt `O-K04-8`) · Fassung der Anlagefunktion · die Steuerungstexte | `zeichnung_vorlagen_260816.md` |
| **B-1 bis B-5** | Starttor-Abnahmen · die Abnahmeeinheit · Fremdprüfung anfordern · Nachweispflicht einengen · Restrisikoliste | `zeichnung_B1-B5_260816.md` |
| **B-6 bis B-21** | sechzehn Punkte, ausgeführt oder zeichnungsfertig vorbereitet | `ENTSCHEIDUNGEN_260816.md` |
| **A. Han** | Anlage „Bauverfahren" gegengezeichnet · Etikett angelegt · Vorlage 1 mitgezeichnet · Nachweis Starttor 11/13 | drei Blätter unter `nachweise/vorbedingungen/` |

### Die zwei mit der größten Wirkung

**Die Anlage „Bauverfahren" ist von beiden Seiten gezeichnet.** Bis heute sagte `CLAUDE.md`
über sich selbst: *„Solange die Anlage nicht gezeichnet ist, ist diese Datei ein Vorschlag."*
**Alle Betriebsregeln des Harness standen auf einer halben Unterschrift** — die
Rollentrennung, die vier Messstufen, die Nachweiskette. Sie sind jetzt getragen. Die
Prüfsumme bleibt gültig, weil der Zeichnungsblock in einer getrennten Datei steht.

**Das Etikett `scheibenabnahme` existiert.** Die dritte Messstufe hängt daran — deshalb sind
alle 29 bisherigen Läufe übersprungen worden, während zwei Steuerungstexte den Fehler beim
Benutzer suchten. **Man konnte es nicht setzen.** Jetzt kann die Fremdprüfung zum ersten Mal
überhaupt auslösen.

---

## 2 · Drei Fehler des Harness, benannt statt geglättet

**Der wichtigste Ertrag des Tages** — alle drei fand eine Prüfung, die der Harness selbst
angesetzt hatte.

### 2.1 · Die Berufung auf F40 trug nicht

Seit dem 15.08. hat der Harness Weisungen in Zeichnungsblätter abgeschrieben und das mit
**F40** begründet. F40 sagt im Wortlaut:

> „Die Zeichnung gehoert dem Menschen und liegt in einer eigenen Datei … **Der Fehler lag …
> darin, dass ein Werkzeug die Unterschrift ueberhaupt erreichen konnte.**"

F40 ist aus einem Schaden entstanden, bei dem ein Werkzeug an eine Unterschrift kam — **das
Gegenteil dessen, wofür sie in Anspruch genommen wurde.** Eine Regel zum Abschreiben einer
Unterschrift gibt es im Kanon nicht (gesucht, kein Treffer).

**Folge:** Alle Blätter vom 15. und 16.08. sind **Nachweise, keine Zeichnungen.** Die
Sachentscheidungen sind davon nicht berührt — die Weisungen stehen im Wortlaut da.

**Die erste Fassung der neuen Regel war zu eng — und der Auftraggeber hat sie berichtigt.**
Sie lautete zunächst, der Harness dürfe überhaupt kein Kreuz setzen. Daraufhin blieben Blätter
leer, die in Wahrheit entschieden waren. Die Klarstellung:

> „Wenn ich etwas entscheide gem. Deinen Empfehlungen, dann ist das gezeichnet! Eine Zeichnung
> ohne Kreuze ist doch wertlos! … Dann trägst du in meinem Auftrag das Kreuz an der richtigen
> Stelle ein."

**Das trifft zu.** Ein Blatt mit leeren Kästchen, das entschieden ist, stellt den Stand falsch
dar — und falsche Darstellung ist genau das, was dieses Projekt sonst bekämpft. Die Regel in
der Verfassung lautet seither:

> **Ein Kästchen wird nur gefüllt, wenn eine zeichnende Person es angewiesen hat — dann trägt
> der Harness es ein**, mit dem Wortlaut der Weisung und dem Datum daneben. Fehlt die Weisung,
> bleibt es leer.

**Was der Harness nie darf, ist eine Unterschrift *erfinden*; eine erteilte einzutragen ist
Buchführung.** Gemessen über fünfzehn Blätter: **88 Kreuze eingetragen, 73 Kästchen bewusst
offen** — Alternativen, die nicht gewählt wurden, Vollzugsspalten für noch nicht geschehene
Handlungen, Träger- und Terminfelder, und alles, was A. Han betrifft, ohne dass seine Weisung
vorliegt.

**Drei Punkte haben die Agenten von sich aus offen gelassen**, weil dort keine Empfehlung
stand: die verklemmte Löschkette, E-6 der Gestaltungsentscheidungen und die Vorfrage zu BA-2.
**Sie haben nicht geraten.**

### 2.2 · Bedingung 6 nennt fünf Starttore, nicht vier

An **drei Stellen** des gezeichneten Auftrags steht „05, 11, 13, **14**, 15". Die Vorlage des
Harness nannte vier und berief sich auf das Korrekturblatt **BA-1** — **das ein Entwurf ist,
ungezeichnet, auf einem Zweig.** Eine Auswahl wurde als gültig behandelt, die erst mit dem
Vollzug gälte.

**Starttor 14 hat keinen Nachweis** und ist als Befund **ST-14** geführt.

### 2.3 · Ein Änderungsstand mit unfertigem Inhalt

In `f8a2311` sind zwei Dateien unfertig hineingeraten, weil `git add -A` benutzt wurde,
während im Hintergrund ein zweiter Durchlauf schrieb. Die Beschreibung erwähnte sie nicht.
**Die Historie wird nicht umgeschrieben** — der Folgestand sagt es und macht sie vollständig.

---

## 3 · Was gebaut wurde

### Meilenstein M4 — gebaut, nicht eingetreten

| | |
|---|---|
| **Die Projektnummer** wird jetzt **vergeben**, nicht entgegengenommen — `K01-M38`: *„Sie wird vergeben, nicht eingegeben"* | belegt: mitgesendet wurde `DE-XXX_999_99`, angelegt wurde `DE-MVR_001_01` |
| **Die fünfte Prüfung** `currency = EUR` ist ergänzt — sie fehlte seit jeher | `K01-M27` verlangt fünf |
| **Die Umgehung ist geschlossen** — die alte Funktionsfassung ist entfernt | sie war für die Portalrolle entrechtet, aber der Eigentümer konnte sie weiter aufrufen |
| **EN-04a** mit allen sechs Aktionen des Bildschirmvertrags | **5 von 33** Bildschirmen gebaut (vorher 4) |

### Ein Werkzeug, das die Steuerungstexte misst

`werkzeuge/fundstellen.py` schlägt jede Datei-Zeile-Angabe nach und prüft drei Dinge: gibt es
die Datei, hat sie so viele Zeilen, steht dort noch, worauf der Text zeigt. **1866
Fundstellen, sechs sperrende Funde.** Als sperrender Schritt in der Prüfstrecke.

**Der Anlass:** An einem Tag fielen vier Steuerungstexte auf, die etwas Falsches behaupteten —
alle vier **zufällig**, beim Danebenlesen. Eine Prüfung fand danach 47 Meldungen, 27 hielten
stand. Die Diagnose: **Behauptungen über Code werden gemessen, Behauptungen über Dokumente
nie.**

### Die Pflegeliste

`nachweise/klauselregister/pflege.json` — sie fehlte seit dem 14.08. und war der Grund, warum
sieben Felder je Registerzeile dauerhaft leer blieben. Das Werkzeug erwartete sie; es gab sie
nur nie. **Das Register läuft seither nicht mehr im Rückfallzweig: 0 Befunde statt 1.**

---

## 4 · Zahlen des Tages

| Gemessen | Wert | Befehl |
|---|---|---|
| Prüflauf gesamt | **11 · 3 · 2** | `bash pruefungen/lauf.sh` |
| Migrationsprüffälle mit Ergebnis | **111 von 111** (morgens: 0) | `psql -f pruefungen/migration/M30__pruefung.sql` |
| davon bestanden | 109 von 111 | ebd. |
| Klauseln im Register | **1231** | `python3 -c "…register.json…"` |
| davon mit Abnahmekriterium | **15** (morgens: 0) | ebd. |
| davon mit Kritikalität | **405** (morgens: 0) | ebd. |
| davon mit **Eigentümer** | **0** | ebd. |
| Restrisiko-Einträge für den Teilschnitt | **113**, alle ohne Träger | `nachweise/restrisiken/restrisiken_teilschnitt.md` |
| Bildschirme gebaut | **5 von 33** | `python3 werkzeuge/herkunft.py` |
| Offene Konzeptpunkte | **79** (geschätzt waren 75), davon **2 mit Frist „vor dem Bau"** | `sichtung_offene_konzeptpunkte_260816.md` |
| Fundstellen geprüft | 1866, **6 sperrende Funde** | `python3 werkzeuge/fundstellen.py` |
| Leere Kästchen in neuen Blättern | **132**, kein gesetztes | Zählung über sieben Blätter |

> **Die Summenzeile des Prüflaufs sieht schlechter aus als gestern und ist besser.** Ein Faden
> ist von *gesperrt* nach *fehlgeschlagen* gewandert: vorher waren dort 23 Fälle nicht
> messbar und **null** gemessen; jetzt sind vier zusätzlich bestanden und einer sagt echt
> „nein". **Ein gemessenes Nein ist mehr wert als ein Nichtmessen.**

---

## 5 · Was jetzt bei einem Menschen liegt

**Die vollständige Liste mit Empfehlung je Punkt:** `arbeit/Vorlagen/ENTSCHEIDUNGEN_260816.md`
— 24 Punkte, alle Empfehlungen am 16.08. angewiesen.

### Die vier, die morgen etwas bewegen

| | Was | Wer |
|---|---|---|
| **1** | **AC-16 fahren** — die echte Zustellung. **Der einzige Punkt, der einen Meilenstein schließt** | A. Han |
| **2** | **Antrag #26 freigeben** — ohne ihn bleibt M4 auf einem Zweig, M5 kann nicht beginnen | A. Han |
| **3** | **Die Fremdprüfung anfordern** — die Anforderung liegt fertig, 45 Roh-Belege, 24 Fragen | A. Han |
| **4** | **Starttor 14** — Nachweis führen und abnehmen | beide |

### Was nur der fachliche Eigentümer liefern kann

**Von 167 Abnahmekriterien liegen 15 vor.** Die übrigen 152 sind aus keiner im Arbeitsstand
liegenden Quelle ableitbar. `K23-M02` sagt wörtlich, wer sie liefert: *„der in derselben
Zeile eingetragene fachliche Eigentümer."*

**Und kein Eigentümer ist eingetragen** — 0 von 1231. Der Harness hat sie nicht geraten;
wo keine benannte Quelle existierte, blieb das Feld leer.

**Das ist die Bedingung, an der das Liefertor scheitern wird, wenn sie offen bleibt.**

---

## 6 · Stolperfallen

- **`main` ist heute nicht bewegt worden.** Dreizehn Änderungsstände liegen auf
  `scheibe/m4-zweckbestimmung`. Wer den Stand sucht, sucht dort.
- **Drei ältere Zeichnungsblätter liegen auf anderen Zweigen** (`nachtraege/korrekturblatt-wega`,
  `offene/entscheidungen-260815`). Der Formvermerk gilt für sie mit, erreicht sie aber nicht.
- **Der Prüfstand nutzt ein anderes Kennwort als die CI-Datei.** Wer das aus der falschen
  Quelle nimmt, bekommt zehnmal *gesperrt* statt eines Ergebnisses.
- **`.claude/settings.json` existiert seit heute** — ob sie wirkt, ist von innen nicht
  feststellbar, weil sie beim Sitzungsstart nicht existierte. Der Nachweis ist in der
  nächsten Sitzung zu führen; bis dahin **gesperrt, nicht bestanden**.
- **Die Rollengrenzen sind nicht mechanisch erzwungen.** Das Einstellungsschema kennt keine
  Spalte für „welcher Agent"; eine Sperre auf den Prüfordner machte den Prüf-Agenten
  arbeitsunfähig. Ein Weg über eine Verbotsliste je Agent ist beschrieben, nicht gebaut.
- **Eine Pfadsperre bindet das genannte Werkzeug, nicht die Kommandozeile.** Beim Bau-Agenten,
  der sie braucht, bleibt jede Pfadgrenze eine Anweisung.
- **Die Anlage Baustrategie hat eine Prüfsumme — aber über einen Stand, der nach der
  Zeichnung geändert wurde.** Die Änderung war gedeckt; nur führt der Zeichnungsblock weiter
  den alten Tag, und **das ursprünglich gezeichnete Exemplar existiert nicht mehr.**

---

## 7 · Zwei Lehren dieses Tages

**Erstens: Eine Prüfung, die den eigenen Bau prüft, muss ihn treffen dürfen.** Dreimal hat
die blinde Trennung heute etwas gefunden, das niemand gesucht hat — einen Bauvorschlag, der
einer Zeichnung widersprach; eine still entschiedene offene Frage; sieben Prüffälle, die nur
deshalb grün waren, weil eine Umgehung offen stand. **Ein Prüffall, der gegen den eigenen Bau
ausschlägt, ist der Nachweis der Blindheit.**

**Zweitens: Ein Lauf, der aufhört zu messen, sieht besser aus als einer, der misst und
scheitert.** Eine neue Bedingung machte einen Prüffall unmöglich; der Lauf brach dort ab, und
**siebzig weitere Fälle wurden nicht mehr gemessen** — darunter die vier, an denen M4 hängt.
Die Summenzeile blieb dabei unverändert grün.

---

## 8 · Womit die nächste Sitzung anfängt

1. **Nachsehen, ob #26 freigegeben ist.** Ohne ihn steht der Tag still.
2. **Nachsehen, ob AC-16 gefahren wurde.** Es ist der einzige Punkt, der einen Meilenstein
   schließt.
3. **Die Fremdprüfung anfordern**, falls nicht geschehen — sie kann ohne jede weitere
   Zeichnung sofort laufen, und ihre Zykluszeit ist unbekannt.
4. **Die Eigentümer der Klauseln klären.** Ohne sie kommt kein Abnahmekriterium zustande, und
   ohne Abnahmekriterien ist Bedingung 4 des Liefertors nicht erfüllbar.

---

## 9 · Was in dieser Übergabe nicht gemessen werden konnte

- **Ob `.claude/settings.json` wirkt.** Sie existierte beim Sitzungsstart nicht.
- **Ob die Verdrahtung zu Starttor 13 erfolgt ist.** Aus dem Repository heraus nicht messbar;
  der Auftragstext sagt *„Verdrahtung offen"*.
- **Ob M1 eingetreten ist.** Die Nachrechnung verweist auf ein Skript außerhalb dieses
  Repositorys.
- **Die Zykluszeit der Fremdprüfung.** Sie ist nie gelaufen.
- **Ob die drei Blätter auf fremden Zweigen noch aktuell sind.** Sie wurden heute nicht
  angefasst.

---

*Abschnitte 1–9 geschrieben am 16.08.2026, 15:32 Uhr, gegen Kopf `1dd19ef`. Alle Zahlen dort
selbst gemessen, je mit dem Befehl daneben. Die Weisungen des Auftraggebers und des
Auftragnehmers stehen in den Nachweisblättern im Wortlaut — der Harness hat kein Kästchen
gesetzt.*

---

# Nachtrag · 15:32 bis 22:28 Uhr — zwölf weitere Änderungsstände

> Diese Übergabe wurde ursprünglich um 15:32 Uhr geschrieben (Kopf `1dd19ef`). Bis Sitzungsende
> sind zwölf weitere Änderungsstände hinzugekommen, Kopf jetzt **`afb6759`**. Was folgt, ist
> **Nachtrag, kein Ersatz** — die Abschnitte 1–9 oben bleiben stehen und unverändert gültig für
> das, was sie beschreiben.

## 10 · Was zwischen 15:32 und 22:28 Uhr entschieden und gebaut wurde

| Zeit | Commit | Was |
|---|---|---|
| 16:05 | `241f73c` | Kreuze eingetragen, Formvermerk zur F40-Berufung berichtigt (vollzieht Abschnitt 2.1 oben) |
| 18:47 | `b215dd7` | Zeichnungsmappe: neun offene Punkte gebündelt — drei ohne Empfehlung, der Harness hat nicht geraten |
| 19:12 | `b116ea3` | A–D umgesetzt: Löschkette (RR-02 mit Vermerk, hebt die Sperre nicht auf) · E-6-Gegenmessung: **0 gestaltete Farb-/Zustandswerte über acht Vorlagen** · Terminfelder · Eigentümerblatt Fassung 2 (157, nicht 167 Klauseln — zehn davon zählten fälschlich mit) |
| 19:37 | `6f282e8` | BA-1 von M. Veil gezeichnet · Klauselregister-Feld „fachlicher Eigentümer": **0 → 157 von 157** des Teilschnitts (154 A. Han, 3 M. Veil) — Bedingung 4 des Liefertors erstmals **erfüllbar**, nicht erfüllt (15 von 157 Abnahmekriterien lagen vor) |
| 19:46 | `c082b15` | Zwei von drei „A. Han"-Zuordnungen aus der Vormappe waren falsch — berichtigt, mit Vermerk, nicht still ersetzt |
| 19:55 | `ee6fa72` | Empfehlungen zu allen offenen Punkten (E-1 bis E-7); zwei Fehldarstellungen in RR-02 gefunden: die Frage war schon am 04.08. entschieden, und der Bau führt Weg A strukturell bereits aus |
| 20:01 | `11b640f` | E-7: Belegzeilen-Korrektur per **Vermerk daneben**, nicht per Dateiänderung — `migrations/M30__pilot_sammelmigration.sql` ist Rang 1, ein Kommentar-Fix hätte die gezeichnete Prüfsumme ungültig gemacht |
| 20:11 | `8dfdda1` | E-4 gebaut: `app/ki_hinweis.py`, der Portal-Hinweis nach Artikel 4 KI-VO, drei Konstanten für die drei Abnahmekriterien aus §7a L9. Kriterium 3 (nachweisbare Kenntnisnahme) **gegen `freiraum_ci` gemessen**, nicht behauptet |
| 21:39 | `73e87e7` | E-6: 142 Kriteriumsvorschläge erzeugt — **62 von 142 (44 %) von der eigens beauftragten Gegenprobe beanstandet** und ersetzt (26 erfunden, 25 zu Unrecht als unableitbar aufgegeben) |
| 21:41 | `ffe7ed8` | Tor-1-Diagnose, drei Befunde mit Gegenprobe: **zwei von drei Erstdiagnosen fielen der eigenen Gegenprobe zum Opfer** — beide hatten ein erfundenes Klauselzitat als Stütze |
| 22:09 | `dfb8bdc` | E-8 vollzogen (NULL/NULL-Riegel in M31 zurückgenommen, nach dessen eigenem 150 Zeilen entfernten Präzedenzfall) — deckt sofort **E-12** auf: MT-95/95b scheiterten seither an einer fremden Bedingung (Projektnummern-Kollision), nicht an dem, was sie messen sollten |
| 22:28 | `afb6759` | Prüf-Auftrag geliefert (E-9-Prüfanteil, E-10, E-12 — Abschnitt 12 unten); E-13 (Anmelde-Riegel) gebaut **und in derselben Sitzung wieder zurückgenommen**, weil er vier fremde Fäden brach; E-14 (VP-24) benannt, nicht behoben |

## 11 · Der teuerste Einzelfund: E-13 — ein Riegel, der vier Fäden brach

Zwischen 20:11 und 22:28 Uhr stand kurzzeitig ein Kästchen `ki_bestaetigt` scharf, das die
Anmeldung sperrte, ohne dass eine Klausel das verlangt (§7a L9 sagt „vor der **ersten**
Nutzung", nicht „vor jeder"). Der blinde Lauf hat gemessen, was das kostet — an Fäden, die mit
dem Portal-Hinweis inhaltlich nichts zu tun haben:

| Faden | ohne Riegel | mit dem Riegel |
|---|---|---|
| `anmeldung` | 30 von 30 | **8 von 30** |
| `vorpruefung` | 30 von 32 | **8 von 32** |
| `anmeldecode` | 16 von 17 | **13 von 17** |

Kein einziger Prüffall kannte das neue Feld. **Zurückgenommen, noch in derselben Sitzung,
bevor der Stand zur Prüfung ging.** Folge: **L9 gilt als gebaut, aber nicht erfüllt** —
Kriterium 3 (nachweisbare Kenntnisnahme) hat vorerst keinen Riegel mehr dahinter, das steht im
Nachweis so, statt das Kriterium fälschlich als bestanden zu führen.

## 12 · Der Prüf-Auftrag — was geliefert wurde, real gegengemessen

Drei Teilaufträge (E-9-Prüfanteil, E-10, E-12) an einen blind geschalteten Agenten auf anderem
Modell (F27), eine Datei zuerst (`pruefungen/klauseln/zweckbestimmung_lauf.sh`), danach
`pruefungen/migration/M30__pruefung.sql`:

1. **Fünf shellcheck-Warnungen behoben.** SC2034 zweimal (Wegwerffeld `t`→`_` in der
   Feld-Zerlegung; ungenutzte Variable `ST_HALB_UI` gestrichen) · SC2221/SC2222 zweimal (Zweig
   `401|403)` stand hinter `2*|4*)` und war damit unerreichbar — davor gezogen). Dabei
   **verschärft, nicht gelockert**: der 401/403-Zweig meldet jetzt `sperr` statt `nok` — nach
   K23-M22 ist eine abgewiesene Sitzung eine fremde Bedingung, kein Urteil über die eigentliche
   Klausel.
2. **Die Singleton-Annahme in ZB-03 ersetzt.** Vorher: „genau ein neu erscheinendes Ziel, sonst
   gesperrt" — eine Annahme ohne Beleg in K19-M06 (regelt das Ausblenden, nicht die Anzahl) oder
   K04-M08 (halt-bezogen). Jetzt: eine Wirkungsmessung — genau eine neue Anwendungszeile, ein
   Eignungs-Check-Verweis darauf, eine Verlaufszeile mit Anlass DISCOVERY. **Selbst gemeldete
   Grenze der eigenen Änderung:** die Messung greift nur, wenn die Erzeugung direkt am
   mehrdeutigen Kandidaten hängt.
3. **`nummernvorrat.PROJ` in der Herrichtung fortgeschrieben.** Die Testdaten trugen
   `DE-DMB_001_01` fest ein, ohne den Zähler zu bewegen; der Serverbefehl zog dieselbe Nummer
   und scheiterte an der Eindeutigkeitsbedingung statt an dem, was er messen sollte — **derselbe
   Fehlertyp wie am 02.08.2026**.

**Gemessen, nicht behauptet — der reale GitHub-Actions-Lauf gegen `afb6759`**
(`gh run view 31970634298`, nicht lokal nachgestellt):

| Tor | Ergebnis |
|---|---|
| 1a · Lint | **bestanden** — 0 shellcheck-Warnungen (war 5) |
| 1b · Migration gegen frische DB | **bestanden** |
| 1c · Prüflauf | **fehlgeschlagen** — Sammelzeile `bestanden: 12 · fehlgeschlagen: 1 · gesperrt: 3`; je Faden: `anmeldung` 30/30 · `einloesung` 18/18 (+ 1 offener Punkt gesperrt: MG-08) · `versand` 9/9 · `anmeldecode` 16/17 · `mitgliedschaft` 8/9 · `vorpruefung` 30/32 (VP-08b gesperrt, **VP-24 echt gescheitert**, Abschnitt 13) · `zweckbestimmung` 8/27 (**19 gesperrt, keiner davon echt gescheitert**) |

**Der Faden `zweckbestimmung` meldet nach dem Prüf-Auftrag GESPERRT statt GESCHEITERT — das ist
der eigentliche Ertrag.** ZB-03 findet real zwei Kandidaten
(`/zweckbestimmung/aendern`, `/zweckbestimmung/anlegen`); die neue Wirkungsmessung lief
tatsächlich gegen beide, keiner erfüllt ihre drei Kriterien. Nach K23-M22 ist das der ehrliche
Zustand: 19 nicht messbare Fälle statt 19 stillschweigend als „geschlossen" behandelte.

**Tor 1 insgesamt bleibt rot.** 1a und 1b sind grün, 1c nicht — wegen VP-24 (echter
Fehlschlag) und der `zweckbestimmung`-Kaskade. Tor 3 lief für diesen Stand nicht (`skipped`);
die Fremdprüfung ist weiterhin nie gefahren worden.

## 13 · VP-24 — der einzige echte Fehlschlag am Sitzungsende

`fit_check` trägt drei zusätzliche Zustandsmerkmale (`zweck_bewertung_menschen`,
`zweck_verbotene_praktik`, `zweckbestimmung_erklaert_am`); K04-M19 zeichnet **zwei** Fragen. Für
das dritte Merkmal (`zweckbestimmung_erklaert_am`) trägt keine Klausel eine Grundlage — M31
begründet die Spalte mit einer Analogie zu `fit_done_needs_ts`, und **eine Analogie ist keine
Klausel** (dritter Fund dieser Art an einem Tag, nach `BEF-K02M17` und den 26 erfundenen
Kriteriumsvorschlägen aus Abschnitt 10 / E-6). Empfehlung: Spalte behalten, Klausel in K04
nachziehen — sie leistet etwas Reales, ist nur (noch) ungedeckt.

## 14 · Was jetzt bei wem liegt — Stand 22:28 Uhr, ergänzt Abschnitt 5

| | Was | Wer | Frist |
|---|---|---|---|
| offen | **#24, #25, #26 zusammenführen** — alle drei laut `gh pr list` weiterhin offen; #25 APPROVED, #24 und #26 REVIEW_REQUIRED; `main` unverändert bei `7642f0b` | A. Han | vor A. Hans Gegenzeichnung von BA-1 (12.4 Nr. 5 sperrt Vorlagen, sobald der Auftrag „in Änderung" gilt) |
| offen | **BA-1 gegenzeichnen** — von M. Veil gezeichnet (Antrag #24), A. Hans Gegenzeichnung steht aus | A. Han | — |
| offen | **Fremdprüfung abschicken** — Anforderung fertig, Tor 3 dieser Sitzung `skipped` | A. Han | **Montag, 17.08.2026** |
| offen | **E-8-Rückfrage** — der zurückgenommene NULL/NULL-Riegel braucht eine Entscheidung, keine automatische Wiederherstellung | M. Veil + A. Han (beide Founder) | — |
| offen | **E-9 Bau-Anteil** — Bildschirmvertrag widersprüchlich (`antwort_aendern`: 3 Felder gegen 1); Eigentümer K19/K04 ist seit heute A. Han | A. Han | — |
| offen | **ZB-03-Mehrdeutigkeit klären** — zwei Wege (`aendern`, `anlegen`) erscheinen am Bildschirm gleichzeitig; ob das gewollt ist, entscheiden die zeichnenden Personen, nicht der Harness | A. Han | — |
| offen | **VP-24** — Klausel für `zweckbestimmung_erklaert_am` nachziehen oder die Spalte anders begründen | Eigentümer K04 (A. Han) | — |
| offen | **142 von 157 Abnahmekriterien des Teilschnitts fehlen weiterhin** — 15 lagen vor, 140 sind jetzt Vorschlag (nicht gezeichnet), 17 ausdrücklich nicht ableitbar | fachliche Eigentümer (A. Han 154 Klauseln, M. Veil 3) | — |

## 15 · Was in diesem Nachtrag nicht gemessen werden konnte

- **Die genaue Grundmenge der Sammelzeile `bestanden: 12 · fehlgeschlagen: 1 · gesperrt: 3`.**
  Wortgleich aus dem CI-Log übernommen (`gh run view 31970634298 --log`), zählt aber sichtbar
  nicht dieselbe Menge wie die Summe der einzelnen Fäden (die liegt weit höher). Ohne Einsicht in
  `pruefungen/lauf.sh` selbst bleibt offen, welche Ebene sie zusammenfasst.
- **Ob AC-16 (die echte Zustellung) inzwischen außerhalb der CI gefahren wurde.** Der CI-Lauf
  zeigt sie GESPERRT, mangels `FREIRAUM_SMTP_*`-Zugangsdaten in der CI-Umgebung — das sagt
  nichts über einen lokalen Einzellauf.
- **Ob #26 vor oder nach BA-1s Gegenzeichnung zusammengeführt werden soll**, wie es die
  Empfehlung aus `6f282e8` vorschlägt. Aus dem Repository-Stand allein nicht ablesbar.

---

*Nachtrag geschrieben am 16.08.2026 gegen Kopf `afb6759` (22:28 Uhr). Zahlen zu Tor 1a–1c aus
dem realen GitHub-Actions-Lauf `31970634298` (`gh run view 31970634298`), PR-Status aus
`gh pr list`/`gh pr view` — beides gegengeprüft, nicht aus den Commit-Nachrichten übernommen,
die als Ausgangsthese behandelt wurden. Was diese Übergabe nicht selbst gemessen hat, steht in
Abschnitt 15.*
