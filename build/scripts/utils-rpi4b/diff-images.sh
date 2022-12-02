#!/usr/bin/env bash
set -euo pipefail

# Unpack two images and run diff on them
# This is reaaaly hacky at the moment

SCRIPTS_DIR="$(readlink -f "$(dirname "$0")")/.."

. "${SCRIPTS_DIR}"/common

function usage() {
    echo "compare-images.sh image1.img.gz image2.img.gz"
    exit 1
}


function cleanup() {
    rm -rf "${TMPDIR}"
}

[ -z "${1:-}" ] && usage
[ -z "${2:-}" ] && usage

FIRST="$(readlink -f "${1}")"
SECOND="$(readlink -f "${2}")"

echoerr "${FIRST}"
echoerr "${SECOND}"

TMPDIR="$(mktemp -d)"

pushd "${TMPDIR}" > /dev/null

trap cleanup EXIT

dirty_unpack_rpi4b_image "${FIRST}" first
dirty_unpack_rpi4b_image "${SECOND}" second

du -s first second

diff -r first second --no-dereference
