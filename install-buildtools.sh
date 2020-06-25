#! /bin/bash

set -e

if [ "$(uname -m)" = "aarch64" ]; then
    BUILDTOOLS="aarch64-buildtools-extended-nativesdk-standalone-3.1.3.sh"
    SHA256SUM="ea342902dafb53f6f7b7df948263a086b116cb0944051e930a8c1edae3ea3e0d"
elif [ "$(uname -m)" = "x86_64" ]; then
    BUILDTOOLS="x86_64-buildtools-extended-nativesdk-standalone-3.1.3.sh"
    SHA256SUM="809de42e33b86d964621752e914883077aeef7da4fe8c7f188669e222e739256"
else
    echo "Unsupported architecture, can't install buildtools."
    exit 1
fi


wget https://downloads.yoctoproject.org/releases/yocto/yocto-3.1.3/buildtools/${BUILDTOOLS}

echo "${SHA256SUM} ${BUILDTOOLS}" > SHA256SUMS
sha256sum -c SHA256SUMS
rm SHA256SUMS

bash ${BUILDTOOLS} -y
rm ${BUILDTOOLS}
