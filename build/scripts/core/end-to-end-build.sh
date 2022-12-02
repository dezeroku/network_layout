#!/usr/bin/env bash

set -e

[ -z "${SLEEP_BETWEEN_STAGES}" ] && SLEEP_BETWEEN_STAGES=3
[ -z "${SKIP_DOWNLOADS:-}" ] && SKIP_DOWNLOADS="false"

SCRIPTS_DIR="$(readlink -f "$(dirname "$0")")/.."

. "${SCRIPTS_DIR}"/common
parse_env_args

echoerr "Build docker build environment image"
sleep "${SLEEP_BETWEEN_STAGES}"
"${SCRIPTS_DIR}/core/setup-image.sh"

if [[ ! "${SKIP_DOWNLOADS}" == "true" ]]; then
    echoerr "Clone the openwrt repo"
    sleep "${SLEEP_BETWEEN_STAGES}"
    "${SCRIPTS_DIR}/core/clone.sh"
else
    echoerr "Skipping cloning because of SKIP_DOWNLOADS=true"
fi

if [[ ! "${SKIP_DOWNLOADS}" == "true" ]]; then
    echoerr "Update source feeds"
    sleep "${SLEEP_BETWEEN_STAGES}"
    "${SCRIPTS_DIR}/core/update-feeds.sh"
else
    echoerr "Skipping feeds update because of SKIP_DOWNLOADS=true"
fi

echoerr "Copy config for ${DEVICE}"
sleep "${SLEEP_BETWEEN_STAGES}"
"${SCRIPTS_DIR}/core/copy-config.sh"

if [[ ! "${SKIP_DOWNLOADS}" == "true" ]]; then
    echoerr "Download source code"
    sleep "${SLEEP_BETWEEN_STAGES}"
    "${SCRIPTS_DIR}/core/build-download-sources.sh"
else
    echoerr "Skipping source code download because of SKIP_DOWNLOADS=true"
fi

echoerr "Compile the final image"
sleep "${SLEEP_BETWEEN_STAGES}"
"${SCRIPTS_DIR}/core/build-compile.sh"
