# Triage der Klauseln nach K23-M04 — **Vorschlag, keine Feststellung**

Erzeugt von `werkzeuge/triage.py`. Jede Einordnung trägt die Belegstelle,
die sie ausgelöst hat. **`unbestimmt` heißt nicht `nicht kritisch`** — es heißt,
dass kein Begriff der fünf Gruppen im Wortlaut vorkommt und die Maschine hier
nichts beiträgt. Diese Zeilen sind die Arbeitsliste, nicht der Rest.

## Die Zahl, nach der gefragt war

| | Anzahl | Anteil |
|---|---|---|
| Klauseln gesamt | 1231 | 100 % |
| **kritisch nach K23-M04** | **405** | 32 % |
| unbestimmt | 826 | 67 % |
| von einem Prüffall genannt | 46 | 3 % |
| **kritisch und ohne Prüffall** | **386** | 31 % |

Die letzte Zeile ist die, die zählt. K23-M04, letzter Satz:

> *„Ist die Klausel sicherheits-, mandanten-, freigabe-, aufbewahrungs- oder
> wiederherstellungskritisch, **sperrt der fehlende Test die Freigabe**.“*

Diese Klauseln brauchen entweder einen Prüffall oder eine gezeichnete
Annahmeentscheidung mit Träger — sonst sperren sie Tor II.

## Nach Gruppe

| Gruppe | Klauseln |
|---|---|
| sicherheitskritisch | 120 |
| mandantenkritisch | 107 |
| freigabekritisch | 156 |
| aufbewahrungskritisch | 62 |
| wiederherstellungskritisch | 18 |

Eine Klausel kann in mehreren Gruppen stehen; die Summe ist deshalb größer
als die Zahl der kritischen Klauseln.

## Nach Konzept

| Konzept | gesamt | kritisch | mit Prüffall | **kritisch ohne Prüffall** |
|---|---|---|---|---|
| K00 | 24 | 2 | 0 | **2** |
| K01 | 81 | 30 | 1 | **29** |
| K02 | 61 | 34 | 2 | **33** |
| K03 | 50 | 26 | 12 | **21** |
| K04 | 49 | 10 | 0 | **10** |
| K05 | 56 | 8 | 0 | **8** |
| K06 | 63 | 7 | 2 | **7** |
| K07 | 46 | 15 | 0 | **15** |
| K08 | 53 | 17 | 3 | **16** |
| K09 | 39 | 17 | 0 | **17** |
| K10 | 61 | 21 | 0 | **21** |
| K11 | 54 | 16 | 0 | **16** |
| K12 | 26 | 10 | 0 | **10** |
| K13 | 53 | 21 | 1 | **20** |
| K14 | 53 | 32 | 3 | **29** |
| K15 | 41 | 23 | 0 | **23** |
| K16 | 54 | 5 | 0 | **5** |
| K17 | 79 | 28 | 1 | **28** |
| K18 | 59 | 13 | 0 | **13** |
| K19 | 32 | 7 | 0 | **7** |
| K20 | 46 | 15 | 16 | **10** |
| K21 | 40 | 12 | 0 | **12** |
| K23 | 41 | 19 | 4 | **17** |
| K25 | 70 | 17 | 1 | **17** |

## Was hier NICHT steht

**Kein Akzeptanzkriterium.** K23-M02:

> *„Fehlt das Akzeptanzkriterium, liefert es der in derselben Zeile eingetragene
> fachliche Eigentümer nach; bis dahin bleibt der Bauauftrag unvollständig.“*

Der Eigentümer ist ein Mensch. Ein Kriterium, das dieses Werkzeug ausdächte, wäre
der teuerste Fehler dieser Arbeit — ab dann prüfte der Bau gegen eine erfundene
Erwartung und bestände.

**Keine Entscheidung.** Der Eigentümer-Vorschlag ist das Konzept, in dem die
Klausel steht. Wo `kanon.yaml` eine Sache einem anderen Konzept zuordnet, gewinnt
`kanon.yaml`; das sieht dieses Werkzeug nicht.

**Keine Sperre.** K23-M04 sperrt die Freigabe, nicht Tor 1. Dieses Werkzeug
meldet Zahlen; wer sperrt, ist Tor II.

