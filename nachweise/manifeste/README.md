# Testmanifeste nach K23-M18

Hier liegen die Manifeste. **Nicht die Berichte** — die sagen, wie ein Lauf ausging;
ein Manifest sagt, **gegen welchen Stand** gemessen wurde.

```
<name>.json                    der Bericht   — was herauskam
<name>_manifest.json           das Manifest  — unter welchen Umstaenden
<name>_manifest.json.sha256    die Pruefsumme darueber
```

Erzeugt von `werkzeuge/manifest.py`, angestossen von `pruefungen/lauf.sh --bericht <datei>`.

## Warum es diesen Ordner gibt

Befund **AH-7**, Handover vom 11.08.2026:

> `nachweise/manifeste/` existiert im Git-Baum nicht. K23-M18 verlangt je Lauf ein
> unveraenderliches Manifest. **Der ganze 11.08. hat gemessen und nichts hinterlassen.**

In CI entstand ein Bericht, aber nur als Anhang am Lauf — und ein Anhang verfaellt nach
Tagen. **Ein Glied einer Kette, das verfaellt, ist keines.**

## Die acht Glieder

| | | |
|---|---|---|
| **1** | Commit-Hash des geprueften Standes | dazu, ob der Arbeitsbaum sauber war |
| **2** | Pruefsumme des Bauauftrags | uebernommen aus `CLAUDE.md`, Herkunft mitgefuehrt |
| **3** | Pruefsumme der Anlage | ebenso; nachrechenbar mit `./install.sh --pruefsumme` |
| **4** | Migrationsstand | welche Dateien, **in welcher Reihenfolge**, gegen welches Basisschema |
| **5** | Abhaengigkeitsstaende | Python, PostgreSQL, `requirements.txt` |
| **6** | Modell-, Prompt-, Wissens-, Richtlinien-, Vorlagenstand | bei Tor 1c **leer** — und das steht drin |
| **7** | Werkzeuge mit Fassung, Beginn und Ende, Umgebung | ohne Zugangswerte (K23-D09) |
| **8** | Pruefsummen aller Eingaben und Ergebnisse | dazu eine ueber das Manifest selbst |

**Ein leeres Feld ist eine Auskunft, ein fehlendes Feld ist keine.** Glied 6 steht bei
Tor 1c auf `null` — nicht weil es nicht gemessen wurde, sondern weil dieser Lauf kein
Modell aufruft und keine Vorlage liest. Der Unterschied ist der ganze Punkt von K23-M22.

## Die Pruefsumme steht NEBEN dem Manifest

Eine Pruefsumme **im** Manifest kann nicht ueber das Manifest gehen — sie waere Teil
dessen, was sie sichert. Deshalb die Nebendatei. Nachrechnen:

```
cd nachweise/manifeste && shasum -a 256 -c <name>_manifest.json.sha256
```

Gegengeprueft am 13.08.2026: Nachrechnen `OK`; nach Aenderung von drei Zeichen im
Manifest `FAILED`. Eine Pruefsumme, die eine Aenderung nicht bemerkt, waere Zierde.

## Wann ein Manifest eingecheckt wird

**Jeder CI-Lauf erzeugt eines** und legt es als Anhang ab — nuetzlich, aber
verganglich.

**Eingecheckt wird es zur Vorlage.** K23-M20 verlangt vor jeder Vorlage einen
bestandenen Durchstich gegen den aktuellen Stand, *nachgewiesen ueber die Pruefsumme im
Manifest*. Das Manifest gehoert also zur Zeichnungseinheit, nicht zu jedem Lauf — sonst
waere der Ordner nach einer Woche unlesbar.

**Voraussetzung: ein sauberer Arbeitsbaum.** Sonst weist Glied 1 aus, dass der
Commit-Hash den gelaufenen Stand nicht beschreibt — und ein Manifest mit dieser
Anmerkung ist als Nachweis wertlos.
