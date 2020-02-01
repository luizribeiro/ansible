#!/bin/sh

OLD_DIR="$(pwd)"
cd "$(dirname "$0")" || exit 1

VAULT="$(ansible-vault view --vault-password-file ./vault_pass.sh ../secrets.yaml)"
secret() {
  echo "$VAULT" | grep "$1" | cut -f 2 -d ' ' | sed "s/['\"]//g"
}

ENDPOINT="$(secret secret_wasabi_endpoint)"
BUCKET="$(secret secret_wasabi_bucket)"
HOST="$1"

export RESTIC_REPOSITORY="s3:https://$ENDPOINT/$BUCKET/$HOST"
export RESTIC_PASSWORD="$(secret secret_restic_password)"
export AWS_ACCESS_KEY_ID="$(secret secret_wasabi_access_key)"
export AWS_SECRET_ACCESS_KEY="$(secret secret_wasabi_secret_key)"

RESTIC_ARGS=""
for arg in "${@:2}"; do
  RESTIC_ARGS="$RESTIC_ARGS $arg"
done

restic $RESTIC_ARGS

cd "$OLD_DIR" || exit 1
