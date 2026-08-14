-- =====================================================================
-- FREIRAUM · Scheibe · Anmeldecode nach Einloesung
-- Pruefdaten fuer die Klauselpruefung  (anmeldecode_lauf.sh)
--
-- Geschrieben gegen K03 v1.3, K20 v1.3, K23 v1.1, K19 EN-01 und
-- schema/K19_screens.yaml -- NICHT gegen den Umsetzungscode. Machart wie
-- einloesung_daten.sql / anmeldung_daten.sql (die eigenen Vorbilder).
--
-- GEPRUEFTE LUECKE: Es gibt in der Anwendung keinen Weg, einen
-- Anmeldecode zu bekommen; mail/versand.py:anmeldecode() haengt an
-- keiner Route. Der Vertrag (K19 EN-01) sieht keinen eigenen Bildschirm
-- vor -- die Adresse ist "aus der Einladung vorbelegt", der Code kommt
-- "per E-Mail". Der einzige im Vertrag vorgesehene Ausloeser ist daher
-- die EINLOESUNG der Einladung selbst (POST /einladung, Erfolg -> 303
-- auf /anmeldung). Diese Datei bereitet FUENF frisch eingeladene Konten
-- vor (WARTET_2FA, ein offener, gueltiger Einladungstoken, NOCH KEIN
-- Anmeldecode) -- der Code entsteht nicht hier, sondern soll durch die
-- Einloesung selbst entstehen. Genau das misst anmeldecode_lauf.sh.
--
-- Aufruf:
--   FREIRAUM_CODE_PFEFFER=... \
--   psql -h localhost -p 55433 -U postgres -d <wegwerfdatenbank> \
--        -v ON_ERROR_STOP=1 -f anmeldecode_daten.sql
--
-- Die Datei ist WIEDERHOLBAR: sie setzt ihre Testkonten, Einladungen und
-- fluechtigen Spuren (login_code, login_attempt, auth_session) zurueck,
-- statt sie zu loeschen. EVENT ist Nachweis (append-only) und wird darum
-- NICHT geloescht -- anmeldecode_lauf.sh setzt vor jedem nachweispflichtigen
-- Fall eine eigene Zeitmarke und misst nur Ereignisse danach.
--
-- MASSSTAB F07: Jedes Pruefkonto verletzt zu Beginn KEINE Bedingung --
-- es ist ein tadelloses, frisch eingeladenes Konto mit offenem,
-- fristgerechtem Token. Die Faelle entstehen erst durch das, was
-- anmeldecode_lauf.sh mit ihm TUT (Einloesung ausloesen, dann pruefen).
-- Der Aufbau wird am Ende dieser Datei selbst geprueft; stimmt er nicht,
-- bricht der Lauf mit dem Wort ABBRUCH ab, statt Faelle zu melden, die
-- an einer falschen Vorbedingung scheitern.
-- =====================================================================

\set ON_ERROR_STOP on

-- ---------------------------------------------------------------------
-- 0 · Der Pfeffer.
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
-- 1 · Der Streuwert des Einladungstokens (wie einloesung_daten.sql).
--     Ein Streuwert fuer login_code.code_hash wird HIER NICHT gebraucht
--     -- dieser Prueflauf seedet keinen Code, er liest den Code, den die
--     Anwendung selbst versendet, aus dem Mailfang (anmeldecode_lauf.sh
--     Abschn. "Werkzeug"). pruef_codewert steht trotzdem bereit: mehrere
--     Faelle rechnen den gelesenen Klartext-Code gegen den gespeicherten
--     Streuwert nach (K03-M05: "Gespeichert wird nur sein
--     kryptografischer Pruefwert").
-- ---------------------------------------------------------------------
CREATE OR REPLACE FUNCTION pruef_tokenwert(klartext text, pfeffer text)
RETURNS text LANGUAGE sql IMMUTABLE AS
$$ SELECT encode(sha256(convert_to(pfeffer || klartext, 'utf8')), 'hex') $$;

CREATE OR REPLACE FUNCTION pruef_codewert(klartext text, pfeffer text)
RETURNS text LANGUAGE sql IMMUTABLE AS
$$ SELECT encode(sha256(convert_to(pfeffer || klartext, 'utf8')), 'hex') $$;

-- ---------------------------------------------------------------------
-- 2 · Mandanten
-- ---------------------------------------------------------------------
INSERT INTO tenant (id, kind, name, customer_code, legal_space)
VALUES ('00000000-0000-4000-8000-0000000000ac', 'OPERATOR', 'Pruefbetreiber Anmeldecode', NULL, 'DE')
ON CONFLICT (id) DO NOTHING;

INSERT INTO tenant (id, kind, name, customer_code, legal_space, invite_ttl_hours, invite_domain)
VALUES ('00000000-0000-4000-8000-0000000000ad', 'CUSTOMER', 'Pruefkunde Anmeldecode', 'DE-ACD', 'DE', 24, NULL)
ON CONFLICT (id) DO NOTHING;

-- ---------------------------------------------------------------------
-- 3 · Der Plattform-Admin ZUERST (platform_admin_guard, siehe die
--     Schwesterdateien).
-- ---------------------------------------------------------------------
INSERT INTO actor (id, tenant_id, email, display_name, mfa_method, status, created_on)
VALUES ('00000000-0000-4000-8000-000000000ac1',
        '00000000-0000-4000-8000-0000000000ac',
        'plattformadmin@pruef.example', 'Pruef Plattform-Admin', 'EMAIL_CODE', 'AKTIV', current_date)
ON CONFLICT (id) DO NOTHING;

INSERT INTO membership (actor_id, portal_code, role_id, tenant_scope)
SELECT '00000000-0000-4000-8000-000000000ac1', 'EXMA', r.id, '00000000-0000-4000-8000-0000000000ac'
  FROM role r WHERE r.portal_code = 'EXMA' AND r.name = 'Plattform-Admin'
ON CONFLICT DO NOTHING;

UPDATE actor SET status = 'AKTIV'
 WHERE id = '00000000-0000-4000-8000-000000000ac1' AND status <> 'AKTIV';

-- ---------------------------------------------------------------------
-- 4 · Die fuenf Pruefkonten -- jedes WARTET_2FA, jedes ohne Code.
--
--     Zuordnung (welcher Fall in anmeldecode_lauf.sh das Konto braucht):
--       ac_kette@         AC-01, AC-02, AC-03, AC-05, AC-10, AC-11, AC-13,
--                         AC-14 (eine Kette: Versand -> Anmeldung -> Frist ->
--                         Wiederverwendung -> Nachweis -> Gegenstueck zu AC-01;
--                         AC-14 ergaenzt am 2026-08-14, P1 der Gegenpruefung)
--       ac_frist@         AC-04                        (Frist manipuliert)
--       ac_unterschwelle@ AC-06                        (vier Fehlversuche,
--                         Gegenprobe zu AC-07)
--       ac_gesperrt5@     AC-07                        (fuenf Fehlversuche)
--       ac_gegenprobe@    AC-08, AC-09, AC-12, AC-13    (Ununterscheidbarkeit,
--                         Kreuzpruefung gegen ac_kette@)
--       ac_unbekannt@     kein Konto -- der Fall AC-09 selbst
-- ---------------------------------------------------------------------
INSERT INTO actor (id, tenant_id, email, display_name, mfa_method, status, status_before_lock, last_login_at, created_on) VALUES
  ('00000000-0000-4000-8000-000000000ac2','00000000-0000-4000-8000-0000000000ad','ac_kette@pruef.example',         'Pruef AC Kette',         'EMAIL_CODE','WARTET_2FA', NULL, NULL, current_date),
  ('00000000-0000-4000-8000-000000000ac3','00000000-0000-4000-8000-0000000000ad','ac_frist@pruef.example',         'Pruef AC Frist',         'EMAIL_CODE','WARTET_2FA', NULL, NULL, current_date),
  ('00000000-0000-4000-8000-000000000ac4','00000000-0000-4000-8000-0000000000ad','ac_unterschwelle@pruef.example', 'Pruef AC Unterschwelle', 'EMAIL_CODE','WARTET_2FA', NULL, NULL, current_date),
  ('00000000-0000-4000-8000-000000000ac5','00000000-0000-4000-8000-0000000000ad','ac_gesperrt5@pruef.example',     'Pruef AC Gesperrt Fuenf','EMAIL_CODE','WARTET_2FA', NULL, NULL, current_date),
  ('00000000-0000-4000-8000-000000000ac6','00000000-0000-4000-8000-0000000000ad','ac_gegenprobe@pruef.example',    'Pruef AC Gegenprobe',    'EMAIL_CODE','WARTET_2FA', NULL, NULL, current_date)
ON CONFLICT (id) DO UPDATE SET
  tenant_id          = EXCLUDED.tenant_id,
  email              = EXCLUDED.email,
  display_name       = EXCLUDED.display_name,
  mfa_method         = EXCLUDED.mfa_method,
  status             = EXCLUDED.status,
  status_before_lock = EXCLUDED.status_before_lock,
  last_login_at      = EXCLUDED.last_login_at;

-- ac_unbekannt@pruef.example darf NIE als Konto existieren -- das ist
-- der Fall selbst (AC-09). Zur Sicherheit hier ausdruecklich entfernt,
-- falls ein frueherer, anders gearteter Lauf sie angelegt haette.
DELETE FROM actor WHERE email = 'ac_unbekannt@pruef.example';

-- ---------------------------------------------------------------------
-- 5 · Alten Lauf zuruecksetzen (fluechtige Spuren; die Konten selbst
--     bleiben stehen, siehe anmeldung_daten.sql Abschn. 4).
-- ---------------------------------------------------------------------
DELETE FROM login_code
 WHERE actor_id IN (SELECT id FROM actor WHERE email LIKE 'ac\_%@pruef.example' ESCAPE '\');
DELETE FROM auth_session
 WHERE actor_id IN (SELECT id FROM actor WHERE email LIKE 'ac\_%@pruef.example' ESCAPE '\');
DELETE FROM login_attempt
 WHERE email LIKE 'ac\_%@pruef.example' ESCAPE '\';
DELETE FROM invitation
 WHERE actor_id IN (SELECT id FROM actor WHERE email LIKE 'ac\_%@pruef.example' ESCAPE '\');

-- ---------------------------------------------------------------------
-- 6 · Mitgliedschaften -- ENDUSER im freigeschalteten Portal, fuer alle
--     fuenf Pruefkonten gleich (kein Fall dieser Scheibe misst die
--     Mitgliedschaft selbst).
-- ---------------------------------------------------------------------
DELETE FROM membership
 WHERE actor_id IN (SELECT id FROM actor WHERE email LIKE 'ac\_%@pruef.example' ESCAPE '\');

INSERT INTO membership (actor_id, portal_code, role_id, tenant_scope)
SELECT a.id, 'ENDUSER', r.id, '00000000-0000-4000-8000-0000000000ad'
  FROM actor a
  CROSS JOIN (SELECT id FROM role WHERE portal_code='ENDUSER' AND name='Endnutzer') r
 WHERE a.email LIKE 'ac\_%@pruef.example' ESCAPE '\'
ON CONFLICT DO NOTHING;

-- ---------------------------------------------------------------------
-- 7 · Die Einladungen -- je Konto EIN offener, fristgerechter Token.
--     Klartext-Tokens (die anmeldecode_lauf.sh sendet) stehen NUR hier
--     als Kommentar -- die Tabelle traegt ausschliesslich den Streuwert.
--
--       ac_kette@           tok-ac-kette-3f7b1d9a4c6e0281
--       ac_frist@           tok-ac-frist-8b2e5f1a7c4d0392
--       ac_unterschwelle@   tok-ac-unterschwelle-1d4a7f2b8c5e0493
--       ac_gesperrt5@       tok-ac-gesperrt5-6c9e2b5f8a1d0594
--       ac_gegenprobe@      tok-ac-gegenprobe-4a7d1f8b2c5e0695
-- ---------------------------------------------------------------------
INSERT INTO invitation (actor_id, portal_code, mail, token_hash, sent_at, expires_at, status)
SELECT a.id, 'ENDUSER', a.email, pruef_tokenwert(v.tok, :'pfeffer'), now(), now() + interval '23 hours', 'VERSANDT'
  FROM (VALUES
      ('ac_kette@pruef.example',         'tok-ac-kette-3f7b1d9a4c6e0281'),
      ('ac_frist@pruef.example',         'tok-ac-frist-8b2e5f1a7c4d0392'),
      ('ac_unterschwelle@pruef.example', 'tok-ac-unterschwelle-1d4a7f2b8c5e0493'),
      ('ac_gesperrt5@pruef.example',     'tok-ac-gesperrt5-6c9e2b5f8a1d0594'),
      ('ac_gegenprobe@pruef.example',    'tok-ac-gegenprobe-4a7d1f8b2c5e0695')
   ) AS v(mail, tok)
  JOIN actor a ON a.email = v.mail;

-- ---------------------------------------------------------------------
-- 8 · Sicht auf die Lage -- anmeldecode_lauf.sh prueft damit den AUFBAU,
--     bevor ein einziger Fall laeuft.
-- ---------------------------------------------------------------------
CREATE OR REPLACE VIEW pruef_anmeldecode_lage AS
SELECT a.email,
       a.id                                        AS actor_id,
       a.status::text                              AS actor_status,
       a.last_login_at,
       i.id                                        AS invitation_id,
       i.status::text                              AS invitation_status,
       i.redeemed_at,
       (i.expires_at > now())                      AS noch_offen_frist,
       (SELECT count(*) FROM membership m JOIN portal p ON p.code = m.portal_code
         WHERE m.actor_id = a.id AND p.release_status = 'ENABLED')
                                                    AS freigeschaltete_portale,
       (SELECT count(*) FROM login_code c
         WHERE c.actor_id = a.id)                  AS codes_gesamt,
       (SELECT count(*) FROM auth_session s
         WHERE s.actor_id = a.id AND s.ended_at IS NULL)
                                                    AS offene_sitzungen
  FROM actor a
  LEFT JOIN invitation i ON i.actor_id = a.id
 WHERE a.email LIKE 'ac\_%@pruef.example' ESCAPE '\';

-- ---------------------------------------------------------------------
-- 9 · AUFBAUPRUEFUNG (F07)
-- ---------------------------------------------------------------------
DO $$
DECLARE r record; fehler text := '';
BEGIN
  -- (a) Jedes der fuenf Pruefkonten hat genau eine Einladung.
  FOR r IN SELECT email, count(invitation_id) AS n
             FROM pruef_anmeldecode_lage GROUP BY email HAVING count(invitation_id) <> 1
  LOOP fehler := fehler || format('%s hat %s Einladungen statt 1; ', r.email, r.n); END LOOP;

  -- (b) VERSANDT, Frist offen, unverbraucht -- fuer alle fuenf gleich.
  FOR r IN SELECT * FROM pruef_anmeldecode_lage
            WHERE invitation_status <> 'VERSANDT' OR NOT noch_offen_frist OR redeemed_at IS NOT NULL
  LOOP fehler := fehler || format('%s: Grundzustand VERSANDT/offen/unverbraucht verletzt; ', r.email); END LOOP;

  -- (c) Genau ein freigeschaltetes Portal.
  FOR r IN SELECT * FROM pruef_anmeldecode_lage WHERE freigeschaltete_portale <> 1
  LOOP fehler := fehler || format('%s hat %s freigeschaltete Portale statt 1; ', r.email, r.freigeschaltete_portale); END LOOP;

  -- (d) WARTET_2FA, keine letzte Anmeldung (K03-G05).
  FOR r IN SELECT * FROM pruef_anmeldecode_lage
            WHERE actor_status <> 'WARTET_2FA' OR last_login_at IS NOT NULL
  LOOP fehler := fehler || format('%s ist nicht sauber WARTET_2FA (Status %s, last_login_at %s); ', r.email, r.actor_status, r.last_login_at); END LOOP;

  -- (e) NOCH KEIN Code -- der Code soll durch die Einloesung entstehen,
  --     nicht durch diese Datei. Ein vorab gesetzter Code wuerde AC-01
  --     nichts mehr messen lassen.
  FOR r IN SELECT * FROM pruef_anmeldecode_lage WHERE codes_gesamt <> 0
  LOOP fehler := fehler || format('%s hat bereits %s Code(s) vor der Einloesung; ', r.email, r.codes_gesamt); END LOOP;

  -- (f) Keine Altsitzungen aus einem frueheren Lauf.
  IF EXISTS (SELECT 1 FROM pruef_anmeldecode_lage WHERE offene_sitzungen > 0) THEN
    fehler := fehler || 'es stehen noch offene Sitzungen aus einem frueheren Lauf; ';
  END IF;
  IF EXISTS (SELECT 1 FROM login_attempt WHERE email LIKE 'ac\_%@pruef.example' ESCAPE '\') THEN
    fehler := fehler || 'es stehen noch Anmeldeversuche aus einem frueheren Lauf; ';
  END IF;

  -- (g) ac_unbekannt@ existiert nirgends -- sonst misst AC-09 nichts.
  IF EXISTS (SELECT 1 FROM actor WHERE email = 'ac_unbekannt@pruef.example') THEN
    fehler := fehler || 'ac_unbekannt@ existiert als Konto -- misst AC-09 nicht mehr; ';
  END IF;

  -- (h) Der Admin steht und ist aktiv.
  IF NOT EXISTS (SELECT 1 FROM actor a JOIN membership m ON m.actor_id = a.id
                  WHERE a.email='plattformadmin@pruef.example' AND a.status='AKTIV' AND m.portal_code='EXMA') THEN
    fehler := fehler || 'Plattform-Admin fehlt oder ist nicht aktiv; ';
  END IF;

  IF fehler <> '' THEN
    RAISE EXCEPTION 'AUFBAU UNBRAUCHBAR (F07): %', fehler;
  END IF;
END $$;

-- ---------------------------------------------------------------------
-- 10 · Was jetzt steht
-- ---------------------------------------------------------------------
SELECT email, actor_status, invitation_status, noch_offen_frist,
       freigeschaltete_portale, codes_gesamt
  FROM pruef_anmeldecode_lage
 ORDER BY email;

\echo 'Pruefdaten stehen. Aufbaupruefung (F07) bestanden. Kein Konto traegt bereits einen Code -- die Einloesung muss ihn erst versenden.'
