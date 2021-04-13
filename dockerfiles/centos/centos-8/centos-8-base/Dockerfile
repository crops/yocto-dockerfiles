# centos-8-base
# Copyright (C) 2015-2020 Intel Corporation
#
# SPDX-License-Identifier: GPL-2.0-only
#

FROM centos:centos8

RUN dnf install -y 'dnf-command(config-manager)' && \
    dnf config-manager --set-enabled powertools && \
    dnf -y install epel-release && \
    dnf -y update && \
    dnf -y install \
        bzip2 \
        chrpath \
        cpp \
        diffstat \
        diffutils \
        file \
        gawk \
        gcc \
        gcc-c++ \
        git \
        glibc-devel \
        glibc-langpack-en \
        gzip \
        make \
        patch \
        perl \
        perl-Data-Dumper \
        perl-Text-ParseWords \
        perl-Thread-Queue \
        python3 \
        rpcgen \
        screen \
        socat \
        subversion \
        sudo \
        tar \
        texinfo \
        tigervnc-server \
        tmux \
        unzip \
        wget \
        which \
        xz && \
    cp -af /etc/skel/ /etc/vncskel/ && \
    echo "export DISPLAY=1" >>/etc/vncskel/.bashrc && \
    mkdir  /etc/vncskel/.vnc && \
    echo "" | vncpasswd -f > /etc/vncskel/.vnc/passwd && \
    chmod 0600 /etc/vncskel/.vnc/passwd && \
    groupadd -g 1000 yoctouser && \
    useradd -u 1000 -g yoctouser -m yoctouser

COPY build-install-dumb-init.sh /
RUN  bash build-install-dumb-init.sh && \
     rm /build-install-dumb-init.sh && \
     dnf -y clean all

USER yoctouser
WORKDIR /home/yoctouser
CMD /bin/bash
