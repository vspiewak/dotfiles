# dotfiles

My macOS setup, managed with [chezmoi](https://www.chezmoi.io).
The previous MacBook setup lives on the [`legacy`](https://github.com/vspiewak/dotfiles/tree/legacy) branch.

## Install

```sh
curl -fsSL dotfiles.vspiewak.com | sh
```

It asks for your password once, then runs unattended: [Homebrew](https://brew.sh) if missing (which also installs the Xcode Command Line Tools), chezmoi, then the dotfiles. Open a new terminal when it's done. Over SSH, use `ssh -t` so it has a terminal for the password prompt.

The dotfiles set up:

- [Tailscale](https://tailscale.com) as a system daemon, so the machine is on the tailnet at boot, before anyone logs in; your user can run `tailscale up` / `tailscale down` without sudo
- SSH with keys only (`~/.ssh/authorized_keys`), no password logins
- [herdr](https://herdr.dev), so the machine can be used as a herdr SSH machine
- Touch ID for `sudo` (on a Mac mini, with a Touch ID keyboard)

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
