#!/usr/bin/env bash

# Enable errexit; stop on any error
set -e

# Prevent sourcing of this file
if [[ "${BASH_SOURCE[0]}" != "$0" ]]; then
  echo >&2 "Error: This script cannot be sourced"
  return 1
fi

# Ensure the script is run from the correct directory
if [[ "$(pwd)" != "$HOME/.profiles" ]]; then
  echo >&2 "Error: This script must be run from $HOME/.profiles"
  exit 1
fi

# Ensure a machine type is specified
if [[ $# -ne 1 ]]; then
  echo >&2 "Usage: $0 <mac|linux>"
  exit 1
fi

# Ensure a machine type is "mac" or "linux" only
machine_type="$1"
if [[ "$machine_type" != "mac" && "$machine_type" != "linux" ]]; then
  echo >&2 "Error: Invalid machine type '$machine_type'. Must be 'mac' or 'linux'."
  exit 1
fi

# Prompt for sudo password
echo "Sudo password required"
sudo -v

cat <<EOF

# IN THE BEGINNING, THERE WERE ...

EOF
sleep 2


# Establish backup directory for archiving any pre-existing dotfiles
backupdir="$(pwd)/backup/$(date -u +%F-%H%M%S)"
mkdir -p "$backupdir"

# Link dotfiles from the specified directory to the home directory
# and create backups of any existing dotfiles
function link_dotfiles() {
  local dotfile
  cat <<EOF

========================================
# DOTFILES ($1)
========================================

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
    ln -sfn "$f" "$dotfile"
    echo "✓ $dotfile"
  done
}
link_dotfiles "x"
link_dotfiles "$machine_type"

# Activate profile for specified machine type
function activate_profile() {
  cat <<EOF

========================================
# PROFILE ACTIVATION ($1)
========================================

EOF

  # Establish directory for the active profile
  mkdir -p "$(pwd)/active"

  # ~/.bashrc sources ./active/profile
  # ./active/profile links to the appropriate profile
  ln -sfn "$(pwd)/$1/_profile" "$(pwd)/active/profile"
  echo "✓ Activated $1"
}
activate_profile "$machine_type"


# Set XDG defaults before sourcing profile specifics
source "./x/sources/xdg"

# Install profile specific apps and tools
[ -f "./$1/installs.sh" ] && source "./$1/installs.sh"

# Install universal apps and tools
[ -f "./x/installs.sh" ] && source "./x/installs.sh"

# Set profile specific system defaults
[ -f "./$1/defaults.sh" ] && source "./$1/defaults.sh"

cat <<EOF

========================================
# THIS IS THE END, MY FRIEND
========================================

You need to restart the machine for all changes to take effect!

EOF

read -p "Would you like to restart now? (Y/n) " restart_now
if [[ -z $restart_now || $restart_now == [Yy] ]]; then
  printf "\nVery well.. cya you on the flip flop"
  sleep 5
  sudo shutdown -r now
else
  printf "\nAlrighty then, but some things won't work as expected.\n\n"
  printf "     ~ Adios Amigo ~\n\n"
fi
