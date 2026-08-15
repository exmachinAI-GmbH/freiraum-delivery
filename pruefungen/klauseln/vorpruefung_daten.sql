-- =====================================================================
-- FREIRAUM · Scheibe 2, erster Teil · M3 "Die Vorpruefung haelt an"
-- Pruefdaten fuer die Klauselpruefung  (vorpruefung_lauf.sh)
--
-- Geschrieben gegen K04 (49 Regeln, Klauselregister), K19 EN-02/EN-03/
-- EN-04, schema/freiraum_datamodel.sql und
-- migrations/M30__pilot_sammelmigration.sql sowie gegen die Wegetabelle
-- in arbeit/Plaene/scheibe2_m3_plan.md Abschnitt 2 --
-- NICHT gegen den Umsetzungscode. Der Prueffall kennt den Server nur
-- durch seine Tueren.
--
-- Aufruf (NACH dem Startbestand/Seed des Baus):
--   psql -h localhost -p 55433 -U postgres -d freiraum_pruef \
--        -v ON_ERROR_STOP=1 -f pruefungen/klauseln/vorpruefung_daten.sql
--
-- Die Datenbank wird zuvor aus
--   schema/freiraum_datamodel.sql
--   migrations/M30__pilot_sammelmigration.sql
-- angelegt. Diese Datei ist WIEDERHOLBAR.
--
-- ---------------------------------------------------------------------
-- MASSSTAB F07 -- und die eine Stelle, an der er hier besonders wehtut
-- ---------------------------------------------------------------------
-- Ein Prueffall, der an einer FREMDEN Bedingung scheitert, misst nichts.
-- Deshalb gilt hier eine strenge Arbeitsteilung:
--
--   * Was diese Datei zu verantworten hat -- Mandanten, Konten,
--     Mitgliedschaften, die vorbereiteten Faelle -- wird am Ende geprueft.
--     Stimmt es nicht, BRICHT diese Datei ab.
--
--   * Der Katalog der drei Eignungsfragen (fit_question/fit_option) ist
--     der STARTBESTAND DES BAUS und damit selbst Pruefgegenstand
--     (K04-M04, M05, M06, M07, D02). Diese Datei legt ihn deshalb NICHT
--     an, solange auch nur eine Frage besteht -- und sie bricht auch
--     nicht ab, wenn er falsch ist. Sie schreibt den Zustand in die
--     Sicht pruef_vorpruefung_lage; der Lauf entscheidet dort zwischen
--     GESCHEITERT (der Bestand ist falsch) und GESPERRT (er ist gar
--     nicht messbar).
--
--   * Ist fit_question LEER, legt diese Datei einen ERSATZBESTAND an --
--     sonst liesse sich kein einziger Weg fahren. Er ist in jedem
--     label_de sichtbar als "[Ersatzbestand ...]" gekennzeichnet, und
--     die Sicht meldet katalog_herkunft = 'ERSATZ'. Der Lauf SPERRT
--     dann alle Faelle, die den Bestand messen -- ein Prueffall, der
--     meine eigenen Daten bestaetigt, ist kein Prueffall.
--
-- Alle Adressen dieser Datei enden auf @vpruef.example. Damit stoert
-- sie die Daten der Scheibe 1 (@pruef.example) nicht und wird von ihnen
-- nicht gestoert; beide duerfen in derselben Datenbank stehen.
-- =====================================================================

\set ON_ERROR_STOP on

-- ---------------------------------------------------------------------
-- 1 · Der Pruefwert des Anmeldecodes
--
--     K03-M15: "Gespeichert wird nur sein kryptografischer Pruefwert."
--     Dieselbe Ableitung wie in anmeldung_daten.sql -- der Lauf stellt
--     sich seine Codes damit selbst aus, damit er wiederholbar ist.
--     Der Pfeffer wird NICHT hier gebraucht, sondern erst im Lauf.
-- ---------------------------------------------------------------------
CREATE OR REPLACE FUNCTION pruef_codewert(klartext text, pfeffer text)
RETURNS text LANGUAGE sql IMMUTABLE AS
$$ SELECT encode(sha256(convert_to(pfeffer || klartext, 'utf8')), 'hex') $$;

-- ---------------------------------------------------------------------
-- 2 · Mandanten
--
--     ef02  Mandant A -- der Mandant der Sitzung, in dem gemessen wird
--     ef03  Mandant B -- der FREMDE Mandant (K04-D08)
--     ef04  Mandant der Loeschsperre -- an ihm haengt AUSSCHLIESSLICH
--           ein Eignungs-Check. Nur so scheitert sein Loeschversuch an
--           der Loeschsperre von fit_check (K04-M10) und nicht an
--           irgendeinem anderen Verweis (F07).
-- ---------------------------------------------------------------------
INSERT INTO tenant (id, kind, name, customer_code, legal_space) VALUES
  ('00000000-0000-4000-8000-00000000ef01','OPERATOR','Pruefbetreiber Vorpruefung', NULL,    'DE'),
  ('00000000-0000-4000-8000-00000000ef02','CUSTOMER','Pruefkunde Vorpruefung A',   'DE-VPA','DE'),
  ('00000000-0000-4000-8000-00000000ef03','CUSTOMER','Pruefkunde Vorpruefung B',   'DE-VPB','DE'),
  ('00000000-0000-4000-8000-00000000ef04','CUSTOMER','Pruefkunde Loeschsperre',    'DE-VPL','DE')
ON CONFLICT (id) DO NOTHING;

-- ---------------------------------------------------------------------
-- 3 · Der Plattform-Admin ZUERST
--
--     Der Waechter platform_admin_guard haengt an actor und membership:
--     bleibt kein aktiver EXMA-Admin uebrig, scheitert JEDE spaetere
--     Aenderung an actor. Er ist Aufbau, kein Prueffall. Ein eigener
--     Admin, damit diese Datei nicht davon abhaengt, ob die Daten der
--     Scheibe 1 in derselben Datenbank stehen.
-- ---------------------------------------------------------------------
INSERT INTO actor (id, tenant_id, email, display_name, mfa_method, status, created_on)
VALUES ('00000000-0000-4000-8000-00000000ea01',
        '00000000-0000-4000-8000-00000000ef01',
        'vp_admin@vpruef.example', 'Pruef Plattform-Admin Vorpruefung',
        'EMAIL_CODE', 'AKTIV', current_date)
ON CONFLICT (id) DO NOTHING;

INSERT INTO membership (actor_id, portal_code, role_id, tenant_scope)
SELECT '00000000-0000-4000-8000-00000000ea01', 'EXMA', r.id,
       '00000000-0000-4000-8000-00000000ef01'
  FROM role r WHERE r.portal_code = 'EXMA' AND r.name = 'Plattform-Admin'
ON CONFLICT DO NOTHING;

UPDATE actor SET status = 'AKTIV'
 WHERE id = '00000000-0000-4000-8000-00000000ea01' AND status <> 'AKTIV';

-- ---------------------------------------------------------------------
-- 4 · Alten Lauf zuruecksetzen
--
--     Die Konten bleiben stehen, nur ihre fluechtigen Spuren und die
--     Vorgaenge des letzten Laufs gehen. Reihenfolge: erst app (sie
--     verweist auf fit_check), dann fit_check (fit_answer haengt mit
--     ON DELETE CASCADE daran).
--
--     event wird NICHT geleert: die Tabelle ist append-only (Regel
--     event_no_delete). Der Lauf misst deshalb bei Ausweg 2 die
--     ZUNAHME der Ereignisse, nie ihren Gesamtstand.
-- ---------------------------------------------------------------------
DELETE FROM app
 WHERE tenant_id IN ('00000000-0000-4000-8000-00000000ef02',
                     '00000000-0000-4000-8000-00000000ef03',
                     '00000000-0000-4000-8000-00000000ef04');

DELETE FROM fit_check
 WHERE tenant_id IN ('00000000-0000-4000-8000-00000000ef02',
                     '00000000-0000-4000-8000-00000000ef03',
                     '00000000-0000-4000-8000-00000000ef04');

DELETE FROM login_code
 WHERE actor_id IN (SELECT id FROM actor WHERE email LIKE '%@vpruef.example');
DELETE FROM auth_session
 WHERE actor_id IN (SELECT id FROM actor WHERE email LIKE '%@vpruef.example');
DELETE FROM login_attempt
 WHERE email LIKE '%@vpruef.example';

-- Das Konto des Falls "Der Nachweis ueberlebt das Konto" (K04-G07) wird
-- im Lauf geloescht. Es entsteht hier jedes Mal neu.
DELETE FROM actor WHERE email = 'vp_geloescht@vpruef.example';

-- ---------------------------------------------------------------------
-- 5 · Die Konten
--
--     Jedes Konto ist AKTIV und Mitglied im freigeschalteten Portal
--     ENDUSER seines Mandanten -- damit ein Fall NUR an seiner eigenen
--     Regel scheitern kann.
--
--       vp_weg        Mandant A · faehrt den Weg EN-02 -> EN-03 -> EN-04
--                     und bleibt am Ende UNVOLLSTAENDIG (fail-closed)
--       vp_halt       Mandant A · faehrt bis zum HALT und danach ueber
--                     alle drei Auswege
--       vp_geeignet   Mandant A · die Gegenprobe: dreimal geeignet
--       vp_leer       Mandant A · hat NIE einen Check -- misst den
--                     fremden Mandanten und den Sperrfall ohne Check
--       vp_fremd      Mandant B · sein Check darf fuer A nicht bestehen
--       vp_negativ    Mandant A · traegt den vorbereiteten Check, an dem
--                     die Negativfaelle gegen die Datenbank laufen
--       vp_geloescht  Mandant A · wird im Lauf geloescht (K04-G07)
-- ---------------------------------------------------------------------
INSERT INTO actor (id, tenant_id, email, display_name, mfa_method, status, created_on) VALUES
  ('00000000-0000-4000-8000-00000000ea02','00000000-0000-4000-8000-00000000ef02','vp_weg@vpruef.example',      'Pruef Weg',            'EMAIL_CODE','AKTIV',current_date),
  ('00000000-0000-4000-8000-00000000ea03','00000000-0000-4000-8000-00000000ef02','vp_halt@vpruef.example',     'Pruef Halt',           'EMAIL_CODE','AKTIV',current_date),
  ('00000000-0000-4000-8000-00000000ea04','00000000-0000-4000-8000-00000000ef02','vp_geeignet@vpruef.example', 'Pruef Geeignet',       'EMAIL_CODE','AKTIV',current_date),
  ('00000000-0000-4000-8000-00000000ea05','00000000-0000-4000-8000-00000000ef03','vp_fremd@vpruef.example',    'Pruef Fremder Mandant','EMAIL_CODE','AKTIV',current_date),
  ('00000000-0000-4000-8000-00000000ea06','00000000-0000-4000-8000-00000000ef02','vp_leer@vpruef.example',     'Pruef ohne Check',     'EMAIL_CODE','AKTIV',current_date),
  ('00000000-0000-4000-8000-00000000ea07','00000000-0000-4000-8000-00000000ef02','vp_negativ@vpruef.example',  'Pruef Negativfaelle',  'EMAIL_CODE','AKTIV',current_date),
  ('00000000-0000-4000-8000-00000000ea08','00000000-0000-4000-8000-00000000ef02','vp_geloescht@vpruef.example','Pruef geloeschtes Konto','EMAIL_CODE','AKTIV',current_date)
ON CONFLICT (id) DO UPDATE SET
  tenant_id    = EXCLUDED.tenant_id,
  email        = EXCLUDED.email,
  display_name = EXCLUDED.display_name,
  mfa_method   = EXCLUDED.mfa_method,
  status       = EXCLUDED.status;

INSERT INTO membership (actor_id, portal_code, role_id, tenant_scope)
SELECT a.id, 'ENDUSER', r.id, a.tenant_id
  FROM actor a
  CROSS JOIN (SELECT id FROM role WHERE portal_code='ENDUSER' AND name='Endnutzer') r
 WHERE a.email LIKE '%@vpruef.example'
   AND a.email <> 'vp_admin@vpruef.example'      -- gehoert zu EXMA
ON CONFLICT DO NOTHING;

-- ---------------------------------------------------------------------
-- 6 · Der Katalog der drei Eignungsfragen
--
--     ER IST PRUEFGEGENSTAND, NICHT AUFBAU (K04-M04/M05/M06/M07/D02).
--     Deshalb: nur wenn fit_question voellig leer ist, entsteht ein
--     ERSATZBESTAND -- erkennbar in jedem Anzeigetext, und der Lauf
--     sperrt dann jeden Fall, der den Bestand misst.
--
--     Die vier Ausschlusstexte aus K04-M07 stehen auch im Ersatzbestand
--     im Wortlaut. Nicht damit ein Fall besteht -- der ist gesperrt --,
--     sondern damit die WEGE (Halt, drei Auswege) ueberhaupt fahrbar
--     sind, wenn der Bau den Seed schuldig bleibt.
--
--     NACHGERECHNET am 15.08.2026 gegen eine frisch aus
--     schema/freiraum_datamodel.sql und M30 aufgebaute Datenbank:
--     der Katalog steht BEREITS im Zielschema (Zeilen 737-756, "SEED:
--     Eignungs-Check", drei Fragen, dreizehn Moeglichkeiten, davon vier
--     mit is_eligible = falsch). Der Zweig unten laeuft in der heutigen
--     Fassung also NIE. Er bleibt trotzdem stehen: er ist die Sicherung
--     dagegen, dass diese Pruefung stillschweigend nichts misst, falls
--     der Startbestand einmal fehlt.
-- ---------------------------------------------------------------------
CREATE TABLE IF NOT EXISTS pruef_vorpruefung_herkunft (
  quelle     text NOT NULL,
  notiert_am timestamptz NOT NULL DEFAULT now()
);
DELETE FROM pruef_vorpruefung_herkunft;

DO $$
BEGIN
  IF (SELECT count(*) FROM fit_question) = 0 THEN

    INSERT INTO fit_question (code, dimension, position, prompt_de) VALUES
      ('art',     'ART',     1, '[Ersatzbestand der Pruefung · ungezeichnet H09/Punkt 13] Um was fuer eine Anwendung geht es?'),
      ('nutzung', 'NUTZUNG', 2, '[Ersatzbestand der Pruefung · ungezeichnet H09/Punkt 13] Wie soll sie genutzt werden?'),
      ('daten',   'DATEN',   3, '[Ersatzbestand der Pruefung · ungezeichnet H09/Punkt 13] Verarbeitet sie fachliche Daten?');

    INSERT INTO fit_option (question_code, position, label_de, value_token, is_eligible) VALUES
      ('art',     1, '[Ersatzbestand] Fachanwendung mit eigener Logik',                       'FACHANWENDUNG', true),
      ('art',     2, '[Ersatzbestand] reine Netzseite',                                       'NETZSEITE',     false),
      ('art',     3, '[Ersatzbestand] etwas zum Installieren auf Rechner oder Geraet',        'INSTALLATION',  false),
      ('nutzung', 1, '[Ersatzbestand] Produktivbetrieb im Unternehmen',                       'PRODUKTIV',     true),
      ('nutzung', 2, '[Ersatzbestand] Wegwerf-Versuch ohne Produktivbetrieb',                 'WEGWERF',       false),
      ('daten',   1, '[Ersatzbestand] Ja - sie verarbeitet fachliche Daten',                  'DATEN_JA',      true),
      ('daten',   2, '[Ersatzbestand] Nein - es geht um Darstellung, Inhalte oder Gestaltung','DATEN_NEIN',    false);

    INSERT INTO pruef_vorpruefung_herkunft (quelle) VALUES ('ERSATZ');
  ELSE
    INSERT INTO pruef_vorpruefung_herkunft (quelle) VALUES ('BESTAND');
  END IF;
END $$;

-- ---------------------------------------------------------------------
-- 7 · Die vorbereiteten Faelle
--
--     ec01  der Check des FREMDEN Mandanten B (K04-D08). Er ist
--           abgeschlossen und traegt completed_at -- sonst scheiterte
--           er an fit_done_needs_ts statt am Mandantenschnitt.
--     ec02  der Check am Mandanten der Loeschsperre (K04-M10)
--     ec03  der Check, an dem die Negativfaelle gegen die Datenbank
--           laufen (K04-M14, M12, M11, G08)
--     ec04  der Check des Kontos, das im Lauf geloescht wird (K04-G07)
-- ---------------------------------------------------------------------
INSERT INTO fit_check (id, tenant_id, actor_id, outcome, completed_at, retention_class) VALUES
  ('00000000-0000-4000-8000-00000000ec01','00000000-0000-4000-8000-00000000ef03',
   '00000000-0000-4000-8000-00000000ea05','NICHT_GEEIGNET', now() - interval '1 hour','KI_NACHWEIS'),
  ('00000000-0000-4000-8000-00000000ec02','00000000-0000-4000-8000-00000000ef04',
   NULL,                                   'OFFEN',          NULL,                    'KI_NACHWEIS'),
  ('00000000-0000-4000-8000-00000000ec03','00000000-0000-4000-8000-00000000ef02',
   '00000000-0000-4000-8000-00000000ea07','OFFEN',           NULL,                    'KI_NACHWEIS'),
  ('00000000-0000-4000-8000-00000000ec04','00000000-0000-4000-8000-00000000ef02',
   '00000000-0000-4000-8000-00000000ea08','OFFEN',           NULL,                    'KI_NACHWEIS');

-- Genau EINE nicht zurueckgenommene Antwort auf ec03. Gewaehlt wird die
-- erste Frage (nach position), die mindestens ZWEI Antwortmoeglichkeiten
-- fuehrt -- der Negativfall gegen fit_answer_aktiv_uq braucht eine
-- zweite Moeglichkeit derselben Frage, sonst scheiterte er an der
-- Primaerschluesselbedingung statt am Teilindex (F07).
INSERT INTO fit_answer (fit_check_id, question_code, option_id)
SELECT '00000000-0000-4000-8000-00000000ec03', k.code,
       (SELECT o.id FROM fit_option o
         WHERE o.question_code = k.code ORDER BY o.position LIMIT 1)
  FROM (SELECT q.code
          FROM fit_question q
          JOIN fit_option o ON o.question_code = q.code
         GROUP BY q.code, q.position
        HAVING count(*) >= 2
         ORDER BY q.position
         LIMIT 1) k;

-- ---------------------------------------------------------------------
-- 8 · Sichten auf die Lage
--     Der Lauf prueft damit den AUFBAU, bevor ein einziger Fall laeuft,
--     und liest daraus den Zustand des Katalogs.
--
--     Bewusst tragen diese Sichten KEINE Spalte vom Typ fit_outcome und
--     keinen Spaltennamen aus dem Wortfeld "Eignung": ein Fall misst,
--     dass neben fit_check.outcome kein zweiter Eignungsstrang besteht
--     (K04-D05) -- meine eigenen Sichten duerfen ihn nicht vortaeuschen.
-- ---------------------------------------------------------------------
CREATE OR REPLACE VIEW pruef_vorpruefung_lage AS
SELECT (SELECT count(*)                    FROM fit_question)                  AS fragen,
       (SELECT count(DISTINCT dimension)   FROM fit_question)                  AS dimensionen,
       (SELECT count(*)                    FROM fit_option)                    AS optionen,
       (SELECT count(*) FROM fit_option WHERE NOT is_eligible)                 AS ausschluss_optionen,
       (SELECT count(*) FROM fit_question q
         WHERE EXISTS (SELECT 1 FROM fit_option o
                        WHERE o.question_code = q.code AND o.is_eligible))     AS fragen_mit_zusage,
       (SELECT count(*) FROM fit_question q
         WHERE EXISTS (SELECT 1 FROM fit_option o
                        WHERE o.question_code = q.code AND NOT o.is_eligible)) AS fragen_mit_ausschluss,
       (SELECT quelle FROM pruef_vorpruefung_herkunft ORDER BY notiert_am DESC LIMIT 1)
                                                                               AS katalog_herkunft;

CREATE OR REPLACE VIEW pruef_vorpruefung_katalog AS
SELECT q.position,
       q.code,
       q.dimension::text                                                       AS dimension,
       q.prompt_de,
       (SELECT count(*) FROM fit_option o WHERE o.question_code = q.code)      AS moeglichkeiten,
       (SELECT count(*) FROM fit_option o
         WHERE o.question_code = q.code AND o.is_eligible)                     AS zusagend,
       (SELECT count(*) FROM fit_option o
         WHERE o.question_code = q.code AND NOT o.is_eligible)                 AS ausschliessend
  FROM fit_question q;

CREATE OR REPLACE VIEW pruef_vorpruefung_konten AS
SELECT a.email,
       a.id                                            AS actor_id,
       a.tenant_id,
       a.status::text                                  AS status,
       (SELECT count(*) FROM membership m JOIN portal p ON p.code = m.portal_code
         WHERE m.actor_id = a.id AND p.release_status = 'ENABLED')
                                                       AS freigeschaltete_portale,
       (SELECT count(*) FROM fit_check c WHERE c.actor_id = a.id)
                                                       AS checks,
       (SELECT count(*) FROM auth_session s
         WHERE s.actor_id = a.id AND s.ended_at IS NULL)
                                                       AS offene_sitzungen
  FROM actor a
 WHERE a.email LIKE '%@vpruef.example';

-- ---------------------------------------------------------------------
-- 9 · AUFBAUPRUEFUNG (F07)
--
--     Geprueft wird AUSSCHLIESSLICH, was diese Datei zu verantworten
--     hat. Der Katalog steht bewusst NICHT darunter -- er ist der
--     Pruefgegenstand, nicht der Aufbau (siehe Kopf).
-- ---------------------------------------------------------------------
DO $$
DECLARE r record; fehler text := '';
BEGIN
  -- (a) Jedes Konto ausser dem Admin gehoert in ein freigeschaltetes Portal.
  FOR r IN SELECT * FROM pruef_vorpruefung_konten
            WHERE email <> 'vp_admin@vpruef.example'
              AND freigeschaltete_portale < 1
  LOOP fehler := fehler || format('%s ohne freigeschaltetes Portal; ', r.email); END LOOP;

  -- (b) Jedes Konto ist AKTIV -- kein Fall misst hier den Kontozustand.
  FOR r IN SELECT * FROM pruef_vorpruefung_konten WHERE status <> 'AKTIV'
  LOOP fehler := fehler || format('%s ist %s statt AKTIV; ', r.email, r.status); END LOOP;

  -- (c) Der Mandantenschnitt: vp_fremd gehoert zu B, alle anderen zu A.
  IF (SELECT tenant_id FROM pruef_vorpruefung_konten WHERE email='vp_fremd@vpruef.example')
     <> '00000000-0000-4000-8000-00000000ef03' THEN
    fehler := fehler || 'vp_fremd@ steht nicht im fremden Mandanten B; ';
  END IF;
  FOR r IN SELECT * FROM pruef_vorpruefung_konten
            WHERE email IN ('vp_weg@vpruef.example','vp_halt@vpruef.example',
                            'vp_geeignet@vpruef.example','vp_leer@vpruef.example',
                            'vp_negativ@vpruef.example','vp_geloescht@vpruef.example')
              AND tenant_id <> '00000000-0000-4000-8000-00000000ef02'
  LOOP fehler := fehler || format('%s steht nicht im Mandanten A; ', r.email); END LOOP;

  -- (d) Die drei Konten, die den Weg fahren, haben NOCH KEINEN Check --
  --     sonst misst "es entsteht genau ein Check" nichts.
  FOR r IN SELECT * FROM pruef_vorpruefung_konten
            WHERE email IN ('vp_weg@vpruef.example','vp_halt@vpruef.example',
                            'vp_geeignet@vpruef.example','vp_leer@vpruef.example')
              AND checks <> 0
  LOOP fehler := fehler || format('%s traegt schon %s Checks aus einem frueheren Lauf; ', r.email, r.checks); END LOOP;

  -- (e) Keine offene Sitzung aus einem frueheren Lauf.
  IF EXISTS (SELECT 1 FROM pruef_vorpruefung_konten WHERE offene_sitzungen > 0) THEN
    fehler := fehler || 'es stehen noch offene Sitzungen aus einem frueheren Lauf; ';
  END IF;

  -- (f) Die vier vorbereiteten Faelle stehen.
  IF NOT EXISTS (SELECT 1 FROM fit_check
                  WHERE id='00000000-0000-4000-8000-00000000ec01'
                    AND tenant_id='00000000-0000-4000-8000-00000000ef03'
                    AND outcome='NICHT_GEEIGNET' AND completed_at IS NOT NULL) THEN
    fehler := fehler || 'der Check des fremden Mandanten fehlt oder ist nicht abgeschlossen; ';
  END IF;
  IF NOT EXISTS (SELECT 1 FROM fit_check
                  WHERE id='00000000-0000-4000-8000-00000000ec02'
                    AND tenant_id='00000000-0000-4000-8000-00000000ef04') THEN
    fehler := fehler || 'der Check am Mandanten der Loeschsperre fehlt; ';
  END IF;

  -- (g) Am Mandanten der Loeschsperre haengt WIRKLICH nur der Check.
  --     Haengt mehr daran, scheitert der Loeschversuch an einer fremden
  --     Bedingung und misst nichts (F07).
  IF (SELECT count(*) FROM fit_check WHERE tenant_id='00000000-0000-4000-8000-00000000ef04') <> 1 THEN
    fehler := fehler || 'am Mandanten der Loeschsperre haengt nicht genau ein Check; ';
  END IF;
  IF EXISTS (SELECT 1 FROM actor   WHERE tenant_id='00000000-0000-4000-8000-00000000ef04')
  OR EXISTS (SELECT 1 FROM app     WHERE tenant_id='00000000-0000-4000-8000-00000000ef04')
  OR EXISTS (SELECT 1 FROM contact WHERE tenant_id='00000000-0000-4000-8000-00000000ef04') THEN
    fehler := fehler || 'am Mandanten der Loeschsperre haengt mehr als der Check; ';
  END IF;

  -- (h) Der Check der Negativfaelle traegt genau eine offene Antwort --
  --     ODER der Katalog gibt keine her; dann sperrt der Lauf die Faelle.
  IF (SELECT count(*) FROM fit_answer
       WHERE fit_check_id='00000000-0000-4000-8000-00000000ec03'
         AND superseded_at IS NULL) > 1 THEN
    fehler := fehler || 'der Check der Negativfaelle traegt mehr als eine offene Antwort; ';
  END IF;

  -- (i) Es gibt keine Anwendung in den Pruefmandanten -- mehrere Faelle
  --     messen "es entsteht keine Anwendung".
  IF EXISTS (SELECT 1 FROM app
              WHERE tenant_id IN ('00000000-0000-4000-8000-00000000ef02',
                                  '00000000-0000-4000-8000-00000000ef03')) THEN
    fehler := fehler || 'in den Pruefmandanten steht schon eine Anwendung; ';
  END IF;

  IF fehler <> '' THEN
    RAISE EXCEPTION 'AUFBAU UNBRAUCHBAR (F07): %', fehler;
  END IF;
END $$;

-- ---------------------------------------------------------------------
-- 10 · Was jetzt steht
-- ---------------------------------------------------------------------
SELECT * FROM pruef_vorpruefung_lage;
SELECT position, code, dimension, moeglichkeiten, zusagend, ausschliessend
  FROM pruef_vorpruefung_katalog ORDER BY position;
SELECT email, status, freigeschaltete_portale AS portale, checks
  FROM pruef_vorpruefung_konten ORDER BY email;

\echo 'Pruefdaten stehen. Aufbaupruefung (F07) bestanden.'
\echo 'Der Katalog der drei Fragen ist Pruefgegenstand, nicht Aufbau --'
\echo 'siehe Spalte katalog_herkunft: BESTAND = vom Bau, ERSATZ = von der Pruefung.'
