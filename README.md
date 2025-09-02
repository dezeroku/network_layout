# Network Layout

This repository describes the configuration for my home network.

Build system used is defined in [openwrt_build_wrapper repository](https://github.com/dezeroku/openwrt_build_wrapper).

## General Overview

A picture is worth more than a thousand words:
![Network Overview](docs/diagrams/created/network_overview.svg?raw=true "Network Overview")

What's covered:

- \[x\] reproducible OpenWRT builds using custom scripting (mostly wrappers over OpenWRT's build system) in [openwrt_build_wrapper](https://github.com/dezeroku/openwrt_build_wrapper) repo
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

### ISP ONT (WAN)

Allows the internet connectivity via ISP.

### Main Router

| Interface  | CIDR            | Internet access | Clients can communicate |
| ---------- | --------------- | --------------- | ----------------------- |
| LAN        | 192.168.1.1/24  | yes             | yes                     |
| Guest      | 192.168.2.1/24  | yes             | no                      |
| IoT        | 192.168.3.1/24  | no              | no                      |
| IoT Int    | 192.168.5.1/24  | yes             | no                      |
| Cluster    | 192.168.4.1/24  | yes             | yes                     |
| VPN Main   | 192.168.69.1/24 | yes             | yes                     |
| VPN Guest  | 192.168.70.1/24 | no              | yes                     |
| VPN Family | 192.168.71.1/24 | yes             | yes                     |

## Hardware Setup

### Main router

| VLAN         | ETH0 (labswitch) | ETH1 (mainswitch) |
| ------------ | ---------------- | ----------------- |
| 20 (guest)   | t                | t                 |
| 30 (iot)     | t                | t                 |
| 31 (iot_int) | t                | t                 |
| 40 (cluster) | t                | t                 |
| 90 (wan)     |                  | t                 |
| 99 (lan)     | (t\*)            | t                 |

Currently Raspberry Pi 4 (8GB RAM variant) is used as a main router.
It's paired with TP-Link UE300 USB-Ethernet adapter (RTL8153), used for mainswitch connection.

It does all the heavy lifting in this setup:

- routing
- DNS
- DHCP
- DNS-level adblock
- [SQM](https://openwrt.org/docs/guide-user/network/traffic-shaping/sqm)

Look into [its config for more details](config/mainrouter/template-variables.yaml).

### Main switch

| VLAN         | LAN1 (mainrouter) | LAN2 (WAN) | LAN3 | LAN4 | LAN5 | LAN6 | LAN7 | LAN8 |
| ------------ | ----------------- | ---------- | ---- | ---- | ---- | ---- | ---- | ---- |
| 20 (guest)   | t                 |            |      |      |      |      |      |      |
| 30 (iot)     | t                 |            |      |      |      |      |      |      |
| 31 (iot_int) | t                 |            |      |      |      |      |      |      |
| 40 (cluster) | t                 |            |      |      |      |      |      |      |
| 90 (wan)     | t                 | u          |      |      |      |      |      |      |
| 99 (lan)     | t                 |            | u    | u    | u    | u    | u    | u    |

Netgear GS108T-300PES switching traffic with VLANs, located in the central infra cross point.

Look into [its config for more details](config/mainswitch/template-variables.yaml).

### Lab switch

| VLAN         | LAN1 (mainrouter) | LAN2 (aprouter) | LAN3 | LAN4 | LAN5 | LAN6 (fradio-server) | LAN7 | LAN8 |
| ------------ | ----------------- | --------------- | ---- | ---- | ---- | -------------------- | ---- | ---- |
| 20 (guest)   | t                 | t               |      |      |      |                      |      |      |
| 30 (iot)     | t                 | t               |      |      |      | u                    |      |      |
| 31 (iot_int) | t                 | t               |      |      |      |                      |      |      |
| 40 (cluster) | t                 | t               |      |      |      |                      |      | u    |
| 99 (lan)     | t                 | t               | u    | u    | u    |                      | u    |      |

Zyxel GS1900-8 switching traffic with VLANs, located in the lab rack.

Look into [its config for more details](config/labswitch/template-variables.yaml).

### AP Router

| VLAN         | WAN | LAN1           | LAN2 | LAN3 |
| ------------ | --- | -------------- | ---- | ---- |
| 20 (guest)   |     | mainrouter (t) |      |      |
| 30 (iot)     |     | mainrouter (t) |      |      |
| 31 (iot_int) |     | mainrouter (t) |      |      |
| 40 (cluster) |     | mainrouter (t) |      |      |
| 99 (lan)     |     | mainrouter (t) |      |      |

ASUS RT-AX53U, used as an AP for all the networks.

Look into [its config for more details](config/aprouter/template-variables.yaml).

## How to build?

Take a look at [openwrt_build_wrapper repository](https://github.com/dezeroku/openwrt_build_wrapper) for details.
General gist is to clone the repo with submodules (`git submodule update --init --recursive`) and run the build as follows:

1. `time DEVICE=<device> ONLY_INITIALIZE_WORKSPACE=true ./openwrt_build_wrapper/scripts/core/entrypoint`
2. `time DEVICE=<device> SKIP_DOWNLOADS=true ./openwrt_build_wrapper/scripts/core/entrypoint`
