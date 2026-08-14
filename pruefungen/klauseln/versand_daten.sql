-- =====================================================================
-- FREIRAUM · Scheibe · Einladung senden
-- Pruefdaten fuer die Klauselpruefung  (versand_lauf.sh)
--
-- Geschrieben gegen K20 v1.3 (Zugaenge und Nutzer, EXMA), K03 v1.3 (fuer
-- die Anmeldung, die die Sitzung herstellt), freiraum_datamodel.sql und
-- M30__pilot_sammelmigration.sql -- NICHT gegen den Umsetzungscode.
--
-- Eigene Datenlage: diese Datei greift NICHT auf anmeldung_daten.sql
-- zu und setzt sie nicht voraus. Sie baut ihre eigene Sitzungsgrundlage
-- (Konto AKTIV, Mitgliedschaft EXMA/Plattform-Admin, Anmeldecode mit
-- gepfeffertem Streuwert) und ihre eigene ID-Reihe, damit sie unabhaengig
-- lauffaehig bleibt.
--
-- Aufruf:
--   FREIRAUM_CODE_PFEFFER=... \
--   psql -h localhost -p 55433 -U postgres -d <wegwerfdatenbank> \
--        -v ON_ERROR_STOP=1 -f versand_daten.sql
--
-- Die Datenbank wird zuvor aus schema/freiraum_datamodel.sql und
-- migrations/M30__pilot_sammelmigration.sql angelegt. Die Datei ist
-- WIEDERHOLBAR: sie setzt ihre eigenen Konten und die globale
-- Portal-Freischaltung zurueck, statt Zeilen anzuhaeufen oder eine
-- fruehere Ausfuehrung liegen zu lassen. `event` bleibt unangetastet
-- (append-only, K23-D-Grundsatz) -- jeder Lauf erzeugt frische
-- Einladungs-UUIDs, alte Nachweiszeilen stoeren daher nicht.
--
-- MASSSTAB F07: Jedes Konto/jeder Fall verletzt genau EINE Bedingung.
-- Alle uebrigen Vorbedingungen sind erfuellt. Der Aufbau wird am Ende
-- dieser Datei selbst geprueft; stimmt er nicht, bricht der Lauf mit
-- RAISE EXCEPTION ab, statt Faelle zu melden, die an der falschen
-- Bedingung scheitern.
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

SELECT set_config('freiraum.pruef_pfeffer', :'pfeffer', false);
DO $$
BEGIN
  IF length(current_setting('freiraum.pruef_pfeffer')) = 0 THEN
    RAISE EXCEPTION 'ABBRUCH: FREIRAUM_CODE_PFEFFER ist leer (wie BEF-L2-1 bei der Anmeldung)';
  END IF;
END $$;

-- ---------------------------------------------------------------------
-- 1 · Der Streuwert -- EINE Formel fuer zwei Zwecke
--
--     K03-M15 ("Gespeichert wird nur sein kryptografischer Pruefwert")
--     und die Streuwertregel aus dem Vertrag dieser Scheibe
--     ("sha256(FREIRAUM_CODE_PFEFFER + token), Hex, Kleinbuchstaben")
--     sind wortgleich dieselbe Formel. Sie steht deshalb an GENAU EINER
--     Stelle: hier -- fuer den Anmeldecode UND fuer invitation.token_hash.
--     Bildet der Serverpfad sie anders, ist allein diese Funktion
--     anzupassen; alle codeabhaengigen Faelle haengen an ihr.
-- ---------------------------------------------------------------------
CREATE OR REPLACE FUNCTION pruef_codewert(klartext text, pfeffer text)
RETURNS text LANGUAGE sql IMMUTABLE AS
$$ SELECT encode(sha256(convert_to(pfeffer || klartext, 'utf8')), 'hex') $$;

-- ---------------------------------------------------------------------
-- 2 · Mandant. EIN Betreiber-Mandant traegt die Domaenenschranke und die
--     Frist (K02, hier nur als Vorbedingung gesetzt -- Eigentuemer bleibt
--     K02). invite_domain OHNE Klammeraffen, wie das Feld es verlangt.
-- ---------------------------------------------------------------------
INSERT INTO tenant (id, kind, name, customer_code, legal_space, invite_domain, invite_ttl_hours)
VALUES ('00000000-0000-4000-9000-0000000000f1', 'OPERATOR', 'Pruefbetreiber Einladung', NULL, 'DE',
        'pruef.example', 24)
ON CONFLICT (id) DO UPDATE SET
  invite_domain    = EXCLUDED.invite_domain,
  invite_ttl_hours = EXCLUDED.invite_ttl_hours;

-- ---------------------------------------------------------------------
-- 3 · Globale Portalfreischaltung zuruecksetzen, BEVOR irgendetwas
--     anderes laeuft.
--
--     K20-D02 wird in versand_lauf.sh geprueft, indem EXMA kurzzeitig auf
--     PLANNED gesetzt und danach sofort zurueckgesetzt wird. Bricht ein
--     frueherer Lauf mitten in diesem Fall ab, bliebe EXMA sonst PLANNED
--     stehen und jeder folgende Lauf schiene grundlos GESPERRT. Diese
--     Zeile heilt das, unabhaengig vom Grund des Abbruchs.
-- ---------------------------------------------------------------------
UPDATE portal SET release_status = 'ENABLED' WHERE code IN ('EXMA','ENDUSER');

-- ---------------------------------------------------------------------
-- 4 · Der Plattform-Admin ZUERST, unangetastet ueber den ganzen Lauf.
--
--     Wie bei der Anmeldung: platform_admin_guard (AFTER UPDATE OR DELETE
--     ON actor/membership, FOR EACH STATEMENT) verlangt jederzeit
--     mindestens einen aktiven EXMA-Admin. Dieses Konto ist reiner
--     Aufbau -- kein Prueffall greift es an. Die Sitzung fuer die
--     Faelle selbst haelt ein ZWEITES Konto (Abschnitt 6), damit ein
--     Fehler in einem Fall nie den Bootstrap-Admin gefaehrdet.
-- ---------------------------------------------------------------------
INSERT INTO actor (id, tenant_id, email, display_name, mfa_method, status, created_on)
VALUES ('00000000-0000-4000-9000-000000000001',
        '00000000-0000-4000-9000-0000000000f1',
        'bootstrapadmin@pruef.example', 'Pruef Bootstrap-Admin', 'EMAIL_CODE', 'AKTIV', current_date)
ON CONFLICT (id) DO NOTHING;

INSERT INTO membership (actor_id, portal_code, role_id, tenant_scope)
SELECT '00000000-0000-4000-9000-000000000001', 'EXMA', r.id, '00000000-0000-4000-9000-0000000000f1'
  FROM role r WHERE r.portal_code = 'EXMA' AND r.name = 'Plattform-Admin'
ON CONFLICT DO NOTHING;

UPDATE actor SET status = 'AKTIV'
 WHERE id = '00000000-0000-4000-9000-000000000001' AND status <> 'AKTIV';

-- ---------------------------------------------------------------------
-- 5 · Alten Lauf zuruecksetzen. Der Bootstrap-Admin bleibt aussen vor,
--     sonst faellt der Guard aus Abschnitt 4 in sich zusammen. Das
--     ausserhalb der Domaene liegende Testkonto traegt nicht die
--     Endung @pruef.example und braucht eine eigene Zeile.
--
--     invitation faellt mit actor per ON DELETE CASCADE -- keine eigene
--     DELETE-Zeile noetig. event bleibt unberuehrt (append-only).
-- ---------------------------------------------------------------------
DELETE FROM actor WHERE email = 'niemand@fremde-domaene.example';
DELETE FROM actor
 WHERE email LIKE '%@pruef.example'
   AND email NOT IN ('bootstrapadmin@pruef.example', 'einladend@pruef.example');

DELETE FROM login_code
 WHERE actor_id IN (SELECT id FROM actor WHERE email IN ('bootstrapadmin@pruef.example','einladend@pruef.example'));
DELETE FROM auth_session
 WHERE actor_id IN (SELECT id FROM actor WHERE email IN ('bootstrapadmin@pruef.example','einladend@pruef.example'));
DELETE FROM login_attempt
 WHERE email LIKE '%@pruef.example' OR email = 'niemand@fremde-domaene.example';

-- ---------------------------------------------------------------------
-- 6 · Das einladende Konto -- die Sitzung, mit der versand_lauf.sh
--     GET/POST /einladung/senden aufruft. AKTIV, Mitgliedschaft EXMA/
--     Plattform-Admin, Reichweite Betreiber-Mandant (K20-G11).
-- ---------------------------------------------------------------------
INSERT INTO actor (id, tenant_id, email, display_name, mfa_method, status, created_on)
VALUES ('00000000-0000-4000-9000-000000000002',
        '00000000-0000-4000-9000-0000000000f1',
        'einladend@pruef.example', 'Pruef Einladend', 'EMAIL_CODE', 'AKTIV', current_date)
ON CONFLICT (id) DO UPDATE SET
  tenant_id    = EXCLUDED.tenant_id,
  display_name = EXCLUDED.display_name,
  mfa_method   = EXCLUDED.mfa_method,
  status       = 'AKTIV';

INSERT INTO membership (actor_id, portal_code, role_id, tenant_scope)
SELECT '00000000-0000-4000-9000-000000000002', 'EXMA', r.id, '00000000-0000-4000-9000-0000000000f1'
  FROM role r WHERE r.portal_code = 'EXMA' AND r.name = 'Plattform-Admin'
ON CONFLICT DO NOTHING;

-- Frischer, gueltiger Anmeldecode (K03-M15: sechsstellig, zehn Minuten).
-- versand_lauf.sh meldet sich damit einmal an und haelt das Sitzungs-Cookie
-- fuer alle Faelle.
INSERT INTO login_code (actor_id, code_hash, issued_at, expires_at)
SELECT id, pruef_codewert('300001', :'pfeffer'), now(), now() + interval '10 minutes'
  FROM actor WHERE email = 'einladend@pruef.example';

-- ---------------------------------------------------------------------
-- 7 · Das Konto mit bereits offener Einladung -- Grundlage fuer den
--     Erneuter-Versand-Fall (K20-M12 + K20-M13 + K20-D05). WARTET_2FA,
--     weil es noch keine zweite Stufe bestaetigt hat. Die Einladung ist
--     VERSANDT, attempt=1, innerhalb Domaene und Frist -- die einzige
--     Abweichung, die der Fall braucht, ist "es gibt bereits eine
--     offene Einladung fuer dieses Konto".
-- ---------------------------------------------------------------------
INSERT INTO actor (id, tenant_id, email, display_name, mfa_method, status, created_on)
VALUES ('00000000-0000-4000-9000-000000000003',
        '00000000-0000-4000-9000-0000000000f1',
        'wiederholt@pruef.example', 'Pruef Wiederholt', 'EMAIL_CODE', 'WARTET_2FA', current_date)
ON CONFLICT (id) DO UPDATE SET
  tenant_id    = EXCLUDED.tenant_id,
  display_name = EXCLUDED.display_name,
  mfa_method   = EXCLUDED.mfa_method,
  status       = 'WARTET_2FA';

INSERT INTO invitation (actor_id, portal_code, mail, token_hash, sent_at, expires_at, status, attempt)
SELECT '00000000-0000-4000-9000-000000000003', 'EXMA', 'wiederholt@pruef.example',
       pruef_codewert('SEED-ALTER-TOKEN', :'pfeffer'),
       now() - interval '2 hours', now() + interval '18 hours', 'VERSANDT', 1;

-- ---------------------------------------------------------------------
-- 7b · ZWEITER Mandant mit einem Konto -- Grundlage fuer den
--      mandantenuebergreifenden Auskunftsfall (K01-M15 + K03-M25,
--      14.08.2026, F1 aus der Fremdpruefung). Das Konto liegt INNERHALB
--      der Domaenenschranke des Betreiber-Mandanten (sonst wuerde die
--      Domaenenschranke K20-M10/K20-D04 den Fall verdecken, nicht die
--      Mandantengrenze) -- gehoert aber einem ZWEITEN, synthetischen
--      Mandanten (K23-M12: rein erfundene Daten, keine echte Firma).
--      K01-M15: ein Objekt eines fremden Mandanten gilt als nicht
--      vorhanden -- versand_lauf.sh prueft daher NICHT gegen eine feste
--      Erwartung, sondern vergleicht die Antwort auf diese Adresse
--      GEGEN die Antwort auf eine echte Unbekannte.
-- ---------------------------------------------------------------------
INSERT INTO tenant (id, kind, name, customer_code, legal_space, invite_domain, invite_ttl_hours)
VALUES ('00000000-0000-4000-9000-0000000000c1', 'CUSTOMER', 'Pruef Fremdmandant GmbH', 'DE-PRF', 'DE',
        NULL, 24)
ON CONFLICT (id) DO UPDATE SET
  name           = EXCLUDED.name,
  customer_code  = EXCLUDED.customer_code,
  legal_space    = EXCLUDED.legal_space;

INSERT INTO actor (id, tenant_id, email, display_name, mfa_method, status, created_on)
VALUES ('00000000-0000-4000-9000-000000000004',
        '00000000-0000-4000-9000-0000000000c1',
        'fremdmandant@pruef.example', 'Pruef Fremdmandant', 'EMAIL_CODE', 'AKTIV', current_date)
ON CONFLICT (id) DO UPDATE SET
  tenant_id    = EXCLUDED.tenant_id,
  display_name = EXCLUDED.display_name,
  mfa_method   = EXCLUDED.mfa_method,
  status       = 'AKTIV';

INSERT INTO membership (actor_id, portal_code, role_id, tenant_scope)
SELECT '00000000-0000-4000-9000-000000000004', 'ENDUSER', r.id, '00000000-0000-4000-9000-0000000000c1'
  FROM role r WHERE r.portal_code = 'ENDUSER' AND r.name = 'Endnutzer'
ON CONFLICT DO NOTHING;

-- ---------------------------------------------------------------------
-- 8 · Sicht auf die Lage -- versand_lauf.sh prueft damit den AUFBAU
--     unmittelbar vor dem ersten Fall erneut (die Daten koennten
--     zwischenzeitlich durch einen fruehen Teil desselben Laufs
--     veraendert worden sein).
-- ---------------------------------------------------------------------
CREATE OR REPLACE VIEW pruef_versand_lage AS
SELECT a.email,
       a.id                                          AS actor_id,
       a.status::text                                AS status,
       a.tenant_id,
       (SELECT count(*) FROM membership m
         WHERE m.actor_id = a.id AND m.portal_code = 'EXMA')  AS exma_mitglied,
       (SELECT count(*) FROM invitation i
         WHERE i.actor_id = a.id)                    AS einladungen_gesamt,
       (SELECT count(*) FROM invitation i
         WHERE i.actor_id = a.id AND i.status = 'VERSANDT') AS einladungen_offen,
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
-- 9 · AUFBAUPRUEFUNG (F07)
-- ---------------------------------------------------------------------
DO $$
DECLARE r record; fehler text := '';
BEGIN
  -- (a) Mandant traegt die richtige Domaenenschranke und Frist.
  IF NOT EXISTS (SELECT 1 FROM tenant
                  WHERE id = '00000000-0000-4000-9000-0000000000f1'
                    AND invite_domain = 'pruef.example'
                    AND invite_ttl_hours = 24) THEN
    fehler := fehler || 'Betreiber-Mandant traegt nicht die erwartete Domaenenschranke/Frist; ';
  END IF;

  -- (b) EXMA ist freigeschaltet -- sonst kommt keiner der Faelle je bis
  --     zur Einladungsmaske.
  IF (SELECT release_status FROM portal WHERE code = 'EXMA') <> 'ENABLED' THEN
    fehler := fehler || 'Portal EXMA ist nicht ENABLED; ';
  END IF;

  -- (c) Bootstrap-Admin steht, unabhaengig von der Sitzung, die die
  --     Faelle benutzen.
  IF NOT EXISTS (SELECT 1 FROM pruef_versand_lage
                  WHERE email = 'bootstrapadmin@pruef.example'
                    AND status = 'AKTIV' AND exma_mitglied >= 1) THEN
    fehler := fehler || 'bootstrapadmin@ ist nicht AKTIV mit EXMA-Mitgliedschaft; ';
  END IF;

  -- (d) Die Sitzungsgrundlage: AKTIV, EXMA-Mitglied, genau ein offener
  --     Anmeldecode.
  IF NOT EXISTS (SELECT 1 FROM pruef_versand_lage
                  WHERE email = 'einladend@pruef.example'
                    AND status = 'AKTIV' AND exma_mitglied >= 1 AND offene_codes = 1) THEN
    fehler := fehler || 'einladend@ traegt nicht Status/Mitgliedschaft/offenen Code wie erwartet; ';
  END IF;
  IF EXISTS (SELECT 1 FROM pruef_versand_lage
              WHERE email = 'einladend@pruef.example' AND offene_sitzungen > 0) THEN
    fehler := fehler || 'einladend@ traegt noch eine offene Sitzung aus einem frueheren Lauf; ';
  END IF;

  -- (e) Der Erneuter-Versand-Fall: genau eine offene Einladung, attempt=1.
  IF NOT EXISTS (SELECT 1 FROM pruef_versand_lage
                  WHERE email = 'wiederholt@pruef.example'
                    AND status = 'WARTET_2FA'
                    AND einladungen_gesamt = 1 AND einladungen_offen = 1 AND attempt_max = 1) THEN
    fehler := fehler || 'wiederholt@ traegt nicht genau eine offene Einladung mit attempt=1; ';
  END IF;

  -- (e2) F1 (14.08.2026, K01-M15 + K03-M25): der zweite, synthetische
  --      Mandant steht, und fremdmandant@ gehoert IHM -- nicht dem
  --      Betreiber-Mandanten aus (a). Ohne diese Trennung wuerde VE-09
  --      keinen mandantenuebergreifenden Fall pruefen, sondern einen
  --      gewoehnlichen Treffer im eigenen Mandanten.
  IF NOT EXISTS (SELECT 1 FROM tenant
                  WHERE id = '00000000-0000-4000-9000-0000000000c1'
                    AND kind = 'CUSTOMER') THEN
    fehler := fehler || 'der zweite (synthetische) Mandant fuer den F1-Fall fehlt; ';
  END IF;
  IF NOT EXISTS (SELECT 1 FROM actor
                  WHERE email = 'fremdmandant@pruef.example'
                    AND status = 'AKTIV'
                    AND tenant_id = '00000000-0000-4000-9000-0000000000c1') THEN
    fehler := fehler || 'fremdmandant@ ist nicht AKTIV oder haengt nicht am zweiten Mandanten; ';
  END IF;

  -- (f) Die dynamischen Fallziele existieren NOCH NICHT -- sonst misst
  --     der zugehoerige Fall nicht die Neuanlage, sondern einen Rest aus
  --     einem fruehen Teil desselben Laufs. niemals-existent@ ist die
  --     echte Unbekannte, gegen die VE-09 fremdmandant@ misst (F1,
  --     14.08.2026).
  IF EXISTS (SELECT 1 FROM actor
              WHERE email IN ('neu@pruef.example','geplant@pruef.example','niemand@fremde-domaene.example',
                               'niemals-existent@pruef.example')) THEN
    fehler := fehler || 'ein dynamisches Fallziel existiert bereits vor dem ersten HTTP-Fall; ';
  END IF;

  -- (g) Keine Altversuche, die eine Drosselung vortaeuschen koennten.
  IF EXISTS (SELECT 1 FROM login_attempt
              WHERE email LIKE '%@pruef.example' OR email = 'niemand@fremde-domaene.example') THEN
    fehler := fehler || 'es stehen noch Anmeldeversuche aus einem frueheren Lauf; ';
  END IF;

  IF fehler <> '' THEN
    RAISE EXCEPTION 'AUFBAU UNBRAUCHBAR (F07): %', fehler;
  END IF;
END $$;

-- ---------------------------------------------------------------------
-- 10 · Was jetzt steht
-- ---------------------------------------------------------------------
SELECT email, status, exma_mitglied, einladungen_gesamt AS einladungen,
       einladungen_offen AS offen, attempt_max, offene_codes
  FROM pruef_versand_lage
 ORDER BY email;

\echo 'Pruefdaten stehen. Aufbaupruefung (F07) bestanden.'
