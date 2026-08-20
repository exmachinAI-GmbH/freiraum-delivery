# Nachtrag zur Tor-3-Anforderung · `teilschnitt-anmeldung`

**20.08.2026 · Der Harness zieht nach, was seit dem 16.08. nicht mehr stimmt.**

| | |
|---|---|
| **Gilt zu** | `arbeit/Vorlagen/tor3_anforderung_teilschnitt_260816.md` — **das Blatt bleibt im Wortlaut bestehen**, dieser Nachtrag tritt daneben |
| **Anlass** | Entscheidung 6 der Standortbestimmung, gezeichnet am 20.08.2026: *„Tor 3 anfordern bis 21.08.2026, anfordernde Person: A. Han"* |
| **Art** | **Ausfertigung. Sie entscheidet nichts.** Der Harness hat kein Modell aufgerufen und kein Review geschrieben |

---

## 1 · Was zu berichtigen ist — die vier Zeilen zuerst

**⚠ Vier der aufgeführten Belege gibt es unter dem genannten Pfad nicht mehr.** Sie sind am
19.08.2026 umbenannt worden, damit die Negativfälle je Migration auseinanderzuhalten sind:

| im Blatt vom 16.08. | heute |
|---|---|
| `migrations/negativfaelle/N1_frist_ge_mindestfrist.sql` | `…/M30_N1_frist_ge_mindestfrist.sql` |
| `migrations/negativfaelle/N2_mail_fehler_braucht_grund.sql` | `…/M30_N2_mail_fehler_braucht_grund.sql` |
| `migrations/negativfaelle/N3_pseudonym_vor_frist.sql` | `…/M30_N3_pseudonym_vor_frist.sql` |
| `migrations/negativfaelle/N4_tagesfrist_positiv.sql` | `…/M30_N4_tagesfrist_positiv.sql` |

> **Warum das mehr ist als eine Kleinigkeit.** Frage 21 der Anforderung betrifft
> **ausschließlich diese vier Dateien**. Ein Prüfer, der sie unter dem alten Pfad sucht,
> findet nichts — und beantwortet die Frage dann entweder gar nicht oder am falschen
> Testsatz. Genau davor warnt Abschnitt 5.3 des Blattes selbst.

## 2 · Die Felder, die neu zu setzen sind

| Feld im Blatt vom 16.08. | dort | **jetzt** |
|---|---|---|
| Anforderung abschicken bis | Montag, 17.08.2026 | **Freitag, 21.08.2026** *(Entscheidung 6)* |
| Geprüfter Stand | ⟨offen⟩ | `56a8b51f8a02b698aea8cd48192a81e10ba95af6` · Zweig `scheibe/m5-gespraech` |
| Datum der Ausfertigung | 16.08.2026 | **20.08.2026** (dieser Nachtrag) |
| Anfordern | A. Han | **unverändert A. Han** — am 20.08. ausdrücklich gezeichnet |

## 3 · Was sich an der Lage geändert hat — der Prüfer soll es wissen

| | |
|---|---|
| **Weg A ist gezeichnet** | Der Umfang zum 31.08. ist der **Teilschnitt bis zur Anmeldung**; M4 bis M12 sind zurückgestellt. **Deshalb geht diese Anforderung hinaus und nicht die für M5** — es gibt einen Durchgang je Scheibenabnahme, nicht zwei (C-4) |
| **Tor 2 gibt es inzwischen** | Für M5 sind am 20.08. **128 blinde Prüffälle** entstanden. Sie gehören **nicht** zu dieser Anforderung — M5 ist zurückgestellt |
| **Der Gesamtlauf ist gemessen** | Gegen eine frische Datenbank: **144 Einzelfälle bestanden, 0 fehlgeschlagen, 132 gesperrt.** *Tor 1c: kein Fehlschlag* |
| **#41 ist zusammengeführt** | `795bcdd` liegt auf `main`; der geprüfte Stand oben setzt darauf auf |
| **Tor 3 ist weiterhin nie gelaufen** | `nachweise/fremdreview/` enthält README und Vorlage, sonst nichts. Das ist der Grund für die Eile: **die Zykluszeit ist unbekannt** |

## 4 · Die Roh-Evidenz mit Prüfsummen — **Stand 20.08.2026**

Alle Dateien am 20.08.2026 nachgesehen und geprüfsummt. **Vier Pfade sind berichtigt**
(Abschnitt 1); die übrigen stehen wie im Blatt vom 16.08.

| Datei | Zeilen | SHA-256 (erste 16) |
|---|---|---|
| `app/__init__.py` | 16 | `1a1866ab6db02c01` |
| `app/haupt.py` | 532 | `0963e010f103d165` |
| `app/datenbank.py` | 505 | `f08a4325c689eaa9` |
| `app/sitzung.py` | 166 | `a76c1ee59136583e` |
| `app/anmeldung.py` | 234 | `64a78d4a2c15f76a` |
| `app/einladung.py` | 452 | `d1783dbcfa4e9d80` |
| `app/einladung_senden.py` | 806 | `716f25810d3e0823` |
| `app/vorpruefung.py` | 1171 | `44a4f02c6f9cddd7` |
| `mail/versand.py` | 556 | `0a0a4e60ab26aa49` |
| `app/vorlagen/start.html` | 36 | `03db5f194b617a15` |
| `app/vorlagen/en01_anmeldung.html` | 111 | `fa89a564221588ed` |
| `app/vorlagen/en02_uebersicht.html` | 113 | `ad58da399c9dcf0e` |
| `app/vorlagen/en03_vorpruefung.html` | 100 | `265e8095d3b352bc` |
| `app/vorlagen/en04_eignung.html` | 347 | `7da0f6160b8b8cae` |
| `app/vorlagen/einladung.html` | 67 | `bc6744164c7cc7be` |
| `app/vorlagen/einladung_senden.html` | 87 | `8895f711f6d2e457` |
| `migrations/M30__pilot_sammelmigration.sql` | 2409 | `1af077c540f910d3` |
| `migrations/negativfaelle/M30_N1_frist_ge_mindestfrist.sql` **← Pfad berichtigt** | 15 | `1025301e2c1f9bcc` |
| `migrations/negativfaelle/M30_N2_mail_fehler_braucht_grund.sql` **← Pfad berichtigt** | 14 | `9d655b15df82bd07` |
| `migrations/negativfaelle/M30_N3_pseudonym_vor_frist.sql` **← Pfad berichtigt** | 28 | `c2f67614d9f10820` |
| `migrations/negativfaelle/M30_N4_tagesfrist_positiv.sql` **← Pfad berichtigt** | 13 | `e3352b2323b6a9db` |
| `seeds/Seed_Welle1_M1-M4.sql` | 229 | `a22ab0de44c90e3a` |
| `seeds/Seed_Vorpruefung_K04.sql` | 199 | `0ec637b5e9fc96e7` |
| `pruefungen/lauf.sh` | 778 | `cfe0757c752b30ba` |
| `pruefungen/migration/M30__pruefung.sql` | 1794 | `47156570838ac6e9` |
| `pruefungen/klauseln/anmeldung_lauf.sh` | 989 | `49214d00e1e9a2df` |
| `pruefungen/klauseln/anmeldung_daten.sql` | 368 | `b37de5151d761f81` |
| `pruefungen/klauseln/anmeldecode_lauf.sh` | 1239 | `385768329c968a03` |
| `pruefungen/klauseln/anmeldecode_daten.sql` | 351 | `bb08aea64990d9f5` |
| `pruefungen/klauseln/einloesung_lauf.sh` | 633 | `df005f48102f3192` |
| `pruefungen/klauseln/einloesung_daten.sql` | 329 | `f338d1d8d1404a61` |
| `pruefungen/klauseln/versand_lauf.sh` | 556 | `bd1c3b2f141a270b` |
| `pruefungen/klauseln/versand_daten.sql` | 351 | `af9be78dfef39c59` |
| `pruefungen/klauseln/mitgliedschaft_lauf.sh` | 834 | `7e072e2092f04b8c` |
| `pruefungen/klauseln/mitgliedschaft_daten.sql` | 469 | `b0c1f3c8048c3404` |
| `pruefungen/klauseln/vorpruefung_lauf.sh` | 2207 | `9baf62f576b7cc9f` |
| `pruefungen/klauseln/vorpruefung_daten.sql` | 427 | `b46d875974206ee8` |
| `nachweise/manifeste/tor1c_260814.json` | 10 | `4525917f878d8728` |
| `nachweise/manifeste/tor1c_260814_manifest.json` | 197 | `f951159b134e66c6` |
| `nachweise/manifeste/tor1c_260813.json` | 10 | `42d55346809c977d` |
| `nachweise/manifeste/tor1c_260813_manifest.json` | 178 | `5b996dbbd453ee8a` |
| `nachweise/klauselregister/register.md` | 1583 | `fdda41fe285df1b2` |
| `nachweise/klauselregister/triage.md` | 85 | `38cd74cfc9e1633d` |
| `nachweise/herkunft/herkunft.json` | 15877 | `9096c332b4cdd6fc` |
| `nachweise/restrisiken/restrisiken.md` | 350 | `7ccb3a06752dddde` |
| `schema/freiraum_datamodel.sql` | 866 | `cb37d5fe6ef76524` |
| `schema/K19_screens.yaml` | 1056 | `4f186ce15bcf170f` |

**Nicht einzeln geprüfsummt**, weil es Ordner sind und ihr Inhalt sich fortschreibt:
`arbeit/Bauberichte/` und `arbeit/Plaene/`. Sie gehen als Ordner mit, wie im Blatt vom 16.08.

> **Was ausdrücklich NICHT mitgeht:** Bauberichte als *Ersatz* für den Quelltext. Der fremde
> Blick prüft gegen **Roh-Evidenz, nicht gegen Erklärungen des Baus** (`CLAUDE.md`:75).
> Die Ordner gehen als Zusatz mit, nicht an Stelle der Dateien darüber.

## 4a · Die zweite Messung dieses Durchlaufs — **die Zeit, jetzt gemessen**

Abschnitt 8 des Blattes vom 16.08. verlangt zwei Zeitpunkte und lässt sie bewusst leer:

> *„Deshalb steht im Kopf dieses Blattes keine Frist für die Rückgabe des Urteils. Sie zu
> setzen hieße zu behaupten, wie lange der Weg dauert — und genau das ist unbekannt.
> **Nach diesem Durchlauf ist es gemessen**, und dann trägt jede spätere Terminaussage zu
> Tor 3."*

**Er ist gelaufen. Hier sind die Zahlen.**

| | |
|---|---|
| **Anforderung abgeschickt am** | **20.08.2026, 14:58 Uhr** — A. Han, an eine frische Instanz von GPT 5.6 Sol *(Angabe des Absenders; die Belegbündel entstanden um 14:42, davor kann es nicht gewesen sein)* |
| **Urteil abgelegt und Formprüfung bestanden am** | **20.08.2026, 16:19 Uhr** — Zeitstempel von Blatt und Prüfsummendatei; die Formprüfung lief um 16:21 ohne Beanstandung |
| **Dauer des Zyklus** | **1 Stunde 21 Minuten** |

### Was diese Zahl trägt — und was nicht

**Sie trägt:** Ein Tor-3-Durchlauf passt in einen Nachmittag. Die Sorge, der Weg könnte
Tage brauchen und deshalb vor dem 31.08. nicht mehr gehen, ist damit **entkräftet** — sie
war berechtigt, solange niemand es gemessen hatte, und ist es jetzt nicht mehr.

**Sie trägt nicht** als reine Rechenzeit des fremden Modells. In den 81 Minuten stecken:
das Wählen des Modells, eine Vorabfrage zur Vollständigkeit der Anhänge, das Nachreichen
von `B_Messungen.txt` mit einer zweiten Antwort, eine Rückfrage nach dem Schlusswort, ein
abgebrochener Kopiervorgang, und das Ausfüllen und Zeichnen des Blattes.

**Und sie trägt nur mit einem Menschen darin.** Kein Schritt lief unbeaufsichtigt; das ist
keine Reibung, sondern die Bedingung (C-4).

> **Für die nächste Terminaussage zu Tor 3 gilt damit: ein Arbeitstag ist reichlich, ein
> halber genügt — sofern ein Mensch in dieser Zeit ansprechbar ist.** Beim zweiten Mal
> dürfte es kürzer werden; die Belegbündel und der Auftragstext liegen jetzt fertig.

---

## 5 · Was am Blatt vom 16.08. unverändert gilt

Alles Übrige: der Vorbehalt in Abschnitt 0, der Prüfgegenstand in Abschnitt 2, die
Ausschlüsse in Abschnitt 3, die Fragen in Abschnitt 6, das Ablegen in Abschnitt 7 und die
vier Abweichungen im Anhang. **Insbesondere Abweichung 4:** den Namen der Abnahmeeinheit
`teilschnitt-anmeldung` **abschreiben, nicht tippen** — er wird gegen keine Liste gehalten.

---

## Zeichnung

- `☐` **Der Nachtrag ist übernommen; die Anforderung geht mit diesen Werten hinaus**
- `☐` **Abweichend:** ⟨was, und warum⟩

| Name | Rolle | Datum |
|---|---|---|
| **A. Han** | fordert an, legt ab, zeichnet den Kopf | ⟨ ⟩ |
| **M. Veil** | vierte Messstufe, nach der Ablage | ⟨ ⟩ |

---

*Ausgefertigt am 20.08.2026 vom Orchestrator, auf Grundlage der am 20.08.2026 gezeichneten
Entscheidung 6. Das Blatt vom 16.08. wird nicht überschrieben — eine ausgefertigte Fassung
bleibt stehen, die Berichtigung tritt daneben. **Der Harness hat kein Modell aufgerufen.**
