# install/ · B1 Installationsskript

**Noch nicht begonnen.** Auftrag: Bauauftrag B1 (Konzeptfabrik).

Legt in einer frischen Datenbank an:
1. Betreiber-Mandant — `kind=OPERATOR`, `legal_space=DE`, `invite_domain`=Betreiber-Domäne,
   `processing_region=swedencentral` (vorbelegt), `invite_ttl_hours=24`, **kein** Kunden-Code
   (K02-M01/M02/M07/M08/M10 · K02-G02)
2. Erst-Admin — `user_code=EXMA-ADM-0001`, `status=AKTIV`, `sealed=true`,
   `money_rights=false` (Bedingung `actor_sealed_no_money`!), E-Mail in der Betreiber-Domäne
   (F09 · K20-M06 · K03-M04/M08)
3. Mitgliedschaft — `portal_code=EXMA`, Rolle Plattform-Admin, Geltungsbereich Betreiber
   (K20-M04/M05 · K20-G11)

Abnahme: `SELECT count(*) FROM platform_admin WHERE status='AKTIV'` = 1.
Abnahmeprotokoll → Dropbox `03_AGENT_HARNESS_CODING/10_PILOT_VORBEDINGUNGEN/B1_Installation/`.
