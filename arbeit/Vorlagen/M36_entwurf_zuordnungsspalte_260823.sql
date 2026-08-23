-- =====================================================================
--  M36 · ENTWURF · Die Zuordnung bekommt eine eigene Spalte
--  Vorgelegt 23.08.2026 · schliesst O-M3-5 · Befund BEF-K04-2
--
--  NICHT GEZEICHNET. Diese Datei liegt in arbeit/Vorlagen/ und NICHT in
--  migrations/. Eine Migration entsteht erst mit der Zeichnung; bis dahin
--  waere sie eine Schemaaenderung ohne Beschluss.
--
--  ---------------------------------------------------------------------
--  WORUM ES GEHT
--  ---------------------------------------------------------------------
--  K04-M22 verlangt "je Antwort eine Zuordnung zu Dokument oder Anwendung".
--  quick_option traegt sie nicht: beim Nachbau nach dem Muster fit_option
--  (M30 Abschn. 3f) ist die dritte Sachspalte -- dort `is_eligible` --
--  ersatzlos entfallen.
--
--  Der Bau behilft sich seit dem 23.08.2026 mit einer Endung am
--  value_token (__dok / __app) und misst sie im Seed nach. Das haelt, aber
--  es haelt nur, solange sich alle daran halten: das Schema erzwingt
--  nichts. Derselbe Fall wie der fehlende Riegel fuer die Rubrik-Fassung.
--
--  ---------------------------------------------------------------------
--  WAS SIE ENTSCHEIDEN
--  ---------------------------------------------------------------------
--  A  Eigene Spalte (dieser Entwurf). K04-M22 wird vom Schema getragen.
--     Kosten: eine Migration, eine Anpassung an Seed und Auswerter.
--  B  Beim Behelf bleiben. Kosten: K04-M22 bleibt im Schema offen; der
--     Pruef-Agent darf ihn als NICHT PRUEFBAR zurueckgeben, und ein
--     fehlendes Ergebnis ist nach K23-M22 nicht bestanden.
--
--  Der Bau empfiehlt nichts. Er nennt, was jede Wahl kostet.
-- =====================================================================

BEGIN;

-- 1 · Der Typ. Zwei Werte, mehr sieht K04-M22 nicht vor.
DO $$ BEGIN
  CREATE TYPE quick_zuordnung AS ENUM ('DOKUMENT','ANWENDUNG');
EXCEPTION WHEN duplicate_object THEN NULL;
END $$;

-- 2 · Die Spalte. Zunaechst nullbar, damit der Bestand nachgezogen werden
--     kann -- eine Pflichtspalte auf eine gefuellte Tabelle zu setzen,
--     scheitert an genau den Zeilen, die man gerade fuellen will.
ALTER TABLE quick_option ADD COLUMN IF NOT EXISTS zuordnung quick_zuordnung;

-- 3 · Der Bestand. Die Endung am value_token ist die heutige Wahrheit; sie
--     wird EINMAL uebersetzt und danach nie wieder gelesen.
UPDATE quick_option
   SET zuordnung = CASE
         WHEN value_token LIKE '%\_\_dok' THEN 'DOKUMENT'::quick_zuordnung
         WHEN value_token LIKE '%\_\_app' THEN 'ANWENDUNG'::quick_zuordnung
       END
 WHERE zuordnung IS NULL;

-- 4 · Erst jetzt die Pflicht. Bleibt eine Zeile ohne Zuordnung, scheitert
--     dieser Schritt -- und das ist die Absicht: eine Antwort ohne
--     Zuordnung darf es nach K04-M22 nicht geben.
ALTER TABLE quick_option ALTER COLUMN zuordnung SET NOT NULL;

COMMENT ON COLUMN quick_option.zuordnung IS
  'K04-M22: je Antwort eine Zuordnung zu Dokument oder Anwendung. '
  'Loest die Behelfsendung __dok/__app am value_token ab (O-M3-5).';

-- 5 · Gegenprobe. Nicht gemessen ist nicht bestanden (K23-M22).
DO $$
DECLARE
  offen integer;
  schief text;
BEGIN
  SELECT count(*) INTO offen FROM quick_option WHERE zuordnung IS NULL;
  IF offen > 0 THEN
    RAISE EXCEPTION 'K04-M22 verletzt: % Antworten ohne Zuordnung', offen;
  END IF;

  -- Die Uebersetzung muss die Endung treffen, sonst hat sie etwas anderes
  -- gemacht als sie sollte.
  SELECT string_agg(value_token || '=' || zuordnung, ', ') INTO schief
    FROM quick_option
   WHERE (value_token LIKE '%\_\_dok' AND zuordnung <> 'DOKUMENT')
      OR (value_token LIKE '%\_\_app' AND zuordnung <> 'ANWENDUNG');
  IF schief IS NOT NULL THEN
    RAISE EXCEPTION 'Uebersetzung stimmt nicht mit der Endung ueberein: %', schief;
  END IF;
END $$;

COMMIT;

-- =====================================================================
--  WAS DANACH NACHZUZIEHEN IST -- nicht Teil dieser Migration
--
--  1  seeds/Seed_Direkt_Prototyp_Check_K04.sql: `zuordnung` ausdruecklich
--     setzen; die Endung am value_token entfaellt.
--  2  app/schnellweg.py, fragen_lesen: `zuordnung` mitlesen.
--  3  app/schnellweg_regel.py: `token.endswith('__app')` weicht dem
--     gelesenen Spaltenwert. Die Kontrollzahl 22 von 243 muss danach
--     unveraendert herauskommen -- werkzeuge/schnellweg_gegenprobe.py
--     misst es.
--  4  VP-24 im Klausellauf steht dann nicht mehr auf GESPERRT.
-- =====================================================================
