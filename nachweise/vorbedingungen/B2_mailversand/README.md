# B2 · E-Mail-Versand — Nachweisablage

> **Der geltende Stand ist der Nachtrag vom 4. August 2026** (`…/entscheidungsvorlagen/final_entscheidung-pflichtangaben/260804_Nachtrag_Bytecamp.md`). Die Dateien `B2_DNS_Stand_260802.md` und `B2_Anbieterantwort_260803.md` in diesem Ordner sind **überholt** und tragen seit dem 05.08.2026 einen Vermerk. Wer hier nachschlägt, ohne den Nachtrag zu kennen, liest den Stand vor der Lösung.


**Status:** noch nicht begonnen. Auftrag: `arbeit/Bauauftrag_Pilot-Vorbedingungen.md`, Abschnitt B2.

## Entschieden (Founder, 02.08.2026)

**Absenderdomäne ist `freiraum.top`** — jeder Einladungslink geht von dort aus.

**Versand läuft über Bytecamp** (der bestehende Anbieter der Domäne). Damit ist an der
SPF-Kette nichts zu ändern: sie erlaubt bereits genau diese Adressen. Ein externer Dienst
hätte zwingend eine SPF-Erweiterung vorausgesetzt, sonst wäre jede Mail beim Empfänger
gescheitert.

Offen bleibt der **Zustellnachweis** — ohne ihn ist eine fehlgeschlagene Einladung nicht
von einer nicht gesendeten zu unterscheiden.

### Befund der Domänenprüfung vom 02.08.2026

| Prüfung | Stand |
|---|---|
| Registrierung | aktiv seit 07.07.2026, Ablauf 07.07.2027 (Key Systems) |
| Nameserver · Mail | `ns1/ns2.bytecamp.net` · MX `mail2.bytecamp.net` — Postfach vorhanden |
| SPF | `v=spf1 ip4:212.204.60.0/24 -all` — **streng**: nur Bytecamp-Adressen dürfen senden |
| DKIM | **kein Eintrag gefunden** (Selektoren default, dkim, mail, selector1/2, k1) |
| DMARC | **kein Eintrag** unter `_dmarc.freiraum.top` |

**Zwei Punkte, die vor dem ersten Versand zu klären sind:**

1. **Das `-all` in der SPF-Kette ist eine harte Sperre.** Wird der Versand über einen anderen
   Dienst als Bytecamp geführt — etwa Azure Communication Services — scheitert jede Mail an
   der SPF-Prüfung des Empfängers, bevor irgendein Fehler in FREIRAUM sichtbar würde. Entweder
   der Versand läuft über Bytecamp-SMTP, oder die SPF-Kette wird vorher um den gewählten
   Dienst ergänzt. Diese Entscheidung fällt zusammen mit der Wahl des Versanddienstes.
2. **Ohne DKIM und DMARC** landen Einladungen bei strengen Empfängern im Spam oder werden
   verworfen. Für einen Anmeldecode, zu dem es ausdrücklich **kein Ersatzverfahren** gibt
   (K03), ist das kein Randfall — es ist der Ausfall der einzigen Anmeldemöglichkeit.

Beides ist Bauarbeit an der Domäne, nicht am Produkt — gehört aber in das Abnahmeprotokoll,
sonst ist eine nicht zugestellte Einladung später nicht von einer nicht gesendeten zu
unterscheiden.

**EU-Verarbeitung (F05):** Bytecamp ist ein deutscher Anbieter — die Prüfung, ob damit die
Anforderung erfüllt ist, gehört mit Beleg in `B2_Dienst-Entscheidung.md`.

Hierher gehören, sobald gebaut wird:

| Datei | Inhalt |
|---|---|
| `B2_Dienst-Entscheidung.md` | Welcher Versanddienst, welche Absenderdomäne, warum — mit Beleg der EU-Verarbeitung (F05; ein Anbieter außerhalb bricht K13) |
| `B2_Zustellnachweis-Konzept.md` | Wie Zustellung protokolliert wird und was bei Fehlschlag passiert (K20-M13 kennt das erneute Senden, nicht den Zustellfehler) |
| `B2_Abnahmeprotokoll.md` | Nachweis: zwei Anmeldungen hintereinander → zwei frische Codes; erster Code nach Verwendung wertlos · Codefrist 10 Min/einmalig (K03-M15) |

Konfiguration/Code im Repo `exmachinai/freiraum-delivery` unter `mail/`.
**Keine Schlüssel oder Zugänge in diesem Ordner** — nur Verweise auf Key Vault/Passwortmanager.
