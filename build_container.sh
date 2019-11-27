#!/bin/bash

# runbitbake.py
#
# Copyright (C) 2016-2019 Intel Corporation
#
# This program is free software; you can redistribute it and/or modify
# it under the terms of the GNU General Public License version 2 as
# published by the Free Software Foundation.
#
# This program is distributed in the hope that it will be useful,
# but WITHOUT ANY WARRANTY; without even the implied warranty of
# MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
# GNU General Public License for more details.
#
# You should have received a copy of the GNU General Public License along
# with this program; if not, write to the Free Software Foundation, Inc.,
# 51 Franklin Street, Fifth Floor, Boston, MA 02110-1301 USA.

set -e

# DISTRO_TO_BUILD is essentially the prefix to the "base" and "builder"
# directories you plan to use. i.e. "fedora-23" or "ubuntu-14.04"

# First build the base
TAG=$DISTRO_TO_BUILD-base
dockerdir=`find -name $TAG`
workdir=`mktemp --tmpdir -d tmp-$TAG.XXX`

cp -r $dockerdir $workdir
workdir=$workdir/$TAG

cp build-install-dumb-init.sh $workdir
cd $workdir

baseimage=`grep FROM Dockerfile | sed -e 's/FROM //'`
docker pull $baseimage

docker build \
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
docker build \
       --build-arg http_proxy=$http_proxy \
       --build-arg HTTP_PROXY=$http_proxy \
       --build-arg https_proxy=$https_proxy \
       --build-arg HTTPS_PROXY=$https_proxy \
       --build-arg no_proxy=$no_proxy \
       --build-arg NO_PROXY=$no_proxy \
       -t $REPO:$TAG .
cd -

# base tests
./tests/container/vnc-test.sh $REPO:$DISTRO_TO_BUILD-base
# builder tests
./tests/container/smoke.sh $REPO:$DISTRO_TO_BUILD-builder

rm $workdir -rf
