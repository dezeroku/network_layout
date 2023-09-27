# Initializing the build env

Simply run the below command:

```
vagrant up
```

# Building

Run `vagrant_build <CMD>` to sync the configuration and scripts from local env with remote and run the CMD provided

Few pointers:

```
./vagrant_build time DEVICE=<DEVICE> ./scripts/core/end-to-end-build
./vagrant_build time DEVICE=<DEVICE> SKIP_DOWNLOADS=true ./scripts/core/end-to-end-build
```

For convenience the `bin` directory of build directories will be synced back to your local machine to `outputs` directory.
Don't make any manual changes in `outputs` as they will get overridden by the `rsync` during copying.

You can also use `scp` or `rsync` to get the files back to your local machine.
For example:

```
# Obtain the ssh-config form the `vagrant-setup` dir
vagrant ssh-config > ssh-config

cd ..

# Get all the built stuff for rpi4b
rsync -e 'ssh -F ./vagrant-setup/ssh-config' -vr --mkpath --delete default:/home/vagrant/network_layout/build/builds/openwrt-rpi4b/bin/ ./outputs/rpi4b-bin

# Get only the images and checksums for rpi4b
rsync -e 'ssh -F ./vagrant-setup/ssh-config' -vmr --mkpath --delete --include="*/" --include="*.img.gz" --include="sha256sums" --exclude="*" default:/home/vagrant/network_layout/build/builds/openwrt-rpi4b/bin/ ./outputs/rpi4b-images

# Get all the built stuff for asus-rt-ax53u
rsync -e 'ssh -F ./vagrant-setup/ssh-config' -vmr --mkpath --delete default:/home/vagrant/network_layout/build/builds/openwrt-asus-rt-ax53u/bin/ ./outputs/asus-rt-ax53u-bin

# Get only the images and checksums for asus-rt-ax53u
rsync -e 'ssh -F ./vagrant-setup/ssh-config' -vmr --mkpath --delete --include="*/" --include="*.bin" --include="sha256sums" --exclude="*" default:/home/vagrant/network_layout/build/builds/openwrt-asus-rt-ax53u/bin/ ./outputs/asus-rt-ax53u-images
```

# Cleaning up

Run

```
vagrant destroy
```
