#!/bin/bash

# Enable errexit; stop on any error
set -e

cat <<EOF

# IN THE BEGINNING, THERE WERE ...

EOF

# Prevent sourcing of this file
if [[ "${BASH_SOURCE[0]}" != "$0" ]]; then
  echo >&2 "Error: Cannot be sourced"
  return 1
fi

temp="${0%/*}/temp"
datetime=$(date -u +%F-%H%M%S)
backupdir="$(pwd)/backup/$datetime"
activedir="$(pwd)/active"
linktype="-sfn" # default to symlinking "-s"

function cleanup() {
  rm -rf "$temp"
}

# Clean up before exiting
trap cleanup EXIT

function usage() {
  cat <<EOF

  Usage: $0 <osx|msys|ubu>

EOF

  exit 1
}

function main() {

  # Ask for the administrator password upfront
  sudo -v

  local valid="false"
  local profiles=(
    osx
    msys
    ubu
  )

  # Prepare temp directory
  mkdir -p "$temp"

  # Prepare the active directory
  mkdir -p "$activedir"

  for profile in "${profiles[@]}"; do

    # Validate profile
    if [[ "$1" = "$profile" ]]; then
      valid="true"

      # Prepare backup directory
      mkdir -p "$backupdir"

      # Set dotfile linking type
      if [[ "$profile" = "msys" ]]; then
        # On Windows, Cygwin symlinks don't always work properly (Sublimetext)
        linktype="-fn"
      fi

      copydots "x" # cross-profile dots
      copydots "$1"

      # Set XDG Defaults
      source "./x/sources/xdg"

      # Activate platform specific profile
      activate "$1"

      # Install profile specific apps
      [ -f "./$1/installs.sh" ] && source "./$1/installs.sh"

      # Add sshkey
      sshme

      # Install cross-profile apps
      [ -f "./x/installs.sh" ] && source "./x/installs.sh"

      # Set profile specific system defaults
      [ -f "./$1/defaults.sh" ] && source "./$1/defaults.sh"

      break
    fi
  done

  [[ "$valid" = "true" ]] || usage
}

function validate_pwd() {

  function bad_path() {
    printf "\n  Error: you need to cd into %s/.profiles then run setup.sh\n\n" "$HOME"
    exit 2
  }

  [[ "$(pwd)" = "$HOME/.profiles" ]] || bad_path

}

function copydots() {
  local dotfile

  cat <<EOF

================================================================================
# DOTFILES ($1)
================================================================================

EOF

  for f in "$(pwd)/$1/dotfiles/"*; do
    # get the file basename
    dotfile="$HOME/.${f##*/}"

    # make sure the file is real, not '/*'
    [[ -f "$f" ]] || break

    # backup existing/matching file in ~/
    if [[ -f "$dotfile" ]]; then
      cp "$dotfile" "$backupdir"
    fi

    # create symlinks for ~
    ln "$linktype" "$f" "$dotfile"
    echo "✓ $dotfile"
  done
}

function sshme() {

  cat <<EOF

================================================================================
# SSH
================================================================================

EOF

  mkdir -p "$HOME/.ssh"
  local privatekey="$HOME/.ssh/id_rsa"
  lpass show --notes "SSH key for busterc" > "$privatekey"
  chmod 600 "$privatekey"
  chown $USER "$privatekey"
  echo "✓ Added $privatekey"
}

function activate() {
  cat <<EOF

================================================================================
# PROFILE ACTIVATION
================================================================================

EOF

  # ~/.bashrc sources ./active/profile
  # ./active/profile links to the appropriate profile
  ln "$linktype" "$(pwd)/$1/_profile" "$activedir/profile"
  echo "✓ Activated $1"
}

validate_pwd
main "$@"
