#!/usr/bin/env python3
"""FREIRAUM Coding-Harness · Fundstellenprobe fuer die Steuerungstexte.

    python3 werkzeuge/fundstellen.py [--konzepte <ordner>] [--alle]
                                     [--datei <pfad> ...]

Warum es diese Datei gibt
-------------------------
Am 16.08.2026 hat eine Pruefung die Steuerungstexte dieses Harness gegen die
Wirklichkeit gehalten. Von 47 Meldungen hielten 27 stand, und das Muster war
scharf:

    Behauptungen ueber Code werden gemessen, Behauptungen ueber Dokumente nie.

Tor 1 rechnet das Klauselregister nach und den Herkunftsgraphen -- aber keine
einzige Fundstelle. Wenn CLAUDE.md schreibt, in `README.md`:31 stehe die Regel
"nach F36 wird nichts geloescht", dann hat das bis heute niemand nachgeschlagen.
Der README ist am 14.08.2026 von 84 auf 265 Zeilen umgeschrieben worden; an
Zeile 31 steht seither etwas anderes. Der Steuerungstext zeigt ins Leere, und
kein Lauf hat es gemerkt.

Dieses Werkzeug ist die dritte Anwendung eines Gedankens, den dieses Projekt
schon zweimal gebaut hat:

    install.sh --pruefsumme   misst die Verfassung gegen die Anlage.
    werkzeuge/herkunft.py     rechnet den Graphen neu und vergleicht.
    dieses Werkzeug           schlaegt jede Datei:Zeile-Behauptung nach.

Eine Behauptung ueber eine Datei ist nachrechenbar wie eine Pruefsumme.

Und es SPERRT. Nicht `::warning::`. Der Herkunftsgraph auf der Hauptspur ist
der Beleg im eigenen Haus, dass eine Warnung in diesem Projekt nichts bewirkt:
seine Aktualitaetspruefung meldet seit jeher nur eine Warnung -- und der
eingecheckte Graph ist nachweislich veraltet.

Was gemessen wird -- drei Fragen je Fundstelle
-----------------------------------------------
1. EXISTENZ    Gibt es die genannte Datei ueberhaupt?
2. LAENGE      Hat sie so viele Zeilen?
3. ANKER       Steht in der genannten Zeile (oder im genannten Bereich) noch
               das, worauf der Steuerungstext zeigt?

Der Anker ist keine Erfindung dieses Werkzeugs, sondern die Schreibweise des
Hauses: neben der Fundstelle steht fast immer das Zitat, entweder in
Anfuehrungszeichen -- *"Kompilierbarer Code kann fachlich falsch sein"*
(Blatt 26:51) -- oder fett hervorgehoben. Dieses Wort wird in der genannten
Zeile gesucht. Findet es sich dort nicht, wohl aber anderswo in derselben
Datei, meldet das Werkzeug die Zeile, in der es heute steht.

Was dieses Werkzeug NICHT tut
------------------------------
1. Es prueft nicht, ob die Aussage RICHTIG ist. Es prueft, ob sie noch dort
   steht, wo der Steuerungstext hinzeigt. Ein Verweis kann zeilengenau treffen
   und inhaltlich falsch sein.

2. Es rechnet keine Zeilennummer um. Wo ein Anker verrutscht ist, steht die
   heutige Zeile im Bericht -- als Angabe fuer den Menschen, nicht als
   Korrektur im Text. Kein Werkzeug schreibt in einen Steuerungstext.

3. Es raet nicht, welches Dokument gemeint ist. Wo die Aufloesung fehlt, steht
   `gesperrt`, nicht `bestanden`.

4. Es kennt keine Fundstelle ohne Dokumentnamen. Die Kurzform "(:649)", die
   das Dokument aus dem Satz davor erbt, wird nicht erkannt und nicht geraten
   -- sie steht unter "nicht ausgefuehrt".

Die vier Zustaende bleiben, wie sie sind
-----------------------------------------
K23-M22: bestanden - fehlgeschlagen - gesperrt - nicht ausgefuehrt. Dieses
Werkzeug erzeugt keinen fuenften und deutet keinen um.

    bestanden         Datei da, Zeile da, Anker sitzt.
    fehlgeschlagen    Datei fehlt, Zeile fehlt, oder der Anker sitzt nicht.
    gesperrt          Konnte nicht gemessen werden -- kein Anker im
                      Steuerungstext, oder das Dokument liegt ausserhalb
                      dieses Repos und der Konzeptordner ist nicht benannt.
    nicht ausgefuehrt Erkannte Schreibweise ohne Dokumentnamen.

`gesperrt` ist KEIN Fehlschlag und sperrt den Lauf nicht -- aber es steht in
der Zusammenfassung und wird gezaehlt. Nicht gemessen ist nicht bestanden.

Was sperrt und was nicht
-------------------------
Gemessen und gemeldet wird alles. Gesperrt wird nur an den ANWEISENDEN
Texten -- CLAUDE.md, .claude/, README, CONTRIBUTING, AGENTS, install.sh,
aufbau.sh, ruff.toml. Wer sie liest, handelt danach; eine Fundstelle, die ins
Leere zeigt, schickt den naechsten Bauenden an die falsche Stelle, heute.

Nachweise und Arbeitsstaende sind datiert. Ein Befund vom 07.08.2026
beschreibt einen Stand von damals. Dass die Datei seither umgeschrieben wurde,
macht ihn nicht falsch -- und ein Gate, das hier sperrte, zwaenge dazu,
Nachweise nachtraeglich umzuschreiben. Ihre Funde stehen im Bericht, unter
eigener Ueberschrift, und sperren nicht.

Rueckgabewert: 0 nur, wenn kein Fund in einem anweisenden Text. Sonst 1.
"""
import argparse
import os
import pathlib
import re
import sys

WURZEL = pathlib.Path(__file__).resolve().parent.parent

# ---------------------------------------------------------------------
# Wo gelesen wird
# ---------------------------------------------------------------------
# Bewusst EIN Wert und nicht ueber die Datei verstreut: wer einen Ort
# ergaenzt, ergaenzt ihn hier.
#
# Nicht dabei: app/, mail/, install/, migrations/, schema/, pruefungen/,
# werkzeuge/. Das ist das GEBAUTE, nicht die Anweisung. Ein Kommentar im
# Quelltext ist keine Steuerung.
#
# ZWEI GRUPPEN, und der Unterschied entscheidet ueber die Sperre:
ANWEISENDE_ORTE = (
    "CLAUDE.md",
    "README.md",
    "CONTRIBUTING.md",
    "AGENTS.md",
    "install.sh",
    "aufbau.sh",
    "ruff.toml",
    ".claude/**/*.md",
)
# Diese Texte WEISEN AN. Wer sie liest, handelt danach. Eine Fundstelle, die
# ins Leere zeigt, schickt den naechsten Bauenden an die falsche Stelle --
# heute, nicht damals. Sie SPERRT.

BERICHTENDE_ORTE = (
    "nachweise/**/*.md",
    "arbeit/**/*.md",
)
# Diese Texte BERICHTEN. Ein Befund vom 07.08.2026, ein Messbericht, ein
# Zeichnungsblatt: sie halten einen Stand von damals fest. Wenn eine Datei
# seither umgeschrieben oder geloescht wurde, ist der Bericht deshalb nicht
# falsch geworden -- er ist datiert. Ein Gate, das hier sperrt, zwaenge dazu,
# Nachweise nachtraeglich umzuschreiben. Genau das darf nicht passieren.
#
# Sie werden gemessen und gemeldet. Sie sperren NICHT.

LESEORTE = ANWEISENDE_ORTE + BERICHTENDE_ORTE

# ---------------------------------------------------------------------
# Was als Fundstelle gilt
# ---------------------------------------------------------------------
# Abgegriffen aus dem Bestand, nicht ausgedacht. So wird hier zitiert:
#
#   `README.md`:34                  Pfad in Ruecktichen, Zeile dahinter
#   `aufbau.sh`:11-14               Bereich mit Bindestrich
#   `arbeit/K23_entwurf.md`:297     Pfad mit Ordnern, auch mit Umlaut
#   app/haupt.py:382-403            ohne Ruecktiche (in den Nachweisen ueblich)
#   Blatt 26:51                     Aussendokument mit Nummer
#   Bauauftrag :80-86               Aussendokument, Leerzeichen vor dem Doppelpunkt
#   K23:75                          Konzeptdokument
#
# Der Gedankenstrich kommt in beiden Formen vor: "11-14" und "80–86". Ein
# Muster, das nur den Bindestrich kennt, liest den halben Bestand nicht.
ENDUNGEN = "py|sh|sql|md|ya?ml|toml|json|html|txt|cfg|ini|js|ts|css"
BIS = r"[-‐‑‒–—]"

# Der Doppelpunkt steht in der Dateiform IMMER ohne Leerzeichen: `README.md`:34.
# Das Leerzeichen unterscheidet die Behauptung von der Ausgabe eines Laufs --
# "ohne ruff.toml: 413 aktive Regeln" in nachweise/befunde/BEF-E_260814.md ist
# Messprotokoll, keine Fundstelle. Ohne diese Regel meldet das Werkzeug dort
# einen Fund, den es nicht gibt.
RE_DATEI = re.compile(
    r"(?<![\w/.\-`])`?"
    r"(?P<pfad>[^\s`|<>()\[\],;:]*?[\w)]\.(?:" + ENDUNGEN + r"))`?"
    r":(?P<von>\d{1,6})(?:\s*" + BIS + r"\s*(?P<bis>\d{1,6}))?"
    r"(?!\d)"
)

# Ein eingerueckter oder eingezaeunter Block ist Beispiel oder Protokoll, keine
# Anweisung. Was dort steht, wird nicht als Behauptung gelesen.
RE_ZAUN = re.compile(r"^\s*(```|~~~)")

# Dokumente ausserhalb dieses Repos. Der Name links, das Suchmuster im
# Konzeptordner rechts.
#
# Wo rechts None steht, ist die Aufloesung NICHT hinterlegt: dieses Repo
# fuehrt den Dateinamen des Bauauftrags und der Blaetter nirgends. Geraten
# wird er nicht -- solche Fundstellen melden `gesperrt`. Wer den Dateinamen
# kennt, traegt ihn hier ein; ab dann werden sie gemessen.
AUSSENDOKUMENTE = {
    "Bauauftrag": None,
    "Blatt": None,
    "BS": None,
    "BV": None,
}

# Konzeptdokumente heissen im Bestand durchgaengig so:
#   260801_FREIRAUM_K23_Test-und-Abnahmekonzept_v1.1.md
RE_KONZEPTNAME = re.compile(r"_FREIRAUM_(K\d{2})_")

RE_AUSSEN = re.compile(
    r"\b(?P<name>Blatt\s+\d{1,2}|Bauauftrag|BS|BV-\d{2}|K\d{2})"
    r"(?:\s*§\s*\d+)?\s*\(?\s*:\s*"
    r"(?P<von>\d{1,6})(?:\s*" + BIS + r"\s*(?P<bis>\d{1,6}))?"
    r"(?!\d)"
)

# Die Kurzform ohne Dokumentnamen: "(:649)", "und :29", ", :618".
# Sie erbt das Dokument aus dem Satz davor. Das ist nicht mechanisch
# aufloesbar, ohne zu raten -- deshalb wird sie GEZAEHLT und als
# "nicht ausgefuehrt" ausgewiesen, nicht stillschweigend uebergangen.
RE_KURZFORM = re.compile(r"(?<![\w\d)])\(?\s*:\s*(?P<von>\d{1,6})(?:\s*" + BIS +
                         r"\s*(?P<bis>\d{1,6}))?(?!\d)")

# ---------------------------------------------------------------------
# Was als Anker gilt
# ---------------------------------------------------------------------
# Nur ausgezeichneter Text: Anfuehrungszeichen oder Fettdruck. KEINE
# Ruecktiche -- die tragen fast immer den Dateinamen selbst oder eine
# Kennung, und ein Anker, der auf den eigenen Pfad zeigt, misst nichts.
#
# ZWEI STAERKEN, und der Unterschied entscheidet ueber die Sperre:
#
#   ZITAT          „...“ oder »...«. Wer in Anfuehrungszeichen setzt,
#                  behauptet den WORTLAUT. Steht er nicht da, ist das ein
#                  Fehlschlag -- eindeutig, ohne Ermessen.
#
#   HERVORHEBUNG   **...**. Fettdruck ist Betonung, nicht Zitat: er kann
#                  denselben Sachverhalt mit anderen Worten wiedergeben.
#                  „Die Nachweisliste (`M30…sql:321-331`) fuehrt **genau
#                  einen** Mandanten" umschreibt eine Spaltendefinition; die
#                  zwei Woerter stehen dort natuerlich nicht. Als Anker
#                  taugt eine Hervorhebung deshalb nur, wenn sie lang und
#                  eigen genug ist, um ein Zitat zu sein -- sonst meldet das
#                  Werkzeug `gesperrt`, nicht `fehlgeschlagen`.
#
#                  Und sie zaehlt NUR in den anweisenden Texten. Dort ist
#                  der Fettdruck die Regel im Wortlaut -- „**Keine
#                  Geheimnisse im Repo** (`README.md`:30)". In einem Bericht
#                  ist der Fettdruck der SCHLUSS des Verfassers: „**Der Fall
#                  ist im Datenmodell nicht darstellbar.**
#                  (`freiraum_datamodel.sql`:199-213)" -- dieser Satz steht
#                  in keiner DDL und soll dort auch nicht stehen. Gemessen
#                  am 16.08.2026: ohne diese Trennung meldete das Werkzeug
#                  in einem einzigen Entscheidungsvorblatt acht Funde, von
#                  denen sechs keine waren.
#
# Bewusst eng: dieser Schritt SPERRT. Ein Gate, das aus dem falschen Grund
# rot meldet, wird abgeschaltet -- und dann misst wieder niemand etwas.
# Wo der Anker fehlt oder zu schwach ist, steht `gesperrt`. Das ist die
# ehrliche Meldung und zugleich der Hinweis an den Schreibenden: setz ein
# Zitat neben die Fundstelle, dann wird sie gemessen.
RE_ANKER = re.compile(
    # Das schliessende Zeichen ist im Bestand mal „…“, mal „…" -- README.md:34
    # schreibt **„Antrag"**. Wer nur die typografische Form kennt, findet das
    # halbe Haus nicht.
    #
    # Kein Tabellenstrich im Anker: ein oeffnendes „ ohne schliessendes
    # Gegenstueck laeuft sonst ueber die halbe Tabellenzeile und zieht drei
    # fremde Zellen als „Zitat" herein.
    r"„(?P<a>[^“”\"|]{3,120})[“”\"]"     # „...“ und „..."
    r"|»(?P<b>[^«»|]{3,120})«"           # »...«
    r"|\*\*(?P<c>[^*|]{3,120})\*\*"      # **...**
)

# Trennzeichen, an denen ein Satz in Abschnitte zerfaellt. Der Anker muss im
# SELBEN Abschnitt stehen wie die Fundstelle -- sonst zieht das Werkzeug ein
# Zitat heran, das zu einer ganz anderen Behauptung gehoert.
RE_TRENNER = re.compile(r"[.;,|·—]|\s–\s")

MINDESTZITAT = 6           # kuerzere Zitate treffen zufaellig
MINDESTHERVORHEBUNG = 20   # Zeichen, damit Fettdruck als Anker taugt
MINDESTWORTE = 3           # Woerter, dieselbe Begruendung
DETAIL_JE_DATEI = 12       # so viele Funde je Datei im Klartext, dann gezaehlt

ZUSTAENDE = ("bestanden", "fehlgeschlagen", "gesperrt", "nicht ausgefuehrt")


# ---------------------------------------------------------------------
# Lesen
# ---------------------------------------------------------------------
def steuertexte(wurzel):
    """[(Pfad, anweisend)] -- doppelte Treffer entfernt, feste Reihenfolge."""
    gefunden = []
    gesehen = set()
    for orte, anweisend in ((ANWEISENDE_ORTE, True), (BERICHTENDE_ORTE, False)):
        for ort in orte:
            treffer = sorted(wurzel.glob(ort)) if "*" in ort else [wurzel / ort]
            for p in treffer:
                if p.is_file() and p not in gesehen:
                    gesehen.add(p)
                    gefunden.append((p, anweisend))
    return gefunden


_zeilen_puffer = {}


def zeilen(pfad):
    """Zeilen einer Datei, gepuffert. Nicht lesbar -> None."""
    schluessel = str(pfad)
    if schluessel not in _zeilen_puffer:
        try:
            _zeilen_puffer[schluessel] = pfad.read_text(
                encoding="utf-8", errors="replace").splitlines()
        except OSError:
            _zeilen_puffer[schluessel] = None
    return _zeilen_puffer[schluessel]


# ---------------------------------------------------------------------
# Anker
# ---------------------------------------------------------------------
def vereinfache(text):
    """Vergleichsform: ohne Auszeichnung, ohne Umbruch, klein geschrieben."""
    t = re.sub(r"\*\*|\*|`|„|“|”|«|»|\"", "", text)
    t = re.sub(BIS, "-", t)
    t = re.sub(r"\s+", " ", t)
    return t.strip().casefold()


def anker(zeilentext, anfang, ende, andere_spannen, anweisend):
    """(Ankertext, Staerke) fuer eine Fundstelle -- oder (None, Grund).

    Gesucht wird im Abschnitt um die Fundstelle: nach links bis zum letzten
    Trennzeichen vor ihr, nach rechts bis zum naechsten danach. Liegt eine
    ANDERE Fundstelle zwischen Zitat und Fundstelle, zaehlt das Zitat nicht --
    es gehoert dann zu jener anderen.

    Genommen wird die NAECHSTE Auszeichnung, nicht die passendste. Wer die
    zweitnaechste nimmt, weil die naechste nicht passt, sucht sich seinen
    Beleg zusammen.
    """
    # Erst die Auszeichnungen, dann die Abschnittsgrenzen. Und zwar in dieser
    # Reihenfolge: ein Zitat enthaelt fast immer selbst ein Komma oder einen
    # Punkt. Wer die Grenzen zuerst sucht, schneidet mitten durch das Zitat
    # und findet es danach nicht mehr -- gemessen am 16.08.2026: so meldete
    # das Werkzeug bei JEDER Fundstelle "kein Anker".
    roh = []
    for m in RE_ANKER.finditer(zeilentext):
        text = m.group("a") or m.group("b") or m.group("c")
        staerke = "hervorhebung" if m.group("c") else "zitat"
        # Ruecktichen-Inhalt allein ist kein Anker: **`README.md`** waere
        # ein Anker auf den eigenen Pfad.
        if not re.search(r"\w{3,}", re.sub(r"`[^`]*`", "", text)):
            continue
        roh.append((m.start(), m.end(), text, staerke))

    def im_anker(pos):
        return any(a <= pos < e for a, e, _, _ in roh)

    links = 0
    for m in RE_TRENNER.finditer(zeilentext, 0, anfang):
        if not im_anker(m.start()):
            links = m.end()
    rechts = len(zeilentext)
    for m in RE_TRENNER.finditer(zeilentext, ende):
        if not im_anker(m.start()):
            rechts = m.start()
            break

    kandidaten = []
    for a, e, text, staerke in roh:
        if a < links or e > rechts:
            continue
        abstand = anfang - e if e <= anfang else a - ende
        kandidaten.append((abstand, a, e, text, staerke))

    kandidaten.sort()
    for _abstand, a, e, text, staerke in kandidaten:
        von, bis = (e, anfang) if e <= anfang else (ende, a)
        if any(von <= s < bis or von < t <= bis for s, t in andere_spannen):
            continue
        schlicht = vereinfache(text)
        if staerke == "zitat":
            if len(schlicht) < MINDESTZITAT:
                return None, "das Zitat neben der Fundstelle ist zu kurz"
            return text, "zitat"
        if not anweisend:
            return None, ("kein Zitat neben der Fundstelle, nur Fettdruck -- "
                          "in einem Bericht ist Fettdruck der Schluss des "
                          "Verfassers, kein Wortlaut")
        if len(schlicht) < MINDESTHERVORHEBUNG or len(schlicht.split()) < MINDESTWORTE:
            return None, ("kein Zitat neben der Fundstelle, nur eine kurze "
                          "Hervorhebung -- zu wenig, um Wortlaut zu sein")
        return text, "hervorhebung"
    return None, ("kein Zitat und keine Hervorhebung neben der Fundstelle -- "
                  "worauf sie zeigt, ist nicht pruefbar")


# ---------------------------------------------------------------------
# Fundstellen einsammeln
# ---------------------------------------------------------------------
def fundstellen(quelle, wurzel, anweisend):
    """Alle Fundstellen einer Datei, Zeile fuer Zeile."""
    inhalt = zeilen(quelle)
    if inhalt is None:
        return []
    try:
        rel = quelle.relative_to(wurzel).as_posix()
    except ValueError:
        rel = str(quelle)   # mit --datei kann ein Text ausserhalb liegen
    gefunden = []
    im_zaun = False
    for nr, zeilentext in enumerate(inhalt, 1):
        if RE_ZAUN.match(zeilentext):
            im_zaun = not im_zaun
            continue
        if im_zaun:
            continue
        roh = []
        for m in RE_DATEI.finditer(zeilentext):
            roh.append(("datei", m, m.group("pfad")))
        for m in RE_AUSSEN.finditer(zeilentext):
            roh.append(("aussen", m, re.sub(r"\s+", " ", m.group("name"))))
        # Ueberlappungen: "K23_entwurf.md`:297" darf nicht zusaetzlich als
        # Aussendokument "K23" gelesen werden.
        roh.sort(key=lambda x: (x[1].start(), -(x[1].end() - x[1].start())))
        behalten = []
        for art, m, name in roh:
            if any(m.start() < b[1].end() and b[1].start() < m.end()
                   for b in behalten):
                continue
            behalten.append((art, m, name))

        spannen = [(m.start(), m.end()) for _, m, _ in behalten]
        for art, m, name in behalten:
            andere = [s for s in spannen if s != (m.start(), m.end())]
            von = int(m.group("von"))
            bis = int(m.group("bis")) if m.group("bis") else von
            text, staerke = anker(zeilentext, m.start(), m.end(), andere,
                                  anweisend)
            gefunden.append({
                "quelle": rel,
                "anweisend": anweisend,
                "quellzeile": nr,
                "zitat": zeilentext[m.start():m.end()].strip().lstrip("(").strip(),
                "art": art,
                "ziel": name,
                "von": von,
                "bis": bis,
                "anker": text,
                "ankerart": staerke if text else None,
                "ankergrund": None if text else staerke,
            })

        # Kurzformen ohne Dokumentnamen -- nur zaehlen.
        for m in RE_KURZFORM.finditer(zeilentext):
            if any(s <= m.start() < t or s < m.end() <= t for s, t in spannen):
                continue
            gefunden.append({
                "quelle": rel,
                "anweisend": anweisend,
                "quellzeile": nr,
                "zitat": zeilentext[max(0, m.start() - 24):m.end()].strip(),
                "art": "kurzform",
                "ziel": None,
                "von": int(m.group("von")),
                "bis": int(m.group("bis")) if m.group("bis") else int(m.group("von")),
                "anker": None,
                "ankerart": None,
                "ankergrund": None,
            })
    return gefunden


# ---------------------------------------------------------------------
# Aufloesen: welche Datei ist gemeint?
# ---------------------------------------------------------------------
# Ordner, die nichts Zitierbares enthalten.
NICHT_DURCHSUCHEN = {".git", ".venv", ".ruff_cache", "__pycache__", "node_modules"}

_namensregister = {}


def namensregister(wurzel):
    """Dateiname -> Pfade im Repo. Fuer die Kurzschreibweise ohne Ordner.

    Die Steuerungstexte nennen einen Pfad oft nur beim Namen, nachdem er
    einmal vollstaendig dastand: `M30__pilot_sammelmigration.sql`:627-634.
    Das ist keine falsche Fundstelle, sondern eine kurze -- solange der Name
    im Repo eindeutig ist. Ist er es nicht, wird nicht geraten.
    """
    if not _namensregister:
        for p in wurzel.rglob("*"):
            if not p.is_file():
                continue
            if NICHT_DURCHSUCHEN & set(p.relative_to(wurzel).parts):
                continue
            _namensregister.setdefault(p.name, []).append(p)
    return _namensregister


def im_konzeptordner(konzepte, muster):
    """Eindeutiger Treffer im Konzeptordner -- oder (None, Grund)."""
    treffer = sorted(p for p in konzepte.rglob(muster) if p.is_file())
    if len(treffer) == 1:
        return treffer[0], None
    if not treffer:
        return None, f"im Konzeptordner nicht gefunden (Muster {muster})"
    namen = " · ".join(p.name for p in treffer[:4])
    return None, f"im Konzeptordner mehrdeutig ({len(treffer)} Treffer: {namen})"


def aufloesen(f, wurzel, konzepte):
    """(Pfad, Grund) -- Pfad None heisst: nicht aufloesbar, Grund sagt warum."""
    if f["art"] == "kurzform":
        return None, "Fundstelle ohne Dokumentnamen"

    if f["art"] == "aussen":
        name = f["ziel"]
        schluessel = name.split()[0].split("-")[0]
        if re.fullmatch(r"K\d{2}", name):
            if konzepte is None:
                return None, "Konzeptdokument; FREIRAUM_KONZEPTE nicht gesetzt"
            return im_konzeptordner(konzepte, f"*_FREIRAUM_{name}_*.md")
        if AUSSENDOKUMENTE.get(schluessel, "fehlt") is None:
            return None, (f"Dokument „{name}“ liegt ausserhalb dieses Repos; "
                          "seine Datei ist in AUSSENDOKUMENTE nicht hinterlegt")
        return None, f"unbekanntes Aussendokument „{name}“"

    pfad = f["ziel"]
    # Ein Konzeptdokument, das mit vollem Namen zitiert wird.
    if RE_KONZEPTNAME.search(pathlib.PurePosixPath(pfad).name):
        if konzepte is None:
            return None, "Konzeptdokument; FREIRAUM_KONZEPTE nicht gesetzt"
        return im_konzeptordner(konzepte, pathlib.PurePosixPath(pfad).name)

    im_repo = wurzel / pfad
    if im_repo.is_file():
        return im_repo, None

    # Kurzschreibweise: nur der Dateiname, ohne Ordner. Ist er im Repo
    # eindeutig, ist die Fundstelle gemeint -- und wird gemessen.
    name = pathlib.PurePosixPath(pfad).name
    if "/" not in pfad:
        treffer = namensregister(wurzel).get(name, [])
        if len(treffer) == 1:
            return treffer[0], None
        if len(treffer) > 1:
            wo = " · ".join(p.relative_to(wurzel).as_posix() for p in treffer[:4])
            return None, (f"Dateiname „{name}“ ist im Repo nicht eindeutig "
                          f"({len(treffer)} Treffer: {wo}) -- ohne Ordner nicht "
                          "aufloesbar")

    # Nicht da. Liegt der Ordner darueber im Repo, war das Repo gemeint --
    # dann fehlt die Datei wirklich. Sonst kann sie ausserhalb liegen.
    elternteil = (wurzel / pfad).parent
    if elternteil.is_dir():
        return None, "FEHLT"
    if konzepte is None:
        return None, ("nicht im Repo; ob sie ausserhalb liegt, ist ungemessen "
                      "(FREIRAUM_KONZEPTE nicht gesetzt)")
    aussen = konzepte / pfad
    if aussen.is_file():
        return aussen, None
    return im_konzeptordner(konzepte, pathlib.PurePosixPath(pfad).name)


# ---------------------------------------------------------------------
# Messen
# ---------------------------------------------------------------------
def pruefe(f, wurzel, konzepte):
    """Setzt "zustand" und "befund" auf der Fundstelle."""
    pfad, grund = aufloesen(f, wurzel, konzepte)

    if pfad is None:
        if grund == "FEHLT":
            f["zustand"] = "fehlgeschlagen"
            f["befund"] = f"Datei existiert nicht: {f['ziel']}"
        elif f["art"] == "kurzform":
            f["zustand"] = "nicht ausgefuehrt"
            f["befund"] = grund
        else:
            f["zustand"] = "gesperrt"
            f["befund"] = grund
        return f

    f["aufgeloest"] = str(pfad)
    inhalt = zeilen(pfad)
    if inhalt is None:
        f["zustand"] = "gesperrt"
        f["befund"] = "Datei nicht lesbar"
        return f

    if f["bis"] > len(inhalt):
        f["zustand"] = "fehlgeschlagen"
        f["befund"] = (f"Datei hat nur {len(inhalt)} Zeilen, "
                       f"die Fundstelle nennt Zeile {f['bis']}")
        return f

    if not f["anker"]:
        f["zustand"] = "gesperrt"
        f["befund"] = f["ankergrund"]
        return f

    gesucht = vereinfache(f["anker"])
    bereich = " ".join(vereinfache(z) for z in inhalt[f["von"] - 1:f["bis"]])
    if gesucht in bereich:
        f["zustand"] = "bestanden"
        f["befund"] = "Datei da, Zeile da, Anker sitzt"
        return f

    f["zustand"] = "fehlgeschlagen"
    heute = [n for n, z in enumerate(inhalt, 1) if gesucht in vereinfache(z)]
    stelle = f"Zeile {f['von']}" if f["von"] == f["bis"] \
        else f"Zeilen {f['von']}-{f['bis']}"
    steht = inhalt[f["von"] - 1].strip()
    f["befund"] = (f"in {stelle} steht der Anker nicht. "
                   f"Dort steht: „{kurz(steht)}“")
    if heute:
        wo = ", ".join(str(n) for n in heute[:3])
        f["befund"] += f" -- der Anker steht heute in Zeile {wo}"
    else:
        f["befund"] += " -- in der ganzen Datei steht er nicht mehr"
    return f


def kurz(text, breite=72):
    return text if len(text) <= breite else text[:breite - 1] + "…"


# ---------------------------------------------------------------------
# Bericht
# ---------------------------------------------------------------------
def bericht(alle, konzepte, zeige_bestandene):
    zeilen_aus = []
    z = zeilen_aus.append

    z("Fundstellenprobe der Steuerungstexte")
    z("=" * 72)
    z("")
    z("Geprueft wird, ob jede Datei:Zeile-Behauptung der Steuerungstexte noch")
    z("trifft: Datei da? Zeile da? Steht dort noch, worauf der Text zeigt?")
    z("")
    if konzepte is None:
        z("  Konzeptordner:  NICHT GESETZT -- FREIRAUM_KONZEPTE fehlt.")
        z("                  Jede Fundstelle ausserhalb dieses Repos meldet")
        z("                  deshalb GESPERRT, nicht bestanden.")
    else:
        z(f"  Konzeptordner:  {konzepte}")
    z("")

    fehler = [f for f in alle if f["zustand"] == "fehlgeschlagen"]

    def liste_der_funde(teilmenge):
        je_datei = {}
        for f in teilmenge:
            je_datei.setdefault(f["quelle"], []).append(f)
        for quelle in sorted(je_datei):
            eintraege = je_datei[quelle]
            z("")
            z(f"{quelle}  ({len(eintraege)})")
            for f in eintraege[:DETAIL_JE_DATEI]:
                z(f"  Zeile {f['quellzeile']}: {f['zitat']}")
                z(f"    {f['befund']}")
                if f.get("anker"):
                    z(f"    erwartet war: „{kurz(f['anker'])}“")
            if len(eintraege) > DETAIL_JE_DATEI:
                z(f"  … und {len(eintraege) - DETAIL_JE_DATEI} weitere "
                  "in dieser Datei")
        z("")

    sperrend = [f for f in fehler if f["anweisend"]]
    if sperrend:
        z("FUNDE IN DEN ANWEISENDEN TEXTEN -- diese sperren")
        z("-" * 72)
        z("Wer diese Zeilen liest, handelt danach und landet an der falschen")
        z("Stelle. Sie zeigen ins Leere -- heute, nicht damals.")
        liste_der_funde(sperrend)

    berichtend = [f for f in fehler if not f["anweisend"]]
    if berichtend:
        z("FUNDE IN NACHWEISEN UND ARBEITSSTAENDEN -- diese sperren NICHT")
        z("-" * 72)
        z("Diese Texte sind datiert. Ein Befund vom 07.08.2026 beschreibt einen")
        z("Stand von damals; dass die Datei seither umgeschrieben wurde, macht")
        z("ihn nicht falsch. Wer hier sperrte, zwaenge dazu, Nachweise")
        z("nachtraeglich umzuschreiben.")
        liste_der_funde(berichtend)

    gesperrt = [f for f in alle if f["zustand"] == "gesperrt"]
    if gesperrt:
        z("GESPERRT -- nicht gemessen, also nicht bestanden")
        z("-" * 72)
        je_grund = {}
        for f in gesperrt:
            je_grund.setdefault(f["befund"], []).append(f)
        for grund in sorted(je_grund, key=lambda g: -len(je_grund[g])):
            liste = je_grund[grund]
            z("")
            z(f"{len(liste)}x  {grund}")
            for f in liste[:3]:
                z(f"    {f['quelle']}:{f['quellzeile']}  {f['zitat']}")
            if len(liste) > 3:
                z(f"    … und {len(liste) - 3} weitere")
        z("")

    offen = [f for f in alle if f["zustand"] == "nicht ausgefuehrt"]
    if offen:
        z("NICHT AUSGEFUEHRT -- Schreibweise ohne Dokumentnamen")
        z("-" * 72)
        z("")
        z(f"{len(offen)} Fundstellen der Form „(:649)“. Sie erben das Dokument")
        z("aus dem Satz davor. Dieses Werkzeug raet es nicht.")
        for f in offen[:5]:
            z(f"    {f['quelle']}:{f['quellzeile']}  …{f['zitat']}")
        if len(offen) > 5:
            z(f"    … und {len(offen) - 5} weitere")
        z("")

    if zeige_bestandene:
        z("BESTANDEN")
        z("-" * 72)
        for f in alle:
            if f["zustand"] == "bestanden":
                z(f"  {f['quelle']}:{f['quellzeile']}  {f['zitat']}"
                  f"  — „{kurz(f['anker'], 40)}“")
        z("")

    zahl = {s: sum(1 for f in alle if f["zustand"] == s) for s in ZUSTAENDE}
    zahl["sperrend"] = len(sperrend)
    anw = [f for f in alle if f["anweisend"]]
    ber = [f for f in alle if not f["anweisend"]]
    z("Zusammenfassung")
    z("-" * 72)
    z(f"{'':<24}{'anweisend':>12}{'berichtend':>12}{'zusammen':>12}")
    z(f"{'  (sperrt)':<24}{'ja':>12}{'nein':>12}{'':>12}")
    z("")
    for s in ZUSTAENDE:
        name = s.upper() if s == "fehlgeschlagen" else s
        z(f"  {name:<22}"
          f"{sum(1 for f in anw if f['zustand'] == s):>12}"
          f"{sum(1 for f in ber if f['zustand'] == s):>12}"
          f"{zahl[s]:>12}")
    z(f"  {'zusammen':<22}{len(anw):>12}{len(ber):>12}{len(alle):>12}")
    z("")
    z("  gesperrt heisst: konnte nicht gemessen werden. Nicht gemessen ist")
    z("  nicht bestanden (K23-M22).")
    z("")
    if sperrend:
        z(f"::error::{len(sperrend)} Fundstellen der anweisenden Texte treffen "
          "nicht.")
        z("   Naechster Schritt: die oben genannten Zeilen aufschlagen und den")
        z("   Verweis berichtigen -- oder, wo der Anker nur verrutscht ist, die")
        z("   gemeldete Zeilennummer uebernehmen.")
    elif berichtend:
        z("Kein sperrender Fund. In Nachweisen und Arbeitsstaenden stehen")
        z(f"{len(berichtend)} veraltete Verweise -- zur Kenntnis, nicht zur Sperre.")
    else:
        z("Kein Fund. Jede gemessene Fundstelle trifft.")
    return "\n".join(zeilen_aus), zahl


def main():
    ap = argparse.ArgumentParser(
        description="Jede Datei:Zeile-Behauptung der Steuerungstexte nachschlagen")
    ap.add_argument("--konzepte", metavar="ORDNER",
                    default=os.environ.get("FREIRAUM_KONZEPTE") or None,
                    help="Ordner der Konzepte ausserhalb dieses Repos "
                         "(sonst FREIRAUM_KONZEPTE)")
    ap.add_argument("--datei", metavar="PFAD", action="append",
                    help="nur diese Steuerungstexte pruefen (mehrfach moeglich)")
    ap.add_argument("--alle", action="store_true",
                    help="auch die bestandenen Fundstellen auflisten")
    a = ap.parse_args()

    konzepte = pathlib.Path(a.konzepte).expanduser() if a.konzepte else None
    if konzepte is not None and not konzepte.is_dir():
        print(f"::error::Konzeptordner nicht gefunden: {konzepte}", file=sys.stderr)
        print("   Naechster Schritt: FREIRAUM_KONZEPTE auf den Ordner der "
              "gezeichneten Konzepte setzen -- oder den Schalter weglassen.",
              file=sys.stderr)
        return 2

    if a.datei:
        anweisend = set(steuertexte(WURZEL))
        quellen = []
        for p in a.datei:
            pfad = pathlib.Path(p).resolve()
            quellen.append((pfad, (pfad, False) not in anweisend))
    else:
        quellen = steuertexte(WURZEL)
    if not quellen:
        print("::error::Keine Steuerungstexte gefunden -- GESPERRT (K23-M22).",
              file=sys.stderr)
        return 2

    alle = []
    for q, ist_anweisend in quellen:
        for f in fundstellen(q, WURZEL, ist_anweisend):
            alle.append(pruefe(f, WURZEL, konzepte))

    text, zahl = bericht(alle, konzepte, a.alle)
    print(text)
    return 1 if zahl["sperrend"] else 0


if __name__ == "__main__":
    sys.exit(main())
