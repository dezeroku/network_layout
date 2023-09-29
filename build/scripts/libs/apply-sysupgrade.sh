#!/usr/bin/env bash
set -euo pipefail

# This script applies the sysupgrade WITHOUT PRESERVING ANY CONFIGURATION ON THE ROUTER
# However by default a local backup gets created

function usage() {
	echo "apply-sysupgrade sysupgrade_file router_ip"
	exit 1
}

APPLY_SYSUPGRADE_PERFORM_BACKUP="true"

[ -z "${1:-}" ] && usage
[ -z "${2:-}" ] && usage

SYSUPGRADE_FILE="$(readlink -f "${1}")"
ROUTER_IP="${2}"

SSH_HOST="root@${ROUTER_IP}"
SYSUPGRADE_FILE_CHECKSUM="$(sha256sum "${SYSUPGRADE_FILE}" | cut -d " " -f 1)"
ROUTER_SYSUPGRADE_FILE="$(ssh -T "${SSH_HOST}" mktemp)"

echoerr "Running an update with ${SYSUPGRADE_FILE}"

if [[ "${APPLY_SYSUPGRADE_PERFORM_BACKUP}" == "true" ]]; then
	BACKUP_FILE="$(mktemp --suffix ".tar.gz")"
	echoerr "Backing up the router configuration as ${BACKUP_FILE}"
	ssh -T "${SSH_HOST}" "sysupgrade -b -" >"${BACKUP_FILE}"
	echoerr "Backup succeeded"
fi

# poor man's scp for better compability
# We want this to expand on the client's side
# shellcheck disable=SC2029
ssh "${SSH_HOST}" "cat > ${ROUTER_SYSUPGRADE_FILE}" <"${SYSUPGRADE_FILE}"
ROUTER_SYSUPGRADE_FILE_CHECKSUM="$(ssh -T "${SSH_HOST}" "sha256sum ${ROUTER_SYSUPGRADE_FILE} | cut -d ' ' -f 1")"
if [[ "${ROUTER_SYSUPGRADE_FILE_CHECKSUM}" != "${SYSUPGRADE_FILE_CHECKSUM}" ]]; then
	echo "Copied file failed the checksum check!"
	echo "expected: ${SYSUPGRADE_FILE_CHECKSUM} got: ${ROUTER_SYSUPGRADE_FILE_CHECKSUM}"
	exit 1
fi

echoerr "Performing the sysupgrade"
# We want this to expand on the client's side
# shellcheck disable=SC2029
ssh "${SSH_HOST}" "sysupgrade -v -n ${ROUTER_SYSUPGRADE_FILE}"
