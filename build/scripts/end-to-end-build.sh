#!/usr/bin/env bash

set -e

[ -z "${SLEEP_BETWEEN_STAGES}" ] && SLEEP_BETWEEN_STAGES=3
[ -z "${SKIP_DOWNLOADS:-}" ] && SKIP_DOWNLOADS="false"

RUNDIR="$(readlink -f "$(dirname "$0")")"

. "${RUNDIR}"/common
parse_env_args

echoerr "Build docker build environment image"
sleep "${SLEEP_BETWEEN_STAGES}"
"${RUNDIR}/setup-image.sh"

if [[ ! "${SKIP_DOWNLOADS}" == "true" ]]; then
    echoerr "Clone the openwrt repo"
    sleep "${SLEEP_BETWEEN_STAGES}"
    "${RUNDIR}/clone.sh"
else
    echoerr "Skipping cloning because of SKIP_DOWNLOADS=true"
fi

if [[ ! "${SKIP_DOWNLOADS}" == "true" ]]; then
    echoerr "Update source feeds"
    sleep "${SLEEP_BETWEEN_STAGES}"
    "${RUNDIR}/update-feeds.sh"
else
    echoerr "Skipping feeds update because of SKIP_DOWNLOADS=true"
fi

echoerr "Copy config for ${DEVICE}"
sleep "${SLEEP_BETWEEN_STAGES}"
"${RUNDIR}/copy-config.sh"

if [[ ! "${SKIP_DOWNLOADS}" == "true" ]]; then
    echoerr "Download source code"
    sleep "${SLEEP_BETWEEN_STAGES}"
    "${RUNDIR}/build-download-sources.sh"
else
    echoerr "Skipping source code download because of SKIP_DOWNLOADS=true"
fi

echoerr "Compile the final image"
sleep "${SLEEP_BETWEEN_STAGES}"
"${RUNDIR}/build-compile.sh"
