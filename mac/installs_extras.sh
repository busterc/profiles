#!/usr/bin/env bash

# These are tools and apps that I _might_ want to install

homebrew_packages=(
    arq
    cheat
    csvkit
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
    tlrc
    tmux
    youtube-dl
)
echo "${homebrew_packages[@]}" | ipt -s " " -m -M "Select Homebrew Packages to Install:" | xargs brew install

homebrew_casks=(
    android-studio
    chatgpt
    claude-code
    disk-inventory-x
    font-geist
    font-geist-mono
    fanny
    inkscape
    keycastr
    kiro-cli
    proxyman
    recordit
    rescuetime
    scribus
    shotcut
    skitch
    slack
    thunderbird
    utm
)
echo "${homebrew_casks[@]}" | ipt -s " " -m -M "Select Homebrew Casks to Install:" | xargs brew install --cask
