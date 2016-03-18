# opensuse-13.2-base
FROM opensuse:13.2

RUN zypper --non-interactive install python \
                   gcc \
                   gcc-c++ \
                   git \
                   chrpath \
                   make \
                   wget \
                   python-xml \
                   diffstat \
                   makeinfo \
                   python-curses \
                   patch \
                   socat \
                   tar \
                   libSDL-devel && \
    useradd -U -m yoctouser

USER yoctouser
WORKDIR /home/yoctouser
CMD /bin/bash
