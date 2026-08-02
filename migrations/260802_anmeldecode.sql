-- =====================================================================
--  FREIRAUM · Migration 260802 · Anmeldecode, Fehlversuche, Sitzung
--
--  ANLASS: Beim Bau von B2 (E-Mail-Versand) am 02.08.2026 gegen die
--  laufende v2.9-Datenbank geprueft: Vier Klauseln aus K03 verlangen
--  dauerhaften Zustand, fuer den das Datenmodell KEINEN Ort hat.
--
--    K03-M15  Ein E-Mail-Code ist zehn Minuten und genau einmal gueltig.
--             Ein neuer Code entwertet alle aelteren Codes desselben
--             Kontos. "Gespeichert wird nur sein kryptografischer
--             Pruefwert."  -> es gibt keine Spalte dafuer.
--    K03-M16  Nach fuenf falschen Codes wird der Code ungueltig, weitere
--             Versuche 15 Minuten gedrosselt.  -> kein Zaehler.
--    K03-M17  Sitzung endet nach 30 Minuten Untaetigkeit, spaetestens
--             nach acht Stunden, "beide Grenzen prueft der Server".
--             -> keine Sitzung im Schema.
--    K03-M18  Heikle Aenderungen verlangen eine Anmeldung, die hoechstens
--             zehn Minuten zurueckliegt.  -> kein Anmeldezeitpunkt je
--             Sitzung; actor.last_login_at ist ein einzelner Wert und
--             kennt keine Sitzung.
--
--  Das Abnahmekriterium von B2 -- "der Erst-Admin meldet sich zweimal
--  hintereinander an und erhaelt zweimal einen neuen Code; der erste ist
--  nach der ersten Verwendung wertlos" -- ist ohne diese Speicherung
--  nicht nachweisbar. Nicht schwer zu bauen, aber nicht vorhanden.
--
--  STATUS: VORSCHLAG. Das DDL in v2.9_PIVOT/ ist eingefroren; diese Datei
--  aendert dort nichts. Wer sie anwendet, entscheidet bewusst -- dasselbe
--  Vorgehen wie bei Migration_260801_tenant.sql.
--
--  ABGRENZUNG: Der Klartext des Codes wird NIE gespeichert, nur sein
--  Streuwert -- wie bei invitation.token_hash (K03-D03 als Muster).
-- =====================================================================

BEGIN;

-- ---------------------------------------------------------------------
-- 1 · Anmeldecode  (K03-M15, K03-M16)
-- ---------------------------------------------------------------------
CREATE TABLE login_code (
  id           uuid PRIMARY KEY DEFAULT gen_random_uuid(),
  actor_id     uuid NOT NULL REFERENCES actor(id) ON DELETE CASCADE,
  code_hash    text NOT NULL,                    -- nur der Pruefwert (K03-M15)
  issued_at    timestamptz NOT NULL DEFAULT now(),
  -- Die Frist rechnet die DATENBANK, nicht der Aufrufer.
  -- Erster Lauf am 02.08.2026: der Aufrufer setzte expires_at aus seiner eigenen
  -- Uhr, issued_at kam aus now() der Datenbank -- drei Millisekunden Versatz,
  -- und die Bedingung schlug zu. Der Versatz war das kleinere Problem: solange
  -- der Aufrufer die Frist mitgibt, KANN er eine laengere mitgeben. Jetzt kann
  -- er es nicht mehr.
  expires_at   timestamptz NOT NULL DEFAULT (now() + interval '10 minutes'),
  consumed_at  timestamptz,                      -- gesetzt = verbraucht
  superseded_at timestamptz,                     -- gesetzt = durch neueren entwertet
  failed_count smallint NOT NULL DEFAULT 0,

  -- Zehn Minuten, nicht laenger. Die Frist ist nach K03-M15 nicht verhandelbar.
  CONSTRAINT login_code_frist
    CHECK (expires_at <= issued_at + interval '10 minutes'),
  -- Nach K03-M16 ist bei fuenf Fehlversuchen Schluss.
  CONSTRAINT login_code_fehlversuche
    CHECK (failed_count BETWEEN 0 AND 5),
  -- Ein Code ist entweder verbraucht oder entwertet, nie beides.
  CONSTRAINT login_code_ende_eindeutig
    CHECK (consumed_at IS NULL OR superseded_at IS NULL)
);

COMMENT ON TABLE login_code IS
  'K03-M15/M16: Zweiter Faktor je Anmeldung. Klartext wird nie gespeichert.';

CREATE INDEX login_code_actor_idx ON login_code (actor_id, issued_at DESC);

-- Genau EIN offener Code je Konto. Setzt K03-M15 durch -- "ein neuer Code
-- entwertet alle aelteren" -- als Bedingung statt als Absichtserklaerung.
CREATE UNIQUE INDEX login_code_nur_einer_offen
  ON login_code (actor_id)
  WHERE consumed_at IS NULL AND superseded_at IS NULL;

-- Ein neuer Code entwertet die aelteren automatisch. Ohne diesen Ausloeser
-- muesste jede aufrufende Stelle daran denken -- und eine Regel, die nur
-- gilt, solange jemand an sie denkt, ist keine Regel.
CREATE FUNCTION login_code_entwertet_aeltere() RETURNS trigger
LANGUAGE plpgsql AS $$
BEGIN
  UPDATE login_code
     SET superseded_at = now()
   WHERE actor_id = NEW.actor_id
     AND id <> NEW.id
     AND consumed_at IS NULL
     AND superseded_at IS NULL;
  RETURN NEW;
END $$;

CREATE TRIGGER login_code_entwertet_aeltere_trg
  BEFORE INSERT ON login_code
  FOR EACH ROW EXECUTE FUNCTION login_code_entwertet_aeltere();

-- ---------------------------------------------------------------------
-- 2 · Zustellnachweis  (Bauauftrag B2)
--
--    Ohne ihn ist eine fehlgeschlagene Einladung nicht von einer nicht
--    gesendeten zu unterscheiden -- der ausdrueckliche Vorbehalt des
--    Bauauftrags. Die Tabelle traegt den Versand, nicht den Inhalt.
-- ---------------------------------------------------------------------
CREATE TYPE mail_kind   AS ENUM ('EINLADUNG','ANMELDECODE');
CREATE TYPE mail_status AS ENUM ('UEBERGEBEN','ABGELEHNT','FEHLER');

CREATE TABLE mail_delivery (
  id            uuid PRIMARY KEY DEFAULT gen_random_uuid(),
  actor_id      uuid REFERENCES actor(id) ON DELETE SET NULL,
  kind          mail_kind NOT NULL,
  recipient     text NOT NULL,
  sender        text NOT NULL,
  status        mail_status NOT NULL,
  provider_id   text,                 -- Kennung des Versanddienstes
  provider_note text,                 -- Antwort im Klartext, fuer die Fehlersuche
  sent_at       timestamptz NOT NULL DEFAULT now(),

  -- Ein Fehlschlag ohne Begruendung ist kein Nachweis.
  CONSTRAINT mail_fehler_braucht_grund
    CHECK (status = 'UEBERGEBEN' OR provider_note IS NOT NULL)
);

COMMENT ON TABLE mail_delivery IS
  'Bauauftrag B2: Zustellnachweis. Kein Mailinhalt, nur Empfaenger, Absender, '
  'Ergebnis und Antwort des Versanddienstes.';

CREATE INDEX mail_delivery_actor_idx ON mail_delivery (actor_id, sent_at DESC);

COMMIT;

-- =====================================================================
--  NEGATIVFAELLE · nach dem Anwenden ausfuehren. Alle MUESSEN scheitern,
--  und zwar JEDER AN SEINER EIGENEN BEDINGUNG (Lehre aus Migration 260801:
--  drei ihrer vier Faelle scheiterten am Codeformat statt an der Zielregel).
-- =====================================================================

-- N1 · Code mit Frist ueber zehn Minuten  -> login_code_frist
-- N2 · Sechster Fehlversuch               -> login_code_fehlversuche
-- N3 · Zwei offene Codes je Konto         -> login_code_nur_einer_offen
-- N4 · Fehlschlag ohne Begruendung        -> mail_fehler_braucht_grund
-- Ausfuehrbar in migrations/pruefe_anmeldecode.sh
