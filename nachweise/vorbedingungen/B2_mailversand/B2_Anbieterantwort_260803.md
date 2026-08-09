# B2 · Antwort des Anbieters · 03.08.2026

> ## ⚠ ÜBERHOLT AM 4. AUGUST 2026
>
> **Diese Datei gibt den Stand vom 3. August 2026 wieder. Bytecamp hat am 4. August
> zweimal geantwortet und drei Aussagen darin aufgehoben:**
>
> | hier steht | seit 4.8. gilt |
> |---|---|
> | MX für `zaa.freiraum.top` fehlt | **eingerichtet** — „Die Subdomain ist als MX eingerichtet." |
> | Virtualhost blockiert durch Speichergrenze (1,20 €/Monat) | **gelöst** — „Die Domain ist eingerichtet." |
> | 2048 Bit abgelehnt, ohne Termin | **konfiguriert** — „Für die Subdomain wurde dies genauso konfiguriert wie für die Domain." |
> | Postfächer fehlen | **verfügbar** — Selbstbedienung über die Domainverwaltung |
>
> **Der geltende Stand steht in** `02_AGENT_HARNESS_KONZEPTE/ITERATION_2/entscheidungsvorlagen/final_entscheidung-pflichtangaben/260804_Nachtrag_Bytecamp.md`.
>
> Was **unverändert** gilt: Beschluss Nr. 43 — die Signaturdomäne ist am
> zugestellten Mailkopf zu **messen**. Der Anbieter sagt zu, was sein soll;
> die Messung belegt, was ist. Eine Zusage ist kein Nachweis.
>
> *Vermerk gesetzt am 05.08.2026, nachdem diese Datei einmal als aktueller
> Stand gelesen wurde und zu zwei falschen Befunden geführt hat.*



Bytecamp (B. Haagen) hat auf die vier Anliegen vom 02.08.2026 geantwortet. Die Antwort
**entsperrt nichts, klärt zwei Punkte und stößt eine Planannahme um.**

## 1 · Der neue Blocker: der Speicherplatz ist voll

> *„Die Domain kann nicht angelegt werden als eigenstaendiger Virtualhost, da Ihr
> Speicherplatz komplett ausgenutzt ist. Wir bieten Speichererweiterungen in 1GB-Schritten
> zu je 1,20 Euro monatlichen Mehrkosten."*

Das ist die eigentliche Nachricht. **B3 hängt nicht an einer Konfiguration, sondern an
1,20 € im Monat.** Die Kette ist eindeutig:

```
Speicher erweitern ──▶ Domain als Virtualhost anlegen ──▶ MX für zaa.freiraum.top
                                                      ──▶ Postfächer einladung@… und dmarc@…
                                                      ──▶ SMTP-Zugangsdaten
                                                      ──▶ B2-Abnahme gegen echten Versand
                                                      ──▶ B3-Abnahme
                                                      ──▶ Pilotstart
```

Ohne diesen einen Schritt steht die gesamte Vorbedingungskette. Wie viele Gigabyte nötig
sind, sagt die Antwort nicht — das ist beim Anbieter zu erfragen.

## 2 · Geklärt: die Signierung übersteht die Umstellung

> *„Der Schluessel gilt fuer die Domain, unabhaengig, wie diese eingerichtet ist."*

Damit ist die Sorge aus dem DNS-Stand vom 02.08. ausgeräumt: Ein Paketwechsel setzt die
Mailkonfiguration **nicht** zurück. Ein offener Punkt weniger.

## 3 · Geklärt: die SMTP-Parameter stehen fest

Aus der verwiesenen Dokumentation (`bytecamp.net/de/faq/email/uebersicht.html`, abgerufen
03.08.2026):

| Feld | Wert |
|---|---|
| Postausgangsserver | `mail.bytecamp.net` |
| Port | 587 mit STARTTLS **oder** 465 mit TLS/SSL |
| Benutzername | die vollständige E-Mail-Adresse |
| Kennwort | das Kennwort des Postfachs |
| Größenbegrenzung | 100 MB je Nachricht |

Fehlt weiterhin: **das Postfach selbst** samt Kennwort — es entsteht erst mit der
Speichererweiterung. Die Werte gehören dann als `FREIRAUM_SMTP_HOST/USER/PASS` in den
Passwortmanager, nicht ins Repo.

## 4 · Nicht geklärt: der `d=`-Wert der Signatur

Die Antwort verweist auf die DKIM-Dokumentation. **Dort steht der `d=`-Wert nicht.** Die
Seite sagt nur: *„Wir signieren ausgehende E-Mails nur dann, wenn in Ihren DNS-Einstellungen
ein entsprechender Eintrag gesetzt wurde."* Auch die Schlüssellänge wird dort nicht genannt.

Damit bleibt genau die Frage offen, die über Erfolg oder Ausfall entscheidet. Unser
DMARC-Eintrag verlangt **strenge Zuordnung** (`adkim=s`):

| `d=` der Signatur | Wirkung |
|---|---|
| `d=freiraum.top` | Zuordnung greift |
| `d=bytecamp.net` | Zuordnung **scheitert** — DKIM zählt für DMARC nicht mit |

**Das lässt sich nicht mehr durch Nachfragen klären, sondern nur noch messen.** Sobald das
Postfach existiert, wird eine echte Mail versandt und am zugestellten Kopf abgelesen, welchen
`d=`-Wert die Signatur trägt. Bis dahin bleibt `p=none` stehen — bei `p=quarantine` oder
`p=reject` wären die Anmeldecodes im Fehlerfall alle auf einmal weg.

## 5 · Abgelehnt: 2048 Bit — und zwar ohne Termin

> *„Einen weiteren Schluessel koennen wir derzeit nicht erzeugen, da dieser global fuer alle
> Kunden gilt. Ein Wechsel bedeutet einhergehenden Aufwand. Geplant ist dies, aber ein
> Zeitpunkt der Implementierung ist nicht nennbar."*

**Das stößt eine Planannahme um.** Das Abnahmeprotokoll vom 02.08. führte die Schlüssellänge
als *„kein Blocker für den Pilot, aber vor dem ersten echten Kunden zu erledigen"*. Genau das
ist bei diesem Anbieter **nicht erledigbar** — der Schlüssel ist geteilte Infrastruktur, und
es gibt keinen Termin.

Aus einer Aufgabe wird damit eine Entscheidung. Drei Wege:

| Weg | Bedeutung |
|---|---|
| 1024 Bit annehmen | Als benanntes, befristetes Restrisiko führen, mit Wiedervorlage. Wird heute allgemein akzeptiert, gilt aber als schwach |
| Versanddienst wechseln | Ein eigener Versanddienst mit eigenem Schlüssel — Mehraufwand, neue Auftragsverarbeitung, aber volle Kontrolle über Schlüssel und `d=`-Wert |
| Pilot mit 1024 Bit, Produktivbetrieb erst nach Wechsel | Trennt die Frage sauber: der Pilot fährt synthetische Daten, der erste echte Kunde bekommt einen eigenen Schlüssel |

Die Entscheidung liegt beim Founder und ist als Entscheidungsvorlage aufgenommen.

## 6 · Was sich am Abnahmestand ändert

**Nichts.** B2 bleibt „gegen den Testempfänger abgenommen, echter Versand offen", B3 bleibt
unbegonnen. Die Antwort verschiebt keinen Nachweis — sie benennt nur präziser, was fehlt.

| Restpunkt aus dem Abnahmeprotokoll | Stand nach dieser Antwort |
|---|---|
| Webhosting aktiv, Postfächer angelegt | **blockiert durch Speichergrenze** |
| MX für `zaa.freiraum.top` | folgt der Domain-Einrichtung |
| SMTP-Zugangsdaten | Parameter bekannt, Postfach und Kennwort fehlen |
| Bestätigung des `d=`-Werts | **nicht beantwortet — nur noch messbar** |
| Signierung übersteht Paketwechsel | **bestätigt** |
| 2048 Bit | **abgelehnt, ohne Termin** — wird zur Founder-Entscheidung |
| Zustellung ≠ Übergabe (Bounce-Verarbeitung) | unverändert offen |
| F05-Beleg (`B2_Dienst-Entscheidung.md`) | unverändert offen |

**Quelle:** E-Mail B. Haagen (Bytecamp) vom 03.08.2026 auf die Anfrage vom 02.08.2026.
