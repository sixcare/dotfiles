#! /bin/bash
set -euo pipefail

# Zsh
doas apt-get update
doas apt-get -y install git zsh

# Oh My zsh

[[ -d ~/.oh-my-zsh ]] || sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)" "" --unattended
doas /usr/sbin/usermod -s /usr/bin/zsh "$USER"

sed -i 's/^plugins=(.*/plugins=(git ssh-agent)/g' ~/.zshrc
sed -i 's/^ZSH_THEME=.*/ZSH_THEME="robbyrussell"/g' ~/.zshrc
grep -q 'export GPG_TTY=.*' myfile && sed -i -e 's/^export GPG_TTY=.*/export GPG_TTY=$(tty)/g' myfile || printf 'export GPG_TTY=$(tty)\n' >> myfile

curl -o- https://raw.githubusercontent.com/sixcare/dotfiles/main/install.sh | zsh
