#!/usr/bin/env bash

set -euo pipefail

VERSION_URL="https://proton.me/download/PassDesktop/linux/x64/version.json"
VERSION_JSON=$(curl -fsL "${VERSION_URL}")


VERSION=$(echo "${VERSION_JSON}" | jq -r '.Releases[0].Version')
SHA=$(echo "${VERSION_JSON}" | jq -r '.Releases[0].File[] | select(.Identifier==".deb (Ubuntu/Debian)") | .Sha512CheckSum')
DOWNLOAD_URL=$(echo "${VERSION_JSON}" | jq -r '.Releases[0].File[] | select(.Identifier==".deb (Ubuntu/Debian)") | .Url')

if [ ! "$VERSION" ]; then
    printf "%s\n" "❌ Failed to get version" 1>&2 
fi

if [ ! "$SHA" ]; then
    printf "%s\n" "❌ Failed to get SHA" 1>&2 
fi

if [ ! "$DOWNLOAD_URL" ]; then
    printf "%s\n" "❌ Failed to get download url" 1>&2 
fi

printf "%s\n" "⬇️ Downloading version ${VERSION}"
curl -fsLo "/tmp/proton-pass-${VERSION}.deb" "${DOWNLOAD_URL}"

printf "%s\n" "🔐 Checking SHA"
echo "${SHA} /tmp/proton-pass-${VERSION}.deb" | sha512sum --check -

printf "%s\n" "📦 Installing"
doas dpkg -i "/tmp/proton-pass-${VERSION}.deb"

printf "%s\n" "📦 Cleaning up"
rm "/tmp/proton-pass-${VERSION}.deb"

printf "%s\n" "✅ Done!"

