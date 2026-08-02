#!/bin/bash
# Die Einladungsschranke sitzt auf der Tabelle invitation, nicht auf actor.
# Geprueft wird die invite_domain des Mandanten, zu dem das EINGELADENE Konto gehoert.
neg() {
  name="$1"; sql="$2"; erwartet="$3"
  out=$(docker exec freiraum-pilot psql -U postgres -d freiraum -c "$sql" 2>&1)
  if echo "$out" | grep -q "ERROR"; then
    if echo "$out" | grep -q "$erwartet"; then echo "  OK   $name"
    else echo "  WARN $name — anderer Grund:"; echo "$out" | grep ERROR | head -1 | sed 's/^/        /'; fi
  else echo "  FEHLGESCHLAGEN  $name — DURCHGELAUFEN"; fi
}
pos() {
  name="$1"; sql="$2"
  out=$(docker exec freiraum-pilot psql -U postgres -d freiraum -c "$sql" 2>&1)
  if echo "$out" | grep -q "ERROR"; then echo "  FEHLGESCHLAGEN  $name — abgewiesen:"; echo "$out" | grep ERROR | head -1 | sed 's/^/        /'
  else echo "  OK   $name — angenommen"; fi
}

echo "Einladungsschranke des Betreiber-Mandanten (invite_domain = exmachinai.com)"
pos "Einladung an eine Adresse der eigenen Domaene" \
  "INSERT INTO invitation (actor_id,portal_code,mail,token_hash,expires_at) SELECT id,'EXMA','michael.veil@exmachinai.com','h1',now()+interval '24 hours' FROM actor WHERE user_code='EXMA-ADM-0001';"
neg "Einladung an eine fremde Domaene" \
  "INSERT INTO invitation (actor_id,portal_code,mail,token_hash,expires_at) SELECT id,'EXMA','fremd@example.org','h2',now()+interval '24 hours' FROM actor WHERE user_code='EXMA-ADM-0001';" \
  "Nur Adressen der Domaene"
neg "Einladung mit ueberschrittener Frist (>24 h)" \
  "INSERT INTO invitation (actor_id,portal_code,mail,token_hash,expires_at) SELECT id,'EXMA','michael.veil@exmachinai.com','h3',now()+interval '48 hours' FROM actor WHERE user_code='EXMA-ADM-0001';" \
  "Gueltigkeit"
neg "Adresse, die die Domaene nur als Teilzeichenkette enthaelt" \
  "INSERT INTO invitation (actor_id,portal_code,mail,token_hash,expires_at) SELECT id,'EXMA','x@evil-exmachinai.com','h4',now()+interval '24 hours' FROM actor WHERE user_code='EXMA-ADM-0001';" \
  "Nur Adressen der Domaene"
echo
echo -n "  Zeilen in invitation (erwartet 1 — nur die zulaessige): "
docker exec freiraum-pilot psql -U postgres -d freiraum -tAc "select count(*) from invitation;"
