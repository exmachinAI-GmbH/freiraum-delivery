# B3 · Testdomäne — Nachweisablage

**Status:** noch nicht begonnen. Auftrag: `arbeit/Bauauftrag_Pilot-Vorbedingungen.md`, Abschnitt B3.

**O-PIL-4 ist entschieden (Founder, 02.08.2026): Der Betreiber bestimmt** — niemand außer
exmachinAI legt fest, wer FREIRAUM nutzen darf. Beschluss samt Nachprüfung am Datenmodell:
`../../../02_AGENT_HARNESS_KONZEPTE/ITERATION_2/arbeit/Founder_Beschluesse/O-PIL-4_Domaenenschranke.md`
(Gegenzeichnung des Founders steht noch aus.)

**Was daraus für die Bestellung folgt.** Der Wächter `invitation_guard()` prüft die
`invite_domain` des Mandanten, zu dem das **eingeladene Konto** gehört — im Pilot also die
des Kundenmandanten `DE-ZAA`. Die Bestimmungsmacht des Betreibers ergibt sich daraus, dass
er diesen Mandanten anlegt und dessen Schranke setzt; sie bedeutet **nicht**, dass die
Unternehmensdomäne des Betreibers geprüft würde.

Gebraucht wird daher: eine **von uns kontrollierte Domäne oder Sub-Domäne, die die
Hausadresse der erfundenen Bank spielt**, mit einem Postfach, das der Prüfer lesen kann.
Sie wird als `tenant.invite_domain` von `DE-ZAA` gesetzt.

**Bestätigt (Founder, 02.08.2026):** *„Wir als FREIRAUM definieren, an welche Empfänger wir
senden."* Genau das ist der Mechanismus — der Betreiber setzt die `invite_domain` je
Mandant, und der Wächter lässt danach nichts anderes durch.

## Vorschlag: Sub-Domäne statt Zukauf — `zaa.freiraum.top`

`freiraum.top` ist seit dem 07.07.2026 registriert, die Nameserver liegen bei uns
(Bytecamp), ein Postfach ist eingerichtet. Eine Sub-Domäne daraus erfüllt beide
Anforderungen an B3 ohne weiteren Zukauf und ohne Wartezeit: von uns kontrolliert, Postfach
lesbar. **Damit hat B3 seine Vorlaufzeit verloren** — die Bestellung entfällt.

### Warum die Sub-Domäne sauber trennt

Der Wächter vergleicht mit `lower(mail) NOT LIKE '%@' || lower(invite_domain)`. Geprüft am
02.08.2026:

| Adresse | Schranke | Ergebnis |
|---|---|---|
| `anna@freiraum.top` | `freiraum.top` | zulässig |
| `anna@zaa.freiraum.top` | `freiraum.top` | **abgewiesen** |
| `anna@zaa.freiraum.top` | `zaa.freiraum.top` | zulässig |
| `x@evil-freiraum.top` | `freiraum.top` | **abgewiesen** |

Die Schranke greift also exakt: eine Sub-Domäne fällt **nicht** unter die Hauptdomäne, und
eine ähnlich geschriebene Fremddomäne auch nicht. Betreiber-Mandant (`freiraum.top`) und
Kundenmandant `DE-ZAA` (`zaa.freiraum.top`) sind dadurch echt getrennt — der
Negativtest der Abnahme misst damit etwas.

### Was noch zu tun ist

1. MX-Eintrag für `zaa.freiraum.top` setzen und ein lesbares Postfach einrichten
   (heute kein MX vorhanden — geprüft am 02.08.2026).
2. `tenant.invite_domain` von `DE-ZAA` auf `zaa.freiraum.top` setzen — durch das
   Installationsskript oder den Seed, nicht von Hand.
3. Abnahme fahren: Einladung an eine Adresse der Sub-Domäne kommt an · Einladung an eine
   Adresse außerhalb wird mit dem Wortlaut des Datenmodells abgewiesen, **ohne** dass eine
   Zeile in `invitation` entsteht.

Hierher gehören, sobald beschafft wird:

| Datei | Inhalt |
|---|---|
| `B3_Domaenendossier.md` | Gewählte Domäne, Registrar, Laufzeit, Postfach-Konzept (wer liest mit), Verweis auf O-PIL-4-Beschluss |
| `B3_Abnahmeprotokoll.md` | Nachweis: Einladung innerhalb der Domäne kommt an · Einladung außerhalb wird abgewiesen, ohne `invitation`-Zeile |

**Keine Zugangsdaten in diesem Ordner** — Registrar-/Postfach-Zugänge in Key Vault/Passwortmanager,
hier nur Verweise. Die Domäne wird später als `tenant.invite_domain` des Kunden-Mandanten `DE-ZAA` gesetzt.
