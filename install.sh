#!/bin/sh
#
# Bootstrap chezmoi and apply these dotfiles:
#
#   curl -fsSL dotfiles.vspiewak.com | sh
#
# Homebrew is a prerequisite, not installed here: its installer is interactive
# (sudo, Xcode Command Line Tools) and doesn't behave when piped into a shell.

# everything runs from main() so a truncated download never runs half a script
main() {
	set -eu

	if [ "$(uname -s)" != "Darwin" ]; then
		echo "error: macOS only" >&2
		exit 1
	fi

	# brew can be installed but not on PATH yet (terminal not restarted)
	if ! command -v brew >/dev/null 2>&1 && [ -x /opt/homebrew/bin/brew ]; then
		eval "$(/opt/homebrew/bin/brew shellenv)"
	fi

	if ! command -v brew >/dev/null 2>&1; then
		cat >&2 <<'EOF'
Homebrew is not installed. Install it first (it also installs the Xcode Command Line Tools):

  /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"

Then run this installer again.
EOF
		exit 1
	fi

	if ! command -v chezmoi >/dev/null 2>&1; then
		brew install chezmoi
	fi

	chezmoi init --apply vspiewak

	echo
	echo "Done. Open a new terminal to load the new environment."
}

main "$@"
