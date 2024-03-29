#!/usr/bin/env bash
# This file is sourced, not run

function unpack_image() {
	# $1 -> .img.gz to unpack
	# $2 -> directory to output

	local file="$1"
	local dir="$2"

	mkdir -p "${dir}"
	pushd "${dir}" >&2 || exit 1

	7z x "${file}" -O. >&2

	find . -type f \( -name "kernel" -o -name "root" \) | sort | while read -r f; do
		echoerr "Unpacking ${f}"
		binwalk -Me "${f}" >&2
		rm "${f}"
	done

	popd >/dev/null || exit 1
}
