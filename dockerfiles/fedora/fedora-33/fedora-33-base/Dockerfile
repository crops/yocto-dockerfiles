# fedora-33-base
# Copyright (C) 2021 Intel Corporation
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

FROM fedora:33

RUN dnf -y update && \
    dnf -y install \
	# These packages were copied straight from the Yocto Project reference
        # manual which is why they are not alphabetized 
        gawk \
        make \
        wget \
        tar \
        bzip2 \
        gzip \
        python3 \
        unzip \
        perl \
        patch \
        diffutils \
        diffstat \
        git \
        cpp \
        gcc \
        gcc-c++ \
        glibc-devel \
        texinfo \
        chrpath \
        ccache \
        perl-Data-Dumper \
        perl-Text-ParseWords \
        perl-Thread-Queue \
        perl-bignum \
        socat \
        python3-pexpect \
        findutils \
        which \
        file \
        cpio \
        python \
        python3-pip \
        xz \
        python3-GitPython \
        python3-jinja2 \
        SDL-devel \
        xterm \
        rpcgen \

        # These packages were added because of reasons such as fewer packages
        # being in the container image by default
        fluxbox \
        glibc-langpack-en \
        hostname \
        procps \
        python-unversioned-command \
        subversion \
        sudo \
        screen \
        tigervnc-server \
        tmux && \
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
