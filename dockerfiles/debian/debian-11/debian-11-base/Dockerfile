# debian-11-base
# Copyright (C) 2015-2021 Intel Corporation
#
# SPDX-License-Identifier: GPL-2.0-only
#

FROM debian:11

ARG TARGETPLATFORM

RUN apt-get clean && \
    apt-get update && \
    DEBIAN_FRONTEND=noninteractive apt-get install -y \
        build-essential \
        chrpath \
        cpio \
        diffstat \
        fluxbox \
        gawk \
        git-core \
        locales \
        lz4 \
        procps \
        python \
        python3 \
        python3-pip \
        python3-virtualenv \
        screen \
        socat \
        subversion \
        sudo \
        sysstat \
        texinfo \
        tightvncserver \
        tmux \
        unzip \
        wget \
        xz-utils \
        zstd && \
    case ${TARGETPLATFORM} in \
        "linux/amd64") \
            DEBIAN_FRONTEND=noninteractive apt-get install -y \
                gcc-multilib \
                g++-multilib \
            ;; \
    esac && \
    cp -af /etc/skel/ /etc/vncskel/ && \
    echo "export DISPLAY=1" >>/etc/vncskel/.bashrc && \
    mkdir  /etc/vncskel/.vnc && \
    echo "" | vncpasswd -f > /etc/vncskel/.vnc/passwd && \
    chmod 0600 /etc/vncskel/.vnc/passwd && \
    useradd -U -m yoctouser && \
    echo 'en_US.UTF-8 UTF-8' >> /etc/locale.gen && locale-gen

COPY build-install-dumb-init.sh  /
RUN  bash /build-install-dumb-init.sh && \
     rm /build-install-dumb-init.sh && \
     apt-get clean

USER yoctouser
WORKDIR /home/yoctouser
CMD /bin/bash
