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
eval "$(/opt/homebrew/bin/brew shellenv)"
echo "✓ Homebrew"

# Install Bash and make it the default shell
brew install bash
if ! grep -q "/opt/homebrew/bin/bash" /etc/shells; then
  sudo echo "/opt/homebrew/bin/bash" | sudo tee -a /etc/shells
fi
# Ensure bash (from homebrew) is the default shell
[[ "$SHELL" != "/opt/homebrew/bin/bash" ]] && chsh -s "/opt/homebrew/bin/bash"
source "$HOME/.bash_profile"
echo "✓ Bash"

brew install bash-completion@2
source "$HOME/.bash_profile"
echo "✓ Bash Completion"

homebrew_recipes=(
    ack
    awscli
    bat
    corepack
    curl
    ffmpeg
    gh
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
    mysql-client
    nvm
    optipng
    pandoc
    pgcli
    pv
    pyenv
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
    basictex
    claude
    cursor
    docker-desktop
    gcloud-cli
    ghostty
    gimp
    google-chrome
    google-drive
    lastpass
    mysql-shell
    mysqlworkbench
    ngrok
    pgadmin4
    rectangle
    visual-studio-code
    vlc
    xbar
)
for cask in "${homebrew_casks[@]}"; do
  brew install --cask "$cask"
  echo "✓ $cask"
done
