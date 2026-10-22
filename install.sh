#!/bin/sh
#
# Bootstrap a Mac with Homebrew, chezmoi and these dotfiles:
#
#   curl -fsSL dotfiles.vspiewak.com | sh
#
# Homebrew's installer also installs the Xcode Command Line Tools.

HOMEBREW_INSTALL_URL=https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh

# everything runs from main() so a truncated download never runs half a script
main() {
	set -eu

	if [ "$(uname -s)" != "Darwin" ]; then
		echo "error: macOS only" >&2
		exit 1
	fi

	installed_homebrew=false
	if ! command -v brew >/dev/null 2>&1 && [ ! -x /opt/homebrew/bin/brew ]; then
		install_homebrew
		installed_homebrew=true
	fi

	# brew is not on PATH in this shell yet (fresh install or terminal not restarted)
	if ! command -v brew >/dev/null 2>&1 && [ -x /opt/homebrew/bin/brew ]; then
		eval "$(/opt/homebrew/bin/brew shellenv)"
	fi

	if ! command -v chezmoi >/dev/null 2>&1; then
		brew install chezmoi
	fi

	chezmoi init --apply vspiewak

	echo
	echo "Done. Open a new terminal to load the new environment."
	if [ "$installed_homebrew" = true ]; then
		echo "Skip Homebrew's \"Next steps\" above: chezmoi already manages ~/.zprofile."
	fi
}

install_homebrew() {
	# when piped into sh, stdin is this script: Homebrew needs the terminal to ask for sudo
	if ! (: </dev/tty) 2>/dev/null; then
		echo "error: no terminal to install Homebrew from, install it first:" >&2
		echo "  /bin/bash -c \"\$(curl -fsSL $HOMEBREW_INSTALL_URL)\"" >&2
		exit 1
	fi

	/bin/bash -c "$(curl -fsSL "$HOMEBREW_INSTALL_URL")" </dev/tty
}

main "$@"
