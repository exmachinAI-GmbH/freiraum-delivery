# B1 · Abnahmeprotokoll — Installationsskript

| Feld | Wert |
|---|---|
| Datum | 02.08.2026 |
| Skript | `exmachinai/freiraum-delivery` · `install/01_betreiber_und_erstadmin.sql` |
| Umgebung | PostgreSQL 16 im Container, frische Datenbank `freiraum` |
| Grundlage | `freiraum_datamodel.sql` (v2.9) + `Migration_260801_tenant.sql` |
| Ergebnis | **bestanden** — Abnahmekriterium erfüllt, alle Negativfälle abgewiesen |

## 1 · Aufbau der Prüfumgebung

| Schritt | Ergebnis |
|---|---|
| DDL v2.9 eingespielt | 37 Tabellen · 11 Sichten · 4 Trigger — deckt sich mit dem Kanon |
| Migration 260801 angewendet | 4 Spalten (`avv_datum`, `avv_aktenzeichen`, `partner_baut`, `partner_setzt_um`) · 2 Bedingungen (`customer_needs_avv`, `partner_needs_aufgabe`) |

## 2 · Abnahmekriterium des Bauauftrags

```
SELECT count(*) FROM platform_admin WHERE status='AKTIV';   →  1
```

**Erfüllt.** Angelegt wurden:

| Objekt | Werte |
|---|---|
| Betreiber-Mandant | `kind=OPERATOR` · `legal_space=DE` · `invite_domain=exmachinai.com` · `invite_ttl_hours=24` · `processing_region=swedencentral` · **kein** Kunden-Code |
| Erst-Admin | `user_code=EXMA-ADM-0001` · `status=AKTIV` · `sealed=true` · `money_rights=false` · Adresse in der Betreiber-Domäne |
| Mitgliedschaft | `portal_code=EXMA` · Rolle *Plattform-Admin* · Geltungsbereich Betreiber |

## 3 · Negativfälle — alle abgewiesen

| Fall | Ergebnis |
|---|---|
| `sealed=true` zusammen mit `money_rights=true` | abgewiesen durch `actor_sealed_no_money` |
| Zweiter Lauf des Installationsskripts | bricht ab: „Es existiert bereits ein Betreiber-Mandant" |
| Löschen des letzten aktiven Plattform-Admins | abgewiesen durch `platform_admin_guard` |
| Einladung an eine fremde Domäne | abgewiesen: „Nur Adressen der Domaene @exmachinai.com sind zulaessig" |
| Einladung mit Frist über 24 h | abgewiesen: Gültigkeit überschritten |
| Adresse `x@evil-exmachinai.com` | abgewiesen — die Schranke greift auf die vollständige Domäne, nicht auf eine Teilzeichenkette |
| Einladung an die eigene Domäne | **angenommen** (Positivfall, zur Kontrolle) |

Nach allen Negativfällen: genau **eine** Zeile in `invitation` — die zulässige.

## 4 · Zwei Befunde aus dem Lauf

### B1-F1 · Die Negativfälle der Migration prüften nicht, was sie behaupteten

**Berichtigt am 02.08.2026 in `Migration_260801_tenant.sql`.**

Drei der vier mitgelieferten Negativfälle verwendeten die Codes `DE-ZN1`, `DE-ZN2` und
`DE-ZN4`. Diese enthalten Ziffern und scheitern deshalb bereits an `customer_code_fmt`
(`^DE-[A-Z]{3}$`) — **bevor** die eigentlich zu prüfende Bedingung erreicht wird. Sie hätten
„abgewiesen" gemeldet, ohne `customer_needs_avv` oder `partner_needs_aufgabe` je zu berühren:
ein bestandener Test, der nichts misst.

Mit formatgültigen Codes (`DE-ZNA`, `DE-ZNB`, `DE-ZND`) scheitern alle vier am richtigen
Grund; der Formatfall steht jetzt als eigener Fall N5. **Regel daraus:** Es genügt nicht zu
prüfen, *dass* ein Satz scheitert — zu prüfen ist, *an welcher Bedingung*.

### B1-F2 · Ein Kunden-Code lässt sich an einen Nicht-Kunden hängen

**Offen — Vorschlag für einen neuen offenen Punkt.**

`customer_needs_code` verlangt einen Kunden-Code bei `kind=CUSTOMER`, aber **keine Bedingung
verbietet ihn bei den anderen Arten.** Im Lauf ging durch:

```sql
UPDATE tenant SET customer_code='DE-AAA' WHERE kind='OPERATOR';   -- akzeptiert
```

Das widerspricht K02-G02 und hat eine unangenehme Nebenwirkung: Der Code `DE-AAA` wäre damit
verbraucht, obwohl er nach K02-M25 dem **ersten echten Kunden** zusteht. Die Wirkung ist
still — es entsteht keine Fehlermeldung, und die fortlaufende Vergabe stolpert erst beim
nächsten Kunden darüber.

Die Gegenmaßnahme wäre eine Bedingung in der Art
`CHECK (customer_code IS NULL OR kind = 'CUSTOMER')`, einzubringen über eine Migration —
das DDL in `v2.9_PIVOT/` ist eingefroren und wird nicht angefasst. Im Installationsskript
ist der Fall bereits vermieden: der Betreiber-Mandant wird ohne Kunden-Code angelegt.

## 5 · Was das Skript zusätzlich tut

Drei Vorprüfungen laufen **vor** der Anlage und brechen sonst ab: kein zweiter
Betreiber-Mandant (weil `sealed` nach K20-M21 unumkehrbar ist), Rolle *Plattform-Admin*
vorhanden, Migration angewendet. Das Abnahmekriterium wird **innerhalb derselben
Transaktion** geprüft — stimmt die Zahl nicht, entsteht gar nichts. Ein halb angelegter
Betreiber-Mandant wäre nicht zurückzunehmen.

## 6 · Was hiermit **nicht** nachgewiesen ist

Der Erst-Admin ist angelegt, aber **es hat sich noch niemand angemeldet** — das setzt B2
voraus. `status=AKTIV` ist bewusst gesetzt, damit der Zugang nicht am fehlenden
2FA-Durchlauf hängt; der Standardwert wäre `WARTET_2FA`.
