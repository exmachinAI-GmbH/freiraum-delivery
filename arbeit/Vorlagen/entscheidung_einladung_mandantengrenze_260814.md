# Entscheidungsvorlage · Einladung über die Unternehmensgrenze

| | |
|---|---|
| **Datum** | 14.08.2026 |
| **Vorgelegt von** | Bau (Coding-Harness), auf Grundlage zweier gegensätzlicher Rechtsauslegungen |
| **Entscheiden** | M. Veil · A. Han |
| **Betrifft** | `app/einladung_senden.py` · Bildschirme EX-05, EX-06, EX-10 · Klauseln K03-M19, K03-M23, K01-M15, K02-G06, K20-G11 |
| **Status ohne Entscheidung** | Zwei von drei gezeichneten Einladungsbildschirmen sind nicht ausführbar; der zugehörige Negativfall ist nach K23-M22 **gesperrt**, nicht bestanden |

---

## 1 · Worum entschieden wird

Darf eine Mitarbeiterin von exmachinAI aus ihrem eigenen Zugang heraus eine Person eines **Kundenunternehmens** zur Anlage einladen — oder darf eine Einladung nur an Personen des **eigenen** Unternehmens gehen?

---

## 2 · Der Sachverhalt

### 2.1 Die Begriffe, die man dafür braucht

**Mandant** heißt in dieser Anlage: ein Unternehmen mit eigenem, abgetrenntem Datenbestand. exmachinAI selbst ist einer davon — angelegt in `install/01_betreiber_und_erstadmin.sql:71-82` mit der Art `OPERATOR` (Betreiber), dem Namen „exmachinAI GmbH", der Einladungsschranke `exmachinai.com` und der Frist 24 Stunden. Jeder Kunde ist ein weiterer Mandant mit der Art `CUSTOMER`.

**Einladungsschranke** (im Datenmodell `invite_domain`) heißt: die Liste der E-Mail-Endungen, an die überhaupt eingeladen werden darf. Beim Betreiber steht dort `exmachinai.com` — an eine Adresse `@demobank.de` kann aus diesem Mandanten heraus nichts versandt werden.

**Zielmandant** heißt: das Unternehmen, zu dem die eingeladene Person gehören soll.

**Serverbefehl** heißt: die eine Stelle im Programm, die eine Bildschirmaktion tatsächlich ausführt. Für das Einladen heißt sie `send_invitation`.

### 2.2 Was der Vertrag sagt — im Wortlaut

Alle Zitate aus `nachweise/klauselregister/register.json`, Zeile in Klammern.

**K03-M19** (MUSS, Register Z. 3256-3259; Herkunft K03 Anmeldung v1.3:279):
> *(berichtigt nach Beschluss S28 vom 02.08.2026)* Geprüft wird die Einladungsschranke des Mandanten, zu dem das **eingeladene Konto** gehört — nicht die des einladenden. **Bei einer Einladung über die Mandantengrenze hinweg gilt damit die Schranke des Ziels.** Ein erneuter Einmal-Link entwertet frühere Links.

**K03-M23** (MUSS, Z. 3316; K03:298):
> Vor der ersten Einladung MUSS für den **Zielmandanten** eine explizite Entscheidung „Domäne beschränken" oder „bewusst unbeschränkt" vorliegen. Der Nachweis führt Zielmandant, Entscheider, Zeitpunkt und Begründung.

**K01-M15** (MUSS, Z. 1351; K01 Rahmenkonzept v1.3:65):
> Jeder Lese- und Schreibzugriff MUSS auf den Mandanten der angemeldeten Sitzung eingeschränkt sein. **Ein Objekt eines fremden Mandanten gilt als nicht vorhanden** (Mandantenschnitt K02).

**K02-G06** (GILT, Z. 1996; K02 Fundament v1.3:92):
> Es GILT: Einladungsfrist und Einladungsschranke stehen am Mandanten, weil sie Eigenschaften der **einladenden** Organisation sind.

**K02-M21** (MUSS, Z. 2476; K02:64):
> Bei einem mandantengebundenen Schreibvorgang MUSS `event.tenant_id` gesetzt sein und mit Mandant der Sitzung, des Fachobjekts und der Projektnummer übereinstimmen. […] **Eine benannte Ausnahme gilt für den Betreiber:** Trägt die Mitgliedschaft der Sitzung den Geltungsbereich Betreiber, tritt an die Stelle der Gleichheit die Prüfung, dass Fachobjekt und Protokolleintrag denselben Kundenmandanten führen. Der Vorgang wird zusätzlich als Betreiberzugriff protokolliert.

**K20-G11** (GILT, Z. 15961; K20:94):
> Es GILT: Die Reichweite des Plattform-Admins ist der Betreiber-Mandant […] **Dieser Geltungsbereich bedeutet ausdrücklich „Plattform, alle Mandanten"** […] Der Betreiber arbeitet damit an Kundenobjekten, ohne je Kunde eine eigene Mitgliedschaft zu brauchen.

**K03-M21** (MUSS, Z. 3286; K03:281):
> Replay, Brute Force, Konto-Ermittlung, Sitzungsfixierung, parallele Anmeldung, **fremder Mandant** und Provider-Ausfall MÜSSEN vor Produktion als **Negativtests** bestanden sein.

**Wichtig zur Einordnung:** *MUSS* ist eine Pflichtklausel, *GILT* eine Festlegung ohne eigenen Prüfauftrag. K03-M19 trägt den Zusatz „Freigegeben **mit Auflagen**"; K01-M15 trägt „Freigegeben · **menschliche Freigabeentscheidung offen**".

### 2.3 Was die gezeichneten Bildschirme sagen

Die einzige pflegbare Bildschirmquelle ist `schema/K19_screens.yaml`. Der Befehl `send_invitation` kommt dort **dreimal** vor — gezählt, nicht geschätzt: Zeile 746, 775 und 882.

- **EX-05** (Kundendialog), `schema/K19_screens.yaml:746-747` — Berechtigung im Wortlaut: *„serverseitiger, idempotenter Einladungsbefehl (K03-M25): **Zielmandant**, Entscheidungsnachweis zur Einladungsschranke (K03-M23) und exakter Vergleich mit `tenant.invite_domain`"*.
- **EX-06** (Maske „Neuen Kunden anlegen"), `:775-776` — derselbe Befehl, ebenfalls mit dem Wort **Zielmandant**. Fehlerzustand `:780`: *„wird das Fenster vorher geschlossen, besteht eine Einladung ohne Kunden"*.
- **EX-10** (EXMA-Nutzerverwaltung), `:882` — *„Rolle fest auf Plattform-Admin"*, also eine Einladung ins eigene Haus.

### 2.4 Was das Datenmodell sagt

- Die Einladungstabelle `invitation` (`schema/freiraum_datamodel.sql:199-213`) führt **keine** eigene Mandantenspalte. Ihr Mandant entsteht nur mittelbar über das eingeladene Konto (`actor_id` → `actor.tenant_id`); so liest ihn auch die Sicht `invitation_offen` (`:861-864`).
- Der Wächter `invitation_guard()` (`:653-668`) holt Schranke und Frist über das **eingeladene** Konto: `FROM actor a JOIN tenant t ON t.id = a.tenant_id WHERE a.id = NEW.actor_id` (`:656-658`). Der einladende Mandant kommt darin nicht vor.
- Die E-Mail-Adresse ist **plattformweit** einmalig: `email text NOT NULL UNIQUE` (`:152`) — eine Adresse kann also in der ganzen Anlage nur einem einzigen Mandanten gehören.
- Die Sicht `platform_admin` (`:850-856`) verbindet die Person über `membership.tenant_scope` — die Reichweite steht also an der Mitgliedschaft, nicht an der Person. Der Kommentar darüber (`:847-849`) sagt das ausdrücklich.
- Die Nachweisliste `invitation_decision` (`migrations/M30__pilot_sammelmigration.sql:321-331`) führt **genau einen** Mandanten, Pflichtfeld — und wird von der Anwendung **nirgends** gelesen oder geschrieben (Suche über `app/`: null Treffer außer einem Kommentar in `app/vorlagen/einladung_senden.html:19`).

### 2.5 Was der Bau tut — und seit wann

**Bis 13.08.2026:** Der Einladungsbefehl suchte die eingegebene Adresse **über alle Mandanten hinweg** und zeigte bei einem fremden Treffer eine eigene Meldung („Konto bei einem anderen Mandanten"). Die Fremdprüfung hat das am 14.08.2026 als Befund F1 gemeldet (`arbeit/Bauberichte/tor3_probelauf_260814.md:85`): *„Eine angemeldete Person kann E-Mail-Adressen durchprobieren und erfährt, welche davon bei einem anderen Mandanten registriert sind."*

**Seit 14.08.2026:** Die Abfrage sucht nur noch im Mandanten der angemeldeten Sitzung — `app/einladung_senden.py:395-398`:
> `"SELECT id FROM actor WHERE lower(email) = %s AND tenant_id = %s ORDER BY id FOR UPDATE", (adresse, einladender["mandant"])`

Ein neues Konto wird ebenfalls im Sitzungsmandanten angelegt (`:415-417`), und der Protokolleintrag trägt den Mandanten der Sitzung (`:301-305`). Der Wert `einladender["mandant"]` stammt aus `app/sitzung.py:110` und `:165-166` und ist `actor.tenant_id` der angemeldeten Person — **nicht** `membership.tenant_scope`.

**Folge heute:** Wird eine Adresse eines anderen Mandanten eingegeben, findet der Befehl nichts, versucht ein neues Konto anzulegen, und die plattformweite Einmaligkeit der Adresse (`schema/freiraum_datamodel.sql:152`) weist das ab. Es entsteht weder Einladung noch Sitzung. Die angezeigte Meldung ist allerdings die für „zeitgleich eine andere Einladung" (`app/einladung_senden.py:180`) — sie trifft den Fall nicht.

**Was bereits gemessen wird:** Der Prüffall **VE-09** existiert seit heute (`pruefungen/klauseln/versand_lauf.sh:476-529`, Prüfdaten mit einem zweiten, erfundenen Mandanten in `pruefungen/klauseln/versand_daten.sql:206` und `:216`). Er vergleicht die Antwort auf eine Adresse aus einem fremden Mandanten mit der Antwort auf eine nirgends existierende Adresse: Statuscode, Weiterleitungsziel, Wortlaut und Zeilenentstehung müssen ununterscheidbar sein. Damit ist das Auskunftsleck gemessen. **Nicht** gemessen ist, ob die Abweisung an ihrer eigenen Bedingung scheitert.

**Was nicht vorliegt:** Der Text von **Beschluss S28 vom 02.08.2026** liegt in diesem Repository nicht. Eine Suche über alle Dateien liefert genau eine Fundstelle — den Verweis im Register selbst (`register.json:3259`). Was S28 entscheiden wollte, ist damit **unbelegt**.

---

## 3 · Die zwei Lesarten

### Lesart A · Der Vertrag **verlangt** die Einladung über die Grenze

**These.** Der erste Mensch eines Kundenunternehmens kann sich nicht selbst einladen — er hat noch keinen Zugang. Also muss ihn jemand von exmachinAI einladen. Genau dafür trägt K03-M19 seinen Satz über die Schranke des Ziels, verlangt K03-M23 den Nachweis für den Zielmandanten, und definiert K20-G11 die Reichweite des Plattform-Admins als „Plattform, alle Mandanten". Der Bau hat die richtige Sache behoben, aber das falsche Stück amputiert: Das Auskunftsleck kam aus dem **Suchen** über alle Mandanten, nicht aus dem **Einladen** über die Grenze.

**Stärkste Belege.**

1. **Zwei von drei gezeichneten Bildschirmen sind unausführbar geworden.** `schema/K19_screens.yaml:747` und `:776` nennen für EX-05 und EX-06 den Zielmandanten im Wortlaut der Berechtigung. Beide sind EXMA-Masken. EX-06 geht weiter: Fehlerzustand `:780` — *„wird das Fenster vorher geschlossen, besteht eine Einladung ohne Kunden"*. Ein Befehl, der das Ziel aus der Sitzung ableitet, kann diesen Zustand nicht einmal beschreiben.
2. **Der Wächter im gezeichneten Datenmodell prüft ausdrücklich gegen das Ziel.** `schema/freiraum_datamodel.sql:656-658` löst Schranke und Frist über `actor.tenant_id` des **eingeladenen** Kontos auf. Diese Bauform unterscheidet sich von einer Prüfung gegen den Einladenden nur dann, wenn beide auseinanderfallen **können**.
3. **Der heutige Stand kann nur noch `@exmachinai.com` einladen.** Da das Konto stets im Sitzungsmandanten entsteht (`app/einladung_senden.py:415-417`) und der Betreiber-Mandant die Schranke `exmachinai.com` trägt (`install/01_betreiber_und_erstadmin.sql:72,78`), schlägt jede Kundeneinladung fehl. Das ist EX-10 — und nichts sonst.

**Schwächste Stelle.** K01-M15 ist ein MUSS des Rahmenkonzepts und kennt in seinem eigenen Wortlaut **keine** Ausnahme. Die Rettung — für den Plattform-Admin sei „der Mandant der Sitzung" die ganze Plattform — steht und fällt mit K20-G11, und das ist ein *GILT*, keine Pflichtklausel; das Register weist seine Herkunft als Ableitung aus dem v2.9-Build aus, den `CLAUDE.md` Abschnitt 1 als Codevorlage ausdrücklich verbietet. Zweitens gibt es im Datenmodell **keine** Spalte, die einen Zielmandanten an der Einladung führt (`schema/freiraum_datamodel.sql:199-213`). Der Zielmandant ist nur mittelbar da. Für ihn als eigenständige Größe gibt es Klauseln und Bildschirme, aber **keinen Schemabeleg**.

---

### Lesart B · Der Vertrag **verbietet** sie — der Bau ist richtig

**These.** Eine Einladung an eine fremde Adresse setzt zwingend voraus, dass der Server die fremde Kontozeile **findet**. Genau dieser Lesezugriff ist untersagt, und die Zeile gilt als nicht vorhanden. K03-M19 ist keine Erlaubnis, sondern eine Kollisionsregel: Sie sagt nur, **welche** Schranke gelesen wird, wenn Sitzungsmandant und Zielmandant auseinanderfallen — und das ist der Betreiberfall (Sitzung bei EXMA, Objekt beim Kunden), nicht die Einladung eines Kontos eines **dritten** Unternehmens.

**Stärkste Belege.**

1. **Der Fall ist im Datenmodell nicht darstellbar.** `invitation` (`schema/freiraum_datamodel.sql:199-213`) führt keine Mandantenspalte; sie hält genau einen Mandanten, abgeleitet über das Konto. Wo der Vertrag zwei Bezüge will, stehen sie auch da (`approval` mit `editor_actor_id` **und** `approver_actor_id`, `:549-550`).
2. **Derselbe Verfasser führt „fremder Mandant" 21 Zeilen vorher als Negativtest.** K03-M21 (K03:281) listet ihn zwischen Replay, Brute Force und Provider-Ausfall — ausnahmslos Angriffe oder Ausfälle — und nennt die Liste ausdrücklich **Negativtests**.
3. **Zwei freigegebene Klauseln sind nur unter dieser Lesart widerspruchsfrei.** K02-G06 verortet die Schranke bei der **einladenden** Organisation, K03-M19 beim Mandanten des **eingeladenen** Kontos. Beide gelten. Widerspruchsfrei sind sie nur, wenn beide dieselbe sind.

**Schwächste Stelle.** Der Wortlaut von K03-M19 selbst: *„Bei einer Einladung über die Mandantengrenze hinweg gilt damit die Schranke des Ziels."* Das ist eine Regel für einen als möglich unterstellten Fall. Wer ihn verbieten will, schreibt keine Regel dafür — er schreibt ihn ins Verbot. Und der Satz wurde am 02.08.2026 durch Beschluss S28 **eigens berichtigt**: Jemand hat genau diese Konstellation angesehen und für regelungsbedürftig gehalten. Der Beschlusstext liegt nicht vor (siehe 2.5) — die Umdeutung auf den Betreiberfall ist damit eine Rekonstruktion, **unbelegt**.

Zweitens, und das ist der Punkt gegen den **Bau**, nicht gegen die These: Der Bau *entscheidet* die Frage nicht, er umgeht sie. Die Grenze hält heute durch die Einmaligkeit der Adresse, nicht durch eine Prüfung. `CLAUDE.md` Abschnitt 6 verbietet ausdrücklich, „einen Negativfall als bestanden [zu] führen, der an einer fremden Bedingung scheitert". Das Ergebnis stimmt, der Beweis dafür fehlt.

---

## 4 · Was jede Entscheidung kostet

Alle Zeitangaben sind **Schätzungen des Baus in halben Tagen**, nicht gemessen. Ein halber Tag = 4 Stunden Bauzeit einschließlich Prüffall.

### Weg A · Die Grenze wird geöffnet (Zielmandant als ausdrückliches Argument)

| Was | Halbe Tage |
|---|---|
| Zielmandant wird Pflichtargument von `send_invitation`; Konto und Ereignis entstehen im **Ziel**, nicht in der Sitzung (`app/einladung_senden.py:301-305, :395-398, :415-417`) | 2 |
| Berechtigung hängt an `membership.tenant_scope` statt an `actor.tenant_id`; Regel: Ziel = Reichweite **oder** Reichweite ist Betreiber (`app/sitzung.py:110, :165-166`) | 2 |
| Betreiberzugriff zusätzlich protokollieren, wie K02-M21 es verlangt | 1 |
| Entscheidungsnachweis `invitation_decision` vor dem Versand prüfen (K03-M23) | 2 |
| Domänenvergleich auf `tenant_invite_domain` umstellen: trimmen, kleinschreiben, internationale Schreibweise, exakter Vergleich (heute nur `LIKE '%@' || d`, `schema/freiraum_datamodel.sql:659`) | 2 |
| Prüffälle: fremder Zielmandant abgewiesen · Betreiber lädt Kunden ein, Erfolg · fehlender Nachweis · Subdomäne · Groß-/Kleinschreibung (K03-M27) | 3 |
| **Zwischensumme** | **12** |

**Nicht schätzbar, aber fällig:**

- **Migrationsnachtrag zur Einmaligkeit der Adresse.** `actor.email` ist plattformweit einmalig (`:152`). Wenn eine Person in zwei Unternehmen vorkommen darf, ist das eine Änderung am **gezeichneten** Datenmodell mit neuer Prüfsumme (`schema/freiraum_datamodel.sha256`) — der Bauaufwand ist klein, der Zeichnungsvorgang ist keine Bauzeit.
- **Zeilenschutz in der Datenbank (RLS).** K02-M20 verlangt die Grenze **zweifach** — im Programmweg und im Datenbestand. Heute liefert `sitzungs_mandant()` NULL, weil der Serverweg den Wert nicht setzt, und die Durchsetzung ist im Pilot ausgeschaltet (`migrations/M30__pilot_sammelmigration.sql:2171-2195`). Eine schreibende Handlung über die Grenze zu öffnen, **bevor** diese zweite Schranke steht, legt die einzige verbleibende Grenze in Anwendungscode. Der Umfang hängt am offenen Punkt O-K13-1 und am Echtdaten-Tor E2.
- **Dauerhaftes Fehlerrisiko:** Jeder Aufrufer muss künftig den Zielmandanten mitführen. Ein vergessenes Argument wird zu einer Einladung in das falsche Unternehmen — ein Fehler, den der heutige Stand baulich **nicht machen kann**.

### Weg B · Die Grenze bleibt zu (der heutige Stand wird bestätigt)

| Was | Halbe Tage |
|---|---|
| Eigene Bedingung und eigene Meldung für „fremder Zielmandant", damit der Fall an **seiner** Bedingung scheitert und nicht an der Einmaligkeit der Adresse | 2 |
| Die Abweisung so bauen, dass sie **nicht** davon abhängt, ob das fremde Konto existiert (sonst ersetzt sie ein Auskunftsleck durch ein anderes, K03-M25) | 1 |
| Widerspruch K03-M19 gegen K02-G06 als Projektbefund verfassen und in die Restrisikoliste eintragen | 1 |
| **Zwischensumme** | **4** |

**Nicht schätzbar, und das ist der eigentliche Preis:**

- **Wie bekommt der erste Mensch eines Kundenunternehmens Zugang?** Unter Weg B gibt es dafür kein Verfahren. EX-05 und EX-06 bleiben nicht ausführbar; ihr Serverbefehl kann sie nicht bedienen. Entweder werden die beiden Bildschirme neu geschnitten (Änderung an `schema/K19_screens.yaml`, das nach K19-M01 die einzige pflegbare Quelle ist — Sache der Konzept-Fabrik, nicht des Baus), oder es wird ein anderer Weg gezeichnet. Beides ist Umfang, den der Bau nach `CLAUDE.md` Abschnitt 6 nicht selbst festlegen darf.
- **Ein fachlicher Fall fällt dauerhaft weg:** der externe Berater, der bereits ein Konto führt und im Kundenportal mitarbeiten soll. Wegen der plattformweiten Einmaligkeit der Adresse geht das auch nicht über ein zweites Konto. Der Vertrag kennt den Fall — `migrations/M30__pilot_sammelmigration.sql:1810-1812` begründet die Domänentabelle ausdrücklich mit *„ein Kunde mit mehreren Marken oder externen Beratern"*. Weg B löst ihn über Domänen, nicht über Unternehmen.

---

## 5 · Was in beiden Fällen gilt

Diese sechs Punkte sind von der Entscheidung **unabhängig** und in beiden Wegen zu erledigen:

1. **Heute entsteht in keiner Lesart eine Einladung an eine fremde Adresse.** Gemessen durch VE-09 (`pruefungen/klauseln/versand_lauf.sh:476-529`). Der Streit geht um die Begründung und die Meldung, nicht um das Ergebnis. Es besteht **keine Eile aus Sicherheitsgründen**.
2. **Der Entscheidungsnachweis nach K03-M23 wird nicht durchgesetzt.** Die Tabelle `invitation_decision` besteht seit dem 04.08.2026 (`migrations/M30__pilot_sammelmigration.sql:321-331`), wird von der Anwendung aber weder gelesen noch geschrieben. Solange das so ist, ist K03-M23 unerfüllt — in beiden Lesarten. Geschätzt 2 halbe Tage.
3. **Der Domänenvergleich ist unvollständig.** `LIKE '%@' || d` (`schema/freiraum_datamodel.sql:659`) erfüllt weder die internationale Schreibweise noch den Ausschluss abweichender Unterdomänen, beides von K03-M27 verlangt. Geschätzt 2 halbe Tage.
4. **Die Einmaligkeit der Adresse ist eine schwere fachliche Festlegung ohne Klausel.** `actor.email … UNIQUE` (`:152`) heißt: eine Person gehört dauerhaft genau einem Unternehmen. Das steht in keinem der 24 gezeichneten Konzepte. Zusätzlich fehlt der Abgleich der Schreibweise: die Datenbank prüft zeichengenau, die Anwendung sucht schreibweisenegal. Beides gehört in einen Migrationsnachtrag mit neuer Zeichnung.
5. **Der Text von Beschluss S28 ist zu beschaffen.** Er liegt in diesem Repository nicht vor. Beide Lesarten stützen sich auf eine Vermutung darüber, was er entscheiden wollte. Ein Blick in den Beschluss kann diese Vorlage möglicherweise erübrigen.
6. **Der Widerspruch K03-M19 gegen K02-G06 bleibt bestehen.** S28 hat K03-M19 berichtigt; K02 v1.3:92 sagt unverändert, Schranke und Frist seien Eigenschaften der **einladenden** Organisation. Eine der beiden Fassungen ist nachzuziehen — das ist Sache der Founder, nicht des Baus.

---

## 6 · Empfehlung

**Vorschlag: Lesart A, aber gestuft — Entscheidung jetzt, Bau erst nach dem Zeilenschutz.**

Begründung in drei Punkten:

1. **Lesart B hat kein Verfahren für den ersten Zugang eines Kunden.** Das ist keine Feinheit, sondern die Aufschaltung selbst. Solange sie nicht gezeichnet ist, sind zwei der drei Einladungsbildschirme (EX-05, EX-06) tote Zeichnungen. Lesart A hat dieses Loch nicht.
2. **Der Zusatz „Bei einer Einladung über die Mandantengrenze hinweg" in K03-M19 wurde eigens berichtigt.** Ein Vertrag, der diesen Fall verbieten will, schreibt keine Regel für ihn. Das ist das stärkste einzelne Textargument im ganzen Streit, und es steht auf der Seite von A.
3. **Die Gegengründe aus Lesart B sind fast ausschließlich Bau-Gründe, keine Vertrags-Gründe** — kein Zeilenschutz, keine Zielmandantenspalte, Einmaligkeit der Adresse. Bau-Gründe rechtfertigen eine **Reihenfolge**, nicht eine Auslegung.

**Konkret vorgeschlagene Reihenfolge:**

| Schritt | Wann |
|---|---|
| Die vier gemeinsamen Punkte aus Abschnitt 5 (Nr. 2, 3, 4, 5) erledigen | sofort, geschätzt 4 halbe Tage plus Beschaffung von S28 |
| Zeilenschutz in der Datenbank einschalten (O-K13-1, Echtdaten-Tor E2) | vor dem ersten Kunden mit echten Daten |
| Zielmandant als Argument, Betreiberausnahme, Betreiberprotokoll (Weg A, 12 halbe Tage) | **erst danach** |
| Bis dahin bleibt der heutige Stand unverändert und wird als **gesperrt**, nicht als bestanden geführt (K23-M22) | ab Zeichnung dieser Vorlage |

Der heutige Stand ist die vorsichtigere Variante: Es entsteht nichts, wo etwas nicht entstehen soll. Als **Zwischenzustand** ist er richtig. Als **Endzustand** lässt er zwei gezeichnete Bildschirme unbedienbar.

**Diese Empfehlung ist ein Vorschlag des Baus. Sie ist keine Entscheidung und wird nicht umgesetzt, bevor unten gezeichnet ist.**

---

## 7 · Zeichnung

Bitte genau ein Kreuz setzen. Ohne Zeichnung bleibt der Punkt offen und der zugehörige Prüffall gesperrt.

**Lesart A** — Die Einladung über die Unternehmensgrenze ist vertraglich verlangt. Der Zielmandant wird ausdrückliches Argument des Einladungsbefehls; der Bau setzt Weg A um.

☐ &nbsp;&nbsp; M. Veil &nbsp;&nbsp;&nbsp; ☐ &nbsp;&nbsp; A. Han

**Lesart B** — Die Einladung bleibt auf das eigene Unternehmen beschränkt. Der heutige Stand wird bestätigt; der Negativfall bekommt eine eigene Bedingung, und der Weg zum ersten Zugang eines Kunden wird gesondert gezeichnet.

☐ &nbsp;&nbsp; M. Veil &nbsp;&nbsp;&nbsp; ☐ &nbsp;&nbsp; A. Han

**Entscheidung vertagt bis** ⟨Datum: \_\_\_\_\_\_\_\_\_\_\_⟩ — bis dahin bleibt der heutige Stand unverändert, und der Punkt wird in `nachweise/restrisiken/restrisiken.md` mit Träger geführt.

☐ &nbsp;&nbsp; M. Veil &nbsp;&nbsp;&nbsp; ☐ &nbsp;&nbsp; A. Han

| | M. Veil | A. Han |
|---|---|---|
| Unterschrift | ____________________ | ____________________ |
| Ort, Datum | ____________________ | ____________________ |