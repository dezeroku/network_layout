#!/usr/bin/env bash
set -euo pipefail

# Run 'uci show' on the sysroot

SCRIPTS_DIR="$(readlink -f "$(dirname "$0")")/.."

. "${SCRIPTS_DIR}"/common

function usage() {
    echo "get-uci-config.sh image1.img.gz"
    exit 1
}

function cleanup() {
    rm -rf "${TMPDIR}"
}

[ -z "${1:-}" ] && usage

IMAGE="$(readlink -f "${1}")"

echoerr "Image: ${IMAGE}"

TMPDIR="$(mktemp -d)"
pushd "${TMPDIR}" > /dev/null

trap cleanup EXIT

dirty_unpack_rpi4b_image "${IMAGE}" .

ensure_uci_runner

docker run -it --rm -v "$PWD/etc:/etc" uci-runner show
