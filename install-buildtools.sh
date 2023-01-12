#! /bin/bash

# install-buildtools.sh
#
# Copyright (C) 2020-2021 Intel Corporation
#
# SPDX-License-Identifier: GPL-2.0-only
#
set -e

RELEASE="4.1"
if [ "$(uname -m)" = "aarch64" ]; then
    BUILDTOOLS="aarch64-buildtools-extended-nativesdk-standalone-${RELEASE}.sh"
    SHA256SUM="d5c0dd3e43c62f0465a9335f450d9f5f6861e4b3d39b0f04174bd50e6861c96e"
elif [ "$(uname -m)" = "x86_64" ]; then
    BUILDTOOLS="x86_64-buildtools-extended-nativesdk-standalone-${RELEASE}.sh"
    SHA256SUM="d360ac01016c848f713d6dd7848f25d0a5319e96e2dd279ab37ffcbd7320dbbe"
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
