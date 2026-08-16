# umsetzt: K04-M21, K04-G12, K03-M13, K10-M34
#
# BAUAUFGABE L9 des Bauauftrags (Paragraf 7a), Teil "Hinweis im
# Endnutzer-Portal" -- der EINZIGE Teil von L9, den der Auftragnehmer
# schuldet. Vertragsbaustein (Vertrieb) und Einweisung (Geschaeftsfuehrung)
# stehen ausdruecklich AUSSERHALB der Tore.
#
# WARUM DIESE DATEI SEIT DEM 16.08.2026 EXISTIERT
# L9 lag bis dahin ausserhalb des Teilschnitts -- niemand wusste, ob der
# Hinweis "vor der ersten Nutzung" schon auf dem Anmeldeweg faellig wird.
# M. Veil hat das am 16.08.2026 entschieden: "Wer sich anmeldet, nutzt das
# Portal -- der KI-Hinweis ist dann faellig." Damit gehoert er in EN-01.
#
# DIE DREI ABNAHMEKRITERIEN AUS PARAGRAF 7a, L9 -- woertlich:
#   1 Der Hinweis erscheint VOR DER ERSTEN NUTZUNG, nicht in einer Fusszeile.
#   2 Er nennt: dass KI eingesetzt wird - dass der Kunde als Betreiber eigene
#     Pflichten nach Artikel 4 hat - wo er Naeheres findet.
#   3 Die Kenntnisnahme ist NACHWEISBAR -- "dieselbe Bauart wie bei der
#     Zweckbestimmung (K04-M21)".
#
# WAS DER HARNESS HIER NICHT ENTSCHIEDEN HAT: ob der Wortlaut rechtlich
# genuegt. Paragraf 7a verlangt fuer L9 -- anders als fuer L8 -- KEINE
# rechtliche Beratung. Gebaut ist gegen die drei Kriterien; die Abnahme
# zeichnet A. Han als Schuldner.
"""Der Portal-Hinweis nach Artikel 4 der KI-Verordnung (Bauaufgabe L9)."""

# ---------------------------------------------------------------------------
#  Der Wortlaut -- Kriterium 2, die drei geforderten Angaben
# ---------------------------------------------------------------------------
#
# Je Angabe eine Konstante, damit ein Prueffall sie EINZELN treffen kann.
# Ein einziger Textblock waere pruefbar nur als Ganzes -- dann misst der
# Prueffall "irgendein Text ist da", nicht "die drei Angaben stehen da".

# (a) dass KI eingesetzt wird
HINWEIS_EINSATZ = (
    "Dieses Portal setzt Kuenstliche Intelligenz ein. Antworten, Vorschlaege "
    "und erzeugte Unterlagen stammen ganz oder teilweise von einem KI-System "
    "und koennen Fehler enthalten.")

# (b) dass der Kunde als Betreiber eigene Pflichten nach Artikel 4 hat
HINWEIS_PFLICHT = (
    "Wenn Sie dieses Portal in Ihrem Unternehmen einsetzen, sind Sie "
    "Betreiber im Sinne der KI-Verordnung. Artikel 4 verpflichtet Sie dann "
    "selbst dazu, fuer ausreichende KI-Kompetenz der Personen zu sorgen, die "
    "in Ihrem Auftrag mit dem System arbeiten. Diese Pflicht trifft Sie, "
    "nicht uns -- wir koennen sie Ihnen nicht abnehmen.")

# (c) wo er Naeheres findet
#
# NICHT ERFUNDEN. K10-M34 bestimmt den Ort: "Das Paket MUSS die Angaben
# fuehren, die der Kunde braucht, um seine eigenen Pflichten aus der
# KI-Verordnung zu beurteilen". Eine Netzadresse steht hier bewusst nicht --
# das Repo fuehrt keine, und eine erfundene Adresse waere schlimmer als
# keine: sie sieht aus wie eine Auskunft.
HINWEIS_QUELLE = (
    "Naeheres steht im Uebergabe-Paket zu Ihrem Projekt -- dort sind die "
    "Angaben zusammengestellt, die Sie zur Beurteilung Ihrer eigenen "
    "Pflichten brauchen. Fragen dazu beantwortet Ihre Ansprechperson.")

HINWEIS = (HINWEIS_EINSATZ, HINWEIS_PFLICHT, HINWEIS_QUELLE)

# Der Text am Kaestchen. Er ist die Erklaerung, die spaeter im Nachweis
# steht -- deshalb sagt er, WAS bestaetigt wird, nicht nur "gelesen".
BESTAETIGUNG = ("Ich habe den Hinweis zum KI-Einsatz und zu meinen Pflichten "
                "nach Artikel 4 gelesen.")

# Eigene Meldung, ausdruecklich NICHT die aus K03-M16.
#
# WARUM EINE EIGENE: MELDUNG_MISSERFOLG ("Pruefen Sie Adresse und Code")
# waere hier gelogen -- an den Angaben liegt es nicht. Und sie ist unbedenklich:
# Ein fehlendes Haekchen sagt NICHTS ueber ein Konto aus, verraet also nicht,
# ob es die Adresse gibt. Dieselbe Ueberlegung wie bei MELDUNG_BETRIEB.
MELDUNG_HINWEIS_OFFEN = (
    "Bitte bestaetigen Sie zuerst den Hinweis zum KI-Einsatz. Ohne die "
    "Bestaetigung wird die Anmeldung nicht versucht -- Ihre Versuche werden "
    "dadurch nicht verbraucht.")

# Kennung des Ereignisses. Ein Prueffall sucht danach; sie steht deshalb
# hier und nicht als Zeichenkette mitten im Aufruf.
AKTION = "KI_HINWEIS_ART4_KENNTNIS"


def bestaetigt(wert):
    """Hat die Person das Kaestchen gesetzt?

    K03-M13: "eine Pruefung allein in der Oberflaeche gilt als nicht
    erfolgt". Das `required`-Merkmal im Markup fehlt deshalb bewusst -- ein
    Browser, der die leere Eingabe selbst abfaengt, verhindert nicht den
    Fehler, sondern die Messung, ob der Server ihn abfaengt. Dieselbe
    Ueberlegung steht schon am Anmeldeformular.

    Ein Kontrollkaestchen, das nicht gesetzt ist, sendet der Browser gar
    nicht mit. Der Vorgabewert im Formular ist deshalb "", nicht None.
    """
    return (wert or "").strip() != ""


def kenntnis_buchen(conn, stand):
    """Die Kenntnisnahme als bleibender Nachweis -- Kriterium 3.

    BAUART NACH K04-M21, wie Paragraf 7a es verlangt: "dieselbe Bauart wie
    bei der Zweckbestimmung". Dort traegt eine Spalte an `fit_check` den
    Zeitpunkt. Hier gibt es kein solches Bezugsobjekt -- der Hinweis haengt
    an der PERSON, nicht an einer Anwendung.

    Deshalb der gezeichnete Behelf K04-G12: "wird sie als Ereignis nach
    K02 Abschnitt 3 gefuehrt". Das Protokoll ist seit `M30` Stufe 10h
    append-only mit der Klasse EREIGNIS -- eine Zeile, die niemand mehr
    entfernen kann, ist genau das, was "nachweisbar" verlangt.

    KLASSE KI_NACHWEIS, nicht EREIGNIS. Begruendung wie bei der
    Zweckbestimmung: Das hier IST der KI-Nachweis, nicht ein Betriebsvorgang
    daneben. K10-M34 laesst ihn ins Uebergabe-Paket eingehen, und ein
    Nachweis mit zwei Aufbewahrungsfristen haette eine zu viel.

    NUR EINMAL JE PERSON. Paragraf 7a sagt "vor der ERSTEN Nutzung". Der
    Nachweis ist der erste Akt, nicht jeder spaetere. Die Bedingung im
    INSERT ist dieselbe Bauart wie `zweckbestimmung_ack_at IS NULL` bei der
    Zweckbestimmung: Wer zweimal bestaetigt, erzeugt keine zweite Zeile --
    und der Zeitpunkt der ERSTEN Kenntnisnahme bleibt erhalten, statt bei
    jeder Anmeldung ueberschrieben zu werden.

    Rueckgabe: True, wenn diese Zeile die erste war.
    """
    zeile = conn.execute(
        "INSERT INTO event (actor_id, actor_label, tenant_id, action,"
        "                   object_ref, change_type, value, source,"
        "                   retention_class)"
        " SELECT %s, %s, %s, %s, %s, 'KENNTNISNAHME', %s,"
        "        'PORTAL_ACTION', 'KI_NACHWEIS'"
        " WHERE NOT EXISTS (SELECT 1 FROM event"
        "                    WHERE actor_id = %s AND action = %s)"
        " RETURNING id",
        (stand["actor_id"], stand["anzeigename"], stand["mandant"], AKTION,
         "AKTOR:" + str(stand["actor_id"]), BESTAETIGUNG,
         stand["actor_id"], AKTION)).fetchone()
    return zeile is not None
