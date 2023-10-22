## Upstream .config

Base `.config` from upstream (generic ramips/mt7621): [config.orig](https://downloads.openwrt.org/releases/${OPENWRT_VERSION}/targets/ramips/mt7621/config.buildinfo)

## Changes compared to upstream

1. Build only for the asus-rt-ax53u specifically
2. Remove USB3 support (because of [this potential issue](https://openwrt.org/docs/guide-user/network/wifi/usb3.0-wifi-issues) and the device only having USB2.0)
3. Enable ccache during the builds
4. Use LLVM from host during the builds
5. Don't generate image builder, SDK, etc.
6. Remove `zyxel-bootconfig`
7. Change all kernel modules to be built-in

## Packages

1. `iperf3` for local network speedtesting
2. `iw-full` for WLAN runtime configuration if needed

## Tips

1. You can go to `files/etc/dropbear` and run the `generate_host_keys.sh` script, so the host keys stay the same when flashing new images
   This makes the process a little bit less annoying (less modifications to `~/.ssh/known_hosts` needed)
