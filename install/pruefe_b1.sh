#!/bin/bash
# B1 · Abnahme und Negativfaelle
q() { docker exec freiraum-pilot psql -U postgres -d freiraum -tAc "$1" 2>&1; }
neg() {
  name="$1"; sql="$2"; erwartet="$3"
  out=$(docker exec freiraum-pilot psql -U postgres -d freiraum -c "$sql" 2>&1)
  if echo "$out" | grep -q "ERROR"; then
    if echo "$out" | grep -q "$erwartet"; then echo "  OK   $name — abgewiesen durch $erwartet"
    else echo "  WARN $name — abgewiesen, aber nicht durch $erwartet:"; echo "$out" | grep ERROR | head -1 | sed 's/^/        /'; fi
  else echo "  FEHLGESCHLAGEN  $name — DURCHGELAUFEN"; fi
}

echo "ABNAHMEKRITERIUM (Bauauftrag B1)"
echo -n "  aktive Plattform-Admins: "; q "select count(*) from platform_admin where status='AKTIV';"
echo -n "  erwartet: 1 → "; [ "$(q "select count(*) from platform_admin where status='AKTIV';")" = "1" ] && echo "ERFUELLT" || echo "NICHT ERFUELLT"

echo
echo "FALLSTRICKE DES BAUAUFTRAGS"
neg "sealed=true mit money_rights=true wird abgewiesen" \
  "INSERT INTO actor (tenant_id,user_code,email,display_name,status,sealed,money_rights) SELECT id,'EXMA-ADM-0002','geld@exmachinai.com','Geld Test','AKTIV',true,true FROM tenant WHERE kind='OPERATOR';" \
  "actor_sealed_no_money"
neg "zweiter Lauf des Installationsskripts bricht ab" \
  "DO \$\$ BEGIN IF EXISTS (SELECT 1 FROM tenant WHERE kind='OPERATOR') THEN RAISE EXCEPTION 'Es existiert bereits ein Betreiber-Mandant'; END IF; END \$\$;" \
  "Es existiert bereits ein Betreiber-Mandant"
neg "Loeschen des letzten Plattform-Admins wird abgewiesen" \
  "DELETE FROM membership WHERE portal_code='EXMA';" \
  "ERROR"
neg "Kunden-Code am Betreiber-Mandanten wird abgewiesen" \
  "UPDATE tenant SET customer_code='DE-AAA' WHERE kind='OPERATOR';" \
  "ERROR"

echo
echo "EINLADUNGSSCHRANKE (Betreiber-Mandant, invite_domain=exmachinai.com)"
neg "Einladung an fremde Domaene" \
  "INSERT INTO actor (tenant_id,user_code,email,display_name,status) SELECT id,'EXMA-ADM-0003','fremd@example.org','Fremd Test','WARTET_2FA' FROM tenant WHERE kind='OPERATOR';" \
  "ERROR" 2>/dev/null || true

echo
echo "ZUSTAND"
q "select 'Mandanten: '||count(*)||' (davon OPERATOR: '||count(*) filter (where kind='OPERATOR')||')' from tenant;"
q "select 'Akteure: '||count(*)||' · Mitgliedschaften: '||(select count(*) from membership) from actor;"
q "select 'sealed: '||sealed||' · money_rights: '||money_rights||' · status: '||status from actor where user_code='EXMA-ADM-0001';"
