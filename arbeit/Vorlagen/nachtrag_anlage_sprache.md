# Zeichnungsfertiger Nachtrag zur Anlage „Bauverfahren"

**Wozu dieses Blatt da ist.** Die Vorgabe in `CONTRIBUTING.md` bindet heute die Menschen, die
in diesem Repository schreiben. Sie bindet den Harness selbst noch **nicht** — dafür müsste
sie in der gezeichneten Anlage „Bauverfahren" stehen, denn `CLAUDE.md` ist nur deren
ausführbare Fassung, und Änderungen fließen ausschließlich von der Anlage zur `CLAUDE.md`,
nie umgekehrt.

Dieses Blatt enthält den Text, der dafür in die Anlage aufzunehmen ist. Es ist ein
**Vorschlag zur Zeichnung**, keine Zeichnung.

---

## Was zu tun ist

1. Den Absatz unten in die Anlage „Bauverfahren" aufnehmen
   (`03_AGENT_HARNESS_CODING/30_DELIVERY_HARNESS/Anlage_Bauverfahren.md`).
2. Die Anlage zeichnen und den Zeichnungsnachweis fortschreiben.
3. Die **neue** Prüfsumme der Anlage berechnen: `shasum -a 256 <Anlage>`.
4. Diese Prüfsumme in den Kopf der `CLAUDE.md` eintragen und den Absatz dort in Abschnitt 5
   („Betriebsregeln") übernehmen.
5. `./install.sh --pruefsumme` ausführen. Erst wenn dieser Befehl **OK** meldet, redet der
   ausgeführte Text wieder über dieselbe Fassung wie der unterschriebene.

**Achtung, Reihenfolge:** Solange Schritt 3 und 4 nicht beide erledigt sind, weicht die
Prüfsumme ab. Die beiden Bau-Kommandos `/scheibe` (baut eine Scheibe) und `/pruefe` (misst,
ohne zu bauen) — eingegeben im Programm `claude` im Verzeichnis `~/freiraum-delivery` —
melden dann „Verfassung nicht belegt". Das ist die eingebaute Sperre und funktioniert wie
vorgesehen; sie darf nicht umgangen werden, indem man die Prüfung überspringt.

---

## Der aufzunehmende Absatz

> ### Verständlichkeit als Lieferbedingung
>
> Der Coding-Harness muss von einer Person **ohne IT-Hintergrund steuerbar und verständlich**
> sein. Wer freigibt, trägt das Risiko; wer das Risiko trägt, muss vorher verstanden haben,
> wofür. Ein Text, den nur sein Autor versteht, verlagert die Entscheidung heimlich zurück
> zum Autor und entwertet die menschliche Freigabe in Tor 4.
>
> **Das gilt für alles, was neu entsteht:** `README.md` und Dateien unter `doku/` ·
> Commit-Nachrichten · Issues · Pull Requests · Projekttafeln einschließlich ihrer Spalten-
> und Kartennamen · Agenten und Kommandos unter `.claude/` einschließlich ihrer
> Beschreibungen und Ausgaben · alle sichtbaren Namen wie Etiketten, Workflows, Prüfschritte
> und Zweignamen · alle Fehlermeldungen in Skripten und Prüfläufen. **Nicht** für den
> Quelltext selbst, seine Kommentare und SQL.
>
> **Die neun Regeln sind unten in Kurzfassung aufgenommen und damit Teil dieser Anlage.**
> Die ausführliche Arbeitsfassung steht in `CONTRIBUTING.md` als `SPR-1` bis `SPR-9`; sie
> erläutert, bindet aber nicht — bei Abweichung gilt der hier gezeichnete Wortlaut.
> Kurzfassung: Der erste Satz sagt, was sich in der Sache ändert · jede
> Kennung wird bei erster Nennung im selben Satz erklärt · Fachwörter werden erklärt oder
> ersetzt · die Reihenfolge ist Anlass, Änderung, Wirkung, was gleich bleibt · Zahlen statt
> Adjektive · der Text trägt ohne Gesprächsverlauf · behauptet wird nur, was gemessen wurde ·
> jede neue Bedienung hat einen Bedienpfad in Worten · Fehlermeldungen sagen, was zu tun ist.
>
> **Bestandsschutz.** Commits, Issues und Pull Requests, die vor Aufnahme dieses Absatzes
> entstanden sind, bleiben unverändert. Ein nachträgliches Umschreiben ist untersagt: Die
> Testmanifeste dieses Harness führen nach `CLAUDE.md` Abschnitt 4 als erstes Glied den
> Commit-Hash des geprüften Standes (erzeugt von `werkzeuge/manifest.py`, abgelegt unter
> `nachweise/manifeste/`). K23-M18 verlangt Laufkennung, Bau- und Schemafassung sowie die
> Prüfsummen aller Eingaben und Ergebnisse; eine umgeschriebene Historie vergibt neue Hashes
> und entwertet jeden bereits abgelegten Nachweis.
>
> **Rang.** Diese Bedingung erweitert den Bauumfang um nichts und schafft kein zusätzliches
> Abnahmetor. Ein Text, der ihr nicht genügt, wird überarbeitet. Er ist **nie** ein Anlass,
> einen Prüfwert zu senken, eine Schwelle zu lockern oder eine Einstufung herabzusetzen —
> das bleibt nach K23-D05 in jedem Fall untersagt.

---

## Herkunft

| | |
|---|---|
| Weisung | Auftraggeber, 14.08.2026 |
| Wortlaut der Weisung | *„der coding harness in github muss für einen low-it steuerbar und verständlich sein"* — sowie: gilt für README, Commits, Issues, Pull Requests, neue Projekte und neue Agenten; der Bestand ist ausgenommen |
| Umgesetzt in | `CONTRIBUTING.md` · `.gitmessage` · `.github/PULL_REQUEST_TEMPLATE.md` · `.github/ISSUE_TEMPLATE/` · `README.md` |
| Kennungsraum | `SPR-1` bis `SPR-9`. Die Räume `V-`, `C-` und `F-` sind belegt und wurden nicht benutzt |
| Vom Orchestrator | **übertragen, nicht selbsttätig gesetzt** |
