# nixos-common-config

NixOS common configuration modules, shared across machines via `nixos-shared-flakes`.

## Directory layout

```
├── applications/   # user-facing application configs
├── basic-config/   # core system defaults (boot, nix, fonts, locale, etc.)
├── filesystem/     # disk and mount definitions
├── networking/     # network interfaces, firewall, proxies
├── security/       # sudo, ssh, kernel hardening
├── hooks/          # git hook templates
├── flake.nix       # flake entrypoint — exposes build-host function
└── install-hooks.py # hook installer
```

## Pre-commit hook

The pre-commit hook validates that a downstream (consumer) NixOS configuration can build against the current state of **this** repository *before* a commit lands.  This catches breakage early and prevents pushing changes that would fail to build for consumers.

### What it does

1. Clones a target NixOS config repository into a temporary directory.
2. Rewrites `flake.nix` inputs in the cloned repo so that references to a remote URL are redirected to `file:///<this-repo>` — the build runs against your *local* working tree.
3. Runs `nixos-rebuild build --flake` against the cloned config to verify it compiles.

### Installing the hook

> **⚠️ Run the installer before making any commit.**  The hook is not active until installed.

```bash
./install-hooks.py <repo_url> <to_substitute> [branch]
```

| Argument | Required | Description |
|---|---|---|
| `repo_url` | yes | URL of the downstream NixOS config repo to clone during each commit |
| `to_substitute` | yes | URL pattern in the cloned `flake.nix` that will be replaced with `git+file://<this-repo>` |
| `branch` | no | Git branch or ref to checkout (defaults to the remote's HEAD) |

**Example:**

```bash
./install-hooks.py \
    https://github.com/example/my-nixos-config.git \
    github:somebody/nixos-shared-flake \
    main
```

### How the substitution works

The hook uses a literal string replacement (`sed`) to rewrite the cloned repo's `flake.nix`.  Every occurrence of `<to_substitute>` is replaced with `git+file://<path-to-this-repo>`.  For the example above, a flake input like:

```nix
inputs.nixos-shared-flakes.url = "github:somebody/nixos-shared-flake";
```

would become:

```nix
inputs.nixos-shared-flakes.url = "git+file:///home/user/nixos-common-config";
```

This ensures the downstream config resolves the shared flake from your local checkout rather than from the remote.

### `install-hooks.sh`

A shell-script equivalent is provided for environments without Python 3.  The Python version (`install-hooks.py`) is preferred: it uses `string.Template` for safe literal substitution that avoids the injection pitfalls of `sed`-based template expansion.
