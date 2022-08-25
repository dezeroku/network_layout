#!/usr/bin/env bash
set -e

ROOTDIR="$(pwd)"

cd openwrt
"${ROOTDIR}/scripts/run.sh" ./scripts/feeds update -a
"${ROOTDIR}/scripts/run.sh" ./scripts/feeds install -a

