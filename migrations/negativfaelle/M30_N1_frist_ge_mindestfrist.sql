-- N1 · Eine Mindestfrist, die laenger ist als die Regelfrist
-- erwartet: frist_ge_mindestfrist
--
-- UMBENANNT AM 19.08.2026 (war: N1_frist_ge_mindestfrist.sql). Der Riegel in Tor 1b zaehlt seit
-- diesem Tag JE MIGRATION vier Negativfaelle statt vier ueber alle (V-7,
-- gezeichnet als Entscheidung 8). Dafuer muss der Dateiname sagen, zu
-- welcher Migration der Fall gehoert. Diese vier pruefen Bedingungen, die
-- M30 einfuehrt -- am Inhalt ist nichts geaendert.
--
-- Die Regelfrist ist die Frist. Eine Untergrenze darueber hinaus waere keine
-- Untergrenze, sondern eine zweite, laengere Frist -- und dann wuesste niemand,
-- welche gilt. K15-M01 verlangt genau eine Zeile je Klasse.
UPDATE retention_rule
   SET mindestfrist_monate = 240
 WHERE class = 'HANDELSRECHT';
