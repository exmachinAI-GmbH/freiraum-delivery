# Der Weg zu **M5 DONE** — Handlungsempfehlung

**20.08.2026 · ⟨VORSCHLAG · NICHT GEZEICHNET⟩ · elf Tage bis zum 31.08.2026**

## Zuerst: „M5 DONE" heißt nicht „der Code ist fertig"

Der Code ist seit dem 19.08. gebaut. **Fertig ist ein Meilenstein erst, wenn alle vier
Messstufen durch sind** — und drei davon hat der Bau nicht in der Hand.

| Stufe | Was sie misst | Stand heute, gemessen |
|---|---|---|
| **Tor 1 · mechanisch** | Lint, Migration gegen frische Datenbank, zweiter Lauf ändert nichts, Negativfälle scheitern | **grün auf `main`** · für `scheibe/m5-gespraech` **noch nicht gefahren** |
| **Tor 2 · blind** | Erfüllt der Stand die 101 gezeichneten Akzeptanzkriterien? | **entsteht gerade** — heute zum ersten Mal überhaupt maschinell angestoßen |
| **Tor 3 · fremd** | Fachliche Eignung, geprüft außerhalb des Harness | **GESPERRT · nie gelaufen.** Anforderung liegt fertig vor |
| **Tor 4 · Mensch** | Wird es getragen? | **offen** — läuft nie automatisch |

> **K23-M22:** *nicht gemessen ist nicht bestanden.* Vier Zustände, nicht zwei. Ein Tor ohne
> Messung meldet **gesperrt**, nie grün — und ein Bau mit anschlagendem Gate erreicht die
> menschliche Freigabe nicht (K23-D01).

---

## Was der Harness ohne weitere Zeichnung tut — fünf Schritte

| | Schritt | Ergebnis |
|---|---|---|
| **1** | Die blinden Prüffälle zurücktragen und **fahren** | die erste echte Zahl für Tor 2: wie viele der 101 Klauseln gedeckt, gemessen, bestanden |
| **2** | Was rot ist, **am Code** beheben — nie am Prüffall | K23-D05: ein Prüfwert wird nicht gesenkt, damit ein Lauf besteht |
| **3** | Tor 1 auf dem Zweig fahren | Lint, frische Datenbank, zweiter Lauf, die vier Negativfälle |
| **4** | **Manifest** nach K23-M18 schreiben | acht Glieder, mit Prüfsumme über sich selbst |
| **5** | Das **Abnahmepaket** vorlegen | Klauselregister · Herkunftsgraph · Restrisikoliste · Testmanifest |

**Danach ist alles getan, was ohne einen Menschen getan werden kann.**

---

## Was nur ein Mensch tun kann — vier Sachen, und drei davon sperren

### A · Die Antwortlisten — **das ist der harte Blocker**

Ohne sie sind **K05-M03, K05-M04 und K05-G02** nach K23-M22 **gesperrt** — obwohl sie am
19.08. gezeichnet sind. Der Code ist gebaut und meldet die Lücke sauber; er kann sie nicht
füllen.

| | |
|---|---|
| **Was fehlt** | zwölf Themen · sieben Ziele · die **Vorschlagslisten der drei Einordnungsfragen** (Branche, Funktionsbereich, Anwendung) |
| **Wem es gehört** | dem fachlichen Eigentümer K05 — **A. Han**, gezeichnet am 19.08.2026 |
| **Wie lang** | Die Länge der drei Vorschlagslisten nennt **keine Quelle** (offener Punkt O-K05-6) |
| **Vorgeschlagener Termin** | **Montag, 24.08.2026** — rückwärts vom 31.08. gerechnet, vier Arbeitstage Vorlauf, **kein Puffer** |
| **Getrennt zu beauftragen** | die Fachfragen der Stufe 02 |

> **Kommen die Listen später als der 24.08., fällt zuerst die Nachbesserung weg, dann die
> Messung.** Danach geht EN-05 mit Lückenmeldung in die Abnahme statt vollständig.

### B · Tor 3 anfordern — **die Anforderung liegt fertig**

`arbeit/Vorlagen/tor3_anforderung_m5_gespraech_260820.md`: Roh-Evidenz mit Prüfsummen, sechs
beantwortbare Fragen, und offen benannt, was dem Prüfer fehlt.

**Der Harness ruft das Modell nicht auf und darf es nicht.** Ein fremder Blick, den der
Prüfling selbst bestellt, entgegennimmt und ablegt, ist keiner. Zu tun sind zwei Dinge: die
Anforderung abschicken und das Urteil unverändert ablegen.

> **Die Zykluszeit ist unbekannt, weil Tor 3 nie gelaufen ist.** Wer den Weg zum ersten Mal
> am 28.08. geht, erfährt zu spät, wie lange er dauert. **Das ist der Grund, es diese Woche
> zu tun, nicht nächste.**

### C · BA-1 und BA-2 gegenzeichnen — **sonst ist M5 zum 31.08. geschuldet**

Ohne A. Hans Gegenzeichnung gilt §12.9: *„Am Auftrag ist nichts geändert."* Dann verlangt der
Auftrag unverändert **alle zwölf Meilensteine zum 31.08.** — M5 wäre nicht Vorarbeit, sondern
Schuld. Der Satz aus dem Vorbereitungsblatt hätte keine Grundlage.

**Drei Zellen: BA-1:655, BA-2:466, BA-2:656.** Danach **25 Eintragungen** im Auftragstext.
Der Vorgang steht in `ba1_ba2_handlungsempfehlung_260819.md`, berichtigt am 20.08.

### D · #41 zusammenführen — **vor der Unterschrift, nicht danach**

Ab der Zeichnung ist keine Vorlage zur Freigabe mehr zulässig, bis alle 25 Haken sitzen
(§12.4 Nr. 5). Wer vorher nicht zusammenführt, sperrt fertige Arbeit hinter der eigenen
Korrektur.

---

## Die Reihenfolge in einem Bild

```
  HEUTE  ─┬─► Harness: Tor 2 fahren, beheben, Tor 1, Manifest, Paket
          │
          ├─► Mensch:  #41 zusammenführen
          │            Tor 3 anfordern          ◄── je früher, desto besser
          │            BA-1/BA-2 zeichnen
          │
  24.08.  ├─► Mensch:  die Antwortlisten liefern (A. Han)
          │
  25.-28. ├─► Harness: einbauen · blind messen · nachbessern
          │
  ~28.08. ├─► Mensch:  Tor-3-Urteil ablegen und zeichnen
          │
  31.08.  └─► Mensch:  Tor 4 — Scheibenabnahme zeichnen
```

---

## Was auch bei bestem Verlauf **nicht** fertig wird

Das gehört auf den Tisch, bevor jemand „done" zeichnet:

| | |
|---|---|
| **EN-04a hat keinen K19-Kasten** | Der Riegel meldet die Vorlage **GESPERRT**. Der Kasten gehört in die Konzept-Fabrik, und dorthin schreibt der Harness nicht. Das ist **M4**, nicht M5 — es steht hier, weil es dieselbe Abnahme berührt |
| **113 Risikozeilen ohne Träger und Frist** | Handarbeit; das Werkzeug kann diese Spalten nicht setzen. Für **105 von 113** fehlt zudem das Akzeptanzkriterium, ohne das kein Prüffall schreibbar ist |
| **Zehn offene Punkte, die eine Angabe verlangen** | `loesungsvorschlaege_neun_offene_260820.md` — fünf davon verlangen einen Namen, ein Datum oder eine Bedeutung, die **in keiner Quelle steht** |
| **M1 gegen die Zielumgebung** | Das Skript liegt im Repo; der Lauf braucht die Pilotumgebung und `frxfw` |

---

## Zeichnung

| | Empfehlung | |
|---|---|---|
| **1** | Der Harness fährt Tor 2, behebt am Code, fährt Tor 1, schreibt Manifest und Paket | ☐ so |
| **2** | **#41 wird zusammengeführt** — vor jeder Unterschrift | ☐ so · ☐ anders: ⟨ ⟩ |
| **3** | **Tor 3 wird diese Woche angefordert** | ☐ so · Anfordernde Person: ⟨ ⟩ |
| **4** | **Die Antwortlisten kommen bis 24.08.2026** | ☐ so · ☐ anderes Datum: ⟨ ⟩ |
| **5** | **BA-1 und BA-2 werden gegengezeichnet** | ☐ so · Datum: ⟨ ⟩ |
| **6** | Wird M5 zum 31.08. **vollständig** geschuldet oder als Vorarbeit geführt? | ☐ vollständig · ☐ Vorarbeit (setzt 5 voraus) |

| Name | Rolle | Datum |
|---|---|---|
| A. Han | für den Auftragnehmer (Nr. 158) | ⟨ ⟩ |
| M. Veil | für den Auftraggeber | ⟨ ⟩ |

---

*Der Harness meldet hier keinen grünen Stand. Er meldet, was gemessen ist, was gesperrt ist
und wer den nächsten Schritt in der Hand hat. „M5 DONE" ist ein Satz, den ein Mensch
unterschreibt — nicht einer, den ein Lauf ausgibt.*
