FROM ubuntu:14.04

RUN apt-get update && \
    apt-get install -y \
        gawk \
        wget \
        git-core \
        diffstat \
        unzip \
        texinfo \
        gcc-multilib \
        build-essential \
        chrpath \
        socat \
        python \
        libsdl1.2-dev && \
    apt-get clean && \
    useradd -U -m yoctouser

USER yoctouser
WORKDIR /home/yoctouser
CMD /bin/bash
