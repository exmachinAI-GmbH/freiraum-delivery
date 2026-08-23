#!/usr/bin/env python3
# umsetzt: BEF-DKIM-1 · AC-16 (K03) · K23-M22 · K23-D09
"""FREIRAUM · Bereitschaftsprüfung vor dem AC-16-Echtlauf.

    python3 werkzeuge/m2_bereitschaft.py
    python3 werkzeuge/m2_bereitschaft.py --manifest nachweise/manifeste/m2_bereit_260823.json

WOZU. AC-16 ist der eine Prüffall, an dem Meilenstein M2 hängt, und er ist teuer:
Der Einladungstoken ist einmalig (K20-D10). Scheitert der Lauf an einer Kleinigkeit —
ein nicht gesetzter Umgebungswert, ein SMTP-Kennwort, das nicht mehr gilt, eine
Empfängeradresse, die kein fremder Anbieter annimmt —, dann ist der Token trotzdem
verbraucht, und vor dem nächsten Versuch muss `anmeldecode_daten.sql` neu eingespielt
werden. Dazwischen sitzt ein Mensch, der ein fremdes Postfach öffnet und innerhalb von
fünf Minuten einen Rohkopf ablegt.

DIESE PRÜFUNG VERBRAUCHT NICHTS. Sie verschickt keine Mail, stellt keinen Code aus und
löst keine Einladung ein. Sie stellt nur fest, ob der Lauf eine Aussicht hat — und
nennt jede Sperre beim Namen, bevor sie Geld kostet.

WAS SIE NICHT IST. Kein Ersatz für AC-16. Sie belegt nicht, dass eine Mail zugestellt
wurde, nicht dass signiert wurde, nicht dass die Zuordnung trägt. Das belegt allein der
zugestellte Kopf (Beschluss 43). Wer diese grüne Zeile für M2 hält, hat M2 nicht.

RÜCKGABEWERTE:

    0   BEREIT      jede Bedingung geprüft und erfüllt — der Echtlauf kann fahren
    1   NICHT BEREIT  mindestens eine Bedingung ist geprüft und NICHT erfüllt
    2   GESPERRT    mindestens eine Bedingung liess sich nicht prüfen. Nach K23-M22
                    ist das nicht dasselbe wie erfüllt — und nicht dasselbe wie verletzt

GEHEIMNISSE. Kein Kennwort, kein Pfeffer und keine vollständige Zugangszeichenkette
erscheint in der Ausgabe oder im Manifest (K23-D09). Gemeldet wird, DASS ein Wert
gesetzt ist, nie welcher.
"""
import argparse
import json
import os
import re
import smtplib
import socket
import ssl
import sys
from datetime import datetime, timezone

BESTANDEN, VERLETZT, GESPERRT = "BESTANDEN", "VERLETZT", "GESPERRT"


def _ohne_geheimnis(text):
    """Kennwoerter aus einer Zugangszeichenkette entfernen (K23-D09)."""
    return re.sub(r"://([^:/@\s]+):[^@\s]*@", r"://\1:***@", text or "")

# Reservierte Namensräume (RFC 2606, RFC 6761). Eine Adresse darin kann kein
# fremder Anbieter annehmen. Am 17.08.2026 entstand ein Lauf mit neun roten
# Fällen, weil der echte Wirt Adressen @pruef.example ablehnte.
RESERVIERT = (".example", ".test", ".invalid", ".localhost",
              "example.com", "example.net", "example.org")


class Pruefung:
    """Ein Punkt der Liste: Name, Zustand, Satz. Mehr trägt er nicht."""

    def __init__(self):
        self.punkte = []

    def melde(self, name, zustand, satz):
        self.punkte.append({"punkt": name, "zustand": zustand, "satz": satz})
        zeichen = {BESTANDEN: "✓", VERLETZT: "✗", GESPERRT: "?"}[zustand]
        print(f"   {zeichen} {name:34} {satz}")

    def urteil(self):
        zustaende = {p["zustand"] for p in self.punkte}
        if VERLETZT in zustaende:
            return "NICHT BEREIT", 1
        if GESPERRT in zustaende:
            return "GESPERRT", 2
        return "BEREIT", 0


def gesetzt(name):
    wert = os.environ.get(name)
    return bool(wert and wert.strip())


# ---------------------------------------------------------------------
# 1 · Die Umgebung
# ---------------------------------------------------------------------
def pruefe_umgebung(p):
    print("\n1 · Umgebungswerte — gemeldet wird DASS, nie WELCHER (K23-D09)")

    pflicht = [
        ("FREIRAUM_ECHTVERSAND", "muss auf 'ja' stehen, sonst legt anmeldecode_daten.sql kein Konto an"),
        ("FREIRAUM_PRUEF_ECHT_EMPFAENGER", "die echte, fremde Adresse, in die ein Mensch sehen kann"),
        ("FREIRAUM_PRUEF_ECHT_MAILKOPF", "Datei, in die der Rohkopf gelegt wird"),
        ("FREIRAUM_SMTP_HOST", "der Wirt des Versands — ein stiller Rückfall auf localhost ist verboten (BEF-L2-1)"),
        ("FREIRAUM_SMTP_USER", "das Postfach, mit dem sich der Versand anmeldet"),
        ("FREIRAUM_SMTP_PASS", "sein Kennwort"),
        ("FREIRAUM_DSN", "die Datenbank, in der der Versandnachweis entsteht"),
        ("FREIRAUM_CODE_PFEFFER", "ohne ihn wird kein Code ausgestellt (BEF-B2-2)"),
    ]
    for name, wozu in pflicht:
        if gesetzt(name):
            p.melde(name, BESTANDEN, "gesetzt")
        else:
            p.melde(name, VERLETZT, f"nicht gesetzt — {wozu}")

    if os.environ.get("FREIRAUM_UMGEBUNG", "").strip().lower() == "lokal":
        p.melde("FREIRAUM_UMGEBUNG", VERLETZT,
                "steht auf 'lokal' — der Lauf ginge an den örtlichen Fänger und meldete "
                "ERFOLG, ohne den echten Weg zu berühren (BEF-L2-1)")
    else:
        p.melde("FREIRAUM_UMGEBUNG", BESTANDEN, "nicht 'lokal' — der echte Weg wird benutzt")

    echt = os.environ.get("FREIRAUM_ECHTVERSAND", "").strip()
    if echt and echt != "ja":
        p.melde("FREIRAUM_ECHTVERSAND", VERLETZT, f"steht auf '{echt}', gebraucht wird 'ja'")

    kopf = os.environ.get("FREIRAUM_PRUEF_ECHT_MAILKOPF")
    if kopf:
        ordner = os.path.dirname(os.path.abspath(kopf)) or "."
        if not os.path.isdir(ordner):
            p.melde("Ablageort des Kopfes", VERLETZT, f"{ordner} ist kein Verzeichnis")
        elif not os.access(ordner, os.W_OK):
            p.melde("Ablageort des Kopfes", VERLETZT, f"{ordner} ist nicht beschreibbar")
        elif os.path.isfile(kopf) and os.path.getsize(kopf) > 0:
            p.melde("Ablageort des Kopfes", GESPERRT,
                    f"{kopf} ist NICHT leer — ein alter Kopf. AC-16 bindet den Kopf an den "
                    f"Zeitpunkt des Versands; ein alter Kopf fällt aus dem Fenster. Vor dem "
                    f"Lauf leeren")
        else:
            p.melde("Ablageort des Kopfes", BESTANDEN, f"{ordner} beschreibbar, Datei leer oder neu")


# ---------------------------------------------------------------------
# 2 · Absender und Empfänger
# ---------------------------------------------------------------------
def pruefe_adressen(p):
    print("\n2 · Absender und Empfänger — dieselbe Regel wie in mail/versand.py")

    absender = os.environ.get("FREIRAUM_ABSENDER", "noreply@freiraum.top")
    erlaubt = os.environ.get("FREIRAUM_ABSENDER_DOMAENE", "freiraum.top").lower()
    domaene = absender.rsplit("@", 1)[-1].lower()
    if domaene != erlaubt:
        p.melde("Absenderbindung", VERLETZT,
                f"{absender} liegt nicht in {erlaubt}. Die SPF-Kette endet auf -all; "
                f"`absender_pruefen()` bricht vor dem Verbindungsaufbau ab")
    else:
        p.melde("Absenderbindung", BESTANDEN, f"{absender} liegt in {erlaubt}")

    empf = (os.environ.get("FREIRAUM_PRUEF_ECHT_EMPFAENGER") or "").strip().lower()
    if not empf:
        p.melde("Empfängeradresse", GESPERRT, "nicht gesetzt — nicht prüfbar")
        return erlaubt
    if "'" in empf:
        p.melde("Empfängeradresse", VERLETZT,
                "enthält ein Hochkomma — das Prüfskript kann sie nicht sicher in SQL setzen")
    elif any(empf.endswith(r) or empf.split("@")[-1] == r.lstrip(".") for r in RESERVIERT):
        p.melde("Empfängeradresse", VERLETZT,
                "liegt in einem reservierten Namensraum (RFC 2606) — kein fremder Anbieter "
                "nimmt sie an. Genau daran scheiterte der Lauf vom 17.08.2026")
    elif empf.split("@")[-1] == erlaubt:
        p.melde("Empfängeradresse", GESPERRT,
                f"liegt in {erlaubt} selbst. Zulässig, aber dann misst der Lauf den Weg zu "
                f"einem EIGENEN Postfach — die Zuordnung eines fremden Empfängers bleibt "
                f"ungemessen. Bewusst entscheiden")
    else:
        p.melde("Empfängeradresse", BESTANDEN, f"fremde Domäne ({empf.split('@')[-1]})")
    return erlaubt


# ---------------------------------------------------------------------
# 3 · Die Namensauflösung
# ---------------------------------------------------------------------
def pruefe_dns(p, domaene, selektor_weisung):
    print(f"\n3 · Namensauflösung für {domaene} — was AC-16 im Kopf sehen will")
    try:
        import dns.flags
        import dns.message
        import dns.query
        import dns.rdatatype
        import dns.resolver
    except ImportError:
        p.melde("DNS", GESPERRT, "dnspython fehlt — nichts gemessen (pip3 install dnspython)")
        return

    r = dns.resolver.Resolver(configure=False)
    r.nameservers = ["1.1.1.1", "8.8.8.8"]
    r.lifetime = 10

    def txt(name):
        m = dns.message.make_query(name, dns.rdatatype.TXT, use_edns=0, payload=4096)
        a = dns.query.udp(m, "1.1.1.1", timeout=10)
        if a.flags & dns.flags.TC:
            raise RuntimeError("Antwort abgeschnitten trotz EDNS0")
        werte = []
        for satz in a.answer:
            if satz.rdtype == dns.rdatatype.TXT:
                for rd in satz:
                    werte.append("".join(s.decode("ascii", "replace") for s in rd.strings))
        return werte

    try:
        spf = [w for w in txt(domaene) if w.lower().startswith("v=spf1")]
        p.melde("SPF", BESTANDEN if spf else VERLETZT,
                spf[0] if spf else "kein SPF-Eintrag — AC-16 will spf=pass im Kopf sehen")
    except Exception as f:
        p.melde("SPF", GESPERRT, f"nicht gemessen ({type(f).__name__})")

    try:
        dmarc = [w for w in txt(f"_dmarc.{domaene}") if w.lower().startswith("v=dmarc1")]
        if not dmarc:
            p.melde("DMARC", VERLETZT, "kein DMARC-Eintrag — AC-16 will dmarc=pass im Kopf sehen")
        else:
            satz = dmarc[0]
            hinweis = ""
            if "adkim=s" in satz.replace(" ", ""):
                hinweis = " · adkim=s: die Signatur muss auf genau diese Domäne lauten"
            p.melde("DMARC", BESTANDEN, satz + hinweis)
    except Exception as f:
        p.melde("DMARC", GESPERRT, f"nicht gemessen ({type(f).__name__})")

    selektor = selektor_weisung or os.environ.get("FREIRAUM_DKIM_SELEKTOR")
    if not selektor:
        p.melde("DKIM", GESPERRT,
                "kein Selektor benennbar — und geraten wird nicht. --selektor setzen oder "
                "FREIRAUM_DKIM_SELEKTOR führen. Der gültige steht im s=-Feld des letzten "
                "zugestellten Kopfes (BEF-DKIM-1 V-2)")
        return
    name = f"{selektor}._domainkey.{domaene}"
    try:
        werte = [w for w in txt(name) if w.lower().startswith("v=dkim1")]
        if not werte:
            p.melde("DKIM", VERLETZT,
                    f"unter {name} steht kein Schlüssel. VOR DER FEHLERSUCHE IN DER ZONE: "
                    f"prüfen, ob der Anbieter den Selektor gewechselt hat (BEF-DKIM-1)")
        elif re.search(r"(^|;)\s*p=\s*(;|$)", werte[0]):
            p.melde("DKIM", VERLETZT, f"{name} trägt ein LEERES p= — der Schlüssel ist widerrufen")
        else:
            p.melde("DKIM", BESTANDEN, f"Schlüssel unter {name} veröffentlicht (Selektor {selektor})")
    except Exception as f:
        p.melde("DKIM", GESPERRT, f"{name} nicht gemessen ({type(f).__name__})")


# ---------------------------------------------------------------------
# 3b · Verlässt die Mail überhaupt das Haus?
# ---------------------------------------------------------------------
def _elternteil(name):
    """Die letzten zwei Namensteile — grob genug, um denselben Anbieter zu erkennen."""
    teile = (name or "").rstrip(".").lower().split(".")
    return ".".join(teile[-2:]) if len(teile) >= 2 else name


def pruefe_zustellweg(p):
    """Läuft der Versand über denselben Anbieter, der auch empfängt?

    WARUM DAS EIN EIGENER PUNKT IST. AC-16 will im Kopf `dkim=pass`, `spf=pass` und
    `dmarc=pass` sehen. Diese Zeile — Authentication-Results — schreibt der EMPFANGENDE
    Server, nicht der sendende. Liegen Versand und Empfang beim selben Anbieter, ist die
    Zustellung hausintern: Viele Anbieter prüfen dann gar nicht und schreiben deshalb
    auch keine Authentication-Results. Der Kopf käme ohne die drei Marken an, und AC-16
    bliebe rot — obwohl an Zone, Schlüssel und Bau nichts falsch ist.

    Ein Adressvergleich allein erkennt das NICHT: Zwei verschiedene Domänen können
    auf demselben Wirt liegen. Deshalb wird der MX-Eintrag des Empfängers gegen den
    Versandwirt gehalten, nicht die Domäne gegen die Domäne.
    """
    print("\n3b · Zustellweg — schreibt der Empfänger überhaupt Authentication-Results?")
    try:
        import dns.resolver
    except ImportError:
        p.melde("Zustellweg", GESPERRT, "dnspython fehlt — nicht gemessen")
        return
    empf = (os.environ.get("FREIRAUM_PRUEF_ECHT_EMPFAENGER") or "").strip()
    wirt = os.environ.get("FREIRAUM_SMTP_HOST")
    if not empf or "@" not in empf or not wirt:
        p.melde("Zustellweg", GESPERRT, "Empfänger oder Versandwirt nicht gesetzt — nicht prüfbar")
        return
    r = dns.resolver.Resolver(configure=False)
    r.nameservers = ["1.1.1.1", "8.8.8.8"]
    r.lifetime = 10
    try:
        mx = sorted((x.preference, str(x.exchange)) for x in r.resolve(empf.split("@")[-1], "MX"))
    except Exception as f:
        p.melde("Zustellweg", VERLETZT,
                f"{empf.split('@')[-1]} hat keinen erreichbaren MX-Eintrag ({type(f).__name__}) — "
                f"eine Mail dorthin kommt nicht an")
        return
    ziel = mx[0][1]
    if _elternteil(ziel) == _elternteil(wirt):
        p.melde("Zustellweg", GESPERRT,
                f"Empfänger-MX ({ziel.rstrip('.')}) und Versandwirt ({wirt}) liegen beim "
                f"SELBEN Anbieter. Die Mail verlässt das Haus nicht. Ob dabei überhaupt "
                f"signiert und geprüft wird — und ob Authentication-Results geschrieben "
                f"werden —, ist offen. Vor dem Echtlauf mit einer Handprobe klären oder "
                f"ein Postfach bei einem anderen Anbieter nehmen")
    else:
        p.melde("Zustellweg", BESTANDEN,
                f"Empfänger-MX {ziel.rstrip('.')} liegt bei einem anderen Anbieter als {wirt}")


# ---------------------------------------------------------------------
# 4 · Der Versandweg — Anmeldung ohne Versand
# ---------------------------------------------------------------------
def pruefe_smtp(p):
    print("\n4 · Versandweg — Verbindung und Anmeldung, OHNE eine Mail zu senden")
    wirt = os.environ.get("FREIRAUM_SMTP_HOST")
    if not wirt:
        p.melde("SMTP", GESPERRT, "FREIRAUM_SMTP_HOST nicht gesetzt — nichts gemessen")
        return
    port = int(os.environ.get("FREIRAUM_SMTP_PORT") or 587)
    tls_verlangt = (os.environ.get("FREIRAUM_SMTP_TLS") or "1") == "1"
    benutzer = os.environ.get("FREIRAUM_SMTP_USER")
    kennwort = os.environ.get("FREIRAUM_SMTP_PASS")

    try:
        s = smtplib.SMTP(wirt, port, timeout=20)
    except (socket.timeout, OSError) as f:
        p.melde("SMTP-Verbindung", GESPERRT,
                f"{wirt}:{port} nicht erreichbar ({type(f).__name__}) — nichts gemessen. "
                f"Häufig eine Sperre des ausgehenden Ports, nicht des Wirts")
        return
    try:
        s.ehlo()
        p.melde("SMTP-Verbindung", BESTANDEN, f"{wirt}:{port} antwortet")

        if tls_verlangt:
            if not s.has_extn("starttls"):
                p.melde("STARTTLS", VERLETZT,
                        "der Wirt bietet kein STARTTLS an, FREIRAUM_SMTP_TLS verlangt es. "
                        "Anmeldedaten über eine ungesicherte Verbindung sind das größere Übel")
                return
            s.starttls(context=ssl.create_default_context())
            s.ehlo()
            p.melde("STARTTLS", BESTANDEN, "ausgehandelt, Zertifikat geprüft")
        else:
            p.melde("STARTTLS", GESPERRT,
                    "FREIRAUM_SMTP_TLS=0 — ungesichert. Ausserhalb der örtlichen Umgebung "
                    "ist das nicht vorgesehen")

        if not (benutzer and kennwort):
            p.melde("SMTP-Anmeldung", GESPERRT, "Benutzer oder Kennwort nicht gesetzt — nicht geprüft")
            return
        try:
            s.login(benutzer, kennwort)
            p.melde("SMTP-Anmeldung", BESTANDEN,
                    "angenommen — das Kennwort gilt. (Der Wert selbst erscheint nirgends)")
        except smtplib.SMTPAuthenticationError as f:
            p.melde("SMTP-Anmeldung", VERLETZT,
                    f"zurückgewiesen ({f.smtp_code}). Das Postfachkennwort lässt sich in der "
                    f"Mailverwaltung des Anbieters neu setzen — es muss nicht wiedergefunden werden")
        except smtplib.SMTPException as f:
            p.melde("SMTP-Anmeldung", GESPERRT, f"nicht durchgeführt ({type(f).__name__})")
    except (smtplib.SMTPException, ssl.SSLError, OSError) as f:
        p.melde("SMTP", GESPERRT, f"Abbruch im Ablauf ({type(f).__name__}: {f})")
    finally:
        try:
            s.quit()
        except Exception:
            pass


# ---------------------------------------------------------------------
# 5 · Datenbank, Prüfkonto, Uhr
# ---------------------------------------------------------------------
def pruefe_datenbank(p):
    print("\n5 · Datenbank — Prüfkonto, offene Einladung, Uhrversatz")
    dsn = os.environ.get("FREIRAUM_DSN")
    if not dsn:
        p.melde("Datenbank", GESPERRT, "FREIRAUM_DSN nicht gesetzt — nichts gemessen")
        return
    try:
        import psycopg
    except ImportError:
        p.melde("Datenbank", GESPERRT,
                "psycopg fehlt — nichts gemessen (pip3 install 'psycopg[binary]')")
        return

    empf = (os.environ.get("FREIRAUM_PRUEF_ECHT_EMPFAENGER") or "").strip()
    try:
        with psycopg.connect(dsn, connect_timeout=10) as conn:
            p.melde("Datenbankverbindung", BESTANDEN, "steht")

            with conn.cursor() as cur:
                cur.execute("SELECT now() AT TIME ZONE 'utc'")
                db_zeit = cur.fetchone()[0].replace(tzinfo=timezone.utc)
            versatz = abs((datetime.now(timezone.utc) - db_zeit).total_seconds())
            if versatz > 60:
                p.melde("Uhrversatz", VERLETZT,
                        f"{versatz:.0f}s zwischen diesem Rechner und der Datenbank. AC-16 bindet "
                        f"den Date-Kopf auf 300s an mail_delivery.sent_at — ein Versatz dieser "
                        f"Grösse frisst das Fenster auf")
            else:
                p.melde("Uhrversatz", BESTANDEN, f"{versatz:.0f}s — innerhalb des 300s-Fensters")

            if not empf:
                p.melde("Prüfkonto", GESPERRT, "kein Empfänger gesetzt — nicht prüfbar")
                return
            with conn.cursor() as cur:
                cur.execute("SELECT count(*) FROM actor WHERE email = %s", (empf,))
                anzahl = cur.fetchone()[0]
            if anzahl == 0:
                p.melde("Prüfkonto", VERLETZT,
                        "kein Konto zu dieser Adresse — anmeldecode_daten.sql mit "
                        "FREIRAUM_ECHTVERSAND=ja und demselben Empfänger einspielen")
                return
            if anzahl > 1:
                p.melde("Prüfkonto", VERLETZT,
                        f"{anzahl} Konten zu dieser Adresse — mehrdeutig, der Lauf träfe "
                        f"irgendeins (die Eindeutigkeit auf actor.email ist schreibweisengenau)")
                return
            p.melde("Prüfkonto", BESTANDEN, "genau eines")

            with conn.cursor() as cur:
                cur.execute(
                    "SELECT i.status::text, i.expires_at > now() FROM invitation i "
                    "JOIN actor a ON a.id = i.actor_id WHERE a.email = %s "
                    "ORDER BY i.sent_at DESC LIMIT 1", (empf,))
                zeile = cur.fetchone()
            if not zeile:
                p.melde("Offene Einladung", VERLETZT,
                        "keine Einladung zu diesem Konto — anmeldecode_daten.sql neu einspielen")
            elif zeile[0] != "VERSANDT":
                p.melde("Offene Einladung", VERLETZT,
                        f"Status {zeile[0]} statt VERSANDT. Der Token ist einmalig (K20-D10) — "
                        f"für einen neuen Versuch anmeldecode_daten.sql NEU einspielen")
            elif not zeile[1]:
                p.melde("Offene Einladung", VERLETZT,
                        "abgelaufen (expires_at liegt zurück) — neu einspielen")
            else:
                p.melde("Offene Einladung", BESTANDEN, "VERSANDT und noch gültig")
    except Exception as f:
        # ERWEITERT AM 23.08.2026: Die vorige Fassung meldete nur den
        # Klassennamen ("OperationalError") -- und damit nicht den Unterschied
        # zwischen "die Datenbank gibt es noch nicht" (der Normalfall VOR
        # `ac16_echtlauf.sh vorbereiten`) und "kein Postgres auf dem Port" (ein
        # echtes Hindernis). Wer beides gleich sieht, sucht am falschen Ort.
        # Der Wortlaut wird maskiert: eine Zugangszeichenkette darf nach
        # K23-D09 nicht in eine Fehlerausgabe geraten.
        grund = _ohne_geheimnis(str(f).strip().splitlines()[0] if str(f).strip() else "")
        tief = grund.lower()
        if "does not exist" in tief or "existiert nicht" in tief:
            p.melde("Datenbank", GESPERRT,
                    "die Datenbank besteht noch nicht — das ist VOR "
                    "`ac16_echtlauf.sh vorbereiten` der Normalfall und kein Hindernis. "
                    "Nach dem Vorbereiten diese Pruefung wiederholen")
        elif "connection refused" in tief or "could not connect" in tief or "starting up" in tief:
            p.melde("Datenbank", VERLETZT,
                    f"kein Postgres erreichbar ({grund}). Der Pruefstand muss laufen — "
                    f"ohne ihn entsteht kein Versandnachweis, und AC-16 hat nichts zu binden")
        else:
            p.melde("Datenbank", GESPERRT, f"nicht gemessen ({type(f).__name__}: {grund})")


def main():
    ap = argparse.ArgumentParser(
        description="Prüft vor dem AC-16-Echtlauf, ob er eine Aussicht hat — ohne etwas zu verbrauchen.")
    ap.add_argument("--selektor", help="DKIM-Selektor; sonst FREIRAUM_DKIM_SELEKTOR")
    ap.add_argument("--manifest", help="Pfad für den Laufnachweis (JSON)")
    ap.add_argument("--ohne-smtp", action="store_true",
                    help="den Versandweg auslassen (wenn der Port hier gesperrt ist)")
    args = ap.parse_args()

    zeitpunkt = datetime.now(timezone.utc).isoformat(timespec="seconds")
    print(f"== M2 · Bereitschaft für den AC-16-Echtlauf · {zeitpunkt}")
    print("   Diese Prüfung verschickt nichts und verbraucht keinen Token.")

    p = Pruefung()
    pruefe_umgebung(p)
    domaene = pruefe_adressen(p)
    pruefe_dns(p, domaene, args.selektor)
    pruefe_zustellweg(p)
    if args.ohne_smtp:
        p.melde("SMTP", GESPERRT, "auf Weisung ausgelassen (--ohne-smtp) — nicht gemessen")
    else:
        pruefe_smtp(p)
    pruefe_datenbank(p)

    urteil, rueckgabe = p.urteil()
    zaehlung = {z: sum(1 for x in p.punkte if x["zustand"] == z)
                for z in (BESTANDEN, VERLETZT, GESPERRT)}
    print()
    print(f"{urteil} — {zaehlung[BESTANDEN]} erfüllt · {zaehlung[VERLETZT]} verletzt · "
          f"{zaehlung[GESPERRT]} nicht prüfbar")
    if rueckgabe == 0:
        # BERICHTIGT AM 23.08.2026: hier stand "FUENF MINUTEN". Falsch --
        # FENSTER_MIN_AC16 ist 20. Die 300 s (BINDUNG_TOLERANZ_SEK_AC16) messen
        # etwas anderes: den Abstand zwischen der Date-Zeile der Mail und
        # mail_delivery.sent_at. Beide entstehen beim Versand; der Mensch hat
        # darauf keinen Einfluss. Zwei Zahlen, die nichts miteinander zu tun
        # haben -- und die falsche stand ausgerechnet in der Zeile, die jemand
        # liest, kurz bevor die Uhr laeuft.
        print("   Der Echtlauf kann fahren. Danach: zuerst im JUNK-Ordner nachsehen,")
        print("   den Rohkopf INNERHALB VON ZWANZIG MINUTEN ablegen (FENSTER_MIN_AC16=20)")
        print("   und AC-16 im selben Fenster wiederholen.")
    else:
        print("   Nicht fahren, solange oben ein ✗ oder ? steht — der Token ist einmalig.")
    print("   Was diese Prüfung NICHT belegt: dass eine Mail ankommt, signiert wird oder")
    print("   die Zuordnung trägt. Das belegt allein der zugestellte Kopf (AC-16).")
    print(f"RUECKGABE: {rueckgabe}")

    if args.manifest:
        os.makedirs(os.path.dirname(os.path.abspath(args.manifest)), exist_ok=True)
        with open(args.manifest, "w", encoding="utf-8") as f:
            json.dump({"werkzeug": "werkzeuge/m2_bereitschaft.py",
                       "gemessen_am": zeitpunkt, "domaene": domaene,
                       "punkte": p.punkte, "urteil": urteil, "rueckgabe": rueckgabe,
                       "vorbehalt": "Prueft die Aussicht, nicht die Zustellung."},
                      f, ensure_ascii=False, indent=2, sort_keys=True)
            f.write("\n")
        print(f"   Laufnachweis abgelegt: {args.manifest}")
    return rueckgabe


if __name__ == "__main__":
    try:
        raise SystemExit(main())
    except BrokenPipeError:
        try:
            sys.stdout.close()
        finally:
            raise SystemExit(2)
