# Network Layout

This is repo is meant to keep configuration for my home network.
Eventually I'd like to have it fully reproducible, versioned and managed only by code.

For now, for main router and AP router there are:

- [x] reproducible OpenWRT builds using custom scripting (mostly wrappers over OpenWRT's build system) in `build`
- [x] reproducible OpenWRT configuration, via `uci-defaults`
- [x] basic monitoring enabled
- [x] zero-touch bootstrap after the OpenWRT is flashed on a device
- [x] automated obtaining of certificates for routers' UI via Let's Encrypt
- [ ] bit-to-bit reproducible builds (there seem to be some issues with `libgcc` or `libgcc1` being required, only the name differs though)
- [x] Internet connectivity monitoring (ping Google and Cloudflare DNS and check if they respond)
- [x] Secure connectivity from outside the network via Wireguard

## Setup

### ISP router

Nothing special, 300M fiber connection, no bridge-mode, so bridge-over-dmz is used.
DDNS is set up on this level to point to an owned domain.

### Main router

Currently Raspberry Pi 4 (8GB RAM variant) is used as a main router.
It's paired with a TP-Link UE300 USB-Ethernet adapter (RTL8153), that's used for WAN connection.
An unmanaged switch is put in front of the Ethernet port, just to expand the ports count.

Running slightly customized OpenWRT (mostly packages preinstalled in the image + built-in config), look in `build` directory for details.

### Main AP

TP-Link RE605x exposes the LAN in AP mode.

### AP Router

ASUS RT-AX53U running openwrt, used only for the purpose of broadcasting main router's guest network over WI-FI.
Most likely some new tasks will be found for it in the future.

Running slightly customized OpenWRT (mostly packages preinstalled in the image + built-in config), look in `build` directory for details.

## Architecture

There are three "LAN" interfaces at the moment and a single "WAN":

1. WAN to connect ISP router (192.168.240.1, no AP) with a main router (192.168.240.99), that's put in a DMZ
2. LAN (192.168.1.1/24) exposed over Ethernet switch + wirelessly on both 2.4 and 5 GHz using the main AP
3. Guest network (192.168.2.1/24) exposed using AP router, completely isolated from LAN both directions
4. VPN (10.200.200.1/24) managed by main router

All of the real logic is done on the main router's level, including DNS and DHCP.
AP Router and Main AP serve as dummy APs.

External DNS queries are encrypted with HTTPS (DoH) and resolved by Cloudflare and Google servers.

A picture is worth more than a thousand words:
![Network Overview](docs/diagrams/created/network_overview.png?raw=true "Network Overview")

## Tips

### RE605x

If you use a password's manager to input the password on login page, you have to manually remove and reinput one of the characters.
Otherwise the login page doesn't detect that password has been filled and fails with a "Can't log in" message.
