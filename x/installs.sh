#!/bin/bash

# Install bpkg and scripts
function bpkgify() {

  cat <<EOF

================================================================================
# BPKG
================================================================================

EOF

  local file
  file="$(which bpkg || true)"

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
    busterc/osx-iso
  )

  for script in "${scripts[@]}"; do
    bpkg install "$script"
  done
}
bpkgify

# Update NPM and install various global packages
function nodify() {

  cat <<EOF

================================================================================
# NPM
================================================================================

EOF

  npm update -g npm

  local packages=(
    bower
    browserify
    colors
    cordova
    eslint
    express-generator
    generator-node
    grunt
    gulp
    http-server
    iconr
    ionic
    keybase
    mocha
    node-inspector
    optipng-bin
    pm2
    svg-caster
    svgo
    trash
    yo

    # Mine, of course
    boomlet
    forkorg
    grunt-file
    gulpfile
    no-exif
    tos
    # xcv # installed with bpkg
  )

  for package in "${packages[@]}"; do
    npm install -g "$package"
  done
}
nodify
