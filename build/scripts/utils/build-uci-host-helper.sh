#!/usr/bin/env bash

# This is meant to be run directly in the container
# so no additional sourcing happens here

set -euo pipefail

TMP_SYSROOT="$(mktemp -d)"

# libubox
function build_libubox() {
    local LIBUBOX_BUILD_DIR="$(mktemp -d)"
    pushd "${LIBUBOX_BUILD_DIR}"
    #mkdir build-libubox && cd build-libubox
    cmake /builder/libubox-source -DBUILD_LUA=OFF -DBUILD_EXAMPLES=OFF -DBUILD_STATIS=ON
    make -j8
    make DESTDIR="${TMP_SYSROOT}" install
    popd
}

# uci
function build_uci() {
    local UCI_BUILD_DIR="$(mktemp -d)"
    pushd "${UCI_BUILD_DIR}"
    #mkdir build-uci && cd build-uci
    cmake /builder/uci-source -DCMAKE_PREFIX_PATH="${TMP_SYSROOT}/usr/local/" -DBUILD_LUA=OFF -DBUILD_STATIC=ON
    make -j8
    make DESTDIR="${TMP_SYSROOT}" install
}

build_libubox
build_uci

# Get static binary
cp "${TMP_SYSROOT}/usr/local/bin/uci" /builder/uci
