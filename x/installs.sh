#!/bin/bash

# Install bpkg and scripts
function bpkgify() {
  local file
  file=$(which bpkg)

  if [[ -z "$file" ]]; then
    (
      cd "$temp" # defined in ../setup.sh
      git clone https://github.com/bpkg/bpkg.git
      cd bpkg
      ./setup.sh
    )
  fi

  local scripts=(
    busterc/xcv
  )

  for script in "${scripts[@]}"; do
    bpkg install "$script"
  done  
}
bpkgify

# Update NPM and install various global packages
function nodify() {
  npm update -g npm

  local packages=(
    bower
    browserify
    colors
    cordova
    grunt
    gulp
    http-server
    ionic
    keybase
    node-inspector
    optipng-bin
    pm2
    yo

    # Mine, of course
    boomlet
    forkorg
    grunt-file
    gulpfile
    no-exif
    # xcv # installed with bpkg
  )

  for package in "${packages[@]}"; do
    npm install -g "$package"
  done
}
nodify
