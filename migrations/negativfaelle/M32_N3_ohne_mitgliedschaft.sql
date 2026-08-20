-- M32 · N3 · Ein Konto ohne Mitgliedschaft im Endnutzer-Portal
-- erwartet: STUFENWECHSEL: keine Mitgliedschaft im Endnutzer-Portal fuer diesen Mandanten
--
-- K05-M24: der Serverpfad prueft Konto, MITGLIEDSCHAFT, Rolle, Mandant und
-- Objektbezug. Die ausreichende Rolle ist nicht offen, sondern gesetzt: das
-- Endnutzer-Portal fuehrt in Release 1 genau eine (F08 ueber K14-G04 und
-- K20-M02; DDL Z. 685-687) -- die Rolle faellt deshalb mit der
-- Mitgliedschaft zusammen (T-4, gez. 19.08.2026).
--
-- ALLES UEBRIGE IST IN ORDNUNG: dasselbe Konto, derselbe Mandant, aktives
-- Konto, erlaubter Uebergang. Es fehlt allein die membership-Zeile.
BEGIN;

INSERT INTO tenant(id, kind, name, customer_code, legal_space)
VALUES ('b2000000-0000-4000-8000-000000000301'::uuid,'OPERATOR',
        'M32-N3 Pruefmandant','DE-QNE','DE');

INSERT INTO actor(id, tenant_id, email, display_name, status)
VALUES ('b2000000-0000-4000-8000-000000000302'::uuid,
        'b2000000-0000-4000-8000-000000000301'::uuid,
        'm32-n3@pruefung.invalid','M32-N3 Konto','AKTIV');

INSERT INTO fit_check(id, tenant_id, actor_id, outcome, completed_at, retention_class,
                      zweck_bewertung_menschen, zweck_verbotene_praktik,
                      zweckbestimmung_erklaert_am)
VALUES ('b2000000-0000-4000-8000-000000000303'::uuid,
        'b2000000-0000-4000-8000-000000000301'::uuid,
        'b2000000-0000-4000-8000-000000000302'::uuid,
        'GEEIGNET', now(), 'KI_NACHWEIS', false, false, now());

SELECT create_app_after_fit(
  'b2000000-0000-4000-8000-000000000301'::uuid,'M32-N3 Anwendung',
  'b2000000-0000-4000-8000-000000000303'::uuid,
  'b2000000-0000-4000-8000-000000000302'::uuid);

SELECT set_journey_phase(
  (SELECT id FROM app WHERE fit_check_id='b2000000-0000-4000-8000-000000000303'::uuid),
  'INTERVIEW'::journey_phase,
  'b2000000-0000-4000-8000-000000000302'::uuid);

ROLLBACK;
