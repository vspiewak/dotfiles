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
- SSH with keys only (`~/.ssh/authorized_keys`), no password logins
- [herdr](https://herdr.dev), so the machine can be used as a herdr SSH machine
- Touch ID for `sudo` (on a Mac mini, with a Touch ID keyboard)
- CLI tools and apps from Homebrew, listed in [`install-packages.sh`](home/.chezmoiscripts/run_onchange_before_install-packages.sh)
- [Starship](https://starship.rs) prompt for zsh, configured in [`starship.toml`](home/dot_config/starship.toml)
- Git name and email, in [`~/.config/git/config`](home/dot_config/git/config.tmpl)
- [Ghostty](https://ghostty.org) theme and font settings, in [`config`](home/dot_config/ghostty/config)
- VS Code extensions, listed in [`configure-vscode.sh`](home/.chezmoiscripts/run_onchange_after_configure-vscode.sh)

Two one-time manual steps:

```sh
sudo tailscale up   # log in to the tailnet
```

and System Settings > General > Sharing > **Remote Login** on (it can't be scripted without Full Disk Access).

Then from another machine: `herdr machine add vspiewak@<hostname> --label <hostname>`.

`dotfiles.vspiewak.com` is GitHub Pages serving [`install.sh`](install.sh), published by [`pages.yml`](.github/workflows/pages.yml).

## Update

```sh
chezmoi update
```
