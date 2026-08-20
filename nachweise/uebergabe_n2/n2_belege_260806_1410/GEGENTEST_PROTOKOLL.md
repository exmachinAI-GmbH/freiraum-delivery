# N2 · Gegentest-Protokoll  

*Zeichnungsakt Nr. 2 zum Abnahmenachweis vom 06.08.2026 (dort Beleg 3). Maßstab **F07**:
Ein Gegentest ist nur bestanden, wenn er an der **vorgesehenen** Regel gescheitert ist.
Ein Scheitern aus anderem Grund ist kein Bestehen — auch wenn der Fall grün gemeldet wird.*

| Feld | Wert |
|---|---|
| Lauf | `n2_belege_260806_1410`, 06.08.2026 14:12 |
| Umgebung | `psql-freiraum-pilot.postgres.database.azure.com` · PostgreSQL 16 · `swedencentral` |
| Rohbeleg | `gegentest_meldungen.txt` |
| `M30__pruefung.sql` SHA-256 | `fc2a2341eea474aaa6637083d127d79ecc073b6c5615a1d8e314d133e032d319` |

---

## 1 · Der Umfang

| | |
|---|---|
| Prüffälle im Lauf | **110**, davon 0 gescheitert |
| davon Gegentests (Fall muss scheitern) | **66** |
| davon Positivbelege (Fall muss gelingen) | **43** |
| Zeilen im Rohbeleg | **109** — siehe Abschnitt 4, `MT-104b` fehlt |

## 2 · Wie die 66 Gegentests ihre Regel nennen

| | Art des Nachweises | Anzahl |
|---|---|---|
| a | **Eigene `RAISE`-Meldung** mit benannter Regel im Wortlaut | **33** |
| b | **Namentlich genannte Bedingung** der Datenbank (`violates … constraint "…"`) | **28** |
| c | Meldung **ohne** benannte Regel — einzeln geprüft, Abschnitt 3 | **5** |

Die Regelfamilien der eigenen Meldungen (a):

| Anzahl | Kennung |
|---|---|
| 8 | `UEBERGANG` — Zustandsmatrix, Nr. 53 / H02 |
| 6 | `APPEND-ONLY` — Protokollzeilen unveränderlich, K14-D09 |
| 2 | `SITZUNGSMANDANT` |
| 2 | `AGENT-FREIGABE` — Vier-Augen-Freigabe, Nr. 32 |
| 2 | `EIGNUNGSRIEGEL` |
| je 1 | `EINSCHRAENKUNG` · `MITTELBARER BEZUG` · `KONTO-SPERRE` |

Bei (a) und (b) steht die Regel in der Meldung selbst. Der F07-Maßstab ist damit unmittelbar
am Beleg ablesbar und nicht aus dem Fallnamen erschlossen.

## 3 · Die fünf Meldungen ohne benannte Regel — einzeln geprüft

Bei diesen fünf nennt die Datenbankmeldung keine Regel im Wortlaut. Sie sind deshalb gegen
den Zweck des Falls gehalten worden:

| Fall | Was der Fall prüfen soll | Tatsächliche Meldung | Urteil |
|---|---|---|---|
| **MT-50** | Gestrichener Wert `ZUSTAND` existiert nicht (E2/A) | `invalid input value for enum template_status_content: "ZUSTAND"` | **trifft** — die Ablehnung des Enum-Werts *ist* die vorgesehene Regel |
| **MT-89** | Die Abnahmerolle darf nicht schreiben (T1, K13-M18) | `permission denied for table event` | **trifft** — der Rechteschnitt ist die vorgesehene Regel |
| **MT-90** | Der Quellenbroker sieht die Konten nicht (T1) | `permission denied for table actor` | **trifft** |
| **MT-96** | Der Portalpfad darf `app` nicht direkt beschreiben (O-K01-20) | `permission denied for table app` | **trifft** |
| **MT-97** | Der Portalpfad darf `actor.sealed` nicht ändern (T1) | `permission denied for table actor` | **trifft** — siehe aber die Einschränkung unten |

### Einschränkung zu MT-96 und MT-97

**Beide belegen die geschlossene Tür, nicht die eine offene.** Stufe 14 lässt für den
Portalpfad ausdrücklich genau einen Weg offen — `create_app_after_fit`, `change_app_state`
und zwei Spalten an `actor`. **Dafür gibt es keinen Prüffall.** Fielen die zugehörigen
GRANT-Anweisungen weg, blieben MT-96 und MT-97 grün.

Das ist **kein** Verstoß gegen F07 — beide scheitern an der vorgesehenen Regel. Es ist eine
Lücke in der Deckung, und zwar dieselbe, an der MT-104 und MT-105 hingen: Ein Fall besteht,
weil etwas *nicht* geht, und niemand misst, ob das Gewollte geht. **Ein Positivfall gehört in
die nächste Runde.**

PostgreSQL meldet bei fehlendem Spaltenrecht dieselbe Zeile wie bei fehlendem Tabellenrecht.
Die Meldung von MT-97 kann deshalb nicht unterscheiden, ob die Spaltenbeschränkung greift
oder ob die Rolle überhaupt keine Rechte an `actor` hat. Auch das spricht für den Positivfall.

## 4 · Ein Fall fehlt im Rohbeleg

`MT-104b` steht nicht in `gegentest_meldungen.txt`. Ursache ist das Extraktionsmuster in
`n2_lauf.sh` Zeile 161 (`MT-[0-9]+ · `), das Kennungen mit Buchstabenzusatz nicht erfasst.

Der Fall ist **bestanden** und in `pruefung_ausgabe.log` belegt:

```
MT-104b · BESTANDEN — Passende Sitzung wird auch bei Durchsetzung angenommen (T4) · angenommen
```

Es ist ein **Positivbeleg**, kein Gegentest — für den F07-Maßstab dieses Protokolls also ohne
Folge. Zu beheben ist das Skript, nicht dieser Lauf.

## 5 · Ergebnis

**Alle 66 Gegentests sind an der vorgesehenen Regel gescheitert.** 61 nennen ihre Regel im
Wortlaut der Meldung, 5 wurden einzeln gegen den Zweck des Falls geprüft und treffen ihn.
Kein Fall ist an einer anderen Regel gescheitert als der gemeinten.

Zwei Einschränkungen sind benannt und nicht behoben: die fehlende Positivdeckung des
Portalpfads (Abschnitt 3) und die fehlende Zeile im Rohbeleg (Abschnitt 4). Beide gehören in
die nächste Runde; keine entwertet ein Ergebnis dieses Laufs.

---

## Zeichnung

> **Diese Zeichnung bestätigt eine Durchsicht, keine Zahl.** Wer sie setzt, erklärt, die
> Meldungen gelesen zu haben — nicht, dass ein Werkzeug 110 gemeldet hat.

| Name | Datum | Unterschrift |
|---|---|---|
| A. Han | 6.8.26  | A. Han |
