#!/bin/sh
set -eu

# Touch ID for sudo (needs a Touch ID keyboard on a Mac mini, else the password
# is asked as usual); sudo_local survives macOS updates, unlike /etc/pam.d/sudo
sudo tee /etc/pam.d/sudo_local >/dev/null <<'EOF'
# sudo_local: local config file which survives system update and is included for sudo
auth       sufficient     pam_tid.so
EOF
