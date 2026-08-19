# N2 · Abnahmenachweis der Sammelmigration 

| Feld | Wert |
|---|---|
| Lauf am | 06.08.2026 14:12 |
| Umgebung | `psql-freiraum-pilot.postgres.database.azure.com` — Azure Database for PostgreSQL, Flexible Server, **PostgreSQL 16**, Region **`swedencentral`**, Datenbank `freiraum` (leer angelegt am 06.08.2026, 12:27). **Ja, es war die Zielumgebung.** Ressourcengruppe `rg-freiraum-pilot`, Konto `frxadmin` (kein SUPERUSER) |
| M30__pilot_sammelmigration.sql SHA-256 | `1af077c540f910d3871ad3b459c5bdeff51034274cbb6b680c065eb3fd2fac4d` |
| M30__pruefung.sql SHA-256 | `fc2a2341eea474aaa6637083d127d79ecc073b6c5615a1d8e314d133e032d319` |

## Welche Pruefungen bestanden wurden

| | Pruefung | Ergebnis | Beleg |
|---|---|---|---|
| 1 | Migration zweimal, **Schema und Daten** unveraendert | beide diffs leer | `schema_diff.txt` · `daten_diff.txt` |
| 2 | Prueffaelle | SUMME: 110 von 110 bestanden, 0 gescheitert | `pruefung_ausgabe.log` |
| 3 | Gegentests an der vorgesehenen Regel (F07) | 109 Meldungen einzeln | `gegentest_meldungen.txt` — **von A. Han durchzusehen, nicht nur zu zaehlen** |
| 4 | Eingefrorene Faelle T0–T21 **und T22/T23 mit Ersatz-Setup** | alle OK | `t0_t23_ergebnis.txt` · `t22_t23_ergebnis.txt` |
| 5 | Objektzahlen gemessen | tabellen 57 sichten 12 trigger 27 funktionen 27 davon_mit_suchpfad 27 enums 44 rollen 6  | `objektzahlen.txt` — kanon.yaml **erst jetzt** nachziehen (F6) |

## Welcher Stand geprueft wurde

Die beiden Pruefsummen oben gehoeren zu Fassungen **vom 06.08.2026**, nicht zu denen vom
5.8. Die Migration wurde am Vormittag des 06.08.2026 an drei Stellen korrigiert; die
Pruefdatei erhielt zwei neue Faelle (MT-108, MT-109). Vollstaendig belegt in
`BEFUNDE_260806_N1_N2_N4.md` im Ordner darueber (`uebergabe/migration/`):

| | Befund | Stand |
|---|---|---|
| **N-4** | Die Migration brach auf der Zielumgebung ab (`ALTER ROLE … NOSUPERUSER`, Stufe 14). Das Administratorkonto eines Flexible Server ist kein SUPERUSER | behoben |
| **N-2** | Der Freigabewaechter fuer Agenten griff beim EINFUEGEN nicht — die Vier-Augen-Freigabe nach Nr. 32 war umgehbar | behoben, Prueffall MT-108 |
| **N-1** | `NOLOGIN` fehlte in der Nachhaertung der sechs Dienstidentitaeten | behoben, Prueffall MT-109 |

**N-4 ist der Grund, warum dieser Nachweis nicht die Laeufe vom 5.8. wiederholt:** Jene
liefen gegen eine Datenbank, auf der das Konto SUPERUSER war. Auf der Zielumgebung waere
die Migration an der ersten der sechs Rollen gescheitert.

**Offen und nicht Gegenstand dieses Nachweises:** Befund **N-3** (`tv_merkmale_ganz`
verlangt alle fuenf Merkmale auch fuer Elementvorlagen, gegen die gezeichnete E2) — das ist
eine Aenderung an gezeichnetem Recht und liegt bei M. Veil. Ebenso der Restpunkt aus N-2:
ein `UPDATE` aus einem anderen Zustand als `IN_REVIEW` nach `RELEASED` laeuft weiterhin am
Waechter vorbei.

## Grenzen dieses Nachweises

Zwei Einschraenkungen, benannt statt verschwiegen. Keine entwertet ein Ergebnis; beide
begrenzen seine Aussage.

**1 · Beleg 3 fuehrt 109 Meldungen bei 110 Faellen.** `MT-104b` fehlt in
`gegentest_meldungen.txt`. Ursache ist das Extraktionsmuster in `n2_lauf.sh` Zeile 161
(`MT-[0-9]+ · `), das Kennungen mit Buchstabenzusatz nicht erfasst. Der Fall selbst ist
**bestanden** — nachweisbar in `pruefung_ausgabe.log`: *„MT-104b · BESTANDEN — Passende
Sitzung wird auch bei Durchsetzung angenommen (T4)"*. Zu beheben am Skript, nicht an diesem
Lauf.

**2 · MT-96 und MT-97 belegen die geschlossene Tuer, nicht die eine offene.** Beide zeigen
`permission denied` fuer den Portalpfad. Stufe 14 laesst aber ausdruecklich genau einen Weg
offen — `create_app_after_fit`, `change_app_state` und zwei Spalten an `actor`. **Dafuer
gibt es keinen Prueffall.** Fielen die zugehoerigen GRANT-Anweisungen weg, blieben MT-96 und
MT-97 gruen. Das ist kein Verstoss gegen F07 — beide Gegentests scheitern an der
vorgesehenen Regel —, aber es ist dieselbe Luecke, an der MT-104 und MT-105 hingen: Ein Fall
besteht, weil etwas *nicht* geht, und niemand misst, ob das Gewollte geht.

**Warum das hier steht und nicht nachgebessert wurde:** Ein zusaetzlicher Positivfall
aenderte `M30__pruefung.sql` und damit die Pruefsumme — der gesamte Lauf waere zu
wiederholen. Der Befund ist dafuer zu klein. Er gehoert in die naechste Runde.

## Wer gezeichnet hat

| Name | Datum | Unterschrift |
|---|---|---|
| A. Han | 6.8.26 | Andrew Han |

> Dieses Blatt ist ein ENTWURF aus `n2_lauf.sh`. Es traegt Messwerte, keine
> Unterschrift — die setzt allein A. Han, nachdem er Beleg 3 gelesen hat.
> Danach nimmt M. Veil ab (N2 im Blatt *Zeichnungen und Abnahmen*).
