#!/bin/sh

set -eo pipefail
OLD_DIR="$(pwd)"
cd "$(dirname "$0")/.." || exit 1

if [ -n "$GITHUB_ACTIONS" ]; then
  # github actions don't have a vault setup
  echo "hunter2"
  exit 0
fi

gpg --quiet --batch --use-agent --decrypt ./vault_pass.gpg
