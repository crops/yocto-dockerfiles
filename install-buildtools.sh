#! /bin/bash

# install-buildtools.sh
#
# Copyright (C) 2020-2021 Intel Corporation
#
# SPDX-License-Identifier: GPL-2.0-only
#
set -e

RELEASE="4.1"

ARCH="$(uname -m)"
case "${ARCH}" in
    aarch64|x86_64)
        ;;
    *)
        echo "Unsupported architecture '${ARCH}', can't install buildtools."
        exit 1
        ;;
esac

if [ $# -eq 0 ]; then
    BUILDTOOLS="${ARCH}-buildtools-nativesdk-standalone-${RELEASE}.sh"
else
    TYPE="${1}"
    case "${TYPE}" in
        docs|extended|make)
            ;;
        *)
            echo "Invalid buildtools type '${TYPE}'."
            exit 1
            ;;
    esac
    BUILDTOOLS="${ARCH}-buildtools-${TYPE}-nativesdk-standalone-${RELEASE}.sh"
fi


wget https://downloads.yoctoproject.org/releases/yocto/yocto-${RELEASE}/buildtools/${BUILDTOOLS}.sha256sum
wget https://downloads.yoctoproject.org/releases/yocto/yocto-${RELEASE}/buildtools/${BUILDTOOLS}

sha256sum -c ${BUILDTOOLS}.sha256sum
rm ${BUILDTOOLS}.sha256sum

bash ${BUILDTOOLS} -y
rm ${BUILDTOOLS}
