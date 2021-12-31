#! /bin/bash

# install-buildtools.sh
#
# Copyright (C) 2020-2021 Intel Corporation
#
# SPDX-License-Identifier: GPL-2.0-only
#
set -e

if [ "$(uname -m)" = "aarch64" ]; then
    BUILDTOOLS="aarch64-buildtools-extended-nativesdk-standalone-3.1.13.sh"
    SHA256SUM="de63845b8d7d3bbd49ea96cd94be3df7ca6e935d0ab510d30c00fa35e3e5e6cd"
elif [ "$(uname -m)" = "x86_64" ]; then
    BUILDTOOLS="x86_64-buildtools-extended-nativesdk-standalone-3.1.13.sh"
    SHA256SUM="3f6a5e150de674d8098223ae1cfa26051b692d2ed04ce00ef247a836c36a0c41"
else
    echo "Unsupported architecture, can't install buildtools."
    exit 1
fi


wget https://downloads.yoctoproject.org/releases/yocto/yocto-3.1.13/buildtools/${BUILDTOOLS}

echo "${SHA256SUM} ${BUILDTOOLS}" > SHA256SUMS
sha256sum -c SHA256SUMS
rm SHA256SUMS

bash ${BUILDTOOLS} -y
rm ${BUILDTOOLS}
