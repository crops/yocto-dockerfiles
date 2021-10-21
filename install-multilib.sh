#!/bin/bash

# install-multilib.sh
#
# Copyright (C) 2020-2021 Intel Corporation
#
# SPDX-License-Identifier: GPL-2.0-only
#

# Don't try and install the multilib packages on arm64
if [ "$(uname -m)" = "x86_64" ]; then
    DEBIAN_FRONTEND=noninteractive apt-get install -y gcc-multilib g++-multilib
fi
