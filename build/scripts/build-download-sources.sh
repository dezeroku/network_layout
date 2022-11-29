#!/usr/bin/env bash
set -e

RUNDIR="$(readlink -f "$(dirname "$0")")"

cd openwrt
"${RUNDIR}/run.sh" make download -j"$(nproc)"
