#!/bin/bash

# install-multilib.sh
#
# Copyright (C) 2020 Intel Corporation
#
# This program is free software; you can redistribute it and/or modify
# it under the terms of the GNU General Public License version 2 as
# published by the Free Software Foundation.
#
# This program is distributed in the hope that it will be useful,
# but WITHOUT ANY WARRANTY; without even the implied warranty of
# MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
# GNU General Public License for more details.
#
# You should have received a copy of the GNU General Public License along
# with this program; if not, write to the Free Software Foundation, Inc.,
# 51 Franklin Street, Fifth Floor, Boston, MA 02110-1301 USA.

# Don't try and install the multilib packages on arm64
if [ "$(uname -m)" = "x86_64" ]; then
    DEBIAN_FRONTEND=noninteractive apt-get install -y gcc-multilib g++-multilib
fi
