---
description: Die Übergabe des Tages schreiben — mit der festen Tor-3-Zeile
---

# `/uebergabe` — die Übergabe des Tages

Schreibt `HANDOVER_JJMMTT.md` für den heutigen Tag. Der Zweck ist nicht die Zusammenfassung,
sondern **dass drei Fragen jeden Tag vor Augen stehen, statt in einem Prüfbericht zu
stehen**: Wo steht der fremde Blick? Was ist gemessen und was nur behauptet? Was hängt am
Menschen?

---

## 1 · Kopf — erzeugt, nicht geschätzt

| Feld | Woher |
|---|---|
| Stand `main` | `git rev-parse --short origin/main` |
| Arbeitszweig und offene Anträge | `git rev-parse --abbrev-ref HEAD` · `gh pr list --state open` |
| Arbeitsbaum sauber? | `git status --porcelain` |
| Tage bis zum Endtermin | gegen den **31.08.2026** (Bauauftrag :1, :39) |

## 2 · Die feste Tor-3-Zeile — **niemals weglassen**

```
python3 werkzeuge/fremdreview.py --stand
```

Die Ausgabe steht **wörtlich** im Handover, in einem eigenen Abschnitt, **oberhalb** der
Meilensteinlage. Nicht am Ende, nicht in einer Fußnote.

**Warum sie ganz oben steht.** Tor 3 ist die dritte von vier Messstufen: ein Modell eines
*anderen* Anbieters prüft die fachliche Eignung gegen Roh-Evidenz. Der Harness darf es
**nie selbst anfordern und nie selbst schreiben** — sonst ist es derselbe Blick mit einem
anderen Etikett. Die Sperre in `pruefungen/tor3.sh` ist deshalb **passiv**: sie meldet
einen Zustand, den man übersehen kann.

Gemessen: bis zum 15.08.2026 ist Tor 3 **kein einziges Mal** mit einem gültigen
Nachweisblatt gelaufen — nicht aus Ablehnung, sondern weil nie ein Moment kam, in dem die
Frage gestellt wurde. Diese Zeile ist dieser Moment.

**Sie führt jede Scheibe und jeden Meilenstein**, nicht nur den, an dem gerade gebaut wird.
Ist für eine Scheibe nie angefordert worden, steht das da — mit dieser Scheibe beim Namen.

### Wann tatsächlich gefragt wird

Die Übergabe **führt** den Stand täglich; **gefragt** wird an genau zwei Punkten:

| Auslöser | gilt für | Ort der Frage |
|---|---|---|
| **Scheibenabnahme** — die Regel | Fundament und Scheiben 1 bis 7 | `/scheibe`, Schritt 10 |
| **Meilensteinabnahme** — die Ausnahme | **nur M10, M11, M12** | vor der Vorlage des jeweiligen Nachweises |

Die Regel steht gezeichnet in C-4: *„einmal je Scheibenabnahme, nicht je Änderung."* Die
Ausnahme ist gemessen: M10 bis M12 gehören **keiner Scheibe** an — die Baustrategie führt
sie als *„Prüf- und Abnahmespur — quer, keine Scheibe"* (BS:125). Ohne die Ausnahme fielen
Durchstich, Lastprüfung und Abnahme durch das Raster.

**Nicht bei jedem Meilenstein.** Scheibe 2 schließt M3 und M4; dreimal dieselbe Frage macht
sie billig. C-4 sagt warum: *„Ein Gate, das bei jedem Commit anschlägt, wird umgangen oder
billig erfüllt — beides schlechter als kein Gate."*

## 3 · Die Meilensteinlage — an der Nachrechnung, nicht am Gefühl

Je berührtem Meilenstein **seine Nachrechnung im Wortlaut** aus dem Bauauftrag (Abschnitt
6a) und daneben, was davon gemessen ist. Je Teilaussage genau einer der vier Zustände aus
**K23-M22**: *bestanden · fehlgeschlagen · gesperrt · nicht ausgeführt.*

**Gesperrt ist nicht bestanden.** Ein Meilenstein mit einer gesperrten Teilaussage ist
**nicht eingetreten** — die Nachrechnung kennt keinen Zwischenzustand, das ist ihr Zweck.

Wo eine Nachrechnung auf etwas verweist, das **nicht in diesem Repo** liegt, wird das
gesagt, statt es aus einer anderen Prüfung abzuleiten.

## 4 · Was gemessen wurde — Befehl und Ergebnis

Je Zeile der ausgeführte Befehl und sein Ergebnis in Zahlen, nie in Adjektiven.
„110 von 110 bestanden", nicht „läuft gut". Mindestens:

```
./pruefungen/lauf.sh --bericht <datei>
python3 werkzeuge/herkunft.py --isoliert
python3 werkzeuge/fremdreview.py --stand
```

**Keine Quote ohne die namentliche Restliste.** F34 im Wortlaut: *„Eine Abdeckungsquote
ersetzt diese Liste nicht. 95 % sagen nichts darüber, ob die fehlenden 5 % die kritischen
sind. Eine künstliche Mindestquote entsteht nicht."* Kein Zielwert, keine Ampel.

## 5 · Was nur ein Mensch tun kann

Eine Tabelle, nach Dringlichkeit, je Zeile: **was · warum es klemmt · wer**. Hierher gehört
alles, was der Harness nicht darf — Zeichnungen, Freigaben, Akzeptanzkriterien, Zugangsdaten,
**und die Anforderung des Fremdreviews**.

## 6 · Fallstricke dieser Sitzung

Fehler, die gemacht wurden, und woran man sie erkennt. **Auch die eigenen.** Ein Handover,
der nur Erfolge führt, ist eine Werbebroschüre.

## 7 · Womit die nächste Sitzung anfängt

Höchstens drei Zeilen. Wenn Tor 3 für die laufende Scheibe nie angefordert wurde, ist eine
davon **immer** die Frage, ob es jetzt angefordert wird.

---

## Was `/uebergabe` nie tut

- **Einen Zustand behaupten, den es nicht gemessen hat.** Fehlt die Grundlage, heißt der
  Zustand *gesperrt* (K23-M22).
- **Ein Fremdreview anfordern, schreiben oder bewerten.** Es führt nur seinen Stand.
- **Einen Meilenstein als eingetreten führen**, solange eine Teilaussage seiner
  Nachrechnung gesperrt oder nicht ausgeführt ist.
- **Eine Quote ohne Restliste nennen** (F34).
- **Einen Zweig zusammenführen, etwas freigeben oder ein Deployment auslösen.**
