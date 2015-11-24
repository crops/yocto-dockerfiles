# ubuntu-14.04-builder
FROM rewitt/yocto:ubuntu-14.04-base

USER yoctouser
COPY runtest.py /home/yoctouser/
COPY runbitbake.py /home/yoctouser/
WORKDIR /home/yoctouser
ENTRYPOINT ["/home/yoctouser/runtest.py"]
