#! /usr/bin/bash

set -o pipefail

readarray -t INTERFACES < <(ip -details -j l show type wireguard | jq -r '.[]["ifname"]')

if [ ${#INTERFACES[@]} -eq 0 ]; then
  printf "%s\n" "{\"text\":\"󰅛 X\",\"tooltip\":\"No WireGuard interface detected\"}"
  exit 0
fi

TOOLTIP_TEXT=$"WireGuard connected to ${#INTERFACES[@]} interface(s)"
for INTERFACE in "${INTERFACES[@]}"; do
    ENDPOINT=0
    ENDPOINT=$(grep Endpoint /etc/wireguard/"${INTERFACE}".conf)
    if [[ "${ENDPOINT}" != 0 ]]; then
      TOOLTIP_TEXT+=$" ${INTERFACE}(${ENDPOINT##*= })"
    fi
done

printf "%s\n" "{\"text\":\"󰒄 \",\"tooltip\":\"${TOOLTIP_TEXT}\"}"
exit 0
