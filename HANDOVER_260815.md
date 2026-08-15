# Übergabe · Sitzung vom 15.08.2026

| | |
|---|---|
| Stand `main` | `af138ab` — **unverändert**, es ist heute nichts zusammengeführt worden |
| Offene Anträge | **#21 · #22 · #23** — alle Tore grün, alle warten auf A. Han |
| Tage bis zum Endtermin | **16** (31.08.2026) |
| Gemessen mit | `./pruefungen/lauf.sh` gegen `freiraum_ci` · `werkzeuge/herkunft.py` · `werkzeuge/wortmarken.py` |

---

## Der Stand in drei Sätzen

**M3 ist gebaut und vollständig gemessen** — der erste Meilenstein, dessen Nachrechnung in
diesem Repo Punkt für Punkt nachgewiesen ist.

**M2 fehlt weiterhin genau ein Lauf**, den keine Maschine fahren kann.

**Nichts davon ist auf `main`.** Drei Anträge warten auf eine Freigabe.

---

## 1 · Tor 3 · der fremde Blick

**Für keine Scheibe angefordert. Zustand: gesperrt.**

`pruefungen/tor3.sh` meldet unverändert: *„Ein fehlendes Fremdreview ist KEIN bestandenes
(K23-M22)."* Es ist bis heute **kein einziges Mal** mit einem gültigen Blatt gelaufen.

**Warum es für M3 nicht anstand.** Tor 3 löst nach der gezeichneten Entscheidung C-4
*„einmal je Scheibenabnahme, nicht je Änderung"* aus — in der CI verdrahtet als
`contains(labels, 'scheibenabnahme')`. M3 wird von **Scheibe 2** geschlossen, zusammen mit
M4; Scheibe 2 ist nicht fertig. Es stand also keine Abnahme an, und Tor 3 meldet in
Antrag #23 folgerichtig `SKIPPED`.

**Was heute daran gebaut wurde** (Antrag #22, noch nicht auf `main`): Der Harness verweigerte
bisher, ohne zu fragen. Jetzt hält `/scheibe` vor der Vorlage an und stellt die Frage
ausdrücklich, und jede Übergabe führt eine feste Zeile aus `fremdreview.py --stand`.

Auslöser ist die **Scheibenabnahme** — Ausnahme **M10, M11, M12**, die keiner Scheibe
angehören und deshalb an der Meilensteinabnahme hängen. Nicht bei jedem Meilenstein:
Scheibe 2 schließt M3 und M4, dreimal dieselbe Frage macht sie billig.

> **Eine Beobachtung in eigener Sache.** Ich habe den Halt heute gebaut — und M3 dann über
> einen Workflow gebaut, der `/scheibe` nicht ausführt. Die Lücke hat also bei meiner
> eigenen Arbeit desselben Tages gewirkt. Sachlich folgenlos, weil keine Abnahme anstand;
> lehrreich trotzdem: **eine Regel, die nur in einem Kommando steht, greift nicht, wenn man
> das Kommando nicht benutzt.** Die feste Zeile in der Übergabe ist deshalb nicht Beiwerk —
> sie ist der Teil, der unabhängig vom Weg wirkt.

---

## 2 · Die Meilensteine, an ihrer Nachrechnung gemessen

### M3 · „Die Vorprüfung hält an" — **eingetreten**

Der Bauauftrag verlangt wörtlich *„ein Lauf, der am Halt endet, und **je einer über alle
drei Auswege**"*.

| Teilaussage | Prüffall | Zustand |
|---|---|---|
| Der Halt | VP-13 | **bestanden** |
| Die Begründung des Halts (K04-M09) | VP-14 | **bestanden** |
| Ausweg 1 · Antwort ändern | VP-17 | **bestanden** |
| Ausweg 2 · Termin | VP-18 | **bestanden** |
| Ausweg 3 · Zur Übersicht | VP-19 | **bestanden** |

Keiner gesperrt, keiner gescheitert. **Antrag #23.**

### M2 · „Ein Eingeladener kann sich anmelden" — **nicht eingetreten**

Drei von vier Teilaussagen bestanden. Die vierte — *„eine echte Zustellung mit abgelesenem
Mailkopf"* — ist **gesperrt**. Zwei Sperren, beide menschlich: das SMTP-Kennwort liegt im
Schlüsselbund auf A. Hans Rechner (*„Ein zweiter Zugriff besteht nicht"*), und der Mailkopf
muss von einem Menschen bei einem fremden Anbieter abgelesen werden — der Prüffall sagt
über sich selbst: *„Dieser Lauf kann nicht selbst in ein fremdes Postfach schauen."*

Anleitung in drei Schritten: `nachweise/vorbedingungen/B2_mailversand/M2_echtlauf_anleitung.md`.

### M1 · „Die Datenbank steht" — **von hier aus nicht bestätigbar**

Die Nachrechnung verweist auf `uebergabe/migration/n2_lauf.sh` — ein Skript, das **nicht in
diesem Repo liegt**. M1 wird gegen die Zielumgebung gemessen. Der Lauf vom 06.08. wurde mit
5 von 5 gemeldet und ist von hier aus weder prüfbar noch bestätigbar.

**Nicht verwechseln:** Die 110 von 110 Migrationsprüffällen dieses Repos sind Tor 1b/1c,
eine andere Prüfung.

### M4 und weiter — **nicht begonnen**

M4 braucht den Zweckbestimmungs-Schritt (EN-04a) und `create_app_after_fit`. Beides ist
bewusst nicht gebaut; nach einem geeigneten Ergebnis steht ein **Hinweis**, keine
Schaltfläche — eine Schaltfläche ins Leere verspricht mehr, als der Bau hält.

---

## 3 · Was heute entstanden ist

| Antrag | Gegenstand | Tore |
|---|---|---|
| **#21** | Klauselschnitt Scheibe 1 · Stichwortverzeichnis, Leseblätter, Zeichnungsblatt | grün |
| **#22** | Der Harness fragt nach dem fremden Blick, statt nur zu verweigern | grün |
| **#23** | **Meilenstein M3** · die Vorprüfung mit Halt und drei Auswegen | grün |

### Der Bau von M3

`app/vorpruefung.py`, drei Bildschirme, ein Startbestand, **32 blind geschriebene
Prüffälle**. Der Weg: Klauselschnitt → Plan → Prüf-Agent blind **vor** der ersten
Codezeile → Bau-Agent → Tor 1 → zwei Gegenproben.

**Der Plan ist der erste Eintrag in `arbeit/Plaene/`** — der Ordner war seit Anlage leer.

### Eine gezeichnete Entscheidung

**BEF-M3-3**: K04-M08 verlangt nach dem Halt den Ausweg *Termin*, K04-D04 verbietet, dass
ein gehaltener Check *„ins Gespräch führt"*. Zwei gezeichnete Klauseln, derselbe Zustand.

**M. Veil hat Lesart A gezeichnet** — *„Gespräch"* meint die geführten Stufen 01/02, nicht
den Anruf. Das Kreuz ist auf Weisung **übertragen, nicht selbsttätig gesetzt** (F40, Muster
BV-22). Damit ist der Befund **entschieden, nicht getragen** — er wird kein kritisches
Restrisiko und braucht keine Annahmeentscheidung.

---

## 4 · Sieben Befunde — fünf wären ohne die blinde Trennung unsichtbar geblieben

`nachweise/befunde/BEF-M3_260815.md`

| | | Stand |
|---|---|---|
| **M3-1** | Der Plan verlangte Platzhalter, wo der Wortlaut längst in Rang 1 stand | erledigt |
| **M3-2** | Dieselbe Antwort zweimal erzeugt keine neue Zeile (K04-M15 wörtlich) | offen, gering |
| **M3-3** | Klauselkonflikt K04-M08 gegen K04-D04 | **entschieden** |
| **M3-4** | Der Halt war im Bildschirm durchgesetzt, nicht im Server | behoben |
| **M3-5** | Zwei `UPDATE` liefen ohne Mandant in der Bedingung | behoben |
| **M3-6** | Vier Prüffälle bestanden, ohne etwas zu messen | behoben |
| **M3-7** | Der Plan sagte nicht, was auf der Halt-Seite stehen bleibt | behoben |

**Zwei ragen heraus.**

**BEF-M3-1 — der Bau hat sich geweigert, dem Plan zu folgen.** Ich hatte Platzhaltertexte
für die drei Eignungsfragen vorgeschrieben. Ihr Wortlaut steht seit jeher im Zielschema,
**Rang 1** der Quellenordnung. Der Bau-Agent hat das gemerkt, den Rang-1-Wortlaut übernommen
und den Widerspruch offengelegt. **Ein Plan ist keine Quelle.**

**BEF-M3-6 — der Fehler vom 02.08. in neuer Gestalt.** Vier Prüffälle prüften *„steht dieser
Text irgendwo auf der Seite"* — an Stellen, wo der Text ohnehin immer steht. Einer schickte
einen deutschen Satz als Antwortkennung und wurde an einer **Formatprüfung** abgewiesen, nicht
an der Zielbedingung. Damals war es der Kundencode, heute die Kennung: derselbe Mechanismus,
dreizehn Tage später.

Alle vier messen jetzt eine **Unterscheidung** statt eines Vorkommens. Und es ist
nachgewiesen, dass sie scheitern können — je Fall wurde eine Bedingung verfälscht, der Fall
lief rot, der Originalzustand wurde wiederhergestellt und mit `git diff` belegt.

**Die Lehre steht im Kopf der Prüfdatei:** *ein Prüffall muss eine Unterscheidung messen,
kein Vorkommen.*

---

## 5 · Zahlen des Tages

| Gemessen | Wert |
|---|---|
| Prüflauf, gesamt | **8 bestanden · 0 fehlgeschlagen · 3 gesperrt** |
| davon der neue Faden `vorpruefung` | **31 von 32 bestanden, 0 gescheitert, 1 gesperrt** |
| Migrationsprüffälle | 110 von 110 |
| Negativfälle | 4 von 4, je an der eigenen Bedingung |
| Regeln im Bestand | 1 231 |
| davon vom Code genannt *(vor M3 gemessen)* | 96 — davon 15 ausdrücklich erklärt |
| davon kritisch ohne Prüffall *(vor M3)* | 22 |
| Bildschirme des Vertrags gebaut | **4 von 33** (EN-01 · EN-02 · EN-03 · EN-04) |
| Klauselregister mit Akzeptanzkriterium | **0 von 1 231** |
| Tor 3 | **nie angefordert** |

**Die drei gesperrten Punkte einzeln** — keiner davon gehört zur Nachrechnung von M3:

- **VP-08b** · K04-M07 nennt drei Antwortwortlaute, die das Zielschema anders führt. Rang 1
  wird nicht geändert; der Fall misst darum nicht den Bau, sondern legt den Widerspruch mit
  dem Befund als Beweis vor. **Nächste Entscheidung für einen Menschen.**
- **AC-16** · echte Zustellung, Altbestand aus M2.
- **MG-08** · *„beim Ablauf verschwindet sie wieder"* ist über keine bekannte Tür prüfbar.

**Kein einziger Fall ist gescheitert.**

---

## 6 · Was nur ein Mensch tun kann — nach Dringlichkeit

| | Was | Warum es klemmt |
|---|---|---|
| **1** | **Die drei Anträge freigeben** — #21, #22, #23 | A. Han. Ohne Freigabe ist nichts von heute auf `main`, auch nicht die Tor-3-Nachfrage |
| **2** | **`AC-16` fahren** — Anleitung liegt vor | schließt M2. Wer Schlüsselbund und ein fremdes Postfach hat, braucht Minuten |
| **3** | **Das Zeichnungsblatt der Scheibe 1 zeichnen** | M. Veil. Ohne gezeichneten Schnitt geht keine Scheibe in den Bau |
| **4** | **VP-08b entscheiden** — K04-M07 gegen Rang 1 | drei Antwortwortlaute weichen ab. Entweder die Klausel nachziehen oder den Befund tragen |
| **5** | **Die beiden Nachträge zur Anlage zeichnen** | liegen seit 14.08. bereit. Bis dahin bindet weder die Sprachregel noch das Fortschrittsverfahren etwas |
| **6** | **Auf die Verzugsmeldung antworten** | seit 14.08. auf `main` |
| **7** | **Akzeptanzkriterien liefern** | 0 von 1 231. Nach K23-M02 ist der Bauauftrag bis dahin unvollständig |
| **8** | **Klarstellender Satz in K04** | Folge der gezeichneten Lesart A. Sache der Konzept-Fabrik, nicht dieses Repos; Wortlautvorschlag liegt im Entscheidungsblatt |

---

## 7 · Fallstricke dieser Sitzung

**Das Kennwort des Prüfstands.** Der erste Prüflauf meldete zehnmal *gesperrt* — ich hatte
`PGPASSWORD=pruefstand` aus der CI-Datei genommen. Der örtliche Prüfstand nutzt `pilot`,
belegt in `README.md:118`. **Die Mechanik hat richtig reagiert:** nicht grün, sondern
gesperrt.

**Ein veralteter Nachweis liest sich wie ein Befund.** Der mitgeführte Herkunftsgraph
stammte vom Zweig vor dem Anmeldecode-Weg und zeigte `K03-M05` als *„gemessen, aber nicht
gebaut"* — obwohl drei Dateien sie umsetzen. **Vor jeder Aussage aus einem erzeugten
Nachweis: neu rechnen.**

**Eine Bereinigung kann selbst einen Rest hinterlassen.** Tor 1a beanstandete zwei tote
Variablen. Ich entfernte `REPO` — und übersah, dass `HIER` nur von `REPO` gebraucht wurde.
Der nächste Lauf fand genau das. Beim dritten Anlauf habe ich **alle** Konstanten
gegengeprüft.

**Eine unvollständige Abschrift trägt weiter.** Meine erste Stationsliste für das
Stichwortverzeichnis hatte 14 Einträge; das Fadendiagramm nennt **22**. Zwei der acht
fehlenden tragen je 40 Regeln.

**Der Faden und die Konzepte sprechen verschiedene Sprachen.** Die Station *Anmeldecode*
traf **null** von 1 231 Regeln — die Konzepte sagen *„E-Mail-Code"* oder *„zweiter Faktor"*.
Mit belegter Gleichsetzung: **0 → 19**. Ob dieselbe Lücke bei anderen Stationen besteht, ist
**nicht geprüft**.

---

## 8 · Womit die nächste Sitzung anfängt

1. **Nachsehen, ob die drei Anträge freigegeben sind.** Ohne sie steht der Tag still.
2. **`AC-16` fahren oder verbindlich verabreden, wer ihn fährt.** M2 hängt an nichts anderem.
3. **M4 nur beginnen, wenn 1 und 2 erledigt sind.** M4 braucht EN-04a und
   `create_app_after_fit`; der Weg dorthin ist mit M3 gebahnt, aber Scheibe 2 wird erst mit
   M4 abnahmefähig — und **erst dann** stellt sich die Frage nach dem fremden Blick.
