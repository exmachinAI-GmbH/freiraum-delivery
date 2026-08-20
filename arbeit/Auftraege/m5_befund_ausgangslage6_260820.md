# Sechster Befund — **die Datei läuft. Sie widerspricht nur sich selbst an einer Stelle.**

**20.08.2026 · Nachbesserungsauftrag an den Prüf-Agenten.**

## Was getragen hat

**Alles.** Die Ausgangslage läuft jetzt vollständig durch — bis zu deiner eigenen
Aufbauprüfung, und die schlägt an. **Das ist genau das gewünschte Verhalten**: sie hat vorher
geschwiegen, jetzt redet sie.

Gemessen vor dem Abbruch: **13 Anwendungen · 14 Eignungs-Checks · 1 Agenten-Zeile.** Deine
Unterabfrage auf den `model_ref`-Startbestand hat getragen, der erweiterte `EXCEPTION`-Block
auch.

## Der Mangel — dein Prüfteil (i) widerspricht deinem Prüfteil (g)

Der **vollständige** Text deines Abbruchs, ohne Kürzung — mehr steht dort nicht:

```
ABBRUCH: AUFBAU UNBRAUCHBAR (F07) --
  gs_ohnecheck@gespraechpruef.example traegt 0 Checks statt genau 1;
```

**Es ist eine einzige Beanstandung. Alle übrigen Prüfungen, einschließlich deiner vier neuen
Zählungen, gehen durch.**

Und die eine ist ein Widerspruch **in deiner Datei mit sich selbst**:

| Stelle | Was dort steht |
|---|---|
| Zeile 164 | *„`gs_ohnecheck` · **KEIN** `fit_check`, **KEINE** `app`-Zeile"* |
| Zeile 230 | *„`gs_ohnecheck@` trägt **gar keinen**"* |
| Zeile 255 | *„`gs_ohnecheck@` trägt **bewusst KEINEN** `fit_check` — kein `INSERT`"* |
| Prüfteil **(g)**, Zeile 480–483 | prüft ausdrücklich, dass er **keinen** trägt — *„sonst wäre der Negativfall nicht mehr rein"* |
| Prüfteil **(i)**, Zeile 493–496 | verlangt von **jedem** Konto außer `gs_admin@` **genau einen** |

**(i) nimmt `gs_admin@` aus, aber nicht `gs_ohnecheck@`.** Vier Stellen deiner Datei sagen,
dass dieses Konto keinen Check tragen darf; die fünfte verlangt einen.

## Was zu tun ist

Bring (i) mit (g) und den drei Kommentaren in Einklang. **Welche Konten (i) ausnehmen muss,
liest du an deiner eigenen Ausgangslage ab** — prüf dabei auch `gs_offen@`, damit du nicht an
der nächsten Ausnahme wieder aufläufst.

> **Nimm nicht die Prüfung (i) heraus, um den Lauf glatt zu bekommen.** Sie ist richtig und
> hat gerade ihre Arbeit getan: sie hat einen Widerspruch gefunden, den sonst niemand gesehen
> hätte. Nur ihre Ausnahmeliste ist unvollständig.

## Danach

Nach dieser einen Berichtigung fährt der Orchestrator den vollen Klausellauf gegen einen
laufenden Server. **Was dann kommt, sind zum ersten Mal echte Prüfergebnisse** — und die
gehören dann nicht mehr in einen Befund an dich, sondern in `gespraech_deckung.md` und in den
Bericht.

## Die Grenze — unverändert

- **Ändere nichts an der fachlichen Aussage eines Falles.**
- **Senke keinen Prüfwert und lockere keine Erwartung** (K23-D05).
- **Nimm keinen Fall und keine Prüfung stillschweigend heraus.**
