-- =====================================================================
-- FREIRAUM · M31 · Projektnummer und Zweckbestimmung
--
-- umsetzt: K01-M27 (die fuenfte Pruefung, currency = EUR), K01-M38
--          (die Projektnummer bildet der Befehl), K01-D19 (kein Weg
--          bietet sie zur Eingabe an), K04-M17 (eine Transaktion,
--          beidseitige Verknuepfung geprueft), K04-M19 (zwei getrennte
--          Fragen, kein fit_question), K04-M21 (die Kenntnisnahme ist
--          Vorbedingung der Anlage), K04-D10 (ein Treffer in Frage 2
--          wird nicht weitergefuehrt), K04-G12 (die Kenntnisnahme wird
--          zusaetzlich als Ereignis gefuehrt -- geschrieben wird das
--          Ereignis in app/zweckbestimmung.py, hier steht der Traeger)
--
-- zur Haelfte umgesetzt: K04-M18 -- weil diese Datei die Eignung
--          unmittelbar vor der Anlage in DERSELBEN Transaktion erneut
--          liest; die drei aktiven Antworten liest sie NICHT erneut. Sie
--          braucht es nicht: `outcome` ist der einzige Ort, an dem die
--          Eignung steht (K04-D05), und er wird hier frisch gelesen. Die
--          Klausel nennt aber ausdruecklich auch die drei Antworten --
--          die Luecke ist benannt, nicht geschlossen.
--
-- Neue Migration, kein Eingriff in M30. M30 bleibt Wort fuer Wort, wie
-- sie gezeichnet ist; was sich aendert, aendert sich hier.
--
-- REGELN DIESER DATEI -- dieselben wie in M30
--   * Idempotent. Ein zweiter Lauf aendert weder Schema noch Daten.
--     Jede Anweisung ist einzeln geschuetzt; keine Anweisung dieser Datei
--     schreibt eine Fachzeile. Der Zaehlerstand in `nummernvorrat` wird
--     hier NICHT angefasst -- ihn erhoeht allein der Serverbefehl zur
--     Laufzeit.
--   * Eine Transaktion. Es gibt keinen Teilstand.
--   * Keine Enum-Erweiterung, deshalb steht auch nichts vor dem BEGIN.
--
-- WAS DIESE DATEI NICHT TUT, UND WARUM
--
--   * Sie schreibt KEINE zweite Verlaufszeile. Der Bildschirmvertrag
--     verlangt fuer `anwendung_anlegen` eine Verlaufszeile DISCOVERY.
--     Die entsteht bereits zwangslaeufig: M30 (Z. 709-727) haengt den
--     Ausloeser `app_state_history_sync_trg` an AFTER INSERT auf `app`.
--     Nachgesehen und nicht angenommen. Der neue Befehl schreibt sie
--     deshalb nicht noch einmal -- er prueft nach, dass sie da ist, und
--     bricht ab, wenn sie fehlt. Zwei Schreiber waeren zwei Wahrheiten;
--     ein Schreiber ohne Nachpruefung waere eine Behauptung.
--   * Sie setzt `app.retention_class` NICHT auf 'PROJEKT_VORVERTRAG'.
--     M30 haelt zu Beschluss Nr. 58 fest, dass Projekte vor Stufe 05
--     diese Klasse tragen; die Spaltenvorgabe ist 'HANDELSRECHT', und
--     der alte Befehl setzte nichts. Das ist ein Befund, keine
--     Entscheidung dieser Scheibe: die Klasse gehoert K15, keine der
--     Klauseln dieses Meilensteins nennt sie, und eine still geaenderte
--     Aufbewahrungsklasse ist eine still geaenderte Loeschfrist. Der
--     Befund steht im Bericht zu M4.
--   * Sie aendert `app/vorpruefung.py` nicht und setzt deshalb auch
--     KEINE Bedingung, die den Weg "Antwort aendern" auf EN-04 in eine
--     Bedingung laufen liesse, die diese Datei nicht kennt. Begruendung
--     unten bei 1c.
-- =====================================================================

BEGIN;

-- =====================================================================
-- 1 · Der Traeger der Zweckbestimmungs-Erklaerung (K04-M19, O-M4-2)
-- =====================================================================
--
-- DIE WAHL, UND WARUM SIE SO KLEIN AUSFAELLT.
--
-- Gebraucht werden genau zwei Ja/Nein-Antworten je Eignungs-Check. Nicht
-- zwei Antworten aus einem Katalog, sondern zwei Antworten auf zwei
-- Fragen, deren Gegenstand die Klausel selbst festlegt (K04-M19). Drei
-- Traeger waeren denkbar:
--
--   (a) zwei nullbare Spalten an `fit_check`          <- gewaehlt
--   (b) eine eigene Tabelle purpose_declaration mit
--       einer Zeile je Check
--   (c) eine Fragen- und eine Antworttabelle, wie
--       fit_question / fit_answer
--
-- (c) faellt an der Klausel selbst: "Er ist kein `fit_question`"
-- (K04-M19). Ein zweiter Fragenkatalog waere genau das noch einmal --
-- mit `position`, `is_eligible` und der Versuchung, die Zweckbestimmung
-- als vierte Eignungsdimension zu lesen. Die Klausel sagt ausdruecklich,
-- dass die drei Dimensionen unberuehrt bleiben.
--
-- (b) faellt an der Groesse: eine Tabelle mit genau einer Zeile je Check
-- und einem Fremdschluessel darauf ist eine Spalte mit Umweg. Sie braucht
-- eine eigene Eindeutigkeit, eine eigene Loeschregel und eine eigene
-- Mandantenfuehrung -- und traegt keinen einzigen Sachverhalt mehr.
--
-- (a) traegt: 1:1 zum Check, dieselbe Loeschregel (`fit_check` faellt,
-- die Erklaerung faellt mit), derselbe Mandant, dieselbe
-- Aufbewahrungsklasse. Und es ist DERSELBE Weg, den die Founder am
-- 4.8.2026 mit Entscheidung F1 fuer die Kenntnisnahme gegangen sind
-- (M30, Abschnitt 3g): Feld an `fit_check`, nicht eigene Tabelle. Zwei
-- benachbarte Sachverhalte an zwei verschiedenen Traegern waeren eine
-- Erklaerung, die niemand geben kann.
--
-- WAS DIE SPALTEN NICHT LEISTEN, und wie die Luecke geschlossen wird:
-- Eine Spalte kennt nur ihren letzten Wert. Wer wann was geantwortet und
-- was er zurueckgenommen hat, steht deshalb NICHT hier, sondern in
-- `event` -- unveraenderlich (K02, Regeln event_no_update/-delete). Der
-- Serverpfad schreibt Antwort, Ruecknahme und Kenntnisnahme je in
-- derselben Transaktion wie die Spalte. Faellt das Ereignis aus, faellt
-- die Spalte mit. Das ist die Nachvollziehbarkeit, die (b) und (c)
-- versprochen haetten, und sie steht dort, wo sie hingehoert.

ALTER TABLE fit_check
  ADD COLUMN IF NOT EXISTS zweck_bewertung_menschen boolean;
ALTER TABLE fit_check
  ADD COLUMN IF NOT EXISTS zweck_verbotene_praktik boolean;
ALTER TABLE fit_check
  ADD COLUMN IF NOT EXISTS zweckbestimmung_erklaert_am timestamptz;

COMMENT ON COLUMN fit_check.zweck_bewertung_menschen IS
  'K04-M19, erste Frage: bewertet, waehlt aus oder ueberwacht die Anwendung '
  'Menschen (Anhang III)? NULL = noch nicht beantwortet. Ein Treffer ist KEIN '
  'Halt (K04-D09), er loest die Kenntnisnahme aus (K04-M20).';
COMMENT ON COLUMN fit_check.zweck_verbotene_praktik IS
  'K04-M19, zweite Frage: verbotene Praktik nach Art. 5 der KI-Verordnung? '
  'NULL = noch nicht beantwortet. Ein Treffer haelt den Weg an und wird nicht '
  'weitergefuehrt (K04-D10); dort heilt keine Aufklaerung und keine '
  'Bestaetigung.';
COMMENT ON COLUMN fit_check.zweckbestimmung_erklaert_am IS
  'Zeitpunkt, zu dem BEIDE Fragen beantwortet vorlagen. Wird beim '
  'Zuruecknehmen einer Antwort wieder geleert -- eine Erklaerung mit einer '
  'offenen Frage ist keine.';

-- 1a · Vollstaendig heisst: beide Fragen. -----------------------------
-- Der Zeitstempel ist die Aussage "die Erklaerung liegt vor". Sie darf
-- nicht dastehen, solange eine der beiden Fragen offen ist -- sonst
-- traegt der Nachweis ein Datum fuer etwas Halbes. Dieselbe Bauart wie
-- `fit_done_needs_ts` beim Eignungs-Check (K04-M12).
DO $$ BEGIN
  IF NOT EXISTS (SELECT 1 FROM pg_constraint
                  WHERE conname = 'zweck_erklaerung_vollstaendig') THEN
    ALTER TABLE fit_check ADD CONSTRAINT zweck_erklaerung_vollstaendig
      CHECK (zweckbestimmung_erklaert_am IS NULL
             OR (zweck_bewertung_menschen IS NOT NULL
                 AND zweck_verbotene_praktik IS NOT NULL));
  END IF;
END $$;

-- 1b · KEINE Bedingung "Kenntnisnahme nur bei vollstaendiger -----------
--      Erklaerung" -- und die einmal gesetzte wird wieder entfernt.
--
-- Eine frueherer Stand dieser Datei setzte hier
--   ack_braucht_erklaerung CHECK (zweckbestimmung_ack_at IS NULL
--                                 OR zweckbestimmung_erklaert_am IS NOT NULL)
-- Sie wird zurueckgenommen. Gemessen am 16.08.2026: sie macht den
-- bestehenden Migrationsprueffall MT-29 unmoeglich, der Lauf bricht dort
-- ab, und MT-30 bis MT-99 werden in keinem echten Lauf mehr gemessen.
-- Zusaetzlich schlaegt sie VOR `ack_klasse_ki_nachweis` und
-- `ack_nach_eignung` zu: MT-27 und MT-28 scheitern dann an der FALSCHEN
-- Bedingung und messen nicht mehr, wofuer sie geschrieben wurden --
-- derselbe Fehlertyp wie am 02.08.2026.
--
-- Die Pruefung folgt nicht dem Bau. Eine Bedingung, die eine
-- Rang-1-Pruefung unmoeglich macht, ist eine Aenderung an M30-Verhalten
-- und gehoert als Rueckfrage an die Founder, nicht in M31.
--
-- WAS SIE SICHERN SOLLTE, wird an zwei Stellen weiterhin getragen:
--   * `zweck_erklaerung_vollstaendig` (1a) haelt fest, dass ein
--     Erklaerungszeitpunkt nur bei zwei beantworteten Fragen dastehen
--     darf. Das ist der Nachweis selbst.
--   * Der Serverbefehl unten liest vor der Anlage BEIDE Antworten und
--     die Kenntnisnahme frisch und weist ab, wenn eines fehlt. Der Weg
--     zu einer Anwendung ist damit geschlossen, ohne dass eine
--     Tabellenbedingung einen Rang-1-Prueffall aussperrt.
--   * Dass die Kenntnisnahme nur NACH einem Treffer in Frage 1
--     ENTSTEHT, setzt app/zweckbestimmung.py durch.
--
-- WIEDERHOLBARKEIT: die Bedingung ist bereits einmal eingespielt worden.
-- Ein blosses Weglassen wirkte nur auf frischen Datenbanken. Deshalb
-- wird sie hier ausdruecklich entfernt, wenn sie vorgefunden wird --
-- bedingt, damit ein zweiter Lauf nichts mehr aendert.
DO $$ BEGIN
  IF EXISTS (SELECT 1 FROM pg_constraint
              WHERE conname = 'ack_braucht_erklaerung'
                AND conrelid = 'public.fit_check'::regclass) THEN
    ALTER TABLE fit_check DROP CONSTRAINT ack_braucht_erklaerung;
  END IF;
END $$;

-- 1c · KEINE Bedingung "Erklaerung nur bei GEEIGNET". -----------------
-- Sie waere die naheliegende Schwester von `ack_nach_eignung` aus M30,
-- und sie wird hier NICHT gesetzt. Zwei Gruende, beide gemessen:
--
--   1. app/vorpruefung.py faengt beim Zuruecksetzen auf OFFEN genau EINE
--      Bedingung ab und prueft dabei ihren NAMEN (`ack_nach_eignung`).
--      Jede andere verletzte Bedingung reicht die Datei bewusst weiter --
--      "eine Ausnahmebehandlung, die JEDE verletzte Bedingung in dieselbe
--      Meldung uebersetzt, verschweigt den naechsten Fehler". Eine neue
--      Bedingung an derselben Stelle wuerde dort also zum Absturz. M4
--      darf EN-04 nicht umschreiben (Plan, Abschnitt 1); also wird auch
--      keine Bedingung gesetzt, die EN-04 nicht kennt.
--   2. Sie waere ueberfluessig fuer das, was sie schuetzen soll. Eine
--      Erklaerung ohne Eignung entsteht nicht: der Serverpfad liest
--      `outcome` vor jedem Schreiben, und die Anlage prueft es unten
--      noch einmal in ihrer eigenen Transaktion (K04-M18). Was eine
--      Anwendungszeile verhindert, ist der Riegel -- nicht der
--      Zeitpunkt, zu dem jemand eine Frage beantwortet hat.
--
-- Die Abweichung ist damit benannt und begruendet, nicht ausgelassen.

-- =====================================================================
-- 2 · Der Serverbefehl in neuer Fassung (K01-M27, K01-M38, K04-M17)
-- =====================================================================
--
-- NEUE SIGNATUR, OHNE p_project_no. Das ist der ganze Punkt von K01-M38:
-- "Sie wird vergeben, nicht eingegeben." Ein Parameter, den der Aufrufer
-- setzen kann, ist eine Eingabe -- gleich, wie diszipliniert der Aufrufer
-- ist. Die alte Fassung mit fuenf Parametern wird deshalb entfernt; der
-- Text von M30 bleibt dabei unangetastet, es wird nur ihr Ergebnis in
-- der Datenbank zurueckgenommen. Siehe Abschnitt 3.
--
-- Die Funktion ist bewusst dieselbe wie in M30 UND anders: derselbe Name,
-- weil K01-M27 ihn nennt; andere Stelligkeit, weil die Nummer nicht mehr
-- hineingereicht wird.

CREATE OR REPLACE FUNCTION create_app_after_fit(
  p_tenant    uuid,
  p_name      text,
  p_fit_check uuid,
  p_actor     uuid)
RETURNS uuid
LANGUAGE plpgsql
SECURITY DEFINER
SET search_path = public, pg_temp
AS $$
DECLARE
  neu        uuid;
  t          record;
  a          record;
  f          record;
  nr         bigint;
  v_no       text;
  v_currency text;
  v_verlauf  integer;
  v_rueck    uuid;
  v_hin      uuid;
BEGIN
  -- -----------------------------------------------------------------
  -- 2a · Die fuenf Pruefungen aus K01-M27, in EINER Transaktion
  -- -----------------------------------------------------------------
  -- Wortgleich uebernommen aus M30 und um die fuenfte ergaenzt. Der
  -- Wortlaut der Meldungen bleibt, damit ein Negativfall, der gegen die
  -- alte Fassung geschrieben wurde, an derselben Bedingung scheitert und
  -- nicht an einer neuen.

  SELECT * INTO t FROM tenant WHERE id = p_tenant;
  IF t IS NULL THEN
    RAISE EXCEPTION 'ANLAGE: Mandant % existiert nicht (K01-M27)', p_tenant
      USING ERRCODE = 'foreign_key_violation';
  END IF;
  IF t.legal_space <> 'DE' THEN
    RAISE EXCEPTION 'ANLAGE: Rechtsraum ist %, zulaessig ist DE (K01-M27)', t.legal_space
      USING ERRCODE = 'check_violation';
  END IF;

  SELECT * INTO a FROM actor WHERE id = p_actor;
  IF a IS NULL OR a.status <> 'AKTIV' THEN
    RAISE EXCEPTION 'ANLAGE: das Konto ist nicht aktiv (K01-M27)'
      USING ERRCODE = 'check_violation';
  END IF;
  IF a.tenant_id <> p_tenant THEN
    RAISE EXCEPTION 'ANLAGE: das Konto gehoert Mandant %, angelegt wird fuer % (K01-M27)',
      a.tenant_id, p_tenant USING ERRCODE = 'check_violation';
  END IF;

  -- K04-M18: die Eignung wird HIER erneut gelesen, in derselben
  -- Transaktion, in der die Zeile entsteht. Was der Bildschirm vor fuenf
  -- Minuten gezeigt hat, berechtigt nicht.
  SELECT * INTO f FROM fit_check WHERE id = p_fit_check;
  IF f IS NULL OR f.outcome <> 'GEEIGNET' THEN
    RAISE EXCEPTION 'ANLAGE: der Eignungs-Check steht nicht auf GEEIGNET (K01-M27)'
      USING ERRCODE = 'check_violation';
  END IF;
  IF f.tenant_id <> p_tenant THEN
    RAISE EXCEPTION 'ANLAGE: der Eignungs-Check gehoert einem anderen Mandanten (K01-M27, K14-D07)'
      USING ERRCODE = 'check_violation';
  END IF;

  -- -----------------------------------------------------------------
  -- 2b · Die Zweckbestimmung als Vorbedingung (K04-D10, K04-M21)
  -- -----------------------------------------------------------------
  -- BERICHTIGT AM 16.08.2026, auf Weisung E-8 (gez. M. Veil). Hier stand
  -- ein dritter Riegel, der beide Fragen als BEANTWORTET verlangte:
  --
  --   IF f.zweck_bewertung_menschen IS NULL
  --      OR f.zweck_verbotene_praktik IS NULL THEN
  --     RAISE EXCEPTION 'ZWECKBESTIMMUNG: beide Fragen muessen
  --                      beantwortet sein (K04-M19)';
  --
  -- ER WIRD ZURUECKGENOMMEN -- aus demselben Grund und nach derselben
  -- Regel wie der Riegel in Abschnitt 1b, 150 Zeilen weiter oben:
  --
  --   "Die Pruefung folgt nicht dem Bau. Eine Bedingung, die eine
  --    Rang-1-Pruefung unmoeglich macht, ist eine Aenderung an
  --    M30-Verhalten und gehoert als Rueckfrage an die Founder,
  --    nicht in M31."
  --
  -- Gemessen am 16.08.2026: er macht MT-95 und MT-95b unmoeglich. Beide
  -- richten einen fit_check mit outcome = GEEIGNET her und lassen die
  -- zwei Zweck-Spalten NULL -- sie stammen aus der Zeit vor diesen
  -- Spalten. MT-95 misst die Nummernvergabe, MT-95b den Rechteweg unter
  -- fr_portal; beide messen danach GAR NICHTS mehr.
  --
  -- WARUM DIE BEGRUENDUNG NICHT TRUG. Der fruehere Kommentar sagte:
  -- "K01-M27 sagt, was der Befehl prueft; K04-M21 sagt, dass die
  -- Kenntnisnahme Bedingung ist." Beide Zitate halten nicht:
  --   K04-M21 woertlich: "Die Kenntnisnahme MUSS als Nachweis erhalten
  --     bleiben und in das Uebergabe-Paket (K10 Abschn. 3) eingehen."
  --     -- kein Wort ueber eine Anlagebedingung.
  --   K04-M19 woertlich: "Nach outcome = GEEIGNET MUSS ein
  --     Zweckbestimmungs-SCHRITT folgen." -- ein Schritt im Ablauf,
  --     keine Bedingung im Serverbefehl.
  --   K01-M27 zaehlt FUENF Pruefungen auf; die Maschinenquelle
  --     schema/K19_screens.yaml:247/251 liest sie abschliessend
  --     ("eine der fuenf Pruefungen scheitert") und kennt als sechste
  --     Bedingung allein die Kenntnisnahme bei Treffer in Frage 1.
  --
  -- Und der zurueckgenommene Zweig war der einzige, den KEIN Negativfall
  -- misst: M31_N1 setzt beide Antworten auf false, N2 und N3 setzen sie.
  -- Ein unbelegter UND unbeobachteter Riegel hat zwei gruene
  -- Rang-1-Faelle rot gefaerbt.
  --
  -- WAS ER SICHERN SOLLTE, wird an drei Stellen weiterhin getragen:
  --   * Treffer in Frage 2   -> der Riegel unten (K04-D10), gemessen
  --                             durch M31_N3
  --   * Treffer in Frage 1 ohne Kenntnisnahme
  --                          -> der Riegel unten (K04-M21), gemessen
  --                             durch M31_N2
  --   * der Weg ueber den Bildschirm
  --                          -> app/zweckbestimmung.py ruft die Anlage
  --                             nur bei zwei Antworten auf
  --
  -- OFFEN UND ALS RUECKFRAGE AN DIE FOUNDER GESTELLT, nicht verschwiegen:
  -- Bei NULL ist ein Treffer in Frage 2 nicht AUSGESCHLOSSEN, und
  -- K19-M14 sagt zu Recht "Ein UI-Zustand ersetzt keine serverseitige
  -- Autorisierung". Wer die Kette nur ueber den Bildschirm schliesst,
  -- verlaesst sich auf einen Weg, den man umgehen kann. Soll der Riegel
  -- wiederkommen, gehoert ZUERST die Klauseldeckung in K04 oder K01
  -- nachgezogen -- und erst danach die Herrichtung von MT-95/95b, mit
  -- Klauselverweis statt Bauverweis.
  -- Vollstaendig in arbeit/Vorlagen/entscheidung_tor1_260816.md, E-8.

  -- Vorrang der zweiten Frage (K04-D10). Sie wird ZUERST geprueft, damit
  -- ein Vorhaben, das beide Fragen trifft, an dieser scheitert und nicht
  -- an der fehlenden Kenntnisnahme -- sonst waere es richtig abgewiesen
  -- und falsch begruendet, und die Nutzerin holte eine Bestaetigung nach,
  -- die nichts heilt.
  IF f.zweck_verbotene_praktik THEN
    RAISE EXCEPTION 'ZWECKBESTIMMUNG: verbotene Praktik nach Art. 5 der KI-Verordnung bejaht; der Weg wird nicht weitergefuehrt (K04-D10)'
      USING ERRCODE = 'check_violation';
  END IF;

  IF f.zweck_bewertung_menschen AND f.zweckbestimmung_ack_at IS NULL THEN
    RAISE EXCEPTION 'ZWECKBESTIMMUNG: die Kenntnisnahme zu Anhang III fehlt; ohne sie ist die Auskunftspflicht nach Art. 25 Abs. 4 nicht belegbar (K04-M21)'
      USING ERRCODE = 'check_violation';
  END IF;

  -- -----------------------------------------------------------------
  -- 2c · Die Projektnummer -- vergeben, nicht eingegeben (K01-M38)
  -- -----------------------------------------------------------------
  -- FORMAT. `app.project_no` erzwingt '^DE-[A-Z]{3}_[0-9]{3}_[0-9]{2}$'.
  -- Die ersten sechs Zeichen sind das Muster von `tenant.customer_code`
  -- ('^DE-[A-Z]{3}$') -- die Nummer traegt also den Kundencode. Fehlt er,
  -- laesst sich keine formatgueltige Nummer bilden; dann entsteht keine
  -- Anwendung. Fail-closed, und mit benanntem Grund.
  --
  -- DIE LETZTEN ZWEI STELLEN sind ABGELEITET, NICHT BELEGT. Keine
  -- gezeichnete Quelle sagt, wofuer sie stehen. Vergeben wird '01'.
  -- Der Punkt geht in die Vorlage (Bericht zu M4).
  --
  -- GLEICHZEITIGKEIT. Der Zaehler steht in `nummernvorrat` und wird mit
  -- UPDATE ... RETURNING gezogen. Das UPDATE sperrt die Zeile bis zum
  -- Ende der Transaktion; ein zweiter Anlauf wartet und liest danach den
  -- erhoehten Stand. Zwei Anlagen koennen deshalb nicht dieselbe Nummer
  -- bekommen. Bricht der Vorgang ab, laeuft die Nummer in den Vorrat
  -- zurueck -- so ist die Zaehlertabelle in M30 ausdruecklich gezeichnet
  -- (V5/B): "Niemals wiederverwendet" meint die VERGEBENE Nummer, nicht
  -- die bloss gezogene.
  IF t.customer_code IS NULL THEN
    RAISE EXCEPTION 'PROJEKTNUMMER: der Mandant fuehrt keinen Kundencode; ohne ihn laesst sich keine Projektnummer bilden (K01-M38)'
      USING ERRCODE = 'check_violation';
  END IF;

  UPDATE nummernvorrat
     SET naechste_nummer = naechste_nummer + 1,
         geaendert_am    = now()
   WHERE praefix = 'PROJ'
  RETURNING naechste_nummer - 1 INTO nr;

  IF nr IS NULL THEN
    RAISE EXCEPTION 'PROJEKTNUMMER: der Vorrat fuehrt keine Zeile fuer PROJ (K01-M38)'
      USING ERRCODE = 'check_violation';
  END IF;
  IF nr > 999 THEN
    -- Drei Stellen sind drei Stellen. Lieber hier anhalten als eine
    -- Nummer bilden, die das Format verletzt -- die Bedingung an der
    -- Spalte faenge es zwar auch, aber ohne zu sagen, was los ist.
    RAISE EXCEPTION 'PROJEKTNUMMER: der Vorrat ist bei % angelangt, das Format traegt nur drei Stellen (K01-M38)', nr
      USING ERRCODE = 'check_violation';
  END IF;

  v_no := t.customer_code || '_' || lpad(nr::text, 3, '0') || '_01';

  -- -----------------------------------------------------------------
  -- 2d · Die Zeile, die fuenfte Pruefung und der Verlauf
  -- -----------------------------------------------------------------
  INSERT INTO app(tenant_id, project_no, name, fit_check_id, created_at)
  VALUES (p_tenant, v_no, p_name, p_fit_check, current_date)
  RETURNING id, currency::text INTO neu, v_currency;

  -- K01-M27, fuenfte Pruefung: currency = EUR. Sie fehlte in M30 -- dort
  -- stand, die Waehrung sei "Vorgabe der Spalte und wird hier nicht
  -- uebergeben". Eine Vorgabe ist ein Netz, kein Plan: aendert jemand die
  -- Spaltenvorgabe, entstuende die Zeile weiter, nur mit anderer
  -- Waehrung. Geprueft wird deshalb der TATSAECHLICHE Wert der eben
  -- entstandenen Zeile, in derselben Transaktion. Schlaegt es fehl,
  -- rollt alles zurueck -- auch die gezogene Nummer.
  IF v_currency <> 'EUR' THEN
    RAISE EXCEPTION 'ANLAGE: die Waehrung der Anwendung ist %, zulaessig ist EUR (K01-M27)', v_currency
      USING ERRCODE = 'check_violation';
  END IF;

  -- Verlaufszeile DISCOVERY. Sie wird hier NICHT geschrieben -- das tut
  -- der Ausloeser app_state_history_sync_trg aus M30 (Z. 709-727)
  -- zwangslaeufig beim INSERT. Nachgesehen wird trotzdem: der
  -- Bildschirmvertrag nennt sie als Teil des Erfolgs, und ein Erfolg,
  -- den niemand nachsieht, ist eine Behauptung. Faellt der Ausloeser
  -- einmal weg, entsteht hier keine Anwendung ohne Verlauf, sondern gar
  -- keine (K01-G06: der Verlauf ist der Nachweis).
  SELECT count(*) INTO v_verlauf
    FROM app_state_history
   WHERE app_id = neu AND state = 'DISCOVERY' AND upper_inf(gueltig);
  IF v_verlauf <> 1 THEN
    RAISE EXCEPTION 'ANLAGE: zur neuen Anwendung steht % offene Verlaufszeile DISCOVERY statt einer (K01-M28, K01-G06)', v_verlauf
      USING ERRCODE = 'check_violation';
  END IF;

  -- -----------------------------------------------------------------
  -- 2e · Die beidseitige Verknuepfung und ihre Gegenprobe (K04-M17)
  -- -----------------------------------------------------------------
  -- "Vor dem Commit wird Gleichheit beider Bezuege geprueft; jede
  -- Abweichung rollt alles zurueck." Also wird nicht nur geschrieben,
  -- sondern beides zurueckgelesen. Der Mandant steht auch im UPDATE --
  -- ein Check eines fremden Mandanten gilt als nicht vorhanden
  -- (K04-D08).
  UPDATE fit_check SET app_id = neu
   WHERE id = p_fit_check AND tenant_id = p_tenant;

  SELECT app_id INTO v_rueck FROM fit_check WHERE id = p_fit_check;
  SELECT fit_check_id INTO v_hin FROM app WHERE id = neu;
  IF v_rueck IS DISTINCT FROM neu OR v_hin IS DISTINCT FROM p_fit_check THEN
    RAISE EXCEPTION 'ANLAGE: die beidseitige Verknuepfung stimmt nicht ueberein (K04-M17)'
      USING ERRCODE = 'check_violation';
  END IF;

  -- -----------------------------------------------------------------
  -- 2f · Die Protokollzeile
  -- -----------------------------------------------------------------
  -- Die Entstehung einer Anwendung ist der folgenreichste Vorgang dieses
  -- Weges. `event.project_no` gibt es genau dafuer. `actor_label` steht
  -- mit im INSERT, weil die Bedingung `event_actor_paarweise`
  -- Verknuepfung und Namensschnappschuss gemeinsam verlangt (K02-G13).
  INSERT INTO event(actor_id, actor_label, tenant_id, project_no, action,
                    object_ref, change_type, value, source)
  VALUES (p_actor, a.display_name, p_tenant, v_no, 'ANWENDUNG_ANGELEGT',
          'APP:' || neu::text, 'Neuanlage',
          'aus Eignungs-Check ' || p_fit_check::text, 'PORTAL_ACTION');

  RETURN neu;
END $$;

COMMENT ON FUNCTION create_app_after_fit(uuid,text,uuid,uuid) IS
  'K01-M27 · K01-M38 · K01-D19 · K04-M17 · K04-M21 · M31. Der einzige Weg zu '
  'einer app-Zeile. Er prueft in derselben Transaktion Mandant, Rechtsraum, '
  'Konto, Mandantenzugehoerigkeit, Eignung und Waehrung, verlangt die '
  'vollstaendige Zweckbestimmung samt Kenntnisnahme und bildet die '
  'Projektnummer selbst. Sie wird vergeben, nicht eingegeben.';

-- =====================================================================
-- 3 · Die alte Fassung wird entfernt (K01-M38, K01-D19)
-- =====================================================================
--
-- Die Fassung aus M30 nimmt `p_project_no` entgegen. Solange sie
-- aufrufbar bleibt, gibt es einen Weg, auf dem eine Projektnummer
-- eingegeben statt vergeben wird -- und K01-D19 sagt: "Kein Bildschirm,
-- kein Formular und kein Endpunkt DARF die Projektnummer zur Eingabe,
-- Auswahl oder Aenderung anbieten."
--
-- EIN FRUEHERER STAND HAT SIE NUR ENTRECHTET, NICHT ENTFERNT. Die
-- Abwaegung war, blind geschriebene Prueffaelle nicht an "Funktion
-- existiert nicht" scheitern zu lassen. Gemessen am 16.08.2026 traegt
-- sie nicht, aus zwei Gruenden:
--
--   1. Der Entzug schliesst die Umgehung nicht. PostgreSQL laesst den
--      EIGENTUEMER der Funktion unabhaengig von GRANT/REVOKE aufrufen --
--      und die Anwendung verbindet sich heute als eben dieser
--      Eigentuemer (`postgres`). Der Weg, auf dem eine Projektnummer
--      eingegeben statt vergeben wird, stand also weiterhin offen. Nicht
--      theoretisch: er ist derselbe Zugang, den app/zweckbestimmung.py
--      benutzt.
--   2. Die Schonung hat ihr Ziel verfehlt. Ein Prueffall, der die alte
--      Stelligkeit aufruft, bekam nicht die ehrliche Auskunft "Funktion
--      existiert nicht", sondern "permission denied for function
--      create_app_after_fit" -- eine Meldung, die in die falsche
--      Richtung zeigt: sie liest sich als Rechteproblem, wo eine
--      Signaturaenderung vorliegt. Fehlt die Funktion dagegen ganz,
--      greift die Vorsichtsklausel eines blind geschriebenen Falls und
--      meldet, was zutrifft: NICHT GEMESSEN.
--
-- Also wird sie entfernt. BEDINGT, nicht unbedingt -- damit ein zweiter
-- Lauf nichts mehr aendert und die Datei auf einer Datenbank ohne die
-- alte Fassung genauso durchlaeuft.
--
-- to_regprocedure statt pg_get_function_identity_arguments: die zweite
-- Auskunft nennt die PARAMETERNAMEN mit ("p_tenant uuid, ..."), nicht nur
-- die Typen. Ein Vergleich gegen die Typliste geht dann still ins Leere --
-- gemessen am 16.08.2026: der Entzug lief nicht, und die Rechte standen
-- unveraendert. to_regprocedure loest genau die eine Stelligkeit auf und
-- liefert NULL, wenn es sie nicht gibt. Die neue Vierwert-Fassung traegt
-- eine andere Stelligkeit und wird davon nicht beruehrt.
DO $$ BEGIN
  IF to_regprocedure('public.create_app_after_fit(uuid,text,text,uuid,uuid)')
     IS NOT NULL THEN
    DROP FUNCTION create_app_after_fit(uuid,text,text,uuid,uuid);
  END IF;
END $$;

-- Und das Recht auf die neue Fassung -- fuer eine Rolle, nicht fuer alle.
-- Ohne die GRANT-Zeile haette der Rechteschnitt aus M30 den Weg
-- geschlossen, ohne einen neuen zu oeffnen. Ohne die REVOKE-Zeile davor
-- braeuchte es sie gar nicht: PostgreSQL erteilt EXECUTE beim Anlegen an
-- PUBLIC, und bei einer Funktion mit SECURITY DEFINER heisst das, dass
-- JEDE Rolle mit den Rechten des Eigentuemers eine Anwendung anlegen
-- koennte. Der Befehl ist der einzige Weg zu einer app-Zeile (K01-M27) --
-- er ist damit auch die einzige Stelle, an der dieser Rechteschnitt
-- ueberhaupt noch wirkt.
DO $$ BEGIN
  REVOKE ALL ON FUNCTION create_app_after_fit(uuid,text,uuid,uuid) FROM PUBLIC;
  IF EXISTS (SELECT 1 FROM pg_roles WHERE rolname = 'fr_portal') THEN
    GRANT EXECUTE ON FUNCTION create_app_after_fit(uuid,text,uuid,uuid) TO fr_portal;
  END IF;
END $$;

-- =====================================================================
-- ABSCHLUSS · Versionseintrag
-- =====================================================================
INSERT INTO schema_migration(version, beschreibung) VALUES
  ('v3.0-pilot-02',
   'M31 · Die Projektnummer wandert in den Serverbefehl (K01-M38, K01-D19), '
   'die fuenfte Pruefung aus K01-M27 (currency = EUR) wird nachgezogen, und '
   'der Eignungs-Check bekommt den Traeger der Zweckbestimmungs-Erklaerung: '
   'zwei nullbare Ja/Nein-Spalten und den Zeitpunkt der Vollstaendigkeit '
   '(K04-M19). Die Anlage verlangt seither die vollstaendige Erklaerung, '
   'weist einen Treffer in Frage 2 ab (K04-D10) und verlangt bei einem '
   'Treffer in Frage 1 die Kenntnisnahme (K04-M21).')
ON CONFLICT (version) DO NOTHING;

COMMIT;
