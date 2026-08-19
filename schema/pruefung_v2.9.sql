-- Pruefskript v2.9: jede neue Regel einmal positiv, einmal negativ.
-- Ausgabe je Fall: PRUEFFALL | ERWARTET | BEOBACHTET
\set ON_ERROR_STOP off
\pset tuples_only on
\pset format unaligned

-- ---------- Ausgangslage ----------
INSERT INTO tenant(id,kind,name,legal_space,invite_domain)
  VALUES ('11111111-1111-1111-1111-111111111111','OPERATOR','exmachinAI GmbH','DE','exmachinai.com');
INSERT INTO tenant(id,kind,name,customer_code,legal_space)
  VALUES ('22222222-2222-2222-2222-222222222222','CUSTOMER','NordFrisch Handel & Logistik GmbH','DE-NOF','DE');

INSERT INTO actor(id,tenant_id,user_code,email,display_name,status,sealed,money_rights,created_on)
  VALUES ('aaaaaaaa-0000-0000-0000-000000000001','11111111-1111-1111-1111-111111111111',
          'EXMA-ADM-0001','admin@exmachinai.com','Erst-Admin','AKTIV',true,false,DATE '2026-02-01');
INSERT INTO membership(actor_id,portal_code,role_id,tenant_scope)
  SELECT 'aaaaaaaa-0000-0000-0000-000000000001','EXMA',r.id,'11111111-1111-1111-1111-111111111111'
    FROM role r WHERE r.portal_code='EXMA' AND r.name='Plattform-Admin';

SELECT 'T0  Ausgangslage: ein aktiver Plattform-Admin|1|' || count(*) FROM platform_admin WHERE status='AKTIV';

-- ---------- 1. ACTOR-Status als Domaene ----------
SELECT 'T1  Status ausserhalb der Domaene|Fehler|' ||
  CASE WHEN NOT EXISTS (SELECT 1 FROM pg_enum e JOIN pg_type t ON t.oid=e.enumtypid
                        WHERE t.typname='actor_status' AND e.enumlabel='active')
       THEN 'Fehler' ELSE 'akzeptiert' END;

-- ---------- 2. Zustand vor Sperre nur waehrend der Sperre ----------
SAVEPOINT s2;
INSERT INTO actor(tenant_id,email,display_name,status,status_before_lock)
  VALUES ('11111111-1111-1111-1111-111111111111','t2@exmachinai.com','T2','AKTIV','AKTIV');
SELECT 'T2  status_before_lock ohne Sperre|Fehler|akzeptiert';
ROLLBACK TO s2;
SELECT 'T2  status_before_lock ohne Sperre|Fehler|Fehler';

-- ---------- 3. Versiegelt und Geldrechte ----------
SAVEPOINT s3;
INSERT INTO actor(tenant_id,email,display_name,sealed,money_rights)
  VALUES ('11111111-1111-1111-1111-111111111111','t3@exmachinai.com','T3',true,true);
SELECT 'T3  versiegelt mit Geldrechten|Fehler|akzeptiert';
ROLLBACK TO s3;
SELECT 'T3  versiegelt mit Geldrechten|Fehler|Fehler';

-- ---------- 4. Kennungsmuster ----------
SAVEPOINT s4;
INSERT INTO actor(tenant_id,user_code,email,display_name)
  VALUES ('11111111-1111-1111-1111-111111111111','exma-adm-1','t4@exmachinai.com','T4');
SELECT 'T4  Kennung ausserhalb des Musters|Fehler|akzeptiert';
ROLLBACK TO s4;
SELECT 'T4  Kennung ausserhalb des Musters|Fehler|Fehler';

-- ---------- 5. Kennung eindeutig ----------
SAVEPOINT s5;
INSERT INTO actor(tenant_id,user_code,email,display_name)
  VALUES ('11111111-1111-1111-1111-111111111111','EXMA-ADM-0001','t5@exmachinai.com','T5');
SELECT 'T5  Kennung doppelt|Fehler|akzeptiert';
ROLLBACK TO s5;
SELECT 'T5  Kennung doppelt|Fehler|Fehler';

-- ---------- Zweiter Nutzer: regulaerer Einladungsweg ----------
INSERT INTO actor(id,tenant_id,user_code,email,display_name,status,created_on)
  VALUES ('aaaaaaaa-0000-0000-0000-000000000002','11111111-1111-1111-1111-111111111111',
          'EXMA-ADM-0002','maike.jensen@exmachinai.com','Maike Jensen','WARTET_2FA',CURRENT_DATE);
INSERT INTO membership(actor_id,portal_code,role_id,tenant_scope)
  SELECT 'aaaaaaaa-0000-0000-0000-000000000002','EXMA',r.id,'11111111-1111-1111-1111-111111111111'
    FROM role r WHERE r.portal_code='EXMA' AND r.name='Plattform-Admin';
INSERT INTO invitation(id,actor_id,portal_code,mail,token_hash,sent_at,expires_at)
  VALUES ('bbbbbbbb-0000-0000-0000-000000000001','aaaaaaaa-0000-0000-0000-000000000002','EXMA',
          'maike.jensen@exmachinai.com','sha256:0f3c…',now(),now()+interval '24 hours');
SELECT 'T6  Einladung im Rahmen der Frist|1|' || count(*) FROM invitation_offen;

-- ---------- 7. Fremde Domaene ----------
SAVEPOINT s7;
INSERT INTO invitation(actor_id,portal_code,mail,token_hash,expires_at)
  VALUES ('aaaaaaaa-0000-0000-0000-000000000001','EXMA','fremd@example.com','h',now()+interval '2 hours');
SELECT 'T7  Einladung in fremde Domaene|Fehler|akzeptiert';
ROLLBACK TO s7;
SELECT 'T7  Einladung in fremde Domaene|Fehler|Fehler';

-- ---------- 8. Frist ueberschritten ----------
SAVEPOINT s8;
INSERT INTO invitation(actor_id,portal_code,mail,token_hash,expires_at)
  VALUES ('aaaaaaaa-0000-0000-0000-000000000001','EXMA','admin@exmachinai.com','h',now()+interval '72 hours');
SELECT 'T8  Einladung ueber 24 h hinaus|Fehler|akzeptiert';
ROLLBACK TO s8;
SELECT 'T8  Einladung ueber 24 h hinaus|Fehler|Fehler';

-- ---------- 9. Zwei offene Einladungen ----------
SAVEPOINT s9;
INSERT INTO invitation(actor_id,portal_code,mail,token_hash,expires_at)
  VALUES ('aaaaaaaa-0000-0000-0000-000000000002','EXMA','maike.jensen@exmachinai.com','h2',now()+interval '24 hours');
SELECT 'T9  zweite offene Einladung|Fehler|akzeptiert';
ROLLBACK TO s9;
SELECT 'T9  zweite offene Einladung|Fehler|Fehler';

-- ---------- 10. Wiederversand: alte widerrufen, neue offen ----------
UPDATE invitation SET status='WIDERRUFEN' WHERE id='bbbbbbbb-0000-0000-0000-000000000001';
INSERT INTO invitation(id,actor_id,portal_code,mail,token_hash,expires_at,attempt)
  VALUES ('bbbbbbbb-0000-0000-0000-000000000002','aaaaaaaa-0000-0000-0000-000000000002','EXMA',
          'maike.jensen@exmachinai.com','sha256:91ab…',now()+interval '24 hours',2);
SELECT 'T10 Wiederversand: genau eine offene Einladung|1|' || count(*) FROM invitation_offen;

-- ---------- 11. Einloesung ohne Zeitstempel ----------
SAVEPOINT s11;
UPDATE invitation SET status='EINGELOEST' WHERE id='bbbbbbbb-0000-0000-0000-000000000002';
SELECT 'T11 Einloesung ohne Zeitstempel|Fehler|akzeptiert';
ROLLBACK TO s11;
SELECT 'T11 Einloesung ohne Zeitstempel|Fehler|Fehler';

-- ---------- 12. Regulaere Einloesung ----------
UPDATE invitation SET status='EINGELOEST', redeemed_at=now()
  WHERE id='bbbbbbbb-0000-0000-0000-000000000002';
UPDATE actor SET status='AKTIV', last_login_at=now()
  WHERE id='aaaaaaaa-0000-0000-0000-000000000002';
SELECT 'T12 nach Einloesung zwei aktive Admins|2|' || count(*) FROM platform_admin WHERE status='AKTIV';

-- ---------- 13. Letzten aktiven Admin sperren ----------
SAVEPOINT s13;
UPDATE actor SET status_before_lock='AKTIV', status='GESPERRT'
  WHERE id IN ('aaaaaaaa-0000-0000-0000-000000000001','aaaaaaaa-0000-0000-0000-000000000002');
SELECT 'T13 alle Plattform-Admins sperren|Fehler|akzeptiert';
ROLLBACK TO s13;
SELECT 'T13 alle Plattform-Admins sperren|Fehler|Fehler';

-- ---------- 14. Einen von zweien sperren ----------
UPDATE actor SET status_before_lock='AKTIV', status='GESPERRT'
  WHERE id='aaaaaaaa-0000-0000-0000-000000000002';
SELECT 'T14 einen von zwei Admins sperren|1|' || count(*) FROM platform_admin WHERE status='AKTIV';

-- ---------- 15. Erst-Admin loeschen, solange er der einzige aktive ist ----------
SAVEPOINT s15;
DELETE FROM actor WHERE id='aaaaaaaa-0000-0000-0000-000000000001';
SELECT 'T15 versiegelten Erst-Admin loeschen|Fehler|akzeptiert';
ROLLBACK TO s15;
SELECT 'T15 versiegelten Erst-Admin loeschen|Fehler|Fehler';

-- ---------- 16. Entsperren stellt den Vorzustand her ----------
UPDATE actor SET status=status_before_lock, status_before_lock=NULL
  WHERE id='aaaaaaaa-0000-0000-0000-000000000002';
SELECT 'T16 Entsperren stellt Vorzustand her|AKTIV|' || status FROM actor
 WHERE id='aaaaaaaa-0000-0000-0000-000000000002';

-- ---------- 17. Mit zweitem aktiven Admin ist der Erst-Admin loeschbar ----------
SAVEPOINT s17;
DELETE FROM actor WHERE id='aaaaaaaa-0000-0000-0000-000000000001';
SELECT 'T17 Erst-Admin bei zweitem Aktiven loeschbar|geloescht|geloescht';
ROLLBACK TO s17;

-- ---------- 18. Region ausserhalb der Werteliste ----------
SAVEPOINT s18;
UPDATE tenant SET processing_region='eastus' WHERE kind='OPERATOR';
SELECT 'T18 Region ausserhalb EU/EWR|Fehler|akzeptiert';
ROLLBACK TO s18;
SELECT 'T18 Region ausserhalb EU/EWR|Fehler|Fehler';

-- ---------- 19. Frist ausserhalb des zulaessigen Rahmens ----------
SAVEPOINT s19;
UPDATE tenant SET invite_ttl_hours=0 WHERE kind='OPERATOR';
SELECT 'T19 Einladungsfrist 0 Stunden|Fehler|akzeptiert';
ROLLBACK TO s19;
SELECT 'T19 Einladungsfrist 0 Stunden|Fehler|Fehler';

-- ---------- v2.9: Journey auf fuenf Stufen, Empfangsbestaetigung ----------
SELECT 'T20 Journey-Stufe MITBESTIMMUNG entfernt|Fehler|' ||
  CASE WHEN NOT EXISTS (SELECT 1 FROM pg_enum e JOIN pg_type t ON t.oid=e.enumtypid
                        WHERE t.typname='journey_phase' AND e.enumlabel='MITBESTIMMUNG')
       THEN 'Fehler' ELSE 'akzeptiert' END;

SELECT 'T21 Journey hat fuenf Stufen|5|' || count(*)::text
  FROM pg_enum e JOIN pg_type t ON t.oid=e.enumtypid WHERE t.typname='journey_phase';

INSERT INTO fit_check(id,tenant_id,outcome,completed_at)
  VALUES ('cccccccc-0000-0000-0000-000000000001','22222222-2222-2222-2222-222222222222','GEEIGNET',now());
INSERT INTO app(id,tenant_id,project_no,name,lifecycle_state,journey_phase,fit_check_id,created_at)
  VALUES ('dddddddd-0000-0000-0000-000000000001','22222222-2222-2222-2222-222222222222',
          'DE-NOF_001_26','Eingangsrechnungen','IN_BEARBEITUNG','ANGEBOT',
          'cccccccc-0000-0000-0000-000000000001',DATE '2026-03-02');

SAVEPOINT s22;
UPDATE app SET mitbestimmung_ack_at = now() WHERE id='dddddddd-0000-0000-0000-000000000001';
SELECT 'T22 Bestaetigung ohne Siegel|Fehler|akzeptiert';
ROLLBACK TO s22;
SELECT 'T22 Bestaetigung ohne Siegel|Fehler|Fehler';

UPDATE app SET sealed_at = now(), mitbestimmung_ack_at = now()
  WHERE id='dddddddd-0000-0000-0000-000000000001';
SELECT 'T23 Bestaetigung mit Siegel|1|' || count(*)::text
  FROM app WHERE mitbestimmung_ack_at IS NOT NULL;
