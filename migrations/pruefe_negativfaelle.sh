#!/bin/bash
# Negativfaelle mit FORMATGUELTIGEN Testcodes (^DE-[A-Z]{3}$).
# Die Vorlage in der Migration nutzt DE-ZN1/ZN2/ZN4 -- die enthalten Ziffern
# und scheitern schon an customer_code_fmt, bevor die zu pruefende Bedingung
# ueberhaupt erreicht wird.
run() {
  name="$1"; sql="$2"; erwartet="$3"
  out=$(docker exec freiraum-pilot psql -U postgres -d freiraum -c "$sql" 2>&1)
  if echo "$out" | grep -q "ERROR"; then
    if echo "$out" | grep -q "$erwartet"; then
      echo "  OK   $name — abgewiesen durch $erwartet"
    else
      echo "  WARN $name — abgewiesen, aber nicht durch $erwartet:"
      echo "$out" | grep ERROR | head -1 | sed 's/^/        /'
    fi
  else
    echo "  FEHLGESCHLAGEN  $name — DURCHGELAUFEN, Bedingung fehlt!"
  fi
}

echo "Negativfaelle mit gueltigem Codeformat:"
run "N1 Kunde ohne Vertragsnachweis" \
  "INSERT INTO tenant (kind,name,customer_code,legal_space) VALUES ('CUSTOMER','N1 Testbank','DE-ZNA','DE');" \
  "customer_needs_avv"
run "N2 Kunde mit nur einer Angabe" \
  "INSERT INTO tenant (kind,name,customer_code,legal_space,avv_datum) VALUES ('CUSTOMER','N2 Testbank','DE-ZNB','DE',DATE '2026-08-01');" \
  "customer_needs_avv"
run "N3 Partner ohne Aufgabe" \
  "INSERT INTO tenant (kind,name,legal_space) VALUES ('PARTNER','N3 Systemhaus','DE');" \
  "partner_needs_aufgabe"
run "N4 Kunde mit Partneraufgabe" \
  "INSERT INTO tenant (kind,name,customer_code,legal_space,avv_datum,avv_aktenzeichen,partner_baut) VALUES ('CUSTOMER','N4 Testbank','DE-ZND','DE',DATE '2026-08-01','AZ-0001',true);" \
  "partner_needs_aufgabe"
echo
echo "Zusatz — der Formatfall selbst, damit er belegt ist:"
run "N5 Kunden-Code mit Ziffer" \
  "INSERT INTO tenant (kind,name,customer_code,legal_space,avv_datum,avv_aktenzeichen) VALUES ('CUSTOMER','N5 Testbank','DE-ZN1','DE',DATE '2026-08-01','AZ-0002');" \
  "customer_code_fmt"
echo
docker exec freiraum-pilot psql -U postgres -d freiraum -tAc "select 'tenant-Zeilen nach allen Negativfaellen: '||count(*) from tenant;"
