# `pruefungen/lauf.sh` · PGPASSWORD wird nicht durchgereicht

⟨VORSCHLAG · NICHT GEZEICHNET · NICHT AUSGEFÜHRT⟩

| Feld | Wert |
|---|---|
| Anlass | Befund **A11** aus dem Bauzug vom 22.08.2026 |
| Betrifft | `pruefungen/lauf.sh`, Zeilen **29–30** |
| Vorgelegt am | 22.08.2026 |
| Warum vorgelegt statt gebaut | `CLAUDE.md`:258 — *„Als Bau-Agent eine Datei unter `pruefungen/` anfassen. Auch nicht ‚nur den Tippfehler'."* Dazu `.github/CODEOWNERS`: `/pruefungen/` verlangt die Zustimmung **beider** Kennungen |
| Zustand der Sache | **offen** — die Datei ist unverändert |

---

## 1 · Was gemessen wurde

`pruefungen/lauf.sh` setzt vier Vorgaben und exportiert vier Namen:

```
Zeile 29: : "${PGHOST:=localhost}" "${PGPORT:=5432}" "${PGUSER:=postgres}" "${PGDATABASE:=freiraum_ci}"
Zeile 30: export PGHOST PGPORT PGUSER PGDATABASE
```

`PGPASSWORD` ist nicht darunter. Es wird im Skript an genau zwei Stellen gelesen — Zeile 608
und Zeile 613 —, und dort nur, um den DSN der Anwendung zusammenzusetzen, mit Rückfallwert
`pilot`. Für die `psql`-Aufrufe des Laufs selbst gibt es keine Vorkehrung.

**Drei Fälle, gemessen am 22.08.2026:**

| Aufruf | Was im Skript ankommt |
|---|---|
| `PGPASSWORD=pilot bash pruefungen/lauf.sh` | kommt an und ist exportiert — die Vorsatz-Zuweisung exportiert von sich aus |
| `PGPASSWORD=pilot` als eigene Zeile, danach `bash pruefungen/lauf.sh` | **kommt nicht an** — Shell-Variable ohne `export` |
| gar nicht gesetzt | kommt nicht an |

Und was `psql` dann tut:

```
$ psql -h 127.0.0.1 -p 5432 -U postgres -d postgres -w -tAc "select 1"
psql: error: connection to server at "127.0.0.1", port 5432 failed: fe_sendauth: no password supplied
```

**Ohne `-w` fragt `psql` an dieser Stelle interaktiv.** In einem Lauf ohne Terminal — CI,
`nohup`, Hintergrund — bedeutet das nicht „Fehler", sondern **Stillstand**. Der Lauf hängt an
der Anmeldung, statt zu messen. Das ist der schlechtere von zwei schlechten Ausgängen: ein
Abbruch ist ablesbar, ein Hänger sieht aus wie Arbeit.

Der dokumentierte Aufruf in `README.md` und in der Ausgabe von `./aufbau.sh --ci` trifft
Fall 1 und läuft heute durch. Der Befund betrifft die beiden anderen Fälle — und jede
entfernte Datenbank, gegen die jemand den Lauf ohne die Vorsatz-Schreibweise fährt.

## 2 · Vorgeschlagene Änderung

Die bestehende Vorgabelogik bleibt **unangetastet** — Zeile 29 und 30 werden nicht angefasst.
Eingefügt wird ein Block **hinter** Zeile 30:

```bash
# PGPASSWORD bekommt bewusst KEINE Vorgabe im Skript: ein Vorgabewert waere
# ein Zugangswert im Repo, und Tor 1a sperrt darauf (K23-D09).
# Gesetzt wird es durchgereicht -- ungesetzt wird sein Fehlen FRUEH gemeldet,
# statt psql spaeter interaktiv fragen zu lassen. Ein Lauf, der an der
# Anmeldung haengt, ist schlechter als einer, der dort abbricht: der Abbruch
# ist ablesbar, der Haenger sieht aus wie Arbeit.
if [ -n "${PGPASSWORD:-}" ]; then
  export PGPASSWORD
else
  # Nicht raten, sondern messen. -w laesst psql NIE interaktiv fragen; eine
  # Datenbank ueber Unix-Socket oder mit .pgpass antwortet hier normal und
  # der Lauf geht weiter. Nur wer wirklich ein Passwort braucht, wird
  # abgewiesen -- und zwar mit dem Wortlaut von psql.
  if ! probe=$(PGCONNECT_TIMEOUT=10 psql -w -tAc 'select 1' 2>&1); then
    echo "GESPERRT: keine Anmeldung an $PGUSER@$PGHOST:$PGPORT/$PGDATABASE ohne PGPASSWORD."
    echo "          $probe"
    echo "          Aufruf mit Passwort, in EINER Zeile:"
    echo "            PGPASSWORD=<wert> bash pruefungen/lauf.sh"
    echo "          Zustand nach K23-M22: gesperrt -- nicht bestanden."
    exit 1
  fi
fi
```

**Was der Vorschlag bewusst nicht tut:**

- **Kein Vorgabewert `pilot`.** Ein Zugangswert im Quelltext ist ein Fund für Tor 1a und
  bricht K23-D09 — auch wenn er nur in einer Prüfumgebung gilt.
- **Keine Vermutung über den Wirt.** Ein früher Entwurf wollte `localhost` ausnehmen. Das
  wäre falsch gewesen: der dokumentierte CI-Aufruf geht über `localhost` **mit** Passwort.
  Statt zu raten, fragt der Vorschlag die Datenbank.
- **Kein Anfassen von Zeile 29 und 30.**

## 3 · Was zu entscheiden ist

| Nr. | Frage | Kästchen |
|---|---|---|
| 1 | Wird der Block eingefügt? | ☐ ja · ☐ nein · ☐ anders |
| 2 | Wer führt die Änderung aus — Prüf-Agent oder ein Mensch? | ☐ Prüf-Agent · ☐ Mensch |

**Die Kästchen sind leer und bleiben es**, bis eine zeichnende Person sie anweist. Der
Harness setzt kein Kreuz, für das keine Weisung im Wortlaut vorliegt (`CLAUDE.md`:244–247).

| Name | Datum | Unterschrift |
|---|---|---|
| M. Veil | | |
| A. Han | | |

Dieses Blatt trägt einen Befund und einen Vorschlag. Es trägt keine Unterschrift und keine
ausgeführte Änderung.
