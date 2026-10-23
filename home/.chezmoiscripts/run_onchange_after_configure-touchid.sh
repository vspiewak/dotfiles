#!/bin/sh
set -eu

# Touch ID for sudo (needs a Touch ID keyboard on a Mac mini, else the password
# is asked as usual); sudo_local survives macOS updates, unlike /etc/pam.d/sudo

# pam_reattach makes Touch ID work in herdr panes too (not over SSH). sudo loads it
# as root: use a root-owned copy, as Homebrew's files are writable by your user and
# a missing module breaks sudo altogether (re-copied when this script changes)
sudo install -d -o root -g wheel /usr/local/lib/pam
sudo install -m 444 -o root -g wheel "$(brew --prefix pam-reattach)/lib/pam/pam_reattach.so" /usr/local/lib/pam/

sudo tee /etc/pam.d/sudo_local >/dev/null <<'PAM'
# sudo_local: local config file which survives system update and is included for sudo
auth       optional       /usr/local/lib/pam/pam_reattach.so ignore_ssh
auth       sufficient     pam_tid.so
PAM
