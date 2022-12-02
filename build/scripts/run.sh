#!/usr/bin/env bash
set -e

RUNDIR="$(readlink -f "$(dirname "$0")")"

[ -z "${CCACHE_STORAGE:-}" ] && CCACHE_STORAGE="$(readlink -f "${RUNDIR}/../ccache-target-storage")"
[ -d "${CCACHE_STORAGE}" ] || mkdir "${CCACHE_STORAGE}"

[ -z "${CCACHE_HOST_STORAGE:-}" ] && CCACHE_HOST_STORAGE="$(readlink -f "${RUNDIR}/../sccache-host-storage")"
[ -d "${CCACHE_HOST_STORAGE}" ] || mkdir "${CCACHE_HOST_STORAGE}"

exec docker run --rm -it \
     -e SCCACHE_CACHE_SIZE="50G" \
     -v $PWD:/builder \
     -v "${CCACHE_STORAGE}":/ccache-storage \
     -v "${CCACHE_HOST_STORAGE}":/home/builder/.cache/sccache \
     openwrt-builder "$@"
