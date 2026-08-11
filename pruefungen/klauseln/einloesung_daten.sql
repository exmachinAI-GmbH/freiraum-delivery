-- =====================================================================
-- FREIRAUM · Scheibe · Einladung einloesen
-- Pruefdaten fuer die Klauselpruefung  (einloesung_lauf.sh)
--
-- Geschrieben gegen schema/freiraum_datamodel.sql, den Ausschnitt aus
-- M30__pilot_sammelmigration.sql (invitation_decision, mail_delivery --
-- beide NICHT der hier gemessene Nachweistraeger, siehe unten) und den
-- Schnittstellenvertrag aus dem Pruefauftrag -- NICHT gegen den
-- Umsetzungscode. Machart und Aufrufvertrag wie anmeldung_daten.sql.
--
-- Aufruf:
--   FREIRAUM_CODE_PFEFFER=... \
--   psql -h localhost -p 55433 -U postgres -d <wegwerfdatenbank> \
--        -v ON_ERROR_STOP=1 -f einloesung_daten.sql
--
-- Die Datei ist WIEDERHOLBAR: sie setzt ihre Testkonten und deren
-- Einladungen zurueck, statt sie zu loeschen. EVENT ist Nachweis
-- (append-only nach Grundsatz, siehe CLAUDE.md/README) und wird darum
-- NICHT geloescht -- einloesung_lauf.sh setzt vor der Positivkontrolle
-- eine eigene Zeitmarke und misst nur Ereignisse danach (F07-fest gegen
-- Altlast aus einem frueheren Lauf).
--
-- MASSSTAB F07: Jedes Pruefkonto/jede Einladung verletzt genau EINE
-- Bedingung. Alle uebrigen Vorbedingungen sind erfuellt -- Mandant,
-- Mitgliedschaft im freigeschalteten Portal, Kontozustand, Frist. Der
-- Aufbau wird am Ende dieser Datei selbst geprueft; stimmt er nicht,
-- bricht der Lauf mit dem Wort ABBRUCH ab, statt Faelle zu melden, die
-- an der falschen Bedingung scheitern.
--
-- Zur Namensverwechslung: M30 fuehrt eine Tabelle INVITATION_DECISION
-- ("Person, Zeitpunkt, Adressat, Grund" der Entscheidung, JEMANDEN
-- einzuladen). Das ist ein anderer Vorgang als der hier gepruefte
-- (die EINLOESUNG einer bereits versandten Einladung durch den
-- Eingeladenen). Der Pruefauftrag nennt den Nachweistraeger fuer
-- K20-M18 ausdruecklich: "im Nachweis (event)". Gemessen wird darum
-- die Tabelle EVENT, nicht INVITATION_DECISION.
-- =====================================================================

\set ON_ERROR_STOP on

-- ---------------------------------------------------------------------
-- 0 · Der Pfeffer. Ohne ihn ist jeder Streuwert falsch -- und ein
--     Positivfall, der am falschen Streuwert scheitert, misst nichts.
-- ---------------------------------------------------------------------
\getenv pfeffer FREIRAUM_CODE_PFEFFER
\if :{?pfeffer}
\else
\echo '*** ABBRUCH: FREIRAUM_CODE_PFEFFER ist nicht gesetzt.'
\echo '*** Ohne den Pfeffer entstehen falsche Streuwerte und der Positivfall'
\echo '*** scheiterte an der Pruefdatenlage statt an einer Klausel (F07).'
\quit
\endif

SELECT set_config('freiraum.pruef_pfeffer', :'pfeffer', false);
DO $$
BEGIN
  IF length(current_setting('freiraum.pruef_pfeffer')) = 0 THEN
    RAISE EXCEPTION 'ABBRUCH: FREIRAUM_CODE_PFEFFER ist leer';
  END IF;
END $$;

-- ---------------------------------------------------------------------
-- 1 · Der Streuwert des Einladungstokens
--
--     Vertrag: sha256(FREIRAUM_CODE_PFEFFER + token) als Hex, Kleinbuchstaben.
--     Die Ableitung steht deshalb an GENAU EINER Stelle: hier. Bildet der
--     Serverpfad den Streuwert anders, ist allein diese Funktion
--     anzupassen -- alle Faelle haengen an ihr.
-- ---------------------------------------------------------------------
CREATE OR REPLACE FUNCTION pruef_tokenwert(klartext text, pfeffer text)
RETURNS text LANGUAGE sql IMMUTABLE AS
$$ SELECT encode(sha256(convert_to(pfeffer || klartext, 'utf8')), 'hex') $$;

-- ---------------------------------------------------------------------
-- 2 · Mandanten
-- ---------------------------------------------------------------------
INSERT INTO tenant (id, kind, name, customer_code, legal_space)
VALUES ('00000000-0000-4000-8000-0000000000e1', 'OPERATOR', 'Pruefbetreiber Einloesung', NULL, 'DE')
ON CONFLICT (id) DO NOTHING;

INSERT INTO tenant (id, kind, name, customer_code, legal_space, invite_ttl_hours, invite_domain)
VALUES ('00000000-0000-4000-8000-0000000000e2', 'CUSTOMER', 'Pruefkunde Einloesung', 'DE-ELN', 'DE', 24, NULL)
ON CONFLICT (id) DO NOTHING;

-- ---------------------------------------------------------------------
-- 3 · Der Plattform-Admin ZUERST (siehe anmeldung_daten.sql Abschn. 3 --
--     gleicher Grund: platform_admin_guard haengt an actor/membership).
-- ---------------------------------------------------------------------
INSERT INTO actor (id, tenant_id, email, display_name, mfa_method, status, created_on)
VALUES ('00000000-0000-4000-8000-000000000021',
        '00000000-0000-4000-8000-0000000000e1',
        'plattformadmin@pruef.example', 'Pruef Plattform-Admin', 'EMAIL_CODE', 'AKTIV', current_date)
ON CONFLICT (id) DO NOTHING;

INSERT INTO membership (actor_id, portal_code, role_id, tenant_scope)
SELECT '00000000-0000-4000-8000-000000000021', 'EXMA', r.id, '00000000-0000-4000-8000-0000000000e1'
  FROM role r WHERE r.portal_code = 'EXMA' AND r.name = 'Plattform-Admin'
ON CONFLICT DO NOTHING;

UPDATE actor SET status = 'AKTIV'
 WHERE id = '00000000-0000-4000-8000-000000000021' AND status <> 'AKTIV';

-- ---------------------------------------------------------------------
-- 4 · Die Konten der Faelle
--
--     Alle sind ENDUSER-Mitglied im freigeschalteten Portal (K20 nennt
--     Mitgliedschaft nicht als Pruefpunkt dieser Scheibe -- sie steht
--     darum bei ALLEN gleich, damit kein Fall unbeabsichtigt an ihr
--     scheitert). Abweichungen vom Normalzustand sind einzeln benannt
--     und sind der Prueffall.
-- ---------------------------------------------------------------------
INSERT INTO actor (id, tenant_id, email, display_name, mfa_method, status, status_before_lock, created_on) VALUES
  -- Positivkontrolle + Mailscanner-Sicherheit (EL-01, EL-04, EL-05..09, EL-15..18)
  ('00000000-0000-4000-8000-000000000022','00000000-0000-4000-8000-0000000000e2','el_positiv@pruef.example',      'Pruef El Positiv',      'EMAIL_CODE','WARTET_2FA', NULL, current_date),
  -- Fall: abgelaufene Einladung (K20-D10)
  ('00000000-0000-4000-8000-000000000023','00000000-0000-4000-8000-0000000000e2','el_abgelaufen@pruef.example',   'Pruef El Abgelaufen',   'EMAIL_CODE','WARTET_2FA', NULL, current_date),
  -- Fall: bereits eingeloeste Einladung (K20-D10). Zustand nach Einloesung simuliert.
  ('00000000-0000-4000-8000-000000000024','00000000-0000-4000-8000-0000000000e2','el_verbraucht@pruef.example',   'Pruef El Verbraucht',   'EMAIL_CODE','AKTIV',      NULL, current_date),
  -- Fall: widerrufene Einladung (K20-D10)
  ('00000000-0000-4000-8000-000000000025','00000000-0000-4000-8000-0000000000e2','el_widerrufen@pruef.example',   'Pruef El Widerrufen',   'EMAIL_CODE','WARTET_2FA', NULL, current_date),
  -- Fall: GESPERRTES Konto, sonst tadellos -- gueltiger, frist­gerechter Token (Vertrag Punkt 1)
  ('00000000-0000-4000-8000-000000000026','00000000-0000-4000-8000-0000000000e2','el_gesperrt@pruef.example',     'Pruef El Gesperrt',     'EMAIL_CODE','GESPERRT',   'WARTET_2FA', current_date),
  -- Fall: Konkurrenz -- zwei gleichzeitige Einloesungen desselben Tokens (Vertrag Punkt 2)
  ('00000000-0000-4000-8000-000000000027','00000000-0000-4000-8000-0000000000e2','el_gleichzeitig@pruef.example', 'Pruef El Gleichzeitig', 'EMAIL_CODE','WARTET_2FA', NULL, current_date)
ON CONFLICT (id) DO UPDATE SET
  tenant_id          = EXCLUDED.tenant_id,
  email              = EXCLUDED.email,
  display_name       = EXCLUDED.display_name,
  mfa_method         = EXCLUDED.mfa_method,
  status             = EXCLUDED.status,
  status_before_lock = EXCLUDED.status_before_lock;

-- ---------------------------------------------------------------------
-- 5 · Mitgliedschaften -- ENDUSER im freigeschalteten Portal, fuer ALLE
--     sechs Pruefkonten gleich.
-- ---------------------------------------------------------------------
DELETE FROM membership
 WHERE actor_id IN (SELECT id FROM actor
                     WHERE email LIKE 'el_%@pruef.example');

INSERT INTO membership (actor_id, portal_code, role_id, tenant_scope)
SELECT a.id, 'ENDUSER', r.id, '00000000-0000-4000-8000-0000000000e2'
  FROM actor a
  CROSS JOIN (SELECT id FROM role WHERE portal_code='ENDUSER' AND name='Endnutzer') r
 WHERE a.email LIKE 'el_%@pruef.example'
ON CONFLICT DO NOTHING;

-- ---------------------------------------------------------------------
-- 6 · Die Einladungen
--
--     EIN offener/relevanter Datensatz je Konto. Klartext-Tokens (die
--     einloesung_lauf.sh sendet) stehen NUR hier als Kommentar -- die
--     Tabelle selbst traegt ausschliesslich den Streuwert (K20-M08).
--
--     Zuordnung:
--       el_positiv@       tok-positiv-6f2e9b1c4a7d5083        gueltig, offen
--       el_abgelaufen@     tok-abgelaufen-9a4b7c2e1f5d0836      abgelaufen
--       el_verbraucht@     tok-verbraucht-2c5e8a1b4d7f0936      bereits eingeloest
--       el_widerrufen@     tok-widerrufen-7b1d4f8a2c5e0937      widerrufen
--       el_gesperrt@       tok-gesperrt-4f8b1d7a2c5e0938        gueltig, offen (Konto gesperrt)
--       el_gleichzeitig@   tok-gleichzeitig-1a4d7f2b8c5e0939    gueltig, offen
--       (kein Konto)       tok-unbekannt-nie-in-db-5e8a1d4f2c7b0940c3  existiert nirgends
--
--     Die abgelaufene Einladung entsteht NICHT durch Umgehen der
--     Waechter: invitation_guard_trg (BEFORE INSERT/UPDATE) verlangt
--     expires_at <= sent_at + invite_ttl_hours. Wer sent_at = now() und
--     expires_at in der Vergangenheit versucht, stoesst zuerst an
--     invitation_frist (expires_at > sent_at). Der Weg, der mit dem
--     Waechter arbeitet: sent_at selbst in die Vergangenheit legen, so
--     dass expires_at = sent_at + ttl noch VOR dem jetzigen now() liegt.
-- ---------------------------------------------------------------------
DELETE FROM invitation
 WHERE actor_id IN (SELECT id FROM actor WHERE email LIKE 'el_%@pruef.example');

-- el_positiv: offen, unverbraucht, weit vor Fristablauf.
INSERT INTO invitation (actor_id, portal_code, mail, token_hash, sent_at, expires_at, status)
SELECT a.id, 'ENDUSER', a.email, pruef_tokenwert('tok-positiv-6f2e9b1c4a7d5083', :'pfeffer'),
       now(), now() + interval '23 hours', 'VERSANDT'
  FROM actor a WHERE a.email = 'el_positiv@pruef.example';

-- el_abgelaufen: sent_at vor 30 Stunden, expires_at = sent_at + 24h (die
-- volle Frist des Mandanten) -- das liegt 6 Stunden VOR now(). Verletzt
-- ist allein die Frist; Status bleibt VERSANDT, redeemed_at bleibt leer.
INSERT INTO invitation (actor_id, portal_code, mail, token_hash, sent_at, expires_at, status)
SELECT a.id, 'ENDUSER', a.email, pruef_tokenwert('tok-abgelaufen-9a4b7c2e1f5d0836', :'pfeffer'),
       now() - interval '30 hours', now() - interval '30 hours' + interval '24 hours', 'VERSANDT'
  FROM actor a WHERE a.email = 'el_abgelaufen@pruef.example';

-- el_verbraucht: bereits eingeloest, Frist laeuft noch (isoliert die
-- Bedingung "schon verbraucht" von "abgelaufen").
INSERT INTO invitation (actor_id, portal_code, mail, token_hash, sent_at, expires_at, status, redeemed_at)
SELECT a.id, 'ENDUSER', a.email, pruef_tokenwert('tok-verbraucht-2c5e8a1b4d7f0936', :'pfeffer'),
       now() - interval '2 hours', now() + interval '21 hours', 'EINGELOEST', now() - interval '1 hour'
  FROM actor a WHERE a.email = 'el_verbraucht@pruef.example';

-- el_widerrufen: widerrufen, Frist laeuft noch (isoliert "widerrufen").
INSERT INTO invitation (actor_id, portal_code, mail, token_hash, sent_at, expires_at, status)
SELECT a.id, 'ENDUSER', a.email, pruef_tokenwert('tok-widerrufen-7b1d4f8a2c5e0937', :'pfeffer'),
       now() - interval '3 hours', now() + interval '20 hours', 'WIDERRUFEN'
  FROM actor a WHERE a.email = 'el_widerrufen@pruef.example';

-- el_gesperrt: die Einladung selbst ist tadellos -- verletzt ist
-- ausschliesslich der Kontozustand.
INSERT INTO invitation (actor_id, portal_code, mail, token_hash, sent_at, expires_at, status)
SELECT a.id, 'ENDUSER', a.email, pruef_tokenwert('tok-gesperrt-4f8b1d7a2c5e0938', :'pfeffer'),
       now(), now() + interval '23 hours', 'VERSANDT'
  FROM actor a WHERE a.email = 'el_gesperrt@pruef.example';

-- el_gleichzeitig: offen, unverbraucht -- Ziel der Konkurrenzpruefung.
INSERT INTO invitation (actor_id, portal_code, mail, token_hash, sent_at, expires_at, status)
SELECT a.id, 'ENDUSER', a.email, pruef_tokenwert('tok-gleichzeitig-1a4d7f2b8c5e0939', :'pfeffer'),
       now(), now() + interval '23 hours', 'VERSANDT'
  FROM actor a WHERE a.email = 'el_gleichzeitig@pruef.example';

-- ---------------------------------------------------------------------
-- 7 · Sicht auf die Lage -- einloesung_lauf.sh prueft damit den AUFBAU,
--     bevor ein einziger Fall laeuft.
-- ---------------------------------------------------------------------
CREATE OR REPLACE VIEW pruef_einladung_lage AS
SELECT a.email,
       a.id                                         AS actor_id,
       a.status::text                                AS actor_status,
       a.status_before_lock::text                    AS status_before_lock,
       i.id                                          AS invitation_id,
       i.status::text                                AS invitation_status,
       i.sent_at,
       i.expires_at,
       (i.expires_at > now())                        AS noch_offen_frist,
       i.redeemed_at,
       (SELECT count(*) FROM membership m
         WHERE m.actor_id = a.id)                    AS mitgliedschaften,
       (SELECT count(*) FROM membership m JOIN portal p ON p.code = m.portal_code
         WHERE m.actor_id = a.id AND p.release_status = 'ENABLED')
                                                      AS freigeschaltete_portale
  FROM actor a
  LEFT JOIN invitation i ON i.actor_id = a.id
 WHERE a.email LIKE 'el_%@pruef.example';

-- ---------------------------------------------------------------------
-- 8 · AUFBAUPRUEFUNG (F07)
--
--     Ein Negativfall gilt erst als bestanden, wenn er an SEINER Regel
--     scheitert. Also wird hier geprueft, dass jedes Konto genau das
--     mitbringt, was sein Fall braucht -- und genau eine Abweichung.
-- ---------------------------------------------------------------------
DO $$
DECLARE r record; fehler text := '';
BEGIN
  -- (a) Jedes Pruefkonto hat genau eine Einladung.
  FOR r IN SELECT email, count(invitation_id) AS n
             FROM pruef_einladung_lage GROUP BY email HAVING count(invitation_id) <> 1
  LOOP fehler := fehler || format('%s hat %s Einladungen statt 1; ', r.email, r.n); END LOOP;

  -- (b) Jedes Pruefkonto ist ENDUSER-Mitglied in genau einem freigeschalteten Portal.
  FOR r IN SELECT DISTINCT email, mitgliedschaften, freigeschaltete_portale
             FROM pruef_einladung_lage
            WHERE freigeschaltete_portale <> 1
  LOOP fehler := fehler || format('%s hat %s freigeschaltete Portale statt 1; ', r.email, r.freigeschaltete_portale); END LOOP;

  -- (c) el_positiv, el_gesperrt, el_gleichzeitig: VERSANDT, Frist offen, unverbraucht.
  FOR r IN SELECT * FROM pruef_einladung_lage
            WHERE email IN ('el_positiv@pruef.example','el_gesperrt@pruef.example','el_gleichzeitig@pruef.example')
              AND (invitation_status <> 'VERSANDT' OR NOT noch_offen_frist OR redeemed_at IS NOT NULL)
  LOOP fehler := fehler || format('%s: Grundzustand VERSANDT/offen/unverbraucht verletzt; ', r.email); END LOOP;

  -- (d) el_abgelaufen: VERSANDT, Frist ABGELAUFEN, unverbraucht -- NUR die Frist ist verletzt.
  IF EXISTS (SELECT 1 FROM pruef_einladung_lage
              WHERE email='el_abgelaufen@pruef.example'
                AND (invitation_status <> 'VERSANDT' OR noch_offen_frist OR redeemed_at IS NOT NULL)) THEN
    fehler := fehler || 'el_abgelaufen@: Fallbedingung (nur die Frist verletzt) stimmt nicht; ';
  END IF;

  -- (e) el_verbraucht: EINGELOEST, redeemed_at gesetzt, Frist NOCH offen -- NUR "schon verbraucht".
  IF EXISTS (SELECT 1 FROM pruef_einladung_lage
              WHERE email='el_verbraucht@pruef.example'
                AND (invitation_status <> 'EINGELOEST' OR redeemed_at IS NULL OR NOT noch_offen_frist)) THEN
    fehler := fehler || 'el_verbraucht@: Fallbedingung (nur schon eingeloest) stimmt nicht; ';
  END IF;

  -- (f) el_widerrufen: WIDERRUFEN, Frist noch offen, kein redeemed_at.
  IF EXISTS (SELECT 1 FROM pruef_einladung_lage
              WHERE email='el_widerrufen@pruef.example'
                AND (invitation_status <> 'WIDERRUFEN' OR NOT noch_offen_frist OR redeemed_at IS NOT NULL)) THEN
    fehler := fehler || 'el_widerrufen@: Fallbedingung (nur widerrufen) stimmt nicht; ';
  END IF;

  -- (g) Kontozustaende.
  IF (SELECT actor_status FROM pruef_einladung_lage WHERE email='el_gesperrt@pruef.example') <> 'GESPERRT' THEN
    fehler := fehler || 'el_gesperrt@ ist nicht GESPERRT; ';
  END IF;
  FOR r IN SELECT DISTINCT email, actor_status FROM pruef_einladung_lage
            WHERE email IN ('el_positiv@pruef.example','el_abgelaufen@pruef.example',
                            'el_widerrufen@pruef.example','el_gleichzeitig@pruef.example')
              AND actor_status <> 'WARTET_2FA'
  LOOP fehler := fehler || format('%s ist nicht WARTET_2FA; ', r.email); END LOOP;
  IF (SELECT actor_status FROM pruef_einladung_lage WHERE email='el_verbraucht@pruef.example') <> 'AKTIV' THEN
    fehler := fehler || 'el_verbraucht@ ist nicht AKTIV; ';
  END IF;

  -- (h) Streuwerte sind wirklich Streuwerte: 64 Hex-Zeichen, kein Klartext-Token darin.
  FOR r IN SELECT email, invitation_id FROM pruef_einladung_lage
            WHERE invitation_id IS NOT NULL
  LOOP
    IF NOT EXISTS (SELECT 1 FROM invitation i
                    WHERE i.id = r.invitation_id AND i.token_hash ~ '^[0-9a-f]{64}$') THEN
      fehler := fehler || format('%s: token_hash ist kein 64-stelliger Hex-Streuwert; ', r.email);
    END IF;
  END LOOP;

  -- (i) Der Admin steht und ist aktiv (sonst scheitert jeder spaetere Lauf-Rebuild).
  IF NOT EXISTS (SELECT 1 FROM actor a JOIN membership m ON m.actor_id = a.id
                  WHERE a.email='plattformadmin@pruef.example' AND a.status='AKTIV' AND m.portal_code='EXMA') THEN
    fehler := fehler || 'Plattform-Admin fehlt oder ist nicht aktiv; ';
  END IF;

  IF fehler <> '' THEN
    RAISE EXCEPTION 'AUFBAU UNBRAUCHBAR (F07): %', fehler;
  END IF;
END $$;

-- ---------------------------------------------------------------------
-- 9 · Was jetzt steht
-- ---------------------------------------------------------------------
SELECT email, actor_status, invitation_status, noch_offen_frist,
       (redeemed_at IS NOT NULL) AS eingeloest, mitgliedschaften, freigeschaltete_portale
  FROM pruef_einladung_lage
 ORDER BY email;

\echo 'Pruefdaten stehen. Aufbaupruefung (F07) bestanden.'
