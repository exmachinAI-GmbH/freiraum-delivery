-- N1 · Eine Mindestfrist, die laenger ist als die Regelfrist
-- erwartet: frist_ge_mindestfrist
--
-- Die Regelfrist ist die Frist. Eine Untergrenze darueber hinaus waere keine
-- Untergrenze, sondern eine zweite, laengere Frist -- und dann wuesste niemand,
-- welche gilt. K15-M01 verlangt genau eine Zeile je Klasse.
UPDATE retention_rule
   SET mindestfrist_monate = 240
 WHERE class = 'HANDELSRECHT';
