#!/usr/bin/env bash

# These are tools and apps that I _might_ want to install

homebrew_packages=(
    cheat
    csvkit
    duckdb
    fvm
    fx
    gifsicle
    httrack
    jenv
    lume
    lynx
    sshpass
    surfraw
    tlrc
    tmux
    yt-dlp
)
echo "${homebrew_packages[@]}" | ipt -s " " -m -M "Select Homebrew Packages to Install:" | xargs brew install

homebrew_casks=(
    android-studio
    antigravity
    antigravity-cli
    chatgpt
    claude-code
    discord
    fanny
    font-eb-garamond
    font-geist
    font-geist-mono
    inkscape
    keycastr
    kiro-cli
    proxyman
    radix
    rescuetime
    scribus
    shotcut
    slack
    thunderbird
    utm
)
echo "${homebrew_casks[@]}" | ipt -s " " -m -M "Select Homebrew Casks to Install:" | xargs brew install --cask
