#!/usr/bin/env bash

set -euo pipefail


VERSION="stable"
DOWNLOAD_URL="https://discord.com/api/download/stable?platform=linux&format=deb"

if [ ! "$VERSION" ]; then
    printf "%s\n" "❌ Failed to get version" 1>&2 
fi

if [ ! "$DOWNLOAD_URL" ]; then
    printf "%s\n" "❌ Failed to get download url" 1>&2 
fi

printf "%s\n" "⬇️ Downloading version ${VERSION}"
curl -fsLo "/tmp/discord-${VERSION}.deb" "${DOWNLOAD_URL}"

printf "%s\n" "📦 Installing"
doas dpkg -i "/tmp/discord-${VERSION}.deb"

printf "%s\n" "📦 Cleaning up"
rm "/tmp/discord-${VERSION}.deb"

printf "%s\n" "✅ Done!"
