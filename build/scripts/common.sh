#!/usr/bin/env bash

# This file is not meant to be run
# It contains a collection of utilities to be shared by every script

set -euo pipefail

function echoerr() {
	echo "$@" 1>&2
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
		[ -f "${SCRIPTS_DIR}/../config/${DEVICE}/template-variables" ] && DEVICE_TEMPLATE_ENV_FILE="$(readlink -f "${SCRIPTS_DIR}/../config/${DEVICE}/template-variables")"
	else
		DEVICE_TEMPLATE_ENV_FILE="$(readlink -f "${DEVICE_TEMPLATE_ENV_FILE}")"
	fi

	if [ -z "${DEVICE_SECRET_TEMPLATE_ENV_FILE:-}" ]; then
		[ -f "${SCRIPTS_DIR}/../config/${DEVICE}/template-variables" ] && DEVICE_SECRET_TEMPLATE_ENV_FILE="$(readlink -f "${SCRIPTS_DIR}/../config/${DEVICE}/secret-variables")"
	else
		DEVICE_SECRET_TEMPLATE_ENV_FILE="$(readlink -f "${DEVICE_SECRET_TEMPLATE_ENV_FILE}")"
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
	if [ -n "${DEVICE_SECRET_TEMPLATE_ENV_FILE:-}" ]; then
		echoerr "DEVICE_SECRET_TEMPLATE_ENV_FILE=${DEVICE_SECRET_TEMPLATE_ENV_FILE}"
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

	BUILDDIR="$(readlink -f "${BUILDDIR}")"

	echoerr "BUILDDIR=${BUILDDIR}"
	echoerr "OPENWRT_VERSION=${OPENWRT_VERSION}"

	export DEVICE
	export BUILDDIR
	export OPENWRT_VERSION
}
