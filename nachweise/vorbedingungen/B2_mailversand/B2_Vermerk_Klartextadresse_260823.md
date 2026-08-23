# Vermerk · Klartextadresse in den AC-16-Belegen

**23.08.2026 · Entscheidung M. Veil**

## Was abweicht

`kopf_260823.txt` und `ac16_pruefen_260823.log` enthalten die E-Mail-Adresse
`michael.veil@icloud.com` unmaskiert. K23-D09 verbietet unmaskierte
personenbezogene Angaben in Manifest, Log, Screenshot oder Fehlerausgabe.

## Warum sie bleibt

Der Prüffall AC-16 hält die `To`-Zeile des zugestellten Kopfes gegen
`FREIRAUM_PRUEF_ECHT_EMPFAENGER`. Eine maskierte Adresse wäre kein Beleg mehr:
Der Nachweis besteht gerade darin, dass **diese** Mail an **diesen** Empfänger
zugestellt und dort gelesen wurde. Wer den Lauf später nachvollziehen will,
braucht die Zeile im Wortlaut.

## Wie weit die Abweichung reicht

| | |
|---|---|
| **Adresse** | die private Adresse des Auftraggebers, von ihm selbst eingebracht |
| **Betroffene Dateien** | genau zwei, beide in diesem Ordner |
| **Nicht betroffen** | Manifeste, Bericht, Klauselregister, Serverprotokolle — dort steht sie nicht |
| **Keine Dritten** | es ist keine Kundenadresse und keine Adresse einer anderen Person |
| **Pilotbetrieb** | unberührt. Für Kundenadressen gilt K23-D09 unverändert |

## Was daraus nicht folgt

Dieser Vermerk deckt **einen** Nachweis, nicht eine Übung. Entsteht der Beleg
später erneut — etwa beim sauberen Wiederholungslauf nach K23-M18 —, gilt die
Entscheidung für dieselbe Adresse fort; für jede andere Adresse ist neu zu
entscheiden.

---

**Gezeichnet:** ⟨………………………⟩ **am** ⟨………………⟩
