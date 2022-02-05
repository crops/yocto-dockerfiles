#!/bin/bash

# vnc-in-container.sh
#
# Copyright (C) 2016-2021 Intel Corporation
#
# SPDX-License-Identifier: GPL-2.0-only
#

set -e
set -x
# this runs inside the container. Returns 0 on success.
ls -al /workdir
# make a vncuser from the skeleton
useradd -m --skel=/etc/vncskel vncuser

# install xdpyinfo in the distros that are missing it
if grep -q Alma /etc/*release; then
    dnf -y install xorg-x11-utils
elif grep -q CentOS /etc/*release; then
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
Xvnc -rfbport 5900 :1 >& /home/vncuser/.vnc/Xvnc.log &
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
