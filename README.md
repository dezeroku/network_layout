# Network Layout

This repository describes the configuration for my home network.

Build system used is defined in [openwrt_build_wrapper repository](https://github.com/dezeroku/openwrt_build_wrapper).

## General Overview

A picture is worth more than a thousand words:
![Network Overview](docs/diagrams/created/network_overview.png?raw=true "Network Overview")

What's covered:

- \[x\] reproducible OpenWRT builds using custom scripting (mostly wrappers over OpenWRT's build system) in `build`
- \[x\] reproducible OpenWRT configuration, via `uci-defaults` (with YAML based config)
- \[x\] basic monitoring enabled
- \[x\] zero-touch bootstrap after the OpenWRT is flashed on a device
- \[x\] automated obtaining of certificates for routers' UI via Let's Encrypt
- \[x\] Internet connectivity monitoring (ping Google and Cloudflare DNS and check if they respond)
- \[x\] Secure connectivity from outside the network via Wireguard
- \[x\] Encrypted DNS queries sent out to Cloudflare
- \[x\] DNS level ad-blocking
- \[x\] applying custom patches
- \[ \] bit-to-bit reproducible builds (there seem to be some issues with `libgcc` or `libgcc1` being required, only the name differs though)

## Interfaces

### ISP Router (WAN)

Allows the internet connectivity via ISP's router (a temporary measure before obtaining the proper ONT. Unfortunately the device has to be provided by ISP, custom ones won't work).

ISP's router spans the `192.168.240.1/24` network, main router is assigned the static IP of `192.168.240.99`.
Main router is put in the DMZ, as described in the [OpenWRT wiki guide](https://openwrt.org/docs/guide-user/network/wan/dmz-based-bridge-mode).

DDNS is set up on this device to point to a custom domain.

This part of the configuration is not covered by this repo.

### Main Router

| Interface  | CIDR            | Internet access | Clients can communicate |
| ---------- | --------------- | --------------- | ----------------------- |
| LAN        | 192.168.1.1/24  | yes             | yes                     |
| Guest      | 192.168.2.1/24  | yes             | no                      |
| IoT        | 192.168.3.1/24  | no              | no                      |
| Cluster    | 192.168.4.1/24  | yes             | yes                     |
| VPN Main   | 192.168.69.1/24 | yes             | yes                     |
| VPN Guest  | 192.168.70.1/24 | no              | yes                     |
| VPN Family | 192.168.71.1/24 | yes             | yes                     |

## Hardware Setup

### Main router

| VLAN         | ETH0  | ETH1       |
| ------------ | ----- | ---------- |
| 20 (guest)   | t     |            |
| 30 (iot)     | t     |            |
| 40 (cluster) | t     |            |
| 99 (lan)     | (t\*) |            |
|              |       | WAN router |

Currently Raspberry Pi 4 (8GB RAM variant) is used as a main router.
It's paired with TP-Link UE300 USB-Ethernet adapter (RTL8153), used for WAN.

It does all the heavy lifting in this setup:

- routing
- DNS
- DHCP
- DNS-level adblock
- [SQM](https://openwrt.org/docs/guide-user/network/traffic-shaping/sqm)

Look into [its config for more details](build/config/mainrouter/template-variables.yaml).

### Main switch

| VLAN         | LAN1 (mainrouter) | LAN2 (aprouter) | LAN3 | LAN4 | LAN5 | LAN6 | LAN7 | LAN8 |
| ------------ | ----------------- | --------------- | ---- | ---- | ---- | ---- | ---- | ---- |
| 20 (guest)   | t                 | t               |      |      |      |      |      |      |
| 30 (iot)     | t                 | t               |      |      |      |      |      |      |
| 40 (cluster) | t                 | t               |      |      |      |      |      | u    |
| 99 (lan)     | t                 | t               | u    | u    | u    | u    | u    |      |

Zyxel GS1900-8HP switching traffic with VLANs.

Look into [its config for more details](build/config/mainswitch/template-variables.yaml).

### AP Router

| VLAN         | WAN | LAN1           | LAN2 | LAN3 |
| ------------ | --- | -------------- | ---- | ---- |
| 20 (guest)   |     | mainrouter (t) |      |      |
| 30 (iot)     |     | mainrouter (t) |      |      |
| 40 (cluster) |     | mainrouter (t) |      |      |
| 99 (lan)     |     | mainrouter (t) |      |      |

ASUS RT-AX53U running openwrt, used as an AP for all the networks.

Look into [its config for more details](build/config/aprouter/template-variables.yaml).

## How to build?

Take a look at [openwrt_build_wrapper repository](https://github.com/dezeroku/openwrt_build_wrapper) for details.
General gist is to clone the repo with submodules (`git submodule update --init --recursive`) and run the build as follows:

1. `time ONLY_INITIALIZE_WORKSPACE=true DEVICE=<device> ./openwrt_build_wrapper/scripts/core/entrypoint`
2. `time SKIP_DOWNLOADS=true DEVICE=<device> ./openwrt_build_wrapper/scripts/core/entrypoint`
