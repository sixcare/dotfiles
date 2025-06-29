#!/usr/bin/env bash

set -euo pipefail

log() {
    printf "$(date -Ins) » %s\n" "$1"
}

# Zsh
log "ZSH"
doas apt-get update
doas apt-get -y install git zsh curl

# Oh My zsh
log "Oh My zsh"
[[ -d ~/.oh-my-zsh ]] || sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)" "" --unattended
doas /usr/sbin/usermod -s /usr/bin/zsh "$USER"

cp ./config/zshrc "${HOME}/.zshrc"

log "Starting install.sh"
zsh ./install.sh
