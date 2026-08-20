-- =====================================================================
-- FREIRAUM · M5 "Das gefuehrte Gespraech" (EN-05 Orientierung, EN-06
-- Interview)
-- Pruefdaten fuer die Klauselpruefung (gespraech_lauf.sh)
--
-- Geschrieben gegen die 101 Klauseln aus klauseln.md (K01, K02, K03,
-- K04, K05, K10, K13, K17, K19 -- Zaehlung: nachweise/klauselregister/
-- M5_klausellage_260819.json) -- NICHT gegen den Umsetzungscode. Der
-- Prueffall kennt den Server nur durch seine Tueren.
--
-- Aufruf (NACH dem Startbestand/Seed des Baus):
--   psql -h localhost -p 55433 -U postgres -d freiraum_pruef \
--        -v ON_ERROR_STOP=1 -f pruefungen/klauseln/gespraech_daten.sql
--
-- Diese Datei ist WIEDERHOLBAR.
--
-- ---------------------------------------------------------------------
-- MASSSTAB F07 -- und die Arbeitsteilung, die daraus folgt
-- ---------------------------------------------------------------------
-- Ein Prueffall, der an einer FREMDEN Bedingung scheitert, misst nichts.
-- Deshalb legt diese Datei NUR die AUSGANGSLAGE an, die vor Stufe 01
-- oder mitten in Stufe 02 gilt -- niemals den Gespraechsinhalt selbst:
--
--   * Mandanten, Konten, Mitgliedschaften, Eignungs-Checks (fit_check)
--     und je nach Fall eine app-Zeile mit journey_phase -- das ist
--     Ausgangslage und wird hier angelegt und am Ende geprueft.
--   * Beitraege, Herkunftsmarken, Uebersprungvermerke, der Dreischritt
--     Datei/document/event -- das ist der PRUEFGEGENSTAND von M5 selbst
--     (K05-M25, K05-M26, K05-M08 ...). Diese Datei legt dazu NICHTS an;
--     jeder Prueffall in gespraech_lauf.sh stellt seinen eigenen
--     Gespraechsstand ueber den Serverpfad her, live, waehrend er misst.
--     Wer diesen Inhalt vorwegnaehme, messe hinterher nur noch sich
--     selbst -- derselbe Fehler wie am 02.08.2026 (offener Punkt
--     O-K23-7).
--
-- Alle Adressen dieser Datei enden auf @gespraechpruef.example. Damit
-- stoert sie die Daten anderer Scheiben nicht und wird von ihnen nicht
-- gestoert.
-- =====================================================================

\set ON_ERROR_STOP on

-- ---------------------------------------------------------------------
-- 1 · Der Pruefwert des Anmeldecodes
--     K03-M15: "Gespeichert wird nur sein kryptografischer Pruefwert."
--     Dieselbe Ableitung wie in den Nachbardateien -- der Lauf stellt
--     sich seine Codes damit selbst aus und ist wiederholbar.
-- ---------------------------------------------------------------------
CREATE OR REPLACE FUNCTION pruef_codewert(klartext text, pfeffer text)
RETURNS text LANGUAGE sql IMMUTABLE AS
$$ SELECT encode(sha256(convert_to(pfeffer || klartext, 'utf8')), 'hex') $$;

-- ---------------------------------------------------------------------
-- 2 · Mandanten
--
--     ea01  Betreiber -- traegt nur den Plattform-Admin
--     ea02  Mandant A -- der Mandant der Sitzung, in dem gemessen wird
--     ea03  Mandant B -- der FREMDE Mandant (K01-M15, K02-M20, K02-M21,
--           K05-M27, K17-D13)
-- ---------------------------------------------------------------------
INSERT INTO tenant (id, kind, name, customer_code, legal_space) VALUES
  ('00000000-0000-4000-8000-0000000ea01','OPERATOR','Pruefbetreiber Gespraech',  NULL,     'DE'),
  ('00000000-0000-4000-8000-0000000ea02','CUSTOMER','Pruefkunde Gespraech A',    'DE-GSA', 'DE'),
  ('00000000-0000-4000-8000-0000000ea03','CUSTOMER','Pruefkunde Gespraech B',    'DE-GSB', 'DE')
ON CONFLICT (id) DO NOTHING;

-- ---------------------------------------------------------------------
-- 3 · Der Plattform-Admin ZUERST
--
--     platform_admin_guard haengt an actor und membership: bleibt kein
--     aktiver EXMA-Admin uebrig, scheitert JEDE spaetere Aenderung an
--     actor. Er ist Aufbau, kein Prueffall.
-- ---------------------------------------------------------------------
INSERT INTO actor (id, tenant_id, email, display_name, mfa_method, status, created_on)
VALUES ('00000000-0000-4000-8000-0000000eb00',
        '00000000-0000-4000-8000-0000000ea01',
        'gs_admin@gespraechpruef.example', 'Pruef Plattform-Admin Gespraech',
        'EMAIL_CODE', 'AKTIV', current_date)
ON CONFLICT (id) DO NOTHING;

INSERT INTO membership (actor_id, portal_code, role_id, tenant_scope)
SELECT '00000000-0000-4000-8000-0000000eb00', 'EXMA', r.id,
       '00000000-0000-4000-8000-0000000ea01'
  FROM role r WHERE r.portal_code = 'EXMA' AND r.name = 'Plattform-Admin'
ON CONFLICT DO NOTHING;

UPDATE actor SET status = 'AKTIV'
 WHERE id = '00000000-0000-4000-8000-0000000eb00' AND status <> 'AKTIV';

-- ---------------------------------------------------------------------
-- 4 · Alten Lauf zuruecksetzen
--
--     Reihenfolge: erst fit_check.app_id loesen, dann app, dann
--     fit_check (keine Referenz mehr offen), dann Anmelde- und
--     Sitzungsspuren. event/document/app_state_history werden NICHT
--     geleert -- append-only bzw. Pruefgegenstand jedes einzelnen
--     Laufs; gespraech_lauf.sh misst dort die ZUNAHME, nie den
--     Gesamtstand (Regel aus zweckbestimmung_lauf.sh, Abschn. 3).
-- ---------------------------------------------------------------------
UPDATE fit_check SET app_id = NULL
 WHERE tenant_id IN ('00000000-0000-4000-8000-0000000ea02',
                     '00000000-0000-4000-8000-0000000ea03');

DELETE FROM app
 WHERE tenant_id IN ('00000000-0000-4000-8000-0000000ea02',
                     '00000000-0000-4000-8000-0000000ea03');

DELETE FROM fit_check
 WHERE tenant_id IN ('00000000-0000-4000-8000-0000000ea02',
                     '00000000-0000-4000-8000-0000000ea03');

DELETE FROM login_code
 WHERE actor_id IN (SELECT id FROM actor WHERE email LIKE '%@gespraechpruef.example');
DELETE FROM auth_session
 WHERE actor_id IN (SELECT id FROM actor WHERE email LIKE '%@gespraechpruef.example');
DELETE FROM login_attempt
 WHERE email LIKE '%@gespraechpruef.example';

-- ---------------------------------------------------------------------
-- 5 · Die Konten
--
--     Jedes Konto ist AKTIV und Mitglied im freigeschalteten Portal
--     ENDUSER seines Mandanten -- damit ein Fall NUR an seiner eigenen
--     Regel scheitern kann. Die eine Ausnahme ist gs_gesperrt@; sie
--     traegt GESPERRT mit Absicht.
--
--       gs_frisch        A · Stufe 01, ganz am Anfang -- der Haupt-
--                            Treiber fuer EN-05 (K05-M01, M02, M03, M04,
--                            G02, M05, M06, G05, M07, D04, G06, M08 ...)
--       gs_zielrang       A · Stufe 01, ganz am Anfang -- ZWEITER,
--                            unabhaengiger Lauf fuer K05-G04 (Rangfolge
--                            entsteht aus der Klickreihenfolge)
--       gs_namensweg      A · Stufe 01, ganz am Anfang -- eigener
--                            Treiber fuer den Namensschritt, damit er
--                            gs_frisch nicht mitten in dessen eigener
--                            Fahrt beruehrt
--       gs_ueberspringen  A · Stufe 01, ganz am Anfang, wird NIE ueber
--                            EN-05 vorangetrieben -- Ziel ist allein der
--                            Negativfall "EN-06-Aktion oder fremd
--                            uebergebene Stufe waehrend ORIENTIERUNG"
--                            (K05-D06, K13-M09 zweiter Negativlauf)
--       gs_unmittelbar    A · Stufe 01, ganz am Anfang -- Ziel ist der
--                            unmittelbare (am Serverpfad vorbei-
--                            gehende) Schreibversuch (K13-M05, K13-M09,
--                            K19-M14)
--       gs_isoliert       A · Stufe 01, ganz am Anfang, wird von KEINEM
--                            Testfall angefasst -- reine Kontrollzeile
--                            fuer die Isolationsprobe zu K01-M01
--       gs_interview      A · Stufe 02 (INTERVIEW), Name bereits
--                            gesetzt -- Haupt-Treiber fuer EN-06
--       gs_interview2     A · Stufe 02 (INTERVIEW) -- zweiter,
--                            unabhaengiger Lauf fuer Faelle, die zwei
--                            getrennte Gespraeche brauchen (K05-D02,
--                            K05-D03 Negativfall, K17-M02 Negativfall C)
--       gs_fertig         A · Stufe 03 (UEBERSICHT) -- das Interview ist
--                            bereits abgeschlossen; Ziel ist die
--                            Nur-Ansicht rueckwaerts (K05-D06 symmetrisch)
--       gs_gleich1        A · Stufe 02 (INTERVIEW), actor_label absicht-
--                            lich identisch mit gs_gleich2 -- K03-M20
--       gs_gleich2        A · Stufe 02 (INTERVIEW), actor_label wie
--                            gs_gleich1, ABER eigene actor.id -- K03-M20
--       gs_offen          A · fit_check OFFEN, KEINE app-Zeile -- K04-G04
--                            Negativfall, K19-D09
--       gs_ohnecheck      A · KEIN fit_check, KEINE app-Zeile -- weiterer
--                            Negativfall "Check nicht lesbar"
--       gs_gesperrt       A · GESPERRT -- die Bedingung "aktives Konto"
--                            aus K03-D01
--       gs_fremd          B · das Konto des FREMDEN Mandanten, Stufe 02
--                            (INTERVIEW) -- K01-M15, K02-M20, K02-M21,
--                            K05-M27, K17-D13
-- ---------------------------------------------------------------------
INSERT INTO actor (id, tenant_id, email, display_name, mfa_method, status, created_on) VALUES
  ('00000000-0000-4000-8000-0000000eb01','00000000-0000-4000-8000-0000000ea02','gs_frisch@gespraechpruef.example',       'Pruef Stufe Eins Frisch',    'EMAIL_CODE','AKTIV',current_date),
  ('00000000-0000-4000-8000-0000000eb02','00000000-0000-4000-8000-0000000ea02','gs_zielrang@gespraechpruef.example',     'Pruef Zielrangfolge',        'EMAIL_CODE','AKTIV',current_date),
  ('00000000-0000-4000-8000-0000000eb03','00000000-0000-4000-8000-0000000ea02','gs_namensweg@gespraechpruef.example',    'Pruef Namensschritt',        'EMAIL_CODE','AKTIV',current_date),
  ('00000000-0000-4000-8000-0000000eb04','00000000-0000-4000-8000-0000000ea02','gs_ueberspringen@gespraechpruef.example','Pruef Stufe ueberspringen',  'EMAIL_CODE','AKTIV',current_date),
  ('00000000-0000-4000-8000-0000000eb05','00000000-0000-4000-8000-0000000ea02','gs_unmittelbar@gespraechpruef.example',  'Pruef Unmittelbarer Zugriff','EMAIL_CODE','AKTIV',current_date),
  ('00000000-0000-4000-8000-0000000eb06','00000000-0000-4000-8000-0000000ea02','gs_isoliert@gespraechpruef.example',     'Pruef Isolationskontrolle',  'EMAIL_CODE','AKTIV',current_date),
  ('00000000-0000-4000-8000-0000000eb07','00000000-0000-4000-8000-0000000ea02','gs_interview@gespraechpruef.example',    'Pruef Stufe Zwei',           'EMAIL_CODE','AKTIV',current_date),
  ('00000000-0000-4000-8000-0000000eb08','00000000-0000-4000-8000-0000000ea02','gs_interview2@gespraechpruef.example',   'Pruef Stufe Zwei Zweitlauf', 'EMAIL_CODE','AKTIV',current_date),
  ('00000000-0000-4000-8000-0000000eb09','00000000-0000-4000-8000-0000000ea02','gs_fertig@gespraechpruef.example',       'Pruef Interview Fertig',     'EMAIL_CODE','AKTIV',current_date),
  ('00000000-0000-4000-8000-0000000eb0a','00000000-0000-4000-8000-0000000ea02','gs_gleich1@gespraechpruef.example',      'Pruef Gleicher Anzeigename', 'EMAIL_CODE','AKTIV',current_date),
  ('00000000-0000-4000-8000-0000000eb0b','00000000-0000-4000-8000-0000000ea02','gs_gleich2@gespraechpruef.example',      'Pruef Gleicher Anzeigename', 'EMAIL_CODE','AKTIV',current_date),
  ('00000000-0000-4000-8000-0000000eb0c','00000000-0000-4000-8000-0000000ea02','gs_offen@gespraechpruef.example',        'Pruef Check Offen',          'EMAIL_CODE','AKTIV',current_date),
  ('00000000-0000-4000-8000-0000000eb0d','00000000-0000-4000-8000-0000000ea02','gs_ohnecheck@gespraechpruef.example',    'Pruef Ohne Check',           'EMAIL_CODE','AKTIV',current_date),
  ('00000000-0000-4000-8000-0000000eb0e','00000000-0000-4000-8000-0000000ea02','gs_gesperrt@gespraechpruef.example',     'Pruef Gesperrtes Konto',     'EMAIL_CODE','GESPERRT',current_date),
  ('00000000-0000-4000-8000-0000000eb0f','00000000-0000-4000-8000-0000000ea03','gs_fremd@gespraechpruef.example',        'Pruef Fremder Mandant',      'EMAIL_CODE','AKTIV',current_date)
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
 WHERE a.email LIKE '%@gespraechpruef.example'
   AND a.email <> 'gs_admin@gespraechpruef.example'      -- gehoert zu EXMA
ON CONFLICT DO NOTHING;

-- ---------------------------------------------------------------------
-- 6 · Die Anwendungen (app) -- ausschliesslich die AUSGANGSLAGE:
--     journey_phase, lifecycle_state, ggf. bereits gesetzter Name.
--     KEIN Beitrag, KEINE Herkunftsmarke, KEIN document, KEIN Uebersprung-
--     vermerk -- das ist der Pruefgegenstand von gespraech_lauf.sh
--     selbst (Abschn. "MASSSTAB F07" oben).
-- ---------------------------------------------------------------------
INSERT INTO app (id, tenant_id, name, journey_phase, lifecycle_state) VALUES
  ('00000000-0000-4000-8000-0000000ed01','00000000-0000-4000-8000-0000000ea02', NULL,                             'ORIENTIERUNG','DISCOVERY'),
  ('00000000-0000-4000-8000-0000000ed02','00000000-0000-4000-8000-0000000ea02', NULL,                             'ORIENTIERUNG','DISCOVERY'),
  ('00000000-0000-4000-8000-0000000ed03','00000000-0000-4000-8000-0000000ea02', NULL,                             'ORIENTIERUNG','DISCOVERY'),
  ('00000000-0000-4000-8000-0000000ed04','00000000-0000-4000-8000-0000000ea02', NULL,                             'ORIENTIERUNG','DISCOVERY'),
  ('00000000-0000-4000-8000-0000000ed05','00000000-0000-4000-8000-0000000ea02', NULL,                             'ORIENTIERUNG','DISCOVERY'),
  ('00000000-0000-4000-8000-0000000ed06','00000000-0000-4000-8000-0000000ea02', NULL,                             'ORIENTIERUNG','DISCOVERY'),
  ('00000000-0000-4000-8000-0000000ed07','00000000-0000-4000-8000-0000000ea02','Pruefanwendung Stufe Zwei',       'INTERVIEW',   'DISCOVERY'),
  ('00000000-0000-4000-8000-0000000ed08','00000000-0000-4000-8000-0000000ea02','Pruefanwendung Stufe Zwei Zweit', 'INTERVIEW',   'DISCOVERY'),
  ('00000000-0000-4000-8000-0000000ed09','00000000-0000-4000-8000-0000000ea02','Pruefanwendung Fertig',           'UEBERSICHT',  'DISCOVERY'),
  ('00000000-0000-4000-8000-0000000ed0a','00000000-0000-4000-8000-0000000ea02','Pruefanwendung Gleich Eins',      'INTERVIEW',   'DISCOVERY'),
  ('00000000-0000-4000-8000-0000000ed0b','00000000-0000-4000-8000-0000000ea02','Pruefanwendung Gleich Zwei',      'INTERVIEW',   'DISCOVERY'),
  ('00000000-0000-4000-8000-0000000ed0c','00000000-0000-4000-8000-0000000ea03','Pruefanwendung Fremd',            'INTERVIEW',   'DISCOVERY')
ON CONFLICT (id) DO NOTHING;

-- ---------------------------------------------------------------------
-- 7 · Die vorbereiteten Eignungs-Checks (fit_check)
--
--     Jede Anwendung aus Abschn. 6 (ausser den beiden ohne app-Zeile,
--     gs_offen@ und gs_ohnecheck@) traegt genau EINEN GEEIGNET-Check,
--     der schon vor dem Lauf auf sie zeigt -- so, wie ein Konto nach
--     M4 dort ankaeme. gs_offen@ traegt einen Check mit OFFEN und OHNE
--     app-Zeile; gs_ohnecheck@ traegt gar keinen.
-- ---------------------------------------------------------------------
INSERT INTO fit_check (id, tenant_id, actor_id, app_id, outcome, completed_at, retention_class) VALUES
  ('00000000-0000-4000-8000-0000000ec01','00000000-0000-4000-8000-0000000ea02','00000000-0000-4000-8000-0000000eb01','00000000-0000-4000-8000-0000000ed01','GEEIGNET', now() - interval '5 minutes','KI_NACHWEIS'),
  ('00000000-0000-4000-8000-0000000ec02','00000000-0000-4000-8000-0000000ea02','00000000-0000-4000-8000-0000000eb02','00000000-0000-4000-8000-0000000ed02','GEEIGNET', now() - interval '5 minutes','KI_NACHWEIS'),
  ('00000000-0000-4000-8000-0000000ec03','00000000-0000-4000-8000-0000000ea02','00000000-0000-4000-8000-0000000eb03','00000000-0000-4000-8000-0000000ed03','GEEIGNET', now() - interval '5 minutes','KI_NACHWEIS'),
  ('00000000-0000-4000-8000-0000000ec04','00000000-0000-4000-8000-0000000ea02','00000000-0000-4000-8000-0000000eb04','00000000-0000-4000-8000-0000000ed04','GEEIGNET', now() - interval '5 minutes','KI_NACHWEIS'),
  ('00000000-0000-4000-8000-0000000ec05','00000000-0000-4000-8000-0000000ea02','00000000-0000-4000-8000-0000000eb05','00000000-0000-4000-8000-0000000ed05','GEEIGNET', now() - interval '5 minutes','KI_NACHWEIS'),
  ('00000000-0000-4000-8000-0000000ec06','00000000-0000-4000-8000-0000000ea02','00000000-0000-4000-8000-0000000eb06','00000000-0000-4000-8000-0000000ed06','GEEIGNET', now() - interval '5 minutes','KI_NACHWEIS'),
  ('00000000-0000-4000-8000-0000000ec07','00000000-0000-4000-8000-0000000ea02','00000000-0000-4000-8000-0000000eb07','00000000-0000-4000-8000-0000000ed07','GEEIGNET', now() - interval '20 minutes','KI_NACHWEIS'),
  ('00000000-0000-4000-8000-0000000ec08','00000000-0000-4000-8000-0000000ea02','00000000-0000-4000-8000-0000000eb08','00000000-0000-4000-8000-0000000ed08','GEEIGNET', now() - interval '20 minutes','KI_NACHWEIS'),
  ('00000000-0000-4000-8000-0000000ec09','00000000-0000-4000-8000-0000000ea02','00000000-0000-4000-8000-0000000eb09','00000000-0000-4000-8000-0000000ed09','GEEIGNET', now() - interval '30 minutes','KI_NACHWEIS'),
  ('00000000-0000-4000-8000-0000000ec0a','00000000-0000-4000-8000-0000000ea02','00000000-0000-4000-8000-0000000eb0a','00000000-0000-4000-8000-0000000ed0a','GEEIGNET', now() - interval '20 minutes','KI_NACHWEIS'),
  ('00000000-0000-4000-8000-0000000ec0b','00000000-0000-4000-8000-0000000ea02','00000000-0000-4000-8000-0000000eb0b','00000000-0000-4000-8000-0000000ed0b','GEEIGNET', now() - interval '20 minutes','KI_NACHWEIS'),
  ('00000000-0000-4000-8000-0000000ec0e','00000000-0000-4000-8000-0000000ea02','00000000-0000-4000-8000-0000000eb0e','00000000-0000-4000-8000-0000000ed01','GEEIGNET', now() - interval '5 minutes','KI_NACHWEIS'),
  ('00000000-0000-4000-8000-0000000ec0f','00000000-0000-4000-8000-0000000ea03','00000000-0000-4000-8000-0000000eb0f','00000000-0000-4000-8000-0000000ed0c','GEEIGNET', now() - interval '20 minutes','KI_NACHWEIS')
ON CONFLICT (id) DO NOTHING;

-- gs_gesperrt@ braucht eine EIGENE app-Zeile (nicht ed01, die gehoert
-- gs_frisch@) -- sonst maesse K03-D01 an einer app, die ein anderer
-- Testfall gerade veraendert (F07, Abschn. "PROBE VERUNREINIGT NICHT").
INSERT INTO app (id, tenant_id, name, journey_phase, lifecycle_state) VALUES
  ('00000000-0000-4000-8000-0000000ed0e','00000000-0000-4000-8000-0000000ea02', NULL, 'ORIENTIERUNG','DISCOVERY')
ON CONFLICT (id) DO NOTHING;
UPDATE fit_check SET app_id = '00000000-0000-4000-8000-0000000ed0e'
 WHERE id = '00000000-0000-4000-8000-0000000ec0e';

-- gs_offen@: OFFEN, KEINE app-Zeile (K04-M11 Vorgabewert; K04-G04
-- Negativfall).
INSERT INTO fit_check (id, tenant_id, actor_id, app_id, outcome, completed_at, retention_class)
VALUES ('00000000-0000-4000-8000-0000000ec0c','00000000-0000-4000-8000-0000000ea02',
        '00000000-0000-4000-8000-0000000eb0c', NULL, 'OFFEN', NULL, 'KI_NACHWEIS')
ON CONFLICT (id) DO NOTHING;
-- gs_ohnecheck@ traegt bewusst KEINEN fit_check -- kein INSERT.

-- ---------------------------------------------------------------------
-- 8 · Zwei Agenten-Zeilen fuer K17-M02 (plattformweit eindeutiger Name)
--
--     ea_moderator ist der Assistent, der in der Teilnehmerliste von
--     EN-06 als Moderator erscheinen muss (K05-M16); ea_zweit besteht
--     nur, damit ein zweiter Anlageversuch mit demselben Namen etwas
--     hat, an dem er scheitern kann.
-- ---------------------------------------------------------------------
DO $$
BEGIN
  INSERT INTO agent (id, name)
  VALUES ('00000000-0000-4000-8000-0000000ee01','Pruef-Moderator Gespraech');
EXCEPTION WHEN undefined_table OR undefined_column THEN
  NULL; -- agent-Tabelle in dieser Form nicht vorhanden; K17-M02 sperrt dann selbst
END $$;

-- ---------------------------------------------------------------------
-- 9 · Sichten auf die Lage
--
--     Bewusst OHNE jede Spalte, die einen Gespraechsinhalt vortaeuschen
--     koennte -- gespraech_lauf.sh misst, dass Beitraege, Marken und
--     Uebersprungvermerke ERST durch den Bau entstehen.
-- ---------------------------------------------------------------------
CREATE OR REPLACE VIEW pruef_gespraech_konten AS
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
 WHERE a.email LIKE '%@gespraechpruef.example';

CREATE OR REPLACE VIEW pruef_gespraech_apps AS
SELECT ap.id AS app_id, ap.tenant_id, ap.name, ap.journey_phase, ap.lifecycle_state,
       fc.outcome AS check_outcome, a.email AS konto
  FROM app ap
  JOIN fit_check fc ON fc.app_id = ap.id
  JOIN actor a ON a.id = fc.actor_id
 WHERE a.email LIKE '%@gespraechpruef.example';

-- ---------------------------------------------------------------------
-- 10 · AUFBAUPRUEFUNG (F07)
--
--     Geprueft wird AUSSCHLIESSLICH, was diese Datei zu verantworten
--     hat. Gespraechsinhalt, Herkunftsmarken, document- und event-
--     Zeilen zu diesen Anwendungen stehen bewusst NICHT darunter -- sie
--     sind Pruefgegenstand, nicht Aufbau.
-- ---------------------------------------------------------------------
DO $$
DECLARE r record; fehler text := '';
BEGIN
  -- (a) Jedes Konto ausser dem Admin gehoert in ein freigeschaltetes Portal.
  FOR r IN SELECT * FROM pruef_gespraech_konten
            WHERE email <> 'gs_admin@gespraechpruef.example'
              AND freigeschaltete_portale < 1
  LOOP fehler := fehler || format('%s ohne freigeschaltetes Portal; ', r.email); END LOOP;

  -- (b) Jedes Konto ausser dem einen Sperrfall ist AKTIV.
  FOR r IN SELECT * FROM pruef_gespraech_konten
            WHERE email <> 'gs_gesperrt@gespraechpruef.example' AND status <> 'AKTIV'
  LOOP fehler := fehler || format('%s ist %s statt AKTIV; ', r.email, r.status); END LOOP;
  IF (SELECT status FROM pruef_gespraech_konten WHERE email='gs_gesperrt@gespraechpruef.example')
     <> 'GESPERRT' THEN
    fehler := fehler || 'gs_gesperrt@ ist nicht GESPERRT -- die Bedingung "aktives Konto" waere nicht messbar; ';
  END IF;

  -- (c) Der Mandantenschnitt: gs_fremd@ gehoert zu B, alle anderen zu A.
  IF (SELECT tenant_id FROM pruef_gespraech_konten WHERE email='gs_fremd@gespraechpruef.example')
     <> '00000000-0000-4000-8000-0000000ea03' THEN
    fehler := fehler || 'gs_fremd@ steht nicht im fremden Mandanten B; ';
  END IF;
  FOR r IN SELECT * FROM pruef_gespraech_konten
            WHERE email NOT IN ('gs_admin@gespraechpruef.example','gs_fremd@gespraechpruef.example')
              AND tenant_id <> '00000000-0000-4000-8000-0000000ea02'
  LOOP fehler := fehler || format('%s steht nicht im Mandanten A; ', r.email); END LOOP;

  -- (d) journey_phase/outcome stehen so, wie die Faelle sie brauchen.
  FOR r IN SELECT konto, journey_phase, check_outcome FROM pruef_gespraech_apps
            WHERE konto IN ('gs_frisch@gespraechpruef.example','gs_zielrang@gespraechpruef.example',
                            'gs_namensweg@gespraechpruef.example','gs_ueberspringen@gespraechpruef.example',
                            'gs_unmittelbar@gespraechpruef.example','gs_isoliert@gespraechpruef.example',
                            'gs_gesperrt@gespraechpruef.example')
              AND (journey_phase <> 'ORIENTIERUNG' OR check_outcome <> 'GEEIGNET')
  LOOP fehler := fehler || format('%s steht nicht auf ORIENTIERUNG/GEEIGNET (traegt %s/%s); ', r.konto, r.journey_phase, r.check_outcome); END LOOP;

  FOR r IN SELECT konto, journey_phase FROM pruef_gespraech_apps
            WHERE konto IN ('gs_interview@gespraechpruef.example','gs_interview2@gespraechpruef.example',
                            'gs_gleich1@gespraechpruef.example','gs_gleich2@gespraechpruef.example',
                            'gs_fremd@gespraechpruef.example')
              AND journey_phase <> 'INTERVIEW'
  LOOP fehler := fehler || format('%s steht nicht auf INTERVIEW (traegt %s); ', r.konto, r.journey_phase); END LOOP;

  IF (SELECT journey_phase FROM pruef_gespraech_apps WHERE konto='gs_fertig@gespraechpruef.example')
     <> 'UEBERSICHT' THEN
    fehler := fehler || 'gs_fertig@ steht nicht auf UEBERSICHT; ';
  END IF;

  -- (e) gs_gleich1@ und gs_gleich2@ tragen denselben Anzeigenamen, aber
  --     verschiedene actor.id -- sonst misst K03-M20 nichts.
  IF (SELECT display_name FROM actor WHERE email='gs_gleich1@gespraechpruef.example')
     <> (SELECT display_name FROM actor WHERE email='gs_gleich2@gespraechpruef.example') THEN
    fehler := fehler || 'gs_gleich1@ und gs_gleich2@ tragen nicht denselben Anzeigenamen; ';
  END IF;
  IF (SELECT id FROM actor WHERE email='gs_gleich1@gespraechpruef.example')
     = (SELECT id FROM actor WHERE email='gs_gleich2@gespraechpruef.example') THEN
    fehler := fehler || 'gs_gleich1@ und gs_gleich2@ tragen dieselbe actor.id; ';
  END IF;

  -- (f) gs_offen@ hat KEINE app-Zeile, ihr Check traegt OFFEN.
  IF EXISTS (SELECT 1 FROM fit_check fc JOIN actor a ON a.id = fc.actor_id
              WHERE a.email = 'gs_offen@gespraechpruef.example' AND fc.app_id IS NOT NULL) THEN
    fehler := fehler || 'gs_offen@ traegt bereits eine Anwendung -- der Negativfall (OFFEN) waere nicht mehr rein; ';
  END IF;
  IF (SELECT outcome FROM fit_check fc JOIN actor a ON a.id = fc.actor_id
       WHERE a.email = 'gs_offen@gespraechpruef.example') <> 'OFFEN' THEN
    fehler := fehler || 'gs_offen@ traegt keinen Check mit outcome OFFEN; ';
  END IF;

  -- (g) gs_ohnecheck@ hat GAR KEINEN fit_check.
  IF EXISTS (SELECT 1 FROM fit_check fc JOIN actor a ON a.id = fc.actor_id
              WHERE a.email = 'gs_ohnecheck@gespraechpruef.example') THEN
    fehler := fehler || 'gs_ohnecheck@ traegt bereits einen fit_check -- der Negativfall waere nicht mehr rein; ';
  END IF;

  -- (h) Keine offene Sitzung aus einem frueheren Lauf.
  IF EXISTS (SELECT 1 FROM pruef_gespraech_konten WHERE offene_sitzungen > 0) THEN
    fehler := fehler || 'es stehen noch offene Sitzungen aus einem frueheren Lauf; ';
  END IF;

  -- (i) Kein Konto traegt schon mehr als einen fit_check aus einem
  --     frueheren, nicht zurueckgesetzten Lauf (die Zahl "genau einer
  --     GEEIGNET-Check" ist Voraussetzung fuer K04-M11/K05-G01).
  FOR r IN SELECT * FROM pruef_gespraech_konten
            WHERE email NOT IN ('gs_admin@gespraechpruef.example') AND checks <> 1
  LOOP fehler := fehler || format('%s traegt %s Checks statt genau 1; ', r.email, r.checks); END LOOP;

  IF fehler <> '' THEN
    RAISE EXCEPTION 'AUFBAU UNBRAUCHBAR (F07): %', fehler;
  END IF;
END $$;

-- ---------------------------------------------------------------------
-- 11 · Was jetzt steht
-- ---------------------------------------------------------------------
SELECT konto, journey_phase, lifecycle_state, check_outcome
  FROM pruef_gespraech_apps ORDER BY konto;
SELECT email, status, freigeschaltete_portale AS portale, checks
  FROM pruef_gespraech_konten ORDER BY email;

\echo 'Pruefdaten stehen. Aufbaupruefung (F07) bestanden.'
\echo 'Gespraechsinhalt, Herkunftsmarken und der Dreischritt Datei/document/'
\echo 'event legt diese Datei NICHT an -- das ist Pruefgegenstand von'
\echo 'gespraech_lauf.sh selbst.'
