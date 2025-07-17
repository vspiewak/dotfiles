#!/bin/bash
#sdkman will crash
#set -eufo pipefail


# source sdkman
export SDKMAN_DIR="$HOME/.sdkman"
[[ -s "$HOME/.sdkman/bin/sdkman-init.sh" ]] && source "$HOME/.sdkman/bin/sdkman-init.sh"

# install default jdk
sdk install java