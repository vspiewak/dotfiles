#!/bin/sh
set -eu

brew bundle --file=/dev/stdin <<EOF
brew "herdr"
brew "pam-reattach"
brew "tailscale"
EOF
