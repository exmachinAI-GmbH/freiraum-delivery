-- =====================================================================
--  FREIRAUM · Migration 260801 · Tabelle tenant
--  Grundlage: Founder-Zeichnungen vom 01.08.2026
--             O-K02-11 (Auftragsverarbeitung)  ·  O-K02-12 (Partneraufgabe)
--
--  WARUM DIESE DATEI UND NICHT DAS DDL:
--  freiraum_datamodel.sql liegt in v2.9_PIVOT/ und ist eingefroren.
--  Der Harness aendert dort nichts. Diese Datei ist der Vorschlag zur
--  Uebernahme; wer sie anwendet, entscheidet bewusst.
--
--  ABHAENGIGE KLAUSELN — ohne diese Migration nicht vollziehbar:
--    K02-M29, K02-M30, K02-D13, K02-G17   (Auftragsverarbeitung)
--    K02-M31, K02-D12                     (Partneraufgabe)
--    K10-M35, K10-D11                     (Empfaenger der Uebergabe)
--    K14-M20                              (Zugang je Partner)
--
--  PRUEFUNG NACH DEM ANWENDEN: die vier Negativfaelle am Ende dieser Datei
--  muessen ALLE abgewiesen werden. Laeuft einer durch, ist die Migration
--  unvollstaendig.
-- =====================================================================

BEGIN;

-- ---------------------------------------------------------------------
-- 1 · Auftragsverarbeitung  (O-K02-11)
--
--   Zwei Spalten, beide fuer sich leer lassbar. Erst die Bedingung macht
--   sie bei der Art Kunde zur Pflicht -- genau wie customer_needs_code.
--   Der Vertrag selbst bleibt ausserhalb der Plattform (K02-D13); hier
--   steht nur der Nachweis, DASS er hinterlegt ist.
-- ---------------------------------------------------------------------

ALTER TABLE tenant
  ADD COLUMN avv_datum        date,   -- Tag der Hinterlegung
  ADD COLUMN avv_aktenzeichen text;   -- Verweis auf die Ablage ausserhalb

COMMENT ON COLUMN tenant.avv_datum IS
  'O-K02-11: Tag der Hinterlegung des Auftragsverarbeitungsvertrags. '
  'Pflicht bei kind = CUSTOMER, siehe customer_needs_avv.';
COMMENT ON COLUMN tenant.avv_aktenzeichen IS
  'O-K02-11: Aktenzeichen der Ablage ausserhalb der Plattform. Der Vertrag '
  'selbst ist kein Plattformdokument (K02-D13).';

ALTER TABLE tenant
  ADD CONSTRAINT customer_needs_avv
  CHECK (kind <> 'CUSTOMER'
         OR (avv_datum IS NOT NULL AND avv_aktenzeichen IS NOT NULL));

-- ---------------------------------------------------------------------
-- 2 · Aufgabe des Partners  (O-K02-12)
--
--   ZWEI unabhaengige Wahrheitswerte, kein Enum und kein vierter Wert in
--   tenant_kind -- K02-M02 laesst keinen zu, und eine Firma kann beides
--   tun. Ein Enum braeuchte dafuer einen dritten Wert "beides" und wuerde
--   bei jeder weiteren Aufgabe wieder wachsen.
-- ---------------------------------------------------------------------

ALTER TABLE tenant
  ADD COLUMN partner_baut      boolean NOT NULL DEFAULT false,
  ADD COLUMN partner_setzt_um  boolean NOT NULL DEFAULT false;

COMMENT ON COLUMN tenant.partner_baut IS
  'O-K02-12: Der Partner erstellt die Anwendung (bauender Umsetzungspartner). '
  'Empfaenger des Testpakets nach K10-M37.';
COMMENT ON COLUMN tenant.partner_setzt_um IS
  'O-K02-12: Der Partner setzt beim Kunden um und betreibt. Erhaelt das '
  'Testpaket NICHT (K10-D10).';

ALTER TABLE tenant
  ADD CONSTRAINT partner_needs_aufgabe
  CHECK (
    CASE kind
      WHEN 'PARTNER' THEN (partner_baut OR partner_setzt_um)   -- mindestens eine
      ELSE (partner_baut = false AND partner_setzt_um = false) -- sonst keine
    END
  );

COMMIT;

-- =====================================================================
--  NEGATIVFAELLE · nach dem Anwenden ausfuehren.
--  Alle vier MUESSEN scheitern -- UND JEDER AM RICHTIGEN GRUND.
--
--  BERICHTIGT 02.08.2026 nach dem ersten echten Lauf gegen PostgreSQL 16.
--  Die urspruenglichen Codes lauteten DE-ZN1, DE-ZN2 und DE-ZN4. Sie enthalten
--  Ziffern und scheitern deshalb bereits an customer_code_fmt (^DE-[A-Z]{3}$) --
--  also BEVOR die eigentlich zu pruefende Bedingung ueberhaupt erreicht wird.
--  Drei der vier Faelle haetten "abgewiesen" gemeldet, ohne je customer_needs_avv
--  oder partner_needs_aufgabe zu beruehren: ein bestandener Test, der nichts
--  misst. Es genuegt daher NICHT zu pruefen, DASS ein Satz scheitert -- es ist
--  zu pruefen, an WELCHER Bedingung. Nachweis: N1, N2, N4 unten sowie N5.
-- =====================================================================

-- N1 · Kunde ohne Vertragsnachweis  -> customer_needs_avv
-- INSERT INTO tenant (kind, name, customer_code, legal_space)
--   VALUES ('CUSTOMER', 'N1 Testbank', 'DE-ZNA', 'DE');

-- N2 · Kunde mit nur einer der beiden Angaben  -> customer_needs_avv
-- INSERT INTO tenant (kind, name, customer_code, legal_space, avv_datum)
--   VALUES ('CUSTOMER', 'N2 Testbank', 'DE-ZNB', 'DE', DATE '2026-08-01');

-- N3 · Partner ohne Aufgabe  -> partner_needs_aufgabe
-- INSERT INTO tenant (kind, name, legal_space)
--   VALUES ('PARTNER', 'N3 Systemhaus', 'DE');

-- N4 · Kunde mit Partneraufgabe  -> partner_needs_aufgabe
-- INSERT INTO tenant (kind, name, customer_code, legal_space,
--                     avv_datum, avv_aktenzeichen, partner_baut)
--   VALUES ('CUSTOMER', 'N4 Testbank', 'DE-ZND', 'DE',
--           DATE '2026-08-01', 'AZ-0001', true);

-- N5 · Kunden-Code mit Ziffer  -> customer_code_fmt
--   Neu am 02.08.2026: haelt den Formatfall als eigenen Fall fest, statt ihn
--   in den anderen drei mitlaufen zu lassen.
-- INSERT INTO tenant (kind, name, customer_code, legal_space,
--                     avv_datum, avv_aktenzeichen)
--   VALUES ('CUSTOMER', 'N5 Testbank', 'DE-ZN1', 'DE',
--           DATE '2026-08-01', 'AZ-0002');

-- =====================================================================
--  BESTANDSDATEN
--  Beide Bedingungen greifen sofort. Bestehende Kundenmandanten ohne
--  Vertragsnachweis lassen die Migration SCHEITERN -- gewollt: ein
--  Kundenmandant ohne Nachweis ist nach K02-M30 kein zulaessiger Zustand.
--  Vor dem Anwenden pruefen:
--    SELECT id, name FROM tenant
--     WHERE kind = 'CUSTOMER'
--       AND (avv_datum IS NULL OR avv_aktenzeichen IS NULL);
--  Ist die Liste nicht leer, zuerst nachtragen -- nicht die Bedingung
--  lockern.
-- =====================================================================
