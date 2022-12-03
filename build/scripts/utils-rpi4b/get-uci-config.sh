#!/usr/bin/env bash
set -euo pipefail

# Unpack two images and run diff on them
# This is reaaaly hacky at the moment

SCRIPTS_DIR="$(readlink -f "$(dirname "$0")")/.."

. "${SCRIPTS_DIR}"/common
. "${SCRIPTS_DIR}/libs/rpi4b"

. "${SCRIPTS_DIR}/libs/get-uci-config-runner"
