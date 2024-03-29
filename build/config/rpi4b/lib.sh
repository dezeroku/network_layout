#!/usr/bin/env bash
# This file is sourced, not run

function dirty_unpack_image() {
	# $1 -> .img.gz to unpack
	# $2 -> directory to output

	local file="$1"
	local dir="$2"

	local img && img="$(mktemp --suffix=.img)"

	# gunzip can be picky about trailing stuff, let's ignore it for now
	gunzip <"${file}" >"${img}" 2>/dev/null || true

	# Just hack out the unpacking, mounting does not seem to like the format of our images
	echoerr "Unpacking ${file}"
	mkdir -p "${dir}"

	# This is dirty
	# Don't fire me :/
	7z x "${img}" -O"${dir}" >/dev/null 2>/dev/null || true
	7z x "${dir}/0.fat" -O"${dir}" >/dev/null 2>/dev/null || true
	7z x "${dir}/1.img" -O"${dir}" >/dev/null 2>/dev/null || true

	rm "${dir}/0.fat"
	rm "${dir}/1.img"
}

function unpack_image() {
	echoerr "No unpack_image defined, falling back to dirty_unpack_image"
	dirty_unpack_image "$@"
}
