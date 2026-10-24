#!/bin/sh
set -eu

# a Mac without a battery (the Mac mini) is a server: never sleep, as nothing
# wakes it over Tailscale, and start again after a power failure
if pmset -g batt | grep -q InternalBattery; then
	exit 0
fi
sudo pmset -a sleep 0 disksleep 0 autorestart 1
