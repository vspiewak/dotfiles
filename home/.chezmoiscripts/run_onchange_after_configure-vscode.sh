#!/bin/sh
set -eu

# installs (or updates) these; extensions added by hand are kept
for extension in \
	GitHub.vscode-github-actions \
	ms-azuretools.vscode-docker \
	ms-vscode-remote.remote-containers \
	ms-vscode-remote.remote-ssh \
	ms-vscode-remote.remote-ssh-edit \
	ms-vscode-remote.vscode-remote-extensionpack \
	yzhang.markdown-all-in-one; do
	code --force --install-extension "$extension"
done
