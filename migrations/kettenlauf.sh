#!/usr/bin/env bash
# =====================================================================
#  FREIRAUM · Kettenlauf — die fünf Belege über einen wählbaren
#                          Migrationsumfang
# =====================================================================
#
#  WAS DIESES SKRIPT TUT
#  ---------------------
#  Es fährt denselben Nachweis wie `migrations/n2_lauf.sh` — Grundschema,
#  Migration zweimal, Prüffälle, Gegentest-Meldungen, eingefrorene Fälle
#  T0 bis T23, Objektzahlen —, aber über einen Migrationsumfang, den der
#  Aufrufende BENENNEN MUSS. Am Ende liegt ein Ordner mit allen Rohbelegen
#  und einer `NACHWEIS.md`, die je Beleg einen Zustand führt.
#
#  WARUM ES DIESES SKRIPT GIBT
#  ---------------------------
#  `n2_lauf.sh` spielt genau eine Migration ein: M30, fest verdrahtet
#  (`migrations/n2_lauf.sh`:42). Inzwischen gibt es drei — M30 (die
#  Sammelmigration), M31 (Projektnummer und Zweckbestimmung) und M32
#  (Zeilenschutz und Stufenwechsel). M31 wirft die fünfstellige Fassung
#  von `create_app_after_fit` weg und ersetzt sie durch eine vierstellige
#  ohne `p_project_no`. Ein zweiter M30-Lauf stellt die alte Fassung
#  wieder her — danach scheitern MT-95, MT-95b und MT-98. Gemessen und
#  im Wortlaut festgehalten in
#  `arbeit/Vorlagen/m1_startklar_260820.md`:79–84.
#
#  Dieses Skript LÖST das nicht auf. Es macht die Frage sichtbar und
#  verlangt eine Antwort, bevor es misst.
#
#  WAS ES NICHT TUT
#  ----------------
#   * Es ersetzt `n2_lauf.sh` nicht und ändert diese Datei nicht. Sie
#     trägt eine hinterlegte Prüfsumme (`migrations/n2_lauf.sh.sha256`);
#     eine Änderung dort wäre eine Änderung am ABNAHMELAUF und gehört
#     gezeichnet, nicht nebenbei gemacht.
#   * Es entscheidet den Umfang von M1 nicht. Ohne `--umfang` bricht es
#     ab und nennt die ungezeichnete Stelle.
#   * Es zeichnet nicht. Die `NACHWEIS.md` trägt Messwerte und leere
#     Unterschriftsfelder.
#   * Es setzt keinen Status, gibt nichts frei, spielt nichts aus.
#   * Es lässt KEINE Prüfdaten in der Datenbank zurück. Alle drei
#     Prüfdateien laufen in einer Transaktion, die am Ende zurückgerollt
#     wird: `pruefungen/migration/M30__pruefung.sql` bringt die Klammer
#     selbst mit (dort :20 `BEGIN;` und :1794 `ROLLBACK;`), das
#     Ersatz-Setup für T22/T23 weiter unten ebenfalls, und
#     `schema/pruefung_v2.9.sql` bekommt sie seit dem 22.08.2026 von
#     aussen durch `migrations/_werkzeug/pruefklammer.sql`.
#
#     BERICHTIGT AM 22.08.2026. Bis dahin stand diese Zusage hier ohne
#     den dritten Fall -- und sie stimmte nicht: Beleg 4 fuhr
#     `psql -1 -f schema/pruefung_v2.9.sql`, und `-1` COMMITTET am
#     Dateiende. Gemessen an einer Kopie der Prüfdatei bis Zeile 171 auf
#     einer frischen Datenbank: 8 Zeilen blieben dauerhaft stehen --
#     2 Mandanten, 2 Akteure, 2 Mitgliedschaften, 2 Einladungen.
#     Mit der Klammer sind es 0, bei unveränderter Ausgabe (je 22
#     Ergebniszeilen T0 bis T21).
#
#     WAS DER LAUF SEHR WOHL SCHREIBT: das Grundschema und die gewählten
#     Migrationen. Das IST die Messung und bleibt in der Datenbank
#     stehen -- deshalb gilt weiterhin "eine eigene Datenbank je
#     Pilot-Anlauf" (CLAUDE.md Abschnitt 5).
#   * Es fasst `migrations/_abgeloest/` und `migrations/uebernahme/`
#     NIEMALS an. `_abgeloest/` ist ersetzt, `uebernahme/` ist ein
#     Vorschlag aus fremder Zuständigkeit und kein Liefergegenstand.
#
#  KLAUSELBEZUG
#  ------------
#  Dieses Skript setzt keine Klausel um — es misst. Deshalb trägt sein
#  Kopf bewusst keine Umsetzungszeile. Es hält zwei Klauseln ein, die für
#  jeden Messlauf gelten: K23-M22 — die Klausel, die je Prüfung genau
#  einen von vier Zuständen zulässt (bestanden, fehlgeschlagen, gesperrt,
#  nicht ausgeführt) — und K23-D09, die verbietet, Zugangswerte in
#  Ausgabe, Protokoll oder Nachweis zu schreiben.
#
#  ---------------------------------------------------------------------
#  BEDIENUNG
#  ---------------------------------------------------------------------
#
#      bash migrations/kettenlauf.sh --umfang <m30|alle> "<verbindung>" [zielordner]
#
#    --umfang m30    nur `migrations/M30__pilot_sammelmigration.sql`
#                    (Lesart A des offenen Punktes, siehe unten)
#    --umfang alle   alle Dateien aus `migrations/*.sql` in lexikalischer
#                    Reihenfolge — heute M30, M31, M32
#                    (Lesart B des offenen Punktes)
#    --ohne-pruefsummen  die mitgelieferten Eingänge NICHT gegen ihre
#                    `.sha256` nachrechnen (nur für einen Rechner ohne
#                    das volle Repo; der Nachweis vermerkt es)
#    --mit-vorlaeufer  zusätzlich `migrations/_vorlaeufer/260801_tenant.sql`
#                    einspielen. VORGABE IST AUS — warum, steht unter
#                    REIHENFOLGE weiter unten. Der Nachweis vermerkt es.
#    --hilfe         diesen Kopf kurz zusammenfassen
#
#    <verbindung>    psql-Verbindung als Freitext, erstes Stellungsargument
#                    wie in `migrations/n2_lauf.sh`:36
#    [zielordner]    Ablage der Belege; Vorgabe:
#                    ../nachweise/kettenlauf/<datum_uhrzeit>_<umfang>
#
#  BEISPIEL FÜR EINE AZURE-ZIELUMGEBUNG (Flexible Server erzwingt TLS)
#
#      PGPASSWORD='⟨Kennwort aus dem Passwortspeicher⟩' \
#      bash migrations/kettenlauf.sh --umfang alle \
#        "host=freiraum-pilot.postgres.database.azure.com port=5432 \
#         dbname=freiraum user=frxadm sslmode=require"
#
#    `sslmode=require` ist Pflicht: Azure Database for PostgreSQL —
#    Flexible Server lässt unverschlüsselte Verbindungen nicht zu. Ohne
#    diese Angabe endet der Lauf an der Anmeldung, nicht an einer Messung.
#    Im übrigen Repo kommt `sslmode` bis heute an keiner Stelle vor;
#    deshalb steht das Beispiel hier.
#
#    DAS KENNWORT GEHÖRT IN `PGPASSWORD`, NICHT IN DIE VERBINDUNG. Ein
#    `password=…` im Stellungsargument steht in der Prozessliste des
#    Rechners und ist dort für jeden Mitbenutzer lesbar. `n2_lauf.sh`
#    lässt beide Formen zu; dieses Skript ebenfalls, prüft aber am Ende
#    aktiv nach, dass der Wert in keinem einzigen Beleg gelandet ist.
#
#  WAS MAN SIEHT, WENN ES GUT GEHT
#    Sechs Abschnitte "Beleg 0" bis "Beleg 5", jeder mit einer gemessenen
#    Zahl, zuletzt "FERTIG" und der Pfad des Belegordners. In der
#    `NACHWEIS.md` steht in jeder Zeile der Tabelle "bestanden".
#    Rückgabewert 0.
#
#  WAS MAN SIEHT, WENN ES SCHIEFGEHT
#    Eine Zeile, die mit "ABBRUCH:" beginnt, sagt, was nicht ging, woran
#    es lag und was als Nächstes zu tun ist. Der Lauf endet dort — ein
#    Nachweis über vier von fünf Prüfungen ist keiner. Die `NACHWEIS.md`
#    wird trotzdem geschrieben, mit dem Vermerk ABGEBROCHEN: die bereits
#    gemessenen Belege stehen als "bestanden", der abbrechende als
#    "fehlgeschlagen", die folgenden als "nicht ausgeführt".
#
#  RÜCKGABEWERTE
#    0  alle fünf Belege bestanden
#    1  ein Beleg ist fehlgeschlagen oder eine Vorbedingung fehlt
#    2  Bedienfehler — insbesondere: `--umfang` nicht angegeben
#
#  ---------------------------------------------------------------------
#  DER OFFENE PUNKT, DEN DIESES SKRIPT NICHT ENTSCHEIDET
#  ---------------------------------------------------------------------
#  Die beiden Lesarten und die Wahlkästchen stehen in
#  `arbeit/Vorlagen/m1_startklar_260820.md`:98–100, die Zeichnungszeile 2 in
#  derselben Datei:119, die Unterschriftszeilen A. Han / M. Veil in
#  derselben Datei:143–144.
#
#  STAND 22.08.2026, NACHGESEHEN UND NICHT BESTÄTIGT: In :119 steht seit
#  diesem Tag ein Kreuz bei B, und :144 trägt bei M. Veil das Datum
#  22.08.2026 mit dem Zusatz „(nur Zeile 2)". Der Wortlaut der Weisung ist
#  in :122–127 mitgeschrieben, wie CLAUDE.md Abschn. 6 es verlangt. Zeile 1
#  und Zeile 3 der Zeichnung sind weiterhin offen, und A. Han hat nicht
#  gegengezeichnet (:143 leer).
#
#  DIESES SKRIPT VERLÄSST SICH DARAUF NICHT. Es kennt die Weisung nicht aus
#  erster Hand, sondern findet sie im Arbeitsbaum vor. Deshalb bleibt
#  `--umfang` ein Pflichtargument: ein Werkzeug, das sich seine eigene
#  Zeichnung aus einer Datei liest, die es selbst nicht verifizieren kann,
#  hat den Riegel abgeschafft, der es davor bewahrt. Wer den Umfang als
#  entschieden führen will, prüft die Zeichnung und passt DANN diesen Kopf
#  an — nicht umgekehrt.
#
#    Lesart A — M1 meint M30 allein. Dann meldet der Prüflauf 108 von 111
#               und dieses Skript bricht in Beleg 2 ab. Die Zielumgebung
#               trüge danach M31 und M32 nicht.
#    Lesart B — M1 meint den Stand, auf dem die Anwendung läuft, also
#               M30 + M31 + M32. Dann meldet der Prüflauf 111 von 111.
#
#  `--umfang m30` fährt Lesart A, `--umfang alle` fährt Lesart B. Welche
#  gilt, entscheidet dieses Skript nicht und darf es nicht entscheiden:
#  ein Werkzeug, das eine ungezeichnete Frage still beantwortet, verlagert
#  die Entscheidung heimlich zum Werkzeug.
#
#  ---------------------------------------------------------------------
#  REIHENFOLGE UND IHR UNTERSCHIED ZU DEN BEIDEN BESTEHENDEN LÄUFEN
#  ---------------------------------------------------------------------
#      1  Grundschema  `schema/freiraum_datamodel.sql`
#      2  die gewählten Migrationen
#
#  Der Vorläufer `migrations/_vorlaeufer/260801_tenant.sql` läuft NUR mit
#  `--mit-vorlaeufer`. BERICHTIGT AM 22.08.2026 nach dem ersten echten Lauf
#  gegen PostgreSQL 16.13; bis dahin lief er immer, und dieser Kopf berief
#  sich dafür auf "frische Datenbank, DDL v2.9, Vorlaeufer 260801, …"
#  (`aufbau.sh`:5–6) und auf "ist deren Voraussetzung"
#  (`migrations/_vorlaeufer/README.md`:4).
#
#  Gemessen hält beides der Sache nicht stand:
#    * Der Vorläufer hängt an `tenant` die Bedingung `customer_needs_avv`
#      (:44–47). Die Prüfdatei `pruefungen/migration/M30__pruefung.sql`:31
#      legt sich ihre Ausgangslage selbst und trägt dort den Kunden
#      "Demobank" OHNE `avv_datum`/`avv_aktenzeichen` ein. Mit Vorläufer
#      stirbt die Prüftransaktion an dieser Zeile — VOR dem ersten Prüffall.
#      Keine Summenzeile, keine Meldungszeile, Beleg 2 bis 5 nicht messbar.
#    * "Voraussetzung von M30" trifft nicht zu: M30, M31 und M32 nennen
#      `avv_datum` und `avv_aktenzeichen` an keiner Stelle — nachgezählt,
#      null Treffer. Der Vorläufer fügt zwei Spalten und zwei Bedingungen
#      an `tenant`, mehr nicht.
#    * `n2_lauf.sh` — der gezeichnete Abnahmelauf, dessen fünf Belege dieses
#      Skript über einen weiteren Umfang nachfährt — spielt den Vorläufer
#      GAR NICHT ein. Genau deshalb läuft er durch.
#
#  Die Vorgabe folgt deshalb dem gezeichneten Lauf. Die Prüfumgebung aus
#  `aufbau.sh` bleibt mit `--mit-vorlaeufer` nachbaubar; sie kollidiert dort
#  nicht, weil `seeds/Seed_Welle1_M1-M4.sql` überhaupt keinen Mandanten
#  anlegt (nachgezählt, null `INSERT INTO tenant`).
#
#  ENTSCHIEDEN IST DAMIT NICHTS. Dass Prüfdatei und Vorläufer zusammen nicht
#  laufen, ist ein Befund über zwei je für sich gezeichnete Stände. Ihn
#  aufzulösen hiesse, `pruefungen/` zu ändern — das gehört gezeichnet.
#
#  Zwei bestehende Läufe weichen davon bewusst ab, und dieses Skript
#  gleicht sie NICHT an:
#    * Messstufe 1b — der Prüfschritt `Tor 1b · Migration gegen frische
#      Datenbank` in `.github/workflows/tore.yml` — fährt "DDL +
#      migrations/*.sql, OHNE Vorlaeufer und OHNE Seed" (`aufbau.sh`:16–18).
#    * `n2_lauf.sh` fährt den Vorläufer gar nicht (:105–119, :128, :140).
#  Wer die Belege dieses Skripts mit denen von Messstufe 1b vergleicht,
#  vergleicht deshalb zwei verschieden aufgebaute Datenbanken.
#
#  DER VORLÄUFER IST NICHT WIEDERHOLBAR. `260801_tenant.sql` fügt Spalten
#  mit `ALTER TABLE … ADD COLUMN` ohne `IF NOT EXISTS` hinzu; ein zweiter
#  Lauf scheitert. Deshalb wird er — wie das Grundschema — nur auf einer
#  leeren Datenbank eingespielt und sonst übersprungen. Der Nachweis
#  vermerkt, welcher der beiden Fälle vorlag.
#
#  ---------------------------------------------------------------------
#  WIE DIESER LAUF PRÜFT, DASS DER ERSTE LAUF WIRKLICH DER ERSTE IST
#  ---------------------------------------------------------------------
#  BERICHTIGT AM 22.08.2026. Anlass ist ein gemessener Befund aus der
#  Gegenprüfung des Fremdmodell-Laufs (unten als P0-1 geführt): Beleg 1
#  meldete auf einer BEREITS MIGRIERTEN Datenbank "bestanden". Der
#  Frischetest fragte nur nach dem Grundschema — ob die Migrationen schon
#  lagen, prüfte niemand —, und es gab keinen Abzug VOR Lauf 1. Bewiesen
#  war damit allein, dass Lauf n+1 dasselbe Ergebnis hat wie Lauf n+2.
#  Genau der grüne Lauf, der nichts gemessen hat, den `CLAUDE.md`
#  Abschnitt 6 verbietet.
#
#  Seitdem stehen zwei Riegel, und Beleg 1 gilt erst als bestanden, wenn
#  BEIDE Hälften stimmen: Lauf 1 verändert etwas, Lauf 2 verändert nichts.
#
#  1 · FRISCHETEST MIT MERKMAL JE MIGRATION (Beleg 0)
#      Zu jeder Migration, die gefahren werden soll, ist ein Merkmal
#      hinterlegt: ein Objekt in der Datenbank, das es NACH ihrem Lauf
#      gibt und vorher nicht. Findet der Lauf eines davon vor, ist die
#      Datenbank nicht frisch — dann bricht er ab und nennt die
#      Migration und ihr Merkmal.
#
#        M30 · die Versionstabelle `schema_migration` (M30:83)
#        M31 · die Spalte `fit_check.zweck_verbotene_praktik` (M31:108)
#        M32 · die Funktion `rls_erzwungen()` (M32:60)
#        Vorläufer 260801 · die Spalte `tenant.avv_datum` (dort :34)
#
#      Alle vier Merkmale werden im Systemkatalog von PostgreSQL
#      nachgesehen (`pg_class`, `pg_attribute`, `pg_proc`). Der Lauf
#      liest dafür keine Anwendungstabelle an und braucht kein Recht,
#      das ein Administratorkonto eines Azure Flexible Server nicht hat.
#
#      KOMMT EINE MIGRATION HINZU, ohne dass ein Merkmal hinterlegt ist,
#      bricht der Lauf ebenfalls ab — er misst dann lieber nicht, als
#      ungeprüft grün zu melden. Das Merkmal wird entweder in der
#      Tabelle `merkmal_zeilen()` weiter unten in dieser Datei ergänzt
#      oder, ohne diese Datei anzufassen, in
#      `migrations/frischetest_merkmale.tsv` — eine Zeile je Migration,
#      drei Felder, durch Tabulator getrennt:
#
#        <Dateiname>  <Merkmal im Klartext>  <SQL, das 0 oder mehr zählt>
#
#      Die Datei ist freiwillig; fehlt sie, gilt allein die Tabelle in
#      dieser Datei. Zeilen, die mit `#` beginnen, werden überlesen. Nennt
#      die Datei einen Dateinamen, der auch in der Tabelle steht, gilt die
#      Datei — sie kann ein Merkmal also nicht nur ergänzen, sondern auch
#      ersetzen. Wer sie einsetzt, legt sie zum Nachweis mit ab.
#
#  2 · ABZUG VOR LAUF 1 UND EIN DRITTER VERGLEICH (Beleg 1)
#      Vor der ersten Migration entstehen `schema_vor.sql` und
#      `daten_vor.sql` — mit denselben Filtern wie die Abzüge danach.
#      Verglichen wird deshalb dreimal:
#
#        vor  ↔ nach Lauf 1   MUSS Unterschiede zeigen
#                             (`erstlauf_schema_diff.txt`,
#                              `erstlauf_daten_diff.txt`)
#        nach Lauf 1 ↔ nach Lauf 2   darf KEINE zeigen
#                             (`schema_diff.txt`, `daten_diff.txt`)
#
#      Ändert Lauf 1 weder Schema noch Daten, bricht der Lauf ab. Das
#      ist der Auffangriegel für den Fall, dass ein Merkmal fehlt oder
#      danebengreift: er misst die Wirkung statt der Vorbedingung.
# =====================================================================
set -euo pipefail

# ---------------------------------------------------------------------
# 1 · Bedienung einlesen
# ---------------------------------------------------------------------
HIER="$(cd "$(dirname "$0")" && pwd)"
WURZEL="$(cd "$HIER/.." && pwd)"

UMFANG=""
PRUEFSUMMEN="ja"
# Der Vorläufer läuft NUR auf Verlangen. Grund: gemessen am 22.08.2026 gegen
# PostgreSQL 16.13. `260801_tenant.sql` hängt an `tenant` die Bedingung
# `customer_needs_avv` (dort :44-47) -- ein Mandant der Art CUSTOMER braucht
# danach `avv_datum` UND `avv_aktenzeichen`. Die Prüfdatei
# `pruefungen/migration/M30__pruefung.sql`:31 legt sich ihre Ausgangslage
# aber selbst und trägt dort den Kunden "Demobank" OHNE diese beiden Angaben
# ein. Mit Vorläufer stirbt deshalb die ganze Prüftransaktion an der ersten
# Einfügung -- vor dem ersten Prüffall. Ergebnis: keine Summenzeile, keine
# Meldungszeile, Beleg 2 bis 5 nicht messbar.
#
# KEINE Migration ist daran schuld, und die Prüfdatei auch nicht:
#   * M30, M31 und M32 nennen avv_datum/avv_aktenzeichen an keiner Stelle --
#     nachgezählt, null Treffer. Der Vorläufer ist für sie keine Voraussetzung,
#     obwohl `migrations/_vorlaeufer/README.md`:4 das behauptet.
#   * `n2_lauf.sh` -- der gezeichnete Abnahmelauf, dessen fünf Belege dieses
#     Skript über einen weiteren Umfang nachfährt -- spielt den Vorläufer
#     GAR NICHT ein (null Treffer auf "vorlaeufer" in der Datei). Genau
#     deshalb läuft er durch.
# Die Vorgabe folgt daher dem gezeichneten Lauf. Wer die Prüfumgebung aus
# `aufbau.sh` nachbauen will, schaltet den Vorläufer mit --mit-vorlaeufer zu;
# der Nachweis hält dann fest, dass er lief.
MIT_VORLAEUFER="nein"
STELLUNG=()

hilfe() {
  cat <<'HILFE'
FREIRAUM · Kettenlauf — die fünf Belege über einen wählbaren Umfang

  bash migrations/kettenlauf.sh --umfang <m30|alle> "<verbindung>" [zielordner]

  --umfang m30         nur M30__pilot_sammelmigration.sql (Lesart A)
  --umfang alle        alle migrations/*.sql in lexikalischer Reihenfolge (Lesart B)
  --ohne-pruefsummen   mitgelieferte Eingänge nicht gegen ihre .sha256 nachrechnen
  --mit-vorlaeufer     zusätzlich migrations/_vorlaeufer/260801_tenant.sql
                       einspielen (Aufbau wie die Prüfumgebung aus aufbau.sh).
                       VORGABE IST AUS: der Vorläufer setzt customer_needs_avv
                       und macht damit die Ausgangslage der Prüfdatei ungültig
                       -- Beleg 2 ist dann nicht messbar. Gemessen 22.08.2026.
  --hilfe              diese Übersicht

  Beispiel für eine Azure-Zielumgebung (TLS ist dort Pflicht):

    PGPASSWORD='⟨Kennwort⟩' bash migrations/kettenlauf.sh --umfang alle \
      "host=freiraum-pilot.postgres.database.azure.com port=5432 \
       dbname=freiraum user=frxadm sslmode=require"

  Der vollständige Kopf dieses Skripts erklärt jeden Beleg und den
  ungezeichneten offenen Punkt zum Umfang von M1.
HILFE
}

while [ $# -gt 0 ]; do
  case "$1" in
    --umfang)
      if [ $# -lt 2 ]; then
        echo "ABBRUCH: Zu \"--umfang\" fehlt der Wert."
        echo "         Zulässig sind genau zwei Werte: m30 (Lesart A) und alle (Lesart B)."
        echo "         Nächster Schritt: --umfang m30 oder --umfang alle angeben."
        exit 2
      fi
      UMFANG="$2"; shift 2 ;;
    --umfang=*)          UMFANG="${1#--umfang=}"; shift ;;
    --ohne-pruefsummen)  PRUEFSUMMEN="nein"; shift ;;
    --mit-vorlaeufer)    MIT_VORLAEUFER="ja"; shift ;;
    --hilfe|-h|--help)   hilfe; exit 0 ;;
    --*)
      echo "ABBRUCH: unbekannte Angabe \"$1\"."
      echo "         Bekannt sind --umfang, --ohne-pruefsummen, --mit-vorlaeufer und --hilfe."
      echo "         Nächster Schritt: bash migrations/kettenlauf.sh --hilfe"
      exit 2 ;;
    *)                   STELLUNG+=("$1"); shift ;;
  esac
done

# Ohne Umfang wird NICHT gemessen. Die Frage ist ungezeichnet; ein
# stillschweigend gesetzter Vorgabewert wäre die Entscheidung, die dieses
# Skript nicht treffen darf.
if [ -z "$UMFANG" ]; then
  cat <<'OFFEN'
ABBRUCH: Der Umfang von M1 ist nicht angegeben — und er ist ungezeichnet.

  M1 ist der erste Meilenstein der Lieferung: die Sammelmigration ist im
  Zielbestand eingespielt, und ein zweiter Lauf ändert nichts.

  Woran es liegt: Dieses Skript nimmt den Umfang nicht selbst an. Die
  beiden Lesarten und die Wahlkästchen stehen in
  arbeit/Vorlagen/m1_startklar_260820.md:98-100, die Zeichnungszeile
  "2 | Umfang von M1: | A · B · anders" in derselben Datei:119, die
  Unterschriftszeilen A. Han / M. Veil in derselben Datei:143-144.

  Stand 22.08.2026: In :119 steht ein Kreuz bei B und :144 trägt bei
  M. Veil ein Datum. Nachgesehen, nicht bestätigt — dieses Skript kennt
  die Weisung nicht aus erster Hand und liest sich seine Zeichnung nicht
  selbst aus einer Datei. A. Han hat nicht gegengezeichnet (:143 leer).

    Lesart A  M1 meint M30 allein. Der Prüflauf meldet dann 108 von 111
              und dieser Lauf bricht in Beleg 2 ab.
    Lesart B  M1 meint den Stand, auf dem die Anwendung läuft, also
              M30 + M31 + M32. Der Prüflauf meldet dann 111 von 111.

  Dieses Skript entscheidet die Frage nicht. Es fährt, was ihm gesagt
  wird, und schreibt in den Nachweis, was gefahren wurde.

  Nächster Schritt: den Umfang benennen —
    bash migrations/kettenlauf.sh --umfang m30  "<verbindung>"
    bash migrations/kettenlauf.sh --umfang alle "<verbindung>"
OFFEN
  exit 2
fi

case "$UMFANG" in
  m30)  UMFANG_KLARTEXT="nur M30 (Lesart A)" ;;
  alle) UMFANG_KLARTEXT="alle Dateien aus migrations/*.sql (Lesart B)" ;;
  *)
    echo "ABBRUCH: \"$UMFANG\" ist kein bekannter Umfang."
    echo "         Zulässig sind genau zwei Werte: m30 (Lesart A) und alle (Lesart B)."
    echo "         Grundlage: arbeit/Vorlagen/m1_startklar_260820.md:98-100"
    echo "         Nächster Schritt: --umfang m30 oder --umfang alle angeben."
    exit 2 ;;
esac

if [ "${#STELLUNG[@]}" -eq 0 ]; then
  echo "ABBRUCH: Die Verbindung zur Datenbank fehlt."
  echo "         Sie ist das erste Stellungsargument, als psql-Freitext."
  echo "         Nächster Schritt, Beispiel für eine Azure-Zielumgebung:"
  echo "           PGPASSWORD='⟨Kennwort⟩' bash migrations/kettenlauf.sh --umfang $UMFANG \\"
  echo "             \"host=… port=5432 dbname=freiraum user=… sslmode=require\""
  exit 2
fi

VERBINDUNG="${STELLUNG[0]}"
STAND="$(date +%y%m%d_%H%M)"
ZIEL="${STELLUNG[1]:-$HIER/../nachweise/kettenlauf/${STAND}_${UMFANG}}"

# ---------------------------------------------------------------------
# 2 · Verbindung zerlegen — Wirt für den Nachweis, Kennwort für die Probe
# ---------------------------------------------------------------------
# Der Nachweis nennt Wirt, Port, Datenbank und Konto, damit nachvollziehbar
# ist, wogegen gemessen wurde. Das Kennwort wird ausschliesslich in einer
# Variablen gehalten, nie ausgegeben und nie in eine Datei geschrieben --
# es dient nur der Gegenprobe am Ende (K23-D09).
GEHEIM=""
WIRT_ANGABE=""

schluessel_aus_verbindung() {   # $1 = Schlüsselwort, z. B. host
  printf '%s' "$VERBINDUNG" \
    | grep -oE "(^|[[:space:]])$1=[^[:space:]]+" \
    | tail -1 \
    | sed -E "s/^[[:space:]]*$1=//" || true
}

verbindung_zerlegen() {
  if printf '%s' "$VERBINDUNG" | grep -qE '^postgres(ql)?://'; then
    # URI-Form: postgresql://konto:kennwort@wirt:port/datenbank?sslmode=require
    local rest anmeldung ort konto
    rest="${VERBINDUNG#*://}"
    anmeldung=""
    ort="$rest"
    if [ "${rest#*@}" != "$rest" ]; then
      anmeldung="${rest%%@*}"
      ort="${rest#*@}"
    fi
    konto="${anmeldung%%:*}"
    if [ "${anmeldung#*:}" != "$anmeldung" ]; then
      GEHEIM="${anmeldung#*:}"
    fi
    WIRT_ANGABE="Wirt und Datenbank: ${ort%%\?*} · Konto: ${konto:-⟨aus der Umgebung⟩}"
  else
    local h p d u s
    h="$(schluessel_aus_verbindung host)"
    p="$(schluessel_aus_verbindung port)"
    d="$(schluessel_aus_verbindung dbname)"
    u="$(schluessel_aus_verbindung user)"
    s="$(schluessel_aus_verbindung sslmode)"
    GEHEIM="$(schluessel_aus_verbindung password)"
    WIRT_ANGABE="Wirt: ${h:-⟨aus der Umgebung⟩} · Port: ${p:-⟨Vorgabe 5432⟩}"
    WIRT_ANGABE="$WIRT_ANGABE · Datenbank: ${d:-⟨aus der Umgebung⟩}"
    WIRT_ANGABE="$WIRT_ANGABE · Konto: ${u:-⟨aus der Umgebung⟩}"
    WIRT_ANGABE="$WIRT_ANGABE · sslmode: ${s:-⟨nicht angegeben⟩}"
  fi
}
verbindung_zerlegen

# ---------------------------------------------------------------------
# 3 · Eingänge feststellen
# ---------------------------------------------------------------------
GRUND="${GRUND_DATEI:-$WURZEL/schema/freiraum_datamodel.sql}"
VORLAEUFER="${VORLAEUFER_DATEI:-$WURZEL/migrations/_vorlaeufer/260801_tenant.sql}"
TST="${TST_DATEI:-$WURZEL/pruefungen/migration/M30__pruefung.sql}"
ALT="${ALT_DATEI:-$WURZEL/schema/pruefung_v2.9.sql}"
# Die Klammer um die Prüfdatei. NEU AM 22.08.2026, Behebung von P0-3:
# `$ALT` legt sich ihre Ausgangslage selbst an und räumt sie nicht ab.
# `migrations/_werkzeug/pruefklammer.sql` fährt sie in BEGIN … ROLLBACK, ohne die
# Prüfdatei anzufassen. Der Kopf jener Datei erklärt das im Einzelnen.
#
# Sie liegt bewusst im UNTERORDNER `_werkzeug/` und nicht direkt in
# `migrations/`: das Suchmuster `migrations/*.sql` unten und in
# `.github/workflows/tore.yml`:330, :360 und :447 fasst alles, was direkt
# dort liegt, als MIGRATION auf. Eine Klammerdatei in `migrations/` würde
# vom Umfang `alle` eingespielt. Unterordner fasst der Glob nicht -- aus
# demselben Grund tragen `_vorlaeufer/` und `_abgeloest/` einen Unterstrich.
KLAMMER="${KLAMMER_DATEI:-$WURZEL/migrations/_werkzeug/pruefklammer.sql}"

# Die Migrationen des gewählten Umfangs, in der Reihenfolge, in der sie
# eingespielt werden. `alle` bildet den Glob aus
# .github/workflows/tore.yml:330 nach: `migrations/*.sql`. Der Glob fasst
# KEINE Unterordner -- _vorlaeufer/, _abgeloest/, negativfaelle/ und
# uebernahme/ bleiben aussen vor, und das ist so gewollt.
MIGRATIONEN=()
case "$UMFANG" in
  m30)
    MIGRATIONEN=("$WURZEL/migrations/M30__pilot_sammelmigration.sql")
    ;;
  alle)
    for m in "$WURZEL"/migrations/*.sql; do
      [ -e "$m" ] || continue
      MIGRATIONEN+=("$m")
    done
    ;;
esac

if [ "${#MIGRATIONEN[@]}" -eq 0 ]; then
  echo "ABBRUCH: Zum Umfang \"$UMFANG\" wurde keine einzige Migration gefunden."
  echo "         Gesucht wurde in: $WURZEL/migrations/"
  echo "         Nächster Schritt: prüfen, ob das Repository vollständig ausgecheckt ist."
  exit 1
fi

PFLICHT_EINGAENGE=("$GRUND" "$TST" "$ALT" "$KLAMMER" "${MIGRATIONEN[@]}")
[ "$MIT_VORLAEUFER" = "ja" ] && PFLICHT_EINGAENGE+=("$VORLAEUFER")
for datei in "${PFLICHT_EINGAENGE[@]}"; do
  if [ ! -f "$datei" ]; then
    echo "ABBRUCH: Eingang nicht gefunden: $datei"
    echo "         Ohne diese Datei kann der Kettenlauf nicht messen."
    echo "         Nächster Schritt: die Datei bereitstellen oder den Pfad über"
    echo "         GRUND_DATEI=, VORLAEUFER_DATEI=, TST_DATEI=, ALT_DATEI= bzw."
    echo "         KLAMMER_DATEI= setzen."
    exit 1
  fi
done

# Prüfsummen der mitgelieferten Kopien. Weicht eine ab, ist die KOPIE
# ungültig -- nicht das Original (schema/README.md, Änderungsregel
# "keine"). Formatunabhängig gelesen wie in `aufbau.sh`:65 und :92: die älteren
# .sha256-Dateien führen nur den nackten Hash, die neueren das
# shasum-Format "<hash>  <datei>".
pruefe_eingang() {
  local datei="$1" summendatei="${1%.sql}.sha256" soll ist
  [ -f "$summendatei" ] || return 0
  soll="$(grep -oE '[0-9a-f]{64}' "$summendatei" | head -1)"
  ist="$(shasum -a 256 "$datei" | cut -d' ' -f1)"
  if [ "$soll" != "$ist" ]; then
    echo "ABBRUCH: Prüfsumme weicht ab: $datei"
    echo "         erwartet: $soll"
    echo "         gemessen: $ist"
    echo "         Die Kopie ist ungültig -- nicht das Original."
    echo "         Nächster Schritt: die Kopie aus dem Original erneuern und den"
    echo "         Befund melden; die Prüfsumme wird NICHT nachgezogen."
    exit 1
  fi
}
if [ "$PRUEFSUMMEN" = "ja" ]; then
  SUMMEN_EINGAENGE=("$GRUND" "${MIGRATIONEN[@]}")
  [ "$MIT_VORLAEUFER" = "ja" ] && SUMMEN_EINGAENGE+=("$VORLAEUFER")
  for datei in "${SUMMEN_EINGAENGE[@]}"; do pruefe_eingang "$datei"; done
fi

mkdir -p "$ZIEL"
ZUSTAENDE="$ZIEL/belege_zustand.tsv"
: > "$ZUSTAENDE"
EINGESPIELT=()

# ---------------------------------------------------------------------
# 4 · Hilfsmittel
# ---------------------------------------------------------------------
sagen() { printf '\n=== %s ===\n' "$1"; }

# ON_ERROR_STOP=1 für JEDEN psql-Aufruf, auch für die Prüffälle. Beide
# Prüfdateien fangen ihre Ausnahmen selbst ab -- M30__pruefung.sql in
# DO-Blöcken, pruefung_v2.9.sql über Sicherungspunkte -- und laufen
# darunter sauber durch. Gemessen am 05.08.2026, festgehalten im Kopf von
# migrations/n2_lauf.sh:87-98.
P() { psql "$VERBINDUNG" -v ON_ERROR_STOP=1 "$@"; }

# Ein Zustand je Beleg, aus genau vier zulässigen Werten (K23-M22).
# "gesperrt" heisst: es konnte nicht gemessen werden -- nie "bestanden".
zustand() {   # $1 Nummer  $2 Name  $3 Zustand  $4 Ergebnis  $5 Beleg
  printf '%s\t%s\t%s\t%s\t%s\n' "$1" "$2" "$3" "$4" "$5" >> "$ZUSTAENDE"
}

lauf_pruefen() {
  local rc="$1" log="$2" was="$3"
  printf '%s: psql-Rückgabewert %s\n' "$was" "$rc" | tee -a "$ZIEL/rueckgabewerte.txt"
  if [ "$rc" -ne 0 ]; then
    abbruch "$was endete mit Rückgabewert $rc." "siehe $log"
  fi
}

# Ein Abbruch sagt drei Dinge: was nicht ging, woran es lag, was jetzt zu
# tun ist. Stumm abbrechen ist der schlimmste Fall -- genau daran ist
# dieser Harness schon einmal aufgelaufen (Befund BEF-D3).
abbruch() {
  echo "ABBRUCH: $1"
  shift
  local zeile
  for zeile in "$@"; do echo "         $zeile"; done
  exit 1
}

# ---------------------------------------------------------------------
# 4a · Merkmal je Migration — woran der Frischetest sie wiedererkennt
# ---------------------------------------------------------------------
# NEU AM 22.08.2026, Behebung von P0-1. Bis dahin fragte der Frischetest
# allein nach dem Grundschema (Typ `retention_class`). Auf einer bereits
# migrierten Datenbank hiess das: Grundschema überspringen, Migration
# zweimal fahren, beide Male ohne Wirkung, beide diffs leer -- und Beleg 1
# meldete "bestanden". Gemessen wurde dabei nichts.
#
# Ein Merkmal ist ein Objekt in der Datenbank, das es NACH dem Lauf einer
# Migration gibt und vorher nicht. Alle vier stehen im Systemkatalog von
# PostgreSQL; der Lauf liest dafür keine Anwendungstabelle an und braucht
# kein Recht, das ein Administratorkonto eines Azure Flexible Server nicht
# hat. Ein Merkmal, das eine Anwendungstabelle abfragt, wäre auf einer
# Datenbank mit Zeilenschutz nicht verlässlich zu messen.
#
# Drei Felder je Zeile, durch TABULATOR getrennt:
#   1 Dateiname der Migration (ohne Pfad)
#   2 das Merkmal im Klartext -- es steht so in der Abbruchmeldung
#   3 SQL, das eine Zahl liefert: 0 = Migration liegt noch nicht
MERKMAL_DATEI="${MERKMAL_DATEI:-$WURZEL/migrations/frischetest_merkmale.tsv}"

merkmal_zeilen() {
  cat <<'MERKMALE'
M30__pilot_sammelmigration.sql	die Versionstabelle schema_migration (M30:83)	SELECT count(*) FROM pg_class c JOIN pg_namespace n ON n.oid=c.relnamespace WHERE n.nspname='public' AND c.relname='schema_migration' AND c.relkind='r'
M31__projektnummer_und_zweckbestimmung.sql	die Spalte fit_check.zweck_verbotene_praktik (M31:108)	SELECT count(*) FROM pg_attribute a JOIN pg_class c ON c.oid=a.attrelid JOIN pg_namespace n ON n.oid=c.relnamespace WHERE n.nspname='public' AND c.relname='fit_check' AND a.attname='zweck_verbotene_praktik' AND NOT a.attisdropped
M32__zeilenschutz_und_stufenwechsel.sql	die Funktion rls_erzwungen() (M32:60)	SELECT count(*) FROM pg_proc p JOIN pg_namespace n ON n.oid=p.pronamespace WHERE n.nspname='public' AND p.proname='rls_erzwungen'
260801_tenant.sql	die Spalte tenant.avv_datum (Vorläufer 260801:34)	SELECT count(*) FROM pg_attribute a JOIN pg_class c ON c.oid=a.attrelid JOIN pg_namespace n ON n.oid=c.relnamespace WHERE n.nspname='public' AND c.relname='tenant' AND a.attname='avv_datum' AND NOT a.attisdropped
MERKMALE
  # Nachtrag aus der Datei -- damit eine neue Migration ein Merkmal
  # bekommt, ohne dass dieses Skript geändert werden muss. Die Datei
  # steht HINTER der Tabelle, `merkmal_von` nimmt den letzten Treffer:
  # eine Zeile aus der Datei ersetzt also eine gleichnamige aus der
  # Tabelle.
  if [ -f "$MERKMAL_DATEI" ]; then
    grep -vE '^[[:space:]]*(#|$)' "$MERKMAL_DATEI" || true
  fi
}

MERKMAL_TEXT=""
MERKMAL_SQL=""
merkmal_von() {   # $1 = Dateiname; setzt MERKMAL_TEXT und MERKMAL_SQL
  local datei text sql
  MERKMAL_TEXT=""; MERKMAL_SQL=""
  while IFS=$'\t' read -r datei text sql; do
    [ "$datei" = "$1" ] || continue
    MERKMAL_TEXT="$text"; MERKMAL_SQL="$sql"
  done < <(merkmal_zeilen)
  [ -n "$MERKMAL_SQL" ]
}

# Die zweite Hälfte des Frischetests: liegt eine der Migrationen, die
# gleich gefahren werden sollen, schon in der Datenbank?
frischetest_migrationen() {
  local liste=("${MIGRATIONEN[@]}")
  [ "$MIT_VORLAEUFER" = "ja" ] && liste+=("$VORLAEUFER")
  local m name zahl rc
  for m in "${liste[@]}"; do
    name="$(basename "$m")"
    if ! merkmal_von "$name"; then
      abbruch \
        "Für \"$name\" ist kein Merkmal hinterlegt." \
        "Woran es liegt: Der Frischetest erkennt eine bereits eingespielte" \
        "Migration an einem Merkmal -- einem Objekt, das es nach ihrem Lauf" \
        "gibt und vorher nicht. Für diese Datei kennt er keines und kann" \
        "deshalb nicht messen, ob die Datenbank frisch ist. Ein Lauf, der" \
        "das nicht messen kann, meldet nicht \"bestanden\" (K23-M22 -- die" \
        "Klausel, die je Prüfung genau vier Zustände zulässt: bestanden," \
        "fehlgeschlagen, gesperrt, nicht ausgeführt)." \
        "Nächster Schritt: ein Merkmal ergänzen -- entweder in der Tabelle" \
        "\`merkmal_zeilen()\` in migrations/kettenlauf.sh oder, ohne diese" \
        "Datei anzufassen, als Zeile in $MERKMAL_DATEI." \
        "Drei Felder, durch TABULATOR getrennt:" \
        "  $name<TAB>Merkmal im Klartext<TAB>SELECT count(*) FROM pg_… " \
        "Das SQL liefert 0, solange die Migration nicht eingespielt ist."
    fi
    set +e
    zahl="$(psql "$VERBINDUNG" -tA -c "$MERKMAL_SQL" 2>&1)"
    rc=$?
    set -e
    if [ "$rc" -ne 0 ]; then
      abbruch \
        "Das Merkmal für \"$name\" liess sich nicht abfragen." \
        "Gesucht wurde: $MERKMAL_TEXT" \
        "Meldung der Datenbank: $zahl" \
        "Nächster Schritt: die Verbindung und die Leserechte des Kontos auf" \
        "den Systemkatalog prüfen; ohne diese Abfrage ist der Frischetest" \
        "nicht zu führen."
    fi
    case "$zahl" in
      ''|*[!0-9]*)
        abbruch \
          "Das Merkmal für \"$name\" hat keine Zahl geliefert, sondern: $zahl" \
          "Gesucht wurde: $MERKMAL_TEXT" \
          "Nächster Schritt: das hinterlegte SQL prüfen -- es muss genau" \
          "eine Zahl liefern (0 = Migration liegt noch nicht)." ;;
    esac
    if [ "$zahl" != "0" ]; then
      abbruch \
        "Die Datenbank ist NICHT frisch: \"$name\" ist bereits eingespielt." \
        "Gefunden wurde $MERKMAL_TEXT -- das Merkmal, das es erst nach dem" \
        "Lauf dieser Migration gibt." \
        "Warum das ein Abbruch ist: Auf einer bereits migrierten Datenbank" \
        "verändert der erste Lauf nichts mehr. Beide Läufe wären wirkungslos," \
        "beide Abzüge gleich, und Beleg 1 meldete \"bestanden\", ohne etwas" \
        "gemessen zu haben. Bewiesen wäre allein, dass Lauf n+1 dasselbe" \
        "Ergebnis hat wie Lauf n+2 -- nicht, dass die Migration einspielbar" \
        "und wiederholbar ist. Das ist Befund P0-1 vom 22.08.2026." \
        "Nächster Schritt: gegen eine FRISCHE Datenbank fahren. Nach der" \
        "Betriebsregel \"eigene Datenbank je Pilot-Anlauf\" (CLAUDE.md" \
        "Abschnitt 5) wird dafür eine neue Datenbank angelegt, nicht die" \
        "vorhandene geleert -- gelöscht wird nach F36 nichts." \
        "Soll nur nachgesehen werden, was in der vorhandenen Datenbank" \
        "steht, ist dieser Lauf das falsche Werkzeug: er misst einen" \
        "Erstlauf, keinen Bestand."
    fi
    echo "  · $name: noch nicht eingespielt ($MERKMAL_TEXT nicht gefunden)"
  done
  echo "Frischetest bestanden: keine der ${#liste[@]} zu fahrenden Dateien liegt bereits."
}

# Der Umgebungsnachweis. NEU AM 23.08.2026.
#
# Das Fremdmodell konnte am 22.08.2026 drei Dinge NICHT beurteilen, weil
# der Lauf sie nirgends aufgeschrieben hat: gegen WELCHE Datenbank er
# lief, MIT WELCHEN Rechten, und WIE genau die Abzüge gezogen wurden.
# Alle drei sind messbar, und keines davon kostet mehr als eine Abfrage.
#
# Diese Funktion misst die ersten beiden. Die dritte schreibt
# `abzug_nehmen` mit, sobald sie pg_dump aufruft.
#
# WARUM DAS KEIN BELEG IST: Ein Beleg trägt einen der vier Zustände aus
# K23-M22 und beweist eine Aussage aus M1. Diese Datei beweist keine --
# sie hält fest, unter welchen Bedingungen die anderen fünf gemessen
# wurden. Sie ersetzt deshalb auch nicht die Zeile "War es die
# Zielumgebung?" im Nachweis: was der Server über sich sagt, ist eine
# Messung; ob das die GEMEINTE Umgebung war, weiss nur ein Mensch.
#
# KEIN ABBRUCH bei Fehlschlag: ein Abnahmelauf endet nicht daran, dass
# eine Zusatzabfrage scheitert. Der Fehlschlag steht dann aber im Klartext
# in der Datei, und der Nachweis zeigt darauf.
umgebung_festhalten() {
  local ziel="$ZIEL/umgebung.txt" rc
  # Zwei Fallen, beide beim Fahren aufgeschlagen und deshalb hier notiert:
  #
  # 1. EIN E-Literal, nicht neun aneinandergereihte. PostgreSQL setzt
  #    benachbarte Zeichenketten über einen Zeilenumbruch hinweg zwar
  #    zusammen -- aber nicht, wenn jede ihr eigenes E-Präfix trägt.
  # 2. KEIN doppeltes Anführungszeichen in der Abfrage. Sie steht in einem
  #    doppelt gequoteten Argument; ein solches Zeichen beendet es, und
  #    psql bekommt den Rest als lose Wörter serviert.
  set +e
  psql "$VERBINDUNG" -tA -c "
SELECT format(
  E'Datenbank:       %s\nAngemeldet als:  %s   (Sitzungskonto: %s)\nServer:          %s   Port %s\nFassung:         %s\nSUPERUSER:       %s\nBYPASSRLS:       %s\nCREATEDB:        %s\nCREATEROLE:      %s\nVerschlüsselt:   %s',
  current_database(), current_user, session_user,
  coalesce(host(inet_server_addr()), '⟨lokaler Sockel⟩'),
  coalesce(inet_server_port()::text, '—'),
  version(),
  (SELECT rolsuper      FROM pg_roles WHERE rolname = current_user),
  (SELECT rolbypassrls  FROM pg_roles WHERE rolname = current_user),
  (SELECT rolcreatedb   FROM pg_roles WHERE rolname = current_user),
  (SELECT rolcreaterole FROM pg_roles WHERE rolname = current_user),
  coalesce((SELECT ssl::text FROM pg_stat_ssl WHERE pid = pg_backend_pid()),
           '⟨unbekannt⟩')
)" > "$ziel" 2>&1
  rc=$?
  set -e
  if [ "$rc" -ne 0 ]; then
    {
      echo
      echo "NICHT GEMESSEN: Die Abfrage endete mit Rückgabewert $rc."
      echo "Der Lauf ist deshalb nicht abgebrochen -- aber die Bedingungen,"
      echo "unter denen die fünf Belege entstanden sind, sind hier nicht belegt."
    } >> "$ziel"
    echo "WARNUNG: Umgebungsnachweis nicht gemessen (Rückgabewert $rc), siehe $ziel"
    return 0
  fi
  echo "Umgebung festgehalten:"
  sed 's/^/  /' "$ziel"
}

# ---------------------------------------------------------------------
# 5 · Der Abschluss — er läuft auch nach einem Abbruch
# ---------------------------------------------------------------------
# Ein Lauf, der auf halber Strecke endet, hinterlässt trotzdem einen
# Nachweis: die gemessenen Belege als "bestanden", der abbrechende als
# "fehlgeschlagen", die folgenden als "nicht ausgeführt". Ein Blatt, das
# nur bei Erfolg entsteht, verschweigt genau die Läufe, über die zu reden
# wäre.
BELEG_NAMEN=(
  "0|Grundschema und Vorläufer"
  "1|Lauf 1 verändert etwas, Lauf 2 verändert nichts"
  "2|Prüffälle"
  "3|Gegentest-Meldungen einzeln festgehalten"
  "4|Eingefrorene Prüffälle T0 bis T23"
  "5|Objektzahlen gemessen"
)
ABSCHLUSS_GELAUFEN="nein"

zustand_von() {   # $1 = Belegnummer
  awk -F'\t' -v n="$1" '$1==n {print $3; gefunden=1} END {if (!gefunden) print ""}' "$ZUSTAENDE" | head -1
}
ergebnis_von() {
  awk -F'\t' -v n="$1" '$1==n {print $4} END {}' "$ZUSTAENDE" | head -1
}
belegdatei_von() {
  awk -F'\t' -v n="$1" '$1==n {print $5} END {}' "$ZUSTAENDE" | head -1
}

# Die Gegenprobe zu K23-D09: kein Beleg, kein Protokoll und kein Nachweis
# darf das Kennwort tragen. Bewusst OHNE grep: ein `grep -F -- "$kennwort"`
# stellt den Wert in die Prozessliste des Rechners und macht ihn dort für
# jeden Mitbenutzer lesbar. Der Vergleich bleibt deshalb in der Shell.
kennwort_probe() {
  local kennwort inhalt datei fund=0 betroffen=()
  for kennwort in "$GEHEIM" "${PGPASSWORD:-}"; do
    [ -n "$kennwort" ] || continue
    while IFS= read -r datei; do
      inhalt="$(cat "$datei" 2>/dev/null || true)"
      case "$inhalt" in
        *"$kennwort"*) betroffen+=("$datei"); fund=1 ;;
      esac
    done < <(find "$ZIEL" -type f)
  done
  if [ "$fund" -eq 0 ]; then
    echo "Gegenprobe bestanden: in keinem Beleg steht ein Zugangswert im Klartext."
  else
    echo "ABBRUCH: In mindestens einem Beleg steht ein Zugangswert im Klartext."
    echo "         Das verstösst gegen K23-D09 -- die Klausel, die verbietet,"
    echo "         Geheimnisse in Protokoll, Manifest oder Nachweis zu schreiben."
    echo "         Betroffen sind diese Dateien:"
    printf '           %s\n' "${betroffen[@]}" | sort -u
    echo
    echo "         PRÜFEN SIE DEN FUND, BEVOR SIE HANDELN. Dieser Vergleich sucht"
    echo "         die Zeichenkette, sonst nichts. Ist der Zugangswert selbst ein"
    echo "         Wort, das im Bestand vorkommt, schlägt er auch ohne jedes Leck"
    echo "         an -- gemessen am 22.08.2026 mit dem Wert \"pilot\", der in"
    echo "         \"M30__pilot_sammelmigration.sql\" und in der Fassungskennung"
    echo "         \"v3.0-pilot-01\" steckt. Der Riegel wird deshalb NICHT"
    echo "         gelockert; er meldet lieber zu viel als zu wenig."
    echo "         Die Fundstellen stehen unmaskiert NUR am Bildschirm, nie in"
    echo "         einer Datei -- sonst schriebe die Gegenprobe selbst hinein,"
    echo "         wogegen sie gerichtet ist."
    echo "         Nächster Schritt: den Belegordner NICHT weitergeben und löschen,"
    echo "         dann den Lauf wiederholen -- mit PGPASSWORD statt password= im"
    echo "         Verbindungstext. Der Nachweis dieses Laufes ist nicht verwendbar."
  fi
  return "$fund"
}

nachweis_schreiben() {   # $1 = Gesamtvermerk
  local gesamt="$1" eintrag nr name z e b tabelle="" summen="" datei h
  for eintrag in "${BELEG_NAMEN[@]}"; do
    nr="${eintrag%%|*}"
    name="${eintrag#*|}"
    z="$(zustand_von "$nr")"
    [ -n "$z" ] || z="nicht ausgeführt"
    e="$(ergebnis_von "$nr")"
    [ -n "$e" ] || e="—"
    b="$(belegdatei_von "$nr")"
    [ -n "$b" ] || b="—"
    tabelle="$tabelle| $nr | $name | **$z** | $e | $b |"$'\n'
  done
  for datei in "${EINGESPIELT[@]}"; do
    h="$(shasum -a 256 "$datei" | cut -d' ' -f1)"
    summen="$summen| \`$(basename "$datei")\` | \`$h\` |"$'\n'
  done
  [ -n "$summen" ] || summen="| — | es wurde keine Datei eingespielt |"$'\n'

  cat > "$ZIEL/NACHWEIS.md" <<NACHWEIS
# FREIRAUM · Kettenlauf — Nachweis $gesamt

Dieses Blatt trägt Messwerte, keine Unterschrift. Es entsteht aus
\`migrations/kettenlauf.sh\`. Wer zeichnet, entscheidet ein Mensch.

## Was gefahren wurde

| Feld | Wert |
|---|---|
| Lauf am | $(date '+%d.%m.%Y %H:%M') |
| Umfang | \`--umfang $UMFANG\` — $UMFANG_KLARTEXT |
| Vorläufer 260801 eingespielt | $([ "$MIT_VORLAEUFER" = "ja" ] && echo "**ja** — mit \`--mit-vorlaeufer\`; Aufbau wie die Prüfumgebung aus \`aufbau.sh\`" || echo "nein — wie im gezeichneten Lauf \`n2_lauf.sh\`") |
| Verbindung | $WIRT_ANGABE |
| Was der Server über sich sagt | \`umgebung.txt\` — Datenbank, Konto, Rechte, Fassung, Verschlüsselung |
| Wie die Abzüge gezogen wurden | \`pg_dump_aufrufe.txt\` — Fassung und beide Aufrufzeilen je Lauf |
| War es die Zielumgebung? | **VON DER ZEICHNENDEN PERSON EINZUTRAGEN** — \`umgebung.txt\` sagt, *welche* Datenbank geantwortet hat; ob das die gemeinte war, sagt sie nicht |
| Prüfsummen der Eingänge nachgerechnet | $([ "$PRUEFSUMMEN" = "ja" ] && echo "ja" || echo "**nein** — mit \`--ohne-pruefsummen\` gefahren") |
| Belegordner | \`$ZIEL\` |

> **Den Umfang von M1 hat dieser Lauf nicht entschieden.** Die beiden Lesarten
> stehen in \`arbeit/Vorlagen/m1_startklar_260820.md\`:98–100, die Zeichnungszeile
> in derselben Datei:119, die Unterschriftszeilen in derselben Datei:143–144.
> Der Lauf hat gefahren, was ihm über \`--umfang\` gesagt wurde, und schreibt es
> hier auf. Ob der gefahrene Umfang der gezeichnete ist, prüft ein Mensch am
> Blatt — nicht dieses Skript.

## Prüfsumme jeder eingespielten Datei

| Datei | SHA-256 |
|---|---|
$summen
## Ergebnis je Beleg

Genau ein Zustand je Beleg, aus vier zulässigen Werten (K23-M22 — die
Klausel, die je Prüfung bestanden, fehlgeschlagen, gesperrt oder nicht
ausgeführt zulässt). Was nicht gemessen werden konnte, heisst *gesperrt*,
nicht *bestanden*.

| | Beleg | Zustand | Ergebnis | Rohbeleg |
|---|---|---|---|---|
$tabelle
## Was dieses Blatt nicht ist

Es ist keine Freigabe, keine Abnahme und keine Zeichnung. Beleg 3 ist zu
**lesen**, nicht zu zählen: die Anzahl der Meldungszeilen sagt nichts
darüber, ob jeder Gegentest an seiner eigenen Bedingung gescheitert ist.

## Wer gezeichnet hat

| Name | Rolle | Datum | Unterschrift |
|---|---|---|---|
| ⟨ ⟩ | für den Auftragnehmer | ⟨ ⟩ | ⟨ ⟩ |
| ⟨ ⟩ | für den Auftraggeber | ⟨ ⟩ | ⟨ ⟩ |
NACHWEIS
}

abschluss() {
  local rc=$?
  [ "$ABSCHLUSS_GELAUFEN" = "nein" ] || exit "$rc"
  ABSCHLUSS_GELAUFEN="ja"
  set +e
  if [ "$rc" -eq 0 ]; then
    nachweis_schreiben "· alle fünf Belege bestanden"
  else
    # Der Beleg, an dem es endete, ist fehlgeschlagen -- nicht gesperrt:
    # gemessen wurde, und die Messung war negativ.
    local eintrag nr
    for eintrag in "${BELEG_NAMEN[@]}"; do
      nr="${eintrag%%|*}"
      if [ -z "$(zustand_von "$nr")" ]; then
        zustand "$nr" "-" "fehlgeschlagen" "Lauf endete hier" "siehe Bildschirmausgabe"
        break
      fi
    done
    nachweis_schreiben "· ABGEBROCHEN"
  fi
  kennwort_probe || rc=1
  echo
  echo "Belege in: $ZIEL"
  echo "Nachweis:  $ZIEL/NACHWEIS.md"
  exit "$rc"
}
trap abschluss EXIT

echo "FREIRAUM · Kettenlauf"
echo "  Umfang:   $UMFANG_KLARTEXT"
echo "  Migrationen in dieser Reihenfolge:"
for m in "${MIGRATIONEN[@]}"; do echo "    · $(basename "$m")"; done
echo "  Verbindung: $WIRT_ANGABE"
echo "  Belege:   $ZIEL"
if [ "$UMFANG" = "m30" ]; then
  echo
  echo "  HINWEIS zu diesem Umfang: M31 ersetzt create_app_after_fit durch eine"
  echo "  Fassung ohne p_project_no. Wird nur M30 gefahren, steht die alte"
  echo "  Fassung -- und MT-95, MT-95b sowie MT-98 scheitern in Beleg 2."
  echo "  Das ist die gemessene Folge von Lesart A, kein Fehler dieses Skripts"
  echo "  (arbeit/Vorlagen/m1_startklar_260820.md:79-84)."
fi

# ---------------------------------------------------------------------
# Beleg 0 · Grundschema und Vorläufer
# ---------------------------------------------------------------------
sagen "Beleg 0 · Grundschema v2.9 und Vorläufer 260801 (Vorbedingung von M30)"
# Idempotent gedacht wie in n2_lauf.sh:106-108: steht der Typ schon, war
# das Grundschema da, und dann wird nichts erneut geladen. Der Vorläufer
# hängt an derselben Bedingung, weil er selbst NICHT wiederholbar ist.
vorhanden="$(psql "$VERBINDUNG" -tA -c "SELECT count(*) FROM pg_type WHERE typname='retention_class'")"

# ZWEITE HÄLFTE DES FRISCHETESTS, neu am 22.08.2026 (Behebung von P0-1).
# Sie läuft VOR jeder Entscheidung über das Grundschema und in beiden
# Fällen -- auch dann, wenn das Grundschema schon steht. Genau das war die
# Lücke: eine Datenbank mit Grundschema UND Migrationen sah aus wie eine
# Datenbank, auf der nur das Grundschema übersprungen wird.
echo "Frischetest: liegt eine der zu fahrenden Migrationen schon in der Datenbank?"
frischetest_migrationen

# Erst hier, nicht früher: vorher steht nicht fest, dass überhaupt gegen
# eine brauchbare Datenbank gefahren wird.
umgebung_festhalten

if [ "$vorhanden" = "0" ]; then
  echo "leere Datenbank -- Grundschema wird geladen: $GRUND"
  set +e
  psql "$VERBINDUNG" -q -v ON_ERROR_STOP=1 -f "$GRUND" 2>&1 | tee "$ZIEL/lauf0_grundschema.log"
  rc=${PIPESTATUS[0]}
  set -e
  [ "$rc" -eq 0 ] || abbruch \
    "Das Grundschema endete mit Rückgabewert $rc." \
    "Ohne Grundschema scheitert schon die erste Anweisung von M30 an" \
    "\`type \"retention_class\" does not exist\`." \
    "Nächster Schritt: $ZIEL/lauf0_grundschema.log lesen."
  EINGESPIELT+=("$GRUND")

  if [ "$MIT_VORLAEUFER" = "ja" ]; then
    echo "Vorläufer wird geladen (auf Verlangen, --mit-vorlaeufer): $VORLAEUFER"
    echo "  ACHTUNG: In dieser Aufstellung ist Beleg 2 nach heutigem Stand NICHT"
    echo "  messbar. Der Vorläufer setzt customer_needs_avv; die Ausgangslage der"
    echo "  Prüfdatei (pruefungen/migration/M30__pruefung.sql:31) verletzt diese"
    echo "  Bedingung. Gemessen am 22.08.2026."
    set +e
    psql "$VERBINDUNG" -q -v ON_ERROR_STOP=1 -f "$VORLAEUFER" 2>&1 | tee "$ZIEL/lauf0_vorlaeufer.log"
    rc=${PIPESTATUS[0]}
    set -e
    [ "$rc" -eq 0 ] || abbruch \
      "Der Vorläufer 260801 endete mit Rückgabewert $rc." \
      "Er scheitert unter anderem an bestehenden Kundenmandanten ohne" \
      "Vertragsnachweis -- das ist gewollt und keine zu lockernde Bedingung." \
      "Nächster Schritt: $ZIEL/lauf0_vorlaeufer.log lesen."
    EINGESPIELT+=("$VORLAEUFER")
    zustand 0 "Grundschema und Vorläufer" "bestanden" \
      "Grundschema und Vorläufer eingespielt (--mit-vorlaeufer)" \
      "\`lauf0_grundschema.log\` · \`lauf0_vorlaeufer.log\`"
  else
    echo "Vorläufer wird NICHT eingespielt -- wie im gezeichneten Lauf n2_lauf.sh."
    echo "  Zuschalten mit --mit-vorlaeufer. Der Kopf dieses Skripts sagt, warum"
    echo "  die Vorgabe so steht und was dann mit Beleg 2 geschieht."
    zustand 0 "Grundschema und Vorläufer" "bestanden" \
      "Grundschema eingespielt; Vorläufer nicht verlangt (wie n2_lauf.sh)" \
      "\`lauf0_grundschema.log\`"
  fi
else
  echo "Grundschema ist bereits vorhanden -- Grundschema und Vorläufer werden übersprungen."
  echo "  Der Vorläufer 260801 ist NICHT wiederholbar (ALTER TABLE … ADD COLUMN"
  echo "  ohne IF NOT EXISTS); ein zweiter Lauf würde scheitern."
  zustand 0 "Grundschema und Vorläufer" "nicht ausgeführt" \
    "Datenbank war nicht leer -- nichts geladen" "—"
fi

# ---------------------------------------------------------------------
# Beleg 1 · Die gewählten Migrationen zweimal, Schema UND Daten vergleichen
# ---------------------------------------------------------------------
sagen "Beleg 1 · Migrationen zweimal, Schema- und Datenvergleich"

# Entrauschen wie in `.github/workflows/tore.yml`:359: pg_dump 16 schreibt
# \restrict/\unrestrict-Zeilen mit einem wechselnden Wert, der zwischen zwei
# Abzügen derselben Datenbank verschieden ist und sonst jeden Vergleich
# scheitern liesse.
# `|| true`, weil grep mit -v den Rückgabewert 1 liefert, sobald keine Zeile
# übrig bleibt. Das wäre unter `set -o pipefail` ein stummer Abbruch. Dass
# wirklich etwas übrig blieb, prüft `abzug_nehmen` danach an der Dateigrösse.
entrausche() { grep -vE "^\\\\(un)?restrict" || true; }

migrationen_einspielen() {   # $1 = Laufnummer
  local nummer="$1" m rc log="$ZIEL/lauf$1.log"
  : > "$log"
  for m in "${MIGRATIONEN[@]}"; do
    echo "  == $(basename "$m")"
    set +e
    psql "$VERBINDUNG" -q -v ON_ERROR_STOP=1 -f "$m" 2>&1 | tee -a "$log"
    rc=${PIPESTATUS[0]}
    set -e
    if [ "$rc" -ne 0 ]; then
      abbruch \
        "Lauf $nummer von $(basename "$m") endete mit Rückgabewert $rc." \
        "Die Migration ist auf diesem Stand nicht einspielbar." \
        "Nächster Schritt: $log lesen. Auf einer Azure-Zielumgebung ist der" \
        "häufigste Grund, dass das Administratorkonto eines Flexible Server" \
        "kein SUPERUSER ist — Befund N-4 aus dem gezeichneten Lauf vom" \
        "06.08.2026, der genau daran abbrach (ALTER ROLE … NOSUPERUSER)."
    fi
    # Der Rückgabewert entscheidet -- das Textmuster fängt nur den Fall,
    # dass psql mit 0 endet und trotzdem eine Fehlerzeile gedruckt hat.
    if grep -qiE "^psql.*(error|FEHLER)" "$log"; then
      abbruch \
        "Lauf $nummer meldet einen Fehler im Protokoll." \
        "Nächster Schritt: $log lesen."
    fi
    if [ "$nummer" -eq 1 ]; then EINGESPIELT+=("$m"); fi
  done
  return 0
}

# ---------------------------------------------------------------------
# Der Datenabzug und der zeilengenaue Zugriffsschutz (RLS)
# ---------------------------------------------------------------------
# ANLASS — Befund P0-2, gemessen am 22.08.2026 gegen PostgreSQL 16.13:
# `M32__zeilenschutz_und_stufenwechsel.sql` schaltet auf `app`, `document`
# und `event` den zeilengenauen Zugriffsschutz ein -- die Sperre in der
# Datenbank, die Zeile für Zeile entscheidet, wer sie sehen darf -- und
# zwar mit ENABLE *und* FORCE (M32:70-80). FORCE heisst: die Regel gilt
# auch für die Eigentümerin der Tabelle.
#
# `pg_dump --data-only` stellt seine eigene Sitzung auf
# `row_security = off`. Sobald eine Abfrage dann eine Tabelle mit
# Zeilenregel anfasst, weist PostgreSQL sie ab:
#
#     pg_dump: error: query failed: ERROR:  query would be affected by
#     row-level security policy for table "app"
#
# Nur ein SUPERUSER darf diese Abschaltung mit Wirkung setzen. Auf der
# Azure-Zielumgebung ist das Administratorkonto keiner -- der Lauf stirbt
# also genau dort, wo er lokal als `postgres` durchlief. Der Abzug nach
# Lauf 1 entsteht gar nicht erst, Beleg 1 ist nicht zu führen.
#
# BEHOBEN mit `--enable-row-security`: pg_dump lässt den Zeilenschutz an
# und zieht die Zeilen, die seine Sitzung sehen darf. Auf dem heutigen
# Stand sind das ALLE -- die Regel aus M32:92-95 lautet
#   (tenant_id = sitzungs_mandant())
#   OR (sitzungs_mandant() IS NULL AND NOT rls_erzwungen())
# und der zweite Zweig ist für eine Sitzung ohne Mandanten wahr, solange
# der Schalter `freiraum.rls_enforce` nicht auf `on` steht (M32:60-63).
# Gemessen als Rolle `frx` (LOGIN, NOSUPERUSER, NOBYPASSRLS): 2 von 2
# `app`-Zeilen aus 2 Mandanten im Abzug, und je Tabelle dieselbe Zahl wie
# `count(*)` als Superuser.
#
# NICHT GEÄNDERT und ausdrücklich nicht zu ändern: M32 und die Tabellen.
# Weder `ALTER TABLE … NO FORCE ROW LEVEL SECURITY` -- was PostgreSQL im
# HINT selbst vorschlägt und was gemessen ebenfalls hilft -- noch eine
# gelockerte Zeilenregel. Beides nähme dem Eigentümer die Regel wieder ab,
# und die Anwendung verbindet sich heute als Eigentümer. Das wäre eine
# gesenkte Schwelle (K23-D05) und legte genau die Vorrichtung still, um
# die es hier geht. `--role=` und `-S/--superuser=` helfen nicht: das eine
# setzt nur `SET ROLE`, das andere ist Textkosmetik im Ausgabeformat.
#
# WAS DER SCHALTER ERKAUFT -- und warum die beiden Proben unten stehen:
# Der Abzug trägt jetzt nur noch, was die Sitzung SIEHT. Steht
# `freiraum.rls_enforce` auf `on` oder ein Mandant in
# `freiraum.tenant_id`, liefert pg_dump einen Abzug OHNE die Zeilen der
# geschützten Tabellen -- ohne Fehler, ohne Warnung, mit Rückgabewert 0.
# Gemessen: mit `PGOPTIONS='-c freiraum.rls_enforce=on'` stehen 0 von 2
# `app`-Zeilen im Abzug, die 2 `tenant`-Zeilen dagegen schon, weil
# `tenant` keine Zeilenregel trägt. Zwei so verkürzte Abzüge sind
# untereinander gleich; der Vergleich in Beleg 1 wäre leer und meldete
# "bestanden", ohne etwas gemessen zu haben -- der grüne Lauf ohne
# Messung, den CLAUDE.md Abschnitt 6 verbietet. Schlimmer noch: Zeilen,
# die Lauf 2 einfügt, wären in beiden Abzügen unsichtbar, und eine nicht
# wiederholbare Migration käme durch.
#
# Dagegen stehen zwei Proben, beide gemessen, keine geschätzt:
#   * `rls_lage_pruefen` VOR jedem Abzug -- liest Schalter und
#     Sitzungsmandanten und bricht ab, wenn der Abzug verkürzt würde.
#   * `zeilenprobe` NACH jedem Abzug -- zählt je Tabelle die Zeilen im
#     Abzug gegen `count(*)` in der Datenbank und schreibt beide Zahlen
#     als Beleg.
# Die Grenze der zweiten Probe wird hier benannt statt verschwiegen: sie
# zählt aus derselben Sitzungslage heraus, in der auch pg_dump zieht. Wäre
# die Sitzung blind, wären beide Zahlen gemeinsam blind. Genau diesen Fall
# deckt die erste Probe ab -- deshalb sind es zwei und nicht eine.

# Zählt, wie viele `INSERT INTO <schema>.<tabelle>`-Zeilen ein Abzug für
# eine Tabelle trägt. `--column-inserts` schreibt genau eine solche Zeile
# je Datenzeile. Anführungszeichen um Schema oder Tabelle werden vorher
# entfernt, damit ein Name, den pg_dump zitieren muss, mitgezählt wird;
# das abschliessende Leerzeichen trennt `app` von `app_state_history`.
zeilen_im_abzug() {   # $1 Abzugsdatei  $2 Schema  $3 Tabelle
  awk -v s="$2" -v t="$3" '
    index($0, "INSERT INTO ") == 1 {
      rest = substr($0, 13)
      gsub(/"/, "", rest)
      if (index(rest, s "." t " ") == 1) n++
    }
    END { print n + 0 }' "$1"
}

# Zahl der Datenzeilen im zuletzt genommenen Abzug, gesetzt von
# `zeilenprobe` und im Nachweis von Beleg 1 ausgewiesen.
ZEILEN_ABZUG=0

# Vorbedingung des Datenabzugs: sieht die Sitzung alle Zeilen?
rls_lage_pruefen() {
  local antwort rc tabellen schalter mandant
  set +e
  antwort="$(psql "$VERBINDUNG" -tAq -F$'\t' -c "
    SELECT (SELECT count(*)
              FROM pg_class c JOIN pg_namespace n ON n.oid = c.relnamespace
             WHERE c.relkind = 'r' AND c.relrowsecurity
               AND n.nspname <> 'information_schema' AND n.nspname !~ '^pg_'),
           coalesce(current_setting('freiraum.rls_enforce', true), 'aus'),
           coalesce(current_setting('freiraum.tenant_id',   true), '');" 2>&1)"
  rc=$?
  set -e
  [ "$rc" -eq 0 ] || abbruch \
    "Die Lage des Zeilenschutzes liess sich nicht messen (Rückgabewert $rc)." \
    "Ohne diese Messung ist nicht zu sagen, ob ein Datenabzug vollständig wäre." \
    "Antwort des Servers: $antwort" \
    "Nächster Schritt: die Verbindung prüfen und den Lauf wiederholen."
  IFS=$'\t' read -r tabellen schalter mandant <<< "$antwort"

  if [ "${tabellen:-0}" -eq 0 ]; then
    echo "  Zeilenschutz: keine Tabelle trägt eine Zeilenregel -- der Datenabzug"
    echo "  kann durch ihn nicht verkürzt werden."
    return 0
  fi
  if [ "$schalter" = "on" ]; then
    abbruch \
      "Der Schalter freiraum.rls_enforce steht auf \"on\" -- der Datenabzug wäre verkürzt." \
      "Woran es liegt: $tabellen Tabelle(n) tragen den zeilengenauen Zugriffsschutz." \
      "Der Abzug läuft mit --enable-row-security, zieht also nur, was diese Sitzung" \
      "sehen darf. Mit eingeschaltetem Schalter und ohne Sitzungsmandanten ist das" \
      "KEINE Zeile dieser Tabellen -- pg_dump meldet das nicht, es liefert" \
      "Rückgabewert 0 und einen stillschweigend leeren Abzug." \
      "Zwei solche Abzüge wären untereinander gleich und meldeten einen bestandenen" \
      "Vergleich, der nichts gemessen hat." \
      "Nächster Schritt: den Schalter für diesen Lauf nicht setzen -- also PGOPTIONS" \
      "ohne freiraum.rls_enforce fahren und prüfen, ob er per ALTER DATABASE oder" \
      "ALTER ROLE hinterlegt ist (\\drds in psql zeigt es). Der Kettenlauf misst eine" \
      "Migration, nicht den Betrieb; die Durchsetzung wird nicht hier eingeschaltet."
  fi
  if [ -n "$mandant" ]; then
    abbruch \
      "In freiraum.tenant_id steht ein Mandant -- der Datenabzug wäre verkürzt." \
      "Woran es liegt: $tabellen Tabelle(n) tragen den zeilengenauen Zugriffsschutz." \
      "Mit gesetztem Mandanten zieht der Abzug nur dessen Zeilen; die Zeilen aller" \
      "anderen Mandanten fehlen, ohne dass pg_dump das meldet." \
      "Nächster Schritt: den Lauf ohne gesetzten Sitzungsmandanten fahren -- also" \
      "PGOPTIONS ohne freiraum.tenant_id, und prüfen, ob der Wert per ALTER DATABASE" \
      "oder ALTER ROLE hinterlegt ist (\\drds in psql zeigt es)."
  fi
  echo "  Zeilenschutz: auf $tabellen Tabelle(n) aktiv; Schalter aus, kein"
  echo "  Sitzungsmandant -- die Sitzung sieht alle Zeilen (nachgezählt unten)."
}

# Gegenprobe nach dem Abzug: trägt er je Tabelle so viele Zeilen, wie die
# Datenbank hat? Die Zahlen kommen in einen eigenen Beleg, damit im
# Nachweis eine Zahl steht und nicht ein Adjektiv (SPR-5).
zeilenprobe() {   # $1 = Laufnummer
  local nummer="$1" datei="$ZIEL/daten_nach_lauf$1.sql"
  local bericht="$ZIEL/daten_zeilen_lauf$1.txt"
  local liste rc schema tabelle soll ist abweichungen=0 summe_db=0 summe_abzug=0
  set +e
  liste="$(psql "$VERBINDUNG" -tAq -F$'\t' -c "
    SELECT n.nspname, c.relname,
           (xpath('/row/z/text()',
                  query_to_xml(format('SELECT count(*) AS z FROM %I.%I',
                                      n.nspname, c.relname), false, true, '')
                 ))[1]::text::bigint
      FROM pg_class c JOIN pg_namespace n ON n.oid = c.relnamespace
     WHERE c.relkind = 'r' AND NOT c.relispartition
       AND n.nspname <> 'information_schema' AND n.nspname !~ '^pg_'
       AND NOT EXISTS (SELECT 1 FROM pg_depend d
                        WHERE d.classid = 'pg_class'::regclass
                          AND d.objid = c.oid AND d.deptype = 'e')
     ORDER BY 1, 2;" 2>&1)"
  rc=$?
  set -e
  [ "$rc" -eq 0 ] || abbruch \
    "Die Zeilen der Datenbank liessen sich nach Lauf $nummer nicht zählen (Rückgabewert $rc)." \
    "Ohne diese Zahl ist nicht zu belegen, dass der Datenabzug vollständig ist." \
    "Antwort des Servers: $liste" \
    "Nächster Schritt: die Verbindung prüfen und den Lauf wiederholen."

  printf 'Tabelle\tZeilen im Abzug\tZeilen in der Datenbank\n' > "$bericht"
  while IFS=$'\t' read -r schema tabelle soll; do
    [ -n "$tabelle" ] || continue
    ist="$(zeilen_im_abzug "$datei" "$schema" "$tabelle")"
    printf '%s.%s\t%s\t%s\n' "$schema" "$tabelle" "$ist" "$soll" >> "$bericht"
    summe_db=$((summe_db + soll))
    summe_abzug=$((summe_abzug + ist))
    [ "$ist" -eq "$soll" ] || abweichungen=$((abweichungen + 1))
  done <<< "$liste"
  printf 'SUMME\t%s\t%s\n' "$summe_abzug" "$summe_db" >> "$bericht"

  if [ "$abweichungen" -ne 0 ]; then
    abbruch \
      "Der Datenabzug nach Lauf $nummer ist unvollständig: bei $abweichungen Tabelle(n)" \
      "stehen im Abzug weniger oder mehr Zeilen als in der Datenbank." \
      "Woran es liegt: Der Abzug läuft mit --enable-row-security und zieht nur, was" \
      "seine Sitzung sehen darf. Fehlen Zeilen, hat eine Zeilenregel sie ausgeblendet." \
      "Ein solcher Abzug darf nicht verglichen werden -- zwei gleich verkürzte Abzüge" \
      "ergäben einen leeren Vergleich und einen bestandenen Beleg ohne Messung." \
      "Die Gegenüberstellung je Tabelle steht in: $bericht" \
      "Nächster Schritt: die Tabellen mit Abweichung im Bericht ablesen und prüfen," \
      "ob für diese Sitzung ein Mandant oder der Schalter freiraum.rls_enforce gesetzt" \
      "ist (\\drds in psql zeigt hinterlegte Werte)."
  fi
  ZEILEN_ABZUG="$summe_abzug"
  echo "  Datenabzug nach Lauf $nummer: $summe_abzug Zeile(n) -- so viele hat die"
  echo "  Datenbank auch (\`$(basename "$bericht")\`)."
}

abzug_nehmen() {   # $1 = Laufnummer
  local nummer="$1" rc
  rls_lage_pruefen
  # Die dritte Frage, die das Fremdmodell nicht beurteilen konnte: WIE die
  # Abzüge gezogen wurden. Beide Aufrufzeilen und die Fassung von pg_dump
  # gehen hier mit -- vor dem Aufruf, damit sie auch dann dastehen, wenn er
  # scheitert.
  #
  # Die Verbindung steht als ⟨Verbindung⟩ und NICHT im Klartext: sie trägt
  # das Kennwort. Ein Zugangswert in einem Beleg sperrt den Lauf (K23-D09),
  # und `kennwort_probe` würde ihn am Ende finden.
  {
    echo "--- Lauf $nummer · $(date '+%d.%m.%Y %H:%M:%S') ---"
    echo "pg_dump-Fassung: $(pg_dump --version 2>&1)"
    echo "Schema: pg_dump --schema-only ⟨Verbindung⟩ > schema_roh_lauf$nummer.sql"
    echo "Daten:  pg_dump --data-only --column-inserts --enable-row-security ⟨Verbindung⟩ > daten_roh_lauf$nummer.sql"
  } >> "$ZIEL/pg_dump_aufrufe.txt"
  set +e
  pg_dump --schema-only "$VERBINDUNG" > "$ZIEL/schema_roh_lauf$nummer.sql"
  rc=$?
  set -e
  [ "$rc" -eq 0 ] || abbruch \
    "Der Schema-Abzug nach Lauf $nummer endete mit Rückgabewert $rc." \
    "Ohne beide Abzüge ist der Vergleich nicht zu führen." \
    "Nächster Schritt: prüfen, ob pg_dump dieselbe Fassung hat wie der Server" \
    "und ob das Konto alle Objekte lesen darf."
  set +e
  # --enable-row-security: siehe den Block über dieser Funktion. Ohne den
  # Schalter bricht dieser Aufruf auf jeder Datenbank ab, die M32 trägt,
  # sobald das Konto kein SUPERUSER ist -- also auf der Zielumgebung.
  pg_dump --data-only --column-inserts --enable-row-security "$VERBINDUNG" \
    > "$ZIEL/daten_roh_lauf$nummer.sql"
  rc=$?
  set -e
  [ "$rc" -eq 0 ] || abbruch \
    "Der Daten-Abzug nach Lauf $nummer endete mit Rückgabewert $rc." \
    "Ein Abzug, der nur zur Hälfte entstand, wird nicht verglichen." \
    "Drei Gründe kommen in Frage, in dieser Reihenfolge zu prüfen:" \
    "1. Der zeilengenaue Zugriffsschutz (RLS) -- die Sperre, die Zeile für Zeile" \
    "   entscheidet, wer sie sehen darf. M32 setzt ihn auf app, document und event" \
    "   mit ENABLE und FORCE. Meldet pg_dump \"query would be affected by row-level" \
    "   security policy for table ...\", fehlt diesem Aufruf --enable-row-security." \
    "   Nächster Schritt: prüfen, ob der Schalter in der pg_dump-Zeile oben steht;" \
    "   NICHT die Tabelle auf NO FORCE stellen -- das schaltet den Schutz ab" \
    "   (K23-D05: kein Prüfwert wird gesenkt, damit ein Lauf besteht)." \
    "2. Die Fassung von pg_dump ist älter als die des Servers." \
    "3. Das Konto darf nicht alle Objekte lesen." \
    "Der Wortlaut der Meldung steht in der Bildschirmausgabe unmittelbar über" \
    "dieser Zeile und entscheidet, welcher der drei Fälle vorliegt."
  entrausche < "$ZIEL/schema_roh_lauf$nummer.sql" > "$ZIEL/schema_nach_lauf$nummer.sql"
  # Daten getrennt: Eine Migration kann schemagleich sein und trotzdem beim
  # zweiten Lauf Zeilen einfügen. Genau das fällt sonst niemandem auf.
  # LC_ALL=C, damit die Sortierung nicht von der Spracheinstellung des
  # Rechners abhängt und zwei Abzüge auf zwei Rechnern vergleichbar bleiben.
  entrausche < "$ZIEL/daten_roh_lauf$nummer.sql" | LC_ALL=C sort \
    > "$ZIEL/daten_nach_lauf$nummer.sql"
  rm -f "$ZIEL/schema_roh_lauf$nummer.sql" "$ZIEL/daten_roh_lauf$nummer.sql"
  [ -s "$ZIEL/schema_nach_lauf$nummer.sql" ] || abbruch \
    "Der Schema-Abzug nach Lauf $nummer ist leer." \
    "Zwei leere Abzüge wären inhaltsgleich und würden einen bestandenen" \
    "Vergleich melden, der nichts gemessen hat." \
    "Nächster Schritt: prüfen, ob die Verbindung auf die richtige Datenbank zeigt."
  # Dieselbe Prüfung für den DATENABZUG. Bis zum 22.08.2026 stand sie nur
  # für den Schemaabzug hier -- ein abgeschnittener Datenabzug wäre also
  # unbemerkt in den Vergleich gegangen. Eine leere Datei heisst nicht
  # "keine Daten": selbst eine Datenbank ohne eine einzige Zeile liefert
  # den Kopf von pg_dump. Wie viele DATENZEILEN darin stehen, misst
  # `zeilenprobe` gleich danach -- eine Zahl, keine Schwelle.
  [ -s "$ZIEL/daten_nach_lauf$nummer.sql" ] || abbruch \
    "Der Daten-Abzug nach Lauf $nummer ist leer -- nicht einmal der Kopf von pg_dump" \
    "steht darin." \
    "Zwei leere Abzüge wären inhaltsgleich und würden einen bestandenen" \
    "Vergleich melden, der nichts gemessen hat." \
    "Nächster Schritt: prüfen, ob auf dem Datenträger noch Platz ist und ob die" \
    "Verbindung auf die richtige Datenbank zeigt."
  zeilenprobe "$nummer"
}

# ---------------------------------------------------------------------
# Der Abzug VOR Lauf 1 — neu am 22.08.2026, Behebung von P0-1
# ---------------------------------------------------------------------
# Ohne ihn ist nicht zu messen, ob Lauf 1 überhaupt etwas verändert hat.
# Ein Lauf 1, der nichts verändert, ist kein erster Lauf: dann sind auch
# Lauf 1 und Lauf 2 gleich, der Vergleich "zweiter Lauf ändert nichts"
# besteht von selbst, und Beleg 1 meldet grün, ohne etwas gemessen zu
# haben. Bewiesen wäre allein, dass Lauf n+1 dasselbe Ergebnis hat wie
# Lauf n+2.
#
# Der Abzug entsteht mit DERSELBEN Funktion und denselben Filtern wie die
# Abzüge danach -- sonst verglichen die drei Vergleiche verschieden
# aufbereitete Dateien. `abzug_nehmen` kennt nur Laufnummern; dieser Abzug
# läuft deshalb als "Lauf 0" durch und wird danach unter dem Namen
# abgelegt, unter dem er im Belegordner zu suchen ist.
abzug_vor_lauf1() {
  abzug_nehmen 0
  mv "$ZIEL/schema_nach_lauf0.sql" "$ZIEL/schema_vor.sql"
  mv "$ZIEL/daten_nach_lauf0.sql"  "$ZIEL/daten_vor.sql"
  [ -f "$ZIEL/daten_zeilen_lauf0.txt" ] \
    && mv "$ZIEL/daten_zeilen_lauf0.txt" "$ZIEL/daten_zeilen_vor.txt"
  echo "  abgelegt als schema_vor.sql und daten_vor.sql"
}

echo "Abzug VOR Lauf 1 (die Zwischenmeldungen nennen ihn \"Lauf 0\"):"
abzug_vor_lauf1
echo "Lauf 1:"
migrationen_einspielen 1
abzug_nehmen 1
echo "Lauf 2:"
migrationen_einspielen 2
abzug_nehmen 2

# ---- Erste Hälfte von Beleg 1: Lauf 1 MUSS etwas verändert haben ------
# Beleg 1 gilt erst als bestanden, wenn BEIDE Hälften stimmen. Diese hier
# ist die neue: sie misst die WIRKUNG des ersten Laufs. Der Frischetest in
# Beleg 0 misst die Vorbedingung; diese Prüfung fängt den Fall auf, dass
# dort ein Merkmal fehlt oder danebengreift.
# Zählt, um wie viele Zeilen sich zwei Abzüge unterscheiden. Das ist eine
# Zahl für den Nachweis (SPR-5: Zahlen statt Adjektive), keine Schwelle --
# gefordert ist nur, dass sie nicht null ist. Sie zählt Zeilen der
# Abzugsdateien, nicht Zeilen der Datenbank: fügt eine Migration eine
# Tabelle hinzu, verschieben sich im sortierten Datenabzug auch Leer- und
# Kommentarzeilen, und die zählen mit.
zaehle_aenderungen() {   # $1 = Vergleichsprotokoll von `diff -u`
  # Die Kopfzeilen von `diff -u` beginnen mit --- und +++ und werden
  # ausgenommen; sonst zählte auch ein leerer Vergleich Änderungen.
  awk '/^(\+\+\+|---)/ {next} /^[+-]/ {n++} END {print n+0}' "$1"
}
erstlauf_schema=0
erstlauf_daten=0
diff -u "$ZIEL/schema_vor.sql" "$ZIEL/schema_nach_lauf1.sql" \
  > "$ZIEL/erstlauf_schema_diff.txt" || erstlauf_schema=1
diff -u "$ZIEL/daten_vor.sql" "$ZIEL/daten_nach_lauf1.sql" \
  > "$ZIEL/erstlauf_daten_diff.txt" || erstlauf_daten=1
n_erst_schema="$(zaehle_aenderungen "$ZIEL/erstlauf_schema_diff.txt")"
n_erst_daten="$(zaehle_aenderungen "$ZIEL/erstlauf_daten_diff.txt")"
if [ "$erstlauf_schema" -eq 0 ] && [ "$erstlauf_daten" -eq 0 ]; then
  abbruch \
    "Lauf 1 hat weder das Schema noch die Daten verändert." \
    "Woran es liegt: Entweder stand die Datenbank schon auf diesem Stand," \
    "oder die gewählten Migrationen tun nichts. Beides heisst dasselbe --" \
    "dies war kein erster Lauf." \
    "Warum das ein Abbruch ist und keine Nebenbemerkung: Sind beide Läufe" \
    "wirkungslos, sind auch beide Abzüge danach gleich. Der Vergleich" \
    "\"zweiter Lauf ändert nichts\" besteht dann von selbst, und Beleg 1" \
    "meldete bestanden, ohne etwas gemessen zu haben. Bewiesen wäre allein," \
    "dass Lauf n+1 dasselbe Ergebnis hat wie Lauf n+2 (Befund P0-1 vom" \
    "22.08.2026)." \
    "Verglichen wurden schema_vor.sql gegen schema_nach_lauf1.sql und" \
    "daten_vor.sql gegen daten_nach_lauf1.sql. Beide Vergleichsprotokolle" \
    "sind leer:" \
    "  $ZIEL/erstlauf_schema_diff.txt" \
    "  $ZIEL/erstlauf_daten_diff.txt" \
    "Nächster Schritt: gegen eine frische Datenbank fahren -- nach der" \
    "Betriebsregel \"eigene Datenbank je Pilot-Anlauf\" (CLAUDE.md Abschnitt" \
    "5) eine neue anlegen, nicht die vorhandene leeren." \
    "Schlägt dieser Riegel an, OBWOHL die Datenbank frisch war, hat der" \
    "Frischetest in Beleg 0 ein Merkmal nicht erkannt. Dann gehört das" \
    "Merkmal in \`merkmal_zeilen()\` berichtigt und der Befund gemeldet --" \
    "die Schwelle wird nicht gesenkt (K23-D05)."
fi
echo "Lauf 1 hat gewirkt: $n_erst_schema Zeile(n) Unterschied im Schema-Abzug, $n_erst_daten im Daten-Abzug."

# ---- Zweite Hälfte von Beleg 1: Lauf 2 darf nichts verändert haben ----
if ! diff -u "$ZIEL/schema_nach_lauf1.sql" "$ZIEL/schema_nach_lauf2.sql" > "$ZIEL/schema_diff.txt"; then
  abbruch \
    "Der zweite Lauf hat das SCHEMA geändert." \
    "Eine Migration, die beim zweiten Einspielen etwas verändert, ist nicht" \
    "wiederholbar -- und ein Abnahmelauf auf ihr ist nicht reproduzierbar." \
    "Unterschiede stehen in: $ZIEL/schema_diff.txt" \
    "Nächster Schritt: die nicht wiederholbare Anweisung in der Migration" \
    "suchen (Vorbild: CREATE OR REPLACE, DROP POLICY IF EXISTS,"  \
    "INSERT … ON CONFLICT) und den Befund melden."
fi
if ! diff -u "$ZIEL/daten_nach_lauf1.sql" "$ZIEL/daten_nach_lauf2.sql" > "$ZIEL/daten_diff.txt"; then
  abbruch \
    "Der zweite Lauf hat DATEN geändert." \
    "Unterschiede stehen in: $ZIEL/daten_diff.txt" \
    "Nächster Schritt: die einfügende Anweisung suchen und um ON CONFLICT" \
    "ergänzen; Zufalls- und Zeitwerte in eingefügten Zeilen sind der" \
    "zweithäufigste Grund."
fi
echo "beide diffs leer -- Schema und Daten sind nach dem zweiten Lauf gleich."
zustand 1 "Lauf 1 verändert etwas, Lauf 2 verändert nichts" "bestanden" \
  "Lauf 1 hat gewirkt: $n_erst_schema Zeile(n) Unterschied im Schema-Abzug, $n_erst_daten im Daten-Abzug; nach Lauf 2 beide diffs leer, ${#MIGRATIONEN[@]} Migration(en) je zweimal; verglichen wurden $ZEILEN_ABZUG Datenzeile(n), so viele wie die Datenbank trägt" \
  "\`erstlauf_schema_diff.txt\` · \`erstlauf_daten_diff.txt\` · \`schema_diff.txt\` · \`daten_diff.txt\` · \`daten_zeilen_lauf1.txt\` · \`daten_zeilen_lauf2.txt\`"

# ---------------------------------------------------------------------
# Beleg 2 und 3 · Prüffälle und Gegentest-Meldungen
# ---------------------------------------------------------------------
sagen "Beleg 2 und 3 · Prüffälle und Gegentest-Meldungen"
set +e; P -f "$TST" > "$ZIEL/pruefung_ausgabe.log" 2>&1; rc=$?; set -e

# Die Kollision Vorläufer × Prüfdatei zuerst -- sie tötet den Lauf VOR dem
# ersten Prüffall und sähe sonst wie ein beliebiger psql-Fehler aus.
if [ "$rc" -ne 0 ] \
   && grep -q "customer_needs_avv" "$ZIEL/pruefung_ausgabe.log" \
   && ! grep -q "SUMME:" "$ZIEL/pruefung_ausgabe.log"; then
  printf 'Prüffälle: psql-Rückgabewert %s\n' "$rc" | tee -a "$ZIEL/rueckgabewerte.txt"
  abbruch \
    "Die Prüffälle sind an der Bedingung customer_needs_avv gescheitert --" \
    "und zwar an ihrer eigenen Ausgangslage, vor dem ersten Prüffall." \
    "Woran es liegt: Der Vorläufer 260801 hängt an tenant die Bedingung" \
    "customer_needs_avv (migrations/_vorlaeufer/260801_tenant.sql:44-47). Die" \
    "Prüfdatei legt sich ihre Ausgangslage selbst und trägt in" \
    "pruefungen/migration/M30__pruefung.sql:31 den Kunden \"Demobank\" ohne" \
    "avv_datum und avv_aktenzeichen ein. Beides ist für sich gezeichneter" \
    "Bestand; zusammen gehen sie nicht." \
    "Es ist KEIN Fehler einer Migration: M30, M31 und M32 nennen diese Spalten" \
    "an keiner Stelle. Der gezeichnete Abnahmelauf n2_lauf.sh spielt den" \
    "Vorläufer gar nicht ein -- deshalb läuft er durch." \
    "Nächster Schritt: ohne --mit-vorlaeufer fahren (Vorgabe). Soll die" \
    "Prüfumgebung MIT Vorläufer gemessen werden, ist die Ausgangslage der" \
    "Prüfdatei anzupassen -- das ist eine Änderung unter pruefungen/ und" \
    "gehört gezeichnet, nicht nebenbei gemacht." \
    "Vollständige Ausgabe: $ZIEL/pruefung_ausgabe.log"
fi

if [ "$rc" -ne 0 ] && [ "$UMFANG" = "m30" ]; then
  # Die vorhersehbare Folge von Lesart A wird BENANNT, nicht getragen.
  # Ein Prüfwert wird hier nicht gesenkt und keine Ausnahme gesetzt
  # (K23-D05); der Lauf endet, und der Grund steht da.
  if grep -q "p_project_no" "$ZIEL/pruefung_ausgabe.log"; then
    printf 'Prüffälle: psql-Rückgabewert %s\n' "$rc" | tee -a "$ZIEL/rueckgabewerte.txt"
    # Die Summenzeile ist hier GEMESSEN worden -- sie gehört in den Nachweis,
    # auch wenn der Lauf gleich endet. Ohne diese drei Zeilen stünde in der
    # Tabelle nur "Lauf endete hier", und der Messwert 108 von 111 wäre
    # allein aus dem Rohprotokoll zu holen.
    grep -oE "SUMME: [0-9]+ von [0-9]+ bestanden.*" "$ZIEL/pruefung_ausgabe.log" \
      | tail -1 > "$ZIEL/summe.txt" || true
    if [ -s "$ZIEL/summe.txt" ]; then
      zustand 2 "Prüffälle" "fehlgeschlagen" \
        "$(cat "$ZIEL/summe.txt") — Folge von Lesart A, siehe Abbruchtext" \
        "\`pruefung_ausgabe.log\` · \`summe.txt\`"
    fi
    abbruch \
      "Die Prüffälle sind gescheitert -- an der offenen Umfangsfrage." \
      "Mit --umfang m30 steht die fünfstellige Fassung von create_app_after_fit," \
      "denn der zweite M30-Lauf stellt sie wieder her. MT-95, MT-95b und MT-98" \
      "messen, dass der Befehl KEINE Projektnummer entgegennimmt — nach K01-M38," \
      "der Klausel \"sie wird vergeben, nicht eingegeben\"." \
      "Das ist die gemessene Folge von Lesart A, kein Fehler im Skript und" \
      "kein Fehler im Bau (arbeit/Vorlagen/m1_startklar_260820.md:79-84)." \
      "Nächster Schritt: entweder den Umfang zeichnen lassen und --umfang alle" \
      "fahren, oder die drei Fälle als benannte Ausnahme zeichnen lassen." \
      "Vollständige Ausgabe: $ZIEL/pruefung_ausgabe.log"
  fi
fi
lauf_pruefen "$rc" "$ZIEL/pruefung_ausgabe.log" "Prüffälle"

grep -oE "SUMME: [0-9]+ von [0-9]+ bestanden.*" "$ZIEL/pruefung_ausgabe.log" \
  | tail -1 > "$ZIEL/summe.txt" || true
if [ ! -s "$ZIEL/summe.txt" ]; then
  abbruch \
    "In der Ausgabe der Prüffälle steht keine Summenzeile." \
    "Der Lauf ist unvollständig geblieben -- gemessen wurde nichts." \
    "Nächster Schritt: $ZIEL/pruefung_ausgabe.log lesen."
fi
cat "$ZIEL/summe.txt"
# Kein fest verdrahteter Sollwert: Die Zahl wächst mit jedem neuen Fall,
# und eine Zahl im Skript veraltet stiller als eine Regel. Gefordert ist,
# dass KEIN Fall scheitert -- und dass überhaupt welche gelaufen sind.
grep -q "SUMME: .* 0 gescheitert" "$ZIEL/summe.txt" || abbruch \
  "Es sind Prüffälle gescheitert." \
  "$(cat "$ZIEL/summe.txt")" \
  "Nächster Schritt: die Zeilen mit GESCHEITERT in" \
  "$ZIEL/pruefung_ausgabe.log lesen. Die Schwelle wird NICHT gesenkt: K23-D05 —" \
  "die Klausel, die verbietet, einen Prüfwert zu senken, damit ein Lauf besteht."
n_faelle="$(grep -oE "SUMME: [0-9]+" "$ZIEL/summe.txt" | grep -oE "[0-9]+" || echo 0)"
[ "$n_faelle" -ge 100 ] || abbruch \
  "Nur $n_faelle Prüffälle gelaufen -- erwartet werden mindestens 100." \
  "Ein Lauf mit zu wenigen Fällen misst nicht, was er zu messen vorgibt." \
  "Nächster Schritt: prüfen, ob $TST vollständig durchgelaufen ist."
echo "$n_faelle Prüffälle, keiner gescheitert."
zustand 2 "Prüffälle" "bestanden" "$(cat "$ZIEL/summe.txt")" "\`pruefung_ausgabe.log\` · \`summe.txt\`"

# BERICHTIGT GEGENÜBER n2_lauf.sh:182. Dort lautet das Muster
# "MT-[0-9]+ · [A-Z* ]+ — .*" und verliert JEDE Kennung mit
# Buchstabenzusatz: nach "MT-95" folgt in "MT-95b · BESTANDEN — …" ein "b"
# statt des Trennzeichens, und der Treffer entfällt lautlos. Gemessen und
# aktenkundig: 109 Meldungen bei 110 Fällen, MT-104b fehlte
# (nachweise/uebergabe_n2/n2_belege_260806_1410/ABNAHMENACHWEIS_ENTWURF.md:48-53
# und GEGENTEST_PROTOKOLL.md:78-79 vom 06.08.2026). Heute betrifft das
# MT-95b und MT-104b. Das Muster nimmt den Zusatz jetzt mit.
#
# Und es fängt den zweiten Fehler derselben Zeile mit ab: n2_lauf.sh:182
# trägt kein "|| true". Findet grep nichts, endet das Skript dort unter
# set -e OHNE MELDUNG -- derselbe stumme Tod, den der Kommentar bei der
# Summenzeile schon einmal behoben hat.
grep -oE "MT-[0-9]+[a-z]* · [A-Z* ]+ — .*" "$ZIEL/pruefung_ausgabe.log" \
  > "$ZIEL/gegentest_meldungen.txt" || true
n_meldungen="$(wc -l < "$ZIEL/gegentest_meldungen.txt" | tr -d ' ')"
if [ "$n_meldungen" -eq 0 ]; then
  abbruch \
    "Es wurde keine einzige Meldungszeile der Gegentests gefunden." \
    "Erwartet wird die Form \"MT-95b · BESTANDEN — …\"; gesucht wurde in" \
    "$ZIEL/pruefung_ausgabe.log." \
    "Nächster Schritt: prüfen, ob die Prüfdatei ihre Ergebniszeilen" \
    "unverändert druckt -- ohne sie ist Beleg 3 nicht zu führen."
fi
if [ "$n_meldungen" -ne "$n_faelle" ]; then
  # Kein Abbruch, aber auch kein Schweigen: die Zahlen gehören
  # nebeneinander, damit ein verlorener Fall auffällt statt zu verschwinden.
  echo "HINWEIS: $n_meldungen Meldungszeilen bei $n_faelle Prüffällen --"
  echo "         die Zahlen sollten gleich sein. Bitte $ZIEL/gegentest_meldungen.txt"
  echo "         gegen $ZIEL/pruefung_ausgabe.log halten."
fi
echo "$n_meldungen Meldungszeilen festgehalten."
zustand 3 "Gegentest-Meldungen einzeln festgehalten" "bestanden" \
  "$n_meldungen Meldungen bei $n_faelle Fällen -- zu LESEN, nicht zu zählen" \
  "\`gegentest_meldungen.txt\`"

# ---------------------------------------------------------------------
# Beleg 4 · Vorbereitung: die Klammer, die nichts hinterlässt
# ---------------------------------------------------------------------
# NEU AM 22.08.2026. Anlass ist ein gemessener Befund aus der Gegenprüfung
# des Fremdmodell-Laufs (unten als P0-3 geführt).
#
# Bis dahin fuhr Beleg 4 die eingefrorenen Prüffälle mit `psql -1 -f $ALT`.
# Der Schalter `-1` klammert die Datei in BEGIN … COMMIT und COMMITTET am
# Dateiende. `schema/pruefung_v2.9.sql` legt sich ihre Ausgangslage selbst
# an -- zwei Mandanten, zwei Akteure, zwei Mitgliedschaften, zwei
# Einladungen, eine Eignungsprüfung, eine Anwendung -- und räumt davon
# nichts ab: sie kennt 14 Teilrücknahmen der Form `ROLLBACK TO s<n>`, aber
# keinen abschliessenden `ROLLBACK`. Die synthetischen Prüfdaten standen
# danach UNWIDERRUFLICH in der Zieldatenbank; nach F36 -- der Festlegung,
# dass in diesem Projekt nichts gelöscht wird -- wären sie nicht wieder
# herauszubekommen.
#
# Behoben wird das VON AUSSEN, in `migrations/_werkzeug/pruefklammer.sql`: BEGIN,
# dann die Prüfdatei über `\i`, dann ROLLBACK. Die Prüfdatei selbst wird
# NICHT angefasst -- sie liegt unter `schema/` mit der Änderungsregel
# "keine" (`schema/README.md`), und eine Messung wird nicht umgeschrieben.
# Die Ausgabe, die Beleg 4 auswertet, bleibt dabei vollständig und trägt
# weiterhin die Zeilennummern der Prüfdatei in ihren Fehlermeldungen.
#
# Dazu zwei Riegel, damit die Klammer nicht bloss behauptet ist:
#   * `klammer_tragfaehig` VOR dem Lauf -- sieht in der Prüfdatei nach, ob
#     sie ihre Transaktion selbst beendet. Ein `COMMIT`, ein `BEGIN`, ein
#     `END;` oder ein alleinstehendes `ROLLBACK;` zerrisse die Klammer.
#     Gefunden wird das BENANNT, nicht überlistet.
#   * `pruefdaten_zaehlen` VOR und NACH Beleg 4 -- Mandanten, Akteure,
#     Mitgliedschaften, Einladungen, Eignungsprüfungen, Anwendungen und
#     Ereignisse. Weicht eine Zahl ab, ist etwas liegen geblieben, und der
#     Lauf bricht ab. Das misst die Wirkung, nicht die Absicht.
#
# Zur Aussagekraft der Zählung: `app`, `document` und `event` tragen seit
# M32 den zeilengenauen Zugriffsschutz. Diese Sitzung sieht dort alle
# Zeilen -- `rls_lage_pruefen` in Beleg 1 bricht vorher ab, wenn
# `freiraum.rls_enforce` auf "on" steht oder ein Sitzungsmandant gesetzt
# ist. Die vier Tabellen, in denen der Befund die Rückstände gemessen hat
# (`tenant`, `actor`, `membership`, `invitation`), tragen ohnehin keine
# Zeilenregel und sind vollständig zählbar.

# Sieht nach, ob die Prüfdatei ihre eigene Transaktion beendet.
klammer_tragfaehig() {   # $1 = Prüfdatei
  local datei="$1" treffer
  case "$datei" in
    *[[:space:]]*)
      abbruch \
        "Der Pfad der Prüfdatei enthält ein Leerzeichen: $datei" \
        "Woran es liegt: die Klammer reicht den Pfad als psql-Variable weiter," \
        "und psql setzt ihn in \\i unverändert ein. Die Anführungsform" \
        "\\i :'pruefdatei' hilft nicht -- gemessen mit psql 16.13 landen die" \
        "Anführungszeichen im Dateinamen." \
        "Nächster Schritt: die Prüfdatei an einen Pfad ohne Leerzeichen legen" \
        "und ALT_DATEI= darauf setzen."
      ;;
  esac
  treffer="$(grep -nEi '^[[:space:]]*(BEGIN|START[[:space:]]+TRANSACTION|COMMIT|END|ROLLBACK)[[:space:]]*(WORK|TRANSACTION)?[[:space:]]*;' "$datei" || true)"
  if [ -n "$treffer" ]; then
    abbruch \
      "Die Prüfdatei beendet ihre Transaktion selbst -- die Klammer trüge nicht." \
      "Woran es liegt: $datei enthält mindestens eine Anweisung, die eine" \
      "Transaktion öffnet oder schliesst. Gefunden wurde:" \
      "$treffer" \
      "Wirkung: alles vor einem COMMIT bliebe dauerhaft in der Zieldatenbank" \
      "stehen, auch wenn die Klammer am Ende ein ROLLBACK absetzt." \
      "Falls es sich um ein BEGIN oder END aus einem PL/pgSQL-Block handelt" \
      "(\$\$ … BEGIN … END \$\$;), ist es ein Fehlalarm -- daran zu erkennen," \
      "dass die Zeile innerhalb eines Dollar-Zitats steht." \
      "Nächster Schritt: den Befund melden, nicht die Prüfung umgehen. Die" \
      "Prüfdatei zu ändern ist eine Änderung an einer gezeichneten Messung" \
      "und gehört gezeichnet, nicht nebenbei gemacht."
  fi
  echo "  Prüfdatei öffnet und schliesst keine eigene Transaktion -- die Klammer trägt."
}

# Zählt die Zeilen, in denen sich Prüfdaten niederschlagen würden.
pruefdaten_zaehlen() {   # $1 = Zieldatei
  local ziel="$1" rc
  set +e
  P -tA > "$ziel" 2>&1 <<'SQL'
SELECT 'tenant     ' || count(*) FROM tenant;
SELECT 'actor      ' || count(*) FROM actor;
SELECT 'membership ' || count(*) FROM membership;
SELECT 'invitation ' || count(*) FROM invitation;
SELECT 'fit_check  ' || count(*) FROM fit_check;
SELECT 'app        ' || count(*) FROM app;
SELECT 'event      ' || count(*) FROM event;
SQL
  rc=$?
  set -e
  [ "$rc" -eq 0 ] || abbruch \
    "Die Zeilen der Prüfdaten liessen sich nicht zählen (Rückgabewert $rc)." \
    "Ohne diese Zahl ist nicht zu sagen, ob Beleg 4 etwas in der Zieldatenbank" \
    "zurücklässt -- und dann ist Beleg 4 gesperrt, nicht bestanden." \
    "Antwort des Servers: siehe $ziel" \
    "Nächster Schritt: die Leserechte des Kontos auf tenant, actor, membership," \
    "invitation, fit_check, app und event prüfen."
}

# ---------------------------------------------------------------------
# Beleg 4 · Eingefrorene Prüffälle T0 bis T23
# ---------------------------------------------------------------------
sagen "Beleg 4 · Eingefrorene Prüffälle T0 bis T23"
klammer_tragfaehig "$ALT"
pruefdaten_zaehlen "$ZIEL/beleg4_zeilen_vorher.txt"
echo "  Zeilen vor Beleg 4: $(tr '\n' ' ' < "$ZIEL/beleg4_zeilen_vorher.txt" | sed 's/  */ /g')"
set +e
P -v pruefdatei="$ALT" -f "$KLAMMER" > "$ZIEL/t0_t23_ausgabe.log" 2>&1
rc=$?
set -e
lauf_pruefen "$rc" "$ZIEL/t0_t23_ausgabe.log" "Eingefrorene Fälle T0 bis T21"
# Die Schlusszeile der Klammer. Fehlt sie, hat die Prüfdatei die Sitzung
# vorzeitig beendet -- dann ist das ROLLBACK nie abgesetzt worden.
if ! grep -q '^-- KLAMMER: ROLLBACK abgesetzt' "$ZIEL/t0_t23_ausgabe.log"; then
  abbruch \
    "Die Klammer hat ihr Ende nicht erreicht -- das ROLLBACK ist nicht belegt." \
    "Woran es liegt: in $ZIEL/t0_t23_ausgabe.log fehlt die Schlusszeile" \
    "\"-- KLAMMER: ROLLBACK abgesetzt\". Die Prüfdatei hat die Sitzung vorzeitig" \
    "beendet (etwa durch \\quit) oder die Verbindung ist abgerissen." \
    "Wirkung: ob Prüfdaten in der Zieldatenbank stehen geblieben sind, ist damit" \
    "NICHT gemessen -- die Zählung nach Beleg 4 wird hier nicht mehr erreicht." \
    "Die Zählung VOR Beleg 4 steht in $ZIEL/beleg4_zeilen_vorher.txt; die Zahlen" \
    "von Hand dagegen zu halten sagt, ob die Datenbank noch brauchbar ist." \
    "Nächster Schritt: $ZIEL/t0_t23_ausgabe.log von unten lesen; die letzte" \
    "genannte Zeile der Prüfdatei sagt, wo es endete."
fi
grep -E "^T[0-9]+" "$ZIEL/t0_t23_ausgabe.log" \
  | awk -F'|' '{print ($2==$3?"OK      ":"ABWEICHT")" "$0}' \
  | tee "$ZIEL/t0_t23_ergebnis.txt"
if grep -q "ABWEICHT" "$ZIEL/t0_t23_ergebnis.txt"; then
  abbruch \
    "Ein eingefrorener Fall weicht ab." \
    "Die Fälle T0 bis T21 sind der eingefrorene Maßstab; weicht einer ab," \
    "hat sich das Verhalten geändert, nicht der Maßstab." \
    "Nächster Schritt: die Zeilen mit ABWEICHT in" \
    "$ZIEL/t0_t23_ergebnis.txt lesen."
fi
# Vollständigkeit, nicht nur Fehlerfreiheit: T0 bis T21 müssen JE GENAU
# EINMAL dastehen. Ein Fall, der gar nicht lief, fiele sonst nicht auf.
# Das Muster T${i}[^0-9] zählt T22 und T23 bewusst nicht mit -- sie
# brauchen das Ersatz-Setup weiter unten.
for i in $(seq 0 21); do
  n="$(grep -cE "T${i}[^0-9]" "$ZIEL/t0_t23_ergebnis.txt" || true)"
  if [ "$n" -ne 1 ]; then
    abbruch \
      "T${i} kommt ${n}-mal vor, erwartet wird genau einmal." \
      "Ein Fall, der nicht lief, ist nicht bestanden -- er ist nicht ausgeführt." \
      "Nächster Schritt: $ZIEL/t0_t23_ergebnis.txt lesen."
  fi
done
echo "T0 bis T21: je genau ein Ergebnis, keine Abweichung."

# T22/T23 · Das Setup der Altdatei kollidiert mit der Anlegeregel W01: die
# Datei legt eine Anwendung unmittelbar in IN_BEARBEITUNG an, die Regel
# verlangt die Entstehung auf DISCOVERY. Deshalb bricht dort die
# Transaktion nach T21 ab, und deshalb laufen T22 und T23 hier gesondert
# mit einem Ersatz-Setup. Wörtlich übernommen aus n2_lauf.sh:211-247 --
# es ist die Messung, und eine Messung wird nicht umgeschrieben.
set +e
P -tA > "$ZIEL/t22_t23_ausgabe.log" 2>&1 <<'SQL'
BEGIN;
INSERT INTO tenant(id,kind,name,customer_code,legal_space,invite_domain)
  VALUES ('22222222-2222-2222-2222-222222222222','CUSTOMER','Nordfracht','DE-NOF','DE','nordfracht.de')
  ON CONFLICT (id) DO NOTHING;
INSERT INTO fit_check(id,tenant_id,outcome,completed_at)
  VALUES ('cccccccc-0000-0000-0000-000000000001','22222222-2222-2222-2222-222222222222','GEEIGNET',now())
  ON CONFLICT (id) DO NOTHING;
-- Ersatz-Setup nach README: entsteht auf DISCOVERY (W01), dann Wechsel.
INSERT INTO app(id,tenant_id,project_no,name,journey_phase,fit_check_id,created_at)
  VALUES ('dddddddd-0000-0000-0000-000000000001','22222222-2222-2222-2222-222222222222',
          'DE-NOF_001_26','Eingangsrechnungen','ANGEBOT',
          'cccccccc-0000-0000-0000-000000000001',DATE '2026-03-02')
  ON CONFLICT (id) DO NOTHING;
UPDATE app SET lifecycle_state='IN_BEARBEITUNG'
  WHERE id='dddddddd-0000-0000-0000-000000000001';

-- T22 muss an ack_needs_seal scheitern, nicht an irgendetwas. Der
-- Ausnahmezweig liest die Meldung und meldet den Fall nur dann als
-- erwartet, wenn sie die vorgesehene Bedingung nennt (Massstab F07).
DO $t22$ BEGIN
  UPDATE app SET mitbestimmung_ack_at = now()
    WHERE id='dddddddd-0000-0000-0000-000000000001';
  RAISE NOTICE '%', 'T22 Bestaetigung ohne Siegel|Fehler|akzeptiert';
EXCEPTION WHEN others THEN
  IF SQLERRM LIKE '%ack_needs_seal%' THEN
    RAISE NOTICE '%', 'T22 Bestaetigung ohne Siegel|Fehler|Fehler';
  ELSE
    RAISE NOTICE '%', 'T22 Bestaetigung ohne Siegel|Fehler|falsche Regel: '||SQLERRM;
  END IF;
END $t22$;

UPDATE app SET sealed_at = now(), mitbestimmung_ack_at = now()
  WHERE id='dddddddd-0000-0000-0000-000000000001';
SELECT 'T23 Bestaetigung mit Siegel|1|' || count(*)::text
  FROM app WHERE mitbestimmung_ack_at IS NOT NULL
   AND id='dddddddd-0000-0000-0000-000000000001';
ROLLBACK;
SQL
rc=$?; set -e
lauf_pruefen "$rc" "$ZIEL/t22_t23_ausgabe.log" "Ersatz-Setup T22/T23"
grep -oE "T2[23] [^|]*\|[^|]*\|.*" "$ZIEL/t22_t23_ausgabe.log" \
  | awk -F'|' '{print ($2==$3?"OK      ":"ABWEICHT")" "$0}' \
  | tee "$ZIEL/t22_t23_ergebnis.txt"
# Genau zwei Zeilen, je eine je Fall. "Nicht leer" genügte nicht -- damit
# hätte die vorhandene T22-Zeile allein gereicht, auch wenn T23 gar nicht
# gelaufen wäre.
n_t22="$(grep -c "T22 " "$ZIEL/t22_t23_ergebnis.txt" || true)"
n_t23="$(grep -c "T23 " "$ZIEL/t22_t23_ergebnis.txt" || true)"
if [ "$n_t22" -ne 1 ] || [ "$n_t23" -ne 1 ]; then
  abbruch \
    "Erwartet wird je ein Ergebnis für T22 und T23, gefunden T22=$n_t22 T23=$n_t23." \
    "Nächster Schritt: $ZIEL/t22_t23_ausgabe.log lesen."
fi
if grep -q "ABWEICHT" "$ZIEL/t22_t23_ergebnis.txt"; then
  abbruch \
    "T22 oder T23 weicht ab." \
    "Nächster Schritt: $ZIEL/t22_t23_ergebnis.txt lesen."
fi
if grep -q "falsche Regel" "$ZIEL/t22_t23_ergebnis.txt"; then
  abbruch \
    "T22 ist an einer anderen Regel gescheitert als ack_needs_seal." \
    "Ein Fall, der an einer fremden Bedingung scheitert, ist ein bestandener" \
    "Test, der nichts misst. Maßstab ist F07 — die Festlegung, dass ein" \
    "Gegentest an SEINER EIGENEN Bedingung scheitern muss." \
    "Nächster Schritt: die Meldung in $ZIEL/t22_t23_ergebnis.txt lesen."
fi
echo "T22/T23 mit Ersatz-Setup ausgeführt und bestanden."

# Die Wirkungsprobe zu P0-3: nach Beleg 4 steht keine Zeile mehr, die
# vorher nicht schon da war. Gezählt wird über BEIDE Teile -- die
# geklammerte Prüfdatei UND das Ersatz-Setup für T22/T23, das seine eigene
# BEGIN … ROLLBACK-Klammer mitbringt.
pruefdaten_zaehlen "$ZIEL/beleg4_zeilen_nachher.txt"
echo "  Zeilen nach Beleg 4: $(tr '\n' ' ' < "$ZIEL/beleg4_zeilen_nachher.txt" | sed 's/  */ /g')"
if ! diff -u "$ZIEL/beleg4_zeilen_vorher.txt" "$ZIEL/beleg4_zeilen_nachher.txt" \
       > "$ZIEL/beleg4_zeilen_diff.txt" 2>&1; then
  abbruch \
    "Beleg 4 hat Prüfdaten in der Zieldatenbank zurückgelassen." \
    "Woran es liegt: vor und nach Beleg 4 wurden die Zeilen von tenant, actor," \
    "membership, invitation, fit_check, app und event gezählt -- die Zahlen" \
    "weichen ab. Welche, steht in $ZIEL/beleg4_zeilen_diff.txt." \
    "Wirkung: die Zieldatenbank trägt jetzt synthetischen Prüfbestand. Nach F36" \
    "wird in diesem Projekt nichts gelöscht; die Datenbank ist für einen" \
    "Pilotlauf verbraucht." \
    "Nächster Schritt: diesen Lauf verwerfen, auf einer frischen Datenbank" \
    "wiederholen und den Befund melden -- die Klammer $KLAMMER hat nicht gehalten."
fi
echo "Beleg 4 hat nichts hinterlassen: alle sieben Zählungen vorher = nachher."
zustand 4 "Eingefrorene Prüffälle T0 bis T23" "bestanden" \
  "T0 bis T21 je genau einmal ohne Abweichung; T22 und T23 mit Ersatz-Setup; \
Zeilen vorher = nachher ($(tr '\n' ' ' < "$ZIEL/beleg4_zeilen_nachher.txt" | sed 's/  */ /g;s/ *$//'))" \
  "\`t0_t23_ergebnis.txt\` · \`t22_t23_ergebnis.txt\` · \`beleg4_zeilen_diff.txt\`"

# ---------------------------------------------------------------------
# Beleg 5 · Objektzahlen
# ---------------------------------------------------------------------
sagen "Beleg 5 · Objektzahlen der Umgebung (für kanon.yaml -- erst danach, F6)"
P -tA <<'SQL' | tee "$ZIEL/objektzahlen.txt"
SELECT 'tabellen '  || count(*) FROM information_schema.tables  WHERE table_schema='public' AND table_type='BASE TABLE';
SELECT 'sichten '   || count(*) FROM information_schema.views   WHERE table_schema='public';
SELECT 'trigger '   || count(*) FROM pg_trigger WHERE NOT tgisinternal;
SELECT 'funktionen '|| count(*) || ' davon_mit_suchpfad ' || count(*) FILTER (WHERE proconfig IS NOT NULL)
  FROM pg_proc p JOIN pg_namespace n ON n.oid=p.pronamespace
 WHERE n.nspname='public' AND NOT EXISTS (SELECT 1 FROM pg_depend d WHERE d.objid=p.oid AND d.deptype='e');
SELECT 'enums '     || count(DISTINCT t.typname) FROM pg_type t JOIN pg_enum e ON e.enumtypid=t.oid;
SELECT 'rollen '    || count(*) FROM pg_roles WHERE rolname LIKE 'fr\_%';
SQL
if [ ! -s "$ZIEL/objektzahlen.txt" ]; then
  abbruch \
    "Die Objektzahlen sind leer geblieben." \
    "Ohne sie ist Beleg 5 nicht zu führen. Nach F6 — der Festlegung, dass die" \
    "Objektzahlen erst NACH der Messung in kanon.yaml nachgezogen werden —" \
    "hängt daran der nächste Schritt der Übergabe." \
    "Nächster Schritt: die Verbindung und die Leserechte des Kontos prüfen."
fi
zustand 5 "Objektzahlen gemessen" "bestanden" \
  "$(tr '\n' ' ' < "$ZIEL/objektzahlen.txt" | sed 's/  */ /g')" \
  "\`objektzahlen.txt\`"

sagen "FERTIG"
echo "Alle fünf Belege bestanden. Der Nachweis trägt Messwerte, keine Unterschrift."
echo "Nächster Schritt: gegentest_meldungen.txt LESEN, die Umgebung in NACHWEIS.md"
echo "eintragen, dann zeichnen lassen -- das tut ein Mensch, nicht dieses Skript."

# =====================================================================
# ENTSPERRT — 22.08.2026, nach Behebung und Messung
# =====================================================================
# Die drei P0 der Gegenpruefung vom 22.08.2026 sind behoben und gegen eine
# Rolle OHNE Superuser-Rechte gemessen (Belege: nachweise/kettenlauf/
# 260822_1847_alle_nicht_superuser):
#
#  P0-1  Der Frischetest prueft jetzt auch, ob eine der zu fahrenden
#        Migrationen bereits eingespielt ist, und es entsteht ein Abzug VOR
#        Lauf 1. Beleg 1 gilt nur als bestanden, wenn Lauf 1 etwas VERAENDERT
#        und Lauf 2 nichts mehr. Gemessen: erstlauf_schema_diff 135 796 Byte,
#        schema_diff 0 Byte. Gegenprobe gegen eine bespielte Datenbank:
#        "ABBRUCH: Die Datenbank ist NICHT frisch".
#
#  P0-2  Der Datenabzug laeuft mit --enable-row-security und kommt damit an
#        FORCE ROW LEVEL SECURITY vorbei, ohne die Vorrichtung anzufassen.
#        Gemessen als Rolle ohne SUPERUSER: Rueckgabewert 0.
#
#  P0-3  Beleg 4 laeuft in einer Klammer, die zurueckgerollt wird. Gemessen:
#        alle sieben Zaehlungen vorher = nachher, beleg4_zeilen_diff 0 Byte.
#
# WAS WEITER GILT: Dieser Lauf hat die ZIELUMGEBUNG nie gesehen. Er lief gegen
# ein lokales PostgreSQL 16. Ein Prueflauf, der durchlaeuft, ist kein Beweis
# ueber das Ziel -- das ist die Lehre von M30:2029-2031 und war heute schon
# zweimal der Fehler. Das Feld "War es die Zielumgebung?" in NACHWEIS.md
# bleibt deshalb leer, bis ein Mensch es ausfuellt.
