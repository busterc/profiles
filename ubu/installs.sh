#!/bin/bash

apt-get update

# build essentials make, gcc, etc
apt-get install -y build-essential

# Git
apt-get install -y git

# Node
curl -sL https://deb.nodesource.com/setup_8.x | sudo -E bash -
apt-get install -y nodejs

# Lastpass CLI `lpass`
apt-get install -y cmake libcurl4-openssl-dev libssl-dev libxml2 libxml2-dev openssl pinentry-curses pkg-config xclip
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
