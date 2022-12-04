#!/usr/bin/env bash
set -e

SCRIPTS_DIR="$(readlink -f "$(dirname "$0")")/.."

. "${SCRIPTS_DIR}"/common

# Build the runner image
pushd "${SCRIPTS_DIR}/../uci-build"
docker build -t uci-runner .
