# Build repo
This directory defines step-by-step instructions that can be followed to obtain a reproduced image of OpenWRT with applied changes

General instructions from upstream can be viewed [here](https://openwrt.org/docs/guide-developer/toolchain/use-buildsystem)

Base hash of the build: `1d4dea6d4f4d34914e4622809b8b4a7c2c35ab47`
Base `.config` from upstream [.config.orig](https://downloads.openwrt.org/releases/21.02.3/targets/bcm27xx/bcm2711/config.buildinfo)

It takes about 15G of space to build everything.

## Build Environment
To get best results, build a debian based environment, Dockerfile for which is kept in `docker-setup` directory.
The image is as similar to the official build env as possible, as it's based on it.

To obtain the env, simply run (from the `docker-setup` dir):
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
The `openwrt` repo in proper revision is added as a submodule in this directory.
To obtain it, simply run (`scripts/clone.sh`):
```
git clone git://git.openwrt.org/openwrt/openwrt.git
cd openwrt
git checkout 1d4dea6d4f4d34914e4622809b8b4a7c2c35ab47
```

You also need to update the feeds in builddir, to do so run (`scripts/update_feeds.sh`):
```
cd openwrt
../scripts/run.sh ./scripts/feeds update -a
../scripts/run.sh ./scripts/feeds install -a
```

## Build
`.config` that should be used during the build is kept in the same directory as this README.
To include it in the build, simply copy it over to `openwrt` repo:
```
cp <device>/config openwrt/.config
```

It's advised to first download required sources for the build (especially if you're considering multi-core build), from the `openwrt` directory:
```
../scripts/run.sh make download
```

To run the actual build, cd to `openwrt` directory and issue:
```
../scripts/run.sh make -j$(nproc)
```

You can choose how many cores you want to run during the build

## Output
The final image will land in `openwrt/bin/targets/...` directory.

## Tips
If there's an error during the compilation, you can run make with additional `V=s` flag.
It might also be a good idea to run with `-j1`, so it's easier to see the error.
