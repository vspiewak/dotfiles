# dotfiles

My macOS setup, managed with [chezmoi](https://www.chezmoi.io).
The previous MacBook setup lives on the [`legacy`](https://github.com/vspiewak/dotfiles/tree/legacy) branch.

## Install

1. Install [Homebrew](https://brew.sh) (it also installs the Xcode Command Line Tools):

   ```sh
   /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
   ```

2. Install chezmoi and apply the dotfiles:

   ```sh
   curl -fsSL dotfiles.vspiewak.com | sh
   ```

3. Open a new terminal.

`dotfiles.vspiewak.com` is GitHub Pages serving [`install.sh`](install.sh), published by [`pages.yml`](.github/workflows/pages.yml).

## Update

```sh
chezmoi update
```
