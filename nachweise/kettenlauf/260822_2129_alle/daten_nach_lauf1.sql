
















































































































































































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
-- Dumped by pg_dump version 18.6
-- Dumped from database version 16.14
-- PostgreSQL database dump
-- PostgreSQL database dump complete
INSERT INTO public.fit_option (id, question_code, "position", label_de, value_token, is_eligible) VALUES ('0788c00c-dfcb-46b6-891e-17fd9266cd64', 'daten', 4, 'Nein - es geht um Darstellung, Inhalte oder Gestaltung', 'Nur Darstellung', false);
INSERT INTO public.fit_option (id, question_code, "position", label_de, value_token, is_eligible) VALUES ('0b1c6325-9923-4d7d-a8f3-a3ccede41f09', 'art', 5, 'Etwas, das lokal auf dem Rechner oder Geraet installiert wird', 'Installierte Software', false);
INSERT INTO public.fit_option (id, question_code, "position", label_de, value_token, is_eligible) VALUES ('45ff41b1-3c4c-4ebb-a384-dcf880fd3e4d', 'art', 2, 'Ein Werkzeug, das einen Arbeitsablauf automatisiert oder unterstuetzt', 'Prozess-Werkzeug', true);
INSERT INTO public.fit_option (id, question_code, "position", label_de, value_token, is_eligible) VALUES ('4f508e1a-d432-4db6-8460-095f22d5c899', 'daten', 2, 'Ja - sie verwaltet eigene Geschaeftsdaten (Vorgaenge, Antraege, Belege, Kunden)', 'Eigene Vorgaenge', true);
INSERT INTO public.fit_option (id, question_code, "position", label_de, value_token, is_eligible) VALUES ('5231838a-fd3a-4b8e-ad65-54f0ed9d9c43', 'nutzung', 4, 'Nur zum Ausprobieren einer Idee - danach vermutlich nicht weiter', 'Wegwerf-Versuch', false);
INSERT INTO public.fit_option (id, question_code, "position", label_de, value_token, is_eligible) VALUES ('5272b6e6-9014-46f9-b73a-91423016ae8c', 'daten', 3, 'Teilweise - vor allem Wissen und Dokumente, die geprueft beantwortet werden sollen', 'Wissen & Dokumente', true);
INSERT INTO public.fit_option (id, question_code, "position", label_de, value_token, is_eligible) VALUES ('67e85b07-abde-494e-a446-a1d5890df1e1', 'nutzung', 2, 'Unsere Kunden oder Partner, dauerhaft', 'Extern - dauerhaft', true);
INSERT INTO public.fit_option (id, question_code, "position", label_de, value_token, is_eligible) VALUES ('79e22485-d22c-41e7-a97b-c258fb54f1dc', 'nutzung', 1, 'Ein Team im Haus, dauerhaft im Tagesgeschaeft', 'Intern - dauerhaft', true);
INSERT INTO public.fit_option (id, question_code, "position", label_de, value_token, is_eligible) VALUES ('8c8a6402-5dd5-45f5-a5f4-66eb3b4e7db8', 'art', 4, 'Eine Website, die unser Unternehmen oder Produkt darstellt', 'Website / Marketing', false);
INSERT INTO public.fit_option (id, question_code, "position", label_de, value_token, is_eligible) VALUES ('9c17ee37-6190-42fc-89e6-c15ac04ebe94', 'art', 1, 'Eine Anwendung, mit der Menschen arbeiten - erfassen, pruefen, freigeben', 'Fachanwendung', true);
INSERT INTO public.fit_option (id, question_code, "position", label_de, value_token, is_eligible) VALUES ('af669f18-ebaf-4446-84c8-913561ce95ae', 'daten', 1, 'Ja - sie liest oder schreibt Daten aus unseren Systemen (ERP, CRM, DMS, Postfach)', 'Systemdaten', true);
INSERT INTO public.fit_option (id, question_code, "position", label_de, value_token, is_eligible) VALUES ('b82d0a9e-97f2-493a-86bf-7ae2070a90e3', 'art', 3, 'Eine Plattform fuer mehrere Parteien - Marktplatz, Buchung, Community', 'Plattform', true);
INSERT INTO public.fit_option (id, question_code, "position", label_de, value_token, is_eligible) VALUES ('e153efcc-ba9f-475a-991e-a3f914029143', 'nutzung', 3, 'Zunaechst wenige Personen, aber mit dem Ziel Produktivbetrieb', 'Pilot -> Produktiv', true);
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
INSERT INTO public.model_ref (id, token, provider, model, version, hosting, manifest_id, manifest_version) VALUES ('074eb064-4fb8-4a5a-8ea8-d5cbaf30c491', 'Klassifikator', 'INTERN', 'Klassifikator', 'n/a', 'ON_PREM_DE', NULL, NULL);
INSERT INTO public.model_ref (id, token, provider, model, version, hosting, manifest_id, manifest_version) VALUES ('6d028a73-268b-4ecb-9b2f-ada0e2be84d2', 'SLM lokal', 'INTERN', 'SLM lokal', 'n/a', 'ON_PREM_DE', NULL, NULL);
INSERT INTO public.model_ref (id, token, provider, model, version, hosting, manifest_id, manifest_version) VALUES ('7da1bcee-7f21-42a1-bc46-3f7eb3deeb82', 'gemäß Auswahl', 'OFFEN', 'gemäß Auswahl', 'n/a', 'OFFEN', NULL, NULL);
INSERT INTO public.model_ref (id, token, provider, model, version, hosting, manifest_id, manifest_version) VALUES ('b6325b6a-39d3-4bca-8eec-dcf80f090986', 'Claude Sonnet', 'ANTHROPIC', 'Claude Sonnet', 'n/a', 'AZURE_EU', NULL, NULL);
INSERT INTO public.model_ref (id, token, provider, model, version, hosting, manifest_id, manifest_version) VALUES ('c3e666b2-4c24-4f33-b39e-aca9b44460b4', 'GPT-4o mini', 'OPENAI', 'GPT-4o mini', 'n/a', 'AZURE_EU', NULL, NULL);
INSERT INTO public.model_ref (id, token, provider, model, version, hosting, manifest_id, manifest_version) VALUES ('e77a8c9a-f986-47dd-b326-de1df44eaa47', 'GPT-4o', 'OPENAI', 'GPT-4o', 'n/a', 'AZURE_EU', NULL, NULL);
INSERT INTO public.module (display_code, internal_key, name, portal_code) VALUES ('M1', 'm1', 'Wissensbausteine', 'EXMA');
INSERT INTO public.module (display_code, internal_key, name, portal_code) VALUES ('M2', 'm2', 'Formatvorlagen', 'EXMA');
INSERT INTO public.module (display_code, internal_key, name, portal_code) VALUES ('M3', 'm4', 'KI-Agenten', 'EXMA');
INSERT INTO public.module (display_code, internal_key, name, portal_code) VALUES ('M4', 'm6', 'Richtlinien', 'EXMA');
INSERT INTO public.nummernvorrat (praefix, naechste_nummer, verwendung, geaendert_am) VALUES ('PROJ', 1, 'Projektnummer project_no (K01-M38)', '2026-08-22 19:29:37.836465+00');
INSERT INTO public.nummernvorrat (praefix, naechste_nummer, verwendung, geaendert_am) VALUES ('REG', 1, 'Registernummer register_no bei erster Freigabe (K08-M24)', '2026-08-22 19:29:37.836465+00');
INSERT INTO public.nummernvorrat (praefix, naechste_nummer, verwendung, geaendert_am) VALUES ('USER', 1, 'Konto-Kennung user_code (K20-M24)', '2026-08-22 19:29:37.836465+00');
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
INSERT INTO public.role (id, portal_code, name) VALUES ('bc04a825-0748-41a9-8d6a-2853ee6217ab', 'EXMA', 'Plattform-Admin');
INSERT INTO public.role (id, portal_code, name) VALUES ('decc7abe-ef2f-419e-8ec7-dfdbc61b5bfc', 'ENDUSER', 'Endnutzer');
INSERT INTO public.role_right (role_id, right_level) VALUES ('bc04a825-0748-41a9-8d6a-2853ee6217ab', 'A');
INSERT INTO public.role_right (role_id, right_level) VALUES ('decc7abe-ef2f-419e-8ec7-dfdbc61b5bfc', 'V');
INSERT INTO public.schema_migration (version, beschreibung, applied_at) VALUES ('v3.0-pilot-01', 'Sammelmigration der 29 Matrixzeilen (Pruefbericht 4.8.2026, Abschnitt 8, Stufen 1-7), einschliesslich der sechs Merkmale aus Nr. 24 (Entscheidung E2 vom 4.8.2026) und des entschiedenen Anmeldecode-Bauplans (Entscheidung E3, Bau-Vorschlag 260802), dem Nachtrag aus dem Befund vom 5.8. (Stufe 9), den sechs gezeichneten Vorfragen V1-V6 vom 5.8.2026 (Stufe 10) und den Zeichnungen T4 und T1 aus den Fremdreviews vom 5.8.2026 (Stufen 11 und 12) sowie der Zeichnung P3 aus Add-On 03 (Stufe 13) sowie den zwei privilegierten Serverbefehlen und dem Rechteschnitt nach dem Tor-3-Delta-Review (Stufe 14) und der Einschraenkung nach Loeschverlangen (Stufe 15, gez. A. Han) sowie den drei Nachtraegen aus dem Tor-3-Delta-Review (Stufe 16).', '2026-08-22 19:29:37.836465+00');
INSERT INTO public.schema_migration (version, beschreibung, applied_at) VALUES ('v3.0-pilot-02', 'M31 · Die Projektnummer wandert in den Serverbefehl (K01-M38, K01-D19), die fuenfte Pruefung aus K01-M27 (currency = EUR) wird nachgezogen, und der Eignungs-Check bekommt den Traeger der Zweckbestimmungs-Erklaerung: zwei nullbare Ja/Nein-Spalten und den Zeitpunkt der Vollstaendigkeit (K04-M19). Die Anlage verlangt seither die vollstaendige Erklaerung, weist einen Treffer in Frage 2 ab (K04-D10) und verlangt bei einem Treffer in Frage 1 die Kenntnisnahme (K04-M21).', '2026-08-22 19:29:47.150444+00');
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
SET row_security = on;
SET standard_conforming_strings = on;
SET statement_timeout = 0;
SET transaction_timeout = 0;
SET xmloption = content;
