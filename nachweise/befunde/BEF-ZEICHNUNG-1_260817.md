# Befund **BEF-ZEICHNUNG-1** · Eine Freigabe am Antrag ist keine Zeichnung am Blatt

| | |
|---|---|
| **Gefunden am** | 17.08.2026, beim Nachmessen einer Agentenmeldung |
| **Betrifft** | Korrekturblatt **BA-1**, jetzt auf `main` (`arbeit/Vorlagen/korrekturblatt_BA-1_wegA_260815.md`) |
| **Klasse** | **Form** — die Verwechslung zweier Vorgänge, die gleich aussehen |
| **Schwere** | ⛔ **Sperrend.** Der Auftragstext ist unverändert, obwohl das Blatt in der Hauptspur liegt |

---

## 1 · Was tatsächlich geschehen ist — gemessen

**A. Han hat am 17.08.2026 gehandelt, und zwar dreimal:**

```
$ gh api graphql … reviews
#24: AndrewExma DISMISSED  2026-08-16T10:20:31Z
     AndrewExma APPROVED   2026-08-17T10:36:21Z
     AndrewExma APPROVED   2026-08-17T12:00:17Z
#25: AndrewExma APPROVED   2026-08-16T10:20:59Z

$ gh pr view 27 --json author,mergedBy
  Autor   : AndrewExma      Gemergt : AndrewExma
  1 Datei : pruefungen/klauseln/anmeldecode_lauf.sh  +222 −44

$ gh run list --branch main
  4603732 Tor 1 success   ·  ab119af Tor 1 success  ·  1322c22 Tor 1 success

$ git rev-list --count 7642f0b..origin/main
18
```

**`main` hat sich zum ersten Mal seit Zweigöffnung bewegt** — drei Anträge zusammengeführt
(#25, #24, #27), **Tor 1 grün auf jedem Merge-Stand.** Das ist ein echter Fortschritt, und er
gehört zuerst genannt.

**Und A. Han hat etwas getan, das ausdrücklich lobend zu erwähnen ist:** Antrag **#27** bindet
`AC-16` an einen **nachweislich frischen** Mailversand statt an eine am 10.08. einmal
abgelesene Datei. Vorher konnte der Fall beliebig oft *falsch grün* bestehen, ohne dass je
wieder eine Mail hinausging. **Das ist eine Verschärfung eines Prüffalls, von der Prüfseite,
in ihrer eigenen Datei** — genau die Rollentrennung, die gestern Abend gebrochen wurde.

---

## 2 · Der Befund: BA-1 ist **nicht** gegengezeichnet

```
$ git show origin/main:arbeit/Vorlagen/korrekturblatt_BA-1_wegA_260815.md | grep -A3 '^| Name'

| M. Veil | Auftraggeber — trifft die Entscheidung | 16.08.2026 | Alle vier Kreuze … |
| A. Han  | für den Auftragnehmer (Nr. 158) — zeichnet die Urkunde mit (12.3) |  | ⛔ erforderlich |
                                                                          ^^^^
                                                                          leer
```

**Vier Kreuze von M. Veil stehen. Die Zeile von A. Han ist leer.**

### Warum die Freigabe an #24 das nicht ersetzt

| | Freigabe an einem Antrag | Zeichnung auf einem Blatt |
|---|---|---|
| **Was sie ist** | ein zweiter Blick auf Code und Text — `dismiss_stale_reviews`, `CODEOWNERS`, Gate 5 aus K23 | die **Willenserklärung** einer Vertragsseite nach **§12.3** |
| **Wo sie steht** | in GitHub, an einem Antrag | **in der Datei**, in der Zeichnungstabelle |
| **Was sie bewirkt** | der Zweig darf zusammengeführt werden | **die Korrektur wird wirksam** |
| **Was ohne sie gilt** | der Antrag bleibt offen | **§12.9: *„Vorschlag bleibt liegen · AM AUFTRAG IST NICHTS GEÄNDERT"*** |

**Beides sind zwei Blicke von A. Han auf dasselbe Blatt — aber nur einer davon ist eine
Unterschrift.** Und die Verfassung sagt zu genau dieser Trennung: **`F40`** — die Zeichnung
*„liegt in einer eigenen Datei und wird von keinem Werkzeug erreicht"*. Ihr Anlass war ein
Schaden, bei dem ein Werkzeug eine Unterschrift erreichen konnte.

> **Die Gefahr ist nicht abstrakt.** BA-1 liegt jetzt in der Hauptspur, trägt vier gesetzte
> Kreuze und sieht damit erledigt aus. Wer es in zwei Wochen aufschlägt, liest die Kreuze und
> hakt den Punkt ab. **Die leere Zeile darunter fällt niemandem auf** — dasselbe Muster, das
> am 16.08.2026 schon bei Blatt 82 gefunden wurde.

### Was daran hängt

```
   A. Han zeichnet BA-1 GEGEN     <- fehlt weiterhin
        v
   Founder-Beschluss zu Weg 3-III  (beide Founder)
        v
   BA-1 vollziehen                 (13 Stellen im Auftragstext)
        v
   BA-2 vollziehen                 (12 Stellen)
        v
   Fassung v1.2 -> einfrieren -> Pruefsumme -> neuer Durchstich
```

**Der erste Kasten ist leer, also steht die ganze Kette** — und mit ihr die drei gezeichneten
Entscheidungen, die bis heute nicht im Auftragstext angekommen sind: Weg A · die aufgehobene
`nummernvorrat`-Ausnahme · die Starttor-Auswahl.

**Der Merge hat daran nichts geändert.** Er hat das Blatt in die Hauptspur gebracht, nicht die
Korrektur in den Auftrag.

---

## 3 · Zwei weitere Punkte, gemessen am 17.08.2026

### ⛔ Die Fremdprüfung war **heute** fällig und ist nicht ausgelöst

```
$ gh pr view 26 --json labels,reviewDecision,state
{"labels":[],"reviewDecision":"REVIEW_REQUIRED","state":"OPEN"}
```

**Kein Etikett auf #26.** Die Anforderung (`tor3_anforderung_teilschnitt_260816.md`) trägt die
Frist *„Montag, 17.08.2026"*, und E-1 war am 16.08. freigegeben. **Messstufe 3 ist damit
weiterhin für keine Scheibe angefordert** — nach `K23-M22` **gesperrt**, nicht bestanden.

Das Etikett `teilschnitt-anmeldung` liegt seit dem 16.08. bereit, und der Ablauf hört darauf.
**Es fehlt nur der Handgriff — und den darf nur ein Mensch tun** (*„Ein Mensch schickt sie ab;
der Harness tut das nicht und darf es nicht."*).

### ⚠ #26 ist unberührt, und der Zweig ist jetzt 18 Commits hinter `main`

| | |
|---|---|
| **#26** | `OPEN`, `REVIEW_REQUIRED`, keine Review, kein Kommentar |
| **Zweig `scheibe/m4-zweckbestimmung`** | **18 zurück**, 28 voraus |
| **Was das praktisch heißt** | A. Hans verschärfter `AC-16`-Prüffall aus #27 ist auf diesem Zweig **nicht** enthalten. **Jede Faden-Zahl aus meinen Läufen von gestern Abend ist gegen einen anderen Prüfstand gemessen als den heutigen** |

> **Vor dem nächsten Lauf gehört `main` hereingeholt.** Sonst misst der Zweig gegen eine
> Prüfstrecke, die es in der Hauptspur nicht mehr gibt — und genau davor warnt `K23-M20`:
> ein Durchstich gegen einen alten Stand gilt als veraltet.

---

## 4 · Woher dieser Befund kommt — und was das über die Meldung sagt

**Er stammt aus dem Nachmessen einer Agentenmeldung, nicht aus ihr.**

Die Meldung führte *„#24 endgültig freigegeben"* als Erfolg und behandelte die Freigabe als
Fortschritt an der Sache. **Sie ist es nicht** — sie ist Fortschritt am Antrag. Der
Unterschied ist §12.3.

**Drei weitere Abweichungen der Meldung, gemessen:**

| | Meldung | Gemessen |
|---|---|---|
| 1 | *„sechs Commits"* auf `main` | **18** (oder **3**, wenn man nur die Merges zählt) — keine der beiden Zahlen ist sechs |
| 2 | *„BA-1-Gegenzeichnung … aus dem Repo-Stand allein nicht prüfbar"* | **Sehr wohl prüfbar** — die Zeichnungstabelle steht in der Datei, und sie ist leer. Ein `grep` genügt |
| 3 | *„#27 selbst gebaut / selbst gemerged"* | **Trifft zu** — Autor und Merger sind `AndrewExma`. Die Formulierung war nur missverständlich; kein Agent hat gemergt |

**Punkt 2 ist der ernste.** Die Meldung erklärte etwas für unmessbar, das mit einem Befehl zu
messen war — und schloss damit genau die Lücke aus, die den Vollzug sperrt.

---

## 5 · Handlungsempfehlung

| | Was | Wer | Dringlichkeit |
|---|---|---|---|
| **1** | **BA-1 in der Datei gegenzeichnen** — Zeile *A. Han*, Datum, im Blatt auf `main` | **A. Han** | ⛔ **hält die ganze Kette** |
| **2** | **Die Fremdprüfung abschicken** — Etikett auf #26 oder Ablauf von Hand anstoßen | **A. Han** | **heute fällig** |
| **3** | **`main` in `scheibe/m4-zweckbestimmung` hereinholen**, dann Lauf wiederholen | Harness | vor der nächsten Messung |
| **4** | **Die vier gestern gesetzten Kreuze in BA-1 gegen die Merge-Fassung prüfen** | Harness | sie sind mitgemergt und stimmen — hier bestätigt |

> **Zu 1, damit es nicht wieder verwechselt wird:** Es genügt **nicht**, #24 erneut
> freizugeben. Die Zeichnung ist ein Eintrag **in der Datei**, mit Namen und Datum, in der
> Tabelle unter *Zeichnung*. Erst dann greift §12.4, und erst dann darf der Vollzug der
> dreizehn Stellen beginnen.

---

*Erhoben am 17.08.2026 vom Orchestrator des Coding-Harness. Jede Aussage trägt den Befehl
daneben, der sie belegt. **Der Befund wirft A. Han nichts vor** — er hat heute mehr bewegt als
die drei Tage davor. Er hält fest, dass eine Freigabe und eine Zeichnung zwei Dinge sind, und
dass das Blatt in der Hauptspur erledigt aussieht, ohne es zu sein.*
