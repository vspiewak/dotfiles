#!/bin/sh
set -eu

# Rosetta, for Colima's amd64 images (without it QEMU emulates them, slower)
sudo softwareupdate --install-rosetta --agree-to-license
