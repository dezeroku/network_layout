#!/usr/bin/env bash
set -e

# Clone with full history to have git log in place

if [[ ! -d "openwrt" ]]; then
    git clone git://git.openwrt.org/openwrt/openwrt.git
else
    while true; do
    read -p "There is already an openwrt dir, do you wish to use it? [Y/N]" yn
    case $yn in
        [Yy]* ) break;;
        [Nn]* ) echo "Please remove it manually to avoid loss of work"; exit 1;;
        * ) echo "Please answer yes or no.";;
    esac
    done
fi

cd openwrt
git checkout v21.02.5
