#! /usr/bin/bash

set -o pipefail

WG_SERVERS=(
  no-osl-wg-001
  no-osl-wg-002
  no-osl-wg-003
  no-osl-wg-004
  no-osl-wg-005
  no-osl-wg-006
)
INTERFACE=NULL

for i in "${!WG_SERVERS[@]}"; do
  if ip link show dev "${WG_SERVERS[$i]}" &>/dev/null; then
    INTERFACE=${WG_SERVERS[$i]}
    break
  fi
done

if [[ ${INTERFACE} == NULL ]]; then
  printf "%s\n" "{\"text\":\"󰅛 X\",\"tooltip\":\"No WireGuard interface detected\"}"
  exit 0
fi

ENDPOINT=$(doas wg show | grep 'endpoint:')
ENDPOINT_EXEC_STATUS=$?
if [[ ${ENDPOINT_EXEC_STATUS} != 0 ]]; then
  printf "%s\n" "{\"text\":\"󰅛 X\",\"tooltip\":\"Failed to get WireGuard status\"}"
  exit 0
fi
ENDPOINT=${ENDPOINT##*: }

printf "%s\n" "{\"text\":\"󰒄 \",\"tooltip\":\"WireGuard connected to ${INTERFACE} (${ENDPOINT})\"}"
exit 0
