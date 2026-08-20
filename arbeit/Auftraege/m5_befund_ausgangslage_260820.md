# Zweiter Befund an **deinen eigenen Dateien** — die Ausgangslage lädt nicht

**20.08.2026 · Nachbesserungsauftrag an den Prüf-Agenten.**

## Was dieser Befund ist

Wie beim ersten Mal: **kein** Testergebnis, **kein** Verhalten der Anwendung, **keine**
Meldung aus dem Umsetzungscode. Nur ein Mangel an **deiner eigenen Datei**, der dazu führt,
dass **kein einziger Fall zur Ausführung kommt**.

**Die UUID-Nachbesserung hat getragen.** Nachgemessen: 0 Kennungen mit elf Zeichen,
`bash -n` sauber. Die Datei kommt jetzt bis Zeile 223 — und scheitert dort.

## Der Mangel

```
psql:pruefungen/klauseln/gespraech_daten.sql:223: ERROR:  EIGNUNGSRIEGEL:
  eine Anwendung entsteht nur zu einem bestandenen Eignungs-Check (K01-M27, O-K01-6)
```

Zeile 223 ist der Beginn deines **Abschnitts 6** — der `INSERT INTO app`. Die Datenbank
weist ihn ab: **zu diesem Zeitpunkt zeigt kein bestandener Eignungs-Check auf die Zeilen.**
Die Checks legst du erst in **Abschnitt 7** an, also danach.

Der Riegel nennt **K01-M27** — eine deiner 101 Klauseln. Er setzt genau das durch, was dort
steht. Deine Ausgangslage widerspricht ihm nicht in der Sache, nur in der **Reihenfolge**.

## Was zu tun ist

Bring deine Ausgangslage in eine Reihenfolge, die der Riegel zulässt. Welche das ist,
entscheidest du aus deinen Klauseln — nicht ich.

**Zwei Hinweise zur Vollständigkeit, damit du nicht auf halbem Weg wieder aufläufst:**

- Deine Kommentare zu Abschnitt 7 setzen voraus, dass die `app`-Zeilen schon da sind (jede
  Anwendung „trägt genau EINEN GEEIGNET-Check, der schon vor dem Lauf auf sie zeigt").
  Prüfe, ob die Abhängigkeit in beide Richtungen läuft — dann genügt Umsortieren nicht.
- `gs_offen@` soll einen Check **ohne** `app`-Zeile tragen, `gs_ohnecheck@` **gar keinen**.
  Diese beiden Ausgangslagen müssen erhalten bleiben; sie sind Prüfgegenstand.

## Die Grenze dieses Auftrags — unverändert

- **Ändere nichts an der fachlichen Aussage eines Falles.**
- **Senke keinen Prüfwert und lockere keine Erwartung** (K23-D05).
- **Nimm keinen Fall heraus** und wandle keinen in `GESPERRT`, um den Lauf glatt zu bekommen.
- Behebe **nur**, was die Ausgangslage am Laden hindert.

> Läuft die Datei danach weiter und scheitert an **einer anderen Stelle**, behebe auch das,
> solange es dieselbe Art von Mangel ist — und nenne am Ende **jede** Stelle einzeln.
> Verlangt etwas eine **fachliche** Entscheidung, behebe es **nicht**, sondern nenne es.

**Du kannst die Datei nicht selbst gegen eine Datenbank fahren, und das ist Absicht.** Eine
laufende Datenbank gäbe dir das Zielschema — genau das, was `blindstand.sh` dir ausdrücklich
vorenthält. Das Laden fährt der Orchestrator, und was dabei scheitert, kommt als Befund
dieser Art zurück. **Deshalb lohnt es sich, deine Datei vor der Rückgabe einmal von oben nach
unten auf Reihenfolgen durchzusehen** statt nur die eine gemeldete Zeile zu berühren: jede
Runde kostet einen ganzen Lauf.
