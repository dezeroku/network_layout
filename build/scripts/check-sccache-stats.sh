#!/usr/bin/env bash
set -e

RUNDIR="$(readlink -f "$(dirname "$0")")"

. "${RUNDIR}"/common
parse_env_args

cd "${BUILDDIR}"
"${RUNDIR}/run.sh" /usr/bin/env bash -c 'sccache --start-server && sleep 3 && sccache --show-stats'
