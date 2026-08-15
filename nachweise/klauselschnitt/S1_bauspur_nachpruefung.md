# Nachprüfung: Was der gebaute Code wirklich abdeckt

> Dreizehn Regeln werden von einer Datei beansprucht, die im Kopf „FREIRAUM · Scheibe 1“
> sagt und die Regel in einer Zeile `umsetzt:` nennt. Hier steht, ob der Anspruch durch
> den eigenen Code der Datei gedeckt ist. Geprüft wurde Zeile für Zeile.

| Regel | Datei | Deckung | Fundstelle |
|---|---|---|---|
| K03-D01 | `app/haupt.py` | **ganz** | `app/haupt.py:382-403 (Startseite), 232-243, 314-335, 338-379` |
| K03-G01 | `app/haupt.py` | *teilweise* | `app/haupt.py:99-108 und 127-129 (MELDUNG_BETRIEB, Status 503)` |
| K03-G01 | `app/einladung.py` | *teilweise* | `app/einladung.py:140-154, 391-392, 426-430, 437-446 (Kopfvermerk Zeile 2 und 35-49)` |
| K03-M05 | `app/haupt.py` | **nur genannt** | `app/haupt.py:20-21 (nur im erklaerenden Vorspann), Aufruf in Zeile 209` |
| K03-M05 | `app/einladung.py` | *teilweise* | `app/einladung.py:301-373 und 451 (_anmeldecode_senden)` |
| K03-M13 | `app/haupt.py` | **ganz** | `app/haupt.py:353-363 (erneute Pruefung beim Absenden), 406-420 (Abmelden), 7-10` |
| K03-M26 | `app/einladung.py` | *teilweise* | `app/einladung.py:353-373 und 426-430` |
| K13-M05 | `app/haupt.py` | *teilweise* | `app/haupt.py:251-280 (_ohne_einladerecht), Aufrufe in 328 und 358` |
| K20-D10 | `app/einladung.py` | **ganz** | `app/einladung.py:235-244 (Bedingung des UPDATE), Begruendung 210-212` |
| K20-M08 | `app/haupt.py` | *teilweise* | `app/haupt.py:68-96 (Protokollfilter), 171-180 (Kopfzeilen der Antwort)` |
| K20-M08 | `app/einladung.py` | *teilweise* | `app/einladung.py:127-137 (streuwert_token), 235-244 (Suche ueber token_hash), 157-174 (_nachweis ohne Token)` |
| K20-M14 | `app/einladung.py` | **ganz** | `app/einladung.py:235-236 (SET status = 'EINGELOEST', redeemed_at = now())` |
| K20-M15 | `app/einladung.py` | **ganz** | `app/einladung.py:276-283, eingeschlossen in die Transaktion ab Zeile 433` |
| K20-M18 | `app/einladung.py` | **ganz** | `app/einladung.py:157-174 (_nachweis), Aufrufe in 292-296` |
| K20-M25 | `app/haupt.py` | *teilweise* | `app/haupt.py:334-335 (Anzeige von MELDUNG_GESENDET)` |
| K23-D09 | `app/haupt.py` | **ganz** | `app/haupt.py:99-108 (datenbank_weg) und 68-96 (Protokollfilter)` |

## Im Einzelnen

### K03-D01 in `app/haupt.py` — ganz

> Kein Vorgang DARF ohne gültige Sitzung und ohne `status = AKTIV` wirksam werden. WARTET_2FA und GESPERRT führen zur Ablehnung, nie zum Teil-Zugang.

K03-D01 ist die Regel "ohne gueltige Anmeldung und ohne freigeschaltetes Konto passiert nichts". Jede Seite, die eine Anmeldung voraussetzt, fragt bei jedem Aufruf frisch bei der Datenbank nach (sitzung_pruefen) und schickt bei jedem Zweifel ganz zurueck zur Anmeldemaske -- keine halbe Seite, keine Restkachel. Der eigentliche Test auf den Kontozustand AKTIV steht in app/sitzung.py:143; haupt.py zieht daraus die Folge. Ehrlich zu benennen ist eine Spannung: die Einloesung der Einladung (app/haupt.py:206) veraendert Zeilen, ohne dass jemand angemeldet ist -- das ist bauartbedingt so, weil ein Konto genau dadurch erst freigeschaltet wird, und die Datei begruendet es in Zeile 218-225.

*Fundstelle:* `app/haupt.py:382-403 (Startseite), 232-243, 314-335, 338-379`

### K03-G01 in `app/haupt.py` — teilweise

> Es GILT fail-closed: nicht erfüllte oder nicht prüfbare Vorbedingung sperrt; die Sperre wird begründet angezeigt.

Die Regel hat zwei Haelften: sperren, und die Sperre begruendet anzeigen. Gesperrt wird ueberall zuverlaessig. Begruendet angezeigt wird sie aber nur in EINEM Fall -- wenn der Dienst seine Datenbank nicht erreicht, sieht der Nutzer einen erklaerenden Satz. In den beiden anderen Sperrfaellen der Datei bekommt er ausdruecklich KEINEN Grund: bei fehlendem Einladerecht gibt es bewusst gar keine Meldung (Zeile 283-296), beim Rueckwurf auf die Anmeldemaske ebenfalls nicht (Zeile 232-243). Beides ist im Text gut begruendet, aber die Kopfzeile beansprucht die Regel ohne Einschraenkung -- und app/einladung.py:51-54 behauptet zusaetzlich, haupt.py fuehre K03-G01 "ganz". Das trifft so nicht zu.

*Fundstelle:* `app/haupt.py:99-108 und 127-129 (MELDUNG_BETRIEB, Status 503)`

### K03-G01 in `app/einladung.py` — teilweise

> Es GILT fail-closed: nicht erfüllte oder nicht prüfbare Vorbedingung sperrt; die Sperre wird begründet angezeigt.

Hier stimmt der Vermerk. Die erste Haelfte -- im Zweifel sperren -- ist sauber gebaut: leerer Wert, fehlender Mailweg, abgewiesene Datenbankbedingung, jeder Zweifel endet mit Ablehnung und ohne Aenderung. Die zweite Haelfte -- den Grund anzeigen -- fehlt bewusst, weil der Grund selbst eine Auskunft waere, die eine andere Regel (K03-M25) verbietet. Die Datei sagt das in Zeile 2 und ausfuehrlich in Zeile 35-49 und legt die Entscheidung einem Menschen vor, statt sie still zu treffen. Das ist der Musterfall, wie ein halber Anspruch vermerkt gehoert.

*Fundstelle:* `app/einladung.py:140-154, 391-392, 426-430, 437-446 (Kopfvermerk Zeile 2 und 35-49)`

### K03-M05 in `app/haupt.py` — nur genannt

> Der zweite Faktor MUSS ein sechsstelliger Code per E-Mail sein: `mfa_method` = EMAIL_CODE. Ein anderes Verfahren führt das Datenmodell nicht.

K03-M05 sagt: der zweite Nachweis beim Anmelden ist ein sechsstelliger Code per E-Mail. In app/haupt.py steht dazu nur ein Satz im Vorspann ("im selben Vorgang geht der Anmeldecode hinaus"). Kein Programmschritt dieser Datei erzeugt, prueft oder verschickt einen Code; sie ruft nur einloesen() auf, und das Ausstellen geschieht in mail/versand.py:114-118. Auch das im Wortlaut genannte Merkmal mfa_method = EMAIL_CODE kommt in der ganzen Datei nicht vor. Die Kopfzeile beansprucht hier mehr, als die Datei selbst tut.

*Fundstelle:* `app/haupt.py:20-21 (nur im erklaerenden Vorspann), Aufruf in Zeile 209`

### K03-M05 in `app/einladung.py` — teilweise

> Der zweite Faktor MUSS ein sechsstelliger Code per E-Mail sein: `mfa_method` = EMAIL_CODE. Ein anderes Verfahren führt das Datenmodell nicht.

Diese Datei loest den Versand des Codes tatsaechlich aus, und zwar an genau der richtigen Stelle -- nach dem Festschreiben der Einloesung. Dass der Code sechsstellig ist und per E-Mail geht, entscheidet aber mail/versand.py, nicht diese Datei. Und das im Wortlaut ausdruecklich genannte Merkmal mfa_method = EMAIL_CODE wird nirgends gesetzt oder geprueft -- es haengt allein am Vorgabewert der Datenbanktabelle (schema/freiraum_datamodel.sql:154). Der Anspruch ist also zur Haelfte gedeckt, ohne dass die Kopfzeile das vermerkt.

*Fundstelle:* `app/einladung.py:301-373 und 451 (_anmeldecode_senden)`

### K03-M13 in `app/haupt.py` — ganz

> Jede Prüfung der Anmeldung MUSS serverseitig erfolgen (K13 Abschn. 3); eine Prüfung allein in der Oberfläche gilt als nicht erfolgt.

K03-M13 verlangt, dass jede Pruefung auf dem Server passiert und nicht im Browser. Die Datei loest das konsequent: es gibt gar kein getrenntes Programm im Browser, jede Entscheidung faellt beim Aufruf gegen die Datenbank, das Formular wird nicht geglaubt, sondern beim Absenden noch einmal geprueft, und das Abmelden beendet die Sitzung serverseitig statt nur das Cookie zu loeschen. Hier deckt der Code den Anspruch vollstaendig.

*Fundstelle:* `app/haupt.py:353-363 (erneute Pruefung beim Absenden), 406-420 (Abmelden), 7-10`

### K03-M26 in `app/einladung.py` — teilweise

> Der Versand nutzt verwaltete Identität oder Secret-Referenz, eine erlaubte Ausgangsverbindung und datensparsame Telemetrie. Codes und vollständige E-Mail-Adressen stehen nie in Logs. Providerfehler, fehlender Nachweis oder unklare Konfiguration wirken fail-closed und alarmieren den Betrieb mit Runbook-Verweis.

Der Wortlaut nennt vier Anforderungen. Zwei sind hier erfuellt: in den Protokollzeilen stehen weder Code noch vollstaendige E-Mail-Adresse, und ein Fehler beim Versand sperrt statt durchzuwinken. Zwei sind es nicht: von "verwalteter Identitaet oder Secret-Referenz" und einer "erlaubten Ausgangsverbindung" steht in dieser Datei nichts (die Zugangswerte kommen als schlichte Umgebungswerte in mail/versand.py:69-79), und die geforderte Alarmierung des Betriebs "mit Runbook-Verweis" gibt es nicht -- die beiden Protokollzeilen nennen kein Runbook und alarmieren niemanden. Dieser halbe Anspruch ist in der Kopfzeile NICHT vermerkt.

*Fundstelle:* `app/einladung.py:353-373 und 426-430`

### K13-M05 in `app/haupt.py` — teilweise

> Jeder Aufruf aus einer Oberfläche MUSS über den Serverpfad laufen. Der Serverpfad prüft aktives Konto, Mitgliedschaft, Rolle, Mandant und Objektbezug, bevor er liest oder schreibt.

Der Wortlaut zaehlt fuenf Dinge auf, die der Server pruefen muss. Drei sind belegbar da: aktives Konto und Mandant kommen aus app/sitzung.py, die Mitgliedschaft ebenfalls (app/sitzung.py:81-88 verlangt genau ein freigeschaltetes Portal), und der Einladeweg ist doppelt abgesichert -- beim Anzeigen des Formulars und noch einmal beim Absenden. Zwei sind es nicht: eine eigene ROLLE wird nirgends gelesen; die Datei argumentiert in Zeile 268-272, die Mitgliedschaft SEI die Rolle -- das ist eine Auslegung, kein Programmschritt. Und ein OBJEKTBEZUG wird gar nicht geprueft, weil es auf diesen Seiten noch kein Objekt gibt. Der Anspruch ist damit nur zum Teil gedeckt.

*Fundstelle:* `app/haupt.py:251-280 (_ohne_einladerecht), Aufrufe in 328 und 358`

### K20-D10 in `app/einladung.py` — ganz

> Eine abgelaufene, eingelöste oder widerrufene Einladung DARF NICHT erneut wirken. Ein verfallener Link führt zu einem neuen Vorgang, nie zu einer Verlängerung.

Die Regel sagt: ein verbrauchter oder verfallener Einladungslink darf nicht noch einmal wirken, und er darf auch nicht heimlich verlaengert werden. Beides ist hier tatsaechlich gebaut. Die Schreibanweisung trifft nur Einladungen, die noch den Zustand VERSANDT haben und deren Frist noch laeuft -- eingeloeste, widerrufene und abgelaufene fallen ohne eigenen Zweig heraus. Und das Entscheidende steht in dem, was FEHLT: Frist und Versuchszaehler werden nicht angefasst, also kann sich nichts verlaengern.

*Fundstelle:* `app/einladung.py:235-244 (Bedingung des UPDATE), Begruendung 210-212`

### K20-M08 in `app/haupt.py` — teilweise

> Gespeichert MUSS allein der Streuwert des Links werden. Wer den Datenbestand liest, darf keine fremde Einladung einlösen können.

Der Wortlaut handelt davon, was in der DATENBANK gespeichert wird -- naemlich nur ein Pruefwert des Links, nie der Link selbst. Genau das entscheidet app/haupt.py nirgends; gespeichert wird in app/einladung_senden.py:663, gelesen in app/einladung.py. Was haupt.py tut, ist verwandt, aber etwas anderes: es haelt den Link aus dem Zugriffsprotokoll und aus Zwischenspeichern heraus. Zwei Einschraenkungen sind zu nennen: der Protokollfilter greift nur bei Adressen, die genau mit "/einladung?" beginnen, und er haengt an der Ausgabe des Servers uvicorn -- laeuft die Anwendung spaeter unter einem anderen Server, greift er ins Leere, und der Link stuende wieder im Protokoll (die Datei sagt das in Zeile 82-84 selbst).

*Fundstelle:* `app/haupt.py:68-96 (Protokollfilter), 171-180 (Kopfzeilen der Antwort)`

### K20-M08 in `app/einladung.py` — teilweise

> Gespeichert MUSS allein der Streuwert des Links werden. Wer den Datenbestand liest, darf keine fremde Einladung einlösen können.

Die zweite Haelfte der Regel ist hier erfuellt: eingeloest wird ausschliesslich, indem der vorgelegte Link zu einem Pruefwert verrechnet und damit gesucht wird. Wer die Tabelle lesen darf, haelt nur Pruefwerte in der Hand und kann daraus keinen Link zurueckrechnen. Auch der Nachweiseintrag enthaelt weder Link noch Pruefwert. Die erste Haelfte -- dass ueberhaupt nur der Pruefwert GESPEICHERT wird -- entscheidet diese Datei nicht; das passiert beim Ausstellen in app/einladung_senden.py:663. Der Anspruch ist also nur von der Lese-Seite her gedeckt.

*Fundstelle:* `app/einladung.py:127-137 (streuwert_token), 235-244 (Suche ueber token_hash), 157-174 (_nachweis ohne Token)`

### K20-M14 in `app/einladung.py` — ganz

> Die Einlösung MUSS Zustand und Zeitpunkt gemeinsam setzen: EINGELOEST nur mit `redeemed_at`, `redeemed_at` nur mit EINGELOEST (`invitation_einloesung`); belegt durch T11.

Die Regel verlangt, dass Zustand und Zeitpunkt der Einloesung immer zusammen gesetzt werden -- nie das eine ohne das andere. Der Code setzt beides in EINER einzigen Anweisung, es kann also gar nicht auseinanderfallen. Zusaetzlich haelt die Datenbank dieselbe Bedingung noch einmal fest (schema/freiraum_datamodel.sql:211, genau die im Wortlaut genannte Bedingung invitation_einloesung). Voll gedeckt.

*Fundstelle:* `app/einladung.py:235-236 (SET status = 'EINGELOEST', redeemed_at = now())`

### K20-M15 in `app/einladung.py` — ganz

> Nach der Einlösung MUSS das Konto von WARTET_2FA auf AKTIV wechseln. Der Kontozustand gehört K03; belegt durch T12.

Gefordert ist, dass das Konto durch die Einloesung von "wartet auf zweiten Faktor" auf "aktiv" wechselt. Genau das tut die zweite Schreibanweisung, und sie laeuft im selben unteilbaren Vorgang wie die Einloesung: entweder beides oder nichts. Eine bewusste Zusatzentscheidung ist sauber begruendet -- ein GESPERRTES Konto wird auf diesem Weg nicht wieder freigeschaltet (Zeile 253-262), sonst waere eine Einladung ein Weg an der Sperre vorbei.

*Fundstelle:* `app/einladung.py:276-283, eingeschlossen in die Transaktion ab Zeile 433`

### K20-M18 in `app/einladung.py` — ganz

> Jede Änderung an Zugang, Rolle, Mitgliedschaft oder Einladung MUSS mit Zeitpunkt, handelnder Instanz sowie Wert davor und danach im internen Nachweis stehen (EXMA-Handbuch 5.6).

Verlangt ist eine luckenlose Spur: wann, wer, was vorher, was nachher. Beide Aenderungen dieses Wegs -- die Einloesung und die Freischaltung des Kontos -- schreiben je eine solche Zeile, mit Zeitpunkt, handelnder Person und dem Wert davor und danach. Bemerkenswert sauber: der Wert davor wird tatsaechlich aus der Datenbank GELESEN und nicht angenommen, obwohl er rechnerisch feststeht (Begruendung in Zeile 216-218). Voll gedeckt.

*Fundstelle:* `app/einladung.py:157-174 (_nachweis), Aufrufe in 292-296`

### K20-M25 in `app/haupt.py` — teilweise

> Wiederversand zeigt: *Der vorherige Link ist ungültig.* Der Nachweis einer Zugangsänderung trägt `retention_class = BETRIEBSPROTOKOLL`; personenbezogene Anzeige wird nach K15 minimiert.

Der Wortlaut fordert zwei getrennte Dinge. Das erste -- der Satz "Der vorherige Link ist ungueltig" -- wird angezeigt, allerdings stammt der Satz aus app/einladung_senden.py:150 und erscheint nach JEDEM erfolgreichen Versand, nicht nur beim Wiederversand; beim allerersten Versand ist er gegenstandslos. Das ist dort in Zeile 143-149 als offener Punkt vermerkt. Das zweite -- dass der Nachweis die Aufbewahrungsart BETRIEBSPROTOKOLL traegt -- ist ausdruecklich NICHT gebaut (app/einladung_senden.py:291-298 nennt einen Widerspruch zwischen zwei Quellen). In app/haupt.py selbst steht dazu nichts. Die Kopfzeile beansprucht die Regel trotzdem ohne jede Einschraenkung.

*Fundstelle:* `app/haupt.py:334-335 (Anzeige von MELDUNG_GESENDET)`

### K23-D09 in `app/haupt.py` — ganz

> Geheimnisse, Zugangswerte oder unmaskierte personenbezogene Angaben DÜRFEN NICHT in Manifest, Log, Screenshot oder Fehlerausgabe gelangen. Ein solcher Fund sperrt den Lauf.

Die Regel verbietet, dass Geheimnisse oder Personenangaben in Protokolle oder Fehlerausgaben geraten. Fuer das, was diese Datei selbst ausgibt, ist das erfuellt: bei einem Datenbankausfall wird die Originalmeldung -- die Rechnernamen und Anschluesse nennt -- unterdrueckt und durch einen neutralen Satz ersetzt, und der Einladungslink wird aus dem Zugriffsprotokoll gekuerzt. Eine Einschraenkung zur Ehrlichkeit: das Kuerzen im Protokoll wirkt nur, solange die Anwendung unter dem Server uvicorn laeuft -- unter einem anderen Server bleibt die Zeile ungekuerzt stehen. Die Datei benennt das selbst.

*Fundstelle:* `app/haupt.py:99-108 (datenbank_weg) und 68-96 (Protokollfilter)`

---

## Ansprüche, die keine Kopfzeile einschränkt

Diese Lücken sind **nicht** im Dateikopf vermerkt. Wer nur die Kopfzeile liest, hält die
Regel für gebaut.

- app/haupt.py, K20-M25: Von den beiden Anforderungen der Regel ist nur die Anzeige gebaut. Die geforderte Aufbewahrungsart BETRIEBSPROTUKOLL fuer den Nachweis wird ausdruecklich nicht gesetzt (begruendet in app/einladung_senden.py:291-298). Die Kopfzeile von haupt.py beansprucht die Regel ohne Einschraenkung. Das ist der deutlichste nicht vermerkte Fall -- deutlicher als der vermerkte in einladung.py.

- app/haupt.py, K03-G01: Die Kopfzeile beansprucht die Regel ganz, gebaut ist die begruendete Anzeige aber nur fuer einen einzigen Fall (Datenbank nicht erreichbar). In zwei anderen Sperrfaellen wird der Grund bewusst verschwiegen (Zeile 283-296 und 232-243). Verschaerfend: app/einladung.py:51-54 behauptet ausdruecklich, haupt.py fuehre K03-G01 "ganz" -- diese Aussage ist so nicht haltbar und traegt die Luecke in eine zweite Datei weiter.

- app/haupt.py, K03-M05: Die Kopfzeile beansprucht die Regel, in der Datei steht dazu aber nur ein Satz im erklaerenden Vorspann (Zeile 20-21). Kein Programmschritt der Datei erzeugt, prueft oder versendet einen Anmeldecode. Das ist der einzige Fall unter den dreizehn, in dem die Kopfzeile eine Regel nennt, ohne dass im Code der Datei etwas dazu steht.

- app/einladung.py, K03-M05: Der Versand wird ausgeloest, aber weder die Sechsstelligkeit noch der Weg per E-Mail noch das im Wortlaut genannte Merkmal mfa_method = EMAIL_CODE werden hier festgelegt oder geprueft. Nicht als halb vermerkt.

- app/einladung.py, K03-M26: Zwei von vier Anforderungen des Wortlauts sind gebaut (keine Adressen und Codes im Protokoll, fail-closed). Nicht gebaut sind verwaltete Identitaet oder Secret-Referenz, die erlaubte Ausgangsverbindung und vor allem die geforderte Alarmierung des Betriebs mit Runbook-Verweis. Nicht als halb vermerkt -- und das in derselben Kopfzeile, die den halben Stand von K03-G01 korrekt ausweist.

- app/haupt.py, K13-M05: Von den fuenf im Wortlaut aufgezaehlten Pruefungen sind drei gebaut. Die Rolle wird nirgends gelesen, sondern per Auslegung mit der Mitgliedschaft gleichgesetzt (Zeile 268-272); ein Objektbezug wird gar nicht geprueft. Nicht als halb vermerkt.

- app/haupt.py und app/einladung.py, K20-M08: Beide beanspruchen die Regel, beide decken nur eine Seite ab. Der eigentliche Kern -- dass allein der Pruefwert gespeichert wird -- geschieht in app/einladung_senden.py:663, und diese Datei traegt ueberhaupt keine Kopfzeile "# umsetzt:". Die am besten belegte Umsetzung der Regel wird also von keiner Datei beansprucht, waehrend zwei Dateien sie beanspruchen, die sie nur zur Haelfte tragen.

- app/haupt.py, K23-D09 und K20-M08 (technischer Vorbehalt): Das Kuerzen des Einladungslinks im Zugriffsprotokoll haengt am Server uvicorn und am genauen Adressanfang "/einladung?". Laeuft die Anwendung spaeter unter einem anderen Server, greift der Filter ins Leere und der Link steht wieder im Klartext im Protokoll. Die Datei benennt das selbst (Zeile 82-84), die Kopfzeile nicht.

- Randbeobachtung, keine der dreizehn: app/haupt.py:137 beruft sich fuer eine Browser-Zwischenspeicher-Einstellung auf K03-M26. Der Wortlaut von K03-M26 handelt ausschliesslich vom E-Mail-Versand und sagt zu Zwischenspeichern im Browser nichts. Die Kopfzeile von haupt.py beansprucht K03-M26 nicht -- die Berufung im Text bleibt trotzdem eine Fehlzuordnung, die beim Lesen leicht als Beleg durchgeht.

---

## Gesamteindruck

Von den sechzehn Anspruechen (dreizehn Regelkennungen, drei davon von beiden Dateien beansprucht) halten sechs vollstaendig, neun nur zum Teil, einer gar nicht.

Vollstaendig gedeckt ist der Kern des Einloesewegs in app/einladung.py: K20-D10, K20-M14, K20-M15 und K20-M18 sind dort nicht nur behauptet, sondern nachvollziehbar gebaut -- teilweise sogar strenger als noetig. In app/haupt.py halten K03-D01 (kein Teil-Zugang) und K03-M13 (jede Pruefung auf dem Server); K23-D09 haelt fuer alles, was die Datei selbst ausgibt.

Das Muster der Luecken ist ueber alle neun Teilfaelle dasselbe und leicht zu merken: Eine Regel nennt zwei oder mehr Anforderungen, gebaut ist eine davon. Bei K03-G01 ist das Sperren gebaut, das Begruenden nicht. Bei K20-M25 ist der Satz auf dem Bildschirm gebaut, die Aufbewahrungsart nicht. Bei K03-M26 sind zwei von vier Anforderungen gebaut. Bei K13-M05 sind drei von fuenf Pruefungen gebaut. Bei K20-M08 ist die Lese-Seite gebaut, die Speicher-Seite liegt in einer dritten Datei. Bei K03-M05 verweist alles auf mail/versand.py, und das im Wortlaut ausdruecklich genannte Merkmal mfa_method = EMAIL_CODE kommt in keiner der beiden Dateien vor.

Auffaellig ist nicht die Qualitaet des Codes -- die ist durchweg hoch und aussergewoehnlich gut begruendet -- sondern die Genauigkeit der Kopfzeilen. Genau EIN halber Anspruch ist vermerkt (K03-G01 in app/einladung.py, Zeile 2, und dort vorbildlich ausfuehrlich). Acht weitere sind es nicht. Die Kopfzeile "# umsetzt: ..." wird vom Werkzeug werkzeuge/herkunft.py als ausdrueckliche Erklaerung gewertet ("erklaert" statt nur "erwaehnt") -- wer die erzeugte Nachweissicht liest, ohne den Code danebenzulegen, bekommt also fuer diese acht ein zu gutes Bild. Fuer die Frage, was ein Mensch von Hand zuordnen muss, heisst das: die Kopfzeilen sind ein brauchbarer Wegweiser, aber kein Beleg.

