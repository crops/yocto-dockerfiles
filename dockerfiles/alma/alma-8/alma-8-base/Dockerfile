# alama-8-base
# Copyright (C) 2015-2020 Intel Corporation
# Copyright (C) 2022 Konsulko Group
#
# SPDX-License-Identifier: GPL-2.0-only
#

FROM almalinux:8

RUN dnf install -y 'dnf-command(config-manager)' && \
    dnf config-manager --set-enabled powertools && \
    dnf -y install epel-release && \
    dnf -y update && \
    dnf -y install \
        bzip2 \
        chrpath \
        cpio \
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
	lz4 \
        make \
        patch \
        perl \
        perl-Data-Dumper \
        perl-Text-ParseWords \
        perl-Thread-Queue \
        python3 \
	rpcgen \
        socat \
        subversion \
        sudo \
        tar \
        tigervnc-server \
        tmux \
        unzip \
        wget \
        which \
        xz \
	zstd && \
    cp -af /etc/skel/ /etc/vncskel/ && \
    echo "export DISPLAY=1" >>/etc/vncskel/.bashrc && \
    mkdir  /etc/vncskel/.vnc && \
    echo "" | vncpasswd -f > /etc/vncskel/.vnc/passwd && \
    chmod 0600 /etc/vncskel/.vnc/passwd && \
    groupadd -g 1000 yoctouser && \
    useradd -u 1000 -g yoctouser -m yoctouser

# Install buildtools-make. The original reason this was needed was due to a
# sanity check for make 4.1.2
COPY install-buildtools-make.sh /
RUN bash /install-buildtools-make.sh && \
    rm /install-buildtools-make.sh

COPY build-install-dumb-init.sh /
RUN  bash build-install-dumb-init.sh && \
     rm /build-install-dumb-init.sh && \
     dnf -y clean all

USER yoctouser
WORKDIR /home/yoctouser
CMD /bin/bash
