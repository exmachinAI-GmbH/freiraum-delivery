-- =====================================================================
-- FREIRAUM · M32 · Zeilenschutz für drei Tabellen und der Stufenwechsel
-- =====================================================================
--
-- DER ERSTE BAUZUG AN M5. Er fasst drei gezeichnete Gegenstände an, und sie
-- gehören zusammen, weil sie dieselbe Stelle betreffen:
--
--   1  Zeilenregeln für `app`, `document`, `event`
--      Grundlage: arbeit/Vorlagen/m5_vor_dem_bauzug_260819.md, Entscheidung 1
--      ("der mittlere Weg"), gez. M. Veil und A. Han, 19.08.2026.
--      Getragen als RR-04 in nachweise/restrisiken/restrisiken.md.
--
--   2  `change_app_state` schreibt die `event`-Zeile ATOMAR mit
--      Grundlage: Blatt 99, Entscheidung 1 vom 19.08.2026 -- ausdruecklich
--      "vor dem ersten Aufruf in M5". K01-M21, K02-D04, K02-M12, K13-M20.
--
--   3  `set_journey_phase` -- der Schreibweg fuer die Stufe, den es bisher
--      NICHT GAB. Gemessen am 19.08.2026: `journey_phase` wird im ganzen
--      Bestand nirgends geschrieben, und `change_app_state` setzt
--      ausschliesslich `lifecycle_state`.
--      Grundlage: arbeit/Plaene/scheibe4_m5_entscheidung2_befehle.md;
--      K05-M08, K05-M19, K13-M09, K01-M05.
--
-- WOHER DIE ZEILENREGELN KOMMEN. Das Muster ist nicht erfunden, sondern
-- uebernommen: migrations/uebernahme/M31__zeilenschutz_VORSCHLAG.sql aus der
-- N2-Uebergabe (dort als "VORSCHLAG ZUR UEBERNAHME, kein Liefergegenstand"
-- gekennzeichnet, weil L1 dem Auftragnehmer gehoert). Uebernommen sind:
-- `rls_erzwungen()`, das Praedikatsmuster und FORCE. Eingeengt ist der
-- Umfang -- der Vorschlag deckt den ganzen Bestand ab, diese Migration die
-- drei Tabellen, die M5 anfasst. Das ist die gezeichnete Entscheidung,
-- nicht eine Bequemlichkeit: der ganze Punkt 09 beruehrt 57 Tabellen und
-- die bereits gebauten Wege M1 bis M4 und ist ein eigener Zug.
--
-- WAS SIE NICHT TUT
--   * Sie schaltet die Durchsetzung NICHT ein. `rls_erzwungen()` bleibt aus,
--     solange `freiraum.rls_enforce` nicht auf 'on' steht. Ohne gesetzte
--     Sitzung wird durchgelassen -- sonst faellt jeder bereits gebaute Weg
--     aus M1 bis M4 in derselben Sekunde aus, denn keiner setzt heute
--     `freiraum.tenant_id`. Das Setzen ist Zug 2 des Bauplans.
--   * Sie legt KEINE Tabelle an. K05-M25: "K05 besitzt weiterhin keine
--     Tabelle."
--   * Sie schreibt KEINE Verlaufszeile fuer den Stufenwechsel. Gezeichnet
--     als RR-05: `app_state_history.state` ist vom Typ `lifecycle_state`,
--     und der Synchron-Trigger feuert nur darauf. Der Nachweis des
--     Stufenwechsels entsteht in `event`.
--
-- IDEMPOTENT: laeuft zweimal hintereinander ohne Unterschied in Schema und
-- Daten. Die Zeilenregeln werden vor dem Anlegen weggeworfen, die
-- Funktionen mit CREATE OR REPLACE geschrieben.
-- =====================================================================

-- ---------------------------------------------------------------------
-- Stufe 1 · Der Schalter
-- ---------------------------------------------------------------------
-- Woertlich uebernommen aus dem Vorschlag der N2-Uebergabe.
--
-- Die Regeln filtern IMMER, sobald eine Sitzung gesetzt ist. Ohne Sitzung
-- entscheidet der Schalter: solange er aus ist, wird durchgelassen; steht
-- er auf 'on', wird abgewiesen.
CREATE OR REPLACE FUNCTION rls_erzwungen() RETURNS boolean
LANGUAGE sql STABLE SET search_path = public, pg_temp AS $$
  SELECT coalesce(current_setting('freiraum.rls_enforce', true), 'off') = 'on'
$$;

COMMENT ON FUNCTION rls_erzwungen() IS
  'L1: Solange aus, laesst eine fehlende Sitzung die Zeile durch. Steht er auf on, nicht mehr.';

-- ---------------------------------------------------------------------
-- Stufe 2 · Zeilenschutz einschalten -- ENABLE und FORCE
-- ---------------------------------------------------------------------
-- FORCE ist der Teil, den man leicht vergisst: Ohne ihn ist der EIGENTUEMER
-- der Tabelle von den Regeln ausgenommen -- und die Anwendung verbindet
-- sich heute als Eigentuemer (gemessen: kein SET ROLE, kein fr_portal in
-- app/). Ein Regime, das den Eigentuemer auslaesst, prueft sich selbst nie.
ALTER TABLE app      ENABLE ROW LEVEL SECURITY;
ALTER TABLE app      FORCE  ROW LEVEL SECURITY;
ALTER TABLE document ENABLE ROW LEVEL SECURITY;
ALTER TABLE document FORCE  ROW LEVEL SECURITY;
ALTER TABLE event    ENABLE ROW LEVEL SECURITY;
ALTER TABLE event    FORCE  ROW LEVEL SECURITY;

-- ---------------------------------------------------------------------
-- Stufe 3 · Die drei Zeilenregeln
-- ---------------------------------------------------------------------
-- Je Tabelle EINE Regel fuer ALL, mit demselben Praedikat in USING und
-- WITH CHECK. Vier getrennte Regeln fuer SELECT/INSERT/UPDATE/DELETE
-- saehen gruendlicher aus und waeren es nicht: die vierte veraltet, sobald
-- jemand die erste aendert.

-- app · UNMITTELBAR -- der Mandant steht in der Zeile (K01-M15).
DROP POLICY IF EXISTS mandant_app ON app;
CREATE POLICY mandant_app ON app AS PERMISSIVE FOR ALL TO PUBLIC
  USING      ((tenant_id = sitzungs_mandant()) OR (sitzungs_mandant() IS NULL AND NOT rls_erzwungen()))
  WITH CHECK ((tenant_id = sitzungs_mandant()) OR (sitzungs_mandant() IS NULL AND NOT rls_erzwungen()));

-- document · MITTELBAR ueber app -- und zwar AUSSCHLIESSLICH ueber
-- document.app_id -> app.tenant_id. Genau das verlangt K05-M27 im
-- Wortlaut; ein zweiter Mandantenwert an der Dokumentzeile waere ein
-- zweiter Strang und ist deshalb nicht Teil des Praedikats.
--
-- Der EXISTS laeuft selbst gefiltert, weil `app` eine Regel UND FORCE
-- traegt. Der Mandantenvergleich steht damit genau EINMAL -- bei der
-- Elterntabelle -- und nicht in jeder Kindtabelle abgeschrieben.
DROP POLICY IF EXISTS mandant_document ON document;
CREATE POLICY mandant_document ON document AS PERMISSIVE FOR ALL TO PUBLIC
  USING      ((EXISTS (SELECT 1 FROM app a WHERE a.id = document.app_id))
              OR (sitzungs_mandant() IS NULL AND NOT rls_erzwungen()))
  WITH CHECK ((EXISTS (SELECT 1 FROM app a WHERE a.id = document.app_id))
              OR (sitzungs_mandant() IS NULL AND NOT rls_erzwungen()));

-- event · UNMITTELBAR, mit einer benannten Ausnahme.
--
-- `event.tenant_id` ist NULLBAR, und das ist gewollt: nicht jeder Eintrag
-- haengt an einem Mandanten (K02-M21 spricht ausdruecklich vom
-- "mandantengebundenen Schreibvorgang"). Ein Praedikat, das nur
-- tenant_id = sitzungs_mandant() zuliesse, machte jeden mandantenlosen
-- Eintrag unsichtbar UND unschreibbar -- die Anmeldeversuche zuerst.
--
-- WAS DIESE AUSNAHME KOSTET, offen benannt: eine Sitzung sieht auch die
-- mandantenlosen Eintraege. Das sind per Definition keine Mandantendaten;
-- wer sie einschraenken will, braucht eine eigene Klasse, keine
-- Verschaerfung dieser Regel.
DROP POLICY IF EXISTS mandant_event ON event;
CREATE POLICY mandant_event ON event AS PERMISSIVE FOR ALL TO PUBLIC
  USING      ((tenant_id IS NULL OR tenant_id = sitzungs_mandant())
              OR (sitzungs_mandant() IS NULL AND NOT rls_erzwungen()))
  WITH CHECK ((tenant_id IS NULL OR tenant_id = sitzungs_mandant())
              OR (sitzungs_mandant() IS NULL AND NOT rls_erzwungen()));

-- ---------------------------------------------------------------------
-- Stufe 4 · change_app_state schreibt das Protokoll mit
-- ---------------------------------------------------------------------
-- Blatt 99, Entscheidung 1: "der Verlauf entscheidet mit" -- und der
-- Protokolleintrag entsteht ATOMAR mit dem Zustandswechsel, nicht daneben.
-- K02-D04: "Ein Schreibvorgang DARF NICHT gelten, wenn sein
-- Protokolleintrag ausbleibt. Beides entsteht gemeinsam oder gar nicht."
--
-- Der Rumpf ist unveraendert uebernommen; NEU sind allein die letzten
-- beiden Anweisungen. Was hier NICHT geprueft wird, wird auch jetzt nicht
-- geprueft: welche Uebergaenge erlaubt sind, entscheidet weiterhin
-- `state_transition` und der Waechter -- eine zweite Stelle mit derselben
-- Regel ist eine Stelle zu viel.
CREATE OR REPLACE FUNCTION change_app_state(p_app uuid, p_ziel lifecycle_state, p_actor uuid)
RETURNS void
LANGUAGE plpgsql SECURITY DEFINER SET search_path = public, pg_temp
AS $fn$
DECLARE v record; a record; v_vorher lifecycle_state;
BEGIN
  SELECT * INTO v FROM app WHERE id = p_app;
  IF v IS NULL THEN
    RAISE EXCEPTION 'ZUSTANDSWECHSEL: Anwendung % existiert nicht (K01-M28)', p_app
      USING ERRCODE = 'foreign_key_violation';
  END IF;

  SELECT * INTO a FROM actor WHERE id = p_actor;
  IF a IS NULL OR a.status <> 'AKTIV' THEN
    RAISE EXCEPTION 'ZUSTANDSWECHSEL: das Konto ist nicht aktiv (K01-M28)'
      USING ERRCODE = 'check_violation';
  END IF;
  IF a.tenant_id <> v.tenant_id THEN
    RAISE EXCEPTION 'ZUSTANDSWECHSEL: das Konto gehoert einem anderen Mandanten (K14-D07)'
      USING ERRCODE = 'check_violation';
  END IF;

  v_vorher := v.lifecycle_state;
  UPDATE app SET lifecycle_state = p_ziel WHERE id = p_app;

  -- K01-M21: Zeitpunkt, Projektnummer, handelnde Instanz, Wert davor und
  -- danach. K02-M13: Zeitpunkt, Aktion, Quelle. K02-M14: die Quelle traegt
  -- einen von zwei Werten. K02-M21: der Mandant des Eintrags ist der des
  -- Fachobjekts. K02-M15: bei einer Aenderung Wert vorher und jetzt.
  INSERT INTO event(id, occurred_at, project_no, tenant_id, actor_id, action,
                    object_ref, change_type, value, source, retention_class)
  VALUES (gen_random_uuid(), now(), v.project_no, v.tenant_id, p_actor,
          'app.lifecycle_state.changed',
          'app:' || p_app::text, 'UPDATE',
          format('lifecycle_state: %s -> %s', v_vorher, p_ziel),
          'PORTAL_ACTION', 'BETRIEBSPROTOKOLL');
END $fn$;

COMMENT ON FUNCTION change_app_state(uuid, lifecycle_state, uuid) IS
  'K01-M28 Zustandswechsel; seit M32 mit atomarem Protokolleintrag (Blatt 99, Entscheidung 1).';

-- ---------------------------------------------------------------------
-- Stufe 5 · set_journey_phase -- der Schreibweg fuer die Stufe
-- ---------------------------------------------------------------------
-- ES GAB IHN NICHT. Gemessen am 19.08.2026 gegen freiraum_ci: `fr_portal`
-- hat auf `app` nur SELECT -- auf jeder einzelnen Spalte, auch auf
-- `journey_phase`; ausfuehren durfte es genau zwei Funktionen, und keine
-- davon fasst die Stufe an. `UPDATE ... journey_phase` kommt in keiner
-- Migration und in keinem Anwendungscode vor.
--
-- EINE FUNKTION FUER BEIDE WECHSEL, nicht zwei. K05-M08 und K05-M19
-- beschreiben verschiedene NACHbedingungen (M19 uebergibt zusaetzlich an
-- K06), aber dieselbe VORbedingung und denselben Schreibvorgang. Die
-- Uebergabe an K06 ist die Grenze von M5, nicht sein Inhalt -- sie steht
-- hier deshalb nicht.
--
-- KEIN UEBERSPRINGEN, KEIN ZURUECK (K05-D06). Erlaubt sind genau die
-- beiden Uebergaenge, die M5 braucht. Jeder andere wird abgewiesen -- auch
-- der Sprung ueber eine Stufe, den kein Bildschirm anbietet, aber ein
-- direkter Aufruf versuchen koennte.
CREATE OR REPLACE FUNCTION set_journey_phase(p_app uuid, p_ziel journey_phase, p_actor uuid)
RETURNS void
LANGUAGE plpgsql SECURITY DEFINER SET search_path = public, pg_temp
AS $fn$
DECLARE v record; a record; v_vorher journey_phase; v_mitglied int;
BEGIN
  SELECT * INTO v FROM app WHERE id = p_app;
  IF v IS NULL THEN
    RAISE EXCEPTION 'STUFENWECHSEL: Anwendung % existiert nicht (K01-M28)', p_app
      USING ERRCODE = 'foreign_key_violation';
  END IF;

  -- Konto (K03-D01) und Mandant (K01-M15, K05-M24)
  SELECT * INTO a FROM actor WHERE id = p_actor;
  IF a IS NULL OR a.status <> 'AKTIV' THEN
    RAISE EXCEPTION 'STUFENWECHSEL: das Konto ist nicht aktiv (K03-D01)'
      USING ERRCODE = 'check_violation';
  END IF;
  IF a.tenant_id <> v.tenant_id THEN
    RAISE EXCEPTION 'STUFENWECHSEL: das Konto gehoert Mandant %, die Anwendung Mandant % (K01-M15)',
      a.tenant_id, v.tenant_id
      USING ERRCODE = 'check_violation';
  END IF;

  -- Mitgliedschaft und Rolle (K05-M24, K13-M05). Die ausreichende Rolle ist
  -- gezeichnet und keine Wahl: das Endnutzer-Portal fuehrt in Release 1
  -- genau EINE Rolle (F08 ueber K14-G04 und K20-M02; DDL Z. 685-687).
  -- Geprueft wird deshalb die Mitgliedschaft im Portal ENDUSER mit
  -- Reichweite auf den Mandanten der Anwendung -- die Rolle faellt damit
  -- zusammen (T-4, gez. A. Han 19.08.2026).
  SELECT count(*) INTO v_mitglied
    FROM membership m
    JOIN role r ON r.id = m.role_id
   WHERE m.actor_id = p_actor
     AND m.portal_code = 'ENDUSER'
     AND m.tenant_scope = v.tenant_id
     AND r.portal_code = 'ENDUSER';
  IF v_mitglied = 0 THEN
    RAISE EXCEPTION 'STUFENWECHSEL: keine Mitgliedschaft im Endnutzer-Portal fuer diesen Mandanten (K05-M24)'
      USING ERRCODE = 'insufficient_privilege';
  END IF;

  v_vorher := v.journey_phase;

  IF NOT ((v_vorher = 'ORIENTIERUNG' AND p_ziel = 'INTERVIEW')
       OR (v_vorher = 'INTERVIEW'    AND p_ziel = 'UEBERSICHT')) THEN
    RAISE EXCEPTION 'STUFENWECHSEL: % nach % ist kein Uebergang von M5 (K05-D06, K05-M08, K05-M19)',
      v_vorher, p_ziel
      USING ERRCODE = 'check_violation';
  END IF;

  UPDATE app SET journey_phase = p_ziel WHERE id = p_app;

  -- Derselbe Zug, nicht der naechste (K02-D04, K13-M20).
  INSERT INTO event(id, occurred_at, project_no, tenant_id, actor_id, action,
                    object_ref, change_type, value, source, retention_class)
  VALUES (gen_random_uuid(), now(), v.project_no, v.tenant_id, p_actor,
          'app.journey_phase.changed',
          'app:' || p_app::text, 'UPDATE',
          format('journey_phase: %s -> %s', v_vorher, p_ziel),
          'PORTAL_ACTION', 'BETRIEBSPROTOKOLL');
END $fn$;

COMMENT ON FUNCTION set_journey_phase(uuid, journey_phase, uuid) IS
  'K05-M08/K05-M19: der einzige Schreibweg fuer app.journey_phase. Protokolleintrag atomar.';

-- Der Portalpfad darf ihn aufrufen -- und nur ihn. Die Spalte selbst bleibt
-- fuer fr_portal lesend (K13-M09: "der Client uebergibt keine Stufe").
DO $rechte$
BEGIN
  IF EXISTS (SELECT 1 FROM pg_roles WHERE rolname = 'fr_portal') THEN
    EXECUTE 'GRANT EXECUTE ON FUNCTION set_journey_phase(uuid, journey_phase, uuid) TO fr_portal';
  END IF;
END $rechte$;

-- ---------------------------------------------------------------------
-- Stufe 6 · Der Lauf rechnet sich selbst nach
-- ---------------------------------------------------------------------
-- Eine Migration, die nur durchlaeuft, hat nichts bewiesen.
DO $nachweis$
DECLARE fehlt text := '';
BEGIN
  IF NOT EXISTS (SELECT 1 FROM pg_proc WHERE proname='set_journey_phase') THEN
    fehlt := fehlt || 'set_journey_phase fehlt; '; END IF;
  IF NOT EXISTS (SELECT 1 FROM pg_proc WHERE proname='rls_erzwungen') THEN
    fehlt := fehlt || 'rls_erzwungen fehlt; '; END IF;
  IF (SELECT count(*) FROM pg_policies
       WHERE schemaname='public' AND tablename IN ('app','document','event')) <> 3 THEN
    fehlt := fehlt || 'es sind nicht genau drei Zeilenregeln; '; END IF;
  IF (SELECT count(*) FROM pg_class
       WHERE relname IN ('app','document','event') AND relrowsecurity AND relforcerowsecurity) <> 3 THEN
    fehlt := fehlt || 'ENABLE oder FORCE fehlt an einer der drei Tabellen; '; END IF;
  IF fehlt <> '' THEN
    RAISE EXCEPTION 'M32 NICHT VOLLSTAENDIG: %', fehlt USING ERRCODE = 'check_violation';
  END IF;
  RAISE NOTICE 'M32 · drei Zeilenregeln mit FORCE, change_app_state mit Protokoll, set_journey_phase angelegt.';
END $nachweis$;
