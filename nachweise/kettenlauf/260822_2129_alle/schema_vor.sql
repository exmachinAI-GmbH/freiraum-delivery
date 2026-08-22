--
-- PostgreSQL database dump
--


-- Dumped from database version 16.14
-- Dumped by pg_dump version 18.6

SET statement_timeout = 0;
SET lock_timeout = 0;
SET idle_in_transaction_session_timeout = 0;
SET transaction_timeout = 0;
SET client_encoding = 'UTF8';
SET standard_conforming_strings = on;
SELECT pg_catalog.set_config('search_path', '', false);
SET check_function_bodies = false;
SET xmloption = content;
SET client_min_messages = warning;
SET row_security = off;

--
-- Name: public; Type: SCHEMA; Schema: -; Owner: azure_pg_admin
--

-- *not* creating schema, since initdb creates it


ALTER SCHEMA public OWNER TO azure_pg_admin;

--
-- Name: btree_gist; Type: EXTENSION; Schema: -; Owner: -
--

CREATE EXTENSION IF NOT EXISTS btree_gist WITH SCHEMA public;


--
-- Name: EXTENSION btree_gist; Type: COMMENT; Schema: -; Owner: 
--

COMMENT ON EXTENSION btree_gist IS 'support for indexing common datatypes in GiST';


--
-- Name: actor_status; Type: TYPE; Schema: public; Owner: frxadmin
--

CREATE TYPE public.actor_status AS ENUM (
    'AKTIV',
    'WARTET_2FA',
    'GESPERRT'
);


ALTER TYPE public.actor_status OWNER TO frxadmin;

--
-- Name: agent_status; Type: TYPE; Schema: public; Owner: frxadmin
--

CREATE TYPE public.agent_status AS ENUM (
    'RELEASED',
    'IN_REVIEW'
);


ALTER TYPE public.agent_status OWNER TO frxadmin;

--
-- Name: artifact_class; Type: TYPE; Schema: public; Owner: frxadmin
--

CREATE TYPE public.artifact_class AS ENUM (
    'VERIFIED_APP',
    'WORK_DOCUMENT'
);


ALTER TYPE public.artifact_class OWNER TO frxadmin;

--
-- Name: catalog_group; Type: TYPE; Schema: public; Owner: frxadmin
--

CREATE TYPE public.catalog_group AS ENUM (
    'TEAM',
    'SINGLE'
);


ALTER TYPE public.catalog_group OWNER TO frxadmin;

--
-- Name: currency_code; Type: TYPE; Schema: public; Owner: frxadmin
--

CREATE TYPE public.currency_code AS ENUM (
    'EUR',
    'GBP',
    'CHF'
);


ALTER TYPE public.currency_code OWNER TO frxadmin;

--
-- Name: document_kind; Type: TYPE; Schema: public; Owner: frxadmin
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


ALTER TYPE public.document_kind OWNER TO frxadmin;

--
-- Name: event_source; Type: TYPE; Schema: public; Owner: frxadmin
--

CREATE TYPE public.event_source AS ENUM (
    'PORTAL_ACTION',
    'MODEL_CHANGE'
);


ALTER TYPE public.event_source OWNER TO frxadmin;

--
-- Name: fit_dimension; Type: TYPE; Schema: public; Owner: frxadmin
--

CREATE TYPE public.fit_dimension AS ENUM (
    'ART',
    'NUTZUNG',
    'DATEN'
);


ALTER TYPE public.fit_dimension OWNER TO frxadmin;

--
-- Name: fit_outcome; Type: TYPE; Schema: public; Owner: frxadmin
--

CREATE TYPE public.fit_outcome AS ENUM (
    'OFFEN',
    'GEEIGNET',
    'NICHT_GEEIGNET'
);


ALTER TYPE public.fit_outcome OWNER TO frxadmin;

--
-- Name: invitation_status; Type: TYPE; Schema: public; Owner: frxadmin
--

CREATE TYPE public.invitation_status AS ENUM (
    'VERSANDT',
    'EINGELOEST',
    'ABGELAUFEN',
    'WIDERRUFEN'
);


ALTER TYPE public.invitation_status OWNER TO frxadmin;

--
-- Name: journey_phase; Type: TYPE; Schema: public; Owner: frxadmin
--

CREATE TYPE public.journey_phase AS ENUM (
    'ORIENTIERUNG',
    'INTERVIEW',
    'UEBERSICHT',
    'PROTOTYP',
    'ANGEBOT'
);


ALTER TYPE public.journey_phase OWNER TO frxadmin;

--
-- Name: knowledge_group; Type: TYPE; Schema: public; Owner: frxadmin
--

CREATE TYPE public.knowledge_group AS ENUM (
    'BRANCHENWISSEN',
    'FUNKTIONSWISSEN',
    'METHODENWISSEN'
);


ALTER TYPE public.knowledge_group OWNER TO frxadmin;

--
-- Name: knowledge_mode; Type: TYPE; Schema: public; Owner: frxadmin
--

CREATE TYPE public.knowledge_mode AS ENUM (
    'DYNAMIC',
    'FIXED'
);


ALTER TYPE public.knowledge_mode OWNER TO frxadmin;

--
-- Name: knowledge_origin; Type: TYPE; Schema: public; Owner: frxadmin
--

CREATE TYPE public.knowledge_origin AS ENUM (
    'EXTERN',
    'PROJEKT'
);


ALTER TYPE public.knowledge_origin OWNER TO frxadmin;

--
-- Name: knowledge_type; Type: TYPE; Schema: public; Owner: frxadmin
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


ALTER TYPE public.knowledge_type OWNER TO frxadmin;

--
-- Name: legal_form; Type: TYPE; Schema: public; Owner: frxadmin
--

CREATE TYPE public.legal_form AS ENUM (
    'GMBH',
    'GMBH_CO_KG',
    'AG',
    'KG',
    'EK'
);


ALTER TYPE public.legal_form OWNER TO frxadmin;

--
-- Name: legal_space; Type: TYPE; Schema: public; Owner: frxadmin
--

CREATE TYPE public.legal_space AS ENUM (
    'DE',
    'EU27_REST',
    'UK',
    'CH',
    'US_NEXUS_VENDOR'
);


ALTER TYPE public.legal_space OWNER TO frxadmin;

--
-- Name: lifecycle_state; Type: TYPE; Schema: public; Owner: frxadmin
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


ALTER TYPE public.lifecycle_state OWNER TO frxadmin;

--
-- Name: lifecycle_status; Type: TYPE; Schema: public; Owner: frxadmin
--

CREATE TYPE public.lifecycle_status AS ENUM (
    'DRAFT',
    'IN_REVIEW',
    'RELEASED',
    'RETIRED'
);


ALTER TYPE public.lifecycle_status OWNER TO frxadmin;

--
-- Name: mfa_method; Type: TYPE; Schema: public; Owner: frxadmin
--

CREATE TYPE public.mfa_method AS ENUM (
    'EMAIL_CODE',
    'OFF'
);


ALTER TYPE public.mfa_method OWNER TO frxadmin;

--
-- Name: model_hosting; Type: TYPE; Schema: public; Owner: frxadmin
--

CREATE TYPE public.model_hosting AS ENUM (
    'AZURE_EU',
    'ON_PREM_DE',
    'OFFEN'
);


ALTER TYPE public.model_hosting OWNER TO frxadmin;

--
-- Name: model_provider; Type: TYPE; Schema: public; Owner: frxadmin
--

CREATE TYPE public.model_provider AS ENUM (
    'ANTHROPIC',
    'OPENAI',
    'INTERN',
    'OFFEN'
);


ALTER TYPE public.model_provider OWNER TO frxadmin;

--
-- Name: portal_code; Type: TYPE; Schema: public; Owner: frxadmin
--

CREATE TYPE public.portal_code AS ENUM (
    'ENDUSER',
    'USER_ADMIN',
    'VAR_ADMIN',
    'EXMA',
    'INDIA_OPS'
);


ALTER TYPE public.portal_code OWNER TO frxadmin;

--
-- Name: release_status; Type: TYPE; Schema: public; Owner: frxadmin
--

CREATE TYPE public.release_status AS ENUM (
    'ENABLED',
    'PLANNED'
);


ALTER TYPE public.release_status OWNER TO frxadmin;

--
-- Name: retention_class; Type: TYPE; Schema: public; Owner: frxadmin
--

CREATE TYPE public.retention_class AS ENUM (
    'HANDELSRECHT',
    'KI_NACHWEIS',
    'BETRIEBSPROTOKOLL'
);


ALTER TYPE public.retention_class OWNER TO frxadmin;

--
-- Name: retention_start; Type: TYPE; Schema: public; Owner: frxadmin
--

CREATE TYPE public.retention_start AS ENUM (
    'ENTSTEHUNGSJAHRESENDE',
    'ERSTELLUNG',
    'BEZUGSOBJEKT'
);


ALTER TYPE public.retention_start OWNER TO frxadmin;

--
-- Name: rights_level; Type: TYPE; Schema: public; Owner: frxadmin
--

CREATE TYPE public.rights_level AS ENUM (
    'L',
    'V',
    'F',
    'A'
);


ALTER TYPE public.rights_level OWNER TO frxadmin;

--
-- Name: template_group; Type: TYPE; Schema: public; Owner: frxadmin
--

CREATE TYPE public.template_group AS ENUM (
    'DOCUMENT',
    'DESIGN',
    'DIALOG',
    'POLICY'
);


ALTER TYPE public.template_group OWNER TO frxadmin;

--
-- Name: tenant_kind; Type: TYPE; Schema: public; Owner: frxadmin
--

CREATE TYPE public.tenant_kind AS ENUM (
    'OPERATOR',
    'CUSTOMER',
    'PARTNER'
);


ALTER TYPE public.tenant_kind OWNER TO frxadmin;

--
-- Name: ui_locale; Type: TYPE; Schema: public; Owner: frxadmin
--

CREATE TYPE public.ui_locale AS ENUM (
    'DE',
    'EN'
);


ALTER TYPE public.ui_locale OWNER TO frxadmin;

--
-- Name: invitation_guard(); Type: FUNCTION; Schema: public; Owner: frxadmin
--

CREATE FUNCTION public.invitation_guard() RETURNS trigger
    LANGUAGE plpgsql
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


ALTER FUNCTION public.invitation_guard() OWNER TO frxadmin;

--
-- Name: platform_admin_guard(); Type: FUNCTION; Schema: public; Owner: frxadmin
--

CREATE FUNCTION public.platform_admin_guard() RETURNS trigger
    LANGUAGE plpgsql
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


ALTER FUNCTION public.platform_admin_guard() OWNER TO frxadmin;

--
-- Name: sealed_actor_guard(); Type: FUNCTION; Schema: public; Owner: frxadmin
--

CREATE FUNCTION public.sealed_actor_guard() RETURNS trigger
    LANGUAGE plpgsql
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


ALTER FUNCTION public.sealed_actor_guard() OWNER TO frxadmin;

SET default_tablespace = '';

SET default_table_access_method = heap;

--
-- Name: actor; Type: TABLE; Schema: public; Owner: frxadmin
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


ALTER TABLE public.actor OWNER TO frxadmin;

--
-- Name: agent; Type: TABLE; Schema: public; Owner: frxadmin
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
    CONSTRAINT agent_monthly_tokens_m_check CHECK ((monthly_tokens_m >= (0)::numeric)),
    CONSTRAINT agent_review_score_check CHECK (((review_score >= 0) AND (review_score <= 100)))
);


ALTER TABLE public.agent OWNER TO frxadmin;

--
-- Name: agent_knowledge; Type: TABLE; Schema: public; Owner: frxadmin
--

CREATE TABLE public.agent_knowledge (
    agent_id uuid NOT NULL,
    module_id text NOT NULL
);


ALTER TABLE public.agent_knowledge OWNER TO frxadmin;

--
-- Name: agent_policy; Type: TABLE; Schema: public; Owner: frxadmin
--

CREATE TABLE public.agent_policy (
    agent_id uuid NOT NULL,
    policy_id text NOT NULL
);


ALTER TABLE public.agent_policy OWNER TO frxadmin;

--
-- Name: agent_template; Type: TABLE; Schema: public; Owner: frxadmin
--

CREATE TABLE public.agent_template (
    agent_id uuid NOT NULL,
    template_id text NOT NULL
);


ALTER TABLE public.agent_template OWNER TO frxadmin;

--
-- Name: app; Type: TABLE; Schema: public; Owner: frxadmin
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
    CONSTRAINT ack_needs_seal CHECK (((mitbestimmung_ack_at IS NULL) OR (sealed_at IS NOT NULL))),
    CONSTRAINT app_is_verified CHECK ((artifact_class = 'VERIFIED_APP'::public.artifact_class)),
    CONSTRAINT app_offer_price_cents_check CHECK ((offer_price_cents >= 0)),
    CONSTRAINT app_open_points_check CHECK ((open_points >= 0)),
    CONSTRAINT app_project_no_check CHECK ((project_no ~ '^DE-[A-Z]{3}_[0-9]{3}_[0-9]{2}$'::text)),
    CONSTRAINT sealed_needs_state CHECK (((sealed_at IS NULL) OR (lifecycle_state <> 'DISCOVERY'::public.lifecycle_state)))
);


ALTER TABLE public.app OWNER TO frxadmin;

--
-- Name: fit_check; Type: TABLE; Schema: public; Owner: frxadmin
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
    CONSTRAINT fit_done_needs_ts CHECK (((outcome = 'OFFEN'::public.fit_outcome) OR (completed_at IS NOT NULL)))
);


ALTER TABLE public.fit_check OWNER TO frxadmin;

--
-- Name: app_fit_ok; Type: VIEW; Schema: public; Owner: frxadmin
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


ALTER VIEW public.app_fit_ok OWNER TO frxadmin;

--
-- Name: app_state_history; Type: TABLE; Schema: public; Owner: frxadmin
--

CREATE TABLE public.app_state_history (
    app_id uuid NOT NULL,
    state public.lifecycle_state NOT NULL,
    gueltig daterange NOT NULL
);


ALTER TABLE public.app_state_history OWNER TO frxadmin;

--
-- Name: app_state_aktuell; Type: VIEW; Schema: public; Owner: frxadmin
--

CREATE VIEW public.app_state_aktuell AS
 SELECT app_id,
    state,
    lower(gueltig) AS seit
   FROM public.app_state_history h
  WHERE (gueltig @> CURRENT_DATE);


ALTER VIEW public.app_state_aktuell OWNER TO frxadmin;

--
-- Name: approval; Type: TABLE; Schema: public; Owner: frxadmin
--

CREATE TABLE public.approval (
    id uuid DEFAULT gen_random_uuid() NOT NULL,
    object_ref text NOT NULL,
    editor_actor_id uuid NOT NULL,
    approver_actor_id uuid NOT NULL,
    approved_at timestamp with time zone DEFAULT now() NOT NULL,
    CONSTRAINT sod_editor_ne_approver CHECK ((editor_actor_id <> approver_actor_id))
);


ALTER TABLE public.approval OWNER TO frxadmin;

--
-- Name: contact; Type: TABLE; Schema: public; Owner: frxadmin
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


ALTER TABLE public.contact OWNER TO frxadmin;

--
-- Name: direct_prototype; Type: TABLE; Schema: public; Owner: frxadmin
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
    retention_class public.retention_class DEFAULT 'BETRIEBSPROTOKOLL'::public.retention_class NOT NULL,
    retention_until date,
    deleted_at timestamp with time zone,
    CONSTRAINT direct_prototype_source_count_check CHECK ((source_count >= 0)),
    CONSTRAINT proto_is_work_doc CHECK ((artifact_class = 'WORK_DOCUMENT'::public.artifact_class))
);


ALTER TABLE public.direct_prototype OWNER TO frxadmin;

--
-- Name: document; Type: TABLE; Schema: public; Owner: frxadmin
--

CREATE TABLE public.document (
    id uuid DEFAULT gen_random_uuid() NOT NULL,
    app_id uuid NOT NULL,
    kind public.document_kind NOT NULL,
    filename text NOT NULL,
    mime text
);


ALTER TABLE public.document OWNER TO frxadmin;

--
-- Name: event; Type: TABLE; Schema: public; Owner: frxadmin
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
    retention_class public.retention_class DEFAULT 'BETRIEBSPROTOKOLL'::public.retention_class NOT NULL
);


ALTER TABLE public.event OWNER TO frxadmin;

--
-- Name: fit_answer; Type: TABLE; Schema: public; Owner: frxadmin
--

CREATE TABLE public.fit_answer (
    fit_check_id uuid NOT NULL,
    question_code text NOT NULL,
    option_id uuid NOT NULL,
    answered_at timestamp with time zone DEFAULT now() NOT NULL,
    superseded_at timestamp with time zone
);


ALTER TABLE public.fit_answer OWNER TO frxadmin;

--
-- Name: fit_option; Type: TABLE; Schema: public; Owner: frxadmin
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


ALTER TABLE public.fit_option OWNER TO frxadmin;

--
-- Name: fit_question; Type: TABLE; Schema: public; Owner: frxadmin
--

CREATE TABLE public.fit_question (
    code text NOT NULL,
    dimension public.fit_dimension NOT NULL,
    "position" smallint NOT NULL,
    prompt_de text NOT NULL,
    CONSTRAINT fit_question_code_check CHECK ((code ~ '^[a-z_]{3,20}$'::text)),
    CONSTRAINT fit_question_position_check CHECK ((("position" >= 1) AND ("position" <= 9)))
);


ALTER TABLE public.fit_question OWNER TO frxadmin;

--
-- Name: invitation; Type: TABLE; Schema: public; Owner: frxadmin
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


ALTER TABLE public.invitation OWNER TO frxadmin;

--
-- Name: invitation_offen; Type: VIEW; Schema: public; Owner: frxadmin
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


ALTER VIEW public.invitation_offen OWNER TO frxadmin;

--
-- Name: knowledge_module; Type: TABLE; Schema: public; Owner: frxadmin
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


ALTER TABLE public.knowledge_module OWNER TO frxadmin;

--
-- Name: knowledge_module_version; Type: TABLE; Schema: public; Owner: frxadmin
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


ALTER TABLE public.knowledge_module_version OWNER TO frxadmin;

--
-- Name: knowledge_module_aktuell; Type: VIEW; Schema: public; Owner: frxadmin
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


ALTER VIEW public.knowledge_module_aktuell OWNER TO frxadmin;

--
-- Name: knowledge_module_source; Type: TABLE; Schema: public; Owner: frxadmin
--

CREATE TABLE public.knowledge_module_source (
    module_id text NOT NULL,
    source_id text NOT NULL
);


ALTER TABLE public.knowledge_module_source OWNER TO frxadmin;

--
-- Name: knowledge_source; Type: TABLE; Schema: public; Owner: frxadmin
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
    CONSTRAINT knowledge_source_id_check CHECK ((id ~ '^Q-[A-Z0-9]{2,4}-[0-9]{1,4}$'::text)),
    CONSTRAINT knowledge_source_register_no_check CHECK (((register_no IS NULL) OR (register_no ~ '^[A-Z]{2,4}-[0-9]{5}$'::text))),
    CONSTRAINT project_source_needs_ref CHECK (((origin <> 'PROJEKT'::public.knowledge_origin) OR (project_ref IS NOT NULL)))
);


ALTER TABLE public.knowledge_source OWNER TO frxadmin;

--
-- Name: knowledge_source_draft; Type: VIEW; Schema: public; Owner: frxadmin
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


ALTER VIEW public.knowledge_source_draft OWNER TO frxadmin;

--
-- Name: knowledge_source_released; Type: VIEW; Schema: public; Owner: frxadmin
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


ALTER VIEW public.knowledge_source_released OWNER TO frxadmin;

--
-- Name: lifecycle_state_label; Type: TABLE; Schema: public; Owner: frxadmin
--

CREATE TABLE public.lifecycle_state_label (
    state public.lifecycle_state NOT NULL,
    locale public.ui_locale NOT NULL,
    label text NOT NULL
);


ALTER TABLE public.lifecycle_state_label OWNER TO frxadmin;

--
-- Name: membership; Type: TABLE; Schema: public; Owner: frxadmin
--

CREATE TABLE public.membership (
    actor_id uuid NOT NULL,
    portal_code public.portal_code NOT NULL,
    role_id uuid NOT NULL,
    tenant_scope uuid NOT NULL
);


ALTER TABLE public.membership OWNER TO frxadmin;

--
-- Name: model_ref; Type: TABLE; Schema: public; Owner: frxadmin
--

CREATE TABLE public.model_ref (
    id uuid DEFAULT gen_random_uuid() NOT NULL,
    token text NOT NULL,
    provider public.model_provider NOT NULL,
    model text NOT NULL,
    version text DEFAULT 'n/a'::text NOT NULL,
    hosting public.model_hosting NOT NULL
);


ALTER TABLE public.model_ref OWNER TO frxadmin;

--
-- Name: module; Type: TABLE; Schema: public; Owner: frxadmin
--

CREATE TABLE public.module (
    display_code text NOT NULL,
    internal_key text NOT NULL,
    name text NOT NULL,
    portal_code public.portal_code NOT NULL,
    CONSTRAINT module_display_code_check CHECK ((display_code ~ '^M[0-9]{1,2}$'::text))
);


ALTER TABLE public.module OWNER TO frxadmin;

--
-- Name: tenant; Type: TABLE; Schema: public; Owner: frxadmin
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
    CONSTRAINT tenant_invite_ttl_hours_check CHECK (((invite_ttl_hours >= 1) AND (invite_ttl_hours <= 168))),
    CONSTRAINT tenant_processing_region_check CHECK ((processing_region = ANY (ARRAY['swedencentral'::text, 'germanywestcentral'::text, 'westeurope'::text, 'northeurope'::text]))),
    CONSTRAINT tenant_release_relevance_check CHECK ((release_relevance = ANY (ARRAY['R1'::text, 'LATER'::text])))
);


ALTER TABLE public.tenant OWNER TO frxadmin;

--
-- Name: platform_admin; Type: VIEW; Schema: public; Owner: frxadmin
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


ALTER VIEW public.platform_admin OWNER TO frxadmin;

--
-- Name: policy; Type: TABLE; Schema: public; Owner: frxadmin
--

CREATE TABLE public.policy (
    id text NOT NULL,
    name text NOT NULL,
    scope text,
    template_id text,
    CONSTRAINT policy_id_check CHECK ((id ~ '^P-[A-Z]+-[0-9]{3}$'::text))
);


ALTER TABLE public.policy OWNER TO frxadmin;

--
-- Name: policy_version; Type: TABLE; Schema: public; Owner: frxadmin
--

CREATE TABLE public.policy_version (
    policy_id text NOT NULL,
    version text NOT NULL,
    status public.lifecycle_status DEFAULT 'DRAFT'::public.lifecycle_status NOT NULL,
    gueltig daterange NOT NULL,
    editor text,
    aenderungsvermerk text,
    erfasst_am timestamp with time zone DEFAULT now() NOT NULL
);


ALTER TABLE public.policy_version OWNER TO frxadmin;

--
-- Name: policy_aktuell; Type: VIEW; Schema: public; Owner: frxadmin
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
    v.aenderungsvermerk
   FROM (public.policy p
     JOIN public.policy_version v ON ((v.policy_id = p.id)))
  WHERE (v.gueltig @> CURRENT_DATE);


ALTER VIEW public.policy_aktuell OWNER TO frxadmin;

--
-- Name: portal; Type: TABLE; Schema: public; Owner: frxadmin
--

CREATE TABLE public.portal (
    code public.portal_code NOT NULL,
    name text NOT NULL,
    release_status public.release_status DEFAULT 'PLANNED'::public.release_status NOT NULL,
    data_locality text DEFAULT 'EU-Azure/swedencentral'::text NOT NULL
);


ALTER TABLE public.portal OWNER TO frxadmin;

--
-- Name: portal_enabled; Type: VIEW; Schema: public; Owner: frxadmin
--

CREATE VIEW public.portal_enabled AS
 SELECT code,
    name,
    release_status,
    data_locality
   FROM public.portal
  WHERE (release_status = 'ENABLED'::public.release_status);


ALTER VIEW public.portal_enabled OWNER TO frxadmin;

--
-- Name: retention_rule; Type: TABLE; Schema: public; Owner: frxadmin
--

CREATE TABLE public.retention_rule (
    class public.retention_class NOT NULL,
    bezeichnung text NOT NULL,
    fristbeginn public.retention_start NOT NULL,
    regelfrist_monate integer,
    mindestfrist_monate integer NOT NULL,
    pseudonymisieren_nach_monaten integer,
    rechtsgrundlage text NOT NULL,
    CONSTRAINT bezugsobjekt_ohne_frist CHECK (((fristbeginn = 'BEZUGSOBJEKT'::public.retention_start) = (regelfrist_monate IS NULL))),
    CONSTRAINT frist_ge_mindestfrist CHECK (((regelfrist_monate IS NULL) OR (regelfrist_monate >= mindestfrist_monate))),
    CONSTRAINT pseudonym_vor_frist CHECK (((pseudonymisieren_nach_monaten IS NULL) OR (regelfrist_monate IS NULL) OR (pseudonymisieren_nach_monaten <= regelfrist_monate)))
);


ALTER TABLE public.retention_rule OWNER TO frxadmin;

--
-- Name: review_run; Type: TABLE; Schema: public; Owner: frxadmin
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


ALTER TABLE public.review_run OWNER TO frxadmin;

--
-- Name: retention_due; Type: VIEW; Schema: public; Owner: frxadmin
--

CREATE VIEW public.retention_due AS
 WITH regel AS (
         SELECT retention_rule.class,
            retention_rule.bezeichnung,
            retention_rule.fristbeginn,
            retention_rule.regelfrist_monate,
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
    ((e.occurred_at + ((r.regelfrist_monate || ' months'::text))::interval))::date AS faellig_am,
    ((e.occurred_at + ((r.pseudonymisieren_nach_monaten || ' months'::text))::interval))::date AS pseudonymisieren_ab
   FROM (public.event e
     JOIN regel r ON ((r.class = e.retention_class)))
  WHERE (r.fristbeginn = 'ERSTELLUNG'::public.retention_start)
UNION ALL
 SELECT 'direct_prototype'::text AS objekt,
    (p.id)::text AS objekt_id,
    p.retention_class,
    ((p.created_at + ((r.regelfrist_monate || ' months'::text))::interval))::date AS faellig_am,
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
     LEFT JOIN app_faellig f ON ((f.id = v.app_id)));


ALTER VIEW public.retention_due OWNER TO frxadmin;

--
-- Name: review_finding; Type: TABLE; Schema: public; Owner: frxadmin
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


ALTER TABLE public.review_finding OWNER TO frxadmin;

--
-- Name: role; Type: TABLE; Schema: public; Owner: frxadmin
--

CREATE TABLE public.role (
    id uuid DEFAULT gen_random_uuid() NOT NULL,
    portal_code public.portal_code NOT NULL,
    name text NOT NULL
);


ALTER TABLE public.role OWNER TO frxadmin;

--
-- Name: role_right; Type: TABLE; Schema: public; Owner: frxadmin
--

CREATE TABLE public.role_right (
    role_id uuid NOT NULL,
    right_level public.rights_level NOT NULL
);


ALTER TABLE public.role_right OWNER TO frxadmin;

--
-- Name: template; Type: TABLE; Schema: public; Owner: frxadmin
--

CREATE TABLE public.template (
    id text NOT NULL,
    grp public.template_group NOT NULL,
    name text NOT NULL
);


ALTER TABLE public.template OWNER TO frxadmin;

--
-- Name: template_version; Type: TABLE; Schema: public; Owner: frxadmin
--

CREATE TABLE public.template_version (
    template_id text NOT NULL,
    version text NOT NULL,
    status public.lifecycle_status DEFAULT 'DRAFT'::public.lifecycle_status NOT NULL,
    gueltig daterange NOT NULL,
    editor text,
    aenderungsvermerk text,
    erfasst_am timestamp with time zone DEFAULT now() NOT NULL
);


ALTER TABLE public.template_version OWNER TO frxadmin;

--
-- Name: template_aktuell; Type: VIEW; Schema: public; Owner: frxadmin
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


ALTER VIEW public.template_aktuell OWNER TO frxadmin;

--
-- Name: test_harness; Type: TABLE; Schema: public; Owner: frxadmin
--

CREATE TABLE public.test_harness (
    app_id uuid NOT NULL,
    filename text NOT NULL
);


ALTER TABLE public.test_harness OWNER TO frxadmin;

--
-- Name: actor actor_email_key; Type: CONSTRAINT; Schema: public; Owner: frxadmin
--

ALTER TABLE ONLY public.actor
    ADD CONSTRAINT actor_email_key UNIQUE (email);


--
-- Name: actor actor_pkey; Type: CONSTRAINT; Schema: public; Owner: frxadmin
--

ALTER TABLE ONLY public.actor
    ADD CONSTRAINT actor_pkey PRIMARY KEY (id);


--
-- Name: actor actor_user_code_key; Type: CONSTRAINT; Schema: public; Owner: frxadmin
--

ALTER TABLE ONLY public.actor
    ADD CONSTRAINT actor_user_code_key UNIQUE (user_code);


--
-- Name: agent_knowledge agent_knowledge_pkey; Type: CONSTRAINT; Schema: public; Owner: frxadmin
--

ALTER TABLE ONLY public.agent_knowledge
    ADD CONSTRAINT agent_knowledge_pkey PRIMARY KEY (agent_id, module_id);


--
-- Name: agent agent_name_key; Type: CONSTRAINT; Schema: public; Owner: frxadmin
--

ALTER TABLE ONLY public.agent
    ADD CONSTRAINT agent_name_key UNIQUE (name);


--
-- Name: agent agent_pkey; Type: CONSTRAINT; Schema: public; Owner: frxadmin
--

ALTER TABLE ONLY public.agent
    ADD CONSTRAINT agent_pkey PRIMARY KEY (id);


--
-- Name: agent_policy agent_policy_pkey; Type: CONSTRAINT; Schema: public; Owner: frxadmin
--

ALTER TABLE ONLY public.agent_policy
    ADD CONSTRAINT agent_policy_pkey PRIMARY KEY (agent_id, policy_id);


--
-- Name: agent_template agent_template_pkey; Type: CONSTRAINT; Schema: public; Owner: frxadmin
--

ALTER TABLE ONLY public.agent_template
    ADD CONSTRAINT agent_template_pkey PRIMARY KEY (agent_id, template_id);


--
-- Name: app app_pkey; Type: CONSTRAINT; Schema: public; Owner: frxadmin
--

ALTER TABLE ONLY public.app
    ADD CONSTRAINT app_pkey PRIMARY KEY (id);


--
-- Name: app app_project_no_key; Type: CONSTRAINT; Schema: public; Owner: frxadmin
--

ALTER TABLE ONLY public.app
    ADD CONSTRAINT app_project_no_key UNIQUE (project_no);


--
-- Name: app_state_history app_state_history_app_id_gueltig_excl; Type: CONSTRAINT; Schema: public; Owner: frxadmin
--

ALTER TABLE ONLY public.app_state_history
    ADD CONSTRAINT app_state_history_app_id_gueltig_excl EXCLUDE USING gist (app_id WITH =, gueltig WITH &&);


--
-- Name: app_state_history app_state_history_pkey; Type: CONSTRAINT; Schema: public; Owner: frxadmin
--

ALTER TABLE ONLY public.app_state_history
    ADD CONSTRAINT app_state_history_pkey PRIMARY KEY (app_id, gueltig);


--
-- Name: approval approval_pkey; Type: CONSTRAINT; Schema: public; Owner: frxadmin
--

ALTER TABLE ONLY public.approval
    ADD CONSTRAINT approval_pkey PRIMARY KEY (id);


--
-- Name: contact contact_pkey; Type: CONSTRAINT; Schema: public; Owner: frxadmin
--

ALTER TABLE ONLY public.contact
    ADD CONSTRAINT contact_pkey PRIMARY KEY (id);


--
-- Name: contact contact_tenant_id_position_key; Type: CONSTRAINT; Schema: public; Owner: frxadmin
--

ALTER TABLE ONLY public.contact
    ADD CONSTRAINT contact_tenant_id_position_key UNIQUE (tenant_id, "position");


--
-- Name: direct_prototype direct_prototype_pkey; Type: CONSTRAINT; Schema: public; Owner: frxadmin
--

ALTER TABLE ONLY public.direct_prototype
    ADD CONSTRAINT direct_prototype_pkey PRIMARY KEY (id);


--
-- Name: document document_pkey; Type: CONSTRAINT; Schema: public; Owner: frxadmin
--

ALTER TABLE ONLY public.document
    ADD CONSTRAINT document_pkey PRIMARY KEY (id);


--
-- Name: event event_pkey; Type: CONSTRAINT; Schema: public; Owner: frxadmin
--

ALTER TABLE ONLY public.event
    ADD CONSTRAINT event_pkey PRIMARY KEY (id);


--
-- Name: fit_answer fit_answer_pkey; Type: CONSTRAINT; Schema: public; Owner: frxadmin
--

ALTER TABLE ONLY public.fit_answer
    ADD CONSTRAINT fit_answer_pkey PRIMARY KEY (fit_check_id, question_code, option_id);


--
-- Name: fit_check fit_check_pkey; Type: CONSTRAINT; Schema: public; Owner: frxadmin
--

ALTER TABLE ONLY public.fit_check
    ADD CONSTRAINT fit_check_pkey PRIMARY KEY (id);


--
-- Name: fit_option fit_option_pkey; Type: CONSTRAINT; Schema: public; Owner: frxadmin
--

ALTER TABLE ONLY public.fit_option
    ADD CONSTRAINT fit_option_pkey PRIMARY KEY (id);


--
-- Name: fit_option fit_option_question_code_position_key; Type: CONSTRAINT; Schema: public; Owner: frxadmin
--

ALTER TABLE ONLY public.fit_option
    ADD CONSTRAINT fit_option_question_code_position_key UNIQUE (question_code, "position");


--
-- Name: fit_option fit_option_question_code_value_token_key; Type: CONSTRAINT; Schema: public; Owner: frxadmin
--

ALTER TABLE ONLY public.fit_option
    ADD CONSTRAINT fit_option_question_code_value_token_key UNIQUE (question_code, value_token);


--
-- Name: fit_question fit_question_dimension_key; Type: CONSTRAINT; Schema: public; Owner: frxadmin
--

ALTER TABLE ONLY public.fit_question
    ADD CONSTRAINT fit_question_dimension_key UNIQUE (dimension);


--
-- Name: fit_question fit_question_pkey; Type: CONSTRAINT; Schema: public; Owner: frxadmin
--

ALTER TABLE ONLY public.fit_question
    ADD CONSTRAINT fit_question_pkey PRIMARY KEY (code);


--
-- Name: fit_question fit_question_position_key; Type: CONSTRAINT; Schema: public; Owner: frxadmin
--

ALTER TABLE ONLY public.fit_question
    ADD CONSTRAINT fit_question_position_key UNIQUE ("position");


--
-- Name: invitation invitation_pkey; Type: CONSTRAINT; Schema: public; Owner: frxadmin
--

ALTER TABLE ONLY public.invitation
    ADD CONSTRAINT invitation_pkey PRIMARY KEY (id);


--
-- Name: knowledge_module knowledge_module_pkey; Type: CONSTRAINT; Schema: public; Owner: frxadmin
--

ALTER TABLE ONLY public.knowledge_module
    ADD CONSTRAINT knowledge_module_pkey PRIMARY KEY (id);


--
-- Name: knowledge_module_source knowledge_module_source_pkey; Type: CONSTRAINT; Schema: public; Owner: frxadmin
--

ALTER TABLE ONLY public.knowledge_module_source
    ADD CONSTRAINT knowledge_module_source_pkey PRIMARY KEY (module_id, source_id);


--
-- Name: knowledge_module_version knowledge_module_version_module_id_gueltig_excl; Type: CONSTRAINT; Schema: public; Owner: frxadmin
--

ALTER TABLE ONLY public.knowledge_module_version
    ADD CONSTRAINT knowledge_module_version_module_id_gueltig_excl EXCLUDE USING gist (module_id WITH =, gueltig WITH &&);


--
-- Name: knowledge_module_version knowledge_module_version_pkey; Type: CONSTRAINT; Schema: public; Owner: frxadmin
--

ALTER TABLE ONLY public.knowledge_module_version
    ADD CONSTRAINT knowledge_module_version_pkey PRIMARY KEY (module_id, version);


--
-- Name: knowledge_source knowledge_source_pkey; Type: CONSTRAINT; Schema: public; Owner: frxadmin
--

ALTER TABLE ONLY public.knowledge_source
    ADD CONSTRAINT knowledge_source_pkey PRIMARY KEY (id);


--
-- Name: knowledge_source knowledge_source_register_no_key; Type: CONSTRAINT; Schema: public; Owner: frxadmin
--

ALTER TABLE ONLY public.knowledge_source
    ADD CONSTRAINT knowledge_source_register_no_key UNIQUE (register_no);


--
-- Name: lifecycle_state_label lifecycle_state_label_pkey; Type: CONSTRAINT; Schema: public; Owner: frxadmin
--

ALTER TABLE ONLY public.lifecycle_state_label
    ADD CONSTRAINT lifecycle_state_label_pkey PRIMARY KEY (state, locale);


--
-- Name: membership membership_pkey; Type: CONSTRAINT; Schema: public; Owner: frxadmin
--

ALTER TABLE ONLY public.membership
    ADD CONSTRAINT membership_pkey PRIMARY KEY (actor_id, portal_code, role_id, tenant_scope);


--
-- Name: model_ref model_ref_pkey; Type: CONSTRAINT; Schema: public; Owner: frxadmin
--

ALTER TABLE ONLY public.model_ref
    ADD CONSTRAINT model_ref_pkey PRIMARY KEY (id);


--
-- Name: model_ref model_ref_provider_model_version_hosting_key; Type: CONSTRAINT; Schema: public; Owner: frxadmin
--

ALTER TABLE ONLY public.model_ref
    ADD CONSTRAINT model_ref_provider_model_version_hosting_key UNIQUE (provider, model, version, hosting);


--
-- Name: model_ref model_ref_token_key; Type: CONSTRAINT; Schema: public; Owner: frxadmin
--

ALTER TABLE ONLY public.model_ref
    ADD CONSTRAINT model_ref_token_key UNIQUE (token);


--
-- Name: module module_internal_key_key; Type: CONSTRAINT; Schema: public; Owner: frxadmin
--

ALTER TABLE ONLY public.module
    ADD CONSTRAINT module_internal_key_key UNIQUE (internal_key);


--
-- Name: module module_pkey; Type: CONSTRAINT; Schema: public; Owner: frxadmin
--

ALTER TABLE ONLY public.module
    ADD CONSTRAINT module_pkey PRIMARY KEY (display_code);


--
-- Name: policy policy_pkey; Type: CONSTRAINT; Schema: public; Owner: frxadmin
--

ALTER TABLE ONLY public.policy
    ADD CONSTRAINT policy_pkey PRIMARY KEY (id);


--
-- Name: policy_version policy_version_pkey; Type: CONSTRAINT; Schema: public; Owner: frxadmin
--

ALTER TABLE ONLY public.policy_version
    ADD CONSTRAINT policy_version_pkey PRIMARY KEY (policy_id, version);


--
-- Name: policy_version policy_version_policy_id_gueltig_excl; Type: CONSTRAINT; Schema: public; Owner: frxadmin
--

ALTER TABLE ONLY public.policy_version
    ADD CONSTRAINT policy_version_policy_id_gueltig_excl EXCLUDE USING gist (policy_id WITH =, gueltig WITH &&);


--
-- Name: portal portal_pkey; Type: CONSTRAINT; Schema: public; Owner: frxadmin
--

ALTER TABLE ONLY public.portal
    ADD CONSTRAINT portal_pkey PRIMARY KEY (code);


--
-- Name: retention_rule retention_rule_pkey; Type: CONSTRAINT; Schema: public; Owner: frxadmin
--

ALTER TABLE ONLY public.retention_rule
    ADD CONSTRAINT retention_rule_pkey PRIMARY KEY (class);


--
-- Name: review_finding review_finding_pkey; Type: CONSTRAINT; Schema: public; Owner: frxadmin
--

ALTER TABLE ONLY public.review_finding
    ADD CONSTRAINT review_finding_pkey PRIMARY KEY (id);


--
-- Name: review_run review_run_app_id_artifact_version_round_key; Type: CONSTRAINT; Schema: public; Owner: frxadmin
--

ALTER TABLE ONLY public.review_run
    ADD CONSTRAINT review_run_app_id_artifact_version_round_key UNIQUE (app_id, artifact_version, round);


--
-- Name: review_run review_run_pkey; Type: CONSTRAINT; Schema: public; Owner: frxadmin
--

ALTER TABLE ONLY public.review_run
    ADD CONSTRAINT review_run_pkey PRIMARY KEY (id);


--
-- Name: role role_pkey; Type: CONSTRAINT; Schema: public; Owner: frxadmin
--

ALTER TABLE ONLY public.role
    ADD CONSTRAINT role_pkey PRIMARY KEY (id);


--
-- Name: role role_portal_code_name_key; Type: CONSTRAINT; Schema: public; Owner: frxadmin
--

ALTER TABLE ONLY public.role
    ADD CONSTRAINT role_portal_code_name_key UNIQUE (portal_code, name);


--
-- Name: role_right role_right_pkey; Type: CONSTRAINT; Schema: public; Owner: frxadmin
--

ALTER TABLE ONLY public.role_right
    ADD CONSTRAINT role_right_pkey PRIMARY KEY (role_id, right_level);


--
-- Name: template template_pkey; Type: CONSTRAINT; Schema: public; Owner: frxadmin
--

ALTER TABLE ONLY public.template
    ADD CONSTRAINT template_pkey PRIMARY KEY (id);


--
-- Name: template_version template_version_pkey; Type: CONSTRAINT; Schema: public; Owner: frxadmin
--

ALTER TABLE ONLY public.template_version
    ADD CONSTRAINT template_version_pkey PRIMARY KEY (template_id, version);


--
-- Name: template_version template_version_template_id_gueltig_excl; Type: CONSTRAINT; Schema: public; Owner: frxadmin
--

ALTER TABLE ONLY public.template_version
    ADD CONSTRAINT template_version_template_id_gueltig_excl EXCLUDE USING gist (template_id WITH =, gueltig WITH &&);


--
-- Name: tenant tenant_customer_code_key; Type: CONSTRAINT; Schema: public; Owner: frxadmin
--

ALTER TABLE ONLY public.tenant
    ADD CONSTRAINT tenant_customer_code_key UNIQUE (customer_code);


--
-- Name: tenant tenant_pkey; Type: CONSTRAINT; Schema: public; Owner: frxadmin
--

ALTER TABLE ONLY public.tenant
    ADD CONSTRAINT tenant_pkey PRIMARY KEY (id);


--
-- Name: test_harness test_harness_pkey; Type: CONSTRAINT; Schema: public; Owner: frxadmin
--

ALTER TABLE ONLY public.test_harness
    ADD CONSTRAINT test_harness_pkey PRIMARY KEY (app_id);


--
-- Name: actor_tenant_idx; Type: INDEX; Schema: public; Owner: frxadmin
--

CREATE INDEX actor_tenant_idx ON public.actor USING btree (tenant_id);


--
-- Name: agent_knowledge_module_idx; Type: INDEX; Schema: public; Owner: frxadmin
--

CREATE INDEX agent_knowledge_module_idx ON public.agent_knowledge USING btree (module_id);


--
-- Name: app_fit_check_idx; Type: INDEX; Schema: public; Owner: frxadmin
--

CREATE INDEX app_fit_check_idx ON public.app USING btree (fit_check_id);


--
-- Name: app_tenant_idx; Type: INDEX; Schema: public; Owner: frxadmin
--

CREATE INDEX app_tenant_idx ON public.app USING btree (tenant_id);


--
-- Name: approval_approver_idx; Type: INDEX; Schema: public; Owner: frxadmin
--

CREATE INDEX approval_approver_idx ON public.approval USING btree (approver_actor_id);


--
-- Name: approval_editor_idx; Type: INDEX; Schema: public; Owner: frxadmin
--

CREATE INDEX approval_editor_idx ON public.approval USING btree (editor_actor_id);


--
-- Name: contact_tenant_mail_uq; Type: INDEX; Schema: public; Owner: frxadmin
--

CREATE UNIQUE INDEX contact_tenant_mail_uq ON public.contact USING btree (tenant_id, lower(mail)) WHERE (mail IS NOT NULL);


--
-- Name: direct_prototype_actor_idx; Type: INDEX; Schema: public; Owner: frxadmin
--

CREATE INDEX direct_prototype_actor_idx ON public.direct_prototype USING btree (actor_id);


--
-- Name: direct_prototype_tenant_idx; Type: INDEX; Schema: public; Owner: frxadmin
--

CREATE INDEX direct_prototype_tenant_idx ON public.direct_prototype USING btree (tenant_id);


--
-- Name: document_app_idx; Type: INDEX; Schema: public; Owner: frxadmin
--

CREATE INDEX document_app_idx ON public.document USING btree (app_id);


--
-- Name: event_project_idx; Type: INDEX; Schema: public; Owner: frxadmin
--

CREATE INDEX event_project_idx ON public.event USING btree (project_no);


--
-- Name: event_tenant_idx; Type: INDEX; Schema: public; Owner: frxadmin
--

CREATE INDEX event_tenant_idx ON public.event USING btree (tenant_id);


--
-- Name: fit_answer_aktiv_uq; Type: INDEX; Schema: public; Owner: frxadmin
--

CREATE UNIQUE INDEX fit_answer_aktiv_uq ON public.fit_answer USING btree (fit_check_id, question_code) WHERE (superseded_at IS NULL);


--
-- Name: fit_answer_option_idx; Type: INDEX; Schema: public; Owner: frxadmin
--

CREATE INDEX fit_answer_option_idx ON public.fit_answer USING btree (option_id);


--
-- Name: fit_answer_question_idx; Type: INDEX; Schema: public; Owner: frxadmin
--

CREATE INDEX fit_answer_question_idx ON public.fit_answer USING btree (question_code);


--
-- Name: fit_check_actor_idx; Type: INDEX; Schema: public; Owner: frxadmin
--

CREATE INDEX fit_check_actor_idx ON public.fit_check USING btree (actor_id);


--
-- Name: fit_check_app_idx; Type: INDEX; Schema: public; Owner: frxadmin
--

CREATE INDEX fit_check_app_idx ON public.fit_check USING btree (app_id);


--
-- Name: fit_check_tenant_idx; Type: INDEX; Schema: public; Owner: frxadmin
--

CREATE INDEX fit_check_tenant_idx ON public.fit_check USING btree (tenant_id);


--
-- Name: invitation_actor_idx; Type: INDEX; Schema: public; Owner: frxadmin
--

CREATE INDEX invitation_actor_idx ON public.invitation USING btree (actor_id);


--
-- Name: invitation_offen_uq; Type: INDEX; Schema: public; Owner: frxadmin
--

CREATE UNIQUE INDEX invitation_offen_uq ON public.invitation USING btree (actor_id) WHERE (status = 'VERSANDT'::public.invitation_status);


--
-- Name: knowledge_module_source_src_idx; Type: INDEX; Schema: public; Owner: frxadmin
--

CREATE INDEX knowledge_module_source_src_idx ON public.knowledge_module_source USING btree (source_id);


--
-- Name: membership_role_idx; Type: INDEX; Schema: public; Owner: frxadmin
--

CREATE INDEX membership_role_idx ON public.membership USING btree (role_id);


--
-- Name: membership_tenant_scope_idx; Type: INDEX; Schema: public; Owner: frxadmin
--

CREATE INDEX membership_tenant_scope_idx ON public.membership USING btree (tenant_scope);


--
-- Name: review_finding_run_idx; Type: INDEX; Schema: public; Owner: frxadmin
--

CREATE INDEX review_finding_run_idx ON public.review_finding USING btree (review_run_id);


--
-- Name: review_run_model_idx; Type: INDEX; Schema: public; Owner: frxadmin
--

CREATE INDEX review_run_model_idx ON public.review_run USING btree (model_ref_id);


--
-- Name: review_run_rubric_idx; Type: INDEX; Schema: public; Owner: frxadmin
--

CREATE INDEX review_run_rubric_idx ON public.review_run USING btree (rubric_module_id);


--
-- Name: event event_no_delete; Type: RULE; Schema: public; Owner: frxadmin
--

CREATE RULE event_no_delete AS
    ON DELETE TO public.event DO INSTEAD NOTHING;


--
-- Name: event event_no_update; Type: RULE; Schema: public; Owner: frxadmin
--

CREATE RULE event_no_update AS
    ON UPDATE TO public.event DO INSTEAD NOTHING;


--
-- Name: actor actor_platform_admin_guard; Type: TRIGGER; Schema: public; Owner: frxadmin
--

CREATE TRIGGER actor_platform_admin_guard AFTER DELETE OR UPDATE ON public.actor FOR EACH STATEMENT EXECUTE FUNCTION public.platform_admin_guard();


--
-- Name: actor actor_sealed_guard; Type: TRIGGER; Schema: public; Owner: frxadmin
--

CREATE TRIGGER actor_sealed_guard BEFORE DELETE ON public.actor FOR EACH ROW EXECUTE FUNCTION public.sealed_actor_guard();


--
-- Name: invitation invitation_guard_trg; Type: TRIGGER; Schema: public; Owner: frxadmin
--

CREATE TRIGGER invitation_guard_trg BEFORE INSERT OR UPDATE ON public.invitation FOR EACH ROW EXECUTE FUNCTION public.invitation_guard();


--
-- Name: membership membership_platform_admin_guard; Type: TRIGGER; Schema: public; Owner: frxadmin
--

CREATE TRIGGER membership_platform_admin_guard AFTER DELETE OR UPDATE ON public.membership FOR EACH STATEMENT EXECUTE FUNCTION public.platform_admin_guard();


--
-- Name: actor actor_tenant_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: frxadmin
--

ALTER TABLE ONLY public.actor
    ADD CONSTRAINT actor_tenant_id_fkey FOREIGN KEY (tenant_id) REFERENCES public.tenant(id) ON DELETE RESTRICT;


--
-- Name: agent_knowledge agent_knowledge_agent_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: frxadmin
--

ALTER TABLE ONLY public.agent_knowledge
    ADD CONSTRAINT agent_knowledge_agent_id_fkey FOREIGN KEY (agent_id) REFERENCES public.agent(id) ON DELETE CASCADE;


--
-- Name: agent_knowledge agent_knowledge_module_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: frxadmin
--

ALTER TABLE ONLY public.agent_knowledge
    ADD CONSTRAINT agent_knowledge_module_id_fkey FOREIGN KEY (module_id) REFERENCES public.knowledge_module(id) ON DELETE RESTRICT;


--
-- Name: agent agent_model_ref_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: frxadmin
--

ALTER TABLE ONLY public.agent
    ADD CONSTRAINT agent_model_ref_id_fkey FOREIGN KEY (model_ref_id) REFERENCES public.model_ref(id) ON DELETE RESTRICT;


--
-- Name: agent_policy agent_policy_agent_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: frxadmin
--

ALTER TABLE ONLY public.agent_policy
    ADD CONSTRAINT agent_policy_agent_id_fkey FOREIGN KEY (agent_id) REFERENCES public.agent(id) ON DELETE CASCADE;


--
-- Name: agent_policy agent_policy_policy_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: frxadmin
--

ALTER TABLE ONLY public.agent_policy
    ADD CONSTRAINT agent_policy_policy_id_fkey FOREIGN KEY (policy_id) REFERENCES public.policy(id) ON DELETE RESTRICT;


--
-- Name: agent_template agent_template_agent_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: frxadmin
--

ALTER TABLE ONLY public.agent_template
    ADD CONSTRAINT agent_template_agent_id_fkey FOREIGN KEY (agent_id) REFERENCES public.agent(id) ON DELETE CASCADE;


--
-- Name: agent_template agent_template_template_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: frxadmin
--

ALTER TABLE ONLY public.agent_template
    ADD CONSTRAINT agent_template_template_id_fkey FOREIGN KEY (template_id) REFERENCES public.template(id) ON DELETE RESTRICT;


--
-- Name: app app_fit_check_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: frxadmin
--

ALTER TABLE ONLY public.app
    ADD CONSTRAINT app_fit_check_id_fkey FOREIGN KEY (fit_check_id) REFERENCES public.fit_check(id) ON DELETE SET NULL;


--
-- Name: app app_retention_class_fkey; Type: FK CONSTRAINT; Schema: public; Owner: frxadmin
--

ALTER TABLE ONLY public.app
    ADD CONSTRAINT app_retention_class_fkey FOREIGN KEY (retention_class) REFERENCES public.retention_rule(class);


--
-- Name: app_state_history app_state_history_app_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: frxadmin
--

ALTER TABLE ONLY public.app_state_history
    ADD CONSTRAINT app_state_history_app_id_fkey FOREIGN KEY (app_id) REFERENCES public.app(id) ON DELETE CASCADE;


--
-- Name: app app_tenant_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: frxadmin
--

ALTER TABLE ONLY public.app
    ADD CONSTRAINT app_tenant_id_fkey FOREIGN KEY (tenant_id) REFERENCES public.tenant(id) ON DELETE RESTRICT;


--
-- Name: approval approval_approver_actor_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: frxadmin
--

ALTER TABLE ONLY public.approval
    ADD CONSTRAINT approval_approver_actor_id_fkey FOREIGN KEY (approver_actor_id) REFERENCES public.actor(id);


--
-- Name: approval approval_editor_actor_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: frxadmin
--

ALTER TABLE ONLY public.approval
    ADD CONSTRAINT approval_editor_actor_id_fkey FOREIGN KEY (editor_actor_id) REFERENCES public.actor(id);


--
-- Name: contact contact_tenant_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: frxadmin
--

ALTER TABLE ONLY public.contact
    ADD CONSTRAINT contact_tenant_id_fkey FOREIGN KEY (tenant_id) REFERENCES public.tenant(id) ON DELETE CASCADE;


--
-- Name: direct_prototype direct_prototype_actor_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: frxadmin
--

ALTER TABLE ONLY public.direct_prototype
    ADD CONSTRAINT direct_prototype_actor_id_fkey FOREIGN KEY (actor_id) REFERENCES public.actor(id) ON DELETE SET NULL;


--
-- Name: direct_prototype direct_prototype_retention_class_fkey; Type: FK CONSTRAINT; Schema: public; Owner: frxadmin
--

ALTER TABLE ONLY public.direct_prototype
    ADD CONSTRAINT direct_prototype_retention_class_fkey FOREIGN KEY (retention_class) REFERENCES public.retention_rule(class);


--
-- Name: direct_prototype direct_prototype_tenant_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: frxadmin
--

ALTER TABLE ONLY public.direct_prototype
    ADD CONSTRAINT direct_prototype_tenant_id_fkey FOREIGN KEY (tenant_id) REFERENCES public.tenant(id) ON DELETE RESTRICT;


--
-- Name: document document_app_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: frxadmin
--

ALTER TABLE ONLY public.document
    ADD CONSTRAINT document_app_id_fkey FOREIGN KEY (app_id) REFERENCES public.app(id) ON DELETE CASCADE;


--
-- Name: event event_project_no_fkey; Type: FK CONSTRAINT; Schema: public; Owner: frxadmin
--

ALTER TABLE ONLY public.event
    ADD CONSTRAINT event_project_no_fkey FOREIGN KEY (project_no) REFERENCES public.app(project_no) ON DELETE SET NULL;


--
-- Name: event event_retention_class_fkey; Type: FK CONSTRAINT; Schema: public; Owner: frxadmin
--

ALTER TABLE ONLY public.event
    ADD CONSTRAINT event_retention_class_fkey FOREIGN KEY (retention_class) REFERENCES public.retention_rule(class);


--
-- Name: event event_tenant_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: frxadmin
--

ALTER TABLE ONLY public.event
    ADD CONSTRAINT event_tenant_id_fkey FOREIGN KEY (tenant_id) REFERENCES public.tenant(id) ON DELETE SET NULL;


--
-- Name: fit_answer fit_answer_fit_check_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: frxadmin
--

ALTER TABLE ONLY public.fit_answer
    ADD CONSTRAINT fit_answer_fit_check_id_fkey FOREIGN KEY (fit_check_id) REFERENCES public.fit_check(id) ON DELETE CASCADE;


--
-- Name: fit_answer fit_answer_option_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: frxadmin
--

ALTER TABLE ONLY public.fit_answer
    ADD CONSTRAINT fit_answer_option_id_fkey FOREIGN KEY (option_id) REFERENCES public.fit_option(id) ON DELETE RESTRICT;


--
-- Name: fit_answer fit_answer_question_code_fkey; Type: FK CONSTRAINT; Schema: public; Owner: frxadmin
--

ALTER TABLE ONLY public.fit_answer
    ADD CONSTRAINT fit_answer_question_code_fkey FOREIGN KEY (question_code) REFERENCES public.fit_question(code) ON DELETE RESTRICT;


--
-- Name: fit_check fit_check_actor_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: frxadmin
--

ALTER TABLE ONLY public.fit_check
    ADD CONSTRAINT fit_check_actor_id_fkey FOREIGN KEY (actor_id) REFERENCES public.actor(id) ON DELETE SET NULL;


--
-- Name: fit_check fit_check_app_fk; Type: FK CONSTRAINT; Schema: public; Owner: frxadmin
--

ALTER TABLE ONLY public.fit_check
    ADD CONSTRAINT fit_check_app_fk FOREIGN KEY (app_id) REFERENCES public.app(id) ON DELETE SET NULL;


--
-- Name: fit_check fit_check_retention_class_fkey; Type: FK CONSTRAINT; Schema: public; Owner: frxadmin
--

ALTER TABLE ONLY public.fit_check
    ADD CONSTRAINT fit_check_retention_class_fkey FOREIGN KEY (retention_class) REFERENCES public.retention_rule(class);


--
-- Name: fit_check fit_check_tenant_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: frxadmin
--

ALTER TABLE ONLY public.fit_check
    ADD CONSTRAINT fit_check_tenant_id_fkey FOREIGN KEY (tenant_id) REFERENCES public.tenant(id) ON DELETE RESTRICT;


--
-- Name: fit_option fit_option_question_code_fkey; Type: FK CONSTRAINT; Schema: public; Owner: frxadmin
--

ALTER TABLE ONLY public.fit_option
    ADD CONSTRAINT fit_option_question_code_fkey FOREIGN KEY (question_code) REFERENCES public.fit_question(code) ON DELETE CASCADE;


--
-- Name: invitation invitation_actor_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: frxadmin
--

ALTER TABLE ONLY public.invitation
    ADD CONSTRAINT invitation_actor_id_fkey FOREIGN KEY (actor_id) REFERENCES public.actor(id) ON DELETE CASCADE;


--
-- Name: invitation invitation_portal_code_fkey; Type: FK CONSTRAINT; Schema: public; Owner: frxadmin
--

ALTER TABLE ONLY public.invitation
    ADD CONSTRAINT invitation_portal_code_fkey FOREIGN KEY (portal_code) REFERENCES public.portal(code);


--
-- Name: knowledge_module_source knowledge_module_source_module_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: frxadmin
--

ALTER TABLE ONLY public.knowledge_module_source
    ADD CONSTRAINT knowledge_module_source_module_id_fkey FOREIGN KEY (module_id) REFERENCES public.knowledge_module(id) ON DELETE CASCADE;


--
-- Name: knowledge_module_source knowledge_module_source_source_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: frxadmin
--

ALTER TABLE ONLY public.knowledge_module_source
    ADD CONSTRAINT knowledge_module_source_source_id_fkey FOREIGN KEY (source_id) REFERENCES public.knowledge_source(id) ON DELETE RESTRICT;


--
-- Name: knowledge_module_version knowledge_module_version_module_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: frxadmin
--

ALTER TABLE ONLY public.knowledge_module_version
    ADD CONSTRAINT knowledge_module_version_module_id_fkey FOREIGN KEY (module_id) REFERENCES public.knowledge_module(id) ON DELETE CASCADE;


--
-- Name: membership membership_actor_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: frxadmin
--

ALTER TABLE ONLY public.membership
    ADD CONSTRAINT membership_actor_id_fkey FOREIGN KEY (actor_id) REFERENCES public.actor(id) ON DELETE CASCADE;


--
-- Name: membership membership_portal_code_fkey; Type: FK CONSTRAINT; Schema: public; Owner: frxadmin
--

ALTER TABLE ONLY public.membership
    ADD CONSTRAINT membership_portal_code_fkey FOREIGN KEY (portal_code) REFERENCES public.portal(code);


--
-- Name: membership membership_role_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: frxadmin
--

ALTER TABLE ONLY public.membership
    ADD CONSTRAINT membership_role_id_fkey FOREIGN KEY (role_id) REFERENCES public.role(id) ON DELETE RESTRICT;


--
-- Name: membership membership_tenant_scope_fkey; Type: FK CONSTRAINT; Schema: public; Owner: frxadmin
--

ALTER TABLE ONLY public.membership
    ADD CONSTRAINT membership_tenant_scope_fkey FOREIGN KEY (tenant_scope) REFERENCES public.tenant(id) ON DELETE RESTRICT;


--
-- Name: module module_portal_code_fkey; Type: FK CONSTRAINT; Schema: public; Owner: frxadmin
--

ALTER TABLE ONLY public.module
    ADD CONSTRAINT module_portal_code_fkey FOREIGN KEY (portal_code) REFERENCES public.portal(code);


--
-- Name: policy policy_template_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: frxadmin
--

ALTER TABLE ONLY public.policy
    ADD CONSTRAINT policy_template_id_fkey FOREIGN KEY (template_id) REFERENCES public.template(id) ON DELETE SET NULL;


--
-- Name: policy_version policy_version_policy_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: frxadmin
--

ALTER TABLE ONLY public.policy_version
    ADD CONSTRAINT policy_version_policy_id_fkey FOREIGN KEY (policy_id) REFERENCES public.policy(id) ON DELETE CASCADE;


--
-- Name: review_finding review_finding_review_run_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: frxadmin
--

ALTER TABLE ONLY public.review_finding
    ADD CONSTRAINT review_finding_review_run_id_fkey FOREIGN KEY (review_run_id) REFERENCES public.review_run(id) ON DELETE CASCADE;


--
-- Name: review_run review_run_app_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: frxadmin
--

ALTER TABLE ONLY public.review_run
    ADD CONSTRAINT review_run_app_id_fkey FOREIGN KEY (app_id) REFERENCES public.app(id) ON DELETE CASCADE;


--
-- Name: review_run review_run_model_ref_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: frxadmin
--

ALTER TABLE ONLY public.review_run
    ADD CONSTRAINT review_run_model_ref_id_fkey FOREIGN KEY (model_ref_id) REFERENCES public.model_ref(id) ON DELETE RESTRICT;


--
-- Name: review_run review_run_retention_class_fkey; Type: FK CONSTRAINT; Schema: public; Owner: frxadmin
--

ALTER TABLE ONLY public.review_run
    ADD CONSTRAINT review_run_retention_class_fkey FOREIGN KEY (retention_class) REFERENCES public.retention_rule(class);


--
-- Name: review_run review_run_rubric_module_id_rubric_version_fkey; Type: FK CONSTRAINT; Schema: public; Owner: frxadmin
--

ALTER TABLE ONLY public.review_run
    ADD CONSTRAINT review_run_rubric_module_id_rubric_version_fkey FOREIGN KEY (rubric_module_id, rubric_version) REFERENCES public.knowledge_module_version(module_id, version) ON DELETE RESTRICT;


--
-- Name: role role_portal_code_fkey; Type: FK CONSTRAINT; Schema: public; Owner: frxadmin
--

ALTER TABLE ONLY public.role
    ADD CONSTRAINT role_portal_code_fkey FOREIGN KEY (portal_code) REFERENCES public.portal(code);


--
-- Name: role_right role_right_role_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: frxadmin
--

ALTER TABLE ONLY public.role_right
    ADD CONSTRAINT role_right_role_id_fkey FOREIGN KEY (role_id) REFERENCES public.role(id) ON DELETE CASCADE;


--
-- Name: template_version template_version_template_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: frxadmin
--

ALTER TABLE ONLY public.template_version
    ADD CONSTRAINT template_version_template_id_fkey FOREIGN KEY (template_id) REFERENCES public.template(id) ON DELETE CASCADE;


--
-- Name: test_harness test_harness_app_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: frxadmin
--

ALTER TABLE ONLY public.test_harness
    ADD CONSTRAINT test_harness_app_id_fkey FOREIGN KEY (app_id) REFERENCES public.app(id) ON DELETE CASCADE;


--
-- Name: FUNCTION pg_replication_origin_advance(text, pg_lsn); Type: ACL; Schema: pg_catalog; Owner: azuresu
--

GRANT ALL ON FUNCTION pg_catalog.pg_replication_origin_advance(text, pg_lsn) TO azure_pg_admin;


--
-- Name: FUNCTION pg_replication_origin_create(text); Type: ACL; Schema: pg_catalog; Owner: azuresu
--

GRANT ALL ON FUNCTION pg_catalog.pg_replication_origin_create(text) TO azure_pg_admin;


--
-- Name: FUNCTION pg_replication_origin_drop(text); Type: ACL; Schema: pg_catalog; Owner: azuresu
--

GRANT ALL ON FUNCTION pg_catalog.pg_replication_origin_drop(text) TO azure_pg_admin;


--
-- Name: FUNCTION pg_replication_origin_oid(text); Type: ACL; Schema: pg_catalog; Owner: azuresu
--

GRANT ALL ON FUNCTION pg_catalog.pg_replication_origin_oid(text) TO azure_pg_admin;


--
-- Name: FUNCTION pg_replication_origin_progress(text, boolean); Type: ACL; Schema: pg_catalog; Owner: azuresu
--

GRANT ALL ON FUNCTION pg_catalog.pg_replication_origin_progress(text, boolean) TO azure_pg_admin;


--
-- Name: FUNCTION pg_replication_origin_session_is_setup(); Type: ACL; Schema: pg_catalog; Owner: azuresu
--

GRANT ALL ON FUNCTION pg_catalog.pg_replication_origin_session_is_setup() TO azure_pg_admin;


--
-- Name: FUNCTION pg_replication_origin_session_progress(boolean); Type: ACL; Schema: pg_catalog; Owner: azuresu
--

GRANT ALL ON FUNCTION pg_catalog.pg_replication_origin_session_progress(boolean) TO azure_pg_admin;


--
-- Name: FUNCTION pg_replication_origin_session_reset(); Type: ACL; Schema: pg_catalog; Owner: azuresu
--

GRANT ALL ON FUNCTION pg_catalog.pg_replication_origin_session_reset() TO azure_pg_admin;


--
-- Name: FUNCTION pg_replication_origin_session_setup(text); Type: ACL; Schema: pg_catalog; Owner: azuresu
--

GRANT ALL ON FUNCTION pg_catalog.pg_replication_origin_session_setup(text) TO azure_pg_admin;


--
-- Name: FUNCTION pg_replication_origin_xact_reset(); Type: ACL; Schema: pg_catalog; Owner: azuresu
--

GRANT ALL ON FUNCTION pg_catalog.pg_replication_origin_xact_reset() TO azure_pg_admin;


--
-- Name: FUNCTION pg_replication_origin_xact_setup(pg_lsn, timestamp with time zone); Type: ACL; Schema: pg_catalog; Owner: azuresu
--

GRANT ALL ON FUNCTION pg_catalog.pg_replication_origin_xact_setup(pg_lsn, timestamp with time zone) TO azure_pg_admin;


--
-- Name: FUNCTION pg_show_replication_origin_status(OUT local_id oid, OUT external_id text, OUT remote_lsn pg_lsn, OUT local_lsn pg_lsn); Type: ACL; Schema: pg_catalog; Owner: azuresu
--

GRANT ALL ON FUNCTION pg_catalog.pg_show_replication_origin_status(OUT local_id oid, OUT external_id text, OUT remote_lsn pg_lsn, OUT local_lsn pg_lsn) TO azure_pg_admin;


--
-- Name: FUNCTION pg_stat_reset(); Type: ACL; Schema: pg_catalog; Owner: azuresu
--

GRANT ALL ON FUNCTION pg_catalog.pg_stat_reset() TO azure_pg_admin;


--
-- Name: FUNCTION pg_stat_reset_shared(text); Type: ACL; Schema: pg_catalog; Owner: azuresu
--

GRANT ALL ON FUNCTION pg_catalog.pg_stat_reset_shared(text) TO azure_pg_admin;


--
-- Name: FUNCTION pg_stat_reset_single_function_counters(oid); Type: ACL; Schema: pg_catalog; Owner: azuresu
--

GRANT ALL ON FUNCTION pg_catalog.pg_stat_reset_single_function_counters(oid) TO azure_pg_admin;


--
-- Name: FUNCTION pg_stat_reset_single_table_counters(oid); Type: ACL; Schema: pg_catalog; Owner: azuresu
--

GRANT ALL ON FUNCTION pg_catalog.pg_stat_reset_single_table_counters(oid) TO azure_pg_admin;


--
-- Name: COLUMN pg_config.name; Type: ACL; Schema: pg_catalog; Owner: azuresu
--

GRANT SELECT(name) ON TABLE pg_catalog.pg_config TO azure_pg_admin;


--
-- Name: COLUMN pg_config.setting; Type: ACL; Schema: pg_catalog; Owner: azuresu
--

GRANT SELECT(setting) ON TABLE pg_catalog.pg_config TO azure_pg_admin;


--
-- Name: COLUMN pg_hba_file_rules.line_number; Type: ACL; Schema: pg_catalog; Owner: azuresu
--

GRANT SELECT(line_number) ON TABLE pg_catalog.pg_hba_file_rules TO azure_pg_admin;


--
-- Name: COLUMN pg_hba_file_rules.type; Type: ACL; Schema: pg_catalog; Owner: azuresu
--

GRANT SELECT(type) ON TABLE pg_catalog.pg_hba_file_rules TO azure_pg_admin;


--
-- Name: COLUMN pg_hba_file_rules.database; Type: ACL; Schema: pg_catalog; Owner: azuresu
--

GRANT SELECT(database) ON TABLE pg_catalog.pg_hba_file_rules TO azure_pg_admin;


--
-- Name: COLUMN pg_hba_file_rules.user_name; Type: ACL; Schema: pg_catalog; Owner: azuresu
--

GRANT SELECT(user_name) ON TABLE pg_catalog.pg_hba_file_rules TO azure_pg_admin;


--
-- Name: COLUMN pg_hba_file_rules.address; Type: ACL; Schema: pg_catalog; Owner: azuresu
--

GRANT SELECT(address) ON TABLE pg_catalog.pg_hba_file_rules TO azure_pg_admin;


--
-- Name: COLUMN pg_hba_file_rules.netmask; Type: ACL; Schema: pg_catalog; Owner: azuresu
--

GRANT SELECT(netmask) ON TABLE pg_catalog.pg_hba_file_rules TO azure_pg_admin;


--
-- Name: COLUMN pg_hba_file_rules.auth_method; Type: ACL; Schema: pg_catalog; Owner: azuresu
--

GRANT SELECT(auth_method) ON TABLE pg_catalog.pg_hba_file_rules TO azure_pg_admin;


--
-- Name: COLUMN pg_hba_file_rules.options; Type: ACL; Schema: pg_catalog; Owner: azuresu
--

GRANT SELECT(options) ON TABLE pg_catalog.pg_hba_file_rules TO azure_pg_admin;


--
-- Name: COLUMN pg_hba_file_rules.error; Type: ACL; Schema: pg_catalog; Owner: azuresu
--

GRANT SELECT(error) ON TABLE pg_catalog.pg_hba_file_rules TO azure_pg_admin;


--
-- Name: COLUMN pg_replication_origin_status.local_id; Type: ACL; Schema: pg_catalog; Owner: azuresu
--

GRANT SELECT(local_id) ON TABLE pg_catalog.pg_replication_origin_status TO azure_pg_admin;


--
-- Name: COLUMN pg_replication_origin_status.external_id; Type: ACL; Schema: pg_catalog; Owner: azuresu
--

GRANT SELECT(external_id) ON TABLE pg_catalog.pg_replication_origin_status TO azure_pg_admin;


--
-- Name: COLUMN pg_replication_origin_status.remote_lsn; Type: ACL; Schema: pg_catalog; Owner: azuresu
--

GRANT SELECT(remote_lsn) ON TABLE pg_catalog.pg_replication_origin_status TO azure_pg_admin;


--
-- Name: COLUMN pg_replication_origin_status.local_lsn; Type: ACL; Schema: pg_catalog; Owner: azuresu
--

GRANT SELECT(local_lsn) ON TABLE pg_catalog.pg_replication_origin_status TO azure_pg_admin;


--
-- Name: COLUMN pg_shmem_allocations.name; Type: ACL; Schema: pg_catalog; Owner: azuresu
--

GRANT SELECT(name) ON TABLE pg_catalog.pg_shmem_allocations TO azure_pg_admin;


--
-- Name: COLUMN pg_shmem_allocations.off; Type: ACL; Schema: pg_catalog; Owner: azuresu
--

GRANT SELECT(off) ON TABLE pg_catalog.pg_shmem_allocations TO azure_pg_admin;


--
-- Name: COLUMN pg_shmem_allocations.size; Type: ACL; Schema: pg_catalog; Owner: azuresu
--

GRANT SELECT(size) ON TABLE pg_catalog.pg_shmem_allocations TO azure_pg_admin;


--
-- Name: COLUMN pg_shmem_allocations.allocated_size; Type: ACL; Schema: pg_catalog; Owner: azuresu
--

GRANT SELECT(allocated_size) ON TABLE pg_catalog.pg_shmem_allocations TO azure_pg_admin;


--
-- Name: COLUMN pg_statistic.starelid; Type: ACL; Schema: pg_catalog; Owner: azuresu
--

GRANT SELECT(starelid) ON TABLE pg_catalog.pg_statistic TO azure_pg_admin;


--
-- Name: COLUMN pg_statistic.staattnum; Type: ACL; Schema: pg_catalog; Owner: azuresu
--

GRANT SELECT(staattnum) ON TABLE pg_catalog.pg_statistic TO azure_pg_admin;


--
-- Name: COLUMN pg_statistic.stainherit; Type: ACL; Schema: pg_catalog; Owner: azuresu
--

GRANT SELECT(stainherit) ON TABLE pg_catalog.pg_statistic TO azure_pg_admin;


--
-- Name: COLUMN pg_statistic.stanullfrac; Type: ACL; Schema: pg_catalog; Owner: azuresu
--

GRANT SELECT(stanullfrac) ON TABLE pg_catalog.pg_statistic TO azure_pg_admin;


--
-- Name: COLUMN pg_statistic.stawidth; Type: ACL; Schema: pg_catalog; Owner: azuresu
--

GRANT SELECT(stawidth) ON TABLE pg_catalog.pg_statistic TO azure_pg_admin;


--
-- Name: COLUMN pg_statistic.stadistinct; Type: ACL; Schema: pg_catalog; Owner: azuresu
--

GRANT SELECT(stadistinct) ON TABLE pg_catalog.pg_statistic TO azure_pg_admin;


--
-- Name: COLUMN pg_statistic.stakind1; Type: ACL; Schema: pg_catalog; Owner: azuresu
--

GRANT SELECT(stakind1) ON TABLE pg_catalog.pg_statistic TO azure_pg_admin;


--
-- Name: COLUMN pg_statistic.stakind2; Type: ACL; Schema: pg_catalog; Owner: azuresu
--

GRANT SELECT(stakind2) ON TABLE pg_catalog.pg_statistic TO azure_pg_admin;


--
-- Name: COLUMN pg_statistic.stakind3; Type: ACL; Schema: pg_catalog; Owner: azuresu
--

GRANT SELECT(stakind3) ON TABLE pg_catalog.pg_statistic TO azure_pg_admin;


--
-- Name: COLUMN pg_statistic.stakind4; Type: ACL; Schema: pg_catalog; Owner: azuresu
--

GRANT SELECT(stakind4) ON TABLE pg_catalog.pg_statistic TO azure_pg_admin;


--
-- Name: COLUMN pg_statistic.stakind5; Type: ACL; Schema: pg_catalog; Owner: azuresu
--

GRANT SELECT(stakind5) ON TABLE pg_catalog.pg_statistic TO azure_pg_admin;


--
-- Name: COLUMN pg_statistic.staop1; Type: ACL; Schema: pg_catalog; Owner: azuresu
--

GRANT SELECT(staop1) ON TABLE pg_catalog.pg_statistic TO azure_pg_admin;


--
-- Name: COLUMN pg_statistic.staop2; Type: ACL; Schema: pg_catalog; Owner: azuresu
--

GRANT SELECT(staop2) ON TABLE pg_catalog.pg_statistic TO azure_pg_admin;


--
-- Name: COLUMN pg_statistic.staop3; Type: ACL; Schema: pg_catalog; Owner: azuresu
--

GRANT SELECT(staop3) ON TABLE pg_catalog.pg_statistic TO azure_pg_admin;


--
-- Name: COLUMN pg_statistic.staop4; Type: ACL; Schema: pg_catalog; Owner: azuresu
--

GRANT SELECT(staop4) ON TABLE pg_catalog.pg_statistic TO azure_pg_admin;


--
-- Name: COLUMN pg_statistic.staop5; Type: ACL; Schema: pg_catalog; Owner: azuresu
--

GRANT SELECT(staop5) ON TABLE pg_catalog.pg_statistic TO azure_pg_admin;


--
-- Name: COLUMN pg_statistic.stacoll1; Type: ACL; Schema: pg_catalog; Owner: azuresu
--

GRANT SELECT(stacoll1) ON TABLE pg_catalog.pg_statistic TO azure_pg_admin;


--
-- Name: COLUMN pg_statistic.stacoll2; Type: ACL; Schema: pg_catalog; Owner: azuresu
--

GRANT SELECT(stacoll2) ON TABLE pg_catalog.pg_statistic TO azure_pg_admin;


--
-- Name: COLUMN pg_statistic.stacoll3; Type: ACL; Schema: pg_catalog; Owner: azuresu
--

GRANT SELECT(stacoll3) ON TABLE pg_catalog.pg_statistic TO azure_pg_admin;


--
-- Name: COLUMN pg_statistic.stacoll4; Type: ACL; Schema: pg_catalog; Owner: azuresu
--

GRANT SELECT(stacoll4) ON TABLE pg_catalog.pg_statistic TO azure_pg_admin;


--
-- Name: COLUMN pg_statistic.stacoll5; Type: ACL; Schema: pg_catalog; Owner: azuresu
--

GRANT SELECT(stacoll5) ON TABLE pg_catalog.pg_statistic TO azure_pg_admin;


--
-- Name: COLUMN pg_statistic.stanumbers1; Type: ACL; Schema: pg_catalog; Owner: azuresu
--

GRANT SELECT(stanumbers1) ON TABLE pg_catalog.pg_statistic TO azure_pg_admin;


--
-- Name: COLUMN pg_statistic.stanumbers2; Type: ACL; Schema: pg_catalog; Owner: azuresu
--

GRANT SELECT(stanumbers2) ON TABLE pg_catalog.pg_statistic TO azure_pg_admin;


--
-- Name: COLUMN pg_statistic.stanumbers3; Type: ACL; Schema: pg_catalog; Owner: azuresu
--

GRANT SELECT(stanumbers3) ON TABLE pg_catalog.pg_statistic TO azure_pg_admin;


--
-- Name: COLUMN pg_statistic.stanumbers4; Type: ACL; Schema: pg_catalog; Owner: azuresu
--

GRANT SELECT(stanumbers4) ON TABLE pg_catalog.pg_statistic TO azure_pg_admin;


--
-- Name: COLUMN pg_statistic.stanumbers5; Type: ACL; Schema: pg_catalog; Owner: azuresu
--

GRANT SELECT(stanumbers5) ON TABLE pg_catalog.pg_statistic TO azure_pg_admin;


--
-- Name: COLUMN pg_statistic.stavalues1; Type: ACL; Schema: pg_catalog; Owner: azuresu
--

GRANT SELECT(stavalues1) ON TABLE pg_catalog.pg_statistic TO azure_pg_admin;


--
-- Name: COLUMN pg_statistic.stavalues2; Type: ACL; Schema: pg_catalog; Owner: azuresu
--

GRANT SELECT(stavalues2) ON TABLE pg_catalog.pg_statistic TO azure_pg_admin;


--
-- Name: COLUMN pg_statistic.stavalues3; Type: ACL; Schema: pg_catalog; Owner: azuresu
--

GRANT SELECT(stavalues3) ON TABLE pg_catalog.pg_statistic TO azure_pg_admin;


--
-- Name: COLUMN pg_statistic.stavalues4; Type: ACL; Schema: pg_catalog; Owner: azuresu
--

GRANT SELECT(stavalues4) ON TABLE pg_catalog.pg_statistic TO azure_pg_admin;


--
-- Name: COLUMN pg_statistic.stavalues5; Type: ACL; Schema: pg_catalog; Owner: azuresu
--

GRANT SELECT(stavalues5) ON TABLE pg_catalog.pg_statistic TO azure_pg_admin;


--
-- Name: COLUMN pg_subscription.oid; Type: ACL; Schema: pg_catalog; Owner: azuresu
--

GRANT SELECT(oid) ON TABLE pg_catalog.pg_subscription TO azure_pg_admin;


--
-- Name: COLUMN pg_subscription.subdbid; Type: ACL; Schema: pg_catalog; Owner: azuresu
--

GRANT SELECT(subdbid) ON TABLE pg_catalog.pg_subscription TO azure_pg_admin;


--
-- Name: COLUMN pg_subscription.subname; Type: ACL; Schema: pg_catalog; Owner: azuresu
--

GRANT SELECT(subname) ON TABLE pg_catalog.pg_subscription TO azure_pg_admin;


--
-- Name: COLUMN pg_subscription.subowner; Type: ACL; Schema: pg_catalog; Owner: azuresu
--

GRANT SELECT(subowner) ON TABLE pg_catalog.pg_subscription TO azure_pg_admin;


--
-- Name: COLUMN pg_subscription.subenabled; Type: ACL; Schema: pg_catalog; Owner: azuresu
--

GRANT SELECT(subenabled) ON TABLE pg_catalog.pg_subscription TO azure_pg_admin;


--
-- Name: COLUMN pg_subscription.subconninfo; Type: ACL; Schema: pg_catalog; Owner: azuresu
--

GRANT SELECT(subconninfo) ON TABLE pg_catalog.pg_subscription TO azure_pg_admin;


--
-- Name: COLUMN pg_subscription.subslotname; Type: ACL; Schema: pg_catalog; Owner: azuresu
--

GRANT SELECT(subslotname) ON TABLE pg_catalog.pg_subscription TO azure_pg_admin;


--
-- Name: COLUMN pg_subscription.subsynccommit; Type: ACL; Schema: pg_catalog; Owner: azuresu
--

GRANT SELECT(subsynccommit) ON TABLE pg_catalog.pg_subscription TO azure_pg_admin;


--
-- Name: COLUMN pg_subscription.subpublications; Type: ACL; Schema: pg_catalog; Owner: azuresu
--

GRANT SELECT(subpublications) ON TABLE pg_catalog.pg_subscription TO azure_pg_admin;


--
-- PostgreSQL database dump complete
--


