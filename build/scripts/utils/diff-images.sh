#!/usr/bin/env bash
set -euo pipefail

# Unpack two images and run diff on them

SCRIPTS_DIR="$(readlink -f "$(dirname "$0")")/.."

# shellcheck source=build/scripts/common
. "${SCRIPTS_DIR}"/common
parse_env_args

# Reference import
# shellcheck source=build/scripts/libs/rpi4b
. "${SCRIPTS_DIR}/libs/${DEVICE}"

# shellcheck source=build/scripts/libs/diff-images-runner
. "${SCRIPTS_DIR}/libs/diff-images-runner"
