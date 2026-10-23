# dotfiles

My macOS setup, managed with [chezmoi](https://www.chezmoi.io).
The previous MacBook setup lives on the [`legacy`](https://github.com/vspiewak/dotfiles/tree/legacy) branch.

## Install

```sh
curl -fsSL dotfiles.vspiewak.com | sh
```

It asks for your password once, then runs unattended: [Homebrew](https://brew.sh) if missing (which also installs the Xcode Command Line Tools), chezmoi, then the dotfiles. Open a new terminal when it's done. Over SSH, use `ssh -t` so it has a terminal for the password prompt.

The dotfiles set up:

- [Tailscale](https://tailscale.com) as a system daemon, so the machine is on the tailnet at boot, before anyone logs in, with the same device name as the Mac's hostname; your user can run `tailscale up` / `tailscale down` without sudo
- SSH (Remote Login) with keys only (`~/.ssh/authorized_keys`), no password logins
- [herdr](https://herdr.dev), so the machine can be used as a herdr SSH machine
- Touch ID for `sudo` (on a Mac mini, with a Touch ID keyboard)
- CLI tools and apps from Homebrew, listed in [`install-packages.sh`](home/.chezmoiscripts/run_onchange_before_install-packages.sh)
- [Starship](https://starship.rs) prompt for zsh, configured in [`starship.toml`](home/dot_config/starship.toml)
- Git name and email, in [`~/.config/git/config`](home/dot_config/git/config.tmpl)
- Repo folders: `~/Dev/github` (personal) and `~/Dev/sephoraeme` (work account, see below)
- [Ghostty](https://ghostty.org) theme and font settings, in [`config`](home/dot_config/ghostty/config)
- VS Code extensions, listed in [`configure-vscode.sh`](home/.chezmoiscripts/run_onchange_after_configure-vscode.sh)

One manual step per machine, to join the tailnet (it signs in through a browser, so chezmoi can't do it; the login then stays across reboots and updates):

```sh
tailscale up
```

To use it as a herdr machine, from the herdr client (e.g. the MacBook): `herdr machine add <user>@<hostname> --label <hostname>`.

`dotfiles.vspiewak.com` is GitHub Pages serving [`install.sh`](install.sh), published by [`pages.yml`](.github/workflows/pages.yml).

## SSH keys

On a new machine, run once:

```sh
ssh-key-sync
```

[It](home/dot_local/bin/executable_ssh-key-sync) creates `~/.ssh/id_ed25519` (named after the hostname) if missing, adds it to GitHub as an authentication and a signing key, adds GitHub's host keys to `~/.ssh/known_hosts` (so `git` over SSH never asks, e.g. for agents), and commits it to [`authorized_keys`](home/private_dot_ssh/authorized_keys). The other machines get it with `chezmoi update`, so they can all SSH into each other. Git signs commits once the key exists.

It asks to log in to GitHub each time, with a throwaway `gh` login that can manage SSH keys and is deleted at the end.

## gh for agents

Where agents run (over SSH, e.g. in herdr), log in `gh` once, with the default scopes:

```sh
gh auth login --hostname github.com --git-protocol ssh --skip-ssh-key --web --insecure-storage
```

Over SSH, macOS doesn't let `gh` read the Keychain, so the token is saved in `~/.config/gh/hosts.yml` (readable only by you, encrypted at rest by FileVault).

## Work account

Repos under `~/Dev/sephoraeme/` use the work GitHub account (`vspiewak-sephoraeme`): git takes its email, signing key and SSH key from [`sephoraeme.config`](home/dot_config/git/sephoraeme.config.tmpl), and a [`gh` wrapper](home/dot_local/bin/executable_gh) picks the work login there. Each account has its own `gh` config, so there's no `gh auth switch` changing the account for every shell (e.g. agents in other herdr panes).

Once per machine, logged in to github.com as the work account in the browser:

```sh
ssh-key-sync sephoraeme   # ~/.ssh/sephoraeme, on the work account only
cd ~/Dev/sephoraeme      # created by chezmoi
gh auth login --hostname github.com --git-protocol ssh --skip-ssh-key --web --insecure-storage
```

The `sephoraeme` organization enforces SAML SSO: at github.com/settings/keys (as the work account), **Configure SSO** on the new authentication key and authorize it for `sephoraeme`; if `gh` then reports a SAML error, open the link it prints to authorize its token too.

Another account, `<name>` for repos under `~/Dev/<name>/`: copy `sephoraeme.config.tmpl` (and its email in `.chezmoitemplates`), add its `includeIf` to the git config, and a line for it in `ssh-key-sync` and the `gh` wrapper.

## Update

```sh
chezmoi update
```

It asks for your password once, up front, then runs unattended.
