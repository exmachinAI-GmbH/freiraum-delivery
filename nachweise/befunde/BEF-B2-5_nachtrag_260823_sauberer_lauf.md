# Nachtrag zu BEF-B2-5 · Der Wiederholungslauf trägt — K23-M18 Glied 1 eingelöst

| | |
|---|---|
| **Gegenstand** | AC-16 · M2, Teilaussage 1 · der Vorbehalt aus PR #51 |
| **Gefahren am** | 23.08.2026, 14:48 bis 14:52 MESZ |
| **Ergebnis** | **bestanden** — auf sauberem Arbeitsbaum, mit Manifest |

---

## 1 · Der Vorbehalt und seine Einlösung

Der Nachweis vom Vormittag trug die Zeile *„Arbeitsbaum war nicht sauber — der Commit-Hash
beschreibt nicht den gelaufenen Stand (K23-M18 Glied 1)."* Drei ungezeichnete Änderungen und
zwei neue Werkzeuge lagen damals im Arbeitsstand.

Der Wiederholungslauf ist auf einem eigenen Arbeitsbaum mit **angehängtem Kopf** an
`origin/main` gefahren — nichts gebaut, nur gemessen. Das Manifest sagt es selbst:

```json
"glied_1_commit": {
  "commit": "67f6c3bdffd4aa039e3e6cfb7c493746aec42b56",
  "zweig": "HEAD",
  "arbeitsbaum_sauber": true,
  "anmerkung": null
}
```

**`arbeitsbaum_sauber: true`.** Der Hash beschreibt den Stand, der gelaufen ist — den
zusammengeführten `main` nach #51 und #52.

Die Prüfsumme des Manifests ist nachgerechnet und trägt: `236d703f44b24f5d…`.

## 2 · Das Ergebnis

`anmeldecode — 6 von 17 bestanden, 11 gescheitert` — dieselbe Zahl wie am Vormittag, und
AC-16 wieder nicht in der Mängelliste. Der Kopf gehört zum Versand um **14:48:35 MESZ**
(`Message-Id: <20260823124835.6014734846@mxout01.bytecamp.net>`), er trägt `d=freiraum.top`,
`s=20260803`, `dkim=pass`, `spf=pass`, `dmarc=pass` und unter `X-DMARC-Info` erstmals
`dmarc-policy=quarantine` — die verschärfte Regel ist beim Empfänger angekommen und wurde
angewandt.

| Beleg | Ort |
|---|---|
| Rohkopf | `nachweise/vorbedingungen/B2_mailversand/kopf_260823_nachlauf.txt` |
| Lauf `senden` | `…/ac16_senden_sauber.log` |
| Lauf `pruefen` | `…/ac16_pruefen_sauber.log` |
| Bericht, Manifest, Prüfsumme | `nachweise/manifeste/nachlauf_260823/` |

## 3 · Zwei Dinge, die dabei aufgefallen sind

**Ein frischer Arbeitsbaum ist nicht messbereit.** `git worktree add` bringt kein `.venv` —
es ist zu Recht nicht versioniert. Der erste Versuch lief deshalb durch bis zu den
Klauselfällen und meldete dort neunmal *„.venv/bin/uvicorn fehlt"*, danach *„.venv/bin/python
fehlt — kein Manifest"*. **Nichts gemessen, kein Token verbraucht** — aber ein verlorener
Durchgang. Ein Vorabschritt, der den Prüfstand prüft statt ihn vorauszusetzen, hätte das
gespart. *(Vorschlag Z-1 unten.)*

**Der Kopf muss zum Versand gehören, nicht zur Mail.** Der zweite Versuch scheiterte, weil in
der Kopfdatei noch der Kopf des Vormittagslaufs stand — inhaltlich tadellos, aber eine Stunde
vom Versandnachweis entfernt, bei 300 Sekunden Bindungstoleranz. **Genau dafür ist die Bindung
da**, und sie hat gegriffen: `5 von 17` statt `6 von 17`. Ein Prüffall, der einen alten,
gültigen Kopf annimmt, wäre der gefährlichere.

## 4 · Vorschläge

| Nr. | Vorschlag | Träger |
|---|---|---|
| **Z-1** | `ac16_echtlauf.sh vorbereiten` prüft vorab, ob `.venv/bin/uvicorn` und `.venv/bin/python` bestehen, und bricht mit einem Satz ab, statt den Durchgang zu verbrauchen | Bau |
| **Z-2** | Dasselbe in `werkzeuge/m2_bereitschaft.py` als eigener Punkt — die Bereitschaftsprüfung meldete BEREIT, obwohl der Prüfstand fehlte. Das ist eine Lücke in ihr, nicht im Lauf | Bau |
| **Z-3** | Nach dem Ablegen des Kopfes prüfen, ob seine `Date`-Zeile im Fenster liegt — **bevor** der Lauf startet. Eine Zeile `grep -m1 ^Date:` erspart einen ganzen Durchgang | Bau |

## 5 · Was weiterhin offen ist

Das Manifest bindet unter Glied 2 auf **„Bauauftrag N5, Fassung v1.1 (07.08.2026)"** — nicht
auf v1.2. Das ist richtig so, solange A-1 offen ist: Gezeichnet ist v1.1. Es ist zugleich der
Grund, warum nach §12.6 **keine Vorlage zur Freigabe zulässig** ist, bevor v1.2 in der
Konzept-Fabrik liegt. Der Nachweis trägt — die Abnahme kann er allein nicht auslösen.
