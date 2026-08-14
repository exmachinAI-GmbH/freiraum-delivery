#!/usr/bin/env python3
# -*- coding: utf-8 -*-
"""Lint-Regel fuer K19_screens.yaml  (Punkt 16 · Entscheidung E11)

SCHARF GESCHALTET am 5.8.2026. Bis dahin lag sie als Entwurf unter
entscheidungsvorlagen/.../uebergabe/k19_lint_regel_entwurf.py.

Warum es diese Datei gibt
-------------------------
K19_screens.yaml ist als "einzige pflegbare Screenquelle" bezeichnet (K19
Abschn. 1) — aber KEIN Werkzeug im Repo liest sie (Befund 2.2 der Planung
vom 4.8.: grep ueber config/, werkzeuge/, vorlagen/, .claude/ ergibt null
Treffer). Eine Vorgabe, die niemand prueft, wird von nichts durchgesetzt.
Diese Regel schliesst die Luecke: sie liest die Datei und prueft K19-M03
(genau eine Zugangsmarke) und K19-M14 (je Aktion sieben Angaben).

Einbau
------
Als eigenstaendige Pruefung lauffaehig:

    python3 werkzeuge/k19_screens_lint.py [pfad/zu/K19_screens.yaml]

Ohne Pfad wird schema/K19_screens.yaml geprueft.

Zur Uebernahme in werkzeuge/lint.py: die Funktion pruefe_k19_screens()
uebernehmen und in der Prueffolge aufrufen, wenn das geprüfte Konzept
K19 ist oder einen Bildschirm referenziert. Exit-Codes wie lint.py:
0 = gruen · 1 = FEHLER · 2 = Aufruffehler. HINWEIS blockiert nicht.

Zweiter Standort seit dem 14.08.2026
------------------------------------
Diese Datei ist eine KOPIE aus der Konzept-Fabrik
(`ITERATION_2/werkzeuge/k19_screens_lint.py`, dort scharf seit 5.8.2026).
Sie liegt hier aus demselben Grund wie `schema/freiraum_datamodel.sql`:
ein CI-Lauf greift nicht auf die Dropbox zu, und eine Pruefung gegen eine
Quelle, die der Lauf nicht selbst mitbringt, ist nicht reproduzierbar.

Der Satz oben -- "eine Vorgabe, die niemand prueft, wird von nichts
durchgesetzt" -- galt am 14.08.2026 erneut, eine Ebene tiefer: die
Maschinenquelle war in dieser Lieferung nicht vorhanden, die vier Vorlagen
unter app/vorlagen/ beriefen sich auf K19-M01, ohne eine Fassung zu nennen.
Gemessen wurde nichts. Genau das schliesst dieser Einbau.

Geaendert gegenueber dem Original sind GENAU ZWEI Stellen: dieser Abschnitt
der Kopfdokumentation und der Vorgabepfad in main(). Die Pruefregeln sind
Zeile fuer Zeile dieselben -- pruefe_k19_screens(), lies_screens(),
pruefe_befehle() und begruendet() sind unberuehrt. Nachrechnen:

    diff "<Fabrik>/werkzeuge/k19_screens_lint.py" werkzeuge/k19_screens_lint.py

Deshalb steht diese Datei auch in ruff.toml unter per-file-ignores: sie wird
hier nicht gepflegt, sondern nachgefuehrt, und muss dafuer vergleichbar
bleiben. Ausgenommen ist ihre Schreibweise, nicht ihre Wirkung -- sie laeuft
in Tor 1a und muss gruen sein.

Absichtliche Milde (bis Entscheidung 3)
---------------------------------------
Der Namensraum des Serverbefehls existiert in keiner v2.9-Quelle. Ein
Platzhalter '<FESTZULEGEN:...>' ist deshalb HINWEIS, kein FEHLER — ein
FEHLENDER oder leerer serverbefehl-Schluessel dagegen ist FEHLER. Sobald
Entscheidung 3 gezeichnet ist, wird PLATZHALTER_IST_FEHLER auf True
gesetzt; ab dann blockiert auch der Platzhalter.

Bewusst KEIN PyYAML: werkzeuge/lint.py haelt das Repo abhaengigkeitsfrei
(eigener Mini-Leser mit dokumentierter Mehrzeilen-Falle). Dieser Leser
hier ist auf genau die Struktur von K19_screens.yaml zugeschnitten und
weist alles ab, was er nicht versteht — fail-closed statt raten.
"""
import re
import sys

PLATZHALTER_IST_FEHLER = True    # scharf seit 5.8.2026, BV-6 Nr. 67

ZUGANGSMARKEN = {"offen", "nach_anmeldung", "nach_gesetztem_haekchen"}   # K19-M03
M14_PFLICHT = ["eingabe", "serverbefehl", "berechtigung",
               "zustand_laden", "zustand_leer", "zustand_erfolg", "zustand_fehler"]
NUR_UI = re.compile(r"^\s*(ausgeblendet|ausgegraut|inaktiv|disabled)\b", re.I)


def _wert(zeile):
    v = zeile.split(":", 1)[1].strip()
    if v.startswith('"') and v.endswith('"'):
        v = v[1:-1]
    return v


def lies_screens(pfad):
    """Liest K19_screens.yaml — Bestandsform (Flow) und Entwurfsform (Block)."""
    kopf, screens, fehler = {}, [], []
    akt_screen, akt_aktion, in_aktionen = None, None, False
    for nr, roh in enumerate(open(pfad, encoding="utf-8"), 1):
        zeile = roh.rstrip("\n")
        strip = zeile.strip()
        if not strip or strip.startswith("#"):
            continue
        einzug = len(zeile) - len(zeile.lstrip())

        m = re.match(r"-\s*\{(.+)\}\s*$", strip)          # Flow: - {id: EN-01, ...}
        if m and einzug <= 2:
            eintrag = {"_zeile": nr}
            for teil in m.group(1).split(","):
                if ":" in teil:
                    k, v = teil.split(":", 1)
                    eintrag[k.strip()] = v.strip()
            screens.append(eintrag)
            akt_screen, in_aktionen, akt_aktion = eintrag, False, None
            continue
        if re.match(r"-\s*id\s*:", strip) and einzug <= 2:  # Block: - id: EN-03
            akt_screen = {"_zeile": nr, "id": _wert(strip.lstrip("- ")),
                          "aktionen": None}
            screens.append(akt_screen)
            in_aktionen, akt_aktion = False, None
            continue
        if akt_screen is not None and einzug >= 4:
            if re.match(r"aktionen\s*:\s*\[\s*\]\s*$", strip):
                akt_screen["aktionen"] = []
                continue
            if re.match(r"aktionen\s*:\s*$", strip):
                akt_screen["aktionen"] = []
                in_aktionen = True
                continue
            if in_aktionen and re.match(r"-\s*kennung\s*:", strip):
                akt_aktion = {"_zeile": nr, "kennung": _wert(strip.lstrip("- "))}
                akt_screen["aktionen"].append(akt_aktion)
                continue
            if in_aktionen and akt_aktion is not None and ":" in strip and einzug >= 8:
                k = strip.split(":", 1)[0].strip()
                akt_aktion[k] = _wert(strip)
                continue
            if ":" in strip and einzug == 4:
                in_aktionen = False
                akt_screen[strip.split(":", 1)[0].strip()] = _wert(strip)
                continue
            fehler.append((nr, "Zeile nicht verstanden — fail-closed: " + strip[:60]))
            continue
        if ":" in strip and einzug == 0 and not strip.startswith("-"):
            k = strip.split(":", 1)[0].strip()
            if k != "screens":
                kopf[k] = _wert(strip)
            continue
        if einzug == 2 and ":" in strip:                   # rules:-Unterschluessel
            kopf.setdefault("_rules", {})[strip.split(":", 1)[0].strip()] = _wert(strip)
            continue
    return kopf, screens, fehler


def pruefe_k19_screens(pfad):
    befunde = []                                          # (schwere, zeile, text)
    aktionen_je_befehl = {}     # Befehl -> [(screen, kennung, zeile, wirkung)]
    try:
        kopf, screens, parsefehler = lies_screens(pfad)
    except OSError as e:
        return [("FEHLER", 0, "Datei nicht lesbar: %s" % e)]
    for nr, txt in parsefehler:
        befunde.append(("FEHLER", nr, txt))

    soll = kopf.get("_rules", {}).get("screen_count")
    if soll is not None and soll.isdigit() and len(screens) != int(soll):
        befunde.append(("FEHLER", 0,
            "screen_count %s festgeschrieben, %d Eintraege gefunden — Befund 2.4 "
            "(validate_hitl_pipeline erwartet exakte Zahl)" % (soll, len(screens))))

    kennungen = set()
    for s in screens:
        sid, z = s.get("id", "?"), s.get("_zeile", 0)
        if sid in kennungen:
            befunde.append(("FEHLER", z, "%s: Kennung doppelt" % sid))
        kennungen.add(sid)
        if s.get("access") not in ZUGANGSMARKEN:
            befunde.append(("FEHLER", z,
                "%s: Zugangsmarke '%s' — K19-M03 erlaubt genau %s"
                % (sid, s.get("access"), " · ".join(sorted(ZUGANGSMARKEN)))))
        if not s.get("owner"):
            befunde.append(("FEHLER", z, "%s: kein Eigentuemer" % sid))

        aktionen = s.get("aktionen")
        if aktionen is None:
            befunde.append(("FEHLER", z,
                "%s: kein aktionen:-Block — K19-M14 ist fuer diesen Bildschirm "
                "unerfuellt (der Befund, der Punkt 16 ausgeloest hat)" % sid))
            continue
        if aktionen == [] and not s.get("anzeige_ohne_aktion"):
            befunde.append(("FEHLER", z,
                "%s: aktionen leer ohne anzeige_ohne_aktion-Begruendung" % sid))
            continue
        for a in aktionen:
            az, ak = a.get("_zeile", z), a.get("kennung", "?")
            bef = (a.get("serverbefehl") or "").strip()
            if bef and "FESTZULEGEN" not in bef:
                aktionen_je_befehl.setdefault(bef, []).append(
                    (sid, ak, az, (a.get("zustand_erfolg") or "").strip()))
            for pflicht in M14_PFLICHT:
                wert = a.get(pflicht, "")
                if not wert:
                    befunde.append(("FEHLER", az,
                        "%s/%s: '%s' fehlt oder leer — K19-M14 verlangt alle sieben"
                        % (sid, ak, pflicht)))
                elif pflicht == "serverbefehl" and "FESTZULEGEN" in wert:
                    befunde.append((
                        "FEHLER" if PLATZHALTER_IST_FEHLER else "HINWEIS", az,
                        "%s/%s: Serverbefehl ist Platzhalter — wartet auf "
                        "Entscheidung 3 (Namensraum)" % (sid, ak)))
                elif pflicht == "berechtigung" and NUR_UI.match(wert):
                    befunde.append(("FEHLER", az,
                        "%s/%s: Berechtigung nennt nur einen UI-Zustand — "
                        "K19-M14 Satz 2: kein Ersatz fuer serverseitige "
                        "Autorisierung" % (sid, ak)))
                elif wert.strip().lower().startswith("entfaellt") \
                        and not begruendet(wert):
                    befunde.append(("FEHLER", az,
                        "%s/%s: '%s' entfaellt ohne Begruendung — entfaellt "
                        "ist zulaessig, aber nur begruendet" % (sid, ak, pflicht)))
    befunde += pruefe_befehle(aktionen_je_befehl, befunde)  # 05.08.2026
    return befunde


def pruefe_befehle(je_befehl, _):
    """Traegt jeder Befehl genau eine Sache -- und jede Sache genau einen Namen?

    05.08.2026 NACHGETRAGEN nach dem Fremdreview zu K19. Die Regel meldete
    "0 Fehler, 0 Hinweise" fuer einen Katalog, in dem
      * derselbe Befehl `load_prototype_preview` an VIER verschiedenen
        Wirkungen stand (Uebergang, Breitenwechsel, Zoom, Neuladen) und
      * dieselbe Wirkung unter ZWEI Namen lief (resume_app /
        resume_app_journey, open_app_readonly / view_sealed_app,
        create_session_by_email_code / start_session).
    Sie zaehlte, ob die sieben Felder DA sind -- nicht, ob die Namen etwas
    bedeuten. Der Satz aus dem Fremdreview trifft es: "Der gruene Validator
    prueft Feldanwesenheit, nicht Befehlssemantik."

    Was hier geprueft wird, ist das Machbare: ob ein Befehl an mehreren
    Stellen steht, deren Erfolgszustand VERSCHIEDEN lautet. Gleiche Wirkung
    unter zwei Namen kann eine Maschine nicht erkennen -- dafuer braucht es
    einen Leser. Deshalb HINWEIS und nicht FEHLER: die Regel meldet den
    Verdacht, entschieden wird er von Hand.
    """
    befunde = []
    for befehl, stellen in sorted(je_befehl.items()):
        if len(stellen) < 2:
            continue
        wirkungen = {w for _, _, _, w in stellen}
        if len(wirkungen) > 1:
            wo = " · ".join("%s/%s" % (s, k) for s, k, _, _ in stellen)
            befunde.append(("HINWEIS", stellen[0][2],
                "%s steht an %d Stellen mit %d verschiedenen Erfolgszustaenden: %s "
                "-- ein Name je Sache (K19-M14)"
                % (befehl, len(stellen), len(wirkungen), wo)))
    return befunde


def begruendet(wert):
    """Traegt ein "entfaellt" einen Grund?

    05.08.2026 KORRIGIERT. Die erste Fassung verlangte woertlich das Wort
    "Begruendung" oder die Kennung "K19-M06" im Text. Beim ersten Lauf gegen
    den vollstaendigen Aktionsblock meldete sie dadurch acht FEHLER, die
    keine waren: alle acht trugen einen Grund, nur in eigenen Worten --
    "entfaellt — die Anzeige wird ohne Nachladen von Inhalten umgestellt".
    Das ist derselbe Fehler, den lint.py an anderer Stelle ausdruecklich
    vermeidet: das WORT pruefen statt der SACHE.

    Jetzt gilt: nach dem "entfaellt" muss ein Gedankenstrich oder Doppelpunkt
    stehen und danach ein Satz, der etwas aussagt -- mindestens vier Woerter.
    Ein blosses "entfaellt" oder "entfaellt — n/a" faellt weiterhin durch.
    """
    rest = re.split(r"[—:-]", wert.strip(), 1)
    if len(rest) < 2:
        return False
    return len(rest[1].split()) >= 4


def main():
    if len(sys.argv) == 1:
        # 14.08.2026: In der Konzept-Fabrik lag die Quelle unter
        # 03_KONZEPTE_v2.9/schemas/. In dieser Lieferung liegt sie neben der
        # anderen Grundwahrheit, in schema/ -- der Vorgabepfad folgt ihr.
        # Er wird aus dem Ort DIESER Datei abgeleitet, nicht aus dem
        # Arbeitsverzeichnis: ein Lauf aus einem Unterordner soll dieselbe
        # Datei messen wie ein Lauf aus der Wurzel.
        import os
        vor = os.path.join(os.path.dirname(os.path.dirname(os.path.abspath(__file__))),
                           "schema", "K19_screens.yaml")
        sys.argv.append(vor)
    if len(sys.argv) != 2:
        print("Aufruf: python3 werkzeuge/k19_screens_lint.py [K19_screens.yaml]")
        return 2
    befunde = pruefe_k19_screens(sys.argv[1])
    n_f = sum(1 for s, _z, _t in befunde if s == "FEHLER")
    for schwere, zeile, text in befunde:
        print("%s  Z.%-4s %s" % (schwere, zeile or "-", text))
    print("----")
    print("K19-Screens: %d FEHLER, %d HINWEISE — %s"
          % (n_f, len(befunde) - n_f, "ROT" if n_f else "GRUEN"))
    return 1 if n_f else 0


if __name__ == "__main__":
    sys.exit(main())
