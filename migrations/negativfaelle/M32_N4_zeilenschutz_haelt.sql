-- M32 · N4 · Eine Dokumentzeile fuer einen fremden Mandanten
-- erwartet: new row violates row-level security policy
--
-- K05-M27: RLS und Serverpfad leiten den Mandanten AUSSCHLIESSLICH ueber
-- document.app_id -> app.tenant_id ab. K02-M20 und K13-M08 verlangen die
-- Grenze zweifach -- im Serverpfad UND im Datenbestand. Dieser Fall misst
-- die zweite Haelfte: die Zeilenregel selbst, ohne jeden Serverpfad.
--
-- ALLES UEBRIGE IST IN ORDNUNG: beide Mandanten bestehen, die Anwendung ist
-- ueber den einen Weg angelegt, die Dokumentzeile ist vollstaendig und
-- formal gueltig. Abweichend ist allein die gesetzte Sitzung: sie gehoert
-- Mandant B, die Anwendung Mandant A.
--
-- ZWEI DINGE MUESSEN STIMMEN, sonst misst der Fall nichts:
--
--   1  Die Sitzung ist gesetzt. Ohne sie laesst die Regel absichtlich durch
--      (M32, Stufe 1). Mit ihr filtert sie IMMER, unabhaengig vom Schalter.
--
--   2  DER FALL LAEUFT NICHT ALS SUPERUSER. Beim ersten Versuch lief er
--      durch -- FORCE ROW LEVEL SECURITY gilt fuer den Eigentuemer, aber
--      NIE fuer einen Superuser, und die Migration laeuft als postgres
--      (rolsuper = t). Genau das ist die Lage der gebauten Anwendung: sie
--      verbindet sich heute ohne Rollenwechsel. Deshalb wechselt dieser
--      Fall ausdruecklich auf fr_portal -- die Rolle, die der Serverpfad
--      kuenftig tragen muss (Zug 2 des Bauplans). Ein Zeilenschutz, der
--      nur gegen Nicht-Superuser haelt, ist eine Ansage an den Bau, nicht
--      an den Angreifer.
BEGIN;

INSERT INTO tenant(id, kind, name, customer_code, legal_space) VALUES
 ('b2000000-0000-4000-8000-000000000401'::uuid,'OPERATOR','M32-N4 Mandant A','DE-QNF','DE'),
 ('b2000000-0000-4000-8000-000000000404'::uuid,'CUSTOMER','M32-N4 Mandant B','DE-QNG','DE');

INSERT INTO actor(id, tenant_id, email, display_name, status)
VALUES ('b2000000-0000-4000-8000-000000000402'::uuid,
        'b2000000-0000-4000-8000-000000000401'::uuid,
        'm32-n4@pruefung.invalid','M32-N4 Konto A','AKTIV');

INSERT INTO fit_check(id, tenant_id, actor_id, outcome, completed_at, retention_class,
                      zweck_bewertung_menschen, zweck_verbotene_praktik,
                      zweckbestimmung_erklaert_am)
VALUES ('b2000000-0000-4000-8000-000000000403'::uuid,
        'b2000000-0000-4000-8000-000000000401'::uuid,
        'b2000000-0000-4000-8000-000000000402'::uuid,
        'GEEIGNET', now(), 'KI_NACHWEIS', false, false, now());

SELECT create_app_after_fit(
  'b2000000-0000-4000-8000-000000000401'::uuid,'M32-N4 Anwendung',
  'b2000000-0000-4000-8000-000000000403'::uuid,
  'b2000000-0000-4000-8000-000000000402'::uuid);

-- Die Kennung der Anwendung wird VOR dem Wechsel gelesen und festgehalten.
--
-- WARUM NICHT ALS UNTERABFRAGE: Beim zweiten Versuch stand hier
-- "INSERT ... SELECT a.id FROM app a WHERE ...". Unter der Sitzung von
-- Mandant B ist die Anwendung von A durch die Zeilenregel unsichtbar --
-- die Unterabfrage lieferte NULL Zeilen, es wurde nichts eingefuegt, und
-- der Fall lief GRUEN durch, ohne die Regel je zu beruehren. Ein Fall, der
-- nichts einfuegt, misst keine Einfuegeregel.
SELECT id AS anwendung_a FROM app
 WHERE fit_check_id='b2000000-0000-4000-8000-000000000403'::uuid \gset

-- Die Sitzung gehoert Mandant B.
SELECT set_config('freiraum.tenant_id','b2000000-0000-4000-8000-000000000404',true);

-- Ohne diesen Wechsel misst der Fall nichts (siehe Kopf, Punkt 2).
SET LOCAL ROLE fr_portal;

INSERT INTO document(id, app_id, kind, filename)
VALUES ('b2000000-0000-4000-8000-000000000405'::uuid,
        :'anwendung_a'::uuid,
        'INTERVIEW_PROTOCOL'::document_kind, 'm32-n4-protokoll.json');

ROLLBACK;
