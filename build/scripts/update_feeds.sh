#!/usr/bin/env bash
set -e

cd openwrt
../scripts/run.sh ./scripts/feeds update -a
../scripts/run.sh ./scripts/feeds install -a

