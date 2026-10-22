# dotfiles

My macOS setup, managed with [chezmoi](https://www.chezmoi.io).
The previous MacBook setup lives on the [`legacy`](https://github.com/vspiewak/dotfiles/tree/legacy) branch.

## Install

```sh
curl -fsSL dotfiles.vspiewak.com | sh
```

It installs [Homebrew](https://brew.sh) if missing (which also installs the Xcode Command Line Tools, and asks for your password), then chezmoi, then applies the dotfiles. Open a new terminal when it's done.

`dotfiles.vspiewak.com` is GitHub Pages serving [`install.sh`](install.sh), published by [`pages.yml`](.github/workflows/pages.yml).

## Update

```sh
chezmoi update
```
