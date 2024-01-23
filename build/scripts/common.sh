#!/usr/bin/env bash

# This file is not meant to be run
# It contains a collection of utilities to be shared by every script

set -euo pipefail

function echoerr() {
	echo "$@" 1>&2
}

check_tool() {
	local tool
	tool="$1"
	if ! command -v "${tool}" >/dev/null; then
		echoerr "${tool} command not found"
		return 1
	fi
}

function parse_env_args() {
	if [ -z "${SCRIPTS_DIR:-}" ]; then
		echo "SCRIPTS_DIR is required to be in env"
		echo "Did you start the script properly?"
		exit 1
	fi

	SCRIPTS_DIR="$(readlink -f "${SCRIPTS_DIR}")"

	if [ -z "${DEVICE:-}" ]; then
		echo "DEVICE is required to be in env" && exit 1
	fi

	[ -z "${DEVICE_ENV_FILE:-}" ] && DEVICE_ENV_FILE="$(readlink -f "${SCRIPTS_DIR}/../config/${DEVICE}/variables")"
	DEVICE_ENV_FILE="$(readlink -f "${DEVICE_ENV_FILE}")"

	if [ -z "${DEVICE_TEMPLATE_ENV_FILE:-}" ]; then
		[ -f "${SCRIPTS_DIR}/../config/${DEVICE}/template-variables.yaml" ] && DEVICE_TEMPLATE_ENV_FILE="$(readlink -f "${SCRIPTS_DIR}/../config/${DEVICE}/template-variables.yaml")"
	else
		DEVICE_TEMPLATE_ENV_FILE="$(readlink -f "${DEVICE_TEMPLATE_ENV_FILE}")"
	fi

	if [ -z "${DEVICE_TEMPLATE_SECRET_ENV_FILE:-}" ]; then
		[ -f "${SCRIPTS_DIR}/../config/${DEVICE}/secret-variables.yaml" ] && DEVICE_TEMPLATE_SECRET_ENV_FILE="$(readlink -f "${SCRIPTS_DIR}/../config/${DEVICE}/secret-variables.yaml")"
	else
		DEVICE_TEMPLATE_SECRET_ENV_FILE="$(readlink -f "${DEVICE_TEMPLATE_SECRET_ENV_FILE}")"
	fi

	[ -z "${REPRODUCE_UPSTREAM_BUILD:-}" ] && REPRODUCE_UPSTREAM_BUILD="false"

	[ -z "${DEVICE_CONFIG_FILE:-}" ] && DEVICE_CONFIG_FILE="$(readlink -f "${SCRIPTS_DIR}/../config/${DEVICE}/config")"
	DEVICE_CONFIG_FILE="$(readlink -f "${DEVICE_CONFIG_FILE}")"

	echoerr "DEVICE=${DEVICE}"
	echoerr "DEVICE_CONFIG_FILE=${DEVICE_CONFIG_FILE}"
	echoerr "DEVICE_ENV_FILE=${DEVICE_ENV_FILE}"
	if [ -n "${DEVICE_TEMPLATE_ENV_FILE:-}" ]; then
		echoerr "DEVICE_TEMPLATE_ENV_FILE=${DEVICE_TEMPLATE_ENV_FILE}"
	fi
	if [ -n "${DEVICE_TEMPLATE_SECRET_ENV_FILE:-}" ]; then
		echoerr "DEVICE_TEMPLATE_SECRET_ENV_FILE=${DEVICE_TEMPLATE_SECRET_ENV_FILE}"
	fi
	echoerr "REPRODUCE_UPSTREAM_BUILD=${REPRODUCE_UPSTREAM_BUILD}"

	# Example file for reference
	# shellcheck source=build/config/rpi4b/variables
	. "${DEVICE_ENV_FILE}"

	if [ -z "${BUILDDIR:-}" ]; then
		mkdir -p "${SCRIPTS_DIR}/../builds"
		BUILDDIR="${SCRIPTS_DIR}/../builds/openwrt-${DEVICE}"
	fi

	[ -z "${OPENWRT_VERSION:-}" ] && echo "No OPENWRT_VERSION provided" && exit 1

	# This is pretty hacky
	# We rely on clone step to create this directory
	# but we also want it to be an absolute path in the next steps
	if [ -d "$BUILDDIR" ]; then
		BUILDDIR="$(readlink -f "${BUILDDIR}")"
	fi

	echoerr "BUILDDIR=${BUILDDIR}"
	echoerr "OPENWRT_VERSION=${OPENWRT_VERSION}"

	export DEVICE
	export BUILDDIR
	export OPENWRT_VERSION
}
