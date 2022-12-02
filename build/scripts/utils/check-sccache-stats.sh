#!/usr/bin/env bash
set -e

SCRIPTS_DIR="$(readlink -f "$(dirname "$0")")/.."

. "${SCRIPTS_DIR}"/common
parse_env_args

cd "${BUILDDIR}"
"${SCRIPTS_DIR}/core/run.sh" /usr/bin/env bash -c 'sccache --start-server && sleep 3 && sccache --show-stats'
