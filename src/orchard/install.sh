#!/bin/sh
set -e

VERSION="${VERSION:-latest}"
REPO_URL="https://github.com/cirruslabs/orchard"
INSTALL_DIR="/usr/local/bin"

install_packages() {
    packages="$*"
    if command -v apt-get >/dev/null 2>&1; then
        export DEBIAN_FRONTEND=noninteractive
        apt-get update -y
        apt-get install -y --no-install-recommends $packages
    elif command -v apk >/dev/null 2>&1; then
        apk add --no-cache $packages
    elif command -v dnf >/dev/null 2>&1; then
        dnf install -y $packages
    elif command -v yum >/dev/null 2>&1; then
        yum install -y $packages
    else
        echo "ERROR: Could not find a supported package manager to install: $packages" >&2
        exit 1
    fi
}

if ! command -v curl >/dev/null 2>&1 || ! command -v sha256sum >/dev/null 2>&1; then
    install_packages ca-certificates curl coreutils
fi

case "$(uname -s)" in
    Linux) ;;
    *)
        echo "ERROR: Orchard CLI feature only supports Linux containers." >&2
        exit 1
        ;;
esac

case "$(uname -m)" in
    x86_64|amd64)
        ARCH="amd64"
        ;;
    aarch64|arm64)
        ARCH="arm64"
        ;;
    *)
        echo "ERROR: Unsupported architecture: $(uname -m)" >&2
        exit 1
        ;;
esac

if [ "$VERSION" = "latest" ]; then
    latest_url="$(curl -fsSLI -o /dev/null -w '%{url_effective}' "${REPO_URL}/releases/latest")"
    VERSION="${latest_url##*/}"
fi

asset_name="orchard-linux-${ARCH}"
checksums_name="orchard_${VERSION}_checksums.txt"
download_url="${REPO_URL}/releases/download/${VERSION}/${asset_name}"
checksums_url="${REPO_URL}/releases/download/${VERSION}/${checksums_name}"
tmp_dir="$(mktemp -d)"
trap 'rm -rf "$tmp_dir"' EXIT

echo "Installing Orchard CLI ${VERSION} for linux-${ARCH}..."

curl -fsSL "${download_url}" -o "${tmp_dir}/${asset_name}"
curl -fsSL "${checksums_url}" -o "${tmp_dir}/checksums.txt"

grep "  ${asset_name}$" "${tmp_dir}/checksums.txt" > "${tmp_dir}/orchard.sha256"
(cd "${tmp_dir}" && sha256sum -c orchard.sha256)

install -d "${INSTALL_DIR}"
install -m 0755 "${tmp_dir}/${asset_name}" "${INSTALL_DIR}/orchard"

orchard --version
echo "Orchard CLI ${VERSION} installed successfully."
