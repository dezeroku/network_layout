#!/usr/bin/env bash
set -euo pipefail

# Unpack two images and run diff on them

SCRIPTS_DIR="$(readlink -f "$(dirname "$0")")/.."

. "${SCRIPTS_DIR}"/common
. "${SCRIPTS_DIR}/libs/rpi4b"

. "${SCRIPTS_DIR}/libs/diff-images-runner"
