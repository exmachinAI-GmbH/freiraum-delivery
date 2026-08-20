# Scheibe 4 · M5 — Entscheidung 2: Serverbefehl oder Serverpfad?

**19.08.2026 · erster Arbeitsschritt nach der Zeichnung von Blatt 100**

Blatt 100, Entscheidung 2 (gezeichnet 19.08.2026): *„Je Befehl wird vor dem ersten Bauzug
bestimmt, ob er Schema braucht — daraus ergibt sich der Migrationszuschnitt."*

## Das Ergebnis in einem Satz

**M5 braucht keine einzige neue Tabelle — aber eine neue Funktion.** Sieben der zehn Befehle
sind reine Serverpfade auf vorhandenem Schema; zwei brauchen einen neuen Schreibweg, weil es
zum Stufenwechsel heute **keinen gibt**; der zehnte ist nach Entscheidung 4 zurückgestellt.

> **Berichtigt am 19.08.2026, noch vor dem ersten Bauzug.** Die erste Fassung dieses Papiers
> stufte `confirm_app_name` und `complete_interview` als reine Serverpfade ein, mit dem
> Hinweis „ruft `change_app_state`". Das ist falsch: `change_app_state` setzt
> `lifecycle_state`, **nicht** `journey_phase`. Gemessen — siehe unten — gibt es überhaupt
> keinen Weg, `journey_phase` zu setzen. Der Fehler ist derselbe wie beim Migrationszuschnitt
> der ersten Planfassung: **eine Funktion nach ihrem Namen beurteilt, statt ihren Rumpf zu
> lesen.**

## Warum — die Klausel sagt es wörtlich

**K05-M25:** *„Der fachliche Gesprächsstand wird als unveränderlicher, strukturierter
Dateistand mit `document_kind = INTERVIEW_PROTOCOL` geführt. `document` (Eigentümer K10)
registriert die Datei … **K05 besitzt weiterhin keine Tabelle.**"*

**K05-M26** beschreibt den Dreischritt je Speichervorgang und zugleich den Wiederaufnahmestand:

> Datei → `document`-Zeile → append-only `event`. *„Der jüngste erfolgreiche Eventeintrag je
> Anwendung verweist in `object_ref` auf Dokument-ID und Hash und bestimmt den
> wiederaufnehmbaren Stand. Ein unvollständiger Dreischritt wird nicht sichtbar."*

Damit ist **M5 selbst** — *abbrechen, neu anmelden, weitermachen* — vollständig aus
vorhandenen Bausteinen erklärt.

## Gemessen: das Schema trägt es bereits

| gebraucht (K05-M26) | vorhanden in `freiraum_ci` |
|---|---|
| Dokumentregistrierung | `document` · `kind = INTERVIEW_PROTOCOL` steht im Enum |
| unveränderliche Stände | `document_version` + Wächter `document_version_unveraenderlich_trg` |
| Protokolleintrag | `event` mit `object_ref`, `document_id`, `document_version` |
| Herkunft des Eintrags | `event.source` = `PORTAL_ACTION` |
| Append-only | Wächter `event_append_only` |
| Mandantenableitung (K05-M27) | `document.app_id → app.tenant_id` |
| Stufenwechsel | `change_app_state`, `app.journey_phase` (fünf Werte) |

## Die Einteilung je Befehl

| # | Befehl | Bildschirm | Einstufung |
|---|---|---|---|
| 1 | `record_topic` | EN-05 | **Serverpfad** — Beitrag in neue Protokollrevision |
| 2 | `record_classification` | EN-05 | **Serverpfad** — dito, drei Antworten in fester Reihenfolge |
| 3 | `record_goals` | EN-05 | **Serverpfad** — dito, Rang = Klickreihenfolge (K05-G04) |
| 4 | `confirm_initial_problem` | EN-05 | **Serverpfad** |
| 5 | `confirm_app_name` | EN-05 | **braucht Schema** — setzt `app.name` *und* `journey_phase` ORIENTIERUNG → INTERVIEW; für beides fehlt der Schreibweg |
| 6 | `record_interview_answer` | EN-06 (2 Aktionen) | **Serverpfad** — Marke *Ihre Angabe* / *KI-Notiz* (K05-M11) |
| 7 | `skip_interview_question` | EN-06 | **Serverpfad** — Vermerk ohne Marke (K05-M10) |
| 8 | `save_interview_progress` | EN-06 | **Serverpfad** — der Stand liegt bereits nach jedem Beitrag fest |
| 9 | `complete_interview` | EN-06 | **braucht Schema** — `journey_phase → UEBERSICHT` (K05-M19); derselbe fehlende Schreibweg |
| 10 | `upload_interview_document` | EN-06 | **zurückgestellt** — Blatt 100, Entscheidung 4 |

## Gemessen: der Stufenwechsel hat keinen Weg

Am 19.08.2026 gegen die neu gebaute Vorlage `freiraum_ci`:

| Frage | Messung |
|---|---|
| Rechte von `fr_portal` auf `app` | **nur `SELECT`** — auf jeder einzelnen Spalte, auch `name` und `journey_phase` |
| Funktionen, die `fr_portal` ausführen darf | genau zwei: `change_app_state`, `create_app_after_fit` |
| Was `change_app_state` tut | `UPDATE app SET lifecycle_state = p_ziel` — **`journey_phase` kommt darin nicht vor** |
| `UPDATE … journey_phase` in den Migrationen | **kein Treffer** |
| `journey_phase` im Anwendungscode | **kein Treffer** |

**`journey_phase` wird heute nirgends geschrieben.** Das Feld existiert mit fünf Werten
(ORIENTIERUNG, INTERVIEW, UEBERSICHT, PROTOTYP, ANGEBOT), und kein Weg führt hinein.

## Was daraus folgt — und was nicht

**Es bleibt bei genau einer Migration — aber mit anderem Inhalt als geraten.** Die erste
Planfassung nannte „M33" für neue Tabellen. Tabellen braucht es nicht (K05-M25). Gebraucht
wird eine **Funktion** nach dem Muster von `change_app_state`: serverseitig, `SECURITY
DEFINER`, mit fester Suchpfadangabe, mit Rechteprüfung, mit `GRANT EXECUTE` an `fr_portal` —
und mit dem Protokolleintrag aus K05-M08 und K05-M19 **im selben Zug**.

Der Unterschied ist nicht kosmetisch: Eine Migration, die Tabellen anlegt, hätte K05-M25
gebrochen (*„K05 besitzt weiterhin keine Tabelle"*).

**Blatt 99, Entscheidung 1 fällt mit dieser Migration zusammen.** Gezeichnet am 19.08.2026:
`change_app_state` schreibt die `event`-Zeile künftig atomar mit, **vor dem ersten Aufruf in
M5**. Gemessen: `change_app_state` schreibt heute **keine** `event`-Zeile — der Rumpf endet
mit `UPDATE app SET lifecycle_state`. Beide Umbauten betreffen dieselbe Stelle und dieselbe
Klausellage (K01-M28, K02, K05-M08). Sie gehören in **einen** Migrationszug, nicht in zwei.

**Offen und vom Bau zu entscheiden:** eine Funktion für beide Stufenwechsel oder je eine.
K05-M08 und K05-M19 beschreiben unterschiedliche Nachbedingungen (M08: Rücknahme bei
Fehlschlag, kein Teilwechsel; M19: zusätzlich Übergabe an K06).

## Ein offener Punkt, der vor dem Bauzug zu klären ist

**Wo liegt die Protokolldatei?** K05-M27 verlangt *„nicht erratbare Schlüssel"* und Zugriff
*„nur über kurzlebige, serverseitig autorisierte Zugriffe"*. `document.content_ref` ist ein
Verweis — die Ablage dahinter ist nicht bestimmt.

Das ist **nicht** dasselbe wie die sieben Festlegungen zum Dateianhang (Blatt 100,
Entscheidung 4): Schadsoftware- und Aktivinhaltsprüfung entfallen hier, weil der Inhalt vom
Server selbst erzeugt wird. Zu entscheiden bleiben **Ablageort, Schlüsselvergabe,
Zugriffsdauer und Aufbewahrung** — und das gilt auch für die erste Stufe ohne Anhang.

## Antwortlisten

**O-K05-6 ist geschlossen** (*„versionierte Konfigurationsdaten; jede Frage behält
Andere …"*, Vorlage K05). Zwölf Themen, drei Einordnungsfragen, sieben Ziele. Ob sie als
`seeds/` oder als Tabelle kommen, ist eine Bauentscheidung ohne Klauselzwang — Empfehlung:
`seeds/`, weil sie versioniert mit dem Stand wandern und keine Laufzeitpflege brauchen.
