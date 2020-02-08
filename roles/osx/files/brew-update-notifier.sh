#!/bin/bash

BREW=$(command -v brew)
TERMINAL_NOTIFIER=$(command -v terminal-notifier)

$BREW update > /dev/null 2>&1

outdated=$($BREW outdated --quiet)
pinned=$($BREW list --pinned)
updatable=$(comm -1 -3 <(echo "$pinned") <(echo "$outdated"))

if [ -n "$updatable" ] && [ -e "$TERMINAL_NOTIFIER" ]; then
  $TERMINAL_NOTIFIER -sender com.apple.Terminal \
    -title "Homebrew Updates Available" \
    -subtitle "The following formulae are outdated:" \
    -message "$updatable" \
    -sound default
fi
