-- =====================================================================
-- FREIRAUM · DAUERMESSUNG AM BESTAND · Kunden-Code am Mandanten
-- Lesegrundlage fuer mandantencode_lauf.sh
-- Angelegt am 16.08.2026 (Auftrag 10.6)
--
-- Geschrieben gegen K02 "Fundament" v1.3 und schema/freiraum_datamodel.sql
-- -- NICHT gegen den Umsetzungscode. Die beiden gezeichneten Klauseln
-- stehen hier im WORTLAUT, weil beide Messungen sie zitieren und nicht
-- umformulieren:
--
--   K02-G02  "Es GILT: Der Kunden-Code ist nur bei der Art Kunde
--             Pflicht. Betreiber und Partner bestehen ohne ihn."
--
--   K02-M25  "Der Kunden-Code MUSS fortlaufend von der Plattform
--             vergeben werden. Der erste lautet `DE-AAA`; jeder weitere
--             ist der naechste freie Code der alphabetischen Folge."
--
-- ---------------------------------------------------------------------
-- WAS EINE DAUERMESSUNG VON EINEM PRUEFFALL UNTERSCHEIDET
-- ---------------------------------------------------------------------
-- Ein Prueffall stellt sich seine Lage selbst her und misst dann eine
-- Handlung. Eine Dauermessung stellt NICHTS her: sie misst den BESTAND,
-- so wie er ist -- bei jedem Lauf neu, ohne Rueckhalt.
--
-- Diese Datei legt deshalb ABSICHTLICH KEINEN EINZIGEN MANDANTEN AN.
-- Wer die Codes selbst schreibt, die er hinterher misst, misst seine
-- eigene Hand. Gemessen wird, was aus Schema und Migration im Bestand
-- steht -- und alles, was sonst noch dort steht.
--
-- ---------------------------------------------------------------------
-- ZWEI ZUSICHERUNGEN AUS DEM AUFTRAG, HIER EINGELOEST
-- ---------------------------------------------------------------------
-- (1) OHNE NEUE DATENBANKBEDINGUNG. Diese Datei legt keinen CHECK,
--     keinen Trigger, keine Regel und keinen eindeutigen Index an. Sie
--     legt genau drei Lese-Dinge an: zwei unveraenderliche Funktionen
--     (Rechnung Buchstabe <-> Platz) und eine Lesesicht. Keines davon
--     kann eine Zeile verhindern; sie koennen nur zeigen, was da ist.
--     Das ist der Unterschied zwischen messen und verbieten.
--
-- (2) AUCH CODES AUF UNBEKANNTEM WEG. Die Sicht liest die Tabelle
--     `tenant` VOLLSTAENDIG. Sie fragt nicht, WOHER ein Code kommt: kein
--     Verbund mit einem Nachweis, kein Filter auf eine Herkunft, kein
--     Filter auf `deleted_at`. Ein Code, der ohne jeden Vorgang direkt
--     in die Zeile geschrieben wurde, steht darum genauso in der
--     Messung wie einer aus dem regulaeren Weg. Genau das ist der Sinn:
--     eine Messung, die nur den bekannten Weg abbildet, bestaetigt den
--     bekannten Weg und findet nichts.
--
-- Aufruf:
--   psql -h localhost -p 55433 -U postgres -d <datenbank> \
--        -v ON_ERROR_STOP=1 -f mandantencode_daten.sql
-- =====================================================================

\set ON_ERROR_STOP on

-- ---------------------------------------------------------------------
-- 1 · Die Rechnung: Buchstabenfolge <-> Platz in der Folge
--
--     `DE-AAA` ist Platz 0, `DE-AAB` Platz 1, `DE-ABA` Platz 26,
--     `DE-BAA` Platz 676. Drei Buchstaben ergeben 17576 Plaetze
--     (0 bis 17575).
--
--     Ohne diese Rechnung liesse sich "der naechste freie Code der
--     alphabetischen Folge" (K02-M25) nicht nachzaehlen -- man koennte
--     nur sagen, ob ein Code SCHOEN AUSSIEHT, nicht, ob er der naechste
--     war. Genau dieser Unterschied ist am 02.08.2026 verlorengegangen:
--     drei Negativfaelle scheiterten an einer FORMATPRUEFUNG des
--     Kundencodes statt an der Zielbedingung. Ein Format sagt nichts
--     ueber eine Folge.
--
--     IMMUTABLE und ohne Seiteneffekt: eine Rechenhilfe zum Lesen,
--     keine Bedingung an den Daten.
-- ---------------------------------------------------------------------
CREATE OR REPLACE FUNCTION pruef_codeplatz(code text)
RETURNS integer LANGUAGE sql IMMUTABLE AS $$
  SELECT CASE
           WHEN code IS NULL OR code !~ '^DE-[A-Z]{3}$' THEN NULL
           ELSE (ascii(substr(code, 4, 1)) - 65) * 676
              + (ascii(substr(code, 5, 1)) - 65) * 26
              + (ascii(substr(code, 6, 1)) - 65)
         END
$$;

CREATE OR REPLACE FUNCTION pruef_codename(platz integer)
RETURNS text LANGUAGE sql IMMUTABLE AS $$
  SELECT CASE
           WHEN platz IS NULL OR platz < 0 OR platz > 17575 THEN NULL
           ELSE 'DE-' || chr(65 + (platz / 676))
                      || chr(65 + ((platz / 26) % 26))
                      || chr(65 + (platz % 26))
         END
$$;

-- ---------------------------------------------------------------------
-- 2 · Die Lesesicht auf den Bestand
--
--     EINE Zeile je Mandant, der einen Kunden-Code TRAEGT -- gleich
--     welcher Art, gleich ob geloescht markiert, gleich auf welchem Weg
--     er entstanden ist. Kein WHERE ausser "traegt ueberhaupt einen
--     Code".
-- ---------------------------------------------------------------------
CREATE OR REPLACE VIEW pruef_mandantencode_lage AS
SELECT t.id,
       t.kind::text                     AS art,
       t.name,
       t.customer_code                  AS code,
       pruef_codeplatz(t.customer_code) AS platz,
       (t.customer_code ~ '^DE-[A-Z]{3}$') AS formatgerecht,
       (t.deleted_at IS NOT NULL)       AS geloescht_markiert
  FROM tenant t
 WHERE t.customer_code IS NOT NULL;

-- ---------------------------------------------------------------------
-- 3 · Die Gegenseite: Mandanten OHNE Code. Sie wird gebraucht, weil
--     K02-G02 zwei Aussagen macht, nicht eine -- Kunde MIT, Betreiber
--     und Partner OHNE. Eine Messung, die nur die eine Haelfte liest,
--     misst ein Vorkommen statt einer Unterscheidung.
-- ---------------------------------------------------------------------
CREATE OR REPLACE VIEW pruef_mandantenart_lage AS
SELECT t.kind::text                    AS art,
       count(*)                        AS mandanten,
       count(t.customer_code)          AS mit_code,
       count(*) - count(t.customer_code) AS ohne_code
  FROM tenant t
 GROUP BY t.kind::text;

-- ---------------------------------------------------------------------
-- 4 · AUFBAUPRUEFUNG (F07) -- und was sie ausdruecklich NICHT prueft.
--
--     Geprueft wird nur, ob das WERKZEUG traegt: laesst sich der
--     Bestand ueberhaupt lesen, und rechnet die Buchstabenrechnung
--     richtig? Der INHALT des Bestands wird hier NICHT geprueft --
--     er ist der Gegenstand der Messung, nicht ihre Vorbedingung.
--     Waere er Vorbedingung, brauchte die Messung einen sauberen
--     Bestand, um einen unsauberen zu finden.
-- ---------------------------------------------------------------------
DO $$
DECLARE fehler text := '';
BEGIN
  IF to_regclass('public.tenant') IS NULL THEN
    fehler := fehler || 'Tabelle tenant fehlt; ';
  END IF;

  -- Die Rechnung an ihren Eckpunkten. Rechnet sie falsch, meldet die
  -- Zaehldifferenz spaeter Luecken, die es nicht gibt -- oder keine,
  -- wo welche sind.
  IF pruef_codeplatz('DE-AAA') IS DISTINCT FROM 0     THEN fehler := fehler || 'pruef_codeplatz(DE-AAA) <> 0; '; END IF;
  IF pruef_codeplatz('DE-AAB') IS DISTINCT FROM 1     THEN fehler := fehler || 'pruef_codeplatz(DE-AAB) <> 1; '; END IF;
  IF pruef_codeplatz('DE-ABA') IS DISTINCT FROM 26    THEN fehler := fehler || 'pruef_codeplatz(DE-ABA) <> 26; '; END IF;
  IF pruef_codeplatz('DE-BAA') IS DISTINCT FROM 676   THEN fehler := fehler || 'pruef_codeplatz(DE-BAA) <> 676; '; END IF;
  IF pruef_codeplatz('DE-ZZZ') IS DISTINCT FROM 17575 THEN fehler := fehler || 'pruef_codeplatz(DE-ZZZ) <> 17575; '; END IF;
  IF pruef_codeplatz('XX-1')   IS NOT NULL            THEN fehler := fehler || 'pruef_codeplatz nimmt einen formatfremden Wert an; '; END IF;

  -- Und die Umkehrung: Hin und zurueck muss denselben Code ergeben.
  IF pruef_codename(0)     IS DISTINCT FROM 'DE-AAA' THEN fehler := fehler || 'pruef_codename(0) <> DE-AAA; '; END IF;
  IF pruef_codename(703)   IS DISTINCT FROM 'DE-BBB' THEN fehler := fehler || 'pruef_codename(703) <> DE-BBB; '; END IF;
  IF pruef_codename(17575) IS DISTINCT FROM 'DE-ZZZ' THEN fehler := fehler || 'pruef_codename(17575) <> DE-ZZZ; '; END IF;
  IF pruef_codename(17576) IS NOT NULL               THEN fehler := fehler || 'pruef_codename nimmt einen Platz jenseits der Folge an; '; END IF;

  IF to_regclass('public.pruef_mandantencode_lage') IS NULL THEN
    fehler := fehler || 'Lesesicht pruef_mandantencode_lage fehlt; ';
  END IF;

  IF fehler <> '' THEN
    RAISE EXCEPTION 'AUFBAU UNBRAUCHBAR (F07): %', fehler;
  END IF;
END $$;

-- ---------------------------------------------------------------------
-- 5 · Was jetzt im Bestand steht -- unkommentiert, zum Mitlesen.
-- ---------------------------------------------------------------------
SELECT art, mandanten, mit_code, ohne_code FROM pruef_mandantenart_lage ORDER BY art;
SELECT code, platz, art, geloescht_markiert, name FROM pruef_mandantencode_lage ORDER BY platz NULLS LAST, code;

\echo 'Lesegrundlage steht. Aufbaupruefung (F07) bestanden. Es wurde KEIN Mandant angelegt -- gemessen wird der Bestand.'
