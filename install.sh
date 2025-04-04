#! /usr/bin/bash

set -euo pipefail

log() {
    printf "\(°^°)/ $(date -Ins) » %s\n" "$1"
}

log "Executing install.sh"

log "Packages"
packages=(
    bmon
    build-essential
    ca-certificates
    firefox-esr
    firefox-esr-l10n-en-gb
    firefox-esr-l10n-nb-no
    fwupd
    gnupg
    htop
    jq
    net-tools
    unzip
    pavucontrol
    pulseaudio
    python3-venv
    resolvconf
    wireguard
    wireguard-tools
)
doas apt-get update
doas apt-get install -y "${packages[@]}"

mkdir -p ~/Downloads/

# WireGuard
doas sed -i '/^permit .* sixcare .* wg$/d' /etc/doas.conf
printf "permit nopass sixcare as root cmd wg" >> /etc/doas.conf

# brightnessctl
log "brightnessctl"
doas apt-get install brightnessctl
doas sed -i '/^permit.*brightnessctl/d' /etc/doas.conf
printf "permit nopass :wheel as root cmd /usr/bin/brightnessctl\n" >> /etc/doas.conf

# Git
log "Git config"
git config --global init.defaultBranch main
git config --global user.name "Are Schjetne"
git config --global user.email sixcare.as@gmail.com
git config --global --replace-all core.pager "less -F -X"

# Nerdfonts
log "Nerdfonts"
mkdir -p ~/Downloads/fonts
curl -fsSLo ~/Downloads/SourceCodePro.zip https://github.com/ryanoasis/nerd-fonts/releases/download/v3.0.2/SourceCodePro.zip
unzip ~/Downloads/SourceCodePro.zip -d ~/Downloads/fonts
doas mv ~/Downloads/fonts/*.ttf /usr/local/share/fonts/
rm -rf ~/Downloads/fonts ~/Downloads/SourceCodePro.zip

# Sway
log "Sway"
doas apt-get install -y sway swaybg swayidle swaylock waybar bemenu
mkdir -p ~/.config/sway
mkdir -p /usr/share/backgrounds
cp ./images/wallpaper_1920x1080.png /usr/share/backgrounds/background-1920x1080.png
cp ./config/swayconfig ~/.config/sway/config

## waybar
mkdir -p ~/.config/waybar/scripts
cp ./config/waybar/style.css ~/.config/waybar/style.css
cp ./config/waybar/config ~/.config/waybar/config

# WireGuard Script
cp ./config/waybar/scripts/wireguard.sh ~/.config/waybar/scripts/wireguard.sh
chmod +x ~/.config/waybar/scripts/wireguard.sh

## swaylock
mkdir -p ~/.config/swaylock/
cp ./images/lockscreen_1920x1080.png /usr/share/backgrounds/lockscreen-1920x1080.png
cp config/swaylock/config ~/.config/swaylock/config

# shellcheck disable=SC2016
grep -q '^alias gotosleep=.*' ~/.zshrc && \
    sed -i -e 's/^alias gotosleep=.*/alias gotosleep="swaylock -C $HOME/.config/swaylock/config; systemclt suspend"/g' ~/.zshrc || \
    printf 'alias gotosleep="swaylock -C $HOME/.config/swaylock/config; systemclt suspend"' >> ~/.zshrc


# Docker
curl -fsSL https://download.docker.com/linux/debian/gpg | doas gpg --dearmor -o /usr/share/keyrings/docker.gpg
doas chmod a+r /usr/share/keyrings/docker.gpg
# shellcheck source=/dev/null
echo \
  "deb [arch=$(dpkg --print-architecture) signed-by=/usr/share/keyrings/docker.gpg] https://download.docker.com/linux/debian \
  $(. /etc/os-release && echo "$VERSION_CODENAME") stable" | \
  doas tee /etc/apt/sources.list.d/docker.list > /dev/null
doas apt-get update
doas apt-get install docker-ce docker-ce-cli containerd.io docker-buildx-plugin docker-compose-plugin
doas /usr/sbin/usermod -aG docker "$USER"

# Keepass
log "Keepassxc"
doas apt-get install -y keepassxc

# VS Code
log "VS Code"
curl -fsSL https://packages.microsoft.com/keys/microsoft.asc | doas gpg --yes --dearmor -o /etc/apt/keyrings/packages.microsoft.gpg
echo "deb [arch=amd64,arm64,armhf signed-by=/etc/apt/keyrings/packages.microsoft.gpg] https://packages.microsoft.com/repos/code stable main" | doas tee /etc/apt/sources.list.d/vscode.list
doas apt-get update
doas apt-get install -y code

mkdir -p ~/.config/Code/User
cp ./config/vscode.json ~/.config/Code/User/settings.json

# Signal
log "Signal"
curl -fsSL https://updates.signal.org/desktop/apt/keys.asc | doas gpg --yes --dearmor -o /usr/share/keyrings/signal-desktop-keyring.gpg
doas chmod a+r /usr/share/keyrings/signal-desktop-keyring.gpg

echo 'deb [arch=amd64 signed-by=/usr/share/keyrings/signal-desktop-keyring.gpg] https://updates.signal.org/desktop/apt xenial main' \
  | doas tee /etc/apt/sources.list.d/signal-xenial.list

doas apt-get update
doas apt-get install -y signal-desktop

# VIM
log "VIM"
doas apt-get install -y vim
doas update-alternatives --set editor /usr/bin/vim.basic
cp ./config/vimrc ~/.vimrc

# TMUX
log "TMUX"
doas apt-get install -y tmux
cp ./config/tmux.conf ~/.tmux.conf

# Rust
log "Rust"
sh -c "$(curl -fsSL https://sh.rustup.rs)" "" -y

# shellcheck disable=SC2016
grep -q '^alias rust_init=.*' ~/.zshrc && \
    sed -i -e 's/^alias rust_init=.*/alias rust_init="source <(rustup completions zsh)"\n/g' "$HOME/.zshrc" || \
    printf 'alias rust_init="source <(rustup completions zsh)"\n' >> "$HOME/.zshrc"


# Neovim
log "Neovim"
doas curl -fsSLo /usr/local/bin/nvim https://github.com/neovim/neovim/releases/latest/download/nvim-linux-x86_64.appimage
doas chmod +x /usr/local/bin/nvim

# Spotify
log "Spotify"
curl -fsSL https://download.spotify.com/debian/pubkey_C85668DF69375001.gpg | doas gpg --dearmor --yes -o /etc/apt/trusted.gpg.d/spotify.gpg
echo "deb https://repository.spotify.com stable non-free" | sudo tee /etc/apt/sources.list.d/spotify.list
doas apt-get update
doas apt-get install -y spotify-client

# NVM
log "NVM"
curl -fsSLo- https://raw.githubusercontent.com/nvm-sh/nvm/v0.40.2/install.sh | bash
NVM_DIR="$([ -z "${XDG_CONFIG_HOME-}" ] && printf %s "${HOME}/.nvm" || printf %s "${XDG_CONFIG_HOME}/nvm")"
export NVM_DIR
# shellcheck source=/dev/null
[ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh" # This loads nvm
nvm install node
nvm use node

# ShellCheck
log "ShellCheck"
doas apt-get install -y shellcheck

# network
log "network"
doas apt-get install -y network-manager
doas systemctl start NetworkManager.service
doas systemctl enable NetworkManager.service

# Kitty
log "Kitty"
[[ -d /opt/kitty.app ]] || curl -fsSLo- https://sw.kovidgoyal.net/kitty/installer.sh | doas sh /dev/stdin dest=/opt launch=n
doas ln -fs /opt/kitty.app/bin/kitten /usr/local/bin/kitten
doas ln -fs /opt/kitty.app/bin/kitty /usr/local/bin/kitty

cp /opt/kitty.app/share/applications/kitty.desktop ~/.local/share/applications/
cp /opt/kitty.app/share/applications/kitty-open.desktop ~/.local/share/applications/

sed -i "s|Icon=kitty|Icon=/opt/kitty.app/share/icons/hicolor/256x256/apps/kitty.png|g" ~/.local/share/applications/kitty*.desktop
sed -i "s|Exec=kitty|Exec=/opt/kitty.app/bin/kitty|g" ~/.local/share/applications/kitty*.desktop

doas update-alternatives --install /usr/bin/x-terminal-emulator x-terminal-emulator /usr/local/bin/kitty 10
doas update-alternatives --set x-terminal-emulator /usr/local/bin/kitty


mkdir -p ~/.config/kitty
find /opt/kitty.app/share/doc/kitty/html/_downloads -name "kitty.conf" -exec cp {} ~/.config/kitty/kitty.conf \;
sed -i 's/^# font_family.*/font_family SauceCodePro Nerd Font Mono/g' ~/.config/kitty/kitty.conf
sed -i 's/^# background_opacity.*/background_opacity 0.85/g' ~/.config/kitty/kitty.conf
