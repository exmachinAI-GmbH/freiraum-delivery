# Tor 3 · Fremdreview — Vorlage

**Kopieren nach `nachweise/fremdreview/<scheibe>_<JJMMTT>.md`**, Kopf ausfüllen, Urteil des
Fremdmodells unverändert einsetzen, Prüfsumme daneben legen:

```bash
cd nachweise/fremdreview && shasum -a 256 <datei>.md > <datei>.md.sha256
python3 werkzeuge/fremdreview.py            # prueft alle Blaetter
```

**Der Kopf wird von einem Menschen ausgefüllt und gezeichnet.** Der Harness schreibt dieses
Blatt nie selbst (`.claude/commands/scheibe.md`:73). Ein von einem Agenten ausgefüllter Kopf
ist kein Nachweis, sondern seine Fälschung.

---

<!-- KOPF · maschinell gelesen, Feldnamen nicht ändern -->

| Feld | Wert |
|---|---|
| scheibe | `<z. B. 1 oder 1-anmeldung>` |
| datum | `<JJJJ-MM-TT>` |
| geprueft_commit | `<voller 40-stelliger Commit-Hash>` |
| pruefendes_modell | `<Name, z. B. GPT 5.6 Sol>` |
| pruefende_fassung | `<Fassungsangabe des Modells>` |
| frische_instanz | `ja` |
| getrennter_kontext | `ja` |
| gegen_roh_evidenz | `ja` |
| evidenz | `<welche Roh-Evidenz vorlag, mit Pfaden — nicht "der Baubericht">` |
| angefordert_von | `<Name des Menschen>` |
| harness_hat_nicht_geschrieben | `ja` |
| urteil | `<traegt | traegt mit auflagen | traegt nicht>` |

<!-- ENDE KOPF -->

## Zeichnung der Anforderung

Ich habe dieses Review bei einer **frischen Instanz** mit **getrenntem Kontext** angefordert,
die vorgelegte Roh-Evidenz benannt, und das Urteil unverändert übernommen. Der Harness hat
es nicht geschrieben.

| Name | Datum | Unterschrift |
|---|---|---|
|  |  |  |

---

## Urteil des Fremdmodells

*Unverändert einsetzen. Nicht zusammenfassen, nicht glätten, nicht kürzen — ein
zusammengefasstes Fremdurteil ist wieder das eigene Wort.*

<!-- hier das Urteil -->

## Fundstellen

*Das Urteil muss auf Fundstellen zeigen (Präzedenz Blatt 26:2 — „80 Zeilen mit
Fundstellen"). Ein Urteil ohne Fundstellen ist eine Meinung.*

<!-- hier die Fundstellen -->

## Auflagen und offene Punkte

| Nr. | Auflage | Träger | Frist |
|---|---|---|---|
|  |  |  |  |
