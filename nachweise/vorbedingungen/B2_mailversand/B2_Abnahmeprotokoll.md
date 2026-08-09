# B2 · Abnahmeprotokoll — E-Mail-Versand

| Feld | Wert |
|---|---|
| Datum | 02.08.2026 |
| Code | `exmachinai/freiraum-delivery` · `mail/versand.py` · `migrations/260802_anmeldecode.sql` |
| Umgebung | PostgreSQL 16 + Mailpit als Testempfänger, beide im Container |
| Ergebnis | **Abnahmekriterium erfüllt** gegen den Testempfänger · **echter Versand noch offen** |
| Nachtrag | 02.08.2026 nachmittags: DNS- und Anbieterstand ergänzt (Abschnitt 5), Befund zu DKIM berichtigt |

## 1 · Abnahmekriterium des Bauauftrags

> Der Erst-Admin meldet sich zweimal hintereinander an und erhält zweimal einen neuen Code.
> Der erste Code ist nach der ersten Verwendung wertlos.

| Prüfung | Ergebnis |
|---|---|
| Zwei Anmeldungen, zwei Mails | 2 Nachrichten im Postfach, Absender `noreply@freiraum.top` |
| Zwei **verschiedene** Codes | zwei verschiedene Streuwerte in `login_code` |
| Erster Code nach Ausstellung des zweiten | **ENTWERTET** — automatisch durch Auslöser, nicht durch den Aufrufer |
| Offene Codes je Konto | genau 1 — durchgesetzt durch einen Teil-Index, nicht durch Absicht |
| Sechsstelliger Code in der Mail | ja |
| Klartext des Codes in der Datenbank | **nein** — nur der Prüfwert (K03-M15) |
| Zustellnachweis je Versand | 2 Zeilen in `mail_delivery`, Status UEBERGEBEN, mit Kennung des Dienstes |

## 2 · Abweisungen — beide greifen

| Fall | Ergebnis |
|---|---|
| Code für ein unbekanntes Konto | abgelehnt, kein Versand, kein Datenbankeintrag |
| Absender außerhalb von `freiraum.top` | abgelehnt mit Begründung der SPF-Lage — **vor** dem Versand |

Der zweite Fall ist der wichtigere: Eine Mail von einer fremden Absenderdomäne würde
hinausgehen und beim Empfänger still an der SPF-Prüfung scheitern. Der Fehler sähe aus wie
ein Erfolg. Deshalb prüft das Werkzeug den Absender selbst, bevor es die Verbindung öffnet.

## 3 · Der Befund, der B2 zuerst blockiert hat

**Für den Anmeldecode gibt es im Datenmodell keinen Ort.**

Vier Klauseln aus K03 verlangen dauerhaften Zustand, den keine der 37 Tabellen führt:

| Klausel | Verlangt | Im Schema |
|---|---|---|
| K03-M15 | Code zehn Minuten und **genau einmal** gültig; ein neuer entwertet alle älteren; „gespeichert wird nur sein kryptografischer Prüfwert" | **kein Feld** |
| K03-M16 | nach fünf Fehlversuchen ungültig, 15 Minuten Drosselung | **kein Zähler** |
| K03-M17 | Sitzung endet nach 30 Minuten Untätigkeit, spätestens nach acht Stunden | **keine Sitzung** |
| K03-M18 | heikle Änderungen nur, wenn die Anmeldung höchstens zehn Minuten zurückliegt | **kein Zeitpunkt je Sitzung** |

Die einzige verwandte Stelle ist `invitation.token_hash` — das ist der **Einmal-Link** zur
Kontoanlage, nicht der Code bei **jeder** Anmeldung. `actor.last_login_at` ist ein einzelner
Wert und kennt keine Sitzung.

Das Abnahmekriterium von B2 ist ohne diese Speicherung nicht nachweisbar. Deshalb liegt als
**Vorschlag** `migrations/260802_anmeldecode.sql` bei: Tabelle `login_code` (Prüfwert, Frist,
Verbrauch, Entwertung, Fehlversuche) und `mail_delivery` (Zustellnachweis). Das eingefrorene
DDL in `v2.9_PIVOT/` bleibt unberührt — dasselbe Vorgehen wie bei der Migration vom 01.08.

Die Negativfälle der Migration laufen alle und scheitern **jeder an seiner eigenen**
Bedingung: Frist über zehn Minuten, sechster Fehlversuch, Fehlschlag ohne Begründung.

## 4 · Was der erste Lauf am Entwurf geändert hat

Die Frist stand zuerst beim Aufrufer: Er rechnete `jetzt + 10 Minuten`, die Datenbank
stempelte `issued_at` selbst — drei Millisekunden Versatz, und die Bedingung schlug zu. Der
Versatz war das kleinere Problem. Das größere: **solange der Aufrufer die Frist mitgibt, kann
er eine längere mitgeben.** Jetzt setzt die Datenbank sie, und niemand kann sie verlängern.

## 5 · DNS- und Anbieterstand — nachgetragen 02.08.2026, nachmittags

Nach der Bestellung beim Anbieter und dem selbst gesetzten DMARC-Eintrag des Founders erneut
gegen das öffentliche DNS geprüft. Ausführlich in `B2_DNS_Stand_260802.md`.

| Prüfung | Stand | |
|---|---|---|
| SPF | `v=spf1 ip4:212.204.60.0/24 -all` | steht |
| **DMARC** | `v=DMARC1; p=none; rua=mailto:dmarc@freiraum.top; adkim=s; aspf=s; pct=100` | **neu gesetzt · vollständig** |
| **DKIM** | Selektor `20140709` → CNAME auf `20140709._domainkey.bytecamp.net`, gültiger `v=DKIM1`-Schlüssel, **1024 Bit** | **war bereits vorhanden** |
| MX `zaa.freiraum.top` | kein Eintrag | offen, beauftragt |
| Webhosting-Paket | Domäne läuft als reine Registrierung ohne Hosting | offen, beauftragt — Voraussetzung für die Postfächer |

### Berichtigung des Befunds aus Abschnitt 3

Die frühere Fassung dieses Protokolls sagte *„DKIM: kein Eintrag gefunden"*. **Das war zu
kurz gegriffen.** Geprüft wurden nur die geläufigen Selektoren (`default`, `dkim`, `mail`,
`selector1`, `selector2`, `k1`). Der tatsächliche Selektor heißt `20140709` — durch Raten
nicht auffindbar, und DKIM sieht keinen Weg vor, Selektoren aufzuzählen. Richtig wäre
gewesen: *unter den üblichen Selektoren kein Schlüssel auffindbar; der tatsächliche Selektor
ist beim Anbieter zu erfragen.* Der Founder hat genau das getan.

### Der Punkt, der jetzt über Erfolg oder Ausfall entscheidet

Der DMARC-Eintrag verlangt **strenge Zuordnung** (`adkim=s`, `aspf=s`). Die Signaturdomäne
muss dann exakt `freiraum.top` lauten; `bytecamp.net` genügt nicht, auch nicht als
übergeordnete Domäne. Der Schlüssel liegt als CNAME beim Anbieter — das ist üblich und für
sich unbedenklich. Entscheidend ist allein der `d=`-Wert der Signatur:

| `d=` der Signatur | Wirkung bei `adkim=s` |
|---|---|
| `d=freiraum.top` | Zuordnung greift |
| `d=bytecamp.net` | Zuordnung **scheitert** — DKIM zählt für DMARC nicht mit |

Danach ist beim Anbieter gefragt. **Bis zur Antwort bleibt `p=none` stehen.** Bei `p=none`
entstehen nur Berichte; bei `p=quarantine` oder `p=reject` und gescheiterter Zuordnung wären
die Anmeldecodes weg — alle auf einmal, ohne Ersatzverfahren (K03). Reihenfolge: Antwort
abwarten → eine Woche Berichte lesen → erst dann verschärfen.

## 6 · Was hiermit **nicht** nachgewiesen ist

**Der Versand lief gegen einen lokalen Testempfänger, nicht gegen den echten Dienst.**
Offen bleiben:

1. **Webhosting aktiv** und die Postfächer `dmarc@freiraum.top` sowie
   `einladung@zaa.freiraum.top` angelegt. Ohne das Berichtspostfach liest die DMARC-Berichte
   niemand — dann ist der Eintrag Zierde.
2. **MX-Eintrag für `zaa.freiraum.top`.**
3. **SMTP-Zugangsdaten** im Passwortmanager (nicht im Repo). Danach dieselbe Abnahme mit
   `FREIRAUM_SMTP_HOST/USER/PASS` und `FREIRAUM_SMTP_TLS=1`.
4. **Bestätigung des `d=`-Werts** durch den Anbieter, dazu die Zusage, dass die Signierung
   die Umstellung auf Webhosting übersteht — ein Paketwechsel kann die Mailkonfiguration
   zurücksetzen.
5. **Schlüssellänge 2048 Bit** statt der heutigen 1024. Kein Blocker für den Pilot, aber vor
   dem ersten echten Kunden zu erledigen.
6. **Zustellung ≠ Übergabe.** `mail_delivery` belegt, dass der Versanddienst die Mail
   angenommen hat. Ob sie im Postfach ankam, weiß erst ein Rückkanal des Anbieters
   (Bounce-Verarbeitung). Bis dahin ist der Nachweis ehrlich benannt: *übergeben*.
7. **EU-Verarbeitung (F05)** ist mit einem deutschen Anbieter plausibel, aber der Beleg
   gehört mit Vertragsstand in `B2_Dienst-Entscheidung.md`.

Bei der Wiederholung gegen den echten Versand wird zusätzlich am zugestellten Kopf geprüft,
ob `DKIM-Signature` mit `d=freiraum.top` erscheint und ob die DMARC-Auswertung des Empfängers
greift.
