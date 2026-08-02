# mail/ · B2 E-Mail-Versand

**Stand 02.08.2026: gegen einen lokalen Testempfänger abgenommen, echter Versand offen.**
Protokoll: Dropbox `03_AGENT_HARNESS_CODING/10_PILOT_VORBEDINGUNGEN/B2_Mailversand/`.

## Entschieden (Founder, 02.08.2026)

Absenderdomäne `freiraum.top`, Versand über **Bytecamp** — damit bleibt die SPF-Kette
unangetastet; sie endet auf `-all` und erlaubt nur den Hausanbieter.

## Aufruf

```bash
export FREIRAUM_DSN='postgresql://…'
export FREIRAUM_SMTP_HOST=… FREIRAUM_SMTP_USER=… FREIRAUM_SMTP_PASS=… FREIRAUM_SMTP_TLS=1
python3 mail/versand.py code      --an michael.veil@exmachinai.com
python3 mail/versand.py einladung --an anna.muster@zaa.freiraum.top --link https://…
```

Ohne gesetzte Umgebung geht der Versand an `localhost:1025` — den Testempfänger.
**Keine Zugangsdaten im Repo**; `.env*` ist gitignored.

## Regeln, die hier durchgesetzt werden

1. Der Code entsteht kryptografisch, wird **vor** dem Versand als Streuwert hinterlegt und
   nie im Klartext gespeichert (K03-M15).
2. Die Zehn-Minuten-Frist setzt die **Datenbank**, nicht der Aufrufer — er kann sie nicht
   verlängern.
3. Ein neuer Code entwertet ältere automatisch (Auslöser), und ein Teil-Index lässt je Konto
   nur einen offenen Code zu.
4. Jeder Versand wird protokolliert, auch der gescheiterte. Ohne Nachweis ist eine
   fehlgeschlagene Einladung nicht von einer nicht gesendeten zu unterscheiden.
5. Der Absender wird **vor** dem Verbindungsaufbau gegen die erlaubte Domäne geprüft.
6. Scheitert der Versand, wird der eben ausgestellte Code entwertet — ein zugestellter Code,
   den niemand bekommen hat, wäre schlimmer als keiner.

## Noch offen

Bytecamp-Zugangsdaten · **DKIM und DMARC für `freiraum.top`** (beide fehlen) ·
Bounce-Verarbeitung, damit aus *übergeben* ein *zugestellt* wird.
