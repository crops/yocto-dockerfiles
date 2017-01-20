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
set -x

echo $USER
id

# Pass in the image that was built for docker
image=$1
workdir=`mktemp -d --suffix=smoke`
pokydir=/workdir/poky
builddir=/workdir/build

# This is to guarantee yoctouser in the container has access to workdir
chmod -R 777 $workdir

# Try to build quilt-native which is small and fast to build.
git clone --depth 1 --branch master \
          git://git.yoctoproject.org/poky $workdir/poky
docker run -t --rm -v $workdir:/workdir $image --pokydir=$pokydir \
           -b $builddir -t quilt-native

# Since yoctouser in the container may create files that the travis user
# can't delete, run the container again to delete the files in the directory.
docker run -t --rm -v $workdir:/workdir --entrypoint=/bin/rm $image \
           $builddir -rf

rm $workdir -rf
