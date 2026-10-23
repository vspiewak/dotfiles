#!/bin/sh
set -eu

brew bundle --file=/dev/stdin <<EOF
brew "curl"
brew "ffmpeg"
brew "gh"
brew "git"
brew "git-lfs"
brew "herdr"
brew "jq"
brew "shellcheck"
brew "tailscale"
brew "wget"
brew "yq"
EOF
