# centos-6.7-base
FROM centos:centos6.7

ADD http://downloads.yoctoproject.org/releases/yocto/yocto-2.0/buildtools/poky-glibc-x86_64-buildtools-tarball-core2-64-buildtools-nativesdk-standalone-2.0.sh /buildtools.sh

RUN yum -y update && \
    yum -y install \
        gawk \
        make \
        wget \
        tar \
        bzip2 \
        gzip \
        python \
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
        socat \
        perl-Data-Dumper \
        perl-Text-ParseWords \
        perl-Thread-Queue \
        SDL-devel \
        file \
        tigervnc-server \
        which && \
    yum -y clean all && \
    groupadd -g 1000 yoctouser && \
    useradd -u 1000 -g yoctouser -m yoctouser && \
    mkdir -p /home/yoctouser/.vnc && \
    echo "" | vncpasswd -f > /home/yoctouser/.vnc/passwd && \
    chown -R yoctouser:yoctouser /home/yoctouser/.vnc && \
    chmod 0600 /home/yoctouser/.vnc/passwd && \
    echo -e "/home/yoctouser/buildtools\ny\n" | bash /buildtools.sh && \
    echo '. /home/yoctouser/buildtools/environment-setup*' >> /home/yoctouser/.bashrc && \
    chown -R yoctouser:yoctouser /home/yoctouser && \
    rm -f /buildtools.sh

USER yoctouser
WORKDIR /home/yoctouser
CMD /bin/bash
