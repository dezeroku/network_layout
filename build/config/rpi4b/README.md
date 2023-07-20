## Upstream .config

Base `.config` from upstream (rpi4b): [config.orig](https://downloads.openwrt.org/releases/${OPENWRT_VERSION}/targets/bcm27xx/bcm2711/config.buildinfo)

## Packages

1. `kmod-usb-net-rtl8152` (for Ethernet-USB adapter support, built into kernel)
2. `irqbalance` (for better management of interrupts)
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
11. `qrencode` for easier sharing of VPN configs
12. `iperf3` for local network speedtesting
13. `acme` for cert requesting
14. `luci-app-acme` for cert requesting
15. `acme-dnsapi` for cert requesting

## Tips

1. It seems that manual "reset" is required after the new sysupgrade is uploaded.
   Without it, there are some leftovers?
2. 512MiB SD card is required to flash the generated image (because of the partition sizes)
