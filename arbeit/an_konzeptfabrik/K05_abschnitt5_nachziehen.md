# Für die Konzept-Fabrik · K05 Abschnitt 5 widerspricht Abschnitt 8

**Vorgelegt 19.08.2026 · Entscheider: M. Veil (Eigentümer Konzept-Fabrik)**
**Zieldatei:** `03_KONZEPTE_v2.9/concepts-md/260801_FREIRAUM_K05_*.md`

## Der Widerspruch

| Zeile | Abschnitt | Aussage |
|---|---|---|
| **244** | 5 · Daten | Thema, Branche, …, Herkunftsmarke, Übersprungvermerk → **„kein Träger belegt"** · **offen — O-K05-1, O-K05-2** |
| **343** | 8 · Offene Punkte — **durch Reviewentscheidungen geschlossen** | O-K05-1/2/5 → *„Strukturierter `INTERVIEW_PROTOCOL`-Dateistand mit Beitragsherkunft; `document` plus `event` tragen Registrierung und Revisionszeiger"* · **geschlossen** |

Abschnitt 8 trägt die spätere Entscheidung; Abschnitt 5 ist nicht nachgezogen worden.

## Warum das jetzt auffällt

**K05-G12** knüpft eine Sperre an genau diese beiden Punkte:

> *„Es GILT: Solange O-K05-1 und O-K05-2 offen sind, bleibt K05 Freigabekandidat. Für
> Gesprächsinhalt und Herkunftsmarke fehlt der belegte Träger; der Produktivweg bleibt
> gesperrt."*

Und **K05-G11** verbietet ausdrücklich, das stillschweigend zu übergehen:

> *„…eine dort als offen ausgewiesene Zeile ist kein stillschweigend angenommener Träger."*

Wer beim Bau von M5 nur Abschnitt 5 liest, hält den Produktivweg für gesperrt. Wer nur
Abschnitt 8 liest, hält ihn für frei. Beide berufen sich auf dieselbe Klausel.

## Was der Harness gemessen hat

Der in Abschnitt 8 benannte Träger **existiert im Schema** (Stand 19.08.2026,
`freiraum_ci` nach `./aufbau.sh --ci`):

| verlangt | vorhanden |
|---|---|
| Dokumentregistrierung, `kind = INTERVIEW_PROTOCOL` | `document`, Wert im Enum vorhanden |
| Revisionszeiger, unveränderlich | `document_version` (`version`, `erfasst_am`, `content_sha256`) + Wächter `document_version_unveraenderlich_trg` |
| Protokolleintrag mit Zeiger auf Dokument und Hash | `event` (`object_ref`, `document_id`, `document_version`) + Wächter `event_append_only` |
| Herkunft des Eintrags | `event.source` mit genau zwei Werten `PORTAL_ACTION`, `MODEL_CHANGE` |

Die Schließung aus Abschnitt 8 ist also nicht nur beschlossen, sondern auch gedeckt.

## Vorschlag

Zeile 244 in Abschnitt 5 nachziehen, etwa:

> | Thema, Branche, Funktionsbereich, Anwendung, Ziele mit Rang, Ausgangsproblem, Antworten
> des Interviews, Herkunftsmarke, Übersprungvermerk | `document` (`kind = INTERVIEW_PROTOCOL`,
> Eigentümer K10) plus `document_version` und `event` (Eigentümer K02) | **geschlossen** —
> O-K05-1/2/5, Abschn. 8 |

Und in **K05-G12** die erste Bedingung streichen oder als erfüllt kennzeichnen. Die zweite
Sperre bleibt davon unberührt: der Stimmweg ist über **K05-D12** weiterhin gesperrt, bis ein
bewerteter Fall nach **F31** vorliegt.

## Was der Harness nicht tut

Er ändert die Datei nicht. `CLAUDE.md` Abschn. 6: keine Datei in der Konzept-Fabrik anfassen.
Der Grund ist Rang, nicht Vorsicht — dürfte der Bauende das Konzept fortschreiben, schriebe er
seinen eigenen Auftrag.
