-- N4 · Eine Aufbewahrungsfrist von null Tagen
-- erwartet: tagesfrist_positiv
--
-- Eine Frist von null Tagen ist keine Aufbewahrung, sondern sofortiges
-- Loeschen -- und das ist nach den Entscheidungen Nr. 14/15 gesperrt. Wer
-- keine Frist will, traegt keine Klasse ein, nicht die Zahl null.
UPDATE retention_rule SET regelfrist_tage = 0 WHERE class = 'KURZFRIST';
