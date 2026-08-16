# E-6 · Nachmessung der ungemessenen Zustände

**Erhoben am 16.08.2026 auf Weisung von M. Veil (B-21, Kreuz „Nachmessen").**

| | |
|---|---|
| **Anlass** | E-6 aus Blatt 82 (`82_ZEICHNUNGSVORLAGE_E1-E6_260811.md`): *„Gemessen wurden 26 Farbpaare auf **einer** Seite. Nicht gemessen: Mauszeiger-, Tastatur- und Sperrzustände, Platzhaltertext, alle übrigen Bildschirme."* |
| **Weisung** | *„Jetzt nachmessen. Der Wert wird geprüft, bevor entschieden wird."* — M. Veil, 16.08.2026 |
| **Gegenstand** | alle acht Vorlagen unter `app/vorlagen/` |
| **Stand** | Commit `b215dd73f9a2950cdb3a86bb6a90805df98d8f52`, Zweig `scheibe/m4-zweckbestimmung` |
| **Zustand nach K23-M22** | **teils bestanden, teils gesperrt** — siehe Abschnitt 4. Kein Teil dieses Blattes darf als *bestanden* zusammengefasst werden |

---

## 1 · Das Ergebnis in einem Satz

**Es ist nichts zu messen, weil nichts gesetzt ist.** Die acht Vorlagen enthalten
**keinen einzigen Farbwert und keine einzige Zustandsregel.** Damit hat E-6 kein
Messobjekt im Bau — der Punkt ist nicht *schlecht* gemessen, er ist am Bau **nicht
messbar**, und zwar aus einem benennbaren Grund.

---

## 2 · Was gemessen wurde — die Befehle stehen daneben

### 2.1 Farbwerte im Bau

```
$ grep -rnoE '#[0-9A-Fa-f]{3,8}\b|rgba?\(|hsla?\(|\b(color|background(-color)?|border-color|outline-color)\s*:' app/ | grep -v currentColor
(keine Ausgabe)
```

**Null Treffer über alle acht Vorlagen.** Kein Hexwert, kein `rgb()`, kein `hsl()`, keine
gesetzte Vorder- oder Hintergrundfarbe. Die einzige Farbangabe im gesamten Bau ist
`currentColor`, also die ausdrückliche Weigerung, eine Farbe zu setzen.

### 2.2 Zustandsregeln im Bau

```
$ grep -rnoE ':(hover|focus|focus-visible|focus-within|active|disabled|placeholder|placeholder-shown|invalid|checked|visited)\b|\[disabled\]|\[aria-disabled' app/
(keine Ausgabe)
```

**Null Treffer.** Es gibt im Bau keine Regel für den Mauszeigerzustand, keine für den
Tastaturfokus, keine für den gesperrten Zustand, keine für Platzhaltertext. **Genau die
vier Zustände, die E-6 als ungemessen benennt, sind im Bau nicht gestaltet.**

### 2.3 Fokusring

```
$ grep -rn 'outline' app/
(keine Ausgabe)
```

**Kein `outline`, keine `outline-offset`, kein `box-shadow` als Fokusersatz.** Der
Fokusring der fünf Bildschirme ist **vollständig der des Browsers**.

### 2.4 Was stattdessen dasteht

```
$ grep -rn 'color-scheme' app/vorlagen/
app/vorlagen/start.html:18:                :root { color-scheme: light dark; }
app/vorlagen/en01_anmeldung.html:27:        :root { color-scheme: light dark; }
app/vorlagen/en02_uebersicht.html:30:        :root { color-scheme: light dark; }
app/vorlagen/en03_vorpruefung.html:33:        :root { color-scheme: light dark; }
app/vorlagen/en04_eignung.html:155:       :root { color-scheme: light dark; }
app/vorlagen/en04a_zweckbestimmung.html:98: :root { color-scheme: light dark; }
app/vorlagen/einladung.html:24:             :root { color-scheme: light dark; }
app/vorlagen/einladung_senden.html:27:      :root { color-scheme: light dark; }
```

**Acht von acht Vorlagen** überlassen Farbe und Kontrast dem Betriebssystem. Alle
Formatangaben zusammen sind **177 Zeilen** über acht Dateien — Abstände, Rahmenstärken,
Schriftgrößen, sonst nichts.

### 2.5 Was an Bedienelementen überhaupt da ist

*Gezählt über das Markup, nicht geschätzt.*

| Vorlage | `button` | `a` | `input` | Bildschirmkennung |
|---|---|---|---|---|
| `en01_anmeldung.html` | 1 | 0 | 2 | **EN-01** |
| `en02_uebersicht.html` | 2 | 1 | 0 | **EN-02** |
| `en03_vorpruefung.html` | 2 | 1 | 0 | **EN-03** |
| `en04_eignung.html` | 5 | 3 | 4 | **EN-04** |
| `en04a_zweckbestimmung.html` | 6 | 3 | 5 | **EN-04a** |
| **Summe der fünf Bildschirme** | **16** | **8** | **11** | **= 35 Bedienelemente** |
| `start.html` | 1 | 0 | 0 | Hilfsseite |
| `einladung.html` | 1 | 0 | 1 | Hilfsseite |
| `einladung_senden.html` | 1 | 0 | 2 | Hilfsseite |

**35 Bedienelemente auf fünf Bildschirmen, keines mit einer eigenen Zustandsgestaltung.**

### 2.6 Zustandsangaben im Markup

```
$ grep -rnoE '\b(disabled|readonly|required|aria-disabled|aria-invalid|placeholder)=?' app/vorlagen/
   2 required
```

**Zwei `required`, sonst nichts.** Kein `disabled`, kein `placeholder`, kein
`aria-invalid`. Der Bau kennt heute **keinen gesperrten Zustand und keinen
Platzhaltertext** — die beiden Zustände, deren Kontrast E-6 vermisst, **existieren im
Bau nicht.**

---

## 3 · Was daraus folgt — und was ausdrücklich nicht

### 3.1 Die Lücke ist eine andere als angenommen

E-6 liest sich, als seien Zustände gestaltet und nur nicht vermessen worden. **Gemessen
gilt das Gegenteil:** Sie sind nicht gestaltet. Das ist kein Messfehler von Blatt 82 —
Blatt 82 ist vom 11.08., die fünf Bildschirme sind danach entstanden.

### 3.2 Der Befund kehrt sich um

| Was E-6 vermutet | Was gemessen ist |
|---|---|
| Vier Zustände sind gestaltet, aber ungemessen | Vier Zustände sind **nicht gestaltet** |
| Ein halber Tag Nachmessen schließt die Lücke | Nachmessen findet **nichts** — es fehlt der Einbau, nicht die Messung |
| Die übrigen Bildschirme tragen ungemessene Farbpaare | Die übrigen Bildschirme tragen **null** Farbpaare |

### 3.3 Der Fokusring — die eine Stelle, die heute schon trägt

Weil kein `outline` gesetzt ist, ist der Fokusring **der des Browsers**, und der erfüllt
in allen aktuellen Browsern die Sichtbarkeitsanforderung von Haus aus. **Das ist heute
der bessere Zustand als ein selbstgebauter Ring**, und es ist der Grund, warum die
Bildschirme trotz fehlender Gestaltung bedienbar sind.

> **Die Gefahr liegt nicht heute, sondern beim Einbau.** In dem Moment, in dem E-1 bis
> E-5 eingebaut werden, wird der Browserfokusring von den eigenen Farben überschrieben —
> und **dann** entsteht genau der ungemessene Zustand, den E-6 meint.

### 3.4 E-5, Vertrag 4 — mitgemessen, weil es sich anbot

Vertrag 4 aus E-5 lautet *„kein Zustand trägt nur Farbe"*. **Er ist heute erfüllt**, und
zwar trivial: Es gibt keine Farbe, die einen Zustand tragen könnte. Zustände werden im
Bau über **Text** ausgedrückt. Das ist kein Verdienst der Gestaltung, sondern ihre
Abwesenheit — aber es ist gemessen und es hält.

---

## 4 · Zustand je Teilfrage nach K23-M22

*Vier Zustände sind zulässig: bestanden · fehlgeschlagen · **gesperrt** · nicht ausgeführt.*

| | Teilfrage aus E-6 | Zustand | Begründung |
|---|---|---|---|
| 1 | Mauszeigerzustand (`:hover`) | **bestanden** | Keine Regel vorhanden — nichts, was den Kontrast senken könnte. Befehl 2.2 |
| 2 | Tastaturfokus (`:focus`) | **bestanden** | Kein `outline` überschrieben; Browserring gilt. Befehl 2.3 |
| 3 | Gesperrter Zustand (`:disabled`) | **nicht ausgeführt** | Der Zustand existiert im Bau nicht. Befehl 2.6 — kein Messobjekt |
| 4 | Platzhaltertext (`::placeholder`) | **nicht ausgeführt** | Kein `placeholder` im Markup. Befehl 2.6 — kein Messobjekt |
| 5 | Farbpaare der übrigen Bildschirme | **bestanden** | Null Farbwerte über acht Vorlagen. Befehl 2.1 |
| 6 | **Dieselben Fragen nach dem Einbau von E-1 bis E-5** | **gesperrt** | Der Einbau hat nicht stattgefunden. Was es nicht gibt, kann nicht gemessen werden |

**Zeile 6 ist der Kern.** Fünf der sechs Teilfragen sind heute beantwortet. Die sechste
ist es nicht und kann es heute nicht sein — sie ist **gesperrt**, nicht bestanden, und
darf in keinem Bericht anders erscheinen.

---

## 5 · Was diese Nachmessung nicht kann

**Sie ist statisch.** Sie liest Quelltext, sie rendert nicht. Was sie deshalb **nicht**
belegt:

| | Was ungemessen bleibt | Warum |
|---|---|---|
| 1 | Der tatsächliche Kontrastwert des Browserfokusrings auf dem tatsächlichen Untergrund | Braucht einen laufenden Bildschirm und ein Messgerät, nicht `grep` |
| 2 | Das Verhalten unter erzwungenen Farbmodi des Betriebssystems | Dito — und es ist ohnehin Gegenstand von E-5, nicht von E-6 |
| 3 | Ob `color-scheme: light dark` auf jedem Zielgerät denselben Untergrund liefert | Geräteabhängig |
| 4 | Der Zustand nach dem Einbau von E-1 bis E-5 | Der Einbau hat nicht stattgefunden |

**Diese vier sind der ehrliche Rest von E-6.** Sie kosten den halben Tag, den Blatt 82
veranschlagt — **aber erst dann, wenn es etwas zu messen gibt.** Heute vorgezogen, misst
er die Voreinstellung des Browsers.

---

## 6 · Handlungsempfehlung, die sich aus der Messung ergibt

> **Die Nachmessung wird an den Einbau gehängt, nicht an den Kalender.**
>
> Konkret: **E-6 gilt als geschlossen für den heutigen Stand** (Zeilen 1 bis 5 der
> Tabelle in Abschnitt 4) und wird als **auflösend bedingter Punkt** weitergeführt: Sobald
> E-1 bis E-5 eingebaut werden, ist vor der Abnahme dieses Einbaus erneut zu messen — mit
> laufendem Bildschirm, gegen die vier Punkte aus Abschnitt 5.
>
> **Das ist kein Zurückstellen.** Der Unterschied ist, dass der Auslöser benannt ist:
> nicht ein Datum, sondern ein Ereignis, das im Bau ohnehin stattfinden muss.

**Wer das nicht will**, hat den Gegenweg offen: den halben Tag heute investieren, gegen
den Browserstandard messen, und nach dem Einbau ein zweites Mal messen. Das ist doppelte
Arbeit für einen Wert, der sich beim Einbau ändert — deshalb steht es hier als
Möglichkeit und nicht als Empfehlung.

---

*Erhoben am 16.08.2026 vom Coding-Harness. **Jede Zahl in diesem Blatt trägt den Befehl
daneben, der sie erzeugt hat** (Schwesterregel, gez. M. Veil 16.08.2026). Kein Wert
stammt aus einer Zusammenfassung, keiner aus Blatt 82 übernommen.*
