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
- [Ghostty](https://ghostty.org) theme and font settings, in [`config`](home/dot_config/ghostty/config)
- VS Code extensions, listed in [`configure-vscode.sh`](home/.chezmoiscripts/run_onchange_after_configure-vscode.sh)

One manual step, to log in to the tailnet:

```sh
sudo tailscale up
```

Then from another machine: `herdr machine add <user>@<hostname> --label <hostname>`.

`dotfiles.vspiewak.com` is GitHub Pages serving [`install.sh`](install.sh), published by [`pages.yml`](.github/workflows/pages.yml).

## SSH keys

On a new machine, run once:

```sh
ssh-key-sync
```

[It](home/dot_local/bin/executable_ssh-key-sync) creates `~/.ssh/id_ed25519` (named after the hostname) if missing, adds it to GitHub as an authentication and a signing key, and commits it to [`authorized_keys`](home/private_dot_ssh/authorized_keys). The other machines get it with `chezmoi update`, so they can all SSH into each other. Git signs commits once the key exists.

It asks to log in to GitHub each time, with a throwaway `gh` login that can manage SSH keys and is deleted at the end.

## gh for agents

Where agents run (over SSH, e.g. in herdr), log in `gh` once, with the default scopes:

```sh
gh auth login --hostname github.com --git-protocol ssh --skip-ssh-key --web --insecure-storage
```

Over SSH, macOS doesn't let `gh` read the Keychain, so the token is saved in `~/.config/gh/hosts.yml` (readable only by you, encrypted at rest by FileVault).

## Update

```sh
chezmoi update
```

It asks for your password once, up front, then runs unattended.
