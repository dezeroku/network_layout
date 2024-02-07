#!/usr/bin/env bash

function unpack_image() {
	# $1 -> .img.gz to unpack
	# $2 -> directory to output

	local file="$1"
	local dir="$2"

	mkdir -p "${dir}"
	pushd "${dir}" >&2 || exit 1

	binwalk -Me "${file}"

	popd >/dev/null || exit 1
}
