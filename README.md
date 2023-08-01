# Network Layout

This repo is meant to keep configuration for my home network.
Eventually I'd like to have it fully reproducible, versioned and managed only by code.

What's covered already:

- [x] reproducible OpenWRT builds using custom scripting (mostly wrappers over OpenWRT's build system) in `build`
- [x] reproducible OpenWRT configuration, via `uci-defaults`
- [x] basic monitoring enabled
- [x] zero-touch bootstrap after the OpenWRT is flashed on a device
- [x] automated obtaining of certificates for routers' UI via Let's Encrypt
- [ ] bit-to-bit reproducible builds (there seem to be some issues with `libgcc` or `libgcc1` being required, only the name differs though)
- [x] Internet connectivity monitoring (ping Google and Cloudflare DNS and check if they respond)
- [x] Secure connectivity from outside the network via Wireguard
- [x] Encrypted DNS queries sent out to Cloudflare

## Architecture

There are three "LAN" interfaces at the moment and a single "WAN":

1. WAN to connect ISP router (192.168.240.1, no AP) with a main router (192.168.240.99), that's put in a DMZ
2. LAN (192.168.1.1/24) exposed over Ethernet switch + wirelessly on both 2.4 and 5 GHz using the main AP
3. Guest network (192.168.2.1/24) exposed using AP router, completely isolated from LAN both directions (except for `devserver`)
4. IOT network (192.168.3.1/24) exposed using AP router, completely isolated from LAN both directions (except for iotserver bridge, also called `homeserver`, whose configuration is defined [here](https://github.com/dezeroku/home_server))
5. VPN (10.200.200.1/24, wireguard) managed by main router

All of the real logic is done on the main router's level, including DNS and DHCP.
AP Router and Main AP serve as dummy APs.

External DNS queries are encrypted with HTTPS (DoH) and resolved by Cloudflare and Google servers.

A picture is worth more than a thousand words:
![Network Overview](docs/diagrams/created/network_overview.png?raw=true "Network Overview")

## Setup

### ISP router

Nothing special, 300M fiber connection, no bridge-mode, so bridge-over-dmz is used.
DDNS is set up on this level to point to an owned domain.

### Main router

| VLAN       | ETH0             | ETH1       | ETH2         |
| ---------- | ---------------- | ---------- | ------------ |
| 20 (guest) | -                |            | aprouter (t) |
| 30 (iot)   | -                |            | aprouter (t) |
| 99 (lan)   | LAN switch (u\*) |            | aprouter(t)  |
|            |                  | WAN router |              |

Currently Raspberry Pi 4 (8GB RAM variant) is used as a main router.
It's paired with two TP-Link UE300 USB-Ethernet adapters (RTL8153), one is used for WAN connection, the other for AP Router.
An unmanaged switch is put in front of the Ethernet port, just to expand the ports count.

Running slightly customized OpenWRT (mostly packages preinstalled in the image + built-in config), look in `build` directory for details.

### Main AP

TP-Link RE605x exposes the LAN in AP mode.

### AP Router

| VLAN       | WAN | LAN1           | LAN2          | LAN3           |
| ---------- | --- | -------------- | ------------- | -------------- |
| 20 (guest) |     | mainrouter (t) | devserver (u) |                |
| 30 (iot)   |     | mainrouter (t) |               | IOT switch (u) |
| 99 (lan)   |     | mainrouter (t) |               |                |

ASUS RT-AX53U running openwrt, used only for the purpose of broadcasting main router's guest network over WI-FI.
Most likely some new tasks will be found for it in the future.

Running slightly customized OpenWRT (mostly packages preinstalled in the image + built-in config), look in `build` directory for details.

## Tips

### RE605x

If you use a password manager to input the password on login page, you have to manually remove and reinput one of the characters.
Otherwise the login page doesn't detect that password has been filled and fails with a "Can't log in" message.
It's stupid, but it works.
