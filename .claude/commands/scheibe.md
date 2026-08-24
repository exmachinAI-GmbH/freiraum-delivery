---
description: Baut die vertikale Scheibe $ARGUMENTS von der Klausel bis zur Vorlage
argument-hint: Scheibennummer (z. B. 1)
---

**Wie du schreibst.** Jeder Text, den dieser Lauf erzeugt — Plan, Baubericht, Manifesttext,
Vorlage, Übergabemeldung, Commit-Nachricht, Beschreibung des Antrags — folgt
`CONTRIBUTING.md` (Regeln `SPR-1` bis `SPR-9`). Lies die Datei, bevor du den ersten Text
schreibst. Die Beschreibung des Antrags muss allein tragen: die freigebende Person soll
entscheiden können, ohne den Code zu öffnen.

Baue die vertikale **Scheibe $ARGUMENTS** nach dieser Pipeline. Eine Scheibe ist ein
Ende-zu-Ende-Lauf; sie gilt erst als bestanden, wenn der **ganze** Faden wieder durchgeht
(G1, Blatt 11:25 · Definition of Done Blatt 11:46–48).

1. **Verfassung prüfen.** `./install.sh --pruefsumme`. Stimmt die Prüfsumme der Anlage
   „Bauverfahren" nicht mit dem Kopf der `CLAUDE.md` überein: **STOP**, Meldung an den
   Founder. Es wird nicht gebaut, sondern gefragt.
   **Nachgezogen am 16.08.2026:** Die Anlage „Bauverfahren" **existiert** und ist am
   07.08.2026 von M. Veil gezeichnet; ihre Prüfsumme steht im Kopf der `CLAUDE.md`. Der
   frühere Vermerk *„die Anlage existiert nicht"* stammte aus der Zeit vor der Zeichnung und
   ist überholt. **Der Schritt meldet also nicht mehr planmäßig „gesperrt"** — was er meldet,
   ist zu messen. Offen ist allein die Gegenzeichnung des Auftragnehmers.

2. **Klauseln laden.** Erzeuge oder lies `nachweise/klauselregister/register.json`:
   `python3 werkzeuge/klauselregister.py --konzepte "$FREIRAUM_KONZEPTE" \`
   `  --pflege nachweise/klauselregister/pflege.json \`
   `  --ziel nachweise/klauselregister/register.json --markdown nachweise/klauselregister/register.md`
   Schneide daraus **genau** die Klauseln der Scheibe $ARGUMENTS. Nie „lies alle 1231".
   Fehlt einer Klausel das **Akzeptanzkriterium**, liefert es der in derselben Zeile
   eingetragene fachliche Eigentümer nach; bis dahin bleibt der Bauauftrag unvollständig
   (K23-M02, K23:57). Die Klausel geht als Rückfrage hinaus, nicht in den Bau.
   **Nachgezogen am 16.08.2026:** Die Zuordnung Klausel → Scheibe **existiert** seit
   Antrag #21 für Scheibe 1 — `nachweise/klauselschnitt/` führt Zeichnungsblatt,
   Lesefassung und Wortmarken. Der frühere Vermerk *„existiert heute nicht"* ist überholt.
   **Unverändert gilt:** Der Harness erfindet die Zuordnung nicht, und das Zeichnungsblatt
   trägt bis heute kein gesetztes Kreuz — der Schnitt ist gemessen, nicht gezeichnet.

3. **Voraussetzungen prüfen.** Für Scheibe 1: V0 (N2 gegen die Zielumgebung), V1 (L2
   Identitätsvertrag), V2 (L1 Zeilenschutz), V3 (H07-Postfächer), V4 (dünner L3-Träger und
   **eine freigegebene** Vorlage), V5 (L4-Eintrag je aufgerufenem Agenten, vollständig) —
   Blatt 11:76–85. Für jede spätere Scheibe: die Breite der Vorgängerscheibe steht.
   Fehlt eine Voraussetzung: Schwelle **S2** (Blatt 11:202) — *Meldung, die Freigabe wird
   jetzt fällig.*

4. **Planen vor Delegation.** Schreibe `arbeit/Plaene/scheibe_$ARGUMENTS_plan.md`:
   Ziel der Scheibe · die neue Breite · Klauselliste mit Akzeptanzkriterium ·
   berührte Dateien · Migrationsbedarf · Fehlerpfade, die abbiegen müssen ·
   die drei Riegel (Zweckbestimmung · Unterschrift und beide Häkchen · Siegel;
   Blatt 11:59, :67, :72–74).
   Zwischen Bau und Prüfung wird **nichts** geteilt außer diesem Plan **ohne** den
   Abschnitt „berührte Dateien".

5. **Bau-Agent beauftragen.** Ziel · Ausgabeformat · Grenzen · Aufwand · Quellen
   (`vorlagen/subagent-auftrag.md` der Konzept-Fabrik). Gib ihm die Klauselliste, den Plan
   und die Schreibgrenzen mit. Er schreibt Code — **keine Datei unter `pruefungen/`**.

6. **Prüf-Agent GLEICHZEITIG und BLIND beauftragen.** Er bekommt **nur** Klauselwortlaut
   und Akzeptanzkriterium. Kein Code, kein Dateiname, kein Ausschnitt, keine
   Fehlermeldung aus dem Bau, kein Gesprächskontext. Er schreibt nach `pruefungen/`.
   Läuft auf einem **anderen Modell** als der Bau (F27). Beide Aufträge gehen im selben Zug
   hinaus — nacheinander wäre der zweite nicht mehr blind.

7. **Lauf.** Frische Datenbank, Schema, Migrationen, Seeds, dann der Faden:
   `./aufbau.sh` (Prüfumgebung, **kein** Pilotlauf, `aufbau.sh`:11–14) → `./pruefungen/lauf.sh`.
   Der Lauf biegt **mindestens einmal je Fehlerpfad** ab; ein reiner Erfolgsweg gilt als
   nicht durchgeführt (K23-M07, K23:62). Jeder Negativfall scheitert an **seiner** Bedingung,
   die Meldung im Wortlaut wird protokolliert (Bauauftrag :649; offener Punkt O-K23-7).

8. **Gates messen.** Tor 1 mechanisch (CI-Lauf oder lokal derselbe Ablauf), dann die
   fünfzehn sperrenden Gates aus K23 Abschn. 6 (:239–255). Jedes Ergebnis trägt **genau
   einen** Zustand: bestanden · fehlgeschlagen · gesperrt · nicht ausgeführt (K23-M22).
   Fehlgeschlagen und gesperrt tragen Befund, Verantwortlichen und Frist.
   Bei Fehlschlag: höchstens **drei** Anläufe, danach Eskalation (übertragene Hausregel,
   nicht gezeichnet). **Kein Prüfwert wird gesenkt und kein Prüffall gelöscht** (K23-D05).

9. **Manifest schreiben.** `nachweise/manifeste/scheibe_$ARGUMENTS_<Laufkennung>.json`
   mit allen acht Gliedern aus `CLAUDE.md` §4, maschinenlesbar, mit Prüfsumme über sich
   selbst (K23-M18). Glied 2 und 3 tragen bis auf Weiteres *gesperrt* — der Bauauftrag hat
   keine Prüfsumme (V-13), die Anlage existiert nicht. Danach Klauselregister,
   Herkunftsgraph und Restrisikoliste fortschreiben. Jedes kritische Restrisiko braucht eine
   **gezeichnete** Annahmeentscheidung — die Liste allein genügt nicht (Blatt 11:137).

10. **HALT — den Menschen fragen, ob das Fremdmodell jetzt anzufordern ist.**
    Tor 3, einmal je Scheibenabnahme (C-4): frische Instanz, getrennter Kontext, Prüfung
    gegen **Roh-Evidenz**, nicht gegen Erklärungen des Baus. Der Harness schreibt dieses
    Review **nie selbst**.

    **Dieser Schritt ist ein Halt, keine Notiz.** Führe aus:

    ```
    python3 werkzeuge/fremdreview.py --stand --scheibe $ARGUMENTS
    ```

    Lege das Ergebnis vor und stelle die Frage ausdrücklich — in dieser Form, damit sie
    nicht überlesen wird:

    > **Tor 3 · Scheibe $ARGUMENTS.** Der Stand ist: `<Ausgabe von --stand>`.
    > Soll das Fremdreview jetzt angefordert werden — ja oder nein?
    > · **Ja** → die Anforderung wird **mechanisch erzeugt** (siehe unten); der Mensch
    >   schickt sie ab, legt das Blatt unter `nachweise/fremdreview/` ab und zeichnet
    >   seinen Kopf.
    > · **Nein** → der Grund wird als benannter offener Punkt in die Vorlage
    >   geschrieben. Tor 3 bleibt **gesperrt** — nicht übersprungen.

    **Warte die Antwort ab.** Ohne sie wird Schritt 11 nicht ausgeführt.

    **Bei „Ja" — der Weg, gezeichnet am 24.08.2026.** Die Anlage „Bauverfahren" schreibt
    den Kanal vor: *„eigener Pfad, direkt zu OpenAI über MCP, nicht über die
    Azure-OpenAI-Ressource"* (:114, :201). Die Anfrage wird **nicht formuliert, sondern
    erzeugt** — aus Commit, Zweig und Belegpaket:

    ```
    python3 werkzeuge/tor3_belege.py --einheit $ARGUMENTS
    python3 werkzeuge/fremdreview_anfordern.py --einheit $ARGUMENTS \
        --auftragstext arbeit/Auftraege/<blatt>.md --paket <paket>.zip
    ```

    Das Werkzeug druckt danach den Befehl, den **ein Mensch** ausführt. **Führe ihn nicht
    aus.** Der Unterschied zwischen „der Harness ruft an" und „der Harness legt die
    Anfrage bereit" ist der ganze Gegenstand von HV-D16 (Anlage :229): *„Kein Tor-3-Review
    selbst schreiben."* Wer den Versand automatisiert, hebt ihn auf.

    Warum die Anfrage erzeugt und nicht geschrieben wird: Formuliert der Orchestrator sie
    frei, reist die Lesart des Baus mit, und das Modell prüft die Erzählung über den Stand
    statt den Stand. `gegen_roh_evidenz: ja` wäre dann eine Behauptung statt einer
    Eigenschaft des Ablaufs.

    Der Grund für diesen Halt ist gemessen, nicht vermutet: Bis zum 15.08.2026 ist Tor 3
    **kein einziges Mal** mit einem gültigen Nachweisblatt gelaufen — nicht weil jemand es
    abgelehnt hätte, sondern weil **nie ein Moment kam, in dem die Frage gestellt wurde**.
    Eine passive Sperre erzeugt keinen Anlass; sie erzeugt einen Zustand, den man übersieht.

    **Das ändert nichts an der Abnahme.** Der Halt ist Steuerung: er verschärft kein Tor
    und erzeugt keine zusätzliche Abnahmebedingung (Blatt 11:182–188). Er stellt eine
    Frage, deren Antwort ohnehin gebraucht wird — nur zum richtigen Zeitpunkt.

    **Wann gefragt wird — die Regel für den ganzen Harness.** Auslöser ist die
    **Scheibenabnahme**, so wie C-4 es zeichnet: *„einmal je Scheibenabnahme, nicht je
    Änderung."* Nicht die Meilensteinabnahme — sonst würde bei Scheibe 2, die M3 **und**
    M4 schließt, dreimal dasselbe gefragt, und eine Frage, die zu oft kommt, wird
    weggeklickt. C-4 begründet genau das: *„Ein Gate, das bei jedem Commit anschlägt, wird
    umgangen oder billig erfüllt — beides schlechter als kein Gate."*

    **Eine Ausnahme, und sie ist gemessen:** M10 (Durchstich), M11 (Last) und M12 (Abnahme)
    gehören **keiner Scheibe** an — die Baustrategie führt sie als *„Prüf- und Abnahmespur
    — quer, keine Scheibe"* (BS:125). Bei reiner Scheibenbindung fielen sie heraus. Für
    diese drei ist der Auslöser deshalb die **Meilensteinabnahme**, mit derselben Frage und
    demselben Halt.

    Umgekehrt gilt: **Scheibe 1 schließt keinen Meilenstein** (*„keinen — sie ist
    Integrationsprobe"*, BS:116). Bei reiner Meilensteinbindung würde ausgerechnet die
    erste Scheibe nie fragen. Deshalb tragen beide Auslöser, jeder für seinen Bereich —
    und keiner doppelt.

11. **Vorlage schnüren.** `arbeit/Vorlagen/scheibe_$ARGUMENTS_vorlage.md`: erreichte
    Klauseln mit Nachweis · Gate-Tabelle · Manifestprüfsumme · offene Punkte ·
    Restrisiken mit Träger und Frist · **leerer** Zeichnungsblock.
    Melde nur dieses Paket als Übergabe. **Kein Feld der menschlichen Entscheidung wird
    ausgefüllt**, kein Zweig zusammengeführt, kein Deployment ausgelöst.

**Kontext-Hygiene:** eine Scheibe je Sitzung, davor `/clear`. Aller Zustand liegt in Git,
`arbeit/` und `nachweise/` — nie im Gespräch.

**Nie:** eine Prüfdatei aus dem Bau heraus ändern · dem Prüf-Agenten Code zeigen · einen
grünen Lauf melden, der nichts gemessen hat · `ABNAHME` oder `IN_PROD` setzen · gegen
Echtdaten prüfen · K22 anfassen · eine offene Frage still entscheiden.
