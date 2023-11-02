#! /bin/zsh

set -euo pipefail

log() {
    printf "\(°^°)/ $(date -Ins) » %s\n" $1
}

log "Packages"
doas apt-get update
doas apt-get install -y ca-certificates curl gnupg unzip build-essential htop bmon net-tools python3-venv

mkdir -p ~/Downloads/

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
doas apt-get install -y sway swaybg swayidle swaylock waybar
mkdir -p ~/.config/{sway,foot}
curl -fsSLo ~/.config/sway/config https://raw.githubusercontent.com/sixcare/dotfiles/main/config/swayconfig
curl -fsSLo ~/.config/foot/foot.ini https://raw.githubusercontent.com/sixcare/dotfiles/main/config/foot.ini
mkdir -p ~/.config/waybar/scripts
curl -fsSLo ~/.config/waybar/style.css https://raw.githubusercontent.com/sixcare/dotfiles/main/config/waybar/style.css
curl -fsSLo ~/.config/waybar/config https://raw.githubusercontent.com/sixcare/dotfiles/main/config/waybar/config
curl -fsSLo ~/.config/waybar/mullvad.zsh https://raw.githubusercontent.com/sixcare/dotfiles/main/config/waybar/scripts/mullvad.zsh

# Podman
log "Podman"
doas apt-get install -y podman

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

# Neovim
log "Neovim"
doas curl -fsSLo /usr/local/bin/nvim https://github.com/neovim/neovim/releases/latest/download/nvim.appimage
doas chmod +x /usr/local/bin/nvim

# nvim
log "nvim"
[[ -d ~/.config/nvim ]] || git clone --depth 1 https://github.com/AstroNvim/AstroNvim ~/.config/nvim

# Spotify
log "Spotify"
curl -fsSL https://download.spotify.com/debian/pubkey_7A3A762FAFD4A51F.gpg | doas gpg --yes --dearmor --yes -o /etc/apt/trusted.gpg.d/spotify.gpg
echo "deb http://repository.spotify.com stable non-free" | doas tee /etc/apt/sources.list.d/spotify.list
doas apt-get update
doas apt-get install -y spotify-client

# NVM
log "NVM"
curl -fsSLo- https://raw.githubusercontent.com/nvm-sh/nvm/v0.39.5/install.sh | bash
export NVM_DIR="$([ -z "${XDG_CONFIG_HOME-}" ] && printf %s "${HOME}/.nvm" || printf %s "${XDG_CONFIG_HOME}/nvm")"
[ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh" # This loads nvm
nvm install node
nvm use node

# ShellCheck
log "ShellCheck"
doas apt-get install -y shellcheck
