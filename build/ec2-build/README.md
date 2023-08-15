# Finding the best value for money

Check the prices of spots that you're interested in many regions and change the `variables.tf` appropriately.

# Initializing the build env

Simply run the below commands:

```
tf init
tf apply
```

You may get some issues related to too low pricing, increase the `spot_price` then.

# Building

Run `ec2_build <CMD>` to sync the configuration and scripts from local env with remote and run the CMD provided

Few pointers:

```
./ec2_build time DEVICE=<DEVICE> ./scripts/core/end-to-end-build
./ec2_build time DEVICE=<DEVICE> SKIP_DOWNLOADS=true ./scripts/core/end-to-end-build
```

Remember to `scp` or `rsync` the built files back to your local machine!
For example:

```
# Get all the built stuff for rpi4b
rsync -vr --mkpath --delete ec2-user@$(terraform output -raw instance_public_dns):/home/ec2-user/network_layout/build/builds/openwrt-rpi4b/bin/ ./outputs/rpi4b-bin

# Get only the images and checksums for rpi4b
rsync -vmr --mkpath --delete --include="*/" --include="*.img.gz" --include="sha256sums" --exclude="*" ec2-user@$(terraform output -raw instance_public_dns):/home/ec2-user/network_layout/build/builds/openwrt-rpi4b/bin/ ./outputs/rpi4b-images

# Get all the built stuff for asus-rt-ax53u
rsync -vmr --mkpath --delete ec2-user@$(terraform output -raw instance_public_dns):/home/ec2-user/network_layout/build/builds/openwrt-asus-rt-ax53u/bin/ ./outputs/asus-rt-ax53u-bin

# Get only the images and checksums for asus-rt-ax53u
rsync -vmr --mkpath --delete --include="*/" --include="*.bin" --include="sha256sums" --exclude="*" ec2-user@$(terraform output -raw instance_public_dns):/home/ec2-user/network_layout/build/builds/openwrt-asus-rt-ax53u/bin/ ./outputs/asus-rt-ax53u-images
```

# Cleaning up (it's important!)

Run

```
tf destroy
```
