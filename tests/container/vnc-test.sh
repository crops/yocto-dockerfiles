#!/bin/bash

# vnc-test
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


# Pass in the image that was built for docker
image=$1
workdir=`mktemp -d --suffix=vnc`
SCRIPT_DIR=$(dirname $(readlink -f $0))
CONTAINER_SCRIPT=vnc-in-container-test.sh
cp $SCRIPT_DIR/$CONTAINER_SCRIPT $workdir

docker run -t --rm -v $workdir:/workdir \
    --entrypoint=/workdir/$CONTAINER_SCRIPT --user=root  $image
rm $workdir -rf
