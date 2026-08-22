--
-- PostgreSQL database dump
--


-- Dumped from database version 16.13 (Ubuntu 16.13-0ubuntu0.24.04.1)
-- Dumped by pg_dump version 16.13 (Ubuntu 16.13-0ubuntu0.24.04.1)

SET statement_timeout = 0;
SET lock_timeout = 0;
SET idle_in_transaction_session_timeout = 0;
SET client_encoding = 'UTF8';
SET standard_conforming_strings = on;
SELECT pg_catalog.set_config('search_path', '', false);
SET check_function_bodies = false;
SET xmloption = content;
SET client_min_messages = warning;
SET row_security = off;

--
-- Name: btree_gist; Type: EXTENSION; Schema: -; Owner: -
--

CREATE EXTENSION IF NOT EXISTS btree_gist WITH SCHEMA public;


--
-- Name: EXTENSION btree_gist; Type: COMMENT; Schema: -; Owner: 
--

COMMENT ON EXTENSION btree_gist IS 'support for indexing common datatypes in GiST';


--
-- Name: actor_status; Type: TYPE; Schema: public; Owner: freiraum
--

CREATE TYPE public.actor_status AS ENUM (
    'AKTIV',
    'WARTET_2FA',
    'GESPERRT'
);


ALTER TYPE public.actor_status OWNER TO freiraum;

--
-- Name: agent_status; Type: TYPE; Schema: public; Owner: freiraum
--

CREATE TYPE public.agent_status AS ENUM (
    'RELEASED',
    'IN_REVIEW'
);


ALTER TYPE public.agent_status OWNER TO freiraum;

--
-- Name: approval_object; Type: TYPE; Schema: public; Owner: freiraum
--

CREATE TYPE public.approval_object AS ENUM (
    'KNOWLEDGE_SOURCE',
    'KNOWLEDGE_MODULE_VERSION',
    'TEMPLATE_VERSION',
    'POLICY_VERSION',
    'AGENT',
    'UEBERGABE_PAKET',
    'APP'
);


ALTER TYPE public.approval_object OWNER TO freiraum;

--
-- Name: approval_reason; Type: TYPE; Schema: public; Owner: freiraum
--

CREATE TYPE public.approval_reason AS ENUM (
    'FREIGABE',
    'RUECKNAHME',
    'BEAUFTRAGUNG',
    'ABNAHME',
    'IN_PROD',
    'PAUSIERT_NACH_BEAUFTRAGT'
);


ALTER TYPE public.approval_reason OWNER TO freiraum;

--
-- Name: approval_tenant_scope; Type: TYPE; Schema: public; Owner: freiraum
--

CREATE TYPE public.approval_tenant_scope AS ENUM (
    'MANDANT',
    'GLOBAL',
    'MITTELBAR'
);


ALTER TYPE public.approval_tenant_scope OWNER TO freiraum;

--
-- Name: artifact_class; Type: TYPE; Schema: public; Owner: freiraum
--

CREATE TYPE public.artifact_class AS ENUM (
    'VERIFIED_APP',
    'WORK_DOCUMENT'
);


ALTER TYPE public.artifact_class OWNER TO freiraum;

--
-- Name: catalog_group; Type: TYPE; Schema: public; Owner: freiraum
--

CREATE TYPE public.catalog_group AS ENUM (
    'TEAM',
    'SINGLE'
);


ALTER TYPE public.catalog_group OWNER TO freiraum;

--
-- Name: concept_kind; Type: TYPE; Schema: public; Owner: freiraum
--

CREATE TYPE public.concept_kind AS ENUM (
    'PROZESS_SCHRITTE',
    'DATEN_SYSTEME',
    'ROLLEN_AKTIONEN',
    'REGELN_AUSNAHMEN',
    'COMPLIANCE',
    'ERGEBNIS_KENNZAHLEN'
);


ALTER TYPE public.concept_kind OWNER TO freiraum;

--
-- Name: currency_code; Type: TYPE; Schema: public; Owner: freiraum
--

CREATE TYPE public.currency_code AS ENUM (
    'EUR',
    'GBP',
    'CHF'
);


ALTER TYPE public.currency_code OWNER TO freiraum;

--
-- Name: document_kind; Type: TYPE; Schema: public; Owner: freiraum
--

CREATE TYPE public.document_kind AS ENUM (
    'INTERVIEW_PROTOCOL',
    'CONCEPT',
    'MEMO',
    'SBOM',
    'ORDER',
    'REVIEW_FINDING',
    'UX_HANDOFF'
);


ALTER TYPE public.document_kind OWNER TO freiraum;

--
-- Name: event_source; Type: TYPE; Schema: public; Owner: freiraum
--

CREATE TYPE public.event_source AS ENUM (
    'PORTAL_ACTION',
    'MODEL_CHANGE'
);


ALTER TYPE public.event_source OWNER TO freiraum;

--
-- Name: fit_dimension; Type: TYPE; Schema: public; Owner: freiraum
--

CREATE TYPE public.fit_dimension AS ENUM (
    'ART',
    'NUTZUNG',
    'DATEN'
);


ALTER TYPE public.fit_dimension OWNER TO freiraum;

--
-- Name: fit_outcome; Type: TYPE; Schema: public; Owner: freiraum
--

CREATE TYPE public.fit_outcome AS ENUM (
    'OFFEN',
    'GEEIGNET',
    'NICHT_GEEIGNET'
);


ALTER TYPE public.fit_outcome OWNER TO freiraum;

--
-- Name: invitation_status; Type: TYPE; Schema: public; Owner: freiraum
--

CREATE TYPE public.invitation_status AS ENUM (
    'VERSANDT',
    'EINGELOEST',
    'ABGELAUFEN',
    'WIDERRUFEN'
);


ALTER TYPE public.invitation_status OWNER TO freiraum;

--
-- Name: journey_phase; Type: TYPE; Schema: public; Owner: freiraum
--

CREATE TYPE public.journey_phase AS ENUM (
    'ORIENTIERUNG',
    'INTERVIEW',
    'UEBERSICHT',
    'PROTOTYP',
    'ANGEBOT'
);


ALTER TYPE public.journey_phase OWNER TO freiraum;

--
-- Name: knowledge_group; Type: TYPE; Schema: public; Owner: freiraum
--

CREATE TYPE public.knowledge_group AS ENUM (
    'BRANCHENWISSEN',
    'FUNKTIONSWISSEN',
    'METHODENWISSEN'
);


ALTER TYPE public.knowledge_group OWNER TO freiraum;

--
-- Name: knowledge_mode; Type: TYPE; Schema: public; Owner: freiraum
--

CREATE TYPE public.knowledge_mode AS ENUM (
    'DYNAMIC',
    'FIXED'
);


ALTER TYPE public.knowledge_mode OWNER TO freiraum;

--
-- Name: knowledge_origin; Type: TYPE; Schema: public; Owner: freiraum
--

CREATE TYPE public.knowledge_origin AS ENUM (
    'EXTERN',
    'PROJEKT'
);


ALTER TYPE public.knowledge_origin OWNER TO freiraum;

--
-- Name: knowledge_type; Type: TYPE; Schema: public; Owner: freiraum
--

CREATE TYPE public.knowledge_type AS ENUM (
    'GITHUB',
    'MCP',
    'WEB',
    'API',
    'OSS',
    'MD',
    'PDF',
    'DOCX',
    'CSV'
);


ALTER TYPE public.knowledge_type OWNER TO freiraum;

--
-- Name: legal_form; Type: TYPE; Schema: public; Owner: freiraum
--

CREATE TYPE public.legal_form AS ENUM (
    'GMBH',
    'GMBH_CO_KG',
    'AG',
    'KG',
    'EK'
);


ALTER TYPE public.legal_form OWNER TO freiraum;

--
-- Name: legal_space; Type: TYPE; Schema: public; Owner: freiraum
--

CREATE TYPE public.legal_space AS ENUM (
    'DE',
    'EU27_REST',
    'UK',
    'CH',
    'US_NEXUS_VENDOR'
);


ALTER TYPE public.legal_space OWNER TO freiraum;

--
-- Name: lifecycle_state; Type: TYPE; Schema: public; Owner: freiraum
--

CREATE TYPE public.lifecycle_state AS ENUM (
    'EINGELADEN',
    'DISCOVERY',
    'IN_BEARBEITUNG',
    'BEAUFTRAGT',
    'IN_DEV',
    'ABNAHME',
    'IN_PROD',
    'PAUSIERT'
);


ALTER TYPE public.lifecycle_state OWNER TO freiraum;

--
-- Name: lifecycle_status; Type: TYPE; Schema: public; Owner: freiraum
--

CREATE TYPE public.lifecycle_status AS ENUM (
    'DRAFT',
    'IN_REVIEW',
    'RELEASED',
    'RETIRED'
);


ALTER TYPE public.lifecycle_status OWNER TO freiraum;

--
-- Name: mail_kind; Type: TYPE; Schema: public; Owner: freiraum
--

CREATE TYPE public.mail_kind AS ENUM (
    'EINLADUNG',
    'ANMELDECODE'
);


ALTER TYPE public.mail_kind OWNER TO freiraum;

--
-- Name: mail_status; Type: TYPE; Schema: public; Owner: freiraum
--

CREATE TYPE public.mail_status AS ENUM (
    'UEBERGEBEN',
    'ABGELEHNT',
    'FEHLER'
);


ALTER TYPE public.mail_status OWNER TO freiraum;

--
-- Name: mfa_method; Type: TYPE; Schema: public; Owner: freiraum
--

CREATE TYPE public.mfa_method AS ENUM (
    'EMAIL_CODE',
    'OFF'
);


ALTER TYPE public.mfa_method OWNER TO freiraum;

--
-- Name: model_hosting; Type: TYPE; Schema: public; Owner: freiraum
--

CREATE TYPE public.model_hosting AS ENUM (
    'AZURE_EU',
    'ON_PREM_DE',
    'OFFEN'
);


ALTER TYPE public.model_hosting OWNER TO freiraum;

--
-- Name: model_provider; Type: TYPE; Schema: public; Owner: freiraum
--

CREATE TYPE public.model_provider AS ENUM (
    'ANTHROPIC',
    'OPENAI',
    'INTERN',
    'OFFEN'
);


ALTER TYPE public.model_provider OWNER TO freiraum;

--
-- Name: naehe_befund; Type: TYPE; Schema: public; Owner: freiraum
--

CREATE TYPE public.naehe_befund AS ENUM (
    'BESTANDEN',
    'GESPERRT',
    'MENSCHLICH_ZU_PRUEFEN'
);


ALTER TYPE public.naehe_befund OWNER TO freiraum;

--
-- Name: portal_code; Type: TYPE; Schema: public; Owner: freiraum
--

CREATE TYPE public.portal_code AS ENUM (
    'ENDUSER',
    'USER_ADMIN',
    'VAR_ADMIN',
    'EXMA',
    'INDIA_OPS'
);


ALTER TYPE public.portal_code OWNER TO freiraum;

--
-- Name: release_status; Type: TYPE; Schema: public; Owner: freiraum
--

CREATE TYPE public.release_status AS ENUM (
    'ENABLED',
    'PLANNED'
);


ALTER TYPE public.release_status OWNER TO freiraum;

--
-- Name: retention_class; Type: TYPE; Schema: public; Owner: freiraum
--

CREATE TYPE public.retention_class AS ENUM (
    'HANDELSRECHT',
    'KI_NACHWEIS',
    'BETRIEBSPROTOKOLL',
    'KURZFRIST',
    'PROJEKT_VORVERTRAG',
    'ARBEITSERGEBNIS',
    'EREIGNIS'
);


ALTER TYPE public.retention_class OWNER TO freiraum;

--
-- Name: retention_start; Type: TYPE; Schema: public; Owner: freiraum
--

CREATE TYPE public.retention_start AS ENUM (
    'ENTSTEHUNGSJAHRESENDE',
    'ERSTELLUNG',
    'BEZUGSOBJEKT'
);


ALTER TYPE public.retention_start OWNER TO freiraum;

--
-- Name: rights_level; Type: TYPE; Schema: public; Owner: freiraum
--

CREATE TYPE public.rights_level AS ENUM (
    'L',
    'V',
    'F',
    'A'
);


ALTER TYPE public.rights_level OWNER TO freiraum;

--
-- Name: template_confirm_density; Type: TYPE; Schema: public; Owner: freiraum
--

CREATE TYPE public.template_confirm_density AS ENUM (
    'KEINE',
    'EINSTUFIG',
    'MEHRSTUFIG'
);


ALTER TYPE public.template_confirm_density OWNER TO freiraum;

--
-- Name: template_dialog_mode; Type: TYPE; Schema: public; Owner: freiraum
--

CREATE TYPE public.template_dialog_mode AS ENUM (
    'GEFUEHRT',
    'GEMISCHT',
    'FREI'
);


ALTER TYPE public.template_dialog_mode OWNER TO freiraum;

--
-- Name: template_function; Type: TYPE; Schema: public; Owner: freiraum
--

CREATE TYPE public.template_function AS ENUM (
    'GESPRAECHSVORLAGE',
    'STATUSVORLAGE',
    'ELEMENTVORLAGE'
);


ALTER TYPE public.template_function OWNER TO freiraum;

--
-- Name: template_group; Type: TYPE; Schema: public; Owner: freiraum
--

CREATE TYPE public.template_group AS ENUM (
    'DOCUMENT',
    'DESIGN',
    'DIALOG',
    'POLICY'
);


ALTER TYPE public.template_group OWNER TO freiraum;

--
-- Name: template_input_density; Type: TYPE; Schema: public; Owner: freiraum
--

CREATE TYPE public.template_input_density AS ENUM (
    'KEINE',
    'GERING',
    'HOCH'
);


ALTER TYPE public.template_input_density OWNER TO freiraum;

--
-- Name: template_result_kind; Type: TYPE; Schema: public; Owner: freiraum
--

CREATE TYPE public.template_result_kind AS ENUM (
    'UEBERSICHT',
    'VORGANG',
    'NACHSCHLAGEN'
);


ALTER TYPE public.template_result_kind OWNER TO freiraum;

--
-- Name: template_status_content; Type: TYPE; Schema: public; Owner: freiraum
--

CREATE TYPE public.template_status_content AS ENUM (
    'KENNZAHL',
    'LISTE',
    'VERLAUF'
);


ALTER TYPE public.template_status_content OWNER TO freiraum;

--
-- Name: tenant_kind; Type: TYPE; Schema: public; Owner: freiraum
--

CREATE TYPE public.tenant_kind AS ENUM (
    'OPERATOR',
    'CUSTOMER',
    'PARTNER'
);


ALTER TYPE public.tenant_kind OWNER TO freiraum;

--
-- Name: transition_authority; Type: TYPE; Schema: public; Owner: freiraum
--

CREATE TYPE public.transition_authority AS ENUM (
    'SYSTEM',
    'VERWALTER',
    'ZWEI_PERSONEN'
);


ALTER TYPE public.transition_authority OWNER TO freiraum;

--
-- Name: ui_locale; Type: TYPE; Schema: public; Owner: freiraum
--

CREATE TYPE public.ui_locale AS ENUM (
    'DE',
    'EN'
);


ALTER TYPE public.ui_locale OWNER TO freiraum;

--
-- Name: agent_release_guard(); Type: FUNCTION; Schema: public; Owner: freiraum
--

CREATE FUNCTION public.agent_release_guard() RETURNS trigger
    LANGUAGE plpgsql
    SET search_path TO 'public', 'pg_temp'
    AS $$
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


ALTER FUNCTION public.agent_release_guard() OWNER TO freiraum;

--
-- Name: app_state_history_sync(); Type: FUNCTION; Schema: public; Owner: freiraum
--

CREATE FUNCTION public.app_state_history_sync() RETURNS trigger
    LANGUAGE plpgsql
    SET search_path TO 'public', 'pg_temp'
    AS $$
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


ALTER FUNCTION public.app_state_history_sync() OWNER TO freiraum;

--
-- Name: append_only_guard(); Type: FUNCTION; Schema: public; Owner: freiraum
--

CREATE FUNCTION public.append_only_guard() RETURNS trigger
    LANGUAGE plpgsql
    SET search_path TO 'public', 'pg_temp'
    AS $$
BEGIN
  RAISE EXCEPTION 'APPEND-ONLY: % erlaubt weder UPDATE noch DELETE', TG_TABLE_NAME
    USING ERRCODE = 'check_violation';
END $$;


ALTER FUNCTION public.append_only_guard() OWNER TO freiraum;

--
-- Name: approval_bezug_guard(); Type: FUNCTION; Schema: public; Owner: freiraum
--

CREATE FUNCTION public.approval_bezug_guard() RETURNS trigger
    LANGUAGE plpgsql
    SET search_path TO 'public', 'pg_temp'
    AS $$
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


ALTER FUNCTION public.approval_bezug_guard() OWNER TO freiraum;

--
-- Name: approval_mandant_guard(); Type: FUNCTION; Schema: public; Owner: freiraum
--

CREATE FUNCTION public.approval_mandant_guard() RETURNS trigger
    LANGUAGE plpgsql
    SET search_path TO 'public', 'pg_temp'
    AS $$
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


ALTER FUNCTION public.approval_mandant_guard() OWNER TO freiraum;

--
-- Name: auswahlvermerk_guard(); Type: FUNCTION; Schema: public; Owner: freiraum
--

CREATE FUNCTION public.auswahlvermerk_guard() RETURNS trigger
    LANGUAGE plpgsql
    SET search_path TO 'public', 'pg_temp'
    AS $$
BEGIN
  IF OLD.auswahlvermerk IS NOT NULL
     AND (NEW.auswahlvermerk IS DISTINCT FROM OLD.auswahlvermerk
          OR NEW.auswahlvermerk_at IS DISTINCT FROM OLD.auswahlvermerk_at) THEN
    RAISE EXCEPTION 'AUSWAHLVERMERK: einmal gesetzt, unveraenderlich (Nr. 25)'
      USING ERRCODE = 'check_violation';
  END IF;
  RETURN NEW;
END $$;


ALTER FUNCTION public.auswahlvermerk_guard() OWNER TO freiraum;

--
-- Name: change_app_state(uuid, public.lifecycle_state, uuid); Type: FUNCTION; Schema: public; Owner: freiraum
--

CREATE FUNCTION public.change_app_state(p_app uuid, p_ziel public.lifecycle_state, p_actor uuid) RETURNS void
    LANGUAGE plpgsql SECURITY DEFINER
    SET search_path TO 'public', 'pg_temp'
    AS $$
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
END $$;


ALTER FUNCTION public.change_app_state(p_app uuid, p_ziel public.lifecycle_state, p_actor uuid) OWNER TO freiraum;

--
-- Name: FUNCTION change_app_state(p_app uuid, p_ziel public.lifecycle_state, p_actor uuid); Type: COMMENT; Schema: public; Owner: freiraum
--

COMMENT ON FUNCTION public.change_app_state(p_app uuid, p_ziel public.lifecycle_state, p_actor uuid) IS 'K01-M28 Zustandswechsel; seit M32 mit atomarem Protokolleintrag (Blatt 99, Entscheidung 1).';


--
-- Name: create_app_after_fit(uuid, text, uuid, uuid); Type: FUNCTION; Schema: public; Owner: freiraum
--

CREATE FUNCTION public.create_app_after_fit(p_tenant uuid, p_name text, p_fit_check uuid, p_actor uuid) RETURNS uuid
    LANGUAGE plpgsql SECURITY DEFINER
    SET search_path TO 'public', 'pg_temp'
    AS $_$
DECLARE
  neu        uuid;
  t          record;
  a          record;
  f          record;
  nr         bigint;
  v_no       text;
  v_currency text;
  v_verlauf  integer;
  v_rueck    uuid;
  v_hin      uuid;
BEGIN
  -- -----------------------------------------------------------------
  -- 2a · Die fuenf Pruefungen aus K01-M27, in EINER Transaktion
  -- -----------------------------------------------------------------
  -- Wortgleich uebernommen aus M30 und um die fuenfte ergaenzt. Der
  -- Wortlaut der Meldungen bleibt, damit ein Negativfall, der gegen die
  -- alte Fassung geschrieben wurde, an derselben Bedingung scheitert und
  -- nicht an einer neuen.

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

  -- K04-M18: die Eignung wird HIER erneut gelesen, in derselben
  -- Transaktion, in der die Zeile entsteht. Was der Bildschirm vor fuenf
  -- Minuten gezeigt hat, berechtigt nicht.
  SELECT * INTO f FROM fit_check WHERE id = p_fit_check;
  IF f IS NULL OR f.outcome <> 'GEEIGNET' THEN
    RAISE EXCEPTION 'ANLAGE: der Eignungs-Check steht nicht auf GEEIGNET (K01-M27)'
      USING ERRCODE = 'check_violation';
  END IF;
  IF f.tenant_id <> p_tenant THEN
    RAISE EXCEPTION 'ANLAGE: der Eignungs-Check gehoert einem anderen Mandanten (K01-M27, K14-D07)'
      USING ERRCODE = 'check_violation';
  END IF;

  -- -----------------------------------------------------------------
  -- 2b · Die Zweckbestimmung als Vorbedingung (K04-D10, K04-M21)
  -- -----------------------------------------------------------------
  -- BERICHTIGT AM 16.08.2026, auf Weisung E-8 (gez. M. Veil). Hier stand
  -- ein dritter Riegel, der beide Fragen als BEANTWORTET verlangte:
  --
  --   IF f.zweck_bewertung_menschen IS NULL
  --      OR f.zweck_verbotene_praktik IS NULL THEN
  --     RAISE EXCEPTION 'ZWECKBESTIMMUNG: beide Fragen muessen
  --                      beantwortet sein (K04-M19)';
  --
  -- ER WIRD ZURUECKGENOMMEN -- aus demselben Grund und nach derselben
  -- Regel wie der Riegel in Abschnitt 1b, 150 Zeilen weiter oben:
  --
  --   "Die Pruefung folgt nicht dem Bau. Eine Bedingung, die eine
  --    Rang-1-Pruefung unmoeglich macht, ist eine Aenderung an
  --    M30-Verhalten und gehoert als Rueckfrage an die Founder,
  --    nicht in M31."
  --
  -- Gemessen am 16.08.2026: er macht MT-95 und MT-95b unmoeglich. Beide
  -- richten einen fit_check mit outcome = GEEIGNET her und lassen die
  -- zwei Zweck-Spalten NULL -- sie stammen aus der Zeit vor diesen
  -- Spalten. MT-95 misst die Nummernvergabe, MT-95b den Rechteweg unter
  -- fr_portal; beide messen danach GAR NICHTS mehr.
  --
  -- WARUM DIE BEGRUENDUNG NICHT TRUG. Der fruehere Kommentar sagte:
  -- "K01-M27 sagt, was der Befehl prueft; K04-M21 sagt, dass die
  -- Kenntnisnahme Bedingung ist." Beide Zitate halten nicht:
  --   K04-M21 woertlich: "Die Kenntnisnahme MUSS als Nachweis erhalten
  --     bleiben und in das Uebergabe-Paket (K10 Abschn. 3) eingehen."
  --     -- kein Wort ueber eine Anlagebedingung.
  --   K04-M19 woertlich: "Nach outcome = GEEIGNET MUSS ein
  --     Zweckbestimmungs-SCHRITT folgen." -- ein Schritt im Ablauf,
  --     keine Bedingung im Serverbefehl.
  --   K01-M27 zaehlt FUENF Pruefungen auf; die Maschinenquelle
  --     schema/K19_screens.yaml:247/251 liest sie abschliessend
  --     ("eine der fuenf Pruefungen scheitert") und kennt als sechste
  --     Bedingung allein die Kenntnisnahme bei Treffer in Frage 1.
  --
  -- Und der zurueckgenommene Zweig war der einzige, den KEIN Negativfall
  -- misst: M31_N1 setzt beide Antworten auf false, N2 und N3 setzen sie.
  -- Ein unbelegter UND unbeobachteter Riegel hat zwei gruene
  -- Rang-1-Faelle rot gefaerbt.
  --
  -- WAS ER SICHERN SOLLTE, wird an drei Stellen weiterhin getragen:
  --   * Treffer in Frage 2   -> der Riegel unten (K04-D10), gemessen
  --                             durch M31_N3
  --   * Treffer in Frage 1 ohne Kenntnisnahme
  --                          -> der Riegel unten (K04-M21), gemessen
  --                             durch M31_N2
  --   * der Weg ueber den Bildschirm
  --                          -> app/zweckbestimmung.py ruft die Anlage
  --                             nur bei zwei Antworten auf
  --
  -- OFFEN UND ALS RUECKFRAGE AN DIE FOUNDER GESTELLT, nicht verschwiegen:
  -- Bei NULL ist ein Treffer in Frage 2 nicht AUSGESCHLOSSEN, und
  -- K19-M14 sagt zu Recht "Ein UI-Zustand ersetzt keine serverseitige
  -- Autorisierung". Wer die Kette nur ueber den Bildschirm schliesst,
  -- verlaesst sich auf einen Weg, den man umgehen kann. Soll der Riegel
  -- wiederkommen, gehoert ZUERST die Klauseldeckung in K04 oder K01
  -- nachgezogen -- und erst danach die Herrichtung von MT-95/95b, mit
  -- Klauselverweis statt Bauverweis.
  -- Vollstaendig in arbeit/Vorlagen/entscheidung_tor1_260816.md, E-8.

  -- Vorrang der zweiten Frage (K04-D10). Sie wird ZUERST geprueft, damit
  -- ein Vorhaben, das beide Fragen trifft, an dieser scheitert und nicht
  -- an der fehlenden Kenntnisnahme -- sonst waere es richtig abgewiesen
  -- und falsch begruendet, und die Nutzerin holte eine Bestaetigung nach,
  -- die nichts heilt.
  IF f.zweck_verbotene_praktik THEN
    RAISE EXCEPTION 'ZWECKBESTIMMUNG: verbotene Praktik nach Art. 5 der KI-Verordnung bejaht; der Weg wird nicht weitergefuehrt (K04-D10)'
      USING ERRCODE = 'check_violation';
  END IF;

  IF f.zweck_bewertung_menschen AND f.zweckbestimmung_ack_at IS NULL THEN
    RAISE EXCEPTION 'ZWECKBESTIMMUNG: die Kenntnisnahme zu Anhang III fehlt; ohne sie ist die Auskunftspflicht nach Art. 25 Abs. 4 nicht belegbar (K04-M21)'
      USING ERRCODE = 'check_violation';
  END IF;

  -- -----------------------------------------------------------------
  -- 2c · Die Projektnummer -- vergeben, nicht eingegeben (K01-M38)
  -- -----------------------------------------------------------------
  -- FORMAT. `app.project_no` erzwingt '^DE-[A-Z]{3}_[0-9]{3}_[0-9]{2}$'.
  -- Die ersten sechs Zeichen sind das Muster von `tenant.customer_code`
  -- ('^DE-[A-Z]{3}$') -- die Nummer traegt also den Kundencode. Fehlt er,
  -- laesst sich keine formatgueltige Nummer bilden; dann entsteht keine
  -- Anwendung. Fail-closed, und mit benanntem Grund.
  --
  -- DIE LETZTEN ZWEI STELLEN sind ABGELEITET, NICHT BELEGT. Keine
  -- gezeichnete Quelle sagt, wofuer sie stehen. Vergeben wird '01'.
  -- Der Punkt geht in die Vorlage (Bericht zu M4).
  --
  -- GLEICHZEITIGKEIT. Der Zaehler steht in `nummernvorrat` und wird mit
  -- UPDATE ... RETURNING gezogen. Das UPDATE sperrt die Zeile bis zum
  -- Ende der Transaktion; ein zweiter Anlauf wartet und liest danach den
  -- erhoehten Stand. Zwei Anlagen koennen deshalb nicht dieselbe Nummer
  -- bekommen. Bricht der Vorgang ab, laeuft die Nummer in den Vorrat
  -- zurueck -- so ist die Zaehlertabelle in M30 ausdruecklich gezeichnet
  -- (V5/B): "Niemals wiederverwendet" meint die VERGEBENE Nummer, nicht
  -- die bloss gezogene.
  IF t.customer_code IS NULL THEN
    RAISE EXCEPTION 'PROJEKTNUMMER: der Mandant fuehrt keinen Kundencode; ohne ihn laesst sich keine Projektnummer bilden (K01-M38)'
      USING ERRCODE = 'check_violation';
  END IF;

  UPDATE nummernvorrat
     SET naechste_nummer = naechste_nummer + 1,
         geaendert_am    = now()
   WHERE praefix = 'PROJ'
  RETURNING naechste_nummer - 1 INTO nr;

  IF nr IS NULL THEN
    RAISE EXCEPTION 'PROJEKTNUMMER: der Vorrat fuehrt keine Zeile fuer PROJ (K01-M38)'
      USING ERRCODE = 'check_violation';
  END IF;
  IF nr > 999 THEN
    -- Drei Stellen sind drei Stellen. Lieber hier anhalten als eine
    -- Nummer bilden, die das Format verletzt -- die Bedingung an der
    -- Spalte faenge es zwar auch, aber ohne zu sagen, was los ist.
    RAISE EXCEPTION 'PROJEKTNUMMER: der Vorrat ist bei % angelangt, das Format traegt nur drei Stellen (K01-M38)', nr
      USING ERRCODE = 'check_violation';
  END IF;

  v_no := t.customer_code || '_' || lpad(nr::text, 3, '0') || '_01';

  -- -----------------------------------------------------------------
  -- 2d · Die Zeile, die fuenfte Pruefung und der Verlauf
  -- -----------------------------------------------------------------
  INSERT INTO app(tenant_id, project_no, name, fit_check_id, created_at)
  VALUES (p_tenant, v_no, p_name, p_fit_check, current_date)
  RETURNING id, currency::text INTO neu, v_currency;

  -- K01-M27, fuenfte Pruefung: currency = EUR. Sie fehlte in M30 -- dort
  -- stand, die Waehrung sei "Vorgabe der Spalte und wird hier nicht
  -- uebergeben". Eine Vorgabe ist ein Netz, kein Plan: aendert jemand die
  -- Spaltenvorgabe, entstuende die Zeile weiter, nur mit anderer
  -- Waehrung. Geprueft wird deshalb der TATSAECHLICHE Wert der eben
  -- entstandenen Zeile, in derselben Transaktion. Schlaegt es fehl,
  -- rollt alles zurueck -- auch die gezogene Nummer.
  IF v_currency <> 'EUR' THEN
    RAISE EXCEPTION 'ANLAGE: die Waehrung der Anwendung ist %, zulaessig ist EUR (K01-M27)', v_currency
      USING ERRCODE = 'check_violation';
  END IF;

  -- Verlaufszeile DISCOVERY. Sie wird hier NICHT geschrieben -- das tut
  -- der Ausloeser app_state_history_sync_trg aus M30 (Z. 709-727)
  -- zwangslaeufig beim INSERT. Nachgesehen wird trotzdem: der
  -- Bildschirmvertrag nennt sie als Teil des Erfolgs, und ein Erfolg,
  -- den niemand nachsieht, ist eine Behauptung. Faellt der Ausloeser
  -- einmal weg, entsteht hier keine Anwendung ohne Verlauf, sondern gar
  -- keine (K01-G06: der Verlauf ist der Nachweis).
  SELECT count(*) INTO v_verlauf
    FROM app_state_history
   WHERE app_id = neu AND state = 'DISCOVERY' AND upper_inf(gueltig);
  IF v_verlauf <> 1 THEN
    RAISE EXCEPTION 'ANLAGE: zur neuen Anwendung steht % offene Verlaufszeile DISCOVERY statt einer (K01-M28, K01-G06)', v_verlauf
      USING ERRCODE = 'check_violation';
  END IF;

  -- -----------------------------------------------------------------
  -- 2e · Die beidseitige Verknuepfung und ihre Gegenprobe (K04-M17)
  -- -----------------------------------------------------------------
  -- "Vor dem Commit wird Gleichheit beider Bezuege geprueft; jede
  -- Abweichung rollt alles zurueck." Also wird nicht nur geschrieben,
  -- sondern beides zurueckgelesen. Der Mandant steht auch im UPDATE --
  -- ein Check eines fremden Mandanten gilt als nicht vorhanden
  -- (K04-D08).
  UPDATE fit_check SET app_id = neu
   WHERE id = p_fit_check AND tenant_id = p_tenant;

  SELECT app_id INTO v_rueck FROM fit_check WHERE id = p_fit_check;
  SELECT fit_check_id INTO v_hin FROM app WHERE id = neu;
  IF v_rueck IS DISTINCT FROM neu OR v_hin IS DISTINCT FROM p_fit_check THEN
    RAISE EXCEPTION 'ANLAGE: die beidseitige Verknuepfung stimmt nicht ueberein (K04-M17)'
      USING ERRCODE = 'check_violation';
  END IF;

  -- -----------------------------------------------------------------
  -- 2f · Die Protokollzeile
  -- -----------------------------------------------------------------
  -- Die Entstehung einer Anwendung ist der folgenreichste Vorgang dieses
  -- Weges. `event.project_no` gibt es genau dafuer. `actor_label` steht
  -- mit im INSERT, weil die Bedingung `event_actor_paarweise`
  -- Verknuepfung und Namensschnappschuss gemeinsam verlangt (K02-G13).
  INSERT INTO event(actor_id, actor_label, tenant_id, project_no, action,
                    object_ref, change_type, value, source)
  VALUES (p_actor, a.display_name, p_tenant, v_no, 'ANWENDUNG_ANGELEGT',
          'APP:' || neu::text, 'Neuanlage',
          'aus Eignungs-Check ' || p_fit_check::text, 'PORTAL_ACTION');

  RETURN neu;
END $_$;


ALTER FUNCTION public.create_app_after_fit(p_tenant uuid, p_name text, p_fit_check uuid, p_actor uuid) OWNER TO freiraum;

--
-- Name: FUNCTION create_app_after_fit(p_tenant uuid, p_name text, p_fit_check uuid, p_actor uuid); Type: COMMENT; Schema: public; Owner: freiraum
--

COMMENT ON FUNCTION public.create_app_after_fit(p_tenant uuid, p_name text, p_fit_check uuid, p_actor uuid) IS 'K01-M27 · K01-M38 · K01-D19 · K04-M17 · K04-M21 · M31. Der einzige Weg zu einer app-Zeile. Er prueft in derselben Transaktion Mandant, Rechtsraum, Konto, Mandantenzugehoerigkeit, Eignung und Waehrung, verlangt die vollstaendige Zweckbestimmung samt Kenntnisnahme und bildet die Projektnummer selbst. Sie wird vergeben, nicht eingegeben.';


--
-- Name: document_version_unveraenderlich(); Type: FUNCTION; Schema: public; Owner: freiraum
--

CREATE FUNCTION public.document_version_unveraenderlich() RETURNS trigger
    LANGUAGE plpgsql
    SET search_path TO 'public', 'pg_temp'
    AS $$
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


ALTER FUNCTION public.document_version_unveraenderlich() OWNER TO freiraum;

--
-- Name: einschraenkung_unumkehrbar(); Type: FUNCTION; Schema: public; Owner: freiraum
--

CREATE FUNCTION public.einschraenkung_unumkehrbar() RETURNS trigger
    LANGUAGE plpgsql
    SET search_path TO 'public', 'pg_temp'
    AS $$
BEGIN
  IF OLD.einschraenkung_ab IS NOT NULL AND NEW.einschraenkung_ab IS NULL THEN
    RAISE EXCEPTION 'EINSCHRAENKUNG: einmal gesetzt, nicht stillschweigend aufhebbar (H1, K15)'
      USING ERRCODE = 'check_violation';
  END IF;
  RETURN NEW;
END $$;


ALTER FUNCTION public.einschraenkung_unumkehrbar() OWNER TO freiraum;

--
-- Name: element_ist_elementvorlage(); Type: FUNCTION; Schema: public; Owner: freiraum
--

CREATE FUNCTION public.element_ist_elementvorlage() RETURNS trigger
    LANGUAGE plpgsql
    SET search_path TO 'public', 'pg_temp'
    AS $$
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


ALTER FUNCTION public.element_ist_elementvorlage() OWNER TO freiraum;

--
-- Name: frist_ende(timestamp with time zone, integer, integer); Type: FUNCTION; Schema: public; Owner: freiraum
--

CREATE FUNCTION public.frist_ende(ab timestamp with time zone, monate integer, tage integer) RETURNS date
    LANGUAGE sql IMMUTABLE
    SET search_path TO 'public', 'pg_temp'
    AS $$
  SELECT CASE
    WHEN tage   IS NOT NULL THEN (ab + (tage   || ' days')::interval)::date
    WHEN monate IS NOT NULL THEN (ab + (monate || ' months')::interval)::date
    ELSE NULL
  END
$$;


ALTER FUNCTION public.frist_ende(ab timestamp with time zone, monate integer, tage integer) OWNER TO freiraum;

--
-- Name: invitation_guard(); Type: FUNCTION; Schema: public; Owner: freiraum
--

CREATE FUNCTION public.invitation_guard() RETURNS trigger
    LANGUAGE plpgsql
    SET search_path TO 'public', 'pg_temp'
    AS $$
DECLARE d text; ttl smallint;
BEGIN
  SELECT t.invite_domain, t.invite_ttl_hours INTO d, ttl
    FROM actor a JOIN tenant t ON t.id = a.tenant_id
   WHERE a.id = NEW.actor_id;
  IF d IS NOT NULL AND lower(NEW.mail) NOT LIKE '%@' || lower(d) THEN
    RAISE EXCEPTION 'Nur Adressen der Domaene @% sind zulaessig', d
      USING ERRCODE = 'check_violation';
  END IF;
  IF NEW.expires_at > NEW.sent_at + (ttl || ' hours')::interval THEN
    RAISE EXCEPTION 'Einladung ueberschreitet die konfigurierte Gueltigkeit von % Stunden', ttl
      USING ERRCODE = 'check_violation';
  END IF;
  RETURN NEW;
END $$;


ALTER FUNCTION public.invitation_guard() OWNER TO freiraum;

--
-- Name: lifecycle_transition_guard(); Type: FUNCTION; Schema: public; Owner: freiraum
--

CREATE FUNCTION public.lifecycle_transition_guard() RETURNS trigger
    LANGUAGE plpgsql
    SET search_path TO 'public', 'pg_temp'
    AS $$
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


ALTER FUNCTION public.lifecycle_transition_guard() OWNER TO freiraum;

--
-- Name: login_attempt_guard(); Type: FUNCTION; Schema: public; Owner: freiraum
--

CREATE FUNCTION public.login_attempt_guard() RETURNS trigger
    LANGUAGE plpgsql
    SET search_path TO 'public', 'pg_temp'
    AS $$
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


ALTER FUNCTION public.login_attempt_guard() OWNER TO freiraum;

--
-- Name: login_attempt_koppelt_code(); Type: FUNCTION; Schema: public; Owner: freiraum
--

CREATE FUNCTION public.login_attempt_koppelt_code() RETURNS trigger
    LANGUAGE plpgsql
    SET search_path TO 'public', 'pg_temp'
    AS $$
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


ALTER FUNCTION public.login_attempt_koppelt_code() OWNER TO freiraum;

--
-- Name: FUNCTION login_attempt_koppelt_code(); Type: COMMENT; Schema: public; Owner: freiraum
--

COMMENT ON FUNCTION public.login_attempt_koppelt_code() IS 'K03-M16, Delta-Review 05.08.2026: Ein Fehlversuch erhoeht den Zaehler am offenen Code und entwertet ihn beim fuenften. Vorher zaehlten login_attempt und login_code.failed_count dasselbe, ohne voneinander zu wissen.';


--
-- Name: login_code_entwertet_aeltere(); Type: FUNCTION; Schema: public; Owner: freiraum
--

CREATE FUNCTION public.login_code_entwertet_aeltere() RETURNS trigger
    LANGUAGE plpgsql
    SET search_path TO 'public', 'pg_temp'
    AS $$
BEGIN
  UPDATE login_code
     SET superseded_at = clock_timestamp()
   WHERE actor_id = NEW.actor_id
     AND id <> NEW.id
     AND consumed_at IS NULL
     AND superseded_at IS NULL;
  RETURN NEW;
END $$;


ALTER FUNCTION public.login_code_entwertet_aeltere() OWNER TO freiraum;

--
-- Name: platform_admin_guard(); Type: FUNCTION; Schema: public; Owner: freiraum
--

CREATE FUNCTION public.platform_admin_guard() RETURNS trigger
    LANGUAGE plpgsql
    SET search_path TO 'public', 'pg_temp'
    AS $$
DECLARE n integer;
BEGIN
  SELECT count(*) INTO n
    FROM actor a JOIN membership m ON m.actor_id = a.id
   WHERE m.portal_code = 'EXMA' AND a.status = 'AKTIV';
  IF n < 1 THEN
    RAISE EXCEPTION 'Mindestens ein aktiver Plattform-Admin muss bestehen bleiben'
      USING ERRCODE = 'check_violation';
  END IF;
  RETURN NULL;
END $$;


ALTER FUNCTION public.platform_admin_guard() OWNER TO freiraum;

--
-- Name: policy_body_immutable(); Type: FUNCTION; Schema: public; Owner: freiraum
--

CREATE FUNCTION public.policy_body_immutable() RETURNS trigger
    LANGUAGE plpgsql
    SET search_path TO 'public', 'pg_temp'
    AS $$
BEGIN
  IF OLD.status = 'RELEASED' AND NEW.body_md IS DISTINCT FROM OLD.body_md THEN
    RAISE EXCEPTION 'RICHTLINIENTEXT: veroeffentlichter Wortlaut wird nie ueberschrieben (K21-M19)'
      USING ERRCODE = 'check_violation';
  END IF;
  RETURN NEW;
END $$;


ALTER FUNCTION public.policy_body_immutable() OWNER TO freiraum;

--
-- Name: register_no_unveraenderlich(); Type: FUNCTION; Schema: public; Owner: freiraum
--

CREATE FUNCTION public.register_no_unveraenderlich() RETURNS trigger
    LANGUAGE plpgsql
    SET search_path TO 'public', 'pg_temp'
    AS $$
BEGIN
  IF OLD.register_no IS NOT NULL AND NEW.register_no IS DISTINCT FROM OLD.register_no THEN
    RAISE EXCEPTION 'REGISTERNUMMER: einmal vergeben, unveraenderlich (K08-M24)'
      USING ERRCODE = 'check_violation';
  END IF;
  RETURN NEW;
END $$;


ALTER FUNCTION public.register_no_unveraenderlich() OWNER TO freiraum;

--
-- Name: rls_erzwungen(); Type: FUNCTION; Schema: public; Owner: freiraum
--

CREATE FUNCTION public.rls_erzwungen() RETURNS boolean
    LANGUAGE sql STABLE
    SET search_path TO 'public', 'pg_temp'
    AS $$
  SELECT coalesce(current_setting('freiraum.rls_enforce', true), 'off') = 'on'
$$;


ALTER FUNCTION public.rls_erzwungen() OWNER TO freiraum;

--
-- Name: FUNCTION rls_erzwungen(); Type: COMMENT; Schema: public; Owner: freiraum
--

COMMENT ON FUNCTION public.rls_erzwungen() IS 'L1: Solange aus, laesst eine fehlende Sitzung die Zeile durch. Steht er auf on, nicht mehr.';


--
-- Name: sealed_actor_guard(); Type: FUNCTION; Schema: public; Owner: freiraum
--

CREATE FUNCTION public.sealed_actor_guard() RETURNS trigger
    LANGUAGE plpgsql
    SET search_path TO 'public', 'pg_temp'
    AS $$
DECLARE n integer;
BEGIN
  IF OLD.sealed THEN
    SELECT count(*) INTO n
      FROM actor a JOIN membership m ON m.actor_id = a.id
     WHERE m.portal_code = 'EXMA' AND a.status = 'AKTIV' AND a.id <> OLD.id;
    IF n < 1 THEN
      RAISE EXCEPTION 'Erst-Admin: loeschbar erst, wenn ein zweiter aktiver Plattform-Admin besteht'
        USING ERRCODE = 'check_violation';
    END IF;
  END IF;
  RETURN OLD;
END $$;


ALTER FUNCTION public.sealed_actor_guard() OWNER TO freiraum;

--
-- Name: sealed_irreversible_guard(); Type: FUNCTION; Schema: public; Owner: freiraum
--

CREATE FUNCTION public.sealed_irreversible_guard() RETURNS trigger
    LANGUAGE plpgsql
    SET search_path TO 'public', 'pg_temp'
    AS $$
BEGIN
  IF OLD.sealed AND NOT NEW.sealed THEN
    RAISE EXCEPTION 'SIEGEL: die Ruecknahme des Siegels ist ausgeschlossen (Nr. 38)'
      USING ERRCODE = 'check_violation';
  END IF;
  RETURN NEW;
END $$;


ALTER FUNCTION public.sealed_irreversible_guard() OWNER TO freiraum;

--
-- Name: session_event_writer(); Type: FUNCTION; Schema: public; Owner: freiraum
--

CREATE FUNCTION public.session_event_writer() RETURNS trigger
    LANGUAGE plpgsql
    SET search_path TO 'public', 'pg_temp'
    AS $$
DECLARE lbl text; ten uuid;
BEGIN
  SELECT a.display_name, a.tenant_id INTO lbl, ten FROM actor a WHERE a.id = NEW.actor_id;
  INSERT INTO event(actor_id, actor_label, tenant_id, action, object_ref, change_type, source)
  VALUES (NEW.actor_id, lbl, ten, 'ANMELDUNG', 'SESSION:' || NEW.id::text, 'Neuanlage', 'PORTAL_ACTION');
  RETURN NEW;
END $$;


ALTER FUNCTION public.session_event_writer() OWNER TO freiraum;

--
-- Name: set_journey_phase(uuid, public.journey_phase, uuid); Type: FUNCTION; Schema: public; Owner: freiraum
--

CREATE FUNCTION public.set_journey_phase(p_app uuid, p_ziel public.journey_phase, p_actor uuid) RETURNS void
    LANGUAGE plpgsql SECURITY DEFINER
    SET search_path TO 'public', 'pg_temp'
    AS $$
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
END $$;


ALTER FUNCTION public.set_journey_phase(p_app uuid, p_ziel public.journey_phase, p_actor uuid) OWNER TO freiraum;

--
-- Name: FUNCTION set_journey_phase(p_app uuid, p_ziel public.journey_phase, p_actor uuid); Type: COMMENT; Schema: public; Owner: freiraum
--

COMMENT ON FUNCTION public.set_journey_phase(p_app uuid, p_ziel public.journey_phase, p_actor uuid) IS 'K05-M08/K05-M19: der einzige Schreibweg fuer app.journey_phase. Protokolleintrag atomar.';


--
-- Name: sitzungs_mandant(); Type: FUNCTION; Schema: public; Owner: freiraum
--

CREATE FUNCTION public.sitzungs_mandant() RETURNS uuid
    LANGUAGE plpgsql STABLE
    SET search_path TO 'public', 'pg_temp'
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


ALTER FUNCTION public.sitzungs_mandant() OWNER TO freiraum;

--
-- Name: FUNCTION sitzungs_mandant(); Type: COMMENT; Schema: public; Owner: freiraum
--

COMMENT ON FUNCTION public.sitzungs_mandant() IS 'Der Mandant der laufenden Anfrage, vom Serverpfad in freiraum.tenant_id hinterlegt. NULL heisst: nicht gesetzt. Ob das durchgelassen oder abgewiesen wird, entscheidet freiraum.rls_enforce -- im Pilot aus, vor dem ersten Mandanten mit echten Daten an (O-K13-1, T4, Echtdaten-Tor E2).';


--
-- Name: template_art_bleibt(); Type: FUNCTION; Schema: public; Owner: freiraum
--

CREATE FUNCTION public.template_art_bleibt() RETURNS trigger
    LANGUAGE plpgsql
    SET search_path TO 'public', 'pg_temp'
    AS $$
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


ALTER FUNCTION public.template_art_bleibt() OWNER TO freiraum;

--
-- Name: tenant_domain_audit(); Type: FUNCTION; Schema: public; Owner: freiraum
--

CREATE FUNCTION public.tenant_domain_audit() RETURNS trigger
    LANGUAGE plpgsql
    SET search_path TO 'public', 'pg_temp'
    AS $$
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


ALTER FUNCTION public.tenant_domain_audit() OWNER TO freiraum;

--
-- Name: tenant_invite_domain_audit(); Type: FUNCTION; Schema: public; Owner: freiraum
--

CREATE FUNCTION public.tenant_invite_domain_audit() RETURNS trigger
    LANGUAGE plpgsql
    SET search_path TO 'public', 'pg_temp'
    AS $$
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


ALTER FUNCTION public.tenant_invite_domain_audit() OWNER TO freiraum;

SET default_tablespace = '';

SET default_table_access_method = heap;

--
-- Name: actor; Type: TABLE; Schema: public; Owner: freiraum
--

CREATE TABLE public.actor (
    id uuid DEFAULT gen_random_uuid() NOT NULL,
    tenant_id uuid NOT NULL,
    user_code text,
    email text NOT NULL,
    display_name text NOT NULL,
    mfa_method public.mfa_method DEFAULT 'EMAIL_CODE'::public.mfa_method NOT NULL,
    status public.actor_status DEFAULT 'WARTET_2FA'::public.actor_status NOT NULL,
    status_before_lock public.actor_status,
    sealed boolean DEFAULT false NOT NULL,
    money_rights boolean DEFAULT false NOT NULL,
    created_on date,
    last_login_at timestamp with time zone,
    CONSTRAINT actor_lock_state CHECK (((status_before_lock IS NULL) OR ((status = 'GESPERRT'::public.actor_status) AND (status_before_lock <> 'GESPERRT'::public.actor_status)))),
    CONSTRAINT actor_sealed_no_money CHECK ((NOT (sealed AND money_rights))),
    CONSTRAINT actor_user_code_check CHECK ((user_code ~ '^[A-Z]{2,8}-[A-Z]{3}-[0-9]{4}$'::text))
);


ALTER TABLE public.actor OWNER TO freiraum;

--
-- Name: agent; Type: TABLE; Schema: public; Owner: freiraum
--

CREATE TABLE public.agent (
    id uuid DEFAULT gen_random_uuid() NOT NULL,
    catalog_group public.catalog_group,
    name text NOT NULL,
    role_kind text,
    model_ref_id uuid NOT NULL,
    is_readonly boolean DEFAULT false NOT NULL,
    status public.agent_status DEFAULT 'IN_REVIEW'::public.agent_status NOT NULL,
    monthly_tokens_m numeric,
    review_score integer,
    output_form text,
    allowed_actions jsonb,
    telemetrie_stand_at timestamp with time zone,
    CONSTRAINT agent_monthly_tokens_m_check CHECK ((monthly_tokens_m >= (0)::numeric)),
    CONSTRAINT agent_released_vollstaendig CHECK (((status <> 'RELEASED'::public.agent_status) OR ((output_form IS NOT NULL) AND (allowed_actions IS NOT NULL)))),
    CONSTRAINT agent_review_score_check CHECK (((review_score >= 0) AND (review_score <= 100)))
);


ALTER TABLE public.agent OWNER TO freiraum;

--
-- Name: agent_knowledge; Type: TABLE; Schema: public; Owner: freiraum
--

CREATE TABLE public.agent_knowledge (
    agent_id uuid NOT NULL,
    module_id text NOT NULL
);


ALTER TABLE public.agent_knowledge OWNER TO freiraum;

--
-- Name: agent_policy; Type: TABLE; Schema: public; Owner: freiraum
--

CREATE TABLE public.agent_policy (
    agent_id uuid NOT NULL,
    policy_id text NOT NULL
);


ALTER TABLE public.agent_policy OWNER TO freiraum;

--
-- Name: agent_template; Type: TABLE; Schema: public; Owner: freiraum
--

CREATE TABLE public.agent_template (
    agent_id uuid NOT NULL,
    template_id text NOT NULL
);


ALTER TABLE public.agent_template OWNER TO freiraum;

--
-- Name: app; Type: TABLE; Schema: public; Owner: freiraum
--

CREATE TABLE public.app (
    id uuid DEFAULT gen_random_uuid() NOT NULL,
    tenant_id uuid NOT NULL,
    project_no text NOT NULL,
    name text NOT NULL,
    artifact_class public.artifact_class DEFAULT 'VERIFIED_APP'::public.artifact_class NOT NULL,
    lifecycle_state public.lifecycle_state DEFAULT 'DISCOVERY'::public.lifecycle_state NOT NULL,
    journey_phase public.journey_phase DEFAULT 'ORIENTIERUNG'::public.journey_phase NOT NULL,
    fit_check_id uuid,
    sealed_at timestamp with time zone,
    currency public.currency_code DEFAULT 'EUR'::public.currency_code NOT NULL,
    retention_class public.retention_class DEFAULT 'HANDELSRECHT'::public.retention_class NOT NULL,
    offer_price_cents integer,
    margin_cents integer,
    open_points integer,
    created_at date NOT NULL,
    updated_at timestamp with time zone,
    deleted_at timestamp with time zone,
    mitbestimmung_ack_at timestamp with time zone,
    auswahlvermerk text,
    auswahlvermerk_at timestamp with time zone,
    einschraenkung_ab timestamp with time zone,
    einschraenkung_grund text,
    CONSTRAINT ack_needs_seal CHECK (((mitbestimmung_ack_at IS NULL) OR (sealed_at IS NOT NULL))),
    CONSTRAINT app_is_verified CHECK ((artifact_class = 'VERIFIED_APP'::public.artifact_class)),
    CONSTRAINT app_offer_price_cents_check CHECK ((offer_price_cents >= 0)),
    CONSTRAINT app_open_points_check CHECK ((open_points >= 0)),
    CONSTRAINT app_project_no_check CHECK ((project_no ~ '^DE-[A-Z]{3}_[0-9]{3}_[0-9]{2}$'::text)),
    CONSTRAINT auswahlvermerk_paar CHECK (((auswahlvermerk IS NULL) = (auswahlvermerk_at IS NULL))),
    CONSTRAINT einschraenkung_ganz CHECK ((((einschraenkung_ab IS NULL) AND (einschraenkung_grund IS NULL)) OR ((einschraenkung_ab IS NOT NULL) AND (btrim(COALESCE(einschraenkung_grund, ''::text)) <> ''::text)))),
    CONSTRAINT sealed_needs_state CHECK (((sealed_at IS NULL) OR (lifecycle_state <> 'DISCOVERY'::public.lifecycle_state)))
);

ALTER TABLE ONLY public.app FORCE ROW LEVEL SECURITY;


ALTER TABLE public.app OWNER TO freiraum;

--
-- Name: COLUMN app.einschraenkung_ab; Type: COMMENT; Schema: public; Owner: freiraum
--

COMMENT ON COLUMN public.app.einschraenkung_ab IS 'H1: Zeitpunkt, ab dem die Zeile wegen eines Loeschverlangens gesperrt ist. Die Faelligkeit richtet sich weiter nach retention_class -- die Einschraenkung verkuerzt keine Frist, sie ueberbrueckt sie.';


--
-- Name: app_eingeschraenkt; Type: VIEW; Schema: public; Owner: freiraum
--

CREATE VIEW public.app_eingeschraenkt AS
 SELECT id,
    tenant_id,
    project_no,
    name,
    einschraenkung_ab,
    einschraenkung_grund,
    retention_class
   FROM public.app a
  WHERE (einschraenkung_ab IS NOT NULL);


ALTER VIEW public.app_eingeschraenkt OWNER TO freiraum;

--
-- Name: VIEW app_eingeschraenkt; Type: COMMENT; Schema: public; Owner: freiraum
--

COMMENT ON VIEW public.app_eingeschraenkt IS 'H1, gez. A. Han 05.08.2026. Anwendungen unter Einschraenkung nach einem Loeschverlangen, dessen Bestaende noch einer handelsrechtlichen Frist unterliegen. Sie werden nicht geloescht und nicht gezeigt -- sie warten auf ihre Faelligkeit und werden dann ohne neues Verlangen entfernt.';


--
-- Name: fit_check; Type: TABLE; Schema: public; Owner: freiraum
--

CREATE TABLE public.fit_check (
    id uuid DEFAULT gen_random_uuid() NOT NULL,
    tenant_id uuid NOT NULL,
    actor_id uuid,
    app_id uuid,
    started_at timestamp with time zone DEFAULT now() NOT NULL,
    completed_at timestamp with time zone,
    outcome public.fit_outcome DEFAULT 'OFFEN'::public.fit_outcome NOT NULL,
    retention_class public.retention_class DEFAULT 'KI_NACHWEIS'::public.retention_class NOT NULL,
    zweckbestimmung_ack_at timestamp with time zone,
    zweck_bewertung_menschen boolean,
    zweck_verbotene_praktik boolean,
    zweckbestimmung_erklaert_am timestamp with time zone,
    CONSTRAINT ack_klasse_ki_nachweis CHECK (((zweckbestimmung_ack_at IS NULL) OR (retention_class = 'KI_NACHWEIS'::public.retention_class))),
    CONSTRAINT ack_nach_eignung CHECK (((zweckbestimmung_ack_at IS NULL) OR (outcome = 'GEEIGNET'::public.fit_outcome))),
    CONSTRAINT fit_done_needs_ts CHECK (((outcome = 'OFFEN'::public.fit_outcome) OR (completed_at IS NOT NULL))),
    CONSTRAINT zweck_erklaerung_vollstaendig CHECK (((zweckbestimmung_erklaert_am IS NULL) OR ((zweck_bewertung_menschen IS NOT NULL) AND (zweck_verbotene_praktik IS NOT NULL))))
);


ALTER TABLE public.fit_check OWNER TO freiraum;

--
-- Name: COLUMN fit_check.zweck_bewertung_menschen; Type: COMMENT; Schema: public; Owner: freiraum
--

COMMENT ON COLUMN public.fit_check.zweck_bewertung_menschen IS 'K04-M19, erste Frage: bewertet, waehlt aus oder ueberwacht die Anwendung Menschen (Anhang III)? NULL = noch nicht beantwortet. Ein Treffer ist KEIN Halt (K04-D09), er loest die Kenntnisnahme aus (K04-M20).';


--
-- Name: COLUMN fit_check.zweck_verbotene_praktik; Type: COMMENT; Schema: public; Owner: freiraum
--

COMMENT ON COLUMN public.fit_check.zweck_verbotene_praktik IS 'K04-M19, zweite Frage: verbotene Praktik nach Art. 5 der KI-Verordnung? NULL = noch nicht beantwortet. Ein Treffer haelt den Weg an und wird nicht weitergefuehrt (K04-D10); dort heilt keine Aufklaerung und keine Bestaetigung.';


--
-- Name: COLUMN fit_check.zweckbestimmung_erklaert_am; Type: COMMENT; Schema: public; Owner: freiraum
--

COMMENT ON COLUMN public.fit_check.zweckbestimmung_erklaert_am IS 'Zeitpunkt, zu dem BEIDE Fragen beantwortet vorlagen. Wird beim Zuruecknehmen einer Antwort wieder geleert -- eine Erklaerung mit einer offenen Frage ist keine.';


--
-- Name: app_fit_ok; Type: VIEW; Schema: public; Owner: freiraum
--

CREATE VIEW public.app_fit_ok AS
 SELECT a.id,
    a.tenant_id,
    a.project_no,
    a.name,
    a.artifact_class,
    a.lifecycle_state,
    a.journey_phase,
    a.fit_check_id,
    a.sealed_at,
    a.currency,
    a.retention_class,
    a.offer_price_cents,
    a.margin_cents,
    a.open_points,
    a.created_at,
    a.updated_at,
    a.deleted_at,
    a.mitbestimmung_ack_at
   FROM (public.app a
     JOIN public.fit_check f ON ((f.id = a.fit_check_id)))
  WHERE (f.outcome = 'GEEIGNET'::public.fit_outcome);


ALTER VIEW public.app_fit_ok OWNER TO freiraum;

--
-- Name: app_state_history; Type: TABLE; Schema: public; Owner: freiraum
--

CREATE TABLE public.app_state_history (
    app_id uuid NOT NULL,
    state public.lifecycle_state NOT NULL,
    gueltig tstzrange NOT NULL
);


ALTER TABLE public.app_state_history OWNER TO freiraum;

--
-- Name: app_state_aktuell; Type: VIEW; Schema: public; Owner: freiraum
--

CREATE VIEW public.app_state_aktuell AS
 SELECT app_id,
    state,
    lower(gueltig) AS seit
   FROM public.app_state_history h
  WHERE upper_inf(gueltig);


ALTER VIEW public.app_state_aktuell OWNER TO freiraum;

--
-- Name: approval; Type: TABLE; Schema: public; Owner: freiraum
--

CREATE TABLE public.approval (
    id uuid DEFAULT gen_random_uuid() NOT NULL,
    object_ref text NOT NULL,
    editor_actor_id uuid NOT NULL,
    approver_actor_id uuid NOT NULL,
    approved_at timestamp with time zone DEFAULT now() NOT NULL,
    objekt_art public.approval_object,
    objekt_id text,
    objekt_version text,
    anlass public.approval_reason,
    tenant_id uuid,
    mandantenbezug public.approval_tenant_scope,
    CONSTRAINT approval_app_ist_mandant CHECK (((objekt_art IS DISTINCT FROM 'APP'::public.approval_object) OR (mandantenbezug = 'MANDANT'::public.approval_tenant_scope))),
    CONSTRAINT approval_bezug_ganz CHECK (((objekt_art IS NULL) OR ((objekt_id IS NOT NULL) AND (anlass IS NOT NULL)))),
    CONSTRAINT approval_mandant_ganz CHECK (((objekt_art IS NULL) OR (mandantenbezug IS NOT NULL))),
    CONSTRAINT approval_mandant_passt CHECK (((mandantenbezug IS NULL) OR ((mandantenbezug = 'MANDANT'::public.approval_tenant_scope) AND (tenant_id IS NOT NULL)) OR ((mandantenbezug = 'GLOBAL'::public.approval_tenant_scope) AND (tenant_id IS NULL)) OR (mandantenbezug = 'MITTELBAR'::public.approval_tenant_scope))),
    CONSTRAINT sod_editor_ne_approver CHECK ((editor_actor_id <> approver_actor_id))
);


ALTER TABLE public.approval OWNER TO freiraum;

--
-- Name: COLUMN approval.mandantenbezug; Type: COMMENT; Schema: public; Owner: freiraum
--

COMMENT ON COLUMN public.approval.mandantenbezug IS 'Zeichnung T4 vom 05.08.2026: MANDANT | GLOBAL | MITTELBAR. Loest die stille Doppelbedeutung von tenant_id IS NULL auf. MITTELBAR heisst: der Mandant steht am Eigentuemer, nicht an der Freigabe -- aufzuloesen mit O-K08-3/7.';


--
-- Name: auth_session; Type: TABLE; Schema: public; Owner: freiraum
--

CREATE TABLE public.auth_session (
    id uuid DEFAULT gen_random_uuid() NOT NULL,
    actor_id uuid NOT NULL,
    device_label text,
    started_at timestamp with time zone DEFAULT now() NOT NULL,
    last_activity_at timestamp with time zone DEFAULT now() NOT NULL,
    ended_at timestamp with time zone,
    CONSTRAINT session_aktivitaet_nach_beginn CHECK ((last_activity_at >= started_at)),
    CONSTRAINT session_ende_nach_beginn CHECK (((ended_at IS NULL) OR (ended_at >= started_at)))
);


ALTER TABLE public.auth_session OWNER TO freiraum;

--
-- Name: contact; Type: TABLE; Schema: public; Owner: freiraum
--

CREATE TABLE public.contact (
    id uuid DEFAULT gen_random_uuid() NOT NULL,
    tenant_id uuid NOT NULL,
    vorname text NOT NULL,
    nachname text NOT NULL,
    tel text,
    mail text,
    is_valid boolean DEFAULT false NOT NULL,
    "position" smallint NOT NULL,
    CONSTRAINT contact_position_check CHECK ((("position" >= 1) AND ("position" <= 3)))
);


ALTER TABLE public.contact OWNER TO freiraum;

--
-- Name: contract_check; Type: TABLE; Schema: public; Owner: freiraum
--

CREATE TABLE public.contract_check (
    id uuid DEFAULT gen_random_uuid() NOT NULL,
    app_id uuid NOT NULL,
    contract_version text NOT NULL,
    seiten smallint NOT NULL,
    ueberschritten boolean NOT NULL,
    ausgewiesen boolean DEFAULT false NOT NULL,
    checked_at timestamp with time zone DEFAULT now() NOT NULL,
    CONSTRAINT contract_check_seiten_check CHECK ((seiten > 0)),
    CONSTRAINT ueberschreitung_ausgewiesen CHECK (((NOT ueberschritten) OR ausgewiesen))
);


ALTER TABLE public.contract_check OWNER TO freiraum;

--
-- Name: direct_prototype; Type: TABLE; Schema: public; Owner: freiraum
--

CREATE TABLE public.direct_prototype (
    id uuid DEFAULT gen_random_uuid() NOT NULL,
    tenant_id uuid NOT NULL,
    actor_id uuid,
    name text NOT NULL,
    format text NOT NULL,
    source_count smallint DEFAULT 0 NOT NULL,
    artifact_class public.artifact_class DEFAULT 'WORK_DOCUMENT'::public.artifact_class NOT NULL,
    created_at timestamp with time zone DEFAULT now() NOT NULL,
    retention_class public.retention_class DEFAULT 'ARBEITSERGEBNIS'::public.retention_class NOT NULL,
    retention_until date,
    deleted_at timestamp with time zone,
    geteilt_bis date,
    CONSTRAINT direct_prototype_source_count_check CHECK ((source_count >= 0)),
    CONSTRAINT proto_is_work_doc CHECK ((artifact_class = 'WORK_DOCUMENT'::public.artifact_class))
);


ALTER TABLE public.direct_prototype OWNER TO freiraum;

--
-- Name: COLUMN direct_prototype.geteilt_bis; Type: COMMENT; Schema: public; Owner: freiraum
--

COMMENT ON COLUMN public.direct_prototype.geteilt_bis IS 'Punkt 20: Ende der Abrufbarkeit des geteilten Prototyps, 14 Tage nach dem Teilen. NULL = nicht geteilt. Der Traeger ist hier, die Frist rechnet der Teilen-Befehl.';


--
-- Name: document; Type: TABLE; Schema: public; Owner: freiraum
--

CREATE TABLE public.document (
    id uuid DEFAULT gen_random_uuid() NOT NULL,
    app_id uuid NOT NULL,
    kind public.document_kind NOT NULL,
    filename text NOT NULL,
    mime text,
    content_ref text,
    content_sha256 text,
    content_media_type text,
    content_size_bytes bigint,
    template_id text,
    template_version text,
    concept_kind public.concept_kind,
    CONSTRAINT concept_braucht_kennung CHECK (((kind = 'CONCEPT'::public.document_kind) = (concept_kind IS NOT NULL))),
    CONSTRAINT document_sha_fmt CHECK (((content_sha256 IS NULL) OR (content_sha256 ~ '^[0-9a-f]{64}$'::text)))
);

ALTER TABLE ONLY public.document FORCE ROW LEVEL SECURITY;


ALTER TABLE public.document OWNER TO freiraum;

--
-- Name: document_version; Type: TABLE; Schema: public; Owner: freiraum
--

CREATE TABLE public.document_version (
    document_id uuid NOT NULL,
    version text NOT NULL,
    status public.lifecycle_status DEFAULT 'DRAFT'::public.lifecycle_status NOT NULL,
    gueltig daterange NOT NULL,
    editor text,
    erfasst_am timestamp with time zone DEFAULT now() NOT NULL,
    content_ref text,
    content_sha256 text,
    content_media_type text,
    content_size_bytes bigint,
    CONSTRAINT dv_released_braucht_inhalt CHECK (((status <> 'RELEASED'::public.lifecycle_status) OR ((content_ref IS NOT NULL) AND (content_sha256 IS NOT NULL) AND (content_media_type IS NOT NULL) AND (content_size_bytes IS NOT NULL)))),
    CONSTRAINT dv_sha_fmt CHECK (((content_sha256 IS NULL) OR (content_sha256 ~ '^[0-9a-f]{64}$'::text)))
);


ALTER TABLE public.document_version OWNER TO freiraum;

--
-- Name: event; Type: TABLE; Schema: public; Owner: freiraum
--

CREATE TABLE public.event (
    id uuid DEFAULT gen_random_uuid() NOT NULL,
    occurred_at timestamp with time zone DEFAULT now() NOT NULL,
    project_no text,
    tenant_id uuid,
    actor_label text,
    action text NOT NULL,
    object_ref text,
    change_type text,
    value text,
    source public.event_source NOT NULL,
    retention_class public.retention_class DEFAULT 'EREIGNIS'::public.retention_class NOT NULL,
    actor_id uuid,
    document_id uuid,
    document_version text,
    CONSTRAINT event_actor_paarweise CHECK (((actor_id IS NULL) OR (actor_label IS NOT NULL))),
    CONSTRAINT event_document_paarweise CHECK (((document_id IS NULL) = (document_version IS NULL)))
);

ALTER TABLE ONLY public.event FORCE ROW LEVEL SECURITY;


ALTER TABLE public.event OWNER TO freiraum;

--
-- Name: fit_answer; Type: TABLE; Schema: public; Owner: freiraum
--

CREATE TABLE public.fit_answer (
    fit_check_id uuid NOT NULL,
    question_code text NOT NULL,
    option_id uuid NOT NULL,
    answered_at timestamp with time zone DEFAULT now() NOT NULL,
    superseded_at timestamp with time zone
);


ALTER TABLE public.fit_answer OWNER TO freiraum;

--
-- Name: fit_option; Type: TABLE; Schema: public; Owner: freiraum
--

CREATE TABLE public.fit_option (
    id uuid DEFAULT gen_random_uuid() NOT NULL,
    question_code text NOT NULL,
    "position" smallint NOT NULL,
    label_de text NOT NULL,
    value_token text NOT NULL,
    is_eligible boolean NOT NULL,
    CONSTRAINT fit_option_position_check CHECK ((("position" >= 1) AND ("position" <= 9)))
);


ALTER TABLE public.fit_option OWNER TO freiraum;

--
-- Name: fit_question; Type: TABLE; Schema: public; Owner: freiraum
--

CREATE TABLE public.fit_question (
    code text NOT NULL,
    dimension public.fit_dimension NOT NULL,
    "position" smallint NOT NULL,
    prompt_de text NOT NULL,
    CONSTRAINT fit_question_code_check CHECK ((code ~ '^[a-z_]{3,20}$'::text)),
    CONSTRAINT fit_question_position_check CHECK ((("position" >= 1) AND ("position" <= 9)))
);


ALTER TABLE public.fit_question OWNER TO freiraum;

--
-- Name: invitation; Type: TABLE; Schema: public; Owner: freiraum
--

CREATE TABLE public.invitation (
    id uuid DEFAULT gen_random_uuid() NOT NULL,
    actor_id uuid NOT NULL,
    portal_code public.portal_code NOT NULL,
    mail text NOT NULL,
    token_hash text NOT NULL,
    sent_at timestamp with time zone DEFAULT now() NOT NULL,
    expires_at timestamp with time zone NOT NULL,
    redeemed_at timestamp with time zone,
    status public.invitation_status DEFAULT 'VERSANDT'::public.invitation_status NOT NULL,
    attempt smallint DEFAULT 1 NOT NULL,
    CONSTRAINT invitation_attempt_check CHECK ((attempt >= 1)),
    CONSTRAINT invitation_einloesung CHECK (((status = 'EINGELOEST'::public.invitation_status) = (redeemed_at IS NOT NULL))),
    CONSTRAINT invitation_frist CHECK ((expires_at > sent_at)),
    CONSTRAINT invitation_mail_fmt CHECK ((mail ~ '^[^[:space:]@]+@[^[:space:]@]+\.[^[:space:]@]+$'::text))
);


ALTER TABLE public.invitation OWNER TO freiraum;

--
-- Name: invitation_decision; Type: TABLE; Schema: public; Owner: freiraum
--

CREATE TABLE public.invitation_decision (
    id uuid DEFAULT gen_random_uuid() NOT NULL,
    tenant_id uuid NOT NULL,
    decided_by text NOT NULL,
    decided_at timestamp with time zone DEFAULT now() NOT NULL,
    adressat_mail text NOT NULL,
    grund text NOT NULL,
    invitation_id uuid,
    CONSTRAINT entscheidung_grund_nicht_leer CHECK ((length(TRIM(BOTH FROM grund)) > 0)),
    CONSTRAINT entscheidung_mail_fmt CHECK ((adressat_mail ~ '^[^[:space:]@]+@[^[:space:]@]+\.[^[:space:]@]+$'::text))
);


ALTER TABLE public.invitation_decision OWNER TO freiraum;

--
-- Name: invitation_offen; Type: VIEW; Schema: public; Owner: freiraum
--

CREATE VIEW public.invitation_offen AS
 SELECT i.id,
    i.actor_id,
    i.portal_code,
    i.mail,
    i.token_hash,
    i.sent_at,
    i.expires_at,
    i.redeemed_at,
    i.status,
    i.attempt,
    a.display_name,
    a.tenant_id
   FROM (public.invitation i
     JOIN public.actor a ON ((a.id = i.actor_id)))
  WHERE ((i.status = 'VERSANDT'::public.invitation_status) AND (i.expires_at > now()));


ALTER VIEW public.invitation_offen OWNER TO freiraum;

--
-- Name: knowledge_module; Type: TABLE; Schema: public; Owner: freiraum
--

CREATE TABLE public.knowledge_module (
    id text NOT NULL,
    grp public.knowledge_group NOT NULL,
    domaene text NOT NULL,
    title text NOT NULL,
    lang text,
    valid_until date,
    owner_label text,
    usage_count integer DEFAULT 0 NOT NULL,
    CONSTRAINT knowledge_module_id_check CHECK ((id ~ '^(BR|FN|ME)-[A-Z0-9]{2,6}-[0-9]{3}$'::text)),
    CONSTRAINT knowledge_module_usage_count_check CHECK ((usage_count >= 0))
);


ALTER TABLE public.knowledge_module OWNER TO freiraum;

--
-- Name: knowledge_module_version; Type: TABLE; Schema: public; Owner: freiraum
--

CREATE TABLE public.knowledge_module_version (
    module_id text NOT NULL,
    version text NOT NULL,
    status public.lifecycle_status DEFAULT 'DRAFT'::public.lifecycle_status NOT NULL,
    gueltig daterange NOT NULL,
    editor text,
    aenderungsvermerk text,
    erfasst_am timestamp with time zone DEFAULT now() NOT NULL
);


ALTER TABLE public.knowledge_module_version OWNER TO freiraum;

--
-- Name: knowledge_module_aktuell; Type: VIEW; Schema: public; Owner: freiraum
--

CREATE VIEW public.knowledge_module_aktuell AS
 SELECT m.id,
    m.grp,
    m.domaene,
    m.title,
    m.lang,
    m.valid_until,
    m.owner_label,
    m.usage_count,
    v.version,
    v.status,
    v.gueltig,
    v.editor,
    v.aenderungsvermerk
   FROM (public.knowledge_module m
     JOIN public.knowledge_module_version v ON ((v.module_id = m.id)))
  WHERE (v.gueltig @> CURRENT_DATE);


ALTER VIEW public.knowledge_module_aktuell OWNER TO freiraum;

--
-- Name: knowledge_module_source; Type: TABLE; Schema: public; Owner: freiraum
--

CREATE TABLE public.knowledge_module_source (
    module_id text NOT NULL,
    source_id text NOT NULL
);


ALTER TABLE public.knowledge_module_source OWNER TO freiraum;

--
-- Name: knowledge_source; Type: TABLE; Schema: public; Owner: freiraum
--

CREATE TABLE public.knowledge_source (
    id text NOT NULL,
    register_no text,
    type public.knowledge_type NOT NULL,
    origin public.knowledge_origin DEFAULT 'EXTERN'::public.knowledge_origin NOT NULL,
    project_ref text,
    source_ref text,
    wissensbereich text,
    domaene text,
    license text,
    mode public.knowledge_mode DEFAULT 'DYNAMIC'::public.knowledge_mode NOT NULL,
    status public.lifecycle_status DEFAULT 'DRAFT'::public.lifecycle_status NOT NULL,
    version text,
    editor text,
    added_at date,
    short_description text,
    meta_tags text[],
    owner_id uuid,
    owner_label text,
    zweck text,
    CONSTRAINT knowledge_source_id_check CHECK ((id ~ '^Q-[A-Z0-9]{2,4}-[0-9]{1,4}$'::text)),
    CONSTRAINT knowledge_source_register_no_check CHECK (((register_no IS NULL) OR (register_no ~ '^[A-Z]{2,4}-[0-9]{5}$'::text))),
    CONSTRAINT ks_owner_paarweise CHECK (((owner_id IS NULL) OR (owner_label IS NOT NULL))),
    CONSTRAINT ks_released_braucht_lizenz CHECK (((status <> 'RELEASED'::public.lifecycle_status) OR ((license IS NOT NULL) AND (btrim(license) <> ''::text)))),
    CONSTRAINT ks_released_braucht_pflichtangaben CHECK (((status <> 'RELEASED'::public.lifecycle_status) OR ((short_description IS NOT NULL) AND (btrim(short_description) <> ''::text) AND (zweck IS NOT NULL) AND (btrim(zweck) <> ''::text) AND (owner_label IS NOT NULL) AND (btrim(owner_label) <> ''::text)))),
    CONSTRAINT ks_released_braucht_register_no CHECK (((status <> 'RELEASED'::public.lifecycle_status) OR (register_no IS NOT NULL))),
    CONSTRAINT lizenz_spdx_form CHECK (((license IS NULL) OR (license ~ '^LicenseRef-[A-Za-z0-9.-]+$'::text) OR (license ~ '^[A-Za-z0-9][A-Za-z0-9.+-]*$'::text))),
    CONSTRAINT oss_nur_mit_apache CHECK (((type <> 'OSS'::public.knowledge_type) OR (status <> 'RELEASED'::public.lifecycle_status) OR (license = ANY (ARRAY['MIT'::text, 'Apache-2.0'::text])))),
    CONSTRAINT project_source_needs_ref CHECK (((origin <> 'PROJEKT'::public.knowledge_origin) OR (project_ref IS NOT NULL)))
);


ALTER TABLE public.knowledge_source OWNER TO freiraum;

--
-- Name: knowledge_source_draft; Type: VIEW; Schema: public; Owner: freiraum
--

CREATE VIEW public.knowledge_source_draft AS
 SELECT id,
    register_no,
    type,
    origin,
    project_ref,
    source_ref,
    wissensbereich,
    domaene,
    license,
    mode,
    status,
    version,
    editor,
    added_at
   FROM public.knowledge_source
  WHERE (status <> 'RELEASED'::public.lifecycle_status);


ALTER VIEW public.knowledge_source_draft OWNER TO freiraum;

--
-- Name: knowledge_source_released; Type: VIEW; Schema: public; Owner: freiraum
--

CREATE VIEW public.knowledge_source_released AS
 SELECT id,
    register_no,
    type,
    origin,
    project_ref,
    source_ref,
    wissensbereich,
    domaene,
    license,
    mode,
    status,
    version,
    editor,
    added_at
   FROM public.knowledge_source
  WHERE (status = 'RELEASED'::public.lifecycle_status);


ALTER VIEW public.knowledge_source_released OWNER TO freiraum;

--
-- Name: lifecycle_state_label; Type: TABLE; Schema: public; Owner: freiraum
--

CREATE TABLE public.lifecycle_state_label (
    state public.lifecycle_state NOT NULL,
    locale public.ui_locale NOT NULL,
    label text NOT NULL
);


ALTER TABLE public.lifecycle_state_label OWNER TO freiraum;

--
-- Name: login_attempt; Type: TABLE; Schema: public; Owner: freiraum
--

CREATE TABLE public.login_attempt (
    id uuid DEFAULT gen_random_uuid() NOT NULL,
    email text NOT NULL,
    origin_hash text NOT NULL,
    attempted_at timestamp with time zone DEFAULT now() NOT NULL,
    success boolean NOT NULL,
    retention_class public.retention_class DEFAULT 'KURZFRIST'::public.retention_class NOT NULL
);


ALTER TABLE public.login_attempt OWNER TO freiraum;

--
-- Name: login_code; Type: TABLE; Schema: public; Owner: freiraum
--

CREATE TABLE public.login_code (
    id uuid DEFAULT gen_random_uuid() NOT NULL,
    actor_id uuid NOT NULL,
    code_hash text NOT NULL,
    issued_at timestamp with time zone DEFAULT now() NOT NULL,
    expires_at timestamp with time zone DEFAULT (now() + '00:10:00'::interval) NOT NULL,
    consumed_at timestamp with time zone,
    superseded_at timestamp with time zone,
    failed_count smallint DEFAULT 0 NOT NULL,
    retention_class public.retention_class DEFAULT 'KURZFRIST'::public.retention_class NOT NULL,
    CONSTRAINT login_code_ende_eindeutig CHECK (((consumed_at IS NULL) OR (superseded_at IS NULL))),
    CONSTRAINT login_code_fehlversuche CHECK (((failed_count >= 0) AND (failed_count <= 5))),
    CONSTRAINT login_code_frist CHECK ((expires_at <= (issued_at + '00:10:00'::interval)))
);


ALTER TABLE public.login_code OWNER TO freiraum;

--
-- Name: mail_delivery; Type: TABLE; Schema: public; Owner: freiraum
--

CREATE TABLE public.mail_delivery (
    id uuid DEFAULT gen_random_uuid() NOT NULL,
    actor_id uuid,
    login_code_id uuid,
    kind public.mail_kind NOT NULL,
    recipient text NOT NULL,
    sender text NOT NULL,
    status public.mail_status NOT NULL,
    provider_id text,
    provider_note text,
    mail_header text,
    sent_at timestamp with time zone DEFAULT now() NOT NULL,
    retention_class public.retention_class DEFAULT 'KURZFRIST'::public.retention_class NOT NULL,
    CONSTRAINT mail_fehler_braucht_grund CHECK (((status = 'UEBERGEBEN'::public.mail_status) OR (provider_note IS NOT NULL)))
);


ALTER TABLE public.mail_delivery OWNER TO freiraum;

--
-- Name: membership; Type: TABLE; Schema: public; Owner: freiraum
--

CREATE TABLE public.membership (
    actor_id uuid NOT NULL,
    portal_code public.portal_code NOT NULL,
    role_id uuid NOT NULL,
    tenant_scope uuid NOT NULL
);


ALTER TABLE public.membership OWNER TO freiraum;

--
-- Name: model_manifest; Type: TABLE; Schema: public; Owner: freiraum
--

CREATE TABLE public.model_manifest (
    id text NOT NULL,
    name text NOT NULL,
    zweck text
);


ALTER TABLE public.model_manifest OWNER TO freiraum;

--
-- Name: model_manifest_version; Type: TABLE; Schema: public; Owner: freiraum
--

CREATE TABLE public.model_manifest_version (
    manifest_id text NOT NULL,
    version text NOT NULL,
    status public.lifecycle_status DEFAULT 'DRAFT'::public.lifecycle_status NOT NULL,
    gueltig daterange NOT NULL,
    editor text,
    erfasst_am timestamp with time zone DEFAULT now() NOT NULL,
    content_ref text,
    content_sha256 text,
    content_media_type text,
    content_size_bytes bigint,
    CONSTRAINT mmv_released_braucht_inhalt CHECK (((status <> 'RELEASED'::public.lifecycle_status) OR ((content_ref IS NOT NULL) AND (content_sha256 IS NOT NULL) AND (content_media_type IS NOT NULL) AND (content_size_bytes IS NOT NULL)))),
    CONSTRAINT mmv_sha_fmt CHECK (((content_sha256 IS NULL) OR (content_sha256 ~ '^[0-9a-f]{64}$'::text)))
);


ALTER TABLE public.model_manifest_version OWNER TO freiraum;

--
-- Name: model_ref; Type: TABLE; Schema: public; Owner: freiraum
--

CREATE TABLE public.model_ref (
    id uuid DEFAULT gen_random_uuid() NOT NULL,
    token text NOT NULL,
    provider public.model_provider NOT NULL,
    model text NOT NULL,
    version text DEFAULT 'n/a'::text NOT NULL,
    hosting public.model_hosting NOT NULL,
    manifest_id text,
    manifest_version text,
    CONSTRAINT model_manifest_paarweise CHECK (((manifest_id IS NULL) = (manifest_version IS NULL)))
);


ALTER TABLE public.model_ref OWNER TO freiraum;

--
-- Name: module; Type: TABLE; Schema: public; Owner: freiraum
--

CREATE TABLE public.module (
    display_code text NOT NULL,
    internal_key text NOT NULL,
    name text NOT NULL,
    portal_code public.portal_code NOT NULL,
    CONSTRAINT module_display_code_check CHECK ((display_code ~ '^M[0-9]{1,2}$'::text))
);


ALTER TABLE public.module OWNER TO freiraum;

--
-- Name: nummernvorrat; Type: TABLE; Schema: public; Owner: freiraum
--

CREATE TABLE public.nummernvorrat (
    praefix text NOT NULL,
    naechste_nummer bigint DEFAULT 1 NOT NULL,
    verwendung text NOT NULL,
    geaendert_am timestamp with time zone DEFAULT now() NOT NULL,
    CONSTRAINT nummernvorrat_naechste_nummer_check CHECK ((naechste_nummer >= 1))
);


ALTER TABLE public.nummernvorrat OWNER TO freiraum;

--
-- Name: tenant; Type: TABLE; Schema: public; Owner: freiraum
--

CREATE TABLE public.tenant (
    id uuid DEFAULT gen_random_uuid() NOT NULL,
    kind public.tenant_kind NOT NULL,
    name text NOT NULL,
    customer_code text,
    legal_form public.legal_form,
    website text,
    address text,
    legal_space public.legal_space NOT NULL,
    mfa_policy public.mfa_method DEFAULT 'EMAIL_CODE'::public.mfa_method NOT NULL,
    invite_ttl_hours smallint DEFAULT 24 NOT NULL,
    invite_domain text,
    processing_region text DEFAULT 'swedencentral'::text NOT NULL,
    release_relevance text DEFAULT 'R1'::text NOT NULL,
    deleted_at timestamp with time zone,
    CONSTRAINT customer_code_fmt CHECK (((customer_code IS NULL) OR (customer_code ~ '^DE-[A-Z]{3}$'::text))),
    CONSTRAINT customer_needs_code CHECK (((kind <> 'CUSTOMER'::public.tenant_kind) OR (customer_code IS NOT NULL))),
    CONSTRAINT region_release_1 CHECK ((processing_region = 'swedencentral'::text)),
    CONSTRAINT tenant_invite_ttl_hours_check CHECK (((invite_ttl_hours >= 1) AND (invite_ttl_hours <= 168))),
    CONSTRAINT tenant_processing_region_check CHECK ((processing_region = ANY (ARRAY['swedencentral'::text, 'germanywestcentral'::text, 'westeurope'::text, 'northeurope'::text]))),
    CONSTRAINT tenant_release_relevance_check CHECK ((release_relevance = ANY (ARRAY['R1'::text, 'LATER'::text])))
);


ALTER TABLE public.tenant OWNER TO freiraum;

--
-- Name: CONSTRAINT region_release_1 ON tenant; Type: COMMENT; Schema: public; Owner: freiraum
--

COMMENT ON CONSTRAINT region_release_1 ON public.tenant IS 'Beschluss Nr. 85 vom 05.08.2026: In Release 1 gilt eine Region fuer alle. Die Spalte laesst mehr zu; diese Bedingung faellt, wenn Release 2 mehrere Regionen zusagt -- dann als eigene Migration mit eigener Zeichnung.';


--
-- Name: platform_admin; Type: VIEW; Schema: public; Owner: freiraum
--

CREATE VIEW public.platform_admin AS
 SELECT a.id,
    a.user_code,
    a.display_name,
    a.email,
    a.status,
    a.sealed,
    a.money_rights,
    a.mfa_method,
    a.created_on,
    a.last_login_at,
    t.name AS reichweite,
    t.processing_region
   FROM ((public.actor a
     JOIN public.membership m ON (((m.actor_id = a.id) AND (m.portal_code = 'EXMA'::public.portal_code))))
     JOIN public.tenant t ON ((t.id = m.tenant_scope)));


ALTER VIEW public.platform_admin OWNER TO freiraum;

--
-- Name: policy; Type: TABLE; Schema: public; Owner: freiraum
--

CREATE TABLE public.policy (
    id text NOT NULL,
    name text NOT NULL,
    scope text,
    template_id text,
    CONSTRAINT policy_id_check CHECK ((id ~ '^P-[A-Z]+-[0-9]{3}$'::text))
);


ALTER TABLE public.policy OWNER TO freiraum;

--
-- Name: policy_version; Type: TABLE; Schema: public; Owner: freiraum
--

CREATE TABLE public.policy_version (
    policy_id text NOT NULL,
    version text NOT NULL,
    status public.lifecycle_status DEFAULT 'DRAFT'::public.lifecycle_status NOT NULL,
    gueltig daterange NOT NULL,
    editor text,
    aenderungsvermerk text,
    erfasst_am timestamp with time zone DEFAULT now() NOT NULL,
    body_md text
);


ALTER TABLE public.policy_version OWNER TO freiraum;

--
-- Name: policy_aktuell; Type: VIEW; Schema: public; Owner: freiraum
--

CREATE VIEW public.policy_aktuell AS
 SELECT p.id,
    p.name,
    p.scope,
    p.template_id,
    v.version,
    v.status,
    v.gueltig,
    v.editor,
    v.aenderungsvermerk,
    v.erfasst_am,
    v.body_md
   FROM (public.policy p
     JOIN public.policy_version v ON ((v.policy_id = p.id)))
  WHERE (v.gueltig @> CURRENT_DATE);


ALTER VIEW public.policy_aktuell OWNER TO freiraum;

--
-- Name: portal; Type: TABLE; Schema: public; Owner: freiraum
--

CREATE TABLE public.portal (
    code public.portal_code NOT NULL,
    name text NOT NULL,
    release_status public.release_status DEFAULT 'PLANNED'::public.release_status NOT NULL,
    data_locality text DEFAULT 'EU-Azure/swedencentral'::text NOT NULL
);


ALTER TABLE public.portal OWNER TO freiraum;

--
-- Name: portal_enabled; Type: VIEW; Schema: public; Owner: freiraum
--

CREATE VIEW public.portal_enabled AS
 SELECT code,
    name,
    release_status,
    data_locality
   FROM public.portal
  WHERE (release_status = 'ENABLED'::public.release_status);


ALTER VIEW public.portal_enabled OWNER TO freiraum;

--
-- Name: project_contract; Type: TABLE; Schema: public; Owner: freiraum
--

CREATE TABLE public.project_contract (
    app_id uuid NOT NULL,
    version text NOT NULL,
    seiten_limit smallint DEFAULT 5 NOT NULL,
    gueltig daterange NOT NULL,
    editor text,
    erfasst_am timestamp with time zone DEFAULT now() NOT NULL,
    CONSTRAINT project_contract_seiten_limit_check CHECK ((seiten_limit > 0))
);


ALTER TABLE public.project_contract OWNER TO freiraum;

--
-- Name: quick_answer; Type: TABLE; Schema: public; Owner: freiraum
--

CREATE TABLE public.quick_answer (
    quick_check_id uuid NOT NULL,
    question_code text NOT NULL,
    version text NOT NULL,
    option_pos smallint NOT NULL,
    answered_at timestamp with time zone DEFAULT now() NOT NULL,
    superseded_at timestamp with time zone
);


ALTER TABLE public.quick_answer OWNER TO freiraum;

--
-- Name: quick_check; Type: TABLE; Schema: public; Owner: freiraum
--

CREATE TABLE public.quick_check (
    id uuid DEFAULT gen_random_uuid() NOT NULL,
    tenant_id uuid NOT NULL,
    actor_id uuid,
    started_at timestamp with time zone DEFAULT now() NOT NULL,
    completed_at timestamp with time zone,
    retention_class public.retention_class DEFAULT 'BETRIEBSPROTOKOLL'::public.retention_class NOT NULL
);


ALTER TABLE public.quick_check OWNER TO freiraum;

--
-- Name: quick_option; Type: TABLE; Schema: public; Owner: freiraum
--

CREATE TABLE public.quick_option (
    question_code text NOT NULL,
    version text NOT NULL,
    "position" smallint NOT NULL,
    label_de text NOT NULL,
    value_token text NOT NULL,
    CONSTRAINT quick_option_position_check CHECK ((("position" >= 1) AND ("position" <= 9)))
);


ALTER TABLE public.quick_option OWNER TO freiraum;

--
-- Name: quick_question; Type: TABLE; Schema: public; Owner: freiraum
--

CREATE TABLE public.quick_question (
    code text NOT NULL,
    "position" smallint NOT NULL,
    CONSTRAINT quick_question_code_check CHECK ((code ~ '^[a-z_]{3,24}$'::text)),
    CONSTRAINT quick_question_position_check CHECK ((("position" >= 1) AND ("position" <= 9)))
);


ALTER TABLE public.quick_question OWNER TO freiraum;

--
-- Name: quick_question_version; Type: TABLE; Schema: public; Owner: freiraum
--

CREATE TABLE public.quick_question_version (
    question_code text NOT NULL,
    version text NOT NULL,
    prompt_de text NOT NULL,
    gueltig daterange NOT NULL
);


ALTER TABLE public.quick_question_version OWNER TO freiraum;

--
-- Name: retention_rule; Type: TABLE; Schema: public; Owner: freiraum
--

CREATE TABLE public.retention_rule (
    class public.retention_class NOT NULL,
    bezeichnung text NOT NULL,
    fristbeginn public.retention_start NOT NULL,
    regelfrist_monate integer,
    mindestfrist_monate integer NOT NULL,
    pseudonymisieren_nach_monaten integer,
    rechtsgrundlage text NOT NULL,
    regelfrist_tage integer,
    CONSTRAINT frist_ge_mindestfrist CHECK (((regelfrist_monate IS NULL) OR (regelfrist_monate >= mindestfrist_monate))),
    CONSTRAINT genau_eine_frist CHECK ((((fristbeginn = 'BEZUGSOBJEKT'::public.retention_start) AND (regelfrist_monate IS NULL) AND (regelfrist_tage IS NULL)) OR ((fristbeginn <> 'BEZUGSOBJEKT'::public.retention_start) AND ((regelfrist_monate IS NULL) <> (regelfrist_tage IS NULL))))),
    CONSTRAINT pseudonym_vor_frist CHECK (((pseudonymisieren_nach_monaten IS NULL) OR (regelfrist_monate IS NULL) OR (pseudonymisieren_nach_monaten <= regelfrist_monate))),
    CONSTRAINT tagesfrist_positiv CHECK (((regelfrist_tage IS NULL) OR (regelfrist_tage > 0)))
);


ALTER TABLE public.retention_rule OWNER TO freiraum;

--
-- Name: review_run; Type: TABLE; Schema: public; Owner: freiraum
--

CREATE TABLE public.review_run (
    id uuid DEFAULT gen_random_uuid() NOT NULL,
    app_id uuid NOT NULL,
    artifact_version text NOT NULL,
    round smallint NOT NULL,
    score smallint NOT NULL,
    threshold smallint DEFAULT 90 NOT NULL,
    passed boolean NOT NULL,
    model_ref_id uuid NOT NULL,
    rubric_module_id text,
    rubric_version text,
    completed_at timestamp with time zone DEFAULT now() NOT NULL,
    retention_class public.retention_class DEFAULT 'KI_NACHWEIS'::public.retention_class NOT NULL,
    CONSTRAINT pass_matches_threshold CHECK ((passed = (score >= threshold))),
    CONSTRAINT review_run_round_check CHECK (((round >= 1) AND (round <= 2))),
    CONSTRAINT review_run_score_check CHECK (((score >= 0) AND (score <= 100))),
    CONSTRAINT review_run_threshold_check CHECK (((threshold >= 0) AND (threshold <= 100)))
);


ALTER TABLE public.review_run OWNER TO freiraum;

--
-- Name: retention_due; Type: VIEW; Schema: public; Owner: freiraum
--

CREATE VIEW public.retention_due AS
 WITH regel AS (
         SELECT retention_rule.class,
            retention_rule.bezeichnung,
            retention_rule.fristbeginn,
            retention_rule.regelfrist_monate,
            retention_rule.regelfrist_tage,
            retention_rule.mindestfrist_monate,
            retention_rule.pseudonymisieren_nach_monaten,
            retention_rule.rechtsgrundlage
           FROM public.retention_rule
        ), app_faellig AS (
         SELECT a.id,
            ((make_date((EXTRACT(year FROM a.created_at))::integer, 12, 31) + ((r.regelfrist_monate || ' months'::text))::interval))::date AS faellig_am
           FROM (public.app a
             JOIN regel r ON ((r.class = a.retention_class)))
          WHERE (r.fristbeginn = 'ENTSTEHUNGSJAHRESENDE'::public.retention_start)
        )
 SELECT 'app'::text AS objekt,
    (a.id)::text AS objekt_id,
    a.retention_class,
    f.faellig_am,
    NULL::date AS pseudonymisieren_ab
   FROM (public.app a
     JOIN app_faellig f ON ((f.id = a.id)))
UNION ALL
 SELECT 'document'::text AS objekt,
    (d.id)::text AS objekt_id,
        CASE
            WHEN (d.kind = ANY (ARRAY['ORDER'::public.document_kind, 'SBOM'::public.document_kind])) THEN 'HANDELSRECHT'::public.retention_class
            ELSE 'KI_NACHWEIS'::public.retention_class
        END AS retention_class,
    f.faellig_am,
        CASE
            WHEN (d.kind = ANY (ARRAY['ORDER'::public.document_kind, 'SBOM'::public.document_kind])) THEN NULL::date
            ELSE ((f.faellig_am - '8 years'::interval))::date
        END AS pseudonymisieren_ab
   FROM (public.document d
     JOIN app_faellig f ON ((f.id = d.app_id)))
UNION ALL
 SELECT 'event'::text AS objekt,
    (e.id)::text AS objekt_id,
    e.retention_class,
    NULL::date AS faellig_am,
    ((e.occurred_at + ((r.pseudonymisieren_nach_monaten || ' months'::text))::interval))::date AS pseudonymisieren_ab
   FROM (public.event e
     JOIN regel r ON ((r.class = e.retention_class)))
  WHERE (r.fristbeginn = 'ERSTELLUNG'::public.retention_start)
UNION ALL
 SELECT 'direct_prototype'::text AS objekt,
    (p.id)::text AS objekt_id,
    p.retention_class,
    public.frist_ende(p.created_at, r.regelfrist_monate, r.regelfrist_tage) AS faellig_am,
    ((p.created_at + ((r.pseudonymisieren_nach_monaten || ' months'::text))::interval))::date AS pseudonymisieren_ab
   FROM (public.direct_prototype p
     JOIN regel r ON ((r.class = p.retention_class)))
  WHERE (r.fristbeginn = 'ERSTELLUNG'::public.retention_start)
UNION ALL
 SELECT 'fit_check'::text AS objekt,
    (c.id)::text AS objekt_id,
    c.retention_class,
    f.faellig_am,
    ((c.started_at + ((r.pseudonymisieren_nach_monaten || ' months'::text))::interval))::date AS pseudonymisieren_ab
   FROM ((public.fit_check c
     JOIN regel r ON ((r.class = c.retention_class)))
     LEFT JOIN app_faellig f ON ((f.id = c.app_id)))
UNION ALL
 SELECT 'review_run'::text AS objekt,
    (v.id)::text AS objekt_id,
    v.retention_class,
    f.faellig_am,
    ((v.completed_at + ((r.pseudonymisieren_nach_monaten || ' months'::text))::interval))::date AS pseudonymisieren_ab
   FROM ((public.review_run v
     JOIN regel r ON ((r.class = v.retention_class)))
     LEFT JOIN app_faellig f ON ((f.id = v.app_id)))
UNION ALL
 SELECT 'invitation'::text AS objekt,
    (i.id)::text AS objekt_id,
    'KURZFRIST'::public.retention_class AS retention_class,
    public.frist_ende(i.expires_at, r.regelfrist_monate, r.regelfrist_tage) AS faellig_am,
    NULL::date AS pseudonymisieren_ab
   FROM (public.invitation i
     CROSS JOIN regel r)
  WHERE ((i.status <> 'EINGELOEST'::public.invitation_status) AND (i.expires_at < now()))
UNION ALL
 SELECT 'login_code'::text AS objekt,
    (c.id)::text AS objekt_id,
    c.retention_class,
    public.frist_ende(COALESCE(c.consumed_at, c.expires_at), r.regelfrist_monate, r.regelfrist_tage) AS faellig_am,
    NULL::date AS pseudonymisieren_ab
   FROM (public.login_code c
     JOIN regel r ON ((r.class = c.retention_class)))
UNION ALL
 SELECT 'mail_delivery'::text AS objekt,
    (p.id)::text AS objekt_id,
    p.retention_class,
    public.frist_ende(p.sent_at, r.regelfrist_monate, r.regelfrist_tage) AS faellig_am,
    NULL::date AS pseudonymisieren_ab
   FROM (public.mail_delivery p
     JOIN regel r ON ((r.class = p.retention_class)));


ALTER VIEW public.retention_due OWNER TO freiraum;

--
-- Name: review_finding; Type: TABLE; Schema: public; Owner: freiraum
--

CREATE TABLE public.review_finding (
    id uuid DEFAULT gen_random_uuid() NOT NULL,
    review_run_id uuid NOT NULL,
    criterion text NOT NULL,
    severity text NOT NULL,
    finding text NOT NULL,
    source_ref text,
    CONSTRAINT review_finding_severity_check CHECK ((severity = ANY (ARRAY['BLOCKER'::text, 'HINWEIS'::text, 'BESTANDEN'::text])))
);


ALTER TABLE public.review_finding OWNER TO freiraum;

--
-- Name: role; Type: TABLE; Schema: public; Owner: freiraum
--

CREATE TABLE public.role (
    id uuid DEFAULT gen_random_uuid() NOT NULL,
    portal_code public.portal_code NOT NULL,
    name text NOT NULL
);


ALTER TABLE public.role OWNER TO freiraum;

--
-- Name: role_right; Type: TABLE; Schema: public; Owner: freiraum
--

CREATE TABLE public.role_right (
    role_id uuid NOT NULL,
    right_level public.rights_level NOT NULL
);


ALTER TABLE public.role_right OWNER TO freiraum;

--
-- Name: schema_migration; Type: TABLE; Schema: public; Owner: freiraum
--

CREATE TABLE public.schema_migration (
    version text NOT NULL,
    beschreibung text NOT NULL,
    applied_at timestamp with time zone DEFAULT now() NOT NULL
);


ALTER TABLE public.schema_migration OWNER TO freiraum;

--
-- Name: state_transition; Type: TABLE; Schema: public; Owner: freiraum
--

CREATE TABLE public.state_transition (
    from_state public.lifecycle_state NOT NULL,
    to_state public.lifecycle_state NOT NULL,
    authority public.transition_authority NOT NULL,
    bedingung text,
    CONSTRAINT kein_selbstwechsel CHECK ((from_state <> to_state))
);


ALTER TABLE public.state_transition OWNER TO freiraum;

--
-- Name: template; Type: TABLE; Schema: public; Owner: freiraum
--

CREATE TABLE public.template (
    id text NOT NULL,
    grp public.template_group NOT NULL,
    name text NOT NULL
);


ALTER TABLE public.template OWNER TO freiraum;

--
-- Name: template_version; Type: TABLE; Schema: public; Owner: freiraum
--

CREATE TABLE public.template_version (
    template_id text NOT NULL,
    version text NOT NULL,
    status public.lifecycle_status DEFAULT 'DRAFT'::public.lifecycle_status NOT NULL,
    gueltig daterange NOT NULL,
    editor text,
    aenderungsvermerk text,
    erfasst_am timestamp with time zone DEFAULT now() NOT NULL,
    elementbedarf_geprueft_at timestamp with time zone,
    content_ref text,
    content_sha256 text,
    content_media_type text,
    content_size_bytes bigint,
    function_kind public.template_function,
    dialog_mode public.template_dialog_mode,
    result_kind public.template_result_kind,
    status_content public.template_status_content,
    input_density public.template_input_density,
    confirm_density public.template_confirm_density,
    CONSTRAINT tv_merkmale_ganz CHECK (((function_kind IS NULL) OR ((dialog_mode IS NOT NULL) AND (result_kind IS NOT NULL) AND (status_content IS NOT NULL) AND (input_density IS NOT NULL) AND (confirm_density IS NOT NULL)))),
    CONSTRAINT tv_released_braucht_inhalt CHECK (((status <> 'RELEASED'::public.lifecycle_status) OR ((content_ref IS NOT NULL) AND (content_sha256 IS NOT NULL) AND (content_media_type IS NOT NULL) AND (content_size_bytes IS NOT NULL)))),
    CONSTRAINT tv_sha_fmt CHECK (((content_sha256 IS NULL) OR (content_sha256 ~ '^[0-9a-f]{64}$'::text)))
);


ALTER TABLE public.template_version OWNER TO freiraum;

--
-- Name: template_aktuell; Type: VIEW; Schema: public; Owner: freiraum
--

CREATE VIEW public.template_aktuell AS
 SELECT t.id,
    t.grp,
    t.name,
    v.version,
    v.status,
    v.gueltig,
    v.editor,
    v.aenderungsvermerk
   FROM (public.template t
     JOIN public.template_version v ON ((v.template_id = t.id)))
  WHERE (v.gueltig @> CURRENT_DATE);


ALTER VIEW public.template_aktuell OWNER TO freiraum;

--
-- Name: template_element; Type: TABLE; Schema: public; Owner: freiraum
--

CREATE TABLE public.template_element (
    template_id text NOT NULL,
    version text NOT NULL,
    element_template_id text NOT NULL,
    CONSTRAINT element_nicht_selbst CHECK ((element_template_id <> template_id))
);


ALTER TABLE public.template_element OWNER TO freiraum;

--
-- Name: tenant_invite_domain; Type: TABLE; Schema: public; Owner: freiraum
--

CREATE TABLE public.tenant_invite_domain (
    tenant_id uuid NOT NULL,
    domain text NOT NULL,
    created_at timestamp with time zone DEFAULT now() NOT NULL,
    CONSTRAINT invite_domain_form CHECK ((domain ~* '^[a-z0-9]([a-z0-9-]*[a-z0-9])?(\.[a-z0-9]([a-z0-9-]*[a-z0-9])?)+$'::text)),
    CONSTRAINT invite_domain_klein CHECK ((domain = lower(btrim(domain))))
);


ALTER TABLE public.tenant_invite_domain OWNER TO freiraum;

--
-- Name: TABLE tenant_invite_domain; Type: COMMENT; Schema: public; Owner: freiraum
--

COMMENT ON TABLE public.tenant_invite_domain IS 'Zeichnung P3 vom 05.08.2026 (O-K03-12). Die Liste zugelassener Einladungsdomaenen je Mandant. tenant.invite_domain bleibt zunaechst stehen und wird abgeleitet; sie faellt erst, wenn der Serverpfad umgestellt ist -- eine Spalte zu entfernen, deren Leser man nicht kennt, ist keine Migration, sondern ein Versuch.';


--
-- Name: test_harness; Type: TABLE; Schema: public; Owner: freiraum
--

CREATE TABLE public.test_harness (
    app_id uuid NOT NULL,
    filename text NOT NULL
);


ALTER TABLE public.test_harness OWNER TO freiraum;

--
-- Name: actor actor_email_key; Type: CONSTRAINT; Schema: public; Owner: freiraum
--

ALTER TABLE ONLY public.actor
    ADD CONSTRAINT actor_email_key UNIQUE (email);


--
-- Name: actor actor_pkey; Type: CONSTRAINT; Schema: public; Owner: freiraum
--

ALTER TABLE ONLY public.actor
    ADD CONSTRAINT actor_pkey PRIMARY KEY (id);


--
-- Name: actor actor_user_code_key; Type: CONSTRAINT; Schema: public; Owner: freiraum
--

ALTER TABLE ONLY public.actor
    ADD CONSTRAINT actor_user_code_key UNIQUE (user_code);


--
-- Name: agent_knowledge agent_knowledge_pkey; Type: CONSTRAINT; Schema: public; Owner: freiraum
--

ALTER TABLE ONLY public.agent_knowledge
    ADD CONSTRAINT agent_knowledge_pkey PRIMARY KEY (agent_id, module_id);


--
-- Name: agent agent_name_key; Type: CONSTRAINT; Schema: public; Owner: freiraum
--

ALTER TABLE ONLY public.agent
    ADD CONSTRAINT agent_name_key UNIQUE (name);


--
-- Name: agent agent_pkey; Type: CONSTRAINT; Schema: public; Owner: freiraum
--

ALTER TABLE ONLY public.agent
    ADD CONSTRAINT agent_pkey PRIMARY KEY (id);


--
-- Name: agent_policy agent_policy_pkey; Type: CONSTRAINT; Schema: public; Owner: freiraum
--

ALTER TABLE ONLY public.agent_policy
    ADD CONSTRAINT agent_policy_pkey PRIMARY KEY (agent_id, policy_id);


--
-- Name: agent_template agent_template_pkey; Type: CONSTRAINT; Schema: public; Owner: freiraum
--

ALTER TABLE ONLY public.agent_template
    ADD CONSTRAINT agent_template_pkey PRIMARY KEY (agent_id, template_id);


--
-- Name: app app_pkey; Type: CONSTRAINT; Schema: public; Owner: freiraum
--

ALTER TABLE ONLY public.app
    ADD CONSTRAINT app_pkey PRIMARY KEY (id);


--
-- Name: app app_project_no_key; Type: CONSTRAINT; Schema: public; Owner: freiraum
--

ALTER TABLE ONLY public.app
    ADD CONSTRAINT app_project_no_key UNIQUE (project_no);


--
-- Name: app_state_history app_state_history_app_id_gueltig_excl; Type: CONSTRAINT; Schema: public; Owner: freiraum
--

ALTER TABLE ONLY public.app_state_history
    ADD CONSTRAINT app_state_history_app_id_gueltig_excl EXCLUDE USING gist (app_id WITH =, gueltig WITH &&);


--
-- Name: app_state_history app_state_history_pkey; Type: CONSTRAINT; Schema: public; Owner: freiraum
--

ALTER TABLE ONLY public.app_state_history
    ADD CONSTRAINT app_state_history_pkey PRIMARY KEY (app_id, gueltig);


--
-- Name: approval approval_pkey; Type: CONSTRAINT; Schema: public; Owner: freiraum
--

ALTER TABLE ONLY public.approval
    ADD CONSTRAINT approval_pkey PRIMARY KEY (id);


--
-- Name: auth_session auth_session_pkey; Type: CONSTRAINT; Schema: public; Owner: freiraum
--

ALTER TABLE ONLY public.auth_session
    ADD CONSTRAINT auth_session_pkey PRIMARY KEY (id);


--
-- Name: contact contact_pkey; Type: CONSTRAINT; Schema: public; Owner: freiraum
--

ALTER TABLE ONLY public.contact
    ADD CONSTRAINT contact_pkey PRIMARY KEY (id);


--
-- Name: contact contact_tenant_id_position_key; Type: CONSTRAINT; Schema: public; Owner: freiraum
--

ALTER TABLE ONLY public.contact
    ADD CONSTRAINT contact_tenant_id_position_key UNIQUE (tenant_id, "position");


--
-- Name: contract_check contract_check_pkey; Type: CONSTRAINT; Schema: public; Owner: freiraum
--

ALTER TABLE ONLY public.contract_check
    ADD CONSTRAINT contract_check_pkey PRIMARY KEY (id);


--
-- Name: direct_prototype direct_prototype_pkey; Type: CONSTRAINT; Schema: public; Owner: freiraum
--

ALTER TABLE ONLY public.direct_prototype
    ADD CONSTRAINT direct_prototype_pkey PRIMARY KEY (id);


--
-- Name: document document_pkey; Type: CONSTRAINT; Schema: public; Owner: freiraum
--

ALTER TABLE ONLY public.document
    ADD CONSTRAINT document_pkey PRIMARY KEY (id);


--
-- Name: document_version document_version_document_id_gueltig_excl; Type: CONSTRAINT; Schema: public; Owner: freiraum
--

ALTER TABLE ONLY public.document_version
    ADD CONSTRAINT document_version_document_id_gueltig_excl EXCLUDE USING gist (document_id WITH =, gueltig WITH &&);


--
-- Name: document_version document_version_pkey; Type: CONSTRAINT; Schema: public; Owner: freiraum
--

ALTER TABLE ONLY public.document_version
    ADD CONSTRAINT document_version_pkey PRIMARY KEY (document_id, version);


--
-- Name: event event_pkey; Type: CONSTRAINT; Schema: public; Owner: freiraum
--

ALTER TABLE ONLY public.event
    ADD CONSTRAINT event_pkey PRIMARY KEY (id);


--
-- Name: fit_answer fit_answer_pkey; Type: CONSTRAINT; Schema: public; Owner: freiraum
--

ALTER TABLE ONLY public.fit_answer
    ADD CONSTRAINT fit_answer_pkey PRIMARY KEY (fit_check_id, question_code, option_id);


--
-- Name: fit_check fit_check_pkey; Type: CONSTRAINT; Schema: public; Owner: freiraum
--

ALTER TABLE ONLY public.fit_check
    ADD CONSTRAINT fit_check_pkey PRIMARY KEY (id);


--
-- Name: fit_option fit_option_pkey; Type: CONSTRAINT; Schema: public; Owner: freiraum
--

ALTER TABLE ONLY public.fit_option
    ADD CONSTRAINT fit_option_pkey PRIMARY KEY (id);


--
-- Name: fit_option fit_option_question_code_position_key; Type: CONSTRAINT; Schema: public; Owner: freiraum
--

ALTER TABLE ONLY public.fit_option
    ADD CONSTRAINT fit_option_question_code_position_key UNIQUE (question_code, "position");


--
-- Name: fit_option fit_option_question_code_value_token_key; Type: CONSTRAINT; Schema: public; Owner: freiraum
--

ALTER TABLE ONLY public.fit_option
    ADD CONSTRAINT fit_option_question_code_value_token_key UNIQUE (question_code, value_token);


--
-- Name: fit_question fit_question_dimension_key; Type: CONSTRAINT; Schema: public; Owner: freiraum
--

ALTER TABLE ONLY public.fit_question
    ADD CONSTRAINT fit_question_dimension_key UNIQUE (dimension);


--
-- Name: fit_question fit_question_pkey; Type: CONSTRAINT; Schema: public; Owner: freiraum
--

ALTER TABLE ONLY public.fit_question
    ADD CONSTRAINT fit_question_pkey PRIMARY KEY (code);


--
-- Name: fit_question fit_question_position_key; Type: CONSTRAINT; Schema: public; Owner: freiraum
--

ALTER TABLE ONLY public.fit_question
    ADD CONSTRAINT fit_question_position_key UNIQUE ("position");


--
-- Name: invitation_decision invitation_decision_pkey; Type: CONSTRAINT; Schema: public; Owner: freiraum
--

ALTER TABLE ONLY public.invitation_decision
    ADD CONSTRAINT invitation_decision_pkey PRIMARY KEY (id);


--
-- Name: invitation invitation_pkey; Type: CONSTRAINT; Schema: public; Owner: freiraum
--

ALTER TABLE ONLY public.invitation
    ADD CONSTRAINT invitation_pkey PRIMARY KEY (id);


--
-- Name: knowledge_module knowledge_module_pkey; Type: CONSTRAINT; Schema: public; Owner: freiraum
--

ALTER TABLE ONLY public.knowledge_module
    ADD CONSTRAINT knowledge_module_pkey PRIMARY KEY (id);


--
-- Name: knowledge_module_source knowledge_module_source_pkey; Type: CONSTRAINT; Schema: public; Owner: freiraum
--

ALTER TABLE ONLY public.knowledge_module_source
    ADD CONSTRAINT knowledge_module_source_pkey PRIMARY KEY (module_id, source_id);


--
-- Name: knowledge_module_version knowledge_module_version_module_id_gueltig_excl; Type: CONSTRAINT; Schema: public; Owner: freiraum
--

ALTER TABLE ONLY public.knowledge_module_version
    ADD CONSTRAINT knowledge_module_version_module_id_gueltig_excl EXCLUDE USING gist (module_id WITH =, gueltig WITH &&);


--
-- Name: knowledge_module_version knowledge_module_version_pkey; Type: CONSTRAINT; Schema: public; Owner: freiraum
--

ALTER TABLE ONLY public.knowledge_module_version
    ADD CONSTRAINT knowledge_module_version_pkey PRIMARY KEY (module_id, version);


--
-- Name: knowledge_source knowledge_source_pkey; Type: CONSTRAINT; Schema: public; Owner: freiraum
--

ALTER TABLE ONLY public.knowledge_source
    ADD CONSTRAINT knowledge_source_pkey PRIMARY KEY (id);


--
-- Name: knowledge_source knowledge_source_register_no_key; Type: CONSTRAINT; Schema: public; Owner: freiraum
--

ALTER TABLE ONLY public.knowledge_source
    ADD CONSTRAINT knowledge_source_register_no_key UNIQUE (register_no);


--
-- Name: lifecycle_state_label lifecycle_state_label_pkey; Type: CONSTRAINT; Schema: public; Owner: freiraum
--

ALTER TABLE ONLY public.lifecycle_state_label
    ADD CONSTRAINT lifecycle_state_label_pkey PRIMARY KEY (state, locale);


--
-- Name: login_attempt login_attempt_pkey; Type: CONSTRAINT; Schema: public; Owner: freiraum
--

ALTER TABLE ONLY public.login_attempt
    ADD CONSTRAINT login_attempt_pkey PRIMARY KEY (id);


--
-- Name: login_code login_code_pkey; Type: CONSTRAINT; Schema: public; Owner: freiraum
--

ALTER TABLE ONLY public.login_code
    ADD CONSTRAINT login_code_pkey PRIMARY KEY (id);


--
-- Name: mail_delivery mail_delivery_pkey; Type: CONSTRAINT; Schema: public; Owner: freiraum
--

ALTER TABLE ONLY public.mail_delivery
    ADD CONSTRAINT mail_delivery_pkey PRIMARY KEY (id);


--
-- Name: membership membership_pkey; Type: CONSTRAINT; Schema: public; Owner: freiraum
--

ALTER TABLE ONLY public.membership
    ADD CONSTRAINT membership_pkey PRIMARY KEY (actor_id, portal_code, role_id, tenant_scope);


--
-- Name: model_manifest model_manifest_pkey; Type: CONSTRAINT; Schema: public; Owner: freiraum
--

ALTER TABLE ONLY public.model_manifest
    ADD CONSTRAINT model_manifest_pkey PRIMARY KEY (id);


--
-- Name: model_manifest_version model_manifest_version_manifest_id_gueltig_excl; Type: CONSTRAINT; Schema: public; Owner: freiraum
--

ALTER TABLE ONLY public.model_manifest_version
    ADD CONSTRAINT model_manifest_version_manifest_id_gueltig_excl EXCLUDE USING gist (manifest_id WITH =, gueltig WITH &&);


--
-- Name: model_manifest_version model_manifest_version_pkey; Type: CONSTRAINT; Schema: public; Owner: freiraum
--

ALTER TABLE ONLY public.model_manifest_version
    ADD CONSTRAINT model_manifest_version_pkey PRIMARY KEY (manifest_id, version);


--
-- Name: model_ref model_ref_pkey; Type: CONSTRAINT; Schema: public; Owner: freiraum
--

ALTER TABLE ONLY public.model_ref
    ADD CONSTRAINT model_ref_pkey PRIMARY KEY (id);


--
-- Name: model_ref model_ref_provider_model_version_hosting_key; Type: CONSTRAINT; Schema: public; Owner: freiraum
--

ALTER TABLE ONLY public.model_ref
    ADD CONSTRAINT model_ref_provider_model_version_hosting_key UNIQUE (provider, model, version, hosting);


--
-- Name: model_ref model_ref_token_key; Type: CONSTRAINT; Schema: public; Owner: freiraum
--

ALTER TABLE ONLY public.model_ref
    ADD CONSTRAINT model_ref_token_key UNIQUE (token);


--
-- Name: module module_internal_key_key; Type: CONSTRAINT; Schema: public; Owner: freiraum
--

ALTER TABLE ONLY public.module
    ADD CONSTRAINT module_internal_key_key UNIQUE (internal_key);


--
-- Name: module module_pkey; Type: CONSTRAINT; Schema: public; Owner: freiraum
--

ALTER TABLE ONLY public.module
    ADD CONSTRAINT module_pkey PRIMARY KEY (display_code);


--
-- Name: nummernvorrat nummernvorrat_pkey; Type: CONSTRAINT; Schema: public; Owner: freiraum
--

ALTER TABLE ONLY public.nummernvorrat
    ADD CONSTRAINT nummernvorrat_pkey PRIMARY KEY (praefix);


--
-- Name: policy policy_pkey; Type: CONSTRAINT; Schema: public; Owner: freiraum
--

ALTER TABLE ONLY public.policy
    ADD CONSTRAINT policy_pkey PRIMARY KEY (id);


--
-- Name: policy_version policy_version_pkey; Type: CONSTRAINT; Schema: public; Owner: freiraum
--

ALTER TABLE ONLY public.policy_version
    ADD CONSTRAINT policy_version_pkey PRIMARY KEY (policy_id, version);


--
-- Name: policy_version policy_version_policy_id_gueltig_excl; Type: CONSTRAINT; Schema: public; Owner: freiraum
--

ALTER TABLE ONLY public.policy_version
    ADD CONSTRAINT policy_version_policy_id_gueltig_excl EXCLUDE USING gist (policy_id WITH =, gueltig WITH &&);


--
-- Name: portal portal_pkey; Type: CONSTRAINT; Schema: public; Owner: freiraum
--

ALTER TABLE ONLY public.portal
    ADD CONSTRAINT portal_pkey PRIMARY KEY (code);


--
-- Name: project_contract project_contract_app_id_gueltig_excl; Type: CONSTRAINT; Schema: public; Owner: freiraum
--

ALTER TABLE ONLY public.project_contract
    ADD CONSTRAINT project_contract_app_id_gueltig_excl EXCLUDE USING gist (app_id WITH =, gueltig WITH &&);


--
-- Name: project_contract project_contract_pkey; Type: CONSTRAINT; Schema: public; Owner: freiraum
--

ALTER TABLE ONLY public.project_contract
    ADD CONSTRAINT project_contract_pkey PRIMARY KEY (app_id, version);


--
-- Name: quick_answer quick_answer_pkey; Type: CONSTRAINT; Schema: public; Owner: freiraum
--

ALTER TABLE ONLY public.quick_answer
    ADD CONSTRAINT quick_answer_pkey PRIMARY KEY (quick_check_id, question_code, version, option_pos);


--
-- Name: quick_check quick_check_pkey; Type: CONSTRAINT; Schema: public; Owner: freiraum
--

ALTER TABLE ONLY public.quick_check
    ADD CONSTRAINT quick_check_pkey PRIMARY KEY (id);


--
-- Name: quick_option quick_option_pkey; Type: CONSTRAINT; Schema: public; Owner: freiraum
--

ALTER TABLE ONLY public.quick_option
    ADD CONSTRAINT quick_option_pkey PRIMARY KEY (question_code, version, "position");


--
-- Name: quick_option quick_option_question_code_version_value_token_key; Type: CONSTRAINT; Schema: public; Owner: freiraum
--

ALTER TABLE ONLY public.quick_option
    ADD CONSTRAINT quick_option_question_code_version_value_token_key UNIQUE (question_code, version, value_token);


--
-- Name: quick_question quick_question_pkey; Type: CONSTRAINT; Schema: public; Owner: freiraum
--

ALTER TABLE ONLY public.quick_question
    ADD CONSTRAINT quick_question_pkey PRIMARY KEY (code);


--
-- Name: quick_question quick_question_position_key; Type: CONSTRAINT; Schema: public; Owner: freiraum
--

ALTER TABLE ONLY public.quick_question
    ADD CONSTRAINT quick_question_position_key UNIQUE ("position");


--
-- Name: quick_question_version quick_question_version_pkey; Type: CONSTRAINT; Schema: public; Owner: freiraum
--

ALTER TABLE ONLY public.quick_question_version
    ADD CONSTRAINT quick_question_version_pkey PRIMARY KEY (question_code, version);


--
-- Name: quick_question_version quick_question_version_question_code_gueltig_excl; Type: CONSTRAINT; Schema: public; Owner: freiraum
--

ALTER TABLE ONLY public.quick_question_version
    ADD CONSTRAINT quick_question_version_question_code_gueltig_excl EXCLUDE USING gist (question_code WITH =, gueltig WITH &&);


--
-- Name: retention_rule retention_rule_pkey; Type: CONSTRAINT; Schema: public; Owner: freiraum
--

ALTER TABLE ONLY public.retention_rule
    ADD CONSTRAINT retention_rule_pkey PRIMARY KEY (class);


--
-- Name: review_finding review_finding_pkey; Type: CONSTRAINT; Schema: public; Owner: freiraum
--

ALTER TABLE ONLY public.review_finding
    ADD CONSTRAINT review_finding_pkey PRIMARY KEY (id);


--
-- Name: review_run review_run_app_id_artifact_version_round_key; Type: CONSTRAINT; Schema: public; Owner: freiraum
--

ALTER TABLE ONLY public.review_run
    ADD CONSTRAINT review_run_app_id_artifact_version_round_key UNIQUE (app_id, artifact_version, round);


--
-- Name: review_run review_run_pkey; Type: CONSTRAINT; Schema: public; Owner: freiraum
--

ALTER TABLE ONLY public.review_run
    ADD CONSTRAINT review_run_pkey PRIMARY KEY (id);


--
-- Name: role role_pkey; Type: CONSTRAINT; Schema: public; Owner: freiraum
--

ALTER TABLE ONLY public.role
    ADD CONSTRAINT role_pkey PRIMARY KEY (id);


--
-- Name: role role_portal_code_name_key; Type: CONSTRAINT; Schema: public; Owner: freiraum
--

ALTER TABLE ONLY public.role
    ADD CONSTRAINT role_portal_code_name_key UNIQUE (portal_code, name);


--
-- Name: role_right role_right_pkey; Type: CONSTRAINT; Schema: public; Owner: freiraum
--

ALTER TABLE ONLY public.role_right
    ADD CONSTRAINT role_right_pkey PRIMARY KEY (role_id, right_level);


--
-- Name: schema_migration schema_migration_pkey; Type: CONSTRAINT; Schema: public; Owner: freiraum
--

ALTER TABLE ONLY public.schema_migration
    ADD CONSTRAINT schema_migration_pkey PRIMARY KEY (version);


--
-- Name: state_transition state_transition_pkey; Type: CONSTRAINT; Schema: public; Owner: freiraum
--

ALTER TABLE ONLY public.state_transition
    ADD CONSTRAINT state_transition_pkey PRIMARY KEY (from_state, to_state);


--
-- Name: template_element template_element_pkey; Type: CONSTRAINT; Schema: public; Owner: freiraum
--

ALTER TABLE ONLY public.template_element
    ADD CONSTRAINT template_element_pkey PRIMARY KEY (template_id, version, element_template_id);


--
-- Name: template template_pkey; Type: CONSTRAINT; Schema: public; Owner: freiraum
--

ALTER TABLE ONLY public.template
    ADD CONSTRAINT template_pkey PRIMARY KEY (id);


--
-- Name: template_version template_version_pkey; Type: CONSTRAINT; Schema: public; Owner: freiraum
--

ALTER TABLE ONLY public.template_version
    ADD CONSTRAINT template_version_pkey PRIMARY KEY (template_id, version);


--
-- Name: template_version template_version_template_id_gueltig_excl; Type: CONSTRAINT; Schema: public; Owner: freiraum
--

ALTER TABLE ONLY public.template_version
    ADD CONSTRAINT template_version_template_id_gueltig_excl EXCLUDE USING gist (template_id WITH =, gueltig WITH &&);


--
-- Name: tenant tenant_customer_code_key; Type: CONSTRAINT; Schema: public; Owner: freiraum
--

ALTER TABLE ONLY public.tenant
    ADD CONSTRAINT tenant_customer_code_key UNIQUE (customer_code);


--
-- Name: tenant_invite_domain tenant_invite_domain_pkey; Type: CONSTRAINT; Schema: public; Owner: freiraum
--

ALTER TABLE ONLY public.tenant_invite_domain
    ADD CONSTRAINT tenant_invite_domain_pkey PRIMARY KEY (tenant_id, domain);


--
-- Name: tenant tenant_pkey; Type: CONSTRAINT; Schema: public; Owner: freiraum
--

ALTER TABLE ONLY public.tenant
    ADD CONSTRAINT tenant_pkey PRIMARY KEY (id);


--
-- Name: test_harness test_harness_pkey; Type: CONSTRAINT; Schema: public; Owner: freiraum
--

ALTER TABLE ONLY public.test_harness
    ADD CONSTRAINT test_harness_pkey PRIMARY KEY (app_id);


--
-- Name: actor_ausnahmekonto_uq; Type: INDEX; Schema: public; Owner: freiraum
--

CREATE UNIQUE INDEX actor_ausnahmekonto_uq ON public.actor USING btree ((true)) WHERE (mfa_method = 'OFF'::public.mfa_method);


--
-- Name: actor_tenant_idx; Type: INDEX; Schema: public; Owner: freiraum
--

CREATE INDEX actor_tenant_idx ON public.actor USING btree (tenant_id);


--
-- Name: agent_knowledge_module_idx; Type: INDEX; Schema: public; Owner: freiraum
--

CREATE INDEX agent_knowledge_module_idx ON public.agent_knowledge USING btree (module_id);


--
-- Name: app_fit_check_idx; Type: INDEX; Schema: public; Owner: freiraum
--

CREATE INDEX app_fit_check_idx ON public.app USING btree (fit_check_id);


--
-- Name: app_tenant_idx; Type: INDEX; Schema: public; Owner: freiraum
--

CREATE INDEX app_tenant_idx ON public.app USING btree (tenant_id);


--
-- Name: approval_approver_idx; Type: INDEX; Schema: public; Owner: freiraum
--

CREATE INDEX approval_approver_idx ON public.approval USING btree (approver_actor_id);


--
-- Name: approval_editor_idx; Type: INDEX; Schema: public; Owner: freiraum
--

CREATE INDEX approval_editor_idx ON public.approval USING btree (editor_actor_id);


--
-- Name: auth_session_actor_idx; Type: INDEX; Schema: public; Owner: freiraum
--

CREATE INDEX auth_session_actor_idx ON public.auth_session USING btree (actor_id);


--
-- Name: contact_tenant_mail_uq; Type: INDEX; Schema: public; Owner: freiraum
--

CREATE UNIQUE INDEX contact_tenant_mail_uq ON public.contact USING btree (tenant_id, lower(mail)) WHERE (mail IS NOT NULL);


--
-- Name: direct_prototype_actor_idx; Type: INDEX; Schema: public; Owner: freiraum
--

CREATE INDEX direct_prototype_actor_idx ON public.direct_prototype USING btree (actor_id);


--
-- Name: direct_prototype_tenant_idx; Type: INDEX; Schema: public; Owner: freiraum
--

CREATE INDEX direct_prototype_tenant_idx ON public.direct_prototype USING btree (tenant_id);


--
-- Name: document_app_idx; Type: INDEX; Schema: public; Owner: freiraum
--

CREATE INDEX document_app_idx ON public.document USING btree (app_id);


--
-- Name: event_actor_idx; Type: INDEX; Schema: public; Owner: freiraum
--

CREATE INDEX event_actor_idx ON public.event USING btree (actor_id);


--
-- Name: event_project_idx; Type: INDEX; Schema: public; Owner: freiraum
--

CREATE INDEX event_project_idx ON public.event USING btree (project_no);


--
-- Name: event_tenant_idx; Type: INDEX; Schema: public; Owner: freiraum
--

CREATE INDEX event_tenant_idx ON public.event USING btree (tenant_id);


--
-- Name: fit_answer_aktiv_uq; Type: INDEX; Schema: public; Owner: freiraum
--

CREATE UNIQUE INDEX fit_answer_aktiv_uq ON public.fit_answer USING btree (fit_check_id, question_code) WHERE (superseded_at IS NULL);


--
-- Name: fit_answer_option_idx; Type: INDEX; Schema: public; Owner: freiraum
--

CREATE INDEX fit_answer_option_idx ON public.fit_answer USING btree (option_id);


--
-- Name: fit_answer_question_idx; Type: INDEX; Schema: public; Owner: freiraum
--

CREATE INDEX fit_answer_question_idx ON public.fit_answer USING btree (question_code);


--
-- Name: fit_check_actor_idx; Type: INDEX; Schema: public; Owner: freiraum
--

CREATE INDEX fit_check_actor_idx ON public.fit_check USING btree (actor_id);


--
-- Name: fit_check_app_idx; Type: INDEX; Schema: public; Owner: freiraum
--

CREATE INDEX fit_check_app_idx ON public.fit_check USING btree (app_id);


--
-- Name: fit_check_tenant_idx; Type: INDEX; Schema: public; Owner: freiraum
--

CREATE INDEX fit_check_tenant_idx ON public.fit_check USING btree (tenant_id);


--
-- Name: invitation_actor_idx; Type: INDEX; Schema: public; Owner: freiraum
--

CREATE INDEX invitation_actor_idx ON public.invitation USING btree (actor_id);


--
-- Name: invitation_offen_uq; Type: INDEX; Schema: public; Owner: freiraum
--

CREATE UNIQUE INDEX invitation_offen_uq ON public.invitation USING btree (actor_id) WHERE (status = 'VERSANDT'::public.invitation_status);


--
-- Name: knowledge_module_source_src_idx; Type: INDEX; Schema: public; Owner: freiraum
--

CREATE INDEX knowledge_module_source_src_idx ON public.knowledge_module_source USING btree (source_id);


--
-- Name: login_attempt_email_idx; Type: INDEX; Schema: public; Owner: freiraum
--

CREATE INDEX login_attempt_email_idx ON public.login_attempt USING btree (email, attempted_at);


--
-- Name: login_attempt_origin_idx; Type: INDEX; Schema: public; Owner: freiraum
--

CREATE INDEX login_attempt_origin_idx ON public.login_attempt USING btree (origin_hash, attempted_at);


--
-- Name: login_code_actor_idx; Type: INDEX; Schema: public; Owner: freiraum
--

CREATE INDEX login_code_actor_idx ON public.login_code USING btree (actor_id, issued_at DESC);


--
-- Name: login_code_nur_einer_offen; Type: INDEX; Schema: public; Owner: freiraum
--

CREATE UNIQUE INDEX login_code_nur_einer_offen ON public.login_code USING btree (actor_id) WHERE ((consumed_at IS NULL) AND (superseded_at IS NULL));


--
-- Name: mail_delivery_actor_idx; Type: INDEX; Schema: public; Owner: freiraum
--

CREATE INDEX mail_delivery_actor_idx ON public.mail_delivery USING btree (actor_id, sent_at DESC);


--
-- Name: membership_role_idx; Type: INDEX; Schema: public; Owner: freiraum
--

CREATE INDEX membership_role_idx ON public.membership USING btree (role_id);


--
-- Name: membership_tenant_scope_idx; Type: INDEX; Schema: public; Owner: freiraum
--

CREATE INDEX membership_tenant_scope_idx ON public.membership USING btree (tenant_scope);


--
-- Name: review_finding_run_idx; Type: INDEX; Schema: public; Owner: freiraum
--

CREATE INDEX review_finding_run_idx ON public.review_finding USING btree (review_run_id);


--
-- Name: review_run_model_idx; Type: INDEX; Schema: public; Owner: freiraum
--

CREATE INDEX review_run_model_idx ON public.review_run USING btree (model_ref_id);


--
-- Name: review_run_rubric_idx; Type: INDEX; Schema: public; Owner: freiraum
--

CREATE INDEX review_run_rubric_idx ON public.review_run USING btree (rubric_module_id);


--
-- Name: actor actor_platform_admin_guard; Type: TRIGGER; Schema: public; Owner: freiraum
--

CREATE TRIGGER actor_platform_admin_guard AFTER DELETE OR UPDATE ON public.actor FOR EACH STATEMENT EXECUTE FUNCTION public.platform_admin_guard();


--
-- Name: actor actor_sealed_guard; Type: TRIGGER; Schema: public; Owner: freiraum
--

CREATE TRIGGER actor_sealed_guard BEFORE DELETE ON public.actor FOR EACH ROW EXECUTE FUNCTION public.sealed_actor_guard();


--
-- Name: actor actor_sealed_irreversible; Type: TRIGGER; Schema: public; Owner: freiraum
--

CREATE TRIGGER actor_sealed_irreversible BEFORE UPDATE OF sealed ON public.actor FOR EACH ROW EXECUTE FUNCTION public.sealed_irreversible_guard();


--
-- Name: agent agent_release_guard_trg; Type: TRIGGER; Schema: public; Owner: freiraum
--

CREATE TRIGGER agent_release_guard_trg BEFORE INSERT OR UPDATE OF status ON public.agent FOR EACH ROW EXECUTE FUNCTION public.agent_release_guard();


--
-- Name: app app_auswahlvermerk_guard; Type: TRIGGER; Schema: public; Owner: freiraum
--

CREATE TRIGGER app_auswahlvermerk_guard BEFORE UPDATE ON public.app FOR EACH ROW EXECUTE FUNCTION public.auswahlvermerk_guard();


--
-- Name: app app_lifecycle_transition_guard; Type: TRIGGER; Schema: public; Owner: freiraum
--

CREATE TRIGGER app_lifecycle_transition_guard BEFORE INSERT OR UPDATE OF lifecycle_state ON public.app FOR EACH ROW EXECUTE FUNCTION public.lifecycle_transition_guard();


--
-- Name: app app_state_history_sync_trg; Type: TRIGGER; Schema: public; Owner: freiraum
--

CREATE TRIGGER app_state_history_sync_trg AFTER INSERT OR UPDATE OF lifecycle_state ON public.app FOR EACH ROW EXECUTE FUNCTION public.app_state_history_sync();


--
-- Name: approval approval_bezug_guard_trg; Type: TRIGGER; Schema: public; Owner: freiraum
--

CREATE TRIGGER approval_bezug_guard_trg BEFORE INSERT ON public.approval FOR EACH ROW EXECUTE FUNCTION public.approval_bezug_guard();


--
-- Name: approval approval_mandant_guard_trg; Type: TRIGGER; Schema: public; Owner: freiraum
--

CREATE TRIGGER approval_mandant_guard_trg BEFORE INSERT ON public.approval FOR EACH ROW EXECUTE FUNCTION public.approval_mandant_guard();


--
-- Name: approval approval_unveraenderlich; Type: TRIGGER; Schema: public; Owner: freiraum
--

CREATE TRIGGER approval_unveraenderlich BEFORE DELETE OR UPDATE ON public.approval FOR EACH ROW EXECUTE FUNCTION public.append_only_guard();


--
-- Name: auth_session auth_session_event_trg; Type: TRIGGER; Schema: public; Owner: freiraum
--

CREATE TRIGGER auth_session_event_trg AFTER INSERT ON public.auth_session FOR EACH ROW EXECUTE FUNCTION public.session_event_writer();


--
-- Name: document_version document_version_unveraenderlich_trg; Type: TRIGGER; Schema: public; Owner: freiraum
--

CREATE TRIGGER document_version_unveraenderlich_trg BEFORE UPDATE ON public.document_version FOR EACH ROW EXECUTE FUNCTION public.document_version_unveraenderlich();


--
-- Name: app einschraenkung_unumkehrbar_trg; Type: TRIGGER; Schema: public; Owner: freiraum
--

CREATE TRIGGER einschraenkung_unumkehrbar_trg BEFORE UPDATE OF einschraenkung_ab ON public.app FOR EACH ROW EXECUTE FUNCTION public.einschraenkung_unumkehrbar();


--
-- Name: template_element element_ist_elementvorlage_trg; Type: TRIGGER; Schema: public; Owner: freiraum
--

CREATE TRIGGER element_ist_elementvorlage_trg BEFORE INSERT OR UPDATE ON public.template_element FOR EACH ROW EXECUTE FUNCTION public.element_ist_elementvorlage();


--
-- Name: event event_append_only; Type: TRIGGER; Schema: public; Owner: freiraum
--

CREATE TRIGGER event_append_only BEFORE DELETE OR UPDATE ON public.event FOR EACH ROW EXECUTE FUNCTION public.append_only_guard();


--
-- Name: invitation_decision invitation_decision_append_only; Type: TRIGGER; Schema: public; Owner: freiraum
--

CREATE TRIGGER invitation_decision_append_only BEFORE DELETE OR UPDATE ON public.invitation_decision FOR EACH ROW EXECUTE FUNCTION public.append_only_guard();


--
-- Name: invitation invitation_guard_trg; Type: TRIGGER; Schema: public; Owner: freiraum
--

CREATE TRIGGER invitation_guard_trg BEFORE INSERT OR UPDATE ON public.invitation FOR EACH ROW EXECUTE FUNCTION public.invitation_guard();


--
-- Name: login_attempt login_attempt_guard_trg; Type: TRIGGER; Schema: public; Owner: freiraum
--

CREATE TRIGGER login_attempt_guard_trg BEFORE INSERT ON public.login_attempt FOR EACH ROW EXECUTE FUNCTION public.login_attempt_guard();


--
-- Name: login_attempt login_attempt_koppelt_code_trg; Type: TRIGGER; Schema: public; Owner: freiraum
--

CREATE TRIGGER login_attempt_koppelt_code_trg AFTER INSERT ON public.login_attempt FOR EACH ROW EXECUTE FUNCTION public.login_attempt_koppelt_code();


--
-- Name: login_code login_code_entwertet_aeltere_trg; Type: TRIGGER; Schema: public; Owner: freiraum
--

CREATE TRIGGER login_code_entwertet_aeltere_trg BEFORE INSERT ON public.login_code FOR EACH ROW EXECUTE FUNCTION public.login_code_entwertet_aeltere();


--
-- Name: mail_delivery mail_delivery_append_only; Type: TRIGGER; Schema: public; Owner: freiraum
--

CREATE TRIGGER mail_delivery_append_only BEFORE DELETE OR UPDATE ON public.mail_delivery FOR EACH ROW EXECUTE FUNCTION public.append_only_guard();


--
-- Name: membership membership_platform_admin_guard; Type: TRIGGER; Schema: public; Owner: freiraum
--

CREATE TRIGGER membership_platform_admin_guard AFTER DELETE OR UPDATE ON public.membership FOR EACH STATEMENT EXECUTE FUNCTION public.platform_admin_guard();


--
-- Name: policy_version policy_version_body_guard; Type: TRIGGER; Schema: public; Owner: freiraum
--

CREATE TRIGGER policy_version_body_guard BEFORE UPDATE ON public.policy_version FOR EACH ROW EXECUTE FUNCTION public.policy_body_immutable();


--
-- Name: knowledge_source register_no_unveraenderlich_trg; Type: TRIGGER; Schema: public; Owner: freiraum
--

CREATE TRIGGER register_no_unveraenderlich_trg BEFORE UPDATE OF register_no ON public.knowledge_source FOR EACH ROW EXECUTE FUNCTION public.register_no_unveraenderlich();


--
-- Name: template_version template_art_bleibt_trg; Type: TRIGGER; Schema: public; Owner: freiraum
--

CREATE TRIGGER template_art_bleibt_trg BEFORE INSERT OR UPDATE OF function_kind ON public.template_version FOR EACH ROW EXECUTE FUNCTION public.template_art_bleibt();


--
-- Name: tenant tenant_domain_audit_trg; Type: TRIGGER; Schema: public; Owner: freiraum
--

CREATE TRIGGER tenant_domain_audit_trg BEFORE UPDATE OF invite_domain ON public.tenant FOR EACH ROW EXECUTE FUNCTION public.tenant_domain_audit();


--
-- Name: tenant_invite_domain tenant_invite_domain_audit_trg; Type: TRIGGER; Schema: public; Owner: freiraum
--

CREATE TRIGGER tenant_invite_domain_audit_trg AFTER INSERT OR DELETE ON public.tenant_invite_domain FOR EACH ROW EXECUTE FUNCTION public.tenant_invite_domain_audit();


--
-- Name: actor actor_tenant_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: freiraum
--

ALTER TABLE ONLY public.actor
    ADD CONSTRAINT actor_tenant_id_fkey FOREIGN KEY (tenant_id) REFERENCES public.tenant(id) ON DELETE RESTRICT;


--
-- Name: agent_knowledge agent_knowledge_agent_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: freiraum
--

ALTER TABLE ONLY public.agent_knowledge
    ADD CONSTRAINT agent_knowledge_agent_id_fkey FOREIGN KEY (agent_id) REFERENCES public.agent(id) ON DELETE CASCADE;


--
-- Name: agent_knowledge agent_knowledge_module_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: freiraum
--

ALTER TABLE ONLY public.agent_knowledge
    ADD CONSTRAINT agent_knowledge_module_id_fkey FOREIGN KEY (module_id) REFERENCES public.knowledge_module(id) ON DELETE RESTRICT;


--
-- Name: agent agent_model_ref_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: freiraum
--

ALTER TABLE ONLY public.agent
    ADD CONSTRAINT agent_model_ref_id_fkey FOREIGN KEY (model_ref_id) REFERENCES public.model_ref(id) ON DELETE RESTRICT;


--
-- Name: agent_policy agent_policy_agent_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: freiraum
--

ALTER TABLE ONLY public.agent_policy
    ADD CONSTRAINT agent_policy_agent_id_fkey FOREIGN KEY (agent_id) REFERENCES public.agent(id) ON DELETE CASCADE;


--
-- Name: agent_policy agent_policy_policy_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: freiraum
--

ALTER TABLE ONLY public.agent_policy
    ADD CONSTRAINT agent_policy_policy_id_fkey FOREIGN KEY (policy_id) REFERENCES public.policy(id) ON DELETE RESTRICT;


--
-- Name: agent_template agent_template_agent_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: freiraum
--

ALTER TABLE ONLY public.agent_template
    ADD CONSTRAINT agent_template_agent_id_fkey FOREIGN KEY (agent_id) REFERENCES public.agent(id) ON DELETE CASCADE;


--
-- Name: agent_template agent_template_template_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: freiraum
--

ALTER TABLE ONLY public.agent_template
    ADD CONSTRAINT agent_template_template_id_fkey FOREIGN KEY (template_id) REFERENCES public.template(id) ON DELETE RESTRICT;


--
-- Name: app app_fit_check_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: freiraum
--

ALTER TABLE ONLY public.app
    ADD CONSTRAINT app_fit_check_id_fkey FOREIGN KEY (fit_check_id) REFERENCES public.fit_check(id) ON DELETE SET NULL;


--
-- Name: app app_retention_class_fkey; Type: FK CONSTRAINT; Schema: public; Owner: freiraum
--

ALTER TABLE ONLY public.app
    ADD CONSTRAINT app_retention_class_fkey FOREIGN KEY (retention_class) REFERENCES public.retention_rule(class);


--
-- Name: app_state_history app_state_history_app_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: freiraum
--

ALTER TABLE ONLY public.app_state_history
    ADD CONSTRAINT app_state_history_app_id_fkey FOREIGN KEY (app_id) REFERENCES public.app(id) ON DELETE CASCADE;


--
-- Name: app app_tenant_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: freiraum
--

ALTER TABLE ONLY public.app
    ADD CONSTRAINT app_tenant_id_fkey FOREIGN KEY (tenant_id) REFERENCES public.tenant(id) ON DELETE RESTRICT;


--
-- Name: approval approval_approver_actor_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: freiraum
--

ALTER TABLE ONLY public.approval
    ADD CONSTRAINT approval_approver_actor_id_fkey FOREIGN KEY (approver_actor_id) REFERENCES public.actor(id);


--
-- Name: approval approval_editor_actor_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: freiraum
--

ALTER TABLE ONLY public.approval
    ADD CONSTRAINT approval_editor_actor_id_fkey FOREIGN KEY (editor_actor_id) REFERENCES public.actor(id);


--
-- Name: approval approval_tenant_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: freiraum
--

ALTER TABLE ONLY public.approval
    ADD CONSTRAINT approval_tenant_id_fkey FOREIGN KEY (tenant_id) REFERENCES public.tenant(id);


--
-- Name: auth_session auth_session_actor_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: freiraum
--

ALTER TABLE ONLY public.auth_session
    ADD CONSTRAINT auth_session_actor_id_fkey FOREIGN KEY (actor_id) REFERENCES public.actor(id) ON DELETE CASCADE;


--
-- Name: contact contact_tenant_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: freiraum
--

ALTER TABLE ONLY public.contact
    ADD CONSTRAINT contact_tenant_id_fkey FOREIGN KEY (tenant_id) REFERENCES public.tenant(id) ON DELETE CASCADE;


--
-- Name: contract_check contract_check_app_id_contract_version_fkey; Type: FK CONSTRAINT; Schema: public; Owner: freiraum
--

ALTER TABLE ONLY public.contract_check
    ADD CONSTRAINT contract_check_app_id_contract_version_fkey FOREIGN KEY (app_id, contract_version) REFERENCES public.project_contract(app_id, version) ON DELETE CASCADE;


--
-- Name: direct_prototype direct_prototype_actor_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: freiraum
--

ALTER TABLE ONLY public.direct_prototype
    ADD CONSTRAINT direct_prototype_actor_id_fkey FOREIGN KEY (actor_id) REFERENCES public.actor(id) ON DELETE SET NULL;


--
-- Name: direct_prototype direct_prototype_retention_class_fkey; Type: FK CONSTRAINT; Schema: public; Owner: freiraum
--

ALTER TABLE ONLY public.direct_prototype
    ADD CONSTRAINT direct_prototype_retention_class_fkey FOREIGN KEY (retention_class) REFERENCES public.retention_rule(class);


--
-- Name: direct_prototype direct_prototype_tenant_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: freiraum
--

ALTER TABLE ONLY public.direct_prototype
    ADD CONSTRAINT direct_prototype_tenant_id_fkey FOREIGN KEY (tenant_id) REFERENCES public.tenant(id) ON DELETE RESTRICT;


--
-- Name: document document_app_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: freiraum
--

ALTER TABLE ONLY public.document
    ADD CONSTRAINT document_app_id_fkey FOREIGN KEY (app_id) REFERENCES public.app(id) ON DELETE CASCADE;


--
-- Name: document document_template_fk; Type: FK CONSTRAINT; Schema: public; Owner: freiraum
--

ALTER TABLE ONLY public.document
    ADD CONSTRAINT document_template_fk FOREIGN KEY (template_id, template_version) REFERENCES public.template_version(template_id, version) ON DELETE RESTRICT;


--
-- Name: document_version document_version_document_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: freiraum
--

ALTER TABLE ONLY public.document_version
    ADD CONSTRAINT document_version_document_id_fkey FOREIGN KEY (document_id) REFERENCES public.document(id) ON DELETE CASCADE;


--
-- Name: event event_actor_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: freiraum
--

ALTER TABLE ONLY public.event
    ADD CONSTRAINT event_actor_id_fkey FOREIGN KEY (actor_id) REFERENCES public.actor(id) ON DELETE SET NULL;


--
-- Name: event event_document_fk; Type: FK CONSTRAINT; Schema: public; Owner: freiraum
--

ALTER TABLE ONLY public.event
    ADD CONSTRAINT event_document_fk FOREIGN KEY (document_id, document_version) REFERENCES public.document_version(document_id, version) ON DELETE RESTRICT;


--
-- Name: event event_project_no_fkey; Type: FK CONSTRAINT; Schema: public; Owner: freiraum
--

ALTER TABLE ONLY public.event
    ADD CONSTRAINT event_project_no_fkey FOREIGN KEY (project_no) REFERENCES public.app(project_no) ON DELETE SET NULL;


--
-- Name: event event_retention_class_fkey; Type: FK CONSTRAINT; Schema: public; Owner: freiraum
--

ALTER TABLE ONLY public.event
    ADD CONSTRAINT event_retention_class_fkey FOREIGN KEY (retention_class) REFERENCES public.retention_rule(class);


--
-- Name: event event_tenant_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: freiraum
--

ALTER TABLE ONLY public.event
    ADD CONSTRAINT event_tenant_id_fkey FOREIGN KEY (tenant_id) REFERENCES public.tenant(id) ON DELETE SET NULL;


--
-- Name: fit_answer fit_answer_fit_check_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: freiraum
--

ALTER TABLE ONLY public.fit_answer
    ADD CONSTRAINT fit_answer_fit_check_id_fkey FOREIGN KEY (fit_check_id) REFERENCES public.fit_check(id) ON DELETE CASCADE;


--
-- Name: fit_answer fit_answer_option_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: freiraum
--

ALTER TABLE ONLY public.fit_answer
    ADD CONSTRAINT fit_answer_option_id_fkey FOREIGN KEY (option_id) REFERENCES public.fit_option(id) ON DELETE RESTRICT;


--
-- Name: fit_answer fit_answer_question_code_fkey; Type: FK CONSTRAINT; Schema: public; Owner: freiraum
--

ALTER TABLE ONLY public.fit_answer
    ADD CONSTRAINT fit_answer_question_code_fkey FOREIGN KEY (question_code) REFERENCES public.fit_question(code) ON DELETE RESTRICT;


--
-- Name: fit_check fit_check_actor_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: freiraum
--

ALTER TABLE ONLY public.fit_check
    ADD CONSTRAINT fit_check_actor_id_fkey FOREIGN KEY (actor_id) REFERENCES public.actor(id) ON DELETE SET NULL;


--
-- Name: fit_check fit_check_app_fk; Type: FK CONSTRAINT; Schema: public; Owner: freiraum
--

ALTER TABLE ONLY public.fit_check
    ADD CONSTRAINT fit_check_app_fk FOREIGN KEY (app_id) REFERENCES public.app(id) ON DELETE SET NULL;


--
-- Name: fit_check fit_check_retention_class_fkey; Type: FK CONSTRAINT; Schema: public; Owner: freiraum
--

ALTER TABLE ONLY public.fit_check
    ADD CONSTRAINT fit_check_retention_class_fkey FOREIGN KEY (retention_class) REFERENCES public.retention_rule(class);


--
-- Name: fit_check fit_check_tenant_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: freiraum
--

ALTER TABLE ONLY public.fit_check
    ADD CONSTRAINT fit_check_tenant_id_fkey FOREIGN KEY (tenant_id) REFERENCES public.tenant(id) ON DELETE RESTRICT;


--
-- Name: fit_option fit_option_question_code_fkey; Type: FK CONSTRAINT; Schema: public; Owner: freiraum
--

ALTER TABLE ONLY public.fit_option
    ADD CONSTRAINT fit_option_question_code_fkey FOREIGN KEY (question_code) REFERENCES public.fit_question(code) ON DELETE CASCADE;


--
-- Name: invitation invitation_actor_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: freiraum
--

ALTER TABLE ONLY public.invitation
    ADD CONSTRAINT invitation_actor_id_fkey FOREIGN KEY (actor_id) REFERENCES public.actor(id) ON DELETE CASCADE;


--
-- Name: invitation_decision invitation_decision_invitation_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: freiraum
--

ALTER TABLE ONLY public.invitation_decision
    ADD CONSTRAINT invitation_decision_invitation_id_fkey FOREIGN KEY (invitation_id) REFERENCES public.invitation(id) ON DELETE SET NULL;


--
-- Name: invitation_decision invitation_decision_tenant_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: freiraum
--

ALTER TABLE ONLY public.invitation_decision
    ADD CONSTRAINT invitation_decision_tenant_id_fkey FOREIGN KEY (tenant_id) REFERENCES public.tenant(id) ON DELETE RESTRICT;


--
-- Name: invitation invitation_portal_code_fkey; Type: FK CONSTRAINT; Schema: public; Owner: freiraum
--

ALTER TABLE ONLY public.invitation
    ADD CONSTRAINT invitation_portal_code_fkey FOREIGN KEY (portal_code) REFERENCES public.portal(code);


--
-- Name: knowledge_module_source knowledge_module_source_module_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: freiraum
--

ALTER TABLE ONLY public.knowledge_module_source
    ADD CONSTRAINT knowledge_module_source_module_id_fkey FOREIGN KEY (module_id) REFERENCES public.knowledge_module(id) ON DELETE CASCADE;


--
-- Name: knowledge_module_source knowledge_module_source_source_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: freiraum
--

ALTER TABLE ONLY public.knowledge_module_source
    ADD CONSTRAINT knowledge_module_source_source_id_fkey FOREIGN KEY (source_id) REFERENCES public.knowledge_source(id) ON DELETE RESTRICT;


--
-- Name: knowledge_module_version knowledge_module_version_module_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: freiraum
--

ALTER TABLE ONLY public.knowledge_module_version
    ADD CONSTRAINT knowledge_module_version_module_id_fkey FOREIGN KEY (module_id) REFERENCES public.knowledge_module(id) ON DELETE CASCADE;


--
-- Name: knowledge_source knowledge_source_owner_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: freiraum
--

ALTER TABLE ONLY public.knowledge_source
    ADD CONSTRAINT knowledge_source_owner_id_fkey FOREIGN KEY (owner_id) REFERENCES public.actor(id) ON DELETE SET NULL;


--
-- Name: login_attempt login_attempt_retention_class_fkey; Type: FK CONSTRAINT; Schema: public; Owner: freiraum
--

ALTER TABLE ONLY public.login_attempt
    ADD CONSTRAINT login_attempt_retention_class_fkey FOREIGN KEY (retention_class) REFERENCES public.retention_rule(class);


--
-- Name: login_code login_code_actor_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: freiraum
--

ALTER TABLE ONLY public.login_code
    ADD CONSTRAINT login_code_actor_id_fkey FOREIGN KEY (actor_id) REFERENCES public.actor(id) ON DELETE CASCADE;


--
-- Name: login_code login_code_retention_class_fkey; Type: FK CONSTRAINT; Schema: public; Owner: freiraum
--

ALTER TABLE ONLY public.login_code
    ADD CONSTRAINT login_code_retention_class_fkey FOREIGN KEY (retention_class) REFERENCES public.retention_rule(class);


--
-- Name: mail_delivery mail_delivery_actor_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: freiraum
--

ALTER TABLE ONLY public.mail_delivery
    ADD CONSTRAINT mail_delivery_actor_id_fkey FOREIGN KEY (actor_id) REFERENCES public.actor(id) ON DELETE SET NULL;


--
-- Name: mail_delivery mail_delivery_login_code_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: freiraum
--

ALTER TABLE ONLY public.mail_delivery
    ADD CONSTRAINT mail_delivery_login_code_id_fkey FOREIGN KEY (login_code_id) REFERENCES public.login_code(id) ON DELETE SET NULL;


--
-- Name: mail_delivery mail_delivery_retention_class_fkey; Type: FK CONSTRAINT; Schema: public; Owner: freiraum
--

ALTER TABLE ONLY public.mail_delivery
    ADD CONSTRAINT mail_delivery_retention_class_fkey FOREIGN KEY (retention_class) REFERENCES public.retention_rule(class);


--
-- Name: membership membership_actor_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: freiraum
--

ALTER TABLE ONLY public.membership
    ADD CONSTRAINT membership_actor_id_fkey FOREIGN KEY (actor_id) REFERENCES public.actor(id) ON DELETE CASCADE;


--
-- Name: membership membership_portal_code_fkey; Type: FK CONSTRAINT; Schema: public; Owner: freiraum
--

ALTER TABLE ONLY public.membership
    ADD CONSTRAINT membership_portal_code_fkey FOREIGN KEY (portal_code) REFERENCES public.portal(code);


--
-- Name: membership membership_role_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: freiraum
--

ALTER TABLE ONLY public.membership
    ADD CONSTRAINT membership_role_id_fkey FOREIGN KEY (role_id) REFERENCES public.role(id) ON DELETE RESTRICT;


--
-- Name: membership membership_tenant_scope_fkey; Type: FK CONSTRAINT; Schema: public; Owner: freiraum
--

ALTER TABLE ONLY public.membership
    ADD CONSTRAINT membership_tenant_scope_fkey FOREIGN KEY (tenant_scope) REFERENCES public.tenant(id) ON DELETE RESTRICT;


--
-- Name: model_ref model_manifest_fk; Type: FK CONSTRAINT; Schema: public; Owner: freiraum
--

ALTER TABLE ONLY public.model_ref
    ADD CONSTRAINT model_manifest_fk FOREIGN KEY (manifest_id, manifest_version) REFERENCES public.model_manifest_version(manifest_id, version) ON DELETE RESTRICT;


--
-- Name: model_manifest_version model_manifest_version_manifest_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: freiraum
--

ALTER TABLE ONLY public.model_manifest_version
    ADD CONSTRAINT model_manifest_version_manifest_id_fkey FOREIGN KEY (manifest_id) REFERENCES public.model_manifest(id) ON DELETE CASCADE;


--
-- Name: module module_portal_code_fkey; Type: FK CONSTRAINT; Schema: public; Owner: freiraum
--

ALTER TABLE ONLY public.module
    ADD CONSTRAINT module_portal_code_fkey FOREIGN KEY (portal_code) REFERENCES public.portal(code);


--
-- Name: policy policy_template_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: freiraum
--

ALTER TABLE ONLY public.policy
    ADD CONSTRAINT policy_template_id_fkey FOREIGN KEY (template_id) REFERENCES public.template(id) ON DELETE SET NULL;


--
-- Name: policy_version policy_version_policy_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: freiraum
--

ALTER TABLE ONLY public.policy_version
    ADD CONSTRAINT policy_version_policy_id_fkey FOREIGN KEY (policy_id) REFERENCES public.policy(id) ON DELETE CASCADE;


--
-- Name: project_contract project_contract_app_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: freiraum
--

ALTER TABLE ONLY public.project_contract
    ADD CONSTRAINT project_contract_app_id_fkey FOREIGN KEY (app_id) REFERENCES public.app(id) ON DELETE CASCADE;


--
-- Name: quick_answer quick_answer_question_code_version_option_pos_fkey; Type: FK CONSTRAINT; Schema: public; Owner: freiraum
--

ALTER TABLE ONLY public.quick_answer
    ADD CONSTRAINT quick_answer_question_code_version_option_pos_fkey FOREIGN KEY (question_code, version, option_pos) REFERENCES public.quick_option(question_code, version, "position") ON DELETE RESTRICT;


--
-- Name: quick_answer quick_answer_quick_check_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: freiraum
--

ALTER TABLE ONLY public.quick_answer
    ADD CONSTRAINT quick_answer_quick_check_id_fkey FOREIGN KEY (quick_check_id) REFERENCES public.quick_check(id) ON DELETE CASCADE;


--
-- Name: quick_check quick_check_actor_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: freiraum
--

ALTER TABLE ONLY public.quick_check
    ADD CONSTRAINT quick_check_actor_id_fkey FOREIGN KEY (actor_id) REFERENCES public.actor(id) ON DELETE SET NULL;


--
-- Name: quick_check quick_check_retention_class_fkey; Type: FK CONSTRAINT; Schema: public; Owner: freiraum
--

ALTER TABLE ONLY public.quick_check
    ADD CONSTRAINT quick_check_retention_class_fkey FOREIGN KEY (retention_class) REFERENCES public.retention_rule(class);


--
-- Name: quick_check quick_check_tenant_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: freiraum
--

ALTER TABLE ONLY public.quick_check
    ADD CONSTRAINT quick_check_tenant_id_fkey FOREIGN KEY (tenant_id) REFERENCES public.tenant(id) ON DELETE RESTRICT;


--
-- Name: quick_option quick_option_question_code_version_fkey; Type: FK CONSTRAINT; Schema: public; Owner: freiraum
--

ALTER TABLE ONLY public.quick_option
    ADD CONSTRAINT quick_option_question_code_version_fkey FOREIGN KEY (question_code, version) REFERENCES public.quick_question_version(question_code, version) ON DELETE CASCADE;


--
-- Name: quick_question_version quick_question_version_question_code_fkey; Type: FK CONSTRAINT; Schema: public; Owner: freiraum
--

ALTER TABLE ONLY public.quick_question_version
    ADD CONSTRAINT quick_question_version_question_code_fkey FOREIGN KEY (question_code) REFERENCES public.quick_question(code) ON DELETE CASCADE;


--
-- Name: review_finding review_finding_review_run_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: freiraum
--

ALTER TABLE ONLY public.review_finding
    ADD CONSTRAINT review_finding_review_run_id_fkey FOREIGN KEY (review_run_id) REFERENCES public.review_run(id) ON DELETE CASCADE;


--
-- Name: review_run review_run_app_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: freiraum
--

ALTER TABLE ONLY public.review_run
    ADD CONSTRAINT review_run_app_id_fkey FOREIGN KEY (app_id) REFERENCES public.app(id) ON DELETE CASCADE;


--
-- Name: review_run review_run_model_ref_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: freiraum
--

ALTER TABLE ONLY public.review_run
    ADD CONSTRAINT review_run_model_ref_id_fkey FOREIGN KEY (model_ref_id) REFERENCES public.model_ref(id) ON DELETE RESTRICT;


--
-- Name: review_run review_run_retention_class_fkey; Type: FK CONSTRAINT; Schema: public; Owner: freiraum
--

ALTER TABLE ONLY public.review_run
    ADD CONSTRAINT review_run_retention_class_fkey FOREIGN KEY (retention_class) REFERENCES public.retention_rule(class);


--
-- Name: review_run review_run_rubric_module_id_rubric_version_fkey; Type: FK CONSTRAINT; Schema: public; Owner: freiraum
--

ALTER TABLE ONLY public.review_run
    ADD CONSTRAINT review_run_rubric_module_id_rubric_version_fkey FOREIGN KEY (rubric_module_id, rubric_version) REFERENCES public.knowledge_module_version(module_id, version) ON DELETE RESTRICT;


--
-- Name: role role_portal_code_fkey; Type: FK CONSTRAINT; Schema: public; Owner: freiraum
--

ALTER TABLE ONLY public.role
    ADD CONSTRAINT role_portal_code_fkey FOREIGN KEY (portal_code) REFERENCES public.portal(code);


--
-- Name: role_right role_right_role_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: freiraum
--

ALTER TABLE ONLY public.role_right
    ADD CONSTRAINT role_right_role_id_fkey FOREIGN KEY (role_id) REFERENCES public.role(id) ON DELETE CASCADE;


--
-- Name: template_element template_element_element_template_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: freiraum
--

ALTER TABLE ONLY public.template_element
    ADD CONSTRAINT template_element_element_template_id_fkey FOREIGN KEY (element_template_id) REFERENCES public.template(id) ON DELETE RESTRICT;


--
-- Name: template_element template_element_template_id_version_fkey; Type: FK CONSTRAINT; Schema: public; Owner: freiraum
--

ALTER TABLE ONLY public.template_element
    ADD CONSTRAINT template_element_template_id_version_fkey FOREIGN KEY (template_id, version) REFERENCES public.template_version(template_id, version) ON DELETE CASCADE;


--
-- Name: template_version template_version_template_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: freiraum
--

ALTER TABLE ONLY public.template_version
    ADD CONSTRAINT template_version_template_id_fkey FOREIGN KEY (template_id) REFERENCES public.template(id) ON DELETE CASCADE;


--
-- Name: tenant_invite_domain tenant_invite_domain_tenant_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: freiraum
--

ALTER TABLE ONLY public.tenant_invite_domain
    ADD CONSTRAINT tenant_invite_domain_tenant_id_fkey FOREIGN KEY (tenant_id) REFERENCES public.tenant(id) ON DELETE CASCADE;


--
-- Name: test_harness test_harness_app_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: freiraum
--

ALTER TABLE ONLY public.test_harness
    ADD CONSTRAINT test_harness_app_id_fkey FOREIGN KEY (app_id) REFERENCES public.app(id) ON DELETE CASCADE;


--
-- Name: app; Type: ROW SECURITY; Schema: public; Owner: freiraum
--

ALTER TABLE public.app ENABLE ROW LEVEL SECURITY;

--
-- Name: document; Type: ROW SECURITY; Schema: public; Owner: freiraum
--

ALTER TABLE public.document ENABLE ROW LEVEL SECURITY;

--
-- Name: event; Type: ROW SECURITY; Schema: public; Owner: freiraum
--

ALTER TABLE public.event ENABLE ROW LEVEL SECURITY;

--
-- Name: app mandant_app; Type: POLICY; Schema: public; Owner: freiraum
--

CREATE POLICY mandant_app ON public.app USING (((tenant_id = public.sitzungs_mandant()) OR ((public.sitzungs_mandant() IS NULL) AND (NOT public.rls_erzwungen())))) WITH CHECK (((tenant_id = public.sitzungs_mandant()) OR ((public.sitzungs_mandant() IS NULL) AND (NOT public.rls_erzwungen()))));


--
-- Name: document mandant_document; Type: POLICY; Schema: public; Owner: freiraum
--

CREATE POLICY mandant_document ON public.document USING (((EXISTS ( SELECT 1
   FROM public.app a
  WHERE (a.id = document.app_id))) OR ((public.sitzungs_mandant() IS NULL) AND (NOT public.rls_erzwungen())))) WITH CHECK (((EXISTS ( SELECT 1
   FROM public.app a
  WHERE (a.id = document.app_id))) OR ((public.sitzungs_mandant() IS NULL) AND (NOT public.rls_erzwungen()))));


--
-- Name: event mandant_event; Type: POLICY; Schema: public; Owner: freiraum
--

CREATE POLICY mandant_event ON public.event USING (((tenant_id IS NULL) OR (tenant_id = public.sitzungs_mandant()) OR ((public.sitzungs_mandant() IS NULL) AND (NOT public.rls_erzwungen())))) WITH CHECK (((tenant_id IS NULL) OR (tenant_id = public.sitzungs_mandant()) OR ((public.sitzungs_mandant() IS NULL) AND (NOT public.rls_erzwungen()))));


--
-- Name: SCHEMA public; Type: ACL; Schema: -; Owner: pg_database_owner
--

GRANT USAGE ON SCHEMA public TO fr_portal;
GRANT USAGE ON SCHEMA public TO fr_broker;
GRANT USAGE ON SCHEMA public TO fr_modell;
GRANT USAGE ON SCHEMA public TO fr_migration;
GRANT USAGE ON SCHEMA public TO fr_wartung;
GRANT USAGE ON SCHEMA public TO fr_pruefung;


--
-- Name: FUNCTION change_app_state(p_app uuid, p_ziel public.lifecycle_state, p_actor uuid); Type: ACL; Schema: public; Owner: freiraum
--

GRANT ALL ON FUNCTION public.change_app_state(p_app uuid, p_ziel public.lifecycle_state, p_actor uuid) TO fr_portal;


--
-- Name: FUNCTION create_app_after_fit(p_tenant uuid, p_name text, p_fit_check uuid, p_actor uuid); Type: ACL; Schema: public; Owner: freiraum
--

REVOKE ALL ON FUNCTION public.create_app_after_fit(p_tenant uuid, p_name text, p_fit_check uuid, p_actor uuid) FROM PUBLIC;
GRANT ALL ON FUNCTION public.create_app_after_fit(p_tenant uuid, p_name text, p_fit_check uuid, p_actor uuid) TO fr_portal;


--
-- Name: FUNCTION set_journey_phase(p_app uuid, p_ziel public.journey_phase, p_actor uuid); Type: ACL; Schema: public; Owner: freiraum
--

GRANT ALL ON FUNCTION public.set_journey_phase(p_app uuid, p_ziel public.journey_phase, p_actor uuid) TO fr_portal;


--
-- Name: TABLE actor; Type: ACL; Schema: public; Owner: freiraum
--

GRANT SELECT ON TABLE public.actor TO fr_pruefung;
GRANT SELECT,INSERT,DELETE,UPDATE ON TABLE public.actor TO fr_wartung;
GRANT SELECT,INSERT ON TABLE public.actor TO fr_portal;


--
-- Name: COLUMN actor.user_code; Type: ACL; Schema: public; Owner: freiraum
--

GRANT UPDATE(user_code) ON TABLE public.actor TO fr_portal;


--
-- Name: COLUMN actor.email; Type: ACL; Schema: public; Owner: freiraum
--

GRANT UPDATE(email) ON TABLE public.actor TO fr_portal;


--
-- Name: COLUMN actor.display_name; Type: ACL; Schema: public; Owner: freiraum
--

GRANT UPDATE(display_name) ON TABLE public.actor TO fr_portal;


--
-- Name: COLUMN actor.mfa_method; Type: ACL; Schema: public; Owner: freiraum
--

GRANT UPDATE(mfa_method) ON TABLE public.actor TO fr_portal;


--
-- Name: COLUMN actor.status; Type: ACL; Schema: public; Owner: freiraum
--

GRANT UPDATE(status) ON TABLE public.actor TO fr_portal;


--
-- Name: COLUMN actor.status_before_lock; Type: ACL; Schema: public; Owner: freiraum
--

GRANT UPDATE(status_before_lock) ON TABLE public.actor TO fr_portal;


--
-- Name: COLUMN actor.last_login_at; Type: ACL; Schema: public; Owner: freiraum
--

GRANT UPDATE(last_login_at) ON TABLE public.actor TO fr_portal;


--
-- Name: TABLE agent; Type: ACL; Schema: public; Owner: freiraum
--

GRANT SELECT ON TABLE public.agent TO fr_pruefung;
GRANT SELECT,INSERT,DELETE,UPDATE ON TABLE public.agent TO fr_wartung;
GRANT SELECT,INSERT,UPDATE ON TABLE public.agent TO fr_portal;


--
-- Name: TABLE agent_knowledge; Type: ACL; Schema: public; Owner: freiraum
--

GRANT SELECT ON TABLE public.agent_knowledge TO fr_pruefung;
GRANT SELECT,INSERT,DELETE,UPDATE ON TABLE public.agent_knowledge TO fr_wartung;
GRANT SELECT,INSERT,UPDATE ON TABLE public.agent_knowledge TO fr_portal;


--
-- Name: TABLE agent_policy; Type: ACL; Schema: public; Owner: freiraum
--

GRANT SELECT ON TABLE public.agent_policy TO fr_pruefung;
GRANT SELECT,INSERT,DELETE,UPDATE ON TABLE public.agent_policy TO fr_wartung;
GRANT SELECT,INSERT,UPDATE ON TABLE public.agent_policy TO fr_portal;


--
-- Name: TABLE agent_template; Type: ACL; Schema: public; Owner: freiraum
--

GRANT SELECT ON TABLE public.agent_template TO fr_pruefung;
GRANT SELECT,INSERT,DELETE,UPDATE ON TABLE public.agent_template TO fr_wartung;
GRANT SELECT,INSERT,UPDATE ON TABLE public.agent_template TO fr_portal;


--
-- Name: TABLE app; Type: ACL; Schema: public; Owner: freiraum
--

GRANT SELECT ON TABLE public.app TO fr_pruefung;
GRANT SELECT,INSERT,DELETE,UPDATE ON TABLE public.app TO fr_wartung;
GRANT SELECT ON TABLE public.app TO fr_portal;


--
-- Name: TABLE app_eingeschraenkt; Type: ACL; Schema: public; Owner: freiraum
--

GRANT SELECT ON TABLE public.app_eingeschraenkt TO fr_pruefung;
GRANT SELECT,INSERT,DELETE,UPDATE ON TABLE public.app_eingeschraenkt TO fr_wartung;
GRANT SELECT,INSERT,UPDATE ON TABLE public.app_eingeschraenkt TO fr_portal;


--
-- Name: TABLE fit_check; Type: ACL; Schema: public; Owner: freiraum
--

GRANT SELECT ON TABLE public.fit_check TO fr_pruefung;
GRANT SELECT,INSERT,DELETE,UPDATE ON TABLE public.fit_check TO fr_wartung;
GRANT SELECT,INSERT,UPDATE ON TABLE public.fit_check TO fr_portal;


--
-- Name: TABLE app_fit_ok; Type: ACL; Schema: public; Owner: freiraum
--

GRANT SELECT ON TABLE public.app_fit_ok TO fr_pruefung;
GRANT SELECT,INSERT,DELETE,UPDATE ON TABLE public.app_fit_ok TO fr_wartung;
GRANT SELECT,INSERT,UPDATE ON TABLE public.app_fit_ok TO fr_portal;


--
-- Name: TABLE app_state_history; Type: ACL; Schema: public; Owner: freiraum
--

GRANT SELECT ON TABLE public.app_state_history TO fr_pruefung;
GRANT SELECT,INSERT,DELETE,UPDATE ON TABLE public.app_state_history TO fr_wartung;
GRANT SELECT,INSERT,UPDATE ON TABLE public.app_state_history TO fr_portal;


--
-- Name: TABLE app_state_aktuell; Type: ACL; Schema: public; Owner: freiraum
--

GRANT SELECT ON TABLE public.app_state_aktuell TO fr_pruefung;
GRANT SELECT,INSERT,DELETE,UPDATE ON TABLE public.app_state_aktuell TO fr_wartung;
GRANT SELECT,INSERT,UPDATE ON TABLE public.app_state_aktuell TO fr_portal;


--
-- Name: TABLE approval; Type: ACL; Schema: public; Owner: freiraum
--

GRANT SELECT ON TABLE public.approval TO fr_pruefung;
GRANT SELECT,INSERT,DELETE,UPDATE ON TABLE public.approval TO fr_wartung;
GRANT SELECT,INSERT,UPDATE ON TABLE public.approval TO fr_portal;


--
-- Name: TABLE auth_session; Type: ACL; Schema: public; Owner: freiraum
--

GRANT SELECT ON TABLE public.auth_session TO fr_pruefung;
GRANT SELECT,INSERT,DELETE,UPDATE ON TABLE public.auth_session TO fr_wartung;
GRANT SELECT,INSERT,UPDATE ON TABLE public.auth_session TO fr_portal;


--
-- Name: TABLE contact; Type: ACL; Schema: public; Owner: freiraum
--

GRANT SELECT ON TABLE public.contact TO fr_pruefung;
GRANT SELECT,INSERT,DELETE,UPDATE ON TABLE public.contact TO fr_wartung;
GRANT SELECT,INSERT,UPDATE ON TABLE public.contact TO fr_portal;


--
-- Name: TABLE contract_check; Type: ACL; Schema: public; Owner: freiraum
--

GRANT SELECT ON TABLE public.contract_check TO fr_pruefung;
GRANT SELECT,INSERT,DELETE,UPDATE ON TABLE public.contract_check TO fr_wartung;
GRANT SELECT,INSERT,UPDATE ON TABLE public.contract_check TO fr_portal;


--
-- Name: TABLE direct_prototype; Type: ACL; Schema: public; Owner: freiraum
--

GRANT SELECT ON TABLE public.direct_prototype TO fr_pruefung;
GRANT SELECT,INSERT,DELETE,UPDATE ON TABLE public.direct_prototype TO fr_wartung;
GRANT SELECT,INSERT,UPDATE ON TABLE public.direct_prototype TO fr_portal;


--
-- Name: TABLE document; Type: ACL; Schema: public; Owner: freiraum
--

GRANT SELECT ON TABLE public.document TO fr_pruefung;
GRANT SELECT,INSERT,DELETE,UPDATE ON TABLE public.document TO fr_wartung;
GRANT SELECT,INSERT,UPDATE ON TABLE public.document TO fr_portal;


--
-- Name: TABLE document_version; Type: ACL; Schema: public; Owner: freiraum
--

GRANT SELECT ON TABLE public.document_version TO fr_pruefung;
GRANT SELECT,INSERT,DELETE,UPDATE ON TABLE public.document_version TO fr_wartung;
GRANT SELECT,INSERT,UPDATE ON TABLE public.document_version TO fr_portal;


--
-- Name: TABLE event; Type: ACL; Schema: public; Owner: freiraum
--

GRANT SELECT ON TABLE public.event TO fr_pruefung;
GRANT SELECT,INSERT,DELETE,UPDATE ON TABLE public.event TO fr_wartung;
GRANT SELECT,INSERT,UPDATE ON TABLE public.event TO fr_portal;
GRANT INSERT ON TABLE public.event TO fr_broker;
GRANT INSERT ON TABLE public.event TO fr_modell;


--
-- Name: TABLE fit_answer; Type: ACL; Schema: public; Owner: freiraum
--

GRANT SELECT ON TABLE public.fit_answer TO fr_pruefung;
GRANT SELECT,INSERT,DELETE,UPDATE ON TABLE public.fit_answer TO fr_wartung;
GRANT SELECT,INSERT,UPDATE ON TABLE public.fit_answer TO fr_portal;


--
-- Name: TABLE fit_option; Type: ACL; Schema: public; Owner: freiraum
--

GRANT SELECT ON TABLE public.fit_option TO fr_pruefung;
GRANT SELECT,INSERT,DELETE,UPDATE ON TABLE public.fit_option TO fr_wartung;
GRANT SELECT,INSERT,UPDATE ON TABLE public.fit_option TO fr_portal;


--
-- Name: TABLE fit_question; Type: ACL; Schema: public; Owner: freiraum
--

GRANT SELECT ON TABLE public.fit_question TO fr_pruefung;
GRANT SELECT,INSERT,DELETE,UPDATE ON TABLE public.fit_question TO fr_wartung;
GRANT SELECT,INSERT,UPDATE ON TABLE public.fit_question TO fr_portal;


--
-- Name: TABLE invitation; Type: ACL; Schema: public; Owner: freiraum
--

GRANT SELECT ON TABLE public.invitation TO fr_pruefung;
GRANT SELECT,INSERT,DELETE,UPDATE ON TABLE public.invitation TO fr_wartung;
GRANT SELECT,INSERT,UPDATE ON TABLE public.invitation TO fr_portal;


--
-- Name: TABLE invitation_decision; Type: ACL; Schema: public; Owner: freiraum
--

GRANT SELECT ON TABLE public.invitation_decision TO fr_pruefung;
GRANT SELECT,INSERT,DELETE,UPDATE ON TABLE public.invitation_decision TO fr_wartung;
GRANT SELECT,INSERT,UPDATE ON TABLE public.invitation_decision TO fr_portal;


--
-- Name: TABLE invitation_offen; Type: ACL; Schema: public; Owner: freiraum
--

GRANT SELECT ON TABLE public.invitation_offen TO fr_pruefung;
GRANT SELECT,INSERT,DELETE,UPDATE ON TABLE public.invitation_offen TO fr_wartung;
GRANT SELECT,INSERT,UPDATE ON TABLE public.invitation_offen TO fr_portal;


--
-- Name: TABLE knowledge_module; Type: ACL; Schema: public; Owner: freiraum
--

GRANT SELECT ON TABLE public.knowledge_module TO fr_pruefung;
GRANT SELECT,INSERT,DELETE,UPDATE ON TABLE public.knowledge_module TO fr_wartung;
GRANT SELECT,INSERT,UPDATE ON TABLE public.knowledge_module TO fr_portal;


--
-- Name: TABLE knowledge_module_version; Type: ACL; Schema: public; Owner: freiraum
--

GRANT SELECT ON TABLE public.knowledge_module_version TO fr_pruefung;
GRANT SELECT,INSERT,DELETE,UPDATE ON TABLE public.knowledge_module_version TO fr_wartung;
GRANT SELECT,INSERT,UPDATE ON TABLE public.knowledge_module_version TO fr_portal;


--
-- Name: TABLE knowledge_module_aktuell; Type: ACL; Schema: public; Owner: freiraum
--

GRANT SELECT ON TABLE public.knowledge_module_aktuell TO fr_pruefung;
GRANT SELECT,INSERT,DELETE,UPDATE ON TABLE public.knowledge_module_aktuell TO fr_wartung;
GRANT SELECT,INSERT,UPDATE ON TABLE public.knowledge_module_aktuell TO fr_portal;


--
-- Name: TABLE knowledge_module_source; Type: ACL; Schema: public; Owner: freiraum
--

GRANT SELECT ON TABLE public.knowledge_module_source TO fr_pruefung;
GRANT SELECT,INSERT,DELETE,UPDATE ON TABLE public.knowledge_module_source TO fr_wartung;
GRANT SELECT,INSERT,UPDATE ON TABLE public.knowledge_module_source TO fr_portal;


--
-- Name: TABLE knowledge_source; Type: ACL; Schema: public; Owner: freiraum
--

GRANT SELECT ON TABLE public.knowledge_source TO fr_pruefung;
GRANT SELECT,INSERT,DELETE,UPDATE ON TABLE public.knowledge_source TO fr_wartung;
GRANT SELECT,INSERT,UPDATE ON TABLE public.knowledge_source TO fr_portal;
GRANT SELECT ON TABLE public.knowledge_source TO fr_broker;


--
-- Name: TABLE knowledge_source_draft; Type: ACL; Schema: public; Owner: freiraum
--

GRANT SELECT ON TABLE public.knowledge_source_draft TO fr_pruefung;
GRANT SELECT,INSERT,DELETE,UPDATE ON TABLE public.knowledge_source_draft TO fr_wartung;
GRANT SELECT,INSERT,UPDATE ON TABLE public.knowledge_source_draft TO fr_portal;


--
-- Name: TABLE knowledge_source_released; Type: ACL; Schema: public; Owner: freiraum
--

GRANT SELECT ON TABLE public.knowledge_source_released TO fr_pruefung;
GRANT SELECT,INSERT,DELETE,UPDATE ON TABLE public.knowledge_source_released TO fr_wartung;
GRANT SELECT,INSERT,UPDATE ON TABLE public.knowledge_source_released TO fr_portal;


--
-- Name: TABLE lifecycle_state_label; Type: ACL; Schema: public; Owner: freiraum
--

GRANT SELECT ON TABLE public.lifecycle_state_label TO fr_pruefung;
GRANT SELECT,INSERT,DELETE,UPDATE ON TABLE public.lifecycle_state_label TO fr_wartung;
GRANT SELECT,INSERT,UPDATE ON TABLE public.lifecycle_state_label TO fr_portal;


--
-- Name: TABLE login_attempt; Type: ACL; Schema: public; Owner: freiraum
--

GRANT SELECT ON TABLE public.login_attempt TO fr_pruefung;
GRANT SELECT,INSERT,DELETE,UPDATE ON TABLE public.login_attempt TO fr_wartung;
GRANT SELECT,INSERT,UPDATE ON TABLE public.login_attempt TO fr_portal;


--
-- Name: TABLE login_code; Type: ACL; Schema: public; Owner: freiraum
--

GRANT SELECT ON TABLE public.login_code TO fr_pruefung;
GRANT SELECT,INSERT,DELETE,UPDATE ON TABLE public.login_code TO fr_wartung;
GRANT SELECT,INSERT,UPDATE ON TABLE public.login_code TO fr_portal;


--
-- Name: TABLE mail_delivery; Type: ACL; Schema: public; Owner: freiraum
--

GRANT SELECT ON TABLE public.mail_delivery TO fr_pruefung;
GRANT SELECT,INSERT,DELETE,UPDATE ON TABLE public.mail_delivery TO fr_wartung;
GRANT SELECT,INSERT,UPDATE ON TABLE public.mail_delivery TO fr_portal;


--
-- Name: TABLE membership; Type: ACL; Schema: public; Owner: freiraum
--

GRANT SELECT ON TABLE public.membership TO fr_pruefung;
GRANT SELECT,INSERT,DELETE,UPDATE ON TABLE public.membership TO fr_wartung;
GRANT SELECT,INSERT,UPDATE ON TABLE public.membership TO fr_portal;


--
-- Name: TABLE model_manifest; Type: ACL; Schema: public; Owner: freiraum
--

GRANT SELECT ON TABLE public.model_manifest TO fr_pruefung;
GRANT SELECT,INSERT,DELETE,UPDATE ON TABLE public.model_manifest TO fr_wartung;
GRANT SELECT,INSERT,UPDATE ON TABLE public.model_manifest TO fr_portal;
GRANT SELECT ON TABLE public.model_manifest TO fr_modell;


--
-- Name: TABLE model_manifest_version; Type: ACL; Schema: public; Owner: freiraum
--

GRANT SELECT ON TABLE public.model_manifest_version TO fr_pruefung;
GRANT SELECT,INSERT,DELETE,UPDATE ON TABLE public.model_manifest_version TO fr_wartung;
GRANT SELECT,INSERT,UPDATE ON TABLE public.model_manifest_version TO fr_portal;


--
-- Name: TABLE model_ref; Type: ACL; Schema: public; Owner: freiraum
--

GRANT SELECT ON TABLE public.model_ref TO fr_pruefung;
GRANT SELECT,INSERT,DELETE,UPDATE ON TABLE public.model_ref TO fr_wartung;
GRANT SELECT,INSERT,UPDATE ON TABLE public.model_ref TO fr_portal;


--
-- Name: TABLE module; Type: ACL; Schema: public; Owner: freiraum
--

GRANT SELECT ON TABLE public.module TO fr_pruefung;
GRANT SELECT,INSERT,DELETE,UPDATE ON TABLE public.module TO fr_wartung;
GRANT SELECT,INSERT,UPDATE ON TABLE public.module TO fr_portal;


--
-- Name: TABLE nummernvorrat; Type: ACL; Schema: public; Owner: freiraum
--

GRANT SELECT ON TABLE public.nummernvorrat TO fr_pruefung;
GRANT SELECT,INSERT,DELETE,UPDATE ON TABLE public.nummernvorrat TO fr_wartung;
GRANT SELECT,INSERT,UPDATE ON TABLE public.nummernvorrat TO fr_portal;


--
-- Name: TABLE tenant; Type: ACL; Schema: public; Owner: freiraum
--

GRANT SELECT ON TABLE public.tenant TO fr_pruefung;
GRANT SELECT,INSERT,DELETE,UPDATE ON TABLE public.tenant TO fr_wartung;
GRANT SELECT,INSERT,UPDATE ON TABLE public.tenant TO fr_portal;


--
-- Name: TABLE platform_admin; Type: ACL; Schema: public; Owner: freiraum
--

GRANT SELECT ON TABLE public.platform_admin TO fr_pruefung;
GRANT SELECT,INSERT,DELETE,UPDATE ON TABLE public.platform_admin TO fr_wartung;
GRANT SELECT,INSERT,UPDATE ON TABLE public.platform_admin TO fr_portal;


--
-- Name: TABLE policy; Type: ACL; Schema: public; Owner: freiraum
--

GRANT SELECT ON TABLE public.policy TO fr_pruefung;
GRANT SELECT,INSERT,DELETE,UPDATE ON TABLE public.policy TO fr_wartung;
GRANT SELECT,INSERT,UPDATE ON TABLE public.policy TO fr_portal;


--
-- Name: TABLE policy_version; Type: ACL; Schema: public; Owner: freiraum
--

GRANT SELECT ON TABLE public.policy_version TO fr_pruefung;
GRANT SELECT,INSERT,DELETE,UPDATE ON TABLE public.policy_version TO fr_wartung;
GRANT SELECT,INSERT,UPDATE ON TABLE public.policy_version TO fr_portal;


--
-- Name: TABLE policy_aktuell; Type: ACL; Schema: public; Owner: freiraum
--

GRANT SELECT ON TABLE public.policy_aktuell TO fr_pruefung;
GRANT SELECT,INSERT,DELETE,UPDATE ON TABLE public.policy_aktuell TO fr_wartung;
GRANT SELECT,INSERT,UPDATE ON TABLE public.policy_aktuell TO fr_portal;


--
-- Name: TABLE portal; Type: ACL; Schema: public; Owner: freiraum
--

GRANT SELECT ON TABLE public.portal TO fr_pruefung;
GRANT SELECT,INSERT,DELETE,UPDATE ON TABLE public.portal TO fr_wartung;
GRANT SELECT,INSERT,UPDATE ON TABLE public.portal TO fr_portal;


--
-- Name: TABLE portal_enabled; Type: ACL; Schema: public; Owner: freiraum
--

GRANT SELECT ON TABLE public.portal_enabled TO fr_pruefung;
GRANT SELECT,INSERT,DELETE,UPDATE ON TABLE public.portal_enabled TO fr_wartung;
GRANT SELECT,INSERT,UPDATE ON TABLE public.portal_enabled TO fr_portal;


--
-- Name: TABLE project_contract; Type: ACL; Schema: public; Owner: freiraum
--

GRANT SELECT ON TABLE public.project_contract TO fr_pruefung;
GRANT SELECT,INSERT,DELETE,UPDATE ON TABLE public.project_contract TO fr_wartung;
GRANT SELECT,INSERT,UPDATE ON TABLE public.project_contract TO fr_portal;


--
-- Name: TABLE quick_answer; Type: ACL; Schema: public; Owner: freiraum
--

GRANT SELECT ON TABLE public.quick_answer TO fr_pruefung;
GRANT SELECT,INSERT,DELETE,UPDATE ON TABLE public.quick_answer TO fr_wartung;
GRANT SELECT,INSERT,UPDATE ON TABLE public.quick_answer TO fr_portal;


--
-- Name: TABLE quick_check; Type: ACL; Schema: public; Owner: freiraum
--

GRANT SELECT ON TABLE public.quick_check TO fr_pruefung;
GRANT SELECT,INSERT,DELETE,UPDATE ON TABLE public.quick_check TO fr_wartung;
GRANT SELECT,INSERT,UPDATE ON TABLE public.quick_check TO fr_portal;


--
-- Name: TABLE quick_option; Type: ACL; Schema: public; Owner: freiraum
--

GRANT SELECT ON TABLE public.quick_option TO fr_pruefung;
GRANT SELECT,INSERT,DELETE,UPDATE ON TABLE public.quick_option TO fr_wartung;
GRANT SELECT,INSERT,UPDATE ON TABLE public.quick_option TO fr_portal;


--
-- Name: TABLE quick_question; Type: ACL; Schema: public; Owner: freiraum
--

GRANT SELECT ON TABLE public.quick_question TO fr_pruefung;
GRANT SELECT,INSERT,DELETE,UPDATE ON TABLE public.quick_question TO fr_wartung;
GRANT SELECT,INSERT,UPDATE ON TABLE public.quick_question TO fr_portal;


--
-- Name: TABLE quick_question_version; Type: ACL; Schema: public; Owner: freiraum
--

GRANT SELECT ON TABLE public.quick_question_version TO fr_pruefung;
GRANT SELECT,INSERT,DELETE,UPDATE ON TABLE public.quick_question_version TO fr_wartung;
GRANT SELECT,INSERT,UPDATE ON TABLE public.quick_question_version TO fr_portal;


--
-- Name: TABLE retention_rule; Type: ACL; Schema: public; Owner: freiraum
--

GRANT SELECT ON TABLE public.retention_rule TO fr_pruefung;
GRANT SELECT,INSERT,DELETE,UPDATE ON TABLE public.retention_rule TO fr_wartung;
GRANT SELECT,INSERT,UPDATE ON TABLE public.retention_rule TO fr_portal;


--
-- Name: TABLE review_run; Type: ACL; Schema: public; Owner: freiraum
--

GRANT SELECT ON TABLE public.review_run TO fr_pruefung;
GRANT SELECT,INSERT,DELETE,UPDATE ON TABLE public.review_run TO fr_wartung;
GRANT SELECT,INSERT,UPDATE ON TABLE public.review_run TO fr_portal;


--
-- Name: TABLE retention_due; Type: ACL; Schema: public; Owner: freiraum
--

GRANT SELECT ON TABLE public.retention_due TO fr_pruefung;
GRANT SELECT,INSERT,DELETE,UPDATE ON TABLE public.retention_due TO fr_wartung;
GRANT SELECT,INSERT,UPDATE ON TABLE public.retention_due TO fr_portal;


--
-- Name: TABLE review_finding; Type: ACL; Schema: public; Owner: freiraum
--

GRANT SELECT ON TABLE public.review_finding TO fr_pruefung;
GRANT SELECT,INSERT,DELETE,UPDATE ON TABLE public.review_finding TO fr_wartung;
GRANT SELECT,INSERT,UPDATE ON TABLE public.review_finding TO fr_portal;


--
-- Name: TABLE role; Type: ACL; Schema: public; Owner: freiraum
--

GRANT SELECT ON TABLE public.role TO fr_pruefung;
GRANT SELECT,INSERT,DELETE,UPDATE ON TABLE public.role TO fr_wartung;
GRANT SELECT,INSERT,UPDATE ON TABLE public.role TO fr_portal;


--
-- Name: TABLE role_right; Type: ACL; Schema: public; Owner: freiraum
--

GRANT SELECT ON TABLE public.role_right TO fr_pruefung;
GRANT SELECT,INSERT,DELETE,UPDATE ON TABLE public.role_right TO fr_wartung;
GRANT SELECT,INSERT,UPDATE ON TABLE public.role_right TO fr_portal;


--
-- Name: TABLE schema_migration; Type: ACL; Schema: public; Owner: freiraum
--

GRANT SELECT ON TABLE public.schema_migration TO fr_pruefung;
GRANT SELECT,INSERT,DELETE,UPDATE ON TABLE public.schema_migration TO fr_wartung;
GRANT SELECT,INSERT,UPDATE ON TABLE public.schema_migration TO fr_portal;


--
-- Name: TABLE state_transition; Type: ACL; Schema: public; Owner: freiraum
--

GRANT SELECT ON TABLE public.state_transition TO fr_pruefung;
GRANT SELECT,INSERT,DELETE,UPDATE ON TABLE public.state_transition TO fr_wartung;
GRANT SELECT,INSERT,UPDATE ON TABLE public.state_transition TO fr_portal;


--
-- Name: TABLE template; Type: ACL; Schema: public; Owner: freiraum
--

GRANT SELECT ON TABLE public.template TO fr_pruefung;
GRANT SELECT,INSERT,DELETE,UPDATE ON TABLE public.template TO fr_wartung;
GRANT SELECT,INSERT,UPDATE ON TABLE public.template TO fr_portal;


--
-- Name: TABLE template_version; Type: ACL; Schema: public; Owner: freiraum
--

GRANT SELECT ON TABLE public.template_version TO fr_pruefung;
GRANT SELECT,INSERT,DELETE,UPDATE ON TABLE public.template_version TO fr_wartung;
GRANT SELECT,INSERT,UPDATE ON TABLE public.template_version TO fr_portal;


--
-- Name: TABLE template_aktuell; Type: ACL; Schema: public; Owner: freiraum
--

GRANT SELECT ON TABLE public.template_aktuell TO fr_pruefung;
GRANT SELECT,INSERT,DELETE,UPDATE ON TABLE public.template_aktuell TO fr_wartung;
GRANT SELECT,INSERT,UPDATE ON TABLE public.template_aktuell TO fr_portal;


--
-- Name: TABLE template_element; Type: ACL; Schema: public; Owner: freiraum
--

GRANT SELECT ON TABLE public.template_element TO fr_pruefung;
GRANT SELECT,INSERT,DELETE,UPDATE ON TABLE public.template_element TO fr_wartung;
GRANT SELECT,INSERT,UPDATE ON TABLE public.template_element TO fr_portal;


--
-- Name: TABLE tenant_invite_domain; Type: ACL; Schema: public; Owner: freiraum
--

GRANT SELECT ON TABLE public.tenant_invite_domain TO fr_pruefung;
GRANT SELECT,INSERT,DELETE,UPDATE ON TABLE public.tenant_invite_domain TO fr_wartung;
GRANT SELECT,INSERT,UPDATE ON TABLE public.tenant_invite_domain TO fr_portal;


--
-- Name: TABLE test_harness; Type: ACL; Schema: public; Owner: freiraum
--

GRANT SELECT ON TABLE public.test_harness TO fr_pruefung;
GRANT SELECT,INSERT,DELETE,UPDATE ON TABLE public.test_harness TO fr_wartung;
GRANT SELECT,INSERT,UPDATE ON TABLE public.test_harness TO fr_portal;


--
-- PostgreSQL database dump complete
--


