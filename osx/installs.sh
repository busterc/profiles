#!/usr/bin/env bash

# Setup a Mac with apps, tools and defaults
function osxify() {

  cat <<EOF

================================================================================
# Apple Rosetta for (Non Mac M1 Compatible) App Support
================================================================================

EOF

  echo "==> Rosetta <=="
  sudo softwareupdate --install-rosetta --agree-to-license
  echo "✓ Rosetta"

  cat <<EOF

================================================================================
# XCODE
================================================================================

EOF

  echo "==> XCode Command Line Tools <=="
  xcode-select --install 2>/dev/null || true
  echo "✓ XCode Command Line Tools"

  echo
  echo "==> CocoaPods <=="
  # Mac M1 requires some finesing: https://stackoverflow.com/a/70129175
  sudo arch -x86_64 gem install ffi
  sudo arch -x86_64 gem install cocoapods
  echo "✓ CocoaPods"

  cat <<EOF

================================================================================
# HOMEBREW
================================================================================

EOF

  # Homebrew itself
  NONINTERACTIVE=1 /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
  eval "$(/opt/homebrew/bin/brew shellenv)"

  # LastPass
  brew install lastpass-cli
  printf "LastPass Username: "
  read lpuser
  lpass login "$lpuser"

  # Create ~/.env
  lpass show --notes rover-dotenv > "$HOME/.env"

  # Prevent Homebrew from getting rate-limited
  export "HOMEBREW_GITHUB_API_TOKEN=$(lpass show --notes 'GitHub Access Token')"

  local recipes=(
    ack
    applesimutils
    awscli
    bash
    bash-completion2
    bat
    fvm
    git
    htop
    httpie
    httrack
    icdiff
    imagemagick
    jenv
    jq
    lazydocker
    lynx
    mkcert
    node
    pgcli
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
  if ! fgrep -q '/opt/homebrew/bin/bash' /etc/shells; then
    echo '/opt/homebrew/bin/bash' | sudo tee -a /etc/shells;
    chsh -s /opt/homebrew/bin/bash;
  fi

  brew tap homebrew/cask-drivers # for ubiquiti-unifi-controller-lts
  brew tap leoafarias/fvm # for fvm
  brew tap wix/brew # for applesimutils

  for recipe in "${recipes[@]}"; do
    brew install "$recipe"
  done

  local casks=(
    android-studio
    arq
    cheatsheet
    disk-inventory-x
    docker
    fanny
    gimp
    google-chrome
    google-drive
    hyper
    inkscape
    keycastr
    lastpass
    lepton
    mysql-shell
    mysqlworkbench
    ngrok
    pgadmin4
    qlstephen
    recordit
    rescuetime
    scribus
    shotcut
    skitch
    # spectacle
    thunderbird
    ubiquiti-unifi-controller-lts
    # virtualbox
    visual-studio-code
    vlc
    vmware-fusion
    xbar
  )

  for cask in "${casks[@]}"; do
    brew install --cask "$cask"
  done
}
osxify
