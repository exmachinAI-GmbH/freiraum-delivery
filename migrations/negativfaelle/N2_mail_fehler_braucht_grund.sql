-- N2 · Ein Zustellfehler ohne Begruendung
-- erwartet: mail_fehler_braucht_grund
--
-- Ein Fehlschlag ohne Begruendung ist kein Nachweis. Genau dafuer ist der
-- Zustellnachweis da: eine fehlgeschlagene Einladung muss von einer nicht
-- gesendeten unterscheidbar sein (Bauauftrag B2).
INSERT INTO mail_delivery (kind, recipient, sender, status, provider_note)
VALUES ('EINLADUNG', 'niemand@example.org', 'noreply@freiraum.top', 'FEHLER', NULL);
