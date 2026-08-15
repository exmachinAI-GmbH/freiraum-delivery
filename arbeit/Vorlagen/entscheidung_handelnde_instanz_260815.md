# Entscheidung · Wer ist die handelnde Instanz, wenn ein Lauf handelt?

> **Der Nachweis verlangt zu jeder Änderung einen Handelnden. Ein Lauf ist keiner.**
> Der Harness legt die Möglichkeiten mit Preis und Folge vor. Entschieden wird von
> Menschen.

| | |
|---|---|
| Vorgelegt am | 15.08.2026 |
| Gefunden bei | Blatt 63 vom 11.08.2026 (Berichtigung zu Blatt 62), Möglichkeit B — dort als Folgepunkt gezeichnet |
| Betroffener Code | `schema/freiraum_datamodel.sql` (Tabelle `event`), `migrations/M30__pilot_sammelmigration.sql` (zwei Auslöser), jeder künftige Lauf |
| Kennung | **OF-INSTANZ-1** |
| Gleiche Frage, andere Kennung | **O-K02-9** in K02 v1.3 — dort fällig **vor der technischen Abnahme** |
| Zu zeichnen von | M. Veil · A. Han (die Antwort ändert eine Bauaufgabe: K15-Aufbewahrungslauf) |

**Ein Lauf** ist in diesem Blatt ein Vorgang, den kein Mensch auslöst: ein Aufräumlauf, der
abgelaufene Einladungen wegräumt, oder der Aufbewahrungslauf, der fällige Daten löscht. Er
hat keine Anmeldung, kein Konto und keine Sitzung.

---

## 1 · Die Frage in drei Sätzen

Jede Änderung muss im Nachweis einen Handelnden tragen. Bisher war das immer ein Mensch mit
Konto und Sitzung. Sobald ein Lauf schreibt, gibt es niemanden, den man dort eintragen
könnte — und das Feld bleibt entweder leer oder es steht etwas darin, das kein Konto ist.

Blatt 63 hat die Frage benannt und ausdrücklich **nicht** entschieden:

> *„Es ist die sauberere Lösung, aber es hängt an einer Frage, die niemand beantwortet hat —
> wer im Nachweis steht, wenn kein Mensch gehandelt hat. Der Bau-Agent hat sie ausdrücklich
> als offenen Punkt gemeldet, statt sich eine Kennung auszudenken. Diese Frage unter
> Termindruck zu entscheiden, wäre derselbe Fehler wie der, den dieses Blatt berichtigt."*
> — Blatt 63, Abschnitt 5

Am 15.08.2026 hat ein Bauvorschlag sie im Vorbeigehen beantwortet: kein Konto eintragen,
stattdessen den Datenbankbenutzer. Das ist unten **Möglichkeit A**. Es ist eine mögliche
Antwort, aber keine, die nebenbei fallen darf.

---

## 2 · Wo die Frage überall anschlägt — gemessen

Sechs gezeichnete Klauseln verlangen die handelnde Instanz. Wortlaut aus den Konzepten
K01, K02, K11 und K20, Fassung v2.9:

| Klausel | Art | Wortlaut |
|---|---|---|
| **K20-M18** | MUSS | *„Jede Änderung an Zugang, Rolle, Mitgliedschaft oder Einladung MUSS mit Zeitpunkt, **handelnder Instanz** sowie Wert davor und danach im internen Nachweis stehen (EXMA-Handbuch 5.6)."* |
| **K01-M21** | MUSS | *„Jeder Zustandswechsel MUSS nachweisbar geschrieben werden: Zeitpunkt, Projektnummer, **handelnde Instanz**, Wert davor und danach."* |
| **K02-M16** | MUSS | *„Der Protokolleintrag MUSS die handelnde Instanz benennen — **eine Person oder das System**, wenn ein Wechsel selbsttätig erfolgt."* |
| **K02-G13** | GILT | *„`actor_label` ist kein Identitätsnachweis. **Bis O-K02-9 entschieden ist**, muss der Server den Wert ausschließlich aus der gültigen Sitzung **oder aus einem fest benannten Systemvorgang** bilden; Nutzereingabe ist unzulässig."* |
| **K03-M20** | MUSS | *„Der Zustandsnachweis MUSS `actor.id` revisionsfest führen. `actor_label` bleibt Anzeige und ist kein Identitätsnachweis."* |
| **K11-G12** | GILT | *„Als handelnde Instanz erscheint im Protokoll **eine Person oder das System** — etwa wenn ein Zustandswechsel aus dem Gesprächsverlauf folgt."* |

**Zwei Dinge fallen auf, und sie sind der Schlüssel dieses Blatts.**

**Erstens: Die Konzepte kennen „das System" bereits.** K02-M16 und K11-G12 nennen es
ausdrücklich als zweite Möglichkeit neben der Person. Es muss also niemand einen Menschen
erfinden. Was fehlt, ist nicht die Erlaubnis, sondern die **Form**.

**Zweitens: K02-G13 nennt die Form sogar schon** — *„ein fest benannter Systemvorgang"*.
Der Satz steht in einer gezeichneten Klausel. Er ist nur nirgends in Datenmodell oder Bau
umgesetzt.

**Und die Frage hat bereits eine Kennung und eine Frist.** K02 v1.3, Zeile 333:

> **O-K02-9** — *„`event.actor_label` ist Freitext und verweist nicht auf `actor`. Wie bleibt
> die handelnde Identität nach Umbenennung, Kontolöschung **oder bei Systemvorgängen**
> revisionsfest?"* · Beteiligt: K00 · K03 · Datenmodell · **fällig: vor technischer Abnahme**

Der erste Teil von O-K02-9 — Umbenennung und Kontolöschung — ist gebaut: M30 hat die Spalte
`event.actor_id` ergänzt und beide Angaben aneinander gekoppelt (siehe Abschnitt 3). **Offen
ist genau der dritte Teil: die Systemvorgänge.** Das ist diese Vorlage.

---

## 3 · Was das Datenmodell hergibt — gemessen

Die Nachweistabelle heißt `event`. Zwei Spalten führen die handelnde Instanz:

`schema/freiraum_datamodel.sql`, Zeilen 528–540:

```sql
CREATE TABLE event (
  id          uuid PRIMARY KEY DEFAULT gen_random_uuid(),
  occurred_at timestamptz NOT NULL DEFAULT now(),
  project_no  text REFERENCES app(project_no) ON DELETE SET NULL,
  tenant_id   uuid REFERENCES tenant(id) ON DELETE SET NULL,
  actor_label text,                    -- <<< kein NOT NULL
  action      text NOT NULL,
  object_ref  text,
  change_type text,
  value       text,
  source      event_source NOT NULL,
  ...
);
```

Die zweite Spalte kommt aus der Sammelmigration. `migrations/M30__pilot_sammelmigration.sql`,
Zeile 735 und 744–748:

```sql
ALTER TABLE event ADD COLUMN IF NOT EXISTS actor_id uuid REFERENCES actor(id) ON DELETE SET NULL;
...
    ALTER TABLE event ADD CONSTRAINT event_actor_paarweise
      CHECK (actor_id IS NULL OR actor_label IS NOT NULL);
```

**Dürfen die Felder leer sein? Ja — und das ist die Lücke.**

| Fall | Erlaubt das Schema? | Bedeutung |
|---|---|---|
| Konto gesetzt **und** Name gesetzt | ja | der Normalfall: ein Mensch hat gehandelt |
| Konto leer, Name gesetzt | **ja** | genau der Fall, um den es hier geht — hier passt A, B, D und E hinein |
| Konto gesetzt, Name leer | **nein** — `event_actor_paarweise` weist es ab | ein gelöschtes Konto soll nicht den Namen mitnehmen |
| Konto leer **und** Name leer | **ja** | eine Nachweiszeile ganz ohne Handelnden. K20-M18 und K02-M16 wären verletzt, das Schema merkt es nicht |

**Das Schema erzwingt die handelnde Instanz also nicht.** Wer sie weglässt, bekommt keine
Fehlermeldung — nur eine Zeile, die niemandem zuzuordnen ist.

**Zwei weitere Messwerte, die für die Möglichkeiten unten zählen:**

**a) Die Herkunftsspalte kennt keinen Lauf.** `schema/freiraum_datamodel.sql`, Zeile 36:

```sql
CREATE TYPE event_source     AS ENUM ('PORTAL_ACTION','MODEL_CHANGE');
```

Zwei Werte: eine Bedienung im Portal, eine Änderung durch ein Modell. **Ein Lauf ist
weder das eine noch das andere.** Es gibt heute keinen Wert, mit dem eine Nachweiszeile
sagen könnte: *hier hat ein Lauf geschrieben.*

**b) „Das System" ist an anderer Stelle bereits ein gezeichneter Handelnder.**
`migrations/M30__pilot_sammelmigration.sql`, Zeile 74 und 815–816:

```sql
CREATE TYPE transition_authority AS ENUM ('SYSTEM','VERWALTER','ZWEI_PERSONEN');
...
  ('DISCOVERY','IN_BEARBEITUNG','SYSTEM','Stufe 02 betreten, Interview beginnt'),      -- W02
  ('IN_BEARBEITUNG','BEAUFTRAGT','SYSTEM','nur mit Zwei-Personen-Freigabe ...'),       -- W03
```

Bei den Zustandswechseln ist `SYSTEM` ein eigener, gleichrangiger Wert neben Mensch und
Vier-Augen-Freigabe — gezeichnet in H02 vom 04.08.2026. Beim Nachweis fehlt dieselbe
Unterscheidung. **Dieselbe Sache ist an einer Stelle sauber modelliert und an der anderen
nicht.**

---

## 4 · Wo heute schon ein Lauf schreibt, ohne dass ein Mensch handelt — gemessen

Gesucht mit `grep -n "INSERT INTO event" migrations/M30__pilot_sammelmigration.sql` und
`grep -rn "current_user"`. Ergebnis: **drei Auslöser schreiben ohne Bedienung, zwei davon
ohne jedes Konto.**

| # | Stelle | Was geschrieben wird | Handelnde Instanz heute |
|---|---|---|---|
| 1 | `tenant_domain_audit()` · M30:936–943 | Änderung der Einladungsdomäne eines Kunden | `actor_label = current_user`, `actor_id` **nicht gesetzt**, `source = 'MODEL_CHANGE'` |
| 2 | `tenant_invite_domain_audit()` · M30:1845–1856 | Aufnahme oder Wegfall einer zugelassenen Einladungsdomäne | `actor_label = current_user`, `actor_id` **nicht gesetzt**, `source = 'PORTAL_ACTION'` |
| 3 | `session_event_writer()` · M30:962–966 | jede Anmeldung | `actor_id` und `actor_label` aus dem Konto — **hier hat ein Mensch gehandelt**, der Auslöser schreibt nur mit |

Der Wortlaut der beiden ersten, Zeile 939 und 1851:

```sql
    VALUES (NEW.id, current_user, 'EINLADUNGSDOMAENE_GEAENDERT', ...
    VALUES (m, 'PORTAL_ACTION', 'INVITE_DOMAIN_CHANGED', current_user, ...
```

`current_user` ist der **Datenbankbenutzer**, unter dem die Verbindung läuft — nicht der
Mensch und nicht der Vorgang. **Möglichkeit A ist also nicht neu. Sie ist zweimal gebaut,
ohne dass sie je entschieden wurde.** Das ist der eigentliche Anlass dieses Blatts: Was hier
entschieden wird, bestätigt oder berichtigt zwei bestehende Stellen.

**Ein vierter Fall trägt gar keine handelnde Instanz.** `app_state_history_sync()`
(M30:709–727) schreibt die Verlaufszeile jedes Zustandswechsels. Die Zieltabelle hat kein
Feld dafür — `schema/freiraum_datamodel.sql`, Zeilen 487–493:

```sql
CREATE TABLE app_state_history (
  app_id  uuid NOT NULL REFERENCES app(id) ON DELETE CASCADE,
  state   lifecycle_state NOT NULL,
  gueltig daterange NOT NULL,
  ...
);
```

K01-M21 verlangt die handelnde Instanz zu jedem Zustandswechsel und benennt `event` als
Träger des Protokolleintrags. Die Verlaufszeile allein trägt sie nicht. **Das ist ein
angrenzender Befund, keine Frage dieses Blatts** — er wird in Abschnitt 8 als Folge geführt.

**Und zwei gezeichnete Läufe sind noch gar nicht gebaut:**

| Lauf | Gezeichnete Grundlage | Was er tut |
|---|---|---|
| **Aufbewahrungslauf** | K15-M13, K15-M19, K01-M33, K10-G03 | löscht fällige Daten in festem Takt. K10-G03: *„ausgelöst wird sie allein vom Aufbewahrungslauf, **nie von einer Bedienung** (F36)"* |
| **Aufräumlauf Einladungen** | Blatt 63, Möglichkeit B — als Folgepunkt gezeichnet | entfernt Mitgliedschaften zu verfallenen Einladungen |

Der Aufbewahrungslauf ist der schwerste Fall: **er löscht.** Jede gelöschte Zeile braucht
einen Nachweis, und dieser Nachweis ist zugleich der Datenschutznachweis. Wenn dort der
Datenbankbenutzer steht, steht im Löschnachweis nicht, welcher Lauf gelöscht hat.

---

## 5 · Die Möglichkeiten

### A · Der Datenbankbenutzer

`actor_label` bekommt `current_user`, `actor_id` bleibt leer. So ist es an den zwei Stellen
aus Abschnitt 4 heute gebaut.

| | |
|---|---|
| **Preis** | **null.** Kein Bau, keine Migration, kein Konzeptsatz. Zwei Stellen laufen bereits so |
| **Folge** | Im Nachweis steht der Name der **Verbindung**, nicht der Name des **Vorgangs**. Läuft der Aufräumlauf, der Aufbewahrungslauf und der Serverpfad unter demselben Benutzer, tragen alle drei denselben Eintrag — im Nachweis sind sie ununterscheidbar |
| **Folge** | Der Wert **wechselt mit der Umgebung.** In `aufbau.sh` läuft die Migration unter einem anderen Benutzer als der Anwendungspfad. Derselbe Vorgang trägt dann in Prüfumgebung und Pilot verschiedene Namen — der Nachweis ist nicht vergleichbar |
| **Folge** | K02-G13 verlangt einen *„fest benannten Systemvorgang"*. Der Datenbankbenutzer ist fest, aber er benennt keinen Vorgang. **Buchstabe knapp erfüllt, Zweck nicht** |
| **Folge** | Wer den Nachweis liest, kann nicht prüfen, ob es den genannten Handelnden gibt. `current_user` verweist auf nichts, was im Bestand steht |

### B · Ein besonderer Wert im Namensfeld

`actor_label` bekommt einen festen Text, etwa `SYSTEM:AUFRAEUMLAUF_EINLADUNGEN`.
`actor_id` bleibt leer.

| | |
|---|---|
| **Preis** | **klein.** Keine Migration. Nötig sind eine geschlossene Liste zulässiger Werte und eine Prüfung, dass kein Freitext hineinrutscht |
| **Folge** | Der Vorgang ist benannt. **K02-G13 ist im Wortsinn erfüllt** — genau das meint *„fest benannter Systemvorgang"* |
| **Folge** | Mensch und Lauf stehen in **derselben Spalte**. Wer sie maschinell trennen will, muss den Text auf ein Vorzeichen wie `SYSTEM:` absuchen. Eine Unterscheidung, die an einer Zeichenkette hängt, bricht still, sobald jemand den Text ändert |
| **Folge** | Die Protokollansicht im Portal zeigt `actor_label` als Namen (`schema/K19_screens.yaml`:1029). Dort erschiene ein Lauf in derselben Spalte wie eine Person. Der Bildschirmvertrag braucht einen Satz dazu |
| **Folge** | `actor_id` bleibt leer. **K03-M20 („`actor.id` revisionsfest") ist für diese Zeilen nicht erfüllt** — es gibt keine Kennung, gegen die man verbinden könnte |

### C · Eine eigene Dienstidentität je Lauf

Jeder Lauf bekommt eine echte Zeile in `actor` — ohne Mitgliedschaft, ohne Anmeldemöglichkeit.
`actor_id` und `actor_label` sind dann normal gefüllt.

| | |
|---|---|
| **Preis** | **hoch, und der Preis ist nicht der Bau, sondern das, was man dafür erfinden muss.** `actor` verlangt `email text NOT NULL UNIQUE` und `tenant_id uuid NOT NULL` (`schema/freiraum_datamodel.sql`:148–152). Ein Lauf hat keine E-Mail-Adresse und gehört keinem Kunden. Man müsste **beides erfinden** — eine Adresse in genau der Spalte, die sonst der Anmeldename ist, und eine Kundenzuordnung für etwas, das über alle Kunden hinweg arbeitet |
| **Preis** | `actor` gehört zu K03 (Anmeldung). Eine Zeile darin ist immer auch eine **mögliche Tür**. Sie bliebe nur deshalb zu, weil ihr die Mitgliedschaft fehlt — eine Sperre durch Abwesenheit, nicht durch Bedingung. Das ist die schwächste Art, eine Tür zuzuhalten |
| **Preis** | Die Rechteprüfungen zählen Konten. `platform_admin_guard()` zählt aktive EXMA-Konten (`schema/freiraum_datamodel.sql`:610–616) und die drei Bedingungen aus K20-G05 müssten die Dienstzeilen ausdrücklich ausnehmen. Jede vergessene Ausnahme ist ein Zählfehler bei einer Sicherheitsregel |
| **Folge** | **K20-M18, K02-M16 und K03-M20 wären vollständig erfüllt** — Kennung und Name, verbindbar, revisionsfest. Die sauberste Antwort auf dem Papier |
| **Folge** | Der Nachweis behauptet, ein Konto habe gehandelt. **Es gibt kein Konto.** Der Preis für die formale Sauberkeit ist eine Unwahrheit im Bestand |

### D · Das Feld leer lassen, die Herkunft anders belegen

`actor_id` und `actor_label` bleiben beide leer. Stattdessen sagt die Herkunftsspalte
`source`, dass ein Lauf geschrieben hat — dafür braucht der Aufzählungstyp einen dritten
Wert neben `PORTAL_ACTION` und `MODEL_CHANGE`.

| | |
|---|---|
| **Preis** | **mittel.** Eine Migration für den neuen Wert. `event_actor_paarweise` erlaubt beide Felder leer, es ist keine Bedingung zu ändern |
| **Folge** | **Ehrlich.** Es wird nichts eingetragen, was es nicht gibt. Kein erfundenes Konto, keine erfundene Adresse |
| **Folge** | **K20-M18 und K02-M16 verlangen wörtlich, dass die handelnde Instanz *benannt* wird.** Ein leeres Feld benennt nichts. Die Möglichkeit trägt nur, wenn zugleich im Konzept festgehalten wird, dass die Herkunftsspalte diese Benennung leistet — das ist eine **Konzeptänderung**, nicht nur eine Migration |
| **Folge** | Alle Läufe sähen gleich aus. `source = SYSTEM_LAUF` sagt *ein Lauf war es*, nicht *welcher*. Beim Aufbewahrungslauf, der löscht, ist das zu wenig |
| **Folge** | Prüfläufe, die heute `actor_label IS NOT NULL` messen (`pruefungen/klauseln/anmeldecode_lauf.sh`:842–843, `einloesung_lauf.sh`:388), müssten je Fall unterscheiden |

### E · Zwei Angaben statt einer: getippte Herkunft **und** benannter Lauf

Die Herkunftsspalte `source` bekommt den neuen Wert `SYSTEM_LAUF` — damit ist **maschinell**
erkennbar, dass kein Mensch gehandelt hat. `actor_label` trägt den **Namen des Laufs** aus
einer geschlossenen Liste, die als eigene kleine Tabelle im Bestand steht (etwa
`system_run` mit Kennung und Name). `actor_id` bleibt leer — es gibt kein Konto, und es wird
keines behauptet.

| | |
|---|---|
| **Preis** | **mittel.** Eine Migration: ein Aufzählungswert, eine Tabelle mit zwei Spalten, eine Bedingung („ist `source = SYSTEM_LAUF`, dann steht in `actor_label` ein Name aus der Liste, und `actor_id` ist leer"). Ein Satz im Bildschirmvertrag K19, damit die Protokollansicht einen Lauf als Lauf zeigt und nicht als Person |
| **Folge** | Die Unterscheidung Mensch/Lauf hängt an einer **getippten Spalte**, nicht am Absuchen eines Textes. Sie bricht nicht still |
| **Folge** | Der Name ist **prüfbar**: er steht in einer Tabelle. Wer den Nachweis liest, kann nachschlagen, ob es den Lauf gibt. Genau das kann bei A und B niemand |
| **Folge** | **K02-G13 ist erfüllt** — fest benannter Systemvorgang, aus dem Bestand gebildet, keine Nutzereingabe. **K02-M16 und K11-G12 sind erfüllt** — „das System" ist benannt |
| **Folge** | **K03-M20 bleibt für diese Zeilen offen** und muss es bleiben: es gibt keine `actor.id`. Das braucht einen klarstellenden Satz in K02 oder K03 — *der Zustandsnachweis führt `actor.id` revisionsfest, wo ein Konto gehandelt hat; wo ein Lauf gehandelt hat, führt er die Kennung des Laufs.* **Das ist eine Konzeptänderung und geht über die Konzept-Fabrik** |
| **Folge** | Die bestehenden Prüfläufe bleiben grün: sie messen `actor_label IS NOT NULL`, und das ist gesetzt |

---

## 6 · Empfehlung des Harness — ein Vorschlag, keine Entscheidung

**Möglichkeit E.**

**Warum nicht A:** Sie ist gratis, und sie ist die einzige, die bereits gebaut ist — aber sie
beantwortet die Frage nicht, sie umgeht sie. Der Datenbankbenutzer ist eine Eigenschaft der
Verbindung, keine Aussage über den Vorgang. Er wechselt mit der Umgebung, und er lässt sich
nicht nachschlagen. Beim Aufbewahrungslauf, der löscht, hieße das: der Löschnachweis nennt
nicht, wer gelöscht hat. **Das ist genau die Art von Antwort, vor der Blatt 63 gewarnt hat.**

**Warum nicht C:** Sie ist auf dem Papier die sauberste und im Bestand die unehrlichste. Für
formale Vollständigkeit müsste man eine E-Mail-Adresse und eine Kundenzuordnung erfinden — in
genau der Tabelle, aus der Anmeldungen kommen. Ein Konto, das kein Konto ist, in der
Kontotabelle, gehalten von der Abwesenheit einer Mitgliedschaft. Der Aufwand ist hoch und
das Ergebnis ist eine Behauptung.

**Warum nicht B oder D allein:** B benennt, unterscheidet aber nicht — Mensch und Lauf teilen
sich eine Textspalte. D unterscheidet, benennt aber nicht — alle Läufe sähen gleich aus. **E
ist nicht ein Kompromiss aus beiden, sondern die Feststellung, dass die Frage zwei Teile
hat:** *war es ein Mensch?* ist eine Ja-Nein-Frage und gehört in eine getippte Spalte. *Welcher
Vorgang war es?* ist eine Namensfrage und gehört in ein Namensfeld mit prüfbarem Bestand.

**Was für E den Ausschlag gibt:** Die gezeichneten Klauseln haben die Antwort im Wesentlichen
schon gegeben, und niemand hat sie umgesetzt. K02-M16 und K11-G12 erlauben „das System"
ausdrücklich. K02-G13 nennt die Form: *„ein fest benannter Systemvorgang"*. Und bei den
Zustandswechseln ist `SYSTEM` seit dem 04.08.2026 ein eigener, gleichrangiger Wert neben
Mensch und Vier-Augen-Freigabe. **E baut nichts Neues aus, sondern zieht beim Nachweis nach,
was an drei anderen Stellen bereits gezeichnet ist.**

**Der Vorschlag ist ein Vorschlag. Er nimmt die Entscheidung nicht vorweg und darf nie als
Freigabe gelesen werden.**

---

## 7 · Was aus jeder Entscheidung folgt

| Entscheidung | Was zu tun ist |
|---|---|
| **A** — Datenbankbenutzer | Kein Bau. Die zwei Stellen aus Abschnitt 4 sind damit **nachträglich gedeckt**. Ein Satz in K02 hält fest, dass der Datenbankbenutzer als *fest benannter Systemvorgang* nach K02-G13 gilt. Aufzunehmen als **Restrisiko**: der Nachweis unterscheidet Läufe nicht und ist zwischen Umgebungen nicht vergleichbar |
| **B** — besonderer Wert | Eine geschlossene Werteliste festlegen und im Serverpfad durchsetzen. Die zwei Stellen aus Abschnitt 4 werden **berichtigt** (`current_user` → fester Name). Ein Satz im Bildschirmvertrag K19 zur Protokollansicht |
| **C** — Dienstidentität | Migration für die Dienstzeilen. **Erfundene E-Mail-Adresse und Kundenzuordnung müssen gezeichnet werden** — sie widersprechen K23-M12 (nur synthetische Daten, gekennzeichnet) nicht, brauchen aber eine ausdrückliche Kennzeichnung. Alle Rechteprüfungen und die drei Bedingungen aus K20-G05 sind auf die Ausnahme zu prüfen |
| **D** — Feld leer | Migration für den neuen Herkunftswert. **K20-M18 und K02-M16 sind zu ändern**, damit ein leeres Namensfeld die Benennung nicht verletzt. Konzeptänderung über die Konzept-Fabrik |
| **E** — getippte Herkunft und benannter Lauf | Migration: Aufzählungswert `SYSTEM_LAUF`, Tabelle der Läufe, Bedingung. Die zwei Stellen aus Abschnitt 4 werden **berichtigt**. **Klarstellender Satz zu K03-M20** über die Konzept-Fabrik. Satz im Bildschirmvertrag K19 |
| **Keine Entscheidung** | Der Aufräumlauf aus Blatt 63 bleibt liegen. **Der Aufbewahrungslauf nach K15-M13 kann nicht gebaut werden** — er löscht, und der Löschnachweis hätte keinen Handelnden. O-K02-9 bleibt offen, obwohl es **vor der technischen Abnahme** fällig ist. Nach Blatt 11:137 braucht jedes kritische Restrisiko eine **gezeichnete Annahmeentscheidung** — die Liste allein genügt nicht |

---

## 8 · Was sonst noch an dieser Antwort hängt

Die Frage wirkt weit über den Aufräumlauf hinaus. **Acht Stellen** warten auf sie:

| # | Was hängt daran | Belegt durch | Gewicht |
|---|---|---|---|
| 1 | **O-K02-9** — dieselbe Frage, in K02 als offener Punkt geführt, **fällig vor der technischen Abnahme** | K02 v1.3:333 | Tor II des Bauauftrags |
| 2 | **Der Aufbewahrungslauf.** Er löscht in festem Takt und ohne Bedienung. Jede gelöschte Zeile braucht einen Nachweis; der Löschnachweis ist zugleich der Datenschutznachweis | K15-M13, K15-M19, K01-M33, K10-G03 | **das schwerste Stück** |
| 3 | **Die Einschränkung nach Löschverlangen (H1).** Läuft die Frist ab, löscht der Aufbewahrungslauf *„OHNE neues Verlangen"* — kein Mensch handelt, und trotzdem muss nachvollziehbar bleiben, wer die Zeile entfernt hat | M30:2086–2091, gez. A. Han 05.08.2026 | Datenschutz |
| 4 | **Der Aufräumlauf für verfallene Einladungen** — der Anlass dieses Blatts | Blatt 63, Möglichkeit B, gez. 11.08.2026 | Folgepunkt |
| 5 | **Agentenläufe.** Ändert ein Agent Verdrahtung, Modell, Schlüssel oder Freigabestatus, entsteht ein Protokolleintrag in `event`. Wer ist dann die handelnde Instanz — der Agent, das Modell, der Mensch, der ihn angestoßen hat? | K17-M18, K17-M37, K17-M43 | **breit** |
| 6 | **Die zwei bereits gebauten Stellen.** Sie laufen heute nach Möglichkeit A, ohne Zeichnung. Jede Entscheidung außer A ist zugleich eine Berichtigung an M30 | M30:939, M30:1851 | bestehender Bau |
| 7 | **Die Protokollansicht im Portal.** Sie zeigt `actor_label` als Namensspalte. Erscheint dort ein Lauf, braucht der Bildschirmvertrag eine Regel, wie er dargestellt wird | `schema/K19_screens.yaml`:1029 | Bedienung |
| 8 | **`app_state_history` trägt gar keine handelnde Instanz** — die Tabelle hat kein Feld dafür, während K01-M21 sie zu jedem Zustandswechsel verlangt. Zwei Wechsel (W02, W03) sind als `SYSTEM` gezeichnet | `schema/freiraum_datamodel.sql`:487–493, M30:815–816 | angrenzender Befund |

**Nicht belegt:** Ob die Antwort auf diese Frage auch für den Nachweis der Modelläufe gilt
(`source = 'MODEL_CHANGE'`). Der Wert existiert seit v2.9 im Schema, wird aber im Repo nur an
einer Stelle geschrieben (M30:942). Ob ein Modelllauf ein Lauf im Sinne dieses Blatts ist,
ist in keiner gemessenen Klausel entschieden.

---

## 9 · Was gemessen ist, und was nicht

**Gemessen:** Die Klauselwortlaute (Abschnitt 2, Dateien und Zeilen genannt). Die
Nullbarkeit der beiden Nachweisspalten und die Kopplungsbedingung (Abschnitt 3). Die zwei
Werte des Aufzählungstyps `event_source`. Die drei Auslöser, die ohne Bedienung schreiben,
und die zwei davon, die `current_user` eintragen (Abschnitt 4). Die Pflichtspalten von
`actor` (Abschnitt 5 C).

**Nicht gemessen, weil nicht ausführbar:** Es lief keine Datenbank
(`pg_isready` → `/tmp:5432 - no response`). Alle Aussagen dieses Blatts sind am Quelltext von
Schema, Migration und Serverpfad gemessen, nicht an einem Lauf. Eine Gegenprobe an einer
frischen Datenbank steht aus.

**Nicht entscheidbar durch Messung:** Ob „das System" im Sinne von K02-M16 der
Datenbankbenutzer, ein benannter Vorgang oder eine Identität ist. Das ist eine Frage der
Festlegung, keine der Messung. **Genau deshalb liegt dieses Blatt vor.**

---

## Menschliche Entscheidung

- [ ] **A** — Der **Datenbankbenutzer** steht im Namensfeld. Die zwei gebauten Stellen
      bleiben, wie sie sind.
- [ ] **B** — Ein **fester Name des Laufs** steht im Namensfeld, aus geschlossener Liste.
      Kein Konto.
- [ ] **C** — Jeder Lauf bekommt eine **eigene Dienstidentität** als Konto ohne
      Anmeldemöglichkeit.
- [ ] **D** — Das Namensfeld **bleibt leer**; die Herkunftsspalte trägt, dass ein Lauf
      geschrieben hat.
- [ ] **E** — **Beides getrennt:** die Herkunftsspalte sagt *ein Lauf war es*, das Namensfeld
      sagt *welcher*, geprüft gegen eine Liste im Bestand. Kein Konto und keines behauptet.
- [ ] **Anders**, nämlich:
- [ ] **Nicht entschieden** — weil:

| Name | Rolle | Datum | Begründung / Auflagen |
|---|---|---|---|
| **M. Veil** | für den Auftraggeber | | |
| **A. Han** | für den Auftragnehmer | | |

---

*Dieses Blatt legt fünf Möglichkeiten mit ihrem Preis und ihren Folgen nebeneinander und
spricht eine Empfehlung aus. Es entscheidet nichts. Der Harness entscheidet keine offene
Frage still (`CLAUDE.md` §6) — er benennt sie und legt sie vor. Blatt 63 hat diese Frage am
11.08.2026 ausdrücklich nicht unter Termindruck entschieden; dieses Blatt hält sie in
derselben Haltung offen und gibt ihr nur die Form, die sie zum Zeichnen braucht.*
