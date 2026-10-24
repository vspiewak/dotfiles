#!/bin/sh
set -eu

# installs (or updates) these; extensions added by hand are kept
for extension in \
	GitHub.vscode-github-actions \
	golang.Go \
	ms-azuretools.vscode-docker \
	ms-vscode-remote.vscode-remote-extensionpack \
	yzhang.markdown-all-in-one; do
	code --force --install-extension "$extension"
done
