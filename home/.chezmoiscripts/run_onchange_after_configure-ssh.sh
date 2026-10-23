#!/bin/sh
set -eu

# keys only (~/.ssh/authorized_keys), no password logins
# sshd keeps the first value it reads: sort before other drop-ins (e.g. Ubuntu's 50-cloud-init.conf)
sudo tee /etc/ssh/sshd_config.d/10-keys-only.conf >/dev/null <<'EOF'
PasswordAuthentication no
KbdInteractiveAuthentication no
EOF

# Remote Login, as the System Settings toggle (after the keys-only config, so it
# never accepts passwords); unlike systemsetup, no Full Disk Access needed
sudo launchctl enable system/com.openssh.sshd
if ! launchctl print system/com.openssh.sshd >/dev/null 2>&1; then
	sudo launchctl bootstrap system /System/Library/LaunchDaemons/ssh.plist
fi
