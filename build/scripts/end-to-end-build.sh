#!/usr/bin/env bash

set -e

[ -z "${SLEEP_BETWEEN_STAGES}" ] && SLEEP_BETWEEN_STAGES=3

[ -z "$1" ] && echo "end-to-end-build.sh DEVICE" && exit 1

RUNDIR="$(readlink -f "$(dirname "$0")")"

echo "Build initial image"
sleep "${SLEEP_BETWEEN_STAGES}"
"${RUNDIR}/setup-image.sh"

echo "Clone the openwrt repo"
sleep "${SLEEP_BETWEEN_STAGES}"
"${RUNDIR}/clone.sh"

echo "Update source feeds"
sleep "${SLEEP_BETWEEN_STAGES}"
"${RUNDIR}/update-feeds.sh"

echo "Copy config for $1"
sleep "${SLEEP_BETWEEN_STAGES}"
"${RUNDIR}/copy-config.sh" "$1"

echo "Download source code"
sleep "${SLEEP_BETWEEN_STAGES}"
"${RUNDIR}/build-download-sources.sh"

echo "Compile the final image"
sleep "${SLEEP_BETWEEN_STAGES}"
"${RUNDIR}/build-compile.sh"
