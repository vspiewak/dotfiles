# 🍎 dotfiles

> My Macs, set up in one command with [chezmoi](https://www.chezmoi.io) and [Homebrew](https://brew.sh). Agents run on the Mac mini, driven over SSH with [herdr](https://herdr.dev).

## 🚀 Setup

```sh
# 1. install: asks your password once, then runs unattended (over SSH: ssh -t)
curl -fsSL dotfiles.vspiewak.com | sh

# 2. in a new terminal, join the tailnet (browser sign-in, kept across reboots)
tailscale up

# 3. this Mac's SSH key: on GitHub (push, signing) and in authorized_keys
ssh-key-sync

# 4. gh for agents (at the Mac's own keyboard, --insecure-storage isn't needed)
gh auth login --hostname github.com --git-protocol ssh --skip-ssh-key --web --insecure-storage

# 5. work account: same, logged in to github.com as vspiewak-sephoraeme,
#    then authorize the new key for SAML SSO (github.com/settings/keys > Configure SSO)
ssh-key-sync sephoraeme
cd ~/Dev/sephoraeme && gh auth login --hostname github.com --git-protocol ssh --skip-ssh-key --web --insecure-storage

# 6. from the herdr client (e.g. the MacBook)
herdr machine add <user>@<hostname>.<tailnet>.ts.net --label <hostname>

# later, to update (asks your password once)
chezmoi update
```

## ✨ What you get

- 📦 **Homebrew**: CLI tools and apps, listed in [`install-packages.sh`](home/.chezmoiscripts/run_onchange_before_install-packages.sh)
- 🔒 **Tailscale**: system daemon, on the tailnet at boot, named after the hostname, `tailscale up`/`down` without sudo
- 🔑 **SSH**: Remote Login with keys only, from Tailscale and private networks only (not the internet)
- 👆 **Touch ID** for `sudo` (on a Mac mini: with a Touch ID keyboard)
- 🐚 **zsh**: [Starship](https://starship.rs) prompt, completion, per-pane history, emacs keys
- 👻 **Ghostty**: Catppuccin Frappe, no ligatures, its terminfo installed on SSH hosts
- 🧩 **VS Code** extensions, listed in [`configure-vscode.sh`](home/.chezmoiscripts/run_onchange_after_configure-vscode.sh)
- 🌿 **git**: signed commits, personal repos in `~/Dev/github`, work repos in `~/Dev/sephoraeme`

## 📝 Notes

- **Accounts by folder**: under `~/Dev/sephoraeme/`, git uses the work email, signing key and SSH key ([`sephoraeme.config`](home/dot_config/git/sephoraeme.config.tmpl)), and a [`gh` wrapper](home/dot_local/bin/executable_gh) uses the work login. No `gh auth switch`, so agents in different herdr panes never flip each other's account. Another account `<name>`: copy `sephoraeme.config.tmpl` and its email template, add its `includeIf`, and a line in `ssh-key-sync` and the `gh` wrapper.
- **[`ssh-key-sync`](home/dot_local/bin/executable_ssh-key-sync)** creates `~/.ssh/id_ed25519` (or `~/.ssh/<account>`), adds it to GitHub through a throwaway `gh` login (asked each run, deleted after), adds GitHub's host keys to `known_hosts`, and commits a personal key to [`authorized_keys`](home/private_dot_ssh/authorized_keys): the other machines get it with `chezmoi update`.
- **gh over SSH**: macOS keeps the Keychain from SSH sessions, so the agents' tokens are in `~/.config/gh*/hosts.yml` (yours only, encrypted at rest by FileVault).
- **At home without Tailscale**: `ssh -4 <user>@<hostname>.local`.
- `dotfiles.vspiewak.com` is GitHub Pages serving [`install.sh`](install.sh) ([`pages.yml`](.github/workflows/pages.yml)). The previous MacBook setup is on [`legacy`](https://github.com/vspiewak/dotfiles/tree/legacy).
