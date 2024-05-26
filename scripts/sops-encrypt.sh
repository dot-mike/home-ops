#!/usr/bin/env bash

SCRIPT_DIR=$(realpath $(dirname $0))

find "$SCRIPT_DIR/.." -regex ".*\.sops\.\(yaml\|yml\)" -not -name ".sops.yaml" -exec sops --config "$SCRIPT_DIR/../.sops.yaml" -e -i {} \;
