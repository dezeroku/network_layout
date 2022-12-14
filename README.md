# Network Layout

This is repo is meant to keep details about home network configuration and common issues that may happen to it

## Setup

### ISP router

Nothing special, 300Mb fiber connection, no bridge-mode, so bridge-over-dmz is used.
DDNS is set up on this level to point to owned domain.

### Main router

Currently Raspberry Pi 4 (8GB RAM variant) is used as a main router.
It's paired with a TP-Link UE300 USB-Ethernet adapter (RTL8153), that's used for WAN connection.
An unmanaged switch is put in front of the Ethernet port, just to expand the ports count.

In use, there is a custom build (take a look in `build` directory with `rpi4b` config to compile it from source), with few additional packages installed.

### AP

TP-Link RE605x exposes the LAN in AP mode.

## Architecture

There are three interfaces at the moment:

1. WAN to connect ISP router (192.168.240.1, no AP) with a Main router (192.168.240.99), that's put in a DMZ
2. LAN (192.168.1.1/24) exposed over Ethernet switch + wirelessly on both 2.4 and 5 GHz on the AP
3. Guest network (192.168.2.1/24) exposed using main router's built-in AP (low range), completely isolated from LAN both directions

TODO: put an image here

## Tips

### RE605x

If you use a password's manager to input the password on login page, you have to manually remove and reinput one of the characters.
Otherwise the login page doesn't detect that password has been filled and fails with a "Can't log in" message.
