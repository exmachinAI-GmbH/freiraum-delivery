#!/usr/bin/env python3
"""Erzeugt nachweise/klauselregister/pflege.json fuer B-4.

Traegt NUR ein, was aus einer benannten Quelle stammt:
  kritikalitaet      <- triage.json vom 14.08.2026, als VORSCHLAG gekennzeichnet
  akzeptanzkriterium <- Wortlaut der Klausel, nur fuer die im Klauselschnitt
                        EINZELN BENANNTEN Klauseln, als VORSCHLAG gekennzeichnet
  eigentuemer        <- NICHTS. Keine Quelle benennt einen Menschen.
"""
import json
from pathlib import Path

REPO = Path("/Users/mveil/freiraum-delivery")
TRIAGE = REPO / "nachweise/klauselregister/triage.json"
ZIEL = REPO / "nachweise/klauselregister/pflege.json"

MARKE = "⟨VORSCHLAG · NICHT GEZEICHNET⟩"
SLOT = "⟨zeichnet: ⟩ ⟨am: ⟩"

# --- Die im Klauselschnitt EINZELN BENANNTEN Klauseln des Teilschnitts --------
# Quelle: nachweise/klauselschnitt/S1_zeichnung.md, Block 1a (7), 1b (6), 2 (2).
# Block 3 nennt keine Klausel einzeln - dort steht nur "Leseanlass".
A = "Block 1a — vom Bau beansprucht und ganz gedeckt"
B = "Block 1b — vom Bau beansprucht, nur teilweise gedeckt"
C = "Block 2 — vom Bau beansprucht, ohne Scheibenangabe"
SCHNITT = {
    "K03-D01": A, "K03-M13": A, "K20-D10": A, "K20-M14": A, "K20-M15": A,
    "K20-M18": A, "K23-D09": A,
    "K03-G01": B, "K03-M05": B, "K03-M26": B, "K13-M05": B, "K20-M08": B,
    "K20-M25": B,
    "K03-M15": C, "K03-M25": C,
}

# --- Die Bedingungen, Satz fuer Satz aus dem Wortlaut abgeschrieben -----------
# Jede Zeile hier ist eine Umstellung des Klauselwortlauts in eine pruefbare
# Aussage. Kein Wert, keine Schwelle, keine Frist, kein Messweg wird ergaenzt -
# das waere Umfang. Was der Wortlaut nicht sagt, steht als offene Klammer da.
BEDINGUNGEN = {
    "K03-D01": [
        "ein Vorgang ohne gültige Sitzung wird nicht wirksam",
        "ein Vorgang mit status WARTET_2FA wird abgelehnt",
        "ein Vorgang mit status GESPERRT wird abgelehnt",
        "in keinem der beiden Fälle entsteht ein Teil-Zugang",
    ],
    "K03-M13": [
        "jede Prüfung der Anmeldung läuft serverseitig",
        "eine allein in der Oberfläche erfolgte Prüfung wird als nicht erfolgt behandelt",
    ],
    "K20-D10": [
        "eine abgelaufene Einladung wirkt nicht erneut",
        "eine eingelöste Einladung wirkt nicht erneut",
        "eine widerrufene Einladung wirkt nicht erneut",
        "ein verfallener Link führt zu einem neuen Vorgang, nicht zu einer Verlängerung",
    ],
    "K20-M14": [
        "EINGELOEST steht nie ohne redeemed_at",
        "redeemed_at steht nie ohne EINGELOEST",
        "beides wird gemeinsam gesetzt (invitation_einloesung)",
        "der Beleg ist T11 - der Wortlaut benennt ihn selbst",
    ],
    "K20-M15": [
        "nach der Einlösung wechselt das Konto von WARTET_2FA auf AKTIV",
        "der Kontozustand bleibt bei K03 - K20 setzt ihn nicht selbst",
        "der Beleg ist T12 - der Wortlaut benennt ihn selbst",
    ],
    "K20-M18": [
        "jede Änderung an Zugang, Rolle, Mitgliedschaft oder Einladung steht im internen Nachweis",
        "der Eintrag trägt den Zeitpunkt",
        "der Eintrag trägt die handelnde Instanz",
        "der Eintrag trägt den Wert davor und den Wert danach",
    ],
    "K23-D09": [
        "kein Geheimnis in Manifest, Log, Screenshot oder Fehlerausgabe",
        "kein Zugangswert in Manifest, Log, Screenshot oder Fehlerausgabe",
        "keine unmaskierte personenbezogene Angabe in Manifest, Log, Screenshot oder Fehlerausgabe",
        "ein solcher Fund sperrt den Lauf",
    ],
    "K03-G01": [
        "eine nicht erfüllte Vorbedingung sperrt",
        "eine nicht prüfbare Vorbedingung sperrt ebenso",
        "die Sperre wird angezeigt",
        "die Anzeige trägt die Begründung",
    ],
    "K03-M05": [
        "der zweite Faktor ist ein Code per E-Mail",
        "der Code ist sechsstellig",
        "mfa_method trägt den Wert EMAIL_CODE",
        "ein anderes Verfahren führt das Datenmodell nicht",
    ],
    "K03-M26": [
        "der Versand nutzt verwaltete Identität oder Secret-Referenz",
        "der Versand nutzt eine erlaubte Ausgangsverbindung",
        "die Telemetrie ist datensparsam",
        "kein Code steht im Log",
        "keine vollständige E-Mail-Adresse steht im Log",
        "Providerfehler wirkt fail-closed und alarmiert den Betrieb mit Runbook-Verweis",
        "fehlender Nachweis wirkt fail-closed und alarmiert den Betrieb mit Runbook-Verweis",
        "unklare Konfiguration wirkt fail-closed und alarmiert den Betrieb mit Runbook-Verweis",
    ],
    "K13-M05": [
        "jeder Aufruf aus einer Oberfläche läuft über den Serverpfad",
        "der Serverpfad prüft das aktive Konto",
        "der Serverpfad prüft die Mitgliedschaft",
        "der Serverpfad prüft die Rolle",
        "der Serverpfad prüft den Mandanten",
        "der Serverpfad prüft den Objektbezug",
        "alle fünf Prüfungen liegen vor dem Lesen und vor dem Schreiben",
    ],
    "K20-M08": [
        "gespeichert wird allein der Streuwert des Links",
        "wer den Datenbestand liest, kann keine fremde Einladung einlösen",
    ],
    "K20-M25": [
        "der Wiederversand zeigt den Satz: Der vorherige Link ist ungültig",
        "der Nachweis einer Zugangsänderung trägt retention_class = BETRIEBSPROTOKOLL",
        "die personenbezogene Anzeige ist nach K15 minimiert",
    ],
    "K03-M15": [
        "ein E-Mail-Code ist zehn Minuten gültig",
        "ein E-Mail-Code ist genau einmal gültig",
        "ein neuer Code entwertet alle älteren Codes desselben Kontos",
        "gespeichert wird nur der kryptografische Prüfwert des Codes",
    ],
    "K03-M25": [
        "der Einladungsbefehl läuft serverseitig",
        "der Einladungsbefehl ist idempotent",
        "er prüft den Zielmandanten",
        "er prüft den Entscheidungsnachweis",
        "er prüft die Domäne",
        "er legt Einladung und Ereignis atomar an",
        "Portal, Builder und Service-Schlüssel umgehen diese Prüfung nicht",
        "Fehlermeldungen geben nicht preis, ob ein Konto existiert",
    ],
}


def kritikalitaet(zeile):
    if zeile["vorschlag_kritikalitaet"] != "kritisch":
        return None  # 'unbestimmt' heisst NICHT 'nicht kritisch' - Feld bleibt leer
    gruppen = " + ".join(zeile["gruppen"])
    belege = "; ".join(
        f"{b['gruppe']}: „{b['begriff']}“ (Stelle {b['stelle']})"
        for b in zeile["belegstellen"]
    )
    sperre = (" · fehlender Test SPERRT die Freigabe (K23-M04)"
              if zeile["sperrt_die_freigabe"] else "")
    return (f"{MARKE} kritisch: {gruppen}{sperre} · Quelle: triage.json vom "
            f"14.08.2026, Beleg im eigenen Wortlaut — {belege} · K23-G08: die "
            f"Kritikalität begründet der fachliche Eigentümer, nicht der "
            f"Harness · {SLOT}")


def kriterium(bed, block):
    liste = "; ".join(f"({i}) {b}" for i, b in enumerate(bed, 1))
    return (f"{MARKE} Umstellung des eigenen Wortlauts, nichts ergänzt. "
            f"Erfüllt, wenn nachgewiesen ist: {liste}. "
            f"Messweg, Schwelle und Evidenzform sagt der Wortlaut nicht — sie "
            f"ergänzt nach K23-M02 der fachliche Eigentümer, der in dieser "
            f"Zeile heute ⟨nicht benannt⟩ ist. Warum diese Klausel vorgelegt "
            f"wird: klauselschnitt/S1_zeichnung.md, {block} — dort noch ohne "
            f"Haken. {SLOT}")


def main():
    triage = json.loads(TRIAGE.read_text(encoding="utf-8"))
    pflege, n_krit, n_kri = {}, 0, 0
    for z in triage["zeilen"]:
        kl = z["klausel"]
        eintrag = {}
        k = kritikalitaet(z)
        if k:
            eintrag["kritikalitaet"] = k
            n_krit += 1
        if kl in SCHNITT:
            eintrag["akzeptanzkriterium"] = kriterium(BEDINGUNGEN[kl], SCHNITT[kl])
            n_kri += 1
        if eintrag:
            pflege[kl] = eintrag
    ZIEL.write_text(json.dumps(pflege, ensure_ascii=False, indent=2,
                              sort_keys=True) + "\n", encoding="utf-8")
    fehlt = sorted(set(SCHNITT) - set(BEDINGUNGEN))
    print(f"Eintraege: {len(pflege)} · Kritikalitaet: {n_krit} · "
          f"Kriteriumsvorschlag: {n_kri} · Eigentuemer: 0 · "
          f"ohne Bedingungsliste: {fehlt}")


if __name__ == "__main__":
    main()
