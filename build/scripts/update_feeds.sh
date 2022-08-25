#!/usr/bin/env bash
set -e

cd openwrt
../run.sh ./scripts/feeds update -a
../run.sh ./scripts/feeds install -a

