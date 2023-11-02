#! /bin/bash
set -euo pipefail

# Zsh
doas apt-get update
doas apt-get -y install git zsh

# Oh My zsh
sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)" "" --unattended
doas usermod -s /usr/bin/zsh "$USER"

sed -i 's/^plugins=(.*/plugins=(git ssh-agent)/g' ~/.zshrc
sed -i 's/^ZSH_THEME=.*/ZSH_THEME="robbyrussell"/g' ~/.zshrc
# shellcheck disable=SC2016
printf 'export GPG_TTY=$(tty)\n' >> ~/.zshrc

curl -o- https://raw.githubusercontent.com/sixcare/dotfiles/main/install.sh | zsh
