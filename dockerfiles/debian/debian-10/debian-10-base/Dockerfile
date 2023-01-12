# debian-10-base
# Copyright (C) 2015-2021 Intel Corporation
#
# SPDX-License-Identifier: GPL-2.0-only
#

FROM debian:10

RUN apt-get clean && \
    apt-get update && \
    DEBIAN_FRONTEND=noninteractive apt-get install -y \
        gawk \
        wget \
        git-core \
        subversion \
        diffstat \
        unzip \
        sysstat \
        texinfo \
        build-essential \
        chrpath \
        socat \
	python \
        python3 \
	python3-pip \
        cpio \
        xz-utils \
        locales \
        screen \
        tmux \
        sudo \
        fluxbox \
        procps \
        tightvncserver \
        lz4 \
        zstd && \
    cp -af /etc/skel/ /etc/vncskel/ && \
    echo "export DISPLAY=1" >>/etc/vncskel/.bashrc && \
    mkdir  /etc/vncskel/.vnc && \
    echo "" | vncpasswd -f > /etc/vncskel/.vnc/passwd && \
    chmod 0600 /etc/vncskel/.vnc/passwd && \
    useradd -U -m yoctouser && \
    echo 'en_US.UTF-8 UTF-8' >> /etc/locale.gen && locale-gen

# Install buildtools. The original reason this was needed was due to a
# sanity check for make 4.1.2, but now we're relying on python-3.8 so instead
# of -make, install all the buildtools

COPY install-buildtools.sh /
RUN bash /install-buildtools.sh && \
    rm /install-buildtools.sh

COPY build-install-dumb-init.sh install-multilib.sh /
RUN  bash /build-install-dumb-init.sh && \
     rm /build-install-dumb-init.sh && \
     bash /install-multilib.sh && \
     rm /install-multilib.sh && \
     apt-get clean

USER yoctouser
WORKDIR /home/yoctouser
CMD /bin/bash
