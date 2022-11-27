#!/usr/bin/env bash
set -e

[ -z "$1" ] && echo "copy-config.sh DEVICE" && exit 1

DEVICE="$1"

RUNDIR="$(readlink -f "$(dirname "$0")")"

cd openwrt
# Copy the base upstream config, modifications and then expand
cat "${RUNDIR}/../${DEVICE}/config.orig" "${RUNDIR}/../${DEVICE}/config" > .config
"${RUNDIR}/run.sh" make defconfig
