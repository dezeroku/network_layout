#!/usr/bin/env bash

exec docker run -it -v $PWD:/builder openwrt-builder $@
