#!/usr/bin/env bash

sudo add-apt-repository ppa:git-core/ppa
sudo apt-get update

# build essentials make, gcc, etc
sudo apt-get install -y build-essential

# Git
sudo apt-get install -y git

# NGINX
sudo apt-get install -y nginx

# NVM
export NVM_DIR="$HOME/.nvm" && (
  git clone https://github.com/creationix/nvm.git "$NVM_DIR"
  cd "$NVM_DIR"
  git checkout `git describe --abbrev=0 --tags --match "v[0-9]*" $(git rev-list --tags --max-count=1)`
) && \. "$NVM_DIR/nvm.sh"

# Node
nvm install --lts

# Lastpass CLI `lpass`
sudo apt-get install -y cmake libcurl4-openssl-dev libssl-dev libxml2 libxml2-dev openssl pinentry-curses pkg-config xclip
mkdir -p temp
(
  cd temp
  git clone https://github.com/lastpass/lastpass-cli
  cd lastpass-cli
  make
  sudo make install
)
printf "LastPass Username: "
read lpuser
lpass login "$lpuser"

# Ack
sudo apt-get install -y ack-grep

# Tree
sudo apt-get install -y tree

# Postgres CLI
sudo apt-get install -y python-pip

# ICDIff
sudo apt-get install -y icdiff
