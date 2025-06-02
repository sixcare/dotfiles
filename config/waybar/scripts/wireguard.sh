#! /usr/bin/bash

set -o pipefail

readarray -t INTERFACES < <(ip -details -j l show type wireguard | jq -r '.[] | select ( . != {}) ["ifname"]')

if [ ${#INTERFACES[@]} -eq 0 ]; then
  printf "%s\n" "{\"text\":\"󰅛 X\",\"tooltip\":\"No WireGuard interface detected\"}"
  exit 0
fi

i=0
IFENDPOINTS=()
for INTERFACE in "${INTERFACES[@]}"; do
    ENDPOINT=0
    ENDPOINT=$(grep -s Endpoint /etc/wireguard/"${INTERFACE}".conf)
    if [[ "${ENDPOINT}" == "" ]]; then
      continue
    fi

    if [[ "${ENDPOINT}" != 0 ]]; then
      (( i+=1 ))
      IFENDPOINTS+=($" ${INTERFACE}(${ENDPOINT##*= })")
    fi
done

TOOLTIP_TEXT=$(printf "Connected to ${i} WireGuard interface(s)%s" "${IFENDPOINTS[@]}")

if [[ "${i}" == 0 ]]; then
  printf "%s\n" "{\"text\":\"󰅛 X\",\"tooltip\":\"Failed to find wireguard interface\"}"
  exit 0
fi

printf "%s\n" "{\"text\":\"󰒄 \",\"tooltip\":\"${TOOLTIP_TEXT}\"}"
exit 0
