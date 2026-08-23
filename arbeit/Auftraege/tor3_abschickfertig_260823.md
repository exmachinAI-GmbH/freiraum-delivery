# Tor 3 · Fremdprüfung `teilschnitt-anmeldung` — **abschickfertig, zweiter Durchgang**

**23.08.2026 · Zum Abschicken durch einen Menschen.**

> **Der Harness hat diese Anforderung NICHT abgeschickt und darf es nicht.** Eine frische
> Instanz, ein getrennter Zusammenhang und „der Harness hat es nicht geschrieben" sind drei
> der zwölf Pflichtangaben im Kopf des Urteilsblattes — bestätigen kann sie nur der
> Anfordernde. `werkzeuge/fremdreview.py` fängt ein Blatt ohne sie ab.

## Was sich seit dem ersten Durchgang geändert hat

Der erste Durchgang lief am **20.08.2026** gegen Commit `248baeda` und endete mit
**`trägt nicht`** und zwölf Gründen.

| | |
|---|---|
| **Grund 2** | behoben — `mfa_method` wird beim Anmelden gelesen und geprüft (PR #55) |
| **Grund 7** | entschieden — Beschluss Nr. 60 gilt, das Korrekturblatt zu K20-M25 liegt vor. **Am Bau war nichts zu ändern** |
| **Gründe 11 und 12** | als Prüfauftrag beim Prüf-Agenten — beides Messfehler, keine Baufehler |
| **M2** | Teilaussage 1 ist belegt: AC-16 bestanden, auf sauberem Arbeitsbaum, mit Manifest |
| **vier Akzeptanzkriterien** | gezeichnet (A. Han, 23.08.) — K03-M05, K03-M25, K20-M18, K20-M25 |
| **acht Gründe** | unverändert offen |

**Diese Tabelle ist für Sie, nicht für das Modell.** Warum, steht im nächsten Abschnitt.

---

## ⚠ Was dem Modell NICHT mitgegeben wird

**Die zwölf Gründe des ersten Urteils gehören nicht ins Belegpaket und nicht in den
Auftragstext.**

Der Auftrag verlangt ein Urteil **gegen Roh-Evidenz statt gegen Erklärungen**. Die zwölf
Gründe sind unsere Erklärung. Wer sie mitgibt, bekommt sie bestätigt und hat danach keine
zweite Meinung, sondern ein Echo.

**Die Reihenfolge ist umgekehrt:** blind urteilen lassen — **danach** vergleichen.

| Was der Vergleich zeigt | Was er wert ist |
|---|---|
| dieselben Gründe wie am 20.08. | Bestätigung; die Liste ist vollständig |
| **weniger** Gründe | die Behebungen wirken — belegt, nicht behauptet |
| **andere** Gründe | der eigentliche Ertrag des zweiten Durchgangs |

*Dieselbe Regel gilt für dieses Blatt: Was oben unter „Was sich geändert hat" steht, wird
nicht mitgeschickt.*

---

## Der geprüfte Stand

| | |
|---|---|
| **Abnahmeeinheit** | `teilschnitt-anmeldung` — **abschreiben, nicht tippen** (der Name wird gegen keine Liste gehalten; ein Tippfehler fällt nicht auf, Abweichung 4 des Werkzeugs) |
| **Commit** | ⟨nach dem Zusammenführen von #56 eintragen — `git rev-parse HEAD` auf sauberem Arbeitsbaum⟩ |
| **Zweig** | `main` |
| **Tor 1** | grün — 1a, 1b, 1c auf den zusammengeführten PRs |
| **Belegpaket** | ⟨`tor3_belege_teilschnitt-anmeldung_260823.zip`, erzeugt mit `werkzeuge/tor3_belege.py`⟩ |
| **Anfordernde Person** | ⟨…………⟩ |

> **`MT-88` ist kein Baubefund.** Die Zeile *„29 Funktionen, 2 ohne search_path"* stammt aus
> den Echtversand-Läufen vom 23.08.: Dort hatten die Prüfdaten `pruef_codewert` und
> `pruef_tokenwert` in derselben Datenbank angelegt. Gegen eine frische Datenbank ist Tor 1b
> grün. Falls die Belege eine solche Ausgabe enthalten, gehört dieser Satz **nicht** dazu —
> das Modell soll die Rohausgabe sehen und selbst urteilen.

## So wird abgeschickt — drei Handgriffe

| | |
|---|---|
| **1** | Eine **frische Instanz** eines fremden Modells öffnen — leerer Kontext, kein Vorgespräch, nicht dieselbe Sitzung, in der gebaut wurde (C-4) |
| **2** | Das **Belegpaket anhängen**. Ist es groß, zuerst `A_Pruefgegenstand` und `C_Massstab`, dann `B_Messungen` und `D_Nachweise` im selben Gespräch nachreichen — so lief es am 20.08. |
| **3** | Den Auftragstext **vollständig einfügen**: `arbeit/Auftraege/tor3_abschickfertig_260820.md`, Abschnitt *„Der Auftrag im Wortlaut"* — **unverändert** |

**Der Auftragstext wird nicht neu geschrieben.** Seine 24 Fragen sind aus dem Klauselwortlaut
abgeleitet und beim ersten Durchgang gelaufen. Ändert man sie zwischen zwei Durchgängen, sind
die Urteile nicht mehr vergleichbar — und der Vergleich ist der Zweck.

## Danach

1. Das Urteil **unverändert** ablegen: `nachweise/fremdreview/teilschnitt-anmeldung_260823.md`
   (Vorlage: `nachweise/fremdreview/VORLAGE.md`). Nicht zusammenfassen, nicht glätten.
2. Den Kopf ausfüllen — **zwölf Pflichtangaben**, vier davon nur vom Anfordernden zu
   bestätigen.
3. Prüfsumme danebenlegen, dann `python3 werkzeuge/fremdreview.py` und `bash pruefungen/tor3.sh`.
   **`tor3.sh` ohne Angabe einer Abnahmeeinheit aufrufen** — mit Angabe meldet es grün, wenn
   für die genannte Einheit gar kein Blatt vorliegt (Abweichung 3).
4. **Erst dann** das neue Urteil gegen die zwölf Gründe halten und die Tabelle in
   `arbeit/Vorlagen/tor3_zwoelf_gruende_260823.md` nachziehen.

---

*Ausgefertigt am 23.08.2026. Was hier fehlt, sind der Commit, das Paket und die anfordernde
Person — alle drei entstehen erst, wenn der Arbeitsbaum sauber ist und der Umfang von
`D_Nachweise` gezeichnet.*
