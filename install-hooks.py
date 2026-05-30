#!/usr/bin/env python3
"""Install the pre-commit hook by substituting template values into hooks/pre-commit.

Usage: install-hooks.py <repo_url> <to_substitute> [branch]

  repo_url       - URL of the nixos config repository to clone during the hook
  to_substitute  - URL pattern in the cloned flake.nix that will be replaced
                   with a file:/// path pointing to this local repository
  branch         - optional git branch/ref to checkout (defaults to HEAD)

The script validates that repo_url is reachable via git ls-remote before
installing to avoid installing a hook that would always fail.
"""

import subprocess
import sys
from pathlib import Path
from string import Template


class HookTemplate(Template):
    """Template subclass using @ as delimiter instead of $ to avoid collision
    with bash variable syntax in the hook script.  Placeholders are written as
    @VARNAME@, e.g. @REPO_URL@.  Template.substitute() performs literal string
    replacement, preventing the injection issues that sed would introduce when
    values contain regex-special characters or the delimiter."""
    delimiter = "@"
    pattern = r"\@(?P<named>[a-zA-Z_][a-zA-Z_0-9]*)\@"


def git_root():
    """Return the absolute path to the repository root."""
    result = subprocess.run(
        ["git", "rev-parse", "--show-toplevel"],
        capture_output=True, text=True, check=True
    )
    return result.stdout.strip()


def check_repo_accessible(url):
    """Return True if the given URL is reachable by git."""
    result = subprocess.run(
        ["git", "ls-remote", "--quiet", url],
        capture_output=True, text=True
    )
    return result.returncode == 0


def main():
    if len(sys.argv) < 3:
        print("Error: repository URL and substitution target are required", file=sys.stderr)
        print(f"Usage: {sys.argv[0]} <repo_url> <to_substitute> [branch]", file=sys.stderr)
        sys.exit(1)

    repo_url = sys.argv[1]
    to_substitute = sys.argv[2]
    branch = sys.argv[3] if len(sys.argv) > 3 else ""

    if not branch:
        print("Warning: no branch specified, using default branch", file=sys.stderr)

    print(f"Checking if {repo_url} is accessible...", file=sys.stderr)
    if not check_repo_accessible(repo_url):
        print(f"Error: repository '{repo_url}' is not accessible", file=sys.stderr)
        sys.exit(1)

    root = git_root()
    template_path = Path(root) / "hooks" / "pre-commit"
    hooks_dir = Path(root) / ".git" / "hooks"

    template_source = template_path.read_text()

    result = HookTemplate(template_source).substitute(
        REPO_URL=repo_url,
        TO_SUBSTITUTE=to_substitute,
        BRANCH=branch,
    )

    hooks_dir.mkdir(parents=True, exist_ok=True)
    hook_path = hooks_dir / "pre-commit"
    hook_path.write_text(result)
    hook_path.chmod(0o755)

    print("pre-commit hook installed successfully", file=sys.stderr)


if __name__ == "__main__":
    main()
