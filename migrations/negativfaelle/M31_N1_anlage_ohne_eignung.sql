-- M31 · N1 · Eine Anwendung ohne bestandenen Eignungs-Check
-- erwartet: ANLAGE: der Eignungs-Check steht nicht auf GEEIGNET
--
-- K01-M27: die Anwendungszeile entsteht ausschliesslich ueber den
-- Serverbefehl, und er prueft die Eignung in DERSELBEN Transaktion, in
-- der die Zeile entstuende. Ein nullbarer Fremdschluessel im Schema ist
-- keine Erlaubnis, ihn zu umgehen. Die Zweckbestimmung ist hier
-- vollstaendig und trifft keine der beiden Fragen -- offen ist allein das
-- Ergebnis des Checks.
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
VALUES ('a0000000-0000-4000-8000-000000001001'::uuid, 'OPERATOR',
        'M31-N1 Pruefmandant', 'DE-QNA', 'DE');

INSERT INTO actor(id, tenant_id, email, display_name, status)
VALUES ('a0000000-0000-4000-8000-000000001002'::uuid,
        'a0000000-0000-4000-8000-000000001001'::uuid,
        'm31-n1@pruefung.invalid', 'M31-N1 Konto', 'AKTIV');

INSERT INTO fit_check(id, tenant_id, actor_id, outcome, retention_class,
                      zweck_bewertung_menschen, zweck_verbotene_praktik,
                      zweckbestimmung_erklaert_am)
VALUES ('a0000000-0000-4000-8000-000000001003'::uuid,
        'a0000000-0000-4000-8000-000000001001'::uuid,
        'a0000000-0000-4000-8000-000000001002'::uuid,
        'OFFEN', 'KI_NACHWEIS', false, false, now());

SELECT create_app_after_fit(
  'a0000000-0000-4000-8000-000000001001'::uuid,
  'M31-N1 Anwendung',
  'a0000000-0000-4000-8000-000000001003'::uuid,
  'a0000000-0000-4000-8000-000000001002'::uuid);

ROLLBACK;
