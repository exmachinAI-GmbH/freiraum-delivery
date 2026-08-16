-- =====================================================================
-- FREIRAUM · Scheibe 2, zweiter Teil · M4 "Die Zweckbestimmung"
-- Pruefdaten fuer die Klauselpruefung  (zweckbestimmung_lauf.sh)
--
-- Geschrieben gegen K04-M08, M17, M18, M19, M20, M21, D06, D08, D09,
-- D10, G12 · K01-M27, M38, D19 · K19-M06, M14 und den Bildschirmvertrag
-- schema/K19_screens.yaml (EN-04a) sowie gegen
-- schema/freiraum_datamodel.sql --
-- NICHT gegen den Umsetzungscode. Der Prueffall kennt den Server nur
-- durch seine Tueren.
--
-- Aufruf (NACH dem Startbestand/Seed des Baus):
--   psql -h localhost -p 55433 -U postgres -d freiraum_pruef \
--        -v ON_ERROR_STOP=1 -f pruefungen/klauseln/zweckbestimmung_daten.sql
--
-- Diese Datei ist WIEDERHOLBAR.
--
-- ---------------------------------------------------------------------
-- MASSSTAB F07 -- und die Arbeitsteilung, die daraus folgt
-- ---------------------------------------------------------------------
-- Ein Prueffall, der an einer FREMDEN Bedingung scheitert, misst nichts.
-- Deshalb:
--
--   * Was diese Datei zu verantworten hat -- Mandanten, Konten,
--     Mitgliedschaften, die vorbereiteten Eignungs-Checks -- wird am Ende
--     geprueft. Stimmt es nicht, BRICHT diese Datei ab.
--
--   * Der Katalog der drei Eignungsfragen (fit_question/fit_option) ist
--     STARTBESTAND DES BAUS. Diese Datei fasst ihn NICHT an. Der Lauf
--     liest ihn und faehrt damit den Weg bis GEEIGNET; gibt der Katalog
--     das nicht her, sperrt der Lauf die betroffenen Faelle.
--
--   * Die Zweckbestimmung selbst -- die beiden Fragen aus K04-M19, die
--     Kenntnisnahme aus K04-M21 -- legt diese Datei NIRGENDS an. Sie ist
--     der Pruefgegenstand. Wo ihr Nachweis getragen wird, ist nach
--     K04-G12 und O-K04-8 offen (eigene Spalte ODER Ereignis nach K02);
--     der Lauf SUCHT ihn an beiden Orten, statt einen davon
--     vorauszusetzen.
--
-- Alle Adressen dieser Datei enden auf @zbpruef.example. Damit stoert sie
-- die Daten der Scheibe 1 (@pruef.example) und die des ersten Teils der
-- Scheibe 2 (@vpruef.example) nicht und wird von ihnen nicht gestoert.
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
--     fb01  Betreiber -- traegt nur den Plattform-Admin
--     fb02  Mandant A -- der Mandant der Sitzung, in dem gemessen wird
--     fb03  Mandant B -- der FREMDE Mandant (K04-D08, F3)
--     fb04  Mandant ausserhalb DE -- fuer die Bedingung legal_space = DE
--           aus K01-M27. Er wird BEHUTSAM angelegt: traegt das Modell
--           ihn nicht, laeuft diese Datei trotzdem durch und der Lauf
--           sperrt allein den Fall, der ihn braucht.
-- ---------------------------------------------------------------------
INSERT INTO tenant (id, kind, name, customer_code, legal_space) VALUES
  ('00000000-0000-4000-8000-00000000fb01','OPERATOR','Pruefbetreiber Zweckbestimmung', NULL,    'DE'),
  ('00000000-0000-4000-8000-00000000fb02','CUSTOMER','Pruefkunde Zweck A',             'DE-ZBA','DE'),
  ('00000000-0000-4000-8000-00000000fb03','CUSTOMER','Pruefkunde Zweck B',             'DE-ZBB','DE')
ON CONFLICT (id) DO NOTHING;

CREATE TABLE IF NOT EXISTS pruef_zweck_herkunft (
  merkmal    text PRIMARY KEY,
  wert       text NOT NULL,
  notiert_am timestamptz NOT NULL DEFAULT now()
);
DELETE FROM pruef_zweck_herkunft;

DO $$
BEGIN
  INSERT INTO tenant (id, kind, name, customer_code, legal_space)
  VALUES ('00000000-0000-4000-8000-00000000fb04','CUSTOMER','Pruefkunde Zweck Ausland','DE-ZBX','EU27_REST')
  ON CONFLICT (id) DO NOTHING;
  INSERT INTO pruef_zweck_herkunft (merkmal, wert) VALUES ('mandant_ausland','JA');
EXCEPTION WHEN others THEN
  INSERT INTO pruef_zweck_herkunft (merkmal, wert)
  VALUES ('mandant_ausland','NEIN: ' || SQLERRM);
END $$;

-- ---------------------------------------------------------------------
-- 3 · Der Plattform-Admin ZUERST
--
--     platform_admin_guard haengt an actor und membership: bleibt kein
--     aktiver EXMA-Admin uebrig, scheitert JEDE spaetere Aenderung an
--     actor. Er ist Aufbau, kein Prueffall.
-- ---------------------------------------------------------------------
INSERT INTO actor (id, tenant_id, email, display_name, mfa_method, status, created_on)
VALUES ('00000000-0000-4000-8000-00000000aa01',
        '00000000-0000-4000-8000-00000000fb01',
        'zb_admin@zbpruef.example', 'Pruef Plattform-Admin Zweck',
        'EMAIL_CODE', 'AKTIV', current_date)
ON CONFLICT (id) DO NOTHING;

INSERT INTO membership (actor_id, portal_code, role_id, tenant_scope)
SELECT '00000000-0000-4000-8000-00000000aa01', 'EXMA', r.id,
       '00000000-0000-4000-8000-00000000fb01'
  FROM role r WHERE r.portal_code = 'EXMA' AND r.name = 'Plattform-Admin'
ON CONFLICT DO NOTHING;

UPDATE actor SET status = 'AKTIV'
 WHERE id = '00000000-0000-4000-8000-00000000aa01' AND status <> 'AKTIV';

-- ---------------------------------------------------------------------
-- 4 · Alten Lauf zuruecksetzen
--
--     Reihenfolge: erst app (fit_check verweist darauf und umgekehrt),
--     dann fit_check (fit_answer haengt mit ON DELETE CASCADE daran).
--     event wird NICHT geleert -- die Tabelle ist append-only
--     (event_no_delete). Der Lauf misst deshalb ueberall die ZUNAHME der
--     Ereignisse, nie ihren Gesamtstand.
-- ---------------------------------------------------------------------
UPDATE fit_check SET app_id = NULL
 WHERE tenant_id IN ('00000000-0000-4000-8000-00000000fb02',
                     '00000000-0000-4000-8000-00000000fb03',
                     '00000000-0000-4000-8000-00000000fb04');

DELETE FROM app
 WHERE tenant_id IN ('00000000-0000-4000-8000-00000000fb02',
                     '00000000-0000-4000-8000-00000000fb03',
                     '00000000-0000-4000-8000-00000000fb04');

DELETE FROM fit_check
 WHERE tenant_id IN ('00000000-0000-4000-8000-00000000fb02',
                     '00000000-0000-4000-8000-00000000fb03',
                     '00000000-0000-4000-8000-00000000fb04');

DELETE FROM login_code
 WHERE actor_id IN (SELECT id FROM actor WHERE email LIKE '%@zbpruef.example');
DELETE FROM auth_session
 WHERE actor_id IN (SELECT id FROM actor WHERE email LIKE '%@zbpruef.example');
DELETE FROM login_attempt
 WHERE email LIKE '%@zbpruef.example';

-- ---------------------------------------------------------------------
-- 5 · Die Konten
--
--     Jedes Konto ist AKTIV und Mitglied im freigeschalteten Portal
--     ENDUSER seines Mandanten -- damit ein Fall NUR an seiner eigenen
--     Regel scheitern kann. Die eine Ausnahme ist zb_gesperrt@; sie
--     traegt GESPERRT mit Absicht und wird in der Aufbaupruefung
--     ausgenommen.
--
--       zb_frei        A · beide Zweckfragen NEIN  -> W6 -> W7
--       zb_anhang      A · Frage 1 JA, Frage 2 NEIN -> W4 -> W5 -> W7
--       zb_verboten    A · Frage 2 JA               -> W3 Halt
--       zb_beide       A · Frage 1 JA UND Frage 2 JA -> Vorrang Frage 2
--       zb_ohne        A · Frage 1 JA, KEINE Kenntnisnahme -> F2
--       zb_halb        A · nur eine Frage beantwortet -> F5
--       zb_wechsel     A · die Eignung wechselt zwischen Anzeige und
--                          Anlage -> F7
--       zb_nachweis    A · der Nachweis laesst sich nicht schreiben -> F4
--       zb_aendern     A · Ausweg 1 aus dem Halt -> W8
--       zb_termin      A · Ausweg 2 aus dem Halt -> W9
--       zb_uebersicht  A · Ausweg 3 aus dem Halt -> W10
--       zb_zweit       A · die zweite Anlage -- fuer "die Nummer wird
--                          vergeben, nicht eingegeben" (K01-M38)
--       zb_fremd       B · das Konto des FREMDEN Mandanten (F3, K04-D08)
--       zb_db          A · traegt die vorbereiteten Checks, an denen die
--                          Faelle gegen die Datenbank laufen
--       zb_gesperrt    A · GESPERRT -- die Bedingung "aktives Konto"
--                          aus K01-M27
-- ---------------------------------------------------------------------
INSERT INTO actor (id, tenant_id, email, display_name, mfa_method, status, created_on) VALUES
  ('00000000-0000-4000-8000-00000000aa02','00000000-0000-4000-8000-00000000fb02','zb_frei@zbpruef.example',      'Pruef Weg frei',        'EMAIL_CODE','AKTIV',current_date),
  ('00000000-0000-4000-8000-00000000aa03','00000000-0000-4000-8000-00000000fb02','zb_anhang@zbpruef.example',    'Pruef Anhang III',      'EMAIL_CODE','AKTIV',current_date),
  ('00000000-0000-4000-8000-00000000aa04','00000000-0000-4000-8000-00000000fb02','zb_verboten@zbpruef.example',  'Pruef verbotene Praktik','EMAIL_CODE','AKTIV',current_date),
  ('00000000-0000-4000-8000-00000000aa05','00000000-0000-4000-8000-00000000fb02','zb_beide@zbpruef.example',     'Pruef beide Treffer',   'EMAIL_CODE','AKTIV',current_date),
  ('00000000-0000-4000-8000-00000000aa06','00000000-0000-4000-8000-00000000fb02','zb_ohne@zbpruef.example',      'Pruef ohne Kenntnisnahme','EMAIL_CODE','AKTIV',current_date),
  ('00000000-0000-4000-8000-00000000aa07','00000000-0000-4000-8000-00000000fb02','zb_halb@zbpruef.example',      'Pruef halbe Antwort',   'EMAIL_CODE','AKTIV',current_date),
  ('00000000-0000-4000-8000-00000000aa08','00000000-0000-4000-8000-00000000fb02','zb_wechsel@zbpruef.example',   'Pruef Eignungswechsel', 'EMAIL_CODE','AKTIV',current_date),
  ('00000000-0000-4000-8000-00000000aa09','00000000-0000-4000-8000-00000000fb02','zb_nachweis@zbpruef.example',  'Pruef Nachweis sperrt', 'EMAIL_CODE','AKTIV',current_date),
  ('00000000-0000-4000-8000-00000000aa10','00000000-0000-4000-8000-00000000fb02','zb_aendern@zbpruef.example',   'Pruef Ausweg aendern',  'EMAIL_CODE','AKTIV',current_date),
  ('00000000-0000-4000-8000-00000000aa11','00000000-0000-4000-8000-00000000fb02','zb_termin@zbpruef.example',    'Pruef Ausweg Termin',   'EMAIL_CODE','AKTIV',current_date),
  ('00000000-0000-4000-8000-00000000aa12','00000000-0000-4000-8000-00000000fb02','zb_uebersicht@zbpruef.example','Pruef Ausweg Uebersicht','EMAIL_CODE','AKTIV',current_date),
  ('00000000-0000-4000-8000-00000000aa13','00000000-0000-4000-8000-00000000fb02','zb_zweit@zbpruef.example',     'Pruef zweite Anlage',   'EMAIL_CODE','AKTIV',current_date),
  ('00000000-0000-4000-8000-00000000aa14','00000000-0000-4000-8000-00000000fb03','zb_fremd@zbpruef.example',     'Pruef fremder Mandant', 'EMAIL_CODE','AKTIV',current_date),
  ('00000000-0000-4000-8000-00000000aa15','00000000-0000-4000-8000-00000000fb02','zb_db@zbpruef.example',        'Pruef Datenbankfaelle', 'EMAIL_CODE','AKTIV',current_date),
  ('00000000-0000-4000-8000-00000000aa16','00000000-0000-4000-8000-00000000fb02','zb_gesperrt@zbpruef.example',  'Pruef gesperrtes Konto','EMAIL_CODE','GESPERRT',current_date)
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
 WHERE a.email LIKE '%@zbpruef.example'
   AND a.email <> 'zb_admin@zbpruef.example'      -- gehoert zu EXMA
ON CONFLICT DO NOTHING;

-- ---------------------------------------------------------------------
-- 6 · Die Ansprechperson
--
--     Ausweg 2 aus dem Halt ist der Termin; die Ansprechperson stammt
--     nach K19 EN-04a aus contact des eigenen Mandanten. Ohne sie
--     scheiterte der Ausweg an einer FREMDEN Bedingung und maesse nichts
--     (F07).
-- ---------------------------------------------------------------------
DO $$
BEGIN
  INSERT INTO contact (tenant_id, vorname, nachname, mail, is_valid, position)
  SELECT '00000000-0000-4000-8000-00000000fb02','Pruef','Ansprechperson',
         'zb_kontakt@zbpruef.example', true, 1
   WHERE NOT EXISTS (SELECT 1 FROM contact
                      WHERE tenant_id='00000000-0000-4000-8000-00000000fb02');
  INSERT INTO pruef_zweck_herkunft (merkmal, wert) VALUES ('ansprechperson','JA');
EXCEPTION WHEN others THEN
  INSERT INTO pruef_zweck_herkunft (merkmal, wert)
  VALUES ('ansprechperson','NEIN: ' || SQLERRM);
END $$;

-- ---------------------------------------------------------------------
-- 7 · Die vorbereiteten Eignungs-Checks fuer die Faelle gegen die
--     Datenbank
--
--     fc01  GEEIGNET im Mandanten A, Konto zb_db -- der Check, an dem
--           der serverseitige Befehl gelingen MUSS (die offene Tuer)
--     fc02  OFFEN im Mandanten A -- die Anlage ohne GEEIGNET (F1)
--     fc03  GEEIGNET im FREMDEN Mandanten B (K04-D08)
--     fc04  GEEIGNET im Mandanten A, Konto zb_gesperrt -- "aktives
--           Konto" aus K01-M27
--     fc05  GEEIGNET im Mandanten ausserhalb DE -- legal_space = DE aus
--           K01-M27; entfaellt, wenn fb04 nicht angelegt werden konnte
--
--     Die Checks tragen KEINE Zweckbestimmung und KEINE Kenntnisnahme.
--     Beides ist Pruefgegenstand und wird hier nicht vorweggenommen.
-- ---------------------------------------------------------------------
INSERT INTO fit_check (id, tenant_id, actor_id, outcome, completed_at, retention_class) VALUES
  ('00000000-0000-4000-8000-00000000fc01','00000000-0000-4000-8000-00000000fb02',
   '00000000-0000-4000-8000-00000000aa15','GEEIGNET', now() - interval '5 minutes','KI_NACHWEIS'),
  ('00000000-0000-4000-8000-00000000fc02','00000000-0000-4000-8000-00000000fb02',
   '00000000-0000-4000-8000-00000000aa15','OFFEN',    NULL,                        'KI_NACHWEIS'),
  ('00000000-0000-4000-8000-00000000fc03','00000000-0000-4000-8000-00000000fb03',
   '00000000-0000-4000-8000-00000000aa14','GEEIGNET', now() - interval '5 minutes','KI_NACHWEIS'),
  ('00000000-0000-4000-8000-00000000fc04','00000000-0000-4000-8000-00000000fb02',
   '00000000-0000-4000-8000-00000000aa16','GEEIGNET', now() - interval '5 minutes','KI_NACHWEIS');

DO $$
BEGIN
  IF EXISTS (SELECT 1 FROM tenant WHERE id='00000000-0000-4000-8000-00000000fb04') THEN
    INSERT INTO fit_check (id, tenant_id, actor_id, outcome, completed_at, retention_class)
    VALUES ('00000000-0000-4000-8000-00000000fc05','00000000-0000-4000-8000-00000000fb04',
            NULL,'GEEIGNET', now() - interval '5 minutes','KI_NACHWEIS');
    INSERT INTO pruef_zweck_herkunft (merkmal, wert) VALUES ('check_ausland','JA');
  ELSE
    INSERT INTO pruef_zweck_herkunft (merkmal, wert) VALUES ('check_ausland','NEIN: kein Mandant ausserhalb DE');
  END IF;
EXCEPTION WHEN others THEN
  INSERT INTO pruef_zweck_herkunft (merkmal, wert)
  VALUES ('check_ausland','NEIN: ' || SQLERRM);
END $$;

-- ---------------------------------------------------------------------
-- 8 · Sichten auf die Lage
--
--     Der Lauf prueft damit den AUFBAU, bevor ein einziger Fall laeuft.
--
--     Bewusst fuehren diese Sichten KEINE Spalte, die eine
--     Zweckbestimmung oder eine Kenntnisnahme vortaeuschen koennte:
--     mehrere Faelle messen, dass beides ERST durch den Bau entsteht.
-- ---------------------------------------------------------------------
CREATE OR REPLACE VIEW pruef_zweck_konten AS
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
 WHERE a.email LIKE '%@zbpruef.example';

CREATE OR REPLACE VIEW pruef_zweck_lage AS
SELECT (SELECT count(*) FROM fit_question)                                    AS fragen,
       (SELECT count(*) FROM fit_option)                                      AS optionen,
       (SELECT count(*) FROM fit_question q
         WHERE EXISTS (SELECT 1 FROM fit_option o
                        WHERE o.question_code = q.code AND o.is_eligible))    AS fragen_mit_zusage,
       (SELECT count(*) FROM app
         WHERE tenant_id IN ('00000000-0000-4000-8000-00000000fb02',
                             '00000000-0000-4000-8000-00000000fb03'))         AS anwendungen,
       (SELECT count(*) FROM information_schema.columns
         WHERE table_name = 'fit_check'
           AND column_name = 'zweckbestimmung_ack_at')                        AS ack_spalte,
       (SELECT wert FROM pruef_zweck_herkunft WHERE merkmal='mandant_ausland')  AS mandant_ausland,
       (SELECT wert FROM pruef_zweck_herkunft WHERE merkmal='check_ausland')    AS check_ausland,
       (SELECT wert FROM pruef_zweck_herkunft WHERE merkmal='ansprechperson')   AS ansprechperson;

-- ---------------------------------------------------------------------
-- 9 · AUFBAUPRUEFUNG (F07)
--
--     Geprueft wird AUSSCHLIESSLICH, was diese Datei zu verantworten
--     hat. Der Fragenkatalog und die Zweckbestimmung stehen bewusst
--     NICHT darunter -- sie sind Pruefgegenstand, nicht Aufbau.
-- ---------------------------------------------------------------------
DO $$
DECLARE r record; fehler text := '';
BEGIN
  -- (a) Jedes Konto ausser dem Admin gehoert in ein freigeschaltetes Portal.
  FOR r IN SELECT * FROM pruef_zweck_konten
            WHERE email <> 'zb_admin@zbpruef.example'
              AND freigeschaltete_portale < 1
  LOOP fehler := fehler || format('%s ohne freigeschaltetes Portal; ', r.email); END LOOP;

  -- (b) Jedes Konto ausser dem einen Sperrfall ist AKTIV.
  FOR r IN SELECT * FROM pruef_zweck_konten
            WHERE email <> 'zb_gesperrt@zbpruef.example' AND status <> 'AKTIV'
  LOOP fehler := fehler || format('%s ist %s statt AKTIV; ', r.email, r.status); END LOOP;
  IF (SELECT status FROM pruef_zweck_konten WHERE email='zb_gesperrt@zbpruef.example')
     <> 'GESPERRT' THEN
    fehler := fehler || 'zb_gesperrt@ ist nicht GESPERRT -- die Bedingung "aktives Konto" waere nicht messbar; ';
  END IF;

  -- (c) Der Mandantenschnitt: zb_fremd@ gehoert zu B, alle anderen Wege zu A.
  IF (SELECT tenant_id FROM pruef_zweck_konten WHERE email='zb_fremd@zbpruef.example')
     <> '00000000-0000-4000-8000-00000000fb03' THEN
    fehler := fehler || 'zb_fremd@ steht nicht im fremden Mandanten B; ';
  END IF;
  FOR r IN SELECT * FROM pruef_zweck_konten
            WHERE email NOT IN ('zb_admin@zbpruef.example','zb_fremd@zbpruef.example')
              AND tenant_id <> '00000000-0000-4000-8000-00000000fb02'
  LOOP fehler := fehler || format('%s steht nicht im Mandanten A; ', r.email); END LOOP;

  -- (d) Die Konten, die den Weg selbst fahren, haben NOCH KEINEN Check --
  --     sonst misst "es entsteht genau ein Check" nichts.
  FOR r IN SELECT * FROM pruef_zweck_konten
            WHERE email IN ('zb_frei@zbpruef.example','zb_anhang@zbpruef.example',
                            'zb_verboten@zbpruef.example','zb_beide@zbpruef.example',
                            'zb_ohne@zbpruef.example','zb_halb@zbpruef.example',
                            'zb_wechsel@zbpruef.example','zb_nachweis@zbpruef.example',
                            'zb_aendern@zbpruef.example','zb_termin@zbpruef.example',
                            'zb_uebersicht@zbpruef.example','zb_zweit@zbpruef.example')
              AND checks <> 0
  LOOP fehler := fehler || format('%s traegt schon %s Checks aus einem frueheren Lauf; ', r.email, r.checks); END LOOP;

  -- (e) Keine offene Sitzung aus einem frueheren Lauf.
  IF EXISTS (SELECT 1 FROM pruef_zweck_konten WHERE offene_sitzungen > 0) THEN
    fehler := fehler || 'es stehen noch offene Sitzungen aus einem frueheren Lauf; ';
  END IF;

  -- (f) Die vorbereiteten Checks stehen so, wie die Faelle sie brauchen.
  IF NOT EXISTS (SELECT 1 FROM fit_check
                  WHERE id='00000000-0000-4000-8000-00000000fc01'
                    AND tenant_id='00000000-0000-4000-8000-00000000fb02'
                    AND actor_id='00000000-0000-4000-8000-00000000aa15'
                    AND outcome='GEEIGNET' AND completed_at IS NOT NULL
                    AND app_id IS NULL) THEN
    fehler := fehler || 'der geeignete Check fc01 fehlt oder traegt schon eine Anwendung; ';
  END IF;
  IF NOT EXISTS (SELECT 1 FROM fit_check
                  WHERE id='00000000-0000-4000-8000-00000000fc02' AND outcome='OFFEN') THEN
    fehler := fehler || 'der offene Check fc02 fehlt; ';
  END IF;
  IF NOT EXISTS (SELECT 1 FROM fit_check
                  WHERE id='00000000-0000-4000-8000-00000000fc03'
                    AND tenant_id='00000000-0000-4000-8000-00000000fb03'
                    AND outcome='GEEIGNET') THEN
    fehler := fehler || 'der geeignete Check des fremden Mandanten fc03 fehlt; ';
  END IF;
  IF NOT EXISTS (SELECT 1 FROM fit_check
                  WHERE id='00000000-0000-4000-8000-00000000fc04'
                    AND actor_id='00000000-0000-4000-8000-00000000aa16'
                    AND outcome='GEEIGNET') THEN
    fehler := fehler || 'der Check am gesperrten Konto fc04 fehlt; ';
  END IF;

  -- (g) Es gibt keine Anwendung in den Pruefmandanten -- fast jeder Fall
  --     misst "es entsteht keine Anwendung" oder "es entsteht genau eine".
  IF EXISTS (SELECT 1 FROM app
              WHERE tenant_id IN ('00000000-0000-4000-8000-00000000fb02',
                                  '00000000-0000-4000-8000-00000000fb03',
                                  '00000000-0000-4000-8000-00000000fb04')) THEN
    fehler := fehler || 'in den Pruefmandanten steht schon eine Anwendung; ';
  END IF;

  -- (h) Kein Konto dieser Datei traegt eine Zweckbestimmung oder eine
  --     Kenntnisnahme aus einem frueheren Lauf. Beides ist
  --     Pruefgegenstand; steht es schon da, misst kein Fall etwas.
  IF EXISTS (SELECT 1 FROM information_schema.columns
              WHERE table_name='fit_check' AND column_name='zweckbestimmung_ack_at') THEN
    IF EXISTS (SELECT 1 FROM fit_check c
                WHERE c.tenant_id IN ('00000000-0000-4000-8000-00000000fb02',
                                      '00000000-0000-4000-8000-00000000fb03')
                  AND c.zweckbestimmung_ack_at IS NOT NULL) THEN
      fehler := fehler || 'ein Check der Pruefmandanten traegt schon eine Kenntnisnahme; ';
    END IF;
  END IF;

  IF fehler <> '' THEN
    RAISE EXCEPTION 'AUFBAU UNBRAUCHBAR (F07): %', fehler;
  END IF;
END $$;

-- ---------------------------------------------------------------------
-- 10 · Was jetzt steht
-- ---------------------------------------------------------------------
SELECT * FROM pruef_zweck_lage;
SELECT email, status, freigeschaltete_portale AS portale, checks
  FROM pruef_zweck_konten ORDER BY email;

\echo 'Pruefdaten stehen. Aufbaupruefung (F07) bestanden.'
\echo 'Die Zweckbestimmung und die Kenntnisnahme legt diese Datei NICHT an --'
\echo 'beides ist Pruefgegenstand. Wo der Nachweis getraegt wird (Spalte oder'
\echo 'Ereignis nach K04-G12), sucht der Lauf an beiden Orten.'
