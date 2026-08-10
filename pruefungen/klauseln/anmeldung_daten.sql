-- =====================================================================
-- FREIRAUM · Scheibe 1 · Anmeldung
-- Pruefdaten fuer die Klauselpruefung  (anmeldung_lauf.sh)
--
-- Geschrieben gegen K03 v1.3, K19 EN-01, freiraum_datamodel.sql und
-- M30__pilot_sammelmigration.sql -- NICHT gegen den Umsetzungscode.
--
-- Aufruf:
--   FREIRAUM_CODE_PFEFFER=... \
--   psql -h localhost -p 55433 -U postgres -d freiraum_pruef \
--        -v ON_ERROR_STOP=1 -f anmeldung_daten.sql
--
-- Die Datenbank wird zuvor aus
--   schema/freiraum_datamodel.sql
--   migrations/M30__pilot_sammelmigration.sql
-- angelegt. Die Datei ist WIEDERHOLBAR: sie setzt die Konten zurueck,
-- statt sie zu loeschen (event ist append-only, actor.id wird dort
-- referenziert; ein DELETE auf actor liefe in den Nachweiswaechter).
--
-- MASSSTAB F07: Jedes Konto verletzt genau EINE Bedingung. Alle uebrigen
-- Vorbedingungen sind erfuellt -- Mandant, Anzeigename, Mitgliedschaft,
-- Kontozustand, offener Code innerhalb der Frist. Der Aufbau wird am Ende
-- dieser Datei selbst geprueft; stimmt er nicht, bricht der Lauf ab, statt
-- Faelle zu melden, die an der falschen Bedingung scheitern.
-- =====================================================================

\set ON_ERROR_STOP on

-- ---------------------------------------------------------------------
-- 0 · Der Pfeffer. Ohne ihn ist jeder Pruefwert falsch -- und ein
--     Positivfall, der am falschen Pruefwert scheitert, misst nichts.
-- ---------------------------------------------------------------------
\getenv pfeffer FREIRAUM_CODE_PFEFFER
\if :{?pfeffer}
\else
\echo '*** ABBRUCH: FREIRAUM_CODE_PFEFFER ist nicht gesetzt.'
\echo '*** Ohne den Pfeffer entstehen falsche Pruefwerte und der Positivfall'
\echo '*** scheiterte an der Pruefdatenlage statt an einer Klausel (F07).'
\quit
\endif

-- Der Umweg ueber set_config ist noetig: psql ersetzt :'pfeffer' nicht
-- innerhalb eines dollar-gequoteten Blocks.
SELECT set_config('freiraum.pruef_pfeffer', :'pfeffer', false);
DO $$
BEGIN
  IF length(current_setting('freiraum.pruef_pfeffer')) = 0 THEN
    RAISE EXCEPTION 'ABBRUCH: FREIRAUM_CODE_PFEFFER ist leer (Entscheidung D vom 10.08.2026, BEF-L2-1)';
  END IF;
END $$;

-- ---------------------------------------------------------------------
-- 1 · Der Pruefwert des Codes
--
--     K03-M15: "Gespeichert wird nur sein kryptografischer Pruefwert."
--     Die Ableitung selbst nennt keine gezeichnete Quelle. Sie steht
--     deshalb an GENAU EINER Stelle: hier. Bildet der Serverpfad den
--     Pruefwert anders, ist allein diese Funktion anzupassen -- alle
--     codeabhaengigen Faelle haengen an ihr.
-- ---------------------------------------------------------------------
CREATE OR REPLACE FUNCTION pruef_codewert(klartext text, pfeffer text)
RETURNS text LANGUAGE sql IMMUTABLE AS
$$ SELECT encode(sha256(convert_to(pfeffer || klartext, 'utf8')), 'hex') $$;

-- ---------------------------------------------------------------------
-- 2 · Mandanten
-- ---------------------------------------------------------------------
INSERT INTO tenant (id, kind, name, customer_code, legal_space)
VALUES ('00000000-0000-4000-8000-0000000000f1', 'OPERATOR', 'Pruefbetreiber Scheibe 1', NULL, 'DE')
ON CONFLICT (id) DO NOTHING;

INSERT INTO tenant (id, kind, name, customer_code, legal_space)
VALUES ('00000000-0000-4000-8000-0000000000f2', 'CUSTOMER', 'Pruefkunde Scheibe 1', 'DE-PRF', 'DE')
ON CONFLICT (id) DO NOTHING;

-- ---------------------------------------------------------------------
-- 3 · Der Plattform-Admin ZUERST.
--
--     Der Waechter platform_admin_guard haengt an actor und membership
--     (AFTER DELETE OR UPDATE, FOR EACH STATEMENT): bleibt kein aktiver
--     EXMA-Admin uebrig, scheitert JEDE spaetere Aenderung an actor.
--     Er ist Aufbau, kein Prueffall.
-- ---------------------------------------------------------------------
-- Reine INSERTs zuerst: ON CONFLICT DO UPDATE wuerde den Waechter schon
-- ausloesen, bevor die Mitgliedschaft steht.
INSERT INTO actor (id, tenant_id, email, display_name, mfa_method, status, created_on)
VALUES ('00000000-0000-4000-8000-000000000001',
        '00000000-0000-4000-8000-0000000000f1',
        'plattformadmin@pruef.example', 'Pruef Plattform-Admin', 'EMAIL_CODE', 'AKTIV', current_date)
ON CONFLICT (id) DO NOTHING;

INSERT INTO membership (actor_id, portal_code, role_id, tenant_scope)
SELECT '00000000-0000-4000-8000-000000000001', 'EXMA', r.id, '00000000-0000-4000-8000-0000000000f1'
  FROM role r WHERE r.portal_code = 'EXMA' AND r.name = 'Plattform-Admin'
ON CONFLICT DO NOTHING;

UPDATE actor SET status = 'AKTIV'
 WHERE id = '00000000-0000-4000-8000-000000000001' AND status <> 'AKTIV';

-- ---------------------------------------------------------------------
-- 4 · Alten Lauf zuruecksetzen
--     (Konten bleiben stehen, nur ihre fluechtigen Spuren gehen.)
-- ---------------------------------------------------------------------
DELETE FROM login_code
 WHERE actor_id IN (SELECT id FROM actor WHERE email LIKE '%@pruef.example');
DELETE FROM auth_session
 WHERE actor_id IN (SELECT id FROM actor WHERE email LIKE '%@pruef.example');
DELETE FROM login_attempt
 WHERE email LIKE '%@pruef.example';

-- ---------------------------------------------------------------------
-- 5 · Die Konten der Faelle
--
--     Jede Zeile ist AKTIV, hat Mandant, Anzeigename und -- wo der Fall
--     es braucht -- eine Mitgliedschaft in einem freigeschalteten Portal.
--     Abweichungen sind einzeln benannt und sind der Prueffall.
-- ---------------------------------------------------------------------
INSERT INTO actor (id, tenant_id, email, display_name, mfa_method, status, status_before_lock, last_login_at, created_on) VALUES
  -- Positivkontrolle. last_login_at absichtlich alt: AN-06 misst, dass die
  -- Anmeldung es fortschreibt.
  ('00000000-0000-4000-8000-000000000002','00000000-0000-4000-8000-0000000000f2','positiv@pruef.example',       'Pruef Positiv',        'EMAIL_CODE','AKTIV',      NULL, now() - interval '7 days', current_date),
  ('00000000-0000-4000-8000-000000000003','00000000-0000-4000-8000-0000000000f2','untaetig@pruef.example',      'Pruef Untaetigkeit',   'EMAIL_CODE','AKTIV',      NULL, NULL, current_date),
  ('00000000-0000-4000-8000-000000000004','00000000-0000-4000-8000-0000000000f2','achtstunden@pruef.example',   'Pruef Achtstunden',    'EMAIL_CODE','AKTIV',      NULL, NULL, current_date),
  ('00000000-0000-4000-8000-000000000005','00000000-0000-4000-8000-0000000000f2','abmeldung@pruef.example',     'Pruef Abmeldung',      'EMAIL_CODE','AKTIV',      NULL, NULL, current_date),
  ('00000000-0000-4000-8000-000000000006','00000000-0000-4000-8000-0000000000f2','sperrmitten@pruef.example',   'Pruef Sperre mitten',  'EMAIL_CODE','AKTIV',      NULL, NULL, current_date),
  -- Mitgliedschaft in ZWEI freigeschalteten Portalen (K03-D02)
  ('00000000-0000-4000-8000-000000000007','00000000-0000-4000-8000-0000000000f2','zweiportale@pruef.example',   'Pruef Zwei Portale',   'EMAIL_CODE','AKTIV',      NULL, NULL, current_date),
  -- KEINE Mitgliedschaft (K03-M11, K03 Abschn. 6)
  ('00000000-0000-4000-8000-000000000008','00000000-0000-4000-8000-0000000000f2','ohneportal@pruef.example',    'Pruef ohne Portal',    'EMAIL_CODE','AKTIV',      NULL, NULL, current_date),
  ('00000000-0000-4000-8000-000000000009','00000000-0000-4000-8000-0000000000f2','falschercode@pruef.example',  'Pruef falscher Code',  'EMAIL_CODE','AKTIV',      NULL, NULL, current_date),
  -- GESPERRT, sonst tadellos: gueltiger Code, Mitgliedschaft (K03-D01)
  ('00000000-0000-4000-8000-000000000010','00000000-0000-4000-8000-0000000000f2','gesperrt@pruef.example',      'Pruef gesperrt',       'EMAIL_CODE','GESPERRT',   'AKTIV', NULL, current_date),
  ('00000000-0000-4000-8000-000000000011','00000000-0000-4000-8000-0000000000f2','abgelaufen@pruef.example',    'Pruef abgelaufen',     'EMAIL_CODE','AKTIV',      NULL, NULL, current_date),
  ('00000000-0000-4000-8000-000000000012','00000000-0000-4000-8000-0000000000f2','verbraucht@pruef.example',    'Pruef verbraucht',     'EMAIL_CODE','AKTIV',      NULL, NULL, current_date),
  ('00000000-0000-4000-8000-000000000013','00000000-0000-4000-8000-0000000000f2','entwertet@pruef.example',     'Pruef entwertet',      'EMAIL_CODE','AKTIV',      NULL, NULL, current_date),
  ('00000000-0000-4000-8000-000000000014','00000000-0000-4000-8000-0000000000f2','drossel@pruef.example',       'Pruef Drosselung',     'EMAIL_CODE','AKTIV',      NULL, NULL, current_date),
  -- WARTET_2FA: last_login_at MUSS leer sein (K03-G05)
  ('00000000-0000-4000-8000-000000000015','00000000-0000-4000-8000-0000000000f2','wartetfalsch@pruef.example',  'Pruef wartet falsch',  'EMAIL_CODE','WARTET_2FA', NULL, NULL, current_date),
  ('00000000-0000-4000-8000-000000000016','00000000-0000-4000-8000-0000000000f2','wartetrichtig@pruef.example', 'Pruef wartet richtig', 'EMAIL_CODE','WARTET_2FA', NULL, NULL, current_date),
  ('00000000-0000-4000-8000-000000000017','00000000-0000-4000-8000-0000000000f2','zweitanmeldung@pruef.example','Pruef Zweitanmeldung', 'EMAIL_CODE','AKTIV',      NULL, NULL, current_date),
  ('00000000-0000-4000-8000-000000000018','00000000-0000-4000-8000-0000000000f2','leercode@pruef.example',      'Pruef leerer Code',    'EMAIL_CODE','AKTIV',      NULL, NULL, current_date)
ON CONFLICT (id) DO UPDATE SET
  tenant_id          = EXCLUDED.tenant_id,
  email              = EXCLUDED.email,
  display_name       = EXCLUDED.display_name,
  mfa_method         = EXCLUDED.mfa_method,
  status             = EXCLUDED.status,
  status_before_lock = EXCLUDED.status_before_lock,
  last_login_at      = EXCLUDED.last_login_at;

-- ---------------------------------------------------------------------
-- 6 · Mitgliedschaften
--     Der Waechter laesst das Loeschen zu, solange der EXMA-Admin aus
--     Abschnitt 3 stehen bleibt -- deshalb ist er ausgenommen.
-- ---------------------------------------------------------------------
DELETE FROM membership
 WHERE actor_id IN (SELECT id FROM actor
                     WHERE email LIKE '%@pruef.example'
                       AND email <> 'plattformadmin@pruef.example');

INSERT INTO membership (actor_id, portal_code, role_id, tenant_scope)
SELECT a.id, 'ENDUSER', r.id, '00000000-0000-4000-8000-0000000000f2'
  FROM actor a
  CROSS JOIN (SELECT id FROM role WHERE portal_code='ENDUSER' AND name='Endnutzer') r
 WHERE a.email LIKE '%@pruef.example'
   AND a.email NOT IN ('plattformadmin@pruef.example',   -- gehoert zu EXMA
                       'ohneportal@pruef.example')       -- der Prueffall AN-13
ON CONFLICT DO NOTHING;

-- Zwei freigeschaltete Portale fuer AN-14 (K03-D02)
INSERT INTO membership (actor_id, portal_code, role_id, tenant_scope)
SELECT '00000000-0000-4000-8000-000000000007', 'EXMA', r.id, '00000000-0000-4000-8000-0000000000f1'
  FROM role r WHERE r.portal_code='EXMA' AND r.name='Plattform-Admin'
ON CONFLICT DO NOTHING;

-- ---------------------------------------------------------------------
-- 7 · Die Codes
--
--     Alle Codes sind sechsstellig (K03-M05). Wo nichts anderes steht,
--     sind sie offen, unverbraucht und innerhalb der Zehn-Minuten-Frist
--     -- damit ein Fall NUR an seiner eigenen Regel scheitern kann.
--
--     Zuordnung (Klartext, den anmeldung_lauf.sh sendet):
--       positiv@         100002        gueltig
--       untaetig@        100003        gueltig
--       achtstunden@     100004        gueltig
--       abmeldung@       100005        gueltig
--       sperrmitten@     100006        gueltig
--       zweiportale@     100007        gueltig
--       ohneportal@      100008        gueltig  (Fall: keine Mitgliedschaft)
--       falschercode@    100009        gueltig  (gesendet wird 999999)
--       gesperrt@        100010        gueltig  (Fall: Kontozustand)
--       abgelaufen@      100011        ABGELAUFEN
--       verbraucht@      100012        VERBRAUCHT
--       entwertet@       100013 alt / 100113 neu (alt wird entwertet)
--       drossel@         100014        gueltig
--       wartetfalsch@    100015        gueltig  (gesendet wird 999999)
--       wartetrichtig@   100016        gueltig
--       zweitanmeldung@  100017        gueltig
--       leercode@        100018        gueltig  (gesendet wird '')
--       unbekannt@       100099        es gibt kein Konto -- der Fall
-- ---------------------------------------------------------------------
INSERT INTO login_code (actor_id, code_hash, issued_at, expires_at)
SELECT a.id, pruef_codewert(v.code, :'pfeffer'), now(), now() + interval '10 minutes'
  FROM (VALUES
      ('positiv@pruef.example',       '100002'),
      ('untaetig@pruef.example',      '100003'),
      ('achtstunden@pruef.example',   '100004'),
      ('abmeldung@pruef.example',     '100005'),
      ('sperrmitten@pruef.example',   '100006'),
      ('zweiportale@pruef.example',   '100007'),
      ('ohneportal@pruef.example',    '100008'),
      ('falschercode@pruef.example',  '100009'),
      ('gesperrt@pruef.example',      '100010'),
      ('drossel@pruef.example',       '100014'),
      ('wartetfalsch@pruef.example',  '100015'),
      ('wartetrichtig@pruef.example', '100016'),
      ('zweitanmeldung@pruef.example','100017'),
      ('leercode@pruef.example',      '100018')
   ) AS v(mail, code)
  JOIN actor a ON a.email = v.mail;

-- ABGELAUFEN (K03-M15, zehn Minuten): vor 20 Minuten ausgestellt, die
-- Frist ist seit 10 Minuten um. Sonst nichts verletzt.
INSERT INTO login_code (actor_id, code_hash, issued_at, expires_at)
SELECT a.id, pruef_codewert('100011', :'pfeffer'),
       now() - interval '20 minutes', now() - interval '10 minutes'
  FROM actor a WHERE a.email = 'abgelaufen@pruef.example';

-- VERBRAUCHT (K03-M15, genau einmal gueltig): Frist laeuft noch,
-- eingeloest wurde er trotzdem schon.
INSERT INTO login_code (actor_id, code_hash, issued_at, expires_at, consumed_at)
SELECT a.id, pruef_codewert('100012', :'pfeffer'),
       now() - interval '2 minutes', now() + interval '8 minutes', now() - interval '1 minute'
  FROM actor a WHERE a.email = 'verbraucht@pruef.example';

-- ENTWERTET (K03-M15, ein neuer entwertet aeltere): der aeltere zuerst,
-- der neuere danach. superseded_at setzt der Ausloeser aus M30, nicht
-- diese Datei -- gemessen wird die Regel, nicht meine Hand.
INSERT INTO login_code (actor_id, code_hash, issued_at, expires_at)
SELECT a.id, pruef_codewert('100013', :'pfeffer'), now() - interval '1 minute', now() + interval '9 minutes'
  FROM actor a WHERE a.email = 'entwertet@pruef.example';
INSERT INTO login_code (actor_id, code_hash, issued_at, expires_at)
SELECT a.id, pruef_codewert('100113', :'pfeffer'), now(), now() + interval '10 minutes'
  FROM actor a WHERE a.email = 'entwertet@pruef.example';

-- ---------------------------------------------------------------------
-- 8 · Sicht auf die Lage -- anmeldung_lauf.sh prueft damit den AUFBAU,
--     bevor ein einziger Fall laeuft.
-- ---------------------------------------------------------------------
CREATE OR REPLACE VIEW pruef_anmeldung_lage AS
SELECT a.email,
       a.id                                        AS actor_id,
       a.status::text                              AS status,
       a.last_login_at,
       (SELECT count(*) FROM membership m
         WHERE m.actor_id = a.id)                  AS mitgliedschaften,
       (SELECT count(*) FROM membership m JOIN portal p ON p.code = m.portal_code
         WHERE m.actor_id = a.id AND p.release_status = 'ENABLED')
                                                   AS freigeschaltete_portale,
       (SELECT count(*) FROM login_code c
         WHERE c.actor_id = a.id
           AND c.consumed_at IS NULL AND c.superseded_at IS NULL
           AND c.expires_at > now())               AS offene_codes,
       (SELECT count(*) FROM login_code c
         WHERE c.actor_id = a.id)                  AS codes_gesamt,
       (SELECT count(*) FROM auth_session s
         WHERE s.actor_id = a.id AND s.ended_at IS NULL)
                                                   AS offene_sitzungen
  FROM actor a
 WHERE a.email LIKE '%@pruef.example';

-- ---------------------------------------------------------------------
-- 9 · AUFBAUPRUEFUNG (F07)
--
--     Ein Negativfall gilt erst als bestanden, wenn er an SEINER Regel
--     scheitert. Also wird hier geprueft, dass jedes Konto genau das
--     mitbringt, was sein Fall braucht -- und genau eine Abweichung.
-- ---------------------------------------------------------------------
DO $$
DECLARE r record; fehler text := '';
BEGIN
  -- (a) Jedes Konto ausser dem Fall AN-13 gehoert in ein freigeschaltetes Portal.
  FOR r IN SELECT * FROM pruef_anmeldung_lage
            WHERE email NOT IN ('ohneportal@pruef.example')
              AND freigeschaltete_portale < 1
  LOOP fehler := fehler || format('%s ohne freigeschaltetes Portal; ', r.email); END LOOP;

  -- (b) Der Fall AN-13 hat KEINE Mitgliedschaft -- sonst misst er nichts.
  IF (SELECT mitgliedschaften FROM pruef_anmeldung_lage
       WHERE email='ohneportal@pruef.example') <> 0 THEN
    fehler := fehler || 'ohneportal@ hat doch eine Mitgliedschaft; ';
  END IF;

  -- (c) Genau EIN offener, fristgerechter Code, wo der Fall ihn braucht.
  FOR r IN SELECT * FROM pruef_anmeldung_lage
            WHERE email IN ('positiv@pruef.example','untaetig@pruef.example',
                            'achtstunden@pruef.example','abmeldung@pruef.example',
                            'sperrmitten@pruef.example','zweiportale@pruef.example',
                            'ohneportal@pruef.example','falschercode@pruef.example',
                            'gesperrt@pruef.example','drossel@pruef.example',
                            'wartetfalsch@pruef.example','wartetrichtig@pruef.example',
                            'zweitanmeldung@pruef.example','leercode@pruef.example',
                            'entwertet@pruef.example')
              AND offene_codes <> 1
  LOOP fehler := fehler || format('%s hat %s offene Codes statt 1; ', r.email, r.offene_codes); END LOOP;

  -- (d) Die drei Codefaelle haben KEINEN offenen Code -- das ist ihr Fall.
  FOR r IN SELECT * FROM pruef_anmeldung_lage
            WHERE email IN ('abgelaufen@pruef.example','verbraucht@pruef.example')
              AND offene_codes <> 0
  LOOP fehler := fehler || format('%s hat einen offenen Code, misst also nichts; ', r.email); END LOOP;

  -- (e) Der aeltere Code von entwertet@ ist wirklich entwertet.
  IF NOT EXISTS (SELECT 1 FROM login_code c JOIN actor a ON a.id=c.actor_id
                  WHERE a.email='entwertet@pruef.example' AND c.superseded_at IS NOT NULL) THEN
    fehler := fehler || 'entwertet@: der aeltere Code ist nicht entwertet; ';
  END IF;

  -- (f) Kontozustaende.
  IF (SELECT status FROM pruef_anmeldung_lage WHERE email='gesperrt@pruef.example') <> 'GESPERRT' THEN
    fehler := fehler || 'gesperrt@ ist nicht GESPERRT; '; END IF;
  FOR r IN SELECT * FROM pruef_anmeldung_lage
            WHERE email IN ('wartetfalsch@pruef.example','wartetrichtig@pruef.example')
              AND status <> 'WARTET_2FA'
  LOOP fehler := fehler || format('%s ist nicht WARTET_2FA; ', r.email); END LOOP;
  FOR r IN SELECT * FROM pruef_anmeldung_lage
            WHERE email IN ('positiv@pruef.example','untaetig@pruef.example','achtstunden@pruef.example',
                            'abmeldung@pruef.example','sperrmitten@pruef.example','zweiportale@pruef.example',
                            'ohneportal@pruef.example','falschercode@pruef.example','abgelaufen@pruef.example',
                            'verbraucht@pruef.example','entwertet@pruef.example','drossel@pruef.example',
                            'zweitanmeldung@pruef.example','leercode@pruef.example')
              AND status <> 'AKTIV'
  LOOP fehler := fehler || format('%s ist nicht AKTIV; ', r.email); END LOOP;

  -- (g) K03-G05: WARTET_2FA traegt keine letzte Anmeldung.
  FOR r IN SELECT * FROM pruef_anmeldung_lage
            WHERE status='WARTET_2FA' AND last_login_at IS NOT NULL
  LOOP fehler := fehler || format('%s traegt last_login_at trotz WARTET_2FA; ', r.email); END LOOP;

  -- (h) Es gibt kein Konto zu unbekannt@ -- sonst misst AN-16 nichts.
  IF EXISTS (SELECT 1 FROM actor WHERE email='unbekannt@pruef.example') THEN
    fehler := fehler || 'unbekannt@ existiert als Konto; ';
  END IF;

  -- (i) Keine Altsitzung, keine Altversuche.
  IF EXISTS (SELECT 1 FROM pruef_anmeldung_lage WHERE offene_sitzungen > 0) THEN
    fehler := fehler || 'es stehen noch offene Sitzungen aus einem frueheren Lauf; ';
  END IF;
  IF EXISTS (SELECT 1 FROM login_attempt WHERE email LIKE '%@pruef.example') THEN
    fehler := fehler || 'es stehen noch Anmeldeversuche aus einem frueheren Lauf; ';
  END IF;

  IF fehler <> '' THEN
    RAISE EXCEPTION 'AUFBAU UNBRAUCHBAR (F07): %', fehler;
  END IF;
END $$;

-- ---------------------------------------------------------------------
-- 10 · Was jetzt steht
-- ---------------------------------------------------------------------
SELECT email, status, mitgliedschaften AS mitglied,
       freigeschaltete_portale AS portale, offene_codes AS code_offen,
       codes_gesamt AS codes
  FROM pruef_anmeldung_lage
 ORDER BY email;

\echo 'Pruefdaten stehen. Aufbaupruefung (F07) bestanden.'
