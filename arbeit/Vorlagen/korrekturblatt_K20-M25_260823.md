# Korrekturblatt K20-1 · K20-M25 und O-K20-4 — `retention_class`

**23.08.2026 · Nach §12.4 des Bauauftrags · ⟨ENTWURF · NICHT VOLLZOGEN⟩**

| | |
|---|---|
| **Gegenstand** | Konzept **K20 · Zugänge und Nutzer (EXMA)**, Fassung **v1.3** vom 01.08.2026, freigegeben (Vier-Augen: M. Veil, 01.08.2026) |
| **Datei** | `03_KONZEPTE_v2.9/concepts-md/260801_FREIRAUM_K20_Zugaenge-und-Nutzer-EXMA_v1.3.md` — **in der Konzept-Fabrik** |
| **Anlass** | Fremdreview vom 20.08.2026, Grund 7 · gezeichnete Entscheidung Weg B vom 23.08.2026 |
| **Vollzug durch** | einen Menschen. Der Harness schreibt in der Konzept-Fabrik nicht |

---

## Feld 1 · Kennung und Gegenstand

**K20-1** — `retention_class` des Zugangsnachweises: `BETRIEBSPROTOKOLL` → `EREIGNIS`.
**Zwei Stellen** im selben Dokument: die Klausel K20-M25 (Abschnitt 7a) und der geschlossene
offene Punkt O-K20-4 (Abschnitt 8).

## Feld 2 · Befund — warum geändert wird

Das Konzept verlangt für den Nachweis einer Zugangsänderung `retention_class =
BETRIEBSPROTOKOLL`. Die **Sammelmigration M30** setzt seit dem 04.08.2026 den Vorgabewert der
Tabelle `event` auf `EREIGNIS`:

| Fundstelle | Inhalt |
|---|---|
| `migrations/M30__pilot_sammelmigration.sql:70` | `ALTER TYPE retention_class ADD VALUE IF NOT EXISTS 'EREIGNIS'` |
| `…:1487` | `EREIGNIS` — *„Unveraenderbare Ereigniszeilen (Protokoll)"* |
| `…:1493` | `ALTER TABLE event ALTER COLUMN retention_class SET DEFAULT 'EREIGNIS'` |
| `schema/freiraum_datamodel.sql`, Tabelle `event` | führt daneben weiterhin `DEFAULT 'BETRIEBSPROTOKOLL'` |

Grundlage der Umstellung ist **Founder-Beschluss Nr. 60, Option A** (*„Beweiswert vor
Löschzusage"*, zusammen mit Nr. 16).

**Der Widerspruch steht nicht zwischen zwei Meinungen, sondern in zwei Dateien.** Der Bau hat
ihn erkannt und ausdrücklich **nicht** entschieden — `app/einladung_senden.py:291`:

> *„K20-M25 nennt fuer den Nachweis einer Zugangsaenderung BETRIEBSPROTOKOLL; M30 hat die
> Vorgabe der Tabelle am 04.08.2026 auf EREIGNIS umgestellt … Zwei Quellen, ein Widerspruch —
> er wird gemeldet, nicht hier entschieden."*

**Aufgelöst nach der Rangfolge des Hauses:** Rang 0 sind Festlegungen und gezeichnete
Founder-Beschlüsse, Rang 1 das Datenmodell samt Sammelmigration M30. Eine Konzeptklausel steht
darunter. **Also wird die Klausel nachgezogen, nicht der Code gebogen.**

## Feld 3 · Alter Wortlaut

**Stelle 1 — Abschnitt 7a, Zeile K20-M25:**

```
| K20-M25 | Wiederversand zeigt: *Der vorherige Link ist ungültig.* Der Nachweis einer
Zugangsänderung trägt `retention_class = BETRIEBSPROTOKOLL`; personenbezogene Anzeige wird
nach K15 minimiert. |
```

**Stelle 2 — Abschnitt 8, Zeile O-K20-4:**

```
| O-K20-4 | Zugangsnachweis trägt BETRIEBSPROTOKOLL | geschlossen · K15-Anwendung |
```

## Feld 4 · Neuer Wortlaut

**Stelle 1:**

```
| K20-M25 | Wiederversand zeigt: *Der vorherige Link ist ungültig.* Der Nachweis einer
Zugangsänderung trägt `retention_class = EREIGNIS` (Founder-Beschluss Nr. 60, Option A;
Vorgabewert der Tabelle `event` seit M30 vom 04.08.2026); personenbezogene Anzeige wird nach
K15 minimiert. |
```

**Stelle 2:**

```
| O-K20-4 | Zugangsnachweis trägt EREIGNIS (Nr. 60, Option A) | geschlossen · K15-Anwendung |
```

## Feld 5 · Betroffene Stellen, einzeln

| Nr. | Datei | Abschnitt | Ankerzitat — daran wird gefunden, nie an der Zeilennummer |
|---|---|---|---|
| 1 | `…K20…v1.3.md` | 7a | `` Der Nachweis einer Zugangsänderung trägt `retention_class = BETRIEBSPROTOKOLL` `` |
| 2 | `…K20…v1.3.md` | 8 | `Zugangsnachweis trägt BETRIEBSPROTOKOLL` |

> **Beide Anker sind am 23.08.2026 gegen die geltende Fassung geprüft und kommen je genau
> einmal vor.** Stimmt ein Anker beim Vollzug nicht, wird **nicht eingetragen, sondern
> gefragt.**

## Feld 6 · Vollzugsspalte je Stelle

| Nr. | vollzogen am | Zeichen |
|---|---|---|
| 1 | ⟨………………⟩ | ⟨………⟩ |
| 2 | ⟨………………⟩ | ⟨………⟩ |

**Nach dem Vollzug:** Fassung auf **v1.4** heben, Kopftabelle nachziehen (Version, Datum,
Freigabe) und die Prüfsumme in der zugehörigen Zeichnungsdatei erneuern — **nie im Konzept
selbst.**

## Feld 7 · Entscheidungskreuz

**Was hiermit entschieden wird:** dass die Klausel dem Beschluss folgt und nicht umgekehrt.

`☐` **Korrektur K20-1 gezeichnet** — beide Stellen werden wie oben vollzogen
`☐` **abweichend:** ⟨……………………………………………………⟩

*Nach §12.3 zeichnen beide Vertragsparteien jedes Korrekturblatt.*

| Rolle | Name | Datum | Kreuz |
|---|---|---|---|
| Auftraggeber | **M. Veil** | ⟨…………⟩ | ⟨…………⟩ |
| Auftragnehmer | **A. Han** (Nr. 158) | ⟨…………⟩ | ⟨…………⟩ |

> **Vorentscheidung liegt vor:** Weg B wurde am 23.08.2026 gekreuzt und von beiden
> gezeichnet — A. Han und M. Veil, in
> `arbeit/Vorlagen/zeichnung_offene_zwei_260823.md`. Dieses Blatt führt sie aus; es entscheidet
> nichts Neues.

---

## Was am Bau NICHT zu ändern ist

**Nichts.** Der Code setzt `retention_class` an dieser Stelle nicht und lässt die
Tabellenvorgabe greifen — also bereits `EREIGNIS`. Der Bau war nie falsch; es fehlte die
Entscheidung.

**Zu berichtigen ist allein ein Kommentar:** `app/einladung_senden.py:291` sagt, der
Widerspruch werde „gemeldet, nicht hier entschieden". Nach dem Vollzug ist er entschieden,
und der Kommentar gehört auf diesen Stand gebracht — mit Verweis auf dieses Blatt.

*Ausgefertigt am 23.08.2026 vom Coding-Harness als Entwurf. Die Anker sind gegen die geltende
Fassung geprüft; der Vollzug bleibt beim Menschen.*
