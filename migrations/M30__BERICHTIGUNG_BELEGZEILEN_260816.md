# Berichtigungsvermerk zu **M30** · Die Belegzeilen der Stufe 10h

**Dieser Vermerk tritt neben `M30__pilot_sammelmigration.sql`. Die Datei selbst wird nicht
angefasst.**

| | |
|---|---|
| **Betrifft** | `M30__pilot_sammelmigration.sql`, Zeilen **67–69** und **1477–1479** |
| **Grundlage** | Befund `nachweise/befunde/BEF-K02M17_260816.md` · Freigabe **E-7**, gez. M. Veil und A. Han, 16.08.2026 |
| **Angelegt** | 16.08.2026 |
| **Art** | **Vermerk, keine Änderung.** Er berichtigt eine Belegangabe, nicht den Bau |

---

## Warum die Datei nicht geändert wird — das ist der Kern dieses Vermerks

**Die Empfehlung E-7 sagte: *„Die Belegzeile berichtigen … Aufwand: Minuten."* Das war
falsch.** Beim Ausführen ist gemessen worden, warum:

```
$ cat migrations/M30__pilot_sammelmigration.sha256
1af077c540f910d3871ad3b459c5bdeff51034274cbb6b680c065eb3fd2fac4d

$ shasum -a 256 migrations/M30__pilot_sammelmigration.sql
1af077c540f910d3871ad3b459c5bdeff51034274cbb6b680c065eb3fd2fac4d   ✅ geht auf

$ git log --oneline -- migrations/M30__pilot_sammelmigration.sql | wc -l
1     # seit dem ersten Commit unveraendert
```

**`M30` ist Rang 1.** Die Verfassung sagt: *„Das autoritative Zielschema ist eingefrorene
Basis **plus M30 in der Fassung mit der Prüfsumme aus dem gezeichneten N2-Nachweis**."*

**Ein geänderter Kommentar ändert die Prüfsumme genauso wie ein geändertes `ALTER TABLE`.**
`shasum` unterscheidet nicht zwischen Text und Anweisung. Wer die Belegzeile in der Datei
berichtigt, macht den Maßstab ungültig — für eine Berichtigung, die den Bau gar nicht
berührt.

> **Deshalb dasselbe Muster wie bei Blatt 57 zu Blatt 52:** *„Blatt 52 bleibt im Wortlaut
> bestehen. Diese Berichtigung tritt daneben. Eine gezeichnete Fassung wird nicht
> überschrieben."*

**Und für `pruefungen/migration/M30__pruefung.sql` kommt ein zweiter Grund dazu:** Der
Bau-Agent fasst **keine** Datei unter `pruefungen/` an — *„auch nicht nur den Tippfehler"*.
Diese Grenze trägt die blinde Rollentrennung; sie für eine Kommentarzeile zu durchbrechen
wäre der erste Schritt, sie später für etwas anderes zu durchbrechen.

---

## Was zu berichtigen ist — Stelle für Stelle

### Stelle 1 · `M30__pilot_sammelmigration.sql`, Zeilen 67–69

**Steht dort:**

```sql
-- 05.08.2026, F-08: eigene Klasse fuer unveraenderbare Ereigniszeilen
-- (Nr. 60, K02-M17) -- ohne Faelligkeit und ohne Anonymisierung.
ALTER TYPE retention_class ADD VALUE IF NOT EXISTS 'EREIGNIS';
```

**Zu lesen ist:**

> `-- 05.08.2026, Befund F-08 aus dem Fremdreview zu K02: eigene Klasse fuer`
> `-- unveraenderbare Ereigniszeilen -- ohne Faelligkeit und ohne Anonymisierung.`
> `-- GRUNDLAGE: Beschluss Nr. 60 (Option A), gez. 04.08.2026,`
> `--   260804_Nachweisprotokoll_Freigabe.md:115.`
> `-- ACHTUNG: NICHT K02-M17. Die Klausel sagt das Gegenteil und ist nachzuziehen`
> `--   (Befund BEF-K02M17 vom 16.08.2026).`

### Stelle 2 · `M30__pilot_sammelmigration.sql`, Zeilen 1477–1479

**Steht dort:**

```sql
-- 10h · F-08 · Eigene Klasse fuer Protokollzeilen (Nr. 60, K02-M17) ---
-- K02-M17 woertlich: "eine eigene Klasse fuer unveraenderbare Ereigniszeilen
-- -- ohne Faelligkeit und ohne Anonymisierung, nicht das Betriebsprotokoll."
```

**Zu lesen ist:**

> `-- 10h · Eigene Klasse fuer Protokollzeilen -----------------------------`
> `-- GRUNDLAGE: Beschluss Nr. 60 (Option A), gez. 04.08.2026 --`
> `--   "Protokollzeilen und der taegliche Aufraeumlauf widersprechen sich"`
> `--   -- entschieden: Beweiswert vor Loeschzusage.`
> `--   Fundstelle: 260804_Nachweisprotokoll_Freigabe.md:115`
> `-- Der Satz "eine eigene Klasse fuer unveraenderbare Ereigniszeilen ..." ist`
> `--   eine WIEDERGABE DIESES BESCHLUSSES, kein Klauselzitat. Er steht in`
> `--   keinem der 24 Konzepte.`
> `-- K02-M17 sagt gezeichnet das Gegenteil: "Vorgabe ist das Betriebsprotokoll".`
> `--   Die Klausel ist nachzuziehen -- Befund BEF-K02M17 vom 16.08.2026.`

### Stelle 3 und 4 · `pruefungen/migration/M30__pruefung.sql`, Zeilen 274–277 und 1036

**Steht dort:**

```sql
-- KORRIGIERT am 5.8.2026 (Befund F-08 aus dem Fremdreview zu K02): …
-- K02-M17 verlangt nach Nr. 60 das Gegenteil -- "ohne Faelligkeit UND ohne Anonymisierung".
INSERT INTO mt SELECT 'MT-17','Protokollzeile weder faellig noch anonymisiert (Nr. 60, K02-M17)', …
```

**Zu lesen ist:** dasselbe, aber ohne `K02-M17` als Anspruchsgrundlage — **`Nr. 60`** trägt
den Fall allein. Der Titel von **MT-17** sollte lauten:
*„Protokollzeile weder fällig noch anonymisiert (Beschluss Nr. 60)"*.

**MT-79** (Zeile 1036) nennt bereits nur `Nr. 60` und ist **richtig**.

> **Diese beiden Stellen berichtigt der Prüf-Agent, nicht der Bau.** Er bekommt dafür den
> Beschluss Nr. 60 und den Wortlaut von K02-M17 — beides ist Klauseltext, keine Umsetzung;
> seine Blindheit bleibt unberührt.

---

## Was **nicht** zu berichtigen ist

| | Warum |
|---|---|
| **Der Bau selbst** — Klasse `EREIGNIS`, Vorgabe für `event`, Trigger `event_append_only` | Er folgt **Beschluss Nr. 60**, gezeichnet. `RR-02` vom 16.08.2026 bestätigt ihn ein zweites Mal |
| **Die Kennung `F-08`** | *Berichtigt gegenüber dem ersten Befundtext:* `F-08` meint hier **den Befund F-08 aus dem Fremdreview zu K02**, nicht die Festlegung F08 des Kanons. Die Prüfdatei sagt das ausdrücklich; im Migrationskommentar fehlt nur der Zusatz. **Das ist eine Unklarheit, kein Fehler** |
| **Die Rechtsgrundlage in `retention_rule`** | Sie nennt bereits korrekt *„Beschluss Nr. 60 (Option A) und Nr. 16"* — **ohne** falsches Klauselzitat |

---

## Wann dieser Vermerk entfällt

**Wenn `M30` das nächste Mal ohnehin abgelöst wird.** Dann gehen die berichtigten Zeilen in
die Nachfolgefassung ein, und dieser Vermerk wird als erledigt geführt — **nicht gelöscht,
sondern abgehakt.**

Bis dahin gilt: **Wer Stufe 10h liest, liest diesen Vermerk mit.** Ein Verweis darauf gehört
in jede Vorlage, die sich auf die Aufbewahrungsklasse des Protokolls stützt.

---

*Angelegt am 16.08.2026 vom Coding-Harness auf Weisung E-7. **Die Empfehlung E-7 sprach von
Minuten und einer Dateiänderung; beides war falsch.** Was hier steht, ist die Berichtigung
dieser Berichtigung — und sie kostet den Maßstab nichts.*
