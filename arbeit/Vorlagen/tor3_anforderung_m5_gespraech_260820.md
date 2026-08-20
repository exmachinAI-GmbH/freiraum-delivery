# Fremdprüfung anfordern · Scheibe `m5-gespraech`

**20.08.2026 · Ausfertigung. Sie entscheidet nichts.** Jedes Feld in ⟨spitzen Klammern⟩
gehört einem Menschen.

| | |
|---|---|
| **Gegenstand** | M5 — das geführte Gespräch: EN-05, EN-06, die neun Serverbefehle, der Zeilenschutz M32 |
| **Zweig · Stand** | `scheibe/m5-gespraech` · `9efb5d4a0b4aae6b0de3db862fca64cdd2f08690` |
| **Anfordern** | ⟨Name⟩ — **ein Mensch. Der Harness tut es nicht** |
| **Anforderung abschicken bis** | ⟨Datum⟩ |
| **Urteil zurück bis** | ⟨Datum⟩ |
| **Blatt ablegen und zeichnen** | ⟨Name⟩ |
| **Erstellt** | 20.08.2026, vom Orchestrator des Coding-Harness |

---

## 0 · Der Vorbehalt — er steht bewusst vor allem anderen

**Der Harness schreibt dieses Review nie selbst.** Er holt nur seinen Nachweis herein.

Wörtlich aus `nachweise/fremdreview/README.md`:

> *„Ein Fremdmodell, das der Harness selbst aufruft, dessen Ausgabe er selbst ablegt und
> dessen Ergebnis er selbst auswertet, ist kein fremder Blick mehr — es ist derselbe Blick
> mit einem anderen Etikett."*

Und aus `nachweise/fremdreview/VORLAGE.md`:

> *„Ein von einem Agenten ausgefüllter Kopf ist kein Nachweis, sondern seine Fälschung."*

**Was der Harness beigesteuert hat:** dieses Blatt, die Belegliste mit Prüfsummen und die
Fragen. **Er hat kein Modell aufgerufen, keine Antwort erzeugt und keinen Kopf ausgefüllt.**

---

## 1 · Die Lage, gemessen am 20.08.2026

```
$ ./pruefungen/tor3.sh
Tor 3: kein Fremdreview abgelegt.
  Zustand: GESPERRT -- nicht gemessen ist nicht bestanden (K23-M22).
Tor 3 sperrt.
```

```
$ python3 werkzeuge/fremdreview.py
Tor 3: kein Fremdreview abgelegt.
  Zustand: GESPERRT
```

**Tor 3 ist bis heute für keine Scheibe gelaufen.** `nachweise/fremdreview/` enthält genau
zwei Dateien: `README.md` und `VORLAGE.md`. Kein Urteil, kein Blatt, keine Prüfsumme.

**Bis zum Endtermin am Montag, 31.08.2026, sind es elf Tage.** Die Zykluszeit einer
Fremdprüfung ist unbekannt, weil sie nie gemessen wurde. Wer den Weg zum ersten Mal am 28.08.
geht, erfährt zu spät, wie lange er dauert.

---

## 2 · Die Roh-Evidenz — **das wird vorgelegt, nicht der Baubericht**

`CLAUDE.md`:75 verlangt die Prüfung *gegen Roh-Evidenz, nicht gegen Erklärungen des Baus*.
Deshalb steht hier Quelltext, keine Zusammenfassung.

| Datei | Zeilen | SHA-256 (erste 16) |
|---|---|---|
| `migrations/M32__zeilenschutz_und_stufenwechsel.sql` | 299 | `6bac64bda3f021ea` |
| `migrations/negativfaelle/M32_N1_stufe_uebersprungen.sql` | 48 | `76592a2e20663854` |
| `migrations/negativfaelle/M32_N2_fremder_mandant.sql` | 49 | `1be048d8217145bb` |
| `migrations/negativfaelle/M32_N3_ohne_mitgliedschaft.sql` | 41 | `dc88eceaead661c5` |
| `migrations/negativfaelle/M32_N4_zeilenschutz_haelt.sql` | 74 | `f56e897f20e3f3a0` |
| `app/gespraech.py` | 2573 | `06d918a510701260` |
| `app/datenbank.py` | 505 | `f08a4325c689eaa9` |
| `app/vorlagen/en05_orientierung.html` | 800 | `27ed3ca15ba90cfc` |
| `app/vorlagen/en06_interview.html` | 497 | `a29b9ce70125f8c9` |
| `app/haupt.py` | 532 | `0963e010f103d165` |
| `werkzeuge/blindlauf.sh` | 191 | `6d24f99609a59476` |
| `werkzeuge/blindstand.sh` | 114 | `05ed75a9678dac49` |

**Ausdrücklich NICHT vorzulegen:** `arbeit/Bauberichte/`, `arbeit/Plaene/`, dieses Blatt,
und jede Datei, in der der Bau erklärt, was er getan hat.

---

## 3 · Was dem Fremdmodell fehlt — offen benannt

| | |
|---|---|
| **Tor 2 ist noch nicht fertig** | Die blinden Klausel-Prüffälle für M5 entstehen im Augenblick der Ausfertigung dieses Blattes. Liegen sie beim Absenden vor, gehören `pruefungen/klauseln/gespraech_*` zur Evidenz — **mit dem Vermerk, dass sie blind entstanden sind** |
| **Kein frisches Tor-1-Manifest für diesen Zweig** | Das jüngste liegt vom 14.08. Der letzte gemessene Lauf meldete **131 Einzelfälle bestanden, 0 fehlgeschlagen, 4 gesperrt** — die Ausgabe gehört mit vorgelegt, nicht die Zahl allein |
| **EN-04a hat keinen K19-Kasten** | Der Riegel meldet die Vorlage deshalb **GESPERRT**. Das ist kein Versehen des Baus, sondern ein offener Punkt der Konzept-Fabrik |
| **Die Antwortlisten fehlen im Wortlaut** | Zwölf Themen, sieben Ziele, drei Vorschlagslisten. Der gezeichnete Rückfallweg S-G trägt: der freie Weg funktioniert, die Auswahllisten melden die Lücke |

---

## 4 · Die Fragen an das Fremdmodell

**Nicht: „Ist das gut?"** Sondern sechs Fragen, die an der Roh-Evidenz beantwortbar sind:

1. **Zeilenschutz.** M32 schaltet `ENABLE` und `FORCE ROW LEVEL SECURITY` auf `app`,
   `document` und `event`. **Kommt eine Sitzung an Zeilen eines fremden Mandanten?**
   Prüfe die drei Regeln einzeln — besonders die `document`-Regel, die über `EXISTS` auf
   `app` geht, und die `event`-Regel, die `tenant_id IS NULL` zulässt.
2. **Der Weg daran vorbei.** Der Serverpfad setzt `freiraum.tenant_id`. **Gibt es einen Pfad
   in `app/`, der eine Verbindung benutzt, ohne ihn zu setzen?** Ein solcher Pfad macht den
   Zeilenschutz wirkungslos, ohne dass ein Test rot wird.
3. **Stufenwechsel.** `set_journey_phase` ist `SECURITY DEFINER`. **Prüft sie wirklich
   Konto, Mitgliedschaft, Rolle und Mandant — oder nur einen Teil davon?** Und: **kommt eine
   vom Client übergebene Stufe durch?**
4. **Die vier Negativfälle.** Scheitert jeder an **seiner eigenen** Bedingung — oder an einer
   fremden? Das ist der Fehler vom 02.08.2026, und er ist in diesem Repo schon zweimal
   aufgetreten.
5. **Die zwei Bildschirme.** EN-05 und EN-06 gegen ihre K19-Kästen: **zeigen sie etwas, das im
   Kasten nicht steht — oder fehlt etwas, das dort steht?**
6. **Was der Bau nicht gesehen hat.** Die offene Frage: **welche Annahme trägt hier still, die
   niemand aufgeschrieben hat?**

---

## 5 · Der Ablauf — fünf Schritte, und der erste gehört dem Menschen

```
  1  Mensch fordert an — frische Instanz, getrennter Kontext
        v
  2  Fremdmodell prüft gegen die Roh-Evidenz aus Abschnitt 2
        v
  3  Mensch legt das Urteil ab:
     nachweise/fremdreview/m5-gespraech_<JJMMTT>.md   + .sha256
     Urteil UNVERÄNDERT einsetzen — nicht zusammenfassen, nicht glätten
        v
  4  python3 werkzeuge/fremdreview.py   — prüft das BLATT, nicht das Urteil
        v
  5  ./pruefungen/tor3.sh               — meldet den Stand je Scheibe
```

---

## 6 · Was zu zeichnen ist

| | | |
|---|---|---|
| **1** | Die Fremdprüfung für `m5-gespraech` wird angefordert | ☐ ja · ☐ nein |
| **2** | Sie fordert an | ⟨Name: ⟩ |
| **3** | Abschicken bis | ⟨Datum: ⟩ |
| **4** | Die Roh-Evidenz aus Abschnitt 2 ist vollständig | ☐ so · ☐ ergänzen: ⟨ ⟩ |
| **5** | Die sechs Fragen aus Abschnitt 4 gehen so mit | ☐ so · ☐ ändern: ⟨ ⟩ |

| Name | Rolle | Datum |
|---|---|---|
| A. Han | für den Auftragnehmer (Nr. 158) | ⟨ ⟩ |
| M. Veil | für den Auftraggeber | ⟨ ⟩ |

---

*Der Harness hat für dieses Blatt kein Fremdmodell aufgerufen. Die Werkzeuge dieser Sitzung
könnten es — ein Modell eines anderen Anbieters ist erreichbar. Genau das ist der Grund, es
nicht zu tun: ein fremder Blick, den der Prüfling selbst bestellt, entgegennimmt und ablegt,
ist keiner. Wer diesen Weg dennoch gehen will, muss es im Kopf des Blattes wahrheitsgemäß
vermerken — dann ist es ein Zusatzblick, aber kein Tor 3.*
