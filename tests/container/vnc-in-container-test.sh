#!/bin/bash

# vnc-script
#
# Copyright (C) 2016 Intel Corporation
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

set -e
set -x
# this runs inside the container. Returns 0 on success.
ls -al /workdir
# make a vncuser from the skeleton
useradd -m --skel=/etc/vncskel vncuser

# install xdpyinfo in the distros that are missing it
if grep -q CentOS /etc/*release; then
    yum -y install xorg-x11-utils
elif grep -q Fedora /etc/*release; then
    dnf -y install xorg-x11-utils
elif grep -q Ubuntu /etc/*release || grep -q Debian /etc/*release; then
    # Ubuntu/debian brings in xdpyinfo by default
    true;
elif grep -q openSUSE /etc/*release; then
    zypper --non-interactive install xdpyinfo
else
    exit 1
fi

###
### This runs each of the following commands as the user
### vncuser.  Note, variables from 1 line will not be available
### for the next.
###
exec sudo -H -u vncuser /bin/bash - <<EOF
# start the server
vncserver -rfbport 5900 -name YOCTO :1
sleep 2

if grep Listening  /home/vncuser/.vnc/*.log | grep 5900 ; then
echo "port established"
else
echo "port NOT established"
exit 1
fi
DISPLAY=:1 xdpyinfo | grep "number of screens"
if DISPLAY=:1 xdpyinfo | egrep -q "number of screens" ; then
echo "xdpyinfo shows screens established";
else
echo "xdpyinfo shows screens NOT established";
exit 1
fi
if grep DISPLAY /home/vncuser/.bashrc; then
echo "DISPLAY set in bashrc"
else
echo "DISPLAY NOT set in bashrc"
exit 1
fi
EOF
