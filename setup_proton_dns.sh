#!/usr/bin/env bash
set -euo pipefail

########################################
# Config / env
########################################

ENV_FILE="${ENV_FILE:-.env}"

if [[ -f "$ENV_FILE" ]]; then
  # shellcheck disable=SC1090
  source "$ENV_FILE"
else
  echo "ERROR: Env file '$ENV_FILE' not found."
  echo "Create it and put CF_API_TOKEN, DOMAIN, PROTON_* values in it."
  exit 1
fi

CF_API_TOKEN="${CF_API_TOKEN:-}"
DOMAIN="${DOMAIN:-}"

if [[ -z "$CF_API_TOKEN" || -z "$DOMAIN" ]]; then
  echo "ERROR: CF_API_TOKEN or DOMAIN not set in '$ENV_FILE'."
  exit 1
fi

CF_API_BASE="https://api.cloudflare.com/client/v4"

PROTON_SPF="${PROTON_SPF:-}"
PROTON_VERIFY="${PROTON_VERIFY:-}"

PROTON_DKIM1_HOST="${PROTON_DKIM1_HOST:-}"
PROTON_DKIM1_VALUE="${PROTON_DKIM1_VALUE:-}"

PROTON_DKIM2_HOST="${PROTON_DKIM2_HOST:-}"
PROTON_DKIM2_VALUE="${PROTON_DKIM2_VALUE:-}"

PROTON_DKIM3_HOST="${PROTON_DKIM3_HOST:-}"
PROTON_DKIM3_VALUE="${PROTON_DKIM3_VALUE:-}"

PROTON_DMARC="${PROTON_DMARC:-}"

########################################
# Find Zone ID
########################################

echo "Looking up Zone ID for ${DOMAIN}..."

ZONE_ID=$(
  curl -s -X GET "${CF_API_BASE}/zones?name=${DOMAIN}&status=active" \
    -H "Authorization: Bearer ${CF_API_TOKEN}" \
    -H "Content-Type: application/json" \
  | jq -r '.result[0].id'
)

if [[ "$ZONE_ID" == "null" || -z "$ZONE_ID" ]]; then
  echo "ERROR: Could not find active zone for ${DOMAIN}."
  exit 1
fi

echo "Found Zone ID: ${ZONE_ID}"
echo

########################################
# Helpers
########################################

delete_records_by_type_and_name() {
  local type="$1"
  local name="$2"

  echo "Looking for existing ${type} records for ${name}..."

  local resp ids
  resp=$(
    curl -s -X GET \
      "${CF_API_BASE}/zones/${ZONE_ID}/dns_records?type=${type}&name=${name}&per_page=100" \
      -H "Authorization: Bearer ${CF_API_TOKEN}" \
      -H "Content-Type: application/json"
  )

  ids=$(echo "$resp" | jq -r '.result[].id')

  if [[ -z "$ids" ]]; then
    echo "  None found."
    echo
    return
  fi

  echo "  Found records: ${ids}"
  for id in $ids; do
    echo "  Deleting record id=${id}..."
    curl -s -X DELETE "${CF_API_BASE}/zones/${ZONE_ID}/dns_records/${id}" \
      -H "Authorization: Bearer ${CF_API_TOKEN}" \
      -H "Content-Type: application/json" \
    | jq -r '.success' >/dev/null
  done

  echo "  Done deleting ${type} records for ${name}."
  echo
}

create_record() {
  local type="$1"
  local name="$2"
  local content="$3"
  local priority="${4:-}"
  local proxied="${5:-false}"

  echo "Creating ${type} record: ${name} -> ${content} (priority=${priority:-N/A}, proxied=${proxied})"

  local data
  if [[ "$type" == "MX" && -n "$priority" ]]; then
    data=$(cat <<EOF
{
  "type": "${type}",
  "name": "${name}",
  "content": "${content}",
  "ttl": 3600,
  "priority": ${priority},
  "proxied": false
}
EOF
)
  else
    data=$(cat <<EOF
{
  "type": "${type}",
  "name": "${name}",
  "content": "${content}",
  "ttl": 3600,
  "proxied": ${proxied}
}
EOF
)
  fi

  echo "$data" | \
    curl -s -X POST "${CF_API_BASE}/zones/${ZONE_ID}/dns_records" \
      -H "Authorization: Bearer ${CF_API_TOKEN}" \
      -H "Content-Type: application/json" \
      --data @- \
    | jq .

  echo
}

########################################
# 1) MX records (Proton inbound)
########################################

echo "Cleaning up existing MX records for ${DOMAIN}..."
delete_records_by_type_and_name "MX" "${DOMAIN}"

echo "Creating Proton MX records..."
create_record "MX" "${DOMAIN}" "mail.protonmail.ch" 10
create_record "MX" "${DOMAIN}" "mailsec.protonmail.ch" 20

########################################
# 2) SPF + verification TXT
########################################

if [[ -n "$PROTON_SPF" ]]; then
  echo "Cleaning up existing Proton SPF TXT (if any)..."

  # Delete TXT records at root that match the current PROTON_SPF exactly
  resp_txt=$(
    curl -s -X GET \
      "${CF_API_BASE}/zones/${ZONE_ID}/dns_records?type=TXT&name=${DOMAIN}&per_page=100" \
      -H "Authorization: Bearer ${CF_API_TOKEN}" \
      -H "Content-Type: application/json"
  )

  ids_spf=$(echo "$resp_txt" | jq --arg v "$PROTON_SPF" -r '.result[] | select(.content == $v) | .id')

  for id in $ids_spf; do
    echo "Deleting old SPF TXT record id=${id}..."
    curl -s -X DELETE "${CF_API_BASE}/zones/${ZONE_ID}/dns_records/${id}" \
      -H "Authorization: Bearer ${CF_API_TOKEN}" \
      -H "Content-Type: application/json" \
    | jq -r '.success' >/dev/null
  done

  echo "Creating SPF TXT for ${DOMAIN}..."
  create_record "TXT" "${DOMAIN}" "${PROTON_SPF}"
fi

if [[ -n "$PROTON_VERIFY" ]]; then
  echo "Cleaning up existing Proton verification TXT (if any)..."

  resp_txt2=$(
    curl -s -X GET \
      "${CF_API_BASE}/zones/${ZONE_ID}/dns_records?type=TXT&name=${DOMAIN}&per_page=100" \
      -H "Authorization: Bearer ${CF_API_TOKEN}" \
      -H "Content-Type: application/json"
  )

  ids_verify=$(echo "$resp_txt2" | jq --arg v "$PROTON_VERIFY" -r '.result[] | select(.content == $v) | .id')

  for id in $ids_verify; do
    echo "Deleting old verification TXT id=${id}..."
    curl -s -X DELETE "${CF_API_BASE}/zones/${ZONE_ID}/dns_records/${id}" \
      -H "Authorization: Bearer ${CF_API_TOKEN}" \
      -H "Content-Type: application/json" \
    | jq -r '.success' >/dev/null
  done

  echo "Creating Proton verification TXT for ${DOMAIN}..."
  create_record "TXT" "${DOMAIN}" "${PROTON_VERIFY}"
fi

########################################
# 3) DKIM CNAMEs
########################################

setup_dkim() {
  local host="$1"
  local value="$2"

  if [[ -z "$host" || -z "$value" ]]; then
    return
  fi

  local fqdn="${host}.${DOMAIN}"

  echo "Cleaning up existing DKIM CNAME for ${fqdn}..."
  delete_records_by_type_and_name "CNAME" "${fqdn}"

  echo "Creating DKIM CNAME: ${fqdn} -> ${value}"
  create_record "CNAME" "${fqdn}" "${value}" "" "false"
}

setup_dkim "$PROTON_DKIM1_HOST" "$PROTON_DKIM1_VALUE"
setup_dkim "$PROTON_DKIM2_HOST" "$PROTON_DKIM2_VALUE"
setup_dkim "$PROTON_DKIM3_HOST" "$PROTON_DKIM3_VALUE"

########################################
# 4) DMARC (optional)
########################################

if [[ -n "$PROTON_DMARC" ]]; then
  local_dmarc_host="_dmarc.${DOMAIN}"
  echo "Cleaning up existing DMARC TXT for ${local_dmarc_host}..."
  delete_records_by_type_and_name "TXT" "${local_dmarc_host}"

  echo "Creating DMARC TXT: ${local_dmarc_host} -> ${PROTON_DMARC}"
  create_record "TXT" "${local_dmarc_host}" "${PROTON_DMARC}"
fi

echo "Done. Proton Mail DNS records configured for ${DOMAIN}."
echo "Check from Proton's Domain settings and with:"
echo "  dig MX ${DOMAIN} +short"
echo "  dig TXT ${DOMAIN} +short"
echo "  dig CNAME protonmail._domainkey.${DOMAIN} +short"

