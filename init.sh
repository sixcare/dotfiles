#! /bin/bash
set -euo pipefail

# Zsh
sudo apt-get update
sudo apt-get -y install zsh

# Oh My zsh
sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)" "" --unattended
sudo usermod -s /usr/bin/zsh "$USER"

sed -i 's/^plugins=(.*/plugins=(git ssh-agent)/g' ~/.zshrc
sed -i 's/^ZSH_THEME=.*/ZSH_THEME="robbyrussell"/g' ~/.zshrc
# shellcheck disable=SC2016
printf 'export GPG_TTY=$(tty)\n' >> ~/.zshrc

zsh install.sh
