#!/bin/sh
set -e

VERSION="${VERSION:-"latest"}"

# Check if npm is available
if ! command -v npm > /dev/null 2>&1; then
    echo "ERROR: npm is not installed. Please add the node feature before this one."
    echo "Add \"ghcr.io/devcontainers/features/node:1\": {} to your devcontainer.json"
    exit 1
fi

# Install codex-acp
if [ "$VERSION" = "latest" ]; then
    npm install -g @zed-industries/codex-acp
else
    npm install -g @zed-industries/codex-acp@{VERSION}
fi

codex-acp --help || exit 1
echo "codex-acp successfully installed."
