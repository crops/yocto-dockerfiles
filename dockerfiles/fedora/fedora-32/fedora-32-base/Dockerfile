# fedora-32-base
# Copyright (C) 2020 Intel Corporation
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

FROM fedora:32

RUN dnf -y update && \
    dnf -y install \
        bzip2 \
        ccache \
        chrpath \
        cpio \
        cpp \
        diffstat \
        diffutils \
        file \
        findutils \
        fluxbox \
        gawk \
        gcc \
        gcc-c++ \
        git \
        glibc-devel \
        glibc-langpack-en \
        gzip \
        hostname \
        make \
        patch \
        perl \
        perl-bignum \
        perl-Data-Dumper \
        perl-Text-ParseWords \
        perl-Thread-Queue \
        procps \
        python3 \
        python3-GitPython \
        python3-jinja2 \
        python3-pexpect \
        python3-pip \
        rpcgen \
        screen \
        SDL-devel \
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
        xterm \
        xz && \
    cp -af /etc/skel/ /etc/vncskel/ && \
    echo "export DISPLAY=1" >>/etc/vncskel/.bashrc && \
    mkdir  /etc/vncskel/.vnc && \
    echo "" | vncpasswd -f > /etc/vncskel/.vnc/passwd && \
    chmod 0600 /etc/vncskel/.vnc/passwd && \
    useradd -U -m yoctouser

COPY build-install-dumb-init.sh /
RUN  bash /build-install-dumb-init.sh && \
     rm /build-install-dumb-init.sh && \
     dnf -y clean all

USER yoctouser
WORKDIR /home/yoctouser
CMD /bin/bash
