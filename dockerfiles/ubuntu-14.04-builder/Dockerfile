FROM rewitt/yocto:ubuntu-14.04-base

USER root
RUN apt-get update && \
    apt-get install -y \
        tightvncserver && \
    mkdir -p /home/yoctouser/.vnc && \
    echo "" | vncpasswd -f > /home/yoctouser/.vnc/passwd && \
    chown -R yoctouser:yoctouser /home/yoctouser/.vnc && \
    chmod 0600 /home/yoctouser/.vnc/passwd

USER yoctouser
COPY runbuild.py /home/yoctouser/
WORKDIR /home/yoctouser
ENTRYPOINT /home/yoctouser/runbuild.py
