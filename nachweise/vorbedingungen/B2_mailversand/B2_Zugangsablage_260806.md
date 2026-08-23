# B2 · Ablage der Zugangsdaten — Vermerk vom 06.08.2026, nachgeführt am 23.08.2026

> **In dieser Datei steht kein Kennwort.** Sie sagt, *wo* die Zugangsdaten liegen und wer sie
> holt — nicht, wie sie lauten.

> **NACHGEFÜHRT AM 23.08.2026 (X-1 aus BEF-B2-4).** Der Versand läuft nicht mehr über
> `einladung@zaa.freiraum.top`, sondern über `noreply@freiraum.top`. Der Grund ist gemessen
> und steht in Abschnitt 1a. Geändert sind: die Tabelle in Abschnitt 1, der neue Abschnitt 1a,
> die Ablagetabelle in Abschnitt 2, der Befehlsblock in Abschnitt 3 und zwei Absätze in
> Abschnitt 4. Der übrige Wortlaut vom 06.08.2026 ist unverändert.

---

## 1 · Die Postfächer

| Postfach | Zweck | Stand |
|---|---|---|
| **`noreply@freiraum.top`** | **Versand der Einladungen und Anmeldecodes — seit 23.08.2026** | bestand am 23.08.2026; ein Anlagedatum ist nicht belegt |
| `einladung@zaa.freiraum.top` | *bis 23.08.2026* Versand der Anmeldecodes — **nicht mehr benutzt**, siehe 1a | angelegt 06.08.2026 |
| `dmarc@freiraum.top` | Empfang der DMARC-Sammelberichte | angelegt 06.08.2026 · Kennwort seit 23.08.2026 auch M. Veil bekannt |
| `stoerung@zaa.freiraum.top` | Störungsweg (BV-13) | angelegt 06.08.2026 |

Die drei unteren am 06.08.2026 in der Bytecamp-Domainverwaltung angelegt und von A. Han
geprüft, Ergebnis positiv.

**Das ist ein Einrichtungsnachweis, keine B2-Abnahme.** Geprüft ist, dass die Postfächer
bestehen und erreichbar sind.

> **Was davon seit dem 23.08.2026 erledigt ist:** der Versand gegen den echten Dienst statt
> gegen den Testempfänger, die Messung des `d=`-Werts am zugestellten Mailkopf (Beschluss
> Nr. 43) sowie Codefrist und Fehlversuchssperre — alle drei durch AC-16 belegt
> (`ac16_pruefen_260823.log`, `kopf_260823.txt`, BEF-B2-5). **Offen bleibt** das Ende der
> Erstkonto-Ausnahme (Nr. 59).

---

## 1a · Warum der Versand das Postfach gewechselt hat

**Gemessen am 23.08.2026 an einem zugestellten Mailkopf** (dritte Handprobe, BEF-B2-4):

Meldet sich der Versand als `einladung@zaa.freiraum.top` an, signiert der Anbieter mit
`d=zaa.freiraum.top` — nicht mit `d=freiraum.top`. Zugleich hatte `zaa.freiraum.top` keinen
SPF-Eintrag, der Empfänger meldete `Received-SPF: none`.

AC-16 sucht im abgelesenen Kopf wörtlich nach `d=freiraum.top` **und** nach `spf=pass`.
**Zwei der sieben Kopfbedingungen wären über dieses Postfach nie erfüllbar gewesen** — der
Lauf wäre rot geworden, ohne dass am Bau etwas falsch ist.

Hinzu kam ein Widerspruch, der seit dem 06.08.2026 unbemerkt im Bestand lag:
`mail/versand.py` bindet den Absender fest auf `freiraum.top` und bricht **vor dem
Verbindungsaufbau** ab, wenn die Absenderdomäne eine andere ist. Der Programmtext verlangte
also `freiraum.top`, während diese Ablage ein Postfach in `zaa.freiraum.top` benannte.

Über `noreply@freiraum.top` ist derselbe Weg zweimal vollständig grün gemessen:
`d=freiraum.top`, `s=20260803`, `dkim=pass`, `spf=pass`, `dmarc=pass`.

*Unabhängig davon hat `zaa.freiraum.top` seit dem 23.08.2026 einen eigenen SPF-Eintrag
(`v=spf1 ip4:212.204.60.0/24 -all`). SPF vererbt sich nicht von der Elterndomäne — anders als
DMARC. Das ist kein Rückweg zum alten Postfach, sondern die Behebung einer Lücke, die auch
sonst geschadet hätte.*

---

## 2 · Wo die Zugangsdaten liegen

| | |
|---|---|
| Ablage | **macOS-Schlüsselbund** — lokal, nicht synchronisiert |
| Dienstnamen | `FREIRAUM_SMTP_PASS` · `FREIRAUM_DMARC_PASS` · `FREIRAUM_STOERUNG_PASS` |
| **Auf A. Hans Rechner** | `FREIRAUM_SMTP_PASS` für `einladung@zaa.freiraum.top` · die beiden übrigen · angelegt 06.08.2026 |
| **Auf M. Veils Rechner** | `FREIRAUM_SMTP_PASS` für **`noreply@freiraum.top`**, angelegt 23.08.2026 · dazu das Kennwort von `dmarc@freiraum.top` |
| Verlustfall | über die Bytecamp-Mailverwaltung jederzeit zurücksetzbar — **am 23.08.2026 einmal ausgeführt und damit belegt.** Anmeldung dort als `postmaster@freiraum.top` mit dem Domainpasswort |

> **Der Dienstname allein ist nicht mehr eindeutig.** Auf zwei Rechnern liegt unter
> `FREIRAUM_SMTP_PASS` das Kennwort **verschiedener** Postfächer. `security
> find-generic-password -s FREIRAUM_SMTP_PASS -w` **ohne** `-a` liefert den ersten Treffer und
> damit womöglich das falsche. `werkzeuge/ac16_echtlauf.sh` sucht seit dem 23.08.2026
> ausdrücklich mit `-a "$FREIRAUM_SMTP_USER"`.

**Nicht geheim und deshalb nicht im Schlüsselbund** (sie stehen ohnehin in den Blättern):
Server `mail.bytecamp.net` · Port 587 STARTTLS oder 465 TLS · Benutzername ist die
vollständige Adresse · `FREIRAUM_SMTP_TLS=1`.

---

## 3 · Wie sie zur Laufzeit gesetzt werden

```bash
export FREIRAUM_SMTP_HOST=mail.bytecamp.net
export FREIRAUM_SMTP_USER=noreply@freiraum.top
export FREIRAUM_SMTP_PASS="$(security find-generic-password \
        -s FREIRAUM_SMTP_PASS -a "$FREIRAUM_SMTP_USER" -w)"
export FREIRAUM_SMTP_TLS=1
```

So entsteht **zu keinem Zeitpunkt eine Datei mit dem Kennwort** — weder im Repo noch in der
Dropbox noch im Benutzerverzeichnis. Genau diese vier Namen erwartet die B2-Abnahme, wenn sie
gegen den echten Versand wiederholt wird.

*Das `-a` ist seit dem 23.08.2026 Pflicht, nicht Schmuck — siehe den Kasten in Abschnitt 2.*

---

## 4 · Was offen bleibt

**Ein zweiter Zugriff besteht nicht — das galt bis zum 23.08.2026.** Der Schlüsselbund teilt
nichts, aber ein Postfachkennwort ist kein verlorener Schlüssel: Es lässt sich in der
Mailverwaltung des Anbieters neu setzen. Genau so ist der Echtlauf am 23.08.2026 zustande
gekommen, ohne A. Hans Rechner. **Für die Dauer bleibt ein geteilter Tresor richtig** (M-14);
Voraussetzung für einen Echtlauf ist er nicht mehr.

**Wer den Versand auslöst, war nicht festgelegt.** Am 23.08.2026 hat **M. Veil** ihn ausgelöst
und den Kopf selbst abgelesen. Das ist ein Vollzug, keine Zeichnung — die Zuweisung für
künftige Läufe steht weiterhin aus, und Blatt 04 weist BR Andrew nach wie vor nur die Messung
zu.

**Der Ablageort ist eine Arbeitsentscheidung, keine gezeichnete.** Der Konzeptbestand nennt an
keiner Stelle einen verbindlichen Ort für Geheimnisse, sondern durchgehend nur
*„Passwortmanager oder Key Vault"* als Platzhalter. Seit dem 23.08.2026 liegen dieselben
Zugangsdaten auf **zwei** Rechnern — das schärft die Frage, statt sie zu beantworten.

**Der vorhandene Azure-Tresor wurde bewusst nicht verwendet.** `kv-wmi3776qfhw2q`
(`rg-freiraum-prod`) liegt in **westeurope** und gehört zum Stapel `freiraum-builder:v13` —
nicht zum Piloten. Eine Ablage dort verstieße gegen K13-M15 (F05, `swedencentral`) und wäre
zudem nicht möglich: das Betriebskonto besitzt dort keine Datenebenen-Rolle.

**`einladung@zaa.freiraum.top` hat seit dem 23.08.2026 keine Aufgabe mehr.** Ob es bestehen
bleibt, gelöscht wird oder einen anderen Zweck bekommt, ist nicht entschieden — es steht als
Vorschlag X-3 in BEF-B2-4.

---

*Erstellt am 06.08.2026. Nachgeführt am 23.08.2026 nach BEF-B2-4. Enthält keine Werte, nur
Orte. Geltender Mailstand ist der Nachtrag vom 04.08.2026
(`entscheidungsvorlagen/final_entscheidung-pflichtangaben/260804_Nachtrag_Bytecamp.md`);
die Dateien `B2_DNS_Stand_260802.md` und `B2_Anbieterantwort_260803.md` sind überholt.*
