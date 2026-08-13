-- =====================================================================
-- FREIRAUM · Scheibe · Mitgliedschaft aus der Einladung (Blatt 62)
-- Pruefdaten fuer die Klauselpruefung  (mitgliedschaft_lauf.sh)
--
-- Geschrieben gegen Blatt 62 (gezeichnet von beiden Foundern, 11.08.2026),
-- K03-M11, K20-M05/M18/D02/D05, freiraum_datamodel.sql und
-- M30__pilot_sammelmigration.sql -- NICHT gegen den Umsetzungscode
-- (app/einladung_senden.py, app/einladung.py kommen in diesem Arbeitsbaum
-- nicht vor). Machart und Aufrufvertrag wie versand_daten.sql und
-- einloesung_daten.sql (die zwei Vorbilder dieser Scheibe).
--
-- GEGENSTAND: nicht der Versand- oder Einloesungsvorgang selbst (die sind
-- bereits eigene Scheiben), sondern die MITGLIEDSCHAFTS-Nebenwirkung, die
-- Blatt 62 an beide bindet:
--   * Versand legt GENAU EINE Mitgliedschaft an (actor_id/portal_code/
--     role_id/tenant_scope wie im Vertrag benannt), in derselben
--     Transaktion wie die Einladung.
--   * Widerruf/Ablauf einer Einladung entfernt sie wieder, im selben
--     Serverpfad, derselben Transaktion.
--   * Einloesung legt KEINE neue Mitgliedschaft an -- sie besteht schon.
--   * Erneuter Versand (K20-M13) hinterlaesst genau eine, nicht zwei,
--     nicht keine.
--   * Eine bereits eingeloeste Einladung darf ihre Mitgliedschaft NIE
--     verlieren, gleich auf welchem Weg erneut ueber sie versucht wird.
--
-- ANNAHME, aus versand_lauf.sh uebernommen (dort ausdruecklich benannt,
-- VE-08-Kommentar): Die Maske /einladung/senden stellt kein Portal zur
-- Wahl -- das Zielportal dieser Tuer ist fest EXMA. Alle ueber HTTP neu
-- eingeladenen Pruefkonten dieser Datei werden deshalb EXMA/Plattform-
-- Admin. Wo eine zweite Mitgliedschaft (ENDUSER) noetig ist (K03-M11,
-- MG-04), wird sie DIREKT gesetzt -- nicht durch diese Tuer, sondern als
-- Stellvertreter fuer eine andere Vergabe (z.B. eine spaetere Scheibe).
--
-- Aufruf:
--   FREIRAUM_CODE_PFEFFER=... \
--   psql -h localhost -p 55433 -U postgres -d <wegwerfdatenbank> \
--        -v ON_ERROR_STOP=1 -f mitgliedschaft_daten.sql
--
-- Die Datenbank wird zuvor aus schema/freiraum_datamodel.sql und
-- migrations/M30__pilot_sammelmigration.sql angelegt. Die Datei ist
-- WIEDERHOLBAR: sie loescht ihre eigenen Pruefkonten (@pruef.example,
-- ausser dem Bootstrap-Admin) und baut sie frisch auf, statt Zeilen
-- anzuhaeufen. event bleibt unangetastet (append-only) -- jeder Lauf
-- erzeugt frische Einladungs- und Mitgliedschafts-IDs, alte
-- Nachweiszeilen stoeren daher nicht.
--
-- MASSSTAB F07: Jedes statische Pruefkonto traegt genau die Vorbedingung,
-- die sein Fall braucht. Die drei DYNAMISCHEN Fallziele (mg_neu@,
-- mg_geplant@, mg_faden@) existieren VOR dem ersten HTTP-Aufruf NICHT --
-- sonst misst der zugehoerige Fall einen Rest aus einem fruehen Teil
-- desselben Laufs statt der Neuanlage. Der Aufbau wird am Ende dieser
-- Datei selbst geprueft; stimmt er nicht, bricht der Lauf mit dem Wort
-- ABBRUCH ab, statt Faelle zu melden, die an der falschen Bedingung
-- scheitern.
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
    RAISE EXCEPTION 'ABBRUCH: FREIRAUM_CODE_PFEFFER ist leer (wie BEF-L2-1 bei der Anmeldung)';
  END IF;
END $$;

-- ---------------------------------------------------------------------
-- 1 · Der Streuwert -- EINE Formel fuer Anmeldecode UND Einladungstoken
--     (uebernommen aus versand_daten.sql, dort ausfuehrlich begruendet).
--     Bildet der Serverpfad sie anders, ist allein diese Funktion
--     anzupassen; alle codeabhaengigen Faelle haengen an ihr.
-- ---------------------------------------------------------------------
CREATE OR REPLACE FUNCTION pruef_codewert(klartext text, pfeffer text)
RETURNS text LANGUAGE sql IMMUTABLE AS
$$ SELECT encode(sha256(convert_to(pfeffer || klartext, 'utf8')), 'hex') $$;

-- ---------------------------------------------------------------------
-- 2 · Mandanten. EIN Betreiber-Mandant traegt die Domaenenschranke und
--     die Frist (K02, hier nur Vorbedingung). EIN Kunden-Mandant traegt
--     den Geltungsbereich der zweiten (ENDUSER-)Mitgliedschaft in MG-04.
-- ---------------------------------------------------------------------
INSERT INTO tenant (id, kind, name, customer_code, legal_space, invite_domain, invite_ttl_hours)
VALUES ('00000000-0000-4000-a000-0000000000f1', 'OPERATOR', 'Pruefbetreiber Mitgliedschaft', NULL, 'DE',
        'pruef.example', 24)
ON CONFLICT (id) DO UPDATE SET
  invite_domain    = EXCLUDED.invite_domain,
  invite_ttl_hours = EXCLUDED.invite_ttl_hours;

INSERT INTO tenant (id, kind, name, customer_code, legal_space)
VALUES ('00000000-0000-4000-a000-0000000000f2', 'CUSTOMER', 'Pruefkunde Mitgliedschaft', 'DE-MTG', 'DE')
ON CONFLICT (id) DO NOTHING;

-- ---------------------------------------------------------------------
-- 3 · Globale Portalfreischaltung zuruecksetzen, BEVOR irgendetwas
--     anderes laeuft (Grund wie versand_daten.sql Abschn. 3: MG-03
--     schaltet EXMA kurzzeitig auf PLANNED; heilt einen abgebrochenen
--     Vorlauf).
-- ---------------------------------------------------------------------
UPDATE portal SET release_status = 'ENABLED' WHERE code IN ('EXMA','ENDUSER');

-- ---------------------------------------------------------------------
-- 4 · Der Plattform-Admin ZUERST, unangetastet ueber den ganzen Lauf.
--     platform_admin_guard (AFTER UPDATE OR DELETE ON actor/membership,
--     FOR EACH STATEMENT) verlangt jederzeit mindestens einen aktiven
--     EXMA-Admin. Dieses Konto ist reiner Aufbau -- kein Prueffall
--     greift es an.
-- ---------------------------------------------------------------------
INSERT INTO actor (id, tenant_id, email, display_name, mfa_method, status, created_on)
VALUES ('00000000-0000-4000-a000-000000000001',
        '00000000-0000-4000-a000-0000000000f1',
        'bootstrapadmin@pruef.example', 'Pruef Bootstrap-Admin', 'EMAIL_CODE', 'AKTIV', current_date)
ON CONFLICT (id) DO NOTHING;

INSERT INTO membership (actor_id, portal_code, role_id, tenant_scope)
SELECT '00000000-0000-4000-a000-000000000001', 'EXMA', r.id, '00000000-0000-4000-a000-0000000000f1'
  FROM role r WHERE r.portal_code = 'EXMA'
ON CONFLICT DO NOTHING;

UPDATE actor SET status = 'AKTIV'
 WHERE id = '00000000-0000-4000-a000-000000000001' AND status <> 'AKTIV';

-- ---------------------------------------------------------------------
-- 5 · Alten Lauf vollstaendig zuruecksetzen. Der Bootstrap-Admin bleibt
--     aussen vor, sonst faellt der Guard aus Abschnitt 4 in sich
--     zusammen. Alles Uebrige (einladend@ und alle mg_*@) wird geloescht
--     und unten frisch aufgebaut -- so bleibt die Datei wiederholbar,
--     auch wenn ein frueherer Lauf mitten in MG-05 (Erneuter Versand)
--     abgebrochen ist und zwei invitation-Zeilen hinterlassen hat.
--
--     invitation und membership fallen mit actor per ON DELETE CASCADE;
--     login_code und auth_session ebenso. login_attempt haengt nur an
--     der Adresse (kein FK) und braucht eine eigene Zeile. event bleibt
--     unberuehrt (append-only).
-- ---------------------------------------------------------------------
DELETE FROM actor
 WHERE email LIKE '%@pruef.example'
   AND email <> 'bootstrapadmin@pruef.example';

DELETE FROM login_attempt WHERE email LIKE '%@pruef.example';

-- ---------------------------------------------------------------------
-- 6 · Das einladende Konto -- die Sitzung, mit der mitgliedschaft_lauf.sh
--     GET/POST /einladung/senden aufruft. AKTIV, Mitgliedschaft EXMA/
--     Plattform-Admin, Reichweite Betreiber-Mandant.
-- ---------------------------------------------------------------------
INSERT INTO actor (id, tenant_id, email, display_name, mfa_method, status, created_on)
VALUES ('00000000-0000-4000-a000-000000000002',
        '00000000-0000-4000-a000-0000000000f1',
        'einladend@pruef.example', 'Pruef Einladend', 'EMAIL_CODE', 'AKTIV', current_date);

INSERT INTO membership (actor_id, portal_code, role_id, tenant_scope)
SELECT '00000000-0000-4000-a000-000000000002', 'EXMA', r.id, '00000000-0000-4000-a000-0000000000f1'
  FROM role r WHERE r.portal_code = 'EXMA';

-- Frischer, gueltiger Anmeldecode (K03-M15: sechsstellig, zehn Minuten).
-- mitgliedschaft_lauf.sh meldet sich damit einmal an und haelt das
-- Sitzungs-Cookie fuer alle Faelle, die eine Sitzung brauchen.
INSERT INTO login_code (actor_id, code_hash, issued_at, expires_at)
SELECT id, pruef_codewert('700001', :'pfeffer'), now(), now() + interval '10 minutes'
  FROM actor WHERE email = 'einladend@pruef.example';

-- ---------------------------------------------------------------------
-- 7 · MG-05 · mg_wiederholt@ -- Grundlage fuer den Erneuter-Versand-Fall
--     (K20-M13 + K20-D05 + Sharp Point 1 aus Blatt 62). WARTET_2FA (noch
--     keine zweite Stufe bestaetigt). EINE offene Einladung, attempt=1.
--     Die Mitgliedschaft besteht BEREITS -- Blatt 62 legt sie beim
--     VERSAND an, nicht erst bei der Einloesung.
-- ---------------------------------------------------------------------
INSERT INTO actor (id, tenant_id, email, display_name, mfa_method, status, created_on)
VALUES ('00000000-0000-4000-a000-000000000003',
        '00000000-0000-4000-a000-0000000000f1',
        'mg_wiederholt@pruef.example', 'Pruef MG Wiederholt', 'EMAIL_CODE', 'WARTET_2FA', current_date);

INSERT INTO invitation (actor_id, portal_code, mail, token_hash, sent_at, expires_at, status, attempt)
SELECT '00000000-0000-4000-a000-000000000003', 'EXMA', 'mg_wiederholt@pruef.example',
       pruef_codewert('tok-mg-wiederholt-alt-6f2e9b1c4a7d', :'pfeffer'),
       now() - interval '2 hours', now() + interval '22 hours', 'VERSANDT', 1;

INSERT INTO membership (actor_id, portal_code, role_id, tenant_scope)
SELECT '00000000-0000-4000-a000-000000000003', 'EXMA', r.id, '00000000-0000-4000-a000-0000000000f1'
  FROM role r WHERE r.portal_code = 'EXMA';

-- ---------------------------------------------------------------------
-- 8 · MG-06 · mg_aktiv@ -- der gefaehrlichste Fall: eine bereits
--     eingeloeste Einladung, das Konto laengst AKTIV und arbeitend.
--     sent_at/expires_at liegen bewusst weit in der Vergangenheit (wie
--     bei einem echten, laengst onboardeten Nutzer) -- damit ein
--     Aufraeumpfad, der sich (fehlerhaft) an expires_at statt am Status
--     orientiert, hier GENAUSO greifen wuerde wie ein Aufraeumpfad, der
--     ueber den Wiederversand laeuft. Keine der beiden Formen darf die
--     bestehende Mitgliedschaft anruehren.
-- ---------------------------------------------------------------------
INSERT INTO actor (id, tenant_id, email, display_name, mfa_method, status, created_on)
VALUES ('00000000-0000-4000-a000-000000000004',
        '00000000-0000-4000-a000-0000000000f1',
        'mg_aktiv@pruef.example', 'Pruef MG Aktiv', 'EMAIL_CODE', 'AKTIV', current_date);

INSERT INTO invitation (actor_id, portal_code, mail, token_hash, sent_at, expires_at, status, redeemed_at)
SELECT '00000000-0000-4000-a000-000000000004', 'EXMA', 'mg_aktiv@pruef.example',
       pruef_codewert('tok-mg-aktiv-laengst-verbraucht-2c5e', :'pfeffer'),
       now() - interval '3 days',
       now() - interval '3 days' + interval '23 hours',
       'EINGELOEST',
       now() - interval '3 days' + interval '30 minutes';

INSERT INTO membership (actor_id, portal_code, role_id, tenant_scope)
SELECT '00000000-0000-4000-a000-000000000004', 'EXMA', r.id, '00000000-0000-4000-a000-0000000000f1'
  FROM role r WHERE r.portal_code = 'EXMA';

-- ---------------------------------------------------------------------
-- 9 · MG-07 · mg_bereitsmitglied@ -- die Einloesung darf KEINE zweite
--     Mitgliedschaft anlegen, weil sie schon besteht (aus dem Versand).
--     Bekannter Klartext-Token (nur hier als Kommentar; die Tabelle
--     traegt ausschliesslich den Streuwert, K20-M08):
--       mg_bereitsmitglied@   tok-mg-bereits-3f8a1c6e9d2b0741   gueltig, offen
-- ---------------------------------------------------------------------
INSERT INTO actor (id, tenant_id, email, display_name, mfa_method, status, created_on)
VALUES ('00000000-0000-4000-a000-000000000005',
        '00000000-0000-4000-a000-0000000000f1',
        'mg_bereitsmitglied@pruef.example', 'Pruef MG Bereits Mitglied', 'EMAIL_CODE', 'WARTET_2FA', current_date);

INSERT INTO invitation (actor_id, portal_code, mail, token_hash, sent_at, expires_at, status)
SELECT '00000000-0000-4000-a000-000000000005', 'EXMA', 'mg_bereitsmitglied@pruef.example',
       pruef_codewert('tok-mg-bereits-3f8a1c6e9d2b0741', :'pfeffer'),
       now(), now() + interval '23 hours', 'VERSANDT';

INSERT INTO membership (actor_id, portal_code, role_id, tenant_scope)
SELECT '00000000-0000-4000-a000-000000000005', 'EXMA', r.id, '00000000-0000-4000-a000-0000000000f1'
  FROM role r WHERE r.portal_code = 'EXMA';

-- ---------------------------------------------------------------------
-- 10 · MG-08 · mg_abgelaufen@ -- Ablauf, bestenfalls messbar (siehe
--      Kopf von mitgliedschaft_lauf.sh: es ist keine Tuer bekannt, die
--      einen Aufraeumlauf FUER ABGELAUFENE Einladungen ausdruecklich
--      ausloest; der Fall versucht es ueber den einzigen bekannten Weg,
--      der einen abgelaufenen Token ueberhaupt anfasst -- POST
--      /einladung -- und wertet TOLERANT aus, was er dabei sieht).
--      sent_at + volle Frist liegt in der Vergangenheit; Status bleibt
--      VERSANDT (noch nicht vom Server umgestellt), Mitgliedschaft
--      besteht wie bei jeder versandten Einladung.
--        mg_abgelaufen@   tok-mg-abgelaufen-7c2f9a4e1d6b0842   abgelaufen
-- ---------------------------------------------------------------------
INSERT INTO actor (id, tenant_id, email, display_name, mfa_method, status, created_on)
VALUES ('00000000-0000-4000-a000-000000000006',
        '00000000-0000-4000-a000-0000000000f1',
        'mg_abgelaufen@pruef.example', 'Pruef MG Abgelaufen', 'EMAIL_CODE', 'WARTET_2FA', current_date);

INSERT INTO invitation (actor_id, portal_code, mail, token_hash, sent_at, expires_at, status)
SELECT '00000000-0000-4000-a000-000000000006', 'EXMA', 'mg_abgelaufen@pruef.example',
       pruef_codewert('tok-mg-abgelaufen-7c2f9a4e1d6b0842', :'pfeffer'),
       now() - interval '30 hours', now() - interval '30 hours' + interval '24 hours', 'VERSANDT';

INSERT INTO membership (actor_id, portal_code, role_id, tenant_scope)
SELECT '00000000-0000-4000-a000-000000000006', 'EXMA', r.id, '00000000-0000-4000-a000-0000000000f1'
  FROM role r WHERE r.portal_code = 'EXMA';

-- ---------------------------------------------------------------------
-- 11 · MG-04 · mg_zweitportal@ -- K03-M11: "genau ein Portal, bestimmt
--      ueber membership. Genau eines -- nicht das erste von mehreren."
--      Die EXMA-Mitgliedschaft entstand (fiktiv) bei einer frueheren,
--      laengst eingeloesten Einladung -- wie mg_aktiv@. Die ENDUSER-
--      Mitgliedschaft wird HIER DIREKT gesetzt: sie steht fuer eine
--      Vergabe ausserhalb dieser Tuer (/einladung/senden vergibt nur
--      EXMA, siehe Kopf dieser Datei) und dient allein dazu, den
--      Positivpfad "zwei freigeschaltete Portale, Anmeldung waehlt
--      hoechstens eines" auch fuer ein Konto zu pruefen, dessen EINE
--      Mitgliedschaft ueber die Einladung entstanden ist.
-- ---------------------------------------------------------------------
INSERT INTO actor (id, tenant_id, email, display_name, mfa_method, status, created_on)
VALUES ('00000000-0000-4000-a000-000000000007',
        '00000000-0000-4000-a000-0000000000f1',
        'mg_zweitportal@pruef.example', 'Pruef MG Zweitportal', 'EMAIL_CODE', 'AKTIV', current_date);

INSERT INTO invitation (actor_id, portal_code, mail, token_hash, sent_at, expires_at, status, redeemed_at)
SELECT '00000000-0000-4000-a000-000000000007', 'EXMA', 'mg_zweitportal@pruef.example',
       pruef_codewert('tok-mg-zweitportal-9b4d7a2f1c5e0839', :'pfeffer'),
       now() - interval '1 day', now() - interval '1 day' + interval '23 hours', 'EINGELOEST',
       now() - interval '1 day' + interval '1 hour';

INSERT INTO membership (actor_id, portal_code, role_id, tenant_scope)
SELECT '00000000-0000-4000-a000-000000000007', 'EXMA', r.id, '00000000-0000-4000-a000-0000000000f1'
  FROM role r WHERE r.portal_code = 'EXMA';

INSERT INTO membership (actor_id, portal_code, role_id, tenant_scope)
SELECT '00000000-0000-4000-a000-000000000007', 'ENDUSER', r.id, '00000000-0000-4000-a000-0000000000f2'
  FROM role r WHERE r.portal_code = 'ENDUSER';

INSERT INTO login_code (actor_id, code_hash, issued_at, expires_at)
SELECT id, pruef_codewert('700004', :'pfeffer'), now(), now() + interval '10 minutes'
  FROM actor WHERE email = 'mg_zweitportal@pruef.example';

-- ---------------------------------------------------------------------
-- 12 · Sicht auf die Lage -- mitgliedschaft_lauf.sh prueft damit den
--      AUFBAU unmittelbar vor dem ersten Fall erneut (die Daten koennten
--      zwischenzeitlich durch einen frueheren Teil desselben Laufs
--      veraendert worden sein). Subqueries statt JOIN: ein Konto kann
--      nach MG-05/MG-06 mehr als eine invitation-Zeile tragen, ohne die
--      Sicht zu verzeilfachen.
-- ---------------------------------------------------------------------
CREATE OR REPLACE VIEW pruef_mitgliedschaft_lage AS
SELECT a.email,
       a.id                                          AS actor_id,
       a.status::text                                AS status,
       a.tenant_id,
       (SELECT count(*) FROM membership m
         WHERE m.actor_id = a.id)                    AS mitgliedschaften_gesamt,
       (SELECT count(*) FROM membership m
         WHERE m.actor_id = a.id AND m.portal_code = 'EXMA')  AS mitgliedschaft_exma,
       (SELECT count(*) FROM membership m
         WHERE m.actor_id = a.id AND m.portal_code = 'ENDUSER') AS mitgliedschaft_enduser,
       (SELECT count(*) FROM invitation i
         WHERE i.actor_id = a.id)                    AS einladungen_gesamt,
       (SELECT count(*) FROM invitation i
         WHERE i.actor_id = a.id AND i.status = 'VERSANDT') AS einladungen_offen,
       (SELECT count(*) FROM invitation i
         WHERE i.actor_id = a.id AND i.status = 'EINGELOEST') AS einladungen_eingeloest,
       (SELECT max(i.attempt) FROM invitation i
         WHERE i.actor_id = a.id)                    AS attempt_max,
       (SELECT count(*) FROM login_code c
         WHERE c.actor_id = a.id
           AND c.consumed_at IS NULL AND c.superseded_at IS NULL
           AND c.expires_at > now())                 AS offene_codes,
       (SELECT count(*) FROM auth_session s
         WHERE s.actor_id = a.id AND s.ended_at IS NULL) AS offene_sitzungen
  FROM actor a
 WHERE a.email LIKE '%@pruef.example';

-- ---------------------------------------------------------------------
-- 13 · AUFBAUPRUEFUNG (F07)
-- ---------------------------------------------------------------------
DO $$
DECLARE fehler text := '';
BEGIN
  -- (a) Mandant traegt die richtige Domaenenschranke und Frist.
  IF NOT EXISTS (SELECT 1 FROM tenant
                  WHERE id = '00000000-0000-4000-a000-0000000000f1'
                    AND invite_domain = 'pruef.example'
                    AND invite_ttl_hours = 24) THEN
    fehler := fehler || 'Betreiber-Mandant traegt nicht die erwartete Domaenenschranke/Frist; ';
  END IF;

  -- (b) EXMA und ENDUSER sind freigeschaltet.
  IF (SELECT release_status FROM portal WHERE code = 'EXMA') <> 'ENABLED' THEN
    fehler := fehler || 'Portal EXMA ist nicht ENABLED; ';
  END IF;
  IF (SELECT release_status FROM portal WHERE code = 'ENDUSER') <> 'ENABLED' THEN
    fehler := fehler || 'Portal ENDUSER ist nicht ENABLED; ';
  END IF;

  -- (c) Der gemessene Bestand: EXMA und ENDUSER tragen je genau EINE
  --     Rolle. Bricht diese Annahme, sind alle Feldpruefungen der
  --     Faelle (role_id = "die eine Rolle") gegenstandslos.
  IF (SELECT count(*) FROM role WHERE portal_code = 'EXMA') <> 1 THEN
    fehler := fehler || 'Portal EXMA traegt nicht genau eine Rolle; ';
  END IF;
  IF (SELECT count(*) FROM role WHERE portal_code = 'ENDUSER') <> 1 THEN
    fehler := fehler || 'Portal ENDUSER traegt nicht genau eine Rolle; ';
  END IF;

  -- (d) Bootstrap-Admin steht.
  IF NOT EXISTS (SELECT 1 FROM pruef_mitgliedschaft_lage
                  WHERE email = 'bootstrapadmin@pruef.example'
                    AND status = 'AKTIV' AND mitgliedschaft_exma >= 1) THEN
    fehler := fehler || 'bootstrapadmin@ ist nicht AKTIV mit EXMA-Mitgliedschaft; ';
  END IF;

  -- (e) Die Sitzungsgrundlage: AKTIV, EXMA-Mitglied, genau ein offener
  --     Anmeldecode, keine Altsitzung.
  IF NOT EXISTS (SELECT 1 FROM pruef_mitgliedschaft_lage
                  WHERE email = 'einladend@pruef.example'
                    AND status = 'AKTIV' AND mitgliedschaft_exma >= 1 AND offene_codes = 1) THEN
    fehler := fehler || 'einladend@ traegt nicht Status/Mitgliedschaft/offenen Code wie erwartet; ';
  END IF;
  IF EXISTS (SELECT 1 FROM pruef_mitgliedschaft_lage
              WHERE email = 'einladend@pruef.example' AND offene_sitzungen > 0) THEN
    fehler := fehler || 'einladend@ traegt noch eine offene Sitzung aus einem frueheren Lauf; ';
  END IF;

  -- (f) MG-05: mg_wiederholt@ -- genau eine offene Einladung, attempt=1,
  --     Mitgliedschaft besteht bereits (Blatt 62: sie entsteht beim Versand).
  IF NOT EXISTS (SELECT 1 FROM pruef_mitgliedschaft_lage
                  WHERE email = 'mg_wiederholt@pruef.example'
                    AND status = 'WARTET_2FA'
                    AND einladungen_gesamt = 1 AND einladungen_offen = 1 AND attempt_max = 1
                    AND mitgliedschaft_exma = 1) THEN
    fehler := fehler || 'mg_wiederholt@ traegt nicht die Vorbedingung fuer den Erneuter-Versand-Fall; ';
  END IF;

  -- (g) MG-06: mg_aktiv@ -- laengst eingeloest, AKTIV, Mitgliedschaft besteht.
  IF NOT EXISTS (SELECT 1 FROM pruef_mitgliedschaft_lage
                  WHERE email = 'mg_aktiv@pruef.example'
                    AND status = 'AKTIV'
                    AND einladungen_gesamt = 1 AND einladungen_eingeloest = 1
                    AND mitgliedschaft_exma = 1) THEN
    fehler := fehler || 'mg_aktiv@ traegt nicht die Vorbedingung fuer den gefaehrlichsten Fall; ';
  END IF;

  -- (h) MG-07: mg_bereitsmitglied@ -- offen, unverbraucht, Mitgliedschaft
  --     besteht schon VOR der Einloesung.
  IF NOT EXISTS (SELECT 1 FROM pruef_mitgliedschaft_lage
                  WHERE email = 'mg_bereitsmitglied@pruef.example'
                    AND status = 'WARTET_2FA'
                    AND einladungen_gesamt = 1 AND einladungen_offen = 1
                    AND mitgliedschaft_exma = 1) THEN
    fehler := fehler || 'mg_bereitsmitglied@ traegt nicht die Vorbedingung fuer MG-07; ';
  END IF;

  -- (i) MG-08: mg_abgelaufen@ -- offen im Datensatz (Status noch
  --     VERSANDT), aber die Frist ist bereits um; Mitgliedschaft besteht.
  IF NOT EXISTS (SELECT 1 FROM pruef_mitgliedschaft_lage l
                  JOIN invitation i ON i.actor_id = l.actor_id
                  WHERE l.email = 'mg_abgelaufen@pruef.example'
                    AND l.status = 'WARTET_2FA' AND i.status = 'VERSANDT'
                    AND i.expires_at <= now() AND l.mitgliedschaft_exma = 1) THEN
    fehler := fehler || 'mg_abgelaufen@ traegt nicht die Vorbedingung fuer MG-08 (abgelaufen, aber noch VERSANDT im Datensatz); ';
  END IF;

  -- (j) MG-04: mg_zweitportal@ -- AKTIV, ZWEI freigeschaltete
  --     Mitgliedschaften (EXMA und ENDUSER), genau ein offener Code.
  IF NOT EXISTS (SELECT 1 FROM pruef_mitgliedschaft_lage
                  WHERE email = 'mg_zweitportal@pruef.example'
                    AND status = 'AKTIV'
                    AND mitgliedschaft_exma = 1 AND mitgliedschaft_enduser = 1
                    AND mitgliedschaften_gesamt = 2 AND offene_codes = 1) THEN
    fehler := fehler || 'mg_zweitportal@ traegt nicht die Vorbedingung fuer MG-04 (K03-M11); ';
  END IF;

  -- (k) Die drei dynamischen Fallziele existieren NOCH NICHT -- sonst
  --     misst der zugehoerige Fall nicht die Neuanlage, sondern einen
  --     Rest aus einem frueheren Teil desselben Laufs.
  IF EXISTS (SELECT 1 FROM actor
              WHERE email IN ('mg_neu@pruef.example','mg_geplant@pruef.example','mg_faden@pruef.example')) THEN
    fehler := fehler || 'ein dynamisches Fallziel existiert bereits vor dem ersten HTTP-Fall; ';
  END IF;

  -- (l) Keine Altversuche, die eine Drosselung vortaeuschen koennten.
  IF EXISTS (SELECT 1 FROM login_attempt WHERE email LIKE '%@pruef.example') THEN
    fehler := fehler || 'es stehen noch Anmeldeversuche aus einem frueheren Lauf; ';
  END IF;

  IF fehler <> '' THEN
    RAISE EXCEPTION 'AUFBAU UNBRAUCHBAR (F07): %', fehler;
  END IF;
END $$;

-- ---------------------------------------------------------------------
-- 14 · Was jetzt steht
-- ---------------------------------------------------------------------
SELECT email, status, mitgliedschaften_gesamt AS mitglied, mitgliedschaft_exma AS exma,
       mitgliedschaft_enduser AS enduser, einladungen_gesamt AS einladungen,
       einladungen_offen AS offen, einladungen_eingeloest AS eingeloest,
       attempt_max, offene_codes
  FROM pruef_mitgliedschaft_lage
 ORDER BY email;

\echo 'Pruefdaten stehen. Aufbaupruefung (F07) bestanden.'
