#!/bin/bash
# Negativfaelle der Migration 260802. Jeder muss an SEINER Bedingung scheitern.
DB="${1:-freiraum-pilot}"
neg() {
  name="$1"; sql="$2"; erwartet="$3"
  out=$(docker exec "$DB" psql -U postgres -d freiraum -c "$sql" 2>&1)
  if echo "$out" | grep -q "ERROR"; then
    if echo "$out" | grep -q "$erwartet"; then echo "  OK   $name — abgewiesen durch $erwartet"
    else echo "  WARN $name — abgewiesen, aber nicht durch $erwartet:"; echo "$out" | grep ERROR | head -1 | sed 's/^/        /'; fi
  else echo "  FEHLGESCHLAGEN  $name — DURCHGELAUFEN"; fi
}
pos() {
  name="$1"; sql="$2"
  out=$(docker exec "$DB" psql -U postgres -d freiraum -c "$sql" 2>&1)
  if echo "$out" | grep -q "ERROR"; then echo "  FEHLGESCHLAGEN  $name:"; echo "$out" | grep ERROR | head -1 | sed 's/^/        /'
  else echo "  OK   $name"; fi
}
q() { docker exec "$DB" psql -U postgres -d freiraum -tAc "$1"; }

echo "Migration 260802 · Negativfaelle"
neg "N1 Code mit Frist ueber zehn Minuten" \
  "INSERT INTO login_code (actor_id,code_hash,expires_at) SELECT id,'h',now()+interval '30 minutes' FROM actor WHERE user_code='EXMA-ADM-0001';" \
  "login_code_frist"
neg "N2 sechster Fehlversuch" \
  "INSERT INTO login_code (actor_id,code_hash,expires_at,failed_count) SELECT id,'h',now()+interval '5 minutes',6 FROM actor WHERE user_code='EXMA-ADM-0001';" \
  "login_code_fehlversuche"
neg "N4 Fehlschlag ohne Begruendung" \
  "INSERT INTO mail_delivery (kind,recipient,sender,status) VALUES ('ANMELDECODE','x@exmachinai.com','noreply@freiraum.top','FEHLER');" \
  "mail_fehler_braucht_grund"

echo
echo "Abnahmekriterium B2 · zweimal anmelden, zweimal frischer Code"
q "DELETE FROM login_code;" >/dev/null
pos "erster Code ausgestellt" \
  "INSERT INTO login_code (actor_id,code_hash,expires_at) SELECT id,'hash-code-1',now()+interval '10 minutes' FROM actor WHERE user_code='EXMA-ADM-0001';"
pos "erster Code verbraucht" \
  "UPDATE login_code SET consumed_at=now() WHERE code_hash='hash-code-1';"
pos "zweiter Code ausgestellt" \
  "INSERT INTO login_code (actor_id,code_hash,expires_at) SELECT id,'hash-code-2',now()+interval '10 minutes' FROM actor WHERE user_code='EXMA-ADM-0001';"
echo -n "  erster Code nach Verwendung noch gueltig? "
g=$(q "select count(*) from login_code where code_hash='hash-code-1' and consumed_at is null and superseded_at is null and expires_at>now();")
[ "$g" = "0" ] && echo "nein — wertlos, wie gefordert" || echo "JA — FEHLER"
echo -n "  offene Codes je Konto (erwartet 1): "; q "select count(*) from login_code where consumed_at is null and superseded_at is null;"

echo
echo "N3 · ein neuer Code entwertet den aelteren automatisch"
q "DELETE FROM login_code;" >/dev/null
q "INSERT INTO login_code (actor_id,code_hash,expires_at) SELECT id,'alt',now()+interval '10 minutes' FROM actor WHERE user_code='EXMA-ADM-0001';" >/dev/null
q "INSERT INTO login_code (actor_id,code_hash,expires_at) SELECT id,'neu',now()+interval '10 minutes' FROM actor WHERE user_code='EXMA-ADM-0001';" >/dev/null
alt=$(q "select coalesce(superseded_at::text,'OFFEN') from login_code where code_hash='alt';")
echo -n "  alter Code: "; [ "$alt" = "OFFEN" ] && echo "noch offen — FEHLER" || echo "entwertet um $alt"
echo -n "  offene Codes (erwartet 1): "; q "select count(*) from login_code where consumed_at is null and superseded_at is null;"
