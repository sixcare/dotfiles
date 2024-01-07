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
    curl
    firefox-esr
    firefox-esr-l10n-en-gb
    firefox-esr-l10n-nb-no
    gnupg
    htop
    jq
    net-tools
    unzip
    pavucontrol
    pulseaudio
    python3-venv
)
doas apt-get update
doas apt-get install -y "${packages[@]}"

mkdir -p ~/Downloads/

# brightnessctl
log "brightnessctl"
doas apt-get install brightnessctl
doas sed -i '/^permit.*brightnessctl/d' /etc/doas.conf
printf "permit nopass :wheel as root cmd /usr/bin/brightnessctl\n" >> /etc/doas.conf

# Mullvad
log "Mullvad"
curl -fsSLo /tmp/mullvad.deb https://mullvad.net/download/app/deb/latest
doas apt-get install -y /tmp/mullvad.deb
rm -f /tmp/mullvad.deb

# Git
log "Git config"
git config --global init.defaultBranch main
git config --global user.name "Are Schjetne"
git config --global user.email sixcare.as@gmail.com

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
mkdir -p ~/.config/{sway,foot}
mkdir -p /usr/share/backgrounds
doas curl -fsSLo /usr/share/backgrounds/background-1920x1080.png https://wallpaper.sixca.re/wallpaper_1920x1080.png
curl -fsSLo ~/.config/sway/config https://raw.githubusercontent.com/sixcare/dotfiles/main/config/swayconfig
curl -fsSLo ~/.config/foot/foot.ini https://raw.githubusercontent.com/sixcare/dotfiles/main/config/foot.ini
## waybar
mkdir -p ~/.config/waybar/scripts
curl -fsSLo ~/.config/waybar/style.css https://raw.githubusercontent.com/sixcare/dotfiles/main/config/waybar/style.css
curl -fsSLo ~/.config/waybar/config https://raw.githubusercontent.com/sixcare/dotfiles/main/config/waybar/config
curl -fsSLo ~/.config/waybar/scripts/mullvad.zsh https://raw.githubusercontent.com/sixcare/dotfiles/main/config/waybar/scripts/mullvad.zsh
chmod +x ~/.config/waybar/scripts/mullvad.zsh
## swaylock
mkdir -p ~/.config/swaylock/
doas curl -fsSLo /usr/share/backgrounds/lockscreen-1920x1080.png https://wallpaper.sixca.re/lockscreen_1920x1080.png
curl -fsSLo ~/.config/swaylock/config https://raw.githubusercontent.com/sixcare/dotfiles/main/config/swaylock/config

# shellcheck disable=SC2016
grep -q '^alias gotosleep=.*' ~/.zshrc && \
    sed -i -e 's/^alias gotosleep=.*/alias gotosleep="swaylock -C $HOME/.config/swaylock/config; systemclt suspend"/g' ~/.zshrc || \
    printf 'alias gotosleep="swaylock -C $HOME/.config/swaylock/config; systemclt suspend"' >> ~/.zshrc

# Podman
log "Podman"
doas apt-get install -y podman

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

# Keepass
log "Keepassxc"
doas apt-get install -y keepassxc

# vscodium
log "vscodium"
curl -fsSL https://gitlab.com/paulcarroty/vscodium-deb-rpm-repo/raw/master/pub.gpg | doas gpg --yes --dearmor -o /usr/share/keyrings/vscodium-archive-keyring.gpg
doas chmod a+r /usr/share/keyrings/vscodium-archive-keyring.gpg

echo 'deb [ signed-by=/usr/share/keyrings/vscodium-archive-keyring.gpg ] https://download.vscodium.com/debs vscodium main' \
    | doas tee /etc/apt/sources.list.d/vscodium.list

doas apt-get update
doas apt-get install -y codium
mkdir -p ~/.config/VSCodium/User
curl -fsSLo ~/.config/VSCodium/User/settings.json https://raw.githubusercontent.com/sixcare/dotfiles/main/config/vscode.json

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
curl -fsSLo ~/.vimrc https://raw.githubusercontent.com/sixcare/dotfiles/main/config/vimrc

# TMUX
log "TMUX"
doas apt-get install -y tmux
curl -fsSLo ~/.tmux.conf https://raw.githubusercontent.com/sixcare/dotfiles/main/config/tmux.conf

# Rust
log "Rust"
sh -c "$(curl -fsSL https://sh.rustup.rs)" "" -y
/home/sixcare/.cargo/bin/rustup component add rust-analyzer

# Neovim
log "Neovim"
doas curl -fsSLo /usr/local/bin/nvim https://github.com/neovim/neovim/releases/latest/download/nvim.appimage
doas chmod +x /usr/local/bin/nvim

# AstroNvim
log "AstroNvim"
[[ -d ~/.config/nvim ]] || git clone --depth 1 https://github.com/AstroNvim/AstroNvim ~/.config/nvim
curl -fsSLo "$HOME"/.config/nvim/init.lua https://raw.githubusercontent.com/sixcare/dotfiles/main/config/nvim/init.lua
curl -fsSLo "$HOME"/.config/nvim/lua/plugins/surround.lua  https://raw.githubusercontent.com/sixcare/dotfiles/main/config/nvim/surround.lua
curl -fsSLo "$HOME"/.config/nvim/lua/plugins/neo-tree.lua  https://raw.githubusercontent.com/sixcare/dotfiles/main/config/nvim/neo-tree.lua

# Spotify
log "Spotify"
curl -fsSL https://download.spotify.com/debian/pubkey_7A3A762FAFD4A51F.gpg | doas gpg --yes --dearmor --yes -o /etc/apt/trusted.gpg.d/spotify.gpg
echo "deb http://repository.spotify.com stable non-free" | doas tee /etc/apt/sources.list.d/spotify.list
doas apt-get update
doas apt-get install -y spotify-client

# NVM
log "NVM"
curl -fsSLo- https://raw.githubusercontent.com/nvm-sh/nvm/v0.39.5/install.sh | bash
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
