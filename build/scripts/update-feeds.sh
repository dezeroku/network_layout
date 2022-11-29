#!/usr/bin/env bash
set -e

RUNDIR="$(readlink -f "$(dirname "$0")")"

cd openwrt
"${RUNDIR}/run.sh" ./scripts/feeds update -a
"${RUNDIR}/run.sh" ./scripts/feeds install -a
