#!/bin/bash

set -eufo pipefail

trap 'killall Dock' EXIT

defaults write com.apple.dock show-recents -int 0

