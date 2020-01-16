#!/bin/sh

export RESTIC_REPOSITORY="{{ restic_backup_repo }}"
export RESTIC_PASSWORD="{{ secret_restic_password }}"

{
  restic backup --exclude-file backup-excludes.txt {{ backup_paths | join (" ") }}
  restic check
  restic forget --keep-daily 7 --keep-weekly 5 --keep-monthly 12
} 2>&1 | tee /var/log/backup.log
