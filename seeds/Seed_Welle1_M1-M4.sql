-- =====================================================================
--  FREIRAUM · Seed Welle 1 · Module M1 bis M4
--  Stand 01.08.2026 · Grundlage: Befuellungsplan_M1-M4.md, Quellendossier
--
--  ZWECK: Das neutrale Testminimum. Es beweist, dass die Kette haelt --
--  Quelle, Baustein, Verdrahtung, Agent, Antwort, Protokoll. Es beweist
--  NICHT, dass die Antworten fachlich taugen. Beides wird nach K23-G04
--  getrennt ausgewiesen.
--
--  ZWEI DINGE, DIE DIESER SEED BEWUSST NICHT TUT:
--
--  1. Er setzt nichts auf RELEASED. Jeder Baustein braucht die
--     Vier-Augen-Freigabe nach K14 -- und die ist eine menschliche
--     Handlung, kein INSERT. Alles entsteht als DRAFT.
--
--  2. Er traegt keinen Wissenstext. knowledge_module hat acht Spalten und
--     keine davon nimmt Inhalt auf; der Inhalt existiert allein als
--     Verweis ueber knowledge_module_source auf knowledge_source.source_ref.
--     Wir kuratieren Fundstellen, wir schreiben keine Lehrbuecher.
--
--  LIZENZLAGE: Jede Quelle hier ist geprueft. Die Spalte license ist im
--  DDL Freitext ohne Bedingung -- K08-M17/M18/M23 verlangen die Angabe,
--  die Datenbank erzwingt sie nicht (offener Punkt O-BEF-2). Bis die
--  Sperre gebaut ist, ist "kommerziell nutzbar" eine Behauptung im
--  Freitextfeld. Das ist der wichtigste Vorbehalt dieser Datei.
-- =====================================================================

BEGIN;

-- ---------------------------------------------------------------------
-- 1 · Quellen  (M1, Register nach K08)
--    Nur Quellen, deren Lizenz die kommerzielle Einspeisung ausdruecklich
--    erlaubt ODER die als reines Verweisziel zulaessig sind.
-- ---------------------------------------------------------------------

INSERT INTO knowledge_source
  (id, register_no, type, origin, source_ref, wissensbereich, domaene, license, mode, status, editor, added_at)
VALUES
  -- METHODENWISSEN
  ('Q-OMG-1', 'OMG-00001', 'WEB', 'EXTERN',
   'https://www.omg.org/spec/BPMN/2.0.2/',
   'Methode', 'Prozessnotation',
   -- Lizenzbedingungen im Wortlaut (haben im Schema kein eigenes Feld, O-K08-12):
   --   OMG Specification License -- Nutzung zur Erstellung und Verbreitung von Software ausdruecklich erlaubt; Weiterverbreitung des Dokuments selbst nicht
   'LicenseRef-OMG-Specification',
   'FIXED', 'DRAFT', 'Kuration', DATE '2026-08-01'),

  ('Q-OMG-2', 'OMG-00002', 'API', 'EXTERN',
   'https://www.omg.org/spec/BPMN/20100501/BPMN20.xsd',
   'Methode', 'Prozessnotation',
   -- Lizenzbedingungen im Wortlaut (haben im Schema kein eigenes Feld, O-K08-12):
   --   OMG Specification License -- Schemadateien ausdruecklich zur kommerziellen Implementierung freigegeben
   'LicenseRef-OMG-Specification',
   'FIXED', 'DRAFT', 'Kuration', DATE '2026-08-01'),

  ('Q-BMI-1', 'BMI-00001', 'WEB', 'EXTERN',
   'https://www.orghandbuch.de/Webs/OHB/DE/Organisationshandbuch/6_MethodenTechniken/61_Erhebungstechniken/erhebungstechniken-node.html',
   'Methode', 'Prozessaufnahme',
   -- Lizenzbedingungen im Wortlaut (haben im Schema kein eigenes Feld, O-K08-12):
   --   ACHTUNG NUR VERWEIS: BMI-Standardhinweis, Urheberrecht bei der Bundesrepublik.
   --   Verlinken und Zitieren zulaessig, TEXTUEBERNAHME NICHT ohne schriftliche Zustimmung.
   --   Sobald ein Agent daraus Fliesstext rendert, ist die Quelle unzulaessig (O-QD-2).
   'LicenseRef-BMI-Nur-Verweis',
   'DYNAMIC', 'DRAFT', 'Kuration', DATE '2026-08-01'),

  -- FUNKTIONSWISSEN
  ('Q-ESCO-1', 'ESC-00001', 'API', 'EXTERN',
   'https://esco.ec.europa.eu/',
   'Funktion', 'Personalwesen',
   -- Lizenzbedingungen im Wortlaut (haben im Schema kein eigenes Feld, O-K08-12):
   --   Creative Commons Attribution 4.0 -- kommerzielle Nutzung und Bearbeitung erlaubt, Namensnennung noetig
   'CC-BY-4.0',
   'DYNAMIC', 'DRAFT', 'Kuration', DATE '2026-08-01'),

  ('Q-GII-1', 'GII-00001', 'WEB', 'EXTERN',
   'https://www.gesetze-im-internet.de/hgb/',
   'Funktion', 'Rechnungswesen',
   -- Lizenzbedingungen im Wortlaut (haben im Schema kein eigenes Feld, O-K08-12):
   --   Paragraf 5 Absatz 1 Urheberrechtsgesetz -- amtliches Werk, gemeinfrei, keine Einschraenkung
   'LicenseRef-UrhG-5-1-Amtliches-Werk',
   'DYNAMIC', 'DRAFT', 'Kuration', DATE '2026-08-01'),

  -- BRANCHENWISSEN  (branchenneutral in Welle 1, Retail Banking folgt in Welle 2)
  ('Q-GII-2', 'GII-00002', 'WEB', 'EXTERN',
   'https://www.gesetze-im-internet.de/gwg_2017/',
   'Branche', 'Regulatorik',
   -- Lizenzbedingungen im Wortlaut (haben im Schema kein eigenes Feld, O-K08-12):
   --   Paragraf 5 Absatz 1 Urheberrechtsgesetz -- amtliches Werk, gemeinfrei
   'LicenseRef-UrhG-5-1-Amtliches-Werk',
   'DYNAMIC', 'DRAFT', 'Kuration', DATE '2026-08-01'),

  ('Q-18F-1', 'GH-00001', 'GITHUB', 'EXTERN',
   'https://github.com/18F/methods',
   'Methode', 'Nutzerzentrierte Gestaltung',
   -- Lizenzbedingungen im Wortlaut (haben im Schema kein eigenes Feld, O-K08-12):
   --   CC0 1.0 Universal -- gemeinfrei, keinerlei Auflage. Einzige Quelle im Bestand ohne jede Bedingung
   'CC0-1.0',
   'FIXED', 'DRAFT', 'Kuration', DATE '2026-08-01'),

  ('Q-ARC-1', 'ARC-00001', 'WEB', 'EXTERN',
   'https://arc42.org/',
   'Methode', 'Anforderungsdokumentation',
   -- Lizenzbedingungen im Wortlaut (haben im Schema kein eigenes Feld, O-K08-12):
   --   CC BY-SA 4.0 -- kommerzielle Nutzung erlaubt, Namensnennung und Weitergabe unter gleichen Bedingungen
   'CC-BY-SA-4.0',
   'FIXED', 'DRAFT', 'Kuration', DATE '2026-08-01');

-- ---------------------------------------------------------------------
-- 2 · Wissensbausteine  (M1) -- zwei je Gruppe
--    Das Praefix der Kennung bezeichnet die Gruppe. ACHTUNG: keine
--    Bedingung verbindet Praefix und grp -- ein Widerspruch wuerde heute
--    angenommen (offener Punkt O-BEF-3). Hier stimmen sie ueberein.
-- ---------------------------------------------------------------------

INSERT INTO knowledge_module (id, grp, domaene, title, lang, valid_until, owner_label)
VALUES
  ('ME-REFA-001', 'METHODENWISSEN', 'Prozessaufnahme',
   'Erhebungstechniken der Ablaufaufnahme', 'de', DATE '2027-08-01', 'Kuration'),
  ('ME-BPMN-001', 'METHODENWISSEN', 'Prozessnotation',
   'Grundelemente der Prozessnotation', 'de', DATE '2028-08-01', 'Kuration'),

  ('FN-PERS-001', 'FUNKTIONSWISSEN', 'Personalwesen',
   'Berufe, Faehigkeiten und Qualifikationen', 'de', DATE '2027-08-01', 'Kuration'),
  ('FN-RECH-001', 'FUNKTIONSWISSEN', 'Rechnungswesen',
   'Handelsrechtliche Buchfuehrungspflichten', 'de', DATE '2027-08-01', 'Kuration'),

  ('BR-REGU-001', 'BRANCHENWISSEN', 'Regulatorik',
   'Sorgfaltspflichten bei der Identifizierung', 'de', DATE '2027-08-01', 'Kuration'),
  ('BR-DOKU-001', 'BRANCHENWISSEN', 'Anforderungsdokumentation',
   'Gliederung einer Architekturbeschreibung', 'de', DATE '2028-08-01', 'Kuration');

-- Erste Fassung je Baustein. status bleibt DRAFT -- die Freigabe ist eine
-- menschliche Handlung nach K14, kein INSERT.
-- Die Ausschlussbedingung ueber (module_id, gueltig) laesst nie zwei
-- ueberlappende Fassungen zu: wer eine neue einstellt, beendet die alte.
INSERT INTO knowledge_module_version (module_id, version, status, gueltig, editor, aenderungsvermerk)
SELECT id, '1.0', 'DRAFT', daterange(DATE '2026-08-01', NULL, '[)'), 'Kuration',
       'Welle 1 -- neutrales Testminimum, Erstanlage'
FROM knowledge_module
WHERE id IN ('ME-REFA-001','ME-BPMN-001','FN-PERS-001','FN-RECH-001','BR-REGU-001','BR-DOKU-001');

-- Verweis Baustein -> Quelle. Hier liegt der eigentliche Inhalt.
INSERT INTO knowledge_module_source (module_id, source_id) VALUES
  ('ME-REFA-001', 'Q-BMI-1'),
  ('ME-REFA-001', 'Q-18F-1'),
  ('ME-BPMN-001', 'Q-OMG-1'),
  ('ME-BPMN-001', 'Q-OMG-2'),
  ('FN-PERS-001', 'Q-ESCO-1'),
  ('FN-RECH-001', 'Q-GII-1'),
  ('BR-REGU-001', 'Q-GII-2'),
  ('BR-DOKU-001', 'Q-ARC-1');

-- ---------------------------------------------------------------------
-- 3 · Formatvorlagen  (M2)
--    ACHTUNG: template hat drei Spalten -- id, grp, name -- und KEIN
--    Inhaltsfeld. Diese Zeilen sind Kennungen ohne Inhalt. Wo der Inhalt
--    liegt, ist offen (O-K25-2 / O-BEF-1). Bis das entschieden ist, ist
--    M2 angelegt, aber nicht bestueckt.
-- ---------------------------------------------------------------------

INSERT INTO template (id, grp, name) VALUES
  -- Dialogvorlagen: Einstieg, Vertiefung, Abschluss
  ('DLG-EIN', 'DIALOG',   'Gespraechseinstieg -- offenste Frage zuerst'),
  ('DLG-VER', 'DIALOG',   'Vertiefung -- Nachfragen und Ueberspringen'),
  ('DLG-ABS', 'DIALOG',   'Abschluss -- Zusammenfassen und Bestaetigen'),
  -- Statusvorlage: die Grundform aus K25
  ('STA-GRD', 'DESIGN',   'Statusspalte -- Grundform neben dem Gespraech'),
  -- Die sechs Anforderungskonzepte aus K06
  ('DOK-PRO', 'DOCUMENT', 'Anforderungskonzept Prozess'),
  ('DOK-UX',  'DOCUMENT', 'Anforderungskonzept Bedienung'),
  ('DOK-ARC', 'DOCUMENT', 'Anforderungskonzept Aufbau'),
  ('DOK-SEC', 'DOCUMENT', 'Anforderungskonzept Sicherheit'),
  ('DOK-BET', 'DOCUMENT', 'Anforderungskonzept Betrieb'),
  ('DOK-COM', 'DOCUMENT', 'Anforderungskonzept Regelwerk'),
  -- Traeger der beiden Richtlinien (K21: Pflegeort M4, Anzeige M2)
  ('POL-ETH', 'POLICY',   'Richtlinienvorlage Ethik'),
  ('POL-FAC', 'POLICY',   'Richtlinienvorlage Fachlichkeit');

-- ---------------------------------------------------------------------
-- 4 · Richtlinien  (M4)
--    K21-M04 verlangt ZWEI ausgelieferte Standard-Richtlinien in v1.0.
--    Ein leeres M4 ist deshalb keine Baustelle, sondern eine Abweichung
--    vom Soll -- der Grund, warum sie hier stehen.
-- ---------------------------------------------------------------------

INSERT INTO policy (id, name, scope, template_id) VALUES
  ('P-ETHIK-001', 'Ethische Grundregeln der Gespraechsfuehrung', 'plattformweit', 'POL-ETH'),
  ('P-FACH-001',  'Fachliche Sorgfalt und Herkunftsangabe',      'plattformweit', 'POL-FAC');

COMMIT;

-- =====================================================================
--  5 · VERDRAHTUNG  (M3) -- BEWUSST NICHT IN DIESEM SEED
--
--  agent_knowledge, agent_template und agent_policy verbinden Agenten mit
--  dem, was hier angelegt wurde. Sie stehen nicht hier, weil:
--
--  (a) K17-M31 den Wissensscope im Serverpfad erzwingt und unfreigegebenes
--      Wissen abweist. Alles oben ist DRAFT. Eine Verdrahtung auf DRAFT
--      wuerde beim ersten Aufruf abgewiesen -- der Seed erzeugte einen
--      Zustand, den die Plattform sofort verwirft.
--
--  (b) Die Verdrahtung ist im Portal aenderbar (K17-M16) und damit ein
--      fachlicher Vorgang mit Protokolleintrag, kein Bestandteil einer
--      Erstbefuellung.
--
--  REIHENFOLGE: Seed laden -> Vier-Augen je Baustein (K14) -> auf
--  RELEASED setzen -> im Portal verdrahten -> erst dann laeuft ein Agent
--  gegen echtes Wissen.
-- =====================================================================

-- =====================================================================
--  6 · GEGENPROBE nach dem Laden
--
--  SELECT grp, count(*) FROM knowledge_module GROUP BY grp;
--    -> je 2 fuer BRANCHENWISSEN, FUNKTIONSWISSEN, METHODENWISSEN
--
--  SELECT count(*) FROM knowledge_source WHERE license IS NULL;
--    -> 0. Ist er groesser, ist K08-M17 verletzt.
--
--  SELECT m.id FROM knowledge_module m
--    LEFT JOIN knowledge_module_source s ON s.module_id = m.id
--   WHERE s.module_id IS NULL;
--    -> leer. Ein Baustein ohne Quelle ist eine leere Huelle mit Titel.
--
--  SELECT count(*) FROM knowledge_module_version WHERE status <> 'DRAFT';
--    -> 0. Nichts ist freigegeben; die Freigabe ist eine menschliche
--       Handlung nach K14.
-- =====================================================================
