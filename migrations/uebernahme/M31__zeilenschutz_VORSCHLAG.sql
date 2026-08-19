-- =====================================================================
-- M31 · Das Zeilenschutz-Regime (RLS)
-- =====================================================================
--
-- VORSCHLAG ZUR UEBERNAHME, kein Liefergegenstand.
--
-- Der Bauauftrag weist L1 dem Auftragnehmer zu. Diese Datei nimmt ihm die
-- Arbeit nicht ab, sondern legt sie ihm daneben -- dasselbe Muster, das
-- M30 gegenueber freiraum_datamodel.sql einhaelt. Er uebernimmt sie,
-- aendert sie oder ersetzt sie; die Abnahme nach L1 bleibt unberuehrt.
--
-- WAS DIE ABNAHME NACH L1 VERLANGT und wo es hier steht:
--   1  Objektinventur, jede Tabelle auf genau einer Liste ... Stufe 1 + 2
--   2  Matrix Objekt x Operation x Rolle mit fachlicher Quelle ... Stufe 7
--   3  Je erlaubter Kombination ein Positivfall, je verbotener
--      ein Negativfall .............................. M31__pruefung.sql
--   4  Eigener Negativfall fuer Dienstschluessel und
--      ungesetzten Mandanten ....................... M31__pruefung.sql
--   5  Keine Rolle mit BYPASSRLS ......................... Stufe 6
--   6  Sichten mit aufrufenden Rechten ................... Stufe 5
--
-- DREI BEFUNDE, die beim Bauen aufgefallen sind und die der Auftrag
-- so noch nicht kennt -- sie stehen an Ort und Stelle im Text:
--   B-1  login_attempt traegt Personendaten ohne Mandantenbezug
--   B-2  nummernvorrat verraet Kundenpraefixe und laesst sich nicht
--        zeilenweise filtern
--   B-3  Es sind ZWOELF Sichten, nicht elf, und vier Tabellen erreichen
--        den Mandanten erst ueber ZWEI Fremdschluessel
--
-- Idempotent: laeuft zweimal hintereinander ohne Unterschied.
-- =====================================================================

BEGIN;

-- ---------------------------------------------------------------------
-- Stufe 0 · Der Schalter der Durchsetzung
-- ---------------------------------------------------------------------
-- Die Regeln filtern IMMER, sobald eine Sitzung gesetzt ist. Ohne Sitzung
-- entscheidet der Schalter: solange er aus ist, wird durchgelassen (Pilot);
-- steht er auf 'on', wird abgewiesen. Das ist genau die Bedingung, an der
-- MT-104 haengt -- dieselbe Regel, nicht eine zweite daneben.
CREATE OR REPLACE FUNCTION rls_erzwungen() RETURNS boolean
LANGUAGE sql STABLE SET search_path = public, pg_temp AS $$
  SELECT coalesce(current_setting('freiraum.rls_enforce', true), 'off') = 'on'
$$;

COMMENT ON FUNCTION rls_erzwungen() IS
  'L1: Solange aus, laesst eine fehlende Sitzung die Zeile durch. Steht er auf on, nicht mehr.';

-- ---------------------------------------------------------------------
-- Stufe 1 · Die Objektinventur
-- ---------------------------------------------------------------------
-- Abnahmekriterium 1 verlangt zwei Listen und sagt: "eine Tabelle, die auf
-- keiner der beiden Listen steht, ist ein Befund". Damit das nicht von der
-- Sorgfalt des Lesers abhaengt, ist die Inventur eine TABELLE und Stufe 2
-- rechnet sie nach.
CREATE TABLE IF NOT EXISTS rls_inventur (
  tabelle      text PRIMARY KEY,
  klasse       text NOT NULL CHECK (klasse IN ('WURZEL','UNMITTELBAR','MITTELBAR','GLOBAL')),
  weg          text,                       -- ueber welche Elterntabelle
  begruendung  text NOT NULL,
  quelle       text NOT NULL,              -- die fachliche Quelle (Kriterium 2)
  erfasst_am   timestamptz NOT NULL DEFAULT now()
);

COMMENT ON TABLE rls_inventur IS
  'L1 Kriterium 1: Jede Basistabelle steht hier mit Klasse und Begruendung. Stufe 2 prueft die Vollstaendigkeit.';

-- Die mandantenbezogenen Tabellen werden BERECHNET, nicht abgeschrieben.
-- Eine Liste von Hand veraltet mit der ersten neuen Tabelle; die Berechnung
-- nicht. Vier Tabellen erreichen den Mandanten erst ueber zwei
-- Fremdschluessel (contract_check, document_version, knowledge_module_source,
-- review_finding) -- eine einstufige Betrachtung uebersieht sie (Befund B-3).
DO $inv$
DECLARE r record;
BEGIN
  -- tenant selbst ist die Wurzel: es traegt keine Spalte tenant_id, sondern IST sie.
  INSERT INTO rls_inventur(tabelle,klasse,weg,begruendung,quelle) VALUES
    ('rls_inventur','GLOBAL',NULL,
     'Die Inventur selbst. Betriebsobjekt des Zeilenschutzes, kein Kundenbestand -- steht hier, damit die Vollstaendigkeitspruefung in Stufe 2 ohne Ausnahme auskommt.',
     'L1 Kriterium 1'),
    ('tenant','WURZEL',NULL,
     'Der Mandant selbst. Traegt keine Spalte tenant_id, sondern ist sie -- gefiltert wird ueber id.',
     'K02 Abschn. 5.2')
  ON CONFLICT (tabelle) DO NOTHING;

  FOR r IN
    WITH RECURSIVE
    bt AS (SELECT table_name::text AS table_name FROM information_schema.tables
            WHERE table_schema='public' AND table_type='BASE TABLE'),
    fk AS (SELECT k.conrelid::regclass::text AS kind, k.confrelid::regclass::text AS eltern
             FROM pg_constraint k
            WHERE k.contype='f'
              AND k.conrelid::regclass::text  IN (SELECT table_name FROM bt)
              AND k.confrelid::regclass::text IN (SELECT table_name FROM bt)),
    wurzel AS (SELECT DISTINCT c.table_name::text AS t, 'UNMITTELBAR'::text AS klasse, NULL::text AS weg, 0 AS stufe
                 FROM information_schema.columns c JOIN bt ON bt.table_name=c.table_name
                WHERE c.table_schema='public' AND c.column_name='tenant_id'
                UNION SELECT 'tenant','WURZEL',NULL,0),
    e AS (SELECT t,klasse,weg,stufe FROM wurzel
          UNION
          SELECT fk.kind,'MITTELBAR',fk.eltern,e.stufe+1
            FROM fk JOIN e ON e.t=fk.eltern
           WHERE e.stufe < 6 AND fk.kind <> fk.eltern)
    SELECT DISTINCT ON (t) t, klasse, weg, stufe FROM e ORDER BY t, stufe, weg
  LOOP
    IF r.t = 'tenant' THEN CONTINUE; END IF;
    INSERT INTO rls_inventur(tabelle,klasse,weg,begruendung,quelle)
    VALUES (r.t, r.klasse, r.weg,
      CASE WHEN r.klasse='UNMITTELBAR'
           THEN 'Traegt die Spalte tenant_id.'
           ELSE 'Erreicht den Mandanten ueber '||r.weg||' (Stufe '||r.stufe||').' END,
      'berechnet aus dem Fremdschluesselgraph, K13-M12')
    ON CONFLICT (tabelle) DO NOTHING;
  END LOOP;
END $inv$;

-- Die Tabellen OHNE Mandantenbezug -- je mit Begruendung, wie Kriterium 1
-- es verlangt. Diese Liste steht bewusst von Hand da: "kein Mandantenbezug"
-- ist eine fachliche Aussage, keine Eigenschaft des Fremdschluesselgraphen.
INSERT INTO rls_inventur(tabelle,klasse,weg,begruendung,quelle) VALUES
    ('agent','GLOBAL',NULL,$q$Katalog der sechzehn Agenten. Betreiberbestand, fuer alle Mandanten derselbe.$q$,$q$K13 Abschn. 3$q$),
    ('agent_knowledge','GLOBAL',NULL,$q$Verdrahtung Agent zu Wissensmodul. Katalogbeziehung ohne Kundenbezug.$q$,$q$K13$q$),
    ('agent_policy','GLOBAL',NULL,$q$Verdrahtung Agent zu Richtlinie. Katalogbeziehung.$q$,$q$K13$q$),
    ('agent_template','GLOBAL',NULL,$q$Verdrahtung Agent zu Vorlage. Katalogbeziehung.$q$,$q$K25$q$),
    ('fit_option','GLOBAL',NULL,$q$Antwortmoeglichkeiten des Eignungs-Checks. Fragebogen des Betreibers.$q$,$q$K04$q$),
    ('fit_question','GLOBAL',NULL,$q$Fragen des Eignungs-Checks. Fragebogen des Betreibers.$q$,$q$K04$q$),
    ('knowledge_module','GLOBAL',NULL,$q$Wissensmodule des Betreibers.$q$,$q$K09$q$),
    ('knowledge_module_version','GLOBAL',NULL,$q$Fassungen der Wissensmodule.$q$,$q$K09$q$),
    ('lifecycle_state_label','GLOBAL',NULL,$q$Anzeigetexte der Lebenslaufzustaende. Beschriftung.$q$,$q$K01$q$),
    ('login_attempt','GLOBAL',NULL,$q$SIEHE BEFUND B-1: personenbezogen, aber NICHT mandantenbezogen. Muss VOR jeder Sitzung lesbar sein, sonst laesst sich die Fehlversuchssperre nicht pruefen.$q$,$q$K03 Nr. 35$q$),
    ('model_manifest','GLOBAL',NULL,$q$Modellmanifest des Betreibers.$q$,$q$K17$q$),
    ('model_manifest_version','GLOBAL',NULL,$q$Fassungen des Modellmanifests.$q$,$q$K17$q$),
    ('model_ref','GLOBAL',NULL,$q$Modellverweise. Betreiberbestand.$q$,$q$K17$q$),
    ('module','GLOBAL',NULL,$q$Modulregister. Betreiberbestand.$q$,$q$K09$q$),
    ('nummernvorrat','GLOBAL',NULL,$q$SIEHE BEFUND B-2: fuehrt Kundenpraefixe. Kein Zeilenfilter moeglich - ein Zaehler hat keine Mandantenzeile.$q$,$q$K02$q$),
    ('policy','GLOBAL',NULL,$q$Richtlinien des Betreibers.$q$,$q$K13$q$),
    ('policy_version','GLOBAL',NULL,$q$Fassungen der Richtlinien.$q$,$q$K13$q$),
    ('portal','GLOBAL',NULL,$q$Die zwei Portale EXMA und ENDUSER. Betriebsstammdaten.$q$,$q$K19$q$),
    ('quick_option','GLOBAL',NULL,$q$Antwortmoeglichkeiten des Schnellwegs. Fragebogen des Betreibers.$q$,$q$K04 Nr. 55$q$),
    ('quick_question','GLOBAL',NULL,$q$Fragen des Schnellwegs.$q$,$q$K04 Nr. 55$q$),
    ('quick_question_version','GLOBAL',NULL,$q$Fassungen der Schnellwegfragen.$q$,$q$K04 Nr. 55$q$),
    ('retention_rule','GLOBAL',NULL,$q$Aufbewahrungsklassen und Fristen. Gelten fuer alle gleich.$q$,$q$K15$q$),
    ('role','GLOBAL',NULL,$q$Die zwei Rollen je Portal. Kein Rechte-Baukasten (K20-D01).$q$,$q$K20$q$),
    ('role_right','GLOBAL',NULL,$q$Rechtestufen je Rolle. Antizipation, in Release 1 nicht ausgewertet.$q$,$q$K20 F08$q$),
    ('schema_migration','GLOBAL',NULL,$q$Versionstabelle des Migrationsrahmens. Betriebsbestand.$q$,$q$M30 Stufe 1$q$),
    ('state_transition','GLOBAL',NULL,$q$Erlaubte Zustandswechsel. Regelwerk, kein Kundenbestand.$q$,$q$K01 Nr. 53$q$),
    ('template','GLOBAL',NULL,$q$Vorlagen des Betreibers.$q$,$q$K25$q$),
    ('template_element','GLOBAL',NULL,$q$Elemente der Vorlagen.$q$,$q$K25$q$),
    ('template_version','GLOBAL',NULL,$q$Fassungen der Vorlagen.$q$,$q$K25$q$)
ON CONFLICT (tabelle) DO NOTHING;

-- ---------------------------------------------------------------------
-- Stufe 2 · Die Inventur rechnet sich nach
-- ---------------------------------------------------------------------
DO $vollst$
DECLARE fehlend text; ueberzaehlig text;
BEGIN
  SELECT string_agg(t.table_name, ', ' ORDER BY t.table_name) INTO fehlend
    FROM information_schema.tables t
   WHERE t.table_schema='public' AND t.table_type='BASE TABLE'
     AND NOT EXISTS (SELECT 1 FROM rls_inventur i WHERE i.tabelle = t.table_name);
  IF fehlend IS NOT NULL THEN
    RAISE EXCEPTION 'RLS-INVENTUR unvollstaendig -- diese Tabellen stehen auf keiner Liste: %', fehlend
      USING ERRCODE = 'check_violation';
  END IF;

  SELECT string_agg(i.tabelle, ', ' ORDER BY i.tabelle) INTO ueberzaehlig
    FROM rls_inventur i
   WHERE NOT EXISTS (SELECT 1 FROM information_schema.tables t
                      WHERE t.table_schema='public' AND t.table_type='BASE TABLE'
                        AND t.table_name = i.tabelle);
  IF ueberzaehlig IS NOT NULL THEN
    RAISE EXCEPTION 'RLS-INVENTUR fuehrt Tabellen, die es nicht gibt: %', ueberzaehlig
      USING ERRCODE = 'check_violation';
  END IF;
END $vollst$;

-- ---------------------------------------------------------------------
-- Stufe 3 · Zeilenschutz einschalten -- ENABLE und FORCE
-- ---------------------------------------------------------------------
-- FORCE ist der Teil, den man leicht vergisst: Ohne ihn ist der EIGENTUEMER
-- der Tabelle von den Regeln ausgenommen, und die Migration laeuft als
-- Eigentuemer. Ein Regime, das den Eigentuemer auslaesst, prueft sich selbst
-- nie -- genau die Sorte gruener Nachweis, die dieses Projekt schon
-- mehrfach eingeholt hat.
DO $an$
DECLARE r record;
BEGIN
  FOR r IN SELECT tabelle FROM rls_inventur WHERE klasse <> 'GLOBAL' ORDER BY tabelle LOOP
    EXECUTE format('ALTER TABLE %I ENABLE ROW LEVEL SECURITY', r.tabelle);
    EXECUTE format('ALTER TABLE %I FORCE  ROW LEVEL SECURITY', r.tabelle);
  END LOOP;
END $an$;

-- ---------------------------------------------------------------------
-- Stufe 4 · Die Zeilenregeln
-- ---------------------------------------------------------------------
-- Je Tabelle EINE Regel fuer ALL -- nicht vier. Vier getrennte Regeln fuer
-- SELECT, INSERT, UPDATE und DELETE saehen gruendlicher aus und waeren es
-- nicht: Sie muessten viermal dasselbe Praedikat tragen, und die vierte
-- veraltet, sobald jemand die erste aendert. Die Matrix in Stufe 7 loest
-- die eine Regel wieder in vier Zeilen auf, weil die ABNAHME sie so verlangt.
--
-- Das Praedikat lautet ueberall gleich:
--    passender Mandant  ODER  (keine Sitzung UND Durchsetzung aus)
-- Mit gesetzter Sitzung wird also IMMER gefiltert, auch im Pilot. Nur die
-- fehlende Sitzung ist es, die der Schalter freigibt.
DO $regeln$
DECLARE
  r record; praedikat text; pk text; fkspalte text;
BEGIN
  FOR r IN SELECT * FROM rls_inventur WHERE klasse <> 'GLOBAL' ORDER BY tabelle LOOP

    IF r.klasse = 'WURZEL' THEN
      praedikat := '(id = sitzungs_mandant()) OR (sitzungs_mandant() IS NULL AND NOT rls_erzwungen())';

    ELSIF r.klasse = 'UNMITTELBAR' THEN
      praedikat := '(tenant_id = sitzungs_mandant()) OR (sitzungs_mandant() IS NULL AND NOT rls_erzwungen())';

    ELSE
      -- Mittelbar: der Mandant steht bei der Elterntabelle. Die Spalten
      -- werden aus dem Fremdschluessel GELESEN, nicht geraten.
      SELECT a.attname, af.attname INTO fkspalte, pk
        FROM pg_constraint k
        JOIN pg_attribute a  ON a.attrelid = k.conrelid  AND a.attnum = k.conkey[1]
        JOIN pg_attribute af ON af.attrelid = k.confrelid AND af.attnum = k.confkey[1]
       WHERE k.contype='f'
         AND k.conrelid::regclass::text  = r.tabelle
         AND k.confrelid::regclass::text = r.weg
       LIMIT 1;

      IF fkspalte IS NULL THEN
        RAISE EXCEPTION 'RLS: kein Fremdschluessel von % nach % gefunden', r.tabelle, r.weg
          USING ERRCODE = 'check_violation';
      END IF;

      praedikat := format(
        '(EXISTS (SELECT 1 FROM %I e WHERE e.%I = %I.%I)) OR (sitzungs_mandant() IS NULL AND NOT rls_erzwungen())',
        r.weg, pk, r.tabelle, fkspalte);
      -- Die Elterntabelle traegt selbst eine Regel und FORCE; der EXISTS
      -- laeuft damit ebenfalls gefiltert. Der Mandantenvergleich steht
      -- also genau EINMAL -- beim Elternteil -- und nicht in jeder
      -- Kindtabelle noch einmal abgeschrieben.
    END IF;

    EXECUTE format('DROP POLICY IF EXISTS %I ON %I', 'mandant_'||r.tabelle, r.tabelle);
    EXECUTE format('CREATE POLICY %I ON %I AS PERMISSIVE FOR ALL TO PUBLIC USING (%s) WITH CHECK (%s)',
                   'mandant_'||r.tabelle, r.tabelle, praedikat, praedikat);
  END LOOP;
END $regeln$;

-- ---------------------------------------------------------------------
-- Stufe 5 · Die Sichten laufen mit aufrufenden Rechten
-- ---------------------------------------------------------------------
-- Ohne security_invoker laeuft eine Sicht mit den Rechten ihres Erzeugers
-- und HEBELT DEN ZEILENSCHUTZ DER UNTERLIEGENDEN TABELLEN AUS. Zwoelf
-- geschuetzte Tabellen und eine ungeschuetzte Sicht darauf sind kein
-- Schutz, sondern ein zweiter Weg an ihm vorbei.
--
-- BEFUND B-3: Der Auftrag spricht von "den elf Sichten". Es sind ZWOELF.
DO $sichten$
DECLARE r record; n int := 0;
BEGIN
  FOR r IN SELECT c.relname FROM pg_class c JOIN pg_namespace ns ON ns.oid=c.relnamespace
            WHERE ns.nspname='public' AND c.relkind='v' ORDER BY c.relname LOOP
    EXECUTE format('ALTER VIEW %I SET (security_invoker = on)', r.relname);
    n := n + 1;
  END LOOP;
  RAISE NOTICE 'Sichten auf aufrufende Rechte umgestellt: %', n;
END $sichten$;

-- ---------------------------------------------------------------------
-- Stufe 6 · Keine Rolle mit BYPASSRLS
-- ---------------------------------------------------------------------
DO $bypass$
DECLARE schuldige text;
BEGIN
  SELECT string_agg(rolname, ', ' ORDER BY rolname) INTO schuldige
    FROM pg_roles WHERE rolbypassrls AND rolname NOT LIKE 'pg\_%';
  IF schuldige IS NOT NULL THEN
    RAISE WARNING 'BYPASSRLS gesetzt bei: % -- nach L1 Kriterium 5 unzulaessig fuer Laufzeitrollen', schuldige;
  END IF;
END $bypass$;

-- ---------------------------------------------------------------------
-- Stufe 7 · Die Matrix
-- ---------------------------------------------------------------------
-- Abnahmekriterium 2: je Objekt x Operation x Rolle eine Zeile mit der
-- greifenden Regel UND der fachlichen Quelle. Sie wird erzeugt, nicht
-- gepflegt -- eine von Hand gefuehrte Matrix weicht ab dem Tag ab, an dem
-- jemand eine Regel aendert und die Tabelle vergisst.
CREATE OR REPLACE VIEW rls_matrix AS
SELECT i.tabelle                              AS objekt,
       op.operation,
       rol.rolle,
       CASE WHEN i.klasse = 'GLOBAL' THEN '(kein Zeilenschutz)'
            ELSE 'mandant_' || i.tabelle END  AS regel,
       i.klasse,
       coalesce(i.weg, '-')                   AS ueber,
       CASE WHEN i.klasse = 'GLOBAL' THEN 'erlaubt, soweit die Rolle das Recht hat'
            ELSE 'nur Zeilen des Sitzungsmandanten' END AS wirkung,
       i.begruendung,
       i.quelle                               AS fachliche_quelle
  FROM rls_inventur i
 CROSS JOIN (VALUES ('SELECT'),('INSERT'),('UPDATE'),('DELETE')) AS op(operation)
 CROSS JOIN (VALUES ('fr_portal'),('fr_broker'),('fr_modell'),
                    ('fr_migration'),('fr_wartung'),('fr_pruefung')) AS rol(rolle);

-- CREATE OR REPLACE VIEW verwirft gesetzte Optionen. Stufe 5 hatte die
-- Sicht im zweiten Lauf bereits umgestellt -- und diese Anweisung hat es
-- wieder zunichte gemacht. Aufgefallen an einer Zahl, die nicht aufging:
-- 13 umgestellte Sichten, aber nur 12 mit gesetzter Option.
ALTER VIEW rls_matrix SET (security_invoker = on);

COMMENT ON VIEW rls_matrix IS
  'L1 Kriterium 2: Objekt x Operation x Rolle mit greifender Regel und fachlicher Quelle. Erzeugt, nicht gepflegt.';

COMMIT;

-- =====================================================================
-- Was diese Datei NICHT leistet -- damit es niemand annimmt
-- =====================================================================
-- 1  Sie schaltet freiraum.rls_enforce NICHT ein. Das geschieht nach L2,
--    wenn der Serverpfad den Mandanten hinterlegt -- vorher wuerde jeder
--    Zugriff ohne Sitzung abgewiesen, auch der berechtigte.
-- 2  Sie vergibt KEINE Tabellenrechte. Welche Rolle welche Tabelle
--    ueberhaupt anfassen darf, ist der Rechteschnitt aus T1 und steht in
--    M30 Stufe 12 und 14. Zeilenschutz kommt danach, nicht stattdessen.
-- 3  Sie loest B-1 und B-2 NICHT. Beide brauchen einen Rollenschnitt, kein
--    Zeilenpraedikat -- eine Entscheidung, keine Migration.
-- =====================================================================
