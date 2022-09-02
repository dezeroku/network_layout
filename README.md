# Network Layout
This is repo is meant to keep details about home network configuration and common issues that may happen to it

## Setup
### ISP router
Nothing special, 300Mb fiber connection, no bridge-mode, so bridge-over-dmz is used.
DDNS is set up on this level to point to `***REMOVED***` domain.

### Main router
Currently Raspberry Pi 4 (8GB RAM variant) is used as a main router.
It's paired with a TP-Link UE300 USB-Ethernet adapter (RTL8153), that's used for WAN connection.
An unmanaged switch is put in front of the Ethernet port, just to expand the ports count.

In use, there is a custom build (take a look in `build` directory to compile it from source), with few additional packages installed:
1. `kmod-usb-net-rtl8152` (for Ethernet-USB adapter support, `modprobe r8152` if needed)
2. `irqbalance` (for better managing of interrupts, TODO: at the moment it requires a manual edit of `/etc/config/irqbalance`, `enabled` option has to be set to `1`, only then the service can be started). You need to either start the service manually or reboot the router
3. `adblock` and `luci-app-adblock` (for ad blocking :p). You need to either start the service manually or reboot the router. You also should change the `Download Utility` in `Services/Adblock` to `curl`.
4. `curl` as a prerequisite for `adblock` downloads
5. `tcpdump-mini` for generating `adblock`'s DNS reports
6. `luci-app-sqm` for SQM. Additional configuration required and listed below (this is set in `/etc/config/sqm`, but preferable way is to use web GUI):
```
option interface 'eth1'
option qdisc 'cake'
option script 'piece_of_cake.qos'
option download '850000'
option upload '850000'
option debug_logging '0'
option verbosity '5'
option enabled '1'
option linklayer 'ethernet'
option overhead '38'
option linklayer_advanced '1'
option tcMTU '2047'
option tcTSIZE '128'
option tcMPU '84'
option linklayer_adaptation_mechanism 'default'
```
Perform a reboot afterwards to apply the settings
7. `wireguard-tools` for VPN
8. `luci-app-wireguard` for better VPN integration
9. `nmap-full` for general debugging
10. `luci-app-https-dns-proxy` for DNS encryption

### AP
TP-Link RE605x exposes the LAN in AP mode.


## Architecture
There are three interfaces at the moment:
1. WAN to connect ISP router (192.168.240.1, no AP) with a Main router (192.168.240.99), that's put in a DMZ
2. LAN (192.168.1.1/24) exposed over Ethernet switch + wirelessly as `***REMOVED***` network on both 2.4 and 5 GHz on the AP
3. Guest network (192.168.2.1/24) exposed using main router's built-in AP (low range), completely isolated from LAN both directions

TODO: put an image here

## Tips
### RE605x
If you use a password's manager to input the password on login page, you have to manually remove and reinput one of the characters.
Otherwise the login page doesn't detect that password has been filled and fails with a "Can't log in" message.
