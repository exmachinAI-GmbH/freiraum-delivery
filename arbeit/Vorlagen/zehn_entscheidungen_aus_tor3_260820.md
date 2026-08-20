# Elf Entscheidungen — **zur Zeichnung**

*Zehn aus dem Fremdurteil, eine (E-11) aus `BEF-ZB-1`, aufgenommen am 20.08.2026.*

**20.08.2026 · ⟨VORSCHLAG · NICHT GEZEICHNET⟩ · elf Tage bis zum 31.08.2026**

Tor 3 hat am 20.08.2026 „trägt nicht" geurteilt und zwölf Gründe genannt. Nachgerechnet:
**kein einziger widerlegt** — acht bestätigt, vier teilweise. Zwei davon sind Bauaufgaben und
**heute erledigt**. Die übrigen **zehn sind keine Bauaufgaben.** Sie brauchen je einen Satz
von einem Menschen.

> **Das ist der Befund hinter dem Befund.** Der fremde Blick hat kaum Fehler im Code
> gefunden. Er hat zehn Stellen gefunden, an denen **niemand entschieden hat** — Auslegungen,
> Geltungsbereiche, Träger, Fristen. Der Bau hat sie im Quelltext benannt und ist
> weitergegangen; ein Dritter, der nur die Klauseln kennt, liest sie als Verstoß. **Beide
> haben recht.** Genau dafür gibt es die vierte Messstufe.

## Wie die Empfehlungen zu lesen sind

| Etikett | Bedeutung |
|---|---|
| **ABGELEITET** | Der Wert folgt aus etwas Gezeichnetem. Keine Wahl |
| **VORSCHLAG** | Begründet, aber gewählt |
| **KEINE EMPFEHLUNG** | Der Harness darf hier nicht raten — es ist ausdrücklich untersagt |

**Sechs der zehn tragen den 31.08.** Sie stehen zuerst.

---

# Teil 1 · Die sechs, die den 31.08. tragen

## E-1 · Die Mandantengrenze im Teilschnitt *(Grund 8 · bestätigt)*

**Die Frage:** Wird der Teilschnitt mit **ungeschützter Mandantengrenze** abgenommen — oder
wird die Serverpfad-Hälfte vorher gebaut?

**Gemessen:** `mandantenvorgang()` wird im Teilschnitt von **keinem** Weg betreten; 22 Stellen
ohne Mandantenbedingung sind einzeln benannt. **RR-04 ist am 19.08. gezeichnet — er deckt
1 von 22.** Für die übrigen 21 gibt es heute **keinen getragenen Eintrag.** RR-04 trägt
zudem die Zusage *„jeder Serverbefehl setzt `freiraum.tenant_id`"*, die im Teilschnitt
nirgends eingelöst ist.

| | Weg | Folge |
|---|---|---|
| **a** | **RR-04 auf den Teilschnitt erweitern** — Umfang auf die acht Tabellen ausdehnen, mit Träger und Frist | Der 31.08. ist haltbar, **mit einem offenen, benannten Risiko statt einer stillen Lücke.** Preis: RR-04 führt selbst *„kritisch — mandantenkritisch"*, und nach K23-M04 ersetzt in dieser Klasse **eine Annahmeentscheidung den Test nicht**. Wer a wählt, nimmt eine Abnahme mit einem kritischen, ungetesteten Punkt ab |
| **b** | **Vorher bauen** — die ~14 Aufrufstellen im Teilschnitt umstellen | Die Lücke ist zu. Preis: Wer baut, bis wann — und die Zeilenregeln für die acht Tabellen folgen danach |

> **Empfehlung: a, mit Frist auf b.** *(VORSCHLAG)* — Elf Tage reichen für b nicht sicher,
> und ein halb umgestellter Serverpfad ist gefährlicher als ein ganz unbenutzter: er
> erzeugt den Eindruck von Schutz. **Aber a ohne Datum für b wäre die stille Lücke mit
> Unterschrift.**

`☐` a — RR-04 erweitern · Träger ⟨ ⟩ · Frist für b ⟨ ⟩
`☐` b — vorher bauen · wer ⟨ ⟩ · bis ⟨ ⟩

## E-2 · Rolle und Eigentümer bei K13-M05 *(Grund 1 · bestätigt)*

**Die Frage:** Gilt die am 19.08. von A. Han gezeichnete Auslegung **T-4** — *„je Portal genau
eine Rolle, die Mitgliedschaft **ist** die Rolle"* — auch für den Teilschnitt?

**Gemessen:** Sie ist bisher **nur für den Stufenwechsel aus M5** gezeichnet (M32:227-232). Im
Teilschnitt liest **keine** Stelle `role_id`. Das gezeichnete Akzeptanzkriterium führt
Mitgliedschaft (3) und Rolle (4) als **zwei** Punkte.

**Und härter:** K13-M05 hat **keinen benannten fachlichen Eigentümer.** Das Kriterium sagt
selbst: *„Messweg, Schwelle und Evidenzform sagt der Wortlaut nicht — sie ergänzt nach
K23-M02 der fachliche Eigentümer, der in dieser Zeile heute ⟨nicht benannt⟩ ist."*
**Solange dort niemand steht, ist „trägt nicht" gegen K13-M05 nicht abschließend messbar.**

`☐` T-4 gilt auch für den Teilschnitt *(→ Punkt 4 erfüllt, 0 Zeilen Code)*
`☐` Nein — echte Rollenprüfung bauen *(~15–30 Zeilen, 1–2 Dateien)*
`☐` **Fachlicher Eigentümer K13-M05: ⟨Name: ⟩** — unabhängig davon zu benennen

## E-3 · `retention_class` bei `event` *(Grund 7 · bestätigt)*

**Die Frage:** Gilt für `event`-Zeilen **K20-M25 Teil (2)** (`BETRIEBSPROTOKOLL`) oder
**K02-M17** in der Fassung von Beschluss Nr. 60 (`EREIGNIS`)?

> **Hier fehlt nicht die Entscheidung, sondern ihre Zuordnung.** Sachlich ist sie am
> **04.08.2026 mit Beschluss Nr. 60** gefallen und am **16.08. mit Zeichnung B-20** bestätigt.
> Nirgends steht, dass K20-M25 Teil (2) dadurch abgelöst ist. **Solange das nicht dasteht,
> liest jeder Prüfer eine unerfüllte MUSS-Klausel — und er liest sie richtig.**

**Empfehlung: `EREIGNIS`, Beschluss Nr. 60.** *(ABGELEITET — die Sachentscheidung ist
zweimal gezeichnet.)* Der Gegenweg wäre nicht vollziehbar: `event` ist append-only
(`event_append_only`, M30:755); eine Löschfrist in ein unveränderliches Protokoll zu
schreiben ist eine Zusage, die niemand einlösen kann.

**Zu zeichnen hat der fachliche Eigentümer von K20-M25** — `register.md`:1256 führt
*Auftragnehmer (Nr. 158), vertreten durch A. Han*.

`☐` `EREIGNIS` — K20-M25 Teil (2) ist für `event` durch Beschluss Nr. 60 abgelöst *(Empfehlung)*
`☐` `BETRIEBSPROTOKOLL` — dann ist K02-M17 zu ändern
`☐` **Teil (3) von K20-M25** (K15-Minimierung) mitprüfen — *von niemandem je geprüft*

## E-4 · Geltungsbereich der Adress-Eindeutigkeit *(Grund 4 · bestätigt)*

**Die Frage:** Ist eine E-Mail-Adresse **plattformweit** eindeutig oder **je Mandant**?

**Gemessen:** Heute plattformweit (`schema/freiraum_datamodel.sql`:152). **Solange das so ist,
ist die Existenz eines Kontos in einem fremden Mandanten von außen ableitbar — daran ändert
kein Meldungswortlaut etwas.** K03-M25 Teilaussage (8) ist dann nicht erfüllt.

> **Die Entscheidungsvorlage liegt seit dem 14.08.2026 ungezeichnet im Repo:**
> `arbeit/Vorlagen/entscheidung_einladung_mandantengrenze_260814.md`, 217 Zeilen, mit drei
> leeren Kreuzen. Der Fremde hat sechs Tage später denselben Befund erhoben.

**Keine Empfehlung zum Geltungsbereich** — er berührt das **gezeichnete Datenmodell** (Rang 1).
Das ist eine Umfangsentscheidung des Auftraggebers.

`☐` plattformweit — dann RR-T-052 tragen, mit Träger und Frist
`☐` je Mandant — dann ist das Datenmodell zu ändern *(Rang 1, Korrekturblatt)*
`☐` Reicht Nicht-Offenbarung **gegenüber einem Verwaltenden im eigenen Mandanten**? ☐ ja ☐ nein

## E-5 · Das Ausnahmekonto Nr. 59 *(Grund 2 · bestätigt)*

**Die Frage:** Fällt das eine Ausnahmekonto mit `mfa_method = OFF` (M30:988-993, eigener
eindeutiger Index) unter **K03-D10** — *„OFF ist in Release 1 kein zulässiger
Betriebszustand"* — oder bleibt es?

**Gemessen:** `app/anmeldung.py` liest `mfa_method` beim Anmelden **überhaupt nicht**. Ein
Konto mit `OFF` und gültigem Code würde nicht wegen der Methode abgewiesen.

**Empfehlung: entscheiden, dann bauen.** *(VORSCHLAG)* Nach der Entscheidung sind es **drei
Zeilen** — `mfa_method` in die Abfrage aufnehmen und in die bestehende Bedingung einhängen.
**Wichtig:** im vorhandenen Zweig `tragfaehig = False` landen, **nicht** früh zurückkehren —
sonst wird die Sperre am Zeitverhalten unterscheidbar.

`☐` Nr. 59 fällt unter K03-D10 und entfällt · `☐` Nr. 59 bleibt, `OFF` wird ausdrücklich
zugelassen · `☐` anders: ⟨ ⟩

## E-6 · Eigene Meldung beim fehlenden Versandweg *(Grund 3 · teilweise)*

**Die Frage:** Bekommt die Nutzerin auf `/einladung` eine **eigene** Meldung, wenn der
Versandweg fehlt?

**Gemessen:** Heute liest sie *„Dieser Einladungslink gilt nicht mehr."* — **der Link gilt aber
weiter.** Der Quelltext benennt es selbst (`app/einladung.py`:414-425), und
`S1_zeichnung.md`:107 führt den Haken als offen: *„die Sperre wird nur in EINEM Fall begründet
angezeigt … In zwei weiteren Fällen wird der Grund bewusst verschwiegen."*

**Empfehlung: ja, eigene Meldung.** *(VORSCHLAG)* Das Vorbild ist im selben Bau schon in
Gebrauch (`app/einladung_senden.py`:184-187, benutzt in :766). **Es ist die einzige der zehn,
bei der der Nutzer heute etwas sachlich Falsches liest.** Aufwand ~10–14 Zeilen, 2 Dateien.

`☐` eigene Meldung *(Empfehlung)* · `☐` bleibt wie es ist — dann als Restrisiko tragen

---

# Teil 2 · Die vier übrigen

## E-7 · Ist ein Anmeldecode „Zugang"? *(Grund 6 · teilweise)*

Wenn ja, verlangt **K20-M18** eine `event`-Spur mit Vorher/Nachher — die gibt es für
`login_code` nicht. Der Klauselwortlaut sagt dazu **nichts**; ein gezeichnetes Kriterium und
ein benannter Eigentümer **fehlen** (`register.md`:1409).

**Empfehlung: ja.** *(VORSCHLAG)* Ein Einmalcode **ist** der Zugang, seine Entwertung **ist**
eine Änderung daran. Danach: ein Trigger auf `login_code`, ~25–40 Zeilen SQL — das Muster
liegt fertig daneben (`session_event_writer`, M30:960-967). **Und dann alle vier Stellen, nicht
nur die eine aus dem Urteil:** wer nur die Trigger-Entwertung nachrüstet, schließt den Pfad,
der über die Anwendung **nie** läuft, und lässt die drei offen, die laufen.

`☐` ja, ein Code ist Zugang *(Empfehlung)* · `☐` nein · `☐` **Eigentümer K20-M18: ⟨Name: ⟩**

## E-8 · Der Terminweg nach dem Halt *(Gründe 9 und 12 · bestätigt)*

**Die Frage:** Gilt K04-M08 *„Gespräch mit der Ansprechperson **vereinbaren**"* als erfüllt,
wenn der Ausweg erscheint und der Wunsch als Ereignis vermerkt wird — **ohne** dass jemand
benachrichtigt wird?

**Heute erledigt, ohne Zeichnung:** Die Quittung sagte *„Ihre Ansprechperson meldet sich bei
Ihnen."* — eine Zusage, die der Bau nicht einlöst. Sie ist berichtigt.

| | | Folge |
|---|---|---|
| **A** | **Vermerken genügt für den Teilschnitt** | Dann ist `schema/K19_screens.yaml`:204-209 anzupassen oder als später fällig zu markieren — er verspricht heute `request_contact_appointment` und *„Gespräch angestoßen"* |
| **B** | **Die Klausel verlangt mehr** | Dann fällt `contact`/K11 in den Teilschnitt, der Pilotbestand braucht eine `contact`-Zeile, und der Leerzustand ist zu bauen. **Das ist Umfang, kein Bugfix** |

**Empfehlung: A** *(VORSCHLAG)*, zu zeichnen sinnvollerweise von demselben, der BEF-M3-3
gezeichnet hat — dieselbe Klausel, dieselbe Lesart.

`☒` **A** — ⟨gezeichnet am 20.08.2026, übertragen vom Harness auf die Weisung im Wortlaut:
**„E-8 ist A"**⟩
`☐` B
`☐` **Auflage:** VP-18 um die negative Zusicherung ergänzen — **bewusst offen gelassen**; sie
ist dem blinden Prüf-Agenten als Frage vorgelegt, nicht als Vorgabe

## E-9 · Secret-Handling und Betriebsalarm *(Grund 5 · teilweise)*

**Vier Festlegungen, keine davon Programmtext:**

1. **M-14 zeichnen** — neuer Key Vault in `swedencentral`. Der vorhandene liegt in
   `westeurope` und **bräche F05**. Die Empfehlung liegt seit dem **09.08.** vor. Ohne diese
   Zeichnung ist der Punkt **baulich blockiert, nicht baulich offen.**
2. **Betriebsalarm:** wer wird alarmiert, wohin, welches Runbook? Der Delivery-Plan legt das
   in Baustein 4.7 — also **außerhalb** dessen, was zum 31.08. geschuldet ist. **Zu
   entscheiden: gilt K03-M26 Satz 3 für den Teilschnitt, oder wandert er mit hinaus?**
3. Ist der Zustellnachweis `mail_delivery` *„Telemetrie"* im Sinne der Klausel? Wenn ja,
   kollidiert sie mit Bauauftrag B2, der den Nachweis fordert — dann muss jemand sagen,
   welche weicht.
4. Ist die Bildschirmausgabe eines Betreiberwerkzeugs ein *„Log"*?

> **Vorgelagert und härter:** K03-M26 trägt bis heute **weder** gezeichnetes Kriterium
> **noch** benannten Eigentümer. Solange niemand gezeichnet hat, **wie** die Klausel gemessen
> wird, ist jedes Urteil über sie — auch ein freisprechendes — nicht belegbar.

`☐` M-14 zeichnen · `☐` Satz 3 gilt für den Teilschnitt ☐ / wandert mit 4.7 hinaus ☐
`☐` **Eigentümer K03-M26: ⟨Name: ⟩**

## E-10 · Der Produktivsperrriegel bei K04-G11 *(Grund 10 · teilweise · berührt den 31.08. nicht)*

**Die Frage:** Was heißt *„der Produktivweg bleibt gesperrt"* — ein **Betriebsbeleg** oder ein
**Riegel im Code**?

**Der Harness darf das nicht auslegen — die Klausel nennt keinen beobachtbaren Ort.**

| | | Folge |
|---|---|---|
| **a** | Die Sperre ist erfüllt, solange es keine Produktivfreigabe gibt | Der Nachweis ist ein gezeichneter Betriebsbeleg, kein Code. O-M3-3 wird von *offen* auf *gezeichnet* gehoben |
| **b** | Die Sperre muss am Bau greifen | Riegel in `app/haupt.py`:104 plus Prüffall |

> **Und ein zweiter Punkt, bei dem ich keine Empfehlung geben darf:** Die Kritikalität von
> K04-G11 steht als ⟨VORSCHLAG · NICHT GEZEICHNET⟩, das Feld `eigentuemer` ist **leer**.
> **K23-G08 untersagt dem Harness ausdrücklich, sie selbst zu begründen.** Solange niemand
> zeichnet, sperrt die Klausel auch nichts.

`☐` a · `☐` b · `☐` **Eigentümer und Kritikalität K04-G11: ⟨Name: ⟩ ⟨Einstufung: ⟩**

---

# Nachtrag · **E-11** — der Ablauf des freien Weges auf EN-04a

*Aufgenommen am 20.08.2026 auf die Weisung „ok, formuliere e-11". Der Punkt stammt nicht aus
dem Fremdurteil, sondern aus `BEF-ZB-1` — dem Befund, dass die dreizehn gesperrten
Zweckbestimmungs-Fälle **kein Baufehler** sind.*

## Warum es diese Entscheidung überhaupt braucht

Der blinde Prüf-Agent misst EN-04a, indem er **zwei Zielmengen vergleicht**: einmal den
freien Weg (beide Zweckfragen verneint), einmal den Weg mit Treffer in Frage 1. Was nur auf
einer Seite steht, ist für ihn der gesuchte Weg.

**Das setzt einen Zwischenschritt voraus, nach dem beide Wege sich noch auf derselben Seite
gegenüberstehen.** Ob es den gibt, sagt keine Klausel.

**Drei unabhängige Diagnosen, jede tatsächlich reproduziert, wurden von ihren Gegenprüfern
widerlegt — und alle drei Gegenproben kamen unabhängig auf dieselbe Ursache:**

> Auf dem freien Weg **ist** der Weiterweg die Anlage. Der Prüflauf bestimmt seinen
> Weiterweg sogar an genau dieser Wirkung — *„derjenige, nach dessen Aufruf eine neue
> Anwendungszeile entstanden ist"* — **verbraucht damit den einzigen Schritt beim Entdecken**
> und misst danach auf der Seite danach. Deshalb bleiben seine beiden Ziele leer, und deshalb
> sperren dreizehn Fälle.

**Der Bau ist entlastet:** Die Vorlage kann in keinem Zweig eine zielfreie Seite liefern;
gemessen trägt der Bestätigungszweig genau ein Ziel.

## Was hier zu entscheiden ist

**K04-M17 bis K04-M21 beschreiben die Zweckbestimmung, aber keine Klausel sagt, ob zwischen
der letzten Antwort und der Anlage ein eigener, folgenloser Schritt liegt.** Genau das ist zu
zeichnen.

| | Lesart | Folge |
|---|---|---|
| **A** | **Ein Schritt.** Ist der Weg frei, legt „Weiter" die Anwendung an. Einen zustandsneutralen Zwischenschritt gibt es nicht | Der Prüf-Agent leitet sein Ablaufmodell neu ab und misst die dreizehn Fälle anders — **ohne Änderung am Bau**. Das entspricht dem, was heute gebaut ist |
| **B** | **Zwei Schritte.** Zwischen Antwort und Anlage steht eine Bestätigungsseite, die nichts ändert | Der Prüflauf bleibt, wie er ist — **der Bau muss einen Schritt ergänzen.** Das ist Umfang: eine Seite, ein Weg, ein Prüffall, und der Bildschirmvertrag ist nachzuziehen |

> **Empfehlung: A.** *(VORSCHLAG des Harness — die Auslegung gehört dem fachlichen
> Eigentümer.)*
>
> **Der Grund ist keine Bequemlichkeit, sondern K01-M27:** *„Eine produktive Anwendungszeile
> MUSS ausschließlich über den serverseitigen Befehl entstehen."* Ein folgenloser
> Zwischenschritt vor der Anlage ist damit **nicht verlangt** — und wo eine Klausel nichts
> fordert, ist der einfachere Weg der belegbare. **B wäre Umfang, den keine Klausel trägt**,
> und der Harness erfindet keinen Umfang (`CLAUDE.md` Abschn. 6).
>
> **Wenn A gilt, ist Grund 12 des Fremdurteils erledigt und M4s Bildschirmseite zum ersten
> Mal messbar** — genau der Punkt, den der Auftraggeber zu M4 einfordert.

## Was dem Prüf-Agenten vorgelegt wird — und was nicht

**Vorgelegt wird die gezeichnete Auslegung, ein Satz.** Aus ihm leitet er sein Ablaufmodell
**selbst** ab.

**Nicht vorgelegt wird**, wie der Bau es macht, welche Adresse welche Antwort liefert oder was
`BEF-ZB-1` sonst enthält — das Blatt beschreibt Verhalten des Baus und bleibt bei ihm. Sonst
schriebe er seinen nächsten Prüffall auf den Code statt auf die Klausel (K23-D05).

`☒` **A** — ein Schritt; auf dem freien Weg ist der Weiterweg die Anlage
⟨gezeichnet am 20.08.2026, übertragen vom Harness auf die Weisung im Wortlaut: **„E-11 ist A"**⟩
`☐` **B** — zwei Schritte; der Bau ergänzt eine Bestätigungsseite
`☐` anders: ⟨ ⟩

**Fachlicher Eigentümer K04:** ⟨einzutragen — das Feld ist bei K04-M08 belegt, bei den
Zweckbestimmungsklauseln zu prüfen⟩

---

# Was auffällt, wenn man alle zehn nebeneinander legt

| | |
|---|---|
| **Fünf Klauseln haben keinen benannten fachlichen Eigentümer** | K13-M05 · K03-M26 · K20-M18 · K20-M25 · K04-G11. **Ohne ihn ist nach K23-M02 nicht messbar, ob sie erfüllt sind** — weder positiv noch negativ. Fünf der zwölf Gründe hängen daran |
| **Zwei Entscheidungen sind längst gefallen** | Der `retention_class`-Beschluss vom 04.08. und die Vorlage zur Adress-Eindeutigkeit vom 14.08. **Es fehlt in beiden Fällen nur die Zuordnung bzw. die Unterschrift** |
| **Nur eine der zehn betrifft etwas, das eine Nutzerin merkt** | E-6 — der Satz *„Dieser Einladungslink gilt nicht mehr"*, wenn er weiter gilt |

---

## Zeichnung

| | Entscheidung | |
|---|---|---|
| **E-1** | Mandantengrenze im Teilschnitt | ☐ a · ☐ b |
| **E-2** | T-4 für den Teilschnitt · Eigentümer K13-M05 | ☐ · ⟨ ⟩ |
| **E-3** | `retention_class` = EREIGNIS | ☐ · ⟨ ⟩ |
| **E-4** | Geltungsbereich der Adress-Eindeutigkeit | ☐ · ⟨ ⟩ |
| **E-5** | Ausnahmekonto Nr. 59 | ☐ · ⟨ ⟩ |
| **E-6** | Eigene Meldung beim fehlenden Versandweg | ☐ · ⟨ ⟩ |
| **E-7** | Anmeldecode = Zugang · Eigentümer K20-M18 | ☐ · ⟨ ⟩ |
| **E-8** | Terminweg — A oder B | **☒ A** · ⟨20.08.2026⟩ |
| **E-9** | M-14 · Betriebsalarm · Eigentümer K03-M26 | ☐ · ⟨ ⟩ |
| **E-10** | K04-G11 · Eigentümer und Kritikalität | ☐ · ⟨ ⟩ |
| **E-11** | Ablauf des freien Weges auf EN-04a — ein Schritt oder zwei | **☒ A** · ⟨20.08.2026⟩ |

| Name | Rolle | Datum |
|---|---|---|
| A. Han | für den Auftragnehmer (Nr. 158) | ⟨ ⟩ |
| M. Veil | für den Auftraggeber | ⟨ ⟩ |

---

*Erstellt am 20.08.2026 aus `arbeit/Bauberichte/tor3_zwoelf_gruende_nachgerechnet_260820.md`.
Jeder Grund ist am Quelltext nachgerechnet und die Nachrechnung gegengelesen worden. **Der
Harness entscheidet keinen der zehn Punkte** — bei E-4 und E-10 darf er nicht einmal eine
Empfehlung geben, und das steht dort.*
