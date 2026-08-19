# Scheibe 4 · M5 — Nachtrag zu Entscheidung 2: Wo liegt die Protokolldatei?

**19.08.2026 · Vorlage zur Zeichnung · noch nicht gezeichnet**

Das Papier zu Blatt 100, Entscheidung 2 schloss mit einem offenen Punkt:

> *„Wo liegt die Protokolldatei? K05-M27 verlangt ‚nicht erratbare Schlüssel' und Zugriff ‚nur
> über kurzlebige, serverseitig autorisierte Zugriffe'. `document.content_ref` ist ein Verweis —
> die Ablage dahinter ist nicht bestimmt. Zu entscheiden bleiben **Ablageort, Schlüsselvergabe,
> Zugriffsdauer und Aufbewahrung**."*

**Drei der vier Punkte sind kleiner, als sie dort stehen — einer ist bereits entschieden.**
Nachgemessen am 19.08.2026 gegen die gezeichneten Klauseln und gegen M30.

---

## 1 · Die Aufbewahrung ist entschieden — von Rang 1, nicht von diesem Blatt

`M30__pilot_sammelmigration.sql:1042–1047`, Sicht `retention_due`:

```sql
SELECT 'document', d.id::text,
       CASE WHEN d.kind IN ('ORDER','SBOM') THEN 'HANDELSRECHT'::retention_class
            ELSE 'KI_NACHWEIS'::retention_class END,
```

Ein Dokument der Art `INTERVIEW_PROTOCOL` ist weder `ORDER` noch `SBOM`. **Es fällt damit unter
`KI_NACHWEIS`** — nicht durch eine Wahl des Bauenden, sondern durch die Sammelmigration, die in
der Rangfolge auf **Rang 1** steht (`CLAUDE.md` Abschn. 1). Die Frist führt K15, nicht K05
(K10-G09: *„K10 nennt die Aufbewahrungsklasse, nie eine Frist"*).

**Für M5 heißt das: keine Entscheidung nötig, und keine Spalte zu setzen.** Die Klasse wird
nicht am Dokument gespeichert, sie wird in der Sicht abgeleitet. Wer sie beim Bau setzen
wollte, träfe eine Festlegung, die schon getroffen ist.

> **Der Nachtrag korrigiert das eigene Papier.** Entscheidung 2 zählte die Aufbewahrung unter
> die offenen Punkte, ohne `retention_due` gelesen zu haben. Das ist derselbe Fehler wie zweimal
> zuvor an diesem Tag: **beurteilt, statt nachgesehen.**

---

## 2 · Was die gezeichneten Klauseln über die Ablage schon sagen

| Klausel | Wortlaut, verkürzt | was daraus folgt |
|---|---|---|
| **K05-M25** | Der Gesprächsstand ist ein *„unveränderlicher, strukturierter **Dateistand**"*; `document` registriert **die Datei**; *„K05 besitzt weiterhin keine Tabelle"* | Der Inhalt ist eine **Datei**, keine Tabellenzeile |
| **K05-M26** | *„erzeugt zuerst **die Datei**, dann die `document`-Zeile und zuletzt ein append-only `event`"* | Die Datei entsteht **vor** der Zeile. Eine Ablage, die das nicht kann, bricht die Reihenfolge |
| **K05-M27** | *„Dateiobjekte verwenden **nicht erratbare Schlüssel** und sind nur über **kurzlebige, serverseitig autorisierte Zugriffe** erreichbar"* · Mandant ausschließlich über `document.app_id → app.tenant_id` | Kein Zugriff ohne Serverpfad; kein Schlüssel, der sich hochzählen lässt |
| **K10-M03** | *„Jede Zeile MUSS einen Dateinamen tragen. Ein Eintrag ohne Datei ist kein Dokument, sondern ein Fehler"* | Dateiname ist Pflichtfeld, **nicht** der Ablageschlüssel |
| **K10-M30** | *„K13 MUSS vor Produktivbetrieb Region `swedencentral`, verwaltete Identität, **private Ablage**, Least Privilege, Verschlüsselung … belegen. K10 erfindet dafür keinen zweiten Cloud- oder Betriebsowner"* | Der Betriebsrahmen ist gesetzt und gehört **K13**, nicht K05 und nicht diesem Blatt |

**Gemessen, was das Schema dafür heute mitbringt** (`M30:492–505`):

| Spalte an `document` | Zweck |
|---|---|
| `content_ref` | der Verweis auf das Objekt — **opak, kein Pfad mit Bedeutung** |
| `content_sha256` | der Hash, mit Formatprüfung `document_sha_fmt` |
| `content_media_type` | Medienart |
| `content_size_bytes` | Größe |

**Und was der Code heute mitbringt: nichts.** `grep -rniE "blob|objektspeicher|storage|azure" app/`
findet **keinen Treffer**. Es gibt keinen Ablage-Anschluss, an dem sich M5 anhängen könnte.

---

## 3 · Was offen bleibt — drei Punkte statt vier

| | offen | wer entscheidet |
|---|---|---|
| **A** | **Der Träger** der Datei: privater Objektspeicher, Datenbank oder Dateisystem | Founders · Betriebsrahmen K13 |
| **B** | **Die Schlüsselvergabe**: woraus entsteht der nicht erratbare Schlüssel | Bauentscheidung, sobald A steht |
| **C** | **Die Zugriffsdauer** des kurzlebigen Zugriffs — K05-M27 nennt *kurzlebig*, keine Zahl | **fachlicher Eigentümer.** Eine Zahl zu erfinden wäre genau der Mangel, an dem die Gegenprobe vom 16.08. 26 Vorschläge kippte |

---

## 4 · Drei Träger, gemessen an den Klauseln

### Variante 1 · Privater Objektspeicher (Azure Blob, `swedencentral`)

| | |
|---|---|
| **trägt** | K10-M30 wörtlich (private Ablage, verwaltete Identität, Region); K05-M26 (Datei zuerst); K05-M27 (Objektschlüssel als GUID, Zugriff nur über kurzlebig signierten, serverseitig ausgestellten Verweis) |
| **kostet** | einen zweiten Zustandsraum: Objekt vorhanden / verwaist / gesperrt. Ein Teilfehler zwischen Objekt und Zeile ist möglich und muss kompensiert werden |
| **Vorbild im Haus** | **K18-M28/M30/M32** beschreiben genau dieses Muster für die Formatvorlagen — unveränderliches Objekt, Hashvergleich bei jedem Lesepfad, Orphans in Quarantäne. **Es ist Vorbild, nicht Rechtsgrund:** K18 gehört die Wissensstruktur M1–M3, nicht der Gesprächsstand. Wer K18-M28 für K05 zitiert, zitiert eine fremde Zuständigkeit |

### Variante 2 · Die Datenbank trägt den Inhalt

| | |
|---|---|
| **trägt** | Mandantenschnitt und Dreischritt in **einer** Transaktion — K02-D04 (*kein Schreibvorgang ohne Protokolleintrag*) und K13-M20 (*atomar*) sind damit trivial erfüllt; kein verwaistes Objekt, kein zweiter Zustandsraum; „nicht erratbar" ist ein `uuid`-Primärschlüssel, „kurzlebig" ist die Transaktion |
| **bricht** | **K05-M25 und K05-M26 im Wortlaut.** *„Dateistand"* und *„erzeugt **zuerst die Datei**"* beschreiben eine Datei. Eine Zeile ist keine Datei. Und **K05-M25 sagt zugleich: „K05 besitzt weiterhin keine Tabelle"** — der Inhalt in eine Tabelle zu legen, wäre die Tabelle, die K05 nicht haben darf, unter anderem Namen |
| **Folge** | Diese Variante ist **nicht ohne Klauseländerung baubar**. Sie steht hier nur, damit die Entscheidung sie kennt |

### Variante 3 · Dateisystem des Anwendungscontainers

| | |
|---|---|
| **trägt** | den Wortlaut *„Datei"*; am schnellsten gebaut |
| **bricht** | K10-M30 (*private Ablage* als belegter Betriebsnachweis), und der Stand überlebt keinen Containerneustart. **Damit bricht er den Meilenstein selbst:** M5 ist nachrechenbar an *abbrechen, neu anmelden, weitermachen* |
| **Folge** | Für den Pilotbetrieb untauglich. Als **Prüfstandsattrappe** im Klausellauf denkbar — dort läuft ohnehin kein Objektspeicher |

---

## 5 · Empfehlung

**Variante 1 für den Pilot, Variante 3 ausschließlich im Prüfstand — und die Trennung wird
sichtbar gebaut.**

Der Serverbefehl kennt nur eine Ablageschnittstelle mit vier Verrichtungen
(*schreiben · lesen · Hash prüfen · sperren*); welcher Träger dahinter steht, entscheidet die
Umgebung, nie der Fachcode. Das ist keine Bequemlichkeit: Ein Klausellauf, der einen
Objektspeicher braucht, läuft in der CI **nicht** — und ein Tor, das nicht messen kann, meldet
nach K23-M22 **gesperrt**, nicht bestanden. Ohne die Trennung wären die Prüffälle zu M5 von
Anfang an gesperrt.

**Was ausdrücklich nicht empfohlen, sondern gefragt wird:** die Zahl hinter *kurzlebig*
(Punkt C). Sie steht in keiner Klausel. Der Harness trägt sie nicht ein.

---

## 6 · Was dieses Blatt nicht tut

Es baut nichts, und es ändert keine Klausel. Variante 2 ist **nicht** als Klauseländerung
vorgeschlagen — sie ist benannt, weil eine Entscheidung, die die verworfene Möglichkeit nicht
kennt, keine Entscheidung ist. Ein Vorschlag zur Änderung von K05 gehörte in die
Konzept-Fabrik, und dorthin schreibt der Harness nicht (`CLAUDE.md` Abschn. 6).

---

## Zeichnung

| | Entscheidung | |
|---|---|---|
| **A** | **Träger der Protokolldatei.** Privater Objektspeicher in `swedencentral` mit verwalteter Identität; im Prüfstand eine Attrappe hinter derselben Schnittstelle *(Empfehlung)* | ☐ so · ☐ Datenbank (verlangt Klauseländerung an K05-M25/M26) · ☐ anders: |
| **B** | **Schlüsselvergabe.** Der Ablageschlüssel ist ein serverseitig erzeugter Zufallswert ohne fachliche Bedeutung; Dateiname und Thema sind **nicht** der Schlüssel (Vorbild K07-M25) *(Empfehlung)* | ☐ so · ☐ anders: |
| **C** | **Zugriffsdauer.** Wie lange gilt ein serverseitig ausgestellter Zugriff auf ein Dateiobjekt? K05-M27 sagt *kurzlebig* und nennt keine Zahl | ☐ ⟨Minuten: ⟩ · ☐ Frage geht an K13 als Betriebsfestlegung |

| Name | Rolle | Datum | Bemerkung |
|---|---|---|---|
| A. Han | für den Auftragnehmer |  |  |
| M. Veil | für den Auftraggeber |  |  |

---

*Gemessen am 19.08.2026 gegen `nachweise/klauselregister/register.json` (Wortlaute K05, K10,
K18, K07, K15), gegen `migrations/M30__pilot_sammelmigration.sql` (Spalten `document.content_*`
Zeile 492–505, Sicht `retention_due` Zeile 1027–1060, `retention_rule` Zeile 125–145) und gegen
`app/` per `grep`. Die Konzept-Fabrik wurde nicht angefasst; die Klauselwortlaute stammen aus
dem im Repo mitgeführten Register.*
