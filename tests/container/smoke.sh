#!/bin/bash

# smoke.sh
#
# Copyright (C) 2016-2021 Intel Corporation
#
# SPDX-License-Identifier: GPL-2.0-only
#

set -e
set -x

echo $USER
id

if [ "${ENGINE_CMD}" = "" ]; then
    ENGINE_CMD="docker"
fi

# Pass in the image that was built for docker
image=$1
workdir=`mktemp -d --suffix=smoke`
pokydir=/workdir/poky
builddir=/workdir/build

# This is to guarantee yoctouser in the container has access to workdir
chmod -R 777 $workdir

# In each instance below where docker is started, the workdir is changed to one
# that should be accessible for the uid:gid specified. Otherwise starting the
# container may fail.

# Ensure dumb-init is installed. This is to try and catch if
# build-install-dumb-init.sh didn't work.
${ENGINE_CMD} run -t --rm --entrypoint=/bin/bash -u $(id -u):$(id -g) -w '/' $image -c 'ls /usr/bin/dumb-init'

# Try to build quilt-native which is small and fast to build.
docker volume create --name testvolume
docker run -it --rm -v testvolume:/workdir busybox chown -R $(id -u):$(id -g) /workdir
docker run -it --rm -v testvolume:/workdir alpine/git clone --depth 1 --branch master \
          git://git.yoctoproject.org/poky /workdir/poky
${ENGINE_CMD} run -t --rm -v testvolume:/workdir -u $(id -u):$(id -g) -w '/' $image --pokydir=$pokydir \
                  -b $builddir -t quilt-native

docker volume rm testvolume

# Since yoctouser in the container may create files that the travis user
# can't delete, run the container again to delete the files in the directory.
${ENGINE_CMD} run -t --rm -v $workdir:/workdir -u $(id -u):$(id -g) -w '/' --entrypoint=/bin/rm $image \
                  $builddir -rf

rm $workdir -rf
