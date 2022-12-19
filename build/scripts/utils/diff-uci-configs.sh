#!/usr/bin/env bash
set -e

SCRIPTS_DIR="$(readlink -f "$(dirname "$0")")/.."

# shellcheck source=build/scripts/common
. "${SCRIPTS_DIR}"/common

function usage() {
	echo "diff-uci-configs.sh DEFAULT CUSTOM"
	echo "    The script will show entries that are present in custom"
	echo "    but aren't in default"
	exit 1
}

function cleanup() {
	rm -rf "${TMPDIR}"
}

[ -z "${1:-}" ] && usage
[ -z "${2:-}" ] && usage

DEFAULT="${1}"
CUSTOM="${2}"

TMPDIR="$(mktemp -d)"
trap cleanup EXIT

DEFAULT_TMP="${TMPDIR}/default"
CUSTOM_TMP="${TMPDIR}/custom"

cp "${DEFAULT}" "${DEFAULT_TMP}"
cp "${CUSTOM}" "${CUSTOM_TMP}"

# Sanitize both files
dos2unix "${DEFAULT_TMP}"
dos2unix "${CUSTOM_TMP}"

combine "${CUSTOM_TMP}" not "${DEFAULT_TMP}"
