#!/bin/bash

export RESTIC_REPOSITORY="{{ restic_backup_repo }}"
export RESTIC_PASSWORD="{{ secret_restic_password }}"
export AWS_ACCESS_KEY_ID="{{ secret_wasabi_access_key }}"
export AWS_SECRET_ACCESS_KEY="{{ secret_wasabi_secret_key }}"

DATE=$(command -v gdate date | head -1)

{
  echo ">>> ===================================================================="
  echo -n ">>> $($DATE): Waiting for connection..."
  i="0"
  while ! timeout 1 ping -c 1 -n 8.8.8.8 &> /dev/null
  do
    echo -n "."
    i=$[$i+1]
    if [[ $i -ge 20 ]]; then
      echo " FAIL"
      exit 1
    fi
  done
  echo " DONE"

  echo -n ">>> $($DATE): Backing up..."
  restic backup --exclude-file backup-excludes.txt {{ backup_paths | join (" ") }} || exit 1
  echo ">>> DONE"
  echo

  echo ">>> $($DATE): Checking backups..."
  restic check || exit 1
  echo ">>> DONE"
  echo

  echo ">>> $($DATE): Cleaning up old backups..."
  restic forget --keep-daily 7 --keep-weekly 5 --keep-monthly 12 --prune || exit 1
  echo ">>> DONE"
  echo
} 2>&1 | tee -a /var/log/backup.log
