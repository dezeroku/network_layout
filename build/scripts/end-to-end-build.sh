#!/usr/bin/env bash

set -e

[ -z "${SLEEP_BETWEEN_STAGES}" ] && SLEEP_BETWEEN_STAGES=3
[ -z "${SKIP_DOWNLOADS:-}" ] && SKIP_DOWNLOADS="false"

RUNDIR="$(readlink -f "$(dirname "$0")")"

. "${RUNDIR}"/common
parse_args

echo "Build docker build environment image"
sleep "${SLEEP_BETWEEN_STAGES}"
"${RUNDIR}/setup-image.sh"

if [[ ! "${SKIP_DOWNLOADS}" == "true" ]]; then
    echo "Clone the openwrt repo"
    sleep "${SLEEP_BETWEEN_STAGES}"
    "${RUNDIR}/clone.sh"
else
    echo "Skipping cloning because of SKIP_DOWNLOADS=true"
fi

if [[ ! "${SKIP_DOWNLOADS}" == "true" ]]; then
    echo "Update source feeds"
    sleep "${SLEEP_BETWEEN_STAGES}"
    "${RUNDIR}/update-feeds.sh"
else
    echo "Skipping feeds update because of SKIP_DOWNLOADS=true"
fi

echo "Copy config for $1"
sleep "${SLEEP_BETWEEN_STAGES}"
"${RUNDIR}/copy-config.sh"

if [[ ! "${SKIP_DOWNLOADS}" == "true" ]]; then
    echo "Download source code"
    sleep "${SLEEP_BETWEEN_STAGES}"
    "${RUNDIR}/build-download-sources.sh"
else
    echo "Skipping source code download because of SKIP_DOWNLOADS=true"
fi

echo "Compile the final image"
sleep "${SLEEP_BETWEEN_STAGES}"
"${RUNDIR}/build-compile.sh"
