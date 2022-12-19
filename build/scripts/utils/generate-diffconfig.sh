#!/usr/bin/env bash

# You should make run that 'make defconfig' was run first, for best reproducibility
# 1. generate "normal" diffconfig based on current .config
# 2. Remove lines that are already present in device specific config.orig

# Depends on:
# 1. dos2unix
# 2. combine

set -e

SCRIPTS_DIR="$(readlink -f "$(dirname "$0")")/.."

# shellcheck source=build/scripts/common
. "${SCRIPTS_DIR}/common"
parse_env_args

cd "${BUILDDIR}"

TMPFILE="$(mktemp)"

"${SCRIPTS_DIR}/core/run.sh" ./scripts/diffconfig.sh >"${TMPFILE}"

# sanitize generated diffconfig
dos2unix "${TMPFILE}" -q

combine "${TMPFILE}" not "${SCRIPTS_DIR}/../config/${DEVICE}/config.orig"
