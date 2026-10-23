#!/bin/sh
set -eu

brew bundle --file=/dev/stdin <<EOF
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

cask "gcloud-cli"
cask "ghostty"
cask "google-chrome"
cask "visual-studio-code"
cask "vlc"
EOF
