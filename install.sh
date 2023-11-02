#! /bin/zsh

set -euo pipefail

sudo apt-get update
sudo apt-get install -y ca-certificates curl gnupg git build-essentials htop bmon net-tools python3-venv
sudo install -m 0755 -d /etc/apt/keyrings

# Git
git config --global init.defaultBranch main
git config --global user.name "Are Schjetne"
git config --global user.email sixcare.as@gmail.com

# Sway
sudo apt-get install -y sway swaybg swayidle swaylock waybar
mkdir -p ~/.config/{sway,waybar,foot}
cp config/swayconfig ~/.config/sway/config
cp -R config/waybar ~/.config/waybar/
cp config/foot.ini ~/.config/foot/foot.ini

# Podman
sudo apt-get install -y podman

# Keepass
sudo apt-get install -y keepassxc

# vscodium
curl -fsSL https://gitlab.com/paulcarroty/vscodium-deb-rpm-repo/raw/master/pub.gpg | sudo gpg --dearmor -o /usr/share/keyrings/vscodium-archive-keyring.gpg
sudo chmod a+r /usr/share/keyrings/vscodium-archive-keyring.gpg

echo 'deb [ signed-by=/usr/share/keyrings/vscodium-archive-keyring.gpg ] https://download.vscodium.com/debs vscodium main' \
    | sudo tee /etc/apt/sources.list.d/vscodium.list

sudo apt-get update 
sudo apt-get install -y codium

# Signal
curl -fsSL https://updates.signal.org/desktop/apt/keys.asc | gpg --dearmor -o /etc/apt/keyrings/signal-desktop-keyring.gpg
chmod a+r /etc/apt/keyrings/signal-desktop-keyring.gpg

echo 'deb [arch=amd64 signed-by=/usr/share/keyrings/signal-desktop-keyring.gpg] https://updates.signal.org/desktop/apt xenial main' \
  | sudo tee /etc/apt/sources.list.d/signal-xenial.list

sudo apt update 
sudo apt install -y signal-desktop

# VIM
sudo apt-get install vim
sudo update-alternatives --set editor /usr/bin/vim.basic
cp config/vimrc ~/.vimrc

# TMUX
sudo apt-get install -y tmux
cp config/tmux.conf ~/.tmux.conf


# Neovim
sudo curl -fsSLo /usr/local/bin/nvim https://github.com/neovim/neovim/releases/latest/download/nvim.appimage
sudo chmod +x /usr/local/bin/nvim

# Nerdfonts
mkdir -p ~/Downloads/fonts
curl -fsSLo ~/Downloads/SourceCodePro.zip https://github.com/ryanoasis/nerd-fonts/releases/download/v3.0.2/SourceCodePro.zip
unzip ~/Downloads/SourceCodePro.zip -d ~/Downloads/fonts
sudo mv ~/Downloads/fonts/*.ttf /usr/local/share/fonts/
rm -rf ~/Downloads/fonts ~/Downloads/SourceCodePro.zip

# nvim
git clone --depth 1 https://github.com/AstroNvim/AstroNvim ~/.config/nvim

# Spotify
curl -sS https://download.spotify.com/debian/pubkey_7A3A762FAFD4A51F.gpg | sudo gpg --dearmor --yes -o /etc/apt/trusted.gpg.d/spotify.gpg
echo "deb http://repository.spotify.com stable non-free" | sudo tee /etc/apt/sources.list.d/spotify.list
sudo apt-get update
sudo apt-get install spotify-client

# NVM
curl -o- https://raw.githubusercontent.com/nvm-sh/nvm/v0.39.5/install.sh | bash

export NVM_DIR="$([ -z "${XDG_CONFIG_HOME-}" ] && printf %s "${HOME}/.nvm" || printf %s "${XDG_CONFIG_HOME}/nvm")"
[ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh" # This loads nvm

nvm use node

# ShellCheck
sudo apt install shellcheck