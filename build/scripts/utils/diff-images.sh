#!/usr/bin/env bash
set -euo pipefail

# Unpack two images and run diff on them

SCRIPTS_DIR="$(readlink -f "$(dirname "$0")")/.."

. "${SCRIPTS_DIR}"/common
parse_env_args

. "${SCRIPTS_DIR}/libs/${DEVICE}"

. "${SCRIPTS_DIR}/libs/diff-images-runner"
