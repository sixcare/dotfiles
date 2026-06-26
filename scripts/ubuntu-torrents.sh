#!/usr/bin/env bash

set -euo pipefail


TORRENTS=(
    https://releases.ubuntu.com/26.04/ubuntu-26.04-desktop-amd64.iso.torrent
    https://releases.ubuntu.com/26.04/ubuntu-26.04-live-server-amd64.iso.torrent
)

for t in "${TORRENTS[@]}"; do
    transmission-remote --add "${t}" --labels iso,iso-ubuntu --download-dir /data/1t/downloads/iso/ubuntu
done
