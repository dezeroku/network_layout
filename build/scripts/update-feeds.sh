#!/usr/bin/env bash
set -e

RUNDIR="$(readlink -f "$(dirname "$0")")"

. "${RUNDIR}/common"
parse_args

cd "${BUILDDIR}"
"${RUNDIR}/run.sh" ./scripts/feeds update -a
"${RUNDIR}/run.sh" ./scripts/feeds install -a
