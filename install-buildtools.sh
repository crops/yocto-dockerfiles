#! /bin/bash

set -e

wget http://downloads.yoctoproject.org/releases/yocto/yocto-3.0/buildtools/x86_64-buildtools-nativesdk-standalone-3.0.sh

echo "c2a077fa1be15d94bf9385a8d478a146 x86_64-buildtools-nativesdk-standalone-3.0.sh" > x86_64-buildtools-nativesdk-standalone-3.0.sh.md5sum
md5sum -c x86_64-buildtools-nativesdk-standalone-3.0.sh.md5sum

chmod +x x86_64-buildtools-nativesdk-standalone-3.0.sh
./x86_64-buildtools-nativesdk-standalone-3.0.sh -y

rm x86_64-buildtools-nativesdk-standalone-3.0.sh
