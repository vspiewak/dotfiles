#!/bin/bash
set -eufo pipefail

# Install Rosetta (Better experience for Docker)
softwareupdate --install-rosetta --agree-to-license
