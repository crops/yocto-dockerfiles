#! /bin/bash

set -e

wget https://downloads.yoctoproject.org/releases/yocto/yocto-3.1/buildtools/x86_64-buildtools-extended-nativesdk-standalone-3.1.sh

echo "4fd00aee6a1e8d85920db8309ea10acb29cbfe9f411a4b127597aabf2013afd4  x86_64-buildtools-extended-nativesdk-standalone-3.1.sh" > SHA256SUMS
sha256sum -c SHA256SUMS
rm SHA256SUMS

bash x86_64-buildtools-extended-nativesdk-standalone-3.1.sh -y
rm x86_64-buildtools-extended-nativesdk-standalone-3.1.sh
