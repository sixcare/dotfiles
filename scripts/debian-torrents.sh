#!/usr/bin/env bash

set -euo pipefail


TORRENTS=(
    https://cdimage.debian.org/debian-cd/current/amd64/bt-cd/debian-13.4.0-amd64-netinst.iso.torrent
    https://cdimage.debian.org/debian-cd/current/amd64/bt-cd/debian-edu-13.4.0-amd64-netinst.iso.torrent
    https://cdimage.debian.org/debian-cd/current/amd64/bt-cd/debian-mac-13.4.0-amd64-netinst.iso.torrent
    https://cdimage.debian.org/debian-cd/current/arm64/bt-cd/debian-13.4.0-arm64-netinst.iso.torrent
    https://cdimage.debian.org/debian-cd/current/armhf/bt-cd/debian-13.4.0-armhf-netinst.iso.torrent
    https://cdimage.debian.org/debian-cd/current/ppc64el/bt-cd/debian-13.4.0-ppc64el-netinst.iso.torrent
    https://cdimage.debian.org/debian-cd/current/riscv64/bt-cd/debian-13.4.0-riscv64-netinst.iso.torrent
    https://cdimage.debian.org/debian-cd/current/s390x/bt-cd/debian-13.4.0-s390x-netinst.iso.torrent
    https://cdimage.debian.org/debian-cd/current/amd64/bt-dvd/debian-13.4.0-amd64-DVD-1.iso.torrent
    https://cdimage.debian.org/debian-cd/current/arm64/bt-dvd/debian-13.4.0-arm64-DVD-1.iso.torrent
    https://cdimage.debian.org/debian-cd/current/armhf/bt-dvd/debian-13.4.0-armhf-DVD-1.iso.torrent
    https://cdimage.debian.org/debian-cd/current/ppc64el/bt-dvd/debian-13.4.0-ppc64el-DVD-1.iso.torrent
    https://cdimage.debian.org/debian-cd/current/riscv64/bt-dvd/debian-13.4.0-riscv64-DVD-1.iso.torrent
    https://cdimage.debian.org/debian-cd/current/s390x/bt-dvd/debian-13.4.0-s390x-DVD-1.iso.torrent
)

for t in "${TORRENTS[@]}"; do
    transmission-remote --add "${t}" --labels iso,iso-debian --download-dir /data/1t/downloads/iso/debian
done
