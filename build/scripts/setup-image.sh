#!/usr/bin/env bash
set -e

RUNDIR="$(readlink -f "$(dirname "$0")")"

cd "${RUNDIR}/../docker-setup/"
docker build -t openwrt-builder .

