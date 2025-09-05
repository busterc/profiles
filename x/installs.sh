#!/usr/bin/env bash

cat <<EOF

========================================
# NPM
========================================

EOF

npm_packages=(
    ipt
    lbl
    npm-check
    nve
    optipng-bin
    trash-cli
    ts-node
)
for pkg in "${npm_packages[@]}"; do
  npm install -g "$pkg"
  echo "✓ $pkg"
done
