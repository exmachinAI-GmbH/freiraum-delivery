#!/usr/bin/env python3
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

WAS HIER NICHT STEHT: die Anmeldung selbst. Diese Datei stellt den Code aus und
verschickt ihn; ob er stimmt, prueft die Anwendung.
"""
import argparse
import hashlib
import os
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

ABSENDER = os.environ.get("FREIRAUM_ABSENDER", "noreply@freiraum.top")
SMTP_HOST = os.environ.get("FREIRAUM_SMTP_HOST", "localhost")
SMTP_PORT = int(os.environ.get("FREIRAUM_SMTP_PORT", "1025"))
SMTP_USER = os.environ.get("FREIRAUM_SMTP_USER")
SMTP_PASS = os.environ.get("FREIRAUM_SMTP_PASS")
SMTP_TLS = os.environ.get("FREIRAUM_SMTP_TLS", "0") == "1"
DSN = os.environ.get("FREIRAUM_DSN", "postgresql://postgres:pilot@localhost:55432/freiraum")


def code_erzeugen():
    """Sechs Stellen aus einer kryptografischen Quelle. Fuehrende Null erlaubt --
    sie wegzulassen wuerde den Raum auf 900 000 verkleinern, ohne dass es jemand
    merkt."""
    return "".join(secrets.choice("0123456789") for _ in range(CODE_STELLEN))


def streuwert(code, pfeffer=""):
    return hashlib.sha256((pfeffer + code).encode("utf-8")).hexdigest()


def absender_pruefen():
    """Der Absender muss in der Domaene liegen, fuer die die SPF-Kette gilt.
    Sonst geht die Mail raus und kommt nie an -- der unangenehmste Fehler,
    weil er wie ein Erfolg aussieht."""
    domaene = ABSENDER.rsplit("@", 1)[-1].lower()
    erlaubt = os.environ.get("FREIRAUM_ABSENDER_DOMAENE", "freiraum.top").lower()
    if domaene != erlaubt:
        raise SystemExit(
            f"Absender {ABSENDER} liegt nicht in {erlaubt}. Die SPF-Kette von {erlaubt} endet auf -all; "
            "eine Mail von einer anderen Domaene wird beim Empfaenger abgewiesen.")


def nachweis(conn, actor_id, art, empfaenger, status, note=None, provider_id=None):
    with conn.cursor() as cur:
        cur.execute(
            "INSERT INTO mail_delivery (actor_id, kind, recipient, sender, status,"
            " provider_id, provider_note) VALUES (%s,%s,%s,%s,%s,%s,%s)",
            (actor_id, art, empfaenger, ABSENDER, status, provider_id, note))
    conn.commit()


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


def anmeldecode(conn, empfaenger):
    with conn.cursor() as cur:
        cur.execute("SELECT id, display_name FROM actor WHERE lower(email)=lower(%s)",
                    (empfaenger,))
        zeile = cur.fetchone()
    if not zeile:
        raise SystemExit(f"Kein Konto zu {empfaenger}. Ein Code fuer ein unbekanntes Konto "
                         "wird nicht ausgestellt.")
    actor_id, name = zeile

    code = code_erzeugen()

    # Erst hinterlegen, dann senden. Andersherum gaebe es einen Code in der Welt,
    # den die Datenbank nicht kennt. Der Ausloeser entwertet dabei aeltere Codes.
    # Die Frist setzt die DATENBANK -- der Aufrufer kann sie nicht verlaengern.
    with conn.cursor() as cur:
        cur.execute(
            "INSERT INTO login_code (actor_id, code_hash) VALUES (%s,%s)"
            " RETURNING expires_at",
            (actor_id, streuwert(code)))
        ablauf = cur.fetchone()[0]
    conn.commit()

    text = (f"Guten Tag {name},\n\n"
            f"Ihr Anmeldecode lautet: {code}\n\n"
            f"Er ist {CODE_FRIST_MINUTEN} Minuten gueltig und genau einmal verwendbar.\n"
            "Fordern Sie einen neuen an, verliert dieser sofort seine Gueltigkeit.\n\n"
            "Wenn Sie sich nicht angemeldet haben, ignorieren Sie diese Nachricht.\n\n"
            "FREIRAUM\n")
    try:
        senden(empfaenger, "Ihr FREIRAUM-Anmeldecode", text)
    except (VersandFehler, smtplib.SMTPException, OSError) as f:
        nachweis(conn, actor_id, "ANMELDECODE", empfaenger, "FEHLER", str(f)[:500])
        # Der Code bleibt entwertet zurueck: er wurde nie zugestellt.
        with conn.cursor() as cur:
            cur.execute("UPDATE login_code SET superseded_at=now() WHERE actor_id=%s"
                        " AND consumed_at IS NULL AND superseded_at IS NULL", (actor_id,))
        conn.commit()
        raise SystemExit(f"Versand gescheitert, im Nachweis vermerkt: {f}")
    nachweis(conn, actor_id, "ANMELDECODE", empfaenger, "UEBERGEBEN",
             provider_id=f"{SMTP_HOST}:{SMTP_PORT}")
    print(f"Code an {empfaenger} uebergeben, gueltig bis {ablauf.isoformat()}")


def einladung(conn, empfaenger, link):
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
    try:
        senden(empfaenger, "Ihre Einladung zu FREIRAUM", text)
    except (VersandFehler, smtplib.SMTPException, OSError) as f:
        nachweis(conn, actor_id, "EINLADUNG", empfaenger, "FEHLER", str(f)[:500])
        raise SystemExit(f"Versand gescheitert, im Nachweis vermerkt: {f}")
    nachweis(conn, actor_id, "EINLADUNG", empfaenger, "UEBERGEBEN",
             provider_id=f"{SMTP_HOST}:{SMTP_PORT}")
    print(f"Einladung an {empfaenger} uebergeben")


def main():
    ap = argparse.ArgumentParser()
    ap.add_argument("art", choices=["code", "einladung"])
    ap.add_argument("--an", required=True)
    ap.add_argument("--link", default="https://freiraum.top/einladung/…")
    a = ap.parse_args()

    absender_pruefen()
    with psycopg.connect(DSN) as conn:
        if a.art == "code":
            anmeldecode(conn, a.an)
        else:
            einladung(conn, a.an, a.link)
    return 0


if __name__ == "__main__":
    sys.exit(main())
