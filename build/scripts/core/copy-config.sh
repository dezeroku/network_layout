#!/usr/bin/env bash
set -e

SCRIPTS_DIR="$(readlink -f "$(dirname "$0")")/.."

. "${SCRIPTS_DIR}"/common
parse_env_args

cd "${BUILDDIR}"

# Copy the base upstream config, modifications and then expand
cat "${SCRIPTS_DIR}/../${DEVICE}/config.orig" > .config
if [[ ! "${REPRODUCE_UPSTREAM_BUILD}" == "true" ]]; then
    if [ -f "${DEVICE_CONFIG_FILE}" ]; then
        echoerr "Applying ${DEVICE_CONFIG_FILE}" on top of original .config
        cat "${DEVICE_CONFIG_FILE}" >> .config
    fi
else
    echoerr "Skipping custom .config because of REPRODUCE_UPSTREAM_BUILD=true"
fi

"${SCRIPTS_DIR}/core/run.sh" make defconfig

rm -rf "${BUILDDIR}/files"
if [[ ! "${REPRODUCE_UPSTREAM_BUILD}" == "true" ]]; then
    # Remove the custom files present and copy from config dir
    if [ -d "${SCRIPTS_DIR}/../${DEVICE}/files" ]; then
        echoerr "Copying custom files from ${SCRIPTS_DIR}/../${DEVICE}/files"
        cp -r "${SCRIPTS_DIR}/../${DEVICE}/files" "${BUILDDIR}/files"
    fi
else
    echoerr "Skipping copying custom files because of REPRODUCE_UPSTREAM_BUILD=true"
fi
