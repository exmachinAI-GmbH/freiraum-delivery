# Tor 3 · Probelauf der Fremdprüfung — 14.08.2026

> **Dies ist KEIN Tor-3-Nachweis.** Es ist ein Probelauf. Der Unterschied ist wichtig und
> steht unten unter *Warum dies kein Nachweis ist*.

## Warum dieser Lauf stattgefunden hat

Die Fremdprüfung war an vier Stellen verbindlich beschrieben und **gegen den gebauten Stand
noch nie durchlaufen**. Damit war unbekannt, wie viele Tage ein Durchlauf kostet. Wer das
kurz vor dem Endtermin zum ersten Mal versucht, findet es zu spät heraus.

**Der Zweck war die Zeitmessung, nicht die Abnahme.**

## Die gemessene Zykluszeit

| | |
|---|---|
| Anforderung abgeschickt | **14.08.2026, 17:26:39 UTC** |
| Urteil vollständig zurück | **14.08.2026, 17:32:51 UTC** |
| **Dauer** | **6 Minuten** |

**Tor 3 ist damit kein Terminrisiko.** Die Annahme, der Zyklus koste Tage, ist widerlegt.
Was Zeit kostet, ist das Zusammenstellen der Rohbelege und — nach einem echten Lauf — das
Ausfüllen und Zeichnen des Kopfes durch einen Menschen.

## Die Umstände des Laufs

| Feld | Wert |
|---|---|
| geprüfter Commit | `40e8ec6d97402f9e5816b21cf828a9bd3f18ec22` (Zweig `main`) |
| prüfendes Modell | OpenAI Codex auf GPT-5 |
| Fassung laut Selbstauskunft | API-Fassung vom 14.08.2026; feinere Build-Kennung nicht offengelegt |
| frische Sitzung | ja |
| getrennter Zusammenhang | ja — eigener Prozess, kein Zugriff auf dieses Gespräch |
| gegen Roh-Evidenz | ja — Quelltext, Migrationen, Negativfälle, Prüffälle, Protokolle |
| ausdrücklich **nicht** vorgelegt | Übergabetexte, Bauberichte, Antragsbeschreibungen, `README.md`, `CLAUDE.md`, `CONTRIBUTING.md` |
| Zugriff | nur lesend |
| **angefordert von** | **dem Harness (Orchestrator)** — nicht von einem Menschen |

## Warum dies kein Nachweis ist

`nachweise/fremdreview/README.md` sagt wörtlich:

> *„Ein Fremdmodell, das der Harness selbst aufruft, dessen Ausgabe er selbst ablegt und
> dessen Ergebnis er selbst auswertet, ist kein fremder Blick mehr — es ist derselbe Blick
> mit einem anderen Etikett."*

Diesen Lauf hat der Harness angefordert. Vier der zwölf Pflichtangaben eines Nachweises sind
Bestätigungen, die nur ein Mensch geben kann; die Unterschrift ebenfalls. Ein von einem
Agenten ausgefüllter Kopf wäre keine Abkürzung, sondern eine Fälschung.

**Deshalb liegt dieses Blatt unter `arbeit/`** — dem Ordner, in dem ausdrücklich nichts ein
Nachweis ist — und nicht unter `nachweise/fremdreview/`. `pruefungen/tor3.sh` meldet
weiterhin **GESPERRT**, und das ist richtig.

**Was daraus einen Nachweis machen würde:** Ein Mensch fordert den Lauf an, legt das Urteil
unter `nachweise/fremdreview/` ab und zeichnet den Kopf. Das Blatt dafür liegt bereit unter
`arbeit/Vorlagen/tor3_anforderung_scheibe1.md`. Nach dieser Messung kostet der Lauf selbst
sechs Minuten.

---

# Das Urteil — unverändert übernommen

*Nicht zusammengefasst, nicht geglättet, nicht gekürzt.*

## 1. Ist die Anmeldung serverseitig durchgesetzt?

- Für die geschützten Routen ist kein Weg an der Anmeldung vorbei erkennbar. Sowohl die Startseite als auch beide Versandrouten lesen das signierte Sitzungsmerkmal und prüfen die zugehörige Sitzung erneut in PostgreSQL (`app/haupt.py:254`, `app/haupt.py:280`, `app/haupt.py:303`).

- Das Cookie enthält nur die signierte Sitzungskennung; Kontodaten oder Berechtigungen werden nicht aus dem Browser übernommen (`app/sitzung.py:28`, `app/sitzung.py:35`). Ungültige Signaturen führen zu `None` und damit zurück zur Anmeldung (`app/sitzung.py:39`, `app/haupt.py:221`).

- Die Sitzungsprüfung kontrolliert serverseitig Sitzungsende, 30 Minuten Untätigkeit, acht Stunden Gesamtdauer, den Kontozustand `AKTIV` und genau ein freigeschaltetes Portal (`app/sitzung.py:109`, `app/sitzung.py:122`, `app/sitzung.py:143`, `app/sitzung.py:147`). Erst danach wird die letzte Aktivität fortgeschrieben (`app/sitzung.py:154`).

- Eine Sitzung entsteht erst nach atomarem Verbrauch eines gültigen, nicht abgelaufenen Codes, erfolgreicher Portalbestimmung und Einfügen einer neuen Sitzungszeile (`app/anmeldung.py:157`, `app/anmeldung.py:178`, `app/anmeldung.py:188`, `app/anmeldung.py:199`). Der Cookie wird nur bei zurückgegebener Sitzungskennung gesetzt (`app/haupt.py:151`, `app/haupt.py:154`, `app/haupt.py:159`).

- Die Einladung aktiviert zwar das Konto, stellt aber keine Sitzung aus; sie leitet anschließend zur Anmeldung weiter (`app/einladung.py:193`, `app/einladung.py:216`, `app/haupt.py:212`). Das ist kein Anmelde-Bypass.

- Die öffentlich erreichbaren Routen `/anmeldung`, `/einladung` und `/gesundheit` geben keinen geschützten Anwendungsinhalt aus (`app/haupt.py:136`, `app/haupt.py:177`, `app/haupt.py:344`).

- Eine andere Berechtigungslücke besteht dennoch: Jede aktive Person mit genau einem freigeschalteten Portal darf Einladungen senden. Weder die Route noch `portal_bestimmen()` prüfen eine Verwaltungsrolle (`app/haupt.py:265`, `app/haupt.py:280`, `app/sitzung.py:71`). Die Anmeldung selbst wird damit nicht umgangen; die fachliche Berechtigung zum Einladen aber schon.

## 2. Kann ein Mandant Daten eines anderen sehen?

- Ja, mindestens die Existenz eines Kontos zu einer eingegebenen E-Mail-Adresse wird mandantenübergreifend offengelegt. `_konto_sichern()` sucht ohne Mandantenbedingung global nach `lower(email)` und unterscheidet danach ausdrücklich zwischen eigenem und fremdem Mandanten (`app/einladung_senden.py:336`, `app/einladung_senden.py:344`). Bei einem fremden Treffer erscheint die besondere Meldung „Konto bei einem anderen Mandanten" (`app/einladung_senden.py:157`, `app/einladung_senden.py:346`, `app/einladung_senden.py:714`). Praktisch bedeutet das: Eine angemeldete Person kann E-Mail-Adressen durchprobieren und erfährt, welche davon bei einem anderen Mandanten registriert sind.

- Diese Auskunft ist nicht auf Verwaltungsrollen begrenzt. Für den Versand genügt eine aktive Sitzung mit genau einem Portal (`app/haupt.py:280`, `app/sitzung.py:143`, `app/sitzung.py:147`). Dadurch kann jede entsprechend angelegte Mitgliedschaft dieses mandantenübergreifende E-Mail-Orakel benutzen.

- Die Anwendung verhindert immerhin, dass das gefundene fremde Konto tatsächlich eingeladen oder verändert wird: Vor Rückgabe der Kontokennung wird `actor.tenant_id` mit dem Mandanten aus der Sitzung verglichen (`app/einladung_senden.py:344`). Neue Konten werden mit dem Mandanten der Sitzung angelegt (`app/einladung_senden.py:354`).

- Die Anmeldung sucht ebenfalls global und schreibweisenunabhängig nach der E-Mail-Adresse. Bei null oder mehreren Treffern scheitert sie geschlossen, statt einen beliebigen Datensatz auszuwählen (`app/anmeldung.py:128`, `app/anmeldung.py:142`, `app/anmeldung.py:166`).

- Die Portalbestimmung berücksichtigt nur `actor_id` und `portal_code`. Sie prüft weder `membership.tenant_scope` gegen `actor.tenant_id` noch die Rolle (`app/sitzung.py:81`). Ob das nicht gelieferte Basisschema eine mandantenfremde Mitgliedschaft durch einen Fremdschlüssel oder eine andere Bedingung verhindert, kann ich nicht beurteilen. Das Manifest nennt das Basisschema nur samt Prüfsumme, liefert dessen Inhalt aber nicht als erlaubten Beleg (`nachweise/manifeste/tor1c_260813_manifest.json:27`).

- Auf Datenbankebene besteht kein allgemeiner Zeilenschutz: Die Migration bezeichnet das vollständige RLS-Regime ausdrücklich als offen (`migrations/M30__pilot_sammelmigration.sql:1713`). `fr_portal` erhält stattdessen `SELECT`, `INSERT` und `UPDATE` auf alle Tabellen; nur einzelne Schreibrechte werden später wieder entzogen (`migrations/M30__pilot_sammelmigration.sql:2357`, `migrations/M30__pilot_sammelmigration.sql:2364`, `migrations/M30__pilot_sammelmigration.sql:2383`). Der vorhandene Sitzungsmandant schützt nur bestimmte Freigabevorgänge und ist im Pilot standardmäßig nicht durchgesetzt (`migrations/M30__pilot_sammelmigration.sql:2161`, `migrations/M30__pilot_sammelmigration.sql:2201`).

## 3. Scheitern die vier Negativfälle an ihrer eigenen Bedingung?

- Der Auswerter verlangt einen Fehlschlag und sucht anschließend lediglich die erwartete Zeichenfolge irgendwo in der gesamten `psql`-Ausgabe (`pruefungen/lauf.sh:129`, `pruefungen/lauf.sh:135`, `pruefungen/lauf.sh:145`). Das ist besser als „irgendein Fehler", beweist aber nicht, dass die Zeichenfolge tatsächlich als PostgreSQL-Bedingungsname gemeldet wurde.

- N2 ist strukturell eindeutig: Der Fall fügt einen Zustellfehler mit `provider_note = NULL` ein (`migrations/negativfaelle/N2_mail_fehler_braucht_grund.sql:7`). M30 definiert genau dafür `mail_fehler_braucht_grund`; der Append-only-Auslöser betrifft nur `UPDATE` und `DELETE`, nicht dieses `INSERT` (`migrations/M30__pilot_sammelmigration.sql:287`, `migrations/M30__pilot_sammelmigration.sql:301`, `migrations/M30__pilot_sammelmigration.sql:315`).

- N4 ist ebenfalls eindeutig: M30 stellt `KURZFRIST` zuvor auf 30 Tage und `regelfrist_monate = NULL` um (`migrations/M30__pilot_sammelmigration.sql:1548`). Der Negativfall ändert allein die Tagesfrist auf null (`migrations/negativfaelle/N4_tagesfrist_positiv.sql:7`), was unmittelbar `tagesfrist_positiv` verletzt (`migrations/M30__pilot_sammelmigration.sql:117`).

- N1 und N3 arbeiten auf `HANDELSRECHT` (`migrations/negativfaelle/N1_frist_ge_mindestfrist.sql:7`, `migrations/negativfaelle/N3_pseudonym_vor_frist.sql:20`). Die Definitionen von `frist_ge_mindestfrist` und `pseudonym_vor_frist` stehen nicht in M30, sondern müssen aus dem nicht freigegebenen Basisschema stammen. Ob diese beiden Anweisungen ausschließlich jene Bedingungen verletzen, kann ich daher aus den erlaubten Dateien nicht selbst herleiten.

- Das Ergebnisprotokoll nennt für alle vier Fälle jeweils den erwarteten Namen (`nachweise/manifeste/tor1c_260813.json:9`). Die tatsächliche `psql`-Fehlerausgabe wurde jedoch nicht mitgeliefert. Deshalb ist für N1 und N3 nur belegt, dass der Auswerter die Zeichenfolge fand, nicht wo und in welchem vollständigen Fehlertext sie stand (`pruefungen/lauf.sh:145`, `nachweise/manifeste/tor1c_260813.json:9`).

## 4. Misst ein Prüffall etwas anderes als der Code?

- Der als „ganzer Faden" bezeichnete Fall stellt den Anmeldecode selbst per direktem SQL-`INSERT` her (`pruefungen/klauseln/mitgliedschaft_lauf.sh:648`, `pruefungen/klauseln/mitgliedschaft_lauf.sh:702`, `pruefungen/klauseln/mitgliedschaft_lauf.sh:707`). Die Anwendung besitzt aber nur eine Route zum Einreichen eines schon vorhandenen Codes (`app/haupt.py:141`). Das Ausstellen und Versenden eines Codes existiert lediglich als Funktion beziehungsweise Kommandozeilenweg in `mail/versand.py` (`mail/versand.py:232`, `mail/versand.py:320`). Der Prüffall belegt deshalb nicht den durchgehenden Nutzerweg „Einladung → Einmalcode erhalten → anmelden", sondern einen Weg mit einem administrativen Datenbankeingriff in der Mitte.

- Die fachliche Einladeberechtigung wird nicht geprüft. Die Versanddaten legen ausschließlich ein einladendes Plattform-Admin-Konto an (`pruefungen/klauseln/versand_daten.sql:143`, `pruefungen/klauseln/versand_daten.sql:157`). Ein Gegenfall „aktive normale Person versucht einzuladen" fehlt, obwohl der Code keine Rollenprüfung enthält (`app/haupt.py:280`, `app/sitzung.py:81`).

- Ein mandantenfremdes bestehendes Konto wird ebenfalls nicht geprüft. Der Versandaufbau enthält nur einen Betreiber-Mandanten; `niemand@fremde-domaene.example` prüft eine fremde E-Mail-Domäne, nicht ein Konto eines anderen Mandanten (`pruefungen/klauseln/versand_daten.sql:74`, `pruefungen/klauseln/versand_daten.sql:130`). Damit bleibt das tatsächlich vorhandene mandantenübergreifende E-Mail-Orakel ungemessen (`app/einladung_senden.py:336`, `app/einladung_senden.py:346`).

- Der Ablauf einer Einladung ist ausdrücklich nicht umgesetzt: Der Einlösepfad lässt eine abgelaufene Einladung auf `VERSANDT` stehen (`app/einladung.py:157`, `app/einladung.py:163`), und der Versandcode erklärt selbst, dass ohne späteren Neuversand niemand die Mitgliedschaft aufräumt (`app/einladung_senden.py:527`). MG-08 erkennt das und wird deshalb gesperrt statt bestanden (`pruefungen/klauseln/mitgliedschaft_lauf.sh:610`, `pruefungen/klauseln/mitgliedschaft_lauf.sh:638`). Der Stand erfüllt somit den eigenen Vertragssatz „beim Ablauf verschwindet sie wieder" nicht.

- Nach einem Mailfehler behauptet die sichtbare Meldung, die Einladung sei widerrufen (`app/einladung_senden.py:176`). Der Widerruf kann jedoch am Einladungswächter scheitern; dann bleiben Einladung und Mitgliedschaft bestehen (`app/einladung_senden.py:638`, `app/einladung_senden.py:660`). Die Versandprüfung verwendet nur einen erfolgreichen SMTP-Fänger und enthält keinen Zustellfehlerfall (`pruefungen/lauf.sh:242`, `pruefungen/lauf.sh:252`, `pruefungen/klauseln/versand_lauf.sh:218`).

- Die Laufzeitprüfungen verwenden nur fünf Stichproben und akzeptieren bis zu 250 Millisekunden Medianunterschied (`pruefungen/klauseln/einloesung_lauf.sh:486`, `pruefungen/klauseln/einloesung_lauf.sh:491`, `pruefungen/klauseln/einloesung_lauf.sh:501`). Damit erkennen sie grobe Verzögerungen, belegen aber keine allgemeine zeitliche Ununterscheidbarkeit.

## 5. Wo behauptet ein Protokoll mehr als die Belege hergeben?

- Das Manifest bindet den Lauf an Commit `03754a469d42684bbb716e16124d4b950ce5e7e5` auf Zweig `ah7-manifest`, nicht an den zu prüfenden Commit `40e8ec6d97402f9e5816b21cf828a9bd3f18ec22` auf `main` (`nachweise/manifeste/tor1c_260813_manifest.json:5`). Die aufgelisteten Einzelprüfsummen binden zwar zahlreiche Dateien, aber das Protokoll beweist keinen ausgeführten Lauf auf dem hier verlangten Commit.

- Das Ergebnis meldet insgesamt null Fehlschläge, führt bei `mitgliedschaft` aber „8 von 9 bestanden, 1 gescheitert" als Anmerkung (`nachweise/manifeste/tor1c_260813.json:4`, `nachweise/manifeste/tor1c_260813.json:9`). Der Zustand lautet zwar korrekt `gesperrt`; die Anmerkung übernimmt jedoch die interne Zählweise, bei der `sperr()` zunächst auch `gescheitert` erhöht (`pruefungen/klauseln/mitgliedschaft_lauf.sh:83`). Ohne Kenntnis des Auswerters klingt das widersprüchlich.

- Das Manifest behauptet, seine eigene Prüfsumme stehe in einer Nebendatei (`nachweise/manifeste/tor1c_260813_manifest.json:2`, `nachweise/manifeste/tor1c_260813_manifest.json:120`). Diese Nebendatei gehört nicht zu den vorgelegten Rohbelegen. Die Unverändertheit des Manifests kann daher nicht nachgerechnet werden.

- Die Zusammenfassung behauptet „110 von 110", „30 von 30", „18 von 18" und „8 von 8" bestanden, liefert aber keine einzelnen Laufmeldungen oder vollständigen Fehlerausgaben (`nachweise/manifeste/tor1c_260813.json:9`). Die Prüfprogramme können diese Summen erzeugen (`pruefungen/migration/M30__pruefung.sql:1577`, `pruefungen/migration/M30__pruefung.sql:1581`); dass genau diese Programme im protokollierten Lauf genau diese Rohresultate erzeugten, ist ohne Laufprotokoll nicht unabhängig überprüfbar.

- Der Kopf des Gesamtlaufs behauptet noch, die Anwendung existiere nicht und Klauselprüfungen seien nicht vorhanden (`pruefungen/lauf.sh:7`, `pruefungen/lauf.sh:11`). Derselbe Lauf startet später tatsächlich die Anwendung und führt vorhandene Klauselprüfungen aus (`pruefungen/lauf.sh:343`, `pruefungen/lauf.sh:407`). Diese Protokollbeschreibung ist veraltet.

Modellbezeichnung und Fassung: OpenAI Codex auf GPT-5, API-Fassung vom 14.08.2026; eine feinere interne Build-Kennung ist mir nicht offengelegt.

## URTEIL

trägt nicht
