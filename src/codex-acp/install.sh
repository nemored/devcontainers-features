#!/bin/sh
set -e

VERSION="${VERSION:-"latest"}"

if [ "$VERSION" = "latest" ]; then
    npm install -g @zed-industries/codex-acp
else
    npm install -g @zed-industries/codex-acp@{VERSION}
fi

codex-acp --help || exit 1
echo "codex-acp successfully installed."
