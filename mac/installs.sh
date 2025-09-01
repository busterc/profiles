#!/usr/bin/env bash

cat <<EOF

========================================
# XCode Command Line Tools
========================================

EOF

xcode-select --install 2>/dev/null || true
echo "✓ XCode Command Line Tools"

cat <<EOF

========================================
# Homebrew
========================================

EOF

NONINTERACTIVE=1 /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
echo "✓ Homebrew"

# # Prevent Homebrew from getting rate-limited during installs
# if [[ -z "$HOMEBREW_GITHUB_API_TOKEN" ]]; then
#   read -p "Enter your GitHub Access Token (To Prevent Rate-Limiting): " github_token
#   export "HOMEBREW_GITHUB_API_TOKEN=$github_token"
#   echo "✓ HOMEBREW_GITHUB_API_TOKEN=$HOMEBREW_GITHUB_API_TOKEN"
# fi

# Install Bash and make it the default shell
brew install bash
if ! grep -q "/opt/homebrew/bin/bash" /etc/shells; then
  sudo echo "/opt/homebrew/bin/bash" >> /etc/shells
fi
chsh -s "/opt/homebrew/bin/bash"
source "$HOME/.bash_profile"
echo "✓ Bash"

brew install bash-completion@2
source "$HOME/.bash_profile"
echo "✓ Bash Completion"

homebrew_recipes=(
    ack
    applesimutils
    awscli
    bat
    corepack
    curl
    ffmpeg
    git
    handbrake
    htop
    httpie
    icdiff
    imagemagick
    jq
    lastpass-cli
    lazydocker
    mkcert
    node
    pgcli
    rename
    repl
    rlwrap
    shellcheck
    tree
    webp
    wget
)
for pkg in "${homebrew_recipes[@]}"; do
  brew install "$pkg"
  echo "✓ $pkg"
done

homebrew_casks=(
    arq
    cheatsheet
    claude
    cursor
    disk-inventory-x
    docker
    docker-desktop
    fanny
    gcloud-cli
    gimp
    google-chrome
    google-drive
    lastpass
    lepton
    mysql-shell
    mysqlworkbench
    ngrok
    pgadmin4
    spectacle
    visual-studio-code
    vlc
    vmware-fusion
    xbar
)
for cask in "${homebrew_casks[@]}"; do
  brew install --cask "$cask"
  echo "✓ $cask"
done
