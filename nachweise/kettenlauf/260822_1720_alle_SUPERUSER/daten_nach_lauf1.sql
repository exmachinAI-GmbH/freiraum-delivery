
















































































































































































--
--
--
--
--
--
--
--
--
--
--
--
--
--
--
--
--
--
--
--
--
--
--
--
--
--
--
--
--
--
--
--
--
--
--
--
--
--
--
--
--
--
--
--
--
--
--
--
--
--
--
--
--
--
--
--
--
--
--
--
--
--
--
--
--
--
--
--
--
--
--
--
--
--
--
--
--
--
--
--
--
--
--
--
--
--
--
--
--
--
--
--
--
--
--
--
--
--
--
--
--
--
--
--
--
--
--
--
--
--
--
--
--
--
--
--
--
--
-- Data for Name: actor; Type: TABLE DATA; Schema: public; Owner: freiraum
-- Data for Name: agent; Type: TABLE DATA; Schema: public; Owner: freiraum
-- Data for Name: agent_knowledge; Type: TABLE DATA; Schema: public; Owner: freiraum
-- Data for Name: agent_policy; Type: TABLE DATA; Schema: public; Owner: freiraum
-- Data for Name: agent_template; Type: TABLE DATA; Schema: public; Owner: freiraum
-- Data for Name: app; Type: TABLE DATA; Schema: public; Owner: freiraum
-- Data for Name: app_state_history; Type: TABLE DATA; Schema: public; Owner: freiraum
-- Data for Name: approval; Type: TABLE DATA; Schema: public; Owner: freiraum
-- Data for Name: auth_session; Type: TABLE DATA; Schema: public; Owner: freiraum
-- Data for Name: contact; Type: TABLE DATA; Schema: public; Owner: freiraum
-- Data for Name: contract_check; Type: TABLE DATA; Schema: public; Owner: freiraum
-- Data for Name: direct_prototype; Type: TABLE DATA; Schema: public; Owner: freiraum
-- Data for Name: document; Type: TABLE DATA; Schema: public; Owner: freiraum
-- Data for Name: document_version; Type: TABLE DATA; Schema: public; Owner: freiraum
-- Data for Name: event; Type: TABLE DATA; Schema: public; Owner: freiraum
-- Data for Name: fit_answer; Type: TABLE DATA; Schema: public; Owner: freiraum
-- Data for Name: fit_check; Type: TABLE DATA; Schema: public; Owner: freiraum
-- Data for Name: fit_option; Type: TABLE DATA; Schema: public; Owner: freiraum
-- Data for Name: fit_question; Type: TABLE DATA; Schema: public; Owner: freiraum
-- Data for Name: invitation; Type: TABLE DATA; Schema: public; Owner: freiraum
-- Data for Name: invitation_decision; Type: TABLE DATA; Schema: public; Owner: freiraum
-- Data for Name: knowledge_module; Type: TABLE DATA; Schema: public; Owner: freiraum
-- Data for Name: knowledge_module_source; Type: TABLE DATA; Schema: public; Owner: freiraum
-- Data for Name: knowledge_module_version; Type: TABLE DATA; Schema: public; Owner: freiraum
-- Data for Name: knowledge_source; Type: TABLE DATA; Schema: public; Owner: freiraum
-- Data for Name: lifecycle_state_label; Type: TABLE DATA; Schema: public; Owner: freiraum
-- Data for Name: login_attempt; Type: TABLE DATA; Schema: public; Owner: freiraum
-- Data for Name: login_code; Type: TABLE DATA; Schema: public; Owner: freiraum
-- Data for Name: mail_delivery; Type: TABLE DATA; Schema: public; Owner: freiraum
-- Data for Name: membership; Type: TABLE DATA; Schema: public; Owner: freiraum
-- Data for Name: model_manifest; Type: TABLE DATA; Schema: public; Owner: freiraum
-- Data for Name: model_manifest_version; Type: TABLE DATA; Schema: public; Owner: freiraum
-- Data for Name: model_ref; Type: TABLE DATA; Schema: public; Owner: freiraum
-- Data for Name: module; Type: TABLE DATA; Schema: public; Owner: freiraum
-- Data for Name: nummernvorrat; Type: TABLE DATA; Schema: public; Owner: freiraum
-- Data for Name: policy; Type: TABLE DATA; Schema: public; Owner: freiraum
-- Data for Name: policy_version; Type: TABLE DATA; Schema: public; Owner: freiraum
-- Data for Name: portal; Type: TABLE DATA; Schema: public; Owner: freiraum
-- Data for Name: project_contract; Type: TABLE DATA; Schema: public; Owner: freiraum
-- Data for Name: quick_answer; Type: TABLE DATA; Schema: public; Owner: freiraum
-- Data for Name: quick_check; Type: TABLE DATA; Schema: public; Owner: freiraum
-- Data for Name: quick_option; Type: TABLE DATA; Schema: public; Owner: freiraum
-- Data for Name: quick_question; Type: TABLE DATA; Schema: public; Owner: freiraum
-- Data for Name: quick_question_version; Type: TABLE DATA; Schema: public; Owner: freiraum
-- Data for Name: retention_rule; Type: TABLE DATA; Schema: public; Owner: freiraum
-- Data for Name: review_finding; Type: TABLE DATA; Schema: public; Owner: freiraum
-- Data for Name: review_run; Type: TABLE DATA; Schema: public; Owner: freiraum
-- Data for Name: role; Type: TABLE DATA; Schema: public; Owner: freiraum
-- Data for Name: role_right; Type: TABLE DATA; Schema: public; Owner: freiraum
-- Data for Name: schema_migration; Type: TABLE DATA; Schema: public; Owner: freiraum
-- Data for Name: state_transition; Type: TABLE DATA; Schema: public; Owner: freiraum
-- Data for Name: template; Type: TABLE DATA; Schema: public; Owner: freiraum
-- Data for Name: template_element; Type: TABLE DATA; Schema: public; Owner: freiraum
-- Data for Name: template_version; Type: TABLE DATA; Schema: public; Owner: freiraum
-- Data for Name: tenant; Type: TABLE DATA; Schema: public; Owner: freiraum
-- Data for Name: tenant_invite_domain; Type: TABLE DATA; Schema: public; Owner: freiraum
-- Data for Name: test_harness; Type: TABLE DATA; Schema: public; Owner: freiraum
-- Dumped by pg_dump version 16.13 (Ubuntu 16.13-0ubuntu0.24.04.1)
-- Dumped from database version 16.13 (Ubuntu 16.13-0ubuntu0.24.04.1)
-- PostgreSQL database dump
-- PostgreSQL database dump complete
INSERT INTO public.fit_option (id, question_code, "position", label_de, value_token, is_eligible) VALUES ('09dba85a-2e71-4046-ba05-002d58cc2b87', 'daten', 4, 'Nein - es geht um Darstellung, Inhalte oder Gestaltung', 'Nur Darstellung', false);
INSERT INTO public.fit_option (id, question_code, "position", label_de, value_token, is_eligible) VALUES ('21e1745f-8a45-40e5-aef7-f7972ea9edd5', 'nutzung', 1, 'Ein Team im Haus, dauerhaft im Tagesgeschaeft', 'Intern - dauerhaft', true);
INSERT INTO public.fit_option (id, question_code, "position", label_de, value_token, is_eligible) VALUES ('2eec6be5-49a2-4337-b75a-c48f6812289e', 'nutzung', 3, 'Zunaechst wenige Personen, aber mit dem Ziel Produktivbetrieb', 'Pilot -> Produktiv', true);
INSERT INTO public.fit_option (id, question_code, "position", label_de, value_token, is_eligible) VALUES ('3b890899-df70-4d4a-9eb1-37d029498939', 'daten', 3, 'Teilweise - vor allem Wissen und Dokumente, die geprueft beantwortet werden sollen', 'Wissen & Dokumente', true);
INSERT INTO public.fit_option (id, question_code, "position", label_de, value_token, is_eligible) VALUES ('4bf0c161-a86a-4ed9-8e0d-931ecb3ccc34', 'art', 2, 'Ein Werkzeug, das einen Arbeitsablauf automatisiert oder unterstuetzt', 'Prozess-Werkzeug', true);
INSERT INTO public.fit_option (id, question_code, "position", label_de, value_token, is_eligible) VALUES ('50ead041-ec91-4a67-a89c-f39a65366054', 'daten', 2, 'Ja - sie verwaltet eigene Geschaeftsdaten (Vorgaenge, Antraege, Belege, Kunden)', 'Eigene Vorgaenge', true);
INSERT INTO public.fit_option (id, question_code, "position", label_de, value_token, is_eligible) VALUES ('73d20e17-564c-4ab6-9337-8b278d63e27e', 'art', 1, 'Eine Anwendung, mit der Menschen arbeiten - erfassen, pruefen, freigeben', 'Fachanwendung', true);
INSERT INTO public.fit_option (id, question_code, "position", label_de, value_token, is_eligible) VALUES ('84ff0cfc-bdfa-48cd-806f-b688f0244faf', 'art', 5, 'Etwas, das lokal auf dem Rechner oder Geraet installiert wird', 'Installierte Software', false);
INSERT INTO public.fit_option (id, question_code, "position", label_de, value_token, is_eligible) VALUES ('9eab48a3-5922-4ee1-9b5a-c775811d65d6', 'nutzung', 2, 'Unsere Kunden oder Partner, dauerhaft', 'Extern - dauerhaft', true);
INSERT INTO public.fit_option (id, question_code, "position", label_de, value_token, is_eligible) VALUES ('a44579f7-05ab-4f20-b091-af5a410086ec', 'nutzung', 4, 'Nur zum Ausprobieren einer Idee - danach vermutlich nicht weiter', 'Wegwerf-Versuch', false);
INSERT INTO public.fit_option (id, question_code, "position", label_de, value_token, is_eligible) VALUES ('b26fa340-2fda-4d11-b62e-1f51ef3e8384', 'art', 4, 'Eine Website, die unser Unternehmen oder Produkt darstellt', 'Website / Marketing', false);
INSERT INTO public.fit_option (id, question_code, "position", label_de, value_token, is_eligible) VALUES ('dfc46c6c-1f15-4ddc-ab63-ffcd19ed7d9f', 'daten', 1, 'Ja - sie liest oder schreibt Daten aus unseren Systemen (ERP, CRM, DMS, Postfach)', 'Systemdaten', true);
INSERT INTO public.fit_option (id, question_code, "position", label_de, value_token, is_eligible) VALUES ('e7f1d93e-0dcf-4ada-ad3a-e7d4dc27b527', 'art', 3, 'Eine Plattform fuer mehrere Parteien - Marktplatz, Buchung, Community', 'Plattform', true);
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
INSERT INTO public.model_ref (id, token, provider, model, version, hosting, manifest_id, manifest_version) VALUES ('2844ff7c-2e59-484c-b67b-5a591efdd521', 'GPT-4o mini', 'OPENAI', 'GPT-4o mini', 'n/a', 'AZURE_EU', NULL, NULL);
INSERT INTO public.model_ref (id, token, provider, model, version, hosting, manifest_id, manifest_version) VALUES ('55b2106d-8da5-4918-acd2-da3e0b30f303', 'Klassifikator', 'INTERN', 'Klassifikator', 'n/a', 'ON_PREM_DE', NULL, NULL);
INSERT INTO public.model_ref (id, token, provider, model, version, hosting, manifest_id, manifest_version) VALUES ('9ea9552c-3f17-413d-8e29-e40594ef0a11', 'SLM lokal', 'INTERN', 'SLM lokal', 'n/a', 'ON_PREM_DE', NULL, NULL);
INSERT INTO public.model_ref (id, token, provider, model, version, hosting, manifest_id, manifest_version) VALUES ('b7882da2-7333-48ab-8785-681e56baf3f5', 'gemäß Auswahl', 'OFFEN', 'gemäß Auswahl', 'n/a', 'OFFEN', NULL, NULL);
INSERT INTO public.model_ref (id, token, provider, model, version, hosting, manifest_id, manifest_version) VALUES ('c7f73342-061e-4c8a-b93b-4c61c111d0b3', 'Claude Sonnet', 'ANTHROPIC', 'Claude Sonnet', 'n/a', 'AZURE_EU', NULL, NULL);
INSERT INTO public.model_ref (id, token, provider, model, version, hosting, manifest_id, manifest_version) VALUES ('d31dcac3-869e-4b0b-9930-fd320a51fce5', 'GPT-4o', 'OPENAI', 'GPT-4o', 'n/a', 'AZURE_EU', NULL, NULL);
INSERT INTO public.module (display_code, internal_key, name, portal_code) VALUES ('M1', 'm1', 'Wissensbausteine', 'EXMA');
INSERT INTO public.module (display_code, internal_key, name, portal_code) VALUES ('M2', 'm2', 'Formatvorlagen', 'EXMA');
INSERT INTO public.module (display_code, internal_key, name, portal_code) VALUES ('M3', 'm4', 'KI-Agenten', 'EXMA');
INSERT INTO public.module (display_code, internal_key, name, portal_code) VALUES ('M4', 'm6', 'Richtlinien', 'EXMA');
INSERT INTO public.nummernvorrat (praefix, naechste_nummer, verwendung, geaendert_am) VALUES ('PROJ', 1, 'Projektnummer project_no (K01-M38)', '2026-08-22 17:20:45.720988+00');
INSERT INTO public.nummernvorrat (praefix, naechste_nummer, verwendung, geaendert_am) VALUES ('REG', 1, 'Registernummer register_no bei erster Freigabe (K08-M24)', '2026-08-22 17:20:45.720988+00');
INSERT INTO public.nummernvorrat (praefix, naechste_nummer, verwendung, geaendert_am) VALUES ('USER', 1, 'Konto-Kennung user_code (K20-M24)', '2026-08-22 17:20:45.720988+00');
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
INSERT INTO public.role (id, portal_code, name) VALUES ('2d8bd046-0ce5-4aca-9245-2c4d80f9319d', 'ENDUSER', 'Endnutzer');
INSERT INTO public.role (id, portal_code, name) VALUES ('6ce961f3-3e68-4d5a-96d2-66936e177c2b', 'EXMA', 'Plattform-Admin');
INSERT INTO public.role_right (role_id, right_level) VALUES ('2d8bd046-0ce5-4aca-9245-2c4d80f9319d', 'V');
INSERT INTO public.role_right (role_id, right_level) VALUES ('6ce961f3-3e68-4d5a-96d2-66936e177c2b', 'A');
INSERT INTO public.schema_migration (version, beschreibung, applied_at) VALUES ('v3.0-pilot-01', 'Sammelmigration der 29 Matrixzeilen (Pruefbericht 4.8.2026, Abschnitt 8, Stufen 1-7), einschliesslich der sechs Merkmale aus Nr. 24 (Entscheidung E2 vom 4.8.2026) und des entschiedenen Anmeldecode-Bauplans (Entscheidung E3, Bau-Vorschlag 260802), dem Nachtrag aus dem Befund vom 5.8. (Stufe 9), den sechs gezeichneten Vorfragen V1-V6 vom 5.8.2026 (Stufe 10) und den Zeichnungen T4 und T1 aus den Fremdreviews vom 5.8.2026 (Stufen 11 und 12) sowie der Zeichnung P3 aus Add-On 03 (Stufe 13) sowie den zwei privilegierten Serverbefehlen und dem Rechteschnitt nach dem Tor-3-Delta-Review (Stufe 14) und der Einschraenkung nach Loeschverlangen (Stufe 15, gez. A. Han) sowie den drei Nachtraegen aus dem Tor-3-Delta-Review (Stufe 16).', '2026-08-22 17:20:45.720988+00');
INSERT INTO public.schema_migration (version, beschreibung, applied_at) VALUES ('v3.0-pilot-02', 'M31 · Die Projektnummer wandert in den Serverbefehl (K01-M38, K01-D19), die fuenfte Pruefung aus K01-M27 (currency = EUR) wird nachgezogen, und der Eignungs-Check bekommt den Traeger der Zweckbestimmungs-Erklaerung: zwei nullbare Ja/Nein-Spalten und den Zeitpunkt der Vollstaendigkeit (K04-M19). Die Anlage verlangt seither die vollstaendige Erklaerung, weist einen Treffer in Frage 2 ab (K04-D10) und verlangt bei einem Treffer in Frage 1 die Kenntnisnahme (K04-M21).', '2026-08-22 17:20:45.961304+00');
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
