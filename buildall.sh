#!/bin/bash

PIDS=()

trap cleanup SIGINT SIGTERM ERR
function cleanup () {
	# Since we're calling kill again on the entire process group make sure
	# to not recurse into cleanup() by disabling the trap on SIGTERM.
	trap - SIGTERM
	kill -- -$$

	exit 1
}

function build_images {
	PIDS=()
	localrepo=$2
	tmpdir=$(mktemp --tmpdir -d tmp-buildall.XXX)

	echo "Building in $tmpdir"

	for i in $1; do
		IMAGETAG=$(basename $i)
		CONTEXTDIR=$tmpdir/$IMAGETAG

		mkdir $CONTEXTDIR
		cd $CONTEXTDIR

		# Replace the rewitt/yocto repo with the newly one meant for testing
		cp $i/Dockerfile .
		sed -i -e "s#rewitt/yocto#$2#" Dockerfile
		echo "Building $localrepo:$IMAGETAG"
		bash -c "docker build --force-rm -t $localrepo:$IMAGETAG . > \
			build.log || \
			echo \"$IMAGETAG build failed\" \
			tail -f build.log \
			echo -e \"\n\n\"" &
		PIDS=( ${PIDS[@]} $! )

		cd -
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

# Create a uid for the repo so we don't overwrite any images the user has
REPO=$(uuidgen)-yocto-docker-test

# Build the "base" images first
DIRS=$(readlink -f $(dirname $(find -path '*base/Dockerfile')))
build_images "$DIRS" $REPO
waitforimages

DIRS=$(readlink -f $(dirname $(find -path '*builder/Dockerfile')))
build_images "$DIRS" $REPO
waitforimages
