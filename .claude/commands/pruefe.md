---
description: Misst einen bestehenden Stand gegen die Klauseln — ohne zu bauen
argument-hint: Scheibennummer, Klausel (K13-M07) oder "alles"
---

**Wie du schreibst.** Jeder Text, den dieser Lauf erzeugt — Bericht, Manifesttext, Befund —
folgt `CONTRIBUTING.md` (Regeln `SPR-1` bis `SPR-9`). Lies die Datei, bevor du den ersten
Text schreibst. Besonders `SPR-7`: Nur behaupten, was gemessen wurde, mit der Messung dabei.

Miss den **vorliegenden** Stand gegen $ARGUMENTS. **Dieses Kommando baut nicht.** Es
ändert keine Datei außer den Nachweisen unter `nachweise/` und dem Bericht unter
`arbeit/Bauberichte/`. Findest du einen Mangel, schreibst du ihn auf — du behebst ihn nicht.

1. **Verfassung prüfen.** `./install.sh --pruefsumme`. Weicht sie ab oder fehlt die Anlage:
   der Bericht trägt im Kopf **„Verfassung nicht belegt"**, und jedes Ergebnis gilt als
   *gesperrt* (K23-M22).

2. **Prüfgegenstand bestimmen.** Notiere und friere ein: Commit-Hash (`git rev-parse HEAD`),
   Arbeitsbaum sauber ja/nein, Migrationsstand, Umgebung. Ein unsauberer Arbeitsbaum wird
   im Bericht ausgewiesen — gemessen wird trotzdem, aber der Gegenstand ist dann nicht
   der Commit.

3. **Klauseln schneiden.** Aus `nachweise/klauselregister/register.json`:
   - Scheibennummer → die Klauseln dieser Scheibe (**Zuordnung existiert noch nicht**)
   - Klauselnummer → genau diese eine
   - `alles` → alle 1231 Zeilen; das ist ein langer Lauf, kündige ihn an
   Zeilen **ohne Akzeptanzkriterium** werden nicht bewertet, sondern als
   *nicht bewertbar — Akzeptanzkriterium fehlt (K23-M02)* geführt.

4. **Prüffälle zuordnen.** Je Klausel: welcher Prüffall unter `pruefungen/` belegt sie?
   Ohne Prüffall trägt das Feld den Vermerk *kein Test — Restrisiko*; die Zeile bleibt
   gültig, die Klausel geht einzeln in die Restrisikoliste (K23-M02 :57, K23-M04 :59).
   Ist sie sicherheits-, mandanten-, freigabe-, aufbewahrungs- oder
   wiederherstellungskritisch, **sperrt** der fehlende Test die Freigabe (K23-M04).

5. **Messen, nicht raten.** Führe die zugeordneten Prüffälle gegen eine **frische**
   Umgebung mit synthetischen Daten aus (K23-M12). Was du nicht ausführen kannst, ist
   *nicht ausgeführt* oder *gesperrt* — niemals *bestanden*.

6. **Die fünfzehn Gates aus K23 Abschn. 6 einzeln durchgehen.** Je Gate: schlägt an /
   schlägt nicht an / nicht messbar. „Nicht messbar" ist ein Befund, kein Häkchen.
   Zu Gate 14 gilt die Zwischenregel aus K23:260–263, solange O-K23-1 offen ist.

7. **Bericht schreiben** nach `arbeit/Bauberichte/pruefung_<JJMMTT>_<Gegenstand>.md`:

   | Klausel | Art | Akzeptanzkriterium | Prüffall | Zustand | Evidenz |

   Zustände ausschließlich: bestanden · fehlgeschlagen · gesperrt · nicht ausgeführt
   (K23-M22). Dazu: Gate-Tabelle · Abweichungen gegen die Rangfolge · Restrisiken mit
   Träger und Frist · **Offene / nicht belegbar**.

8. **Register fortschreiben.** Teststand, Ergebnis und Evidenzverweis je gemessener
   Klausel in `nachweise/klauselregister/pflege.json`. Nur diese Felder — Wortlaut,
   Herkunft und Dokumentversion kommen aus der Quelle und werden nie von Hand gesetzt.
   Die Kritikalität setzt der fachliche Eigentümer, nicht der Harness (K23-G08 :106).

**Nie:** einen Mangel im selben Zug beheben · einen Prüfwert an den Stand anpassen ·
eine Kritikalität herabstufen, damit weniger sperrt (K23-D05, K23-G08) · eine
Abdeckungsquote als Freigabegrund melden (K23-D04 :87, F34) · gegen die Zielumgebung oder
mit produktiven Identitäten messen (K23-D10 :93).
