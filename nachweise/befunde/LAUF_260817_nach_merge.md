# Prüflauf vom 17.08.2026 — gegen den **heutigen** Prüfstand

| | |
|---|---|
| **Anlass** | `BEF-ZEICHNUNG-1`: der Zweig war **18 Commits hinter `main`** und maß damit gegen eine Prüfstrecke, die es in der Hauptspur nicht mehr gibt. `K23-M20` nennt das einen **veralteten Durchstich** |
| **Getan** | `git merge origin/main` — **konfliktfrei** |
| **Neu darin** | A. Hans **#27**: `AC-16` an einen nachweislich frischen Mailversand gebunden (`anmeldecode_lauf.sh`, +222/−44) |
| **Stand** | Merge-Commit `7245e55`, Zweig `scheibe/m4-zweckbestimmung` |

---

## Das Ergebnis

```
shellcheck  (17 Dateien, koalaman/shellcheck:stable -S warning)   0 Warnungen
ruff check app/ werkzeuge/                                        sauber
python3 -m py_compile app/*.py                                    sauber
Migrationsprueffaelle (M30__pruefung.sql)              111 von 111, 0 gescheitert

  anmeldung         30 von 30
  einloesung        18 von 18
  versand            9 von  9
  anmeldecode       16 von 17     AC-16 GESPERRT
  mitgliedschaft     8 von  9     MG-08 GESPERRT
  vorpruefung       30 von 32     VP-24 GESCHEITERT · VP-08b GESPERRT
  zweckbestimmung    8 von 27     alle uebrigen GESPERRT, keiner gescheitert

  Gesamt: bestanden 12 · fehlgeschlagen 1 · gesperrt 3
```

## Was daran zählt

**Die Zahlen sind identisch mit denen vom 16.08. abends.** Das war **nicht**
selbstverständlich, und es ist jetzt **belegt statt angenommen**: A. Hans Verschärfung von
`AC-16` hat nichts umgeworfen.

**`AC-16` meldet weiterhin `GESPERRT` — und das ist richtig so.** Die CI-Umgebung führt keine
`FREIRAUM_SMTP_*`-Zugänge. **Ein Fall, der ohne echten Versand nicht mehr fälschlich grün
wird, ist genau das, was #27 herstellen sollte.** Vorher konnte er sich auf eine am 10.08.
einmal abgelesene Datei stützen.

## Genau ein echter Fehlschlag

| | Zustand | Was es ist |
|---|---|---|
| **VP-24** | **GESCHEITERT** | `fit_check.zweckbestimmung_erklaert_am` trägt keine Klausel — `M31` begründet sie mit einer **Analogie**. Eine Analogie ist keine Klausel. **→ E-14** |
| VP-08b | gesperrt | Widerspruch `K04-M07` gegen Rang 1 — wartet auf einen Menschen |
| MG-08 | gesperrt | über keine bekannte Tür prüfbar — getragener offener Punkt |
| AC-16 | gesperrt | braucht einen echten Mailversand — A. Han, Schlüsselbund |
| ZB-03 ff. | gesperrt | zwei Wege statt einem; der Vertrag widerspricht sich selbst. **→ E-9** |

**Nach `K23-M22` ist *gesperrt* nicht *gescheitert*** — was nicht gemessen werden konnte, ist
nicht fehlgeschlagen. Deshalb melden drei der vier Fäden eine **Warnung**, keinen Fehler.

---

## Was am Zweig noch zu tun ist: **nichts**

**Alles, was Bauarbeit war, ist getan.** Was Tor 1c rot hält, sind **zwei
Menschenentscheidungen**, beide bei **A. Han** als fachlichem Eigentümer von K04 und K19:

| | Frage | Blatt |
|---|---|---|
| **E-14** | Klausel für `fit_check.zweckbestimmung_erklaert_am` nachziehen — oder die Spalte streichen | `entscheidung_tor1_260816.md` |
| **E-9** | `antwort_aendern`: halt-only oder ab jeder vorhandenen Antwort? | dasselbe |

**Und davor, weiterhin unerledigt:** die **Gegenzeichnung von BA-1** in der Datei
(`BEF-ZEICHNUNG-1`) und die **Fremdprüfung**, deren Frist der 17.08.2026 war.

---

*Gefahren am 17.08.2026 vom Orchestrator, gegen `freiraum_ci` auf Port 55433. Jede Zahl aus
dem Lauf selbst, keine aus einer Zusammenfassung. **Der Lauf ersetzt den CI-Lauf nicht** — er
läuft auf demselben Prüfstand, aber auf diesem Rechner.*
