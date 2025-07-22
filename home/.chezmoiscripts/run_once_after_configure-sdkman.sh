#!/bin/bash
#sdkman will crash
#set -eufo pipefail


# source sdkman
export SDKMAN_DIR="$HOME/.sdkman"
[[ -s "$HOME/.sdkman/bin/sdkman-init.sh" ]] && source "$HOME/.sdkman/bin/sdkman-init.sh"

# install jdks
sdk install java 21.0.8-tem
sdk install java 8.0.462-amzn

# set default
sdk default java 21.0.8-tem