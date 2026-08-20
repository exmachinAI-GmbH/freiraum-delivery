# Prüfauftrag M5 · **blind** — die Prüffälle zum geführten Gespräch

**20.08.2026 · Auftrag an den Prüf-Agenten.** Du arbeitest im Blindstand: der Umsetzungscode
ist auf Betriebssystemebene nicht lesbar. Das ist kein Hindernis, das ist der Auftrag.

## Was du bekommst

| | |
|---|---|
| `auftrag.md` | dieses Blatt |
| `klauseln.md` | **101 Klauseln im Wortlaut mit ihren gezeichneten Akzeptanzkriterien** — deine einzige fachliche Quelle |
| `nachweise/klauselregister/` | das Register, falls du eine Klausel im Zusammenhang nachschlagen willst |
| `pruefungen/klauseln/` | die **bestehenden** Prüffälle früherer Meilensteine — als **Formvorbild**, nicht als Inhalt |

Mehr gibt es nicht, und mehr darfst du nicht verwenden. Verlangt irgendetwas von dir, Code zu
lesen, antworte wörtlich: **„ABGELEHNT — das ist Umsetzungscode."**

## Was geprüft wird

**M5, „das geführte Gespräch".** Zwei Bildschirme und die Serverbefehle dahinter:

- **EN-05 · Orientierung** — Einordnungsfragen, Themenwahl, Zielwahl, Übergang ins Interview
- **EN-06 · Interview** — das geführte Gespräch selbst, Antworten, Belege, Abschluss

Was diese Bildschirme können müssen, steht **ausschließlich in den 101 Klauseln**. Was sie
**nicht** können müssen, ebenfalls. Rate nichts dazu.

## Was du schreibst — zwei Dateien

| Datei | Inhalt |
|---|---|
| `pruefungen/klauseln/gespraech_daten.sql` | die Prüfdaten: Mandanten, Konten, Mitgliedschaften, Ausgangslagen. **Wiederholbar.** Alle Adressen enden auf `@gespraechpruef.example` |
| `pruefungen/klauseln/gespraech_lauf.sh` | die Fälle gegen einen **laufenden** Server unter `FREIRAUM_PRUEF_URL` |

**Die Form ist vorgegeben** — nimm `zweckbestimmung_daten.sql` und `zweckbestimmung_lauf.sh`
als Vorbild: Kopfkommentar mit den geprüften Klauseln, Aufrufbeispiel, ausdrückliche Liste
dessen, was die Datei **nicht** messen kann, ein Zustand je Fall, Zählung am Ende.

## Die vier Regeln, an denen dein Ergebnis gemessen wird

1. **Gemessen wird eine Unterscheidung, kein Vorkommen.** Kein Fall darf fragen „steht dieser
   Text irgendwo". Jeder Fall braucht einen **zweiten Lauf**, der sich nur in einer Antwort
   unterscheidet — und der das Gegenteil zeigen muss. Ein Bildschirm, der immer alles zeigt,
   muss durchfallen.
2. **Adressen werden entdeckt, nicht geraten.** Ein geratener Pfad misst einen 404 — also eine
   **fremde** Bedingung. Fahre wie eine Nutzerin: folge den Weiterleitungen, lies die Formulare
   der Seite, leite die Ziele aus dem **Unterschied** zwischen mehreren Läufen ab. Lässt sich
   ein Ziel nicht eindeutig bestimmen, meldet jeder Fall, der es braucht, **GESPERRT** — nie
   bestanden (K23-M22).
3. **Je Klausel mindestens ein Positiv- und ein Negativfall.** Jeder Negativfall nennt im Kopf
   `-- erwartet: <Bedingungsname>` und scheitert an **seiner eigenen** Bedingung. Die erwartete
   Meldung gehört im Wortlaut in den Prüffall.
4. **Gibt eine Klausel keinen messbaren Maßstab her, schreibe keinen Prüffall**, sondern
   `NICHT PRÜFBAR` und nenne, welche Angabe im Akzeptanzkriterium fehlt. **Rate niemals.**

## Was am Ende dazugehört

Eine dritte Datei, `pruefungen/klauseln/gespraech_deckung.md`:

- je Klausel: gedeckt · NICHT PRÜFBAR (mit fehlender Angabe) · WIDERSPRUCH (mit beiden Nummern)
- die Zählung: wie viele der 101 gedeckt, wie viele nicht, wie viele im Widerspruch
- **welche Klauseln du ungedeckt lässt und warum** — das ist der wichtigste Teil des Berichts

> **Ein ungedeckter Punkt, der benannt ist, ist ein Ergebnis. Ein ungedeckter Punkt, der
> unbenannt bleibt, ist ein Fehler.**
