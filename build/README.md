# Build repo
This directory defines step-by-step instructions that can be followed to obtain a reproduced image of OpenWRT with applied changes

General instructions from upstream can be viewed [here](https://openwrt.org/docs/guide-developer/toolchain/use-buildsystem)

Base tag of the build: `v22.03.2`
For each device supported you can look in `<device>` directory to see the config and relevant README with changes.
You can run `diff <device>/config <device>/config.orig` to compare the differences between upstream and current .config
Custom .config available for:
1. rpi4b

The idea is to:
1. first apply the upstream config.orig
2. Put our custom changes on top (concatenate the files)
3. Run `make defconfig` to expand the diffconfigs into proper full .config

Some warnings about overriding values is expected, as that's what we're doing with custom `.config`.

After the base config is applied and you do some changes with `make menuconfig` or similar, it's possible to easily obtain the custom diffconfig by running `./scripts/generate-diffconfig.sh <DEVICE> > <DEVICE>/config` and inspecting the changes.

It takes about 15G of space to build everything.

## Build Environment
To get best results, build a debian based environment, Dockerfile for which is kept in `docker-setup` directory.
The image is as similar to the official build env as possible, as it's based on it.

To obtain the env, simply run (from the `docker-setup` dir, can be obtained by running `scripts/setup-image.sh`):
```
docker build -t openwrt-builder .
```

Additionally there is provided a wrapper `scripts/run.sh`, which takes a command to run in the dockerized build env as an argument.
In the later paragraphs, when you see a command prefixed with `scripts/run.sh` you can remove it, if you'd prefer to build using your own env.

For easier access it might be worth to add the `scripts` directory to your path like so:
```
export PATH="$PATH:$PWD/scripts"
```

This way you can just prefix calls with `run.sh`, instead of a full path.

## Sources
For misc reasons, the `openwrt` repo can't be added as a submodule.

To obtain it, simply run (`scripts/clone.sh`):
```
git clone git://git.openwrt.org/openwrt/openwrt.git
cd openwrt
git checkout v22.03.2
```

You also need to update the feeds in builddir, to do so run (`scripts/update-feeds.sh`):
```
cd openwrt
../scripts/run.sh ./scripts/feeds update -a
../scripts/run.sh ./scripts/feeds install -a
```

## Build
`.config` that should be used during the build is kept in the same directory as this README.
To include it in the build, simply copy it over to `openwrt` repo (`scripts/copy-config.sh <device>`):
Note that `<device>/config` path does not have a dot in filename, while the one in `openwrt` has.
Make sure that you copy the file as `.config`.
```
cp <device>/config openwrt/.config
```

It's advised to first download required sources for the build (especially if you're considering multi-core build), from the `openwrt` directory (`scripts/build-download-sources.sh`):
```
../scripts/run.sh make download -j$(nproc)
```

To run the actual build, cd to `openwrt` directory and issue (`scripts/build-compile.sh`):
```
../scripts/run.sh make -j$(nproc)
```

You can choose how many cores you want to run during the build

Optionally, you can run `scripts/end-to-end-build.sh <device>` to run all the steps (fetch the code, copy the config, download sources, build the image).
This is not recommended for interactive development, as many steps are run necessarily.
It's fine to just obtain the final image though, e.g. in CI context.

## Output
The final image will land in `openwrt/bin/targets/...` directory.

## Tips
If there's an error during the compilation, you can run make with additional `V=s` flag.
It might also be a good idea to run with `-j1`, so it's easier to see the error.
