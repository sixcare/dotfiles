#!/usr/bin/env bash

set -euo pipefail

INSTALL_SELECTED=false

log() {
    printf "$(date -Ins) » %s\n" "$1"
}

on_error() {
  local exit_code=$?
  log "💥💥💥 Error in script at line $1: command '$BASH_COMMAND' exited with code $exit_code"
  exit $exit_code
}
trap 'on_error $LINENO' ERR


usage() {
  cat <<EOF
Usage: $0 [OPTIONS]

Options:
  --all              Run all 🪆 sub-modules (same as running without any arguments)
  --firefox          Install 🦊 Firefox
  --fonts            Install 🇫 Nerdfonts
  --git              Configure 🌲 Git
  --kitty            Install 🐈‍⬛ Kitty
  --neovim           Install 📓 Neovim
  --network          Install 🌐 Network(Manager)
  --nvm              Install 🤓 NVM
  --packages         Install 📦 common packages
  --podman           Install 🦭 Podman
  --rust             Install 🦀 Rust
  --signal           Install 💬 Signal
  --spotify          Install 🎧 Spotify
  --sway             Install 😎 Sway"
  --tmux             Install 🖥️ TMUX
  --vim              Install 📒 VIM
  --vscode           Install 📔 VS Code
  --wireguard        Install 🔗 WireGuard
  -h, --help         Show this help message 🆘
EOF
  exit 0
}


firefox() {
  log "🦊 Firefox"
  doas apt-get purge -y firefox-esr
  curl -fsSL https://packages.mozilla.org/apt/repo-signing-key.gpg | doas tee /etc/apt/keyrings/packages.mozilla.org.asc > /dev/null
  echo "deb [signed-by=/etc/apt/keyrings/packages.mozilla.org.asc] https://packages.mozilla.org/apt mozilla main" | doas tee /etc/apt/sources.list.d/mozilla.list > /dev/null
  echo '
    Package: *
    Pin: origin packages.mozilla.org
    Pin-Priority: 1000
    ' | doas tee /etc/apt/preferences.d/mozilla 
    doas apt-get update && doas apt-get install -y firefox
}

fonts() {
  log "🇫 Nerdfonts"
  mkdir -p ~/Downloads/fonts
  curl -fsSLo ~/Downloads/SourceCodePro.zip https://github.com/ryanoasis/nerd-fonts/releases/download/v3.4.0/SourceCodePro.zip
  unzip ~/Downloads/SourceCodePro.zip -d ~/Downloads/fonts
  doas mv ~/Downloads/fonts/*.ttf /usr/local/share/fonts/
  rm -rf ~/Downloads/fonts ~/Downloads/SourceCodePro.zip
}

git() {
  log "🌲 Git config"
  git config --global init.defaultBranch main
  git config --global user.name "Are Schjetne"
  git config --global user.email sixcare.as@gmail.com
  git config --global --replace-all core.pager "less -F -X"
}

kitty() {
  log "🐈‍⬛ Kitty"

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
}

neovim() {
  log "📓 Neovim"
  doas curl -fsSLo /usr/local/bin/nvim https://github.com/neovim/neovim/releases/latest/download/nvim-linux-x86_64.appimage
  doas chmod +x /usr/local/bin/nvim
}

network() {
  log "🌐 Network"
  doas apt-get install -y network-manager
  doas systemctl start NetworkManager.service
  doas systemctl enable NetworkManager.service
}

nvm() {
  log "🤓 NVM"
  curl -fsSLo- https://raw.githubusercontent.com/nvm-sh/nvm/v0.40.3/install.sh | bash
  NVM_DIR="$([ -z "${XDG_CONFIG_HOME-}" ] && printf %s "${HOME}/.nvm" || printf %s "${XDG_CONFIG_HOME}/nvm")"
  export NVM_DIR
  # shellcheck source=/dev/null
  [ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"
  nvm install node
  nvm use node
}

packages() {
  log "📦 Packages"
  PACKAGES=(
      bmon
      brightnessctl
      build-essential
      ca-certificates
      fwupd
      gnupg
      htop
      jq
      keepassxc
      net-tools
      shellcheck
      unzip
      pavucontrol
      pulseaudio
      python3-venv
  )
  doas apt-get update
  doas apt-get install -y "${PACKAGES[@]}"
}

podman() {
  log "🦭 Podman"
  doas apt-get -y install podman podman-docker podman-compose
}

rust() {
  log "🦀 Rust"
  sh -c "$(curl -fsSL https://sh.rustup.rs)" "" -y

  # shellcheck disable=SC2016
  grep -q '^alias rust_init=.*' ~/.zshrc && \
      sed -i -e 's/^alias rust_init=.*/alias rust_init="source <(rustup completions zsh)"\n/g' "$HOME/.zshrc" || \
      printf 'alias rust_init="source <(rustup completions zsh)"\n' >> "$HOME/.zshrc"
}

signal() {
  log "💬 Signal"
  curl -fsSL https://updates.signal.org/desktop/apt/keys.asc | doas gpg --yes --dearmor -o /usr/share/keyrings/signal-desktop-keyring.gpg
  doas chmod a+r /usr/share/keyrings/signal-desktop-keyring.gpg

  echo 'deb [arch=amd64 signed-by=/usr/share/keyrings/signal-desktop-keyring.gpg] https://updates.signal.org/desktop/apt xenial main' \
    | doas tee /etc/apt/sources.list.d/signal-xenial.list

  doas apt-get update
  doas apt-get install -y signal-desktop
}

spotify() {
  log "🎧 Spotify"
  curl -fsSL https://download.spotify.com/debian/pubkey_C85668DF69375001.gpg | doas gpg --dearmor --yes -o /etc/apt/trusted.gpg.d/spotify.gpg
  echo "deb https://repository.spotify.com stable non-free" | sudo tee /etc/apt/sources.list.d/spotify.list
  doas apt-get update
  doas apt-get install -y spotify-client
}

sway() {
  log "😎 Sway"
  doas apt-get install -y sway swaybg swayidle swaylock waybar bemenu
  mkdir -p ~/.config/sway
  mkdir -p /usr/share/backgrounds
  cp ./images/wallpaper_1920x1080.png /usr/share/backgrounds/background-1920x1080.png
  cp ./config/swayconfig ~/.config/sway/config

  ## waybar
  mkdir -p ~/.config/waybar/scripts
  cp ./config/waybar/style.css ~/.config/waybar/style.css
  cp ./config/waybar/config ~/.config/waybar/config

  ## swaylock
  mkdir -p ~/.config/swaylock/
  cp ./images/lockscreen_1920x1080.png /usr/share/backgrounds/lockscreen-1920x1080.png
  cp config/swaylock/config ~/.config/swaylock/config

  # shellcheck disable=SC2016
  grep -q '^alias gotosleep=.*' ~/.zshrc && \
      sed -i -e 's/^alias gotosleep=.*/alias gotosleep="swaylock -C $HOME/.config/swaylock/config; systemclt suspend"/g' ~/.zshrc || \
      printf 'alias gotosleep="swaylock -C $HOME/.config/swaylock/config; systemclt suspend"' >> ~/.zshrc
}

tmux() {
  log "🖥️ TMUX"
  doas apt-get install -y tmux
  cp ./config/tmux.conf "${HOME}"/.tmux.conf
}

vim() {
  log "📒 VIM"
  doas apt-get install -y vim
  doas update-alternatives --set editor /usr/bin/vim.basic
  cp ./config/vimrc "${HOME}"/.vimrc
}

vscode() {
  log "📔 VS Code"
  curl -fsSL https://packages.microsoft.com/keys/microsoft.asc | doas gpg --yes --dearmor -o /etc/apt/keyrings/packages.microsoft.gpg
  echo "deb [arch=amd64,arm64,armhf signed-by=/etc/apt/keyrings/packages.microsoft.gpg] https://packages.microsoft.com/repos/code stable main" | doas tee /etc/apt/sources.list.d/vscode.list
  doas apt-get update
  doas apt-get install -y code

  mkdir -p ~/.config/Code/User
  cp ./config/vscode.json ~/.config/Code/User/settings.json
}

wireguard() {
  log "🔗 WireGuard"
  doas apt-get install -y wireguard wireguard-tools
  cp ./config/waybar/scripts/wireguard.sh ~/.config/waybar/scripts/wireguard.sh
  chmod +x ~/.config/waybar/scripts/wireguard.sh
}

all() {
  log "🌌 Running all"

  firefox
  fonts
  git
  kitty
  neovim
  network
  nvm
  packages
  podman
  ruts
  signal
  spotify
  sway
  tmux
  vim
  vscode
  wireguard
}

while [[ $# -gt 0 ]]; do
  case "$1" in
    --all)
      all
      INSTALL_SELECTED=true
      shift
      ;;
    --firefox)
      firefox
      INSTALL_SELECTED=true
      shift
      ;;
    --fonts)
      fonts
      INSTALL_SELECTED=true
      shift
      ;;
    --git)
      git
      INSTALL_SELECTED=true
      shift
      ;;
    --kitty)
      kitty
      INSTALL_SELECTED=true
      shift
      ;;
    --neovim)
      neovim
      INSTALL_SELECTED=true
      shift
      ;;
    --network)
      network
      INSTALL_SELECTED=true
      shift
      ;;
    --nvm)
      nvm
      INSTALL_SELECTED=true
      shift
      ;;
    --packages)
      packages
      INSTALL_SELECTED=true
      shift
      ;;
    --podman)
      podman
      INSTALL_SELECTED=true
      shift
      ;;
    --signal)
      signal
      INSTALL_SELECTED=true
      shift
      ;;
    --spotify)
      spotify
      INSTALL_SELECTED=true
      shift
      ;;
    --sway)
      sway
      INSTALL_SELECTED=true
      shift
      ;;
    --tmux)
      tmux
      INSTALL_SELECTED=true
      shift
      ;;
    --vim)
      vscode
      INSTALL_SELECTED=true
      shift
      ;;
    --vscode)
      vscode
      INSTALL_SELECTED=true
      shift
      ;;
    --wireguard)
      wireguard
      INSTALL_SELECTED=true
      shift
      ;;
    -h|--help)
      usage
      ;;
    *)
      echo "[!] Unknown option: $1"
      usage
      ;;
  esac
done

if ! $INSTALL_SELECTED; then
  all
fi
