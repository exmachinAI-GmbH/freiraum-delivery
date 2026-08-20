# Die zwölf Gründe des Fremdurteils — **nachgerechnet**

**20.08.2026 · Baubericht. Er stellt fest, er entscheidet nichts.**

Das Fremdmodell hat am 20.08.2026 „trägt nicht" geurteilt und zwölf Gründe genannt
(`nachweise/fremdreview/teilschnitt-anmeldung_260820.md`). Dieses Blatt rechnet jeden
einzeln am Quelltext nach — **nicht geglaubt, nachgesehen.**

## Das Ergebnis in einer Zeile

**Kein einziger Grund ist widerlegt.**

| | |
|---|---|
| **BESTÄTIGT** | **8** |
| **TEILWEISE** — die Beobachtung stimmt, die Folgerung geht zu weit oder zu kurz | **4** |
| **WIDERLEGT** | **0** |

## Und ein Befund über die Nachrechnung selbst

Jede Nachrechnung ist anschließend von einem eigenen Prüfer mit dem Auftrag gelesen worden,
sie zu **widerlegen**. **Alle sechs Gegenproben haben angeschlagen**, zusammen zwölf
Berichtigungen — und sie gehen fast durchweg **in dieselbe Richtung:**

> **Die Nachrechnung war zu nachsichtig mit dem eigenen Bau.** Fünf Gründe, die sie auf
> *TEILWEISE* abgestuft hatte, stehen nach der Gegenprobe wieder auf *BESTÄTIGT*.

Zwei Beispiele, weil sie zeigen, wie das passiert:

- **Grund 1**: Die Nachrechnung erklärte „Rolle fehlt" für *widerlegt* — sie hatte
  `_ohne_einladerecht` in `app/haupt.py:349-378` gefunden. Die Gegenprobe hält dagegen:
  `haupt.py:378` liest `stand["portal"]`, und das stammt aus einer Abfrage, die
  **`role_id` gar nicht liest**. Es ist eine Portalprüfung, keine Rollenprüfung. Der
  Fremde hatte zeilengenau recht.
- **Grund 11**: Die Nachrechnung nannte die Frage offen, ob der Wortlaut der Fehlermeldung
  überhaupt gefordert sei. Die Gegenprobe fand die Antwort in der Datei, die dieser Harness
  **zuerst liest** — `CLAUDE.md`:180-182: *„Ein Negativfall gilt erst als bestanden, wenn er
  an seiner eigenen Bedingung scheitert; **die Fehlermeldung im Wortlaut ist Teil der
  Evidenz**."*

## Die Einteilung

| | Zahl | |
|---|---|---|
| **BAU** — am Code behebbar, ohne dass jemand etwas entscheidet | **2** ganz (6, 11), Teile von 1, 2, 3, 4, 9 |
| **ENTSCHEIDUNG** — es braucht eine Festlegung eines Menschen | **10** |
| **BELEGLAGE** — aus fehlenden Belegen geschlossen | **0** |

**Zehn der zwölf berühren den 31.08.** Nicht betroffen sind Grund 9 und 10: K04-M08 gehört
nicht zu den 152 Klauseln des Teilschnitts — nachgerechnet über
`nachweise/klauselschnitt/S1_wortmarken.json`.

> **Das ist die eigentliche Nachricht dieses Blattes.** Der fremde Blick hat kaum Baufehler
> gefunden. Er hat **zehn Stellen gefunden, an denen niemand entschieden hat** — Auslegungen,
> Geltungsbereiche, Träger, Fristen. Der Bau hat sie im Quelltext benannt und ist
> weitergegangen; ein Dritter, der nur die Klauseln kennt, liest sie als Verstoß.

---

## Zwei Dinge, die der Bau selbst verschuldet hat

**1 · Eine veraltete Selbstauskunft hat den Prüfer in die Irre geführt.**
`app/datenbank.py` behauptet an drei Stellen (:19-22, :119, :216-220), `mandantenvorgang()`
habe **keinen Aufrufer**, und nennt `app/zweckbestimmung.py` namentlich als Nichtaufrufer.
Das ist seit `zweckbestimmung.py:1148` falsch — und es galt schon am geprüften Commit. Der
Fremde hat den Satz übernommen. **Reiner Bau, fünf Zeilen.**

**2 · Der Prüflauf wirft die Evidenz weg, die eine gezeichnete Regel verlangt.**
`pruefungen/lauf.sh:302-304` druckt im Erfolgszweig nur *„scheitert an `$erwartet`"* und
verwirft die tatsächliche PostgreSQL-Meldung. `CLAUDE.md`:180-182 verlangt sie im Wortlaut
als Teil der Evidenz. **Damit ist F07 für die vier Negativfälle nicht belegbar** — der Lauf
behauptet es, ohne es zu zeigen.

---

# Die zwölf Gründe einzeln

### Grund 1 · K13-M05

| | |
|---|---|
| **Nachgerechnet** | **BESTÄTIGT** |
| **Einordnung** | **BAU + enge ENTSCHEIDUNG** |
| **Berührt den 31.08.** | **ja** |

**Was das Fremdmodell sagt.** Die fuenf verlangten Pruefungen sind nicht vollstaendig umgesetzt: Konto und Mitgliedschaft gebaut,
Rolle fehlt als Berechtigungspruefung (portal_bestimmen() liest nur m.portal_code, nicht role_id),
Mandant nur uebernommen aber die transaktionslokale Mandantenmechanik von keinem vorhandenen Weg
benutzt, Objektbezug nicht allgemein gebaut. Fundstellen: app/sitzung.py:82-86, 131-153,
app/datenbank.py:381-416, app/vorpruefung.py:426-449.

**Was am Quelltext gemessen ist.**

Die Ueberschrift stimmt, zwei der drei Einzelvorwuerfe sind zu breit.

BESTAETIGT: (a) Aktives Konto -- /Users/andi/freiraum-delivery/app/sitzung.py:143-145 (status !=
AKTIV -> sitzung_beenden + None). (b) Mitgliedschaft -- portal_bestimmen(), app/sitzung.py:71-88,
angewandt in :147-152; indirekt ueber 'genau ein freigeschaltetes Portal', wie er sagt. (c) Kein
allgemeiner Objektbezug -- es gibt keinen zentralen Objektberechtigungspfad.

WIDERLEGT bei 'Rolle fehlt': Er hat nur portal_bestimmen() angesehen. /Users/andi/freiraum-
delivery/app/haupt.py:349-378 (_ohne_einladerecht) IST ein serverseitiger Rollen-Riegel -- 'return
stand["portal"] != PORTAL_VERWALTUNG' mit PORTAL_VERWALTUNG = "EXMA" (haupt.py:346), angewandt
ZWEIMAL, an GET und POST von /einladung/senden (haupt.py:426 und :456). Der Docstring
haupt.py:350-377 begruendet ihn ausdruecklich mit K13-M05 und K20-M02 (Release 1 fuehrt je Portal
genau EINE Rolle, EXMA-Mitgliedschaft IST Plattform-Admin). Diese Datei lag im Belegpaket.
Zusaetzlich liest /Users/andi/freiraum-
delivery/migrations/M32__zeilenschutz_und_stufenwechsel.sql:234-239 role_id wirklich (JOIN role r ON
r.id = m.role_id) und haelt in :227-232 eine gezeichnete Festlegung fest: 'die Rolle faellt damit
zusammen (T-4, gez. A. Han 19.08.2026)'. M32 lag NICHT im Paket.

WIDERLEGT bei 'von keinem vorhandenen Weg benutzt': /Users/andi/freiraum-
delivery/app/zweckbestimmung.py:159 importiert mandantenvorgang und :1148 betritt es ('with
mandantenvorgang(conn, stand["mandant"])'). Das galt schon am geprueften Stand -- 'git diff 248baed
HEAD -- app/ mail/ migrations/ seeds/ schema/' ist leer. Er hat die Selbstauskunft von
app/datenbank.py uebernommen, und die ist veraltet: :19-22 ('sie hat nach diesem Zug KEINEN
Aufrufer: kein Weg im Bestand betritt mandantenvorgang'), :119 ('das tut nach diesem Zug noch kein
Weg'), :223-225 ('app/haupt.py, app/vorpruefung.py, app/zweckbestimmung.py und
app/einladung_senden.py rufen weiterhin verbindung() und sonst nichts').

SEINE FOLGERUNG BLEIBT TROTZDEM RICHTIG FUER DEN TEILSCHNITT: zweckbestimmung.py gehoert zu M4 und
war ausdruecklich ausgeschlossen (arbeit/Vorlagen/tor3_anforderung_teilschnitt_260816.md:118-122).
Im Teilschnitt selbst setzt kein Weg den Mandanten -- haupt.py:254, 306, 421, 452, 483, 507 nutzen
alle das blanke verbindung(); freiraum.rls_enforce bleibt aus (datenbank.py:214-222).

ZU KURZ beim Objektbezug: der Mandantenbezug steht an mehr Stellen in der WHERE-Bedingung, als er
gefunden hat -- app/vorpruefung.py:446 (fit_check, seine Stelle), aber auch :978 und :1093 ('WHERE
id = %s AND tenant_id = %s') und app/einladung_senden.py:396.

UND DER MASSSTAB STUETZT IHN: das GEZEICHNETE Akzeptanzkriterium in /Users/andi/freiraum-
delivery/nachweise/klauselregister/register.json zaehlt sieben Punkte auf, darunter '(4) der
Serverpfad prueft die Rolle' und '(6) der Serverpfad prueft den Objektbezug'. Es setzt Rolle NICHT
mit Portal-Mitgliedschaft gleich. Das Repo sagt dasselbe wie er:
nachweise/klauselschnitt/S1_zeichnung.md:110 -- 'Drei von fuenf Pruefungen gebaut. Die Rolle wird
nirgends gelesen, sondern per Auslegung mit der Mitgliedschaft gleichgesetzt; ein Objektbezug wird
gar nicht geprueft', Haken noch offen.

**Was die Gegenprobe daran berichtigt hat.**

Die beiden "WIDERLEGT" halten am Quelltext nicht.

(1) "Rolle fehlt" ist NICHT widerlegt. /Users/andi/freiraum-delivery/app/haupt.py:378 lautet 'return
stand["portal"] != PORTAL_VERWALTUNG'. Das ist eine PORTAL-Pruefung, keine Rollenpruefung.
`stand["portal"]` stammt aus portal_bestimmen(), app/sitzung.py:81-85, und dessen SQL liest genau
'SELECT DISTINCT m.portal_code FROM membership m JOIN portal_enabled p ...' -- role_id kommt darin
nicht vor. Der Satz des Fremden ('portal_bestimmen() liest nur m.portal_code, nicht role_id') ist
damit woertlich richtig UND gilt unveraendert fuer _ohne_einladerecht. Es gibt keine uebersehene
Stelle im Teilschnitt, die role_id liest (grep 'role_id' ueber app/: null Treffer). Die Nachrechnung
ersetzt eine Codepruefung durch eine Auslegung und nennt das Widerlegung.

(2) Der als Beleg zitierte Docstring ueberfuehrt sich selbst. app/haupt.py:359-361 behauptet:
'Konto, Mandant und Objektbezug hielt app/sitzung.py laengst -- Mitgliedschaft und Rolle wurden nur
GEZAEHLT, nie GEPRUEFT.' Die Nachrechnung raeumt drei Absaetze spaeter selbst ein, dass es KEINEN
Objektbezug gibt. Sie zitiert also einen Beleg, dessen Nachbarsatz nachweislich falsch ist, ohne das
zu vermerken.

(3) "von keinem vorhandenen Weg benutzt" ist NICHT widerlegt, sondern ausserhalb des Pruefumfangs
erledigt. app/zweckbestimmung.py stand nicht im Belegpaket:
arbeit/Vorlagen/tor3_anforderung_teilschnitt_260816.md:159-172 zaehlt neun Quelltextdateien auf,
zweckbestimmung.py ist nicht darunter und wird in :119-125 ausdruecklich ausgeschlossen. Der Fremde
konnte zweckbestimmung.py:1148 nicht sehen -- er hat nichts uebersehen, ihm wurde es entzogen. Ihm
daraus einen Fehler zu machen und die Selbstauskunft in app/datenbank.py:19-20 als seine Quelle zu
unterstellen, ist unbelegt.

(4) Die Aufwandschaetzung ist an einer Stelle geraten: 'mandantenvorgang um die sechs
verbindung()-Bloecke in app/haupt.py (254, 306, 421, 452, 483, 507)'. haupt.py:254 liegt in
anmeldung_absenden (POST /anmeldung) und haupt.py:306 in einladung_annehmen (POST /einladung) --
dort existiert noch keine Sitzung und kein stand["mandant"]. mandantenvorgang bricht nach
app/datenbank.py:404-416 ohne brauchbaren Mandanten ab. Hoechstens vier der sechs Bloecke kommen
ueberhaupt in Frage; app/datenbank.py:214-222 sagt genau das ('Anmeldung und Einloesung laufen nach
diesem Zug unveraendert').

(5) Die Unsicherheit ist falsch. Die Nachrechnung schreibt: 'Ich habe KEINE Zeichnung gefunden ...
T-4 (M32:233) deckt nur den Stufenwechsel.' Die Zeichnung existiert und liegt ausserhalb von M32:
/Users/andi/freiraum-delivery/arbeit/Vorlagen/m5_teil1_fuenf_ohne_massstab_260819.md, Kopfzeile ':3'
('19.08.2026 · gezeichnet von A. Han'), T-4 in :21, :117-135 und die Zeichnungszeile :191 ('eine
Rolle je Portal — Feststellung, kein eigener Rollenfall'), Unterschrift :196. T-4 haengt an K05-M24
(Aufrufe der Stufen 01/02), nicht am Stufenwechsel, und stuetzt sich auf Rang 0/1
(schema/freiraum_datamodel.sql:685-687, K14-G04, K20-M02, K20-M03). Nach dem eigenen Satz der
Nachrechnung ('Sollte es sie geben ..., faellt der erste Entscheidungspunkt weg') faellt ihr erster
Entscheidungspunkt damit zumindest teilweise.

(6) Das Argument 'kein Messweg, weil der Eigentuemer ⟨nicht benannt⟩ ist' haelt nicht. In derselben
Registerzeile (nachweise/klauselregister/register.json, zeilen[695]) steht im Feld `eigentuemer`:
'Auftragnehmer (Nr. 158), vertreten durch A. Han · gez. A. Han, 16.08.2026'. Die Nachrechnung
uebernimmt eine Textbaustein-Floskel aus dem Kriterium als Tatsache, ohne das Nachbarfeld zu lesen.

(7) Kleiner Fehler derselben Art, die sie dem Fremden bei Grund 2 vorwirft: die Zeichnungsnotiz
steht in M32 auf Zeile 232, nicht 233 (233 ist 'SELECT count(*) INTO v_mitglied').

**Aufwand.** Die Entscheidung selbst: 0 Zeilen. Danach je nach Ausgang: (A) Auslegung 'Rolle = Portal-
Mitgliedschaft' auf den Teilschnitt ausgedehnt -> 0 Zeilen Code, 1 Zeile in
nachweise/klauselschnitt/S1_zeichnung.md:110 plus Traeger/Annahme/Frist in RR-T-084
(nachweise/restrisiken/restrisiken_teilschnitt.json:2634-2663). (B) echte Rollenpruefung verlangt ->
role_id in app/sitzung.py:82-85 mitlesen, in stand fuehren, Riegel setzen: ca. 15-30 Zeilen in 1-2
Dateien. Mandant durchgaengig: mandantenvorgang um die sechs verbindung()-Bloecke in app/haupt.py
(254, 306, 421, 452, 483, 507) und um app/vorpruefung.py: ca. 20-40 Zeilen in 2-3 Dateien;
rls_enforce einschalten ist eine Betriebsentscheidung und haengt laut datenbank.py:214-222
ausdruecklich am Echtdaten-Tor E2. Reiner BAU ohne Entscheidung: die veralteten Selbstauskuenfte in
app/datenbank.py:19-22, :119, :223-225 berichtigen -- ca. 5 Zeilen, 1 Datei.

**Was zu tun ist.**

Ein Mensch muss zwei Dinge festlegen, beide vor dem 31.08.

ERSTENS: Gilt die am 19.08.2026 von A. Han gezeichnete Auslegung T-4 -- 'je Portal genau eine Rolle,
die Mitgliedschaft IST die Rolle' (M32:227-232) -- auch fuer den Teilschnitt bis zur Anmeldung? Sie
ist bisher nur fuer den Stufenwechsel aus M5 gezeichnet. Sagt der Mensch ja, ist Punkt (4) des
gezeichneten Akzeptanzkriteriums durch app/haupt.py:349-378 erfuellt und das Fremdurteil an dieser
Stelle erledigt. Sagt er nein, ist es Bau.

ZWEITENS: Welchen Messweg hat K13-M05 fuer den Teilschnitt? Das gezeichnete Kriterium sagt selbst:
'Messweg, Schwelle und Evidenzform sagt der Wortlaut nicht -- sie ergaenzt nach K23-M02 der
fachliche Eigentuemer, der in dieser Zeile heute ⟨nicht benannt⟩ ist.' Solange dort niemand steht,
ist 'traegt nicht' gegen K13-M05 nicht abschliessend messbar. Konkret zu benennen: der fachliche
Eigentuemer, und ob 'Objektbezug' im Teilschnitt durch die Mandantenbedingung in der Abfrage
(vorpruefung.py:446, 978, 1093; einladung_senden.py:396) erfuellt ist oder eine allgemeine Pruefung
verlangt.

DRITTENS, unabhaengig davon und ohne Entscheidung: RR-T-084 (K13-M05) steht in
nachweise/restrisiken/restrisiken_teilschnitt.json mit 'sperrend_keine_annahme_genuegt: true' und
leeren Feldern fuer Traeger, Annahmeentscheidung und Frist. Genau diese drei Felder fuellt ein
Mensch.

VIERTENS, reiner Bau: app/datenbank.py behauptet an drei Stellen, mandantenvorgang habe keinen
Aufrufer. Das ist seit zweckbestimmung.py:1148 falsch und hat das Fremdmodell in die Irre gefuehrt.
Berichtigen.

---

### Grund 2 · K03-M05

| | |
|---|---|
| **Nachgerechnet** | **BESTÄTIGT** |
| **Einordnung** | **BAU + enge ENTSCHEIDUNG** |
| **Berührt den 31.08.** | **ja** |

**Was das Fremdmodell sagt.** Nur die Sechsstelligkeit des erzeugten Codes wird durchgesetzt; mfa_method = EMAIL_CODE nicht. Die
Anmeldung trimmt die Eingabe nur, prueft sie nicht auf sechs Ziffern, und actor.mfa_method wird beim
Anmelden ueberhaupt nicht gelesen. Das Zielschema laesst auch OFF zu; ein Konto mit OFF und
gueltigem login_code wuerde von diesem Serverpfad nicht wegen der MFA-Methode abgewiesen.
Fundstellen app/anmeldung.py:129-131, 158-166, 206-216, schema/freiraum_datamodel.sql:49, 155.

**Was am Quelltext gemessen ist.**

Jede einzelne Beobachtung stimmt. Die Folgerung geht in einem Punkt zu weit und in einem anderen zu
kurz.

BESTAETIGT: (a) Sechsstelligkeit nur beim Erzeugen -- /Users/andi/freiraum-
delivery/mail/versand.py:50 (CODE_STELLEN = 6) und :114-118 (code_erzeugen). (b) Die Anmeldung
trimmt nur -- /Users/andi/freiraum-delivery/app/anmeldung.py:212, 'eingabe = (code or "").strip()';
nirgends eine Laengen- oder Ziffernpruefung. (c) mfa_method wird beim Anmelden nicht gelesen -- die
SELECT-Abfrage in app/anmeldung.py:128-130 holt nur 'id, status'. STAERKER ALS ER SAGT: 'grep -rn
mfa_method' ueber app/, mail/ und seeds/ liefert NULL Treffer. Das Merkmal kommt im gesamten
Anwendungscode nicht vor; nur in migrations/M30__pilot_sammelmigration.sql:988, 993, 1999, 2385. (d)
Das Schema fuehrt OFF -- bestaetigt, aber die Fundstellen sind je eine Zeile zu tief: der ENUM steht
in schema/freiraum_datamodel.sql:48 (Zeile 49 ist legal_form), die Spalte in :154 (Zeile 155 ist ein
Kommentar). (e) Ein OFF-Konto wuerde von diesem Pfad nicht wegen der Methode abgewiesen --
buchstaeblich richtig.

ZU WEIT: das liest sich wie eine Umgehung, und eine ist es nicht. OFF verschafft niemandem etwas.
app/anmeldung.py:157-176 verlangt in JEDEM Fall einen offenen, nicht abgelaufenen, nicht entwerteten
login_code, dessen SHA-256-mit-Pfeffer stimmt. Ein OFF-Konto muss denselben gemailten
Sechsstellencode vorlegen wie jedes andere -- der Server behandelt OFF strenger, als der ENUM
erlaubt, nicht laxer. Und ein solches Konto gibt es im ausgelieferten Stand nirgends:
/Users/andi/freiraum-delivery/install/01_betreiber_und_erstadmin.sql:99-102 legt den Erst-Admin mit
'EMAIL_CODE' an, seeds/ kennt mfa gar nicht, und migrations/M30:992-993 (actor_ausnahmekonto_uq)
deckelt OFF-Konten datenseitig bei hoechstens einem. Das von ihm beschriebene Konto muesste jemand
unter Umgehung des Serverpfads in die Datenbank schreiben.

ZU KURZ: er haengt den Befund an K03-M05, und dort ist er am schwaechsten -- der Wortlaut ('Der
zweite Faktor MUSS ein sechsstelliger Code per E-Mail sein: mfa_method = EMAIL_CODE. Ein anderes
Verfahren fuehrt das Datenmodell nicht.') beschreibt, was der zweite Faktor IST, und verlangt nicht
ausdruecklich eine Abweisung. Die scharfe Klausel ist K03-D10, RR-T-041 in /Users/andi/freiraum-
delivery/nachweise/restrisiken/restrisiken_teilschnitt.md:124: 'Der zweite Faktor DARF NICHT
abgeschaltet werden. Der abschaltende Wert von mfa_method ist in Release 1 kein zulaessiger
Betriebszustand -- weder am Konto noch am Mandanten.' Gegen die haelt weder der Serverpfad noch das
Schema etwas, und M30 Nr. 59 sieht ausdruecklich EIN solches Konto vor. Diesen Widerspruch loest das
Repo nirgends auf. Er hat das richtige Loch durch die falsche Klausel gefunden.

UND DER MASSSTAB IST NOCH NICHT GESETZT: das Akzeptanzkriterium zu K03-M05 in
nachweise/klauselregister/register.json traegt ⟨VORSCHLAG · NICHT GEZEICHNET⟩. Sein Punkt (3) lautet
'mfa_method traegt den Wert EMAIL_CODE' -- er hat also unwissentlich gegen den ungezeichneten
Vorschlag gemessen und ihn getroffen. Ein bindendes 'nicht durchgesetzt' laesst sich daraus noch
nicht ableiten, weil der Messweg nicht festliegt.

**Was die Gegenprobe daran berichtigt hat.**

Die Einzelmessungen stimmen fast alle -- die beiden Korrekturen am Fremdurteil stimmen nicht.

(1) 'ZU WEIT: das liest sich wie eine Umgehung, und eine ist es nicht' greift einen Satz an, den der
Fremde nicht geschrieben hat. Sein Wortlaut lautet: 'ein Konto mit OFF und GUELTIGEM login_code
wuerde von diesem Serverpfad nicht wegen der MFA-Methode abgewiesen'. Er setzt den gueltigen Code
selbst voraus und behauptet genau das, was app/anmeldung.py:128-130 zeigt: die Abfrage holt 'id,
status' und sonst nichts. Es gibt nichts zu entschaerfen.

(2) 'ZU KURZ ... er hat das richtige Loch durch die falsche Klausel gefunden' wird von der Quelle
widerlegt, aus der die Nachrechnung selbst zitiert. Sie zitiert
nachweise/klauselschnitt/S1_zeichnung.md:110 fuer K13-M05, laesst aber :108 aus derselben Tabelle
weg. Dort steht zu K03-M05: 'Der schwerste Fall. app/haupt.py beansprucht die Regel, aber kein
Programmschritt dieser Datei erzeugt, prueft oder versendet einen Code. app/einladung.py loest den
Versand aus, legt aber weder Sechsstelligkeit noch Mailweg noch mfa_method = EMAIL_CODE fest.' Das
Repo haengt exakt diese Luecke an K03-M05. Die Empfehlung, den Befund von K03-M05 weg auf K03-D10
umzuhaengen, ist damit nicht gedeckt -- K03-D10 kommt hinzu, ersetzt nicht. Dasselbe sagt der
Bildschirmvertrag im Belegpaket: schema/K19_screens.yaml:629 ('actor.mfa_method = EMAIL_CODE,
K03-M05').

(3) 'fundstellen_stimmen: false' ist unverhaeltnismaessig und die Nachrechnung begeht denselben
Fehler. Richtig ist die Verschiebung um eine Zeile: der ENUM steht auf
schema/freiraum_datamodel.sql:48, die Spalte auf :154. Die drei uebrigen Fundstellen des Fremden
(anmeldung.py:129-131, 158-166, 206-216) sind zeilengenau. Zugleich schreibt die Nachrechnung selbst
'install/01_betreiber_und_erstadmin.sql:101' fuer EMAIL_CODE -- :101 ist 'FROM tenant t', der Wert
steht auf :100. Und der Satz 'Das Merkmal kommt im gesamten Anwendungscode nicht vor; nur in
migrations/M30:988, 993, 1999, 2385' ist zu eng: mfa_method steht ausserdem in install/01:96,
schema/freiraum_datamodel.sql:127, :154, :852 und schema/K19_screens.yaml:629. (Die vier M30-Zeilen
selbst sind exakt.)

(4) Zu kurz gegen die Klausel, die sie selbst vorschlaegt. K03-D10 sagt 'weder am Konto NOCH AM
MANDANTEN'. Die Mandantenseite hat die Nachrechnung nicht nachgesehen:
schema/freiraum_datamodel.sql:127 fuehrt 'mfa_policy mfa_method NOT NULL DEFAULT EMAIL_CODE' --
derselbe ENUM, also auch dort OFF moeglich, und 'mfa_policy' kommt in app/, mail/ und seeds/
ebenfalls nirgends vor. Das verschaerft den Befund, den sie abschwaechen wollte.

(5) Positiv anzumerken, damit es nicht untergeht: die Aufwandschaetzung ist hier plausibel und nicht
geraten -- der Hinweis, die Pruefung muesse in 'tragfaehig = False' laufen statt frueh
zurueckzukehren, ist am Zeitseitenkanal-Vermerk app/anmeldung.py:132-141 belegt und richtig.

**Aufwand.** Nach der Entscheidung sehr klein. mfa_method in die SELECT-Abfrage app/anmeldung.py:128-130
aufnehmen und in die Bedingung app/anmeldung.py:149-150 einhaengen: ca. 3 Zeilen, 1 Datei. WICHTIG:
es muss im bestehenden Zweig 'tragfaehig = False' landen und darf NICHT frueh zurueckkehren -- sonst
reisst der Zeitseitenkanal wieder auf, den app/anmeldung.py:132-141 ausdruecklich beschreibt und der
am 10.08.2026 gemessen wurde. Sechsstelligkeitspruefung der Eingabe: ca. 2 Zeilen bei
app/anmeldung.py:212, aus demselben Grund ebenfalls ohne Kurzschluss; das ist reine Haertung ohne
Verhaltensaenderung, weil eine Eingabe anderer Laenge den Hash ohnehin nie trifft. Dazu ein
Prueffall in pruefungen/klauseln/. Insgesamt unter 10 Zeilen in 1 Datei plus Prueffall.

**Was zu tun ist.**

Ein Mensch muss den Widerspruch aufloesen, bevor gebaut wird. Er ist echt und steht im Repo:

  * K03-D10 (RR-T-041): OFF ist in Release 1 kein zulaessiger Betriebszustand -- weder am Konto noch
am Mandanten.
  * migrations/M30__pilot_sammelmigration.sql:988-993 (Nr. 59): sieht GENAU EIN Ausnahmekonto mit
mfa_method = OFF vor und sichert es mit einem eindeutigen Index ab.

ZU ENTSCHEIDEN: Faellt das Ausnahmekonto Nr. 59 fuer Release 1 weg (dann weist der Anmeldepfad
mfa_method <> 'EMAIL_CODE' ab und M30:992-993 gehoert zurueckgenommen), oder bleibt es (dann ist
K03-D10 fuer dieses eine versiegelte Konto ausgenommen, und diese Ausnahme gehoert gezeichnet --
nicht stillschweigend geduldet). Heute gilt weder das eine noch das andere: der Erst-Admin wird
ohnehin mit EMAIL_CODE angelegt (install/01_betreiber_und_erstadmin.sql:101), das Ausnahmekonto ist
also vorgesehen, aber unbenutzt.

ZWEITENS zu entscheiden: das Akzeptanzkriterium zu K03-M05 zeichnen oder verwerfen. Solange es
⟨VORSCHLAG · NICHT GEZEICHNET⟩ traegt und der fachliche Eigentuemer in der Zeile ⟨nicht benannt⟩
ist, gibt es keinen Massstab, gegen den 'vollstaendig durchgesetzt' entschieden werden koennte.

DANACH ist es Bau, und zwar kleiner Bau -- siehe Aufwand. Ich empfehle, ihn nicht an K03-M05 zu
haengen, sondern an K03-D10: dort steht der Satz, den der Code heute nicht haelt.

---

### Grund 3 · K03-G01

| | |
|---|---|
| **Nachgerechnet** | **TEILWEISE** |
| **Einordnung** | **BAU (tragender Teil) + ENTSCHEIDUNG** |
| **Berührt den 31.08.** | **ja** |

**Was das Fremdmodell sagt.** Sperren ohne den verursachenden Grund; bei fehlendem Versandweg gilt der Link weiter, der Nutzer
liest das Gegenteil. Fundstellen app/anmeldung.py:60-62, 167-181, 206-216; app/haupt.py:258-262;
app/einladung.py:104-107, 377-447, 415-426; app/vorpruefung.py:987-991, 1110-1118.

**Was am Quelltext gemessen ist.**

Drei Teilbeobachtungen, drei verschiedene Ergebnisse.

(1) EINE MELDUNG BEIM ANMELDEN — STIMMT, IST ABER KEIN BRUCH. /Users/andi/freiraum-
delivery/app/anmeldung.py:35 fuehrt MELDUNG_MISSERFOLG = "Anmeldung nicht moeglich. Pruefen Sie
Adresse und Code." Zeile 166-176 buendelt tatsaechlich falschen, abgelaufenen, verbrauchten,
entwerteten und fehlenden Code sowie unbekanntes, mehrdeutiges und gesperrtes Konto in EINEN Zweig;
Zeile 178-180 nimmt das fehlende Portal dazu; /Users/andi/freiraum-delivery/app/haupt.py:257-261
zeigt genau diesen einen Satz. Beobachtung bestaetigt. Die Folgerung geht jedoch zu weit: dieselbe
Ununterscheidbarkeit ist von K03-M16 ausdruecklich VERLANGT ("ohne die Existenz eines Kontos
preiszugeben"), und der Bau hat den Zweig am 10.08.2026 sogar noch weiter zusammengezogen, weil der
frueher getrennte Abbruch ueber die Laufzeit messbar war (Kommentar anmeldung.py:120-140,
_KEIN_KONTO in Zeile 41). Der Fremde wertet einen Klauselkonflikt als einseitigen Verstoss, ohne die
Gegenklausel zu nennen.

(2) FEHLENDER VERSANDWEG — VOLL BESTAETIGT, UND ES IST DER EINZIGE SACHLICH FALSCHE SATZ.
/Users/andi/freiraum-delivery/app/einladung.py:426-430: versandweg_fehlt() liefert Gruende, es wird
protokolliert und `return False` — die Einladung wird NICHT verbraucht, der Link traegt weiter.
/Users/andi/freiraum-delivery/app/haupt.py:309-314 knuepft an False MELDUNG_EINLADUNG = "Dieser
Einladungslink gilt nicht mehr. Bitte fordern Sie einen neuen an." (einladung.py:105-106). Der
Nutzer liest damit woertlich das Gegenteil des Zustands. Der Quelltext benennt das selbst und im
Wortlaut in einladung.py:414-425 ("Falsch ist der SATZ, den app/haupt.py an False knuepft ... Ob sie
gebaut wird, entscheidet ein Mensch") und in der Kopfzeile Zeile 2 sowie 35-54. Erreichbar ist der
Fall real: mail/versand.py:189-217 schlaegt an, wenn FREIRAUM_SMTP_HOST fehlt (ausserhalb 'lokal')
oder die Absenderdomaene nicht passt.

(3) MELDUNG_ERGEBNIS_UNKLAR IN DER VORPRUEFUNG — WIDERLEGT. Der Fremde zaehlt sie unter "Sperren
ohne den verursachenden Grund". Am Code ist es anders: /Users/andi/freiraum-
delivery/app/vorpruefung.py:279-282 lautet "Der Stand dieses Eignungs-Checks laesst sich zurzeit
nicht sicher lesen. Aus Vorsicht wurde nichts geaendert. Das liegt nicht an Ihren Angaben. Bitte
wenden Sie sich an Ihre Ansprechperson." Das ist eine begruendete Sperranzeige derselben Bauart wie
MELDUNG_BETRIEB (haupt.py:180-182), die der Fremde selbst als K03-G01-konform gelten laesst — nur
ohne Betriebsangabe. Die Stellen 989-990 und 1116-1117 sind korrekt zitiert, die Einordnung als
"ohne Grund" trifft nicht zu.

GEGENPROBE ZUR BEHEBBARKEIT: Der Bauplan fuer Fall (2) liegt im Repo schon zweimal fertig vor —
MELDUNG_BETRIEB (haupt.py:180-182, 503) und MELDUNG_VERSANDWEG (/Users/andi/freiraum-
delivery/app/einladung_senden.py:184-187, im Versandpfad in Zeile 766 bereits benutzt). Beide nennen
einen Betriebsgrund, ohne etwas ueber ein Konto zu sagen. Der Einwand, ein Grund waere hier ein
Orakel, traegt beim fehlenden Versandweg gerade NICHT: die Bedingung haengt an der Umgebung, nicht
am Token.

**Was die Gegenprobe daran berichtigt hat.**

VIER BEFUNDE.

(A) TEIL (1) IST ZU BEQUEM WEGGEWERTET. Die Nachrechnung nennt die eine Meldung beim Anmelden "kein
Bruch" und laesst von zwoelf Zeilen des Fremdurteils nur eine tragen. Der eigene Bau sagt an drei
Stellen das Gegenteil: /Users/andi/freiraum-delivery/app/einladung.py:2 ("zur Haelfte umgesetzt:
K03-G01"), :35-40 ("K03-G01 IST HIER HALB GEBAUT ... Die zweite ist NICHT gebaut: der Nutzer bekommt
MELDUNG_MISSERFOLG, und der Satz nennt keinen Grund"), nachweise/klauselschnitt/S1_zeichnung.md:107
(Haken OFFEN, Spalte 'Was fehlt': "die Sperre wird nur in EINEM Fall begruendet angezeigt ... In
zwei weiteren Faellen wird der Grund bewusst verschwiegen") und
nachweise/klauselschnitt/S1_bauspur_nachpruefung.md:36-48 (K03-G01 in haupt.py "teilweise", in
einladung.py "teilweise"). Der Satz des Fremden "Sperren ohne den verursachenden Grund" IST dieses
Eingestaendnis. Er ist bewusst und begruendet offen, aber er ist nicht "kein Bruch".

(B) DIE GEGENKLAUSEL IST UEBERDEHNT. K03-M16 lautet im Register woertlich
(nachweise/klauselregister/register.json, Herkunft 260802_FREIRAUM_K03_Anmeldung_v1.3.md:276): "Nach
fuenf falschen Codes wird der Code ungueltig; weitere Versuche werden fuer 15 Minuten gedrosselt.
Konto- und Netzgrenzen werden gemeinsam ausgewertet, ohne die Existenz eines Kontos preiszugeben."
Sie verbietet die Kontoauskunft — sie VERLANGT keine Sperre ohne jeden Grund. app/haupt.py:180-182
beweist das im selben Haus: MELDUNG_BETRIEB nennt einen Grund und sagt ueber ein Konto nichts. Die
Nachrechnung legt an den Fremden einen Wortlautmassstab an, den sie an ihre eigene Gegenklausel
nicht anlegt; register.md:305 fuehrt K03-M16 zudem ohne Eigentuemer, ohne Kritikalitaet und ohne
Akzeptanzkriterium.

(C) DIE EINORDNUNG DES TRAGENDEN TEILS IST FALSCH. Die eigene Meldung fuer den fehlenden Versandweg
ist im selben Bau bereits GEBAUT und IN GEBRAUCH: MELDUNG_VERSANDWEG in
app/einladung_senden.py:184-187, benutzt in Zeile 766 — ohne Zeichnung, ohne Umgebungswert im Text,
ohne Kontoaussage. Die Nachrechnung sieht das selbst ("der Bauplan liegt im Repo schon zweimal
fertig vor") und widerlegt den Sperrgrund selbst ("die Bedingung haengt an der Umgebung, nicht am
Token") — legt die Sache aber trotzdem einem Menschen bis zum 31.08. vor. Damit wird eine Bauaufgabe
geparkt, deren identische Fassung drei Dateien weiter seit dem 14.08.2026 laeuft.

(D) MASSSTAB UNGLEICH BEI DEN FUNDSTELLEN. "fundstellen_stimmen: false" haengt allein an
app/anmeldung.py:60-62 — dort steht wirklich nur das Ende des Docstrings und `return streuwert(code,
CODE_PFEFFER)`; der Verweis auf 33-35 ist richtig. Die uebrigen Bereiche des Fremden sind durchweg
um eine Zeile verschoben und umschliessen den Text (166-176 gegen 167-181, 178-180, 257-261,
105-106, 426-430) — dieselbe Art Verschiebung wird bei Grund 4 als "stimmt" durchgewinkt.

WAS ICH GEGENGEPRUEFT UND BESTAETIGT HABE: Teil (2) traegt vollstaendig (einladung.py:426-430 return
False ohne Verbrauch, haupt.py:309-314 knuepft daran MELDUNG_EINLADUNG aus einladung.py:105-106;
erreichbar ueber mail/versand.py:189-217). Teil (3) ist zu Recht widerlegt, und staerker als
argumentiert: der Kopf von app/vorpruefung.py:1-2 beansprucht K04-M05 bis K04-G06 und K13-M05, nie
K03-G01; die Sperren in 989-990 und 1116-1117 messen gegen K04-G04, und MELDUNG_ERGEBNIS_UNKLAR
(279-282) nennt einen Grund. beruehrt_31_08 = true ist belegt
(nachweise/meldungen/VERZUG_260814.md:71-80: Teilschnitt = Mandant · Einladungsschranke · Einladung
ueber den echten Mailweg · Anmeldecode · Anmeldung). Der Aufwand ist plausibel: einloesen() hat
genau einen Aufrufer (app/haupt.py:307).

**Aufwand.** Nach der Entscheidung klein und eng begrenzt: 2 Dateien im Bau. app/einladung.py — eine
Meldungskonstante nach dem Vorbild von einladung_senden.py:184-187 und ein unterscheidbarer
Rueckgabewert aus einloesen() fuer den Versandweg-Fall (ca. 10-14 Zeilen, betrifft die Kopfvermerke
Zeile 2 und 35-54, die dann nachzuziehen sind). app/haupt.py:309-314 — ein Zweig, der diesen Fall
auf die eigene Meldung legt (ca. 4-6 Zeilen). Dazu ein Prueffall beim Pruef-Agenten unter
pruefungen/klauseln/ (schreibt der Bau nicht). Fuer (1) und (3) ist gar nichts zu bauen.

**Was zu tun ist.**

ZU ENTSCHEIDEN HAT EIN MENSCH GENAU EINEN SATZ, und die Frage steht seit dem 14.08.2026 im Quelltext
(app/einladung.py:414-425) sowie als offener Haken in nachweise/klauselschnitt/S1_zeichnung.md:107
und ausformuliert in nachweise/klauselschnitt/S1_bauspur_nachpruefung.md:40-48:

FRAGE: Bekommt der Nutzer beim fehlenden Versandweg auf /einladung eine EIGENE Meldung — Vorschlag
im Wortlaut analog app/einladung_senden.py:184-187: "Die Anmeldung ist zurzeit nicht moeglich, weil
der Dienst keinen Mailweg hat. Ihr Link bleibt gueltig, es wurde nichts geaendert, und es liegt
nicht an Ihren Angaben. Bitte verstaendigen Sie den Betrieb." — oder bleibt es bei
MELDUNG_MISSERFOLG?

ENTSCHEIDER: der fachliche Eigentuemer von K03-G01. Das Klauselregister
(nachweise/klauselregister/register.md:261) weist die Klausel dem Auftragnehmer (Nr. 158), vertreten
durch A. Han, zu; Kritikalitaet und Akzeptanzkriterium stehen dort ausdruecklich als ⟨VORSCHLAG ·
NICHT GEZEICHNET⟩. Termin: vor dem 31.08., weil K03-G01 im Teilschnitt liegt.

WAS BEI JA ZU BAUEN IST: siehe Aufwand. WAS BEI NEIN ZU TUN IST: die Auflage schriftlich zeichnen,
damit der Stand nicht als unbemerkter Fehler durchgeht — der Satz bleibt dann wissentlich falsch.

UNABHAENGIG DAVON ZU BERICHTIGEN (reiner Vermerkfehler, kein Verhalten): app/einladung.py:51-54
behauptet, app/haupt.py fuehre K03-G01 "ganz". Das trifft nicht zu — haupt.py begruendet die Sperre
nur im Datenbankausfall (Zeile 161, 180-182), nicht bei fehlendem Einladerecht und nicht beim
Rueckwurf auf die Anmeldemaske. Der Widerspruch steht bereits gemessen in
nachweise/klauselschnitt/S1_bauspur_nachpruefung.md:40.

DEM MENSCHEN IST AUSSERDEM ZU SAGEN, dass Teil (3) des Grundes am Code nicht zutrifft und Teil (1)
die Gegenklausel K03-M16 nicht wuerdigt. Von zwoelf Zeilen dieses Grundes traegt eine — sie traegt
allerdings vollstaendig.

---

### Grund 4 · K03-M25

| | |
|---|---|
| **Nachgerechnet** | **BESTÄTIGT** |
| **Einordnung** | **ENTSCHEIDUNG + BAU am Wortlaut** |
| **Berührt den 31.08.** | **ja** |

**Was das Fremdmodell sagt.** Fehlermeldungen geben den Kontobestand preis. Fundstellen app/einladung_senden.py:176-179
(MELDUNG_MEHRDEUTIG) und 181-183 (MELDUNG_GLEICHZEITIG); dazu der Vermerk, die fruehere
Fremdmandantenmeldung sei entfernt (165-174). Schluss: "Damit ist die Nicht-Offenbarung nicht
erfuellt."

**Was am Quelltext gemessen ist.**

Beide Meldungen stehen im Wortlaut an den genannten Stellen von /Users/andi/freiraum-
delivery/app/einladung_senden.py: MELDUNG_MEHRDEUTIG in Zeile 175-178, MELDUNG_GLEICHZEITIG in Zeile
180-182. Die Entfernung von MELDUNG_FREMDER_MANDANT ist in Zeile 164-173 als Kommentar belegt. Beide
zitierten Bereiche umschliessen den jeweiligen Text vollstaendig.

ZU MELDUNG_MEHRDEUTIG — Beobachtung stimmt, Reichweite kleiner als gedacht. Ausgeloest wird sie in
Zeile 400-404, und die davorstehende Abfrage (Zeile 396-400) sucht seit dem 14.08.2026 NUR noch im
eigenen Mandanten: "SELECT id FROM actor WHERE lower(email) = %s AND tenant_id = %s". Sie schlaegt
also nur an, wenn im Mandanten der Sitzung zwei Konten stehen, die sich allein in der
Gross-/Kleinschreibung unterscheiden. Adressat ist ein angemeldeter Verwaltender mit Einladerecht
(app/haupt.py:456-464). Das ist eine Auskunft ueber den EIGENEN Bestand an einen dazu Berechtigten —
die Enumeration, gegen die K03-M25 schuetzt, ermoeglicht sie nicht.

ZU MELDUNG_GLEICHZEITIG — hier traegt der Grund, aber aus einem staerkeren Grund, als der Fremde
nennt. Er argumentiert nur ueber den Wortlaut ("Zu diesem Konto ..."). Die eigentliche Preisgabe
steht im Quelltext selbst und er hat sie uebersehen: einladung_senden.py:366-378 haelt fest, dass
ein Konto in einem FREMDEN Mandanten seit dem Wegfall des Fremdmandanten-Zweigs in die Neuanlage
laeuft, dort auf die zeichengenaue, plattformweite Eindeutigkeit auf actor.email faellt und als
UniqueViolation genau in MELDUNG_GLEICHZEITIG endet (Ausnahmezweig Zeile 776-781). Woertlich: "ein
Aufrufer kann Erfolg und Abweisung immer noch unterscheiden." Ich habe die Eindeutigkeit im
Zielschema nachgesehen: /Users/andi/freiraum-delivery/schema/freiraum_datamodel.sql:152 fuehrt
`email text NOT NULL UNIQUE` — plattformweit, nicht je Mandant (bestaetigt in
nachweise/uebergabe_n2/n2_belege_260806_1410/schema_nach_lauf1.sql:2990: `ADD CONSTRAINT
actor_email_key UNIQUE (email)`). Der Unterschied ist von aussen sichtbar: Erfolg endet in 303 auf
"/einladung/senden?gesendet=1" (app/haupt.py:474-476), Abweisung in 200 mit Meldung
(app/haupt.py:466-472). Damit unterscheidet die Antwort messbar zwischen "an dieser Adresse gibt es
irgendwo auf der Plattform ein Konto" und "gibt es nicht" — genau die Aussage, die K03-M25
verbietet.

FOLGE FUER DIE MESSUNG: Der dafuer gebaute Prueffall VE-09 (/Users/andi/freiraum-
delivery/pruefungen/klauseln/versand_lauf.sh:483-535) misst differentiell fremdmandant@pruef.example
gegen niemals-existent@pruef.example und vergleicht Statuscode, Location-Ziel, Zeilenentstehung und
Wortlaut. Nach dem Code muss er rot sein (200 + Meldung gegen 303 + Location, und keine invitation-
Zeile gegen eine). Eine Laufausgabe zu VE-09 liegt im Repo nicht.

DER KLAUSELWORTLAUT ist unbedingt formuliert: "Fehlermeldungen verraten nicht, ob es ein Konto zu
der Adresse gibt" (nachweise/klauselschnitt/S1_leseblaetter.md:599; Teilaussage (8) im
Akzeptanzvorschlag, nachweise/klauselregister/register.md:325). Er unterscheidet nicht nach
Adressat. Der Schluss des Fremden — Nicht-Offenbarung nicht erfuellt — traegt damit.

**Was die Gegenprobe daran berichtigt hat.**

VIER BEFUNDE, kein Widerspruch zum Urteil selbst.

(A) DIE TRAGENDE FUNDSTELLE FEHLT — UND SIE IST DIE ENTSCHEIDUNGSVORLAGE SELBST.
/Users/andi/freiraum-delivery/arbeit/Vorlagen/entscheidung_einladung_mandantengrenze_260814.md (217
Zeilen, vom 14.08.2026, ungezeichnet) behandelt genau diese Konstellation. Abschnitt 2.5 stellt den
Befund im Wortlaut fest: "Die angezeigte Meldung ist allerdings die fuer 'zeitgleich eine andere
Einladung' (app/einladung_senden.py:180) — sie trifft den Fall nicht." Abschnitt 5 Nr. 4 fuehrt
bereits "Die Einmaligkeit der Adresse ist eine schwere fachliche Festlegung ohne Klausel" (:152).
Abschnitt 7 traegt drei Kreuze — Lesart A, Lesart B, Vertagung — alle leer. Die Nachrechnung kennt
dieses Blatt nicht und stellt die Frage neu.

(B) DER ERSATZANKER IST DIE FALSCHE KLAUSEL UND EIN NICHT EINGETRAGENES BLATT.
nachweise/klauselregister/M5_ergaenzungen_nachtrag10_260819.json:8 traegt den zitierten Satz
woertlich — aber unter dem Schluessel "K03-M03", nicht K03-M25, und das Feld "grund" desselben
Objekts sagt: "dies ist der M5-Ersatzvorschlag der Gegenprobe, NICHT EINGETRAGEN". "Im Repo bereits
als offen ausgewiesen und wartet nur auf die Zeichnung" trifft damit auf diesen Beleg nicht zu.

(C) ENTSCHEIDER ZU ENG UND ZU SCHMAL GEFASST. Die Nachrechnung schickt die Frage an A. Han allein
(register.md:325). Die vorliegende Vorlage verlangt je ein Kreuz von M. Veil UND A. Han und stellt
eine weitere Frage als "plattformweit oder je Mandant": Lesart A (Zielmandant wird Pflichtargument)
gegen Lesart B (Grenze bleibt zu, eigener Sperrgrund) gegen Vertagung.

(D) DER AUFWAND IST GERATEN UND VOM REPO WIDERLEGT. Dasselbe Blatt schaetzt Weg A auf 12 halbe Tage
zuzueglich ausdruecklich nicht schaetzbarer Posten (Zeilenschutz/RLS aus O-K13-1, Betreiberprotokoll
K02-M21, invitation_decision, Domaenenvergleich, Migrationsnachtrag mit neuer Pruefsumme auf
schema/freiraum_datamodel.sha256) und Weg B auf 4 halbe Tage. "Eine neue Migrationsdatei, Anpassung
von _konto_sichern, VE-09 und Seed" unterschlaegt zudem die Sache selbst: eine Eindeutigkeit je
Mandant schliesst das Orakel nur, weil dieselbe Person dann ein ZWEITES Konto im Sitzungsmandanten
bekommt — das ist die fachliche Frage der Vorlage, kein Migrationsdetail.

(E) FUNDSTELLEN-MASSSTAB. "fundstellen_stimmen: true" ist grosszuegig: die Bereiche des Fremden
liegen je eine Zeile daneben (tatsaechlich 175-178, 180-182, 164-173 gegen zitierte 176-179,
181-183, 165-174). Auch eigene Angaben rutschen: die Abfrage steht in 394-398 (nicht 396-400),
_konto_sichern beginnt in Zeile 308 (nicht 396), der VE-09-Block endet in 537 (nicht 535).

WAS ICH NACHGERECHNET UND BESTAETIGT HABE: mandantengebundener SELECT 394-398; MELDUNG_MEHRDEUTIG
175-178, ausgeloest 400-404; MELDUNG_GLEICHZEITIG 180-182; Entfernungsvermerk 164-173; Neuanlage
414-417; UniqueViolation-Zweig 777-781; Selbstmeldung des Quelltextes 365-375 ("ein Aufrufer kann
Erfolg und Abweisung immer noch unterscheiden"); schema/freiraum_datamodel.sql:152 `email text NOT
NULL UNIQUE`; schema_nach_lauf1.sql:2990; 200-mit-Meldung gegen 303-auf-gesendet=1 in
app/haupt.py:466-476; Adressat mit Einladerecht 456-464; VE-09 in
pruefungen/klauseln/versand_lauf.sh:483-537, und im Repo liegt tatsaechlich keine Laufausgabe dazu
(die Manifeste in nachweise/manifeste/ fuehren nur Pruefsummen). beruehrt_31_08 = true ist belegt:
der Teilschnitt nach VERZUG_260814.md:77-80 umfasst die Einladung ueber den echten Mailweg.

**Aufwand.** Zwei Haelften mit sehr ungleichem Aufwand.

BAUBAR OHNE ENTSCHEIDUNG (Kosmetik, schliesst die Luecke NICHT): Wortlaut von MELDUNG_MEHRDEUTIG und
MELDUNG_GLEICHZEITIG neutralisieren, so dass kein Konto benannt wird — 1 Datei,
/Users/andi/freiraum-delivery/app/einladung_senden.py:175-182, ca. 6 Zeilen. Der Unterschied 200/303
bleibt und damit das Orakel; VE-09 bliebe rot.

NICHT OHNE ENTSCHEIDUNG BAUBAR (schliesst die Luecke): Der Traeger ist `UNIQUE (email)` in
schema/freiraum_datamodel.sql:152. Eine Eindeutigkeit je Mandant ist eine Aenderung am gezeichneten
Datenmodell (Rang 1 nach CLAUDE.md Abschn. 1) und damit ein Migrationsnachtrag mit eigenen
Negativfaellen — Groessenordnung: eine neue Migrationsdatei, Anpassung von _konto_sichern
(einladung_senden.py:396-420), Nachziehen von VE-09 und der Seed-Lage in
pruefungen/klauseln/versand_daten.sql. Der Bau-Agent darf das nicht von sich aus tun; der Quelltext
meldet es selbst als offenen Punkt (einladung_senden.py:373-378).

**Was zu tun ist.**

ZU ENTSCHEIDEN SIND ZWEI DINGE, beide von einem Menschen, beide vor dem 31.08.:

(A) GELTUNGSBEREICH DER ADRESS-EINDEUTIGKEIT. Plattformweit (heutiges gezeichnetes Modell,
schema/freiraum_datamodel.sql:152) oder je Mandant? Solange sie plattformweit ist, ist die Existenz
eines Kontos in einem fremden Mandanten von aussen ableitbar und K03-M25 Teilaussage (8) nicht
erfuellt — daran aendert kein Wortlaut etwas. Diese Frage ist im Repo bereits als offen ausgewiesen
und wartet nur auf die Zeichnung: nachweise/klauselregister/M5_ergaenzungen_nachtrag10_260819.json:8
sagt woertlich "In welchem Geltungsbereich die Adresse eindeutig ist — plattformweit oder je
Mandant, im Licht von K03-M19 — und mit welcher Meldung die Ablehnung gezeigt wird, sagt der
Wortlaut nicht; das ergaenzt nach K23-M02 der fachliche Eigentuemer." Entscheider fuer K03-M25 nach
nachweise/klauselregister/register.md:325: Auftragnehmer (Nr. 158), vertreten durch A. Han; die
Kritikalitaet (sicherheits- UND wiederherstellungskritisch) steht dort als ⟨VORSCHLAG · NICHT
GEZEICHNET⟩, und nachweise/restrisiken/restrisiken_teilschnitt.md:135 fuehrt RR-T-052 mit ⛔.

(B) REICHT DIE NICHT-OFFENBARUNG GEGENUEBER EINEM BERECHTIGTEN VERWALTENDEN IM EIGENEN MANDANTEN?
Nur davon haengt MELDUNG_MEHRDEUTIG ab. Sagt der Eigentuemer ja, faellt dieser Teil des Fremdurteils
weg und bleibt allein (A) offen; sagt er nein, ist auch der Wortlaut zu neutralisieren.

SOFORT UND OHNE ENTSCHEIDUNG ZU TUN: VE-09 einmal laufen lassen (/Users/andi/freiraum-
delivery/pruefungen/klauseln/versand_lauf.sh:483-535). Nach der Aktenlage muss er rot sein; er ist
am 14.08.2026 als "behoben, aber bislang ungemessen" angelegt worden und im Repo liegt bis heute
keine Ausgabe dazu. Ein roter VE-09 ist der harte Beleg fuer (A) und macht aus einer Auslegungsfrage
eine Messung. Faellt er wider Erwarten gruen aus, ist zuerst zu klaeren, warum — dann stimmt
entweder mein Schluss oder der Prueffall nicht.

DEM MENSCHEN IST ZU SAGEN: Der Fremde hat richtig geurteilt, aber die schwaechere der beiden Stellen
begruendet. Die tragende Stelle steht seit dem 14.08. im eigenen Quelltext und ist dort als offener
Punkt vermerkt — sie war also belegbar, ohne dass ein Fremdmodell sie finden musste.

---

### Grund 5 · K03-M26

| | |
|---|---|
| **Nachgerechnet** | **TEILWEISE** |
| **Einordnung** | **ENTSCHEIDUNG** |
| **Berührt den 31.08.** | **ja** |

**Was das Fremdmodell sagt.** Kein Secret-Handling über verwaltete Identität, keine Alarmierung mit Runbook-Verweis; mail_delivery
speichert die vollständige Adresse. Fundstellen mail/versand.py:70-79, 126-137, 221-226, 536-552.

**Was am Quelltext gemessen ist.**

Der Klauselwortlaut (nachweise/restrisiken/restrisiken_teilschnitt.json, RR-T-053): 'Der Versand
nutzt verwaltete Identität oder Secret-Referenz, eine erlaubte Ausgangsverbindung und datensparsame
Telemetrie. Codes und vollständige E-Mail-Adressen stehen nie in Logs. Providerfehler, fehlender
Nachweis oder unklare Konfiguration wirken fail-closed und alarmieren den Betrieb mit Runbook-
Verweis.' Vier Teilaussagen einzeln nachgerechnet:

(1) VERWALTETE IDENTITÄT — BESTÄTIGT. /Users/andi/freiraum-delivery/mail/versand.py:72-73 liest
SMTP_USER und SMTP_PASS unmittelbar aus os.environ, ohne jede Indirektion. Zeile 133-134 im
Docstring von pfeffer() sagt es selbst: 'spaeter aus dem Schluesseltresor ueber die verwaltete
Identitaet'. Dieselbe Zukunftsform steht in app/datenbank.py:93-94 ('Spaeter kommen Pfeffer und
Sitzungsschluessel aus dem Schluesseltresor ueber die verwaltete Identitaet'). Ich habe das ganze
Repo gegen managed.identity|verwaltete
Identit|key.?vault|Schluesseltresor|DefaultAzureCredential|secret.?ref durchsucht: außerhalb von
Doku, Plänen und Nachweisblättern gibt es keine einzige Codestelle. Nicht gebaut, nirgends.
  Präzisierung, die seinen Punkt nicht schwächt: 126-137 ist der Docstring von pfeffer() und handelt
vom CODE-PFEFFER, nicht vom SMTP-Kennwort. Er zieht zwei verschiedene Geheimnisse in einen Satz. Der
Schluss gilt für beide.

(2) ERLAUBTE AUSGANGSVERBINDUNG — BESTÄTIGT (er sagt selbst nur 'teilweise'). versand.py:70 erzwingt
einen gesetzten SMTP_HOST, :76 setzt TLS außerhalb 'lokal' auf an, :189-217 versandweg_fehlt() prüft
Host und Absenderdomäne. Eine Egress-Allowlist auf Netzebene existiert im Repo nicht.

(3) DATENSPARSAME TELEMETRIE / mail_delivery — BEOBACHTUNG BESTÄTIGT, FOLGERUNG GEHT ZU WEIT.
versand.py:220-226 fügt recipient=empfaenger unmaskiert ein, und M30:292 (recipient text NOT NULL)
speichert ihn im Klartext. Das ist wörtlich richtig. Aber: mail_delivery ist kein Log und keine
Telemetrie — es ist der append-only Zustellnachweis, den Bauauftrag B2 ausdrücklich verlangt
(versand.py:16-19, app/einladung.py:335-338), gegen UPDATE/DELETE durch mail_delivery_append_only
gesperrt (M30:315-317). Der Klauselsatz, den er meint ('stehen nie in Logs'), zielt auf Logs; die
Datensparsamkeit des Nachweises ist über retention_class = KURZFRIST geregelt, 30 Tage, mit
Rechtsgrundlage (M30:123-130, :299, :1548-1553). Diese Gegenbelege nennt er nicht. Ob ein append-
only Nachweis 'Telemetrie' im Sinne der Klausel ist, sagt der Wortlaut nicht — das ist eine
Auslegung, keine Messung.

(4) KEINE ADRESSEN IN LOGS / ALARMIERUNG — BESTÄTIGT. Das Kommandozeilenwerkzeug gibt die volle
Adresse dreimal aus: versand.py:535-536 (SystemExit 'Kein Konto zu {a.an}'), :541 (print 'Code an
{a.an} uebergeben'), :551 (print 'Einladung an {a.an} uebergeben'). Seine Angabe '552' ist um eins
daneben — 552 ist 'return 0' —, die Stelle ist 551. Der Serverpfad hält sich dagegen sauber
(app/einladung.py:339-342, app/einladung_senden.py:749-751).
  Alarmierung mit Runbook-Verweis: Ich habe das ganze Repo gegen Runbook|runbook|alarm|Alarm
gegriffen. Außerhalb von Klauselwortlauten, Registerzeilen und dem Zielbild in
doku/Delivery_Verification_Harness_Plan_v1.0.md:164-172 gibt es keinen Mechanismus.
app/einladung.py:426-430 tut bei fehlendem Versandweg genau das, was er sagt: PROTOKOLL.error(...)
und return False. fail-closed ist gebaut, alarmiert wird niemand, ein Runbook wird nirgends genannt.
Bestätigt.

WAS ER NICHT WISSEN KONNTE: Genau dieser Befund steht seit dem 16.08. im Repo, in seinem eigenen
Umfang — nachweise/klauselschnitt/S1_bauspur_nachpruefung.md:80 ('Zwei sind hier erfuellt ... Zwei
sind es nicht ... die geforderte Alarmierung des Betriebs "mit Runbook-Verweis" gibt es nicht'),
S1_zeichnung.md:109, und als sperrendes Restrisiko RR-T-053 in restrisiken_teilschnitt.md:136. Das
D_Nachweise-Paket wurde ihm laut Kopf des Blattes nicht vorgelegt. Er hat es trotzdem am Quelltext
gefunden — das ist eine unabhängige Bestätigung, kein neuer Fund.

**Was die Gegenprobe daran berichtigt hat.**

1) "fundstellen_stimmen: false" ist zu forsch — alle vier Fundstellen des Fremdurteils landen.
mail/versand.py:70-79 enthaelt SMTP_USER/SMTP_PASS (72-73, os.environ, ohne Indirektion). 126-137
ist der pfeffer()-Docstring, dessen Zeilen 133-134 "Schluesseltresor ueber die verwaltete
Identitaet" als Zukunft benennen — fuer die Behauptung "kein Secret-Handling ueber verwaltete
Identitaet" ist das eine taugliche Belegstelle, nicht eine falsche. 221-226 ist der Rumpf von
nachweis() mit recipient unmaskiert. Und 536-552 ist ein BEREICH, kein Punkt: er umschliesst die
beiden print-Zeilen 541 und 551. Den Bereichsendpunkt 552 ("return 0") als "um eins daneben" zu
ruegen, ist eine Fehllesung der Zitierweise, kein Mangel des Fremdurteils.
2) Die Registeraussage ist an der eigenen Fundstelle falsch. register.md:326 traegt sehr wohl einen
benannten und gezeichneten fachlichen Eigentuemer: "Auftragnehmer (Nr. 158), vertreten durch A. Han
· gez. A. Han, 16.08.2026 · Zeichnung: nachweise/klauselregister/eigentuemer_zuweisung_260816.md".
Ich habe die Zeichnung geoeffnet: beide Kaestchen [x], Unterschriftentabelle M. Veil (Einengung) und
A. Han (Namen), 16.08.2026. Die zwei Felder mit ⟨VORSCHLAG · NICHT GEZEICHNET⟩ in Zeile 326 sind
Kritikalitaet und Abnahmekriterium — NICHT der Eigentuemer. "M-11: 0 von 1231" ist der Messstand vom
15.08. und durch die Zeichnung vom 16.08. ueberholt; die Nachrechnung zitiert im selben Satz eine
Quelle vom 16.08. und eine, die dadurch hinfaellig ist. Damit schrumpft das "vorgelagert und
haertere" Argument: offen ist allein das Abnahmekriterium, und es schuldet eine benannte, gebundene
Person.
3) Ein Befund im eigenen Zitierbereich des Fremden wurde uebersehen und stattdessen entlastet:
mail_delivery.provider_note nimmt str(f)[:500] ROH auf (versand.py:437 und :486), M30:296 sagt dazu
"Antwort im Klartext, fuer die Fehlersuche" — und app/einladung.py:340-342 haelt selbst fest, dass
die Meldung eines Mailservers die Adresse regelmaessig mitfuehrt. Das ist ein ZWEITER unmaskierter
Adresskanal in dieselbe Tabelle. Die Folgerung "geht zu weit" ist damit zu grosszuegig; die
Teilaussage "datensparsame Telemetrie" traegt mehr, als eingeraeumt wird.
4) "Die Datensparsamkeit des Nachweises ist ueber retention_class = KURZFRIST geregelt" vertauscht
zwei Eigenschaften. M30:123-130 und :1548-1553 stimmen woertlich (30 Tage, Rechtsgrundlage), aber
eine Loeschfrist ist keine Datensparsamkeit. Der Klauselwortlaut sagt "datensparsam", nicht
"befristet".
5) Die beiden Belege fuer "Der Serverpfad haelt sich dagegen sauber" (app/einladung.py:339-342,
app/einladung_senden.py:749-751) sind DOCSTRINGS, also die Selbstbeschreibung des Codes, nicht die
Protokollaufrufe. Die Aussage haelt — ich habe die tatsaechlichen Aufrufe nachgesehen
(einladung.py:356-357, 372-373, 428-429; einladung_senden.py:270, 558-559, 722, 765): keine Adresse.
Aber eine Gegenpruefung darf eine Abwesenheit nicht am Kommentar des Geprueften messen.
6) "Das D_Nachweise-Paket wurde ihm laut Kopf des Blattes nicht vorgelegt" ist aus dem Repo nicht
belegbar; der Kopf von S1_bauspur_nachpruefung.md sagt dazu nichts.
7) Aufwand (a) ist geraten, nicht gemessen: requirements.txt fuehrt ausschliesslich psycopg, ruff,
fastapi, jinja2, uvicorn, itsdangerous, python-multipart — keinen Tresor-Klienten. Zu den "30-50
Zeilen" kommt eine neue festgeschriebene Abhaengigkeit samt Manifestfuehrung (K23-M18 Glied 5). Das
ist nicht in der Zahl enthalten.
WAS ICH BESTAETIGE: die repoweite Abwesenheit von verwalteter Identitaet/Secret-Referenz (nur Doku-
und Registerstellen: app/datenbank.py:93-94, versand.py:133-134, pflege_erzeugen.py:91), die
Abwesenheit jeder Alarmierung und jedes Runbook-Verweises (einziger Mechanismus-Treffer: keiner;
einladung.py:426-430 ist PROTOKOLL.error + return False), die fehlende Egress-Allowlist, die
Klartext-Adresse in mail_delivery (M30:292), der append-only-Schutz (M30:315-317), sowie
S1_bauspur_nachpruefung.md:80, S1_zeichnung.md:109 und restrisiken_teilschnitt.md:136 (RR-T-053,
sperrend) — alle woertlich richtig.

**Aufwand.** Gemischt, und der große Teil ist kein Bau.
(a) Verwaltete Identität: nicht in Zeilen zu messen, solange M-14 offen ist. Danach ca. 30-50 Zeilen
in mail/versand.py (Auflösung von SMTP_PASS und FREIRAUM_CODE_PFEFFER über einen Tresor-Client statt
os.environ) plus install/ und Umgebungsbelegung. Bis zum 31.08. nicht ohne die Zeichnung.
(b) Alarmierung: Codeseite klein — ca. 15-25 Zeilen in zwei Dateien (mail/versand.py:437 und 486 im
Fehlerzweig, app/einladung.py:426-430), die eine Alarmzeile mit fester Runbook-Kennung absetzen. Das
Runbook selbst, sein Empfänger und die Zuständigkeit sind Text und Festlegung, kein Bau.
(c) mail_delivery: Maskierung wären ca. 3-5 Zeilen in versand.py:220-226 plus Migration — aber sie
zerstört den Zweck des Nachweises aus B2. Vorher entscheiden, nicht bauen.
(d) CLI-Ausgabe: ca. 3 Zeilen (versand.py:535-536, 541, 551), falls maskiert werden soll. Der
Quelltext begründet an Ort und Stelle (505-517, 543-546), warum er es nicht tut.

**Was zu tun ist.**

Vier Festlegungen, alle von Menschen:
1. M-14 zeichnen (arbeit/Vorlagen/offene_entscheidungen_260815.md:80): neuer Key Vault in
swedencentral — der vorhandene liegt in westeurope und verstieße gegen F05. Die Empfehlung liegt
seit dem 09.08. vor. Ohne diese Zeichnung ist Teilaussage (1) baulich blockiert, nicht baulich
offen.
2. Betriebsalarm: WER wird alarmiert, WOHIN, und WELCHES Runbook wird verwiesen. Das ist ein Service
Owner und ein Dokument, kein Programmtext. Der Delivery-Plan legt das ausdrücklich in Baustein 4.7
(Release-, Betriebs- und Service-Harness, doku/Delivery_Verification_Harness_Plan_v1.0.md:158-172),
also in einen Bereich, der zum 31.08. nicht geschuldet ist — genau das ist zu entscheiden: gilt
K03-M26 Satz 3 für den Teilschnitt, oder wandert er mit 4.7 hinaus.
3. Auslegung: Ist der append-only Zustellnachweis mail_delivery 'Telemetrie' bzw. 'Log' im Sinne von
K03-M26? Wenn ja, kollidiert die Klausel mit Bauauftrag B2, der den Nachweis fordert — dann muss ein
Mensch sagen, welche der beiden weicht. Wenn nein, entfällt der dritte Teil seines Grundes.
4. Auslegung: Ist die stdout/stderr-Ausgabe eines Betreiberwerkzeugs ein 'Log'? Der Quelltext
argumentiert (versand.py:514-517), am Terminal sei die Adresse die eigene Eingabe des Betreibers.
Vorgelagert und härter: K03-M26 trägt bis heute weder gezeichnetes Abnahmekriterium noch benannten
fachlichen Eigentümer (nachweise/klauselregister/register.md:326, beide Felder ⟨VORSCHLAG · NICHT
GEZEICHNET⟩; M-11: 0 von 1231). Solange niemand gezeichnet hat, WIE die Klausel gemessen wird, ist
jedes Urteil über sie — seines wie meines — eine Auslegung.

---

### Grund 6 · K20-M18

| | |
|---|---|
| **Nachgerechnet** | **TEILWEISE** |
| **Einordnung** | **ENTSCHEIDUNG** |
| **Berührt den 31.08.** | **ja** |

**Was das Fremdmodell sagt.** Die Entwertung älterer Anmeldecodes erzeugt keine event-Spur mit Vorher/Nachher. Fundstellen
migrations/M30__pilot_sammelmigration.sql:218-235, mail/versand.py:402-446.

**Was am Quelltext gemessen ist.**

Am Quelltext nachgesehen, Zeile für Zeile — er hat recht, und er hat sich zu seinen Ungunsten
geirrt: die Lücke ist größer, als er sie beschreibt.

SEINE FUNDSTELLE STIMMT. M30:220-230 ist die Funktion login_code_entwertet_aeltere(), sie setzt
superseded_at = clock_timestamp() auf alle offenen Codes desselben Kontos; M30:232-234 hängt sie als
BEFORE INSERT ON login_code ein. Kein INSERT INTO event darin. mail/versand.py:406-412 fügt den
neuen Code ein und schreibt danach keine event-Zeile; :444-445 schreibt nur nach mail_delivery, das
ist ein Zustellnachweis, kein Änderungsnachweis. Ich habe alle Trigger in M30 aufgelistet (grep
'CREATE OR REPLACE TRIGGER', 22 Stück) und alle INSERT INTO event (M30:938, :964, :1849). Kein
einziger hängt an login_code. Bestätigt.

SEINE GEGENBEISPIELE STIMMEN AUCH. app/einladung.py:157-174 (_nachweis schreibt value = f'{davor} ->
{danach}') und :292-296 (zwei Aufrufe für EINLADUNG_EINGELOEST und KONTO_FREIGESCHALTET) tragen
tatsächlich Vorher/Nachher. Nachgelesen, stimmt wörtlich.

WO ER ZU KURZ GREIFT — DREI WEITERE ÄNDERUNGEN AM ANMELDECODE, ALLE OHNE event-SPUR:
  a) M30:2293-2299, Trigger login_attempt_koppelt_code_trg (M30:2304-2306): der fünfte Fehlversuch
setzt failed_count hoch UND superseded_at. Das ist eine Entwertung des Zugangscodes durch die
Datenbank, ohne Nachweiszeile. Diese Stelle ist im Teilschnitt ERREICHBAR — app/anmeldung.py:85
schreibt bei jedem Versuch eine login_attempt-Zeile.
  b) mail/versand.py:439-442: scheitert der Versand, wird der eben ausgestellte Code per UPDATE
entwertet. Keine event-Zeile.
  c) app/anmeldung.py:157-165: die erfolgreiche Anmeldung setzt consumed_at. Keine event-Zeile mit
Vorher/Nachher. Der Trigger session_event_writer (M30:960-967) schreibt zwar action='ANMELDUNG',
füllt event.value aber gar nicht — der Harness hat das selbst gemessen und notiert
(pruefungen/klauseln/anmeldecode_lauf.sh:100-111: 'gemessen an der laufenden Datenbank ist die
Spalte dort NULL').

WO SEIN BEISPIEL SCHWÄCHER IST, ALS ES KLINGT: Ausgerechnet die von ihm gewählte Stelle ist über die
Anwendung im Teilschnitt nicht auslösbar. Der einzige Aufrufer von anmeldecode() ist
app/einladung.py:451 in einloesen(), und K20-D10 verhindert eine zweite erfolgreiche Einlösung
desselben Tokens; es gibt keinen Endpunkt 'neuen Code anfordern' (app/einladung.py:331-333 sagt das
ausdrücklich: 'der Vertrag fuehrt keine Aktion, mit der er einen neuen anfordern koennte'). Der
Harness hat dieselbe Beobachtung schon am 14.08. festgehalten (anmeldecode_lauf.sh:87-92, Punkt 4).
Auslösbar ist der Trigger nur über das Kommandozeilenwerkzeug mail/versand.py code — das gehört zum
Prüfgegenstand, ist aber der Betreiberweg, nicht der Nutzerweg. Die drei Stellen, die er nicht
nennt, sind über die Anwendung erreichbar.

**Was die Gegenprobe daran berichtigt hat.**

1) Die Einordnung BAU ist zu bequem. Der ganze Grund besteht nur, wenn ein login_code "Zugang" im
Sinne von K20-M18 ist. Das ist eine Auslegung: pruefungen/klauseln/anmeldecode_lauf.sh:100-111 haelt
ausdruecklich fest, dass der Klauselwortlaut dazu nichts sagt; ein gezeichnetes Abnahmekriterium
fehlt (register.md:1409); und die hauseigene Bauspur-Nachpruefung stuft K20-M18 als "ganz" gedeckt
ein (S1_bauspur_nachpruefung.md:22, :132, und :187 "nicht nur behauptet, sondern nachvollziehbar
gebaut"). Die Nachrechnung nennt die Vorfrage selbst "nicht vom Bau zu beantworten" und ordnet den
Grund trotzdem als BAU ein. Nach dem Pruefmassstab ist das ENTSCHEIDUNG mit kleinem nachgelagerten
Bau.
2) Wie bei Grund 5: "K20-M18 hat bis heute ... keinen benannten fachlichen Eigentuemer
(register.md:1409)" ist an der zitierten Zeile falsch. Zeile 1409 traegt "Auftragnehmer (Nr. 158),
vertreten durch A. Han · gez. A. Han, 16.08.2026". Ungezeichnet ist nur das Abnahmekriterium. Die
"Vorfrage fuer einen Menschen" hat also bereits einen Adressaten — genau das, was als fehlend
behauptet wird.
3) Die Vollstaendigkeitsbehauptung stimmt nicht: "grep 'CREATE OR REPLACE TRIGGER', 22 Stueck" — es
sind 23 (grep -c in M30). Wer sich auf Abwesenheit stuetzt, muss die Zaehlung genau haben.
4) "In migrations/ liegt zum Teilschnitt aber nur M30" ist falsch. Dort liegen zusaetzlich
M31__projektnummer_und_zweckbestimmung.sql und M32__zeilenschutz_und_stufenwechsel.sql (vom
19.08.2026, "der erste Bauzug an M5"); beide schreiben INSERT INTO event (M31:465, M32:172, :257).
Ich habe nachgesehen: keiner der beiden legt einen Trigger an, keiner beruehrt login_code — der
Befund ueberlebt. Aber die selbst eingeraeumte Restunsicherheit ("ein Trigger aus einer spaeteren
Migration waere mir entgangen") war am Repo beantwortbar und wurde nicht beantwortet.
5) Daraus folgt ein Aufwandsfehler: M32:79-80 stellt event auf ROW LEVEL SECURITY mit FORCE, Policy
mandant_event (M32:123-129) hat ein WITH CHECK auf tenant_id = sitzungs_mandant(). Ein login_code-
Trigger, der nach dem Muster von session_event_writer tenant_id aus actor aufloest, passiert diese
Regel nur, solange rls_erzwungen() aus ist (M32:35 sagt: Durchsetzung ist nicht eingeschaltet). Wird
sie eingeschaltet, muss die schreibende Sitzung freiraum.tenant_id fuehren — set_config steht nur in
app/datenbank.py:477 und app/gespraech.py:1810, NICHT im Betreiberweg mail/versand.py. Der Satz
"dann sind mail/versand.py und app/anmeldung.py gar nicht anzufassen" ist damit nicht tragfaehig,
und "eine Migration, eine Pruefdatei, ein Lauf" ist geschaetzt, nicht gemessen.
6) "Drei weitere Stellen, die er nicht nennt" ist um eine aufgeblaeht: mail/versand.py:439-442 liegt
INNERHALB seiner eigenen Fundstelle mail/versand.py:402-446. Ungenannt sind zwei (Fuenf-
Fehlversuche-Trigger, consumed_at).
7) beruehrt_31_08 = true bleibt richtig, ist aber schwaecher als dargestellt: K20-M18 gehoert zum
Teilschnitt (S1_zeichnung.md:96, S1_bauspur:22, Eigentuemer nur fuer Teilschnittklauseln vergeben),
taucht aber in restrisiken_teilschnitt.json/.md ueberhaupt nicht auf — kein sperrender Eintrag,
anders als RR-T-053 bei Grund 5. Es beruehrt den 31.08. als Umfang, nicht als Sperre. Das haette
gesagt werden muessen.
WAS ICH BESTAETIGE, Zeile fuer Zeile nachgesehen: M30:220-230 login_code_entwertet_aeltere(),
:232-234 BEFORE INSERT ON login_code, kein event-Insert darin; die drei INSERT INTO event in M30
stehen bei 938, 964, 1849 und keiner haengt an login_code; versand.py:406-412 Neuanlage ohne event,
:439-442 Entwertung ohne event, :444-445 nur mail_delivery; anmeldung.py:85 login_attempt auf beiden
Wegen, :157-165 consumed_at ohne event; M30:2293-2299 mit Trigger :2304-2306 (fuenfter Fehlversuch
setzt superseded_at); session_event_writer M30:960-967 fuellt event.value nicht;
einladung.py:157-174 und :292-296 tragen Vorher/Nachher; einladung.py:331-333 und :451 stimmen
woertlich. Der gemessene Befund steht.

**Aufwand.** Klein und gut umrissen, aber vier Stellen statt einer.
Hauptteil: ein Nachweis-Trigger auf login_code in migrations/M30__pilot_sammelmigration.sql — ca.
25-40 Zeilen SQL, eine Datei. Das Muster liegt fertig daneben: session_event_writer (M30:960-967)
löst actor_label und tenant_id aus actor auf und schreibt in event. Ein AFTER INSERT OR UPDATE ON
login_code würde alle vier Stellen auf einmal decken (Neuausstellung, Trigger-Entwertung, Fünf-
Fehlversuche-Entwertung, Verbrauch) — dann sind mail/versand.py und app/anmeldung.py gar nicht
anzufassen.
Zwei Bedingungen dabei, die nicht vergessen werden dürfen:
  - event.value darf Code und Streuwert NICHT tragen (K20-M08, K23-D09) — nur Zustandsnamen, etwa
'OFFEN -> ENTWERTET'. Das Muster steht in app/einladung.py:165-167.
  - Falls K20-M25 auf diese Zeilen zutrifft, muss retention_class = BETRIEPSPROTOKOLL gesetzt werden
— das ist genau Grund 7 und wäre in derselben Migration zu erledigen.
Prüffälle: ca. 40-70 Zeilen in pruefungen/klauseln/anmeldecode_lauf.sh, nach dem Vorbild von
AC-15/AC-17. Die Datei benennt die Lücke bereits im Kopf; der Prüffall ersetzt eine Fußnote durch
eine Messung.
Gesamt realistisch: eine Migration, eine Prüfdatei, ein Lauf. Vor dem 31.08. machbar.

**Was zu tun ist.**

Bauen, nicht entscheiden — mit einer kleinen Vorfrage, die der Harness selbst schon aufgeworfen hat
und die ich nicht für mich entscheide:
BAUEN: Einen event-Trigger auf login_code, der bei Neuanlage und bei jeder Zustandsänderung
(superseded_at, consumed_at, failed_count) eine Zeile mit Zeitpunkt, handelnder Instanz und Wert
davor/danach schreibt. Deckt alle vier Stellen ab. Danach die Prüffälle in anmeldecode_lauf.sh,
sonst ist es wieder ungemessen.
VORFRAGE FÜR EINEN MENSCHEN (klein, aber nicht vom Bau zu beantworten): Fällt ein Anmeldecode unter
'Zugang' im Sinne von K20-M18? anmeldecode_lauf.sh:100-111 hält ausdrücklich fest, dass der
Klauselwortlaut zur Anmeldung als Neuanlage — 'mit einem "davor" fuer eine Neuanlage' — nichts sagt.
Ich lese ihn wie das Fremdmodell: ein Einmalcode IST der Zugang, seine Entwertung IST eine Änderung
daran. Aber K20-M18 hat bis heute kein gezeichnetes Abnahmekriterium und keinen benannten fachlichen
Eigentümer (nachweise/klauselregister/register.md:1409). Wer die Klausel besitzt, sollte den Satz
sagen — er kostet eine Zeile und macht aus einer Auslegung eine Vorgabe.
ZUSATZ, DEN DAS BLATT NICHT NENNT: Beim Bau die drei erreichbaren Stellen mit aufnehmen, nicht nur
die eine aus dem Urteil. Wer nur die Trigger-Entwertung nachrüstet, schließt ausgerechnet den Pfad,
der über die Anwendung nie läuft, und lässt die drei offen, die laufen.

---

### Grund 7 · K20-M25

| | |
|---|---|
| **Nachgerechnet** | **BESTÄTIGT** |
| **Einordnung** | **ENTSCHEIDUNG** |
| **Berührt den 31.08.** | **ja** |

**Was das Fremdmodell sagt.** _nachweis() laesst retention_class weg; M30 setzt EREIGNIS statt BETRIEBSPROTOKOLL. Fundstellen
app/einladung_senden.py:276-306, 292-299, migrations/M30__pilot_sammelmigration.sql:1481-1497.
Folgerung: K20-M25 ist nicht erfuellt.

**Was am Quelltext gemessen ist.**

Zeile fuer Zeile nachgesehen, alles trifft zu.

1) app/einladung_senden.py:300-305 — das INSERT von _nachweis() nennt genau acht Spalten: actor_id,
actor_label, tenant_id, action, object_ref, change_type, value, source. retention_class steht NICHT
darin. Bestaetigt.

2) app/einladung_senden.py:291-298 — der Quelltext sagt es selbst im Wortlaut: "`retention_class`
wird NICHT gesetzt. K20-M25 nennt fuer den Nachweis einer Zugangsaenderung BETRIEBSPROTOKOLL; M30
hat die Vorgabe der Tabelle am 04.08.2026 auf EREIGNIS umgestellt ... Zwei Quellen, ein Widerspruch
-- er wird gemeldet, nicht hier entschieden." Bestaetigt.

3) migrations/M30__pilot_sammelmigration.sql:1493 — `ALTER TABLE event ALTER COLUMN retention_class
SET DEFAULT 'EREIGNIS';` Bestaetigt. Die Klasse EREIGNIS wird eine Zeile davor (1484-1491) in
retention_rule angelegt, ohne Faelligkeit und ohne Anonymisierung.

4) Gegenprobe ueber den ganzen Bestand: `grep -rn retention_class app/` findet KEINE einzige Stelle,
die beim Schreiben in `event` eine Klasse setzt — nicht in einladung_senden.py:300, nicht in
einladung.py:170, nicht in vorpruefung.py:1163, nicht in gespraech.py:1412. Jede event-Zeile des
Teilschnitts traegt also EREIGNIS. Der Befund ist sogar breiter als der Fremde ihn nennt.

5) Der Klauselwortlaut stimmt. nachweise/klauselregister/register.md:1256 fuehrt K20-M25 mit drei
Teilaussagen: (1) Wiederversand zeigt den Satz, (2) der Nachweis einer Zugangsaenderung traegt
retention_class = BETRIEBSPROTOKOLL, (3) die personenbezogene Anzeige ist nach K15 minimiert. Teil
(2) ist unbestreitbar nicht gebaut. Der eigene Klauselschnitt sagt dasselbe seit dem 16.08.:
nachweise/klauselschnitt/S1_zeichnung.md:112 und S1_bauspur_nachpruefung.md:163 — "Die geforderte
Aufbewahrungsart BETRIEBSPROTOKOLL fuer den Nachweis wird ausdruecklich nicht gesetzt."

WAS DER FREMDE NICHT GESEHEN HAT, und was die Lage aendert: der Widerspruch ist kein Versehen,
sondern eine bereits gezeichnete Entscheidung. K02-M17 verlangt im Wortlaut "eine eigene Klasse fuer
unveraenderbare Ereigniszeilen -- ohne Faelligkeit und ohne Anonymisierung, NICHT das
Betriebsprotokoll" (M30:1478-1479). Beschluss Nr. 60 (Option A), gezeichnet am 04.08.2026, hat genau
zwischen K20-M25 und K02-M17 entschieden — zugunsten von EREIGNIS. RR-02 in
nachweise/restrisiken/restrisiken.md:162-200 bestaetigt ihn am 16.08. ein zweites Mal (Zeichnung
B-20, M. Veil) und haelt fest, dass BETRIEBSPROTOKOLL im Protokoll gar nicht vollziehbar WAERE: der
Ausloeser event_append_only (M30:755) laesst kein Entfernen zu, eine Klasse mit Loeschfrist steht
dort also auf dem Papier und wird nie ausgefuehrt. Wer K20-M25 Teil (2) baute, baute eine Regel, die
die Datenbank nicht ausfuehren kann.

EIN FEHLER IM QUELLTEXT, den ich beim Nachrechnen gefunden habe und der nicht zum Grund gehoert,
aber hier hin: app/einladung_senden.py:293-295 gibt M30 FALSCH HERUM wieder. Der Kommentar sagt, M30
halte fest, "dass Altbestand mit BETRIEBSPROTOKOLL nachzuziehen waere". M30:1494-1496 sagt das
Gegenteil: `UPDATE event SET retention_class='EREIGNIS' WHERE retention_class='BETRIEBSPROTOKOLL'` —
Altbestand wird NACH EREIGNIS gezogen, nicht nach BETRIEBSPROTOKOLL. Ein Leser dieses Kommentars
nimmt an, M30 halte K20-M25 offen; M30 schliesst sie.

**Was die Gegenprobe daran berichtigt hat.**

Das Urteil BESTAETIGT traegt, aber sechs tragende Saetze der Nachrechnung sind am Quelltext falsch —
und drei davon kehren die Lage um.

1) DIE ENTLASTENDE KERNAUSSAGE IST AUF EIN ZITAT GEBAUT, DAS DAS REPO SELBST ALS FALSCH FUEHRT. Die
Nachrechnung schreibt: "K02-M17 verlangt im Wortlaut 'eine eigene Klasse fuer unveraenderbare
Ereigniszeilen -- ohne Faelligkeit und ohne Anonymisierung, NICHT das Betriebsprotokoll'
(M30:1478-1479)" und folgert: "Wer K20-M25 Teil (2) baute, brach K02-M17." Genau diese Zeile ist am
16.08.2026 berichtigt worden. /Users/andi/freiraum-
delivery/migrations/M30__BERICHTIGUNG_BELEGZEILEN_260816.md:86-91 zu M30:1477-1479: "Der Satz 'eine
eigene Klasse fuer unveraenderbare Ereigniszeilen ...' ist eine WIEDERGABE DIESES BESCHLUSSES, kein
Klauselzitat. Er steht in keinem der 24 Konzepte. -- K02-M17 sagt gezeichnet das Gegenteil: 'Vorgabe
ist das Betriebsprotokoll'. Die Klausel ist nachzuziehen -- Befund BEF-K02M17 vom 16.08.2026."
Dieselbe Feststellung steht in nachweise/restrisiken/restrisiken.md:207 ("K02-M17 ... das Gegenteil
dessen, was gebaut ist -- Widerspruch"). Damit faellt die ganze Konstruktion "zwei Klauseln stehen
gegeneinander, eine gezeichnete Entscheidung hat gewaehlt": K02-M17 UND K20-M25 sagen beide
BETRIEBSPROTOKOLL; dagegen steht allein Beschluss Nr. 60. Der Bau widerspricht zwei gezeichneten
Klauseln mit einem Beschluss als Deckung — das ist schaerfer als der Fremdbefund, nicht milder.

2) DIE "GEGENPROBE UEBER DEN GANZEN BESTAND" (Punkt 4) IST FALSCH. Behauptet: "grep -rn
retention_class app/ findet KEINE einzige Stelle, die beim Schreiben in event eine Klasse setzt".
Nachgezaehlt: app/ki_hinweis.py:127-131 schreibt INSERT INTO event (... retention_class) ...
'KI_NACHWEIS', und app/zweckbestimmung.py:724-729 setzt die Spalte im zweiten Zweig ausdruecklich.
ki_hinweis.py gehoert zum Teilschnitt (Bauaufgabe L9, seit 16.08.2026 in EN-01, importiert in
app/haupt.py:57). Die Folgerung "Jede event-Zeile des Teilschnitts traegt also EREIGNIS" haelt nur
deshalb, weil ki_hinweis.kenntnis_buchen() im ganzen Bestand KEINEN Aufrufer hat (grep -rn
kenntnis_buchen app/ liefert nur die Definition auf :99). Diese Pruefung hat die Nachrechnung nicht
gemacht und nennt sie nicht. "Der Befund ist sogar breiter als der Fremde ihn nennt" ist mit einem
grep begruendet, den der grep nicht hergibt.

3) DER BEHAUPTETE "FEHLER IM QUELLTEXT" IST KEINER — UND DIE DARAUS ABGELEITETE SOFORT-BAUANWEISUNG
WUERDE EINEN EINBAUEN. app/einladung_senden.py:293-295 lautet: "... und haelt ausdruecklich fest,
dass Altbestand mit BETRIEBSPROTOKOLL nachzuziehen waere". "Altbestand mit BETRIEBSPROTOKOLL" ist
attributiv die WHERE-Bedingung, nicht das Ziel. M30:1494-1496 sagt genau das: "Bei Altbestand waere
zusaetzlich noetig: UPDATE event SET retention_class='EREIGNIS' WHERE
retention_class='BETRIEBSPROTOKOLL'". Der Kommentar gibt M30 richtig wieder. Die Nachrechnung liest
"mit" instrumental und erklaert den Satz fuer "FALSCH HERUM"; sie fuehrt die Berichtigung zweimal
als "SOFORT UND OHNE ZEICHNUNG (reiner BAU)". Ausgefuehrt ergaebe das eine falsche Kommentarzeile.
Zusaetzlich: M30:1494-1496 ist ein KOMMENTAR, kein ausgefuehrtes UPDATE (beide Zeilen beginnen mit
'--'). Die Nachrechnung zitiert ihn als SQL und schliesst "M30 schliesst sie" — M30 fuehrt den
Altbestandslauf gerade nicht aus.

4) EIGENE FUNDSTELLE FALSCH, DREIMAL BENUTZT. "register.md:1256" traegt K18-G13 ("| K18-G13 | GILT |
v1.6 · Freigegeben mit Auflagen | ..."). K20-M25 steht in
nachweise/klauselregister/register.md:1420. Der Inhalt der Wiedergabe stimmt, die Zeile ist um 164
daneben. Die Nachrechnung setzt fundstellen_stimmen=true und rechnet dem Fremden gleichzeitig eine
Verschiebung um EINE Zeile vor.

5) DIE UNSICHERHEIT "NR. 60 HAT K20-M25 VIELLEICHT NIE GESEHEN" IST AM REPO ENTSCHEIDBAR, UND DIE
STELLE STEHT IM SELBEN ABSATZ, DEN DIE NACHRECHNUNG ZITIERT.
nachweise/restrisiken/restrisiken.md:168 fuehrt RR-02 als "O-K15-6 ... O-K02-6 ... geschlossen an
O-K20-4". arbeit/Vorlagen/vorlage_neun_entscheidungen_260816.md:753-754 definiert O-K20-4 woertlich
als "Zugangsnachweis traegt BETRIEBSPROTOKOLL -> geschlossen · K15-Anwendung", und :742-743 haelt
fest: "K20 · Zugaenge traegt keinen einzigen offenen Punkt -- alle sieben sind geschlossen." Die
K20-Seite der Verklemmung ist benannt und verkettet; die Nachrechnung hat RR-02 gelesen und die
Zeile darueber nicht.

6) DER AUFWAND IST GERATEN. Weg (a) "0 Zeilen Code ... ein Blatt, 2 Registerzeilen, unter einer
Stunde" laesst zwei belegte Auflagen weg: BEF-K02M17 verlangt, dass die KLAUSEL K02-M17 nachgezogen
wird (M30__BERICHTIGUNG_BELEGZEILEN_260816.md:91) — eine Konzeptaenderung an K02 v1.3, kein
Registereintrag; und register.md:1420 fuehrt K20-M25 als "kritisch: aufbewahrungskritisch ·
fehlender Test SPERRT die Freigabe (K23-M04)", dieselbe Auflage, die RR-02 fuer sich selbst notiert
("eine Annahmeentscheidung ersetzt den Test NICHT"). Auch Weg (a) endet damit nicht bei einem Blatt,
sondern bei Klauselnachzug plus Prueffall.

WAS UNBERUEHRT BLEIBT: die vier Fundstellen des Fremden habe ich einzeln nachgesehen und sie treffen
(app/einladung_senden.py:275-305 acht Spalten ohne retention_class; :291-298 im zitierten Wortlaut;
M30:1493 ALTER TABLE ... SET DEFAULT 'EREIGNIS'; retention_rule-Anlage 1484-1491 ohne Faelligkeit
und Anonymisierung). Der Trigger event_append_only steht auf M30:755. Das Urteil BESTAETIGT bleibt
richtig — die Begruendung darunter nicht.

**Aufwand.** Der reine Codeeingriff ist winzig und irrefuehrend klein: 2 Zeilen in
app/einladung_senden.py:301-305 (Spaltenname + Literal im INSERT), 1 Datei. Wer es dabei belaesst,
hat aber K02-M17 gebrochen und eine nicht vollziehbare Loeschfrist in ein append-only Protokoll
geschrieben. Die tatsaechliche Arbeit haengt an der Richtung der Entscheidung:

(a) Entscheidung zugunsten EREIGNIS (= Bestaetigung von Beschluss Nr. 60): 0 Zeilen Code. Aufwand
ist reine Nachweisarbeit — ein Blatt, das K20-M25 Teil (2) als durch Nr. 60 abgeloest fuehrt, plus
Eintrag im Klauselregister (register.md:1256, heute VORSCHLAG · NICHT GEZEICHNET) und Verweis in
RR-02. Etwa 1 Blatt, 2 Registerzeilen, unter einer Stunde.

(b) Entscheidung zugunsten BETRIEBSPROTOKOLL: 2 Zeilen in einladung_senden.py, dazu eine Migration,
die die Vorgabe von event zuruecknimmt, dazu die Aufhebung von event_append_only oder eine Ausnahme
darin, dazu die Ruecknahme von Beschluss Nr. 60 und von RR-02/Zeichnung B-20. Mehrere Dateien, ein
neuer Migrationsschritt, und der Nachweis, dass MT-17/MT-79 dann noch messen, was ihre Klausel sagt.

Unabhaengig davon, sofort und ohne Entscheidung: die falsche M30-Wiedergabe in
app/einladung_senden.py:293-295 berichtigen — 3 Kommentarzeilen, 1 Datei, reiner BAU.

**Was zu tun ist.**

ZU ENTSCHEIDEN IST, von einem Menschen, in einem Satz: Gilt fuer `event`-Zeilen K20-M25 Teil (2)
(retention_class = BETRIEBSPROTOKOLL) oder K02-M17 in der Fassung von Beschluss Nr. 60
(retention_class = EREIGNIS)?

Die Entscheidung ist sachlich am 04.08.2026 mit Beschluss Nr. 60 (Option A) schon gefallen und am
16.08.2026 mit Zeichnung B-20 (M. Veil, RR-02) bestaetigt worden. Was FEHLT, ist nicht die
Entscheidung, sondern ihre Zuordnung zu dieser einen Klausel: nirgends steht, dass K20-M25 Teil (2)
dadurch abgeloest ist. Solange das nicht steht, liest jeder Pruefer — wie dieser Fremde — eine
unerfuellte MUSS-Klausel, und er liest sie richtig.

KONKRET vorzulegen ist:
1. Wer zeichnet: der fachliche Eigentuemer von K20-M25. register.md:1256 fuehrt ihn als
"Auftragnehmer (Nr. 158), vertreten durch A. Han"; das Akzeptanzkriterium daneben traegt den Vermerk
VORSCHLAG · NICHT GEZEICHNET. Diese Zeichnung ist die Handlung.
2. Was gezeichnet wird: dass K20-M25 Teil (2) fuer die Tabelle `event` durch Beschluss Nr. 60
(Option A) abgeloest ist, mit Begruendung aus K02-M17 und aus der Unvollziehbarkeit
(event_append_only, M30:755).
3. Wohin es eingetragen wird: register.md bei K20-M25, RR-02 als zweite betroffene Klausel neben
O-K15-6/O-K02-6, und nachweise/klauselschnitt/S1_zeichnung.md:112, wo der Punkt heute noch als
offene Bauluecke steht.
4. K20-M25 Teil (3) (K15-Minimierung der personenbezogenen Anzeige) ist von niemandem geprueft
worden — weder vom Fremden noch im Klauselschnitt. Wer die Klausel anfasst, prueft Teil (3) mit,
sonst bleibt sie halb gemessen.

SOFORT UND OHNE ZEICHNUNG (reiner BAU): app/einladung_senden.py:293-295 berichtigen. Der Kommentar
gibt M30 in der Gegenrichtung wieder und hat genau die Lesart erzeugt, die der Fremde uebernommen
hat.

FUER DEN 31.08.: Wenn Weg A den Teilschnitt bis zur Anmeldung abnimmt, faellt diese Zeichnung VOR
dem 31.08. an. Ohne sie geht eine MUSS-Klausel als unerfuellt in die Abnahme — mit dem gebauten
Stand unveraendert, aber mit einem Blatt, das sagt warum.

---

### Grund 8 · K02-M20 / K13-M08 (Mandantengrenze); gemessen gegen Frage 15 des Auftrags

| | |
|---|---|
| **Nachgerechnet** | **BESTÄTIGT** |
| **Einordnung** | **ENTSCHEIDUNG** |
| **Berührt den 31.08.** | **ja** |

**Was das Fremdmodell sagt.** mandantenvorgang() wird von KEINEM vorhandenen Weg benutzt; der Quelltext haelt fest, dass der
Normalfall weiterhin verbindung() ohne gesetzten Mandanten ist (app/datenbank.py:381-416). 22
Stellen ohne ausdrueckliche Mandantenbedingung, einzeln aufgezaehlt. Folgerung: die verlangte
Aussage "jede Abfrage und jede Schreibanweisung traegt die Mandantengrenze" ist eindeutig falsch.

**Was am Quelltext gemessen ist.**

ICH HABE ALLE 22 STELLEN NACHGESEHEN, nicht acht. Alle 22 stimmen. Keine einzige Falschmeldung in
der Liste.

Stichprobe im Wortlaut, jede am Quelltext gelesen:
- app/anmeldung.py:84-86 — INSERT INTO login_attempt (email, origin_hash, success). Kein Mandant.
STIMMT.
- app/anmeldung.py:128-130 — SELECT id, status FROM actor WHERE lower(email) = %s ORDER BY id FOR
UPDATE. Global, kein tenant_id. STIMMT.
- app/anmeldung.py:157-165 — UPDATE login_code ... WHERE actor_id = %s AND consumed_at IS NULL ...
Kein Mandant. STIMMT.
- app/anmeldung.py:188-191 — UPDATE actor SET status='AKTIV', last_login_at=now() WHERE id = %s.
Kein Mandant. STIMMT.
- app/anmeldung.py:199-201 — INSERT INTO auth_session (actor_id). Kein Mandant. STIMMT.
- app/einladung.py:235-244 — UPDATE invitation ... WHERE i.token_hash=%s AND i.status='VERSANDT' AND
i.expires_at>now() AND k.status IN (...). Keine tenant_id-Bedingung. STIMMT.
- app/einladung.py:276-283 — UPDATE actor a SET status='AKTIV' ... WHERE a.id=%s. Kein Mandant.
STIMMT.
- app/sitzung.py:81-85 — SELECT DISTINCT m.portal_code FROM membership m JOIN portal_enabled p ...
WHERE m.actor_id = %s. Die Spalte m.tenant_scope EXISTIERT (freiraum_datamodel.sql:189, NOT NULL,
Teil des Primaerschluessels) und wird nicht geprueft. STIMMT, und das ist die schaerfste der 22:
hier wird der Portalzugang bestimmt, und die Mitgliedschaft eines fremden Mandanten zaehlte mit.
- app/sitzung.py:92-95 und 156-158 — UPDATE auth_session ... WHERE id = %s. Kein Mandant. STIMMT.
- app/sitzung.py:109-116 — SELECT ... FROM auth_session s JOIN actor a ON a.id=s.actor_id WHERE
s.id=%s. Liest a.tenant_id, prueft ihn nicht. STIMMT.
- app/einladung_senden.py:473-490 — DELETE FROM membership m USING invitation i WHERE i.id=%s AND
m.actor_id=i.actor_id AND m.portal_code=i.portal_code. Kein m.tenant_scope. STIMMT.
- app/einladung_senden.py:539-551 — INSERT INTO membership (...tenant_scope) SELECT a.id,
r.portal_code, r.id, a.tenant_id FROM actor a ... WHERE a.id=%s. Der tenant_scope kommt aus dem
ZIELKONTO, nicht aus der Sitzung; ein Vergleich gegen einladender["mandant"] findet nicht statt.
STIMMT genau so, wie er es beschreibt.
- app/einladung_senden.py:553-556 — SELECT count(*) FROM membership WHERE actor_id=%s AND
portal_code=%s. Ohne tenant_scope, obwohl tenant_scope im Primaerschluessel steht: die
Eindeutigkeitszaehlung kann bei zwei Mandanten 2 statt 1 liefern und wirft dann
_Abweisung(MELDUNG_MITGLIEDSCHAFT). STIMMT.
- app/einladung_senden.py:597-602 — UPDATE invitation ... WHERE i.actor_id=%s AND
i.status='VERSANDT'. Kein Mandant. STIMMT.
- app/einladung_senden.py:656-658 — SELECT 1 FROM portal_enabled WHERE code=%s. Global. STIMMT.
- app/einladung_senden.py:662-674 — INSERT INTO invitation ... SELECT a.id, ... FROM actor a JOIN
tenant t ON t.id=a.tenant_id WHERE a.id=%s. Frist aus dem Mandanten DES KONTOS, kein Abgleich mit
dem der Sitzung. STIMMT.
- app/einladung_senden.py:707-712 — UPDATE invitation ... WHERE i.id=%s. Kein Mandant. STIMMT.
- app/vorpruefung.py:386-388 und 822-824 — SELECT ... FROM fit_option (global) bzw. WHERE id=%s AND
question_code=%s. STIMMT; das ist Konfigurationsbestand, wie er selbst sagt.
- app/vorpruefung.py:460-463 — SELECT ... FROM fit_answer WHERE fit_check_id=%s AND superseded_at IS
NULL. STIMMT.
- app/vorpruefung.py:889-918 — SELECT/UPDATE/INSERT auf fit_answer nur ueber fit_check_id +
question_code. STIMMT.
- app/vorpruefung.py:970-980 — die Ruecknahme (UPDATE fit_answer, 970-974) traegt keinen Mandanten,
das anschliessende UPDATE fit_check (975-979) traegt "AND tenant_id = %s", und bei rowcount != 1
rollt _CheckNichtGetroffen alles zurueck (981-985). GENAU SO STIMMT ES — er hat es praezise
beschrieben, samt der Einschraenkung, dass die einzelne Anweisung die Grenze nicht traegt.
- app/vorpruefung.py:1163-1169 — INSERT INTO event (... tenant_id ...) VALUES (...,
stand["mandant"], ...). Schreibt einen Mandantenwert, prueft keinen bestehenden Objektbezug. STIMMT.

Auch seine drei POSITIVEN Funde stimmen: vorpruefung.py:442-449 liest fit_check mit "WHERE
tenant_id=%s AND actor_id=%s"; die Ergebnis-/Reset-Updates 975-979 und 1092-1095 tragen tenant_id;
einladung_senden.py:394-398 sucht das Zielkonto mit "WHERE lower(email)=%s AND tenant_id=%s". Er hat
nicht nur belastet.

WAS ICH WIDERLEGE — die Kernaussage, und sie ist die Ueberschrift des Grundes:
"mandantenvorgang() wird von KEINEM vorhandenen Weg benutzt" IST AM CODE FALSCH. Die Stelle:
app/zweckbestimmung.py:159 (`from app.datenbank import mandantenvorgang, verbindung`) und
app/zweckbestimmung.py:1148 (`with mandantenvorgang(conn, stand["mandant"]):`). Ich habe geprueft,
dass beide Zeilen am GEPRUEFTEN COMMIT 248baeda schon so standen — `git show
248baeda:app/zweckbestimmung.py | grep -n mandantenvorgang` liefert 159 und 1148. Es gibt also genau
einen Aufrufer, und der Kommentar daneben (zweckbestimmung.py:1132-1147) benennt ihn als "DER ERSTE
WEG, DER DEN MANDANTEN SETZT (Zug 2 des M5-Bauplans, 19.08.2026)".

WARUM ER TROTZDEM NICHT SCHULD IST, und das gehoert dazu: er hat es aus dem Quelltext, und der
Quelltext sagt es falsch. app/datenbank.py:19-20 ("sie hat nach diesem Zug KEINEN Aufrufer: kein Weg
im Bestand betritt mandantenvorgang"), :119 ("und das tut nach diesem Zug noch kein Weg") und vor
allem :216-220 ("SIE STELLT DIE BESTEHENDEN ROUTEN NICHT UM. app/haupt.py, app/vorpruefung.py,
app/zweckbestimmung.py und app/einladung_senden.py rufen weiterhin verbindung() und sonst nichts") —
dieser letzte Satz nennt app/zweckbestimmung.py namentlich und ist am gepruften Stand nachweislich
unwahr. Der Kopf von datenbank.py ist gegenueber dem naechsten Bauzug stehengeblieben. Der Fremde
hat einen veralteten Kommentar gelesen und ihn geglaubt; das ist genau der Fehler, den Roh-Evidenz
verhindern soll, und hier hat die Roh-Evidenz selbst ihn erzeugt.

UND FUER DEN TEILSCHNITT AENDERT DIE WIDERLEGUNG NICHTS. app/zweckbestimmung.py ist im Auftragstext
ausdruecklich "Nicht Gegenstand" (arbeit/Auftraege/tor3_abschickfertig_260820.md:59-60: "Nicht
Gegenstand: alles, was nach der Vorpruefung kommt -- die Zweckbestimmung, das Anlegen einer
Anwendung ..."). Innerhalb des geprueften Teilschnitts betritt KEIN Weg mandantenvorgang: 16 Stellen
`with verbindung() as conn` in app/haupt.py (6) und app/vorpruefung.py (10), keine davon mit
Mandantenklammer. Die Aussage ist also im Umfang der Pruefung wahr und nur ausserhalb davon falsch.

FUNDSTELLE FALSCH: app/datenbank.py:381-416 ist die Docstring von mandantenvorgang(). Dort steht die
zitierte Aussage NICHT. Der Satz "nach diesem Zug IST der Normalfall der ungeschuetzte --
verbindung() allein, in fuenf Dateien" steht auf :143-152; "die fuenf gebauten Wege benutzen
weiterhin genau diesen hier" auf :372-375; "kein Weg im Bestand betritt mandantenvorgang" auf :19-20
und :119. Der Inhalt der Aussage stimmt, die Zeilenangabe zeigt auf den falschen Absatz.

DIE FOLGERUNG GEHT EINEN SCHRITT ZU WEIT. Er schreibt, "die verlangte Aussage 'jede Abfrage und jede
Schreibanweisung traegt die Mandantengrenze' ist eindeutig falsch". Verlangt wird sie so von keiner
Klausel — der Satz stammt aus Frage 15 des Auftrags
(tor3_anforderung_teilschnitt_260816.md:376-378), also aus unserer eigenen Fragestellung. K02-M20
und K13-M08 verlangen etwas anderes: "Die Mandantengrenze MUSS zweifach durchgesetzt werden -- im
Serverpfad und im Datenbestand" (RR-04). Gemessen daran ist sein Befund nicht schwaecher, sondern
anders geschnitten: die eine Haelfte (Serverpfad) ist im Teilschnitt nicht gebaut, die andere
(Datenbestand) existiert seit M32 — fuer drei Tabellen, von denen nur eine im Teilschnitt vorkommt.

WIE ES SICH ZU RR-04 VERHAELT — und das ist der Teil, den der Mensch braucht:
RR-04 (nachweise/restrisiken/restrisiken.md:267-282, offen und getragen seit 19.08.2026, Traeger M.
Veil, Grundlage m5_vor_dem_bauzug_260819.md Entscheidung 1, gez. M. Veil und A. Han) traegt diesen
Befund NICHT — er deckt ihn nur zu einem Zweiundzwanzigstel.

1) RR-04 deckt ausdruecklich drei Tabellen: app, document, event. Von den 22 Stellen des Fremden
beruehrt GENAU EINE eine dieser drei: vorpruefung.py:1163-1169 (INSERT INTO event). Die uebrigen 21
liegen auf actor, login_attempt, login_code, auth_session, invitation, membership, fit_check,
fit_answer, fit_option, portal_enabled — alle ausserhalb. RR-04 sagt das selbst, im eigenen Kasten:
"Fuer die uebrigen Tabellen des Pilotstands ist die zweite Haelfte der Mandantengrenze weiterhin
NICHT GEBAUT -- und dort steht auch kein Eintrag dieser Liste dafuer. Wer aus RR-04 liest, die
Mandantengrenze sei geschlossen, liest ihn falsch." Der Fremde hat gefunden, was RR-04 als ungedeckt
benennt.

2) RR-04 traegt eine zweite Zusage, und die ist im Teilschnitt nicht eingeloest: "Unabhaengig davon
setzt JEDER Serverbefehl freiraum.tenant_id." Gemessen: von 16 Serverbefehlen des Teilschnitts setzt
ihn keiner. Der einzige Weg im ganzen Bestand, der ihn setzt, liegt ausserhalb des Teilschnitts.
Diese Haelfte von Entscheidung 1 ist am 20.08. nicht ausgefuehrt.

3) RR-04s eigener Befund ist inzwischen veraltet und misst zu schwarz: er sagt "Im Repo gibt es KEIN
ENABLE ROW LEVEL SECURITY und KEIN CREATE POLICY -- gemessen am 19.08.2026". Am gepruften Commit
248baeda liegt migrations/M32__zeilenschutz_und_stufenwechsel.sql vor, mit ENABLE ROW LEVEL SECURITY
auf app (:75), document (:77), event (:79) und drei CREATE POLICY (:92, :105, :124). Der Satz in
RR-04 gehoert berichtigt.

4) Die Zeilenregeln aus M32 sind fuer den Teilschnitt WIRKUNGSLOS, und zwar mit Ansage: das
Praedikat lautet "(tenant_id = sitzungs_mandant()) OR (sitzungs_mandant() IS NULL AND NOT
rls_erzwungen())" (M32:92-94), und rls_erzwungen() liest freiraum.rls_enforce mit Vorgabe 'off'
(M32:62). Solange kein Teilschnittweg freiraum.tenant_id setzt und der Schalter aus ist, laesst die
Regel jede Zeile durch. Auch die eine event-Stelle ist damit ungeschuetzt. Der Fremde haette M32
also selbst dann nicht als Deckung werten duerfen.

DIE BELEGLAGE, weil sie hier mit hineinspielt: M32 taucht in seinem gesamten Urteil an keiner Stelle
auf — bei einer Frage, die woertlich nach jeder Abfrage und jeder Schreibanweisung fragt, haette ein
Pruefer mit M32 in der Hand die Zeilenregeln erwaehnt, und sei es um sie als wirkungslos abzutun.
Ich schliesse daraus, dass M32 im Belegpaket nicht lag; beweisen kann ich es nicht, denn die
Packliste der 47 Belege liegt nicht im Repo (arbeit/Auftraege/tor3_abschickfertig_260820.md:15 nennt
nur die Zahl). Beides waere vorhanden gewesen: M32 und app/zweckbestimmung.py liegen beide am Commit
248baeda im Baum.

**Was die Gegenprobe daran berichtigt hat.**

Die Messarbeit ist gut — die 16 Aufrufstellen, M32, RR-04, freiraum_datamodel.sql:189-190 und der
Aufrufer in zweckbestimmung.py stimmen alle. Falsch ist die daraus gezogene Abstufung.

1) TEILWEISE IST ZU FORSCH — DIE WIDERLEGUNG LIEGT AUSSERHALB DES UMFANGS, UND DIE NACHRECHNUNG SAGT
DAS SELBST. Nachgeprueft und bestaetigt: app/zweckbestimmung.py:159 und :1148 rufen
mandantenvorgang, auch am Commit 248baeda (git show 248baeda:app/zweckbestimmung.py | grep -n
mandantenvorgang liefert 159 und 1148). Ebenso bestaetigt, dass app/datenbank.py:216-220
("app/haupt.py, app/vorpruefung.py, app/zweckbestimmung.py und app/einladung_senden.py rufen
weiterhin verbindung() und sonst nichts") dadurch unwahr ist. Aber: mit Weg A ist der Teilschnitt
bis zur Anmeldung der Umfang, app/zweckbestimmung.py ist ausdruecklich "Nicht Gegenstand", und die
Nachrechnung schreibt selbst "Innerhalb des geprueften Teilschnitts betritt KEIN Weg
mandantenvorgang" und "FUER DEN TEILSCHNITT AENDERT DIE WIDERLEGUNG NICHTS". Ein Satz, der im
Pruefumfang wahr ist und nur ausserhalb davon falsch, traegt keine Abstufung des Grundes. Der Fund
gehoert als Kontext und als BAU-Auftrag am Kopf von datenbank.py in die Messung — nicht in das
Urteil.

2) fundstellen_stimmen=false IST NICHT VERHAELTNISMAESSIG, UND DER MASSSTAB IST DOPPELT. 22 von 23
Fundstellen habe ich gegengelesen (anmeldung.py:84-86, 128-130, 157-165, 188-191, 199-201;
sitzung.py:80-84, 109-116; einladung_senden.py:539-556, 662-674; vorpruefung.py:970-985, 1163-1169)
— sie treffen. Der eine Fehlgriff ist app/datenbank.py:381-416: dort steht die Docstring von
mandantenvorgang (def auf :381), die zitierte Aussage steht auf :355-375 (verbindung, "OHNE
hinterlegten Mandanten ... die fuenf gebauten Wege benutzen weiterhin genau diesen hier") und auf
:216-220. Das ist ein verfehlter Absatz in derselben Datei bei richtiger Sache. Dieselbe
Nachrechnung verzeiht demselben Pruefer eine Verschiebung um eine Zeile ausdruecklich ("nicht als
Fehler gewertet") und leistet sich in Grund 7 selbst register.md:1256 statt 1420.

3) DIE WIDERLEGUNG DER KERNAUSSAGE IST AM WORTLAUT DES FREMDEN ZU BREIT GESCHNITTEN. Im Original
(nachweise/fremdreview/teilschnitt-anmeldung_260820.md:99) steht: "Eine durchgaengige
Mandantengrenze kann ich diesem Stand nicht bescheinigen. Die zentrale Mechanik mandantenvorgang()
wird von keinem vorhandenen Weg benutzt" — Satz 1 traegt den Befund, Satz 2 belegt ihn. Die
Nachrechnung erhebt den Beleg zur "Ueberschrift des Grundes" und stuft daran ab. Der Befund selbst
(Zeile 99 Satz 1, Zeile 128 Schlusssatz) ist von der Nachrechnung in allen 22 Punkten bestaetigt
worden.

4) EIGENE FUNDSTELLE UM EINS DANEBEN: "nachweise/restrisiken/restrisiken.md:272 berichtigen" — die
Befund-Zeile mit "kein ENABLE ROW LEVEL SECURITY und kein CREATE POLICY" steht auf :273. Inhaltlich
ist die Berichtigung faellig und richtig: migrations/M32__zeilenschutz_und_stufenwechsel.sql liegt
am Commit 248baeda im Baum (git ls-tree 248baeda migrations/), mit ENABLE ROW LEVEL SECURITY auf
:75/:77/:79, CREATE POLICY auf :92/:105/:124 und rls_erzwungen() mit Vorgabe 'off' auf :60-62.

5) EINORDNUNG ENTSCHEIDUNG TRAEGT, ABER NICHT SAUBER GETRENNT. Frage 1 (RR-04 erweitern oder
Serverpfad-Haelfte bauen) ist Auslegung einer getragenen Entscheidung und damit ENTSCHEIDUNG.
Zugleich enthaelt die Empfehlung mit app/sitzung.py:80-84 ("AND m.tenant_scope = %s") eine echte
SQL-Aenderung mit Folgeaufwand im Aufruferpfad; das ist BAU und haengt an keiner Zeichnung. Es
sollte als eigener Posten stehen, nicht als Anhang der Entscheidungsfrage.

WAS UNBERUEHRT BLEIBT UND GUT IST: die 16 Aufrufstellen sind exakt (haupt.py
254/306/421/452/483/507, vorpruefung.py 584/610/631/658/691/798/866/959/1049/1154 — genau 6 und 10).
RR-04s Selbstaussage (restrisiken.md:279-282: "Wer aus RR-04 liest, die Mandantengrenze sei
geschlossen, liest ihn falsch") und die nicht eingeloeste Zusage "jeder Serverbefehl setzt
freiraum.tenant_id" (:277) stimmen woertlich. freiraum_datamodel.sql:189-190 fuehrt tenant_scope NOT
NULL im Primaerschluessel. Die Frist-Beobachtung (Frage 3) ist scharf und richtig:
app/vorpruefung.py:1163 schreibt in event ausserhalb EN-05/EN-06. Der Aufwand ist hier gerechnet,
nicht geraten.

**Aufwand.** Ich trenne, was ohne Zeichnung baubar ist, von dem, was nicht.

OHNE ZEICHNUNG SOFORT BAUBAR (reiner BAU, drei Posten):
- app/datenbank.py:19-20, :119, :216-220 berichtigen — der Kopf behauptet, kein Weg betrete
mandantenvorgang, und nennt app/zweckbestimmung.py namentlich als Nicht-Aufrufer. Beides ist seit
Zug 2 falsch. ~6 Kommentarzeilen, 1 Datei. Das ist der Kommentar, der diesen Fremdbefund erzeugt
hat; er wird jeden naechsten Pruefer genauso irrefuehren.
- nachweise/restrisiken/restrisiken.md:272 berichtigen — "kein ENABLE ROW LEVEL SECURITY und kein
CREATE POLICY im Repo" ist seit M32 unwahr. ~2 Zeilen, 1 Datei.
- app/sitzung.py:81-85 um "AND m.tenant_scope = %s" ergaenzen. Diese eine Stelle ist die einzige der
22, die eine ausdrueckliche Bedingung tragen KANN und sie fachlich braucht: sie bestimmt den
Portalzugang aus membership, und tenant_scope steht bereits NOT NULL im Primaerschluessel
(freiraum_datamodel.sql:189). ~3 Zeilen, 1 Datei — aber der Mandant muss dort erst hinkommen, was
den Aufruferpfad in app/sitzung.py:109-158 beruehrt. Rechne mit ~15 Zeilen ueber 1-2 Dateien und
einem Prueffall.

MIT ZEICHNUNG, GROESSENORDNUNG (damit der Mensch die Frist einschaetzen kann):
- Serverpfad-Haelfte: die sitzungsgebundenen Wege in die Klammer mandantenvorgang setzen. 16 Stellen
`with verbindung() as conn` im Teilschnitt (app/haupt.py:254, 306, 421, 452, 483, 507;
app/vorpruefung.py:584, 610, 631, 658, 691, 798, 866, 959, 1049, 1154). Davon sind die vor-
sitzungsgebundenen (Anmeldung, Einloesung) STRUKTURELL ausgenommen — dort gibt es noch keinen
Mandanten, wie datenbank.py:135-145 richtig begruendet. Bleiben etwa 14 Aufrufstellen, je 2-4 Zeilen
Umbau plus die Verschiebung des fachlichen Teils in die Klammer. 2 Dateien, ~60-100 geaenderte
Zeilen, dazu je Weg ein gemessener Lauf, weil die Klammer eine Transaktion oeffnet und damit das
Rollback-Verhalten aendert (siehe die Warnung in datenbank.py:360-364 zum Fehlversuch-Buchen: dieser
eine darf NICHT in die Klammer, sonst zaehlt die Drosselung nach K03-M16 nie).
- Datenbestand-Haelfte: Zeilenregeln fuer die Teilschnitt-Tabellen. Heute gedeckt: 3 Tabellen (app,
document, event). Ungedeckt und im Teilschnitt beschrieben: actor, auth_session, login_code,
login_attempt, invitation, membership, fit_check, fit_answer — 8 weitere. Eine neue Migration nach
dem Muster von M32:75-128, ~10 Zeilen je Tabelle, also ~80-100 Zeilen in 1 neuer Datei, plus
Negativfaelle. Das IST Punkt 09, und Punkt 09 ist laut RR-04 "ein eigener Zug".
- Der Schalter: freiraum.rls_enforce auf 'on'. 1 Zeile — und sie darf erst fallen, wenn ALLE
sitzungsgebundenen Wege umgestellt sind, sonst bricht jeder nicht umgestellte Weg (M32:62,
datenbank.py:212-222). Das ist der Punkt, an dem der Umbau unteilbar wird.

**Was zu tun ist.**

ZU ENTSCHEIDEN IST, von einem Menschen, und es sind drei getrennte Fragen. Nicht eine.

FRAGE 1 — die einzige, die am 31.08. haengt: Wird der Teilschnitt bis zur Anmeldung mit
ungeschuetzter Mandantengrenze abgenommen, gegen RR-04, oder nicht?
RR-04 ist am 19.08.2026 gezeichnet worden (M. Veil und A. Han), aber er deckt diesen Befund nur fuer
eine der 22 Stellen. Fuer die uebrigen 21 gibt es heute KEINEN getragenen Eintrag — RR-04 sagt das
selbst im Wortlaut. Und RR-04 traegt ausserdem die nicht eingeloeste Zusage "jeder Serverbefehl
setzt freiraum.tenant_id", die im Teilschnitt nirgends ausgefuehrt ist. Es braucht daher eine von
zwei Festlegungen:
  (a) RR-04 wird um den Teilschnitt ERWEITERT: der Umfang wird ausdruecklich auf die acht
Teilschnitt-Tabellen ausgedehnt, das Restrisiko fuer sie benannt und getragen, mit Traeger und
Frist. Dann ist der 31.08. haltbar — mit einem offenen, benannten Risiko statt mit einer stillen
Luecke. ACHTUNG: RR-04 fuehrt selbst "kritisch -- mandantenkritisch" und haelt fest, dass nach
K23-M04 in dieser Klasse eine Annahmeentscheidung den Test NICHT ersetzt. Wer (a) waehlt, waehlt
eine Abnahme mit einem kritischen, ungetesteten Punkt.
  (b) Die Serverpfad-Haelfte wird VOR dem 31.08. fuer den Teilschnitt gebaut (die ~14
Aufrufstellen). Dann ist zu entscheiden, wer sie baut und bis wann, und dass die Zeilenregeln fuer
die acht Tabellen danach folgen.
ZU BENENNEN sind in beiden Faellen: Person, Datum, Umfang in Tabellen.

FRAGE 2 — Terminierung von Punkt 09 gegen den 31.08. RR-04 nennt als Traeger dafuer ausdruecklich M.
Veil: "die Terminierung von Punkt 09 gegen den 31.08.2026 ist eine Entscheidung des Auftraggebers".
Diese Entscheidung steht heute nicht da. Sie ist zu treffen: Punkt 09 vor dem 31.08., danach, oder
als getragenes Restrisiko ueber den 31.08. hinaus.

FRAGE 3 — die Frist von RR-04 ist ereignisgebunden formuliert: "mit dem ersten Bildschirm ausserhalb
von EN-05/EN-06, der auf denselben Bestand schreibt". Der Teilschnitt SCHREIBT auf denselben Bestand
— vorpruefung.py:1163 schreibt in event, eine der drei RR-04-Tabellen, ausserhalb von EN-05/EN-06.
Nach dem Wortlaut von RR-04 ist die Bedingung damit bereits eingetreten. Zu klaeren ist, ob das so
gemeint war; wenn ja, ist RR-04 faellig und nicht mehr aufschiebbar.

WAS OHNE JEDE ZEICHNUNG SOFORT ZU TUN IST (BAU, und ich empfehle es getrennt von allem oben):
1. app/datenbank.py:19-20, :119 und besonders :216-220 berichtigen. Dieser Kommentar hat den
Fremdbefund erzeugt. Solange er steht, wird der naechste Pruefer dasselbe schreiben, und wir werden
dasselbe noch einmal nachrechnen.
2. nachweise/restrisiken/restrisiken.md:272 berichtigen — M32 existiert.
3. app/sitzung.py:81-85 um die tenant_scope-Bedingung ergaenzen. Von den 22 Stellen ist das die
eine, die den Portalzugang bestimmt; sie ist ohne Zeilenregeln und ohne Umbau der Klammer zu
schliessen.

ZUR BELEGLAGE, fuer den naechsten Tor-3-Lauf: dem Pruefer haben zwei Belege gefehlt, die im Repo
lagen — migrations/M32__zeilenschutz_und_stufenwechsel.sql (die gebaute Haelfte im Datenbestand) und
app/zweckbestimmung.py (der eine Aufrufer von mandantenvorgang, allerdings ausdruecklich Nicht-
Gegenstand). Bei einer Frage, die woertlich nach jeder Abfrage und jeder Schreibanweisung fragt,
gehoert M32 ins Paket, auch wenn seine Regeln heute nichts treffen — gerade dann. Und die Packliste
der 47 Belege gehoert in das Repo; heute steht dort nur die Zahl, und ich konnte deshalb nicht
entscheiden, sondern nur schliessen.

---

### Grund 9 · K04-M08

| | |
|---|---|
| **Nachgerechnet** | **BESTÄTIGT** |
| **Einordnung** | **ENTSCHEIDUNG** |
| **Berührt den 31.08.** | nein |

**Was das Fremdmodell sagt.** Der Termin-Ausweg loest die Ansprechperson nicht auf; es entsteht nur ein internes Ereignis. Er
fuehrt daher nicht vollstaendig zu "Gespraech mit der Ansprechperson vereinbaren". Fundstellen
app/vorpruefung.py:1123-1172, 1131-1139.

**Was am Quelltext gemessen ist.**

Am Quelltext nachgesehen, Zeile fuer Zeile. app/vorpruefung.py:1122-1171 ist die ganze Funktion
eignung_termin(). Sie tut genau drei Dinge: Sitzung pruefen (1154-1157), Check lesen (1159-1161),
EINE Zeile in `event` einfuegen mit action='TERMIN_ANGEFRAGT', object_ref='FIT_CHECK:<id>',
change_type='Neuanlage' (1163-1169), dann Umleitung auf /eignung?termin=1 (1171). Kein Lesen von
`contact`, kein Mailversand, kein zweiter Schreibweg. Der Docstring sagt es selbst im Wortlaut
(1133-1138): "DIE ANSPRECHPERSON WIRD NICHT AUFGELOEST ... Der Wunsch wird vermerkt, die Zustellung
an die Ansprechperson ist ein offener Punkt und wird nicht behauptet." Gegengeprueft:
`TERMIN_ANGEFRAGT` wird nirgends gelesen (grep ueber das ganze Repo -- nur Schreibstellen in
vorpruefung.py:1166 und zweckbestimmung.py:1336 sowie der Prueffall VP-18). Die Tabelle `contact`
steht im Zielschema (schema/freiraum_datamodel.sql:216-227), wird aber von
migrations/M30__pilot_sammelmigration.sql GAR NICHT angelegt (kein einziger Treffer auf "contact" in
migrations/) und von keinem Seed gefuellt -- im Pilotbestand existiert sie also nicht einmal, nicht
nur "traegt keine Zeile". Der Bildschirmvertrag verlangt an dieser Stelle wirklich mehr:
schema/K19_screens.yaml:202-208, Aktion `termin`, serverbefehl `request_contact_appointment`,
zustand_erfolg "Gespraech mit der Ansprechperson angestossen (K04-M08)". Insoweit stimmt der Fremde
vollstaendig.

UND ER HAT DAS SCHLIMMERE UEBERSEHEN. Die Quittung, die der Nutzer nach der Umleitung liest, steht
in app/vorpruefung.py:252-254: "Ihr Wunsch nach einem Gespraech ist vermerkt. Ihre Ansprechperson
meldet sich bei Ihnen." Der Kommentar zwei Zeilen darueber (250-251) behauptet, sie "verspricht
nichts, was diese Scheibe nicht haelt". Das ist am eigenen Code widerlegt: der zweite Satz sagt
einem Nutzer zu, dass sich jemand meldet, waehrend derselbe Docstring 130 Zeilen tiefer festhaelt,
dass die Zustellung ein offener Punkt ist und niemand aufgeloest wird. Es ist nicht nur "ein
internes Ereignis" -- es ist ein internes Ereignis plus eine unwahre Zusage an den Nutzer. Dieselbe
Meldung steht wortgleich in app/zweckbestimmung.py:389-391 (M4, ausserhalb des Teilschnitts). Kein
Prueffall misst diesen Text (grep auf "Ansprechperson meldet" findet nur die zwei Quellstellen).

**Was die Gegenprobe daran berichtigt hat.**

Vier Mängel, einer davon tragend.

1) BERUEHRT_31_08 = JA widerspricht der eigenen Messung. Ich habe die Vereinigungsmenge selbst
nachgerechnet (python über nachweise/klauselschnitt/S1_wortmarken.json, Stationen 0-4
Mandant/Einladungsschranke/Einladung/Anmeldecode/Anmeldung): genau 152 Klauseln, aus K04 darin
ausschließlich D08, M10, M18 — K04-M08 ist NICHT enthalten und taucht nur in Station 10 'Gespraech'
auf. Genau diese Rechnung nutzt die Nachrechnung bei Grund 10, um beruehrt_31_08 = nein zu setzen.
Bei Grund 9 setzt sie mit identischer Messung ja. Beides zusammen ist nicht haltbar. Die Begründung
('die unwahre Quittung steht im abzunehmenden Stand') trägt nicht, denn nach derselben Logik stünde
auch der bedingungslos eingebundene Vorprüfungs-Router im abzunehmenden Stand.
arbeit/Vorlagen/festlegung_teilschnitt_anmeldung_260816.md:74 sagt bei Schritt 5 ausdrücklich 'hier
endet der Teilschnitt'; die Vorprüfung steht dort nicht.

2) EINORDNUNG BAU IST FALSCH — und sie wird nur dadurch möglich, dass der Grund des Fremden
ausgetauscht wird. Der Fremde sagt: der Ausweg führt nicht vollständig zu 'Gespräch mit der
Ansprechperson vereinbaren'. Ob eine bloße Ereigniszeile diesen Ausweg aus K04-M08 erfüllt, ist
Auslegung von Klausel und Bildschirmvertrag (schema/K19_screens.yaml:202-208: serverbefehl
request_contact_appointment, zustand_erfolg 'Gespraech mit der Ansprechperson angestossen
(K04-M08)') — und arbeit/Vorlagen/entscheidung_termin_nach_halt_260815.md:146 führt genau das
ausdrücklich als 'offen, gehört zu K11'. Gezeichnet ist am 15.08. (Zeile 135) nur Lesart A zu
K04-D04 Satz 1 ('Gespräch' = Stufen 01/02), nicht die Frage, ob der Ausweg ohne Zustellung genügt.
Die Nachrechnung ordnet stattdessen ihren eigenen Zusatzbefund (den Wortlaut der Quittung) ein und
nennt ihn BAU. Hinzu kommt: den Satz zu streichen entfernt den Stand WEITER vom zustand_erfolg des
gezeichneten Bildschirmvertrags — auch die Textänderung setzt eine Entscheidung voraus, die der
Harness nicht treffen darf. Zutreffend wäre: ENTSCHEIDUNG (mit einem nachgeordneten, kleinen BAU-
Vollzug, sobald der Wortlaut gezeichnet ist).

3) EINE MESSAUSSAGE IST SCHLICHT FALSCH. 'grep auf "Ansprechperson meldet" findet nur die zwei
Quellstellen' — der grep findet genau EINE Stelle (app/vorpruefung.py:253).
app/zweckbestimmung.py:390 bricht die Zeile anders um ('Ihre Ansprechperson ' / 'meldet sich bei
Ihnen.') und wird von diesem Muster nicht getroffen. Die Schlussfolgerung hält dennoch: mit dem
tragfähigen Muster 'Wunsch nach einem Gespraech' habe ich nachgemessen — Treffer nur
app/vorpruefung.py:253, app/zweckbestimmung.py:390 und zwei Vorlagenkommentare
(en04_eignung.html:276, en04a_zweckbestimmung.html:248); kein Prüffall misst den Text. Ebenso
unvollständig: 'TERMIN_ANGEFRAGT ... nur Schreibstellen in vorpruefung.py:1166 und
zweckbestimmung.py:1336 sowie VP-18' — app/gespraech.py:1288 trägt den Wert ebenfalls (Kommentar).
Gelesen wird er nirgends; die Aussage stimmt in der Sache, nicht in der Messung.

4) Die Unsicherheit zu arbeit/Vorlagen/entscheidung_steuertexte_260816.md zielt daneben: dieses
Blatt behandelt die Steuerungstexte des Harness (Bau-Kommando, Verfassung, Schreibziele wie app/),
nicht die Nutzermeldungen der Anwendung. Es sperrt den Wortlaut von MELDUNG_TERMIN weder, noch deckt
es ihn. Die Bindung ist K19_screens.yaml.

Nebenbei, weil zeilengenau geprüft werden sollte: die Funktion steht bei 1122-1171 (Dekorator 1122,
letzte Zeile 1171); die Fundstelle des Fremden '1123-1172' ist an beiden Enden um eins verschoben.
Das ist unschädlich, wird aber unter 'fundstellen_stimmen: true' stillschweigend mitkorrigiert.

**Aufwand.** Klein. Zwei bis drei Zeilen in genau einer Datei fuer den Teilschnitt: app/vorpruefung.py:252-254
(Wortlaut von MELDUNG_TERMIN) plus der irrefuehrende Kommentar 250-251. Wenn gleich mitgezogen:
app/zweckbestimmung.py:389-391, gleiche Aenderung, gehoert aber zu M4. Kein Prueffall bricht dabei
(VP-18 misst nur die event-Zeile, pruefungen/klauseln/vorpruefung_lauf.sh:1606-1647). Das Aufloesen
der Ansprechperson selbst ist KEIN kleiner Bau und hier auch nicht baubar -- `contact` existiert im
Pilotbestand nicht.

**Was zu tun ist.**

Die Quittung ehrlich machen: den Satz "Ihre Ansprechperson meldet sich bei Ihnen." streichen oder
durch eine Formulierung ersetzen, die nur sagt, was geschieht (der Wunsch ist vermerkt), und den
Kommentar 250-251 mit anpassen, weil er heute das Gegenteil dessen behauptet, was die Meldung tut.
Das braucht keine Zeichnung -- dass die Zusage nicht eingeloest wird, steht im selben Modul.

WAS DAGEGEN NICHT ZU BAUEN IST, und warum: Die Auslegungsfrage hinter K04-M08 ist bereits
gezeichnet. arbeit/Vorlagen/entscheidung_termin_nach_halt_260815.md, Befund BEF-M3-3, gezeichnet von
M. Veil am 15.08.2026, Lesart A -- der Termin-Ausweg nach dem Halt bleibt zulaessig. Dasselbe Blatt
haelt in seiner Schlusstabelle ausdruecklich fest: "Die Ansprechperson ist weiterhin nicht
erreichbar | offen, gehoert zu K11 | Gebaut ist der Nachweis des Wunsches (Ereigniszeile
TERMIN_ANGEFRAGT), nicht die Zustellung." Der Fremde hat also keinen unbekannten Mangel gefunden,
sondern einen bereits benannten und einem Menschen vorgelegten offenen Punkt -- nur hat er die eine
Stelle nicht gesehen, an der der Bau daraus doch eine Zusage macht. Genau die ist zu beheben.

---

### Grund 10 · K04-G11

| | |
|---|---|
| **Nachgerechnet** | **TEILWEISE** |
| **Einordnung** | **ENTSCHEIDUNG** |
| **Berührt den 31.08.** | nein |

**Was das Fremdmodell sagt.** Kein Produktivsperrriegel; der Router wird bedingungslos eingebunden. "Auf Codeebene ist der von
K04-G11 verlangte Riegel nicht vorhanden", K04-G11 sei "daher nicht umgesetzt". Fundstellen
app/haupt.py:72,104,105, app/vorpruefung.py:627-666.

**Was am Quelltext gemessen ist.**

Erst den Wortlaut nachgelesen, wie aufgetragen. nachweise/klauselregister/register.json:3706-3719,
K04-G11, Art GILT: "Es GILT: Bis Antwortkatalog und Wiederanlauf aus O-K04-2 und O-K04-4 beschlossen
sind, ist K04 nur Freigabekandidat; der Produktivweg bleibt gesperrt." Herkunft
260801_FREIRAUM_K04_v1.7.md:94. Feld `eigentuemer` ist LEER, die Kritikalitaet traegt ausdruecklich
"⟨VORSCHLAG · NICHT GEZEICHNET⟩".

Die Beobachtung am Code stimmt und ich habe sie nachgesehen: app/haupt.py:72 `from app.vorpruefung
import router as vorpruefung_router`, app/haupt.py:104 `app.include_router(vorpruefung_router)` --
ohne Bedingung, ohne Schalter, ohne Umgebungsvariable. Zehn Routen sind damit registriert
(app/vorpruefung.py:570, 598, 627, 638, 665, 789, 828, 922, 1009, 1122). Ein grep auf "K04-G11"
ueber den gesamten Baum findet KEINE einzige Stelle in app/, mail/, migrations/, seeds/ oder
pruefungen/ -- der Riegel ist im Code tatsaechlich nirgends. Auch der zweite Durchgang stimmt: VP-31
ist der letzte Prueffall und misst K04-G07 (pruefungen/klauseln/vorpruefung_lauf.sh:2176-2199), ein
Fall fuer K04-G11 existiert nicht.

WO DIE FOLGERUNG ZU WEIT GEHT: Die Klausel verlangt keinen Schalter im Programm. Sie sagt "K04 ist
nur Freigabekandidat" und "der Produktivweg bleibt gesperrt" -- das ist eine Sperre ueber den
FREIGABESTAND, nicht ein Merkmal am Bau. Aus "kein Feature-Schalter im Code" folgt nicht "Klausel
nicht umgesetzt"; es folgt nur, dass der Nachweis woanders liegen muesste. Und genau dort ist er
auch benannt: arbeit/Plaene/scheibe2_m3_plan.md:171, offener Punkt O-M3-3, zitiert die Klausel im
Wortlaut und zieht die Folge -- "Dieser Bau ist damit ein Pruefstand, keine Produktivfreigabe." Der
Punkt wurde also nicht uebersehen, sondern ausgewiesen. Dazu gemessen: in diesem Repo gibt es
ueberhaupt keinen Produktivweg, an dem etwas aufgehen koennte. .github/workflows/ enthaelt genau
zwei Dateien, tore.yml (Tor 1: Lint, Migration, Vertragspruefungen) und tor3.yml -- keinen Deploy-
Schritt. install/README.md sagt von sich selbst "Noch nicht begonnen." Der Fremde hat diese Grenze
im zweiten Durchgang selbst gezogen: "Ob dieser Serverstand tatsaechlich in einer Produktivumgebung
erreichbar ist, kann ich aus den gelieferten Belegen nicht feststellen." Damit steht sein eigener
Schlusssatz "K04-G11 ist daher nicht umgesetzt" gegen seinen eigenen Vorbehalt.

WAS WIRKLICH FEHLT, und das ist echt: kein Prueffall (bestaetigt, s.o.) UND keine Restrisiko-Zeile.
nachweise/restrisiken/restrisiken_teilschnitt.md fuehrt aus K04 nur RR-T-055 (K04-D08), RR-T-056
(K04-M10) und RR-T-057 (K04-M18). K04-G11 steht dort nicht -- weil es nicht zum Ausschnitt gehoert
(siehe Unsicherheit). Eine freigabekritisch eingestufte Klausel ohne Prueffall und ohne Restrisiko-
Zeile ist nach K23-M04/K23-D07 unversorgt.

**Was die Gegenprobe daran berichtigt hat.**

Der Kern hält, drei Ungenauigkeiten stehen dagegen.

1) 'fundstellen_stimmen: true' ist zu bequem. Die Nachrechnung zitiert das Fremdurteil selbst mit
'app/haupt.py:72,104,105' und prüft dann nur 72 und 104 nach. app/haupt.py:105 ist eine LEERZEILE
(104 = app.include_router(vorpruefung_router), 105 leer, 110 = zweckbestimmung_router). Die Stelle
stammt aus dem ersten Durchgang des Fremden (nachweise/fremdreview/teilschnitt-
anmeldung_260820.md:142, dort nur ':105'); im zweiten Durchgang nennt er 72,104 (ebd.:169). Eine der
drei genannten Zeilen trägt also nicht, was ihr zugeschrieben wird — das gehört benannt, nicht mit
einem pauschalen 'true' überschrieben.

2) Zahlfehler im Aufwand: 'dann laufen die uebrigen 30 VP-Prueffaelle nur noch mit gesetzter
Freigabe'. Es sind 31 (VP-01 bis VP-31, nachgezählt in pruefungen/klauseln/vorpruefung_lauf.sh).

3) Der stärkste Beleg für die eigene These wurde übersehen:
nachweise/klauselregister/M5_teil1_vorschlaege_260819.json führt für die parallele Klausel K05-G12
aus, die Wortmarken 'Freigabekandidat' und 'Produktivweg' kämen im ganzen Register nur in drei
Klauseln vor — K04-G11, K05-G12, K06-G13 — 'in keiner mit einem beobachtbaren Ort', und ein
Kriterium, das an einem Bildschirmaufruf anschlüge, wäre 'genau der Mangel erfunden'. Das ist im
Haus bereits gemessen und gezeichnet und stützt die Lesart 'Sperre über den Freigabestand, kein
Merkmal am Bau' weit besser als der bloße Planpunkt O-M3-3. Die Nachrechnung stellt es so dar, als
sei der Punkt allein im Plan ausgewiesen.

Alles Übrige habe ich nachgesehen und bestätigt: register.json:3706-3719 mit leerem 'eigentuemer'
(3712) und '⟨VORSCHLAG · NICHT GEZEICHNET⟩ ... ⟨zeichnet: ⟩' (3713); K04-G11 kommt in app/, mail/,
migrations/, seeds/, pruefungen/ nirgends vor (alle Treffer liegen in nachweise/ und arbeit/);
O-K04-2/O-K04-4 haben genau zwei Treffer (register.json:3709, scheibe2_m3_plan.md:171); VP-31 misst
K04-G07 (vorpruefung_lauf.sh:2176ff.), ein Fall für K04-G11 fehlt; .github/workflows enthält nur
tore.yml und tor3.yml ohne Deploy-Schritt (tore.yml:12 'Kein Deployment. Keine Geheimnisse. Keine
Zielumgebung.'), install/README.md sagt 'Noch nicht begonnen.'; restrisiken_teilschnitt.md führt aus
K04 nur RR-T-055/056/057. Urteil TEILWEISE, Einordnung ENTSCHEIDUNG und beruehrt_31_08 = nein
bleiben richtig.

**Aufwand.** Als Zeichnung: gering -- eine Restrisiko-Zeile mit Traeger, Annahmeentscheidung und Frist, plus die
Zeichnung der Kritikalitaet durch den fachlichen Eigentuemer (das Feld `eigentuemer` in
register.json:3712 ist leer, und K23-G08 verbietet dem Harness, sie selbst zu begruenden).

Falls ein Mensch stattdessen einen Riegel im Code beschliesst: ebenfalls klein, aber es waere neuer
Umfang -- rund 5 bis 10 Zeilen in app/haupt.py um Zeile 104 (Umgebungsvariable, fail-closed,
Vorpruefungs-Router nur bei ausdruecklicher Freigabe einbinden) und ein Prueffall in
pruefungen/klauseln/vorpruefung_lauf.sh (etwa 15 Zeilen), der bei gesetztem Riegel 404 auf
/vorpruefung erwartet. Betroffen waeren zwei Dateien. Achtung: dann laufen die uebrigen 30 VP-
Prueffaelle nur noch mit gesetzter Freigabe -- der Lauf braucht die Variable in seiner Vorbereitung.

**Was zu tun ist.**

Genau zu entscheiden ist ZWEIERLEI, und beides von einem Menschen:

1. WAS "der Produktivweg bleibt gesperrt" hier heisst. Entweder (a) die Sperre ist erfuellt, solange
es keine Produktivfreigabe und keinen Deploy gibt -- dann ist der Nachweis ein
Betriebs-/Freigabebeleg (eine gezeichnete Feststellung, dass K04 nicht in Produktion steht), nicht
Code, und O-M3-3 im Plan wird von "offener Punkt" auf "gezeichnet" gehoben. Oder (b) die Sperre muss
am Bau selbst greifen -- dann ist der Riegel in app/haupt.py:104 zu bauen und ein Prueffall dafuer
zu schreiben. Der Harness darf das nicht auslegen; die Klausel nennt keinen beobachtbaren Ort.

2. WER die Kritikalitaet zeichnet und ob K04-G11 eine Restrisiko-Zeile bekommt. Heute steht die
Einstufung "freigabekritisch + wiederherstellungskritisch" ausdruecklich als "⟨VORSCHLAG · NICHT
GEZEICHNET⟩ ... ⟨zeichnet: ⟩ ⟨am: ⟩" (register.json:3713). Solange niemand zeichnet, sperrt sie auch
nichts. Fuer O-K04-2 und O-K04-4 selbst gilt: sie kommen im ganzen Repo NUR im Klauselwortlaut vor
(zwei Treffer, register.json:3709 und scheibe2_m3_plan.md:171) -- die beiden offenen Punkte liegen
in der Konzept-Fabrik, nicht hier. Ob sie beschlossen sind, ist aus diesem Repo nicht feststellbar;
solange sie es nicht sind, gilt die Bedingung der Klausel weiter.

---

### Grund 11 · F07 (Massstab des Prueflaufs, keine K-Klausel) — Belegbarkeit der vier M30-Negativfaelle; beruehrt die Nachweisfuehrung, nicht den Pruefgegenstand

| | |
|---|---|
| **Nachgerechnet** | **BESTÄTIGT** |
| **Einordnung** | **BAU** |
| **Berührt den 31.08.** | **ja** |

**Was das Fremdmodell sagt.** "Noch wichtiger: Im Erfolgszweig verwirft der Harness die tatsaechliche Fehlermeldung und gibt nur
'scheitert an $erwartet' aus (pruefungen/lauf.sh:302-304). Die vollstaendige PostgreSQL-Meldung wird
nur beim falschen Fehlerfall ausgegeben (:306-308). Darum kann ich die verlangten vier
tatsaechlichen Fehlermeldungen im Wortlaut nicht ehrlich zitieren. Belegt sind nur die vier
erwarteten Bedingungsnamen."

**Was am Quelltext gemessen ist.**

Die Beobachtung stimmt Zeile fuer Zeile. /Users/andi/freiraum-delivery/pruefungen/lauf.sh:302 `elif
printf '%s' "$aus" | grep -qF "$erwartet"; then`, :303 `echo "   $kennung — scheitert an
$erwartet"`, :304 `merke "$kennung" bestanden "$erwartet"`. Der Erfolgszweig gibt $aus nirgends aus;
$aus wird in der naechsten Schleifenrunde ueberschrieben. Der Fehlerzweig :306-308 druckt dagegen
`head -2` der echten Meldung. Kein tee, keine Protokolldatei fuer diesen Abschnitt (Protokoll gibt
es nur fuer den Server, :617-624). Auch die Manifeste tragen nur den ERWARTETEN Namen:
nachweise/manifeste/tor1c_260820*.json fuehren durchgehend
{"kennung":"M30_N1_frist_ge_mindestfrist","zustand":"bestanden","anmerkung":"frist_ge_mindestfrist"}
usw. Der Wortlaut der vier Postgres-Meldungen steht nirgends im Repo — er waere also auch bei
vollstaendiger Vorlage nicht auffindbar gewesen.

WO ER ZU WEIT GEHT: Die Aussage 'jeder Negativfall scheitert an SEINER Bedingung' ist nicht unbelegt
im Sinne von ungeprueft. Zeile 302 ist genau diese Pruefung: `grep -qF "$erwartet"` laeuft gegen
$aus, und $aus ist `psql ... 2>&1`, also die echte Fehlerausgabe. Wer nicht an seiner Bedingung
scheitert, faellt in :306 'FALSCHE BEDINGUNG' und wird als fehlgeschlagen vermerkt. Die Aussage ist
maschinell erzwungen — sie ist nur nicht abgeschrieben. Sein 'unbelegt' trifft die Zitierbarkeit,
nicht die Pruefung.

WO ER SOGAR RECHT BEHAELT, OHNE ES ZU SAGEN: `grep -qF` sucht im GESAMTEN kombinierten Ausgabestrom,
nicht in der ERROR-Zeile. Ein NOTICE, eine DETAIL-Zeile oder ein von psql mitgedruckter 'LINE
n:'-Auszug des SQL-Textes, der den Bedingungsnamen enthaelt, wuerde den Riegel ebenfalls oeffnen,
obwohl der wirkliche ERROR ein anderer waere. Fuer die vier M30-Faelle habe ich das ausgeschlossen:
der erwartete String steht dort nur in den Kommentarzeilen 2 und 4 (geprueft in allen vier Dateien),
und psql echot Kommentare bei ECHO=none nicht. Der Riegel ist also heute nicht ausnutzbar, aber
schwaecher als sein Etikett.

**Was die Gegenprobe daran berichtigt hat.**

ENTSCHEIDENDE FUNDSTELLE UEBERSEHEN — und zwar in der Datei, die dieser Harness zuerst liest.
CLAUDE.md:180-182 lautet woertlich: "Ein Negativfall gilt erst als bestanden, wenn er an seiner
eigenen Bedingung scheitert; die Fehlermeldung im Wortlaut ist Teil der Evidenz." Und weiter:
"Gezeichnete Grundlage: Bauauftrag §9 Tor I Nr. 6 (:649) und `README.md`:204 des Repos." Damit ist
die von der Nachrechnung als offen erklaerte Frage bereits beantwortet. Ihre eigene unsicherheit —
"Ob 'im Wortlaut zitierbar' ueberhaupt gefordert ist oder ob der maschinelle Riegel als Beleg
genuegt, ist eine Frage des Nachweismassstabs, die ich nicht entscheide" — ist keine offene Frage,
sondern eine gezeichnete Vorgabe, die die Nachrechnung nicht nachgesehen hat. (Nur die
KLAUSELfassung ist offen, CLAUDE.md:182-185, O-K23-7; die Bauauftragsgrundlage ist gezeichnet.)
Sobald der Wortlaut ausdruecklich TEIL DER EVIDENZ ist, trifft der Einwand des Fremden nicht bloss
die Zitierbarkeit, sondern den Belegstand selbst: die vier Faelle erfuellen den gezeichneten
Massstab nicht.

STROHMANN: Die Herabstufung auf TEILWEISE stuetzt sich auf den Satz "Die Aussage 'jeder Negativfall
scheitert an SEINER Bedingung' ist nicht unbelegt im Sinne von ungeprueft". Diesen Sinn hat der
Fremde nie behauptet. Sein Wortlaut (nachweise/fremdreview/teilschnitt-anmeldung_260820.md:186) sagt
genau das Gegenteil von einem Ueberzug: "Belegt sind nur die vier erwarteten Bedingungsnamen" und
"kann ich weiterhin nicht belegen". Die Nachrechnung raeumt zwei Absaetze spaeter selbst ein: "Sein
'unbelegt' trifft die Zitierbarkeit, nicht die Pruefung" — also genau das, was er geschrieben hat.
Der Abschnitt "WO ER ZU WEIT GEHT" widerlegt niemanden; er ist die einzige Stuetze fuer TEILWEISE
und traegt nicht.

AUFWAND ZU KLEIN GERECHNET. Der Fremde verlangt an derselben Stelle :186 nicht nur eine
Konsolenzeile, sondern "eine konkrete psql-Laufausgabe dieser vier Faelle" fuer B_Messungen. Eine
solche Ausgabe entsteht in diesem Repo nirgends: pruefungen/lauf.sh hebt ueberhaupt nur EIN
Protokoll auf, das Serverprotokoll (:617-624), und auch das nur bei FREIRAUM_ECHTVERSAND=ja; ein tee
ueber den Negativfall-Abschnitt gibt es nicht, und in nachweise/ liegt keine Tor-1-Laufausgabe
(geprueft). "4-6 Zeilen in EINER Datei" deckt die Konsolenzeile ab, nicht den vorlagefaehigen Beleg.
Zweitens ist "EINER Datei" auch fuer die anmerkung falsch: werkzeuge/herkunft.py:322 uebernimmt
anmerkung in den Herkunftsgraph — der Postgres-Wortlaut landet also auch in
nachweise/herkunft/herkunft.json, mit derselben Maskierungsfalle.

WAS STIMMT: Alle genannten Fundstellen sind einzeln nachgesehen und exakt — lauf.sh:302-304 (302
`elif printf '%s' "$aus" | grep -qF "$erwartet"`, 303 echo, 304 merke), :306-308 (head -2 der echten
Meldung), merke() :156-163 ohne jede Maskierung (:157 reine Stringverkettung), Serverprotokoll
:617-624. Der erwartete String steht in allen vier Dateien tatsaechlich nur in Zeile 2 und Zeile 4
(nachgezaehlt). Die Manifeste tor1c_260820*.json fuehren durchgehend nur den erwarteten Namen als
anmerkung. Der Maskierungshinweis ist echt und wertvoll. Auch der Zusatzbefund (grep -qF gegen den
ganzen Ausgabestrom statt gegen die ERROR-Zeile) haelt.

**Aufwand.** Klein. 4-6 Zeilen in EINER Datei (pruefungen/lauf.sh:302-304). ACHTUNG FALLE: merke() baut die JSON-
Zeile per Stringverkettung ohne Maskierung (pruefungen/lauf.sh:156-163). Postgres-Meldungen fuehren
Anfuehrungszeichen ('violates check constraint "frist_ge_mindestfrist"') — wer sie ungefiltert in
anmerkung schreibt, zerbricht jedes Manifest. Also entweder maskieren oder nur die Konsolenzeile
ergaenzen. Rechne mit 6-10 Zeilen, wenn die Maskierung mit dazu soll.

**Was zu tun ist.**

1) Im Erfolgszweig die tatsaechliche Meldung mitschreiben, nicht nur den erwarteten Namen — z.B. die
erste ERROR-Zeile aus $aus ziehen und hinter 'scheitert an $erwartet' setzen, damit ein Leser den
Wortlaut zitieren kann, ohne dem Harness zu glauben. 2) Denselben Wortlaut (JSON-maskiert) in die
anmerkung von merke() geben, damit er im Manifest steht und nicht nur auf der Konsole. 3) Optional
und unabhaengig davon: den Riegel in :302 auf die ERROR/DETAIL-Zeile verengen statt auf den ganzen
Ausgabestrom, damit ein NOTICE mit demselben Namen nicht als Treffer durchgeht.

---

### Grund 12 · K04-M08 (Register-Wortlaut: "Nach einem Halt MUESSEN genau drei Auswege erscheinen: Antwort aendern, Gespraech mit der Ansprechperson vereinbaren, zur Uebersicht zurueckkehren.")

| | |
|---|---|
| **Nachgerechnet** | **BESTÄTIGT** |
| **Einordnung** | **ENTSCHEIDUNG** |
| **Berührt den 31.08.** | **ja** |

**Was das Fremdmodell sagt.** "Umgekehrt gibt es mindestens einen Prueffall, der die Klausel staerker erscheinen laesst, als der
Code tatsaechlich ist: VP-18. Der Test wertet K04-M08 als erfuellt, wenn genau ein event mit
TERMIN_ANGEFRAGT entsteht (vorpruefung_lauf.sh:1606-1647). Der Code sagt aber ausdruecklich: Die
Ansprechperson wird nicht aufgeloest, es wird niemand kontaktiert; 'der Wunsch wird vermerkt, die
Zustellung an die Ansprechperson ist ein offener Punkt' (app/vorpruefung.py:1123-1144). Damit
beweist VP-18 'Ereignis vermerkt', nicht 'Gespraech mit der Ansprechperson vereinbart/angestossen'.
Das ist ein verbliebener Messfehler zugunsten des Standes."

**Was am Quelltext gemessen ist.**

SEIN CODEBEFUND STIMMT VOLLSTAENDIG. app/vorpruefung.py:1123 def eignung_termin, Docstring
:1133-1139 woertlich: 'DIE ANSPRECHPERSON WIRD NICHT AUFGELOEST. ... contact gehoert nicht zu dieser
Scheibe und traegt im Pilotbestand keine Zeile; ... Der Wunsch wird vermerkt, die Zustellung an die
Ansprechperson ist ein offener Punkt und wird nicht behauptet.' Der Rumpf :1163-1169 schreibt genau
EIN INSERT in event mit action 'TERMIN_ANGEFRAGT'; kein Lesen von contact, kein Versand. VP-18
(pruefungen/klauseln/vorpruefung_lauf.sh:1606-1647, nur gelesen) behauptet: Status 303, Location auf
/eignung mit termin=1, Ereignis-Delta genau 1, mindestens eines mit Bezug auf den Check, outcome
unveraendert, keine app-Zeile. Kein einziger Satz prueft contact oder eine Zustellung. Insofern:
bestaetigt.

WO SEINE FOLGERUNG ZU WEIT GEHT — zwei Punkte, beide am Quelltext nachgesehen:
(a) 'Er wertet K04-M08 als erfuellt' trifft nicht zu. Der WOERTLICHE MUSS von K04-M08 ('genau drei
Auswege erscheinen') wird von einem ANDEREN Fall gemessen: VP-15,
pruefungen/klauseln/vorpruefung_lauf.sh:1506-1531. Der zaehlt alle drei Wege auf der Halt-Seite ab
(/eignung/aendern, /eignung/termin, /uebersicht) UND weist einen vierten Weg zurueck. VP-18 traegt
K04-M08 also nicht allein; er misst die Wirkung des zweiten Ausweges.
(b) Die Erfolgszeile von VP-18 selbst (:1644) verspricht genau das, was sie misst: 'AUSWEG 2: Termin
— genau ein Ereignis TERMIN_ANGEFRAGT mit Bezug auf den Check, das Ergebnis bleibt unveraendert'.
Kein 'Gespraech vereinbart'. Die Zusicherung ist ehrlich.

WO ER RECHT HAT — UND EINE SCHAERFERE FUNDSTELLE, DIE ER NICHT GENANNT HAT: Der Ueberzug sitzt nicht
im Zusicherungssatz, sondern im ETIKETT. pruefungen/klauseln/vorpruefung_lauf.sh:34, der eigene
Fallindex der Datei, liest: 'VP-18  Ausweg 2  Termin            (Gespraech angestossen, outcome
bleibt)'. 'Gespraech angestossen' ist woertlich der Erfolgszustand des Bildschirmvertrags
(schema/K19_screens.yaml:208 'Gespraech mit der Ansprechperson angestossen (K04-M08)', Serverbefehl
:204 request_contact_appointment) — und woertlich das, was der Code nach seinem eigenen Docstring
NICHT tut. Dasselbe in HANDOVER_260815.md:65 ('Ausweg 2 · Termin | VP-18 | bestanden') unter der
Ueberschrift 'M3 · Die Vorpruefung haelt an — eingetreten'. Wer nur Index und Handover liest, liest
'Gespraech angestossen'. Das ist der Messfehler zugunsten des Standes, und er ist echt.

ZWEI ENTLASTENDE TATSACHEN, DIE ER NICHT SEHEN KONNTE: (1) Das Klauselregister
nachweise/klauselregister/register.json fuehrt K04-M08 mit LEEREN Feldern
test/teststand/ergebnis/evidenz — es beruft sich nirgends auf VP-18. Der Kopf des Blattes sagt
selbst: 'D_Nachweise.txt (Klauselregister, Herkunftsgraph) wurde nicht vorgelegt.' (2) Es gibt eine
gezeichnete Entscheidung zu genau diesem Weg: BEF-M3-3, nachweise/befunde/BEF-M3_260815.md:56-66, M.
Veil hat am 15.08.2026 Lesart A gezeichnet. ABER: sie loest K04-M08 gegen K04-D04 auf (der Termin-
Ausweg ist zulaessig) — sie sagt NICHT, dass der Termin-Ausweg die Ansprechperson nicht aufloesen
muss. Seine Luecke ist von dieser Unterschrift also gerade nicht gedeckt.

**Was die Gegenprobe daran berichtigt hat.**

DIE BEIDEN ENTLASTUNGEN HALTEN AM QUELLTEXT NICHT.
(a) "'Er wertet K04-M08 als erfuellt' trifft nicht zu" ist an der Datei widerlegt, die die
Nachrechnung selbst zitiert. pruefungen/klauseln/vorpruefung_lauf.sh:1607 fuehrt VP-18 im Kopf als
"Wegetabelle + K04-M08 + K19 EN-04 termin", und die Erfolgszeile :1644 endet woertlich "(K04-M08,
Wegetabelle)". VP-18 spricht die Klausel also selbst erfuellt, genau unter der Bedingung, die der
Fremde nennt (Delta 1 bei TERMIN_ANGEFRAGT, :1639-1640). Der Fremde hat nie behauptet, VP-18 trage
K04-M08 ALLEIN; der Hinweis auf VP-15 (:1506-1531, korrekt zitiert) ergaenzt ihn, er widerlegt ihn
nicht.
(b) "Die Zusicherung ist ehrlich" haelt daneben nicht: :1644 traegt die Ueberschrift "AUSWEG 2:
Termin" plus den Klauselstempel K04-M08 auf einer Messung, die nach app/vorpruefung.py:1133-1138
ausdruecklich die Ansprechperson nicht aufloest. Das ist der beanstandete Ueberzug, nicht seine
Widerlegung. Mit (a) und (b) faellt die gesamte Stuetze fuer TEILWEISE weg; die eigenen Zusatzfunde
der Nachrechnung (:34 "Gespraech angestossen", HANDOVER_260815.md:65 unter der Ueberschrift :55
"eingetreten") verstaerken den Fremden nur. Jeder Satz seines Urteils ist am Quelltext bestaetigt.

FALSCHE FUNDSTELLE IM HANDLUNGSTEIL. In Weg (B) heisst es, "der Leerzustand aus K19_screens.yaml:88"
sei zu bauen und zu messen. :88 gehoert nicht zum Halt-Bildschirm: die Bildschirme sind bei "  -
id:" gefuehrt, EN-02 beginnt :63, EN-03 erst :124 — :83-90 ist die Aktion `termin_vereinbaren` auf
EN-02. Der Halt ist EN-04 (:174), und dessen Aktion `termin` traegt ihren Leerzustand :207:
"entfaellt — Verweisaktion ohne Datenbestand". Wer nach Weg B baut, baut gegen die falsche
Vertragszeile. Schaerfer noch: dass der Vertrag am Halt AUSDRUECKLICH keinen Leerzustand vorsieht
(:207) und zwei Zeilen weiter dennoch "Gespraech mit der Ansprechperson angestossen (K04-M08)" als
Erfolgszustand verspricht (:208), ist der eigentliche Widerspruch im Massstab — er bleibt ungenannt.

WAS STIMMT (alles einzeln nachgesehen): app/vorpruefung.py:1123 def eignung_termin, Docstring-
Wortlaut :1133-1138 exakt wie zitiert, der eine INSERT :1163-1169 ohne jeden contact-Zugriff. VP-18
:1606-1647 misst Status/Location/Delta/Bezug/outcome/app und nirgends contact. VP-15 :1506-1531
zaehlt die drei Wege ab und weist einen vierten zurueck. :34 und :1644 im Wortlaut korrekt.
HANDOVER_260815.md:65 korrekt. K19_screens.yaml:204 request_contact_appointment und :208
Erfolgszustand korrekt. register.json fuehrt K04-M08 tatsaechlich mit leeren
test/teststand/ergebnis/evidenz (per json geprueft), Wortlaut der Klausel stimmt. Kopfzeile :25
"D_Nachweise.txt ... wurde nicht vorgelegt" korrekt. BEF-M3_260815.md:56-67: M. Veil zeichnet Lesart
A und loest nur K04-M08 gegen K04-D04 auf — die Luecke ist von dieser Unterschrift wirklich nicht
gedeckt. beruehrt_31_08 stimmt: Weg A engt Tor II auf den Teilschnitt bis zur Anmeldung ein und
stellt M4 bis M12 zurueck (arbeit/Vorlagen/ba1_ba2_handlungsempfehlung_260819.md:28), M3 liegt also
im Umfang. Einordnung ENTSCHEIDUNG bleibt richtig: die Auslegung von "vereinbaren" ist keine
Bauaufgabe.

**Aufwand.** Zwei getrennte Teile. WORTLAUT (klein, ~3 Zeilen in 2 Dateien):
pruefungen/klauseln/vorpruefung_lauf.sh:34 und :1644 sowie HANDOVER_260815.md:65 so umschreiben,
dass sie 'Terminwunsch vermerkt' sagen statt 'Gespraech angestossen'. ACHTUNG: vorpruefung_lauf.sh
gehoert dem blinden Pruef-Agenten — nur er darf dort Hand anlegen, ein Bau-Agent, der die
Zusicherung seines eigenen Pruefers umschreibt, hebt die Trennung auf. SACHE (kein Bau, sondern
Umfang): contact aufloesen und zustellen zieht K11 und eine Zeile in contact in den Teilschnitt, den
der Code ausdruecklich ausserhalb sieht. Nicht schaetzbar, bevor entschieden ist.

**Was zu tun ist.**

ZU ENTSCHEIDEN IST — durch einen Menschen, sinnvollerweise denselben Zeichner wie bei BEF-M3-3 (M.
Veil), weil es dieselbe Klausel in derselben Lesart betrifft:

Gilt K04-M08 'Gespraech mit der Ansprechperson VEREINBAREN' als erfuellt, wenn (i) der Ausweg auf
dem Halt-Bildschirm erscheint und (ii) der Wunsch als Ereignis vermerkt wird, ohne dass contact
aufgeloest oder jemand benachrichtigt wird — oder verlangt die Klausel die Aufloesung der
Ansprechperson und einen Zustellweg?

Je nach Antwort:
(A) 'Vermerken genuegt fuer den Teilschnitt' — dann ist der Bildschirmvertrag
schema/K19_screens.yaml:204-209 fuer diesen Schnitt anzupassen oder ausdruecklich als spaeter
faellig zu markieren (heute verspricht er Serverbefehl request_contact_appointment und
Erfolgszustand 'Gespraech ... angestossen'), und die drei Etiketten oben sind auf den gemessenen
Sachverhalt zurueckzunehmen. Danach ist Grund 12 ein reiner Wortlautfehler.
(B) 'Die Klausel verlangt mehr' — dann faellt contact/K11 in den Teilschnitt, der Pilotbestand
braucht eine contact-Zeile, und der Leerzustand aus K19_screens.yaml:88 ('keine gueltige
Ansprechperson hinterlegt — statt der Schaltflaeche ein Hinweis mit dem Ersatzweg') ist zu bauen und
zu messen. Das ist Umfang, kein Bugfix.

UNABHAENGIG VON DER ENTSCHEIDUNG ist eine Auflage moeglich: VP-18 um eine NEGATIVE Zusicherung
ergaenzen ('es entsteht keine Zustellung, contact wird nicht gelesen'), damit der Fall nicht nur
nicht zu viel verspricht, sondern die Luecke selbst festhaelt. Auch das liegt in der Hand des
blinden Pruef-Agenten.

---

## Was der Harness ohne Zeichnung sofort tun kann

| | | Aufwand |
|---|---|---|
| **a** | `app/datenbank.py`: die drei veralteten Selbstauskünfte berichtigen | ~5 Zeilen, 1 Datei |
| **b** | `pruefungen/lauf.sh`: im Erfolgszweig die tatsächliche Fehlermeldung mitschreiben — **Vorsicht**, `merke()` baut die JSON-Zeile ohne Maskierung (`:156-163`), und Postgres-Meldungen führen Anführungszeichen | 4–6 Zeilen, 1 Datei · *`pruefungen/` — braucht eine Weisung* |
| **c** | `app/vorpruefung.py:252-254`: die Quittung *„Ihre Ansprechperson meldet sich bei Ihnen"* ehrlich machen — sie wird nicht eingelöst, und das steht im selben Modul | 2–3 Zeilen, 1 Datei |

## Was ein Mensch entscheiden muss — die zehn, nach Dringlichkeit

**Sofort, weil sie den 31.08. tragen:**

1. **Grund 8** — Wird der Teilschnitt mit ungeschützter Mandantengrenze abgenommen? RR-04 ist
   gezeichnet, deckt aber **1 von 22** Stellen. Für die übrigen 21 gibt es heute keinen
   getragenen Eintrag.
2. **Grund 1** — Gilt die am 19.08. gezeichnete Auslegung *„die Mitgliedschaft ist die Rolle"*
   (T-4) auch für den Teilschnitt? Bisher nur für den Stufenwechsel aus M5 gezeichnet.
   **Und: wer ist fachlicher Eigentümer von K13-M05?** Das Feld ist leer.
3. **Grund 7** — `retention_class` bei `event`: **BETRIEBSPROTOKOLL** (K20-M25) oder
   **EREIGNIS** (K02-M17, Beschluss Nr. 60)? Die Sachentscheidung ist am 04.08. gefallen und
   am 16.08. bestätigt — **es fehlt nur die Zuordnung**, nicht die Entscheidung.
4. **Grund 4** — Gilt die Adress-Eindeutigkeit plattformweit oder je Mandant? Solange
   plattformweit, ist die Existenz eines fremden Kontos von außen ableitbar, und **kein
   Wortlaut ändert daran etwas**. Die Entscheidungsvorlage liegt seit dem **14.08.**
   ungezeichnet: `arbeit/Vorlagen/entscheidung_einladung_mandantengrenze_260814.md`.
5. **Grund 2** — Fällt das Ausnahmekonto Nr. 59 (`mfa_method = OFF`, M30:988-993) unter
   K03-D10, oder bleibt es? Danach sind es drei Zeilen Code.
6. **Grund 3** — Bekommt der Nutzer beim fehlenden Versandweg eine **eigene** Meldung? Die
   Frage steht seit dem 14.08. im Quelltext (`app/einladung.py:414-425`).

**Ebenfalls vor dem 31.08., aber kleiner:**

7. **Grund 5** — M-14 zeichnen (Key Vault in `swedencentral`; der vorhandene liegt in
   `westeurope` und bräche F05), und: wer wird alarmiert, wohin, welches Runbook?
8. **Grund 6** — Ist ein `login_code` „Zugang" im Sinne von K20-M18? Der Klauselwortlaut sagt
   nichts dazu, ein gezeichnetes Kriterium fehlt.
9. **Grund 12** — Gilt K04-M08 *„Gespräch vereinbaren"* als erfüllt, wenn der Wunsch nur
   vermerkt wird? Dieselbe Lesart wie BEF-M3-3.

**Nach dem 31.08. (nicht im Teilschnitt):**

10. **Grund 10** — Was heißt *„der Produktivweg bleibt gesperrt"* bei K04-G11: ein
    Betriebsbeleg oder ein Riegel im Code? Und die Kritikalität ist ungezeichnet — das Feld
    `eigentuemer` in `register.json:3712` ist leer, und **K23-G08 verbietet dem Harness, sie
    selbst zu setzen.**

---

*Erstellt am 20.08.2026. Zwölf Gründe, paarweise nachgerechnet, jede Nachrechnung von einem
eigenen Prüfer mit dem Auftrag gegengelesen, sie zu widerlegen. Alle sechs Gegenproben haben
angeschlagen; die Berichtigungen stehen bei jedem Grund im Text. **Der Harness stellt hier
fest, was gemessen ist — er entscheidet keinen der zehn Punkte.**