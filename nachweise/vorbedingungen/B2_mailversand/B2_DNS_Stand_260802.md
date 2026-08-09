# B2 · DNS- und Versandstand `freiraum.top`

> ## ⚠ ÜBERHOLT AM 4. AUGUST 2026
>
> **Diese Datei gibt den Stand vom 2. August 2026 wieder. Bytecamp hat am 4. August
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



**Erhoben am 02.08.2026 gegen das öffentliche DNS**, nach der Bestellung beim Anbieter und
dem selbst gesetzten DMARC-Eintrag des Founders.

## 1 · Was jetzt steht

| Prüfung | Stand | Bewertung |
|---|---|---|
| **SPF** | `v=spf1 ip4:212.204.60.0/24 -all` | steht · streng, erlaubt nur den Hausanbieter |
| **DMARC** | `v=DMARC1; p=none; rua=mailto:dmarc@freiraum.top; adkim=s; aspf=s; pct=100` | **neu gesetzt** · vollständig, inklusive strenger Zuordnung |
| **DKIM** | Selektor `20140709`, CNAME auf `20140709._domainkey.bytecamp.net`, löst auf einen gültigen `v=DKIM1`-Schlüssel auf | **war bereits vorhanden** · **1024 Bit** |
| **MX `zaa.freiraum.top`** | kein Eintrag | offen — beim Anbieter beauftragt |
| **Webhosting-Paket** | Domäne läuft als reine Registrierung | offen — beim Anbieter beauftragt, Voraussetzung für Postfächer |

## 2 · Berichtigung eines eigenen Befunds

Im Abnahmeprotokoll vom selben Tag steht *„DKIM: kein Eintrag gefunden"*. **Das war zu
kurz gegriffen.** Geprüft wurden nur die geläufigen Selektoren — `default`, `dkim`, `mail`,
`selector1`, `selector2`, `k1`. Der tatsächliche Selektor heißt `20140709` und ist damit
durch kein Erraten zu finden.

Richtig hätte die Aussage lauten müssen: *unter den üblichen Selektoren kein Schlüssel
auffindbar; der tatsächliche Selektor ist beim Anbieter zu erfragen.* Ein Selektor lässt sich
nicht aufzählen — DKIM sieht dafür keinen Weg vor. Wer ihn nicht kennt, muss fragen.

## 3 · Der Punkt, der jetzt zählt: die strenge Zuordnung

Der DMARC-Eintrag trägt `adkim=s` und `aspf=s` — **strenge** Zuordnung. Das heißt: Die
Domäne, mit der signiert wird, muss **exakt** `freiraum.top` sein; `bytecamp.net` genügt
nicht, auch nicht als übergeordnete Domäne.

Der Schlüssel liegt als CNAME auf den Anbieter. Das ist üblich und für sich unbedenklich —
entscheidend ist allein, **welchen `d=`-Wert die Signatur trägt**:

| `d=`-Wert der Signatur | Wirkung bei `adkim=s` |
|---|---|
| `d=freiraum.top` | Zuordnung greift — alles richtig |
| `d=bytecamp.net` | Zuordnung **scheitert**, DKIM zählt nicht für DMARC |

Genau danach ist beim Anbieter gefragt worden. **Solange die Antwort aussteht, muss
`p=none` stehen bleiben.** Bei `p=none` passiert nichts weiter als Berichte — bei
`p=quarantine` oder `p=reject` und gescheiterter Zuordnung wären die Anmeldecodes weg, und
zwar alle auf einmal. Dasselbe gilt für `aspf=s`: Führt der Anbieter einen eigenen
Rückweg-Absender, scheitert auch die SPF-Zuordnung.

**Reihenfolge daher:** Antwort des Anbieters abwarten → eine Woche DMARC-Berichte lesen →
erst dann verschärfen. Die Berichte gehen an `dmarc@freiraum.top`; dieses Postfach muss es
also geben, sonst prüft niemand nach.

## 4 · Schlüssellänge

Der veröffentlichte Schlüssel ist **1024 Bit** (nachgerechnet: 162 Byte DER-Struktur; ein
2048-Bit-Schlüssel ergäbe rund 294 Byte). Das wird heute noch überall akzeptiert, gilt aber
als schwach; 2048 Bit ist die Empfehlung. Beim Anbieter angefragt — kein Blocker für den
Pilot, aber vor dem ersten echten Kunden zu erledigen.

Ebenfalls angefragt und wichtig: **ob die Signierung die Umstellung auf Webhosting
übersteht.** Ein Wechsel des Pakets kann die Mailkonfiguration zurücksetzen.

## 5 · Was daraus für die B2-Abnahme folgt

Die Abnahme gegen den Testempfänger steht (siehe `B2_Abnahmeprotokoll.md`). Für die Abnahme
gegen den echten Versand fehlen noch:

1. Webhosting aktiv, Postfächer `dmarc@freiraum.top` und `einladung@zaa.freiraum.top` angelegt
2. MX-Eintrag für `zaa.freiraum.top`
3. SMTP-Zugangsdaten im Passwortmanager
4. Bestätigung des `d=`-Werts durch den Anbieter

Dann wiederhole ich denselben Lauf mit gesetzten Umgebungsvariablen und prüfe zusätzlich am
zugestellten Kopf, ob `DKIM-Signature` mit `d=freiraum.top` erscheint und ob DMARC in der
Empfängerprüfung greift.

## 6 · Nachtrag — erneute Prüfung 02.08.2026, ca. 14:50

Gegen das öffentliche DNS und die Dienste selbst geprüft. **Die Bestellung wird sichtbar
ausgeführt:**

| Prüfung | Mittag | Jetzt |
|---|---|---|
| Webhosting | reine Registrierung | **aktiv** — `http://freiraum.top/` antwortet mit 200 |
| MX `freiraum.top` | — (nicht erhoben) | **`20 mail2.bytecamp.net`** — die Hauptdomäne nimmt Mail an |
| MX `zaa.freiraum.top` | kein Eintrag | **weiterhin kein Eintrag** — bleibt offen |
| SPF / DMARC / DKIM | wie erhoben | unverändert |

**Postfach `dmarc@freiraum.top`:** von außen nicht feststellbar. Eine RCPT-Probe gegen
`mail2.bytecamp.net` scheiterte bereits an der HELO-Prüfung des Servers (450, Host not
found) — das ist eine Aussage über die Probe, nicht über das Postfach. Ob die Postfächer
existieren, zeigt erst die Anmeldung beim Anbieter oder der erste echte Versand.

**Für die Rest-Abnahme B2 fehlen damit noch:** MX für `zaa.freiraum.top` · Postfächer
angelegt und Zugänge im Passwortmanager · Bestätigung des `d=`-Werts. Sobald die
SMTP-Zugangsdaten vorliegen, kann die Abnahme gegen den echten Versand sofort laufen.
