#!/usr/bin/env bash

# These are tools and apps that I _might_ want to install

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
echo "${homebrew_packages[@]}" | ipt -s " " -m -M "Select Homebrew Packages to Install:" | xargs brew install

homebrew_casks=(
    android-studio
    chatgpt
    claude-code
    disk-inventory-x
    fanny
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
echo "${homebrew_casks[@]}" | ipt -s " " -m -M "Select Homebrew Casks to Install:" | xargs brew install --cask
