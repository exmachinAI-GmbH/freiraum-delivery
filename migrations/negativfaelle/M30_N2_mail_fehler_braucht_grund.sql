-- N2 · Ein Zustellfehler ohne Begruendung
-- erwartet: mail_fehler_braucht_grund
--
-- UMBENANNT AM 19.08.2026 (war: N2_mail_fehler_braucht_grund.sql). Der Riegel in Tor 1b zaehlt seit
-- diesem Tag JE MIGRATION vier Negativfaelle statt vier ueber alle (V-7,
-- gezeichnet als Entscheidung 8). Dafuer muss der Dateiname sagen, zu
-- welcher Migration der Fall gehoert. Diese vier pruefen Bedingungen, die
-- M30 einfuehrt -- am Inhalt ist nichts geaendert.
--
-- Ein Fehlschlag ohne Begruendung ist kein Nachweis. Genau dafuer ist der
-- Zustellnachweis da: eine fehlgeschlagene Einladung muss von einer nicht
-- gesendeten unterscheidbar sein (Bauauftrag B2).
INSERT INTO mail_delivery (kind, recipient, sender, status, provider_note)
VALUES ('EINLADUNG', 'niemand@example.org', 'noreply@freiraum.top', 'FEHLER', NULL);
