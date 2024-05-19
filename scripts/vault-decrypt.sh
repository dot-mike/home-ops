#!/usr/bin/env bash

SCRIPT_DIR=$(realpath $(dirname $0))

FILES=(
    "${SCRIPT_DIR}/../infrastructure/ansible/inventory/group_vars/proxmox/vault.yml"
    "${SCRIPT_DIR}/../infrastructure/ansible/inventory/group_vars/all/vault.yml"
    "${SCRIPT_DIR}/../.env"
)

EXTRA_ARGS=""
VAULT_COMMAND="ansible-vault"

if [[ -z "${ANSIBLE_VAULT_PASSWORD_FILE:-}" ]]; then
    EXTRA_ARGS="--vault-password-file ${SCRIPT_DIR}/../.vault-pass"
fi

for FILE in "${FILES[@]}"; do
    if [ ! -f "$FILE" ]; then
        echo "File not found: $FILE"
        exit 1
    fi

    OWNER=$(stat -c %u "$FILE")
    PERMS=$(stat -c %a "$FILE")

    $VAULT_COMMAND decrypt $EXTRA_ARGS "$FILE"

    chown $OWNER "$FILE"
    chmod $PERMS "$FILE"
done
