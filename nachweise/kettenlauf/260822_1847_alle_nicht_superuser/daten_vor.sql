




















































































































--
--
--
--
--
--
--
--
--
--
--
--
--
--
--
--
--
--
--
--
--
--
--
--
--
--
--
--
--
--
--
--
--
--
--
--
--
--
--
--
--
--
--
--
--
--
--
--
--
--
--
--
--
--
--
--
--
--
--
--
--
--
--
--
--
--
--
--
--
--
--
--
--
--
--
--
--
--
-- Data for Name: actor; Type: TABLE DATA; Schema: public; Owner: frx
-- Data for Name: agent; Type: TABLE DATA; Schema: public; Owner: frx
-- Data for Name: agent_knowledge; Type: TABLE DATA; Schema: public; Owner: frx
-- Data for Name: agent_policy; Type: TABLE DATA; Schema: public; Owner: frx
-- Data for Name: agent_template; Type: TABLE DATA; Schema: public; Owner: frx
-- Data for Name: app; Type: TABLE DATA; Schema: public; Owner: frx
-- Data for Name: app_state_history; Type: TABLE DATA; Schema: public; Owner: frx
-- Data for Name: approval; Type: TABLE DATA; Schema: public; Owner: frx
-- Data for Name: contact; Type: TABLE DATA; Schema: public; Owner: frx
-- Data for Name: direct_prototype; Type: TABLE DATA; Schema: public; Owner: frx
-- Data for Name: document; Type: TABLE DATA; Schema: public; Owner: frx
-- Data for Name: event; Type: TABLE DATA; Schema: public; Owner: frx
-- Data for Name: fit_answer; Type: TABLE DATA; Schema: public; Owner: frx
-- Data for Name: fit_check; Type: TABLE DATA; Schema: public; Owner: frx
-- Data for Name: fit_option; Type: TABLE DATA; Schema: public; Owner: frx
-- Data for Name: fit_question; Type: TABLE DATA; Schema: public; Owner: frx
-- Data for Name: invitation; Type: TABLE DATA; Schema: public; Owner: frx
-- Data for Name: knowledge_module; Type: TABLE DATA; Schema: public; Owner: frx
-- Data for Name: knowledge_module_source; Type: TABLE DATA; Schema: public; Owner: frx
-- Data for Name: knowledge_module_version; Type: TABLE DATA; Schema: public; Owner: frx
-- Data for Name: knowledge_source; Type: TABLE DATA; Schema: public; Owner: frx
-- Data for Name: lifecycle_state_label; Type: TABLE DATA; Schema: public; Owner: frx
-- Data for Name: membership; Type: TABLE DATA; Schema: public; Owner: frx
-- Data for Name: model_ref; Type: TABLE DATA; Schema: public; Owner: frx
-- Data for Name: module; Type: TABLE DATA; Schema: public; Owner: frx
-- Data for Name: policy; Type: TABLE DATA; Schema: public; Owner: frx
-- Data for Name: policy_version; Type: TABLE DATA; Schema: public; Owner: frx
-- Data for Name: portal; Type: TABLE DATA; Schema: public; Owner: frx
-- Data for Name: retention_rule; Type: TABLE DATA; Schema: public; Owner: frx
-- Data for Name: review_finding; Type: TABLE DATA; Schema: public; Owner: frx
-- Data for Name: review_run; Type: TABLE DATA; Schema: public; Owner: frx
-- Data for Name: role; Type: TABLE DATA; Schema: public; Owner: frx
-- Data for Name: role_right; Type: TABLE DATA; Schema: public; Owner: frx
-- Data for Name: template; Type: TABLE DATA; Schema: public; Owner: frx
-- Data for Name: template_version; Type: TABLE DATA; Schema: public; Owner: frx
-- Data for Name: tenant; Type: TABLE DATA; Schema: public; Owner: frx
-- Data for Name: test_harness; Type: TABLE DATA; Schema: public; Owner: frx
-- Dumped by pg_dump version 16.13 (Ubuntu 16.13-0ubuntu0.24.04.1)
-- Dumped from database version 16.13 (Ubuntu 16.13-0ubuntu0.24.04.1)
-- PostgreSQL database dump
-- PostgreSQL database dump complete
INSERT INTO public.fit_option (id, question_code, "position", label_de, value_token, is_eligible) VALUES ('19ae1dca-12b7-4154-a626-1d6b6ee93b05', 'art', 3, 'Eine Plattform fuer mehrere Parteien - Marktplatz, Buchung, Community', 'Plattform', true);
INSERT INTO public.fit_option (id, question_code, "position", label_de, value_token, is_eligible) VALUES ('1f5f7eed-6acb-4f17-8c44-84f7a75cde2d', 'nutzung', 4, 'Nur zum Ausprobieren einer Idee - danach vermutlich nicht weiter', 'Wegwerf-Versuch', false);
INSERT INTO public.fit_option (id, question_code, "position", label_de, value_token, is_eligible) VALUES ('1f8f2997-2d93-404d-a97d-c3bdcfffbce0', 'daten', 3, 'Teilweise - vor allem Wissen und Dokumente, die geprueft beantwortet werden sollen', 'Wissen & Dokumente', true);
INSERT INTO public.fit_option (id, question_code, "position", label_de, value_token, is_eligible) VALUES ('2a1fa37e-5672-4c2f-8066-c852e94ba111', 'art', 4, 'Eine Website, die unser Unternehmen oder Produkt darstellt', 'Website / Marketing', false);
INSERT INTO public.fit_option (id, question_code, "position", label_de, value_token, is_eligible) VALUES ('348e7276-49f5-420d-8453-1c11b608cde6', 'art', 1, 'Eine Anwendung, mit der Menschen arbeiten - erfassen, pruefen, freigeben', 'Fachanwendung', true);
INSERT INTO public.fit_option (id, question_code, "position", label_de, value_token, is_eligible) VALUES ('361ed398-6ff8-49de-a9ae-34099aa10485', 'daten', 4, 'Nein - es geht um Darstellung, Inhalte oder Gestaltung', 'Nur Darstellung', false);
INSERT INTO public.fit_option (id, question_code, "position", label_de, value_token, is_eligible) VALUES ('58851e19-4304-4cf0-9179-a0dcfb9a86f6', 'art', 2, 'Ein Werkzeug, das einen Arbeitsablauf automatisiert oder unterstuetzt', 'Prozess-Werkzeug', true);
INSERT INTO public.fit_option (id, question_code, "position", label_de, value_token, is_eligible) VALUES ('6a58dc42-8042-4f32-af28-9d122fc48918', 'nutzung', 2, 'Unsere Kunden oder Partner, dauerhaft', 'Extern - dauerhaft', true);
INSERT INTO public.fit_option (id, question_code, "position", label_de, value_token, is_eligible) VALUES ('6e9f0716-60a5-4245-87f1-b909fbbac663', 'nutzung', 1, 'Ein Team im Haus, dauerhaft im Tagesgeschaeft', 'Intern - dauerhaft', true);
INSERT INTO public.fit_option (id, question_code, "position", label_de, value_token, is_eligible) VALUES ('7f7ac1f7-7170-4966-956f-a3fe8fa38208', 'art', 5, 'Etwas, das lokal auf dem Rechner oder Geraet installiert wird', 'Installierte Software', false);
INSERT INTO public.fit_option (id, question_code, "position", label_de, value_token, is_eligible) VALUES ('8fa0991d-a667-4a09-ba91-52c28e41933f', 'daten', 2, 'Ja - sie verwaltet eigene Geschaeftsdaten (Vorgaenge, Antraege, Belege, Kunden)', 'Eigene Vorgaenge', true);
INSERT INTO public.fit_option (id, question_code, "position", label_de, value_token, is_eligible) VALUES ('b23da0a6-2638-465b-9a88-70af93191b5a', 'daten', 1, 'Ja - sie liest oder schreibt Daten aus unseren Systemen (ERP, CRM, DMS, Postfach)', 'Systemdaten', true);
INSERT INTO public.fit_option (id, question_code, "position", label_de, value_token, is_eligible) VALUES ('d0dd63a3-db75-4f02-aad3-b3fa5c407969', 'nutzung', 3, 'Zunaechst wenige Personen, aber mit dem Ziel Produktivbetrieb', 'Pilot -> Produktiv', true);
INSERT INTO public.fit_question (code, dimension, "position", prompt_de) VALUES ('art', 'ART', 1, 'Was soll am Ende entstehen?');
INSERT INTO public.fit_question (code, dimension, "position", prompt_de) VALUES ('daten', 'DATEN', 3, 'Beruehrt die Anwendung Ihre Geschaeftsdaten?');
INSERT INTO public.fit_question (code, dimension, "position", prompt_de) VALUES ('nutzung', 'NUTZUNG', 2, 'Wer soll damit arbeiten - und wie lange?');
INSERT INTO public.lifecycle_state_label (state, locale, label) VALUES ('ABNAHME', 'DE', 'Abnahme');
INSERT INTO public.lifecycle_state_label (state, locale, label) VALUES ('ABNAHME', 'EN', 'Acceptance');
INSERT INTO public.lifecycle_state_label (state, locale, label) VALUES ('BEAUFTRAGT', 'DE', 'Beauftragt');
INSERT INTO public.lifecycle_state_label (state, locale, label) VALUES ('BEAUFTRAGT', 'EN', 'Ordered');
INSERT INTO public.lifecycle_state_label (state, locale, label) VALUES ('DISCOVERY', 'DE', 'Discovery');
INSERT INTO public.lifecycle_state_label (state, locale, label) VALUES ('DISCOVERY', 'EN', 'Discovery');
INSERT INTO public.lifecycle_state_label (state, locale, label) VALUES ('EINGELADEN', 'DE', 'Eingeladen');
INSERT INTO public.lifecycle_state_label (state, locale, label) VALUES ('EINGELADEN', 'EN', 'Invited');
INSERT INTO public.lifecycle_state_label (state, locale, label) VALUES ('IN_BEARBEITUNG', 'DE', 'In Bearbeitung');
INSERT INTO public.lifecycle_state_label (state, locale, label) VALUES ('IN_BEARBEITUNG', 'EN', 'In progress');
INSERT INTO public.lifecycle_state_label (state, locale, label) VALUES ('IN_DEV', 'DE', 'In Dev');
INSERT INTO public.lifecycle_state_label (state, locale, label) VALUES ('IN_DEV', 'EN', 'In dev');
INSERT INTO public.lifecycle_state_label (state, locale, label) VALUES ('IN_PROD', 'DE', 'In Prod');
INSERT INTO public.lifecycle_state_label (state, locale, label) VALUES ('IN_PROD', 'EN', 'In prod');
INSERT INTO public.lifecycle_state_label (state, locale, label) VALUES ('PAUSIERT', 'DE', 'Pausiert');
INSERT INTO public.lifecycle_state_label (state, locale, label) VALUES ('PAUSIERT', 'EN', 'Paused');
INSERT INTO public.model_ref (id, token, provider, model, version, hosting) VALUES ('8a84ab29-3359-40c1-a07c-f5e65ef26163', 'GPT-4o mini', 'OPENAI', 'GPT-4o mini', 'n/a', 'AZURE_EU');
INSERT INTO public.model_ref (id, token, provider, model, version, hosting) VALUES ('9d0cc8a0-3019-4c57-a355-ed740aeaeffa', 'gemäß Auswahl', 'OFFEN', 'gemäß Auswahl', 'n/a', 'OFFEN');
INSERT INTO public.model_ref (id, token, provider, model, version, hosting) VALUES ('9eb6c2c4-8af1-4d8b-bc96-1fabcca182fc', 'Claude Sonnet', 'ANTHROPIC', 'Claude Sonnet', 'n/a', 'AZURE_EU');
INSERT INTO public.model_ref (id, token, provider, model, version, hosting) VALUES ('a917b957-15c3-416a-a397-cd9c87036b61', 'Klassifikator', 'INTERN', 'Klassifikator', 'n/a', 'ON_PREM_DE');
INSERT INTO public.model_ref (id, token, provider, model, version, hosting) VALUES ('b128099b-7c1d-40e3-9f44-027e7af187a8', 'GPT-4o', 'OPENAI', 'GPT-4o', 'n/a', 'AZURE_EU');
INSERT INTO public.model_ref (id, token, provider, model, version, hosting) VALUES ('d2a65808-c536-4a56-be99-7f2ab1981eec', 'SLM lokal', 'INTERN', 'SLM lokal', 'n/a', 'ON_PREM_DE');
INSERT INTO public.module (display_code, internal_key, name, portal_code) VALUES ('M1', 'm1', 'Wissensbausteine', 'EXMA');
INSERT INTO public.module (display_code, internal_key, name, portal_code) VALUES ('M2', 'm2', 'Formatvorlagen', 'EXMA');
INSERT INTO public.module (display_code, internal_key, name, portal_code) VALUES ('M3', 'm4', 'KI-Agenten', 'EXMA');
INSERT INTO public.module (display_code, internal_key, name, portal_code) VALUES ('M4', 'm6', 'Richtlinien', 'EXMA');
INSERT INTO public.portal (code, name, release_status, data_locality) VALUES ('ENDUSER', 'Endnutzer-Portal', 'ENABLED', 'EU-Azure/swedencentral');
INSERT INTO public.portal (code, name, release_status, data_locality) VALUES ('EXMA', 'EXMA-Portal', 'ENABLED', 'EU-Azure/swedencentral');
INSERT INTO public.portal (code, name, release_status, data_locality) VALUES ('INDIA_OPS', 'India-Ops-Portal', 'PLANNED', 'EU-Azure/swedencentral');
INSERT INTO public.portal (code, name, release_status, data_locality) VALUES ('USER_ADMIN', 'User-Admin-Portal', 'PLANNED', 'EU-Azure/swedencentral');
INSERT INTO public.portal (code, name, release_status, data_locality) VALUES ('VAR_ADMIN', 'VAR-Admin-Portal', 'PLANNED', 'EU-Azure/swedencentral');
INSERT INTO public.retention_rule (class, bezeichnung, fristbeginn, regelfrist_monate, mindestfrist_monate, pseudonymisieren_nach_monaten, rechtsgrundlage) VALUES ('BETRIEBSPROTOKOLL', 'Betriebsprotokoll ohne handelsrechtlichen Bezug', 'ERSTELLUNG', 24, 6, 12, 'EU AI Act Art. 19 als Untergrenze, DSGVO Art. 5 Abs. 1 lit. e als Obergrenze, DIN 66398');
INSERT INTO public.retention_rule (class, bezeichnung, fristbeginn, regelfrist_monate, mindestfrist_monate, pseudonymisieren_nach_monaten, rechtsgrundlage) VALUES ('HANDELSRECHT', 'Handels- und steuerrelevante Unterlagen', 'ENTSTEHUNGSJAHRESENDE', 120, 96, NULL, 'Paragraf 147 AO (10 J. Buecher und Abschluesse, 8 J. Buchungsbelege), Paragraf 257 HGB');
INSERT INTO public.retention_rule (class, bezeichnung, fristbeginn, regelfrist_monate, mindestfrist_monate, pseudonymisieren_nach_monaten, rechtsgrundlage) VALUES ('KI_NACHWEIS', 'Nachweis der KI-Pruefung und der Eignungsentscheidung', 'BEZUGSOBJEKT', NULL, 6, 24, 'EU AI Act Art. 19 und Art. 26 Abs. 6 (mindestens 6 Monate), DSGVO Art. 5 Abs. 1 lit. e');
INSERT INTO public.role (id, portal_code, name) VALUES ('29e4bcb8-a9ee-4b42-bbc8-25153532fee9', 'EXMA', 'Plattform-Admin');
INSERT INTO public.role (id, portal_code, name) VALUES ('5682ceae-c54e-4922-b043-56c98a58eb89', 'ENDUSER', 'Endnutzer');
INSERT INTO public.role_right (role_id, right_level) VALUES ('29e4bcb8-a9ee-4b42-bbc8-25153532fee9', 'A');
INSERT INTO public.role_right (role_id, right_level) VALUES ('5682ceae-c54e-4922-b043-56c98a58eb89', 'V');
SELECT pg_catalog.set_config('search_path', '', false);
SET check_function_bodies = false;
SET client_encoding = 'UTF8';
SET client_min_messages = warning;
SET idle_in_transaction_session_timeout = 0;
SET lock_timeout = 0;
SET row_security = on;
SET standard_conforming_strings = on;
SET statement_timeout = 0;
SET xmloption = content;
