#!/usr/bin/env bash
set -e

RUNDIR="$(readlink -f "$(dirname "$0")")"

. "${RUNDIR}"/common

cd "${BUILDDIR}"
"${RUNDIR}/run.sh" make -j"$(nproc)"
