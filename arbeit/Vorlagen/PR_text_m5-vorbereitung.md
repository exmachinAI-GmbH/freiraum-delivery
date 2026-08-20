# Antragstext für den Pull Request `m5-vorbereitung` → `main`

**Anzulegen unter:** https://github.com/exmachinAI-GmbH/freiraum-delivery/pull/new/m5-vorbereitung
**Titel:** M5-Vorbereitung: Blatt 100 ausgeführt, 101 Kriterien gezeichnet, Bauauftrag §6a übertragen

*Der Harness konnte den Antrag nicht selbst stellen: `gh` ist auf diesem Rechner nicht
installiert. Der Text steht hier fertig zum Einfügen — anlegen und zusammenführen tut ohnehin
ein Mensch (CLAUDE.md Abschn. 6).*

---

## Was dieser Antrag enthält

**Die vollständige Vorbereitung des Meilensteins M5** — keine Zeile Anwendungscode. Gebaut wird
erst nach diesem Antrag; hier steht, **wogegen** gebaut wird.

### 1 · Blatt 100 ist ausgeführt (E1–E6)

- **E2** — 7 von 10 Befehlen sind reine Serverpfade; `journey_phase` wird heute **nirgends**
  geschrieben (gemessen, nicht geraten)
- **E3** — 35 mitwirkende Klauseln, **Nachtrag +10** aus K03/K17, die außerhalb des Suchraums
  lagen → **45**
- **E5** — **101 von 101 Akzeptanzkriterien gezeichnet**, jetzt auch im Register
- **E6** — `werkzeuge/blindstand.sh`, Sandbox statt sparse-checkout; zweimal am selben Tag
  berichtigt, beide Male durch Prüfung der eigenen Arbeit

### 2 · Acht Sperren, gemessen und entschieden

`arbeit/Vorlagen/m5_vor_dem_bauzug_260819.md` — 23 belegte Lücken, 8 sperrend, alle acht
Entscheidungen gezeichnet. Schwerster Befund: **RLS gibt es im Lieferstand nicht**, während der
Bildschirmvertrag sich für EN-06 wörtlich darauf beruft.

### 3 · Übertragen aus der Konzept-Fabrik

- `arbeit/Quellen/BAUAUFTRAG_v1.1_paragraph6_und_6a.md` — die zwölf Meilensteine im Wortlaut,
  Prüfsumme identisch mit Glied 2 der Nachweiskette
- `migrations/n2_lauf.sh` — das M1-Nachweisskript, das laut S3 „nicht im Repo" lag
- `migrations/uebernahme/M31__zeilenschutz_VORSCHLAG.sql` — **ein fertiges RLS-Regime**, 332
  Zeilen, nie übernommen
- `schema/pruefung_v2.9.sql` — Rang 4 der Quellenrangfolge, bis heute nicht mitgeführt

### 4 · Restrisiken

**RR-04** · **RR-05** · **RR-06** — jeder Eintrag sagt selbst, was er **nicht** leistet.

---

## Was dieser Antrag **nicht** ist

**Keine Freigabe, keine Abnahme, kein Bauzug.** Eine adversariale Prüfung mit drei Linsen hat am
19.08. abends widerlegt, dass der erste Bauzug erreicht sei. Sieben der acht Hürden sind
daraufhin erledigt worden; was bleibt, steht in `arbeit/Vorlagen/m5_bauzug_freigabe_260819.md`:
**drei Kreuze** und sieben Dinge, die jemand tun muss — Tor 3 anfordern ist das Nadelöhr.

**Tor 1 hat diese Commits noch kein einziges Mal gemessen.** Der Lauf löst erst mit diesem
Antrag aus; das ist sein wichtigster Zweck.
