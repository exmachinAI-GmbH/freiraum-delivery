# B2 · Was bei Bytecamp zu tun ist — Schritt für Schritt

**Stand 02.08.2026.** Ausgangslage geprüft: `freiraum.top` liegt bei Bytecamp
(`ns1/ns2.bytecamp.net`, MX `mail2.bytecamp.net`), SPF ist gesetzt, **DKIM und DMARC fehlen**.

## Warum das kein Schönheitsfehler ist

In FREIRAUM gibt es kein Kennwort. Der sechsstellige Code in der Mail **ist** der Zugang, und
K03 sagt ausdrücklich: ohne Versand keine Sitzung, kein Ersatzverfahren. Eine Mail, die im
Spam landet, ist deshalb kein Ärgernis, sondern ein gesperrter Zugang — und niemand sieht,
warum. Genau davor schützen die beiden fehlenden Einträge.

---

## Schritt 1 · DKIM aktivieren lassen

**Was es ist.** Eine kryptografische Unterschrift unter jeder Mail. Der Mailserver signiert,
der öffentliche Schlüssel steht in Ihrem DNS, der Empfänger prüft die Unterschrift. Damit ist
belegt: Die Mail kommt wirklich von `freiraum.top` und wurde unterwegs nicht verändert.

**Was Sie tun.** Bytecamp bitten, DKIM für die Domäne zu aktivieren. Bei den meisten Hostern
ist das ein Schalter im Kundenbereich; sonst genügt eine Mail an den Support (Vorlage unten).
Bytecamp erzeugt das Schlüsselpaar, trägt den öffentlichen Teil als TXT-Eintrag unter
`<selektor>._domainkey.freiraum.top` ein und signiert ab dann jede ausgehende Mail.

**Was Sie zurückbekommen sollten:** den verwendeten **Selektor** (ein kurzer Name, oft
`default`, `bc`, `s1` oder ähnlich). Den brauche ich, um die Prüfung nachzuvollziehen.

**Fertig, wenn:** `dig +short TXT <selektor>._domainkey.freiraum.top` etwas ausgibt, das mit
`v=DKIM1;` beginnt.

---

## Schritt 2 · DMARC-Eintrag setzen

**Was es ist.** Eine Anweisung an den Empfänger, was er tun soll, wenn SPF oder DKIM
scheitern — und wohin er Berichte schicken darf. Ohne DMARC entscheidet jeder Empfänger
selbst, meist zu Ihren Ungunsten.

**Was Sie tun.** Im DNS von `freiraum.top` einen TXT-Eintrag anlegen:

| Feld | Wert |
|---|---|
| Name | `_dmarc` (ergibt `_dmarc.freiraum.top`) |
| Typ | `TXT` |
| Wert | `v=DMARC1; p=none; rua=mailto:dmarc@freiraum.top; adkim=s; aspf=s; pct=100` |

**Was die Bestandteile bedeuten:**

| Teil | Bedeutung |
|---|---|
| `p=none` | Noch **nichts blockieren**, nur berichten. Der bewusste Anfang |
| `rua=mailto:…` | Wohin die Sammelberichte gehen — das Postfach muss existieren |
| `adkim=s` · `aspf=s` | Strenge Zuordnung: die Absenderdomäne muss exakt passen, nicht nur „irgendwie verwandt" |
| `pct=100` | Die Regel gilt für alle Mails |

**Warum `p=none` und nicht sofort scharf.** Wer sofort auf `reject` geht, sperrt womöglich
den eigenen Versand aus, ohne es zu merken — und beim Anmeldecode fällt das erst auf, wenn
sich niemand mehr anmelden kann. Ein bis zwei Wochen mitlesen, dann verschärfen.

**Fertig, wenn:** `dig +short TXT _dmarc.freiraum.top` den Eintrag ausgibt.

---

## Schritt 3 · Zugangsdaten für den Versand

Für den echten Versand braucht das Skript einen SMTP-Zugang: **Server, Port, Benutzername,
Kennwort**, dazu die Angabe, ob TLS verlangt wird (fast immer ja, Port 587).

**Wohin damit:** Passwortmanager oder Key Vault. **Nicht** in die Dropbox, **nicht** ins Repo
— dort ist `.env*` gesperrt, aber die Regel gilt unabhängig davon.

Das Postfach `dmarc@freiraum.top` aus Schritt 2 sollte im selben Zug angelegt werden.

---

## Schritt 4 · Postfach für den Pilot-Kundenmandanten

Getrennt von allem oben, gehört aber in dieselbe Bestellung: Für den Pilotlauf braucht die
Sub-Domäne `zaa.freiraum.top` einen **MX-Eintrag** und ein Postfach, das der Prüfer lesen
kann. Sie spielt die Hausadresse der Demobank; heute existiert dort kein MX.

---

## Vorlage für die Mail an Bytecamp

> Betreff: freiraum.top — DKIM aktivieren, Subdomain-Postfach einrichten
>
> Guten Tag,
>
> für unsere Domäne **freiraum.top** bitten wir um zwei Einrichtungen:
>
> **1. DKIM aktivieren.** Bitte erzeugen Sie ein Schlüsselpaar, hinterlegen den öffentlichen
> Schlüssel im DNS und signieren ausgehende Mails der Domäne. Bitte teilen Sie uns den
> verwendeten Selektor mit.
>
> **2. Sub-Domäne `zaa.freiraum.top`** mit MX-Eintrag und einem abrufbaren Postfach
> (z. B. `einladung@zaa.freiraum.top`) einrichten.
>
> Außerdem benötigen wir die SMTP-Zugangsdaten für den programmgesteuerten Versand über
> unser Absenderpostfach (Server, Port, Benutzername, TLS-Anforderung).
>
> Den DMARC-Eintrag setzen wir selbst, sofern wir Zugriff auf die DNS-Verwaltung haben —
> andernfalls bitten wir auch darum:
> `_dmarc.freiraum.top  TXT  "v=DMARC1; p=none; rua=mailto:dmarc@freiraum.top; adkim=s; aspf=s; pct=100"`
>
> Vielen Dank.

---

## Wenn alles steht

Melden Sie sich; ich prüfe DKIM und DMARC im DNS nach und wiederhole die B2-Abnahme gegen
den echten Versand statt gegen den Testempfänger. Erst danach ist B2 vollständig abgenommen.

**Nicht vergessen:** Die SPF-Kette endet auf `-all` und erlaubt heute ausschließlich
Bytecamp-Adressen. Solange der Versand über Bytecamp läuft, ist das genau richtig und muss
nicht angefasst werden. Sollte später ein anderer Dienst dazukommen, **muss die SPF-Kette
vorher erweitert werden** — sonst scheitert jede Mail beim Empfänger, ohne dass in FREIRAUM
ein Fehler sichtbar wird.
