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

## Was zu tun ist — drei Schritte

### Schritt 1 · Eine echte Empfängeradresse bei einem fremden Anbieter wählen

Nicht `@freiraum.top` und nicht `@zaa.freiraum.top` — der Sinn der Prüfung ist, dass die
Mail den eigenen Zuständigkeitsbereich **verlässt** und die Echtheitsmerkmale beim fremden
Anbieter ankommen. Ein Postfach bei einem beliebigen Anbieter genügt, auf das Sie Zugriff
haben.

### Schritt 2 · Das Prüfkonto anlegen und den Versand auslösen

Am Rechner, auf dem der Schlüsselbund liegt. Die vier Namen sind dieselben wie in
`B2_Zugangsablage_260806.md` Abschnitt 3:

```bash
cd ~/freiraum-delivery

# Zugang — das Kennwort kommt aus dem Schlüsselbund, nie aus einer Datei
export FREIRAUM_SMTP_HOST=mail.bytecamp.net
export FREIRAUM_SMTP_USER=einladung@zaa.freiraum.top
export FREIRAUM_SMTP_PASS="$(security find-generic-password -s FREIRAUM_SMTP_PASS -w)"
export FREIRAUM_SMTP_TLS=1

# Der echte Lauf wird ausdrücklich freigeschaltet
export FREIRAUM_ECHTVERSAND=ja
export FREIRAUM_PRUEF_ECHT_EMPFAENGER="<Ihre Adresse beim fremden Anbieter>"

# Prüfstand
export PGHOST=localhost PGPORT=55433 PGUSER=postgres \
       PGPASSWORD=pilot PGDATABASE=freiraum_ci

# Das Prüfkonto anlegen — mit DENSELBEN beiden Werten
psql -v ON_ERROR_STOP=1 -f pruefungen/klauseln/anmeldecode_daten.sql
```

Danach liegt die Mail im gewählten Postfach.

### Schritt 3 · Den Mailkopf ablesen und ablegen

Im Postfach die zugestellte Mail öffnen, die **vollständige Kopfzeile** anzeigen lassen
(in den meisten Programmen *„Original anzeigen"* oder *„Quelltext anzeigen"*) und den Text
in eine Datei speichern — irgendwo außerhalb des Repos, damit keine Adressen im Bestand
landen:

```bash
export FREIRAUM_PRUEF_ECHT_MAILKOPF=~/mailkopf_150826.txt
./pruefungen/lauf.sh --bericht ~/lauf_150826.json
```

---

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
