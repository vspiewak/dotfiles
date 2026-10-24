#!/bin/sh
set -eu

# Claude Code, with its own installer: it updates itself (~/.local/bin on its
# PATH, or it asks to add it to ~/.zshrc, which ~/.zprofile already does)
curl -fsSL https://claude.ai/install.sh | PATH="$HOME/.local/bin:$PATH" bash
