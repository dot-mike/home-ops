#!/bin/sh

#!/bin/sh

SCRIPT_DIR=$(realpath $(dirname $0))

FILES=(
    "${SCRIPT_DIR}/../metal/inventory/group_vars/proxmox/vault.yml"
    "${SCRIPT_DIR}/../metal/inventory/group_vars/all/vault.yml"
    "${SCRIPT_DIR}/../.env"
)

for FILE in "${FILES[@]}"; do
    if [ ! -f "$FILE" ]; then
        echo "File not found: $FILE"
        exit 1
    fi

    OWNER=$(stat -c %u "$FILE")
    PERMS=$(stat -c %a "$FILE")

    ansible-vault decrypt "$FILE"

    chown $OWNER "$FILE"
    chmod $PERMS "$FILE"
done
