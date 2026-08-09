# Rollen der Bauseite

*Stand 09.08.2026. **Hier stehen Rollen, keine Personen.** Namen, dienstliche Adressen und
Postfachadressen stehen in `03_AGENT_HARNESS_CODING/30_DELIVERY_HARNESS/Zugaenge_und_Rollen_260807.md`
(Dropbox) — dieses Blatt liegt dort **einmal**, weil es personenbezogene Daten führt.*

---

## Warum getrennt

**Git vergisst nicht.** Am 07.08.2026 ist aus einem Beschlussblatt eine Rufnummer wieder
entfernt worden. In einer Datei ist die Redaktion der aktuelle Stand; in git stünde der
ursprüngliche Wert dauerhaft in der Historie und in jedem Klon — ein Löschverlangen nach K15
wäre nicht erfüllbar, ohne die Historie umzuschreiben.

**Zum Arbeiten braucht man die Rollen, nicht die Namen.** Deshalb steht hier, *welche* Rolle
was tut; *wer* sie trägt, steht im Zugangsblatt.

---

## Wer was tut

| Rolle | Aufgabe | Beschluss |
|---|---|---|
| **Auftraggeber** | erteilt den Bauauftrag, zeichnet Tor II | Bauauftrag Abschn. 8 |
| **Zeichnet für den Auftragnehmer** | Gegenzeichnung von Auftrag und Anlage | **Nr. 158** |
| **Abnehmender Plattform-Admin** | löst den Wechsel nach `ABNAHME` aus (K23-M15) | **Nr. 158** |
| **Security- und Betriebsreview** | | **Nr. 149** |
| **Zweite natürliche Person** | zweiter Blick nach K14; zweite Person für `IN_PROD` (K23-M21) | **Nr. 165** |
| **Founder Technik und Betrieb** | Zielumgebung, Foundry-Deployment, Identitäten, Mailweg | Baustrategie V0–V3 |

**Auftraggeber und Auftragnehmer sind dieselbe Gesellschaft** — Eigenleistung, Bauauftrag
Kopftabelle. Die Rollentrennung ist deshalb eine Verfahrensregel, keine Vertragsfolge, und
sie ist genau deshalb aufgeschrieben.

---

## Anmeldung und Domäne

**Plattform-Admins melden sich mit einer Adresse der Domäne `@exmachinai.com` an.** Eine
Einladung an eine fremde Domäne wird abgewiesen — nachgewiesen im B1-Abnahmeprotokoll. Das
ist eine Regel über die Domäne, nicht über Personen.

---

## Postfächer und Zugangsdaten

Die drei Postfächer der Bauseite sind am 06.08.2026 angelegt und geprüft. **Adressen im
Zugangsblatt.** Hier nur der Zugriffsweg:

| Zweck | Umgebungsvariable | Wo der Wert liegt |
|---|---|---|
| Versand (SMTP) | `FREIRAUM_SMTP_USER`, `FREIRAUM_SMTP_PASS` | Schlüsselbund, Dienstname `FREIRAUM_SMTP_PASS` |
| DMARC-Berichte | — | Schlüsselbund, `FREIRAUM_DMARC_PASS` |
| Störungsweg | — | Schlüsselbund, `FREIRAUM_STOERUNG_PASS` |
| Datenbank (Zielumgebung) | `FREIRAUM_DSN` | Schlüsselbund, `FREIRAUM_PG_ADMIN_PASS` |

**In keiner Datei dieses Repos steht ein Kennwort** (Regel: keine Geheimnisse im Repo,
K23-D09). Der Code liest ausschließlich Umgebungsvariablen.

### Der Engpass, der noch offen ist

**Der Schlüsselbund liegt auf einem Rechner und teilt nichts.** Muss eine zweite Person
versenden oder auf die Datenbank, braucht es vorher einen geteilten Tresor oder Key Vault.
Bis dahin kann nur eine Person die Werte setzen — unabhängig davon, wer das Repo klonen kann.

*Empfehlung aus dem Plan vom 09.08.2026: **Key Vault**, weil K13 ihn ohnehin nennt und ein
zweiter Geheimnisort genau das ist, was K13-M17 vermeiden will.*
