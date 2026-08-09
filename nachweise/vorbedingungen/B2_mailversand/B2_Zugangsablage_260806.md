# B2 · Ablage der Zugangsdaten — Vermerk vom 06.08.2026

> **In dieser Datei steht kein Kennwort.** Sie sagt, *wo* die Zugangsdaten liegen und wer sie
> holt — nicht, wie sie lauten.

---

## 1 · Die drei Postfächer

| Postfach | Zweck | Stand 06.08.2026 |
|---|---|---|
| `einladung@zaa.freiraum.top` | Versand der Anmeldecodes | angelegt |
| `dmarc@freiraum.top` | Empfang der DMARC-Sammelberichte | angelegt |
| `stoerung@zaa.freiraum.top` | Störungsweg (BV-13) | angelegt |

Alle drei am 06.08.2026 in der Bytecamp-Domainverwaltung angelegt und von A. Han geprüft,
Ergebnis positiv.

**Das ist ein Einrichtungsnachweis, keine B2-Abnahme.** Geprüft ist, dass die Postfächer
bestehen und erreichbar sind. Offen bleiben unverändert: der Versand gegen den echten Dienst
statt gegen den Testempfänger, die Messung des `d=`-Werts am zugestellten Mailkopf
(Beschluss Nr. 43, verantwortlich BR Andrew), die Prüfung von Codefrist und
Fehlversuchssperre sowie das Ende der Erstkonto-Ausnahme (Nr. 59).

---

## 2 · Wo die Zugangsdaten liegen

| | |
|---|---|
| Ablage | **macOS-Schlüsselbund** auf dem Rechner von A. Han — lokal, nicht synchronisiert |
| Dienstnamen | `FREIRAUM_SMTP_PASS` · `FREIRAUM_DMARC_PASS` · `FREIRAUM_STOERUNG_PASS` |
| Angelegt am | 06.08.2026 |
| Zugriff | A. Han |
| Verlustfall | über die Bytecamp-Domainverwaltung jederzeit zurücksetzbar — der Schaden wäre ein unterbrochener Versand, kein Verlust |

**Nicht geheim und deshalb nicht im Schlüsselbund** (sie stehen ohnehin in den Blättern):
Server `mail.bytecamp.net` · Port 587 STARTTLS oder 465 TLS · Benutzername ist die
vollständige Adresse · `FREIRAUM_SMTP_TLS=1`.

---

## 3 · Wie sie zur Laufzeit gesetzt werden

```bash
export FREIRAUM_SMTP_HOST=mail.bytecamp.net
export FREIRAUM_SMTP_USER=einladung@zaa.freiraum.top
export FREIRAUM_SMTP_PASS="$(security find-generic-password -s FREIRAUM_SMTP_PASS -w)"
export FREIRAUM_SMTP_TLS=1
```

So entsteht **zu keinem Zeitpunkt eine Datei mit dem Kennwort** — weder im Repo noch in der
Dropbox noch im Benutzerverzeichnis. Genau diese vier Namen erwartet die B2-Abnahme, wenn sie
gegen den echten Versand wiederholt wird.

---

## 4 · Was offen bleibt

**Ein zweiter Zugriff besteht nicht.** Der Schlüsselbund teilt nichts. Muss BR Andrew für die
Messung des Mailkopfs **selbst versenden**, braucht es einen geteilten Tresor; löst A. Han den
Versand aus und BR Andrew prüft die Zustellung, bleibt es bei dieser Ablage. **Wer den Versand
auslöst, ist nicht festgelegt** — Blatt 04 weist BR Andrew die Messung zu, nicht den Versand.

**Der Ablageort ist eine Arbeitsentscheidung, keine gezeichnete.** Der Konzeptbestand nennt an
keiner Stelle einen verbindlichen Ort für Geheimnisse, sondern durchgehend nur
*„Passwortmanager oder Key Vault"* als Platzhalter. Solange es keine Zugangsdaten gab, war das
folgenlos; seit heute gibt es welche.

**Der vorhandene Azure-Tresor wurde bewusst nicht verwendet.** `kv-wmi3776qfhw2q`
(`rg-freiraum-prod`) liegt in **westeurope** und gehört zum Stapel `freiraum-builder:v13` —
nicht zum Piloten. Eine Ablage dort verstieße gegen K13-M15 (F05, `swedencentral`) und wäre
zudem nicht möglich: das Betriebskonto besitzt dort keine Datenebenen-Rolle.

---

*Erstellt am 06.08.2026. Enthält keine Werte, nur Orte. Geltender Mailstand ist der Nachtrag
vom 04.08.2026 (`entscheidungsvorlagen/final_entscheidung-pflichtangaben/260804_Nachtrag_Bytecamp.md`);
die Dateien `B2_DNS_Stand_260802.md` und `B2_Anbieterantwort_260803.md` sind überholt.*
