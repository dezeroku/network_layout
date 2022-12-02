#!/usr/bin/env bash
set -e

SCRIPTS_DIR="$(readlink -f "$(dirname "$0")")/.."

. "${SCRIPTS_DIR}"/common

# Prepare image
pushd "${SCRIPTS_DIR}/../uci-build/docker-setup"
docker build -t uci-builder .
popd

# Run the build
docker run -it \
       -v "${SCRIPTS_DIR}/../uci-build:/builder" \
       -v "${SCRIPTS_DIR}/utils/build-uci-host-helper.sh:/build-uci-host-helper.sh" \
       uci-builder bash '/build-uci-host-helper.sh'

# Build the runner image
pushd "${SCRIPTS_DIR}/../uci-build"
docker build -t uci-runner -f docker-setup/Dockerfile.runner .
