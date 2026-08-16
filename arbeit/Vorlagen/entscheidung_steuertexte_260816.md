# Entscheidungsvorlage · Die Steuerungstexte sind von der Wirklichkeit abgedriftet

**47 Meldungen, 27 halten stand. Fünf halten einen Bau an.**

| | |
|---|---|
| **An** | M. Veil (Auftraggeber) · A. Han (für den Auftragnehmer) |
| **Von** | Orchestrator des Coding-Harness |
| **Art** | **Vorlage. Keine Entscheidung.** |
| **Vorgelegt** | 16.08.2026 |
| **Vollständiger Bericht** | `arbeit/Bauberichte/steuertexte_pruefung_260816.md` |

---

## Der Anlass

An **einem** Tag sind vier Stellen aufgefallen, an denen ein Steuerungstext des Harness etwas
behauptet, das nicht mehr stimmt — zweimal im Bau-Kommando, zweimal in der Verfassung selbst.
**Alle vier sind zufällig aufgefallen**, beim Danebenlesen.

Deshalb wurde einmal systematisch gemessen. Das Urteil:

> Die Steuerungstexte sind **nicht flächendeckend falsch, sondern an den Nahtstellen
> abgerissen**: die Sachaussagen halten fast durchweg — aber **jede Angabe, die auf eine
> fremde Datei zeigt oder einen Zustand behauptet, ist verrottet.**

Und die Diagnose in einem Satz:

> **Behauptungen über Code werden gemessen, Behauptungen über Dokumente nie.**

Ein veralteter Steuerungstext ist schlimmer als gar keiner: Er erzeugt Vorbehalte, die
niemand hinterfragt, weil sie amtlich aussehen.

---

## Teil 1 · Die eine echte Regelfrage

**`app/` steht in keiner Grenze des Harness — weder als Erlaubnis noch als Verbot.**

Die Verfassung nennt als Schreibziel des Bau-Agenten sechs Ordner. **`app/` ist nicht
darunter** — obwohl dort seit dem 10.08.2026 die gesamte Anwendung liegt: fünfzehn Dateien im
gültigen Stand, und die Prüfstrecke lintet sie ausdrücklich mit.

**Das hat zwei Seiten, und die zweite ist die gefährlichere:**

| | |
|---|---|
| **Der Bau-Agent** hat für sein eigenes Arbeitsverzeichnis **keine Erlaubnis** | Jeder Bauzug in `app/` läuft formal ungedeckt — auch M3 und M4 |
| **Der blinde Prüf-Agent** hat **kein Verbot**, dort hineinzusehen | Die Blindheit, auf der die ganze Prüfstrecke ruht, ist für den Ordner mit der Anwendung **nirgends aufgeschrieben** |

Dass sie bisher gehalten hat, lag daran, dass sie in jedem einzelnen Auftrag ausdrücklich
gesetzt wurde. **Sie hing an der Sorgfalt, nicht an der Regel.**

> **Wichtig für die Zeichnung:** Diese Grenze steht **nicht** in der gezeichneten Anlage. Sie
> ist eine Zutat der ausführbaren Datei und lässt sich ohne Berührung der Prüfsumme
> berichtigen — geprüft.

### Handlungsempfehlung: **berichtigen, und zwar beide Seiten**

> | Schreibt nach | `app/ install/ mail/ migrations/ seeds/ schema/ werkzeuge/` sowie die
> erzeugten Nachweise unter `nachweise/` und die Bauunterlagen unter `arbeit/` |
> **ausschließlich `pruefungen/`** |

Und in der Beschreibung des Prüf-Agenten wird `app/` in die Liste dessen aufgenommen, was er
**nie liest**. Ohne diesen zweiten Halbsatz ist die Berichtigung nur halb.

- [ ] **Berichtigen wie vorgeschlagen** ✅ *Empfehlung*
- [ ] **anders:** ⟨…⟩

---

## Teil 2 · Die vier übrigen, die einen Bau anhalten

Alle vier sind **Berichtigungen von Tatsachen**, keine Regeländerungen. Sie brauchen keine
Zeichnung — nur Ihre Kenntnisnahme, dass sie ausgeführt werden.

| | Was behauptet wird | Was gilt |
|---|---|---|
| **A2** | Das Bau-Kommando führt zwei Glieder der Nachweiskette als *gesperrt* | Beide Prüfsummen sind belegt und rechnen nach |
| **A3** | Ein Arbeitsschritt schickt Klauseln an einen Adressaten | Den Adressaten gibt es nicht |
| **A4** | Ein Arbeitsschritt baut die Prüfdatenbank auf | Er baut die falsche |
| **A5** | Die Übergabe hält einen grünen Stand für ungemessen | Er ist gemessen |

**Dazu, aus derselben Familie:** Das Etikett, an dem die Fremdprüfung hängt, **existiert im
Repository nicht** — deshalb sind alle 29 bisherigen Läufe übersprungen worden, während zwei
Steuerungstexte den Fehler beim Benutzer suchen. Und **sämtliche Zeilenverweise auf den
Bauauftrag** zeigen auf die abgelöste Fassung.

- [ ] **Kenntnis genommen, wird ausgeführt** ✅ *Empfehlung*

---

## Teil 3 · Wie verhindert man, dass es wieder passiert?

Die Prüfung hat **eine** Empfehlung ausgesprochen, und sie stützt sich auf etwas, das dieses
Projekt schon zweimal gebaut hat:

> **Ein Werkzeug, das jede Fundstelle der Steuerungstexte nachschlägt — als sperrender
> Schritt in der Prüfstrecke.**
>
> `install.sh --pruefsumme` misst die Verfassung gegen die Anlage. `herkunft.py` rechnet den
> Herkunftsgraphen nach. Es fehlt nur die dritte Anwendung desselben Gedankens: **eine
> Behauptung über eine Datei ist nachrechenbar wie eine Prüfsumme.**

**Und es muss sperren, nicht warnen.** Der Beleg liegt im eigenen Haus: Die vorhandene
Aktualitätsprüfung des Herkunftsgraphen meldet nur eine Warnung — und der eingecheckte Graph
auf der Hauptspur ist nachweislich veraltet. **Eine Warnung bewirkt hier nichts.**

**Fünfzehn der 27 Funde hätte dieses Werkzeug am Tag ihrer Entstehung gefunden**,
einschließlich der vier, die gestern zufällig auffielen.

Für den Rest — Zustandsbehauptungen wie *„die Anlage existiert nicht"* — genügt die
schwächere Schwester derselben Regel: **jede Behauptung über einen Zustand trägt den Befehl,
der sie erzeugt hat, direkt daneben.** Die Abendübergabe vom 15.08. macht das bereits vor.

### Handlungsempfehlung: **beides**

- [ ] **Das Werkzeug wird gebaut und sperrt** ✅ *Empfehlung* — es ist bereits in Arbeit
- [ ] **Die Schwesterregel wird aufgenommen**: jede Zustandsbehauptung in einem
      Steuerungstext trägt den Befehl daneben, der sie belegt ✅ *Empfehlung*
- [ ] **anders:** ⟨…⟩

> **Ein Vorbehalt, der dazugehört.** Ein Fundstellenprüfer findet keine Behauptung, die nie
> irgendwo stand. Die Prüfung hat genau so einen Fall gefunden: **ein erfundenes Zitat trägt
> eine ganze Regel.** Was das Werkzeug nicht kann, wird ausdrücklich aufgeschrieben — ein
> Werkzeug, dessen Grenzen niemand kennt, erzeugt falsche Sicherheit.

---

## Zeichnung

*Dieser Block wird von Menschen ausgefüllt. Der Harness trägt hier nichts ein.*

| Name | Rolle | Datum | Anmerkung |
|---|---|---|---|
| **M. Veil** | Auftraggeber | | |
| **A. Han** | für den Auftragnehmer (Nr. 158) | | |

---

*Erstellt am 16.08.2026 vom Orchestrator des Coding-Harness. 47 Meldungen aus fünf
Suchrichtungen, jede einzeln am Original nachgeprüft; 20 verworfen. **Diese Vorlage
entscheidet nichts.***
