-- =====================================================================
-- FREIRAUM · K19-M01 · "Folgt die ausgelieferte Seite ihrem Kasten?"
-- Pruefdaten fuer die Klauselpruefung  (k19_kasten_lauf.sh)
--
-- Geschrieben gegen schema/K19_build_referenz.md (Abschn. 5 und 6),
-- schema/K19_screens.yaml, schema/freiraum_datamodel.sql und
-- migrations/M30__pilot_sammelmigration.sql -- NICHT gegen den
-- Umsetzungscode und NICHT gegen die Vorlagen.
--
-- Aufruf:
--   FREIRAUM_CODE_PFEFFER=... \
--   psql -h localhost -p 55433 -U postgres -d <db> \
--        -v ON_ERROR_STOP=1 -f pruefungen/klauseln/k19_kasten_daten.sql
--
-- pruefungen/lauf.sh ruft sie selbst auf: zu jeder <name>_lauf.sh
-- erwartet er eine <name>_daten.sql daneben und sperrt sonst, ohne den
-- Fall auch nur zu starten. Bis zum 19.08.2026 fehlte diese Datei --
-- der Fall galt als tauglich, hat im Gesamtlauf aber nichts gemessen.
--
-- Die Datei ist WIEDERHOLBAR.
--
-- ---------------------------------------------------------------------
-- WAS DIESE DATEI ANLEGT -- UND WARUM GENAU DAS
-- ---------------------------------------------------------------------
-- EIN Konto, mit dem der Lauf durch EN-01 hindurchkommt.
--
-- EN-01 selbst traegt die Zugangsmarke "offen" (K19 Abschn. 6) und ist
-- ohne Sitzung erreichbar; fuer den Kasten von EN-01 braucht es also
-- kein Konto. Gebraucht wird es fuer den zweiten Bildschirm, den der
-- Lauf misst: EN-03 traegt "nach Anmeldung". Ohne Konto bliebe er
-- GESPERRT, und der Lauf haette genau einen Bildschirm.
--
-- Mehr als ein Konto legt diese Datei NICHT an. Der Lauf misst
-- Oberflaechen gegen ihre Kaesten, keine Rechte und keine Zustaende --
-- jedes weitere Konto waere Aufbau, den kein Fall benutzt.
--
-- ---------------------------------------------------------------------
-- MASSSTAB F07
-- ---------------------------------------------------------------------
-- Das Konto ist AKTIV und Mitglied im freigeschalteten Portal ENDUSER.
-- Beides ist Vorbedingung, nicht Pruefgegenstand: scheiterte die
-- Anmeldung an einem gesperrten Konto oder an einer fehlenden
-- Mitgliedschaft, maesse der Lauf eine FREMDE Bedingung statt des
-- Kastens. Der Aufbau wird am Ende dieser Datei selbst geprueft; stimmt
-- er nicht, bricht sie ab.
--
-- Alle Adressen enden auf @k19pruef.example. Damit stoert diese Datei
-- die Daten der Scheibe 1 (@pruef.example) und der Scheibe 2
-- (@vpruef.example, @zbpruef.example) nicht und wird von ihnen nicht
-- gestoert.
--
-- WAS SIE AUSDRUECKLICH NICHT ANFASST: den Startbestand der
-- Oberflaeche. Kaesten, Bildschirmkennungen und Beschriftungen sind
-- Pruefgegenstand. Eine Pruefdatei, die sie herstellte, bestaetigte
-- ihre eigene Hand.
-- =====================================================================

\set ON_ERROR_STOP on

-- ---------------------------------------------------------------------
-- 0 · Der Pfeffer
--
--     Der LAUF stellt sich seine Anmeldecodes selbst aus (K03-M15,
--     dieselbe Bauart wie vorpruefung_daten.sql) -- gebraucht wird hier
--     nur die Ableitung, damit beide Seiten denselben Pruefwert bilden.
--     Fehlt der Pfeffer, ist das KEIN Grund abzubrechen: EN-01 ist ohne
--     Sitzung messbar. Der Lauf sperrt dann den Teil, der eine Sitzung
--     braucht, und sagt warum.
-- ---------------------------------------------------------------------
CREATE OR REPLACE FUNCTION pruef_codewert(klartext text, pfeffer text)
RETURNS text LANGUAGE sql IMMUTABLE AS
$$ SELECT encode(sha256(convert_to(pfeffer || klartext, 'utf8')), 'hex') $$;

-- ---------------------------------------------------------------------
-- 1 · Mandanten
--
--     d901  OPERATOR -- traegt den Plattform-Admin
--     d902  CUSTOMER -- traegt das Konto, das die Bildschirme sieht
-- ---------------------------------------------------------------------
INSERT INTO tenant (id, kind, name, customer_code, legal_space) VALUES
  ('00000000-0000-4000-8000-00000000d901','OPERATOR','Pruefbetreiber K19', NULL,    'DE'),
  ('00000000-0000-4000-8000-00000000d902','CUSTOMER','Pruefkunde K19',     'DE-KNT','DE')
ON CONFLICT (id) DO NOTHING;

-- ---------------------------------------------------------------------
-- 2 · Der Plattform-Admin ZUERST
--
--     Der Waechter platform_admin_guard haengt an actor und membership
--     (AFTER DELETE OR UPDATE, FOR EACH STATEMENT): bleibt kein aktiver
--     EXMA-Admin uebrig, scheitert JEDE spaetere Aenderung an actor.
--     Er ist Aufbau, kein Prueffall -- und ein EIGENER, damit diese
--     Datei nicht davon abhaengt, ob die Daten anderer Scheiben in
--     derselben Datenbank stehen.
--
--     Reine INSERTs zuerst: ein ON CONFLICT DO UPDATE loeste den
--     Waechter schon aus, bevor die Mitgliedschaft steht.
-- ---------------------------------------------------------------------
INSERT INTO actor (id, tenant_id, email, display_name, mfa_method, status, created_on)
VALUES ('00000000-0000-4000-8000-00000000da01',
        '00000000-0000-4000-8000-00000000d901',
        'k19_admin@k19pruef.example', 'Pruef Plattform-Admin K19',
        'EMAIL_CODE', 'AKTIV', current_date)
ON CONFLICT (id) DO NOTHING;

INSERT INTO membership (actor_id, portal_code, role_id, tenant_scope)
SELECT '00000000-0000-4000-8000-00000000da01', 'EXMA', r.id,
       '00000000-0000-4000-8000-00000000d901'
  FROM role r WHERE r.portal_code = 'EXMA' AND r.name = 'Plattform-Admin'
ON CONFLICT DO NOTHING;

UPDATE actor SET status = 'AKTIV'
 WHERE id = '00000000-0000-4000-8000-00000000da01' AND status <> 'AKTIV';

-- ---------------------------------------------------------------------
-- 3 · Alten Lauf zuruecksetzen
--
--     Die Konten bleiben stehen, nur ihre fluechtigen Spuren gehen.
--     event wird NICHT geleert -- die Tabelle ist append-only (Regel
--     event_no_delete).
-- ---------------------------------------------------------------------
DELETE FROM login_code
 WHERE actor_id IN (SELECT id FROM actor WHERE email LIKE '%@k19pruef.example');
DELETE FROM auth_session
 WHERE actor_id IN (SELECT id FROM actor WHERE email LIKE '%@k19pruef.example');
DELETE FROM login_attempt
 WHERE email LIKE '%@k19pruef.example';

-- ---------------------------------------------------------------------
-- 4 · Das Konto, das die Bildschirme sieht
--
--     k19_seite  Mandant d902 · AKTIV · Portal ENDUSER
--
--     Es faehrt keinen Weg und beantwortet nichts. Es meldet sich an
--     und holt Bildschirme -- mehr verlangt K19-M01 nicht.
-- ---------------------------------------------------------------------
INSERT INTO actor (id, tenant_id, email, display_name, mfa_method, status, created_on)
VALUES ('00000000-0000-4000-8000-00000000da02',
        '00000000-0000-4000-8000-00000000d902',
        'k19_seite@k19pruef.example', 'Pruef Bildschirme K19',
        'EMAIL_CODE', 'AKTIV', current_date)
ON CONFLICT (id) DO UPDATE SET
  tenant_id    = EXCLUDED.tenant_id,
  display_name = EXCLUDED.display_name,
  mfa_method   = EXCLUDED.mfa_method,
  status       = EXCLUDED.status;

INSERT INTO membership (actor_id, portal_code, role_id, tenant_scope)
SELECT '00000000-0000-4000-8000-00000000da02', 'ENDUSER', r.id,
       '00000000-0000-4000-8000-00000000d902'
  FROM role r WHERE r.portal_code = 'ENDUSER' AND r.name = 'Endnutzer'
ON CONFLICT DO NOTHING;

-- ---------------------------------------------------------------------
-- 5 · Die Sicht auf die Lage
--
--     Der Lauf prueft damit den AUFBAU, bevor ein Bildschirm geholt
--     wird. Steht sie nicht, ist die Datendatei nicht eingespielt --
--     und ein Lauf gegen eine unbekannte Datenlage misst nichts.
-- ---------------------------------------------------------------------
CREATE OR REPLACE VIEW pruef_k19_kasten_lage AS
SELECT a.email,
       a.status::text                              AS status,
       (SELECT count(*) FROM membership m JOIN portal p ON p.code = m.portal_code
         WHERE m.actor_id = a.id AND p.release_status = 'ENABLED')
                                                   AS freigeschaltete_portale,
       (SELECT count(*) FROM auth_session s
         WHERE s.actor_id = a.id AND s.ended_at IS NULL)
                                                   AS offene_sitzungen
  FROM actor a
 WHERE a.email LIKE '%@k19pruef.example';

-- ---------------------------------------------------------------------
-- 6 · AUFBAUPRUEFUNG (F07)
--
--     Genau die Vorbedingungen, an denen der Lauf sonst scheiterte,
--     ohne einen Kasten gemessen zu haben.
-- ---------------------------------------------------------------------
DO $$
DECLARE fehler text := '';
BEGIN
  IF NOT EXISTS (SELECT 1 FROM pruef_k19_kasten_lage
                  WHERE email = 'k19_seite@k19pruef.example') THEN
    fehler := fehler || 'das Konto k19_seite@ besteht nicht; ';
  END IF;
  IF (SELECT status FROM pruef_k19_kasten_lage
       WHERE email = 'k19_seite@k19pruef.example') <> 'AKTIV' THEN
    fehler := fehler || 'k19_seite@ ist nicht AKTIV -- die Anmeldung scheiterte an einer fremden Bedingung; ';
  END IF;
  IF (SELECT freigeschaltete_portale FROM pruef_k19_kasten_lage
       WHERE email = 'k19_seite@k19pruef.example') < 1 THEN
    fehler := fehler || 'k19_seite@ gehoert keinem freigeschalteten Portal an; ';
  END IF;
  IF EXISTS (SELECT 1 FROM pruef_k19_kasten_lage WHERE offene_sitzungen > 0) THEN
    fehler := fehler || 'es stehen noch Sitzungen aus einem frueheren Lauf; ';
  END IF;
  -- Der Startbestand der Oberflaeche ist Pruefgegenstand und wird hier
  -- NICHT hergestellt -- aber das freigeschaltete Portal ENDUSER ist
  -- Vorbedingung. Fehlt es, misst kein Bildschirm etwas.
  IF NOT EXISTS (SELECT 1 FROM portal
                  WHERE code = 'ENDUSER' AND release_status = 'ENABLED') THEN
    fehler := fehler || 'das Portal ENDUSER ist nicht ENABLED; ';
  END IF;

  IF fehler <> '' THEN
    RAISE EXCEPTION 'ABBRUCH -- AUFBAU UNBRAUCHBAR (F07): %', fehler;
  END IF;
END $$;

-- ---------------------------------------------------------------------
-- 7 · Was jetzt steht
-- ---------------------------------------------------------------------
SELECT email, status, freigeschaltete_portale AS portale, offene_sitzungen AS sitzungen
  FROM pruef_k19_kasten_lage
 ORDER BY email;

\echo 'Pruefdaten stehen. Aufbaupruefung (F07) bestanden.'
\echo 'Die Kaesten selbst sind Pruefgegenstand -- diese Datei legt keinen an.'
