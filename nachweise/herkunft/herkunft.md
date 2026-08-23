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
| **vom gebauten Code genannt** | **211** |
| davon ausdrücklich als umgesetzt erklärt (`umsetzt:`) | 40 |
| davon nur nebenbei erwähnt | 171 |
| vom Code genannt **und** von einem Prüffall gemessen | 159 |
| **vom Code genannt und von niemandem gemessen** | **52** |
| **davon als kritisch vorgeschlagen** | **24** |
| Bildschirme im Vertrag | 33 |
| davon gebaut | 7 |

Die Zeile *davon als kritisch vorgeschlagen* ist die, auf die es ankommt:
**im Code genannt, als kritisch vorgeschlagen, von keinem Prüffall gemessen.**
Solange die Zeile *als umgesetzt erklärt* auf 0 steht, hat **keine** Datei eine
Umsetzung erklärt; die bloße Nennung kann auch das Gegenteil bedeuten. Die
Einstufung *kritisch* ist ein Vorschlag aus der Triage, keine Feststellung — die
trifft ein Mensch.

**Der Unterschied zwischen *erklärt* und *erwähnt*, und warum er wichtig ist:**
Eine Datei gilt erst dann als Umsetzung einer Anforderung, wenn sie eine Zeile
`umsetzt:` mit der Kennung trägt. Kommt die Kennung nur irgendwo im Text vor,
zählt sie nicht — denn `app/haupt.py` nennt eine Anforderung gerade, um zu sagen,
dass hier **nicht** danach gehandelt wird. Eine reine Textsuche hätte das als
Umsetzung gezählt und den Graphen zum Lügen gebracht.

## Die sieben Fragen nach isolierten Ergebnissen

| | Frage | Anzahl |
|---|---|---|
| 1 | Welche gebaute Datei sagt nicht, wofür sie da ist? | **5** |
| 2 | Was wird gemessen, das niemand gebaut hat? | **40** |
| 3 | Welche vom Code genannte Anforderung ist von keinem bestandenen Lauf belegt? | **52** |
| 4 | Welcher Prüffall ist noch nie in einem Protokoll gelaufen? | **0** |
| 5 | Welches Protokoll führt eine Kennung ohne Prüffall? | **8** |
| 6 | Welcher Bildschirm des Vertrags ist nicht gebaut? | **26** |
| 7 | Welche genannte Kennung gehört zu keiner bekannten Anforderung? | **0** |

### Im Einzelnen

**1 · Welche gebaute Datei sagt nicht, wofür sie da ist?** — 5 Einträge

- `app/vorlagen/_kopf.html`
- `install/nach_umzug.sh`
- `mail/__init__.py`
- `migrations/_werkzeug/pruefklammer.sql`
- `migrations/n2_lauf.sh`

**2 · Was wird gemessen, das niemand gebaut hat?** — 40 Einträge

- `K01-G09`
- `K01-M01`
- `K01-M09`
- `K01-M16`
- `K01-M17`
- `K01-M26`
- `K01-M35`
- `K02-D01`
- `K02-M22`
- `K03-D11`
- `K03-M03`
- `K03-M20`
- `K04-D11`
- `K04-G08`
- `K04-M07`
- `K05-D08`
- `K05-G03`
- `K05-G08`
- `K05-G10`
- `K05-G11`
- `K05-G12`
- `K10-M01`
- `K10-M02`
- `K13-M10`
- `K13-M13`
- `K15-M01`
- `K17-D03`
- `K17-D13`
- `K17-M02`
- `K17-M07`
- `K17-M23`
- `K19-D09`
- `K19-G01`
- `K19-M02`
- `K19-M05`
- `K23-D07`
- `K23-M02`
- `K23-M04`
- `K23-M12`
- `K23-M18`

**3 · Welche vom Code genannte Anforderung ist von keinem bestandenen Lauf belegt?** — 52 Einträge

- `K01-D08`
- `K01-G06`
- `K01-M28`
- `K02-D05`
- `K02-G02`
- `K02-M01`
- `K02-M02`
- `K02-M07`
- `K02-M08`
- `K02-M10`
- `K02-M25`
- `K03-G04`
- `K03-G09`
- `K03-G10`
- `K03-M04`
- `K03-M08`
- `K03-M18`
- `K03-M21`
- `K04-G09`
- `K04-M22`
- `K07-M25`
- `K08-M17`
- `K08-M25`
- `K10-M30`
- `K10-M34`
- `K13-D04`
- `K13-D07`
- `K13-M12`
- `K13-M17`
- `K13-M21`
- `K14-M13`
- `K15-G10`
- `K16-D11`
- `K18-M27`
- `K18-M30`
- `K19-D06`
- `K19-M10`
- `K19-M13`
- `K20-D03`
- `K20-G03`
- … und 12 weitere (vollständig in `herkunft.json`)

**4 · Welcher Prüffall ist noch nie in einem Protokoll gelaufen?** — 0 Einträge

*keine*

**5 · Welches Protokoll führt eine Kennung ohne Prüffall?** — 8 Einträge

- {'kennung': 'N1_frist_ge_mindestfrist', 'zustand': 'bestanden', 'bericht': 'nachweise/manifeste/tor1c_260813.json'}
- {'kennung': 'N2_mail_fehler_braucht_grund', 'zustand': 'bestanden', 'bericht': 'nachweise/manifeste/tor1c_260813.json'}
- {'kennung': 'N3_pseudonym_vor_frist', 'zustand': 'bestanden', 'bericht': 'nachweise/manifeste/tor1c_260813.json'}
- {'kennung': 'N4_tagesfrist_positiv', 'zustand': 'bestanden', 'bericht': 'nachweise/manifeste/tor1c_260813.json'}
- {'kennung': 'N1_frist_ge_mindestfrist', 'zustand': 'bestanden', 'bericht': 'nachweise/manifeste/tor1c_260814.json'}
- {'kennung': 'N2_mail_fehler_braucht_grund', 'zustand': 'bestanden', 'bericht': 'nachweise/manifeste/tor1c_260814.json'}
- {'kennung': 'N3_pseudonym_vor_frist', 'zustand': 'bestanden', 'bericht': 'nachweise/manifeste/tor1c_260814.json'}
- {'kennung': 'N4_tagesfrist_positiv', 'zustand': 'bestanden', 'bericht': 'nachweise/manifeste/tor1c_260814.json'}

**6 · Welcher Bildschirm des Vertrags ist nicht gebaut?** — 26 Einträge

- `EN-03a`
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

