# Dev Container Features

This repository contains dev container Features published from the `src` directory.

## Features

### `codex-acp`

Installs Zed Industries' ACP adapter for Codex CLI.

```jsonc
{
    "image": "mcr.microsoft.com/devcontainers/base:ubuntu",
    "features": {
        "ghcr.io/nemored/devcontainers-features/codex-acp:0": {}
    }
}
```

### `orchard`

Installs the Orchard CLI from [cirruslabs/orchard](https://github.com/cirruslabs/orchard).

```jsonc
{
    "image": "mcr.microsoft.com/devcontainers/base:ubuntu",
    "features": {
        "ghcr.io/nemored/devcontainers-features/orchard:0": {}
    }
}
```

## Repository Structure

Each Feature has its own subdirectory under `src`, containing at least a `devcontainer-feature.json` and an `install.sh` entrypoint.

```text
src/
├── codex-acp/
│   ├── devcontainer-feature.json
│   ├── install.sh
│   └── README.md
└── orchard/
    ├── devcontainer-feature.json
    ├── install.sh
    └── README.md
```

Feature tests live under `test/<feature>`.

## Testing

Run the feature test suite from the repository root:

```bash
devcontainer features test .
```

To test a single feature directly:

```bash
devcontainer features test -f codex-acp .
devcontainer features test -f orchard .
```

## Publishing

The release workflow publishes Features from `src` to GitHub Container Registry and generates per-feature documentation.

Features are referenced with the repository namespace:

```text
ghcr.io/nemored/devcontainers-features/<feature>:<version>
```
