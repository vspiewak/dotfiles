#!/bin/sh
set -eu

# keys only (~/.ssh/authorized_keys), no password logins
# sshd keeps the first value it reads: sort before other drop-ins (e.g. Ubuntu's 50-cloud-init.conf)
sudo tee /etc/ssh/sshd_config.d/10-keys-only.conf >/dev/null <<'EOF'
PasswordAuthentication no
KbdInteractiveAuthentication no
EOF

# logins only from Tailscale and private networks (home LAN, link-local), not
# from the internet, e.g. through the Mac's public IPv6 (launchd listens on all
# addresses, so sshd's ListenAddress can't limit it)
sudo tee /etc/ssh/sshd_config.d/10-private-networks-only.conf >/dev/null <<'EOF'
AllowUsers *@100.64.0.0/10 *@fd7a:115c:a1e0::/48 *@10.0.0.0/8 *@172.16.0.0/12 *@192.168.0.0/16 *@fc00::/7 *@fe80::/10
EOF

# Remote Login, as the System Settings toggle (after the keys-only config, so it
# never accepts passwords); unlike systemsetup, no Full Disk Access needed
sudo launchctl enable system/com.openssh.sshd
if ! launchctl print system/com.openssh.sshd >/dev/null 2>&1; then
	sudo launchctl bootstrap system /System/Library/LaunchDaemons/ssh.plist
fi
