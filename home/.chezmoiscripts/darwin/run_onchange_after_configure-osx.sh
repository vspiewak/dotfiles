#!/bin/bash

set -eufo pipefail

trap 'killall Dock' EXIT

# Enable TouchID for sudo
! grep -q pam_tid.so /etc/pam.d/sudo && sudo gsed -i '2iauth       sufficient     pam_tid.so' /etc/pam.d/sudo

# Don’t show recent applications in Dock
defaults write com.apple.dock show-recents -int 0

