# Vertrag 3 · Zoom 200 Prozent — GESPERRT, kein Prüffall gebaut

**18.08.2026 · blinder Prüf-Agent · Zustand nach K23-M22: GESPERRT (nicht messbar)**

Hier steht kein Prüffall, und das ist die Aussage dieser Datei. *Ein Fall, der immer
besteht, ist schädlicher als kein Fall* — deshalb ist keiner gebaut, sondern aufgeschrieben,
was gemessen werden müsste und was dafür fehlt.

---

## 1 · Der Vertrag im Wortlaut

> Bis 200 % Vergrösserung entsteht kein Informationsverlust und kein waagerechter
> Rollbalken (WCAG 1.4.10, K16-M21). Prüfbar: Fenster auf 1280 px, Zoom 200 % —
> entspricht 640 px Breite; kein Inhalt darf verschwinden oder abgeschnitten sein.

Vertrag 3 aus E-5, gezeichnet am 18.08.2026.

Angrenzend, gleicher Gegenstand:

* **K19-M13** — „Jeder Bildschirm MUSS … einen verlustfreien schmalen Darstellungsmodus
  besitzen." (`nachweise/klauselregister/register.json`, Herkunft
  `260801_FREIRAUM_K19_Build-Referenz_v1.3.md:53`)
* **K19 Abschn. 5.1** — „Bei schmaler Ansicht folgt die rechte Arbeitsfläche unter dem
  Gespräch; Reihenfolge, Namen, Hinweise und Aktionen bleiben vollständig."
  (`schema/K19_build_referenz.md`, Abschn. 5.1)
* **K16-M21** — „Sprache, Zoom und Kontrast MUSS die Oberfläche sofort umsetzen. Sie sind
  reine Darstellung." (Klauselregister, Herkunft
  `260801_FREIRAUM_K16_Bedien-Standard_v1.3.md:78`)

---

## 2 · Was gemessen werden müsste

Der Vertrag zerfällt in vier Aussagen. Jede ist für sich entscheidbar — **wenn** ein
Werkzeug die Seite bei 640 px CSS-Breite tatsächlich setzt.

| Nr. | Aussage | Messgrösse |
|---|---|---|
| Z1 | kein waagerechter Rollbalken | bei Ansichtsbreite 640 px gilt `document.documentElement.scrollWidth <= clientWidth`; ebenso für jeden Block, der nicht ausdrücklich als waagerecht rollbar gebaut ist |
| Z2 | kein Inhalt verschwindet | die Menge des sichtbaren Textes bei 640 px ist gleich der bei 1280 px — gemessen als Menge der Textknoten mit `getBoundingClientRect().width > 0` und `visibility != hidden` |
| Z3 | kein Inhalt ist abgeschnitten | kein Element mit `overflow: hidden` hat bei 640 px `scrollWidth > clientWidth`; kein Textkasten hat `getBoundingClientRect().right > 640` |
| Z4 | Reihenfolge, Namen, Hinweise und Aktionen bleiben vollständig (K19 Abschn. 5.1) | die Folge der Kastenelemente aus `pruefungen/klauseln/k19_kasten_lauf.sh` ist bei 640 px dieselbe wie bei 1280 px |

Z4 ist der einzige Teil, für den in `pruefungen/` bereits ein Messwerkzeug steht — es misst
aber den **ausgelieferten Text**, nicht den **gesetzten Aufriss**. Ohne Layout ändert sich
der Text bei 640 px nicht, und der Fall bestünde immer. **Deshalb ist er nicht gebaut.**

---

## 3 · Was dafür fehlt — gemessen, nicht vermutet

Alle vier Aussagen setzen dasselbe voraus: **etwas, das CSS anwendet und Kästen ausrechnet.**
Ein HTML-Rumpf allein trägt keine Breite; die Aussage „640 px" entsteht erst im Satz.

Gemessen am 18.08.2026 in dieser Umgebung:

```
for c in playwright chromedriver geckodriver puppeteer google-chrome \
         chromium chromium-browser firefox wkhtmltoimage; do command -v $c; done
    -> keines vorhanden

python3 -c "import playwright | selenium | pyppeteer | weasyprint | cssutils | tinycss2 | bs4"
    -> keines vorhanden

grep -iE "playwright|selenium|axe|pa11y|browser" requirements.txt
    -> kein Browserwerkzeug
```

Es fehlen damit **drei** Dinge, und keines davon kann dieser Lauf sich selbst beschaffen:

1. **Eine Satzmaschine.** Kein Browser ohne Fenster, kein Treiber, keine Satzbibliothek,
   kein CSS-Leser. Auf dem Rechner besteht ein `/Applications/Google Chrome.app` — das ist
   der Browser eines Menschen, kein wiederholbares Messwerkzeug für einen Prüffall und in
   der CI nicht vorhanden. Ein Fall, der ein Programmfenster aufmacht, läuft in Tor 1 nicht.
2. **Eine ausgelieferte Seite.** Der blinde Arbeitsbaum führt kein `app/` (CLAUDE.md
   Abschn. 3) und kann deshalb keinen Server starten. Das ist Absicht, kein Mangel — es
   heisst nur, dass dieser Fall hier auch dann nicht liefe, wenn die Satzmaschine da wäre.
3. **Eine gezeichnete Toleranz.** „Kein waagerechter Rollbalken" ist beim Satz nie
   pixelgenau: Rundung auf Bruchteile erzeugt regelmässig ein bis zwei Pixel Überhang, die
   kein Mensch als Rollbalken sieht. Welche Abweichung noch keine Verletzung ist, sagt
   weder der Vertrag noch K16 noch K19. **Wer sie selbst setzt, setzt einen Prüfwert** —
   das darf kein Agent (K23-D05, CLAUDE.md Abschn. 6).

---

## 4 · Was ohne Satzmaschine messbar wäre — und warum es hier nicht steht

Ohne Layout liessen sich Anzeichen messen: ob die Seite ein
`<meta name="viewport">` trägt, ob in Formatangaben feste Pixelbreiten stehen, ob ein
`overflow-x` gesetzt ist. Das sind **Anzeichen, nicht der Vertrag**:

* Eine Seite kann alle drei Anzeichen erfüllen und bei 640 px trotzdem waagerecht rollen —
  eine einzige zu lange, nicht umbrechbare Zeichenkette genügt.
* Eine Seite kann alle drei verletzen und bei 640 px trotzdem verlustfrei sein.

Ein Fall, der ein Anzeichen misst und den Vertrag meldet, senkt den Prüfwert, damit ein Lauf
besteht — genau das, was K23-D05 verbietet. Er wäre ausserdem der Fehler vom 02.08.2026 in
neuer Gestalt: ein bestandener Test, der nichts misst.

---

## 5 · Zustand und was ihn auflösen würde

**Zustand: GESPERRT** (K23-M22 — was nicht gemessen werden konnte, ist gesperrt, nie
bestanden). Der Vertrag ist **nicht** verletzt und **nicht** erfüllt; er ist ungemessen.
Über den Bau sagt diese Datei nichts.

Aufgelöst ist die Sperre, sobald **alle drei** Stücke aus Abschn. 3 vorliegen:

1. eine Satzmaschine, die in Tor 1 ohne Fenster läuft, mit Version im Testmanifest
   (K23-M18, Glied 7);
2. eine Umgebung, in der die Seiten ausgeliefert werden — der blinde Arbeitsbaum ist es
   nicht;
3. eine gezeichnete Toleranz für Z1 und Z3, entschieden von einem Menschen.

Fehlt eines davon, bleibt die Sperre. Das ist ein gültiges Ergebnis.

---

*Erstellt am 18.08.2026. Die Werkzeugprobe in Abschn. 3 ist an diesem Tag in dieser
Umgebung ausgeführt worden; die Klauselwortlaute stammen aus
`nachweise/klauselregister/register.json` und `schema/K19_build_referenz.md`, beide am
selben Tag gelesen.*
