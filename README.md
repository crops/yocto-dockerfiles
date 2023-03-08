# yocto-docker

macOS compatible version of crops/yocto-dockerfiles. Currently has been only tested on Ubuntu-22.04. To build ubuntu-22.04-base and ubuntu-22.04-builder images, run following:
```
# Export REPO name. This will be the name of the built image.
# You can use crops/yocto if you want to override it
export REPO=ejaaskel/yocto
# Export the disto to be built. This should be one of the
# versioned distros in dockerfiles-folder. Only ubuntu-22.04
# has been tested by me.
export DISTRO_TO_BUILD=ubuntu-22.04
# Run the build script for a single image
./build_container.sh
```
