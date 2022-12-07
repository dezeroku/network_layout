#!/usr/bin/env bash
set -e

SCRIPTS_DIR="$(readlink -f "$(dirname "$0")")/.."

. "${SCRIPTS_DIR}"/common
parse_env_args

cd "${BUILDDIR}"

# Insert a file into /etc/custom-version-file
# containing device specific info that was used during the build

if [[ ! -d "${BUILDDIR}/files" ]]; then
    mkdir "${BUILDDIR}/files"
fi

CUSTOM_VERSION_FILE="${BUILDDIR}/files/custom-version-file"

function dump_file() {
    # $1 - file
    # $2 - optional filename override
    local file="${1}"

    if [ -z "${2:-}" ]; then
        filename="${file}"
    else
        filename="${2}"
    fi
    echo "========= <${filename}> ========="
    cat "${file}"
    echo "========= >${filename}< ========="
    echo ""
}

DEVICE_DIR="${SCRIPTS_DIR}/../${DEVICE}"

echo SCRIPTS_VERSION="$(cd "${SCRIPTS_DIR}" && git describe HEAD)"
echo SCRIPTS_COMMIT="$(cd "${SCRIPTS_DIR}" && git rev-parse HEAD)"

DEVICE_SECRET_TEMPLATE_ENV_FILE="$(readlink -f "$(dirname "${DEVICE_TEMPLATE_ENV_FILE}")/secret-variables")"

# This should be a list of everything that may affect the build
[ -f "${DEVICE_ENV_FILE}" ] && dump_file "${DEVICE_ENV_FILE}" "variables"
[ -f "${DEVICE_TEMPLATE_ENV_FILE}" ] && dump_file "${DEVICE_TEMPLATE_ENV_FILE}" "template_variables"
[ -f "${DEVICE_SECRET_TEMPLATE_ENV_FILE}" ] && dump_file "${DEVICE_SECRET_TEMPLATE_ENV_FILE}" "secret_template_variables"
[ -f "${DEVICE_CONFIG_FILE}" ] && dump_file "${DEVICE_CONFIG_FILE}" "config"
dump_file "${DEVICE_DIR}/config.orig" "config.orig"

# Dump the "files/" dir if present
if [ -d "${DEVICE_DIR}/files" ]; then
    find "${DEVICE_DIR}/files" -type f | sort | while read f; do
        dump_file "${f}" ${f#"${DEVICE_DIR}/files"}
    done
fi
