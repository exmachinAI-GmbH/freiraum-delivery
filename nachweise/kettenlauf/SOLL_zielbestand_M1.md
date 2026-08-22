# Soll · Was „Zielbestand" in M1 bedeutet

**Angelegt am 22.08.2026**, weil das Fremdurteil zu Recht bemängelt hat, dass die Belege
sagen, **wo** gemessen wurde — aber nicht, **wogegen**. Ein Istwert ohne Sollwert ist eine
Ablesung, keine Prüfung.

Dieses Blatt ist die fehlende Sollseite. Es stellt nichts fest und nimmt nichts ab.

---

## 1 · Der Wortlaut, um den es geht

Meilenstein **M1** des Bauauftrags §6a:

> „Die Datenbank steht — **Sammelmigration im Zielbestand**, zweiter Lauf ändert nichts."

Drei Begriffe darin sind auslegungsbedürftig: *Datenbank*, *Zielbestand*, *zweiter Lauf*.

---

## 2 · Die Umgebung

| Feld | Soll | Herkunft |
|---|---|---|
| Server | `psql-freiraum-pilot.postgres.database.azure.com` | die Pilotumgebung, benannt im gezeichneten Nachweis vom 06.08.2026 |
| Region | Sweden Central | ebenda |
| Hauptversion | PostgreSQL **16** | ebenda |
| Datenbank | `freiraum` | der Name, unter dem die Anwendung sie erreicht |
| Konto | `frxadmin` — **kein SUPERUSER** | `ABNAHMENACHWEIS_ENTWURF.md`:6 vom 06.08.2026 |
| Verschlüsselung | `sslmode=require` | `require_secure_transport = on` am Server, gemessen 22.08.2026 |

**Warum das Konto zum Soll gehört:** Ein Lauf mit allen Datenbankrechten misst etwas anderes
als der Betrieb. `M30`:2029–2031 hält den Fall aktenkundig fest — die Läufe vom 05.08.2026
liefen als SUPERUSER, und *„eine Migration, die auf der Prüfdatenbank durchläuft, läuft nicht
deshalb auch im Ziel."* Ein Abnahmelauf ohne diese Einschränkung ist nicht abnahmefähig.

---

## 3 · Der Ausgangszustand

**Soll: eine frische Datenbank.** Kein Grundschema, keine Migration, keine Zeile.

Der Grund ist nicht Ordnungsliebe. M1 verlangt **beide** Hälften: dass der erste Lauf etwas
verändert *und* dass der zweite nichts mehr verändert. Läuft der erste Lauf gegen eine bereits
aufgebaute Datenbank, ist er kein erster Lauf, und die erste Hälfte bleibt ungemessen —
gemessen wäre dann nur, dass der dritte Lauf dem vierten gleicht.

`migrations/kettenlauf.sh` erzwingt das seit dem 22.08.2026: Findet er eine der zu fahrenden
Migrationen bereits vor, bricht er ab.

> **Nicht Teil des Solls:** ein produktionsähnlicher Bestand. M1 ist der **Aufbau** der
> Datenbank, nicht die Migration vorhandener Daten. Eine Bestandsmigration ist ein anderer
> Vorgang und gehört nicht zu diesem Meilenstein.

---

## 4 · Was eingespielt wird, und in welcher Reihenfolge

Seit der Zeichnung vom 22.08.2026 (Punkt 10.3) umfasst **Rang 1** das eingefrorene Datenmodell
plus **M30, M31 und M32**. Daraus folgt für M1 die Lesart **B**.

| # | Datei | Rolle |
|---|---|---|
| 0 | `schema/freiraum_datamodel.sql` | das eingefrorene Grundschema v2.9 |
| 1 | `migrations/M30__pilot_sammelmigration.sql` | die Sammelmigration |
| 2 | `migrations/M31__projektnummer_und_zweckbestimmung.sql` | Projektnummer wird vergeben statt eingegeben (K01-M38) |
| 3 | `migrations/M32__zeilenschutz_und_stufenwechsel.sql` | Zeilenschutz, Durchsetzung ausgeschaltet |

**Das Grundschema wird einmal eingespielt, die Migrationskette zweimal.**

Das ist keine Nachlässigkeit, sondern die Sache selbst: Das Grundschema ist keine Migration,
sondern der Boden, auf dem sie laufen. Was M1 auf Idempotenz prüft, ist die **Kette
M30 → M31 → M32** — und die wird als Ganzes zweimal gefahren, nicht jede Datei einzeln
hintereinander zweimal. Der zweite Durchgang beginnt erst, wenn der erste vollständig durch ist.

> *Berichtigt am 22.08.2026.* Zuvor stand hier, „die Kette" werde als Ganzes zweimal gefahren,
> ohne das Grundschema auszunehmen. Das Fremdurteil hat den Widerspruch zum Belegblatt
> („Grundschema eingespielt", „3 Migration(en) je zweimal") zu Recht benannt. Der Lauf war
> richtig, der Solltext war es nicht.

**Nicht eingespielt:** `migrations/_vorlaeufer/`, `migrations/_abgeloest/`,
`migrations/uebernahme/`. Der Vorläufer `260801_tenant.sql` ist im Prüfaufbau die Voraussetzung
von M30; im Zielbestand bringt M30 seinen Inhalt selbst mit — so hielt es auch der gezeichnete
Lauf `n2_lauf.sh`.

---

## 5 · Die Sollwerte der Objektzahlen

`config/kanon.yaml` der Konzept-Fabrik führt unter `bestand_pilot` die gemessenen Objektzahlen.
**Wichtig: Dieser Block ist ausdrücklich als „v2.9 **+ M30**" bezeichnet.** Er ist die
Sollreferenz für den **alten** Maßstab, nicht für den seit dem 22.08.2026 geltenden.

| Objektart | Soll (`bestand_pilot`, Stand M30) | Ist (Lauf vom 22.08.2026, M30+M31+M32) | |
|---|---:|---:|---|
| Tabellen | 57 | 57 | ✔ |
| Sichten | 12 | 12 | ✔ |
| Trigger | 27 | 27 | ✔ |
| **Funktionen** | **27** | **29** | **Abweichung** |
| Enums | 44 | 44 | ✔ |
| Rollen (Dienstidentitäten) | 6 | 6 | ✔ |

**Fünf von sechs Werten stimmen überein.** Die sechste Abweichung ist erklärt und erwartbar:
M31 und M32 ergänzen zwei Funktionen. Alle 29 tragen einen festen Suchpfad, wie das Soll es
für die 27 verlangt.

> **Auflage, nicht Befund:** `bestand_pilot` ist nach **F6** auf den geltenden Maßstab
> nachzuziehen — 29 Funktionen. Das geschieht in der **Konzept-Fabrik**; der Harness schreibt
> dorthin nie. Bis dahin ist die Abweichung hier benannt und begründet, nicht offen.

---

## 6 · Was dieses Soll ausdrücklich nicht verlangt

- **Keine Bestandsdaten.** Die Datenbank ist nach dem Lauf leer bis auf das, was die
  Migrationen selbst anlegen.
- **Keinen eingeschalteten Zeilenschutz.** `M32`:35–39 legt die Vorrichtung an und lässt die
  Durchsetzung aus. Der Nachweis, dass sie hält, gehört zu **M11**.
- **Keine Produktionsreife.** M1 ist das Fundament, nicht die Freigabe.

---

## 7 · Zur Zählweise der Vergleichsdateien

Das Belegblatt nennt **3 337** Zeilen Unterschied im Schema-Abzug und **166** im Daten-Abzug.
`wc -l` auf denselben Dateien ergibt **3 947** und **237**. Beide Zahlen sind richtig; sie
messen Verschiedenes:

| | |
|---|---|
| `wc -l` | **alle** Zeilen der Vergleichsdatei — einschliesslich Kontextzeilen und Abschnittsköpfen (`@@ … @@`), die `diff -u` zur Lesbarkeit mitschreibt |
| das Belegblatt | nur die **geänderten** Zeilen: solche, die mit `+` oder `-` beginnen, ohne die zwei Dateiköpfe |

**Ein kleiner Zählfehler ist dabei aufgefallen und wird hier benannt statt geglättet:**
`zaehle_aenderungen()` in `migrations/kettenlauf.sh`:1327–1331 nimmt Zeilen aus, die mit `---`
beginnen — gedacht als Ausschluss des Dateikopfes. Eine **entfernte** SQL-Kommentarzeile, die
mit `--` beginnt, trägt im Vergleich das Präfix `-` und beginnt damit ebenfalls mit `---`. Sie
wird mitausgeschlossen. Gemessen an dieser Datei: 3 350 Zeilen beginnen mit `+` oder `-`,
gezählt wurden 3 337 — die Differenz sind Kommentarzeilen.

**Wirkung: keine auf das Urteil.** Die Zahl belegt, *dass* der erste Lauf gewirkt hat, nicht
*wie stark*. Ob 3 337 oder 3 350 — beides ist deutlich ungleich null. Der Zählfehler ist
trotzdem aufzunehmen, weil eine Zahl, die im Nachweis steht, nachrechenbar sein muss.

---

*Dieses Blatt beschreibt das Soll. Ob der Lauf vom 22.08.2026 es erfüllt, entscheidet nicht
der Harness — das ist die Frage, die Tor 3 und der Mensch beantworten.*
