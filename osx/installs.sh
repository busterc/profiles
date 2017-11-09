#!/bin/bash

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
  brew install lastpass-cli --with-pinentry
  # LastPass hacky install docs (overcomes HomeBrew a2x errors)
  brew install lastpass-cli --with-pinentry --with-doc
  printf "LastPass Username: "
  read lpuser
  lpass login "$lpuser"

  # Prevent Homebrew from getting rate-limited
  export "HOMEBREW_GITHUB_API_TOKEN=$(lpass show --notes 'GitHub Access Token')"

  local recipes=(
    ack
    bash-completion
    git
    httrack
    imagemagick
    lynx
    node
    repl
    rlwrap
    shellcheck
    surfraw
    tmux
    tree
  )

  for recipe in "${recipes[@]}"; do
    brew install "$recipe"
  done

  brew tap caskroom/cask

  local casks=(
    arq
    cheatsheet
    docker
    filezilla
    gimp
    google-chrome
    google-backup-and-sync
    hyper
    keycastr
    lastpass
    real-vnc
    recordit
    rescuetime
    shotcut
    sketch
    skitch
    sling
    slingplayer
    spectacle
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
