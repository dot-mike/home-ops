#!/bin/sh

SCRIPT_DIR=$(realpath $(dirname $0))
ansible-vault encrypt "${SCRIPT_DIR}/../metal/inventory/group_vars/proxmox/vault.yml"
ansible-vault encrypt "${SCRIPT_DIR}/../metal/inventory/group_vars/all/vault.yml"
