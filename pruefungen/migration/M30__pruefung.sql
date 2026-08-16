-- =====================================================================
-- FREIRAUM - Pruefung der Sammelmigration v3.0-pilot  (Stufe 8)
--
-- Laeuft NACH M30__pilot_sammelmigration.sql auf derselben frischen
-- Datenbank. Alles in einer Transaktion mit ROLLBACK am Ende — der
-- Testlauf hinterlaesst nichts.
--
-- MASSSTAB (F07 / H06): Ein Gegentest ist nur bestanden, wenn er an der
-- VORGESEHENEN Regel gescheitert ist. Jeder Gegentest prueft deshalb die
-- Fehlermeldung auf die erwartete Kennung und protokolliert die
-- TATSAECHLICHE Meldung. Ein Scheitern aus anderem Grund = NICHT bestanden.
--
-- ERGEBNIS: eine NOTICE je Test (MT-xx BESTANDEN/GESCHEITERT + Meldung)
-- und am Ende eine Summenzeile. Erwartung: 0 GESCHEITERT.
--
-- NICHT HIER: der Idempotenz-Nachweis der Migration selbst (Nr. 26).
-- Der laeuft als eigener Schritt: Migration ZWEIMAL ausfuehren, nach dem
-- zweiten Lauf muss pg_dump --schema-only identisch sein (siehe README).
-- =====================================================================
BEGIN;

CREATE TEMP TABLE mt (nr text, name text, ok boolean, meldung text) ON COMMIT DROP;

-- ---------------------------------------------------------------------
-- Ausgangslage (Muster: pruefung_v2.9.sql): Betreiber, aktiver
-- Plattform-Admin, Kunde Demobank, zweiter Admin fuer Vier-Augen.
-- ---------------------------------------------------------------------
INSERT INTO tenant(id,kind,name,legal_space,invite_domain)
VALUES ('00000000-0000-0000-0000-000000000001','OPERATOR','exmachinAI','DE','exmachinai.com');
INSERT INTO tenant(id,kind,name,customer_code,legal_space,invite_domain)
VALUES ('00000000-0000-0000-0000-000000000002','CUSTOMER','Demobank','DE-DMB','DE','demobank.de');

INSERT INTO actor(id,tenant_id,email,display_name,status)
VALUES ('00000000-0000-0000-0000-0000000000a1','00000000-0000-0000-0000-000000000001',
        'admin@exmachinai.com','Erst-Admin','AKTIV');
INSERT INTO actor(id,tenant_id,email,display_name,status)
VALUES ('00000000-0000-0000-0000-0000000000a2','00000000-0000-0000-0000-000000000001',
        'zweit@exmachinai.com','Zweit-Admin','AKTIV');
INSERT INTO actor(id,tenant_id,email,display_name,status)
VALUES ('00000000-0000-0000-0000-0000000000a3','00000000-0000-0000-0000-000000000002',
        'manfred.mueller@demobank.de','Manfred Mueller','AKTIV');

INSERT INTO membership(actor_id,portal_code,role_id,tenant_scope)
SELECT '00000000-0000-0000-0000-0000000000a1','EXMA',r.id,'00000000-0000-0000-0000-000000000001'
  FROM role r WHERE r.portal_code='EXMA';
INSERT INTO membership(actor_id,portal_code,role_id,tenant_scope)
SELECT '00000000-0000-0000-0000-0000000000a2','EXMA',r.id,'00000000-0000-0000-0000-000000000001'
  FROM role r WHERE r.portal_code='EXMA';

-- =====================================================================
-- STUFE-1-NACHWEIS
-- =====================================================================
DO $$ BEGIN
  INSERT INTO mt SELECT 'MT-01','Versionseintrag vorhanden (Nr. 26)',
    EXISTS (SELECT 1 FROM schema_migration WHERE version='v3.0-pilot-01'),
    'schema_migration fuehrt v3.0-pilot-01';
END $$;

-- =====================================================================
-- ZUSTANDSMASCHINE (Nr. 46 · 53 / H02)  — Positiv und N01..N13
-- =====================================================================
-- V1/A (gez. 5.8.2026): Eine Anwendung entsteht nur zu einem bestandenen
-- Eignungs-Check. Bis dahin legte diese Datei zwei Projektzeilen ohne jeden
-- Eignungsnachweis an -- das Wort fit_check_id kam darin kein einziges Mal
-- vor. Genau davor hat die Vorentscheidung V1 gewarnt; hier ist die Folge.
INSERT INTO fit_check(id,tenant_id,actor_id,outcome,completed_at)
VALUES ('00000000-0000-0000-0000-0000000000e1','00000000-0000-0000-0000-000000000002',
        '00000000-0000-0000-0000-0000000000a3','GEEIGNET',now());
INSERT INTO fit_check(id,tenant_id,actor_id,outcome,completed_at)
VALUES ('00000000-0000-0000-0000-0000000000e2','00000000-0000-0000-0000-000000000002',
        '00000000-0000-0000-0000-0000000000a3','GEEIGNET',now());
-- Ein OFFENER Check fuer den Gegentest weiter unten.
INSERT INTO fit_check(id,tenant_id,actor_id,outcome)
VALUES ('00000000-0000-0000-0000-0000000000e9','00000000-0000-0000-0000-000000000002',
        '00000000-0000-0000-0000-0000000000a3','OFFEN');

-- Positiv: Anlegen -> DISCOVERY erzeugt zwangslaeufig die Verlaufszeile.
INSERT INTO app(id,tenant_id,project_no,name,created_at,fit_check_id)
VALUES ('00000000-0000-0000-0000-0000000000f1','00000000-0000-0000-0000-000000000002',
        'DE-DMB_001_01','Pilotprojekt',current_date,
        '00000000-0000-0000-0000-0000000000e1');

-- Die Herrichtung traegt project_no='DE-DMB_001_01' HIER fest ein --
-- an der Zeile vorbei, die K01-M38 dem serverseitigen Befehl vorbehaelt
-- ("sie wird vergeben, nicht eingegeben"). Ohne diese Zeile bliebe der
-- Zaehler bei 1 stehen, und MT-95/MT-95b (Stufe 14, unten) zoegen beim
-- ersten Aufruf von create_app_after_fit dieselbe Nummer 001 und
-- scheiterten an der Eindeutigkeitsbedingung -- einer FREMDEN Bedingung,
-- nicht an dem, was sie messen sollen (Massstab F07/H06). Der Zaehler
-- wird deshalb auf den naechsten freien Wert vorgezogen. Die uebrigen
-- mit fester Nummer eingetragenen Zeilen (Zeile ~86 '_009_01', ~97
-- '_010_01', ~119 '_002_01') sind Gegentests, die alle an einer
-- EXCEPTION scheitern und daher nie committen -- sie belegen keine
-- Nummer und brauchen keine weitere Zaehlerkorrektur.
UPDATE nummernvorrat SET naechste_nummer = 2 WHERE praefix = 'PROJ';

-- Gegentest O-K01-6: ohne Eignungsnachweis entsteht keine Zeile.
DO $$ BEGIN
  INSERT INTO app(tenant_id,project_no,name,created_at)
  VALUES ('00000000-0000-0000-0000-000000000002','DE-DMB_009_01','Ohne Eignung',current_date);
  INSERT INTO mt VALUES ('MT-57','Anwendung ohne Eignungsnachweis scheitert (O-K01-6)',false,
    'FEHLER: wurde angenommen');
EXCEPTION WHEN others THEN
  INSERT INTO mt VALUES ('MT-57','Anwendung ohne Eignungsnachweis scheitert (O-K01-6)',
    SQLERRM LIKE '%EIGNUNGSRIEGEL%', 'Meldung: '||SQLERRM);
END $$;

-- Gegentest O-K01-6: ein NICHT bestandener Check reicht nicht.
DO $$ BEGIN
  INSERT INTO app(tenant_id,project_no,name,created_at,fit_check_id)
  VALUES ('00000000-0000-0000-0000-000000000002','DE-DMB_010_01','Offener Check',current_date,
          '00000000-0000-0000-0000-0000000000e9');
  INSERT INTO mt VALUES ('MT-58','Offener Eignungs-Check reicht nicht (O-K01-6)',false,
    'FEHLER: wurde angenommen');
EXCEPTION WHEN others THEN
  INSERT INTO mt VALUES ('MT-58','Offener Eignungs-Check reicht nicht (O-K01-6)',
    SQLERRM LIKE '%steht nicht auf GEEIGNET%', 'Meldung: '||SQLERRM);
END $$;

DO $$ BEGIN
  INSERT INTO mt SELECT 'MT-02','Anlegen schreibt Verlaufszeile (Nr. 46)',
    EXISTS (SELECT 1 FROM app_state_history
             WHERE app_id='00000000-0000-0000-0000-0000000000f1'
               AND state='DISCOVERY' AND upper_inf(gueltig)),
    'app_state_history traegt die offene DISCOVERY-Zeile';
END $$;

-- Gegentest W01/H02: Anlegen ausserhalb DISCOVERY scheitert an der Anlegeregel.
DO $$ BEGIN
  -- Mit gueltigem Eignungsnachweis, damit der Fall an der ANLEGEREGEL
  -- scheitert und nicht am Eignungsriegel (Massstab F07).
  INSERT INTO app(tenant_id,project_no,name,created_at,lifecycle_state,fit_check_id)
  VALUES ('00000000-0000-0000-0000-000000000002','DE-DMB_002_01','Falschstart',current_date,
          'EINGELADEN','00000000-0000-0000-0000-0000000000e2');
  INSERT INTO mt VALUES ('MT-03','Anlegen auf EINGELADEN scheitert (H02/W01)',false,'FEHLER: wurde angenommen');
EXCEPTION WHEN others THEN
  INSERT INTO mt VALUES ('MT-03','Anlegen auf EINGELADEN scheitert (H02/W01)',
    SQLERRM LIKE '%entsteht auf DISCOVERY%', 'Meldung: '||SQLERRM);
END $$;

-- N01: Discovery -> Beauftragt (Vertrag ohne Interview) scheitert an der Uebergangstabelle.
DO $$ BEGIN
  UPDATE app SET lifecycle_state='BEAUFTRAGT' WHERE id='00000000-0000-0000-0000-0000000000f1';
  INSERT INTO mt VALUES ('MT-04','N01 Discovery->Beauftragt scheitert',false,'FEHLER: wurde angenommen');
EXCEPTION WHEN others THEN
  INSERT INTO mt VALUES ('MT-04','N01 Discovery->Beauftragt scheitert',
    SQLERRM LIKE '%nicht erlaubt%Uebergangstabelle%' OR SQLERRM LIKE '%nicht erlaubt (Uebergangstabelle%',
    'Meldung: '||SQLERRM);
END $$;

-- N03: Sprung Discovery -> In Prod scheitert an der Uebergangstabelle.
DO $$ BEGIN
  UPDATE app SET lifecycle_state='IN_PROD' WHERE id='00000000-0000-0000-0000-0000000000f1';
  INSERT INTO mt VALUES ('MT-05','N03 Discovery->In Prod scheitert',false,'FEHLER: wurde angenommen');
EXCEPTION WHEN others THEN
  INSERT INTO mt VALUES ('MT-05','N03 Discovery->In Prod scheitert',
    SQLERRM LIKE '%nicht erlaubt%', 'Meldung: '||SQLERRM);
END $$;

-- Positiv W02: Discovery -> In Bearbeitung.
UPDATE app SET lifecycle_state='IN_BEARBEITUNG' WHERE id='00000000-0000-0000-0000-0000000000f1';

-- N04: Rueckweg nach EINGELADEN scheitert.
DO $$ BEGIN
  UPDATE app SET lifecycle_state='EINGELADEN' WHERE id='00000000-0000-0000-0000-0000000000f1';
  INSERT INTO mt VALUES ('MT-06','N04 Rueckweg nach EINGELADEN scheitert',false,'FEHLER: wurde angenommen');
EXCEPTION WHEN others THEN
  INSERT INTO mt VALUES ('MT-06','N04 Rueckweg nach EINGELADEN scheitert',
    SQLERRM LIKE '%nicht erlaubt%', 'Meldung: '||SQLERRM);
END $$;

-- N06: In Bearbeitung -> Beauftragt ohne Festschreibung scheitert an sealed_at.
DO $$ BEGIN
  UPDATE app SET lifecycle_state='BEAUFTRAGT' WHERE id='00000000-0000-0000-0000-0000000000f1';
  INSERT INTO mt VALUES ('MT-07','N06 Beauftragt ohne Festschreibung scheitert',false,'FEHLER: wurde angenommen');
EXCEPTION WHEN others THEN
  INSERT INTO mt VALUES ('MT-07','N06 Beauftragt ohne Festschreibung scheitert',
    SQLERRM LIKE '%festgeschriebenes Projekt%', 'Meldung: '||SQLERRM);
END $$;

-- N05: festgeschrieben, aber ohne Zwei-Personen-Freigabe -> scheitert an der Freigabekopplung.
UPDATE app SET sealed_at=now() WHERE id='00000000-0000-0000-0000-0000000000f1';
DO $$ BEGIN
  UPDATE app SET lifecycle_state='BEAUFTRAGT' WHERE id='00000000-0000-0000-0000-0000000000f1';
  INSERT INTO mt VALUES ('MT-08','N05 Beauftragt ohne Freigabe scheitert an der Kopplung',false,'FEHLER: wurde angenommen');
EXCEPTION WHEN others THEN
  INSERT INTO mt VALUES ('MT-08','N05 Beauftragt ohne Freigabe scheitert an der Kopplung',
    SQLERRM LIKE '%Zwei-Personen-Freigabe%', 'Meldung: '||SQLERRM);
END $$;

-- Selbstfreigabe scheitert an sod_editor_ne_approver (Nr. 32).
DO $$ BEGIN
  INSERT INTO approval(object_ref,editor_actor_id,approver_actor_id)
  VALUES ('APP:00000000-0000-0000-0000-0000000000f1:BEAUFTRAGUNG',
          '00000000-0000-0000-0000-0000000000a1','00000000-0000-0000-0000-0000000000a1');
  INSERT INTO mt VALUES ('MT-09','Selbstfreigabe scheitert (sod)',false,'FEHLER: wurde angenommen');
EXCEPTION WHEN others THEN
  INSERT INTO mt VALUES ('MT-09','Selbstfreigabe scheitert (sod)',
    SQLERRM LIKE '%sod_editor_ne_approver%', 'Meldung: '||SQLERRM);
END $$;

-- Positiv W03: mit Vier-Augen-Freigabe gelingt der Wechsel.
INSERT INTO approval(object_ref,editor_actor_id,approver_actor_id)
VALUES ('APP:00000000-0000-0000-0000-0000000000f1:BEAUFTRAGUNG',
        '00000000-0000-0000-0000-0000000000a1','00000000-0000-0000-0000-0000000000a2');
UPDATE app SET lifecycle_state='BEAUFTRAGT' WHERE id='00000000-0000-0000-0000-0000000000f1';

DO $$ BEGIN
  INSERT INTO mt SELECT 'MT-10','W03 mit Freigabe gelingt · Verlauf gekoppelt',
    (SELECT lifecycle_state='BEAUFTRAGT' FROM app WHERE id='00000000-0000-0000-0000-0000000000f1')
    AND EXISTS (SELECT 1 FROM app_state_history
                 WHERE app_id='00000000-0000-0000-0000-0000000000f1'
                   AND state='BEAUFTRAGT' AND upper_inf(gueltig))
    AND (SELECT count(*) FROM app_state_history
          WHERE app_id='00000000-0000-0000-0000-0000000000f1')=3,
    'drei Verlaufszeilen, offene Zeile = BEAUFTRAGT';
END $$;

-- W11: Beauftragt -> Pausiert (Verwalter) gelingt.
UPDATE app SET lifecycle_state='PAUSIERT' WHERE id='00000000-0000-0000-0000-0000000000f1';

-- N10: Rueckweg in einen ANDEREN als den letzten Zustand scheitert am Verlauf.
DO $$ BEGIN
  UPDATE app SET lifecycle_state='IN_BEARBEITUNG' WHERE id='00000000-0000-0000-0000-0000000000f1';
  INSERT INTO mt VALUES ('MT-11','N10 falscher Rueckweg aus Pausiert scheitert am Verlauf',false,'FEHLER: wurde angenommen');
EXCEPTION WHEN others THEN
  INSERT INTO mt VALUES ('MT-11','N10 falscher Rueckweg aus Pausiert scheitert am Verlauf',
    SQLERRM LIKE '%Rueckweg aus PAUSIERT%', 'Meldung: '||SQLERRM);
END $$;

-- N13: richtiger Rueckweg, aber EINE Person -> scheitert an der Personenzahl (W17, 4.8.2026).
DO $$ BEGIN
  UPDATE app SET lifecycle_state='BEAUFTRAGT' WHERE id='00000000-0000-0000-0000-0000000000f1';
  INSERT INTO mt VALUES ('MT-12','N13 Pausiert->Beauftragt ohne zwei Personen scheitert',false,'FEHLER: wurde angenommen');
EXCEPTION WHEN others THEN
  INSERT INTO mt VALUES ('MT-12','N13 Pausiert->Beauftragt ohne zwei Personen scheitert',
    SQLERRM LIKE '%verlangt zwei Personen%', 'Meldung: '||SQLERRM);
END $$;

-- Positiv W17: mit Freigabe fuer GENAU DIESEN Wechsel gelingt der Rueckweg.
INSERT INTO approval(object_ref,editor_actor_id,approver_actor_id)
VALUES ('APP:00000000-0000-0000-0000-0000000000f1:PAUSIERT->BEAUFTRAGT',
        '00000000-0000-0000-0000-0000000000a1','00000000-0000-0000-0000-0000000000a2');
UPDATE app SET lifecycle_state='BEAUFTRAGT' WHERE id='00000000-0000-0000-0000-0000000000f1';

DO $$ BEGIN
  INSERT INTO mt SELECT 'MT-13','W17 mit zwei Personen gelingt',
    (SELECT lifecycle_state='BEAUFTRAGT' FROM app WHERE id='00000000-0000-0000-0000-0000000000f1'),
    'Rueckweg in den Vertragszustand mit Vier-Augen';
END $$;

-- =====================================================================
-- PROTOKOLL (Nr. 16 · 48 / Punkt 11)
-- =====================================================================
-- Positiv: Anmeldung (neue Sitzung) erzeugt genau eine Protokollzeile.
INSERT INTO auth_session(id,actor_id,device_label)
VALUES ('00000000-0000-0000-0000-0000000000e1','00000000-0000-0000-0000-0000000000a3','Rechner');

DO $$ BEGIN
  INSERT INTO mt SELECT 'MT-14','Anmeldung erzeugt Protokollzeile (Nr. 16)',
    (SELECT count(*) FROM event
      WHERE action='ANMELDUNG'
        AND object_ref='SESSION:00000000-0000-0000-0000-0000000000e1'
        AND actor_id='00000000-0000-0000-0000-0000000000a3')=1,
    'genau eine ANMELDUNG-Zeile mit fester Kontoverknuepfung (Nr. 48)';
END $$;

-- Gegentest: Protokollzeile aendern wird ABGEWIESEN (nicht mehr still verworfen).
DO $$ BEGIN
  UPDATE event SET action='MANIPULIERT' WHERE action='ANMELDUNG';
  INSERT INTO mt VALUES ('MT-15','Protokoll: UPDATE wird abgewiesen (F02-Haertung)',false,'FEHLER: wurde angenommen');
EXCEPTION WHEN others THEN
  INSERT INTO mt VALUES ('MT-15','Protokoll: UPDATE wird abgewiesen (F02-Haertung)',
    SQLERRM LIKE '%APPEND-ONLY%', 'Meldung: '||SQLERRM);
END $$;

DO $$ BEGIN
  DELETE FROM event WHERE action='ANMELDUNG';
  INSERT INTO mt VALUES ('MT-16','Protokoll: DELETE wird abgewiesen',false,'FEHLER: wurde angenommen');
EXCEPTION WHEN others THEN
  INSERT INTO mt VALUES ('MT-16','Protokoll: DELETE wird abgewiesen',
    SQLERRM LIKE '%APPEND-ONLY%', 'Meldung: '||SQLERRM);
END $$;

-- Protokollzeilen sind NIE faellig (Nr. 16/18/60), Pseudonymisierung bleibt.
DO $$ BEGIN
  -- KORRIGIERT am 5.8.2026 (Befund F-08 aus dem Fremdreview zu K02): Der Fall
  -- verlangte bisher, dass pseudonymisieren_ab GESETZT ist. K02-M17 verlangt
  -- nach Nr. 60 das Gegenteil -- "ohne Faelligkeit UND ohne Anonymisierung".
  -- Der Fall bestand, weil er den Ist-Stand mass statt die Klausel.
  INSERT INTO mt SELECT 'MT-17','Protokollzeile weder faellig noch anonymisiert (Nr. 60, K02-M17)',
    NOT EXISTS (SELECT 1 FROM retention_due
                 WHERE objekt='event' AND (faellig_am IS NOT NULL
                                       OR pseudonymisieren_ab IS NOT NULL)),
    'weder faellig_am noch pseudonymisieren_ab -- die Zeile bleibt, wie sie ist';
END $$;

-- =====================================================================
-- ANMELDECODE UND SPERREN (Nr. 35 · 61)
-- =====================================================================
-- Gegentest Nr. 61: Code mit 11 Minuten scheitert an login_code_frist.
-- Die Bedingung heisst nach Entscheidung E3 so; sie rechnet gegen issued_at.
DO $$ BEGIN
  INSERT INTO login_code(actor_id,code_hash,issued_at,expires_at)
  VALUES ('00000000-0000-0000-0000-0000000000a3','hash1',now(),now()+interval '11 minutes');
  INSERT INTO mt VALUES ('MT-18','Code laenger als 10 Minuten scheitert (Nr. 61)',false,'FEHLER: wurde angenommen');
EXCEPTION WHEN others THEN
  INSERT INTO mt VALUES ('MT-18','Code laenger als 10 Minuten scheitert (Nr. 61)',
    SQLERRM LIKE '%login_code_frist%', 'Meldung: '||SQLERRM);
END $$;

-- Gegentest K03-M15 (Entscheidung E3): ein neuer Code entwertet die aelteren,
-- und es bleibt genau EINER offen. Der Bau-Vorschlag setzt das als Bedingung
-- durch, nicht als Absichtserklaerung -- die frueher hier gebaute Fassung
-- konnte es gar nicht.
INSERT INTO login_code(actor_id,code_hash) VALUES
  ('00000000-0000-0000-0000-0000000000a3','hash-alt');
INSERT INTO login_code(actor_id,code_hash) VALUES
  ('00000000-0000-0000-0000-0000000000a3','hash-neu');
DO $$ BEGIN
  INSERT INTO mt SELECT 'MT-45','Neuer Code entwertet den aelteren (K03-M15)',
    (SELECT count(*) FROM login_code
      WHERE actor_id='00000000-0000-0000-0000-0000000000a3'
        AND consumed_at IS NULL AND superseded_at IS NULL)=1
    AND (SELECT superseded_at IS NOT NULL FROM login_code
          WHERE code_hash='hash-alt'),
    'genau ein offener Code je Konto; der aeltere traegt superseded_at';
END $$;

-- Gegentest K03-M16: mehr als fuenf Fehlversuche je Code scheitern.
DO $$ BEGIN
  UPDATE login_code SET failed_count=6 WHERE code_hash='hash-neu';
  INSERT INTO mt VALUES ('MT-46','6 Fehlversuche je Code scheitern (K03-M16)',false,'FEHLER: wurde angenommen');
EXCEPTION WHEN others THEN
  INSERT INTO mt VALUES ('MT-46','6 Fehlversuche je Code scheitern (K03-M16)',
    SQLERRM LIKE '%login_code_fehlversuche%', 'Meldung: '||SQLERRM);
END $$;

-- Gegentest Nr. 35: der 6. Fehlversuch je Konto scheitert an der KONTO-SPERRE.
INSERT INTO login_attempt(email,origin_hash,success)
SELECT 'manfred.mueller@demobank.de','origin-a',false FROM generate_series(1,5);
DO $$ BEGIN
  INSERT INTO login_attempt(email,origin_hash,success)
  VALUES ('manfred.mueller@demobank.de','origin-a',false);
  INSERT INTO mt VALUES ('MT-19','6. Fehlversuch je Konto wird gesperrt (Nr. 35)',false,'FEHLER: wurde angenommen');
EXCEPTION WHEN others THEN
  INSERT INTO mt VALUES ('MT-19','6. Fehlversuch je Konto wird gesperrt (Nr. 35)',
    SQLERRM LIKE '%KONTO-SPERRE%', 'Meldung: '||SQLERRM);
END $$;

-- Gegentest Nr. 35: der 21. Fehlversuch derselben Herkunft scheitert an der
-- HERKUNFTS-SPERRE — auch fuer Adressen OHNE Konto.
INSERT INTO login_attempt(email,origin_hash,success)
SELECT 'adresse'||g||'@ohnekonto.example','origin-b',false FROM generate_series(1,20) g;
DO $$ BEGIN
  INSERT INTO login_attempt(email,origin_hash,success)
  VALUES ('nochmal@ohnekonto.example','origin-b',false);
  INSERT INTO mt VALUES ('MT-20','21. Fehlversuch je Herkunft wird gesperrt (Nr. 35)',false,'FEHLER: wurde angenommen');
EXCEPTION WHEN others THEN
  INSERT INTO mt VALUES ('MT-20','21. Fehlversuch je Herkunft wird gesperrt (Nr. 35)',
    SQLERRM LIKE '%HERKUNFTS-SPERRE%', 'Meldung: '||SQLERRM);
END $$;

-- Versandnachweis unveraenderbar (Nr. 35). Heisst nach E3 mail_delivery.
INSERT INTO mail_delivery(kind,recipient,sender,status)
VALUES ('ANMELDECODE','manfred.mueller@demobank.de','noreply@exmachinai.com','UEBERGEBEN');
DO $$ BEGIN
  UPDATE mail_delivery SET recipient='geaendert@demobank.de';
  INSERT INTO mt VALUES ('MT-21','Versandnachweis unveraenderbar',false,'FEHLER: wurde angenommen');
EXCEPTION WHEN others THEN
  INSERT INTO mt VALUES ('MT-21','Versandnachweis unveraenderbar',
    SQLERRM LIKE '%APPEND-ONLY%', 'Meldung: '||SQLERRM);
END $$;

-- Nr. 34 (zweiter Sicherheitstest): Zweitanmeldung am Handy macht die
-- Sitzung am Rechner nicht wieder frisch.
DO $$
DECLARE alt timestamptz;
BEGIN
  SELECT last_activity_at INTO alt FROM auth_session
   WHERE id='00000000-0000-0000-0000-0000000000e1';
  INSERT INTO auth_session(actor_id,device_label)
  VALUES ('00000000-0000-0000-0000-0000000000a3','Handy');
  INSERT INTO mt SELECT 'MT-22','Zweitanmeldung frischt erste Sitzung nicht auf (Nr. 34)',
    (SELECT last_activity_at FROM auth_session
      WHERE id='00000000-0000-0000-0000-0000000000e1') = alt,
    'last_activity_at der Rechner-Sitzung unveraendert';
END $$;
-- Nr. 34, erster Sicherheitstest (untergeschobene fremde Anmeldung):
-- Laufzeitverhalten der Anmeldestrecke, nicht der Datenbank — gehoert in
-- die Abnahme des Mailwegs (H07). Hier bewusst KEIN Datenbanktest.

-- =====================================================================
-- NACHWEISLISTE EINLADUNGEN (Nr. 10, Punkt 05)
-- =====================================================================
INSERT INTO invitation_decision(tenant_id,decided_by,adressat_mail,grund)
VALUES ('00000000-0000-0000-0000-000000000002','A. Han','manfred.mueller@demobank.de','Pilotteilnehmer Demobank');

DO $$ BEGIN
  UPDATE invitation_decision SET grund='umgeschrieben';
  INSERT INTO mt VALUES ('MT-23','Nachweisliste: Aenderung scheitert (Nr. 10)',false,'FEHLER: wurde angenommen');
EXCEPTION WHEN others THEN
  INSERT INTO mt VALUES ('MT-23','Nachweisliste: Aenderung scheitert (Nr. 10)',
    SQLERRM LIKE '%APPEND-ONLY%', 'Meldung: '||SQLERRM);
END $$;

DO $$ BEGIN
  DELETE FROM invitation_decision;
  INSERT INTO mt VALUES ('MT-24','Nachweisliste: Loeschung scheitert (Nr. 10)',false,'FEHLER: wurde angenommen');
EXCEPTION WHEN others THEN
  INSERT INTO mt VALUES ('MT-24','Nachweisliste: Loeschung scheitert (Nr. 10)',
    SQLERRM LIKE '%APPEND-ONLY%', 'Meldung: '||SQLERRM);
END $$;

-- =====================================================================
-- SIEGEL (Nr. 38) UND AUSNAHMEKONTO (Nr. 59)
-- =====================================================================
INSERT INTO actor(id,tenant_id,email,display_name,status,sealed)
VALUES ('00000000-0000-0000-0000-0000000000a4','00000000-0000-0000-0000-000000000001',
        'siegel@exmachinai.com','Versiegelt','AKTIV',true);
DO $$ BEGIN
  UPDATE actor SET sealed=false WHERE id='00000000-0000-0000-0000-0000000000a4';
  INSERT INTO mt VALUES ('MT-25','Siegelruecknahme scheitert (Nr. 38)',false,'FEHLER: wurde angenommen');
EXCEPTION WHEN others THEN
  INSERT INTO mt VALUES ('MT-25','Siegelruecknahme scheitert (Nr. 38)',
    SQLERRM LIKE '%SIEGEL%', 'Meldung: '||SQLERRM);
END $$;

UPDATE actor SET mfa_method='OFF' WHERE id='00000000-0000-0000-0000-0000000000a1';
DO $$ BEGIN
  UPDATE actor SET mfa_method='OFF' WHERE id='00000000-0000-0000-0000-0000000000a2';
  INSERT INTO mt VALUES ('MT-26','Zweites Ausnahmekonto scheitert (Nr. 59)',false,'FEHLER: wurde angenommen');
EXCEPTION WHEN others THEN
  INSERT INTO mt VALUES ('MT-26','Zweites Ausnahmekonto scheitert (Nr. 59)',
    SQLERRM LIKE '%actor_ausnahmekonto_uq%', 'Meldung: '||SQLERRM);
END $$;

-- =====================================================================
-- KENNTNISNAHME (O-K04-8 / F1)
-- =====================================================================
INSERT INTO fit_check(id,tenant_id,actor_id,completed_at,outcome)
VALUES ('00000000-0000-0000-0000-0000000000c1','00000000-0000-0000-0000-000000000002',
        '00000000-0000-0000-0000-0000000000a3',now(),'GEEIGNET');

-- Gegentest F1: Kenntnisnahme mit Klasse BETRIEBSPROTOKOLL wird abgewiesen.
DO $$ BEGIN
  UPDATE fit_check SET retention_class='BETRIEBSPROTOKOLL', zweckbestimmung_ack_at=now()
   WHERE id='00000000-0000-0000-0000-0000000000c1';
  INSERT INTO mt VALUES ('MT-27','Kenntnisnahme nur mit KI_NACHWEIS (F1)',false,'FEHLER: wurde angenommen');
EXCEPTION WHEN others THEN
  INSERT INTO mt VALUES ('MT-27','Kenntnisnahme nur mit KI_NACHWEIS (F1)',
    SQLERRM LIKE '%ack_klasse_ki_nachweis%', 'Meldung: '||SQLERRM);
END $$;

-- Gegentest F1: Kenntnisnahme vor GEEIGNET wird abgewiesen.
INSERT INTO fit_check(id,tenant_id,outcome)
VALUES ('00000000-0000-0000-0000-0000000000c2','00000000-0000-0000-0000-000000000002','OFFEN');
DO $$ BEGIN
  UPDATE fit_check SET zweckbestimmung_ack_at=now()
   WHERE id='00000000-0000-0000-0000-0000000000c2';
  INSERT INTO mt VALUES ('MT-28','Kenntnisnahme erst nach GEEIGNET (F1)',false,'FEHLER: wurde angenommen');
EXCEPTION WHEN others THEN
  INSERT INTO mt VALUES ('MT-28','Kenntnisnahme erst nach GEEIGNET (F1)',
    SQLERRM LIKE '%ack_nach_eignung%', 'Meldung: '||SQLERRM);
END $$;

-- Positiv: am GEEIGNET-Check mit KI_NACHWEIS gelingt sie.
UPDATE fit_check SET zweckbestimmung_ack_at=now()
 WHERE id='00000000-0000-0000-0000-0000000000c1';
DO $$ BEGIN
  INSERT INTO mt SELECT 'MT-29','Kenntnisnahme am GEEIGNET-Check gelingt (F1)',
    (SELECT zweckbestimmung_ack_at IS NOT NULL FROM fit_check
      WHERE id='00000000-0000-0000-0000-0000000000c1'),
    'Feld gesetzt, Klasse KI_NACHWEIS';
END $$;

-- =====================================================================
-- AGENT (Nr. 29 · 32)
-- =====================================================================
INSERT INTO agent(id,name,model_ref_id)
SELECT '00000000-0000-0000-0000-0000000000b1','Testagent',m.id
  FROM model_ref m WHERE m.token='Claude Sonnet';

-- Gegentest Nr. 32: Freigabe ohne Vier-Augen scheitert.
UPDATE agent SET output_form='markdown', allowed_actions='["lesen"]'::jsonb
 WHERE id='00000000-0000-0000-0000-0000000000b1';
DO $$ BEGIN
  UPDATE agent SET status='RELEASED' WHERE id='00000000-0000-0000-0000-0000000000b1';
  INSERT INTO mt VALUES ('MT-30','Agentenfreigabe ohne Vier-Augen scheitert (Nr. 32)',false,'FEHLER: wurde angenommen');
EXCEPTION WHEN others THEN
  INSERT INTO mt VALUES ('MT-30','Agentenfreigabe ohne Vier-Augen scheitert (Nr. 32)',
    SQLERRM LIKE '%AGENT-FREIGABE%', 'Meldung: '||SQLERRM);
END $$;

-- Gegentest Nr. 29: Freigabe ohne Handlungsliste scheitert an der Vollstaendigkeit.
INSERT INTO approval(object_ref,editor_actor_id,approver_actor_id)
VALUES ('AGENT:00000000-0000-0000-0000-0000000000b1',
        '00000000-0000-0000-0000-0000000000a1','00000000-0000-0000-0000-0000000000a2');
DO $$ BEGIN
  UPDATE agent SET allowed_actions=NULL, status='RELEASED'
   WHERE id='00000000-0000-0000-0000-0000000000b1';
  INSERT INTO mt VALUES ('MT-31','Freigabe ohne Handlungsliste scheitert (Nr. 29)',false,'FEHLER: wurde angenommen');
EXCEPTION WHEN others THEN
  INSERT INTO mt VALUES ('MT-31','Freigabe ohne Handlungsliste scheitert (Nr. 29)',
    SQLERRM LIKE '%agent_released_vollstaendig%', 'Meldung: '||SQLERRM);
END $$;

-- Positiv: vollstaendig und mit Freigabe gelingt RELEASED.
UPDATE agent SET status='RELEASED' WHERE id='00000000-0000-0000-0000-0000000000b1';
DO $$ BEGIN
  INSERT INTO mt SELECT 'MT-32','Agent vollstaendig + Vier-Augen -> RELEASED (Nr. 29/32)',
    (SELECT status='RELEASED' FROM agent WHERE id='00000000-0000-0000-0000-0000000000b1'),
    'Freigabe mit editor <> approver';
END $$;

-- =====================================================================
-- AUSWAHLVERMERK (Nr. 25)
-- =====================================================================
UPDATE app SET auswahlvermerk='Vorlage A1 v1, Gleichstand nach Umfang', auswahlvermerk_at=now()
 WHERE id='00000000-0000-0000-0000-0000000000f1';
DO $$ BEGIN
  UPDATE app SET auswahlvermerk='nachtraeglich umgeschrieben'
   WHERE id='00000000-0000-0000-0000-0000000000f1';
  INSERT INTO mt VALUES ('MT-33','Auswahlvermerk unveraenderlich (Nr. 25)',false,'FEHLER: wurde angenommen');
EXCEPTION WHEN others THEN
  INSERT INTO mt VALUES ('MT-33','Auswahlvermerk unveraenderlich (Nr. 25)',
    SQLERRM LIKE '%AUSWAHLVERMERK%', 'Meldung: '||SQLERRM);
END $$;

-- =====================================================================
-- PROJEKTVERTRAG (Nr. 50 / H01)
-- =====================================================================
INSERT INTO project_contract(app_id,version,gueltig)
VALUES ('00000000-0000-0000-0000-0000000000f1','v1',daterange(current_date,NULL));

-- Gegentest H01: Ueberschreitung ohne Ausweis scheitert.
DO $$ BEGIN
  INSERT INTO contract_check(app_id,contract_version,seiten,ueberschritten,ausgewiesen)
  VALUES ('00000000-0000-0000-0000-0000000000f1','v1',6,true,false);
  INSERT INTO mt VALUES ('MT-34','Ueberschreitung ohne Ausweis scheitert (H01)',false,'FEHLER: wurde angenommen');
EXCEPTION WHEN others THEN
  INSERT INTO mt VALUES ('MT-34','Ueberschreitung ohne Ausweis scheitert (H01)',
    SQLERRM LIKE '%ueberschreitung_ausgewiesen%', 'Meldung: '||SQLERRM);
END $$;

-- Positiv H01: 6 Seiten MIT Ausweis gelingt — ausweisen, nicht anhalten.
INSERT INTO contract_check(app_id,contract_version,seiten,ueberschritten,ausgewiesen)
VALUES ('00000000-0000-0000-0000-0000000000f1','v1',6,true,true);
DO $$ BEGIN
  INSERT INTO mt SELECT 'MT-35','Ueberschreitung MIT Ausweis haelt nicht an (H01)',
    EXISTS (SELECT 1 FROM contract_check
             WHERE app_id='00000000-0000-0000-0000-0000000000f1' AND ausgewiesen),
    'Pruefergebnis festgehalten, Vorgang laeuft weiter';
END $$;

-- Gegentest Nr. 50: zweite gleichzeitig geltende Vertragsfassung scheitert.
DO $$ BEGIN
  INSERT INTO project_contract(app_id,version,gueltig)
  VALUES ('00000000-0000-0000-0000-0000000000f1','v2',daterange(current_date,NULL));
  INSERT INTO mt VALUES ('MT-36','Zweite geltende Vertragsfassung scheitert (Nr. 50)',false,'FEHLER: wurde angenommen');
EXCEPTION WHEN others THEN
  INSERT INTO mt VALUES ('MT-36','Zweite geltende Vertragsfassung scheitert (Nr. 50)',
    SQLSTATE = '23P01', 'Exclusion-Verletzung: '||SQLERRM);
END $$;

-- =====================================================================
-- SCHNELLWEG-FRAGEN (Nr. 55) UND template_element (F6)
-- =====================================================================
INSERT INTO quick_question(code,position) VALUES ('thema',1);
INSERT INTO quick_question_version(question_code,version,prompt_de,gueltig)
VALUES ('thema','v1','Frage in Fassung 1',daterange(current_date,current_date+1));
INSERT INTO quick_option(question_code,version,position,label_de,value_token)
VALUES ('thema','v1',1,'Antwort A','antwort_a');
INSERT INTO quick_check(id,tenant_id)
VALUES ('00000000-0000-0000-0000-0000000000d1','00000000-0000-0000-0000-000000000002');
INSERT INTO quick_answer(quick_check_id,question_code,version,option_pos)
VALUES ('00000000-0000-0000-0000-0000000000d1','thema','v1',1);
-- Neue Fassung der Frage:
INSERT INTO quick_question_version(question_code,version,prompt_de,gueltig)
VALUES ('thema','v2','Frage in Fassung 2 (geaendert)',daterange(current_date+1,NULL));

DO $$ BEGIN
  INSERT INTO mt SELECT 'MT-37','Geaenderte Frage aendert alte Antwort nicht (Nr. 55)',
    EXISTS (SELECT 1 FROM quick_answer a
             JOIN quick_question_version v
               ON v.question_code=a.question_code AND v.version=a.version
            WHERE a.quick_check_id='00000000-0000-0000-0000-0000000000d1'
              AND v.prompt_de='Frage in Fassung 1'),
    'Antwort verweist weiter auf die beantwortete Fassung v1';
END $$;

INSERT INTO template(id,grp,name) VALUES ('T-HAUPT','DESIGN','Gespraechsvorlage');
INSERT INTO template(id,grp,name) VALUES ('T-ELEM','DESIGN','Elementvorlage');
-- Nach Entscheidung E2 traegt eine Vorlage des Vorlagen-Universums das ganze
-- Profil; das Ziel eines Elementbedarfs muss selbst eine Elementvorlage sein.
INSERT INTO template_version(template_id,version,gueltig,
       function_kind,dialog_mode,result_kind,status_content,input_density,confirm_density)
VALUES ('T-ELEM','v1',daterange(current_date,NULL),
       'ELEMENTVORLAGE','GEMISCHT','VORGANG','LISTE','GERING','KEINE');
INSERT INTO template_version(template_id,version,gueltig,
       function_kind,dialog_mode,result_kind,status_content,input_density,confirm_density)
VALUES ('T-HAUPT','v1',daterange(current_date,NULL),
       'GESPRAECHSVORLAGE','GEMISCHT','VORGANG','KENNZAHL','HOCH','EINSTUFIG');
INSERT INTO template_element(template_id,version,element_template_id)
VALUES ('T-HAUPT','v1','T-ELEM');

-- =====================================================================
-- SECHS MERKMALE DER VORLAGENFASSUNG (Nr. 24, Entscheidung E2)
-- =====================================================================
-- Positiv: eine Schriftstueck-Vorlage darf ALLE SECHS leer lassen. Das ist
-- der Kern von E2/A -- ohne diese Freiheit koennten die siebzehn
-- Bestandsvorlagen die Pflichtfelder nicht fuellen und die Migration
-- braeche beim ersten Lauf ab.
INSERT INTO template(id,grp,name) VALUES ('T-DOK','DOCUMENT','Kurzsteckbrief');
DO $$ BEGIN
  INSERT INTO template_version(template_id,version,gueltig)
  VALUES ('T-DOK','v1',daterange(current_date,NULL));
  INSERT INTO mt SELECT 'MT-47','Schriftstueck-Vorlage ohne Merkmale zulaessig (E2/A)',
    (SELECT function_kind IS NULL FROM template_version
      WHERE template_id='T-DOK' AND version='v1'),
    'alle sechs Angaben leer, Fassung angelegt';
EXCEPTION WHEN others THEN
  INSERT INTO mt VALUES ('MT-47','Schriftstueck-Vorlage ohne Merkmale zulaessig (E2/A)',
    false,'FEHLER: wurde abgewiesen -- '||SQLERRM);
END $$;

-- Gegentest E2/A: ein HALBES Profil scheitert. Ein Auswahllauf, der auf
-- einer Luecke filtert, trifft falsch statt gar nicht.
DO $$ BEGIN
  INSERT INTO template_version(template_id,version,gueltig,function_kind)
  VALUES ('T-DOK','v2',daterange(current_date,NULL),'STATUSVORLAGE');
  INSERT INTO mt VALUES ('MT-48','Halbes Merkmalsprofil scheitert (E2/A)',false,'FEHLER: wurde angenommen');
EXCEPTION WHEN others THEN
  INSERT INTO mt VALUES ('MT-48','Halbes Merkmalsprofil scheitert (E2/A)',
    SQLERRM LIKE '%tv_merkmale_ganz%', 'Meldung: '||SQLERRM);
END $$;

-- Gegentest Nr. 24: die funktionale Art ist unveraenderlich. Eine zweite
-- Fassung darf die Vorlage nicht in einen anderen Topf umhaengen.
DO $$ BEGIN
  INSERT INTO template_version(template_id,version,gueltig,
         function_kind,dialog_mode,result_kind,status_content,input_density,confirm_density)
  VALUES ('T-HAUPT','v2',daterange(current_date,NULL),
         'STATUSVORLAGE','GEMISCHT','VORGANG','KENNZAHL','HOCH','EINSTUFIG');
  INSERT INTO mt VALUES ('MT-49','Funktionale Art bleibt ueber Fassungen (Nr. 24)',false,'FEHLER: wurde angenommen');
EXCEPTION WHEN others THEN
  INSERT INTO mt VALUES ('MT-49','Funktionale Art bleibt ueber Fassungen (Nr. 24)',
    SQLERRM LIKE '%FUNKTIONALE ART%', 'Meldung: '||SQLERRM);
END $$;

-- Gegentest K25-M14: der gestrichene vierte Statusinhalt existiert nicht.
DO $$ BEGIN
  PERFORM 'ZUSTAND'::template_status_content;
  INSERT INTO mt VALUES ('MT-50','Gestrichener Wert ZUSTAND existiert nicht (E2/A)',false,
    'FEHLER: der Wert wurde angenommen');
EXCEPTION WHEN others THEN
  INSERT INTO mt VALUES ('MT-50','Gestrichener Wert ZUSTAND existiert nicht (E2/A)',
    SQLERRM LIKE '%invalid input value%' OR SQLERRM LIKE '%ung_ltige Eingabesyntax%'
    OR SQLERRM LIKE '%ZUSTAND%', 'Meldung: '||SQLERRM);
END $$;

-- Gegentest F6/Nr. 24: das Ziel eines Elementbedarfs muss eine
-- Elementvorlage sein. Diese Pruefung war bis zur Entscheidung ueber die
-- Wertelisten gar nicht formulierbar.
DO $$ BEGIN
  INSERT INTO template_element(template_id,version,element_template_id)
  VALUES ('T-HAUPT','v1','T-DOK');
  INSERT INTO mt VALUES ('MT-51','Elementbedarf nur auf Elementvorlagen (Nr. 24)',false,'FEHLER: wurde angenommen');
EXCEPTION WHEN others THEN
  INSERT INTO mt VALUES ('MT-51','Elementbedarf nur auf Elementvorlagen (Nr. 24)',
    SQLERRM LIKE '%ELEMENTBEDARF%', 'Meldung: '||SQLERRM);
END $$;

-- Gegentest F6: eine Vorlage kann sich nicht selbst verlangen.
DO $$ BEGIN
  INSERT INTO template_element(template_id,version,element_template_id)
  VALUES ('T-HAUPT','v1','T-HAUPT');
  INSERT INTO mt VALUES ('MT-38','Vorlage verlangt sich nicht selbst (F6)',false,'FEHLER: wurde angenommen');
EXCEPTION WHEN others THEN
  INSERT INTO mt VALUES ('MT-38','Vorlage verlangt sich nicht selbst (F6)',
    SQLERRM LIKE '%element_nicht_selbst%', 'Meldung: '||SQLERRM);
END $$;

-- F6: Umfang wird GEZAEHLT, nicht geschaetzt; ohne Feststellung kein Umfang 0.
DO $$ BEGIN
  INSERT INTO mt SELECT 'MT-39','Umfang zaehlbar, nicht erhoben unterscheidbar (F6)',
    (SELECT count(*) FROM template_element WHERE template_id='T-HAUPT' AND version='v1')=1
    AND (SELECT elementbedarf_geprueft_at IS NULL FROM template_version
          WHERE template_id='T-HAUPT' AND version='v1'),
    'eine verlangte Elementvorlage; Feststellung noch offen -> fail-closed';
END $$;

-- =====================================================================
-- EINLADUNGSDOMAENE (Nr. 54, Option B)
-- =====================================================================
UPDATE tenant SET invite_domain=NULL WHERE id='00000000-0000-0000-0000-000000000002';
DO $$ BEGIN
  INSERT INTO mt SELECT 'MT-40','Abschalten der Schranke erzeugt Nachweis (Nr. 54 B)',
    EXISTS (SELECT 1 FROM event
             WHERE action='EINLADUNGSDOMAENE_GEAENDERT'
               AND tenant_id='00000000-0000-0000-0000-000000000002'
               AND value LIKE '%abgeschaltet%'),
    'Protokollzeile mit altem und neuem Wert';
END $$;

-- =====================================================================
-- AUFBEWAHRUNG (Nr. 17 · 35 · 49)
-- =====================================================================
DO $$ BEGIN
  INSERT INTO mt SELECT 'MT-41','Neue Klassen vorhanden (Nr. 17/35/49)',
    (SELECT count(*) FROM retention_rule WHERE class IN ('KURZFRIST','PROJEKT_VORVERTRAG'))=2,
    'KURZFRIST (30 Tage, seit Stufe 9a tagesgenau) und PROJEKT_VORVERTRAG (6 Monate)';
END $$;

-- =====================================================================
-- STUFE 9 · Nachtrag aus dem Befund vom 5.8.2026
-- =====================================================================
DO $$ BEGIN
  INSERT INTO mt SELECT 'MT-52','Fristen sind tagesgenau darstellbar (Stufe 9a)',
    (SELECT regelfrist_tage=30 AND regelfrist_monate IS NULL
       FROM retention_rule WHERE class='KURZFRIST')
    AND (SELECT regelfrist_tage=90 AND regelfrist_monate IS NULL
           FROM retention_rule WHERE class='ARBEITSERGEBNIS'),
    'KURZFRIST 30 Tage, ARBEITSERGEBNIS 90 Tage -- keine Monatsnaeherung mehr';
END $$;

-- Gegentest: eine Klasse darf nicht BEIDE Fristen tragen. Zwei Fristen
-- fuer dieselbe Sache sind ein Fehler, kein Angebot.
DO $$ BEGIN
  INSERT INTO retention_rule(class,bezeichnung,fristbeginn,regelfrist_tage,
                             regelfrist_monate,mindestfrist_monate,rechtsgrundlage)
  VALUES ('ARBEITSERGEBNIS','doppelt','ERSTELLUNG',10,2,0,'Test')
  ON CONFLICT (class) DO UPDATE SET regelfrist_tage=10, regelfrist_monate=2;
  INSERT INTO mt VALUES ('MT-53','Zwei Fristen an einer Klasse scheitern (Stufe 9a)',false,
    'FEHLER: wurde angenommen');
EXCEPTION WHEN others THEN
  INSERT INTO mt VALUES ('MT-53','Zwei Fristen an einer Klasse scheitern (Stufe 9a)',
    SQLERRM LIKE '%genau_eine_frist%', 'Meldung: '||SQLERRM);
END $$;

DO $$ BEGIN
  INSERT INTO mt SELECT 'MT-54','Telemetriestand hat einen Ort (O-K17-5)',
    EXISTS (SELECT 1 FROM information_schema.columns
             WHERE table_name='agent' AND column_name='telemetrie_stand_at'),
    'agent.telemetrie_stand_at -- die 26-Stunden-Schwelle ist berechenbar';
END $$;

-- O-K21-6: body_md muss ueber den LESEPFAD ankommen, nicht nur in der
-- Tabelle stehen. Genau das war der Befund.
DO $$ BEGIN
  INSERT INTO mt SELECT 'MT-55','policy_aktuell fuehrt body_md (O-K21-6)',
    (SELECT count(*) FROM information_schema.columns
      WHERE table_name='policy_aktuell'
        AND column_name IN ('id','name','scope','template_id','version','status',
                            'gueltig','editor','aenderungsvermerk','erfasst_am','body_md'))=11,
    'elf benannte Spalten statt SELECT *; der veroeffentlichte Text ist lesbar';
END $$;

DO $$ BEGIN
  INSERT INTO mt SELECT 'MT-56','Traeger fuer die 14-Tage-Frist (Punkt 20)',
    EXISTS (SELECT 1 FROM information_schema.columns
             WHERE table_name='direct_prototype' AND column_name='geteilt_bis')
    AND (SELECT column_default LIKE '%ARBEITSERGEBNIS%'
           FROM information_schema.columns
          WHERE table_name='direct_prototype' AND column_name='retention_class'),
    'direct_prototype.geteilt_bis vorhanden; Vorgabeklasse ARBEITSERGEBNIS (A-K12-2)';
END $$;

DO $$ BEGIN
  INSERT INTO mt SELECT 'MT-42','Anmeldecode-Faelligkeit in der Sicht (Nr. 35)',
    EXISTS (SELECT 1 FROM retention_due WHERE objekt='login_code' AND faellig_am IS NOT NULL)
    OR NOT EXISTS (SELECT 1 FROM login_code),
    'Zweig login_code liefert Faelligkeit 30 Tage nach Verbrauch/Ablauf';
END $$;

-- =====================================================================
-- UEBERGANGSTABELLE SELBST (Nr. 53 / H02)
-- =====================================================================
-- Nachgetragen 04.08.2026. Beim Abzaehlen der Traeger gegen die Pruefaelle
-- fiel auf: state_transition wird zwar durch den Uebergangs-Waechter in
-- MT-01 bis MT-08 mitgeprueft, aber die Tabelle selbst -- ihr Inhalt und
-- ihre eigene Bedingung -- von keinem Fall. Ein Waechter, der aus einer
-- leeren Tabelle liest, sperrt jeden Wechsel und sieht dabei aus wie eine
-- besonders strenge Regel.

DO $$ BEGIN
  INSERT INTO mt SELECT 'MT-43','Uebergangstabelle vollstaendig (H02, W02-W20)',
    (SELECT count(*) FROM state_transition)=19
    AND EXISTS (SELECT 1 FROM state_transition
                 WHERE from_state='PAUSIERT' AND to_state='BEAUFTRAGT'
                   AND authority='ZWEI_PERSONEN'),
    '19 eingetragene Wechsel; W17 traegt ZWEI_PERSONEN (entschieden 4.8.2026)';
END $$;

DO $$ BEGIN
  BEGIN
    INSERT INTO state_transition(from_state,to_state,authority)
      VALUES ('IN_DEV','IN_DEV','VERWALTER');
    INSERT INTO mt VALUES ('MT-44','Selbstwechsel scheitert (N11)',false,
      'kein Fehler -- der Selbstwechsel wurde eingetragen');
  EXCEPTION WHEN check_violation THEN
    INSERT INTO mt VALUES ('MT-44','Selbstwechsel scheitert (N11)',
      position('kein_selbstwechsel' in SQLERRM) > 0, 'Meldung: ' || SQLERRM);
  END;
END $$;

-- =====================================================================
-- STUFE 10 · Die sechs gezeichneten Vorfragen (5.8.2026)
-- =====================================================================

-- V2/A · Dokumentfassung -----------------------------------------------
INSERT INTO document(id,app_id,kind,filename,concept_kind)
VALUES ('00000000-0000-0000-0000-0000000000c1','00000000-0000-0000-0000-0000000000f1',
        'CONCEPT','prozess_schritte.md','PROZESS_SCHRITTE');
INSERT INTO document_version(document_id,version,gueltig,status,
       content_ref,content_sha256,content_media_type,content_size_bytes)
VALUES ('00000000-0000-0000-0000-0000000000c1','v1',daterange(current_date,NULL),'RELEASED',
        'obj://k06/v1', repeat('a',64), 'text/markdown', 1234);

DO $$ BEGIN
  INSERT INTO mt SELECT 'MT-59','Dokumentfassung traegt Stand und Pruefsumme (O-K06-1..3)',
    (SELECT content_sha256 = repeat('a',64) FROM document_version
      WHERE document_id='00000000-0000-0000-0000-0000000000c1' AND version='v1'),
    'document_version mit Speicherverweis, Pruefsumme, Medientyp und Groesse';
END $$;

-- Gegentest: eine freigegebene Fassung wird nicht geaendert (K06-M28).
DO $$ BEGIN
  UPDATE document_version SET content_sha256 = repeat('b',64)
   WHERE document_id='00000000-0000-0000-0000-0000000000c1' AND version='v1';
  INSERT INTO mt VALUES ('MT-60','Freigegebene Dokumentfassung unveraenderlich (K06-M28)',false,
    'FEHLER: wurde angenommen');
EXCEPTION WHEN others THEN
  INSERT INTO mt VALUES ('MT-60','Freigegebene Dokumentfassung unveraenderlich (K06-M28)',
    SQLERRM LIKE '%FASSUNG%', 'Meldung: '||SQLERRM);
END $$;

-- Gegentest: nie zwei gleichzeitig geltende Fassungen desselben Dokuments.
DO $$ BEGIN
  INSERT INTO document_version(document_id,version,gueltig)
  VALUES ('00000000-0000-0000-0000-0000000000c1','v2',daterange(current_date,NULL));
  INSERT INTO mt VALUES ('MT-61','Zwei geltende Dokumentfassungen scheitern (BF-4)',false,
    'FEHLER: wurde angenommen');
EXCEPTION WHEN others THEN
  INSERT INTO mt VALUES ('MT-61','Zwei geltende Dokumentfassungen scheitern (BF-4)',
    SQLERRM LIKE '%document_version_document_id_gueltig_excl%'
    OR SQLERRM LIKE '%exclusion%', 'Meldung: '||SQLERRM);
END $$;

-- Gegentest: ein Konzeptdokument ohne Artefaktkennung scheitert (K06-M01).
DO $$ BEGIN
  INSERT INTO document(app_id,kind,filename)
  VALUES ('00000000-0000-0000-0000-0000000000f1','CONCEPT','ohne_kennung.md');
  INSERT INTO mt VALUES ('MT-62','Konzept ohne Artefaktkennung scheitert (K06-M01)',false,
    'FEHLER: wurde angenommen');
EXCEPTION WHEN others THEN
  INSERT INTO mt VALUES ('MT-62','Konzept ohne Artefaktkennung scheitert (K06-M01)',
    SQLERRM LIKE '%concept_braucht_kennung%', 'Meldung: '||SQLERRM);
END $$;

-- V3/A · Modellpfad-Manifest -------------------------------------------
INSERT INTO model_manifest(id,name) VALUES ('MPM-1','Modellpfade Release 1');
DO $$ BEGIN
  INSERT INTO model_manifest_version(manifest_id,version,gueltig,status)
  VALUES ('MPM-1','v1',daterange(current_date,NULL),'RELEASED');
  INSERT INTO mt VALUES ('MT-63','Manifest ohne Pruefsumme nicht freigebbar (K17-M06)',false,
    'FEHLER: wurde angenommen');
EXCEPTION WHEN others THEN
  INSERT INTO mt VALUES ('MT-63','Manifest ohne Pruefsumme nicht freigebbar (K17-M06)',
    SQLERRM LIKE '%mmv_released_braucht_inhalt%', 'Meldung: '||SQLERRM);
END $$;

-- V4/B · Lizenz in SPDX-Schreibweise -----------------------------------
INSERT INTO knowledge_source(id,type,origin,status,license,
       short_description,zweck,owner_id,owner_label)
VALUES ('Q-TS-1','OSS','EXTERN','DRAFT','MIT',
        'Testquelle','Pruefung der Pflichtangaben',
        '00000000-0000-0000-0000-0000000000a1','Erst-Admin');
DO $$ BEGIN
  UPDATE knowledge_source SET status='RELEASED' WHERE id='Q-TS-1';
  INSERT INTO mt VALUES ('MT-64','OSS-Freigabe ohne Registernummer scheitert (K08-M24)',false,
    'FEHLER: wurde angenommen');
EXCEPTION WHEN others THEN
  INSERT INTO mt VALUES ('MT-64','OSS-Freigabe ohne Registernummer scheitert (K08-M24)',
    SQLERRM LIKE '%ks_released_braucht_register_no%', 'Meldung: '||SQLERRM);
END $$;

UPDATE knowledge_source SET register_no='TST-00001' WHERE id='Q-TS-1';
DO $$ BEGIN
  UPDATE knowledge_source SET license='GPL-3.0-only', status='RELEASED' WHERE id='Q-TS-1';
  INSERT INTO mt VALUES ('MT-65','OSS nur unter MIT oder Apache-2.0 (K08-M18)',false,
    'FEHLER: wurde angenommen');
EXCEPTION WHEN others THEN
  INSERT INTO mt VALUES ('MT-65','OSS nur unter MIT oder Apache-2.0 (K08-M18)',
    SQLERRM LIKE '%oss_nur_mit_apache%', 'Meldung: '||SQLERRM);
END $$;

DO $$ BEGIN
  UPDATE knowledge_source SET license='BaFin Nutzungsbedingungen 2024' WHERE id='Q-TS-1';
  INSERT INTO mt VALUES ('MT-66','Lizenz nur in SPDX-Schreibweise (V4/B)',false,
    'FEHLER: wurde angenommen');
EXCEPTION WHEN others THEN
  INSERT INTO mt VALUES ('MT-66','Lizenz nur in SPDX-Schreibweise (V4/B)',
    SQLERRM LIKE '%lizenz_spdx_form%', 'Meldung: '||SQLERRM);
END $$;

UPDATE knowledge_source SET license='LicenseRef-BaFin-Nutzung-2024' WHERE id='Q-TS-1';
DO $$ BEGIN
  INSERT INTO mt SELECT 'MT-67','LicenseRef fuer Nicht-SPDX-Bedingungen zulaessig (V4/B)',
    (SELECT license='LicenseRef-BaFin-Nutzung-2024' FROM knowledge_source WHERE id='Q-TS-1'),
    'BaFin-Nutzungsbedingungen als LicenseRef -- SPDX sieht die Form dafuer vor';
END $$;

-- Gegentest K08-M24: die Registernummer bleibt, was sie war.
DO $$ BEGIN
  UPDATE knowledge_source SET register_no='TST-00002' WHERE id='Q-TS-1';
  INSERT INTO mt VALUES ('MT-68','Registernummer unveraenderlich (K08-M24)',false,
    'FEHLER: wurde angenommen');
EXCEPTION WHEN others THEN
  INSERT INTO mt VALUES ('MT-68','Registernummer unveraenderlich (K08-M24)',
    SQLERRM LIKE '%REGISTERNUMMER%', 'Meldung: '||SQLERRM);
END $$;

-- V5/B · Nummernvorrat --------------------------------------------------
DO $$ BEGIN
  INSERT INTO mt SELECT 'MT-69','Nummernvorrat fuehrt die drei Kennungen (V5/B)',
    (SELECT count(*) FROM nummernvorrat WHERE praefix IN ('USER','REG','PROJ'))=3,
    'je Praefix eine Zeile: Konto-Kennung, Registernummer, Projektnummer';
END $$;

-- V6/B · Typisierter Freigabebezug --------------------------------------
-- 05.08.2026: Mandantenbezug ergaenzt. Zeichnung T4 macht ihn bei APP zur
-- Pflicht; die Aufsetzzeile folgt der Regel, nicht die Regel der Zeile.
INSERT INTO approval(objekt_art,objekt_id,anlass,mandantenbezug,tenant_id,
                     editor_actor_id,approver_actor_id)
VALUES ('APP','00000000-0000-0000-0000-0000000000f1','BEAUFTRAGUNG','MANDANT',
        '00000000-0000-0000-0000-000000000002',
        '00000000-0000-0000-0000-0000000000a1','00000000-0000-0000-0000-0000000000a2');

DO $$ BEGIN
  INSERT INTO mt SELECT 'MT-70','Freigabebezug typisiert, object_ref abgeleitet (K14-M08)',
    (SELECT object_ref = 'APP:00000000-0000-0000-0000-0000000000f1:BEAUFTRAGUNG'
       FROM approval WHERE objekt_art='APP' AND anlass='BEAUFTRAGUNG'),
    'Objektart, Schluessel und Anlass getrennt; der Text entsteht daraus';
END $$;

-- DER KERN VON V6/B: Beauftragung und Rueckweg aus der Pause sind
-- verschiedene Anlaesse. Ohne die vierte Spalte fielen sie zusammen, und
-- eine Freigabe fuer die Beauftragung liesse den Rueckweg mit durch.
DO $$ BEGIN
  INSERT INTO mt SELECT 'MT-71','Beauftragung und Rueckweg sind verschiedene Anlaesse (V6/B)',
    NOT EXISTS (SELECT 1 FROM approval
                 WHERE objekt_art='APP'
                   AND objekt_id='00000000-0000-0000-0000-0000000000f1'
                   AND anlass='PAUSIERT_NACH_BEAUFTRAGT'),
    'die Freigabe zur Beauftragung deckt den Rueckweg aus der Pause nicht mit ab';
END $$;

-- Gegentest K14-M08: ein Bezug auf ein Objekt, das es nicht gibt.
DO $$ BEGIN
  INSERT INTO approval(objekt_art,objekt_id,anlass,editor_actor_id,approver_actor_id)
  VALUES ('KNOWLEDGE_SOURCE','Q-GIBTS-NICHT','FREIGABE',
          '00000000-0000-0000-0000-0000000000a1','00000000-0000-0000-0000-0000000000a2');
  INSERT INTO mt VALUES ('MT-72','Freigabe auf ein fehlendes Objekt scheitert (K14-M08)',false,
    'FEHLER: wurde angenommen');
EXCEPTION WHEN others THEN
  INSERT INTO mt VALUES ('MT-72','Freigabe auf ein fehlendes Objekt scheitert (K14-M08)',
    SQLERRM LIKE '%FREIGABEBEZUG%', 'Meldung: '||SQLERRM);
END $$;

-- Gegentest: ein halber Bezug ist schlimmer als der alte Freitext.
DO $$ BEGIN
  INSERT INTO approval(objekt_art,editor_actor_id,approver_actor_id,object_ref)
  VALUES ('APP','00000000-0000-0000-0000-0000000000a1',
          '00000000-0000-0000-0000-0000000000a2','halb');
  INSERT INTO mt VALUES ('MT-73','Halber Freigabebezug scheitert (V6/B)',false,
    'FEHLER: wurde angenommen');
EXCEPTION WHEN others THEN
  INSERT INTO mt VALUES ('MT-73','Halber Freigabebezug scheitert (V6/B)',
    SQLERRM LIKE '%approval_bezug_ganz%', 'Meldung: '||SQLERRM);
END $$;

-- O-K08-1/5 · die drei Spalten aus K08-M23 (Stufe 10g) ----------------
DO $$ BEGIN
  INSERT INTO mt SELECT 'MT-74','K08-M23: die drei Spalten existieren (O-K08-1/5)',
    (SELECT count(*) FROM information_schema.columns
      WHERE table_name='knowledge_source'
        AND column_name IN ('short_description','meta_tags','owner_id','owner_label','zweck'))=5,
    'short_description, meta_tags, owner_id, owner_label, zweck';
END $$;

-- Gegentest K08-M23: ohne Pflichtangaben keine Freigabe.
INSERT INTO knowledge_source(id,type,origin,status,license,register_no)
VALUES ('Q-TS-2','OSS','EXTERN','DRAFT','MIT','TST-00009');
DO $$ BEGIN
  UPDATE knowledge_source SET status='RELEASED' WHERE id='Q-TS-2';
  INSERT INTO mt VALUES ('MT-75','Freigabe ohne Pflichtangaben scheitert (K08-M23)',false,
    'FEHLER: wurde angenommen');
EXCEPTION WHEN others THEN
  INSERT INTO mt VALUES ('MT-75','Freigabe ohne Pflichtangaben scheitert (K08-M23)',
    SQLERRM LIKE '%ks_released_braucht_pflichtangaben%', 'Meldung: '||SQLERRM);
END $$;

-- Gegentest Nr. 48: ein verknuepftes Konto ohne Namensschnappschuss ist
-- ein Datenverlust in spe -- wird das Konto geloescht, bleibt nichts.
DO $$ BEGIN
  UPDATE knowledge_source SET owner_label=NULL WHERE id='Q-TS-1';
  INSERT INTO mt VALUES ('MT-76','Konto ohne Namensschnappschuss scheitert (Nr. 48)',false,
    'FEHLER: wurde angenommen');
EXCEPTION WHEN others THEN
  INSERT INTO mt VALUES ('MT-76','Konto ohne Namensschnappschuss scheitert (Nr. 48)',
    SQLERRM LIKE '%ks_owner_paarweise%', 'Meldung: '||SQLERRM);
END $$;

-- Befund des Fremdreviews zu K15 (5.8.2026): Stufe 9a hat regelfrist_tage
-- angelegt, die Sicht retention_due aber weiter mit regelfrist_monate
-- gerechnet. Fuer ARBEITSERGEBNIS ist die Monatsspalte NULL -- die Sicht
-- lieferte faellig_am = NULL, und der Loeschlauf haette nichts bekommen.
-- MT-52 pruefte nur die GESPEICHERTEN Werte und meldete gruen.
DO $$
DECLARE d date;
BEGIN
  INSERT INTO direct_prototype(id,tenant_id,name,format,created_at)
  VALUES ('00000000-0000-0000-0000-0000000000d9',
          '00000000-0000-0000-0000-000000000002','Fristprobe','MD',
          now() - interval '100 days');
  SELECT faellig_am INTO d FROM retention_due
   WHERE objekt='direct_prototype' AND objekt_id='00000000-0000-0000-0000-0000000000d9';
  INSERT INTO mt VALUES ('MT-77','Tagesfrist wird in der Sicht gerechnet (K15, Stufe 9a)',
    d IS NOT NULL AND d <= current_date,
    CASE WHEN d IS NULL THEN 'FEHLER: faellig_am ist NULL -- die Sicht rechnet die '
                             'Tagesfrist nicht'
         ELSE 'faellig_am = ' || d || ' (90 Tage nach Erstellung, ueberfaellig)' END);
END $$;

-- Dieselbe Probe fuer die 30 Tage aus Nr. 17/35: KURZFRIST ist seit Stufe 9a
-- tagesgenau, die Sicht naeherte sie vorher als "1 month".
DO $$
DECLARE d date;
BEGIN
  SELECT faellig_am INTO d FROM retention_due
   WHERE objekt='login_code' LIMIT 1;
  INSERT INTO mt VALUES ('MT-78','Anmeldecode-Faelligkeit tagesgenau (Nr. 35)',
    d IS NOT NULL,
    CASE WHEN d IS NULL THEN 'FEHLER: keine Faelligkeit'
         ELSE 'faellig_am = ' || d END);
END $$;

DO $$ BEGIN
  INSERT INTO mt SELECT 'MT-79','Protokollzeilen tragen die Ereignisklasse (Nr. 60)',
    (SELECT column_default LIKE '%EREIGNIS%' FROM information_schema.columns
      WHERE table_name='event' AND column_name='retention_class')
    AND (SELECT regelfrist_monate IS NULL AND regelfrist_tage IS NULL
           AND pseudonymisieren_nach_monaten IS NULL
           FROM retention_rule WHERE class='EREIGNIS'),
    'Klasse EREIGNIS ohne Frist und ohne Anonymisierung, Vorgabewert an event';
END $$;

DO $$ BEGIN
  INSERT INTO mt SELECT 'MT-80','Projekte vor Stufe 05: 90 Tage, nicht 6 Monate (Nr. 58)',
    (SELECT regelfrist_tage=90 AND regelfrist_monate IS NULL AND mindestfrist_monate=0
       FROM retention_rule WHERE class='PROJEKT_VORVERTRAG'),
    'Nr. 58 verlangt die 30/60/90-Regel; Nr. 49 meint KI_NACHWEIS und BETRIEBSPROTOKOLL';
END $$;

-- Befunde F-09, F-12, F-13 aus den Fremdreviews zu K02 und K14 ---------
-- event ist append-only; der Fall muss beim INSERT scheitern, nicht beim
-- UPDATE -- sonst faengt ihn der Append-only-Waechter ab und der Gegentest
-- misst die falsche Regel (F07). Erster Anlauf tat genau das.
DO $$ BEGIN
  INSERT INTO event(tenant_id,source,action,actor_id,actor_label)
  VALUES ('00000000-0000-0000-0000-000000000002','PORTAL_ACTION','TEST_F09',
          '00000000-0000-0000-0000-0000000000a1', NULL);
  INSERT INTO mt VALUES ('MT-81','Konto ohne Namensschnappschuss scheitert (Nr. 48, K02-G13)',
    false,'FEHLER: wurde angenommen');
EXCEPTION WHEN others THEN
  INSERT INTO mt VALUES ('MT-81','Konto ohne Namensschnappschuss scheitert (Nr. 48, K02-G13)',
    SQLERRM LIKE '%event_actor_paarweise%', 'Meldung: '||SQLERRM);
END $$;

-- F-13: eine Freigabezeile wird nicht geaendert (K14-D09).
DO $$ BEGIN
  UPDATE approval SET objekt_id='00000000-0000-0000-0000-000000000999'
   WHERE objekt_art='APP';
  INSERT INTO mt VALUES ('MT-82','Freigabezeile unveraenderlich (K14-D09)',false,
    'FEHLER: wurde angenommen');
EXCEPTION WHEN others THEN
  INSERT INTO mt VALUES ('MT-82','Freigabezeile unveraenderlich (K14-D09)',
    SQLERRM LIKE '%APPEND-ONLY%', 'Meldung: '||SQLERRM);
END $$;

-- F-12: eine TYPISIERTE Agentenfreigabe muss den Release-Waechter passieren.
-- Vorher suchte er woertlich 'AGENT:<id>' und fand den typisierten Bezug nicht.
DO $$
DECLARE aid uuid; mid uuid;
BEGIN
  SELECT id INTO mid FROM model_ref LIMIT 1;
  INSERT INTO agent(id,name,model_ref_id,status)
  VALUES (gen_random_uuid(),'Pruefagent F-12',mid,'IN_REVIEW') RETURNING id INTO aid;
  UPDATE agent SET catalog_group='SINGLE', role_kind='test', review_score=90,
         output_form='JSON', allowed_actions='{}' WHERE id=aid;
  -- 05.08.2026: mandantenbezug ergaenzt. Ein Agent gilt ueber alle Mandanten;
  -- Zeichnung T4 verlangt, dass das dasteht statt aus einem leeren Feld
  -- gelesen zu werden.
  INSERT INTO approval(objekt_art,objekt_id,anlass,mandantenbezug,
                       editor_actor_id,approver_actor_id)
  VALUES ('AGENT',aid::text,'FREIGABE','GLOBAL',
          '00000000-0000-0000-0000-0000000000a1','00000000-0000-0000-0000-0000000000a2');
  UPDATE agent SET status='RELEASED' WHERE id=aid;
  INSERT INTO mt VALUES ('MT-83','Typisierte Agentenfreigabe wird erkannt (F-12)',
    true,'der Release-Waechter liest den typisierten Bezug');
EXCEPTION WHEN others THEN
  INSERT INTO mt VALUES ('MT-83','Typisierte Agentenfreigabe wird erkannt (F-12)',
    false,'FEHLER: '||SQLERRM);
END $$;

-- =====================================================================
-- ZEICHNUNGEN T4 UND T1 vom 5.8.2026 (Fremdreviews, Befunde F-14 und F-01/F-05)
-- =====================================================================

-- T4 · Positiv: Freigabe zu einer Anwendung, Mandant stimmt.
DO $$ BEGIN
  INSERT INTO approval(objekt_art,objekt_id,anlass,mandantenbezug,tenant_id,object_ref,editor_actor_id,approver_actor_id)
  VALUES ('APP','00000000-0000-0000-0000-0000000000f1','FREIGABE','MANDANT',
          '00000000-0000-0000-0000-000000000002','x','00000000-0000-0000-0000-0000000000a1','00000000-0000-0000-0000-0000000000a2');
  INSERT INTO mt VALUES ('MT-84','Anwendungsfreigabe mit richtigem Mandanten wird angenommen (T4)',
    true,'angenommen');
EXCEPTION WHEN others THEN
  INSERT INTO mt VALUES ('MT-84','Anwendungsfreigabe mit richtigem Mandanten wird angenommen (T4)',
    false,'FEHLER: '||SQLERRM);
END $$;

-- T4 · Gegentest: APP ohne Mandantenkennung.
DO $$ BEGIN
  INSERT INTO approval(objekt_art,objekt_id,anlass,mandantenbezug,object_ref,editor_actor_id,approver_actor_id)
  VALUES ('APP','00000000-0000-0000-0000-0000000000f1','FREIGABE','MANDANT','x','00000000-0000-0000-0000-0000000000a1','00000000-0000-0000-0000-0000000000a2');
  INSERT INTO mt VALUES ('MT-85','Anwendungsfreigabe ohne Mandant scheitert (T4, O-K14-2)',
    false,'FEHLER: wurde angenommen');
EXCEPTION WHEN others THEN
  INSERT INTO mt VALUES ('MT-85','Anwendungsfreigabe ohne Mandant scheitert (T4, O-K14-2)',
    SQLERRM LIKE '%approval_mandant_passt%', 'Meldung: '||SQLERRM);
END $$;

-- T4 · Gegentest: APP mit FREMDEM Mandanten. Das ist der Fall, den das
-- K14-Review meinte -- ein Kann-Feld haette ihn nicht einmal bemerkt.
DO $$ BEGIN
  INSERT INTO approval(objekt_art,objekt_id,anlass,mandantenbezug,tenant_id,object_ref,editor_actor_id,approver_actor_id)
  VALUES ('APP','00000000-0000-0000-0000-0000000000f1','FREIGABE','MANDANT',
          '00000000-0000-0000-0000-000000000001','x','00000000-0000-0000-0000-0000000000a1','00000000-0000-0000-0000-0000000000a2');
  INSERT INTO mt VALUES ('MT-86','Anwendungsfreigabe mit fremdem Mandanten scheitert (T4)',
    false,'FEHLER: wurde angenommen');
EXCEPTION WHEN others THEN
  INSERT INTO mt VALUES ('MT-86','Anwendungsfreigabe mit fremdem Mandanten scheitert (T4)',
    SQLERRM LIKE '%MANDANTENBEZUG%', 'Meldung: '||SQLERRM);
END $$;

-- T4 · Gegentest: GLOBAL und trotzdem ein Mandant. Das ist die stille
-- Doppelbedeutung, die T4 beendet.
DO $$ BEGIN
  INSERT INTO approval(objekt_art,objekt_id,anlass,mandantenbezug,tenant_id,object_ref,editor_actor_id,approver_actor_id)
  VALUES ('AGENT','00000000-0000-0000-0000-0000000000b1','FREIGABE','GLOBAL',
          '00000000-0000-0000-0000-000000000002','x','00000000-0000-0000-0000-0000000000a1','00000000-0000-0000-0000-0000000000a2');
  INSERT INTO mt VALUES ('MT-87','Globale Freigabe mit Mandant scheitert (T4)',
    false,'FEHLER: wurde angenommen');
EXCEPTION WHEN others THEN
  INSERT INTO mt VALUES ('MT-87','Globale Freigabe mit Mandant scheitert (T4)',
    SQLERRM LIKE '%approval_mandant_passt%', 'Meldung: '||SQLERRM);
END $$;

-- T1/F-05 · Traegt jede eigene Funktion einen festen Suchpfad? Gezaehlt, nicht
-- abgezaehlt: der Auftrag O-K13-1 nannte einmal eine Zahl, und sie war
-- ueberholt, bevor er ausgefuehrt wurde (F-06).
DO $$
DECLARE ohne int; ganz int;
BEGIN
  SELECT count(*) FILTER (WHERE p.proconfig IS NULL), count(*) INTO ohne, ganz
    FROM pg_proc p JOIN pg_namespace n ON n.oid = p.pronamespace
   WHERE n.nspname = 'public'
     AND NOT EXISTS (SELECT 1 FROM pg_depend d WHERE d.objid = p.oid AND d.deptype = 'e');
  INSERT INTO mt VALUES ('MT-88','Jede eigene Funktion hat einen festen Suchpfad (F-05)',
    ohne = 0 AND ganz > 0, ganz||' Funktionen, '||ohne||' ohne search_path');
END $$;

-- T1 · Gegentest mit einer ECHTEN Rolle. Er war bis zur Zeichnung vom 5.8.
-- nicht moeglich: es gab keine Rolle, gegen die er haette laufen koennen --
-- genau das hielt F-05 offen.
DO $$ BEGIN
  SET LOCAL ROLE fr_pruefung;
  INSERT INTO event(tenant_id,source,action,actor_label)
  VALUES ('00000000-0000-0000-0000-000000000002','PORTAL_ACTION','TEST_T1','pruefer');
  RESET ROLE;
  INSERT INTO mt VALUES ('MT-89','Die Abnahmerolle darf nicht schreiben (T1, K13-M18)',
    false,'FEHLER: wurde angenommen');
EXCEPTION WHEN others THEN
  RESET ROLE;
  INSERT INTO mt VALUES ('MT-89','Die Abnahmerolle darf nicht schreiben (T1, K13-M18)',
    SQLERRM LIKE '%denied for table event%' OR SQLERRM LIKE '%keine Berechtigung%',
    'Meldung: '||SQLERRM);
END $$;

-- T1 · Gegentest: Der Quellenbroker sieht die Konten nicht. Die Zeichnung
-- verbietet ihm actor, approval und login_code ausdruecklich.
DO $$ BEGIN
  SET LOCAL ROLE fr_broker;
  PERFORM 1 FROM actor LIMIT 1;
  RESET ROLE;
  INSERT INTO mt VALUES ('MT-90','Der Quellenbroker sieht die Konten nicht (T1)',
    false,'FEHLER: er durfte lesen');
EXCEPTION WHEN others THEN
  RESET ROLE;
  INSERT INTO mt VALUES ('MT-90','Der Quellenbroker sieht die Konten nicht (T1)',
    SQLERRM LIKE '%denied for table actor%' OR SQLERRM LIKE '%keine Berechtigung%',
    'Meldung: '||SQLERRM);
END $$;

-- P3 · Mehrere Einladungsdomaenen (Zeichnung vom 5.8.2026, O-K03-12) -----

-- Positiv: zwei Domaenen an einem Mandanten. Genau das ging vorher nicht.
DO $$ BEGIN
  INSERT INTO tenant_invite_domain(tenant_id,domain) VALUES
    ('00000000-0000-0000-0000-000000000002','demobank-privat.de'),
    ('00000000-0000-0000-0000-000000000002','demobank-firmen.de');
  INSERT INTO mt SELECT 'MT-91','Ein Mandant fuehrt mehrere Einladungsdomaenen (P3)',
    (SELECT count(*) FROM tenant_invite_domain
      WHERE tenant_id='00000000-0000-0000-0000-000000000002') >= 2,
    'mehrere Zeilen je Mandant moeglich';
EXCEPTION WHEN others THEN
  INSERT INTO mt VALUES ('MT-91','Ein Mandant fuehrt mehrere Einladungsdomaenen (P3)',
    false,'FEHLER: '||SQLERRM);
END $$;

-- Gegentest: Grossschreibung. Ohne diese Regel waeren Demobank.de und
-- demobank.de zwei Domaenen -- und die Schranke haette ein Loch.
DO $$ BEGIN
  INSERT INTO tenant_invite_domain(tenant_id,domain)
  VALUES ('00000000-0000-0000-0000-000000000002','Demobank.DE');
  INSERT INTO mt VALUES ('MT-92','Grossgeschriebene Domaene wird abgewiesen (P3)',
    false,'FEHLER: wurde angenommen');
EXCEPTION WHEN others THEN
  INSERT INTO mt VALUES ('MT-92','Grossgeschriebene Domaene wird abgewiesen (P3)',
    SQLERRM LIKE '%invite_domain_klein%', 'Meldung: '||SQLERRM);
END $$;

-- Gegentest: keine Domaene, sondern ein Wort.
DO $$ BEGIN
  INSERT INTO tenant_invite_domain(tenant_id,domain)
  VALUES ('00000000-0000-0000-0000-000000000002','demobank');
  INSERT INTO mt VALUES ('MT-93','Etwas ohne Punkt ist keine Domaene (P3)',
    false,'FEHLER: wurde angenommen');
EXCEPTION WHEN others THEN
  INSERT INTO mt VALUES ('MT-93','Etwas ohne Punkt ist keine Domaene (P3)',
    SQLERRM LIKE '%invite_domain_form%', 'Meldung: '||SQLERRM);
END $$;

-- Jede Aufnahme und jede Entfernung ist ein Protokolleintrag.
DO $$
DECLARE vorher int; nachher int;
BEGIN
  SELECT count(*) INTO vorher FROM event WHERE action='INVITE_DOMAIN_CHANGED';
  DELETE FROM tenant_invite_domain
   WHERE tenant_id='00000000-0000-0000-0000-000000000002'
     AND domain='demobank-privat.de';
  SELECT count(*) INTO nachher FROM event WHERE action='INVITE_DOMAIN_CHANGED';
  INSERT INTO mt VALUES ('MT-94','Entfernen einer Domaene wird protokolliert (P3)',
    nachher > vorher, 'Protokollzeilen vorher '||vorher||', nachher '||nachher);
END $$;

-- Stufe 14 · Der scharfe Rechteschnitt (Zeichnung 5.8.2026) --------------

-- =====================================================================
-- NACHGEZOGEN AM 16.08.2026 · MT-95, MT-95b UND MT-98
-- WORAUF SICH DIE AENDERUNG STUETZT -- UND WORAUF AUSDRUECKLICH NICHT
-- =====================================================================
-- Bis heute riefen diese drei Faelle create_app_after_fit in einer
-- Gestalt auf, die eine PROJEKTNUMMER UEBERGIBT ('DE-DMB_002_01',
-- 'DE-DMB_005_01', 'DE-DMB_004_01'). Diese Gestalt misst einen Weg, den
-- zwei GEZEICHNETE KLAUSELN verbieten:
--
--   K01-M38 · MUSS
--     "Die Projektnummer MUSS der serverseitige Befehl bilden, in
--      derselben Transaktion, in der die Anwendungszeile entsteht.
--      SIE WIRD VERGEBEN, NICHT EINGEGEBEN."
--
--   K01-D19 · DARF NICHT
--     "Kein Bildschirm, kein Formular und kein Endpunkt DARF die
--      Projektnummer zur Eingabe, Auswahl oder Aenderung anbieten.
--      EIN DENNOCH MITGESENDETER WERT WIRD VERWORFEN."
--
-- BEIDE KLAUSELN GALTEN VORHER. Ein Prueffall, der eine Projektnummer
-- uebergibt, war damit schon vorher falsch -- er ist nur nie
-- aufgefallen, weil eine zweite Fassung des Befehls offenstand, die den
-- Wert entgegennahm, und ihn trug.
--
-- DIE BEGRUENDUNG IST DIE KLAUSEL, NICHT DER BAU. Dass eine Fassung des
-- Befehls entfernt worden ist, ist NICHT der Grund dieser Aenderung und
-- traegt sie auch nicht. Traegt der Befehl morgen wieder einen Parameter
-- fuer die Projektnummer, wird dieser Fall NICHT zurueckgedreht -- er
-- meldet dann einen VERSTOSS gegen K01-M38 (siehe mt_lage unten).
--
-- KEIN PRUEFWERT WIRD GESENKT (K23-D05). Jeder der drei Faelle misst
-- weiterhin genau das, was er vorher gemessen hat, und zusaetzlich:
--   * MT-95  belegt die angelegte Zeile jetzt ueber die vom Befehl
--            ZURUECKGEGEBENE Kennung statt ueber eine vom Aufrufer
--            bestimmte Nummer, und prueft, dass die vergebene Nummer die
--            Form aus K01-M35/M38 traegt (drei Buchstaben = Kunden-Code).
--   * MT-95b findet die unter fr_portal entstandene Zeile ebenfalls ueber
--            die zurueckgegebene Kennung -- schaerfer als vorher, denn
--            damit ist belegt, dass der Rueckgabewert auf DIESE Zeile
--            zeigt.
--   * MT-98  ist unveraendert ein Negativfall an der Mandantenbedingung.
--
-- DIE GESTALT WIRD ERFRAGT, NICHT ANGENOMMEN. Wer sie raet, misst im
-- Fehlerfall "Funktion nicht vorhanden" -- also eine FREMDE Bedingung
-- (Massstab F07). mt_lage unten trennt drei Faelle sauber:
--   leer                    -> messbar
--   'VERSTOSS ...'          -> der Befehl nimmt eine Projektnummer
--                              entgegen: FEHLSCHLAG an K01-M38
--   'NICHT MESSBAR ...'     -> die Gestalt gibt den Aufruf nicht her:
--                              der Fall meldet das, statt es als
--                              fehlendes Recht auszugeben
-- =====================================================================
CREATE TEMP TABLE mt_befehl ON COMMIT DROP AS
WITH f AS (
  SELECT p.pronargs,
         coalesce(p.proargnames, ARRAY[]::text[]) AS namen,
         (SELECT coalesce(string_agg(format_type(t.typ,NULL), ',' ORDER BY t.pos),'')
            FROM unnest(p.proargtypes) WITH ORDINALITY AS t(typ,pos))  AS typen
    FROM pg_proc p WHERE p.proname = 'create_app_after_fit'
)
SELECT (SELECT count(*)        FROM f)                                        AS fassungen,
       (SELECT max(pronargs)   FROM f)                                        AS werte,
       (SELECT coalesce(string_agg(array_to_string(namen,','),' | '),'(keine)') FROM f) AS namen,
       (SELECT coalesce(string_agg(typen,' | '),'(keine)')                     FROM f) AS typen,
       (SELECT coalesce(string_agg(n,','),'')
          FROM f, unnest(f.namen) AS n
         WHERE n ~* '(project|projekt|nummer|(^|_)no$|(^|_)nr($|_))')          AS nr_param;

CREATE TEMP TABLE mt_lage ON COMMIT DROP AS
SELECT CASE
  WHEN b.fassungen = 0
    THEN 'NICHT MESSBAR: create_app_after_fit besteht nicht'
  -- Zuerst die Klausel, dann die Messbarkeit: ein Parameter fuer die
  -- Projektnummer ist kein fehlender Befund, sondern der Verstoss selbst.
  WHEN b.nr_param <> ''
    THEN 'VERSTOSS gegen K01-M38 ("sie wird vergeben, nicht eingegeben"): '
         ||'der Befehl nimmt eine Projektnummer entgegen -- Parameter: '||b.nr_param
  WHEN b.fassungen > 1
    THEN 'NICHT MESSBAR: es bestehen '||b.fassungen||' Fassungen von create_app_after_fit ('
         ||b.namen||'); welche gemeint ist, liesse sich nur raten'
  WHEN b.werte <> 4
    THEN 'NICHT MESSBAR: create_app_after_fit besteht nicht in der Gestalt mit vier Werten '
         ||'(gefunden: '||coalesce(b.werte::text,'—')||' -- '||b.namen||')'
  WHEN b.typen <> 'uuid,text,uuid,uuid'
    THEN 'NICHT MESSBAR: die Werte tragen die Typen '||b.typen||' statt uuid,text,uuid,uuid; '
         ||'die Zuordnung liesse sich nur raten'
  -- Drei der vier Werte sind uuid. Ohne Namen waere eine Vertauschung
  -- STILL -- der Fall scheiterte dann an einer fremden Bedingung, statt
  -- an seiner eigenen. Deshalb wird die Reihenfolge an den Namen geprueft.
  WHEN NOT (b.namen ~* '^[^,|]*(tenant|mandant)[^,|]*,[^,|]*(name|bezeichn)[^,|]*,[^,|]*(fit|check|eignung)[^,|]*,[^,|]*(actor|konto|account)[^,|]*$')
    THEN 'NICHT MESSBAR: die vier Werte heissen "'||b.namen||'"; welcher Wert wohin gehoert, '
         ||'liesse sich nur raten (erwartet der Reihe nach: Mandant, Name, Eignungs-Check, Konto)'
  ELSE ''
END AS lage
FROM mt_befehl b;

-- Positiv: der kanalisierte Weg funktioniert -- UND der Befehl vergibt
-- die Nummer selbst (K01-M38, K01-M35).
DO $$
DECLARE neu uuid; lage text; nr text;
BEGIN
  SELECT l.lage INTO lage FROM mt_lage l;
  IF lage <> '' THEN
    INSERT INTO mt VALUES ('MT-95','create_app_after_fit legt die Anwendung an, Nummer vergeben (O-K01-20, K01-M38)',
      false, lage);
  ELSE
    -- a3 ist Manfred Mueller beim Kunden (Mandant 2) -- das passende Konto.
    -- KEINE Projektnummer im Aufruf: sie wird vergeben, nicht eingegeben.
    neu := create_app_after_fit('00000000-0000-0000-0000-000000000002',
                                'Zweitanwendung',
                                '00000000-0000-0000-0000-0000000000e1',
                                '00000000-0000-0000-0000-0000000000a3');
    SELECT a.project_no INTO nr FROM app a WHERE a.id = neu;
    INSERT INTO mt VALUES ('MT-95','create_app_after_fit legt die Anwendung an, Nummer vergeben (O-K01-20, K01-M38)',
      neu IS NOT NULL AND nr ~ '^DE-DMB_[0-9]{3}_[0-9]{2}$',
      'Zeile angelegt: '||coalesce(neu::text,'—')||', vergebene Nummer: '||coalesce(nr,'—')
      ||' (Kunden-Code des Mandanten: DE-DMB, K01-M35)');
  END IF;
EXCEPTION WHEN others THEN
  INSERT INTO mt VALUES ('MT-95','create_app_after_fit legt die Anwendung an, Nummer vergeben (O-K01-20, K01-M38)',
    false,'FEHLER: '||SQLERRM);
END $$;

-- ---------------------------------------------------------------------
-- MT-95b · DIE OFFENE TUER (nachgetragen 16.08.2026)
--
-- WARUM ES IHN GIBT. MT-95 ruft den Befehl OHNE Rollenwechsel auf, also
-- als Eigentuemer der Datenbank. MT-96 und MT-97 messen, was dem
-- Portalpfad VERWEHRT ist. Damit misst diese Stelle bisher nur die
-- geschlossene Tuer: Fielen die Rechte-Anweisungen der Migration ersatzlos
-- weg, blieben MT-96 und MT-97 GRUEN -- ihnen genuegt, dass etwas
-- scheitert. Die Bauaufgabe L1 sagt dazu: "Ein Regime, das alles
-- verbietet, bestuende jeden Negativtest -- und die Anwendung liefe
-- nicht."
--
-- WAS ER MISST. Unter DERSELBEN Rolle, der MT-96 den direkten Weg
-- verwehrt, MUSS der vorgesehene Weg GELINGEN: fr_portal ruft
-- create_app_after_fit auf, und die Zeile entsteht wirklich. Erst beide
-- Faelle zusammen sind eine Unterscheidung -- verwehrt ist der eine Weg,
-- offen der andere.
--
-- WORAN ER SCHEITERT, WENN ER SCHEITERT: an seiner eigenen Bedingung.
-- Mandant, Konto und Eignungs-Check sind dieselben wie in MT-95, das
-- ohne Rollenwechsel gelingt. Unterschieden ist allein die Rolle. Fehlt
-- dem Portalpfad das Ausfuehrungsrecht -- oder laeuft der Befehl mit den
-- Rechten des Aufrufers statt mit denen seines Eigentuemers --, faellt
-- er hier auf.
--
-- NACHGEZOGEN AM 16.08.2026, gestuetzt auf K01-M38 und K01-D19 (Wortlaut
-- und Begruendung im Block ueber MT-95): der Aufruf uebergibt keine
-- Projektnummer mehr. Die entstandene Zeile wird ueber die vom Befehl
-- ZURUECKGEGEBENE Kennung wiedergefunden. Das misst mehr als vorher --
-- vorher belegte "eine Zeile mit DE-DMB_005_01" nur, dass irgendeine
-- Zeile mit dieser Nummer stand; jetzt ist belegt, dass der
-- Rueckgabewert auf genau diese Zeile zeigt.
--
-- Die Gestalt des Befehls wird nicht angenommen, sondern ERFRAGT
-- (mt_lage): gaebe es ihn in der klauselgemaessen Gestalt nicht,
-- scheiterte der Fall an "Funktion nicht vorhanden" -- also an einer
-- FREMDEN Bedingung. Dann meldet er das ausdruecklich, statt es als
-- fehlendes Recht auszugeben.
-- ---------------------------------------------------------------------
DO $$
DECLARE neu uuid; lage text; steht int; nr text;
BEGIN
  SELECT l.lage INTO lage FROM mt_lage l;
  IF lage <> '' THEN
    INSERT INTO mt VALUES ('MT-95b','Der Portalpfad DARF den Serverbefehl aufrufen (L1)',
      false,'NICHT GEMESSEN: '||lage||' -- der Rechteweg ist damit nicht pruefbar');
  ELSE
    SET LOCAL ROLE fr_portal;
    neu := create_app_after_fit('00000000-0000-0000-0000-000000000002',
                                'Ueber den Portalpfad',
                                '00000000-0000-0000-0000-0000000000e1',
                                '00000000-0000-0000-0000-0000000000a3');
    RESET ROLE;
    SELECT count(*) INTO steht FROM app WHERE id = neu;
    SELECT a.project_no INTO nr FROM app a WHERE a.id = neu;
    INSERT INTO mt VALUES ('MT-95b','Der Portalpfad DARF den Serverbefehl aufrufen (L1)',
      neu IS NOT NULL AND steht = 1,
      'unter fr_portal angelegt: '||coalesce(neu::text,'—')||', Zeilen zu dieser Kennung: '||steht
      ||', vergebene Nummer: '||coalesce(nr,'—'));
  END IF;
EXCEPTION WHEN others THEN
  RESET ROLE;
  INSERT INTO mt VALUES ('MT-95b','Der Portalpfad DARF den Serverbefehl aufrufen (L1)',
    false,'FEHLER unter fr_portal: '||SQLERRM);
END $$;

-- Gegentest: der Portalpfad kommt an der Tabelle nicht mehr vorbei.
DO $$ BEGIN
  SET LOCAL ROLE fr_portal;
  INSERT INTO app(tenant_id,project_no,name,created_at,fit_check_id)
  VALUES ('00000000-0000-0000-0000-000000000002','DE-DMB_003_01','Direkt',
          current_date,'00000000-0000-0000-0000-0000000000e1');
  RESET ROLE;
  INSERT INTO mt VALUES ('MT-96','Der Portalpfad darf app nicht direkt beschreiben (O-K01-20)',
    false,'FEHLER: wurde angenommen');
EXCEPTION WHEN others THEN
  RESET ROLE;
  INSERT INTO mt VALUES ('MT-96','Der Portalpfad darf app nicht direkt beschreiben (O-K01-20)',
    SQLERRM LIKE '%denied for table app%', 'Meldung: '||SQLERRM);
END $$;

-- Gegentest: actor.sealed bleibt dem Portalpfad verschlossen -- die
-- Zeichnung T1 verbietet es ausdruecklich, und ein Tabellen-UPDATE kennt
-- kein Spaltenverbot.
DO $$ BEGIN
  SET LOCAL ROLE fr_portal;
  UPDATE actor SET sealed = false
   WHERE id = '00000000-0000-0000-0000-0000000000a1';
  RESET ROLE;
  INSERT INTO mt VALUES ('MT-97','Der Portalpfad darf actor.sealed nicht aendern (T1)',
    false,'FEHLER: wurde angenommen');
EXCEPTION WHEN others THEN
  RESET ROLE;
  INSERT INTO mt VALUES ('MT-97','Der Portalpfad darf actor.sealed nicht aendern (T1)',
    SQLERRM LIKE '%denied for%' OR SQLERRM LIKE '%sealed%', 'Meldung: '||SQLERRM);
END $$;

-- Gegentest: der Befehl selbst prueft. Ein Konto eines fremden Mandanten
-- darf keine Anwendung anlegen (K14-D07).
--
-- NACHGEZOGEN AM 16.08.2026, gestuetzt auf K01-M38 und K01-D19 (Wortlaut
-- und Begruendung im Block ueber MT-95): der Aufruf uebergibt keine
-- Projektnummer mehr. Am Gemessenen aendert das nichts -- der Fall
-- scheitert an der MANDANTENBEDINGUNG, und die Meldung wird weiterhin
-- im Wortlaut auf die Kennung ANLAGE geprueft (Bauauftrag §9 Tor I
-- Nr. 6: ein Negativfall gilt erst als bestanden, wenn er an SEINER
-- eigenen Bedingung scheitert).
--
-- Ist die Gestalt des Befehls nicht messbar, meldet der Fall das
-- ausdruecklich -- sonst scheiterte er an "Funktion nicht vorhanden"
-- und waere ein bestandener Negativfall, der nichts gemessen hat.
DO $$
DECLARE lage text;
BEGIN
  SELECT l.lage INTO lage FROM mt_lage l;
  IF lage <> '' THEN
    INSERT INTO mt VALUES ('MT-98','Ein Konto fremden Mandanten legt nichts an (K01-M27)',
      false,'NICHT GEMESSEN: '||lage);
  ELSE
    -- a1 ist der Erst-Admin des Betreibers (Mandant 1) und hat beim Kunden
    -- nichts anzulegen (K14-D07).
    PERFORM create_app_after_fit('00000000-0000-0000-0000-000000000002',
                                 'Fremd',
                                 '00000000-0000-0000-0000-0000000000e1',
                                 '00000000-0000-0000-0000-0000000000a1');
    INSERT INTO mt VALUES ('MT-98','Ein Konto fremden Mandanten legt nichts an (K01-M27)',
      false,'FEHLER: wurde angenommen');
  END IF;
EXCEPTION WHEN others THEN
  INSERT INTO mt VALUES ('MT-98','Ein Konto fremden Mandanten legt nichts an (K01-M27)',
    SQLERRM LIKE '%ANLAGE%', 'Meldung: '||SQLERRM);
END $$;

-- Beschluss Nr. 85 · eine Region in Release 1.
DO $$ BEGIN
  UPDATE tenant SET processing_region = 'germanywestcentral'
   WHERE id = '00000000-0000-0000-0000-000000000002';
  INSERT INTO mt VALUES ('MT-99','Eine zweite Verarbeitungsregion wird abgewiesen (Nr. 85)',
    false,'FEHLER: wurde angenommen');
EXCEPTION WHEN others THEN
  INSERT INTO mt VALUES ('MT-99','Eine zweite Verarbeitungsregion wird abgewiesen (Nr. 85)',
    SQLERRM LIKE '%region_release_1%', 'Meldung: '||SQLERRM);
END $$;

-- Stufe 15 · H1 · Einschraenkung statt Loeschung (gez. A. Han) ----------

DO $$ BEGIN
  UPDATE app SET einschraenkung_ab = now(),
                 einschraenkung_grund = 'Loeschverlangen 05.08.2026, Frist laeuft'
   WHERE id = '00000000-0000-0000-0000-0000000000f1';
  INSERT INTO mt SELECT 'MT-100','Eine Anwendung laesst sich einschraenken (H1)',
    (SELECT count(*) FROM app_eingeschraenkt) = 1,
    'app_eingeschraenkt zeigt die gesperrte Zeile';
EXCEPTION WHEN others THEN
  INSERT INTO mt VALUES ('MT-100','Eine Anwendung laesst sich einschraenken (H1)',
    false,'FEHLER: '||SQLERRM);
END $$;

-- Gegentest: eine Einschraenkung ohne Grund ist eine Sperre, die niemand
-- erklaeren kann.
DO $$ BEGIN
  UPDATE app SET einschraenkung_ab = now(), einschraenkung_grund = NULL
   WHERE id = '00000000-0000-0000-0000-0000000000f1';
  INSERT INTO mt VALUES ('MT-101','Einschraenkung ohne Grund wird abgewiesen (H1)',
    false,'FEHLER: wurde angenommen');
EXCEPTION WHEN others THEN
  INSERT INTO mt VALUES ('MT-101','Einschraenkung ohne Grund wird abgewiesen (H1)',
    SQLERRM LIKE '%einschraenkung_ganz%', 'Meldung: '||SQLERRM);
END $$;

-- Gegentest: das Verlangen laesst sich nicht still zuruecknehmen.
DO $$ BEGIN
  UPDATE app SET einschraenkung_ab = NULL
   WHERE id = '00000000-0000-0000-0000-0000000000f1';
  INSERT INTO mt VALUES ('MT-102','Eine Einschraenkung ist nicht still aufhebbar (H1)',
    false,'FEHLER: wurde angenommen');
EXCEPTION WHEN others THEN
  INSERT INTO mt VALUES ('MT-102','Eine Einschraenkung ist nicht still aufhebbar (H1)',
    SQLERRM LIKE '%EINSCHRAENKUNG%', 'Meldung: '||SQLERRM);
END $$;

-- Stufe 16 · Die drei Nachtraege aus dem Delta-Review -------------------

-- 16a · Der Sitzungsabgleich greift, sobald der Serverpfad ihn setzt.
DO $$ BEGIN
  PERFORM set_config('freiraum.tenant_id',
                     '00000000-0000-0000-0000-000000000001', true);
  INSERT INTO approval(objekt_art,objekt_id,anlass,mandantenbezug,tenant_id,object_ref,
                       editor_actor_id,approver_actor_id)
  VALUES ('APP','00000000-0000-0000-0000-0000000000f1','FREIGABE','MANDANT',
          '00000000-0000-0000-0000-000000000002','x',
          '00000000-0000-0000-0000-0000000000a1','00000000-0000-0000-0000-0000000000a2');
  PERFORM set_config('freiraum.tenant_id','',true);
  INSERT INTO mt VALUES ('MT-103','Eine Freigabe fuer einen fremden Sitzungsmandanten scheitert (T4)',
    false,'FEHLER: wurde angenommen');
EXCEPTION WHEN others THEN
  PERFORM set_config('freiraum.tenant_id','',true);
  INSERT INTO mt VALUES ('MT-103','Eine Freigabe fuer einen fremden Sitzungsmandanten scheitert (T4)',
    SQLERRM LIKE '%SITZUNGSMANDANT%', 'Meldung: '||SQLERRM);
END $$;

-- 16a · Der Sitzungswaechter, beide Seiten. Die Ueberschrift lautete bis zum
-- 5.8.2026 abends noch "Ohne gesetzte Sitzung laesst der Waechter durch" --
-- das war der alte, fail-open Stand und widersprach dem Text darunter.
-- ZWEIMAL KORRIGIERT. Erst lautete der Fall "Ohne Sitzung schweigt der
-- Waechter" und bestand, WEIL er durchlaesst -- ein Fail-open als bestandener
-- Schutz. Dann machte ich daraus einen Positivtest; das zweite Auftragsreview
-- nannte das zu Recht eine Umbenennung statt einer Behebung.
-- Jetzt misst MT-104 die eingeschaltete Durchsetzung: Ist sie an und fehlt
-- die Sitzung, wird abgewiesen. MT-104b misst die Gegenseite -- passende
-- Sitzung, angenommen. Zwei Faelle, zwei Seiten, keine Behauptung.
DO $$ BEGIN
  PERFORM set_config('freiraum.rls_enforce','on',true);
  PERFORM set_config('freiraum.tenant_id','',true);
  INSERT INTO approval(objekt_art,objekt_id,anlass,mandantenbezug,tenant_id,object_ref,
                       editor_actor_id,approver_actor_id)
  VALUES ('APP','00000000-0000-0000-0000-0000000000f1','RUECKNAHME','MANDANT',
          '00000000-0000-0000-0000-000000000002','x',
          '00000000-0000-0000-0000-0000000000a1','00000000-0000-0000-0000-0000000000a2');
  PERFORM set_config('freiraum.rls_enforce','off',true);
  INSERT INTO mt VALUES ('MT-104','Eingeschaltete Durchsetzung weist eine Zeile ohne Sitzung ab (T4)',
    false,'FEHLER: wurde angenommen — fail-open trotz eingeschalteter Durchsetzung');
EXCEPTION WHEN others THEN
  PERFORM set_config('freiraum.rls_enforce','off',true);
  INSERT INTO mt VALUES ('MT-104','Eingeschaltete Durchsetzung weist eine Zeile ohne Sitzung ab (T4)',
    SQLERRM LIKE '%keine Sitzung gesetzt%', 'Meldung: '||SQLERRM);
END $$;

-- Die Gegenseite: passende Sitzung, Durchsetzung an -- angenommen.
DO $$ BEGIN
  PERFORM set_config('freiraum.rls_enforce','on',true);
  PERFORM set_config('freiraum.tenant_id',
                     '00000000-0000-0000-0000-000000000002', true);
  INSERT INTO approval(objekt_art,objekt_id,anlass,mandantenbezug,tenant_id,object_ref,
                       editor_actor_id,approver_actor_id)
  VALUES ('APP','00000000-0000-0000-0000-0000000000f1','RUECKNAHME','MANDANT',
          '00000000-0000-0000-0000-000000000002','x',
          '00000000-0000-0000-0000-0000000000a1','00000000-0000-0000-0000-0000000000a2');
  PERFORM set_config('freiraum.rls_enforce','off',true);
  PERFORM set_config('freiraum.tenant_id','',true);
  INSERT INTO mt VALUES ('MT-104b','Passende Sitzung wird auch bei Durchsetzung angenommen (T4)',
    true,'angenommen');
EXCEPTION WHEN others THEN
  PERFORM set_config('freiraum.rls_enforce','off',true);
  PERFORM set_config('freiraum.tenant_id','',true);
  INSERT INTO mt VALUES ('MT-104b','Passende Sitzung wird auch bei Durchsetzung angenommen (T4)',
    false,'FEHLER: '||SQLERRM);
END $$;

-- 16b · MITTELBAR wird ueber den Eigentuemer aufgeloest.
DO $$
DECLARE ks text;   -- knowledge_source.id ist eine Kennung wie Q-TS-1, keine UUID
BEGIN
  SELECT id INTO ks FROM knowledge_source LIMIT 1;
  IF ks IS NULL THEN
    -- KORRIGIERT nach Befund B03: Ohne Wissensquelle loest der geprufte
    -- Schutz gar nicht aus. Der Fall meldete trotzdem "bestanden" -- das
    -- ist ein nicht ausgefuehrter Test, kein bestandener. K23-M22 kennt
    -- dafuer einen eigenen Zustand, und der ist NICHT bestanden.
    INSERT INTO mt VALUES ('MT-105','Mittelbarer Bezug wird ueber den Eigentuemer geprueft (T4)',
      false,'NICHT AUSGEFUEHRT: keine Wissensquelle in den Testdaten — der '
            'Schutz wurde nicht ausgeloest. Kein Nachweis.');
  ELSE
    UPDATE knowledge_source SET owner_id='00000000-0000-0000-0000-0000000000a3',
           owner_label='Manfred Mueller' WHERE id=ks;
    BEGIN
      INSERT INTO approval(objekt_art,objekt_id,anlass,mandantenbezug,tenant_id,object_ref,
                           editor_actor_id,approver_actor_id)
      VALUES ('KNOWLEDGE_SOURCE',ks,'FREIGABE','MITTELBAR',
              '00000000-0000-0000-0000-000000000001','x',
              '00000000-0000-0000-0000-0000000000a1','00000000-0000-0000-0000-0000000000a2');
      INSERT INTO mt VALUES ('MT-105','Mittelbarer Bezug wird ueber den Eigentuemer geprueft (T4)',
        false,'FEHLER: wurde angenommen');
    EXCEPTION WHEN others THEN
      INSERT INTO mt VALUES ('MT-105','Mittelbarer Bezug wird ueber den Eigentuemer geprueft (T4)',
        SQLERRM LIKE '%MITTELBARER BEZUG%', 'Meldung: '||SQLERRM);
    END;
  END IF;
END $$;

-- 16c · Ein Fehlversuch erhoeht den Zaehler am offenen Code.
-- Eigenes Konto: die Adressen der uebrigen Prueffaelle tragen schon
-- Fehlversuche, und der Kontowaechter haette gesperrt, bevor die Kopplung
-- dran ist -- der Test waere an der falschen Regel gescheitert (F07).
INSERT INTO actor(id,tenant_id,email,display_name,status)
VALUES ('00000000-0000-0000-0000-0000000000a9','00000000-0000-0000-0000-000000000002',
        'kopplung@demobank.de','Kopplungs-Testkonto','AKTIV');

DO $$
DECLARE vorher int; nachher int; c uuid;
BEGIN
  INSERT INTO login_code(actor_id,code_hash,issued_at,expires_at)
  VALUES ('00000000-0000-0000-0000-0000000000a9','hash-kopplung',
          now(), now() + interval '10 minutes')
  RETURNING id, failed_count INTO c, vorher;
  INSERT INTO login_attempt(email,origin_hash,attempted_at,success)
  VALUES ('kopplung@demobank.de','k-herkunft-1',now(),false);
  SELECT failed_count INTO nachher FROM login_code WHERE id=c;
  INSERT INTO mt VALUES ('MT-106','Ein Fehlversuch erhoeht den Zaehler am Code (K03-M16)',
    nachher = vorher + 1, 'failed_count vorher '||vorher||', nachher '||nachher);
EXCEPTION WHEN others THEN
  INSERT INTO mt VALUES ('MT-106','Ein Fehlversuch erhoeht den Zaehler am Code (K03-M16)',
    false,'FEHLER: '||SQLERRM);
END $$;

-- 16c · Der fuenfte Fehlversuch entwertet den Code.
DO $$
DECLARE c uuid; ent timestamptz; n int;
BEGIN
  SELECT id INTO c FROM login_code WHERE code_hash='hash-kopplung';
  -- Vier weitere: zusammen mit dem aus MT-106 sind es fuenf. Der
  -- Kontowaechter laesst fuenf zu und sperrt erst den sechsten -- die
  -- Entwertung ist damit genau erreichbar.
  FOR i IN 2..5 LOOP
    INSERT INTO login_attempt(email,origin_hash,attempted_at,success)
    VALUES ('kopplung@demobank.de','k-herkunft-'||i,now(),false);
  END LOOP;
  SELECT superseded_at, failed_count INTO ent, n FROM login_code WHERE id=c;
  INSERT INTO mt VALUES ('MT-107','Der fuenfte Fehlversuch entwertet den Code (K03-M16)',
    ent IS NOT NULL, 'failed_count '||n||', '||
    CASE WHEN ent IS NULL THEN 'nicht entwertet' ELSE 'superseded_at gesetzt' END);
EXCEPTION WHEN others THEN
  INSERT INTO mt VALUES ('MT-107','Der fuenfte Fehlversuch entwertet den Code (K03-M16)',
    false,'FEHLER: '||SQLERRM);
END $$;

-- =====================================================================
-- NACHTRAG 6.8.2026 — die zwei Faelle zu den Befunden N-1 und N-2
-- =====================================================================

-- ---------------------------------------------------------------------
-- N-2: Der Freigabewaechter muss auch beim EINFUEGEN greifen.
--
-- Bis zum 6.8.2026 hing er allein am UPDATE -- und KEIN Prueffall dieser
-- Datei deckte den Weg ab: jeder Freigabefall hier laeuft ueber UPDATE
-- (zuletzt MT-83), der einzige INSERT mit Statusangabe setzt IN_REVIEW.
-- Die Luecke galt damit als geprueft, weil sie gruen dastand.
--
-- Ausgabeform, Handlungsliste und die Katalogfelder sind hier ABSICHTLICH
-- gefuellt: sonst koennte der Fall an agent_released_vollstaendig scheitern
-- statt am Waechter. Ein Gegentest, der an der falschen Regel scheitert,
-- ist nach F07 nicht bestanden.
-- ---------------------------------------------------------------------
DO $$
DECLARE mid uuid;
BEGIN
  SELECT id INTO mid FROM model_ref LIMIT 1;
  INSERT INTO agent(id,name,model_ref_id,status,output_form,allowed_actions,
                    catalog_group,role_kind,review_score)
  VALUES (gen_random_uuid(),'Pruefagent N-2',mid,'RELEASED','JSON','{}',
          'SINGLE','test',90);
  INSERT INTO mt VALUES ('MT-108','Agent direkt als RELEASED eingefuegt wird abgewiesen (Nr. 32, N-2)',
    false,'FEHLER: wurde angenommen — der Waechter greift beim INSERT nicht');
EXCEPTION WHEN others THEN
  INSERT INTO mt VALUES ('MT-108','Agent direkt als RELEASED eingefuegt wird abgewiesen (Nr. 32, N-2)',
    SQLERRM LIKE '%AGENT-FREIGABE%', 'Meldung: '||SQLERRM);
END $$;

-- ---------------------------------------------------------------------
-- N-1: Keine der sechs Dienstidentitaeten darf sich anmelden koennen.
-- Sie sind Rechteschnitte, keine Konten (T1, gezeichnet 5.8.2026).
--
-- GRENZE DIESES FALLS, ausdruecklich benannt: Er misst den ENDZUSTAND.
-- Der Befund N-1 betraf die NACHHAERTUNG einer Rolle, die VOR der Migration
-- schon mit LOGIN bestand. Dieser Fall laesst sich hier nicht herstellen,
-- weil die Migration zum Pruefzeitpunkt bereits gelaufen ist. Wer ihn
-- belegen will, legt vor dem ZWEITEN Migrationslauf eine der sechs Rollen
-- mit LOGIN an und prueft danach erneut -- das ist ein Schritt des Laufs,
-- kein Prueffall dieser Datei.
-- ---------------------------------------------------------------------
DO $$
DECLARE n int; wer text;
BEGIN
  SELECT count(*), coalesce(string_agg(rolname,', '),'-')
    INTO n, wer
    FROM pg_roles WHERE rolname LIKE 'fr\_%' AND rolcanlogin;
  INSERT INTO mt VALUES ('MT-109','Keine fr_*-Rolle ist anmeldbar (T1, N-1)',
    n = 0, CASE WHEN n = 0 THEN 'keine anmeldbar' ELSE 'anmeldbar: '||wer END);
EXCEPTION WHEN others THEN
  INSERT INTO mt VALUES ('MT-109','Keine fr_*-Rolle ist anmeldbar (T1, N-1)',
    false,'FEHLER: '||SQLERRM);
END $$;

-- =====================================================================
-- ERGEBNIS
-- =====================================================================
DO $$
DECLARE z record; n_ok int; n_all int;
BEGIN
  FOR z IN SELECT * FROM mt ORDER BY nr LOOP
    RAISE NOTICE '% · % — % · %', z.nr,
      CASE WHEN z.ok THEN 'BESTANDEN' ELSE '*** GESCHEITERT ***' END, z.name, z.meldung;
  END LOOP;
  SELECT count(*) FILTER (WHERE ok), count(*) INTO n_ok, n_all FROM mt;
  RAISE NOTICE '=======================================================';
  RAISE NOTICE 'SUMME: % von % bestanden, % gescheitert', n_ok, n_all, n_all - n_ok;
  IF n_ok < n_all THEN
    RAISE EXCEPTION 'PRUEFUNG NICHT BESTANDEN (% Fehlschlaege)', n_all - n_ok;
  END IF;
END $$;

ROLLBACK;   -- der Testlauf hinterlaesst nichts
