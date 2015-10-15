# ubuntu-14.04-base
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
        libsdl1.2-dev  \
        tightvncserver && \
    apt-get clean && \
    useradd -U -m yoctouser && \
    mkdir -p /home/yoctouser/.vnc && \
    echo "" | vncpasswd -f > /home/yoctouser/.vnc/passwd && \
    chown -R yoctouser:yoctouser /home/yoctouser/.vnc && \
    chmod 0600 /home/yoctouser/.vnc/passwd

USER yoctouser
WORKDIR /home/yoctouser
CMD /bin/bash
