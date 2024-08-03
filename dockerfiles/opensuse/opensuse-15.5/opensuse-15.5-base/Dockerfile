# opensuse-15.5-base
# Copyright (C) 2015-2020 Intel Corporation
# Copyright (C) 2022-2024 Konsulko Group
#
# SPDX-License-Identifier: GPL-2.0-only
##

FROM opensuse/leap:15.5

# Keep these in alphabetical order, as sorted by vim :sort
RUN zypper --non-interactive install \
                   bzip2 \
                   chrpath \
                   diffstat \
                   gcc \
                   gcc-c++ \
                   git \
                   glibc-locale \
                   gzip \
                   iproute2 \
                   libSDL-devel \
                   lz4 \
                   make \
                   makeinfo \
                   net-tools \
                   patch \
                   python3 \
                   python3-Jinja2 \
                   python3-curses \
                   python3-pexpect \
                   python3-pip \
                   python3-virtualenv \
                   rpcgen \
                   socat \
                   subversion \
                   sudo \
                   tar \
                   wget \
                   xorg-x11-Xvnc \
                   xz \
                   zstd && \
    cp -af /etc/skel/ /etc/vncskel/ && \
    echo "export DISPLAY=1" >>/etc/vncskel/.bashrc && \
    mkdir  /etc/vncskel/.vnc && \
    echo "" | vncpasswd -f > /etc/vncskel/.vnc/passwd && \
    chmod 0600 /etc/vncskel/.vnc/passwd && \
    useradd -U -m yoctouser

# Install buildtools. The original reason this was needed was due to a
# sanity check for make 4.1.2, but now we're relying on python-3.8 so instead
# of -make, install all the buildtools

COPY install-buildtools.sh /
RUN bash /install-buildtools.sh && \
    rm /install-buildtools.sh

COPY build-install-dumb-init.sh /
RUN  bash /build-install-dumb-init.sh && \
     rm /build-install-dumb-init.sh

USER yoctouser
WORKDIR /home/yoctouser
CMD /bin/bash
