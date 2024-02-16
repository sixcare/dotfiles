#! /bin/bash
set -euo pipefail

log() {
    printf "\(°^°)/ $(date -Ins) » %s\n" "$1"
}

# Zsh
log "ZSH"
doas apt-get update
doas apt-get -y install git zsh curl

# Oh My zsh
log "Oh My zsh"
[[ -d ~/.oh-my-zsh ]] || sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)" "" --unattended
doas /usr/sbin/usermod -s /usr/bin/zsh "$USER"

sed -i 's/^plugins=(.*/plugins=(git ssh-agent)/g' ~/.zshrc
sed -i 's/^ZSH_THEME=.*/ZSH_THEME="robbyrussell"/g' ~/.zshrc
# shellcheck disable=SC2016
grep -q 'export GPG_TTY=.*' ~/.zshrc && sed -i -e 's/^export GPG_TTY=.*/export GPG_TTY=$(tty)/g' ~/.zshrc || printf 'export GPG_TTY=$(tty)\n' >> ~/.zshrc

log "Downloading install.sh"
curl -fsSLo- https://raw.githubusercontent.com/sixcare/dotfiles/main/install.sh | zsh
