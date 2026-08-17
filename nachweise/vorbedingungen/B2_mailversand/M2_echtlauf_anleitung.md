# Teilaussage 1 der M2-Nachrechnung schließen — Anleitung

> **Wofür das gut ist.** Der Meilenstein M2 verlangt vier Dinge. Drei sind gemessen und
> bestanden. Das vierte lautet wörtlich: *„eine echte Zustellung mit abgelesenem
> Mailkopf"*. Es ist heute **gesperrt** — nicht durchgefallen, sondern nicht messbar,
> weil zwei Angaben fehlen, die nur ein Mensch beibringen kann.
>
> Diese Anleitung sagt, wer was tut. Sie enthält **kein Kennwort**.

Stand: 15.08.2026 · Prüffall `AC-16` in `pruefungen/klauseln/anmeldecode_lauf.sh`

---

## Warum es kein Werkzeug allein kann

Zwei Sperren, beide bewusst so gebaut:

**1 · Das Kennwort teilt sich nicht.** Der Vermerk vom 06.08.2026 legt es fest: die
Zugangsdaten liegen im macOS-Schlüsselbund **auf dem Rechner von A. Han**, lokal und nicht
synchronisiert. Wörtlich: *„Ein zweiter Zugriff besteht nicht. Der Schlüsselbund teilt
nichts."*

**2 · In ein fremdes Postfach kann der Lauf nicht schauen.** Der Prüffall sagt das selbst:
*„Dieser Lauf kann nicht selbst in ein fremdes Postfach schauen."* Der Mailkopf muss bei
einem **anderen** Anbieter tatsächlich zugestellt, dort geöffnet und als Datei abgelegt
werden. Genau darin liegt der Beweiswert — ein Nachweis, den die Maschine sich selbst
ausstellt, ist keiner.

**Wer den Versand auslöst, ist nicht festgelegt.** Blatt 04 weist BR Andrew die *Messung*
des Mailkopfs zu, nicht den Versand. Das ist ein offener Punkt aus dem Vermerk vom 06.08.,
kein Versäumnis dieser Anleitung.

---

## Was zu tun ist — fünf Schritte in ZWEI Durchgängen

> **Neu seit dem 17.08.2026.** AC-16 nahm bis dahin jeden Mailkopf, auch einen alten — der Kopf
> vom 10.08.2026 hätte den Fall beliebig oft bestehen lassen (Befund **Blatt 89**). Er ist
> seither an einen **nachweislich frischen** Versand gebunden. Das kostet einen zweiten
> Durchgang und macht den Nachweis erst zu einem.

```
Durchgang 1   verschicken        ->  AC-16 GESPERRT: "Kopf jetzt holen"
   Mensch     Kopf ablesen, ablegen
Durchgang 2   pruefen            ->  AC-16 BESTANDEN
```

**Zwischen beiden höchstens 20 Minuten.** Und: **im zweiten Durchgang die Daten NICHT neu
einspielen** — der Einladungstoken ist einmalig (K20-D10), ein neuer Lauf von
`anmeldecode_daten.sql` würfe den soeben erzeugten Beleg weg.

### Schritt 1 · Eine echte Empfängeradresse bei einem fremden Anbieter wählen

Nicht `@freiraum.top` und nicht `@zaa.freiraum.top` — der Sinn der Prüfung ist, dass die Mail
den eigenen Zuständigkeitsbereich **verlässt** und die Echtheitsmerkmale beim fremden Anbieter
ankommen. Ein Postfach bei einem beliebigen Anbieter genügt, auf das Sie Zugriff haben.

### Schritt 2 · Umgebung setzen und Prüfkonto anlegen

Am Rechner, auf dem der Schlüsselbund liegt. Die vier Namen sind dieselben wie in
`B2_Zugangsablage_260806.md` Abschnitt 3.

```bash
cd ~/freiraum-delivery

# Zugang -- das Kennwort kommt aus dem Schluesselbund, nie aus einer Datei
export FREIRAUM_SMTP_HOST=mail.bytecamp.net
export FREIRAUM_SMTP_USER=einladung@zaa.freiraum.top
export FREIRAUM_SMTP_PASS="$(security find-generic-password -s FREIRAUM_SMTP_PASS -w)"
export FREIRAUM_SMTP_TLS=1

# Der echte Lauf wird ausdruecklich freigeschaltet
export FREIRAUM_ECHTVERSAND=ja
export FREIRAUM_PRUEF_ECHT_EMPFAENGER="<Ihre Adresse beim fremden Anbieter>"
export FREIRAUM_PRUEF_ECHT_MAILKOPF=~/mailkopf.txt

# Pruefstand
export PGHOST=localhost PGPORT=55433 PGUSER=postgres \
       PGPASSWORD=pilot PGDATABASE=freiraum_ci

# Das Pruefkonto anlegen -- GENAU EINMAL, nicht zwischen den Durchgaengen
psql -v ON_ERROR_STOP=1 -f pruefungen/klauseln/anmeldecode_daten.sql
```

### Schritt 3 · Durchgang 1 — verschicken

```bash
./pruefungen/lauf.sh --bericht ~/lauf_ac16.json
```

**Erwartet:** AC-16 meldet **GESPERRT** mit dem Satz *„Echter Versand ausgeloest und von
mail_delivery bestaetigt … Jetzt binnen 20 Minuten den ZUGESTELLTEN Rohkopf lesen"*.

**Das ist der Erfolg dieses Durchgangs, nicht sein Fehlschlag.** Die Mail ist unterwegs.

### Schritt 4 · Den Mailkopf ablesen und ablegen

Im Postfach die zugestellte Mail öffnen, den **vollständigen Rohkopf** anzeigen lassen (in
Gmail: ⋮ → *Original anzeigen*; anderswo *Quelltext anzeigen*) und **unverändert** in die Datei
schreiben, die in Schritt 2 benannt wurde:

```bash
pbpaste > ~/mailkopf.txt        # macOS, direkt nach dem Kopieren
head -20 ~/mailkopf.txt         # nachsehen, ob es gestimmt hat
```

Gebraucht werden vier Zeilen: `Authentication-Results`, `DKIM-Signature`, **`Date`** und
**`To`**. Die letzten zwei sind seit dem 17.08. neu — sie tragen die Bindung.

> **Falle:** Wird die Datei mit TextEdit geschrieben, vorher **Format → In reinen Text
> umwandeln**. Sonst steht RTF-Auszeichnung darin und der Kopf ist nicht lesbar.

### Schritt 5 · Durchgang 2 — prüfen

Dieselbe Umgebung, dieselbe Sitzung, **ohne** `anmeldecode_daten.sql`:

```bash
./pruefungen/lauf.sh --bericht ~/lauf_ac16_zwei.json
```

**Erwartet:** AC-16 **BESTANDEN**. Der Fall löst diesmal keine zweite Einlösung aus — er
findet den frischen `mail_delivery`-Nachweis aus Durchgang 1 und prüft den Kopf gegen ihn.

---

## Was schiefgehen kann, und was es bedeutet

| Meldung | Bedeutung |
|---|---|
| *„Kein frischer Versand ausloesbar: Status 200 statt 303"* | Der Token ist verbraucht. `anmeldecode_daten.sql` neu einspielen und bei Schritt 3 beginnen |
| *„Date … liegt Xs vom server-eigenen Versand entfernt"* | Der Kopf gehört nicht zu diesem Versand — meist ein alter Kopf, oder die 20 Minuten sind abgelaufen |
| *„Date-Zeile nicht auswertbar"* | Der Kopf trägt `-0000` (Zeitzone unbekannt) oder wurde umformatiert. Rohkopf erneut ablegen |
| *„To nennt nicht den geprueften Empfaenger"* | Die Mail im falschen Postfach geöffnet |
| *„mail_delivery zeigt (noch) keinen uebergebenen Versand"* | Entweder verzögert — dann Schritt 5 gleich noch einmal — oder der Versand ist wirklich gescheitert |

**Alle diese Meldungen sperren, sie bestehen nicht.** Nach K23-M22 ist *nicht messbar* nicht
dasselbe wie *in Ordnung*.

## Woran der Lauf misst

Der Prüffall sucht im abgelesenen Kopf vier Angaben. Sie sind **nicht ausgedacht**, sondern
aus `B2_Abnahmeprotokoll.md` Abschnitt 5/6 übernommen — dieselben Felder, die der Einzellauf
vom 10.08.2026 abgelesen hat:

| Was im Kopf stehen muss | Was es bedeutet |
|---|---|
| `DKIM-Signature ... d=freiraum.top` | die Mail ist mit dem Schlüssel **unserer** Domäne unterschrieben |
| `dkim=pass` | der fremde Anbieter hat diese Unterschrift geprüft und für gültig befunden |
| `spf=pass` | der Versandserver darf für unsere Domäne senden |
| `dmarc=pass` | beides zusammen erfüllt die Regel, die unsere Domäne selbst veröffentlicht |

Fehlt eine der vier, meldet der Lauf **fehlgeschlagen** — nicht gesperrt. Das ist der
Unterschied zwischen *„konnte nicht gemessen werden"* und *„gemessen und nicht in Ordnung"*.

---

## Was danach gilt

Läuft `AC-16` durch, ist Teilaussage 1 **wiederholbar** belegt statt nur durch den
Einzellauf vom 10.08.2026. Zusammen mit den drei bereits bestandenen Teilaussagen —
Protokollzeile, Zehnminutenfrist, Fünf-Fehlversuche-Sperre — ist die Nachrechnung von M2
dann vollständig.

**Vorher nicht.** Nach K23-M22 gilt: was nicht gemessen werden konnte, ist *gesperrt*,
nicht *bestanden*. Ein Meilenstein tritt ein oder nicht; einen Zwischenzustand kennt die
Nachrechnung nicht — das ist ihr Zweck.

---

## Ein Hinweis, der nicht zu dieser Anleitung gehört, aber dazu

Der Bauauftrag ordnet M2 die Konzepte **K03 · K02 · K11** zu. Gemessen am 15.08.2026:
von den **54 Regeln des Betriebs-Portals (K11)** ist keine einzige umgesetzt, keine
erwähnt, keine durch einen Test belegt.

Für die *Nachrechnung* von M2 spielt das keine Rolle — sie misst die vier Sätze, sonst
nichts. Für die Frage, ob nach M2 etwas trägt, spielt es sehr wohl eine. Das ist ein
Projektbefund, keine Abnahmebedingung.
