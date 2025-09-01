#!/usr/bin/env bash

homebrew_packages=(
    arq
    dart
    duckdb
    fvm
    fx
    gemini-cli
    gifsicle
    httrack
    jenv
    lynx
    surfraw
    tmux
    youtube-dl
)

selected=()
for pkg in "${homebrew_packages[@]}"; do
  read -p "Install $pkg? (Y/n) " choice
  if [[ -z $choice || $choice == [Yy] ]]; then
    selected+=("$pkg")
  fi
done

if [[ ${#selected[@]} -gt 0 ]]; then
  brew install "${selected[@]}"
fi

homebrew_casks=(
    android-studio
    chatgpt
    claude-code
    inkscape
    keycastr
    proxyman
    recordit
    rescuetime
    scribus
    shotcut
    skitch
    thunderbird
)
for cask in "${homebrew_casks[@]}"; do
  brew install --cask "$cask"
  echo "✓ $cask"
done
