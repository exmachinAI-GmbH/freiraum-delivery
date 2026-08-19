-- =====================================================================
-- Pruefung des Zeilenschutz-Regimes (M31 · Bauaufgabe L1)
--
-- Laeuft NACH M30 und M31 auf derselben Datenbank. Alles in einer
-- Transaktion mit ROLLBACK am Ende -- der Testlauf hinterlaesst nichts.
--
-- MASSSTAB (F07): Ein Gegentest ist nur bestanden, wenn er an der
-- VORGESEHENEN Regel gescheitert ist. Ein Scheitern aus anderem Grund
-- ist NICHT bestanden, auch wenn es gruen aussieht.
--
-- WARUM DIESER TEST NICHT ALS SUPERUSER LAEUFT -- der wichtigste Satz
-- dieser Datei: Ein SUPERUSER UMGEHT DEN ZEILENSCHUTZ VOLLSTAENDIG, und
-- auch FORCE ROW LEVEL SECURITY hilft dagegen nicht (FORCE bindet den
-- EIGENTUEMER, nicht den Superuser). Beim ersten Lauf am 05.08.2026 sind
-- deshalb acht von zwanzig Faellen gescheitert -- nicht weil die Regeln
-- falsch waren, sondern weil der Pruefer ueber ihnen stand.
--
-- Der Test nimmt darum eine eigene Rolle an, die ALLE Tabellenrechte hat
-- und KEIN Superuser ist. Damit ist alles, was sie nicht sieht, allein
-- vom Zeilenschutz verborgen -- und nicht von einem fehlenden GRANT.
--
-- WARUM HIER POSITIVFAELLE STEHEN (L1 Kriterium 3b): Ein Regime, das
-- alles verbietet, bestuende jeden Negativtest -- und die Anwendung liefe
-- nicht. Zu jedem Verbot gehoert deshalb der Nachweis, dass das Erlaubte
-- erlaubt bleibt. Die Faelle stehen paarweise.
-- =====================================================================
BEGIN;

CREATE TEMP TABLE mt(nr text, name text, ok boolean, meldung text) ON COMMIT DROP;

-- Die Pruefrolle. NOLOGIN, kein Superuser, kein BYPASSRLS -- sie kann nur,
-- was der Zeilenschutz ihr laesst. Sie entsteht in dieser Transaktion und
-- verschwindet mit dem ROLLBACK.
DO $rolle$ BEGIN
  IF NOT EXISTS (SELECT 1 FROM pg_roles WHERE rolname='rls_pruefer') THEN
    CREATE ROLE rls_pruefer NOLOGIN NOSUPERUSER NOBYPASSRLS;
  END IF;
END $rolle$;
GRANT USAGE ON SCHEMA public TO rls_pruefer;
GRANT SELECT, INSERT, UPDATE, DELETE ON ALL TABLES IN SCHEMA public TO rls_pruefer;
GRANT ALL ON mt TO rls_pruefer;

-- Zwei Mandanten. Der Zeilenschutz laesst sich an einem einzigen nicht
-- pruefen -- ohne einen zweiten sieht jede Regel richtig aus.
INSERT INTO tenant(id,kind,name,customer_code,legal_space,processing_region)
VALUES ('aaaaaaaa-0000-0000-0000-000000000001','CUSTOMER','Mandant A','DE-AAA','DE','swedencentral'),
       ('bbbbbbbb-0000-0000-0000-000000000002','CUSTOMER','Mandant B','DE-BBB','DE','swedencentral')
ON CONFLICT (id) DO NOTHING;

INSERT INTO actor(id,tenant_id,email,display_name)
VALUES ('a0000000-0000-0000-0000-00000000000a','aaaaaaaa-0000-0000-0000-000000000001','anna@a.example','Anna A'),
       ('b0000000-0000-0000-0000-00000000000b','bbbbbbbb-0000-0000-0000-000000000002','bert@b.example','Bert B')
ON CONFLICT (id) DO NOTHING;

-- Je ein bestandener Eignungs-Check. Ohne ihn entsteht keine Anwendung --
-- der Eignungsriegel (K01-M27) weist sie ab. Das ist kein Hindernis fuer
-- diesen Test, sondern ein Beleg, dass die Riegel aus M30 weiter greifen,
-- waehrend der Zeilenschutz darueberliegt.
INSERT INTO fit_check(id,tenant_id,outcome,completed_at)
VALUES ('a2000000-0000-0000-0000-0000000000a2','aaaaaaaa-0000-0000-0000-000000000001','GEEIGNET',now()),
       ('b2000000-0000-0000-0000-0000000000b2','bbbbbbbb-0000-0000-0000-000000000002','GEEIGNET',now())
ON CONFLICT (id) DO NOTHING;

-- Je eine Anwendung, damit der mittelbare Weg (app_state_history ueber app)
-- ueberhaupt etwas zu filtern hat.
INSERT INTO app(id,tenant_id,project_no,name,fit_check_id,created_at)
VALUES ('a1000000-0000-0000-0000-0000000000a1','aaaaaaaa-0000-0000-0000-000000000001','DE-AAA_001_26','App A','a2000000-0000-0000-0000-0000000000a2',DATE '2026-03-01'),
       ('b1000000-0000-0000-0000-0000000000b1','bbbbbbbb-0000-0000-0000-000000000002','DE-BBB_001_26','App B','b2000000-0000-0000-0000-0000000000b2',DATE '2026-03-01')
ON CONFLICT (id) DO NOTHING;

-- Ab hier gilt der Zeilenschutz. Alles davor war Vorbereitung.
SET LOCAL ROLE rls_pruefer;

-- =====================================================================
-- 1 · Unmittelbarer Mandantenbezug -- das Paar aus Positiv und Negativ
-- =====================================================================
DO $$ DECLARE n int; BEGIN
  PERFORM set_config('freiraum.tenant_id','aaaaaaaa-0000-0000-0000-000000000001',true);
  SELECT count(*) INTO n FROM actor;
  INSERT INTO mt VALUES ('RL-01','Sitzung A sieht die eigene Zeile (Positivfall, K13-M12)',
    n = 1, 'sichtbare Zeilen: '||n);
END $$;

DO $$ DECLARE n int; BEGIN
  PERFORM set_config('freiraum.tenant_id','aaaaaaaa-0000-0000-0000-000000000001',true);
  SELECT count(*) INTO n FROM actor WHERE tenant_id='bbbbbbbb-0000-0000-0000-000000000002';
  INSERT INTO mt VALUES ('RL-02','Sitzung A sieht KEINE Zeile von B (Gegentest, K13-D04)',
    n = 0, 'sichtbare Fremdzeilen: '||n);
END $$;

DO $$ DECLARE n int; BEGIN
  PERFORM set_config('freiraum.tenant_id','bbbbbbbb-0000-0000-0000-000000000002',true);
  SELECT count(*) INTO n FROM actor;
  INSERT INTO mt VALUES ('RL-03','Sitzung B sieht ihre eigene Zeile -- die Regel filtert seitenrichtig',
    n = 1, 'sichtbare Zeilen: '||n);
END $$;

-- =====================================================================
-- 2 · Die Wurzel: tenant filtert ueber id, nicht ueber tenant_id
-- =====================================================================
DO $$ DECLARE n int; k text; BEGIN
  PERFORM set_config('freiraum.tenant_id','aaaaaaaa-0000-0000-0000-000000000001',true);
  SELECT count(*), max(customer_code) INTO n, k FROM tenant;
  INSERT INTO mt VALUES ('RL-04','Sitzung A sieht genau ihren eigenen Mandanten (WURZEL)',
    n = 1 AND k = 'DE-AAA', 'Zeilen: '||n||', Code: '||coalesce(k,'-'));
END $$;

-- =====================================================================
-- 3 · Schreiben ueber die Grenze -- WITH CHECK
-- =====================================================================
DO $$ BEGIN
  PERFORM set_config('freiraum.tenant_id','aaaaaaaa-0000-0000-0000-000000000001',true);
  INSERT INTO actor(id,tenant_id,email,display_name)
  VALUES ('c0000000-0000-0000-0000-00000000000c','bbbbbbbb-0000-0000-0000-000000000002','x@b.example','Fremd');
  INSERT INTO mt VALUES ('RL-05','Sitzung A darf keine Zeile fuer B anlegen (Gegentest)',
    false,'FEHLER: wurde angenommen');
EXCEPTION WHEN others THEN
  -- F07: Es genuegt nicht, DASS es scheitert. Es muss an der Zeilenregel
  -- scheitern -- SQLSTATE 42501 ist die Verletzung der WITH-CHECK-Klausel.
  INSERT INTO mt VALUES ('RL-05','Sitzung A darf keine Zeile fuer B anlegen (Gegentest)',
    SQLSTATE = '42501', 'SQLSTATE '||SQLSTATE||': '||SQLERRM);
END $$;

DO $$ DECLARE n int; BEGIN
  PERFORM set_config('freiraum.tenant_id','aaaaaaaa-0000-0000-0000-000000000001',true);
  INSERT INTO actor(id,tenant_id,email,display_name)
  VALUES ('d0000000-0000-0000-0000-00000000000d','aaaaaaaa-0000-0000-0000-000000000001','neu@a.example','Neu A');
  GET DIAGNOSTICS n = ROW_COUNT;
  INSERT INTO mt VALUES ('RL-06','Sitzung A darf fuer sich selbst anlegen (Positivfall zu RL-05)',
    n = 1, 'angelegte Zeilen: '||n);
EXCEPTION WHEN others THEN
  INSERT INTO mt VALUES ('RL-06','Sitzung A darf fuer sich selbst anlegen (Positivfall zu RL-05)',
    false, 'FEHLER: '||SQLERRM);
END $$;

-- =====================================================================
-- 4 · Mittelbarer Bezug -- der Mandant steht beim Elternteil
-- =====================================================================
DO $$ DECLARE n int; BEGIN
  PERFORM set_config('freiraum.tenant_id','',true);
  -- Nichts anzulegen: Ein Trigger aus M30 schreibt die erste Verlaufszeile
  -- beim Anlegen der Anwendung selbst. Der Fall prueft, DASS je Mandant
  -- genau eine mittelbare Zeile dasteht -- sonst misst RL-08 ins Leere.
  SELECT count(*) INTO n FROM app_state_history;
  INSERT INTO mt VALUES ('RL-07','Vorbereitung: je Mandant eine mittelbare Zeile vorhanden (ohne Sitzung gezaehlt)',
    n = 2, 'Verlaufszeilen gesamt: '||n);
EXCEPTION WHEN others THEN
  INSERT INTO mt VALUES ('RL-07','Vorbereitung: je Mandant eine mittelbare Zeile vorhanden (ohne Sitzung gezaehlt)',
    false, 'FEHLER: '||SQLERRM);
END $$;

DO $$ DECLARE fremd int; eigen int; BEGIN
  PERFORM set_config('freiraum.tenant_id','bbbbbbbb-0000-0000-0000-000000000002',true);
  -- Beim ersten Lauf am 05.08.2026 zaehlte dieser Fall ALLE Verlaufszeilen
  -- und meldete Fehlschlag -- dabei sah B genau seine eigene, also richtig.
  -- Der Fehler lag im Test, nicht im Regime. Jetzt werden beide Seiten
  -- getrennt gezaehlt: fremde muessen null sein, eigene sichtbar bleiben.
  SELECT count(*) INTO fremd FROM app_state_history
   WHERE app_id = 'a1000000-0000-0000-0000-0000000000a1';
  SELECT count(*) INTO eigen FROM app_state_history
   WHERE app_id = 'b1000000-0000-0000-0000-0000000000b1';
  INSERT INTO mt VALUES ('RL-08','Sitzung B sieht die mittelbare Zeile von A nicht, die eigene schon (Gegentest und Positivfall, ueber app)',
    fremd = 0 AND eigen = 1, 'fremde: '||fremd||', eigene: '||eigen);
END $$;

-- =====================================================================
-- 5 · Der ungesetzte Mandant -- beide Seiten des Schalters
-- =====================================================================
DO $$ DECLARE n int; BEGIN
  PERFORM set_config('freiraum.tenant_id','',true);
  PERFORM set_config('freiraum.rls_enforce','off',true);
  SELECT count(*) INTO n FROM actor;
  INSERT INTO mt VALUES ('RL-09','Ohne Sitzung und mit ausgeschalteter Durchsetzung wird durchgelassen (Pilot)',
    n >= 2, 'sichtbare Zeilen: '||n);
END $$;

DO $$ DECLARE n int; BEGIN
  PERFORM set_config('freiraum.tenant_id','',true);
  PERFORM set_config('freiraum.rls_enforce','on',true);
  SELECT count(*) INTO n FROM actor;
  -- Das ist der Fall, auf den E2 zielt: Vor dem ersten Mandanten mit
  -- echten Daten steht der Schalter auf on, und dann ist eine fehlende
  -- Sitzung kein Versehen mehr, sondern ein Zugriff ohne Berechtigung.
  INSERT INTO mt VALUES ('RL-10','Ohne Sitzung und mit EINGESCHALTETER Durchsetzung wird nichts sichtbar (Gegentest, E2)',
    n = 0, 'sichtbare Zeilen: '||n);
END $$;

DO $$ DECLARE n int; BEGIN
  PERFORM set_config('freiraum.tenant_id','aaaaaaaa-0000-0000-0000-000000000001',true);
  PERFORM set_config('freiraum.rls_enforce','on',true);
  SELECT count(*) INTO n FROM actor;
  INSERT INTO mt VALUES ('RL-11','Mit Sitzung bleibt bei eingeschalteter Durchsetzung alles Erlaubte erlaubt (Positivfall zu RL-10)',
    n >= 1, 'sichtbare Zeilen: '||n);
END $$;

-- =====================================================================
-- 6 · Globale Tabellen bleiben lesbar
-- =====================================================================
DO $$ DECLARE n int; BEGIN
  PERFORM set_config('freiraum.tenant_id','aaaaaaaa-0000-0000-0000-000000000001',true);
  PERFORM set_config('freiraum.rls_enforce','on',true);
  SELECT count(*) INTO n FROM retention_rule;
  INSERT INTO mt VALUES ('RL-12','Eine globale Tabelle bleibt trotz Zeilenschutz lesbar (Positivfall)',
    n > 0, 'Aufbewahrungsklassen: '||n);
END $$;

-- =====================================================================
-- 7 · Der Eigentuemer ist nicht ausgenommen -- FORCE
-- =====================================================================
DO $$ DECLARE n int; fehlend text; BEGIN
  SELECT count(*), string_agg(i.tabelle, ', ' ORDER BY i.tabelle)
    INTO n, fehlend
    FROM rls_inventur i
    JOIN pg_class c ON c.relname = i.tabelle
    JOIN pg_namespace ns ON ns.oid = c.relnamespace AND ns.nspname='public'
   WHERE i.klasse <> 'GLOBAL' AND NOT c.relforcerowsecurity;
  INSERT INTO mt VALUES ('RL-13','Jede mandantenbezogene Tabelle traegt FORCE ROW LEVEL SECURITY (Kriterium 1)',
    n = 0, CASE WHEN n=0 THEN 'alle' ELSE 'ohne FORCE: '||fehlend END);
END $$;

-- =====================================================================
-- 8 · Dienstschluessel -- keine Rolle darf am Regime vorbei
-- =====================================================================
DO $$ DECLARE schuldige text; BEGIN
  SELECT string_agg(rolname, ', ' ORDER BY rolname) INTO schuldige
    FROM pg_roles WHERE rolbypassrls AND rolname LIKE 'fr\_%';
  INSERT INTO mt VALUES ('RL-14','Keine Dienstidentitaet traegt BYPASSRLS (Kriterium 5, Gegentest)',
    schuldige IS NULL, coalesce('BYPASSRLS bei: '||schuldige, 'keine'));
END $$;

DO $$ DECLARE n int; BEGIN
  SELECT count(*) INTO n FROM pg_roles WHERE rolname LIKE 'fr\_%' AND rolcanlogin;
  INSERT INTO mt VALUES ('RL-15','Keine Dienstidentitaet kann sich anmelden (T1, Gegentest)',
    n = 0, 'mit Anmelderecht: '||n);
END $$;

-- =====================================================================
-- 9 · Die Sichten hebeln nichts aus
-- =====================================================================
DO $$ DECLARE n int; fehlend text; BEGIN
  SELECT count(*), string_agg(c.relname, ', ' ORDER BY c.relname) INTO n, fehlend
    FROM pg_class c JOIN pg_namespace ns ON ns.oid=c.relnamespace
   WHERE ns.nspname='public' AND c.relkind='v'
     AND NOT ('security_invoker=on' = ANY(coalesce(c.reloptions, ARRAY[]::text[])));
  INSERT INTO mt VALUES ('RL-16','Jede Sicht laeuft mit aufrufenden Rechten (Kriterium 6)',
    n = 0, CASE WHEN n=0 THEN 'alle' ELSE 'ohne security_invoker: '||fehlend END);
END $$;

DO $$ DECLARE n int; BEGIN
  PERFORM set_config('freiraum.tenant_id','bbbbbbbb-0000-0000-0000-000000000002',true);
  PERFORM set_config('freiraum.rls_enforce','on',true);
  SELECT count(*) INTO n FROM app_fit_ok WHERE tenant_id='aaaaaaaa-0000-0000-0000-000000000001';
  INSERT INTO mt VALUES ('RL-17','Eine Sicht zeigt B keine Zeile von A (Gegentest -- der zweite Weg am Schutz vorbei)',
    n = 0, 'sichtbare Fremdzeilen ueber die Sicht: '||n);
END $$;

-- =====================================================================
-- 10 · Die Inventur ist vollstaendig
-- =====================================================================
DO $$ DECLARE fehlend text; BEGIN
  SELECT string_agg(t.table_name, ', ' ORDER BY t.table_name) INTO fehlend
    FROM information_schema.tables t
   WHERE t.table_schema='public' AND t.table_type='BASE TABLE'
     AND NOT EXISTS (SELECT 1 FROM rls_inventur i WHERE i.tabelle = t.table_name);
  INSERT INTO mt VALUES ('RL-18','Jede Basistabelle steht auf genau einer Liste (Kriterium 1)',
    fehlend IS NULL, coalesce('ohne Eintrag: '||fehlend, 'vollstaendig'));
END $$;

DO $$ DECLARE n int; BEGIN
  SELECT count(*) INTO n FROM rls_matrix;
  INSERT INTO mt VALUES ('RL-19','Die Matrix fuehrt jede Kombination aus Objekt, Operation und Rolle (Kriterium 2)',
    n = (SELECT count(*) FROM rls_inventur) * 4 * 6, 'Zeilen: '||n);
END $$;

DO $$ DECLARE n int; BEGIN
  SELECT count(*) INTO n FROM rls_matrix WHERE fachliche_quelle IS NULL OR btrim(fachliche_quelle) = '';
  INSERT INTO mt VALUES ('RL-20','Jede Matrixzeile nennt eine fachliche Quelle (Kriterium 2, Gegentest)',
    n = 0, 'Zeilen ohne Quelle: '||n);
END $$;

RESET ROLE;

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
    RAISE EXCEPTION 'ZEILENSCHUTZ-PRUEFUNG NICHT BESTANDEN (% Fehlschlaege)', n_all - n_ok;
  END IF;
END $$;

ROLLBACK;
