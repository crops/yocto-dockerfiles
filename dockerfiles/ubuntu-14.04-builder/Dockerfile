# ubuntu-14.04-builder
FROM rewitt/yocto:ubuntu-14.04-base

USER yoctouser
COPY runbuild.py /home/yoctouser/
WORKDIR /home/yoctouser
ENTRYPOINT ["/home/yoctouser/runbuild.py"]
