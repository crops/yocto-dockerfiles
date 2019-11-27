# centos-7-base
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

FROM centos:centos7

RUN yum -y install epel-release && \
    yum -y update && \
    yum -y install \
        gawk \
        make \
        wget \
        tar \
        bzip2 \
        gzip \
        python \
        python3 \
        unzip \
        perl \
        patch \
        diffutils \
        diffstat \
        git \
        subversion \
        cpp \
        gcc \
        gcc-c++ \
        glibc-devel \
        texinfo \
        chrpath \
        socat \
        perl-Data-Dumper \
        perl-Text-ParseWords \
        perl-Thread-Queue \
        file \
        tigervnc-server \
        xz \
        screen \
        tmux \
        sudo \
        which && \
    cp -af /etc/skel/ /etc/vncskel/ && \
    echo "export DISPLAY=1" >>/etc/vncskel/.bashrc && \
    mkdir  /etc/vncskel/.vnc && \
    echo "" | vncpasswd -f > /etc/vncskel/.vnc/passwd && \
    chmod 0600 /etc/vncskel/.vnc/passwd && \
    groupadd -g 1000 yoctouser && \
    useradd -u 1000 -g yoctouser -m yoctouser

# Install the buildtools-tarball so tar is a new enough version to satisy the
# 1.28 requirment added by the 2c7624c17e43f9215cf7dcebf7258d28711bc3ce commit
# to poky.
RUN  wget http://downloads.yoctoproject.org/releases/yocto/yocto-3.0/buildtools/x86_64-buildtools-nativesdk-standalone-3.0.sh || exit 1 && \
     echo "c2a077fa1be15d94bf9385a8d478a146 x86_64-buildtools-nativesdk-standalone-3.0.sh" > x86_64-buildtools-nativesdk-standalone-3.0.sh.md5sum || exit 1 && \
     md5sum -c x86_64-buildtools-nativesdk-standalone-3.0.sh.md5sum || exit 1 && \
     chmod +x x86_64-buildtools-nativesdk-standalone-3.0.sh || exit 1 && \
     ./x86_64-buildtools-nativesdk-standalone-3.0.sh || exit 1

COPY build-install-dumb-init.sh /
RUN  bash build-install-dumb-init.sh && \
     rm /build-install-dumb-init.sh && \
     yum -y clean all

#COPY vncserver.patch /
#RUN  patch /usr/bin/vncserver /vncserver.patch && \
#     rm /vncserver.patch

USER yoctouser
WORKDIR /home/yoctouser
CMD /bin/bash
