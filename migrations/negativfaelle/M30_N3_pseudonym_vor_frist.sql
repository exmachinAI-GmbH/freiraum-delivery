-- N3 · Pseudonymisierung nach dem Ende der Aufbewahrung
-- erwartet: pseudonym_vor_frist
--
-- UMBENANNT AM 19.08.2026 (war: N3_pseudonym_vor_frist.sql). Der Riegel in Tor 1b zaehlt seit
-- diesem Tag JE MIGRATION vier Negativfaelle statt vier ueber alle (V-7,
-- gezeichnet als Entscheidung 8). Dafuer muss der Dateiname sagen, zu
-- welcher Migration der Fall gehoert. Diese vier pruefen Bedingungen, die
-- M30 einfuehrt -- am Inhalt ist nichts geaendert.
--
-- Wer erst pseudonymisiert, nachdem die Frist abgelaufen ist, pseudonymisiert
-- nie: die Zeile ist dann bereits entfernt. Die Massnahme muss VOR dem
-- Fristende greifen, sonst ist sie eine Absichtserklaerung.
--
-- HINWEIS ZUR AUSWAHL DIESES FALLS. Der urspruengliche N3 setzte auf
-- login_code_ende_eindeutig und lautete:
--
--     INSERT INTO login_code (actor_id, code_hash, consumed_at, superseded_at)
--     SELECT id, repeat('a',64), now(), now() FROM actor LIMIT 1;
--
-- Er LIEF DURCH -- nicht weil die Bedingung fehlte, sondern weil `actor` in
-- einer frischen Datenbank leer ist und das INSERT ... SELECT null Zeilen
-- einfuegt. Ein Negativfall, der aus dem falschen Grund besteht, belegt nichts
-- (O-K23-7; derselbe Fehlertyp wie in Migration 260801). Dieser Fall arbeitet
-- deshalb auf retention_rule, das M30 selbst saet -- er haengt an keiner
-- Saatdatei.
UPDATE retention_rule
   SET pseudonymisieren_nach_monaten = regelfrist_monate + 12
 WHERE class = 'HANDELSRECHT';
