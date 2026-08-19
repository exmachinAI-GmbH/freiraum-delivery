-- M32 · N2 · Ein Konto eines fremden Mandanten wechselt die Stufe
-- erwartet: STUFENWECHSEL: das Konto gehoert Mandant
--
-- K01-M15: jeder Zugriff ist auf den Mandanten der angemeldeten Sitzung
-- eingeschraenkt; K05-M24 nennt den Mandanten als eine der fuenf Pruefungen
-- des Serverpfads. Ein Konto, das anderswo hingehoert, wechselt hier nichts.
--
-- ALLES UEBRIGE IST IN ORDNUNG: das fremde Konto ist AKTIV und hat in SEINEM
-- Mandanten eine Mitgliedschaft; die Anwendung steht in ORIENTIERUNG, das
-- Ziel INTERVIEW ist der erlaubte Uebergang. Abweichend ist allein der
-- Mandant -- die Pruefung des Mandanten steht VOR der Mitgliedschaft, damit
-- der Fall an seiner eigenen Bedingung scheitert und nicht an der naechsten.
BEGIN;

INSERT INTO tenant(id, kind, name, customer_code, legal_space) VALUES
 ('b2000000-0000-4000-8000-000000000201'::uuid,'OPERATOR','M32-N2 Mandant A','DE-QNC','DE'),
 ('b2000000-0000-4000-8000-000000000204'::uuid,'CUSTOMER','M32-N2 Mandant B','DE-QND','DE');

INSERT INTO actor(id, tenant_id, email, display_name, status) VALUES
 ('b2000000-0000-4000-8000-000000000202'::uuid,'b2000000-0000-4000-8000-000000000201'::uuid,
  'm32-n2-a@pruefung.invalid','M32-N2 Konto A','AKTIV'),
 ('b2000000-0000-4000-8000-000000000205'::uuid,'b2000000-0000-4000-8000-000000000204'::uuid,
  'm32-n2-b@pruefung.invalid','M32-N2 Konto B','AKTIV');

INSERT INTO membership(actor_id, portal_code, role_id, tenant_scope)
SELECT 'b2000000-0000-4000-8000-000000000205'::uuid,'ENDUSER', r.id,
       'b2000000-0000-4000-8000-000000000204'::uuid
  FROM role r WHERE r.portal_code='ENDUSER';

INSERT INTO fit_check(id, tenant_id, actor_id, outcome, completed_at, retention_class,
                      zweck_bewertung_menschen, zweck_verbotene_praktik,
                      zweckbestimmung_erklaert_am)
VALUES ('b2000000-0000-4000-8000-000000000203'::uuid,
        'b2000000-0000-4000-8000-000000000201'::uuid,
        'b2000000-0000-4000-8000-000000000202'::uuid,
        'GEEIGNET', now(), 'KI_NACHWEIS', false, false, now());

SELECT create_app_after_fit(
  'b2000000-0000-4000-8000-000000000201'::uuid,'M32-N2 Anwendung',
  'b2000000-0000-4000-8000-000000000203'::uuid,
  'b2000000-0000-4000-8000-000000000202'::uuid);

-- Konto B greift nach der Anwendung von Mandant A.
SELECT set_journey_phase(
  (SELECT id FROM app WHERE fit_check_id='b2000000-0000-4000-8000-000000000203'::uuid),
  'INTERVIEW'::journey_phase,
  'b2000000-0000-4000-8000-000000000205'::uuid);

ROLLBACK;
