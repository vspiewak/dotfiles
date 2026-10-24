#!/bin/sh
set -eu

# docker compose: Homebrew's plugin (keeps the rest of the file: logins, context)
config=$HOME/.docker/config.json
mkdir -p "$HOME/.docker"
[ -f "$config" ] || echo '{}' >"$config"
jq '.cliPluginsExtraDirs = ["/opt/homebrew/lib/docker/cli-plugins"]' "$config" >"$config.new"
mv "$config.new" "$config"

# the VM's size (saved by colima start), then Colima as a service: up after
# each login
brew services stop colima >/dev/null 2>&1 || true
colima stop >/dev/null 2>&1 || true
colima start --cpu 8 --memory 16 --vm-type vz --vz-rosetta
colima stop
brew services start colima
