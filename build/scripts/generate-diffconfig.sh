#!/usr/bin/env bash

# You should make run that 'make defconfig' was run first, for best reproducibility
# 1. generate "normal" diffconfig based on current .config
# 2. Remove lines that are already present in device specific config.orig

set -e

[ -z "$1" ] && echo "generate-diffconfig.sh DEVICE" && exit 1

DEVICE="$1"

RUNDIR="$(readlink -f "$(dirname "$0")")"

cd openwrt

TMPFILE="$(mktemp)"

"${RUNDIR}/run.sh" ./scripts/diffconfig.sh > "${TMPFILE}"

# sanitize generated diffconfig
dos2unix "${TMPFILE}" -q

combine "${TMPFILE}" not "${RUNDIR}/../${DEVICE}/config.orig"
