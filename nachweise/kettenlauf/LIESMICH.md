# Kettenlauf · Belege

Erzeugt von `migrations/kettenlauf.sh`. Ein Belegordner je Lauf, benannt nach
Zeitpunkt und Umfang.

| Ordner | Umfang | Konto | Verwendbar als Nachweis? |
|---|---|---|---|
| `260822_1720_alle_SUPERUSER` | alle | **SUPERUSER** | **NEIN** |
| `260822_1720_m30_SUPERUSER` | m30 | **SUPERUSER** | **NEIN** |
| `260822_1847_alle_nicht_superuser` | alle | NOSUPERUSER + BYPASSRLS | als **Prüfstandslauf**, nicht als Zielumgebungslauf |

## Warum die beiden Läufe von 17:20 nicht zählen

Sie liefen als SUPERUSER. Ein Superuser umgeht den Zeilenschutz immer — deshalb
war dort unsichtbar, dass `pg_dump --data-only` gegen die von M32 gesetzte
Klammer `FORCE ROW LEVEL SECURITY` als Nicht-Superuser abbricht. Dieselbe Grube
ist im Bestand schon beschrieben: `M30__pilot_sammelmigration.sql`:2029–2031
hält fest, dass die Läufe vom 05.08.2026 gegen ein Konto mit SUPERUSER liefen
und *„eine Migration, die auf der Pruefdatenbank durchlaeuft, nicht deshalb auch
im Ziel laeuft"*.

**Sie werden nicht gelöscht (F36), aber sie tragen nichts.**

## Was der Lauf von 18:47 zeigt — und was nicht

Er lief als Rolle ohne SUPERUSER. Beide Hälften des Idempotenzbeweises liegen
zum ersten Mal vor: `erstlauf_schema_diff.txt` und `erstlauf_daten_diff.txt`
sind **nicht leer** (Lauf 1 hat etwas verändert), `schema_diff.txt` und
`daten_diff.txt` sind **leer** (Lauf 2 hat nichts verändert).

**Was er nicht zeigt:** die Zielumgebung. Er lief gegen ein lokales
PostgreSQL 16, nicht gegen `psql-freiraum-pilot`. Das Feld
*„War es die Zielumgebung?"* in `NACHWEIS.md` steht deshalb auf
**VON DER ZEICHNENDEN PERSON EINZUTRAGEN**.

## Zur Nachbildung von `frxadmin`

Der erste Versuch lief mit einer Rolle **ohne** `BYPASSRLS` und brach in
`M30`:2051 ab: *„permission denied to alter role — Only roles with the BYPASSRLS
attribute may change the BYPASSRLS attribute."*

**Das ist kein Befund gegen Azure, sondern gegen die Nachbildung.** `M30`:2025–2026
hält eine Messung **von der Zielumgebung selbst** fest, vom 06.08.2026:
*„NOLOGIN, NOCREATEDB, NOCREATEROLE und NOBYPASSRLS werden akzeptiert, allein
NOSUPERUSER nicht."* Das Konto dort kann es also. Ein Prüfstand, der `frxadmin`
nachbilden will, braucht daher **NOSUPERUSER + BYPASSRLS** — sonst ist er
strenger als das Ziel und meldet Fehler, die dort keine sind.
