#!/bin/env bash
set -e

repo_home="$(git rev-parse --show-toplevel)"

cd "${repo_home}"

cp -r hooks/* .git/hooks/
