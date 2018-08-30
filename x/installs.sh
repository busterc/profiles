#!/usr/bin/env bash

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
      sudo ./setup.sh install
    )
  fi

  local scripts=(
    busterc/xcv
    busterc/osx-iso
  )

  for script in "${scripts[@]}"; do
    sudo bpkg install "$script" -g
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
    colors
    cordova
    datauri-cli
    degit
    depcheck
    eslint
    express-generator
    generator-code
    generator-generator
    generator-nm
    generator-node
    hpm-cli
    http-server
    iconr
    ionic
    ios-sim
    keybase
    khaos
    live-server
    marko-cli
    n
    npm-check
    optipng-bin
    pm2
    pushover-cli
    svg-caster
    svgo
    tldr
    trash-cli
    vsce
    yo

    # Mine, of course
    assert-dotenv-cli
    boomlet
    distiller
    forkorg
    generator-cordova-www
    generator-prettier-package-json
    grunt-file
    gulpfile
    jstdin
    lbl
    microgen
    mvy
    no-exif
    npmu
    nvx
    tos
    # xcv # installed with bpkg
    yos
  )

  for package in "${packages[@]}"; do
    npm install -g "$package"
  done
}
nodify

# Install various Python packages
function pipify() {

  cat <<EOF

================================================================================
# PIP
================================================================================

EOF

  pip install git+https://github.com/jeffkaufman/icdiff.git
  pip install pgcli
}
pipify
