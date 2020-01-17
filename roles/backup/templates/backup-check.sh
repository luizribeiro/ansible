#!/bin/sh

if [ "$#" -ne 1 ]; then
    echo "usage: $0 <hostname>"
    exit 2
fi

displaytime() {
  T=$1
  D=$((T / 60 / 60 / 24))
  H=$((T / 60 / 60 % 24))
  M=$((T / 60 % 60))
  S=$((T % 60))
  [ $D -gt 0 ] && printf '%d days ' $D
  [ $H -gt 0 ] && printf '%d hours ' $H
  [ $M -gt 0 ] && printf '%d minutes ' $M
  [ $D -gt 0 ] || [ $H -gt 0 ] || [ $M -gt 0 ] && printf 'and '
  printf '%d seconds\n' $S
}

fatal() {
  echo "FATAL: $1"
  exit 1
}

HOSTNAME="$1"
export HOME="/root"
export RESTIC_REPOSITORY="{{ restic_backup_repo_prefix }}/$HOSTNAME"
export RESTIC_PASSWORD="{{ secret_restic_password }}"

echo "Checking backup for $HOSTNAME..."

LAST_BACKUP_DATE=$(restic snapshots --last --json | jq --raw-output ".[0].time")
LAST_BACKUP_TIMESTAMP=$(date -d "$LAST_BACKUP_DATE" +%s)
CURRENT_TIMESTAMP=$(date +%s)
SECONDS_SINCE_LAST_BACKUP=$((CURRENT_TIMESTAMP - LAST_BACKUP_TIMESTAMP))

printf "Time since last backup: "
displaytime $SECONDS_SINCE_LAST_BACKUP

MAX_BACKUP_AGE=$((48 * 3600))
if [ $SECONDS_SINCE_LAST_BACKUP -gt $MAX_BACKUP_AGE ]; then
  fatal "Most recent backup is too old."
fi

echo "Running checks on backup..."
CHECK_OUTPUT=$(restic check)
case "$CHECK_OUTPUT" in
  *"no errors were found"*) ;;
  *) fatal "Errors were found on backup." ;;
esac

echo "Everything looks OK!"
