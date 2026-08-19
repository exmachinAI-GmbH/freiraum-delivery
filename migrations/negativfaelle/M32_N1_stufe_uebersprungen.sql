-- M32 · N1 · Eine Stufe wird uebersprungen
-- erwartet: STUFENWECHSEL: ORIENTIERUNG nach UEBERSICHT ist kein Uebergang von M5
--
-- K05-D06 verbietet das Ueberspringen und das Anspringen von Stufen; K05-M08
-- und K05-M19 nennen die beiden Uebergaenge, die M5 kennt. Der Bildschirm
-- bietet den Sprung nicht an -- ein direkter Aufruf koennte ihn versuchen,
-- und genau dagegen prueft der Serverbefehl.
--
-- ALLES UEBRIGE IST IN ORDNUNG: Mandant, aktives Konto, Mitgliedschaft im
-- Endnutzer-Portal mit Reichweite auf denselben Mandanten, ein Eignungs-Check
-- auf GEEIGNET und eine ueber den einen Weg angelegte Anwendung in Stufe
-- ORIENTIERUNG. Abweichend ist allein das Ziel des Wechsels.
BEGIN;

INSERT INTO tenant(id, kind, name, customer_code, legal_space)
VALUES ('b2000000-0000-4000-8000-000000000101'::uuid, 'OPERATOR',
        'M32-N1 Pruefmandant', 'DE-QNB', 'DE');

INSERT INTO actor(id, tenant_id, email, display_name, status)
VALUES ('b2000000-0000-4000-8000-000000000102'::uuid,
        'b2000000-0000-4000-8000-000000000101'::uuid,
        'm32-n1@pruefung.invalid', 'M32-N1 Konto', 'AKTIV');

INSERT INTO membership(actor_id, portal_code, role_id, tenant_scope)
SELECT 'b2000000-0000-4000-8000-000000000102'::uuid, 'ENDUSER', r.id,
       'b2000000-0000-4000-8000-000000000101'::uuid
  FROM role r WHERE r.portal_code='ENDUSER';

INSERT INTO fit_check(id, tenant_id, actor_id, outcome, completed_at, retention_class,
                      zweck_bewertung_menschen, zweck_verbotene_praktik,
                      zweckbestimmung_erklaert_am)
VALUES ('b2000000-0000-4000-8000-000000000103'::uuid,
        'b2000000-0000-4000-8000-000000000101'::uuid,
        'b2000000-0000-4000-8000-000000000102'::uuid,
        'GEEIGNET', now(), 'KI_NACHWEIS', false, false, now());

SELECT create_app_after_fit(
  'b2000000-0000-4000-8000-000000000101'::uuid, 'M32-N1 Anwendung',
  'b2000000-0000-4000-8000-000000000103'::uuid,
  'b2000000-0000-4000-8000-000000000102'::uuid);

-- Der Sprung ueber INTERVIEW hinweg.
SELECT set_journey_phase(
  (SELECT id FROM app WHERE fit_check_id='b2000000-0000-4000-8000-000000000103'::uuid),
  'UEBERSICHT'::journey_phase,
  'b2000000-0000-4000-8000-000000000102'::uuid);

ROLLBACK;
