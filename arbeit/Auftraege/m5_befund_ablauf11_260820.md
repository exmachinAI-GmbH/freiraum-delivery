# Elfter Befund — **eine gezeichnete Auslegung, und was sie an deinem Lauf ändert**

**20.08.2026 · Nachbesserungsauftrag an den Prüf-Agenten.**

Betroffen ist diesmal **nicht** `gespraech_lauf.sh`, sondern
**`pruefungen/klauseln/zweckbestimmung_lauf.sh`**.

## Was dieser Befund enthält — und was nicht

**Er enthält eine gezeichnete Auslegung.** Also genau das, was dir nach K23-M02 zusteht: der
fachliche Eigentümer sagt, wie eine Klausel zu messen ist.

**Er enthält kein Testergebnis, kein Verhalten der Anwendung, keine Adresse und keine
Antwort eines Bildschirms.** Was dein Lauf beim Fahren gesehen hat, steht hier nicht — und du
brauchst es nicht: aus der Auslegung leitest du dein Ablaufmodell selbst ab.

## Die gezeichnete Auslegung

**EN-04a, der Weg nach der Zweckbestimmung.** Ob zwischen der letzten Zweckantwort und dem
Anlegen der Anwendung ein eigener, folgenloser Schritt liegt, sagt **keine Klausel**. Es ist
am **20.08.2026 entschieden und gezeichnet** worden (E-11, Weg A):

> **Auf dem freien Weg — beide Zweckfragen verneint — ist der Weiterweg zugleich die Anlage.
> Einen zustandsneutralen Zwischenschritt zwischen der letzten Antwort und der Anlage gibt es
> nicht.**
>
> Grundlage: **K01-M27** — *„Eine produktive Anwendungszeile MUSS ausschließlich über den
> serverseitigen Befehl entstehen."* Ein folgenloser Zwischenschritt davor ist nicht verlangt;
> ihn zu fordern hieße, Umfang zu erfinden.

## Was das an deinem Lauf ändert

**Dein Lauf leitet zwei Ziele aus dem Unterschied zweier Zielmengen ab** — einmal der freie
Weg, einmal der Weg mit Treffer in Frage 1. Das setzt voraus, dass beide Wege sich **nach**
dem Weiterweg noch auf **derselben Seite** gegenüberstehen.

**Nach der gezeichneten Auslegung gibt es diese Seite auf dem freien Weg nicht.** Der
Weiterweg **ist** dort die Anlage.

**Und du bestimmst deinen Weiterweg selbst an genau dieser Wirkung** — *„derjenige, nach
dessen Aufruf eine neue Anwendungszeile entstanden ist"*. Damit verbrauchst du den einzigen
Schritt beim Entdecken und misst danach auf dem, was danach kommt. **Deine beiden Ziele
bleiben leer, und dreizehn deiner 27 Fälle melden GESPERRT.**

**Zu tun:** Leite dein Ablaufmodell für EN-04a aus der Auslegung neu ab. Du brauchst dafür
keine zweite Zielmenge auf einer Seite, die es nicht gibt.

> **Nicht durch Absenken lösen.** Die dreizehn Fälle sollen messen, nicht bestehen. Findest du
> für einen von ihnen auch mit dem richtigen Modell keinen Maßstab, gehört er auf **GESPERRT
> mit Begründung** — das ist ein Ergebnis, kein Versagen.

## Ein zweiter Punkt, den du an deiner eigenen Datei prüfen solltest

`nur_pfad()` streicht aus einer Adresse den Abfrageteil. **Dein eigener Kommentar begründet
das mit dem VERGLEICH** — *„der Lauf vergleicht nur Pfade"*.

**An einigen Stellen benutzt du dieselbe Funktion aber nicht zum Vergleichen, sondern zum
FOLGEN**: das gekürzte Ergebnis wird als Adresse für den nächsten Aufruf verwendet. Eine
Weiterleitung kann einen Abfrageteil führen, der zu ihr gehört; wer ihn wegschneidet, folgt
einer anderen Adresse als der, die ihm genannt wurde.

**Sieh dir an, an welchen Stellen du vergleichst und an welchen du folgst**, und ob dieselbe
Funktion für beides richtig ist.

## Die Grenze — unverändert

- **Ändere nichts an der fachlichen Aussage eines Falles.**
- **Senke keinen Prüfwert und lockere keine Erwartung** (K23-D05).
- **Nimm keinen Fall stillschweigend heraus.**
- Am Ende müssen `bash -n` und `shellcheck -S warning` sauber bleiben.
