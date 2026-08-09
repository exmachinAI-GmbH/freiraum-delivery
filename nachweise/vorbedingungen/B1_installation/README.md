# B1 · Installationsskript — Nachweisablage

**Status:** noch nicht begonnen. Auftrag: `arbeit/Bauauftrag_Pilot-Vorbedingungen.md`, Abschnitt B1.

## Entschieden (Founder, 02.08.2026)

**Plattform-Admins melden sich mit `@exmachinai.com` an.** Der Betreiber-Mandant trägt also
`invite_domain = 'exmachinai.com'`, und die Adresse des Erst-Admins `EXMA-ADM-0001` liegt in
dieser Domäne. Das entspricht dem alten Build (`EXMA_DOM = 'exmachinai.com'`).

**Nicht verwechseln:** `freiraum.top` ist die **Absender**domäne der Einladungen (B2). Die
Anmeldedomäne der Plattform-Admins ist davon unabhängig — der Wächter prüft ausschließlich
die Empfängeradresse gegen die `invite_domain` des jeweiligen Mandanten.

Der Pilot-Kundenmandant heißt **Demobank** und trägt den Code `DE-ZAA`
(neu gezeichnet 02.08.2026, Fassung v2 der Vergabe-Entscheidungsvorlage).

Hierher gehören, sobald gebaut wird:

| Datei | Inhalt |
|---|---|
| `B1_Anlage-Doku.md` | Was das Skript anlegt (Betreiber-Mandant, Erst-Admin `EXMA-ADM-0001`, Mitgliedschaft) und mit welchen Werten |
| `B1_Abnahmeprotokoll.md` | Nachweis: `SELECT count(*) FROM platform_admin WHERE status='AKTIV'` = 1 · Datum, Datenbank, Prüfer |

Der Skript-Code selbst liegt im Repo `exmachinai/freiraum-delivery` unter `install/`.

**Merkposten aus dem Bauauftrag:** `sealed=true` + `money_rights=true` weist die Datenbank ab
(`actor_sealed_no_money`) — der Erst-Admin trägt `money_rights=false`. `sealed` ist unumkehrbar:
eigene Datenbank je Anlauf.
