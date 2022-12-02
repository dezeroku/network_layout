# Build repo

This directory defines step-by-step instructions that can be followed to obtain a reproduced image of OpenWRT with applied changes

General instructions from upstream can be viewed [here](https://openwrt.org/docs/guide-developer/toolchain/use-buildsystem)

Base tag of the build: `v22.03.2`
For each device supported you can look in `$DEVICE` directory to see the config and relevant README with changes.
Custom configurations are available for:

1. rpi4b

It takes about 15G of space to build everything in case of rpi4b.

## Per device config

1. `config.orig` - upstream .config fil
2. `config` (optional) - diffconfig with custom changes, applied on top of config.orig. Customisable with `DEVICE_CONFIG_FILE`
3. `files/` - directory of files that should be copied to the image as is
4. `variables` - file containing env variables that should be present during the build. Customisable with `DEVICE_ENV_FILE`

## Build Environment

To get best results, build a debian based environment, Dockerfile for which is kept in `docker-setup` directory.
The image is as similar to the official build env as possible, as it's based on it.

To obtain the env, simply run `scripts/core/setup-image.sh`

Additionally there is provided a wrapper `scripts/core/run.sh`, which takes a command to run in the dockerized build env as an argument.
For easier access it might be worth to add the `scripts/core/` directory to your path like so:

```
export PATH="$PATH:$PWD/scripts/core"
```

This way you can just prefix calls with `run.sh`, instead of a full path.

## Sources

Every buildable target has `variables` fine defining entries used later on in this chapter.
For the build to proceed you have to at least have `$DEVICE` exported in env or pass it as first argument to most of the scripts.
Variables supported:

1. `$DEVICE` - required, name of the supported device to build e.g. `rpi4b`
2. `$BUILDDIR` - optional, if not provided defaults to `repo-root/build/openwrt-$DEVICE`

There are few helper scripts that can be used to checkout the code and build final image.
If you're interested in details please read them or refer the link mentioned at the top of this README.

For misc reasons, the `openwrt` repo can't be added as a submodule.
To obtain it, simply run `scripts/clone.sh`

You also need to update the feeds in builddir, to do so run `scripts/update-feeds.sh`

## Build

Almost all of the scripts require `DEVICE` variable to be present in environment.

`.config` that should be used during the build is kept in device specific directory, e.g. `rpi4b`.

The idea is to:

1. first apply the upstream `config.orig`
2. Put our custom changes (`config`) on top (concatenate the files)
3. Run `make defconfig` to expand the diffconfigs into proper full .config

Some warnings about overriding values is expected, as that's what we're doing with custom `.config`.

After the base config is applied and you do some changes with `make menuconfig` or similar, it's possible to easily obtain the custom diffconfig by running `./scripts/core/generate-diffconfig.sh > $DEVICE/config` and inspecting the changes.

To do all of that run `scripts/core/copy-config.sh`

It's advised to first download required sources for the build (especially if you're considering multi-core build), from the `openwrt` directory with `scripts/core/build-download-sources.sh`

To run the actual build issue `scripts/core/build-compile.sh`

Optionally, you can run `scripts/core/end-to-end-build.sh` to run all the steps (fetch the code, copy the config, download sources, build the image).
This is not recommended for interactive development, as many steps are run when not necessarily needed.
It's fine to just obtain the final image though, e.g. in CI context.

## Output

The final image will land in `openwrt-$DEVICE/bin/targets/...` directory.

## Tips

If there's an error during the compilation, you can run make with additional `V=s` flag.
It might also be a good idea to run with `-j1`, so it's easier to see the error.

As `ccache` needs custom OpenWRT patches to work properly, setting it on system-level and then building `tools/ccache` can cause unexpected messups.
To resolve this problem, use `sccache` on system-host-level (e.g. to compile tools) and `ccache` internally in OpenWRT.
This is already handled in the Docker container.

## Comparing UCI configuration

You can build `uci` binary runnable on host with `scripts/utils/build-uci-host.sh`
The binary will be output as `uci-build/uci`.

For the sake of reproducibility (avoiding issues with glibc matching), also `uci-runner` docker image gets created.
The image has `uci` available as `/uci`.

Using `scripts/utils-rpi4b/get-uci-config.sh` script it's possible to retrieve the UCI default values from built image.
When such a default config is obtained, it's easy to calculate diff between the config currently in use on the router and the default.

`scripts/utils/diff-uci-configs.sh` allows you to calculate a diff showing entries that are present in one file (the one that's meant to land on your device) and not present in the second one (the one that's default).
Thanks to this mechanism you can keep only a list of entries that are custom to your config and not provided by default.
