# Entscheidungsvorlage · Tor 1 ist rot — und der Harness darf es nicht allein grün machen

**Vier Entscheidungen. Zwei davon kann nur ein Mensch treffen, zwei nur der Prüf-Agent.**

| | |
|---|---|
| **An** | M. Veil (Auftraggeber) · A. Han (für den Auftragnehmer, Nr. 158) |
| **Von** | Orchestrator des Coding-Harness |
| **Art** | **Vorlage mit Handlungsempfehlungen. Keine Entscheidung.** |
| **Vorgelegt** | 16.08.2026, nach der Weisung *„fixe das"* |
| **Grundlage** | drei Diagnosen, je mit **adversarischer Gegenprobe** — Auftrag der Gegenprobe war zu **widerlegen**, nicht zu bestätigen |

> ### Warum das eine Vorlage ist und keine Behebung
>
> **Beide behebbaren Fehler liegen in Dateien unter `pruefungen/`.** Der Bau-Agent fasst dort
> nichts an — *„auch nicht nur den Tippfehler"*. Und der dritte ist ein Widerspruch im
> gezeichneten Bildschirmvertrag, den weder Bau noch Prüfung auflösen darf.
>
> **Der Harness hätte Tor 1 in zehn Minuten grün gehabt** — `shellcheck -S error` statt
> `-S warning`, und die Sache wäre erledigt gewesen. Genau das verbietet `K23-D05`.

---

## Der Stand in einem Bild

```
Tor 1a · Lint                    ROT   5 shellcheck-Warnungen, alle in EINER Datei
Tor 1b · Migration frisch        GRUEN
Tor 1c · blinde Prueffaelle      ROT   MT-95/95b  +  20 von 27 im Faden zweckbestimmung
Tor 1  · Sperre                  ROT   Folge aus 1a und 1c -- kein eigener Fehler
```

**Kein einziger der Fehler stammt aus dem Bau von heute Abend** (Portal-Hinweis,
Kriteriumsvorschläge). Alle drei kommen mit **M4**.

---
---

# ⚠ Vorab: was die Gegenproben an den Diagnosen gefunden haben

**Zwei von drei Erstdiagnosen sind gefallen.** Das ist kein Makel des Verfahrens — es ist
sein Ertrag. Beide gefallenen Diagnosen sagten *„der Test ist falsch"*, und beide Male hat
die Gegenprobe das widerlegt.

| Fall | Erstdiagnose | Gegenprobe | Was gilt |
|---|---|---|---|
| **A** | „drei Änderungen, sonst nichts" | **gefallen** — sie hat shellcheck **tatsächlich laufen lassen** (Docker) und **fünf** Warnungen gefunden, nicht vier | Der Vorschlag hätte Tor 1a **rot gelassen** |
| **B** | „der Test ist veraltet, der Bau ist richtig" | **gefallen** — der Bau stützt sich auf **zwei Fehlzitate** | **Der Riegel im Bau ist der Verdächtige** |
| **C** | „der Bildschirmvertrag widerspricht sich" | **hält stand**, mit Gewichtungskorrektur | Der Widerspruch ist **unsymmetrisch**: 3 Felder gegen 1 |

> **Die Erstdiagnose zu B war die bequeme Antwort.** Sie hätte bedeutet: der Harness ändert
> einen Test, damit sein eigener Bau grün wird. Die Gegenprobe hat den Satz gefunden, mit dem
> das Projekt sich selbst dagegen verpflichtet hat — er steht in der Prüfdatei:
>
> > *„Wer in einem Jahr fragt, warum diese vier Fälle geändert wurden: **weil die Klausel es
> > so verlangt, nicht weil der Bau es so tut.**"*

---
---

# E-8 · Der Riegel in `create_app_after_fit` — **die schwerwiegendste der vier**

## Was passiert

`M31` hat in den Serverbefehl eine Vorbedingung eingezogen: Beide Zweckbestimmungsfragen
müssen beantwortet sein, sonst Abbruch. **Zwei Rang-1-Prüffälle sterben daran** — MT-95
(*Nummer wird vergeben*) und MT-95b (*der Portalpfad darf den Befehl aufrufen*).

## Was die Gegenprobe gefunden hat — drei Funde, jeder nachprüfbar

### 1 · Der Bau widerspricht sich selbst, 150 Zeilen früher

**`M31` Abschnitt 1b nimmt einen strukturgleichen Riegel ausdrücklich zurück:**

> *„Gemessen am 16.08.2026: sie macht den bestehenden Migrationsprüffall MT-29 unmöglich …
> **Die Prüfung folgt nicht dem Bau. Eine Bedingung, die eine Rang-1-Prüfung unmöglich macht,
> ist eine Änderung an M30-Verhalten und gehört als Rückfrage an die Founder, nicht in
> M31.**"*
> — `migrations/M31__projektnummer_und_zweckbestimmung.sql`:147–157

**Abschnitt 2b tut mit MT-95/95b exakt dasselbe — und bleibt stehen.** Dieselbe Datei
behandelt denselben Sachverhalt zweimal gegensätzlich.

### 2 · Zwei Fehlzitate tragen den Riegel

`M31`:292–293 begründet ihn so: *„K01-M27 sagt, was der Befehl prüft; **K04-M21 sagt, dass
die Kenntnisnahme Bedingung ist.**"* — Selbst nachgelesen:

| Klausel | Was sie **wirklich** sagt |
|---|---|
| **K04-M21** | *„Die Kenntnisnahme MUSS **als Nachweis erhalten bleiben** und in das Übergabe-Paket (K10 Abschn. 3) eingehen."* — **kein Wort über eine Anlagebedingung** |
| **K04-M19** | *„Nach `outcome = GEEIGNET` MUSS ein Zweckbestimmungs-**Schritt** folgen."* — beschreibt einen **Ablaufschritt**, keine Bedingung im Serverbefehl |
| **K01-M27** | *„Er prüft in derselben Transaktion: Eignung GEEIGNET, aktives Konto, Mandantenzugehörigkeit, `legal_space = DE` und `currency = EUR`."* — **fünf**, und die Maschinenquelle liest sie abschließend |

**Das ist das dritte erfundene Zitat an einem Tag.** Die anderen beiden: `BEF-K02M17`
(*„K02-M17 wörtlich"*) und die 26, die die Gegenprobe bei E-6 gefunden hat.

### 3 · Der Riegel ist selbst ungemessen

Die vier Negativfälle `M31_N1` bis `N4` decken den NULL/NULL-Zweig **nicht** ab — N1 setzt
beide Antworten auf `false`, N2 und N3 setzen sie. **Ein unbelegter *und* unbeobachteter
Riegel färbt zwei grüne Rang-1-Fälle rot.**

## Warum der naheliegende Fix gesperrt ist

Die Erstdiagnose wollte die Testherrichtung nachziehen. **Das darf niemand:** Der nötige
`INSERT` setzt Kenntnis der Spaltennamen, ihrer Bedeutung (`false` = kein Treffer) und der
Riegelreihenfolge voraus — **alles steht ausschließlich in `M31`**, also im Umsetzungscode,
den der Prüf-Agent nie sieht. Er kann die Zeile nicht herleiten; die einzige Begründung wäre
*„weil der Bau es so tut"*.

## ✅ Handlungsempfehlung: **2b zurücknehmen, nach dem eigenen Präzedenzfall**

> **Der Harness empfiehlt, den NULL/NULL-Riegel aus `M31` Abschnitt 2b zu streichen** — genau
> so, wie Abschnitt 1b es 150 Zeilen früher mit seinem Riegel getan hat, und mit derselben
> Begründung.
>
> **Was dann weiterhin trägt** (die Kette bricht nicht):
>
> | | |
> |---|---|
> | Der Weg über den Bildschirm | `app/zweckbestimmung.py` ruft `anwendung_anlegen` nur bei zwei Antworten auf |
> | Treffer in Frage 2 | `M31_N3` misst die Abweisung — der Riegel **bleibt** |
> | Treffer in Frage 1 ohne Kenntnisnahme | `M31_N2` misst die Abweisung — der Riegel **bleibt** |
> | Die fünf Prüfungen aus K01-M27 | unverändert |
>
> **Zurückgenommen wird allein der NULL/NULL-Zweig** — der einzige ohne Klauseldeckung und
> ohne Negativfall.

**Der Einwand dagegen, ehrlich benannt:** Bei `NULL` ist ein Treffer in Frage 2 nicht
*ausgeschlossen*, und `K19-M14` sagt zu Recht *„Ein UI-Zustand ersetzt keine serverseitige
Autorisierung"*. Wer die Kette nur über den Bildschirm schließt, verlässt sich auf einen Weg,
den man umgehen kann. **Deshalb ist das keine Bau-Entscheidung.**

- [x] **Wie empfohlen: 2b zurücknehmen**, Rückfrage an die Founder wie in 1b —
      **gez. M. Veil, 16.08.2026** · Weisung im Wortlaut: *„hiermit freigegeben, gez. M. Veil“*
- [ ] **Riegel bleibt** — dann ist zuerst die **Klauseldeckung** in K04 oder K01 nachzuziehen, und **erst danach** die Testherrichtung, mit Klauselverweis statt Bauverweis
- [ ] **anders:** ⟨…⟩

> ### ✅ Vollzogen am 16.08.2026 — und was dabei sichtbar wurde
>
> **`M31` Abschnitt 2b ist zurückgenommen**, mit vollständigem Vermerk an Ort und Stelle:
> was dort stand, warum es fällt, welche drei Riegel weiterhin tragen, und die Rückfrage an
> die Founder. **Die beiden Fehlzitate sind dabei berichtigt.**
>
> **Der Lauf danach zeigt: der Zweckbestimmungs-Fehler ist weg — und ein zweiter, davon
> unabhängiger tritt hervor.**
>
> ```
> vorher : MT-95  FEHLER: ZWECKBESTIMMUNG: beide Fragen muessen beantwortet sein
> jetzt  : MT-95  FEHLER: duplicate key value violates unique constraint app_project_no_key
> ```
>
> **Das ist kein Rückschritt.** Der zurückgenommene Riegel hat einen zweiten Defekt
> verdeckt: Beide Fälle starben an ihm, bevor sie den zweiten überhaupt erreichten.
> **Ein Riegel, der andere Fehler verbirgt, kostet mehr, als er nützt.** Siehe **E-12**.

> **Was in jedem Fall zu tun ist, unabhängig vom Kreuz:** die beiden Fehlzitate in `M31`:292
> berichtigen. `M31` ist **nicht** eingefroren — anders als `M30` trägt es keine Prüfsumme.

---
---

# E-9 · Der Bildschirmvertrag widerspricht sich — **20 gesperrte Prüffälle hängen daran**

## Was passiert

Der blinde Prüffall erwartet nach zwei Antworten **genau ein** neues Ziel. Der Bau zeigt
**zwei**: *Antwort zurücknehmen* und *Anwendung anlegen*. **ZB-03 sperrt daran, und ZB-04 bis
ZB-14 kaskadieren** — dazu zehn weitere Fahrten.

## Der Widerspruch, im Wortlaut

**`schema/K19_screens.yaml`, Aktion `antwort_aendern` — vier Felder, drei zeigen in eine
Richtung, eines in die andere:**

| Zeile | Feld | Was es sagt | Lesart |
|---|---|---|---|
| 254 | `serverbefehl` | `supersede_fit_answer` | **nur nach einem Halt** |
| 255 | `berechtigung` | *„einer der drei Auswege nach einem **Halt** (K04-M08)"* | **nur nach einem Halt** |
| 258 | `zustand_erfolg` | *„EN-04 öffnet erneut"* | **nur nach einem Halt** |
| 257 | `zustand_leer` | *„die Aktion existiert **nur bei vorhandener Antwort**"* | ab der **ersten** Antwort |

**Der Bau ist der Zeile 257 gefolgt.** Drei Felder sagen etwas anderes.

## Was **nicht** stimmt — auch der Prüffall hat einen Fehler

**Die Annahme *„genau ein neues Ziel"* steht in keinem Vertragstext.** Die Gegenprobe hat
gesucht und nicht gefunden:

- **K19-M06** regelt das **Ausblenden** einer Schaltfläche bei selbst erfüllbarer Bedingung —
  nicht die **Anzahl** gleichzeitig neu erscheinender Wege.
- **K04-M08** ist ausdrücklich **halt**-bezogen.

**EN-04a nennt sechs Aktionen, und nirgends steht, dass nur eine zugleich neu erscheinen
darf.** Die Singleton-Annahme ist eine Heuristik des Prüf-Agenten, keine Ableitung.

## ✅ Handlungsempfehlung: **halt-only — und das heißt, der Bau ist falsch**

> **Nach Belegdichte 3:1 empfiehlt der Harness Lesart (A): `antwort_aendern` ist
> halt-only.** Dann ist der Knopf *„Antwort zurücknehmen"* im offenen Zustand zu entfernen —
> **der Bau ändert sich, nicht der Test.**
>
> **Und die Rücknahme im offenen Zustand?** Wenn sie fachlich gewollt ist (eine Kundin
> korrigiert eine Zweckantwort, ohne dass ein Halt vorliegt), gehört sie als **eigene,
> siebte Aktion** in den Vertrag — mit eigenem Serverbefehl und eigenem Leerzustand. **Nicht
> als stille Zweitbedeutung einer bestehenden.**

- [ ] **(A) halt-only** ✅ *Empfehlung* — Vertrag angleichen, Bau korrigieren
- [ ] **(B) ab jeder vorhandenen Antwort** — dann sind `serverbefehl` und `zustand_erfolg` zu berichtigen, weil sie den gebauten Weg nicht beschreiben
- [ ] **(A) + eigene siebte Aktion** für die Rücknahme im offenen Zustand
- [ ] **anders:** ⟨…⟩

> **Unabhängig vom Kreuz** ist die Singleton-Heuristik des Prüffalls zu ersetzen — durch eine
> **vertragsverankerte** Erkennung: Der Anlageweg ist an seiner **Wirkung** zu erkennen (eine
> neue Anwendungszeile, `fit_check.app_id` gesetzt, Verlaufszeile `DISCOVERY`), nicht an einer
> Mengendifferenz. **Das entsperrt die Kaskade sofort und hängt an keiner Entscheidung.**

---
---

# E-10 · Fünf shellcheck-Warnungen — **ein Auftrag an den Prüf-Agenten**

## Was passiert

`shellcheck -S warning` läuft ohne Ausnahmen und ohne `.shellcheckrc`. **Fünf Warnungen,
alle in `pruefungen/klauseln/zweckbestimmung_lauf.sh`** — die Gegenprobe hat den Lauf per
Docker tatsächlich gefahren, die Erstdiagnose kannte nur vier.

| Zeile | Kennung | Was |
|---|---|---|
| 699 | SC2034 | `t` in der Feldzerlegung unbenutzt — **die fünfte, die der Erstdiagnose fehlte** |
| 751 | SC2034 | `ST_HALB_UI` gesetzt und nie benutzt |
| 1046 / 1052 | SC2221 / SC2222 | `2*\|4*)` fängt 401/403 ab, bevor der Sonderzweig greift |
| 1319 / 1325 | SC2221 / SC2222 | dasselbe Muster, zweite Stelle |

**Der Kopfkommentar derselben Datei verlangt die Unterscheidung ausdrücklich:** *„Ein 404
oder ein 401 wäre eine **fremde Bedingung** — deshalb wird der Status ausdrücklich
unterschieden."* **Der Code unterscheidet ihn nicht.** Die Umordnung stellt die Absicht her,
sie erfindet sie nicht — und sie **verschärft**: 401/403 erzeugt danach eine Diagnose statt
still zu bestehen.

## Eine Nebenentscheidung, die vor die Umsetzung gehört

Der neu scharfgeschaltete Zweig meldet **`nok`**, obwohl sein eigener Text 401/403 als
*„fremde Bedingung"* — also **nicht messbar** — einstuft. Der Kopf von `tore.yml` sagt:
*„Ein Lauf, der nicht messen kann, meldet **GESPERRT** — nie grün (K23-M22)."*

> **Empfehlung: `sperr` statt `nok`**, in derselben Änderung. Das ist reine Klauselanwendung,
> keine fachliche Frage.

## ✅ Handlungsempfehlung: **ein Auftrag an den blinden Prüf-Agenten, vier Änderungen**

> | | |
> |---|---|
> | 1 | Zweig `401\|403)` **vor** `2*\|4*)` ziehen — an **beiden** Stellen, Wortlaut unverändert |
> | 2 | `ST_HALB_UI=""` (751) streichen — die Messung leistet ZB-03 bereits |
> | 3 | `t` (699) durch einen Wegwerfnamen ersetzen — **nicht** streichen, es ist ein Positionsfeld |
> | 4 | Reaktion des Zweigs auf **`sperr`** statt `nok` |
>
> **Was der Prüf-Agent bekommt:** die Torschwelle, den Kopfkommentar **seiner eigenen
> Datei**, die fünf Zeilen, und den `K23-M22`-Wortlaut. **Nicht** mitgeben: dass in `app/`
> kein 401/403 vorkommt — das war Gegenprobe, nicht Begründung. Sonst wäre der Prüftext an
> den Umsetzungscode angepasst.
>
> **Ausdrücklich nicht:** `-S error` setzen, `-e SC2221,SC2222,SC2034` ergänzen oder den
> Zweig löschen. **Jede dieser Varianten macht Tor 1a grün, indem sie eine Unterscheidung
> aufgibt, statt sie herzustellen** — `K23-D05`.

- [x] **Der Prüf-Agent bekommt diesen Auftrag** ✅ *Empfehlung* — **gez. M. Veil, 16.08.2026**
- [ ] **anders:** ⟨…⟩

**Nachrangig und bewusst nicht im Auftrag:** ob `404` einen eigenen Zweig bekommt. Das wäre
eine **Erweiterung** des Prüfwerts, keine Reparatur — und damit eine Entscheidung für einen
Menschen.

---
---

# E-11 · Die Kennung `MG-11` — **am 16.08.2026 aufgelöst**

## ⚠ Diese Vorlage hat den Punkt selbst falsch dargestellt

**Sie behauptete: *„`MG-11` gibt es nicht — im ganzen Repository kein einziger Treffer."***
**Das war falsch, und der Fehler war meiner.** Gesucht wurde nur im Arbeitsbaum des
aktuellen Zweigs und nur in `*.sh`. `MG-11` steht in einer `.sql`-Datei und auf einem
**anderen Zweig**:

```
$ git log --all -S'MG-11'
f734705  M-7 bis M-10 umgesetzt -- und der Prueflauf sagt, was noch fehlt

$ git branch -a --contains f734705
umsetzung/M7-M10-260815          # NICHT scheibe/m4-zweckbestimmung

$ git merge-base --is-ancestor f734705 HEAD ; echo $?
1                                # kein Vorfahr -- anderer Zweig

$ git show umsetzung/M7-M10-260815:pruefungen/klauseln/mitgliedschaft_daten.sql | grep -c MG-11
3
$ git show HEAD:pruefungen/klauseln/mitgliedschaft_daten.sql | grep -c MG-11
0
```

**`MG-11` ist real:** *„zwei Zugangszeilen, abgelaufen ist nur die EXMA-Einladung"*, Konto
`mg_portalablauf@`, angelegt am 16.08.2026 um 00:41 auf dem Zweig `umsetzung/M7-M10-260815`.

## Was daraus wirklich folgt — und es ist ernster als ein Tippfehler

| | |
|---|---|
| **Der Prüffall ist echt** | kein Tippfehler, keine erfundene Kennung |
| **Er läuft auf diesem Zweig nicht** | er existiert hier nicht — der Faden `mitgliedschaft` misst hier **9 Fälle statt 10** |
| **Der Harness hat ihn trotzdem als *rot* geführt** | im M4-Plan, in Übergaben und in dieser Vorlage — **eine Zustandsbehauptung über einen Prüffall, den der eigene Lauf gar nicht kennt** |

> **Das ist genau der Fehler, gegen den die Schwesterregel vom 16.08.2026 geschrieben wurde:**
> *„Jede Zustandsbehauptung in einem Steuerungstext trägt den Befehl daneben, der sie
> belegt."* Hätte ich `MG-11` je mit einem Befehl belegt, wäre der Widerspruch am ersten Tag
> aufgefallen.

## ✅ Handlungsempfehlung

> **`MG-11` ist kein offener Befund dieses Zweigs, sondern ein Prüffall, der mit
> `umsetzung/M7-M10-260815` hereinkommt.** Er ist als *rot* zu **streichen**, solange er
> hier nicht existiert — und beim Zusammenführen dieses Zweigs erneut zu bewerten.
>
> **Und der Zweig selbst gehört auf die Liste:** `umsetzung/M7-M10-260815` ist weder
> zusammengeführt noch als Antrag offen. **Was dort liegt, ist in keinem Lauf dieses Zweigs
> gemessen.**

- [x] **Kennung geklärt** — `MG-11` existiert auf `umsetzung/M7-M10-260815`, nicht hier ·
      *gemessen am 16.08.2026*
- [ ] **`umsetzung/M7-M10-260815` sichten** — was liegt dort, und gehört es in den Teilschnitt?

**Die drei anderen `GESPERRT` sind geprüft und getragen:** `MG-08` (kein prüfbarer Weg,
offener Punkt) · `VP-08b` (Widerspruch K04-M07 gegen Rang 1, wartet auf einen Menschen) ·
`AC-16` (echter Mailversand, braucht A. Hans Schlüsselbund).

---
---

# Reihenfolge — was zuerst

```
SOFORT, unabhaengig voneinander:
  E-10  Pruef-Agent: die vier shellcheck-Aenderungen        -> Tor 1a gruen
  E-9   Pruef-Agent: Singleton-Heuristik ersetzen           -> Kaskade entsperrt
        ACHTUNG: beide fassen DIESELBE Datei an.
        Ein Auftrag, nacheinander -- nicht parallel.

PARALLEL DAZU, an die Menschen:
  E-8   Bleibt der NULL/NULL-Riegel?                        M. Veil + A. Han
  E-9   antwort_aendern: halt-only oder ab erster Antwort?  M. Veil + A. Han

DANACH:
  Bau korrigiert, was die Entscheidungen ergeben.
```

## Was auch danach noch rot ist — damit die Vorlage nicht mehr verspricht, als sie hält

| | |
|---|---|
| **MT-95 / MT-95b** | bleiben rot, bis **E-8** entschieden ist. **Es gibt keinen zulässigen prüfseitigen Fix** |
| **Die ZB-Fälle um `antwort_aendern`** | bleiben rot, wenn E-9 auf halt-only fällt — dann ist erst der Bau zu ändern. Der Prüf-Fix **entsperrt** die Kaskade, macht sie nicht grün |
| **Alle drei Behebungen** | sind **unverifiziert**, bis ein echter Lauf sie bestätigt. **Nach jedem Schritt fahren, nicht am Ende** |

> **Ein Vorbehalt zur ganzen Vorlage.** Fünf der sechs Agenten haben **statisch** gearbeitet —
> gelesen, nicht gefahren. Nur die Gegenprobe zu E-10 hat shellcheck wirklich laufen lassen,
> und genau sie hat den Fehler der Erstdiagnose gefunden. **Was hier steht, ist nach
> `K23-M22` gut begründet, aber nicht gemessen.**

---

## Zeichnung

*Eingetragen auf Weisung; der Harness trägt nur ein, was angewiesen wurde.*

| | Entscheidung | angenommen | abweichend |
|---|---|---|---|
| **E-8** | NULL/NULL-Riegel aus M31 2b zurücknehmen | **[x]** M. Veil | ✅ **vollzogen** |
| **E-9** | `antwort_aendern` ist halt-only | **[x]** M. Veil | ⛔ Bau-Anteil wartet auf **A. Han** als Eigentümer K19/K04 · Prüf-Anteil erteilt |
| **E-10** | Prüf-Agent bekommt die vier shellcheck-Änderungen | **[x]** M. Veil | ✅ **erteilt** |
| **E-11** | Kennung `MG-11` klären | **[x]** M. Veil | ✅ **geklärt** — sie existiert, auf einem anderen Zweig |
| **E-12** | Herrichtung schreibt den Nummernzähler nicht fort | *neu, 16.08.* | ✅ **erteilt** — beim Vollzug von E-8 sichtbar geworden |

> ### ⛔ Warum A. Hans Unterschrift bei E-8 und E-9 aussteht
>
> **M. Veil hat freigegeben, und der Harness hat vollzogen, was der Auftraggeber allein
> entscheiden darf. Zwei Punkte gehen darüber hinaus:**
>
> | | Warum beide Unterschriften |
> |---|---|
> | **E-8** | `M31` Abschnitt 1b sagt selbst, die Frage gehöre *„als Rückfrage an die **Founder**"* — und *Founder* heißt in diesem Projekt durchgängig **beide** (*„an beide Founder"*, *„auf Weisung beider Founder"*). **Die Rücknahme ist vollzogen; die Rückfrage ist damit gestellt, nicht beantwortet.** |
> | **E-9** | Der Bau-Anteil ändert einen Bildschirm gegen den **gezeichneten Bildschirmvertrag**. Fachlicher Eigentümer von **K19** und **K04** ist seit dem 16.08.2026 **A. Han** |
>
> **Was ohne A. Han nicht geschieht:** Der Knopf *„Antwort zurücknehmen"* bleibt im offenen
> Zustand stehen, und `K19_screens.yaml` bleibt widersprüchlich. **Der Prüf-Anteil von E-9
> läuft trotzdem** — er macht ZB-03 messfähig, unabhängig davon, wie die Frage ausgeht.

---
---

# E-12 · Die Herrichtung vergibt Nummern hinter dem Zähler — **beim Vollzug von E-8 sichtbar geworden**

**Er lag hinter dem zurückgenommenen Riegel und war deshalb nie gemessen worden.**

```
$ psql … "select naechste_nummer from nummernvorrat where praefix='PROJ'"
1

$ sed -n '80p;119p' pruefungen/migration/M30__pruefung.sql
        'DE-DMB_001_01','Pilotprojekt',current_date,
  VALUES (…,'DE-DMB_002_01','Falschstart',current_date,
```

**Die Herrichtung trägt vier Anwendungszeilen mit fest eingetragenen Nummern ein — und
schreibt den Zähler nicht fort.** Er steht danach weiter bei **1**. Der Serverbefehl zieht
die 1, bildet `DE-DMB_001_01` — und trifft auf die Nummer, die die Herrichtung schon
vergeben hat.

**MT-95 und MT-95b scheitern damit an der Eindeutigkeitsbedingung der Nummer, nicht an dem,
was sie messen sollen.** Das ist derselbe Fehlertyp wie am **02.08.2026**: ein Fall, der an
einer **fremden** Bedingung scheitert, misst nichts.

> **Warum das erst jetzt auffällt — und warum das für E-8 spricht.** Vorher starben beide
> Fälle am Zweckbestimmungs-Riegel, bevor sie die Nummernvergabe überhaupt erreichten.
> **Ein Riegel, der andere Fehler verdeckt, kostet mehr, als er nützt.**

**Warum es der Prüfseite gehört und nicht dem Bau:** `K01-M38` sagt *„Sie wird vergeben,
nicht eingegeben."* Eine Herrichtung, die Nummern fest einträgt, umgeht den Befehl — das
darf sie, um einen Zustand herzustellen, aber sie muss den Zähler mitführen. **Das ist aus
der Klausel ableitbar, ohne einen Blick in den Bau.**

**Erteilt** am 16.08.2026 als dritter Teil desselben Prüf-Auftrags.

---

## Zeichnung

*Eingetragen auf Weisung; der Harness trägt nur ein, was angewiesen wurde.*

| Name | Rolle | Datum | Anmerkung |
|---|---|---|---|
| **M. Veil** | Auftraggeber | **16.08.2026** | *„hiermit freigegeben, gez. M. Veil“* — alle vier Punkte |
| **A. Han** | für den Auftragnehmer (Nr. 158) | | ⛔ **erforderlich für E-8 und E-9** |

---

*Erstellt am 16.08.2026 vom Orchestrator des Coding-Harness, auf Grundlage von drei Diagnosen
und drei Gegenproben. **Zwei der drei Erstdiagnosen sind an ihrer Gegenprobe gescheitert, und
beide sagten „der Test ist falsch".** Diese Vorlage entscheidet nichts.*
