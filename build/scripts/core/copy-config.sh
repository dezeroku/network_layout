#!/usr/bin/env bash
set -e

SCRIPTS_DIR="$(readlink -f "$(dirname "$0")")/.."

# shellcheck source=build/scripts/common
. "${SCRIPTS_DIR}"/common
parse_env_args

cd "${BUILDDIR}"

# Copy the base upstream config, modifications and then expand
cat "${SCRIPTS_DIR}/../config/${DEVICE}/config.orig" >.config
if [[ ! "${REPRODUCE_UPSTREAM_BUILD}" == "true" ]]; then
	if [ -f "${DEVICE_CONFIG_FILE}" ]; then
		echoerr "Applying ${DEVICE_CONFIG_FILE}" on top of original .config
		cat "${DEVICE_CONFIG_FILE}" >>.config
	fi
else
	echoerr "Skipping custom .config because of REPRODUCE_UPSTREAM_BUILD=true"
fi

"${SCRIPTS_DIR}/core/run.sh" make defconfig

rm -rf "${BUILDDIR}/files"
if [[ ! "${REPRODUCE_UPSTREAM_BUILD}" == "true" ]]; then
	# Remove the custom files present and copy from config dir
	if [ -d "${SCRIPTS_DIR}/../config/${DEVICE}/files" ]; then
		echoerr "Copying custom files from ${SCRIPTS_DIR}/../config/${DEVICE}/files"
		cp -r "${SCRIPTS_DIR}/../config/${DEVICE}/files" "${BUILDDIR}/files"

		# Replace all the _TEMPLATE variables in files with values from env
		# All such values should come from ${DEVICE_TEMPLATE_ENV_FILE} file
		if [ -n "${DEVICE_TEMPLATE_ENV_FILE:-}" ]; then
			echoerr "Applying template-variables templating on top of ${BUILDDIR}/files"

			# This is done in such a convoluted way
			# to allow usage of "normal" variables in the e.g. UCI files
			# We only template the variables that we know for sure have to be templated

			# Find variables defined in template file and add dollar signs at the beginning
			template_variables=""
			while read -r var; do
				echo "${var}"
				template_variables="${template_variables} \$$(echo "${var}" | cut -d '=' -f1)"
			done <<<"$(env -i bash -c ". ${DEVICE_TEMPLATE_ENV_FILE} && env | grep '_TEMPLATE='")"

			echoerr "Templating with following variables: ${template_variables}"

			find "${BUILDDIR}/files" -type f | sort | while read file; do
				echoerr "Templating ${file}"
				TMPFILE="$(mktemp)"
				env -i bash -c ". ${DEVICE_TEMPLATE_ENV_FILE} && cat ${file} | envsubst '${template_variables}'" >"${TMPFILE}"
				mv "${TMPFILE}" "${file}"
			done

			# Sanity check for potentially missed _TEMPLATE variables definitions

			if grep -nr "_TEMPLATE" "${BUILDDIR}/files" >/dev/null; then
				missed="$(grep -nr "_TEMPLATE" "${BUILDDIR}/files")"

				while true; do
					echo
					echo "${missed}"
					echo "It seems there are variables ending with _TEMPLATE that weren't properly templated"
					read -p "Do you wish to continue the build? [Y/N]" yn
					case $yn in
					[Yy]*) break ;;
					[Nn]*)
						echo "Please fix usage of the _TEMPLATE variables and retry"
						exit 1
						;;
					*) echo "Please answer yes or no." ;;
					esac
				done
			fi
		fi
	fi
else
	echoerr "Skipping copying custom files because of REPRODUCE_UPSTREAM_BUILD=true"
fi
