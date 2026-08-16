# Fachliche Eigentümer je Konzept — **leeres Formular zur Zeichnung**

> **Diese Datei gehört dem Menschen.** Der Harness hat sie angelegt und die Zahlen
> gemessen. **In die letzten beiden Spalten hat er nichts geschrieben und schreibt
> auch später nichts hinein.** Wer sie überschreibt, löscht eine Entscheidung.

| | |
|---|---|
| **Warum es dieses Blatt gibt** | `K23-M02` verlangt je Registerzeile einen fachlichen Eigentümer. Gemessen am 16.08.2026: **0 von 1231** Zeilen tragen einen |
| **Warum der Harness ihn nicht einträgt** | **Keine der geprüften Quellen benennt einen Menschen.** Der Nachweis steht unten unter *Was gesucht wurde* |
| **Warum 24 Zeilen statt 1231** | Jede Klausel trägt ihr Konzept schon in der Kennung: `K03-M05` gehört zu K03. Wer 24 Namen einträgt, hat 1231 Zeilen zugeordnet |
| **Angelegt am** | 16.08.2026 · auf Weisung zu B-4 |

---

## Was gesucht wurde — und was gefunden

Vier Quellen wurden durchsucht. **Keine nennt eine Person als Eigentümer eines
Konzepts.**

| Quelle | Was drin steht | Ob ein Mensch benannt ist |
|---|---|---|
| `config/konzepte.yaml` | je Konzept: Titel, Umfang, Welle, Abhängigkeiten, **besitzt** (Tabellen), Quellen, Inhalt | **nein** — es gibt kein Feld dafür |
| `config/kanon.yaml`, Abschnitt 4 | *„Jede Tabelle hat genau einen Eigentümer"* — und ordnet 38 Tabellen je einem **Konzept** zu | **nein** — der Eigentümer ist dort ein Dokument, kein Mensch |
| Kopftabellen der 24 Konzepte | Konzept · Version / Status · Datum / Freigabe · Quellen · Seitenlimit · Lint · Tabletop · Besitzt · Baut auf | **nein** — keine der 24 Kopftabellen führt eine Eigentümerzeile |
| Wortlaut der 1231 Klauseln | die Regeln selbst | **nein** |

**Was an Personen überhaupt vorkommt**, und warum es nicht genügt:

- **M. Veil (Founder)** steht in jeder Kopftabelle unter *Datum / Freigabe* als
  Vier-Augen-Prüfer. Das ist die **Freigabe des Konzepttextes**, nicht die Zusage,
  jedes Abnahmekriterium daraus nachzuliefern. Wer das gleichsetzt, macht aus einer
  Unterschrift von damals eine Arbeitszusage von heute.
- **A. Han** trägt drei **offene Punkte** (O-K13-9, O-K15-1, O-K15-2), jeweils
  ausdrücklich gezeichnet. Offene Punkte sind keine Klauseln; die drei lassen sich
  keiner `K##-M##`-Zeile zuordnen.
- **„Konzept-Fabrik-Owner"** steht als Adressat einzelner offener Punkte. Das ist
  eine Rollenbezeichnung ohne Namen.

**Deshalb ist das Feld leer geblieben.** Ein eingetragener Name, den keine Quelle
trägt, sähe aus wie eine Zuordnung und wäre keine.

---

## Das Formular

**Eine Zeile je Konzept. Sie tragen die letzten beiden Spalten ein.**

*Spalte „Klauseln" ist die Zahl der Regeln, die mit diesem Namen zugeordnet wären.
Spalte „kritisch" ist der Vorschlag der Triage vom 14.08.2026. Spalte „sperrt"
sind die kritischen Regeln ohne Prüffall — dort sperrt nach `K23-M04` der fehlende
Test die Freigabe. Spalte „Teilschnitt" sind die Regeln, für die schon heute ein
Kriteriumsvorschlag im Register steht.*

| Konzept | Titel | Besitzt (aus `kanon.yaml`) | Klauseln | kritisch | sperrt | Teilschnitt | **Fachlicher Eigentümer** | **Gez. / Datum** |
|---|---|---|---:|---:|---:|---:|---|---|
| **K00** | Beschluss-Log v2.2 bis v2.9 | — | 24 | 2 | 2 | 0 | ⟨Name⟩ | |
| **K01** | Rahmenkonzept v2.9 | `app` | 81 | 30 | 29 | 0 | ⟨Name⟩ | |
| **K02** | Fundament | `event`, `tenant` | 61 | 34 | 33 | 0 | ⟨Name⟩ | |
| **K03** | Anmeldung | `actor` | 50 | 26 | 21 | **7** | ⟨Name⟩ | |
| **K04** | Eignungs- und Schnell-Check | `app_fit_ok`, `fit_answer`, `fit_check`, `fit_option`, `fit_question` | 49 | 10 | 10 | 0 | ⟨Name⟩ | |
| **K05** | Geführtes Gespräch (Stufen 01 und 02) | — | 56 | 8 | 8 | 0 | ⟨Name⟩ | |
| **K06** | Anforderungskonzepte, Projektvertrag und Fachreview (Stufe 03) | `review_finding`, `review_run` | 63 | 7 | 7 | 0 | ⟨Name⟩ | |
| **K07** | Prototyp und Verfeinern (Stufe 04) | `direct_prototype` | 46 | 15 | 15 | 0 | ⟨Name⟩ | |
| **K08** | Wissen und Quellen im Projekt | `knowledge_module_source`, `knowledge_source`, `knowledge_source_draft`, `knowledge_source_released` | 53 | 17 | 16 | 0 | ⟨Name⟩ | |
| **K09** | Angebot und Freigabe (Stufe 05) | — | 39 | 17 | 17 | 0 | ⟨Name⟩ | |
| **K10** | Übergabe-Paket | `document`, `test_harness` | 61 | 21 | 21 | 0 | ⟨Name⟩ | |
| **K11** | Betriebs-Portal | `app_state_aktuell`, `app_state_history`, `contact`, `lifecycle_state_label` | 54 | 16 | 16 | 0 | ⟨Name⟩ | |
| **K12** | Prototyp-Hosting | — | 26 | 10 | 10 | 0 | ⟨Name⟩ | |
| **K13** | Architektur-Muster | `portal`, `portal_enabled` | 53 | 21 | 20 | **1** | ⟨Name⟩ | |
| **K14** | Sicherheits-Grundlinie | `approval` | 53 | 32 | 29 | 0 | ⟨Name⟩ | |
| **K15** | Datenschutz- und Löschkonzept | `retention_due`, `retention_rule` | 41 | 23 | 23 | 0 | ⟨Name⟩ | |
| **K16** | Bedien-Standard | — | 54 | 5 | 5 | 0 | ⟨Name⟩ | |
| **K17** | Agenten-Betriebs- und Interaktionskonzept | `agent`, `agent_knowledge`, `agent_policy`, `agent_template`, `model_ref` | 79 | 28 | 28 | 0 | ⟨Name⟩ | |
| **K18** | Wissens-Struktur M1 bis M3 | `knowledge_module`, `knowledge_module_aktuell`, `knowledge_module_version`, `module`, `template`, `template_aktuell`, `template_version` | 59 | 13 | 13 | 0 | ⟨Name⟩ | |
| **K19** | Build-Referenz (ASCII) | — | 32 | 7 | 7 | 0 | ⟨Name⟩ | |
| **K20** | Zugänge und Nutzer (EXMA) | `invitation`, `invitation_offen`, `membership`, `platform_admin`, `role`, `role_right` | 46 | 15 | 10 | **6** | ⟨Name⟩ | |
| **K21** | Richtlinien (M4) | `policy`, `policy_aktuell`, `policy_version` | 40 | 12 | 12 | 0 | ⟨Name⟩ | |
| **K23** | Test- und Abnahmekonzept | — | 41 | 19 | 17 | **1** | ⟨Name⟩ | |
| **K25** | Wortschatz und Sperren des Prototyp-Erzeugers | — | 70 | 17 | 17 | 0 | ⟨Name⟩ | |
| | **Summe** | | **1231** | **405** | **386** | **15** | | |

**K22** steht nicht in dieser Liste: Festlegung **F28** nimmt es aus dem Bauauftrag
heraus. **K24** ist nach Beschluss S27 nicht vergeben.

---

## Wenn Sie mit weniger anfangen wollen

**Drei Namen decken alles ab, was heute einen Kriteriumsvorschlag trägt:**
K03 (7), K20 (6), K13 (1), K23 (1) — vier Konzepte, 15 Regeln. Das ist der
kürzeste Weg zu einer Zeile im Register, die vollständig ist.

**Vier Namen decken die größte Sperre:** K02 (33), K01 (29), K14 (29), K17 (28)
tragen zusammen **119 der 386** Regeln, bei denen der fehlende Test nach `K23-M04`
die Freigabe sperrt.

---

## Zeichnung

- [ ] **Die oben eingetragenen Namen gelten als fachliche Eigentümer nach `K23-M02`.**
- [ ] **Abweichend:** ⟨…⟩
- [ ] **Zurückgestellt für:** ⟨Kennungen⟩ — mit Begründung

| Name | Rolle | Datum | Anmerkung |
|---|---|---|---|
| | | | |

*Angelegt am 16.08.2026 vom Coding-Harness. Die Zahlen sind gemessen
(`register.json`, `triage.json`), die Namen sind es nicht — sie fehlen, und der
Harness trägt sie nicht nach. Sobald sie stehen, kommen sie über `pflege.json` in
das Register; ein Werkzeugwechsel ist dafür nicht nötig.*
