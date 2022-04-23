#!/bin/bash

# build-container.sh
#
# Copyright (C) 2016-2021 Intel Corporation
#
# SPDX-License-Identifier: GPL-2.0-only
#

set -e

# Allow the user to specify another command to use for building such as podman
if [ "${ENGINE_CMD}" = "" ]; then
    ENGINE_CMD="docker"
fi

# DISTRO_TO_BUILD is essentially the prefix to the "base" and "builder"
# directories you plan to use. i.e. "fedora-23" or "ubuntu-16.04"

# First build the base
TAG=$DISTRO_TO_BUILD-base
dockerdir=`find -name $TAG`
workdir=`mktemp --tmpdir -d tmp-$TAG.XXX`

cp -r $dockerdir $workdir
workdir=$workdir/$TAG

cp install-multilib.sh $workdir
cp build-install-dumb-init.sh $workdir
cp install-buildtools.sh $workdir
cp install-buildtools-make.sh $workdir
cd $workdir

baseimage=`grep FROM Dockerfile | sed -e 's/FROM //'`
${ENGINE_CMD} pull $baseimage

${ENGINE_CMD} build \
       --build-arg http_proxy=$http_proxy \
       --build-arg HTTP_PROXY=$http_proxy \
       --build-arg https_proxy=$https_proxy \
       --build-arg HTTPS_PROXY=$https_proxy \
       --build-arg no_proxy=$no_proxy \
       --build-arg NO_PROXY=$no_proxy \
       -t $REPO:$TAG .
rm $workdir -rf
cd -

# Now build the builder. We copy things to a temporary directory so that we
# can modify the Dockerfile to use whatever REPO is in the environment.
TAG=$DISTRO_TO_BUILD-builder
workdir=`mktemp --tmpdir -d tmp-$TAG.XXX`

# use the builder template to populate the distro specific Dockerfile
cp dockerfiles/templates/Dockerfile.builder $workdir/Dockerfile
cp distro-entry.sh $workdir
sed -i "s/DISTRO_TO_BUILD/$DISTRO_TO_BUILD/g" $workdir/Dockerfile

cp helpers/runbitbake.py $workdir
cd $workdir

# Replace the rewitt/yocto repo with the one from environment
sed -i -e "s#crops/yocto#$REPO#" Dockerfile

# Lastly build the image
${ENGINE_CMD} build \
       --build-arg http_proxy=$http_proxy \
       --build-arg HTTP_PROXY=$http_proxy \
       --build-arg https_proxy=$https_proxy \
       --build-arg HTTPS_PROXY=$https_proxy \
       --build-arg no_proxy=$no_proxy \
       --build-arg NO_PROXY=$no_proxy \
       -t $REPO:$TAG .
cd -

# base tests
ENGINE_CMD=${ENGINE_CMD}
    ./tests/container/vnc-test.sh $REPO:$DISTRO_TO_BUILD-base
# builder tests
ENGINE_CMD=${ENGINE_CMD}
    ./tests/container/smoke.sh $REPO:$DISTRO_TO_BUILD-builder

rm $workdir -rf
