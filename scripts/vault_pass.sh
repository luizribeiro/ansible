#!/bin/sh

set -eo pipefail
OLD_DIR="$(pwd)"
cd "$(dirname "$0")/.." || exit 1

gpg --quiet --batch --use-agent --decrypt ./vault_pass.gpg

cd "$OLD_DIR" || exit 1
