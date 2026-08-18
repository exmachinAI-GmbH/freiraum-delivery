#!/usr/bin/env python3
"""Der UI-Riegel · Blatt 94 (BEF-UI-1), Punkt 4 -- gezeichnet am 18.08.2026.

WOZU ER DA IST
    M. Veil hat am 11.08.2026 festgelegt (Blatt 70): "Kein Bildschirm
    entsteht ohne seinen K19-Kasten ... Neu ist, dass sie auch fuer den Bau
    gilt, nicht nur fuer Konzepte."

    Die Festlegung galt ein Vierteljahr und wurde nicht eingehalten -- nicht
    aus Nachlaessigkeit, sondern weil nichts danach fragte. Am 18.08.2026
    trug 1 von 8 Vorlagen ihren Kasten.

    Die CLAUDE.md der Konzeptfabrik fuehrt K19 als verbindliche
    UI-Referenz (Z. 51). Die CLAUDE.md DIESES Repos nennt K19 kein
    einziges Mal -- gemessen am 18.08.2026: null Treffer. Der Bau hatte
    die Regel also nie vor Augen, und nichts hat danach gefragt.

    Dieses Werkzeug ist der Unterschied zwischen einer Regel und einer
    Schranke: es macht aus der Weisung eine Bedingung, an der ein Lauf
    scheitert.

WAS ER PRUEFT -- vier Pruefungen je Vorlage in app/vorlagen/

    a) Marker      Traegt die Vorlage  bildschirm: <ID>  oder
                   bildschirm: keiner -- <Grund>?          sonst FEHLER
    b) Kasten da   Fuehrt die Referenz einen Kasten zu <ID>? sonst GESPERRT
    c) Woertlich   Steht der Kasten woertlich in der Vorlage? sonst FEHLER
    d) Gestaltung  Fuehrt die Vorlage eigene Farbwerte oder
                   eine eigene font-Angabe?                 dann  FEHLER

WAS (c) NICHT LEISTET -- und das ist wichtig
    Es beweist, dass die Vorlage ihren Kasten ZITIERT, nicht dass sie ihm
    FOLGT. Der Unterschied ist gemessen: en02, en03 und en04 weichen
    inhaltlich ab (Blatt 94 Abschn. 4), und keine dieser Abweichungen faende
    dieses Werkzeug. Wer mehr will, braucht einen Prueffall beim blinden
    Pruef-Agenten -- nicht ein schaerferes grep hier.

    Ein Riegel, der zu viel verspricht, ist schlimmer als keiner.

WARUM (d) HEUTE GRUEN IST
    Weil keine Vorlage Farbwerte fuehrt -- es gibt schlicht keine
    Gestaltung. Sobald app/statisch/token.css vorliegt (Blatt 94, Punkt 2),
    kehrt sich der Sinn um: dann darf keine Vorlage mehr eigene fuehren, und
    dieser Riegel haelt die Gestaltung an EINER Stelle statt ueber acht
    Dateien verteilt.

GESPERRT IST KEIN FEHLSCHLAG (Blatt 64, K23-M22)
    Fehlt der Kasten in der Referenz -- wie heute bei EN-03a und EN-04a --,
    kann diese Vorlage nicht gemessen werden. Das meldet der Riegel als
    GESPERRT und laeuft weiter. Nicht gemessen ist nicht bestanden, aber
    auch nicht gescheitert.

    Ein Lauf OHNE eine einzige bestandene Vorlage gilt als Fehlschlag: dann
    hat der Riegel nichts gemessen und darf nicht gruen melden.
"""
import re
import sys
from pathlib import Path

WURZEL = Path(__file__).resolve().parent.parent
REFERENZ = WURZEL / "schema" / "K19_build_referenz.md"
VORLAGEN = WURZEL / "app" / "vorlagen"

# Der Marker steht im Jinja-Kommentar am Kopf der Vorlage.
MARKER = re.compile(r"bildschirm:\s*(?P<wert>keiner|[A-Z]{2}-[0-9]+[a-z]?)"
                    r"(?P<rest>[^\n]*)")

# (d) Eigene Gestaltung. Der Farbwert muss ein VOLLSTAENDIGES Wort sein,
# sonst faengt die Regel jede Ankermarke "#abschnitt" mit sechs Buchstaben.
FARBWERT = re.compile(r"#(?:[0-9a-fA-F]{3}|[0-9a-fA-F]{6})\b")
SCHRIFT = re.compile(r"\bfont(?:-family)?\s*:")

# Ausgenommen von (d), solange kein token.css besteht: die Grundangaben, die
# eine Seite ueberhaupt lesbar machen. Sie verschwinden mit Blatt 94 Punkt 2.
# Bis dahin waere ein Fehlschlag daran eine Meldung ueber den Plan, nicht
# ueber den Stand.
GESTALTUNG_AB = WURZEL / "app" / "statisch" / "token.css"


def zahl_im_vertrag():
    """Wie viele Bildschirme fuehrt die Maschinenquelle?

    Getrennt gezaehlt von den Kaesten, mit Absicht: Die beiden Zahlen sind
    heute verschieden (33 gegen 31), und genau diese Differenz ist der
    Befund. Faende sie hier zusammen statt, waere sie unsichtbar.
    Fehlt die Datei, wird nichts behauptet -- dann steht ein Fragezeichen.
    """
    quelle = WURZEL / "schema" / "K19_screens.yaml"
    if not quelle.exists():
        return "?"
    return sum(1 for z in quelle.read_text(encoding="utf-8").splitlines()
               if re.match(r"\s+- id:\s*[A-Z]{2}-[0-9]", z))


def kaesten_lesen(pfad):
    """Alle Kaesten der Referenz, nach Bildschirmkennung.

    Ein Kasten beginnt mit '╭─ <Kennung> ·' und endet mit '╰'. Die
    Kopfleiste ('╭─ Kopfleiste ...') traegt keine Kennung und wird
    uebergangen -- sie gehoert zu jedem Bildschirm, zu keinem allein.
    """
    kaesten, laufend, kennung = {}, None, None
    for zeile in pfad.read_text(encoding="utf-8").splitlines():
        if zeile.startswith("╭"):
            treffer = re.match(r"╭─\s+([A-Z]{2}-[0-9]+[a-z]?)\s", zeile)
            kennung = treffer.group(1) if treffer else None
            laufend = [zeile] if kennung else None
        elif laufend is not None:
            laufend.append(zeile)
            if zeile.startswith("╰"):
                kaesten[kennung] = laufend
                laufend, kennung = None, None
    return kaesten


def woertlich_enthalten(text, kasten):
    """Steht der Kasten woertlich in der Vorlage?

    Verglichen wird ohne fuehrende Leerzeichen: die Vorlage rueckt ihren
    Kasten ein, und eine Einrueckung ist keine Abweichung. Die Reihenfolge
    zaehlt -- die Zeilen muessen zusammenhaengend aufeinander folgen.
    """
    hay = [z.strip() for z in text.splitlines()]
    nadel = [z.strip() for z in kasten]
    n = len(nadel)
    return any(hay[i:i + n] == nadel for i in range(len(hay) - n + 1))


def pruefe(vorlage, kaesten, gestaltung_besteht):
    """Vier Pruefungen. Gibt (zustand, meldung) -- Zustand nach K23-M22."""
    text = vorlage.read_text(encoding="utf-8")
    name = vorlage.name

    # (a) Der Marker. Fail-closed: keine Angabe ist keine Erlaubnis.
    treffer = MARKER.search(text)
    if not treffer:
        return "fehlgeschlagen", (
            f"{name} traegt keinen Marker. Erwartet im Kopfkommentar: "
            f"'bildschirm: <Kennung>' oder 'bildschirm: keiner -- <Grund>' "
            f"(Blatt 70)")

    wert = treffer.group("wert")

    if wert == "keiner":
        if not treffer.group("rest").strip(" -\t"):
            return "fehlgeschlagen", (
                f"{name} sagt 'bildschirm: keiner' ohne Grund. Eine Vorlage "
                f"ohne K19-Bildschirm muss sagen, warum sie keiner ist")
        # (d) gilt auch fuer sie.
        return gestaltung_pruefen(name, text, gestaltung_besteht) or (
            "bestanden", f"{name} — kein K19-Bildschirm, Grund benannt")

    # (b) Fuehrt die Referenz einen Kasten dazu?
    if wert not in kaesten:
        return "gesperrt", (
            f"{name} nennt {wert}, aber K19_build_referenz.md fuehrt dazu "
            f"keinen Kasten. Nicht messbar (K23-M22). Der Kasten entsteht in "
            f"der Konzeptfabrik, nicht hier (Blatt 94, Punkt 1)")

    # (c) Steht er woertlich da?
    if not woertlich_enthalten(text, kaesten[wert]):
        return "fehlgeschlagen", (
            f"{name} nennt {wert}, gibt den Kasten aber nicht woertlich "
            f"wieder. Blatt 70: kein Bildschirm ohne seinen K19-Kasten")

    return gestaltung_pruefen(name, text, gestaltung_besteht) or (
        "bestanden", f"{name} — {wert}, Kasten woertlich")


def gestaltung_pruefen(name, text, gestaltung_besteht):
    """(d) Eigene Gestaltung in der Vorlage. None heisst: nichts gefunden."""
    if not gestaltung_besteht:
        return None  # Noch gibt es keine gemeinsame Quelle, gegen die es ginge.
    stil = "\n".join(re.findall(r"<style[^>]*>(.*?)</style>", text, re.DOTALL))
    farben = sorted(set(FARBWERT.findall(stil)))
    schrift = SCHRIFT.search(stil)
    if farben or schrift:
        was = []
        if farben:
            was.append("Farbwerte " + " ".join(farben[:6]))
        if schrift:
            was.append("eine eigene font-Angabe")
        return "fehlgeschlagen", (
            f"{name} fuehrt {' und '.join(was)}. Seit app/statisch/token.css "
            f"besteht, kommt die Gestaltung aus EINER Quelle (Blatt 78, "
            f"Blatt 94 Punkt 4d)")
    return None


def main():
    if not REFERENZ.exists():
        print(f"::error::{REFERENZ.name} fehlt — der Riegel misst nichts "
              f"(K23-M22)")
        return 1
    if not VORLAGEN.is_dir():
        print(f"::error::{VORLAGEN} fehlt — der Riegel misst nichts")
        return 1

    kaesten = kaesten_lesen(REFERENZ)
    gestaltung_besteht = GESTALTUNG_AB.exists()
    vorlagen = sorted(VORLAGEN.glob("*.html"))

    if not vorlagen:
        print("::error::keine Vorlage gefunden — der Riegel hat nichts "
              "gemessen")
        return 1

    ok = fehl = gesperrt = 0
    mit_kasten = kein_bildschirm = 0
    for v in vorlagen:
        zustand, meldung = pruefe(v, kaesten, gestaltung_besteht)
        if zustand == "bestanden":
            ok += 1
            if "kein K19-Bildschirm" in meldung:
                kein_bildschirm += 1
            else:
                mit_kasten += 1
            print(f"   {meldung}")
        elif zustand == "gesperrt":
            gesperrt += 1
            print(f"::warning::GESPERRT — {meldung}")
        else:
            fehl += 1
            print(f"::error::{meldung}")

    # Der Zaehler aus Blatt 94, Punkt 5.
    #
    # ER ZAEHLT DREI VERSCHIEDENE DINGE, und sie sind verschieden gross:
    #   im Vertrag   -- was K19_screens.yaml fuehrt (die Maschinenquelle)
    #   mit Kasten   -- was K19_build_referenz.md zeichnet
    #   gebaut       -- wozu eine Vorlage besteht
    # Am 18.08.2026: 33 · 31 · 5. Die Luecke zwischen 33 und 31 sind EN-03a
    # und EN-04a (Blatt 94, Punkt 1), die zwischen 31 und 5 ist der Umfang
    # der Scheiben M1 bis M4.
    #
    # Der erste Entwurf dieses Zaehlers meldete "7 Vorlagen tragen ihren
    # Kasten" und zaehlte die drei Seiten mit, die gar kein K19-Bildschirm
    # sind. Eine Zahl, die zu gut aussieht, ist schlimmer als keine.
    vertrag = zahl_im_vertrag()
    gebaut = sum(1 for v in vorlagen
                 if (m := MARKER.search(v.read_text(encoding="utf-8")))
                 and m.group("wert") != "keiner")
    print(f"\nBildschirme: {vertrag} im Vertrag · {len(kaesten)} mit Kasten "
          f"in der Referenz · {gebaut} gebaut · {mit_kasten} tragen ihren "
          f"Kasten")
    print(f"Riegel: {ok} bestanden (davon {kein_bildschirm} ohne "
          f"K19-Bildschirm) · {fehl} fehlgeschlagen · {gesperrt} gesperrt")

    if fehl:
        print(f"::error::UI-Riegel: {fehl} Vorlage(n) verletzen Blatt 70")
        return 1
    if ok == 0:
        print("::error::UI-Riegel: keine einzige Vorlage bestanden — "
              "der Riegel hat nichts gemessen (K23-M22)")
        return 1
    if gesperrt:
        print(f"::warning::UI-Riegel: {gesperrt} Vorlage(n) GESPERRT — "
              f"nicht gemessen, nicht bestanden")
    return 0


if __name__ == "__main__":
    sys.exit(main())
