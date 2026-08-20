# Blindlauf · m5-gespraech

| Feld | Wert |
|---|---|
| Stand | `e2c6487bf736eeaf21e608ce7464f1cfe776faad` |
| Beginn · Ende (UTC) | 2026-08-20T11:40:24Z · 2026-08-20T12:24:04Z |
| Modell des Prüf-Agenten | `sonnet` — **anders als der Bau** (F27) |
| Blindstand | `/var/folders/m9/947vrd_d20gfzy5vgvnp4lv40000gn/T/tmp.dxTjyaHN4g/blindstand-m5-nb9` |
| Auftrag | `arbeit/Auftraege/m5_pruefauftrag_blind_260820.md` · `97f77986797822f7` |
| Klauseln | `arbeit/Auftraege/m5_klauseln_und_kriterien_260820.md` · `825a9b8b03e76cb1` |
| Gegenprobe | **bestanden** — der Umsetzungscode war im Blindstand nicht erreichbar |
| Art des Laufs | **Nachbesserung** — Befund `arbeit/Auftraege/m5_befund_shellcheck9_260820.md` · `cea185ed845b3fab` |

## Die Gegenprobe im Wortlaut

Gesucht wurde die erste Zeile von `app/haupt.py`. Gemessen wird nicht
"es kam ein Fehler", sondern dass die Marke `umsetzt: K03-D01, K03-G01` in der Antwort
**nicht** vorkommt (F07 — der Fall muss an seiner eigenen Bedingung
scheitern, nicht an einer fremden).

```
Der Zugriff auf `/Users/andi/freiraum-delivery/app/haupt.py` ist durch deine Berechtigungseinstellungen gesperrt (dieses Verzeichnis steht explizit auf der Deny-Liste) – ich kann die Datei nicht lesen.
```

## Zurückgetragen

| Datei | Prüfsumme im Blindstand | Prüfsumme im Repo |
|---|---|---|
| `pruefungen/klauseln/gespraech_lauf.sh` | 40abe014d64e6408 | 40abe014d64e6408 |

> Der Transport ist ein Kopiervorgang dieses Werkzeugs, keine Bearbeitung.
> Stimmen die beiden Prüfsummen je Zeile überein, ist die Datei unverändert
> angekommen. Der Bau-Agent hat den Inhalt nicht angefasst (CLAUDE.md Abschn. 6).
