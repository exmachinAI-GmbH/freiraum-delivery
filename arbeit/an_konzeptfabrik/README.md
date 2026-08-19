# An die Konzept-Fabrik · der Übergabeordner

**Hier liegt, was in der Konzept-Fabrik entstehen muss und was der Harness dort nicht selbst
schreiben darf.**

## Warum es diesen Ordner gibt

`CLAUDE.md` Abschn. 6 führt *„Eine Datei in der Konzept-Fabrik oder in `v2.9_PIVOT/`
verändern"* unter dem, was nie getan wird. Am 18.08.2026 hat der Orchestrator die Regel
gebrochen — F41 in `config/kanon.yaml` eingetragen — und die Datei sofort byte-identisch
wiederhergestellt.

**Beide Founder haben die Regel daraufhin ausdrücklich bestätigt** (Entscheidung 2 vom
18.08.2026, gez. M. Veil und A. Han), mit der Auflage, die Übergabe zu mechanisieren statt sie
zu lockern.

**Der Grund ist nicht Vorsicht, sondern Rang.** `config/kanon.yaml` ist Rang 0 — die Regeln,
nach denen gebaut wird. Dürfte der Bauende sie fortschreiben, schriebe er seine eigene
Verfassung.

## Wie es benutzt wird

Jede Datei hier trägt im Kopf, **wohin** ihr Inhalt gehört und **an welche Stelle**. Einfügen
tut ein Mensch. Danach kann die Datei hier gelöscht werden — sie ist eine Übergabe, kein
Nachweis.

| Datei | Ziel | Stelle |
|---|---|---|
| `01_F41_kanon.yaml.txt` | `config/kanon.yaml` (Konzept-Fabrik) | unter `festlegungen`, hinter F40 |
| `02_F42_kanon.yaml.txt` | `config/kanon.yaml` (Konzept-Fabrik) | unter `festlegungen`, hinter F41 |
| `03_EN-04a_kasten.md` | `260801_FREIRAUM_K19_Build-Referenz_v1.3.md` | hinter EN-04, Z. 251 |

## Nach dem Einfügen

**Bei `03` sagen Sie dem Orchestrator Bescheid.** Er zieht die Kopie
`schema/K19_build_referenz.md` neu und rechnet die Prüfsumme nach — sonst wird Tor 1a rot,
weil die Kopie von ihrer Summe abweicht. Danach fällt `EN-04a` von GESPERRT auf messbar.

**Bei `01` und `02`** ändert sich am Lauf nichts; die Durchsetzung steht bereits. Es fehlt nur
der Rang.

## Was hier nicht hineingehört

Nachweise, Befunde, Blätter. Die entstehen in der Entscheidungsakte, nicht hier. Dieser Ordner
führt ausschließlich **Text, der anderswo hingehört**.
