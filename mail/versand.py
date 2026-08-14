#!/usr/bin/env python3
# umsetzt: K03-M05, K03-M15, K03-M25, K03-M26, K23-D09
"""FREIRAUM · B2 · Versandweg fuer Einladung und Anmeldecode.

    python3 mail/versand.py code   --an michael.veil@exmachinai.com
    python3 mail/versand.py einladung --an anna.muster@zaa.freiraum.top --link https://...

Der Versand ist die eine Stelle, an der eine Mail das Haus verlaesst. Deshalb
liegen hier drei Dinge zusammen, die sonst auseinanderdriften:

  1. Der Code entsteht hier und wird SOFORT als Streuwert hinterlegt
     (K03-M15: gespeichert wird nur der kryptografische Pruefwert). Der
     Klartext existiert nur in der Mail und in dieser Funktion.

  2. Jeder Versuch wird protokolliert -- auch der gescheiterte. Ohne
     Zustellnachweis ist eine fehlgeschlagene Einladung nicht von einer nicht
     gesendeten zu unterscheiden; das ist der ausdrueckliche Vorbehalt des
     Bauauftrags B2.

  3. Der Absender ist fest auf die Betreiber-Domaene gebunden. Ein anderer
     Absender wuerde an der SPF-Kette von freiraum.top scheitern -- sie endet
     auf -all und erlaubt ausschliesslich den Hausanbieter.

SEIT DEM 14.08.2026 RUFT DIE ANWENDUNG BEIDE FUNKTIONEN. `einladung()` seit dem
11.08. aus app/einladung_senden.py, `anmeldecode()` seit heute aus
app/einladung.py. Beide sind deshalb serverfaehig gebaut: sie beenden keinen
Prozess, sie melden mit einer Ausnahme, und keine von ihnen schreibt eine
Adresse auf die Ausgabe (K03-M26, K23-D09). Die Zeilen fuer den Betreiber
stehen in `main()`.

WAS HIER NICHT STEHT: die Anmeldung selbst. Diese Datei stellt den Code aus und
verschickt ihn; ob er stimmt, prueft die Anwendung.
"""
import argparse
import hashlib
import os
import re
import secrets
import smtplib
import sys
from email.message import EmailMessage

try:
    import psycopg
except ImportError:  # pragma: no cover
    print("psycopg fehlt: pip3 install 'psycopg[binary]'", file=sys.stderr)
    raise SystemExit(2)

# Frist und Laenge stehen in K03-M15 und sind nicht verhandelbar.
CODE_STELLEN = 6
CODE_FRIST_MINUTEN = 10

# ---------------------------------------------------------------------
# Wohin diese Datei schreibt und sendet, wird AUSDRUECKLICH gewaehlt.
#
# BEF-L2-1, gemessen am 10.08.2026: DSN und SMTP_HOST trugen Vorgabewerte auf
# localhost. Fehlte die Umgebung, schrieb der Versand in die oertliche
# Pruefdatenbank und schickte an einen oertlichen Mailfaenger -- und meldete
# ERFOLG. Ein Zustelltest haette damit den echten Weg nie beruehrt und trotzdem
# gruen gemeldet. Genau das ist die Messung, die B2/AH-11 verlangt.
#
# Regel: FREIRAUM_UMGEBUNG=lokal setzt die oertlichen Werte -- und sagt es.
#        Sonst sind FREIRAUM_SMTP_HOST und FREIRAUM_DSN Pflicht.
#        Ein stiller Rueckfall auf localhost gibt es nicht mehr.
# ---------------------------------------------------------------------
UMGEBUNG = os.environ.get("FREIRAUM_UMGEBUNG", "").strip().lower()
LOKAL = UMGEBUNG == "lokal"

ABSENDER = os.environ.get("FREIRAUM_ABSENDER", "noreply@freiraum.top")
SMTP_HOST = os.environ.get("FREIRAUM_SMTP_HOST") or ("localhost" if LOKAL else None)
SMTP_PORT = int(os.environ.get("FREIRAUM_SMTP_PORT") or (1025 if LOKAL else 587))
SMTP_USER = os.environ.get("FREIRAUM_SMTP_USER")
SMTP_PASS = os.environ.get("FREIRAUM_SMTP_PASS")
# Ausserhalb der oertlichen Umgebung ist TLS die Vorgabe. Anmeldedaten ueber
# eine ungesicherte Verbindung waeren das groessere Uebel als ein Fehlschlag.
SMTP_TLS = (os.environ.get("FREIRAUM_SMTP_TLS") or ("0" if LOKAL else "1")) == "1"
DSN = os.environ.get("FREIRAUM_DSN") or (
    "postgresql://postgres:pilot@localhost:55432/freiraum" if LOKAL else None
)


def _dsn_ohne_geheimnis(dsn):
    """Das Kennwort wird nie mitgedruckt -- auch nicht in einer Hinweiszeile
    (K23-D09: keine Zugangswerte in Log, Manifest oder Fehlerausgabe)."""
    return re.sub(r"://([^:/@]+):[^@]*@", r"://\1:***@", dsn or "")


def umgebung_pruefen():
    """Sagt vor dem ersten Schreibvorgang, wohin geschrieben und gesendet wird.

    Der Satz ist kein Schmuck: Er ist der Beleg, dass ein Zustelltest den
    echten Dienst beruehrt hat und nicht einen Fänger auf demselben Rechner."""
    fehlend = [n for n, w in (("FREIRAUM_SMTP_HOST", SMTP_HOST),
                              ("FREIRAUM_DSN", DSN)) if not w]
    if fehlend:
        raise SystemExit(
            "Nicht gesetzt: " + ", ".join(fehlend) + ".\n"
            "Entweder die Werte angeben, oder fuer die oertliche Pruefumgebung\n"
            "ausdruecklich FREIRAUM_UMGEBUNG=lokal setzen.\n"
            "Ein stiller Rueckfall auf localhost ist nicht vorgesehen (BEF-L2-1)."
        )
    print(
        "Umgebung: {} · SMTP {}:{} · TLS {} · Anmeldung {} · DB {}".format(
            "LOKAL (Pruefumgebung)" if LOKAL else "Dienst",
            SMTP_HOST, SMTP_PORT,
            "an" if SMTP_TLS else "aus",
            "ja" if SMTP_USER else "nein",
            _dsn_ohne_geheimnis(DSN),
        ),
        file=sys.stderr,
    )


def code_erzeugen():
    """Sechs Stellen aus einer kryptografischen Quelle. Fuehrende Null erlaubt --
    sie wegzulassen wuerde den Raum auf 900 000 verkleinern, ohne dass es jemand
    merkt."""
    return "".join(secrets.choice("0123456789") for _ in range(CODE_STELLEN))


def streuwert(code, pfeffer=""):
    return hashlib.sha256((pfeffer + code).encode("utf-8")).hexdigest()


def pfeffer():
    """Der Pfeffer aus der Umgebung -- Entscheidung D vom 10.08.2026.

    Befund BEF-B2-2: bis dahin wurde der Parameter oben nie belegt. Ein
    SHA-256 ueber sechs Ziffern ohne Pfeffer ist ueber alle 1 000 000
    Kandidaten in gemessenen 0,17 Sekunden zurueckgerechnet -- wer login_code
    lesen darf, kennt damit jeden Code.

    Nie in der Datenbank, nie im Bau, spaeter aus dem Schluesseltresor ueber
    die verwaltete Identitaet. Fehlt er, wird kein Code ausgestellt: ein
    Vorgabewert waere ein fest verdrahtetes Geheimnis (Befund BEF-L2-1), und
    ein hier anders gepfefferter Wert passt nachher zu keiner Anmeldung.

    GEAENDERT AM 14.08.2026 (Gegenpruefung, Fund B2): bis dahin SystemExit --
    die LETZTE solche Stelle im Serverpfad. Gerufen wird diese Funktion aus
    `anmeldecode()`, und der einzige Aufrufer dort, `_anmeldecode_senden()` in
    app/einladung.py, faengt VersandFehler und CodeNichtAusgestellt. SystemExit
    erbt von BaseException, kam an beiden vorbei und haette den Arbeiter
    mitgenommen -- wegen eines FEHLENDEN Umgebungswertes, also genau dann, wenn
    ohnehin kein Code entsteht.

    Die bisherige Begruendung ("am Terminal die einzige Diagnose") traegt
    nicht: `main()` setzt CodeNichtAusgestellt in SystemExit(str(f)) um, im
    selben Wortlaut, auf demselben Weg (K03-G01: sperren, und die Sperre dem
    Betreiber begruenden). Der Text unten ist deshalb UNVERAENDERT; allein die
    Klasse ist eine andere.

    CodeNichtAusgestellt steht weiter unten in dieser Datei. Der Name wird beim
    Aufruf aufgeloest und nicht beim Uebersetzen -- die Reihenfolge traegt.
    """
    wert = os.environ.get("FREIRAUM_CODE_PFEFFER")
    if not wert:
        raise CodeNichtAusgestellt(
            "FREIRAUM_CODE_PFEFFER ist nicht gesetzt. Ohne Pfeffer waere der "
            "abgelegte Pruefwert in Sekunden zurueckgerechnet (Entscheidung D "
            "vom 10.08.2026, Befund BEF-B2-2). Es wird kein Code ausgestellt.")
    return wert


def absender_domaene_falsch():
    """Der Grund, wenn der Absender nicht in der SPF-Domaene liegt -- sonst None.

    Die Bedingung steht seit dem 11.08.2026 hier und nicht mehr in
    `absender_pruefen()`: sie wird an zwei Stellen gebraucht, und zwei
    Kopien derselben Regel driften auseinander. Der Wortlaut ist unveraendert.
    """
    domaene = ABSENDER.rsplit("@", 1)[-1].lower()
    erlaubt = os.environ.get("FREIRAUM_ABSENDER_DOMAENE", "freiraum.top").lower()
    if domaene != erlaubt:
        return (
            f"Absender {ABSENDER} liegt nicht in {erlaubt}. Die SPF-Kette von {erlaubt} endet auf -all; "
            "eine Mail von einer anderen Domaene wird beim Empfaenger abgewiesen.")
    return None


def absender_pruefen():
    """Der Absender muss in der Domaene liegen, fuer die die SPF-Kette gilt.
    Sonst geht die Mail raus und kommt nie an -- der unangenehmste Fehler,
    weil er wie ein Erfolg aussieht."""
    grund = absender_domaene_falsch()
    if grund:
        raise SystemExit(grund)


def versandweg_fehlt():
    """Was fehlt, damit eine Mail ueberhaupt hinausgehen kann -- als LISTE.

    Dieselben Bedingungen wie `umgebung_pruefen()` und `absender_pruefen()`,
    nur ohne SystemExit. Der Grund fuer die zweite Ausdrucksform: SystemExit
    erbt von BaseException. Ein Kommandozeilenwerkzeug darf sich damit
    beenden; in einem Serverpfad faengt es niemand ab, und der Arbeiter geht
    mit. Ein Server muss antworten, nicht sterben.

    FREIRAUM_DSN steht bewusst NICHT darin: eine aufrufende Anwendung bringt
    ihre eigene Verbindung mit (app/datenbank.py, eigener Pflichtwert).
    Geprueft wird hier allein der Weg der Mail.

    Ohne diese Pruefung faellt smtplib still auf den eigenen Rechner
    zurueck: SMTP_HOST ist dann None, und smtplib.SMTP(None, 587) verbindet
    sich mit localhost. Genau der stille Rueckfall, den BEF-L2-1 am
    10.08.2026 verboten hat -- hier nur eine Ebene tiefer, in der
    Standardbibliothek.
    """
    gruende = []
    if not SMTP_HOST:
        gruende.append(
            "FREIRAUM_SMTP_HOST ist nicht gesetzt und FREIRAUM_UMGEBUNG ist nicht "
            "'lokal'. Ein stiller Rueckfall auf localhost ist nicht vorgesehen "
            "(BEF-L2-1).")
    grund = absender_domaene_falsch()
    if grund:
        gruende.append(grund)
    return gruende


def nachweis(conn, actor_id, art, empfaenger, status, note=None, provider_id=None):
    with conn.cursor() as cur:
        cur.execute(
            "INSERT INTO mail_delivery (actor_id, kind, recipient, sender, status,"
            " provider_id, provider_note) VALUES (%s,%s,%s,%s,%s,%s,%s)",
            (actor_id, art, empfaenger, ABSENDER, status, provider_id, note))
    conn.commit()


# WOERTLICH, und ohne Auskunft. K03-M25 verlangt, dass eine Fehlermeldung
# nicht preisgibt, ob ein Konto besteht. Der Satz nennt deshalb weder die
# Adresse noch den Grund -- dieselbe Bauart wie MELDUNG_MISSERFOLG in
# app/anmeldung.py, und aus demselben Grund: eine zweite Fassung derselben
# Meldung ist der Anfang der Fallunterscheidung, und die Fallunterscheidung
# ist hier die Kontoauskunft.
MELDUNG_KEIN_CODE = "Es wurde kein Anmeldecode ausgestellt."


class CodeNichtAusgestellt(RuntimeError):
    """Es ist kein Anmeldecode entstanden -- und warum, sagt diese Ausnahme nicht.

    Eigene Klasse NEBEN VersandFehler, weil die beiden Faelle verschieden
    weiterzubehandeln sind: ein gescheiterter Versandweg ist ein Betriebsfehler
    und hinterlaesst eine Zeile in `mail_delivery`; ein nicht ausgestellter
    Code hat nie einen Versand versucht und hinterlaesst deshalb auch keinen
    Zustellnachweis.

    Wo es um ein KONTO geht, ist ihr Wortlaut MELDUNG_KEIN_CODE und traegt
    weder Adresse noch Grund (K03-M25, K23-D09).

    SEIT DEM 14.08.2026 gibt es einen zweiten Wortlaut: `pfeffer()` meldet mit
    derselben Klasse, dass FREIRAUM_CODE_PFEFFER fehlt (Fund B2). Das ist keine
    Kontoauskunft -- der Satz nennt einen Umgebungswert und sonst nichts, und
    er faellt fuer jedes Konto gleich. Die Regel dazu ist eng: der Wortlaut
    einer Ausnahme dieser Klasse geht NIE auf einen Nutzerbildschirm. Er geht
    auf das Terminal des Betreibers (`main()`) oder gar nirgendwo hin
    (app/einladung.py protokolliert einen eigenen Satz ohne str(f)).
    """


class VersandFehler(RuntimeError):
    """Der Versandweg selbst ist gescheitert -- Server abgelehnt, Verbindung weg,
    Anmeldung verweigert.

    Eigene Klasse, damit die aufrufenden Stellen sie ENG fangen koennen. Bis zum
    07.08.2026 stand dort `except Exception`; das fing auch einen Tippfehler im
    Code und schrieb ihn als Zustellnachweis mit Status FEHLER weg -- ein
    Programmierfehler haette wie ein stummer Mailserver ausgesehen.
    Befund BEF-C2 aus dem ersten Lauf des Coding-Harness."""


def senden(empfaenger, betreff, text):
    m = EmailMessage()
    m["From"] = ABSENDER
    m["To"] = empfaenger
    m["Subject"] = betreff
    m.set_content(text)
    with smtplib.SMTP(SMTP_HOST, SMTP_PORT, timeout=20) as s:
        if SMTP_TLS:
            s.starttls()
        if SMTP_USER:
            s.login(SMTP_USER, SMTP_PASS)
        antwort = s.send_message(m)
    # send_message liefert die Empfaenger, die NICHT angenommen wurden.
    if antwort:
        raise VersandFehler(f"Vom Server abgelehnt: {antwort}")


def konto_aufloesen(conn, adresse):
    """Die EINE Kontokennung zu einer Adresse -- oder gar keine.

    NEU AM 14.08.2026 (Gegenpruefung, Fund B1). Bis dahin loeste
    `anmeldecode()` die Adresse selbst auf, mit
    "lower(email)=lower(%s)" und fetchone(). Die Eindeutigkeit auf actor.email
    ist aber SCHREIBWEISENGENAU -- "CREATE UNIQUE INDEX actor_email_key ON
    actor (email)". Beides zusammen ergibt eine Mehrdeutigkeit: anna@pruef.test
    und Anna@pruef.test lassen sich nebeneinander anlegen (gemessen am
    10.08.2026), die Abfrage findet BEIDE, und fetchone() nimmt eine davon --
    welche, bestimmt die Zeilenreihenfolge, die PostgreSQL nicht zusichert.

    Die Auswirkung war hier groesser als bei der Anmeldung: der Ausloeser
    haette die offenen Codes eines FREMDEN Kontos entwertet, und die Anrede der
    Mail haette den Namen dieses fremden Kontos getragen -- an eine Adresse,
    die ihm nicht gehoert (K23-D09).

    Also dieselbe Bauart wie app/anmeldung.py:113-143: fetchall() und die harte
    Forderung "genau eine". Null Zeilen heisst unbekannt, zwei heissen
    mehrdeutig -- beides sperrt, mit demselben einen Wortlaut (K03-G01: was
    nicht pruefbar ist, sperrt; K03-M25: die Meldung sagt nicht, was der Fall
    war).

    Die Wurzel liegt im Schema und nicht hier: richtig waere ein eindeutiger
    Index ueber lower(email). Das ist eine Aenderung am gezeichneten Modell und
    gehoert in einen Migrationsnachtrag, nicht in diesen Pfad -- wortgleich der
    Vermerk in app/anmeldung.py.

    WER DIESE FUNKTION BRAUCHT: allein `main()`, also das Terminal. Der
    Serverpfad loest nicht ein zweites Mal auf; er reicht die Kennung durch,
    die er beim Freischalten ohnehin schon in der Hand hatte
    (app/einladung.py:_vollzug).
    """
    with conn.cursor() as cur:
        cur.execute("SELECT id FROM actor WHERE lower(email)=lower(%s) ORDER BY id",
                    (adresse,))
        zeilen = cur.fetchall()
    if len(zeilen) != 1:
        raise CodeNichtAusgestellt(MELDUNG_KEIN_CODE)
    return zeilen[0][0]


def anmeldecode(conn, actor_id, empfaenger):
    """Der Anmeldecode. Rueckgabe: der Ablaufzeitpunkt, wie die Datenbank ihn setzt.

    GEAENDERT AM 14.08.2026, als app/einladung.py diese Funktion in Betrieb
    nahm. Bis dahin rief sie allein `main()` auf -- ein Anmeldecode entstand
    nur, wenn ein Betreiber ihn von Hand am Terminal ausloeste. Drei Stellen
    waren fuer ein Kommandozeilenwerkzeug richtig und fuer einen Serverpfad
    falsch. Die ersten beiden sind dieselben, die `einladung()` am 11.08.2026
    umgebaut hat; die dritte gibt es dort nicht:

      1. BEIDE Fehlerfaelle loesten SystemExit aus. SystemExit erbt von
         BaseException; Starlette faengt es nicht, und der Arbeiter geht mit.
         Jetzt VersandFehler fuer den gescheiterten Versand und
         CodeNichtAusgestellt fuer den Fall ohne Konto. `main()` macht aus
         beiden wieder SystemExit.
      2. Die Erfolgszeile ging mit der Empfaengeradresse auf die Ausgabe. Am
         Terminal des Betreibers ist das seine eigene Eingabe; aus einem
         Serverprozess heraus waere es eine unmaskierte Personenangabe im
         Protokoll (K23-D09, K03-M26: "Codes und vollstaendige E-Mail-Adressen
         stehen nie in Logs"). Sie steht jetzt in `main()`. Diese Funktion gibt
         allein den Ablaufzeitpunkt zurueck -- er nennt niemanden.
      3. NEU GEGENUEBER einladung(): der Satz "Kein Konto zu <Adresse>" war
         eine Kontoauskunft. K03-M25 verlangt ausdruecklich, dass eine
         Fehlermeldung nicht preisgibt, ob ein Konto besteht -- und die Adresse
         stand obendrein darin. AUS DIESER FUNKTION ist beides weg; hier gilt
         der eine Wortlaut MELDUNG_KEIN_CODE.
         Am Terminal steht der Satz seit dem 14.08.2026 wieder, und zwar in
         `main()` (Gegenpruefung, Fund B5). Der Verzicht war zu weit gegriffen:
         K03-M25 schuetzt den NUTZER vor der Auskunft, und der Betreiber am
         Terminal hat die Adresse selbst eingetippt -- ihm sagt sie nichts, was
         er nicht schon weiss. K03-G01 verlangt umgekehrt, dass eine Sperre
         begruendet angezeigt wird. Der Serverpfad hat davon nichts: er sieht
         MELDUNG_KEIN_CODE, und dabei bleibt es.

    DIE KONTOKENNUNG KOMMT SEIT DEM 14.08.2026 VON AUSSEN (Gegenpruefung, Fund
    B1). Vorher stand hier eine zweite, eigene Aufloesung der Adresse -- und
    zwar eine mehrdeutige (die Begruendung steht bei `konto_aufloesen()`). Der
    Serverpfad hatte die Kennung laengst: app/einladung.py:_vollzug() hat sie
    aus der Zeile, die er soeben freigeschaltet hat, und warf sie bis dahin
    weg. Zweimal aufloesen heisst: zweimal etwas anderes treffen koennen. Jetzt
    wird durchgereicht, und `main()` loest genau einmal auf.

    Die Anrede kommt danach ueber die KENNUNG, nicht ueber die Adresse -- der
    Primaerschluessel trifft hoechstens eine Zeile. Die Adresse steht trotzdem
    mit in der Bedingung: sie ist der Empfaenger der Mail, und wenn sie nicht
    zu der Kennung gehoert, gehen Code und Anrede an einen Fremden. Passt
    beides nicht zusammen, entsteht kein Code (fail-closed, K03-G01).

    DER LETZTE SystemExit IST WEG (Fund B2): `pfeffer()` meldet seit dem
    14.08.2026 mit CodeNichtAusgestellt. Bis dahin beendete er den Prozess --
    im Serverpfad an `_anmeldecode_senden()` vorbei, weil SystemExit von
    BaseException erbt. Am Terminal aendert sich nichts: `main()` gibt den
    unveraenderten Wortlaut aus.

    Der Zustellnachweis bleibt, wo er war: auf BEIDEN Wegen. Ohne ihn ist ein
    fehlgeschlagener Versand nicht von einem nicht erfolgten zu unterscheiden
    (Bauauftrag B2). Wo gar kein Versand versucht wurde -- kein Konto --, steht
    auch keine Zeile: was nicht geschehen ist, wird nicht behauptet.
    """
    # Ueber die Kennung, und die Adresse muss zu ihr gehoeren. Der
    # Primaerschluessel ist eindeutig -- fetchone() ist hier kein Griff ins
    # Ungewisse mehr, sondern trifft hoechstens eine Zeile.
    with conn.cursor() as cur:
        cur.execute("SELECT display_name FROM actor"
                    " WHERE id=%s AND lower(email)=lower(%s)",
                    (actor_id, empfaenger))
        zeile = cur.fetchone()
    if not zeile:
        raise CodeNichtAusgestellt(MELDUNG_KEIN_CODE)
    name = zeile[0]

    code = code_erzeugen()

    # Erst hinterlegen, dann senden. Andersherum gaebe es einen Code in der Welt,
    # den die Datenbank nicht kennt. Der Ausloeser entwertet dabei aeltere Codes.
    # Die Frist setzt die DATENBANK -- der Aufrufer kann sie nicht verlaengern.
    with conn.cursor() as cur:
        cur.execute(
            "INSERT INTO login_code (actor_id, code_hash) VALUES (%s,%s)"
            " RETURNING expires_at",
            (actor_id, streuwert(code, pfeffer())))
        ablauf = cur.fetchone()[0]
    conn.commit()

    text = (f"Guten Tag {name},\n\n"
            f"Ihr Anmeldecode lautet: {code}\n\n"
            f"Er ist {CODE_FRIST_MINUTEN} Minuten gueltig und genau einmal verwendbar.\n"
            "Fordern Sie einen neuen an, verliert dieser sofort seine Gueltigkeit.\n\n"
            "Wenn Sie sich nicht angemeldet haben, ignorieren Sie diese Nachricht.\n\n"
            "FREIRAUM\n")
    # ValueError und UnicodeError stehen seit dem 14.08.2026 mit im Tupel
    # (Gegenpruefung, Fund B7). Nicht als Bequemlichkeit, sondern gemessen an
    # `senden()`: EmailMessage weist einen To-Header mit CR oder LF mit einem
    # ValueError ab (Zeile 249, Kopfzeileneinschleusung), und ein Empfaenger,
    # den der Server nicht kodieren kann, endet in einem UnicodeError. Beide
    # kamen an diesem Zweig vorbei -- und damit an der FEHLER-Zeile in
    # mail_delivery UND an der Entwertung des soeben ausgestellten Codes.
    # Zurueck blieb ein gueltiger Code, den niemand bekommen hat, und kein
    # Zustellnachweis: genau der Zustand, den Bauauftrag B2 ausschliesst.
    #
    # ZWEI BENANNTE KLASSEN, kein "except Exception". Ein Tippfehler in diesem
    # Modul soll weiter als Programmierfehler herausfallen und nicht als
    # stummer Mailserver im Nachweis stehen (Befund BEF-C2 vom 07.08.2026).
    try:
        senden(empfaenger, "Ihr FREIRAUM-Anmeldecode", text)
    except (VersandFehler, smtplib.SMTPException, OSError,
            ValueError, UnicodeError) as f:
        nachweis(conn, actor_id, "ANMELDECODE", empfaenger, "FEHLER", str(f)[:500])
        # Der Code bleibt entwertet zurueck: er wurde nie zugestellt.
        with conn.cursor() as cur:
            cur.execute("UPDATE login_code SET superseded_at=now() WHERE actor_id=%s"
                        " AND consumed_at IS NULL AND superseded_at IS NULL", (actor_id,))
        conn.commit()
        raise VersandFehler(f"Versand gescheitert, im Nachweis vermerkt: {f}") from f
    nachweis(conn, actor_id, "ANMELDECODE", empfaenger, "UEBERGEBEN",
             provider_id=f"{SMTP_HOST}:{SMTP_PORT}")
    return ablauf


def einladung(conn, empfaenger, link):
    """Die Einladungsmail. Rueckgabe: die Kennung des benutzten Versandwegs.

    GEAENDERT AM 11.08.2026, als app/einladung_senden.py diese Funktion in
    Betrieb nahm. Zwei Stellen waren fuer ein Kommandozeilenwerkzeug richtig
    und fuer einen Serverpfad falsch:

      1. Der Fehlschlag loeste SystemExit aus. SystemExit erbt von
         BaseException; Starlette faengt es nicht, und der Arbeiter geht mit.
         Jetzt VersandFehler -- die Klasse, die es dafuer seit dem
         07.08.2026 gibt (Befund BEF-C2). `main()` macht daraus wieder
         SystemExit, die Ausgabe der Kommandozeile ist unveraendert.
      2. Die Erfolgszeile ging mit der Empfaengeradresse auf die Ausgabe.
         Am Terminal des Betreibers ist das seine eigene Eingabe; aus einem
         Serverprozess heraus waere es eine unmaskierte Personenangabe im
         Protokoll (K23-D09). Sie steht jetzt in `main()`.

    Der Zustellnachweis bleibt, wo er war: auf BEIDEN Wegen. Ohne ihn ist
    eine fehlgeschlagene Einladung nicht von einer nicht gesendeten zu
    unterscheiden (Bauauftrag B2).
    """
    with conn.cursor() as cur:
        cur.execute("SELECT id, display_name FROM actor WHERE lower(email)=lower(%s)",
                    (empfaenger,))
        zeile = cur.fetchone()
    actor_id = zeile[0] if zeile else None
    name = zeile[1] if zeile else empfaenger

    text = (f"Guten Tag {name},\n\n"
            "Sie wurden zu FREIRAUM eingeladen. Ueber diesen Link legen Sie Ihren "
            f"Zugang an:\n\n{link}\n\n"
            "Der Link ist einmalig. Ein neuer Link entwertet diesen.\n\n"
            "FREIRAUM\n")
    weg = f"{SMTP_HOST}:{SMTP_PORT}"
    try:
        senden(empfaenger, "Ihre Einladung zu FREIRAUM", text)
    except (VersandFehler, smtplib.SMTPException, OSError) as f:
        nachweis(conn, actor_id, "EINLADUNG", empfaenger, "FEHLER", str(f)[:500])
        raise VersandFehler(f"Versand gescheitert, im Nachweis vermerkt: {f}") from f
    nachweis(conn, actor_id, "EINLADUNG", empfaenger, "UEBERGEBEN",
             provider_id=weg)
    return weg


def main():
    ap = argparse.ArgumentParser()
    ap.add_argument("art", choices=["code", "einladung"])
    ap.add_argument("--an", required=True)
    ap.add_argument("--link", default="https://freiraum.top/einladung/…")
    a = ap.parse_args()

    umgebung_pruefen()
    absender_pruefen()
    with psycopg.connect(DSN) as conn:
        if a.art == "code":
            # Dieselbe Aufteilung wie bei der Einladung: die Ausgabe steht
            # hier und nicht in anmeldecode(). Am Terminal ist die Adresse die
            # eigene Eingabe des Betreibers, im Serverprotokoll waere sie eine
            # unmaskierte Personenangabe (K23-D09, K03-M26).
            #
            # DIE BETREIBERDIAGNOSE STEHT SEIT DEM 14.08.2026 WIEDER HIER
            # (Gegenpruefung, Fund B5). Am 14.08. war sie mit dem Umbau auf den
            # Serverpfad ersatzlos entfallen; der Betreiber sah am Terminal
            # denselben nichtssagenden Satz wie der Nutzer im Browser und
            # konnte nicht mehr unterscheiden, ob die Adresse falsch war oder
            # der Versand scheiterte. K03-M25 verbietet die Auskunft dem
            # NUTZER; der Betreiber hat die Adresse selbst eingetippt, ihm
            # sagt sie nichts, was er nicht schon weiss. K03-G01 verlangt
            # umgekehrt, dass eine Sperre begruendet ANGEZEIGT wird.
            #
            # Deshalb die Aufteilung in zwei Zweige: die Aufloesung des Kontos
            # steht fuer sich, und nur SIE traegt die Diagnose. Alles, was
            # danach kommt -- fehlender Pfeffer, gescheiterter Versand --,
            # behaelt seinen eigenen Wortlaut. Ein Zweig ueber beides haette
            # die Meldung aus `pfeffer()` verschluckt und dem Betreiber ein
            # fehlendes Konto gemeldet, wo ein Umgebungswert fehlt.
            #
            # OFFEN, benannt und nicht entschieden: `konto_aufloesen()` sperrt
            # auch bei ZWEI Konten, die sich nur in der Schreibweise
            # unterscheiden. Am Terminal erscheint dafuer derselbe Satz wie
            # fuer "kein Konto". Ob der mehrdeutige Fall dem Betreiber einen
            # eigenen Wortlaut wert ist, entscheidet ein Mensch -- es waere
            # eine zweite Meldung, und die wird hier nicht erfunden.
            try:
                actor_id = konto_aufloesen(conn, a.an)
            except CodeNichtAusgestellt as f:
                raise SystemExit(f"Kein Konto zu {a.an}. Ein Code fuer ein unbekanntes Konto "
                                 "wird nicht ausgestellt.") from f
            try:
                ablauf = anmeldecode(conn, actor_id, a.an)
            except (CodeNichtAusgestellt, VersandFehler) as f:
                raise SystemExit(str(f)) from f
            print(f"Code an {a.an} uebergeben, gueltig bis {ablauf.isoformat()}")
        else:
            # Die Ausgabe steht hier und nicht in einladung(): am Terminal
            # ist die Adresse die eigene Eingabe des Betreibers, im
            # Serverprotokoll waere sie eine unmaskierte Personenangabe
            # (K23-D09).
            try:
                einladung(conn, a.an, a.link)
            except VersandFehler as f:
                raise SystemExit(str(f)) from f
            print(f"Einladung an {a.an} uebergeben")
    return 0


if __name__ == "__main__":
    sys.exit(main())
