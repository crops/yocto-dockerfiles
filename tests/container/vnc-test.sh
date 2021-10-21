#!/bin/bash

# vnc-test.sh
#
# Copyright (C) 2016-2021 Intel Corporation
#
# SPDX-License-Identifier: GPL-2.0-only
#

set -e
set -x

if [ "${ENGINE_CMD}" = "" ]; then
    ENGINE_CMD="docker"
fi

# Pass in the image that was built for docker
image=$1
workdir=`mktemp -d --suffix=vnc`
SCRIPT_DIR=$(dirname $(readlink -f $0))
CONTAINER_SCRIPT=vnc-in-container-test.sh
cp $SCRIPT_DIR/$CONTAINER_SCRIPT $workdir

${ENGINE_CMD} run -t --rm -v $workdir:/workdir \
    --entrypoint=/workdir/$CONTAINER_SCRIPT --user=root  $image
rm $workdir -rf
