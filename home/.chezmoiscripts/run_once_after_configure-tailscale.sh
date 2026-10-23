#!/bin/sh
set -eu

# system daemon: the tailnet is up at boot, before anyone logs in (unlike the GUI app)
sudo brew services start tailscale

# let your user run tailscale up/down without sudo; retry while the daemon starts
tries=0
until sudo tailscale set --operator="$(id -un)" 2>/dev/null; do
	tries=$((tries + 1))
	if [ "$tries" -ge 10 ]; then
		echo "Tailscale: run 'sudo tailscale set --operator=$(id -un)'" >&2
		break
	fi
	sleep 1
done

if ! tailscale status >/dev/null 2>&1; then
	echo "Tailscale: run 'sudo tailscale up' to log in"
fi
