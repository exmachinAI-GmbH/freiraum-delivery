# Übernahmekandidaten aus der N2-Übergabe — **noch nicht in Kraft**

**Übertragen am 19.08.2026** auf die Weisung: *„lese auch den Bauauftrag gem. §6 … wenn dieser
in der Konzeptfabrik liegt, übertrage diesen in den Coding Harness."*

## Was hier liegt und warum

| Datei | Was sie ist |
|---|---|
| `M31__zeilenschutz_VORSCHLAG.sql` | **Das vollständige Zeilenschutz-Regime (RLS)** — 332 Zeilen, idempotent, aus der N2-Übergabe der Konzept-Fabrik |
| `M31__zeilenschutz_pruefung_VORSCHLAG.sql` | die zugehörige Prüfung: je erlaubter Kombination ein Positivfall, je verbotener ein Negativfall, dazu Dienstschlüssel und ungesetzter Mandant |

**Die Datei sagt über sich selbst** (Zeile 5 f.):

> *„VORSCHLAG ZUR UEBERNAHME, kein Liefergegenstand. Der Bauauftrag weist L1 dem Auftragnehmer
> zu. Diese Datei nimmt ihm die Arbeit nicht ab, sondern legt sie ihm daneben — dasselbe Muster,
> das M30 gegenüber `freiraum_datamodel.sql` einhält. Er übernimmt sie, ändert sie oder ersetzt
> sie; die Abnahme nach L1 bleibt unberührt."*

## Warum das die Lage von S-A ändert

Der Befund vom 19.08.2026 lautete: **im Repo gibt es kein einziges `ENABLE ROW LEVEL SECURITY`
und kein `CREATE POLICY`** — und `M30:1713` hält fest, die Zeilenregeln seien *„Punkt 09 und
bleiben offen"*. Beides stimmt für den **Lieferstand**. Es stimmt nicht für die **Vorarbeit**:
sie lag fertig in der Übergabe und ist nie übernommen worden.

Gezeichnet ist am 19.08. (Entscheidung 1) der **mittlere Weg**: Zeilenregeln für die drei
Tabellen, die M5 anfasst — `app`, `document`, `event`. Dieser Vorschlag geht weiter; er deckt
den ganzen Bestand. **Was hier liegt, ist deshalb Rohstoff, nicht die Umsetzung.**

## Drei Befunde, die der Vorschlag selbst mitbringt

Sie stehen im Text an Ort und Stelle und sind beim Übernehmen zu entscheiden:

- **B-1** `login_attempt` trägt Personendaten ohne Mandantenbezug
- **B-2** `nummernvorrat` verrät Kundenpräfixe und lässt sich nicht zeilenweise filtern
- **B-3** Es sind **zwölf** Sichten, nicht elf, und vier Tabellen erreichen den Mandanten erst
  über **zwei** Fremdschlüssel

## Der Namenskonflikt — und wie er aufgelöst wird

Die Übergabe nennt die Datei `M31`. Im Lieferstand ist **M31 vergeben**
(`M31__projektnummer_und_zweckbestimmung.sql`, Scheibe M4). Die Übernahme läuft deshalb als
**M32**; die Dateien hier behalten ihren Herkunftsnamen mit dem Zusatz `_VORSCHLAG`, damit
Quelle und Umsetzung nie verwechselt werden.

## Was noch fehlt, bevor Zeilenregeln überhaupt wirken

**Der Serverpfad verbindet sich heute als Eigentümer der Tabellen** — gemessen: kein einziges
`SET ROLE`, kein Treffer für `fr_portal` in `app/`, `install/`, `mail/`, `werkzeuge/`. Für den
Eigentümer gilt RLS nicht, solange nicht `FORCE ROW LEVEL SECURITY` gesetzt ist. Und
`freiraum.tenant_id` wird von **keinem** Serverbefehl gesetzt; der gebaute Wächter
`sitzungs_mandant()` lässt bei ungesetztem Wert ausdrücklich durch (`M30:2166–2172`).

**Beides gehört in denselben Zug wie die Übernahme.** Ein eingespieltes Regime, an dem der
Serverpfad vorbeiläuft, ist die schlechteste aller Lagen: es sieht aus wie ein Schutz und ist
keiner.

---

*Die Prüfsummen der übernommenen Dateien liegen daneben (`.sha256`), gemessen beim Übertragen.
Geändert wurde an den Dateien nichts.*
