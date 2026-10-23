#!/bin/sh
set -eu

# every apply: ask for the password up front, not in the middle of the scripts
sudo -v -p "Password: "
# keep it until chezmoi is done (brew bundle can outlast sudo's 5 minutes)
while kill -0 "$PPID" 2>/dev/null; do
	sudo -n true
	sleep 60
done >/dev/null 2>&1 &
