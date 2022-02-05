#! /bin/bash

# install-buildtools.sh
#
# Copyright (C) 2020-2021 Intel Corporation
# Copyright (C) 2022 Konsulko Group
#
# SPDX-License-Identifier: GPL-2.0-only
#
set -e

RELEASE_VERSION="3.4.1"

if [ "$(uname -m)" = "aarch64" ]; then
    BUILDTOOLS="aarch64-buildtools-extended-nativesdk-standalone-${RELEASE_VERSION}.sh"
    SHA256SUM="ed9fcf3f0236068421e8cca431118455ab0ebd3901274387bb6484bf0c512034"
elif [ "$(uname -m)" = "x86_64" ]; then
    BUILDTOOLS="x86_64-buildtools-extended-nativesdk-standalone-${RELEASE_VERSION}.sh"
    SHA256SUM="a441eed44f35512ea697faef270b9ab9ce6c280265207fabf36bf2bff6c89018"
else
    echo "Unsupported architecture, can't install buildtools."
    exit 1
fi


wget https://downloads.yoctoproject.org/releases/yocto/yocto-${RELEASE_VERSION}/buildtools/${BUILDTOOLS}

echo "${SHA256SUM} ${BUILDTOOLS}" > SHA256SUMS
sha256sum -c SHA256SUMS
rm SHA256SUMS

bash ${BUILDTOOLS} -y
rm ${BUILDTOOLS}
