# freiraum-delivery

**Was das hier ist:** die Baustelle der FREIRAUM-Software
(`github.com/exmachinAI-GmbH/freiraum-delivery`). Hier liegt der Programmcode, die
Prüfstrecke, die ihn misst, und die Nachweise darüber, dass gemessen wurde. Was gebaut
werden soll, steht nicht hier, sondern in den 24 gezeichneten Konzepten der Konzept-Fabrik.
Dieses Repository baut nur — es entscheidet nichts.

**Wenn Sie nicht programmieren:** Sie brauchen die Abschnitte 1, 5, 6, 7, **8** und **9**.
Abschnitt 8 sagt, was eine Meldung bedeutet, die Sie nicht einordnen können — insbesondere,
dass **GESPERRT** kein Fehler ist und nicht dasselbe wie *bestanden*. Abschnitt 9 zeigt
Schritt für Schritt, wie Sie den Harness im Browser bedienen. Abschnitt 4 erklärt nebenbei
die Wörter Mandant, Prüffall und Negativfall; überfliegen Sie ihn einmal. Die Abschnitte 2
und 3 richten sich an die Person, die den Code auf ihrem Rechner laufen lassen will.

> **Wie hier geschrieben wird:** Jeder neue Text in diesem Repository — Commit-Nachricht,
> Issue, Pull Request, Projekttafel, Agentenbeschreibung — muss ohne IT-Vorkenntnisse
> verständlich sein. Die verbindliche Vorgabe steht in **[CONTRIBUTING.md](CONTRIBUTING.md)**.

---

## 1 · Wie hier entschieden wird

Kein Programm und kein Agent gibt hier etwas frei. Eine Änderung nimmt immer denselben Weg:

```
Nebenspur anlegen  →  bauen  →  automatische Prüfung (Tor 1)  →  Antrag stellen (Pull Request)
                                                                          ↓
                                    Hauptspur "main"  ←  ein Mensch gibt frei
```

- **„Nebenspur"** heißt im Fachwort *Branch*: eine Arbeitskopie, in der man ändern kann,
  ohne den gültigen Stand anzufassen.
- **„Antrag"** heißt *Pull Request*: die Bitte, die Nebenspur in den gültigen Stand zu
  übernehmen. Das ist die Stelle, an der ein Mensch liest und zustimmt.
- **Direkt in die Hauptspur schreiben kann niemand** — auch die Administratorin nicht. Diese
  Sperre ist seit dem 09.08.2026 wirksam und wurde durch einen abgewiesenen Versuch belegt,
  nicht durch das Zitieren einer Einstellung.
- Ein Antrag braucht die Zustimmung einer **anderen** Person als der, die ihn gestellt hat.

**Zusammengeführt ist nicht abgenommen.** Nach der automatischen Prüfung (Tor 1) folgen noch
drei Stufen: **Tor 2** — Prüffälle, geschrieben, ohne den Code zu kennen; **Tor 3** — eine
KI eines *anderen* Anbieters prüft gegen die Rohbelege; **Tor 4** — ein Mensch zeichnet. Was
dieses Repository je Scheibe abliefert, ist eine **Vorlage**, keine Freigabe (`CLAUDE.md`,
Abschnitt 2).

**Wie Sie das im Browser bedienen, steht in Abschnitt 9.** Alle Fachwörter stehen erklärt im
Glossar in [CONTRIBUTING.md, Abschnitt 6](CONTRIBUTING.md#6--glossar).

---

## 2 · Anfangen

**Sie brauchen drei Dinge auf dem Rechner:**

| | Wofür |
|---|---|
| **Docker** | lässt die Datenbank in einem abgeschlossenen Behälter laufen, ohne den Rechner zu verändern |
| **Python 3.11** | die Sprache, in der die Werkzeuge dieses Repositorys geschrieben sind |
| **`psql`** — ein Postgres-Client | das Kommandozeilenwerkzeug, mit dem die Prüfläufe die Datenbank ansprechen |

**`psql` ist nicht optional.** Fehlt es, meldet `pruefungen/lauf.sh` in der ersten Zeile
`psql ist nicht im PATH — dieser Lauf misst NICHTS`, nennt die Abhilfe und setzt **jeden**
Prüfschritt auf **GESPERRT**. Gesperrt heißt *nicht gemessen* — nicht *bestanden*. Bis zum
10.08.2026 brach der Lauf an dieser Stelle nach der Kopfzeile wortlos ab; festgehalten als
Befund BEF-D3 in `nachweise/befunde/BEF-D_260809.md`.

Die folgenden Zeilen werden im **Terminal** eingegeben, eine nach der anderen. Docker und
Python 3.11 werden vorher einmal von Hand installiert.

```bash
brew install libpq && brew link --force libpq     # macOS; unter Linux: postgresql-client
git clone https://github.com/exmachinAI-GmbH/freiraum-delivery.git && cd freiraum-delivery
python3 -m venv .venv && .venv/bin/pip install -r requirements.txt
./install.sh           # Einrichtung: Ordner, Agenten, Commit-Vorlage, Prüfsumme
./aufbau.sh            # Prüfumgebung aufbauen (siehe nächster Abschnitt)
```

**Für Bauen und Messen ist mehr nicht nötig.** Seit dem 09.08.2026 bringt das Repository
alle Bau-Eingaben selbst mit — kein Pfad in eine Dropbox, keiner auf einen bestimmten
Rechner.

**Was Sie bei `./install.sh` sehen können:**
`Anlage 'Bauverfahren' nicht gefunden … Zustand: gesperrt (K23-M22)`. Das ist kein Fehler
der Einrichtung und kein Abbruch — die Einrichtung läuft zu Ende. Die gezeichnete Anlage
liegt bewusst außerhalb dieses Repositorys (Abschnitt 6). Wer sie hat, nennt ihren Ort
einmalig:

```bash
export FREIRAUM_ANLAGE=/pfad/zu/Anlage_Bauverfahren.md
```

Wer sie nicht hat, kann bauen und messen; nur die Bau-Kommandos melden dann *Verfassung
nicht belegt* (Abschnitt 8).

---

## 3 · Zwei Datenbanken, und sie sind nicht dasselbe

Der häufigste Anfängerfehler ist, die beiden zu verwechseln. Sie werden aus verschiedenen
Teilen gebaut und antworten deshalb verschieden.

| | Name · Anschluss | gebaut aus | wofür |
|---|---|---|---|
| **Prüfumgebung** | `freiraum` · Port 55432 | Bauplan + Vorläufer 260801 + M30 + M31 + M32 + Startdaten + B1 | entwickeln, die Vorbedingungen B1/B2 nachvollziehen |
| **Tor 1b** | `freiraum_ci` · Port 55433 | Bauplan + alle Dateien aus `migrations/` — **ohne** Vorläufer, **ohne** Startdaten | denselben Lauf fahren, den GitHub automatisch fährt |

Kurz übersetzt: **Bauplan** ist die Datei `schema/freiraum_datamodel.sql`, die festlegt,
welche Tabellen und Felder es gibt. **M30** ist die Sammelmigration — ein gebündelter
Änderungsschritt an diesem Bauplan. **Startdaten** (*Seed*) sind Beispieldaten, mit denen
eine leere Datenbank gefüllt wird. **B1** ist der Betreiber-Mandant — der erste Kunde im
System samt Erst-Admin; **B2** ist die Anbindung des Mailversands. Beide sind Vorbedingungen,
die vor dem ersten Pilotlauf stehen müssen. **Tor 1b** ist der automatische Prüfschritt, der
die Änderungsschritte gegen eine frische, leere Datenbank laufen lässt.

```bash
./aufbau.sh --ci
PGHOST=localhost PGPORT=55433 PGUSER=postgres PGDATABASE=freiraum_ci PGPASSWORD=pilot \
  bash pruefungen/lauf.sh
```

Dieselbe Zeile druckt `./aufbau.sh --ci` am Ende selbst — im Zweifel die aus der Ausgabe
nehmen. Ohne `PGPASSWORD` fragt `psql` nach einem Passwort, und der Lauf meldet **GESPERRT**,
ohne etwas gemessen zu haben.

**Warum getrennt:** Der Vorläufer 260801 führt eine Pflichtprüfung auf einen
Auftragsverarbeitungsvertrag ein (`customer_needs_avv`). Die Prüffälle zu M30 legen aber
absichtlich einen Kunden **ohne** solchen Vertrag an und werden dagegen abgewiesen. Gegen
Bauplan + M30 laufen sie **110 von 110** durch.

Bis zum 09.08.2026 wurde `freiraum_ci` nur von GitHub gebaut. Tor 1b war auf dem eigenen
Rechner nicht nachvollziehbar — festgehalten als BEF-D4 in
`nachweise/befunde/BEF-D_260809.md`.

---

## 4 · Was wo liegt

| Ordner | Inhalt |
|---|---|
| `app/` | die Anwendung selbst — die Seiten, die eine Person im Browser sieht, und der Code dahinter |
| `.github/` | die Beschreibung der automatischen Prüfung (Tor 1), die GitHub bei jedem Antrag fährt, dazu die Vorlagen für Issues und Anträge |
| `install/` | **B1** — der Betreiber-Mandant: der erste Kunde im System, der Erst-Admin `EXMA-ADM-0001` und seine Mitgliedschaft |
| `mail/` | **B2** — die Anbindung des Mailversands und der Nachweis, dass der Versanddienst eine Mail **übernommen** hat. Nicht, dass sie im Postfach ankam: dafür fehlt der Rückkanal des Anbieters (`nachweise/vorbedingungen/B2_mailversand/B2_Abnahmeprotokoll.md`, Nr. 6). Der Beleg für die Verarbeitung in der EU (Festlegung F05) ist **offen** (ebd. Nr. 7) |
| `schema/` | der eingefrorene Bauplan der Datenbank (Fassung v2.9), als Kopie mit Prüfsumme |
| `migrations/` | die Änderungsschritte an der Datenbank: `M30__pilot_sammelmigration.sql` · `_vorlaeufer/` (was davor lief) · `_abgeloest/` (was ersetzt wurde) · `negativfaelle/` |
| `seeds/` | die Startdaten der ersten Welle, als Kopie mit Prüfsumme |
| `pruefungen/` | die Prüffälle — **hier schreibt ausschließlich der Prüf-Agent** |
| `werkzeuge/` | Hilfsprogramme, z. B. `klauselregister.py` |
| `nachweise/` | die Belege: Klauselregister · Manifeste · Restrisiken · Herkunft · Rollen · Vorbedingungen **B1** (Betreiber-Mandant), **B2** (Mailversand) und **B3** (Testdomäne) · Befunde · Pilot-Anläufe |
| `doku/` | Grundlagen, die nicht hier entstanden sind |
| `arbeit/` | Zwischenstände, Pläne und Vorlagen — nichts davon ist ein Nachweis |

**„Mandant"** heißt: ein Kunde als abgetrennter Datenbereich. Kein Mandant darf Daten eines
anderen sehen. **„Prüffall"** ist ein Testfall, der eine einzelne Anforderung misst.
**„Negativfall"** ist ein Testfall, der **scheitern muss** — besteht er, ist die Sperre, die
er prüfen sollte, nicht wirksam.

### Drei Ordner sind Kopien, keine Originale

`schema/`, `migrations/_vorlaeufer/` und `seeds/` enthalten Kopien von Dateien, die
anderswo entstanden sind. Jede trägt ihre Prüfsumme vom Tag der Aufnahme und einen Vermerk,
woher sie stammt; `aufbau.sh` rechnet sie vor jedem Lauf nach.

**Änderungsregel: keine.** Weicht eine Kopie ab, ist die Kopie ungültig — nicht das
Original. Eine Prüfsumme ist eine Kennzahl aus dem Dateiinhalt: ändert sich der Inhalt,
ändert sie sich mit. So fällt eine stille Abweichung auf.

---

## 5 · Woran man sich hält

| | |
|---|---|
| Konzeptlage | Konzept-Fabrik ITERATION_2, 24 exportierte Konzepte in der Fassung v2.9 — **dort wird nichts mehr verändert** |
| Was im Streitfall gilt | `schema/freiraum_datamodel.sql` **plus** `migrations/M30__pilot_sammelmigration.sql`. Diese beiden gewinnen jeden Widerspruch. Kein Konzept, kein Handbuch und kein Agent beschließt eine Datenbankspalte |
| Wo die Belege liegen | **hier**, unter `nachweise/` |
| Die gezeichnete Verfassung | die Anlage „Bauverfahren" — sie liegt **bewusst außerhalb dieses Repositorys**, siehe Abschnitt 6 |

**GitHub ist die Wahrheit.** Kein Klon in Dropbox oder iCloud. Was dort liegt, altert
unbemerkt.

---

## 6 · Warum zwei Dinge außerhalb liegen

| | Warum |
|---|---|
| **Anlage „Bauverfahren"** und ihre Zeichnung | `CLAUDE.md` ist die Datei in diesem Repository, die die unterschriebene Anlage in ausführbare Arbeitsanweisungen übersetzt. Der Befehl `./install.sh --pruefsumme` rechnet ihren Kopf **gegen** die Anlage. Lägen beide hier, änderte ein einziger Commit beide Seiten — und die Prüfung ginge immer auf, ohne etwas zu prüfen. Ihr Wert besteht gerade darin, dass die beiden Seiten in verschiedenen Vertrauensbereichen liegen |
| **Zugangsblatt** (Namen, Adressen) | Git vergisst nicht. Wer eine Personenangabe später schwärzt, hat sie trotzdem für immer in der Änderungsgeschichte und in jedem Klon stehen. Was zum **Arbeiten** nötig ist, steht ohne Personenbezug in `nachweise/rollen.md` |

---

## 7 · Eiserne Regeln

1. **Keine Zugangsdaten im Repository.** Dateien, die mit `.env` beginnen, sind
   ausgeschlossen; Zugänge gehören in den Key Vault oder den Passwortmanager. Ein Fund
   sperrt den Lauf.
2. **Eine eigene Datenbank je Pilot-Anlauf.** Ein versiegelter Datensatz (`sealed`) lässt
   sich nicht wieder öffnen — das ist so gewollt und in K20-M21 festgelegt.
3. **Nur erfundene Daten** in Entwicklung und Abnahme. Kein Echtbetrieb, solange der
   zeilengenaue Zugriffsschutz fehlt: der Bauplan v2.9 hat noch keine Regeln, die Zeile für
   Zeile entscheiden, wer sie sehen darf.
4. **Die vier Negativfälle jeder Migration müssen scheitern**, bevor sie als angewendet
   gilt — und zwar jeder an seiner **eigenen** Bedingung. Ein Testfall, der aus einem
   anderen Grund scheitert, hat nichts gemessen.
5. **Verarbeitung in der EU** (Festlegung F05). Ein Dienst außerhalb bricht das Konzept K13
   zum Datenschutz.

---

## 8 · Wenn etwas nicht geht

| Was Sie sehen | Was das heißt | Was zu tun ist |
|---|---|---|
| Der Lauf meldet `psql ist nicht im PATH — dieser Lauf misst NICHTS` und danach ist **jeder** Schritt GESPERRT | das Datenbankwerkzeug fehlt, es wurde **nichts** gemessen | `psql --version` eingeben. Kommt keine Antwort, die erste Zeile aus Abschnitt 2 nachholen, dann den Lauf wiederholen |
| Ein **einzelner** Prüfschritt meldet **GESPERRT** | dieser Schritt konnte nicht messen | Das ist die richtige Meldung und kein Fehler. Gesperrt heißt **nicht** bestanden. Sind **alle** Schritte gesperrt, siehe die Zeile darüber |
| `Datenbank nicht erreichbar — GESPERRT` | die Datenbank läuft nicht, oder die Passwortangabe fehlt | `./aufbau.sh --ci` ausführen und die Aufrufzeile aus der Ausgabe übernehmen (Abschnitt 3) |
| Prüfsumme **weicht ab** (die Meldung zeigt zwei verschiedene Werte) | der ausgeführte Text redet über eine andere Fassung als der gezeichnete | **Nicht weiterbauen — nachfragen** |
| „Verfassung nicht belegt" **oder** „Anlage 'Bauverfahren' nicht gefunden" | die gezeichnete Anlage liegt nicht auf diesem Rechner | Außerhalb des Founder-Rechners der Normalfall und kein Fehler. Sie können bauen und prüfen; jeder Lauf trägt dann den Vermerk *Verfassung nicht belegt* |
| Eine Prüfsumme einer mitgelieferten Kopie weicht ab | die Kopie stimmt nicht mehr mit ihrem Original überein | Die Kopie ist ungültig, nicht das Original. Als Befund melden, nicht überschreiben |
| Der Antrag lässt sich nicht zusammenführen | die Freigabe fehlt oder wurde verworfen | Jeder weitere Commit **nach** einer Freigabe verwirft sie. Erst fertig bauen, dann um Freigabe bitten |

Für alles andere: einen Punkt anlegen — wie, steht in Abschnitt 9.

---

## 9 · So steuern Sie den Harness im Browser

Für diese vier Handgriffe brauchen Sie kein Terminal und keinen Klon. Sie brauchen ein
GitHub-Konto mit Zugang zu `github.com/exmachinAI-GmbH/freiraum-delivery`.

### Eine Freigabe erteilen

1. Das Repository öffnen und oben den Reiter **Pull requests** anklicken.
2. Den Antrag anklicken und die **Beschreibung** lesen. Nach dieser Vorgabe muss sie allein
   tragen — der Reiter *Files changed* ist freiwillig.
3. Rechts oben **Review changes**, dann **Approve**, dann **Submit review**.

**Wenn es gut geht:** Am Antrag steht *1 approval* und ein grüner Haken.
**Wenn nicht:** Fehlt der Knopf oder erscheint eine rote Meldung, nicht weiterklicken,
sondern zurückfragen. Ein roter Haken bei den Prüfungen heißt: Tor 1 ist nicht durch, der
Antrag ist noch nicht entscheidungsreif.

### Das Ergebnis der automatischen Prüfung ansehen

Reiter **Actions**. Grüner Haken heißt bestanden, rotes Kreuz heißt fehlgeschlagen. Ein
Klick auf den Lauf zeigt, welcher der vier Schritte (Tor 1a, 1b, 1c, Sperre) angeschlagen
hat.

### Einen Punkt anlegen

1. Reiter **Issues**, dann **New issue**.
2. Vorlage wählen: **Befund melden**, wenn etwas nicht stimmt — **Aufgabe**, wenn etwas
   entstehen soll.
3. Die vorausgefüllten Abschnitte überschreiben, dann **Submit new issue**.

Punkte ohne Vorlage sind bewusst abgeschaltet: ein Punkt ohne Anlass, ohne Nachstellweg und
ohne Fertigkriterium kostet später mehr Zeit, als die Vorlage jetzt kostet.

### Nachsehen, was gemessen wurde

Im Ordner `nachweise/manifeste/` liegt je Lauf ein Protokoll. Es führt je Prüfschritt genau
einen von vier Zuständen: **bestanden · fehlgeschlagen · gesperrt · nicht ausgeführt**.
*Gesperrt* heißt: konnte nicht gemessen werden. Es ist **kein** bestanden.
