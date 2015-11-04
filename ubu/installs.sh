#!/bin/bash

apt-get update

# build essentials make, gcc, etc
apt-get install -y build-essential

# Git
apt-get install -y git

# Node
curl -sL https://deb.nodesource.com/setup_5.x | sudo -E bash -
apt-get install -y nodejs

# Lastpass CLI `lpass`
apt-get install -y openssl libcurl4-openssl-dev libxml2 libssl-dev libxml2-dev pinentry-curses xclip
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
apt-get install -y ack-grep

# Tree
apt-get install -y tree
