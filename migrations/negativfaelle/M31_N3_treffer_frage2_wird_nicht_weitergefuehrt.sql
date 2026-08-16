-- M31 · N3 · Anlage bei Treffer in Frage 2, mit vorliegender Kenntnisnahme
-- erwartet: ZWECKBESTIMMUNG: verbotene Praktik nach Art. 5
--
-- K04-D10: ein Treffer in der zweiten Frage wird NICHT weitergefuehrt --
-- dort heilt keine Aufklaerung und keine Bestaetigung. Genau das misst
-- dieser Fall: die Kenntnisnahme LIEGT VOR, und die Anlage scheitert
-- trotzdem. Und sie scheitert an der zweiten Frage und nicht an der
-- ersten, obwohl beide zutreffen (K04-M20, Vorrang der zweiten Frage).
--
-- ALLES UEBRIGE IST IN ORDNUNG. Ein Negativfall gilt erst als bestanden,
-- wenn er an SEINER EIGENEN Bedingung scheitert (Bauauftrag §9 Tor I
-- Nr. 6). Deshalb bestehen Mandant, Rechtsraum DE, aktives Konto und die
-- Mandantenzugehoerigkeit; abweichend ist nur, was der Fall misst.
-- DER KUNDENCODE TRAEGT KEINE ZIFFER. '^DE-[A-Z]{3}$' laesst keine zu --
-- ein Code wie 'DE-QN1' scheiterte an customer_code_fmt, also an einer
-- fremden Bedingung, und der Fall maesse nichts. Genau dieser Fehler ist
-- am 02.08.2026 in drei von vier Negativfaellen aufgetreten
-- (migrations/pruefe_negativfaelle.sh, Kopf).
BEGIN;

INSERT INTO tenant(id, kind, name, customer_code, legal_space)
VALUES ('a0000000-0000-4000-8000-000000003001'::uuid, 'OPERATOR',
        'M31-N3 Pruefmandant', 'DE-QNC', 'DE');

INSERT INTO actor(id, tenant_id, email, display_name, status)
VALUES ('a0000000-0000-4000-8000-000000003002'::uuid,
        'a0000000-0000-4000-8000-000000003001'::uuid,
        'm31-n3@pruefung.invalid', 'M31-N3 Konto', 'AKTIV');

INSERT INTO fit_check(id, tenant_id, actor_id, outcome, completed_at,
                      retention_class, zweck_bewertung_menschen,
                      zweck_verbotene_praktik, zweckbestimmung_erklaert_am,
                      zweckbestimmung_ack_at)
VALUES ('a0000000-0000-4000-8000-000000003003'::uuid,
        'a0000000-0000-4000-8000-000000003001'::uuid,
        'a0000000-0000-4000-8000-000000003002'::uuid,
        'GEEIGNET', now(), 'KI_NACHWEIS', true, true, now(), now());

SELECT create_app_after_fit(
  'a0000000-0000-4000-8000-000000003001'::uuid,
  'M31-N3 Anwendung',
  'a0000000-0000-4000-8000-000000003003'::uuid,
  'a0000000-0000-4000-8000-000000003002'::uuid);

ROLLBACK;
