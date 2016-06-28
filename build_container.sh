#!/bin/bash

# runbitbake.py
#
# Copyright (C) 2016 Intel Corporation
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

cd $dockerdir
docker build -t $REPO:$TAG .
cd -

# Now build the builder. We copy things to a temporary directory so that we
# can modify the Dockerfile to use whatever REPO is in the environment.
TAG=$DISTRO_TO_BUILD-builder
dockerdir=`find -name $TAG`
workdir=`mktemp --tmpdir -d tmp-$TAG.XXX`

cp -r $dockerdir $workdir
workdir=$workdir/$TAG

cp helpers/runbitbake.py $workdir
cd $workdir

# Replace the rewitt/yocto repo with the one from environment
sed -i -e "s#crops/yocto#$REPO#" Dockerfile

# Lastly build the image
docker build -t $REPO:$TAG .
cd -

./tests/container/smoke.sh $REPO:$DISTRO_TO_BUILD-builder
