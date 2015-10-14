FROM fedora:22

RUN dnf -y install \
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
        ccache \
        perl-Data-Dumper \
        perl-Text-ParseWords \
        perl-Thread-Queue \
        socat \
        findutils \
        which \
        cpio \
        SDL-devel && \
    dnf -y clean all && \
    useradd -U -m yoctouser

USER yoctouser
WORKDIR /home/yoctouser
CMD /bin/bash
