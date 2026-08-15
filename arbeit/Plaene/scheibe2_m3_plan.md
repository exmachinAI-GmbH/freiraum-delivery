# Plan · Scheibe 2, erster Teil — M3 „Die Vorprüfung hält an"

| | |
|---|---|
| Zweig | `scheibe/vorpruefung-m3` |
| Meilenstein | **M3** · *„Die Vorprüfung hält an."* |
| Nachrechnung (Bauauftrag Z. 247, wörtlich) | *„ein Lauf, der am Halt endet, und **je einer über alle drei Auswege**: Antwort ändern (Rücknahme, `superseded_at`), Termin (Gespräch angestoßen), Zur Übersicht (EN-02, Eignungs-Check bleibt erhalten). K04-M08 verlangt genau drei"* |
| Klauselschnitt | **K04 · 49 Regeln** (Bauauftrag Z. 247, Spalte „Konzepte") · dazu die Bildschirme EN-02, EN-03, EN-04 aus `schema/K19_screens.yaml` |
| Angelegt | 15.08.2026 |

---

## 1 · Was gebaut wird — und was ausdrücklich nicht

**Gebaut wird der Weg bis zum Halt und die drei Auswege daraus.** Das ist genau, was die
Nachrechnung misst.

| Bildschirm | Was er kann | in dieser Scheibe |
|---|---|---|
| **EN-02** · Übersicht | *Neue Anwendung erstellen* → EN-03. Der Eignungs-Check bleibt beim Zurückkehren erhalten | **ja**, in der Minimalform: nur diese eine Aktion |
| **EN-03** · Vorprüfung 1 | zwei Wege: *Check starten* → EN-03a · *Überspringen* → EN-04 | **ja**, beide Wege — aber *Check starten* führt auf einen benannten Halt (siehe unten) |
| **EN-03a** · die fünf Fragen | Direkt-Prototyp-Check | **nein** — Begründung unten |
| **EN-04** · Eignungs-Check | drei Fragen, Halt, drei Auswege | **ja, vollständig** |
| **EN-04a** · Zweckbestimmung | gehört zu M4 | **nein** |

### Warum EN-03a nicht gebaut wird

`K04-M22` verlangt *„genau fünf Fragen, je Frage genau drei Antwortmöglichkeiten"*. **Der
Wortlaut dieser fünf Fragen existiert nirgends.** Die Sammelmigration hält das selbst fest:

> *„Die fünf Fragen selbst (Wortlaut) sind Konzeptinhalt (K04) und werden als Seed
> nachgereicht, sobald H09/Punkt 13 den Wortlaut zeichnet."*

Sie zu erfinden wäre genau das, was `CLAUDE.md` verbietet: *„Umfang erfinden. Was nicht in
den 24 gezeichneten Konzepten steht, wird nicht gebaut, sondern als offener Punkt
vorgelegt."*

**Folge für den Bau:** `EN-03` bietet beide Wege an. *Überspringen* führt nach EN-04.
*Check starten* zeigt eine benannte Meldung — *„Vorprüfung 1 ist noch nicht verfügbar: der
Wortlaut der fünf Fragen ist nicht gezeichnet (H09/Punkt 13)"* — und bleibt auf EN-03, ohne
etwas anzulegen. Das ist der im Bildschirmvertrag vorgesehene Fehlerzustand:
*„Fragenfluss nicht ladbar — Meldung, Verbleib auf EN-03; [Überspringen] bleibt offen, es
entsteht kein Vorschlag."*

**Die Nachrechnung von M3 ist davon nicht berührt** — sie misst Halt und Auswege, beides in
EN-04.

### Der zweite Vorbehalt: die Fragetexte des Eignungs-Checks

`fit_question.prompt_de` ist Pflicht, `K04-M04` verlangt genau drei Fragen — je eine für
*Art*, *Nutzung*, *Daten*. **Auch diese drei Fragetexte stehen in keiner Klausel.**

Was **wohl** wörtlich vorgegeben ist: die vier Antwortmöglichkeiten mit `is_eligible = falsch`
aus `K04-M07` — *„reine Netzseite"*, *„etwas zum Installieren auf Rechner oder Gerät"*,
*„Wegwerf-Versuch ohne Produktivbetrieb"* und bei der Datenfrage *„Nein — es geht um
Darstellung, Inhalte oder Gestaltung"*.

**Der Startbestand trägt deshalb sichtbar gekennzeichnete Platzhaltertexte** in der Form
`[ungezeichnet · H09/Punkt 13] Art der Anwendung?`. Die vier Ausschlussantworten stehen im
Wortlaut der Klausel. Der Platzhalter geht als offener Punkt zurück; er ist keine
Behauptung, sondern eine sichtbare Lücke.

---

## 2 · Die Wege — der Vertrag zwischen Bau und Prüfung

Beide Agenten arbeiten blind gegeneinander. **Diese Tabelle ist das Einzige, was beide
kennen.** Wer davon abweicht, erzeugt einen Fehlschlag, der nichts über die Klausel sagt.

| Weg | Verhalten |
|---|---|
| `GET /uebersicht` | **EN-02.** Ohne gültige Sitzung → 303 auf `/anmeldung`. Sonst 200 mit der Schaltfläche *Neue Anwendung erstellen*. Zeigt einen bestehenden Eignungs-Check dieses Kontos mit seinem Ergebnis an. **Ändert nichts** |
| `POST /uebersicht/neu` | Erfolg → 303 auf `/vorpruefung`. **Legt weder `app` noch `fit_check` an** (EN-02, `zustand_erfolg` wörtlich) |
| `GET /vorpruefung` | **EN-03.** 200 mit zwei Schaltflächen: *Check starten* und *Überspringen* |
| `POST /vorpruefung/starten` | 200, Verbleib auf EN-03 mit der benannten Meldung zum ungezeichneten Wortlaut. **Legt nichts an** |
| `POST /vorpruefung/ueberspringen` | Erfolg → 303 auf `/eignung`. Legt **einen** `fit_check` an: `tenant_id` und `actor_id` aus der Sitzung, `outcome = OFFEN`, `retention_class = KI_NACHWEIS` |
| `GET /eignung` | **EN-04.** 200: die drei Fragen in `position`-Reihenfolge, je Frage die Antwortmöglichkeiten, die aktive Antwort markiert. Bei `outcome = NICHT_GEEIGNET`: **das Halt-Feld an Stelle des Weiterwegs**, begründet, mit den drei Auswegen. Ohne offenen Check → 303 auf `/vorpruefung` |

**Nachtrag vom 15.08.2026 — wie die Halt-Seite aufgebaut ist.** Die Zeile oben war zu
unbestimmt: sie sagt, *dass* das Halt-Feld erscheint, nicht *was daneben stehen bleibt*.
Bau und Prüfung haben daraus Verschiedenes abgeleitet, und der Prüffall VP-14 konnte
deshalb weder grün noch rot melden — er blieb auf *gesperrt*, also ohne Messung. Der
Vertrag wird deshalb geschärft:

| Auf der Halt-Seite | |
|---|---|
| **Die Antwortformulare verschwinden.** Die drei Fragen und die gewählten Antworten bleiben **sichtbar**, aber nicht mehr absendbar | K04-M08 verlangt *„genau drei Auswege"*. Bliebe daneben ein absendbares Antwortformular stehen, sähe der Nutzer einen **vierten** Weg — auch wenn der Server ihn abweist |
| **Der Halt-Block trägt eine eigene, maschinell auffindbare Marke:** `<div id="halt">` | Ohne einen benannten Ort lässt sich der Begründungsbereich nur raten. Genau daran ist VP-14 gescheitert |
| **Im Halt-Block stehen:** die Begründung mit dem **Wortlaut der aufhaltenden Antwort** und die drei Auswege | K04-M09 (*„welche Antwort ihn aufhält"*) und K04-M08 |
| **Im Halt-Block steht nicht:** der Wortlaut einer Antwort, die **nicht** aufhält | Sonst unterscheidet die Begründung nichts — und *„welche"* verlangt eine Unterscheidung |

**Dieselbe Marke gilt für den Hinweis bei unvollständigem Check:** `<div id="hinweis">`,
und darin wird die **fehlende Frage beim Namen genannt** — der Bildschirmvertrag verlangt
wörtlich *„Hinweis nennt die fehlende Frage"*. Eine allgemeine Aufforderung genügt nicht.

*Warum dieser Nachtrag kein Weichmachen ist: er senkt keinen Prüfwert und ändert keine
Erwartung. Er benennt einen Ort, den beide Seiten bisher erraten mussten — und er
verschärft die inhaltliche Anforderung an beiden Stellen (Unterscheidung statt Vorkommen).*
| `POST /eignung/antwort` | Felder `frage` (= `fit_question.code`) und `option` (= `fit_option.id`). Erfolg → 303 auf `/eignung`. Bestehende aktive Antwort derselben Frage wird **zurückgenommen** (`superseded_at = now()`), nie gelöscht |
| `POST /eignung/aendern` | Feld `frage`. Nimmt die aktive Antwort zurück, ohne eine neue zu setzen. Setzt `outcome` auf `OFFEN` und `completed_at` auf `NULL` zurück. Erfolg → 303 auf `/eignung` |
| `POST /eignung/weiter` | Wertet aus. **GEEIGNET** nur, wenn zu allen drei Fragen genau eine nicht zurückgenommene Antwort vorliegt **und jede** `is_eligible = wahr` trägt (K04-M13). Sonst, wenn alle drei beantwortet sind und mindestens eine `is_eligible = falsch` trägt: **NICHT_GEEIGNET**. Fehlt eine Antwort: bleibt `OFFEN`, 200 mit benannter Meldung (K04-G04, fail-closed). Jedes Ergebnis außer OFFEN setzt `completed_at` **im selben Schreibvorgang** |
| `POST /eignung/termin` | **Ausweg 2.** Legt eine `event`-Zeile mit `action = 'TERMIN_ANGEFRAGT'` und Bezug auf den Check an. Erfolg → 303 auf `/eignung?termin=1`. **Ändert `outcome` nicht** |
| `GET /uebersicht` nach dem Halt | **Ausweg 3.** Der Check bleibt bestehen, `outcome` unverändert, keine Zeile getilgt (K04-D03) |

**Nach `outcome = GEEIGNET`** zeigt EN-04 einen Hinweis, dass der Zweckbestimmungs-Schritt
folgt — **gebaut wird er nicht** (EN-04a, gehört zu M4).

---

## 3 · Die Regeln, die dieser Schnitt trägt

Aus den 49 Regeln des K04 sind das die, die in dieser Scheibe gebaut und gemessen werden.
Die übrigen betreffen EN-03a, EN-04a oder das Zusammenspiel mit K01 und gehen nach M4.

| Regel | Was sie hier verlangt |
|---|---|
| **K04-M04** | genau drei Fragen, je eine je Dimension ART · NUTZUNG · DATEN |
| **K04-M05** | feste Reihenfolge über `fit_question.position` |
| **K04-M06** | jede Antwortmöglichkeit trägt `label_de`, `value_token`, `is_eligible`; kein Freitext |
| **K04-M07** | die vier Ausschlussantworten im Wortlaut |
| **K04-M08** | nach einem Halt **genau drei** Auswege |
| **K04-M09** | der Halt wird begründet — der Nutzer erfährt, welche Antwort ihn aufhält |
| **K04-M10** | jeder Check trägt einen Mandanten |
| **K04-M11** | `outcome` führt OFFEN · GEEIGNET · NICHT_GEEIGNET, Vorgabe OFFEN |
| **K04-M12** | jedes Ergebnis außer OFFEN trägt `completed_at` |
| **K04-M13** | GEEIGNET nur bei drei aktiven Antworten, alle `is_eligible = wahr` |
| **K04-M14** | je Frage höchstens eine nicht zurückgenommene Antwort |
| **K04-M15** | Änderung nimmt zurück und legt neu an |
| **K04-M16** | Aufbewahrungsklasse KI_NACHWEIS |
| **K04-D02** | nicht mehr und nicht weniger als drei Fragen |
| **K04-D03** | eine zurückgenommene Antwort wird **nicht entfernt** |
| **K04-D04** | NICHT_GEEIGNET führt nicht ins Gespräch, es entsteht keine Anwendung |
| **K04-D05** | kein zweiter Eignungsstrang neben `outcome` |
| **K04-D08** | ein Check eines fremden Mandanten gilt als nicht vorhanden |
| **K04-D11** | ein unvollständiger Check führt nicht zum Vorschlag *Direkt-Prototyp* |
| **K04-G04** | fail-closed: OFFEN, fehlende Antwort oder unlesbarer Check → gesperrt |
| **K04-G06** | ein Check besteht auch ohne Anwendung; `app_id` bleibt leer |
| **K04-G10** | EN-03 und EN-04 stammen aus K19 und werden nicht frei gezeichnet |

**Ausdrücklich nicht in dieser Scheibe:** K04-M01/M02/M03/M22/M23/M24/M25 (Direkt-Prototyp-
Check, Wortlaut ungezeichnet) · K04-M17/M18/M19/M20/M21 und K04-D09/D10 (Zweckbestimmung und
Anwendungsanlage, gehören zu M4) · K04-G01/G02/G03/G13 (Zusammenspiel mit K01).

---

## 4 · Was der Bau nicht anfassen darf

- **Kein Schema.** `fit_question`, `fit_option`, `fit_check`, `fit_answer` und die Sicht
  `app_fit_ok` stehen in `schema/freiraum_datamodel.sql` und M30. Sie werden **benutzt**,
  nicht geändert. Rang 1 der Quellenordnung gewinnt jeden Widerspruch.
- **Keine Datei unter `pruefungen/`.** Auch nicht „nur den Tippfehler".
- **Keine Migration.** Der Startbestand der drei Fragen kommt als **Seed**, nicht als
  Schemaänderung.
- **`app_fit_ok` ist kein Schreibschutz** (K04-D06). Die Sicht filtert, sie verhindert
  nichts.

## 5 · Was die Prüfung nicht sehen darf

Der Prüf-Agent schreibt seine Fälle **allein aus den Klauseln und dieser Wegetabelle** —
ohne den Umsetzungscode gesehen zu haben. Gibt eine Klausel keinen messbaren Maßstab her,
schreibt er **„NICHT PRÜFBAR aus der Klausel"** und nennt, welche Angabe fehlt. Er rät nie.

---

## 6 · Offene Punkte, die mit diesem Plan hinausgehen

| | |
|---|---|
| **O-M3-1** | Der Wortlaut der drei Eignungsfragen ist nicht gezeichnet. Der Startbestand trägt Platzhalter, sichtbar gekennzeichnet |
| **O-M3-2** | Der Wortlaut der fünf Fragen des Direkt-Prototyp-Checks ist nicht gezeichnet (H09/Punkt 13). EN-03a wird deshalb nicht gebaut |
| **O-M3-3** | `K04-G11` sagt selbst: *„Bis Antwortkatalog und Wiederanlauf aus O-K04-2 und O-K04-4 beschlossen sind, ist K04 nur Freigabekandidat; der Produktivweg bleibt gesperrt."* Dieser Bau ist damit ein Prüfstand, keine Produktivfreigabe |
| **O-M3-4** | `action = 'TERMIN_ANGEFRAGT'` — ob dieser Wert im Aufzählungstyp der `event`-Tabelle geführt wird, prüft der Bau. Fehlt er, ist das ein Befund, kein Anlass für eine Schemaänderung |
