# M3 · Der Weg zu DONE — Schritt für Schritt

*Stand 23.08.2026, nach dem Bau · Zweig `scheibe/m3-schnellweg`, Commit `5ef042d`*

---

## Was DONE für M3 heißt

Nicht „gebaut". **Tor 4 gezeichnet** — die Unterschrift unter einen Stand, der die vier Messstufen durchlaufen hat. Der Grundsatz darüber: *nicht gemessen ist nicht bestanden.* Ein gesperrter Prüfpunkt zählt nicht als offen, sondern als nicht erbracht.

Heute steht M3 auf **nicht ausgeführt**. Der Bau ist fertig, die Messung hat nicht begonnen.

---

## Der Weg, in der Reihenfolge, in der er gegangen wird

Sieben Schritte. **Drei davon sind Unterschriften und dauern Minuten. Vier sind Arbeit, und drei davon kann ich übernehmen.**

```
S1 ─ drei Zeichnungen, parallel ─────────────┐
     S1a  N-K19-1                            │
     S1b  O-K19-11 · „genau fünf"            │  Menschen · Minuten
     S1c  O-M3-5  · Zuordnungsspalte         │
                                             ▼
S2 ─ K19 v1.4 nachziehen ────────────────────┤  Mensch trägt · ich liefere
                                             ▼
S3 ─ Klausellauf gegen einen echten Server ──┤  ich
                                             ▼
S4 ─ Tor 2 · blind ──────────────────────────┤  Prüf-Agent
                                             ▼
S5 ─ Tor 3 · fremd ──────────────────────────┤  Fremdmodell
                                             ▼
S6 ─ Klauselregister: Ergebnis je Klausel ───┤  ich, aus S3-S5
                                             ▼
S7 ─ Tor 4 · Zeichnung ──────────────────────┘  M. Veil / A. Han  =  DONE
```

---

## S1 · Drei Zeichnungen — der einzige echte Engpass

Alle drei sind unabhängig voneinander und können in einer Sitzung erledigt werden.

### S1a · N-K19-1 zeichnen

| | |
|---|---|
| **Wer** | A. Han (der Nachtrag nennt ihn als Zeichnenden) · Gegenzeichnung M. Veil |
| **Was** | Den Nachtrag vom 14.08.2026 im Wortlaut zeichnen. Blatt: `arbeit/Vorlagen/zeichnung_N-K19-1_260823.md` |
| **Aufwand** | Eine Unterschrift. Der Nachtrag begründet jede Kastenzeile einzeln und liefert jede Einfügestelle nach Dateizeile |
| **Warum es blockiert** | Ohne sie gelten EN-03a **und EN-04a** nach K19-G01 als *nicht belegt*. Das sperrt nicht den Bau — es sperrt die Abnahme |
| **Löst zugleich** | **M4.** Ein Blatt, zwei Meilensteine |

### S1b · O-K19-11 entscheiden — „genau fünf" gegen „höchstens fünf"

| | |
|---|---|
| **Wer** | K04, hilfsweise K00 — praktisch beide Founder |
| **Der Widerspruch** | K04-M02 sagt „höchstens fünf kurze Fragen" · K04-M22 sagt „genau fünf Fragen" · Endnutzer-Handbuch 3.1 sagt „bis zu fünf" |
| **Was der Bau tut** | Zeigt fünf fest. Das ist die Lesart von K04-M22 und die einzige, die zur Kontrollzahl 22 von 243 passt — ein adaptiver Abbruch nach dem ersten Veto ergäbe eine andere Zahl |
| **Wenn anders entschieden wird** | Der Auswerter muss nach jedem Veto abbrechen und die Restfragen sichtbar entfallen lassen. **Ein halber Bautag**, und `werkzeuge/schnellweg_gegenprobe.py` braucht eine zweite Sollzahl |
| **Ich liefere** | Eine Entscheidungsvorlage A/B mit beiden Folgen — sage Bescheid |

### S1c · O-M3-5 entscheiden — die fehlende Zuordnungsspalte

| | |
|---|---|
| **Wer** | Founder mit dem Datenmodell — dieselbe Zuständigkeit wie O-K04-8 und O-K04-10 |
| **Der Befund** | `quick_option` hat keine Spalte für *Dokument/Anwendung*, obwohl K04-M22 sie je Antwort verlangt. Beim Nachbau von `fit_option` ist `is_eligible` ersatzlos entfallen |
| **Behelf heute** | Die Zuordnung steht als Endung `__dok`/`__app` am `value_token`. Der Seed misst sie nach und bricht ab, wenn eine fehlt |
| **Zielzustand** | `CREATE TYPE quick_zuordnung AS ENUM ('DOKUMENT','ANWENDUNG')` und eine Spalte. Das ist eine **Migration**, kein Seed |
| **Wenn nicht entschieden** | M3 ist trotzdem abnehmbar — aber K04-M22 ist im Schema nicht durchgesetzt, und der Prüf-Agent kann den Behelf als *nicht prüfbar aus der Klausel* zurückgeben. Dann fehlt ein Ergebnis, und fehlende Ergebnisse sind nicht bestanden |
| **Ich liefere** | Die Migration M36 als Entwurf, lauffähig und mit Gegenprobe — sage Bescheid |

---

## S2 · K19 v1.4 nachziehen

| | |
|---|---|
| **Nach** | S1a |
| **Wer** | Ein Mensch trägt es in die Konzept-Fabrik. Der Harness kann dort nicht schreiben |
| **Was** | Zwei Kästen in Abschn. 6, zwei Sitemap-Zeilen, zwei Zuordnungszeilen in Abschn. 8. Alles steht fertig in N-K19-1 Abschn. 2 und 3, mit Einfügestelle nach Dateizeile |
| **Ich kann liefern** | Die vollständige Fassung v1.4 als Entwurf unter `arbeit/an_konzeptfabrik/` — dann ist das Übertragen ein Kopiervorgang, keine Redaktion |
| **Nebenwirkung** | `config/konzepte.yaml` Z. 753 sagt „K19 fuehrt 31 Bildschirme". Wird auf 33 nachgezogen |

---

## S3 · Klausellauf gegen einen echten Server

**Das ist der Schritt, bei dem ich mich vorhin geirrt habe.** Ich hatte gesagt, dafür brauche es die Pilotumgebung und damit A-2. Das stimmt so nicht: Tor 1 verlangt „Klauselfälle gegen einen echten Server" — nicht gegen die Pilotumgebung. Einen echten Server kann ich stellen.

| | |
|---|---|
| **Wer** | Ich |
| **Was** | PostgreSQL aufsetzen, Datenmodell und Migrationen einspielen, den Seed laden, den Server starten und **jeden Weg aus dem Prüfauftrag durchfahren** — einschließlich der Fehlerpfade: Antwort passt nicht zur Frage, Vorgang eines fremden Mandanten, unvollständiger Check |
| **Ergebnis** | Ein Manifest unter `nachweise/manifeste/` mit Datum, Prüfsumme und Ergebnis je Fall |
| **Dauer** | Ein bis zwei Stunden |
| **Was es NICHT ersetzt** | Den Lauf auf der Pilotumgebung. **Ob der Wertungslauf dort liegen muss, sagt K23 — das ist auszuweisen, nicht von mir zu entscheiden.** Liegt er dort, hängt M3 doch an A-2, und dann ist der lokale Lauf ein Vorlauf, kein Nachweis |

---

## S4 · Tor 2 · blind

| | |
|---|---|
| **Wer** | Prüf-Agent, anderes Modell |
| **Auftrag** | liegt: `arbeit/Auftraege/m3_pruefauftrag_en03a_260823.md` — Wegetabelle, neun Klauseln, die Kontrollzahl 22 von 243 als blind messbarer Maßstab |
| **Zwei Bedingungen** | Lauf unter `blindstand.sh` — die Lesesperre besteht, ist aber an keinen Lauf angeschlossen (V-13); wer sie nicht ausdrücklich benutzt, arbeitet ohne sie. Und **ein Lauf zur Zeit**: zwei gleichzeitige Läufe erschlagen einander die Server und erzeugen rote Fälle, die keine sind (BEF-NEBENLAUF-1) |
| **Erwartete Rückgabe** | Auch „NICHT PRÜFBAR aus der Klausel" ist ein Ergebnis — bei O-M3-5 rechne ich damit |

---

## S5 · Tor 3 · fremd

| | |
|---|---|
| **Wer** | Fremdmodell, frische Instanz, gegen Roh-Evidenz statt gegen Erklärungen |
| **Warum es hier zählt** | Für M4 bis M6 ist Tor 3 **nie gelaufen**. M3 hat mit dem Wortlaut-Irrtum gerade gezeigt, wie lange eine falsche Aktenlage unwidersprochen steht — vier Stellen, drei Wochen |
| **Was vorzulegen ist** | Der Seed, `app/schnellweg_regel.py`, der Prüfauftrag, die beiden Befunde. Nicht meine Zusammenfassung |

---

## S6 · Klauselregister — Ergebnis je Klausel

| | |
|---|---|
| **Wer** | Ich, aus den Läufen S3 bis S5 |
| **Warum eigener Schritt** | Risiko R-1: im geführten Register haben 1230 von 1231 Klauseln keinen Prüffall und **alle 1231 kein Ergebnis**. Ohne Eintrag ist die Abnahme nicht belegbar, auch wenn alles läuft |
| **Umfang für M3** | Neun Klauseln: K04-M22, M23, M24, M25, M03, D11 · K19-M03, M06 · K01-M15 |

---

## S7 · Tor 4 · die Zeichnung

| | |
|---|---|
| **Wer** | M. Veil / A. Han |
| **Voraussetzung** | S1 bis S6 vollständig, jeder Prüfpunkt mit einem der vier Zustände — bestanden, fehlgeschlagen, gesperrt, nicht ausgeführt |
| **Besonderheit** | Tor 4 hat **keine Ablage und ist nie gefahren**. M3 wäre der erste Stand, der sie bekommt. Wo die Zeichnung eines Stufenstands abgelegt wird, ist selbst noch nicht festgelegt — das gehört mitentschieden, sonst steht am Ende eine Unterschrift ohne Ort |

---

## Zusammengerechnet

| | |
|---|---|
| **Menschliche Akte** | drei Zeichnungen (S1a–c) · ein Übertrag (S2) · ein Prüflauf (S4) · ein fremder Blick (S5) · eine Abnahme (S7) |
| **Meine Arbeit** | S3, S6, dazu die Zulieferungen zu S1b, S1c und S2 |
| **Engpass** | **S1a.** Ohne die Zeichnung ist der Bildschirm nicht belegt, und ohne belegten Bildschirm ist jede Messung darunter nur ein Vorlauf |
| **Realistisch** | Bei zügiger Zeichnung: M3 abnahmereif in zwei bis drei Arbeitstagen |

---

## Was ich sofort tun kann, ohne auf etwas zu warten

1. **S3** — den Klausellauf gegen einen echten Server fahren und das Manifest ablegen
2. **Zulieferung zu S1c** — die Migration M36 für die Zuordnungsspalte als Entwurf
3. **Zulieferung zu S1b** — die Entscheidungsvorlage „genau fünf" gegen „höchstens fünf"
4. **Zulieferung zu S2** — K19 v1.4 als fertige Fassung unter `arbeit/an_konzeptfabrik/`

*Punkt 1 ist der wertvollste: er verwandelt sechs Zeilen „nicht gemessen" in Ergebnisse.*

---

## Nachtrag in eigener Sache

**Der Commit.** Mein erster Versuch hat mit `git add -A` fremde, unfertige M2-Arbeit mitgezogen — sieben Dateien, die zu `ac16_echtlauf.sh`, `dkim_dns.py` und `m2_bereitschaft.py` gehören. Ich habe den Commit aufgetrennt; die M2-Dateien liegen wieder unangetastet als Arbeitsstand da. Der Regel „eine Scheibe je Arbeitszweig" folgt jetzt auch dieser Zweig.

**Vier Sperrdateien.** Beim Auftrennen sind verwaiste Git-Sperren angefallen. Über das eingebundene Laufwerk darf ich nichts löschen, deshalb liegen sie in `.git/_to_delete/` — `HEAD.lock.5`, `ORIG_HEAD.lock.5`, `index.lock.5`, `maintenance.lock.5`. Sie können weg; der Ordner auch.
