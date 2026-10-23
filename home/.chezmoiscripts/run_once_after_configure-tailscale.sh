#!/bin/sh
set -eu

# system daemon: the tailnet is up at boot, before anyone logs in (unlike the GUI app)
sudo brew services start tailscale

if ! tailscale status >/dev/null 2>&1; then
	echo "Tailscale: run 'sudo tailscale up' to log in"
fi
