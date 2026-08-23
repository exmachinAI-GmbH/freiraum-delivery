-- =====================================================================
--  FREIRAUM · Startbestand des Direkt-Prototyp-Checks (K04)
--  Angelegt 23.08.2026 · Scheibe 2 · Meilenstein M3
--
--  umsetzt: K04-M22 (genau fuenf Fragen, je genau drei
--           Antwortmoeglichkeiten, je Antwort eine Zuordnung zu
--           Dokument oder Anwendung)
--
--  ---------------------------------------------------------------------
--  DAS WICHTIGSTE ZUERST: DER WORTLAUT IST GEZEICHNET.
--  ---------------------------------------------------------------------
--
--  Bis zum 23.08.2026 stand an vier Stellen dieses Bestandes, der Wortlaut
--  der fuenf Fragen sei "nirgends gezeichnet" und werde nachgereicht,
--  "sobald H09/Punkt 13 ihn zeichnet" -- so in migrations/M30 Abschn. 3f,
--  in app/vorpruefung.py, in app/vorlagen/en03_vorpruefung.html und in
--  arbeit/Plaene/scheibe2_m3_plan.md (O-M3-2).
--
--  DAS TRIFFT SEIT DEM 01.08.2026 NICHT MEHR ZU. Das freigegebene Konzept
--
--      concepts-md/260801_FREIRAUM_K04_Eignungs-und-Schnell-Check_v1.7.md
--      Status: Freigegeben · Vier-Augen: M. Veil (Founder) · 01.08.2026
--
--  fuehrt in Abschnitt 5.0 "Die fuenf Fragen des Direkt-Prototyp-Checks"
--  die vollstaendige Tabelle: fuenf Fragen, je drei Antwortmoeglichkeiten,
--  je Antwort die Zuordnung zu Dokument oder Anwendung. Darueber steht:
--  "Angenommen am 01.08.2026 (Founder), schliesst O-K04-1." Abschnitt 8
--  desselben Dokuments fuehrt O-K04-1 als geschlossen.
--
--  Der Befund dazu: arbeit/Bauberichte/BEF-K04-1_Wortlaut_ist_gezeichnet.md
--
--  WORTLAUT: woertlich aus K04 Abschn. 5.0 uebernommen, Zeichen fuer
--  Zeichen. Nicht neu gefasst, nicht geglaettet, nicht erfunden.
--
--  ZU DEN UMLAUTEN: `prompt_de` und `label_de` tragen ECHTE Umlaute, weil
--  die Quelle sie traegt und weil ein Endnutzer diesen Text liest. Der
--  uebrige Bestand umschreibt Umlaute -- das ist eine Regel fuer Code und
--  Kommentar, nicht fuer angezeigten Text. Der Eignungs-Check zeigt heute
--  umschriebene Fragen ("Beruehrt die Anwendung Ihre Geschaeftsdaten?"),
--  weil sein Startbestand aus dem DDL kommt. Das ist ein eigener kleiner
--  Befund und wird hier nicht mitgeschleppt.
--
--  WIEDERHOLBAR: jedes INSERT traegt ON CONFLICT DO NOTHING. Ein zweiter
--  Lauf aendert weder Schema noch Bestand (Nachweispunkt N2).
--
--  BELEGUNGSKONFLIKT, benannt und nicht behoben: pruefungen/migration/
--  M30__pruefung.sql legt eine Pruefzeile quick_question('thema', 1) an.
--  `position` ist tabellenweit eindeutig -- in einer Datenbank MIT dieser
--  Pruefzeile kollidiert dieser Seed auf Position 1. Er gehoert in den
--  Zielbestand, nicht in die Pruefdatenbank. Positionen zu verschieben,
--  um der Pruefzeile auszuweichen, waere das falsche Ende.
--
--  NUR SYNTHETISCHE, FACHLICHE STAMMDATEN. Kein Personenbezug, kein
--  Mandant, kein Vorgang -- nur der Fragenkatalog selbst (K23-M12).
-- =====================================================================

BEGIN;

-- ---------------------------------------------------------------------
-- 1 · Die fuenf Fragen  (K04-M22)
--
--     Traeger: quick_question, angelegt in migrations/M30 Abschn. 3f
--     ("Fragen des Schnellwegs", Nr. 55). `code` folgt ^[a-z_]{3,24}$,
--     `position` liegt zwischen 1 und 9 und ist tabellenweit eindeutig.
--     Die Reihenfolge ist die aus K04 Abschn. 5.0 und steht in der
--     Datenbank -- nicht im Programmtext und nicht in der Vorlage.
-- ---------------------------------------------------------------------
INSERT INTO quick_question (code, position) VALUES
  ('ergebnis',        1),
  ('wiederholung',    2),
  ('beteiligte',      3),
  ('daten',           4),
  ('verbindlichkeit', 5)
ON CONFLICT DO NOTHING;

-- ---------------------------------------------------------------------
-- 2 · Die Fassung v1  (Gegentest Nr. 55, MT-37)
--
--     Der Traeger fuehrt die Fragen MIT Fassung: eine geaenderte Frage
--     aendert alte Antworten nicht, weil die Antwort auf die BEANTWORTETE
--     Fassung verweist. Gueltig ab dem Zeichnungstag von K04 v1.7, offen
--     nach oben. Wird der Wortlaut spaeter geaendert, wird diese Fassung
--     am Aenderungstag geschlossen und eine neue angelegt -- der
--     Ausschluss `EXCLUDE USING gist` laesst keine zwei gleichzeitig
--     gueltigen Fassungen derselben Frage zu.
-- ---------------------------------------------------------------------
INSERT INTO quick_question_version (question_code, version, prompt_de, gueltig) VALUES
  ('ergebnis',        'v1',
   'Was hätten Sie am liebsten in der Hand?',
   daterange(DATE '2026-08-01', NULL)),
  ('wiederholung',    'v1',
   'Brauchen Sie das einmal oder immer wieder?',
   daterange(DATE '2026-08-01', NULL)),
  ('beteiligte',      'v1',
   'Arbeiten andere Menschen damit — oder nur Sie?',
   daterange(DATE '2026-08-01', NULL)),
  ('daten',           'v1',
   'Woher kommen die Angaben, mit denen gearbeitet wird?',
   daterange(DATE '2026-08-01', NULL)),
  ('verbindlichkeit', 'v1',
   'Muss auf das Ergebnis Verlass sein — geprüft, nachvollziehbar, verantwortet?',
   daterange(DATE '2026-08-01', NULL))
ON CONFLICT DO NOTHING;

-- ---------------------------------------------------------------------
-- 3 · Die fuenfzehn Antwortmoeglichkeiten  (K04-M22)
--
--     DIE ZUORDNUNG HAT KEINE EIGENE SPALTE, UND DAS IST EIN BEFUND.
--     `fit_option` -- das Vorbild, nach dem M30 Abschn. 3f gebaut wurde --
--     traegt drei Sachspalten: label_de, value_token, is_eligible. Beim
--     Nachbau ist die dritte entfallen und NICHT ersetzt worden.
--     quick_option fuehrt nur label_de und value_token.
--
--     K04-M22 verlangt aber "je Antwort eine Zuordnung zu Dokument oder
--     Anwendung". Bis eine eigene Spalte beschlossen ist, traegt
--     `value_token` sie als Endung:
--
--         __dok   spricht fuer den Direkt-Prototyp
--         __app   spricht fuer die Anwendung
--
--     Das ist eine Behelfsloesung mit doppelt belegter Spalte, kein
--     Zielzustand. Die Gegenprobe in Abschnitt 4 misst sie nach, damit
--     eine Antwort ohne Zuordnung nicht durchrutscht. Der Vorschlag fuer
--     den Zielzustand steht in
--     arbeit/Bauberichte/BEF-K04-2_Traeger_ohne_Zuordnung.md
--     und ist eine MIGRATION, nicht dieser Seed.
-- ---------------------------------------------------------------------
INSERT INTO quick_option (question_code, version, position, label_de, value_token) VALUES
  -- Frage 1 · Ergebnis -- VETORECHT nach K04-M23
  ('ergebnis',        'v1', 1,
   'eine Datei, die ich öffne, lese und weitergebe',    'datei_weitergeben__dok'),
  ('ergebnis',        'v1', 2,
   'etwas, das ich aufrufe und in dem ich arbeite',     'darin_arbeiten__app'),
  ('ergebnis',        'v1', 3,
   'weiß ich noch nicht',                               'noch_offen__app'),

  -- Frage 2 · Wiederholung -- gezaehlt nach K04-M24
  ('wiederholung',    'v1', 1,
   'einmal, für eine bestimmte Frage',                  'einmalig__dok'),
  ('wiederholung',    'v1', 2,
   'immer wieder, im laufenden Betrieb',                'laufender_betrieb__app'),
  ('wiederholung',    'v1', 3,
   'erst einmal, später vielleicht öfter',              'spaeter_vielleicht__app'),

  -- Frage 3 · Beteiligte -- gezaehlt nach K04-M24
  ('beteiligte',      'v1', 1,
   'nur ich',                                           'nur_ich__dok'),
  ('beteiligte',      'v1', 2,
   'mehrere Personen, jede mit eigener Sicht',          'mehrere_sichten__app'),
  ('beteiligte',      'v1', 3,
   'ich erstelle es, andere lesen es',                  'ich_schreibe__dok'),

  -- Frage 4 · Daten -- gezaehlt nach K04-M24
  ('daten',           'v1', 1,
   'ich bringe sie mit oder gebe sie einmal ein',       'mitgebracht__dok'),
  ('daten',           'v1', 2,
   'sie stehen in Systemen, die laufend weiterlaufen',  'laufende_systeme__app'),
  ('daten',           'v1', 3,
   'sie entstehen erst beim Benutzen',                  'entstehen_beim_tun__app'),

  -- Frage 5 · Verbindlichkeit -- VETORECHT nach K04-M23
  ('verbindlichkeit', 'v1', 1,
   'nein, es ist eine Arbeitsgrundlage für mich',       'arbeitsgrundlage__dok'),
  ('verbindlichkeit', 'v1', 2,
   'ja, andere verlassen sich darauf',                  'andere_verlassen_sich__app'),
  ('verbindlichkeit', 'v1', 3,
   'es geht um Geld, Fristen oder Personen',            'geld_fristen_personen__app')
ON CONFLICT DO NOTHING;

-- ---------------------------------------------------------------------
-- 4 · Gegenprobe -- der Seed misst sich selbst
--
--     Keine Bedingung der Datenbank erzwingt, dass es FUENF Fragen zu je
--     DREI Antworten gibt: sie erzwingt nur Eindeutigkeit. Genau das
--     stellt dieser Abschnitt her. Scheitert eine Probe, bricht der Lauf
--     mit einer benannten Ausnahme ab -- nicht gemessen ist nicht
--     bestanden (K23-M22).
-- ---------------------------------------------------------------------
DO $$
DECLARE
  fragen  CONSTANT text[] := ARRAY['ergebnis','wiederholung','beteiligte','daten','verbindlichkeit'];
  gezaehlt integer;
  abweichler text;
BEGIN
  SELECT count(*) INTO gezaehlt FROM quick_question WHERE code = ANY(fragen);
  IF gezaehlt <> 5 THEN
    RAISE EXCEPTION 'K04-M22 verletzt: % der fuenf Fragen liegen vor, nicht 5', gezaehlt;
  END IF;

  SELECT count(*) INTO gezaehlt
    FROM quick_question_version WHERE version = 'v1' AND question_code = ANY(fragen);
  IF gezaehlt <> 5 THEN
    RAISE EXCEPTION 'Fassung v1 unvollstaendig: % von 5 Fragen tragen sie', gezaehlt;
  END IF;

  SELECT string_agg(question_code || '=' || anzahl, ', ') INTO abweichler
    FROM (SELECT question_code, count(*) AS anzahl
            FROM quick_option
           WHERE version = 'v1' AND question_code = ANY(fragen)
           GROUP BY question_code
          HAVING count(*) <> 3) AS t;
  IF abweichler IS NOT NULL THEN
    RAISE EXCEPTION 'K04-M22 verletzt: nicht genau drei Antworten je Frage (%)', abweichler;
  END IF;

  SELECT string_agg(value_token, ', ') INTO abweichler
    FROM quick_option
   WHERE version = 'v1' AND question_code = ANY(fragen)
     AND value_token !~ '(__dok|__app)$';
  IF abweichler IS NOT NULL THEN
    RAISE EXCEPTION 'K04-M22 verletzt: Antwort ohne Zuordnung (%)', abweichler;
  END IF;
END $$;

COMMIT;

-- =====================================================================
--  OFFENER PUNKT, der an diesem Startbestand haengt
--
--  O-M3-5 (neu): quick_option traegt keine Spalte fuer die Zuordnung.
--  Solange sie fehlt, ist K04-M22 im Schema NICHT durchgesetzt -- er ist
--  nur in diesem Seed und in seiner Gegenprobe nachgehalten. Derselbe
--  Fall wie der fehlende Schema-Riegel fuer die Rubrik-Fassung: eine
--  Pflicht, die so lange gilt, wie sich alle daran halten.
--  Entscheiden muessten Founder und Datenmodell -- wie bei O-K04-8 und
--  O-K04-10.
-- =====================================================================
