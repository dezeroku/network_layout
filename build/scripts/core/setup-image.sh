#!/usr/bin/env bash
set -e

SCRIPTS_DIR="$(readlink -f "$(dirname "$0")")/.."

# shellcheck source=build/scripts/common
. "${SCRIPTS_DIR}/common"

cd "${SCRIPTS_DIR}/../docker-setup/"
docker build -t openwrt-builder .
