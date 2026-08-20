# Neunter Befund — **Tor 1a hält den Antrag an**, wegen fünfzehn Zeilen in deiner Datei

**20.08.2026 · Nachbesserungsauftrag an den Prüf-Agenten.**

## Die Lage

Für den Bauzweig ist am 20.08.2026 ein Antrag gestellt worden (#42). **Tor 1a ist rot**, und
der Grund liegt zu fünfzehn Fünfzehnteln in `pruefungen/klauseln/gespraech_lauf.sh`.

Die CI fährt `shellcheck -S warning` über **alle** Shell-Skripte im Versionsstand
(`.github/workflows/tore.yml`:118). Bei dieser Schwelle ist eine Warnung ein Fehlschlag.

> **Die Bau-Seite ist bereits sauber.** Zwei Befunde in `werkzeuge/blindlauf.sh` sind
> behoben. **Alles Übrige sind deine Zeilen** — und der Bau fasst `pruefungen/` nicht an.

## Die fünfzehn Befunde, vollständig

```
  pruefungen/klauseln/gespraech_lauf.sh:513:43: warning: besch appears unused. Verify use (or export if used externally). [SC2034]
  pruefungen/klauseln/gespraech_lauf.sh:513:49: warning: zf appears unused. Verify use (or export if used externally). [SC2034]
  pruefungen/klauseln/gespraech_lauf.sh:539:7: warning: vorher_ev appears unused. Verify use (or export if used externally). [SC2034]
  pruefungen/klauseln/gespraech_lauf.sh:694:7: warning: branche_frueher appears unused. Verify use (or export if used externally). [SC2034]
  pruefungen/klauseln/gespraech_lauf.sh:840:27: warning: ZR_PFAD appears unused. Verify use (or export if used externally). [SC2034]
  pruefungen/klauseln/gespraech_lauf.sh:844:7: warning: st_zrb appears unused. Verify use (or export if used externally). [SC2034]
  pruefungen/klauseln/gespraech_lauf.sh:846:7: warning: st_zrf appears unused. Verify use (or export if used externally). [SC2034]
  pruefungen/klauseln/gespraech_lauf.sh:848:7: warning: st_zra appears unused. Verify use (or export if used externally). [SC2034]
  pruefungen/klauseln/gespraech_lauf.sh:1091:1: warning: VORHER_D06 appears unused. Verify use (or export if used externally). [SC2034]
  pruefungen/klauseln/gespraech_lauf.sh:1104:9: warning: st_ue_skip appears unused. Verify use (or export if used externally). [SC2034]
  pruefungen/klauseln/gespraech_lauf.sh:1178:5: warning: st_fremd_zugriff appears unused. Verify use (or export if used externally). [SC2034]
  pruefungen/klauseln/gespraech_lauf.sh:1227:3: warning: st_en05_zurueck appears unused. Verify use (or export if used externally). [SC2034]
  pruefungen/klauseln/gespraech_lauf.sh:1335:3: warning: ev_vor_d04 appears unused. Verify use (or export if used externally). [SC2034]
  pruefungen/klauseln/gespraech_lauf.sh:1394:3: warning: vorher_frei_count appears unused. Verify use (or export if used externally). [SC2034]
  pruefungen/klauseln/gespraech_lauf.sh:1723:7: warning: versuch_umschreiben appears unused. Verify use (or export if used externally). [SC2034]
```

**Alle fünfzehn sind derselbe Befund: `SC2034` — „Variable wird gesetzt, aber nie gelesen".**

## Was zu tun ist — und warum das keine Kosmetik ist

**Sieh bei jeder einzeln nach, welcher der drei Fälle vorliegt.** Sie sehen gleich aus und
bedeuten Verschiedenes:

| | Fall | was zu tun ist |
|---|---|---|
| **1** | Die Zuweisung dient nur dem **Nebeneffekt** — der Aufruf soll laufen, sein Rückgabewert interessiert nicht (etwa `st_zrb="$(sende_frage …)"`) | Ruf die Funktion ohne Zuweisung auf, oder setz eine Zeile `# shellcheck disable=SC2034` **mit Begründung** darüber |
| **2** | Die Variable war als **Vergleichswert** gedacht und wird nur versehentlich nicht benutzt — `vorher_ev`, `VORHER_D06`, `ev_vor_d04`, `vorher_frei_count`, `branche_frueher` heißen alle nach einem *Vorher* | **Das ist der wichtige Fall.** Ein Vorher-Wert, der nie gegen ein Nachher gehalten wird, heißt: **der Fall misst die Unterscheidung nicht, die er zu messen behauptet.** Dann ist nicht die Variable zu streichen, sondern der Vergleich nachzuziehen |
| **3** | Die Variable ist wirklich **überflüssig** | streichen |

> **Fall 2 ist der Grund, warum dieser Befund nicht „nur Lint" ist.** Deine eigene erste
> Arbeitsregel lautet: *„Gemessen wird eine Unterscheidung, kein Vorkommen."* Genau die
> braucht einen Vorher- **und** einen Nachher-Wert. Wo shellcheck sagt, der Vorher-Wert werde
> nie gelesen, sagt er dir womöglich, dass die Unterscheidung fehlt.
>
> **Prüf das, bevor du irgendetwas streichst.** Fünf der fünfzehn Namen tragen ein *vorher*,
> *vor* oder *frueher*.

## Die Grenze — unverändert

- **Ändere nichts an der fachlichen Aussage eines Falles.**
- **Senke keinen Prüfwert und lockere keine Erwartung** (K23-D05).
- **Nimm keinen Fall stillschweigend heraus.** Findest du in Fall 2 eine fehlende Messung,
  **stell sie her oder melde den Fall als GESPERRT mit Begründung** — beides ist richtig,
  Wegschauen nicht.
- **Ein `# shellcheck disable` ohne Begründung ist keine Lösung**, sondern ein zugeklebtes
  Warnlicht.

## Prüf dich selbst, bevor du zurückgibst

Der Bau fährt danach genau das:

```
shellcheck -S warning pruefungen/klauseln/gespraech_lauf.sh
```

**Null Ausgabe heißt bestanden.** `bash -n` muss ebenfalls sauber bleiben.
