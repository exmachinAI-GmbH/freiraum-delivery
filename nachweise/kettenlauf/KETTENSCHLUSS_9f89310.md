# Kettenschluss · Die eingespielten Dateien sind der Inhalt von `9f89310`

**Angelegt am 22.08.2026**, weil das dritte Fremdurteil den letzten offenen Punkt so benannt hat:

> „Der Laufnachweis nennt zwar SHA-256-Werte der vier SQL-Eingänge, zeigt aber nicht, dass genau
> diese Hashes dem Inhalt von Commit `9f89310` entsprechen."

Der Einwand trifft. Ohne diesen Schritt sagt der Nachweis nur, *dass* vier Dateien mit
bestimmten Prüfsummen eingespielt wurden — nicht, dass es **die** vier Dateien des
Abnahmestandes waren.

---

## Nachgerechnet

```
git show 9f89310:<pfad> | sha256sum
```

| Datei im Abnahmestand `9f89310` | SHA-256 | im Laufnachweis |
|---|---|---|
| `schema/freiraum_datamodel.sql` | `cb37d5fe6ef7652458eb6f6cf2b201400aa6e5ff61b2396800bf5b4e48e46e96` | **gleich** |
| `migrations/M30__pilot_sammelmigration.sql` | `1af077c540f910d3871ad3b459c5bdeff51034274cbb6b680c065eb3fd2fac4d` | **gleich** |
| `migrations/M31__projektnummer_und_zweckbestimmung.sql` | `d7fedad9d89352308a68bf0a9df3ba8b17b7b62ff43b7e19813479d2bdc8fb79` | **gleich** |
| `migrations/M32__zeilenschutz_und_stufenwechsel.sql` | `6bac64bda3f021eaaf0ccf911474edada044cae81b41de6dd1a532b895633522` | **gleich** |

**Vier von vier stimmen überein.** Der Lauf vom 22.08.2026 um 21:29 Uhr hat genau die Dateien
eingespielt, die im Abnahmestand stehen.

---

## Welche Blätter ausserhalb von `9f89310` liegen

Das Fremdurteil verlangt zu Recht, sie zu benennen. Es sind drei, alle **nach** dem Lauf
entstanden und keine Eingabe in ihn:

| Blatt | Was es ist |
|---|---|
| `nachweise/kettenlauf/SOLL_zielbestand_M1.md` | die Sollseite — was „Zielbestand" bedeutet |
| `nachweise/kettenlauf/AUFLAGEN_M1_260822.md` | die drei getragenen Auflagen, gezeichnet |
| `nachweise/kettenlauf/KETTENSCHLUSS_9f89310.md` | dieses Blatt |

**Keines davon verändert den gemessenen Zustand.** Sie beschreiben ihn, ordnen ihn ein und
tragen, was offen bleibt. Der Abnahmestand für die **Messung** ist und bleibt `9f89310`.

---

## Was damit weiterhin nicht belegt ist

Das Fremdurteil nennt vier Dinge, die es *„nicht beurteilen kann"*. Drei davon bleiben offen
und sind hier festgehalten, damit sie nicht als geschlossen gelesen werden:

| | |
|---|---|
| **Die aktive Sitzung** | Kein Rohbeleg der Verbindung — Server, Datenbank, Rolle und SSL stehen im Nachweis, sind aber nicht durch eine Serverabfrage aus dem Lauf selbst belegt |
| **Der Rollenstatus** | Kein Rollenabzug zum Laufzeitpunkt. Dass `frxadmin` kein SUPERUSER ist, steht im gezeichneten Nachweis vom 06.08.2026 — nicht in diesem Lauf |
| **Der Umfang der Abzüge** | Die `pg_dump`-Aufrufe und ihre Filter liegen nicht bei. Ob der leere Vergleich **alle** zustandsrelevanten Objektarten erfasst, ist damit nicht unabhängig prüfbar |

**Drei Zeilen, die der nächste Abnahmelauf mitschreiben sollte** — `SELECT current_database(),
current_user, version()`, `SELECT rolsuper FROM pg_roles WHERE rolname = current_user` und die
verwendeten `pg_dump`-Aufrufe im Wortlaut. Das kostet nichts und schliesst drei Lücken auf
einmal.

---

*Angelegt vom Orchestrator, nachdem ein Fremdmodell den Punkt benannt hat. Die Prüfsummen sind
nachgerechnet, nicht abgeschrieben.*
