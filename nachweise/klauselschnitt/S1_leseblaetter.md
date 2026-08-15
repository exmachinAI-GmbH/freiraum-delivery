# Leseblätter zum Faden der Scheibe 1

> **Dies ist Lesematerial, keine Zuordnung.** Kein Eintrag sagt, dass eine Regel zu
> Scheibe 1 gehört. Er sagt, dass ihr Wortlaut ein Wort der genannten Station des
> gezeichneten Fadens enthält. Was daraus folgt, entscheidet ein Mensch.

Grundlage: Anlage Baustrategie, Fadendiagramm Zeilen 52–70, gezeichnet 05.08.2026.
Die Regeln sind nach Sache gebündelt, nicht alphabetisch — sonst wären sie unlesbar.

## Übersicht

| Station | Zeile im Faden | Regeln | Bündel |
|---|---|---:|---:|
| [Mandant](#mandant) | EXMA-Minimum: Mandant anlegen (BS:53) | 106 | 16 |
| [Einladungsschranke](#einladungsschranke) | EXMA-Minimum: ... Einladungsschranke (BS:53) | 4 | 3 |
| [Einladung](#einladung) | EXMA-Minimum: ... Einladung senden (BS:53) | 34 | 10 |
| [Vorpruefung](#vorpruefung) | Vorpruefung: ein geeigneter Fall -> GEEIGNET (BS:57) | 8 | 4 |
| [geeignet](#geeignet) | ... ein geeigneter Fall -> GEEIGNET (BS:57) | 8 | 5 |
| [Zweckbestimmung](#zweckbestimmung) | ZWECKBESTIMMUNG bestaetigt (Riegel) (BS:59) | 2 | 2 |
| [Anwendung](#anwendung) | create_app_after_fit -- der EINE Weg (BS:61) | 99 | 16 |
| [Gespraech](#gespraech) | ein Gespraechspfad (Stufen 01-02) (BS:63) | 42 | 13 |
| [Anforderungen](#anforderungen) | ... > Anforderungen/Vertrag (Stufe 03) (BS:63) | 15 | 6 |
| [Vertrag](#vertrag) | ... Anforderungen/Vertrag (Stufe 03) (BS:63) | 34 | 7 |
| [Prototyp](#prototyp) | Prototyp aus EINER freigegebenen Vorlage (BS:65) | 42 | 10 |
| [Vorlage](#vorlage) | ... aus EINER freigegebenen Vorlage (Stufe 04) (BS:65) | 40 | 9 |
| [Angebot](#angebot) | Angebot, Stufe 05 (BS:67) | 40 | 8 |
| [Haekchen](#haekchen) | UNTERSCHRIFT + BEIDE HAEKCHEN (BS:67) | 13 | 6 |
| [Siegel](#siegel) | ... > SIEGEL (Riegel) (BS:67) | 23 | 7 |
| [Uebergabe](#uebergabe) | das Uebergabe-Paket (BS:69) | 31 | 8 |
| [Manifest](#manifest) | ... mit Manifest- und Archivpruefsumme (BS:69) | 12 | 5 |
| [Pruefsumme](#pruefsumme) | ... Manifest- und Archivpruefsumme (BS:69) | 7 | 5 |

---

## Mandant

*EXMA-Minimum: Mandant anlegen* — BS:53 · **106 Regeln**

**Anmerkung:** So liest sich eine Kennung: der vordere Teil (K01, K02, K03 ...) ist das Regelbuch, aus dem die Regel stammt - K02 ist das "Fundament", in dem der Mandant zu Hause ist, K03 die Anmeldung, K13 die Architektur, K23 die Tests. Der Buchstabe dahinter sagt die Art: M = MUSS, G = GILT, D = DARF NICHT; die Zahl ist nur die laufende Nummer im Regelbuch. "Mandant" meint durchgehend: eine Firma mit einem eigenen, abgeschlossenen Bereich im System. "RLS" meint Regeln in der Datenbank selbst, die fuer jede einzelne Zeile entscheiden, wer sie sehen darf. Ein "Serverpfad" ist der Weg ueber das Programm auf dem Server, im Unterschied zu einer Pruefung, die nur in der Bildschirmoberflaeche stattfindet. || Hinweis zum Wort "Vertrag": K02-M29 und K02-M30 (mit der Ausnahme K02-G17) sprechen nicht vom Projektvertrag der Stufe 03, sondern vom Auftragsverarbeitungsvertrag nach Datenschutzrecht - ein anderes Dokument. K02-M30 wirkt allerdings unmittelbar auf den Beginn eines Gespraechs. || Hinweis zu Nebentreffern: bei einigen Regeln taucht das Wort "Mandant" nur als Nebenbedingung eines ganz anderen Themas auf - K23-M10, K23-M11, K23-M12 und K23-M23 (Lastpruefung, also Geschwindigkeit unter vielen gleichzeitigen Nutzern), K08-M31 (Nachweisfelder fuer Wissensquellen), K17-G12 (plattformweiter Agenten-Katalog), K25-G14 (mehrere gleichzeitig laufende Prototyp-Umgebungen) und K25-M22 (der Auswahlvermerk fuehrt den Mandantenbezug nur als eines von rund fuenfzehn Feldern). K02-G15 ist reine Zahlenauskunft zum Namensraum der Codes. || Hinweis zu Luecken, die die Regeln selbst benennen: K02-M29 und K02-M31 beschreiben etwas, wofuer das Datenmodell heute kein Feld hat, und verweisen auf offene Auftraege (O-K02-11 bzw. O-K02-12); K02-M29 haelt zusaetzlich fest, dass der Produktivbetrieb bis dahin gesperrt bleibt. K14-G05 nennt ebenfalls einen offenen Punkt (O-K14-2). K03-M19 ist ausdruecklich als berichtigt gekennzeichnet (Beschluss S28 vom 02.08.2026) und legt fest, dass die Schranke des Ziel-, nicht des Absendermandanten gilt; sie ist zusammen mit K20-M10 zu lesen.

### Welche Angaben ein Mandant zwingend traegt (Art, Name, Rechtsraum)

**K02-M02** · MUSS — Jede Firma bekommt beim Anlegen genau eine von drei Arten - Betreiber, Kunde oder Partner - und eine vierte gibt es nicht.

> Jeder Mandant MUSS eine Art tragen: Betreiber, Kunde oder Partner. Ein vierter Wert ist nicht vorgesehen.

**K02-M03** · MUSS — Der Firmenname ist Pflicht und ist das, was am Bildschirm als Name der Firma erscheint.

> Jeder Mandant MUSS einen Namen tragen. Das Feld ist Pflicht und wird in der Oberfläche als Firmenname geführt.

**K02-M07** · MUSS — Jede Firma bekommt die Angabe, nach welchem Landesrecht sie gefuehrt wird; im ersten Bau ist nur Deutschland (DE) erlaubt, die anderen Werte sind zwar vorgesehen, aber gesperrt.

> Jeder Mandant MUSS einen Rechtsraum tragen. Für Release 1 ist allein DE zulässig (F35); die übrigen Werte bleiben modelliert.

**K02-D07** · DARF NICHT — Eine Firma ohne Rechtsraum darf es nicht geben - auch nicht kurz waehrend des Anlegens.

> Ein Mandant DARF NICHT ohne Rechtsraum bestehen. Ein leeres Feld ist kein zulässiger Übergangszustand.

### Der Kunden-Code: wie er entsteht, was er bedeutet, wo Testmandanten sitzen

**K02-M04** · MUSS — Eine Kundenfirma braucht zwingend einen Kunden-Code; eine Regel in der Datenbank namens customer_needs_code laesst gar nichts anderes zu.

> Ein Mandant der Art Kunde MUSS einen Kunden-Code tragen. Durchgesetzt von der Bedingung `customer_needs_code`.

**K02-M06** · MUSS — Denselben Kunden-Code gibt es im ganzen System nur ein einziges Mal.

> Der Kunden-Code MUSS plattformweit eindeutig sein. Zwei Mandanten teilen ihn nie.

**K02-D10** · DARF NICHT — Niemand tippt den Code ein oder sucht ihn aus, und er wird auch nicht aus dem Firmennamen gebildet - er wird vergeben.

> Der Kunden-Code DARF NICHT eingegeben, gewählt oder aus dem Namen des Mandanten abgeleitet werden.

**K02-M26** · MUSS — Der Code wird vom Server im selben, unteilbaren Arbeitsschritt vergeben, in dem die Firma angelegt wird; klappt die Vergabe nicht, entsteht auch keine Firma.

> Die Vergabe MUSS serverseitig und in derselben Transaktion wie die Anlage des Mandanten erfolgen. Schlägt sie fehl, entsteht kein Mandant.

**K02-G14** · GILT — Der Code ist eine reine Kennung ohne Aussagekraft; wer wissen will, um welche Firma es geht, liest den Namen.

> Es GILT: Der Kunden-Code trägt keine Bedeutung. Lesbar ist der Name des Mandanten; der Code ist ein Bezug, kein Kürzel.

**K02-G16** · GILT — Beginnt der Code mit einem Z, ist die Firma eine Testfirma; ein eigenes Feld "Test ja/nein" gibt es nicht.

> Es GILT: Ein Mandant, dessen Code mit `Z` beginnt, ist ein Testmandant. Das Merkmal steht im Code selbst; ein zusätzliches Feld entsteht dafür nicht.

**K02-D11** · DARF NICHT — Ein Code aus dem Testbereich darf nie an eine Firma gehen, in der echte Kundendaten liegen.

> Ein Code des Namensraums `DE-Z..` DARF NICHT an einen Mandanten vergeben werden, der echte Kundendaten führt.

**K02-G15** · GILT — Von den rechnerisch moeglichen Drei-Buchstaben-Codes sind 676 fuer Tests reserviert, 16 900 bleiben fuer echte Kunden.

> Es GILT: Der reservierte Namensraum umfasst 676 der 17 576 möglichen Codes. Für Kundenmandanten bleiben 16 900.

**K01-M35** · MUSS — Die drei Grossbuchstaben in einer Projektnummer sind genau der Kunden-Code der Firma; die Projektnummer erfindet keine eigenen Buchstaben.

> Die drei Großbuchstaben MÜSSEN der Kunden-Code des tragenden Mandanten sein (Eigentümer K02). Die Projektnummer bildet keinen eigenen Buchstabencode.

### Wo verarbeitet wird: Rechtsraum, Region und Datenlokalitaet

**K02-M08** · MUSS — Jede Firma traegt die Angabe, in welchem Rechenzentrumsgebiet ihre Daten verarbeitet werden; vorgesehen und im ersten Bau allein zulaessig ist swedencentral (Schweden, EU).

> Jeder Mandant MUSS eine Verarbeitungsregion tragen. Vorgabe ist `swedencentral`; Release 1 verarbeitet ausschließlich dort (K13 Abschn. 3).

**K02-G05** · GILT — Die Region haengt an der Firma; ein einzelner Nutzer kann sie nicht umstellen.

> Es GILT: Die Verarbeitungsregion ist eine Eigenschaft der Plattform je Mandant, nicht eine Einstellung des einzelnen Nutzers.

**K01-M23** · MUSS — Jeder Kunde hat genau einen Rechtsraum, und verarbeitet wird in der EU; beide Angaben haengen an der Firma.

> Jeder Kunde MUSS genau einen Rechtsraum aus `legal_space` tragen, und die Verarbeitung MUSS in der EU stattfinden, Vorgabe `swedencentral` (F05). Beide Werte liegen am Mandanten und werden von K02 ausgeführt.

**K12-M02** · MUSS — Die Region darf nur aus einer festen, geprueften Liste an der Firma kommen und wird zusaetzlich gegen die Zusage geprueft, wo Daten liegen duerfen.

> Die Region MUSS aus der geprüften Werteliste am Mandanten stammen (Eigentümer K02) und gegen die Datenlokalität geprüft werden (Eigentümer K13).

**K12-M12** · MUSS — Eine Prototyp-Vorschau gibt es nur fuer Firmen mit der Region swedencentral; andere Regionen werden mit Begruendung gesperrt statt umgeleitet.

> Release 1 liefert Vorschauen nur für Mandanten mit `processing_region = swedencentral`. Andere modellierte Regionen erhalten eine begründete Sperre und keine Ausweichregion.

**K13-G04** · GILT — Die Zusage, wo Daten liegen, steht an der Oberflaeche (dem Portal) und nicht an der einzelnen Firma.

> Es GILT: `portal.data_locality` trägt die Zusage der Datenlokalität mit der Vorgabe `EU-Azure/swedencentral`. Sie ist eine Angabe je Portal, nicht je Mandant.

### Die drei Arten von Mandanten: Betreiber, Kunde, Partner

**K02-D12** · DARF NICHT — Das Kennzeichen fuer die Partner-Aufgabe (bauen / umsetzen) darf nur bei Partnern stehen, nie bei Betreiber oder Kunde.

> Ein Mandant der Art Betreiber oder Kunde DARF NICHT ein solches Kennzeichen tragen.

**K02-M31** · MUSS — Bei einem Partner muss erkennbar sein, ob er die Anwendung baut, sie beim Kunden einfuehrt oder beides - ein Feld dafuer fehlt heute und ist als offener Auftrag O-K02-12 notiert.

> Ein Mandant der Art Partner MUSS erkennen lassen, ob er die Anwendung **baut**, sie beim Kunden **umsetzt**, oder beides.

**K10-G10** · GILT — "Umsetzungspartner" ist der Sammelbegriff; unterschieden wird nach der Aufgabe, nicht durch eine eigene Mandantenart.

> Es GILT: *Umsetzungspartner* ist der Oberbegriff für beide Firmen. Unterschieden werden sie durch ihre Aufgabe am Partner-Mandanten (Eigentümer K02), nie durch die Art des Mandanten.

**K10-M35** · MUSS — Eine Uebergabe geht immer an genau eine Partnerfirma mit erkennbarer Aufgabe; ohne benannten Empfaenger findet sie nicht statt.

> Jede Übergabe MUSS genau einen Empfänger benennen: einen Mandanten der Art Partner mit erkennbarer Aufgabe. Ohne benannten Empfänger entsteht keine Übergabe.

**K20-G11** · GILT — Der Plattform-Admin sitzt im Betreiber-Mandanten, und dieser Geltungsbereich reicht ausdruecklich ueber alle Firmen hinweg, ohne dass er bei jedem Kunden eigens Mitglied sein muesste.

> Es GILT: Die Reichweite des Plattform-Admins ist der Betreiber-Mandant mit `tenant_kind = OPERATOR`. Sie ist eine Angabe je Mitgliedschaft, keine Eigenschaft der Rolle. **Dieser Geltungsbereich bedeutet ausdrücklich „Plattform, alle Mandanten"**

### Einladungsschranke und Einladungsfrist stehen am Mandanten

**K02-G06** · GILT — Frist und Domaenenschranke sind Eigenschaften der Firma und werden deshalb dort gespeichert, nicht bei der einzelnen Einladung.

> Es GILT: Einladungsfrist und Einladungsschranke stehen am Mandanten, weil sie Eigenschaften der einladenden Organisation sind. Das Verfahren dahinter gehört K20.

**K20-G08** · GILT — Aendert man die Frist an der Firma, gilt das nur fuer kuenftige Einladungen, nicht rueckwirkend fuer bereits versandte.

> Es GILT: Schranke und Frist stehen am Mandanten, nicht in der Einladung (Eigentümer K02). Ändert sich die Frist, wirkt sie auf künftige Einladungen, nicht rückwirkend.

**K03-M22** · MUSS — Die erlaubte E-Mail-Domaene setzt allein der Betreiber beim Anlegen der Firma, und er muss dabei ausdruecklich entscheiden - auch "keine Schranke" ist eine zu vermerkende Entscheidung, kein Leerlassen.

> Die Einladungsschranke setzt allein der Betreiber, indem er den Mandanten anlegt. Bei jeder Anlage MUSS über sie entschieden werden: entweder die Domäne des Kunden oder ausdrücklich keine Schranke; die Wahl ist zu vermerken.

**K03-M23** · MUSS — Bevor die erste Einladung rausgeht, muss eine nachweisbare Entscheidung zur Domaene vorliegen, mit Firma, Entscheider, Zeitpunkt und Begruendung; ein leeres Feld beweist nichts.

> Vor der ersten Einladung MUSS für den **Zielmandanten** eine explizite Entscheidung „Domäne beschränken“ oder „bewusst unbeschränkt“ vorliegen. Der Nachweis führt Zielmandant, Entscheider, Zeitpunkt und Begründung.

**K03-M19** · MUSS — Geprueft wird die Schranke der Firma, in die eingeladen wird, nicht die des Absenders; ein neuer Einmal-Link entwertet die frueheren.

> Geprüft wird die Einladungsschranke des Mandanten, zu dem das **eingeladene Konto** gehört — nicht die des einladenden. Bei einer Einladung über die Mandantengrenze hinweg gilt damit die Schranke des Ziels.

**K03-M24** · MUSS — Der Server vergleicht den Teil der E-Mail-Adresse hinter dem @ ganz genau mit der hinterlegten Domaene der Zielfirma; aehnlich klingende oder untergeordnete Adressen bestehen den Vergleich nicht.

> Bei „Domäne beschränken“ extrahiert und normalisiert der Server den Domänenteil der eingeladenen Adresse (Trimmen, Kleinschreibung und idna-A-Label) und vergleicht ihn **exakt** mit der ebenso normalisierten Zielmandanten-Domäne.

**K03-M25** · MUSS — Das Versenden laeuft ueber einen Serverbefehl, der Zielfirma, Entscheidungsnachweis und Domaene prueft und Einladung samt Protokolleintrag in einem Zug anlegt; kein anderer Weg darf daran vorbei.

> Ein serverseitiger, idempotenter Einladungsbefehl prüft Zielmandant, Entscheidungsnachweis und Domäne und legt Einladung und Ereignis atomar an. Portal, Builder und Service-Schlüssel dürfen diese Prüfung nicht umgehen.

**K20-M10** · MUSS — Solange eine Domaenenschranke gesetzt ist, muss die eingeladene Adresse darin liegen, sonst weist der Server ab.

> Die Adresse MUSS in der Domänenschranke des Mandanten liegen, solange eine gesetzt ist. Der Wächter weist sonst ab; belegt durch T7.

**K03-M07** · MUSS — Der einmalige Einladungslink verfaellt nach 24 Stunden; die Frist selbst ist eine Angabe an der Firma.

> Der Einmal-Link MUSS nach 24 Stunden verfallen (F11). Die Frist steht am Mandanten (Eigentümer K02), der Einladungssatz gehört K20.

**K20-M11** · MUSS — Der Ablaufzeitpunkt einer Einladung liegt nach dem Versand und haelt die an der Firma hinterlegte Frist ein.

> Der Ablaufzeitpunkt MUSS nach dem Versandzeitpunkt liegen (`invitation_frist`) und die Frist des Mandanten einhalten. Vorgabe sind 24 Stunden (F11); belegt durch T8 und T19.

**K19-G08** · GILT — Die am Bildschirm gezeigten 24 Stunden sind nur die Anzeige der Firmenvorgabe, die zwischen 1 und 168 Stunden liegen darf; steht dort etwas anderes, folgt der Text.

> Es GILT: die Angabe 24 Stunden ist die Anzeige der Mandantenvorgabe im Werteband 1 bis 168 Stunden (F11, Eigentümer K02). Weicht die Vorgabe ab, folgt der Anzeigetext ihr.

### Die zweite Anmeldestufe als Regel der Firma

**K02-M09** · MUSS — Jede Firma traegt eine fuer alle ihre Nutzer geltende Regel, wie die zweite Anmeldestufe laeuft; vorgesehen ist ein Code per E-Mail.

> Jeder Mandant MUSS eine organisationsweite Richtlinie zur zweiten Anmeldestufe tragen. Vorgabe ist der Code per E-Mail; das Verfahren führt K03.

**K03-G03** · GILT — Das Feld fuer diese Regel gehoert zur Firma; wie die Anmeldung dann konkret ablaeuft, steht in einem anderen Regelbuch.

> Es GILT: Die organisationsweite Richtlinie zur zweiten Stufe liegt am Mandanten (Eigentümer K02, dort Abschn. 3). K03 führt das Verfahren, nicht das Feld.

**K03-D10** · DARF NICHT — Die zweite Anmeldestufe darf nicht abgeschaltet werden - weder beim einzelnen Konto noch als Regel der Firma; der Server weist den Versuch ab und protokolliert ihn.

> Der zweite Faktor DARF NICHT abgeschaltet werden. Der abschaltende Wert von `mfa_method` ist in Release 1 kein zulässiger Betriebszustand — weder am Konto noch als Richtlinie des Mandanten (Eigentümer K02).

### Die Mandantengrenze: fremde Daten gelten als nicht vorhanden

**K01-M15** · MUSS — Wer angemeldet ist, sieht und aendert nur Daten der eigenen Firma; alles andere verhaelt sich, als gaebe es es nicht.

> Jeder Lese- und Schreibzugriff MUSS auf den Mandanten der angemeldeten Sitzung eingeschränkt sein. Ein Objekt eines fremden Mandanten gilt als nicht vorhanden (Mandantenschnitt K02).

**K14-M12** · MUSS — Dieselbe Beschraenkung noch einmal, mit der Zusatzforderung, dass sie doppelt greift - im Programm und in der Datenbank; bis beides belegt ist, ist die Datenbank nicht direkt erreichbar.

> Jeder Lese- und Schreibzugriff MUSS auf den Mandanten der angemeldeten Sitzung eingeschränkt sein — doppelt: serverseitige Autorisierung und Regeln im Datenbestand. Bis beide nachgewiesen sind, bleibt das Schema server-only (K01 Abschn. 3).

**K01-D08** · DARF NICHT — Kein Bildschirm, keine Liste, kein Datenexport und keine Anfrage an ein Sprachmodell darf Daten zweier Firmen zusammenbringen - auch keine Summen oder Durchschnitte.

> Kein Bildschirm, keine Liste, keine Ausleitung und keine Modellanfrage DARF Daten zweier Mandanten zusammenführen. Auch verdichtete Kennzahlen über die Mandantengrenze hinweg sind untersagt (K02).

**K14-D07** · DARF NICHT — Dasselbe Verbot noch einmal aus dem Sicherheits-Regelbuch: keine Zusammenfuehrung von Daten zweier Firmen, auch nicht verdichtet.

> Kein Bildschirm, keine Liste, keine Ausfuhr und keine Modellanfrage DARF Daten zweier Mandanten zusammenführen. Auch verdichtete Kennzahlen über die Mandantengrenze hinweg sind untersagt.

**K02-D05** · DARF NICHT — Daten einer fremden Firma duerfen weder angezeigt noch gezaehlt noch in einer Summe sichtbar werden.

> Ein Bestand eines fremden Mandanten DARF NICHT sichtbar, zählbar oder verdichtet erreichbar sein. Er gilt als nicht vorhanden.

**K04-D08** · DARF NICHT — Die Vorpruefung einer fremden Firma ist weder einsehbar noch aenderbar.

> Ein Eignungs-Check eines fremden Mandanten DARF NICHT sichtbar oder änderbar sein; er gilt als nicht vorhanden (Mandantenschnitt K02).

**K07-D08** · DARF NICHT — Prototyp-Bestaende einer fremden Firma duerfen weder angezeigt noch heruntergeladen werden.

> Ein Bestand eines fremden Mandanten DARF NICHT sichtbar oder ladbar sein; er gilt als nicht vorhanden.

**K16-G11** · GILT — Auch die blosse Anzeige eines Bearbeitungsstands ist an die eigene Firma gebunden.

> Es GILT: Die Anzeige eines Zustands ist mandantengebunden wie jede andere Anzeige. Ein fremder Bestand gilt als nicht vorhanden (K02).

**K17-D13** · DARF NICHT — Auch ein automatisch arbeitender Software-Agent darf Daten zweier Firmen nicht mischen, nicht einmal als Beispiel in einer Eingabe.

> Ein Agent DARF Daten zweier Mandanten NICHT zusammenführen — auch nicht verdichtet und auch nicht als Beispiel in einer Eingabe (K02 Abschn. 3).

**K14-D10** · DARF NICHT — Es gibt keinen Notfall-Zugang, der die Firmengrenze aushebelt - auch bei einer Stoerung nicht.

> Es DARF keinen Ausnahmezugang geben, der die Rollentrennung, die Mandantengrenze oder die Maskierung umgeht. Auch ein Betriebsvorfall hebt keine dieser drei Sperren auf.

**K17-G12** · GILT — Der Agenten-Katalog gilt fuer die ganze Plattform und gehoert keiner Firma; getrennt werden nur die Kundendaten.

> Es GILT: Der Katalog trägt keinen Mandantenbezug; er ist plattformweit. Die Trennung der Kundendaten liegt im Serverpfad und im Datenbestand (K13 Abschn. 3).

**K25-G14** · GILT — Laufen mehrere Prototyp-Umgebungen parallel, folgt ihre Trennung derselben Firmentrennung wie beim Hosting.

> Es GILT: Mehrere Hüllen laufen gleichzeitig. Ihre Trennung folgt der Mandantentrennung des Hostings (K12, K13).

### Doppelte Durchsetzung: Serverpfad und Datenbank-Regeln (RLS)

**K02-M20** · MUSS — Die Firmengrenze wird zweimal durchgesetzt: einmal im Programm auf dem Server und einmal in der Datenbank selbst.

> Die Mandantengrenze MUSS zweifach durchgesetzt werden — im Serverpfad und im Datenbestand, nach K13 Abschn. 3.

**K13-M08** · MUSS — Dieselbe Doppelung, mit der Begruendung: faellt eine der beiden Ebenen aus, haelt die andere noch.

> Die Mandantengrenze MUSS zweifach durchgesetzt werden: im Serverpfad durch Autorisierung und im Datenbestand durch Policies. Fällt eine Ebene aus, hält die andere.

**K13-D09** · DARF NICHT — Ein Datenweg im Echtbetrieb darf sich nicht allein auf die Pruefung im Programmcode verlassen; die zweite Schicht in der Datenbank ist Bedingung fuer den Start.

> Ein produktiver Datenpfad DARF NICHT allein durch Autorisierung im Servercode geschützt sein. Die zweite Mandantenschutzschicht aus RLS ist ein Produktionsgate.

**K13-M05** · MUSS — Jeder Klick am Bildschirm laeuft ueber den Server, der vorher Konto, Mitgliedschaft, Rolle, Firma und Objektbezug prueft.

> Jeder Aufruf aus einer Oberfläche MUSS über den Serverpfad laufen. Der Serverpfad prüft aktives Konto, Mitgliedschaft, Rolle, Mandant und Objektbezug, bevor er liest oder schreibt.

**K13-M07** · MUSS — Bevor eine Datenschnittstelle direkt erreichbar wird, muessen Datenbankregeln fuer Lesen, Anlegen, Aendern und Loeschen aktiv sein - belegt durch einen Test mit zwei Firmen je Vorgangsart.

> Vor jeder Exposition über eine unmittelbar erreichbare Datenschnittstelle MÜSSEN RLS-Policies für SELECT, INSERT, UPDATE und DELETE aktiv sein. Der Nachweis erfolgt über einen Zwei-Mandanten-Negativtest je Vorgangsart.

**K13-M16** · MUSS — Vor dem Echtbetrieb gelten diese Datenbankregeln fuer alle firmenbezogenen Tabellen und Ansichten, geprueft auf allen drei Ebenen - Oberflaeche, Schnittstelle, Datenbank.

> Vor jedem Produktivbetrieb MÜSSEN RLS-Policies für alle mandantenbezogenen Tabellen und Sichten aktiv sein. UI-, API- und DB-Negativtests prüfen zwei Mandanten, Rollen, Objektbezug und privilegierte Bypass-Rollen.

**K01-M30** · MUSS — Ohne nachgewiesene Datenbankregeln bleibt die Datenbank nur ueber den Server erreichbar und nicht direkt.

> Vor jeder Exposition über eine Supabase Data API MÜSSEN RLS-Policies für SELECT, INSERT, UPDATE und DELETE aktiv sein. Sie prüfen aktives Konto, Mitgliedschaft, Rolle, Mandant und Objekt.

**K02-G12** · GILT — Solange die offenen Punkte nicht belegt sind, bleibt die Datenbank nur ueber den Server erreichbar; ein Vorgang, bei dem sich die Firma nicht bestimmen laesst, ist nie erlaubt.

> Es GILT: Bis O-K02-6 und die Datenbestandsregeln aus K13 belegt sind, bleibt das Schema server-only. Ein mandantengebundener Vorgang ohne auflösbaren Mandantenbezug ist kein zulässiger Übergangszustand.

**K05-M24** · MUSS — Auch die Aufrufe im gefuehrten Gespraech (Stufen 01 und 02) laufen ueber diesen pruefenden Serverweg.

> Jeder Aufruf aus den Stufen 01 und 02 MUSS über den Serverpfad laufen, der Konto, Mitgliedschaft, Rolle, Mandant und Objektbezug prüft (K13 Abschn. 3).

**K06-M26** · MUSS — Auch die Aufrufe der Stufe 03 (Anforderungen und Vertrag) laufen ueber diesen pruefenden Serverweg.

> Jeder Aufruf der Stufe 03 MUSS über den Serverpfad laufen, der Konto, Mitgliedschaft, Rolle, Mandant und Objektbezug prüft (K13 Abschn. 3).

**K05-M27** · MUSS — Zu welcher Firma ein Dokument gehoert, wird nur ueber die zugehoerige Anwendung bestimmt; Dateien sind nur ueber kurzlebige, gepruefte Zugriffe erreichbar.

> RLS und Serverpfad leiten den Mandanten ausschließlich über `document.app_id → app.tenant_id` ab. Zwei-Mandanten- und Zwei-Anwendungs-Negativtests sind Produktionsgate.

**K07-M19** · MUSS — Jede Aenderung am Prototyp laeuft als Serverbefehl, der Konto, Firma, erwarteten Stand und erlaubten Bereich prueft; scheitert ein Teil, bleibt alles unveraendert.

> Jede Änderung läuft als revisionsgebundener, idempotenter Server-Command. Er prüft angemeldetes Konto, Mandant, erwartete Revision und den erlaubten UI-Scope.

**K07-M22** · MUSS — Laden, Teilen und Entfernen pruefen bei jedem einzelnen Aufruf Konto, Firma und Zustand des Objekts; eine erratene Kennung bekommt die Antwort "nicht vorhanden".

> Laden, Teilen und Entfernen prüfen bei jedem Aufruf serverseitig Konto, Mandant und Objektstatus. Ablage und Metadaten sind privat und RLS-geschützt; fremde oder erratene Kennungen antworten wie nicht vorhanden.

**K08-M22** · MUSS — Bei projektbezogenen Wissensquellen pruefen Server und Datenbank Firma und Anwendung; ein technischer Schluessel darf diese Grenze nicht umgehen.

> RLS und Serverpfad prüfen bei Projektquellen Mandant und Anwendung. Globale Quellen sind nur nach Plattformfreigabe lesbar. Ein Service- oder Builder-Schlüssel darf diese Grenze nicht umgehen.

**K08-M31** · MUSS — Der Nachweis zu einer Wissensquelle bindet viele Angaben zusammen; die Firmengrenze taucht darin nur als Nebenbedingung fuer technische Rollen auf.

> Quelltext wird im Nachweis minimiert; Service-Rollen dürfen Mandanten-, Projekt- und RLS-Grenzen nicht umgehen.

**K11-G05** · GILT — Die Uebersicht app_state_aktuell ist nur eine Leseansicht ohne eigenen Firmenbezug; die Grenze zieht der Server.

> Es GILT: `app_state_aktuell` ist eine Lesesicht auf Anwendung, Zustand und Beginn — kein Schreibschutz, ohne eigenen Mandantenbezug; die Grenze zieht der Serverpfad (K13 Abschn. 3).

**K11-M27** · MUSS — Diese Uebersicht bleibt fuer direkte Zugriffe gesperrt oder erbt die Datenbankregeln der zugrunde liegenden Tabellen; geprueft wird mit zwei Firmen fuer Lesen, Suchen und Ausfuhr.

> `app_state_aktuell` bleibt für direkte Clientrollen gesperrt oder wird als Security-Invoker-Sicht mit RLS der Basistabellen bereitgestellt. Zwei-Mandanten-Tests decken Lesen, Suche und Export ab.

### Was alles einen Mandanten tragen muss (Anwendung, Konto, Check, Prototyp, Protokoll, Ansprechpartner)

**K01-M02** · MUSS — Jede Anwendung traegt als Pflichtfeld die Firma, und eine Firma mit mindestens einer Anwendung laesst sich nicht loeschen - die Datenbank verweigert es, statt mitzuloeschen.

> Jede Zeile in `app` MUSS einen Mandanten tragen (`tenant_id`, Pflicht, Verweis auf `tenant` — Eigentümer K02). Ein Mandant mit mindestens einer Anwendung ist nicht löschbar; die Datenbank verweigert das Löschen, sie räumt nicht mit auf.

**K03-M02** · MUSS — Jedes Benutzerkonto traegt die Firma, zu der es gehoert.

> Jede Zeile in `actor` MUSS einen Mandanten tragen (`tenant_id`, Verweis auf `tenant` — Eigentümer K02).

**K04-M10** · MUSS — Jede Vorpruefung traegt eine Firma, und dieser Verweis haelt die Firma fest - sie kann nicht darunter weggeloescht werden.

> Jeder Eignungs-Check MUSS einen Mandanten tragen: `fit_check.tenant_id` ist Pflicht, Verweis auf `tenant` (Eigentümer K02) mit Löschsperre.

**K07-M12** · MUSS — Jeder Prototyp traegt eine Firma und haelt sie ebenso fest.

> Jeder Direkt-Prototyp MUSS einen Mandanten tragen; der Verweis hält den Mandanten mit einer Löschsperre fest.

**K02-M21** · MUSS — Bei jedem Schreibvorgang muss der Protokolleintrag dieselbe Firma tragen wie Sitzung, Objekt und Projektnummer, sonst wird alles zurueckgenommen; fuer den Betreiber gilt eine ausdruecklich benannte Ausnahme, die zusaetzlich protokolliert wird.

> Bei einem mandantengebundenen Schreibvorgang MUSS `event.tenant_id` gesetzt sein und mit Mandant der Sitzung, des Fachobjekts und der Projektnummer übereinstimmen. Fehlt oder widerspricht ein Bezug, wird die gemeinsame Transaktion zurückgerollt.

**K11-M01** · MUSS — Ein Ansprechpartner ist genau ein Eintrag und gehoert genau einer Firma; wird die Firma entfernt, geht er mit.

> Ein Ansprechpartner MUSS genau eine Zeile in `contact` sein und genau einen Mandanten tragen (`tenant_id`, Verweis auf `tenant` — Eigentümer K02, Löschregel `cascade`).

**K11-M02** · MUSS — Je Firma gibt es hoechstens drei Ansprechpartner, doppelt abgesichert ueber die Platznummer 1 bis 3 und deren Eindeutigkeit.

> Je Mandant MÜSSEN höchstens drei Ansprechpartner bestehen. Die Grenze trägt doppelt: Wertebereich 1 bis 3 an `contact.position` und Eindeutigkeit von Mandant und Platznummer.

**K11-D05** · DARF NICHT — Ein vierter Ansprechpartner derselben Firma entsteht nicht, und zwei duerfen nicht auf demselben Platz stehen.

> Eine vierte Zeile in `contact` DARF für denselben Mandanten nicht entstehen, und zwei Zeilen DÜRFEN nicht dieselbe Platznummer tragen.

**K25-M22** · MUSS — Der Vermerk zur Vorlagenauswahl haelt viele Angaben fest, darunter auch, zu welcher Anwendung und welcher Firma er gehoert.

> Jede Auswahl MUSS einen vollständigen Auswahlvermerk erzeugen: Auswahlkennung, Zeitpunkt, Anwendungs- und Mandantenbezug, Fassung der bestätigten Anforderungen, Profil mit Herkunft, Kandidaten vor und nach dem Filter, Deckungsgrade, Kennung und Fassung je Vorlage, angewandte Gleichstandsregel, Zweitplatzierter, Erzeuger- und Review-Agentenstand sowie Klartextsatz.

### Loeschen und Entfernen eines Mandanten

**K02-D03** · DARF NICHT — Eine Firma wird nie wirklich aus der Datenbank geloescht; "entfernt" heisst, dass ein Datum gesetzt wird.

> Ein Mandant DARF NICHT physisch entfernt werden. Das Entfernen ist ein Zeitstempel, nicht das Tilgen der Zeile.

**K02-D09** · DARF NICHT — Solange noch ein Benutzerkonto auf die Firma zeigt, laesst sie sich nicht entfernen.

> Ein Mandant DARF NICHT entfernt werden, solange ein Konto auf ihn verweist. Die Löschsperre am Verweis hält ihn fest.

**K20-G10** · GILT — Wird ein Konto entfernt, verschwinden seine Mitgliedschaften und Einladungen mit; Rolle und Firma bleiben bestehen.

> Es GILT: Beim Entfernen eines Kontos gehen Mitgliedschaften und Einladungen mit; Rolle und Mandant bleiben und verweigern das Mitlöschen.

**K02-G11** · GILT — Ein Protokolleintrag bleibt auch dann erhalten, wenn Anwendung oder Firma wegfallen; er verliert nur den Verweis darauf.

> Es GILT: Ein Protokolleintrag überlebt seinen Bezug. Entfällt die Anwendung oder der Mandant, bleibt der Eintrag bestehen und verliert nur den Verweis.

### Vom Mandanten zur Anwendung: der eine Weg des Anlegens

**K01-M26** · MUSS — Eine Anwendung gehoert immer zu einer Firma mit Rechtsraum Deutschland; deshalb beginnen alle Projektnummern mit DE-.

> Eine Anwendung MUSS einem Mandanten mit `legal_space = DE` gehören. Nur er legt in Release 1 eine Anwendung an (F35); das Muster von `project_no` mit dem Präfix `DE-` ist damit die Regel, nicht ein Fehler des Datenmodells.

**K01-M27** · MUSS — Eine echte Anwendung entsteht nur ueber den einen Serverbefehl create_app_after_fit, der Eignung, aktives Konto, Firmenzugehoerigkeit, Rechtsraum und Waehrung in einem einzigen Zug prueft - eine Luecke im Datenmodell ist keine Erlaubnis, daran vorbeizugehen.

> Eine produktive Anwendungszeile MUSS ausschließlich über den serverseitigen Befehl `create_app_after_fit` entstehen. Er prüft in derselben Transaktion: Eignung `GEEIGNET`, aktives Konto, Mandantenzugehörigkeit, `legal_space = DE` und `currency = EUR`.

**K04-M18** · MUSS — Unmittelbar vor dem Anlegen liest der Server Ergebnis, die drei Antworten und die Firma noch einmal frisch; ein alter Bildschirmstand genuegt nicht.

> Der Server MUSS Ergebnis, drei aktive Antworten und Mandant unmittelbar vor der Anlage erneut lesen. Ein veralteter Bildschirmstand berechtigt nicht zur Anlage.

**K02-G10** · GILT — Die Waehrung haengt an der Anwendung, nicht an der Firma.

> Es GILT: Die Währung steht an der Anwendung, nicht am Mandanten (Eigentümer K01). K02 führt sie nicht.

### Auftragsverarbeitungsvertrag und die Sperre des Gespraechsbeginns

**K02-M29** · MUSS — Bei einer Kundenfirma muss nachgewiesen sein, dass ein Auftragsverarbeitungsvertrag (das Datenschutz-Dokument, nicht der Projektvertrag) hinterlegt ist - mit Zeitpunkt und Aktenzeichen; ein Feld dafuer fehlt heute (Auftrag O-K02-11), und bis dahin bleibt der Echtbetrieb gesperrt.

> Ein Mandant der Art Kunde MUSS den Nachweis des hinterlegten Auftragsverarbeitungsvertrags führen: Zeitpunkt der Hinterlegung und Aktenzeichen der Ablage außerhalb der Plattform.

**K02-M30** · MUSS — Fehlt dieser Vertrag, lehnt der Server den Beginn eines Gespraechs fuer diese Firma ab - und zwar im Programm, nicht bloss durch einen ausgegrauten Knopf am Bildschirm.

> Ohne hinterlegten Vertrag MUSS der Beginn eines Gesprächs für diesen Mandanten serverseitig abgelehnt werden. Die Prüfung liegt im Serverpfad, nicht in der Oberfläche, und wirkt sperrend wie `customer_needs_code`.

**K02-G17** · GILT — Fuer Testfirmen aus dem reservierten Codebereich gilt diese Sperre nicht, solange dort keine echten Personendaten liegen.

> Es GILT: K02-M30 greift nicht für Testmandanten des reservierten Namensraums. Die Ausnahme setzt voraus, dass dort keine echten Personendaten stehen; diese Regel führt K14 und sie ist Abnahmekriterium seiner Freigabe.

### Protokollansicht und Protokollausfuhr an der Firmengrenze

**K02-D08** · DARF NICHT — Die Protokollansicht zeigt weder technische Schluessel noch Daten fremder Firmen.

> Die Protokollsicht DARF NICHT technische Schlüssel oder Bestände fremder Mandanten zeigen.

**K11-D09** · DARF NICHT — Dieselbe Ansicht darf auch keine Ausfuhr erzeugen, die ueber die Firmengrenze reicht.

> Die Protokollsicht DARF keine Zeile eines fremden Mandanten zeigen und keine Ausfuhr über die Mandantengrenze erzeugen (Schnitt K02, Durchsetzung K13 Abschn. 3).

**K02-M23** · MUSS — Jeder Export des Protokolls wird auf dem Server erneut geprueft, liefert nur die erlaubten Firmen mit festen Spalten und entschaerft Tabellenformeln, damit sie in Excel nicht ausgefuehrt werden.

> Jede Protokollausfuhr MUSS serverseitig erneut autorisiert werden, ausschließlich die gefilterte Mandantenmenge mit fester Spaltenliste liefern und Tabellenformeln als Daten neutralisieren.

### Geteilte Zugaenge und Abruf des Uebergabe-Pakets

**K12-M10** · MUSS — Ein geteilter Zugang ist ein zufaellig erzeugter, an Objekt und Firma gebundener Zugriff ueber den Server; Ablauf und Widerruf werden bei jedem Abruf neu geprueft.

> Ein Freigabezugang ist ein serververmittelter, zufälliger, objekt- und mandantengebundener Zugriff. Ablauf und Widerruf werden bei jedem Abruf geprüft; ein nackter Storage-Link gilt nicht als widerrufbar.

**K07-M23** · MUSS — Beim Teilen gibt es keinen direkten Speicherlink, sondern einen Zugang ueber den Server, der nach 14 Tagen ablaeuft, jederzeit widerrufbar ist und bei jedem Abruf neu geprueft wird.

> Teilen verwendet keinen direkt ausgegebenen Storage-Link, sondern einen serververmittelten, zufälligen, objekt- und mandantengebundenen Freigabezugang.

**K10-M22** · MUSS — Der Abruf des Uebergabe-Pakets wird fuer Anwendung, Firma, Person und freigegebene Fassung einzeln autorisiert; dauerhaft gueltige oder oeffentliche Links sind verboten.

> Jeder Abruf MUSS privat und serverseitig für Anwendung, Mandant, Person und freigegebene Paketrevision autorisiert werden. Öffentliche oder dauerhaft gültige Objektlinks sind unzulässig.

**K14-M20** · MUSS — Jede beteiligte Partnerfirma bekommt einen eigenen Uebergabezugang; einen gemeinsamen Zugang fuer zwei Partner gibt es nicht.

> Ein Übergabezugang MUSS je Partnermandant einzeln erteilt werden. Sind zwei Partner beteiligt, entstehen zwei Zugänge mit zwei getrennten Geheimnisreferenzen. Ein gemeinsamer Zugang entsteht nicht.

### Freigaben: das freigegebene Objekt muss in der eigenen Firma liegen

**K14-M04** · MUSS — Bevor eine Freigabe gespeichert wird, prueft der Server fuenf Dinge - darunter, dass das freigegebene Objekt zur Firma der angemeldeten Sitzung gehoert.

> Der Server MUSS vor dem Schreiben der Freigabezeile fünf Bedingungen prüfen: Die Aktion steht in der Matrix, der Freigeber ist die angemeldete Sitzung, beide Konten tragen `actor_status = AKTIV`, beide haben eine Mitgliedschaft im betroffenen Portal (`membership`, Eigentümer K20), und das Objekt liegt im Mandanten der Sitzung.

**K14-M05** · MUSS — Diese Serverpruefung muss zusaetzlich zur Datenbankbedingung bestehen, denn die Datenbank kennt weder die Sitzung noch die Firma.

> Die serverseitige Prüfung aus K14-M04 MUSS unabhängig von der Bedingung in der Datenbank bestehen. Der CHECK vergleicht zwei Werte einer Zeile; er kennt weder Sitzung noch Aktion noch Mandant und ersetzt die Aktionsprüfung nicht.

**K14-M08** · MUSS — Der Verweis auf das freigegebene Objekt muss eindeutig sein und wird innerhalb der eigenen Firma aufgeloest; ein fehlender, fremder oder mehrdeutiger Verweis blockiert den ganzen Vorgang.

> `approval.object_ref` MUSS das freigegebene Objekt eindeutig bezeichnen: Objektart, Schlüssel und Version. Der Server löst den Bezug im Mandanten der Sitzung auf; fehlender, fremder oder mehrdeutiger Bezug sperrt die Transaktion.

**K14-G05** · GILT — Die Freigabezeile selbst enthaelt keine Firmenspalte; der Firmenbezug ergibt sich nur ueber Objekt und Konten und wird allein vom Server durchgesetzt - dazu ist ein offener Punkt notiert.

> Es GILT: `approval` trägt keine Mandantenspalte und keinen Fremdschlüssel auf das freigegebene Objekt. Der Mandantenbezug entsteht über das Objekt und über die beiden Konten und wird ausschließlich serverseitig durchgesetzt (offener Punkt O-K14-2).

### Nachweise, Negativtests und Lastpruefung zur Firmentrennung

**K03-M21** · MUSS — Vor dem Echtbetrieb muessen typische Angriffsversuche - darunter der Zugriff auf eine fremde Firma - nachweislich fehlschlagen.

> Replay, Brute Force, Konto-Ermittlung, Sitzungsfixierung, parallele Anmeldung, fremder Mandant und Provider-Ausfall MÜSSEN vor Produktion als Negativtests bestanden sein.

**K03-M27** · MUSS — Die Abnahme der Einladung geht eine feste Liste von Fehlerfaellen durch, darunter die fremde Zielfirma; in jedem Fall darf weder eine Einladung noch eine Sitzung entstehen.

> Die Abnahme prüft mindestens: bewusst unbeschränkt, fehlender Nachweis, exakte Domäne, Groß-/Kleinschreibung, idna, Suffixverwechslung, Subdomäne, fremder Zielmandant, parallele Einladung, Replay und Providerausfall.

**K07-M28** · MUSS — Vor dem Echtbetrieb sind Negativtests unter anderem zur Firmentrennung bestanden, und der Betrieb fuehrt dazu Kennzahlen, Alarme und Handbuecher.

> Vor Produktion bestehen revisionsgebundene Negativtests für Mandantentrennung, Linkablauf/-widerruf, Parallelität, Prompt Injection, UI-Scope, Retention-Drift, Barrierefreiheit, Egress, Restore und Audit-Rollback.

**K23-M04** · MUSS — Jede Regel ohne belegenden Test wird einzeln als Restrisiko aufgefuehrt; betrifft sie die Firmentrennung, sperrt der fehlende Test die Freigabe - eine Prozentzahl zur Abdeckung genuegt nicht.

> Eine Klausel ohne belegenden Test MUSS einzeln als Restrisiko mit Träger, Kritikalität und Annahmeentscheidung aufgeführt werden. Ist die Klausel sicherheits-, mandanten-, freigabe-, aufbewahrungs- oder wiederherstellungskritisch, sperrt der fehlende Test die Freigabe.

**K23-M10** · MUSS — Es muss einen Belastungstest geben, bei dem mehrere Firmen gleichzeitig Prototypen erzeugen.

> Es MUSS eine Lastprüfung geben, die mehrere Mandanten gleichzeitig prototypisieren lässt. Ihre Zielwerte legt der Founder fest (O-K23-1).

**K23-M11** · MUSS — Dieser Belastungstest muss zeigen, dass die Firmentrennung auch unter Last haelt - nicht nur, dass es schnell genug bleibt.

> Die Lastprüfung MUSS die Mandantentrennung unter Last nachweisen, nicht nur die Antwortzeit.

**K23-M12** · MUSS — Jeder Pruef lauf nutzt kuenstliche, je Firma gekennzeichnete Daten in einer getrennten Umgebung; echte Daten und echte Zugangsgeheimnisse werden nie verwendet.

> Jeder Prüflauf MUSS gegen deterministisch erzeugte, synthetische und je Mandant gekennzeichnete Daten in einer abgetrennten Umgebung laufen.

**K23-M23** · MUSS — Der Belastungstest laeuft ausserhalb des Echtbetriebs mit eigenen Testzugaengen und zeichnet auch auf, ob Firmen fair bedient werden und ob es Trennungsverstoesse gab.

> Die Lastprüfung MUSS außerhalb der Produktion mit getrennten Testidentitäten und kleinsten erforderlichen Berechtigungen laufen. Sie zeichnet neben Antwortzeit und Fehlerquote auch Warteschlangen, Ressourcenverbrauch, Mandantenfairness und Trennungsverstöße auf.

---

## Einladungsschranke

*EXMA-Minimum: ... Einladungsschranke* — BS:53 · **4 Regeln**

**Anmerkung:** Wie eine Kennung zu lesen ist: K02-M11 heisst — Konzeptheft Nr. 02 ("Fundament"), darin die Regel Nr. 11. Der Buchstabe vor der Zahl sagt die Art: M = MUSS (Pflicht), G = GILT (eine Feststellung, wie etwas ist), D = DARF NICHT (Verbot). Zwei Woerter, die hier staendig vorkommen: "Mandant" ist die Organisation des Kunden, wie sie im System angelegt ist (eine Firma = ein Mandant). "Domaene" ist der Teil einer E-Mail-Adresse hinter dem @-Zeichen, also etwa "firma.de". Alle vier Regeln dieser Station reden tatsaechlich von der Einladungsschranke — kein Fehltreffer wegen eines zufaellig gleichen Wortes. Beim Lesen faellt aber eine Arbeitsteilung auf: K02-G06 und K02-M11 sagen vor allem, WO die Angabe gespeichert ist und WER das Verfahren ausfuehrt (naemlich Konzept K20), waehrend die eigentliche Pruefregel in K03-M19 und die Entscheidungspflicht in K03-M22 steht.

### wer die Schranke setzt und dass ueber sie ausdruecklich entschieden werden muss

**K03-M22** · MUSS — Nur der Betreiber selbst legt die Schranke fest, und zwar in dem Moment, in dem er den Mandanten anlegt — dabei muss er sich aktiv fuer eine Domaene oder ausdruecklich fuer "keine Schranke" entscheiden und diese Wahl festhalten; laesst er das Feld einfach leer, wird gar nicht geprueft und jede beliebige Adresse kann eingeladen werden (die Regel begruendet das damit, dass ein Tippfehler dann einen gueltigen Zugang an eine fremde Person schickt und es kein Kennwort als zweite Huerde gibt).

> Die Einladungsschranke setzt allein der Betreiber, indem er den Mandanten anlegt. Bei jeder Anlage MUSS über sie entschieden werden: entweder die Domäne des Kunden oder ausdrücklich keine Schranke; die Wahl ist zu vermerken. **Ist keine gesetzt, findet keine Prüfung statt — jede Adresse ist dann zulässig.** […]

### was die gesetzte Schranke bewirkt und welche Schranke bei einer Einladung ueber Mandantengrenzen hinweg zaehlt

**K02-M11** · MUSS — Wenn eine Schranke hinterlegt ist, duerfen Einladungen nur noch an E-Mail-Adressen dieser einen Domaene gehen — an alle anderen nicht.

> Ist eine Einladungsschranke gesetzt, MUSS die Einladung auf Adressen dieser Domäne beschränkt bleiben. Das Verfahren führt K20.

**K03-M19** · MUSS — Wenn jemand aus Organisation A jemanden aus Organisation B einlaedt, zaehlt die Schranke von B (dem Empfaenger), nicht die von A; die Regel haelt ausserdem fest, dass ein neu verschickter Einmal-Link alle frueher verschickten Links entwertet, und traegt den Zusatz, dass sie nach Beschluss S28 vom 02.08.2026 berichtigt wurde.

> Geprüft wird die Einladungsschranke des Mandanten, zu dem das **eingeladene Konto** gehört — nicht die des einladenden. Bei einer Einladung über die Mandantengrenze hinweg gilt damit die Schranke des Ziels. […]

### wo die Angabe gespeichert ist und wer das Verfahren dahinter verantwortet

**K02-G06** · GILT — Die beiden Angaben "wie lange gilt eine Einladung" und "welche Domaene ist erlaubt" haengen am Mandanten selbst, weil sie zur Organisation gehoeren und nicht zur einzelnen Einladung; wie im Ablauf damit umgegangen wird, ist in einem anderen Konzeptheft (K20) beschrieben.

> Es GILT: Einladungsfrist und Einladungsschranke stehen am Mandanten, weil sie Eigenschaften der einladenden Organisation sind. Das Verfahren dahinter gehört K20.

---

## Einladung

*EXMA-Minimum: ... Einladung senden* — BS:53 · **34 Regeln**

**Anmerkung:** Zum Lesen dieser Station: Die Kennungen sind so gebaut, dass der erste Teil das Konzeptpapier nennt, aus dem die Regel stammt, und der zweite Teil die Art plus eine laufende Nummer. K01 = Rahmenkonzept, K02 = Fundament (Mandant, Protokoll), K03 = Anmeldung, K05 = Gefuehrtes Gespraech Stufen 01-02, K11 = Betriebs-Portal, K15 = Datenschutz- und Loeschkonzept, K20 = Zugaenge und Nutzer EXMA, K23 = Test- und Abnahmekonzept. Ein M steht fuer MUSS, ein D fuer DARF NICHT, ein G fuer GILT (eine Feststellung, die etwas klarstellt, ohne selbst etwas zu fordern). Also: K20-M12 = zwoelfte MUSS-Regel aus dem Konzept K20. Weitere Woerter, die immer wiederkehren: 'Mandant' ist die Organisation, unter der ein Kunde gefuehrt wird; 'Einladungsschranke' (im Datenmodell invite_domain) ist die Festlegung, an welche E-Mail-Domaene ueberhaupt eingeladen werden darf; 'Einmal-Link' ist der Link in der Einladungsmail, der nur ein einziges Mal wirkt; 'Streuwert' (Hash) ist ein unumkehrbarer Zahlenabdruck des Links, aus dem sich der Link selbst nicht zurueckrechnen laesst; 'idempotent' heisst: derselbe Befehl zweimal ausgefuehrt erzeugt trotzdem nur eine Einladung; 'fail-closed' heisst: solange etwas ungeprueft ist, bleibt der Weg zu, nicht nur ausgegraut. Hinweise zu Treffern, die sachlich woanders liegen als beim ersten Versand einer Einladung: K20-M19 und K20-G10 handeln vom Entfernen eines Zugangs beziehungsweise Kontos und beruehren die Einladung nur als Nebenfolge (offene Einladungen werden dabei widerrufen). K15-G09 ordnet die Einladung datenschutzrechtlich ein und benennt den Aufraeumlauf als offenen Punkt. K05-M17 meint nicht die erste Einladung des Kunden, sondern das spaetere Nachladen weiterer Mitarbeiter waehrend des Gespraechs. K01-M22 ist eine Rollenregel, in der die Einladung nur als Randbemerkung vorkommt.

### die Einladung ist der einzige Weg zu einem Zugang, und wer das Verfahren fuehrt

**K20-M07** · MUSS — Niemand bekommt einen Zugang auf anderem Weg als durch eine Einladung, und zu jeder Einladung wird ein Datensatz mit Konto, Portal, Adresse, Zahlenabdruck des Links sowie Versand- und Ablaufzeitpunkt angelegt; ob das auch fuer das Kundenportal gilt, ist als offene Frage vermerkt.

> Ein neuer Zugang zum EXMA-Portal MUSS über eine Einladung entstehen: Zeile in `invitation` mit Konto, Portal, Adresse, Streuwert, Versand- und Ablaufzeitpunkt. Ob derselbe Satz auch Zugänge zum ENDUSER-Portal trägt, ist offen (O-K20-5).

**K01-M22** · MUSS — Es gibt in der ersten Ausbaustufe nur eine einzige Rolle je Portal, und der Endnutzer erscheint ueberhaupt nur als eingeladener Zugang, ohne eigene Rolle.

> Release 1 MUSS mit genau einer Rolle je Portal auskommen: Plattform-Admin (F08). Der Endnutzer steht daneben ausschließlich als eingeladener Zugang; Rolle und Einladung führt K20, das Konto K03.

**K11-G06** · GILT — Einen Ansprechpartner beim Kunden zu erfassen bedeutet noch nicht, dass diese Person sich anmelden kann; Ansprechpartner und Zugang sind zwei verschiedene Dinge.

> Es GILT: `contact` ist kein Zugang. Ein Ansprechpartner ist eine Person beim Kunden; das Konto führt K03, die Einladung K20.

**K05-M17** · MUSS — Auch wenn spaeter im Gespraech weitere Mitarbeiter dazugeholt werden, laeuft das ueber dasselbe Einladungsverfahren und nicht ueber einen eigenen, bequemeren Weg.

> *Weitere Mitarbeiter einladen* MUSS über die Einladung laufen, die K20 führt (`invitation`, Eigentümer K20). K05 löst sie aus und beschreibt sie nicht.

**K20-G09** · GILT — Auch Verwaltende und Betreiber durchlaufen genau dasselbe Einladungs- und Anmeldeverfahren wie jeder Kunde; eine Abkuerzung fuer Interne gibt es nicht.

> Es GILT: Das Einladungsverfahren der Verwaltenden — Einmal-Link, Frist, Code bei jeder Anmeldung — ist dasselbe wie beim Endnutzer. Einen bequemeren Weg gibt es ausdrücklich nicht (EXMA-Handbuch 5.4). Über den Datenweg des ENDUSER-Portals sagt das nichts (O-K20-5).

### was vollstaendig vorliegen muss, bevor ueberhaupt eingeladen werden darf

**K11-M06** · MUSS — Der Kunde muss zuerst fertig angelegt sein; das Verschicken der Einladung ist ein eigener, spaeterer Schritt und erzeugt selbst keinen Kunden.

> Die Anlage eines Kunden MUSS mit dem Anlegen abgeschlossen werden. Das Versenden des Einladungslinks legt keinen Kunden an; es richtet allein die Einladung ein (Eigentümer K20).

**K11-M07** · MUSS — Die Schaltflaeche zum Einladen taucht erst auf, wenn Firmenname, Vorname, Nachname, Telefon und eine geprueft gueltige E-Mail-Adresse alle zusammen da sind; vorher ist sie nicht sichtbar, nicht nur inaktiv.

> Der Einladungsweg MUSS erst erscheinen, wenn Firmenname, Vorname, Nachname, Telefon und eine gültige Adresse zusammen vorliegen. Als gültig zählt eine Adresse, deren Marke aus K11-M04 gesetzt ist; solange sie „nicht geprüft" trägt, bleibt der Weg verborgen — fail-closed, nicht ausgegraut.

**K20-D02** · DARF NICHT — Solange ein Portal nur geplant und noch nicht freigeschaltet ist, darf dafuer weder eine Rolle noch eine Mitgliedschaft noch eine Einladung entstehen.

> Für ein Portal mit `release_status = PLANNED` DARF keine Rolle vergeben, keine Mitgliedschaft angelegt und keine Einladung versandt werden (F04; Freischaltung K13). Auch `invitation.portal_code` führt nur freigeschaltete Portale.

### die Einladungsschranke: die bewusste Entscheidung und ihr Nachweis

**K02-G06** · GILT — Frist und Domaenenbeschraenkung sind Eigenschaften der Organisation und werden dort hinterlegt, nicht in der einzelnen Einladung.

> Es GILT: Einladungsfrist und Einladungsschranke stehen am Mandanten, weil sie Eigenschaften der einladenden Organisation sind. Das Verfahren dahinter gehört K20.

**K02-M11** · MUSS — Wenn fuer eine Organisation eine E-Mail-Domaene festgelegt ist, darf nur an Adressen dieser Domaene eingeladen werden.

> Ist eine Einladungsschranke gesetzt, MUSS die Einladung auf Adressen dieser Domäne beschränkt bleiben. Das Verfahren führt K20.

**K03-M22** · MUSS — Beim Anlegen jeder Organisation muss der Betreiber ausdruecklich waehlen, ob auf eine Domaene beschraenkt wird oder bewusst nicht, und diese Wahl festhalten; ein blosses Freilassen des Feldes zaehlt nicht als Entscheidung, weil dann jede Adresse durchgeht und ein Tippfehler einen gueltigen Zugang an eine fremde Person schickt.

> Die Einladungsschranke setzt allein der Betreiber, indem er den Mandanten anlegt. Bei jeder Anlage MUSS über sie entschieden werden: entweder die Domäne des Kunden oder ausdrücklich keine Schranke; die Wahl ist zu vermerken. **Ist keine gesetzt, findet keine Prüfung statt — jede Adresse ist dann zulässig.** Ein stillschweigendes Leerlassen ist keine Entscheidung: ohne Schranke schickt ein Tippfehler in der Adresse einen gültigen Zugang an eine fremde Person, und ein Kennwort als zweite Hürde gibt es nicht.

**K03-M23** · MUSS — Vor der allerersten Einladung muss ein dokumentierter Beschluss vorliegen, der Organisation, entscheidende Person, Zeitpunkt und Begruendung nennt; fehlt er oder passt er nicht zur gespeicherten Domaene, wird gar nicht erst versendet.

> Vor der ersten Einladung MUSS für den **Zielmandanten** eine explizite Entscheidung „Domäne beschränken" oder „bewusst unbeschränkt" vorliegen. Der Nachweis führt Zielmandant, Entscheider, Zeitpunkt und Begründung. Ein bloßes `invite_domain = NULL` beweist „bewusst unbeschränkt" nicht; fehlt der Nachweis oder widerspricht er der gespeicherten Domäne, wird nicht versendet.

**K20-D04** · DARF NICHT — Eine Einladung an eine Adresse ausserhalb der festgelegten Domaene entsteht unter keinen Umstaenden, auch nicht als Ausnahme fuer eigene Leute.

> Eine Einladung an eine Adresse außerhalb der Domänenschranke DARF NICHT entstehen — auch nicht auf Zuruf, auch nicht für einen Verwaltenden.

**K03-M19** · MUSS — Massgeblich ist immer die Domaenenbeschraenkung der Organisation, in die eingeladen wird, nicht die der einladenden Seite; und ein neu verschickter Link macht alle frueheren Links wertlos.

> *(berichtigt nach Beschluss S28 vom 02.08.2026)* Geprüft wird die Einladungsschranke des Mandanten, zu dem das **eingeladene Konto** gehört — nicht die des einladenden. Bei einer Einladung über die Mandantengrenze hinweg gilt damit die Schranke des Ziels. Ein erneuter Einmal-Link entwertet frühere Links.

### die Pruefung beim Versenden: serverseitig, nicht umgehbar, abgenommen

**K03-M25** · MUSS — Das Einladen laeuft ueber einen einzigen Befehl auf dem Server, der Ziel, Beschluss und Domaene prueft und Einladung samt Protokolleintrag entweder ganz oder gar nicht anlegt; kein Bedienweg und kein technischer Schluessel darf daran vorbei, und Fehlermeldungen verraten nicht, ob es ein Konto zu der Adresse gibt.

> Ein serverseitiger, idempotenter Einladungsbefehl prüft Zielmandant, Entscheidungsnachweis und Domäne und legt Einladung und Ereignis atomar an. Portal, Builder und Service-Schlüssel dürfen diese Prüfung nicht umgehen; Fehlermeldungen geben nicht preis, ob ein Konto existiert.

**K03-M27** · MUSS — Vor der Freigabe muss eine feste Liste von Missbrauchs- und Fehlerfaellen durchgespielt werden (unter anderem Gross- und Kleinschreibung, Umlautdomaenen, verwechselte Endungen wie .de statt .com, Unterdomaenen, gleichzeitige Einladungen, wiederholtes Absenden desselben Aufrufs, Ausfall des Mailanbieters), und in jedem dieser Faelle darf weder eine Einladung noch eine Anmeldesitzung entstehen.

> Die Abnahme prüft mindestens: bewusst unbeschränkt, fehlender Nachweis, exakte Domäne, Groß-/Kleinschreibung, idna, Suffixverwechslung, Subdomäne, fremder Zielmandant, parallele Einladung, Replay und Providerausfall. Jeder Negativfall erzeugt weder Einladung noch Sitzung.

### Frist und Einmal-Link: wie lange eine Einladung wirkt und was gespeichert wird

**K02-M10** · MUSS — Wie lange eine Einladung gilt, ist je Organisation einstellbar zwischen einer Stunde und einer Woche mit 24 Stunden als Vorgabewert, und darf nicht fest im Programm verdrahtet sein.

> Die Einladungsfrist MUSS zwischen 1 und 168 Stunden liegen, Vorgabe 24. Sie ist Eigenschaft der einladenden Organisation, keine Konstante im Programmtext.

**K03-M07** · MUSS — Der Link in der Einladungsmail verfaellt nach 24 Stunden, wobei der genaue Wert an der Organisation hinterlegt ist.

> Der Einmal-Link MUSS nach 24 Stunden verfallen (F11). Die Frist steht am Mandanten (Eigentümer K02), der Einladungssatz gehört K20.

**K20-G08** · GILT — Wird die Frist spaeter geaendert, gilt die neue Frist nur fuer kuenftige Einladungen; bereits verschickte behalten ihre alte Frist.

> Es GILT: Schranke und Frist stehen am Mandanten, nicht in der Einladung (Eigentümer K02). Ändert sich die Frist, wirkt sie auf künftige Einladungen, nicht rückwirkend.

**K20-M22** · MUSS — Ob eine Einladung abgelaufen ist, wird immer aus dem gespeicherten Ablaufzeitpunkt errechnet und nie als Zustand hineingeschrieben; ein erneuter Versand aendert alte und neue Einladung in einem einzigen untrennbaren Schritt, und wer in zwei Portale eingeladen wird, bekommt die zweite Einladung erst nach Einloesung oder Widerruf der ersten.

> Ablauf wird ausschließlich aus `expires_at` abgeleitet; kein Lauf schreibt ABGELAUFEN. Wiederversand setzt die alte Einladung und die Neuanlage in einer Transaktion um. Bei zwei Portalen erfolgt die Einladung sequenziell: erst Einlösung oder Widerruf, dann nächstes Portal.

**K20-D10** · DARF NICHT — Ein abgelaufener, bereits benutzter oder zurueckgezogener Link funktioniert nie wieder; wer ihn anklickt, muss einen ganz neuen Vorgang bekommen statt einer Verlaengerung.

> Eine abgelaufene, eingelöste oder widerrufene Einladung DARF NICHT erneut wirken. Ein verfallener Link führt zu einem neuen Vorgang, nie zu einer Verlängerung.

**K20-M08** · MUSS — In der Datenbank steht nur ein unumkehrbarer Zahlenabdruck des Links, damit niemand mit Datenbankzugriff eine fremde Einladung einloesen kann.

> Gespeichert MUSS allein der Streuwert des Links werden. Wer den Datenbestand liest, darf keine fremde Einladung einlösen können.

### hoechstens eine offene Einladung je Konto, Wiederversand nur ueber den Widerruf

**K20-M12** · MUSS — Zu einem Konto darf zu keinem Zeitpunkt mehr als eine noch offene Einladung existieren, und die Datenbank selbst verhindert eine zweite.

> Je Konto MUSS es höchstens eine offene Einladung geben. Getragen wird das vom eindeutigen Teilindex auf dem Zustand *versandt*; belegt durch T9.

**K20-M13** · MUSS — Wer eine Einladung noch einmal verschickt, zieht damit zwangslaeufig die alte zurueck und erhoeht einen Versuchszaehler, so dass hinterher wieder genau eine offene Einladung existiert.

> Ein erneuter Versand MUSS die vorherige Einladung zuerst auf WIDERRUFEN setzen und den Zähler `attempt` erhöhen. Danach besteht wieder genau eine offene Einladung; belegt durch T10.

**K20-D05** · DARF NICHT — Der Platz fuer die eine offene Einladung wird ausschliesslich durch einen ausdruecklichen Widerruf frei, nicht dadurch, dass man die Einladung als abgelaufen oder eingeloest umdeklariert.

> Eine zweite offene Einladung je Konto DARF NICHT bestehen. Der Wunsch nach einem neuen Link führt über den Widerruf, nicht daran vorbei. Der Platz DARF NICHT über einen Wechsel nach ABGELAUFEN oder EINGELOEST frei gemacht werden — allein WIDERRUFEN nach K20-M13 schafft ihn, und nur dieser Weg erhöht den Zähler (DDL Z. 601–602).

### was die Einladung beim Empfaenger ausloest

**K03-G02** · GILT — Zwischen dem Versand der Einladung und der ersten bestaetigten zweiten Anmeldestufe befindet sich das Konto in einem eigenen Wartezustand, der weder als freigeschaltet noch als gesperrt gilt.

> Es GILT: WARTET_2FA ist weder aktiv noch gesperrt — der Zustand zwischen versandter Einladung und erster bestätigter zweiter Stufe.

**K03-M03** · MUSS — Jedes Konto braucht eine eindeutige E-Mail-Adresse und einen Anzeigenamen; die Adresse dient zugleich als Anmeldename und wird aus der Einladung uebernommen.

> `email` und `display_name` MÜSSEN gesetzt sein, die Adresse eindeutig. Sie ist der Anmeldename und wird aus der Einladung vorbelegt.

### Nachweis, Protokoll und Anzeige rund um die Einladung

**K20-M18** · MUSS — Jede Aenderung an Zugang, Rolle, Mitgliedschaft oder Einladung wird lueckenlos protokolliert, mit Zeitpunkt, handelnder Stelle sowie dem Wert vorher und nachher.

> Jede Änderung an Zugang, Rolle, Mitgliedschaft oder Einladung MUSS mit Zeitpunkt, handelnder Instanz sowie Wert davor und danach im internen Nachweis stehen (EXMA-Handbuch 5.6).

**K15-G09** · GILT — Datenschutzrechtlich gilt die Einladung als Sicherheitsmittel und nicht als Nachweisdokument; der Beleg, dass eingeladen wurde, steht im Protokoll, und wie alte Einladungen aufgeraeumt werden, ist noch ungeklaert.

> Es GILT: Eine Einladung ist ein Sicherheitsmittel, kein Nachweis, und trägt deshalb keine eigene Klasse. Der Beleg, dass eingeladen wurde, liegt im Protokoll (Eigentümer K02). Der Aufräumlauf steht als offener Punkt.

**K20-G04** · GILT — Wenn die Einladungspruefung etwas ablehnt, muss die Meldung genau dort sichtbar werden, wo abgelehnt wurde, und zwar im festgelegten Wortlaut; zwei weitere Selbstpruefungen laufen dagegen unsichtbar im Hintergrund.

> Es GILT: Zwei der drei Invarianten — ein aktiver Plattform-Admin und der versiegelte Erst-Admin — laufen als Selbstprüfung ohne eigene Anzeige im Portal (EXMA-Handbuch 5.3). Die Meldungen des Einladungswächters werden dagegen am Ort der Ablehnung angezeigt (K20-G01, Abschnitt 4.1). Alle drei melden im Wortlaut aus Abschnitt 5.

**K11-M23** · MUSS — Der angezeigte Einladungsstatus wird jedes Mal frisch aus der fuehrenden Stelle gelesen statt irgendwo mitgeschrieben, und Ansprechpartner lassen sich in der ersten Ausbaustufe nicht loeschen.

> Einladungsmarken werden live aus K20 gelesen und nicht kopiert. Ansprechpartner können in Release 1 nicht entfernt werden; Platznummern bleiben stabil.

### wenn ein Portalzugang oder ein Konto wieder entfernt wird

**K20-M19** · MUSS — Wird jemandem der Zugang zu einem Portal entzogen, verschwindet nur diese eine Mitgliedschaft, das Konto und andere Portalzugaenge bleiben, und noch offene Einladungen fuer dasselbe Portal werden im selben Zug zurueckgezogen.

> *Portalzugang entfernen* löscht ausschließlich die `membership` des gewählten Portals. `actor` (Eigentümer K03) bleibt bestehen; Mitgliedschaften anderer Portale bleiben unverändert. Offene Einladungen desselben Portals werden atomar WIDERRUFEN.

**K20-G10** · GILT — Wird ein Konto geloescht, verschwinden dessen Mitgliedschaften und Einladungen mit ihm, waehrend Rolle und Organisation bestehen bleiben.

> Es GILT: Beim Entfernen eines Kontos gehen Mitgliedschaften und Einladungen mit; Rolle und Mandant bleiben und verweigern das Mitlöschen.

### die Einladung als Startpunkt der durchgehend gepruefen Kundenreise

**K23-M06** · MUSS — Der durchgehende Abnahmetest beginnt bei der Einladung und endet beim abgerufenen Uebergabe-Paket, ohne dass irgendein Schritt uebersprungen oder nachtraeglich von Hand ergaenzt werden darf.

> Der Durchstich MUSS die Kundenreise von der Einladung bis zum abgerufenen Übergabe-Paket durchlaufen, ohne Sprung und ohne nachgereichten Zwischenstand.

---

## Vorpruefung

*Vorpruefung: ein geeigneter Fall -> GEEIGNET* — BS:57 · **8 Regeln**

**Anmerkung:** Hinweis fuer den Leser, keine Entscheidung: Das Wort "Vorpruefung" hat in diesen acht Regeln zwei ganz verschiedene Bedeutungen. In K01-M12, K04-M01, K07-G04, K07-M25, K15-M10 und K15-M22 meint es die Vorpruefung am Einstieg — den Direkt-Prototyp-Check und den Eignungs-Check aus Konzept K04. In K08-M30 und K17-M42 dagegen meint "deterministische Vorpruefung" etwas voellig anderes: eine maschinelle Erstkontrolle INNERHALB eines Ausgabetors, das prueft, ob ein aus fremden Quellen erzeugter Text an den Kunden hinausgehen darf. Diese beiden sind nur ueber das gleiche Wort in die Liste geraten. "Deterministisch" heisst hier: nach festen Regeln, bei gleicher Eingabe immer gleiches Ergebnis, ohne Beteiligung eines Sprachmodells. Weiter zu wissen: "serverseitig" heisst, die Pruefung laeuft auf dem Server der Anwendung und kann vom Bildschirm des Nutzers aus nicht umgangen werden. K15-M10 und K15-M22 reden nicht vom Ablauf der Vorpruefung, sondern nur davon, wie lange ihre Daten aufbewahrt werden.

### der Einstieg und die feste Reihenfolge der beiden Vorpruefungen

**K01-M12** · MUSS — Es gibt nur einen Anfang: ueber die Startseite, und dabei muessen beide Vorpruefungen durchlaufen werden — an ihnen vorbei gibt es keinen Weg in ein Vorhaben.

> Der Einstieg in ein Vorhaben MUSS über die Startseite laufen und zwingend beide Vorprüfungen durchlaufen (Eigentümer K04).

**K04-M01** · MUSS — Die Reihenfolge liegt fest: zuerst wird geprueft, ob der Fall nur ein Direkt-Prototyp ist, danach erst, ob er ueberhaupt geeignet ist.

> Der Einstieg *Neue Anwendung erstellen* MUSS zwei Vorprüfungen in fester Reihenfolge durchlaufen: erst Direkt-Prototyp-Check, dann Eignungs-Check.

### der Direkt-Prototyp, der in der Vorpruefung entsteht, und was mit ihm nicht passieren darf

**K07-G04** · GILT — Der Direkt-Prototyp ist ein Erzeugnis der Vorpruefung und nicht des spaeteren Gespraechs; er steht fuer sich allein und haengt an keiner Anwendung.

> Es GILT: Ein Direkt-Prototyp entsteht in der Vorprüfung (Eigentümer K04), nicht im Gespräch. Er hat keinen Bezug zu einer Anwendung.

**K07-M25** · MUSS — Der Dateiname des Direkt-Prototyps wird aus der in der Vorpruefung bestaetigten Themenbezeichnung gebildet und dabei auf dem Server auf harmlose Laenge und Zeichen zurechtgestutzt — er dient nur der Lesbarkeit, nicht dem Wiederfinden in der Ablage; die Regel haelt ausserdem fest, dass ein Direkt-Prototyp nicht in eine Anwendung ueberfuehrt wird und seine Inhalte nur ueber den normalen Weg K04-K06 als neue Eingabe wieder aufgenommen werden duerfen.

> Das Thema des Dateinamens stammt aus der bestätigten Themenbezeichnung der Vorprüfung (K04), wird serverseitig auf eine sichere Länge und Zeichenmenge normalisiert und ist nicht der Ablageschlüssel. […]

### wie lange die Daten einer Vorpruefung aufbewahrt werden

**K15-M10** · MUSS — Die Liste, in der Loeschfristen gefuehrt werden (`retention_due`, sinngemaess "faellig zum Loeschen"), muss sechs Arten von Gegenstaenden abdecken — die Vorpruefung ist einer davon.

> `retention_due` MUSS sechs Bezugsobjekte führen: Anwendung (Eigentümer K01), Dokument (Eigentümer K10), Protokolleintrag (Eigentümer K02), Arbeitsdokument (Eigentümer K07), Vorprüfung (Eigentümer K04) und Prüflauf (Eigentümer K06).

**K15-M22** · MUSS — Wie lange eine Vorpruefung aufbewahrt wird, haengt davon ab, ob aus ihr eine Anwendung geworden ist: mit Anwendung gilt die Klasse "KI-Nachweis", ohne Anwendung die Klasse "Betriebsprotokoll" mit kuerzerer Frist, und wenn die Verbindung erst spaeter entsteht, wird die Klasse nachtraeglich hochgestuft — sonst haetten abgelehnte Pruefungen eine Frist ohne bestimmbaren Beginn.

> Die Aufbewahrungsklasse einer Vorprüfung MUSS ihrer Bindung folgen: mit Anwendungsbezug `KI_NACHWEIS`, ohne Bezug `BETRIEBSPROTOKOLL`. Die Zuweisung geschieht beim Anlegen serverseitig; ein Bezug, der später entsteht, hebt die Klasse nach. […]

### das gleiche Wort in anderer Sache: die maschinelle Erstkontrolle im Ausgabetor fuer quellenbasierte Texte

**K08-M30** · MUSS — Bevor ein Text, der aus fremden Quellen erzeugt wurde, an den Kunden geht, durchlaeuft er eine dreistufige Kontrolle — erst eine feste maschinelle Regelpruefung, dann eine getrennte Aehnlichkeitspruefung durch ein zweites Modell, im Zweifel ein Mensch — mit dem Ergebnis "bestanden", "gesperrt" oder "menschlich zu pruefen"; solange die Schwellenwerte nicht gezeichnet sind, geht ueberhaupt kein solcher Text automatisch hinaus.

> Vor jedem quellenbasierten Kundendokument läuft ein versioniertes Ausgabetor: deterministische Vorprüfung, getrennte modellgestützte Ähnlichkeitsprüfung und im Prüffall eine menschliche Entscheidung. […]

**K17-M42** · MUSS — Dasselbe Ausgabetor muss lueckenlos festhalten, aus welcher Quelle in welcher Fassung der Text stammt und mit welchen Einstellungen geprueft wurde (ein "Hash" ist ein kurzer Zahlenwert, der sich aendert, sobald sich der Inhalt aendert — eine Art Fingerabdruck); ausserdem darf das pruefende Modell selbst nichts schreiben oder veroeffentlichen und ist nicht die alleinige Sicherung.

> Das Tor bindet Quellen-ID/-version/-hash und Fundstelle, Ausgabe-Hash, Rechte-/Policy-Version, deterministische Vorprüfung, getrenntes Prüfermodell, Prompt-/Rubrikversion und Ergebnis „bestanden“, „gesperrt“ oder „menschlich zu prüfen“. […]

---

## geeignet

*... ein geeigneter Fall -> GEEIGNET* — BS:57 · **8 Regeln**

**Anmerkung:** Hinweis fuer den Leser, keine Entscheidung: K23-G02 benutzt das Wort "geeignet" in einer voellig anderen Bedeutung — dort geht es darum, dass ein WERKZEUG oder Anbieter, der Bauauftraege erfuellt, austauschbar ist, nicht um einen geeigneten Kundenfall. Diese Regel ist allein ueber das gleiche Wort in die Liste geraten. Wortklaerungen fuer diese Station: `fit_check` ist der Eignungs-Check, `outcome` sein Ergebnis, `fit_check_id` die Verweisnummer, mit der eine Anwendung auf ihren Eignungs-Check zeigt. "Nullbar" bzw. "technisch leer zulässig" heisst: die Datenbank laesst dieses Feld rein technisch leer, weil Anwendung und Check aufeinander zeigen und eines von beiden zuerst da sein muss — es ist ausdruecklich KEINE Erlaubnis, ohne Check zu arbeiten. "Atomar in derselben Transaktion" heisst: alle Pruefungen und das Anlegen passieren in einem einzigen, unteilbaren Schritt — entweder alles oder nichts, nichts kann dazwischenrutschen. K01-G05 und K04-G01 sagen inhaltlich fast dasselbe aus zwei Blickwinkeln (einmal aus dem Rahmenkonzept, einmal aus dem Check-Konzept).

### wie das Ergebnis des Eignungs-Checks aussieht und wann es GEEIGNET heissen darf

**K04-M11** · MUSS — Es gibt genau drei moegliche Ergebnisse — offen, geeignet, nicht geeignet — und solange nichts entschieden ist, steht "offen" da; ein leeres oder erfundenes viertes Ergebnis gibt es nicht.

> Das Ergebnis MUSS in `fit_check.outcome` stehen und einen der Werte OFFEN, GEEIGNET, NICHT_GEEIGNET führen. Vorgabe ist OFFEN.

**K04-M13** · MUSS — "Geeignet" darf erst herauskommen, wenn zu jeder der drei Fragen genau eine gueltige, nicht widerrufene Antwort vorliegt und jede dieser Antworten fuer Eignung spricht — eine fehlende oder zurueckgezogene Antwort reicht nicht.

> GEEIGNET MUSS voraussetzen, dass zu allen drei Fragen genau eine nicht zurückgenommene Antwort vorliegt und jede `is_eligible` = wahr trägt.

### was auf ein GEEIGNET zwingend folgen muss

**K04-M19** · MUSS — Sobald "geeignet" feststeht, folgt zwingend ein weiterer Schritt, in dem zwei getrennte Fragen zum Zweck der geplanten Anwendung beantwortet werden — die erste zu Anwendungen mit hohem Risiko fuer Menschen, die zweite zu verbotenen Zwecken; dieser Schritt zaehlt ausdruecklich nicht als vierte Eignungsfrage.

> Nach `outcome = GEEIGNET` MUSS ein Zweckbestimmungs-Schritt folgen. Er fragt zweierlei getrennt: **erstens**, ob die Anwendung Menschen bewertet, auswählt oder überwacht — bei Bewerbung, Beschäftigung, Kreditwürdigkeit, Versicherung, Bildung, Biometrie; **zweitens**, ob sie Gefühle am Arbeitsplatz oder in der Bildung erkennen, Menschen nach sozialem Verhalten bewerten, Schwächen wegen Alter, Behinderung oder Notlage ausnutzen oder Gesichter ungezielt sammeln soll. […]

### was bei NICHT_GEEIGNET nicht geschehen darf

**K04-D04** · DARF NICHT — Faellt der Check negativ aus, ist der Weg zu Ende: kein Gespraech, keine Anwendung, keine Angebotsanfrage.

> Ein Check mit NICHT_GEEIGNET DARF NICHT ins Gespräch führen. Es entsteht keine Anwendung (Eigentümer K01) und keine Angebotsanfrage.

### keine Anwendung ohne geeigneten Check — und der eine Befehl, ueber den sie entsteht

**K01-M27** · MUSS — Eine echte Anwendung darf nur ueber einen einzigen Befehl auf dem Server entstehen, der in einem unteilbaren Schritt fuenf Dinge zugleich prueft — Eignung steht auf GEEIGNET, das Konto ist aktiv, es gehoert zum richtigen Mandanten, der Rechtsraum ist Deutschland und die Waehrung Euro — und die Regel stellt ausdruecklich klar, dass ein technisch leer zulaessiges Feld im Datenbankschema keine Erlaubnis ist, diesen Befehl zu umgehen.

> Eine produktive Anwendungszeile MUSS ausschließlich über den serverseitigen Befehl `create_app_after_fit` entstehen. Er prüft in derselben Transaktion: Eignung `GEEIGNET`, aktives Konto, Mandantenzugehörigkeit, `legal_space = DE` und `currency = EUR`. […]

**K01-G05** · GILT — Das Feld, mit dem eine Anwendung auf ihren Eignungs-Check zeigt, darf in der Datenbankbeschreibung leer sein, weil Anwendung und Check gegenseitig aufeinander verweisen — trotzdem entsteht im Nutzerweg keine Anwendung ohne geeigneten Check, weil der Server das erzwingt; die Regel ergaenzt, dass `app_fit_ok` nur eine Anzeige zum Lesen ist und nichts blockiert.

> Es GILT: `fit_check_id` ist im DDL wegen der beidseitigen Verknüpfung technisch nullbar. Im Release-1-Nutzerweg entsteht dennoch keine Anwendung vor einem geeigneten Check; durchgesetzt wird das serverseitig und atomar nach K01-M27. […]

**K04-G01** · GILT — Dieselbe Feststellung noch einmal aus Sicht des Check-Konzepts: das Verweisfeld darf technisch leer sein, aber im tatsaechlichen Ablauf gibt es keine Anwendung vor einem geeigneten Check.

> Es GILT: `app.fit_check_id` ist wegen der beidseitigen Verknüpfung technisch leer zulässig (Eigentümer K01). Im Release-1-Nutzerweg entsteht dennoch keine Anwendung vor einem geeigneten Check.

### das gleiche Wort in anderer Sache: die Austauschbarkeit der Erzeuger

**K23-G02** · GILT — Hier heisst "geeignet" etwas anderes: es geht darum, dass kein bestimmtes Werkzeug und kein bestimmter Anbieter vorgeschrieben ist — wer den Bauauftrag erfuellt und die Kontrollpunkte ("Gates") besteht, darf verwendet werden.

> Es GILT: Erzeuger sind austauschbar. Wer den Bauauftrag erfüllt und die Gates besteht, ist geeignet; ein Anbieter wird nicht vorgeschrieben.

---

## Zweckbestimmung

*ZWECKBESTIMMUNG bestaetigt (Riegel)* — BS:59 · **2 Regeln**

**Anmerkung:** Diese Station ist die kleinste des Fadens: nur zwei Regeln nennen das Wort ueberhaupt. Beide reden von derselben Sache, nur an zwei verschiedenen Enden des Wegs — K04-M19 laesst die Zweckbestimmung ganz vorne abfragen, K10-M34 verlangt sie ganz hinten im Uebergabe-Paket wieder. K04-M19 ist dieselbe Regel, die auch an der Station "geeignet" auftaucht; sie steht dort im Buendel "was auf ein GEEIGNET zwingend folgen muss". "Zweckbestimmung" ist ein Wort aus der KI-Verordnung und meint: wofuer die Anwendung nach dem Willen ihres Anbieters bestimmt ist. "Art. 25 Abs. 4" ist der Artikel der KI-Verordnung, der den Zulieferer verpflichtet, dem Anbieter die Angaben zu geben, die dieser fuer seine eigenen Pflichten braucht.

### die Zweckbestimmung wird am Anfang abgefragt, unmittelbar nach dem geeigneten Check

**K04-M19** · MUSS — Direkt nach dem Ergebnis "geeignet" muss ein eigener Schritt kommen, der in zwei getrennten Fragen klaert, wozu die Anwendung dienen soll: einmal, ob sie Menschen bewertet, auswaehlt oder ueberwacht (die Hochrisiko-Felder), und einmal, ob sie einem der ausdruecklich verbotenen Zwecke dient — dieser Schritt ist ausdruecklich keine weitere Eignungsfrage und aendert an den drei Eignungsfragen nichts.

> Nach `outcome = GEEIGNET` MUSS ein Zweckbestimmungs-Schritt folgen. Er fragt zweierlei getrennt: **erstens**, ob die Anwendung Menschen bewertet, auswählt oder überwacht — bei Bewerbung, Beschäftigung, Kreditwürdigkeit, Versicherung, Bildung, Biometrie; **zweitens**, ob sie Gefühle am Arbeitsplatz oder in der Bildung erkennen, Menschen nach sozialem Verhalten bewerten, Schwächen wegen Alter, Behinderung oder Notlage ausnutzen oder Gesichter ungezielt sammeln soll. Er ist kein `fit_question`; die drei Dimensionen nach K04-M04 bleiben unberührt.

### dieselbe Zweckbestimmung wird am Ende dem Kunden mitgegeben

**K10-M34** · MUSS — Das Uebergabe-Paket muss vier Angaben enthalten, ohne die der Kunde seine eigenen gesetzlichen Pflichten nicht beurteilen kann — wozu die Anwendung bestimmt ist, wo ihre Grenzen liegen, welche KI-Modelle von welchem Anbieter verwendet werden und die Kenntnisnahme aus dem Check-Konzept — und die Regel stellt klar, dass dafuer keine zusaetzliche achte Dokumentart angelegt wird.

> Das Paket MUSS die Angaben führen, die der Kunde braucht, um seine eigenen Pflichten aus der KI-Verordnung zu beurteilen: Zweckbestimmung der Anwendung, ihre Grenzen, die verwendeten Modelle mit ihrem Anbieter, und die Kenntnisnahme aus K04 Abschn. 3. […]

---

## Anwendung

*create_app_after_fit -- der EINE Weg* — BS:61 · **99 Regeln**

**Anmerkung:** LESEHILFE ZU DEN KENNUNGEN. Eine Kennung wie K01-M27 liest sich so: K01 = das Konzeptpapier, aus dem die Regel stammt; M = MUSS, G = GILT (eine Feststellung, die einfach zutrifft), D = DARF NICHT; 27 = laufende Nummer. Die Papiere dieser Station: K01 Rahmenkonzept, K02 Fundament (Mandanten, Protokoll), K03 Anmeldung, K04 Eignungs- und Schnell-Check, K05 Gefuehrtes Gespraech Stufen 01-02, K06 Anforderungskonzepte/Projektvertrag/Fachreview, K07 Prototyp und Verfeinern, K08 Wissen und Quellen, K09 Angebot und Freigabe, K10 Uebergabe-Paket, K11 Betriebs-Portal, K13 Architektur-Muster, K14 Sicherheits-Grundlinie, K15 Datenschutz- und Loeschkonzept, K16 Bedien-Standard, K17 Agenten, K18 Wissens-Struktur, K19 Build-Referenz, K20 Zugaenge und Nutzer EXMA, K21 Richtlinien, K25 Wortschatz und Sperren des Prototyp-Erzeugers. Woerter, die immer wiederkehren: 'app' ist der Name der Tabelle, in der jede Anwendung genau eine Zeile hat; 'Mandant' ist der Kunde oder die Firma, zu der eine Anwendung gehoert; 'RLS' ist die Technik, die dafuer sorgt, dass ein Mandant nur seine eigenen Zeilen sieht; F15, F35, F36 sind Nummern frueherer Feststellungen, auf die die Papiere zurueckverweisen.

ZWEI BEDEUTUNGEN DESSELBEN WORTES. Das Stichwort 'Anwendung' trifft an dieser Station zweierlei, und die Buendel 12 und 13 sammeln genau den Unterschied. (a) 'Anwendung' als das Kundenvorhaben, also die Sache, die im Faden entsteht -- das sind die meisten Regeln. (b) 'Anwendung' als das Programm, die laufende Software-Schicht, im Gegensatz zum Datenbankschema. In dieser zweiten Bedeutung stehen K14-G03, K18-M15, K21-M03 und K01-G18 sowie die fuenf Selbstschutz-Regeln K01-G13, K03-G07, K14-G08, K19-G07 und K20-G06 -- Saetze der Form 'das liegt in der Anwendung, nicht im Schema'. Diese neun sind ueber das Wort getroffen, nicht ueber die Sache; K18-M15 (Versionszeilen im Wissensbestand) und K21-M03 (Geltungsbereich einer Richtlinie) haben inhaltlich gar nichts mit einem Kundenvorhaben zu tun.

EINE DRITTE, KLEINERE WORTGLEICHHEIT. In K05-M03, K05-M04 und K05-G02 ist 'Anwendung' der Name der dritten Einordnungsfrage im Gespraech (Branche, dann Funktionsbereich, dann Anwendung) -- also die Beschriftung eines Eingabefeldes, nicht das Vorhaben selbst.

DOPPELUNGEN, DIE AUFFALLEN. Mehrere Regeln sagen woertlich fast dasselbe an verschiedenen Stellen: K01-D17, K11-D01 und K15-D01 (kein Loeschknopf); K01-G13, K03-G07, K14-G08 und K20-G06 (eigenes Konto nicht sperrbar); K01-D10 und K16-D07 (Nebenfragen-Fenster); K01-G05 und K04-G01 (leeres Verweisfeld); K01-G10 und K04-G05 sowie K04-D07 und K07-D04 (Arbeitsdokument gegen geprueste Anwendung). Wer eine davon liest, hat die anderen mitgelesen.

EINE REGEL OHNE TRAEGER. K02-M31 verlangt etwas, wofuer es heute kein Datenfeld gibt; das Papier sagt das selbst und nennt einen offenen Auftrag O-K02-12.

### was eine Anwendung im Datenbestand ueberhaupt ist -- eine Zeile, ein Mandant, feste Pflichtangaben

**K01-M01** · MUSS — Eine Anwendung ist genau ein Datensatz in der Tabelle `app`, und an diesem einen Datensatz haengen Zustand, Stufe, Siegel und Aufbewahrungsklasse -- nirgends sonst.

> Eine Anwendung MUSS genau eine Zeile in `app` sein. `app` ist die Aggregatswurzel; die kanonische Kennung ist `app.id`.

**K01-M02** · MUSS — Jede Anwendung gehoert zwingend zu einem Mandanten, und solange ein Mandant noch mindestens eine Anwendung hat, verweigert die Datenbank sein Loeschen.

> Jede Zeile in `app` MUSS einen Mandanten tragen (`tenant_id`, Pflicht, Verweis auf `tenant` — Eigentümer K02).

**K01-M04** · MUSS — In der Tabelle `app` stehen ausschliesslich geprueste Anwendungen; ein blosses Arbeitsdokument entsteht dort nie, sondern in einer eigenen Tabelle.

> Jede Zeile in `app` MUSS eine geprüfte Anwendung sein: `artifact_class = VERIFIED_APP`, erzwungen durch CHECK `app_is_verified`.

**K01-M05** · MUSS — Jede Anwendung fuehrt zwei getrennte Zustandsangaben nebeneinander: den Betriebszustand mit acht moeglichen Werten und die Reisephase mit fuenf, beide Pflicht.

> Eine Anwendung MUSS zwei Zustandsachsen führen, beide Pflicht: `lifecycle_state` mit acht Werten (EINGELADEN, DISCOVERY, IN_BEARBEITUNG, BEAUFTRAGT, IN_DEV, ABNAHME, IN_PROD, PAUSIERT) und `journey_phase` mit fünf Werten (ORIENTIERUNG, INTERVIEW, UEBERSICHT, PROTOTYP, ANGEBOT).

**K01-M26** · MUSS — Eine Anwendung darf nur einem deutschen Mandanten gehoeren, weshalb jede Projektnummer mit dem Vorsatz DE- beginnt.

> Eine Anwendung MUSS einem Mandanten mit `legal_space = DE` gehören.

**K01-G16** · GILT — Beide Portale bezeichnen dieselbe Anwendung ueber die Projektnummer und sehen denselben Datensatz, nur mit unterschiedlichem Ausschnitt.

> Es GILT: die Anwendung wird portalübergreifend über `project_no` bezeichnet. Beide Portale sehen dieselbe Zeile, nur mit unterschiedlichem Ausschnitt.

**K02-G10** · GILT — Die Waehrung ist eine Angabe der einzelnen Anwendung, nicht des Kunden.

> Es GILT: Die Währung steht an der Anwendung, nicht am Mandanten (Eigentümer K01). K02 führt sie nicht.

**K11-G10** · GILT — Zwei Anwendungen duerfen denselben Namen tragen; eindeutig ist allein die Projektnummer.

> Es GILT: Der Name einer Anwendung ist nicht eindeutig, die Projektnummer schon. Zwei Vorhaben verschiedener Kunden können denselben Titel tragen (Eigentümer K01).

**K02-M31** · MUSS — Bei einem Partner-Mandanten soll erkennbar sein, ob er die Anwendung baut, beim Kunden umsetzt oder beides -- ein Feld dafuer gibt es heute noch nicht.

> Ein Mandant der Art Partner MUSS erkennen lassen, ob er die Anwendung **baut**, sie beim Kunden **umsetzt**, oder beides. **Das Datenmodell führt dafür heute kein Feld**; der Träger ist als Auftrag O-K02-12 benannt.

### der eine Weg, auf dem eine Anwendung ueberhaupt entsteht

**K01-M27** · MUSS — Eine echte Anwendung darf nur ein einziger Serverbefehl erzeugen, der im selben Arbeitsgang Eignung, Konto, Mandantenzugehoerigkeit, Rechtsraum und Waehrung prueft.

> Eine produktive Anwendungszeile MUSS ausschließlich über den serverseitigen Befehl `create_app_after_fit` entstehen. Er prüft in derselben Transaktion: Eignung `GEEIGNET`, aktives Konto, Mandantenzugehörigkeit, `legal_space = DE` und `currency = EUR`.

**K01-M38** · MUSS — Die Projektnummer vergibt der Server selbst im selben Arbeitsgang; niemand tippt sie ein.

> Die Projektnummer MUSS der serverseitige Befehl bilden, in derselben Transaktion, in der die Anwendungszeile entsteht. Sie wird vergeben, nicht eingegeben.

**K04-M17** · MUSS — Das Anlegen der Anwendung und das gegenseitige Verknuepfen mit der Vorpruefung passieren in einem einzigen Vorgang, der bei jeder Abweichung vollstaendig zurueckgenommen wird.

> Anlage der Anwendung und beidseitige Verknüpfung MÜSSEN in einer Transaktion erfolgen. Vor dem Commit wird Gleichheit beider Bezüge geprüft; jede Abweichung rollt alles zurück (Eigentümer K01).

**K01-G05** · GILT — Dass das Verweisfeld auf die Vorpruefung technisch leer bleiben darf, ist keine Erlaubnis: im Nutzerweg entsteht keine Anwendung ohne vorher bestandene Eignung.

> Im Release-1-Nutzerweg entsteht dennoch keine Anwendung vor einem geeigneten Check; durchgesetzt wird das serverseitig und atomar nach K01-M27.

**K04-G01** · GILT — Dieselbe Aussage noch einmal aus Sicht des Eignungs-Checks: das Feld darf technisch leer sein, der Weg laesst es trotzdem nicht zu.

> Es GILT: `app.fit_check_id` ist wegen der beidseitigen Verknüpfung technisch leer zulässig (Eigentümer K01). Im Release-1-Nutzerweg entsteht dennoch keine Anwendung vor einem geeigneten Check.

**K04-G06** · GILT — Eine Vorpruefung kann fuer sich allein bestehen; erst mit dem Anlegen der Anwendung bekommt sie den Verweis darauf.

> Es GILT: Ein Eignungs-Check besteht auch ohne Anwendung. `fit_check.app_id` bleibt bis zur Anlage leer; der Fremdschlüssel `fit_check_app_fk` leert ihn beim Entfernen der Anwendung (Eigentümer K01).

**K04-D04** · DARF NICHT — Faellt die Vorpruefung auf nicht geeignet, entsteht weder ein Gespraech noch eine Anwendung noch eine Angebotsanfrage.

> Ein Check mit NICHT_GEEIGNET DARF NICHT ins Gespräch führen. Es entsteht keine Anwendung (Eigentümer K01) und keine Angebotsanfrage.

**K13-M09** · MUSS — Anlegen und Zustandswechsel laufen ausnahmslos ueber die Serverbefehle; direktes Schreiben in die zugehoerigen Tabellen ist allen Zugaengen entzogen.

> Das Anlegen einer Anwendung und jeder Zustandswechsel MÜSSEN über die serverseitigen Befehle laufen, die K01 Abschn. 3 festlegt.

### die Vorpruefung: wie die Weiche zwischen Dokument und Anwendung gestellt wird

**K04-M01** · MUSS — Wer eine neue Anwendung erstellen will, durchlaeuft zuerst den Direkt-Prototyp-Check und danach den Eignungs-Check, in genau dieser Reihenfolge.

> Der Einstieg *Neue Anwendung erstellen* MUSS zwei Vorprüfungen in fester Reihenfolge durchlaufen: erst Direkt-Prototyp-Check, dann Eignungs-Check.

**K04-M22** · MUSS — Der Direkt-Prototyp-Check besteht aus genau fuenf Fragen mit je drei Antworten, und jede Antwort zeigt entweder auf Dokument oder auf Anwendung.

> Der Direkt-Prototyp-Check MUSS genau fünf Fragen führen, je Frage genau drei Antwortmöglichkeiten, je Antwort eine Zuordnung zu *Dokument* oder *Anwendung*.

**K04-M23** · MUSS — Zwei der fuenf Fragen entscheiden allein: zeigt eine von ihnen auf Anwendung, steht das Ergebnis fest, ohne dass die uebrigen zaehlen.

> Zwei Fragen MÜSSEN allein entscheiden: die Frage nach der Verbindlichkeit und die Frage nach dem Ergebnis. Zeigt eine von beiden auf *Anwendung*, lautet der Vorschlag *Anwendung*, ohne dass die übrigen gewogen werden.

**K04-M24** · MUSS — Die uebrigen drei Fragen werden schlicht gezaehlt: zwei oder drei Treffer ergeben Anwendung, einer oder keiner ergibt Direkt-Prototyp.

> Die drei übrigen Fragen MÜSSEN gezählt werden. Zwei oder drei Treffer auf *Anwendung* ergeben den Vorschlag *Anwendung*; einer ergibt *Direkt-Prototyp* mit Nennung der abweichenden Antwort; keiner ergibt *Direkt-Prototyp*.

**K04-D11** · DARF NICHT — Fehlt eine Antwort oder scheitert die Auswertung, faellt der Vorschlag immer auf Anwendung und der Grund wird genannt.

> Ein unvollständiger oder nicht auswertbarer Check DARF NICHT zum Vorschlag *Direkt-Prototyp* führen. Fehlt eine Antwort oder scheitert die Auswertung, lautet der Vorschlag *Anwendung*, und der Grund wird genannt.

**K04-G13** · GILT — Im Zweifel zeigt der Vorschlag auf die Anwendung, weil dieser Weg durch alle Pruefungen fuehrt und der teurere Weg der ungefaehrlichere ist.

> Es GILT: Bei Unklarheit zeigt der Vorschlag auf die Anwendung.

### die Zweckbestimmung: die zwei Fragen nach der KI-Verordnung

**K04-M19** · MUSS — Sobald ein Fall als geeignet gilt, folgt zwingend ein eigener Schritt mit zwei getrennten Fragen: eine nach dem Bewerten, Auswaehlen oder Ueberwachen von Menschen, eine nach ausdruecklich verbotenen Verwendungen.

> Nach `outcome = GEEIGNET` MUSS ein Zweckbestimmungs-Schritt folgen. Er fragt zweierlei getrennt: **erstens**, ob die Anwendung Menschen bewertet, auswählt oder überwacht — bei Bewerbung, Beschäftigung, Kreditwürdigkeit, Versicherung, Bildung, Biometrie; **zweitens**, ob sie Gefühle am Arbeitsplatz oder in der Bildung erkennen, Menschen nach sozialem Verhalten bewerten, Schwächen wegen Alter, Behinderung oder Notlage ausnutzen oder Gesichter ungezielt sammeln soll.

**K04-M20** · MUSS — Trifft die erste Frage zu, muss der Bildschirm Warnung, Hinweis auf die eigenen Pflichten des Kunden und die Aufforderung zur Bestaetigung zeigen; trifft die zweite zu, stattdessen den Ablehnungsgrund.

> Bei einem Treffer in der **ersten** Frage MUSS der Schritt drei Dinge zeigen: die Warnung, dass die Anwendung dem Anhang III der KI-Verordnung unterfallen kann; den Hinweis, dass der Kunde sie als Anbieter unter eigenem Namen in Verkehr bringt und damit die Pflichten aus Art. 9, 11, 14, 17 und 43 trägt; und die Aufforderung, dies zu bestätigen.

**K04-D10** · DARF NICHT — Ein Treffer in der zweiten Frage beendet den Weg endgueltig -- weder Aufklaerung noch Bestaetigung heilen ihn, weil die Verwendung ganz verboten ist.

> Ein Treffer in der **zweiten** Frage DARF NICHT weitergeführt werden.

**K10-M34** · MUSS — Das Uebergabe-Paket muss Zweckbestimmung, Grenzen, verwendete Modelle samt Anbieter und die Kenntnisnahme enthalten, damit der Kunde seine eigenen Pflichten beurteilen kann.

> Das Paket MUSS die Angaben führen, die der Kunde braucht, um seine eigenen Pflichten aus der KI-Verordnung zu beurteilen: Zweckbestimmung der Anwendung, ihre Grenzen, die verwendeten Modelle mit ihrem Anbieter, und die Kenntnisnahme aus K04 Abschn. 3.

### geprueste Anwendung und Arbeitsdokument duerfen nie verwechselt werden

**K01-G10** · GILT — Nur eine geprueste Anwendung kann Gegenstand einer Angebotsanfrage sein; ein Direkt-Prototyp ist ein blosses Arbeitsdokument.

> Es GILT die Unterscheidung, die den Weg gleich zu Beginn entscheidet: eine geprüfte Anwendung kann Gegenstand einer Angebotsanfrage sein, ein Direkt-Prototyp ist ein Arbeitsdokument und ist es nicht (K07).

**K04-D07** · DARF NICHT — Ein Direkt-Prototyp darf nirgends so aussehen, als waere er eine geprueste Anwendung.

> Ein Direkt-Prototyp DARF NICHT als geprüfte Anwendung dargestellt werden. Er bleibt Arbeitsdokument in `direct_prototype` (Eigentümer K07).

**K04-G05** · GILT — Kurzfassung derselben Unterscheidung: Arbeitsdokument hier, angebotsfaehige geprueste Anwendung dort.

> Es GILT: der Direkt-Prototyp ist ein Arbeitsdokument (K07), die geprüfte Anwendung kann Gegenstand einer Angebotsanfrage sein (K01).

**K07-D04** · DARF NICHT — Ein Direkt-Prototyp darf weder wie eine geprueste Anwendung dargestellt werden noch in eine Angebotsanfrage geraten.

> Ein Direkt-Prototyp DARF NICHT als geprüfte Anwendung dargestellt werden und NICHT Gegenstand einer Angebotsanfrage sein.

**K07-D05** · DARF NICHT — Ein Arbeitsdokument kann nachtraeglich nicht zur gepruesten Anwendung umgestempelt werden; der Wechsel ist im Bestand ausgeschlossen.

> Die Marke Arbeitsdokument DARF NICHT auf `VERIFIED_APP` umgestellt werden. Ein Wechsel zur Marke der geprüften Anwendung ist im Bestand ausgeschlossen.

**K07-D06** · DARF NICHT — Direkt-Prototypen und geprueste Anwendungen duerfen nicht in derselben Liste stehen.

> Ein Direkt-Prototyp DARF NICHT in derselben Liste wie die geprüften Anwendungen erscheinen.

**K07-G03** · GILT — Zwei spiegelbildliche Bedingungen in der Datenbank halten die Anwendung auf gepruest und den Direkt-Prototyp auf Arbeitsdokument fest, so dass eine Verwechslung im Bestand unmoeglich wird.

> Es GILT: Die beiden Bedingungen sind spiegelbildlich — die eine nagelt die Anwendung auf geprüft fest (Eigentümer K01), die andere den Direkt-Prototyp auf Arbeitsdokument.

**K07-G04** · GILT — Ein Direkt-Prototyp entsteht schon in der Vorpruefung, nicht im Gespraech, und hat gar keinen Bezug zu einer Anwendung.

> Es GILT: Ein Direkt-Prototyp entsteht in der Vorprüfung (Eigentümer K04), nicht im Gespräch. Er hat keinen Bezug zu einer Anwendung.

**K07-G07** · GILT — Der Sinn der Trennung ist, dass niemand ein Arbeitsdokument fuer eine geprueste Anwendung haelt.

> Es GILT: Die scharfe Trennung beider Bereiche ist der Zweck, nicht die Form. Ein Arbeitsdokument, das für eine geprüfte Anwendung gehalten wird, ist genau das Risiko, das vermieden werden soll.

**K07-M14** · MUSS — Der Bereich der Direkt-Prototypen steht sichtbar abgesetzt und traegt den ausdruecklichen Hinweis, dass diese nicht beauftragbar sind.

> Der Bereich der Direkt-Prototypen MUSS deutlich abgesetzt vom Bereich der geprüften Anwendungen stehen und den Hinweis führen, dass es sich nicht um beauftragbare Anwendungen handelt.

### der Zustand einer Anwendung: Wechsel, lueckenloser Verlauf, Anzeige

**K01-M28** · MUSS — Ein Zustandswechsel laeuft nur ueber einen einzigen Serverbefehl, der sperrt, prueft, drei Stellen gleichzeitig schreibt und bei jedem Fehler alles zuruecknimmt.

> Ein Zustandswechsel MUSS ausschließlich über `change_app_state` laufen. Der Befehl sperrt die Anwendung, prüft erlaubten Übergang und Berechtigung und schreibt `app.lifecycle_state`, `app_state_history` sowie `event` atomar.

**K11-M08** · MUSS — Der Zustandsverlauf jeder Anwendung wird lueckenlos gefuehrt, je Zeile ein Zustand mit seinem Gueltigkeitszeitraum.

> Jede Anwendung MUSS lückenlos in `app_state_history` geführt werden: je Zeile ein Betriebszustand und ein Gültigkeitszeitraum, Schlüssel aus Anwendung und Zeitraum.

**K11-M09** · MUSS — Zwei Verlaufszeilen derselben Anwendung duerfen sich zeitlich nicht ueberschneiden; die Datenbank weist das zurueck.

> Zwei Verlaufszeilen derselben Anwendung MÜSSEN überschneidungsfrei sein. Die Ausschlussbedingung weist einen überlappenden Zeitraum zurück.

**K11-G05** · GILT — Die Ansicht des aktuellen Zustands ist nur eine Leseansicht und schuetzt nichts; die Grenze zwischen Mandanten zieht der Server.

> Es GILT: `app_state_aktuell` ist eine Lesesicht auf Anwendung, Zustand und Beginn — kein Schreibschutz, ohne eigenen Mandantenbezug; die Grenze zieht der Serverpfad (K13 Abschn. 3).

**K11-G08** · GILT — In der Kundenliste stehen die Zustandsmarken aller Anwendungen eines Kunden nebeneinander.

> Es GILT: Die Kundenliste zeigt je Kunde die Zustandsmarken seiner Anwendungen nebeneinander — bei drei Anwendungen bis zu drei Marken.

**K01-M10** · MUSS — Jede Anwendungskarte zeigt Name, genau einen Zustandsnamen, Stufe und offenen Schritt, und Fortfuehren springt an die gespeicherte Stelle zurueck, nicht an den Stufenanfang.

> Jede Karte einer Anwendung MUSS Name, genau einen Zustandsnamen sowie Stufe und offenen Schritt tragen. *Fortführen* MUSS an die gespeicherte Stelle zurückführen, nicht an den Anfang der Stufe.

**K09-M12** · MUSS — Bevor gesiegelt werden darf, muss die Anwendung den Zustand DISCOVERY verlassen haben; die Datenbank sichert das zusaetzlich ab.

> Vor dem Siegel MUSS die Anwendung den Betriebszustand DISCOVERY verlassen haben.

### nichts wird geloescht -- das Loeschverbot und seine einzige Ausnahme

**K01-D13** · DARF NICHT — Kunden und Anwendungen sind aenderbar, aber nicht entfernbar; die einzige Ausnahme sind Portal-Zugaenge.

> Kunden und Anwendungen DÜRFEN im Betriebs-Portal nicht gelöscht werden. Änderbar ist alles, entfernbar nichts; die einzige Ausnahme sind Portal-Zugänge unter den Bedingungen aus K20.

**K01-D17** · DARF NICHT — Auf keinem Bildschirm darf ein Knopf zum Entfernen von Kunde, Anwendung oder Protokolleintrag erscheinen; ein Fehleintrag wird korrigiert, nicht getilgt.

> Kein Bildschirm DARF eine Bedienung zum Entfernen eines Kunden, einer Anwendung oder eines Protokolleintrags zeigen (F36).

**K11-D01** · DARF NICHT — Dieselbe Sperre, hier ausdruecklich fuer das Betriebs-Portal formuliert.

> Kein Bildschirm des Betriebs-Portals DARF eine Löschfunktion für Kunden, Anwendungen oder Protokolleinträge zeigen (F36).

**K15-D01** · DARF NICHT — Dieselbe Sperre, hier ausdruecklich fuer das App-Portal formuliert.

> Kein Bildschirm des App-Portals DARF ein Bedienelement zum Entfernen eines Kunden, einer Anwendung oder eines Protokolleintrags zeigen (F36).

**K20-D09** · DARF NICHT — Die einzige Ausnahme gilt nur fuer Portal-Zugaenge und darf nicht ausgeweitet werden.

> Die Ausnahme vom Löschverbot DARF NICHT über den Portal-Zugang hinaus ausgedehnt werden. Kunde, Anwendung und Protokolleintrag bleiben unantastbar (F36; K01 Abschn. 3).

**K07-G05** · GILT — Der Direkt-Prototyp ist das einzige Objekt, das der Nutzer selbst entfernen darf, weil er keiner der drei geschuetzten Klassen angehoert.

> Es GILT: Der Direkt-Prototyp ist das **einzige** Objekt, das der Nutzer selbst entfernen darf.

**K15-G08** · GILT — Der Papierkorb fuer Arbeitsdokumente ist vom Loeschverbot nicht betroffen.

> Es GILT: Der Papierkorb der Arbeitsdokumente ist von F36 nicht berührt. F36 nennt Kunden, Anwendungen und Protokolleinträge; ein Arbeitsdokument ist keines davon (Eigentümer K07).

**K02-G11** · GILT — Ein Protokolleintrag bleibt bestehen, auch wenn die Anwendung oder der Mandant wegfaellt; er verliert nur den Verweis.

> Es GILT: Ein Protokolleintrag überlebt seinen Bezug. Entfällt die Anwendung oder der Mandant, bleibt der Eintrag bestehen und verliert nur den Verweis.

**K10-G03** · GILT — Faellt eine Anwendung weg, fallen ihre Dokumente und ihr Testpaket mit weg -- ausgeloest allein vom Aufbewahrungslauf, nie von einer Bedienung.

> Es GILT: Entfällt die Anwendung, entfallen Dokumente und Testpaket mit ihr.

**K11-G14** · GILT — Ein versehentlich doppelt angelegter Kunde wird nicht geloescht, sondern eindeutig umbenannt und bleibt ohne Anwendung stehen.

> Es GILT: Ein doppelt angelegter Kunde bleibt bestehen; er wird eindeutig umbenannt und trägt keine Anwendung (Handbuch 12).

### Aufbewahrung und Fristen haengen an der Anwendung

**K01-M20** · MUSS — Jede Anwendung traegt eine Aufbewahrungsklasse; das Loeschdatum ist nur ein Protokolleintrag der ausgefuehrten Massnahme, nie ein Bedienelement.

> Jede Anwendung MUSS eine Aufbewahrungsklasse tragen (`retention_class`, Vorgabe HANDELSRECHT, Verweis auf `retention_rule` — Eigentümer K15).

**K15-M10** · MUSS — Die Faelligkeitstabelle fuehrt sechs Arten von Bezugsobjekten, darunter die Anwendung selbst.

> `retention_due` MUSS sechs Bezugsobjekte führen: Anwendung (Eigentümer K01), Dokument (Eigentümer K10), Protokolleintrag (Eigentümer K02), Arbeitsdokument (Eigentümer K07), Vorprüfung (Eigentümer K04) und Prüflauf (Eigentümer K06).

**K15-M12** · MUSS — Je nach Klasse laeuft die Frist ab Jahresende, ab dem Zeitpunkt der Zeile oder ab dem Datum der zugehoerigen Anwendung.

> Klassen mit `fristbeginn = ENTSTEHUNGSJAHRESENDE` MÜSSEN vom 31. Dezember des Entstehungsjahres an rechnen, Klassen mit ERSTELLUNG vom Zeitpunkt der Zeile, Klassen mit BEZUGSOBJEKT vom Datum der zugehörigen Anwendung (Eigentümer K01).

**K15-G05** · GILT — Der KI-Nachweis hat keine eigene Frist, sondern erbt die Faelligkeit seiner Anwendung.

> Es GILT: KI_NACHWEIS hat keine eigene Regelfrist, sondern erbt die Fälligkeit der zugehörigen Anwendung (Eigentümer K01). Das ist die Bedeutung von `fristbeginn = BEZUGSOBJEKT`.

**K15-M22** · MUSS — Eine Vorpruefung mit Anwendungsbezug wird als KI-Nachweis aufbewahrt, eine ohne Bezug als Betriebsprotokoll; ein spaeter entstehender Bezug hebt die Klasse nach.

> Die Aufbewahrungsklasse einer Vorprüfung MUSS ihrer Bindung folgen: mit Anwendungsbezug `KI_NACHWEIS`, ohne Bezug `BETRIEBSPROTOKOLL`.

### wer sehen und schreiben darf -- Zurechnung und die Grenze zwischen Mandanten

**K01-M13** · MUSS — Jede Handlung an den Daten einer Anwendung muss einem angemeldeten Konto zugeordnet sein, sonst entsteht ueberhaupt kein Vorgang.

> Jede Handlung, die Daten einer Anwendung erzeugt, ändert oder freigibt, MUSS einem angemeldeten Konto zugeordnet sein. Ohne diese Zuordnung entsteht kein Vorgang; Konto führt K03, Nachweis führt K02.

**K05-M27** · MUSS — Wer ein Dokument sehen darf, wird ausschliesslich ueber die Anwendung des Dokuments bestimmt; Dateien sind nur ueber kurzlebige, serverseitig freigegebene Zugriffe erreichbar.

> RLS und Serverpfad leiten den Mandanten ausschließlich über `document.app_id → app.tenant_id` ab.

**K08-M22** · MUSS — Bei Projektquellen prueft der Server Mandant und Anwendung, und kein technischer Schluessel darf diese Grenze umgehen.

> RLS und Serverpfad prüfen bei Projektquellen Mandant und Anwendung. Globale Quellen sind nur nach Plattformfreigabe lesbar. Ein Service- oder Builder-Schlüssel darf diese Grenze nicht umgehen.

**K10-D09** · DARF NICHT — In ein Uebergabe-Paket darf nichts geraten, was zu einer anderen Anwendung gehoert.

> Ein Bestand einer fremden Anwendung DARF NICHT in ein Paket geraten. Die Zuordnung über die Anwendung ist die Grenze.

**K10-M22** · MUSS — Jeder Abruf des Pakets wird serverseitig gegen Anwendung, Mandant, Person und freigegebene Paketfassung geprueft; dauerhaft gueltige oder oeffentliche Links sind unzulaessig.

> Jeder Abruf MUSS privat und serverseitig für Anwendung, Mandant, Person und freigegebene Paketrevision autorisiert werden.

**K09-D03** · DARF NICHT — Preis- und Betragsfelder der Anwendung duerfen nicht an das Endnutzer-Portal ausgeliefert werden, auch nicht unsichtbar im Datenpaket.

> Der Serverpfad DARF `offer_price_cents` und jedes andere Betragsfeld der Anwendung NICHT in eine Antwort an das Endnutzer-Portal aufnehmen — auch nicht ungezeigt im Antwortkörper.

**K14-G14** · GILT — Der Uebergabezugang fuehrt in die Betriebsumgebung der uebergebenen Anwendung, nicht in ein Portal der Plattform.

> Es GILT: Der Übergabezugang führt in die Betriebsumgebung der übergebenen Anwendung, nicht in ein Portal der Plattform. Ein Partner erhält daraus weder eine Portalrolle noch ein Freigaberecht.

### Selbstschutz des eigenen Kontos -- fuenfmal derselbe Satz in fuenf Papieren

**K01-G13** · GILT — Niemand kann sein eigenes Konto sperren oder loeschen; das ist eine Regel des laufenden Programms und wird durch einen Abnahmetest geprueft, nicht durch die Datenbank.

> Es GILT F15: die zwei Selbstschutz-Regeln — das eigene Konto lässt sich weder sperren noch löschen — liegen in der Anwendung, nicht im Schema. Sie sind ein Abnahmetest (K20), kein Schemafehler.

**K03-G07** · GILT — Dieselbe Selbstschutzregel, hier aus Sicht des Anmeldekonzepts.

> Es GILT F15: Das eigene Konto lässt sich weder sperren noch entfernen. Diese Regel liegt in der Anwendung, ihr Abnahmetest bei K20.

**K14-G08** · GILT — Dieselbe Selbstschutzregel, hier aus Sicht der Sicherheits-Grundlinie.

> Es GILT F15: Die beiden Selbstschutz-Regeln — das eigene Konto lässt sich weder sperren noch entfernen — liegen in der Anwendung, nicht im Schema. Sie sind ein Abnahmetest (K20), kein Schemafehler.

**K20-G06** · GILT — Dieselbe Selbstschutzregel, hier aus Sicht der Zugangsverwaltung.

> Es GILT F15: Das eigene Konto lässt sich weder sperren noch entfernen. Diese Regel liegt in der Anwendung und ist ein Abnahmetest dieses Konzepts, kein Fehler des Datenmodells.

**K19-G07** · GILT — Bereits abgeschlossene Stufen lassen sich nur noch ansehen, und der Selbstschutz des eigenen Kontos gilt als Abnahmetest.

> Es GILT: zurückliegende Stufen öffnen sich nur als Nur-Ansicht. Rollentrennung bei Freigaben gehört K14, der Selbstschutz gegen Sperren des eigenen Kontos ist nach F15 ein Abnahmetest der Anwendung.

### was ausdruecklich NICHT in die Anwendung hineinschreibt: Nebenfragen-Fenster und Agenten

**K01-D10** · DARF NICHT — Was im Nebenfragen-Fenster unter dem Gespraech gefragt wird, erzeugt keinen Eintrag, keine Anforderung und kein Dokument.

> Der Inhalt des Nebenfragen-Fensters unter dem Gespräch DARF NICHT in die Anwendung einfließen.

**K16-D07** · DARF NICHT — Dieselbe Sperre, hier im Bedien-Standard formuliert.

> Der Inhalt des Nebenfragen-Fensters DARF NICHT in die Anwendung einfließen — kein Eintrag in der rechten Spalte, keine Anforderung, kein Dokument.

**K16-M19** · MUSS — Das Nebenfragen-Fenster laeuft technisch getrennt und hat gar kein Schreibrecht auf die Anwendung.

> Das Nebenfragen-Fenster MUSS serverseitig getrennt geführt werden: eigener Aufrufweg, eigener Verlauf, kein Schreibrecht auf die Anwendung.

**K16-M20** · MUSS — Das Fenster sagt dem Nutzer selbst, dass sein Inhalt nicht in die Anwendung einfliesst.

> Das Nebenfragen-Fenster MUSS im Fenster selbst tragen, dass sein Inhalt nicht in die Anwendung einfließt.

**K17-D11** · DARF NICHT — Der Hilfe-Agent schreibt keinen Inhalt in die Anwendung.

> Der Hilfe-Agent DARF keinen Inhalt in die Anwendung schreiben. Der Verlauf des Nebenfragen-Fensters erzeugt keine Anforderung und kein Dokument (K16 Abschn. 3).

**K25-D23** · DARF NICHT — Der Prototyp-Erzeuger und der Review-Agent duerfen an keiner dieser Stellen unmittelbar schreiben.

> Erzeuger und Review-Agent DÜRFEN NICHT unmittelbar auf Anwendung, Vorlage, Ereignis, Freigabe oder fachlichen Dienst schreiben.

**K17-M11** · MUSS — Der Review-Agent prueft zusaetzlich, ob eine Plattformregel fehlt, die fuer diese Anwendung gelten muesste.

> Der Review-Agent MUSS eine zweite Rubrik führen: Anwendbarkeit der Plattformregeln auf den Projektvertrag. Sie beantwortet, ob eine Plattformregel fehlt, die für diese Anwendung gelten müsste.

### Stellen, an denen "Anwendung" das laufende Programm meint und nicht das Kundenvorhaben

**K14-G03** · GILT — Was das Programm selbst prueft, darf die Datenbank gar nicht erst zulassen -- die Datenbank ist die letzte Sperre, nicht die erste.

> Es GILT der Grundsatz des Datenmodells: Was die Anwendung als Selbstprüfung führt, darf die Datenbank nicht zulassen. Die Bedingung in der Datenbank ist die letzte Sperre, nicht die erste.

**K01-G18** · GILT — Die Beschraenkung auf einen Rechtsraum und eine Waehrung steckt im Programm und in den Konzepten, nicht im Datenmodell.

> Es GILT: die Einschränkung auf einen Rechtsraum und eine Währung liegt in der Anwendung und in den Konzepten, nicht im Schema (F35).

**K18-M15** · MUSS — Bei Versionszeilen im Wissensbestand verlangt das Programm Bearbeiter und Aenderungsvermerk, obwohl die Datenbank sie offenlaesst.

> Jede Versionszeile MUSS Bearbeiter und Änderungsvermerk führen. Das Schema lässt beide Felder offen; die Anwendung verlangt sie, sonst ist die Historie nicht lesbar.

**K21-M03** · MUSS — Bei Richtlinien verlangt das Programm einen Geltungsbereich, obwohl die Datenbank ihn offenlaesst.

> Jede Richtlinie MUSS einen Geltungsbereich führen; das Schema lässt `scope` offen, die Anwendung verlangt ihn.

### das Gespraech: "Anwendung" als dritte Einordnungsfrage, und wie ein Stand gespeichert wird

**K05-M03** · MUSS — Die drei Einordnungsfragen des Gespraechs kommen in fester Reihenfolge, und die dritte heisst Anwendung.

> Die drei Einordnungsfragen MÜSSEN in fester Reihenfolge gestellt werden: Branche, dann Funktionsbereich, dann Anwendung.

**K05-M04** · MUSS — Zu jeder Einordnungsfrage gehoert genau eine offene Ausweichantwort, hier Andere Anwendung.

> Jede Einordnungsfrage MUSS neben den vorgeschlagenen Antworten genau eine offene Alternative führen — *Andere Branche*, *Anderer Funktionsbereich*, *Andere Anwendung*.

**K05-G02** · GILT — Die Antworten auf diese drei Fragen sind freie Eingaben des Nutzers, keine vorgegebene Liste.

> Es GILT: Branche, Funktionsbereich und Anwendung sind Eingabefelder des Nutzers, keine festgelegten Werte. Eine Zielbranche gibt es nicht; F16 hat sie gestrichen.

**K05-M26** · MUSS — Jedes erfolgreiche Speichern erzeugt Datei, Dokumentzeile und Protokolleintrag in dieser Reihenfolge, und der juengste Eintrag je Anwendung bestimmt, wo weitergearbeitet wird.

> Jeder erfolgreiche Speichervorgang erzeugt zuerst die Datei, dann die `document`-Zeile und zuletzt ein append-only `event`. Der jüngste erfolgreiche Eventeintrag je Anwendung verweist in `object_ref` auf Dokument-ID und Hash und bestimmt den wiederaufnehmbaren Stand.

### Anforderungen und Fachreview werden je Anwendung gezaehlt

**K06-M09** · MUSS — Zu einer Anwendung darf es je Fassung und Runde hoechstens einen Prueflauf geben.

> Je Anwendung, Artefaktfassung und Runde MUSS höchstens ein Prüflauf bestehen, getragen von der Eindeutigkeit über diese drei Spalten.

**K06-M29** · MUSS — Die Fassungsnummer je Anwendung und Unterlage vergibt der Server aufsteigend; eine blosse Reviewkorrektur erhoeht nur die Rundenzahl.

> `artifact_version` wird serverseitig als monoton steigende Ganzzahl-Zeichenfolge je Anwendung und Artefakt vergeben. Eine Inhaltsänderung erzeugt einen neuen Stand; eine Reviewkorrektur innerhalb desselben Inhaltsstands erhöht nur `round`.

**K06-D07** · DARF NICHT — Es darf keinen zweiten Prüfstrang geben, insbesondere kein gespiegeltes Bestehens-Kennzeichen an der Anwendung.

> Neben `review_run` DARF kein zweiter Prüfstrang entstehen: kein gespiegelter Prüfwert an der Anwendung, kein zweites Bestehenskennzeichen, keine abgeleitete Spalte.

### Vorlagenauswahl und Prototyp-Vorschau haengen an der Anwendung

**K25-M03** · MUSS — Die Statusspalte zeigt den Stand der nachgebildeten Anwendung.

> Die Statusspalte MUSS den Stand der nachgebildeten Anwendung zeigen.

**K25-M22** · MUSS — Jede Vorlagenauswahl erzeugt einen vollstaendigen Vermerk mit Anwendungs- und Mandantenbezug und allen Gruenden, die zur Auswahl gefuehrt haben.

> Jede Auswahl MUSS einen vollständigen Auswahlvermerk erzeugen: Auswahlkennung, Zeitpunkt, Anwendungs- und Mandantenbezug, Fassung der bestätigten Anforderungen, Profil mit Herkunft, Kandidaten vor und nach dem Filter, Deckungsgrade, Kennung und Fassung je Vorlage, angewandte Gleichstandsregel, Zweitplatzierter, Erzeuger- und Review-Agentenstand sowie Klartextsatz.

**K25-M23** · MUSS — Vorlage, Fassung und Auswahlvermerk muessen ueber einen freigegebenen Serverbefehl an der Anwendung festgehalten sein, bevor ueberhaupt eine Vorschau entsteht.

> Vorlage, Fassung und der vollständige Auswahlvermerk nach K25-M22 — er **ist** die Begründung — MÜSSEN über einen vom Eigentümer K01 freigegebenen Serverbefehl an der Anwendung festgehalten sein, bevor eine Vorschau entsteht.

**K25-G06** · GILT — Die Zeitgrenze fuer den Erzeuger haengt an genau einem Feld, dem Siegel an der Anwendung.

> Es GILT: Die Zeitgrenze hängt an genau einem Feld, dem Siegel an der Anwendung. Es gibt keine zweite Zustandsquelle.

### Dokumente und Uebergabe-Paket haengen an der Anwendung

**K10-M01** · MUSS — Jedes Dokument ist genau eine Zeile und gehoert zu einer Anwendung; ohne Anwendung entsteht kein Dokument.

> Jedes Dokument MUSS als genau eine Zeile in `document` bestehen und einer Anwendung zugeordnet sein. Ohne Anwendung entsteht kein Dokument.

**K10-M04** · MUSS — Zu einer Anwendung gibt es hoechstens ein Testpaket.

> Zu jeder Anwendung MUSS höchstens ein Testpaket bestehen. Der Schlüssel von `test_harness` ist die Anwendung selbst und erzwingt das.

**K10-G02** · GILT — Es gibt genau ein Paket je Anwendung, keine zweite Fassung daneben.

> Es GILT: Der Schlüssel von `test_harness` ist die Anwendung. Es gibt daher genau ein Paket je Anwendung — keine zweite Fassung, kein Nebeneinander.

**K10-M18** · MUSS — Jede Uebergabe erzeugt einen Protokolleintrag mit Anwendung, Zeitpunkt und handelnder Stelle.

> Jede Übergabe MUSS einen Protokolleintrag erzeugen (Träger `event`, Eigentümer K02) mit Anwendung, Zeitpunkt und handelnder Instanz.

**K10-M19** · MUSS — Jede Uebergabe traegt eine unveraenderliche Kennung aus Anwendung, Projektnummer, Paketstand, Vertragsstand, Zeitpunkt und Quellstand; aendert sich der Inhalt, gilt die alte Freigabe nicht weiter.

> Jede Übergabe MUSS eine unveränderliche Release-Kennung führen: Anwendung, Projektnummer, Paketrevision, Projektvertragsrevision, Erzeugungszeitpunkt und Quellrevision.

**K01-M24** · MUSS — Dass die beiden Mitbestimmungs-Unterlagen uebergeben wurden, wird als Zeitpunkt an der Anwendung festgehalten -- eine eigene Stufe dafuer gibt es nicht mehr.

> Die Übergabe der beiden Unterlagen MUSS als Zeitpunkt an der Anwendung nachgewiesen werden — die Stufe dafür ist gestrichen, geblieben ist die Spalte `mitbestimmung_ack_at` (F03).

---

## Gespraech

*ein Gespraechspfad (Stufen 01-02)* — BS:63 · **42 Regeln**

**Anmerkung:** Drei Hinweise zum Lesen, keine Zuordnungsentscheidung. (1) K04-M08 wurde nur wegen des Wortes "Gespräch" getroffen, meint dort aber etwas anderes: einen Rückruf- bzw. Termin mit einem Menschen (der Ansprechperson) nach einem Halt in der Vorprüfung, nicht das gefuehrte Gespraech im Portal. (2) K11-M12 und K16-M10 enthalten das Wort Gespraech gar nicht in der Sache: sie regeln, woher die angezeigten NAMEN der acht Betriebszustaende kommen (eine Uebersetzungstabelle je Anzeigesprache). Sie stehen hier, weil sie an derselben Zustandsmechanik haengen wie der Gespraechsstand. (3) K17-D10 und K17-M10 sind Regeln ueber einen Pruef-Agenten (eine zweite, kontrollierende Maschine): sie sagen, was dieser Agent NICHT bekommen darf, naemlich den Gespraechskontext. Sie beschreiben also keinen Schritt im Gespraech selbst, sondern eine Abschottung daneben. (4) K09-D08 spricht vom Gespraech, regelt aber den Zeitpunkt NACH dem Absenden des Angebots.

### Wie der Gespraechsbildschirm aufgebaut und bedient wird

**K01-M06** · MUSS — Das Gespraech laeuft in fuenf festen Stufen, und oben rechts sieht der Kunde eine Leiste mit allen fuenf, in der die gerade erreichte Stufe hervorgehoben ist. (K01 ist das Rahmenkonzept, das Dokument, das die Grundordnung des Ganzen festlegt.)

> Das Portal MUSS das Gespräch in genau fünf Stufen führen. Die Fortschrittsleiste über der rechten Spalte MUSS alle fünf zeigen und die erreichte markieren.

**K01-M07** · MUSS — Der Bildschirm ist immer in zwei Spalten geteilt: links redet oder klickt man, rechts erscheint sofort das Ergebnis - man muss nicht zwischen mehreren Formularen hin und her springen.

> Jeder Bildschirm mit Gespräch MUSS zweigeteilt sein: links wird gesagt oder geklickt, rechts erscheint das Ergebnis, unmittelbar und ohne Wechsel zwischen getrennten Formularen.

**K25-M01** · MUSS — Dasselbe Zweispalten-Bild gilt auch fuer den Rahmen um den Prototyp: auf breitem Bildschirm links das Gespraech, rechts der Stand. (K25 ist das Konzept fuer den Prototyp-Erzeuger und seine festen Woerter und Sperren; "Huelle" ist der Rahmen, in dem der Prototyp angezeigt wird.)

> Die Hülle MUSS zweigeteilt sein: in breiter Darstellung links das Gespräch, rechts der Stand; in schmaler Darstellung gilt K25-M08.

**K25-M02** · MUSS — Die linke Spalte hat ueberall dieselben vier Bedienteile: den bisherigen Verlauf, Vorschlaege zum Anklicken, ein freies Textfeld und einen Senden-Knopf.

> Die Gesprächsspalte MUSS dieselben Bedienelemente führen wie die Grundform des geführten Gesprächs: Verlauf, Vorschläge, Freitextfeld, Senden.

**K25-M08** · MUSS — Auf einem schmalen Bildschirm (etwa Handy) rutscht die rechte Spalte einfach unter das Gespraech - weggelassen wird nichts.

> Die Hülle MUSS in schmaler Darstellung verlustfrei sein. Der Stand folgt dann unter dem Gespräch; nichts entfällt.

**K25-G03** · GILT — Der Bildschirm besteht aus genau drei Bereichen - aeusserer Rahmen, Gespraechsspalte, Statusspalte - und einen vierten Bereich gibt es nicht.

> Es GILT die Gliederung in drei Zonen: A Rahmen, B Gesprächsspalte, C Statusspalte. Zone A gehört nicht K25. Eine Zone D gibt es nicht.

**K05-M20** · MUSS — Sprechen statt tippen gibt es in zwei klar getrennten Formen: ein Mikrofon, das Gesagtes ins Textfeld schreibt, und ein Knopf "Sprechen", der das ganze Gespraech freihaendig fuehrt. (K05 ist das Konzept fuer das gefuehrte Gespraech, Stufen 01 und 02.)

> Der Stimmweg MUSS zwei getrennte Bedienungen führen: Das Mikrofon diktiert in das Eingabefeld, *Sprechen* führt das Gespräch freihändig.

### Die Vorlagen, aus denen ein Gespraechsbildschirm gebaut wird

**K25-M14** · MUSS — Es gibt genau drei Sorten von Vorlagen - eine fuer das Gespraech, eine fuer die Statusspalte, eine fuer einzelne Bausteine - und keine vierte.

> Das Vorlagen-Universum MUSS aus genau drei Arten bestehen: Gesprächsvorlage, Statusvorlage, Elementvorlage. Eine vierte Art entsteht nicht.

**K25-M15** · MUSS — Jede Gespraechsvorlage haelt dieselbe Grundform ein; Vorlagen duerfen sich in Einzelheiten unterscheiden, aber nicht von der Grundform abweichen.

> Jede Gesprächsvorlage MUSS die Grundform tragen: Gespräch im Vordergrund, Stand daneben, in schmaler Darstellung darunter. Die Vorlagen unterscheiden sich innerhalb der Grundform, nicht von ihr weg.

### Der Warnhinweis, der immer ueber dem Gespraech steht

**K01-M08** · MUSS — Ueber dem Gespraech steht dauerhaft und unwegklickbar der Hinweis, dass die maschinellen Vorschlaege Fehler enthalten koennen und dass Zahlen und Namen vor dem Bestaetigen zu pruefen sind.

> Über dem Gespräch MUSS dauerhaft der Hinweis stehen, dass Vorschläge der Modelle Fehler enthalten können und Zahlen und Namen vor der Bestätigung zu prüfen sind. Der Hinweis ist nicht wegklickbar.

**K05-M14** · MUSS — Derselbe Hinweis gilt ausdruecklich in beiden Stufen des gefuehrten Gespraechs (Stufe 01 und Stufe 02).

> Über dem Gespräch MUSS in beiden Stufen der nicht wegklickbare Hinweis stehen, dass Vorschläge der Modelle Fehler enthalten können (K01 Abschn. 3).

**K16-M09** · MUSS — Derselbe Hinweis noch einmal als allgemeine Bedienregel fuer das ganze Portal. (K16 ist der Bedien-Standard, das Dokument mit den einheitlichen Bedienregeln.)

> Über dem Gespräch MUSS dauerhaft stehen, dass Vorschläge Fehler enthalten können. Der Hinweis ist nicht wegklickbar (K01 Abschn. 3).

### Der Stand ueberlebt das Abmelden: Speichern und spaeter weitermachen

**K01-M09** · MUSS — Ab der zweiten Stufe gibt es unter dem Gespraech einen Knopf zum Unterbrechen; wer sich abmeldet, findet alles wieder vor - nichts existiert nur waehrend einer Sitzung.

> Ab Stufe 02 MUSS unter dem Gespräch *Speichern, später weitermachen* stehen. Der Stand MUSS das Abmelden überleben; es gibt keinen Vorgang, der nur innerhalb einer Sitzung besteht.

**K05-M15** · MUSS — Dieselbe Forderung, hier im Konzept des gefuehrten Gespraechs selbst wiederholt.

> Ab Stufe 02 MUSS unter dem Gespräch *Speichern, später weitermachen* stehen. Der Stand MUSS das Abmelden überleben (K01 Abschn. 3).

### Fragen ueberspringen und spaeter nachtragen

**K05-M10** · MUSS — In Stufe 02 darf jede Frage uebersprungen werden; das hinterlaesst rechts einen Vermerk, der nur den Text "(Frage uebersprungen)" traegt und keinerlei Gespraechsinhalt.

> Jede Frage in Stufe 02 MUSS überspringbar sein. *Diese Frage ignorieren* MUSS den Übersprungvermerk in die rechte Spalte schreiben.

**K16-M24** · MUSS — Eine uebersprungene Frage bleibt in der Zusammenfassung sichtbar als uebersprungen stehen und kann nachgeholt werden, solange das Gespraech noch offen ist.

> Eine übersprungene Frage MUSS in der Zusammenfassung als solche vermerkt und nachtragbar bleiben, solange das Gespräch läuft.

### Wer hat das gesagt - Mensch oder Maschine, und wer sitzt mit am Tisch

**K05-D02** · DARF NICHT — Jeder inhaltliche Eintrag traegt eindeutig, ob er vom Menschen oder von der Maschine stammt; gemischt oder unmarkiert geht nicht, und der Uebersprungvermerk darf nicht als Hintertuer fuer unmarkierten Inhalt missbraucht werden.

> Eine KI-Notiz DARF NICHT als eigene Angabe des Nutzers erscheinen, und eine eigene Angabe DARF NICHT als KI-Notiz erscheinen.

**K05-M16** · MUSS — Oben rechts steht, wer am Gespraech beteiligt ist - mindestens der angemeldete Nutzer und der maschinelle Assistent als Gespraechsfuehrer; weitere eingeladene Mitarbeiter koennen dazukommen.

> Stufe 02 MUSS oben in der rechten Spalte die Teilnehmer des Gesprächs nennen: mindestens den angemeldeten Nutzer und den Assistenten als Moderator.

**K11-G12** · GILT — Im Protokoll (der unveraenderlichen Liste aller Vorgaenge) steht bei jedem Eintrag, wer gehandelt hat: entweder ein Mensch oder das System selbst. (K11 ist das Konzept fuer das Betriebs-Portal, die interne Sicht des Betreibers.)

> Es GILT: Als handelnde Instanz erscheint im Protokoll eine Person oder das System — etwa wenn ein Zustandswechsel aus dem Gesprächsverlauf folgt.

### Das Nebenfragen-Fenster bleibt folgenlos

**K01-D10** · DARF NICHT — Was der Kunde in dem kleinen Nebenfenster fragt, wirkt sich auf nichts aus: kein Eintrag in der rechten Spalte, keine Anforderung, kein Dokument.

> Der Inhalt des Nebenfragen-Fensters unter dem Gespräch DARF NICHT in die Anwendung einfließen.

**K16-M18** · MUSS — Der Knopf unter dem Gespraech oeffnet genau dieses Nebenfenster und loest sonst gar nichts aus.

> Die gleichnamige Schaltfläche unter dem Gespräch MUSS das Nebenfragen-Fenster öffnen und nichts sonst.

### Nur ein Strang fuer den Stand - und woher die angezeigten Zustandsnamen kommen

**K01-G02** · GILT — Es gibt zwei getrennte Sichten auf denselben Vorgang: die Betriebssicht (wie weit ist das Geschaeft) und die Kundensicht (wie weit ist mein Gespraech). Anzeigetexte wie "In Klaerung" oder "Angebot angefragt" sind nur abgeleitete Etiketten, keine eigenen Zustaende.

> Es GILT F21: `lifecycle_state` ist der Blick des Betriebs auf das Geschäft, `journey_phase` der Blick des Kunden auf sein Gespräch.

**K16-G03** · GILT — Dieselbe Zweiteilung als Bedienregel: zwei Achsen, und daneben darf kein weiterer Status-Strang entstehen.

> Es GILT F21: zwei Achsen, kein zweiter Statusstrang. `lifecycle_state` beschreibt das Geschäft, `journey_phase` das Gespräch.

**K05-D11** · DARF NICHT — Der Stand des Gespraechs wird an genau einer Stelle gefuehrt; keine Kopie, kein Zaehler und keine zweite Spalte daneben, die dasselbe noch einmal sagt.

> Neben `app.journey_phase` DARF kein zweiter Strang für den Stand des Gesprächs entstehen — kein gespiegeltes Feld, kein Zähler, keine abgeleitete Spalte (Eigentümer K01).

**K16-M10** · MUSS — Kein Zustandsname wird im Bildschirm frei hingeschrieben; er kommt immer aus einer zentralen Uebersetzungstabelle, ausgewaehlt nach Zustand und Sprache.

> Jeder angezeigte Zustandsname MUSS aus `lifecycle_state_label` stammen, ausgewählt über Zustand und Anzeigesprache.

**K11-M12** · MUSS — Diese Uebersetzungstabelle muss vollstaendig sein: acht Betriebszustaende mal zwei Anzeigesprachen ergibt sechzehn Eintraege.

> `lifecycle_state_label` MUSS für jeden der acht Betriebszustände je Anzeigesprache genau einen Text führen. Vollständig sind das sechzehn Zeilen; Schlüssel ist Zustand und Sprache.

### Wann ein Gespraech ueberhaupt beginnen darf - und wann keines beginnt

**K02-M30** · MUSS — Solange fuer den Kunden kein Vertrag hinterlegt ist, verweigert der Server den Start eines Gespraechs - die Pruefung sitzt im Server, nicht bloss in der Oberflaeche, und sperrt genauso hart wie die Einladungsschranke. (K02 ist das Fundament, das Konzept der technischen Grundlagen.)

> Ohne hinterlegten Vertrag MUSS der Beginn eines Gesprächs für diesen Mandanten serverseitig abgelehnt werden.

**K04-D04** · DARF NICHT — Faellt die Vorpruefung negativ aus, gibt es kein Gespraech, keine Anwendung und keine Angebotsanfrage. (K04 ist das Konzept fuer Eignungs- und Schnell-Check, also die Vorpruefung.)

> Ein Check mit NICHT_GEEIGNET DARF NICHT ins Gespräch führen. Es entsteht keine Anwendung (Eigentümer K01) und keine Angebotsanfrage.

**K04-M08** · MUSS — Wenn die Vorpruefung stoppt, bekommt der Kunde genau drei Auswege angeboten: Antwort korrigieren, einen Termin mit einem Menschen vereinbaren, oder zurueck zur Uebersicht.

> Nach einem Halt MÜSSEN genau drei Auswege erscheinen: Antwort ändern, Gespräch mit der Ansprechperson vereinbaren, zur Übersicht zurückkehren.

**K07-G04** · GILT — Der sogenannte Direkt-Prototyp (ein blosses Arbeitsdokument) entsteht schon in der Vorpruefung und nicht im Gespraech; er haengt an keiner Anwendung. (K07 ist das Konzept Prototyp und Verfeinern.)

> Es GILT: Ein Direkt-Prototyp entsteht in der Vorprüfung (Eigentümer K04), nicht im Gespräch. Er hat keinen Bezug zu einer Anwendung.

### Aenderungen laufen ueber das Gespraech und werden dort sichtbar bestaetigt

**K07-M07** · MUSS — Jede Aenderung wird im Gespraech ausdruecklich bestaetigt und ist danach sofort in der Vorschau zu sehen.

> Jede Änderung MUSS im Gespräch bestätigt werden und sich unmittelbar auf die Vorschau auswirken.

**K07-D03** · DARF NICHT — Betraege und Regeln aendern sich nie stillschweigend im Hintergrund; was nach Stufe 03 auffaellt, wird entweder im Gespraech festgehalten oder an einen Menschen uebergeben.

> Eine Änderung an Beträgen oder Regeln DARF NICHT still geschehen. Fällt nach Stufe 03 etwas auf, wird es im Gespräch festgehalten oder an die Ansprechperson gegeben.

**K25-M24** · MUSS — Auch Aenderungen am Rahmen des Prototyps werden im Gespraech gesagt und im Gespraech bestaetigt - nirgends sonst.

> Jede Änderung an der Hülle MUSS in der Gesprächsspalte geäußert und dort bestätigt werden.

### Das Ende des Gespraechs: was festgehalten, uebergeben und danach zugemacht wird

**K05-M19** · MUSS — Der Knopf "Bin fertig mit dem Interview" bewirkt drei Dinge zugleich: die Kundensicht springt auf UEBERSICHT, es entsteht ein Protokolleintrag, und der Gespraechsstand geht an die Anforderungs-Stufe weiter - ohne Protokolleintrag findet kein Wechsel statt.

> *Bin fertig mit dem Interview* MUSS `journey_phase` auf UEBERSICHT setzen (Eigentümer K01), einen Protokolleintrag in `event` erzeugen (Eigentümer K02) und den Gesprächsstand an K06 übergeben.

**K05-M25** · MUSS — Der inhaltliche Gespraechsstand wird als unveraenderliche Datei abgelegt, die zu jedem Beitrag festhaelt: wer, auf welche Art entstanden, woher, in welchem Bearbeitungszustand, samt Pruefwert des vorigen Beitrags.

> Der fachliche Gesprächsstand wird als unveränderlicher, strukturierter Dateistand mit `document_kind = INTERVIEW_PROTOCOL` geführt.

**K07-D09** · DARF NICHT — Ist das Feinschleifen abgeschlossen, ist das Gespraech inhaltlich zu und wird nicht wieder aufgemacht.

> Nach dem Abschluss des Feilens DARF das Gespräch inhaltlich NICHT wieder geöffnet werden.

**K09-D08** · DARF NICHT — Ist das Angebot abgesendet, laesst sich am Gespraech nichts mehr aendern; die Uebersichtskarte bietet nur noch "Ansehen", und Aenderungswuensche gehen an einen Menschen. (K09 ist das Konzept Angebot und Freigabe.)

> Nach dem Absenden DARF das Gespräch nicht mehr verändert werden. Die Karte trägt *Ansehen* statt *Fortführen*; Änderungen laufen über die Ansprechperson.

### Der Pruef-Agent bekommt den Gespraechskontext ausdruecklich nicht

**K17-M10** · MUSS — Die kontrollierende Maschine urteilt nur ueber das vorgelegte Ergebnis und die Pruefragen - sie kennt weder die Quellen noch das Gespraech, damit sie nicht mitgezogen wird. (K17 ist das Konzept fuer Betrieb und Zusammenspiel der Agenten, also der arbeitenden Maschinenrollen.)

> Der Prüf-Agent MUSS blind arbeiten: allein Prüfgegenstand und Prüffragen, keine Quellen, kein Gesprächskontext.

**K17-D10** · DARF NICHT — Dasselbe als Verbot formuliert: es darf ihm nichts uebergeben werden, woraus er sehen koennte, wie das Ergebnis zustande kam.

> Dem Prüf-Agenten DÜRFEN weder Quellen noch Gesprächskontext noch die Herleitung des Prüfgegenstands übergeben werden.

### Was am Gespraechskonzept noch offen ist und wie es geprueft wird

**K05-G11** · GILT — Das Gespraechskonzept fuehrt keine eigene Datenablage; der Inhalt wird von anderen Konzepten getragen, und eine dort als offen gekennzeichnete Zeile darf nicht stillschweigend als Traeger unterstellt werden.

> Es GILT: K05 besitzt kein Datenobjekt.

**K05-G12** · GILT — Solange zwei benannte offene Punkte nicht geklaert sind, ist das Gespraechskonzept noch nicht freigegeben: fuer Gespraechsinhalt und Herkunftsmarke fehlt der belegte Ablageort, der produktive Weg ist gesperrt, und der Stimmweg ist zusaetzlich gesperrt, bis ein bewerteter Fall vorliegt.

> Es GILT: Solange O-K05-1 und O-K05-2 offen sind, bleibt K05 Freigabekandidat.

**K23-M08** · MUSS — Fuer das Gespraech, fuer die Bediensperren und fuer den Prototyp-Erzeuger gibt es je einen eigenen automatischen Test, der gegen genau die Regeln des jeweiligen Konzepts prueft. (K23 ist das Test- und Abnahmekonzept.)

> Discovery-Gespräch, Bedien-Sperren und Prototyp-Erzeuger MÜSSEN je eine eigene Modulprüfung gegen ihre eigenen Klauseln haben.

---

## Anforderungen

*... > Anforderungen/Vertrag (Stufe 03)* — BS:63 · **15 Regeln**

**Anmerkung:** Zweierlei Vorsicht beim Lesen. Erstens: vier der fuenfzehn Regeln sagen woertlich dasselbe -- K01-D10, K05-D07, K16-D07 und K17-D11 verbieten alle vier, dass der Inhalt des Nebenfragen-Fensters (das kleine Hilfe-Fenster neben dem Gespraech) eine Anforderung erzeugt. Sie stehen nur deshalb viermal da, weil vier verschiedene Konzeptpapiere dieselbe Sperre wiederholen. Wer eine gelesen hat, kennt alle vier. Zweitens: zwei Regeln benutzen das Wort 'Anforderung' in einer voellig anderen Bedeutung als der Faden. K16-M23 meint mit 'Anforderungen' die Bedienbarkeits-Vorgaben an einen Bildschirm (Tastatur, Fokus, schmale Ansicht) -- nicht das, was der Kunde fachlich braucht. K09-G07 meint mit 'die Anforderung' das Anfordern eines Angebots durch einen Menschen -- also einen Vorgang, nicht ein Dokument. Beide sind reine Worttreffer. Das ist ein Lesehinweis, keine Zuordnungsentscheidung.

### was Stufe 03 an Anforderungskonzepten fuehren muss und wie lang das Ergebnis sein darf

**K06-M01** · MUSS — In Stufe 03 des Kundenwegs entstehen genau sechs Themenhefte mit fest vorgegebenen Namen -- kein siebtes und kein fuenftes. (K06 ist das Konzeptpapier 'Anforderungskonzepte, Projektvertrag, Fachreview'; die Endung M01 heisst schlicht: die erste MUSS-Regel dieses Papiers.)

> Stufe 03 MUSS genau sechs Anforderungskonzepte führen: Prozess & Schritte, Daten & Systeme, Rollen & Aktionen, Regeln & Ausnahmen, Compliance, Ergebnis & Kennzahlen.

**K06-M23** · MUSS — Der Projektvertrag darf hoechstens vier Seiten bzw. rund 2.000 Woerter lang sein, ein Programm zaehlt das nach; bei Ueberlaenge wird verdichtet und nicht gestrichen.

> Jeder Projektvertrag MUSS eine maschinell gezählte harte Obergrenze einhalten (F24): **vier Seiten, rund 2.000 Wörter** — bei sechs Anforderungsdimensionen etwa 300 Wörter je Dimension, genug für Klauseln und zu wenig für Prosa.

**K06-G08** · GILT — Begruendung fuer die Laengengrenze: ein frueherer Versuch mit rund 90.000 Woertern je Konzept enthielt die Anforderungen zwar, aber niemand konnte sie darin finden oder als verbindlich erkennen.

> Anlass der Obergrenze ist die erste Iteration mit rund 90.000 Wörtern je Konzept — die Anforderungen waren enthalten, aber weder auffindbar noch als verbindlich erkennbar (F24).

### wann ein Anforderungskonzept ueberhaupt angezeigt werden darf

**K06-D01** · DARF NICHT — Ein Anforderungskonzept bleibt unsichtbar, bis genau zu diesem Stand des Dokuments eine maschinelle Pruefung durchgelaufen und bestanden ist; solange erscheint nur ein Warte-Hinweis, und nach zwei erfolglosen Runden bleibt die Ansicht ganz aus. ('Artefaktstand' meint: die eine konkrete Fassung dieses Dokuments, nicht das Dokument allgemein.)

> Ein Anforderungskonzept DARF NICHT angezeigt werden, solange zu seinem Artefaktstand kein abgeschlossener Prüflauf mit `passed` = wahr und ohne offenen Blocker vorliegt.

### welcher der beiden Wege ueberhaupt zu einem Anforderungskonzept fuehrt

**K04-G13** · GILT — Es gibt zwei Wege durch das Portal; nur der Anwendungsweg fuehrt durch Eignungspruefung, Anforderungskonzept, Fachreview und Angebot, der Dokumentweg laesst all das aus -- deshalb wird im Zweifel der teurere Anwendungsweg vorgeschlagen. (K04 ist das Konzeptpapier 'Eignungs- und Schnell-Check'.)

> Es GILT: Bei Unklarheit zeigt der Vorschlag auf die Anwendung. Der Dokumentweg überspringt jede Prüfung — Eignung, Anforderungskonzept, Fachreview, Angebot.

### das Nebenfragen-Fenster erzeugt niemals eine Anforderung -- vier gleichlautende Verbote

**K01-D10** · DARF NICHT — Was der Kunde im kleinen Hilfe-Fenster neben dem Gespraech fragt, bleibt dort und wandert nie in die entstehende Anwendung, in die Ergebnisspalte, in eine Anforderung oder in ein Dokument. (K01 ist das Rahmenkonzept, also das Dachpapier ueber allen anderen.)

> Der Inhalt des Nebenfragen-Fensters unter dem Gespräch DARF NICHT in die Anwendung einfließen. Er erzeugt keinen Eintrag in der rechten Spalte, keine Anforderung und kein Dokument

**K05-D07** · DARF NICHT — Dieselbe Sperre, gesehen vom Papier ueber das gefuehrte Gespraech der Stufen 01 und 02 (K05): das Nebenfenster bleibt folgenlos fuer Anforderungen und Dokumente.

> Der Inhalt des Nebenfragen-Fensters DARF NICHT in die rechte Spalte, in eine Anforderung oder in ein Dokument einfließen (Eigentümer K16).

**K16-D07** · DARF NICHT — Dieselbe Sperre, hier im Papier, das sie besitzt: K16 ist der Bedien-Standard, also die Hausordnung fuer alle Bildschirme.

> Der Inhalt des Nebenfragen-Fensters DARF NICHT in die Anwendung einfließen — kein Eintrag in der rechten Spalte, keine Anforderung, kein Dokument.

**K17-D11** · DARF NICHT — Dieselbe Sperre, gerichtet an das Hilfsprogramm selbst: der Hilfe-Agent darf nichts in die Anwendung schreiben, sein Gespraechsverlauf erzeugt weder Anforderung noch Dokument. (K17 ist das Papier ueber Betrieb und Verhalten der KI-Agenten.)

> Der Hilfe-Agent DARF keinen Inhalt in die Anwendung schreiben. Der Verlauf des Nebenfragen-Fensters erzeugt keine Anforderung und kein Dokument (K16 Abschn. 3).

### die bestaetigten Anforderungen als verbindliche Quelle fuer Vorlagenwahl und Prototyp-Huelle

**K25-M19** · MUSS — Bevor der Prototyp-Erzeuger eine Vorlage auswaehlt, bildet er ein Merkmalsprofil aus genau fuenf Merkmalen, und zwar ausschliesslich aus der festgeschriebenen Fassung der vom Kunden bestaetigten Anforderungen; fehlt oder verwundert ein Wert, bricht er ab statt zu raten. ('fail-closed' heisst: im Zweifel anhalten, nicht weitermachen. K25 ist das Papier 'Wortschatz und Sperren des Prototyp-Erzeugers'.)

> Der Erzeuger MUSS vor jeder Auswahl ein Merkmalsprofil aus genau fünf Merkmalen nach Abschnitt 6 bilden, abgeleitet allein aus der revisionsgebundenen Fassung der bestätigten Anforderungen.

**K25-M22** · MUSS — Jede Vorlagenauswahl hinterlaesst ein vollstaendiges Protokoll -- unter anderem, auf welcher Fassung der bestaetigten Anforderungen sie beruht -- samt einem Satz in Klartext, der nur zusammenfasst und nichts Neues behauptet.

> Jede Auswahl MUSS einen vollständigen Auswahlvermerk erzeugen: Auswahlkennung, Zeitpunkt, Anwendungs- und Mandantenbezug, Fassung der bestätigten Anforderungen, Profil mit Herkunft, Kandidaten vor und nach dem Filter, Deckungsgrade, Kennung und Fassung je Vorlage, angewandte Gleichstandsregel, Zweitplatzierter, Erzeuger- und Review-Agentenstand sowie Klartextsatz.

**K25-G02** · GILT — Die sogenannte Huelle -- die sichtbare Oberflaeche des Prototyps -- gilt nicht als eigener Bildschirm, sondern als Inhalt eines Vorschaufensters; welche Spalten sie zeigt, folgt aus den bestaetigten Kundenanforderungen und nicht aus dem technischen Datenmodell.

> Sie ist instanzabhängiger Inhalt eines einzigen Vorschaubereichs; ihre Spalten stammen aus den bestätigten Anforderungen des Kunden, nicht aus dem Datenmodell.

**K25-G08** · GILT — Am Aussehen des Prototyps darf gedreht werden, an den bestaetigten Anforderungen nicht; ein Wunsch, der beides zugleich betraefe, wird abgelehnt statt halb ausgefuehrt.

> Es GILT: Eine Änderung an der Hülle berührt nie eine bestätigte Anforderung. Trifft ein Wunsch beides, wird er fail-closed abgelehnt.

### reine Worttreffer -- 'Anforderung' hier in anderer Bedeutung

**K09-G07** · GILT — Ueber eine Angebotsanfrage entscheidet nie das Programm, sondern ein Mensch, und die Annahme passiert ausserhalb des Portals -- 'Anforderung' meint hier den Vorgang des Anforderns, nicht ein Anforderungskonzept. (K09 ist das Papier 'Angebot und Freigabe'.)

> Es GILT: Kein Rechner entscheidet über die Anfrage. Die Anforderung ist ein menschlicher Akt; die Annahme geschieht außerhalb des Portals.

**K16-M23** · MUSS — Jeder Bildschirm muss bedienbar sein -- Reihenfolge beim Durchtabben, Tastaturbedienung, Ansage von Zustandsaenderungen, Darstellung auf schmalen Geraeten; 'Anforderungen' meint hier technische Bedienvorgaben. (K19 ist die Build-Referenz, das Papier, das die einzelnen Bildschirme durchnummeriert.)

> Jeder Bildschirm MUSS die Anforderungen an Fokusreihenfolge, Tastaturbedienung, Statusansage und schmale Ansicht aus K19 Abschn. 5.1 erfüllen.

---

## Vertrag

*... Anforderungen/Vertrag (Stufe 03)* — BS:63 · **34 Regeln**

**Anmerkung:** Zum Lesen dieser Station: Die Kennungen nennen zuerst das Konzeptpapier, dann die Art und eine Nummer. K01 = Rahmenkonzept, K02 = Fundament, K06 = Anforderungskonzepte / Projektvertrag / Fachreview, K07 = Prototyp und Verfeinern, K08 = Wissen und Quellen, K10 = Uebergabe-Paket, K13 = Architektur-Muster, K17 = Agenten-Betriebs- und Interaktionskonzept, K18 = Wissens-Struktur, K21 = Richtlinien, K23 = Test- und Abnahmekonzept, K25 = Wortschatz und Sperren des Prototyp-Erzeugers. M = MUSS, D = DARF NICHT, G = GILT (eine Feststellung, die etwas klarstellt). WICHTIG BEIM LESEN: das Wort 'Vertrag' meint in dieser Trefferliste mindestens fuenf voellig verschiedene Dinge. (1) Den PROJEKTVERTRAG — das Dokument, das am Uebergang von Stufe 03 zu Stufe 04 aus den bestaetigten Konzepten entsteht und die Bauvorlage bildet: K06-M18, K06-M19, K06-M23, K06-M24, K06-M34, K06-D12, K06-G09, K06-G14, K07-G01, K10-M07, K10-M17, K10-M19, K10-M28, K10-M36, K10-D08, K10-D10, K10-G08, K17-M11, K17-M12, K17-M14, K17-G14, K23-G05. (2) Den AUFTRAGSVERARBEITUNGSVERTRAG, also die datenschutzrechtliche Vereinbarung mit dem Kunden: K02-M29, K02-M30, K02-D13. Das ist ein anderes Dokument als der Projektvertrag; K02-M30 wirkt allerdings als Sperre unmittelbar vor dem Gespraech. (3) Den SCHNITTSTELLENVERTRAG — ein reiner Fachausdruck fuer die Zusage, welche Datenspalten ein Programmteil einem anderen liefert; hier geht es um die Datenbankabfrage 'SELECT *', also 'nimm alle Spalten', die durch eine ausdrueckliche Aufzaehlung ersetzt werden soll. Diese Regeln haben mit einem Vertrag im rechtlichen Sinn nichts zu tun: K01-G03, K01-M34, K13-G11, K18-M21, K21-M17. (4) Den LIZENZ- beziehungsweise NUTZUNGSVERTRAG fuer fremde Quellen: K08-M29. (5) Den EVAL-VERTRAG, also die festgeschriebene Pruefanordnung fuer Agenten: K17-M30. Dazu kommen zwei Regeln aus K25, in denen 'Vertrag' nur nebenbei vorkommt: K25-G13 sagt, dass die Prototyp-Huelle keinen Vertrag erzeugt, und K25-G15 meint mit 'Vertrag' den Text des Konzeptpapiers selbst, den der Eigentuemer ergaenzen muss. Weitere wiederkehrende Woerter: 'Klausel' ist ein einzelner nummerierter Satz im Projektvertrag; 'Golden-Test' ist ein Test, der beweist, dass eine bestimmte Klausel tatsaechlich erfuellt ist; 'Revision' ist ein Stand eines Dokuments mit eigener Nummer; 'blind ansetzen' heisst, ein pruefendes Modell bekommt nur den Vertrag und keine Zusatzerklaerungen.

### wie und wann der Projektvertrag entsteht und was er dann einfriert

**K06-M19** · MUSS — Genau beim Wechsel von der Anforderungsstufe zur Prototypstufe wird aus den bestaetigten Konzepten der Projektvertrag erzeugt, der danach als verbindliche Bauvorlage dient.

> Am Übergang von Stufe 03 zu Stufe 04 MUSS aus den bestätigten Konzepten der Projektvertrag entstehen. Er ist die Bauvorlage für UX-Prototyp-Builder und Coding-Partner.

**K06-M18** · MUSS — Stufenwechsel, Protokolleintrag und Entstehung des Projektvertrags passieren in einem einzigen untrennbaren Schritt; misslingt einer davon, bleibt alles beim alten Stand.

> Der Stufenwechsel MUSS `app.journey_phase` von UEBERSICHT auf PROTOTYP setzen (Eigentümer K01) — in derselben Transaktion wie der Protokolleintrag und die Entstehung des Projektvertrags (K06-M19). Scheitert einer der drei Schritte, bleibt die Stufe bei UEBERSICHT.

**K06-G09** · GILT — Ab der Prototypstufe darf nur noch am Aussehen und an der Bedienung geaendert werden, weil der inhaltliche Umfang mit dem Projektvertrag festgeschrieben ist.

> Es GILT: Weil der Projektvertrag am Übergang 03 zu 04 entsteht, sind ab Stufe 04 nur noch Darstellung und Bedienung änderbar. Der Grund liegt hier, die Ausführung in K07.

**K07-G01** · GILT — Die Sperre gegen nachtraegliche Umfangsaenderungen im Prototyp hat ihren Grund im Projektvertrag: was vertraglich festgelegt ist, wird nicht durch spaeteres Nachbessern still verschoben.

> Es GILT: Der Grund für die Sperre aus K07-D01 ist der Projektvertrag. Er entsteht am Übergang von Stufe 03 zu Stufe 04 (F23, Eigentümer K06). Was vertraglich gebunden ist, wird nicht nachträglich durch Feilen verschoben.

### was im Projektvertrag stehen muss, wie lang er sein darf und was nicht hineingehoert

**K06-M23** · MUSS — Der Projektvertrag darf hoechstens vier Seiten beziehungsweise rund 2.000 Woerter umfassen, maschinell nachgezaehlt; wird es mehr, muss der Text gestrafft werden, ohne Inhalt wegzulassen.

> Jeder Projektvertrag MUSS eine maschinell gezählte harte Obergrenze einhalten (F24): **vier Seiten, rund 2.000 Wörter** — bei sechs Anforderungsdimensionen etwa 300 Wörter je Dimension, genug für Klauseln und zu wenig für Prosa. Wird sie überschritten, wird verdichtet, nicht gestrichen (F25).

**K06-D12** · DARF NICHT — Jeder einzelne Satz im Projektvertrag muss auf eine nachweisbare Quelle zurueckgehen; alles ohne Herkunft gilt als erfundener Umfang und wandert stattdessen auf die Liste offener Punkte.

> Eine Klausel ohne belegte Herkunft DARF NICHT im Projektvertrag stehen. Sie ist erfundener Umfang und gehört in die Offene-Punkte-Liste.

**K06-M34** · MUSS — Im Projektvertrag muss stehen, wie abgenommen wird: was genau abgenommen wird, wie Maengel festgehalten werden, welche Frist gilt und was passiert, wenn niemand die Abnahme erklaert.

> Der Projektvertrag MUSS das Abnahmeverfahren zwischen Kunde und Umsetzungspartner führen: Gegenstand der Abnahme, Mängelliste, Frist und Rechtsfolge einer nicht erklärten Abnahme.

**K23-G05** · GILT — Das Abnahmeverfahren selbst steht im Vertrag; das Testkonzept verlangt lediglich, dass die Durchfuehrung belegt wird.

> Es GILT: Das Abnahme**verfahren** zwischen Kunde und Umsetzungspartner ist Vertragsinhalt und gehört K06. K23 verlangt nur den Nachweis.

**K06-G14** · GILT — Drei Stellen teilen sich die Arbeit und keine ersetzt die andere: das Verfahren steht im Vertrag, der Nachweis haengt am Zustand im Betriebsportal, die Pruefungen liefert das Testkonzept.

> Es GILT die Arbeitsteilung: K06 führt das Verfahren im Vertrag, K11 führt den Nachweis am Zustand, K23 führt die Prüfungen, gegen die abgenommen wird. Keines ersetzt ein anderes.

### die Pruefkette ueber den Projektvertrag und ihr benannter blinder Fleck

**K06-M24** · MUSS — Sechs Pruefungen sind Pflicht, vier davon automatisch und zwei mit menschlichem Fachurteil, und zusaetzlich liest ein pruefendes Modell den Vertrag ohne Vorwissen.

> Die Kette MUSS sechs Prüfungen führen: vier maschinell, zwei mit Fachurteil (Abschnitt 4.4). Zusätzlich liest der Prüf-Agent den Projektvertrag blind.

**K17-M11** · MUSS — Das pruefende Modell muss zusaetzlich beurteilen, ob im Vertrag eine Plattformregel fehlt, die fuer diese Anwendung eigentlich gelten muesste.

> Der Review-Agent MUSS eine zweite Rubrik führen: Anwendbarkeit der Plattformregeln auf den Projektvertrag. Sie beantwortet, ob eine Plattformregel fehlt, die für diese Anwendung gelten müsste.

**K17-M12** · MUSS — Ein Modell bekommt nur den Vertrag ohne Zusatzerklaerungen vorgelegt; alles, was es daraus nicht beantworten kann, gilt als Luecke, ueber die spaeter auch der bauende Partner stolpern wuerde.

> Der Prüf-Agent MUSS zusätzlich blind auf den Projektvertrag angesetzt werden. Was er nicht beantworten kann, ist eine Lücke, die auch der Coding-Partner haben wird.

**K17-M14** · MUSS — Wer den Vertrag prueft, muss ein anderes Sprachmodell benutzen als wer ihn geschrieben hat, weil dasselbe Modell dieselben blinden Flecken haette.

> Für die zweite Rubrik MUSS die Modellvielfalt weiter gelten: der Review-Agent läuft auf einem anderen Modell als der Erzeuger des Projektvertrags. Eine Prüfung auf demselben Modell teilt dessen blinde Flecken.

**K17-G14** · GILT — Die Pruefkette prueft den Vertrag, aber niemand prueft dabei, ob die zugrunde liegenden Konzepte selbst vollstaendig sind; diese Luecke schliessen nur ein Durchsprechen am Tisch und eine Freigabe durch zwei Personen.

> Es GILT der benannte blinde Fleck aus F26: Niemand in der Prüfkette des Projektvertrags prüft, ob K14, K15, K16 und K17 selbst vollständig sind. Diese Lücke schließen allein Tabletop und Vier-Augen-Freigabe.

### der Projektvertrag im Uebergabe-Paket: Empfaenger, Kennung, Testnachweis

**K10-M36** · MUSS — Sowohl der Partner, der baut, als auch der Partner, der einfuehrt, muessen den Projektvertrag bekommen.

> Der Projektvertrag MUSS **beide** Partner des Projekts erreichen — den bauenden und den einführenden.

**K10-M17** · MUSS — Die vollstaendigen Plattformkonzepte gehen einmalig an jeden Umsetzungspartner; pro Projekt kommt dann nur noch der Projektvertrag als das Unterscheidende hinzu.

> Die Rahmenlieferung MUSS genau einmal **je Umsetzungspartner** erfolgen und die Plattformkonzepte vollständig enthalten (F23). Je Projekt folgt allein der Projektvertrag als Unterschied.

**K10-M07** · MUSS — Jeder Nachweistest muss ausdruecklich sagen, welchen Satz des Projektvertrags er belegt; ein Test ohne diese Angabe zaehlt als Beleg nicht.

> Jeder Golden-Test MUSS die Klausel des Projektvertrags nennen, die er beweist (F26, Eigentümer K06). Ein Test ohne benannte Klausel belegt nichts.

**K10-M28** · MUSS — Die Abdeckungsquote misst, wie viele Saetze des freigegebenen Vertragsstands durch mindestens einen bestandenen Test belegt sind; mehrere Tests fuer denselben Satz zaehlen nur einmal, und alles Uebersprungene oder Fehlgeschlagene bleibt einzeln als unbelegt sichtbar.

> Für die Abdeckungsquote GILT: Nenner sind alle eindeutigen Klauseln der freigegebenen Projektvertragsrevision; Zähler sind nur Klauseln mit mindestens einem bestandenen Golden-Test derselben Revision. Mehrere Tests zählen eine Klausel einmal. Ausgeschlossene, nicht ausführbare und fehlgeschlagene Tests bleiben einzeln als nicht belegt sichtbar.

**K10-M19** · MUSS — Jedes Uebergabe-Paket traegt eine unveraenderliche Kennung, die unter anderem den Stand des Projektvertrags festhaelt; aendert sich der Inhalt, entsteht ein neuer Paketstand und die alte Freigabe verfaellt.

> Jede Übergabe MUSS eine unveränderliche Release-Kennung führen: Anwendung, Projektnummer, Paketrevision, Projektvertragsrevision, Erzeugungszeitpunkt und Quellrevision. Eine Inhaltsänderung erzeugt eine neue Paketrevision; eine bestehende Freigabe gilt nicht weiter.

**K10-D08** · DARF NICHT — Fuer die Uebergabe des Prototyp-Baukastens wird kein zweites Vertragsdokument angelegt; sie ist Teil des einen Projektvertrags.

> Die Übergabegestaltung für den Prototyp-Baukasten DARF NICHT als eigenständiger Vertrag geführt werden. Sie ist eine Teilmenge des Projektvertrags (F23, Eigentümer K06).

**K10-G08** · GILT — Was fuer die Uebergabe des Baukastens gilt, ist nur ein Ausschnitt aus dem Projektvertrag und darf keine eigene, davon abweichende Fassung werden.

> Es GILT: Die Übergabegestaltung für den Baukasten ist eine Sicht auf den Projektvertrag, kein zweites Dokument mit eigener Wahrheit.

**K10-D10** · DARF NICHT — Das Testpaket erreicht den einfuehrenden Partner ausschliesslich auf dem vorgesehenen Weg, insbesondere nicht als Anhang des Projektvertrags und nicht in Auszuegen.

> Das Testpaket DARF NICHT auf einem anderen Weg an den einführenden Partner gelangen — weder auszugsweise noch als Anlage zum Projektvertrag.

### der Auftragsverarbeitungsvertrag als Sperre vor dem ersten Gespraech

**K02-M29** · MUSS — Zu jedem Kunden muss festgehalten sein, wann der datenschutzrechtliche Auftragsverarbeitungsvertrag hinterlegt wurde und unter welchem Aktenzeichen er ausserhalb der Plattform liegt; ein Feld dafuer gibt es heute noch nicht, weshalb der echte Betrieb bis dahin gesperrt bleibt.

> Ein Mandant der Art Kunde MUSS den Nachweis des hinterlegten Auftragsverarbeitungsvertrags führen: Zeitpunkt der Hinterlegung und Aktenzeichen der Ablage außerhalb der Plattform. **Das Datenmodell führt dafür heute kein Feld** — der Träger ist als Auftrag O-K02-11 benannt. Bis er vorliegt, ist die Klausel nicht vollziehbar und der Produktivbetrieb bleibt gesperrt.

**K02-M30** · MUSS — Solange der Auftragsverarbeitungsvertrag nicht hinterlegt ist, verweigert der Server den Start eines Gespraechs fuer diesen Kunden, und zwar tief im Programm, nicht bloss durch eine ausgegraute Schaltflaeche.

> Ohne hinterlegten Vertrag MUSS der Beginn eines Gesprächs für diesen Mandanten serverseitig abgelehnt werden. Die Prüfung liegt im Serverpfad, nicht in der Oberfläche, und wirkt sperrend wie `customer_needs_code`. Prüfpunkt und Meldung führen K05 und K13; ohne sie ist keines der beiden freigabefähig.

**K02-D13** · DARF NICHT — Der Auftragsverarbeitungsvertrag wird nicht in der Plattform abgelegt; gespeichert wird nur der Nachweis, dass er anderswo hinterlegt ist.

> Der Vertrag selbst DARF NICHT als Plattformdokument geführt werden. `document_kind` bleibt bei sieben Werten; die Plattform führt allein den Nachweis seiner Hinterlegung.

### 'Vertrag' als Fachausdruck fuer eine Zusage zwischen Programmteilen (Schnittstellenvertrag)

**K01-M34** · MUSS — Eine bestimmte Datenbankabfrage muss ihre Spalten kuenftig einzeln aufzaehlen, statt pauschal alle zu nehmen, damit sich nichts auf die zufaellige Reihenfolge der Spalten verlaesst.

> Die Sicht `app_fit_ok` MUSS in der nächsten Datenmodell-Version ihre Spalten explizit auflisten. Weder API-Vertrag noch Migration dürfen sich auf `SELECT *` oder die physische Spaltenreihenfolge stützen.

**K01-G03** · GILT — Eine uebriggebliebene Spalte steht aus technischen Gruenden am Tabellenende, und aus dieser Position darf niemand eine Zusage ableiten; die pauschale Spaltenabfrage ist als offene technische Schuld vermerkt.

> Es GILT: Die Empfangsbestätigungsspalte der gestrichenen Mitbestimmungsstufe steht im aktuellen DDL aus Migrationsgründen am Tabellenende. Diese physische Reihenfolge ist kein Schnittstellenvertrag. `SELECT *` in `app_fit_ok` ist als zu schließende Modellschuld durch K01-M34 markiert.

**K13-G11** · GILT — Auch diese Datenbanksicht muss ihre Spalten ausdruecklich benennen, bevor sich ein anderer Programmteil darauf stuetzt.

> Es GILT: `portal_enabled` wird vor Nutzung als Schnittstellenvertrag auf explizite Spalten umgestellt; `SELECT *` im aktuellen DDL ist eine zu schließende Modellschuld.

**K18-M21** · MUSS — Zwei weitere Datenbanksichten muessen ihre Spalten einzeln auflisten, bevor andere Programmteile sich auf sie verlassen duerfen.

> Beide Sichten MÜSSEN vor ihrer Nutzung als Schnittstellenvertrag ihre Spalten ausdrücklich auflisten. Der Stern im vorliegenden Modellstand ist eine zu schließende Modellschuld, wie in K01 Abschn. 3 für `app_fit_ok` festgehalten.

**K21-M17** · MUSS — Auch die Sicht auf die jeweils gueltigen Richtlinien muss ihre Spalten ausdruecklich benennen, bevor sie genutzt wird.

> `policy_aktuell` MUSS vor Nutzung als Schnittstellenvertrag ihre Spalten auflisten.

### andere Bedeutungen von 'Vertrag': Nutzungsrechte, Pruefanordnung, Nachbildung

**K08-M29** · MUSS — Fremde Inhalte umzuformulieren verschafft noch kein Nutzungsrecht; vor der Freigabe muessen Rechteinhaber, Lizenzstand, erlaubter Zweck, Zielgruppe, Gebiet, Laufzeit und noetige Quellenangabe festgehalten sein, und ein unklarer oder abgelaufener Rechtsstand sperrt Nutzung und Auslieferung.

> Sinngemäße Wiedergabe ersetzt **keine** Nutzungserlaubnis. Die Aussage „nutzbar bleiben" aus K08-M28 gilt daher nur bei ausreichender rechtlicher Erlaubnis. Vor RELEASED sind Rechteinhaber beziehungsweise Herkunft, Lizenz-/Vertragsstatus, zulässiger Zweck, Zielgruppe, Gebiet, Laufzeit und nötige Attribution maschinenlesbar oder revisionsfest referenziert. Unklarer, abgelaufener oder widersprüchlicher Rechtsstatus sperrt Nutzung und Auslieferung.

**K17-M30** · MUSS — Fuer jedes eingesetzte Modell muss verbindlich festgeschrieben sein, ab welcher Guete es freigegeben ist, und die zugehoerige Pruefanordnung haelt Testdaten, Bewertungsmassstaebe, Wiederholungen, die genauen Versionsstaende sowie ein moegliches menschliches Uebersteuern fest.

> Freigabeschwellen sind je Agent im Manifest Pflichtwerte und werden mit K14 freigegeben. Es gibt keine universelle erfundene Quote. Der Eval-Vertrag bindet Dataset, Rubriken, Wiederholungen, Agent-, Prompt- und Modellversion sowie menschlichen Override.

**K25-G13** · GILT — Der erzeugte Prototyp ist eine Attrappe: was darin geklickt wird, loest beim Kunden keinen echten Vorgang und keine rechtliche Bindung aus.

> Es GILT: Die Hülle ist eine Nachbildung. Sie erzeugt keinen Vorgang, keinen Vertrag und keine Rechtsfolge beim Kunden.

**K25-G15** · GILT — Wo ein Konzept noch keine Festlegung trifft, darf niemand nach eigenem Gutduenken etwas bauen; der betroffene Weg bleibt gesperrt, bis der zustaendige Eigentuemer das Konzept ergaenzt und ein Test das Gesperrtsein belegt.

> Es GILT: Fehlende Träger aus Abschnitt 8 sind keine stillschweigende Implementierungsfreiheit. Der betroffene Pfad bleibt gesperrt, bis der Eigentümer den Vertrag kanonisch ergänzt und ein Negativtest ihn belegt.

---

## Prototyp

*Prototyp aus EINER freigegebenen Vorlage* — BS:65 · **42 Regeln**

**Anmerkung:** Vier Hinweise zum Lesen, keine Zuordnungsentscheidung. (1) Achtung, das Wort "Prototyp" meint hier zwei voellig verschiedene Dinge: den DIREKT-PROTOTYP (ein blosses Arbeitsdokument, das schon in der Vorpruefung entstehen kann und mit keiner Anwendung verbunden ist) und den PROTOTYP in Stufe 04 (die durchklickbare Vorschau der geprueften Anwendung). Die grosse Mehrheit dieser Treffer - alle K04- und fast alle K07-Regeln, dazu K01-G10, K01-M04, K12-D06, K12-G06, K15-G07 - handelt vom Direkt-Prototyp, nicht vom Prototyp aus einer freigegebenen Vorlage. (2) K10-D08 wurde ueber das Wort "Prototyp-Baukasten" getroffen, regelt aber eine Vertragsfrage: dass die Uebergabegestaltung kein eigener Vertrag ist, sondern Teil des Projektvertrags. (3) K23-M10 ist eine Lastpruefung; ihre Zielwerte sind ausdruecklich noch nicht festgelegt (offener Punkt O-K23-1). (4) K07-M29 haengt an einer Aufbewahrungsklasse, die im Datenmodell noch nicht besteht; bis dahin gilt eine ausdruecklich als vorlaeufig gekennzeichnete Zwischenzuordnung (offener Punkt O-K07-7).

### Die Grundunterscheidung: geprueft Anwendung gegen Direkt-Prototyp als blosses Arbeitsdokument

**K01-G10** · GILT — Ganz am Anfang entscheidet sich der Weg: nur eine geprueft Anwendung kann spaeter zu einem Angebot fuehren; ein Direkt-Prototyp ist blosses Arbeitsmaterial und kann es nie. (K01 ist das Rahmenkonzept, die Grundordnung des Ganzen.)

> Es GILT die Unterscheidung, die den Weg gleich zu Beginn entscheidet: eine geprüfte Anwendung kann Gegenstand einer Angebotsanfrage sein, ein Direkt-Prototyp ist ein Arbeitsdokument und ist es nicht (K07).

**K01-M04** · MUSS — In der Tabelle der Anwendungen stehen ausschliesslich geprueft Anwendungen - die Datenbank selbst laesst nichts anderes zu; Arbeitsdokumente landen in einer eigenen, getrennten Tabelle.

> Jede Zeile in `app` MUSS eine geprüfte Anwendung sein: `artifact_class = VERIFIED_APP`, erzwungen durch CHECK `app_is_verified`.

**K04-G05** · GILT — Dieselbe Unterscheidung, hier im Konzept der Vorpruefung festgehalten. (K04 ist das Konzept fuer Eignungs- und Schnell-Check, also die Vorpruefung.)

> Es GILT: der Direkt-Prototyp ist ein Arbeitsdokument (K07), die geprüfte Anwendung kann Gegenstand einer Angebotsanfrage sein (K01).

**K07-G03** · GILT — Zwei einander spiegelnde Datenbank-Bedingungen sorgen dafuer, dass die beiden Sorten im Bestand nie verwechselt werden koennen.

> Es GILT: Die beiden Bedingungen sind spiegelbildlich — die eine nagelt die Anwendung auf geprüft fest (Eigentümer K01), die andere den Direkt-Prototyp auf Arbeitsdokument.

**K07-M13** · MUSS — Jeder Direkt-Prototyp traegt zwingend die Kennzeichnung "Arbeitsdokument"; die Datenbank erzwingt das.

> Jeder Direkt-Prototyp MUSS die Marke Arbeitsdokument tragen. Durchgesetzt von der Bedingung `proto_is_work_doc`.

**K04-D07** · DARF NICHT — Ein Direkt-Prototyp darf dem Kunden nirgends wie eine geprueft Anwendung praesentiert werden.

> Ein Direkt-Prototyp DARF NICHT als geprüfte Anwendung dargestellt werden. Er bleibt Arbeitsdokument in `direct_prototype` (Eigentümer K07).

**K07-D04** · DARF NICHT — Dasselbe Verbot, ergaenzt um den zweiten Teil: aus einem Direkt-Prototyp kann nie eine Angebotsanfrage werden.

> Ein Direkt-Prototyp DARF NICHT als geprüfte Anwendung dargestellt werden und NICHT Gegenstand einer Angebotsanfrage sein.

**K07-D06** · DARF NICHT — In der Uebersicht stehen Direkt-Prototypen niemals in derselben Liste wie die geprueft Anwendungen.

> Ein Direkt-Prototyp DARF NICHT in derselben Liste wie die geprüften Anwendungen erscheinen.

**K07-M14** · MUSS — Die Direkt-Prototypen bekommen einen optisch klar getrennten Bereich mit dem ausdruecklichen Hinweis, dass man diese Dinge nicht beauftragen kann.

> Der Bereich der Direkt-Prototypen MUSS deutlich abgesetzt vom Bereich der geprüften Anwendungen stehen und den Hinweis führen, dass es sich nicht um beauftragbare Anwendungen handelt.

**K07-G04** · GILT — Der Direkt-Prototyp entsteht schon in der Vorpruefung, nicht im Gespraech, und ist mit keiner Anwendung verbunden.

> Es GILT: Ein Direkt-Prototyp entsteht in der Vorprüfung (Eigentümer K04), nicht im Gespräch. Er hat keinen Bezug zu einer Anwendung.

### Der Direkt-Prototyp-Check in der Vorpruefung: Reihenfolge, Fragen, Auswertung

**K04-M01** · MUSS — Wer eine neue Anwendung anlegen will, durchlaeuft zwei Vorpruefungen in fester Reihenfolge: zuerst die Frage "reicht ein Arbeitsdokument", dann die eigentliche Eignungspruefung.

> Der Einstieg *Neue Anwendung erstellen* MUSS zwei Vorprüfungen in fester Reihenfolge durchlaufen: erst Direkt-Prototyp-Check, dann Eignungs-Check.

**K04-M02** · MUSS — Diesen ersten Check kann man starten oder ueberspringen; er umfasst hoechstens fuenf kurze Fragen.

> Der Direkt-Prototyp-Check MUSS zwei Wege anbieten: *Check starten* und *Überspringen*. Er stellt höchstens fünf kurze Fragen.

**K04-D01** · DARF NICHT — Nur der erste Check ist ueberspringbar; die eigentliche Eignungspruefung muss jeder durchlaufen.

> Der Eignungs-Check DARF NICHT übersprungen werden. Überspringbar ist allein der Direkt-Prototyp-Check.

**K04-M22** · MUSS — Der Check besteht aus genau fuenf Fragen mit je drei Antworten, und jede Antwort zaehlt entweder Richtung "Dokument" oder Richtung "Anwendung"; die Formulierungen stehen fest im Konzept.

> Der Direkt-Prototyp-Check MUSS genau fünf Fragen führen, je Frage genau drei Antwortmöglichkeiten, je Antwort eine Zuordnung zu *Dokument* oder *Anwendung*.

**K04-M24** · MUSS — Die Auswertung ist eine feste Auszaehlung: ab zwei Treffern Richtung Anwendung lautet der Vorschlag Anwendung, bei einem Treffer Direkt-Prototyp mit ausdruecklicher Nennung der abweichenden Antwort, bei keinem Direkt-Prototyp.

> Zwei oder drei Treffer auf *Anwendung* ergeben den Vorschlag *Anwendung*; einer ergibt *Direkt-Prototyp* mit Nennung der abweichenden Antwort; keiner ergibt *Direkt-Prototyp*.

**K04-M03** · MUSS — Am Ende steht ein Vorschlag, welcher Weg passt - der Kunde bleibt frei, sich anders zu entscheiden.

> Der Direkt-Prototyp-Check MUSS am Ende vorschlagen, welcher Weg besser passt. Der Vorschlag ist keine Entscheidung.

**K04-D11** · DARF NICHT — Wenn Antworten fehlen oder die Auswertung scheitert, lautet der Vorschlag im Zweifel "Anwendung", und der Grund wird genannt - der Zweifel faellt also nie zugunsten des blossen Arbeitsdokuments aus.

> Ein unvollständiger oder nicht auswertbarer Check DARF NICHT zum Vorschlag *Direkt-Prototyp* führen.

### Wie ein Direkt-Prototyp gespeichert wird: Pflichtangaben, Mandant, Name, Aktionen

**K07-M11** · MUSS — Jeder Direkt-Prototyp ist genau ein Eintrag in seiner eigenen Tabelle und hat zwingend einen Namen und ein Format.

> Ein Direkt-Prototyp MUSS als genau eine Zeile in `direct_prototype` bestehen und einen Namen sowie ein Format tragen.

**K07-M12** · MUSS — Jeder Direkt-Prototyp gehoert zu genau einem Kunden, und solange er existiert, kann dieser Kunde nicht geloescht werden.

> Jeder Direkt-Prototyp MUSS einen Mandanten tragen; der Verweis hält den Mandanten mit einer Löschsperre fest.

**K07-M15** · MUSS — Der Dateiname wird nicht frei vergeben, sondern folgt einem festen Muster aus Datum, Uhrzeit und Thema.

> Der Dateiname eines Direkt-Prototyps MUSS einem festen Muster aus Datum, Uhrzeit und Thema folgen.

**K07-M16** · MUSS — Zu jedem Direkt-Prototyp gibt es genau drei Knoepfe: herunterladen, teilen, entfernen - nicht mehr und nicht weniger.

> Je Direkt-Prototyp MÜSSEN genau drei Aktionen bereitstehen: Laden, Teilen und Entfernen.

**K07-G05** · GILT — Das allgemeine Loeschverbot des Portals gilt fuer Kunden, Anwendungen und Protokolleintraege; der Direkt-Prototyp ist die einzige Ausnahme, die der Nutzer selbst wegwerfen darf.

> Es GILT: Der Direkt-Prototyp ist das **einzige** Objekt, das der Nutzer selbst entfernen darf.

**K07-G06** · GILT — Wird ein Benutzerkonto entfernt, verschwindet nur der Verweis auf die Person; der Eintrag selbst bleibt bestehen, damit der Nachweis nicht verlorengeht.

> Es GILT: Das Konto am Direkt-Prototyp wird beim Entfernen des Kontos geleert, die Zeile bleibt. Der Nachweis überlebt das Konto.

### Aufbewahrung, Fristen und Loeschung des Direkt-Prototyps

**K07-M18** · MUSS — Jeder Direkt-Prototyp gehoert einer Aufbewahrungsklasse an, hat ein sichtbares Faelligkeitsdatum, und die eigentliche Frist legt das Datenschutzkonzept fest. (K15 ist das Datenschutz- und Loeschkonzept.)

> Jeder Direkt-Prototyp MUSS eine Aufbewahrungsklasse tragen; die Fälligkeit wird als eigenes Datum mitgeführt und im Portal angezeigt. Die Frist führt K15.

**K01-G15** · GILT — Die Grundordnung benennt nur die Klasse, nicht die Dauer; die konkreten Fristen - Einmal-Link 24 Stunden, Prototyp-Link 14 Tage, Loeschung nach 90 Tagen - stehen in den ausfuehrenden Konzepten.

> Es GILT: K01 nennt die Aufbewahrungsklasse, nie die Frist. Die Fristen aus F11 — Einmal-Link 24 Stunden, Prototyp-Link 14 Tage, Löschung nach 90 Tagen — werden von K15, K20 und K07 ausgeführt.

**K15-G07** · GILT — Der Link auf einen Prototyp verfaellt nach 14 Tagen, die Daten dahinter werden nach 90 Tagen geloescht; die Frist wird am Arbeitsdokument vollzogen.

> Es GILT F11 für die kurzen Fristen: der Verweis auf einen Prototyp läuft nach 14 Tagen ab, der zugehörige Bestand wird nach 90 Tagen entfernt.

**K12-D06** · DARF NICHT — Fuer das tatsaechliche Loeschen darf nicht das angezeigte Datum herangezogen werden - das ist nur Anzeige und darf fehlen; massgeblich ist ein eigener Faelligkeitseintrag. (K12 ist das Konzept fuer das Prototyp-Hosting, also die Bereitstellung der Vorschau.)

> Die Entfernung DARF NICHT auf `direct_prototype.retention_until` gestützt werden: die Spalte ist nur Anzeige (Z. 324) und darf leer sein.

**K12-G06** · GILT — Der Gruender hat entschieden: die Prototyp-Vorschau zaehlt als Arbeitsergebnis, nicht als Betriebsprotokoll; deshalb greift die lange gesetzliche Mindestaufbewahrung fuer Protokolle hier nicht und die 90-Tage-Frist bleibt widerspruchsfrei.

> Es GILT die Entscheidung des Founders vom 31.07.2026: Die Prototyp-Vorschau ist ein **Arbeitsergebnis**, kein automatisch erzeugtes Protokoll.

**K07-M29** · MUSS — Sobald es die vorgesehene vierte Aufbewahrungsklasse tatsaechlich gibt, wird der Direkt-Prototyp ihr zugeordnet; bis dahin gilt eine ausdruecklich als vorlaeufig markierte Zwischenloesung, die nicht als fachliche Einordnung missverstanden werden darf.

> Sobald die vierte Aufbewahrungsklasse nach K15 Abschn. 3 im Datenmodell besteht, MUSS der Direkt-Prototyp ihr zugeordnet werden.

### Der Weg in die Prototyp-Stufe: was vorher bestaetigt sein muss

**K05-G05** · GILT — Dass der Kunde sein Ausgangsproblem ausdruecklich bestaetigt, ist kein Hoeflichkeitsschritt, sondern eine Sperre: alles Spaetere - Anforderungen, Prototyp, Angebot - baut auf genau dieser Beschreibung auf. (K05 ist das Konzept fuer das gefuehrte Gespraech.)

> Es GILT: Die Bestätigung des Ausgangsproblems ist ein Tor, keine Höflichkeit. Konzepte, Prototyp und Angebot bauen auf dieser einen Beschreibung auf.

**K06-M14** · MUSS — Waehrend die Anforderungen geprueft werden, sieht der Kunde fuenf abzuhakende Schritte bis "Bereit fuer Prototyp" sowie den erreichten Pruefwert und die laufende Runde. (K06 ist das Konzept fuer Anforderungskonzepte, Projektvertrag und Fachreview.)

> Der Bildschirm MUSS während der Prüfung fünf Stufen abhaken — erste Version, Fachreview, Optimierung, Bestanden, Bereit für Prototyp — und Prüfwert samt aktueller Runde zeigen.

**K06-M18** · MUSS — Der Sprung in die Prototyp-Stufe passiert nur zusammen mit dem Protokolleintrag und der Entstehung des Projektvertrags - alles drei in einem einzigen Vorgang; scheitert eines davon, bleibt der Kunde in der vorigen Stufe.

> Der Stufenwechsel MUSS `app.journey_phase` von UEBERSICHT auf PROTOTYP setzen (Eigentümer K01) — in derselben Transaktion wie der Protokolleintrag und die Entstehung des Projektvertrags (K06-M19).

**K06-M19** · MUSS — Beim Uebergang in die Prototyp-Stufe entsteht aus den bestaetigten Anforderungen der Projektvertrag; er ist die verbindliche Bauvorlage fuer alle, die danach bauen.

> Am Übergang von Stufe 03 zu Stufe 04 MUSS aus den bestätigten Konzepten der Projektvertrag entstehen. Er ist die Bauvorlage für UX-Prototyp-Builder und Coding-Partner.

**K06-G07** · GILT — Die Anforderungsdokumente fassen zusammen und verweisen, sie malen nichts aus: statt Bildschirme in Worten zu beschreiben, verweisen sie auf den Prototyp.

> Es GILT F24: Familie 2 ist Verdichtung plus Verweis, niemals Ausarbeitung. Bildschirme werden nicht beschrieben, sondern auf den Prototyp verwiesen.

### Die fuenf Stufen der Kundenreise, in denen PROTOTYP die vierte ist

**K01-M05** · MUSS — Jede Anwendung fuehrt zwei Pflicht-Zustaende nebeneinander: acht Betriebszustaende fuer die interne Sicht und fuenf Reisestufen fuer die Kundensicht, deren vierte PROTOTYP heisst.

> Eine Anwendung MUSS zwei Zustandsachsen führen, beide Pflicht: `lifecycle_state` mit acht Werten (EINGELADEN, DISCOVERY, IN_BEARBEITUNG, BEAUFTRAGT, IN_DEV, ABNAHME, IN_PROD, PAUSIERT) und `journey_phase` mit fünf Werten (ORIENTIERUNG, INTERVIEW, UEBERSICHT, PROTOTYP, ANGEBOT).

**K19-M04** · MUSS — Die Fortschrittsleiste zeigt genau diese fuenf Stufen in dieser Reihenfolge. (K19 ist die Build-Referenz, das Dokument mit den verbindlichen Bauvorgaben.)

> Die Fortschrittsanzeige MUSS fünf Stufen führen: ORIENTIERUNG · INTERVIEW · UEBERSICHT · PROTOTYP · ANGEBOT.

### Was der gebaute Prototyp koennen muss und wie seine Vorlage gewaehlt wird

**K25-M06** · MUSS — Der Prototyp ist keine Bilderschau, sondern durchklickbar: was im Bausteinkatalog als bedienbar gilt, reagiert auch wirklich; was als reine Anzeige gilt, reagiert nicht. (K25 ist das Konzept fuer den Prototyp-Erzeuger mit seinem festen Wortschatz und seinen Sperren.)

> Der Prototyp MUSS lauffähig und durchklickbar sein: jedes im Katalog als *bedienbar: ja* geführte Element antwortet auf Klick, Eingabe oder Auswahl.

**K25-M21** · MUSS — Passen mehrere Vorlagen gleich gut, entscheidet erst der kleinere Umfang, dann der kleinere Name; bleibt es auch dann gleich, wird sicherheitshalber abgebrochen - kein Prototyp, die Luecke wird benannt und der Gruender entscheidet.

> Bei Gleichstand MUSS zuerst der kleinere Umfang, dann der kleinere Bezeichner gewinnen.

### Der Ausgang aus der Prototyp-Stufe: die Rueckfrage, die zumacht

**K07-M09** · MUSS — Bevor es zur Angebotsstufe weitergeht, kommt eine ausdrueckliche Rueckfrage mit dem Hinweis, dass danach nichts mehr geaendert werden kann, und zwei Knoepfen: zurueck oder abschliessen.

> Der Übergang zu Stufe 05 MUSS über eine Rückfrage laufen, die benennt, dass danach keine Änderungen mehr möglich sind. Sie führt zwei Wege: zurück in den Prototyp oder abschließen.

### Pruefungen, die der Prototyp-Erzeuger bestehen muss

**K23-M08** · MUSS — Der Prototyp-Erzeuger bekommt einen eigenen automatischen Test, der genau gegen seine eigenen Regeln prueft. (K23 ist das Test- und Abnahmekonzept.)

> Discovery-Gespräch, Bedien-Sperren und Prototyp-Erzeuger MÜSSEN je eine eigene Modulprüfung gegen ihre eigenen Klauseln haben.

**K23-M10** · MUSS — Es muss einen Belastungstest geben, bei dem mehrere Kunden gleichzeitig Prototypen erzeugen; welche Werte dabei erreicht werden muessen, ist noch offen und entscheidet der Gruender.

> Es MUSS eine Lastprüfung geben, die mehrere Mandanten gleichzeitig prototypisieren lässt. Ihre Zielwerte legt der Founder fest (O-K23-1).

### Die Uebergabegestaltung des Prototyp-Baukastens ist kein eigener Vertrag

**K10-D08** · DARF NICHT — Wie der Prototyp-Baukasten uebergeben wird, wird nicht in einem eigenen Vertrag geregelt, sondern ist Teil des Projektvertrags. (K10 ist das Konzept fuer das Uebergabe-Paket.)

> Die Übergabegestaltung für den Prototyp-Baukasten DARF NICHT als eigenständiger Vertrag geführt werden. Sie ist eine Teilmenge des Projektvertrags (F23, Eigentümer K06).

---

## Vorlage

*... aus EINER freigegebenen Vorlage (Stufe 04)* — BS:65 · **40 Regeln**

**Anmerkung:** Zum Wort selbst, damit Sie beim Lesen nicht stolpern: "Vorlage" kommt in diesen 40 Regeln in mindestens vier verschiedenen Bedeutungen vor. (1) Formatvorlage im Sinne eines gespeicherten Musters, aus dem etwas gebaut wird -- das ist die Bedeutung der Faden-Zeile "Prototyp aus EINER freigegebenen Vorlage"; so gemeint in allen K18-, K21-, K25- und K17-Regeln. (2) Vorlage im Sinne von Vorbild/Muster-Fall: K01-D01 sagt von einem nur geplanten Portal, es sei "keine Vorlage" -- die Regel handelt in Wahrheit davon, dass ein geplantes Portal keinen Einstieg und keinen Bildschirm bekommen darf; das Wort ist hier ein Zufallstreffer. (3) Vorlage im Sinne von "etwas vorlegen": K23-M20 spricht von "jeder Vorlage eines Baus zur menschlichen Freigabe" -- gemeint ist der Vorgang des Vorlegens, nicht ein gespeichertes Muster. Die Regel selbst (ohne Durchstich keine Freigabe) hat mit Mustern nichts zu tun. (4) Vorlage als Bauplan bzw. Textbaustein: K06-M19 nennt den Projektvertrag die "Bauvorlage" fuer die Prototyp-Werkzeuge, K09-M20 nennt den Wortlaut einer Bestaetigungsnachricht eine "K10-Vorlage". Beides sind keine Formatvorlagen im Sinne von M2. Zwei weitere Hinweise: K18-M01 ist nur getroffen, weil das Modul M2 im Namen das Wort "Formatvorlagen" traegt -- die Regel selbst besagt, dass es genau vier Wissensmodule gibt. Und K21-G09 ist keine Verhaltensregel, sondern eine Notiz ueber zwei Kapitel desselben Dokuments, die denselben Zustand unterschiedlich benennen ("In Pruefung" gegen "In Arbeit"); sie ist als offener Punkt O-K21-4 vermerkt.

### was eine Formatvorlage ist und wo ihr Text liegt

**K18-M01** · MUSS — Der Wissensteil der Anlage hat genau vier Faecher -- K18 ist das Konzeptpapier, das diese Wissensstruktur beschreibt, und die Formatvorlagen wohnen im zweiten Fach, genannt M2.

> Der Wissensteil MUSS aus genau vier Modulen bestehen: M1 Wissensregister, M2 Formatvorlagen, M3 KI-Agenten, M4 Richtlinien. Jedes Modul ist genau eine Zeile in `module`.

**K18-M09** · MUSS — Jede Vorlage ist genau ein Eintrag in der Vorlagenliste (`template` ist der Name dieser Liste in der Datenbank) und gehoert genau einer von vier Sorten an: Dokument, Gestaltung, Dialog oder Richtlinie.

> Jede Formatvorlage MUSS genau eine Zeile in `template` sein und genau einer `template_group` angehören: DOCUMENT, DESIGN, DIALOG oder POLICY.

**K18-M24** · MUSS — Der eigentliche Text einer Vorlage steht in einer Datei, und die Datenbank merkt sich nur, wo diese Datei liegt und welche Fassung gilt.

> Der Inhalt einer Formatvorlage MUSS als eigene Datei ausserhalb der Datenbank liegen; die Versionszeile trägt allein den Verweis darauf.

**K18-D12** · DARF NICHT — Die Kehrseite der vorigen Regel: Niemand darf den Vorlagentext doch noch in die Datenbank hineinschmuggeln, auch nicht getarnt in einem Kommentarfeld.

> Der Inhalt einer Formatvorlage DARF NICHT in die Datenbank geschrieben werden — weder in ein neues Feld noch in eine Zweckentfremdung des Änderungsvermerks.

**K18-D03** · DARF NICHT — Oben in der Vorlagendatei darf kein eigener Status und keine eigene Versionsnummer stehen, damit es nicht zwei Wahrheiten darueber gibt, welche Fassung gilt.

> Die Kopfzeile eines Wissensbausteins oder einer Formatvorlage DARF weder Status noch Versionsnummer führen. Ein zweiter Statusstrang entsteht damit gar nicht erst.

**K18-G08** · GILT — Welche Vorlagen es gibt, wird jeweils aktuell aus dem Modul M2 abgefragt und nicht als feste Liste irgendwo festgeschrieben.

> Es GILT: Die Vorlagenliste wird aus M2 erhoben und nicht eingefroren. Die Gruppe POLICY ist seit v2.7 die vierte Gruppe.

### wer eine Vorlage aendern darf -- die Gruppe POLICY gehoert den Richtlinien

**K18-D06** · DARF NICHT — Vorlagen der Sorte Richtlinie darf man im Vorlagen-Modul M2 nur ansehen; geaendert werden sie ausschliesslich im Richtlinien-Modul M4.

> Eine Vorlage der Gruppe POLICY DARF NICHT in M2 geändert werden. M2 zeigt sie, M4 pflegt sie (Eigentümer K21).

**K18-M20** · MUSS — Dieselbe Sache von der anderen Seite: Richtlinien-Vorlagen muessen in der Vorlagenliste sichtbar sein, auch wenn sie woanders gepflegt werden.

> Vorlagen der Gruppe POLICY MÜSSEN in M2 erscheinen. Gepflegt werden sie ausschließlich in M4 (Eigentümer K21).

**K21-D05** · DARF NICHT — Dieselbe Regel noch einmal aus Sicht von K21, dem Konzeptpapier fuer die Richtlinien: der Inhalt einer Leitplanke wird nicht ueber die Vorlagenliste bearbeitet.

> Eine Leitplanke DARF NICHT in M2 geändert werden; dort erscheint nur die Vorlage (K18).

**K21-G06** · GILT — Eine Richtlinie darf auf eine Vorlage zeigen, muss es aber nicht; faellt die Vorlage weg, wird der Verweis einfach geleert statt die Richtlinie mitzureissen.

> Es GILT: `policy.template_id` verweist freiwillig auf eine Vorlage der Gruppe POLICY (K18); die Löschregel leert ihn.

**K21-G09** · GILT — Eine Notiz ueber eine Unstimmigkeit im eigenen Dokument: zwei Kapitel benennen denselben Zwischenstand einer Vorlage verschieden, und das ist als offener Punkt vermerkt.

> Es GILT: Kap. 9.1 nennt *In Prüfung*, Kap. 7.2 für Formatvorlagen *In Arbeit* (O-K21-4).

### Vorlagen, an denen ein Agent haengt -- nicht loeschen, nicht zum fuehrenden Text erklaeren

**K18-D07** · DARF NICHT — Solange ein KI-Agent mit einer Vorlage verbunden ist, laesst sich diese Vorlage nicht loeschen -- die Datenbank verweigert den Loeschversuch von sich aus.

> Ein Wissensbaustein oder eine Formatvorlage, an der ein Agent hängt, DARF NICHT entfernt werden. Die Löschregel `restrict` an den Verdrahtungstabellen (Eigentümer K17) verweigert den Vorgang.

**K17-M20** · MUSS — Ein KI-Agent sieht nur die Vorlagen, die ihm ausdruecklich zugeordnet wurden; alles andere existiert fuer ihn schlicht nicht.

> Ein Agent MUSS ausschließlich die Wissensbausteine, Vorlagen und Richtlinien erreichen, an die er verdrahtet ist. Alles Übrige gilt als nicht vorhanden.

**K17-D12** · DARF NICHT — Bei Gespraechsvorlagen fuer die KI ist nicht der Eintrag in der Vorlagenliste massgeblich, sondern der Text im KI-Werkzeug selbst; die Liste fuehrt ihn nur nachrichtlich.

> Eine Dialogvorlage DARF NICHT als führender Text behandelt werden. Führend ist die Prompt-Version in Microsoft Foundry; der Eintrag in M2 ist nachrichtlich (Eigentümer K18).

**K18-D08** · DARF NICHT — Wortgleich dieselbe Regel wie K17-D12, nur im anderen Konzeptpapier abgelegt -- inhaltlich kein Unterschied.

> Eine Dialogvorlage DARF NICHT als führender Text behandelt werden. Führend ist die Prompt-Version in Microsoft Foundry; der Eintrag in M2 ist nachrichtlich (K17).

### jedes Ergebnis fuehrt mit, aus welcher Vorlagen-Fassung es entstanden ist

**K18-M18** · MUSS — Alles, was aus einer Vorlage entsteht, traegt fuer immer den Vermerk, welche Fassung der Vorlage dabei benutzt wurde.

> Jedes erzeugte Ergebnis MUSS die Vorlagen-Version mitführen, mit der es entstanden ist. Für Prüfläufe ist die Bindung an `knowledge_module_version` belegt; Träger ist `review_run` (Eigentümer K06).

**K18-M19** · MUSS — Wo es heute noch kein Feld gibt, das die Vorlagen-Fassung mitfuehrt, wird das als Auflage an das Uebergabe-Paket weitergereicht -- Massstab ist, dass ein altes Ergebnis auch nach zwei Vorlagenaenderungen noch erklaerbar bleibt.

> Für Ergebnisse ohne belegten Träger MUSS die Vorlagen-Version als Auflage an K10 gehen.

**K18-M34** · MUSS — Ein abgeschlossener Lauf haelt Vorlage, Fassung und einen Fingerabdruck des Inhalts fest, damit spaetere Aenderungen an der Vorlage den alten Nachweis nicht rueckwirkend verfaelschen.

> Agenten-, Prüf- und Dokumentläufe pinnen Vorlagen-ID, Versions-ID und Inhalts-Hash. Ein späterer Vorlagenwechsel verändert einen abgeschlossenen Nachweis nicht.

**K06-G10** · GILT — Die Anforderungskonzepte und der Pruefbefund werden nach zwei bestimmten Vorlagen geschrieben, und jedes so entstandene Dokument merkt sich die benutzte Vorlagen-Fassung.

> Es GILT: Die Rubrik ist ein Wissensmodul mit Fassung, die Konzepte folgen der Vorlage A3, der Befund der Vorlage A12 (alle Eigentümer K18). Jedes Artefakt merkt sich die Vorlagen-Fassung.

**K06-M32** · MUSS — Die festen Kuerzel, aus denen Anforderungs-Nummern gebildet werden, gehoeren zur Vorlage und wandern mit deren Fassung -- was einmal ausgeliefert ist, wird nie umnummeriert.

> Die sechs Kürzel werden mit der Vorlage versioniert; Umnummerierung eines ausgelieferten Stands ist verboten.

### wechselt eine Vorlage, wird neu geprueft; und ohne bestandenen Durchstich keine Freigabe

**K23-M16** · MUSS — Sobald sich eine Vorlage aendert (oder eines von acht anderen Dingen), muss erneut geprueft werden -- und wenn unklar ist, wie weit die Aenderung reicht, wird alles geprueft.

> Ein erneuter, wirkungsbezogen ausgewählter Prüflauf MUSS ausgelöst werden, wenn Code, Schema, Richtlinie, Vorlage, Abhängigkeit, Infrastrukturkonfiguration, Modell, Prompt oder Wissens-Verdrahtung wechselt.

**K23-M18** · MUSS — Jeder Prueflauf endet mit einem unveraenderlichen Protokoll, das unter vielem anderen auch die benutzten Vorlagenstaende und die Pruefsummen aller Eingaben und Ergebnisse auffuehrt.

> Am Ende eines Laufs MUSS ein unveränderliches Manifest stehen.

**K23-M20** · MUSS — Bevor ein Bau einem Menschen zur Freigabe vorgelegt wird, muss ein vollstaendiger Testlauf bestanden sein, der gegen genau denselben Bauauftrag gelaufen ist -- weicht die Pruefsumme ab, gilt der Testlauf als veraltet. (Hier heisst "Vorlage" das Vorlegen, nicht ein Muster.)

> Vor jeder Vorlage eines Baus zur menschlichen Freigabe MUSS ein bestandener Durchstich vorliegen, der gegen den aktuellen Stand des Bauauftrags gelaufen ist.

### das Vorlagen-Universum des Prototyp-Erzeugers: genau drei Arten, eine Grundform

**K25-M14** · MUSS — Der Prototyp-Erzeuger kennt genau drei Sorten von Vorlagen -- fuer das Gespraech, fuer die Standanzeige und fuer einzelne Bedienelemente -- und eine vierte Sorte darf nicht dazukommen. (K25 ist das Konzeptpapier fuer den Prototyp-Erzeuger.)

> Das Vorlagen-Universum MUSS aus genau drei Arten bestehen: Gesprächsvorlage, Statusvorlage, Elementvorlage. Eine vierte Art entsteht nicht.

**K25-M15** · MUSS — Alle Gespraechsvorlagen haben denselben Grundaufbau -- Gespraech vorn, Stand daneben, auf schmalen Bildschirmen darunter -- und duerfen nur innerhalb dieses Aufbaus variieren.

> Jede Gesprächsvorlage MUSS die Grundform tragen: Gespräch im Vordergrund, Stand daneben, in schmaler Darstellung darunter. Die Vorlagen unterscheiden sich innerhalb der Grundform, nicht von ihr weg.

**K25-M16** · MUSS — Die drei Vorlagenarten des Erzeugers liegen in derselben Vorlagenverwaltung wie alles andere; solange dort Inhalt und Art nicht maschinenlesbar hinterlegt sind, bleibt die Auswahl fail-closed, also gesperrt statt geraten.

> Alle drei funktionalen Arten MÜSSEN als Formatvorlagen nach K18 geführt und über die Sicht der geltenden Stände gelesen werden.

**K25-M31** · MUSS — Eine Vorlage kann nur das, was in ihrer geltenden Fassung ausdruecklich eingetragen ist -- fehlt der Eintrag, gilt die Faehigkeit als nicht vorhanden, und die KI raet nicht.

> Eine Vorlage trägt ein Merkmal genau dann, wenn ihre geltende Fassung den Merkmalswert ausdrücklich führt.

### der Erzeuger waehlt nur aus -- er legt keine Vorlage an und es gibt keine Auffangvorlage

**K25-D10** · DARF NICHT — Der Prototyp-Erzeuger darf aus dem vorhandenen Bestand nur auswaehlen -- neue Vorlagen erfinden oder bestehende umbauen darf er nicht.

> Der Erzeuger DARF eine Vorlage NICHT anlegen, ergänzen, abwandeln oder versionieren.

**K25-D11** · DARF NICHT — Wenn keine Vorlage passt, gibt es keine Notloesung, die trotzdem etwas liefert -- dann entsteht eben nichts.

> Es DARF keine Auffangvorlage geben, die bei fehlender Passung einspringt.

**K25-D23** · DARF NICHT — Weder der Erzeuger noch der pruefende Agent darf selbst etwas in die Datenbestaende schreiben; sie schlagen vor, sie vollziehen nicht.

> Erzeuger und Review-Agent DÜRFEN NICHT unmittelbar auf Anwendung, Vorlage, Ereignis, Freigabe oder fachlichen Dienst schreiben.

**K25-M05** · MUSS — Der Katalog der erlaubten Bedienelemente wird auf dem Server als abschliessende Erlaubnisliste durchgesetzt, aus den freigegebenen Vorlagenstaenden erzeugt und mit einer Pruefsumme versehen -- laesst er sich nicht eindeutig erzeugen, entsteht kein Prototyp.

> Der Elementkatalog MUSS im Serverpfad als versionierte, maschinenlesbare Positivliste durchgesetzt werden.

**K25-M18** · MUSS — Der Erzeuger darf nur das benutzen, was in allen drei Quellen zugleich steht; fehlt eine Quelle oder widersprechen sie sich, ist die betroffene Vorlage nicht waehlbar.

> Der Wortschatz des Erzeugers MUSS die Schnittmenge aus Agenten-Verdrahtung, Positivliste nach K25-M05 und geltenden freigegebenen Vorlagenständen sein.

**K25-G12** · GILT — Was der Prototyp ueberhaupt an Oberflaeche zeigen darf, ist genau durch den gewaehlten Vorlagensatz und dessen Bedienelemente begrenzt.

> Es GILT: Der in K07 genannte *erlaubte UI-Scope* ist der gewählte Vorlagensatz samt seinen Elementvorlagen.

### die Auswahl der EINEN Vorlage: Gleichstand, Auswahlvermerk, Festhalten vor der Vorschau

**K25-M21** · MUSS — Passen zwei Vorlagen gleich gut, gewinnt die kleinere, danach die alphabetisch fruehere -- und sind sie auch darin gleich, bricht der Vorgang ab: kein Prototyp, sondern eine benannte Luecke und eine Entscheidung des Founders.

> Bei Gleichstand MUSS zuerst der kleinere Umfang, dann der kleinere Bezeichner gewinnen.

**K25-M22** · MUSS — Jede Vorlagenauswahl hinterlaesst ein vollstaendiges Protokoll, aus dem sich lueckenlos ablesen laesst, welche Vorlagen zur Wahl standen und warum genau diese eine gewonnen hat.

> Jede Auswahl MUSS einen vollständigen Auswahlvermerk erzeugen: Auswahlkennung, Zeitpunkt, Anwendungs- und Mandantenbezug, Fassung der bestätigten Anforderungen, Profil mit Herkunft, Kandidaten vor und nach dem Filter, Deckungsgrade, Kennung und Fassung je Vorlage, angewandte Gleichstandsregel, Zweitplatzierter, Erzeuger- und Review-Agentenstand sowie Klartextsatz.

**K25-M23** · MUSS — Erst wenn Vorlage, Fassung und Auswahlprotokoll an der Anwendung festgeschrieben sind, darf ueberhaupt eine Vorschau entstehen -- fehlt der Ablageort dafuer, entsteht keine.

> Vorlage, Fassung und der vollständige Auswahlvermerk nach K25-M22 — er **ist** die Begründung — MÜSSEN über einen vom Eigentümer K01 freigegebenen Serverbefehl an der Anwendung festgehalten sein, bevor eine Vorschau entsteht.

**K25-D16** · DARF NICHT — Ohne das vollstaendige Auswahlprotokoll darf der gewaehlte Vorlagensatz nicht herausgegeben werden.

> Ein Vorlagensatz DARF ohne vollständigen Auswahlvermerk NICHT ausgeliefert werden.

### das Wort "Vorlage" in einer anderen Bedeutung als Formatvorlage

**K01-D01** · DARF NICHT — Drei nur geplante Portale duerfen nichts Sichtbares und nichts Aufrufbares bekommen -- der Nachsatz der Regel sagt, sie seien "modelliert, nicht gebaut, und keine Vorlage", und meint mit Vorlage ein Vorbild, kein gespeichertes Muster.

> Ein Portal mit `release_status = PLANNED` — USER_ADMIN, VAR_ADMIN, INDIA_OPS — DARF weder Einstieg noch Bildschirm noch Endpunkt bekommen.

**K06-M19** · MUSS — Beim Uebergang von den Anforderungen zum Prototyp entsteht aus den bestaetigten Konzepten der Projektvertrag, und dieser ist der Bauplan fuer die Prototyp-Werkzeuge -- "Bauvorlage" meint hier diesen Bauplan, keine Formatvorlage.

> Am Übergang von Stufe 03 zu Stufe 04 MUSS aus den bestätigten Konzepten der Projektvertrag entstehen. Er ist die Bauvorlage für UX-Prototyp-Builder und Coding-Partner.

**K09-M20** · MUSS — Die Bestaetigung geht nur an die geprüfte Adresse des handelnden Kontos, eine Rechnungsadresse wird nicht erfunden -- der Text dieser Nachricht liegt als freigegebene, versionierte Textvorlage vor, was hier der einzige Bezug zum Wort Vorlage ist.

> Release 1 sendet die Bestätigung ausschließlich an die verifizierte Adresse des handelnden Kontos.

---

## Angebot

*Angebot, Stufe 05* — BS:67 · **40 Regeln**

**Anmerkung:** Drei Regeln sind nur wegen des Wortes getroffen und handeln von etwas anderem: K03-D04 verwendet "angeboten" im Sinne von "zur Auswahl stellen" und betrifft den zweiten Faktor bei der Anmeldung, nicht das Angebot. K15-D02 verwendet "angeboten" ebenso und betrifft ein Datumsfeld im Loeschkonzept. K10-M33 spricht vom "Serviceangebot Paketuebergabe" -- das ist ein Betriebsdienst mit Ansprechpartner und Eskalationsweg, nicht das Angebot an den Kunden; die Regel gehoert der Sache nach zur Uebergabe. Ein vierter Fall ist ein Grenzfall: K16-D04 ist ueber das Wort "angeboten" hereingekommen, handelt aber tatsaechlich von abgeleiteten Anzeigenamen und damit auch von "Angebot angefragt" -- deshalb steht sie im Buendel zu den Etiketten und nicht bei den Zufallstreffern. Zwei Beobachtungen zum Bestand selbst: Das Preis-Verbot (neun Regeln, K01-D05 / K05-D08 / K07-D07 / K09-D02 / K11-D06 / K13-D06 / K14-D06 / K16-D12 / K19-D01) sagt neunmal weitgehend dasselbe aus neun verschiedenen Konzeptpapieren, mit leicht unterschiedlicher Reichweite -- K14-D06 ist die weiteste Fassung (auch Ausfuhr, Fehlermeldung, Betriebskennzahl), K13-D06 die knappste. Und das Verbot der zweiten Statusquelle steht zweimal wortgleich, als K01-D04 und K09-D09.

### der Vorgang des Endnutzers heisst Angebotsanfrage und ist unverbindlich

**K01-D06** · DARF NICHT — Was der Kunde am Ende ausloest, ist eine unverbindliche Anfrage und keine Bestellung -- ob sie angenommen wird, entscheidet ein Mensch.

> Der Vorgang des Endnutzers DARF NICHT als verbindlicher Auftrag dargestellt werden. Er ist eine unverbindliche Angebotsanfrage; kein Rechner entscheidet über ihre Annahme.

**K09-D01** · DARF NICHT — Dieselbe Regel aus dem Angebots-Konzeptpapier, mit dem Zusatz, dass das Wort "Beauftragung" allein der Innensicht des Betriebs gehoert und dem Kunden gegenueber "Angebotsanfrage" heisst.

> Der Vorgang des Endnutzers DARF NICHT als verbindlicher Auftrag dargestellt werden.

**K10-G07** · GILT — Auch im Uebergabe-Paket gilt die Sprachtrennung: intern heisst das Dokument Beauftragung, gegenueber dem Kunden bleibt es die unverbindliche Angebotsanfrage.

> Es GILT: Die Dokumentart für die Beauftragung ist ein Dokumentname des Betriebs. Der Vorgang des Endnutzers heißt Angebotsanfrage und ist unverbindlich (Eigentümer K09).

**K01-G10** · GILT — Nur ein geprueftes Vorhaben kann zu einer Angebotsanfrage fuehren; ein schnell erzeugter Direkt-Prototyp bleibt ein Arbeitsdokument, und eine Datenbankregel haelt diese Trennung fest.

> Es GILT die Unterscheidung, die den Weg gleich zu Beginn entscheidet: eine geprüfte Anwendung kann Gegenstand einer Angebotsanfrage sein, ein Direkt-Prototyp ist ein Arbeitsdokument und ist es nicht (K07).

**K04-G05** · GILT — Dieselbe Trennung, hier aus Sicht des Eignungs-Checks festgehalten.

> Es GILT: der Direkt-Prototyp ist ein Arbeitsdokument (K07), die geprüfte Anwendung kann Gegenstand einer Angebotsanfrage sein (K01).

**K07-D04** · DARF NICHT — Ein Direkt-Prototyp darf weder als gepruefte Anwendung auftreten noch in eine Angebotsanfrage muenden -- dieselbe Trennung als ausdrueckliches Verbot.

> Ein Direkt-Prototyp DARF NICHT als geprüfte Anwendung dargestellt werden und NICHT Gegenstand einer Angebotsanfrage sein.

**K15-G10** · GILT — Was passiert, wenn jemand seine Angebotsanfrage zurueckziehen oder vorzeitig geloescht haben will, ist bewusst offen gelassen und ausdruecklich als ungeloeste Frage vermerkt.

> Es GILT: Widerruf einer Angebotsanfrage und Löschverlangen vor Ablauf der handelsrechtlichen Frist sind nicht modelliert. K15 stellt beides in Abschnitt 8 und entscheidet es nicht.

### wer ueberhaupt bis zur Angebotsanfrage kommt

**K04-D04** · DARF NICHT — Faellt die Vorpruefung negativ aus, ist der Weg zu Ende: kein Gespraech, kein Vorhaben, keine Angebotsanfrage.

> Ein Check mit NICHT_GEEIGNET DARF NICHT ins Gespräch führen. Es entsteht keine Anwendung (Eigentümer K01) und keine Angebotsanfrage.

**K04-G13** · GILT — Im Zweifel wird der Kunde auf den aufwendigeren Anwendungsweg gelenkt, weil der Dokumentweg jede Pruefung ueberspringt -- Eignung, Anforderungskonzept, Fachreview und Angebot -- und der teurere Weg deshalb der ungefaehrlichere ist.

> Es GILT: Bei Unklarheit zeigt der Vorschlag auf die Anwendung.

**K07-M06** · MUSS — Nach vier Verfeinerungsrunden am Prototyp gibt es einen fuenften Schritt, der das Feilen beendet und zur Angebotsanfrage fuehrt; er ist von Anfang an sichtbar.

> Ein fünfter Eintrag derselben Reihe MUSS das Feilen abschließen und zur Angebotsanfrage führen. Er steht von Anfang an bereit.

**K05-G05** · GILT — Die Bestaetigung der Problembeschreibung im Gespraech ist ein echter Riegel, weil alles Spaetere -- bis hin zum Angebot -- auf genau dieser Beschreibung aufbaut.

> Es GILT: Die Bestätigung des Ausgangsproblems ist ein Tor, keine Höflichkeit. Konzepte, Prototyp und Angebot bauen auf dieser einen Beschreibung auf.

### die fuenf Stufen der Reise und die zwei Zustandsachsen

**K01-M05** · MUSS — Jedes Vorhaben fuehrt zwei getrennte Staende: den Betriebszustand mit acht Werten und die Kundenreise mit fuenf Werten, deren letzter ANGEBOT heisst.

> Eine Anwendung MUSS zwei Zustandsachsen führen, beide Pflicht: `lifecycle_state` mit acht Werten (EINGELADEN, DISCOVERY, IN_BEARBEITUNG, BEAUFTRAGT, IN_DEV, ABNAHME, IN_PROD, PAUSIERT) und `journey_phase` mit fünf Werten (ORIENTIERUNG, INTERVIEW, UEBERSICHT, PROTOTYP, ANGEBOT).

**K19-M04** · MUSS — Der Fortschrittsbalken, den der Kunde sieht, zeigt genau diese fuenf Stufen mit dem Angebot als letzter.

> Die Fortschrittsanzeige MUSS fünf Stufen führen: ORIENTIERUNG · INTERVIEW · UEBERSICHT · PROTOTYP · ANGEBOT.

### "Angebot angefragt" ist nur ein Etikett -- das Siegel ist die einzige Quelle

**K01-D04** · DARF NICHT — Ob ein Angebot angefragt wurde, liest man einzig am Siegel-Zeitstempel ab -- kein zweites Feld darf dieselbe Aussage noch einmal fuehren. (`sealed_at` ist der Zeitpunkt, zu dem gesiegelt wurde.)

> Neben `sealed_at` DARF es keine zweite Quelle für *Angebot angefragt* geben: kein Wahrheitswert, kein zusätzliches Statusfeld, keine abgeleitete Spalte.

**K09-D09** · DARF NICHT — Wortgleich dieselbe Regel wie K01-D04, hier im Angebots-Konzeptpapier abgelegt.

> Neben dem Siegel DARF keine zweite Quelle für den Anzeigenamen *Angebot angefragt* entstehen — kein Wahrheitswert, kein zusätzliches Feld, keine abgeleitete Spalte.

**K09-G04** · GILT — Der Siegel-Zeitstempel ist die alleinige Grundlage der Anzeige "Angebot angefragt", und daraus wird ausdruecklich kein zusaetzlicher Betriebszustand gemacht.

> Es GILT: `sealed_at` ist die einzige Zustandsquelle für den abgeleiteten Anzeigenamen *Angebot angefragt*. Träger und Anzeigeregel liegen bei K11 und K16; ein neunter Betriebszustand entsteht nicht.

**K01-G02** · GILT — Zwei Anzeigetexte werden aus den zugrunde liegenden Staenden errechnet und sind nur Etiketten, keine eigenen Zustaende -- "Angebot angefragt" erscheint, sobald gesiegelt ist.

> *In Klärung* erscheint bei `lifecycle_state = DISCOVERY` zusammen mit `journey_phase = UEBERSICHT`; *Angebot angefragt* bei gesetztem `app.sealed_at`.

**K16-M15** · MUSS — Sobald das Siegel gesetzt ist, muss die Anzeige "Angebot angefragt" auch tatsaechlich erscheinen.

> *Angebot angefragt* MUSS erscheinen, sobald `app.sealed_at` gesetzt ist (Eigentümer K01).

**K16-D04** · DARF NICHT — Ein errechnetes Etikett darf man nicht abspeichern, nicht danach filtern und nicht in einer Auswahlliste anbieten, weil es kein echter Zustand ist.

> Ein abgeleitetes Label DARF NICHT gespeichert, gefiltert oder zur Auswahl angeboten werden. Es ist kein Zustand (F21).

**K19-G04** · GILT — Auf zwei Bildschirmen des Betriebs-Portals darf das errechnete Etikett zwar erscheinen, aber nie ausgewaehlt werden; die Regel nennt "Angebot angefragt" auf dem Kundenbildschirm EN-11 als zweiten Fall desselben Musters.

> In der Auswahlliste von EX-04 und EX-08 wird es nur angezeigt, nie ausgewählt — ein abgeleiteter Name ist nicht setzbar.

### der Riegel vor dem Siegel: gesperrte Schaltflaeche und Nachpruefung auf dem Server

**K09-M06** · MUSS — Der Knopf "Angebot anfordern" bleibt gesperrt, bis alle drei Vorbedingungen erfuellt sind -- er wird dabei sichtbar ausgegraut, damit der Kunde sieht, dass es ihn gibt.

> Die Schaltfläche *Angebot anfordern* MUSS gesperrt bleiben, solange nicht alle drei Vorbedingungen vorliegen. Sie wird ausgegraut gezeigt, nicht ausgeblendet.

**K09-M09** · MUSS — Der Server prueft unabhaengig vom Bildschirm nach, ob die Kundenreise wirklich bei der Stufe ANGEBOT angekommen ist -- steht sie frueher, wird abgewiesen und es entsteht kein Siegel; keine Datenbankregel faengt das ab, allein diese Klausel traegt es.

> Der Serverpfad MUSS zusätzlich prüfen, dass `journey_phase` auf ANGEBOT steht.

### kein Preis auf einem Endnutzer-Bildschirm

**K01-D05** · DARF NICHT — Der Kunde sieht nirgends einen Preis; Angebotspreis und Marge leben ausschliesslich im internen Betriebs-Portal (EXMA).

> Kein Bildschirm des Endnutzer-Portals DARF einen Preis zeigen. Der Angebotspreis (`offer_price_cents`) und der interne Betrag (`margin_cents`) sind Felder des EXMA-Portals (F14).

**K05-D08** · DARF NICHT — Dasselbe Verbot, hier ausdruecklich fuer die beiden Gespraechsstufen ausgesprochen.

> Kein Bildschirm der Stufen 01 und 02 DARF einen Betrag zeigen. Das Endnutzer-Portal führt keinen; die Angebotsangaben sind Felder des EXMA-Portals (K01 Abschn. 3).

**K07-D07** · DARF NICHT — Auch die Prototyp-Vorschau zeigt keine Betraege; erfundene Beispielzahlen in einer Maske sind davon ausgenommen, weil sie nur Anschauung sind.

> Die Vorschau DARF keinen Angebotspreis, keine Marge und keine Provision zeigen (F14). Beispieldaten der Maske sind davon nicht berührt — sie sind Anschauung, kein Preis.

**K09-D02** · DARF NICHT — Dasselbe Verbot, hier fuer die Angebotsstufe selbst -- auch auf dem Bildschirm, auf dem das Angebot angefordert wird, steht keine Zahl.

> Kein Bildschirm dieser Stufe DARF einen Betrag zeigen. Der Angebotspreis (`offer_price_cents`) ist ein Feld des EXMA-Portals (F14).

**K11-D06** · DARF NICHT — Das Verbot gilt nicht nur fuer Bildschirme, sondern auch fuer die technischen Antworten, die das Kundenportal vom Server bekommt.

> Der Angebotspreis DARF das Endnutzer-Portal weder in einer Ansicht noch in einer Antwort einer Schnittstelle erreichen (F14). Er ist ein Feld des Betriebs-Portals.

**K13-D06** · DARF NICHT — Dasselbe Verbot, hier im Konzeptpapier zur Architektur wiederholt.

> Der Angebotspreis DARF das Endnutzer-Portal weder in einer Ansicht noch in einer Antwort einer Schnittstelle erreichen.

**K14-D06** · DARF NICHT — Die weiteste Fassung des Verbots: der Preis darf auch nicht ueber einen Export, eine Fehlermeldung oder eine Betriebsstatistik nach aussen sickern.

> Der Angebotspreis DARF das Endnutzer-Portal in keiner Form erreichen — weder in einer Ansicht noch in der Antwort einer Schnittstelle, einer Ausfuhr, einer Fehlermeldung oder einer Betriebskennzahl.

**K16-D12** · DARF NICHT — Dasselbe Verbot, hier als Regel des Bedien-Standards fuer alle Bildschirme.

> Kein Bildschirm des Endnutzer-Portals DARF einen Betrag zeigen. Der Angebotspreis ist ein Feld des EXMA-Portals (F14).

**K19-D01** · DARF NICHT — Dasselbe Verbot, hier mit der Gegenprobe: es gibt genau drei interne Bildschirme, auf denen der Angebotspreis ueberhaupt erscheinen darf.

> Ein ENDUSER-Bildschirm DARF NICHT Preis, Marge oder Provision zeigen. Der Angebotspreis erscheint ausschließlich in EX-04, EX-05 und EX-08 des EXMA-Portals (F14).

### der Angebotspreis als Feld: wer ihn schreibt, wie er aussieht, wie die Grenze belegt wird

**K11-M14** · MUSS — Auf der internen Detailansicht eines Vorhabens ist der Angebotspreis das einzige Feld, in das ein Mensch frei etwas hineinschreibt.

> Der Angebotspreis MUSS das einzige frei beschreibbare Feld der App-Detailansicht sein. Alle übrigen Angaben sind abgeleitet, gewählt oder gelesen.

**K11-M15** · MUSS — Ein getippter Preis zaehlt erst nach dem Speichern; bis dahin bleibt der zuletzt gespeicherte Betrag der gueltige.

> Der Angebotspreis MUSS erst mit dem Speichern übernommen werden, nicht schon beim Tippen. Bis dahin gilt der zuletzt gesicherte Betrag.

**K11-M16** · MUSS — Der Preis wird als ganze Zahl in Cent gefuehrt und darf nicht negativ sein; alles andere wird abgelehnt statt stillschweigend gerundet.

> Der Angebotspreis MUSS eine ganze Zahl ab null in der kleinsten Einheit der Währung sein (`app.offer_price_cents`, Eigentümer K01).

**K13-M14** · MUSS — Das Aussortieren des Preises passiert erst beim Zusammenbauen der Antwort auf dem Server, weil die Datenbank keine Zugriffsregel je Spalte kennt -- und das wird mit einem Abnahmetest belegt.

> Der Angebotspreis MUSS im Serverpfad ausgesteuert werden.

**K14-M17** · MUSS — Acht benannte Testfaelle muessen bestanden sein, bevor das Kundenportal ueberhaupt in Betrieb gehen darf -- sie belegen, dass der Preis nirgends durchrutscht.

> Der Abnahmetest aus Abschnitt 4.3 mit den Fällen `AT-01` bis `AT-08` MUSS bestanden sein, bevor das Endnutzer-Portal in Betrieb geht.

**K14-G11** · GILT — Dieser Abnahmetest wird von zwei Konzeptpapieren gemeinsam verantwortet und gilt als bestanden, wenn alle acht Faelle die Aussteuerung belegen.

> Es GILT: Der Abnahmetest zum Angebotspreis wird gemeinsam mit K13 geführt und schließt den offenen Punkt O-K13-4.

### Worttreffer "Angebot"/"angeboten" in anderer Bedeutung

**K03-D04** · DARF NICHT — Bei der Anmeldung gibt es als zweiten Sicherheitsschritt ausschliesslich den Code per E-Mail, fuer alle Rollen gleich -- "angeboten" meint hier "zur Auswahl gestellt".

> Ein anderer zweiter Faktor als der Code per E-Mail DARF NICHT angeboten werden, auch nicht Verwaltenden.

**K15-D02** · DARF NICHT — Das Loeschdatum darf nicht als Faelligkeitsdatum missverstanden oder als Bedienelement angezeigt werden -- auch hier meint "angeboten" das Anzeigen einer Auswahl.

> `deleted_at` DARF NICHT als Fälligkeitsdatum gelesen oder als Bedienelement angeboten werden. Die Fälligkeit steht allein in `retention_due.faellig_am`.

**K10-M33** · MUSS — Fuer die Uebergabe des fertigen Pakets muss es einen benannten Verantwortlichen und geregelte Ablaeufe geben, und eine fehlerhafte Uebergabe wird als neue Fassung korrigiert statt still ueberschrieben -- "Serviceangebot" meint hier eine Betriebsleistung, nicht das Angebot an den Kunden.

> K16/K13 MÜSSEN das Serviceangebot „Paketübergabe“ mit Service Owner, Incident-, Problem-, Change-, Priorisierungs-, Eskalations- und Empfangsprozess führen.

---

## Haekchen

*UNTERSCHRIFT + BEIDE HAEKCHEN* — BS:67 · **13 Regeln**

**Anmerkung:** Im Register stehen unter diesem Wort zwei verschiedene Haekchen, die nicht verwechselt werden duerfen. Das eine sitzt am Ende der Stufe 03 und schaltet den Weiterweg nach Stufe 04 frei -- davon handeln K06-M16, K06-M17, K06-M28, K06-D08, K06-D09 und mittelbar K06-D14. Das andere sind die zwei Haekchen im Freigabeblock des Angebots in Stufe 05, neben der getippten Unterschrift -- davon handeln K09-M02, K09-M04, K09-M05, K09-M16, K09-D06, K09-G08 und K19-M09. Die Zeile des Fadens 'UNTERSCHRIFT + BEIDE HAEKCHEN' spricht von den zweiten. Eine Regel ist nur am Rande ein Haekchen-Thema: K06-D14 verbietet eigentlich, dem Kunden interne Kennungen zu zeigen, und nennt das Haekchen nur in der Begruendung. Das ist ein Lesehinweis, keine Zuordnungsentscheidung.

### das Haekchen am Ende der Stufe 03 als Riegel vor Stufe 04

**K06-M16** · MUSS — Das Haekchen ist ein Riegel: erst wenn der Kunde es setzt, erscheint ueberhaupt die Schaltflaeche zum Weitergehen; vorher steht dort nur ein Hinweis auf die ausstehende Pruefung. ('Gate' ist das englische Wort fuer genau so einen Riegel. K06 ist das Konzeptpapier 'Anforderungskonzepte, Projektvertrag, Fachreview'.)

> Das Häkchen MUSS ein Gate sein: erst gesetzt, erscheint der Weiterweg. Ohne Häkchen steht an seiner Stelle der Prüfhinweis.

**K06-D08** · DARF NICHT — Ohne gesetztes Haekchen darf der Weg in Stufe 04 weder sichtbar sein noch funktionieren -- und ein muendliches Einverstaendnis zaehlt ausdruecklich nicht.

> Der Weiterweg nach Stufe 04 DARF NICHT ohne gesetztes Häkchen erscheinen oder wirken. Ein Zuruf ersetzt es nicht.

**K06-D09** · DARF NICHT — Das Haekchen laesst sich gar nicht erst anklicken, solange fuer genau die angezeigte Fassung des Dokuments keine bestandene Pruefung vorliegt -- sonst koennte man die Pruefung umgehen.

> Das Häkchen DARF NICHT setzbar sein, solange zum angezeigten Artefaktstand kein bestandener Prüflauf vorliegt. Sonst führte der Weg an der Prüfung vorbei (K06-M03).

### womit das Stufe-03-Haekchen belegt wird

**K06-M17** · MUSS — Jedes Setzen des Haekchens schreibt einen Eintrag in das Protokollbuch; laesst sich der Eintrag nicht schreiben, findet auch der Stufenwechsel nicht statt. ('event' ist der Name dieses Protokollbuchs; K02 ist das Fundament-Papier, dem es gehoert.)

> Das Setzen des Häkchens MUSS einen Protokolleintrag in `event` erzeugen (Eigentümer K02). Scheitert der Eintrag, scheitert der Stufenwechsel.

**K06-M28** · MUSS — Der Beweis fuer das Haekchen ist allein der unveraenderliche Protokolleintrag zu genau dieser Dokumentfassung; passt er nicht eindeutig, oder ist inzwischen eine neuere Fassung da, gilt das Haekchen als nicht gesetzt.

> Das Häkchen wird durch den unveränderlichen K02-Eintrag zum exakten Artefaktstand belegt. Das Gate liest diesen Eintrag; ohne eindeutige Zuordnung oder bei neuerer Revision gilt es als nicht gesetzt.

### was der Kunde vor dem Haekchen lesen koennen muss

**K06-D14** · DARF NICHT — Interne Kuerzel duerfen dem Kunden nicht angezeigt werden -- er soll Klartext lesen, denn ein Haekchen unter etwas Unverstaendlichem waere wertlos.

> Die Kennungen der Familie 1 DÜRFEN im Endnutzer-Portal nicht sichtbar sein. Der Kunde liest Klartext, sonst wäre sein Häkchen wertlos (F25).

### der Freigabeblock des Angebots: genau drei Eingaben

**K09-M02** · MUSS — Am Ende des Angebots stehen genau drei Felder -- eine getippte Unterschrift und zwei Haekchen -- und kein viertes. (K09 ist das Konzeptpapier 'Angebot und Freigabe'.)

> Der Freigabeblock MUSS genau drei Eingaben führen: eine getippte Unterschrift und zwei Häkchen. Eine vierte Eingabe gibt es nicht.

**K09-M04** · MUSS — Mit dem ersten Haekchen bestaetigt der Kunde zweierlei auf einmal: dass seine Anfrage unverbindlich ist und dass ihm die offenen Punkte gezeigt wurden -- der Verweis auf diese offenen Punkte muss anklickbar sein und sie sofort zeigen.

> Das erste Häkchen MUSS zwei Aussagen zugleich tragen: die Anfrage ist unverbindlich, und die offenen Punkte wurden offengelegt.

**K09-M05** · MUSS — Mit dem zweiten Haekchen bestaetigt der Kunde, die beiden Merkblaetter erhalten zu haben, und nimmt zur Kenntnis, dass ihre Verteilung in seinem eigenen Haus seine Sache ist.

> Das zweite Häkchen MUSS den Empfang der beiden Memos bestätigen und festhalten, dass die Weitergabe im Haus des Kunden bei diesem liegt.

### nichts vorbelegen, alles noch einmal zeigen

**K09-D06** · DARF NICHT — Unterschrift und Haekchen muessen jedes Mal frisch vom Menschen gesetzt werden -- kein Voraushaken, kein Uebernehmen aus einem frueheren Vorgang.

> Unterschrift und Häkchen DÜRFEN NICHT vorbelegt, vorausgefüllt oder aus einem früheren Vorgang übernommen werden.

**K09-M16** · MUSS — Vor dem endgueltigen Absenden erscheint eine Zusammenfassungsseite mit Unterschrift, beiden Haekchen, offenen Punkten und Empfaengeradresse; man kann zurueck und korrigieren, und erst die erneute Bestaetigung loest den Vorgang aus.

> Vor dem endgültigen Absenden zeigt eine Prüfseite Unterschrift, beide Häkchen, offene Punkte und Empfängeradresse.

### wo der Nachweis liegt und was der Bildschirm zeigen muss

**K09-G08** · GILT — Unterschrift und erstes Haekchen werden nicht als Felder in der Datenbank gespeichert; der Nachweis ist das erzeugte Bestaetigungsdokument selbst.

> Es GILT: Für die Unterschrift und für das erste Häkchen führt das Datenmodell keine Spalte. Der Nachweis ist das Bestätigungsdokument, nicht eine Spalte (Abschn. 8, O-K09-1, O-K09-2).

**K19-M09** · MUSS — Der Bildschirm mit der Nummer EN-09 muss beide Haekchen anzeigen, das zweite ausdruecklich als Uebergabe der zwei Merkblaetter beschriften, und er wirkt nur zusammen mit dem Siegel. (K19 ist die Build-Referenz, das Papier, das die Bildschirme durchnummeriert; 'EN-09' ist die Nummer dieses einen Bildschirms im Endnutzer-Portal.)

> EN-09 MUSS beide Häkchen zeigen und das zweite als Übergabe der beiden Memos beschriften. Es wirkt nur zusammen mit dem Siegel (F03, CHECK `ack_needs_seal`, Prüffall T22, Eigentümer K09).

---

## Siegel

*... > SIEGEL (Riegel)* — BS:67 · **23 Regeln**

**Anmerkung:** Lesehilfe zu den Kennungen: Eine Kennung wie "K09-M11" heisst: Dokument K09, elfte Regel der Art MUSS; "D" steht fuer DARF NICHT, "G" fuer GILT. Weiter tauchen auf: `app` = die Tabelle, in der jede Anwendung genau eine Zeile hat; `journey_phase` = das Feld, das festhaelt, wie weit die Kundenreise gediehen ist; `open_points` = das Feld mit der Zahl der offenen Punkte; `ack_needs_seal`, `sealed_needs_state`, `actor_sealed_no_money` = Schranken in der Datenbank, die einen unzulaessigen Eintrag von vornherein abweisen; T3, T15, T17, T22 = Nummern von Pruefaellen; F03, F36 = Nummern von Festlegungen; EN-09 = die neunte Bildschirmmaske der Bauliste.

Zwei Hinweise zum Wortsinn, damit beim Lesen nichts durcheinandergeraet:

(1) Sieben der 23 Regeln benutzen "versiegelt" in einer voellig anderen Bedeutung als der Faden: K20-M06, K20-D06, K20-D08, K20-M20, K20-G05, K20-G04 und K03-D08 sprechen nicht vom Siegel am Angebot, sondern von einem versiegelten BENUTZERKONTO -- dem allerersten Verwalterkonto, das gegen Loeschen gesperrt ist und keine Geldrechte tragen darf. Sie sind hier nur wegen des Wortstamms "siegel" gelandet. Sie stehen unten als eigenes Buendel beisammen.

(2) K10-G04 enthaelt das Wort "Guetesiegel" als blosses Sprachbild; die Regel handelt vom Abdeckungsnachweis, nicht vom Siegel.

### wo das Siegel steht -- an genau einer Stelle, ohne zweite Wahrheitsquelle daneben

**K01-M01** · MUSS — Jede Anwendung ist genau eine Zeile in der Tabelle `app` (der Liste aller Anwendungen), und Zustand, Stufe, Siegel und Aufbewahrungsklasse werden ausschliesslich an dieser Zeile gefuehrt, an keiner anderen Stelle.

> Eine Anwendung MUSS genau eine Zeile in `app` sein. `app` ist die Aggregatswurzel; die kanonische Kennung ist `app.id`. Zustand, Stufe, Siegel und Aufbewahrungsklasse hängen an dieser Zeile und nirgends sonst.

**K25-G06** · GILT — Ob eine Anwendung noch geaendert werden darf, entscheidet ein einziges Feld -- das Siegel an der Anwendung; eine zweite Stelle, die dasselbe aussagen koennte, existiert nicht.

> Es GILT: Die Zeitgrenze hängt an genau einem Feld, dem Siegel an der Anwendung. Es gibt keine zweite Zustandsquelle.

**K09-D09** · DARF NICHT — Dass am Bildschirm "Angebot angefragt" steht, wird allein aus dem Siegel abgelesen -- kein zusaetzliches Ja/Nein-Kaestchen, kein extra Feld, keine mitgerechnete Spalte daneben.

> Neben dem Siegel DARF keine zweite Quelle für den Anzeigenamen *Angebot angefragt* entstehen — kein Wahrheitswert, kein zusätzliches Feld, keine abgeleitete Spalte.

### was erfuellt sein muss, bevor ueberhaupt gesiegelt werden darf

**K09-M09** · MUSS — Das Programm im Hintergrund (Serverpfad) darf erst siegeln, wenn das Feld `journey_phase` -- der Stand der Kundenreise -- auf ANGEBOT steht; steht es noch frueher, wird abgewiesen, und diese Pruefung leistet keine Schranke in der Datenbank, sondern allein diese Regel.

> Der Serverpfad MUSS zusätzlich prüfen, dass `journey_phase` auf ANGEBOT steht. Bei einem früheren Wert wird abgewiesen: kein Freigabeblock, kein Siegel. Keine Bedingung im Datenmodell prüft das; die Regel trägt allein diese Klausel.

**K09-M12** · MUSS — Vor dem Siegel muss die Anwendung den Anfangszustand DISCOVERY (Erkundung) verlassen haben; der Wechsel geschieht im selben unteilbaren Vorgang, und die Datenbankschranke `sealed_needs_state` haelt das Ergebnis fest.

> Vor dem Siegel MUSS die Anwendung den Betriebszustand DISCOVERY verlassen haben. Der Wechsel läuft über den Zustandsbefehl aus K01 Abschn. 3; `sealed_needs_state` sichert das Ergebnis in der Datenbank. Der Wechsel ist Teil des atomaren Befehls (Abschn. 8, O-K09-3).

**K09-M19** · MUSS — Beim Siegeln wird die Zahl der offenen Punkte aus der versionierten Liste des Dokuments K10 frisch berechnet, und wenn Zahl, Dokumentstand und Pruefsumme (Hash) nicht zusammenpassen, wird abgewiesen.

> `open_points` wird beim Siegel aus der versionierten K10-Liste berechnet. Zahl, Dokumentrevision und Hash müssen übereinstimmen; bei Drift wird abgewiesen.

### der Siegelvorgang selbst -- ganz oder gar nicht, und nur ein einziges Mal

**K09-M11** · MUSS — Siegel und Empfangsbestaetigung werden in einem einzigen unteilbaren Zug (Transaktion) gesetzt -- geht ein Schritt schief, wird alles zurueckgenommen, damit kein halb fertiger Abschluss stehenbleibt.

> Das Absenden MUSS Siegel und Empfangsbestätigung in einer Transaktion setzen. Scheitert ein Schritt, wird alles zurückgerollt; ein halber Abschluss entsteht nicht.

**K09-M18** · MUSS — Im selben gegen Zwischeneingriffe gesperrten Vorgang springt der Zustand von DISCOVERY auf IN_BEARBEITUNG, und erst danach werden Siegel und Empfangsbestaetigung mit demselben Zeitstempel gesetzt; ist der Sprung nicht erlaubt, bleibt alles unveraendert.

> Im selben gesperrten Vorgang wechselt `DISCOVERY` über K01 nach `IN_BEARBEITUNG`, danach werden Siegel und Empfangsbestätigung mit identischem Zeitpunkt gesetzt. Ist der Übergang unzulässig, bleibt alles unverändert.

**K09-M10** · MUSS — Ist bereits gesiegelt, muss ein zweites Absenden erkannt und abgewiesen werden, ohne dass dabei ein neuer Zeitpunkt geschrieben wird.

> Der Serverpfad MUSS ein bereits gesetztes Siegel als Abschluss erkennen und ein zweites Absenden abweisen. Dabei wird kein Zeitpunkt neu geschrieben (K09-D10).

**K09-M21** · MUSS — Doppelklick, gleichzeitiger Zugriff von zwei Seiten oder ein misslungener Versand duerfen kein zweites Siegel erzeugen; der Abschluss bleibt gueltig, und der Versand wird gefahrlos wiederholt (idempotent = mehrfaches Ausfuehren wirkt wie einmaliges) und notfalls als Stoerung eskaliert.

> Wiederholung, Parallelzugriff oder Versandfehler erzeugen kein zweites Siegel. Der Abschluss bleibt wirksam; der Versand läuft idempotent mit Retry und Incident-Eskalation.

### Siegel, Empfangsbestaetigung und die beiden Haekchen haengen zusammen

**K09-D07** · DARF NICHT — Eine Empfangsbestaetigung darf nur entstehen, wenn das Siegel gesetzt ist -- die Datenbankschranke `ack_needs_seal` weist jeden anderen Versuch ab, nachgewiesen im Pruefall T22.

> Die Empfangsbestätigung DARF NICHT ohne gesetztes Siegel entstehen. `ack_needs_seal` weist den Versuch ab; belegt durch Prüffall T22.

**K19-M09** · MUSS — Die Bildschirmmaske EN-09 muss beide Haekchen anzeigen und das zweite ausdruecklich als Uebergabe der beiden Memos beschriften; wirksam wird das Haekchen nur zusammen mit dem gesetzten Siegel.

> EN-09 MUSS beide Häkchen zeigen und das zweite als Übergabe der beiden Memos beschriften. Es wirkt nur zusammen mit dem Siegel (F03, CHECK `ack_needs_seal`, Prüffall T22, Eigentümer K09).

### was nach dem Siegel gesperrt ist -- eine Zeitgrenze, keine Rechteliste

**K25-D18** · DARF NICHT — Nach dem Siegel laesst sich an der erzeugten Huelle nichts mehr aendern -- nicht weil es verboten waere, sondern weil es die Bedienung dafuer gar nicht gibt.

> Nach dem Siegel DARF kein Element der Hülle mehr änderbar sein. Die Bedienung dafür ist nicht vorhanden.

**K25-G05** · GILT — Der Schutz vor Fehlbedienung (Poka-Yoke, japanisch fuer "Fehler unmoeglich machen") arbeitet hier ueber den Zeitpunkt und nicht ueber Berechtigungen: vor dem Siegel aenderbar, danach nichts mehr.

> Es GILT: Poka-Yoke ist hier eine **Zeitgrenze**, keine Rechteliste. Vor dem Siegel änderbar innerhalb des Universums, danach nichts.

**K25-G07** · GILT — Es gibt zwei voneinander unabhaengige Sperren -- die Zeitgrenze am Siegel und eine inhaltliche Sperre ab Stufe 04, die schon greift, solange gar nicht gesiegelt ist.

> Es GILT die Trennung zweier Sperren: die **Zeitgrenze** am Siegel und die **Sachgrenze** ab Stufe 04. Die Sachgrenze gilt auch, solange das Siegel noch leer ist.

### "versiegelt" im ganz anderen Sinn: das gesperrte Erst-Admin-Konto (Wortstamm-Treffer, siehe Anmerkung)

**K20-M06** · MUSS — Das allererste Verwalterkonto (Erst-Admin) wird von vornherein gesperrt und ohne jedes Geldrecht angelegt; die Datenbankschranke `actor_sealed_no_money` weist jede andere Kombination ab.

> Der Erst-Admin MUSS versiegelt und ohne Geldrechte angelegt werden. Die Bedingung `actor_sealed_no_money` weist die Verbindung ab; belegt durch T3.

**K03-D08** · DARF NICHT — Ein gesperrtes (versiegeltes) Benutzerkonto darf keine Zahlungen freigeben duerfen.

> Ein versiegeltes Konto DARF keine Zahlungsfreigaben tragen — Bedingung `actor_sealed_no_money` (Eigentümer K20), belegt durch T3.

**K20-D06** · DARF NICHT — Ein gesperrtes (versiegeltes) Benutzerkonto darf ueberhaupt keine Rechte tragen, die Geld bewegen.

> Ein versiegeltes Konto DARF keine Geldrechte tragen; belegt durch T3.

**K20-D08** · DARF NICHT — Das erste Verwalterkonto darf nicht geloescht werden, solange es keinen zweiten aktiven Plattform-Verwalter gibt -- sonst stuende niemand mehr zur Verfuegung.

> Der versiegelte Erst-Admin DARF NICHT entfernt werden, solange kein zweiter aktiver Plattform-Admin besteht; belegt durch T15 und T17.

**K20-M20** · MUSS — Vor dem Entfernen eines Zugangs prueft das Programm drei Dinge -- ob jemand sich selbst entfernt, ob es der letzte Verwalter waere und ob es der versiegelte Erst-Admin ist -- und die Bedienoberflaeche nennt die Aktion "Portalzugang entfernen" und zeigt die Folge vor dem Bestaetigen an.

> Vor dem Entfernen prüft der Server eigenes Konto, letzter aktiver Plattform-Admin und versiegelten Erst-Admin. Die vorhandene Membership-Invariante bleibt letzte Datenbankschranke. Die UI benennt die Aktion *Portalzugang entfernen* und zeigt die Auswirkung vor Bestätigung.

**K20-G05** · GILT — Entfernt wird immer nur die Zugehoerigkeit zum Portal (`membership`) und nie das Konto selbst, und drei Bedingungen begrenzen diesen Befehl.

> Es GILT F36: Entfernt wird ausschließlich die portalbezogene `membership`. Drei Bedingungen begrenzen den Command: letztes aktives Plattform-Admin-Konto, versiegelter Erst-Admin und eigenes Konto.

**K20-G04** · GILT — Zwei der drei Schutzregeln laufen still im Hintergrund und haben keine eigene Anzeige im Portal, waehrend die Meldungen des Einladungswaechters direkt dort erscheinen, wo abgelehnt wird.

> Es GILT: Zwei der drei Invarianten — ein aktiver Plattform-Admin und der versiegelte Erst-Admin — laufen als Selbstprüfung ohne eigene Anzeige im Portal (EXMA-Handbuch 5.3).

### "Guetesiegel" nur als Sprachbild -- die Regel handelt vom Abdeckungsnachweis

**K10-G04** · GILT — Der Abdeckungsnachweis sagt nur, welche Regeln belegt sind und welche nicht -- er behauptet ausdruecklich nicht, dass damit genug belegt sei.

> Es GILT: Der Abdeckungsnachweis ist ein Fertig-Kriterium, kein Gütesiegel. Er sagt, was belegt ist und was nicht — er behauptet nicht, dass genug belegt sei.

---

## Uebergabe

*das Uebergabe-Paket* — BS:69 · **31 Regeln**

**Anmerkung:** Lesehilfe zu den Kennungen: "K10-M27" heisst Dokument K10, siebenundzwanzigste Regel der Art MUSS; "D" = DARF NICHT, "G" = GILT. Weiter tauchen auf: SBOM = Stueckliste aller mitgelieferten Softwarebausteine; `mitbestimmung_ack_at` = das Feld, in dem der Zeitpunkt der Uebergabe der beiden Memos steht; `approval.object_ref` = das Feld der Freigabezeile, das auf die Pruefsummen zeigt; `event` = die Protokolltabelle; F03, F23, F34 = Nummern von Festlegungen; EN-09 = die neunte Bildschirmmaske; MIT und Apache-2.0 = zwei Lizenzen fuer quelloffene Software; "fail-closed" = im Zweifel wird gesperrt statt durchgelassen.

Drei Hinweise zum Wortsinn, damit beim Lesen nichts durcheinandergeraet:

(1) Sechs Regeln meinen mit "Uebergabe" NICHT die Uebergabe an den Kunden, sondern das Weiterreichen von Text an ein Sprachmodell: K01-M17, K05-M23, K14-M09, K14-M10, K17-M21 und K08-M32. Sie sind allein ueber das Wort hier gelandet und stehen unten als eigenes Buendel.

(2) Fuenf Regeln -- K14-M20, K14-M21, K14-D13, K14-D14, K14-G14 -- handeln vom "Uebergabezugang": einem technischen Zugang, den eine Partnerfirma zur Betriebsumgebung der fertigen Anwendung erhaelt. Das ist eine andere Sache als das Uebergabe-Paket mit den Pruefsummen.

(3) In K10-D08 und K10-G08 steht das Wort "Vertrag", gemeint ist aber die Uebergabegestaltung des Prototyp-Baukastens als Teilmenge des Projektvertrags -- kein eigenes Vertragswerk.

### was im Uebergabe-Paket enthalten sein muss

**K06-M25** · MUSS — Ganz oben im Uebergabe-Paket muss stehen, welcher Anteil der Regeln durch Tests belegt ist, und jede Regel ohne massgeblichen Test (Golden-Test) muss einzeln benannt werden.

> Das Übergabe-Paket (Eigentümer K10) MUSS die Abdeckungsquote sichtbar im Kopf führen und jede ohne Golden-Test gebliebene Klausel einzeln aufführen (F34).

**K04-M21** · MUSS — Die vom Kunden bestaetigte Kenntnisnahme muss aufbewahrt werden und in das Uebergabe-Paket eingehen, weil sich sonst die Auskunftspflicht der KI-Verordnung nicht nachweisen laesst.

> Die Kenntnisnahme MUSS als Nachweis erhalten bleiben und in das Übergabe-Paket (K10 Abschn. 3) eingehen. Ohne sie ist die Auskunftspflicht nach Art. 25 Abs. 4 der KI-Verordnung nicht belegbar.

**K10-M24** · MUSS — Die Stueckliste der mitgelieferten Softwarebausteine (SBOM) muss von einem Programm lesbar sein und Name, Version, Herkunft, Lizenz und Abhaengigkeiten fuehren; eine unbekannte oder unzulaessige Lizenz haelt die Uebergabe an.

> Die SBOM MUSS maschinenlesbar sein, Komponentenname, Version, Lieferant oder Ursprung, Lizenz und Abhängigkeitsbeziehung führen und einem anerkannten Austauschformat folgen. Unbekannte oder nach K08 unzulässige Lizenz blockiert die Übergabe.

**K08-M18** · MUSS — In dem, was ausgeliefert wird, duerfen quelloffene Bausteine nur unter den Lizenzen MIT oder Apache-2.0 stecken, und der Nachweis dafuer ist die Stueckliste im Uebergabe-Paket.

> Im Auslieferungspfad MÜSSEN Quellen mit `type = OSS` auf die Lizenzen MIT und Apache-2.0 begrenzt sein. Beleg ist die Stückliste im Übergabe-Paket (Eigentümer K10).

### bevor das Paket herausgeht: saeubern, im Vier-Augen-Prinzip freigeben, an die Pruefsummen binden

**K10-M11** · MUSS — Vor der Uebergabe wird jedes Dokument und das Testpaket geputzt (gescrubbt): keine Passwoerter, keine Schluessel, keine Angaben zu Personen ueber das fachlich Noetige hinaus.

> Jedes Dokument und das Testpaket MÜSSEN vor der Übergabe gescrubbt sein: keine Zugangsdaten, keine Schlüsselwerte, keine personenbezogenen Angaben über das fachlich Nötige hinaus (K14 Abschn. 3).

**K10-M12** · MUSS — Eine Uebergabe braucht zwei Menschen: wer sie vorbereitet hat, darf sie nicht selbst freigeben.

> Die Übergabe MUSS über die Vier-Augen-Freigabe laufen (Eigentümer K14). Bearbeiter und Freigeber sind zwei verschiedene Personen.

**K10-M27** · MUSS — Die Freigabezeile haelt Bearbeiter, Freigeber, Zeitpunkt und Entscheidung fest und verweist auf die beiden Pruefsummen des Pakets, wobei dieser Verweis heute nur freier Text und nicht technisch gesichert ist -- und wer nachtraeglich aendert, still ersetzt oder unvollstaendig protokolliert, hat keinen uebergabefaehigen Stand mehr.

> Die Freigabezeile MUSS Bearbeiter, Freigeber, Zeitpunkt und Entscheidung führen und über `approval.object_ref` auf Manifest- und Archivprüfsumme zeigen (K14 Abschn. 3). […] Nachträgliche Änderung, paralleler Ersatz oder unvollständiges Protokoll macht den Stand nicht übergabefähig.

### jede Uebergabe wird eindeutig gekennzeichnet, protokolliert und einem Empfaenger zugeordnet

**K10-M19** · MUSS — Jede Uebergabe traegt eine unveraenderliche Kennung aus Anwendung, Projektnummer, Paketstand, Vertragsstand, Erzeugungszeitpunkt und Quellstand -- und sobald sich der Inhalt aendert, entsteht ein neuer Paketstand, fuer den die alte Freigabe nicht mehr gilt.

> Jede Übergabe MUSS eine unveränderliche Release-Kennung führen: Anwendung, Projektnummer, Paketrevision, Projektvertragsrevision, Erzeugungszeitpunkt und Quellrevision. Eine Inhaltsänderung erzeugt eine neue Paketrevision; eine bestehende Freigabe gilt nicht weiter.

**K10-M18** · MUSS — Jede Uebergabe hinterlaesst einen Protokolleintrag mit Anwendung, Zeitpunkt und der Angabe, wer gehandelt hat.

> Jede Übergabe MUSS einen Protokolleintrag erzeugen (Träger `event`, Eigentümer K02) mit Anwendung, Zeitpunkt und handelnder Instanz.

**K10-M35** · MUSS — Zu jeder Uebergabe gehoert genau ein benannter Empfaenger -- ein Partner-Mandant mit erkennbarer Aufgabe -- und ohne diesen Namen kommt keine Uebergabe zustande.

> Jede Übergabe MUSS genau einen Empfänger benennen: einen Mandanten der Art Partner mit erkennbarer Aufgabe. Ohne benannten Empfänger entsteht keine Übergabe.

**K10-M33** · MUSS — Die Paketuebergabe wird als regulaere Dienstleistung mit benanntem Verantwortlichen und geregelten Ablaeufen fuer Stoerungen, Aenderungen und Eskalationen gefuehrt, und eine fehlerhafte Uebergabe wird als neuer, erneut freigegebener Stand korrigiert und niemals stillschweigend ueberschrieben.

> K16/K13 MÜSSEN das Serviceangebot „Paketübergabe“ mit Service Owner, Incident-, Problem-, Change-, Priorisierungs-, Eskalations- und Empfangsprozess führen. Eine fehlerhafte Übergabe wird korrigiert und als neue Revision erneut freigegeben, nie still überschrieben.

### die beiden Unterlagen (Memos): uebergeben ja, versenden nein

**K01-D15** · DARF NICHT — Die Plattform verschickt die beiden Unterlagen an niemanden; nachgewiesen wird nur, dass der Kunde sie erhalten hat, und was er im eigenen Haus damit tut, ist seine Sache.

> FREIRAUM DARF die beiden Unterlagen an niemanden versenden. Nachgewiesen wird ausschließlich die Übergabe an den Kunden; die Weitergabe im Haus des Kunden liegt beim Kunden.

**K09-D04** · DARF NICHT — Dasselbe aus Sicht des Angebotsdokuments: die Plattform versendet die beiden Memos nicht, sie belegt nur die Uebergabe an den Kunden.

> FREIRAUM DARF die beiden Memos an niemanden versenden. Nachgewiesen wird ausschließlich die Übergabe an den Kunden; wen er im Haus informiert, entscheidet er selbst.

**K01-M24** · MUSS — Der Nachweis der Uebergabe ist ein Zeitstempel an der Anwendung im Feld `mitbestimmung_ack_at`; eine eigene Prozessstufe dafuer gibt es nicht mehr.

> Die Übergabe der beiden Unterlagen MUSS als Zeitpunkt an der Anwendung nachgewiesen werden — die Stufe dafür ist gestrichen, geblieben ist die Spalte `mitbestimmung_ack_at` (F03).

**K09-G03** · GILT — Dieser Zeitstempel belegt ausschliesslich, dass der Kunde die Unterlagen bekommen hat -- er belegt niemals einen Versand durch die Plattform.

> Es GILT F03: `mitbestimmung_ack_at` (Ersatz gestrichener Stufe) belegt allein die Übergabe an den Kunden, nie einen Versand durch die Plattform.

**K19-M09** · MUSS — Die Bildschirmmaske EN-09 zeigt beide Haekchen, das zweite ausdruecklich beschriftet als Uebergabe der beiden Memos, und es wirkt nur zusammen mit dem gesetzten Siegel.

> EN-09 MUSS beide Häkchen zeigen und das zweite als Übergabe der beiden Memos beschriften. Es wirkt nur zusammen mit dem Siegel (F03, CHECK `ack_needs_seal`, Prüffall T22, Eigentümer K09).

### die Uebergabegestaltung des Baukastens ist kein eigenes Vertragswerk

**K10-D08** · DARF NICHT — Wie der Prototyp-Baukasten uebergeben wird, steht als Teil des Projektvertrags und darf nicht als eigener Vertrag daneben gefuehrt werden.

> Die Übergabegestaltung für den Prototyp-Baukasten DARF NICHT als eigenständiger Vertrag geführt werden. Sie ist eine Teilmenge des Projektvertrags (F23, Eigentümer K06).

**K10-G08** · GILT — Die Uebergabegestaltung ist nur eine Ansicht auf den Projektvertrag -- kein zweites Dokument, das etwas anderes behaupten koennte.

> Es GILT: Die Übergabegestaltung für den Baukasten ist eine Sicht auf den Projektvertrag, kein zweites Dokument mit eigener Wahrheit.

### der Uebergabezugang, den eine Partnerfirma zur fertigen Anwendung bekommt (siehe Anmerkung)

**K14-M20** · MUSS — Jede beteiligte Partnerfirma bekommt ihren eigenen Zugang mit eigenem Geheimnis; einen gemeinsam benutzten Zugang gibt es nicht.

> Ein Übergabezugang MUSS je Partnermandant einzeln erteilt werden. Sind zwei Partner beteiligt, entstehen zwei Zugänge mit zwei getrennten Geheimnisreferenzen. Ein gemeinsamer Zugang entsteht nicht.

**K14-M21** · MUSS — Jeder solche Zugang verfaellt automatisch nach 90 Tagen, und die Frist laeuft fuer jeden Zugang einzeln.

> Jeder Übergabezugang MUSS einen Ablaufzeitpunkt tragen. Die Frist beträgt 90 Tage ab Erteilung und läuft je Zugang getrennt.

**K14-D13** · DARF NICHT — Ein Zugang ohne Ablaufdatum wird gar nicht erst erteilt, denn ein Zugang, den man erst bei Bedarf entziehen will, ist in Wahrheit ein dauerhafter.

> Ein Übergabezugang DARF NICHT ohne Ablaufzeitpunkt erteilt werden. Ein Zugang, der erst bei Bedarf entzogen werden soll, gilt als dauerhaft und wird nicht erteilt.

**K14-D14** · DARF NICHT — Ein Zugang darf nicht weitergegeben oder von einer zweiten Firma mitbenutzt werden, weil man ihn dann keiner der beiden mehr gezielt entziehen koennte.

> Ein Übergabezugang DARF NICHT weitergereicht oder von einem zweiten Partner mitbenutzt werden. Ein geteilter Zugang lässt sich einer der beiden Firmen nicht entziehen.

**K14-G14** · GILT — Dieser Zugang fuehrt in die laufende Anwendung selbst, nicht ins Portal der Plattform, und verschafft dem Partner dort weder eine Rolle noch ein Freigaberecht.

> Es GILT: Der Übergabezugang führt in die Betriebsumgebung der übergebenen Anwendung, nicht in ein Portal der Plattform. Ein Partner erhält daraus weder eine Portalrolle noch ein Freigaberecht.

### "Uebergabe an ein Sprachmodell" -- ein voellig anderer Vorgang (siehe Anmerkung)

**K01-M17** · MUSS — Bevor Text an ein Sprachmodell (die KI) geht, werden Angaben zu Personen unkenntlich gemacht, und der Schluessel zum Zurueckuebersetzen bleibt in der Plattform.

> Vor jeder Übergabe an ein Sprachmodell MÜSSEN personenbezogene Angaben maskiert werden. Die Rückauflösung bleibt in der Plattform; ihre Aufbewahrung führt K15, den Modellpfad K17.

**K14-M10** · MUSS — Dieselbe Pflicht aus Sicht der Sicherheitsgrundlinie, ausdruecklich auch fuer hochgeladene Dokumente.

> Vor jeder Übergabe an ein Sprachmodell MÜSSEN personenbezogene Angaben in Texteingaben und hochgeladenen Dokumenten maskiert werden. Die Zuordnung für die Rückauflösung bleibt in der Plattform; ihre Aufbewahrung führt K15.

**K05-M23** · MUSS — Dieselbe Pflicht, hier fuer das gefuehrte Gespraech der Stufen 01-02 wiederholt.

> Vor jeder Übergabe an ein Sprachmodell MÜSSEN personenbezogene Angaben maskiert werden; die Rückauflösung bleibt in der Plattform (K01 Abschn. 3, Modellpfad K17).

**K14-M09** · MUSS — Alles, was ein Nutzer eintippt, diktiert oder hochlaedt, gilt als blosser Inhalt und nie als Befehl; es wird vor der Weitergabe an die KI sauber von den Anweisungen getrennt, damit darin versteckte Kommandos nicht ausgefuehrt werden.

> Text, den ein Nutzer eingibt, diktiert oder hochlädt, MUSS als Daten behandelt werden. Er wird vor der Übergabe an ein Sprachmodell strukturell von der Anweisung getrennt; eine darin enthaltene Handlungsanweisung wird nicht ausgeführt (Agentenbetrieb K17).

**K17-M21** · MUSS — Dieselben beiden Pflichten -- Nutzertext ist nie Befehl, und Personenangaben werden vorher unkenntlich gemacht -- aus Sicht des Agentenbetriebs.

> Text, den ein Nutzer eingibt, diktiert oder hochlädt, MUSS als Daten behandelt werden; eine darin enthaltene Handlungsanweisung wird nicht ausgeführt. Vor der Übergabe an ein Sprachmodell MÜSSEN personenbezogene Angaben maskiert werden (K01 Abschn. 3).

**K08-M32** · MUSS — Zustaendigkeit fuer Quellen und Rechte liegt bei K08, die Ausfuehrung des gemeinsamen Ausgabetors bei K17, und wenn die Versionsangaben fehlen oder die Kombination nicht freigegeben ist, wird im Zweifel gesperrt statt durchgelassen.

> K08 besitzt Quelle, Rechte- und Policy-Status; K17 besitzt die Ausführung des gemeinsamen Ausgabetors. Beide Seiten pinnen kompatible Versionen. Fehlt eine Version oder ist die Kombination nicht freigegeben, wirkt die Übergabe fail-closed.

### Bedienbarkeit der Uebergabe und der durchgehende Probelauf bis zum abgerufenen Paket

**K05-M32** · MUSS — Aenderungen am Bildschirm werden auch fuer Hilfsmittel wie Vorlesegeraete angesagt, Tastaturbedienung und ein gleichwertiger Textweg sind Pflicht, und Speichern, Hochladen und Uebergeben zeigen jeweils klar an, ob es geklappt hat, gescheitert ist oder fortgesetzt werden kann.

> Dynamische Änderungen werden als Statusmeldung für Hilfstechnologien ausgegeben; Tastaturreihenfolge, Fehlerfokus und gleichwertiger Textweg sind Pflicht. Speichern, Upload und Übergabe besitzen eindeutige Erfolg-, Fehler- und Wiederaufnahmezustände.

**K23-M06** · MUSS — Der durchgehende Probelauf muss die ganze Kundenreise von der Einladung bis zum abgeholten Uebergabe-Paket am Stueck schaffen -- ohne Abkuerzung und ohne dass irgendwo ein Zwischenergebnis von Hand nachgeschoben wird.

> Der Durchstich MUSS die Kundenreise von der Einladung bis zum abgerufenen Übergabe-Paket durchlaufen, ohne Sprung und ohne nachgereichten Zwischenstand.

---

## Manifest

*... mit Manifest- und Archivpruefsumme* — BS:69 · **12 Regeln**

**Anmerkung:** Das Wort 'Manifest' bezeichnet im Register vier voellig verschiedene Dinge -- ein Manifest ist allgemein ein Inhaltsverzeichnis, das genau auflistet, woraus etwas besteht. Erstens das Manifest des Uebergabe-Pakets (K10-M20, K10-M27); die Zeile des Fadens 'mit Manifest- und Archivpruefsumme' spricht von diesem. Zweitens das Manifest eines Testlaufs (K23-M18, K23-M20, K23-D08, K23-D09). Drittens das Buildmanifest, ein technischer Bau-Nachweis (K07-M21). Viertens -- und am weitesten weg -- das Modellpfad-Manifest der KI-Agenten (K17-M27, K17-M28, K17-M29, K17-M30, K17-M33); diese fuenf Regeln handeln davon, welches Sprachmodell in welcher Region mit welcher Freigabeschwelle aufgerufen werden darf, und sind allein wegen des Wortes hier gelandet. Das ist ein Lesehinweis, keine Zuordnungsentscheidung.

### das Manifest des Uebergabe-Pakets und seine Pruefsummen

**K10-M20** · MUSS — Das Inhaltsverzeichnis des Uebergabe-Pakets nennt zu jeder einzelnen Datei Ablageort, Art, Groesse und einen Fingerabdruck, und zusaetzlich einen Fingerabdruck fuer das gesamte Paket; stimmt ein Fingerabdruck nicht oder zeigt ein Pfad aus dem Paket hinaus, wird der Abruf gesperrt. ('SHA-256' ist so ein Fingerabdruck: eine Zeichenfolge, die sich aendert, sobald sich am Inhalt auch nur ein Buchstabe aendert. K10 ist das Konzeptpapier 'Uebergabe-Paket'.)

> Das Manifest MUSS für jede Datei relativen Pfad, Dokumentart, Medienart, Byte-Größe und SHA-256 sowie für das Gesamtarchiv einen SHA-256 führen.

**K10-M27** · MUSS — Die Freigabe des Pakets haelt fest, wer es bearbeitet, wer es freigegeben hat, wann und mit welcher Entscheidung, und verweist dabei auf die beiden Fingerabdruecke; dieser Verweis ist heute nur freier Text, und nachtraegliche Aenderung oder ein unvollstaendiges Protokoll machen den Stand nicht uebergabefaehig. (K14 ist die Sicherheits-Grundlinie.)

> Die Freigabezeile MUSS Bearbeiter, Freigeber, Zeitpunkt und Entscheidung führen und über `approval.object_ref` auf Manifest- und Archivprüfsumme zeigen (K14 Abschn. 3).

### das Manifest eines Testlaufs

**K23-M18** · MUSS — Jeder Testlauf endet mit einem nicht mehr aenderbaren Protokollblatt, das lueckenlos festhaelt, was womit in welcher Fassung getestet wurde und mit welchem Ergebnis -- samt Fingerabdruecken aller Eingaben und Ergebnisse. (K23 ist das Test- und Abnahmekonzept.)

> Am Ende eines Laufs MUSS ein unveränderliches Manifest stehen. Es führt Laufkennung, Umgebung, Bau- und Schemafassung, Datensatzfassung, Modell-, Prompt-, Wissens-, Richtlinien- und Vorlagenstände, Testwerkzeuge, Beginn/Ende, Ergebnisse, Evidenzverweise sowie die Prüfsummen aller Eingaben und Ergebnisse.

**K23-M20** · MUSS — Bevor ein Bau einem Menschen zur Freigabe vorgelegt wird, muss ein bestandener Durchlauf vorliegen, der gegen genau den aktuellen Bauauftrag gelaufen ist -- nachgewiesen dadurch, dass der Fingerabdruck im Protokollblatt mit dem des vorgelegten Bauauftrags uebereinstimmt; sonst gilt der Durchlauf als veraltet.

> Vor jeder Vorlage eines Baus zur menschlichen Freigabe MUSS ein bestandener Durchstich vorliegen, der gegen den aktuellen Stand des Bauauftrags gelaufen ist.

### was nie in ein Manifest gelangen darf, und was mit verdorbenen Laeufen geschieht

**K23-D09** · DARF NICHT — Passwoerter, Zugangsschluessel und ungeschwaerzte Personendaten duerfen weder im Protokollblatt noch in Logdateien, Bildschirmfotos oder Fehlermeldungen auftauchen; wird so etwas gefunden, ist der Lauf gesperrt.

> Geheimnisse, Zugangswerte oder unmaskierte personenbezogene Angaben DÜRFEN NICHT in Manifest, Log, Screenshot oder Fehlerausgabe gelangen. Ein solcher Fund sperrt den Lauf.

**K23-D08** · DARF NICHT — Ist in einem Testlauf echtes Produktionsmaterial aufgetaucht, laesst er sich nicht nachtraeglich reparieren: er wird verworfen, sein Ergebnis gilt als nicht erhoben und er wird nach Saeuberung der Umgebung ganz wiederholt -- das Protokollblatt des verworfenen Laufs bleibt aber als Nachweis erhalten.

> Ein Lauf, in dem Produktionsdaten oder Produktionsgeheimnisse aufgetreten sind, DARF NICHT nachträglich geheilt werden.

### das Buildmanifest als technischer Freigabenachweis

**K07-M21** · MUSS — Zum Prototyp gehoeren technische Nachweise -- ein Bau-Inhaltsverzeichnis, ein wiederholbarer Export sowie Pruefungen auf Fremdbestandteile, Lizenzen, Schadsoftware und versehentlich mitgelieferte Passwoerter; der Vorschaucode selbst laeuft abgeschottet ohne Zugangswerte und ohne Verbindung nach aussen. ('SBOM' ist eine Stueckliste der verwendeten fremden Softwarebausteine. K07 ist das Papier 'Prototyp und Verfeinern'.)

> Buildmanifest, reproduzierbarer Export, SBOM-, Lizenz-, Malware- und Secret-Prüfung sind technische Freigabenachweise von K13/K14.

### das Modellpfad-Manifest der KI-Agenten -- gleiches Wort, anderer Gegenstand

**K17-M27** · MUSS — Eine einzige versionierte Liste legt verbindlich fest, welches Sprachmodell bei welchem Anbieter in welcher Region wofuer benutzt wird -- und ohne eine vollstaendige, freigegebene Fassung dieser Liste findet ueberhaupt kein Aufruf statt. (K17 ist das Papier ueber Betrieb und Verhalten der KI-Agenten.)

> Ein versioniertes Modellpfad-Manifest im Konfigurationsbestand ist die autoritative Quelle für Deployment, Anbieter, Region, Zweck, Datenminimum, Evaluationssatz, Freigabeschwelle und menschliche Eskalationsrolle.

**K17-M28** · MUSS — Was in der Datenbank ueber das benutzte Modell steht, ist nur ein Abbild dieser Liste und muss mit ihr uebereinstimmen; weicht es ab, sperren automatische Pruefungen -- und Passwoerter stehen weder in der Liste noch in ihrem Abbild.

> `model_ref` ist die Datenbankprojektion des Manifests. Token, Modell, Version und Hosting müssen übereinstimmen; Startup-, Drift- und Releaseprüfungen sperren bei Abweichung.

**K17-M29** · MUSS — Welche Rolle ein Agent hat, wird auf dem Server gegen die feste Liste der sechzehn zugelassenen Rollen geprueft; Anzeigewerte wie Verbrauch und Bewertung werden taeglich nachgefuehrt, gelten veraltet als veraltet und entscheiden keine Freigabe.

> `role_kind` wird serverseitig gegen die im Manifest versionierte Liste der sechzehn Agentenrollen geprüft.

**K17-M30** · MUSS — Fuer jeden Agenten muss in der Liste stehen, ab welchem Guetewert er freigegeben ist; dieser Wert wird eigens freigegeben und darf nicht pauschal erfunden werden.

> Freigabeschwellen sind je Agent im Manifest Pflichtwerte und werden mit K14 freigegeben. Es gibt keine universelle erfundene Quote.

**K17-M33** · MUSS — Bevor Nutzungsdaten mitgeschrieben werden, werden Personendaten und Passwoerter entfernt oder geschwaerzt; wer sie lesen darf und wie lange sie bleiben, steht in derselben Liste -- und bei sensiblen Inhalten ist das Mitschreiben von vornherein ausgeschaltet.

> Vor Telemetrie werden personenbezogene Daten und Secrets minimiert oder redigiert; Zugriff, Frist und geschützte Leserrolle sind im Manifest festgelegt.

---

## Pruefsumme

*... Manifest- und Archivpruefsumme* — BS:69 · **7 Regeln**

**Anmerkung:** Wortklaerung zuerst, weil hier alles davon abhaengt: Eine Pruefsumme ist ein kurzer Zahlen- und Buchstabenwert, der aus einer Datei berechnet wird — aendert sich auch nur ein Zeichen in der Datei, kommt ein voellig anderer Wert heraus. Damit laesst sich beweisen, dass etwas seit der Freigabe nicht veraendert wurde. Ein "Manifest" ist ein Beipackzettel: eine Datei, die auflistet, was in einem Paket oder Lauf steckt, mitsamt den Pruefsummen der einzelnen Teile. Hinweis fuer den Leser, keine Entscheidung: die sieben Regeln reden von SECHS verschiedenen Pruefsummen an sechs verschiedenen Gegenstaenden — am Uebergabe-Paket und seinem Archiv (K10-M27), am Manifest eines Testlaufs (K23-M18), am Bauauftrag (K23-M20), an den Anforderungskonzepten (K06-M27), am Elementkatalog des Prototyp-Erzeugers (K25-M05) und an der fortlaufenden Kette der Protokolleintraege (K02-G09, K11-G13). In K06-M27 und K25-M05 ist die Pruefsumme nur eine Eigenschaft unter mehreren; der eigentliche Gegenstand dieser beiden Regeln ist ein anderer. Der Faden nennt namentlich die Manifest- und die Archivpruefsumme.

### die Pruefsumme am Uebergabe-Paket und ihre Verbindung zur Freigabe

**K10-M27** · MUSS — Zu jeder Freigabe muss festgehalten sein, wer bearbeitet, wer freigegeben hat, wann das war und wie entschieden wurde, und dieser Eintrag muss auf die Pruefsummen des Beipackzettels und des Archivs verweisen; die Regel gibt ausdruecklich zu, dass diese Verbindung derzeit nur als freier Text besteht und nicht von der Datenbank erzwungen wird, und haelt fest, dass nachtraegliche Aenderungen, ein zweiter Stand daneben oder ein lueckenhaftes Protokoll das Paket nicht uebergabefaehig machen.

> Die Freigabezeile MUSS Bearbeiter, Freigeber, Zeitpunkt und Entscheidung führen und über `approval.object_ref` auf Manifest- und Archivprüfsumme zeigen (K14 Abschn. 3). […] Nachträgliche Änderung, paralleler Ersatz oder unvollständiges Protokoll macht den Stand nicht übergabefähig.

### das unveraenderliche Manifest eines Laufs und die Pruefung, ob der Lauf noch aktuell ist

**K23-M18** · MUSS — Jeder Testlauf endet mit einem Beipackzettel, der nicht mehr geaendert werden darf und lueckenlos festhaelt, was mit welchen Staenden und Werkzeugen geprueft wurde, wann es lief, was herauskam — und die Pruefsummen von allem, was hineinging und herauskam.

> Am Ende eines Laufs MUSS ein unveränderliches Manifest stehen. Es führt Laufkennung, Umgebung, Bau- und Schemafassung, Datensatzfassung, Modell-, Prompt-, Wissens-, Richtlinien- und Vorlagenstände, Testwerkzeuge, Beginn/Ende, Ergebnisse, Evidenzverweise sowie die Prüfsummen aller Eingaben und Ergebnisse. […]

**K23-M20** · MUSS — Bevor einem Menschen etwas zur Freigabe vorgelegt wird, muss ein bestandener Testlauf vorliegen, der gegen genau denselben Bauauftrag gelaufen ist, der jetzt vorgelegt wird — bewiesen dadurch, dass die Pruefsumme im Beipackzettel mit der des vorgelegten Auftrags uebereinstimmt; stimmen sie nicht ueberein, gilt der Testlauf als veraltet.

> Vor jeder Vorlage eines Baus zur menschlichen Freigabe MUSS ein bestandener Durchstich vorliegen, der gegen den aktuellen Stand des Bauauftrags gelaufen ist. *Aktuell* heißt: die im Manifest nach K23-M18 geführte Prüfsumme des Bauauftrags stimmt mit der des vorgelegten überein. […]

### die Pruefsumme als Merkmal des verbindlichen Dokumentenstands

**K06-M27** · MUSS — Die sechs Anforderungskonzepte werden nicht in einer eigenen Tabelle gefuehrt, sondern als versionierte Dokumente, und was als der eine massgebliche Stand gilt, ergibt sich aus ihrem Inhalt samt Kennungen, Reihenfolge, Herkunft und Pruefsumme.

> Die sechs Konzepte und Familie 2 werden als versionierte Dokumente von K10 geführt. Ihr strukturierter Inhalt, Kennungen, Reihenfolge, Herkunft und Prüfsumme bilden den kanonischen Artefaktstand; eine neue K06-Tabelle entsteht nicht.

### die Pruefsumme als Merkmal der erlaubten Bausteinliste beim Prototyp-Erzeuger

**K25-M05** · MUSS — Welche Bausteine ein Prototyp enthalten darf, steht in einer abschliessenden Erlaubnisliste ("Positivliste": nur was darauf steht, ist erlaubt), die auf dem Server erzwungen wird, aus den freigegebenen Vorlagen entsteht, eine Pruefsumme traegt und vom Sprachmodell niemals selbst erweitert werden darf — laesst sie sich nicht eindeutig erzeugen, entsteht ueberhaupt kein Prototyp.

> Der Elementkatalog MUSS im Serverpfad als versionierte, maschinenlesbare Positivliste durchgesetzt werden. Sie wird aus Abschnitt 5 und den geltenden, freigegebenen Vorlagenständen erzeugt, trägt eine Prüfsumme und wird nie vom Modell erweitert. […]

### die fortlaufende Pruefsummen-Kette liegt im internen Nachweis, nicht in der Ansicht

**K02-G09** · GILT — Die Protokolleintraege sind so verkettet, dass jeder Eintrag den vorhergehenden mit absichert — wer einen alten Eintrag aendert, zerstoert die Kette; diese Kette liegt aber im internen Nachweisspeicher und nicht in der Ansicht, die hier beschrieben wird.

> Es GILT: Die Prüfsummen-Kette, bei der jede Prüfsumme den vorhergehenden Eintrag mitsichert, liegt im internen Nachweis und nicht in dieser Sicht.

**K11-G13** · GILT — Dieselbe Feststellung aus Sicht des Betriebs-Portals: was der Betreiber dort am Bildschirm sieht, ist nur eine Lesefläche; der eigentliche verkettete Nachweis liegt woanders.

> Es GILT: Die Prüfsummenkette liegt im internen Nachweisspeicher, nicht in der Protokollsicht. Die Sicht ist eine Lesefläche.

