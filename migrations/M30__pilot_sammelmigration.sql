-- =====================================================================
-- FREIRAUM - Sammelmigration v2.9 -> v3.0-pilot  (VORSCHLAG, 4.8.2026)
--
-- Setzt die 29 Zeilen der Aenderungsmatrix (uebergabe/matrix_rohdaten/daten.py)
-- in ausfuehrbares SQL um, in der Reihenfolge der acht Stufen aus dem
-- Pruefbericht, Abschnitt 8.
--
-- REGELN DIESES SKRIPTS
--   * freiraum_datamodel.sql in v2.9_PIVOT/ ist eingefroren. Der Harness
--     aendert dort nichts. Diese Datei ist der Vorschlag zur Uebernahme
--     (dasselbe Muster wie arbeit/Migration_260801_tenant.sql).
--   * Idempotent: Ein zweiter Lauf aendert nichts (Gegentest der Zeile
--     Nr. 26). Jede Anweisung ist entsprechend geschuetzt.
--   * Eine einzige Migration, kein Teilstand: Der Hauptteil laeuft in
--     EINER Transaktion. Nur die Enum-Erweiterungen stehen davor, weil
--     ein neuer Enum-Wert in derselben Transaktion nicht benutzbar ist.
--   * Frische Datenbank, kein Altbestand (H06 Schritt 1). Rueckfuellungen
--     entfallen deshalb; wo sie bei Altbestand noetig waeren, steht ein
--     Kommentar.
--
-- QUELLEN DER ZAHLEN (nichts erfunden):
--   Nr. 17  Aufraeumfrist Einladungen: 30 Tage nach Ablauf
--           (Pflichtangabe vom 3.8.2026; ersetzt die 90 Tage der
--           urspruenglichen Option A und die 90 Tage aus
--           freiraum_datamodel_v2.9.md Z. 130)
--   Nr. 33  eigene Sitzungstabelle, Beginn + letzte Aktivitaet je Geraet
--   Nr. 35  5 Fehlversuche je Konto -> 15 Min Wartezeit;
--           20 je Herkunft binnen 1 h -> 60 Min Sperre;
--           Codes 30 Tage nach Verbrauch oder Ablauf geloescht
--   Nr. 49  sechs Monate fuer Projekte vor Stufe 05 (Option B)
--   Nr. 61  Codegueltigkeit 10 Minuten (Option A)
--   H01     Projektvertrag: 5 Seiten, Ueberschreitung ausweisen
--   H02     Zustandsmatrix: 20 Wechsel, W17 zwei Personen,
--           EINGELADEN unbenutzbar
--   F1/F6   (4.8.2026) Kenntnisnahme an fit_check; template_element
--
-- ENTSCHIEDEN am 4.8.2026 (Entscheidungsvorlage "Der Weg auf Gruen",
-- gez. M. Veil) und in dieser Datei umgesetzt:
--   [E2] Wertelisten und Geltungsbereich der sechs Merkmale (Nr. 24 /
--        Punkt 17): Stufe 3l. Achtzehn Werte, alle sechs Spalten
--        NULL-faehig, Pflicht nur im Vorlagen-Universum.
--   [E3] Anmeldecode: es gilt der Bau-Vorschlag 260802_anmeldecode.sql
--        (login_code, mail_delivery) -- Stufe 3b/3c.
--
-- OFFEN — dieses Skript laesst bewusst aus, was nicht entschieden ist:
--   [N1] Namen der zwei neuen Aufbewahrungsklassen sind VORSCHLAG:
--        'KURZFRIST' (30 Tage) und 'PROJEKT_VORVERTRAG' (6 Monate).
--   [N2] retention_rule rechnet in Monaten; die 30 Tage aus Nr. 17/35
--        stehen deshalb als 1 Monat. Wer tagesgenau will, braucht eine
--        Spalte regelfrist_tage — als Befund vermerkt, nicht gebaut.
--   [K1] kanon.yaml wird ERST NACH Uebernahme dieses Skripts nachgezogen
--        (Entscheidung F6): tabellen 37 -> 46, sichten 11 -> 11,
--        enums 30 -> 39, trigger 4 -> 15. Ein Kanon-Eintrag ohne
--        DDL-Zeile waere eine Behauptung gegen Rang 1. Die Zahlen sind
--        nach der Uebernahme gegen die laufende Datenbank zu zaehlen,
--        nicht aus diesem Kommentar abzuschreiben.
-- =====================================================================

-- ---------------------------------------------------------------------
-- VORAB (ausserhalb der Haupttransaktion): Enum-Erweiterungen
-- ---------------------------------------------------------------------
ALTER TYPE retention_class ADD VALUE IF NOT EXISTS 'KURZFRIST';          -- [N1][N2]
ALTER TYPE retention_class ADD VALUE IF NOT EXISTS 'PROJEKT_VORVERTRAG'; -- [N1] Nr. 49
-- 05.08.2026, Stufe 9a: vierte Klasse fuer Arbeitsergebnisse
-- (O-K12-1, A-K12-1, O-K15-8). Muss hier stehen und nicht unten:
-- ein neuer Enum-Wert ist in derselben Transaktion nicht benutzbar.
ALTER TYPE retention_class ADD VALUE IF NOT EXISTS 'ARBEITSERGEBNIS';
-- 05.08.2026, F-08: eigene Klasse fuer unveraenderbare Ereigniszeilen
-- (Nr. 60, K02-M17) -- ohne Faelligkeit und ohne Anonymisierung.
ALTER TYPE retention_class ADD VALUE IF NOT EXISTS 'EREIGNIS';

DO $$ BEGIN
  IF NOT EXISTS (SELECT 1 FROM pg_type WHERE typname = 'transition_authority') THEN
    CREATE TYPE transition_authority AS ENUM ('SYSTEM','VERWALTER','ZWEI_PERSONEN');
  END IF;
END $$;

BEGIN;

-- =====================================================================
-- STUFE 1 · Rahmen (Nr. 26) — Versionstabelle, Idempotenz
-- =====================================================================
CREATE TABLE IF NOT EXISTS schema_migration (
  version      text        PRIMARY KEY,
  beschreibung text        NOT NULL,
  applied_at   timestamptz NOT NULL DEFAULT now()
);

-- Der Eintrag entsteht am ENDE dieser Datei. Ein zweiter Lauf findet ihn
-- vor und aendert trotzdem nichts — jede Anweisung ist selbst geschuetzt.
-- (Gegentest Nr. 26: Migration zweimal ausfuehren, zweiter Lauf leer.)

-- =====================================================================
-- STUFE 2 · Aufbewahrungsklassen und Fristen (Nr. 17 · 35 · 49 · 58 · 60)
-- =====================================================================
-- VORGEZOGEN AUS DEM NACHTRAG VOM 5.8.2026 (Stufe 9a). Die Tagesspalte
-- steht hier und nicht unten, weil die Sicht retention_due sie benennt --
-- und die Sicht entsteht vor Stufe 9. Der Grund fuer die Spalte steht
-- dort, bei Stufe 9a.
ALTER TABLE retention_rule ADD COLUMN IF NOT EXISTS regelfrist_tage integer;

DO $$ BEGIN
  -- Die Bedingung bezugsobjekt_ohne_frist las bisher: keine Monatsfrist
  -- GENAU DANN, wenn die Frist am Bezugsobjekt haengt. Mit der Tagesspalte
  -- ist das zu eng -- eine Klasse mit Tagesfrist traegt keine Monatsfrist
  -- und haengt trotzdem nicht am Bezugsobjekt.
  IF EXISTS (SELECT 1 FROM pg_constraint WHERE conname = 'bezugsobjekt_ohne_frist') THEN
    ALTER TABLE retention_rule DROP CONSTRAINT bezugsobjekt_ohne_frist;
  END IF;
  IF NOT EXISTS (SELECT 1 FROM pg_constraint WHERE conname = 'genau_eine_frist') THEN
    ALTER TABLE retention_rule ADD CONSTRAINT genau_eine_frist
      CHECK ( (fristbeginn = 'BEZUGSOBJEKT'
               AND regelfrist_monate IS NULL AND regelfrist_tage IS NULL)
           OR (fristbeginn <> 'BEZUGSOBJEKT'
               AND (regelfrist_monate IS NULL) <> (regelfrist_tage IS NULL)) );
  END IF;
  IF NOT EXISTS (SELECT 1 FROM pg_constraint WHERE conname = 'tagesfrist_positiv') THEN
    ALTER TABLE retention_rule ADD CONSTRAINT tagesfrist_positiv
      CHECK (regelfrist_tage IS NULL OR regelfrist_tage > 0);
  END IF;
END $$;

-- KURZFRIST: offene Einladungen (Nr. 17, 30 Tage nach Ablauf), Anmeldecodes
-- und Versandnachweise (Nr. 35, 30 Tage nach Verbrauch/Ablauf). [N2]
INSERT INTO retention_rule(class,bezeichnung,fristbeginn,regelfrist_monate,
                           mindestfrist_monate,pseudonymisieren_nach_monaten,rechtsgrundlage)
VALUES ('KURZFRIST','Kurzlebige Zugangsartefakte (Einladungen, Anmeldecodes, Versandnachweise)',
        'ERSTELLUNG',1,1,NULL,
        'Beschluss Nr. 17 (Pflichtangabe 3.8.2026: 30 Tage) und Nr. 35; DSGVO Art. 5 Abs. 1 lit. e')
ON CONFLICT (class) DO NOTHING;

-- PROJEKT_VORVERTRAG: Projekte vor Stufe 05 (Nr. 49: sechs Monate, Option B;
-- Zuordnung nach Nr. 58 Option A mit gestuftem Termin).
INSERT INTO retention_rule(class,bezeichnung,fristbeginn,regelfrist_monate,
                           regelfrist_tage,mindestfrist_monate,
                           pseudonymisieren_nach_monaten,rechtsgrundlage)
VALUES ('PROJEKT_VORVERTRAG','Projekte vor Vertragsschluss (vor Stufe 05)',
        'ERSTELLUNG',NULL,90,0,NULL,
        'Beschluss Nr. 58 (30/60/90-Regel fuer untaetige Projekte); DSGVO Art. 5 Abs. 1 lit. e')
ON CONFLICT (class) DO UPDATE
  SET regelfrist_tage = 90, regelfrist_monate = NULL, mindestfrist_monate = 0;
-- KORRIGIERT am 5.8.2026 nach dem Fremdreview zu K15 (Befund F-02): Die Klasse
-- trug sechs Monate unter Berufung auf Nr. 49. Nr. 49 ordnet die sechs Monate
-- aber KI_NACHWEIS und BETRIEBSPROTOKOLL zu -- nicht Projekten vor Stufe 05.
-- Fuer die verlangt Nr. 58 die 30/60/90-Regel, also Loeschung nach 90 Tagen.
-- Mit sechs Monaten Mindestfrist waere sie ausgeschlossen gewesen.

-- Zuordnung der Bestandsprojekte (Nr. 58): entfaellt auf frischer Datenbank.
-- Bei Altbestand: UPDATE app SET retention_class='PROJEKT_VORVERTRAG'
--   WHERE lifecycle_state IN ('DISCOVERY','IN_BEARBEITUNG') AND sealed_at IS NULL;

-- =====================================================================
-- STUFE 3 · Fehlende Tabellen und Felder
-- =====================================================================

-- 3a · Sitzungsspeicher (Nr. 33) --------------------------------------
CREATE TABLE IF NOT EXISTS auth_session (
  id               uuid PRIMARY KEY DEFAULT gen_random_uuid(),
  actor_id         uuid NOT NULL REFERENCES actor(id) ON DELETE CASCADE,
  device_label     text,                                  -- "Rechner" / "Handy" — je Geraet (Nr. 33)
  started_at       timestamptz NOT NULL DEFAULT now(),
  last_activity_at timestamptz NOT NULL DEFAULT now(),    -- das Zifferblatt der Parkuhr
  ended_at         timestamptz,
  CONSTRAINT session_ende_nach_beginn CHECK (ended_at IS NULL OR ended_at >= started_at),
  CONSTRAINT session_aktivitaet_nach_beginn CHECK (last_activity_at >= started_at)
);
CREATE INDEX IF NOT EXISTS auth_session_actor_idx ON auth_session (actor_id);
-- Die 30-Minuten-Regel prueft das Programm bei jedem Aufruf (Nr. 33) —
-- die Datenablage liefert nur last_activity_at. Kein Trigger dafuer.
-- Nr. 34 (zwei Sicherheitstests) misst an dieser Tabelle; die Tests
-- stehen in M30__pruefung.sql, MT-20/MT-21.

-- 3b · Codespeicher (Nr. 35 · 61) -------------------------------------
-- NAMENSKONFLIKT ENTSCHIEDEN am 4.8.2026 (Entscheidung E3, Moeglichkeit A,
-- M. Veil): Es gilt der Bau-Vorschlag migrations/260802_anmeldecode.sql aus
-- dem Repo freiraum-delivery. Er ist am 2.8.2026 beim Bau von B2 gegen eine
-- laufende v2.9-Datenbank geprueft worden; was in einem echten Lauf gehalten
-- hat, sticht das, was nur auf Papier steht.
--
-- Die frueher hier gebaute Fassung ist damit hinfaellig. Uebernommen ist der
-- Bau-Vorschlag mit seinen Spalten (issued_at statt sent_at, superseded_at,
-- failed_count), seinem Teilindex und seinem Ausloeser. Ergaenzt ist allein,
-- was der Bau-Vorschlag nicht kennen konnte, weil es erst diese Migration
-- einfuehrt: retention_class (Nr. 17 · 35 · 49).
--
-- Ein Unterschied bleibt bewusst stehen: die Fuenf-Fehlversuche-Regel gibt es
-- jetzt zweimal, auf zwei Ebenen. login_code.failed_count zaehlt je Code
-- (K03-M16), login_attempt zaehlt je Adresse und Zeitfenster (Nr. 35). Das
-- ist keine Dopplung, sondern zwei verschiedene Fragen -- "ist dieser Code
-- verbraucht" und "wird diese Adresse gerade durchprobiert".
CREATE TABLE IF NOT EXISTS login_code (
  id            uuid PRIMARY KEY DEFAULT gen_random_uuid(),
  actor_id      uuid NOT NULL REFERENCES actor(id) ON DELETE CASCADE,
  code_hash     text NOT NULL,                    -- nur der Pruefwert (K03-M15)
  issued_at     timestamptz NOT NULL DEFAULT now(),
  -- Die Frist rechnet die DATENBANK, nicht der Aufrufer. Solange der Aufrufer
  -- sie mitgibt, KANN er eine laengere mitgeben (Befund aus dem Lauf 2.8.).
  expires_at    timestamptz NOT NULL DEFAULT (now() + interval '10 minutes'),
  consumed_at   timestamptz,                      -- gesetzt = verbraucht
  superseded_at timestamptz,                      -- gesetzt = durch neueren entwertet
  failed_count  smallint NOT NULL DEFAULT 0,
  retention_class retention_class NOT NULL DEFAULT 'KURZFRIST' REFERENCES retention_rule(class),
  CONSTRAINT login_code_frist
    CHECK (expires_at <= issued_at + interval '10 minutes'),   -- Nr. 61 / K03-M15
  CONSTRAINT login_code_fehlversuche
    CHECK (failed_count BETWEEN 0 AND 5),                      -- K03-M16
  CONSTRAINT login_code_ende_eindeutig
    CHECK (consumed_at IS NULL OR superseded_at IS NULL)
);
CREATE INDEX IF NOT EXISTS login_code_actor_idx ON login_code (actor_id, issued_at DESC);

-- Genau EIN offener Code je Konto -- K03-M15 als Bedingung statt als Absicht.
CREATE UNIQUE INDEX IF NOT EXISTS login_code_nur_einer_offen
  ON login_code (actor_id)
  WHERE consumed_at IS NULL AND superseded_at IS NULL;

-- Ein neuer Code entwertet die aelteren. Ohne diesen Ausloeser muesste jede
-- aufrufende Stelle daran denken -- und eine Regel, die nur gilt, solange
-- jemand an sie denkt, ist keine Regel.
CREATE OR REPLACE FUNCTION login_code_entwertet_aeltere() RETURNS trigger
LANGUAGE plpgsql AS $$
BEGIN
  UPDATE login_code
     SET superseded_at = clock_timestamp()
   WHERE actor_id = NEW.actor_id
     AND id <> NEW.id
     AND consumed_at IS NULL
     AND superseded_at IS NULL;
  RETURN NEW;
END $$;

CREATE OR REPLACE TRIGGER login_code_entwertet_aeltere_trg
  BEFORE INSERT ON login_code
  FOR EACH ROW EXECUTE FUNCTION login_code_entwertet_aeltere();

CREATE TABLE IF NOT EXISTS login_attempt (
  id            uuid PRIMARY KEY DEFAULT gen_random_uuid(),
  email         text NOT NULL,          -- auch fuer Adressen ohne Konto (Nr. 35: Herkunftssperre)
  origin_hash   text NOT NULL,          -- Herkunft, gehasht — Zustaendigkeit It. Nr. 35 eingetragen
  attempted_at  timestamptz NOT NULL DEFAULT now(),
  success       boolean NOT NULL,
  retention_class retention_class NOT NULL DEFAULT 'KURZFRIST' REFERENCES retention_rule(class)
);
CREATE INDEX IF NOT EXISTS login_attempt_email_idx  ON login_attempt (email, attempted_at);
CREATE INDEX IF NOT EXISTS login_attempt_origin_idx ON login_attempt (origin_hash, attempted_at);

-- Sperren aus Nr. 35: 5 Fehlversuche je Konto -> 15 Minuten Wartezeit;
-- 20 Fehlversuche je Herkunft binnen einer Stunde -> 60 Minuten Sperre.
CREATE OR REPLACE FUNCTION login_attempt_guard() RETURNS trigger LANGUAGE plpgsql AS $$
DECLARE n_konto integer; n_herkunft integer;
BEGIN
  SELECT count(*) INTO n_konto FROM login_attempt
   WHERE email = NEW.email AND NOT success
     AND attempted_at > now() - interval '15 minutes';
  IF n_konto >= 5 THEN
    RAISE EXCEPTION 'KONTO-SPERRE: 5 Fehlversuche, 15 Minuten Wartezeit (Nr. 35)'
      USING ERRCODE = 'check_violation';
  END IF;
  SELECT count(*) INTO n_herkunft FROM login_attempt
   WHERE origin_hash = NEW.origin_hash AND NOT success
     AND attempted_at > now() - interval '60 minutes';
  IF n_herkunft >= 20 THEN
    RAISE EXCEPTION 'HERKUNFTS-SPERRE: 20 Fehlversuche je Herkunft, 60 Minuten (Nr. 35)'
      USING ERRCODE = 'check_violation';
  END IF;
  RETURN NEW;
END $$;

CREATE OR REPLACE TRIGGER login_attempt_guard_trg
  BEFORE INSERT ON login_attempt
  FOR EACH ROW EXECUTE FUNCTION login_attempt_guard();

-- 3c · Versandnachweis (Nr. 35) ---------------------------------------
-- Heisst nach Entscheidung E3 (4.8.2026) mail_delivery, nicht dispatch_proof.
-- Der Bau-Vorschlag vom 2.8. deckt mehr ab als die frueher hier gebaute
-- Fassung: er trennt Einladung von Anmeldecode (kind), haelt Absender und
-- Ergebnis fest und verlangt zu jedem Fehlschlag eine Begruendung. Ohne ihn
-- ist eine fehlgeschlagene Einladung nicht von einer nicht gesendeten zu
-- unterscheiden -- der ausdrueckliche Vorbehalt des Bauauftrags B2.
DO $$ BEGIN
  CREATE TYPE mail_kind AS ENUM ('EINLADUNG','ANMELDECODE');
EXCEPTION WHEN duplicate_object THEN NULL; END $$;
DO $$ BEGIN
  CREATE TYPE mail_status AS ENUM ('UEBERGEBEN','ABGELEHNT','FEHLER');
EXCEPTION WHEN duplicate_object THEN NULL; END $$;

CREATE TABLE IF NOT EXISTS mail_delivery (
  id            uuid PRIMARY KEY DEFAULT gen_random_uuid(),
  actor_id      uuid REFERENCES actor(id) ON DELETE SET NULL,
  login_code_id uuid REFERENCES login_code(id) ON DELETE SET NULL,
  kind          mail_kind NOT NULL,
  recipient     text NOT NULL,
  sender        text NOT NULL,
  status        mail_status NOT NULL,
  provider_id   text,                 -- Kennung des Versanddienstes
  provider_note text,                 -- Antwort im Klartext, fuer die Fehlersuche
  mail_header   text,                 -- fuer die Signaturmessung (Nr. 43)
  sent_at       timestamptz NOT NULL DEFAULT now(),
  retention_class retention_class NOT NULL DEFAULT 'KURZFRIST' REFERENCES retention_rule(class),
  -- Ein Fehlschlag ohne Begruendung ist kein Nachweis.
  CONSTRAINT mail_fehler_braucht_grund
    CHECK (status = 'UEBERGEBEN' OR provider_note IS NOT NULL)
);
CREATE INDEX IF NOT EXISTS mail_delivery_actor_idx ON mail_delivery (actor_id, sent_at DESC);

-- Nachweis laesst sich nicht aendern — mit FEHLERMELDUNG, nicht still.
-- (F02 hat das stille Verwerfen der event-Regeln geruegt; neue Nachweise
-- weisen ab, statt zu schlucken.)
CREATE OR REPLACE FUNCTION append_only_guard() RETURNS trigger LANGUAGE plpgsql AS $$
BEGIN
  RAISE EXCEPTION 'APPEND-ONLY: % erlaubt weder UPDATE noch DELETE', TG_TABLE_NAME
    USING ERRCODE = 'check_violation';
END $$;

CREATE OR REPLACE TRIGGER mail_delivery_append_only
  BEFORE UPDATE OR DELETE ON mail_delivery
  FOR EACH ROW EXECUTE FUNCTION append_only_guard();

-- 3d · Nachweisliste Einladungsentscheidungen (Nr. 10, Punkt 05) -------
-- Je Einladungsentscheidung eine Zeile: Person, Zeitpunkt, Adressat, Grund.
CREATE TABLE IF NOT EXISTS invitation_decision (
  id             uuid PRIMARY KEY DEFAULT gen_random_uuid(),
  tenant_id      uuid NOT NULL REFERENCES tenant(id) ON DELETE RESTRICT,
  decided_by     text NOT NULL,                            -- Person (Namensschnappschuss)
  decided_at     timestamptz NOT NULL DEFAULT now(),       -- Zeitpunkt
  adressat_mail  text NOT NULL,                            -- Adressat
  grund          text NOT NULL,                            -- Grund
  invitation_id  uuid REFERENCES invitation(id) ON DELETE SET NULL,
  CONSTRAINT entscheidung_mail_fmt CHECK (adressat_mail ~ '^[^[:space:]@]+@[^[:space:]@]+\.[^[:space:]@]+$'),
  CONSTRAINT entscheidung_grund_nicht_leer CHECK (length(trim(grund)) > 0)
);

CREATE OR REPLACE TRIGGER invitation_decision_append_only
  BEFORE UPDATE OR DELETE ON invitation_decision
  FOR EACH ROW EXECUTE FUNCTION append_only_guard();

-- 3e · Projektvertrag (Nr. 50 / H01) ----------------------------------
-- H01 (gez. A. Han, 4.8.2026): Obergrenze gilt je Konzept UND je
-- Projektvertrag, 5 Seiten, bei Ueberschreitung AUSWEISEN, nicht anhalten.
CREATE TABLE IF NOT EXISTS project_contract (
  app_id        uuid NOT NULL REFERENCES app(id) ON DELETE CASCADE,
  version       text NOT NULL,
  seiten_limit  smallint NOT NULL DEFAULT 5 CHECK (seiten_limit > 0),   -- H01: 5 Seiten
  gueltig       daterange NOT NULL,
  editor        text,
  erfasst_am    timestamptz NOT NULL DEFAULT now(),
  PRIMARY KEY (app_id, version),
  EXCLUDE USING gist (app_id WITH =, gueltig WITH &&)      -- genau eine geltende Fassung
);

CREATE TABLE IF NOT EXISTS contract_check (
  id               uuid PRIMARY KEY DEFAULT gen_random_uuid(),
  app_id           uuid NOT NULL,
  contract_version text NOT NULL,
  seiten           smallint NOT NULL CHECK (seiten > 0),
  ueberschritten   boolean NOT NULL,
  ausgewiesen      boolean NOT NULL DEFAULT false,
  checked_at       timestamptz NOT NULL DEFAULT now(),
  FOREIGN KEY (app_id, contract_version)
    REFERENCES project_contract(app_id, version) ON DELETE CASCADE,
  -- H01: Ueberschreitung haelt nicht an, MUSS aber ausgewiesen sein.
  CONSTRAINT ueberschreitung_ausgewiesen CHECK (NOT ueberschritten OR ausgewiesen)
);

-- 3f · Fragen des Schnellwegs (Nr. 55) --------------------------------
-- Eigener Traeger nach dem Muster fit_question/fit_option, MIT Fassung:
-- eine geaenderte Frage aendert alte Antworten nicht, weil die Antwort
-- auf die beantwortete Fassung verweist.
CREATE TABLE IF NOT EXISTS quick_question (
  code     text PRIMARY KEY CHECK (code ~ '^[a-z_]{3,24}$'),
  position smallint NOT NULL UNIQUE CHECK (position BETWEEN 1 AND 9)
);

CREATE TABLE IF NOT EXISTS quick_question_version (
  question_code text NOT NULL REFERENCES quick_question(code) ON DELETE CASCADE,
  version       text NOT NULL,
  prompt_de     text NOT NULL,
  gueltig       daterange NOT NULL,
  PRIMARY KEY (question_code, version),
  EXCLUDE USING gist (question_code WITH =, gueltig WITH &&)
);

CREATE TABLE IF NOT EXISTS quick_option (
  question_code text NOT NULL,
  version       text NOT NULL,
  position      smallint NOT NULL CHECK (position BETWEEN 1 AND 9),
  label_de      text NOT NULL,
  value_token   text NOT NULL,
  PRIMARY KEY (question_code, version, position),
  FOREIGN KEY (question_code, version)
    REFERENCES quick_question_version(question_code, version) ON DELETE CASCADE,
  UNIQUE (question_code, version, value_token)
);

CREATE TABLE IF NOT EXISTS quick_check (
  id           uuid PRIMARY KEY DEFAULT gen_random_uuid(),
  tenant_id    uuid NOT NULL REFERENCES tenant(id) ON DELETE RESTRICT,
  actor_id     uuid REFERENCES actor(id) ON DELETE SET NULL,
  started_at   timestamptz NOT NULL DEFAULT now(),
  completed_at timestamptz,
  retention_class retention_class NOT NULL DEFAULT 'BETRIEBSPROTOKOLL' REFERENCES retention_rule(class)
);

CREATE TABLE IF NOT EXISTS quick_answer (
  quick_check_id uuid NOT NULL REFERENCES quick_check(id) ON DELETE CASCADE,
  question_code  text NOT NULL,
  version        text NOT NULL,          -- die BEANTWORTETE Fassung (Gegentest Nr. 55)
  option_pos     smallint NOT NULL,
  answered_at    timestamptz NOT NULL DEFAULT now(),
  superseded_at  timestamptz,
  PRIMARY KEY (quick_check_id, question_code, version, option_pos),
  FOREIGN KEY (question_code, version, option_pos)
    REFERENCES quick_option(question_code, version, position) ON DELETE RESTRICT
);
-- Die fuenf Fragen selbst (Wortlaut) sind Konzeptinhalt (K04) und werden
-- als Seed nachgereicht, sobald H09/Punkt 13 den Wortlaut zeichnet.

-- 3g · Kenntnisnahme des Zweckbestimmungs-Schritts (O-K04-8, F1) -------
-- Entscheidung F1 (4.8.2026): Feld an fit_check, Klasse KI_NACHWEIS.
-- Loest K04-G12 ("als Ereignis") ab.
ALTER TABLE fit_check ADD COLUMN IF NOT EXISTS zweckbestimmung_ack_at timestamptz;

DO $$ BEGIN
  IF NOT EXISTS (SELECT 1 FROM pg_constraint WHERE conname = 'ack_nach_eignung') THEN
    ALTER TABLE fit_check ADD CONSTRAINT ack_nach_eignung
      CHECK (zweckbestimmung_ack_at IS NULL OR outcome = 'GEEIGNET');
  END IF;
  IF NOT EXISTS (SELECT 1 FROM pg_constraint WHERE conname = 'ack_klasse_ki_nachweis') THEN
    -- Gegentest F1: Kenntnisnahme mit Klasse BETRIEBSPROTOKOLL wird abgewiesen.
    ALTER TABLE fit_check ADD CONSTRAINT ack_klasse_ki_nachweis
      CHECK (zweckbestimmung_ack_at IS NULL OR retention_class = 'KI_NACHWEIS');
  END IF;
END $$;
-- ABWEICHUNG vom Matrix-Gegentest "ohne Anwendungsbezug scheitert":
-- Die Kenntnisnahme entsteht NACH outcome=GEEIGNET, aber BEVOR die app
-- angelegt ist — app_id kann beim Schreiben noch nicht Pflicht sein.
-- Der Anwendungsbezug wird zum Abnahmekriterium (fit_check mit ack und
-- ohne app nach Abschluss der Journey = Befund), nicht zur Schreibsperre.

-- 3h · template_element (O-K25-Umfang, F6) ----------------------------
-- Beziehung Vorlagenfassung -> verlangte Elementvorlage. Eigentuemer K18.
CREATE TABLE IF NOT EXISTS template_element (
  template_id         text NOT NULL,
  version             text NOT NULL,
  element_template_id text NOT NULL REFERENCES template(id) ON DELETE RESTRICT,
  PRIMARY KEY (template_id, version, element_template_id),
  FOREIGN KEY (template_id, version)
    REFERENCES template_version(template_id, version) ON DELETE CASCADE,
  CONSTRAINT element_nicht_selbst CHECK (element_template_id <> template_id)
);
-- "Das Ziel ist wirklich eine Elementvorlage" ist erst pruefbar, wenn die
-- funktionale Art existiert -> haengt an [E4]. Bis dahin kein CHECK.

-- F6: KEIN Rueckfuellen mit Umfang null. Der Pflegevermerk, der "verlangt
-- keine" von "nicht erhoben" unterscheidet — VORSCHLAG, offene Frage aus
-- F6 (Pflegevermerk oder verbotenes siebtes Merkmal?):
ALTER TABLE template_version ADD COLUMN IF NOT EXISTS elementbedarf_geprueft_at timestamptz;

-- 3i · Vorlageninhalt und Dokument-Ablage (Nr. 20 · 21) ---------------
-- KORRIGIERT 4.8.2026 nach dem Quellenabgleich: Die erste Fassung dieser
-- Zeile legte storage_key/size_bytes an DOCUMENT an. K18-M27 verlangt
-- woertlich etwas anderes, naemlich an TEMPLATE_VERSION:
--   "template_version MUSS vor RELEASED eine opake content_ref,
--    content_sha256, content_media_type und content_size_bytes
--    revisionsfest fuehren."
-- Die Konzeptnamen haben Vorrang vor selbst gewaehlten; sonst meldet der
-- Quellenabgleich sie spaeter zu Recht als fehlend.
ALTER TABLE template_version ADD COLUMN IF NOT EXISTS content_ref        text;
ALTER TABLE template_version ADD COLUMN IF NOT EXISTS content_sha256     text;
ALTER TABLE template_version ADD COLUMN IF NOT EXISTS content_media_type text;
ALTER TABLE template_version ADD COLUMN IF NOT EXISTS content_size_bytes bigint;

DO $$ BEGIN
  IF NOT EXISTS (SELECT 1 FROM pg_constraint WHERE conname = 'tv_sha_fmt') THEN
    ALTER TABLE template_version ADD CONSTRAINT tv_sha_fmt
      CHECK (content_sha256 IS NULL OR content_sha256 ~ '^[0-9a-f]{64}$');
  END IF;
  -- K18-M27: vor RELEASED muss der Inhaltsverweis vollstaendig sein.
  -- Das ist zugleich der Grund, warum nach F13 heute keine Fassung
  -- freigegeben werden kann — hier wird die Sperre erst durchsetzbar.
  IF NOT EXISTS (SELECT 1 FROM pg_constraint WHERE conname = 'tv_released_braucht_inhalt') THEN
    ALTER TABLE template_version ADD CONSTRAINT tv_released_braucht_inhalt
      CHECK (status <> 'RELEASED' OR (content_ref IS NOT NULL
             AND content_sha256 IS NOT NULL AND content_media_type IS NOT NULL
             AND content_size_bytes IS NOT NULL));
  END IF;
END $$;

-- Dieselbe Ablage fuer Gespraechsprotokolle und Uebergabepakete an
-- document (Umfang von Nr. 21; der Direkt-Prototyp braucht die
-- BV-3-Nachfolge-Entscheidung, siehe F5).
ALTER TABLE document ADD COLUMN IF NOT EXISTS content_ref        text;
ALTER TABLE document ADD COLUMN IF NOT EXISTS content_sha256     text;
ALTER TABLE document ADD COLUMN IF NOT EXISTS content_media_type text;
ALTER TABLE document ADD COLUMN IF NOT EXISTS content_size_bytes bigint;
ALTER TABLE document ADD COLUMN IF NOT EXISTS template_id        text;
ALTER TABLE document ADD COLUMN IF NOT EXISTS template_version   text;

DO $$ BEGIN
  IF NOT EXISTS (SELECT 1 FROM pg_constraint WHERE conname = 'document_sha_fmt') THEN
    ALTER TABLE document ADD CONSTRAINT document_sha_fmt
      CHECK (content_sha256 IS NULL OR content_sha256 ~ '^[0-9a-f]{64}$');
  END IF;
  IF NOT EXISTS (SELECT 1 FROM pg_constraint WHERE conname = 'document_template_fk') THEN
    ALTER TABLE document ADD CONSTRAINT document_template_fk
      FOREIGN KEY (template_id, template_version)
      REFERENCES template_version(template_id, version) ON DELETE RESTRICT;
  END IF;
END $$;
-- "Verweis auf fehlende Datei laesst die Freigabe scheitern" prueft der
-- Freigabelauf gegen den Objektspeicher — ausserhalb der Datenbank.

-- K21-M19: policy_version erhaelt body_md (Datenmodellauftrag O-K21-5,
-- als "geschlossen" gefuehrt, aber ohne Migration — im Quellenabgleich
-- vom 4.8. aufgefallen). Veroeffentlichter Text wird nie ueberschrieben;
-- die Unveraenderlichkeit erzwingt der Trigger darunter.
ALTER TABLE policy_version ADD COLUMN IF NOT EXISTS body_md text;

CREATE OR REPLACE FUNCTION policy_body_immutable() RETURNS trigger LANGUAGE plpgsql AS $$
BEGIN
  IF OLD.status = 'RELEASED' AND NEW.body_md IS DISTINCT FROM OLD.body_md THEN
    RAISE EXCEPTION 'RICHTLINIENTEXT: veroeffentlichter Wortlaut wird nie ueberschrieben (K21-M19)'
      USING ERRCODE = 'check_violation';
  END IF;
  RETURN NEW;
END $$;

CREATE OR REPLACE TRIGGER policy_version_body_guard
  BEFORE UPDATE ON policy_version
  FOR EACH ROW EXECUTE FUNCTION policy_body_immutable();

-- 3j · Agentenkatalog (Nr. 29) ----------------------------------------
ALTER TABLE agent ADD COLUMN IF NOT EXISTS output_form     text;
ALTER TABLE agent ADD COLUMN IF NOT EXISTS allowed_actions jsonb;

DO $$ BEGIN
  IF NOT EXISTS (SELECT 1 FROM pg_constraint WHERE conname = 'agent_released_vollstaendig') THEN
    -- Gegentest Nr. 29: Ein Agent ohne Ausgabeform/Handlungsliste kann
    -- nicht freigegeben werden — und nur freigegebene loesen aus.
    ALTER TABLE agent ADD CONSTRAINT agent_released_vollstaendig
      CHECK (status <> 'RELEASED' OR (output_form IS NOT NULL AND allowed_actions IS NOT NULL));
  END IF;
END $$;

-- 3k · Auswahlvermerk am Kundenprojekt (Nr. 25) -----------------------
ALTER TABLE app ADD COLUMN IF NOT EXISTS auswahlvermerk    text;
ALTER TABLE app ADD COLUMN IF NOT EXISTS auswahlvermerk_at timestamptz;

DO $$ BEGIN
  IF NOT EXISTS (SELECT 1 FROM pg_constraint WHERE conname = 'auswahlvermerk_paar') THEN
    ALTER TABLE app ADD CONSTRAINT auswahlvermerk_paar
      CHECK ((auswahlvermerk IS NULL) = (auswahlvermerk_at IS NULL));
  END IF;
END $$;

CREATE OR REPLACE FUNCTION auswahlvermerk_guard() RETURNS trigger LANGUAGE plpgsql AS $$
BEGIN
  IF OLD.auswahlvermerk IS NOT NULL
     AND (NEW.auswahlvermerk IS DISTINCT FROM OLD.auswahlvermerk
          OR NEW.auswahlvermerk_at IS DISTINCT FROM OLD.auswahlvermerk_at) THEN
    RAISE EXCEPTION 'AUSWAHLVERMERK: einmal gesetzt, unveraenderlich (Nr. 25)'
      USING ERRCODE = 'check_violation';
  END IF;
  RETURN NEW;
END $$;

CREATE OR REPLACE TRIGGER app_auswahlvermerk_guard
  BEFORE UPDATE ON app
  FOR EACH ROW EXECUTE FUNCTION auswahlvermerk_guard();

-- 3l · Sechs Merkmale der Vorlagenfassung (Nr. 24 / Punkt 17) ---------
-- ENTSCHIEDEN am 4.8.2026: Entscheidung E2, Moeglichkeit A, M. Veil.
--
-- Die achtzehn Werte stammen aus K25 Abschn. 6 und sind einzeln belegt;
-- eine Gegenprobe hat keinen als erfunden zurueckgewiesen. GESTRICHEN ist
-- der vierte Statusinhalt "ZUSTAND" -- er trug als einziger Wert keine
-- Fundstelle und ist in der Ausarbeitung entstanden, nicht in der Quelle.
--
-- DER GELTUNGSBEREICH ist der Kern von E2/A. Nr. 24 setzt die sechs
-- Angaben an "die Vorlagenfassung" -- und template_version fuehrt ALLE
-- Vorlagen, auch die siebzehn Schriftstueck-Vorlagen des Bestands
-- (Kurzsteckbrief, Protokoll, Moodboard, Prompt-Steckbriefe, Leitplanken).
-- Auf keine von ihnen passt einer der achtzehn Werte. Deshalb:
--   * alle sechs Spalten sind NULL-faehig,
--   * gesetzt ist entweder KEINE oder ALLE SECHS (tv_merkmale_ganz),
--   * der Erzeugerpfad waehlt nur Fassungen mit gesetzter Art -- eine
--     Fassung ohne Merkmale faellt heraus, statt falsch zu treffen
--     (fail-closed, K25-M31).
-- Ein vierter Wert "nicht anwendbar" waere die Alternative gewesen und ist
-- verworfen: K25-M14 verbietet eine vierte Art ausdruecklich, und ein Wert,
-- der nirgends gelten darf, ist eine Fehlerquelle.
--
-- SPALTENNAMEN: Nr. 24 nennt keine. Gewaehlt ist die Schreibweise des
-- eingefrorenen Datenmodells (englisch, snake_case, wie template_group und
-- lifecycle_state). Kein Konzept nennt bisher einen abweichenden Namen --
-- am 4.8. gegen alle 25 Entwuerfe geprueft.
DO $$ BEGIN
  CREATE TYPE template_function AS ENUM
    ('GESPRAECHSVORLAGE','STATUSVORLAGE','ELEMENTVORLAGE');          -- K25-M14
EXCEPTION WHEN duplicate_object THEN NULL; END $$;
DO $$ BEGIN
  CREATE TYPE template_dialog_mode AS ENUM ('GEFUEHRT','GEMISCHT','FREI');
EXCEPTION WHEN duplicate_object THEN NULL; END $$;
DO $$ BEGIN
  CREATE TYPE template_result_kind AS ENUM ('UEBERSICHT','VORGANG','NACHSCHLAGEN');
EXCEPTION WHEN duplicate_object THEN NULL; END $$;
DO $$ BEGIN
  CREATE TYPE template_status_content AS ENUM ('KENNZAHL','LISTE','VERLAUF');
EXCEPTION WHEN duplicate_object THEN NULL; END $$;
DO $$ BEGIN
  CREATE TYPE template_input_density AS ENUM ('KEINE','GERING','HOCH');
EXCEPTION WHEN duplicate_object THEN NULL; END $$;
DO $$ BEGIN
  CREATE TYPE template_confirm_density AS ENUM ('KEINE','EINSTUFIG','MEHRSTUFIG');
EXCEPTION WHEN duplicate_object THEN NULL; END $$;

ALTER TABLE template_version ADD COLUMN IF NOT EXISTS function_kind   template_function;
ALTER TABLE template_version ADD COLUMN IF NOT EXISTS dialog_mode     template_dialog_mode;
ALTER TABLE template_version ADD COLUMN IF NOT EXISTS result_kind     template_result_kind;
ALTER TABLE template_version ADD COLUMN IF NOT EXISTS status_content  template_status_content;
ALTER TABLE template_version ADD COLUMN IF NOT EXISTS input_density   template_input_density;
ALTER TABLE template_version ADD COLUMN IF NOT EXISTS confirm_density template_confirm_density;

DO $$ BEGIN
  -- Entweder keine Angabe oder das ganze Profil. Ein halbes Profil waere
  -- schlimmer als keines: der Auswahllauf filtert dann auf einer Luecke.
  IF NOT EXISTS (SELECT 1 FROM pg_constraint WHERE conname = 'tv_merkmale_ganz') THEN
    ALTER TABLE template_version ADD CONSTRAINT tv_merkmale_ganz
      CHECK (function_kind IS NULL
             OR (dialog_mode IS NOT NULL AND result_kind IS NOT NULL
                 AND status_content IS NOT NULL AND input_density IS NOT NULL
                 AND confirm_density IS NOT NULL));
  END IF;
END $$;

-- Die funktionale Art ist ein UNVERAENDERLICHES Merkmal: eine
-- Gespraechsvorlage wird in Fassung 2 keine Statusvorlage. Nr. 24 legt die
-- Angabe trotzdem an die Fassung, nicht an die Kopfzeile -- ohne die Regel
-- hier koennte eine neue Fassung eine Vorlage aus dem einen Topf in den
-- anderen umhaengen, waehrend alte Auswahlvermerke auf sie zeigen.
CREATE OR REPLACE FUNCTION template_art_bleibt() RETURNS trigger LANGUAGE plpgsql AS $$
DECLARE andere template_function;
BEGIN
  IF NEW.function_kind IS NULL THEN RETURN NEW; END IF;
  SELECT function_kind INTO andere FROM template_version
   WHERE template_id = NEW.template_id AND version <> NEW.version
     AND function_kind IS NOT NULL
   LIMIT 1;
  IF andere IS NOT NULL AND andere <> NEW.function_kind THEN
    RAISE EXCEPTION 'FUNKTIONALE ART: Fassungen von % tragen bereits %, nicht % (Nr. 24)',
      NEW.template_id, andere, NEW.function_kind USING ERRCODE = 'check_violation';
  END IF;
  RETURN NEW;
END $$;

CREATE OR REPLACE TRIGGER template_art_bleibt_trg
  BEFORE INSERT OR UPDATE OF function_kind ON template_version
  FOR EACH ROW EXECUTE FUNCTION template_art_bleibt();

-- Nachgeholt aus 3h: "Das Ziel ist wirklich eine Elementvorlage" war bis
-- zur Entscheidung ueber die Wertelisten nicht pruefbar. Jetzt ist es das.
CREATE OR REPLACE FUNCTION element_ist_elementvorlage() RETURNS trigger LANGUAGE plpgsql AS $$
BEGIN
  -- Der Selbstbezug gehoert der Bedingung element_nicht_selbst, nicht diesem
  -- Waechter. Ohne diese Zeile fing der Waechter den Fall vorher ab, und der
  -- Gegentest MT-38 scheiterte an der falschen Regel -- nach F07 gilt er dann
  -- als NICHT bestanden. Genau so ist es beim ersten Lauf passiert.
  IF NEW.element_template_id = NEW.template_id THEN RETURN NEW; END IF;
  IF NOT EXISTS (SELECT 1 FROM template_version
                  WHERE template_id = NEW.element_template_id
                    AND function_kind = 'ELEMENTVORLAGE') THEN
    RAISE EXCEPTION 'ELEMENTBEDARF: % ist keine Elementvorlage (K25-M14, Nr. 24)',
      NEW.element_template_id USING ERRCODE = 'check_violation';
  END IF;
  RETURN NEW;
END $$;

CREATE OR REPLACE TRIGGER element_ist_elementvorlage_trg
  BEFORE INSERT OR UPDATE ON template_element
  FOR EACH ROW EXECUTE FUNCTION element_ist_elementvorlage();

-- =====================================================================
-- STUFE 4 · Zustandsverlauf auf Zeitpunkte (Nr. 46)
-- =====================================================================
-- daterange -> tstzrange: zwei Wechsel am selben Tag werden darstellbar.
DO $$ BEGIN
  IF EXISTS (SELECT 1 FROM information_schema.columns
              WHERE table_name = 'app_state_history'
                AND column_name = 'gueltig' AND udt_name = 'daterange') THEN
    DROP VIEW IF EXISTS app_state_aktuell;               -- haengt an der Spalte
    ALTER TABLE app_state_history
      ALTER COLUMN gueltig TYPE tstzrange
      USING tstzrange(lower(gueltig)::timestamptz, upper(gueltig)::timestamptz);
  END IF;
END $$;

-- Sicht neu (lower() ist jetzt timestamptz — deshalb DROP/CREATE statt REPLACE):
CREATE OR REPLACE VIEW app_state_aktuell AS
  SELECT h.app_id, h.state, lower(h.gueltig) AS seit
    FROM app_state_history h WHERE upper_inf(h.gueltig);

-- Kopplung Zustand <-> Verlauf: der Verlauf entsteht ZWANGSLAEUFIG.
-- Anlegen schreibt die erste Zeile, jeder Wechsel schliesst die offene
-- und oeffnet die naechste. Damit gilt: kein Zustand ohne Verlaufszeile,
-- keine Verlaufszeile ohne Zustand (Gegentest Nr. 46).
-- clock_timestamp() statt now(): now() ist je Transaktion konstant —
-- zwei Wechsel in EINER Transaktion ergaeben identische (leere) Bereiche
-- und kollidierten am Primaerschluessel. clock_timestamp() laeuft weiter.
CREATE OR REPLACE FUNCTION app_state_history_sync() RETURNS trigger LANGUAGE plpgsql AS $$
DECLARE ts timestamptz := clock_timestamp();
BEGIN
  IF TG_OP = 'INSERT' THEN
    INSERT INTO app_state_history(app_id, state, gueltig)
    VALUES (NEW.id, NEW.lifecycle_state, tstzrange(ts, NULL));
  ELSIF NEW.lifecycle_state IS DISTINCT FROM OLD.lifecycle_state THEN
    UPDATE app_state_history
       SET gueltig = tstzrange(lower(gueltig), ts)
     WHERE app_id = NEW.id AND upper_inf(gueltig);
    INSERT INTO app_state_history(app_id, state, gueltig)
    VALUES (NEW.id, NEW.lifecycle_state, tstzrange(ts, NULL));
  END IF;
  RETURN NEW;
END $$;

CREATE OR REPLACE TRIGGER app_state_history_sync_trg
  AFTER INSERT OR UPDATE OF lifecycle_state ON app
  FOR EACH ROW EXECUTE FUNCTION app_state_history_sync();

-- =====================================================================
-- STUFE 5 · Verknuepfungen (Nr. 25 · 31 · 32 · 48 · 50 · 53)
-- =====================================================================

-- 5a · Protokollzeile mit fester Kontoverknuepfung (Nr. 48) -----------
-- actor_label bleibt als historisierter Namensschnappschuss bestehen.
ALTER TABLE event ADD COLUMN IF NOT EXISTS actor_id uuid REFERENCES actor(id) ON DELETE SET NULL;
CREATE INDEX IF NOT EXISTS event_actor_idx ON event (actor_id);

DO $$ BEGIN
  -- F-09 (Fremdreview K02): K02-G13 verlangt nach Nr. 48 Verknuepfung UND
  -- Namensschnappschuss gemeinsam. actor_id war nullbar ergaenzt, ohne dass
  -- eine Bedingung beide koppelt -- ein geloeschtes Konto haette den Namen
  -- mitgenommen. Bei knowledge_source ist dieselbe Regel als
  -- ks_owner_paarweise gebaut; hier fehlte sie.
  IF NOT EXISTS (SELECT 1 FROM pg_constraint WHERE conname = 'event_actor_paarweise') THEN
    ALTER TABLE event ADD CONSTRAINT event_actor_paarweise
      CHECK (actor_id IS NULL OR actor_label IS NOT NULL);
  END IF;
END $$;

-- F02-Haertung: Aendern/Loeschen wird ABGEWIESEN statt still verworfen.
-- Die alten Regeln schluckten den Versuch ohne Fehlermeldung — genau die
-- Gefahr, die Nr. 16 beschreibt. Regeln weg, Trigger mit Fehler hin.
DROP RULE IF EXISTS event_no_update ON event;
DROP RULE IF EXISTS event_no_delete ON event;
CREATE OR REPLACE TRIGGER event_append_only
  BEFORE UPDATE OR DELETE ON event
  FOR EACH ROW EXECUTE FUNCTION append_only_guard();

-- 5b · Freigabekopplung fuer Agenten (Nr. 32) -------------------------
-- IN_REVIEW -> RELEASED nur mit Vier-Augen-Freigabe (approval erzwingt
-- editor <> approver; Selbstfreigabe scheitert an sod_editor_ne_approver).
CREATE OR REPLACE FUNCTION agent_release_guard() RETURNS trigger LANGUAGE plpgsql AS $$
BEGIN
  -- KORRIGIERT 6.8.2026 (Befund N-2 aus der Verifikation in der Nacht zum
  -- 6.8.2026): Der Waechter hing allein am UPDATE. Ein direkt als RELEASED
  -- EINGEFUEGTER Agent umging die Vier-Augen-Freigabe vollstaendig -- und kein
  -- Prueffall deckte das ab, weil jeder Freigabefall der Pruefdatei ueber
  -- UPDATE laeuft. Der INSERT allein am Ausloeser genuegt dabei NICHT: bei
  -- INSERT ist OLD leer, die alte Bedingung waere nie wahr geworden. Deshalb
  -- wird hier nach TG_OP unterschieden.
  --
  -- NICHT geaendert (bewusst): Ein UPDATE aus einem anderen Zustand als
  -- IN_REVIEW nach RELEASED laeuft weiterhin am Waechter vorbei. Das waere
  -- eine Erweiterung ueber den Befund hinaus und beruehrt die Zustandsmatrix
  -- (Stufe 5c, H02). Als offener Punkt gemeldet, nicht still mitgeaendert.
  IF (TG_OP = 'INSERT' AND NEW.status = 'RELEASED')
     OR (TG_OP = 'UPDATE' AND OLD.status = 'IN_REVIEW' AND NEW.status = 'RELEASED') THEN
    -- KORRIGIERT 5.8.2026 (F-12, Fremdreview K14): Der Waechter suchte
    -- woertlich 'AGENT:<id>'. Der typisierte Bezug aus Stufe 10f leitet aber
    -- 'AGENT:<id>:FREIGABE' ab -- eine typisierte Freigabe wurde hier nicht
    -- gefunden, und die untypisierte Altform umging die neue Existenzpruefung.
    -- Jetzt liest er den typisierten Bezug und faellt auf die Altform zurueck.
    IF NOT EXISTS (SELECT 1 FROM approval
                    WHERE (objekt_art = 'AGENT' AND objekt_id = NEW.id::text
                           AND anlass = 'FREIGABE')
                       OR object_ref = 'AGENT:' || NEW.id::text) THEN
      RAISE EXCEPTION 'AGENT-FREIGABE: braucht Vier-Augen-Freigabe (Nr. 32), object_ref=AGENT:%', NEW.id
        USING ERRCODE = 'check_violation';
    END IF;
  END IF;
  RETURN NEW;
END $$;

-- ERWEITERT 6.8.2026 (Befund N-2): INSERT ergaenzt. Vorher stand hier nur
-- "BEFORE UPDATE OF status" -- der Ausloeser feuerte beim Einfuegen nie.
CREATE OR REPLACE TRIGGER agent_release_guard_trg
  BEFORE INSERT OR UPDATE OF status ON agent
  FOR EACH ROW EXECUTE FUNCTION agent_release_guard();
-- "Agent in Pruefung laesst sich nicht verwenden" ist Laufzeitverhalten
-- des Agenten-Rahmens; das Schema traegt den Status, der Rahmen prueft ihn.

-- 5c · Uebergangstabelle (Nr. 53 / H02) -------------------------------
CREATE TABLE IF NOT EXISTS state_transition (
  from_state lifecycle_state NOT NULL,
  to_state   lifecycle_state NOT NULL,
  authority  transition_authority NOT NULL,
  bedingung  text,
  PRIMARY KEY (from_state, to_state),
  CONSTRAINT kein_selbstwechsel CHECK (from_state <> to_state)   -- N11
);

-- Die 19 Wechsel aus H02 (W01, das Anlegen, ist der INSERT selbst).
-- W17 traegt ZWEI_PERSONEN — entschieden am 4.8.2026.
INSERT INTO state_transition(from_state,to_state,authority,bedingung) VALUES
  ('DISCOVERY','IN_BEARBEITUNG','SYSTEM','Stufe 02 betreten, Interview beginnt'),                        -- W02
  ('IN_BEARBEITUNG','BEAUFTRAGT','SYSTEM','nur mit Zwei-Personen-Freigabe und festgeschriebenem Projekt'),-- W03
  ('BEAUFTRAGT','IN_DEV','VERWALTER','der Bau beginnt'),                                                  -- W04
  ('IN_DEV','ABNAHME','VERWALTER','der Prototyp liegt vor'),                                              -- W05
  ('ABNAHME','IN_DEV','VERWALTER','Nacharbeit — einziger Rueckweg ohne zweite Person'),                   -- W06
  ('ABNAHME','IN_PROD','ZWEI_PERSONEN','das Uebergabe-Paket ist uebergeben'),                             -- W07
  ('BEAUFTRAGT','IN_BEARBEITUNG','ZWEI_PERSONEN','Ruecknahme einer Beauftragung, mit Grund'),             -- W08
  ('DISCOVERY','PAUSIERT','VERWALTER','mit Grund im Protokoll'),                                          -- W09
  ('IN_BEARBEITUNG','PAUSIERT','VERWALTER','mit Grund im Protokoll'),                                     -- W10
  ('BEAUFTRAGT','PAUSIERT','VERWALTER','mit Grund; der Vertrag bleibt bestehen'),                         -- W11
  ('IN_DEV','PAUSIERT','VERWALTER','mit Grund im Protokoll'),                                             -- W12
  ('ABNAHME','PAUSIERT','VERWALTER','mit Grund im Protokoll'),                                            -- W13
  ('IN_PROD','PAUSIERT','VERWALTER','nur Betreuung, nicht der Betrieb der Anwendung'),                    -- W14
  ('PAUSIERT','DISCOVERY','VERWALTER','nur zurueck in den letzten Zustand vor der Pause'),                -- W15
  ('PAUSIERT','IN_BEARBEITUNG','VERWALTER','nur zurueck in den letzten Zustand vor der Pause'),           -- W16
  ('PAUSIERT','BEAUFTRAGT','ZWEI_PERSONEN','Rueckweg in den Vertragszustand — entschieden 4.8.2026'),     -- W17
  ('PAUSIERT','IN_DEV','VERWALTER','nur zurueck in den letzten Zustand vor der Pause'),                   -- W18
  ('PAUSIERT','ABNAHME','VERWALTER','nur zurueck in den letzten Zustand vor der Pause'),                  -- W19
  ('PAUSIERT','IN_PROD','VERWALTER','nur zurueck in den letzten Zustand vor der Pause')                   -- W20
ON CONFLICT (from_state, to_state) DO NOTHING;

CREATE OR REPLACE FUNCTION lifecycle_transition_guard() RETURNS trigger LANGUAGE plpgsql AS $$
DECLARE t state_transition%ROWTYPE; letzter lifecycle_state;
BEGIN
  IF TG_OP = 'INSERT' THEN
    -- V1/A (gez. M. Veil, 5.8.2026), O-K01-6: DER RIEGEL AN DER ENTSTEHUNG.
    -- K01-M27 verlangt, dass eine Projektzeile nur nach bestandener Eignung
    -- entsteht. Bisher war das eine Aussage ueber Programmcode -- der
    -- Datenbestand nahm den Schreibvorgang an, und app.fit_check_id blieb
    -- nullbar. O-K04-5 verlangt woertlich "Durchsetzung an der Entstehung
    -- der Zeile, nicht am Zustandswechsel"; deshalb steht der Riegel hier
    -- und nicht weiter unten.
    --
    -- ZUERST, sonst scheitert der Fall an der falschen Regel: Die
    -- Anlegeregel W01 prueft nur den Zustand. Ohne diese Reihenfolge
    -- meldete ein Anlegeversuch ohne Eignung "entsteht auf DISCOVERY" --
    -- richtig abgewiesen, falsch begruendet (Massstab F07).
    IF NEW.fit_check_id IS NULL THEN
      RAISE EXCEPTION 'EIGNUNGSRIEGEL: eine Anwendung entsteht nur zu einem bestandenen Eignungs-Check (K01-M27, O-K01-6)'
        USING ERRCODE = 'check_violation';
    END IF;
    IF NOT EXISTS (SELECT 1 FROM fit_check
                    WHERE id = NEW.fit_check_id AND outcome = 'GEEIGNET') THEN
      RAISE EXCEPTION 'EIGNUNGSRIEGEL: der Eignungs-Check % steht nicht auf GEEIGNET (K01-M27, O-K01-6)',
        NEW.fit_check_id USING ERRCODE = 'check_violation';
    END IF;

    -- W01: Ein Projekt entsteht auf DISCOVERY (Entscheidung M. Veil, 4.8.2026);
    -- EINGELADEN ist im Release 1 unbenutzbar (H02).
    IF NEW.lifecycle_state <> 'DISCOVERY' THEN
      RAISE EXCEPTION 'UEBERGANG: ein Projekt entsteht auf DISCOVERY (W01, H02), nicht auf %', NEW.lifecycle_state
        USING ERRCODE = 'check_violation';
    END IF;
    RETURN NEW;
  END IF;

  IF NEW.lifecycle_state IS NOT DISTINCT FROM OLD.lifecycle_state THEN
    RETURN NEW;
  END IF;

  SELECT * INTO t FROM state_transition
   WHERE from_state = OLD.lifecycle_state AND to_state = NEW.lifecycle_state;
  IF NOT FOUND THEN
    -- N01-N04, N11: jeder nicht eingetragene Wechsel scheitert HIER.
    RAISE EXCEPTION 'UEBERGANG: % -> % ist nicht erlaubt (Uebergangstabelle, Nr. 53)',
      OLD.lifecycle_state, NEW.lifecycle_state USING ERRCODE = 'check_violation';
  END IF;

  -- W03: Kopplung an Festschreibung und Zwei-Personen-Freigabe (N05, N06).
  IF NEW.lifecycle_state = 'BEAUFTRAGT' AND OLD.lifecycle_state = 'IN_BEARBEITUNG' THEN
    IF NEW.sealed_at IS NULL THEN
      RAISE EXCEPTION 'UEBERGANG: BEAUFTRAGT verlangt ein festgeschriebenes Projekt (sealed_at, Nr. 53)'
        USING ERRCODE = 'check_violation';
    END IF;
    IF NOT EXISTS (SELECT 1 FROM approval WHERE object_ref = 'APP:' || NEW.id::text || ':BEAUFTRAGUNG') THEN
      RAISE EXCEPTION 'UEBERGANG: BEAUFTRAGT verlangt die Zwei-Personen-Freigabe (Nr. 53), object_ref=APP:%:BEAUFTRAGUNG', NEW.id
        USING ERRCODE = 'check_violation';
    END IF;
  END IF;

  -- N07, N08, N13: Wege mit zwei Personen brauchen eine approval-Zeile
  -- fuer GENAU DIESEN Wechsel (sod erzwingt editor <> approver).
  IF t.authority = 'ZWEI_PERSONEN' THEN
    IF NOT EXISTS (SELECT 1 FROM approval
                    WHERE object_ref = 'APP:' || NEW.id::text || ':' ||
                          OLD.lifecycle_state::text || '->' || NEW.lifecycle_state::text) THEN
      RAISE EXCEPTION 'UEBERGANG: % -> % verlangt zwei Personen (approval fehlt fuer object_ref=APP:%:%->%)',
        OLD.lifecycle_state, NEW.lifecycle_state, NEW.id, OLD.lifecycle_state, NEW.lifecycle_state
        USING ERRCODE = 'check_violation';
    END IF;
  END IF;

  -- N10: Der Rueckweg aus PAUSIERT fuehrt genau in den letzten Zustand
  -- vor der Pause — der Verlauf (Nr. 46) liefert, wohin zurueck.
  IF OLD.lifecycle_state = 'PAUSIERT' THEN
    SELECT h.state INTO letzter
      FROM app_state_history h
     WHERE h.app_id = NEW.id AND h.state <> 'PAUSIERT'
     ORDER BY upper(h.gueltig) DESC NULLS LAST
     LIMIT 1;
    IF letzter IS NULL OR letzter <> NEW.lifecycle_state THEN
      RAISE EXCEPTION 'UEBERGANG: Rueckweg aus PAUSIERT fuehrt nach % (Verlauf), nicht nach %',
        COALESCE(letzter::text, '<kein Verlauf>'), NEW.lifecycle_state
        USING ERRCODE = 'check_violation';
    END IF;
  END IF;

  RETURN NEW;
END $$;

CREATE OR REPLACE TRIGGER app_lifecycle_transition_guard
  BEFORE INSERT OR UPDATE OF lifecycle_state ON app
  FOR EACH ROW EXECUTE FUNCTION lifecycle_transition_guard();

-- 5d · Einladungsdomaene: Abschaltnachweis (Nr. 54, Option B) ---------
-- Nr. 54 ist mit Option B gezeichnet: EINE Domaene je Kunde; Abschalten
-- nur mit begruendetem, protokolliertem Nachweis. Der Nachweis entsteht
-- hier zwangslaeufig: jede Aenderung der Domaene schreibt eine
-- Protokollzeile. (Die fruehere Matrixzeile "mehrere Domaenen"
-- widersprach dem Beschluss und ist am 4.8. korrigiert.)
CREATE OR REPLACE FUNCTION tenant_domain_audit() RETURNS trigger LANGUAGE plpgsql AS $$
BEGIN
  IF NEW.invite_domain IS DISTINCT FROM OLD.invite_domain THEN
    INSERT INTO event(tenant_id, actor_label, action, object_ref, change_type, value, source)
    VALUES (NEW.id, current_user, 'EINLADUNGSDOMAENE_GEAENDERT',
            'TENANT:' || NEW.id::text, 'Aenderung',
            COALESCE(OLD.invite_domain,'<leer>') || ' -> ' || COALESCE(NEW.invite_domain,'<leer — Schranke abgeschaltet>'),
            'MODEL_CHANGE');
  END IF;
  RETURN NEW;
END $$;

CREATE OR REPLACE TRIGGER tenant_domain_audit_trg
  BEFORE UPDATE OF invite_domain ON tenant
  FOR EACH ROW EXECUTE FUNCTION tenant_domain_audit();

-- =====================================================================
-- STUFE 6 · Sperren und Ausloeser (Nr. 16 · 38 · 59 · 18/60)
-- =====================================================================

-- 6a · Anmelde-Ausloeser (Nr. 16, Punkt 11) ---------------------------
-- Jede Anmeldung (= neue Sitzung) schreibt im selben Vorgang die
-- unveraenderbare Protokollzeile. Nr. 48 deckt nur Fachaenderungen;
-- dieser Trigger deckt die Anmeldung. Faellt das Schreiben aus,
-- scheitert die Anmeldung (Gegentest Punkt 11).
CREATE OR REPLACE FUNCTION session_event_writer() RETURNS trigger LANGUAGE plpgsql AS $$
DECLARE lbl text; ten uuid;
BEGIN
  SELECT a.display_name, a.tenant_id INTO lbl, ten FROM actor a WHERE a.id = NEW.actor_id;
  INSERT INTO event(actor_id, actor_label, tenant_id, action, object_ref, change_type, source)
  VALUES (NEW.actor_id, lbl, ten, 'ANMELDUNG', 'SESSION:' || NEW.id::text, 'Neuanlage', 'PORTAL_ACTION');
  RETURN NEW;
END $$;

CREATE OR REPLACE TRIGGER auth_session_event_trg
  AFTER INSERT ON auth_session
  FOR EACH ROW EXECUTE FUNCTION session_event_writer();

-- 6b · Siegel unumkehrbar (Nr. 38) ------------------------------------
CREATE OR REPLACE FUNCTION sealed_irreversible_guard() RETURNS trigger LANGUAGE plpgsql AS $$
BEGIN
  IF OLD.sealed AND NOT NEW.sealed THEN
    RAISE EXCEPTION 'SIEGEL: die Ruecknahme des Siegels ist ausgeschlossen (Nr. 38)'
      USING ERRCODE = 'check_violation';
  END IF;
  RETURN NEW;
END $$;

CREATE OR REPLACE TRIGGER actor_sealed_irreversible
  BEFORE UPDATE OF sealed ON actor
  FOR EACH ROW EXECUTE FUNCTION sealed_irreversible_guard();

-- 6c · Genau ein Ausnahmekonto (Nr. 59) -------------------------------
-- Hoechstens EIN Konto ohne bestaetigten Code (mfa_method = OFF).
-- Die Codepflicht fuer das Erstkonto selbst wird erst mit der Abnahme
-- des Mailwegs eingeschaltet (B2) — dieser Index sperrt nur das ZWEITE
-- Ausnahmekonto und ist deshalb sofort gefahrlos.
CREATE UNIQUE INDEX IF NOT EXISTS actor_ausnahmekonto_uq
  ON actor ((true)) WHERE mfa_method = 'OFF';

-- 6d · Protokollzeilen nie faellig (Nr. 18 · 60) ----------------------
-- steht in der Sicht, Stufe 7.

-- =====================================================================
-- STUFE 7 · Sichten
-- =====================================================================
-- retention_due neu: (1) event-Zweig liefert KEIN faellig_am mehr —
-- Beschluss Nr. 16: Beweiswert vor Loeschzusage, Protokollzeilen werden
-- nie entfernt; die Pseudonymisierung nach 12 Monaten bleibt.
-- (2) Neue Zweige fuer Einladungen (Nr. 17: 30 Tage nach Ablauf),
-- Anmeldecodes und Versandnachweise (Nr. 35: 30 Tage nach Verbrauch
-- oder Ablauf). Seit Stufe 9a tagesgenau, nicht mehr als Monat genaehert.
--
-- SPALTEN BENANNT, nicht "*": Die erste Fassung schrieb hier
-- "SELECT * FROM retention_rule". Beim Nachtragen der Spalte
-- regelfrist_tage in Stufe 9a riss dadurch der Idempotenz-Nachweis --
-- der zweite Lauf ersetzte die Sicht, und der Stern loeste sich auf
-- einmal in eine Spalte mehr auf. Genau derselbe Fehler, den O-K21-6
-- an policy_aktuell beanstandet. Ein Stern in einer Sicht ist eine
-- Zusage, die sich aendert, ohne dass jemand sie aendert.
-- Eine Frist, zwei moegliche Einheiten. Die Rechnung steht hier einmal und
-- nicht in jedem Zweig der Sicht erneut -- sonst zieht der naechste Nachtrag
-- wieder nur die Haelfte nach.
CREATE OR REPLACE FUNCTION frist_ende(ab timestamptz, monate integer, tage integer)
RETURNS date LANGUAGE sql IMMUTABLE AS $$
  SELECT CASE
    WHEN tage   IS NOT NULL THEN (ab + (tage   || ' days')::interval)::date
    WHEN monate IS NOT NULL THEN (ab + (monate || ' months')::interval)::date
    ELSE NULL
  END
$$;

CREATE OR REPLACE VIEW retention_due AS
WITH regel AS (SELECT class, bezeichnung, fristbeginn, regelfrist_monate,
                      regelfrist_tage, mindestfrist_monate,
                      pseudonymisieren_nach_monaten, rechtsgrundlage
                 FROM retention_rule),
     app_faellig AS (
       SELECT a.id,
              (make_date(EXTRACT(YEAR FROM a.created_at)::int, 12, 31)
                 + (r.regelfrist_monate || ' months')::interval)::date AS faellig_am
       FROM app a JOIN regel r ON r.class = a.retention_class
       WHERE r.fristbeginn = 'ENTSTEHUNGSJAHRESENDE')
SELECT 'app' AS objekt, a.id::text AS objekt_id, a.retention_class, f.faellig_am,
       NULL::date AS pseudonymisieren_ab
  FROM app a JOIN app_faellig f ON f.id = a.id
UNION ALL
SELECT 'document', d.id::text,
       CASE WHEN d.kind IN ('ORDER','SBOM') THEN 'HANDELSRECHT'::retention_class
            ELSE 'KI_NACHWEIS'::retention_class END,
       f.faellig_am,
       CASE WHEN d.kind IN ('ORDER','SBOM') THEN NULL::date
            ELSE (f.faellig_am - interval '96 months')::date END
  FROM document d JOIN app_faellig f ON f.id = d.app_id
UNION ALL
-- Nr. 16/18/60: Protokollzeilen erscheinen NIE als faellig; nur der
-- Personenbezug endet (Pseudonymisierung), der Nachweis bleibt.
SELECT 'event', e.id::text, e.retention_class,
       NULL::date,
       (e.occurred_at + (r.pseudonymisieren_nach_monaten || ' months')::interval)::date
  FROM event e JOIN regel r ON r.class = e.retention_class
 WHERE r.fristbeginn = 'ERSTELLUNG'
UNION ALL
SELECT 'direct_prototype', p.id::text, p.retention_class,
       frist_ende(p.created_at, r.regelfrist_monate, r.regelfrist_tage),
       (p.created_at + (r.pseudonymisieren_nach_monaten || ' months')::interval)::date
  FROM direct_prototype p JOIN regel r ON r.class = p.retention_class
 WHERE r.fristbeginn = 'ERSTELLUNG'
UNION ALL
SELECT 'fit_check', c.id::text, c.retention_class, f.faellig_am,
       (c.started_at + (r.pseudonymisieren_nach_monaten || ' months')::interval)::date
  FROM fit_check c JOIN regel r ON r.class = c.retention_class
  LEFT JOIN app_faellig f ON f.id = c.app_id
UNION ALL
SELECT 'review_run', v.id::text, v.retention_class, f.faellig_am,
       (v.completed_at + (r.pseudonymisieren_nach_monaten || ' months')::interval)::date
  FROM review_run v JOIN regel r ON r.class = v.retention_class
  LEFT JOIN app_faellig f ON f.id = v.app_id
UNION ALL
-- Nr. 17: nicht eingeloeste Einladungen, 30 Tage nach Ablauf. [N2]
SELECT 'invitation', i.id::text, 'KURZFRIST'::retention_class,
       frist_ende(i.expires_at, r.regelfrist_monate, r.regelfrist_tage), NULL::date
  FROM invitation i CROSS JOIN regel r
 WHERE i.status <> 'EINGELOEST' AND i.expires_at < now()
UNION ALL
-- Nr. 35: Anmeldecodes 30 Tage nach Verbrauch oder Ablauf. [N2]
SELECT 'login_code', c.id::text, c.retention_class,
       frist_ende(COALESCE(c.consumed_at, c.expires_at),
                  r.regelfrist_monate, r.regelfrist_tage), NULL::date
  FROM login_code c JOIN regel r ON r.class = c.retention_class
UNION ALL
SELECT 'mail_delivery', p.id::text, p.retention_class,
       frist_ende(p.sent_at, r.regelfrist_monate, r.regelfrist_tage), NULL::date
  FROM mail_delivery p JOIN regel r ON r.class = p.retention_class;
-- Der taegliche Lauf und der Alarm nach drei Tagen (Nr. 18/60) sind
-- Betrieb, kein Schema — die Sicht liefert die Faelligkeit, der Lauf
-- verarbeitet sie. Mandantentrennung der Sichten: Punkt 09 (Echtbetrieb).

-- =====================================================================
-- STUFE 10 · Die sechs Vorfragen (gez. M. Veil, 5.8.2026)
-- =====================================================================
-- V1 A · V2 A · V3 A · V4 B · V5 B · V6 B
--
-- Die Zeichnung loest siebzehn Bausperrer. Was hier NICHT steht, steht auch
-- nicht in der gezeichneten Moeglichkeit: V1/A nennt ausdruecklich, dass der
-- Entzug der Tabellenrechte die namentliche Besetzung der Dienstidentitaeten
-- braucht -- und die ist in O-K13-1 offen geblieben ("Offen bleibt die
-- namentliche Besetzung"). O-K13-1 und O-K14-4 bleiben deshalb offen, mit der
-- Zeichnung und nicht gegen sie. Ein erfundener Rollenname waere hier der
-- schwerste moegliche Fehler: er saehe aus wie eine Sperre und waere keine.
--
-- Der Riegel aus V1/A steht nicht hier, sondern in Stufe 5c im Ausloeser auf
-- app -- dort, wo die Zeile entsteht (O-K04-5: "Durchsetzung an der
-- Entstehung der Zeile, nicht am Zustandswechsel").

-- 10a · V2/A · Dokumentfassung (O-K06-1..3, O-K09-1/2, O-K09-5) -------
-- document trug bisher fuenf Spalten und keine Fassung: kein Zeitpunkt,
-- keine Pruefsumme, kein Schreibschutz. Ein Haekchen "ich habe die sechs
-- Konzepte geprueft" konnte deshalb auf nichts Bestimmtes zeigen.
-- Gebaut wird das Muster Vorlage/Vorlagenfassung aus BF-4 -- dasselbe, das
-- template, knowledge_module und policy schon tragen.
DO $$ BEGIN
  CREATE TYPE concept_kind AS ENUM
    ('PROZESS_SCHRITTE','DATEN_SYSTEME','ROLLEN_AKTIONEN',
     'REGELN_AUSNAHMEN','COMPLIANCE','ERGEBNIS_KENNZAHLEN');   -- K06-M01, woertlich
EXCEPTION WHEN duplicate_object THEN NULL; END $$;

-- Die Artefaktkennung sagt, WELCHES der sechs Konzepte eine Zeile ist.
-- document_kind sagt nur, dass es ein Konzept ist -- alle sechs tragen dort
-- denselben Wert CONCEPT.
ALTER TABLE document ADD COLUMN IF NOT EXISTS concept_kind concept_kind;

DO $$ BEGIN
  IF NOT EXISTS (SELECT 1 FROM pg_constraint WHERE conname = 'concept_braucht_kennung') THEN
    ALTER TABLE document ADD CONSTRAINT concept_braucht_kennung
      CHECK ((kind = 'CONCEPT') = (concept_kind IS NOT NULL));
  END IF;
END $$;

CREATE TABLE IF NOT EXISTS document_version (
  document_id   uuid NOT NULL REFERENCES document(id) ON DELETE CASCADE,
  version       text NOT NULL,
  status        lifecycle_status NOT NULL DEFAULT 'DRAFT',
  gueltig       daterange NOT NULL,
  editor        text,
  erfasst_am    timestamptz NOT NULL DEFAULT now(),
  content_ref        text,
  content_sha256     text,
  content_media_type text,
  content_size_bytes bigint,
  PRIMARY KEY (document_id, version),
  CONSTRAINT dv_sha_fmt CHECK (content_sha256 IS NULL OR content_sha256 ~ '^[0-9a-f]{64}$'),
  -- Wie bei template_version: freigegeben nur mit vollstaendigem Inhaltsverweis.
  CONSTRAINT dv_released_braucht_inhalt
    CHECK (status <> 'RELEASED' OR (content_ref IS NOT NULL AND content_sha256 IS NOT NULL
           AND content_media_type IS NOT NULL AND content_size_bytes IS NOT NULL)),
  -- Dieselbe Regel wie an den drei bestehenden Fassungstabellen: nie zwei
  -- gleichzeitig geltende Fassungen desselben Dokuments.
  EXCLUDE USING gist (document_id WITH =, gueltig WITH &&)
);

-- Eine freigegebene Fassung wird nicht mehr geaendert. Der Waechter dafuer
-- liegt seit Stufe 3i fertig vor (policy_version) und wird hier nur
-- angehaengt -- kein zweiter Ort fuer dieselbe Regel.
CREATE OR REPLACE FUNCTION document_version_unveraenderlich() RETURNS trigger
LANGUAGE plpgsql AS $$
BEGIN
  IF OLD.status = 'RELEASED' AND (
       NEW.content_ref IS DISTINCT FROM OLD.content_ref
    OR NEW.content_sha256 IS DISTINCT FROM OLD.content_sha256
    OR NEW.content_size_bytes IS DISTINCT FROM OLD.content_size_bytes) THEN
    RAISE EXCEPTION 'FASSUNG: eine freigegebene Dokumentfassung wird nicht geaendert (K06-M28)'
      USING ERRCODE = 'check_violation';
  END IF;
  RETURN NEW;
END $$;

CREATE OR REPLACE TRIGGER document_version_unveraenderlich_trg
  BEFORE UPDATE ON document_version
  FOR EACH ROW EXECUTE FUNCTION document_version_unveraenderlich();

-- Der Haekchen-Eintrag zeigt auf die FASSUNG, nicht auf das Dokument
-- (O-K06-2). Zusammengesetzter Schluessel, wie an zwei Stellen schon.
ALTER TABLE event ADD COLUMN IF NOT EXISTS document_id      uuid;
ALTER TABLE event ADD COLUMN IF NOT EXISTS document_version text;

DO $$ BEGIN
  IF NOT EXISTS (SELECT 1 FROM pg_constraint WHERE conname = 'event_document_fk') THEN
    ALTER TABLE event ADD CONSTRAINT event_document_fk
      FOREIGN KEY (document_id, document_version)
      REFERENCES document_version(document_id, version) ON DELETE RESTRICT;
  END IF;
  IF NOT EXISTS (SELECT 1 FROM pg_constraint WHERE conname = 'event_document_paarweise') THEN
    ALTER TABLE event ADD CONSTRAINT event_document_paarweise
      CHECK ((document_id IS NULL) = (document_version IS NULL));
  END IF;
END $$;
-- review_run.artifact_version bleibt Freitext -- so gezeichnet in V2/A.

-- 10b · V3/A · Modellpfad-Manifest (O-K17-4, O-K17-13) ----------------
-- Das Manifest ist eine TEXTDATEI im Auslieferungsbestand -- sie liegt beim
-- Programmcode und wird mit ihm ausgeliefert. In der Datenbank stehen nur
-- Freigabe und Pruefsumme, nach genau dem Muster von template_version.
-- Damit ist die Driftpruefung aus K17-M06 rechenbar: der laufende Dienst
-- vergleicht die Pruefsumme der ausgelieferten Datei mit der geltenden
-- Fassung hier. Weichen sie ab, ist Drift nachgewiesen -- nicht vermutet.
CREATE TABLE IF NOT EXISTS model_manifest (
  id    text PRIMARY KEY,          -- z.B. 'MPM-1'
  name  text NOT NULL,
  zweck text
);

CREATE TABLE IF NOT EXISTS model_manifest_version (
  manifest_id  text NOT NULL REFERENCES model_manifest(id) ON DELETE CASCADE,
  version      text NOT NULL,
  status       lifecycle_status NOT NULL DEFAULT 'DRAFT',
  gueltig      daterange NOT NULL,
  editor       text,
  erfasst_am   timestamptz NOT NULL DEFAULT now(),
  content_ref        text,
  content_sha256     text,
  content_media_type text,
  content_size_bytes bigint,
  PRIMARY KEY (manifest_id, version),
  CONSTRAINT mmv_sha_fmt CHECK (content_sha256 IS NULL OR content_sha256 ~ '^[0-9a-f]{64}$'),
  CONSTRAINT mmv_released_braucht_inhalt
    CHECK (status <> 'RELEASED' OR (content_ref IS NOT NULL AND content_sha256 IS NOT NULL
           AND content_media_type IS NOT NULL AND content_size_bytes IS NOT NULL)),
  EXCLUDE USING gist (manifest_id WITH =, gueltig WITH &&)
);

-- K17-M06: kein Modellpfad ohne geltendes, freigegebenes Manifest. Der
-- Verweis steht am Modellpfad, damit die Startpruefung ihn ohne Umweg liest.
ALTER TABLE model_ref ADD COLUMN IF NOT EXISTS manifest_id      text;
ALTER TABLE model_ref ADD COLUMN IF NOT EXISTS manifest_version text;

DO $$ BEGIN
  IF NOT EXISTS (SELECT 1 FROM pg_constraint WHERE conname = 'model_manifest_fk') THEN
    ALTER TABLE model_ref ADD CONSTRAINT model_manifest_fk
      FOREIGN KEY (manifest_id, manifest_version)
      REFERENCES model_manifest_version(manifest_id, version) ON DELETE RESTRICT;
  END IF;
  IF NOT EXISTS (SELECT 1 FROM pg_constraint WHERE conname = 'model_manifest_paarweise') THEN
    ALTER TABLE model_ref ADD CONSTRAINT model_manifest_paarweise
      CHECK ((manifest_id IS NULL) = (manifest_version IS NULL));
  END IF;
END $$;

-- 10c · V3/A · Telemetrie- und Textnaehe-Schwellen (O-K17-13, O-K17-8) -
-- S33 nennt zwei Schwellen (acht Woerter, 0,90) und eine dreiwertige
-- Befundliste; K17-M... verlangt je Agent eine Freigabeschwelle. Beide
-- leben nach V3/A IM MANIFEST, nicht in einer eigenen Tabelle -- deshalb
-- entsteht hier kein Traeger, sondern nur der Befund am Ergebnis.
DO $$ BEGIN
  CREATE TYPE naehe_befund AS ENUM ('BESTANDEN','GESPERRT','MENSCHLICH_ZU_PRUEFEN');
EXCEPTION WHEN duplicate_object THEN NULL; END $$;

-- 10d · V4/B · Lizenz in SPDX-Schreibweise (O-K08-4) ------------------
-- license bleibt ein Textfeld -- so gezeichnet. Verbindlich wird die
-- SCHREIBWEISE und die Pflicht vor der Freigabe. Welche Werte die Maske
-- anbietet, prueft der Server gegen die Liste im Manifest (V3/A); dieselbe
-- Bauart wie bei den sechzehn Agentenrollen, wo role_kind Text bleibt.
DO $$ BEGIN
  -- K08-M17: vor der Freigabe ist die Lizenz gefuellt.
  IF NOT EXISTS (SELECT 1 FROM pg_constraint WHERE conname = 'ks_released_braucht_lizenz') THEN
    ALTER TABLE knowledge_source ADD CONSTRAINT ks_released_braucht_lizenz
      CHECK (status <> 'RELEASED' OR (license IS NOT NULL AND btrim(license) <> ''));
  END IF;
  -- SPDX-Schreibweise: Kurzname oder LicenseRef-... fuer Bedingungen, die
  -- SPDX nicht kennt (BaFin-Nutzungsbedingungen, ISO-20022-IPR, bpmn-js).
  IF NOT EXISTS (SELECT 1 FROM pg_constraint WHERE conname = 'lizenz_spdx_form') THEN
    ALTER TABLE knowledge_source ADD CONSTRAINT lizenz_spdx_form
      CHECK (license IS NULL
             OR license ~ '^LicenseRef-[A-Za-z0-9.-]+$'
             OR license ~ '^[A-Za-z0-9][A-Za-z0-9.+-]*$');
  END IF;
  -- K08-M18: OSS-Quellen liefern nur unter MIT oder Apache-2.0 aus.
  IF NOT EXISTS (SELECT 1 FROM pg_constraint WHERE conname = 'oss_nur_mit_apache') THEN
    ALTER TABLE knowledge_source ADD CONSTRAINT oss_nur_mit_apache
      CHECK (type <> 'OSS' OR status <> 'RELEASED'
             OR license IN ('MIT','Apache-2.0'));
  END IF;
END $$;

-- 10e · V5/B · Nummernvorrat (O-K20-3, O-K08-9) -----------------------
-- Eine Zeile je Praefix mit der naechsten freien Nummer. Der Server erhoeht
-- sie und nimmt den Wert in DERSELBEN Transaktion, in der das Konto entsteht
-- oder die Freigabe wirksam wird.
--
-- MITGEZEICHNET (V5/B, ausdruecklich): Bricht der Vorgang ab, laeuft die
-- Nummer zurueck in den Vorrat, weil auch die Erhoehung zurueckgerollt wird.
-- "Niemals wiederverwendet" meint die VERGEBENE Nummer -- nicht die bloss
-- gezogene, die nie an einem Datensatz und auf keinem Beleg stand.
--
-- Eine Zaehlertabelle und keine Sequenz: eine Sequenz laesst sich nicht
-- zurueckrollen, und ein neues Praefix waere eine Schemaaenderung statt
-- eines Datensatzes.
CREATE TABLE IF NOT EXISTS nummernvorrat (
  praefix         text PRIMARY KEY,
  naechste_nummer bigint NOT NULL DEFAULT 1 CHECK (naechste_nummer >= 1),
  verwendung      text NOT NULL,
  geaendert_am    timestamptz NOT NULL DEFAULT now()
);

INSERT INTO nummernvorrat(praefix, naechste_nummer, verwendung) VALUES
  ('USER',  1, 'Konto-Kennung user_code (K20-M24)'),
  ('REG',   1, 'Registernummer register_no bei erster Freigabe (K08-M24)'),
  ('PROJ',  1, 'Projektnummer project_no (K01-M38)')
ON CONFLICT (praefix) DO NOTHING;

-- K08-M24: register_no ist ab RELEASED Pflicht und danach unveraenderlich.
DO $$ BEGIN
  IF NOT EXISTS (SELECT 1 FROM pg_constraint WHERE conname = 'ks_released_braucht_register_no') THEN
    ALTER TABLE knowledge_source ADD CONSTRAINT ks_released_braucht_register_no
      CHECK (status <> 'RELEASED' OR register_no IS NOT NULL);
  END IF;
END $$;

CREATE OR REPLACE FUNCTION register_no_unveraenderlich() RETURNS trigger
LANGUAGE plpgsql AS $$
BEGIN
  IF OLD.register_no IS NOT NULL AND NEW.register_no IS DISTINCT FROM OLD.register_no THEN
    RAISE EXCEPTION 'REGISTERNUMMER: einmal vergeben, unveraenderlich (K08-M24)'
      USING ERRCODE = 'check_violation';
  END IF;
  RETURN NEW;
END $$;

CREATE OR REPLACE TRIGGER register_no_unveraenderlich_trg
  BEFORE UPDATE OF register_no ON knowledge_source
  FOR EACH ROW EXECUTE FUNCTION register_no_unveraenderlich();

-- 10f · V6/B · Typisierter Freigabebezug, vier Spalten (O-K08-8) ------
-- approval.object_ref war Freitext. K14-M08 verlangt Objektart, Schluessel
-- und Version -- eine Zeichenkette erfuellt das nur, solange jemand sie
-- richtig zusammensetzt.
--
-- DIE VIERTE SPALTE IST DER KERN. Ohne den Anlass fallen 'APP:x:BEAUFTRAGUNG'
-- und 'APP:x:PAUSIERT->BEAUFTRAGT' auf dasselbe Wertetripel zusammen: eine
-- Freigabe fuer die Beauftragung liesse den Rueckweg aus der Pause mit
-- durch, und der Pruefzeile MT-12 waere ihr Gegenstand entzogen.
--
-- Die sieben Objektarten: sechs aus der K14-Matrix (die siebte Zeile,
-- Ruecknahme, nennt kein eigenes Objekt, sondern "dasselbe Objekt") plus
-- app, das M30 verlangt und das in der Matrix fehlt.
DO $$ BEGIN
  CREATE TYPE approval_object AS ENUM
    ('KNOWLEDGE_SOURCE','KNOWLEDGE_MODULE_VERSION','TEMPLATE_VERSION',
     'POLICY_VERSION','AGENT','UEBERGABE_PAKET','APP');
EXCEPTION WHEN duplicate_object THEN NULL; END $$;

DO $$ BEGIN
  CREATE TYPE approval_reason AS ENUM
    ('FREIGABE','RUECKNAHME','BEAUFTRAGUNG',
     'ABNAHME','IN_PROD','PAUSIERT_NACH_BEAUFTRAGT');   -- die drei Zwei-Personen-Uebergaenge
EXCEPTION WHEN duplicate_object THEN NULL; END $$;

ALTER TABLE approval ADD COLUMN IF NOT EXISTS objekt_art     approval_object;
ALTER TABLE approval ADD COLUMN IF NOT EXISTS objekt_id      text;
ALTER TABLE approval ADD COLUMN IF NOT EXISTS objekt_version text;
ALTER TABLE approval ADD COLUMN IF NOT EXISTS anlass         approval_reason;
-- O-K14-2, zweiter Teil: eine Mandantenspalte waere heute nicht befuellbar --
-- von den sieben Objektarten traegt allein app eine Mandantenkennung.
-- Deshalb ein Kann-Feld; Pflicht wird es fruehestens nach O-K08-3/7.
ALTER TABLE approval ADD COLUMN IF NOT EXISTS tenant_id uuid REFERENCES tenant(id);

DO $$ BEGIN
  -- Entweder ganz typisiert oder gar nicht. Ein halber Bezug waere schlimmer
  -- als der alte Freitext: er saehe geprueft aus.
  IF NOT EXISTS (SELECT 1 FROM pg_constraint WHERE conname = 'approval_bezug_ganz') THEN
    ALTER TABLE approval ADD CONSTRAINT approval_bezug_ganz
      CHECK (objekt_art IS NULL
             OR (objekt_id IS NOT NULL AND anlass IS NOT NULL));
  END IF;
END $$;

-- Ein einziger Waechter prueft je Art, ob das bezeichnete Objekt wirklich
-- existiert. object_ref bleibt daneben als ABGELEITETER Text bestehen -- so
-- lassen sich die drei vorhandenen Waechter und die Pruefzeilen in einem
-- Schritt umstellen statt in fuenf.
CREATE OR REPLACE FUNCTION approval_bezug_guard() RETURNS trigger
LANGUAGE plpgsql AS $$
DECLARE da boolean;
BEGIN
  IF NEW.objekt_art IS NULL THEN
    RETURN NEW;                     -- Altform, Freitext in object_ref
  END IF;
  -- Der halbe Bezug gehoert der Bedingung approval_bezug_ganz, nicht diesem
  -- Waechter. Ohne diese Zeile meldete er "objekt <NULL> existiert nicht" --
  -- richtig abgewiesen, falsch begruendet. Zweiter Fall dieser Art an einem
  -- Abend; beide Male fing ein Ausloeser den Fall vor der Bedingung ab.
  IF NEW.objekt_id IS NULL OR NEW.anlass IS NULL THEN
    RETURN NEW;
  END IF;
  da := CASE NEW.objekt_art
    WHEN 'KNOWLEDGE_SOURCE' THEN
      EXISTS (SELECT 1 FROM knowledge_source WHERE id = NEW.objekt_id)
    WHEN 'TEMPLATE_VERSION' THEN
      EXISTS (SELECT 1 FROM template_version
               WHERE template_id = NEW.objekt_id AND version = NEW.objekt_version)
    WHEN 'POLICY_VERSION' THEN
      EXISTS (SELECT 1 FROM policy_version
               WHERE policy_id = NEW.objekt_id AND version = NEW.objekt_version)
    WHEN 'KNOWLEDGE_MODULE_VERSION' THEN
      EXISTS (SELECT 1 FROM knowledge_module_version
               WHERE module_id = NEW.objekt_id AND version = NEW.objekt_version)
    WHEN 'AGENT' THEN
      EXISTS (SELECT 1 FROM agent WHERE id::text = NEW.objekt_id)
    WHEN 'APP' THEN
      EXISTS (SELECT 1 FROM app WHERE id::text = NEW.objekt_id)
    -- Das Uebergabe-Paket ist nach K14 ueber Manifest- und Archivpruefsumme
    -- bezeichnet und hat KEINE Tabelle. Es laesst sich hier nicht nachsehen;
    -- das ist kein Versehen, sondern die Lage (K10 Abschn. 3).
    WHEN 'UEBERGABE_PAKET' THEN true
  END;
  IF NOT da THEN
    RAISE EXCEPTION 'FREIGABEBEZUG: % % existiert nicht (K14-M08)',
      NEW.objekt_art, NEW.objekt_id USING ERRCODE = 'foreign_key_violation';
  END IF;
  -- Der abgeleitete Text, damit die vorhandenen Waechter weiterlesen koennen.
  NEW.object_ref := upper(NEW.objekt_art::text) || ':' || NEW.objekt_id
                    || COALESCE(':' || NEW.objekt_version, '')
                    || ':' || NEW.anlass::text;
  RETURN NEW;
END $$;

CREATE OR REPLACE TRIGGER approval_bezug_guard_trg
  BEFORE INSERT ON approval
  FOR EACH ROW EXECUTE FUNCTION approval_bezug_guard();

-- F-13 (Fremdreview K14): K14-D09 verbietet Aenderungen an einer Freigabezeile
-- -- "neue Freigabezeile, nie Aenderung der alten". Der Bezugswaechter lief
-- bisher auch BEI UPDATE und pruefte die Aenderung, statt sie abzuweisen.
-- Eine Freigabe, die sich nachtraeglich auf ein anderes Objekt umschreiben
-- laesst, ist keine.
CREATE OR REPLACE TRIGGER approval_unveraenderlich
  BEFORE UPDATE OR DELETE ON approval
  FOR EACH ROW EXECUTE FUNCTION append_only_guard();

-- 10g · O-K08-1/5 · Die drei Spalten aus K08-M23 ---------------------
-- K08-M23 ist am 2.8.2026 gezeichnet und verlangt woertlich:
-- "knowledge_source erhaelt short_description, meta_tags, owner_id und einen
-- standardisierten Lizenzbezeichner." Die drei Namen standen seit dem
-- 4.8. als einzige im Quellenabgleich -- eine gezeichnete Klausel verlangte
-- etwas, das es nirgends gab.
--
-- WORAUF owner_id ZEIGT, war offen. Die Antwort ist ABGELEITET, nicht
-- erfunden: Beschluss Nr. 48 zeichnet fuer event.actor_id die Bauart
-- "Feste Verknuepfung zum Konto plus historisierter Namensschnappschuss",
-- und knowledge_module traegt owner_label bereits als Text. Beides zusammen
-- ergibt genau ein Paar -- Fremdschluessel fuer die Verknuepfung,
-- Textspalte fuer den Namen zum Zeitpunkt der Freigabe.
--
-- Der Grund fuer das Paar steht in Nr. 48: ein Konto kann umbenannt oder
-- geloescht werden. Der Fremdschluessel allein verloere dann den Namen, die
-- Textspalte allein die Verknuepfung.
ALTER TABLE knowledge_source ADD COLUMN IF NOT EXISTS short_description text;
ALTER TABLE knowledge_source ADD COLUMN IF NOT EXISTS meta_tags          text[];
ALTER TABLE knowledge_source ADD COLUMN IF NOT EXISTS owner_id           uuid
  REFERENCES actor(id) ON DELETE SET NULL;
ALTER TABLE knowledge_source ADD COLUMN IF NOT EXISTS owner_label        text;
ALTER TABLE knowledge_source ADD COLUMN IF NOT EXISTS zweck              text;

DO $$ BEGIN
  -- K08-M23, zweiter Satz: "Vor RELEASED sind Kurzbeschreibung, Zweck,
  -- Lizenz, Owner und K14-Freigabenachweis Pflicht." Lizenz steht schon in
  -- 10d; der Freigabenachweis haengt an O-K08-8 (approval) und bleibt offen.
  IF NOT EXISTS (SELECT 1 FROM pg_constraint WHERE conname = 'ks_released_braucht_pflichtangaben') THEN
    ALTER TABLE knowledge_source ADD CONSTRAINT ks_released_braucht_pflichtangaben
      CHECK (status <> 'RELEASED'
             OR (short_description IS NOT NULL AND btrim(short_description) <> ''
                 AND zweck IS NOT NULL AND btrim(zweck) <> ''
                 AND owner_label IS NOT NULL AND btrim(owner_label) <> ''));
  END IF;
  -- Der Namensschnappschuss ist Pflicht, sobald ein Konto verknuepft ist --
  -- sonst waere die Loeschung des Kontos ein Datenverlust (Nr. 48).
  IF NOT EXISTS (SELECT 1 FROM pg_constraint WHERE conname = 'ks_owner_paarweise') THEN
    ALTER TABLE knowledge_source ADD CONSTRAINT ks_owner_paarweise
      CHECK (owner_id IS NULL OR owner_label IS NOT NULL);
  END IF;
END $$;

-- 10h · F-08 · Eigene Klasse fuer Protokollzeilen (Nr. 60, K02-M17) ---
-- K02-M17 woertlich: "eine eigene Klasse fuer unveraenderbare Ereigniszeilen
-- -- ohne Faelligkeit und ohne Anonymisierung, nicht das Betriebsprotokoll."
-- Bis heute trug event BETRIEBSPROTOKOLL, und MT-17 prueft, dass die
-- Pseudonymisierung GESETZT ist. Der Prueffall bestand, weil er den Ist-Stand
-- mass -- nicht die Klausel. Ein Prueffall, der das Gegenteil seiner Klausel
-- bestaetigt, ist schlimmer als keiner: er meldet gruen.
INSERT INTO retention_rule(class,bezeichnung,fristbeginn,regelfrist_monate,
                           regelfrist_tage,mindestfrist_monate,
                           pseudonymisieren_nach_monaten,rechtsgrundlage)
VALUES ('EREIGNIS','Unveraenderbare Ereigniszeilen (Protokoll)',
        'BEZUGSOBJEKT',NULL,NULL,0,NULL,
        'Beschluss Nr. 60 (Option A) und Nr. 16: Beweiswert vor Loeschzusage. '
        'Ohne Faelligkeit und ohne Anonymisierung -- die Zeile bleibt, wie sie ist')
ON CONFLICT (class) DO NOTHING;

ALTER TABLE event ALTER COLUMN retention_class SET DEFAULT 'EREIGNIS';
-- Auf frischer Datenbank genuegt der Vorgabewert. Bei Altbestand waere
-- zusaetzlich noetig: UPDATE event SET retention_class='EREIGNIS'
--   WHERE retention_class='BETRIEBSPROTOKOLL';

-- =====================================================================
-- STUFE 9 · Nachtrag aus dem Befund vom 5.8.2026
-- =====================================================================
-- HERKUNFT: In der Nacht zum 5.8. wurde ueber alle 25 Konzepte
-- nachgerechnet, welche offenen Punkte sich als "geschlossen ·
-- Datenmodellauftrag" bezeichnen und dabei nirgends einen Traeger haben.
-- Ergebnis: 44 ohne Deckung, davon 24 Bausperrer.
--
-- DIESE STUFE BAUT NUR, WAS OHNE NEUE ENTSCHEIDUNG BAUBAR IST.
-- Sie steht bewusst getrennt von den Stufen 1 bis 7: jene setzen die 29
-- Zeilen der Aenderungsmatrix um, diese traegt nach, was in der Matrix
-- nie angekommen ist. Wer die Migration prueft, soll beides unterscheiden
-- koennen.
--
-- NICHT HIER, weil vorher zu zeichnen (Vorentscheidungen V1 bis V6):
--   O-K01-6, O-K01-20, O-K04-5, O-K13-1, O-K14-4, O-K21-1/2  -> Rollenmodell
--   O-K06-1..3, O-K09-1/2, O-K09-5                            -> Artefaktbegriff
--   O-K17-4, O-K17-13                                         -> Manifestgestalt
--   O-K08-1/5, O-K08-3/7, O-K08-4, O-K08-6, O-K08-8, O-K08-9  -> Lizenz, RLS,
--                                                                Freigabetabelle
--   O-K20-3                                                   -> Nummernvorrat
--
-- NACHTRAG 5.8.2026, abends: DIESE LISTE IST UEBERHOLT. Sie stammt vom
-- Vormittag. Seither sind V1 bis V6 gezeichnet und als Stufe 10 gebaut, dazu
-- T1 bis T4 aus den Fremdreviews als Stufen 11 und 12. Von den oben
-- aufgefuehrten Punkten tragen jetzt:
--   O-K01-6  -> Eignungsriegel in lifecycle_transition_guard (Stufe 10)
--   O-K09-1/2, O-K09-5 -> document_version (Stufe 10a)
--   O-K17-4, O-K17-13  -> model_manifest (Stufe 10b/10c)
--   O-K08-1/5 -> drei Spalten (10g) · O-K08-4 -> SPDX (10d)
--   O-K08-8   -> typisierter Bezug (10f) · O-K08-9, O-K20-3 -> Nummernvorrat (10e)
--   O-K13-1   -> sechs Dienstidentitaeten (Stufe 12, Zeichnung T1)
-- ES BLEIBEN OHNE TRAEGER: O-K08-3/7 (Mandantenbezug an knowledge_source,
-- haengt am RLS-Regime) und O-K08-6 (zwei Sichten mit fester Spaltenliste).
-- Der Kommentar wird nicht geloescht, sondern datiert fortgeschrieben: was
-- einmal galt, soll lesbar bleiben.

-- 9a · Fristen in TAGEN (O-K12-1 · A-K12-1 · A-K12-2 · O-K15-8 · Punkt 20)
-- --------------------------------------------------------------------
-- retention_rule rechnet bisher nur in Monaten. Das war schon fuer die
-- 30 Tage aus Nr. 17/35 eine Naeherung -- im Kopf dieser Datei als [N2]
-- vermerkt. Fuer die VIERZEHN Tage des geteilten Prototyps (Punkt 20,
-- BV-4 Nr. 63) reicht die Naeherung nicht mehr: vierzehn Tage sind in
-- Monaten gar nicht darstellbar, null Monate hiesse "sofort".
--
-- Deshalb eine zweite Fristspalte in Tagen. Sie ersetzt die Monatsspalte
-- nicht, sie steht daneben -- genau eine der beiden gilt je Klasse.
-- Die Spalte selbst und ihre Bedingungen stehen weiter oben in Stufe 2 --
-- sie muessen vor den Sichten stehen, weil retention_due sie benennt.

-- KURZFRIST wird von der Naeherung auf die tatsaechlichen 30 Tage
-- umgestellt. Die Zahl 30 steht so in der Pflichtangabe vom 3.8.2026;
-- "1 Monat" war eine Eigenschaft des Modells, keine des Beschlusses.
UPDATE retention_rule
   SET regelfrist_tage = 30, regelfrist_monate = NULL
 WHERE class = 'KURZFRIST' AND regelfrist_tage IS NULL;

-- Vierte Klasse: Arbeitsergebnisse (O-K12-1, A-K12-1, O-K15-8).
-- 90 Tage, Fristbeginn ERSTELLUNG, keine gesetzliche Untergrenze --
-- ein Arbeitsdokument ist kein Nachweis. Der Enum-Wert steht im Vorspann.
INSERT INTO retention_rule(class,bezeichnung,fristbeginn,regelfrist_tage,
                           regelfrist_monate,mindestfrist_monate,
                           pseudonymisieren_nach_monaten,rechtsgrundlage)
VALUES ('ARBEITSERGEBNIS','Arbeitsergebnisse ohne Nachweischarakter (Direkt-Prototyp)',
        'ERSTELLUNG',90,NULL,0,NULL,
        'Offene Punkte O-K12-1, A-K12-1, O-K15-8; kein gesetzlicher Aufbewahrungsgrund')
ON CONFLICT (class) DO NOTHING;

-- Punkt 20 (BV-4 Nr. 63): der GETEILTE Prototyp ist nach vierzehn Tagen
-- nicht mehr abrufbar. Das ist eine andere Frist als die des Prototyps
-- selbst -- deshalb eine eigene Klasse und nicht ein zweiter Wert an
-- derselben. Erst mit der Tagesspalte ueberhaupt darstellbar.
ALTER TABLE direct_prototype ADD COLUMN IF NOT EXISTS geteilt_bis date;
COMMENT ON COLUMN direct_prototype.geteilt_bis IS
  'Punkt 20: Ende der Abrufbarkeit des geteilten Prototyps, 14 Tage nach dem Teilen. '
  'NULL = nicht geteilt. Der Traeger ist hier, die Frist rechnet der Teilen-Befehl.';

-- A-K12-2: neu angelegte Direkt-Prototypen tragen kuenftig die neue Klasse.
-- Auf frischer Datenbank ist das der Vorgabewert; bei Altbestand waere
-- zusaetzlich ein UPDATE noetig (hier bewusst nicht, H06 Schritt 1).
ALTER TABLE direct_prototype
  ALTER COLUMN retention_class SET DEFAULT 'ARBEITSERGEBNIS';

-- 9b · Telemetriestand je Agent (O-K17-5) -----------------------------
-- K17 rechnet eine 26-Stunden-Schwelle gegen den letzten Telemetrielauf.
-- Der Zeitpunkt hatte bisher keinen Ort; die Schwelle war damit nicht
-- berechenbar. WER schreibt, ist Betrieb und keine Datenmodellfrage.
ALTER TABLE agent ADD COLUMN IF NOT EXISTS telemetrie_stand_at timestamptz;

-- 9c · policy_aktuell mit fester Spaltenliste (O-K21-6) ---------------
-- Die Sicht las bisher "SELECT p.*". Damit war body_md (K21-M19, in
-- Stufe 3i ergaenzt) ueber den Lesepfad unsichtbar -- die Spalte stand
-- da, kam aber nirgends an. K08-M25 verlangt aus demselben Grund feste
-- Spaltenlisten: was eine Sicht fuehrt, soll dastehen und nicht davon
-- abhaengen, welche Spalten die Tabelle gerade hat.
CREATE OR REPLACE VIEW policy_aktuell AS
  SELECT p.id, p.name, p.scope, p.template_id,
         v.version, v.status, v.gueltig, v.editor, v.aenderungsvermerk,
         v.erfasst_am, v.body_md
    FROM policy p JOIN policy_version v ON v.policy_id = p.id
   WHERE v.gueltig @> CURRENT_DATE;

-- =====================================================================
-- STUFE 11 · T4 · Der Mandantenbezug einer Freigabe (gez. M. Veil, 5.8.2026)
-- =====================================================================
-- Das K14-Review hat die Begruendung fuer das Kann-Feld verworfen: Dass nur
-- eine von sieben Objektarten den Mandanten direkt fuehrt, ist kein Grund,
-- das Feld fuer alle unverbindlich zu lassen -- es zeigt eine ungeloeste
-- Modellierungsfrage. Zeichnung T4 folgt dem Review.
--
-- Der Kern der Aenderung ist nicht die Pflicht, sondern das Ende der stillen
-- Doppelbedeutung: NULL hiess bisher zugleich "global" und "wissen wir nicht".
-- Jetzt sagt es eine eigene Spalte.

DO $$ BEGIN
  CREATE TYPE approval_tenant_scope AS ENUM
    ('MANDANT',    -- gehoert genau einem Mandanten; tenant_id ist Pflicht
     'GLOBAL',     -- gilt ueber alle Mandanten; tenant_id MUSS leer sein
     'MITTELBAR'); -- mandantenbezogen ueber den Eigentuemer, nicht direkt
EXCEPTION WHEN duplicate_object THEN NULL; END $$;

ALTER TABLE approval ADD COLUMN IF NOT EXISTS mandantenbezug approval_tenant_scope;

-- Bestandszeilen: Was typisiert ist, bekommt seinen Bezug; untypisierter
-- Altbestand bleibt leer, weil ein geratener Wert schlimmer waere als keiner.
UPDATE approval SET mandantenbezug =
  CASE objekt_art
    WHEN 'APP'                      THEN 'MANDANT'::approval_tenant_scope
    WHEN 'POLICY_VERSION'           THEN 'GLOBAL'::approval_tenant_scope
    WHEN 'UEBERGABE_PAKET'          THEN 'GLOBAL'::approval_tenant_scope
    WHEN 'AGENT'                    THEN 'GLOBAL'::approval_tenant_scope
    WHEN 'TEMPLATE_VERSION'         THEN 'GLOBAL'::approval_tenant_scope
    WHEN 'KNOWLEDGE_SOURCE'         THEN 'MITTELBAR'::approval_tenant_scope
    WHEN 'KNOWLEDGE_MODULE_VERSION' THEN 'MITTELBAR'::approval_tenant_scope
  END
 WHERE objekt_art IS NOT NULL AND mandantenbezug IS NULL;

DO $$ BEGIN
  -- Wer typisiert ist, nennt seinen Mandantenbezug. Ganz oder gar nicht --
  -- dieselbe Regel wie bei approval_bezug_ganz eine Stufe darueber.
  IF NOT EXISTS (SELECT 1 FROM pg_constraint WHERE conname = 'approval_mandant_ganz') THEN
    ALTER TABLE approval ADD CONSTRAINT approval_mandant_ganz
      CHECK (objekt_art IS NULL OR mandantenbezug IS NOT NULL);
  END IF;

  -- Und der Bezug sagt, ob die Spalte gefuellt sein muss oder leer sein soll.
  IF NOT EXISTS (SELECT 1 FROM pg_constraint WHERE conname = 'approval_mandant_passt') THEN
    ALTER TABLE approval ADD CONSTRAINT approval_mandant_passt
      CHECK (mandantenbezug IS NULL
             OR (mandantenbezug = 'MANDANT'  AND tenant_id IS NOT NULL)
             OR (mandantenbezug = 'GLOBAL'   AND tenant_id IS NULL)
             OR (mandantenbezug = 'MITTELBAR'));
  END IF;

  -- APP ist immer mandantengebunden. Das ist keine Konvention, sondern folgt
  -- daraus, dass app selbst eine Mandantenspalte fuehrt.
  IF NOT EXISTS (SELECT 1 FROM pg_constraint WHERE conname = 'approval_app_ist_mandant') THEN
    ALTER TABLE approval ADD CONSTRAINT approval_app_ist_mandant
      CHECK (objekt_art IS DISTINCT FROM 'APP' OR mandantenbezug = 'MANDANT');
  END IF;
END $$;

-- Der Abgleich gegen app.tenant_id. Er kann kein CHECK sein -- eine
-- Pruefbedingung darf keine andere Tabelle lesen.
CREATE OR REPLACE FUNCTION approval_mandant_guard() RETURNS trigger
LANGUAGE plpgsql AS $$
DECLARE app_mandant uuid;
BEGIN
  IF NEW.objekt_art IS DISTINCT FROM 'APP' THEN
    RETURN NEW;                       -- nicht zustaendig: durchlassen
  END IF;

  SELECT a.tenant_id INTO app_mandant FROM app a WHERE a.id::text = NEW.objekt_id;

  IF app_mandant IS NULL THEN
    RETURN NEW;                       -- die Existenz prueft approval_bezug_guard
  END IF;

  -- Der leere Fall gehoert der Pruefbedingung approval_mandant_passt, nicht
  -- diesem Waechter. Wer ihn hier abfaengt, laesst den Gegentest an der
  -- falschen Regel scheitern -- und nach F07 ist ein solcher Test nicht
  -- bestanden. Derselbe Fehler ist in dieser Migration dreimal vorher
  -- passiert (MT-38, MT-73, MT-03).
  IF NEW.tenant_id IS NULL THEN
    RETURN NEW;
  END IF;

  IF NEW.tenant_id IS DISTINCT FROM app_mandant THEN
    RAISE EXCEPTION 'MANDANTENBEZUG: die Freigabe nennt Mandant %, die Anwendung gehoert Mandant % (K14, O-K14-2, Zeichnung T4)',
      NEW.tenant_id, app_mandant USING ERRCODE = 'check_violation';
  END IF;
  RETURN NEW;
END $$;

CREATE OR REPLACE TRIGGER approval_mandant_guard_trg
  BEFORE INSERT ON approval
  FOR EACH ROW EXECUTE FUNCTION approval_mandant_guard();

COMMENT ON COLUMN approval.mandantenbezug IS
  'Zeichnung T4 vom 05.08.2026: MANDANT | GLOBAL | MITTELBAR. Loest die stille '
  'Doppelbedeutung von tenant_id IS NULL auf. MITTELBAR heisst: der Mandant steht '
  'am Eigentuemer, nicht an der Freigabe -- aufzuloesen mit O-K08-3/7.';


-- =====================================================================
-- STUFE 12 · T1 · Die sechs Dienstidentitaeten (gez. M. Veil, 5.8.2026)
-- =====================================================================
-- K13-M18: "Jede Laufzeitkomponente MUSS eine eigene minimal berechtigte
-- Dienstidentitaet besitzen." O-K13-1 hielt fest: "Offen bleibt die
-- namentliche Besetzung." Sie ist am 5.8.2026 gezeichnet.
--
-- WAS HIER NICHT STEHT: Kennwoerter. K13-M17 verbietet langlebige
-- Geheimnisse in Code -- die Rollen entstehen ohne Anmeldung, und wer sich
-- als sie anmeldet, wird ausserhalb dieser Datei zugeordnet.
--
-- WAS HIER AUCH NICHT STEHT: das vollstaendige RLS-Regime. Diese Stufe
-- benennt die Identitaeten und schneidet die Rechte; die Zeilenregeln je
-- Tabelle sind Punkt 09 und bleiben offen. Wer beides vermengt, haelt den
-- halben Bau fuer den ganzen.

DO $$
DECLARE r text;
BEGIN
  FOREACH r IN ARRAY ARRAY['fr_portal','fr_broker','fr_modell',
                           'fr_migration','fr_wartung','fr_pruefung'] LOOP
    IF NOT EXISTS (SELECT 1 FROM pg_roles WHERE rolname = r) THEN
      -- NOLOGIN: die Rolle ist ein Rechteschnitt, kein Konto.
      -- NOBYPASSRLS ist Vorgabe und steht hier, weil K13-M18 es ausdruecklich
      -- verlangt: "Die normale Serveridentitaet darf RLS nicht umgehen."
      EXECUTE format('CREATE ROLE %I NOLOGIN NOSUPERUSER NOCREATEDB '
                     'NOCREATEROLE NOBYPASSRLS', r);
    END IF;
  END LOOP;
END $$;

-- Ausgangslage fuer alle sechs: nichts. Was danach kommt, ist einzeln erteilt.
DO $$
DECLARE r text;
BEGIN
  FOREACH r IN ARRAY ARRAY['fr_portal','fr_broker','fr_modell',
                           'fr_migration','fr_wartung','fr_pruefung'] LOOP
    EXECUTE format('REVOKE ALL ON ALL TABLES    IN SCHEMA public FROM %I', r);
    EXECUTE format('REVOKE ALL ON ALL SEQUENCES IN SCHEMA public FROM %I', r);
    EXECUTE format('REVOKE ALL ON SCHEMA public FROM %I', r);
    EXECUTE format('GRANT USAGE ON SCHEMA public TO %I', r);
  END LOOP;
END $$;

-- fr_pruefung darf lesen und sonst nichts. Eine Abnahme, die schreiben kann,
-- ist keine Abnahme.
GRANT SELECT ON ALL TABLES IN SCHEMA public TO fr_pruefung;

-- fr_wartung: privilegiert, aber nicht dauerhaft. Die Befristung ist eine
-- Betriebsregel, keine Datenbankeigenschaft -- sie steht in O-K13-1.
GRANT SELECT, INSERT, UPDATE, DELETE ON ALL TABLES IN SCHEMA public TO fr_wartung;
GRANT USAGE ON ALL SEQUENCES IN SCHEMA public TO fr_wartung;

-- fr_migration bekommt hier nichts: DDL macht der Eigentuemer. Die Rolle
-- existiert, damit der Betrieb sie besetzen kann, ohne sie zu erfinden.

-- fr_portal: der Serverpfad beider Portale. Lesen und schreiben im Rahmen der
-- Zeilenregeln, kein DELETE -- das Loeschen laeuft nach K15 ueber einen
-- eigenen Weg mit Zwei-Personen-Freigabe, nicht ueber den Portalpfad.
-- OFFEN GEGENUEBER O-K01-20: Der Punkt verlangt, dass Anlage und
-- Zustandswechsel NUR ueber create_app_after_fit und change_app_state laufen
-- und "direkte Tabellenrechte entzogen bleiben". Der Riegel steht (Stufe 10,
-- lifecycle_transition_guard) -- die Rechteentziehung nicht: fr_portal haelt
-- hier INSERT auf app. Sie laesst sich erst entziehen, wenn die beiden
-- Serverbefehle als privilegierte Funktionen existieren; heute sind es
-- Anwendungsbefehle. Wer das Recht vorher entzieht, nimmt dem Portal die
-- Anlage, statt sie zu kanalisieren. Gehoert in die Negativmatrix zu O-K13-1.
GRANT SELECT, INSERT, UPDATE ON ALL TABLES IN SCHEMA public TO fr_portal;
GRANT USAGE ON ALL SEQUENCES IN SCHEMA public TO fr_portal;

-- fr_broker: der Quellenbroker nach K13-M21. Er liest Quellen und schreibt
-- Protokoll. Konten, Freigaben und Anmeldecodes gehen ihn nichts an.
GRANT SELECT ON knowledge_source TO fr_broker;
GRANT INSERT ON event            TO fr_broker;

-- fr_modell: der Modellpfad nach K13-M22. Er schreibt Protokoll und liest,
-- was der Aufruf braucht -- keine Tabelle mit Personenbezug ohne benannten
-- Zweck.
GRANT INSERT ON event TO fr_modell;
DO $$ BEGIN
  IF to_regclass('public.model_manifest') IS NOT NULL THEN
    EXECUTE 'GRANT SELECT ON model_manifest TO fr_modell';
  END IF;
END $$;

-- Und die ausdruecklichen Verbote der Zeichnung. Sie sind nach dem REVOKE
-- oben technisch schon erfuellt; sie stehen hier trotzdem, weil ein spaeteres
-- GRANT ALL sie sonst still mitnimmt.
DO $$
DECLARE t text;
BEGIN
  FOREACH t IN ARRAY ARRAY['actor','approval','login_code'] LOOP
    IF to_regclass('public.' || t) IS NOT NULL THEN
      EXECUTE format('REVOKE ALL ON %I FROM fr_broker', t);
      EXECUTE format('REVOKE ALL ON %I FROM fr_modell', t);
    END IF;
  END LOOP;
END $$;

-- Der feste Suchpfad (Befund F-05) stand hier und steht jetzt am ENDE
-- dieser Datei: Stufe 13 legt nach Stufe 12 eine weitere Funktion an,
-- und die blieb ohne. MT-88 hat es gefunden.



-- =====================================================================
-- STUFE 13 · P3 · Mehrere Einladungsdomaenen je Mandant (gez. 5.8.2026)
-- =====================================================================
-- tenant.invite_domain war eine einzelne Textspalte. Ein Kunde mit mehreren
-- Marken oder externen Beratern liess sich nur ueber NULL abbilden -- und NULL
-- heisst nicht "mehrere erlaubt", sondern SCHRANKE ABGESCHALTET. Der Ausloeser
-- tenant_domain_audit protokolliert das seit Stufe 6 mit genau diesem Wort.
--
-- Eine Liste ist eine Tabelle, kein Trennzeichen. Ein Trennzeichen liesse sich
-- nicht pruefen, nicht indizieren und nicht mit einem Fremdschluessel sichern
-- -- derselbe Fehler wie object_ref als Freitext (V6/B) und policy_aktuell
-- mit SELECT * (O-K21-6). Beide sind an diesem Tag behoben worden.

CREATE TABLE IF NOT EXISTS tenant_invite_domain (
  tenant_id  uuid NOT NULL REFERENCES tenant(id) ON DELETE CASCADE,
  domain     text NOT NULL,
  created_at timestamptz NOT NULL DEFAULT now(),
  PRIMARY KEY (tenant_id, domain),
  -- Kleingeschrieben und ohne Rand: sonst waeren "Demobank.de" und
  -- "demobank.de" zwei Domaenen, und die Schranke haette ein Loch.
  CONSTRAINT invite_domain_klein CHECK (domain = lower(btrim(domain))),
  CONSTRAINT invite_domain_form  CHECK (domain ~* '^[a-z0-9]([a-z0-9-]*[a-z0-9])?(\.[a-z0-9]([a-z0-9-]*[a-z0-9])?)+$')
);

-- Uebernahme: jede heute gesetzte Domaene wird eine Zeile. NULL bleibt NULL --
-- es ist keine Domaene, sondern eine abgeschaltete Schranke, und die wird hier
-- nicht stillschweigend zu einer Liste umgedeutet.
INSERT INTO tenant_invite_domain(tenant_id, domain)
SELECT id, lower(btrim(invite_domain)) FROM tenant
 WHERE invite_domain IS NOT NULL AND btrim(invite_domain) <> ''
ON CONFLICT DO NOTHING;

-- Der Ausloeser aus Stufe 6 bewacht weiterhin die Spalte. Fuer die Tabelle
-- kommt derselbe Schutz dazu: JEDE Zeile ist ein Sicherheitsereignis, ihr
-- Wegfall erst recht.
CREATE OR REPLACE FUNCTION tenant_invite_domain_audit() RETURNS trigger
LANGUAGE plpgsql AS $$
DECLARE m uuid; d text; was text;
BEGIN
  IF TG_OP = 'DELETE' THEN m := OLD.tenant_id; d := OLD.domain; was := 'entfernt';
  ELSE                     m := NEW.tenant_id; d := NEW.domain; was := 'aufgenommen';
  END IF;
  INSERT INTO event(tenant_id, source, action, actor_label, object_ref,
                    change_type, value)
  VALUES (m, 'PORTAL_ACTION', 'INVITE_DOMAIN_CHANGED', current_user,
          'TENANT_INVITE_DOMAIN:' || m::text, was, d);
  RETURN COALESCE(NEW, OLD);
END $$;

CREATE OR REPLACE TRIGGER tenant_invite_domain_audit_trg
  AFTER INSERT OR DELETE ON tenant_invite_domain
  FOR EACH ROW EXECUTE FUNCTION tenant_invite_domain_audit();

COMMENT ON TABLE tenant_invite_domain IS
  'Zeichnung P3 vom 05.08.2026 (O-K03-12). Die Liste zugelassener '
  'Einladungsdomaenen je Mandant. tenant.invite_domain bleibt zunaechst '
  'stehen und wird abgeleitet; sie faellt erst, wenn der Serverpfad umgestellt '
  'ist -- eine Spalte zu entfernen, deren Leser man nicht kennt, ist keine '
  'Migration, sondern ein Versuch.';

-- =====================================================================
-- STUFE 14 · Die zwei Serverbefehle als privilegierte Funktionen
--            (gez. M. Veil, 5.8.2026, nach dem Tor-3-Delta-Review)
-- =====================================================================
-- Das Delta-Review vom 5.8. hat den Rechteschnitt aus Stufe 12 mit
-- TRAEGT NICHT beurteilt, und es hat recht: fr_portal hielt SELECT,
-- INSERT und UPDATE auf ausnahmslos alle Tabellen -- auch auf app, das
-- K01-M27 kanalisiert, und auf actor.sealed, das die Zeichnung T1
-- ausdruecklich verbietet. Der Vorbehalt im Kommentar war, wie das
-- Review es nennt, "als Nachweis der Auftragserfuellung eine Ausrede".
--
-- Der Ausweg ist der, den O-K01-20 immer gemeint hat: Die beiden
-- Serverbefehle werden zu privilegierten Funktionen, und die direkten
-- Rechte fallen. SECURITY DEFINER ist hier vertretbar, weil seit T1
-- JEDE eigene Funktion einen festen Suchpfad traegt -- das ist die
-- Bedingung, unter der Befund F-05 das Risiko begrenzt nannte.

CREATE OR REPLACE FUNCTION create_app_after_fit(
  p_tenant     uuid,
  p_project_no text,
  p_name       text,
  p_fit_check  uuid,
  p_actor      uuid)
RETURNS uuid
LANGUAGE plpgsql
SECURITY DEFINER
SET search_path = public, pg_temp
AS $$
DECLARE neu uuid; t record; a record; f record;
BEGIN
  -- K01-M27 nennt fuenf Pruefungen. Sie laufen hier, in einer Transaktion,
  -- und keine davon kann der Aufrufer umgehen -- das ist der ganze Zweck.

  SELECT * INTO t FROM tenant WHERE id = p_tenant;
  IF t IS NULL THEN
    RAISE EXCEPTION 'ANLAGE: Mandant % existiert nicht (K01-M27)', p_tenant
      USING ERRCODE = 'foreign_key_violation';
  END IF;
  IF t.legal_space <> 'DE' THEN
    RAISE EXCEPTION 'ANLAGE: Rechtsraum ist %, zulaessig ist DE (K01-M27)', t.legal_space
      USING ERRCODE = 'check_violation';
  END IF;

  SELECT * INTO a FROM actor WHERE id = p_actor;
  IF a IS NULL OR a.status <> 'AKTIV' THEN
    RAISE EXCEPTION 'ANLAGE: das Konto ist nicht aktiv (K01-M27)'
      USING ERRCODE = 'check_violation';
  END IF;
  IF a.tenant_id <> p_tenant THEN
    RAISE EXCEPTION 'ANLAGE: das Konto gehoert Mandant %, angelegt wird fuer % (K01-M27)',
      a.tenant_id, p_tenant USING ERRCODE = 'check_violation';
  END IF;

  SELECT * INTO f FROM fit_check WHERE id = p_fit_check;
  IF f IS NULL OR f.outcome <> 'GEEIGNET' THEN
    RAISE EXCEPTION 'ANLAGE: der Eignungs-Check steht nicht auf GEEIGNET (K01-M27)'
      USING ERRCODE = 'check_violation';
  END IF;
  IF f.tenant_id <> p_tenant THEN
    RAISE EXCEPTION 'ANLAGE: der Eignungs-Check gehoert einem anderen Mandanten (K01-M27, K14-D07)'
      USING ERRCODE = 'check_violation';
  END IF;

  -- currency = EUR ist Vorgabe der Spalte und wird hier nicht uebergeben:
  -- ein Parameter, den der Aufrufer setzen koennte, waere eine Luecke in
  -- genau der Pruefung, die K01-M27 verlangt.
  INSERT INTO app(tenant_id, project_no, name, fit_check_id, created_at)
  VALUES (p_tenant, p_project_no, p_name, p_fit_check, current_date)
  RETURNING id INTO neu;

  UPDATE fit_check SET app_id = neu WHERE id = p_fit_check;
  RETURN neu;
END $$;

COMMENT ON FUNCTION create_app_after_fit(uuid,text,text,uuid,uuid) IS
  'K01-M27 · O-K01-20 · Zeichnung vom 05.08.2026. Der einzige Weg zu einer '
  'app-Zeile. fr_portal hat kein INSERT auf app -- wer die Funktion umgeht, '
  'kommt nicht an der Tabelle an, sondern an einer fehlenden Berechtigung.';


CREATE OR REPLACE FUNCTION change_app_state(
  p_app   uuid,
  p_ziel  lifecycle_state,
  p_actor uuid)
RETURNS void
LANGUAGE plpgsql
SECURITY DEFINER
SET search_path = public, pg_temp
AS $$
DECLARE v record; a record;
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

  -- WELCHE Uebergaenge erlaubt sind, entscheidet die Matrix in
  -- state_transition und der Waechter lifecycle_transition_guard. Diese
  -- Funktion prueft das NICHT noch einmal -- eine zweite Stelle mit
  -- derselben Regel ist eine Stelle zu viel, und die eine, die man
  -- vergisst zu pflegen, wird die falsche.
  UPDATE app SET lifecycle_state = p_ziel WHERE id = p_app;
END $$;

COMMENT ON FUNCTION change_app_state(uuid,lifecycle_state,uuid) IS
  'K01-M28 · O-K01-20 · Zeichnung vom 05.08.2026. Der einzige Weg zu einem '
  'Zustandswechsel. Die Uebergangsregeln bleiben bei state_transition und '
  'lifecycle_transition_guard -- diese Funktion kanalisiert nur den Zugang.';


-- ---------------------------------------------------------------------
-- Und jetzt fallen die direkten Rechte
-- ---------------------------------------------------------------------
DO $$ BEGIN
  -- app: kein INSERT, kein UPDATE. Lesen bleibt -- die Uebersicht braucht es,
  -- und die Zeilenregeln (Punkt 09) begrenzen spaeter, WAS gelesen wird.
  REVOKE INSERT, UPDATE, DELETE ON app FROM fr_portal;

  -- actor.sealed: T1 verbietet die Aenderung ausdruecklich. Ein Tabellen-
  -- UPDATE kennt kein Spaltenverbot, also wird es spaltenweise erteilt.
  REVOKE UPDATE ON actor FROM fr_portal;
  GRANT UPDATE (email, display_name, mfa_method, status, status_before_lock,
                user_code, last_login_at)
    ON actor TO fr_portal;

  -- Der Weg bleibt offen -- aber nur der eine.
  GRANT EXECUTE ON FUNCTION create_app_after_fit(uuid,text,text,uuid,uuid) TO fr_portal;
  GRANT EXECUTE ON FUNCTION change_app_state(uuid,lifecycle_state,uuid)     TO fr_portal;
END $$;

-- Vorhandene gleichnamige Rollen werden nachgehaertet. Stufe 12 setzte die
-- Merkmale nur beim Anlegen -- eine Rolle, die vorher schon da war, blieb
-- damit ungehaertet. Auch das hat das Delta-Review gefunden.
--
-- KORRIGIERT 6.8.2026 (Befund N-1): NOLOGIN fehlte hier. Stufe 12 legt die
-- sechs korrekt mit NOLOGIN an (Z. 1712) -- diese Nachhaertungsschleife liess
-- das Merkmal aber aus. Eine VOR der Migration mit LOGIN angelegte
-- gleichnamige fr_*-Rolle waere damit anmeldbar geblieben, obwohl die Rolle
-- ein Rechteschnitt ist und kein Konto. Auf einer frischen Zielumgebung greift
-- der Fall nicht; die Migration sagt aber Wiederholbarkeit zu, und die gilt
-- auch gegen Umgebungen mit Altbestand.
-- KORRIGIERT 6.8.2026 (Befund N-4, gemessen auf der Zielumgebung): Diese
-- Schleife brach auf Azure Database for PostgreSQL mit "permission denied to
-- alter role" ab -- und zwar an JEDER Rolle, also an der ganzen Migration.
-- Grund: Das Administratorkonto eines Flexible Server ist KEIN SUPERUSER, und
-- PostgreSQL wertet das blosse Nennen von NOSUPERUSER in ALTER ROLE als
-- Aenderung des Superuser-Merkmals -- auch wenn es den vorhandenen Wert nur
-- bestaetigt. Gemessen am 6.8.2026: NOLOGIN, NOCREATEDB, NOCREATEROLE und
-- NOBYPASSRLS werden akzeptiert, allein NOSUPERUSER nicht. In CREATE ROLE
-- (Stufe 12) ist es dagegen zulaessig; deshalb fiel es dort nicht auf.
--
-- Die Laeufe vom 5.8.2026 liefen gegen eine Datenbank, auf der das Konto
-- SUPERUSER war. Genau diese Luecke soll N2 schliessen: eine Migration, die
-- auf der Pruefdatenbank durchlaeuft, laeuft nicht deshalb auch im Ziel.
--
-- NOSUPERUSER wird jetzt nur noch angefasst, wenn es tatsaechlich abweicht --
-- und schlaegt dann mit benannter Ursache fehl, statt still durchzugehen.
DO $$
DECLARE r text; ist_super boolean;
BEGIN
  FOREACH r IN ARRAY ARRAY['fr_portal','fr_broker','fr_modell',
                           'fr_migration','fr_wartung','fr_pruefung'] LOOP
    EXECUTE format('ALTER ROLE %I NOLOGIN NOCREATEDB NOCREATEROLE NOBYPASSRLS', r);
    SELECT rolsuper INTO ist_super FROM pg_roles WHERE rolname = r;
    IF ist_super THEN
      BEGIN
        EXECUTE format('ALTER ROLE %I NOSUPERUSER', r);
      EXCEPTION WHEN insufficient_privilege THEN
        RAISE EXCEPTION 'DIENSTIDENTITAET-SUPERUSER: Rolle % besitzt SUPERUSER und laesst sich mit diesem Konto nicht herabstufen (K13-M18). Von einem Konto mit SUPERUSER ausfuehren.', r
          USING ERRCODE = 'insufficient_privilege';
      END;
    END IF;
  END LOOP;
END $$;


-- ---------------------------------------------------------------------
-- Die Verarbeitungsregion (Beschluss Nr. 85 vom 5.8.2026)
-- ---------------------------------------------------------------------
-- KORREKTUR ZU ADD-ON 03, P2: Dort stand, das Datenmodell fuehre keine
-- Region -- "nachgezaehlt: null Treffer". Das war falsch. tenant.
-- processing_region existiert im eingefrorenen Datenmodell seit jeher,
-- mit Vorgabe swedencentral und einer Pruefbedingung, die drei Werte
-- zulaesst.
--
-- Die Zeichnung Nr. 85 ist davon nicht beruehrt -- eine Region fuer alle
-- bleibt richtig. Aber sie ist jetzt ERZWINGBAR statt nur versprochen,
-- und ein Versprechen, das die Datenbank nicht kennt, ist eines, das der
-- erste Konfigurationsfehler bricht.
DO $$ BEGIN
  IF NOT EXISTS (SELECT 1 FROM pg_constraint WHERE conname = 'region_release_1') THEN
    ALTER TABLE tenant ADD CONSTRAINT region_release_1
      CHECK (processing_region = 'swedencentral');
  END IF;
END $$;

COMMENT ON CONSTRAINT region_release_1 ON tenant IS
  'Beschluss Nr. 85 vom 05.08.2026: In Release 1 gilt eine Region fuer alle. '
  'Die Spalte laesst mehr zu; diese Bedingung faellt, wenn Release 2 mehrere '
  'Regionen zusagt -- dann als eigene Migration mit eigener Zeichnung.';


-- =====================================================================
-- STUFE 15 · H1 · Einschraenkung statt Loeschung (gez. A. Han, 5.8.2026)
-- =====================================================================
-- Ein Teilnehmer verlangt Loeschung; ein Teil seiner Daten unterliegt einer
-- handelsrechtlichen Frist. K15-G10 stellt den Fall und entscheidet ihn
-- nicht -- weder Vorrang noch Verfahren noch Nachweis.
--
-- Die Zeichnung H1 waehlt die Einschraenkung: Die Zeile bleibt, wird aber
-- gesperrt, bis die Frist ablaeuft; dann loescht der Aufbewahrungslauf sie
-- OHNE neues Verlangen. Der Grund ist nicht Bequemlichkeit -- er ist, dass
-- das Verlangen sonst verfaellt. Wer nur loescht, was loeschbar ist, hat den
-- Rest nach Ablauf der Frist immer noch da, und niemand erinnert sich.

ALTER TABLE app ADD COLUMN IF NOT EXISTS einschraenkung_ab   timestamptz;
ALTER TABLE app ADD COLUMN IF NOT EXISTS einschraenkung_grund text;

DO $$ BEGIN
  -- Eine Einschraenkung ohne Grund ist eine Sperre, die niemand erklaeren
  -- kann. Der Grund ist der Nachweis, dass ein Verlangen dahinterstand.
  IF NOT EXISTS (SELECT 1 FROM pg_constraint WHERE conname = 'einschraenkung_ganz') THEN
    ALTER TABLE app ADD CONSTRAINT einschraenkung_ganz
      CHECK ((einschraenkung_ab IS NULL AND einschraenkung_grund IS NULL)
          OR (einschraenkung_ab IS NOT NULL AND btrim(coalesce(einschraenkung_grund,'')) <> ''));
  END IF;
END $$;

-- Einmal eingeschraenkt, bleibt eingeschraenkt. Das Verlangen kann niemand
-- zuruecknehmen ausser dem Teilnehmer -- und dann ist es ein neuer Vorgang
-- mit eigenem Blatt, kein stilles UPDATE.
CREATE OR REPLACE FUNCTION einschraenkung_unumkehrbar() RETURNS trigger
LANGUAGE plpgsql AS $$
BEGIN
  IF OLD.einschraenkung_ab IS NOT NULL AND NEW.einschraenkung_ab IS NULL THEN
    RAISE EXCEPTION 'EINSCHRAENKUNG: einmal gesetzt, nicht stillschweigend aufhebbar (H1, K15)'
      USING ERRCODE = 'check_violation';
  END IF;
  RETURN NEW;
END $$;

CREATE OR REPLACE TRIGGER einschraenkung_unumkehrbar_trg
  BEFORE UPDATE OF einschraenkung_ab ON app
  FOR EACH ROW EXECUTE FUNCTION einschraenkung_unumkehrbar();

-- Die Sicht, die den Serverpfad bindet. Was hier steht, darf nicht angezeigt,
-- nicht ausgefuehrt und nicht an ein Modell gegeben werden.
CREATE OR REPLACE VIEW app_eingeschraenkt AS
  SELECT a.id, a.tenant_id, a.project_no, a.name,
         a.einschraenkung_ab, a.einschraenkung_grund, a.retention_class
    FROM app a
   WHERE a.einschraenkung_ab IS NOT NULL;

COMMENT ON VIEW app_eingeschraenkt IS
  'H1, gez. A. Han 05.08.2026. Anwendungen unter Einschraenkung nach einem '
  'Loeschverlangen, dessen Bestaende noch einer handelsrechtlichen Frist '
  'unterliegen. Sie werden nicht geloescht und nicht gezeigt -- sie warten '
  'auf ihre Faelligkeit und werden dann ohne neues Verlangen entfernt.';

COMMENT ON COLUMN app.einschraenkung_ab IS
  'H1: Zeitpunkt, ab dem die Zeile wegen eines Loeschverlangens gesperrt ist. '
  'Die Faelligkeit richtet sich weiter nach retention_class -- die '
  'Einschraenkung verkuerzt keine Frist, sie ueberbrueckt sie.';


-- =====================================================================
-- STUFE 16 · Drei Befunde aus dem Tor-3-Delta-Review vom 5.8.2026
-- =====================================================================
-- Das Delta-Review nannte vier Punkte TEILWEISE. Ich hatte gesagt, zwei
-- davon haengen am RLS-Regime und fallen erst mit Punkt 09. Beim Bauen hat
-- sich gezeigt: Das stimmt nur zur Haelfte.
--
--   16a  Der Sitzungsabgleich laesst sich JETZT bauen -- er braucht keine
--        Zeilenregeln, nur einen Ort, an dem der Serverpfad den Mandanten
--        der Anfrage hinterlegt.
--   16b  MITTELBAR laesst sich fuer knowledge_source aufloesen, weil
--        owner_id seit Stufe 10g existiert. Fuer
--        knowledge_module_version nicht -- dort gibt es keinen Eigentuemer.
--   16c  Die Kopplung zwischen login_attempt und login_code fehlte ganz.

-- ---------------------------------------------------------------------
-- 16a · Der Mandant der Sitzung (T4, Delta-Review Punkt 3)
-- ---------------------------------------------------------------------
-- Der Waechter aus Stufe 11 glich die Freigabe nur gegen app ab. Das
-- Review verlangte Objekt UND Sitzung. Der Serverpfad hinterlegt den
-- Mandanten der Anfrage in freiraum.tenant_id -- dieselbe Bauart, die
-- O-K13-1 fuer das Zeilenschutz-Regime ohnehin verlangt.
--
-- IST DIE EINSTELLUNG NICHT GESETZT, laesst der Waechter durch. Das ist
-- bewusst und benannt: Der Serverpfad setzt sie heute noch nicht, und eine
-- Sperre, die jeden Schreibvorgang abweist, waere keine Haertung, sondern
-- ein Stillstand. Sobald der Serverpfad sie setzt, greift sie -- und der
-- Gegentest MT-103 beweist, dass sie dann greift.
CREATE OR REPLACE FUNCTION sitzungs_mandant() RETURNS uuid
LANGUAGE plpgsql STABLE
SET search_path = public, pg_temp
AS $$
DECLARE roh text;
BEGIN
  roh := current_setting('freiraum.tenant_id', true);
  IF roh IS NULL OR btrim(roh) = '' THEN
    RETURN NULL;                      -- kein Serverpfad, keine Aussage
  END IF;
  RETURN roh::uuid;
EXCEPTION WHEN others THEN
  -- Ein unlesbarer Wert ist schlimmer als keiner: Er sieht aus wie ein
  -- gesetzter Mandant. Deshalb wird er gemeldet, nicht verschluckt.
  RAISE EXCEPTION 'SITZUNGSMANDANT: freiraum.tenant_id ist gesetzt, aber keine Kennung: %', roh
    USING ERRCODE = 'invalid_parameter_value';
END $$;

COMMENT ON FUNCTION sitzungs_mandant() IS
  'Der Mandant der laufenden Anfrage, vom Serverpfad in freiraum.tenant_id '
  'hinterlegt. NULL heisst: nicht gesetzt. Ob das durchgelassen oder abgewiesen '
  'wird, entscheidet freiraum.rls_enforce -- im Pilot aus, vor dem ersten '
  'Mandanten mit echten Daten an (O-K13-1, T4, Echtdaten-Tor E2).';

CREATE OR REPLACE FUNCTION approval_mandant_guard() RETURNS trigger
LANGUAGE plpgsql AS $$
DECLARE app_mandant uuid; sitzung uuid; eigner_mandant uuid;
BEGIN
  sitzung := sitzungs_mandant();

  -- 05.08.2026, nach dem zweiten Auftragsreview: Ohne gesetzte Sitzung liess
  -- der Waechter durch -- ein Fail-open, das kein Prueffall messen konnte.
  -- Jetzt entscheidet ein Schalter, und beide Seiten sind gemessen:
  --   freiraum.rls_enforce = 'on'  -> keine Sitzung, keine Zeile (fail-closed)
  --   sonst                        -> durchlassen, benannt und befristet
  -- Der Schalter steht im Pilot aus, weil der Serverpfad den Mandanten noch
  -- nicht hinterlegt; VOR dem ersten Mandanten mit echten Daten geht er an.
  -- Das ist Bauaufgabe L2 und Bedingung E2 im Echtdaten-Tor.
  IF sitzung IS NULL
     AND coalesce(current_setting('freiraum.rls_enforce', true), 'off') = 'on'
     AND NEW.tenant_id IS NOT NULL THEN
    RAISE EXCEPTION 'SITZUNGSMANDANT: keine Sitzung gesetzt, und die Durchsetzung ist eingeschaltet — die Freigabe wird abgewiesen (K14-D07, T4, fail-closed)'
      USING ERRCODE = 'check_violation';
  END IF;

  -- Der Sitzungsabgleich gilt fuer JEDE typisierte Freigabe mit Mandant,
  -- nicht nur fuer APP. Wer im Namen eines Mandanten angemeldet ist, zeichnet
  -- nicht fuer einen anderen (K14-D07).
  IF sitzung IS NOT NULL AND NEW.tenant_id IS NOT NULL
     AND NEW.tenant_id <> sitzung THEN
    RAISE EXCEPTION 'SITZUNGSMANDANT: die Freigabe nennt Mandant %, die Sitzung laeuft fuer % (K14-D07, T4)',
      NEW.tenant_id, sitzung USING ERRCODE = 'check_violation';
  END IF;

  -- MITTELBAR: der Mandant steht am Eigentuemer. Fuer knowledge_source
  -- laesst er sich seit Stufe 10g aufloesen -- owner_id zeigt auf ein Konto,
  -- und das Konto traegt seinen Mandanten.
  IF NEW.objekt_art = 'KNOWLEDGE_SOURCE' AND NEW.mandantenbezug = 'MITTELBAR'
     AND NEW.tenant_id IS NOT NULL THEN
    SELECT a.tenant_id INTO eigner_mandant
      FROM knowledge_source k JOIN actor a ON a.id = k.owner_id
     WHERE k.id::text = NEW.objekt_id;
    IF eigner_mandant IS NOT NULL AND eigner_mandant <> NEW.tenant_id THEN
      RAISE EXCEPTION 'MITTELBARER BEZUG: die Freigabe nennt Mandant %, der Eigentuemer der Quelle gehoert zu % (O-K14-2, T4)',
        NEW.tenant_id, eigner_mandant USING ERRCODE = 'check_violation';
    END IF;
  END IF;
  -- Fuer KNOWLEDGE_MODULE_VERSION bleibt MITTELBAR unaufgeloest: die Tabelle
  -- fuehrt keinen Eigentuemer, nur module_id und editor. Das ist kein
  -- Versaeumnis dieser Stufe, sondern der offene Punkt O-K08-3/7 -- und es
  -- steht hier, damit niemand die Luecke fuer geschlossen haelt.

  IF NEW.objekt_art IS DISTINCT FROM 'APP' THEN
    RETURN NEW;
  END IF;

  SELECT a.tenant_id INTO app_mandant FROM app a WHERE a.id::text = NEW.objekt_id;
  IF app_mandant IS NULL THEN
    RETURN NEW;
  END IF;
  IF NEW.tenant_id IS NULL THEN
    RETURN NEW;                       -- gehoert approval_mandant_passt
  END IF;
  IF NEW.tenant_id IS DISTINCT FROM app_mandant THEN
    RAISE EXCEPTION 'MANDANTENBEZUG: die Freigabe nennt Mandant %, die Anwendung gehoert Mandant % (K14, O-K14-2, Zeichnung T4)',
      NEW.tenant_id, app_mandant USING ERRCODE = 'check_violation';
  END IF;
  RETURN NEW;
END $$;


-- ---------------------------------------------------------------------
-- 16c · login_attempt und login_code zusammenbinden (Delta-Review Punkt 5)
-- ---------------------------------------------------------------------
-- Das Review: "Es fehlt eine technische Kopplung zwischen login_attempt und
-- login_code.failed_count; die CHECK-Bedingung begrenzt nur den Wert, erhoeht
-- ihn aber nicht und entwertet den Code nicht automatisch."
--
-- Das trifft zu. Die beiden Tabellen zaehlten dieselbe Sache aus zwei
-- Blickwinkeln und wussten nichts voneinander. K03-M16 verlangt beides:
-- den Zaehler und die Drosselung.
CREATE OR REPLACE FUNCTION login_attempt_koppelt_code() RETURNS trigger
LANGUAGE plpgsql AS $$
DECLARE betroffen uuid; stand int;
BEGIN
  IF NEW.success THEN
    RETURN NEW;                       -- ein Treffer zaehlt nicht als Fehlversuch
  END IF;

  -- Der offene Code des Kontos zu dieser Adresse. Gibt es keinen, ist der
  -- Fehlversuch trotzdem gezaehlt -- in login_attempt, je Adresse.
  SELECT c.id, c.failed_count INTO betroffen, stand
    FROM login_code c JOIN actor a ON a.id = c.actor_id
   WHERE lower(a.email) = lower(NEW.email)
     AND c.consumed_at IS NULL AND c.superseded_at IS NULL
     AND c.expires_at > NEW.attempted_at
   ORDER BY c.issued_at DESC LIMIT 1;

  IF betroffen IS NULL THEN
    RETURN NEW;
  END IF;

  IF stand + 1 >= 5 THEN
    -- Fuenf Fehlversuche entwerten den Code. Er wird nicht geloescht --
    -- superseded_at ist der Nachweis, dass er einmal galt (K03-M15).
    UPDATE login_code SET failed_count = stand + 1, superseded_at = NEW.attempted_at
     WHERE id = betroffen;
  ELSE
    UPDATE login_code SET failed_count = stand + 1 WHERE id = betroffen;
  END IF;
  RETURN NEW;
END $$;

CREATE OR REPLACE TRIGGER login_attempt_koppelt_code_trg
  AFTER INSERT ON login_attempt
  FOR EACH ROW EXECUTE FUNCTION login_attempt_koppelt_code();

COMMENT ON FUNCTION login_attempt_koppelt_code() IS
  'K03-M16, Delta-Review 05.08.2026: Ein Fehlversuch erhoeht den Zaehler am '
  'offenen Code und entwertet ihn beim fuenften. Vorher zaehlten login_attempt '
  'und login_code.failed_count dasselbe, ohne voneinander zu wissen.';


-- ---------------------------------------------------------------------
-- Der feste Suchpfad (Befund F-05)
-- ---------------------------------------------------------------------
-- Gemessen am 5.8.2026: 20 eigene Funktionen, davon 0 mit gesetztem
-- search_path. Alle verwenden unqualifizierte Objektnamen -- sobald eine
-- Laufzeitrolle in einem durchsuchten Schema Objekte anlegen darf, entscheidet
-- der Suchpfad, welche Tabelle gemeint war.
--
-- Der Lauf zaehlt die Funktionen nicht ab, sondern findet sie: Der Auftrag
-- O-K13-1 nannte einmal "die drei Waechter", und die Zahl war ueberholt,
-- bevor er ausgefuehrt wurde (Befund F-06).
DO $$
DECLARE f record;
BEGIN
  FOR f IN
    SELECT p.oid::regprocedure AS sig
      FROM pg_proc p
      JOIN pg_namespace n ON n.oid = p.pronamespace
     WHERE n.nspname = 'public'
       AND NOT EXISTS (SELECT 1 FROM pg_depend d
                        WHERE d.objid = p.oid AND d.deptype = 'e')
  LOOP
    EXECUTE format('ALTER FUNCTION %s SET search_path = public, pg_temp', f.sig);
  END LOOP;
END $$;

-- ---------------------------------------------------------------------
-- RECHTE-NACHZUG · laeuft zuletzt, wie der Suchpfad
-- ---------------------------------------------------------------------
-- Die Pauschalrechte aus Stufe 12 liefen VOR den Tabellen aus Stufe 13 und
-- 15. Beim ersten Lauf blieben tenant_invite_domain und app_eingeschraenkt
-- ohne Rechte, beim zweiten deckte GRANT ON ALL TABLES sie ab -- der
-- Endzustand hing von der Laufzahl ab. Gefunden vom pg_dump-Vergleich in
-- n2_lauf.sh am 5.8.2026. Deshalb wird die Rechtebasis hier, nach dem
-- letzten Objekt, noch einmal vollstaendig hergestellt; GRANT und REVOKE
-- sind wiederholbar, der Endzustand ist damit je Lauf derselbe.
DO $$
DECLARE r text;
BEGIN
  -- ALLE Laufzeitrollen zuruecksetzen, nicht nur drei: sonst haengt die
  -- REIHENFOLGE der ACL-Eintraege davon ab, ob eine Tabelle ihre Rechte aus
  -- Stufe 12 oder erst hier bekam -- und der pg_dump-Vergleich schlaegt an,
  -- obwohl die Rechte selbst gleich sind.
  FOREACH r IN ARRAY ARRAY['fr_pruefung','fr_wartung','fr_portal',
                           'fr_broker','fr_modell'] LOOP
    EXECUTE format('REVOKE ALL ON ALL TABLES IN SCHEMA public FROM %I', r);
  END LOOP;
END $$;
GRANT SELECT ON ALL TABLES IN SCHEMA public TO fr_pruefung;
GRANT SELECT, INSERT, UPDATE, DELETE ON ALL TABLES IN SCHEMA public TO fr_wartung;
GRANT SELECT, INSERT, UPDATE ON ALL TABLES IN SCHEMA public TO fr_portal;
GRANT SELECT ON knowledge_source TO fr_broker;
GRANT INSERT ON event            TO fr_broker;
GRANT INSERT ON event            TO fr_modell;
DO $$ BEGIN
  IF to_regclass('public.model_manifest') IS NOT NULL THEN
    EXECUTE 'GRANT SELECT ON model_manifest TO fr_modell';
  END IF;
END $$;
DO $$
DECLARE tt text;
BEGIN
  FOREACH tt IN ARRAY ARRAY['actor','approval','login_code'] LOOP
    EXECUTE format('REVOKE ALL ON %I FROM fr_broker', tt);
    EXECUTE format('REVOKE ALL ON %I FROM fr_modell', tt);
  END LOOP;
END $$;
-- und die Verschaerfungen aus Stufe 14, die auf der Basis aufsetzen:
DO $$ BEGIN
  REVOKE INSERT, UPDATE, DELETE ON app FROM fr_portal;
  REVOKE UPDATE ON actor FROM fr_portal;
  GRANT UPDATE (email, display_name, mfa_method, status, status_before_lock,
                user_code, last_login_at)
    ON actor TO fr_portal;
END $$;

-- =====================================================================
-- ABSCHLUSS · Versionseintrag (Stufe 1)
-- =====================================================================
INSERT INTO schema_migration(version, beschreibung) VALUES
  ('v3.0-pilot-01',
   'Sammelmigration der 29 Matrixzeilen (Pruefbericht 4.8.2026, Abschnitt 8, Stufen 1-7), '
   'einschliesslich der sechs Merkmale aus Nr. 24 (Entscheidung E2 vom 4.8.2026) und des '
   'entschiedenen Anmeldecode-Bauplans (Entscheidung E3, Bau-Vorschlag 260802), '
   'dem Nachtrag aus dem Befund vom 5.8. (Stufe 9), den sechs gezeichneten '
   'Vorfragen V1-V6 vom 5.8.2026 (Stufe 10) und den Zeichnungen T4 und T1 aus '
   'den Fremdreviews vom 5.8.2026 (Stufen 11 und 12) sowie der Zeichnung P3 aus Add-On 03 '
   '(Stufe 13) sowie den zwei privilegierten Serverbefehlen und dem '
   'Rechteschnitt nach dem Tor-3-Delta-Review (Stufe 14) und der Einschraenkung nach Loeschverlangen (Stufe 15, gez. A. Han) sowie den drei Nachtraegen aus dem '
   'Tor-3-Delta-Review (Stufe 16).')
ON CONFLICT (version) DO NOTHING;

COMMIT;

-- STUFE 8 (Tests) steht in M30__pruefung.sql — bewusst getrennt, damit
-- der Testlauf die Migration nicht veraendert und wiederholbar bleibt.
