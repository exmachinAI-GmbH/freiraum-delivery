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
  ('00000000-0000-4000-8000-00000000ea01','OPERATOR','Pruefbetreiber Gespraech',  NULL,     'DE'),
  ('00000000-0000-4000-8000-00000000ea02','CUSTOMER','Pruefkunde Gespraech A',    'DE-GSA', 'DE'),
  ('00000000-0000-4000-8000-00000000ea03','CUSTOMER','Pruefkunde Gespraech B',    'DE-GSB', 'DE')
ON CONFLICT (id) DO NOTHING;

-- ---------------------------------------------------------------------
-- 3 · Der Plattform-Admin ZUERST
--
--     platform_admin_guard haengt an actor und membership: bleibt kein
--     aktiver EXMA-Admin uebrig, scheitert JEDE spaetere Aenderung an
--     actor. Er ist Aufbau, kein Prueffall.
-- ---------------------------------------------------------------------
INSERT INTO actor (id, tenant_id, email, display_name, mfa_method, status, created_on)
VALUES ('00000000-0000-4000-8000-00000000eb00',
        '00000000-0000-4000-8000-00000000ea01',
        'gs_admin@gespraechpruef.example', 'Pruef Plattform-Admin Gespraech',
        'EMAIL_CODE', 'AKTIV', current_date)
ON CONFLICT (id) DO NOTHING;

INSERT INTO membership (actor_id, portal_code, role_id, tenant_scope)
SELECT '00000000-0000-4000-8000-00000000eb00', 'EXMA', r.id,
       '00000000-0000-4000-8000-00000000ea01'
  FROM role r WHERE r.portal_code = 'EXMA' AND r.name = 'Plattform-Admin'
ON CONFLICT DO NOTHING;

UPDATE actor SET status = 'AKTIV'
 WHERE id = '00000000-0000-4000-8000-00000000eb00' AND status <> 'AKTIV';

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
 WHERE tenant_id IN ('00000000-0000-4000-8000-00000000ea02',
                     '00000000-0000-4000-8000-00000000ea03');

DELETE FROM app
 WHERE tenant_id IN ('00000000-0000-4000-8000-00000000ea02',
                     '00000000-0000-4000-8000-00000000ea03');

DELETE FROM fit_check
 WHERE tenant_id IN ('00000000-0000-4000-8000-00000000ea02',
                     '00000000-0000-4000-8000-00000000ea03');

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
  ('00000000-0000-4000-8000-00000000eb01','00000000-0000-4000-8000-00000000ea02','gs_frisch@gespraechpruef.example',       'Pruef Stufe Eins Frisch',    'EMAIL_CODE','AKTIV',current_date),
  ('00000000-0000-4000-8000-00000000eb02','00000000-0000-4000-8000-00000000ea02','gs_zielrang@gespraechpruef.example',     'Pruef Zielrangfolge',        'EMAIL_CODE','AKTIV',current_date),
  ('00000000-0000-4000-8000-00000000eb03','00000000-0000-4000-8000-00000000ea02','gs_namensweg@gespraechpruef.example',    'Pruef Namensschritt',        'EMAIL_CODE','AKTIV',current_date),
  ('00000000-0000-4000-8000-00000000eb04','00000000-0000-4000-8000-00000000ea02','gs_ueberspringen@gespraechpruef.example','Pruef Stufe ueberspringen',  'EMAIL_CODE','AKTIV',current_date),
  ('00000000-0000-4000-8000-00000000eb05','00000000-0000-4000-8000-00000000ea02','gs_unmittelbar@gespraechpruef.example',  'Pruef Unmittelbarer Zugriff','EMAIL_CODE','AKTIV',current_date),
  ('00000000-0000-4000-8000-00000000eb06','00000000-0000-4000-8000-00000000ea02','gs_isoliert@gespraechpruef.example',     'Pruef Isolationskontrolle',  'EMAIL_CODE','AKTIV',current_date),
  ('00000000-0000-4000-8000-00000000eb07','00000000-0000-4000-8000-00000000ea02','gs_interview@gespraechpruef.example',    'Pruef Stufe Zwei',           'EMAIL_CODE','AKTIV',current_date),
  ('00000000-0000-4000-8000-00000000eb08','00000000-0000-4000-8000-00000000ea02','gs_interview2@gespraechpruef.example',   'Pruef Stufe Zwei Zweitlauf', 'EMAIL_CODE','AKTIV',current_date),
  ('00000000-0000-4000-8000-00000000eb09','00000000-0000-4000-8000-00000000ea02','gs_fertig@gespraechpruef.example',       'Pruef Interview Fertig',     'EMAIL_CODE','AKTIV',current_date),
  ('00000000-0000-4000-8000-00000000eb0a','00000000-0000-4000-8000-00000000ea02','gs_gleich1@gespraechpruef.example',      'Pruef Gleicher Anzeigename', 'EMAIL_CODE','AKTIV',current_date),
  ('00000000-0000-4000-8000-00000000eb0b','00000000-0000-4000-8000-00000000ea02','gs_gleich2@gespraechpruef.example',      'Pruef Gleicher Anzeigename', 'EMAIL_CODE','AKTIV',current_date),
  ('00000000-0000-4000-8000-00000000eb0c','00000000-0000-4000-8000-00000000ea02','gs_offen@gespraechpruef.example',        'Pruef Check Offen',          'EMAIL_CODE','AKTIV',current_date),
  ('00000000-0000-4000-8000-00000000eb0d','00000000-0000-4000-8000-00000000ea02','gs_ohnecheck@gespraechpruef.example',    'Pruef Ohne Check',           'EMAIL_CODE','AKTIV',current_date),
  ('00000000-0000-4000-8000-00000000eb0e','00000000-0000-4000-8000-00000000ea02','gs_gesperrt@gespraechpruef.example',     'Pruef Gesperrtes Konto',     'EMAIL_CODE','GESPERRT',current_date),
  ('00000000-0000-4000-8000-00000000eb0f','00000000-0000-4000-8000-00000000ea03','gs_fremd@gespraechpruef.example',        'Pruef Fremder Mandant',      'EMAIL_CODE','AKTIV',current_date)
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
-- 6 · Die vorbereiteten Eignungs-Checks (fit_check) -- ZUERST, noch
--     OHNE app_id
--
--     EIGNUNGSRIEGEL weist jede INSERT INTO app ab, der nicht schon
--     beim Einfuegen ueber app.fit_check_id auf einen bestandenen
--     (GEEIGNET-)Check zeigt -- beobachtetes Verhalten des laufenden
--     Baus, kein Zitat aus einer gezeichneten Klausel: K01-G05
--     (nachweise/klauselregister/register.json) haelt dazu nur GILT-
--     Hintergrund fest ("`fit_check_id` ist im DDL wegen der
--     beidseitigen Verknuepfung technisch nullbar"), ohne eigenes
--     Akzeptanzkriterium; K01-M26/K01-M27 (register.md :136/:139)
--     stehen als ⟨VORSCHLAG · NICHT GEZEICHNET⟩ -- keine der 101
--     Klauseln dieses Laufs (nachweise/klauselregister/
--     M5_klausellage_260819.json). Beide werden hier NUR als
--     Hintergrund zitiert, nie als getesteter Massstab. Die
--     Verknuepfung laeuft in BEIDE Richtungen
--     (fit_check.app_id <-> app.fit_check_id); zum Zeitpunkt DIESES
--     Inserts gibt es noch keine app-Zeile, also bleibt app_id hier
--     NULL -- Abschnitt 7 setzt beim Anlegen der app-Zeile
--     fit_check_id, Abschnitt 7b schliesst danach app_id rueckwaerts.
--
--     Jede Anwendung aus Abschn. 7 (ausser den beiden ohne app-Zeile,
--     gs_offen@ und gs_ohnecheck@) traegt genau EINEN GEEIGNET-Check --
--     so, wie ein Konto nach M4 dort ankaeme. gs_offen@ traegt einen
--     Check mit OFFEN und OHNE app-Zeile; gs_ohnecheck@ traegt gar
--     keinen.
-- ---------------------------------------------------------------------
INSERT INTO fit_check (id, tenant_id, actor_id, app_id, outcome, completed_at, retention_class) VALUES
  ('00000000-0000-4000-8000-00000000ec01','00000000-0000-4000-8000-00000000ea02','00000000-0000-4000-8000-00000000eb01', NULL,'GEEIGNET', now() - interval '5 minutes','KI_NACHWEIS'),
  ('00000000-0000-4000-8000-00000000ec02','00000000-0000-4000-8000-00000000ea02','00000000-0000-4000-8000-00000000eb02', NULL,'GEEIGNET', now() - interval '5 minutes','KI_NACHWEIS'),
  ('00000000-0000-4000-8000-00000000ec03','00000000-0000-4000-8000-00000000ea02','00000000-0000-4000-8000-00000000eb03', NULL,'GEEIGNET', now() - interval '5 minutes','KI_NACHWEIS'),
  ('00000000-0000-4000-8000-00000000ec04','00000000-0000-4000-8000-00000000ea02','00000000-0000-4000-8000-00000000eb04', NULL,'GEEIGNET', now() - interval '5 minutes','KI_NACHWEIS'),
  ('00000000-0000-4000-8000-00000000ec05','00000000-0000-4000-8000-00000000ea02','00000000-0000-4000-8000-00000000eb05', NULL,'GEEIGNET', now() - interval '5 minutes','KI_NACHWEIS'),
  ('00000000-0000-4000-8000-00000000ec06','00000000-0000-4000-8000-00000000ea02','00000000-0000-4000-8000-00000000eb06', NULL,'GEEIGNET', now() - interval '5 minutes','KI_NACHWEIS'),
  ('00000000-0000-4000-8000-00000000ec07','00000000-0000-4000-8000-00000000ea02','00000000-0000-4000-8000-00000000eb07', NULL,'GEEIGNET', now() - interval '20 minutes','KI_NACHWEIS'),
  ('00000000-0000-4000-8000-00000000ec08','00000000-0000-4000-8000-00000000ea02','00000000-0000-4000-8000-00000000eb08', NULL,'GEEIGNET', now() - interval '20 minutes','KI_NACHWEIS'),
  ('00000000-0000-4000-8000-00000000ec09','00000000-0000-4000-8000-00000000ea02','00000000-0000-4000-8000-00000000eb09', NULL,'GEEIGNET', now() - interval '30 minutes','KI_NACHWEIS'),
  ('00000000-0000-4000-8000-00000000ec0a','00000000-0000-4000-8000-00000000ea02','00000000-0000-4000-8000-00000000eb0a', NULL,'GEEIGNET', now() - interval '20 minutes','KI_NACHWEIS'),
  ('00000000-0000-4000-8000-00000000ec0b','00000000-0000-4000-8000-00000000ea02','00000000-0000-4000-8000-00000000eb0b', NULL,'GEEIGNET', now() - interval '20 minutes','KI_NACHWEIS'),
  ('00000000-0000-4000-8000-00000000ec0e','00000000-0000-4000-8000-00000000ea02','00000000-0000-4000-8000-00000000eb0e', NULL,'GEEIGNET', now() - interval '5 minutes','KI_NACHWEIS'),
  ('00000000-0000-4000-8000-00000000ec0f','00000000-0000-4000-8000-00000000ea03','00000000-0000-4000-8000-00000000eb0f', NULL,'GEEIGNET', now() - interval '20 minutes','KI_NACHWEIS')
ON CONFLICT (id) DO NOTHING;

-- gs_offen@: OFFEN, KEINE app-Zeile (K04-M11 Vorgabewert; K04-G04
-- Negativfall). Ohne GEEIGNET beruehrt sie den EIGNUNGSRIEGEL nicht.
INSERT INTO fit_check (id, tenant_id, actor_id, app_id, outcome, completed_at, retention_class)
VALUES ('00000000-0000-4000-8000-00000000ec0c','00000000-0000-4000-8000-00000000ea02',
        '00000000-0000-4000-8000-00000000eb0c', NULL, 'OFFEN', NULL, 'KI_NACHWEIS')
ON CONFLICT (id) DO NOTHING;
-- gs_ohnecheck@ traegt bewusst KEINEN fit_check -- kein INSERT.

-- ---------------------------------------------------------------------
-- 7 · Die Anwendungen (app) -- ausschliesslich die AUSGANGSLAGE:
--     journey_phase, lifecycle_state, ggf. bereits gesetzter Name, und
--     fit_check_id auf den in Abschn. 6 schon vorhandenen GEEIGNET-
--     Check (das erfuellt den EIGNUNGSRIEGEL beim Einfuegen).
--     KEIN Beitrag, KEINE Herkunftsmarke, KEIN document, KEIN Uebersprung-
--     vermerk -- das ist der Pruefgegenstand von gespraech_lauf.sh
--     selbst (Abschn. "MASSSTAB F07" oben).
--
--     project_no ist NOT NULL in app und wird hier je Zeile mit einem
--     synthetischen, mandantengebundenen Wert belegt -- reine
--     Infrastruktur wie die id-Spalte, KEIN gepruefter Wert: keine der
--     101 Klauseln dieses Laufs stellt eine Anforderung an project_no,
--     also misst kein Testfall in gespraech_lauf.sh diese Spalte. Das
--     Muster `DE-XXX_NNN_NN` steht nur im ungezeichneten Vorschlag
--     K01-M26 (register.md :136); es wird hier NICHT als getesteter
--     Massstab behauptet, nur als plausible, eindeutige Schreibweise
--     uebernommen, damit die Ausgangslage lesbar bleibt und nicht mit
--     project_no einer anderen Pruefscheibe kollidiert. Siehe die
--     Abwaegung "Ausgangslage von Hand vs. durch die Tuer" in
--     gespraech_deckung.md Abschn. 5.
--
--     created_at ist ebenfalls NOT NULL in app (Rueckmeldung der
--     Datenbank auf einen eigenen Probelauf, kein Zitat aus schema/)
--     und wird hier je Zeile mit now() belegt -- dieselbe Rolle wie
--     project_no: reine Infrastruktur, keine der 101 Klauseln stellt
--     eine Anforderung an den Erstellungszeitpunkt, kein Testfall in
--     gespraech_lauf.sh liest die Spalte.
--
--     name traegt bei den sieben Anwendungen in Stufe ORIENTIERUNG
--     (ed01-ed06, ed0e) NICHT NULL, sondern den Platzhalter
--     '(Ausgangslage: Name noch nicht gesetzt)' -- ebenfalls Antwort der
--     Datenbank auf einen eigenen Probelauf: die Spalte ist NOT NULL.
--     Entscheidung dazu (Fall 1 von zwei moeglichen, siehe
--     gespraech_deckung.md Abschn. 5): KEIN WIDERSPRUCH zu K05-D06/
--     K05-M07/K05-G06 ("kein Name ist gesetzt" vor der Bestaetigung in
--     Stufe 01) -- diese Klauseln beschreiben den fachlichen Zustand
--     "kein bestaetigter Name", nicht die Nullbarkeit der Spalte; keine
--     der 101 Klauseln behauptet, die Spalte selbst muesse NULL sein.
--     Der Platzhalter ist bewusst NICHT leer und sieht bewusst NICHT
--     wie ein echter Anwendungsname aus, damit er in keiner Anzeige mit
--     einem echten oder KI-vorgeschlagenen Namen verwechselbar ist. Der
--     einzige Testfall, der zuvor NULL/leer voraussetzte
--     (K05-M07-negativ in gespraech_lauf.sh), ist entsprechend
--     angepasst: er vergleicht jetzt den vollen Vorher-Zustand
--     (journey_phase UND name) gegen den vollen Nachher-Zustand, statt
--     Leere anzunehmen -- dieselbe fachliche Aussage ("eine leere
--     Namenseingabe aendert den Zustand nicht"), nur ohne die jetzt
--     falsche Annahme.
-- ---------------------------------------------------------------------
INSERT INTO app (id, tenant_id, name, project_no, journey_phase, lifecycle_state, fit_check_id, created_at) VALUES
  ('00000000-0000-4000-8000-00000000ed01','00000000-0000-4000-8000-00000000ea02', '(Ausgangslage: Name noch nicht gesetzt)','DE-GSA_001_01','ORIENTIERUNG','DISCOVERY','00000000-0000-4000-8000-00000000ec01', now()),
  ('00000000-0000-4000-8000-00000000ed02','00000000-0000-4000-8000-00000000ea02', '(Ausgangslage: Name noch nicht gesetzt)','DE-GSA_002_01','ORIENTIERUNG','DISCOVERY','00000000-0000-4000-8000-00000000ec02', now()),
  ('00000000-0000-4000-8000-00000000ed03','00000000-0000-4000-8000-00000000ea02', '(Ausgangslage: Name noch nicht gesetzt)','DE-GSA_003_01','ORIENTIERUNG','DISCOVERY','00000000-0000-4000-8000-00000000ec03', now()),
  ('00000000-0000-4000-8000-00000000ed04','00000000-0000-4000-8000-00000000ea02', '(Ausgangslage: Name noch nicht gesetzt)','DE-GSA_004_01','ORIENTIERUNG','DISCOVERY','00000000-0000-4000-8000-00000000ec04', now()),
  ('00000000-0000-4000-8000-00000000ed05','00000000-0000-4000-8000-00000000ea02', '(Ausgangslage: Name noch nicht gesetzt)','DE-GSA_005_01','ORIENTIERUNG','DISCOVERY','00000000-0000-4000-8000-00000000ec05', now()),
  ('00000000-0000-4000-8000-00000000ed06','00000000-0000-4000-8000-00000000ea02', '(Ausgangslage: Name noch nicht gesetzt)','DE-GSA_006_01','ORIENTIERUNG','DISCOVERY','00000000-0000-4000-8000-00000000ec06', now()),
  ('00000000-0000-4000-8000-00000000ed07','00000000-0000-4000-8000-00000000ea02','Pruefanwendung Stufe Zwei',       'DE-GSA_007_01','INTERVIEW',   'DISCOVERY','00000000-0000-4000-8000-00000000ec07', now()),
  ('00000000-0000-4000-8000-00000000ed08','00000000-0000-4000-8000-00000000ea02','Pruefanwendung Stufe Zwei Zweit', 'DE-GSA_008_01','INTERVIEW',   'DISCOVERY','00000000-0000-4000-8000-00000000ec08', now()),
  ('00000000-0000-4000-8000-00000000ed09','00000000-0000-4000-8000-00000000ea02','Pruefanwendung Fertig',           'DE-GSA_009_01','UEBERSICHT',  'DISCOVERY','00000000-0000-4000-8000-00000000ec09', now()),
  ('00000000-0000-4000-8000-00000000ed0a','00000000-0000-4000-8000-00000000ea02','Pruefanwendung Gleich Eins',      'DE-GSA_010_01','INTERVIEW',   'DISCOVERY','00000000-0000-4000-8000-00000000ec0a', now()),
  ('00000000-0000-4000-8000-00000000ed0b','00000000-0000-4000-8000-00000000ea02','Pruefanwendung Gleich Zwei',      'DE-GSA_011_01','INTERVIEW',   'DISCOVERY','00000000-0000-4000-8000-00000000ec0b', now()),
  ('00000000-0000-4000-8000-00000000ed0c','00000000-0000-4000-8000-00000000ea03','Pruefanwendung Fremd',            'DE-GSB_001_01','INTERVIEW',   'DISCOVERY','00000000-0000-4000-8000-00000000ec0f', now())
ON CONFLICT (id) DO NOTHING;

-- gs_gesperrt@ braucht eine EIGENE app-Zeile (nicht ed01, die gehoert
-- gs_frisch@) -- sonst maesse K03-D01 an einer app, die ein anderer
-- Testfall gerade veraendert (F07, Abschn. "PROBE VERUNREINIGT NICHT").
-- Ihr Check ec0e steht seit Abschn. 6 bereit; fit_check_id zeigt gleich
-- beim Einfuegen auf ihn.
INSERT INTO app (id, tenant_id, name, project_no, journey_phase, lifecycle_state, fit_check_id, created_at) VALUES
  ('00000000-0000-4000-8000-00000000ed0e','00000000-0000-4000-8000-00000000ea02', '(Ausgangslage: Name noch nicht gesetzt)', 'DE-GSA_012_01', 'ORIENTIERUNG','DISCOVERY','00000000-0000-4000-8000-00000000ec0e', now())
ON CONFLICT (id) DO NOTHING;

-- ---------------------------------------------------------------------
-- 7b · Rueckverknuepfung fit_check.app_id (schliesst die beidseitige
--      Verknuepfung aus Abschn. 6/7 -- vor Abschn. 8 zeigt jeder
--      GEEIGNET-Check wieder auf seine app-Zeile, wie es Abschn. 7's
--      Kommentar und die Aufbaupruefung in Abschn. 10(f)/(i) voraussetzen).
-- ---------------------------------------------------------------------
UPDATE fit_check SET app_id = a.id
  FROM app a
 WHERE a.fit_check_id = fit_check.id
   AND fit_check.id IN (
     '00000000-0000-4000-8000-00000000ec01','00000000-0000-4000-8000-00000000ec02',
     '00000000-0000-4000-8000-00000000ec03','00000000-0000-4000-8000-00000000ec04',
     '00000000-0000-4000-8000-00000000ec05','00000000-0000-4000-8000-00000000ec06',
     '00000000-0000-4000-8000-00000000ec07','00000000-0000-4000-8000-00000000ec08',
     '00000000-0000-4000-8000-00000000ec09','00000000-0000-4000-8000-00000000ec0a',
     '00000000-0000-4000-8000-00000000ec0b','00000000-0000-4000-8000-00000000ec0e',
     '00000000-0000-4000-8000-00000000ec0f');

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
  VALUES ('00000000-0000-4000-8000-00000000ee01','Pruef-Moderator Gespraech');
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
     <> '00000000-0000-4000-8000-00000000ea03' THEN
    fehler := fehler || 'gs_fremd@ steht nicht im fremden Mandanten B; ';
  END IF;
  FOR r IN SELECT * FROM pruef_gespraech_konten
            WHERE email NOT IN ('gs_admin@gespraechpruef.example','gs_fremd@gespraechpruef.example')
              AND tenant_id <> '00000000-0000-4000-8000-00000000ea02'
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

  -- (j) Die Grundzahlen selbst -- nicht nur Eigenschaften VORHANDENER
  --     Zeilen, sondern ob ueberhaupt die erwartete ANZAHL an Konten,
  --     Mitgliedschaften, Eignungs-Checks und Anwendungen steht. Ohne
  --     diese Zaehlung wuerden (a)-(i) oben eine LEERE Ausgangslage
  --     (z. B. weil ein INSERT INTO app zuvor an einem NOT-NULL-Feld
  --     gescheitert ist) stillschweigend BESTEHEN lassen -- ihre
  --     FOR-Schleifen pruefen nur Zeilen, die DA SIND, nie ob genug
  --     Zeilen da sind. Befund vom 20.08.2026: bei einem Lauf ohne
  --     Abbruch beim ersten Fehler standen 0 app-Zeilen, waehrend diese
  --     Aufbaupruefung nicht anschlug -- "ein Lauf, der besteht und
  --     nichts misst" (derselbe Fehler wie am 02.08.2026, offener Punkt
  --     O-K23-7). Die vier Zahlen sind aus den INSERT-Bloecken dieser
  --     Datei abgezaehlt (Abschn. 3-7b) und aendern sich nur, wenn diese
  --     Datei selbst geaendert wird.
  DECLARE
    n_actor      int;
    n_membership int;
    n_fitcheck   int;
    n_app        int;
  BEGIN
    SELECT count(*) INTO n_actor FROM actor WHERE email LIKE '%@gespraechpruef.example';
    IF n_actor <> 16 THEN
      fehler := fehler || format('es stehen %s Konten statt der erwarteten 16; ', n_actor);
    END IF;

    SELECT count(*) INTO n_membership FROM membership m
      JOIN actor a ON a.id = m.actor_id
     WHERE a.email LIKE '%@gespraechpruef.example';
    IF n_membership <> 16 THEN
      fehler := fehler || format('es stehen %s Mitgliedschaften statt der erwarteten 16; ', n_membership);
    END IF;

    SELECT count(*) INTO n_fitcheck FROM fit_check fc
      JOIN actor a ON a.id = fc.actor_id
     WHERE a.email LIKE '%@gespraechpruef.example';
    IF n_fitcheck <> 14 THEN
      fehler := fehler || format('es stehen %s Eignungs-Checks statt der erwarteten 14; ', n_fitcheck);
    END IF;

    SELECT count(*) INTO n_app FROM app
     WHERE tenant_id IN ('00000000-0000-4000-8000-00000000ea02',
                         '00000000-0000-4000-8000-00000000ea03');
    IF n_app <> 13 THEN
      fehler := fehler || format('es stehen %s Anwendungen statt der erwarteten 13; ', n_app);
    END IF;
  END;

  IF fehler <> '' THEN
    RAISE EXCEPTION 'ABBRUCH: AUFBAU UNBRAUCHBAR (F07) -- %', fehler;
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
