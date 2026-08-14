# Herkunftsgraph — `Quelle → Klausel → Umsetzung → Test → Nachweis`

Erzeugt von `werkzeuge/herkunft.py`. **Nicht von Hand pflegen.**

Dieser Nachweis ist nach K23-M03 vorgeschrieben — der Klausel, die verlangt, dass
jede Anforderung von ihrer Quelle bis zu ihrem Nachweis lückenlos verfolgbar ist —
und er ist **Bedingung 4 der technischen Lieferabnahme (Tor II)**.

**Er sperrt nichts.** Eine fehlende Kante ist ein Befund. Wer sperrt, ist Tor II.

## Die Zahlen

| | Anzahl |
|---|---|
| Anforderungen insgesamt | 1231 |
| **vom gebauten Code genannt** | **83** |
| davon ausdrücklich als umgesetzt erklärt (`umsetzt:`) | 0 |
| davon nur nebenbei erwähnt | 83 |
| vom Code genannt **und** von einem Prüffall gemessen | 41 |
| **vom Code genannt und von niemandem gemessen** | **42** |
| **davon als kritisch vorgeschlagen** | **18** |
| Bildschirme im Vertrag | 33 |
| davon gebaut | 1 |

Die Zeile *davon als kritisch vorgeschlagen* ist die, auf die es ankommt:
**gebaut, als kritisch eingestuft, von niemandem geprüft.** Die Einstufung
*kritisch* ist ein Vorschlag aus der Triage, keine Feststellung — die trifft
ein Mensch.

**Der Unterschied zwischen *erklärt* und *erwähnt*, und warum er wichtig ist:**
Eine Datei gilt erst dann als Umsetzung einer Anforderung, wenn sie eine Zeile
`umsetzt:` mit der Kennung trägt. Kommt die Kennung nur irgendwo im Text vor,
zählt sie nicht — denn `app/haupt.py` nennt eine Anforderung gerade, um zu sagen,
dass hier **nicht** danach gehandelt wird. Eine reine Textsuche hätte das als
Umsetzung gezählt und den Graphen zum Lügen gebracht.

## Die sieben Fragen nach isolierten Ergebnissen

| | Frage | Anzahl |
|---|---|---|
| 1 | Welche gebaute Datei sagt nicht, wofür sie da ist? | **8** |
| 2 | Was wird gemessen, das niemand gebaut hat? | **5** |
| 3 | Welche gebaute Anforderung prüft niemand? | **44** |
| 4 | Welcher Prüffall ist noch nie in einem Protokoll gelaufen? | **2** |
| 5 | Welches Protokoll führt eine Kennung ohne Prüffall? | **4** |
| 6 | Welcher Bildschirm des Vertrags ist nicht gebaut? | **32** |
| 7 | Welche genannte Kennung gehört zu keiner bekannten Anforderung? | **0** |

### Im Einzelnen

**1 · Welche gebaute Datei sagt nicht, wofür sie da ist?** — 8 Einträge

- `install/nach_umzug.sh`
- `install/pruefe_b1.sh`
- `install/pruefe_schranke.sh`
- `mail/__init__.py`
- `migrations/negativfaelle/N2_mail_fehler_braucht_grund.sql`
- `migrations/negativfaelle/N3_pseudonym_vor_frist.sql`
- `migrations/negativfaelle/N4_tagesfrist_positiv.sql`
- `migrations/pruefe_negativfaelle.sh`

**2 · Was wird gemessen, das niemand gebaut hat?** — 5 Einträge

- `K03-M05`
- `K03-M06`
- `K23-D05`
- `K23-M18`
- `K23-M22`

**3 · Welche gebaute Anforderung prüft niemand?** — 44 Einträge

- `K01-M22`
- `K01-M28`
- `K01-M38`
- `K02-G02`
- `K02-M01`
- `K02-M25`
- `K03-G04`
- `K03-G09`
- `K03-G10`
- `K03-M04`
- `K03-M18`
- `K03-M21`
- `K03-M26`
- `K04-G12`
- `K08-M17`
- `K08-M25`
- `K13-D07`
- `K13-M17`
- `K13-M21`
- `K13-M22`
- `K14-M13`
- `K15-G10`
- `K15-M01`
- `K18-M27`
- `K19-D06`
- `K19-M01`
- `K19-M03`
- `K19-M10`
- `K19-M13`
- `K20-D03`
- `K20-G03`
- `K20-G08`
- `K20-M04`
- `K20-M05`
- `K20-M06`
- `K20-M09`
- `K20-M11`
- `K20-M21`
- `K20-M22`
- `K20-M24`
- … und 4 weitere (vollständig in `herkunft.json`)

**4 · Welcher Prüffall ist noch nie in einem Protokoll gelaufen?** — 2 Einträge

- `pruefungen/lauf.sh`
- `pruefungen/tor3.sh`

**5 · Welches Protokoll führt eine Kennung ohne Prüffall?** — 4 Einträge

- {'kennung': 'N1_frist_ge_mindestfrist', 'zustand': 'bestanden', 'bericht': 'nachweise/manifeste/tor1c_260813.json'}
- {'kennung': 'N2_mail_fehler_braucht_grund', 'zustand': 'bestanden', 'bericht': 'nachweise/manifeste/tor1c_260813.json'}
- {'kennung': 'N3_pseudonym_vor_frist', 'zustand': 'bestanden', 'bericht': 'nachweise/manifeste/tor1c_260813.json'}
- {'kennung': 'N4_tagesfrist_positiv', 'zustand': 'bestanden', 'bericht': 'nachweise/manifeste/tor1c_260813.json'}

**6 · Welcher Bildschirm des Vertrags ist nicht gebaut?** — 32 Einträge

- `EN-02`
- `EN-03`
- `EN-03a`
- `EN-04`
- `EN-04a`
- `EN-05`
- `EN-06`
- `EN-07`
- `EN-08`
- `EN-09`
- `EN-10`
- `EN-11`
- `EN-12`
- `EN-13`
- `EN-14`
- `EX-01`
- `EX-02`
- `EX-03`
- `EX-04`
- `EX-05`
- `EX-06`
- `EX-07`
- `EX-08`
- `EX-09`
- `EX-10`
- `EX-11`
- `EX-12`
- `EX-13`
- `EX-14`
- `EX-15`
- `EX-16`
- `EX-17`

**7 · Welche genannte Kennung gehört zu keiner bekannten Anforderung?** — 0 Einträge

*keine*

## Was hier nicht steht

**Keine Bewertung.** Der Graph sagt, wer auf wen zeigt — nicht, ob es stimmt.

**Keine erfundene Kante.** Wo ein Beleg fehlt, steht die Lücke, nicht eine
geratene Verbindung.

**Keine Sperre.** Der Rückgabewert ist immer 0, auch bei Löchern. Ein Nachweis,
der sperrt, wäre eine selbstgebaute Abnahmebedingung — und die Anlage sagt
ausdrücklich, dass eine Verletzung von Steuerungsregeln ein Projektbefund ist,
niemals eine zusätzliche Abnahmebedingung.

