-- M31 · N4 · Erklaerungszeitpunkt, obwohl eine der beiden Fragen offen ist
-- erwartet: zweck_erklaerung_vollstaendig
--
-- K04-M19 kennt ZWEI Fragen. `zweckbestimmung_erklaert_am` ist die
-- Aussage "die Erklaerung liegt vor" -- sie darf nicht dastehen, solange
-- eine der beiden Fragen offen ist. Sonst traegt der Nachweis ein Datum
-- fuer etwas Halbes. Hier ist Frage 1 beantwortet, Frage 2 nicht, und der
-- Zeitpunkt wird trotzdem gesetzt.
--
-- WARUM DIESER FALL UND NICHT MEHR "Kenntnisnahme ohne Erklaerung":
-- Der frueherer Stand von M31 setzte dafuer die Bedingung
-- `ack_braucht_erklaerung`. Sie ist am 16.08.2026 zurueckgenommen worden,
-- weil sie den bestehenden Migrationsprueffall MT-29 unmoeglich machte
-- und MT-27/MT-28 an die falsche Bedingung zog (Begruendung in
-- M31, Abschnitt 1b). Ein Negativfall gegen eine Bedingung, die es nicht
-- gibt, misst nichts. Dass die Kenntnisnahme keine Anwendung traegt,
-- solange die Erklaerung fehlt, misst weiterhin N2 -- dort am
-- Serverbefehl, wo dieser Riegel jetzt allein sitzt.
--
-- ALLES UEBRIGE IST IN ORDNUNG. Ein Negativfall gilt erst als bestanden,
-- wenn er an SEINER EIGENEN Bedingung scheitert (Bauauftrag §9 Tor I
-- Nr. 6). Deshalb bestehen Mandant, Rechtsraum DE, aktives Konto und die
-- Mandantenzugehoerigkeit; abweichend ist nur, was der Fall misst.
-- `zweckbestimmung_ack_at` bleibt LEER -- damit koennen weder
-- `ack_nach_eignung` noch `ack_klasse_ki_nachweis` aus M30 den Fall an
-- sich ziehen.
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

-- Frage 1 beantwortet, Frage 2 offen -- und trotzdem der Zeitpunkt.
UPDATE fit_check
   SET zweck_bewertung_menschen    = true,
       zweckbestimmung_erklaert_am = now()
 WHERE id = 'a0000000-0000-4000-8000-000000004003'::uuid;

ROLLBACK;
