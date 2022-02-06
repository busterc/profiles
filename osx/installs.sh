#!/usr/bin/env bash

# Setup a Mac with apps, tools and defaults
function osxify() {

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
  sudo gem install cocoapods
  echo "✓ CocoaPods"

  cat <<EOF

================================================================================
# HOMEBREW
================================================================================

EOF

  # Homebrew itself
  NONINTERACTIVE=1 /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"

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
    git
    htop
    httpie
    httrack
    icdiff
    imagemagick
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
  if ! fgrep -q '/usr/local/bin/bash' /etc/shells; then
    echo '/usr/local/bin/bash' | sudo tee -a /etc/shells;
    chsh -s /usr/local/bin/bash;
  fi

  brew tap homebrew/cask-drivers # for ubiquiti-unifi-controller-lts
  brew tap wix/brew # for applesimutils

  for recipe in "${recipes[@]}"; do
    brew install "$recipe"
  done

  local casks=(
    arq
    cheatsheet
    disk-inventory-x
    docker
    fanny
    # filezilla # was removed from casks for malware/adware
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
