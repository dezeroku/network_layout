#!/usr/bin/env bash
set -e

RUNDIR="$(readlink -f "$(dirname "$0")")"

. "${RUNDIR}"/common

cd "${BUILDDIR}"
# Copy the base upstream config, modifications and then expand
cat "${RUNDIR}/../${DEVICE}/config.orig" "${RUNDIR}/../${DEVICE}/config" > .config
"${RUNDIR}/run.sh" make defconfig
