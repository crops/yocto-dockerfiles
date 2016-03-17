# ubuntu-14.04-builder
FROM rewitt/yocto:ubuntu-14.04-base

USER yoctouser
COPY runbitbake.py /home/yoctouser/
WORKDIR /home/yoctouser
ENTRYPOINT ["/home/yoctouser/runbitbake.py"]
