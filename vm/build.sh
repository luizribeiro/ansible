#!/usr/bin/env bash

cd "$(dirname "$0")" || exit 1

VM="$1"
AVAILABLE_VMS=$(ls -d ./*/ | sed -E 's#\./([a-z-]+)//#\1#g')

usage() {
  echo "Usage: $0 <vm>"
  echo ""
  echo "Where VM should be one of:"
  for available_vm in $AVAILABLE_VMS; do
    echo " - $available_vm"
  done
  echo ""
  exit 1
}

if [[ ! " ${AVAILABLE_VMS[@]} " =~ " ${VM} " ]]; then
  usage
fi

for vm in $AVAILABLE_VMS; do
  echo $vm
done
