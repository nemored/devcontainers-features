#!/bin/sh
set -e

VERSION="${VERSION:-latest}"
PACKAGE="@zed-industries/codex-acp"
BINARY="codex-acp"

case "$(uname -s)" in
    Linux) ;;
    *)
        echo "ERROR: Codex ACP feature only supports Linux containers." >&2
        exit 1
        ;;
esac

if ! command -v npm >/dev/null 2>&1; then
    echo 'ERROR: npm is not installed, but this feature declares a dependency on "ghcr.io/devcontainers/features/node:1".' >&2
    echo "The Node.js feature dependency may not have installed successfully." >&2
    exit 1
fi

resolved_version="$(npm view "${PACKAGE}@${VERSION}" version)"
package_spec="${PACKAGE}@${resolved_version}"

echo "Installing ${PACKAGE} ${resolved_version}..."
npm install -g --omit=dev --no-audit --no-fund "${package_spec}"

if ! command -v "${BINARY}" >/dev/null 2>&1; then
    echo "ERROR: ${BINARY} was not found on PATH after installation." >&2
    exit 1
fi

"${BINARY}" --help >/dev/null
echo "${BINARY} ${resolved_version} installed successfully."
