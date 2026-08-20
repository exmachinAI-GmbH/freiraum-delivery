# Achter Befund — **ein Fall.** Und danach ist der Lauf durch

**20.08.2026 · Nachbesserungsauftrag an den Prüf-Agenten.**

## Was getragen hat

**Der Lauf kommt bis zum Ende und druckt seine Summe.** Beide Schutzstellen halten.

```
davon GESPERRT (nicht messbar, zaehlt nach K23-M22 nicht als bestanden): 115
SUMME: 12 von 128 bestanden, 116 gescheitert (K05-G12 nicht mitgezaehlt)
```

**115 der 116 sind GESPERRT** — also nicht gemessen, nicht fehlgeschlagen. Das ist ein
ehrliches Ergebnis und kein Mangel.

## Der Mangel — genau ein Fall, und er stammt aus deiner eigenen letzten Änderung

```
K01-M01-vorher GESCHEITERT  -- erwartet: gs_isoliert@ traegt den unberuehrten
Ausgangsstand. Gelesen: 'ORIENTIERUNG|DISCOVERY|(Ausgangslage: Name noch nicht gesetzt)'
```

Zeile 1152 erwartet **„ORIENTIERUNG/DISCOVERY/ohne Namen"**. Gelesen wird der Platzhalter, den
**du selbst** in Runde 4 eingeführt hast, weil die Spalte `name` nicht leer bleiben darf.

**Der Fall widerspricht damit deiner eigenen Ausgangslage** — dieselbe Art von Widerspruch wie
bei `gs_ohnecheck@` in Runde 6, nur andersherum: dort war die Prüfung zu streng, hier ist die
Erwartung veraltet.

## Was zu tun ist — und was ausdrücklich **nicht**

Der Fall misst **Isolation**: dass der Stand von `gs_isoliert@` vor und nach allen
Schreibvorgängen **Feld für Feld gleich** ist. Das prüfst du zwei Zeilen weiter mit
`ISOL_VORHER = ISOL_NACHHER` — und dieser Vergleich ist richtig und bleibt.

`K01-M01-vorher` ist die **Vorprüfung** dazu: dass der Ausgangsstand der ist, den deine
Ausgangslage anlegt. Zieh die Erwartung auf den Wert nach, den deine Datei tatsächlich
schreibt.

> **Streiche die Vorprüfung nicht** und wandle sie nicht in `GESPERRT`. Sie hat gerade ihre
> Arbeit getan: sie hat gemerkt, dass Ausgangslage und Erwartung auseinandergelaufen sind.
> Eine Vorprüfung, die man bei der ersten Abweichung entfernt, ist keine.
>
> **Und mach sie nicht beliebig.** Eine Erwartung, die jeden Wert zulässt, würde auch eine
> Ausgangslage durchwinken, die es gar nicht gibt.

## Danach

**Danach ist dieser Lauf durch**: 12 bestanden, 0 fehlgeschlagen, der Rest gesperrt — mit
Begründung je Zeile. Mehr ist heute nicht messbar, und das liegt nicht an dir.

## Die Grenze — unverändert

- **Ändere nichts an der fachlichen Aussage eines Falles.**
- **Senke keinen Prüfwert und lockere keine Erwartung** (K23-D05).
- **Nimm keinen Fall und keine Prüfung stillschweigend heraus.**
