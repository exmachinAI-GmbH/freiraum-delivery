# Blindlauf · m5-gespraech

| Feld | Wert |
|---|---|
| Stand | `9efb5d4a0b4aae6b0de3db862fca64cdd2f08690` |
| Beginn · Ende (UTC) | 2026-08-20T06:51:25Z · 2026-08-20T07:32:25Z |
| Modell des Prüf-Agenten | `sonnet` — **anders als der Bau** (F27) |
| Blindstand | `/var/folders/m9/947vrd_d20gfzy5vgvnp4lv40000gn/T/tmp.Pxi4LSPt5V/blindstand-m5` |
| Auftrag | `arbeit/Auftraege/m5_pruefauftrag_blind_260820.md` · `97f77986797822f7` |
| Klauseln | `arbeit/Auftraege/m5_klauseln_und_kriterien_260820.md` · `825a9b8b03e76cb1` |
| Gegenprobe | **bestanden** — der Umsetzungscode war im Blindstand nicht erreichbar |

## Die Gegenprobe im Wortlaut

Gesucht wurde die erste Zeile von `app/haupt.py`. Gemessen wird nicht
"es kam ein Fehler", sondern dass die Marke `umsetzt: K03-D01, K03-G01` in der Antwort
**nicht** vorkommt (F07 — der Fall muss an seiner eigenen Bedingung
scheitern, nicht an einer fremden).

```
Dieser Pfad liegt außerhalb meines Arbeitsverzeichnisses und ist durch die Sandbox-Konfiguration explizit vom Lesezugriff ausgeschlossen (`/Users/andi/freiraum-delivery` steht auf der Deny-Liste). Ich kann die Datei daher nicht einlesen.
```

## Zurückgetragen

| Datei | Prüfsumme im Blindstand | Prüfsumme im Repo |
|---|---|---|
| `pruefungen/klauseln/gespraech_daten.sql` | `0e11c8e02e76ef5b` | `0e11c8e02e76ef5b` |
| `pruefungen/klauseln/gespraech_deckung.md` | `5e41a64575808b12` | `5e41a64575808b12` |
| `pruefungen/klauseln/gespraech_lauf.sh` | `0422486a73f098e1` | `0422486a73f098e1` |

> Der Transport ist ein Kopiervorgang dieses Werkzeugs, keine Bearbeitung.
> Stimmen die beiden Prüfsummen je Zeile überein, ist die Datei unverändert
> angekommen. Der Bau-Agent hat den Inhalt nicht angefasst (CLAUDE.md Abschn. 6).
