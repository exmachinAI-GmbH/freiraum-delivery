-- M31 · N4 · Kenntnisnahme ohne vollstaendige Zweckbestimmungs-Erklaerung
-- erwartet: ack_braucht_erklaerung
--
-- K04-M20 und der Bildschirmvertrag EN-04a: die Kenntnisnahme erscheint
-- NUR nach einem Treffer in Frage 1 -- also fruehestens, wenn beide Fragen
-- beantwortet sind. Eine Bestaetigung zu etwas, das niemand erklaert hat,
-- ist kein Nachweis. Der Eignungs-Check steht auf GEEIGNET und traegt die
-- Klasse KI_NACHWEIS; die beiden Bedingungen aus M30 (ack_nach_eignung,
-- ack_klasse_ki_nachweis) sind damit erfuellt und koennen den Fall nicht
-- an sich ziehen.
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
VALUES ('a0000000-0000-4000-8000-000000004001'::uuid, 'OPERATOR',
        'M31-N4 Pruefmandant', 'DE-QND', 'DE');

INSERT INTO actor(id, tenant_id, email, display_name, status)
VALUES ('a0000000-0000-4000-8000-000000004002'::uuid,
        'a0000000-0000-4000-8000-000000004001'::uuid,
        'm31-n4@pruefung.invalid', 'M31-N4 Konto', 'AKTIV');

INSERT INTO fit_check(id, tenant_id, actor_id, outcome, completed_at,
                      retention_class)
VALUES ('a0000000-0000-4000-8000-000000004003'::uuid,
        'a0000000-0000-4000-8000-000000004001'::uuid,
        'a0000000-0000-4000-8000-000000004002'::uuid,
        'GEEIGNET', now(), 'KI_NACHWEIS');

UPDATE fit_check SET zweckbestimmung_ack_at = now()
 WHERE id = 'a0000000-0000-4000-8000-000000004003'::uuid;

ROLLBACK;
