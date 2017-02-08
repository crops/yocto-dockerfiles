#!/bin/bash

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

PIDS=()
# some systems do not have enough tty's available to run all the
# dumbinit tests in parallel. If the tty tests are failing try
# setting SERIAL_BUILD=1
if [ "$SERIAL_BUILD" == "" ]; then
    SERIAL_BUILD=0
fi
trap cleanup SIGINT SIGTERM ERR
function cleanup () {
    # Since we're calling kill again on the entire process group make sure
    # to not recurse into cleanup() by disabling the trap on SIGTERM.
    trap - SIGTERM
    kill -- -$$

    exit 1
}

build_image() {
    OUTPUTDIR=$1
    REPO=$2
    DISTRO_TO_BUILD=$3
    TMPDIR=$OUTPUTDIR REPO=$REPO \
        DISTRO_TO_BUILD=$DISTRO_TO_BUILD \
        bash -c "$build_cont . >& \
                    $OUTPUTDIR/build.log || \
                    echo \"$DISTRO_TO_BUILD build failed\""
}

function build_images {
    PIDS=()
    localrepo=$2
    tmpdir=$(mktemp --tmpdir -d tmp-buildall.XXX)

    echo "Building REPO=$REPO in $tmpdir"

    for i in $1; do
        DISTRO_TO_BUILD=$(basename $i)
        OUTPUTDIR=$tmpdir/$DISTRO_TO_BUILD
        mkdir $OUTPUTDIR

        echo "Building $DISTRO_TO_BUILD"

        if [ $SERIAL_BUILD == "0" ]; then
            build_image $OUTPUTDIR $REPO $DISTRO_TO_BUILD &
        else
            build_image $OUTPUTDIR $REPO $DISTRO_TO_BUILD
        fi
        PIDS=( ${PIDS[@]} $! )
    done
}

function waitforimages {
    numpids=${#PIDS[@]}
    while [ $numpids -gt 0 ]; do
        echo "waiting for $numpids images to be built"
        wait -n
        if [ $? -ne 0 ]; then
            cleanup
        fi
        numpids=$((numpids-1))
    done
}


set -e

SCRIPTDIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"
cd $SCRIPTDIR

if [ "x" = "x$REPO" ]; then
    # Create a uid for the repo so we don't overwrite any user images
    REPO=$(uuidgen)-yocto-docker-test
fi

build_cont=`readlink -f ./build_container.sh`

DIRS=$(readlink -f $(dirname $(dirname $(find -path '*base/Dockerfile'))))
build_images "$DIRS"
waitforimages
