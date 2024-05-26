#!/bin/sh

if [ $# -ne 1 ]; then
    echo "Usage: $0 <on|off>"
    exit 1
fi

SCRIPT_DIR=$(realpath $(dirname $0))
ANSIBLE_DIR="$SCRIPT_DIR/../infrastructure/ansible"

direnv exec $ANSIBLE_DIR ansible-playbook -i $ANSIBLE_DIR/inventory/hosts.yml $ANSIBLE_DIR/host-power.yml --extra-vars "state=$1"
