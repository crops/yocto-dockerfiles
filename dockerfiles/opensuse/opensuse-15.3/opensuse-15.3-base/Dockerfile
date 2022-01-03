# opensuse-15.3-base
# Copyright (C) 2015-2020 Intel Corporation
# Copyright (C) 2022 Konsulko Group
#
# SPDX-License-Identifier: GPL-2.0-only
##

FROM opensuse/leap:15.3

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
                   python \
                   python-curses \
                   python-xml \
                   python3 \
		   python3-Jinja2 \
                   python3-curses \
		   python3-pexpect \
		   python3-pip \
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

# Install buildtools-make. The original reason this was needed was due to a
# sanity check for make 4.2.1
COPY install-buildtools-make.sh /
RUN bash /install-buildtools-make.sh && \
    rm /install-buildtools-make.sh

COPY build-install-dumb-init.sh /
RUN  bash /build-install-dumb-init.sh && \
     rm /build-install-dumb-init.sh

USER yoctouser
WORKDIR /home/yoctouser
CMD /bin/bash
