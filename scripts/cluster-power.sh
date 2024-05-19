#!/bin/sh

if [ $# -ne 1 ]; then
    echo "Usage: $0 <on|off>"
    exit 1
fi

SCRIPT_DIR=$(realpath $(dirname $0))
ansible-playbook "$SCRIPT_DIR/../infrastructure/ansible/host-power.yml" --extra-vars "state=$1"
