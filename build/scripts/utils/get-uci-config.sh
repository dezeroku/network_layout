#!/usr/bin/env bash
set -euo pipefail

# Unpack two images and run diff on them
# This is reaaaly hacky at the moment

SCRIPTS_DIR="$(readlink -f "$(dirname "$0")")/.."

# shellcheck source=build/scripts/common
. "${SCRIPTS_DIR}"/common
parse_env_args

# shellcheck source=build/scripts/libs/uci
. "${SCRIPTS_DIR}/libs/uci"

# Reference import
# shellcheck source=build/scripts/libs/rpi4b
. "${SCRIPTS_DIR}/libs/${DEVICE}"

# shellcheck source=build/scripts/libs/get-uci-config-runner
. "${SCRIPTS_DIR}/libs/get-uci-config-runner"
