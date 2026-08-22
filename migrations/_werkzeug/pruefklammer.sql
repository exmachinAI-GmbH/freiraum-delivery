-- =====================================================================
--  FREIRAUM · Klammer um eine Prüfdatei — der Lauf hinterlässt nichts
-- =====================================================================
--
--  NEU AM 22.08.2026. Anlass ist ein gemessener Befund aus der
--  Gegenprüfung des Fremdmodell-Laufs (dort als P0-3 geführt).
--
--  WOZU DIESE DATEI DA IST
--  -----------------------
--  `schema/pruefung_v2.9.sql` — die eingefrorenen Prüffälle T0 bis T23 —
--  legt sich ihre Ausgangslage selbst an: zwei Mandanten, zwei Akteure,
--  zwei Mitgliedschaften, zwei Einladungen, eine Eignungsprüfung und eine
--  Anwendung. Abgeräumt wird davon nichts. Die Datei kennt nur
--  `SAVEPOINT` und `ROLLBACK TO <Punkt>` — 14 Teilrücknahmen, aber keinen
--  abschließenden `ROLLBACK`. Ihre letzte Anweisung ist ein `SELECT`.
--
--  Bis zum 22.08.2026 fuhr `migrations/kettenlauf.sh` sie mit `psql -1`.
--  Der Schalter `-1` klammert die Datei in `BEGIN` … `COMMIT` und setzt
--  am Dateiende ein COMMIT ab. Die synthetischen Prüfdaten standen danach
--  UNWIDERRUFLICH in der Zieldatenbank. Nach F36 wird in diesem Projekt
--  nichts gelöscht; ein Pilotlauf gegen die echte Umgebung hätte sie also
--  dauerhaft verunreinigt.
--
--  Diese Datei legt die fehlende Klammer AUSSEN HERUM: `BEGIN`, dann die
--  Prüfdatei über `\i`, dann `ROLLBACK`. Die Prüfdatei selbst wird nicht
--  angefasst — sie liegt unter `schema/` mit der Änderungsregel „keine"
--  (`schema/README.md`), und eine Messung wird nicht umgeschrieben.
--
--  WARUM DIE KLAMMER HÄLT — NACHGESEHEN, NICHT ANGENOMMEN
--  ------------------------------------------------------
--  Eine Klammer von außen trägt nur, solange die eingeschlossene Datei
--  die Transaktion nicht selbst beendet. Gemessen am 22.08.2026 in
--  `schema/pruefung_v2.9.sql`: null `BEGIN`, null `START TRANSACTION`,
--  null `COMMIT`, null `END;`, null alleinstehendes `ROLLBACK;` — die 14
--  Fundstellen sind ausnahmslos `ROLLBACK TO s<n>`, und die geben nur bis
--  zu einem Sicherungspunkt zurück, ohne die Transaktion zu beenden.
--  Null Dollar-Zitate (`$$`), also auch kein `BEGIN` aus einem
--  PL/pgSQL-Block, das dabei mitgezählt worden wäre.
--
--  `migrations/kettenlauf.sh` sieht das vor jedem Lauf selbst nach und
--  bricht ab, wenn eine dieser Anweisungen auftaucht (Funktion
--  `klammer_tragfaehig`). Eine Prüfdatei, die ihre eigene Transaktion
--  beendet, wird BENANNT, nicht überlistet.
--
--  WARUM SIE IM UNTERORDNER `_werkzeug/` LIEGT
--  -------------------------------------------
--  `migrations/*.sql` ist an vier Stellen das Suchmuster für ALLE
--  Migrationen: `migrations/kettenlauf.sh` beim Umfang `alle` und
--  `.github/workflows/tore.yml`:330, :360 und :447. Läge diese Datei
--  direkt in `migrations/`, spielten alle vier sie als Migration ein.
--  Unterordner fasst das Muster nicht -- aus demselben Grund tragen
--  `_vorlaeufer/` und `_abgeloest/` einen Unterstrich.
--
--  BEDIENUNG
--  ---------
--      psql "<verbindung>" -v ON_ERROR_STOP=1 \
--           -v pruefdatei=<Pfad zur Prüfdatei> \
--           -f migrations/_werkzeug/pruefklammer.sql
--
--  WAS MAN SIEHT, WENN ES GUT GEHT
--    Zuerst `BEGIN`, dann Zeile für Zeile die unveränderte Ausgabe der
--    Prüfdatei — bei `pruefung_v2.9.sql` die Zeilen
--    `T0 …|erwartet|beobachtet` —, dann `ROLLBACK` und zuletzt die Zeile
--
--      -- KLAMMER: ROLLBACK abgesetzt, die Prüfdaten sind zurückgenommen.
--
--    Diese letzte Zeile ist der Beleg, dass die Klammer ihr Ende erreicht
--    hat. `kettenlauf.sh` sucht sie im Protokoll; fehlt sie, gilt Beleg 4
--    als fehlgeschlagen.
--
--  WAS MAN SIEHT, WENN ES SCHIEFGEHT
--    * „ABBRUCH: Die Klammer wurde ohne Prüfdatei aufgerufen." — dann
--      fehlt `-v pruefdatei=…`. Nächster Schritt: den Pfad angeben.
--    * Die Schlusszeile fehlt: die Prüfdatei hat die Sitzung vorzeitig
--      beendet (etwa durch `\quit`) oder die Verbindung ist abgerissen.
--      Nächster Schritt: das Protokoll von unten lesen; die letzte Zeile
--      der Prüfdatei sagt, wo es endete.
--
--  EINE GRENZE, GEMESSEN UND BENANNT
--    Der Pfad der Prüfdatei darf KEIN Leerzeichen enthalten. psql setzt
--    den Wert einer Variablen in `\i :pruefdatei` unverändert ein, und
--    die Anführungsform `\i :'pruefdatei'` hilft nicht: gemessen am
--    22.08.2026 mit psql 16.13 landen dabei die Anführungszeichen im
--    Dateinamen („No such file or directory"). `kettenlauf.sh` sieht den
--    Pfad deshalb vorher nach und bricht mit einer eigenen Meldung ab.
--
--  WAS DIESE DATEI NICHT TUT
--    Sie ändert das Verhalten der Prüffälle nicht. Insbesondere setzt sie
--    `ON_ERROR_STOP` für die Prüfdatei nicht zurück: `pruefung_v2.9.sql`
--    schaltet es in ihrer Zeile 3 selbst aus, und sie ist darauf gebaut —
--    ihre Gegentests scheitern absichtlich und werden über
--    Sicherungspunkte aufgefangen. Erst NACH `\i` schaltet die Klammer es
--    wieder ein, damit ein fehlschlagendes `ROLLBACK` nicht stumm bliebe.
-- =====================================================================

\if :{?pruefdatei}
\else
  \echo 'ABBRUCH: Die Klammer wurde ohne Pruefdatei aufgerufen.'
  \echo '         Woran es liegt: die psql-Variable "pruefdatei" ist nicht gesetzt.'
  \echo '         Naechster Schritt: den Aufruf um -v pruefdatei=<Pfad> ergaenzen.'
  -- Nicht nur melden, sondern scheitern: mit ON_ERROR_STOP=1 endet psql
  -- hier mit Rückgabewert 3. Ein stiller Lauf ohne Prüffälle wäre sonst
  -- ein grüner Lauf, der nichts gemessen hat.
  DO $klammer$ BEGIN
    RAISE EXCEPTION 'Klammer ohne Pruefdatei aufgerufen -- siehe die drei Zeilen darueber.';
  END $klammer$;
  \quit
\endif

BEGIN;

\i :pruefdatei

-- Ab hier wieder hörbar: die Prüfdatei hat ON_ERROR_STOP ausgeschaltet.
-- Ein `ROLLBACK`, das nicht durchginge, soll den Lauf abbrechen und nicht
-- als bestanden durchgehen.
\set ON_ERROR_STOP on

ROLLBACK;

\echo '-- KLAMMER: ROLLBACK abgesetzt, die Pruefdaten sind zurueckgenommen.'
