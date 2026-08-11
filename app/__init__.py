"""FREIRAUM · Scheibe 1 · Anmeldung.

Der erste senkrechte Schnitt: Bildschirm EN-01 (K19) ueber den Serverpfad in
die Datenbank und zurueck. Seit dem 10.08.2026 haengt die Einloesung der
Einladung davor (app/einladung.py, K20): der Link aus der Mail schaltet das
Konto frei, danach beginnt der Weg oben. Seit dem 11.08.2026 haengt der
Versand davor (app/einladung_senden.py, K20): der Verwaltende laedt ein, das
Konto entsteht, der Link geht per Mail hinaus.

Was hier NICHT liegt, steht im Bauzettel der Scheibe unter "offen" -- die
MITGLIEDSCHAFT (Blatt 62 ist nicht entschieden; ohne sie findet
app/sitzung.py kein Portal, und das eingeladene Konto kommt nach der
Einloesung noch nicht durch EN-01), die Kennung `user_code` (K20-M24 haengt
an der Rolle und damit an derselben Frage), erneute Anmeldung bei heiklen
Aenderungen (K03-M18), Zeilenschutz und alles hinter der Startseite.
"""
