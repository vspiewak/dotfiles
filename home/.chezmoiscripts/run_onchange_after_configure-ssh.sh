#!/bin/sh
set -eu

# keys only (~/.ssh/authorized_keys), no password logins
# sshd keeps the first value it reads: sort before other drop-ins (e.g. Ubuntu's 50-cloud-init.conf)
sudo tee /etc/ssh/sshd_config.d/10-keys-only.conf >/dev/null <<'EOF'
PasswordAuthentication no
KbdInteractiveAuthentication no
EOF

# Remote Login can't be turned on from a script without Full Disk Access
if ! nc -z -G 1 localhost 22 2>/dev/null; then
	echo "SSH: turn on System Settings > General > Sharing > Remote Login"
fi
