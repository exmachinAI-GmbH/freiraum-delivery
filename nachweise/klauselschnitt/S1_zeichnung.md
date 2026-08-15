# Klauselschnitt Scheibe 1 · zur Zeichnung

> **Diese Datei gehört dem Menschen.** Ein Werkzeug legt sie an und fügt fehlende
> Regelzeilen hinzu. In eine bestehende Zeile schreibt es **nie** — auch dann nicht,
> wenn noch kein Kreuz gesetzt ist. Wer sie überschreibt, löscht eine Entscheidung.

| Feld | Wert |
|---|---|
| Scheibe | **1 · der dünne Faden** |
| Grundlage des Fadens | Anlage Baustrategie, Zeilen 52–70, gezeichnet 05.08.2026 |
| Angelegt am | 15.08.2026 |
| Regeln im Bestand | 1 231 |
| Vom Stichwortverzeichnis berührt | 454 |
| Zur Zeichnung vorgelegt | Block 1: 13 · Block 2: 2 · Block 3: siehe unten |

---

## Was dieses Blatt ist — und was nicht

Dieses Blatt **registriert die Zuordnung** von Regeln zur Scheibe 1. Jede Zeile ist
einzeln aufgeführt und einzeln darauf geprüft, ob eine gezeichnete Festlegung sie
ausnimmt (Beschluss Nr. 102 vom 05.08.2026).

Es ändert **keinen Meilenstein, kein Tor und keine Abnahmebedingung.** Die Zuordnung
gehört zur Steuerung, nicht zur Abnahme — die Anlage Baustrategie trennt beides in
ihren Zeilen 182 bis 188 ausdrücklich.

**Was hier nicht steht:** keine Kritikalität, kein Akzeptanzkriterium, keine
Aussage darüber, ob eine Regel erfüllt ist. Und keine Quote — nach Festlegung F34
wörtlich: *„Eine Abdeckungsquote ersetzt diese Liste nicht. 95 % sagen nichts darüber,
ob die fehlenden 5 % die kritischen sind."*

---

## Wie eine Zeile gelesen wird

Jede Zeile beantwortet zwei Fragen getrennt: **gehört die Regel hierher** — und
**was heißt das**.

| Geltung | Bedeutung |
|---|---|
| **`neu_ab`** | in dieser Scheibe **zum ersten Mal zu bauen** — und von da an in jedem späteren Lauf mitzumessen. Der Regelfall |
| **`einmalig`** | nur in dieser Scheibe zu messen, danach nie wieder. Braucht eine eigene Begründung |
| **`quer`** | gilt in **jeder** Scheibe, in keiner zum ersten Mal. Kommt auf kein Scheibenblatt, sondern auf das Querschnittsblatt |
| **`fuehrend`** | ab dieser Scheibe **geführt** und fortgeschrieben — nicht gebaut, nicht im Lauf gemessen. Das sind die Nachweise |
| **`ausserhalb`** | keiner Scheibe zugeordnet |

Dazu bei `neu_ab` die **Tiefe**: `duenn` heißt *so viel, wie der dünne Faden braucht*;
`voll` heißt *die ganze Breite*. Dieselbe Zugangsregel kann in Scheibe 1 dünn und in
Scheibe 3 voll gelten — ohne dieses Feld weiß der Bau nicht, wie viel er schuldet.

**Der Haken je Zeile trägt die Zuordnung. Das Sammelkreuz bestätigt nur die Sammlung.
Eine Zeile ohne Haken bleibt offen, auch wenn das Sammelkreuz steht.**

---

## Block 0 · schon anderswo gezeichnet

*Leer.* Es liegt noch kein anderes gezeichnetes Blatt vor. Sobald eines existiert,
stehen hier die Regeln, die dort bereits `quer` oder `ausserhalb` tragen — zur
Kenntnis, nicht zur erneuten Zeichnung.

---

## Block 1 · Der Vertrag schweigt, aber der gebaute Code beansprucht sie

**Ein Sammelkreuz deckt diesen Block.** Zulässig, weil jede Zeile einzeln aufgeführt
ist, jede ihre Fundstelle trägt und je Zeile geprüft wurde, ob eine gezeichnete
Festlegung sie ausnimmt.

Woher sie kommen: Diese dreizehn Regeln werden von einer Datei beansprucht, die in
ihrem Kopf **zugleich** „FREIRAUM · Scheibe 1" sagt **und** die Regel in einer Zeile
`umsetzt:` nennt. Das ist keine Ableitung, sondern eine Abschrift — der Bau hat es
selbst notiert, während er baute.

*Hinweis zur Vertragskette: Die Zeile der Scheibe 1 in der Anlage Baustrategie sagt
wörtlich „schließt Meilenstein: keinen — sie ist Integrationsprobe". Über den Vertrag
lässt sich für diese Scheibe deshalb **keine einzige** Regel herleiten. Alles hier
stammt aus dem gebauten Bestand oder aus Ihrer eigenen Lesung.*

| Regel | Art | Was sie verlangt | Fundstelle im Bau | Geltung | Tiefe | ✓ | abweichend |
|---|---|---|---|---|---|---|---|
| **K03-D01** | DARF NICHT | Kein Vorgang wird ohne gültige Sitzung und aktives Konto wirksam. Halb-Zugang gibt es nicht | `app/haupt.py:1` | `neu_ab` | `duenn` | [ ] | |
| **K03-G01** | GILT | Was nicht geprüft werden kann, wird gesperrt — und die Sperre wird begründet angezeigt | `app/haupt.py:1` | `neu_ab` | `duenn` | [ ] | |
| **K03-M05** | MUSS | Der zweite Faktor ist ein sechsstelliger Code per E-Mail. Ein anderes Verfahren kennt das Datenmodell nicht | `app/haupt.py:1` · `app/einladung.py:1` · `mail/versand.py:2` | `neu_ab` | `duenn` | [ ] | |
| **K03-M13** | MUSS | Jede Prüfung der Anmeldung läuft auf dem Server. Eine Prüfung nur in der Oberfläche gilt als nicht erfolgt | `app/haupt.py:1` | `neu_ab` | `duenn` | [ ] | |
| **K03-M26** | MUSS | Der Mailversand nutzt eine verwaltete Identität; Codes und volle Adressen stehen nie im Protokoll; Fehler sperren und alarmieren | `app/einladung.py:1` · `mail/versand.py:2` | `neu_ab` | `duenn` | [ ] | |
| **K13-M05** | MUSS | Jeder Aufruf aus der Oberfläche läuft über den Serverpfad, der Konto, Mitgliedschaft, Rolle, Mandant und Objektbezug prüft | `app/haupt.py:1` | `neu_ab` | `duenn` | [ ] | |
| **K20-D10** | DARF NICHT | Eine abgelaufene, eingelöste oder widerrufene Einladung wirkt nicht erneut. Ein verfallener Link führt zu einem neuen Vorgang | `app/einladung.py:1` | `neu_ab` | `duenn` | [ ] | |
| **K20-M08** | MUSS | Gespeichert wird nur der Streuwert des Links. Wer die Datenbank liest, kann keine fremde Einladung einlösen | `app/einladung.py:1` · `app/haupt.py:1` | `neu_ab` | `duenn` | [ ] | |
| **K20-M14** | MUSS | Einlösung setzt Zustand und Zeitpunkt gemeinsam — nie das eine ohne das andere | `app/einladung.py:1` | `neu_ab` | `duenn` | [ ] | |
| **K20-M15** | MUSS | Nach der Einlösung wechselt das Konto von *wartet auf zweiten Faktor* auf *aktiv* | `app/einladung.py:1` | `neu_ab` | `duenn` | [ ] | |
| **K20-M18** | MUSS | Jede Änderung an Zugang, Rolle, Mitgliedschaft oder Einladung steht mit Zeitpunkt, Handelndem und Wert davor und danach im Nachweis | `app/einladung.py:1` | `neu_ab` | `duenn` | [ ] | |
| **K20-M25** | MUSS | Wiederversand sagt ausdrücklich, dass der vorherige Link ungültig ist; der Nachweis trägt die Aufbewahrungsklasse Betriebsprotokoll | `app/haupt.py:1` | `neu_ab` | `duenn` | [ ] | |
| **K23-D09** | DARF NICHT | Keine Geheimnisse, Zugangswerte oder unmaskierten Personenangaben in Manifest, Protokoll, Bildschirmabzug oder Fehlerausgabe. Ein Fund sperrt den Lauf | `app/haupt.py:2` | **`quer`?** | — | [ ] | |

> **Eine Zeile in Block 1 ist zweifelhaft, und zwar von uns aus, nicht von Ihnen.**
> **K23-D09** wird von `app/haupt.py` beansprucht — aber sie gilt für jeden Lauf in
> jeder Scheibe, nicht erst ab Scheibe 1. Wir schlagen `quer` vor statt `neu_ab`. Wenn
> Sie das anders sehen, tragen Sie es in die Spalte *abweichend* ein.

---

## Block 2 · Der Code beansprucht sie, nennt aber keine Scheibe

**Sammelkreuz zulässig, aber jede Zeile trägt eine Gegenprobe.**

Diese beiden Regeln stehen in der `umsetzt:`-Zeile von `mail/versand.py` — einer Datei,
die sich im Kopf **„B2 · Versandweg"** nennt und **keine Scheibennummer** trägt. Der
Anspruch ist da, die Zuordnung nicht.

| Regel | Art | Was sie verlangt | Gegenprobe | Geltung | Tiefe | ✓ | abweichend |
|---|---|---|---|---|---|---|---|
| **K03-M15** | MUSS | Ein E-Mail-Code gilt zehn Minuten und genau einmal. Ein neuer Code entwertet alle älteren desselben Kontos. Gespeichert wird nur sein Prüfwert | Gehört der Versandweg zum dünnen Faden? Das Fadendiagramm nennt in Zeile 55 „Einladung kommt an (echter Mailweg)" — das spricht dafür. Und die Regel gehört sachlich zum Anmeldecode, der Station ohne jeden Treffer | | | [ ] | |
| **K03-M25** | MUSS | Ein serverseitiger Einladungsbefehl prüft Zielmandant, Entscheidungsnachweis und Domäne und legt Einladung und Ereignis in einem Zug an. Portal, Builder und Dienstschlüssel dürfen die Prüfung nicht umgehen; Fehlermeldungen verraten nicht, ob ein Konto existiert | dieselbe Frage. Sachlich gehört sie zur Station „Einladung senden" (BS:53) | | | [ ] | |

---

## Block 3 · Leseanlässe — hier gilt kein Sammelkreuz

*Wird aus den Leseblättern ergänzt.*

**In diesem Block gilt eine Zeile ausschließlich mit ihrem eigenen Haken als
gezeichnet.** Ohne Haken bleibt sie offen. Das ist kein Versäumnis, sondern das
richtige Ergebnis: ein Wort, das in einer Regel und in der Beschreibung des Fadens
vorkommt, belegt, dass ein Wort an zwei Stellen steht — nicht, dass die Regel zu
dieser Scheibe gehört.

**Vier Stationen sind gemessen untauglich** — ihre Trefferliste geht vollständig in
einer Querschnittsgruppe auf, sie benennen also etwas, das in jeder Scheibe gilt:

| Station | Treffer | steckt ganz in |
|---|---|---|
| Anmeldung | 6 | sicherheitskritisch |
| Unterschrift | 5 | freigabekritisch |
| Kenntnisnahme | 3 | freigabekritisch |

**Eine Station traf zunächst überhaupt nichts: `Anmeldecode`** — ausgerechnet die, an
der gerade gebaut wird. Der Grund war kein Mangel im Bestand, sondern ein
Wortunterschied: die Konzepte nennen dieselbe Sache **„E-Mail-Code"** oder
**„zweiter Faktor"**, nie „Anmeldecode".

Die Gleichsetzung ist nicht geraten, sie steht wörtlich in zwei Regeln:

> **K03-M05** — *„Der zweite Faktor MUSS ein sechsstelliger Code per E-Mail sein:
> `mfa_method` = EMAIL_CODE."*
>
> **K03-M15** — *„Ein E-Mail-Code ist zehn Minuten und genau einmal gültig."*

Damit trägt die Station **19 Regeln** statt null, verteilt auf fünf Konzepte —
darunter K14 und K19, die über den Vertrag für Scheibe 1 gar nicht erreichbar wären.
Falls Sie eine der drei Gleichsetzungen nicht mittragen, streichen Sie sie; die
Übersicht in `S1_wortmarken.md` führt jede einzeln mit ihrem Beleg auf.

**Ob dieselbe Sprachlücke bei anderen Stationen besteht, ist nicht geprüft.** Das ist
Lesearbeit am Wortlaut, keine Messung — und sie gehört zu dem, was Sie beim
Durchgehen von Block 3 bemerken werden.

---

## Block 4 · offen

Alles, was in keinem der Blöcke steht, ist **offen** — und wird als offen gezählt,
nie als erledigt. „Offen" heißt hier nichts anderes als: *die Maschine trägt an dieser
Stelle nichts bei.*

---

## Menschliche Entscheidung

- [ ] **Wie vorgeschlagen** — mit den unter *abweichend* eingetragenen Änderungen
- [ ] **Mit Auflagen** — die Auflagen gehen als benannte offene Punkte zurück
- [ ] **Nicht gezeichnet** — weil:

| Name | Datum | Begründung / Auflagen |
|---|---|---|
| | | |

*Mitzeichnung:* Sollte eine der oben stehenden Regeln an einer Bauaufgabe hängen, die
A. Han abnimmt — L1 (Zeilenschutz), L2 (Identitätsvertrag), L6 (Betriebsziele) oder die
Voraussetzungen V0, V1, V3 — dann tragen Sie das bitte in der Spalte *abweichend* mit
dem Wort `mitzeichnen` ein. Die Maschine markiert das **nicht** vor: das Feld
*fachlicher Eigentümer* ist in allen 1 231 Registerzeilen leer, und kein Regelwortlaut
nennt eine Bauaufgabe. Eine maschinelle Vormarkierung wäre eine Erfindung.
