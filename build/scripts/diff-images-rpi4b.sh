#!/usr/bin/env bash
set -euo pipefail

# Unpack two images and run diff on them
# This is reaaaly hacky at the moment

RUNDIR="$(readlink -f "$(dirname "$0")")"

. "${RUNDIR}"/common

function usage() {
    echo "compare-images.sh image1.img.gz image2.img.gz"
    exit 1
}


function cleanup() {
    # Clean the mounts
    #sudo umount "${TMPDIR}/first/boot"
    #sudo umount "${TMPDIR}/first/root"
    #sudo umount "${TMPDIR}/second/boot"
    #sudo umount "${TMPDIR}/second/root"
    :
}

function mount_in_dir() {
    local file="$1"
    local dir="$2"

    local img="$(mktemp --suffix=.img)"

    # gunzip can be picky about trailing stuff, let's ignore it for now
    gunzip < "${file}" > "${img}" 2> /dev/null || true

    #mkdir -p "${dir}/boot"
    #mkdir -p "${dir}/root"

    #local loop=$(sudo losetup --show -fP "${img}")
    #sudo mount "${loop}p1" "${dir}/boot"
    #sudo mount "${loop}p2" "${dir}/root"

    # Just hack out the unpacking, mounting does not seem to like the format of our images
    echoerr "Unpacking ${file}"
    mkdir -p "${dir}"

    # This is dirty
    # Don't fire me :/
    7z x "${img}" -O"${dir}" > /dev/null 2> /dev/null || true
    7z x "${dir}/0.fat" -O"${dir}" > /dev/null 2> /dev/null || true
    7z x "${dir}/1.img" -O"${dir}" > /dev/null 2> /dev/null || true

    rm "${dir}/0.fat"
    rm "${dir}/1.img"
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

mount_in_dir "${FIRST}" first
mount_in_dir "${SECOND}" second

du -s first second

diff -r first second
