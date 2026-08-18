-- M31 · N2 · Anlage bei Treffer in Frage 1 ohne Kenntnisnahme
-- erwartet: ZWECKBESTIMMUNG: die Kenntnisnahme zu Anhang III fehlt
--
-- K04-M21: die Kenntnisnahme ist Vorbedingung der Anlage. Ohne sie ist
-- die Auskunftspflicht nach Art. 25 Abs. 4 der KI-Verordnung nicht
-- belegbar. Der Eignungs-Check steht hier auf GEEIGNET, die Erklaerung ist
-- vollstaendig, die zweite Frage ist verneint -- es fehlt allein die
-- Bestaetigung.
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
VALUES ('a0000000-0000-4000-8000-000000002001'::uuid, 'OPERATOR',
        'M31-N2 Pruefmandant', 'DE-QNB', 'DE');

INSERT INTO actor(id, tenant_id, email, display_name, status)
VALUES ('a0000000-0000-4000-8000-000000002002'::uuid,
        'a0000000-0000-4000-8000-000000002001'::uuid,
        'm31-n2@pruefung.invalid', 'M31-N2 Konto', 'AKTIV');

INSERT INTO fit_check(id, tenant_id, actor_id, outcome, completed_at,
                      retention_class, zweck_bewertung_menschen,
                      zweck_verbotene_praktik, zweckbestimmung_erklaert_am)
VALUES ('a0000000-0000-4000-8000-000000002003'::uuid,
        'a0000000-0000-4000-8000-000000002001'::uuid,
        'a0000000-0000-4000-8000-000000002002'::uuid,
        'GEEIGNET', now(), 'KI_NACHWEIS', true, false, now());

SELECT create_app_after_fit(
  'a0000000-0000-4000-8000-000000002001'::uuid,
  'M31-N2 Anwendung',
  'a0000000-0000-4000-8000-000000002003'::uuid,
  'a0000000-0000-4000-8000-000000002002'::uuid);

ROLLBACK;
