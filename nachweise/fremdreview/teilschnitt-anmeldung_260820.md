# Tor 3 · Fremdreview — `teilschnitt-anmeldung`

**Abgelegt am 20.08.2026.** Das Urteil steht unverändert, wie es das Fremdmodell abgegeben
hat. Der Harness hat es nicht geschrieben und den Kopf nicht ausgefüllt.

**Der Kopf wird von einem Menschen ausgefüllt und gezeichnet.** Der Harness schreibt dieses
Blatt nie selbst (`.claude/commands/scheibe.md`:73). Ein von einem Agenten ausgefüllter Kopf
ist kein Nachweis, sondern seine Fälschung.

---

<!-- KOPF · maschinell gelesen, Feldnamen nicht ändern -->

| Feld | Wert |
|---|---|
| scheibe          | teilschnitt-anmeldung |
| datum            | 2026-08-20 |
| geprueft_commit  | 248baeda8b8b06c1ae9f9c4778f2ce858cb442ad |
| angefordert_von  | A. Han |
| pruefendes_modell | GPT 5.6 Sol|
| pruefende_fassung | Anzeige im Modellwähler am 20.08.2026: „GPT-5.6 Sol"; eine feinere Fassungsangabe stellt die Oberfläche nicht bereit |
| frische_instanz | `ja` |
| getrennter_kontext | `ja` |
| gegen_roh_evidenz | `ja` |
| evidenz | A_Pruefgegenstand.txt (23 Dateien: app/, mail/, migrations/, seeds/) und C_Massstab.txt (schema/K19_screens.yaml, schema/freiraum_datamodel.sql); im selben Gespräch nachgereicht B_Messungen.txt (14 Dateien: Prüffälle, Prüfausgaben, Manifeste). Roh-Belege im Wortlaut, vollständig gelesen. Keine Bauberichte, keine Zusammenfassungen. D_Nachweise.txt (Klauselregister, Herkunftsgraph) wurde nicht vorgelegt. |
| harness_hat_nicht_geschrieben | `ja` |
| urteil |  traegt nicht |

<!-- ENDE KOPF -->

## Zeichnung der Anforderung

Ich habe dieses Review bei einer **frischen Instanz** mit **getrenntem Kontext** angefordert,
die vorgelegte Roh-Evidenz benannt, und das Urteil unverändert übernommen. Der Harness hat
es nicht geschrieben.

| Name | Datum | Unterschrift |
|---|---|---|
| A. Han | 20.08.2026 | A. Han |

---

## Urteil des Fremdmodells

*Unverändert einsetzen. Nicht zusammenfassen, nicht glätten, nicht kürzen — ein
zusammengefasstes Fremdurteil ist wieder das eigene Wort.*

### Erster Durchgang — vorgelegt: A_Pruefgegenstand.txt und C_Massstab.txt

A · Anmeldung, Sitzung, Zugriffsweg

1 — K03-M13: Nein, bei der eigentlichen Anmeldung sehe ich keine Sicherheitsprüfung, die ausschließlich in der Oberfläche stattfindet. Die Anmeldung selbst ruft serverseitig anmelden() auf (app/haupt.py:255-256); dort werden Konto und Status gelesen (app/anmeldung.py:129-131), der Code atomar verbraucht (app/anmeldung.py:158-166), der Portalzugang bestimmt (app/anmeldung.py:179-181) und erst dann die Sitzung angelegt (app/anmeldung.py:189-202). Allerdings dokumentiert der Server selbst eine andere, derzeit nur sichtbare und nicht serverseitig erzwungene Kenntnisnahme: app/haupt.py:245-253. Bezogen auf diese Prüfung gilt K03-M13 also gerade nicht als erfüllt.

2 — K13-M05: Die fünf verlangten Prüfungen sind nicht vollständig umgesetzt.
Aktives Konto: gebaut in sitzung_pruefen(), status != "AKTIV" beendet die Sitzung (app/sitzung.py:131-146). Mitgliedschaft: gebaut, aber lediglich indirekt darüber, dass genau ein freigeschaltetes Portal aus membership gefunden werden muss (app/sitzung.py:72-89, 148-153). Rolle: fehlt als Berechtigungsprüfung; portal_bestimmen() liest nur m.portal_code, nicht role_id oder Rollenberechtigungen (app/sitzung.py:82-86). Mandant: Der Mandant wird zwar aus dem Konto übernommen (app/sitzung.py:110-121, 161-167), aber die dafür neu vorgesehene transaktionslokale Mandantenmechanik wird von keinem vorhandenen Weg benutzt; der Quelltext bezeichnet den heutigen Normalfall selbst als ungeschützt (app/datenbank.py:381-416). Objektbezug: nicht allgemein gebaut. Beim Eignungs-Check wird er für fit_check durch tenant_id + actor_id hergestellt (app/vorpruefung.py:426-449), aber K13-M05 verlangt die fünf Prüfungen vor jedem betreffenden Oberflächenaufruf; eine allgemeine Objektberechtigungsprüfung existiert nicht. Damit fehlen mindestens Rolle und allgemeiner Objektbezug, und die Mandantenprüfung ist nicht als durchgängiger Serverpfad umgesetzt.

3 — K03-D01: Für die nachgelagerten Routen sehe ich keinen Teil-Zugang mit WARTET_2FA. sitzung_pruefen() akzeptiert ausschließlich AKTIV; alles andere beendet die bestehende Sitzung und liefert None (app/sitzung.py:131-153). Bei der Anmeldung darf WARTET_2FA nur innerhalb des Vorgangs vorkommen, der den richtigen Code verbraucht und das Konto auf AKTIV setzt (app/anmeldung.py:150-176, 189-202). Aber die Einladungseinlösung selbst verändert im Zustand WARTET_2FA bereits Daten — Einladung und Kontostatus — bevor eine gültige Sitzung existiert (app/einladung.py:236-245, 277-293). Das ist fachlich der vorgesehene Vor-Anmeldeweg; nach dem Wortlaut „kein Vorgang“ von K03-D01 wäre das allerdings eine Ausnahme, die die Klausel selbst nicht formuliert.

4 — K03-M05: Nur die Sechsstelligkeit des erzeugten Codes wird im Quelltext durchgesetzt; mfa_method = EMAIL_CODE nicht. Der Generator erzeugt genau sechs Ziffern (mail/versand.py:50-52, 115-119). Die Anmeldung validiert dagegen die Eingabe nicht auf sechs Ziffern; sie trimmt sie lediglich (app/anmeldung.py:206-216) und vergleicht den Hash (app/anmeldung.py:158-166). Vor allem wird actor.mfa_method beim Anmelden überhaupt nicht gelesen (app/anmeldung.py:129-131). Das Zielschema lässt neben EMAIL_CODE ausdrücklich auch OFF zu (schema/freiraum_datamodel.sql:49, 155). Ein Konto mit mfa_method = OFF und einem gültigen login_code würde dieser Serverpfad nicht wegen der MFA-Methode abweisen. K03-M05 ist daher nicht vollständig im Code durchgesetzt.

5 — K03-M15:

Zehn Minuten: im Code/Schema durchgesetzt. expires_at erhält standardmäßig now()+10 minutes, und eine längere Frist wird zusätzlich durch login_code_frist verhindert (migrations/M30__pilot_sammelmigration.sql:192-205). Beim Verbrauch wird expires_at > now() geprüft (app/anmeldung.py:159-165).
Genau einmal: im Code durchgesetzt. Der Verbrauch setzt consumed_at, aber nur wenn dieser noch NULL ist (app/anmeldung.py:158-166); zwei gleichzeitige erfolgreiche Verbräuche derselben offenen Zeile sind dadurch ausgeschlossen.
Neuer Code entwertet alle älteren offenen Codes: im Datenbankcode durchgesetzt. Der BEFORE INSERT-Trigger setzt bei allen älteren offenen Codes desselben Kontos superseded_at (migrations/M30__pilot_sammelmigration.sql:213-235).
Nur kryptografischer Prüfwert gespeichert: im Versandcode durchgesetzt. Der Klarcode wird erzeugt (mail/versand.py:402), gespeichert wird ausschließlich streuwert(code, pfeffer()) in code_hash (mail/versand.py:407-412). Die Tabelle führt kein Klartextfeld (migrations/M30__pilot_sammelmigration.sql:192-203).

6 — K03-G01: Es gibt mehrere Sperren ohne den konkret verursachenden Grund. Bei falschem, abgelaufenem, verbrauchtem oder entwertetem Code, unbekanntem oder mehrdeutigem Konto, gesperrtem Konto und fehlendem Portal kommt nach außen immer nur "Anmeldung nicht moeglich. Pruefen Sie Adresse und Code." (app/anmeldung.py:60-62, 167-181, 206-216; app/haupt.py:258-262). Bei ungültiger, abgelaufener, widerrufener oder bereits eingelöster Einladung lautet die eine Meldung "Dieser Einladungslink gilt nicht mehr. Bitte fordern Sie einen neuen an." (app/einladung.py:104-107, 377-447). Besonders klar gebrochen ist die Begründung bei fehlendem Versandweg: der Link gilt weiter, trotzdem sieht der Nutzer genau den Satz, er gelte nicht mehr; der Quelltext benennt diese offene Lücke selbst (app/einladung.py:415-426). Auch ein nicht eindeutig treffendes Mandanten-Update bei der Eignung endet in der generischen MELDUNG_ERGEBNIS_UNKLAR (app/vorpruefung.py:987-991, 1110-1118).

B · Einladung

7 — K20-M08: Aus der Datenbank allein kann ich den Einladungslink nicht rekonstruieren. Die Anwendung erzeugt ein zufälliges Token (app/einladung_senden.py:218-237), speichert in invitation.token_hash nur dessen Streuwert (app/einladung_senden.py:663-673) und vergleicht bei der Einlösung wieder nur den Streuwert (app/einladung.py:236-245). Das Zielschema enthält token_hash, aber kein Token-Klartextfeld (schema/freiraum_datamodel.sql:200-212). Unter der Annahme, dass TOKEN_BYTES = 32 tatsächlich kryptografisch zufällig erzeugt wird, reicht ein vollständiger Datenbankabzug nicht zum Einlösen.

8 — K20-M14: Im gezeigten Serverpfad entstehen Zustand und Zeitpunkt gemeinsam. Dieselbe einzelne SQL-Anweisung setzt status='EINGELOEST' und redeemed_at=now() (app/einladung.py:236-245). Zusätzlich erzwingt das Schema die Äquivalenz (status='EINGELOEST') = (redeemed_at IS NOT NULL) (schema/freiraum_datamodel.sql:200-212). Ein Abbruch zwischen beiden Werten ist damit nicht möglich.

9 — K20-M15: Einladung und Aktivierung liegen in derselben Transaktion, aber nicht in derselben SQL-Anweisung. Zuerst wird die Einladung eingelöst (app/einladung.py:236-245), anschließend actor.status='AKTIV' gesetzt (app/einladung.py:277-284). Beide laufen innerhalb with conn.transaction() (app/einladung.py:433-436). Scheitert der zweite Schritt, löst _Misserfolg den Rollback aus (app/einladung.py:286-293). Ein dauerhaftes Zwischenstadium „Einladung eingelöst, Konto noch WARTET_2FA“ entsteht auf diesem Pfad daher nicht.

10 — K20-D10: Bei zwei gleichzeitigen Einlösungen kann nur eine gewinnen. Das UPDATE trifft ausschließlich status='VERSANDT' (app/einladung.py:236-245). Nach dem Commit der ersten Transaktion erfüllt die Zeile diese Bedingung für die zweite nicht mehr. Die zweite Anfrage fällt in _Misserfolg und erhält die allgemeine Ungültigkeitsmeldung (app/einladung.py:433-447, app/einladung.py:104-107).

11 — K03-M25: Die sechs Teilaussagen sind nur teilweise erfüllt. Zielmandant: beim Anlegen wird das Konto ausschließlich im Mandanten der Sitzung gesucht/angelegt (app/einladung_senden.py:395-420). Entscheidungsnachweis: einen belastbaren Beleg für eine entsprechende Prüfung finde ich im Versandpfad nicht; _anlegen() prüft Portal und Datenbankbedingungen, aber keinen benannten Entscheidungsnachweis (app/einladung_senden.py:614-680). Domäne: wird durch den Datenbankwächter bzw. dessen Fehlerpfad einbezogen (app/einladung_senden.py:783-796). Atomare Anlage von Einladung und Ereignis: Einladung und Nachweis werden innerhalb derselben äußeren Transaktion angelegt (app/einladung_senden.py:771-775; _anlegen: 663-680). Umgehung durch Portal/Builder/Service-Schlüssel: nicht belegbar, weil entsprechende alternative Aufrufer bzw. Berechtigungstests in den gelieferten Roh-Belegen fehlen. Fehlermeldungen geben den Kontobestand teilweise preis: insbesondere
"Zu dieser Adresse bestehen mehrere Konten, die sich nur in der Gross- und Kleinschreibung unterscheiden. Der Versand ist gesperrt, bis das geklaert ist." (app/einladung_senden.py:176-179).
Das verrät ausdrücklich, dass mehrere Konten bestehen. Dagegen wurde die frühere Fremdmandantenmeldung entfernt (app/einladung_senden.py:165-174). Die weitere Meldung
"Zu diesem Konto ist zeitgleich eine andere Einladung entstanden. Es wurde nichts geaendert; bitte erneut versuchen." (app/einladung_senden.py:181-183) verrät ebenfalls die Existenz „dieses Kontos“. Damit ist die Nicht-Offenbarung nicht erfüllt.

12 — K03-M26:

Verwaltete Identität oder Secret-Referenz: nicht gebaut. SMTP-Benutzer und Kennwort kommen direkt aus Umgebungsvariablen (mail/versand.py:70-79). Der Kommentar beschreibt verwaltete Identität nur als späteres Ziel (mail/versand.py:126-137).
Erlaubte Ausgangsverbindung: nur teilweise. SMTP-Host muss explizit gesetzt sein und TLS ist außerhalb lokal standardmäßig an (mail/versand.py:55-80, 190-218); einen Beleg für eine Netzwerk-/Egress-Allowlist finde ich nicht.
Datensparsame Telemetrie: nicht vollständig. mail_delivery speichert die vollständige Empfängeradresse (mail/versand.py:221-226).
Keine Codes/vollständigen E-Mail-Adressen in Logs: der Serverpfad vermeidet sie überwiegend (app/einladung.py:336-343; app/einladung_senden.py:749-751), aber das Kommandozeilenwerkzeug gibt vollständige Empfängeradressen aus (mail/versand.py:536-542, 552).
Providerfehler/fehlender Nachweis/unklare Konfiguration fail-closed und Betriebsalarm mit Runbook-Verweis: Provider- und Konfigurationsfehler sperren bzw. widerrufen (app/einladung_senden.py:761-767, 798-805; mail/versand.py:434-446). Einen Alarmierungsmechanismus mit Runbook-Verweis finde ich nicht. Bei fehlendem Versandweg wird lediglich geloggt (app/einladung.py:427-431). Damit ist dieser Teil nicht gebaut.

13 — K20-M18: Eine konkrete Lücke ist der Anmeldecode selbst. Das Ausstellen eines neuen Codes entwertet ältere Codes über einen Datenbanktrigger (migrations/M30__pilot_sammelmigration.sql:218-235), aber dafür wird in diesem Vorgang keine event-Spur mit handelnder Instanz sowie vorher/nachher erzeugt (mail/versand.py:402-446). Das ist eine Änderung am Zugang im Sinne der Klausel. Bei Einladungsstatus und Mitgliedschaft dagegen werden Vorher/Nachher-Werte geschrieben (app/einladung.py:158-175, 293; app/einladung_senden.py:491-494, 563-566, 607-610, 677-680).

14 — K20-M25: Der Hinweis wird angezeigt; die geforderte Aufbewahrungsklasse wird nicht gesetzt. Der Text lautet "Einladung versandt. Der vorherige Link ist ungueltig." (app/einladung_senden.py:144-151). _nachweis() lässt retention_class im INSERT vollständig weg (app/einladung_senden.py:276-306). Der Quelltext weist ausdrücklich darauf hin, dass dadurch die Tabellenvorgabe greift und K20-M25 mit der späteren M30-Vorgabe kollidiert (app/einladung_senden.py:292-299). M30 setzt den Standard von event.retention_class auf EREIGNIS, nicht BETRIEBSPROTOKOLL (migrations/M30__pilot_sammelmigration.sql:1481-1497). K20-M25 ist damit nicht erfüllt.

C · Mandantengrenze

15 — Eine durchgängige Mandantengrenze kann ich diesem Stand nicht bescheinigen. Die zentrale Mechanik mandantenvorgang() wird von keinem vorhandenen Weg benutzt; der Quelltext hält fest, dass der Normalfall weiterhin verbindung() ohne gesetzten Mandanten ist (app/datenbank.py:381-416).

Stellen ohne ausdrückliche Mandantenbedingung im betrachteten Pfad sind insbesondere:

app/anmeldung.py:85-87 — INSERT login_attempt; kein Mandant.
app/anmeldung.py:129-131 — globale Suche actor WHERE lower(email)=...; kein Mandant.
app/anmeldung.py:158-166 — login_code nur über actor_id; kein Mandant.
app/anmeldung.py:189-192 — actor nur über id; kein Mandant.
app/anmeldung.py:200-202 — auth_session nur actor_id; kein Mandant.
app/einladung.py:236-245 — Einladung wird nur anhand token_hash/status/Frist/Kontostatus eingelöst; keine tenant_id-Bedingung.
app/einladung.py:277-284 — Kontoaktivierung nur über actor.id; kein Mandant.
app/sitzung.py:82-86 — membership nur anhand actor_id; tenant_scope wird nicht geprüft.
app/sitzung.py:93-95, 157-159 — Sitzungsupdates nur über Sitzungs-ID.
app/sitzung.py:110-117 — Sitzung/Konto über Sitzungs-ID; kein Mandant in der Bedingung.
app/einladung_senden.py:474-489 — Löschen aus membership über Einladung/Konto/Portal; keine Prüfung m.tenant_scope.
app/einladung_senden.py:540-552 — Mitgliedschaft wird aus actor.id und Portal erzeugt; kein Vergleich gegen einladender["mandant"].
app/einladung_senden.py:554-557 — Eindeutigkeitszählung nach Konto+Portal, ohne tenant_scope.
app/einladung_senden.py:598-603 — Widerruf einer Einladung nach actor_id/status; kein Mandant.
app/einladung_senden.py:657-659 — portal_enabled ist global; kein Mandant.
app/einladung_senden.py:663-673 — neue Einladung wird über actor.id und dessen tenant erzeugt, aber ohne expliziten Vergleich zum Mandanten der Sitzung.
app/einladung_senden.py:708-713 — Rücknahme nach Einladungs-ID; kein Mandant.
app/vorpruefung.py:386-389 und 823-826 — Fragen-/Optionskatalog global; fachlich Konfigurationsbestand, aber ohne Mandant.
app/vorpruefung.py:461-464 — aktive Antworten nur über fit_check_id; kein Mandant.
app/vorpruefung.py:890-918 — Lesen, Zurücknehmen und Einfügen von fit_answer nur über fit_check_id/question_code; kein Mandant in diesen Anweisungen.
app/vorpruefung.py:971-980 — zuerst wird fit_answer ohne Mandantenbedingung zurückgenommen; erst das anschließend im selben Transaktionsblock ausgeführte fit_check-UPDATE trägt tenant_id. Bei Fehltreffer wird zwar zurückgerollt (app/vorpruefung.py:981-985), aber die einzelne Schreibanweisung selbst enthält die Mandantengrenze nicht.
app/vorpruefung.py:1164-1170 — event bekommt einen Mandantenwert geschrieben, prüft aber keinen bestehenden Objektbezug.

Positiv: fit_check selbst wird beim Lesen mit Mandant und Konto eingeschränkt (app/vorpruefung.py:443-449), und die Ergebnis-/Reset-Updates tragen tenant_id (app/vorpruefung.py:977-980, 1092-1095). Beim Einladungsversand wird das Zielkonto innerhalb des Mandanten der Sitzung gesucht (app/einladung_senden.py:395-420).

Damit kann ich nicht sagen, dass ein konkret vorgelegter Fremdmandantenangriff nachweislich erfolgreich ist; dafür fehlen entsprechende Laufbelege. Aber die verlangte Aussage „jede Abfrage und jede Schreibanweisung trägt die Mandantengrenze“ ist eindeutig falsch.

D · Vorprüfung und Halt

16 — K04-M04: Ja, der Startbestand führt genau drei Fragen und die Laufzeit prüft das erneut. Die drei Fragen werden als art, nutzung, daten eingefügt (seeds/Seed_Vorpruefung_K04.sql:54-61); der Seed verlangt anschließend fragen = 3 und dimensionen = 3 (seeds/Seed_Vorpruefung_K04.sql:118-130). Das Schema macht dimension zudem NOT NULL UNIQUE (schema/freiraum_datamodel.sql:241-247). Die Anwendung verweigert Anzeige/Auswertung, wenn nicht genau ART, NUTZUNG und DATEN vorhanden sind (app/vorpruefung.py:404-423).

17 — K04-M07: Ja. Alle vier Ausschlussantworten stehen im Startbestand mit is_eligible=false. Reine Netzseite: seeds/Seed_Vorpruefung_K04.sql:82-83; installierte Software: 84-85; Wegwerf-Versuch: 91-92; Datenfrage „Nein - es geht um Darstellung, Inhalte oder Gestaltung“: 98-100. Der Seed prüft außerdem, dass insgesamt genau vier false vorkommen (seeds/Seed_Vorpruefung_K04.sql:118-145).

18 — K04-M08: Auf dem Halt-Bildschirm erscheinen genau drei Auswege. Antwort aendern → POST /eignung/aendern, Termin vereinbaren → POST /eignung/termin, Zur Uebersicht → /uebersicht (app/vorlagen/en04_eignung.html:246-282). Antwort ändern setzt die betreffende aktive Antwort auf superseded_at und den Check im selben Transaktionsblock zurück auf OFFEN (app/vorpruefung.py:969-985). Der Terminweg schreibt lediglich TERMIN_ANGEFRAGT und lässt den Check unverändert (app/vorpruefung.py:1123-1172). Die Übersicht liest denselben noch bestehenden Check und zeigt sein Ergebnis (app/vorpruefung.py:571-596). Aber: Der Terminweg löst die im Bildschirmvertrag verlangte Ansprechperson gerade nicht auf; der Quelltext erklärt contact für außerhalb des Schnitts und speichert nur den Wunsch (app/vorpruefung.py:1131-1139). Er führt daher nicht vollständig zu „Gespräch mit der Ansprechperson vereinbaren“, sondern nur zu einem internen Ereignis.

19 — K04-M09: Ja, die konkrete aufhaltende Antwort wird ermittelt und angezeigt. aufhaltende_antworten() übernimmt option["label"], also den Wortlaut der tatsächlich gewählten ungeeigneten Antwort (app/vorpruefung.py:470-485). Der Haltblock iteriert über diese Gründe (app/vorlagen/en04_eignung.html:246-273). Es wird damit nicht nur „ungeeignet“ angezeigt.

20 — K04-D04: Eine Anwendung oder Angebotsanfrage entsteht auf den gezeigten Haltwegen nicht; ein anderes Objekt entsteht aber durchaus. Die Auswertung setzt nur fit_check.outcome/completed_at (app/vorpruefung.py:1087-1095). Ein erneuter handgesendeter /eignung/weiter-Aufruf im Halt wird vor jeder Änderung abgefangen (app/vorpruefung.py:1055-1065). Der Rücksprung über /uebersicht liest nur den vorhandenen Check (app/vorpruefung.py:584-596). Der Terminweg erzeugt allerdings eine event-Zeile TERMIN_ANGEFRAGT (app/vorpruefung.py:1164-1170); das ist keine Anwendung und keine Angebotsanfrage. Einen Race, der nach NICHT_GEEIGNET dennoch app erzeugt, kann ich aus dem Gegenstand nicht belegen; der Anwendungs-Anlegeweg liegt ausdrücklich außerhalb des Prüfgegenstands. Für eine vollständige Nebenläufigkeitsbewertung fehlen außerdem konkrete Concurrency-Prüfausgaben.

21 — K04-G11: Ja, der Stand öffnet den Vorprüfungsweg ohne erkennbaren Freigaberiegel. Der gesamte Router wird bedingungslos in FastAPI registriert (app/haupt.py:105); /vorpruefung, /eignung sowie die schreibenden Endpunkte sind unmittelbar definiert und erreichbar (app/vorpruefung.py:628-666, 790-829, 923, 1010, 1123). Im gelieferten Bildschirmvertrag steht der Gesamtstatus FREIGABEKANDIDAT (schema/K19_screens.yaml:8-10). Einen Feature-Schalter oder sonstigen Produktivsperrriegel für K04 finde ich nicht. K04-G11 ist daher nicht umgesetzt.

E · Misst die Prüfung, was sie vorgibt

22 — Nicht vollständig beantwortbar: Die vier Negativfall-Dateien liegen vor, die zugehörigen tatsächlichen Prüfausgaben aber nicht. Die Dateien nennen als erwartete Bedingungen:

N1: frist_ge_mindestfrist (migrations/negativfaelle/M30_N1_frist_ge_mindestfrist.sql:2-4)
N2: mail_fehler_braucht_grund (migrations/negativfaelle/M30_N2_mail_fehler_braucht_grund.sql:2-4)
N3: pseudonym_vor_frist (migrations/negativfaelle/M30_N3_pseudonym_vor_frist.sql:2-4)
N4: tagesfrist_positiv (migrations/negativfaelle/M30_N4_tagesfrist_positiv.sql:2-4)

Die eigentlichen UPDATE/INSERT-Versuche stehen in N1 :14-16, N2 :14-15, N3 :27-29, N4 :14. Aber keine Ausgabedatei mit den vier tatsächlichen PostgreSQL-Fehlermeldungen ist unter den 23 gelieferten Dateien enthalten; auch die in M30 erwähnte M30__pruefung.sql gehört nicht zum gelieferten Satz (migrations/M30__pilot_sammelmigration.sql:2409 bzw. Schlusskommentar zur getrennten Teststufe). Deshalb kann ich weder belegen, dass jeder Fall an seiner eigenen Bedingung scheitert, noch die vier tatsächlichen Fehlermeldungen im Wortlaut zitieren. Jede solche Behauptung wäre geraten.

23 — Ebenfalls nicht belastbar beantwortbar, weil die eigentlichen Prüffälle und deren Ausgaben fehlen. Im gelieferten Satz befinden sich Quelltext, Migration, vier Negativfall-SQL-Dateien und Seeds, aber keine automatisierten UI-/HTTP-Prüfdateien. Ich kann daher nicht feststellen, welcher konkrete Prüffall etwa nur "Text" in response.text misst. Umgekehrt gibt es im Quelltext zahlreiche Aussagen über frühere „Messungen“ und „Gegenprüfungen“, aber ohne die dazugehörigen Prüffälle/Ausgaben sind sie keine unabhängigen Belege. Beispiel: app/haupt.py:232 sagt selbst, dass kein einziger Prüffall das Feld ki_bestaetigt kennt. Das ist eine Quelltextbehauptung; der dazugehörige Prüfsatz fehlt. Für die von dir verlangte Vorkommen-vs.-Unterscheidungsanalyse lautet die belastbare Antwort daher: nicht beurteilbar mit den gelieferten Belegen.

24 — K23-D09: Im Serverpfad sehe ich keinen Klartext-Anmeldecode im Log; im mitgelieferten Kommandozeilenpfad stehen aber vollständige E-Mail-Adressen in Ausgabe und Fehlerausgabe. SystemExit(f"Kein Konto zu {a.an}...") gibt die volle Adresse in einer Fehlerausgabe aus (mail/versand.py:533-537). Erfolgszeilen schreiben "Code an {a.an} uebergeben..." und "Einladung an {a.an} uebergeben" (mail/versand.py:539-552). Damit ist K23-D09 jedenfalls für diesen ausgelieferten Codepfad nicht eingehalten. Der Klarcode selbst wird nicht ausgegeben; er erscheint nur im Mailtext (mail/versand.py:402-420). Das DSN-Kennwort wird vor Ausgabe maskiert (mail/versand.py:83-86, 103-110).

Zur zweiten Hälfte kann ich kein Manifest oder Protokoll mit einer nachweislich falschen Behauptung benennen, weil solche Artefakte im gelieferten 23-Dateien-Satz nicht enthalten sind. Es gibt allerdings viele selbstreferenzielle Behauptungen im Quelltext über externe Messungen, Gegenprüfungen und Nachweise, deren zugrunde liegende Rohbelege fehlen, z. B. der behauptete Zeitvergleich in app/anmeldung.py:133-142, die gemessene Mehrdeutigkeit in mail/versand.py:292-315 oder die behauptete Gegenprüfung in app/einladung.py:345-352. Diese Kommentare darf ich nicht als unabhängigen Nachweis übernehmen.

In Summe sind mehrere MUSS-/GILT-Klauseln materiell verletzt oder nicht belegbar: K13-M05 ist nicht vollständig umgesetzt, mfa_method=EMAIL_CODE wird nicht serverseitig geprüft, K03-G01 hat unbegründete bzw. sogar sachlich falsche Sperrmeldungen, K03-M25 leakt Kontobestand über Fehlermeldungen, K03-M26 fehlt insbesondere bei Secret-Handling/Runbook-Alarmierung, K20-M18 lässt Zugangscodeänderungen ohne vollständigen Änderungsnachweis, K20-M25 setzt die falsche Aufbewahrungsklasse, die Mandantengrenze ist nicht durchgängig eingebunden, der Termin-Ausweg ist fachlich nur halb gebaut und K04-G11 hat keinen Produktivsperrriegel. Für die behauptete Prüfgüte in 22/23 fehlen zudem die tatsächlichen Prüfausgaben.

trägt nicht

### Zweiter Durchgang — nachgereicht: B_Messungen.txt (Fragen 21 bis 23)

21 — K04-G11

Der Produktivsperrriegel ist im Quelltext nicht gebaut; die Prüffälle messen K04-G11 überhaupt nicht. Der Vorprüfungs-Router wird ohne Freigabeschalter eingebunden (app/haupt.py:72,104), und /vorpruefung sowie /eignung sind unmittelbar als erreichbare Routen registriert (app/vorpruefung.py:627-666,789-829).

Der Prüflauf bezeichnet sich zwar als Prüfung gegen K04, endet aber mit VP-31 = K04-G07; ein Fall für K04-G11 ist nicht enthalten (pruefungen/klauseln/vorpruefung_lauf.sh:1-10,2176-2207).

Urteil zu 21: Auf Codeebene ist der von K04-G11 verlangte Riegel nicht vorhanden. Ob dieser Serverstand tatsächlich in einer Produktivumgebung erreichbar ist, kann ich aus den gelieferten Belegen nicht feststellen; dafür fehlt ein Deployment-/Betriebsbeleg.

22 — M30_N1 bis M30_N4

Die Machart der Prüfung ist jetzt richtig: Für jede Negativdatei liest der Harness die Kopfzeile -- erwartet: ..., führt genau diese Datei aus und wertet sie nur dann als bestanden, wenn die tatsächliche psql-Ausgabe genau diese erwartete Bedingungskennung enthält. Läuft die Anweisung durch oder erscheint eine andere Bedingung, wird der Fall rot (pruefungen/lauf.sh:274-310).

Die vier erwarteten Bedingungen sind:

N1: frist_ge_mindestfrist (migrations/negativfaelle/M30_N1_frist_ge_mindestfrist.sql:1-15).
N2: mail_fehler_braucht_grund (M30_N2_mail_fehler_braucht_grund.sql:1-13).
N3: pseudonym_vor_frist (M30_N3_pseudonym_vor_frist.sql:1-28). Der Fall wurde ausdrücklich geändert, weil der frühere N3 wegen null eingefügter Zeilen gar keine Bedingung auslöste (:14-25).
N4: tagesfrist_positiv (M30_N4_tagesfrist_positiv.sql:1-12).

Aber ob die vier im konkreten Lauf tatsächlich jeweils an dieser Bedingung gescheitert sind, kann ich weiterhin nicht belegen. B_Messungen.txt enthält die Prüffälle und den Harness, aber keine konkrete psql-Laufausgabe dieser vier Fälle. Noch wichtiger: Im Erfolgszweig verwirft der Harness die tatsächliche Fehlermeldung und gibt nur "scheitert an $erwartet" aus (pruefungen/lauf.sh:302-304). Die vollständige PostgreSQL-Meldung wird nur beim falschen Fehlerfall ausgegeben (:306-308).

Darum kann ich die verlangten vier tatsächlichen Fehlermeldungen im Wortlaut nicht ehrlich zitieren. Belegt sind nur die vier erwarteten Bedingungsnamen.

23 — Vorkommen statt Unterscheidung

Ja — solche Scheinprüfungen gab es. In der aktuellen Fassung sind die drei wirklichen Vorkommensfehler aber nachgebessert.

VP-14 / K04-M09: Früher reichte es, wenn der Wortlaut der aufhaltenden Antwort irgendwo auf EN-04 vorkam. Da EN-04 die Antwortmöglichkeiten ohnehin zeigt, konnte der Test praktisch nicht scheitern (vorpruefung_lauf.sh:94-103). Jetzt wird geprüft, dass die aufhaltende Antwort im Halt-Block steht und eine nicht aufhaltende Antwort dort nicht steht (:1410-1500).
VP-12: Früher musste lediglich der Text der fehlenden Frage irgendwo auf der Seite vorkommen; dort stehen ohnehin alle drei Fragen (vorpruefung_lauf.sh:117-123). Jetzt muss die fehlende Frage im div#hinweis stehen und eine bereits beantwortete Frage dort fehlen (:1293-1360).
VP-10: Früher wurde nur geprüft, ob die Kennung der gewählten Option auf der Seite vorkommt; sie musste dort ohnehin stehen, damit sie absendbar ist (vorpruefung_lauf.sh:125-130). Jetzt wird die gewählte Option gegen alle anderen Optionen derselben Frage abgegrenzt: genau sie muss markiert sein (:1183-1253).

VP-09 gehört dagegen trotz der Überschrift „vier Fälle“ nicht zu diesem Vorkommensfehler. Sein alter Fehler war ein anderer: Ein deutscher Freitext konnte bereits an der UUID-Formprüfung scheitern und damit an einer fremden Bedingung. Die aktuelle Fassung ergänzt deshalb eine formal gültige, aber nicht vorhandene UUID (vorpruefung_lauf.sh:1115-1179).

Umgekehrt gibt es mindestens einen Prüffall, der die Klausel stärker erscheinen lässt, als der Code tatsächlich ist: VP-18. Der Test wertet K04-M08 als erfüllt, wenn genau ein event mit TERMIN_ANGEFRAGT entsteht (vorpruefung_lauf.sh:1606-1647). Der Code sagt aber ausdrücklich: Die Ansprechperson wird nicht aufgelöst, es wird niemand kontaktiert; „der Wunsch wird vermerkt, die Zustellung an die Ansprechperson ist ein offener Punkt“ (app/vorpruefung.py:1123-1144).

Damit beweist VP-18 „Ereignis vermerkt“, nicht „Gespräch mit der Ansprechperson vereinbart/angestoßen“. Das ist ein verbliebener Messfehler zugunsten des Standes.

Du hast dein Schlusswort abgegeben, bevor du die Prüffälle aus B_Messungen.txt gesehen hattest. Jetzt hast du sie.
 Schließe erneut ab — mit genau einem dieser drei Worte, als letzte Zeile deiner Antwort, sonst nichts:
 trägt · trägt mit Auflagen · trägt nicht

trägt nicht

## Fundstellen

*Das Urteil muss auf Fundstellen zeigen (Präzedenz Blatt 26:2 — „80 Zeilen mit
Fundstellen"). Ein Urteil ohne Fundstellen ist eine Meinung.*

Das Modell nennt seine Fundstellen bei jeder einzelnen Frage im Urteil oben, je als
`Datei:Zeile` — insgesamt mehrere Hundert. Sie sind dort nicht herausgelöst worden,
weil sie ihre Aussagekraft aus dem Satz beziehen, in dem sie stehen.

## Auflagen und offene Punkte

Keine Auflagen — das Urteil lautet „trägt nicht". Was daraus folgt, entscheidet Tor 4,
nicht dieses Blatt.

Die Gründe stehen im Urteil oben. Sie sind hier einzeln aufgeführt, damit keiner in einem
Absatz untergeht. Der Wortlaut ist seiner.

| Nr. | Grund des „trägt nicht" | Träger | Frist |
|---|---|---|---|
| 1 | K13-M05 ist nicht vollständig umgesetzt — Rolle und allgemeiner Objektbezug fehlen, die Mandantenprüfung ist kein durchgängiger Serverpfad |  |  |
| 2 | K03-M05: `mfa_method = EMAIL_CODE` wird beim Anmelden gar nicht gelesen; ein Konto mit `OFF` würde nicht abgewiesen |  |  |
| 3 | K03-G01: Sperren ohne den verursachenden Grund — bei fehlendem Versandweg gilt der Link weiter, der Nutzer liest das Gegenteil |  |  |
| 4 | K03-M25: Fehlermeldungen geben den Kontobestand preis |  |  |
| 5 | K03-M26: kein Secret-Handling über verwaltete Identität, keine Alarmierung mit Runbook-Verweis; `mail_delivery` speichert die vollständige Adresse |  |  |
| 6 | K20-M18: die Entwertung älterer Anmeldecodes erzeugt keine `event`-Spur mit Vorher/Nachher |  |  |
| 7 | K20-M25: `_nachweis()` lässt `retention_class` weg; M30 setzt EREIGNIS statt BETRIEBSPROTOKOLL |  |  |
| 8 | Die Mandantengrenze ist nicht durchgängig — `mandantenvorgang()` wird von keinem Weg benutzt; 22 Stellen ohne Mandantenbedingung benannt |  |  |
| 9 | K04-M08: der Termin-Ausweg löst die Ansprechperson nicht auf — es entsteht nur ein internes Ereignis |  |  |
| 10 | K04-G11: kein Produktivsperrriegel; der Router wird bedingungslos eingebunden |  |  |
| 11 | Zu Frage 22 fehlen die tatsächlichen Fehlermeldungen — der Harness verwirft sie im Erfolgszweig und gibt nur „scheitert an $erwartet" aus (`pruefungen/lauf.sh`:302-304) |  |  |
| 12 | **VP-18 misst zugunsten des Standes:** er wertet K04-M08 als erfüllt, wenn ein `TERMIN_ANGEFRAGT`-Ereignis entsteht — er beweist „Ereignis vermerkt", nicht „Gespräch vereinbart". Ein verbliebener Messfehler |  |  |


| Nr. | Auflage | Träger | Frist |
|---|---|---|---|
|  |  |  |  |
