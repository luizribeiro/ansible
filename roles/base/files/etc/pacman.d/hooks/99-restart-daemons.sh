#!/usr/bin/env bash
SERVICES=$(cat | sed 's!.*/!!')

for service in $SERVICES; do
  if systemctl is-active --quiet "$service"; then
    echo "Restarting $service..."
    systemctl restart "$service"
  else
    echo "Service $service is not running. Skipped."
  fi
done
