#! /bin/bash

# install-buildtools-make.sh
#
# Copyright (C) 2020-2021 Intel Corporation
# Copyright (C) 2022 Konsulko Group
#
# SPDX-License-Identifier: GPL-2.0-only
#
set -e

RELEASE="4.1"
if [ "$(uname -m)" = "aarch64" ]; then
    BUILDTOOLS="aarch64-buildtools-make-nativesdk-standalone-${RELEASE}.sh"
    SHA256SUM="ed241869743ac795d1a988246953df5931f68c22108d6f86ebc485b773d28db4"
elif [ "$(uname -m)" = "x86_64" ]; then
    BUILDTOOLS="x86_64-buildtools-make-nativesdk-standalone-${RELEASE}.sh"
    SHA256SUM="d9cc8a4f76392e23f9b2854af78d460e99bb5e4cbb82de6ccca0f6be7506f652"
else
    echo "Unsupported architecture, can't install buildtools-make."
    exit 1
fi

wget https://downloads.yoctoproject.org/releases/yocto/yocto-${RELEASE}/buildtools/${BUILDTOOLS}

echo "${SHA256SUM} ${BUILDTOOLS}" > SHA256SUMS
sha256sum -c SHA256SUMS
rm SHA256SUMS

bash ${BUILDTOOLS} -y
rm ${BUILDTOOLS}
