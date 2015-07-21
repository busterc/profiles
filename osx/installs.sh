#!/bin/bash

# Setup a Mac with apps, tools and defaults
function osxify() {

  cat <<EOF

================================================================================
# XCODE
================================================================================

EOF

  # XCode Command Line Tools
  xcode-select --install

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
  brew install lastpass-cli --with-pinentry # --with-doc

  # Prevent Homebrew from getting rate-limited
  export "HOMEBREW_GITHUB_API_TOKEN=$(lpass show --notes 'GitHub Access Token')"

  local recipes=(
    ack
    boot2docker
    git
    imagemagick
    node
    shellcheck
    tmux
  )

  for recipe in "${recipes[@]}"; do
    brew install "$recipe"
  done 

  local casks=(
    google-chrome
    google-drive
    lastpass
    picasa
    rescuetime
    spectacle
    sublime-text
    vagrant
    vlc
    vmware-fusion
  )
  
  for cask in "${casks[@]}"; do
    brew install "Caskroom/cask/$cask"
  done
}
osxify