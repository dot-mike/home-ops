#!/bin/bash

SCRIPT_DIR=$(dirname "$(readlink -f "$0")")
ansible-vault decrypt "${SCRIPT_DIR}/../metal/inventory/group_vars/proxmox/vault.yml"
ansible-vault decrypt "${SCRIPT_DIR}/../metal/inventory/group_vars/all/vault.yml"
