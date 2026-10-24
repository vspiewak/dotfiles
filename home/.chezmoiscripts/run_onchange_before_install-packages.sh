#!/bin/sh
set -eu

brew bundle --file=/dev/stdin <<EOF
brew "colima"
brew "docker"
brew "docker-compose"
brew "ffmpeg"
brew "gh"
brew "git"
brew "git-lfs"
brew "go"
brew "golangci-lint"
brew "herdr"
brew "jq"
brew "mise"
brew "shellcheck"
brew "starship"
brew "tailscale"
brew "tmux"
brew "wget"
brew "yq"

cask "gcloud-cli"
cask "ghostty"
cask "google-chrome"
cask "visual-studio-code"
cask "vlc"
EOF
