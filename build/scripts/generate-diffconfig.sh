#!/usr/bin/env bash

# You should make run that 'make defconfig' was run first, for best reproducibility
# 1. generate "normal" diffconfig based on current .config
# 2. Remove lines that are already present in device specific config.orig

# Depends on:
# 1. dos2unix
# 2. combine

set -e

RUNDIR="$(readlink -f "$(dirname "$0")")"

. "${RUNDIR}/common"
parse_args

cd "${BUILDDIR}"

TMPFILE="$(mktemp)"

"${RUNDIR}/run.sh" ./scripts/diffconfig.sh > "${TMPFILE}"

# sanitize generated diffconfig
dos2unix "${TMPFILE}" -q

combine "${TMPFILE}" not "${RUNDIR}/../${DEVICE}/config.orig"
