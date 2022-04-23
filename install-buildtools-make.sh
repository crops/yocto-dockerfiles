#! /bin/bash

# install-buildtools-make.sh
#
# Copyright (C) 2020-2021 Intel Corporation
# Copyright (C) 2022 Konsulko Group
#
# SPDX-License-Identifier: GPL-2.0-only
#
set -e

RELEASE="4.0"
if [ "$(uname -m)" = "aarch64" ]; then
    BUILDTOOLS="aarch64-buildtools-make-nativesdk-standalone-${RELEASE}.sh"
    SHA256SUM="a6b1cd89b7b5d8d7ea540c2d6c101ef84fd8c78a125e407b6b3ad8427f5a64f3"
elif [ "$(uname -m)" = "x86_64" ]; then
    BUILDTOOLS="x86_64-buildtools-make-nativesdk-standalone-${RELEASE}.sh"
    SHA256SUM="79ce0518e1b60cb854d3701350179f471a2a781ae695045ff13a62995923dbce"
else
    echo "Unsupported architecture, can't install buildtools-make."
    exit 1
fi

# FIXME: temporarily use pre-release URL
wget https://autobuilder.yocto.io/pub/non-release/20220413-28/buildtools/${BUILDTOOLS}
# wget https://downloads.yoctoproject.org/releases/yocto/yocto-${RELEASE}/buildtools/${BUILDTOOLS}

echo "${SHA256SUM} ${BUILDTOOLS}" > SHA256SUMS
sha256sum -c SHA256SUMS
rm SHA256SUMS

bash ${BUILDTOOLS} -y
rm ${BUILDTOOLS}
