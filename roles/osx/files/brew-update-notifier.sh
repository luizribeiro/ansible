#!/bin/bash

BREW=$(command -v brew)
TERMINAL_NOTIFIER=$(command -v terminal-notifier)
STATUS_FILE="$HOME/.local/.brew-last-notified"

$BREW update > /dev/null 2>&1

outdated=$( ($BREW outdated --quiet && $BREW cask outdated --quiet) | sort -u)
pinned=$($BREW list --pinned)
updatable=$(comm -1 -3 <(echo "$pinned") <(echo "$outdated"))

if [ -n "$updatable" ] && [ -e "$TERMINAL_NOTIFIER" ]; then
  current_time=$(date +%s)
  if [ -f "$STATUS_FILE" ]; then
    last_notif=$(stat -f "%m" "$STATUS_FILE")
  else
    last_notif=0
  fi

  if (( last_notif >= (current_time - (60 * 60 * 24)) )); then
    # limit to one notification per day
    exit
  fi

  touch "$STATUS_FILE"
  $TERMINAL_NOTIFIER -sender com.apple.Terminal \
    -title "Homebrew Updates Available" \
    -subtitle "The following formulae are outdated:" \
    -message "$updatable" \
    -sound default
fi
