
















































































































































































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
-- Data for Name: actor; Type: TABLE DATA; Schema: public; Owner: frxadmin
-- Data for Name: agent; Type: TABLE DATA; Schema: public; Owner: frxadmin
-- Data for Name: agent_knowledge; Type: TABLE DATA; Schema: public; Owner: frxadmin
-- Data for Name: agent_policy; Type: TABLE DATA; Schema: public; Owner: frxadmin
-- Data for Name: agent_template; Type: TABLE DATA; Schema: public; Owner: frxadmin
-- Data for Name: app; Type: TABLE DATA; Schema: public; Owner: frxadmin
-- Data for Name: app_state_history; Type: TABLE DATA; Schema: public; Owner: frxadmin
-- Data for Name: approval; Type: TABLE DATA; Schema: public; Owner: frxadmin
-- Data for Name: auth_session; Type: TABLE DATA; Schema: public; Owner: frxadmin
-- Data for Name: contact; Type: TABLE DATA; Schema: public; Owner: frxadmin
-- Data for Name: contract_check; Type: TABLE DATA; Schema: public; Owner: frxadmin
-- Data for Name: direct_prototype; Type: TABLE DATA; Schema: public; Owner: frxadmin
-- Data for Name: document; Type: TABLE DATA; Schema: public; Owner: frxadmin
-- Data for Name: document_version; Type: TABLE DATA; Schema: public; Owner: frxadmin
-- Data for Name: event; Type: TABLE DATA; Schema: public; Owner: frxadmin
-- Data for Name: fit_answer; Type: TABLE DATA; Schema: public; Owner: frxadmin
-- Data for Name: fit_check; Type: TABLE DATA; Schema: public; Owner: frxadmin
-- Data for Name: fit_option; Type: TABLE DATA; Schema: public; Owner: frxadmin
-- Data for Name: fit_question; Type: TABLE DATA; Schema: public; Owner: frxadmin
-- Data for Name: invitation; Type: TABLE DATA; Schema: public; Owner: frxadmin
-- Data for Name: invitation_decision; Type: TABLE DATA; Schema: public; Owner: frxadmin
-- Data for Name: knowledge_module; Type: TABLE DATA; Schema: public; Owner: frxadmin
-- Data for Name: knowledge_module_source; Type: TABLE DATA; Schema: public; Owner: frxadmin
-- Data for Name: knowledge_module_version; Type: TABLE DATA; Schema: public; Owner: frxadmin
-- Data for Name: knowledge_source; Type: TABLE DATA; Schema: public; Owner: frxadmin
-- Data for Name: lifecycle_state_label; Type: TABLE DATA; Schema: public; Owner: frxadmin
-- Data for Name: login_attempt; Type: TABLE DATA; Schema: public; Owner: frxadmin
-- Data for Name: login_code; Type: TABLE DATA; Schema: public; Owner: frxadmin
-- Data for Name: mail_delivery; Type: TABLE DATA; Schema: public; Owner: frxadmin
-- Data for Name: membership; Type: TABLE DATA; Schema: public; Owner: frxadmin
-- Data for Name: model_manifest; Type: TABLE DATA; Schema: public; Owner: frxadmin
-- Data for Name: model_manifest_version; Type: TABLE DATA; Schema: public; Owner: frxadmin
-- Data for Name: model_ref; Type: TABLE DATA; Schema: public; Owner: frxadmin
-- Data for Name: module; Type: TABLE DATA; Schema: public; Owner: frxadmin
-- Data for Name: nummernvorrat; Type: TABLE DATA; Schema: public; Owner: frxadmin
-- Data for Name: policy; Type: TABLE DATA; Schema: public; Owner: frxadmin
-- Data for Name: policy_version; Type: TABLE DATA; Schema: public; Owner: frxadmin
-- Data for Name: portal; Type: TABLE DATA; Schema: public; Owner: frxadmin
-- Data for Name: project_contract; Type: TABLE DATA; Schema: public; Owner: frxadmin
-- Data for Name: quick_answer; Type: TABLE DATA; Schema: public; Owner: frxadmin
-- Data for Name: quick_check; Type: TABLE DATA; Schema: public; Owner: frxadmin
-- Data for Name: quick_option; Type: TABLE DATA; Schema: public; Owner: frxadmin
-- Data for Name: quick_question; Type: TABLE DATA; Schema: public; Owner: frxadmin
-- Data for Name: quick_question_version; Type: TABLE DATA; Schema: public; Owner: frxadmin
-- Data for Name: retention_rule; Type: TABLE DATA; Schema: public; Owner: frxadmin
-- Data for Name: review_finding; Type: TABLE DATA; Schema: public; Owner: frxadmin
-- Data for Name: review_run; Type: TABLE DATA; Schema: public; Owner: frxadmin
-- Data for Name: role; Type: TABLE DATA; Schema: public; Owner: frxadmin
-- Data for Name: role_right; Type: TABLE DATA; Schema: public; Owner: frxadmin
-- Data for Name: schema_migration; Type: TABLE DATA; Schema: public; Owner: frxadmin
-- Data for Name: state_transition; Type: TABLE DATA; Schema: public; Owner: frxadmin
-- Data for Name: template; Type: TABLE DATA; Schema: public; Owner: frxadmin
-- Data for Name: template_element; Type: TABLE DATA; Schema: public; Owner: frxadmin
-- Data for Name: template_version; Type: TABLE DATA; Schema: public; Owner: frxadmin
-- Data for Name: tenant; Type: TABLE DATA; Schema: public; Owner: frxadmin
-- Data for Name: tenant_invite_domain; Type: TABLE DATA; Schema: public; Owner: frxadmin
-- Data for Name: test_harness; Type: TABLE DATA; Schema: public; Owner: frxadmin
-- Dumped by pg_dump version 16.14 (Homebrew)
-- Dumped from database version 16.14
-- PostgreSQL database dump
-- PostgreSQL database dump complete
INSERT INTO public.fit_option (id, question_code, "position", label_de, value_token, is_eligible) VALUES ('15d964c2-6115-4452-863c-74aa0eba2cc9', 'art', 5, 'Etwas, das lokal auf dem Rechner oder Geraet installiert wird', 'Installierte Software', false);
INSERT INTO public.fit_option (id, question_code, "position", label_de, value_token, is_eligible) VALUES ('25fdb2e8-e3cb-455d-9baa-7ba0e6fb27f5', 'art', 4, 'Eine Website, die unser Unternehmen oder Produkt darstellt', 'Website / Marketing', false);
INSERT INTO public.fit_option (id, question_code, "position", label_de, value_token, is_eligible) VALUES ('27b73495-3f6d-4f7d-9f33-2b7336e2b97c', 'nutzung', 4, 'Nur zum Ausprobieren einer Idee - danach vermutlich nicht weiter', 'Wegwerf-Versuch', false);
INSERT INTO public.fit_option (id, question_code, "position", label_de, value_token, is_eligible) VALUES ('284a267d-42e5-4242-ac2e-6f181f5b5ace', 'art', 3, 'Eine Plattform fuer mehrere Parteien - Marktplatz, Buchung, Community', 'Plattform', true);
INSERT INTO public.fit_option (id, question_code, "position", label_de, value_token, is_eligible) VALUES ('2b2182f3-694d-478c-9085-c79b8c3eaf72', 'daten', 3, 'Teilweise - vor allem Wissen und Dokumente, die geprueft beantwortet werden sollen', 'Wissen & Dokumente', true);
INSERT INTO public.fit_option (id, question_code, "position", label_de, value_token, is_eligible) VALUES ('3d78d5c8-1ba1-40f0-b516-6ece31e18cdc', 'daten', 2, 'Ja - sie verwaltet eigene Geschaeftsdaten (Vorgaenge, Antraege, Belege, Kunden)', 'Eigene Vorgaenge', true);
INSERT INTO public.fit_option (id, question_code, "position", label_de, value_token, is_eligible) VALUES ('7fde9ff1-18f4-4858-9e2e-cdb599f29226', 'daten', 1, 'Ja - sie liest oder schreibt Daten aus unseren Systemen (ERP, CRM, DMS, Postfach)', 'Systemdaten', true);
INSERT INTO public.fit_option (id, question_code, "position", label_de, value_token, is_eligible) VALUES ('9dc0cb8d-7156-4d0b-9732-9a5941899c5d', 'nutzung', 3, 'Zunaechst wenige Personen, aber mit dem Ziel Produktivbetrieb', 'Pilot -> Produktiv', true);
INSERT INTO public.fit_option (id, question_code, "position", label_de, value_token, is_eligible) VALUES ('a519abea-c963-4bab-adbc-ae6bf43a4695', 'nutzung', 2, 'Unsere Kunden oder Partner, dauerhaft', 'Extern - dauerhaft', true);
INSERT INTO public.fit_option (id, question_code, "position", label_de, value_token, is_eligible) VALUES ('ba98a8f1-7d92-4f2e-844f-13a37b1bc8a0', 'nutzung', 1, 'Ein Team im Haus, dauerhaft im Tagesgeschaeft', 'Intern - dauerhaft', true);
INSERT INTO public.fit_option (id, question_code, "position", label_de, value_token, is_eligible) VALUES ('bfa14fa8-e783-4b28-b3c6-143ca3919fd1', 'art', 1, 'Eine Anwendung, mit der Menschen arbeiten - erfassen, pruefen, freigeben', 'Fachanwendung', true);
INSERT INTO public.fit_option (id, question_code, "position", label_de, value_token, is_eligible) VALUES ('c58d0318-231d-4f3d-b23e-e2a8f10f5e28', 'daten', 4, 'Nein - es geht um Darstellung, Inhalte oder Gestaltung', 'Nur Darstellung', false);
INSERT INTO public.fit_option (id, question_code, "position", label_de, value_token, is_eligible) VALUES ('cdbf7c3f-ee4f-4cfb-9acb-17a729cf79dd', 'art', 2, 'Ein Werkzeug, das einen Arbeitsablauf automatisiert oder unterstuetzt', 'Prozess-Werkzeug', true);
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
INSERT INTO public.model_ref (id, token, provider, model, version, hosting, manifest_id, manifest_version) VALUES ('2fdfb8e9-4e48-404b-8f35-687d6f1742eb', 'GPT-4o', 'OPENAI', 'GPT-4o', 'n/a', 'AZURE_EU', NULL, NULL);
INSERT INTO public.model_ref (id, token, provider, model, version, hosting, manifest_id, manifest_version) VALUES ('3221f229-9156-4c04-9b59-eb54db8423e2', 'Klassifikator', 'INTERN', 'Klassifikator', 'n/a', 'ON_PREM_DE', NULL, NULL);
INSERT INTO public.model_ref (id, token, provider, model, version, hosting, manifest_id, manifest_version) VALUES ('7126b5a2-2e9d-4f58-810d-ecaeb1502003', 'SLM lokal', 'INTERN', 'SLM lokal', 'n/a', 'ON_PREM_DE', NULL, NULL);
INSERT INTO public.model_ref (id, token, provider, model, version, hosting, manifest_id, manifest_version) VALUES ('76ae5ee6-c45f-469e-b202-960aa3930b30', 'Claude Sonnet', 'ANTHROPIC', 'Claude Sonnet', 'n/a', 'AZURE_EU', NULL, NULL);
INSERT INTO public.model_ref (id, token, provider, model, version, hosting, manifest_id, manifest_version) VALUES ('8051d317-2398-4fe8-be7e-64db7c269f2b', 'gemäß Auswahl', 'OFFEN', 'gemäß Auswahl', 'n/a', 'OFFEN', NULL, NULL);
INSERT INTO public.model_ref (id, token, provider, model, version, hosting, manifest_id, manifest_version) VALUES ('82988fb6-f906-441f-b0c0-8ccb9b89a6c6', 'GPT-4o mini', 'OPENAI', 'GPT-4o mini', 'n/a', 'AZURE_EU', NULL, NULL);
INSERT INTO public.module (display_code, internal_key, name, portal_code) VALUES ('M1', 'm1', 'Wissensbausteine', 'EXMA');
INSERT INTO public.module (display_code, internal_key, name, portal_code) VALUES ('M2', 'm2', 'Formatvorlagen', 'EXMA');
INSERT INTO public.module (display_code, internal_key, name, portal_code) VALUES ('M3', 'm4', 'KI-Agenten', 'EXMA');
INSERT INTO public.module (display_code, internal_key, name, portal_code) VALUES ('M4', 'm6', 'Richtlinien', 'EXMA');
INSERT INTO public.nummernvorrat (praefix, naechste_nummer, verwendung, geaendert_am) VALUES ('PROJ', 1, 'Projektnummer project_no (K01-M38)', '2026-08-06 12:10:46.304954+00');
INSERT INTO public.nummernvorrat (praefix, naechste_nummer, verwendung, geaendert_am) VALUES ('REG', 1, 'Registernummer register_no bei erster Freigabe (K08-M24)', '2026-08-06 12:10:46.304954+00');
INSERT INTO public.nummernvorrat (praefix, naechste_nummer, verwendung, geaendert_am) VALUES ('USER', 1, 'Konto-Kennung user_code (K20-M24)', '2026-08-06 12:10:46.304954+00');
INSERT INTO public.portal (code, name, release_status, data_locality) VALUES ('ENDUSER', 'Endnutzer-Portal', 'ENABLED', 'EU-Azure/swedencentral');
INSERT INTO public.portal (code, name, release_status, data_locality) VALUES ('EXMA', 'EXMA-Portal', 'ENABLED', 'EU-Azure/swedencentral');
INSERT INTO public.portal (code, name, release_status, data_locality) VALUES ('INDIA_OPS', 'India-Ops-Portal', 'PLANNED', 'EU-Azure/swedencentral');
INSERT INTO public.portal (code, name, release_status, data_locality) VALUES ('USER_ADMIN', 'User-Admin-Portal', 'PLANNED', 'EU-Azure/swedencentral');
INSERT INTO public.portal (code, name, release_status, data_locality) VALUES ('VAR_ADMIN', 'VAR-Admin-Portal', 'PLANNED', 'EU-Azure/swedencentral');
INSERT INTO public.retention_rule (class, bezeichnung, fristbeginn, regelfrist_monate, mindestfrist_monate, pseudonymisieren_nach_monaten, rechtsgrundlage, regelfrist_tage) VALUES ('ARBEITSERGEBNIS', 'Arbeitsergebnisse ohne Nachweischarakter (Direkt-Prototyp)', 'ERSTELLUNG', NULL, 0, NULL, 'Offene Punkte O-K12-1, A-K12-1, O-K15-8; kein gesetzlicher Aufbewahrungsgrund', 90);
INSERT INTO public.retention_rule (class, bezeichnung, fristbeginn, regelfrist_monate, mindestfrist_monate, pseudonymisieren_nach_monaten, rechtsgrundlage, regelfrist_tage) VALUES ('BETRIEBSPROTOKOLL', 'Betriebsprotokoll ohne handelsrechtlichen Bezug', 'ERSTELLUNG', 24, 6, 12, 'EU AI Act Art. 19 als Untergrenze, DSGVO Art. 5 Abs. 1 lit. e als Obergrenze, DIN 66398', NULL);
INSERT INTO public.retention_rule (class, bezeichnung, fristbeginn, regelfrist_monate, mindestfrist_monate, pseudonymisieren_nach_monaten, rechtsgrundlage, regelfrist_tage) VALUES ('EREIGNIS', 'Unveraenderbare Ereigniszeilen (Protokoll)', 'BEZUGSOBJEKT', NULL, 0, NULL, 'Beschluss Nr. 60 (Option A) und Nr. 16: Beweiswert vor Loeschzusage. Ohne Faelligkeit und ohne Anonymisierung -- die Zeile bleibt, wie sie ist', NULL);
INSERT INTO public.retention_rule (class, bezeichnung, fristbeginn, regelfrist_monate, mindestfrist_monate, pseudonymisieren_nach_monaten, rechtsgrundlage, regelfrist_tage) VALUES ('HANDELSRECHT', 'Handels- und steuerrelevante Unterlagen', 'ENTSTEHUNGSJAHRESENDE', 120, 96, NULL, 'Paragraf 147 AO (10 J. Buecher und Abschluesse, 8 J. Buchungsbelege), Paragraf 257 HGB', NULL);
INSERT INTO public.retention_rule (class, bezeichnung, fristbeginn, regelfrist_monate, mindestfrist_monate, pseudonymisieren_nach_monaten, rechtsgrundlage, regelfrist_tage) VALUES ('KI_NACHWEIS', 'Nachweis der KI-Pruefung und der Eignungsentscheidung', 'BEZUGSOBJEKT', NULL, 6, 24, 'EU AI Act Art. 19 und Art. 26 Abs. 6 (mindestens 6 Monate), DSGVO Art. 5 Abs. 1 lit. e', NULL);
INSERT INTO public.retention_rule (class, bezeichnung, fristbeginn, regelfrist_monate, mindestfrist_monate, pseudonymisieren_nach_monaten, rechtsgrundlage, regelfrist_tage) VALUES ('KURZFRIST', 'Kurzlebige Zugangsartefakte (Einladungen, Anmeldecodes, Versandnachweise)', 'ERSTELLUNG', NULL, 1, NULL, 'Beschluss Nr. 17 (Pflichtangabe 3.8.2026: 30 Tage) und Nr. 35; DSGVO Art. 5 Abs. 1 lit. e', 30);
INSERT INTO public.retention_rule (class, bezeichnung, fristbeginn, regelfrist_monate, mindestfrist_monate, pseudonymisieren_nach_monaten, rechtsgrundlage, regelfrist_tage) VALUES ('PROJEKT_VORVERTRAG', 'Projekte vor Vertragsschluss (vor Stufe 05)', 'ERSTELLUNG', NULL, 0, NULL, 'Beschluss Nr. 58 (30/60/90-Regel fuer untaetige Projekte); DSGVO Art. 5 Abs. 1 lit. e', 90);
INSERT INTO public.role (id, portal_code, name) VALUES ('93f65443-bb15-4e0a-99ef-7884ce7b7799', 'EXMA', 'Plattform-Admin');
INSERT INTO public.role (id, portal_code, name) VALUES ('d567c625-aa93-40e8-9645-9b40078d0b1f', 'ENDUSER', 'Endnutzer');
INSERT INTO public.role_right (role_id, right_level) VALUES ('93f65443-bb15-4e0a-99ef-7884ce7b7799', 'A');
INSERT INTO public.role_right (role_id, right_level) VALUES ('d567c625-aa93-40e8-9645-9b40078d0b1f', 'V');
INSERT INTO public.schema_migration (version, beschreibung, applied_at) VALUES ('v3.0-pilot-01', 'Sammelmigration der 29 Matrixzeilen (Pruefbericht 4.8.2026, Abschnitt 8, Stufen 1-7), einschliesslich der sechs Merkmale aus Nr. 24 (Entscheidung E2 vom 4.8.2026) und des entschiedenen Anmeldecode-Bauplans (Entscheidung E3, Bau-Vorschlag 260802), dem Nachtrag aus dem Befund vom 5.8. (Stufe 9), den sechs gezeichneten Vorfragen V1-V6 vom 5.8.2026 (Stufe 10) und den Zeichnungen T4 und T1 aus den Fremdreviews vom 5.8.2026 (Stufen 11 und 12) sowie der Zeichnung P3 aus Add-On 03 (Stufe 13) sowie den zwei privilegierten Serverbefehlen und dem Rechteschnitt nach dem Tor-3-Delta-Review (Stufe 14) und der Einschraenkung nach Loeschverlangen (Stufe 15, gez. A. Han) sowie den drei Nachtraegen aus dem Tor-3-Delta-Review (Stufe 16).', '2026-08-06 12:10:46.304954+00');
INSERT INTO public.state_transition (from_state, to_state, authority, bedingung) VALUES ('ABNAHME', 'IN_DEV', 'VERWALTER', 'Nacharbeit — einziger Rueckweg ohne zweite Person');
INSERT INTO public.state_transition (from_state, to_state, authority, bedingung) VALUES ('ABNAHME', 'IN_PROD', 'ZWEI_PERSONEN', 'das Uebergabe-Paket ist uebergeben');
INSERT INTO public.state_transition (from_state, to_state, authority, bedingung) VALUES ('ABNAHME', 'PAUSIERT', 'VERWALTER', 'mit Grund im Protokoll');
INSERT INTO public.state_transition (from_state, to_state, authority, bedingung) VALUES ('BEAUFTRAGT', 'IN_BEARBEITUNG', 'ZWEI_PERSONEN', 'Ruecknahme einer Beauftragung, mit Grund');
INSERT INTO public.state_transition (from_state, to_state, authority, bedingung) VALUES ('BEAUFTRAGT', 'IN_DEV', 'VERWALTER', 'der Bau beginnt');
INSERT INTO public.state_transition (from_state, to_state, authority, bedingung) VALUES ('BEAUFTRAGT', 'PAUSIERT', 'VERWALTER', 'mit Grund; der Vertrag bleibt bestehen');
INSERT INTO public.state_transition (from_state, to_state, authority, bedingung) VALUES ('DISCOVERY', 'IN_BEARBEITUNG', 'SYSTEM', 'Stufe 02 betreten, Interview beginnt');
INSERT INTO public.state_transition (from_state, to_state, authority, bedingung) VALUES ('DISCOVERY', 'PAUSIERT', 'VERWALTER', 'mit Grund im Protokoll');
INSERT INTO public.state_transition (from_state, to_state, authority, bedingung) VALUES ('IN_BEARBEITUNG', 'BEAUFTRAGT', 'SYSTEM', 'nur mit Zwei-Personen-Freigabe und festgeschriebenem Projekt');
INSERT INTO public.state_transition (from_state, to_state, authority, bedingung) VALUES ('IN_BEARBEITUNG', 'PAUSIERT', 'VERWALTER', 'mit Grund im Protokoll');
INSERT INTO public.state_transition (from_state, to_state, authority, bedingung) VALUES ('IN_DEV', 'ABNAHME', 'VERWALTER', 'der Prototyp liegt vor');
INSERT INTO public.state_transition (from_state, to_state, authority, bedingung) VALUES ('IN_DEV', 'PAUSIERT', 'VERWALTER', 'mit Grund im Protokoll');
INSERT INTO public.state_transition (from_state, to_state, authority, bedingung) VALUES ('IN_PROD', 'PAUSIERT', 'VERWALTER', 'nur Betreuung, nicht der Betrieb der Anwendung');
INSERT INTO public.state_transition (from_state, to_state, authority, bedingung) VALUES ('PAUSIERT', 'ABNAHME', 'VERWALTER', 'nur zurueck in den letzten Zustand vor der Pause');
INSERT INTO public.state_transition (from_state, to_state, authority, bedingung) VALUES ('PAUSIERT', 'BEAUFTRAGT', 'ZWEI_PERSONEN', 'Rueckweg in den Vertragszustand — entschieden 4.8.2026');
INSERT INTO public.state_transition (from_state, to_state, authority, bedingung) VALUES ('PAUSIERT', 'DISCOVERY', 'VERWALTER', 'nur zurueck in den letzten Zustand vor der Pause');
INSERT INTO public.state_transition (from_state, to_state, authority, bedingung) VALUES ('PAUSIERT', 'IN_BEARBEITUNG', 'VERWALTER', 'nur zurueck in den letzten Zustand vor der Pause');
INSERT INTO public.state_transition (from_state, to_state, authority, bedingung) VALUES ('PAUSIERT', 'IN_DEV', 'VERWALTER', 'nur zurueck in den letzten Zustand vor der Pause');
INSERT INTO public.state_transition (from_state, to_state, authority, bedingung) VALUES ('PAUSIERT', 'IN_PROD', 'VERWALTER', 'nur zurueck in den letzten Zustand vor der Pause');
SELECT pg_catalog.set_config('search_path', '', false);
SET check_function_bodies = false;
SET client_encoding = 'UTF8';
SET client_min_messages = warning;
SET idle_in_transaction_session_timeout = 0;
SET lock_timeout = 0;
SET row_security = off;
SET standard_conforming_strings = on;
SET statement_timeout = 0;
SET xmloption = content;
