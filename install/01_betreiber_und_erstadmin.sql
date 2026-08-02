-- =====================================================================
--  FREIRAUM · B1 · Installationsskript
--  Betreiber-Mandant · Erst-Admin · Mitgliedschaft
--
--  Auftrag:  Bauauftrag_Pilot-Vorbedingungen.md, Abschnitt B1
--  Belege:   K02-M01/M02/M07/M08/M10 · K02-G02  (Mandant)
--            F09 · K20-M06 · K03-M04/M08        (Erst-Admin)
--            K20-M04/M05 · K20-G11              (Mitgliedschaft)
--  Entschieden 02.08.2026 (Founder): Plattform-Admins melden sich mit
--            @exmachinai.com an. Die Absenderdomaene der Einladungen
--            (freiraum.top) ist davon unabhaengig -- der Waechter prueft
--            ausschliesslich die EMPFAENGER-Adresse.
--
--  VORAUSSETZUNG: frische Datenbank mit freiraum_datamodel.sql und
--            Migration_260801_tenant.sql. Der Zustand `sealed` ist nach
--            K20-M21 unumkehrbar -- deshalb je Anlauf eine eigene Datenbank.
--
--  AUFRUF:   psql -v ON_ERROR_STOP=1 \
--                 -v admin_email=michael.veil@exmachinai.com \
--                 -v admin_name='Michael Veil' \
--                 -f install/01_betreiber_und_erstadmin.sql
-- =====================================================================

\set ON_ERROR_STOP on

-- Vorbelegung, falls die Aufrufparameter fehlen. Der Name ist absichtlich
-- erkennbar unecht: wer ihn im Bestand sieht, weiss, dass er nicht gesetzt wurde.
\if :{?admin_email} \else \set admin_email 'admin@exmachinai.com' \endif
\if :{?admin_name}  \else \set admin_name  'Erst-Admin (nicht gesetzt)' \endif

BEGIN;

-- ---------------------------------------------------------------------
-- 0 · Fail-closed: das Skript laeuft nur auf einer jungfraeulichen Datenbank.
--
--     Ein zweiter Lauf wuerde einen zweiten Betreiber-Mandanten anlegen --
--     und `sealed` ist unumkehrbar. Lieber hier abbrechen als spaeter
--     eine Datenbank wegwerfen.
-- ---------------------------------------------------------------------
DO $$
BEGIN
  IF EXISTS (SELECT 1 FROM tenant WHERE kind = 'OPERATOR') THEN
    RAISE EXCEPTION
      'Es existiert bereits ein Betreiber-Mandant. Dieses Skript laeuft nur '
      'auf einer frischen Datenbank (K20-M21: sealed ist unumkehrbar).';
  END IF;
  IF NOT EXISTS (SELECT 1 FROM role WHERE portal_code = 'EXMA'
                                      AND name = 'Plattform-Admin') THEN
    RAISE EXCEPTION
      'Die Rolle Plattform-Admin fehlt. Wurde freiraum_datamodel.sql '
      'vollstaendig eingespielt (SEED Release-1-Gate)?';
  END IF;
  IF NOT EXISTS (SELECT 1 FROM information_schema.columns
                  WHERE table_name = 'tenant' AND column_name = 'avv_datum') THEN
    RAISE EXCEPTION
      'Migration_260801_tenant.sql ist nicht angewendet.';
  END IF;
END $$;

-- ---------------------------------------------------------------------
-- 1 · Betreiber-Mandant
--
--     KEIN Kunden-Code: den traegt nach K02-G02 nur ein Kundenmandant, und
--     die fortlaufende Vergabe ab DE-AAA gilt ihm allein (K02-M25).
--     KEIN Vertragsnachweis: `customer_needs_avv` fordert ihn nur bei
--     kind = CUSTOMER -- der Betreiber schliesst mit sich selbst keinen.
--     KEINE Partneraufgabe: `partner_needs_aufgabe` verlangt sie nur bei
--     kind = PARTNER und verbietet sie sonst ausdruecklich.
-- ---------------------------------------------------------------------
INSERT INTO tenant (
  kind, name, legal_space,
  invite_domain,          -- Anmeldedomaene der Plattform-Admins
  invite_ttl_hours,       -- 24 h, Vorgabe des Bauauftrags
  processing_region,      -- EU-Residenz (F05)
  mfa_policy
) VALUES (
  'OPERATOR', 'exmachinAI GmbH', 'DE',
  'exmachinai.com',
  24,
  'swedencentral',
  'EMAIL_CODE'
);

-- ---------------------------------------------------------------------
-- 2 · Erst-Admin
--
--     sealed = true  ist Pflicht (F09, K20-M06) und unumkehrbar.
--     money_rights = false ist damit ZWINGEND: die Bedingung
--     `actor_sealed_no_money` weist die Kombination sealed+money ab.
--     status = AKTIV setzt den Erst-Admin bewusst ohne 2FA-Durchlauf;
--     der Standardwert waere WARTET_2FA, und dann kaeme niemand hinein,
--     bevor B2 steht.
-- ---------------------------------------------------------------------
INSERT INTO actor (
  tenant_id, user_code, email, display_name,
  mfa_method, status, sealed, money_rights, created_on
)
SELECT
  t.id, 'EXMA-ADM-0001', :'admin_email', :'admin_name',
  'EMAIL_CODE', 'AKTIV', true, false, CURRENT_DATE
FROM tenant t
WHERE t.kind = 'OPERATOR';

-- ---------------------------------------------------------------------
-- 3 · Mitgliedschaft im EXMA-Portal, Geltungsbereich Betreiber
--
--     Das EXMA-Portal kennt genau eine Rolle (Plattform-Admin, kein
--     Rechte-Baukasten). Der Geltungsbereich ist der Betreiber-Mandant.
-- ---------------------------------------------------------------------
INSERT INTO membership (actor_id, portal_code, role_id, tenant_scope)
SELECT a.id, 'EXMA', r.id, t.id
FROM actor a
CROSS JOIN role r
CROSS JOIN tenant t
WHERE a.user_code   = 'EXMA-ADM-0001'
  AND r.portal_code = 'EXMA' AND r.name = 'Plattform-Admin'
  AND t.kind        = 'OPERATOR';

-- ---------------------------------------------------------------------
-- 4 · Abnahmekriterium des Bauauftrags -- IN DERSELBEN TRANSAKTION.
--
--     Stimmt die Zahl nicht, wird nichts angelegt. Ein halb angelegter
--     Betreiber-Mandant waere wegen sealed nicht zurueckzunehmen.
-- ---------------------------------------------------------------------
DO $$
DECLARE n integer;
BEGIN
  SELECT count(*) INTO n FROM platform_admin WHERE status = 'AKTIV';
  IF n <> 1 THEN
    RAISE EXCEPTION 'Abnahme fehlgeschlagen: % aktive Plattform-Admins, erwartet genau 1', n;
  END IF;
END $$;

COMMIT;

\echo 'B1 angelegt. Abnahme:'
SELECT user_code, email, status, sealed, money_rights, reichweite, processing_region
  FROM platform_admin;
