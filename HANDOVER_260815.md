# Übergabe · Sitzung vom 15.08.2026

| | |
|---|---|
| Stand `main` | `af138ab` |
| Arbeitszweig | `schnitt/scheibe1` → **Antrag #21**, alle Tore grün, Freigabe steht aus |
| Tage bis zum Endtermin | **16** (31.08.2026) |
| Meilensteine eingetreten | **keiner nachweisbar** — Begründung unten |
| Gemessen mit | `./pruefungen/lauf.sh` gegen `freiraum_ci` · `werkzeuge/herkunft.py` · `werkzeuge/wortmarken.py` |

---

## Der Stand in einem Satz

**M2 fehlt genau ein Lauf, den kein Werkzeug fahren kann; M3 fehlt alles.**

---

## 1 · M2 gemessen — drei von vier

Der Bauauftrag rechnet M2 an vier Sätzen nach. Der Prüflauf vom 15.08. misst sie einzeln:

| Teilaussage der M2-Nachrechnung | Zustand |
|---|---|
| `event` trägt die Anmeldung | **bestanden** |
| Code verfällt nach 10 Minuten | **bestanden** — Fristfenster 600 s, auf die Sekunde |
| Sperre nach fünf Fehlversuchen greift | **bestanden** |
| **eine echte Zustellung mit abgelesenem Mailkopf** | **GESPERRT** |

Der Prüffall `AC-16` benennt seine Lücke selbst:

> *„Teilaussage 1 der M2-Nachrechnung bleibt ohne diesen Lauf nur durch den Einzellauf vom
> 10.08.2026 belegt, nicht durch einen wiederholbaren Prüflauf."*

**M2 ist damit nicht eingetreten.** Nach K23-M22 — der Regel, die je Test genau vier
Zustände zulässt — ist *gesperrt* nicht *bestanden*. Ein Meilenstein tritt ein oder nicht;
einen Zwischenzustand kennt die Nachrechnung nicht, und das ist ihr Zweck.

### Warum der Lauf heute nicht gefahren werden konnte

Zwei Sperren, beide menschlich, beide bewusst so gebaut:

1. **Das SMTP-Kennwort liegt im Schlüsselbund auf A. Hans Rechner.** Der Vermerk vom
   06.08. sagt wörtlich: *„Ein zweiter Zugriff besteht nicht. Der Schlüsselbund teilt
   nichts."* Auf dem Rechner dieser Sitzung sind alle drei Dienstnamen abgefragt worden —
   keiner ist hinterlegt.
2. **Der Mailkopf muss von einem Menschen bei einem fremden Anbieter abgelesen werden.**
   Der Prüffall sagt es selbst: *„Dieser Lauf kann nicht selbst in ein fremdes Postfach
   schauen."* Darin liegt der ganze Beweiswert — ein Nachweis, den die Maschine sich selbst
   ausstellt, ist keiner.

**Vorbereitet:** `nachweise/vorbedingungen/B2_mailversand/M2_echtlauf_anleitung.md`. Drei
Schritte, kein Kennwort im Text. Für den, der Schlüsselbund und Postfach hat, dauert es
Minuten.

**Offener Punkt aus dem Vermerk vom 06.08.:** *„Wer den Versand auslöst, ist nicht
festgelegt"* — Blatt 04 weist BR Andrew die *Messung* des Mailkopfs zu, nicht den Versand.

---

## 2 · M1 — von hier aus nicht bestätigbar

Die Nachrechnung lautet: *„`uebergabe/migration/n2_lauf.sh` läuft durch: leerer Schema-
**und** Datenvergleich, kein gescheiterter Prüffall, T22/T23 ausgeführt, Objektzahlen wie im
Nachweis"*.

**Dieses Skript liegt nicht in diesem Repo.** M1 wird gegen die *Zielumgebung* gemessen —
A. Hans Vorarbeit V0. Der Lauf vom 06.08. wurde mit 5 von 5 gemeldet; von hier aus ist er
weder prüfbar noch bestätigbar.

**Nicht verwechseln:** Was dieses Repo misst, sind **110 von 110 Migrationsprüffällen und
vier von vier Negativfällen** gegen eine frische Datenbank. Das ist Tor 1b/1c des Harness,
eine andere Prüfung. Wer beides gleichsetzt, hält M1 für belegt, weil etwas anderes grün war.

---

## 3 · M3 beginnen — was das konkret heißt

**M3 · „Die Vorprüfung hält an."** Nachrechnung: *ein Lauf, der am Halt endet, und je einer
über alle drei Auswege* — Antwort ändern, Termin, Zur Übersicht (EN-02).

### Der Gegenstand fehlt vollständig

| | |
|---|---|
| K04 · Eignungs-Check, **49 Regeln** | **0 umgesetzt · 0 durch einen bestandenen Test belegt** |
| Bildschirm **EN-02** — in der Nachrechnung namentlich gefordert | **nicht gebaut** |
| Bildschirme insgesamt | **1 von 33** (`EN-01`) |

Es gibt also nichts zu messen. M3 zu „beginnen" heißt: **K04 bauen und mindestens zwei
Bildschirme.**

### Die vier Regeln, an denen M3 hängt — im Wortlaut

> **K04-M08** · MUSS — *„Nach einem Halt MÜSSEN genau drei Auswege erscheinen: Antwort
> ändern, Gespräch mit der Ansprechperson vereinbaren, zur Übersicht zurückkehren."*
>
> **K04-M11** · MUSS — *„Das Ergebnis MUSS in `fit_check.outcome` stehen und einen der Werte
> OFFEN, GEEIGNET, NICHT_GEEIGNET führen. Vorgabe ist OFFEN."*
>
> **K04-D04** · DARF NICHT — *„Ein Check mit NICHT_GEEIGNET DARF NICHT ins Gespräch führen.
> Es entsteht keine Anwendung und keine Angebotsanfrage."*
>
> **K04-M15** · MUSS — *„Eine Antwortänderung MUSS die bisherige Zeile mit `superseded_at`
> zurücknehmen und eine neue anlegen."*

Dazu **K04-D10**, das den zweiten Halt begründet: ein Treffer in der *zweiten* Frage darf
nicht weitergeführt werden — *„dort heilt keine Aufklärung und keine Bestätigung."*

### Der Klauselschnitt für M3 ist ableitbar — anders als bei Scheibe 1

M3 wird von **Scheibe 2** geschlossen, zusammen mit M4. Und für Scheibe 2 trägt die
Vertragskette, weil ihre Zeile einen Meilenstein schließt:

```
Scheibe 2  ──▶  M3 + M4  ──▶  K04 · K01 · K19  ──▶  162 Kandidatenregeln
BS:117          BA:247/248      Spalte "Konzepte"     register.json
```

| Konzept | Regeln | umgesetzt | durch Test belegt |
|---|---|---|---|
| K04 · Eignungs-Check | 49 | 0 | 0 |
| K01 · Rahmenkonzept | 81 | 0 | 3 |
| K19 · Bildschirme | 32 | 0 | 0 |
| | **162** | **0** | **3** |

Das ist der Unterschied zu Scheibe 1, deren Zeile wörtlich sagt *„schließt Meilenstein:
keinen"* und für die die Vertragskette deshalb **nichts** liefert. Für Scheibe 2 gibt es
einen belegten Suchraum von 162 Regeln — er muss nur noch auf die neue Breite geschnitten
werden, und die steht wörtlich in BS:117: *„Vorprüfung komplett: Halt bei NICHT_GEEIGNET,
die drei Auswege, der eine Weg belastbar in Breite."*

**Erster Arbeitsschritt für M3**, wenn Sie beginnen wollen: `werkzeuge/wortmarken.py` um die
Stationen der Scheibe 2 erweitern und den Schnitt daraus vorlegen — dieselbe Mechanik wie
heute für Scheibe 1, aber diesmal mit dem Vertrag als zweitem Bein.

---

## 4 · Was heute entstanden ist

**Antrag #21** — *Der Klauselschnitt für Scheibe 1: Lesematerial und Zeichnungsblatt*.
Alle Tore grün, Freigabe von A. Han steht aus.

| | |
|---|---|
| `werkzeuge/wortmarken.py` | erzeugt das Stichwortverzeichnis zum gezeichneten Faden. **Nennt nirgends eine Scheibe** |
| `S1_zeichnung.md` | das Blatt, auf dem M. Veil zeichnet — leer, kein Haken gesetzt |
| `S1_leseblaetter.md` | 470 Regeln im Wortlaut, in **140 Bündeln** über 22 Stationen |
| `S1_bauspur_nachpruefung.md` | die Nachprüfung der 13 beanspruchten Regeln |
| Herkunftsgraph | auf dem Stand von `main` neu gerechnet |

### Drei Befunde, die Bauarbeit auslösen

1. **`app/haupt.py` beansprucht K03-M05** — *„Der zweite Faktor ist ein sechsstelliger Code
   per E-Mail"* — aber **kein Programmschritt dieser Datei** erzeugt, prüft oder versendet
   einen Code. Nur ein Satz im Vorspann.
2. **Die beste Umsetzung von K20-M08** steht in `app/einladung_senden.py:663` — einer Datei
   **ohne jede `umsetzt:`-Kopfzeile.** Die am besten belegte Umsetzung beansprucht niemand,
   während zwei Dateien sie beanspruchen, die sie nur halb tragen.
3. **`app/einladung.py:51` behauptet**, `haupt.py` führe K03-G01 *„ganz"*. Das trifft nicht
   zu und trägt die Lücke in eine zweite Datei weiter.

Von sechzehn geprüften Ansprüchen sind **sieben ganz gedeckt, acht teilweise, einer gar
nicht.** Keine dieser Lücken ist heute im Dateikopf vermerkt.

### Der Fund, der über den Tag hinausreicht

Die Station **`Anmeldecode`** traf **null** von 1 231 Regeln — ausgerechnet die, an der
gebaut wird. Kein Mangel im Bestand, sondern ein **Wortunterschied**: die Konzepte sagen
*„E-Mail-Code"* oder *„zweiter Faktor"*, nie „Anmeldecode".

Die Gleichsetzung durfte nicht geraten werden — sie steht wörtlich in **K03-M05**: *„Der
zweite Faktor MUSS ein sechsstelliger Code per E-Mail sein."* Mit Beleg erweitert:
**0 → 19 Regeln**, darunter zwei Konzepte, die über den Vertrag für Scheibe 1 gar nicht
erreichbar wären.

**Ein Wortabgleich misst Wörter, nicht Sachen.** Wo Vertrag und Konzept verschiedene Wörter
benutzen, schweigt er. Geprüft ist das für **eine** von 22 Stationen.

---

## 5 · Zahlen des Tages

| Gemessen | Wert |
|---|---|
| Regeln im Bestand | 1 231 |
| davon vom gebauten Code genannt | **96** — davon **15 ausdrücklich erklärt**, 81 beiläufig erwähnt |
| davon ohne Prüffall | 48 |
| davon **kritisch** ohne Prüffall | **22** |
| Regeln mit einem **bestandenen** Test | 43 |
| Bildschirme des Vertrags gebaut | **1 von 33** |
| Klauselregister mit Akzeptanzkriterium | **0 von 1 231** |
| Prüflauf 15.08. | 8 bestanden · 0 fehlgeschlagen · **2 gesperrt** (`AC-16`, `MG-08`) |

---

## 6 · Was nur ein Mensch tun kann — nach Dringlichkeit

| | Was | Warum es klemmt |
|---|---|---|
| **1** | **`AC-16` fahren** — Anleitung liegt vor | schließt M2. Wer Schlüsselbund und ein fremdes Postfach hat, braucht Minuten |
| **2** | **Antrag #21 freigeben** | A. Han. Danach liegt das Zeichnungsblatt auf `main` |
| **3** | **Das Zeichnungsblatt zeichnen** | M. Veil. Ohne gezeichneten Schnitt geht keine Scheibe in den Bau |
| **4** | **Die beiden Nachträge zur Anlage zeichnen** | liegen seit 14.08. in `arbeit/Vorlagen/`. Bis dahin bindet weder die Sprachregel noch das Fortschrittsverfahren etwas |
| **5** | **Auf die Verzugsmeldung antworten** | seit 14.08. auf `main`, die Antwortzusage läuft |
| **6** | **Akzeptanzkriterien liefern** | 0 von 1 231. Nach K23-M02 ist der Bauauftrag bis dahin unvollständig. Der Harness darf sie nicht erfinden — ein erfundenes Kriterium nennt `triage.py` *„den teuersten Fehler dieser Arbeit"* |
| **7** | **Tor 3 einmal anfordern** | nie gelaufen. Der Harness darf das Review nicht selbst anfordern |

---

## 7 · Fallstricke dieser Sitzung

**Das Kennwort des Prüfstands.** Der erste Prüflauf meldete zehnmal GESPERRT — ich hatte
`PGPASSWORD=pruefstand` aus der CI-Datei genommen. Der örtliche Prüfstand nutzt `pilot`, und
das steht in `README.md:118` und `aufbau.sh:74`. **Die Mechanik hat richtig reagiert:** sie
meldete nicht grün, sondern gesperrt — genau wie K23-M22 es verlangt.

**Ein veralteter Nachweis liest sich wie ein Befund.** Der mitgeführte Herkunftsgraph
stammte vom Zweig vor dem Anmeldecode-Weg und zeigte `K03-M05` als *„gemessen, aber nicht
gebaut"*. Ich hielt das für einen Fehler im Werkzeug — es war eine alte Datei. **Vor jeder
Aussage aus einem erzeugten Nachweis: neu rechnen.**

**Eine unvollständige Abschrift trägt weiter.** Meine erste Stationsliste hatte 14 Einträge,
das Fadendiagramm nennt **22**. Zwei der acht fehlenden — *Vorlage* und *Angebot* — tragen je
40 Regeln.

---

## 8 · Womit die nächste Sitzung anfängt

1. **`AC-16` fahren oder verbindlich verabreden, wer ihn fährt.** M2 hängt an nichts
   anderem mehr.
2. **Prüfen, ob die Sprachlücke auch andere Stationen trifft.** Bei *Anmeldecode* waren es
   0 statt 19. Zwei Kandidaten, die auffällig wenig treffen: *Zweckbestimmung* (2) und
   *Einladungsschranke* (4) — beide sind Riegel des Fadens und dürften mehr Regeln haben.
3. **M3 nur beginnen, wenn Punkt 1 erledigt ist.** M3 braucht K04 vollständig plus zwei
   Bildschirme. Wer beides parallel anfängt, hat am 31.08. zwei unfertige Meilensteine
   statt eines fertigen und eines angefangenen.
