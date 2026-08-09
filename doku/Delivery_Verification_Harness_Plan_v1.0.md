# FREIRAUM Delivery & Verification Harness

**Dokumenttyp:** Konsolidierter, durch den FREIRAUM-Expertenreview-Raster geprüfter Umsetzungsplan  
**Stand:** 31.07.2026  
**Basis:** Gesamtbuild v2.9, Plattformkonzepte K00–K22, Projektkonzepte der Familien 1 und 2  
**Zielgruppe:** Mid-Tech Audience, Architektur-, Entwicklungs-, UX/UI-, Security-, Compliance- und Betriebsteams

## 1. Konsolidiertes Urteil des Experten-Review-Teams

Benötigt wird ein eigener **FREIRAUM Delivery & Verification Harness**, getrennt von der Konzept-Fabrik.

> Nicht der Gesamtbuild v2.9 wird zum App Builder. Der Harness übersetzt freigegebene Konzepte in einen maschinenlesbaren Bauauftrag, lässt diesen durch austauschbare App Builder umsetzen und akzeptiert das Ergebnis nur bei nachgewiesener Konformität.

Die Konzept-Fabrik beantwortet: „Ist das Konzept vollständig, widerspruchsfrei und freigabefähig?“  
Der Delivery & Verification Harness beantwortet: „Tut das gebaute und laufende System nachweisbar das, was die freigegebenen Konzepte verlangen?“

## 2. Verbindliche Quellenhierarchie

Der Harness erzwingt folgende Rangfolge:

1. DDL und Datenmodell als technische Ground Truth.
2. K00–K22 als plattformweite, für jede App geltende Regeln.
3. Freigegebene projektspezifische Anforderungen aus Familie 1.
4. Projektvertrag aus Familie 2.
5. Freigegebene Richtlinien aus M4.
6. K19 als verbindlicher UI-Vertrag und K16 als Bedienregelwerk.
7. Gesamtbuild v2.9 ausschließlich als visuelle und strukturelle Referenz über `quellen/build-inventar.md` und `quellen/build-tot.md`.

Der HTML-Gesamtbuild darf niemals direkt zur Codegenerierung verwendet werden. Er enthält überlagerte sowie physisch noch vorhandene, aber gestrichene Strukturen. Jede generierte Funktion muss bis zu ihrer freigegebenen Quelle zurückverfolgbar sein.

## 3. Zielarchitektur

```text
Freigegebene Konzepte und DDL
              |
              v
      Build-Contract-Compiler
              |
              v
 UI-, Daten-, API- und Agentenverträge
              |
              v
       App-Builder-Adapter
              |
              v
 Replit / Lovable / Bolt / OSS-Builder
              |
              v
      Prüf- und Evidenz-Harness
              |
              v
  Blockierende Release-Gates
              |
              v
       Finales HITL-Paket
              |
              v
       Menschliche Freigabe
```

## 4. Bausteine des Harness

### 4.1 Build-Contract-Compiler

Der Compiler überführt jede M/D/G-Klausel in eine maschinenlesbare Registry. Je Eintrag werden mindestens geführt:

- eindeutige Klauselkennung;
- verbindlicher Wortlaut;
- Herkunft und Dokumentversion;
- fachlicher Eigentümer;
- betroffene Screens, Tabellen, Views, APIs, Agenten und Betriebsservices;
- Akzeptanzkriterium;
- zugeordneter Test;
- Evidenz und Ergebnis;
- Status oder ausdrücklich benanntes Restrisiko.

Zusätzlich entsteht ein Traceability Graph, der Quelle, Klausel, Implementierung, Test und Evidenz miteinander verbindet.

### 4.2 Schema- und API-Harness

Dieser Baustein:

- erzeugt und prüft versionierte Migrationen;
- erkennt Drift gegenüber DDL und Datenmodell;
- erzeugt explizite Views ohne unkontrolliertes `SELECT *`;
- erzeugt ausschließlich serverseitige Schreibbefehle;
- erstellt RLS-Policies für SELECT, INSERT, UPDATE und DELETE;
- prüft Mandant, Rolle, Objektbezug und privilegierte Bypass-Rollen;
- prüft Idempotenz, Nebenläufigkeit, atomare Auditierung und Wiederanlauf.

Direkte Schreibrechte eines Browsers oder App Builders auf fachliche Tabellen sind ausgeschlossen.

### 4.3 UX/UI-Contract-Harness

Die aktuelle K19-Maschinenquelle enthält 31 Screen-IDs. Je Screen erzeugt beziehungsweise prüft der Harness:

- Komponentenvertrag und Screen-Eigentümer;
- notwendige Elemente und Aktionen;
- Lade-, Leer-, Erfolgs- und Fehlerzustände;
- Zugangs- und Berechtigungsmarke;
- serverseitige Vorbedingungen;
- Poka-Yoke-Regeln aus K16;
- „ausblenden“ versus „ausgrauen“;
- abgeleitete, nicht auswählbare Labels;
- Responsive-Verhalten;
- WCAG-2.2-Konformität;
- visuelle Regression gegenüber der freigegebenen Referenz.

UX-Änderungen aus den Konzepten werden damit nicht frei interpretiert, sondern als versionierter UI-Vertrag umgesetzt.

### 4.4 App-Builder-Adapter

Replit, Lovable, Bolt oder ein OSS-Stack sind austauschbare Erzeuger. Jeder Adapter:

- erhält denselben Build Contract;
- arbeitet nur mit synthetischen Daten in einer isolierten Umgebung;
- erhält keine Produktionsidentitäten oder Produktionsgeheimnisse;
- erhält keinen direkten Produktionsdatenbankzugriff;
- muss ein vollständiges, exportierbares Repository liefern;
- liefert Build-Manifest, Abhängigkeitsliste und erzeugte Artefakte zurück;
- muss dieselben Tests und Release-Gates bestehen.

Der Harness bleibt damit unabhängig von einem einzelnen Anbieter.

### 4.5 Agenten- und Modell-Harness

Der Harness prüft die 16 Agenten und bindet jeden Modellpfad an:

- Deployment-ID, Anbieter und Region;
- Netzwerk- und Policyversion;
- fachlichen Zweck und Datenminimum;
- Modell- und Promptversion;
- Toolrechte und erlaubte Datenziele;
- versionierten Evaluationssatz;
- Freigabeschwelle;
- menschliche Eskalationsrolle.

Der Review-Agent verwendet ein anderes Modell als der erzeugende Agent. Unvollständige Modellpfade werden nicht aufgerufen. Dynamisches Wissen läuft ausschließlich über den Quellenbroker.

### 4.6 Acceptance-, Security- und Compliance-Harness

Der Harness führt automatisiert aus:

- Golden- und Contract-Tests;
- Integrations-, End-to-End- und UI-Tests;
- Zwei-Mandanten-Negativtests je Vorgangsart;
- Rollen-, Objektbezugs- und Selbstfreigabetests;
- Fail-closed- und Berechtigungs-Negativtests;
- Tests auf Lost Updates, Idempotenz und Teilfehler;
- Audit-, Aufbewahrungs- und Time-Travel-Tests;
- Prompt-Injection- und Datenabflussprüfungen;
- SAST, DAST, Geheimnisscan und Abhängigkeitsprüfung;
- SBOM- und Lizenzprüfung;
- Accessibility- und visuelle Regressionstests.

Jede Klausel zeigt auf Evidenz oder auf ein ausdrücklich benanntes Restrisiko.

### 4.7 Release-, Betriebs- und Service-Harness

Dieser Baustein umfasst:

- Infrastructure as Code;
- CI/CD und kontrollierte Umgebungs-Promotion;
- verwaltete Identitäten, Key Vault und private Endpunkte;
- Observability, Korrelation und Alarmierung;
- SLI/SLO sowie festgelegte RTO/RPO;
- Backup- und Restore-Proben;
- Kapazitäts- und Kostenwarnungen;
- Servicekatalog und Konfigurationsregister;
- Service Owner, Kritikalität und SLA/OLA;
- Incident-, Problem-, Change- und Eskalationswege;
- Runbooks und revisionsgebundene Betriebsnachweise.

Am Ende entsteht ein unveränderliches Release-Manifest mit Hashes aller geprüften Eingaben und Ergebnisse.

## 5. Blockierende Release-Gates

Ein Build darf nicht zur menschlichen Freigabe gelangen bei:

1. DDL-, Schema-, Quellen- oder Konzeptdrift.
2. Fehlenden oder unwirksamen RLS-Policies.
3. Erfolgreichem Zugriff zwischen zwei Mandanten.
4. Umgehung der serverseitigen Befehle.
5. Selbstfreigabe oder fehlender Rollentrennung.
6. Verlust einer fachlichen Änderung oder ihrer Auditspur.
7. Kritischen Sicherheitslücken oder enthaltenen Geheimnissen.
8. Erfolgreicher Prompt-Injection mit Tool- oder Datenzugriff.
9. Fehlgeschlagenem Backup-/Restore-Test.
10. Nicht nachvollziehbarer Herkunft einer erzeugten Funktion.
11. Fehlender Eigentümer- oder Akzeptanzzuordnung.
12. Beschädigter Hash- und Evidenzkette.

Die Testabdeckung wird sichtbar ausgewiesen. Entsprechend F34 gibt es keine künstliche Mindestquote. Jede nicht durch einen Golden-Test belegte Klausel muss jedoch einzeln als Restrisiko aufgeführt werden.

Den Status „Freigegeben“ setzt ausschließlich ein Mensch im finalen HITL-Paket.

## 6. Gegenwärtiger technischer Blocker

Die v2.9-DDL enthält derzeit keine nachgewiesenen RLS-Policies. Deshalb gilt verbindlich:

- Entwicklung und Abnahme nur isoliert und server-only;
- kein direkter Browser- oder Builder-Zugriff auf das Schema;
- keine Verwendung von Produktionsdaten in Baukasten-Vorschauen;
- keine Produktivfreigabe;
- Produktion erst nach RLS für alle mandantenbezogenen Tabellen und bestandenen Zwei-Mandanten-Negativtests.

## 7. Empfohlene Umsetzungsreihenfolge

Nicht sofort alle App Builder anbinden. Zuerst wird ein vollständiger vertikaler Referenzdurchlauf hergestellt:

1. Maschinenlesbarer Build Contract für K00, K01, K02, K13, K16 und K19.
2. Ein vollständiger Endnutzerprozess mit den zugehörigen Screens.
3. Serverseitiger Befehl, Datenmodell, Auditierung und RLS.
4. Golden-, Contract-, UI- und Zwei-Mandanten-Negativtests.
5. Evidenzkette und finales HITL-Paket.
6. Nach erfolgreicher Referenzabnahme schrittweise Aufnahme der übrigen Konzepte.
7. Danach zusätzliche Builder-Adapter für Replit, Lovable, Bolt und OSS-Stacks.

## 8. Liefergegenstände

Der fertige Harness liefert je Build mindestens:

- `build-contract.yaml`;
- `clause-registry.yaml`;
- `traceability-graph.json`;
- `ui-contract.yaml`;
- Schema- und Migrationspaket;
- RLS- und API-Vertrag;
- Agenten- und Modellregister;
- Testkatalog und Testergebnisse;
- SBOM und Security-Nachweise;
- Betriebs- und Service-Readiness-Nachweis;
- Liste aller nicht getesteten Klauseln und Restrisiken;
- unveränderliches Build-Manifest mit SHA-256-Prüfkette;
- finales HITL-Freigabepaket.

## 9. Schlussfolgerung

Der Zielzustand ist keine reine Codefabrik. Er ist eine **evidenzbasierte, compliance-by-construction App-Fabrik**.

Der App Builder erzeugt Code. Der FREIRAUM Delivery & Verification Harness entscheidet anhand verbindlicher Verträge und nachprüfbarer Evidenz, ob dieser Code fachlich, technisch, gestalterisch, sicher, compliant und betriebsfähig ist. Erst danach erhält der Mensch das finale HITL-Paket zur Entscheidung.
