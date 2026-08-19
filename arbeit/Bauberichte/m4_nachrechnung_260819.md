# M4 · Die Nachrechnung nach §6a — **gefahren am 19.08.2026**

**Der Lauf ist gefahren, nicht behauptet.** Was hier steht, ist die Ausgabe; die Feststellung
*„M4 ist eingetreten"* steht **nicht** darin — die zeichnet ein Mensch (K23-G01, K23-D06).

## Was §6a verlangt

> **M4** · *„Eine Anwendung entsteht nur über den einen Weg. Nach GEEIGNET und Zweckbestimmung
> legt `create_app_after_fit` die Zeile an; ein direkter `INSERT` wird abgewiesen."*
> **Nachrechenbar an:** *„MT-95 bis MT-98 gegen den Zielbestand; EN-04a bedienbar; bei Treffer
> in Frage 1 liegt die Kenntnisnahme vor."*

Quelle: `arbeit/Quellen/BAUAUFTRAG_v1.1_paragraph6_und_6a.md` — seit dem 19.08. im Repo, wortgleich.

## Die Umgebung

| | |
|---|---|
| Datenbank | `freiraum_ci`, **frisch gebaut** aus `schema/freiraum_datamodel.sql` + `migrations/*.sql` (`./aufbau.sh --ci`), Port 55433 |
| Stand | Zweig `m5-vorbereitung`, Commit dieses Berichts |
| **Was sie nicht ist** | **die Zielumgebung.** `aufbau.sh` sagt es selbst: *„Das hier ist eine PRÜFumgebung, kein Pilotlauf."* Der Lauf gegen `psql-freiraum-pilot…` steht aus und braucht `frxfw` |

---

## 1 · MT-95 bis MT-98 — **alle bestanden**

Aus `pruefungen/migration/M30__pruefung.sql`, Ausgabe im Wortlaut:

```
MT-95  · BESTANDEN — create_app_after_fit legt die Anwendung an, Nummer vergeben
         Zeile: 496a0e63-… · Nummer: DE-DMB_002_01 (Kunden-Code DE-DMB, K01-M35)
MT-95b · BESTANDEN — Der Portalpfad DARF den Serverbefehl aufrufen (L1)
         unter fr_portal angelegt: 336a0abc-… · Zeilen zu dieser Kennung: 1
MT-96  · BESTANDEN — Der Portalpfad darf app nicht direkt beschreiben (O-K01-20)
         Meldung: permission denied for table app
MT-97  · BESTANDEN — Der Portalpfad darf actor.sealed nicht aendern (T1)
         Meldung: permission denied for table actor
MT-98  · BESTANDEN — Ein Konto fremden Mandanten legt nichts an (K01-M27)
         Meldung: ANLAGE: das Konto gehoert Mandant …0001, angelegt wird fuer …0002

SUMME: 111 von 111 bestanden, 0 gescheitert
```

**Die beiden Negativfälle scheitern an ihrer eigenen Bedingung** und nennen die Meldung im
Wortlaut — genau das verlangt Bauauftrag §9 Tor I Nr. 6.

## 2 · Der Gesamtlauf

`pruefungen/lauf.sh` gegen dieselbe Datenbank:

```
Pruefpunkte:   bestanden: 13 · fehlgeschlagen: 0 · gesperrt: 4
Einzelfaelle:  bestanden: 131 · fehlgeschlagen: 0 · gesperrt: 17
Tor 1c: kein Fehlschlag.
```

**Kein einziger Fehlschlag.** Die acht Negativfälle der Migrationen scheitern je an ihrer
eigenen Bedingung. Was gesperrt ist, ist nach `K23-M22` **nicht bestanden** — und steht unten.

## 3 · „EN-04a bedienbar" — **nur zur Hälfte belegt**

Der Klausellauf `zweckbestimmung` meldet **14 von 27 bestanden, 13 gesperrt, 0 gescheitert.**
Die 13 haben **eine** gemeinsame Ursache, im Wortlaut des Laufs:

> *„Die Fahrt FREIER WEG (beide Fragen verneint) kam nicht bis zur Auswertung — die Antwort auf
> den Weiterweg `/zweckbestimmung/anlegen` (303, Weiterleitung `/zweckbestimmung`) führt auf eine
> Seite OHNE JEDES ZIEL: dort steht weder ein `<form action=…>` noch ein `<a href=…>`. **Die
> Fahrt mit Treffer in Frage 1 kam durch.**"*

**Was daraus folgt und was nicht.**

- **Belegt ist** der dritte Teil der Nachrechnung: *„bei Treffer in Frage 1 liegt die
  Kenntnisnahme vor"* — diese Fahrt kam durch.
- **Nicht belegt ist** der freie Weg bis zur Anlage über den Bildschirm.
- **Die Ursache ist benannt, nicht geklärt.** Die Vorlage `en04a_zweckbestimmung.html` führt im
  Block nach der Anlage sehr wohl ein Ziel (`<a href="/uebersicht">`, Zeile 116). Dass der Lauf
  keines findet, spricht dafür, dass er auf einer **zweiten** Umleitung landet — nach der Anlage
  gibt es keinen offenen Eignungs-Check mehr, und `_vorbedingung` leitet weiter. **Gemessen ist
  das nicht.**
- **Der Bau darf es nicht selbst nachmessen, indem er den Prüffall ändert.** `pruefungen/` ist
  für den Bau-Agenten gesperrt — auch „nur der Tippfehler". Der Befund gehört dem Prüf-Agenten
  vorgelegt.

## 4 · Was sonst gesperrt blieb

| | Warum |
|---|---|
| **AC-16** | Echte Zustellung nicht ausgeführt — der Lauf braucht SMTP-Zugänge aus dem Schlüsselbund. Teilaussage 1 der M2-Nachrechnung ruht weiter auf dem Einzellauf vom 19.08. |
| **EN-04a-A / EN-04a-B** | *„Die Build-Referenz führt für EN-04a keinen Kasten"* — nach `K19-G01` fail-closed. **Kein Baufehler**, aber EN-04a ist damit an seiner Anordnung nicht messbar |
| **MG-08** | Der Ablauf einer Einladung ist über keine bekannte Tür prüfbar |

---

## 5 · Das Ergebnis in einem Satz

**Die Serverseite von M4 ist nachgerechnet und hält** — MT-95 bis MT-98 bestanden, 111 von 111,
kein Fehlschlag im ganzen Lauf. **Die Bildschirmseite ist es nicht vollständig:** der freie Weg
kommt im Lauf nicht bis zur Auswertung, und EN-04a hat keinen K19-Kasten.

**Damit ist M4 nicht abschließend nachgerechnet — und die Feststellung nicht vorzulegen.** Zwei
Dinge fehlen, beide klein und beide nicht vom Bau allein zu erledigen:

1. **Der K19-Kasten für EN-04a** — er entsteht in der Konzept-Fabrik (`arbeit/an_konzeptfabrik/03_EN-04a_kasten.md` liegt fertig vor, seit dem 19.08. vorgelegt).
2. **Die Klärung des freien Wegs** — als Befund an den Prüf-Agenten, der seine Fahrt der zweiten
   Umleitung folgen lässt oder den Bau widerlegt.

**Und der Lauf gegen die Zielumgebung steht aus.** §6a sagt *„gegen den Zielbestand"*; gefahren
ist er gegen die Prüfumgebung.

---

*Gefahren am 19.08.2026 auf Weisung „Fahre den Lauf". Datenbank frisch gebaut, Ausgabe
unverändert übernommen. Der Bericht stellt nichts fest, was der Lauf nicht gemessen hat.*
