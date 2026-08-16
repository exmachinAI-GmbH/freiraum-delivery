# Bauaufgabe **L9** · Der Portal-Hinweis nach Artikel 4 — gebaut am 16.08.2026

| | |
|---|---|
| **Grundlage** | Bauauftrag §7a, L9, Teil *„Hinweis im Endnutzer-Portal"* · Freigabe **E-4**, gez. M. Veil und A. Han, 16.08.2026 |
| **Anlass** | Entscheidung vom 16.08.2026: *„L9 bleibt im Umfang des 31.08. — wer sich anmeldet, nutzt das Portal."* |
| **Gebaut** | `app/ki_hinweis.py` (neu) · `app/vorlagen/en01_anmeldung.html` · `app/haupt.py` |
| **Zustand** | ⛔ **NICHT ERFÜLLT** — Kriterium 3 ist am 16.08.2026 zurückgenommen worden. *Berichtigt, siehe Kopfvermerk* |

> ### ⛔ Berichtigung vom 16.08.2026, spät abends — L9 ist nicht erfüllt
>
> **Dieses Blatt beschrieb Kriterium 3 als *bestanden*. Das gilt nicht mehr.**
>
> Der Riegel, der die Kenntnisnahme erzwang, hat im blinden Prüflauf **vier Fäden rot
> gefärbt** — `anmeldung` fiel von 30 auf 8 von 30. Kein einziger Prüffall kennt das Feld
> `ki_bestaetigt`; der Riegel hatte den **Anmeldevertrag** geändert, auf dem alles andere
> aufsetzt. **Er ist zurückgenommen, zusammen mit dem Kästchen in der Maske.**
>
> | | Stand seit dem 16.08.2026 abends |
> |---|---|
> | Kriterium 1 · Hinweis vor der ersten Nutzung, nicht in der Fußzeile | **erfüllt** — der Kasten steht unverändert über dem Formular |
> | Kriterium 2 · die drei geforderten Angaben | **erfüllt** |
> | Kriterium 3 · nachweisbare Kenntnisnahme | ⛔ **nicht erfüllt** — nicht erzwungen |
>
> **Die Messungen in Abschnitt 3 bleiben gültig** — sie zeigen, dass die Bauart trägt: einmal
> je Person, append-only, unentfernbar. **Was fehlt, ist der Auslöser.** Der Code dafür steht
> unverändert in `app/ki_hinweis.py` und wartet auf die Entscheidung **E-13**.
>
> **Warum kein Kästchen ohne Riegel stehen blieb:** `K03-M13` — *„eine Prüfung allein in der
> Oberfläche gilt als nicht erfolgt."* Ein Kästchen, das nichts sperrt, täuscht eine
> Kenntnisnahme vor, die niemand nachweist.

---

## 1 · Die drei Abnahmekriterien und wie sie gebaut sind

**Wörtlich aus §7a, L9 — nichts davon ist abgeleitet:**

| | Kriterium | Wie gebaut |
|---|---|---|
| **1** | Der Hinweis erscheint **vor der ersten Nutzung**, nicht in einer Fußzeile | `<section class="ki">` **über** dem Formular in EN-01, mit eigenem Rahmen, in Fließtextgröße |
| **2** | Er nennt: dass KI eingesetzt wird · dass der Kunde als Betreiber eigene Pflichten nach Artikel 4 hat · wo er Näheres findet | drei benannte Konstanten `HINWEIS_EINSATZ`, `HINWEIS_PFLICHT`, `HINWEIS_QUELLE` |
| **3** | Die Kenntnisnahme ist **nachweisbar** — *„dieselbe Bauart wie bei der Zweckbestimmung (K04-M21)"* | Ereignis nach dem gezeichneten Behelf **K04-G12**, Klasse `KI_NACHWEIS`, append-only |

### Warum drei Konstanten statt eines Textblocks

**Damit ein Prüffall die drei Angaben einzeln treffen kann.** Ein einziger Block wäre nur
als Ganzes prüfbar — dann misst der Prüffall *„irgendein Text ist da"*, nicht *„die drei
geforderten Angaben stehen da"*. Das ist derselbe Fehler, den `MT-17` einmal gemacht hat: den
Ist-Stand messen statt die Klausel.

### Warum bei „wo er Näheres findet" keine Netzadresse steht

**Weil das Repository keine führt.** `K10-M34` bestimmt den Ort statt dessen:

> *„Das Paket MUSS die Angaben führen, die der Kunde braucht, um seine eigenen Pflichten aus
> der KI-Verordnung zu beurteilen."*

Der Hinweis verweist deshalb auf das **Übergabe-Paket** und die **Ansprechperson**. **Eine
erfundene Adresse wäre schlimmer als keine** — sie sieht aus wie eine Auskunft.

---

## 2 · Die Reihenfolge im Server — sie ist die halbe Umsetzung von Kriterium 1

Die Prüfung des Kästchens steht **vor** dem Anmeldeversuch. Drei Gründe, und der zweite ist
der, den man übersieht:

| | |
|---|---|
| **1** | *„Vor der ersten Nutzung"* heißt **vor** der Anmeldung. Umgekehrt entstünde die Sitzung zuerst, und der Hinweis käme, wenn die Nutzung schon begonnen hat |
| **2** | **Ein fehlendes Häkchen darf keinen Versuch verbrauchen.** Nach fünf Fehlversuchen sperrt `login_attempt_guard` das Konto für 15 Minuten (Nr. 35). Wer sein Häkchen vergisst, hat nichts falsch gemacht — ihn dafür in die Drosselung laufen zu lassen wäre eine Strafe ohne Anlass |
| **3** | Die Prüfung berührt die Datenbank **nicht** und verrät deshalb nichts. Die eine Kontoauskunft bleibt `MELDUNG_MISSERFOLG` (K03-M16) |

**Kein `required` im Markup.** `K03-M13`: *„eine Prüfung allein in der Oberfläche gilt als
nicht erfolgt."* Fängt der Browser das leere Kästchen selbst ab, verhindert er nicht den
Fehler — er verhindert die **Messung**, ob der Server ihn abfängt. Dieselbe Überlegung steht
schon an den Feldern darunter.

---

## 3 · Kriterium 3 gemessen — gegen das echte Schema, nicht behauptet

**Gefahren am 16.08.2026 gegen `freiraum_ci` (Port 55433), in einer zurückgerollten
Transaktion:**

```
$ psql … <<'SQL'
  INSERT INTO event (…, action, …, retention_class)
   SELECT …, 'KI_HINWEIS_ART4_KENNTNIS', …, 'KI_NACHWEIS'
    WHERE NOT EXISTS (SELECT 1 FROM event WHERE actor_id=… AND action='KI_HINWEIS_ART4_KENNTNIS');
SQL

 ERSTER AUFRUF: Zeile angelegt        INSERT 0 1
 ZWEITER AUFRUF                       INSERT 0 0     ← keine zweite Zeile
 zeilen_gesamt | klasse
             1 | KI_NACHWEIS

 DELETE FROM event WHERE action='KI_HINWEIS_ART4_KENNTNIS';
 ERROR:  APPEND-ONLY: event erlaubt weder UPDATE noch DELETE

 UPDATE event SET value='manipuliert' WHERE action='KI_HINWEIS_ART4_KENNTNIS';
 ERROR:  APPEND-ONLY: event erlaubt weder UPDATE noch DELETE
```

**Vier Aussagen, alle vier gemessen:**

| | Aussage | Beleg |
|---|---|---|
| 1 | Die Kenntnisnahme entsteht | `INSERT 0 1` |
| 2 | **Nur einmal je Person** — *„vor der ERSTEN Nutzung"* | zweiter Aufruf: `INSERT 0 0` |
| 3 | Sie trägt die Klasse **`KI_NACHWEIS`** | `klasse = KI_NACHWEIS` |
| 4 | Sie ist **unentfernbar und unveränderbar** | `DELETE` und `UPDATE` beide abgewiesen |

**Punkt 4 ist der Kern von *nachweisbar*.** Ein Nachweis, den der Betreiber später
stillschweigend löschen kann, ist keiner. Der Trigger `event_append_only` weist beides ab —
und er weist es auch dem Eigentümer der Datenbank ab.

> **Warum Klasse `KI_NACHWEIS` und nicht `EREIGNIS`.** Dieselbe Begründung wie bei der
> Zweckbestimmung: **Das hier *ist* der KI-Nachweis**, nicht ein Betriebsvorgang daneben.
> `K10-M34` lässt ihn ins Übergabe-Paket eingehen, und ein Nachweis mit zwei
> Aufbewahrungsfristen hätte eine zu viel.

---

## 4 · Was gemessen ist — und was nicht

| | Kriterium | Zustand nach `K23-M22` | Beleg |
|---|---|---|---|
| **1** | Hinweis vor der ersten Nutzung, nicht in einer Fußzeile | **bestanden** | Vorlage gerendert: `ki-titel` steht vor `<form>`; kein `<footer>` in der Datei |
| **2** | Die drei geforderten Angaben | **bestanden** | alle drei Konstanten im gerenderten HTML gefunden |
| **3** | Kenntnisnahme nachweisbar | **bestanden** | Abschnitt 3, vier Messungen |
| **—** | **Dass der Server das Häkchen erzwingt** | ⛔ **gesperrt** | *siehe unten* |

### ⛔ Was fehlt: der blinde Prüffall

**Der Bau hat sich hier selbst gemessen, und das genügt nach `K23` nicht.** Die Messungen
oben sind Bau-Messungen: Sie zeigen, dass das Gebaute tut, was der Bau wollte. Sie zeigen
**nicht**, dass es tut, was die Klausel verlangt.

**Was der blinde Prüf-Agent zu schreiben hat** — je Kriterium mindestens ein Positiv- und ein
Negativfall:

| | Zu messen | Erwartete Bedingung des Negativfalls |
|---|---|---|
| 1 | `POST /anmeldung` **ohne** `ki_bestaetigt` erzeugt **keine** Sitzung und **keinen** Keks | die eigene Meldung, **nicht** `MELDUNG_MISSERFOLG` |
| 2 | Derselbe Aufruf **verbraucht keinen** Anmeldeversuch — `login_attempt` wächst nicht | *(der Punkt, an dem ein zu spät gesetzter Riegel auffiele)* |
| 3 | `GET /anmeldung` zeigt alle drei Angaben **vor** dem ersten Eingabefeld | Position im Dokument, nicht bloße Anwesenheit |
| 4 | Nach erfolgreicher Anmeldung besteht **genau eine** Zeile mit `KI_HINWEIS_ART4_KENNTNIS` | und nach der zweiten Anmeldung **immer noch genau eine** |

> **Diesen Prüffall schreibt der Harness nicht.** Wer baut und zugleich prüft, schreibt den
> Prüffall auf den Code statt auf die Klausel — `K23-D05`. Der Prüf-Agent bekommt dafür den
> Wortlaut der drei Kriterien aus §7a und `K04-M21`; **Umsetzungscode sieht er nicht.**

**Bis dieser Prüffall läuft, ist L9 nach `K23-M22` nicht *bestanden*, sondern
teilgemessen** — und darf in keinem Bericht als erledigt erscheinen.

---

## 5 · Zwei Fragen, die der Harness nicht entschieden hat

| | Frage | Warum offen |
|---|---|---|
| **1** | **Genügt der Wortlaut rechtlich?** | §7a verlangt für L9 — anders als für **L8** (*„A. Han mit rechtlicher Beratung"*) — **keine** rechtliche Beratung. Wo der Auftrag den Unterschied macht, ebnet der Harness ihn nicht ein. **A. Han nimmt ab** |
| **2** | **Einmal je Person oder bei jeder Anmeldung?** | §7a sagt *„vor der ersten Nutzung"*. Gebaut ist die **vorsichtigere** Lesart: Das Kästchen wird **bei jeder** Anmeldung verlangt, der **Nachweis** entsteht nur beim ersten Mal. **Grund:** Wer nur beim ersten Mal fragen wollte, müsste vor der Anmeldung wissen, wer da kommt — und das hieße, die Adresse gegen die Datenbank zu prüfen, bevor der Code stimmt. Das verrät, ob es ein Konto gibt |

> **Zu Frage 2, offen gesagt:** Ein Kästchen bei jeder Anmeldung erzeugt Klickmüdigkeit, und
> Klickmüdigkeit ist das Gegenteil einer Kenntnisnahme. Der Bau mildert das (ein gesetztes
> Häkchen überlebt eine Fehlermeldung), beseitigt es aber nicht. **Wenn eine andere Lesart
> gewollt ist, ist hier der Ort** — sie kostet eine Kontoauskunft vor der Anmeldung, und die
> wollte K03 ausdrücklich nicht.

---

*Angelegt am 16.08.2026 vom Coding-Harness auf Weisung E-4. Alle Zahlen und Zustände an
diesem Tag gemessen; die Befehle stehen daneben. **L9 ist gebaut, nicht abgenommen** — die
Abnahme zeichnet A. Han als Schuldner nach §7a, und der blinde Prüffall fehlt.*
