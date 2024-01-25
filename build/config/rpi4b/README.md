## Upstream .config

Base `.config` from upstream (rpi4b): [config.orig](https://downloads.openwrt.org/releases/${OPENWRT_VERSION}/targets/bcm27xx/bcm2711/config.buildinfo)

## Packages

1. `kmod-usb-net-rtl8152` (for Ethernet-USB adapter support, built into kernel)
2. `irqbalance` (for better management of interrupts)
3. `adblock` and `luci-app-adblock` (for ad blocking :p). You need to either start the service manually or reboot the router. You also should change the `Download Utility` in `Services/Adblock` to `curl`.
4. `curl` as a prerequisite for `adblock` downloads
5. `tcpdump-mini` for generating `adblock`'s DNS reports
6. `luci-app-sqm` for SQM. `files/etc/uci-defaults/9950-sqm` contains the config for it.
7. `wireguard-tools` for VPN tooling
8. `luci-app-wireguard` for better VPN integration
9. `nmap-full` for general debugging
10. `luci-app-https-dns-proxy` for DNS encryption
11. `qrencode` for easier sharing of VPN configs
12. `iperf3` for local network speedtesting
13. `acme` for cert requesting
14. `luci-app-acme` for cert requesting
15. `acme-dnsapi` for cert requesting

## Tips

1. It seems that manual "reset" is required after the new sysupgrade is uploaded.
   Without it, there are some leftovers?
   A command like the one below solves the issue:

```
ssh root@192.168.1.1 "yes | firstboot && reboot" ; ping 192.168.1.1
```
