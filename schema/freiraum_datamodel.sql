-- =====================================================================
-- FREIRAUM - Optimiertes Datenmodell v2.9  (PostgreSQL DDL)
-- Quelle: FREIRAUM_Gesamtbuild_v2.9.html (Repo v2.9_PIVOT)
-- Vorgaenger: freiraum_datamodel_v2.8 (Repo v2.8_PIVOT)
-- Grundsatz: DDD-Antizipation im Schema, YAGNI im Verhalten.
--            Release 1 = ENDUSER + EXMA. Uebrige Portale = PLANNED (Daten, kein Routing).
--
-- Neu in v2.9 (Delta gegenueber v2.8):
--   * Die Journey hat fuenf Stufen. Die Stufe MITBESTIMMUNG entfaellt: Der Build hat sie nie
--     angesteuert (advancePhase(4) existierte nicht), und der Versand der Memos an Betriebsrat
--     und Datenschutzbeauftragte ist fachlich nicht gewollt -- die Informationspflicht trifft
--     den Betreiber, nicht FREIRAUM.
--   * APP.mitbestimmung_ack_at: Die Memos entstehen unveraendert; belegt wird ihre Uebergabe.
--     Die Bestaetigung entsteht im selben Akt wie die Angebotsanforderung.
--
-- Aus v2.8 unveraendert uebernommen: Zugaenge & Nutzer (ACTOR + MEMBERSHIP), INVITATION,
-- Einladungsverfahren und Region am Mandanten, die drei zeilenuebergreifenden Invarianten.
-- =====================================================================

BEGIN;

-- ---------- ENUM-TYPEN (kanonisch) ----------
CREATE TYPE portal_code      AS ENUM ('ENDUSER','USER_ADMIN','VAR_ADMIN','EXMA','INDIA_OPS');
CREATE TYPE release_status   AS ENUM ('ENABLED','PLANNED');
CREATE TYPE tenant_kind      AS ENUM ('OPERATOR','CUSTOMER','PARTNER');
CREATE TYPE legal_space      AS ENUM ('DE','EU27_REST','UK','CH','US_NEXUS_VENDOR');
CREATE TYPE rights_level     AS ENUM ('L','V','F','A');   -- Lesen, Vorschlagen, Freigeben, Admin
CREATE TYPE lifecycle_state  AS ENUM ('EINGELADEN','DISCOVERY','IN_BEARBEITUNG','BEAUFTRAGT','IN_DEV','ABNAHME','IN_PROD','PAUSIERT');
CREATE TYPE knowledge_type   AS ENUM ('GITHUB','MCP','WEB','API','OSS','MD','PDF','DOCX','CSV');
CREATE TYPE knowledge_mode   AS ENUM ('DYNAMIC','FIXED');
CREATE TYPE lifecycle_status AS ENUM ('DRAFT','IN_REVIEW','RELEASED','RETIRED');  -- v2.7: 4 Werte (war DRAFT/RELEASED)
CREATE TYPE template_group   AS ENUM ('DOCUMENT','DESIGN','DIALOG','POLICY');     -- v2.7: POLICY als 4. Gruppe
-- policy_status entfaellt: der Status liegt seit BF-4 an der Versionszeile (lifecycle_status).
CREATE TYPE agent_status     AS ENUM ('RELEASED','IN_REVIEW');
CREATE TYPE catalog_group    AS ENUM ('TEAM','SINGLE');
CREATE TYPE event_source     AS ENUM ('PORTAL_ACTION','MODEL_CHANGE');

-- v2.7 NEU
CREATE TYPE ui_locale        AS ENUM ('DE','EN');
-- v2.9: fuenf Stufen. Die Stufe MITBESTIMMUNG ist entfallen -- der Build hat sie
-- nie angesteuert (advancePhase(4) existierte nicht), und das Versenden der Memos an
-- Betriebsrat und Datenschutzbeauftragte ist fachlich nicht gewollt: Die Informationspflicht
-- trifft den Betreiber, nicht FREIRAUM. Die Memos entstehen unveraendert; ihre Uebergabe wird
-- als Empfangsbestaetigung an APP festgehalten (siehe app.mitbestimmung_ack_at).
CREATE TYPE journey_phase    AS ENUM ('ORIENTIERUNG','INTERVIEW','UEBERSICHT','PROTOTYP','ANGEBOT');
CREATE TYPE fit_dimension    AS ENUM ('ART','NUTZUNG','DATEN');
CREATE TYPE fit_outcome      AS ENUM ('OFFEN','GEEIGNET','NICHT_GEEIGNET');
CREATE TYPE mfa_method       AS ENUM ('EMAIL_CODE','OFF');
CREATE TYPE legal_form       AS ENUM ('GMBH','GMBH_CO_KG','AG','KG','EK');
CREATE TYPE model_provider   AS ENUM ('ANTHROPIC','OPENAI','INTERN','OFFEN');
CREATE TYPE model_hosting    AS ENUM ('AZURE_EU','ON_PREM_DE','OFFEN');
CREATE TYPE artifact_class   AS ENUM ('VERIFIED_APP','WORK_DOCUMENT');
CREATE TYPE knowledge_origin AS ENUM ('EXTERN','PROJEKT');
CREATE TYPE knowledge_group  AS ENUM ('BRANCHENWISSEN','FUNKTIONSWISSEN','METHODENWISSEN');
-- Review-Befund BF-3: Betraege brauchen eine Waehrung. Werte nach ISO 4217, beschraenkt auf
-- die Kunden-Rechtsraeume aus LEGAL_SPACE (DE/EU27_REST -> EUR, UK -> GBP, CH -> CHF).
-- Bewusst als Enum statt text+CHECK, konsistent mit der Domaenendisziplin des Modells (BF-11).
CREATE TYPE currency_code    AS ENUM ('EUR','GBP','CHF');
-- Loeschklassen nach DIN 66398 (Loeschklasse = Fristbeginn + Regelfrist).
-- Drei Datenklassen; der Umgang mit Personenbezug ist KEINE vierte Klasse, sondern ein
-- Attribut der Regel (pseudonymisieren_nach_monaten) -- siehe Kommentar an retention_rule.
CREATE TYPE retention_class AS ENUM ('HANDELSRECHT','KI_NACHWEIS','BETRIEBSPROTOKOLL');
CREATE TYPE retention_start AS ENUM ('ENTSTEHUNGSJAHRESENDE','ERSTELLUNG','BEZUGSOBJEKT');
-- Dokumentarten als Domaene statt als Kommentar (Review-Befund BF-11). Die Loeschklasse
-- wird aus der Art abgeleitet, nicht je Zeile gespeichert -- eine ableitbare Spalte waere
-- genau die Redundanz, die BF-9 ruegt. Die Zuordnung steht in der Sicht retention_due.
CREATE TYPE document_kind   AS ENUM ('INTERVIEW_PROTOCOL','CONCEPT','MEMO','SBOM','ORDER','REVIEW_FINDING','UX_HANDOFF');

-- v2.8 NEU
-- Der Nutzerzustand des Builds ('aktiv' / 'wartet auf 2FA' / 'gesperrt') war in v2.7 Freitext
-- in ACTOR.status. Er ist eine geschlossene Domaene und gehoert damit -- wie alle uebrigen
-- Zustaende dieses Modells -- in ein Enum (Review-Befund BF-11 aus v2.7, jetzt eingeloest).
CREATE TYPE actor_status      AS ENUM ('AKTIV','WARTET_2FA','GESPERRT');
-- Lebenslauf einer Einladung. WIDERRUFEN entsteht beim Wiederversand: der alte Link verliert
-- seine Gueltigkeit, bleibt aber als Nachweis stehen (append-only-Gedanke wie bei EVENT).
CREATE TYPE invitation_status AS ENUM ('VERSANDT','EINGELOEST','ABGELAUFEN','WIDERRUFEN');

-- ---------- ZUGRIFFSKONTROLLE ----------
CREATE TABLE portal (
  code            portal_code    PRIMARY KEY,
  name            text           NOT NULL,
  release_status  release_status NOT NULL DEFAULT 'PLANNED',
  data_locality   text           NOT NULL DEFAULT 'EU-Azure/swedencentral'
);

-- v2.7 NEU: Modul-Register loest den Key-Drift D9 auf (Anzeige ist kanonisch)
CREATE TABLE module (
  display_code text PRIMARY KEY CHECK (display_code ~ '^M[0-9]{1,2}$'),
  internal_key text NOT NULL UNIQUE,
  name         text NOT NULL,
  portal_code  portal_code NOT NULL REFERENCES portal(code)
);

-- ---------- AUFBEWAHRUNG / LOESCHKONZEPT (Vorschlag, rechtlich zu bestaetigen) ----------
-- Die Regel ist Datum, nicht Code: Fristen sind abfragbar und im Audit vorzeigbar.
-- Zielkonflikt, den die Tabelle aufloest: Der EU AI Act setzt eine Untergrenze (6 Monate),
-- Handels- und Steuerrecht setzen lange Untergrenzen fuer einen Teil der Daten, die DSGVO
-- setzt eine Obergrenze. Deshalb keine einheitliche Frist, sondern Klassen.
-- Zur "vierten Klasse" aus dem Vorschlag: Der Personenbezug in KI_NACHWEIS und
-- BETRIEBSPROTOKOLL ist keine eigene Datenklasse, sondern eine Behandlungsregel auf
-- Feldebene. Er ist deshalb als Spalte der Regel modelliert, nicht als Enum-Wert --
-- sonst stuenden zwei verschiedene Achsen in derselben Werteliste.
CREATE TABLE retention_rule (
  class                         retention_class PRIMARY KEY,
  bezeichnung                   text            NOT NULL,
  fristbeginn                   retention_start NOT NULL,
  regelfrist_monate             integer,          -- NULL = an das Bezugsobjekt gekoppelt
  mindestfrist_monate           integer         NOT NULL,  -- gesetzliche Untergrenze
  pseudonymisieren_nach_monaten integer,          -- Ende des Personenbezugs, Nachweis bleibt
  rechtsgrundlage               text            NOT NULL,
  CONSTRAINT frist_ge_mindestfrist CHECK (regelfrist_monate IS NULL OR regelfrist_monate >= mindestfrist_monate),
  CONSTRAINT pseudonym_vor_frist   CHECK (pseudonymisieren_nach_monaten IS NULL
                                          OR regelfrist_monate IS NULL
                                          OR pseudonymisieren_nach_monaten <= regelfrist_monate),
  CONSTRAINT bezugsobjekt_ohne_frist CHECK ((fristbeginn = 'BEZUGSOBJEKT') = (regelfrist_monate IS NULL))
);

CREATE TABLE tenant (
  id                uuid PRIMARY KEY DEFAULT gen_random_uuid(),
  kind              tenant_kind  NOT NULL,
  name              text         NOT NULL,                  -- Pflichtfeld (UI: "Firmenname *")
  customer_code     text         UNIQUE,                    -- Muster DE-XXX (Registry)
  legal_form        legal_form,                             -- v2.7: Enum statt Freitext
  website           text,
  address           text,
  legal_space       legal_space  NOT NULL,
  mfa_policy        mfa_method   NOT NULL DEFAULT 'EMAIL_CODE',  -- v2.7: organisationsweite 2FA-Richtlinie
  -- v2.8: Einladungsverfahren als Konfiguration, nicht als Konstante im Programmtext.
  -- Der Build fuehrt beides als Variable (EXMA_INVFRIST = 24, EXMA_DOM = 'exmachinai.com');
  -- fachlich ist es eine Eigenschaft der Organisation, die einlaedt.
  invite_ttl_hours  smallint     NOT NULL DEFAULT 24
                                 CHECK (invite_ttl_hours BETWEEN 1 AND 168),
  invite_domain     text,        -- NULL = keine Schranke; sonst nur Adressen dieser Domaene
  -- v2.8: Verarbeitungsregion. Datenlokalitaet ist eine Eigenschaft des Mandanten, nicht
  -- des einzelnen Nutzers -- der Build zeigt sie am Admin, gemeint ist die Plattform.
  -- Werteliste identisch zu RESIDENCY_ALLOWED des Builds.
  processing_region text         NOT NULL DEFAULT 'swedencentral'
                                 CHECK (processing_region IN ('swedencentral','germanywestcentral',
                                                              'westeurope','northeurope')),
  release_relevance text         NOT NULL DEFAULT 'R1' CHECK (release_relevance IN ('R1','LATER')),
  deleted_at        timestamptz,                            -- Soft-Delete: Kunden nicht physisch loeschbar
  CONSTRAINT customer_needs_code CHECK (kind <> 'CUSTOMER' OR customer_code IS NOT NULL),
  CONSTRAINT customer_code_fmt   CHECK (customer_code IS NULL OR customer_code ~ '^DE-[A-Z]{3}$')
);

CREATE TABLE actor (
  id           uuid PRIMARY KEY DEFAULT gen_random_uuid(),
  tenant_id    uuid NOT NULL REFERENCES tenant(id) ON DELETE RESTRICT,
  -- v2.8: fachliche Kennung aus dem Build (EXMA-ADM-0001). Optional, weil sie nur dort
  -- vergeben wird, wo Nutzer verwaltet werden; eindeutig, weil sie in Belegen zitiert wird.
  user_code    text UNIQUE CHECK (user_code ~ '^[A-Z]{2,8}-[A-Z]{3}-[0-9]{4}$'),
  email        text NOT NULL UNIQUE,
  display_name text NOT NULL,
  mfa_method   mfa_method NOT NULL DEFAULT 'EMAIL_CODE',    -- v2.7: nur E-Mail-Code oder Aus
  -- v2.8: Zustand als Domaene. WARTET_2FA ist der Zustand zwischen versandter Einladung und
  -- erster bestaetigter Zwei-Faktor-Anmeldung -- fachlich weder aktiv noch gesperrt.
  status       actor_status NOT NULL DEFAULT 'WARTET_2FA',
  -- v2.8: Zustand vor dem Sperren. Ohne dieses Feld faellt ein zuvor wartender Nutzer beim
  -- Entsperren faelschlich auf 'aktiv' -- der Build haelt dafuer 'vorSperre'.
  status_before_lock actor_status,
  -- v2.8: Versiegelte Anlage (Erst-Admin des Installers). Versiegelte Konten tragen keine
  -- Geldrechte; die Trennung von Administration und Zahlungsfreigabe ist damit Schema, nicht Absprache.
  sealed       boolean NOT NULL DEFAULT false,
  money_rights boolean NOT NULL DEFAULT false,
  created_on   date,                                        -- "seit" im Build
  last_login_at timestamptz,                                -- "Letzte Anmeldung"
  CONSTRAINT actor_lock_state CHECK (status_before_lock IS NULL
                                     OR (status = 'GESPERRT' AND status_before_lock <> 'GESPERRT')),
  CONSTRAINT actor_sealed_no_money CHECK (NOT (sealed AND money_rights))
);

CREATE TABLE role (
  id          uuid PRIMARY KEY DEFAULT gen_random_uuid(),
  portal_code portal_code NOT NULL REFERENCES portal(code),
  name        text NOT NULL,
  UNIQUE (portal_code, name)
);

CREATE TABLE role_right (
  role_id     uuid NOT NULL REFERENCES role(id) ON DELETE CASCADE,
  right_level rights_level NOT NULL,
  PRIMARY KEY (role_id, right_level)
);

CREATE TABLE membership (
  actor_id     uuid NOT NULL REFERENCES actor(id) ON DELETE CASCADE,
  portal_code  portal_code NOT NULL REFERENCES portal(code),
  role_id      uuid NOT NULL REFERENCES role(id) ON DELETE RESTRICT,
  tenant_scope uuid NOT NULL REFERENCES tenant(id) ON DELETE RESTRICT,
  PRIMARY KEY (actor_id, portal_code, role_id, tenant_scope)
);

-- ---------- EINLADUNG (v2.8 NEU) ----------
-- Der Build versendet einen Einmal-Link (24 h) und verlangt danach bei jeder Anmeldung einen
-- sechsstelligen E-Mail-Code. Modelliert wird die Einladung, nicht der Code: der Code ist
-- fluechtig und gehoert nicht in ein Fachdatenmodell, die Einladung dagegen ist nachweispflichtig.
-- Gespeichert wird ausschliesslich der Hash des Links -- wer die Datenbank liest, kann keine
-- fremde Einladung einloesen.
CREATE TABLE invitation (
  id          uuid PRIMARY KEY DEFAULT gen_random_uuid(),
  actor_id    uuid NOT NULL REFERENCES actor(id) ON DELETE CASCADE,
  portal_code portal_code NOT NULL REFERENCES portal(code),
  mail        text NOT NULL,        -- Adresse zum Zeitpunkt des Versands (Nachweis, nicht Verweis)
  token_hash  text NOT NULL,        -- nur der Hash, nie der Link
  sent_at     timestamptz NOT NULL DEFAULT now(),
  expires_at  timestamptz NOT NULL,
  redeemed_at timestamptz,
  status      invitation_status NOT NULL DEFAULT 'VERSANDT',
  attempt     smallint NOT NULL DEFAULT 1 CHECK (attempt >= 1),  -- "Link erneut senden"
  CONSTRAINT invitation_frist     CHECK (expires_at > sent_at),
  CONSTRAINT invitation_einloesung CHECK ((status = 'EINGELOEST') = (redeemed_at IS NOT NULL)),
  CONSTRAINT invitation_mail_fmt  CHECK (mail ~ '^[^[:space:]@]+@[^[:space:]@]+\.[^[:space:]@]+$')
);

-- ---------- KUNDEN-KONTAKTE ----------
CREATE TABLE contact (
  id        uuid PRIMARY KEY DEFAULT gen_random_uuid(),
  tenant_id uuid NOT NULL REFERENCES tenant(id) ON DELETE CASCADE,
  vorname   text NOT NULL,
  nachname  text NOT NULL,
  tel       text,
  mail      text,
  is_valid  boolean NOT NULL DEFAULT false,
  position  smallint NOT NULL CHECK (position BETWEEN 1 AND 3),  -- max. 3 je Tenant
  UNIQUE (tenant_id, position)
);

-- ---------- ANZEIGE-NAMEN DER ZUSTAENDE (v2.7 NEU) ----------
-- Token bleibt intern stabil; der Anzeigename ist Datum, nicht Code (Build: ST_DE/ST_EN/stName).
CREATE TABLE lifecycle_state_label (
  state  lifecycle_state NOT NULL,
  locale ui_locale       NOT NULL,
  label  text            NOT NULL,
  PRIMARY KEY (state, locale)
);

-- ---------- EIGNUNGS-CHECK (v2.7 NEU) ----------
-- Vorgeschaltetes Gate vor Schritt 01: drei Fragen, ein nicht-eignungsfaehiger
-- Optionswert stoppt das gefuehrte Gespraech (fail-closed).
CREATE TABLE fit_question (
  code       text PRIMARY KEY CHECK (code ~ '^[a-z_]{3,20}$'),   -- art | nutzung | daten
  dimension  fit_dimension NOT NULL UNIQUE,
  position   smallint NOT NULL UNIQUE CHECK (position BETWEEN 1 AND 9),
  prompt_de  text NOT NULL
);

CREATE TABLE fit_option (
  id            uuid PRIMARY KEY DEFAULT gen_random_uuid(),
  question_code text NOT NULL REFERENCES fit_question(code) ON DELETE CASCADE,
  position      smallint NOT NULL CHECK (position BETWEEN 1 AND 9),
  label_de      text NOT NULL,
  value_token   text NOT NULL,       -- z.B. Fachanwendung, Website / Marketing
  is_eligible   boolean NOT NULL,    -- false = hartes Ausschlusskriterium
  UNIQUE (question_code, position),
  UNIQUE (question_code, value_token)
);

CREATE TABLE fit_check (
  id            uuid PRIMARY KEY DEFAULT gen_random_uuid(),
  tenant_id     uuid NOT NULL REFERENCES tenant(id) ON DELETE RESTRICT,
  actor_id      uuid REFERENCES actor(id) ON DELETE SET NULL,
  app_id        uuid,                                  -- FK nach app, spaeter gesetzt (siehe unten)
  started_at    timestamptz NOT NULL DEFAULT now(),
  completed_at  timestamptz,
  outcome       fit_outcome NOT NULL DEFAULT 'OFFEN',
  retention_class retention_class NOT NULL DEFAULT 'KI_NACHWEIS' REFERENCES retention_rule(class),
  CONSTRAINT fit_done_needs_ts CHECK (outcome = 'OFFEN' OR completed_at IS NOT NULL)
);

CREATE TABLE fit_answer (
  fit_check_id  uuid NOT NULL REFERENCES fit_check(id) ON DELETE CASCADE,
  question_code text NOT NULL REFERENCES fit_question(code) ON DELETE RESTRICT,
  option_id     uuid NOT NULL REFERENCES fit_option(id)   ON DELETE RESTRICT,
  answered_at   timestamptz NOT NULL DEFAULT now(),
  superseded_at timestamptz,                            -- "Antwort aendern" nimmt zurueck, loescht nicht
  PRIMARY KEY (fit_check_id, question_code, option_id)
);

-- ---------- APP (Aggregatswurzel) ----------
CREATE TABLE app (
  id                uuid PRIMARY KEY DEFAULT gen_random_uuid(),
  tenant_id         uuid NOT NULL REFERENCES tenant(id) ON DELETE RESTRICT,
  project_no        text NOT NULL UNIQUE CHECK (project_no ~ '^DE-[A-Z]{3}_[0-9]{3}_[0-9]{2}$'),
  name              text NOT NULL,
  artifact_class    artifact_class  NOT NULL DEFAULT 'VERIFIED_APP',  -- v2.7: geprueft vs. Arbeitsdokument
  lifecycle_state   lifecycle_state NOT NULL DEFAULT 'DISCOVERY',
  journey_phase     journey_phase   NOT NULL DEFAULT 'ORIENTIERUNG',  -- v2.9: 5 Stufen
  fit_check_id      uuid REFERENCES fit_check(id) ON DELETE SET NULL, -- v2.7: Eignungsnachweis
  sealed_at         timestamptz,                                      -- v2.7: EINE Zustandsquelle fuer "Angebot angefragt"
  currency          currency_code NOT NULL DEFAULT 'EUR',    -- BF-3: Waehrung der Betragsspalten
  retention_class   retention_class NOT NULL DEFAULT 'HANDELSRECHT' REFERENCES retention_rule(class),
  offer_price_cents integer CHECK (offer_price_cents >= 0),   -- kleinste Einheit der Waehrung (Cent/Pence/Rappen), kein Float
  margin_cents      integer,                                  -- dito, intern; darf negativ sein
  open_points       integer CHECK (open_points >= 0),
  created_at        date NOT NULL,
  updated_at        timestamptz,
  deleted_at        timestamptz,
  -- v2.9: Empfangsbestaetigung der Unterlagen zu Mitbestimmung und Datenschutz.
  -- Gesetzt im Moment der Angebotsanforderung, gemeinsam mit der Unterschrift. FREIRAUM
  -- verschickt die Memos nicht; belegt wird ausschliesslich, dass sie uebergeben wurden.
  -- Steht bewusst am Ende der Tabelle, damit Frischinstallation und Migration dieselbe
  -- Spaltenreihenfolge erzeugen -- ALTER TABLE kann eine Spalte nur anhaengen.
  mitbestimmung_ack_at timestamptz,
  CONSTRAINT app_is_verified CHECK (artifact_class = 'VERIFIED_APP'),
  CONSTRAINT sealed_needs_state CHECK (sealed_at IS NULL OR lifecycle_state <> 'DISCOVERY'),
  -- Die Bestaetigung entsteht im selben Akt wie die Anforderung; ohne Siegel gibt es sie nicht.
  CONSTRAINT ack_needs_seal CHECK (mitbestimmung_ack_at IS NULL OR sealed_at IS NOT NULL)
);

ALTER TABLE fit_check
  ADD CONSTRAINT fit_check_app_fk FOREIGN KEY (app_id) REFERENCES app(id) ON DELETE SET NULL;

-- v2.7 NEU: Direkt-Prototyp = Arbeitsdokument ohne Pruefung, keine beauftragbare Anwendung
CREATE TABLE direct_prototype (
  id              uuid PRIMARY KEY DEFAULT gen_random_uuid(),
  tenant_id       uuid NOT NULL REFERENCES tenant(id) ON DELETE RESTRICT,
  actor_id        uuid REFERENCES actor(id) ON DELETE SET NULL,
  name            text NOT NULL,
  format          text NOT NULL,                          -- DOCX, XLSX, PPTX, MD ...
  source_count    smallint NOT NULL DEFAULT 0 CHECK (source_count >= 0),
  artifact_class  artifact_class NOT NULL DEFAULT 'WORK_DOCUMENT',
  created_at      timestamptz NOT NULL DEFAULT now(),
  retention_class retention_class NOT NULL DEFAULT 'BETRIEBSPROTOKOLL' REFERENCES retention_rule(class),
  retention_until date,                                   -- materialisiertes Ergebnis der Regel; im Portal angezeigt
  deleted_at      timestamptz,
  CONSTRAINT proto_is_work_doc CHECK (artifact_class = 'WORK_DOCUMENT')
);

CREATE TABLE document (
  id       uuid PRIMARY KEY DEFAULT gen_random_uuid(),
  app_id   uuid NOT NULL REFERENCES app(id) ON DELETE CASCADE,
  kind     document_kind NOT NULL,
  filename text NOT NULL,
  mime     text
);

CREATE TABLE test_harness (
  app_id   uuid PRIMARY KEY REFERENCES app(id) ON DELETE CASCADE,
  filename text NOT NULL
);

-- ---------- KI: MODELLE, AGENTEN, WISSEN, VORLAGEN, RICHTLINIEN ----------
-- v2.7: provider/hosting sind Enums; das Anzeigeschema lautet "Modell . Anbieter . Hosting".
CREATE TABLE model_ref (
  id        uuid PRIMARY KEY DEFAULT gen_random_uuid(),
  token     text           NOT NULL UNIQUE,   -- kanonisches Anzeige-Token, z.B. 'Claude Sonnet'
  provider  model_provider NOT NULL,
  model     text           NOT NULL,
  -- BF-2: version ist NOT NULL mit Platzhalter. Als nullbare Spalte war die Tupel-Eindeutigkeit
  -- unwirksam, weil PostgreSQL NULL-Werte in eindeutigen Indizes als verschieden behandelt.
  version   text           NOT NULL DEFAULT 'n/a',   -- 'n/a' = Anbieter fuehrt keine Versionsangabe
  hosting   model_hosting  NOT NULL,
  UNIQUE (provider, model, version, hosting)
);

CREATE TABLE agent (
  id               uuid PRIMARY KEY DEFAULT gen_random_uuid(),
  catalog_group    catalog_group,
  name             text NOT NULL UNIQUE,
  role_kind        text,
  model_ref_id     uuid NOT NULL REFERENCES model_ref(id) ON DELETE RESTRICT,  -- v2.7: Pflicht
  is_readonly      boolean NOT NULL DEFAULT false,
  status           agent_status NOT NULL DEFAULT 'IN_REVIEW',
  monthly_tokens_m numeric CHECK (monthly_tokens_m >= 0),
  review_score     integer CHECK (review_score BETWEEN 0 AND 100)
);

-- v2.7 NEU: Wissensbaustein (fachliche ID) - das, worauf Agenten verdrahtet sind.
CREATE TABLE knowledge_module (
  id           text PRIMARY KEY CHECK (id ~ '^(BR|FN|ME)-[A-Z0-9]{2,6}-[0-9]{3}$'),  -- ME-REFA-001
  grp          knowledge_group  NOT NULL,
  domaene      text NOT NULL,
  title        text NOT NULL,
  -- Status und Version liegen an der Versionszeile, nicht am Kopf (BF-4).
  lang         text,
  valid_until  date,
  owner_label  text,
  usage_count  integer NOT NULL DEFAULT 0 CHECK (usage_count >= 0)
);

-- v2.7: Quellen-ID ist kanonisch; die Register-Nummer ist ein stabiler Alias, nicht die Identitaet.
CREATE TABLE knowledge_source (
  id             text PRIMARY KEY CHECK (id ~ '^Q-[A-Z0-9]{2,4}-[0-9]{1,4}$'),   -- Q-GH-4
  register_no    text UNIQUE CHECK (register_no IS NULL OR register_no ~ '^[A-Z]{2,4}-[0-9]{5}$'),  -- GIT-00004 (Alias)
  type           knowledge_type   NOT NULL,
  origin         knowledge_origin NOT NULL DEFAULT 'EXTERN',
  project_ref    text,
  source_ref     text,
  wissensbereich text,
  domaene        text,
  license        text,
  mode           knowledge_mode   NOT NULL DEFAULT 'DYNAMIC',
  status         lifecycle_status NOT NULL DEFAULT 'DRAFT',
  version        text,
  editor         text,
  added_at       date,
  CONSTRAINT project_source_needs_ref CHECK (origin <> 'PROJEKT' OR project_ref IS NOT NULL)
);

CREATE TABLE knowledge_module_source (
  module_id text NOT NULL REFERENCES knowledge_module(id) ON DELETE CASCADE,
  source_id text NOT NULL REFERENCES knowledge_source(id) ON DELETE RESTRICT,   -- Quelle in Nutzung nicht loeschbar
  PRIMARY KEY (module_id, source_id)
);

CREATE TABLE template (
  id      text PRIMARY KEY,          -- A1, A2, ... , PS-DISC, AP-ETHIK
  grp     template_group NOT NULL,   -- v2.7: inkl. POLICY
  name    text NOT NULL
);

CREATE TABLE policy (
  id      text PRIMARY KEY CHECK (id ~ '^P-[A-Z]+-[0-9]{3}$'),  -- P-ETHIK-001
  name    text NOT NULL,
  scope   text,
  template_id text REFERENCES template(id) ON DELETE SET NULL   -- v2.7: Richtlinien-Vorlage sauber verknuepft
);

-- N:M mit referenzieller Integritaet (aus DELETE_RULES):
-- v2.7: Agenten sind auf WISSENSBAUSTEINE verdrahtet, nicht auf Einzelquellen.
CREATE TABLE agent_knowledge (
  agent_id  uuid NOT NULL REFERENCES agent(id) ON DELETE CASCADE,
  module_id text NOT NULL REFERENCES knowledge_module(id) ON DELETE RESTRICT,
  PRIMARY KEY (agent_id, module_id)
);

CREATE TABLE agent_template (
  agent_id    uuid NOT NULL REFERENCES agent(id) ON DELETE CASCADE,
  template_id text NOT NULL REFERENCES template(id) ON DELETE RESTRICT,           -- Vorlage in Nutzung nicht loeschbar
  PRIMARY KEY (agent_id, template_id)
);

CREATE TABLE agent_policy (
  agent_id  uuid NOT NULL REFERENCES agent(id) ON DELETE CASCADE,
  policy_id text NOT NULL REFERENCES policy(id) ON DELETE RESTRICT,
  PRIMARY KEY (agent_id, policy_id)
);

-- ---------- VERSIONSHISTORIEN (Review-Befund BF-4) ----------
-- Gaengige Praxis fuer fachliche Historie im OLTP: Kopf/Version-Trennung mit
-- Gueltigkeitszeit. Der Kopf traegt Identitaet und unveraenderliche Merkmale, die
-- Versionszeile den Stand samt Gueltigkeitszeitraum, Bearbeiter und Aenderungsvermerk.
-- PostgreSQL hat keine systemversionierten Tabellen wie SQL Server; die idiomatische
-- Entsprechung ist ein daterange mit Ausschluss-Constraint. Der verhindert, dass zwei
-- Versionen desselben Objekts gleichzeitig gelten -- die Regel wird erzwungen statt gehofft.
-- Bewusst NICHT bitemporal: Transaktionszeit liefert bereits das append-only EVENT-Log.
CREATE EXTENSION IF NOT EXISTS btree_gist;

CREATE TABLE knowledge_module_version (
  module_id         text NOT NULL REFERENCES knowledge_module(id) ON DELETE CASCADE,
  version           text NOT NULL,
  status            lifecycle_status NOT NULL DEFAULT 'DRAFT',
  gueltig           daterange NOT NULL,
  editor            text,
  aenderungsvermerk text,
  erfasst_am        timestamptz NOT NULL DEFAULT now(),
  PRIMARY KEY (module_id, version),
  EXCLUDE USING gist (module_id WITH =, gueltig WITH &&)
);

CREATE TABLE template_version (
  template_id       text NOT NULL REFERENCES template(id) ON DELETE CASCADE,
  version           text NOT NULL,
  status            lifecycle_status NOT NULL DEFAULT 'DRAFT',
  gueltig           daterange NOT NULL,
  editor            text,
  aenderungsvermerk text,
  erfasst_am        timestamptz NOT NULL DEFAULT now(),
  PRIMARY KEY (template_id, version),
  EXCLUDE USING gist (template_id WITH =, gueltig WITH &&)
);

CREATE TABLE policy_version (
  policy_id         text NOT NULL REFERENCES policy(id) ON DELETE CASCADE,
  version           text NOT NULL,
  status            lifecycle_status NOT NULL DEFAULT 'DRAFT',
  gueltig           daterange NOT NULL,
  editor            text,
  aenderungsvermerk text,
  erfasst_am        timestamptz NOT NULL DEFAULT now(),
  PRIMARY KEY (policy_id, version),
  EXCLUDE USING gist (policy_id WITH =, gueltig WITH &&)
);

-- Zustandsverlauf der Anwendung: beantwortet "wann stand diese App in welchem Zustand".
-- Vorher nur durch Nachparsen der Ereignistabelle rekonstruierbar.
CREATE TABLE app_state_history (
  app_id  uuid NOT NULL REFERENCES app(id) ON DELETE CASCADE,
  state   lifecycle_state NOT NULL,
  gueltig daterange NOT NULL,
  PRIMARY KEY (app_id, gueltig),
  EXCLUDE USING gist (app_id WITH =, gueltig WITH &&)
);

-- ---------- UNABHAENGIGE FACHPRUEFUNG (v2.7 NEU) ----------
-- Der Review-Agent bewertet mit einem anderen Foundation-Modell und veraendert kein Artefakt.
CREATE TABLE review_run (
  id            uuid PRIMARY KEY DEFAULT gen_random_uuid(),
  app_id        uuid NOT NULL REFERENCES app(id) ON DELETE CASCADE,
  artifact_version text NOT NULL,                       -- z.B. v2
  round         smallint NOT NULL CHECK (round BETWEEN 1 AND 2),
  score         smallint NOT NULL CHECK (score BETWEEN 0 AND 100),
  threshold     smallint NOT NULL DEFAULT 90 CHECK (threshold BETWEEN 0 AND 100),
  passed        boolean NOT NULL,
  model_ref_id  uuid NOT NULL REFERENCES model_ref(id) ON DELETE RESTRICT,
  -- Pinnt die tatsaechlich benutzte Rubrik-VERSION. Nur so bleibt rekonstruierbar,
  -- gegen welchen Stand geprueft wurde (BF-4).
  rubric_module_id text,
  rubric_version   text,
  completed_at  timestamptz NOT NULL DEFAULT now(),
  retention_class retention_class NOT NULL DEFAULT 'KI_NACHWEIS' REFERENCES retention_rule(class),
  UNIQUE (app_id, artifact_version, round),
  FOREIGN KEY (rubric_module_id, rubric_version)
    REFERENCES knowledge_module_version(module_id, version) ON DELETE RESTRICT,
  CONSTRAINT pass_matches_threshold CHECK (passed = (score >= threshold))
);

CREATE TABLE review_finding (
  id            uuid PRIMARY KEY DEFAULT gen_random_uuid(),
  review_run_id uuid NOT NULL REFERENCES review_run(id) ON DELETE CASCADE,
  criterion     text NOT NULL,          -- Vollstaendigkeit, Widerspruchsfreiheit, Belegtheit ...
  severity      text NOT NULL CHECK (severity IN ('BLOCKER','HINWEIS','BESTANDEN')),
  finding       text NOT NULL,
  source_ref    text
);

-- ---------- AUDIT / PROTOKOLL (append-only) ----------
CREATE TABLE event (
  id          uuid PRIMARY KEY DEFAULT gen_random_uuid(),
  occurred_at timestamptz NOT NULL DEFAULT now(),
  project_no  text REFERENCES app(project_no) ON DELETE SET NULL,
  tenant_id   uuid REFERENCES tenant(id) ON DELETE SET NULL,
  actor_label text,
  action      text NOT NULL,
  object_ref  text,
  change_type text,
  value       text,
  source      event_source NOT NULL,
  retention_class retention_class NOT NULL DEFAULT 'BETRIEBSPROTOKOLL' REFERENCES retention_rule(class)
);
-- Append-only: kein UPDATE/DELETE (per Rolle/Policy erzwingen)
CREATE RULE event_no_update AS ON UPDATE TO event DO INSTEAD NOTHING;
CREATE RULE event_no_delete AS ON DELETE TO event DO INSTEAD NOTHING;

-- ---------- SEGREGATION OF DUTIES (Vier-Augen: Editor != Freigeber) ----------
CREATE TABLE approval (
  id                uuid PRIMARY KEY DEFAULT gen_random_uuid(),
  object_ref        text NOT NULL,
  editor_actor_id   uuid NOT NULL REFERENCES actor(id),
  approver_actor_id uuid NOT NULL REFERENCES actor(id),
  approved_at       timestamptz NOT NULL DEFAULT now(),
  CONSTRAINT sod_editor_ne_approver CHECK (editor_actor_id <> approver_actor_id)
);

-- ---------- INDIZES UND ZUSAETZLICHE EINDEUTIGKEITEN (Review v2.7) ----------

-- BF-1 (blockierend): Je Eignungsfrage darf hoechstens EINE nicht zurueckgenommene Antwort
-- existieren. Ohne diese Bedingung konnte ein Eignungs-Check gleichzeitig eine qualifizierende
-- und eine disqualifizierende Antwort auf dieselbe Frage tragen — das Gate fiel nach offen aus.
CREATE UNIQUE INDEX fit_answer_aktiv_uq
  ON fit_answer (fit_check_id, question_code) WHERE superseded_at IS NULL;

-- BF-7: Fachliche Eindeutigkeit der Ansprechpartner. Strenge Variante nach Entscheidung
-- vom 28.07.2026: eine Person je Kunde, unabhaengig von der Rolle. Bewusst lockerbar,
-- falls der Fachbereich Mehrfachrollen zulaesst — die Lockerung ist billig, die Verschaerfung nicht.
CREATE UNIQUE INDEX contact_tenant_mail_uq
  ON contact (tenant_id, lower(mail)) WHERE mail IS NOT NULL;

-- BF-6: Indizes auf Fremdschluesselspalten. Ausgewaehlt nach der Regel "referenzierende Tabelle
-- waechst mit dem Geschaeftsvolumen ODER die Zieltabelle traegt eine Loeschregel, deren Pruefung
-- sonst einen vollstaendigen Durchlauf ausloest". Bewusst NICHT angelegt (kleine, statische
-- Kataloge auf beiden Seiten): membership.portal_code, module.portal_code, agent.model_ref_id,
-- agent_template.template_id, agent_policy.policy_id, policy.template_id.
CREATE INDEX actor_tenant_idx                ON actor (tenant_id);
CREATE INDEX app_tenant_idx                  ON app (tenant_id);
CREATE INDEX app_fit_check_idx               ON app (fit_check_id);
CREATE INDEX direct_prototype_tenant_idx     ON direct_prototype (tenant_id);
CREATE INDEX direct_prototype_actor_idx      ON direct_prototype (actor_id);
CREATE INDEX document_app_idx                ON document (app_id);
CREATE INDEX event_tenant_idx                ON event (tenant_id);
CREATE INDEX event_project_idx               ON event (project_no);
CREATE INDEX fit_check_tenant_idx            ON fit_check (tenant_id);
CREATE INDEX fit_check_actor_idx             ON fit_check (actor_id);
CREATE INDEX fit_check_app_idx               ON fit_check (app_id);
CREATE INDEX fit_answer_option_idx           ON fit_answer (option_id);
CREATE INDEX fit_answer_question_idx         ON fit_answer (question_code);
CREATE INDEX approval_editor_idx             ON approval (editor_actor_id);
CREATE INDEX approval_approver_idx           ON approval (approver_actor_id);
CREATE INDEX review_run_model_idx            ON review_run (model_ref_id);
CREATE INDEX review_run_rubric_idx           ON review_run (rubric_module_id);
CREATE INDEX review_finding_run_idx          ON review_finding (review_run_id);
CREATE INDEX knowledge_module_source_src_idx ON knowledge_module_source (source_id);
CREATE INDEX agent_knowledge_module_idx      ON agent_knowledge (module_id);
CREATE INDEX membership_role_idx             ON membership (role_id);
CREATE INDEX membership_tenant_scope_idx     ON membership (tenant_scope);
CREATE INDEX invitation_actor_idx            ON invitation (actor_id);

-- v2.8: Hoechstens EINE offene Einladung je Akteur. Der Wiederversand erzeugt eine neue Zeile
-- und muss die alte auf WIDERRUFEN setzen -- ohne diese Bedingung koennten zwei gueltige
-- Einmal-Links nebeneinander bestehen, und "einmal" waere gerade keine Zusicherung mehr.
CREATE UNIQUE INDEX invitation_offen_uq
  ON invitation (actor_id) WHERE status = 'VERSANDT';

-- ---------- ZEILENUEBERGREIFENDE INVARIANTEN (v2.8 NEU) ----------
-- Drei Regeln des Builds lassen sich nicht als CHECK ausdruecken, weil sie andere Zeilen
-- betreffen. Sie stehen hier als Trigger, weil die Anwendung sie ohnehin als Selbstpruefung
-- fuehrt: was der Build als verletzt meldet, darf die Datenbank nicht zulassen.

-- (1) Es muss jederzeit mindestens einen aktiven Plattform-Admin geben.
CREATE FUNCTION platform_admin_guard() RETURNS trigger LANGUAGE plpgsql AS $$
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

CREATE TRIGGER actor_platform_admin_guard
  AFTER UPDATE OR DELETE ON actor
  FOR EACH STATEMENT EXECUTE FUNCTION platform_admin_guard();

CREATE TRIGGER membership_platform_admin_guard
  AFTER UPDATE OR DELETE ON membership
  FOR EACH STATEMENT EXECUTE FUNCTION platform_admin_guard();

-- (2) Ein versiegeltes Konto ist erst loeschbar, wenn ein zweiter aktiver Plattform-Admin
--     besteht. Ohne diese Regel kann sich die Plattform selbst aussperren.
CREATE FUNCTION sealed_actor_guard() RETURNS trigger LANGUAGE plpgsql AS $$
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

CREATE TRIGGER actor_sealed_guard
  BEFORE DELETE ON actor
  FOR EACH ROW EXECUTE FUNCTION sealed_actor_guard();

-- (3) Einladungen nur in die erlaubte Domaene und nur innerhalb der konfigurierten Frist.
CREATE FUNCTION invitation_guard() RETURNS trigger LANGUAGE plpgsql AS $$
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

CREATE TRIGGER invitation_guard_trg
  BEFORE INSERT OR UPDATE ON invitation
  FOR EACH ROW EXECUTE FUNCTION invitation_guard();

-- ---------- SEED: Release-1-Gate ----------
INSERT INTO portal(code,name,release_status) VALUES
  ('ENDUSER',   'Endnutzer-Portal', 'ENABLED'),
  ('EXMA',      'EXMA-Portal',      'ENABLED'),
  ('USER_ADMIN','User-Admin-Portal','PLANNED'),
  ('VAR_ADMIN', 'VAR-Admin-Portal', 'PLANNED'),
  ('INDIA_OPS', 'India-Ops-Portal', 'PLANNED');

-- SEED v2.8: Rollen der Release-1-Portale. Das EXMA-Portal kennt genau EINE Rolle --
-- der Build sagt es ausdruecklich ("Eine Rolle fuer alle: Plattform-Admin ... kein
-- Rechte-Baukasten"). Der Name loest 'App-Builder-Admin' aus v2.7 ab.
INSERT INTO role(portal_code,name) VALUES
  ('EXMA',   'Plattform-Admin'),
  ('ENDUSER','Endnutzer');

INSERT INTO role_right(role_id,right_level)
  SELECT id,'A' FROM role WHERE portal_code='EXMA'  AND name='Plattform-Admin';
INSERT INTO role_right(role_id,right_level)
  SELECT id,'V' FROM role WHERE portal_code='ENDUSER' AND name='Endnutzer';

-- SEED: Loeschklassen (Vorschlag vom 28.07.2026, rechtlich zu bestaetigen)
-- HANDELSRECHT      Regelfrist 10 Jahre, Untergrenze 8 Jahre (Buchungsbelege nach dem
--                   Wachstumschancengesetz). Kein Personenbezug-Ende vor Fristablauf:
--                   ein Beleg ohne Beteiligte ist als Beleg wertlos.
-- KI_NACHWEIS       An das Bezugsobjekt (die Anwendung) gekoppelt, Untergrenze 6 Monate
--                   aus dem AI Act. Personenbezug endet nach 24 Monaten, der Nachweis bleibt.
-- BETRIEBSPROTOKOLL Regelfrist 24 Monate ab Erstellung, Untergrenze 6 Monate aus dem
--                   AI Act, Obergrenze aus der Speicherbegrenzung. Personenbezug endet nach 12.
INSERT INTO retention_rule(class,bezeichnung,fristbeginn,regelfrist_monate,mindestfrist_monate,pseudonymisieren_nach_monaten,rechtsgrundlage) VALUES
  ('HANDELSRECHT','Handels- und steuerrelevante Unterlagen','ENTSTEHUNGSJAHRESENDE',120,96,NULL,
   'Paragraf 147 AO (10 J. Buecher und Abschluesse, 8 J. Buchungsbelege), Paragraf 257 HGB'),
  ('KI_NACHWEIS','Nachweis der KI-Pruefung und der Eignungsentscheidung','BEZUGSOBJEKT',NULL,6,24,
   'EU AI Act Art. 19 und Art. 26 Abs. 6 (mindestens 6 Monate), DSGVO Art. 5 Abs. 1 lit. e'),
  ('BETRIEBSPROTOKOLL','Betriebsprotokoll ohne handelsrechtlichen Bezug','ERSTELLUNG',24,6,12,
   'EU AI Act Art. 19 als Untergrenze, DSGVO Art. 5 Abs. 1 lit. e als Obergrenze, DIN 66398');

-- SEED: Modul-Mapping (Anzeige ist kanonisch, interne Keys bleiben aus Kompatibilitaet)
INSERT INTO module(display_code,internal_key,name,portal_code) VALUES
  ('M1','m1','Wissensbausteine',  'EXMA'),
  ('M2','m2','Formatvorlagen',    'EXMA'),
  ('M3','m4','KI-Agenten',        'EXMA'),
  ('M4','m6','Richtlinien',       'EXMA');

-- SEED: Anzeige-Namen der Lifecycle-Zustaende (Token stabil, Label als Datum)
INSERT INTO lifecycle_state_label(state,locale,label) VALUES
  ('EINGELADEN','DE','Eingeladen'),        ('EINGELADEN','EN','Invited'),
  ('DISCOVERY','DE','Discovery'),          ('DISCOVERY','EN','Discovery'),
  ('IN_BEARBEITUNG','DE','In Bearbeitung'),('IN_BEARBEITUNG','EN','In progress'),
  ('BEAUFTRAGT','DE','Beauftragt'),        ('BEAUFTRAGT','EN','Ordered'),
  ('IN_DEV','DE','In Dev'),                ('IN_DEV','EN','In dev'),
  ('ABNAHME','DE','Abnahme'),              ('ABNAHME','EN','Acceptance'),
  ('IN_PROD','DE','In Prod'),              ('IN_PROD','EN','In prod'),
  ('PAUSIERT','DE','Pausiert'),            ('PAUSIERT','EN','Paused');

-- SEED: kanonische Modell-Token (aus MODELS x MODEL_ORIGIN des Builds v2.7)
INSERT INTO model_ref(token,provider,model,version,hosting) VALUES
  ('Claude Sonnet','ANTHROPIC','Claude Sonnet','n/a','AZURE_EU'),
  ('GPT-4o',       'OPENAI',   'GPT-4o',       'n/a','AZURE_EU'),
  ('GPT-4o mini',  'OPENAI',   'GPT-4o mini',  'n/a','AZURE_EU'),
  ('SLM lokal',    'INTERN',   'SLM lokal',    'n/a','ON_PREM_DE'),
  ('Klassifikator','INTERN',   'Klassifikator','n/a','ON_PREM_DE'),
  ('gemäß Auswahl','OFFEN',  'gemäß Auswahl','n/a','OFFEN');

-- SEED: Eignungs-Check (drei Fragen, Ausschluss ueber is_eligible = false)
INSERT INTO fit_question(code,dimension,position,prompt_de) VALUES
  ('art',    'ART',    1,'Was soll am Ende entstehen?'),
  ('nutzung','NUTZUNG',2,'Wer soll damit arbeiten - und wie lange?'),
  ('daten',  'DATEN',  3,'Beruehrt die Anwendung Ihre Geschaeftsdaten?');

INSERT INTO fit_option(question_code,position,label_de,value_token,is_eligible) VALUES
  ('art',1,'Eine Anwendung, mit der Menschen arbeiten - erfassen, pruefen, freigeben','Fachanwendung',true),
  ('art',2,'Ein Werkzeug, das einen Arbeitsablauf automatisiert oder unterstuetzt','Prozess-Werkzeug',true),
  ('art',3,'Eine Plattform fuer mehrere Parteien - Marktplatz, Buchung, Community','Plattform',true),
  ('art',4,'Eine Website, die unser Unternehmen oder Produkt darstellt','Website / Marketing',false),
  ('art',5,'Etwas, das lokal auf dem Rechner oder Geraet installiert wird','Installierte Software',false),
  ('nutzung',1,'Ein Team im Haus, dauerhaft im Tagesgeschaeft','Intern - dauerhaft',true),
  ('nutzung',2,'Unsere Kunden oder Partner, dauerhaft','Extern - dauerhaft',true),
  ('nutzung',3,'Zunaechst wenige Personen, aber mit dem Ziel Produktivbetrieb','Pilot -> Produktiv',true),
  ('nutzung',4,'Nur zum Ausprobieren einer Idee - danach vermutlich nicht weiter','Wegwerf-Versuch',false),
  ('daten',1,'Ja - sie liest oder schreibt Daten aus unseren Systemen (ERP, CRM, DMS, Postfach)','Systemdaten',true),
  ('daten',2,'Ja - sie verwaltet eigene Geschaeftsdaten (Vorgaenge, Antraege, Belege, Kunden)','Eigene Vorgaenge',true),
  ('daten',3,'Teilweise - vor allem Wissen und Dokumente, die geprueft beantwortet werden sollen','Wissen & Dokumente',true),
  ('daten',4,'Nein - es geht um Darstellung, Inhalte oder Gestaltung','Nur Darstellung',false);

-- Nur ENABLED-Portale werden von der Anwendung gerendert/geroutet:
CREATE VIEW portal_enabled AS SELECT * FROM portal WHERE release_status = 'ENABLED';

-- Agenten erreichen ueber den Quellenbroker ausschliesslich freigegebene Quellen:
CREATE VIEW knowledge_source_released AS
  SELECT * FROM knowledge_source WHERE status = 'RELEASED';

-- Tab-Trennung des Wissensregisters als Daten (Register = freigegeben, Entwuerfe = Rest):
CREATE VIEW knowledge_source_draft AS
  SELECT * FROM knowledge_source WHERE status <> 'RELEASED';

-- Loeschkonzept abfragbar: je klassifiziertem Datensatz das Faelligkeitsdatum und den
-- Zeitpunkt, ab dem der Personenbezug zu entfernen ist. Klasse BEZUGSOBJEKT erbt das
-- Datum der zugehoerigen Anwendung -- deshalb der Verweis ueber app.
CREATE VIEW retention_due AS
WITH regel AS (SELECT * FROM retention_rule),
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
       -- Zuordnung der Dokumentart zur Loeschklasse (Entscheidung vom 28.07.2026):
       -- ORDER = kaufmaennischer Beleg, SBOM = Produkthaftungsnachweis -> Handelsrecht.
       -- Die uebrigen sind KI-erzeugte Nachweise -> an die Anwendung gekoppelt.
       CASE WHEN d.kind IN ('ORDER','SBOM') THEN 'HANDELSRECHT'::retention_class
            ELSE 'KI_NACHWEIS'::retention_class END,
       f.faellig_am,
       CASE WHEN d.kind IN ('ORDER','SBOM') THEN NULL::date
            ELSE (f.faellig_am - interval '96 months')::date END
  FROM document d JOIN app_faellig f ON f.id = d.app_id
UNION ALL
SELECT 'event', e.id::text, e.retention_class,
       (e.occurred_at + (r.regelfrist_monate || ' months')::interval)::date,
       (e.occurred_at + (r.pseudonymisieren_nach_monaten || ' months')::interval)::date
  FROM event e JOIN regel r ON r.class = e.retention_class
 WHERE r.fristbeginn = 'ERSTELLUNG'
UNION ALL
SELECT 'direct_prototype', p.id::text, p.retention_class,
       (p.created_at + (r.regelfrist_monate || ' months')::interval)::date,
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
  LEFT JOIN app_faellig f ON f.id = v.app_id;

-- Jeweils gueltiger Stand je Katalogobjekt. Ersetzt die frueheren Kopfspalten
-- version und status, die neben der Versionstabelle Redundanz gewesen waeren.
CREATE VIEW knowledge_module_aktuell AS
  SELECT m.*, v.version, v.status, v.gueltig, v.editor, v.aenderungsvermerk
    FROM knowledge_module m JOIN knowledge_module_version v ON v.module_id = m.id
   WHERE v.gueltig @> CURRENT_DATE;

CREATE VIEW template_aktuell AS
  SELECT t.*, v.version, v.status, v.gueltig, v.editor, v.aenderungsvermerk
    FROM template t JOIN template_version v ON v.template_id = t.id
   WHERE v.gueltig @> CURRENT_DATE;

CREATE VIEW policy_aktuell AS
  SELECT p.*, v.version, v.status, v.gueltig, v.editor, v.aenderungsvermerk
    FROM policy p JOIN policy_version v ON v.policy_id = p.id
   WHERE v.gueltig @> CURRENT_DATE;

-- Aktueller Zustand aus dem Verlauf -- app.lifecycle_state bleibt der schnelle Zugriff,
-- diese Sicht der Nachweis, dass beide uebereinstimmen.
CREATE VIEW app_state_aktuell AS
  SELECT h.app_id, h.state, lower(h.gueltig) AS seit
    FROM app_state_history h WHERE h.gueltig @> CURRENT_DATE;

-- Eignung als harte Vorbedingung fuer die Journey:
CREATE VIEW app_fit_ok AS
  SELECT a.*
  FROM app a
  JOIN fit_check f ON f.id = a.fit_check_id
  WHERE f.outcome = 'GEEIGNET';

-- v2.8: Plattform-Administratoren als Sicht statt als gespeichertes Etikett. Die "Reichweite"
-- des Builds ('Plattform (alle Mandanten)') ist keine Eigenschaft der Person, sondern der
-- Mitgliedschaft -- sie ergibt sich aus dem Geltungsbereich und wird deshalb abgeleitet.
CREATE VIEW platform_admin AS
  SELECT a.id, a.user_code, a.display_name, a.email, a.status, a.sealed, a.money_rights,
         a.mfa_method, a.created_on, a.last_login_at,
         t.name AS reichweite, t.processing_region
    FROM actor a
    JOIN membership m ON m.actor_id = a.id AND m.portal_code = 'EXMA'
    JOIN tenant t     ON t.id = m.tenant_scope;

-- v2.8: Offene Einladungen -- versandt, noch nicht eingeloest, noch nicht abgelaufen.
-- Der Abgleich mit der Uhr steht in der Sicht und nicht als gespeicherter Status, damit
-- kein Hintergrundlauf noetig ist, um die Wahrheit herzustellen.
CREATE VIEW invitation_offen AS
  SELECT i.*, a.display_name, a.tenant_id
    FROM invitation i JOIN actor a ON a.id = i.actor_id
   WHERE i.status = 'VERSANDT' AND i.expires_at > now();

COMMIT;
