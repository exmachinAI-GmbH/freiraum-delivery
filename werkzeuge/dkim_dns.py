#!/usr/bin/env python3
# umsetzt: BEF-DKIM-1 V-1, V-2, V-3 · K23-M22 (nicht gemessen ist nicht bestanden)
"""FREIRAUM · Messgerät für die DKIM-Veröffentlichung der Absenderdomäne.

    python3 werkzeuge/dkim_dns.py
    python3 werkzeuge/dkim_dns.py --domaene freiraum.top --selektor 20260803
    python3 werkzeuge/dkim_dns.py --kopf nachweise/.../mailkopf.txt --manifest nachweise/manifeste/dkim_260823.json

WOZU DIESES WERKZEUG. Am 22.08.2026 meldete der Stand „DKIM fehlt" für freiraum.top.
Der Eintrag stand die ganze Zeit — unter einem anderen Selektor. Zwei Fehlerquellen
haben zusammengewirkt, und dieses Werkzeug ist gegen genau diese beiden gebaut:

  1. DER SELEKTOR LÄSST SICH NICHT ERRATEN. Der Anbieter benennt seinen Schlüssel nach
     dem Tag der Ausstellung und rotiert ihn (`20140709` → `20260803`). Ein fest
     verdrahteter Selektor misst nach jeder Rotation ins Leere und meldet „fehlt" —
     obwohl sich an unserer Zone nichts geändert hat. Deshalb rät dieses Werkzeug NIE.
     Es nimmt den Selektor aus einer benannten Quelle oder es sperrt.

  2. DIE ANTWORT IST ÜBER UDP ABGESCHNITTEN. CNAME plus 2048-Bit-Schlüssel
     überschreiten 512 Byte. Ohne EDNS0 antwortet jeder Resolver mit NOERROR,
     gesetztem TC-Flag und LEEREM Antwortteil. Wer nur den Antwortteil liest, sieht
     dasselbe wie bei „kein Eintrag" — und meldet falsch rot. Deshalb fragt dieses
     Werkzeug immer mit EDNS0 (Puffer 4096) und wertet ein gesetztes TC-Flag als
     GESPERRT, nie als Ergebnis.

DIE SCHEITERBEDINGUNG. Jedes Messgerät im Haus trägt eine Bedingung, an der es
scheitern kann. Hier ist es diese: Ein veröffentlichter Schlüssel BELEGT NICHT, dass
signiert wird. Der Anbieter sagt zu, ausgehende Mail nur dann zu signieren, wenn der
Eintrag gesetzt ist — ob es für unser Postfach geschieht, sagt allein der zugestellte
Mailkopf (Beschluss 43). Dieses Werkzeug misst die VORAUSSETZUNG. Es meldet niemals
„DKIM funktioniert", und wer seine grüne Zeile für einen Zustellnachweis hält, hat AC-16
nicht gefahren.

RÜCKGABEWERTE — der eigene Vertrag dieses Laufs:

    0   BESTANDEN     ein gültiger Schlüssel ist unter dem benannten Selektor
                      veröffentlicht, alle befragten Resolver sind sich einig
    1   FEHLGESCHLAGEN  gemessen, und das Ergebnis trägt nicht: kein Eintrag,
                      kein v=DKIM1, leerer Schlüssel (Widerruf), Domänenversatz
    2   GESPERRT      es wurde NICHTS gemessen: kein Selektor benennbar, Antwort
                      abgeschnitten, Zeitüberschreitung, dnspython fehlt,
                      Resolver uneinig. NICHT dasselbe wie fehlgeschlagen (K23-M22)

Sprache: Die Ausgabe trägt echte Umlaute. Der übrige Programmbestand schreibt sie als
ae/oe/ue — wenn das hier stören soll, ist es eine Suchen-und-Ersetzen-Änderung an den
Textkonstanten und an nichts sonst.
"""
import argparse
import json
import os
import re
import sys
from datetime import datetime, timezone

try:
    import dns.flags
    import dns.message
    import dns.name
    import dns.query
    import dns.rdatatype
    import dns.resolver
except ImportError:
    # GESPERRT und nicht fehlgeschlagen: ohne die Bibliothek ist nichts gemessen.
    print("GESPERRT · dnspython fehlt — nichts gemessen.", file=sys.stderr)
    print("           pip3 install dnspython", file=sys.stderr)
    raise SystemExit(2)

EDNS_PUFFER = 4096
ZEITGRENZE_SEK = 10

# Öffentliche Resolver als Gegenprobe. Der autoritative Nameserver der Zone kommt
# zur Laufzeit dazu — er wird ermittelt, nicht eingetragen: ein fest verdrahteter
# Nameserver ist derselbe Fehler wie ein fest verdrahteter Selektor.
RESOLVER = {
    "cloudflare": "1.1.1.1",
    "google": "8.8.8.8",
    "quad9": "9.9.9.9",
}


# ---------------------------------------------------------------------
# Der Selektor — vier Quellen, eine Rangfolge, kein Raten
# ---------------------------------------------------------------------
def selektor_aus_kopf(pfad):
    """Selektor und Signaturdomäne aus einem abgelesenen Mailkopf.

    Das ist die einzige GEMESSENE Quelle: Was im Kopf als `s=` steht, hat der
    Anbieter beim letzten Versand tatsächlich benutzt. Alles andere ist behauptet.

    Gelesen wird die DKIM-Signature-Kopfzeile samt Faltung (RFC 5322: Fortsetzungen
    beginnen mit Leerzeichen oder Tabulator). Ein Kopf kann mehrere Signaturen
    tragen; genommen wird die erste, deren `d=` zur geprüften Domäne passt — und
    wenn keine passt, die erste überhaupt, damit der Domänenversatz sichtbar wird
    statt verschluckt.
    """
    if not pfad or not os.path.isfile(pfad):
        return None, None, f"Kopfdatei {pfad or '<nicht gesetzt>'} fehlt oder ist keine Datei"
    with open(pfad, "r", encoding="utf-8", errors="replace") as f:
        roh = f.read().replace("\r\n", "\n").replace("\r", "\n")
    # Faltung auflösen, dann die Signaturzeilen einsammeln.
    entfaltet = re.sub(r"\n[ \t]+", " ", roh)
    zeilen = [z for z in entfaltet.split("\n")
              if z.lower().startswith("dkim-signature:")]
    if not zeilen:
        return None, None, f"keine DKIM-Signature-Kopfzeile in {pfad}"
    funde = []
    for z in zeilen:
        s = re.search(r"[;\s]s=([A-Za-z0-9._-]+)", z)
        d = re.search(r"[;\s]d=([A-Za-z0-9._-]+)", z)
        if s:
            funde.append((s.group(1), d.group(1).lower() if d else None))
    if not funde:
        return None, None, f"DKIM-Signature in {pfad} führt kein s=-Feld"
    return funde[0][0], funde[0][1], None


def selektor_bestimmen(args):
    """Woher der Selektor kommt — und was es heißt, wenn zwei Quellen streiten.

    Rangfolge:
      1. --selektor            ausdrückliche Weisung des Aufrufers
      2. der Mailkopf          GEMESSEN, aus dem letzten Echtversand
      3. FREIRAUM_DKIM_SELEKTOR  behauptet, aus der Umgebung
      4. nichts                → GESPERRT. Es wird nicht geraten.

    Weichen Kopf und Weisung/Umgebung voneinander ab, ist das der Rotationsfall aus
    BEF-DKIM-1 V-3: Der Anbieter hat den Schlüssel gewechselt, unsere Zone zeigt noch
    auf den alten, und niemand merkt es, bis die nächste Mail nicht mehr trägt. Der
    Fall wird ausdrücklich gemeldet.
    """
    kopf_sel, kopf_dom, kopf_grund = selektor_aus_kopf(
        args.kopf or os.environ.get("FREIRAUM_PRUEF_ECHT_MAILKOPF"))
    umgebung = os.environ.get("FREIRAUM_DKIM_SELEKTOR")

    if args.selektor:
        sel, quelle = args.selektor, "Weisung (--selektor)"
    elif kopf_sel:
        sel, quelle = kopf_sel, "abgelesener Mailkopf (s=)"
    elif umgebung:
        sel, quelle = umgebung, "Umgebung (FREIRAUM_DKIM_SELEKTOR)"
    else:
        return None, None, None, None, [
            "Kein Selektor benennbar — und geraten wird nicht.",
            f"  aus dem Mailkopf: {kopf_grund}",
            "  aus der Umgebung: FREIRAUM_DKIM_SELEKTOR nicht gesetzt",
            "  Der gültige Wert steht beim Anbieter und im Kopf jeder signierten Mail als s=.",
        ]

    warnungen = []
    if kopf_sel and kopf_sel != sel:
        warnungen.append(
            f"SELEKTORVERSATZ · der Mailkopf trägt s={kopf_sel}, gemessen wird {sel} "
            f"({quelle}). Einer von beiden ist veraltet — das ist der Rotationsfall "
            f"(BEF-DKIM-1 V-3).")
    if kopf_dom and kopf_dom != args.domaene.lower():
        warnungen.append(
            f"DOMÄNENVERSATZ · der Mailkopf signiert mit d={kopf_dom}, geprüft wird "
            f"{args.domaene}. Bei adkim=s zählt nur die exakte Domäne.")
    return sel, quelle, kopf_sel, kopf_dom, warnungen


# ---------------------------------------------------------------------
# Die Abfrage — immer mit EDNS0, TC ist eine Sperre
# ---------------------------------------------------------------------
def autoritative_server(domaene):
    """Die Nameserver der Zone, zur Laufzeit ermittelt.

    Der autoritative Server ist die einzige Antwort ohne Zwischenspeicher. Wer nur
    öffentliche Resolver fragt, misst deren Gedächtnis mit.
    """
    r = dns.resolver.Resolver(configure=False)
    r.nameservers = [RESOLVER["cloudflare"], RESOLVER["google"]]
    r.lifetime = ZEITGRENZE_SEK
    server = {}
    try:
        ns = r.resolve(domaene, "NS")
    except Exception:
        return server
    for eintrag in ns:
        name = str(eintrag.target).rstrip(".")
        try:
            for a in r.resolve(name, "A"):
                server[f"autoritativ:{name}"] = a.to_text()
                break
        except Exception:
            continue
    return server


def fragen(name, server):
    """Eine TXT-Abfrage mit EDNS0. Gibt (zustand, wert, hinweis) zurück.

    zustand ist einer von: 'gefunden' · 'leer' · 'nxdomain' · 'gesperrt'.
    Ein gesetztes TC-Flag ergibt 'gesperrt' — eine abgeschnittene Antwort ist
    keine Messung, sondern ein nicht zustande gekommener Versuch.
    """
    m = dns.message.make_query(name, dns.rdatatype.TXT,
                               use_edns=0, payload=EDNS_PUFFER)
    try:
        antwort = dns.query.udp(m, server, timeout=ZEITGRENZE_SEK)
    except Exception as f:
        return "gesperrt", None, f"kein Zustandekommen ({type(f).__name__})"

    if antwort.flags & dns.flags.TC:
        return "gesperrt", None, (
            "Antwort abgeschnitten (TC gesetzt) trotz EDNS0 — nicht gemessen, "
            "nicht 'kein Eintrag'. Über TCP wiederholen.")
    rcode = dns.rcode.to_text(antwort.rcode())
    if rcode == "NXDOMAIN":
        return "nxdomain", None, "der Name besteht nicht"
    if rcode != "NOERROR":
        return "gesperrt", None, f"Rückmeldung {rcode}"

    for satz in antwort.answer:
        if satz.rdtype != dns.rdatatype.TXT:
            continue
        for rdata in satz:
            # Ein TXT-Eintrag über 255 Zeichen kommt in MEHREREN Zeichenketten.
            # Wer nur die erste liest, hält einen 2048-Bit-Schlüssel für
            # abgeschnitten und meldet ihn als ungültig.
            wert = "".join(s.decode("ascii", "replace") for s in rdata.strings)
            if wert.lower().startswith("v=dkim1") or "p=" in wert:
                return "gefunden", wert, None
    return "leer", None, "NOERROR ohne TXT im Antwortteil"


# ---------------------------------------------------------------------
# Die Bewertung
# ---------------------------------------------------------------------
def _tlv(puffer, i):
    """Ein DER-Element ab Stelle i: (Kennung, Inhalt, nächste Stelle)."""
    kennung = puffer[i]
    laenge = puffer[i + 1]
    i += 2
    if laenge & 0x80:
        n = laenge & 0x7F
        laenge = int.from_bytes(puffer[i:i + n], "big")
        i += n
    return kennung, puffer[i:i + laenge], i + laenge


def schluessellaenge(p):
    """Die Bitlänge des RSA-Modulus — gerechnet, nicht geschätzt.

    Die frühere Fassung rechnete die Base64-Länge in Bits um und meldete für einen
    2048-Bit-Schlüssel „~2352 Bit". Das war die Länge der DER-HÜLLE, nicht die des
    Schlüssels: `p=` trägt eine SubjectPublicKeyInfo-Struktur (Algorithmuskennung,
    Bitfolge, darin erst Modulus und Exponent). Eine Zahl, die plausibel aussieht und
    etwas anderes misst, ist schlimmer als keine — hier wird die Struktur aufgemacht.

    Gibt None zurück, wenn sich der Schlüssel nicht lesen lässt. None heißt
    „nicht bestimmt", nicht „zu kurz".
    """
    import base64
    try:
        roh = base64.b64decode(p + "=" * (-len(p) % 4), validate=False)
        _, spki, _ = _tlv(roh, 0)                 # SEQUENCE { algid, BIT STRING }
        kennung, algid, weiter = _tlv(spki, 0)    # SEQUENCE algid
        kennung, bitfolge, _ = _tlv(spki, weiter) # BIT STRING
        if kennung != 0x03:
            return None
        inneres = bitfolge[1:]                    # erstes Byte: ungenutzte Bits
        _, rsa, _ = _tlv(inneres, 0)              # SEQUENCE { INTEGER n, INTEGER e }
        kennung, modulus, _ = _tlv(rsa, 0)
        if kennung != 0x02:
            return None
        return len(modulus.lstrip(b"\x00")) * 8
    except Exception:
        return None


def schluessel_pruefen(wert):
    """Trägt der veröffentlichte Wert? Gibt (traegt, begruendung, felder) zurück."""
    felder = {}
    for teil in wert.split(";"):
        if "=" in teil:
            k, v = teil.split("=", 1)
            felder[k.strip().lower()] = v.strip()
    if felder.get("v", "").upper() != "DKIM1":
        return False, "kein v=DKIM1 — das ist kein DKIM-Schlüsselsatz", felder
    p = felder.get("p")
    if p is None:
        return False, "kein p=-Feld — der Satz führt keinen Schlüssel", felder
    if p == "":
        return False, ("p= ist LEER. Das ist kein Fehler der Messung, sondern ein "
                       "WIDERRUFENER Schlüssel — der Anbieter hat ihn zurückgezogen."), felder
    bits = schluessellaenge(p)
    felder["_modulus_bits"] = bits
    art = felder.get("k", "rsa")
    if bits is None:
        return True, (f"ein Schlüssel steht da (k={art}), seine Länge ließ sich aber nicht "
                      f"lesen — der Wert ist keine lesbare RSA-Struktur"), felder
    if bits < 1024:
        return False, (f"der Modulus misst {bits} Bit. Unter 1024 Bit wird der Schlüssel "
                       f"von Empfängern verworfen (RFC 8301)"), felder
    if bits < 2048:
        return True, (f"gültig, k={art}, {bits} Bit — unter dem heutigen Stand von "
                      f"2048 Bit, aber tragfähig"), felder
    return True, f"gültig, k={art}, {bits} Bit", felder


def main():
    ap = argparse.ArgumentParser(
        description="Misst, ob der DKIM-Schlüssel der Absenderdomäne veröffentlicht ist.")
    ap.add_argument("--domaene", default=os.environ.get("FREIRAUM_ABSENDER_DOMAENE", "freiraum.top"),
                    help="die Domäne, für die signiert werden soll (Vorgabe: freiraum.top)")
    ap.add_argument("--selektor", help="ausdrücklicher Selektor; sonst aus Mailkopf oder Umgebung")
    ap.add_argument("--kopf", help="Datei mit einem abgelesenen Mailkopf (Vorgabe: FREIRAUM_PRUEF_ECHT_MAILKOPF)")
    ap.add_argument("--manifest", help="Pfad, unter dem der Laufnachweis als JSON abgelegt wird")
    ap.add_argument("--selbstprobe", action="store_true",
                    help="zeigt, dass die Sperre gegen abgeschnittene Antworten wirklich greift")
    args = ap.parse_args()

    zeitpunkt = datetime.now(timezone.utc).isoformat(timespec="seconds")
    sel, quelle, kopf_sel, kopf_dom, warnungen = selektor_bestimmen(args)

    print(f"== DKIM-Veröffentlichung · {args.domaene} · {zeitpunkt}")

    if sel is None:
        for zeile in warnungen:
            print(f"   {zeile}")
        print("\nGESPERRT · kein Selektor benennbar — nichts gemessen (K23-M22).")
        print("RUECKGABE: 2")
        return 2

    name = f"{sel}._domainkey.{args.domaene}"
    print(f"   Selektor {sel} · Quelle: {quelle}")
    print(f"   Abfrage:  {name} TXT · EDNS0 Puffer {EDNS_PUFFER}")
    for w in warnungen:
        print(f"   ⚠ {w}")

    if args.selbstprobe:
        # Die Scheiterbedingung vorführen statt behaupten: dieselbe Abfrage OHNE
        # EDNS0. Kommt sie mit gesetztem TC und leerem Antwortteil zurück, ist
        # genau der Zustand hergestellt, den ein naives Werkzeug als „kein
        # Eintrag" liest — und dieses hier als GESPERRT.
        print("\n   -- Selbstprobe: dieselbe Abfrage ohne EDNS0 --")
        m = dns.message.make_query(name, dns.rdatatype.TXT)   # kein use_edns
        try:
            a = dns.query.udp(m, RESOLVER["cloudflare"], timeout=ZEITGRENZE_SEK)
            tc = bool(a.flags & dns.flags.TC)
            print(f"   TC-Flag {'GESETZT' if tc else 'nicht gesetzt'} · "
                  f"Antwortteil {'leer' if not a.answer else 'gefüllt'}")
            print("   " + ("→ Die Sperre greift: ohne EDNS0 wäre hier nichts zu sehen, "
                           "und ein naives Werkzeug meldete „fehlt\"."
                           if tc else
                           "→ Die Antwort passt heute auch ohne EDNS0. Das kann sich mit "
                           "jedem längeren Schlüssel ändern — die Sperre bleibt nötig."))
        except Exception as f:
            print(f"   Selbstprobe nicht zustande gekommen ({type(f).__name__})")

    server = dict(RESOLVER)
    server.update(autoritative_server(args.domaene))
    if not any(k.startswith("autoritativ") for k in server):
        warnungen.append("kein autoritativer Nameserver ermittelbar — gemessen wird "
                         "nur gegen Zwischenspeicher")

    print()
    ergebnisse = {}
    for lbl, ip in sorted(server.items()):
        zustand, wert, hinweis = fragen(name, ip)
        ergebnisse[lbl] = {"server": ip, "zustand": zustand, "wert": wert, "hinweis": hinweis}
        kurz = (wert[:72] + "…") if wert and len(wert) > 72 else (wert or hinweis or "")
        print(f"   {lbl:28} {zustand:9} {kurz}")

    zustaende = {e["zustand"] for e in ergebnisse.values()}
    werte = {e["wert"] for e in ergebnisse.values() if e["wert"]}

    urteil, rueckgabe, saetze = None, None, []

    if zustaende == {"gesperrt"}:
        urteil, rueckgabe = "GESPERRT", 2
        saetze.append("Kein einziger Resolver hat geantwortet — nichts gemessen.")
    elif "gefunden" not in zustaende and "nxdomain" in zustaende:
        urteil, rueckgabe = "FEHLGESCHLAGEN", 1
        saetze.append(f"Unter dem Selektor {sel} steht kein Eintrag für {args.domaene}.")
        saetze.append("VOR DER SUCHE NACH EINEM FEHLER IN DER ZONE: Prüfen, ob der Anbieter "
                      "den Selektor gewechselt hat. Der gültige steht im s=-Feld des letzten "
                      "zugestellten Kopfes. Ein Wechsel sieht genauso aus wie ein gelöschter "
                      "Eintrag (BEF-DKIM-1 V-3).")
    elif "gefunden" not in zustaende:
        urteil, rueckgabe = "GESPERRT", 2
        saetze.append("Keine auswertbare Antwort — abgeschnitten oder ohne TXT. Nicht gemessen.")
    elif len(werte) > 1:
        urteil, rueckgabe = "GESPERRT", 2
        saetze.append("Die Resolver sind sich UNEINIG — verschiedene Schlüssel unter demselben "
                      "Namen. Entweder läuft die Verbreitung einer Änderung noch, oder die Zone "
                      "ist uneinheitlich. In 30 Minuten wiederholen; bis dahin ist nichts belegt.")
    else:
        wert = werte.pop()
        traegt, begruendung, felder = schluessel_pruefen(wert)
        if traegt:
            urteil, rueckgabe = "BESTANDEN", 0
            saetze.append(f"Ein Schlüssel ist veröffentlicht: {begruendung}.")
            fehlend = [k for k in ergebnisse if ergebnisse[k]["zustand"] != "gefunden"]
            if fehlend:
                urteil, rueckgabe = "GESPERRT", 2
                saetze.append(f"Aber nicht überall: {', '.join(fehlend)} hat nicht geantwortet. "
                              "Ein Teilbefund ist kein Befund.")
        else:
            urteil, rueckgabe = "FEHLGESCHLAGEN", 1
            saetze.append(begruendung)

    print()
    print(f"{urteil} · {name}")
    for s in saetze:
        print(f"   {s}")
    print("   Was dieser Lauf NICHT belegt: dass ausgehende Mail auch signiert WIRD.")
    print("   Das belegt allein der zugestellte Mailkopf (AC-16, Beschluss 43).")
    print(f"RUECKGABE: {rueckgabe}")

    if args.manifest:
        nachweis = {
            "werkzeug": "werkzeuge/dkim_dns.py",
            "gemessen_am": zeitpunkt,
            "domaene": args.domaene,
            "selektor": sel,
            "selektor_quelle": quelle,
            "selektor_im_kopf": kopf_sel,
            "signaturdomaene_im_kopf": kopf_dom,
            "abgefragter_name": name,
            "edns_puffer": EDNS_PUFFER,
            "resolver": ergebnisse,
            "warnungen": warnungen,
            "urteil": urteil,
            "rueckgabe": rueckgabe,
            "vorbehalt": ("Belegt die Veroeffentlichung, nicht die Signatur. "
                          "Der Signaturnachweis ist der zugestellte Mailkopf (AC-16)."),
        }
        os.makedirs(os.path.dirname(os.path.abspath(args.manifest)), exist_ok=True)
        with open(args.manifest, "w", encoding="utf-8") as f:
            json.dump(nachweis, f, ensure_ascii=False, indent=2, sort_keys=True)
            f.write("\n")
        print(f"   Laufnachweis abgelegt: {args.manifest}")

    return rueckgabe


if __name__ == "__main__":
    try:
        raise SystemExit(main())
    except BrokenPipeError:
        # `... | head` schliesst die Leitung mitten im Schreiben. Ohne diesen Fang
        # endet ein sonst fehlerfreier Lauf mit einem Rueckverfolgungsbericht --
        # und sieht damit aus wie ein Fehlschlag, der keiner ist.
        try:
            sys.stdout.close()
        finally:
            raise SystemExit(2)
