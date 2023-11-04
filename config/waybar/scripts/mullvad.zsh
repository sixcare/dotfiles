#! /bin/zsh

set -e

if ! mullvad status &>/dev/null ; then
  printf "%s\n" "{\"text\":\"Mullvad is not running\",\"tooltip\":\"Not running man\"}"
  exit 0
fi

MULLVAD_STATUS=$(mullvad status)

if [[ $(print $MULLVAD_STATUS | awk '{print $1}') == 'Connecting' ]]; then
  printf "%s\n" "{\"text\":\"󰛴 \",\"tooltip\":\"${MULLVAD_STATUS}\"}"
  exit 0
fi

if [[ $MULLVAD_STATUS == *"Offline"* || $MULLVAD_STATUS == *"offline"* ]]; then
  printf "%s\n" "{\"text\":\"󰲛 X\",\"tooltip\":\"${MULLVAD_STATUS}\"}"
  exit 0
fi

if [[ $MULLVAD_STATUS == *"Disconnected"* || $MULLVAD_STATUS == *"disconnected"* ]]; then
  printf "%s\n" "{\"text\":\"󰲛 X\",\"tooltip\":\"${MULLVAD_STATUS}\"}"
  exit 0
fi

MULLVAD_SRV=$(print $MULLVAD_STATUS | cut -d' ' -f3)
MULLVAD_IP=$(mullvad relay list | grep -i $MULLVAD_SRV | xargs | awk '{print $2}' | cut -d'(' -f2)

if [[ -z $MULLVAD_SRV ]]; then
  printf "%s\n" "{\"text\":\"󰅛 X\",\"tooltip\":\"${MULLVAD_STATUS}\"}"
else
  printf "%s\n" "{\"text\":\"󰒄 \",\"tooltip\":\"${MULLVAD_STATUS} (${MULLVAD_IP::-1})\"}"
fi
