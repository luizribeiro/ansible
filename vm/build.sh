#!/usr/bin/env bash

cd "$(dirname "$0")" || exit 1

VM="$1"
AVAILABLE_VMS=$(ls -d */ | sed -E 's#/##g' | grep -v boxes)

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

if [[ ! ${AVAILABLE_VMS[@]} =~ (^|[[:space:]])${VM}($|[[:space:]]) ]]; then
  usage
fi

cd "$VM"
vagrant destroy --force
vagrant up
vagrant package
vagrant cloud publish \
  --release --force \
  "luizribeiro/$VM" \
  "$(date +"%Y.%m.%d")" \
  virtualbox package.box
