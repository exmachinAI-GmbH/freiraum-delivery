# migrations/ · versionierte Migrationen

Der Bauplan `schema/freiraum_datamodel.sql` ist Grundwahrheit. Jede Änderung daran entsteht
als **neue Datei in diesem Ordner** — nie durch Anfassen des Bauplans und nie durch Anfassen
einer bereits eingespielten Migration.

*Neu geschrieben am 22.08.2026. Bis dahin stand hier „**Noch leer.** Erste Migration bei
Baustart" — geschrieben vor dem ersten Bauzug und seither nie nachgezogen. Zu diesem
Zeitpunkt lagen drei Migrationen, zwölf Negativfälle und drei Skripte im Ordner.*

## Der geltende Bestand

Drei Migrationen. Sie werden **alle** eingespielt, in aufsteigender Reihenfolge der Kennung.

| Datei | Was sie tut | Prüfsumme |
|---|---|---|
| `M30__pilot_sammelmigration.sql` | Sammelmigration des Pilotstands. **Rang 1** zusammen mit dem Bauplan — sie gewinnt jeden Widerspruch gegen Doku, Handbücher und Prüffälle | `M30__pilot_sammelmigration.sha256` |
| `M31__projektnummer_und_zweckbestimmung.sql` | Die Projektnummer bildet der Serverbefehl, kein Weg bietet sie zur Eingabe an (K01-M38, K01-D19); zwei getrennte Fragen der Zweckbestimmung (K04-M19). Ersetzt `create_app_after_fit` durch die vierstellige Fassung **ohne** `p_project_no` | `M31__projektnummer_und_zweckbestimmung.sha256` |
| `M32__zeilenschutz_und_stufenwechsel.sql` | Zeilenregeln mit `FORCE` für `app`, `document`, `event`; `set_journey_phase` prüft Konto, Mitgliedschaft, Mandant und Übergang; `change_app_state` schreibt die Verlaufszeile atomar mit | `M32__zeilenschutz_und_stufenwechsel.sha256` |

**M30 wird nicht mehr geändert.** Änderungsregel „keine", doppelt gezeichnet
(`.github/CODEOWNERS`). Was an M30 zu berichtigen ist, tritt als Vermerk
**neben** die Datei — Vorbild `M30__BERICHTIGUNG_BELEGZEILEN_260816.md`.

**M31 und M32 tragen seit dem 22.08.2026 eine Prüfsummendatei.** Bis dahin hatten sie keine,
und `aufbau.sh` übersprang die Prüfung still.

## Reihenfolge

| Schritt | Was | Wo |
|---|---|---|
| 1 | `schema/freiraum_datamodel.sql` | immer zuerst — ohne den Bauplan scheitert schon die erste Anweisung von M30 an `type "retention_class" does not exist` |
| 2 | `_vorlaeufer/260801_tenant.sql` | **nur im Pilotpfad** von `aufbau.sh`, nicht in der Messstufe 1b |
| 3 | `M30` → `M31` → `M32` | aufsteigend nach Kennung. Diese Ordnung stellt der Glob `migrations/*.sql` selbst her |
| 4 | `seeds/Seed_Welle1_M1-M4.sql` | nur im Pilotpfad, nach allen Migrationen |

**Der Glob erfasst keine Unterordner.** `_vorlaeufer/`, `_abgeloest/`, `negativfaelle/` und
`uebernahme/` werden von `migrations/*.sql` nicht gelesen — dort abgelegtes SQL läuft nie
mit. Wer eine Datei dorthin legt, nimmt sie damit aus dem Bestand.

**Die Kennung kommt aus dem Dateinamen.** Zwei Ziffern, doppelter Unterstrich:
`M33__sprechender_name.sql`. Jede andere Schreibweise erkennt der Riegel nicht — und die
Pflicht zu vier eigenen Negativfällen greift dann stillschweigend nicht.

## Die drei Unterordner — und was sie unterscheidet

| Ordner | Bedeutung | Läuft mit? |
|---|---|---|
| `_vorlaeufer/` | Was **weiterhin läuft**, aber nicht hier entstanden ist: `260801_tenant.sql` (Vertragsnachweis, Partneraufgabe) ist Voraussetzung von M30. Kopie eines Originals der Konzept-Fabrik, Änderungsregel **keine** | nur im Pilotpfad |
| `_abgeloest/` | Was **ersetzt** wurde: `260802_anmeldecode.sql`, aufgegangen in M30. Nach F36 wird nichts gelöscht — abgelöst heißt nicht falsch, sondern richtig für seinen Tag | **nein** |
| `uebernahme/` | Was **noch nicht in Kraft** ist: der Zeilenschutz-Vorschlag aus der N2-Übergabe über 57 Tabellen. Rohstoff, kein Liefergegenstand. Gezeichnet ist der mittlere Weg — drei Tabellen in M32 | **nein** |
| `negativfaelle/` | Vier Fälle je Migration, `M##_N#_*.sql`. Jeder muss scheitern, und zwar an **seiner eigenen** Bedingung; die erwartete Meldung steht im Kopf als `-- erwartet:` | als Prüfung, nicht als Bestand |

## Welches Skript was fährt

| Skript | Fährt | Wogegen |
|---|---|---|
| `../aufbau.sh` | Pilotpfad: Bauplan, Vorläufer, M30, M31, M32, Startdaten, B1 — acht Schritte | `freiraum` · Port 55432 |
| `../aufbau.sh --ci` | Bauplan + `migrations/*.sql`, **ohne** Vorläufer, **ohne** Startdaten | `freiraum_ci` · Port 55433 |
| `pruefe_negativfaelle.sh` | die Fälle des Pilotstands, gegen den laufenden Container | `freiraum` |
| `pruefe_negativfaelle_M31.sh` | die vier M31-Fälle, je mit Wortlaut der Meldung, dazu die Gegenprobe „nichts liegengeblieben" | Bauplan + M30 + M31 |
| `pruefe_negativfaelle_M32.sh` | die vier M32-Fälle, ebenso | Bauplan + M30 + M31 + M32 |
| `n2_lauf.sh "<verbindung>"` | den Abnahmelauf der N2-Übergabe: fünf Belege, jeder mit Belegdatei. Bricht ein Schritt ab, endet der Lauf dort | Zielumgebung |

Die Messstufe 1b in `.github/workflows/tore.yml` fährt denselben Bestand wie `--ci`: Bauplan,
dann alle `migrations/*.sql` in Glob-Reihenfolge, danach ein **zweiter** Lauf — er darf weder
Schema noch Daten verändern. Deshalb wird jede Migration durchgängig idempotent geschrieben:
`CREATE OR REPLACE`, `DROP POLICY IF EXISTS` vor `CREATE POLICY`, `INSERT … ON CONFLICT`,
keine Zufalls- und keine Zeitwerte in eingefügten Zeilen.

## Zwei offene Punkte, die hier hergehören

1. **`n2_lauf.sh` spielt genau eine Migration ein — M30, fest verdrahtet.** Inzwischen gibt es
   drei. Ob M1 M30 allein meint oder den Stand, auf dem die Anwendung läuft, ist **nicht
   gezeichnet**: die Wahlkästchen in `arbeit/Vorlagen/m1_startklar_260820.md` sind leer. Der
   Unterschied ist gemessen — gegen M30 allein melden die Prüffälle 108 von 111, gegen
   M30 + M31 + M32 melden sie 111 von 111. Der Harness entscheidet das nicht.
2. **M32 trägt keine `-- umsetzt:`-Zeile im Kopf.** `werkzeuge/herkunft.py` führt die Datei
   deshalb ohne Herkunftskante zur Klausel. M31 macht es vor.

## Regeln

- Jede Migration führt **vier eigene** Negativfälle. Drei genügen nicht, und Fälle einer
  anderen Migration zählen nicht mit.
- Jede Migration trägt im Kopf `-- umsetzt: K##-M##` — daraus entsteht die Herkunftskante.
- Ein Negativfall gilt erst als bestanden, wenn er an **seiner eigenen** Bedingung scheitert.
  Ein Fall, der aus einem anderen Grund abgewiesen wird, hat nichts gemessen.
- Angewendet wird nur in der Datenbank des jeweiligen Anlaufs. Ausschließlich synthetische,
  je Mandant gekennzeichnete Daten; Zugänge kommen aus `PG*`-Umgebungsvariablen, nie aus
  einer Datei in diesem Repo.
