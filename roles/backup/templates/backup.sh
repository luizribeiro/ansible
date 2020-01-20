#!/bin/bash

export RESTIC_REPOSITORY="{{ restic_backup_repo }}"
export RESTIC_PASSWORD="{{ secret_restic_password }}"

DATE=$(command -v gdate date | head -1)

{
  echo ">>> ===================================================================="
  echo -n ">>> $($DATE): Backing up..."
  restic backup --exclude-file backup-excludes.txt {{ backup_paths | join (" ") }}
  echo ">>> DONE"
  echo

  echo ">>> $($DATE): Checking backups..."
  restic check
  echo ">>> DONE"
  echo

  echo ">>> $($DATE): Cleaning up old backups..."
  restic forget --keep-daily 7 --keep-weekly 5 --keep-monthly 12
  echo ">>> DONE"
  echo
} 2>&1 | tee -a /var/log/backup.log
