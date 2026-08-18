Alle Läufe sind durch. Hier ist das Ergebnis.

# NACHMESSUNG M4 · Prüf-Agent · 16.08.2026

Zweig `scheibe/m4-zweckbestimmung`, Arbeitsbaum unverändert. Ich habe nichts geändert.

## 1 · Urteil in drei Sätzen

**Von den zwei sperrenden Mängeln ist einer weg und einer nicht.** M1 trägt vollständig und nachweisbar: vor der Nachbesserung brach der Migrationslauf bei Zeile 455 ab und **0 von 111** MT-Fällen trugen ein Ergebnis, jetzt sind es **111 von 111** — das habe ich gegen den alten Stand gegengemessen, nicht geglaubt. M3 dagegen ist nur zur Hälfte behoben: der Faden `zweckbestimmung` steht weiter bei **5 von 26** und der Grund liegt **im Bau, nicht im Prüffall** — ich habe ihn gefunden und belegt.

**Der Stand ist nicht vorlagefähig.** Er hängt an einer einzigen Stelle in `app/vorlagen/en04a_zweckbestimmung.html`, die der Bau bei M3 stehengelassen hat; das kann der Bau in einem Durchgang auflösen. Die drei roten MT-Fälle und vier weitere ZB-Fälle hängen an M5 und gehören den Founder; VP-24 hängt an O-K04-8 und gehört ebenfalls den Founder.

## 2 · Die Zahlen

| Prüfung | Befehl | Vorher | Nachher |
|---|---|---|---|
| Frischer Aufbau | `bash aufbau.sh --ci` | — | RC=0, DDL + M30 + M31 |
| **Voller Lauf** | `pruefungen/lauf.sh` | `bestanden: 11 · fehlgeschlagen: 3 · gesperrt: 2` | **wortgleich** `bestanden: 11 · fehlgeschlagen: 3 · gesperrt: 2`, RC=1 |
| **MT-Fälle mit Ergebnis** | `psql -f pruefungen/migration/M30__pruefung.sql` | **0 von 111** (Abbruch Z. 455) | **111 von 111** · `SUMME: 108 von 111 bestanden, 3 gescheitert` |
| MT-27 / 28 / 29 | ebd. | nicht gemessen | **BESTANDEN**, je an eigener Bedingung (`ack_klasse_ki_nachweis`, `ack_nach_eignung`) |
| MT-30 bis MT-99 | ebd. | nicht gemessen | gemessen |
| MT-95 / 95b / 98 | ebd. | nicht gemessen | gemessen, **GESCHEITERT** |
| zweckbestimmung | ebd. | 3 bestanden · 2 gescheitert · **21 gesperrt** | **5 bestanden · 6 gescheitert · 15 gesperrt** |
| vorpruefung | ebd. | 30 von 32, VP-24 rot | 30 von 32, **VP-24 unverändert rot** |
| anmeldung / einlösung / versand | ebd. | 30/30 · 18/18 · 9/9 | unverändert grün |
| Negativfälle | ebd. | — | **8 von 8**, M31-N1..N4 je an eigener Bedingung |
| `pruefungen/` angefasst? | `git status --short` / `git diff --stat` | — | **kein Unterschied, keine neue Datei** |
| Prüfwert gesenkt? | `git diff -- pruefungen/` | — | **leer** |
| Wiederholbarkeit | M31 zweiter + dritter Lauf, `pg_dump` | — | **Schema identisch · Daten identisch** |
| `ruff check app werkzeuge mail` | — | — | `All checks passed!` |
| `py_compile` · `bash -n` (M31-Skript, `aufbau.sh`) | — | — | RC=0 |

**Zu Punkt 4 und 5 ausdrücklich:** Der Bau hat `pruefungen/` **nicht** angefasst. Kein Prüfwert gesenkt. Geändert sind genau die acht Dateien seines Berichts. Zusätzlich liegt eine unverfolgte Datei `arbeit/Vorlagen/entscheidung_traeger_zweckbestimmung_260816.md` — sie nennt als Verfasser den Orchestrator, nicht den Bau, und ist kein Regelverstoß des Bau-Agenten.

**Zu Punkt 6:** VP-24 ist rot geblieben. `fit_check` trägt jetzt vier Spalten mehr, als Rang 1 kennt (`zweck_bewertung_menschen`, `zweck_verbotene_praktik`, `zweckbestimmung_ack_at`, `zweckbestimmung_erklaert_am`). `schema/freiraum_datamodel.sql` ist unverändert. Der Bau hat Rang 1 also **nicht** angefasst — der Fall bleibt zu Recht rot und die Frage bleibt offen.

## 3 · Was noch rot oder gesperrt ist

**MT-95, MT-95b, MT-98 — Folge von M5.** `create_app_after_fit` besteht nur noch in der Vierwert-Fassung; alle drei rufen die Fünfwert-Fassung. Sie waren vorher **nicht gemessen** (nicht grün), es ist also kein Rückschritt, sondern neu sichtbares Rot. Auflösen können das nur die Founder: entweder die Prüffälle ziehen auf die Vierwert-Fassung nach, oder die Fünfwert-Fassung kommt samt Umgehung zurück.

**ZB-20, ZB-21, ZB-22, ZB-23 — dieselbe Ursache, vom Bau nicht berichtet.** `Nicht messbar: create_app_after_fit besteht nicht in der Gestalt mit fünf Werten (gefunden: p_tenant uuid, p_name text, p_fit_check uuid, p_actor uuid)`. M5 kostet also **sieben** Fälle, nicht drei. Der Bau hat nur MT-95/98 genannt.

**ZB-03b, ZB-05, ZB-06, ZB-07, ZB-08, ZB-09 gescheitert und ZB-10 bis ZB-18 gesperrt — eine einzige Ursache, und sie liegt im Bau.** Siehe Abschnitt 4.

**ZB-25 gesperrt** — `currency = EUR` ist mit den vorhandenen Mitteln nicht messbar; Feststellung des Prüffalls, kein Baumangel.

**VP-08b gesperrt** — Widerspruch K04-M07 gegen Rang 1, braucht eine Menschenentscheidung. Unverändert.

**AC-16, MG-08 gesperrt** — unverändert, nicht Gegenstand von M4.

## 4 · Mangel der Nachbesserung selbst: M3 ist an der entscheidenden Stelle nicht behoben

Der Bau schreibt, der Prüfling sehe die Zustände nicht und er könne ohne den Prüffall nicht sagen, warum — das gehöre an den Prüf-Agenten. **Das ist die falsche Zuordnung.** Ich habe die Ursache gemessen, und sie liegt im Bau.

**Der Befund.** `app/vorlagen/en04a_zweckbestimmung.html` rendert **zwei verborgene Felder mit demselben Namen `frage`** und verschiedenen Werten (`bewertung`, `praktik`) — je Frage eines, Zeile 214. Der Prüffall sammelt die verborgenen Felder der Seite und schickt sie bei jedem POST mit (seine F07-Regel: kein POST darf an einer *fremden* Bedingung scheitern). Bei doppeltem Schlüssel gewinnt der letzte Wert. Der Server nimmt also immer `frage=praktik`, sucht `antwort_praktik`, findet beim Beantworten von Frage 1 nichts — und schreibt nichts.

**Gemessen, nicht hergeleitet.** Aus dem aufbewahrten Arbeitsverzeichnis des Prüflaufs:

```
zb_f1  (Frage 1 = Nein)  -> HTTP/1.1 200 OK      kein Location, nichts geschrieben
zb_f2  (Frage 2 = Nein)  -> HTTP/1.1 303         location: /zweckbestimmung

zb_f0  (0 Antworten)   Ziele: 2x /zweckbestimmung/antwort
zb_f1s (nach Frage 1)  Ziele: 2x /zweckbestimmung/antwort   <-- unverändert, Antwort verloren
zb_f2s (nach Frage 2)  Ziele: 2x antwort + 1x /zweckbestimmung/aendern
```

**Die Folgekette.** Weil nur eine Antwort ankommt, ist das einzige Ziel, das „erst mit beiden Antworten“ erscheint, `/zweckbestimmung/aendern`. Der Prüffall leitet daraus folgerichtig `Ziel Weiter = /zweckbestimmung/aendern` ab und ruft es in allen drei Fahrten auf. `aendern` ist aber der Rücknahmeweg (`app/zweckbestimmung.py:1015`, `SET <spalte> = NULL`). Damit wird auch die letzte Antwort gelöscht, und alle drei Fahrten landen auf derselben leeren Seite:

```
zb_f3s (frei)      2x /zweckbestimmung/antwort · 1x /uebersicht
zb_a3s (Anhang)    2x /zweckbestimmung/antwort · 1x /uebersicht
zb_v3s (Halt)      2x /zweckbestimmung/antwort · 1x /uebersicht   ·  "Art. 5": 0 Treffer
```

Daher `0 Ziele Unterschied`, daher „der Halt verweist nicht auf Artikel 5“, daher „1 Weg statt drei“. **Die Gegenmessung des Bau-Agenten widerlegt das nicht** — er hat die Ziele auf `/zweckbestimmung` selbst gezählt, nicht auf der Seite, zu der der abgeleitete Weiterweg führt. Beide Messungen stimmen; sie messen Verschiedenes.

**Warum das M3 ist und nicht etwas Neues.** M3 hieß „je Frage ein eigener Feldname“. Der Bau hat die **Antwortfelder** getrennt (`antwort_bewertung` / `antwort_praktik`) und den **Unterscheider** `frage` doppelt stehen lassen — genau das, was der eigene Kommentar in der Vorlage als untauglich benennt: *„Zwei getrennte Fragen mit demselben Feldnamen wären von außen nicht auseinanderzuhalten.“* Von außen sind sie es weiterhin nicht.

**Auflösbar vom Bau, ohne auf den Prüffall zu bauen.** Der Bau hat einen Rückfallweg über den Feldnamen bewusst abgelehnt — zu Recht. Er braucht ihn aber gar nicht: es genügt, dem verborgenen Feld **je Frage einen eigenen Namen** zu geben (`frage_bewertung` / `frage_praktik`) und den Handler beide annehmen zu lassen. Das ist der Wortlaut von M3, kein Bau auf den Prüffall, und die Kollision ist weg. Ob die Sammlung verborgener Felder über die ganze Seite hinweg (statt je Formular) beim Prüffall bleiben soll, ist eine getrennte Frage für die Founder — sie ändert an diesem Baumangel nichts.

**Ein Nebenpunkt, der danach neu zu messen ist.** ZB-08 meldet zusätzlich *„es wurde ein Nachweis der Kenntnisnahme geschrieben, obwohl Frage 2 zutrifft“*. In dieser Fahrt entstand eine Ereigniszeile `ZWECKBESTIMMUNG_ZURUECKGENOMMEN` durch den erzwungenen `aendern`-Aufruf. Ob der Prüffall die mitzählt oder ob dort wirklich ein Kenntnisnahme-Nachweis liegt, lässt sich erst nach Behebung der Hauptursache sauber entscheiden.

## 5 · Was der Bericht des Bau-Agenten richtig hatte

Alles Nachprüfbare außer der Zuordnung in Abschnitt 4 hat gehalten: die Wiederholbarkeit von M31 (Schema und Daten nach zweitem und drittem Lauf identisch), die vier Negativfälle je an eigener Bedingung, die Ersetzung von `M31_N4`, `ruff`/`py_compile`/`bash -n`, keine Berührung von `pruefungen/`, kein gesenkter Prüfwert, VP-24 unangetastet rot, und die aufgeräumten Prüfdaten. Die Zahl `108 von 111` und `5 von 26` stimmen auf den Fall genau.