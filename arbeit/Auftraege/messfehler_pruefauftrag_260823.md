# Prüfauftrag · **Zwei Messfehler** — VP-18 und die verworfenen Fehlermeldungen

**23.08.2026 · Auftrag an den Prüf-Agenten.** Du arbeitest im Blindstand: der
Umsetzungscode ist auf Betriebssystemebene nicht lesbar. Das ist kein Hindernis, das ist
der Auftrag.

**Anlass:** Fremdreview `nachweise/fremdreview/teilschnitt-anmeldung_260820.md`, Urteil
`trägt nicht`, Gründe **11** und **12**. Beide liegen unter `pruefungen/` und damit
ausschließlich in deiner Hand — der Bau-Agent darf dort keine Datei anfassen, auch nicht
den Tippfehler (`CLAUDE.md`:265).

> **Warum diese beiden zuerst und getrennt von den übrigen zehn.** Die anderen zehn Gründe
> betreffen den **Bau**. Diese beiden betreffen das, **womit** gebaut und gemessen wird. Ein
> Messfehler ist keine Zeile wie die anderen: Er verfälscht jedes Ergebnis, das mit ihm
> entstanden ist — rückwirkend und unbemerkt.

---

## Auftrag 1 · VP-18 misst zugunsten des Standes — **der gefährlichere**

**Der Befund im Wortlaut des Fremdmodells:**

> *„VP-18 misst zugunsten des Standes: er wertet K04-M08 als erfüllt, wenn ein
> `TERMIN_ANGEFRAGT`-Ereignis entsteht — er beweist ‚Ereignis vermerkt', nicht ‚Gespräch
> vereinbart'. Ein verbliebener Messfehler."*

**Was daran wiegt.** K04-M08 verlangt nach dem Halt den Ausweg *Termin*. VP-18 gehört zu den
32 Fällen, mit denen **M3 am 15.08.2026 als eingetreten gemeldet wurde** — 32 von 32, keiner
gesperrt, keiner gescheitert. Trägt einer dieser 32 einen Messfehler, ist die Zahl nicht
falsch; sie belegt etwas anderes als angenommen. **Das ist die gefährliche Richtung: falsch
grün.**

**Was zu tun ist**

1. **Feststellen, was K04-M08 im Wortlaut verlangt** — aus dem Klauselregister, nicht aus
   der Erinnerung und nicht aus dem Prüffall.
2. **Feststellen, was VP-18 heute tatsächlich misst.** Wenn zwischen beidem eine Lücke liegt:
   benennen, **nicht** stillschweigend schließen.
3. **Entscheiden, ob die Lücke im Prüffall liegt oder im Bau.** Beides ist möglich, und die
   Antwort ist nicht dieselbe:
   - Liegt sie im **Prüffall** — er misst zu wenig —, ist der Fall zu berichtigen. Trifft der
     berichtigte Fall dann nicht mehr zu, ist das ein **Baubefund** und wird als solcher
     gemeldet, nicht durch eine Abschwächung des Falls beseitigt.
   - Liegt sie im **Bau** — der Ausweg *Termin* löst die Ansprechperson nicht auf, vgl.
     Grund 9 desselben Reviews —, gehört sie in einen Befund an den Bau. Der Prüffall bleibt
     dann, wie er ist, und meldet rot statt grün.
4. **Prüfen, ob derselbe Fehler in weiteren Fällen steckt.** VP-18 ist der benannte; er muss
   nicht der einzige sein. Ein Fall, der ein *Ereignis* prüft, wo eine *Wirkung* verlangt
   ist, hat dieselbe Bauart.

**Was du ablegst:** die Berichtigung unter `pruefungen/klauseln/`, und einen Befund unter
`nachweise/befunde/` mit der Kennung `BEF-VP-18-…` — mit dem Wortlaut der Klausel, dem
Wortlaut des alten Falls und der Begründung, warum der neue misst, was verlangt ist.

**Was ausdrücklich mit zu melden ist:** wie viele der 32 M3-Fälle von der Berichtigung
betroffen sind und ob M3 danach unverändert als eingetreten gilt. **Diese Angabe ist Teil des
Auftrags, nicht eine Zugabe.**

---

## Auftrag 2 · Die tatsächlichen Fehlermeldungen gehen verloren

**Der Befund im Wortlaut:**

> *„Zu Frage 22 fehlen die tatsächlichen Fehlermeldungen — der Harness verwirft sie im
> Erfolgszweig und gibt nur ‚scheitert an $erwartet' aus (`pruefungen/lauf.sh`:302-304)."*

**Was daran wiegt.** Ein Negativfall gilt als bestanden, wenn er scheitert. **Woran** er
scheitert, wird nicht ausgegeben — nur, woran er scheitern sollte. Damit besteht auch ein
Fall, der aus dem **falschen** Grund scheitert. Genau diesen Fehlertyp führt der Bestand
selbst mehrfach unter *„FALSCHE BEDINGUNG"* — dort wird er erkannt, im Erfolgszweig nicht.

**Nachgemessen am 23.08.2026:** Der Zweig besteht weiterhin; die Zeilennummern haben sich seit
dem 20.08. verschoben. Der Befund ist damit **nicht erledigt, sondern neu zu verorten.**

**Was zu tun ist**

1. Im Erfolgszweig die tatsächliche Fehlermeldung **mit ausgeben** — nicht nur den erwarteten
   Wortlaut. Eine Zeile, die beides nebeneinanderstellt, macht den Unterschied sichtbar.
2. Prüfen, ob die Ausgabe damit Geheimnisse oder unmaskierte Personenangaben tragen kann
   (K23-D09). Wenn ja: maskieren, aber **nicht** weglassen.
3. Einen Fall mitliefern, der belegt, dass die Unterscheidung greift — ein Negativfall, der
   aus dem falschen Grund scheitert, muss danach **auffallen**.

**Was du ablegst:** die Berichtigung in `pruefungen/lauf.sh` und einen Befund unter
`nachweise/befunde/`.

---

## Zwei Regeln für beide Aufträge

**Kein Fall wird abgeschwächt, damit er besteht.** Wenn eine Berichtigung dazu führt, dass
ein bisher grüner Punkt rot wird, ist das **das Ergebnis** — nicht ein Problem, das durch
Nachjustieren des Falls zu beseitigen wäre. Nicht gemessen ist nicht bestanden (K23-M22);
falsch gemessen ist schlechter als beides.

**Der Bau-Agent liest deine Dateien nicht und schreibt sie nicht.** Umgekehrt bleibt der
Umsetzungscode für dich gesperrt. Wo du einen Baufehler vermutest, schreibst du einen Befund
— du behebst ihn nicht.

---

*Ausgefertigt am 23.08.2026. Der Anlass steht in `arbeit/Vorlagen/tor3_zwoelf_gruende_260823.md`,
Gründe 11 und 12 — dort auch, warum sie vor den übrigen zehn stehen.*
