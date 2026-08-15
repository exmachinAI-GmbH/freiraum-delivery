-- =====================================================================
--  FREIRAUM · Startbestand des Eignungs-Checks (K04)
--  Angelegt 15.08.2026 · Scheibe 2 · Meilenstein M3
--
--  umsetzt: K04-M04, K04-M05, K04-M06, K04-M07, K04-D02
--
--  ZWECK: Die drei Fragen des Eignungs-Checks und ihre
--  Antwortmoeglichkeiten. Genau drei Fragen, je eine je Dimension ART,
--  NUTZUNG und DATEN (K04-M04, K04-D02); feste Reihenfolge ueber
--  `position` 1 bis 3 (K04-M05); jede Antwortmoeglichkeit mit `label_de`,
--  `value_token` und `is_eligible`, kein Freitext (K04-M06); genau VIER
--  Antwortmoeglichkeiten mit `is_eligible` = false (K04-M07).
--
--  ---------------------------------------------------------------------
--  DAS WICHTIGSTE ZUERST: DIESE DATEI SCHREIBT NICHTS UM.
--  ---------------------------------------------------------------------
--
--  Der Bauplan `schema/freiraum_datamodel.sql` -- Rang 1 der Quellenordnung
--  und damit die Quelle, die jeden Widerspruch gewinnt -- FUEHRT DIESEN
--  STARTBESTAND BEREITS SELBST, in seinen Zeilen 736 bis 756, unter der
--  Ueberschrift "SEED: Eignungs-Check (drei Fragen, Ausschluss ueber
--  is_eligible = false)". Er legt dort genau die drei Fragen und genau die
--  dreizehn Antwortmoeglichkeiten an, die auch hier stehen.
--
--  Wer den Bauplan einspielt, hat den Startbestand also schon. Diese Datei
--  ist deshalb ausdruecklich WIEDERHOLBAR und AENDERT NICHTS an vorhandenen
--  Zeilen: jedes INSERT traegt ON CONFLICT DO NOTHING. Laeuft sie gegen eine
--  Datenbank aus dem Bauplan, bewirkt sie nichts. Laeuft sie gegen eine
--  Datenbank, in der die Fragen fehlen, stellt sie exakt denselben Bestand
--  her. Ein Startbestand, der einen vorhandenen ueberschriebe, waere eine
--  stille Aenderung an Rang 1 -- und die ist verboten.
--
--  WORTLAUT: Der Wortlaut der drei Fragen und aller Antwortmoeglichkeiten ist
--  WOERTLICH aus dem Bauplan uebernommen, Zeichen fuer Zeichen. Er ist hier
--  nicht neu gefasst, nicht geglaettet und nicht erfunden. Zum Vorbehalt, der
--  daran haengt, siehe den Abschnitt "OFFENER PUNKT" am Ende dieser Datei.
--
--  NUR SYNTHETISCHE, FACHLICHE STAMMDATEN. Hier steht kein Personenbezug,
--  kein Mandant, kein Vorgang -- nur der Fragenkatalog selbst (K23-M12).
-- =====================================================================

BEGIN;

-- ---------------------------------------------------------------------
-- 1 · Die drei Fragen  (K04-M04, K04-M05, K04-D02)
--
--     `dimension` und `position` sind im Bauplan je tabellenweit eindeutig.
--     Damit kann es zu jeder Dimension hoechstens eine Frage geben -- dass
--     es zu jeder auch MINDESTENS eine gibt, erzwingt keine Bedingung der
--     Datenbank. Genau das stellt diese Datei her und die Gegenprobe am Ende
--     misst es nach.
-- ---------------------------------------------------------------------
INSERT INTO fit_question (code, dimension, position, prompt_de) VALUES
  ('art',     'ART',     1, 'Was soll am Ende entstehen?'),
  ('nutzung', 'NUTZUNG', 2, 'Wer soll damit arbeiten - und wie lange?'),
  ('daten',   'DATEN',   3, 'Beruehrt die Anwendung Ihre Geschaeftsdaten?')
ON CONFLICT (code) DO NOTHING;

-- ---------------------------------------------------------------------
-- 2 · Die Antwortmoeglichkeiten  (K04-M06, K04-M07)
--
--     Je Zeile: `label_de` (was der Nutzer liest), `value_token` (der
--     stabile interne Wert) und `is_eligible`. Kein Freitext, keine
--     Sonstiges-Zeile -- K04-M06 sieht keine vor.
--
--     ON CONFLICT haengt an (question_code, position): das ist die
--     Eindeutigkeit, die der Bauplan fuehrt. `id` ist ein zufaelliger
--     Schluessel und taugt dafuer nicht.
--
--     DIE VIER AUSSCHLUSSANTWORTEN nach K04-M07 sind unten einzeln
--     gekennzeichnet. Die Klausel benennt sie in Kurzform; der Bauplan
--     fuehrt den ausformulierten Bildschirmtext dazu. Beide sind unten
--     nebeneinandergestellt, damit die Zuordnung nachpruefbar ist und nicht
--     geglaubt werden muss.
-- ---------------------------------------------------------------------
INSERT INTO fit_option (question_code, position, label_de, value_token, is_eligible) VALUES
  -- Frage 1 · ART
  ('art', 1, 'Eine Anwendung, mit der Menschen arbeiten - erfassen, pruefen, freigeben', 'Fachanwendung',    true),
  ('art', 2, 'Ein Werkzeug, das einen Arbeitsablauf automatisiert oder unterstuetzt',    'Prozess-Werkzeug', true),
  ('art', 3, 'Eine Plattform fuer mehrere Parteien - Marktplatz, Buchung, Community',    'Plattform',        true),
  -- K04-M07, Ausschluss 1 von 4 -- Klausel: "reine Netzseite"
  ('art', 4, 'Eine Website, die unser Unternehmen oder Produkt darstellt',               'Website / Marketing',   false),
  -- K04-M07, Ausschluss 2 von 4 -- Klausel: "etwas zum Installieren auf Rechner oder Geraet"
  ('art', 5, 'Etwas, das lokal auf dem Rechner oder Geraet installiert wird',            'Installierte Software', false),

  -- Frage 2 · NUTZUNG
  ('nutzung', 1, 'Ein Team im Haus, dauerhaft im Tagesgeschaeft',                  'Intern - dauerhaft', true),
  ('nutzung', 2, 'Unsere Kunden oder Partner, dauerhaft',                          'Extern - dauerhaft', true),
  ('nutzung', 3, 'Zunaechst wenige Personen, aber mit dem Ziel Produktivbetrieb',  'Pilot -> Produktiv', true),
  -- K04-M07, Ausschluss 3 von 4 -- Klausel: "Wegwerf-Versuch ohne Produktivbetrieb"
  ('nutzung', 4, 'Nur zum Ausprobieren einer Idee - danach vermutlich nicht weiter', 'Wegwerf-Versuch',  false),

  -- Frage 3 · DATEN
  ('daten', 1, 'Ja - sie liest oder schreibt Daten aus unseren Systemen (ERP, CRM, DMS, Postfach)', 'Systemdaten',        true),
  ('daten', 2, 'Ja - sie verwaltet eigene Geschaeftsdaten (Vorgaenge, Antraege, Belege, Kunden)',   'Eigene Vorgaenge',   true),
  ('daten', 3, 'Teilweise - vor allem Wissen und Dokumente, die geprueft beantwortet werden sollen','Wissen & Dokumente', true),
  -- K04-M07, Ausschluss 4 von 4 -- die Klausel nennt diesen Wortlaut WOERTLICH:
  --   "bei der Datenfrage: Nein - es geht um Darstellung, Inhalte oder Gestaltung"
  ('daten', 4, 'Nein - es geht um Darstellung, Inhalte oder Gestaltung', 'Nur Darstellung', false)
ON CONFLICT (question_code, position) DO NOTHING;

-- ---------------------------------------------------------------------
-- 3 · Gegenprobe im selben Vorgang  (fail-closed, K04-G04)
--
--     Ein Startbestand, der stillschweigend halb laedt, ist schlimmer als
--     einer, der gar nicht laedt: der Bildschirm saehe vollstaendig aus und
--     waere es nicht. Stimmt eine der vier Zahlen nicht, bricht der Vorgang
--     ab und NICHTS wird festgeschrieben.
-- ---------------------------------------------------------------------
DO $$
DECLARE
  fragen        integer;
  dimensionen   integer;
  optionen      integer;
  ausschluss    integer;
BEGIN
  SELECT count(*)                 INTO fragen      FROM fit_question;
  SELECT count(DISTINCT dimension) INTO dimensionen FROM fit_question;
  SELECT count(*)                 INTO optionen    FROM fit_option;
  SELECT count(*)                 INTO ausschluss  FROM fit_option
   WHERE is_eligible = false;

  -- K04-M04 und K04-D02: nicht mehr und nicht weniger als drei Fragen.
  IF fragen <> 3 OR dimensionen <> 3 THEN
    RAISE EXCEPTION
      'Der Eignungs-Check fuehrt % Fragen ueber % Dimensionen. Verlangt sind '
      'genau drei Fragen, je eine je Dimension ART, NUTZUNG und DATEN '
      '(K04-M04, K04-D02).', fragen, dimensionen;
  END IF;

  -- Eine Frage ohne Antwortmoeglichkeiten liesse sich nicht beantworten.
  IF optionen <> 13 THEN
    RAISE EXCEPTION
      'Der Eignungs-Check fuehrt % Antwortmoeglichkeiten. Der Startbestand '
      'sieht 13 vor (5 zur Art, 4 zur Nutzung, 4 zu den Daten).', optionen;
  END IF;

  -- K04-M07: genau vier Ausschlussantworten. Eine mehr sperrte Vorhaben, die
  -- keine Klausel ausschliesst; eine weniger liesse eines durch, das eine
  -- Klausel ausschliesst.
  IF ausschluss <> 4 THEN
    RAISE EXCEPTION
      'Der Eignungs-Check fuehrt % Antwortmoeglichkeiten mit is_eligible = '
      'false. K04-M07 verlangt genau vier.', ausschluss;
  END IF;
END $$;

COMMIT;

-- =====================================================================
--  OFFENER PUNKT · der Wortlaut der drei Fragen
--
--  Der Plan zu diesem Meilenstein fuehrt als offenen Punkt O-M3-1, der
--  Wortlaut der drei Eignungsfragen sei nicht gezeichnet, und sieht dafuer
--  sichtbar gekennzeichnete Platzhalter vor.
--
--  DIESER STARTBESTAND FUEHRT KEINE PLATZHALTER, und das ist eine
--  Entscheidung mit Grund: Der Wortlaut STEHT im Bauplan
--  `schema/freiraum_datamodel.sql`, Zeilen 736 bis 756 -- und der Bauplan ist
--  Rang 1 der Quellenordnung. Er gewinnt jeden Widerspruch, auch den gegen
--  einen Plan. Platzhalter einzutragen hiesse hier zweierlei zugleich:
--
--    (a) den Rang-1-Bestand zu ueberschreiben, was ausdruecklich verboten
--        ist -- das Zielschema wird BENUTZT, nie geaendert; und
--    (b) technisch gar nicht moeglich zu sein, ohne genau das zu tun:
--        `code`, `dimension` und `position` sind je eindeutig. Ein zweiter
--        Satz Fragen mit Platzhaltertexten wuerde von der Datenbank
--        abgewiesen, ein UPDATE waere die Aenderung an Rang 1.
--
--  WAS OFFEN BLEIBT, ist eine andere Frage als die des Plans: KEINE KLAUSEL
--  des Konzepts K04 nennt den Wortlaut der drei Fragen. Er ist im Bauplan
--  belegt, aber nicht in den 24 gezeichneten Konzepten. Wer den Wortlaut
--  aendern will, aendert damit Rang 1 -- und das ist eine Entscheidung fuer
--  einen Menschen, nicht fuer diesen Startbestand.
--
--  ZUM WORTLAUT DER VIER AUSSCHLUSSANTWORTEN: K04-M07 benennt sie in
--  Kurzform ("reine Netzseite", "etwas zum Installieren auf Rechner oder
--  Geraet", "Wegwerf-Versuch ohne Produktivbetrieb") und nur die vierte
--  woertlich als Bildschirmtext ("Nein - es geht um Darstellung, Inhalte
--  oder Gestaltung"). Der Bauplan fuehrt zu jeder der ersten drei einen
--  ausformulierten Bildschirmtext. Die Zuordnung steht oben Zeile fuer Zeile
--  im Kommentar. Sie ist eine LESART und keine Zeichnung -- wer sie anders
--  liest, soll sie dort nachlesen und widersprechen koennen.
--
--  GEGENPROBE VON HAND nach dem Laden:
--
--    SELECT position, code, dimension, prompt_de FROM fit_question
--     ORDER BY position;
--      -> genau drei Zeilen, Positionen 1, 2, 3, Dimensionen ART, NUTZUNG,
--         DATEN
--
--    SELECT question_code, position, label_de FROM fit_option
--     WHERE is_eligible = false ORDER BY question_code, position;
--      -> genau vier Zeilen: art/4, art/5, daten/4, nutzung/4
--
--    SELECT q.code, count(o.id) FROM fit_question q
--      JOIN fit_option o ON o.question_code = q.code GROUP BY q.code;
--      -> art 5, nutzung 4, daten 4. Keine Frage ohne Antwortmoeglichkeit.
-- =====================================================================
