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

# 5. work account vspiewak-<work>: same, logged in to github.com as it, then
#    authorize the new key for SAML SSO if asked (github.com/settings/keys)
ssh-key-sync <work>
cd ~/Dev/github-<work> && gh auth login --hostname github.com --git-protocol ssh --skip-ssh-key --web --insecure-storage

# 6. from the herdr client (e.g. the MacBook)
herdr machine add <user>@<hostname>.<tailnet>.ts.net --label <hostname>

# later, to update (asks your password once)
chezmoi update --init
```

## ✨ What you get

- 📦 **Homebrew**: CLI tools and apps, listed in [`install-packages.sh`](home/.chezmoiscripts/run_onchange_before_install-packages.sh)
- 🔒 **Tailscale**: system daemon, on the tailnet at boot, named after the hostname, `tailscale up`/`down` without sudo
- 🔑 **SSH**: Remote Login with keys only, from Tailscale and private networks only (not the internet)
- ⚡ **Always on** (Macs without a battery, e.g. the Mac mini): never sleeps, restarts after a power failure
- 👆 **Touch ID** for `sudo` (on a Mac mini: with a Touch ID keyboard)
- 🐚 **zsh**: [Starship](https://starship.rs) prompt, completion, per-pane history, emacs keys
- 👻 **Ghostty**: Catppuccin Frappe, no ligatures, its terminfo installed on SSH hosts
- 🧩 **VS Code** extensions, listed in [`configure-vscode.sh`](home/.chezmoiscripts/run_onchange_after_configure-vscode.sh)
- 🌿 **git**: signed commits, personal repos in `~/Dev/github`, work repos in `~/Dev/github-<work>`
- ☁️ **gcloud**: your work login in `~/.config/gcloud`, a repo's own in its `.gcloud/` (never committed)
- 🐳 **Docker** with [Colima](https://github.com/abiosoft/colima): `docker`, `docker compose`, Testcontainers; a VM of 8 CPUs and 16 GB, up after each login ([`configure-colima.sh`](home/.chezmoiscripts/run_onchange_after_configure-colima.sh))
- ☕ **Java, Node and Python** with [mise](https://mise.jdx.dev): JDK 25 (default) and 11, Node 24, Python 3.14, [`config.toml`](home/dot_config/mise/config.toml); a repo's `.sdkmanrc`, `.nvmrc` or `.python-version` picks its own

## 📝 Notes

- **Accounts by folder**: in `~/Dev/github-<name>/`, a [`gh` wrapper](home/dot_local/bin/executable_gh) uses the `vspiewak-<name>` login, and for the work account git uses its email, signing key and SSH key ([`work.config`](home/dot_config/git/work.config.tmpl)). No `gh auth switch`, so agents in different herdr panes never flip each other's account. The work name and emails are hex-encoded in [`.chezmoi.toml.tmpl`](home/.chezmoi.toml.tmpl): a new job is a new value there, then `ssh-key-sync <work>`.
- **[`ssh-key-sync [<name>]`](home/dot_local/bin/executable_ssh-key-sync)** creates `~/Dev/github` (or `~/Dev/github-<name>`) and `~/.ssh/id_ed25519` (or `~/.ssh/<name>`), adds it to GitHub through a throwaway `gh` login (asked each run, deleted after), adds GitHub's host keys to `known_hosts`, and commits a personal key to [`authorized_keys`](home/private_dot_ssh/authorized_keys): the other machines get it with `chezmoi update`.
- **gh over SSH**: macOS keeps the Keychain from SSH sessions, so the agents' tokens are in `~/.config/gh*/hosts.yml` (yours only, encrypted at rest by FileVault).
- **gcloud by repo**: in a repo with a `.gcloud/` folder, `gcloud`, Spring's credentials and everything started there (agents too) use that login, set up once with `mkdir .gcloud && cd . && gcloud auth login --update-adc`. Everywhere else: your work login, refreshed with the same `gcloud auth login --update-adc`. Over SSH, add `--no-launch-browser` and paste back the code Google shows. It's [`.zshenv`](home/dot_zshenv) setting `CLOUDSDK_CONFIG` on each `cd`.
- **Java, Node and Python versions**: mise picks them from the folder each time `java`, `node` or `python` runs, so an agent that `cd`s into a repo gets that repo's. For one shell: `export MISE_JAVA_VERSION=temurin-11` (or `MISE_NODE_VERSION=22`). A repo pinning a JDK that isn't installed yet: `mise install` in it, once (a missing Node or Python installs by itself). `npm i -g` installs for the current Node version only.
- **At home without Tailscale**: `ssh -4 <user>@<hostname>.local`.
- `dotfiles.vspiewak.com` is GitHub Pages serving [`install.sh`](install.sh) ([`pages.yml`](.github/workflows/pages.yml)). The previous MacBook setup is on [`legacy`](https://github.com/vspiewak/dotfiles/tree/legacy).
