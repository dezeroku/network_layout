#!/usr/bin/env bash
set -e

cd docker-setup/
docker build -t openwrt-builder .

