#!/bin/sh

SCRIPT_DIR=$(realpath $(dirname $0))
ansible-vault decrypt "${SCRIPT_DIR}/../metal/inventory/group_vars/proxmox/vault.yml"
ansible-vault decrypt "${SCRIPT_DIR}/../metal/inventory/group_vars/all/vault.yml"
