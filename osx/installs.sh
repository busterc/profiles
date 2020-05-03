#!/usr/bin/env bash

# Setup a Mac with apps, tools and defaults
function osxify() {

  cat <<EOF

================================================================================
# XCODE
================================================================================

EOF

  echo "✓ XCode Command Line Tools"
  xcode-select --install 2>/dev/null || true

  cat <<EOF

================================================================================
# HOMEBREW
================================================================================

EOF

  # Homebrew itself
  if [[ ! "$(type -P brew)" ]]; then
    ruby -e "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/master/install)"
  fi
  brew doctor
  brew update

  # LastPass
  brew install lastpass-cli
  printf "LastPass Username: "
  read lpuser
  lpass login "$lpuser"

  # Prevent Homebrew from getting rate-limited
  export "HOMEBREW_GITHUB_API_TOKEN=$(lpass show --notes 'GitHub Access Token')"

  local recipes=(
    ack
    bash
    bash-completion2
    bat
    git
    htop
    httpie
    httrack
    imagemagick
    jq
    lynx
    node
    rename
    repl
    rlwrap
    shellcheck
    surfraw
    tmux
    tree
    wget
    youtube-dl
  )

  # Switch to using brew-installed bash as default shell
  if ! fgrep -q '/usr/local/bin/bash' /etc/shells; then
    echo '/usr/local/bin/bash' | sudo tee -a /etc/shells;
    chsh -s /usr/local/bin/bash;
  fi

  for recipe in "${recipes[@]}"; do
    brew install "$recipe"
  done

  brew tap caskroom/cask

  local casks=(
    arq
    bitbar
    cheatsheet
    docker
    fanny
    filezilla
    gimp
    google-chrome
    google-backup-and-sync
    hyper
    inkscape
    keycastr
    lastpass
    lepton
    mysql-shell
    qlstephen
    real-vnc
    recordit
    rescuetime
    scribus
    shotcut
    sketch
    skitch
    slingplayer
    spectacle
    ubiquiti-unifi-controller
    virtualbox
    visual-studio-code
    vlc
    vmware-fusion
  )

  for cask in "${casks[@]}"; do
    brew cask install "$cask"
  done
}
osxify
