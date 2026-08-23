# Zur Zeichnung · Vier Akzeptanzkriterien — A. Han

**23.08.2026 · Eigentümer laut Register: Auftragnehmer (Nr. 158), vertreten durch A. Han,
gez. 16.08.2026.**

---

## Worum es geht — in vier Sätzen

Das Fremdreview vom 20.08.2026 hat zwölf Gründe genannt, warum der Teilschnitt *nicht trägt*.
Vier davon lassen sich **nicht bauen**, weil nicht gezeichnet ist, wann die Klausel als
erfüllt gilt. Die Kriterien tragen die Marke ⟨VORSCHLAG · NICHT GEZEICHNET⟩ und sagen
selbst: *„Messweg, Schwelle und Evidenzform sagt der Wortlaut nicht — sie ergänzt nach
K23-M02 der fachliche Eigentümer."*

**Der Harness darf sie nicht ergänzen** (K23-M02, K23-G08). Baut er ohne sie, entscheidet er
den Inhalt eines Kriteriums — und dann misst der Bau sich selbst.

**Zeichnen heißt hier zweierlei:** den Kriterientext bestätigen **und** die eine offene
Frage darunter beantworten. Ohne die Antwort bleibt das Kriterium unbaubar, auch mit
Unterschrift.

---

## 1 · K03-M05 — der zweite Faktor

> **Kriterium (Vorschlag):** Erfüllt, wenn nachgewiesen ist: (1) der zweite Faktor ist ein
> Code per E-Mail; (2) der Code ist sechsstellig; (3) **`mfa_method` trägt den Wert
> `EMAIL_CODE`**; (4) ein anderes Verfahren führt das Datenmodell nicht.

**Gemessen am 23.08.2026:** `mfa_method` kommt im gesamten Anwendungscode **nicht vor** —
kein Treffer in `app/` und `mail/`. Das Schema lässt neben `EMAIL_CODE` auch `OFF` zu.

**Die offene Frage — ohne sie kann der Bau Punkt (3) nicht umsetzen:**

Was tut der Server bei der Anmeldung, wenn ein Konto `mfa_method = OFF` trägt?

`x` **abweisen** — mit der bestehenden Meldung, die keinen Grund nennt (K03-M25); Empfehlung des Harness: **abweisen mit der bestehenden Meldung** — und M30:992-993 zurücknehmen
>
`☐` **abweisen** — mit eigener Meldung: ⟨………………………⟩
`☐` **zulassen** — dann ist Punkt (3) im Kriterium zu streichen und zu begründen
`☐` abweisen, **außer** für die Erstkonto-Ausnahme nach Beschluss Nr. 59

> ### Empfehlung des Harness: **abweisen mit der bestehenden Meldung** — und M30:992-993 zurücknehmen
>
> **Gemessen, nicht gemeint** (`arbeit/Bauberichte/tor3_zwoelf_gruende_nachgerechnet_260820.md`:344-352):
> `migrations/M30…sql:988-993` sieht nach **Beschluss Nr. 59** genau **ein** Ausnahmekonto mit
> `mfa_method = OFF` vor und sichert es mit einem eindeutigen Index ab. **Benutzt wird es
> nicht:** Der Erst-Admin wird ohnehin mit `EMAIL_CODE` angelegt
> (`install/01_betreiber_und_erstadmin.sql:101`). Das Ausnahmekonto ist *vorgesehen, aber
> unbenutzt*.
>
> Damit ist der Weg mit der kleinsten Ausnahme zugleich der ohne Verlust: abweisen, und die
> Vorsorge für ein Konto zurücknehmen, das niemand anlegt. Bleibt sie stehen, ist K03-D10 für
> ein versiegeltes Konto ausgenommen — **und diese Ausnahme müsste gezeichnet werden, nicht
> stillschweigend geduldet.** Heute gilt weder das eine noch das andere.
>
> *Eine eigene Meldung für diesen Fall wäre der Fehler: Sie machte aus der Abweisung genau das
> Orakel, das K03-M25 verbietet.*

`x` **Kriterium so gezeichnet** ⟨zeichnet: …A. Han………⟩ ⟨am: ……23.8.26……⟩

---

## 2 · K03-M25 — der Einladungsbefehl

> **Kriterium (Vorschlag):** Erfüllt, wenn nachgewiesen ist: (1) serverseitig; (2) idempotent;
> (3) prüft den Zielmandanten; (4) prüft den Entscheidungsnachweis; (5) prüft die Domäne;
> (6) legt Einladung und Ereignis atomar an; (7) Portal, Builder und Service-Schlüssel
> umgehen die Prüfung nicht; (8) **Fehlermeldungen geben nicht preis, ob ein Konto existiert.**

**Der Befund des Fremdmodells betrifft allein Punkt (8).** Der Bau führt dafür einen
einzigen Wortlaut (`MELDUNG_MISSERFOLG`) und einen Umweg gegen den Zeitseitenkanal.

**Die offene Frage:** Woran wird Punkt (8) gemessen?

`☐` **nur am Wortlaut** — eine Meldung, kein Unterschied im Text
`x` **Wortlaut und Statuscode** — auch die Antwortnummer darf nicht unterscheiden; Empfehlung des Harness: **Wortlaut und Statuscode** — der Zeitseitenkanal als benannter Punkt
`☐` **Wortlaut, Statuscode und Antwortzeit** — der Zeitseitenkanal zählt mit
`☐` anders: ⟨………………………⟩

> ### Empfehlung des Harness: **Wortlaut und Statuscode** — der Zeitseitenkanal als benannter Punkt
>
> Der Bau behandelt den Zeitseitenkanal bereits: `app/anmeldung.py` führt eigens eine
> Kennung `_KEIN_KONTO`, gegen die auch dann geprüft wird, wenn kein Konto besteht — damit
> der Weg ohne Treffer dieselbe Anzahl Anweisungen kostet wie der mit. Das ist ernst gemeint
> und soll nicht verloren gehen.
>
> **Trotzdem gehört er nicht ins Kriterium.** Eine Zeitschwelle hat niemand festgelegt, und
> ein Zeittest ohne Schwelle flattert — er meldet mal grün, mal rot, je nach Auslastung des
> Prüfstands. **Ein Kriterium, das man nicht verlässlich messen kann, wird gezeichnet und dann
> ignoriert.** Das ist schlechter als eines, das die Grenze ausspricht.
>
> Vorschlag: Punkt (8) misst **Wortlaut und Statuscode**; der Zeitseitenkanal wird als
> geführter Punkt mit Träger und Frist aufgenommen, mit dem heutigen Umweg als Beleg dafür,
> dass er nicht vergessen ist.

`x` **Kriterium so gezeichnet** ⟨zeichnet: …A.Han………⟩ ⟨am: 23.8.26…………⟩

---

## 3 · K20-M18 — der Nachweis jeder Zugangsänderung

> **Kriterium (Vorschlag):** Erfüllt, wenn nachgewiesen ist: (1) jede Änderung an Zugang,
> Rolle, Mitgliedschaft oder Einladung steht im internen Nachweis; (2) der Eintrag trägt den
> Zeitpunkt; (3) er trägt die handelnde Instanz; (4) **er trägt den Wert davor und den Wert
> danach.**

**Der Befund betrifft Punkt (4):** Die Entwertung älterer Anmeldecodes erzeugt keine Spur mit
Vorher/Nachher.

**Die offene Frage:** In welcher Form steht „davor/danach" im Nachweis?

`x` in `event.value` als zwei benannte Felder — Vorschlag: `{"vorher": …, "nachher": …}`; Empfehlung des Harness: **zwei benannte Felder in `event.value`**
`☐` als zwei Einträge, einer je Zustand
`☐` anders: ⟨………………………⟩

> **Zu bedenken:** Bei Anmeldecodes ist der „Wert" ein Streuwert. Er darf nach K03-M15 nicht
> im Klartext erscheinen — der Nachweis trägt also den **Zustand** (`VERSANDT` → `ENTWERTET`),
> nicht den Code.

> ### Empfehlung des Harness: **zwei benannte Felder in `event.value`**
>
> **Gemessen:** `event.value` ist vom Typ `text` (`schema/freiraum_datamodel.sql`, Tabelle
> `event`, Zeile 10 des Blocks) — kein `jsonb`. Zwei benannte Felder gehen also als
> JSON-**Text** hinein: `{"vorher": "VERSANDT", "nachher": "ENTWERTET"}`.
>
> **Warum ein Eintrag und nicht zwei:** Zwei Einträge lassen sich einzeln lesen, einzeln
> löschen und einzeln übersehen. Das Paar gehört zusammen, weil es erst zusammen eine
> Änderung beschreibt — und `event` ist ohnehin nur anfügbar (`append_only_guard`), ein
> zweiter Eintrag könnte also nie mit dem ersten verknüpft werden.
>
> **Sauberer wäre `jsonb` oder zwei eigene Spalten.** Das ist eine Änderung am gezeichneten
> Datenmodell und gehört in einen Migrationsnachtrag, nicht in diesen Pfad — dieselbe
> Begründung, die `app/anmeldung.py` für den fehlenden Index über `lower(email)` führt.

`x` **Kriterium so gezeichnet** ⟨zeichnet: …A.Han………⟩ ⟨am: …23.8.26………⟩

---

## 4 · K20-M25 — der Wiederversand · **hier bitte nicht allein zeichnen**

> **Kriterium (Vorschlag):** Erfüllt, wenn nachgewiesen ist: (1) der Wiederversand zeigt den
> Satz *Der vorherige Link ist ungültig*; (2) **der Nachweis einer Zugangsänderung trägt
> `retention_class = BETRIEBSPROTOKOLL`**; (3) die personenbezogene Anzeige ist nach K15
> minimiert.

> ## ⚠ Punkt (2) widerspricht einem gezeichneten Founder-Beschluss
>
> `app/einladung_senden.py:291` hält es fest: *„K20-M25 nennt für den Nachweis einer
> Zugangsänderung BETRIEBSPROTOKOLL; **M30 hat die Vorgabe der Tabelle am 04.08.2026 auf
> EREIGNIS umgestellt** … Zwei Quellen, ein Widerspruch — er wird gemeldet, nicht hier
> entschieden."*
>
> **Das ist Beschluss Nr. 60, Option A.** Eine Klausel gegen einen Founder-Beschluss
> aufzulösen ist nicht Sache des fachlichen Eigentümers allein — **das gehört M. Veil**, und
> es ist Grund 7 der zwölf.

**Punkte (1) und (3)** können unabhängig davon gezeichnet werden:

`☐` **Punkte (1) und (3) gezeichnet**, Punkt (2) zurückgestellt bis zur Entscheidung über
Nr. 60 ⟨zeichnet: …………⟩ ⟨am: …………⟩

**Zur Entscheidung durch M. Veil — Grund 7:**

`☐` **A** — die Klausel gilt: `BETRIEBSPROTOKOLL`; die Tabellenvorgabe aus M30 wird für
Zugangsänderungen überschrieben
`x` **B** — der Beschluss gilt: `EREIGNIS`; K20-M25 Punkt (2) wird per Korrekturblatt; Empfehlung des Harness: **B — der Beschluss gilt, die Klausel wird geändert**
geändert
`☐` **C** — beides bleibt, der Widerspruch wird als benanntes Restrisiko geführt
⟨Träger: ………⟩ ⟨Frist: ………⟩

> ### Empfehlung des Harness: **B — der Beschluss gilt, die Klausel wird geändert**
>
> **Nicht nach Geschmack, sondern nach der Rangfolge des Hauses.** Sie steht in der
> Projektsteuerung: *Rang 0 — Festlegungen und gezeichnete Founder-Beschlüsse, gewinnt gegen
> alles Weitere. Rang 1 — das Datenmodell plus Sammelmigration M30, gewinnt gegen Doku,
> Handbücher, Prüffälle.* Eine Klausel aus einem Konzept steht darunter.
>
> **Gemessen:** `migrations/M30…sql:70` fügt `EREIGNIS` zum Aufzählungstyp hinzu, `:1493`
> setzt den Vorgabewert der Tabelle `event` darauf, `:1495` vermerkt den nötigen Nachzug des
> Altbestands. Das Basisschema führt daneben weiterhin
> `DEFAULT 'BETRIEBSPROTOKOLL'` — **der Widerspruch steht also nicht zwischen zwei Meinungen,
> sondern in zwei Dateien.**
>
> Nach der Rangfolge gewinnen Nr. 60 und M30. Dann ist **K20-M25 Punkt (2) per Korrekturblatt
> zu ändern** — nicht der Code zu biegen.
>
> **Weg C — beides stehen lassen — wäre der einzige, der nichts löst:** Er ist der heutige
> Zustand, und er hat den Befund erzeugt.

⟨zeichnet: A.Han…………⟩ ⟨am: …23.8.26………⟩

---

## Was danach geschieht

Sobald 1 bis 3 gezeichnet sind, baut der Harness gegen den gezeichneten Maßstab — die
Gründe 2, 4 und 6 des Fremdreviews. Punkt 4 wartet auf die Entscheidung zu Nr. 60.

Danach ist ein erneutes Tor 3 sinnvoll: gegen einen Stand, dessen Maßstab feststeht, und mit
den übrigen Gründen als **benannte** offene Punkte statt als unbenannte.

---

> **Zur Herkunft der Empfehlungen.** Sie stützen sich auf
> `arbeit/Bauberichte/tor3_zwoelf_gruende_nachgerechnet_260820.md` — dort hat der Harness die
> zwölf Gründe schon am 20.08.2026 gegen den Programmtext nachgerechnet — und auf eigene
> Messungen vom 23.08.2026. Jede Empfehlung nennt ihre Fundstelle. **Eine Empfehlung ist keine
> Zeichnung**; ein Kreuz setzt der fachliche Eigentümer.

*Die Kriterientexte sind wörtlich aus `nachweise/klauselregister/pflege.json` übernommen,
nichts ergänzt und nichts gekürzt. Der Harness hat die Fragen darunter formuliert, aber keine
davon beantwortet. Nach der Zeichnung gehören die Werte zurück ins Register — das ist Sache
des Knowledge-Managers, nicht dieses Blattes.*
