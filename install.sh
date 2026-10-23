#!/bin/sh
#
# Bootstrap a Mac with Homebrew, chezmoi and these dotfiles:
#
#   curl -fsSL dotfiles.vspiewak.com | sh
#
# Homebrew's installer also installs the Xcode Command Line Tools.

# everything runs from main() so a truncated download never runs half a script
main() {
	set -eu

	if [ "$(uname -s)" != "Darwin" ]; then
		echo "error: macOS only" >&2
		exit 1
	fi

	# when piped into sh, stdin is this script: sudo and Homebrew need the terminal
	if ! (: </dev/tty) 2>/dev/null; then
		echo "error: run this from a terminal (over SSH: ssh -t), it needs your password" >&2
		exit 1
	fi

	# ask for the password once, then keep sudo alive until this script exits
	sudo -v -p "Password (asked once for the whole install): "
	while kill -0 $$ 2>/dev/null; do
		sudo -n true
		sleep 60
	done 2>/dev/null &

	installed_homebrew=false
	if ! command -v brew >/dev/null 2>&1 && [ ! -x /opt/homebrew/bin/brew ]; then
		# no "Press RETURN", sudo is already cached; the terminal stays attached for
		# Homebrew's Command Line Tools GUI fallback
		NONINTERACTIVE=1 /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)" </dev/tty
		installed_homebrew=true
	fi

	# brew is not on PATH in this shell yet (fresh install or terminal not restarted)
	if ! command -v brew >/dev/null 2>&1 && [ -x /opt/homebrew/bin/brew ]; then
		eval "$(/opt/homebrew/bin/brew shellenv)"
	fi

	if ! command -v chezmoi >/dev/null 2>&1; then
		brew install chezmoi
	fi

	# init only clones on the first run; update pulls the latest, regenerates the
	# config from its template (asks new questions, e.g. hostname) and applies
	chezmoi init vspiewak
	chezmoi update --init

	echo
	echo "Done. Open a new terminal to load the new environment."
	if [ "$installed_homebrew" = true ]; then
		echo "Skip Homebrew's \"Next steps\" above: chezmoi already manages ~/.zprofile."
	fi
}

main "$@"
