# 20_PILOT · Pilot-Anläufe

**Status:** noch nicht begonnen. Startet erst, wenn B1–B3 abgenommen sind.

Je Anlauf ein Ordner (`anlauf_01`, `anlauf_02`, …) und eine **eigene Datenbank** —
`sealed` ist unumkehrbar (K20-M21), nach F36 wird nichts gelöscht; ein misslungener Anlauf
hinterlässt dauerhaften Bestand.

Grundlage je Anlauf: `Pilot-Drehbuch_Retail-Banking.md` (207 Schritte, 110 Fehlerpfade),
Testmandant `DE-ZAA`, Laufzeit **mindestens zwei Kalendertage** (K11-M21 sperrt zwei
Zustandswechsel am selben Kalendertag).

Je `anlauf_XX/` gehören hierher: Durchführungsprotokoll, Befundliste, Evidenzen
(u. a. die vier Negativfälle der `Migration_260801_tenant.sql` — alle müssen scheitern —
und die Vier-Augen-Nachweise je Seed-Baustein nach K14).
