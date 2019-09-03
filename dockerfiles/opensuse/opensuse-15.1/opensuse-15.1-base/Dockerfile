# opensuse-15.1-base
# Copyright (C) 2015-2019 Intel Corporation
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

FROM opensuse/leap:15.1

RUN zypper --non-interactive install python \
                   python3 \
                   gcc \
                   gcc-c++ \
                   git \
                   subversion \
                   chrpath \
                   make \
                   wget \
                   python-xml \
                   diffstat \
                   makeinfo \
                   python-curses \
                   patch \
                   socat \
                   tar \
                   glibc-locale \
                   python3-curses \
                   sudo  \
                   iproute2 \
                   net-tools \
                   xorg-x11-Xvnc \
                   gzip \
                   bzip2 && \
    cp -af /etc/skel/ /etc/vncskel/ && \
    echo "export DISPLAY=1" >>/etc/vncskel/.bashrc && \
    mkdir  /etc/vncskel/.vnc && \
    echo "" | vncpasswd -f > /etc/vncskel/.vnc/passwd && \
    chmod 0600 /etc/vncskel/.vnc/passwd && \
    useradd -U -m yoctouser

COPY build-install-dumb-init.sh /
RUN  bash /build-install-dumb-init.sh && \
     rm /build-install-dumb-init.sh

USER yoctouser
WORKDIR /home/yoctouser
CMD /bin/bash
