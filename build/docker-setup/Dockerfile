# This Dockerfile is really inspired (basically copy-pasted) by the `docker/buildworker/Dockerfile` available in [OpenWRT buildbot repo](https://git.openwrt.org/?p=buildbot.git;a=summary)
# At the time of writing it was based on 85ffd9a27da104698b3ee433aaf0ffb0cb13504e hash

# debian 10
FROM        debian:10@sha256:fa8155031d12cd165c237e0b38688cade32912e990ffe21f9e31968d9a04da38

ARG         DEBIAN_FRONTEND=noninteractive
ARG         OPENWRT_VERSION=unknown

USER root

RUN \
	apt-get update && \
	apt-get install -y \
		build-essential \
		ccache \
		curl \
		gawk \
		gcc-multilib \
		genisoimage \
		git-core \
		gosu \
		libdw-dev \
		libelf-dev \
		libncurses5-dev \
		locales \
		pv \
		pwgen \
		python \
		python3 \
		python3-pip \
		qemu-utils \
		rsync \
		signify-openbsd \
		subversion \
		swig \
		unzip \
		wget && \
	apt-get clean && \
	localedef -i en_US -c -f UTF-8 -A /usr/share/locale/locale.alias en_US.UTF-8

ENV LANG=en_US.utf8

RUN \
    groupadd buildbot && \
    useradd \
	--create-home --home-dir /builder \
	--comment "OpenWrt buildbot" \
	--gid 1000 --uid 1000 --shell /bin/bash buildbot && \
    chown buildbot:buildbot /builder

USER buildbot
WORKDIR /builder
