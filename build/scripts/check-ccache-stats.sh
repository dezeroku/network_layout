#!/usr/bin/env bash
set -e

RUNDIR="$(readlink -f "$(dirname "$0")")"

. "${RUNDIR}"/common
parse_env_args

cd "${BUILDDIR}"
"${RUNDIR}/run.sh" ./staging_dir/host/bin/ccache -s -d /ccache-storage
