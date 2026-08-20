# Abnahme der Scheibe m5-vorbereitung

> **DIESE DATEI MELDET NOCH NICHTS AN.** Sie heißt `abnahme_VORBEREITET.md`, nicht `abnahme.md`
> — der Riegel `werkzeuge/tor3_pflicht.py` greift erst beim zweiten Namen. **Ein Befehl macht
> daraus die Anmeldung:**
>
> ```
> git mv nachweise/scheiben/m5-vorbereitung/abnahme_VORBEREITET.md \
>        nachweise/scheiben/m5-vorbereitung/abnahme.md
> ```
>
> **Warum sie nicht schon so heißt.** F42 verlangt ein Tor-3-Blatt, dessen geprüfter Commit ein
> Vorfahr des Abnahmestandes ist. `nachweise/fremdreview/` enthält heute **nur README und
> Vorlage** — es gibt kein einziges. Mit dem zweiten Namen schlüge Tor 1 also sofort an, und
> zwar zu Recht: fail-closed. Das ist keine Umgehung des Riegels, sondern die Reihenfolge, die
> er erzwingt — **erst der fremde Blick, dann die Anmeldung.**

<!-- KOPF · maschinell gelesen, Feldnamen nicht ändern -->

| Feld | Wert |
|---|---|
| scheibe | `m5-vorbereitung` |
| stand | `<voller Commit-Hash des Abnahmestandes — nach dem Zusammenführen von #41 eintragen>` |
| datum | `<JJJJ-MM-TT>` |
| angemeldet_von | `<Name>` |

## Was abgenommen wird

Die Vorbereitung des Meilensteins M5: der gemessene Umfang, die 101 gezeichneten
Akzeptanzkriterien, die acht entschiedenen Sperren und die aus der Konzept-Fabrik übertragenen
Quellen. **Kein Anwendungscode** — der erste Bauzug (M32) läuft auf einem eigenen Zweig.

## Was mit vorzulegen ist (Blatt 11:137)

| | Stand am 19.08.2026 |
|---|---|
| **Klauselregister** | `nachweise/klauselregister/register.json` — 1231 Zeilen, davon 101 M5-Klauseln mit **gezeichnetem** Kriterium und Eigentümer |
| **Herkunftsgraph** | `werkzeuge/herkunft.py` — erzeugt |
| **Restrisikoliste** | `nachweise/restrisiken/restrisiken.md` — offen und getragen: **RR-02, RR-04, RR-05, RR-06**; RR-01 geschlossen |
| **Testmanifest** | `nachweise/manifeste/` — je Lauf |

## Was der Abnahme entgegensteht — offen benannt

1. **Tor 3 ist nie gelaufen.** Kein Blatt in `nachweise/fremdreview/`. Der fremde Blick entsteht
   außerhalb des Harness und wird angefordert, nicht geschrieben.
2. **M4 ist nicht abschließend nachgerechnet** — Serverseite ja (MT-95…MT-98 bestanden), aber
   EN-04a hat keinen K19-Kasten und der freie Weg kommt im Klausellauf nicht bis zur Auswertung
   (`arbeit/Bauberichte/m4_nachrechnung_260819.md`).
3. **M1 ist gegen die Zielumgebung nicht gefahren.** Das Skript liegt jetzt im Repo
   (`migrations/n2_lauf.sh`), der Lauf braucht die Pilotumgebung und `frxfw`.
4. **BA-1 und BA-2 sind ohne die Gegenzeichnung A. Hans nicht wirksam** (§12.9).

## Zeichnung

| | |
|---|---|
| ☐ Die Scheibe wird zur Abnahme vorgelegt | |

| Name | Rolle | Datum |
|---|---|---|
|  | für den Auftragnehmer |  |
|  | für den Auftraggeber |  |

---

*Vorbereitet am 19.08.2026 vom Harness. Die Kreuze und die Namen setzt ein Mensch — und den
Namen der Datei ändert er, wenn das Tor-3-Blatt vorliegt.*
