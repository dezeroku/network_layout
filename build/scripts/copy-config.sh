#!/usr/bin/env bash
set -e

RUNDIR="$(readlink -f "$(dirname "$0")")"

. "${RUNDIR}"/common

cd "${BUILDDIR}"

# Copy the base upstream config, modifications and then expand
cat "${RUNDIR}/../${DEVICE}/config.orig" > .config
if [ -f "${DEVICE_CONFIG_FILE}" ]; then
    echoerr "Applying ${DEVICE_CONFIG_FILE}" on top of original .config
    cat "${DEVICE_CONFIG_FILE}" >> .config
fi

"${RUNDIR}/run.sh" make defconfig

# Remove the custom files present and copy from config dir
if [ -d "${RUNDIR}/../${DEVICE}/files" ]; then
    echoerr "Copying custom files from ${RUNDIR}/../${DEVICE}/files"
    rm -rf "${BUILDDIR}/files"
    cp -r "${RUNDIR}/../${DEVICE}/files" "${BUILDDIR}/files"
fi
