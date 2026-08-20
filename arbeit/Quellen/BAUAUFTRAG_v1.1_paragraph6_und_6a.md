# Bauauftrag N5 v1.1 · §6 und §6a — **wortgleicher Auszug, mitgeführt im Harness**

| | |
|---|---|
| **Quelle** | `03_N5_BAUAUFTRAG_v1.1_260807.md` · Konzept-Fabrik, `…/260805/260805-Add-On-04/` |
| **Prüfsumme der Quelle** | `3341362f8962af9d48de4afdc863284d5261e9ede3c997fb32bd83933186e43d` |
| **Gegenprobe** | identisch mit Glied 2 der Nachweiskette in `CLAUDE.md` — dieselbe gezeichnete Fassung |
| **Übertragen am** | 19.08.2026, auf Weisung: *„lese auch den Bauauftrag gem. §6 … wenn dieser in der Konzeptfabrik liegt, übertrage diesen in den Coding Harness"* |
| **Umfang** | Zeilen 229–274 der Quelle, unverändert |

> **Warum das hier steht.** M1 bis M12 sind die Zustände, an denen der Auftrag gemessen wird —
> und bis heute waren sie aus dem Lieferstand heraus nicht nachschlagbar. Ein Nachweisskript,
> dessen Messpunkte aus einer Rekonstruktion stammen, misst etwas anderes als die gezeichnete
> Zeile. Der Auszug ist **wortgleich**; geändert wurde nichts, ergänzt nichts.
>
> **Er ersetzt die Quelle nicht.** Bei Abweichung gilt der Bauauftrag in der Konzept-Fabrik;
> die Prüfsumme oben ist der Beleg, gegen den sich das nachrechnen lässt.

---

## 6 · Der Pilot läuft mit synthetischen Daten

Das ist keine Einschränkung des Auftrags, sondern seine Voraussetzung: BV-4 hält fest,
dass der Betrieb mit echten Kundendaten derzeit **nicht vertretbar** ist. Der Pilot fährt
mit den erfundenen Daten der Demobank.


---

## 6a · Meilensteine — je ein Zustand, der eintritt oder nicht

**Ein Meilenstein beschreibt, was danach *wahr* ist, nicht woran gearbeitet wurde.**
Jeder trägt eine Nachrechnung: einen Satz, den man prüfen kann, ohne den Bau zu kennen.

| | Meilenstein · **Zustand** | Nachrechenbar an | Konzepte |
|---|---|---|---|
| **M1** | **Die Datenbank steht.** Die Sammelmigration ist im Zielbestand eingespielt; ein zweiter Lauf ändert nichts | `uebergabe/migration/n2_lauf.sh` läuft durch: leerer Schema- **und** Datenvergleich, kein gescheiterter Prüffall, T22/T23 ausgeführt, Objektzahlen wie im Nachweis | K13 · K23 |
| **M2** | **Ein Eingeladener kann sich anmelden.** Einladung geht raus, Code kommt an, Anmeldung gelingt, die Protokollzeile existiert | eine echte Zustellung mit abgelesenem Mailkopf; `event` trägt die Anmeldung; Code verfällt nach 10 Minuten; Sperre nach fünf Fehlversuchen greift | K03 · K02 · K11 |
| **M3** | **Die Vorprüfung hält an.** Direkt-Prototyp-Check und Eignungs-Check laufen; ein *NICHT_GEEIGNET* führt in den Halt — nicht weiter | ein Lauf, der am Halt endet, und **je einer über alle drei Auswege**: *Antwort ändern* (Rücknahme, `superseded_at`), *Termin* (Gespräch angestoßen), *Zur Übersicht* (EN-02, Eignungs-Check bleibt erhalten). K04-M08 verlangt genau drei | K04 |
| **M4** | **Eine Anwendung entsteht nur über den einen Weg.** Nach GEEIGNET und Zweckbestimmung legt `create_app_after_fit` die Zeile an; ein direkter `INSERT` wird abgewiesen | MT-95 bis MT-98 gegen den Zielbestand; EN-04a bedienbar; bei Treffer in Frage 1 liegt die Kenntnisnahme vor | K01 · K04 · K19 |
| **M5** | **Das Gespräch trägt und überlebt das Abmelden.** Stufe 01 und 02 laufen; *Speichern, später weitermachen* hält den Stand über eine Abmeldung hinweg | ein Gespräch abbrechen, neu anmelden, weitermachen — der Stand ist da | K05 |
| **M6** | **Die sechs Anforderungskonzepte liegen vor.** Stufe 03 erzeugt sie; der Projektvertrag hält die Obergrenze ein | sechs Dokumente mit Fassung und Prüfsumme; Seitenzahl gegen `config/artefakte.yaml` | K06 |
| **M7** | **Der Prototyp ist gebaut und bedienbar.** Stufe 04 zeigt eine Vorschau, keine Zeichnung; Rechenlogik, Beträge, Prüfregeln und Freigabestufen bleiben unantastbar | jemand bedient den Prototyp, ohne dass ein unantastbarer Teil sich ändern lässt | K07 |
| **M8** | **Das Angebot ist freigebbar.** Stufe 05 zeigt den Freigabeblock; Unterschrift und beide Häkchen sind Bedingung | ein Lauf, der ohne Häkchen abgewiesen wird, und einer, der durchgeht | K09 |
| **M9** | **Das Übergabe-Paket ist abrufbar.** Es trägt Manifest- und Archivprüfsumme, die Freigabezeile ist typisiert | Paket herunterladen, Prüfsumme nachrechnen, `approval` führt Objektart, Schlüssel, Version und Anlass | K10 · K14 |
| **M10** | **Der Durchstich ist bestanden.** Ein Lauf von der Einladung bis zum abgerufenen Paket, ohne Sprung — **und mindestens einmal je Fehlerpfad abgebogen** | das unveränderliche Manifest nach K23-M18 | K23 |
| **M11** | **Die Lastprüfung ist bestanden.** Drei Mandanten gleichzeitig, 95 % unter 3 Sekunden, 50 Modellaufrufe je Gespräch — **und die Mandantentrennung hält** | Lastprotokoll mit Trennungsnachweis; eine schnelle Anwendung, die Daten vermischt, hat nicht bestanden | K23 |
| **M12** | **Der Wechsel nach ABNAHME ist gezeichnet.** Der Nachweis nennt, welche Prüfungen bestanden wurden, mit welchem Stand, und wer gezeichnet hat | `approval` mit Anlass ABNAHME, ausgelöst von **einer** Person in der Rolle Plattform-Admin (K23-M15, K23-M21) — der zweite Blick ist für `IN_PROD` erforderlich, **nicht** für `ABNAHME` | K23 · K14 |

**M1 bis M4 sind die Kette, an der alles hängt.** Fällt M4, entsteht keine Anwendung, und
M5 bis M9 haben keinen Gegenstand.

> **Kein Meilenstein trägt ein eigenes Datum — es gibt einen Endtermin für alle:
> den 31. August 2026.**
>
> Das ist Absicht. Zwölf Einzeltermine würden zwölf Verhandlungen erzeugen und beim
> ersten Verzug reihum verschoben. Ein Endtermin für zwölf nachrechenbare Zustände
> erzeugt eine Frage: **Sind sie eingetreten?** Die Reihenfolge und das Tempo dazwischen
> gehören dem Auftragnehmer — er kennt seinen Bau besser als der Auftraggeber.
>
> **Woran der Auftraggeber vor dem Endtermin misst:** an M1 bis M4. Sie sind die Kette,
> an der alles hängt; steht M4 nicht, sind M5 bis M9 gegenstandslos, und der Endtermin
> ist nicht zu halten — unabhängig davon, wie viel gebaut wurde.

---
