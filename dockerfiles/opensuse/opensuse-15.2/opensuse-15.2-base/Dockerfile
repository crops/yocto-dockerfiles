# opensuse-15.2-base
# Copyright (C) 2015-2020 Intel Corporation
#
# SPDX-License-Identifier: GPL-2.0-only
##

FROM opensuse/leap:15.2

RUN zypper --non-interactive install python \
                   bzip2 \
                   chrpath \
                   diffstat \
                   gcc \
                   gcc-c++ \
                   git \
                   glibc-locale \
                   gzip \
                   iproute2 \
                   make \
                   makeinfo \
                   net-tools \
                   patch \
                   python-curses \
                   python-xml \
                   python3 \
                   python3-curses \
                   socat \
                   subversion \
                   sudo  \
                   tar \
                   wget \
                   xorg-x11-Xvnc && \
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
