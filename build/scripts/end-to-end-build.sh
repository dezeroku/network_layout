#!/usr/bin/env bash

set -e

[ -z "${SLEEP_BETWEEN_STAGES}" ] && SLEEP_BETWEEN_STAGES=3

RUNDIR="$(readlink -f "$(dirname "$0")")"

. "${RUNDIR}"/common

echo "Build docker build environment image"
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
"${RUNDIR}/copy-config.sh"

echo "Download source code"
sleep "${SLEEP_BETWEEN_STAGES}"
"${RUNDIR}/build-download-sources.sh"

echo "Compile the final image"
sleep "${SLEEP_BETWEEN_STAGES}"
"${RUNDIR}/build-compile.sh"
